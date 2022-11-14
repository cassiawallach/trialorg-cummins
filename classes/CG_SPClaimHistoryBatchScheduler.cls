/*
 * Block comments with details of changes
 */
global class CG_SPClaimHistoryBatchScheduler implements Schedulable
{
    global void execute (SchedulableContext sc)
    {
            CG_SPClaimHistoryBatch  SchdBatch = new CG_SPClaimHistoryBatch();
            System.scheduleBatch (SchdBatch,'submissionSPClaimHistBatchSchedule',1); 
    }
}