@isTest 
public class CG_GetFailCodesScheduler_Test{
    static TestMethod void testScheduler() {
        CG_GetFailCodesScheduler schClass = new CG_GetFailCodesScheduler();
        String runTime = '0 0 23 * * ?';
        Test.startTest();
        System.schedule('Test Schedule', runTime, schClass);
        Test.stopTest();
    }
}