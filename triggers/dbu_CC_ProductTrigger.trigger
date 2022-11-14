trigger dbu_CC_ProductTrigger on ccrz__E_Product__c (after update) {
    if(Trigger.isAfter){
        if(Trigger.isUpdate){
            dbu_ProductInventoryCtrl.updateInvCheckOnProduct(Trigger.new,Trigger.oldMap);
        }
    }
}