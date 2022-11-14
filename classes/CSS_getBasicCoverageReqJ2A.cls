public class CSS_getBasicCoverageReqJ2A{

    public class Sender {
        public String ServiceName;
        public String SenderID;
    }

    public class Target {
        public String TargetID;
    }

    public class DataArea {
        public String ESN;
        public String EngineApplicationCode;
        public String Region;
        public String Territory;
        public String WarrantyStartDate;
        public String PartsWarranty;
        public string JobId;
        public string FailurePoint;     //#85179
        public string FailureUnit;      //#85179
        public string ReconFlag;       //added as per the story 156820
        public String FailureDate;     //CT3-498, Dinesh Yadav 
    }

    public class Header {
        public Sender Sender;
        public Target Target;
    }

    public Header Header;
    public DataArea DataArea;

    
    public static CSS_getBasicCoverageReqJ2A parse(String json) {
        return (CSS_getBasicCoverageReqJ2A) System.JSON.deserialize(json, CSS_getBasicCoverageReqJ2A.class);
    }
}