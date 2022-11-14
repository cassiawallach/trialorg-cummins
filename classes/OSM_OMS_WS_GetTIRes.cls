public class OSM_OMS_WS_GetTIRes {
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
    public static OSM_OMS_WS_GetTIRes parse(String json) {
        return (OSM_OMS_WS_GetTIRes) System.JSON.deserialize(json, OSM_OMS_WS_GetTIRes.class);
    }
}