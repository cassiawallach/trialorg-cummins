public class CG_ReqPDFInbound_Req {

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
        public String CustomerPO;
        public String Action;
        public String SecurityCode;
        public String InvoiceUser;
    }

    public Header Header;
    public DataArea DataArea;

    public class Header {
        public Target Target;
        public Sender Sender;
        public Location Location;
    }

    public class Location {
        public String LocationID;
    }


    public static CG_ReqPDFInbound_Req parse(String json) {
        return (CG_ReqPDFInbound_Req) System.JSON.deserialize(json, CG_ReqPDFInbound_Req.class);
    }
}