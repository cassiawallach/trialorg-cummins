trigger FSL_ShopVehicleNumberTrigger on Shop_Vehicle_Number__c(before insert, before update,after insert, after update) {
     if(trigger.isBefore && trigger.isInsert) {
         FSL_SVNTriggerHandler.avoidDuplicateUser(Trigger.new, Trigger.oldMap, Trigger.Old);
     }
     
     if(trigger.isBefore && trigger.isUpdate) {
         FSL_SVNTriggerHandler.avoidDuplicateUser(Trigger.new, Trigger.oldMap, Trigger.Old);
     }
}