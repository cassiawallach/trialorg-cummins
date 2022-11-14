//Updated By               Date Updated On
//Sangeeta Rani            10th March 2021
@istest
public class OSMMaintenanceMessageBatch_Test {
    static testMethod void testMethod1() 
    {
       OSM_Maintenance_Message__c o=new OSM_Maintenance_Message__c();
       o.Start_Date__c=System.today()-1;
       o.End_Date__c=System.today()+1;
       insert o;
        Test.startTest();

            OSMMaintenanceMessageBatch obj = new OSMMaintenanceMessageBatch();
            DataBase.executeBatch(obj); 
            
            String CRON_EXP = '0 0 0 15 3 ? *';
            String jobId = System.schedule('ScheduleApexClassTest',  CRON_EXP, new OSM_MaintenanceMessageSchedular());
            CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, NextFireTime FROM CronTrigger WHERE id = :jobId];            
        Test.stopTest();
    }


}