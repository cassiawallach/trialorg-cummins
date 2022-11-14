@isTest
public class CSS_SBL_GetApplicationListBatch_Test {
    static testMethod void CSS_SBL_GetApplicationListBatch_Test() {
        CSS_DataExchange_Parent__c dep = new CSS_DataExchange_Parent__c();
        insert dep;
        
        Test.startTest();
        CSS_SBL_GetApplicationListBatch obj = new CSS_SBL_GetApplicationListBatch();
        Database.executeBatch(obj);
        Test.stopTest();
    }
}