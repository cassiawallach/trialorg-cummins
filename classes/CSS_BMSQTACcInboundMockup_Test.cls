@isTest
global class CSS_BMSQTACcInboundMockup_Test implements HttpCalloutMock {
    global HTTPResponse respond(HTTPRequest req) 
    {
        HttpResponse res = new HttpResponse();
        {
            //Create a fake response
            res.setHeader('Content-Type', 'application/json');
            //res.setBody('{"faultCode":[{"state":{"name": "dialog","dialogParamater":{"freeTextSearch": "234"}},"views":{"result":{"pagination":{"totalNumberOfRecord": 3,"currentPage": 0,"numberPerPage": 3,"numberOfPages": 1},"cases":[{"rank":0,"name": "K13742431","imageUseStyle": false,"caseId": 27944,"title": "Fault Code 234 triggered by another fault code","similarity": 100,"similarityImage": "/images/64x16_star5.gif","caseViews": [{"sections":[{"caption": "Admin","baseType": "CLASS","id": "4#104","attributes":[{"caption": "Modification Date","templateName": "case-modification-date","baseType": "LONG","id": "4#55","values":[{"caption": "2016-04-07 17:28","name": "Thu Apr 07 17:28:33 EDT 2016"}]}');
            //res.setBody('"{ ""Header"": {  ""Status"": ""success"",  ""ReturnCodeDescription"": ""message_ifany"",  ""Location"": { ""LocationID"": ""02400-02394"" } }, ""DataArea"": { ""WOReferenceNumber"": ""WO1234567"" }');
            res.setBody('{\"Header\":{\"ReturnCodeDescription\":\"Distributor Not Setup\",\"Status\":\"ERROR\",\"Sender\":{\"ServiceName\":\"GetCustomer\",\"SenderID\":\"CSS\"},\"Target\":{\"TargetID\":\"BMS\"},\"Location\":{\"LocationID\":\"Test\"}},\"DataArea\":{\"WOReferenceNumber\":\"Distributor Not Setup\"}}');
        }
        return res;
    }
}