@isTest
global class CSS_CommentInboundMock implements HttpCalloutMock {
   // Implement this interface method
    global HTTPResponse respond(HTTPRequest req) {
        
       HttpResponse res = new HttpResponse();
            //response for calling method 
            res.setHeader('Content-Type', 'application/json');
            //res.setBody('{"success"}');
            //res.setBody('{"Header":{"ReturnCodeDescription":"Service Provider Code is Mandatory","Status":"ERROR","ReturnCode":"E002","MessageIdentifier":"2016-06-21T05:43:50.595-05:00"}}');
            res.setStatusCode(200);
            String json = '{ '+
		'\"Header\": { '+
		'  \"Status\": \"success\", '+
		'  \"ReturnCodeDescription\": \"message_ifany\", '+
		'  \"Location\": { \"LocationID\": \"02400-02394\" }, '+
        '  \"Sender\": { \"ServiceName\":\"comminbound\",\"SenderID\":\"send11\",\"MessageID\":\"msg22\" },'+
        '  \"Target\": { \"TargetID\": \"Target33\" } '+
		'} '+
		'}';
        res.setBody(json);
        	return res;
            }
    
    }