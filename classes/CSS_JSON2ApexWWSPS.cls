public class CSS_JSON2ApexWWSPS {
	public class DataArea {
		public List<ProductCertifications> ProductCertifications;
	}

	public class Header {
		public String ReturnCodeDescription;
		public String Status;
		public Integer ReturnCode;
		public String MessageIdentifier;
	}

	public DataArea DataArea;
	public Header Header;

	public class ProductDetails {
		public String ServiceModel;
		public String ProductCertificationStatus;
		public TechIDs TechIDs;
		public String MarketingModel;
	}

	public class ProductCertifications {
		public Integer DistributorCode;
        public String CerificationFlag;
		public String CerificationDate;
		public String ProfileStatus;
		public String CertificationExpiryDate;
		public String DistributorFlag;
		public List<ProductDetails> ProductDetails;
	}

	public class TechIDs {
        public List<String> TechID;
	}

	public class TechIDs_Z {
		public String TechID;
	}


	public static CSS_JSON2ApexWWSPS parse(String json) {
		return (CSS_JSON2ApexWWSPS) System.JSON.deserialize(json, CSS_JSON2ApexWWSPS.class);
	}

}