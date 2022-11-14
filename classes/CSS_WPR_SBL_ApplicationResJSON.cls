public class CSS_WPR_SBL_ApplicationResJSON {

    public class Details {
        public String ApplicationCode;
        public String Description;
        public String BusinessUnit;
        public String AutomotiveFlag;
        public String MarineFlag;
        public String ActiveFlag;
        public String DefaultUom;
    }

    public class DataArea {
        public List<Details> Details;
    }

    /*public class CSS_WPR_SBL_ApplicationResJSON {
        public DataArea DataArea;
        public Header Header;
    }*/

    public class Header {
        public String ReturnCodeDescription;
        public String Status;
    }

    
    public Header Header;
    public DataArea DataArea;
    
    public static CSS_WPR_SBL_ApplicationResJSON parse(String json) {
        return (CSS_WPR_SBL_ApplicationResJSON) System.JSON.deserialize(json, CSS_WPR_SBL_ApplicationResJSON.class);
    }
}