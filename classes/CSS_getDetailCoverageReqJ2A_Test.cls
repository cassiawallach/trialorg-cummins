@isTest
public class CSS_getDetailCoverageReqJ2A_Test {
static testMethod void testParse() {
    string json=        '{' +
      '  "Header": {' +
            '"Sender": {'+
               ' "ServiceName": "GetBasicCoverage",'+
                   ' "SenderID": "CSS" '+
                       ' },'+
                        '"Target": { '+
                         '"TargetID": "SIEBEL" '+
                          ' }'+
                           ' },'+
                            '  "DataArea": {'+
                             '  "ESN": "79464646",'+
                              ' "EngineApplicationCode": "130",'+
                               '"Region": "MEXICO",'+
                                ' "Territory": "MEXICO",'+
                                 ' "WarrantyStartDate": "10/14/2013",'+
                                  ' "PartsWarranty": "Y" '+
                                   ' }'+     
                                     '}'+
                                                   '';
                   CSS_getDetailCoverageReqJ2A.parse(json);
          
        
}
}