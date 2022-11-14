@isTest
public class CSS_WS_QSOL_Test {
    
    static testmethod void QSOLRestCallMethod()
    {
        CSS_Integration_Details__c conDetails = new CSS_Integration_Details__c();
        conDetails.Name = 'GetEngineDataPlateQSOLREST';
        conDetails.AuthEnv__c = 'OAGOAUTH';
        conDetails.ApplicationName__c = 'GetEngineDataPlateQSOLREST';
        conDetails.End_Point__c = 'Test';
        conDetails.Method_Type__c = 'POST';
        conDetails.Username__c = 'POST';
        conDetails.Passcode__c = 'POST';
        conDetails.Timeout__c = 2.0;
        insert conDetails;
       // Test.setMock(HttpCalloutMock.class, new CG_WS_QSOLMock());
        //Test.setMock(HttpCalloutMock.class, new CG_J2AQsolTokenMock());
        string json = '{"apiToken":"eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ"}';
        string json1 ='{"engineSerialNumber":"79462241","data":[{"vin":"1NPTX4EX3CD137011","marketingEngineModel":"ISX15 450","serviceEngineModel":"ISX15 CM2250","epaModelName":"BCEXH0912XAP","engineBuildPlant":"JEP - JAMESTOWN ENGINE PLANT","engineBuildDate":"2011-02-23T00:00:00Z","warrantyStartDate":"2012-03-16T00:00:00Z","ecmCode":"CL10135","fuelPumpPartNumber":"4088507","fuelPumpCalibration":"P846","marketingConfig":"D103009BB09","technicalConfig":"D103009BX03","cplNumber":"CPL3719","customerNumber":"1608","shopOrder":"SO33045","businessUnit":"EBU"}]}';
        CG_CL_HttpRequestMock token = new CG_CL_HttpRequestMock(200,'Complete',json,null);
        CG_CL_HttpRequestMock req1 = new CG_CL_HttpRequestMock(200,'Complete',json1,null);
        Map<String, HttpCalloutMock> endpointsResponse =new Map<String,HttpCalloutMock>();
        endpointsResponse.put('https://api-ue-devnf-aw-ex.cummins.com/api/core-security-api/v1/auth/token',token);
        endpointsResponse.put(conDetails.End_Point__c+'79484646',req1);
        HttpCalloutMock multiCalloutMock =  new CG_CL_HTTPMultiRequestMock(endpointsResponse);
        Test.setMock(HttpCalloutMock.class, multiCalloutMock);
        Test.startTest();
        CSS_WS_QSOL.getSMNFromQSOL('79484646','Assess');
        Test.stopTest();
    }
    
}