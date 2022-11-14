/**********************************************************************
Name:CSS_BMSSendJobPlan_Req_Json
Copyright © 2018  Cummins
=======================================================================
=======================================================================
Purpose:  
Get SRT from BMS(Job Plan) request Wrapper class #133132                                                        
=======================================================================
History                                                            
-------                                                            
VERSION   AUTHOR          DATE                 DETAIL                                 
1.0 -    Vignesh S      04/04/2018        INITIAL DEVELOPMENT  
=======================================================================
***********************************************************************/
public class CSS_BMSSendJobPlan_Req_Json {

    public class Header {
        public Sender Sender;
        public Target Target;
        public Location Location;
    }

    public class Sender {
        public String ServiceName;
        public String SenderID;
    }

    public class Target {
        public String TargetID;
    }

    public class Location {
        public String LocationID;
    }

    public class DataArea {
        public String CSSjobID;
        public String DistributorCode;
        public String BranchCode;
        public String CustomerCode;
        public String OrderSourceType;
        public String BMSReferenceNumber;
        public List<SRTDetail> SRTDetails;
    }

    public class SRTDetail {
        public String SRTGroup;
        public String Procedure;
        public String Step;
        public Integer Quantity;
        public Double SRTHour;
        public Integer ActualHour;
        public Double BilledHour;
        public String Bill;
        public String Troubleshoot;
        public String Flexible;
        public String PrivateWork;
        public String ServiceModelName;
        public String Title;
        public Integer SortOrder;
        public String Access;
        public Integer WarrantyAllocation;
        public String AdjustmentReason;
        public String AccountCode;
        public String ClaimType;
        public String CreateDate;
        public String CreateUser;
        public String ChangeDate;
        public String ChangeUser;
    }

    public Header Header;
    public DataArea DataArea;

    public static CSS_BMSSendJobPlan_Req_Json parse(String json) {
        return (CSS_BMSSendJobPlan_Req_Json) System.JSON.deserialize(json, CSS_BMSSendJobPlan_Req_Json.class);
    }
}