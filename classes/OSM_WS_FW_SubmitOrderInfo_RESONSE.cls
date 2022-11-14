public class OSM_WS_FW_SubmitOrderInfo_RESONSE {
    public Header header;

    public class Header {
        public String status;
        public Sender sender;
        public Target target;
        public String returnCodeDescription;
    }
    
    public class Sender {
        public String messageID;
        public String serviceName;
        public String senderId;
    }

    public class Target {
        public String targetId;
    }
    
    public static OSM_WS_FW_SubmitOrderInfo_RESONSE parse(String json) {
        return (OSM_WS_FW_SubmitOrderInfo_RESONSE) System.JSON.deserialize(json, OSM_WS_FW_SubmitOrderInfo_RESONSE.class);
    }
}