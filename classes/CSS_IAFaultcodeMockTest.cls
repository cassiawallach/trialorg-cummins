@isTest
global class CSS_IAFaultcodeMockTest implements HttpCalloutMock {
    global HTTPResponse respond(HTTPRequest req) 
    {
        HttpResponse res = new HttpResponse();
        {
            //Create a fake response
            res.setHeader('Content-Type','application/x-www-form-urlencoded');
            res.setBody('{"Header": {"ServiceName": "GetPrioritizedFC","ServiceVersion": "2.0","ToolID": "ATLASMOBILE","SenderID": "oh559","TargetID": "CSS" },"DataArea": {"PSN": "79484646","SERVICEMODELNAME": "ISX15 CM2250","ERT": "15255","MAKE": "PETERBILT","MODEL":"389","ACCESS": "B","UserLocation": ",7362332,44444-16402,56270-56255-P","CustomerName": "IA Cummins Test","ComplaintText": "Oil Leak Testing12345","IASNumber": "","FAULTLIST": [{"fc": "1117",        "occurenceTime": 12,"status": "active", "count": 1},{"fc": "1116", "occurenceTime": 654,"status": "active", "count": 1 },{"fc": "1118","occurenceTime": 7865,"status": "active","count": 1 },{ "fc": "1119", "occurenceTime": 80876,"status": "active", "count": 1 }]}}');
        }
        return res;
    }
}