@isTest
private class OSM_SW_ccLogicCartPlace_Test {

	private static testMethod void test() {
	    
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
        
        ccrz__E_Cart__c objCart=transecRes.cart;
        objCart.ccrz__EncryptedId__c = transecRes.cart.Id;
        update objCart;
        
        Test.startTest();
        
        Map<String, Object> inputData = new Map<String, Object>();
        inputData.put('cartId', transecRes.cart.Id);
        
        OSM_SW_ccLogicCartPlace objLogicCartPlace = new OSM_SW_ccLogicCartPlace();
        objLogicCartPlace.process(inputData);
        
        Test.stopTest();
	}

}