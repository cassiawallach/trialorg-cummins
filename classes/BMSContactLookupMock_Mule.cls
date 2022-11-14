@isTest
global class BMSContactLookupMock_Mule implements HttpCalloutMock {
    // Implement this interface method
    global HTTPResponse respond(HTTPRequest req) {
        // Optionally, only send a mock response for a specific endpoint
        // and method.
        system.debug('InsideContactLookupMock**');
        System.assertEquals('GET', req.getMethod());
        
		system.debug('InsideContactLookupMock2**');
		CSS_BMSContactLookupResponseJ2A.Sender sender = new  CSS_BMSContactLookupResponseJ2A.Sender();
		sender.ServiceName='Test Service';
		sender.MessageID='ABC10019';
		sender.SenderID='TESTSENDER';
		
		CSS_BMSContactLookupResponseJ2A.Target target = new  CSS_BMSContactLookupResponseJ2A.Target();
		target.TargetID='TestTarget';
		
		
		CSS_BMSContactLookupResponseJ2A.Location loc = new  CSS_BMSContactLookupResponseJ2A.Location();
		loc.LocationID='1209';
		
		CSS_BMSContactLookupResponseJ2A.Header header = new  CSS_BMSContactLookupResponseJ2A.Header();
		header.Sender=sender;
		header.Target=target;
		header.Location=loc;
		header.ReturnCodeDescription='100';
		header.Status='success';
		
		CSS_BMSContactLookupResponseJ2A.DataArea da = new  CSS_BMSContactLookupResponseJ2A.DataArea();
		
		da.CustomerNumber='12344';
        da.FirstName='VS';
        da.MI='2232';
        da.LastName='wewe';
        da.Salutation='MMM';
		
       CSS_BMSContactLookupResponseJ2A obj = new CSS_BMSContactLookupResponseJ2A();
	   obj.Header=header;
	   
		List<CSS_BMSContactLookupResponseJ2A.DataArea> dtList = new List<CSS_BMSContactLookupResponseJ2A.DataArea> ();
		dtList.add(da);
		 obj.DataArea=dtList;
		
        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody(Json.serialize(obj));
		res.setStatusCode(200);
        return res;
    }
}