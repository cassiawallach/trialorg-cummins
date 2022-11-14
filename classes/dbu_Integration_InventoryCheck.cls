/** 
* @Class Name: dbu_Integration_InventoryCheck    
* @Description      
- Constructor:  
* @Main Author: Ranadip Jha    
* @Last Modified: 24/08/2022       
* @Open Points      /   
*/
public class dbu_Integration_InventoryCheck {
    
    private  static String ENP_POINT_URL;
    private static String RESOURCE;
    private final static String REQUEST_BODY = 'grant_type=client_credentials&client_id={0}&client_secret={1}&resource={2}';
    private  static String CONSUMER_KEY;
    private  static String CONSUMER_SECRET;
    private  static String METHOD_TYPE;  
    private static String CONTENT_TYPE;
    private static String PART_NUMBER = '&partNumber=';
    private static String LOCATIONN = '&location=';
    private static String VENDOR_PART_NUMBER = 'vendorPartNumber=';
    private static String PRODUCT_CODE = '&productCode=';
    private static String ZIP_CODE = '&zipCode=';
    
@Testvisible
    private static String getAccessToken(){
        TokenResponse resp;
        try{
            CSS_Integration_Details__c conDetails = CSS_Integration_Details__c.getValues('dbu_Inventory_AccessToken');
            ENP_POINT_URL = conDetails.End_Point__c;
            CONSUMER_KEY = conDetails.Key__c;
            CONSUMER_SECRET = conDetails.Passcode__c;
            METHOD_TYPE = conDetails.Method_Type__c;
            CONTENT_TYPE = conDetails.grant_type__c;
            RESOURCE = conDetails.Resource__c;
            HttpRequest req = new HttpRequest();
            //req.setHeader('Content-Type', CONTENT_TYPE);
            //system.debug('Content_Type ' + CONTENT_TYPE);
            req.setTimeout(2000);
            req.setEndpoint(ENP_POINT_URL);
            req.setMethod(METHOD_TYPE);
            req.setBody(String.format(REQUEST_BODY ,new string[]{CONSUMER_KEY,CONSUMER_SECRET,
                                                                 RESOURCE}));
            Http http = new Http();
            String resBody = '{"token_type":"jj","expires_in":"jj","ext_expires_in":"jj","expires_on":"jj","not_before":"jj","resource":"jj","access_token":"jj"}';
            if(!Test.isRunningTest())
            {
            
                HttpResponse res = http.send(req);
                resBody = res.getbody();
            
            }
           try{
                resp = (TokenResponse)JSON.deserialize(resBody, TokenResponse.class);
           }catch(Exception ex){
               System.debug('Error in the fetch Token log in the Inventory api\t'+ex.getLineNumber()+'\tException message:\t'+ex.getMessage());
                return null;
           }
           
           system.debug('name and acce token '+ resp.token_type +' '+ resp.access_token);
            return resp.access_token;
        }catch(CallOutException ce){
            dbu_CallCCCartApi.lstIntegrationErrorLogWrapper.add(dbu_IntegrationErrorLogWrapper.dbu_IntegrationErrorLogWrapper(null,ce.getMessage(),'','','Inventory Check Token Request','Exception'));
            return null;
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
    public static List<Dbu_InventoryWrapper>  getInventory(String FullPartNumber,String partNumber){
        return null;
    }
    
    @AuraEnabled
    public static List<Dbu_InventoryWrapper>  getInventory(String FullPartNumber,String partNumber, String productCode, String zipCode, String countryCode){
        String AccessToken;
        String EndPoint;
        try{
            AccessToken = getAccessToken();
            if(AccessToken == null){
                return null;
            }
            CSS_Integration_Details__c conDetails = CSS_Integration_Details__c.getValues('dbu_Inventory_Check');
            ENP_POINT_URL = conDetails.End_Point__c;
            METHOD_TYPE = conDetails.Method_Type__c;
            CONTENT_TYPE = conDetails.grant_type__c;
             //@Ayushi/Shaily for CR-CHG0109792/CECI-1170
             EndPoint = ENP_POINT_URL +VENDOR_PART_NUMBER + EncodingUtil.urlEncode(FullPartNumber, 'UTF-8') + PART_NUMBER + EncodingUtil.urlEncode(partNumber, 'UTF-8') + PRODUCT_CODE +productCode+ ZIP_CODE+ EncodingUtil.urlEncode(zipCode, 'UTF-8') +LOCATIONN + countryCode;
            system.debug('EndPoint ' + EndPoint);
            
            HttpRequest req = new HttpRequest();
            req.setHeader('Content-Type',CONTENT_TYPE);
            req.setHeader('Authorization','Bearer '+ AccessToken);
            req.setMethod(METHOD_TYPE);
            req.setEndpoint(EndPoint);
            req.setTimeout(12000);
            Http http = new Http();
            HTTPResponse res = http.send(req);
            System.debug('Inventory Response=>\t'+res);
            List<Dbu_InventoryWrapper> resp = new List<Dbu_InventoryWrapper>();
            if (res.getStatusCode() == 200) {
                 System.debug('res.getbody()===>'+res.getbody());
                   if(String.isNotBlank(res.getbody())){
                       try{
                            resp = (List<Dbu_InventoryWrapper>)JSON.deserialize(res.getbody(), List<Dbu_InventoryWrapper>.class);
                       }catch(Exception ex){
                            system.debug('Exception in dbu_Invetory_Callout JSON.deserialize=='+ex.getMessage()+'LineNumber='+ex.getLineNumber());
                            dbu_CallCCCartApi.lstIntegrationErrorLogWrapper.add(dbu_IntegrationErrorLogWrapper.dbu_IntegrationErrorLogWrapper(null,ex.getMessage(),EndPoint,'','Inventory Check Service','Exception'));
                            return null;
                       } 
                   }
                system.debug('inventory ' + resp);
                //createErrorLog(res.getStatusCode(),'',requestData,res.getBody(),'Inventory Check Service','Success');
                return resp;
        } else {
            //createErrorLog(res.getStatusCode(),res.getBody(),requestData,res.getBody(),'Inventory Check Service',res.getStatus());
            dbu_CallCCCartApi.lstIntegrationErrorLogWrapper.add(dbu_IntegrationErrorLogWrapper.dbu_IntegrationErrorLogWrapper(res.getStatusCode(),res.getBody(),EndPoint,'','Inventory Check Service','Exception'));
            return resp;
        }                        
        }catch(CallOutException ce){
            //createErrorLog(null,ce.getMessage(),'','','Inventory Check Service','Exception');
            dbu_CallCCCartApi.lstIntegrationErrorLogWrapper.add(dbu_IntegrationErrorLogWrapper.dbu_IntegrationErrorLogWrapper(null,ce.getMessage(),EndPoint,'','Inventory Check Service','Exception'));
            return null;
        }      
    }
    
    @future
    public static void createErrorLog(Integer ErrorCode,String ErrorDescription,String Request, String Response,String ServiceName,String Status){
        
        dbu_Integration_Error_Log.createErrorLog(ErrorCode,ErrorDescription,Request,Response,ServiceName,Status);
    }
    
    
}