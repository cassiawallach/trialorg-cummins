global class OSM_WS_ScheduleVertexBatchJob implements Schedulable{
    
    global void execute(SchedulableContext SC){
        OSM_WS_RetryVertexJobs bjobs = new OSM_WS_RetryVertexJobs();
        database.executebatch(bjobs,1);
    }
    
}