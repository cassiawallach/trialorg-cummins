//
// Generated by JSON2Apex http://json2apex.herokuapp.com/
//

public class CG_OP_getApplicationCodesReqJSON {

	public class Sender {
		public String ServiceName;
		public String SenderID;
	}

	public class Target {
		public String TargetID;
	}

	public class DataArea {
		public String LAST_PROCESSED_DATE;
	}

	public Header Header;
	public DataArea DataArea;

	public class Header {
		public Target Target;
		public Sender Sender;
	}

	
	public static CG_OP_getApplicationCodesReqJSON parse(String json) {
		return (CG_OP_getApplicationCodesReqJSON) System.JSON.deserialize(json, CG_OP_getApplicationCodesReqJSON.class);
	}
}