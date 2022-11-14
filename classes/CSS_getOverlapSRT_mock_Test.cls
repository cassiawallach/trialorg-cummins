@isTest
global class CSS_getOverlapSRT_mock_Test implements HttpCalloutMock{
    global HTTPResponse respond(HTTPRequest req) 
    {
        HttpResponse res = new HttpResponse();
        {
            //Create a fake response
            res.setHeader('Content-Type', 'application/json');
            res.setBody( '{'+
'\"Header\": {'+
  '\"MessageIdentifier\": \"From SRT\",'+
  '\"ReturnCode\": \"From SRT\",'+
  '\"ReturnCodeDescription\": \"Service Successful\",'+
  '\"Status\": \"Success\",'+
  '\"MessageType\": \"From SRT\"'+
'},'+
' \"DataArea\": {'+
' \"TotalOverlapHours\": 5.5,'+
' \"TotalAdjustedHours\": 0.5,'+
            '       \"Steps\": [{'+
'                    \"StepId\": 1234,'+
'                     \"AccessCode\": \"R\",'+
'                     \"Qty\": 2,'+
'                     \"SRTHours\": 2.5,'+
'                     \"SRTAdjustedHours\": 0.5,'+
'                     \"TotalOverlapHours\": ['+
'                     {'+
'                           \"SRTNumber\": \"11-111-11\",'+
'                           \"OverlapHrs\": 1.5'+
'                     }]'+
'              }]'+
 '}'+
'}');
        }
        return res;
    }
}