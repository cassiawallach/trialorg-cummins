/* this class can be used as a common IAM class for Authentication against OAG by creating a record in CSS integration details
and getting those details here. Integration details are custom settings*/


public with sharing class IAM_CST_Authentication{

//Below method will take name of the service and then will return respective authentication token.

    Public Static String getBearer(String serviceName){
    
        CSS_Integration_Details__c IAM = new CSS_Integration_Details__c();
        IAM = CSS_getConnnectionDetails.getConnection(serviceName);
        System.debug('Printing connection details'+IAM);
    
        httpRequest req=new httpRequest();
        httpResponse res;
        string accessToken;
        String body=System.Label.IAM_CST_Authentication_Body;
        //String body='grant_type=client_credentials&client_id=c13116b1-6c87-464e-8aba-96aef814cd29&client_secret=lZ2cL5x4mvQGBnM0p6XfR32If5NARyuv3G%2Fp88IN%2BuA%3D&resource=https://guidanzu-stg.cummins.com/ServiceTraining/public/WS/sfim/';
        
        System.debug('Printing Body'+body);
        
       try{
        
        req.SetMethod('POST');  
        req.setEndpoint('https://login.microsoftonline.com/b31a5d86-6dda-4457-85e5-c55bbc07923d/oauth2/token');
        //Access Token & Refresh Token
        req.setBody(body);
        System.debug('httpRequest'+req.toString());
        System.debug('httpRequest'+req);
        req.setHeader('Content-Type','application/x-www-form-urlencoded');
        System.debug('Printing request body'+req.getbody());
        System.debug('***********req**********'+req);       
         res = new http().send(req);
        System.debug(res.getBody());
        string jSONRequestBody= res.getBody();
        IAM_CSS_J2AToken_SRT  wo1 = (IAM_CSS_J2AToken_SRT)JSON.deserializeStrict(jSONRequestBody,IAM_CSS_J2AToken_SRT.class); 
         accessToken = wo1.access_token;
           
        return accessToken;
        }catch(exception e){
            System.debug('Printing error Message for CST Access token'+e.getMessage());
            //Calling IDM error Handiling Class to insert the error into the error Object.
           // error=e.getMessage();
            //IAM_ErrorHandling.IAMerrorCapture(res.getbody(),'EDQ oAuth',e.getMessage());
            return null;
        
        } 
    }
}