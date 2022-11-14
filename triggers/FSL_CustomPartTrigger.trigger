trigger FSL_CustomPartTrigger on FSL_Custom_Part__c (After Update) {
    if(Trigger.isAfter && Trigger.isUpdate){
        FSL_CustomPartTriggerHandler.handleAfterUpdate(Trigger.new,Trigger.oldmap);
    }
}