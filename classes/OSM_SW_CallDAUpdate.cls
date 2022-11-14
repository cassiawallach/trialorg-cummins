global class OSM_SW_CallDAUpdate Implements Queueable,Database.AllowsCallouts{ 
    global Set<Id> orderIdToDAUpdate;
    public OSM_SW_CallDAUpdate(Set<Id> idSet)
    {
        orderIdToDAUpdate = new Set<Id>();
        orderIdToDAUpdate = idSet;
    }
    global void execute(QueueableContext context) { 
        OSM_SW_OrderActions.call_DA_OrderCancellationAsync(orderIdToDAUpdate);
    
    } 
    
}