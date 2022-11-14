/************************************************
 History
 --------
 VERSION    AUTHOR          DATE            DETAILS
 1.0        Ashish          17/03/2021      Test Class Fixes
 */
@isTest
public class OSM_WS_RetryOneBMSRefundFSDCall_Test {
    
    static testmethod void test1(){
        //list<ccrz__E_TransactionPayment__c> transPaymntList = [Select id,ccrz__InvoiceAppliedTo__c,ccrz__InvoiceAppliedTo__r.OSM_SW_IsIntercompanyInvoice__c,ccrz__InvoiceAppliedTo__r.OSM_Child_Account__r.BillingCountry,ccrz__InvoiceAppliedTo__r.ccrz__BillTo__r.BillingCountry, OSM_ARInvoice_Integration_Failure__c, Bolt_Credit_Memo_Call_Status__c from ccrz__E_TransactionPayment__c where Bolt_Credit_Memo_Call_Status__c = 'Failure' or Bolt_Credit_Memo_Call_Status__c = 'Pending'];
        TestProductSetupReq testReq = new TestProductSetupReq();
        testReq.permissionSetName = 'OSM_Support_Admin';
        testReq.accountGroupName = 'TestingAccountGroup';
        testReq.accountName = 'TestingAccount';
        testReq.compositeProductName = 'Connected Diagnostics';
        testReq.compositeProductSKU = '1234567-BUS';
        testReq.compositeProductGroupName = 'DA';
        testReq.compositeProductProductType = 'Aggregated';
        testReq.componentProductName = 'CD Base-BUS';
        testReq.componentProductStatus = 'Released';
        testReq.componentProductSKU = '1301298-BUS';
        testReq.componentProductGroupName = 'DA';
        testReq.componentProductPackageName = 'Base';
        testReq.priceListName = 'TestPriceList';
        testReq.specName = 'TestName';
        List<Account>  lstacc = new List<Account>();
        Account acc = new Account();
        RecordType recid =[select id from recordType where name='wwsps' limit 1];  
        acc.RecordTypeId= recid.id;       
        acc.Name = 'Test Account';
        acc.CMI_Account_Status__c = 'Active';
        //acc.CMI_CDA_Status__c = 'New Customer Request';
        //acc.CMI_Region__c = 'NORTH AMERICA';
        //acc.CSS_Language__c = 'English';
        acc.BillingCountry = 'United States';
        lstacc.add(acc);
        insert lstacc;
        TestCompletedTransactionSetUpRes transecRes = new TestCompletedTransactionSetUpRes();
        transecRes = OSM_TestDataCreationUtility.createProductSetUp(testReq);
        System.debug('transecRes: -- ' + transecRes);
        List<ccrz__E_OrderItem__c> orderItemList=new List<ccrz__E_OrderItem__c>();
        ccrz__E_Order__c order1=transecRes.order;
        order1.ccrz__OrderStatus__c ='Cancellation Pending';
        order1.OrderProcessedforFSD__c  = true;
        update order1;
       // order1.Is_OMS_Revoke_and_Cancel_Not_Done_Count__c=0;
        list<ccrz__E_Invoice__c> invcList = new list<ccrz__E_Invoice__c>();
        ccrz__E_Invoice__c  invc = new ccrz__E_Invoice__c ();
        invc.Id = transecRes.invoice.Id;
        invc.ccrz__BillTo__c=acc.id;
        invc.OSM_SW_IsIntercompanyInvoice__c =false;
        invc.OSM_Child_Account__c =acc.id;
        invc.OSM_SW_Is_Refund_FSD_Done__c  = false;
        invc.Invoice_Type__c = 'Credit Memo';
        invcList.add(invc);
        update invcList ;
        
        
         
        list<ccrz__E_TransactionPayment__c> transPaymntList =new list<ccrz__E_TransactionPayment__c>();
        ccrz__E_TransactionPayment__c payment=new ccrz__E_TransactionPayment__c();
        payment.OSM_ARInvoice_Integration_Failure__c=true;
        payment.Bolt_Credit_Memo_Call_Status__c = 'Failure';
        payment.Bolt_Credit_Memo_Call_Status__c = 'Pending';
        payment.ccrz__InvoiceAppliedTo__c= invc.ID;
        insert payment;
        transPaymntList.add(payment);
        OSM_WS_RetryOneBMSRefundFSDCall bjobs = new OSM_WS_RetryOneBMSRefundFSDCall();
            Database.executeBatch(bjobs,1);
            
            CallCancleOrderProcessQuable objQua = new CallCancleOrderProcessQuable();
                        objQua.orderId = transecRes.order.Id;
                        ID jobID = System.enqueueJob(objQua);
                        System.debug('jobID'+jobID);
    }

}