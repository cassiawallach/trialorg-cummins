@isTest
global class CSS_CustInboundMock implements HttpCalloutMock {
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
        '  \"Location\": { \"LocationID\": \"02400-02394\" } '+
        '}, '+
        '\"DataArea\": { '+
        '  \"CustomerCode\": \"1234567\", '+
        '  \"OpenChargeFlag\": \"\" '+
        '} '+
        '}';
        res.setBody(json);
        	return res;
            }
    
    }