Public Class CSS_WS_OAuth{

    Public Static String getToken(String AuthEnv){
        String accessToken;
        String endPoint;
        HttpResponse res;
        try{
            HttpRequest req = new HttpRequest();
            Http http = new Http();
            String client_id;
            String client_secret;
            String resource;
            String jsonRequest;
            CSS_Integration_Details__c conDetails = new CSS_Integration_Details__c();
            if(!Test.isRunningTest()){
                conDetails = getConnection(AuthEnv); //value of "AuthEnv" field from "CSS_Integration_Details__c" custom setting. It provides the resource for getting correct credentials
                endPoint = conDetails.End_Point__c;
                client_id = conDetails.Username__c;   
                client_secret = ConDetails.Passcode__c;
                resource = ConDetails.key__c;                
            } else {
                endPoint = 'https://api-ue-devnf-aw-ex.cummins.com/api/core-security-api/v1/auth/MxAuthEngi';
                client_id = '400529c8-31be-4749-acfe-7549baa2fcb2';
                client_secret = '~6_5~e.~8D19I0Sw7YSNtq2kiAgK5bA.w3';
                resource = 'https://api-ue-devnf-aw-ex.cummins.com/cmi-engine';
            }
            req.setEndpoint(endPoint);
            req.setMethod('POST');
            req.setHeader('Content-Type','application/json');
            jsonRequest = '{' +
                '   \"client_id\": \"' + client_id + '\",' +
                '   \"client_secret\": \"' + client_secret + '\",' +
                '   \"resource\": \"' + resource + '\"' +
                ' }';
            
            req.setBody(jsonRequest);
            res = http.send(req);
            String jSONRequestBody = res.getBody();
            CSS_WS_J2A_AuthToken wo1 = (CSS_WS_J2A_AuthToken)JSON.deserialize(jSONRequestBody, CSS_WS_J2A_AuthToken.Class);
            accessToken = wo1.access_token;
        } catch(exception e){
            if(!Test.isRunningTest()){
                css_utility.LogOutIntError(endPoint,e.getMessage()+'- OAG Token', res.getBody(), 'WS_OA');
            }
        }
        return accessToken;
    }
    
    public static CSS_Integration_Details__c getConnection(string appName){
        Blob key = Blob.valueOf('12345678901234567890123456789012');
        System.debug('The key is'+key);
        string algo = 'AES256';
        CSS_Integration_Details__c inteDetails = new CSS_Integration_Details__c(); 
        List<CSS_Integration_Details__c> conDetails = new List<CSS_Integration_Details__c>([select Name,ApplicationName__c,End_Point__c,IsActive__c,
                                                                                            Key__c, Passcode__c, Username__c, Method_Type__c, AuthEnv__c 
                                                                                            from CSS_Integration_Details__c where ApplicationName__c=:appName AND IsActive__c = true limit 1]);
        inteDetails.Name = conDetails[0].Name;
        inteDetails.ApplicationName__c = conDetails[0].ApplicationName__c;
        inteDetails.End_Point__c = conDetails[0].End_Point__c;
        inteDetails.IsActive__c = conDetails[0].IsActive__c;
        inteDetails.Method_Type__c = conDetails[0].Method_Type__c;
        inteDetails.AuthEnv__c = conDetails[0].AuthEnv__c;
        inteDetails.Key__c = Crypto.decryptWithManagedIV(algo, key, EncodingUtil.base64Decode(conDetails[0].Key__c)).toString();
        inteDetails.Passcode__c = Crypto.decryptWithManagedIV(algo, key, EncodingUtil.base64Decode(conDetails[0].Passcode__c)).toString();
        inteDetails.Username__c = Crypto.decryptWithManagedIV(algo, key, EncodingUtil.base64Decode(conDetails[0].Username__c)).toString();
        return inteDetails;
    }
}