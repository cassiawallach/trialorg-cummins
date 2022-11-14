public class CG_IP_CustCreditMsgReqJSON {

    public Header Header;
	public DataArea DataArea;
    
	public class Sender {
		public String ServiceName;
		public String SenderID;
	}

	public class Target {
		public String TargetID;
	}

	public class DataArea {
		public String CustomerNumber;
	}

	public class Header {
		public Sender Sender;
		public Target Target;
		public Location Location;
	}

    public class Location {
		public String LocationID;
	}

	
	public static CG_IP_CustCreditMsgReqJSON parse(String json) {
		return (CG_IP_CustCreditMsgReqJSON) System.JSON.deserialize(json, CG_IP_CustCreditMsgReqJSON.class);
	}
}