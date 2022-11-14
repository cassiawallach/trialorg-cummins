global class CSS_getOverlapSRTResponseJ2A {
    
public class TotalOverlapHours {
        public String SRTNumber;
        public Double OverlapHrs;
    }

    public class Steps {
        public Integer StepId;
        public String AccessCode;
        public Integer Qty;
        public Double SRTHours;
        public Double SRTAdjustedHours;
        public List<TotalOverlapHours> TotalOverlapHours;
    }

    public class DataArea {
        public Double TotalOverlapHours;
        public Double TotalAdjustedHours;
        public List<Steps> Steps;
    }

    public class Header {
        public String MessageIdentifier;
        public String ReturnCode;
        public String ReturnCodeDescription;
        public String Status;
        public String MessageType;
    }

    public Header Header;
    public DataArea DataArea;

    
    public static CSS_getOverlapSRTResponseJ2A parse(String json) {
        return (CSS_getOverlapSRTResponseJ2A) System.JSON.deserialize(json, CSS_getOverlapSRTResponseJ2A.class);
    }

}