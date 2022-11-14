public without sharing class dbu_OrderItemShippingLabelEmailData {
    public dbu_OrderItemShippingLabelEmailData(){}
    @AuraEnabled public ccrz__E_Order__c  orderObject;
    @AuraEnabled public EmailTemplate template;
    @AuraEnabled public String shippingInstructions;
    @AuraEnabled public String contactId;
    @AuraEnabled public OrgWideEmailAddress[] owea;
    @AuraEnabled public String pdf_ShippingIns;
    @AuraEnabled public String localData;
   
}