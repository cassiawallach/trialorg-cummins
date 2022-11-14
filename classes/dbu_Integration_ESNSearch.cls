/** 
* @Class Name: dbu_Integration_ESNSearch    
* @Description      
- Constructor:  
* @Main Author: Saikomal Kattamudi    
* @Last Modified: 22/09/2020       
* @Open Points      /   
*/

public class dbu_Integration_ESNSearch {
    
    public static string getAccessToken(){
        
        HttpRequest req = new HttpRequest();
        
        Http http = new Http();
        
        string client_id;
        
        string client_secret;
        
        string resource;
        
        string methodType;
        
        string endPointURL;
        
        string accessToken;
        try{
            
            
            CSS_Integration_Details__c conDetails = CSS_Integration_Details__c.getValues('dbu_ESNSearch_AccessToken');
            system.debug('conDetails > ' + conDetails);
            endPointURL = conDetails.End_Point__c;
            
            
            client_id = conDetails.Key__c;
            
            client_secret = conDetails.Passcode__c  ;
            
            resource = conDetails.Resource__c;
            
            methodType =conDetails.Method_Type__c;
            system.debug('resource'+resource);
            
            req.setEndpoint(endPointURL);
            
            req.setMethod(methodType);
            
            req.setHeader('Content-Type','application/json');
            
            req.setBody('{"client_id":"'+client_id+'","client_secret":"'+client_secret+'","resource":"'+resource+'"}');
            system.debug('req > ' +req);
            HttpResponse res = new HttpResponse();
            if(!test.isRunningTest()){
                
                
                res = http.send(req);
                system.debug('res > ' +res);
                TokenResponse tokenResp = (TokenResponse)JSON.deserialize(res.getBody(), TokenResponse.class);
                system.debug('tokenResp > ' +tokenResp);
                
                accessToken = tokenResp.access_token;
                system.debug('accessToken > ' +accessToken);
            }
            else{
              
                //accessToken = 'eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiIsIng1dCI6Im5PbzNaRHJPRFhFSzFqS1doWHNsSFJfS1hFZyIsImtpZCI6Im5PbzNaRHJPRFhFSzFqS1doWHNsSFJfS1hFZyJ9.eyJhdWQiOiJodHRwczovL2FwaS11ZS1zdGduZi1hdy1leC5jdW1taW5zLmNvbS9wY2MvdjEvY2F0YWxvZ3MiLCJpc3MiOiJodHRwczovL3N0cy53aW5kb3dzLm5ldC9iMzFhNWQ4Ni02ZGRhLTQ0NTctODVlNS1jNTViYmMwNzkyM2QvIiwiaWF0IjoxNjExNzI1NDAwLCJuYmYiOjE2MTE3MjU0MDAsImV4cCI6MTYxMTcyOTMwMCwiYWlvIjoiRTJKZ1lIQlgrNjFUUFBuQk4zdFJWdVg1VytiOUFBQT0iLCJhcHBpZCI6IjEyMmMzMzRkLWE2YTktNGQ3Zi1iZmFlLTc4Yjc4OTAyYjA0ZCIsImFwcGlkYWNyIjoiMSIsImlkcCI6Imh0dHBzOi8vc3RzLndpbmRvd3MubmV0L2IzMWE1ZDg2LTZkZGEtNDQ1Ny04NWU1LWM1NWJiYzA3OTIzZC8iLCJvaWQiOiIyZDhmODg4ZC1iZjgzLTQyMzgtOTg4My04ZTQ5OGQ3M2FjMTMiLCJyaCI6IjAuQUFBQWhsMGFzOXB0VjBTRjVjVmJ2QWVTUFUwekxCS3BwbjlOdjY1NHQ0a0NzRTBPQUFBLiIsInN1YiI6IjJkOGY4ODhkLWJmODMtNDIzOC05ODgzLThlNDk4ZDczYWMxMyIsInRpZCI6ImIzMWE1ZDg2LTZkZGEtNDQ1Ny04NWU1LWM1NWJiYzA3OTIzZCIsInV0aSI6InlJNHBvdXVHdlUtdG1McUNrR1lBQUEiLCJ2ZXIiOiIxLjAifQ.kAi6qCeN74ukEAl8HiSxyDqvF5JWXwlCHXqk2SEClrrzPo0T-F1HIDr8AycoBUG7la5QBs0S_jXqmWWY9uVR-lkEJoSlp4erHC2-HULk1AR6uR_RXP_MxpuxwmSxl4y4QZoar5XpXhwNpWikBK-M6U1i02sbkB_oVNR0NoateoG0S4B3r8Gt_w6bc_14SLhzvgRdYDsKgTytF3Tavfm-HTOQZLYLWmBpPGB2uIMzEqnhN6vpdh4Z2mhXlnDomeidF9gcr6NTMIm1B9rix4qpw7TiHi36YWQEro9xEQzpY45-fxfrUOQfN8LFlG6jwT1roM3Z4KXbjD0wv5Ow8F86aA';
        string responsebody ='{"token_type": "Bearer","expires_in": "3599","ext_expires_in": "3599","expires_on": "1611729300","not_before": "1611725400","resource": "https://api-ue-stgnf-aw-ex.cummins.com/pcc/v1/catalogs","access_token":"eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiIsIng1dCI6Im5PbzNaRHJPRFhFSzFqS1doWHNsSFJfS1hFZyIsImtpZCI6Im5PbzNaRHJPRFhFSzFqS1doWHNsSFJfS1hFZyJ9.eyJhdWQiOiJodHRwczovL2FwaS11ZS1zdGduZi1hdy1leC5jdW1taW5zLmNvbS9wY2MvdjEvY2F0YWxvZ3MiLCJpc3MiOiJodHRwczovL3N0cy53aW5kb3dzLm5ldC9iMzFhNWQ4Ni02ZGRhLTQ0NTctODVlNS1jNTViYmMwNzkyM2QvIiwiaWF0IjoxNjExNzI1NDAwLCJuYmYiOjE2MTE3MjU0MDAsImV4cCI6MTYxMTcyOTMwMCwiYWlvIjoiRTJKZ1lIQlgrNjFUUFBuQk4zdFJWdVg1VytiOUFBQT0iLCJhcHBpZCI6IjEyMmMzMzRkLWE2YTktNGQ3Zi1iZmFlLTc4Yjc4OTAyYjA0ZCIsImFwcGlkYWNyIjoiMSIsImlkcCI6Imh0dHBzOi8vc3RzLndpbmRvd3MubmV0L2IzMWE1ZDg2LTZkZGEtNDQ1Ny04NWU1LWM1NWJiYzA3OTIzZC8iLCJvaWQiOiIyZDhmODg4ZC1iZjgzLTQyMzgtOTg4My04ZTQ5OGQ3M2FjMTMiLCJyaCI6IjAuQUFBQWhsMGFzOXB0VjBTRjVjVmJ2QWVTUFUwekxCS3BwbjlOdjY1NHQ0a0NzRTBPQUFBLiIsInN1YiI6IjJkOGY4ODhkLWJmODMtNDIzOC05ODgzLThlNDk4ZDczYWMxMyIsInRpZCI6ImIzMWE1ZDg2LTZkZGEtNDQ1Ny04NWU1LWM1NWJiYzA3OTIzZCIsInV0aSI6InlJNHBvdXVHdlUtdG1McUNrR1lBQUEiLCJ2ZXIiOiIxLjAifQ.kAi6qCeN74ukEAl8HiSxyDqvF5JWXwlCHXqk2SEClrrzPo0T-F1HIDr8AycoBUG7la5QBs0S_jXqmWWY9uVR-lkEJoSlp4erHC2-HULk1AR6uR_RXP_MxpuxwmSxl4y4QZoar5XpXhwNpWikBK-M6U1i02sbkB_oVNR0NoateoG0S4B3r8Gt_w6bc_14SLhzvgRdYDsKgTytF3Tavfm-HTOQZLYLWmBpPGB2uIMzEqnhN6vpdh4Z2mhXlnDomeidF9gcr6NTMIm1B9rix4qpw7TiHi36YWQEro9xEQzpY45-fxfrUOQfN8LFlG6jwT1roM3Z4KXbjD0wv5Ow8F86aA"}';
                TokenResponse tokenResp = (TokenResponse)JSON.deserialize(responsebody, TokenResponse.class);
            }
            system.debug('accessToken '+accessToken);
            
        }
        
        catch(exception e){
            
            system.debug('Exception Message'+e.getMessage()+''+'Exception line Number '+e.getLineNumber());
            
        }
        
        return accessToken;
        
    }
    
    public static dbu_EsnSearchResponseWrapper getEsnResult(string esn){
        
        string accessToken;
        dbu_EsnSearchResponseWrapper lstParsed = new dbu_EsnSearchResponseWrapper();
        HttpRequest req = new HttpRequest();
        Map<String, Object> mapData = new Map<String, Object>();
        Http http = new Http();
        string client_id;
        string client_secret;
        string resource;
        string methodType;
        string endPointURL;
       // HttpResponse res = new HttpResponse();
        String responseBody; 
        String Status;
        Integer StatusCode;
        string mSec;
        try{
            
            CSS_Integration_Details__c conDetails = CSS_Integration_Details__c.getValues('dbu_ESNSearchCallout');
             system.debug('conDetails > ' +conDetails);
            methodType = conDetails.Method_Type__c;
            accessToken = getAccessToken();
            system.debug('accessToken > ' +accessToken);
            endPointURL =conDetails.End_Point__c+esn;
            system.debug('endPointURL > ' +endPointURL);
            req.setHeader('Authorization','Bearer '+accessToken);
            req.setMethod(methodType);
            req.setTimeout(120000);
            req.setEndpoint(endPointURL);
            system.debug('req > ' +req);
            if(!test.isRunningTest()){
                HttpResponse res = new HttpResponse();
                Long reqTime = DateTime.now().getTime();
                system.debug('reqTime > ' +reqTime);
                res = http.send(req);
                system.debug('res > ' +res);
                Long respTime = DateTime.now().getTime();
                system.debug('respTime > ' +respTime);
                system.debug('resfrom esn service'+res.getStatusCode());
                long milliSeconds = respTime-reqTime ;
                system.debug('milliSeconds > ' +milliSeconds);
                mSec='***TIME::' +string.ValueOf(milliSeconds)+ ':: TIME***';
                system.debug('mSec > ' +mSec);
                if(res.getStatusCode() == 200)
                {
                    responseBody = res.getBody(); //Access Response body
                    system.debug('responseBody > ' +responseBody);
                    string correctedJsonStr = responseBody.replace('Number','Number_Z');
                    system.debug('correctedJsonStr > ' +correctedJsonStr);
                    lstParsed = (dbu_EsnSearchResponseWrapper)json.deserialize(correctedJsonStr, dbu_EsnSearchResponseWrapper.class); //deserialize the reponse
                    system.debug('lstParsed > ' +lstParsed);
                    dbu_Integration_Error_Log.createErrorLog(res.getStatusCode(),mSec,esn,'','ESN Service',res.getStatus());
                }
                else
                {
                    responseBody = res.getBody();                    
                    system.debug('responseBody 2 >> '+responseBody);
                    Status = res.getStatus();
                    system.debug('Status > ' +Status);
                    StatusCode = res.getStatusCode();
                    system.debug('StatusCode > ' +StatusCode);
                   dbu_Integration_Error_Log.createErrorLog(res.getStatusCode(),mSec,esn,'','ESN Service',res.getStatus());
                } 
            }
            else{
                responseBody='{"Header":{"MessageIdentifier":"2-a0c8c090-02fb-11eb-b9e9-121d5554e1ea", "ReturnCode":"PARTLIST001","ReturnCodeDescription":"PartLists Retrieved successfully","Status":"SUCCESS","MessageType":"S"},"DataArea":{"PartLists":[{"ESN":"79464646","Parts":[{"Number":"3687580","Description":"Studded Flange Cap Screw","Systems":["DRIVES AND MOUNTINGS"]},{"Number":"3171713","Description":"Hexagon Flange Head Cap Screw","Systems":["DRIVES AND MOUNTINGS"]}]}]}}';
                string correctedJsonStr = responseBody.replace('Number','Number_Z');
                lstParsed = (dbu_EsnSearchResponseWrapper)json.deserialize(correctedJsonStr, dbu_EsnSearchResponseWrapper.class); //deserialize the reponse
            }
            
            
            
        }
        catch(exception e){
            dbu_Integration_Error_Log.createErrorLog(null,mSec+e.getMessage(),esn,'','ESN Service','Exception');
            system.debug('Exception Message'+e.getMessage()+''+'Exception line Number '+e.getLineNumber());
        }
        return lstParsed ;
    }

    public class TokenResponse {
        
        public String token_type;
        
        public String expires_in;
        
        public String ext_expires_in;
        
        public String expires_on;
        
        public String not_before;
        
        public String resource;
        
        public String access_token;
        
    }
    
    public static void test(){
         string acc;
         string var;
         string acc3;
        string acc4;
        string acc5;
        string acc7;
        string acc8;
        string acc9;
        string acc10; 
        string acc11; 
        string acc12; 
        string acc13; 
        string acc14; 
        string acc15; 
        string acc16; 
    }
    
    
}