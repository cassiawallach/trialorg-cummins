/************************************************************
Name:  OSM_ScheduleBatchJobs 
Copyright © 2018  Cummins
=============================================================
=============================================================
Purpose:                                                            
This is generic class for scheduling various batch jobs
=============================================================
=============================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE              DETAIL                                
1.0 -   Ankit S         24/08/2018     INITIAL DEVELOPMENT          

*************************************************************/


global class OSM_ScheduleBatchJobs{
    
    //Schedule OneBMSFSD Cancel Job   
    global static void scheduleRefundFSD(){
        String cron_exp = label.OSM_VertexCron_Expr; //Every Hour
        
        OSM_WS_OneBMSRefundFSDScheduler  sc = new OSM_WS_OneBMSRefundFSDScheduler ();
        system.schedule('OSM OneBMSFSD Cancel Job', cron_exp, sc);
    }
    
    //Schedule InterCompany Cancel Job   
    global static void scheduleRefundInterCompany(){
        String cron_exp = label.OSM_VertexCron_Expr; //Every Hour
        
        OSM_WS_IntercompanyIntRefundScheduler  sc = new OSM_WS_IntercompanyIntRefundScheduler ();
        system.schedule('OSM IntercompanyInvoice Cancel Job', cron_exp, sc);
    }
    
    //Schedule InterCompany Job   
    global static void scheduleIntercompany(){
        String cron_exp = label.OSM_VertexCron_Expr; //Every Hour
        
            OSM_WS_RetryInterCompanyIntSchedular  sc = new  OSM_WS_RetryInterCompanyIntSchedular ();
        system.schedule('OSM IntercompanyInvoice Job', cron_exp, sc);
    }
    
    //Schedule Bolt Integration
    global static void scheduleBoltIntegration(){
        OSM_WS_Bolt_ScheduleBatchJobs.scheduleIntegration();
    }
    
    //Schedule Bolt Reversal
    global static void scheduleBoltReversalIntegration(){
        OSM_WS_Bolt_ScheduleReversalBatchJobs.scheduleIntegration();
    }
    
    //Schedule DA Integration
    global static void scheduleDAIntegration(){
        OSM_WS_DA_ScheduleBatchJobs.scheduleIntegration();
    }
    
    //Schedule Vertex Integration   
    global static void scheduleVertexIntegration(){
        String cron_exp = label.OSM_VertexCron_Expr; //Every Hour
        
        OSM_WS_ScheduleVertexBatchJob  sc = new OSM_WS_ScheduleVertexBatchJob ();
        system.schedule('OSM Vertex Integration Job', cron_exp, sc);
    }
    
    //Schedule subscription cancellation    
    global static void scheduleSubscriptionCancellation(){
        //Will be taken up in release 1B
        //OSM_WS_ScheduleSubscriptionCancellation.scheduleIntegration();
    }
    
    //Schedule subscription expiration  
    global static void scheduleSubscriptionExpiration(){
        String cron_exp = label.OSM_SubsExpirationCron_Expr ;  //Everyday at 1AM
        
        OSM_SW_SubExpBatchScheduler  sc = new OSM_SW_SubExpBatchScheduler ();
        system.schedule(Label.OSM_Subs_Expiration, cron_exp, sc);
    }

    //Schedule single invoice generation    
    global static void scheduleSingleInvoiceGeneration(){
        OSM_SW_SingleInvoiceGeneration_Scheduler.scheduleRecurringInvoiceBatch();
    }
    
    //Refund to BAMS on Order Cancel
    global static void scheduleRefundOnOrderCancelProcess(){
        OSM_BAMS_RefundOnOrderCancelScheduler.scheduleRefundOnOrderCancelBatch();
    }
    //Schedule to update service level on Account--Harshini 
    /*global static void scheduleUpdateAccServiceLevel(){
        String cron_exp = label.OSM_SubsExpirationCron_Expr ;  //Everyday at 1AM
        
        OSM_SerLevel_UpdateAccBatchScheduler  sc = new OSM_SerLevel_UpdateAccBatchScheduler ();
        system.schedule('Update Account Service Level', cron_exp, sc);
    }*/
    
    //Schedule Subscription Days alert batch that will run every hour -- Neha Sharma   
    global static void scheduleSubscriptionAlertBatch(){
        String cron_exp = label.OSM_VertexCron_Expr; //Every Hour
        
        OSM_Subscription_DaysAlertbatchScheduler  sc = new OSM_Subscription_DaysAlertbatchScheduler();
        system.schedule('OSM Subscription days alert batch', cron_exp, sc);
    }
    
     //Schedule RevokeAPIfailureBatch that will run every hour -- Neha Sharma   
    /*global static void scheduleRevokeAPIFailuretBatch(){
        String cron_exp = label.OSM_VertexCron_Expr; //Every Hour
        
        OSM_OMS_SW_RevokeAPIFailbatchScheduler  sc = new OSM_OMS_SW_RevokeAPIFailbatchScheduler();
        system.schedule('OSM RevokeApiFailureBatch', cron_exp, sc);
    }*/
    
    // Schedule OMS Create Order Retry Batch Service
    /*global static void scheduleOMSCreateOrderService()
    {
        OSM_OMS_CreateOrderScheduler.scheduleCreateOrderRetryBatch();
    }*/
}