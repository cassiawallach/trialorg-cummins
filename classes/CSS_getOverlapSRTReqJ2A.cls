global class CSS_getOverlapSRTReqJ2A {
        public class Sender {
        public String ServiceName;
        public String SenderID;
    }

    public class Steps {
        public Integer StepId;
        public Integer Qty;
        public String AccessCode;
    }

    public class Target {
        public String TargetID;
    }

    public class DataArea {
        public String JobID; // Sai 6/01 : Changed the jobid to jobID
        public String ClaimID;
        public String Languagecode;
        public String DTTimestamp;
        public String EffectiveDTTime;
        public List<Steps> Steps;
    }

    public class Header {
        public Sender Sender;
        public Target Target;
    }

    public Header Header;
    public DataArea DataArea;

    
    public static CSS_getOverlapSRTReqJ2A parse(String json) {
        return (CSS_getOverlapSRTReqJ2A) System.JSON.deserialize(json, CSS_getOverlapSRTReqJ2A.class);
    }
}