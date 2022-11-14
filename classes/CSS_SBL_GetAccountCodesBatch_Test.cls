@isTest
public class CSS_SBL_GetAccountCodesBatch_Test {
    static testMethod void CSS_SBL_GetAccountCodeBatch_Test() {
        CSS_DataExchange_Parent__c dep = new CSS_DataExchange_Parent__c();
        insert dep;
        
        Test.startTest();
        CSS_SBL_GetAccountCodesBatch obj = new CSS_SBL_GetAccountCodesBatch();
        Database.executeBatch(obj);
        Test.stopTest();
    }

}