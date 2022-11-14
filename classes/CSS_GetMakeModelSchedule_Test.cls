@isTest 
public class CSS_GetMakeModelSchedule_Test {
    static TestMethod void testScheduler() {
        CSS_GetMakeModel_Schedule schClass = new CSS_GetMakeModel_Schedule();
        String runTime = '0 0 23 * * ?';
       	Test.startTest();
        System.schedule('Test Schedule', runTime, schClass);
        Test.stopTest();
    }
}