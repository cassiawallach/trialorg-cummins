public class CSS_GetClaimDetailsResponse {

    public class OtherClaimablesList {
        public String Item;
        public String ItemDescription;
        //public Integer ClaimedAmount;
        public String ClaimedAmount;
        //public Integer AdjustedAmount;
        public String AdjustedAmount;//Changed from Integer to String  as part of the defect # 191640
        public String AdjustmentReason;
    }

    public class DataArea {
        public String ServiceProviderCode;
        public String DistributorCode;
        public String DistributorName;
        public String PSN;
        public String WorkOrderNumber;
        //public Date WarrantyStartDate;
        public String WarrantyStartDate;
        public String EngineApplicationCode;
        public String EngineApplicationDescription;//Added as per Colosseum Sprint -- Rajasekhar H GSSC-66
        public String Equipment;//Added as per Colosseum Sprint -- Rajasekhar H GSSC-66
		public String ServiceModel;//Added as per Colosseum Sprint -- Rajasekhar H GSSC-66
		public String Manufacturer;
        public String ModelSeries;
        public String Contact;
        public String BISFlag;
        //public Date FailureDate;
        public String FailureDate;
        public Integer FailurePoint;
        public String FailureMeasure;
        public String DISDNumber;
        public String CustomerName;
        public String EngineVIN;
        public String TSRNumber;
        public String UnitNumber;
        public String DealerClaimNumber;
        public String ClaimSource;
        //public Date ClaimFiledDate;
        public String ClaimFiledDate;
        public String ECMCalibAfter;
        public String ECMCalibBefore;
        public String ECMRevBfr;
        public String ECMRevAfter;
        public List<FailureList> FailureList;
        public List<AdditionalESNs> AdditionalESNs;
        public List<Notes> Notes;
        public List<ComplaintCodes> ComplaintCodes;
    }

    public class Header {
        public String ReturnCodeDescription;
        public String Status;
        public String ReturnCode;
        public String MessageIdentifier;
    }

    public class SRTList {
        public String SRTCode;
        public String SRTDescription;
        //public Integer SRTHours;
        public Double SRTHours;
        public Integer ClaimedQty;
        public Integer ClaimedPercent;
        public Decimal ClaimedHours; //public Integer ClaimedHours; changed as per the webservice
        public Integer AdjustedQty;
        public Integer AdjustedPercent;
        public Decimal AdjustedHours; // public Integer AdjustedHours; changed as per the webservice response
        public String AdjustmentReason;
        public String PenaltyAppliedFlag;
    }

    public Header Header;
    public List<DataArea> DataArea;

    public class FailureList {
        public String SystemCode;
        public String ComponentCode;
        public String FailMode;
        public String Failurename;
        public String CampaignNumber;
        public String FaultCode;
        public String AccountCode;
        public String PayCode;
        public String IMSClaimNumber; //Added as per Colosseum Sprint -- Rajasekhar H GSSC-66 IMSClaim
        public String CreditDate;  //Added as per Colosseum Sprint -- Rajasekhar H GSSC-66    Date***
		public List<PartsList> PartsList;
        public List<OtherClaimablesList> OtherClaimablesList;
        public List<SRTList> SRTList;
        public List<TravelList> TravelList;
    }

    public class PartsList {
        public String PartNumber;
        public String PartDescription;
        public String ClaimedQty;
        public String AdjustedQty;
        public String TrackingNumber;
        public String RID;
        public String AdjustmentReason;
        public String PartsPercentage; //Added as per Colosseum Sprint -- Rajasekhar H GSSC-66
        public String AdjustedPercentage; //Added as per Colosseum Sprint - Rajasekhar H GSSC-66  AdjustedPartsPercentage
   }

    public class TravelList {
        public String TravelType;
        public String ClaimedDistance; 
        public String ClaimedHours; // public Integer ClaimedHours;  Changed as per the response from webservice
        public String ClaimedAmount;
        public String AdjustedDistance;
        public String AdjustedHours;
        //public Integer AdjustedAmount;
        public String AdjustedAmount;
        public String LodgingAmount; // public Integer LodgingAmount // Changed as per the response from webservice
        public String MealsAmount;
        public String TowingAmount;
        public String LaborAmount;
        public String TravelAmount;
        //public Integer TotalTravel;
        public String TotalTravel;
        //public Integer BaseFare;
        public String BaseFare;
        public integer AdjustedBaseFare; //Added as per Colosseum Sprint -- Rajasekhar H GSSC-66 AdjBaseFare    String
        public integer AdjustedMeals; //Added as per Colosseum Sprint -- Rajasekhar H GSSC-66 AdjMeals  String
		public integer AdjustedTowing; //Added as per Colosseum Sprint -- Rajasekhar H GSSC-66 AdjTowing    String
        public integer AdjustedLodging; //Added as per Colosseum Sprint -- Rajasekhar H GSSC-66 AdjLodging  String
        public String AdjustmentReason;
        public String PenaltyAppliedFlag;
        public String AdjustedPercent;
    }

    public class AdditionalESNs {
        public String PSN;
        public  String WarrantyStartDate;      //Date
        public String BISFlag;
        public Integer FailurePoint;
        public String FailureMeasure;
        public String VIN;
        public String ECMCalibAfter;
        public String ECMCalibBefore;
        public String ECMRevBfr;
        public String ECMRevAfter;
    }

    public class ComplaintCodes {
        public String ComplaintCode;
        public String ComplaintText;
    }

    public class Notes {
        public String Note;
        public String NoteType;
        //public Date CreatedDate;
        public String CreatedDate;
    }
    
    //Added as per Colosseum Sprint -- Rajasekhar H GSSC-66
    /*public class CreditDate {
        public String Creditdate;  //Date
     }*/


    public static CSS_GetClaimDetailsResponse parse(String json) {
        return (CSS_GetClaimDetailsResponse) System.JSON.deserialize(json, CSS_GetClaimDetailsResponse.class);
    }
}