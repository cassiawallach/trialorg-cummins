global class OSM_Subscription_RevokedScheduler implements Schedulable{
    
    global void execute(SchedulableContext SC){
        OSM_Subscription_RevokedAlertbatch revokeBatch= new OSM_Subscription_RevokedAlertbatch();
        database.executebatch(revokeBatch,1);
    }
    
}