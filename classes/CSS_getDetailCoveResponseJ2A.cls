public class CSS_getDetailCoveResponseJ2A {

    public class DataArea {
        public String SystemCode;
        public String ComponentCode;
        public String AccountCode;
        public String AccountCodeType;
        public String PayCode;
        public String CertificateNumber;
        public Integer CoveredLaborHrs;
        public Integer CoveredMealsLodgingAmt;
        public Integer CoveredOCAmount;
        public Integer CoveredPartsQty;
        public Integer CoveredTowingMiles;
        public Integer CoveredTravelLabor;
        public Integer CoveredTravelMiles;
        public Integer DeductibleAmount;
        public Integer CampaignLaborPercentage;
        public Integer CampaignOCPercentage;
        public Integer CampaignPartsPercentage;
        public Integer CampaignTowingPercentage;
        public Integer CampaignTravelPercentage;
        public String Message;
        public String Status;
        public String WarrantyId;
    }

    public class Header {
        public String MessageIdentifier;
        public String ReturnCode;
        public String ReturnCodeDescription;
        public String Status;
    }

    public Header Header;
    public DataArea DataArea;

    
    public static CSS_getDetailCoveResponseJ2A parse(String json) {
        return (CSS_getDetailCoveResponseJ2A) System.JSON.deserialize(json, CSS_getDetailCoveResponseJ2A.class);
    }
}