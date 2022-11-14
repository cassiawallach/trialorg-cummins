@isTest
global with sharing class dbu_Integration_Vertex_Token_Mock implements HttpCalloutMock {
    global HTTPResponse respond(HTTPRequest request) {
        HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type', 'application/json');
        response.setBody('{"token_type":"test","expires_in":"sss","access_token":"ssss","refresh_token":"sss","scope":"ssss"}');
        response.setStatusCode(200);
        return response; 
            
    
    }
}