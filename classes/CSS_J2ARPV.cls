public class CSS_J2ARPV {

	public class DataArea {
		public String NotificationMessage;
		public String RepeatVisitFlag;
		public String NotificationFlag;
		public string ErrorCode;
        
	}

	public class Header {
		public String Status;
        public String ReturnCodeDescription;
		public String ReturnCode;
		public String MessageIdentifier;
		public String MessageType;
	}

	public DataArea DataArea;
	public Header Header;

	
	public static CSS_J2ARPV parse(String json) {
		return (CSS_J2ARPV) System.JSON.deserialize(json, CSS_J2ARPV.class);
	}
}