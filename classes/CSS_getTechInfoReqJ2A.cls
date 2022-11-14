public class CSS_getTechInfoReqJ2A {

    public class Sender {
        public String ServiceName;
        public String SenderID;
    }

    public class Target {
        public String TargetID;
    }

    public class DataArea {
        public List<GetTechInfoInput> GetTechInfoInput;        
    }
    public class GetTechInfoInput{
        public String SPCode;
        public List<QualProgIDs> QualProgIDs;
    }
    public class Header {
        public Sender Sender;
        public Target Target;
    }

    public Header Header;
    public DataArea DataArea;

    public class QualProgIDs {
        public String QualProgId;
    }	
    
    public static CSS_getTechInfoReqJ2A  parse(String json) {
        return (CSS_getTechInfoReqJ2A) System.JSON.deserialize(json, CSS_getTechInfoReqJ2A.class);
    }
}