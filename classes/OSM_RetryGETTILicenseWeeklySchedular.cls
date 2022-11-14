global class OSM_RetryGETTILicenseWeeklySchedular implements Schedulable
{
  /*global static String scheduleInterCompanyRetryBatch(){
        String CRON_EXP = '0 0 8 * * 6'; 
        
        OSM_RetryGETTILicenseWeeklySchedular sch=new OSM_RetryGETTILicenseWeeklySchedular();
        return system.schedule('OSM_RetryGETTIIntWeeklySchedular',CRON_EXP,sch); // every week at 8 am on saturday
        // return null;
    }*/
    
    global void execute(SchedulableContext SC){
        OSM_OMS_GetTI_WeeklyBatch bjobs = new OSM_OMS_GetTI_WeeklyBatch();
        Database.executeBatch(bjobs,1);       
    }
}