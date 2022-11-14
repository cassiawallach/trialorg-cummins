public class CSS_WPR_SBL_CatComplaintsListResJSON {

    public class Details {
        public String ComplaintCode;
        public String Description;
        public String BusinessUnit;
        public String ActiveFlag;
        public String Category;
    }

    public class DataArea {
        public List<Details> Details;
    }

    /*public class JSON2Apex {
        public DataArea DataArea;
        public Header Header;
    }*/

    public class Header {
        public String ReturnCodeDescription;
        public String Status;
    }
    
    public Header Header;
    public DataArea DataArea;
    
    public static CSS_WPR_SBL_CatComplaintsListResJSON parse(String json) {
        return (CSS_WPR_SBL_CatComplaintsListResJSON) System.JSON.deserialize(json, CSS_WPR_SBL_CatComplaintsListResJSON.class);
    }
}