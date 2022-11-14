public class CSS_WS_J2A_GetFailCodes {

    public class Details {
        public String Active;
        public String BusinesUnit;
        public String ServiceGroupCode;
        public String UpdatedDate;
        public String SystemCode;
        public String ComponentCode;
        public String FailureName;
        public String SystemName;
        public String ComponentName;
        public String Created;
    }

    public class DataArea {
        public List<Details> Details;
    }

    public class Header {
        public String Status;
        public String ReturnCode;
        public String ReturnCodeDescription;
        public String MessageIdentifier;
    }

    public DataArea DataArea;
    public Header Header;

    
    public static CSS_WS_J2A_GetFailCodes parse(String json) {
        return (CSS_WS_J2A_GetFailCodes) System.JSON.deserialize(json, CSS_WS_J2A_GetFailCodes.class);
    }
}