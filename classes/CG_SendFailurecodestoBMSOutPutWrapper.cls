public class CG_SendFailurecodestoBMSOutPutWrapper {
    public class Sender {
        public String ServiceName;
        public String SenderID;
    }
    public class Target {
        public String TargetID;
    }
    public class Location {
        public String LocationID;
    }
    public Header Header;
    public class Header {
        public String ReturnCodeDescription;
        public String status;
        public Sender Sender;
        public Target Target;
        public Location Location;
    }
    public static CG_SendFailurecodestoBMSOutPutWrapper parse(String json) {
        return (CG_SendFailurecodestoBMSOutPutWrapper) System.JSON.deserialize(json,CG_SendFailurecodestoBMSOutPutWrapper.class);
    }
}