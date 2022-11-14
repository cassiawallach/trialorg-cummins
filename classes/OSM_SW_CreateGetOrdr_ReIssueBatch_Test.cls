@isTest
public class OSM_SW_CreateGetOrdr_ReIssueBatch_Test {
    static testMethod void testBatchScript(){
        User usr=OSM_TestDataCreationUtility.getPortalUser();
        TestProductSetupReq testReq = new TestProductSetupReq();
        testReq.permissionSetName = 'OSM_Support_Admin';
        
        testReq.accountGroupName = 'TestingAccountGroup';
        testReq.accountName = 'TestingAccount';        
        
        testReq.compositeProductName = 'Guidanz';
        testReq.compositeProductSKU = '1234567-BUS';
        testReq.compositeProductGroupName = 'DA';
        testReq.compositeProductProductType = 'Aggregated';
        
        testReq.componentProductName = 'Guidanz 12';
        testReq.componentProductStatus = 'Released';
        testReq.componentProductSKU = '1301298-BUS';
        testReq.componentProductGroupName = 'DA';
        testReq.componentProductPackageName = 'Base';
        
        
        testReq.priceListName = 'TestPriceList';
        testReq.specName = 'TestName';
        
        
        TestCompletedTransactionSetUpRes transecRes = new TestCompletedTransactionSetUpRes();
        transecRes = OSM_TestDataCreationUtility.createProductSetUp(testReq);
        system.debug('transecRes---->>'+transecRes);
        
        Account acc = new Account();
        acc.name = 'OSM_Test_Acc';
        acc.OSM_Preferred_Payment_Method__c = 'PO';
        insert acc;
        
        set<string> prodid = new set<string>();
        ccrz__E_Product__c prod = new ccrz__E_Product__c();
        prod.name = 'Guidanz';
        prod.ccrz__SKU__c = '15458776';
        prod.ccrz__Quantityperunit__c = 3343;
        prod.ccrz__StartDate__c = system.today();
        prod.ccrz__EndDate__c = system.today()+1;
        prod.ccrz__ShortDesc__c = 'testing';
        prod.ccrz__ProductStatus__c='Released';
        insert prod;
        String prodidstring = String.valueof(prod.id);
        prodid.add(prodidstring); 
        
        List<ccrz__E_Subscription__c> subList = new List<ccrz__E_Subscription__c>();
        ccrz__E_Subscription__c sub = new ccrz__E_Subscription__c();
        sub.OSM_Display_Product__c = prod.id;
        sub.ccrz__Quantity__c = 10;
        sub.ccrz__Sequence__c = 2;
        sub.ccrz__Account__c = transecRes.objSetupDate.account.Id;
        sub.ccrz__Storefront__c ='SoftwareStore';
        sub.ccrz__SubscriptionStartDate__c  = system.today();
        sub.OSM_Subscription_End_Date__c  = System.today()+50;
        sub.ccrz__SubscriptionStatus__c = 'Active';
        sub.ccrz__SubscriptionProduct__c = prod.id;
        sub.OSM_Free_Trial__c =false;
        //sub.OSM_Display_Product__r.ccrz__ShortDesc__c = 'test description';
        subList.add(sub);
        insert subList;
        
        OSM_Order_Subscription__c objSubsc = new OSM_Order_Subscription__c();
        objSubsc.CC_Order_Item__c = transecRes.orderItem.Id;
        objSubsc.OSM_CCSubscription__c = subList[0].id;
        objSubsc.OSM_CCOrder__c = transecRes.order.Id;
        objSubsc.Billing_Frequency__c = 'Monthly';
        insert objSubsc;
        System.debug('transecRes.orderSubscriptionjunction: '+objSubsc);
        
        
        ccrz__E_Order__c objOrdr = new ccrz__E_Order__c();
        objOrdr.ccrz__OrderStatus__c = 'Order Submitted';
        objOrdr.Id = transecRes.order.Id;
        objOrdr.ByPassFlow__c = true;
        objOrdr.ccrz__OrderDate__c = system.today();
        update objOrdr;
        
        
        ccrz__E_OrderItem__c objItem = new ccrz__E_OrderItem__c();
        objItem.IsRevokeLicenseSucess__c = false;
        objItem.Revocation_Status__c = '';
        objItem.Id = transecRes.orderItem.Id;
        update objItem;
        
        
        OSM_Order_Item_License__c objLsc1 = new OSM_Order_Item_License__c();
        objLsc1.CC_Order_Item__c = transecRes.orderItem.Id;
        objLsc1.Activation_Key__c = 'ABCDEF';
        objLsc1.Status__c = 'New';
        objLsc1.Type__c = 'Basic';
        insert objLsc1;
        
        OSM_Order_Item_License__c objLsc2 = new OSM_Order_Item_License__c();
        objLsc2.Status__c = 'New';
        objLsc2.CC_Order_Item__c = transecRes.orderItem.Id;
        objLsc2.Tool_Instance_Key__c = 'test2';
        objLsc2.Parent_Activation_Key__c = objLsc1.Id;
        insert objLsc2;
        
        
        OSM_Order_Item_License__c objLsc12 = new OSM_Order_Item_License__c();
        objLsc12.CC_Order_Item__c = transecRes.orderItem.Id;
        objLsc12.Activation_Key__c = 'ABCDEF';
        objLsc12.Status__c = 'New';
        objLsc12.Type__c = 'Functional';
        insert objLsc12;
        
        OSM_Order_Item_License__c objLsc21 = new OSM_Order_Item_License__c();
        objLsc21.Status__c = 'Revoked/ReIssue';
        objLsc21.CC_Order_Item__c = transecRes.orderItem.Id;
        objLsc21.Tool_Instance_Key__c = 'test2';
        objLsc21.Parent_Activation_Key__c = objLsc12.Id;
        insert objLsc21;
        
        Test.startTest();
        Database.executeBatch(new OSM_SW_CreateGetOrder_ON_ReIssueBatch(), 1);
        Test.stopTest();
    }
}