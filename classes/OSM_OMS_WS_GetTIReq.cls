public class OSM_OMS_WS_GetTIReq 
{
    public class Sender 
    {
        public String ServiceName;
        public String SenderID;
    }
    
    public class Target 
    {
        public String TargetID;
    }
    
    public Header Header;
    public GetTIFromLicenseKeyInput GetTIFromLicenseKeyInput;
    
    public class Message 
    {
        public String MessageID;
        public String Timestamp;
    }
    
    public class Header 
    {
        public Sender Sender;
        public Target Target;
        public Message Message;
    }
    
    public class GetTIFromLicenseKeyInput 
    {
        public String ToolName;
        public String ActivationKey;
    }
    
    public static OSM_OMS_WS_GetTIReq parse(String json) 
    {
        return (OSM_OMS_WS_GetTIReq) System.JSON.deserialize(json, OSM_OMS_WS_GetTIReq.class);
    }
}