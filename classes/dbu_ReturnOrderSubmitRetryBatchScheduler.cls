global class dbu_ReturnOrderSubmitRetryBatchScheduler implements Schedulable{
    
    global void execute(SchedulableContext SC){
        dbu_ReturnOrderSubmitRetryBatch returnOrderSubmit= new dbu_ReturnOrderSubmitRetryBatch();
        database.executebatch(returnOrderSubmit,1);
    }
    
}