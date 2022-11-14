@isTest
global class CSS_ESNHistory_Test implements HttpCalloutMock {
    global HTTPResponse respond(HTTPRequest req) 
    {
        HttpResponse res = new HttpResponse();
        {
            //Create a fake response
            res.setHeader('Content-Type', 'application/json');
            res.setBody('{"pagination":{"currentPage":1,"numberPerPage":15,"numberOfPages":1,"totalNumberOfRecord":3},"diagnosticSession":[{"id":"DSBDT4665","creationDate":"2016-02-26 10:41 EST","owner":"POINTE CLAIRE-CUMMINS EASTERN CANADA LP-56330","title":"Tester","model":"ISB6.7 CM2350 B101","status":"Open","serialNumber":"73676187","additionalProp":{"application":"Automotive (other than C series) [130]","failureType":"MI","REPEAT_FLAG":"true"}},{"id":"DSBDT4252","creationDate":"2016-01-21 14:18 EST","owner":"nh877","title":"Trucking","model":"ISB6.7 CM2350 B101","status":"Open","serialNumber":"73676187","additionalProp":{"application":"Automotive (other than C series) [130]","failureType":"MI"}},{"id":"DSBDT4230","creationDate":"2016-01-15 10:44 EST","owner":"nh877","title":"Ondie&#039;s Test with Team","model":"ISB6.7 CM2350 B101","status":"Open","serialNumber":"73676187","additionalProp":{"application":"Automotive (other than C series) [130]","failureType":"MI"}}]}');
        }
        return res;
    }
}