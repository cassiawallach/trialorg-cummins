@isTest
public class dbu_orderProductDetailsEmailCtrl_Test 
{
    public static testMethod void getPaypalPayment(){
        Id iamRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('IAM').getRecordTypeId();
        Id ContactRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('IAM').getRecordTypeId();
        Account createAccount= dbu_TestDataCreationUtility.createAccount(iamRecordTypeId);
        insert createAccount;
        Contact createContact= dbu_TestDataCreationUtility.createContact(createAccount, ContactRecordTypeId);
        insert createContact;
        ccrz__E_Product__c createProduct= dbu_TestDataCreationUtility.createProduct();
        insert createProduct;
        ccrz__E_Cart__c createCart= dbu_TestDataCreationUtility.createCart();
        createCart.dbu_storeLanguage__c = 'US';
        insert createCart;
        ccrz__E_CartItem__c createCartItem= dbu_TestDataCreationUtility.createCartItem(createProduct.Id,createCart.Id);
        insert createCartItem;
        ccrz__E_ContactAddr__c createContactAddr= dbu_TestDataCreationUtility.createContactAddr();
        insert createContactAddr;
        ccrz__E_ContactAddr__c createContactAddr1= dbu_TestDataCreationUtility.createContactAddr1();
        insert createContactAddr1;
        ccrz__E_Order__c createOrder= dbu_TestDataCreationUtility.createOrder(createContact.Id,createCart.Id,createContactAddr.id,createContactAddr1.id);
        createOrder.ccrz__User__c = UserInfo.getUserId();
        createOrder.ccrz__PaymentMethod__c = 'PayPal';
        createOrder.dbu_BMS_Tracking_Number__c = '111,112';
        insert createOrder;
        ccrz__E_OrderItem__c createOrderItem= dbu_TestDataCreationUtility.createOrderItem(createOrder.Id,createProduct.Id,createCartItem.Id);
        insert createOrderItem;
        List<String> listOrderIds = New List<String>();
        listOrderIds.add(createOrder.id);
        ccrz__E_TransactionPayment__c createTransPayment= dbu_TestDataCreationUtility.createTransactionPayment(createOrder.Id);
        insert createTransPayment;
        ccrz__E_ProductMedia__c createProductMedia=dbu_TestDataCreationUtility.createProductMedia(createProduct.Id);
        insert createProductMedia;
        

        ccrz__E_Cart__c objCart = new ccrz__E_Cart__c();
        objCart.dbu_StoreCode__c = 'test';
        objCart.Id = createCart.Id;
        update objCart;
        
        dbu_orderProductDetailsEmailController objCls = new dbu_orderProductDetailsEmailController();
        objCls.orderId = createOrder.Id;
        List<dbu_orderProductDetailsEmailController.orderItemWrapper> getOrderItems = objCls.getOrderItems();
        List<dbu_orderProductDetailsEmailController.orderItemWrapper> getOrderItemsPickup = objCls.getOrderItemsPickup();
        List<dbu_orderProductDetailsEmailController.orderItemWrapper> getAllOrderItems = objCls.getAllOrderItems();
        dbu_orderProductDetailsEmailController.TrackingNumberWrapper getTrackingNumber = objCls.getTrackingNumber();
   
    }
    public static testMethod void getPaypalPaymentEN(){
        Id iamRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('IAM').getRecordTypeId();
        Id ContactRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('IAM').getRecordTypeId();
        Account createAccount= dbu_TestDataCreationUtility.createAccount(iamRecordTypeId);
        insert createAccount;
        Contact createContact= dbu_TestDataCreationUtility.createContact(createAccount, ContactRecordTypeId);
        insert createContact;
        ccrz__E_Product__c createProduct= dbu_TestDataCreationUtility.createProduct();
        insert createProduct;
        ccrz__E_Cart__c createCart= dbu_TestDataCreationUtility.createCart();
        createCart.dbu_storeLanguage__c = 'EN';
        insert createCart;
        ccrz__E_CartItem__c createCartItem= dbu_TestDataCreationUtility.createCartItem(createProduct.Id,createCart.Id);
        insert createCartItem;
        ccrz__E_ContactAddr__c createContactAddr= dbu_TestDataCreationUtility.createContactAddr();
        insert createContactAddr;
        ccrz__E_ContactAddr__c createContactAddr1= dbu_TestDataCreationUtility.createContactAddr1();
        insert createContactAddr1;
        ccrz__E_Order__c createOrder= dbu_TestDataCreationUtility.createOrder(createContact.Id,createCart.Id,createContactAddr.id,createContactAddr1.id);
        createOrder.ccrz__User__c = UserInfo.getUserId();
        createOrder.ccrz__PaymentMethod__c = 'PayPal';
        createOrder.dbu_BMS_Tracking_Number__c = '111,112';
        insert createOrder;
        ccrz__E_OrderItem__c createOrderItem= dbu_TestDataCreationUtility.createOrderItem(createOrder.Id,createProduct.Id,createCartItem.Id);
        insert createOrderItem;
        List<String> listOrderIds = New List<String>();
        listOrderIds.add(createOrder.id);
        ccrz__E_TransactionPayment__c createTransPayment= dbu_TestDataCreationUtility.createTransactionPayment(createOrder.Id);
        insert createTransPayment;
        ccrz__E_ProductMedia__c createProductMedia=dbu_TestDataCreationUtility.createProductMedia(createProduct.Id);
        insert createProductMedia;
        

        ccrz__E_Cart__c objCart = new ccrz__E_Cart__c();
        objCart.dbu_StoreCode__c = 'test';
        objCart.Id = createCart.Id;
        update objCart;
        
        dbu_orderProductDetailsEmailController objCls = new dbu_orderProductDetailsEmailController();
        objCls.orderId = createOrder.Id;
        List<dbu_orderProductDetailsEmailController.orderItemWrapper> getOrderItems = objCls.getOrderItems();
        List<dbu_orderProductDetailsEmailController.orderItemWrapper> getOrderItemsPickup = objCls.getOrderItemsPickup();
        List<dbu_orderProductDetailsEmailController.orderItemWrapper> getAllOrderItems = objCls.getAllOrderItems();
        dbu_orderProductDetailsEmailController.TrackingNumberWrapper getTrackingNumber = objCls.getTrackingNumber();
   
    }
}