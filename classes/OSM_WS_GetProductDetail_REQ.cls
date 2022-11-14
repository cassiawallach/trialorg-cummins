/************************************************************
Name:  OSM_WS_GetProductDetail_REQ 
Copyright © 2018  Cummins
=============================================================
=============================================================
Purpose:                                                            
This is JSON2Apex class for Product interface request.                                    
=============================================================
=============================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE              DETAIL                                
1.0 -   Mouilka G            23/03/2018     INITIAL DEVELOPMENT          

*************************************************************/

public class OSM_WS_GetProductDetail_REQ {

    public String messageID;
    public String timeStamp;
    public String initiator;
    public String customerID;

    
    public static OSM_WS_GetProductDetail_REQ parse(String json) {
        return (OSM_WS_GetProductDetail_REQ) System.JSON.deserialize(json, OSM_WS_GetProductDetail_REQ.class);
    }
}