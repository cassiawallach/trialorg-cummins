public class CSS_getDetailCoverageReqJ2A{

    public class Sender {
        public String ServiceName;
        public String SenderID;
    }

    public class Target {
        public String TargetID;
    }

    public class DataArea {
        public String ESN;
        public String SPCode;
        public String FailureDate;
        public String FailurePoint;
        public String FailureMeasure;
        public String EngineApplicationCode;
        public String SystemCode;
        public String ComponentCode;
        public String FaultCode;
        public String WarrantyStartDate;
        public String CampaignNumber;
        public String NewPartsWrntyFlg;
        public String ReconPartsWrntyFlg;
        public String RoadRelayWrntyFlg;
        public String AccountCode;
    }

    public class Header {
        public Sender Sender;
        public Target Target;
    }

    public Header Header;
    public DataArea DataArea;

    
    public static CSS_getDetailCoverageReqJ2A parse(String json) {
        return (CSS_getDetailCoverageReqJ2A) System.JSON.deserialize(json, CSS_getDetailCoverageReqJ2A.class);
    }
}