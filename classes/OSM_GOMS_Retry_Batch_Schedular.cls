/**********************************************************************
Name:  OSM_AccounGroupScheduler
Copyright © 2018  Cummins
=======================================================================
=======================================================================
Purpose:                                                            
This schedule class to run the jobs of GOMSAPI failed records evry hour

=======================================================================
=======================================================================
History                                                            
-------                                                            
VERSION  AUTHOR                         DATE              DETAIL                                
1.0 -   Saikomal Kattmudi            14/03/2020     INITIAL DEVELOPMENT          
*************************************************************/


/*global class OMS_GOMSRetryBatch_Scheduler implements Schedulable{
    public static String cron_exp = '0 0 * * * ?';
                                        
     global static String scheduleGOMSrRetryBatch(){
        OMS_GOMSRetryBatch_Scheduler sc = new OMS_GOMSRetryBatch_Scheduler();
        return system.schedule('OSM OMS Create Order Retry Batch', cron_exp, sc); 
    }
    
    global  void execute(System.SchedulableContext SC){
        OSM_GOMS_Retry_Batch  obj = new OSM_GOMS_Retry_Batch ();
        Database.executeBatch(obj,5);
    }
}*/




global class OSM_GOMS_Retry_Batch_Schedular implements Schedulable {
    global void execute(SchedulableContext SC) {
        
        OSM_GOMS_Retry_Batch ba = new OSM_GOMS_Retry_Batch();
        Id batchJobId1 = Database.executeBatch(ba,1);
        
       OSM_GOMS_Cancel_Retry_Batch bb = new OSM_GOMS_Cancel_Retry_Batch();
        Id batchJobId2 = Database.executeBatch(bb, 1);
        
    }
}