@isTest
public class CSS_GetRSWControlNumber_Test {
    public static testmethod void updateJobOrderData()
    {
        Test.startTest();
        List<CSS_Job_Order__c> SJobs = new List<CSS_Job_Order__c>();
        Integer i;
        string endPoint;
        for(i=0;i<3;i++)
        {       
            CSS_Job_Order__c recJO = new CSS_Job_Order__c();
            recJO.Customer_Name__c='TestJob' + i;
            recJO.Status__c='INTAKE';
            if (i==1) {recJO.Status__c='CLOSED';}
            if (i==2) {recJO.Control_Number__c = '["1234567"]';}
            SJobs.add(recJO);
        }
        insert SJobs;
        system.debug('SJobs ## ' + SJobs);
        List<Id> SJobsId = new List<Id>();
        for (CSS_Job_Order__c recsJobs: SJobs) {
            SJobsId.add(recsJobs.Id);
        }
        system.debug('SJobsId ## ' + SJobsId);
        List<CSS_Job_Order__c> lstJobs = new List<CSS_Job_Order__c>([Select Id, Name, ESN__c,Status__c,Control_Number__c   from CSS_Job_Order__c where Id = :sJobsId]);
        system.debug('lstJobs ## ' + lstJobs);
        //Create JSON to call Service
        String sJSONReq = '{'+
            '  \"DataArea\": {'+
            '    \"CSSJobIdRecords\": {'+
            '      \"CSSJobIdRecord\": ['+
            '        {'+
            '          \"CSSJobId\": \"' + lstJobs[0].Name +'\",'+
            '          \"ControlNumbers\": {'+
            '            \"ControlNumber\": ['+
            '             \"111111\",'+
            '              \"22222\"'+
            '            ]'+
            '          }'+
            '        },'+
            '        {'+
            '          \"CSSJobId\": \"' + lstJobs[1].Name + '\",'+
            '          \"ControlNumbers\": {'+
            '            \"ControlNumber\": ['+
            '              \"33333\"]'+
            '          }'+
            '        },'+
            '        {'+
            '          \"CSSJobId\": \"' + lstJobs[2].Name + '\",'+
            '          \"ControlNumbers\": {'+
            '            \"ControlNumber\": ['+
            '              \"33333\"]'+
            '          }'+
            '        },' +
            '        {'+
            '          \"CSSJobId\": \"C-GYAN\",'+
            '          \"ControlNumbers\": {'+
            '            \"ControlNumber\": ['+
            '              \"33333\"]'+
            '          }'+
            '        }' +
            '      ]'+
            '    }'+
            '  }'+
            '}';
        system.debug('sJSONReq ## ' + sJSONReq);
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        req.addHeader('Content-Type', 'application/json');
        req.requestURI = '/services/apexrest/RSW/V02/CSS/ControlNumber/';  //Request URL
        req.httpMethod = 'PUT';//HTTP Request Type
        req.requestBody = Blob.valueof(sJSONReq);
        RestContext.request = req;
        RestContext.response= res;
        
        CSS_GetRSWControlNumber.updateJobOrderData();

        //Second Test for Null JSON
        RestRequest req1 = new RestRequest(); 
        RestResponse res1 = new RestResponse();
        req1.addHeader('Content-Type', 'application/json');
        req1.requestURI = '/services/apexrest/RSW/V02/CSS/ControlNumber/';  //Request URL
        req1.httpMethod = 'PUT';//HTTP Request Type
        req1.requestBody = Blob.valueof('Null');
        RestContext.request = req1;
        RestContext.response= res1;
        
        CSS_GetRSWControlNumber.updateJobOrderData();
        //Error Test for Malformed JSON

        RestRequest req2 = new RestRequest(); 
        RestResponse res2 = new RestResponse();
        req2.addHeader('Content-Type', 'application/json');
        req2.requestURI = '/services/apexrest/RSW/V02/CSS/ControlNumber/';  //Request URL
        req2.httpMethod = 'PUT';//HTTP Request Type
        req2.requestBody = Blob.valueof('{["C002345"}');
        RestContext.request = req2;
        RestContext.response= res2;
        
        CSS_GetRSWControlNumber.updateJobOrderData();
        test.stopTest();
    }   
}