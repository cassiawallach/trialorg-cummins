/******
Name:  OSM_CancelLicensesRESWrapper
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
public class OSM_CancelLicensesRESWrapper {

    public class Sender {
        public String ServiceName;
        public String SenderID;
    }

    public class Target {
        public String TargetID;
    }

    public class Header {
        public String ReturnCodeDescription;
        public String Status;
        public Sender Sender;
        public Target Target;
    }

    public Header Header;
    public CancelLicensesOutput CancelLicensesOutput;

    public class CancelLicensesOutput {
        public String CancelledCopies;
        public String RemainingCopies;
        public String CancelLicenseStatus;
    }

    
    public static OSM_CancelLicensesRESWrapper parse(String json) {
        return (OSM_CancelLicensesRESWrapper) System.JSON.deserialize(json, OSM_CancelLicensesRESWrapper.class);
    }
}