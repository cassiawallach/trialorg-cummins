public class FSLDiagSRTREPWrappers {
    public DataArea DataArea;
    public Header Header;
    class Header {
        public String Status;   //Success
        public String ReturnCodeDescription;    //
    }
    Public class DataArea {
        public CaseResponse[] CaseResponse;
        public String ResponseMessage;  //
    }
    public class CaseResponse {
        public String AccessCodeD; //0
        public String AccessCodeC;  //0.8
        public String SRTDetails;   //11-803-00
        public String AccessCodeB; //0
        public String SRTAccessCode;    //C
        public String AccessCodeA; //0
        public String S6Desc;   //
        public String Assignment;   //PRIMARY
        public String S9Desc;   //
        public String SRTDesc;  //Includes:
        public Decimal SRTTime;  //0.8
        public String S1Desc;   //
        public String S5Desc;   //
        public String S3Desc;   //
        public String S8Desc;   //
        public Integer SRTQuantity; //1
        public String AccessCodeS1;    //0
        public String SRTTitle; //Aftertreatment SCR Catalyst - Remove and Install
        public String S4Desc;   //
        public String FailureID;    //F11000200
        public VerifyRepeatValue VerifyRepeatValue;
        public String AccessCodeS8;    //0
        public String AccessCodeS9;    //0
        public String AccessCodeR; //0
        public String AccessCodeS6;    //0
        public String S2Desc;   //
        public String AccessCodeS7;    //0
        public String SRTMessage;   //
        public String AccessCodeS4;    //0
        public String AccessCodeS5;    //0
        public String AccessCodeS2;    //0
        public String AccessCodeS3;    //0
        public String FailureName;  //Aftertreatment SCR Catalyst
        public String S7Desc;   //
    }
    Public class VerifyRepeatValue {
        public String SRTEventPerfDateTime; //
        public String SRTType;  //
        public Step Step;
    }
    Public class Step {
        public string StepID;  //106381
        public String Percentage;  //0
        public String SRTModifyDateTime;    //
        public List<String> StepDescription;
    }
}