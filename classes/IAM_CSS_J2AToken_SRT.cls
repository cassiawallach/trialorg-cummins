public class IAM_CSS_J2AToken_SRT {
    
  public String access_token;
  public String token_type;
  public Integer ext_expires_in;
  public Integer expires_in;
  public Integer expires_on;
  public String not_before;
  public String resource;
    public String error;
  public String error_description;
  public static IAM_CSS_J2AToken_SRT parse(String json) {
    return (IAM_CSS_J2AToken_SRT) System.JSON.deserialize(json, IAM_CSS_J2AToken_SRT.class);
  }
}