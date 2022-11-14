@isTest
public class FSL_NightlyComm_ScheduleBatchJobs_Test {
    
    static TestMethod void testScheduler() {
        
        FSL_NightlyComm_ScheduleBatchJobs  FSLNightlyJob  = new FSL_NightlyComm_ScheduleBatchJobs();
        String runTime = '0 0 3 * * ? *';
        
        Test.startTest();
        
        FSL_NightlyComm_ScheduleBatchJobs  s = new FSL_NightlyComm_ScheduleBatchJobs();
        s.schedule_Send_Communication_Nightly_BMS();
        s.schedule_Send_Communication_Nightly_MOVEX();
        s.schedule_Send_Communication_Nightly_MOVEXMYD();
        s.schedule_Send_Communication_Nightly_MOVEXUK();
        
        Test.stopTest();
    }
}