@isTest
public class dbu_ViewInvoiceDetails_Test 
{
    
    public static testMethod void Invoicewrapper(){
        // Deployment Comment
        Id iamRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('IAM').getRecordTypeId();
        Id ContactRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('IAM').getRecordTypeId();
        Account createAccount= dbu_TestDataCreationUtility.createAccount(iamRecordTypeId);
        insert createAccount;
        Contact createContact= dbu_TestDataCreationUtility.createContact(createAccount, ContactRecordTypeId);
        insert createContact;
        ccrz__E_ContactAddr__c createContactAddr= dbu_TestDataCreationUtility.createContactAddr();
        insert createContactAddr;
        ccrz__E_ContactAddr__c createContactAddr1= dbu_TestDataCreationUtility.createContactAddr1();
        insert createContactAddr1;
        ccrz__E_Product__c createProduct= dbu_TestDataCreationUtility.createProduct();
        insert createProduct;
        ccrz__E_Cart__c createCart= dbu_TestDataCreationUtility.createCart();
        createCart.ccrz__ShipTo__c = createContactAddr.Id;
        insert createCart;
        ccrz__E_CartItem__c createCartItem= dbu_TestDataCreationUtility.createCartItem(createProduct.Id,createCart.Id);
        insert createCartItem;
        
        ccrz__E_Order__c createOrder= dbu_TestDataCreationUtility.createOrder(createContact.Id,createCart.Id,createContactAddr.id,createContactAddr1.id);
        createOrder.ccrz__User__c = UserInfo.getUserId();
        createOrder.ccrz__Account__c = createAccount.Id;
        createOrder.ccrz__TotalDiscount__c = 20;
        createOrder.ccrz__TaxAmount__c = 14;
        createOrder.ccrz__ShipAmount__c = 40;
        insert createOrder;
        ccrz__E_OrderItem__c createOrderItem= dbu_TestDataCreationUtility.createOrderItem(createOrder.Id,createProduct.Id,createCartItem.Id);
        
        insert createOrderItem;
        List<String> listOrderIds = New List<String>();
        listOrderIds.add(createOrder.id);
        ccrz__E_TransactionPayment__c createTransPayment= dbu_TestDataCreationUtility.createTransactionPayment(createOrder.Id);
        insert createTransPayment;
        ccrz__E_ProductMedia__c createProductMedia=dbu_TestDataCreationUtility.createProductMedia(createProduct.Id);
        insert createProductMedia;
        
        ccrz__E_Invoice__c invoice = new ccrz__E_Invoice__c();
        invoice.ccrz__CCOrder__c = createOrder.Id;
        invoice.ccrz__Contact__c = createContact.Id;
        invoice.ccrz__User__c = UserInfo.getUserId();
        invoice.ccrz__BillTo__c = createAccount.Id;
        invoice.ccrz__SoldTo__c = createAccount.Id;
        invoice.ccrz__CurrencyCode__c = 'USD';
        invoice.ccrz__DateIssued__c = System.today();
        invoice.ccrz__DateDue__c = System.today();
        invoice.ccrz__OriginalAmount__c = 500;
        invoice.ccrz__RemainingAmount__c = 0.00;
        invoice.ccrz__Storefront__c = 'CSSNAStore';
        
        insert invoice;
        
        ccrz__E_InvoiceItem__c invoiceItem_Item = new ccrz__E_InvoiceItem__c();
        invoiceItem_Item.ccrz__OriginalAmount__c = 500;
        invoiceItem_Item.ccrz__Invoice__c = invoice.Id;
        invoiceItem_Item.ccrz__CCOrderItem__c = createOrderItem.Id;
        invoiceItem_Item.ccrz__CCOrder__c = createOrder.Id;
        invoiceItem_Item.Quantity__c = 1;
        invoiceItem_Item.ccrz__Status__c = 'Open';
        invoiceItem_Item.ccrz__Type__c = 'Item';
        insert invoiceItem_Item;
        
        System.currentPageReference().getParameters().put('orderId', createOrder.Id);
        dbu_ViewInvoiceDetails  obj = new dbu_ViewInvoiceDetails();
        dbu_ViewInvoiceDetails.viewInvoiceData('https://csodev-cumminscss.cs90.force.com/CSSNAStore/s/invoice?orderid='+createOrder.Id);
       
    }
    
public static testMethod void Invoicewrapper2(){
        // Deployment Comment
        Id iamRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('IAM').getRecordTypeId();
        Id ContactRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('IAM').getRecordTypeId();
        Account createAccount= dbu_TestDataCreationUtility.createAccount(iamRecordTypeId);
        insert createAccount;
        Contact createContact= dbu_TestDataCreationUtility.createContact(createAccount, ContactRecordTypeId);
        insert createContact;
        ccrz__E_Product__c createProduct= dbu_TestDataCreationUtility.createProduct();
        insert createProduct;
        ccrz__E_ContactAddr__c createContactAddr= dbu_TestDataCreationUtility.createContactAddr();
    	createContactAddr.ccrz__AddressSecondline__c = 'Novi Pazar';
        insert createContactAddr;
        ccrz__E_ContactAddr__c createContactAddr1= dbu_TestDataCreationUtility.createContactAddr1();
        insert createContactAddr1;    
        ccrz__E_Cart__c createCart= dbu_TestDataCreationUtility.createCart();
    	createCart.dbu_Pick_Up_From_Store__c = createContactAddr.id;
        insert createCart;
        ccrz__E_CartItem__c createCartItem= dbu_TestDataCreationUtility.createCartItem(createProduct.Id,createCart.Id);
        insert createCartItem;

        ccrz__E_Order__c createOrder= dbu_TestDataCreationUtility.createOrder(createContact.Id,createCart.Id,createContactAddr.id,createContactAddr1.id);
        createOrder.ccrz__User__c = UserInfo.getUserId();
        createOrder.ccrz__Account__c = createAccount.Id;
        createOrder.ccrz__TotalDiscount__c = 20;
        createOrder.ccrz__TaxAmount__c = 14;
        createOrder.ccrz__ShipAmount__c = 40;
    	createOrder.ccrz__ShipMethod__c = 'Pick Up';
        insert createOrder;
        ccrz__E_OrderItem__c createOrderItem= dbu_TestDataCreationUtility.createOrderItem(createOrder.Id,createProduct.Id,createCartItem.Id);
        
        insert createOrderItem;
        List<String> listOrderIds = New List<String>();
        listOrderIds.add(createOrder.id);
        ccrz__E_TransactionPayment__c createTransPayment= dbu_TestDataCreationUtility.createTransactionPayment(createOrder.Id);
        insert createTransPayment;
        ccrz__E_ProductMedia__c createProductMedia=dbu_TestDataCreationUtility.createProductMedia(createProduct.Id);
        insert createProductMedia;
        
        ccrz__E_Invoice__c invoice = new ccrz__E_Invoice__c();
        invoice.ccrz__CCOrder__c = createOrder.Id;
        invoice.ccrz__Contact__c = createContact.Id;
        invoice.ccrz__User__c = UserInfo.getUserId();
        invoice.ccrz__BillTo__c = createAccount.Id;
        invoice.ccrz__SoldTo__c = createAccount.Id;
        invoice.ccrz__CurrencyCode__c = 'USD';
        invoice.ccrz__DateIssued__c = System.today();
        invoice.ccrz__DateDue__c = System.today();
        invoice.ccrz__OriginalAmount__c = 500;
        invoice.ccrz__RemainingAmount__c = 0.00;
        invoice.ccrz__Storefront__c = 'CSSNAStore';
        
        insert invoice;
        
        ccrz__E_InvoiceItem__c invoiceItem_Item = new ccrz__E_InvoiceItem__c();
        invoiceItem_Item.ccrz__OriginalAmount__c = 500;
        invoiceItem_Item.ccrz__Invoice__c = invoice.Id;
        invoiceItem_Item.ccrz__CCOrderItem__c = createOrderItem.Id;
        invoiceItem_Item.ccrz__CCOrder__c = createOrder.Id;
        invoiceItem_Item.Quantity__c = 1;
        invoiceItem_Item.ccrz__Status__c = 'Open';
        invoiceItem_Item.ccrz__Type__c = 'Item';
        insert invoiceItem_Item;
        
        System.currentPageReference().getParameters().put('orderId', createOrder.Id);
        dbu_ViewInvoiceDetails  obj = new dbu_ViewInvoiceDetails();
        dbu_ViewInvoiceDetails.viewInvoiceData('https://csodev-cumminscss.cs90.force.com/CSSNAStore/s/invoice?orderid='+createOrder.Id);
       
    }    
}