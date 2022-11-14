public class OSM_SW_QueueOrderUpdateonCancel implements Queueable,Database.AllowsCallouts {
    Set<Id> setOrderId;
    public OSM_SW_QueueOrderUpdateonCancel(Set<Id> setOrder) {
        setOrderId= setOrder;
    }
    public void execute(QueueableContext context) {
        try
        {
               
               OSM_SW_OrderCancellationUtility.updateRecordsOnOrderCancellation(setOrderId);     //Call method to update sobject records
               OSM_SW_OrderTriggerHandlerUtility.getOrderCancel(setOrderId);
        }
        Catch(Exception ex)
        {
            system.debug('exception in updating records: '+ex);
        }
    }
}