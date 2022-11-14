global class CSS_SendJobInfoResWrapper {
    
        public class DataArea {
        public String CSSJobID;
    }

    public class Header {
        public String ServiceName;
        public String ServiceVersion;
        public String Status;
        public String ReturnCode;
        public String ReturnCodeDescription;
    }

    public Header Header;
    public DataArea DataArea;

    public static CSS_SendJobInfoResWrapper parse(String json) {
        return (CSS_SendJobInfoResWrapper) System.JSON.deserialize(json, CSS_SendJobInfoResWrapper.class);
    }
    
}