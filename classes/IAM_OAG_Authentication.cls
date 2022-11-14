/* this class can be used as a common IAM class for Authentication against OAG by creating a record in CSS integration details
and getting those details here. Integration details are custom settings*/


Public Class IAM_OAG_Authentication{

//Below method will take name of the service and then will return respective authentication token.

    Public Static String getBearer(String serviceName){
    
        CSS_Integration_Details__c IAM = new CSS_Integration_Details__c();
        IAM = CSS_getConnnectionDetails.getConnection(serviceName);
        System.debug('Printing connection details'+IAM);
    
        httpRequest req=new httpRequest();
        httpResponse res;
        string accessToken;
        string error='';
        String body='grant_type=client_credentials&client_id='+IAM.Passcode__c+'&client_secret='+IAM.Key__c+'&scope=IAM';
        System.debug('Printing Body'+body);
        
       try{
        
        req.SetMethod('POST');  
        req.setEndpoint(IAM.End_Point__c);
        //Access Token & Refresh Token
        req.setBody(body);
        System.debug('httpRequest'+req.toString());
        req.setHeader('Content-Type','application/x-www-form-urlencoded');
       // System.debug('Printing request body'+req.getbody());
        //System.debug('***********req**********'+req);        
         res = new http().send(req);
        //System.debug(res.getBody());
        string jSONRequestBody= res.getBody();
        System.debug('response body in GL authentican'+res.getBody());
        CSS_J2AToken_SRT wo1 = (CSS_J2AToken_SRT)JSON.deserializeStrict(jSONRequestBody,CSS_J2AToken_SRT.class); 
         accessToken = wo1.access_token;
           
        return accessToken;
        }catch(exception e){
            System.debug('Printing error Message for OAG Access token'+e.getMessage());
            //Calling IDM error Handiling Class to insert the error into the error Object.
           // error=e.getMessage();
            //IAM_ErrorHandling.IAMerrorCapture(res.getbody(),'EDQ oAuth',e.getMessage());
            return null;
        
        } 
    }
}