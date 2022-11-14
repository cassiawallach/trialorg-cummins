/**********************************************************************
Name: dbu_Integration_Invoice_Request
Copyright © 2020  Cummins
======================================================
======================================================
Purpose:    dbu_Integration_Invoice_Request request for REST API Service to update order status
                                                          
======================================================
======================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE(dd/mm/yyyy)                DETAIL                                 
1.0    Rajnish Kumar         27/08/2020                 INITIAL DEVELOPMENT                    

***********************************************************************/
global with sharing class dbu_Integration_Invoice_Request {
    
    public dbu_Integration_Invoice_Request(){}

    public String BMSInvoiceDate;// BMS_InvoiceDate__c
    public String CCOrderId;// ccrz__OrderId__c it is for order item.. not for order
    public String BMSInvoiceNumber;// BMS_InvoiceNumber__c
    public List<dbu_Integration_InvoiceItem_Request> CCInvoiceLineItemId;
    public String CCOrderShippingStatus;// ccrz__Status__c
    public String CCOrderShippingTrackingNumber;// ccrz__Status__c
    //public String Refund_Invoice_Number;// BMS_Refund_Invoice_Number__c

}