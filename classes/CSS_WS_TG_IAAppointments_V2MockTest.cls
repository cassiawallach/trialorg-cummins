@isTest
global class CSS_WS_TG_IAAppointments_V2MockTest implements HttpCalloutMock {
    // Implement this interface method
    global HTTPResponse respond(HTTPRequest req) {
        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('{"Header":{"toolID":"GUIDANZ","status":"Success","serviceVersion":"2.0","serviceName":"IAAppointments","senderId":"oh559","returnCodeDescription":"CG01-IAAppointments list is sent successfully"},"DataArea":{"woEnabled":null,"serviceRequests":[]}}');
        res.setStatusCode(200);
        return res;
    }
}