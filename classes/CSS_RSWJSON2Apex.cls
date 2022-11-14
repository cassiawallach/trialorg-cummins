public class CSS_RSWJSON2Apex 
{
    public class ControlNumbers {
        public List<String> ControlNumber;
    }

    public class CSSJobIdRecord {
        public String CSSJobId;
        public ControlNumbers ControlNumbers;
    }

    public class DataArea {
        public CSSJobIdRecords CSSJobIdRecords;
    }

    public class CSSJobIdRecords {
        public List<CSSJobIdRecord> CSSJobIdRecord;
    }

    public DataArea DataArea;

    public class ControlNumbers_Z {
        public String ControlNumber;
    }

    
    public static CSS_RSWJSON2Apex parse(String json) {
        return (CSS_RSWJSON2Apex) System.JSON.deserialize(json, CSS_RSWJSON2Apex.class);
    }

}