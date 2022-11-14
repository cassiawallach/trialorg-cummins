public class CSS_J2ARepair_SRT {
    
    public DataArea DataArea;
	public Header Header;

	public class DataArea {
		public List<CaseResponse> CaseResponse;
		public String ResponseMessage;
	}

	public class CaseResponse {
		public String S2Desc;
		public String S1Desc;
		public String Assignment;
		public String S8Desc;
        public String ECMFlag;
        public String FlexSRT;
		public Decimal SRTTime;
		public String SRTAccessCode;
		public Decimal AccessCodeR;
		public String S9Desc;
		public String SRTTitle;
		public String S3Desc;
		public String S6Desc;
		public String SRTMessage;
		public String SRTDesc;
		public Decimal SRTQuantity;
		public String S7Desc;
		public String S4Desc;
		public Decimal AccessCodeS1;
		public Decimal AccessCodeS2;
		public Decimal AccessCodeS3;
		public Decimal AccessCodeS4;
		public Decimal AccessCodeS5;
		public String S5Desc;
		public VerifyRepeatValue VerifyRepeatValue;
		public Decimal AccessCodeS6;
		public Decimal AccessCodeS7;
		public Decimal AccessCodeS8;
		public String FailureID;
		public Decimal AccessCodeS9;
		public String FailureName;
		public String SRTDetails;
		public Decimal AccessCodeB;
		public Decimal AccessCodeA;
		public Decimal AccessCodeD;
		public Decimal AccessCodeC;
        public String CaseNumber; //this field is not available in the response structure
        public string SRTUsage;//Added as part of story GSSC-125
	}

	public class Header {
		public String ReturnCodeDescription;
		public String Status;
	}

	public class Step {
		public Integer Percentage;
		public String SRTModifyDateTime;
		public List<String> StepDescription;
		public Integer StepID;
	}

	public class VerifyRepeatValue {
		public String SRTType;
		public Step Step;
		public String SRTEventPerfDateTime;
	}

	
	public static CSS_J2ARepair_SRT parse(String json) {
		return (CSS_J2ARepair_SRT) System.JSON.deserialize(json, CSS_J2ARepair_SRT.class);
	}
    
    /* Old wrapeer code below
	public class DataArea {
		public List<CaseResponse> CaseResponse;
		public String ResponseMessage;
	}

	public class CaseResponse {
		public String SRTTitle;
		public Integer SRTQuantity;
		public VerifyRepeatValue VerifyRepeatValue;
        public String FailureID;
		public String Assignment;
        public String FailureName;
		public String SRTDetails;
		public String CaseNumber;
        //public Integer SRTID;
		public Double SRTTime;
		public String SRTAccessCode;
		public String SRTMessage;
	}

	public class Header {
		public String ReturnCodeDescription;
		public String Status;
	}

	public DataArea DataArea;
	public Header Header;

	public class Step {
		public Integer Percentage;
		public String SRTModifyDateTime;
		public List<String> StepDescription;
        public Integer StepID;
       // public String SRTStatusMessage;
		//public SRTTime SRTTime;
       //public String SRTEventPerfDateTime;
	}
		
	public class VerifyRepeatValue {
		public String SRTType;
		public Step Step;
		public String SRTEventPerfDateTime;
	}
	public static CSS_J2ARepair_SRT parse(String json) {
		return (CSS_J2ARepair_SRT) System.JSON.deserialize(json, CSS_J2ARepair_SRT.class);
	}
	*/
}