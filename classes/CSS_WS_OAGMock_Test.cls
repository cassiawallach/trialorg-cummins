@istest
global class CSS_WS_OAGMock_Test implements HttpCalloutMock {
    global HTTPResponse respond(HTTPRequest req) 
    {
        HttpResponse res = new HttpResponse();
        {
            //Create a fake response
            res.setStatusCode(200);
            res.setHeader('Content-Type', 'application/json');
            //res.setBody('{"DataArea":[{"SRTType":"Admin","SRTNumber":"99-202-00","SRTTitle":"PM Inspection 21 - 34 / Natural Gas","BTime":0,"RTime":0,"SRTCategory":"Service, Maintenance, Contract Repair","StepID":139319,"ATime":0,"CTime":2,"DTime":0},{"SRTType":"Admin","SRTNumber":"99-227-00","SRTTitle":"PM Full Service 501 - 600 / Diesel","BTime":0,"RTime":0,"SRTCategory":"Service, Maintenance, Contract Repair","StepID":139342,"ATime":0,"CTime":7,"DTime":0}],"Header":{"ReturnCodeDescription":"Normal, Successful completion.","ReturnCode":"ORA-00000","MessageIdentifier":"S"}}');
            res.setBody('{"DataArea": [{ "ClaimInformation": { "ServiceProviderCode": "Bangalore", "DSID": "1234", "RONumber": "123", "ESN":"79464646",FailurePoint": "not", "FailureMeasure": "measure", "FailureDate": "10","WarrantyStartDate": "23", "Manufacturer": "KENWORTH", "Model": "model", "Application": "qwer","VIN": "1234", "UnitNumber": "23456", "ServiceProviderContact": "CMARINE", "CustomerName": "test user","ComplaintCode": "complaint", "JobId": "c-09878", "UserId": "23456"}]}');
            
            if((req.getEndpoint()).contains('bmscustomercontact')){
                
                
                String json = '{'+
		'                \"DataArea\": ['+
		'                {'+
		'                                \"CustomerNumber\": \"5723046\",'+
		'                                \"FirstName\": \"\",'+
		'                                \"MI\": \"5723046\",'+
		'                                \"LastName\": \"CA\",'+
		'                                \"Salutation\": \"BRITESTONE COLONY\",'+
		'                                \"Position\": \"CARBON\",'+
		'                                \"LocationAddressline1\": \"BOX 129\",'+
		'                                \"LocationAddressline2\": \"CARBON COLONY\",'+
		'                                \"LocationAddressline3\": \"CARBON COLONY\",'+
		'                                \"City\": \"403\",'+
		'                                \"State\": \"CASH\",'+
		'                                \"PostalCode\": \"AB\",'+
		'                                \"PostalCodeSuffix\": \"\",'+
		'                                \"Country\": \"US\",'+
		'                                \"PhoneAreaCode\": \"667\",'+
		'                                \"PhoneNumber\": \"278-6789\",'+
		'                                \"Ext\": \"11\",'+
		'                                \"FaxAreacode\": \"813\",'+
		'                                \"FaxNumber\": \"213-0897\",'+
		'                                \"Email\": \"Example@gmail.com\",'+
		'                                \"Comments\": \"Testing\",'+
		'                                \"ContactID\": \"213897\"'+
		'                }],'+
		''+
		'                \"Header\": {'+
		'                                \"ReturnCodeDescription\":\"retTest\",'+
		'                                \"Status\": \"SUCCESS\",'+
		'                                \"Sender\": {'+
		'                                                \"ServiceName\": \"GetCustomer\",'+
		'                                                \"MessageID\":\"1234\", '+
		'                                                \"SenderID\": \"BMS\"'+
		'                                },'+
		'                                \"Target\": {'+
		'                                                \"TargetID\": \"CSS\"'+
		'                                },'+
		'                                \"Location\": {'+
		'                                                \"LocationID\": \"56270-56255\"'+
		'                                }'+
		'                }'+
		'}';
                res.setBody(json);
       
            }
            else if((req.getEndpoint()).contains('bmscustomer')){
                String json = '{ '+
                '\"Header\": { '+
                '  \"Status\": \"success\", '+
                '  \"ReturnCodeDescription\": \"message_ifany\", '+
                '  \"Location\": { \"LocationID\": \"02400-02394\" } '+
                '}, '+
                '\"DataArea\": { '+
                '  \"CustomerCode\": \"1234567\", '+
                '  \"OpenChargeFlag\": \"\" '+
                '} '+
                '}';
                
                 res.setBody(json);  
                
            }
            
            
            
        }
        return res;
    }

}