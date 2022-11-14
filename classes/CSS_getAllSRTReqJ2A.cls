public class CSS_getAllSRTReqJ2A {

    public class Sender {
        public String ServiceName;
        public String SenderID;
    }

    public class Target {
        public String TargetID;
    }

    public class DataArea {
        public String Jobid;
        public String ClaimID;
        public String Languagecode;
        public String EngineFamilyCode;
        public String ServiceModelName;
        public String EquipmentID;
        public String SRTType;
        public String SRTCategory;
        public String DTTimestamp;
        public String EffectiveDTTime;
    }

    public class Header {
        public Sender Sender;
        public Target Target;
    }

    public Header Header;
    public DataArea DataArea;

    
    public static CSS_getAllSRTReqJ2A parse(String json) {
        return (CSS_getAllSRTReqJ2A) System.JSON.deserialize(json, CSS_getAllSRTReqJ2A.class);
    }
}