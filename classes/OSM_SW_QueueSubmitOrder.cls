public class OSM_SW_QueueSubmitOrder implements Queueable, Database.AllowsCallouts {
    Id orderId;
    public OSM_SW_QueueSubmitOrder(Id order) {
        orderId= order;
    } 
    public void execute(QueueableContext context) {
        OSM_ReturnWrapper objRet = new OSM_ReturnWrapper();
        objRet = OSM_WS_SubmitOrderBusiness_Handler.getOrderInfo(orderId,'Cancel',null,'partial cance',false,null);
        
        
        try{
            if(!objRet.exceptionFlag || Test.isRunningTest())
            {
                
                OSM_SW_OrderCancelUtilForPage.updateIntercompanyOrderCancelSucess(orderId);
                OSM_SW_OrderCancelUtilForPage.updateSubsc(orderId);
            }
            else
            {
               
                OSM_SW_OrderCancelUtilForPage.updateIntercompanyOrder(orderId);
                
            }
        }
        Catch(Exception ex)
        {
            system.debug('exception in updating records: '+ex);
        }
    }
}