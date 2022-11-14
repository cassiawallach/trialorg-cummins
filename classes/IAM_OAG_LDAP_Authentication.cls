Public class IAM_OAG_LDAP_Authentication{

       public static string getToken(){
       
        httpRequest req=new httpRequest();
        httpResponse res;
        string accessToken;
        string error='';
       try{
        
        req.SetMethod('POST');  
        req.setEndpoint(label.IAM_LDAP_Util_Authentication_URL);//Need to replace end point with LDAP Util Authentication
        //Access Token & Refresh Token
        req.setBody(label.IAM_LDAP_Util_Authentication_Body);//Need to replace body with required parameters
        System.debug('httpRequest'+req.toString());
        req.setHeader('Content-Type','application/x-www-form-urlencoded');
        System.debug('Printing request body'+req.getbody());
        System.debug('***********req**********'+req);        
         res = new http().send(req);
        System.debug(res.getBody());
        string jSONRequestBody= res.getBody();
        LDAP_util wo1 = (LDAP_util )JSON.deserializeStrict(jSONRequestBody,LDAP_util.class); 
         accessToken = wo1.access_token;
           
        return accessToken;
        }catch(exception e){
            System.debug('Printing error Message for OAG Access token'+e.getMessage());
            //Calling IDM error Handiling Class to insert the error into the error Object.
            error=e.getMessage();
            IAM_ErrorHandling.IAMerrorCapture(res.getbody(),'EDQ oAuth',e.getMessage());
            return null;
            }    
        }

}