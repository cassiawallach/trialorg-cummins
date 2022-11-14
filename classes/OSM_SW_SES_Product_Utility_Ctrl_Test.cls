//This class is TEST class for OSM_SW_SES_Product_Utility_Ctrl
//recompilation
//recompilcation
// Singaiah Update for MP-757 05-04-2022
//recompile
//recompile
@isTest
private class OSM_SW_SES_Product_Utility_Ctrl_Test {

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
        
        Test.startTest();
        
        ccrz__E_SubProdTerm__c subProdTerm = transecRes.objSetupDate.subProdTermList[0];
        subProdTerm.ccrz__DisplayName__c = 'Monthly';
        update subProdTerm;
        
        ccrz__E_CompositeProduct__c compProd = new ccrz__E_CompositeProduct__c();
        compProd.ccrz__Composite__c = transecRes.objSetupDate.componentList[0].Id;
        compProd.ccrz__Component__c = transecRes.objSetupDate.componentList[0].Id;
        insert compProd;
        
        ccrz__E_CompositeProduct__c compProd2 = new ccrz__E_CompositeProduct__c();
        compProd2.ccrz__Composite__c = transecRes.objSetupDate.componentList[0].Id;
        compProd2.ccrz__Component__c = transecRes.objSetupDate.componentList[0].Id;
        compProd2.ccrz__Quantity__c = 9999;
        insert compProd2;
         OSM_Features_Maintenance__c osmFM=  new OSM_Features_Maintenance__c();
        osmFM.Name='SubscriptionLength';
        osmFM.Subscription_Length__c = 'ON';
        insert osmFM;
         OSM_SubscriptionLength__mdt lstSouthernPlain = [SELECT Label, Product_SKU__c,Subscription_Length__c from OSM_SubscriptionLength__mdt
                                                                 WHERE DeveloperName='INCAL_Automotive' limit 1];
        OSM_SW_SES_Product_Utility_Ctrl.getBillingFrequenciesAndSubscriptions(new Map<Id, ccrz__E_SubProdTerm__c>{transecRes.objSetupDate.subProdTermList[0].Id => transecRes.objSetupDate.subProdTermList[0]}, transecRes.objSetupDate.account.Id, 'SoftwareStore', transecRes.objSetupDate.compositeProduct.Id,'');
        
        Test.stopTest();

  }
  
  private static testMethod void test2() {
      
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
        
        Test.startTest();
        
        ccrz__E_SubProdTerm__c subProdTerm = transecRes.objSetupDate.subProdTermList[0];
        subProdTerm.ccrz__DisplayName__c = 'Monthly';
        update subProdTerm;
        
        ccrz__E_CompositeProduct__c compProd = new ccrz__E_CompositeProduct__c();
        compProd.ccrz__Composite__c = transecRes.objSetupDate.componentList[0].Id;
        compProd.ccrz__Component__c = transecRes.objSetupDate.componentList[0].Id;
        insert compProd;
        
        ccrz__E_CompositeProduct__c compProd2 = new ccrz__E_CompositeProduct__c();
        compProd2.ccrz__Composite__c = transecRes.objSetupDate.componentList[0].Id;
        compProd2.ccrz__Component__c = transecRes.objSetupDate.componentList[0].Id;
        compProd2.ccrz__Quantity__c = 9999;
        insert compProd2;
        
        ccrz__E_Product__c prod = transecRes.objSetupDate.componentList[0];
        prod.Package__c = 'Lite';
        update prod;
         OSM_SubscriptionLength__mdt lstSouthernPlain = [SELECT Label, Product_SKU__c,Subscription_Length__c from OSM_SubscriptionLength__mdt
                                                                 WHERE DeveloperName='INCAL_Automotive' limit 1];
        OSM_SW_SES_Product_Utility_Ctrl.getBillingFrequenciesAndSubscriptions(new Map<Id, ccrz__E_SubProdTerm__c>{transecRes.objSetupDate.subProdTermList[0].Id => transecRes.objSetupDate.subProdTermList[0]}, transecRes.objSetupDate.account.Id, 'SoftwareStore', transecRes.objSetupDate.compositeProduct.Id,'SES-123');
        
        Test.stopTest();

  }
  
  private static testMethod void test3() {
      
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
        
        Test.startTest();
        
        ccrz__E_SubProdTerm__c subProdTerm = transecRes.objSetupDate.subProdTermList[0];
        subProdTerm.ccrz__DisplayName__c = 'Monthly';
        update subProdTerm;
        
        ccrz__E_CompositeProduct__c compProd = new ccrz__E_CompositeProduct__c();
        compProd.ccrz__Composite__c = transecRes.objSetupDate.componentList[0].Id;
        compProd.ccrz__Component__c = transecRes.objSetupDate.componentList[0].Id;
        insert compProd;
        
        ccrz__E_CompositeProduct__c compProd2 = new ccrz__E_CompositeProduct__c();
        compProd2.ccrz__Composite__c = transecRes.objSetupDate.componentList[0].Id;
        compProd2.ccrz__Component__c = transecRes.objSetupDate.componentList[0].Id;
        compProd2.ccrz__Quantity__c = 9999;
        insert compProd2;
        
        ccrz__E_Product__c prod = transecRes.objSetupDate.componentList[0];
        prod.Package__c = 'Pro';
        update prod;
         OSM_SubscriptionLength__mdt lstSouthernPlain = [SELECT Label, Product_SKU__c,Subscription_Length__c from OSM_SubscriptionLength__mdt
                                                                 WHERE DeveloperName='INCAL_Automotive' limit 1];
        OSM_SW_SES_Product_Utility_Ctrl.getBillingFrequenciesAndSubscriptions(new Map<Id, ccrz__E_SubProdTerm__c>{transecRes.objSetupDate.subProdTermList[0].Id => transecRes.objSetupDate.subProdTermList[0]}, transecRes.objSetupDate.account.Id, 'SoftwareStore', transecRes.objSetupDate.compositeProduct.Id,'CG-BASE-23');
        
        Test.stopTest();

  }

}