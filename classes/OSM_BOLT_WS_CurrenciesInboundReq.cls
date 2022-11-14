/************************************************************
Name:  OSM_BOLT_WS_CurrenciesInboundReq 
Copyright © 2018  Cummins
=============================================================
=============================================================
Purpose:                                                            
This is JSON2Apex class for Currencies interface request
=============================================================
=============================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE              DETAIL                                
1.0 -   Ankit S         10/04/2018     INITIAL DEVELOPMENT          


*************************************************************/

public class OSM_BOLT_WS_CurrenciesInboundReq {

    public class Sender {
        public String ServiceName;
        public String SenderID;
    }

    public class Target {
        public String TargetID;
    }

    public class DataArea {
        public List<CURR_RATE_STG_ROW> CURR_RATE_STG_ROW;
    }

    public class Header {
        public Sender Sender;
        public Target Target;
    }

    public class CURR_RATE_STG_ROW {
        public String FROM_CURRENCY;
        public String TO_CURRENCY;
        public String FROM_CONVERSION_DATE;
        public String TO_CONVERSION_DATE;
        public String CONVERSION_TYPE;
        public String CONVERSION_RATE;
        public String MODE_FLAG;
    }

    public Header Header;
    public DataArea DataArea;

    
    public static OSM_BOLT_WS_CurrenciesInboundReq parse(String json) {
        return (OSM_BOLT_WS_CurrenciesInboundReq) System.JSON.deserialize(json, OSM_BOLT_WS_CurrenciesInboundReq.class);
    }
}