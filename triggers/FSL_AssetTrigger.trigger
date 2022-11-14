trigger FSL_AssetTrigger on Asset (after update) {
      if(trigger.isAfter && trigger.isUpdate) {
         FSL_AssetTriggerHandler.updateVIN(trigger.newmap,trigger.oldmap);
      }
}