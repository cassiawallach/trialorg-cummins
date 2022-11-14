public class FSL_getEPRFlagResWrapper {
    public class DataArea {
        public String Location;
        public String Message;
        public String Attention;
        public String ReturnMessage;
        public String EPRFlag;
        public String PartNumber;
        public String Company;
    }
    
    public List<DataArea> DataArea;
    public Header Header;
    
    public class Header {
        public String Status;
        public String ReturnCodeDescription;
    }
    
    public static FSL_getEPRFlagResWrapper parse(String json) {
		return (FSL_getEPRFlagResWrapper) System.JSON.deserialize(json, FSL_getEPRFlagResWrapper.class);
	}
}