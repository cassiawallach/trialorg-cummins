/** 
* @Class Name: dbu_Integration_ESNValidation    
* @Description      
- Constructor:  
* @Main Author: Saikomal Kattamudi    
* @Last Modified: 03/11/2020       
* @Open Points      /   
*/

public   class  dbu_Integration_ESNValidation {

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
            
            
            CSS_Integration_Details__c conDetails = CSS_Integration_Details__c.getValues('dbu_ESNSearch_AccessToken');
            
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
    
    public static dbu_ESNValidationResponse getEsnResult(string esn,string partnumber){
        
        string accessToken;
        dbu_ESNValidationResponse lstParsed = new dbu_ESNValidationResponse();
        HttpRequest req = new HttpRequest();
        Map<String, Object> mapData = new Map<String, Object>();
        Http http = new Http();
        string client_id;
        string client_secret;
        string resource;
        string methodType;
        string endPointURL;
        String request=esn+''+partnumber;
        string mSec;
        try{
                        
            CSS_Integration_Details__c conDetails = CSS_Integration_Details__c.getValues('dbu_ESNValidation');
            methodType = conDetails.Method_Type__c;
            accessToken = getAccessToken();
            string x ='https://api-ue-stgnf4-aw-ex.cummins.com/pcc/v1/catalogs/parts/compatibility?esn=79971431&partNo=2871960';
            
            endPointURL =conDetails.End_Point__c+esn +'&'+'partNo='+partnumber;
            
            req.setHeader('Authorization','Bearer '+accessToken);
            req.setMethod(methodType);
            req.setTimeout(120000);
            req.setEndpoint(endPointURL);
            HttpResponse res = new HttpResponse();
            Long reqTime = DateTime.now().getTime();
            res = http.send(req);
            Long respTime = DateTime.now().getTime();
            long milliSeconds = respTime-reqTime ;
            mSec='***TIME::' +string.ValueOf(milliSeconds)+ ':: TIME***';
            if(res.getStatusCode() == 200)
            {
                lstParsed = (dbu_ESNValidationResponse)JSON.deserialize(res.getbody(), dbu_ESNValidationResponse.class);
               dbu_Integration_Error_Log.createErrorLog(res.getStatusCode(),mSec,request,res.getBody(),'ESN Validation','Success');
                system.debug('responseBody-->'+res.getBody());
            }        
            else
            {
                dbu_Integration_Error_Log.createErrorLog(res.getStatusCode(),mSec+res.getBody(),request,res.getBody(),'ESN Validation',res.getStatus());
            }             
            
        }
        catch(exception e){
            dbu_Integration_Error_Log.createErrorLog(null,mSec+e.getMessage(),'','','ESN Validation','Exception');
            system.debug('Exception Message'+e.getMessage()+''+'Exception line Number '+e.getLineNumber());
        }
        return lstParsed ;
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