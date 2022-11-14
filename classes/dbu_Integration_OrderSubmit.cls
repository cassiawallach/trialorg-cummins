/** 
* @Class Name: dbu_Integration_OrderSubmit    
* @Description      
- Constructor:  
* @Main Author: Ranadip Jha    
* @Last Modified: 23/09/2020       
* @Open Points      / comment4coverage  
*/

public class dbu_Integration_OrderSubmit {
    
    private  static String ENP_POINT_URL;
    //private static String RESOURCE = 'https://api-ue-devnf3-aw-ex.cummins.com:443/aftermarket-part';
    private final static String REQUEST_BODY = 'grant_type=client_credentials&client_id={0}&client_secret={1}&resource={2}';
    private  static String CONSUMER_KEY;
    private  static String CONSUMER_SECRET;
    private  static String METHOD_TYPE;    
    private static String Content_Type;
    private static String RESOURCE;
    private  static String ORDER_CONSUMER_KEY;
    private  static String ORDER_CONSUMER_SECRET;
    
    public static String getAccessToken(){
        try{
            CSS_Integration_Details__c conDetails = CSS_Integration_Details__c.getValues('dbu_Order_AccessToken');
            ENP_POINT_URL = conDetails.End_Point__c;
             CONSUMER_KEY = conDetails.Key__c;
            CONSUMER_SECRET = conDetails.Passcode__c;
            METHOD_TYPE = conDetails.Method_Type__c;
            RESOURCE=conDetails.Resource__c;
            HttpRequest req = new HttpRequest();
            req.setEndpoint(ENP_POINT_URL);
            req.setMethod(METHOD_TYPE);
            //req.setTimeout(120000);
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
        public String resource;
        public String access_token;
    }
    // need to pass parameter to this method 
    @AuraEnabled(cacheable=true)
    public static OrderSubmitResponseWrapper getOrderStatus(OrderSubmitRequestData  orderSubmitRequestData){
        String jsonRequestStr;
        string mSec;
        try{
            string responseBody;
            String AccessToken = getAccessToken();
            
          CSS_Integration_Details__c conDetails = CSS_Integration_Details__c.getValues('dbu_Order_StatusUpdate');
            ENP_POINT_URL = conDetails.End_Point__c;
            METHOD_TYPE = conDetails.Method_Type__c;
            Content_Type = conDetails.grant_type__c;
            ORDER_CONSUMER_KEY = conDetails.Key__c;
            ORDER_CONSUMER_SECRET = conDetails.Passcode__c;
            HttpRequest req = new HttpRequest();
            req.setHeader('Content-Type', Content_Type);
            req.setHeader('Authorization','Bearer ' + AccessToken);
            req.setHeader('client_id',ORDER_CONSUMER_KEY);
            req.setHeader('client_secret',ORDER_CONSUMER_SECRET);
            req.setTimeout(60000);
            req.setEndpoint(ENP_POINT_URL);
            req.setMethod(METHOD_TYPE);
            jsonRequestStr = JSON.serialize(orderSubmitRequestData);
            jsonRequestStr = jsonRequestStr.replaceAll('null', '\"\"');
            //jsonRequestStr = jsonRequestStr.replaceAll(system.label.dbu_special_characters,'');
            //req.setBody(JSON.serialize(orderSubmitRequestData));
            req.setBody(jsonRequestStr);
            System.debug('jsonRequestStr=>\t'+jsonRequestStr);
            Http http = new Http();
            Long reqTime = DateTime.now().getTime();
            HttpResponse res;
            try
            {
                res = http.send(req);
                Long respTime = DateTime.now().getTime();
                long milliSeconds = respTime-reqTime ;
                mSec='***TIME::' +string.ValueOf(milliSeconds)+ ':: TIME***';
                
                if(res.getStatusCode() != 200)
                {
                    dbu_Integration_Error_Log.createErrorLog(res.getStatusCode(),mSec,jsonRequestStr,res.getBody(),'Order Submit Service',res.getStatus());  
                }
            }
            catch(Exception ex)
            {
                
                dbu_Integration_Error_Log.createErrorLog(null,mSec+ex.getMessage(),jsonRequestStr,'','Order Submit Service','Exception');
                System.debug('exception message\t'+ex.getMessage()+'Line\t'+ex.getLineNumber());
            }
            if(res != null)
              responseBody = res.getBody(); 
            system.debug('response =>' + responseBody);
            system.debug('res =>' + res);
            OrderSubmitResponseWrapper result = (OrderSubmitResponseWrapper)JSON.deserialize(res.getbody(), OrderSubmitResponseWrapper.class);
            system.debug('status ' +result.status);
            return result;
            
        }catch(CallOutException ce){
            
            dbu_Integration_Error_Log.createErrorLog(null,ce.getMessage(),jsonRequestStr,'','Order Submit Service','Exception');
            System.debug('exception message\t'+ce.getMessage()+'Line\t'+ce.getLineNumber());
            throw ce;
        }       
    }
    
    public class OrderSubmitResponseWrapper{
        @AuraEnabled
        public String Status;
        public String locationCode;
    }

    public class OrderSubmitRequestData {
    public String buyingPartyName;
    public String buyingPartyNumber;
    public String buyingPartyEmailID;
    public List<BuyingPartyAddress> buyingPartyAddress;
        public String distributorCode;
        public string customerCode;
        public String destinationTransactionSystem;
        public String orderNumber;
        public String sourceTransactionSystem;
        public String status;
        public String submittedDate;
        public String shippingMode;
        public String paymentType;
        public Double totalOrderAmount;
        public Double totalTaxAmount;
        public List<BillToCustomer> billToCustomer;
        public List<Lines> lines;
        //Added new fields 20thApril2021
        public String cartId; 
        public String transactionSubCode;
        //end
    }
  public class BuyingPartyAddress {
    public String address1;
    public String address2;
    public String address3;
    public String city;
    public String state;
    public String country;
    public String postalCode;
  }
  public class BillToCustomer {
    public String address1;
    public String address2;
    public String address3;
    public String city;
    public String state;
    public String country;
    public String postalCode;
    public String partyName;
    public String contactNumber;//CHG0083792
  }
    public class ShipToDistributor{
        public String address1;
    public String address2;
    public String address3;
    public String city;
    public String state;
    public String country;
    public String postalCode;
    public String partyName;     
    }
    public class ShipToCustomer{
        public String address1;
    public String address2;
    public String address3;
    public String city;
    public String state;
    public String country;
    public String postalCode;
    public String partyName;      
    }
  public class Lines {
    public String lineId;
    public Integer orderedQuantity;
    public String orderReturnFlag;
    public String productCode;
    public String shippingMode;
    public String partNumber;
    public Double unitSellingPrice;
    public String deliveryMethod;
    public Double unitDiscount;
    public Double couponDiscount;
    public Double shippingCharges;
    public Double taxAmount;
    //Added new fields 20thApril2021
    public String unitOfMeasure; 
    public String quantityPerUnit; 
    //end
    public String taxClassificationCode;
    public String fulfillmentLocationCode;
    public List<ShipToDistributor> shipToDistributor;
    public List<ShipToCustomer> shipToCustomer;
    //Removed dbu_isInStock
  }
}