trigger OSM_SW_TransactionPaymentTrigger on ccrz__E_TransactionPayment__c (before insert,after insert,before update,after update) {

    System.debug('Tigger context : '+Trigger.isInsert);
    System.debug('Tigger context : '+Trigger.isUpdate);
    if( Trigger.isInsert )
    {
        if(Trigger.isBefore)
        {
            OSM_SW_TransactionPaymentTriggerHandler.OnBeforeInsert(trigger.New);
        }
        else
        {
            OSM_SW_TransactionPaymentTriggerHandler.OnAfterInsert(trigger.NewMap);
        }
    }
    else if ( Trigger.isUpdate )
    {
        if(Trigger.isBefore)
        {
            OSM_SW_TransactionPaymentTriggerHandler.OnBeforeUpdate(trigger.OldMap,trigger.NewMap);
        }
        else
        {
            OSM_SW_TransactionPaymentTriggerHandler.OnAfterUpdate(Trigger.OldMap,Trigger.NewMap);
        }
    }

}