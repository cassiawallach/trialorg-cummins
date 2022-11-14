trigger OSM_SW_InvoiceTrigger on ccrz__E_Invoice__c (before insert,after insert,before update,after update) {



    if( Trigger.isInsert )
    {
        if(Trigger.isBefore)
        {
            OSM_SW_InvoiceTriggerHandler.OnBeforeInsert(trigger.NewMap);
        }
        else
        {
            OSM_SW_InvoiceTriggerHandler.OnAfterInsert(trigger.NewMap);
        }
    }
    else if ( Trigger.isUpdate )
    {
        if(Trigger.isBefore)
        {
            OSM_SW_InvoiceTriggerHandler.OnBeforeUpdate(trigger.OldMap,trigger.NewMap);
        }
        else
        {
            OSM_SW_InvoiceTriggerHandler.OnAfterUpdate(Trigger.OldMap,Trigger.NewMap);
        }
    }

}