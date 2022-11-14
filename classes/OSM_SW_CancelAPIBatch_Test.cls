@istest
public class OSM_SW_CancelAPIBatch_Test {
    private static testMethod void cancelLicenses_ServiceHandler_Test() {
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
        
        ccrz__E_Product__c objProduct = new ccrz__E_Product__c(ccrz__SKU__c = '15458776',
                                                               Name = 'Connected Advisor',
                                                               ccrz__ShortDesc__c = 'testing',
                                                               ccrz__Quantityperunit__c = 3343,
                                                               ccrz__StartDate__c = system.today(),
                                                               ccrz__EndDate__c = system.today()+1);
        insert objProduct;
        
        ccrz__E_Product__c objProduct2 = new ccrz__E_Product__c(Name = 'Test',
                                                                ccrz__SKU__c = '15458777',
                                                                ccrz__ShortDesc__c = 'testing',
                                                                ccrz__Quantityperunit__c = 3343,
                                                                ccrz__StartDate__c = system.today(),
                                                                ccrz__EndDate__c = system.today()+1);
        insert objProduct2;
        
        ccrz__E_Order__c order = new ccrz__E_Order__c(ByPassFlow__c = true);
        order.ccrz__OrderStatus__c='Cancellation Pending';
        //order.Is_OMS_Revoke_and_Cancel_Not_Done_Count__c=0;
        insert order;
        
        ccrz__E_OrderItem__c orderItem = new ccrz__E_OrderItem__c();
        Set<id> idSet=new set<id>();
        orderItem.ccrz__Price__c = 500;
        orderItem.ccrz__Quantity__c = 55;
        orderItem.ccrz__SubAmount__c = 250;
        orderItem.Number_of_Bundles__c = 20;
        orderItem.ccrz__Order__c = order.id;
        orderItem.OSM_GetTI_Success__c = true;
        orderItem.ccrz__OriginalQuantity__c = 20;
        orderItem.ccrz__Product__c = objProduct.Id;
        orderItem.OSM_SW_Is_Refund_FSD_Done__c=true;
      
        orderItem.CancelLicenseAPICalled__c=false;
        orderItem.OMS_Product__c=true;
        insert orderItem;
        idSet.add(orderItem.id);
        
        ccrz__E_OrderItem__c orderItem2 = new ccrz__E_OrderItem__c();
        orderItem2.ccrz__Price__c = 500;
        orderItem2.ccrz__Quantity__c = 55;
        orderItem2.ccrz__SubAmount__c = 250;
        orderItem2.Number_of_Bundles__c = 20;
        orderItem2.ccrz__Order__c = order.id;
        orderItem2.OSM_GetTI_Success__c = true;
        orderItem2.ccrz__OriginalQuantity__c = 20;
        orderItem2.ccrz__Product__c = objProduct2.Id;
        orderItem2.CancelLicenseAPICalled__c=false;
        orderItem2.OMS_Product__c=true;
        orderItem2.OSM_SW_Is_Refund_FSD_Done__c=true;
        //orderItem.OSM_SW_Is_OMS_Revoke_and_Cancel_Not_Done__c=false;
        insert orderItem2;
        idSet.add(orderItem2.id);
        
        ccrz__E_TransactionPayment__c newTP = new ccrz__E_TransactionPayment__c();
        newTP = transecRes.transactionPayment.clone(false, true);
        newTP.ccrz__CCOrder__c = order.Id;
        newTP.ccrz__AccountType__c='cc';
        insert newTP;
        Test.startTest();
         database.executeBatch(new OSM_SW_CancelAPIBatch(idSet));
        
        
        ccrz__E_TransactionPayment__c newTP2 = new ccrz__E_TransactionPayment__c();
        newTP2 = transecRes.transactionPayment.clone(false, true);
        newTP2.ccrz__CCOrder__c = order.Id;
        newTP2.ccrz__AccountType__c='po';
        insert newTP2;
        
         database.executeBatch(new OSM_SW_CancelAPIBatch(idSet));
        Test.stopTest();
    }
    
}