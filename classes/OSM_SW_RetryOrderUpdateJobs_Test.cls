@isTest
public class OSM_SW_RetryOrderUpdateJobs_Test{
    //public static User loggedInUser=OSM_TestDataCreationUtility.getPortalUser();
    //public static User usr=OSM_TestDataCreationUtility.getPortalUser();
    public static testmethod void test1(){
        

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
        
        
        TestCompletedTransactionSetUpRes transecRes = new TestCompletedTransactionSetUpRes();
                                
        transecRes = OSM_TestDataCreationUtility.createProductSetUp(testReq);
        System.Runas(transecRes.objSetupDate.loggedInUser){
        ccrz__E_TransactionPayment__c crt = transecRes.transactionPayment;
        crt.OSM_Order_Update_Integration_Failure__c  = true;
        update  crt;
        System.debug('transecRes: '+transecRes);
        
        Test.starttest();
            List<ccrz__E_TransactionPayment__c> translist = [Select id,ccrz__CCOrder__c from ccrz__E_TransactionPayment__c  where id  =:crt.id];
            OSM_SW_RetryOrderUpdateJobs  obj = new OSM_SW_RetryOrderUpdateJobs(); 
            obj.execute(null,translist);
            database.executebatch(obj);
        Test.stoptest();
    }
    }
    public static testmethod void test2(){
        
        /*TestProductSetupReq testReq = new TestProductSetupReq();
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

        TestProductSetupRes objResponseProductSetup = new TestProductSetupRes();
        objResponseProductSetup = OSM_TestDataCreationUtility.createProductSetUp(testReq);
        System.debug('objResponseProductSetup: '+objResponseProductSetup);

        TestCompletedTransactionSetUpRes transecRes = new TestCompletedTransactionSetUpRes();
        transecRes = OSM_TestDataCreationUtility.createCompletedTransactionFlowTestData(objResponseProductSetup, 40, 6);*/
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
        
        
        TestCompletedTransactionSetUpRes transecRes = new TestCompletedTransactionSetUpRes();
                                
        transecRes = OSM_TestDataCreationUtility.createProductSetUp(testReq);
        System.Runas(transecRes.objSetupDate.loggedInUser){
        ccrz__E_TransactionPayment__c crt = transecRes.transactionPayment;
        crt.OSM_Order_Cancellation_Failure__c   = true;
        update  crt;
        System.debug('transecRes: '+transecRes);
        
        Test.starttest();
            List<ccrz__E_TransactionPayment__c> translist = [Select id,ccrz__CCOrder__c from ccrz__E_TransactionPayment__c  where id  =:crt.id];
            OSM_SW_RetryOrderCancellationJobs  obj = new OSM_SW_RetryOrderCancellationJobs(); 
            obj.execute(null,translist);
            database.executebatch(obj);
        Test.stoptest();
        }
    }
}