/************************************************************
Name:  OSM_WS_GetProductDetail_RES 
Copyright © 2018  Cummins
=============================================================
=============================================================
Purpose:                                                            
This is JSON2Apex class for Product interface response.                                    
=============================================================
=============================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE              DETAIL                                
1.0 -   Mouilka G            23/03/2018     INITIAL DEVELOPMENT          

*************************************************************/

public class OSM_WS_GetProductDetail_RES {

    public class ProductSubscriptionInfo {
        public String productID;
        public Integer availableCount;
        public Integer totalSubscriptionCount;
        public String message;
    }

    public String customerID;
    public List<ProductSubscriptionInfo> productSubscriptionInfo;

    public Long totalAuthCallTime{get;set;}
    public Long totalServiceCallTime{get;set;}
    public boolean exceptionFlag{get;set;}
    public String errorMessage{get;set;}
    public String exceptionMessage{get;set;}
    
    public static OSM_WS_GetProductDetail_RES parse(String json) {
        return (OSM_WS_GetProductDetail_RES) System.JSON.deserialize(json, OSM_WS_GetProductDetail_RES.class);
    }
}