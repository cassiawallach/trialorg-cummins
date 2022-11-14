public class CSS_WPR_SBL_GetWarrantyResJSON {
    
    public DataArea DataArea;
    public Header Header;
    
    public class Details {
        public String CoveredTravelBaseFareAmt;
        public String CoveredOCAmount;
        public String CoveredLaborHrs;
        public String CoveredTowingMiles;
        public String Message;
        public String CampaignLaborPercentage;
        public String CoveredTravelLabor;
        public String CertificateNumber;
        public String CampaignTowingPercentage;
        public String SystemCode;
        public String AccountCodeType;
        public String CoveredPartsQty;
        public String Status;
        public String CampaignOCPercentage;
        public String DeductibleAmount;
        public String ComponentCode;
        public String PayCode;
        public String AccountCode;
        public String CampaignPartsPercentage;
        public String CoveredMealsLodgingAmt;
        public String WarrantyId;
        public String CoveredTravelMiles;
        public String CampaignTravelPercentage;
    }

    public class DataArea {
        public List<Details> Details;
        public String AccountCode;
        public String AccountCodeType;
    }

    public class Header {
        public String ReturnCodeDescription;
        public String Status;
    }

    public static CSS_WPR_SBL_GetWarrantyResJSON parse(String json) {
        return (CSS_WPR_SBL_GetWarrantyResJSON) System.JSON.deserialize(json, CSS_WPR_SBL_GetWarrantyResJSON.class);
    }
}