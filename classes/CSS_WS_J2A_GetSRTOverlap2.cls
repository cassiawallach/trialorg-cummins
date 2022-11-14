public class CSS_WS_J2A_GetSRTOverlap2 {
    Public Header Header;
    Public DataArea DataArea;

    public class Steps {
        public String Qty;
        public List<OverlapTime> OverlapTime;
        public String SRTHours;
        public String SRTAdjustedHours;
        public String StepId;
        public String AccessCode;
    }

    public class DataArea {
        public String TotalOverlapHours;
        public List<Steps> Steps;
        public String TotalAdjustedHours;
    }

    public class Header {
        public String ReturnCodeDescription;
        public String ReturnCode;
        public String Status;
        public String MessageIdentifier;
    }

    public class OverlapTime {
        public String SRTNumber;
        public String OverlapHrs;
    }
   
    public static CSS_WS_J2A_GetSRTOverlap2 parse(String json) {
        return (CSS_WS_J2A_GetSRTOverlap2) System.JSON.deserialize(json, CSS_WS_J2A_GetSRTOverlap2.class);
    }
}