public class IAM_EDQ_accessToken{
    public String access_token; 
    public String token_type;   
    public Integer expires_in;  
    public String refresh_token;    
    public String scope;    
    public static IAM_EDQ_accessToken parse(String json){
        return (IAM_EDQ_accessToken) System.JSON.deserialize(json, IAM_EDQ_accessToken.class);
    }
}