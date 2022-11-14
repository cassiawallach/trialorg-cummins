@isTest
public class dbu_CallccapitoCreateOrder_Test 
{
    public static testMethod void createOrderTest(){//updated
        //added for prodeployment
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
        insert createOrder;//CHG0085464
        ccrz__E_OrderItem__c createOrderItem= dbu_TestDataCreationUtility.createOrderItem(createOrder.Id,createProduct.Id,createCartItem.Id);
        insert createOrderItem;
        //String tpdata;
        TransactionPaymentParams TPP = new TransactionPaymentParams();
        TPP.accountNumber = 'Generic Mechine - DBU Customer';
        TPP.accountType = 'DBUCom Reseller';
        //TPP.amount  = 2425;
        TPP.comments = 'India is great';
        TPP.expirationMonth = 4;
        TPP.expirationYear = 2021;
        TPP.paymentType = 'Debit Card';
        TPP.requestAmount = 2425;
        //TPP.storedPaymentId = ; 
        TPP.storefront = 'CSSNAStore';
        TPP.subAccountNumber = 'AC8499937';
        TPP.token = 'xi939sdv09ascj0zzz';
        TPP.transactionCode = 'i386';
        TPP.transactionPaymentId = 'T90S-WE';
        TPP.transactionSubcode = 'T-72QS'; 
        TPP.transactionType = 'Card PURCHASE';
        TPP.verificationCode = 'T-84-YK';
        TPP.saveAsStoredPayment = true ;
        TPP.accountName = 'Generic Mechine';
        string PARAM_TRANSACTION_DATA_INPUT_STRING = JSON.serialize(TPP);
      dbu_CallccapitoCreateOrder.CreateOrder(createCart.Id, PARAM_TRANSACTION_DATA_INPUT_STRING );
      dbu_CallccapitoCreateOrder.orderSubmitFuture(createOrder.id);
      dbu_CallccapitoCreateOrder.orderSubmitNonFuture(createOrder.id);
     }
}
//UAT Deployment