trigger OSM_AccountGroupMappingTrigger on Account (before insert, before update) 
{  
    if(Trigger.isbefore && (Trigger.isInsert || Trigger.isUpdate))
    {
        OSM_SW_BoltInformation_Helper.updateBoltInfo(Trigger.new);
        
    }
  //  Boolean activateTrigger = false;
      Boolean activateTrigger = true;
    if(activateTrigger)
    {
        OSM_AccountGroupMapping_Helper.updateAccountGroup(Trigger.new);
    }
}