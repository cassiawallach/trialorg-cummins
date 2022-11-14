@isTest
global class CSS_CustOutBoundMock1 implements HttpCalloutMock {
   // Implement this interface method
    global HTTPResponse respond(HTTPRequest req) {
        
       HttpResponse res = new HttpResponse();
            //response for calling method 
            res.setHeader('Content-Type', 'application/json');
            //res.setBody('{"success"}');
            //res.setBody('{"Header":{"ReturnCodeDescription":"Service Provider Code is Mandatory","Status":"ERROR","ReturnCode":"E002","MessageIdentifier":"2016-06-21T05:43:50.595-05:00"}}');
            res.setStatusCode(404);
            String json = '{ '+
        '\"Header\": { '+
            '  \"Status\": \"success\", '+
                    '  \"Sender\": { '+
                    '\"ServiceName\": \"GetUnitInfo\",'+
                    '\"SenderID\": \"CSS\"'+
                    '},'+
                    ' \"Target\": {'+
                    '\"TargetID\": \"BMS"'+
                    '},'+
            '  \"Location\": { '+
            '   \"LocationID\": \"02400-02394\" '+
            '  } '+
            '}, '+
            '\"DataArea\": [{ '+
        '  \"CustomerCode\" : \"A1234567\", '+
        '  \"CustomerName\": \"Test1\", '+
        '  \"LocationAddressline1\": \"\", '+
        '  \"LocationAddressline2\": \"\", '+
        '  \"LocationAddressline3\": \"\", '+
        '  \"PhoneNumber\": \"\", '+
        '  \"AreaCode\": \"\", '+
        '  \"City\": \"\", '+
        '  \"PaymentType\": \"\", '+
        '  \"State\": 0, '+
        '  \"Country\": \"\", '+
        '  \"Postalcode1\": \"\", '+
        '  \"Postalcode2\": \"\" '+
        '}] '+
        '}';
        res.setBody(json);
        	return res;
            }
    
    }