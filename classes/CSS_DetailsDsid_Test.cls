@isTest
global class CSS_DetailsDsid_Test implements HttpCalloutMock{
	 global HTTPResponse respond(HTTPRequest req) 
    {
        HttpResponse res = new HttpResponse();
        {
            //Create a fake response
            res.setHeader('Content-Type', 'application/json');
            res.setBody('{"details":{"id":"DSBDT4730","status":"Open","name":"TITLE value","title":"TITLE value","details":[{"name":"DSID","caption":"DSID","value":"DSBDT4730","editable":false},{"name":"WORKORDER","caption":"Work Order","editable":true},{"name":"CREATED","caption":"Creation Date","value":"22-APR-2016 15:28:22 EDT","editable":false}');
        }
        return res;
    }
}