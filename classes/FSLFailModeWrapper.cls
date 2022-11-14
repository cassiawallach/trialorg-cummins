public class FSLFailModeWrapper {
    
    public Header Header;
    public DataArea DataArea;
    
    
    public class Header {
        public String MessageIdentifier;
        public String ReturnCode;
        public String ReturnCodeDescription;
        public String Status;
    }
    
    public class DataArea {
        public list<Details> Details;
    }
    
    public class Details {
        public String TargetID; //SIEBEL
        public string Description; 
        public string BusinessUnit;
        public string FailModeCode;
        public string Active;
    }
    
    public static FSLFailModeWrapper parse(String json) {
        return (FSLFailModeWrapper) System.JSON.deserialize(json, FSLFailModeWrapper.class);
    }
}