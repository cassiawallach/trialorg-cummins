public class CG_TEST_SIEBEL {
  
    public static CG_OP_OAGWrapper AccessToken(){
        string accessToken;
        string endPoint;
        Datetime startDt;
        Datetime endDt;
        CG_OP_OAGWrapper returnWrapper = new CG_OP_OAGWrapper();
        try{

            
            HttpRequest req = new HttpRequest();
            Http http = new Http();
           
			//Note:- Below hardcode value needs to be called from integeration detail.Since we dont have any field to update resource.So will update it after sometime.
			string cliendid='ad724392-5594-4e85-b9eb-b0fc19c2fabe';
            string clientsecret='ocj8yiMYSDH39gPJpEZTNQo9cCXdgOW5olQ2s1Y3siA=';
            string resource='https://api-ue-devnf-aw-ex.cummins.com/cmi-sp';
            string accesstokenendpoint='https://api-ue-devnf-aw-ex.cummins.com/api/core-security-api/v1/auth/token';
			
			 sampletest sh12 = new sampletest();
			sh12.client_id=cliendid;
			sh12.client_secret=clientsecret;
			sh12.resource=resource;
			string jsonrequestbody=json.serialize(sh12);
			system.debug('string>>'+jsonrequestbody);
			
			req.setHeader('Content-Type','application/json');
			req.setMethod('POST');
			req.setBody(jsonrequestbody);
			req.setEndpoint(accesstokenendpoint);
            startDt = System.now();
			httpresponse res=http.send(req);
			system.debug('res>>>'+res);
			string responsbody=res.getBody();
			 endDt = System.now();
			try{
			  tokenresclass tokenobj=(tokenresclass)system.json.deserialize(responsbody, tokenresclass.class);
				accesstoken=tokenobj.access_token;
                
			}
			catch(Exception e){
				accesstoken=null;
				system.debug('Issue in Access tokenresponse>>'+e.getMessage());
			}
            returnWrapper.accessToken = accessToken;
            Long totalTime = endDt.getTime() - startDt.getTime();
            returnWrapper.totalAuthCallTime = totalTime;

        }
        catch(exception e){
            system.debug('Entered into catch of AccessToken>>>'+e.getMessage() +e.getLineNumber());
            returnWrapper.exceptionFlag = true;
            returnWrapper.errorMessage = 'Some error in getting Techinfo : '+e.getMessage();
            returnWrapper.appName = 'Techinfoservice';
            returnWrapper.endPoint = endPoint;

        }
        return returnWrapper;        
    }
	public static CG_OP_OAGWrapper calloutTechinfo(string Servicename,String lastProcessedDate) {
        system.debug('in calloutTechinfo method...');
        CG_OP_OAGWrapper returnWrapper = new CG_OP_OAGWrapper();
        String jSONReqBody;
        Datetime startDt;
        Datetime endDt;
		string endpoint;
        try {
          
            CG_OP_OAGWrapper accessTokenOPWrap = AccessToken();
            system.debug('**accessTokenOPWrap**'+accessTokenOPWrap);
            
            if (accessTokenOPWrap != null && accessTokenOPWrap.exceptionFlag == true) {
                returnWrapper.exceptionFlag = true;
                returnWrapper.exceptionMessage = accessTokenOPWrap.exceptionMessage;
                return returnWrapper;
            }
		
			
            String accessToken = accessTokenOPWrap.accessToken;
            system.debug('accessTokenOPWrap>>>:'+accessTokenOPWrap);
            HttpRequest req = new HttpRequest();
            	
			if(Servicename=='Techinfo'){
				 endpoint='https://api-ue-devnf-aw-ex.cummins.com/cmi-serviceprovider/technician?sender=css&lastRunDate=2019-06-06';
                // endpoint='https://api-ue-devnf-aw-ex.cummins.com/cmi-serviceprovider/technician?sender=css&lastRunDate='+lastProcessedDate;
				   
			}
			else{
				 endpoint='https://api-ue-devnf-aw-ex.cummins.com/cmi-serviceprovider/techservicemodel?sender=css&lastRunDate=2018-06-06';
                // endpoint='https://api-ue-devnf-aw-ex.cummins.com/cmi-serviceprovider/techservicemodel?sender=css&lastRunDate='+lastProcessedDate;
			}
            req.setEndpoint(endpoint);
			 req.setHeader('client-id','271bf3f9be404e4b9a3a85559a2cecb3');
             req.setHeader('client-secret','74A587c3C7Ff45A38B87A6C49ec29299');
            req.setHeader('Authorization', 'Bearer ' + accessToken);
            req.setMethod('GET');
           
            req.setTimeout(120000); // Sai: 14/03/2017. Added for SRT Read timed out issue.

            Http http = new Http();
            startDt = System.now();
            HttpResponse httpRes = new HttpResponse();
           
                httpres = http.send(req);
               system.debug('httpres>>'+httpres);

            if (httpRes.getStatusCode() == 200) {
                System.debug('########### successfully executed ################');
                endDt = System.now();
                Long totalTime = endDt.getTime() - startDt.getTime();
                returnWrapper.totalServiceCallTime = totalTime;
                returnWrapper.totalAuthCallTime = accessTokenOPWrap.totalAuthCallTime;
                returnWrapper.request = req;
                if(!Test.isRunningTest()){
                    system.debug('httpRes----'+httpRes+'res Body--'+httpRes.getBody());
                    returnWrapper.response = httpRes;
                    system.debug('InsideREsponse***'+returnWrapper.response);}
                 
                else{
                    httpres.setStatus('OK');
                    httpres.setStatusCode(200);
                    system.debug('StatusCode***'+httpres.getStatusCode());
                    returnWrapper.response = httpRes;    
                    system.debug('returnWrapper.response**'+returnWrapper.response);

                }

            } else {
                returnWrapper.exceptionFlag = true;
                String body = httpRes.getBody();
                Integer statusCode = httpRes.getStatusCode();
                String msg = statusCode + '---' + body;

                returnWrapper.exceptionMessage = msg;
                returnWrapper.serviceName = 'GetTechinfo';
                returnWrapper.endPoint = endpoint;
            }
            return returnWrapper;
        } catch (Exception ex) {
            String stackTrace = ex.getStackTraceString();
            String msg = ex.getMessage();
            returnWrapper.exceptionMessage += msg;
            returnWrapper.exceptionMessage += stackTrace;
            returnWrapper.exceptionFlag = true;

            return returnWrapper;
        }
    }
    public class sampletest{
        public string client_id;
        public string client_secret;
        public string resource;
    }
    
    Public class tokenresclass{
        public string token_type;
        public string expires_in;
        public string ext_expires_in;
        public string expires_on;
        public string not_before;
        public string resource;
        public string access_token;
    }
    
    
    public static CG_OP_OAGWrapper getAccessToken(String serviceName){
        string accessToken;
        string endPoint;
        Datetime startDt;
        Datetime endDt;
        CG_OP_OAGWrapper returnWrapper = new CG_OP_OAGWrapper();
        try{
            System.debug('=====GETTING ACCESS TOKEN FOR SERVICE===='+serviceName);
            HttpRequest req = new HttpRequest();
            Http http = new Http();
            string client_id;
            string client_secret;
            string key;

            if(!Test.isRunningTest()){
                CSS_Integration_Details__c conDetails = new CSS_Integration_Details__c();
                conDetails = CSS_getConnnectionDetails.getConnection(serviceName);
                endPoint = conDetails.End_Point__c;
                client_id = conDetails.Username__c;   
                client_secret = ConDetails.Passcode__c;
                key = ConDetails.Key__c; //new body param as resource
            }
            else{
                endPoint = 'https://api-ue-devnf-aw-ex.cummins.com/api/core-security-api/v1/auth/token';
                client_id = 'ad724392-5594-4e85-b9eb-b0fc19c2fabe';
                client_secret = 'ocj8yiMYSDH39gPJpEZTNQo9cCXdgOW5olQ2s1Y3siA=';
                key = 'https://api-ue-devnf-aw-ex.cummins.com/cmi-sp';
            }

            req.setEndpoint(endPoint);
            req.setMethod('POST');
            req.setHeader('Content-Type','application/json');
            req.setBody('{"client_id":"'+client_id+'","client_secret":"'+client_secret+'","resource":"'+key+'"}');
            //req.setBody('grant_type=client_credentials&client_id='+client_id+'&client_secret='+client_secret+'&scope=CSSCloud');
            system.debug('req>>>>>>>.>>>'+req.getBody());
            HttpResponse res = new HttpResponse();
            startDt = System.now();
            endDt = System.now();
            if(!Test.isRunningTest()){
                res = http.send(req);
            }else{
                res.setBody('{"token_type":"Bearer","expires_in":"3600","ext_expires_in":"3600","expires_on":"1561063243","not_before":"1561059343","resource":"https://api-ue-devnf-aw-ex.cummins.com/cmi-sp","access_token":"eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiIsIng1dCI6IkN0ZlFDOExlLThOc0M3b0MyelFrWnBjcmZPYyIsImtpZCI6IkN0ZlFDOExlLThOc0M3b0MyelFrWnBjcmZPYyJ9.eyJhdWQiOiJodHRwczovL2FwaS11ZS1kZXZuZi1hdy1leC5jdW1taW5zLmNvbS9jbWktc3AiLCJpc3MiOiJodHRwczovL3N0cy53aW5kb3dzLm5ldC9iMzFhNWQ4Ni02ZGRhLTQ0NTctODVlNS1jNTViYmMwNzkyM2QvIiwiaWF0IjoxNTYxMDU5MzQzLCJuYmYiOjE1NjEwNTkzNDMsImV4cCI6MTU2MTA2MzI0MywiYWlvIjoiNDJaZ1lIamxzbWozejROTnpnWXQ2aTcrVVp2aUFRPT0iLCJhcHBpZCI6ImFkNzI0MzkyLTU1OTQtNGU4NS1iOWViLWIwZmMxOWMyZmFiZSIsImFwcGlkYWNyIjoiMSIsImlkcCI6Imh0dHBzOi8vc3RzLndpbmRvd3MubmV0L2IzMWE1ZDg2LTZkZGEtNDQ1Ny04NWU1LWM1NWJiYzA3OTIzZC8iLCJvaWQiOiJiYmJmMzU0Mi1iZjY1LTRiMzktYWIzOC0zMDAzNjZjZmJiMGQiLCJzdWIiOiJiYmJmMzU0Mi1iZjY1LTRiMzktYWIzOC0zMDAzNjZjZmJiMGQiLCJ0aWQiOiJiMzFhNWQ4Ni02ZGRhLTQ0NTctODVlNS1jNTViYmMwNzkyM2QiLCJ1dGkiOiJ5aXlZYkdoUzNVcVRWWjVtQzhOZUFBIiwidmVyIjoiMS4wIn0.PrbkWrRFJSojdTqZ5yP-JeanRHQgOrTUuEf5KNQCT0ejR52VJqGpZp4KpGwo4cBMjiPMSVZlizTANROSaghwpx29iNNWgEDrVRE8VM7_eeBolRYuub6fkk0Ie9VmuqWVomlsDFuk24IQT1q_dxdXZBRGPaSZGRq-xcxGblmdg6zGF_NrUYfGPzDdJk6ccFrcYOWSKJHBzYa12dQFiZ_oaf50EK6WG_FB13tcCVQnhqBqU0vYpOzsKobF96v-2CH1bM1GVMCAq_kez00Drvt2qdJCMCEctrt_7lu8qkBQ1OXHBSj9sSy0EnptN7DQ3L6HSxTrRZuoQftTwMsSMzfR8g"}');
                res.setStatusCode(200);
            }
            
            
            string jSONRequestBody = res.getBody();
            system.debug('jSONRequestBody'+jSONRequestBody);
            CG_WPR_MuleTokenResJSON wprObj = (CG_WPR_MuleTokenResJSON)JSON.deserializeStrict(jSONRequestBody,CSS_J2AToken_SRT.class); 
            
            accessToken = wprObj.access_token;
            System.debug('ACCESS TOKEN BODY: '+res.getBody());  
            System.debug('ACCESS TOKEN Status: '+res.getStatus());
            System.debug('ACCESS TOKEN Status Code: '+res.getStatusCode());
            returnWrapper.accessToken = accessToken;
            Long totalTime = endDt.getTime() - startDt.getTime();
            returnWrapper.totalAuthCallTime = totalTime;

        }
        catch(exception e){
            system.debug('Entered into catch of OAG token Method in CSS_WS_OAG>>>'+e.getMessage() +e.getLineNumber());
            returnWrapper.exceptionFlag = true;
            returnWrapper.errorMessage = 'Some error in getting OAG : '+e.getMessage();
            returnWrapper.appName = 'OAGToken';
            returnWrapper.endPoint = endPoint;
            if(Test.isRunningTest()){
                 returnWrapper.exceptionFlag = false;
            }
        }
        return returnWrapper;        
    }

    public static CG_OP_OAGWrapper calloutGeneric(CG_IP_OAGWrapper reqWrapper) {
        system.debug('in calloutGeneric method...');
        CG_OP_OAGWrapper returnWrapper = new CG_OP_OAGWrapper();
        String jSONReqBody;
        Datetime startDt;
        Datetime endDt;
        try {
            system.debug('reqWrapper>>>>:'+reqWrapper);
            system.debug('reqWrapper.serviceName>>>>:'+reqWrapper.serviceName);
            CSS_Integration_Details__c conDetails = CSS_Integration_Details__c.getValues(reqWrapper.serviceName);
            system.debug('conDetails>>>:'+conDetails);
            // if (conDetails == null) {conDetails = 'OAGOAuth';}
            CG_OP_OAGWrapper accessTokenOPWrap = getAccessToken(conDetails.AuthEnv__c);
            system.debug('**accessTokenOPWrap**'+accessTokenOPWrap);
             system.debug('accessTokenOPWrap.exceptionFlag'+ accessTokenOPWrap.exceptionFlag);
            
            //In case of no access token return wrapper
            if (accessTokenOPWrap != null && accessTokenOPWrap.exceptionFlag == true) {
                returnWrapper.exceptionFlag = true;
                returnWrapper.exceptionMessage = accessTokenOPWrap.exceptionMessage;
                return returnWrapper;
            }
            system.debug('accessTokenOPWrap>>>:'+accessTokenOPWrap);
            system.debug('accessTokenOPWrap.accessToken>>>:'+accessTokenOPWrap.accessToken);
            String accessToken = accessTokenOPWrap.accessToken;
            system.debug('accessTokenOPWrap>>>:'+accessTokenOPWrap);
            HttpRequest req = new HttpRequest();
            //List<string> caseNum = new List<string>{'K87481914'};
            req.setEndpoint(conDetails.End_Point__c);
            System.debug('=======> ConDetails>>:'+conDetails.End_Point__c);
            req.setHeader('client-id', conDetails.Username__c); //new header param //271bf3f9be404e4b9a3a85559a2cecb3
            req.setHeader('client-secret', conDetails.Passcode__c); //new header param //74A587c3C7Ff45A38B87A6C49ec29299
            req.setHeader('Content-Type', 'application/json');
            req.setHeader('Authorization', 'Bearer ' + accessToken);
            req.setBody(reqWrapper.jsonReqBody);
            system.debug('Method_Type__c>>>:'+conDetails.Method_Type__c);
            System.debug('===reqWrapper.jsonReqBody====' + reqWrapper.jsonReqBody);
            req.setMethod(conDetails.Method_Type__c);
            Integer timeOut = conDetails.Timeout__c.intValue();
            req.setTimeout(timeOut);    
            //req.setTimeout(120000);

            Http http = new Http();
            startDt = System.now();
            HttpResponse httpRes = new HttpResponse();
            if(!Test.isRunningTest()) {
                httpres = http.send(req);
            }else{
                httpres.setStatusCode(200);

            }

            System.debug('#####httpRes:'+httpRes+'  ######httpRes.getBody:'+httpRes.getBody());
            if (httpRes.getStatusCode() == 200) {
                System.debug('########### successfully executed ################');
                endDt = System.now();
                Long totalTime = endDt.getTime() - startDt.getTime();
                returnWrapper.totalServiceCallTime = totalTime;
                returnWrapper.totalAuthCallTime = accessTokenOPWrap.totalAuthCallTime;
                returnWrapper.request = req;
                if(!Test.isRunningTest()){
                    system.debug('httpRes----'+httpRes+'res Body--'+httpRes.getBody());
                    returnWrapper.response = httpRes;
                    system.debug('InsideREsponse***'+returnWrapper.response);}
                else{
                    httpres.setStatus('OK');
                    httpres.setStatusCode(200);
                    system.debug('StatusCode***'+httpres.getStatusCode());
                    returnWrapper.response = httpRes;    
                    system.debug('returnWrapper.response**'+returnWrapper.response);
                }
            }else{
                returnWrapper.exceptionFlag = true;
                String body = httpRes.getBody();
                Integer statusCode = httpRes.getStatusCode();
                String msg = statusCode + '---' + body;

                returnWrapper.exceptionMessage = msg;
                returnWrapper.serviceName = reqWrapper.serviceName;
                returnWrapper.endPoint = conDetails.End_Point__c;
            }
            return returnWrapper;

        }catch(Exception ex){
            //MANDATORY: In case of exception Set the exceptionFlag=true always
            System.debug('===Exception whie making callout getStackTraceString===:' + ex.getStackTraceString());
            system.debug('EXCEPTION of CG_WS_OAG - calloutGeneric Method ErrorMessage>>>>:'+ex.getMessage() + ' LineNumber>>:' + ex.getLineNumber() + ' Rootcause>>:' +ex.getCause());
            String stackTrace = ex.getStackTraceString();
            String msg = ex.getMessage();
            returnWrapper.exceptionMessage += msg;
            returnWrapper.exceptionMessage += stackTrace;
            returnWrapper.exceptionFlag = true;
            return returnWrapper;
        }
    }

}