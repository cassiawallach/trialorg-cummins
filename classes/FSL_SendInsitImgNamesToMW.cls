/*
@ Author Name: Dinesh Yadav
@ Created Date: Dec 2020
@ Purpose: Send INSITE image names to MW API and update related WO Insite recods based on response
@ Test Class: FSL_schBatchSendInsitImgNamesToMW_Test
@ Last Modified Date: 
@ CT3-237.
*/
public class FSL_SendInsitImgNamesToMW{
    public void SendInsitImgNamesToMW(List<WO_INSITE_Images__c> lstWOInsite){
        //Prepare request JSON
        FSL_MW_ReqWrapper MWReq = new FSL_MW_ReqWrapper();
    
        FSL_MW_ReqWrapper.Header headerDetails = new FSL_MW_ReqWrapper.Header();                               
        FSL_MW_ReqWrapper.Sender senderDetails = new FSL_MW_ReqWrapper.Sender();
        senderDetails.ServiceName = 'ECMimages';
        senderDetails.SenderID = 'GuidanzWeb';
        
        headerDetails.Sender = senderDetails;

        FSL_MW_ReqWrapper.Target targetDetails = new FSL_MW_ReqWrapper.Target();            
        targetDetails.TargetID = 'AzureFiles';           
        headerDetails.Target = targetDetails;
        
        MWReq.Header = headerDetails;
        
        FSL_MW_ReqWrapper.DataArea DTA = new FSL_MW_ReqWrapper.DataArea();
        List<String> lstStrImages = new List<String>();
        for(WO_INSITE_Images__c objInsite : lstWOInsite){
            if(string.isNotBlank(objInsite.Eif_Before_Image__c)){
                lstStrImages.add(objInsite.Eif_Before_Image__c);
            }
            
            if(string.isNotBlank(objInsite.Eif_After_Image__c)){
                lstStrImages.add(objInsite.Eif_After_Image__c);
            }
            
            if(string.isNotBlank(objInsite.Csv_Before_Image__c)){
                lstStrImages.add(objInsite.Csv_Before_Image__c);
            }
            
            if(string.isNotBlank(objInsite.Csv_After_Image__c)){
                lstStrImages.add(objInsite.Csv_After_Image__c);
            }           
        }
        
        DTA.Images = lstStrImages;

        MWReq.DataArea = DTA;
        system.debug('MWReq :: '+MWReq);
        
        //---- Send request to MW for token generate
        string endpointURL='';
        CSS_Integration_Details__c conDetails = new CSS_Integration_Details__c();
        conDetails = CSS_getConnnectionDetails.getConnection('FSL_Mule_INSITEImages');   
        endpointURL = conDetails.End_Point__c;

        CG_OP_OAGWrapper accessTokenOPWrap=null;
        if(!Test.isRunningTest()){
            accessTokenOPWrap =  CG_WS_Mule.getAccessToken(conDetails.AuthEnv__c,'FSL_Mule_INSITEImages');     
        }else{
            accessTokenOPWrap=new CG_OP_OAGWrapper();
        }
        //--------- Send request for 'Send INSITE image names to MW API'
        
        
        String jsonReqBody = '';
        HttpRequest req1 = new HttpRequest();
        
        system.debug('MWReq>>>>:'+MWReq);
        
        if(MWReq != null){
            jsonReqBody = JSON.serialize(MWReq).replace('null','');
        }
        system.debug('jsonReqBody>>>>:'+jsonReqBody);
        
        try{
            String access_token = accessTokenOPWrap.accessToken;                
            req1.setHeader('Authorization','Bearer '+access_token);
            req1.setHeader('Content-Type','application/json; charset=UTF-8');
            req1.setHeader('client_id',conDetails.Username__c);
            req1.setHeader('client_secret',conDetails.Passcode__c);
            
            conDetails.Method_Type__c = 'POST';//Added New
            conDetails.Timeout__c = 120000;//Added New
            Integer timeOut = conDetails.Timeout__c.intValue();
            req1.setTimeout(timeOut);
            
            req1.setMethod('POST');
            System.debug('endPointURL Wo Comment '+endPointURL);
            req1.setEndpoint(endPointURL);
            req1.setBody(jsonReqBody); 
            
            if(Test.isRunningTest()){
                conDetails.Username__c=conDetails.Username__c==null? '4546545456454545444545':conDetails.Username__c;
                conDetails.Passcode__c=conDetails.Passcode__c==null? '54654564564654655454564565':conDetails.Passcode__c;
            }
            
            System.debug('Username >>> :: '+conDetails.Username__c);
            system.debug('req1 :: '+req1);
            system.debug('req1 body>>>>>>'+req1.getBody());
            system.debug('req1 header>>>>>>>.>>>'+req1.getHeader('Authorization'));
            //Sending request and mapping the response 
            Http http1 = new Http();
            //startDt = System.now();
            HttpResponse httpRes1 = new HttpResponse();
            if(!Test.isRunningTest()) {
                httpRes1 = http1.send(req1);
            }
            System.debug('httpRes1 '+httpRes1);
            System.debug('Status Code >>> :: '+httpRes1.getStatusCode());
            system.debug('Response Body >>>'+httpRes1.getbody());
        
            if(httpRes1.getStatusCode() != 200){
            //    FSL_ApplicationLogger.insertFSLIntegrationErrorLog(jsonReqBody,String.valueOf(httpRes1.getbody()),'ANVL','Failure','First','Mule','Guidanz');
            }
            
            
            string jSONRequestBody = httpRes1.getBody();
            
            if(Test.isRunningTest()){
                jSONRequestBody  = '{ "Header": { "Status": "SUCCESS" }, "DataArea": { "Images": [{"FileName": "I-20190421-111230469-EA2C1D72.eif", "Exists": "Yes", "LastModifiedDateTime": "2019-04-21T12:52:31.000" },'+
                                   '{"FileName": "I-20191002-111230700-EB2C1D01.csv","Exists": "Yes","LastModifiedDateTime": "2019-04-21T12:52:31.000" }]}}';
            }
            
            FSL_MW_ResWrapper wprObj = (FSL_MW_ResWrapper)JSON.deserializeStrict(jSONRequestBody,FSL_MW_ResWrapper.class); 
            system.debug('wprObj :: '+wprObj);
            system.debug('wprObj.Header  :: '+wprObj.Header ); //&& wprObj.Header.Status =='SUCCESS'
            if(wprObj.Header != null ){
                if(wprObj.DataArea != null){
                    if(wprObj.DataArea.Images !=null && wprObj.DataArea.Images.size() > 0 ){
                        //update WO_INSITE_Images__c object data
                        List<WO_INSITE_Images__c> lstUpdWOInsite = new List<WO_INSITE_Images__c>();
                        map<string, FSL_MW_ResWrapper.Images> mapImageNameToImages = new map<string, FSL_MW_ResWrapper.Images>();
                        for(FSL_MW_ResWrapper.Images objClsImg : wprObj.DataArea.Images){
                            mapImageNameToImages.put(objClsImg.FileName, objClsImg);
                        }
                        
                        for(WO_INSITE_Images__c objInsite : lstWOInsite){
                            Boolean check = false;
                            
                            if(string.isNotBlank(objInsite.Eif_Before_Image__c)){
                                if(mapImageNameToImages.get(objInsite.Eif_Before_Image__c) != null){
                                    FSL_MW_ResWrapper.Images objImage = mapImageNameToImages.get(objInsite.Eif_Before_Image__c);
                                    objInsite.Eif_Before_Image_Present__c = objImage.Exists;
                                    if(string.isNotBlank(objImage.LastModifiedDateTime)){
                                        String strDate=objImage.LastModifiedDateTime;
                                        strDate = strDate.replace('T',' ');
                                        Datetime dt = Datetime.valueOf(strDate);
                                        system.debug('LastModifiedDateTime '+dt);
                                        objInsite.Eif_Before_Image_ModifiedDate_Time__c = dt;
                                    }
                                    check = true;
                                }
                            }
                            
                            if(string.isNotBlank(objInsite.Eif_After_Image__c)){
                                if(mapImageNameToImages.get(objInsite.Eif_After_Image__c) != null){
                                    FSL_MW_ResWrapper.Images objImage = mapImageNameToImages.get(objInsite.Eif_After_Image__c);
                                    objInsite.Eif_After_Image_Present__c = objImage.Exists;
                                    if(string.isNotBlank(objImage.LastModifiedDateTime)){
                                        String strDate=objImage.LastModifiedDateTime;
                                        strDate = strDate.replace('T',' ');
                                        Datetime dt = Datetime.valueOf(strDate);
                                        system.debug('LastModifiedDateTime '+dt);
                                        objInsite.Eif_After_Image_ModifiedDate_Time__c = dt;
                                    }
                                    check = true;
                                }
                            }
                            
                            if(string.isNotBlank(objInsite.Csv_Before_Image__c)){
                                if(mapImageNameToImages.get(objInsite.Csv_Before_Image__c) != null){
                                    FSL_MW_ResWrapper.Images objImage = mapImageNameToImages.get(objInsite.Csv_Before_Image__c);
                                    objInsite.Csv_Before_Image_present__c = objImage.Exists;
                                    if(string.isNotBlank(objImage.LastModifiedDateTime)){
                                        String strDate=objImage.LastModifiedDateTime;
                                        strDate = strDate.replace('T',' ');
                                        Datetime dt = Datetime.valueOf(strDate);
                                        system.debug('LastModifiedDateTime '+dt);
                                        objInsite.Csv_Before_Image_ModifiedDate_Time__c = dt;
                                    }
                                    check = true;
                                }
                            }
                            
                            if(string.isNotBlank(objInsite.Csv_After_Image__c)){
                                if(mapImageNameToImages.get(objInsite.Csv_After_Image__c) != null){
                                    FSL_MW_ResWrapper.Images objImage = mapImageNameToImages.get(objInsite.Csv_After_Image__c);
                                    objInsite.Csv_After_Image_present__c = objImage.Exists;
                                    if(string.isNotBlank(objImage.LastModifiedDateTime)){
                                        String strDate=objImage.LastModifiedDateTime;
                                        strDate = strDate.replace('T',' ');
                                        Datetime dt = Datetime.valueOf(strDate);
                                        system.debug('LastModifiedDateTime '+dt);
                                        objInsite.Csv_After_Image_ModifiedDate_Time__c = dt;
                                    }
                                    check = true;
                                }
                            }   
                            
                            if(check == true)
                                lstUpdWOInsite.add(objInsite);
                        }
                        
                        //update WO_INSITE_Images__c
                        if(lstUpdWOInsite != null && lstUpdWOInsite.size() > 0)
                            update lstUpdWOInsite;
                    }               
                }
            }
        }
        catch(Exception e){
            system.debug('** error '+e.getMessage());
        }
        
    }   

}