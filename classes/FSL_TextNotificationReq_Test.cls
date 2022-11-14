@isTest
public class FSL_TextNotificationReq_Test {
    
    static testMethod void testParse() {
        String json=        '{'+
        '   "Header":{'+
        '      "Target":{'+
        '         "TargetPhoneNumber":"",'+
        '         "TargetEmailCcAddress":"",'+
        '         "TargetEmailBccAddress":"",'+
        '         "TargetEmailAddress":""'+
        '      },'+
        '      "Source":{'+
        '         "SenderID":"Guidanz",'+
        '         "FromEmailAddress":"DONOTREPLY@cummins.com"'+
        '      },'+
        '      "Language":"FR",'+
        '      "EventType":"Service_Status_Change",'+
        '      "Action":"sms"'+
        '   },'+
        '   "DataArea":{'+
        '      "WorkOrderNumber":"00002720",'+
        '      "ServiceStatus":"Diagnostics have started. A Service Team Member will notify you with an update when completed.",'+
        '      "NotificationSubject":"Cummins Service Update",'+
        '      "BranchContact":{'+
        '         "SupervisorContact":"",'+
        '         "PhoneNumber":"",'+
        '         "Address":"North Interstate 35"'+
        '      },'+
        '      "AssetDetails":{'+
        '         "VIN":"7EN778584",'+
        '         "Unit":"CONVENTIONAL",'+
        '         "ProductSerialNumber":"",'+
        '         "Model":"PROSTAR",'+
        '         "Make":"INTERNATIONAL"'+
        '      }'+
        '   }'+
        '}';
        FSL_TextNotificationReq obj = FSL_TextNotificationReq.parse(json);
        System.assert(obj != null);
    }
}