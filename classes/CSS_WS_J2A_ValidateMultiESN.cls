public class CSS_WS_J2A_ValidateMultiESN {

    public class DataArea {
        public List<Details> Details;
    }

    public class Header {
        public String Status;
        public String ReturnCodeDescription;
    }

    public Header Header;
    public DataArea DataArea;

    public class Details {
        public String Esn;
        public String ValidationFlag;
        public String WarrantyStartDate;
    }
    
    public static CSS_WS_J2A_ValidateMultiESN parse(String json) {
        return (CSS_WS_J2A_ValidateMultiESN) System.JSON.deserialize(json, CSS_WS_J2A_ValidateMultiESN.class);
    }
}