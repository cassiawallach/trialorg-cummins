public class CG_WPR_SBL_SPCertification {

	public class DataArea {
		public List<CertificationInfo> CertificationInfo;
	}

	public Header Header;
	public DataArea DataArea;

	public class Header {
		public String Status;
		public String MessageIdentifier;
		public String ReturnCodeDescription;
        public String ReturnCode; //new field added
        public String MessageType; //new field added
	}

	public class CertificationInfo {
		public String SpCode;
		public String SpRowId;
		public String Smn;
		public String SpCertRowId;
		public String OemCode;
		public String OemName;
		public String StartDate;
		public String EndDate;
		public String ServiceLevel;
	}

	
	public static CG_WPR_SBL_SPCertification parse(String json) {
		return (CG_WPR_SBL_SPCertification) System.JSON.deserialize(json, CG_WPR_SBL_SPCertification.class);
	}
}