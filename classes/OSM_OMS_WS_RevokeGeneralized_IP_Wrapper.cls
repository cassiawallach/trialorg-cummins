/************************************************************
Name:  OSM_OMS_WS_RevokeGeneralized_IP_Wrapper
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
public class OSM_OMS_WS_RevokeGeneralized_IP_Wrapper {

    public Header Header{get;set;}
    public RevokeLicensesInput RevokeLicensesInput{get;set;}
    
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


    public class RevokeLicensesInput {
        public String ToolName;
        public String RequesterId;
        public List<InstanceIdList> InstanceIdList;
    }

    public class InstanceIdList {
        public String Instance;
    }

    
   
}