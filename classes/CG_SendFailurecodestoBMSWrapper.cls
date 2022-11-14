public class CG_SendFailurecodestoBMSWrapper {
    
    public class Sender {
        public String ServiceName;
        public String SenderID;
    }
    
    public class Target {
        public String TargetID;
    }
    
    public class DataArea {
        public String CSSJobID;
        public String DistributorCode;
        public String BranchCode;
        public String CustomerCode;
        public String OrderType;
        public String BMSReferenceNumber;
        public List<FailuresList> FailuresList;
    }
    
    public Header Header;
    public DataArea DataArea;
    
    public class Header {
        public Sender Sender;
        public Target Target;
        public Location Location;
    }
    
    public class FailuresList {
        public String ProductGroup;
        public String GroupNo;
        public String SystemCode;
        public String ComponentCode;
        public String FailureMode;
        public String FailLocation;
        //public String FailureOrder;
        public String ClaimType;
        public String CreateUser;
        public String ChangeUser;
    }
    
    public class Location {
        public String LocationID;
    }
    
    
    public static CG_SendFailurecodestoBMSWrapper parse(String json) {
        return (CG_SendFailurecodestoBMSWrapper) System.JSON.deserialize(json, CG_SendFailurecodestoBMSWrapper.class);
    }
}