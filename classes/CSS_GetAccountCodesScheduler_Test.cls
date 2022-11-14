@IsTest
public class CSS_GetAccountCodesScheduler_Test {
    
    static TestMethod void testScheduler() {

        CSS_GetAccountCodesScheduler schClass = new CSS_GetAccountCodesScheduler();
        String runTime = '0 0 23 * * ?';
        
        Test.startTest();
        system.schedule('Test Schedule', runTime, schClass);
        Test.stopTest();
    }

}