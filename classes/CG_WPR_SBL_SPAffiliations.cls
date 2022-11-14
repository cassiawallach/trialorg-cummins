public class CG_WPR_SBL_SPAffiliations {

    public Header Header;
	public DataArea DataArea;
    
    public class DataArea {
		public List<AffiliationInfo> AffiliationInfo;
	}

	public class Header {
		public String Status;
		public String MessageIdentifier;
		public String ReturnCodeDescription;
        public String ReturnCode; //new field added
        public String MessageType; //new field added
	}

	public class AffiliationInfo {
		public String Affiliation;
		public String Primary;
		public String LastUpdatedBy;
		public String LastUpdatedDate;
		public String AffiliationRowId;
		public String SpCode;
		public String SpRowId;
	}

	
	public static CG_WPR_SBL_SPAffiliations parse(String json) {
		return (CG_WPR_SBL_SPAffiliations) System.JSON.deserialize(json, CG_WPR_SBL_SPAffiliations.class);
	}
    
    
}