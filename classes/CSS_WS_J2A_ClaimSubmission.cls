public class CSS_WS_J2A_ClaimSubmission {

    public class DataArea {
        public String ClaimNumber;
        public String Status;
        public String ErrorMessage;
    }

    public class Header {
        public String Status;
        public String ReturnCodeDescription;
    }

    public Header Header;
    public DataArea DataArea;

    
    public static CSS_WS_J2A_ClaimSubmission parse(String json) {
        return (CSS_WS_J2A_ClaimSubmission) System.JSON.deserialize(json, CSS_WS_J2A_ClaimSubmission.class);
    }
}