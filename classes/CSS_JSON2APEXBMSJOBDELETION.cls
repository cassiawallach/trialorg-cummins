/**********************************************************************
Name:CSS_JSON2APEXBMSJOBDELETION
Copyright © 2011  Cummins
=======================================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE                 DETAIL                                 
1.0 - karthik Gorantla      03/19/2018        INITIAL DEVELOPMENT  
=======================================================================
***********************************************************************/

public class CSS_JSON2APEXBMSJOBDELETION {

	public class Sender {
		public String ServiceName;
		public String SenderID;
	}

	public class Target {
		public String TargetID;
	}

	public class DataArea {
		public String CSSJobId;
		public String DistributorCode;
		public String BranchCode;
		public String CustomerCode;
		public String OrderType;
		public String BMSReferenceNumber;
		public String Action;
		public String Reason;
	}

	public Header Header;
	public DataArea DataArea;

	public class Header {
		public Sender Sender;
		public Target Target;
		public Location Location;
	}

	public class Location {
		public String LocationID;
	}

	
	public static CSS_JSON2APEXBMSJOBDELETION parse(String json) {
		return (CSS_JSON2APEXBMSJOBDELETION) System.JSON.deserialize(json, CSS_JSON2APEXBMSJOBDELETION.class);
	}
}