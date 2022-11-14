/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 09-21-2022
 * @last modified by  : Ramesh
 * 
**/
@isTest
public class dbu_RetryOrderSubmitAPI_Test 
{
    
    public static testMethod void retryOrderSubmitAPITest(){
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
       // createCart.dbu_Pick_Up_From_Store__c = createContactAddr.Id;
        createCart.dbu_Pick_Up_From_Store__c =  createContactAddr.id;
        insert createCart; 
        ccrz__E_CartItem__c createCartItem= dbu_TestDataCreationUtility.createCartItem(createProduct.Id,createCart.Id);
        insert createCartItem; 
        
        ccrz__E_Order__c createOrder= dbu_TestDataCreationUtility.createOrder(createContact.Id,createCart.Id,createContactAddr.id,createContactAddr.id);
        createOrder.ccrz__ShipMethod__c='Ship To Address';
        createOrder.ccrz__ShipMethod__c=createContactAddr.id;
        createOrder.ccrz__Account__c=createAccount.id;
        createOrder.ccrz__OriginatedCart__c=createCart.id;
        insert createOrder;//Added Replace dbu_special_characters for User Input
        ccrz__E_OrderItem__c createOrderItem= dbu_TestDataCreationUtility.createOrderItem(createOrder.Id,createProduct.Id,createCartItem.Id);
        createOrderItem.dbu_Shipto__c = true;
        createOrderItem.ccrz__AbsoluteDiscount__c=0.00;
        createOrderItem.Vertex_Tax__c=1.2;
        createOrderItem.ccrz__OrderItemStatus__c='';
        insert createOrderItem;
        List<String> listOrderItemIds = New List<String>();
        listOrderItemIds.add(createOrderItem.id);
        List<ccrz__E_Order__c> orderList = new List<ccrz__E_Order__c>();
        //orderList.add(createOrder);
        dbu_IntegrationErrorLog__c errorLog = new dbu_IntegrationErrorLog__c();
        errorLog.Name='ErrorLogEmail';
        errorLog.SetToAddress__c='test2093@cumminstes.com';
        errorLog.TargetObjectId__c=Userinfo.getUserId();//Added code with labels to replace special characters
        insert errorLog;
        orderList = [Select id, name,ccrz__BuyerPhone__c,ccrz__Storefront__c,DBU_Customer_BMS_Number__c,ccrz__PaymentMethod__c,dbu_SubmitOrder_Success__c,ccrz__OrderStatus__c,dbu_Shipto__c,ccrz__ShipMethod__c,ccrz__TotalAmount__c,ccrz__TaxAmount__c,ccrz__OrderDate__c,ccrz__Account__c,ccrz__BillTo__r.ccrz__AddressFirstline__c,ccrz__ShipTo__r.ccrz__AddressFirstline__c,ccrz__BuyerLastName__c,ccrz__BuyerFirstName__c,ccrz__BuyerEmail__c,ccrz__OrderNumber__c, 
        ccrz__Account__r.Name,ccrz__Account__r.BillingStreet,ccrz__Account__r.BillingCity,ccrz__Account__r.BillingState,ccrz__Account__r.BillingPostalCode,ccrz__Account__r.BillingCountry,ccrz__Account__r.CMI_Address2__c,ccrz__Account__r.CMI_Address3__c,
        ccrz__BillTo__r.ccrz__AddressSecondline__c,ccrz__ShipTo__r.ccrz__AddressSecondline__c,ccrz__BillTo__r.ccrz__AddressThirdline__c,ccrz__ShipTo__r.ccrz__AddressThirdline__c,ccrz__ShipTo__r.ccrz__City__c,ccrz__BillTo__r.ccrz__City__c,
        ccrz__BillTo__r.ccrz__State__c,ccrz__ShipTo__r.ccrz__State__c,ccrz__ShipTo__r.ccrz__Country__c,ccrz__BillTo__r.ccrz__Country__c,ccrz__BillTo__r.ccrz__PostalCode__c,ccrz__ShipTo__r.ccrz__PostalCode__c,CreatedDate,dbu_Days_Since_Order_Date__c,
        ccrz__OriginatedCart__r.dbu_Pick_Up_From_Store__r.ccrz__AddressFirstline__c,ccrz__OriginatedCart__r.dbu_Pick_Up_From_Store__r.ccrz__AddressSecondline__c,ccrz__OriginatedCart__r.dbu_Pick_Up_From_Store__r.ccrz__AddressThirdline__c,ccrz__OriginatedCart__r.dbu_Pick_Up_From_Store__r.ccrz__City__c,ccrz__OriginatedCart__r.dbu_Pick_Up_From_Store__r.ccrz__State__c,
        ccrz__OriginatedCart__r.dbu_Pick_Up_From_Store__r.ccrz__Country__c,ccrz__OriginatedCart__r.dbu_Pick_Up_From_Store__r.ccrz__PostalCode__c,
        (Select id,Name,dbu_Shipto__c,dbu_Dropoff_Location__c,ccrz__Product__c,ccrz__Price__c,ccrz__SubAmount__c,ccrz__Product__r.ccrz__TaxRateId__c,ccrz__Product__r.ccrz__UnitOfMeasure__c,ccrz__Product__r.ccrz__Quantityperunit__c,ccrz__Order__r.ccrz__OriginatedCart__r.dbu_StoreCode__c,dbu_Selected_Return_Items__c,ccrz__Order__r.ccrz__ShipMethod__c,ccrz__AbsoluteDiscount__c,ccrz__Product__r.dbu_Has_Core_Charge__c,ccrz__Product__r.dbu_Part_Number__c,ccrz__Product__r.dbu_GenuinePart__c,ccrz__Product__r.ccrz__SKU__c,ccrz__Product__r.dbu_Product_Code__c,ccrz__ParentOrderItem__c, ccrz__Quantity__c,Vertex_Tax__c,ccrz__Order__r.ccrz__Account__c, ccrz__Order__r.name,ccrz__Order__r.ccrz__ShipAmount__c,ccrz__OrderItemStatus__c,dbu_isShipTo__c,dbu_isInStock__c from ccrz__E_OrderItems__r),(select ccrz__TransactionSubcode__c,ccrz__TransactionCode__c from ccrz__TransactionPayments__r),ccrz__OriginatedCart__c from ccrz__E_Order__c Where dbu_SubmitOrder_Success__c = false AND ccrz__OrderStatus__c='Order Submitted' AND dbu_Is_Cloned__c =False AND ccrz__Storefront__c='CSSNAStore'];
        
        dbu_RetryOrderSubmitAPI.retunOrderOrSubmitDetails(orderList,'submit');
        dbu_RetryOrderSubmitAPI.retunOrderOrSubmitDetails(orderList,'return');
         
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
        ccrz__E_Cart__c createCart= dbu_TestDataCreationUtility.createCart();
        insert createCart;
        ccrz__E_CartItem__c createCartItem= dbu_TestDataCreationUtility.createCartItem(createProduct.Id,createCart.Id);
        insert createCartItem;
        ccrz__E_ContactAddr__c createContactAddr= dbu_TestDataCreationUtility.createContactAddr();
        createContactAddr.ccrz__Country__c='CA';
        createContactAddr.ccrz__PostalCode__c='V4N3P8';
        insert createContactAddr;
        ccrz__E_Order__c createOrder= dbu_TestDataCreationUtility.createOrder(createContact.Id,createCart.Id,createContactAddr.Id,createContactAddr.id);
        createOrder.ccrz__Account__c=createAccount.id;
        createOrder.ccrz__ShipAmount__c=5.0;
        createOrder.ccrz__TaxAmount__c=1.0;
        createOrder.ccrz__ShipMethod__c='Pick Up';
        insert createOrder;
        ccrz__E_OrderItem__c createOrderItem= dbu_TestDataCreationUtility.createOrderItem(createOrder.Id,createProduct.Id,createCartItem.Id);
        createOrderItem.ccrz__Price__c=0.00;
        createOrderItem.ccrz__SubAmount__c=0.00;
        createOrderItem.ccrz__AbsoluteDiscount__c=10.00;
        createOrderItem.Vertex_Tax__c=1.2;
        createOrderItem.dbu_Shipto__c = true;
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
        orderItemObj.dbu_Shipto__c = true;
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
        orderItemObj1.dbu_Shipto__c = true;
        insert orderItemObj1;
        dbu_IntegrationErrorLog__c errorLog = new dbu_IntegrationErrorLog__c();
        errorLog.Name='ErrorLogEmail';
        errorLog.SetToAddress__c='test2093@cumminstes.com';
        errorLog.TargetObjectId__c=Userinfo.getUserId();
        insert errorLog;
        List<String> listOrderItemIds = New List<String>();
        listOrderItemIds.add(orderItemObj.id);
        List<ccrz__E_Order__c> orderList = new List<ccrz__E_Order__c>();
        //orderList.add(createOrder);
        orderList = [Select id, name,ccrz__Storefront__c,DBU_Customer_BMS_Number__c,ccrz__PaymentMethod__c,dbu_SubmitOrder_Success__c,ccrz__OrderStatus__c,dbu_Shipto__c,ccrz__ShipMethod__c,ccrz__TotalAmount__c,ccrz__TaxAmount__c,ccrz__OrderDate__c,ccrz__Account__c,ccrz__BillTo__r.ccrz__AddressFirstline__c,ccrz__ShipTo__r.ccrz__AddressFirstline__c,ccrz__BuyerLastName__c,ccrz__BuyerFirstName__c,ccrz__BuyerEmail__c,ccrz__OrderNumber__c, 
        ccrz__Account__r.Name,ccrz__Account__r.BillingStreet,ccrz__Account__r.BillingCity,ccrz__Account__r.BillingState,ccrz__Account__r.BillingPostalCode,ccrz__Account__r.BillingCountry,ccrz__Account__r.CMI_Address2__c,ccrz__Account__r.CMI_Address3__c,
        ccrz__BillTo__r.ccrz__AddressSecondline__c,ccrz__ShipTo__r.ccrz__AddressSecondline__c,ccrz__BillTo__r.ccrz__AddressThirdline__c,ccrz__ShipTo__r.ccrz__AddressThirdline__c,ccrz__ShipTo__r.ccrz__City__c,ccrz__BillTo__r.ccrz__City__c,
        ccrz__BillTo__r.ccrz__State__c,ccrz__ShipTo__r.ccrz__State__c,ccrz__ShipTo__r.ccrz__Country__c,ccrz__BillTo__r.ccrz__Country__c,ccrz__BillTo__r.ccrz__PostalCode__c,ccrz__ShipTo__r.ccrz__PostalCode__c,CreatedDate,dbu_Days_Since_Order_Date__c,
        ccrz__OriginatedCart__r.dbu_Pick_Up_From_Store__r.ccrz__AddressFirstline__c,ccrz__OriginatedCart__r.dbu_Pick_Up_From_Store__r.ccrz__AddressSecondline__c,ccrz__OriginatedCart__r.dbu_Pick_Up_From_Store__r.ccrz__AddressThirdline__c,ccrz__OriginatedCart__r.dbu_Pick_Up_From_Store__r.ccrz__City__c,ccrz__OriginatedCart__r.dbu_Pick_Up_From_Store__r.ccrz__State__c,
        ccrz__OriginatedCart__r.dbu_Pick_Up_From_Store__r.ccrz__Country__c,ccrz__OriginatedCart__r.dbu_Pick_Up_From_Store__r.ccrz__PostalCode__c,
        (Select id,Name,dbu_Shipto__c,dbu_Dropoff_Location__c,ccrz__Product__c,ccrz__Price__c,ccrz__SubAmount__c,ccrz__Product__r.ccrz__TaxRateId__c,ccrz__Product__r.ccrz__UnitOfMeasure__c,ccrz__Product__r.ccrz__Quantityperunit__c,ccrz__Order__r.ccrz__OriginatedCart__r.dbu_StoreCode__c,dbu_Selected_Return_Items__c,ccrz__Order__r.ccrz__ShipMethod__c,ccrz__AbsoluteDiscount__c,ccrz__Product__r.dbu_Has_Core_Charge__c,ccrz__Product__r.dbu_Part_Number__c,ccrz__Product__r.dbu_GenuinePart__c,ccrz__Product__r.ccrz__SKU__c,ccrz__Product__r.dbu_Product_Code__c,ccrz__ParentOrderItem__c, ccrz__Quantity__c,Vertex_Tax__c,ccrz__Order__r.ccrz__Account__c, ccrz__Order__r.name,ccrz__Order__r.ccrz__ShipAmount__c,ccrz__OrderItemStatus__c from ccrz__E_OrderItems__r),(select ccrz__TransactionSubcode__c,ccrz__TransactionCode__c from ccrz__TransactionPayments__r),ccrz__OriginatedCart__c from ccrz__E_Order__c Where dbu_SubmitOrder_Success__c = false AND ccrz__OrderStatus__c='Order Submitted' AND dbu_Is_Cloned__c =False AND ccrz__Storefront__c='CSSNAStore'];
        System.debug('orderList=====\t'+orderList[0].ccrz__E_OrderItems__r[0].dbu_Shipto__c);
        dbu_RetryOrderSubmitAPI.retunOrderOrSubmitDetails(orderList,'return');
    }
    
    
    public static testMethod void retryOrderSubmitAPITest2(){
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
       // createCart.dbu_Pick_Up_From_Store__c = createContactAddr.Id;
        insert createCart;
        ccrz__E_CartItem__c createCartItem= dbu_TestDataCreationUtility.createCartItem(createProduct.Id,createCart.Id);
        insert createCartItem;
        
        ccrz__E_Order__c createOrder= dbu_TestDataCreationUtility.createOrder(createContact.Id,createCart.Id,createContactAddr.id,createContactAddr.id);
        createOrder.ccrz__ShipMethod__c='Ship To Address';
        createOrder.ccrz__Account__c=createAccount.id;
        insert createOrder;
        ccrz__E_OrderItem__c createOrderItem= dbu_TestDataCreationUtility.createOrderItem(createOrder.Id,createProduct.Id,createCartItem.Id);
        createOrderItem.dbu_Shipto__c = false;
        createOrderItem.ccrz__AbsoluteDiscount__c=0.00;
        createOrderItem.Vertex_Tax__c=1.2;
        createOrderItem.ccrz__OrderItemStatus__c='';
        createOrderItem.dbu_Dropoff_Location__c = 'US,Canada,USA,CA,United States,California';
        insert createOrderItem;
        List<String> listOrderItemIds = New List<String>();
        listOrderItemIds.add(createOrderItem.id);
        List<ccrz__E_Order__c> orderList = new List<ccrz__E_Order__c>();
        //orderList.add(createOrder);
        dbu_IntegrationErrorLog__c errorLog = new dbu_IntegrationErrorLog__c();
        errorLog.Name='ErrorLogEmail';
        errorLog.SetToAddress__c='test2093@cumminstes.com';
        errorLog.TargetObjectId__c=Userinfo.getUserId();
        insert errorLog;
        orderList = [Select id, name,ccrz__Storefront__c,DBU_Customer_BMS_Number__c,ccrz__PaymentMethod__c,dbu_SubmitOrder_Success__c,ccrz__OrderStatus__c,dbu_Shipto__c,ccrz__ShipMethod__c,ccrz__TotalAmount__c,ccrz__TaxAmount__c,ccrz__OrderDate__c,ccrz__Account__c,ccrz__BillTo__r.ccrz__AddressFirstline__c,ccrz__ShipTo__r.ccrz__AddressFirstline__c,ccrz__BuyerLastName__c,ccrz__BuyerFirstName__c,ccrz__BuyerEmail__c,ccrz__OrderNumber__c, 
        ccrz__Account__r.Name,ccrz__Account__r.BillingStreet,ccrz__Account__r.BillingCity,ccrz__Account__r.BillingState,ccrz__Account__r.BillingPostalCode,ccrz__Account__r.BillingCountry,ccrz__Account__r.CMI_Address2__c,ccrz__Account__r.CMI_Address3__c,
        ccrz__BillTo__r.ccrz__AddressSecondline__c,ccrz__ShipTo__r.ccrz__AddressSecondline__c,ccrz__BillTo__r.ccrz__AddressThirdline__c,ccrz__ShipTo__r.ccrz__AddressThirdline__c,ccrz__ShipTo__r.ccrz__City__c,ccrz__BillTo__r.ccrz__City__c,
        ccrz__BillTo__r.ccrz__State__c,ccrz__ShipTo__r.ccrz__State__c,ccrz__ShipTo__r.ccrz__Country__c,ccrz__BillTo__r.ccrz__Country__c,ccrz__BillTo__r.ccrz__PostalCode__c,ccrz__ShipTo__r.ccrz__PostalCode__c,CreatedDate,dbu_Days_Since_Order_Date__c,
        ccrz__OriginatedCart__r.dbu_Pick_Up_From_Store__r.ccrz__AddressFirstline__c,ccrz__OriginatedCart__r.dbu_Pick_Up_From_Store__r.ccrz__AddressSecondline__c,ccrz__OriginatedCart__r.dbu_Pick_Up_From_Store__r.ccrz__AddressThirdline__c,ccrz__OriginatedCart__r.dbu_Pick_Up_From_Store__r.ccrz__City__c,ccrz__OriginatedCart__r.dbu_Pick_Up_From_Store__r.ccrz__State__c,
        ccrz__OriginatedCart__r.dbu_Pick_Up_From_Store__r.ccrz__Country__c,ccrz__OriginatedCart__r.dbu_Pick_Up_From_Store__r.ccrz__PostalCode__c,
        (Select id,Name,dbu_Shipto__c,dbu_Dropoff_Location__c,ccrz__Product__c,ccrz__Price__c,ccrz__SubAmount__c,ccrz__Product__r.ccrz__TaxRateId__c,ccrz__Product__r.ccrz__UnitOfMeasure__c,ccrz__Product__r.ccrz__Quantityperunit__c,ccrz__Order__r.ccrz__OriginatedCart__r.dbu_StoreCode__c,dbu_Selected_Return_Items__c,ccrz__Order__r.ccrz__ShipMethod__c,ccrz__AbsoluteDiscount__c,ccrz__Product__r.dbu_Has_Core_Charge__c,ccrz__Product__r.dbu_Part_Number__c,ccrz__Product__r.dbu_GenuinePart__c,ccrz__Product__r.ccrz__SKU__c,ccrz__Product__r.dbu_Product_Code__c,ccrz__ParentOrderItem__c, ccrz__Quantity__c,Vertex_Tax__c,ccrz__Order__r.ccrz__Account__c, ccrz__Order__r.name,ccrz__Order__r.ccrz__ShipAmount__c,ccrz__OrderItemStatus__c from ccrz__E_OrderItems__r),(select ccrz__TransactionSubcode__c,ccrz__TransactionCode__c from ccrz__TransactionPayments__r),ccrz__OriginatedCart__c from ccrz__E_Order__c Where dbu_SubmitOrder_Success__c = false AND ccrz__OrderStatus__c='Order Submitted' AND dbu_Is_Cloned__c =False AND ccrz__Storefront__c='CSSNAStore'];
        
        dbu_RetryOrderSubmitAPI.retunOrderOrSubmitDetails(orderList,'submit');
        dbu_RetryOrderSubmitAPI.retunOrderOrSubmitDetails(orderList,'return');
    }
    
    public static testMethod void retryOrderSubmitAPITest3(){
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
       // createCart.dbu_Pick_Up_From_Store__c = createContactAddr.Id;
        insert createCart;
        ccrz__E_CartItem__c createCartItem= dbu_TestDataCreationUtility.createCartItem(createProduct.Id,createCart.Id);
        insert createCartItem;
        ccrz__E_Order__c createOrder= dbu_TestDataCreationUtility.createOrder(createContact.Id,createCart.Id,createContactAddr.id,createContactAddr.id);
        createOrder.ccrz__ShipMethod__c='Pick Up';
        createOrder.ccrz__Account__c=createAccount.id;
        insert createOrder;
        ccrz__E_OrderItem__c createOrderItem= dbu_TestDataCreationUtility.createOrderItem(createOrder.Id,createProduct.Id,createCartItem.Id);
        createOrderItem.dbu_Shipto__c = false;
        createOrderItem.ccrz__AbsoluteDiscount__c=0.00;
        createOrderItem.Vertex_Tax__c=1.2;
        createOrderItem.ccrz__OrderItemStatus__c='';
        createOrderItem.dbu_Dropoff_Location__c = 'US,Canada,USA,CA,United States,California';
        insert createOrderItem;
        List<String> listOrderItemIds = New List<String>();
        listOrderItemIds.add(createOrderItem.id);
        List<ccrz__E_Order__c> orderList = new List<ccrz__E_Order__c>();
        //orderList.add(createOrder);
        dbu_IntegrationErrorLog__c errorLog = new dbu_IntegrationErrorLog__c();
        errorLog.Name='ErrorLogEmail';//Added code with labels to replace special characters
        errorLog.SetToAddress__c='test2093@cumminstes.com';
        errorLog.TargetObjectId__c=Userinfo.getUserId();
        insert errorLog;
        orderList = [Select id, name,ccrz__Storefront__c,DBU_Customer_BMS_Number__c,ccrz__PaymentMethod__c,dbu_SubmitOrder_Success__c,ccrz__OrderStatus__c,dbu_Shipto__c,ccrz__ShipMethod__c,ccrz__TotalAmount__c,ccrz__TaxAmount__c,ccrz__OrderDate__c,ccrz__Account__c,ccrz__BillTo__r.ccrz__AddressFirstline__c,ccrz__ShipTo__r.ccrz__AddressFirstline__c,ccrz__BuyerLastName__c,ccrz__BuyerFirstName__c,ccrz__BuyerEmail__c,ccrz__OrderNumber__c, 
        ccrz__Account__r.Name,ccrz__Account__r.BillingStreet,ccrz__Account__r.BillingCity,ccrz__Account__r.BillingState,ccrz__Account__r.BillingPostalCode,ccrz__Account__r.BillingCountry,ccrz__Account__r.CMI_Address2__c,ccrz__Account__r.CMI_Address3__c,
        ccrz__BillTo__r.ccrz__AddressSecondline__c,ccrz__ShipTo__r.ccrz__AddressSecondline__c,ccrz__BillTo__r.ccrz__AddressThirdline__c,ccrz__ShipTo__r.ccrz__AddressThirdline__c,ccrz__ShipTo__r.ccrz__City__c,ccrz__BillTo__r.ccrz__City__c,
        ccrz__BillTo__r.ccrz__State__c,ccrz__ShipTo__r.ccrz__State__c,ccrz__ShipTo__r.ccrz__Country__c,ccrz__BillTo__r.ccrz__Country__c,ccrz__BillTo__r.ccrz__PostalCode__c,ccrz__ShipTo__r.ccrz__PostalCode__c,CreatedDate,dbu_Days_Since_Order_Date__c,
        ccrz__OriginatedCart__r.dbu_Pick_Up_From_Store__r.ccrz__AddressFirstline__c,ccrz__OriginatedCart__r.dbu_Pick_Up_From_Store__r.ccrz__AddressSecondline__c,ccrz__OriginatedCart__r.dbu_Pick_Up_From_Store__r.ccrz__AddressThirdline__c,ccrz__OriginatedCart__r.dbu_Pick_Up_From_Store__r.ccrz__City__c,ccrz__OriginatedCart__r.dbu_Pick_Up_From_Store__r.ccrz__State__c,
        ccrz__OriginatedCart__r.dbu_Pick_Up_From_Store__r.ccrz__Country__c,ccrz__OriginatedCart__r.dbu_Pick_Up_From_Store__r.ccrz__PostalCode__c,
        (Select id,Name,dbu_Shipto__c,dbu_Dropoff_Location__c,ccrz__Product__c,ccrz__Price__c,ccrz__SubAmount__c,ccrz__Product__r.ccrz__TaxRateId__c,ccrz__Product__r.ccrz__UnitOfMeasure__c,ccrz__Product__r.ccrz__Quantityperunit__c,ccrz__Order__r.ccrz__OriginatedCart__r.dbu_StoreCode__c,dbu_Selected_Return_Items__c,ccrz__Order__r.ccrz__ShipMethod__c,ccrz__AbsoluteDiscount__c,ccrz__Product__r.dbu_Has_Core_Charge__c,ccrz__Product__r.dbu_Part_Number__c,ccrz__Product__r.dbu_GenuinePart__c,ccrz__Product__r.ccrz__SKU__c,ccrz__Product__r.dbu_Product_Code__c,ccrz__ParentOrderItem__c, ccrz__Quantity__c,Vertex_Tax__c,ccrz__Order__r.ccrz__Account__c, ccrz__Order__r.name,ccrz__Order__r.ccrz__ShipAmount__c,ccrz__OrderItemStatus__c from ccrz__E_OrderItems__r),(select ccrz__TransactionSubcode__c,ccrz__TransactionCode__c from ccrz__TransactionPayments__r),ccrz__OriginatedCart__c from ccrz__E_Order__c Where dbu_SubmitOrder_Success__c = false AND ccrz__OrderStatus__c='Order Submitted' AND dbu_Is_Cloned__c =False AND ccrz__Storefront__c='CSSNAStore'];
        
        dbu_RetryOrderSubmitAPI.retunOrderOrSubmitDetails(orderList,'submit');
        dbu_RetryOrderSubmitAPI.retunOrderOrSubmitDetails(orderList,'return');
    }

    public static testMethod void retryOrderSubmitAPITest4(){
        Id iamRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('IAM').getRecordTypeId();
        Id ContactRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('IAM').getRecordTypeId();
        Account createAccount= dbu_TestDataCreationUtility.createAccount(iamRecordTypeId);
        createAccount.BillingCountry = 'United States';
        insert createAccount;
        Contact createContact= dbu_TestDataCreationUtility.createContact(createAccount, ContactRecordTypeId);
        insert createContact;
        ccrz__E_Product__c createProduct= dbu_TestDataCreationUtility.createProduct();
        createProduct.dbu_Product_Code__c='CECO';
        insert createProduct;
        ccrz__E_ContactAddr__c createContactAddr= dbu_TestDataCreationUtility.createContactAddr();
        createContactAddr.ccrz__Country__c='United States';
        createContactAddr.ccrz__PostalCode__c='V4N3P8';
        insert createContactAddr;
         ccrz__E_Cart__c createCart= dbu_TestDataCreationUtility.createCart();
        createCart.dbu_Pick_Up_From_Store__c = createContactAddr.Id;
        insert createCart;
        ccrz__E_CartItem__c createCartItem= dbu_TestDataCreationUtility.createCartItem(createProduct.Id,createCart.Id);
        insert createCartItem;
        ccrz__E_Order__c createOrder= dbu_TestDataCreationUtility.createOrder(createContact.Id,createCart.Id,createContactAddr.id,createContactAddr.id);
        createOrder.ccrz__ShipMethod__c='Pick Up';
        createOrder.ccrz__Account__c=createAccount.id;
        insert createOrder;
        ccrz__E_OrderItem__c createOrderItem= dbu_TestDataCreationUtility.createOrderItem(createOrder.Id,createProduct.Id,createCartItem.Id);
        createOrderItem.dbu_Shipto__c = false;
        createOrderItem.ccrz__AbsoluteDiscount__c=0.00;
        createOrderItem.Vertex_Tax__c=1.2;
        createOrderItem.ccrz__OrderItemStatus__c='';
        createOrderItem.dbu_Dropoff_Location__c = 'US,Canada,USA,CA,United States,California';
        insert createOrderItem;
        List<String> listOrderItemIds = New List<String>();
        listOrderItemIds.add(createOrderItem.id);
        List<ccrz__E_Order__c> orderList = new List<ccrz__E_Order__c>();
        //orderList.add(createOrder);
        dbu_IntegrationErrorLog__c errorLog = new dbu_IntegrationErrorLog__c();
        errorLog.Name='ErrorLogEmail';//Added code with labels to replace special characters
        errorLog.SetToAddress__c='test2093@cumminstes.com';
        errorLog.TargetObjectId__c=Userinfo.getUserId();
        insert errorLog;
        orderList = [Select id, name,ccrz__Storefront__c,DBU_Customer_BMS_Number__c,ccrz__PaymentMethod__c,dbu_SubmitOrder_Success__c,ccrz__OrderStatus__c,dbu_Shipto__c,ccrz__ShipMethod__c,ccrz__TotalAmount__c,ccrz__TaxAmount__c,ccrz__OrderDate__c,ccrz__Account__c,ccrz__BillTo__r.ccrz__AddressFirstline__c,ccrz__ShipTo__r.ccrz__AddressFirstline__c,ccrz__BuyerLastName__c,ccrz__BuyerFirstName__c,ccrz__BuyerEmail__c,ccrz__OrderNumber__c, 
        ccrz__Account__r.Name,ccrz__Account__r.BillingStreet,ccrz__Account__r.BillingCity,ccrz__Account__r.BillingState,ccrz__Account__r.BillingPostalCode,ccrz__Account__r.BillingCountry,ccrz__Account__r.CMI_Address2__c,ccrz__Account__r.CMI_Address3__c,
        ccrz__BillTo__r.ccrz__AddressSecondline__c,ccrz__ShipTo__r.ccrz__AddressSecondline__c,ccrz__BillTo__r.ccrz__AddressThirdline__c,ccrz__ShipTo__r.ccrz__AddressThirdline__c,ccrz__ShipTo__r.ccrz__City__c,ccrz__BillTo__r.ccrz__City__c,
        ccrz__BillTo__r.ccrz__State__c,ccrz__ShipTo__r.ccrz__State__c,ccrz__ShipTo__r.ccrz__Country__c,ccrz__BillTo__r.ccrz__Country__c,ccrz__BillTo__r.ccrz__PostalCode__c,ccrz__ShipTo__r.ccrz__PostalCode__c,CreatedDate,dbu_Days_Since_Order_Date__c,
        ccrz__OriginatedCart__r.dbu_Pick_Up_From_Store__r.ccrz__AddressFirstline__c,ccrz__OriginatedCart__r.dbu_Pick_Up_From_Store__r.ccrz__AddressSecondline__c,ccrz__OriginatedCart__r.dbu_Pick_Up_From_Store__r.ccrz__AddressThirdline__c,ccrz__OriginatedCart__r.dbu_Pick_Up_From_Store__r.ccrz__City__c,ccrz__OriginatedCart__r.dbu_Pick_Up_From_Store__r.ccrz__State__c,
        ccrz__OriginatedCart__r.dbu_Pick_Up_From_Store__r.ccrz__Country__c,ccrz__OriginatedCart__r.dbu_Pick_Up_From_Store__r.ccrz__PostalCode__c,
        (Select id,Name,dbu_Shipto__c,dbu_Dropoff_Location__c,ccrz__Product__c,ccrz__Price__c,ccrz__SubAmount__c,ccrz__Product__r.ccrz__TaxRateId__c,ccrz__Product__r.ccrz__UnitOfMeasure__c,ccrz__Product__r.ccrz__Quantityperunit__c,ccrz__Order__r.ccrz__OriginatedCart__r.dbu_StoreCode__c,dbu_Selected_Return_Items__c,ccrz__Order__r.ccrz__ShipMethod__c,ccrz__AbsoluteDiscount__c,ccrz__Product__r.dbu_Has_Core_Charge__c,ccrz__Product__r.dbu_Part_Number__c,ccrz__Product__r.dbu_GenuinePart__c,ccrz__Product__r.ccrz__SKU__c,ccrz__Product__r.dbu_Product_Code__c,ccrz__ParentOrderItem__c, ccrz__Quantity__c,Vertex_Tax__c,ccrz__Order__r.ccrz__Account__c, ccrz__Order__r.name,ccrz__Order__r.ccrz__ShipAmount__c,ccrz__OrderItemStatus__c from ccrz__E_OrderItems__r),(select ccrz__TransactionSubcode__c,ccrz__TransactionCode__c from ccrz__TransactionPayments__r),ccrz__OriginatedCart__c from ccrz__E_Order__c Where dbu_SubmitOrder_Success__c = false AND ccrz__OrderStatus__c='Order Submitted' AND dbu_Is_Cloned__c =False AND ccrz__Storefront__c='CSSNAStore'];
        
        dbu_RetryOrderSubmitAPI.retunOrderOrSubmitDetails(orderList,'submit');
        dbu_RetryOrderSubmitAPI.retunOrderOrSubmitDetails(orderList,'return');
    }
}//Prod Deployment 23-09-2022