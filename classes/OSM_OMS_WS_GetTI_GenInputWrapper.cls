public class OSM_OMS_WS_GetTI_GenInputWrapper
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
        public String AccountId;//Added By Dhiraj
    }
    
    public static OSM_OMS_WS_GetTI_GenInputWrapper parse(String json) 
    {
        return (OSM_OMS_WS_GetTI_GenInputWrapper) System.JSON.deserialize(json, OSM_OMS_WS_GetTI_GenInputWrapper.class);
    }
}