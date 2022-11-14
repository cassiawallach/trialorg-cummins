/************************************************************
Name:  OSM_OMS_WS_RevokeLicenseReq
Copyright © 2018  Cummins
=============================================================
=============================================================
Purpose:                                                            
This is request wrapper class. 

=============================================================
=============================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE              DETAIL                                
1.0 -   Sangeeta            17/01/2019    INITIAL DEVELOPMENT          


*************************************************************/
public class OSM_OMS_WS_RevokeLicenseReq {

   public class Sender {
        public String ServiceName;
        public String SenderID;
    }

    public class Target {
        public String TargetID;
    }

    public class Header {
        public Sender Sender;
        public Target Target;
    }

   public Header Header;
    public RevokeLicensesInput RevokeLicensesInput;

    public class RevokeLicensesInput {
        public String ToolName;
        public String RequesterId;
        public List<InstanceIdList> InstanceIdList;
    }

    public class InstanceIdList {
        public String Instance;
    }

    public static OSM_OMS_WS_RevokeLicenseReq parse(String json) {
        return (OSM_OMS_WS_RevokeLicenseReq) System.JSON.deserialize(json, OSM_OMS_WS_RevokeLicenseReq.class);
    }
}