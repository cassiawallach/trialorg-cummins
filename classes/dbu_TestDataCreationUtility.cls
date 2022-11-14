@isTest
public class dbu_TestDataCreationUtility
{
    public static ccrz__E_Product__c createProduct()
    {
        ccrz__E_Product__c prodObj = new ccrz__E_Product__c();
        prodObj.Name = 'Test DBU 3684450PUMP,WATER';
        prodObj.ccrz__SKU__c = '1234567';
        prodObj.ccrz__Quantityperunit__c = 1.00;
        prodObj.ccrz__ProductType__c = 'Product';
        prodObj.ccrz__UnitOfMeasure__c = 'Each';
        prodObj.ccrz__ProductIndexStatus__c = 'Not Current';
        prodObj.ccrz__Storefront__c = 'CSSNAStore';
        prodObj.ccrz__ProductStatus__c = 'Released';
        prodObj.Group_Name__c = 'Ecom';
        prodObj.dbu_Product_Status__c = 'In Stock';
        prodObj.ccrz__InventoryType__c = 'STANDARD';
        //insert prodObj;
        return prodObj;
    }
    public static ccrz__E_Cart__c createCart()
    {
        ccrz__E_Cart__c cartObj = new ccrz__E_Cart__c();
        cartObj.ccrz__Name__c = 'My Cart';
        cartObj.ccrz__CartType__c = 'Cart';
        cartObj.ccrz__CurrencyISOCode__c = 'USD';
        cartObj.ccrz__ShipMethod__c = 'Ship to address';
        cartObj.ccrz__Storefront__c = 'CSSNAStore';
        cartObj.ccrz__CartStatus__c = 'Closed';
        cartObj.ccrz__BuyerFirstName__c = 'DBUEcom';
        cartObj.ccrz__BuyerLastName__c = 'Testing';
        cartObj.ccrz__BuyerEmail__c = 'test@test.com';
        cartObj.ccrz__BuyerPhone__c = '9999911111';
        //insert cartObj;
        return cartObj;
    }
    public static ccrz__E_CartItem__c createCartItem(Id prodObjId, Id cartObjId)
    {
        ccrz__E_CartItem__c cartItemObj = new ccrz__E_CartItem__c();
        cartItemObj.ccrz__Price__c = 10.00;
        cartItemObj.ccrz__Quantity__c = 5;
        cartItemObj.ccrz__SubAmount__c = 50.00;
        cartItemObj.ccrz__cartItemType__c = 'Major';
        cartItemObj.ccrz__StoreID__c = 'CSSNAStore';
        cartItemObj.ccrz__ProductType__c = 'Product';
        cartItemObj.ccrz__Product__c = prodObjId;
        cartItemObj.ccrz__Cart__c = cartObjId;
        //insert cartItemObj;
        return cartItemObj;
    }
    public static Account createAccount( Id AccountRecordType)
    {
        Account objAccount =   new Account();
        objAccount.Name =   'CSSNA Store Account';
        objAccount.Type  =   'Customer';
        objAccount.CMI_Account_Status__c = 'Active';
        objAccount.IAM_WWSPS_Regions__c = 'US and Canada';
        objAccount.ERP_System__c =   'No ERP System';
        objAccount.IA_CSSEnabled__c =   true;
        objAccount.BillingCountry =  'United States';
        objAccount.ShippingCountry =  'United States';
        objAccount.RecordTypeId =   AccountRecordType;
        return objAccount;
    }
    public static Contact createContact(Account AccountID, Id iamRecordTypeId)
    {
        //Id iamRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('IAM').getRecordTypeId();
        //ccrz__E_Product__c product = TestingUtils.createCompositeProduct();
        Contact contactObj = new Contact();
        contactObj.Account = AccountID;
        contactObj.FirstName = 'DBUEcom';
        contactObj.LastName = 'Test';
        contactObj.Email = 'test@test.com';
        contactObj.Username__c  = 'mukesh@test.com';
        contactObj.IAM_Contact_Status__c = 'Active';
        contactObj.RecordTypeId = iamRecordTypeId;
       //insert contactObj;
        return contactObj;
    }
    public static ccrz__E_Order__c createOrder(Id contactObjId, Id cartId, Id billingAddr,Id shippingAddr)
    {
        ccrz__E_Order__c orderObj = new ccrz__E_Order__c();
        orderObj.ccrz__Name__c = 'My Cart';
        orderObj.ccrz__OrderNumber__c = 1253656;
        orderObj.ccrz__Storefront__c = 'CSSNAStore';
        orderObj.ccrz__OrderStatus__c = 'Order Submitted';
        orderObj.ccrz__CurrencyISOCode__c = 'USD';
        orderObj.ccrz__BuyerFirstName__c = 'DBUEcom';
        orderObj.ccrz__BuyerLastName__c = 'TestData';
        orderObj.ccrz__BuyerEmail__c = 'test@test.com';
        orderObj.ccrz__BuyerPhone__c = '9999911111';
        orderObj.ccrz__Contact__c = contactObjId;
        orderObj.ccrz__OrderDate__c= System.today();
        orderObj.ccrz__Storefront__c ='CSSNAStore';
        orderObj.ccrz__OriginatedCart__c=cartId;
        orderObj.ccrz__BillTo__c =billingAddr;
        orderObj.ccrz__ShipTo__c =shippingAddr;
        //insert orderObj;
        return orderObj;
    }
    public static ccrz__E_OrderItem__c createOrderItem(Id orderObjId,Id prodObjId,Id cartItemObjId)
    {
        ccrz__E_OrderItem__c orderItemObj = new ccrz__E_OrderItem__c();
        orderItemObj.ccrz__Price__c = 10.00;
        orderItemObj.ccrz__Quantity__c = 5;
        orderItemObj.ccrz__SubAmount__c = 50.00;
        orderItemObj.ccrz__StoreId__c = 'CSSNAStore';
        orderItemObj.ccrz__OrderItemStatus__c = 'Order Submitted';
        orderItemObj.ccrz__Order__c = orderObjId;
        orderItemObj.ccrz__Product__c = prodObjId;
        orderItemObj.ccrz__OrderItemId__c = cartItemObjId;
        //insert orderItemObj;
        return orderItemObj;
    }
    public static ccrz__E_TransactionPayment__c createTransactionPayment(Id orderObjId)
    {
        ccrz__E_TransactionPayment__c  transPayment = new ccrz__E_TransactionPayment__c();
        transPayment.ccrz__AccountType__c = 'DBUCom Reseller';
        transPayment.ccrz__TransactionType__c= 'PAYPAL';
        transPayment.ccrz__Storefront__c = 'CSSNAStore';
        transPayment.ccrz__CCOrder__c = orderObjId;
        transPayment.ccrz__PaymentType__c= 'PAYPAL';
        transPayment.ccrz__AccountNumber__c='4111111111111111';
        transPayment.ccrz__Amount__c=350.20;
        return transPayment;
    }
    public static ccrz__E_ContactAddr__c createContactAddr()
    {
        ccrz__E_ContactAddr__c  contactAddr = new ccrz__E_ContactAddr__c();
        contactAddr.ccrz__FirstName__c= 'DBUCom';
        contactAddr.ccrz__LastName__c= 'Reseller';
        contactAddr.ccrz__AddressFirstline__c = '6301 BROADWAY';
        contactAddr.ccrz__City__c= 'DENVER';
        contactAddr.ccrz__State__c='CO';
        contactAddr.ccrz__Country__c='US';
        contactAddr.ccrz__PostalCode__c='80216-1034';
        contactAddr.ccrz__ShippingComments__c='Shipping Comments';
        return contactAddr;
    }
    public static ccrz__E_ContactAddr__c createContactAddr1()
    {
        ccrz__E_ContactAddr__c  contactAddr = new ccrz__E_ContactAddr__c();
        contactAddr.ccrz__FirstName__c= 'DBUCom';
        contactAddr.ccrz__LastName__c= 'Reseller';
        contactAddr.ccrz__AddressFirstline__c = '6301 BROADWAY';
        contactAddr.ccrz__City__c= 'DENVER';
        contactAddr.ccrz__State__c='CO';
        contactAddr.ccrz__Country__c='US';
        contactAddr.ccrz__PostalCode__c='80216-1034';
        contactAddr.ccrz__ShippingComments__c='Billing Comments';
        return contactAddr;
    }
    public static ccrz__E_ProductMedia__c createProductMedia(Id productId)
    {
        ccrz__E_ProductMedia__c productMedia = new ccrz__E_ProductMedia__c();
        productMedia.ccrz__Product__c= productId;
        productMedia.ccrz__Enabled__c= True;
        productMedia.ccrz__EndDate__c = system.today()+90;
        productMedia.ccrz__StartDate__c= system.today()-1;
        productMedia.ccrz__MediaType__c='Product Image';
        productMedia.ccrz__ProductMediaSource__c='URI';
        productMedia.ccrz__URI__c='https://cssna-parts.gdc-rad.com/3684200.png';
        productMedia.ccrz__Locale__c='en_US';
        return productMedia;
    }
    
}