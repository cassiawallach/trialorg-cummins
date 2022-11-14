public class OSM_OMS_CreateOrderGeneral_IP_Wrapper
{
    public ID orderId {get;set;} 
	public String orderName {get;set;} 
    public String timestamp {get;set;} 
    public String toolName {get;set;} 
    public String requesterId {get;set;}
    public ID AccId {get;set;} // Added By Dhiraj 
 	public List<OrderItemDetails> orderItemDetailsList {get;set;} 
    
    public class OrderItemDetails
    {
        public String adminId {get;set;} 
        public String totalCopies {get;set;} 
        public String startDate {get;set;} 
        public String revalidationPeriod {get;set;} 
        public String numberOfRepairs {get;set;} 
        public String numberOfReinstalls {get;set;} 
        public String numberOfRehosts {get;set;} 
        public String licenseName {get;set;} 
        public String productName {get;set;} 
        public String productGroup {get;set;} 
        public String feature {get;set;} 
        public String featureGroup {get;set;} 
        public String duration {get;set;} 
        public String countsPerCopy {get;set;} 
        
        public OrderItemDetails()
        {
            adminId = '';
            totalCopies = '';
            startDate = '';
            revalidationPeriod = '';
            numberOfRepairs = '';
            numberOfReinstalls = '';
            numberOfRehosts = '';
            licenseName = '';
            productName = '';
            productGroup = '';
            feature = '';
            featureGroup = '';
            duration = '';
            countsPerCopy = '';
        }
    }
    
    public OSM_OMS_CreateOrderGeneral_IP_Wrapper()
    {
        orderName = '';
        timestamp = '';
        toolName = '';
        requesterId = ''; 
    }
        
}