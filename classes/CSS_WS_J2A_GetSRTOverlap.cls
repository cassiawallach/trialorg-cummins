public class CSS_WS_J2A_GetSRTOverlap {

    public class DataArea {
        public List<Details> Details;
    }

    public class Header {
        public String Status;
        public String ReturnCodeDescription;
    }

    public Header Header;
    public DataArea DataArea;

    public class Details {
        public String EngineFamilyCode;
        public String SrtAccessCode;
        public String SrtCode;
        public String OverlapHours;
        public String Name;
        public String SrtQty;
        public String Claim;
        public String FailureLine;
    }

    
    public static CSS_WS_J2A_GetSRTOverlap parse(String json) {
        return (CSS_WS_J2A_GetSRTOverlap) System.JSON.deserialize(json, CSS_WS_J2A_GetSRTOverlap.class);
    }
}