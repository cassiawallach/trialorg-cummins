public class CSS_WS_J2A_GetCSSAmount {

    public class DataArea {
        public String Status;
        public String ErrorMessage;
    }

    public class Header {
        public String Status;
        public String ReturnCodeDescription;
    }

    public Header Header;
    public DataArea DataArea;

    
    public static CSS_WS_J2A_GetCSSAmount parse(String json) {
        return (CSS_WS_J2A_GetCSSAmount) System.JSON.deserialize(json, CSS_WS_J2A_GetCSSAmount.class);
    }
}