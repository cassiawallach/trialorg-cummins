/************************************************************
Name:  OSM_BOLT_WS_CurrenciesInboundRes 
Copyright © 2018  Cummins
=============================================================
=============================================================
Purpose:                                                            
This is JSON2Apex class for Currencies interface response
=============================================================
=============================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE              DETAIL                                
1.0 -   Ankit S         10/04/2018     INITIAL DEVELOPMENT          


*************************************************************/

global class OSM_BOLT_WS_CurrenciesInboundRes {

    public String Status;
    public String ReturnCodeDescription;
    
    public static OSM_BOLT_WS_CurrenciesInboundRes parse(String json) {
        return (OSM_BOLT_WS_CurrenciesInboundRes) System.JSON.deserialize(json, OSM_BOLT_WS_CurrenciesInboundRes.class);
    }
}