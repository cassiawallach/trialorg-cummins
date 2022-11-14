/************************************************************
Name:  OSM_BOLT_WS_JournalEntryOutboundRes 
Copyright © 2018  Cummins
=============================================================
=============================================================
Purpose:                                                            
This is JSON2Apex class for Journal Entry Outbound interface
response
=============================================================
=============================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE              DETAIL                                
1.0 -   Ankit S         19/05/2018     INITIAL DEVELOPMENT          


*************************************************************/

public class OSM_BOLT_WS_JournalEntryOutboundRes {

    public String Status;
    public String Request;
    public String ReturnCodeDescription;
    public Integer totalServiceCallTime;
    public Integer totalAuthCallTime;
    public Boolean exceptionFlag;
    public String errorMessage;
    
    public static OSM_BOLT_WS_JournalEntryOutboundRes parse(String json) {
        return (OSM_BOLT_WS_JournalEntryOutboundRes) System.JSON.deserialize(json, OSM_BOLT_WS_JournalEntryOutboundRes.class);
    }
}