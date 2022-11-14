@isTest
public class dbu_send_Email_Test 
{
    public static testMethod void sendMail(){
        Id iamRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('IAM').getRecordTypeId();
        Id ContactRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('IAM').getRecordTypeId();
        Account createAccount= dbu_TestDataCreationUtility.createAccount(iamRecordTypeId);
        insert createAccount;
        Contact createContact= dbu_TestDataCreationUtility.createContact(createAccount, ContactRecordTypeId);
        insert createContact;
        ccrz__E_Product__c createProduct= dbu_TestDataCreationUtility.createProduct();
        insert createProduct;
        ccrz__E_Cart__c createCart= dbu_TestDataCreationUtility.createCart();
        insert createCart;
        ccrz__E_CartItem__c createCartItem= dbu_TestDataCreationUtility.createCartItem(createProduct.Id,createCart.Id);
        insert createCartItem;
        ccrz__E_ContactAddr__c createContactAddr= dbu_TestDataCreationUtility.createContactAddr();
        insert createContactAddr;
        ccrz__E_ContactAddr__c createContactAddr1= dbu_TestDataCreationUtility.createContactAddr1();
        insert createContactAddr1;
        ccrz__E_Order__c createOrder= dbu_TestDataCreationUtility.createOrder(createContact.Id,createCart.Id,createContactAddr.id,createContactAddr1.id);
        createOrder.ccrz__User__c = UserInfo.getUserId();
        insert createOrder;
        ccrz__E_OrderItem__c createOrderItem= dbu_TestDataCreationUtility.createOrderItem(createOrder.Id,createProduct.Id,createCartItem.Id);
        createOrderItem.dbu_Estimated_Return_Amount__c = 123;
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
        
        ccrz__E_Order__c obj = new ccrz__E_Order__c();
        //obj = createOrder.clone(false,false,false,false);
        insert obj;
        
       
        createOrder.CC_Order__c = obj.Id;
        update createOrder;
        
        createOrderItem.ccrz__OrderItemStatus__c = 'Return Initiated';
        createOrderItem.dbu_Is_return_mail_sent__c = false;
        update createOrderItem;
        
        
        System.debug(createOrder);
        
        
        List<Id> lstId = new List<Id>();
        lstId.add(createOrder.Id);
        
        List<ccrz__E_Order__c> listOrders = new List<ccrz__E_Order__c>();
        Map < String, List < ccrz__E_OrderItem__c >> mapOrderItemList = new Map < String, List < ccrz__E_OrderItem__c >> ();
        listOrders =[Select id,name,CC_Order__c,dbu_StoreLocationAddress__c,ccrz__User__c,ccrz__Note__c,dbu_Dropoff_Location__c,ccrz__ShipTo__c,ccrz__ShipTo__r.ccrz__FirstName__c,ccrz__ShipTo__r.ccrz__LastName__c,ccrz__ShipTo__r.ccrz__AddressFirstline__c,ccrz__ShipTo__r.ccrz__AddressSecondline__c,ccrz__ShipTo__r.ccrz__AddressThirdline__c,ccrz__ShipTo__r.ccrz__City__c,ccrz__ShipTo__r.ccrz__State__c,ccrz__ShipTo__r.ccrz__Country__c,ccrz__ShipTo__r.ccrz__PostalCode__c, ccrz__Contact__c,ccrz__BuyerFirstName__c,ccrz__BuyerLastName__c,ccrz__BuyerEmail__c,ccrz__BuyerMobilePhone__c,
        (Select id,Name,ccrz__Product__c,dbu_Estimated_Return_Amount__c,ccrz__Price__c,ccrz__AbsoluteDiscount__c,ccrz__Product_Name__c,ccrz__Product__r.dbu_GenuinePart__c,ccrz__Quantity__c,Vertex_Tax__c,dbu_Dropoff_Location__c,
        ccrz__Order__r.ccrz__Account__c, ccrz__OrderItemStatus__c,dbu_Reason_for_Return__c,ccrz__ItemTotal__c,dbu_Is_return_mail_sent__c,dbu_Shipto__c from ccrz__E_OrderItems__r where ccrz__OrderItemStatus__c = 'Return Initiated' and dbu_Is_return_mail_sent__c = false) from ccrz__E_Order__c where id IN: lstId And CC_Order__c != Null];
        
        System.debug('sssss:'+listOrders);
        
        dbu_send_Email.toSendMailForReturn(lstId);
        
        
        createOrderItem.dbu_Shipto__c = true;
        update createOrderItem;
        dbu_send_Email.toSendMailForReturn(lstId);
    }
}