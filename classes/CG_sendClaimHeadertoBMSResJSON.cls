public class CG_sendClaimHeadertoBMSResJSON {

	public class Sender {
		public String ServiceName;
		public String MessageID;
		public String SenderID;
	}

	public class Target {
		public String TargetID;
	}

	public Header Header;

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

	
	public static CG_sendClaimHeadertoBMSResJSON parse(String json) {
		return (CG_sendClaimHeadertoBMSResJSON) System.JSON.deserialize(json, CG_sendClaimHeadertoBMSResJSON.class);
	}
}