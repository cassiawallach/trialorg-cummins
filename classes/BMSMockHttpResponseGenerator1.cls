@isTest
global class BMSMockHttpResponseGenerator1 implements HttpCalloutMock {
    // Implement this interface method
    global HTTPResponse respond(HTTPRequest req) {
        // Optionally, only send a mock response for a specific endpoint
        // and method.
        
        System.assertEquals('POST', req.getMethod());
        
		
		CSS_UnitOutboundJSON2Apex.Sender sender = new  CSS_UnitOutboundJSON2Apex.Sender();
		sender.ServiceName='Test Service';
		sender.MessageID='ABC10019';
		sender.SenderID='TESTSENDER';
		
		CSS_UnitOutboundJSON2Apex.Target target = new  CSS_UnitOutboundJSON2Apex.Target();
		target.TargetID='TestTarget';
		
		
		CSS_UnitOutboundJSON2Apex.Location loc = new  CSS_UnitOutboundJSON2Apex.Location();
		loc.LocationID='1209';
		
		CSS_UnitOutboundJSON2Apex.Header header = new  CSS_UnitOutboundJSON2Apex.Header();
		header.Sender=sender;
		header.Target=target;
		header.Location=loc;
		header.ReturnCodeDescription='100';
		header.Status='ERROR';
		
		CSS_UnitOutboundJSON2Apex.DataArea da = new  CSS_UnitOutboundJSON2Apex.DataArea();
		
		da.CustomerCode='12344';
        da.contactName='VS';
        da.Model='2232';
        da.ownerName='wewe';
        da.UnitDescription='MMM';
        da.UnitDescription = 'Test';
		CSS_UnitOutboundJSON2Apex obj = new CSS_UnitOutboundJSON2Apex();
       //CSS_UnitOutboundJSON2Apex obj = new CSS_UnitOutboundJSON2Apex();
	   obj.Header=header;
	   
		List<CSS_UnitOutboundJSON2Apex.DataArea> dtList = new List<CSS_UnitOutboundJSON2Apex.DataArea> ();
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