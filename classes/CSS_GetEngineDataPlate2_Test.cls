@isTest
global class CSS_GetEngineDataPlate2_Test implements WebServiceMock {
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
            CSS_quickserveCumminsComWebservices.getEngineDataplateResponse_element response_elem = new CSS_quickserveCumminsComWebservices.getEngineDataplateResponse_element();
            //CSS_quickserveCumminsComWebservices.ModelName gl = new CSS_quickserveCumminsComWebservices.ModelName();
            CSS_quickserveCumminsComWebservices.ModelName gl = null;
            response_elem.return_x = gl;
            response.put('response_x', response_elem);
            //response.put('response_x',response_elem.get('response_x'));
        }
}