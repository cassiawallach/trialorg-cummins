public class CSS_getFailureCodesSRTReqJ2A {
    public class Sender {
        public String ServiceName;
        public String SenderID;
    }

    public class Target {
        public String TargetID;
    }

    public class DataArea {
        public String ServiceModelName;
        public String Languagecode;
        public String EngineFamilyCode;
    }

    public class Header {
        public Sender Sender;
        public Target Target;
    }

    public Header Header;
    public DataArea DataArea;

    
    public static CSS_getFailureCodesSRTReqJ2A parse(String json) {
        return (CSS_getFailureCodesSRTReqJ2A) System.JSON.deserialize(json, CSS_getFailureCodesSRTReqJ2A.class);
    }
}