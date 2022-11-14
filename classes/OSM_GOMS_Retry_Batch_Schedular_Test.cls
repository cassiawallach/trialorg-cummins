/************************************************************
Name:  OSM_GOMS_Retry_Batch_Schedular_Test
Copyright © 2019  Cummins
=============================================================
=============================================================
Purpose:                                                            
This is test class for OSM_GOMS_Retry_Batch_Schedular class.                          
=============================================================
=============================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE              DETAIL                                
1.0 -    Rupesh Ranjan     15/06/2020        INITIAL DEVELOPMENT          
*****************************************************/
@isTest
private class OSM_GOMS_Retry_Batch_Schedular_Test
{

    static testmethod void schedulerTest() 
    {
        String CRON_EXP = '0 0 0 15 3 ? *';
        Test.startTest();

            String jobId = System.schedule('ScheduleApexClassTest',  CRON_EXP, new OSM_GOMS_Retry_Batch_Schedular());
            CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, NextFireTime FROM CronTrigger WHERE id = :jobId];
            System.assertEquals(CRON_EXP, ct.CronExpression);
            System.assertEquals(0, ct.TimesTriggered);
            System.assertEquals(CRON_EXP, ct.CronExpression);
            System.assertEquals(0, ct.TimesTriggered);

        Test.stopTest();
        
    }
}