global class CSS_getRepairSRTRespJ2A {

	public class DataArea {
		public String FailureID;
		public String FailureName;
		public String SRTDetail;
		public String SRTTitle;
		public String SRTDesc;
		public String AccessCode;
		public Double SRTTime;
		public Integer Quantity;
		public String Assignment;
		public String SRTMessage;
	}

	public class Header {
		public String MessageIdentifier;
		public String ReturnCode;
		public String ReturnCodeDescription;
		public String Status;
		public String MessageType;
	}

	public Header Header;
	public List<DataArea> DataArea;

	
	public static CSS_getRepairSRTRespJ2A parse(String json) {
		return (CSS_getRepairSRTRespJ2A) System.JSON.deserialize(json, CSS_getRepairSRTRespJ2A.class);
	}
}