public class CSS_getFailureCodesSRTResJ2A {
    public class DataArea {
        public String FailureID;
        public String FailureName;
        public String SystemCode;
        public String ComponentCode;
        public String FailureMode;
    }

    public class Header {
        public String MessageIdentifier;
        public String ReturnCode;
        public String ReturnCodeDescription;
        public String Status;
        public String MessageType;
    }

    public Header Header;
    public List<DataArea> DataArea;

    
    public static CSS_getFailureCodesSRTResJ2A parse(String json) {
        return (CSS_getFailureCodesSRTResJ2A) System.JSON.deserialize(json, CSS_getFailureCodesSRTResJ2A.class);
    }
}