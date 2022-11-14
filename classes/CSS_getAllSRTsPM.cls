public class CSS_getAllSRTsPM {
   
	public class DataArea {
		public String SRTType;
		public String SRTNumber;
		public String SRTTitle;
		public Integer BTime;
		public Integer RTime;
		public String SRTCategory;
		public Integer StepID;
		public Integer ATime;
		public double CTime;
		public Integer DTime;
	}

	public class Header {
		public String ReturnCodeDescription;
		public String ReturnCode;
		public String MessageIdentifier;
	}

	public List<DataArea> DataArea;
	public Header Header;

	
	public static CSS_getAllSRTsPM parse(String json) {
		return (CSS_getAllSRTsPM) System.JSON.deserialize(json, CSS_getAllSRTsPM.class);
	}


}