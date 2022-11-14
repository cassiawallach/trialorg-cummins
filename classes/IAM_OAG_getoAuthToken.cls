/*
This class can be used as a common IAM class for Authentication against OAG by creating a record in CSS integration details
and getting those details here. Integration details are custom settings
*/


Public Class IAM_OAG_getoAuthToken{

//Below method will take name of the service and then will return respective authentication token.

    Public Static String getAccessToken(String serviceName){
    
        CSS_Integration_Details__c IAM = new CSS_Integration_Details__c();
        IAM = IAM_getConnnectionDetails.getConnection(serviceName);
        System.debug('Printing connection details'+IAM);
    
        httpRequest req=new httpRequest();
        httpResponse res;
        string accessToken;
        String body='';
        string error='';
        if(!Test.isRunningTest()){
            body='grant_type='+IAM.grant_type__c+'&client_id='+IAM.Passcode__c+'&client_secret='+IAM.Key__c+'&scope='+IAM.Logging__c;
        }else{
            body='grant_type='+'client_credentials'+'&client_id='+'83ae698b-370c-4940-851b-1b6b0de06466'+'&client_secret='+'41a194c6-c900-485e-85c7-249cbaca191f'+'&scope='+'GLIAM';
        }
        System.debug('Printing Body'+body);
        
       try{
        
        req.SetMethod(IAM.Method_Type__c);  
        req.setEndpoint(IAM.End_Point__c);
        //Access Token & Refresh Token
        req.setBody(body);
        System.debug('httpRequest'+req.toString());
        req.setHeader('Content-Type','application/x-www-form-urlencoded'); 
        req.setTimeout(12000);        
        res = new http().send(req);
        if(res.getStatusCode()==200){
            string jSONRequestBody= res.getBody();
            System.debug('response body in authentication Part'+res.getBody());
            IAM_accesToken wo1 = (IAM_accesToken)JSON.deserializeStrict(jSONRequestBody,IAM_accesToken.class); 
            accessToken = wo1.access_token;   
            return accessToken;
        }else{
            
           System.debug('Printing status of the response'+res.getBody()); 
           return accessToken;
        
        }
        }catch(exception e){
            System.debug('Printing error Message for OAG Access token'+e.getMessage());
            if(e.getMessage()!='Read timed out'){
                If(!test.isRunningTest())
            IAM_ErrorHandling.IAMerrorCapture(res.getbody(),'EDQ Address cleanse Future Method',e.getMessage());
                   }else{
                       IAM_ErrorHandling.IAMerrorCapture('Error from OAG oAuth token class','EDQ Address cleanse Future Method',e.getMessage());
                   }
            return null;
        
        } 
    }
}