Public Class IAM_RSW_Authentication{

//Below method will take name of the CDH service and then will return respective authentication token.

    Public Static String getBearer(){
    
        System.debug('getBearer for RSW');
    
        httpRequest req = new httpRequest();
        httpResponse res;
        string accessToken;
        string error = '';
        String body = System.Label.IAM_RSW_ClientID_Secret;
        System.debug('Printing getBearer Body'+body);
        
       try{        
        req.SetMethod('POST');  
        req.setEndpoint(System.Label.IAM_OAG_OAuth_URL+'/iam');
        
        //Access Token & Refresh Token
        req.setBody(body);
        System.debug('httpRequest'+req.toString());
        System.debug('httpRequest'+req);
        req.setHeader('Content-Type','application/x-www-form-urlencoded');
        res = new http().send(req);
        System.debug(res.getBody());
        string jSONRequestBody= res.getBody();
        LDAP_util wo1 = (LDAP_util)JSON.deserializeStrict(jSONRequestBody,LDAP_util.class); 
         accessToken = wo1.access_token;
         System.debug('Printing access Token '+accessToken );
           
        return accessToken;
        }catch(exception e){
            System.debug('Printing error Message for RSW Access token'+e.getMessage());
            return null;
        
        } 
    }
}