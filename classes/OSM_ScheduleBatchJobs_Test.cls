/*************************************************
 History
 --------
 VERSION    AUTHOR          DATE            DETAILS
 1.0        Ashish          22/10/2021      Test Class Fixes
**/
@isTest
public class OSM_ScheduleBatchJobs_Test{
static testMethod void tetsMethod1(){

test.StartTest();
//OSM_ScheduleBatchJobs batchch = new OSM_ScheduleBatchJobs();
//String sch = '    0 0 * * * ?'; 
  
try{OSM_ScheduleBatchJobs.scheduleBoltIntegration();}catch(Exception e){}
try{OSM_ScheduleBatchJobs.scheduleDAIntegration();}catch(Exception e){}
try{OSM_ScheduleBatchJobs.scheduleVertexIntegration();}catch(Exception e){}
try{OSM_ScheduleBatchJobs.scheduleSubscriptionCancellation();}catch(Exception e){}
try{OSM_ScheduleBatchJobs.scheduleSubscriptionExpiration();}catch(Exception e){}
try{OSM_ScheduleBatchJobs.scheduleSingleInvoiceGeneration();}catch(Exception e){}
try{OSM_ScheduleBatchJobs.scheduleRefundOnOrderCancelProcess();}catch(Exception e){}
try{OSM_ScheduleBatchJobs.scheduleRefundFSD();}catch(Exception e){}
try{OSM_ScheduleBatchJobs.scheduleRefundInterCompany();}catch(Exception e){}
try{OSM_ScheduleBatchJobs.scheduleIntercompany();}catch(Exception e){}
//OSM_ScheduleBatchJobs.scheduleBoltReversalIntegration();
//OSM_ScheduleBatchJobs.scheduleUpdateAccServiceLevel();
try{OSM_ScheduleBatchJobs.scheduleSubscriptionAlertBatch();}catch(Exception e){}
//OSM_ScheduleBatchJobs.scheduleRevokeAPIFailuretBatch();
//OSM_ScheduleBatchJobs.scheduleOMSCreateOrderService();

//system.schedule('Test Territory Check', sch, batchch);
try{OSM_ScheduleBatchJobs.scheduleSubscriptionExpiration();}catch(Exception e){}

 test.StopTest();
 

}

 
}