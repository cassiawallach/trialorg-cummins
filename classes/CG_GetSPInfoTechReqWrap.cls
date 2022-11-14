public class CG_GetSPInfoTechReqWrap {

    public class Sender {
        public String ServiceName;
        public String SenderID;
    }

    public class Target {
        public String TargetID;
    }

    public class DataArea {
        public Date LAST_PROCESSED_DATE;
    }

    public class Header {
        public Sender Sender;
        public Target Target;
    }

    public Header Header;
    public DataArea DataArea;

    
    public static CG_GetSPInfoTechReqWrap  parse(String json) {
        return (CG_GetSPInfoTechReqWrap) System.JSON.deserialize(json, CG_GetSPInfoTechReqWrap.class);
    }
}