@isTest
global class CSS_Switch_WebService_Test implements WebServiceMock {
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
            wwwKaidaraCom.switchChunkIndexResponse response_elem = new wwwKaidaraCom.switchChunkIndexResponse();
            wwwKaidaraComKaidaraservice.feature fea = new wwwKaidaraComKaidaraservice.feature();
           // fea.history[0].key='10#170';
            response_elem.return_x = fea;
            response.put('response_x', response_elem);
        }
}