/*
  *****************************************************************************
  HISTORY
  *****************************************************************************
  ******************************************************************************
    Version        Author        Date        Details
    1.0  Vignesh  Shanmugakani              Intial Developement
    1.1  Rajesh Narra           10-24-2017  Added SymptomData class and added member variables to the SolutionData,DataArea,RepairData
    ****************************************************************************
*/

global class CSS_GetJobInfoResWrapper {
    
    public class SolutionData {
        public String SolutionTitle;
        public String SolDescriptions;
        public String Comments;
        public String SolutionNumber;
        public String SymptomName;
        public String RelatedFC;
        public String FaultCode;
    }
    public class SymptomData{
        public String SymptomName;
     }
    public class Components {
        public String ComponentID;
        public String ComponentName;
        public String Action;
    }
    
    public class DataArea {
        public String CSSJobId;
        public String PSN;
        public String SERVICEMODELNAME;
        public String MAKE;
        public String MODEL;
        public String CUSTOMERNAME;
        public String SHOPWO;
        public String DATEAVAILSERVICE;
        public List<FAULTDETAILS> FAULTDETAILS = new List<FAULTDETAILS>();
        public List<SolutionData> SolutionData = new List<SolutionData>();
        public List<SymptomData> SymptomData = new List<SymptomData>();
        public List<RepairData> RepairData = new List<RepairData>();
        public CUST_DATA CUST_DATA;
        public UNIT_DATA UNIT_DATA;
    }

  public class Header {
    public String ServiceName;
    public String ServiceVersion;
    public String Status;
    public String ReturnCode;
    public String ReturnCodeDescription;
  }
    
    
    public class CUST_DATA {
        public String CustomerID;
        public String CustomerName;
        public String ContactName;
        public String AddressLine1;
        public String AddressLine2;
        public String City;
        public String StateProvince;
        public String Country;
    }

    public class UNIT_DATA {
        public String Application;
        public String UnitNumber;
        public String ESN;
        public String ServiceModel;
        public String Make;
        public String Model;
        public String VIN;
        public String FailureDate;
        public String WarrStartDate;
        public String MileageOrKms;
        public String MileageMeasure;
        public String Hours;
        public String FailurePoint;
        public String BeforeInService;
    }

    public class RepairData {
        public String FaultCode;
        public String RelatedFC;
        public String SolutionNumber;
        public String SolutionDescription;
        public String SolutionTitle;
        public String RepairAction;
        public String RepairComments;
        public String SymptomName;
        public List<Components> Components = new List<Components>();
    }

    public class FAULTDETAILS {
        public String Count;
        public String FaultCodeText;
        public String FaultCode;
        public String FaultCodeType;
        public String PrimaryFC;
        public String RelatedFC;
        public String RelatedFC_Text;
    }
        
  public Header Header;
  public DataArea DataArea;
  
  public static CSS_GetJobInfoResWrapper parse(String json) {
      System.debug('** Rajesh N'+json);
    return (CSS_GetJobInfoResWrapper) System.JSON.deserialize(json, CSS_GetJobInfoResWrapper.class);
  }
}