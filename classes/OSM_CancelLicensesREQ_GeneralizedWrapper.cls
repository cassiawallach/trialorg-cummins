/******
Name:  OSM_CancelLicensesREQ_GeneralizedWrapper
Copyright © 2018  Cummins
=============================================================
=============================================================
Purpose:                                                                                             
=============================================================
=============================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE              DETAIL                                
1.0 -   Neha Mehta       14/01/2019     INITIAL DEVELOPMENT 
*******/
public class OSM_CancelLicensesREQ_GeneralizedWrapper {

    public class Sender {
        public String ServiceName;
        public String SenderID;
    }

    public class Target {
        public String TargetID;
    }

    public class CancelLicensesInput {
        public String ToolName;
        public String RequesterId;
        public String ItemId;
        public Integer TotalCopies;
        public String AccountId; //Added by Dhiraj
    }

    public class Header {
        public Sender Sender;
        public Target Target;
    }

    public Header Header;
    public CancelLicensesInput CancelLicensesInput;

    
    public static OSM_CancelLicensesREQ_GeneralizedWrapper parse(String json) {
        return (OSM_CancelLicensesREQ_GeneralizedWrapper) System.JSON.deserialize(json,OSM_CancelLicensesREQ_GeneralizedWrapper.class);
    }
}