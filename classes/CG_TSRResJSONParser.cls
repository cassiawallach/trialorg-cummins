public class CG_TSRResJSONParser {
    
    public Header Header;
    public DataArea DataArea;
    
    public class DataArea{
        public String ActivityDescription;
        public String ErrorMessage;
        public String ActivityOwner;
        public String ActivityID;
        public String TSRNumber;
        public String ActivityType;
        public String ActivitySubject;
        public String ErrorCode;
        public String CSSJobID;
    }
    
    public class Header{
        public String ReturnCodeDescription;
        public String Status;
        public String ReturnCode;
        public String MessageIdentifier;
    }
    
    public static CG_TSRResJSONParser parse(String json) {
        return (CG_TSRResJSONParser) System.JSON.deserialize(json, CG_TSRResJSONParser.class);
    }

}