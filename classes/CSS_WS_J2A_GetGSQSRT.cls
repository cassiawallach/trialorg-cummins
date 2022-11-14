public class CSS_WS_J2A_GetGSQSRT {

    public class DataArea {
        public List<CaseResponse> CaseResponse;
        public String ResponseMessage;
    }

    public DataArea DataArea;
    public Header Header;

    public class CaseResponse {
        public String AccessCodeD;
        public String AccessCodeC;
        public String SRTDetails;
        public String AccessCodeB;
        public String SRTAccessCode;
        public String AccessCodeA;
        public String S6Desc;
        public String Assignment;
        public String S9Desc;
        public String SRTDesc;
        public String SRTTime;
        public String S1Desc;
        public String S5Desc;
        public String S3Desc;
        public String S8Desc;
        public String SRTQuantity;
        public String AccessCodeS1;
        public String SRTTitle;
        public String S4Desc;
        public String FailureID;
        public VerifyRepeatValue VerifyRepeatValue;
        public String AccessCodeS8;
        public String AccessCodeS9;
        public String AccessCodeR;
        public String AccessCodeS6;
        public String S2Desc;
        public String AccessCodeS7;
        public String SRTMessage;
        public String AccessCodeS4;
        public String AccessCodeS5;
        public String AccessCodeS2;
        public String AccessCodeS3;
        public String FailureName;
        public String S7Desc;
    }

    public class Header {
        public String Status;
        public String ReturnCodeDescription;
    }

    public class Step {
        public String StepID;
        public String Percentage;
        public String SRTModifyDateTime;
        public List<String> StepDescription;
    }

    public class VerifyRepeatValue {
        public String SRTEventPerfDateTime;
        public String SRTType;
        public Step Step;
    }

    
    public static CSS_WS_J2A_GetGSQSRT parse(String json) {
        return (CSS_WS_J2A_GetGSQSRT) System.JSON.deserialize(json, CSS_WS_J2A_GetGSQSRT.class);
    }
}