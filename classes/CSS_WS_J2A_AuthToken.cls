public class CSS_WS_J2A_AuthToken {

    public String token_type;
    public String expires_in;
    public String ext_expires_in;
    public String expires_on;
    public String not_before;
    public String resource;
    public String access_token;

    
    public static CSS_WS_J2A_AuthToken parse(String json) {
        return (CSS_WS_J2A_AuthToken) System.JSON.deserialize(json, CSS_WS_J2A_AuthToken.class);
    }
}