public class LDAP_util {
    
  public String access_token;
  public String token_type;
  public String scope;
  public Integer expires_in;
  public string refresh_token;
  public String resource;
    public String error;
  public String error_description;
  public static CSS_J2AToken_SRT parse(String json) {
    return (CSS_J2AToken_SRT) System.JSON.deserialize(json, CSS_J2AToken_SRT.class);
  }
}