/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 09-21-2022
 * @last modified by  : Ramesh
**/
@isTest
public class dbu_OrderSubmitRetryBatch_Test 
{
    
    public static testMethod void orderSubmitRetryBatchTest(){//updated
        // insert contact added comment
        Id iamRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('IAM').getRecordTypeId();
        Id ContactRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('IAM').getRecordTypeId();
        Account createAccount= dbu_TestDataCreationUtility.createAccount(iamRecordTypeId);
        createAccount.BillingCountry = 'Canada';
        insert createAccount;
        Contact createContact= dbu_TestDataCreationUtility.createContact(createAccount, ContactRecordTypeId);
        insert createContact;
        ccrz__E_Product__c createProduct= dbu_TestDataCreationUtility.createProduct();
        createProduct.dbu_Product_Code__c='CECO';
        insert createProduct;
        
       
        ccrz__E_ContactAddr__c createContactAddr= dbu_TestDataCreationUtility.createContactAddr();
        createContactAddr.ccrz__Country__c='Canada';
        createContactAddr.ccrz__PostalCode__c='V4N3P8';
        insert createContactAddr;
        
         ccrz__E_Cart__c createCart= dbu_TestDataCreationUtility.createCart();
        createCart.dbu_Pick_Up_From_Store__c = createContactAddr.Id;
        insert createCart;
        ccrz__E_CartItem__c createCartItem= dbu_TestDataCreationUtility.createCartItem(createProduct.Id,createCart.Id);
        insert createCartItem;
        
        ccrz__E_Order__c createOrder= dbu_TestDataCreationUtility.createOrder(createContact.Id,createCart.Id,createContactAddr.id,createContactAddr.id);
        createOrder.ccrz__ShipMethod__c='Ship To Address';
        createOrder.ccrz__Account__c=createAccount.id;
        createOrder.ccrz__OriginatedCart__c = createCart.Id;
        createOrder.ccrz__PaymentMethod__c='credit card';
        insert createOrder;
        ccrz__E_OrderItem__c createOrderItem= dbu_TestDataCreationUtility.createOrderItem(createOrder.Id,createProduct.Id,createCartItem.Id);
        createOrderItem.ccrz__AbsoluteDiscount__c=0.00;
        createOrderItem.Vertex_Tax__c=1.2;
        createOrderItem.ccrz__OriginalQuantity__c=1;
        createOrderItem.ccrz__OrderItemStatus__c='';
        createOrderItem.dbu_Dropoff_Location__c='623 5th Ave 19th floor, New York, NY 10022, United States';
        insert createOrderItem;
        List<String> listOrderItemIds = New List<String>();
        listOrderItemIds.add(createOrderItem.id);
        List<ccrz__E_Order__c> orderList = new List<ccrz__E_Order__c>();
        orderList.add(createOrder);
        dbu_IntegrationErrorLog__c errorLog = new dbu_IntegrationErrorLog__c();
        errorLog.Name='ErrorLogEmail';
        errorLog.SetToAddress__c='test2093@cumminstes.com';
        errorLog.TargetObjectId__c=Userinfo.getUserId();
        insert errorLog;
        ccrz__E_OrderItem__c orderItemObj = new ccrz__E_OrderItem__c();
        orderItemObj.ccrz__Price__c = 10.00;
        orderItemObj.ccrz__Quantity__c = 5;
        orderItemObj.ccrz__SubAmount__c = 50.00;
        orderItemObj.ccrz__StoreId__c = 'CSSNAStore';
        orderItemObj.ccrz__OrderItemStatus__c = '';
        orderItemObj.ccrz__Order__c = createOrder.Id;
        orderItemObj.ccrz__Product__c = createProduct.Id;
        orderItemObj.dbu_Selected_Return_Items__c = True;
        orderItemObj.dbu_Shipto__c = false;
        orderItemObj.dbu_Dropoff_Location__c='Cummins Sales And Service - Ocala FL,Ocala,321 S. W. 52nd Ave,FL,U.S.A,12345';
        insert orderItemObj;
        listOrderItemIds.add(orderItemObj.id);
        dbu_OrderSubmitRetryBatch OSRB = new dbu_OrderSubmitRetryBatch();
        database.executeBatch(OSRB, 1);
       }
       public static testMethod void retryOrderSubmitAPITest1(){
        Id iamRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('IAM').getRecordTypeId();
        Id ContactRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('IAM').getRecordTypeId();
        Account createAccount= dbu_TestDataCreationUtility.createAccount(iamRecordTypeId);
        //createAccount.BillingCountry = 'Canada';
        insert createAccount;
        Contact createContact= dbu_TestDataCreationUtility.createContact(createAccount, ContactRecordTypeId);
        insert createContact;
        ccrz__E_Product__c createProduct= dbu_TestDataCreationUtility.createProduct();
        createProduct.dbu_Has_Core_Charge__c=True;
        insert createProduct;
        ccrz__E_ContactAddr__c createContactAddr1= dbu_TestDataCreationUtility.createContactAddr();
        createContactAddr1.ccrz__Country__c='US';
        createContactAddr1.ccrz__PostalCode__c='10022';
        insert createContactAddr1;
        ccrz__E_Cart__c createCart= dbu_TestDataCreationUtility.createCart();
        createCart.dbu_Pick_Up_From_Store__c = createContactAddr1.Id;
        insert createCart;
        ccrz__E_CartItem__c createCartItem= dbu_TestDataCreationUtility.createCartItem(createProduct.Id,createCart.Id);
        insert createCartItem;
        ccrz__E_ContactAddr__c createContactAddr= dbu_TestDataCreationUtility.createContactAddr();
        //createContactAddr.ccrz__Country__c='CA';
        //createContactAddr.ccrz__PostalCode__c='V4N3P8';
        insert createContactAddr;
        ccrz__E_Order__c createOrder= dbu_TestDataCreationUtility.createOrder(createContact.Id,createCart.Id,createContactAddr.Id,createContactAddr.id);
        createOrder.ccrz__Account__c=createAccount.id;
        createOrder.ccrz__ShipAmount__c=5.0;
        createOrder.ccrz__TaxAmount__c=1.0;
        createOrder.ccrz__ShipMethod__c='Pick Up';
        createOrder.ccrz__PaymentMethod__c='credit card';
        insert createOrder;
        ccrz__E_OrderItem__c createOrderItem= dbu_TestDataCreationUtility.createOrderItem(createOrder.Id,createProduct.Id,createCartItem.Id);
        createOrderItem.ccrz__Price__c=0.00;
        createOrderItem.ccrz__AbsoluteDiscount__c=10.00;
        createOrderItem.Vertex_Tax__c=1.2;
        insert createOrderItem;
        List<Object> orderData = new List<Object>();
        
        ccrz__E_OrderItem__c orderItemObj = new ccrz__E_OrderItem__c();
        orderItemObj.ccrz__Price__c = 10.00;
        orderItemObj.ccrz__Quantity__c = 5;
        orderItemObj.ccrz__SubAmount__c = 50.00;
        orderItemObj.ccrz__StoreId__c = 'CSSNAStore';
        orderItemObj.ccrz__OrderItemStatus__c = '';
        orderItemObj.ccrz__Order__c = createOrder.Id;
        orderItemObj.ccrz__Product__c = createProduct.Id;
        orderItemObj.dbu_Selected_Return_Items__c = True;
        orderItemObj.dbu_Shipto__c = True;
        orderItemObj.dbu_Dropoff_Location__c='Cummins Sales And Service - Ocala FL,Ocala,321 S. W. 52nd Ave,FL,U.S.A,12345';
        insert orderItemObj;
        ccrz__E_OrderItem__c orderItemObj1 = new ccrz__E_OrderItem__c();
        orderItemObj1.ccrz__Price__c = 10.00;
        orderItemObj1.ccrz__Quantity__c = 5;
        orderItemObj1.ccrz__SubAmount__c = 50.00;
        orderItemObj1.ccrz__StoreId__c = 'CSSNAStore';
        orderItemObj1.ccrz__OrderItemStatus__c = 'Return Initiated';
        orderItemObj1.ccrz__Order__c = createOrder.Id;
        orderItemObj1.ccrz__Product__c = createProduct.Id;
        orderItemObj1.dbu_Selected_Return_Items__c = True;
            orderItemObj1.dbu_Shipto__c = True;
        insert orderItemObj1;
        dbu_IntegrationErrorLog__c errorLog = new dbu_IntegrationErrorLog__c();
        errorLog.Name='ErrorLogEmail';
        errorLog.SetToAddress__c='test2093@cumminstes.com';
        errorLog.TargetObjectId__c=Userinfo.getUserId();
        insert errorLog;
        dbu_OrderSubmitRetryBatch OSRB = new dbu_OrderSubmitRetryBatch();
        database.executeBatch(OSRB, 1);
    }  
    }
    //Prod Deployment 23-09-2022