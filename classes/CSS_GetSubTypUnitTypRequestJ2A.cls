public class CSS_GetSubTypUnitTypRequestJ2A {

    public class Sender {
        public String ServiceName;
        public String SenderID;
    }

    public class Target {
        public String TargetID;
    }

    public class Header {
        public Sender Sender;
        public Target Target;
        public Location Location;
    }

    public Header Header;

    public class Location {
        public String LocationID;
    }

    
    public static CSS_GetSubTypUnitTypRequestJ2A parse(String json) {
        return (CSS_GetSubTypUnitTypRequestJ2A) System.JSON.deserialize(json, CSS_GetSubTypUnitTypRequestJ2A.class);
    }
}