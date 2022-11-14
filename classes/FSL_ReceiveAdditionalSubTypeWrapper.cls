/*********************************************************************************************************************************
Name:FSL_ReceiveAdditionalSubTypeWrapper
Copyright © 2019  Cummins
===================================================================================================================================
===================================================================================================================================
Purpose:                                                            
This is the wrapper for integration api expose class for Additional Sub-Type from MOVEX.
===================================================================================================================================
===================================================================================================================================
History                                                            
-------                                                            
VERSION  					AUTHOR            		DATE               				DETAIL                                
1.0 -      					PiyushR    				8/25/2020       				INITIAL DEVELOPMENT 
***********************************************************************************************************************************/

public class FSL_ReceiveAdditionalSubTypeWrapper {

	public class Sender {
		public String ServiceName;
		public String SenderID;
	}

	public class Target {
		public String TargetID;
	}

	public class DataArea {
		public String CSSJobID;
		public String ERPWONumber;
		public String PayerAccount;
		public String AssignmentNumber;
		public String PrimarySubType;
		public String ERPJobLineNumber;
		public String Status;
		public List<AdditionalSubTypes> AdditionalSubTypes;
	}

	public Header Header;
	public DataArea DataArea;
 
	public class Header {
		public Sender Sender;
		public Target Target;
	}

	public class AdditionalSubTypes {
		public String SubType;
		public String AssignmentNumber;
		public String ERPJobLineNumber;
		public String PayerAccount;
		public String Status;
	}
	
	public static FSL_ReceiveAdditionalSubTypeWrapper parse(String json) {
		return (FSL_ReceiveAdditionalSubTypeWrapper) System.JSON.deserialize(json, FSL_ReceiveAdditionalSubTypeWrapper.class);
	}
}