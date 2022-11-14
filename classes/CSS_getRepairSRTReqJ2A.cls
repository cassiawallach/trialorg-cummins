global class CSS_getRepairSRTReqJ2A {

	public class Sender {
		public String ServiceName;
		public String SenderID;
	}

	public class Target {
		public String TargetID;
	}

	public class DataArea {
		public String Jobid;
		public String ClaimID;
		public String Languagecode;
		public String EngineFamilyCode;
		public String ServiceModelName;
		public String EquipmentID;
		public List<String> FailureID;
		public String DTTimestamp;
	}

	public class Header {
		public Sender Sender;
		public Target Target;
	}

	public Header Header;
	public DataArea DataArea;

	
	public static CSS_getRepairSRTReqJ2A parse(String json) {
		return (CSS_getRepairSRTReqJ2A) System.JSON.deserialize(json, CSS_getRepairSRTReqJ2A.class);
	}
}