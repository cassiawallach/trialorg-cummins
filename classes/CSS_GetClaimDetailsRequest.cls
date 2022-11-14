public class CSS_GetClaimDetailsRequest {

    public class Sender {
        public String ServiceName;
        public String SenderID;
    }

    public class Target {
        public String TargetID;
    }

    public class DataArea {
        public String SiebelClaimNumber;
    }

    public class Header {
        public Target Target;
        public Sender Sender;
    }

    public Header Header;
    public DataArea DataArea;


    public static CSS_GetClaimDetailsRequest parse(String json) {
        return (CSS_GetClaimDetailsRequest) System.JSON.deserialize(json, CSS_GetClaimDetailsRequest.class);
    }
}