public class EVL_DX_SORequestWrapper {
    
    //public Header Header;
    //public DataArea DataArea;
    
    public class Header
    {
        public String ServiceName;
        public String ToolID;
        public String ServiceVersion;
        public String SenderId;
        public String TargetId;
        public String SPCode;
        public String UserId;
    }
    
    public class DataArea
    {
       
        public String ServiceOrderNumber;
        public String SPCode;
        public CUST_DATA CUST_DATA;
        public UNIT_DATA UNIT_DATA;
        public List<CampaignDetails> CampaignDetails;
        public List<SERVICEHIST> SERVICEHIST;
            
    }
    
    //8/4/22 Adam changes as part of Salesforce Health Assesment
    @TestVisible
    private Header Header;
    
    public Header getHeader() {
        return Header;
    }
    public void setHeader(Header newHeader){
        this.Header = newHeader;
    }
    @TestVisible
    private DataArea DataArea;
    
    public DataArea getDataArea() {
        return DataArea;
    }
    public void setDataArea(DataArea newDataArea) {
        this.DataArea = newDataArea;
    }
    
    //end change*/
    
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
        public String ProductHours;
        public String ProductMileage;
        public String MileageMeasure;       
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
    
     public class CampaignDetails {
        public String CampaignsATCsDataFlag;
        public String CampaignsATCsDataNumber;
        public String CampaignsATCsDataType;

    }
     public class DataResponse
    {
        public string ServiceOrderNumber;
        public string GuidanzURL;
        public string ReturnCodeDescription;
        public string Status;
        public string ErrorCode;
        public string senderId;
        public String TargetId;

    }
    
    public static EVL_DX_SORequestWrapper parse(String json){
		return (EVL_DX_SORequestWrapper) System.JSON.deserialize(json, EVL_DX_SORequestWrapper.class);
	}
}