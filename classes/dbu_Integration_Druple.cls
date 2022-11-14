/** 
* @Class Name: dbu_Integration_Druple    
* @Description      
- Constructor:  
* @Main Author: Ranadip Jha    
* @Last Modified: 18/09/2020       
* @Open Points      /   
*/

public with sharing class dbu_Integration_Druple {

    private  static String ENP_POINT_URL;
    //private static String RESOURCE = 'https://api-ue-devnf-aw-ex.cummins.com/cmi/v1/contentmanagement';
    private static String RESOURCE;
    private final static String REQUEST_BODY = 'grant_type=client_credentials&client_id={0}&client_secret={1}&resource={2}';
    private  static String CONSUMER_KEY;
    private  static String CONSUMER_SECRET;
    private  static String METHOD_TYPE;  
    private static String Content_Type;
    
    private static String getAccessToken(){
        try{
            CSS_Integration_Details__c conDetails = CSS_Integration_Details__c.getValues('dbu_druple_AccessToken');
            ENP_POINT_URL = conDetails.End_Point__c;
            CONSUMER_KEY = conDetails.Key__c;
            CONSUMER_SECRET = conDetails.Passcode__c;
            METHOD_TYPE = conDetails.Method_Type__c;
            RESOURCE = conDetails.Resource__c;
            
            HttpRequest req = new HttpRequest();
            req.setEndpoint(ENP_POINT_URL);
            req.setMethod(METHOD_TYPE);
            req.setBody(String.format(REQUEST_BODY ,new string[]{CONSUMER_KEY,CONSUMER_SECRET,
                                                                 RESOURCE}));
           
            Http http = new Http();
            HttpResponse res = http.send(req);
          
           TokenResponse resp = (TokenResponse)JSON.deserialize(res.getbody(), TokenResponse.class);
           system.debug('name and acce token '+ resp.token_type +' '+ resp.access_token);
            return resp.access_token;
        }catch(CallOutException ce){
            throw ce;
        }       
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
    
    @AuraEnabled
    public static List<DrupleResponseWrapper> getDrupleContent(String data){
        Long milliSeconds;
        string mSec; 
        try{
            String AccessToken = getAccessToken();
            System.debug('got access token');
            CSS_Integration_Details__c conDetails = CSS_Integration_Details__c.getValues('dbu_Druple_Content');
            ENP_POINT_URL = conDetails.End_Point__c;
            METHOD_TYPE = conDetails.Method_Type__c;
            Content_Type = conDetails.grant_type__c;
            String EndPoint = ENP_POINT_URL + data;
            
            HttpRequest req = new HttpRequest();
            req.setHeader('Content-Type', Content_Type);
            req.setHeader('Authorization','Bearer ' + AccessToken);

            req.setEndpoint(EndPoint);
            req.setMethod(METHOD_TYPE);
            
            Http http = new Http();
            Long reqTime = DateTime.now().getTime();
            HttpResponse res = http.send(req);
            
            string responseBody = res.getBody();
            Long respTime = DateTime.now().getTime();
            system.debug('response =>' + responseBody);
            List<DrupleResponseWrapper> result = (List<DrupleResponseWrapper>)json.deserialize(responseBody, List<DrupleResponseWrapper>.class); //deserialize the reponse
            system.debug('result =>' + result);
            milliSeconds = respTime-reqTime ;
            System.debug('milliseconds---->>' + milliSeconds);
            mSec='***TIME::' +string.ValueOf(milliSeconds)+ ':: TIME***';
           if(res.getStatusCode() == 200)
            { 
                dbu_Integration_Error_Log.createErrorLog(res.getStatusCode(),mSec, data, '', 'Drupal Service', 'Success');
                system.debug('before result =>' + result);
                return result;
            }
            else
            {
                dbu_Integration_Error_Log.createErrorLog(res.getStatusCode(),mSec+res.getBody(),data,'','Drupal Service',res.getStatus());
            }
            return result;
        }catch(CallOutException ce){
            
           // throw new AuraHandledException('Something went wrong:::: '+ ce.getMessage()); 
           dbu_Integration_Error_Log.createErrorLog(null,mSec+ce.getMessage(),'','','Drupal Service','Exception');
           throw ce;
        }       
    }
    
    public class DrupleResponseWrapper{

        @AuraEnabled
        public String title{get;set;}
        @AuraEnabled
        public String image{get;set;}
        @AuraEnabled
        public String body{get;set;}

        public DrupleResponseWrapper(String title,String body, String image)
        {
            this.title = title;
            this.body = body;
            this.image = image;
            
        }

    }
}