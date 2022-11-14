global class CSS_getPartsListSRTResponseJ2A {
    
    public class DataArea {
        public String Notes;
        public Integer Qty;
        public String PartNumberMfg;
        public String OEM;
        public String PartSize;
        public String OptionNumber;
        public String FailureID;
        public String Assignment;
        public String PartNameService;
        public String FailureName;
        public String PartNumberService;
        
    }
    
    public class Header {
        public String MessageIdentifier;
        public String ReturnCode;
        public String ReturnCodeDescription;
        public String Status;
        public String MessageType;
    }
    
    public Header Header;
    public List<DataArea> DataArea;
    
    
    public static CSS_getPartsListSRTResponseJ2A parse(String json) {
        return (CSS_getPartsListSRTResponseJ2A) System.JSON.deserialize(json, CSS_getPartsListSRTResponseJ2A.class);
    }
}