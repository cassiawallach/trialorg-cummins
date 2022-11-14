/*--**********************************************************************
Name:dbu_Integration_ProductImages
Copyright Â© 2020  Cummins
======================================================
======================================================
Purpose:                                                            
-------  
We are using this Class to get the images for every product
======================================================
======================================================
History                                                            
-------                                                            
VERSION       AUTHOR                 DATE               DETAIL                                 
1.0 -     Saikomal Kattamudi      02/12/2020      INITIAL DEVELOPMENT
1.1 -     Harish Gadiyaram		  05/14/2021      CSSN-3095,Replacing PCC with Akamai URL Image Changes
************************************************************************/

public Without Sharing class dbu_Integration_ProductImages {
    @AuraEnabled(cacheable=true)
    public static string getAccessToken(){
        
        HttpRequest req = new HttpRequest();
        
        Http http = new Http();
        
        string client_id;
        
        string client_secret;
        
        string resource;
        
        string methodType;
        
        string endPointURL;
        
        string accessToken;
        try{
            
            
            CSS_Integration_Details__c conDetails = CSS_Integration_Details__c.getValues('dbu_ProductImageAccessToen');
            
            endPointURL = conDetails.End_Point__c;
            
            
            client_id = conDetails.Key__c;
            
            client_secret = conDetails.Passcode__c  ;
            
            resource = conDetails.Resource__c;
            
            methodType =conDetails.Method_Type__c;
            
            req.setEndpoint(endPointURL);
            
            req.setMethod(methodType);
            
            req.setHeader('Content-Type','application/json');
            
            req.setBody('{"client_id":"'+client_id+'","client_secret":"'+client_secret+'","resource":"'+resource+'"}');
            
            HttpResponse res = new HttpResponse();
            
            res = http.send(req);
            TokenResponse tokenResp = (TokenResponse)JSON.deserialize(res.getBody(), TokenResponse.class);
            
            accessToken = tokenResp.access_token;
            
            system.debug('accessToken '+accessToken);
            
        }
        
        catch(exception e){
            
            system.debug('Exception Message'+e.getMessage()+''+'Exception line Number '+e.getLineNumber());
            
        }
        
        return accessToken;
        
    }
    @AuraEnabled(cacheable=true)
    public static String getProductImages(string imageURL){
        system.debug('imageURL'+imageURL);
        
        List<Attachment> attList;
        
        //--Added by Mukesh (21-12-2020)--
        List<Document> docList = [SELECT Id,Name FROM Document WHERE Name =: imageURL];
        System.debug('docList.size===='+docList.size());
        if(docList.size() > 0){
            String orgId = UserInfo.getOrganizationId();
            String domainName = System.Label.dbu_domainName;
            String returnImageUrl = domainName+'--c.documentforce.com/servlet/servlet.ImageServer?id='+docList[0].Id+'&oid='+orgId;
            System.debug('returnImageUrl==='+returnImageUrl);
          return returnImageUrl;
        }
       /* List<dbu_ImageData__c> imgDataList = [SELECT Id,Img_URL__c FROM dbu_ImageData__c WHERE Img_URL__c =: imageURL];
        if(imgDataList.size() > 0){
            attList = [SELECT Id,ParentId,Body FROM Attachment WHERE ParentId =:imgDataList[0].Id];
            if(attList.size() > 0){
                String rawData = attList[0].Body.toString();
                return rawData;
            }
        }*/
        //-----------------------------
        System.debug('====Go for api call=====');
        string accessToken;
        String responseBody;
        HttpRequest req = new HttpRequest();
        Http http = new Http();
        string client_id;
        string client_secret;
        string resource;
        string methodType;
        string endPointURL;
        string mSec;
        
        try{
            string serverName='PCC';
            endPointURL =imageURL;
            if(imageURL.contains(system.label.dbu_akamaiimageDomain)){
                /******* Added by Harish, CSSN-3095,to do Akamai callout to get image*************/
                ID nwId=Network.getNetworkId();
                string loginURL= Network.getLoginUrl(nwId);
                string referalURL ='';
                if(loginURL != null){
                    referalURL=loginURL.substring(0,loginURL.lastIndexOf('/')+1)+'s/';
                }  
                req.setMethod('GET');
                req.setHeader('Referer',referalURL);
                serverName='Akamai';
            }
            else{
                CSS_Integration_Details__c conDetails = CSS_Integration_Details__c.getValues('dbu_ProductImage');
                methodType = conDetails.Method_Type__c;
                accessToken = getAccessToken(); 
                endPointURL =imageURL;
                system.debug('endPointURL'+endPointURL);
                req.setHeader('Authorization','Bearer '+accessToken);
                req.setMethod(methodType);
            }
            req.setTimeout(120000);
            req.setEndpoint(endPointURL);
            HttpResponse res = new HttpResponse();
            Long reqTime = DateTime.now().getTime();
            res = http.send(req);
            Long respTime = DateTime.now().getTime();
            System.debug('StatusCode====='+res.getStatusCode());
            long milliSeconds = respTime-reqTime ;
            mSec='***TIME::' +string.ValueOf(milliSeconds)+ ':: TIME***';
            if(res.getStatusCode() == 200){
            createErrorLog(res.getStatusCode(),mSec,imageURL,'',serverName +' Image Service','Success');
            Blob blb = res.getBodyAsBlob();
            responseBody  = EncodingUtil.base64Encode(blb);
            
            //---calling future method--Added by Mukesh (21-12-2020)---
            insertImageData(imageURL,responseBody);
            //-------------------------------------------------------
            //String responseBody = res.getBody(); //Access Response body
            
            system.debug('responseBody'+responseBody);
                // return responseBody;
            }else{
                createErrorLog(res.getStatusCode(),mSec+res.getBody(),imageURL,'',serverName+' Image Service','Exception');
            }
           
           
            
        }
        catch(exception e){
            system.debug('Exception Message'+e.getMessage()+''+'Exception line Number '+e.getLineNumber());
             createErrorLog(null,'Exception Message'+e.getMessage()+''+'Exception line Number '+e.getLineNumber(),imageURL,'','PCC Image Service','Exception');
        }
        
        return responseBody;
    }  
    
    //---Storing image blob in Custom object--Added by Mukesh (24-12-2020)---
  /*  @future
    public static void insertImageData(String imgURL, String rawResponse){
        try{
             if(String.isNotBlank(rawResponse)){
                dbu_ImageData__c imgDataObj = new dbu_ImageData__c();
                imgDataObj.Img_URL__c = imgURL;
                if(imgDataObj != null){
                    insert imgDataObj;
                     System.debug('====Inserted Successfully ImageData Record===='+imgDataObj.id);
                    Attachment attachment = new Attachment();
                    attachment.Body = Blob.valueOf(rawResponse);
                    attachment.Name = String.valueOf('rawData.txt');
                    attachment.ParentId = imgDataObj.Id; 
                    insert attachment;
                    System.debug('====Inserted Successfully Attachment Record===='+attachment.id);
                }
            }
            
        }catch(exception e){
             System.debug('====Error on Inserting the record====');
             system.debug('Exception Message'+e.getMessage()+''+'Exception line Number '+e.getLineNumber());
        }
    }*/
    @future
    public static void insertImageData(String imgURL, String rawResponse){
        System.debug('Future method called');
        try{
            if(String.isNotBlank(rawResponse)){
                Document docObj = [SELECT Id, FolderId, Folder.Name FROM Document WHERE Folder.Name =: 'Public' LIMIT 1];
                System.debug('docObj-====='+docObj);
                Blob bdata = EncodingUtil.base64Decode(rawResponse);
                Document doc=new Document();
                doc.Body=bdata;
                doc.IsPublic = true;
                doc.FolderId= docObj.FolderId;
                doc.Name= imgURL;
                doc.Type='jpg';
                Insert doc; 
                System.debug('===Document Record Inserted Successfully===='+doc.Id);
            }
            
        }catch(exception e){
            System.debug('====Error on Inserting the record====');
            system.debug('Exception Message'+e.getMessage()+''+'Exception line Number '+e.getLineNumber());
        }
    }
     @future
    public static void createErrorLog(Integer ErrorCode,String ErrorDescription,String Request, String Response,String ServiceName,String Status){
        
        dbu_Integration_Error_Log.createErrorLog(ErrorCode,ErrorDescription,Request,Response,ServiceName,Status);
    } 
    public class TokenResponse {
        
        public String token_type;
        
        public String expires_in;
        
        public String ext_expires_in;
        
        public String expires_on;
        
        public String not_before;
        
        public String resource;
        
        public String access_token;
        
    }
}