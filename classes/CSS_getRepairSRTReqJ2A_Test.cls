@isTest
public class CSS_getRepairSRTReqJ2A_Test {  
    static testMethod void testParse() {
        String json=        '{'+
        '   "Header": {'+
        '       "Sender": {'+
        '           "ServiceName": "GetRepairSRT",'+
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
        '       "EngineFamilyCode": "10",'+
        '       "ServiceModelName": " ISX15 CM2350 X101",'+
        '       "EquipmentID": " EQ1234",'+
        '       "FailureID": ['+
        '           "F19000580",'+
        '           "F19000678"'+
        '       ],'+
        '       "DTTimestamp": "DD-MMM-YY HH:MI:SS AM"'+
        '   }'+
        '}'+
        '';
      CSS_getRepairSRTReqJ2A.parse(json);
        
    }
}