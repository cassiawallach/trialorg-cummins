/**********************************************************************
Name:  OSM_SW_SalesRepInActiveTrigger
Copyright © 2018  Cummins
======================================================
======================================================
Purpose:                                                            
The purpose of this trigger is to update status values as InActive when the status is in requested,in progress or sent status
and when the order item is inserted. The updation of status as "InActive" happens on comparison of contact and product values 
on CC Request for Quoten and CC Order items.                               
======================================================
======================================================
History                                                            
-------                                                            
VERSION     AUTHOR                      DATE              DETAIL                                
 1.0 -    Adarsh Pidaparthy           4/13/2018     INITIAL DEVELOPMENT          


*****************************************************/ 
trigger OSM_SW_SalesRepInActiveTrigger on ccrz__E_OrderItem__c(after insert,before insert,after update) {
    List<ccrz__E_OrderItem__c> triggerNewLst = new List<ccrz__E_OrderItem__c>();       
    if(trigger.isAfter&&trigger.isInsert){
        for(ccrz__E_OrderItem__c rec:trigger.new){
            if(rec.ccrz__StoreId__c != 'CSSNAStore') {
                //OSM_SW_SalesRepInActiveTriggerHandler.onAfterInsert(Trigger.new);
                triggerNewLst.add(rec);
                //OSM_SW_OrderItemTriggerHandler.OnAfterInsertTotalUsedUpdate(Trigger.new);
            }            
        }
        if(triggerNewLst != null && triggerNewLst.size() > 0) {
            OSM_SW_SalesRepInActiveTriggerHandler.onAfterInsert(triggerNewLst);
            OSM_SW_OrderItemTriggerHandler.OnAfterInsert(triggerNewLst);
        }
    }
    if(trigger.isBefore&&trigger.isInsert){
    for(ccrz__E_OrderItem__c rec:trigger.new){
        if(rec.ccrz__StoreId__c != 'CSSNAStore') {
            triggerNewLst.add(rec);
            //OSM_SW_OrderItemTriggerHandler.OnAfterInsert(Trigger.new);
            //OSM_SW_OrderItemTriggerHandler.onBeforeInsert(Trigger.new);
            }        	
        }
        if(triggerNewLst != null && triggerNewLst.size() > 0) {
            OSM_SW_OrderItemTriggerHandler.OnAfterTaxUpdate(triggerNewLst);
            OSM_SW_OrderItemTriggerHandler.onBeforeInsert(triggerNewLst);
        }
    }
    
    // Fixes for MAR-1499
    if(trigger.isBefore &&trigger.isUpdate){
        OSM_SW_OrderItemTriggerHandler.beforeUpdate(trigger.new, trigger.oldMap);
    }

    //Mar-1266
    if(trigger.isAfter && trigger.isUpdate){
        system.debug('**inside trigger**');
        Set<Id> itemIdSet = new Set<Id>();
        for(ccrz__E_OrderItem__c rec:trigger.new){
            if(rec.ccrz__StoreId__c != 'CSSNAStore') {
                triggerNewLst.add(rec);
                if(rec.ccrz__OrderItemStatus__c == 'Cancelled')  
                itemIdSet.add(rec.Id);
            }
        }
        //for(ccrz__E_OrderItem__c rec:trigger.new){
            //system.debug('**inside trigger for loop***'+rec.ccrz__StoreId__c);
            OSM_SW_OrderItemTriggerHandler.OnAfterUpdateTotalUsedUpdate(trigger.new, trigger.oldMap);
            if(triggerNewLst != null && triggerNewLst.size() > 0) {
                OSM_SW_OrderItemTriggerHandler.onAfterUpdate(triggerNewLst, trigger.oldMap);
                OSM_SW_OrderItemTriggerHandler.onAfterUpdateAutomatedProcessImplementation(triggerNewLst, trigger.oldMap);
            }
        //}
         // for IAM update MAR-130
         if(itemIdSet != null && itemIdSet.size() > 0)
         {
             OSM_SW_OrderCancelUtilForPage.updateIAMRecord(itemIdSet);
             
         }
    }
}