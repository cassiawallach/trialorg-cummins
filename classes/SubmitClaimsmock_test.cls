@istest
Global class SubmitClaimsmock_test implements httpcalloutmock {
    global httpresponse respond(httprequest req)
    {
        httpresponse res = new httpresponse();
        res.setHeader('content-type','application/json');
        res.setStatus('Success');
        res.setStatusCode(200);
        res.setBody('OSB Service Callout action received SOAP Fault response');
        return res;
    }

}