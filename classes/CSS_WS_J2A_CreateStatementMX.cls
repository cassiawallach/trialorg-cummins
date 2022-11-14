public class CSS_WS_J2A_CreateStatementMX {

    public class DataArea {
        public String MsgTransaction;
        public String MsgDescription;
    }

    public class Header {
        public String Status;
        public String ReturnCodeDescription;
    }

    public Header Header;
    public DataArea DataArea;

    
    public static CSS_WS_J2A_CreateStatementMX parse(String json) {
        return (CSS_WS_J2A_CreateStatementMX) System.JSON.deserialize(json, CSS_WS_J2A_CreateStatementMX.class);
    }
}