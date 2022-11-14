/*****************************************************************
Name:  OSM_BOLT_WS_CustomMasterRes
Copyright © 2018  Cummins
==================================================================
==================================================================
Purpose:                                                            
This is JSON to Apex wrapper for service response which we will get
once the input is exposed to rest webservice class 
OSM_BOLT_WS_CustomMasterInbound                         
==================================================================
==================================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE              DETAIL                                
1.0 -   Mouilka G         05/04/2018     INITIAL DEVELOPMENT          

******************************************************************/

global class OSM_BOLT_WS_CustomMasterRes {

    public String Status;
    public String ReturnCodeDescription;
    
    public OSM_BOLT_WS_CustomMasterRes()
    {
        
    }
    
    public static OSM_BOLT_WS_CustomMasterRes parse(String json) {
        return (OSM_BOLT_WS_CustomMasterRes) System.JSON.deserialize(json, OSM_BOLT_WS_CustomMasterRes.class);
    }
}