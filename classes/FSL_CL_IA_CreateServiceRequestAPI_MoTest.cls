@isTest
//adding Test class for coverage
global class FSL_CL_IA_CreateServiceRequestAPI_MoTest implements HttpCalloutMock {
        //Rajashekar N ; 09/09/2020 ; CT2-146
        global HttpResponse respond(HttpRequest request){
        HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type', 'application/json');
        response.setBody('{"Header":{"Status":"Success","ServiceVersion":"1.0","ServiceName":"IASerRequestCreation","ReturnCodeDescription":"CG01 - Response sent successfully"},"DataArea":{"WONumber":"Y","IASNumber":"IAS-001"}}');
        response.setStatusCode(200);
        return response;  
    }
}