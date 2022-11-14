public class CSS_WS_J2A_GetAccountCoverage {

    public class DataArea {
        public String AccountCode;
        public String AccountCodeType;
        public List<Details> Details;
    }

    public class Header {
        public String Status;
        public String ReturnCodeDescription;
    }

    public Header Header;
    public DataArea DataArea;

    public class Details {
        public String CoveredTravelBaseFareAmt;
        public String SystemCode;
        public String ComponentCode;
        public String AccountCode;
        public String AccountCodeType;
        public String PayCode;
        public String CertificateNumber;
        public String CoveredLaborHrs;
        public String CoveredMealsLodgingAmt;
        public String CoveredOCAmount;
        public String CoveredPartsQty;
        public String CoveredTowingMiles;
        public String CoveredTravelLabor;
        public String CoveredTravelMiles;
        public String DeductibleAmount;
        public String CampaignLaborPercentage;
        public String CampaignOCPercentage;
        public String CampaignPartsPercentage;
        public String CampaignTowingPercentage;
        public String CampaignTravelPercentage;
        public String Message;
        public String Status;
        public String WarrantyId;
    }
    
    public static CSS_WS_J2A_GetAccountCoverage parse(String json) {
        return (CSS_WS_J2A_GetAccountCoverage) System.JSON.deserialize(json, CSS_WS_J2A_GetAccountCoverage.class);
    }
}