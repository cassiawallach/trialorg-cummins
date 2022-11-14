@isTest
global class FSLCumminsServiceUtility_Mock_Test implements HttpCalloutMock {
    global HttpResponse respond(HttpRequest req){
        HttpResponse res = new HttpResponse( );
        res.setHeader( 'Content-Type', 'application/json');  
        res.setStatusCode(200);
        res.setStatus('OK');
        return res;
    }
}