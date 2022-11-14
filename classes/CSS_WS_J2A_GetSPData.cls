public class CSS_WS_J2A_GetSPData {

    public class DataArea {
        public String Region;
        public String Territory;
        public String ChannelOfDistribution;
        public String ChannelCode;
        public String FieldServiceLaborRate;
        public String InShopLaborRate;
        public String TravelRate;
        public List<Details> Details;
    }

    public class Header {
        public String Status;
        public String ReturnCodeDescription;
    }

    public Header Header;
    public DataArea DataArea;

    public class Details {
        public String PromotionID;
        public String FirstName;
        public String LastName;
    }

    
    public static CSS_WS_J2A_GetSPData parse(String json) {
        return (CSS_WS_J2A_GetSPData) System.JSON.deserialize(json, CSS_WS_J2A_GetSPData.class);
    }
}