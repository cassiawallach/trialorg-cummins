@isTest
global class CSS_SOAPEDS_SOLUTIONS_Test implements WebServiceMock{
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
            wwwKaidaraCom.getDiagnosticSessionSolutionsResponse response_elem = new  wwwKaidaraCom.getDiagnosticSessionSolutionsResponse();
            List<wwwKaidaraComKaidaraservice.dsCaseAction> dsAct = new List<wwwKaidaraComKaidaraservice.dsCaseAction>();
            dsAct.add(new wwwKaidaraComKaidaraservice.dsCaseAction());
            dsAct[0].caseName='K07940700';
            response_elem.return_x = dsAct;
            response.put('response_x', response_elem);
        }
}