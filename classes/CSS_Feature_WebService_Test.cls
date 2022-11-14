@isTest
global class CSS_Feature_WebService_Test implements WebServiceMock {
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
            wwwKaidaraCom.fireTransitionResponse response_elem = new wwwKaidaraCom.fireTransitionResponse();
            wwwKaidaraComKaidaraservice.feature fea = new wwwKaidaraComKaidaraservice.feature();
            wwwKaidaraComKaidaraservice.state sta = new wwwKaidaraComKaidaraservice.state();
            //fea.current.type_x='Engine';
            //fea.stateContent.query.values[0].identifier='10#170';
            //fea.states[0].type_x='Engine';
            response_elem.return_x = fea;
            response.put('response_x', response_elem);
        }
}