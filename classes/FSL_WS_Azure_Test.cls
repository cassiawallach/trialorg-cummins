//Comment added for deployment sept 2022
/*
* Test Class for Apex Controller - FSL_WS_Azure
* Author - Piyush Rani
*/ 
@isTest
public class FSL_WS_Azure_Test {
    @isTest
    static void testAzureService(){
        list<CSS_Integration_Details__c> recs= new list<CSS_Integration_Details__c>();
        CSS_Integration_Details__c condetails = new CSS_Integration_Details__c();
        condetails.name='QSOL Auth Token';
        condetails.ApplicationName__c='QSOL Soft';
        condetails.AuthEnv__c='QSOL Auth Tokens';
        condetails.End_Point__c='https://api-ue-devnf-aw-ex.cummins.com/api/core-security-api/v1/auth/token';
        condetails.grant_type__c='Refresh_full';
        condetails.IsActive__c=true;
        condetails.Key__c='7r7F6tyJlMmmC6JHSUMqK6dEUPvhL172LYrK6URZB3zKLO45503MD61NA8STQCRvGn7Qroo3CkG7RRlFe9Bw==';
        condetails.Logging__c='BOTH';
        condetails.Method_Type__c='POST';
        condetails.Passcode__c='7r7F6tyJlMmmC6JHSUMqK6dEUPvhL172LYrK6URZB3zKLO45503MD61NA8LSTQCRvGn7Qroo3CkG7RRlFe9Bw==';
        condetails.Timeout__c=120;
        condetails.Username__c='wQPYUk3iFjCz7sofEcwrXu+voqsIza/dbcO5QlGuxTVNg/ly+0Sy1nWe57U01ngfRWq9ogg3q6LfncwdAZmBg==';
        recs.add(condetails);
        CSS_Integration_Details__c condetails1 = new CSS_Integration_Details__c();
        condetails1.name='GetEngineDataPlateQSOLREST';
        condetails1.ApplicationName__c='QSOL Soft';
        condetails1.AuthEnv__c='QSOL Auth Token';
        condetails1.End_Point__c='https://api-ue-devnf-aw-ex.cummins.com/api/core-security-api/v1/send/data';
        condetails1.grant_type__c='Refresh_full';
        condetails1.IsActive__c=true;
        condetails1.Key__c='7r7F6tyJlMmmC6JHSUMqK6dEUPvhL171LYrK6URZB3zKLO45503MD61NA8LTSTQCRvGn5Qroo3CkG7RRlFe9Bw==';
        condetails1.Logging__c='BOTH';
        condetails1.Method_Type__c='POST';
        condetails1.Passcode__c='7r7F6tyJlMmmC6JHSUMqK6dEUPvhL171LYrK6URZB3zKLO45503MD61NA8LTSTQCRvGn5Qroo3CkG7RRlFe9Bw==';
        condetails1.Timeout__c=120;
        condetails1.Username__c='wQPYUk3iFjCz7sofEcwrXu+voqsIza/dbcO3QlGuxTVNg/ly+0Sy1nWe59U01nRfRW/q9ogg4q6LfncwdAZmBg==';
        recs.add(condetails1);
        insert recs; 
        string json='{ "token_type": "Bearer", "expires_in": "3600", "ext_expires_in": "3600", "expires_on": "1561467793", "not_before": "1561463893", "resource": "https://api-ue-devnf-aw-ex.cummins.com/cmi-sp", "access_token": "eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiIsIng1" }';
        string json1  ='[{ "documentNum":"ATC1943", "documentDesc":"ISX15 CM2350 FUEL PUMP TAPPET ATC FOR RYDER","type":"TSB","language":"en","status":"OPEN","documentLink":"https://qs-stg.cummins.com/qs3/pubsys2/xml/en/atc/2019/atc1943.html"}, { "documentNum":"ATC1943", "documentDesc":"ISX15 CM2350 FUEL PUMP TAPPET ATC FOR RYDER","type":"TRP","language":"en","status":"OPEN","documentLink":"https://qs-stg.cummins.com/qs3/pubsys2/xml/en/atc/2019/atc1943.html"},{ "documentNum":"ATC1943", "documentDesc":"ISX15 CM2350 FUEL PUMP TAPPET ATC FOR RYDER","type":"ATC","language":"en","status":"OPEN","documentLink":"https://qs-stg.cummins.com/qs3/pubsys2/xml/en/atc/2019/atc1943.html"},{"documentNum":"ATC1943", "documentDesc":"ISX15 CM2350 FUEL PUMP TAPPET ATC FOR RYDER","type":"CAMPAIGN","language":"en","status":"OPEN", "documentLink":"https://qs-stg.cummins.com/qs3/pubsys2/xml/en/atc/2019/atc1943.html" }]';
        CG_CL_HttpRequestMock mock1 = new CG_CL_HttpRequestMock(200,'Complete',json,null);
        CG_CL_HttpRequestMock mock2 = new CG_CL_HttpRequestMock(200,'Complete',json1,null);
        CG_CL_HttpRequestMock mock3 = new CG_CL_HttpRequestMock(202,'Complete',json1,null);
        Map<String, HttpCalloutMock> endpointsResponse =new Map<String,HttpCalloutMock>();
        endpointsResponse.put('https://api-ue-devnf-aw-ex.cummins.com/api/core-security-api/v1/auth/token',mock1);
        endpointsResponse.put('https://api-ue-devnf-aw-ex.cummins.com/api/core-security-api/v1/send/datanull',mock2);
        HttpCalloutMock multiCalloutMock =  new CG_CL_HTTPMultiRequestMock(endpointsResponse);
        Test.setMock(HttpCalloutMock.class, multiCalloutMock);
        test.startTest();
        FSL_IP_OAGWrapper reqWrapper = new FSL_IP_OAGWrapper();
        reqWrapper.serviceName='GetEngineDataPlateQSOLREST';
        reqWrapper.jsonReqBody='{"filename":"filename"}';
        FSL_WS_Azure.calloutGeneric(reqWrapper);
        endpointsResponse.clear();
        endpointsResponse.put('https://api-ue-devnf-aw-ex.cummins.com/api/core-security-api/v1/auth/token',mock1);
        endpointsResponse.put('https://api-ue-devnf-aw-ex.cummins.com/api/core-security-api/v1/send/datanull',mock3);
        HttpCalloutMock multiCalloutMock1 =  new CG_CL_HTTPMultiRequestMock(endpointsResponse);
        Test.setMock(HttpCalloutMock.class, multiCalloutMock1);
        FSL_IP_OAGWrapper reqWrapper1 = new FSL_IP_OAGWrapper();
        reqWrapper1.serviceName='GetEngineDataPlateQSOLREST';
        reqWrapper1.jsonReqBody='{"filename":"filename"}';
        FSL_WS_Azure.calloutGeneric(reqWrapper1);
        test.stopTest();
    }
    
    @isTest
    static void testAzureServicecatches(){
        FSL_IP_OAGWrapper reqWrapper1 = new FSL_IP_OAGWrapper();
        reqWrapper1.serviceName='GetEngineDataPlateQSOLREST';
        reqWrapper1.jsonReqBody='{"filename":"filename"}';
        FSL_WS_Azure.calloutGeneric(reqWrapper1);
    }
    
    @isTest
    static void testAzureServicecatches1(){
        CSS_Integration_Details__c condetails = new CSS_Integration_Details__c();
        condetails.name='QSOL Auth Token';
        condetails.ApplicationName__c='QSOL Soft';
        condetails.AuthEnv__c='QSOL Auth Tokens';
        condetails.End_Point__c='https://api-ue-devnf-aw-ex.cummins.com/api/core-security-api/v1/auth/token';
        condetails.grant_type__c='Refresh_full';
        condetails.IsActive__c=true;
        condetails.Key__c='7r7F6tyJlMmmC6JHSUMqK6dEUPvhL172LYrK6URZB3zKLO45503MD61NA8STQCRvGn7Qroo3CkG7RRlFe9Bw==';
        condetails.Logging__c='BOTH';
        condetails.Method_Type__c='POST';
        condetails.Passcode__c='7r7F6tyJlMmmC6JHSUMqK6dEUPvhL172LYrK6URZB3zKLO45503MD61NA8LSTQCRvGn7Qroo3CkG7RRlFe9Bw==';
        condetails.Timeout__c=120;
        condetails.Username__c='wQPYUk3iFjCz7sofEcwrXu+voqsIza/dbcO5QlGuxTVNg/ly+0Sy1nWe57U01ngfRWq9ogg3q6LfncwdAZmBg==';
        insert condetails;
        string json='{ "token_type": "Bearer", "expires_in": "3600", "ext_expires_in": "3600", "expires_on": "1561467793", "not_before": "1561463893", "resource": "https://api-ue-devnf-aw-ex.cummins.com/cmi-sp", "access_token": "eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiIsIng1" }';
        CG_CL_HttpRequestMock mock1 = new CG_CL_HttpRequestMock(200,'Complete',json,null);
        Map<String, HttpCalloutMock> endpointsResponse =new Map<String,HttpCalloutMock>();
        endpointsResponse.put('https://api-ue-devnf-aw-ex.cummins.com/api/core-security-api/v1/auth/tokensd',mock1);
        HttpCalloutMock multiCalloutMock =  new CG_CL_HTTPMultiRequestMock(endpointsResponse);
        Test.setMock(HttpCalloutMock.class, multiCalloutMock);
        FSL_WS_Azure.getAccessToken('QSOL Auth Token');
    } 
}