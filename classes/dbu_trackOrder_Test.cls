@isTest
public With Sharing class dbu_trackOrder_Test {

    @isTest
    static void  getOrderListTest(){
        // deployment comment
        Id iamRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('IAM').getRecordTypeId();
        Contact contactObj = new Contact();
        contactObj.FirstName = 'Ranadip';
        contactObj.LastName = 'Jha';
        contactObj.Email = 'test@test.com';
        contactObj.Username__c	= 'ranadip@test.com';
        contactObj.IAM_Contact_Status__c = 'Active';
        contactObj.RecordTypeId = iamRecordTypeId;
        insert contactObj;

        ccrz__E_Order__c orderObj = new ccrz__E_Order__c();
        orderObj.ccrz__OrderNumber__c = 1253656;
        orderObj.ccrz__Storefront__c = 'CSSNAStore';
        orderObj.ccrz__OrderStatus__c = 'Order Submitted';
        orderObj.ccrz__CurrencyISOCode__c = 'USD';
        orderObj.ccrz__BuyerFirstName__c = 'ranadip';
        orderObj.ccrz__BuyerLastName__c = 'Jha';
        orderObj.ccrz__BuyerEmail__c = 'test@test.com';
        orderObj.ccrz__BuyerPhone__c = '9999911111';
        orderObj.ccrz__Contact__c = contactObj.Id;
        insert orderObj;
        ccrz__E_Order__c obj = [select id, Name,ccrz__BuyerEmail__c from ccrz__E_Order__c  where id =: orderObj.id]; 
        Test.startTest();
        dbu_trackOrder.getOrderList(obj.Name, obj.ccrz__BuyerEmail__c);
        Test.stopTest();
        
    }
}