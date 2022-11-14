@isTest
global class CSS_EDSwebcalloutMockImpl_Test implements WebServiceMock {
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
            System.debug('Hello varun');
            wwwKaidaraCom.createDiagnosticSessionResponse response_elem = new  wwwKaidaraCom.createDiagnosticSessionResponse();
            wwwKaidaraComKaidaraservice.resultDiagnosticSession dsID = new wwwKaidaraComKaidaraservice.resultDiagnosticSession();
            dsID.ID='DSBDT3829';
            system.debug('DSBDT3829<><>' + dsID.ID);
            response_elem.return_x = dsID;
            response.put('response_x', response_elem);
        }
}