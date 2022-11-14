global class OSM_UpdateOrderCancel_BatchScheduler implements Schedulable {
    global void execute(SchedulableContext SC) {
        
        OSM_SW_UpdateOrderCancel_Retry_Batch osmUOC = new OSM_SW_UpdateOrderCancel_Retry_Batch();
        Database.executeBatch(osmUOC, 1);
    }
}