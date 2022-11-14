/************************************************************
Name:  OSM_SW_SingleInvoiceGeneration_Scheduler 
Copyright © 2018  Cummins
=============================================================
=============================================================
Purpose:                                                            
This is scheduler class which will schedule the recurring invoice 
batch once in a day.

=============================================================
=============================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE              DETAIL                                
1.0 -   Vaibhav S        08/06/2018     INITIAL DEVELOPMENT          

*************************************************************/

global class OSM_SW_SingleInvoiceGeneration_Scheduler implements Schedulable{

    
    //Seconds Minutes Hours Day_of_month Month Day_of_week optional_year
    //public static String cron_exp = '0 0 1 ? * *';  //Every day at 1am
    public static String cron_exp = Label.OSM_Recurring_Invoice_Process_Cron;  //Every day at 1am
          
    global static String scheduleRecurringInvoiceBatch(){
        if(Test.isRunningTest()) {
            OSM_SW_SingleInvoiceGeneration_Scheduler sc = new OSM_SW_SingleInvoiceGeneration_Scheduler();
            return system.schedule('OSM Recurring Invoice Process Test', cron_exp, sc);
        }
        else {
            OSM_SW_SingleInvoiceGeneration_Scheduler sc = new OSM_SW_SingleInvoiceGeneration_Scheduler();
            return system.schedule(Label.OSM_Recurring_Invoice_Process, cron_exp, sc);
        }
    }
    
    global void execute(SchedulableContext SC){
        OSM_SW_Batch_Subscription_Processor bjobs = new OSM_SW_Batch_Subscription_Processor(); 
        Integer batchSize = 1;
        if(Label.OSM_Recurring_Invoice_Process_BatchSize!=''){
            batchSize = Integer.valueOf(Label.OSM_Recurring_Invoice_Process_BatchSize);
        }
        
        Database.executeBatch(bjobs,batchSize);
       
    }
    
    
    
}