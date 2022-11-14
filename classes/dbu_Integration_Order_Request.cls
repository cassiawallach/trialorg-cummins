/**********************************************************************
Name: dbu_Integration_Order_Request
Copyright © 2020  Cummins
======================================================
======================================================
Purpose:    dbu_Integration_Order_Request request for REST API Service to update order status
                                                          
======================================================
======================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE(dd/mm/yyyy)                DETAIL                                 
1.0    Rajnish Kumar         20/08/2020                 INITIAL DEVELOPMENT                    

***********************************************************************/
global with sharing class dbu_Integration_Order_Request {
    //public String CCOrderId{get;set;}//ccrz__OrderItemStatus__c BMS Order Id
    public String BMSOrderStatus{get;set;}//ccrz__OrderItemStatus__c BMS Order Id -- OrderStatus
    public String BMSOrderId{get;set;}//ccrz__OrderItemStatus__c BMS Order Id -- --OrderId
    public String CCOrderId{get;set;}//ccrz__OrderItemStatus__c BMS Order Id -- --OrderId
    public List<dbu_Integration_OrderItem_Request> OrderItemsStatus{get;set;}//ccrz__OrderItemId__c
    //public String ccrz__Product__c{get;set;}
}