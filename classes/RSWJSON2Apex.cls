public class RSWJSON2Apex 
{

    public class ControlNumbers 
    {
        public List<String> ControlNumber;
    }

    public class CSSJobIdRecord 
    {
        public String CSSJobId;
        public ControlNumbers ControlNumbers;
    }

    public class DataArea 
    {
        public CSSJobIdRecords CSSJobIdRecords;
    }

    public class CSSJobIdRecords 
    {
        public List<CSSJobIdRecord> CSSJobIdRecord;
    }

    public DataArea DataArea;

    public static RSWJSON2Apex parse(String json) 
    {
        return (RSWJSON2Apex) System.JSON.deserialize(json, RSWJSON2Apex.class);
    }
}