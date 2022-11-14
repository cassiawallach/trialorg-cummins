/************************************************************
Name:  OSM_WS_GetOrderDetail_RES 
Copyright © 2018  Cummins
=============================================================
=============================================================
Purpose:                                                            
This is JSON2Apex class for order interface response                                    
=============================================================
=============================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE              DETAIL                                
1.0 -   Mouilka G            23/03/2018     INITIAL DEVELOPMENT          

*************************************************************/

public class OSM_WS_GetOrderDetail_RES {

    public String messageID {get;set;}
    public String Response {get;set;}
    public Long totalAuthCallTime {get;set;}
    public Long totalServiceCallTime {get;set;}    
    public boolean exceptionFlag{get;set;}
    public String errorMessage{get;set;}
    public String exceptionMessage{get;set;}
    
    public static OSM_WS_GetOrderDetail_RES parse(String json) {
        return (OSM_WS_GetOrderDetail_RES) System.JSON.deserialize(json, OSM_WS_GetOrderDetail_RES.class);
    }
}