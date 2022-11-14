public class FSL_BMSWOQTInboundJSON2APEX {

    public class DataArea {
        public String WOReferenceNumber;
        public String ContactID;
        //Added by Bharat 03/25
        public String CSSJobID;
    }

    public class Header {
        public String Status;
        public String ReturnCodeDescription;
        public Location Location;
        public Sender Sender;
		public Target Target;
    }

    public Header Header;
    public DataArea DataArea;

    public class Location {
        public String LocationID;
    }
	
	public class Sender{
		public string ServiceName;
		public string MessageID;
		public string SenderID;
	}

	public class Target{
		public string TargetID;
		}
    
    public static FSL_BMSWOQTInboundJSON2APEX parse(String json) {
        return (FSL_BMSWOQTInboundJSON2APEX) System.JSON.deserialize(json, FSL_BMSWOQTInboundJSON2APEX.class);
    }
}