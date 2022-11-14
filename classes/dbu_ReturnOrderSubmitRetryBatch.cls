global class dbu_ReturnOrderSubmitRetryBatch implements Database.Batchable<sObject>,Database.AllowsCallouts
{
    
    global Database.QueryLocator start(Database.BatchableContext BC)
    {
       date da = date.valueOf(label.dbu_OrderDate);
       return Database.getQueryLocator([Select id,ccrz__BuyerPhone__c, name,DBU_Customer_BMS_Number__c,ccrz__Storefront__c,ccrz__PaymentMethod__c,dbu_SubmitOrder_Success__c,ccrz__OrderStatus__c,dbu_Shipto__c,ccrz__ShipMethod__c,ccrz__TotalAmount__c,ccrz__TaxAmount__c,ccrz__OrderDate__c,ccrz__Account__c,ccrz__BillTo__r.ccrz__AddressFirstline__c,ccrz__ShipTo__r.ccrz__AddressFirstline__c,ccrz__BuyerLastName__c,ccrz__BuyerFirstName__c,ccrz__BuyerEmail__c,ccrz__OrderNumber__c, 
        ccrz__Account__r.Name,ccrz__Account__r.BillingStreet,ccrz__Account__r.BillingCity,ccrz__Account__r.BillingState,ccrz__Account__r.BillingPostalCode,ccrz__Account__r.BillingCountry,ccrz__Account__r.CMI_Address2__c,ccrz__Account__r.CMI_Address3__c,
        ccrz__BillTo__r.ccrz__AddressSecondline__c,ccrz__ShipTo__r.ccrz__AddressSecondline__c,ccrz__BillTo__r.ccrz__AddressThirdline__c,ccrz__ShipTo__r.ccrz__AddressThirdline__c,ccrz__ShipTo__r.ccrz__City__c,ccrz__BillTo__r.ccrz__City__c,
        ccrz__BillTo__r.ccrz__State__c,ccrz__ShipTo__r.ccrz__State__c,ccrz__ShipTo__r.ccrz__Country__c,ccrz__BillTo__r.ccrz__Country__c,ccrz__BillTo__r.ccrz__PostalCode__c,ccrz__ShipTo__r.ccrz__PostalCode__c,CreatedDate,dbu_Days_Since_Order_Date__c,
        (Select id,Name,ccrz__Product__c,ccrz__Price__c,ccrz__Product__r.ccrz__TaxRateId__c,ccrz__Product__r.ccrz__UnitOfMeasure__c,ccrz__Product__r.ccrz__Quantityperunit__c,dbu_Shipto__c,dbu_StoreCode__c,dbu_Dropoff_Location__c,ccrz__Order__r.ccrz__ShipMethod__c,dbu_Selected_Return_Items__c,ccrz__AbsoluteDiscount__c,ccrz__Product__r.dbu_Has_Core_Charge__c,ccrz__Product__r.dbu_Part_Number__c,ccrz__Product__r.dbu_GenuinePart__c,ccrz__Product__r.ccrz__SKU__c,ccrz__Product__r.dbu_Product_Code__c,ccrz__ParentOrderItem__c, ccrz__Quantity__c,Vertex_Tax__c,ccrz__Order__r.ccrz__Account__c, ccrz__Order__r.name,ccrz__Order__r.ccrz__ShipAmount__c,ccrz__OrderItemStatus__c,dbu_isShipTo__c,dbu_isInStock__c from ccrz__E_OrderItems__r) from ccrz__E_Order__c Where dbu_SubmitOrder_Success__c = false AND ccrz__OrderStatus__c='Shipped' AND dbu_Is_Cloned__c =True AND ccrz__Storefront__c='CSSNAStore'AND CreatedDate >=:da]); //AND id=:'a2V1F0000037zse'
    }
    global void execute(Database.BatchableContext BC, List<ccrz__E_Order__c> orderIds)
    {
        system.debug('orderIds-->>>'+orderIds);
        dbu_Integration_OrderSubmit.OrderSubmitResponseWrapper response = dbu_RetryOrderSubmitAPI.retunOrderOrSubmitDetails(orderIds,'return');
    }
    global void finish(Database.BatchableContext BC)
    {
    }
}