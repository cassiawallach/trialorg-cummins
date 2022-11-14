/************************************************
 History
 --------
 VERSION    AUTHOR          DATE            DETAILS
 1.0        Ashish          06/03/2021      Test Class Fixes
 2.0        Subbu           07/28/2021      MAR-1861
 */
@isTest 
public class OSM_WS_Bolt_ScheduleReversalBatchJobTest{      
    String CRON_EXP = '0 0 0 15 3 ? *';  
       static testmethod void schedulerTest() 
    {
        String CRON_EXP = '0 0 0 15 3 ? *';
        Test.startTest();
            //OSM_WS_Bolt_ScheduleReversalBatchJobs ctrl = new OSM_WS_Bolt_ScheduleReversalBatchJobs();
            OSM_WS_Bolt_ScheduleReversalBatchJobs.scheduleIntegration();
            String jobId = System.schedule('ScheduleApexClassTest',  CRON_EXP, new OSM_WS_Bolt_ScheduleReversalBatchJobs());
            CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, NextFireTime FROM CronTrigger WHERE id = :jobId];
            System.assertEquals(CRON_EXP, ct.CronExpression);
            System.assertEquals(0, ct.TimesTriggered);
            System.assertEquals(CRON_EXP, ct.CronExpression);
            System.assertEquals(0, ct.TimesTriggered);

        Test.stopTest();
        
    }
    
    
}