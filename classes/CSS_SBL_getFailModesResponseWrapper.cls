public class CSS_SBL_getFailModesResponseWrapper{

    public Header Header;
    public DataArea DataArea;

    public class Header{
        public String MessageIdentifier{get;set;}
        public String ReturnCode{get;set;}
        public String ReturnCodeDescription{get;set;}
        public String Status{get;set;}
        public String MessageType {get;set;} // Added for Mule Integration
    }

    public class DataArea{
        public list<Details> Details {get;set;} 
    }     


   public class Details {
        public String Active;
        public String Description; 
        public String LastUpdated; 
        public String Created;
        public String BusinessUnit; 
        public String FailModeCode; 
    }

    public static CSS_SBL_getFailModesResponseWrapper parse(String json) {
        return (CSS_SBL_getFailModesResponseWrapper) System.JSON.deserialize(json, CSS_SBL_getFailModesResponseWrapper.class);
    }
}