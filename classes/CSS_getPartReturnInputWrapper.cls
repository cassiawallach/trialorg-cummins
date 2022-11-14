//
// Generated by JSON2Apex http://json2apex.herokuapp.com/
// Kalpana:Story#105223
//

public class CSS_getPartReturnInputWrapper {

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
        public String PSN;
        public String DISTICHANNEL;
        public String FAILDATE;
        public List<PARTS> PARTS;
    }

    public class Header {
        public Sender Sender;
        public Target Target;
    }

    public class PARTS {
        public String PARTNUMBER;
        public String PRODUCTFAMILY;
        public String TERRITORYCLASS;
        public String ACCOUNTCODE;
        public String FAILCODE;
    }

    public static CSS_getPartReturnInputWrapper parse(String json) {
        return (CSS_getPartReturnInputWrapper) System.JSON.deserialize(json, CSS_getPartReturnInputWrapper.class);
    }
}