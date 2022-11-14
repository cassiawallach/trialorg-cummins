@isTest
global class CSS_GetQSOLOptions_Test implements WebServiceMock {
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
            CSS_quickserveCumminsComWebservices.getOptionsResponse_element response_elem = new CSS_quickserveCumminsComWebservices.getOptionsResponse_element();
            CSS_quickserveCumminsComWebservices.ArrayOfOptions gl = new CSS_quickserveCumminsComWebservices.ArrayOfOptions();
            //CSS_quickserveCumminsComWebservices.Options item = gl.item[0];
            CSS_quickserveCumminsComWebservices.Options opt  = new CSS_quickserveCumminsComWebservices.Options();
            opt.optionNumber = '123';
            opt.repairGroup = '1assda';
            opt.groupName = '21312sdada';
            gl.item = new CSS_quickserveCumminsComWebservices.Options[]{opt};
            response_elem.return_x = gl;
            response.put('response_x', response_elem);
        }
}