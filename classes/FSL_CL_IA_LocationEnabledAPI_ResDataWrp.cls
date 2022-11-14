public class FSL_CL_IA_LocationEnabledAPI_ResDataWrp {
	public Header Header;
	public DataArea DataArea;

	public class DataArea {
		public String woEnabled;
	}

	public class Header {
		public String status;
		public String serviceVersion;
		public String serviceName;
		public String returnCodeDescription;
        public String toolId;
        public String senderId;      
	}
    public static FSL_CL_IA_LocationEnabledAPI_ResDataWrp parse(String json) {
		return (FSL_CL_IA_LocationEnabledAPI_ResDataWrp) System.JSON.deserialize(json, FSL_CL_IA_LocationEnabledAPI_ResDataWrp.class);
	}
}