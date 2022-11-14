/**********************************************************************
Name:  OSM_SW_SalesRepEditQuoteTrigger
Copyright © 2018  Cummins
======================================================
======================================================
Purpose:                                                            
The purpose of this trigger is to update status values based on click of Edit quote button                                
======================================================
======================================================
History                                                            
-------                                                            
VERSION     AUTHOR                      DATE              DETAIL                                
 1.0 -    Adarsh Pidaparthy           4/13/2018     INITIAL DEVELOPMENT          


*****************************************************/
trigger OSM_SW_SalesRepEditQuoteTrigger on ccrz__E_RequestForQuote__c (before update, after update) {

    list<ccrz__E_RequestForQuote__c> rfqlist = new list<ccrz__E_RequestForQuote__c>();
    
    if(trigger.isbefore && trigger.isupdate){
        OSM_SW_SalesRepEditQuoteTriggerHandler.onBeforeUpdate(Trigger.new,Trigger.oldMap);
       //OSM_SW_SalesRepEditQuoteTriggerHandler.onAfterUpdate(Trigger.new,Trigger.oldMap);
        OSM_SW_SalesRepEditQuoteTriggerHandler.priceAndDiscountCalculation(Trigger.new,Trigger.oldMap);
     }
    
    if(trigger.isafter && trigger.isupdate){
       // OSM_SW_SalesRepEditQuoteTriggerHandler.onBeforeUpdate(Trigger.new,Trigger.oldMap);
        //OSM_SW_SalesRepEditQuoteTriggerHandler.onAfterUpdate(Trigger.new,Trigger.oldMap);
        OSM_SW_QuoteExpiredEmailCtlr.SendEmail(Trigger.new,Trigger.oldMap); 
     }
    
    /*
    if(trigger.isUpdate && trigger.isafter){
        OSM_SW_General_Util.quoteApexSharing(trigger.new[0].Id);
    }*/
}