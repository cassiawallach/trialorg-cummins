@isTest
global class CG_OverlapSRTMock_Test implements HttpCalloutMock {
   // Implement this interface method
    global HTTPResponse respond(HTTPRequest req) {
        system.debug('Inside**');
       HttpResponse res = new HttpResponse();
            //response for calling method 
            res.setHeader('Content-Type', 'application/json');
            //res.setBody('{"success"}');
            //res.setBody('{"Header":{"ReturnCodeDescription":"Service Provider Code is Mandatory","Status":"ERROR","ReturnCode":"E002","MessageIdentifier":"2016-06-21T05:43:50.595-05:00"}}');
            res.setStatusCode(200);
             String json='{'+
            '"Header":{'+
                '"Status":"Success",'+
                    '"ReturnCodeDescription":"<Message from SRT>",'+
                        '"ReturnCode":"<MessageCode from SRT>",'+
            '"MessageType":"<Message Type From SRT>",'+
                '"MessageIdentifier":"Identifier from MW"},'+
            '"DataArea":{'+
            '"TotalOverlapHours":5.5,'+
               ' "TotalAdjustedHours":0.5,'+
                    '"Steps":'+
        '['+
            '{'+
                '"TotalOverlapHours":['+
        '{"SRTNumber":"11-111-11","OverlapHrs":1.5},'+
        '{"SRTNumber":"12-121-12","OverlapHrs":3.0}],'+
            '"StepId":1234,"SRTHours":2.5,'+
           '"SRTAdjustedHours":0.5,'+
                '"Qty":2,"AccessCode":"R"'+
                    '},'+
                    '{'+
                        '"TotalOverlapHours":['+
                            '{"SRTNumber":"11-111-13","OverlapHrs":2.5},'+
                            '{"SRTNumber":"11-111-14","OverlapHrs":2.0}],'+
                                '"StepId":1235,"SRTHours":2.5,'+
                                    '"SRTAdjustedHours":0.5,"Qty":1,'+
                                        '"AccessCode":"B"'+
                        '}'+
']'+
                        '}'+
                        '}'+
');'+
            '';
        res.setBody(json);

        	return res;
            }
    
    }