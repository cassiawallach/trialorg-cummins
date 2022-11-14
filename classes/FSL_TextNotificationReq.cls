public class FSL_TextNotificationReq {
	public class Target {
		public String TargetEmailAddress;
		public String TargetEmailCcAddress;
		public String TargetEmailBccAddress;
		public String TargetPhoneNumber;
	}

	public class DataArea {
		public String NotificationSubject;
		public String ServiceStatus;
		public String WorkOrderNumber;
		public BranchContact BranchContact;
		public AssetDetails AssetDetails;
	}

	public Header Header;
	public DataArea DataArea;

	public class Header {
		public String Language;
		public String Action;
		public String EventType;
		public Source Source;
		public Target Target;
	}

	public class BranchContact {
		public String Address;
		public String PhoneNumber;
		public String SupervisorContact;
	}

	public class AssetDetails {
		public String Unit;
		public String Make;
		public String Model;
		public String ProductSerialNumber;
		public String VIN;
	}

	public class Source {
		public String SenderID;
		public String FromEmailAddress;
	}    
    public static FSL_TextNotificationReq parse(String json){
        return (FSL_TextNotificationReq) System.JSON.deserialize(json, FSL_TextNotificationReq.class);
    }
}