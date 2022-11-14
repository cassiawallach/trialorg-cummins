/******************************************************************************************************************
Name: EVL_RSW_ReqWrapper
Copyright © 2020  Cummins
===================================================================================================================
===================================================================================================================
Purpose:    This class is for Create Claims funtionality.
===================================================================================================================
===================================================================================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE                DETAIL                                 
1.0     Lochana Rajput     06/10/2022     Added Event type attribute in DataArea for FTR feature in JSON request of RSW 
*******************************************************************************************************************/
public class EVL_RSW_ReqWrapper {

	public class Sender {
		public String SenderID;
	}

	public class Target {
		public String TargetID;
	}

	public class DataArea {
		//1.0 STARTS
		public String eventType;
		//1.0 ENDS
		public String id;
		public String timestamp;
		public String dsID;
		public String createDate;
		public String workOrder;
		public String esn;
		public String dsStatus;
		public String dsClosureType;
		public String nbSearches;
		public String accessSRTID;
		public String faliurePoint;
		public String faliureMeasure;
		public String manufacturer;
		public String modelSeries;
		public String unitNumber;
		public String customerName;
		public String application;
		public String faultCode;//fault Code Object - should it be only fault code object or sym as well?
		public List<Event> event;
	}
  //public Header Header; 
    //public DataArea DataArea;
    //started by Naga Anusha Malepati 8/3/22 ,NIN-470, regarding Class variables doesn't have public accessibility
     @TestVisible
     private Header Header;     
    // Getter
    public Header getHeader() {
        return Header;
    }    
    // Setter
    public void setHeader(Header newHeader) {
        this.Header = newHeader;
    }
     @TestVisible
    private DataArea DataArea;        
    // Getter
    public DataArea getDataArea() {
        return DataArea;
    }    
    // Setter
    public void setDataArea(DataArea newDataArea) {
        this.DataArea = newDataArea;
    } 
    //Ended by Naga Anusha Malepati 8/3/22 ,NIN-470, regarding Class variables doesn't have public accessibility 

	public class Header {
		public Sender Sender;
		public Target Target;
	}

	public class Event {
		public String solutionId;
		public String solutionSeq;//Rank
		public String searchNumber;//'1'
		public String searchCompleted;
		public String verificationStatus;
		public String repairStatus;
		public String timestamp;//last modified timestamp
		public String informationType;
		public String componentID;
	}

	
	public static EVL_RSW_ReqWrapper parse(String json) {
		return (EVL_RSW_ReqWrapper) System.JSON.deserialize(json, EVL_RSW_ReqWrapper.class);
	}
}