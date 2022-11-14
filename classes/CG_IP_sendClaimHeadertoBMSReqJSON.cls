public class CG_IP_sendClaimHeadertoBMSReqJSON {

	public class Sender {
		public String ServiceName;
		public String SenderID;
	}

	public class Target {
		public String TargetID;
	}

	public class DataArea {
		public String CSSJobID;
		public String DistributorCode;
		public String BranchCode;
		public String CustomerCode;
		public String OrderType;
		public String BMSReferenceNumber;
		public List<ClaimDetails> ClaimDetails;
	}

	public Header Header;
	public DataArea DataArea;

	public class Header {
		public Target Target;
		public Sender Sender;
		public Location Location;
	}

	public class ClaimDetails {
		public String ClaimType;
		public String AccountCode;
		public String PayCode;
		public String ESN;
		public String Certificate;
		public String AuthorizationNumber;
		public String FailureDate;
		public String WarrantyStarDate;
		public String MissionDisabling;
		public String SMN;
		public String Make;
		public String Model;
		public String EquipmentConfiguration;
		public String ApplicationCode;
		public Integer Distance;
		public String DistanceType;
		public Double Hours;
		public String ApprovalCode;
		public String DistributorAuthorization;
		public String DeductibleApply;
		public String TravelAllowed;
		public String TowingAllowed;
		public Integer TravelHoursAllowed;
		public String CreateUser;
		public String ChangeUser;
	}

	public class Location {
		public String LocationID;
	}

	
	public static CG_IP_sendClaimHeadertoBMSReqJSON parse(String json) {
		return (CG_IP_sendClaimHeadertoBMSReqJSON) System.JSON.deserialize(json, CG_IP_sendClaimHeadertoBMSReqJSON.class);
	}
}