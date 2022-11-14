/******************************************************************************************************
Name : FSL_ServiceOrderContactTrigger 
Description : ServiceOrderContact object Trigger.
Description2 : using this trigger to check duplicate records while inserting and updating SOC 

Version                 Date                    Author                             Summary Of Change
--------------------------------------------------------------------------------------------------------- 
1.0                   06/08/2020               Arpita Sarangee                   Trigger created
*********************************************************************************************************/

trigger FSL_ServiceOrderContactTrigger on ServiceOrderContact__c (before insert,before update, after insert,after update) {
    if(trigger.isBefore && (trigger.isInsert /*|| trigger.isUpdate*/)) {
        if(!FSL_serviceOrderContactTriggerHandler.isSOCInsert){
            FSL_serviceOrderContactTriggerHandler.isSOCInsert= true;
            FSL_serviceOrderContactTriggerHandler.insertServiceOrderContactList(Trigger.New);
            FSL_serviceOrderContactTriggerHandler.ServiceOrderContactAfterInsert(Trigger.New);
        }  
    
    }
   if (trigger.isafter && trigger.isInsert){
    FSL_serviceOrderContactTriggerHandler.ServiceOrderContactAfterInsert(Trigger.New);
    }
    
        if(trigger.isBefore && (trigger.isUpdate)) {
       
         
            FSL_serviceOrderContactTriggerHandler.insertServiceOrderContactListUpdate(Trigger.New,Trigger.OldMap);
          
        
    
    }
    
}