global class OSM_Subscription_ExpiredScheduler implements Schedulable{
    
    global void execute(SchedulableContext SC){
        OSM_Subscription_ExpiredAlertbatch expAlertBatch= new OSM_Subscription_ExpiredAlertbatch();
        database.executebatch(expAlertBatch,1);
    }
    
}