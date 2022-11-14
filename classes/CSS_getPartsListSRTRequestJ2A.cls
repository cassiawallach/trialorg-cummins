global class CSS_getPartsListSRTRequestJ2A {

    public class Sender {
        public String ServiceName;
        public String SenderID;
    }

    public class Target {
        public String TargetID;
    }

    public class DataArea {
        public String JobID; // Sai:6/01 changed the jobId to jobID
        public String ClaimID;
        public String Languagecode;
        public String EngineFamilyCode;
        public String ServiceModelName;
        public String EquipmentID;
        public String DTTimestamp;
        public String EffectiveDTTime;
        public List<String> FailureID;
        public List<String> OptionNumber;
    }

    public class Header {
        public Sender Sender;
        public Target Target;
    }

    public Header Header;
    public DataArea DataArea;

    
    public static CSS_getPartsListSRTRequestJ2A parse(String json) {
        return (CSS_getPartsListSRTRequestJ2A) System.JSON.deserialize(json, CSS_getPartsListSRTRequestJ2A.class);
    }
}