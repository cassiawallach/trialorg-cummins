public class CG_J2AQsolToken {

	public String apiToken;
	public String ResponseCode;

	
	public static CG_J2AQsolToken parse(String json) {
		return (CG_J2AQsolToken) System.JSON.deserialize(json, CG_J2AQsolToken.class);
	}
}