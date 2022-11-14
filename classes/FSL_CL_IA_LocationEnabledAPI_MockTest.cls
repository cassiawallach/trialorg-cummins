@isTest
global class FSL_CL_IA_LocationEnabledAPI_MockTest implements HttpCalloutMock {
     //Rajashekar N ; 09/09/2020 ; CT2-146
    global HttpResponse respond(HttpRequest req){
		
        HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type', 'application/json');
        response.setBody('{"Header":{"Status":"Success","ServiceVersion":"1.0","ServiceName":"IALocationEnabled","ReturnCodeDescription":"CG01 - Response sent successfully"},"DataArea":{"wOEnabled":"Y"}}');
        response.setStatusCode(200);
        return response;    
        
    }
}