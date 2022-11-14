public class CSS_getAllSRTResponseJ2A {

    public List<DataArea> DataArea;
    public Header Header;
    //Below Error fields are not from SRT webservice
    public String errorCode;
    public String errorDescription;

    public class DataArea {
        public String SRTType;
        public String SRTNumber;
        public String SRTTitle;
        public Double BTime;
        public Double RTime;
        public String SRTCategory;
        public Integer StepID;
        public Double ATime;
        public Double CTime;
        public Double DTime;
        public String SRTFamily; //added as part of story 128678
        public String ComponentType; //added as part of story 128678
        public String ECMFlag;
        public String PrivateFlag;
        public String Regions;
        public String FlexSRT;
        
    }
    public class Header {
        public String ReturnCodeDescription;
        public String ReturnCode;
        public String MessageIdentifier;
    }

    public static CSS_getAllSRTResponseJ2A parse(String json) {
        return (CSS_getAllSRTResponseJ2A) System.JSON.deserialize(json, CSS_getAllSRTResponseJ2A.class);
    }


}