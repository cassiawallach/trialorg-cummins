/**********************************************************************
Name: FSL_SetupResourceTrigger
Copyright Â© 2019  Cummins
======================================================
======================================================
Purpose:                                                            
-------  
======================================================
======================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE                DETAIL                                 
1.0 - Vinod Yelala      11/10/2019      INITIAL DEVELOPMENT                    
***********************************************************************/
trigger FSL_SetupResourceTrigger on Setup_Resource__c (after insert, after update, before insert, before update) {
    if(Trigger.isBefore) {
        if(Trigger.isInsert) {
            FSL_SetupResourceTriggerHandler.createServiceResourceAndUser(Trigger.new, null);
            FSL_SetupResourceTriggerHandler.switchRecordType(Trigger.new, null);
            
        }
        
        else if(Trigger.isUpdate) {
            FSL_SetupResourceTriggerHandler.createServiceResourceAndUser(Trigger.new, Trigger.oldMap);
            FSL_SetupResourceTriggerHandler.switchRecordType(Trigger.new, Trigger.oldMap);
        }
    }
    else if(Trigger.isAfter) {
        FSL_SetupResourceTriggerHelper.afterTrigger(Trigger.isInsert, Trigger.isUpdate, Trigger.new, Trigger.oldMap);
        // Starts added for updating user details with service territory timezone and territory code details.
        if(Trigger.isInsert) {
            FSL_SetupResourceTriggerHandler.updateUserDetails(Trigger.newMap, null);
        }
        else {
            FSL_SetupResourceTriggerHandler.updateUserDetails(Trigger.newMap, Trigger.oldMap);
        }
        // Ends added for updating user details with service territory timezone and territory code details.
    }
}