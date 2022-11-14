global class dbu_OrderSubmitRetryBatchScheduler implements Schedulable{
    
    global void execute(SchedulableContext SC){
        dbu_OrderSubmitRetryBatch orderSubmit= new dbu_OrderSubmitRetryBatch();
        database.executebatch(orderSubmit,1);
    }
    
}