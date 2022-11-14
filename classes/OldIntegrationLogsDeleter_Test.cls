/*Test class for OldIntegrationLogsDeleterSchedule and OldIntegrationLogsDeleter class
 * Author: Shirisha
 * Dated:11/17/2021
 * */

 
@isTest
public class OldIntegrationLogsDeleter_Test {
  
    @isTest
     private static void schedulerTest() 
    {
        List<OSM_Integration_Log__c> lstIntegrationLog= new List<OSM_Integration_Log__c>();
        String CRON_EXP = '0 0 0 15 3 ? *';
        String numberOfMonths = System.Label.OSM_Integration_Created_Month;
        Integer d=integer.valueof(numberOfMonths);
        Date today = System.today();
        Date last_n_month = today.addMonths(-d-1);
        dateTime createdDate = last_n_month;
        System.debug('Printing the created date in test class'+createdDate );
        for(Integer i=0 ;i <200;i++)
        {
            OSM_Integration_Log__c acc = new OSM_Integration_Log__c();
            acc.CreatedDate= createdDate ;
    		lstIntegrationLog.add(acc);
        }
        insert lstIntegrationLog;
        
         Test.startTest();
			String jobId = System.schedule('ScheduleApexClassTest',  CRON_EXP, new OldIntegrationLogsDeleterSchedule());
            CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, NextFireTime FROM CronTrigger WHERE id = :jobId];
            System.assertEquals(CRON_EXP, ct.CronExpression);
            System.assertEquals(0, ct.TimesTriggered);
		 Test.stopTest();
        
    }
}