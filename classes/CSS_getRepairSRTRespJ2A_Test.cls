@isTest
public class CSS_getRepairSRTRespJ2A_Test { 
    static testMethod void testParse() {
        String json=        '{'+
        '   "Header": {'+
        '       "MessageIdentifier": "Identifier from MW",'+
        '       "ReturnCode": "<MessageCode from SRT>",'+
        '       "ReturnCodeDescription": "<Message from SRT>",'+
        '       "Status": "Success",'+
        '       "MessageType": "<Message Type From SRT>"'+
        '   },'+
        '   "DataArea": ['+
        '       {'+
        '           "FailureID": "F19000580",'+
        '           "FailureName": "Thermostat",'+
        '           "SRTDetail": "19-360-00",'+
        '           "SRTTitle": "Steam Clean –single component",'+
        '           "SRTDesc": "Disconnect and Connect Connector halves, if applicable",'+
        '           "AccessCode": "A",'+
        '           "SRTTime": 0.1,'+
        '           "Quantity": 2,'+
        '           "Assignment": "PRIMARY",'+
        '           "SRTMessage": "<text>"'+
        '       },'+
        '       {'+
        '           "FailureID": "F19000678",'+
        '           "FailureName": "Thermostat",'+
        '           "SRTDetail": "19-360-00",'+
        '           "SRTTitle": "Steam Clean –single component",'+
        '           "SRTDesc": "Disconnect and Connect Connector halves, if applicable",'+
        '           "AccessCode": "A",'+
        '           "SRTTime": 0.1,'+
        '           "Quantity": 2,'+
        '           "Assignment": "PRIMARY",'+
        '           "SRTMessage": "<text>"'+
        '       }'+
        '   ]'+
        '}'+
        '';
        CSS_getRepairSRTRespJ2A.parse(json);
    
}
}