@isTest
public class OSM_BAMS_WS_GeneralizedInputWrapper_test{

    public static testMethod void wrapMethod(){
    
        //Account
        Account testaccount = new Account();
        testAccount.Name = 'testacc';
        testAccount.BillingStreet = 'Street';
        testAccount.BillingCity = 'City';
        testAccount.BillingState = '';
        testAccount.BOLT_Account_Number__c = '999';
        testAccount.BillingPostalCode = '11000';
        testAccount.BillingCountry = 'United States';
        testAccount.CMI_Region__c = 'India';
        testAccount.CSS_Locale__c = 'English(India)';
        
            // JUHI Changes - prevent hard coding of ID
        testAccount.RecordTypeId = OSM_TestDataCreationUtility.getAccountRecordTypeID();
        testAccount.OwnerId = OSM_TestDataCreationUtility.getSystemAdministratorID();
        
        //testAccount.RecordTypeId = '0124C000000Cimc';
        //testAccount.OwnerId = '0054C0000016Fe3';
        
        testAccount.CSS_Timezone__c = '(GMT+05:30) India Standard Time (Asia/Kolkata)';
        insert testAccount;
        system.debug('testAccount'+testAccount);
            
        //CC Order
        ccrz__E_Order__c o1 = new ccrz__E_Order__c ();
        o1.ccrz__Storefront__c = 'SoftwareStore';
        o1.ccrz__Account__c = testAccount.Id;
        o1.ccrz__CurrencyISOCode__c = 'USD';
        insert o1;
        System.debug('---CC Order---'+o1);
        
        //Invoice
        ccrz__E_Invoice__c invc = new ccrz__E_Invoice__c();
        invc.ccrz__CCOrder__c = o1.id;
        invc.ccrz__Status__c = 'Paid';
        invc.ccrz__Storefront__c = 'SoftwareStore';
        invc.ccrz__CurrencyCode__c = 'USD';
        insert invc;
        
        //Transaction payment
        ccrz__E_TransactionPayment__c  ctpayment = new ccrz__E_TransactionPayment__c();
        ctpayment.ccrz__AccountType__c = 'po';
        ctpayment.Transaction_Status__c = 'Order Placed Success';
        ctpayment.ccrz__Storefront__c = 'SoftwareStore';
        ctpayment.ccrz__CCOrder__c = o1.id;
        ctpayment.ccrz__InvoiceAppliedTo__c = invc.id;
        insert ctpayment;   
    
         OSM_BAMS_WS_GeneralizedInputWrapper obj = new OSM_BAMS_WS_GeneralizedInputWrapper();
         obj.merchantID = '14344';
         obj.merchantReferenceCode = '14344';
         obj.PTcurrency = 'USD';
         obj.grandTotalAmount = 100.0;
         obj.subscriptionID = '5353825601416867704107';
         obj.orderId = '5269207';
         obj.order = o1;
         obj.transactionPayment = ctpayment;
         obj.invoice = invc;
        
    }
}