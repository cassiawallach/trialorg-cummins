//Test class of OSM_SW_CreateGetOrder_ON_ReIssueBatch
// Test class of OSM_OMS_GetTI_ON_Revoked_Batch
// Test class
@isTest
public class OSM_SW_RevokeInstanceBatch_Test {
    
    @testSetup static void testData() {
        
        ccrz__E_Order__c order = new ccrz__E_Order__c(ByPassFlow__c = true);
        insert order;
        
        
        
        ccrz__E_OrderItem__c orderItem = new ccrz__E_OrderItem__c();
        orderItem.ccrz__Order__c       = order.id;
        orderItem.ccrz__Price__c       = 500;
        orderItem.ccrz__Quantity__c    = 55;
        orderItem.ccrz__SubAmount__c   = 250;
        insert orderItem;
        
        OSM_Order_Item_License__c ParentActivationKey = new OSM_Order_Item_License__c();
        ParentActivationKey.Activation_Key__c         = 'testActivationKey';
        ParentActivationKey.CC_Order_Item__c          = orderItem.id;
        ParentActivationKey.Parent_Activation_Key__c  = null;
        ParentActivationKey.OMS_Item_Id__c            = '1234';
        ParentActivationKey.Tool_Instance_Key__c      = '12345';
        ParentActivationKey.Status__c                 = 'Revoke Intitiated';
        ParentActivationKey.type__c                   = 'Tool instance';
        insert ParentActivationKey;
        
        OSM_Order_Item_License__c orderItemLicense = new OSM_Order_Item_License__c();
        orderItemLicense.Activation_Key__c         = 'testActivationKey';
        orderItemLicense.CC_Order_Item__c          = orderItem.id;
        orderItemLicense.Parent_Activation_Key__c  = ParentActivationKey.id;
        orderItemLicense.OMS_Item_Id__c            = '1234';
        orderItemLicense.Tool_Instance_Key__c      = '12345';
        orderItemLicense.Status__c                 = 'Revoke Intitiated';
        orderItemLicense.type__c                   = 'Tool instance';
        insert orderItemLicense;
        
        OSM_Order_Item_License__c orderItemLicense2 = new OSM_Order_Item_License__c();
        orderItemLicense2.Activation_Key__c         = 'testActivationKey';
        orderItemLicense2.CC_Order_Item__c          = orderItem.id;
        orderItemLicense2.Parent_Activation_Key__c  = ParentActivationKey.id;
        orderItemLicense2.OMS_Item_Id__c            = '1234';
        orderItemLicense2.Tool_Instance_Key__c      = '12345';
        orderItemLicense2.Status__c                 = 'Revoked/ReIssue';
        orderItemLicense2.type__c                   = 'Tool instance';
        insert orderItemLicense2;
        
        OSM_Order_Item_License__c orderItemLicense3  = new OSM_Order_Item_License__c();
        orderItemLicense3.Activation_Key__c          = 'testActivationKey';
        orderItemLicense3.CC_Order_Item__c           = orderItem.id;
        orderItemLicense3.Parent_Activation_Key__c   = orderItemLicense2.id;
        orderItemLicense3.Revoked_ReIssue_Lisence__c = orderItemLicense.id;
        orderItemLicense3.OMS_Item_Id__c             = '1234';
        orderItemLicense3.Tool_Instance_Key__c       = '12345';
        orderItemLicense3.Status__c                  = 'Create And Get Done';
        insert orderItemLicense3;
        
        
    } 
    
    @isTest static void testMethod1() {
        test.startTest();
        dataBase.executeBatch(new OSM_SW_RevokeInstanceBatch());
        dataBase.executeBatch(new OSM_SW_CreateGetOrder_ON_ReIssueBatch());
        dataBase.executeBatch(new OSM_OMS_GetTI_ON_Revoked_Batch());
        test.stopTest();
    }  
}