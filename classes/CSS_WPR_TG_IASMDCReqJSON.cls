public class CSS_WPR_TG_IASMDCReqJSON {

    public Header Header;
	public List<DataArea> DataArea;

    public class Header {
		public String ServiceName;
		public String ServiceVersion;
		public String Target;
		public String SenderID;
		public String RunTime;
	}
    
    public class DataArea {
		public String Id;
		public String IASNumber;
		public String ServiceName;
		public String ServiceVersion;
		public String ToolID;
		public String SenderID;
		public String TargetID;
		public String PSN;
		public String SERVICEMODELNAME;
		public String ERT;
		public String MAKE;
		public String MODEL;
		public String ACCESS;
		public String UserLocation;
		public String CustomerName;
		public String ComplaintText;
		public String Algorithm;
		public String CSSEnabled;
		public String CSSJobNumber;
		public String Status;
		public String ReturnCodeDescription;
		public String Version;
        public String CreatedBy;
        public String UpdatedBy;
        public String CreatedDateTime;
        public String UpdatedDateTime;
		public Result Result;
	}

    public class Result {
		public List<UnPrioritizedData> unPrioritizedData;
		public List<PrioritizedData> prioritizedData;
	}
    
    public class PrioritizedData {
		public String rootCause4;
		public String rootCause3;
		public String rootCause2;
		public String rootCause1;
		public List<Relfc> relfc;
		public String rc4Likelihood;
		public String rc3Likelihood;
		public String rc2Likelihood;
		public String rc1Likelihood;
		public String prifc;
		public String lhrs;
	}
    
    public class UnPrioritizedData {
		public String upfc;
		public String rc;
	}
	

	public class Relfc {
        public String rfc;
	}

	

	
	public static CSS_WPR_TG_IASMDCReqJSON parse(String json) {
		return (CSS_WPR_TG_IASMDCReqJSON) System.JSON.deserialize(json, CSS_WPR_TG_IASMDCReqJSON.class);
	}
}