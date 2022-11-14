public class CallCancleOrderProcessQuable implements Queueable {
    public id orderId;
    public void execute(QueueableContext context) {
        Set<Id> setItemId = new Set<Id>();
        if(orderId != null)
        {
            setItemId.add(orderId);
            OSM_SW_OrderCancellationUtility.updateRecordsOnOrderCancellation(setItemId);
            OSM_SW_OrderTriggerHandlerUtility.getOrderCancel(setItemId);
        }
    }
}