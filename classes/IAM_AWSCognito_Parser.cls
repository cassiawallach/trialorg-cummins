/* This class is used to parse AWS Cognito API requests and response 
** Those APIs are Authentication, Disable_User, Revoke_Token, Update_User_Attributes*/
public class IAM_AWSCognito_Parser {
    
    /* Create request body to get access token */
    public static String getAuthRequest(String clientId, String secret, String resource) {
        Request_AuthBody authBody = new Request_AuthBody();
        authBody.client_id = clientId;
        authBody.client_secret = secret;
        authBody.resource = resource;
        return JSON.serialize(authBody);
    }
    
    /* Parse access token response body to String */
    public static String getAuthResponse(String responseBody) {
        Response_AccesToken accToken = 
            (Response_AccesToken)JSON.deserializeStrict(responseBody, Response_AccesToken.class); 
        return accToken.access_token; 
    }
    
    /* Create request body for Disable_user API */
    public static String getDisableUserRequestBody(String apiName, String userId, String sourceSystem, String Idp) {
        Request_DisableOrRevokeUser body = new Request_DisableOrRevokeUser(apiName, userId, sourceSystem, Idp);
        return JSON.serialize(body);
    }
    
    /* Create request body for Revoke_Token API */
    public static String getRevokeUserRequestBody(String apiName, String userId, String sourceSystem, String Idp) {
        Request_DisableOrRevokeUser body = new Request_DisableOrRevokeUser(apiName, userId, sourceSystem, Idp);
        return JSON.serialize(body);
    }
    
    /* Create request body for Update_user_attributes API */
    public static String getUpdateUserRequestBody(String apiName, String userId, Map<String, String> attributes, 
    String sourceSystem, String Idp) {
        List<UserAttributes> UserAttributes = new List<UserAttributes>();
        UserAttributes attribute;
        if(!attributes.isEmpty()) {
            for(String key : attributes.keySet()) {
                attribute = new UserAttributes();
                attribute.Name = key;
                attribute.Value = attributes.get(key);
                UserAttributes.add(attribute);
            }            
        }
        Request_UpdateUserAttributes body 
            = new Request_UpdateUserAttributes(apiName, userId, UserAttributes, sourceSystem, Idp);
        return JSON.serialize(body);
    }
    
    /* parse response body of disable_user, revoke_token and Update_user_attributes API to String */
    public static Response_UserAction getResponse_UserAction(String responseBody) {
        Response_UserAction response = 
            (Response_UserAction)JSON.deserializeStrict(responseBody, Response_UserAction.class); 
        return response; 
    }
    
    private class Request_AuthBody {
        String client_id;
        String client_secret;
        String resource;
    }
    
    private class Request_DisableOrRevokeUser {
        public Header Header;
        public Data Data;
        public Request_DisableOrRevokeUser(String apiName, String userId, String sourceSystem, String Idp) {
            Header = new Header(apiName, sourceSystem);
            Data = new Data(userId, Idp);
        }
    } 
    
    private class Request_UpdateUserAttributes {
        public Header Header;
        public DataUserAttributes Data;
        public Request_UpdateUserAttributes(String apiName, String userId, List<UserAttributes> attributes, String sourceSystem, String Idp) {
            Header = new Header(apiName, sourceSystem);
            Data = new DataUserAttributes(userId, Idp, attributes);
        }
    }
    
    private class Header {
        public String api_name; 
        public String source_system;
        public Header(String apiName, String sourceSystem) {
            api_name = apiName;
            source_system = sourceSystem;
        }
    }
    
    private class Data {
        public String UserId;
        public String Idp;
        public Data(String UID, String IdpObj) {
            UserId = UID;
            Idp = IdpObj;
        }
    }
    
    private class DataUserAttributes {
        public List<UserAttributes> UserAttributes;
        public String UserId;
        public String Idp;
        public DataUserAttributes(String UID, String IdpObj, List<UserAttributes> attributes) {
            UserAttributes = attributes;
            UserId = UID;
            Idp = IdpObj;
        }
    }
    
    private class UserAttributes {
        public String Name;
        public String Value;
    }
    
    /* Parse access token response in below wrapper */
    public class Response_AccesToken {    
        public String access_token;
        public String token_type;
        public Integer expires_in;
        public String ext_expires_in;
        public Integer expires_on;
        public Integer not_before;
        public String resource;
    }
    
    /* Parse disable_user, revoke_token and Update_user_attributes API response in below wrapper */
    public class Response_UserAction {
        public String MessageIdentifier;
        public String ReturnCode;
        public String ReturnCodeDescription;
        public String Status;
        public String Message;
    }
}