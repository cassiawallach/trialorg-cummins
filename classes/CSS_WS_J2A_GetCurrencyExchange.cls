public class CSS_WS_J2A_GetCurrencyExchange {

    public class DataArea {
        public String ConversionRate;
    }

    public class Header {
        public String Status;
        public String ReturnCodeDescription;
    }

    public Header Header;
    public DataArea DataArea;

    
    public static CSS_WS_J2A_GetCurrencyExchange parse(String json) {
        return (CSS_WS_J2A_GetCurrencyExchange) System.JSON.deserialize(json, CSS_WS_J2A_GetCurrencyExchange.class);
    }
}