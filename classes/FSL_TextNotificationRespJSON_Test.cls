@isTest
public class FSL_TextNotificationRespJSON_Test {
           
     static testmethod void testParse() {
        String json=        '{'+
        '    "CustCommunicationResp": ['+
        '        {'+
        '            "MessageIdentifier": "2-948724f0-cf8b-11ea-ab89-02c39419982e",'+
        '            "ReturnCode": "sms",'+
        '            "ReturnCodeDescription": "SMS sent successfully to +13304027474",'+
        '            "Status": "SUCCESS",'+
        '            "MessageType": "S"'+
        '        }'+
        '    ]'+
        '}';
        
         FSL_TextNotificationRespJSON obj = FSL_TextNotificationRespJSON.parse(json);
    }
           
}