/*
  *****************************************************************************
  HISTORY
  *****************************************************************************
  ******************************************************************************
    Version	Author        			Date        Details
    1.0		Vignesh  Shanmugakani              	Intial Developement
    1.1		Rajesh Narra           	10-24-2017  Added BeforeInService to the Wrapper
	2.0		Gyana Pany				02-13-2018	Updated Mapping based on API version 2.0
    ****************************************************************************
*/

global class CSS_SendJobInfoReqWrapper {
    
    public class DataArea {
        public String ServiceOrderNumber;
        public String SPCode;
        public CUST_DATA CUST_DATA;
        public UNIT_DATA UNIT_DATA;
        //Commented by Sriprada for Dealer DX changes to make it unique
       //public COMPLAINT_DATA COMPLAINT_DATA;   // Dunkirk Story

        public List<SERVICEHIST> SERVICEHIST;
        public List<CampaignDetails> CampaignDetails;

    }
    
    public class Header {
        public String ServiceName;
        public String ServiceVersion;
        public String ToolID;
        public String SPCode;
        public String SenderID;
        public String TargetID;
        public String UserId;
    }
    
    public Header Header;
    public DataArea DataArea;
    
    public class CUST_DATA {
        public String CustomerName;
        public String Location;
        public String ShopWO;
        public String Contact;
        public String CustomerComplaint;
        public String JobCreatedDate;
        public String AvailableForService;


    }  
    
    public class UNIT_DATA {
        public string PSN;
        public String UnitNumber;
        public String Application;
        
        public String ServiceModel;
        public String Make;
        public String Model;
        public String VIN;
        
        public String WarrStartDate;
        public String BeforeInService;
        public String FailureDate;
        public String MileageMeasure;
        public String ProductMileage;
        public String ProductHours;       
    }
    
    /*  commented by Sriprada for Dealer DX changes to make it unique

    public class COMPLAINT_DATA {  // // Story Dunkirk
        public string ComplaintText; 
        public String Code; 
        
    }   */
    public class CampaignDetails {
        public String CampaignsATCsDataFlag;
        public String CampaignsATCsDataNumber;
        public String CampaignsATCsDataType;
        
    }
    
    public class SERVICEHIST {
        public String Source;
        public String JobDate;
        public String CustomerName;
        public String ShopWO;
        public String ServiceModelNM;
        public String ServiceLocation;
        public String WorkSummary;
        public String FaultCodeSymptom;
        public String Mileage;
        public String MileageMeasure;
    }
    
    public static CSS_SendJobInfoReqWrapper parse(String json) {
        return (CSS_SendJobInfoReqWrapper) System.JSON.deserialize(json, CSS_SendJobInfoReqWrapper.class);
    }
}