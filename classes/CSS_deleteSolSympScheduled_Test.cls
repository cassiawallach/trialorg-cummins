@isTest 
public class CSS_deleteSolSympScheduled_Test {

    static TestMethod void testScheduler() {

        CSS_deleteSolSympScheduled schClass = new CSS_deleteSolSympScheduled();
        String runTime = '0 0 23 * * ?';
        
        CSS_Solutions__c sol = new CSS_Solutions__c();
        sol.Name = 'Test Position';
        insert sol;

        Test.startTest();
            system.schedule('Test Schedule', runTime, schClass);
        Test.stopTest();
    }

}