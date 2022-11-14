public class OSM_RequiredFields_Exception extends Exception {

    
    public Map<String,String> fieldVsErrorMap;
    public ccrz__E_Subscription__c subscription;
    public List<OSM_Order_Subscription__c> orderSubsJunction;
        
    public OSM_RequiredFields_Exception(String exceptionMsg, Boolean exceptionFlag )
    {
        this.exceptionFlag = exceptionFlag;
        this.exceptionMessage = exceptionMsg;
    }
    
    public boolean exceptionFlag{get;set;}
    public String exceptionMessage{get;set;}
    
    
}