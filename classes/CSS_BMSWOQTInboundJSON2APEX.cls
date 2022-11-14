public class CSS_BMSWOQTInboundJSON2APEX {

    public class DataArea {
        public String WOReferenceNumber;
        public String ContactID;
        public String CSSJobID;//Added for FSL Changes 3/4 by Anirudh.
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
    
    public static CSS_BMSWOQTInboundJSON2APEX parse(String json) {
        return (CSS_BMSWOQTInboundJSON2APEX) System.JSON.deserialize(json, CSS_BMSWOQTInboundJSON2APEX.class);
    }
}