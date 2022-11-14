public class CG_WPR_SBL_GetInfoReqJSON {

    public Header Header;
    public DataArea DataArea;

    public class Sender {
        public String ServiceName;
        public String SenderID;
    }

    public class Target {
        public String TargetID;
    }

    public class DataArea {
        public string LastProcessedDate; //This is for SPInfo/TechInfo services
    }

    public class Header {
        public Sender Sender;
        public Target Target;
    }


    public static CG_WPR_SBL_GetInfoReqJSON parse(String json) {
        return (CG_WPR_SBL_GetInfoReqJSON) System.JSON.deserialize(json, CG_WPR_SBL_GetInfoReqJSON.class);
    }
}