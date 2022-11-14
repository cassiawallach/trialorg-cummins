@isTest
global class CSS_GetFaultCodeOverview_Test implements WebServiceMock {
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
            CSS_quickserveCumminsComWebservices.getFaultCodeOverviewResponse_element response_elem = new CSS_quickserveCumminsComWebservices.getFaultCodeOverviewResponse_element();
            CSS_quickserveCumminsComWebservices.FaultCodeInfo gl = new CSS_quickserveCumminsComWebservices.FaultCodeInfo();
            //wwwKaidaraCom.getLocale gL = new wwwKaidaraCom.getLocale();
            //string gl='session';
            // gL.sessionKey='session';
            response_elem.return_x = gl;
            response.put('response_x', response_elem);
        }
}