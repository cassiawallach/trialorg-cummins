/*
 * Block comments with details of changes
 */
global class CG_CheckwarrantyBasicCoverageMock_test implements HttpCalloutMock {
   // Implement this interface method
    global HTTPResponse respond(HTTPRequest req) {
        // Optionally, only send a mock response for a specific endpoint
        // and method.
        //System.assertEquals('https://services-dev-oauth.cummins.com/api/oauth/token/css', req.getEndpoint());
        //System.assertEquals('POST', req.getMethod());
        HttpResponse res;

 if((req.getEndpoint()).contains('basiccoverage')){
            res = new HttpResponse();
            //response for calling method 
            res.setHeader('Content-Type', 'application/json');
            res.setStatusCode(200);
            res.setBody('{'+
           ' "Header":{'+
                '"ReturnCodeDescription":"",'+
                  '  "Status":"Success"'+
                        '},'+
                            '"BasicCoverageResponseHeader":'+
        '{'+
            '"Response":'+
            '{'+
                '"ListOfCoverageDetails":'+
           
        '{'+
                    '"CoverageDetails":['+
            '{'+   
                            '"ListOfCoverageComponentList":'+
            '{'+
                                '"CoverageComponentList":['+
                                    '{'+
                                        '"MegawattHours":"0",'+
                                            '"CoverageMaxMonths":"24",'+
                                                '"CoverageComponentTypeCode":"BASE",'+
                                                    '"CoverageMinMonths":"0",'+
                                                       ' "CoverageHours":"9999999",'+
                                                            '"CoverageDefenitionType":"BASE",'+
                                                              '  "CoverageMiles":"250000" '+
           '},'+
        '{'+
                                        '"MegawattHours":"0",'+
                                            '"CoverageMaxMonths":"60",'+
                                             '   "CoverageComponentTypeCode":"EXTENDED",'+
                                                    '"CoverageMinMonths":"0",'+
                                                       ' "CoverageHours":"0",'+
                                                            '"CoverageDefenitionType":"EXTENDED",'+
                                                                '"CoverageMiles":"9999999"'+
           '},'+
        '{'+
                                           '"MegawattHours":"0",'+
                                            '"CoverageMaxMonths":"24",'+
                                                '"CoverageComponentTypeCode":"INJECTOR",'+
                                                    '"CoverageMinMonths":"0",'+
                                                     '   "CoverageHours":"9999999",'+
                                                            '"CoverageDefenitionType":"BASE",'+
                                                                '"CoverageMiles":"125000"'+
           '},'+
            '{'+
                                        '"MegawattHours":"0",'+
                                            '"CoverageMaxMonths":"12",'+
                                                '"CoverageComponentTypeCode":"BELTS/HOSES",'+
                                                    '"CoverageMinMonths":"0",'+
                                                        '"CoverageHours":"0",'+
                                                            '"CoverageDefenitionType":"BASE",'+
                                                                '"CoverageMiles":"9999999"'+
            '}'+
                                ']'+
                            '},'+
                                '"WarrantyManualURL":"https://quickserve.cummins.com/qs3/portal/service/manual/en/4021290/?page=",'+
                            '"CoverageType":"NEW-New Engine Warranty",'+
                                '"ListOfCoverageDedutibles":{'+
            '       "CoverageDedutibles":[]'+
            '},'+
        '"ProcedureNumber":"111-503-007"'+
            '}'+
']'+
            '},'+
'"ListOfExtendedCoverageDetails":{'+
    '"ExtendedCoverageDetails":['+
        '{'+
            '"ListOfExtCoverageDedutibles":{'+
                '"ExtendedCoverageDedutibles":['+
        '{'+
                        '"CoverageDefTypeCode":"EXTENDED",'+
            '"ConstantDecutibleAmt":"0",'+
                '"BeginMiles":"0",'+
                    '"BeginMonths":"0",'+
                        '"FirstVisitAmt":"250",'+
                            '"ProgramID":"UPL",'+
                                '"BeginMegawattHours":"",'+
                                    '"BeginHours":"0",'+
                                        '"SubsequentVisitAmt":"0"'+
            '}'+
    ']'+
            '},'+
'"WarrantyManualURL":"https://quickserve.cummins.com/qs3/portal/service/manual/en/4021290/?page=",'+
        '"BeginMiles":"0",'+
            '"EndMiles":"500000",'+
                '"ProcedureNumber":"111-505-065",'+
                    '"CertificateNumber":"TMC1000482",'+
                        '"ProgramID":"TMC",'+
            '"BeginHours":"0",'+
                '"EndHours":"0",'+
                    '"EndDate":"10/14/2018",'+
                        '"StartDate":"10/14/2013",'+
                            '"Months":"60",'+
                                '"CAPCoverageID":"CMC"'+
                                    '},'+
        '{'+
                                        '"ListOfExtCoverageDedutibles":{"ExtendedCoverageDedutibles":[]},'+
                                            '"WarrantyManualURL":"https://quickserve.cummins.com/qs3/portal/service/manual/en/4021290/?page=",'+
        '"BeginMiles":"0",'+
            '"EndMiles":"500000",'+
                '"ProcedureNumber":"111-505-106",'+
                    '"CertificateNumber":"TP21004642",'+
                        '"ProgramID":"TP2",'+
                            '"BeginHours":"0",'+
                                '"EndHours":"0",'+
                                    '"EndDate":"10/14/2018",'+
                                        '"StartDate":"10/14/2013",'+
                                            '"Months":"60",'+
                                                '"CAPCoverageID":"CRT"'+
            '}'+
    ']'+
            '}'+
            '}'+
            '}'+
            '}');
        }
        return res;
    }
}