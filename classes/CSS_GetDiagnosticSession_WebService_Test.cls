@isTest
global class CSS_GetDiagnosticSession_WebService_Test implements WebServiceMock {
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
            wwwKaidaraCom.getDiagnosticSessionResponse response_elem = new wwwKaidaraCom.getDiagnosticSessionResponse();
            wwwKaidaraComKaidaraservice.diagnosticSession fea = new wwwKaidaraComKaidaraservice.diagnosticSession();
           // fea.history[0].key='10#170';
            response_elem.return_x = fea;
            response.put('response_x', response_elem);
        }
}