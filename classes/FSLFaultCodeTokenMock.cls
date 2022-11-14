@isTest
global class FSLFaultCodeTokenMock implements HttpCalloutMock {
    global HTTPResponse respond(HTTPRequest req) {
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type','application/x-www-form-urlencoded');
        res.setBody('{"documentNum": "T2085","documentDesc": "ISX15 CM2350 455HP AND HIGHER SCR REPLACEMENT TRP","type": "TRP","language": "en","status": "OPEN","documentLink": "https://qs-stg.cummins.com/qs3/pubsys2/xml/en/trp/2020/t2085.html"}');
        res.setStatusCode(200);
        return res;
    }
}