@isTest 
public class CSS_TG_StoreIARecordsInMDCScheduler_Test {

    static TestMethod void testScheduler() {
        CSS_TG_StoreIARecordsInMDCScheduler iasScheduler = new CSS_TG_StoreIARecordsInMDCScheduler();
        String runTime = '0 30 * * * ?'; //for every 1 hour
        Test.startTest();
        System.schedule('Test Schedule', runTime, iasScheduler);
        Test.stopTest();
    }

}