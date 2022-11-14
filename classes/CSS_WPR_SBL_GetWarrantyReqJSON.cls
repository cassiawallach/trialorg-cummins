public class CSS_WPR_SBL_GetWarrantyReqJSON {

    public Header Header;
    public DataArea DataArea;
    
    public class Sender {
        public String MessageID;
        public String ServiceName;
        public String SenderID;
    }

    public class Details {
        public String SystemCode;
        public String ComponentCode;
    }

    public class DataArea {
        public String Esn;
        public String SPCode;
        public String FailureDate;
        public String FailurePoint;
        public String FailureMeasure;
        public String EngineApplicationCode;
        public String FaultCode;
        public String WarrantyStartDate;
        public String CampaignNumber;
        public String NewPartsWrntyFlg;
        public String ReconPartsWrntyFlg;
        public String RoadRelayWrntyFlg;
        public String AccountCode;
        public List<Details> Details;
    }

    public class Header {
        public Sender Sender;
    }
    
    public static CSS_WPR_SBL_GetWarrantyReqJSON parse(String json) {
        return (CSS_WPR_SBL_GetWarrantyReqJSON) System.JSON.deserialize(json, CSS_WPR_SBL_GetWarrantyReqJSON.class);
    }
}