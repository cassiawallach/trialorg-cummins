public class CSS_J2ADiagnostic_SRT {

	public class VerifyRepeatValue_Y {
		public String SRTType;
		public Step_Y Step;
		public String SRTEventPerfDateTime;
	}

	public class DataArea {
		public List<CaseResponse> CaseResponse;
		public String ResponseMessage;
	}

	public class CaseResponse {
		public String SRTTitle;
		public VerifyRepeatValue VerifyRepeatValue;
		public String SRTID;
		public String CaseNumber;
        public String Assignment;
        public String FlexSRT;
        public string SRTAccessCode;
        public String ECMFlag;//Added as part of story GSSC-125
	}

	public DataArea DataArea;
	public Header Header;

	public class Step {
		public Integer Percentage;
		public String SRTModifyDateTime;
		public List<String> StepDescription;
		public String SRTStatusMessage;
		public Integer StepID;
		public SRTTime SRTTime;
	}

	public class VerifyRepeatValue {
		public String SRTType;
		public Step Step;
		public String SRTEventPerfDateTime;
	}

	public class VerifyRepeatValue_Z {
		public String SRTType;
		public Step_Z Step;
		public String SRTEventPerfDateTime;
	}

	public class SRTTime_Z {
		public String SpecialAccessCode;
		public List<String> SpecialAccessCodeDescription;
		public Double AccessCodeB;
		public Double AccessCodeA;
		public Double AccessCodeD;
		public Integer AccessCodeR;
		public Integer AccessCodeC;
	}

	public class SRTTime_Y {
		public String SpecialAccessCode;
		public List<String> SpecialAccessCodeDescription;
		public Double AccessCodeB;
		public Double AccessCodeA;
		public Double AccessCodeD;
		public Double AccessCodeR;
		public Double AccessCodeC;
	}

	public class Step_Y {
		public Integer Percentage;
		public String SRTModifyDateTime;
		public List<String> StepDescription;
		public String SRTStatusMessage;
		public Integer StepID;
		public SRTTime_Y SRTTime;
	}

	public class Step_Z {
		public Integer Percentage;
		public String SRTModifyDateTime;
		public List<String> StepDescription;
		public String SRTStatusMessage;
		public Integer StepID;
		public SRTTime_Z SRTTime;
	}

	public class Header {
		public String ReturnCodeDescription;
		public String Status;
	}

	public class SRTTime {
		public String SpecialAccessCode;
		public List<String> SpecialAccessCodeDescription;
		public Double AccessCodeB;
		public Double AccessCodeA;
		public Double AccessCodeD;
		public Double AccessCodeR;
		public Double AccessCodeC;
	}

	
	public static CSS_J2ADiagnostic_SRT parse(String json) {
		return (CSS_J2ADiagnostic_SRT) System.JSON.deserialize(json, CSS_J2ADiagnostic_SRT.class);
	}
}