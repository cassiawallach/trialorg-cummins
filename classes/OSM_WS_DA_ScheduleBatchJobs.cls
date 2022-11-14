/************************************************************
Name:  OSM_WS_DA_ScheduleBatchJobs
Copyright © 2018  Cummins
=============================================================
=============================================================
Purpose:                                                            
This is batch class which will take all failed order 
update and order cancellation jobs and will send it to 
scheduler which will run every 1 hr.               
=============================================================
=============================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE              DETAIL                                
1.0 -   Ankit S            12/07/2018     INITIAL DEVELOPMENT          

*************************************************************/

global class OSM_WS_DA_ScheduleBatchJobs implements Schedulable{
    
    public static String cron_exp = label.OSM_DA_Cron_Expression;  //Every Hour
    public static String batchName = label.OSM_DA_Batch_Name;
    global static String scheduleIntegration(){
        
        if(Test.isRunningTest()) {
            OSM_WS_DA_ScheduleBatchJobs sc = new OSM_WS_DA_ScheduleBatchJobs();
        	return system.schedule('OSM DA Integration Job Test', cron_exp, sc);
        }
        else {
            OSM_WS_DA_ScheduleBatchJobs sc = new OSM_WS_DA_ScheduleBatchJobs();
        	//return system.schedule('OSM DA Integration Job', cron_exp, sc);
        	return system.schedule(batchName, cron_exp, sc);
        }
        
    }
    
    global void execute(SchedulableContext SC){      
        OSM_SW_RetryOrderUpdateJobs bjobs = new OSM_SW_RetryOrderUpdateJobs();
        database.executebatch(bjobs,Integer.valueOf(label.OSM_OrderUpdate_BatchSize));
    }   
}