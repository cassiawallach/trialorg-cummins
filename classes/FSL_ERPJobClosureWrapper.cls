public class FSL_ERPJobClosureWrapper {
	public Header Header;
	public DataArea DataArea;
	public class Header {
		public Sender Sender;
		public Target Target;
		public Location Location;
	}
	public class Sender {
		public String ServiceName;	//sendBMSJobDeletion
		public String SenderID;	//BMS
	}
	public class Target {
		public String TargetID;	//CSS
	}
	public class Location {
		public String LocationID;	//02400-02394
	}
	public class DataArea {
		public String CSSJobId;	//00000451
		public String DistributorCode;	//02400
		public String BranchCode;	//02394
		public String CustomerCode;	//C100002045
		public String OrderType;	//WO/WOQT
		public String BMSReferenceNumber;	//98687687
		public String Action;	//DELETE
		public String Reason;	//Job deleted in BMS. 
	}
	public static FSL_ERPJobClosureWrapper parse(String json){
		return (FSL_ERPJobClosureWrapper) System.JSON.deserialize(json, FSL_ERPJobClosureWrapper.class);
	}
}