public class FSL_TextNotificationRespJSON {
    public CustCommunicationResp[] CustCommunicationResp;
    public class CustCommunicationResp {
        Public String MessageIdentifier;
        public String ReturnCode;
        public String ReturnCodeDescription;
        public String Status;
        public String MessageType;
    }
    
    public static FSL_TextNotificationRespJSON  parse(String json){
        return (FSL_TextNotificationRespJSON) System.JSON.deserialize(json, FSL_TextNotificationRespJSON.class);
    }
    
}