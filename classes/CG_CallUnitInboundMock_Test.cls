@isTest
global class CG_CallUnitInboundMock_Test implements HttpCalloutMock {
   // Implement this interface method
    global HTTPResponse respond(HTTPRequest req) {
        system.debug('Inside**');
       HttpResponse res = new HttpResponse();
            //response for calling method 
            res.setHeader('Content-Type', 'application/json');
            //res.setBody('{"success"}');
            //res.setBody('{"Header":{"ReturnCodeDescription":"Service Provider Code is Mandatory","Status":"ERROR","ReturnCode":"E002","MessageIdentifier":"2016-06-21T05:43:50.595-05:00"}}');
            res.setStatusCode(200);
            res.setBody('{ '+
                                        '\"Header\": { '+
                                        '  \"Status\": \"success\", '+
                                        '  \"ReturnCodeDescription\": \"message_ifany\", '+
                                        '  \"Location\": { \"LocationID\": \"02400-02394\" }, '+
                                        '  \"Sender\": { '+
                                        '\"ServiceName\": \"GetUnitInfo\",'+
                                        '\"SenderID\": \"CSS\",'+
                                        '\"MessageID\": \"Msg11\"'+
                                        '},'+
                                        ' \"Target\": {'+
                                        '\"LocationID\": \"02400-02394",'+
                                        '\"TargetID\": \"BMS"'+
                                        '}'+
                                        '}, '+
                                        '\"DataArea\": { '+
                                        '\"UnitNumber\": \"WO1234567\" '+
                                        '} '+
                                        '}');

        	return res;
            }
    
    }