/*********************************************************************************************************************************
Name:FSL_GetTimesheetStatusRequest
Copyright © 2019  Cummins
===================================================================================================================================
===================================================================================================================================
Purpose:                                                            
This is the wrapper class to handle request received in class FSL_GetTimesheetStatus.
===================================================================================================================================
===================================================================================================================================
History                                                            
-------                                                            
VERSION  					AUTHOR            		DATE               				DETAIL                                
1.0 -     					Raghav Bansal    		7/12/2021       				INITIAL DEVELOPMENT 
***********************************************************************************************************************************/

global class FSL_GetTimesheetStatusRequest {

    public Header Header;
	public DataArea DataArea;

    public class Header {
		public Sender Sender;
		public Target Target;
	}

    public class Sender {
		public String ServiceName;
		public String SenderID;
	}

	public class Target {
		public String TargetID;
	}

	public class DataArea {
		public String CSSJobID;
		public String ERPJobLineNumber;
		public String AssignmentNumber;
	}
	
	public static FSL_GetTimesheetStatusRequest parse(String json) {
		return (FSL_GetTimesheetStatusRequest) System.JSON.deserialize(json, FSL_GetTimesheetStatusRequest.class);
	}
}