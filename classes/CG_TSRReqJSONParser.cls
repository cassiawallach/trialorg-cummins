public class CG_TSRReqJSONParser {
    
    public Header Header;
    public DataArea DataArea;
    
    public class Header {
        public Sender Sender;
        public Target Target;
    }
    
    public class Sender {
        public String ServiceName;
        public String SenderID;
    }
    
    public class Target {
        public String TargetID;
    }
    
    public class DataArea {
        public String SRNumber;
        public String SupportLevel;
        public String PSN;
        public String GeneralSymptoms;
        public String Status;
        public String TechID;
        public String ContactEmail;
        public String ContactLastName;
        public String ContactFirstName;
        public String ContactPhoneNumber;
        public String SPCode;
        public String CustomerName;
        public String CSSJobID;
        public String ShopWO;
        public String RepeatVisit;
        public String FailureDate; //Should it be DAteTime?
        public String UOM;
        public String MileageValue;
        public String ComplaintCode;
        public list<string> FaultCode;
        public String AttachmentURL;
        public String EscalationText;
        public list<string> FaultCodeStatus;
        public String Symptom;
        public String EscalationGroup;
        
    }
    
    public static CG_TSRReqJSONParser parse(String json) {
        return (CG_TSRReqJSONParser) System.JSON.deserialize(json, CG_TSRReqJSONParser.class);
    }
}