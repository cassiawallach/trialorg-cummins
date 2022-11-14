/************************************************************
Name:  OSM_WS_GetOrderDetail_REQ 
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
public class OSM_WS_GetOrderDetail_REQ {

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
    //public List<ccrz__E_OrderItem__c> orderLineItems;
    public List<OrderLineItems> orderLineItems;
        
    public static OSM_WS_GetOrderDetail_REQ parse(String json) {
        return (OSM_WS_GetOrderDetail_REQ) System.JSON.deserialize(json, OSM_WS_GetOrderDetail_REQ.class);
    }
}