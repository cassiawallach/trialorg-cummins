public class CSS_J2AToken_SRT {
    
	public String access_token;
	public String token_type;
	public Integer expires_in;
	public String refresh_token;
	public String scope;
  
	public static CSS_J2AToken_SRT parse(String json) {
		return (CSS_J2AToken_SRT) System.JSON.deserialize(json, CSS_J2AToken_SRT.class);
	}
}