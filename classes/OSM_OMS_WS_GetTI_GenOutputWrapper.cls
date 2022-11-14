public class OSM_OMS_WS_GetTI_GenOutputWrapper{
    public String errorMsg;
    public Boolean errorFlag;
    public OSM_Integration_Log__c log;
    public class Sender {
        public String ServiceName;
        public String SenderID;
    }

    public class Target {
        public String TargetID;
    }

    public class ToolInstListInfo {
        public List<ToolInstList> ToolInstList;
    }

    public Header Header;
    public GetTIFromLicenseKeyOutput GetTIFromLicenseKeyOutput;

    public class Header {
        public String ReturnCodeDescription;
        public String Status;
        public Sender Sender;
        public Target Target;
    }

    public class GetTIFromLicenseKeyOutput {
        public ToolInstListInfo ToolInstListInfo;
    }

    public class ToolInstList {
        public String ToolInstance;
        public String InstanceID;
    }   
    
    public static OSM_OMS_WS_GetTI_GenOutputWrapper parse(String json) {
        return (OSM_OMS_WS_GetTI_GenOutputWrapper) System.JSON.deserialize(json, OSM_OMS_WS_GetTI_GenOutputWrapper.class);
    }
}