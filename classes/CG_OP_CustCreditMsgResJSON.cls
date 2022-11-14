public class CG_OP_CustCreditMsgResJSON {

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
		public List<CreditMessageDetails> CreditMessageDetails;
	}

	public class Header {
        public String ReturnCodeDescription; 
		public String Status;
		public Sender Sender;
		public Target Target;
		public Location Location;
	}

	public class CreditMessageDetails {
		public String CreditMessageCode;
		public String CreditMessage;
	}

	public class Location {
		public String LocationID;
	}

	
	public static CG_OP_CustCreditMsgResJSON parse(String json) {
		return (CG_OP_CustCreditMsgResJSON) System.JSON.deserialize(json, CG_OP_CustCreditMsgResJSON.class);
	}
}