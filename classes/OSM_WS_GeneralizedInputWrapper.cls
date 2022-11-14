/************************************************************
Name:  OSM_WS_GeneralizedInputWrapper
Copyright © 2018  Cummins
=============================================================
=============================================================
Purpose:                                                            
This is a generalised wrapper for all product, order update 
and order cancellation interface. Instead of passing 
individual paramters, we will pass this generalized 
wrapper class.                
=============================================================
=============================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE              DETAIL                                
1.0 -   Ankit S            18/04/2018     INITIAL DEVELOPMENT          

*************************************************************/

public class OSM_WS_GeneralizedInputWrapper {

    public String messageID;
    public String timeStamp;
    public String initiator;
    public String customerId;
    public String orderId;
    public String createdDate;
    public String cancelDate;
    public String nextInvoiceDate;

    public class OrderLineItems {
        public String productID;
        public String freeTrial;
        public Integer subscriptionQuantity;
        public String subscriptionType;
        public String startDate;
        public Decimal pricePerUnit;
        public String currencyType;
        public String expirationDate;
        public List<String> equipmentGroups;
    }

    public class EquipmentGroups {
    }
    
    public List<OrderLineItems> orderLineItems;
    
    public static OSM_WS_GeneralizedInputWrapper parse(String json) {
        return (OSM_WS_GeneralizedInputWrapper) System.JSON.deserialize(json, OSM_WS_GeneralizedInputWrapper.class);
    }
}