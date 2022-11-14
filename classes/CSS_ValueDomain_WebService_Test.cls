@isTest
global class CSS_ValueDomain_WebService_Test implements WebServiceMock {
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
            wwwKaidaraCom.getValueDomainResponse response_elem = new wwwKaidaraCom.getValueDomainResponse();
            wwwKaidaraComKaidaraservice.valueDomain gl = new wwwKaidaraComKaidaraservice.valueDomain();
            //wwwKaidaraCom.getLocale gL = new wwwKaidaraCom.getLocale();
            //string gl='session';
           // gL.sessionKey='session';
            response_elem.return_x = gl;
            response.put('response_x', response_elem);
        }
}