global class OSM_OMS_CreateOrderScheduler implements Schedulable
{
	global static String scheduleCreateOrderRetryBatch(){
        OSM_OMS_CreateOrderScheduler sc = new OSM_OMS_CreateOrderScheduler();
        return system.schedule('OSM OMS Create Order Retry Batch', Label.OSM_OMS_RETRY_CREATEORDER_CRON, sc); // every hour
    }
    
    global void execute(SchedulableContext SC){
        OSM_OMS_CreateOrder_Retry_Batch bjobs = new OSM_OMS_CreateOrder_Retry_Batch();
        Database.executeBatch(bjobs,5);       
    }
}