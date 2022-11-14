public class OSM_OMS_WS_GetTIHelper 
{
    public static OSM_OMS_WS_GetTIReq populateRequestObjectDataForGetTI(OSM_OMS_WS_GetTI_GenInputWrapper generalizedInputWrapper)
    {
        OSM_OMS_WS_GetTIReq getTIReq = new OSM_OMS_WS_GetTIReq();
        
        getTIReq.Header = new OSM_OMS_WS_GetTIReq.Header();
        
        getTIReq.Header.Sender = new OSM_OMS_WS_GetTIReq.Sender();
        getTIReq.Header.Sender.ServiceName = 'GetTIFromLicenseKey';
        getTIReq.Header.Sender.SenderID = 'Mrktplc';
        
        getTIReq.Header.Target = new OSM_OMS_WS_GetTIReq.Target();
        getTIReq.Header.Target.TargetID = 'OMS';
        
        getTIReq.Header.Message = new OSM_OMS_WS_GetTIReq.Message();
        getTIReq.Header.Message.MessageID = generalizedInputWrapper.Header.Message.MessageID; // confirm if it should be order or orderItem ID
        getTIReq.Header.Message.Timestamp = generalizedInputWrapper.Header.Message.Timestamp;
        
        getTIReq.GetTIFromLicenseKeyInput = new OSM_OMS_WS_GetTIReq.GetTIFromLicenseKeyInput();
        getTIReq.GetTIFromLicenseKeyInput.ToolName = generalizedInputWrapper.GetTIFromLicenseKeyInput.ToolName;
        getTIReq.GetTIFromLicenseKeyInput.ActivationKey = generalizedInputWrapper.GetTIFromLicenseKeyInput.ActivationKey;
        
        return getTIReq;
    }
}