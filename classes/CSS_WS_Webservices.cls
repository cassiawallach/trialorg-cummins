Public Class CSS_WS_Webservices{
    
    Private HttpRequest req;
    
    Public CSS_WS_Webservices(String endPoint){
        this.req = new HttpRequest();
        this.setEndpoint(endPoint);
        this.req.setTimeout(60*1000);//30 Secs Timeout
    }
    
    Private String getToken(String AuthEnv){
        return CSS_WS_OAuth.getToken(AuthEnv);
    }
    
    Private Void setEndpoint(String endPoint){
        if(!Test.isRunningTest()){
            CSS_Integration_Details__c recIntDetails = new CSS_Integration_Details__c();
            recIntDetails = CSS_WS_OAuth.getConnection(endPoint);
            if(recIntDetails.Method_Type__c == 'POST'){
                this.req.setEndpoint(recIntDetails.End_Point__c);
            }
        } else {
            req.setEndpoint('https://mxwrntydev-cumminscss.cs59.force.com/services/apexrest/mock_webservice/' + endPoint);
        }
    }
    
    Public Void setRequestData(String jsonData, String endPoint){
        String AuthEnv;
        String client_id;
        String client_secret;
        String method_type;
        String end_point;
        String token;
        String final_end_point;
        CSS_Integration_Details__c recIntDetails = new CSS_Integration_Details__c();
        recIntDetails = CSS_WS_OAuth.getConnection(endPoint);
        system.debug(recIntDetails);
        AuthEnv = recIntDetails.AuthEnv__c;
        client_id = recIntDetails.Username__c;   
        client_secret = recIntDetails.Passcode__c;
        method_type = recIntDetails.Method_Type__c;
        end_point = recIntDetails.End_Point__c;
        token = getToken(AuthEnv);
        //system.debug(token);
        this.req.setHeader('Content-Type','application/json');
        this.req.setHeader('Authorization', 'Bearer '+ token);
        this.req.setHeader('client-id',client_id);
        this.req.setHeader('client-secret',client_secret);
        if(endPoint == 'MxClaimRel'){
            this.req.setHeader('x-sender-id','SF Mexico');
            this.req.setHeader('x-target-id','Reliability');
        }
        this.req.setMethod(method_type);        
        if(method_type == 'POST'){//POST Method Type
            System.debug('WS JSON Request: '+ jsonData );
            this.req.setBody(jsonData);
        } else if(method_type == 'GET'){//GET Method Type
            final_end_point = end_point + jsonData;
            final_end_point = final_end_point.replace(' ', '%20') ;
            System.debug('WS JSON Request: '+ final_end_point);
            if(!Test.isRunningTest()){
                this.req.setEndpoint(final_end_point);
            }else{
                this.req.setEndpoint('https://mxwrntydev-cumminscss.cs59.force.com/services/apexrest/mock_webservice/'  + endPoint);
            }
        }
        system.debug(this.req);
    }
    
    Public String makeRequest(){
        Http http = new Http();
        HTTPResponse res = http.send(this.req);
        return res.getBody();
    }
    
}