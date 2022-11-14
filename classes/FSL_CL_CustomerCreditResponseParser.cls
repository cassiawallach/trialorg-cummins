public class FSL_CL_CustomerCreditResponseParser{
public class Sender {
		public String ServiceName;
		public String SenderID;
		public String MessageID;
	}

	public class Target {
		public String TargetID;
	}

	public class DataArea {
		public String CustomerNumber;
		public List<CreditMessageDetails> CreditMessageDetails;
	}

	public DataArea DataArea;
	public Header Header;

	public class Header {
		public Sender Sender;
		public String Status;
		public Target Target;
		public String ReturnCodeDescription;
		public Location Location;
	}

	public class CreditMessageDetails {
		public String CreditMessage;
		public String CreditMessageCode;
	}

	public class Location {
		public String LocationID;
	}

	
	public static FSL_CL_CustomerCreditResponseParser parse(String json) {
		return (FSL_CL_CustomerCreditResponseParser) System.JSON.deserialize(json, FSL_CL_CustomerCreditResponseParser.class);
	}
}