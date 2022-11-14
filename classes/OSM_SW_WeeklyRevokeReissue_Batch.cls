global class OSM_SW_WeeklyRevokeReissue_Batch implements Schedulable{

    public static final String jobName = (Test.isRunningTest() ? 'Test  ' : '') +'OSM_SW_WeeklyRevokeReissue_Batch';
    
    global void execute(SchedulableContext SC){
        Database.executebatch(new OSM_SW_RevokeInstanceBatch(),1);
        Database.executebatch(new OSM_SW_CreateGetOrder_ON_ReIssueBatch(),1);
        Database.executebatch(new OSM_OMS_GetTI_ON_Revoked_Batch(),1);
    }
    
    // method to schedule the job
    public static void schedule() {
       
    	//Added by Swetha Jira-1002
    	//Schedule job to run at every every saturday weekly        
        //system.schedule('OSM_SW_RevokeInstanceBatch_Weekly', '0 0 * * 6 ?', new OSM_SW_RevokeInstanceBatch());
        //system.schedule('OSM_SW_CreateGetOrder_ON_ReIssueBatch_Weekly', '0 0 * * 6 ?', new OSM_SW_CreateGetOrder_ON_ReIssueBatch());
        //system.schedule('OSM_OMS_GetTI_ON_Revoked_Batch_Weekly', '0 0 * * 6 ?', new OSM_OMS_GetTI_ON_Revoked_Batch());      
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