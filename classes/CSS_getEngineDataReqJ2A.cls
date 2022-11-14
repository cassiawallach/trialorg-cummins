public class CSS_getEngineDataReqJ2A {

    public class Sender {
        public String ServiceName;
        public String SenderID;
    }

    public class Target {
        public String TargetID;
    }

    public class DataArea {
        public String ESN;
    }

    public class Header {
        public Sender Sender;
        public Target Target;
    }

    public Header Header;
    public DataArea DataArea;

    
    public static CSS_getEngineDataReqJ2A  parse(String json) {
        return (CSS_getEngineDataReqJ2A ) System.JSON.deserialize(json, CSS_getEngineDataReqJ2A.class);
    }
}