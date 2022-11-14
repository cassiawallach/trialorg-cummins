/*
* Block comments with details of changes
*/
public class CG_PaidClaimsDetailsResWrapper {

    public class DetailSRTs {
        public Double SRTHours;
        public Integer SRTQty;
        public Integer PercentageAdjustment;
        public String AdjustmentReason;
        public String AccessCode;
        public String SRTCode;
        public String PenaltyAppliedFlag; //added for the story 109395
    }

    public class DetailParts {
        public String AdjustmentPartsPercent;//191640
        public String PartQty;
        public String PartNumber;
        public String AdjustmentReason;
    }

    public class DataArea {
        public List<DetailSRTs> DetailSRTs;
        public List<DetailOtherClaimables> DetailOtherClaimables;
        public List<DetailParts> DetailParts;
        public List<DetailTravel> DetailTravel;
    }

    public class Header {
        public String MessageIdentifier;
        public String ReturnCode;
        public String ReturnCodeDescription;
        public String Status;
        public String DistributorCode; //added for the story 109395 by venkat
        public String DistributorName; //added for the story 109395
        public String AdjudicatorName; //added for the story 109395
    }

    public DataArea DataArea;
    public Header Header;

    public class DetailOtherClaimables {
        public String Item;
        public String Description;
        public String ApprovedAmount;
        public String AdjustmentReason;
    }

    public class DetailTravel {
        public String TravelType;
        public String AdjustmentReason;
        //Commented as part of the defect # 191640
        /* public Integer Distance;
        public Double Hours;
        public Integer LodgingAmount;
        public Integer MealsAmount;
        public Integer TowingDetails;
        public Integer TotalTravel;*/
        public String Distance; //Changed from Integer to String  as part of the defect # 191640
        public String Hours; //Changed from Double to String  as part of the defect # 191640
        public String LodgingAmount; //Changed from Integer to String  as part of the defect # 191640
        public String MealsAmount;  //Changed from Integer to String  as part of the defect # 191640
        public String TowingDetails; //Changed from Integer to String  as part of the defect # 191640
        public String TotalTravel; //Changed from Integer to String  as part of the defect # 191640*/
        public String BaseFare;
        public String TravelAdjustedPercentage;
        public String PenaltyAppliedFlag; //added for the story 109395
    }


    public static CG_PaidClaimsDetailsResWrapper parse(String json) {
        return (CG_PaidClaimsDetailsResWrapper) System.JSON.deserialize(json, CG_PaidClaimsDetailsResWrapper.class);
    }
}