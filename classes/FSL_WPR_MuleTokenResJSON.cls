public class FSL_WPR_MuleTokenResJSON {
    public String token_type;
    public String expires_in;
    public String ext_expires_in;
    public String expires_on;
    public String not_before;
    public String resource;
    public String access_token;
    
    
    public static FSL_WPR_MuleTokenResJSON parse(String json) {
        return (FSL_WPR_MuleTokenResJSON) System.JSON.deserialize(json, FSL_WPR_MuleTokenResJSON.class);
    }
}