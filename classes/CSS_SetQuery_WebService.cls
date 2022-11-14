@isTest
global class CSS_SetQuery_WebService implements WebServiceMock {
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
            wwwKaidaraCom.setQueryResponse response_elem = new wwwKaidaraCom.setQueryResponse();
            wwwKaidaraComKaidaraservice.query fea = new wwwKaidaraComKaidaraservice.query();
           // fea.values[0].identifier='10#170';
            response_elem.return_x = fea;
            response.put('response_x', response_elem);
        }
}