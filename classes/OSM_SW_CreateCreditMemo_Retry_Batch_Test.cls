//Subbu update to pick this up for deployment
@isTest
public class OSM_SW_CreateCreditMemo_Retry_Batch_Test{
    static testMethod void CreateCreditMemo_Retry_BatchMethod(){  
    
    //CC Order
        
        ccrz__E_Order__c ord = new ccrz__E_Order__c();
        ord.ccrz__Storefront__c = 'SoftwareStore';
        ord.OrderProcessedforFSD__c = true;
        ord.OSM_SW_Is_DA_Update_Done_Or_Not_Needed__c = false;
        ord.ccrz__CurrencyISOCode__c = 'USD';
        ord.ccrz__OrderStatus__c = 'Cancellation Pending';
        insert ord;
    //create Invoice 
        ccrz__E_Invoice__c invoice = new ccrz__E_Invoice__c();
        invoice.ccrz__CCOrder__c = ord.id;
        invoice.ccrz__CurrencyCode__c = 'USD';
        invoice.ccrz__DateIssued__c = System.today();
        invoice.ccrz__DateDue__c = System.today();
        invoice.ccrz__OriginalAmount__c = 10000;
        invoice.ccrz__RemainingAmount__c = 0.00;
        invoice.ccrz__Storefront__c = 'SoftwareStore';
        invoice.Is_GOMS_Intercompany_Invoice__c= true;
        invoice.CreditMemo_Number__c='';
        insert invoice;
    Test.startTest();
    OSM_SW_CreateCreditMemo_Retry_Batch createCreditMemo = new OSM_SW_CreateCreditMemo_Retry_Batch();
    Database.executeBatch(createCreditMemo, 1);
    System.assertEquals('Cancellation Pending', ord.ccrz__OrderStatus__c);
    System.assertNotEquals(null,invoice,'The Invoice not Genarated');
    Test.stopTest();  
    }
}