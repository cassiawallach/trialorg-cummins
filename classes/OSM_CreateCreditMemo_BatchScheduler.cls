global class OSM_CreateCreditMemo_BatchScheduler implements Schedulable {
    global void execute(SchedulableContext SC) {
        
        OSM_SW_CreateCreditMemo_Retry_Batch osmCCM = new OSM_SW_CreateCreditMemo_Retry_Batch();
        Database.executeBatch(osmCCM, 1);
    }
}