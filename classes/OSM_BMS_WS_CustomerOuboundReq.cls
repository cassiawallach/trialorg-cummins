/************************************************************
Name:  OSM_BMS_WS_CustomerOuboundReq
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
1.0 -   Sangeeta            23/10/2018     INITIAL DEVELOPMENT          


*************************************************************/

public class OSM_BMS_WS_CustomerOuboundReq {

    public class Sender {
        public String ServiceName;
        public String SenderID;
    }

    public class Target {
        public String TargetID;
    }

    public class DataArea {
        public String CustomerName;
        public String CustomerCode;
        public String DealerCode;
    }

    public class Header {
        public Sender Sender;
        public Target Target;
        public Location Location;
    }

    public Header Header;
    public DataArea DataArea;

    public class Location {
        public String LocationID;
    }

    
    public static OSM_BMS_WS_CustomerOuboundReq parse(String json) {
        return (OSM_BMS_WS_CustomerOuboundReq) System.JSON.deserialize(json, OSM_BMS_WS_CustomerOuboundReq.class);
    }
}