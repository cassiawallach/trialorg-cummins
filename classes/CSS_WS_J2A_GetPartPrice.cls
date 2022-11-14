public class CSS_WS_J2A_GetPartPrice {

    public class DataArea {
        public String PartPrice;
    }

    public class Header {
        public String Status;
        public String ReturnCodeDescription;
    }

    public DataArea DataArea;
    public Header Header;

    
    public static CSS_WS_J2A_GetPartPrice parse(String json) {
        return (CSS_WS_J2A_GetPartPrice) System.JSON.deserialize(json, CSS_WS_J2A_GetPartPrice.class);
    }
}