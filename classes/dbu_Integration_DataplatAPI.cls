/**
* Author : Sri Lahari Gadiraju
* Created on 9 AUG 2021
* Description : This class will be used for DataPlateAPI Integration
*/
public class dbu_Integration_DataplatAPI {
    
 public static string getAccessToken(){
        
        HttpRequest req = new HttpRequest();
        
        Http http = new Http();
        
        string client_id;
        string apiKey;
        string methodType;
        string endPointURL;
        
        string accessToken;
        try{
            
            CSS_Integration_Details__c conDetails = CSS_Integration_Details__c.getValues('dbu_Dataplate_AccessToken');
            
            endPointURL = conDetails.End_Point__c;
            client_id = conDetails.Username__c ;
            methodType=conDetails.Method_Type__c;
            apiKey=conDetails.Key__c;
            req.setEndpoint(endPointURL);
            
            req.setMethod(methodType);
            
            req.setHeader('Content-Type','application/json');
            
            req.setBody('{"clientId":"'+client_id+'","apiKey":"'+apiKey+'"}');
            
            HttpResponse res = new HttpResponse();
                res = http.send(req);
            
            TokenResponse tokenResp = (TokenResponse)JSON.deserialize(res.getBody(), TokenResponse.class);
            accessToken = tokenResp.apiToken;
            
            system.debug('accessToken '+accessToken);
            
        }
        
        catch(exception e){
            
            system.debug('Exception Message'+e.getMessage()+''+'Exception line Number '+e.getLineNumber());
            
        }
        
        return accessToken;
        
    }
    
    //public static dbu_EsnSearchResponseWrapper getEsnResultwithVIN(string esn){
    public static TokenResponse getProductInfo(string vin){   
        
        string accessToken;
        string retEsnforVIN;
        TokenResponse tokenResp=new TokenResponse();
        dbu_EsnSearchResponseWrapper lstParsed = new dbu_EsnSearchResponseWrapper();
        HttpRequest req = new HttpRequest();
        Map<String, Object> mapData = new Map<String, Object>();
        Http http = new Http();
       
        string methodType;
        string endPointURL;
        // HttpResponse res = new HttpResponse();
        String responseBody; 
        String Status;
        Integer StatusCode;
        string mSec;
        try{
            
            CSS_Integration_Details__c conDetails = CSS_Integration_Details__c.getValues('dbu_DataplateCallout');
            methodType = conDetails.Method_Type__c;
            accessToken = getAccessToken();
            endPointURL =conDetails.End_Point__c+vin;
            req.setHeader('Authorization','Bearer '+accessToken);
            req.setMethod(methodType);
            req.setTimeout(120000);
            req.setEndpoint(endPointURL);
            
                HttpResponse res = new HttpResponse();
                Long reqTime = DateTime.now().getTime();
                res = http.send(req);
                Long respTime = DateTime.now().getTime();
                system.debug('resfrom esn service'+res.getStatusCode());
                long milliSeconds = respTime-reqTime ;
                mSec='***TIME::' +string.ValueOf(milliSeconds)+ ':: TIME***';
                if(res.getStatusCode() == 200)
                {
                    responseBody = res.getBody(); //Access Response body
                 	 tokenResp = (TokenResponse)JSON.deserialize(res.getBody(), TokenResponse.class);
					system.debug('tokenResp '+tokenResp);
                   
                }
                else
                {
                    responseBody = res.getBody();
                    system.debug('responseBody'+responseBody);
                    Status = res.getStatus();
                    StatusCode = res.getStatusCode();
                } 
           
            
            
            
        }
        catch(exception e){
            dbu_Integration_Error_Log.createErrorLog(null,mSec+e.getMessage(),vin,'','Prod Info Service','Exception'); //CECI-978 - Updated "ESN Service" to "Prod Info Service" - Abhilash
            system.debug('Exception Message'+e.getMessage()+''+'Exception line Number '+e.getLineNumber());
        }
        return tokenResp ;
        
    }
    public class TokenResponse {
        public string engineSerialNumber;	//79929608
        public String vin;	//3HTDTAPT7HN707018   
        public String apiToken;
        public List<dataCls> data;
        
    }
    
    public class dataCls{
        public string marketingEngineModel;
        public string serviceEngineModel;
        public string engineBuildDate;
        public String vin;
        
    }
   
}