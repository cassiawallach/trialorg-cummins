public class CSS_WS_J2A_GetPartReturn {

    public class DataArea {
        public String LOCATION;
        public String MESSAGE;
        public String ATTENTION;
        public String RETURNMESSAGE;
        public String EPRFLAG;
        public String PARTNUMBER;
        public String COMPANY;
    }

    public class Header {
        public String Status;
        public String ReturnCodeDescription;
    }

    public List<DataArea> DataArea;
    public Header Header;

    
    public static CSS_WS_J2A_GetPartReturn parse(String json) {
        return (CSS_WS_J2A_GetPartReturn) System.JSON.deserialize(json, CSS_WS_J2A_GetPartReturn.class);
    }
}