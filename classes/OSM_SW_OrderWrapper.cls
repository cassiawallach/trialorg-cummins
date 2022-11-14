public class OSM_SW_OrderWrapper {
	
    
    //input
    public String orderId;
    public String orderStatus;
    public ccrz__E_Order__c order;
    public String accountId;
    
    
    //every order will have invoice
    //input
    public String invoiceId;
    public ccrz__E_Invoice__c invoiceToUpdate;
    public String invoiceStatus;
    public List<ccrz__E_Order__c> orderLstForInvoiceToBeUpdated;
    
    public String txPaymentId;
    public ccrz__E_TransactionPayment__c txPayment;
    
    
    public String action;
    
   // public List<OSM_SW_OrderLineWapper> orderLinesToCancel;
    
    public Map<String,OSM_SW_OrderLineWrapper>  lineIdVsWrapperToCancel;
    
    public class OSM_SW_OrderLineWrapper{
    	//input    
        public Integer qtyToCancel;
        //input
        public String orderLineId;
        //this will have id of child like CA-Base
        //input
        public String productIdSubscribed;
        public ccrz__E_OrderItem__c orderItem;
        public ccrz__E_Subscription__c subscription;
        public String invoiceLineId;
        public ccrz__E_InvoiceItem__c invoiceItem;
        public OSM_Order_Subscription__c orderSubsJunction;
       
    } 
}