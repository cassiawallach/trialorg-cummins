@isTest
public with sharing class dbu_Integration_Invoice_Test {
    // Ranadip
    private static decimal QUANTITY = 1.00;
    private static String PRODUCT_TYPE = 'Product';
    private static String UNIT_MEASURE = 'Each';
    private static String PRODUCT_INDEX_STATUS = 'Not Current';
    private static String STORE_FRONT = 'CSSNAStore';
    private static String PRODUCT_STATUS = 'Released';
    private static String GROUP_NAME = 'Ecom';
    private static String DBU_PRODUCT_STATUS = 'In Stock';
    private static String INVENTORY_TYPE = 'STANDARD';
    Private static String CART_NAME = 'TEST CART';
    private static String ORDER_STATUS = 'Order Submitted';
    private static String CURRENCY_ISO_CODE = 'USD';
    private static String BUYER_FIRST_NAME ='Test First Name';
    private static String BUYER_LAST_NAME = 'Test Last Name';
    private static String BUYER_EMAIL = 'test@test.com';
    private static String BUYER_PHONE_NO = '9999911111';
    private static String CART_TYPE = 'Cart';
    private static String SHIP_METHOD = 'Ship to address';
    private static String CART_STATUS = 'Closed';
    private static Decimal CART_ITEM_PRICE = 10.00;
    private static Decimal CART_ITEM_QUANTITY = 5;
    private static Decimal CART_ITEM_SUB_AMOUNT = 50.00;
    private static String CART_ITEM_TYPE = 'Major';
    
    public static ccrz__E_Product__c createProduct(String pName,String partNo){
        ccrz__E_Product__c prodObj = new ccrz__E_Product__c();
        prodObj.Name = pName;
        prodObj.ccrz__SKU__c = '999';
        prodObj.dbu_Part_Number__c = partNo;
        prodObj.ccrz__Quantityperunit__c = QUANTITY;
        prodObj.ccrz__ProductType__c = PRODUCT_TYPE;
        prodObj.ccrz__UnitOfMeasure__c = UNIT_MEASURE;
        prodObj.ccrz__ProductIndexStatus__c = PRODUCT_INDEX_STATUS;
        prodObj.ccrz__Storefront__c = STORE_FRONT;
        prodObj.ccrz__ProductStatus__c = DBU_PRODUCT_STATUS;
        prodObj.Group_Name__c = GROUP_NAME;
        prodObj.dbu_Product_Status__c = DBU_PRODUCT_STATUS;
        prodObj.ccrz__InventoryType__c = INVENTORY_TYPE;
        return prodObj;
    }
    public static ccrz__E_Order__c createOrder(Integer orderNo, Id conId){
        ccrz__E_Order__c OrderObj = new ccrz__E_Order__c();
        //OrderObj.Name = name;
        OrderObj.ccrz__OrderNumber__c = orderNo;
        OrderObj.ccrz__BuyerFirstName__c = BUYER_FIRST_NAME;
        OrderObj.ccrz__BuyerLastName__c = BUYER_LAST_NAME;
        OrderObj.ccrz__BuyerEmail__c = BUYER_EMAIL;
        OrderObj.ccrz__BuyerPhone__c = BUYER_PHONE_NO;
        OrderObj.ccrz__Contact__c = conId;
        return OrderObj;    
    }
    public static ccrz__E_Cart__c createCart(){
        ccrz__E_Cart__c cartObj = new ccrz__E_Cart__c();
        cartObj.ccrz__Name__c = CART_NAME;
        cartObj.ccrz__CartType__c = CART_TYPE;
        cartObj.ccrz__CurrencyISOCode__c = CURRENCY_ISO_CODE;
        cartObj.ccrz__ShipMethod__c = SHIP_METHOD;
        cartObj.ccrz__Storefront__c = STORE_FRONT;
        cartObj.ccrz__CartStatus__c = CART_STATUS;
        cartObj.ccrz__BuyerFirstName__c = BUYER_FIRST_NAME;
        cartObj.ccrz__BuyerLastName__c = BUYER_LAST_NAME;
        cartObj.ccrz__BuyerEmail__c = BUYER_EMAIL;
        cartObj.ccrz__BuyerPhone__c = BUYER_PHONE_NO;
        return cartObj;
    }
    public static ccrz__E_CartItem__c createCartItem(Id pId,Id cartId){
        ccrz__E_CartItem__c cartItemObj = new ccrz__E_CartItem__c();
        cartItemObj.ccrz__Price__c = CART_ITEM_PRICE;
        cartItemObj.ccrz__Quantity__c =CART_ITEM_QUANTITY;
        cartItemObj.ccrz__SubAmount__c =CART_ITEM_SUB_AMOUNT;
        cartItemObj.ccrz__cartItemType__c = CART_ITEM_TYPE;
        cartItemObj.ccrz__StoreID__c = STORE_FRONT;
        cartItemObj.ccrz__ProductType__c = PRODUCT_TYPE;
        cartItemObj.ccrz__Product__c = pId;
        cartItemObj.ccrz__Cart__c = cartId;
        return cartItemObj;
    }
    public static Contact crateContact(Id iamRecordTypeId){
        Contact contactObj = new Contact();
        contactObj.FirstName = BUYER_FIRST_NAME;
        contactObj.LastName = BUYER_LAST_NAME;
        contactObj.Email = BUYER_EMAIL;
        contactObj.Username__c  = 'ranadip@test.com';
        contactObj.IAM_Contact_Status__c = 'Active';
        contactObj.RecordTypeId = iamRecordTypeId;
        return contactObj;
    }
    public static ccrz__E_OrderItem__c crateOrderItem(Id orderId,Id pId,Id cartItemId){
        ccrz__E_OrderItem__c orderItemObj = new ccrz__E_OrderItem__c();
        orderItemObj.ccrz__Price__c = CART_ITEM_PRICE;
        orderItemObj.ccrz__Quantity__c = CART_ITEM_QUANTITY;
        orderItemObj.ccrz__SubAmount__c = CART_ITEM_SUB_AMOUNT;
        orderItemObj.ccrz__StoreId__c = STORE_FRONT;
        orderItemObj.ccrz__OrderItemStatus__c = ORDER_STATUS;
        orderItemObj.ccrz__Order__c = orderId;
        orderItemObj.ccrz__Product__c = pId;
        orderItemObj.ccrz__OrderItemId__c = cartItemId;
        return orderItemObj;
    }
    @isTest
    static void UpdateInvoiceTest(){
        Id iamRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('IAM').getRecordTypeId();
        //system.debug('JIO');
        // For Orignal Order
        ccrz__E_Product__c productObj =  createProduct( 'Test Product', '12345');
        insert productObj;
        ccrz__E_Cart__c cartObj =  createCart();
        insert cartObj;
        ccrz__E_CartItem__c cartItemObj =  createCartItem(productObj.Id,cartObj.Id);
        insert cartItemObj;
        Contact con =  crateContact(iamRecordTypeId);
        insert con;
        ccrz__E_Order__c originalOrderObj =  createOrder(12234455,con.Id);
        insert originalOrderObj;
        ccrz__E_OrderItem__c originalOrderItemObj =  crateOrderItem(originalOrderObj.Id,productObj.Id,cartItemObj.Id);
        insert originalOrderItemObj;
        
        //For Clone Order
        //ccrz__E_Product__c clProductObj =  createProduct( 'Test Clone Product', '123456');
        ccrz__E_Cart__c cartObjCl =  createCart();
        insert cartObjCl;
        ccrz__E_CartItem__c cartItemObjCl =  createCartItem(productObj.Id,cartObjCl.Id);
        insert cartItemObjCl;
        //Contact cont =  crateContact(iamRecordTypeId);
        ccrz__E_Order__c cloneOrderObj =  createOrder(12234466,con.Id);
        cloneOrderObj.CC_Order__c = originalOrderObj.Id;
        insert cloneOrderObj;
        ccrz__E_OrderItem__c cloneOrderItemObj =  crateOrderItem(cloneOrderObj.Id,productObj.Id,cartItemObj.Id);
        cloneOrderItemObj.dbu_CC_Order_Item__c = originalOrderItemObj.Id;
        insert cloneOrderItemObj;
        
        ccrz__E_Order__c obj = [select id, Name,ccrz__BuyerEmail__c from ccrz__E_Order__c  where id =: cloneOrderObj.id]; 
        
        List<dbu_Integration_InvoiceItem_Request> invoiceItemReqObjList = new List<dbu_Integration_InvoiceItem_Request>();
        dbu_Integration_InvoiceItem_Request invoiceItemReqObj = new dbu_Integration_InvoiceItem_Request();
        invoiceItemReqObj.CCInvoiceLineItemNumber = productObj.dbu_Part_Number__c;
        invoiceItemReqObjList.add(invoiceItemReqObj);
        
        List<dbu_Integration_Invoice_Request> invoiceReqObjList = new List<dbu_Integration_Invoice_Request>();
        dbu_Integration_Invoice_Request invoiceReqObj = new dbu_Integration_Invoice_Request();
        invoiceReqObj.BMSInvoiceDate = '2020-10-10';
        //invoiceReqObj.CCOrderId = String.valueof(cloneOrderObj.ccrz__OrderNumber__c);
        //invoiceReqObj.CCOrderId = String.valueof(cloneOrderObj.Name);
        invoiceReqObj.CCOrderId = obj.Name;
        invoiceReqObj.BMSInvoiceNumber = '123456789';
        invoiceReqObj.CCInvoiceLineItemId = invoiceItemReqObjList;
        invoiceReqObj.CCOrderShippingStatus = 'Shipped';
        invoiceReqObj.CCOrderShippingTrackingNumber = '123456789';
        invoiceReqObjList.add(invoiceReqObj);
        
        Test.startTest();
        dbu_Integration_Invoice.UpdateInvoice(invoiceReqObjList);
        Test.stopTest();
        
    }
}
//UAT Deployment