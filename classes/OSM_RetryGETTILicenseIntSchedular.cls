global class OSM_RetryGETTILicenseIntSchedular implements Schedulable
{
 /* global static String scheduleInterCompanyRetryBatch(){
        String CRON_EXP = '0 0 * * * ?'; 
        OSM_RetryGETTILicenseIntSchedular  sch=new OSM_RetryGETTILicenseIntSchedular();
        return system.schedule('OSM_RetryGETTIIntSchedular',CRON_EXP,sch); // every hour
        // return null;
    }*/
    
    global void execute(SchedulableContext SC){
        OSM_OMS_GetTI_HourlyBatch bjobs = new OSM_OMS_GetTI_HourlyBatch();
        Database.executeBatch(bjobs,1);       
    }
}