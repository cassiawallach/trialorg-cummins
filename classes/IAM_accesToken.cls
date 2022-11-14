/*
Apex class to deserialize JSON response from the OAG oAuth class to get the acess token.
This is for IAM purpose.
*/

public class IAM_accesToken {
    
  public String access_token;
  public String token_type;
  public Integer expires_in;
  public String refresh_token;
  public String scope;
  
  public static IAM_accesToken parse(String json) {
    return (IAM_accesToken) System.JSON.deserialize(json, IAM_accesToken.class);
  }
}