/*Copyright © 2018  Cummins
=============================================================
=============================================================
Purpose:                                                            
This is test class for IAM_HighRadius_Parser class. 
Parsing response  for HighRadius.                         
=============================================================
=============================================================
History                                                            
-------                                                            
VERSION  AUTHOR                   DATE              DETAIL                                
1.0 -    Nishant Verma          10/10/2020       INITIAL DEVELOPMENT       
*****************************************************/
/********************************************************************************
***********************************************************************************/
public class IAM_HighRadius_Parser {
    
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
    /* parse response body of disable_user, revoke_token and Update_user_attributes API to String */
    public static Response_BMSInstance getResponse_BMSInstance(String responseBody) {
        Response_BMSInstance response = 
            (Response_BMSInstance)JSON.deserializeStrict(responseBody, Response_BMSInstance.class); 
        return response; 
    }
    
    
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
    public class Response_BMSInstance {
        public String instance;
        public String Status;
        public String Message;
        Public string MessageIdentifier;
        Public string ReturnCode;
        Public string ReturnCodeDescription;
        Public string MessageType;
        Public string EHFFlag;
		public string erpCustomerCode;
    }
    private class Request_AuthBody {
        String client_id;
        String client_secret;
        String resource;
    }
	public class BMSresponseToSF{
		public String BMSinstance;
		public string erpCustomerCode;
	}
}