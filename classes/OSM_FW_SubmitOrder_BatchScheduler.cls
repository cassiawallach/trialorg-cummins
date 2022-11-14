global class OSM_FW_SubmitOrder_BatchScheduler implements Schedulable {
    global void execute(SchedulableContext SC) {        
        OSM_FW_SubmitOrder_Batch b = new OSM_FW_SubmitOrder_Batch();
        Id batchJobId = Database.executeBatch(b, 1);        
    }
}