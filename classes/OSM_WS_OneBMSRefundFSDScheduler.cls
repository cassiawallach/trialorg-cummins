global class OSM_WS_OneBMSRefundFSDScheduler implements Schedulable
{
    global void execute(SchedulableContext SC){
        OSM_WS_RetryOneBMSRefundFSDCall bjobs = new OSM_WS_RetryOneBMSRefundFSDCall();
        Database.executeBatch(bjobs,1);       
    }
}