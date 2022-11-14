@isTest
public class CSS_SBL_getFailModesResponseWrapper_Test {
    static testMethod void testDataParse() {
        String json = '{'+
            '                \"DataArea\": '+
            '                {'+
            '                "Details":[' +
            '                {' +
            '                                \"FailModeCode\": \"BR1-BROKEN\",'+
            '                                \"DESCRIPTION\": \"Broken Filter shell1\",'+
            '                                \"Active\": \"Y\",'+
            '                                \"BusinessUnit\": \"EBU\",'+
            '                                \"LastUpdated\": \"2010-03-19T16:18:59.000-05:00\",'+
            '                                \"Created\": \"2010-03-19T16:18:59.000-05:00\"'+
            '                }]'+
            '                },'  +
            ''+
            '                \"Header\": {'+
            '                                \"ReturnCodeDescription\":\"\",'+
            '                                \"MessageIdentifier\":\"\",'+
            '                                \"ReturnCode\":\"\",'+
            '                                \"MessageType\":\"\",'+
            '                                \"Status\": \"Success\"'+
            '                }'+
            '}';
        try{
            CSS_SBL_getFailModesResponseWrapper controller = CSS_SBL_getFailModesResponseWrapper.parse(json);
            CSS_SBL_getFailModesResponseWrapper.Header header = new CSS_SBL_getFailModesResponseWrapper.Header();
            header.ReturnCodeDescription = '';
            header.Status = 'Success';
            header.MessageIdentifier='tetdt';
            header.ReturnCode ='RC';
            header.MessageType ='Test MessageType';
            CSS_SBL_getFailModesResponseWrapper.DataArea dArea = new CSS_SBL_getFailModesResponseWrapper.DataArea();
            CSS_SBL_getFailModesResponseWrapper.Details detail = new CSS_SBL_getFailModesResponseWrapper.Details();
            detail.FailModeCode ='BR1-BROKEN';
            detail.Description ='Broken Filter shell1';
            detail.Active ='Y';
            detail.Created ='2010-03-19T16:18:59.000-05:00';
            detail.LastUpdated='2010-03-19T16:18:59.000-05:00';
            detail.BusinessUnit='EBU';
            dArea.details.add(detail);
        }
        Catch(exception e){}
        
    }
}