public class CSS_WPR_SBL_GetTechInfoReqJSON {

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
		public String LAST_PROCESSED_DATE;
		public List<String> SP_CODE;
	}

	public class Header {
		public Sender Sender;
		public Target Target;
	}

		
	public static CSS_WPR_SBL_GetTechInfoReqJSON parse(String json) {
		return (CSS_WPR_SBL_GetTechInfoReqJSON) System.JSON.deserialize(json, CSS_WPR_SBL_GetTechInfoReqJSON.class);
	}
}