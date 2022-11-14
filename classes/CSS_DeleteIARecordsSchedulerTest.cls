@isTest 
public class CSS_DeleteIARecordsSchedulerTest {

    static TestMethod void testScheduler() {
        CSS_DeleteIARecordsScheduler schClass = new CSS_DeleteIARecordsScheduler();
        String runTime = '0 0 23 * * ?';
        
        CSS_DataExchange_Parent__c deObj = new CSS_DataExchange_Parent__c();
        deObj.ServiceName__c = 'GetAssessData';
        insert deObj;

        Test.startTest();
        System.schedule('Test Schedule', runTime, schClass);
        Test.stopTest();
    }

}