/************************************************************
Name:  OSM_SW_SubscriptionTrigger 
Copyright © 2018  Cummins
=============================================================
=============================================================
Purpose:                                                            
This is trigger on subscription object which will work on 
after insert and after update call.  
=============================================================
=============================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE              DETAIL                                
1.0 -   Ankit S         01/07/2018     INITIAL DEVELOPMENT          


*************************************************************/
trigger OSM_SW_SubscriptionTrigger on ccrz__E_Subscription__c (before insert,after insert, before update ,after update) {
    
    if(trigger.isBefore){
        if(trigger.isInsert && !OSM_SW_SubscriptionTriggerHandler.isBeforeInsertExecuted){ 
            //Insert logic for before insert  
            OSM_SW_SubscriptionTriggerHandler.OnBeforeInsert(Trigger.new);
            OSM_SW_SubscriptionTriggerHandler.isBeforeInsertExecuted = true;
        }
        if(trigger.isUpdate && !OSM_SW_SubscriptionTriggerHandler.isBeforeUpdateExecuted){
            //Insert logic for before update
            //update subscription if non one time order is getting cancelled and One time is existing
            OSM_SW_SubscriptionTriggerHandler.updateSusbcriptionSPT(Trigger.new, Trigger.oldMap);
            OSM_SW_SubscriptionTriggerHandler.isBeforeUpdateExecuted = true;
        }
    }

    if(trigger.isAfter){
        if(trigger.isInsert && !OSM_SW_SubscriptionTriggerHandler.isAfterInsertExecuted ){
            //Insert logic for after insert
            OSM_SW_SubscriptionTriggerHandler.OnAfterInsert(Trigger.newMap);   
            // update the status of the CopySubscriptionStatus in the IAM provisioning junction object
            OSM_SW_SubscriptionTriggerHandler.createIAMProvisioning(Trigger.newMap);     
            OSM_SW_SubscriptionTriggerHandler.isAfterInsertExecuted = true; 
        }
        if(trigger.isUpdate){
            if(!OSM_SW_SubscriptionTriggerHandler.isAfterUpdateExecuted)
            {
                //Insert logic for before update
                OSM_SW_SubscriptionTriggerHandler.OnAfterUpdate(trigger.oldMap,trigger.newMap);
                
                //update account billing frequency & payment method if subscription's last payment done
                OSM_SW_SubscriptionTriggerHandler.afterSubscriptionLastPaymentDone(trigger.new,trigger.oldMap);
                
                OSM_SW_SubscriptionTriggerHandler.isAfterUpdateExecuted = true;
        	}
            
            system.debug('updateSubscriptionStatus called');
            OSM_SW_SubscriptionTriggerHandler.updateSubscriptionStatus(trigger.oldMap,trigger.newMap);
         }
    }
               
}