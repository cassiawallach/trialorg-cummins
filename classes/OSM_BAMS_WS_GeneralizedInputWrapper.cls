global class OSM_BAMS_WS_GeneralizedInputWrapper{

    public String merchantID{get;set;}
    public String merchantReferenceCode{get;set;}
    public String PTcurrency{get;set;}
    public Decimal grandTotalAmount{get;set;}
    public String subscriptionID{get;set;}
    public String orderId{get;set;}
    public string orderItmId {get; set;}
    public ccrz__E_Order__c order{get;set;}
    public ccrz__E_TransactionPayment__c transactionPayment{get;set;}
    public ccrz__E_Invoice__c invoice{get;set;}
    public ccrz__E_OrderItem__c orderItem {get; set;}    
}