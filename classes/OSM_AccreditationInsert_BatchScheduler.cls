global class OSM_AccreditationInsert_BatchScheduler implements Schedulable {
    global void execute(SchedulableContext SC) {
        
        OSM_AccreditationInsert_Batch b = new OSM_AccreditationInsert_Batch();
        Id batchJobId = Database.executeBatch(b, 200);
        
    }
}