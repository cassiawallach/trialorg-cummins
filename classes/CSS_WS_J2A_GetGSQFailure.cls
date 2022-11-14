public class CSS_WS_J2A_GetGSQFailure {

    public class DataArea {
        public String FailureName;
        public String SystemCode;
        public String ComponentCode;
        public String FailureID;
        public String FailureMode;
    }

    public class Header {
        public String ReturnCode;
        public String ReturnCodeDescription;
        public String MessageIdentifier;
        public String Status;
        public String MessageType;
    }

    public List<DataArea> DataArea;
    public Header Header;
    
    public static CSS_WS_J2A_GetGSQFailure parse(String json) {
        return (CSS_WS_J2A_GetGSQFailure) System.JSON.deserialize(json, CSS_WS_J2A_GetGSQFailure.class);
    }
    
}