/**********************************************************************
Name:CSS_BMSSendJobPlan_Req_Json
Copyright © 2018  Cummins
=======================================================================
=======================================================================
Purpose:  
Get Parts from BMS(Parts) request Wrapper class #133137                                                        
=======================================================================
History                                                            
-------                                                            
VERSION   AUTHOR          DATE                 DETAIL                                 
1.0 -    Karthik G     04/16/2018        INITIAL DEVELOPMENT  
=======================================================================
***********************************************************************/

public class CSS_BMSJobParts_Req_Json {

    public class Sender {
        public String ServiceName;
        public String SenderID;
    }

    public class PartDetails {
        public String PartNumber;
        public String PartDescription;
        public String QuantityOrdered;
        public String QuantityUsed;
        public String PartsReturn;
        //public Double SellPrice; Commented by Rajesh Narra on 06-29-2018 during SIT
        //public Integer WarrantyAllocation; Commented by Rajesh Narra on 06-29-2018 during SIT
        public String SellPrice;
        public String WarrantyAllocation;
        public String Comments;
        public String LineType;
        public String SerialNumber;
        public String SerialNumberVendor;
        public String Model;
        public String Option;
        public String ESN;
        public String SSN;
        public String VIN;
        public String PartOC;
        public String TrackingNumber;
        public String RID;
        public String Address1;
        public String Address2;
        public String City;
        public String State;
        public String Zip;
        public String CreateUser;
        public String CreateDate;
        public String ChangeUser;
        public String ChangeDate;
        //public String priceBook; Commented by Rajesh Narra since this price book is not there in the requirement document.
    }

    public class Target {
        public String TargetID;
        public String SourceEnvironment;
    }

    public class DataArea {
        public String CSSJobId;
        public String DistributorCode;
        public String BranchCode;
       // public String CustomerCode; by Rajesh Narra
       public Integer CustomerCode;
        public String OrderType;
        //public String BMSReferenceNumber; by Rajesh Narra
        Public Integer BMSReferenceNumber;
        public List<PartDetails> PartDetails;
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


    public static CSS_BMSJobParts_Req_Json parse(String json) {
        return (CSS_BMSJobParts_Req_Json) System.JSON.deserialize(json, CSS_BMSJobParts_Req_Json.class);
    }
}