public Without Sharing class dbu_Integration_ProductCloudfrontImages {
    
    private final static String REQUEST_BODY = 'grant_type={0}&scope={1}&client_id={2}';
    private static String GRANT_TYPE;
    private static String SCOPE;
    private  static String CLIENT_ID;
    
    @AuraEnabled(cacheable=true)
    public static string getAccessToken(){
        
        HttpRequest req = new HttpRequest();
        Http http = new Http();
        string accessToken;
        
        
        try{
            
            CSS_Integration_Details__c conDetails = CSS_Integration_Details__c.getValues('dbu_ProductCloudfrontImageAccessToken');
        
            CLIENT_ID = conDetails.Key__c;
            SCOPE = conDetails.Resource__c;
            GRANT_TYPE = conDetails.Grant_Type__C;
            
            string username = conDetails.Username__c; 
            string password = conDetails.Passcode__c;
    
            Blob header = Blob.valueOf(username + ':' + password);
            String authorizationHeader = 'Basic ' + EncodingUtil.base64Encode(header);
            
            req.setEndpoint(conDetails.End_Point__c);
            req.setMethod(conDetails.Method_Type__c);
            //req.setHeader('Content-Type','application/json');
            req.setHeader('Content-Type','application/x-www-form-urlencoded');
            req.setHeader('Accept', '*/*');
             
            req.setHeader('Authorization',authorizationHeader );
            
            req.setBody(String.format(REQUEST_BODY ,new string[]{GRANT_TYPE ,SCOPE, CLIENT_ID}));
            
            HttpResponse res = new HttpResponse();
            
            res = http.send(req);
            //START JIRA-CECI-1002
            if(res.getStatusCode() != 200)
            {
            createErrorLog(res.getStatusCode(),'',res.getBody(),res.getBody(),'AWS Image Service Token','Exception');
            }
            //END JIRA-CECI-1002
            TokenResponse tokenResp = (TokenResponse)JSON.deserialize(res.getBody(), TokenResponse.class);
            
            accessToken = tokenResp.access_token;
            //createErrorLog(res.getStatusCode(),'',res.getBody(),res.getBody(),'AWS Image Service Token','Success');
            system.debug('accessToken '+accessToken);
            
        }
        
        catch(exception e){
            system.debug('Exception Message'+e.getMessage()+''+'Exception line Number '+e.getLineNumber());
            createErrorLog(null,'Exception Message'+e.getMessage()+''+'Exception line Number '+e.getLineNumber(),'','','AWS Image Service Token','Exception');
            return null;
        }
        return accessToken;
    }
    
    @AuraEnabled(cacheable=true)
    public static String getProductImages(string imageURL,string accessToken){
        
        HttpRequest req = new HttpRequest();
        Http http = new Http();
        string client_id;
        string client_secret;
        string resource;
        string methodType;
        string endPointURL;
        string mSec;   
        try{ 
            //START JIRA-CECI-1002
             //accessToken = getAccessToken();
            if(String.isBlank(accessToken)){
                //return '';
                accessToken = getAccessToken();                
                 //END JIRA-CECI-1002
            }
            CSS_Integration_Details__c conDetails = CSS_Integration_Details__c.getValues('dbu_ProductCloudfrontImage');
            
            req.setHeader('Authorization',+accessToken);
            req.setBody('{"filePath":"'+imageURL+'"}');

            req.setMethod(conDetails.Method_Type__c);
            
            req.setTimeout(120000);
            req.setEndpoint(conDetails.End_Point__c);
            
            HttpResponse res = new HttpResponse();
            Long reqTime = DateTime.now().getTime();
            res = http.send(req);
            Long respTime = DateTime.now().getTime();
            long milliSeconds = respTime-reqTime ;
            mSec='***TIME::' +string.ValueOf(milliSeconds)+ ':: TIME***';
            //START JIRA-CECI-1002
            if(res.getStatusCode() != 200)
            {
            createErrorLog(res.getStatusCode(),mSec,res.getBody(),res.getBody(),'AWS Image Service','Exception');
            }
            //END JIRA-CECI-1002
            //createErrorLog(res.getStatusCode(),mSec,res.getBody(),res.getBody(),'AWS Image Service','Success');
            System.debug('response of aws service call===='+res);
            System.debug('response of aws service call res.getBody()===='+res.getBody());
            return res.getBody(); 
            
        }
        catch(exception e){
            system.debug('Exception Message'+e.getMessage()+''+'Exception line Number '+e.getLineNumber());
            createErrorLog(null,'Exception Message'+e.getMessage()+''+'Exception line Number '+e.getLineNumber(),'','','AWS Image Service','Exception');
        }
        
        return '';
    }
    @future
    public static void createErrorLog(Integer ErrorCode,String ErrorDescription,String Request, String Response,String ServiceName,String Status){
        
        dbu_Integration_Error_Log.createErrorLog(ErrorCode,ErrorDescription,Request,Response,ServiceName,Status);
    }    
    public class TokenResponse {
        public String access_token;
        public String expires_in;
        public String token_type;        
    }
}