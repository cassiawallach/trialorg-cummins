global class OSM_BAMS_RefundOnOrderCancelScheduler implements Schedulable{
    
    //Seconds Minutes Hours Day_of_month Month Day_of_week optional_year
    //public static String cron_exp = '0 0 1 ? * *';  //Every day at 1am
        
    global static String scheduleRefundOnOrderCancelBatch(){
        if(Test.isRunningTest()) {
        	OSM_BAMS_RefundOnOrderCancelScheduler sc = new OSM_BAMS_RefundOnOrderCancelScheduler();
        	return system.schedule('OSM Refund Payment Test', Label.OSM_REFUND_BAMS_CRON, sc);
        }
        else {
            OSM_BAMS_RefundOnOrderCancelScheduler sc = new OSM_BAMS_RefundOnOrderCancelScheduler();
        	return system.schedule('OSM Refund Payment', Label.OSM_REFUND_BAMS_CRON, sc);
        }
    }
    
    global void execute(SchedulableContext SC){
        OSM_BAMS_RefundOnOrderCancelBatch bjobs = new OSM_BAMS_RefundOnOrderCancelBatch();
        Database.executeBatch(bjobs,1);       
    }
}