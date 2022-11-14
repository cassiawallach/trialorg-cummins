public class CG_GetPartsdatareqWrapper {

	public class Sender {
		public String MessageID;
		public String ServiceName;
		public String SenderID;
	}

	public class DataArea {
		public String PartNumberShort;
	}

	public Header Header;
	public DataArea DataArea;

	public class Header {
		public Sender Sender;
	}

	
	public static CG_GetPartsdatareqWrapper parse(String json) {
		return (CG_GetPartsdatareqWrapper) System.JSON.deserialize(json, CG_GetPartsdatareqWrapper.class);
	}
}