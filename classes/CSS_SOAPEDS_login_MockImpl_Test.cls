@isTest
global class CSS_SOAPEDS_login_MockImpl_Test implements WebServiceMock {
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
            wwwKaidaraCom.loginWithTokenResponse response_elem = new  wwwKaidaraCom.loginWithTokenResponse();
            wwwKaidaraComKaidaraservice.kaidaraSession session = new wwwKaidaraComKaidaraservice.kaidaraSession();
            session.Key='Session key Mock response';
            response_elem.return_x = session;
            response.put('response_x', response_elem);
        }
}