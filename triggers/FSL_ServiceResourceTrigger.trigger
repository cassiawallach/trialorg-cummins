/**********************************************************************
Name: FSL_ServiceResourceTrigger
Copyright Â© 2019  Cummins
======================================================
======================================================
Purpose:                                                            
-------  
======================================================
======================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE                DETAIL                                 
1.0 - Vinod Yelala      03/20/2019      INITIAL DEVELOPMENT                    
***********************************************************************/
trigger FSL_ServiceResourceTrigger on ServiceResource (before insert, before update) {
    
    if(Trigger.isBefore)
    {
        if(Trigger.isUpdate)
        {
            FSL_ServiceResourceTriggerHandler.beforeUpdateTrigger(Trigger.new, Trigger.oldMap);
        }
    }
}