public class CG_WPR_MuleTokenResJSON {

	public String token_type;
	public String expires_in;
	public String ext_expires_in;
	public String expires_on;
	public String not_before;
	public String resource;
	public String access_token;

	
	public static CG_WPR_MuleTokenResJSON parse(String json) {
		return (CG_WPR_MuleTokenResJSON) System.JSON.deserialize(json, CG_WPR_MuleTokenResJSON.class);
	}
}