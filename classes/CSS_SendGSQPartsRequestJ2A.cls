public class CSS_SendGSQPartsRequestJ2A {

    public class Sender {
        public String ServiceName;
        public String SenderID;
    }

    public class PartDetails {
        public String ProductCodeOEM;
        public String PartNumberService;
        public Integer Quantity;
    }

    public class Target {
        public String TargetID;
    }

    public class DataArea {
        public String CSSJobId;
        public String DistributorCode;
        public String DistributorBranchCode;
        public String OrderType;
        public String BMSQuoteID;
        public List<PartDetails> PartDetails;
    }

    public class Header {
        public Sender Sender;
        public Target Target;
        public Location Location;
    }

    public Header Header;
    public DataArea DataArea;

    public class Location {
        public String LocationID;
    }

    
    public static CSS_SendGSQPartsRequestJ2A parse(String json) {
        return (CSS_SendGSQPartsRequestJ2A) System.JSON.deserialize(json, CSS_SendGSQPartsRequestJ2A.class);
    }
}