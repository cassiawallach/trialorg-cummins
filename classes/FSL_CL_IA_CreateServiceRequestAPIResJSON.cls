public class FSL_CL_IA_CreateServiceRequestAPIResJSON {
    
    public Header Header;
    public DataArea DataArea;
    public class Header {
        public String status;
		public String serviceVersion;
		public String serviceName;
		public String returnCodeDescription;
        public String toolId;
        public String senderId;
     }
    
    public class DataArea {
        public String iasNumber;
        public String woNumber;
    }
    public static FSL_CL_IA_CreateServiceRequestAPIResJSON parse(String json) {
        return (FSL_CL_IA_CreateServiceRequestAPIResJSON) System.JSON.deserialize(json, FSL_CL_IA_CreateServiceRequestAPIResJSON.class);
    } 

}