//Updated on 04/04/2022
@IsTest(seeAllData=false)
public class OSM_GetOrderInfo_Service_Test {
	
    //UPdated for User Story 883
    @testSetup
    static void testData() {
        // Create Account
        Account testaccount = TestingUtils.insertAccount();
    }

    Public static testMethod void testGetOrderInfo () {
                
        List<Account> accounts = [SELECT Id FROM Account LIMIT 1];
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
		testReq.priceListName = 'Test_PriceList';
        testReq.specName = 'TestName';


        TestCompletedTransactionSetUpRes transecRes = new TestCompletedTransactionSetUpRes();
        System.assert( testReq != null, 'Request argument should not be null');//UPdated for User Story 883
        transecRes = OSM_TestDataCreationUtility.createProductSetUp(testReq);
        System.assert( transecRes != null, 'Transaction Response should not be null');//UPdated for User Story 883
        System.assert( transecRes.invoice != null, 'Invoice has been generacted successfully');//UPdated for User Story 883
        
        Test.StartTest();
        Test.setMock(HttpCalloutMock.class, new OSMGetOrderInfoServiceMockUp());
        OSM_GetOrder_WS_GeneralizedoutputWrapper resrap = OSM_GetOrderInfo_Service.callGetOrderInfoService('OMSOrderId', transecRes.order.Id,accounts[0].Id);
        System.assert( resrap != null, 'Get Order Info Service Response should not be null');//UPdated for User Story 883
        Test.StopTest();
    }
    
    
   public class OSMGetOrderInfoServiceMockUp implements HttpCalloutMock {
    public HTTPResponse respond(HTTPRequest req) 
    {
        HttpResponse res = new HttpResponse();
        {
            //Create a fake response
            res.setHeader('Content-Type', 'application/json');
            res.setStatusCode(200);
            res.setBody('{"Header":{"Sender":{"ServiceName":"GetOrder","SenderID":"Mrktpl"},"Target":{"TargetID":"OMS"}},"ItemInfoList":{"ItemInfo":[{"ItemId":"7757","LicenseInfo":{"LicenseName":"Komatsu Tier4 Basic","ActivationKey":"NIQ12IWCSV1D"}},{"ItemId":"7758","LicenseInfo":{"LicenseName":"Komatsu Tier4","ActivationKey":"NIQ12IWCSV1D"}}]}}');
        }
        return res;
    }
}

}