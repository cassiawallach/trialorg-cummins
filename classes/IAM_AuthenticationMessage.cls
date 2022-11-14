public class IAM_AuthenticationMessage {

    public Data data;

    public class Data {
        public Integer SuccessCode;
        public String SuccessStatus;
    }

    
    public static IAM_AuthenticationMessage parse(String json) {
        return (IAM_AuthenticationMessage) System.JSON.deserialize(json, IAM_AuthenticationMessage.class);
    }
}