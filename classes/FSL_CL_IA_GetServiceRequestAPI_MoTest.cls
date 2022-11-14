@isTest
global class FSL_CL_IA_GetServiceRequestAPI_MoTest implements HttpCalloutMock {
    //Rajashekar N ; 09/09/2020 ; CT2-146
    global HttpResponse respond(HttpRequest request){
        HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type', 'application/json');
        response.setBody('{"Header":{"Status":"Success","ServiceVersion":"1.0","ServiceName":"GetServiceRequestAPI","ReturnCodeDescription":"CG01 - Response sent successfully"},"DataArea":{"CustomerName":"CusName","ContactFirstName":"FN","ContactLastName":"LN","WONumber":"0000123","PSN":"000123","UnitNumber":"123","ComplaintText":"FN","AvailableForService":"Y","WOEnabled":"Y"}}');
        response.setStatusCode(200);
        return response;
    }
}