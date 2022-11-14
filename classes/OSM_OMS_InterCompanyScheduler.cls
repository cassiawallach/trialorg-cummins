global class OSM_OMS_InterCompanyScheduler implements Schedulable
{
  /*global static String scheduleInterCompanyRetryBatch(){
        OSM_OMS_InterCompanyScheduler sc = new OSM_OMS_InterCompanyScheduler();
        return system.schedule('OSM Intercompany Retry Batch', Label.OSM_INTERCOMPANY_RETRY_CRON, sc); // every hour
    }*/
    
    global void execute(SchedulableContext SC){
        OSM_InterCompanyInvoice_RetryBatch bjobs = new OSM_InterCompanyInvoice_RetryBatch();
        Database.executeBatch(bjobs,1);       
    }
}