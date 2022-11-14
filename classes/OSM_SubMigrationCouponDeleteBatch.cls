/************************************************************
Name:  OSM_SubMigrationCouponDeleteBatch
Copyright © 2018  Cummins
=============================================================
=============================================================
Purpose:                                                            
This batch is written to delete existing mapped coupons
=============================================================
=============================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE              DETAIL                                
1.0 -   Sangeeta            07/08/2019    INITIAL DEVELOPMENT          


*************************************************************/

global class OSM_SubMigrationCouponDeleteBatch implements Database.Batchable<sObject>,Database.AllowsCallouts, Schedulable{
    
    String query;
   
   
    global Database.QueryLocator start(Database.BatchableContext BC){
        
        query='select id,Dealer_Coupon_Code__c,Discount_for_Distributors_for_Backend__c,Distributor_Coupon_Code__c from OSM_Existing_Subscription__c where (Dealer_Coupon_Code__c!=null or Discount_for_Distributors_for_Backend__c!=null or Distributor_Coupon_Code__c!=null)';
        return Database.getQueryLocator(query);
    }
 
    global void execute(Database.BatchableContext BC, List<OSM_Existing_Subscription__c> scope){               
       List<OSM_Existing_Subscription__c> recordsToUpdate=new List<OSM_Existing_Subscription__c>();
       
       
       for(OSM_Existing_Subscription__c sub :scope)
       {
           sub.Dealer_Coupon_Code__c='';
           sub.Discount_for_Distributors_for_Backend__c=0.0;
           sub.Distributor_Coupon_Code__c='';
           recordsToUpdate.add(sub);
       }                                                                          
       
        if(recordsToUpdate!=null && recordsToUpdate.size()>0)
        {
            update recordsToUpdate;
        }
    }

    global void finish(Database.BatchableContext BC){
        OSM_Integration_Log__c log = new OSM_Integration_Log__c();
        log.Service_Name__c='OSM_SubMigrationCouponDeleteBatch';
        log.Internal_Batch_Log__c=true;
        AsyncApexJob jobstatus = [SELECT Id, Status, NumberOfErrors, JobItemsProcessed,TotalJobItems, CreatedBy.Email FROM AsyncApexJob WHERE Id =:BC.getJobId()];
        log.Status__c = jobstatus.Status;
        if(jobstatus.Status=='Completed'){
            log.Status__c = 'Processed'; 
        }else if(jobstatus.Status=='Failed'){
            log.Internal_Batch_Failure__c=true;
            log.No_of_Jobs_Failed__c=jobstatus.NumberOfErrors;
        }
        insert log;
        
        OSM_SubscriptionMigrationBatch subMigrationBatch = new OSM_SubscriptionMigrationBatch();
        Database.executeBatch(subMigrationBatch,1);
    }

    global  void execute(System.SchedulableContext SC){
        Database.executeBatch(new OSM_SubMigrationCouponDeleteBatch());
    }
}