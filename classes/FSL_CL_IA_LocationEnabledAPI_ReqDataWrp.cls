public class FSL_CL_IA_LocationEnabledAPI_ReqDataWrp {
	public Header Header;
    public DataArea DataArea;

    public class DataArea {
        public String userLocation;
        public String userName;
    }

    public class Header {
        public String serviceName;
        public String serviceVersion;
        public String toolID;
        public String targetID;
        public String senderId;   
    }
    public static FSL_CL_IA_LocationEnabledAPI_ReqDataWrp parse(String json) {
        return (FSL_CL_IA_LocationEnabledAPI_ReqDataWrp) System.JSON.deserialize(json, FSL_CL_IA_LocationEnabledAPI_ReqDataWrp.class);
    } 
}