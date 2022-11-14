@IsTest(SeeAllData=false)
public class CSM_IncidentSNOWUpdateService_Test {
	public static testMethod void CG_GetAccessTokenMethodTest() {
        string accessToken= null;
        list<CSS_Integration_Details__c> recs= new list<CSS_Integration_Details__c>();
        CSS_Integration_Details__c condetails = new CSS_Integration_Details__c();
        condetails.name='Mule Auth Token';
        condetails.ApplicationName__c='Mule Soft';
        condetails.AuthEnv__c='Mule Auth Token';
        condetails.End_Point__c='https://api-ue-devnf-aw-ex.cummins.com/api/core-security-api/v1/auth/token';
        condetails.grant_type__c='Refresh_full';
        condetails.IsActive__c=true;
        condetails.Key__c='7r7F6tyJlMmmC6JHSUMqK6dEUPvhL171LYrK6URZB3zKLO45503MD61NA8LTSTQCRvGn5Qroo3CkG7RRlFe9Bw==';
        condetails.Logging__c='BOTH';
        condetails.Method_Type__c='POST';
        condetails.Passcode__c='7r7F6tyJlMmmC6JHSUMqK6dEUPvhL171LYrK6URZB3zKLO45503MD61NA8LTSTQCRvGn5Qroo3CkG7RRlFe9Bw==';
        condetails.Timeout__c=120;
        condetails.Username__c='wQPYUk3iFjCz7sofEcwrXu+voqsIza/dbcO3QlGuxTVNg/ly+0Sy1nWe59U01nRfRW/q9ogg4q6LfncwdAZmBg==';
        recs.add(condetails);
        insert recs; 
       
        string json ='{"token_type":"Bearer","expires_in":"3600","ext_expires_in":"3600", "expires_on":"1562583448","not_before":"1562579548","resource":"https://api-ue-devnf-aw-ex.cummins.com/cmi-sp","access_token":"eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiIsIng1dCI6IkN0ZlFDOExlLThOc0M3b0MyelFrWnBjcmZPYyIsImtpZCI6IkN0ZlFDOExlLThOc0M3b0MyelFrWnBjcmZPYyJ9.eyJhdWQiOiJodHRwczovL2Fw"}';
        string json1= '{"Header":{"Target":{"TargetID":"TSR"},"Sender":{"ServiceName":"UpsertTSR","SenderID":"GUIDANZ"}},"DataArea":{"UOM":"","TechID":null,"Symptom":"559","SupportLevel":"Cummins CARE Level 1","Status":"Open","SRNumber":"","SPCode":"21933","ShopWO":"","RepeatVisit":"N","PSN":"79464646","MileageValue":"","GeneralSymptoms":"test v","FaultCodeStatus":null,"FaultCode":null,"FailureDate":"11/7/2017","EscalationText":"","EscalationGroup":"HMLD","CustomerName":"test","CSSJobID":"CSS-00070849","ContactPhoneNumber":"","ContactLastName":"Anirudh","ContactFirstName":"Pesari","ContactEmail":"pesari.anirudhcummins.com","ComplaintCode":"101","AttachmentURL":""}}';
        CG_CL_HttpRequestMock mock1 = new CG_CL_HttpRequestMock(200,'Complete',json,null);
        CG_CL_HttpRequestMock mock2 = new CG_CL_HttpRequestMock(200,'Complete',json1,null);
        Map<String, HttpCalloutMock> endpointsResponse =new Map<String,HttpCalloutMock>();
        endpointsResponse.put('https://api-ue-devnf-aw-ex.cummins.com/api/core-security-api/v1/auth/token',mock1);
        endpointsResponse.put('https://api-ue-devnf-aw-ex.cummins.com/api/core-security-api/v1/send/data',mock2);
        HttpCalloutMock multiCalloutMock =  new CG_CL_HTTPMultiRequestMock(endpointsResponse);
        Test.setMock(HttpCalloutMock.class, multiCalloutMock);
        CG_IP_OAGWrapper reqWrapper = new CG_IP_OAGWrapper();
        reqWrapper.jsonReqBody = '{"Header":{"Target":{"TargetID":"TSR"},"Sender":{"ServiceName":"UpsertTSR","SenderID":"GUIDANZ"}},"DataArea":{"UOM":"","TechID":null,"Symptom":"559","SupportLevel":"Cummins CARE Level 1","Status":"Open","SRNumber":"","SPCode":"21933","ShopWO":"","RepeatVisit":"N","PSN":"79464646","MileageValue":"","GeneralSymptoms":"test v","FaultCodeStatus":null,"FaultCode":null,"FailureDate":"11/7/2017","EscalationText":"","EscalationGroup":"HMLD","CustomerName":"test","CSSJobID":"CSS-00070849","ContactPhoneNumber":"","ContactLastName":"Anirudh","ContactFirstName":"Pesari","ContactEmail":"pesari.anirudhcummins.com","ComplaintCode":"101","AttachmentURL":""}}';
        reqWrapper.methodType = 'POST';
        reqWrapper.timeOut = 1;
        reqWrapper.serviceName = 'Mule Auth Token';
        reqWrapper.endPoint='https://api-ue-devnf-aw-ex.cummins.com/api/core-security-api/v1/send/data';
     
        //accessTokenOPWrap.exceptionFlag = true;
        CG_CL_HttpRequestMock mock3 = new CG_CL_HttpRequestMock(201,'Complete',json,null);
        CG_CL_HttpRequestMock mock4 = new CG_CL_HttpRequestMock(201,'Complete',json1,null);
        endpointsResponse.clear();
        endpointsResponse.put('https://api-ue-devnf-aw-ex.cummins.com/api/core-security-api/v1/auth/token',mock3);
        endpointsResponse.put('https://api-ue-devnf-aw-ex.cummins.com/api/core-security-api/v1/send/data',mock4);
        HttpCalloutMock multiCalloutMock1 =  new CG_CL_HTTPMultiRequestMock(endpointsResponse);
        Test.setMock(HttpCalloutMock.class, multiCalloutMock1);
           
        CG_OP_OAGWrapper accessTokenOPWrap = CG_WS_Mule.getAccessToken('ad724392-5594-4e85-b9eb-b0fc19c2fabe','CG_GetDiagTargetTime');
        accessToken=accessTokenOPWrap.accessToken;
       // Test.startTest();
                CSM_SNow_Initiator_wwid__mdt metaFile = new CSM_SNow_Initiator_wwid__mdt();
        metaFile.Service_Request_Origin__c = 'Email';
        metaFile.Initiator_wwid__c = 'OY876';
        Blob key = Blob.valueOf('12345678901234567890123456789012');
        string algo = 'AES256';
        
        CSS_Integration_Details__c inte = new CSS_Integration_Details__c();
        inte.Name = 'FSL_ServiceNow';
        inte.Username__c = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('test')));
        inte.Passcode__c = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('test')));
        inte.Key__c = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('1234')));
        inte.ApplicationName__c = 'FSL_ServiceNow';
        inte.End_Point__c = 'abc.com';
        inte.IsActive__c = true;
        inte.Method_Type__c = 'POST';
        insert inte;
         CSS_Integration_Details__c integrationDetails = new CSS_Integration_Details__c();
        integrationDetails.Name = 'FSL_ServiceNowUpdate';
        integrationDetails.Username__c = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('test')));
        integrationDetails.Passcode__c = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('test')));
        integrationDetails.Key__c = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('1234')));
        integrationDetails.ApplicationName__c = 'FSL_ServiceNowUpdate';
        integrationDetails.End_Point__c = 'abc.com';
        integrationDetails.IsActive__c = true;
        integrationDetails.Method_Type__c = 'POST';
        insert integrationDetails;
          CSM_IncidentSNOWUpdateService.getAuthenticationToken();
       // Test.stopTest();
     }

   public static testMethod void CSS_DoCalloutTestMethod() {
        string accessToken= null;
        list<CSS_Integration_Details__c> recs= new list<CSS_Integration_Details__c>();
        CSS_Integration_Details__c condetails = new CSS_Integration_Details__c();
        condetails.name='Mule Auth Token';
        condetails.ApplicationName__c='Mule Soft';
        condetails.AuthEnv__c='Mule Auth Token';
        condetails.End_Point__c='https://api-ue-devnf-aw-ex.cummins.com/api/core-security-api/v1/auth/token';
        condetails.grant_type__c='Refresh_full';
        condetails.IsActive__c=true;
        condetails.Key__c='7r7F6tyJlMmmC6JHSUMqK6dEUPvhL171LYrK6URZB3zKLO45503MD61NA8LTSTQCRvGn5Qroo3CkG7RRlFe9Bw==';
        condetails.Logging__c='BOTH';
        condetails.Method_Type__c='POST';
        condetails.Passcode__c='7r7F6tyJlMmmC6JHSUMqK6dEUPvhL171LYrK6URZB3zKLO45503MD61NA8LTSTQCRvGn5Qroo3CkG7RRlFe9Bw==';
        condetails.Timeout__c=120;
        condetails.Username__c='wQPYUk3iFjCz7sofEcwrXu+voqsIza/dbcO3QlGuxTVNg/ly+0Sy1nWe59U01nRfRW/q9ogg4q6LfncwdAZmBg==';
        recs.add(condetails);
        insert recs; 
       
        string json ='{"token_type":"Bearer","expires_in":"3600","ext_expires_in":"3600", "expires_on":"1562583448","not_before":"1562579548","resource":"https://api-ue-devnf-aw-ex.cummins.com/cmi-sp","access_token":"eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiIsIng1dCI6IkN0ZlFDOExlLThOc0M3b0MyelFrWnBjcmZPYyIsImtpZCI6IkN0ZlFDOExlLThOc0M3b0MyelFrWnBjcmZPYyJ9.eyJhdWQiOiJodHRwczovL2Fw"}';
        string json1= '{"Header":{"Target":{"TargetID":"TSR"},"Sender":{"ServiceName":"UpsertTSR","SenderID":"GUIDANZ"}},"DataArea":{"UOM":"","TechID":null,"Symptom":"559","SupportLevel":"Cummins CARE Level 1","Status":"Open","SRNumber":"","SPCode":"21933","ShopWO":"","RepeatVisit":"N","PSN":"79464646","MileageValue":"","GeneralSymptoms":"test v","FaultCodeStatus":null,"FaultCode":null,"FailureDate":"11/7/2017","EscalationText":"","EscalationGroup":"HMLD","CustomerName":"test","CSSJobID":"CSS-00070849","ContactPhoneNumber":"","ContactLastName":"Anirudh","ContactFirstName":"Pesari","ContactEmail":"pesari.anirudhcummins.com","ComplaintCode":"101","AttachmentURL":""}}';
        CG_CL_HttpRequestMock mock1 = new CG_CL_HttpRequestMock(200,'Complete',json,null);
        CG_CL_HttpRequestMock mock2 = new CG_CL_HttpRequestMock(200,'Complete',json1,null);
        Map<String, HttpCalloutMock> endpointsResponse =new Map<String,HttpCalloutMock>();
        endpointsResponse.put('https://api-ue-devnf-aw-ex.cummins.com/api/core-security-api/v1/auth/token',mock1);
        endpointsResponse.put('https://api-ue-devnf-aw-ex.cummins.com/api/core-security-api/v1/send/data',mock2);
        HttpCalloutMock multiCalloutMock =  new CG_CL_HTTPMultiRequestMock(endpointsResponse);
        Test.setMock(HttpCalloutMock.class, multiCalloutMock);
        CG_IP_OAGWrapper reqWrapper = new CG_IP_OAGWrapper();
        reqWrapper.jsonReqBody = '{"Header":{"Target":{"TargetID":"TSR"},"Sender":{"ServiceName":"UpsertTSR","SenderID":"GUIDANZ"}},"DataArea":{"UOM":"","TechID":null,"Symptom":"559","SupportLevel":"Cummins CARE Level 1","Status":"Open","SRNumber":"","SPCode":"21933","ShopWO":"","RepeatVisit":"N","PSN":"79464646","MileageValue":"","GeneralSymptoms":"test v","FaultCodeStatus":null,"FaultCode":null,"FailureDate":"11/7/2017","EscalationText":"","EscalationGroup":"HMLD","CustomerName":"test","CSSJobID":"CSS-00070849","ContactPhoneNumber":"","ContactLastName":"Anirudh","ContactFirstName":"Pesari","ContactEmail":"pesari.anirudhcummins.com","ComplaintCode":"101","AttachmentURL":""}}';
        reqWrapper.methodType = 'GET';
        reqWrapper.timeOut = 1;
        reqWrapper.serviceName = 'Mule Auth Token';
       // reqWrapper.endPoint='https://api-ue-devnf-aw-ex.cummins.com/api/core-security-api/v1/send/data';
     
        //accessTokenOPWrap.exceptionFlag = true;
        CG_CL_HttpRequestMock mock3 = new CG_CL_HttpRequestMock(201,'Complete',json,null);
        CG_CL_HttpRequestMock mock4 = new CG_CL_HttpRequestMock(201,'Complete',json1,null);
        endpointsResponse.clear();
        endpointsResponse.put('https://api-ue-devnf-aw-ex.cummins.com/api/core-security-api/v1/auth/token',mock3);
        endpointsResponse.put('https://api-ue-devnf-aw-ex.cummins.com/api/core-security-api/v1/send/data',mock4);
        HttpCalloutMock multiCalloutMock1 =  new CG_CL_HTTPMultiRequestMock(endpointsResponse);
        Test.setMock(HttpCalloutMock.class, multiCalloutMock1);
           
        CG_OP_OAGWrapper accessTokenOPWrap = CG_WS_Mule.getAccessToken('ad724392-5594-4e85-b9eb-b0fc19c2fabe','CG_GetDiagTargetTime');
        accessToken=accessTokenOPWrap.accessToken;
    
                CSM_SNow_Initiator_wwid__mdt metaFile1 = new CSM_SNow_Initiator_wwid__mdt();
        metaFile1.Service_Request_Origin__c = 'Email';
        metaFile1.Initiator_wwid__c = 'OY876';
        Blob key1 = Blob.valueOf('12345678901234567890123456789012');
        string algo = 'AES256';
        
        CSS_Integration_Details__c inte1 = new CSS_Integration_Details__c();
        inte1.Name = 'FSL_ServiceNow_Get';
        inte1.Username__c = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key1, Blob.valueOf('test')));
        inte1.Passcode__c = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key1, Blob.valueOf('test')));
        inte1.Key__c = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key1, Blob.valueOf('1234')));
        inte1.ApplicationName__c = 'FSL_ServiceNow_Get';
        inte1.End_Point__c = '{INC}'+'abc.com';
        inte1.IsActive__c = true;
        inte1.Method_Type__c = 'GET';
        insert inte1;
         CSS_Integration_Details__c integrationDetails1 = new CSS_Integration_Details__c();
        integrationDetails1.Name = 'FSL_ServiceNow_Get';
        integrationDetails1.Username__c = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key1, Blob.valueOf('test')));
        integrationDetails1.Passcode__c = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key1, Blob.valueOf('test')));
        integrationDetails1.Key__c = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key1, Blob.valueOf('1234')));
        integrationDetails1.ApplicationName__c = 'FSL_ServiceNow_Get';
        integrationDetails1.End_Point__c = '{INC}'+'abc.com';
        integrationDetails1.IsActive__c = true;
        integrationDetails1.Method_Type__c = 'GET';
        insert integrationDetails1;
        Account acc1 = new Account();
        acc1.name = 'Test Account';
        insert acc1;
       
         Case caseRec = new Case();
        caseRec.Origin = 'Email';
        caseRec.Subject = 'Test';
        caseRec.Description = 'testing Data';
        caseRec.AccountId=acc1.Id;
        insert caseRec;
       // List<Incident> inctlist = new List<Incident>();
      //  Incident inc1 = new Incident( CSM_Ticket_Incident_Number__c ='INC3547273', Subject='Test',Status ='New',Service_Request__c=caseRec.id);
        //inctlist.add(inc1);
       // Insert inctlist;
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());

       
        //Account acc2 = new Account();
       // acc2.name = 'Test Account';
       // insert acc2;
        
        
        Incident incidentRec = new Incident();
        incidentRec.CSM_Ticket_Config_Item__c = 'Middleware';
        incidentRec.Impact = '2';
        incidentRec.Urgency = '1';
        incidentRec.Description = 'Testing';
        incidentRec.CSM_Ticket_Incident_Number__c = '';
        incidentRec.Service_Request__c=caseRec.id;
        incidentRec.Status='New';
        incidentRec.Subject='Test Data';
        insert incidentRec;
        Test.starttest();
        HttpResponse result =CSM_IncidentSNOWUpdateService.doCallout(incidentRec,accessToken);
        String contentType = result.getHeader('Content-Type');
        System.assert(contentType == 'application/json');
        String actualValue = result.toString();
        String expectedValue = '{"Status":"In Queue"}';
        System.debug('expectedValue>>>' + expectedValue);
        //System.assertEquals(actualValue, expectedValue);
      //  System.assertEquals(200, result.getStatusCode()); 
       Test.stopTest();
    }
   //this comments use for Deployment purpose.Set Missing component
}