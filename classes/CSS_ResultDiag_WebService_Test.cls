@isTest
global class CSS_ResultDiag_WebService_Test implements WebServiceMock {
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
            wwwKaidaraCom.searchDiagnosticSessionResponse response_elem = new  wwwKaidaraCom.searchDiagnosticSessionResponse();
            wwwKaidaraComKaidaraservice.resultDiagnosticSessionContent fea = new wwwKaidaraComKaidaraservice.resultDiagnosticSessionContent();
            fea.nbChunks=1;
            response_elem.return_x = fea;
            response.put('response_x', response_elem);
        }
}