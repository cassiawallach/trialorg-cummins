@isTest 
public class CSS_delUnitTypeSubTypeScheduler_Test {

    static TestMethod void testScheduler() {

        CSS_delUnitTypeSubTypeScheduler schClass = new CSS_delUnitTypeSubTypeScheduler();
        String runTime = '0 0 23 * * ?';
        
        CSS_JobEventTemporary__c jobEvent = new CSS_JobEventTemporary__c();
        jobEvent.Name = 'Test Job Event';
        insert jobEvent;

        Test.startTest();
        system.schedule('Test Schedule', runTime, schClass);
        Test.stopTest();
    }

}