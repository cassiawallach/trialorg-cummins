@isTest 
public class CG_MiscChargeLOV_Scheduler_Test{
    static TestMethod void testScheduler() {
        CG_MiscChargeLOV_Scheduler schClass = new CG_MiscChargeLOV_Scheduler();
        String runTime = '0 0 23 * * ?';
        Test.startTest();
        System.schedule('Test Schedule', runTime, schClass);
        Test.stopTest();
    }
}