//This is wrapper class for outgoing cancelled subscription variables for OSM
public class OSM_SW_OrderSubscriptionWrapper{
        public string osm_orderId;
        public string osm_subscriptionID;
        public Integer osm_quantity; //This is to be cancel quantity
        public string osm_productId;
        public Date osm_CancelDate;
    	public String osm_invoiceId;
        public OSM_Order_Subscription__c osm_orderSubs;
}