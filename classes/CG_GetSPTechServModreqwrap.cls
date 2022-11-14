public class CG_GetSPTechServModreqwrap{

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

    
    public static CG_GetSPTechServModreqwrap  parse(String json) {
        return (CG_GetSPTechServModreqwrap) System.JSON.deserialize(json, CG_GetSPTechServModreqwrap.class);
    }
}