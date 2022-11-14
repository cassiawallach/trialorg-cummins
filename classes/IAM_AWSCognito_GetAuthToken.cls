/* This class is used to get authentication token from AWS Cognito Auth Service */
public class IAM_AWSCognito_GetAuthToken {
    
    /* Return access token */
    public static String getAccessToken(String serviceName){
        HttpResponse res;
        String accessToken;        
        String body;
        try {
            /* Get auth service (Integration) details */
            CSS_Integration_Details__c serviceDetails = new CSS_Integration_Details__c();
            serviceDetails = IAM_AWSCognito_ConnectionDetails.getConnection(serviceName);
            System.debug('#### connection details '+serviceDetails);
            
            if(!Test.isRunningTest()) {            
                body = IAM_AWSCognito_Parser.getAuthRequest(serviceDetails.Passcode__c, serviceDetails.Key__c, serviceDetails.Resource__c);
            } else {
                body = IAM_AWSCognito_Parser.getAuthRequest('ad724392-5594-4e85-b9eb-b0fc19c2fabe',
                       'ocj8yiMYSDH39gPJpEZTNQo9cCXdgOW5olQ2s1Y3siA=', 'https://api-ue-devnf3-aw-in.cummins.com/cmi-iam');
            }
            System.debug('#### request body' +body);
            HttpRequest req = new httpRequest();
            req.SetMethod(serviceDetails.Method_Type__c);  
            req.setEndpoint(serviceDetails.End_Point__c);
            req.setBody(body);        
            req.setHeader('Content-Type','application/json'); 
            req.setTimeout(12000);
            System.debug('#### httpRequest '+req.toString());
            /* Send Request */
            res = new http().send(req);
            System.debug('### response body - '+res.getBody());
            if(res.getStatusCode() == 200){
                string responseBody= res.getBody();
                System.debug('### response body - '+res.getBody());
                accessToken = IAM_AWSCognito_Parser.getAuthResponse(responseBody);
            }
            System.debug('### accessToken - '+accessToken);
            return accessToken;
        } catch(Exception e) {
            System.debug('#### Exception - '+e.getMessage());            
            IAM_ErrorHandling.IAMerrorCapture(
                'IAM_AWSCognito Error', 'IAM_AWSCognito_GetAuthToken getAccessToken method', e.getMessage());            
            return null;        
        } 
    }
}