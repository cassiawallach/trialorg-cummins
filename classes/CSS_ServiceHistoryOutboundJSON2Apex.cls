/**********************************************************************
Name: CSS_ServiceHistoryOutboundJSON2Apex 
Copyright © 2016  Cummins
======================================================
======================================================
Purpose:    Wrapper Class to deserialize the response from
            BMS_ServiceHistoryOutbound
                                                          
======================================================
======================================================
History                                                            
-------                                                            
VERSION         AUTHOR          DATE            DETAIL                                 
1.0         Nisha Mendiratta    05/09/2016      INITIAL DEVELOPMENT                    

***********************************************************************/


public class CSS_ServiceHistoryOutboundJSON2Apex {
    
    	public class Sender {
		public String ServiceName;
		public String SenderID;
	}

	public class Target {
		public String TargetID;
	}

	public class DataArea {
		public String Distance;
		public String FaultcodesCORRECTION;
		public String DistanceType;
		public String ReceivedDate;
		public String WorkSummaryCAUSE;
		public String Location;
		public String UnitHours;
		public String BMSLink;
		public String BMSWOreference;
		public String ProductModel;
		public String CustomerName;
		public String WorkSummaryCOMPLAINT;
        public Integer Invoice;
        public String ClaimNumber;
	}

	public class Header {
        public String ReturnCodeDescription;
		public String Status;
		public Sender Sender;
		public Target Target;
		public Location Location;
	}

	public List<DataArea> DataArea;
	public Header Header;

	public class Location {
		public String LocationID;
	}


    public static CSS_ServiceHistoryOutboundJSON2Apex parse(String json) {
        return (CSS_ServiceHistoryOutboundJSON2Apex) System.JSON.deserialize(json, CSS_ServiceHistoryOutboundJSON2Apex.class);
    }
}