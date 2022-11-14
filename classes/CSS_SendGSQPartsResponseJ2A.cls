public class CSS_SendGSQPartsResponseJ2A {

    public class Header {
        public String Status;
        public String ReturnCodeDescription;
        public Location Location;
    }

    public Header Header;

    public class Location {
        public String LocationID;
    }

    
    public static CSS_SendGSQPartsResponseJ2A parse(String json) {
        return (CSS_SendGSQPartsResponseJ2A) System.JSON.deserialize(json, CSS_SendGSQPartsResponseJ2A.class);
    }
}