@isTest
public class FSL_Send_Com_Nightly_MOVEXUK_Schd_Test{
   
    static TestMethod void testScheduler() {
       
        FSL_Send_Com_Nightly_MOVEXUK_Schedular FSLNightlyJob = new FSL_Send_Com_Nightly_MOVEXUK_Schedular();
        String runTime = '0 59 * * * ?';
        
        Test.startTest();
        system.schedule('FSLNightly', runTime, FSLNightlyJob);
        Test.stopTest();
       
    }
}