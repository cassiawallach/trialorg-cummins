global class  CSS_RSWClaimInfo_Mock implements HttpCalloutMock{
    
      global HTTPResponse respond(HTTPRequest req)  
        {
                   
            HttpResponse res;
        
            if((req.getEndpoint()).contains('https://services-dev-oauth.cummins.com/api/oauth/token/css')){
            //Create a fake response
            res = new HttpResponse();
            res.setHeader('Content-Type','application/x-www-form-urlencoded');
            res.setBody('{"access_token":"YDrDcBwK3v5Z4knPMqw8LJuyk175erFKJxPdxN81nzfIrVKVO0prWS","token_type":"Bearer","expires_in":1200,"refresh_token":"1bdLXFA0rwhWAMWYMhyLPZrcidouGY7zeG6FXOelw2i4nX","scope":"CSSCloud"}');
            }
        
            else if((req.getEndpoint()).contains('claiminformation123')){
            res = new HttpResponse();
            //response for calling method 
            res.setHeader('Content-Type', 'application/json');
            res.setStatusCode(200);
           
                 //System.debug('The Claim Request is***'+ cInfoRequest );
           req.setBody('{"Header":{"Sender":{"MessageID": "unique message ID at SF","SenderID": "SF","ServiceName": "ServiceRequest"},"Target":{"TargetID":"RSW"}},"DataArea": { "ClaimInformation": { "ServiceProviderCode": "Bangalore", "DSID": "DSID", "RONumber": "RONumber", "ESN":"7946+4646", "FailurePoint": "FailurePoint", "FailureMeasure": "FailureMeasure", "FailureDate": "FailureDate","WarrantyStartDate": "WarrantyStartDate+", "Manufacturer": "Make", "Model": "Model", "Application": "Application","VIN": "VIN", "UnitNumber": "UnitNumber", "ServiceProviderContact": "CMARINE", "CustomerName": "CustomerName","ComplaintCode": "ComplaintCode", "JobId": "JobId", "UserId": "UserId"}}}');
                 
            }
              return res;
    }
    

}