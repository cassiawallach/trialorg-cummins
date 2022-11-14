global with sharing class dbu_Integration_OrderItem_Request {
    public String BMSOrderItemId{get;set;}//ccrz__OrderItemStatus__c BMS Order Id -- PartNumber
    //public String CCOrderItemId{get;set;}//ccrz__OrderItemStatus__c BMS Order Id -- PartNumber
    public String BMSOrderItemStatus{get;set;}//ccrz__OrderItemStatus__c BMS Order Id --PartNumberStatus 
    public String Comment{get;set;}//dbu_BMS_Comment__c

}