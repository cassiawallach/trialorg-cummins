public class CSS_WS_J2A_ClaimReliability {

    public String messageIdentifier;
    public String returnCode;
    public String returnCodeDescription;
    public String status;
    public String message;
    
    public static CSS_WS_J2A_ClaimReliability parse(String json) {
        return (CSS_WS_J2A_ClaimReliability) System.JSON.deserialize(json, CSS_WS_J2A_ClaimReliability.class);
    }
    
}