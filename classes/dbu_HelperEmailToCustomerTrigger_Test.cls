@isTest
public with sharing class dbu_HelperEmailToCustomerTrigger_Test {
    
    @isTest public static void sendEmailTest(){
        ccrz__E_Product__c productObj = dbu_TestDataCreationUtility.createProduct();
        productObj.dbu_Has_Core_Charge__c = false;
        insert productObj;
        
        ccrz__E_ContactAddr__c  ShipFromAddr = new ccrz__E_ContactAddr__c();
        ShipFromAddr.ccrz__AddressFirstline__c = '2815 Exposition Blvd';
        ShipFromAddr.ccrz__AddressSecondline__c = 'Ste 2353242';
        ShipFromAddr.ccrz__AddressThirdline__c = null;
        ShipFromAddr.ccrz__City__c = 'Austin';
        ShipFromAddr.ccrz__State__c = 'TX';
        ShipFromAddr.ccrz__PostalCode__c = '78703';
        ShipFromAddr.ccrz__Country__c = 'US';
        insert ShipFromAddr;
        
        ccrz__E_Cart__c cartObj = dbu_TestDataCreationUtility.createCart();
        insert cartObj;
        
        ccrz__E_CartItem__c cartItemObj = dbu_TestDataCreationUtility.createCartItem(productObj.Id,cartObj.Id);
        insert cartItemObj;
        
        Id iamRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('IAM').getRecordTypeId();
        Contact contactObj = new Contact();
        contactObj.FirstName = 'Test';
        contactObj.LastName = 'Test';
        contactObj.Email = 'test@test.com';
        contactObj.Username__c	= 'ranadip@test.com';
        contactObj.IAM_Contact_Status__c = 'Active';
        contactObj.RecordTypeId = iamRecordTypeId;
        insert contactObj;
        
        ccrz__E_Order__c orderObj = new ccrz__E_Order__c();
        orderObj.ccrz__Name__c = 'My Cart';
        orderObj.ccrz__OrderNumber__c = 1253656;
        orderObj.ccrz__Storefront__c = 'CSSNAStore';
        orderObj.ccrz__OrderStatus__c = 'Delivered';
        orderObj.ccrz__CurrencyISOCode__c = 'USD';
        orderObj.ccrz__BuyerFirstName__c = 'name';
        orderObj.ccrz__BuyerLastName__c = '';
        orderObj.ccrz__BuyerEmail__c = 'test@test.com';
        orderObj.ccrz__BuyerPhone__c = '123456789';
        orderObj.ccrz__Contact__c = contactObj.Id;
        orderObj.ccrz__OrderDate__c= System.today();
        orderObj.ccrz__Storefront__c ='CSSNAStore';
        orderObj.ccrz__OriginatedCart__c=cartObj.Id;
        //orderObj.ccrz__BillTo__c =billingAddr;
        orderObj.ccrz__ShipTo__c =ShipFromAddr.Id;
        insert orderObj;
        
        ccrz__E_OrderItem__c orderItemObj = new ccrz__E_OrderItem__c();
        orderItemObj.ccrz__Price__c = 10.00;
        orderItemObj.ccrz__Quantity__c = 5;
        orderItemObj.ccrz__SubAmount__c = 50.00;
        orderItemObj.ccrz__StoreId__c = 'CSSNAStore';
        orderItemObj.ccrz__OrderItemStatus__c = 'Return Rejected';//Refunded
        orderItemObj.ccrz__OrderItemStatus__c = 'Refunded';
        orderItemObj.dbu_Shipto__c = true;
        orderItemObj.dbu_IsShippingLabelSent__c = false;
        orderItemObj.dbu_Reason_for_Return__c = 'Damaged in shipping'; 
        orderItemObj.ccrz__Order__c = orderObj.Id;
        orderItemObj.ccrz__Product__c = productObj.Id;
        orderItemObj.ccrz__OrderItemId__c = cartItemObj.id;
        insert orderItemObj;
        
      ccrz__E_OrderItem__c oi = [select id ,ccrz__Product__r.dbu_Has_Core_Charge__c, ccrz__OrderItemStatus__c,ccrz__Order__c,ccrz__Order__r.ccrz__BuyerEmail__c,ccrz__Order__r.ccrz__User__c,ccrz__Order__r.ccrz__Contact__c from ccrz__E_OrderItem__c where id =:orderItemObj.id];

        
        Test.startTest();
        dbu_HelperEmailToCustomerTrigger.sendEmail(oi);       
        Test.stopTest();
    }

}