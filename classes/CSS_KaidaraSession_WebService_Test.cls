@isTest
global class CSS_KaidaraSession_WebService_Test implements WebServiceMock {
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
            wwwKaidaraCom.loginResponse response_elem = new wwwKaidaraCom.loginResponse();
            wwwKaidaraComKaidaraservice.kaidaraSession fea = new wwwKaidaraComKaidaraservice.kaidaraSession();
            fea.name='Engine';
            response_elem.return_x = fea;
            response.put('response_x', response_elem);
        }
}