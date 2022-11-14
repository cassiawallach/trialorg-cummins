public class FSL_CL_PMRecommendationsWrapper{
    public Header Header;
    public DataArea DataArea;
    public class Header {
        public Sender Sender;
        public Target Target;   
        public Location Location;
        
    }
    public class Sender {
        public String ServiceName;
        public String SenderID;
        public Sender(String ServiceName, String SenderID){
            this.ServiceName = ServiceName;
            this.SenderID = SenderID;
        }
    }
    public class Target {
        public String TargetID;
        public Target(String TargetID){
            this.TargetID = TargetID;
        }
    }
    public class Location {
        public String LocationID;
        public Location(String LocationID){
            this.LocationID = LocationID;
        }
    }
    public class DataArea {
        public Recommendation Recommendations;
    }
    public class Recommendation {
        public String RecommendationId;
        public String WorkOrderNumber;
        public String ShopWorkOrder;
        public String CustomerCode;
        public String OrderType;
        public String SubType;
        public String RepairInformation;
        public String PartsInformation;
        public String EstimatedRepairTime;
        public String NumberOfTechnicians;
        public String TravelTime;
    }
     
    
}