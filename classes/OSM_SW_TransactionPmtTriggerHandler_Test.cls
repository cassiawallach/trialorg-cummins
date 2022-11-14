//Updated By Sangeeta 
// Updated by sangeeta
// Updated by Sharad
// Updated by Sangeeta
//Update by Subbu
//Update for Test Class- 08/09
//Test Class for the class OSM_SW_TransactionPaymentTriggerHandler         
@isTest
public class OSM_SW_TransactionPmtTriggerHandler_Test{
     
        public static final Id PROFILEID=TestingUtils.SYS_ADMIN_PROFILE_ID;
        
        static testMethod void OnBeforeInsert_Test(){
        List<ccrz__E_Invoice__c> invoiceList=new List<ccrz__E_Invoice__c>();
        User usr = [Select id from User where Id = :UserInfo.getUserId()];
        List<ccrz__E_AccountGroup__c> accGrpId=TestingUtils.createAccountGroup(1,'TestAccountGroup','none',true);
        List<Account> accId=TestingUtils.createAccount(1,'testAccount',accGrpId[0].id,usr.id,true);
     
        List<Contact> con=TestingUtils.createContact(1,accId[0].id,usr.id,true);
   //    List<Contact> con=TestingUtils.createContactIAM(1,accId[0].id,usr.id,true);
        ccrz__E_Order__c order=TestingUtils.createOrder(con[0].id,'testOrder',true);
        List<ccrz__E_Invoice__c> cc_Invoice=TestingUtils.createCCInvoices(1,order.id,con[0].id,'Open','cart',true);
        cc_Invoice[0].Recurring_Invoice__c=true;
        cc_Invoice[0].ccrz__BillTo__c=accId[0].id;
        cc_Invoice[0].Payment_Method__c='cc';
        cc_Invoice[0].ccrz__Status__c='Closed';
        invoiceList.add(cc_Invoice[0]);
        update invoiceList;
        ccrz__E_TransactionPayment__c transPayment=TestingUtils.createTransactionPayment(order.id,true);
        transPayment.ccrz__InvoiceAppliedTo__c=invoiceList[0].id;
        transPayment.ccrz__AccountType__c='cc';
        transPayment.Transaction_Status__c='Recurring Payment Success';
        transPayment.ccrz__Token__c='6197149325146696804002';
        transPayment.ccrz__TransactionCode__c='5RKLINY8CNVL';
        update transPayment;
         
        
        List<ccrz__E_TransactionPayment__c> transPaymentList=new List<ccrz__E_TransactionPayment__c>();
        transPaymentList.add(transPayment);
        List<Id> invoiceIds=new List<Id>();
        invoiceIds.add(invoiceList[0].id);
        
        OSM_Orders_In_Invoice__c ordInvoice=new OSM_Orders_In_Invoice__c();
        ordInvoice.Vertex_Call_Status__c='success'; 
        ordInvoice.CC_Invoice__c=invoiceList[0].id;
        ordInvoice.CC_Order__c=order.id;
        insert ordInvoice;
        Map<Id,ccrz__E_TransactionPayment__c> transpaymentMap=new Map<Id,ccrz__E_TransactionPayment__c>();
        transpaymentMap.put(transPaymentList[0].id,transPaymentList[0]);
        
        Test.StartTest();
        Test.setMock(HttpCalloutMock.class, new OMS_SubmitOrder_Mock());
        OSM_SW_TransactionPaymentTriggerHandler handler=new OSM_SW_TransactionPaymentTriggerHandler();
        OSM_SW_TransactionPaymentTriggerHandler.OnBeforeInsert(transPaymentList);
        OSM_SW_TransactionPaymentTriggerHandler.callVertexForRecurringCC(invoiceIds);
        OSM_SW_TransactionPaymentTriggerHandler.populateTransactionStatusForRecurringInvoice(transPaymentList);
        OSM_SW_TransactionPaymentTriggerHandler.OnAfterInsert(transpaymentMap);
       // OSM_SW_TransactionPaymentTriggerHandler.OnAfterUpdate(transpaymentMap,transpaymentMap);
        OSM_SW_TransactionPaymentTriggerHandler.OnBeforeUpdate(transpaymentMap,transpaymentMap);
        
        Test.StopTest();
    }
    static testMethod void OnAfterUpdate_Test(){
        TestProductSetupReq testReq = new TestProductSetupReq();
        testReq.permissionSetName = 'OSM_Support_Admin';        
        testReq.accountGroupName = 'TestingAccountGroup Test';
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
        
        
         
        TestCompletedTransactionSetUpRes transecRes = new TestCompletedTransactionSetUpRes();
        
        transecRes = OSM_TestDataCreationUtility.createProductSetUp(testReq);
        
        System.debug('transecRes: '+transecRes);
        transecRes.transactionPayment.Transaction_Status__c = 'OrderItem Cancel Success';
        update transecRes.transactionPayment;
        
        Map<Id,ccrz__E_TransactionPayment__c> transpaymentMap=new Map<Id,ccrz__E_TransactionPayment__c>();
        transpaymentMap.put(transecRes.transactionPayment.id,transecRes.transactionPayment);
        
        Test.StartTest();
        Test.setMock(HttpCalloutMock.class, new OMS_SubmitOrder_Mock());
        OSM_SW_TransactionPaymentTriggerHandler.OnAfterUpdate(transpaymentMap,transpaymentMap);
        Test.StopTest();
    }


}