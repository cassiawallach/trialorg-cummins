public class OSM_GetOrderInfoReq
{
    public Header Header { get; set; }
    public GetOrderInfoInput GetOrderInfoInput { get; set; }
    
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

    public class GetOrderInfoInput
    {
        public string ToolName { get; set; }
        public string OMSOrderID { get; set; }
    }
    
}