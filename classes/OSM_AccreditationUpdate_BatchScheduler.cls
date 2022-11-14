global class OSM_AccreditationUpdate_BatchScheduler implements Schedulable {
    global void execute(SchedulableContext SC) {
        
        OSM_AccreditationUpdate_Batch b = new OSM_AccreditationUpdate_Batch();
        Id batchJobId = Database.executeBatch(b, 200);
        
    }
}