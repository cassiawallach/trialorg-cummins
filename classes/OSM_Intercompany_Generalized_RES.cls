/******
Name:  OSM_Intercompany_Generalized_RES 
Copyright © 2018  Cummins
=============================================================
=============================================================
Purpose:                                                                                             
=============================================================
=============================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE              DETAIL                                
1.0 -   Neha Mehta       19/12/2018     INITIAL DEVELOPMENT 
*******/
public class OSM_Intercompany_Generalized_RES  {
    public String errorMsg;
    public Boolean errorFlag;
    public OSM_Integration_Log__c log;
    public class Sender {
        public String ServiceName;
        public String SenderID;
    }

    public class Target {
        public String TargetID;
    }

    public class DataArea {
        public String DistributorCode;
        public String CustomerCode;
        public String Attribute01;
        public String Attribute02;
        public String Attribute03;
    }

    public class Header {
        public String Status;
        public String StatusMessage;
        public Sender Sender;
        public Target Target;
    }

    public Header Header;
    public DataArea DataArea;

    
    public static OSM_Intercompany_Generalized_RES parse(String json) {
        return (OSM_Intercompany_Generalized_RES) System.JSON.deserialize(json, OSM_Intercompany_Generalized_RES.class);
    }
}