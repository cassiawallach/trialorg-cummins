public class CSS_WPR_SRT_MakeModalEquipIdResJSON {

    public DataArea DataArea;
	public Header Header;
    
	public class DataArea {
		public List<EquipmentData> EquipmentData;
	}

	public class ServiceModelDetails {
		public String SMN;
		public String EF;
	}

	public class Header {
		public String ReturnCodeDescription;
		public String Status;
	}

	public class EquipmentData {
		public List<ServiceModelDetails> ServiceModelDetails;
		public String Status;
		public String ApplicationCategory;
		public String Model;
		public String EngineFamilyCode;
		public String Configuration;
		public String EquipmentId;
		public String AccessCode;
		public String Make;
	}
	
	public static CSS_WPR_SRT_MakeModalEquipIdResJSON parse(String json) {
		return (CSS_WPR_SRT_MakeModalEquipIdResJSON) System.JSON.deserialize(json, CSS_WPR_SRT_MakeModalEquipIdResJSON.class);
	}
}