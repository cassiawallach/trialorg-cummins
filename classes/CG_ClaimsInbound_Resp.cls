public class CG_ClaimsInbound_Resp {

	public class Sender {
		public String ServiceName;
		public String MessageID;
		public String SenderID;
	}

	public class Target {
		public String TargetID;
	}

	public class DataArea {
		public String BMSClaimNumber ;
	}

	public Header Header;
	public DataArea DataArea;

	public class Header {
		public String ReturnCodeDescription;
		public String Status;
		public Sender Sender;
		public Target Target;
		public Location Location;
	}

	public class Location {
		public String LocationID;
	}

	
	public static CG_ClaimsInbound_Resp parse(String json) {
		return (CG_ClaimsInbound_Resp) System.JSON.deserialize(json, CG_ClaimsInbound_Resp.class);
	}
}