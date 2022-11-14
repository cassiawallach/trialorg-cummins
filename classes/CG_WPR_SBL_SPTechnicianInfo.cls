public class CG_WPR_SBL_SPTechnicianInfo {

	public class TechnicianInfo {
		public String SpCode;
		public String SpRowId;
		public String FstName;
		public String LastName;
		public String PromotionId;
		public String TechRowId;
	}
    public class DataArea{
        public list<TechnicianInfo> TechnicianInfo;
    }

	public DataArea DataArea;
	public Header Header;

	public class Header {
		public String ReturnCodeDescription;
		public String Status;
		public String MessageIdentifier;
        public String ReturnCode; //new field added
        public String MessageType; //new field added
	}

	
	public static CG_WPR_SBL_SPTechnicianInfo parse(String json) {
		return (CG_WPR_SBL_SPTechnicianInfo) System.JSON.deserialize(json, CG_WPR_SBL_SPTechnicianInfo.class);
	}
}