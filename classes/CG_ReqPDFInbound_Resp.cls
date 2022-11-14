public class CG_ReqPDFInbound_Resp {

    public class Sender {
        public String ServiceName;
        public String MessageID;
        public String SenderID;
    }

    public class Target {
        public String TargetID;
    }

    public Header Header;

    public class Header {
        public String ReturnCodeDescription;
        public String Status;
        public Sender Sender;
        public Target Target;
        public Location Location;
    }

    public class Location {
        public String LocationID;
    }


    public static CG_ReqPDFInbound_Resp parse(String json) {
        return (CG_ReqPDFInbound_Resp) System.JSON.deserialize(json, CG_ReqPDFInbound_Resp.class);
    }
}