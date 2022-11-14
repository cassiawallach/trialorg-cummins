public class FSL_CL_PMRecommendationsResponseWrapper{
    public Header Header;
    public DataArea DataArea;
    
    public class Header {
        public String Status;
        public String ReturnCodeDescription;
        
        public Location Location;
    }
    
    public class Location {
        public String LocationID;
    }    
    
    public class DataArea {
        public Recommendation Recommendations;
    }
    public class Recommendation {
        public String RecommendationId;
        public String WorkOrderNumber;
        public String QuoteId;
        public String Status;
        public String ReturnCodeDescription;
    }
}