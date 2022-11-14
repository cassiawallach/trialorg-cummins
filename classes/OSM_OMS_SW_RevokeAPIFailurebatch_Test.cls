//This is the test class of OSM_OMS_SW_RevokeAPIFailurebatch
//updated on 8th Oct by Sangeeta
@isTest
public class OSM_OMS_SW_RevokeAPIFailurebatch_Test {
   // public static User loggedInUser=OSM_TestDataCreationUtility.getPortalUser();
   
    static testMethod void RevokeAPIFailurebatch_Test(){
    
    User usr=OSM_TestDataCreationUtility.getPortalUser();
   
        
        
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
        
        System.Runas(transecRes.objSetupDate.loggedInUser) {
            
            ccrz__E_Order__c order1 = transecRes.order;
            order1.ccrz__OrderStatus__c = 'Cancellation Pending';
            List<String> orderIdsList1 = new List<String>();
            List<ccrz__E_Order__c> orderList = new List<ccrz__E_Order__c>();
            
            //adding orders into list
            orderIdsList1.add(order1.Id);
            orderList.add(order1);
            update orderList;
            
            //create orderitem record
            ccrz__E_OrderItem__c item = new ccrz__E_OrderItem__c();
            item.OMS_Instance_ID__c = '33243324';
            //item.OMS_Revoke_API_failure__c = true;
            item.ccrz__Order__c = order1.id;
            item.ccrz__Price__c = 20;
            item.ccrz__Quantity__c = 1;
            item.ccrz__SubAmount__c = 20;
            item.IsRevokeLicenseSucess__c = false;
            item.Instance_ID_Count__c = 1;
            insert item;
            
            OSM_Order_Item_License__c ParentActivationKey = new OSM_Order_Item_License__c();
            ParentActivationKey.Activation_Key__c         = 'testActivationKey';
            ParentActivationKey.CC_Order_Item__c          = item.Id;
            ParentActivationKey.Parent_Activation_Key__c  = null;
            ParentActivationKey.OMS_Item_Id__c            = '1234';
            ParentActivationKey.Tool_Instance_Key__c      = '12345';
            ParentActivationKey.Status__c                 = 'New';
            ParentActivationKey.type__c                   = 'Basic';
            insert ParentActivationKey;
            
            OSM_Order_Item_License__c orderItemLicense2 = new OSM_Order_Item_License__c();
            orderItemLicense2.Activation_Key__c         = 'testActivationKey';
            orderItemLicense2.CC_Order_Item__c          = item.Id;
            orderItemLicense2.Parent_Activation_Key__c  = ParentActivationKey.Id;
            orderItemLicense2.OMS_Item_Id__c            = '1234';
            orderItemLicense2.Tool_Instance_Key__c      = '12345';
            orderItemLicense2.Status__c                 = 'New';
            orderItemLicense2.type__c                   = 'Functional';
            insert orderItemLicense2;
            
            //calling batch class 
            Test.StartTest();
            //OSM_OMS_SW_RevokeAPIFailurebatch obj = new OSM_OMS_SW_RevokeAPIFailurebatch();
            //DataBase.executeBatch(obj); 
            String CRON_EXP = '0 0 * * * ?'; 
            System.schedule('RevokeAPIFailbatchTest',  CRON_EXP, new OSM_OMS_SW_RevokeAPIFailbatchScheduler());
            Test.stopTest();
        
        }
        
    }

    static testMethod void RevokeAPIFailurebatch_Test2(){
    
        User usr=OSM_TestDataCreationUtility.getPortalUser();
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
        
        System.Runas(transecRes.objSetupDate.loggedInUser) {            
            ccrz__E_Order__c order1 = transecRes.order;
            order1.ccrz__OrderStatus__c = 'Cancellation Pending';
            List<String> orderIdsList1 = new List<String>();
            List<ccrz__E_Order__c> orderList = new List<ccrz__E_Order__c>();
            
            //adding orders into list
            orderIdsList1.add(order1.Id);
            orderList.add(order1);
            update orderList;
            
            //create orderitem record
            ccrz__E_OrderItem__c item = new ccrz__E_OrderItem__c();
            item.OMS_Instance_ID__c = '33243324';
            //item.OMS_Revoke_API_failure__c = true;
            item.ccrz__Order__c = order1.id;
            item.ccrz__Price__c = 20;
            item.ccrz__Quantity__c = 1;
            item.ccrz__SubAmount__c = 20;
            item.IsRevokeLicenseSucess__c = false;
            item.Instance_ID_Count__c = 1;
            insert item;
            
            OSM_Order_Item_License__c ParentActivationKey = new OSM_Order_Item_License__c();
            ParentActivationKey.Activation_Key__c         = 'testActivationKey';
            ParentActivationKey.CC_Order_Item__c          = item.Id;
            ParentActivationKey.Parent_Activation_Key__c  = null;
            ParentActivationKey.OMS_Item_Id__c            = '1234';
            ParentActivationKey.Tool_Instance_Key__c      = '12345';
            ParentActivationKey.Status__c                 = 'New';
            ParentActivationKey.type__c                   = 'Basic';
            insert ParentActivationKey;
            
            OSM_Order_Item_License__c orderItemLicense2 = new OSM_Order_Item_License__c();
            orderItemLicense2.Activation_Key__c         = 'testActivationKey';
            orderItemLicense2.CC_Order_Item__c          = item.Id;
            orderItemLicense2.Parent_Activation_Key__c  = ParentActivationKey.Id;
            orderItemLicense2.OMS_Item_Id__c            = '1234';
            orderItemLicense2.Tool_Instance_Key__c      = '12345';
            orderItemLicense2.Status__c                 = 'New';
            orderItemLicense2.type__c                   = 'Functional';
            insert orderItemLicense2;
            
            Test.StartTest();
            OSM_OMS_SW_RevokeAPIFailurebatch obj = new OSM_OMS_SW_RevokeAPIFailurebatch(new Set<Id>{item.Id});
            DataBase.executeBatch(obj); 
            Test.stopTest();
        
        }
        
    }
     
}