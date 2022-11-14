@isTest
global class CSS_GetWarrantyDocs_Test implements WebServiceMock {
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
            system.debug('InsideMock**');
            CSS_quickserveCumminsComWebservices.getWarrantyDocsResponse_element response_elem = new CSS_quickserveCumminsComWebservices.getWarrantyDocsResponse_element();
            CSS_quickserveCumminsComWebservices.ArrayOfWarrantyDoc gl = new CSS_quickserveCumminsComWebservices.ArrayOfWarrantyDoc();
            CSS_quickserveCumminsComWebservices.WarrantyDoc itemWarr = new CSS_quickserveCumminsComWebservices.WarrantyDoc();
            itemWarr.docNumber = '12345';
            CSS_quickserveCumminsComWebservices.WarrantyDoc warDoc = new CSS_quickserveCumminsComWebservices.WarrantyDoc();
            warDoc.docNumber='doc123';
            Account[] accs3 = new Account[]{new Account()};
            gl.item = new CSS_quickserveCumminsComWebservices.WarrantyDoc[]{warDoc};
            response_elem.return_x = gl;
            response.put('response_x', response_elem);
        }
}