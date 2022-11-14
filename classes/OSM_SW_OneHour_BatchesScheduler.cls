global class OSM_SW_OneHour_BatchesScheduler implements Schedulable{
    public static final String jobName = (Test.isRunningTest() ? 'Test  ' : '') +'OSM_SW_OneHour_BatchesScheduler';
    
    global void execute(SchedulableContext SC){
        Database.executebatch(new OSM_SW_RevokeOIBatch(null),1);
        //Commented by Swetha Jira-1002 - Removed batch reference from per hour call.
        Database.executebatch(new OSM_SW_RevokeInstanceBatch(),1);
        Database.executebatch(new OSM_SW_CreateGetOrder_ON_ReIssueBatch(),1);
        Database.executebatch(new OSM_SW_CancelOIBatch(null),1);
        //Commented by Swetha Jira-1002 - Removed batch reference from per hour call.
        //Database.executebatch(new OSM_OMS_GetTI_ON_Revoked_Batch(),1);
        
        //OMS retrial batches..
        //Database.executeBatch(new OSM_OMS_CreateOrder_Retry_Batch(),1);
        //Database.executeBatch(new OSM_OMS_GetTI_HourlyBatch(),1); 
        Database.executeBatch(new OSM_OMS_SW_RevokeAPIFailurebatch(),1);
        Database.executeBatch(new OSM_CancelLicensesRetryIntBatch(),1);
    }
    
    // method to schedule the job
    public static void schedule() {
        // schedule job to run at every one hour 1:00 AM everyday
        String jobId1 = System.schedule(jobName, '0 0 * * * ?', new OSM_SW_OneHour_BatchesScheduler());
        
        System.schedule('OSM_OMS_CreateOrder_Retry_Batch-00', '0 0 * * * ?', new OSM_OMS_CreateOrder_Retry_Batch());
        System.schedule('OSM_OMS_CreateOrder_Retry_Batch-30', '0 30 * * * ?', new OSM_OMS_CreateOrder_Retry_Batch());
        
    }
    
    // method to cancel any scheduled jobs
    public static void cancel() {
        
        // loop through jobs and abort
        for (CronTrigger job : [SELECT Id, CronJobDetail.Name
                                FROM CronTrigger
                                WHERE CronJobDetail.Name = :jobName
                                AND NextFireTime != NULL])
        {
            System.abortJob(job.id);
        }
    }
    
}