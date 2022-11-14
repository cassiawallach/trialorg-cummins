public without sharing class dbu_CCOrderAPIResponseWrapper {
    public dbu_CCOrderAPIResponseWrapper(){}
    
    @AuraEnabled public string orderDate;
    @AuraEnabled public string orderedDate;
    @AuraEnabled public String sfdcName;
    @AuraEnabled public String sfid;
    @AuraEnabled public String buyerFirstName;
    @AuraEnabled public String buyerLastName;
    @AuraEnabled public String buyerEmail;
    @AuraEnabled public String buyerPhone;
    @AuraEnabled public String dbupickupAddress;
     @AuraEnabled public String dbuPickUpStoreOpenHrs;
    //@AuraEnabled public String orderStatus;
    //@AuraEnabled public String billTo;
    @AuraEnabled public Decimal items;
    @AuraEnabled public Decimal shipAmount;
    @AuraEnabled public Decimal totalAmount;
    @AuraEnabled public Decimal totalDiscount;
    @AuraEnabled public Decimal subtotalAmount;
    @AuraEnabled public Decimal taxAmount;
    @AuraEnabled public Decimal taxSubTotalAmount;
    @AuraEnabled public String orderStatus;
    @AuraEnabled public decimal quantityperUnit;
    @AuraEnabled public Decimal daysSinceOrderDate; 
    @AuraEnabled public String paymentMethod;
    @AuraEnabled public boolean isInvoiceCreated;
    @AuraEnabled public String currencyISOCode; // Added by Mukesh Gupta for CurrencyISOCode --18-01-2021
    @AuraEnabled public Map<String,String> cloneOrderAgainstOrgOrderItemMap;
    //@AuraEnabled public list<dbu_CloneOrderOrderItemsRespWrapper> cloneOrderAgainstOrgOrderItemMapDetails;
    
    
    @AuraEnabled public list<dbu_CCApiOrderRelatedResponseWrapper> addresslist;
    @AuraEnabled  public list<dbu_orderBillingAddress> billingAddress;
    @AuraEnabled  public list<dbu_CCApiOrderItemsResponseWrapper> productlist;
    // @AuraEnabled  public list<dbu_OrderItemsRelatedListWrapper> orderItemsList;
    @AuraEnabled public list<dbu_OrderItemsRelatedListWrapper> EOrderItemsS;
    @AuraEnabled public list<ccrz__E_RelatedProduct__c> relatedProducts;
    
    //Added by Malhar & Dhiraj-for inventory- pickup address in CC ORDER
    @AuraEnabled  public list<ccrz__E_ContactAddr__c> OrderPickUpAddress;
    
    //@Vishnu 
    @AuraEnabled public boolean noShipmentWeight;
}