global class OSM_OrderCreationTimeCheck_Schedular implements Schedulable {
    global void execute(SchedulableContext SC) {
        
        OSM_OrderCreationTimeCheck ba = new OSM_OrderCreationTimeCheck();
        Id batchJobId1 = Database.executeBatch(ba,1);
     
        
    }
}