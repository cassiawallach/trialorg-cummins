global class OSM_WS_IntercompanyIntRefundScheduler implements Schedulable
{
    global void execute(SchedulableContext SC){
        OSM_WS_RetryInterCompanyINTforRefund bjobs = new OSM_WS_RetryInterCompanyINTforRefund();
        Database.executeBatch(bjobs,1);    
        
        OSM_WS_RetryInterCompanyDistINTforRefund distJobs=new OSM_WS_RetryInterCompanyDistINTforRefund();
        Database.executeBatch(distJobs,1); 
        //MAR-1783 Code Start
        OSM_WS_RetryInterCompanyOItemforRefund oItemJobs = new OSM_WS_RetryInterCompanyOItemforRefund();
        Database.executeBatch(oItemJobs,1);
        OSM_WS_RetryInterCompanyDistOItemRefund oItemDistJobs = new OSM_WS_RetryInterCompanyDistOItemRefund();
        Database.executeBatch(oItemDistJobs,1);
        //MAR-1783 Code End
    }
}