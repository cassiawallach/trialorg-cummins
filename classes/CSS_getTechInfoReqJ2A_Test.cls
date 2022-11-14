@IsTest
public class CSS_getTechInfoReqJ2A_Test {
    
    static testMethod void testParse() {
        String json = '{'+
        '   \"Header\": {'+
        '       \"Sender\": {'+
        '           \"ServiceName\": \"GetTechInfo\",'+
        '           \"SenderID\": \"CSS\"'+
        '       },'+
        '       \"Target\": {'+
        '           \"TargetID\": \"SIEBEL\"'+
        '       }'+
        '   },'+
        '   \"DataArea\": {'+
        '       \"SPCode\": \"23430\",'+
        '       \"QualProgIDs\": ['+
        '                           {'+
        '            \"QualProgId\" : \"123\"'+
        '                           },'+
        '                            {'+
        '            \"QualProgId\" : \"123\"'+
        '                           }'+
        '                    ]'+
        '   }'+
        '}';
        CSS_getTechInfoReqJ2A obj = CSS_getTechInfoReqJ2A.parse(json);
        System.assert(obj != null);
    }
}