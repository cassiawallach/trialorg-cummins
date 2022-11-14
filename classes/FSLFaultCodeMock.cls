@IsTest
global class FSLFaultCodeMock implements HttpCalloutMock {
    global HTTPResponse respond(HTTPRequest req) {
        // Create a fake response
        HttpResponse res = new HttpResponse();
        // res.setHeader('Content-Type', 'application/json');
        
        if(req.getEndpoint().contains('getQSOLToken')){
            res.setHeader('Content-Type', 'application/json');
            res.setStatusCode(200);
            res.setBody('{"apiToken":"XN8PBx2p854LkXBZn78J281ZFLTAhlNO4QY7jqZ34e2Wma6vaKf4jH","token_type":"Bearer","expires_in":1200,"refresh_token":"nqtzIv8U4o2oB5UzJx0yQxuf0kBoTmZR22uOVmqq96E4oY","scope":"CSSCloud"}');
        }
        else{
            // if(req.getEndpoint().toLowerCase().contains('serialNumber&documentType=TSB&language=en&businessUnit=EBU'))
            // {
            res.setHeader('Content-Type', 'application/json');
            res.setStatusCode(200);
            res.setBody('[{"documentNum": "T2085","documentDesc": "ISX15 CM2350 455HP AND HIGHER SCR REPLACEMENT TRP","type": "TRP","language": "en","status": "OPEN","documentLink": "https://qs-stg.cummins.com/qs3/pubsys2/xml/en/trp/2020/t2085.html"}]');
        }
        return res;
    }
}