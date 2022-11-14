trigger OSM_SW_OrderTrigger on ccrz__E_Order__c (before insert,before update,after insert,after update) {




if( Trigger.isInsert )
    {
    
       
        if(Trigger.isBefore)
        {

            OSM_SW_OrderTriggerHandler.OnBeforeInsert(Trigger.new);
        }
        else
        {
            OSM_SW_OrderTriggerHandler.OnAfterInsert(Trigger.newMap);
        }
    }
    else if ( Trigger.isUpdate )
    {
        
        if(Trigger.isBefore)
        {
            
            OSM_SW_OrderTriggerHandler.OnBeforeUpdate(Trigger.oldMap,Trigger.newMap);
        }
        else
        {
            OSM_SW_OrderTriggerHandler.OnAfterUpdate(Trigger.oldMap,Trigger.newMap);
        }
    }

    if(trigger.isUpdate && trigger.isAfter){
        
    }
}