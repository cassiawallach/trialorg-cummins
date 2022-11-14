//updated by Sangeeta 28thJuly
//updated by Sharad 04thOct21 
@isTest
public class OSM_SW_QueueSubmitOrder_Test 
{
    static testMethod void testMethod1() 
    {
       TestProductSetupReq testReq = new TestProductSetupReq();
        testReq.permissionSetName = 'OSM_Support_Admin';
        
        testReq.accountGroupName = 'TestingAccountGroup';
        testReq.accountName = 'TestingAccount';
          
        testReq.compositeProductName = 'Connected Diagnostics';
        testReq.compositeProductSKU = 'CG-Lite-004';
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
        
        
        Test.startTest();
        
        OSM_SW_QueueSubmitOrder obj1 = new OSM_SW_QueueSubmitOrder(transecRes.order.Id);
        
        ID jobID = System.enqueueJob(obj1);
        
        Test.stopTest();
            
       
    }
    
}