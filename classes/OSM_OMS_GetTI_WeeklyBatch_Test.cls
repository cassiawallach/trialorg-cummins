@isTest
public class OSM_OMS_GetTI_WeeklyBatch_Test {

    @testSetup static void testData() {

        ccrz__E_Order__c order = new ccrz__E_Order__c();
        insert order;
        
        ccrz__E_OrderItem__c orderItem       = new ccrz__E_OrderItem__c();
        orderItem.ccrz__Order__c             = order.id;
        orderItem.ccrz__Quantity__c          = 55;
        orderItem.ccrz__SubAmount__c         = 250;
        orderItem.OMS_Product__c             = true;
        orderItem.OMS_Activation_Key__c      = 'testActivation';
        orderItem.Tool_Instance_Key_Count__c = 2;
        orderItem.Tool_Instance_Key__c       = '';
        orderItem.ccrz__Price__c             = 2500;
        insert orderItem;
    }

    @isTest static void testMethod1() {
        
        Test.startTest();
        Database.executeBatch(new OSM_OMS_GetTI_WeeklyBatch());
        //OSM_RetryGETTILicenseWeeklySchedular.scheduleInterCompanyRetryBatch();
        string sch = '0 0 * * * ?';
        System.schedule('test weekly sch', sch, new OSM_RetryGETTILicenseWeeklySchedular());    
        Test.stopTest();
    }
}