public class OSM_GetOrder_WS_GeneralizedoutputWrapper
{
    public String errorMsg;
    public Boolean errorFlag;
    public OSM_Integration_Log__c log;
    
    public Header Header { get; set; }
    public ItemInfoList ItemInfoList { get; set; }
    public class Sender
    {
        public string ServiceName { get; set; }
        public string SenderID { get; set; }
    }

    public class Target
    {
        public string TargetID { get; set; }
    }

    public class Header
    {
        public Sender Sender { get; set; }
        public Target Target { get; set; }
    }

    public class LicenseInfo
    {
        public string LicenseName { get; set; }
        public string ActivationKey { get; set; }
    }

    public class ItemInfo
    {
        public string ItemId { get; set; }
        public LicenseInfo LicenseInfo { get; set; }
    }

    public class ItemInfoList
    {
        public List<ItemInfo> ItemInfo { get; set; }
    }
   
    public static OSM_GetOrderInfoRes parse(String json) {
        return (OSM_GetOrderInfoRes) System.JSON.deserialize(json, OSM_GetOrderInfoRes.class);
    }

}