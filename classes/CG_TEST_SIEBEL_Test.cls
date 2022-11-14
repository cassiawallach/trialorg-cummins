@isTest
public class CG_TEST_SIEBEL_Test {
    
    static testMethod void AccessTokenMethod(){
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new CG_TEST_SIEBEL_Mock());
        CG_TEST_SIEBEL.AccessToken();
        Test.stopTest();
    }
    
    static testMethod void calloutTechinfoMethod(){
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new CG_TEST_SIEBEL_Mock());
        CG_TEST_SIEBEL.calloutTechinfo('Techinfo','lastProcessedDate');
        
        CG_IP_OAGWrapper reqWrapper = new CG_IP_OAGWrapper();
        
        CSS_Integration_Details__c inte3 = new CSS_Integration_Details__c();
        Blob key3 = Blob.valueOf('12345678901234567890123456789012');
        string algo3 = 'AES256';
        inte3.Name = 'CSS_SBL_FailModes';
        inte3.Username__c = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key3, Blob.valueOf('test')));
        inte3.Passcode__c = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key3, Blob.valueOf('test')));
        inte3.Key__c = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key3, Blob.valueOf('1234')));
        inte3.ApplicationName__c = 'GetCampaign';
        inte3.End_Point__c = 'https://services-stg.cummins.com/csswarranty/serviceproviderdata';
        inte3.IsActive__c = true;
        inte3.AuthEnv__c='OAGOAuthTest';
        insert inte3;
        
        CG_OP_OAGWrapper accessTokenOPWrap = CG_TEST_SIEBEL.getAccessToken(inte3.AuthEnv__c);
        CG_TEST_SIEBEL.calloutGeneric(reqWrapper);
        CG_TEST_SIEBEL.AccessToken();
        Test.stopTest();
    }
    
    static testMethod void calloutTechinfoMethod1(){
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new CG_TEST_SIEBEL_Mock1());
        CG_TEST_SIEBEL.calloutTechinfo('abc','lastProcessedDate');
        CG_TEST_SIEBEL.AccessToken();
        Test.stopTest();
    }
    
    static testMethod void getAccessTokenMethod(){
        Test.startTest();
        CG_IP_OAGWrapper reqWrapper = new CG_IP_OAGWrapper();
        
        Test.setMock(HttpCalloutMock.class, new CG_TEST_SIEBEL_Mock());
        //Test.setMock(HttpCalloutMock.class, new CSS_AccessToken_SRT_Test());
        CG_TEST_SIEBEL.getAccessToken('serviceName');
        //CG_TEST_SIEBEL.calloutGeneric(reqWrapper);
        CG_TEST_SIEBEL.AccessToken();
        Test.stopTest();
    }
    
    static testMethod void calloutGenericMethod(){
        
        
        Test.startTest();
        
        CG_IP_OAGWrapper reqWrapper = new CG_IP_OAGWrapper();
        reqWrapper.jsonReqBody = '{"Header":{"Target":{"TargetID":"TSR"},"Sender":{"ServiceName":"UpsertTSR","SenderID":"GUIDANZ"}},"DataArea":{"UOM":"","TechID":null,"Symptom":"559","SupportLevel":"Cummins CARE Level 1","Status":"Open","SRNumber":"","SPCode":"21933","ShopWO":"","RepeatVisit":"N","PSN":"79464646","MileageValue":"","GeneralSymptoms":"test v","FaultCodeStatus":null,"FaultCode":null,"FailureDate":"11/7/2017","EscalationText":"","EscalationGroup":"HMLD","CustomerName":"test","CSSJobID":"CSS-00070849","ContactPhoneNumber":"","ContactLastName":"Anirudh","ContactFirstName":"Pesari","ContactEmail":"pesari.anirudhcummins.com","ComplaintCode":"101","AttachmentURL":""}}';
        reqWrapper.methodType = 'POST';
        reqWrapper.timeOut = 1;
		reqWrapper.serviceName = 'TSR';
		
		CSS_Integration_Details__c inte3 = new CSS_Integration_Details__c();
        Blob key3 = Blob.valueOf('12345678901234567890123456789012');
        string algo3 = 'AES256';
        inte3.Name = 'TSR';
        inte3.Username__c = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key3, Blob.valueOf('test')));
        inte3.Passcode__c = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key3, Blob.valueOf('test')));
        inte3.Key__c = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key3, Blob.valueOf('1234')));
        inte3.ApplicationName__c = 'TSR';
        inte3.End_Point__c = 'https://services-test.cummins.com/css/technicianservicerequest';
        inte3.IsActive__c = true;
        inte3.AuthEnv__c='OAGOAuthTest';
        insert inte3;
		
       CG_OP_OAGWrapper  outputWrapper = CG_TEST_SIEBEL.calloutGeneric(reqWrapper);
        
        
      
        
        //CG_OP_OAGWrapper accessTokenOPWrap = CG_TEST_SIEBEL.getAccessToken(inte3.AuthEnv__c);
        // CSS_Integration_Details__c conDetails = CSS_Integration_Details__c.getValues('CSS_SBL_FailModes');
        //CG_OP_OAGWrapper accessTokenOPWrap = CG_TEST_SIEBEL.getAccessToken('CSS_SBL_FailModes');
        //system.debug('**accessTokenOPWrapMIR**'+accessTokenOPWrap);
        // system.debug('======>'+outputWrapper);
        Test.setMock(HttpCalloutMock.class, new CG_TEST_SIEBEL_Mock());
        CG_TEST_SIEBEL.AccessToken();
        CG_TEST_SIEBEL.calloutGeneric(reqWrapper);
        
        Test.stopTest();
    }
    
    static testMethod void SiebelMethod(){
        list<CSS_Integration_Details__c> recs= new list<CSS_Integration_Details__c>();
        CSS_Integration_Details__c condetails = new CSS_Integration_Details__c();
        condetails.name='TestSieble1';
        condetails.ApplicationName__c='Mule Soft';
        condetails.AuthEnv__c='TestSieble1';
        condetails.End_Point__c='https://api-ue-devnf-aw-ex.cummins.com/api/core-security-api/v1/auth/token';
        condetails.grant_type__c='Refresh_full';
        condetails.IsActive__c=true;
        condetails.Key__c='https://api-ue-devnf-aw-ex.cummins.com/cmi-sp';
        condetails.Logging__c='BOTH';
        condetails.Method_Type__c='POST';
        condetails.Passcode__c='7r7F6tyJlMmmC6JHSUMqK6dEUPvhL171LYrK6URZB3zKLO45503MD61NA8LTSTQCRvGn5Qroo3CkG7RRlFe9Bw==';
        condetails.Timeout__c=120;
        condetails.Username__c='wQPYUk3iFjCz7sofEcwrXu+voqsIza/dbcO3QlGuxTVNg/ly+0Sy1nWe59U01nRfRW/q9ogg4q6LfncwdAZmBg==';
        recs.add(condetails);
        CSS_Integration_Details__c condetails1 = new CSS_Integration_Details__c();
        condetails1.name='TestSieble';
        condetails1.ApplicationName__c='Mule Soft';
        condetails1.AuthEnv__c='ad724392-5594-4e85-b9eb-b0fc19c2fabe';
        condetails1.End_Point__c='https://api-ue-devnf-aw-ex.cummins.com/api/core-security-api/v1/auth/token';
        condetails1.grant_type__c='Refresh_full';
        condetails1.IsActive__c=true;
        condetails1.Key__c='https://api-ue-devnf-aw-ex.cummins.com/cmi-sp';
        condetails1.Logging__c='BOTH';
        condetails1.Method_Type__c='POST';
        condetails1.Passcode__c='7r7F6tyJlMmmC6JHSUMqK6dEUPvhL171LYrK6URZB3zKLO45503MD61NA8LTSTQCRvGn5Qroo3CkG7RRlFe9Bw==';
        condetails1.Timeout__c=120;
        condetails1.Username__c='wQPYUk3iFjCz7sofEcwrXu+voqsIza/dbcO3QlGuxTVNg/ly+0Sy1nWe59U01nRfRW/q9ogg4q6LfncwdAZmBg==';
        recs.add(condetails1);
        insert recs; 
        Test.startTest();  
        string json ='{"token_type":"Bearer","expires_in":"3600","ext_expires_in":"3600", "expires_on":"1562583448","not_before":"1562579548","resource":"https://api-ue-devnf-aw-ex.cummins.com/cmi-sp","access_token":"eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiIsIng1dCI6IkN0ZlFDOExlLThOc0M3b0MyelFrWnBjcmZPYyIsImtpZCI6IkN0ZlFDOExlLThOc0M3b0MyelFrWnBjcmZPYyJ9.eyJhdWQiOiJodHRwczovL2Fw"}';
        string json1= '{"Header":{"Target":{"TargetID":"TSR"},"Sender":{"ServiceName":"UpsertTSR","SenderID":"GUIDANZ"}},"DataArea":{"UOM":"","TechID":null,"Symptom":"559","SupportLevel":"Cummins CARE Level 1","Status":"Open","SRNumber":"","SPCode":"21933","ShopWO":"","RepeatVisit":"N","PSN":"79464646","MileageValue":"","GeneralSymptoms":"test v","FaultCodeStatus":null,"FaultCode":null,"FailureDate":"11/7/2017","EscalationText":"","EscalationGroup":"HMLD","CustomerName":"test","CSSJobID":"CSS-00070849","ContactPhoneNumber":"","ContactLastName":"Anirudh","ContactFirstName":"Pesari","ContactEmail":"pesari.anirudhcummins.com","ComplaintCode":"101","AttachmentURL":""}}';
        CG_CL_HttpRequestMock mock1 = new CG_CL_HttpRequestMock(200,'Complete',json,null);
        //CG_CL_HttpRequestMock mock2 = new CG_CL_HttpRequestMock(200,'Complete',json1,null);
        Test.setMock(HttpCalloutMock.class, new CG_TEST_SIEBEL_Mock());
        Map<String, HttpCalloutMock> endpointsResponse =new Map<String,HttpCalloutMock>();
        endpointsResponse.put('https://api-ue-devnf-aw-ex.cummins.com/api/core-security-api/v1/auth/token',mock1);
        //endpointsResponse.put('https://api-ue-devnf-aw-ex.cummins.com/api/core-security-api/v1/send/data',mock2);
        HttpCalloutMock multiCalloutMock =  new CG_CL_HTTPMultiRequestMock(endpointsResponse);
        Test.setMock(HttpCalloutMock.class, multiCalloutMock);
        Test.setMock(HttpCalloutMock.class, new CG_TEST_SIEBEL_Mock());
        CG_IP_OAGWrapper reqWrapper = new CG_IP_OAGWrapper();
        reqWrapper.jsonReqBody = '{"Header":{"Target":{"TargetID":"TSR"},"Sender":{"ServiceName":"UpsertTSR","SenderID":"GUIDANZ"}},"DataArea":{"UOM":"","TechID":null,"Symptom":"559","SupportLevel":"Cummins CARE Level 1","Status":"Open","SRNumber":"","SPCode":"21933","ShopWO":"","RepeatVisit":"N","PSN":"79464646","MileageValue":"","GeneralSymptoms":"test v","FaultCodeStatus":null,"FaultCode":null,"FailureDate":"11/7/2017","EscalationText":"","EscalationGroup":"HMLD","CustomerName":"test","CSSJobID":"CSS-00070849","ContactPhoneNumber":"","ContactLastName":"Anirudh","ContactFirstName":"Pesari","ContactEmail":"pesari.anirudhcummins.com","ComplaintCode":"101","AttachmentURL":""}}';
        reqWrapper.methodType = 'POST';
        reqWrapper.timeOut = 1;
        reqWrapper.serviceName = 'TestSieble1';
        CG_OP_OAGWrapper accessTokenOPWrap =CG_TEST_SIEBEL.getAccessToken(conDetails1.AuthEnv__c);
        system.debug('**accessTokenOPWrapMIR2**'+accessTokenOPWrap);
        CG_TEST_SIEBEL.calloutGeneric(reqWrapper);
        //CG_CL_HttpRequestMock mock3 = new CG_CL_HttpRequestMock(201,'Complete',json,null);
        //CG_CL_HttpRequestMock mock4 = new CG_CL_HttpRequestMock(201,'Complete',json1,null);
        //endpointsResponse.clear();
        //endpointsResponse.put('https://api-ue-devnf-aw-ex.cummins.com/api/core-security-api/v1/auth/token',mock3);
        //endpointsResponse.put('https://api-ue-devnf-aw-ex.cummins.com/api/core-security-api/v1/send/data',mock4);
        //HttpCalloutMock multiCalloutMock1 =  new CG_CL_HTTPMultiRequestMock(endpointsResponse);
        Test.setMock(HttpCalloutMock.class, new CG_TEST_SIEBEL_Mock());
        //Test.setMock(HttpCalloutMock.class, multiCalloutMock1);
        CG_OP_OAGWrapper accessTokenOPWrap3 =CG_TEST_SIEBEL.getAccessToken(conDetails.AuthEnv__c);
        CG_TEST_SIEBEL.calloutGeneric(reqWrapper);
        //CG_CL_HTTPMultiRequestMock multiCalloutMock8=  new CG_CL_HTTPMultiRequestMock(endpointsResponse);
        //multiCalloutMock8.addRequestMock('https://api-ue-devnf-aw-ex.cummins.com/api/core-security-api/v1/auth/token',multiCalloutMock8);
        Test.stopTest();
    } 
    
    public static testmethod void exceptionMethod(){
        Test.startTest();
        try{
            CG_OP_OAGWrapper obj =  CG_TEST_SIEBEL.calloutTechinfo(null,null);
        }catch(Exception e){
            
        }
    }
}