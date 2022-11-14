public class CSS_WPR_SRT_MakeModalEquipIdReqJSON {

    public Header Header;
	public DataArea DataArea;
    
	public class Sender {
		public String MessageID;
		public String SenderID;
		public String ServiceName;
	}

	public class Target {
		public String TargetID;
	}

	public class DataArea {
		public String LastRunDate;
		public String LangCode;
	}

	public class Header {
		public Sender Sender;
		public Target Target;
	}


	public static CSS_WPR_SRT_MakeModalEquipIdReqJSON parse(String json) {
		return (CSS_WPR_SRT_MakeModalEquipIdReqJSON) System.JSON.deserialize(json, CSS_WPR_SRT_MakeModalEquipIdReqJSON.class);
	}
}