@isTest
public class CSS_getOverlapSRTReqJ2A_Test {
    static testMethod void testParse() {
        String json=        '{'+
        '   "Header": {'+
        '       "Sender": {'+
        '           "ServiceName": "GetOverlapSRT",'+
        '           "SenderID": "CSS"'+
        '       },'+
        '       "Target": {'+
        '           "TargetID": "SRT"'+
        '       }'+
        '   },'+
        '   "DataArea": {'+
        '       "Jobid": "CSS-000001234",'+
        '       "ClaimID": "C100002045",'+
        '       "Languagecode": "en",'+
        '       "DTTimestamp": "DD-MMM-YY HH:MI:SS AM",'+
        '       "EffectiveDTTime": "DD-MMM-YY HH:MI:SS AM",'+
        '       "Steps": ['+
        '           {'+
        '               "StepId": 1234,'+
        '               "Qty": 2,'+
        '               "AccessCode": "R"'+
        '           },'+
        '           {'+
        '               "StepId": 1235,'+
        '               "Qty": 1,'+
        '               "AccessCode": "B"'+
        '           }'+
        '       ]'+
        '   }'+
        '}'+
        '';
        CSS_getOverlapSRTReqJ2A.parse(json);
       
    }

}