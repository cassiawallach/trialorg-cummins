trigger dbu_CC_ProductInvTrigger on ccrz__E_ProductInventoryItem__c (after update,after insert) {
    if(Trigger.isAfter){
        if(Trigger.isUpdate || Trigger.isInsert){
            dbu_ProductInventoryCtrl.getInvStatus(Trigger.new);
        }
    }
}