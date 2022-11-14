@isTest
public class OSM_SW_CancelOIBatch_Test {

    @testSetup static void testData() {

        ccrz__E_Order__c order = new ccrz__E_Order__c();
        insert order;
        
        ccrz__E_OrderItem__c orderItem       = new ccrz__E_OrderItem__c();
        orderItem.ccrz__Order__c             = order.id;
        orderItem.ccrz__Quantity__c          = 55;
        orderItem.ccrz__SubAmount__c         = 250;
        orderItem.OMS_Product__c             = true;
        orderItem.OMS_Activation_Key__c      = 'testActivation';
        orderItem.Revocation_Status__c       = 'Revoke Initiated';
        orderItem.ccrz__Price__c             = 2500;
        orderItem.Number_of_Bundles__c       = 25;
        orderItem.ccrz__OriginalQuantity__c  = 25;
        insert orderItem;
    }

    @isTest static void testMethodWithoutRecordIds() {
        Database.executeBatch(new OSM_SW_CancelOIBatch(null));
    }
    @isTest static void testMethodWithRecordIds() {
        
        Id RecordId = [SELECT ID FROM ccrz__E_OrderItem__c LIMIT 1].Id;
        Set<String> RecordIdSet = new Set<String>();
        RecordIdSet.add(RecordId);
        Test.startTest();
        Database.executeBatch(new OSM_SW_CancelOIBatch(RecordIdSet));
        Test.stopTest();
    }
}