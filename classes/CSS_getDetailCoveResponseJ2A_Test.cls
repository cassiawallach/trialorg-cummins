@isTest
public class CSS_getDetailCoveResponseJ2A_Test {
    static testMethod void testParse(){
        String json= '{'+
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
                                                       ' "CoverageHours":"6250",'+
                                                            '"CoverageDefenitionType":"BASE",'+
                                                              '  "CoverageMiles":"250000" '+
           '},'+
        '{'+
                                        '"MegawattHours":"0",'+
                                            '"CoverageMaxMonths":"60",'+
                                             '   "CoverageComponentTypeCode":"EXTENDED",'+
                                                    '"CoverageMinMonths":"0",'+
                                                       ' "CoverageHours":"12500",'+
                                                            '"CoverageDefenitionType":"EXTENDED",'+
                                                                '"CoverageMiles":"500000"'+
           '},'+
        '{'+
                                           '"MegawattHours":"0",'+
                                            '"CoverageMaxMonths":"24",'+
                                                '"CoverageComponentTypeCode":"INJECTOR",'+
                                                    '"CoverageMinMonths":"0",'+
                                                     '   "CoverageHours":"3125",'+
                                                            '"CoverageDefenitionType":"BASE",'+
                                                                '"CoverageMiles":"125000"'+
           '},'+
            '{'+
                                        '"MegawattHours":"0",'+
                                            '"CoverageMaxMonths":"12",'+
                                                '"CoverageComponentTypeCode":"BELTS/HOSES",'+
                                                    '"CoverageMinMonths":"0",'+
                                                        '"CoverageHours":"6250",'+
                                                            '"CoverageDefenitionType":"BASE",'+
                                                                '"CoverageMiles":"250000"'+
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
            '}'+
            '';
CSS_getDetailCoveResponseJ2A.parse(json);
                                                                                                                                                                
                             }
                                       
                            }