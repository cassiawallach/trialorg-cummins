/************************************************************
Name:  OSM_BOLT_WS_ARInvoiceOutboundRes 
Copyright © 2018  Cummins
=============================================================
=============================================================
Purpose:                                                            
This is Json to Apex Response class. 
=============================================================
=============================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE              DETAIL                                
1.0 -   Ankit S         19/05/2018     INITIAL DEVELOPMENT          


*************************************************************/

global class OSM_BOLT_WS_ARInvoiceOutboundRes {

    public String Status;
    public String Request;
    public String ReturnCodeDescription;
    public Integer totalServiceCallTime;
    public Integer totalAuthCallTime; 
    public Boolean exceptionFlag;
    public String errorMessage;
    
    public static OSM_BOLT_WS_ARInvoiceOutboundRes parse(String json) {
        return (OSM_BOLT_WS_ARInvoiceOutboundRes) System.JSON.deserialize(json, OSM_BOLT_WS_ARInvoiceOutboundRes.class);
    }
}