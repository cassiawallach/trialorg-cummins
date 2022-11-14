/************************************************************
Name:  OSM_WS_GetFreeTrailReq 
Copyright © 2018  Cummins
=============================================================
=============================================================
Purpose:                                                            
This is request class for freetrial subscription.
=============================================================
=============================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE              DETAIL                                
1.0 -   Ankit S         01/07/2018     INITIAL DEVELOPMENT          


*************************************************************/
public class OSM_WS_GetFreeTrailReq {

    public class OrderLineItems {
        public String productID;
        public String freeTrial;
        public Integer subscriptionQuantity;
        public String subscriptionType;
        public Double pricePerUnit;
        public String currencyType;
        public String startDate;
        public String expirationDate;
        public List<String> equipmentGroups;
    }

    public String messageID;
    public String timeStamp;
    public String initiator;
    public String customerId;
    public String orderId;
    public String createdDate;
    public String nextInvoiceDate;
    public List<OrderLineItems> orderLineItems;
        
}