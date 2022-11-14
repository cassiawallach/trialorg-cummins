public class CG_WPR_SBL_SPTechnicianSMN{

	public class TechServiceModelInfo{
        public String ServiceModelName;
        public String SmnRowId;
		public String SpCode;
		public String SpRowId;
		public String CertPercentage;
		public String TechRowId;
	}
    public class DataArea{
        public list<TechServiceModelInfo> TechServiceModelInfo;
    }

	public class Header{
        public String Status;
        public String MessageIdentifier;
		public String ReturnCodeDescription;
		public String ReturnCode; //new field added
        public String MessageType; //new field added		
	}

	public DataArea DataArea;
	public Header Header;

	
	public static CG_WPR_SBL_SPTechnicianSMN parse(String json) {
		return (CG_WPR_SBL_SPTechnicianSMN) System.JSON.deserialize(json, CG_WPR_SBL_SPTechnicianSMN.class);
	}
}