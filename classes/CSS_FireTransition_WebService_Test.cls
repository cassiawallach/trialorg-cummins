@isTest
global class CSS_FireTransition_WebService_Test implements WebServiceMock {
    global void doInvoke(
        Object stub,
        Object request,
        Map<String, Object> response,
        String endpoint,
        String soapAction,
        String requestName,
        String responseNS,
        String responseName,
        String responseType) {
            wwwKaidaraCom.openResponse response_elem = new wwwKaidaraCom.openResponse();
            wwwKaidaraComKaidaraservice.project fea = new wwwKaidaraComKaidaraservice.project();
            fea.name='Engine';
            response_elem.return_x = fea;
            response.put('response_x', response_elem);
        }
}