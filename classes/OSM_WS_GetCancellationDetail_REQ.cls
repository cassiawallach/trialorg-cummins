/************************************************************
Name:  OSM_WS_GetCancellationDetail_REQ 
Copyright © 2018  Cummins
=============================================================
=============================================================
Purpose:                                                            
This is JSON2Apex class for Order Cancelaltion interface request.                                    
=============================================================
=============================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE              DETAIL                                
1.0 -   Mouilka G            23/03/2018     INITIAL DEVELOPMENT          

*************************************************************/

public class OSM_WS_GetCancellationDetail_REQ {

    public String messageID;
    public String timeStamp;
    public String initiator;
    public String customerID;
    public String orderID;
    public String cancelDate;

    
    public static OSM_WS_GetCancellationDetail_REQ parse(String json) {
        return (OSM_WS_GetCancellationDetail_REQ) System.JSON.deserialize(json, OSM_WS_GetCancellationDetail_REQ.class);
    }
}