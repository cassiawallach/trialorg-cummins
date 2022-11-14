/**********************************************************************
Name: FSLAssignedResourceTrigger
Copyright Â© 2019  Cummins
======================================================
======================================================
Purpose:                                                            
-------  
This is used for the update the assigned resuorce in the service appointment in after insert and after update context.
======================================================
======================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE                DETAIL                                 
1.0 - Vinod Yelala      12/20/2018      INITIAL DEVELOPMENT         
2.0 - Vijay/Rajkumar    6/28/2021       Added logic to avoid Trigger Recursion
***********************************************************************/ 
trigger FSLAssignedResourceTrigger on AssignedResource (after insert, after update) {
    //Added check to stop recursion
    //
    if((Trigger.isInsert || Trigger.isUpdate) && Trigger.isAfter){
        system.debug('Inside Assigned Resource After Insert');

        if(Trigger.isInsert) {

            Map<Id,AssignedResource> mapAssignedResources = new Map<Id,AssignedResource>();
            for(AssignedResource ar: Trigger.new){
                System.debug('\n vp --- Assigned Res Service Crewid= \n' + ar.ServiceCrewId);
                if(ar.serviceCrewID!=null) {
                    mapAssignedResources.put(ar.id,ar);
                }
            }

            if(mapAssignedResources.keyset().size()>0) {
                FSLAssignedResourceAsynchronousCall.cloneSAForAssignedResource(JSON.serialize(mapAssignedResources));
            }

        }
        
        if(RecursiveTriggerHandler.isAssignedResource == true){
            RecursiveTriggerHandler.isAssignedResource = false;
        
			FSL_AssignedResourceTriggerHandler.updateSATechandBay(Trigger.oldMap, Trigger.NewMap);
        }
    }
}