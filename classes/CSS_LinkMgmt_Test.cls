@isTest
global class CSS_LinkMgmt_Test implements WebServiceMock{
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
            CSS_quickserveCumminsComWebservices.linkMgmtResponse_element response_elem = new CSS_quickserveCumminsComWebservices.linkMgmtResponse_element();
            string gl='https://qsolpilot.cummins.com/qs3/pubsys2/xml/en/procedures/132/132-019-019-tr-mixar5.html|https://qsolpilot.cummins.com/qs3/pubsys2/xml/en/procedures/132/132-019-019-tr-vqxg5na.html';
            //wwwKaidaraCom.getLocale gL = new wwwKaidaraCom.getLocale();
            //string gl='session';
            // gL.sessionKey='session';
            response_elem.return_x = gl;
            response.put('response_x', response_elem);
        }
}