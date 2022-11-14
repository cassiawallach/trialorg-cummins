public class FSL_DetailCoverageResWrapper {
   

	public class Details {
		public String DeductibleAmount;
		public String CampaignTravelPercentage;
		public String Status;
		public String CampaignPartsPercentage;
		public String Message;
		public String ComponentCode;
		public String SystemCode;
		public String CampaignLaborPercentage;
		public String CoveredTowingMiles;
		public String CoveredTravelMiles;
		public String WarrantyId;
		public String CoveredMealsLodgingAmt;
		public String CoveredLaborHrs;
		public String CampaignOCPercentage;
		public String CoveredTravelLabor;
		public String CampaignTowingPercentage;
		public String PayCode;
		public String AccountCodeType;
		public String CoveredPartsQty;
		public String CoveredTravelBaseFareAmt;
		public String AccountCode;
		public String CertificateNumber;
		public String CoveredOCAmount;
	}

	public class DataArea {
		public List<Details> Details;
		public String AccountCodeType;
		public String AccountCode;
        public DataArea()
        {
            Details = new List<Details>();
        }
	}

	public DataArea DataArea;
	public Header Header;

	public class Header {
		public String Status;
		public String ReturnCodeDescription;
	}

	
	public static FSL_DetailCoverageResWrapper parse(String json) {
		return (FSL_DetailCoverageResWrapper) System.JSON.deserialize(json, FSL_DetailCoverageResWrapper.class);
	}

    
    
   
}