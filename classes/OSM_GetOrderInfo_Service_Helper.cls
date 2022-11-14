public class OSM_GetOrderInfo_Service_Helper
{
    public static OSM_GetOrderInfoReq populateDynamicData(String OMSOrderID)
    {
        
        // Defining variable whose values will come through custom label(Static)
         
        String Service_Name_Quote = 'GetOrder';
        String Sender_ID = 'Mrktplc';
        String Target_ID = 'OMS';
        
        OSM_GetOrderInfoReq objReq = new OSM_GetOrderInfoReq();
        objReq.Header = new OSM_GetOrderInfoReq.Header();
        objReq.Header.Sender = new OSM_GetOrderInfoReq.Sender();
        objReq.Header.Target = new OSM_GetOrderInfoReq.Target();
        objReq.GetOrderInfoInput = new OSM_GetOrderInfoReq.GetOrderInfoInput();
        objReq.Header.Sender.ServiceName = Service_Name_Quote;
        objReq.Header.Sender.SenderID = Sender_ID;
        objReq.Header.Target.TargetID = Target_ID;
        
        objReq.GetOrderInfoInput.ToolName = 'INSITE';
        objReq.GetOrderInfoInput.OMSOrderID = OMSOrderID;
    
        
        return objReq;
    }
    
    

}