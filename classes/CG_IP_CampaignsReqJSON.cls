public class CG_IP_CampaignsReqJSON {

    public Header Header;
	public DataArea DataArea;
    
	public class Sender {
		public String MessageID;
		public String ServiceName;
		public String SenderID;
	}

    public class DataArea {
		public String Esn;
		public String FailureDate;
        public String Region;
		public String Territory;
	}

	public class Header {
		public Sender Sender;
		public String Target;
	}

	
	public static CG_IP_CampaignsReqJSON parse(String json) {
		return (CG_IP_CampaignsReqJSON) System.JSON.deserialize(json, CG_IP_CampaignsReqJSON.class);
	}
}