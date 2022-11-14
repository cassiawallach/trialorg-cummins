public class CSS_GetSubTypUnitTypResJ2A {

    public class Sender {
        public String ServiceName;
        public String MessageID;
        public String SenderID;
    }

    public class Target {
        public String TargetID;
    }

    public class DataArea {
        public String CodeValue;
        public String CodeDescription;
        public String Code;
    }

    public class Header {
        public String Status;
        public Sender Sender;
        public Target Target;
        public Location Location;
    }

    public List<DataArea> DataArea;
    public Header Header;

    public class Location {
        public String LocationID;
    }

    
    public static CSS_GetSubTypUnitTypResJ2A parse(String json) {
        return (CSS_GetSubTypUnitTypResJ2A) System.JSON.deserialize(json, CSS_GetSubTypUnitTypResJ2A.class);
    }
}