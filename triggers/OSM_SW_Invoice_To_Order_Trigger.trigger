trigger OSM_SW_Invoice_To_Order_Trigger on OSM_Orders_In_Invoice__c (after insert,after update) {

    System.debug('process trigger');
        if( Trigger.isInsert )
        {
            if(Trigger.isAfter)
            {
                OSM_SW_InvoiceToOrderTriggerHandler.OnAfterInsert(trigger.NewMap);
            }
        }
    
}