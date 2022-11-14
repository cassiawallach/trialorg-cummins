public class CSS_WS_J2A_GetCSSDetails {

    public class DetailParts {
        public String PartNumber;
        public String PartQty;
        public String AdjustmentReason;
        public String AdjustmentPartsPercent;
    }

    public class DetailSRTs {
        public String SRTCode;
        public String SRTHours;
        public String SRTQty;
        public String AccessCode;
        public String PercentageAdjustment;
        public String AdjustmentReason;
    }

    public class DetailTravels {
        public String AdjustmentReason;
        public String TravelType;
    }

    public class DataArea {
        public List<DetailParts> DetailParts;
        public List<DetailSRTs> DetailSRTs;
        public List<DetailOtherClaimables> DetailOtherClaimables;
        public List<DetailTravels> DetailTravels;
    }

    public class Header {
        public String Status;
        public String ReturnCodeDescription;
    }

    public Header Header;
    public DataArea DataArea;

    public class DetailOtherClaimables {
        public String Description;
        public String ApprovedAmount;
        public String AdjustmentReason;
    }
    
    public static CSS_WS_J2A_GetCSSDetails parse(String json) {
        return (CSS_WS_J2A_GetCSSDetails) System.JSON.deserialize(json, CSS_WS_J2A_GetCSSDetails.class);
    }
}