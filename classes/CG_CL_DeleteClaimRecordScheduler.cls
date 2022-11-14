global class CG_CL_DeleteClaimRecordScheduler implements Schedulable {
    global void execute(SchedulableContext SC) {
        CG_CL_DeleteClaimRecordBatch b = new CG_CL_DeleteClaimRecordBatch();
        
        Id batchJobId = Database.executeBatch(b, 200);
    }
}