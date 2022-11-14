//adding test class part of vgrs2-512 --- coveragecheck
@isTest 
global class CSS_FN_SIEBEL_Test {
    
    static testmethod void MarketingApplicationCodes(){
        CSS_JobEventTemporary__c dateProcessRecAppCode = new CSS_JobEventTemporary__c();
        dateProcessRecAppCode.Key__c = 'ApplicationCodes_LastProcessed';
        insert dateProcessRecAppCode;
        
        CSS_JobEventTemporary__c queryJobEventTempAppCod = new CSS_JobEventTemporary__c();
        queryJobEventTempAppCod.key__c = 'MarketingApplicationCodes';
        queryJobEventTempAppCod.Attribute1__c = 'BW1';
        queryJobEventTempAppCod.Attribute3__c = 'AUTOMOTIV1(X15)';
        insert queryJobEventTempAppCod;
        
        CSS_FN_SIEBEL.insertResponse('{"Header": {"ReturnCodeDescription": "<Message from Siebel>", "Status": "Success", "ReturnCode": "<MessageCode from Siebel>","MessageIdentifier": "<Identifier from MW>"},"DataArea": [{"MarketingApplicationCode": "BW", "MarketingApplicationDescription": "AUTOMOTIVE (X15)","ProductApplicationCode": "120", "ProductApplicationDescription": "AUTOMOTIVE (C-OVER 225 HP)","ProductFamilyCode": "09"}, {"MarketingApplicationCode": "UX", "MarketingApplicationDescription": "BUS","ProductApplicationCode": "210", "ProductApplicationDescription": "WORLDWIDE BUS(EXC.US & CANADA SCHOOL BUS", "ProductFamilyCode": "OE"}]}','getMarketingApplicationCodes');
        
        CSS_JobEventTemporary__c queryJobEventTempAppCode = new CSS_JobEventTemporary__c();
        queryJobEventTempAppCode.key__c = 'MarketingApplicationCodes';
        queryJobEventTempAppCode.Attribute1__c = 'BW';
        queryJobEventTempAppCode.Attribute3__c = 'AUTOMOTIVE (X15)';
        insert queryJobEventTempAppCode;
        
        CSS_FN_SIEBEL.insertResponse('{"Header": {"ReturnCodeDescription": "<Message from Siebel>", "Status": "Success", "ReturnCode": "<MessageCode from Siebel>","MessageIdentifier": "<Identifier from MW>"},"DataArea": [{"MarketingApplicationCode": "BW", "MarketingApplicationDescription": "AUTOMOTIVE (X15)","ProductApplicationCode": "120", "ProductApplicationDescription": "AUTOMOTIVE (C-OVER 225 HP)","ProductFamilyCode": "09"}, {"MarketingApplicationCode": "UX", "MarketingApplicationDescription": "BUS","ProductApplicationCode": "210", "ProductApplicationDescription": "WORLDWIDE BUS(EXC.US & CANADA SCHOOL BUS", "ProductFamilyCode": "OE"}]}','getMarketingApplicationCodes');
        
        CSS_JobEventTemporary__c dateProcessRecAppCod = new CSS_JobEventTemporary__c();
        dateProcessRecAppCod.Key__c = 'FailCodeProcessedDate';
        insert dateProcessRecAppCod;
        
        //CSS_FN_SIEBEL.getFailCodes();
        CSS_FN_SIEBEL.getSPHeaderData();
        CSS_FN_SIEBEL.getSPCertificationData();
        CSS_FN_SIEBEL.getSPAffiliationData();
        CSS_FN_SIEBEL.GetSPTechnicianData();
        CSS_FN_SIEBEL.GetSPTechnicianSMNData();
        CG_WPR_SBL_SPTechnicianSMN wrap =  new CG_WPR_SBL_SPTechnicianSMN();
        CG_WPR_SBL_SPTechnicianSMN.DataArea dat =  new CG_WPR_SBL_SPTechnicianSMN.DataArea();
       dat.TechServiceModelInfo=null ;
        CSS_FN_SIEBEL.insertSPTechnicianSMNData(wrap);
        
        CSS_JobEventTemporary__c dateProcessRecAppCo = new CSS_JobEventTemporary__c();
        dateProcessRecAppCo.Key__c = 'FailCodeProcessedDate';
        dateProcessRecAppCo.Key__c = '07/02/2018';
        insert dateProcessRecAppCo;
        
        //CSS_FN_SIEBEL.getFailCodes();
    }
    
    static testmethod void CSS_FN_SIEBEL_TEST_Method(){
        // CSS_FN_SIEBEL.insertResponse('response','service')
        CSS_FN_SIEBEL.insertResponse('response','service');
        CSS_FN_SIEBEL.insertResponse('response','GetApplicationList');
        CSS_FN_SIEBEL.insertResponse('{"Header": {"ReturnCodeDescription": "<Message from Siebel>", "Status": "Success", "ReturnCode": "<MessageCode from Siebel>","MessageIdentifier": "<Identifier from MW>"},"DataArea": [{"MarketingApplicationCode": "BW", "MarketingApplicationDescription": "AUTOMOTIVE (X15)","ProductApplicationCode": "120", "ProductApplicationDescription": "AUTOMOTIVE (C-OVER 225 HP)","ProductFamilyCode": "09"}, {"MarketingApplicationCode": "UX", "MarketingApplicationDescription": "BUS","ProductApplicationCode": "210", "ProductApplicationDescription": "WORLDWIDE BUS(EXC.US & CANADA SCHOOL BUS", "ProductFamilyCode": "OE"}]}','getMarketingApplicationCodes');
        //  CSS_FN_SIEBEL.insertResponse('response','GetAccountCodes');
        CSS_FN_SIEBEL.storeApplicationOrCategoryComplaintList('service');      
        CSS_Integration_Details__c inteDetails = new CSS_Integration_Details__c(); 
        // inteDetails.Name = 'CSS_SBL_ApplicationCodes';
        inteDetails.Name = 'CSS_SBL_ApplicationCodes';
        inteDetails.ApplicationName__c = 'CSS_SBL_ApplicationCodes';
        inteDetails.End_Point__c = 'https://services-stg.cummins.com/css/siebelapplicationlist';
        inteDetails.IsActive__c = true;
        inteDetails.Key__c = '7GUoRKlp5dKNlAZvsgYM9VE14s3zYMo8zTJ9vK8Ham8=';
        inteDetails.Passcode__c = '2A3tPPZZfV26YIx0a31n5xAO3QhLikdOwg8AemK0qFU=';
        inteDetails.Username__c = 'r/6be8MhnZIMtZMvmFrMwu/wgLPgXhFC6bX9xrZNQYA=';
        insert inteDetails;
        //   test.setMock(HttpCalloutMock.class, new CSS_MockHttpResponseGenerator());
        CSS_FN_SIEBEL.storeApplicationOrCategoryComplaintList('GetApplicationList');
        date d = system.today(); 
        CSS_JobEventTemporary__c jobevnt = new CSS_JobEventTemporary__c();
        jobevnt.Reason__c = 'test';
        jobevnt.Attribute13__c = d;
        jobevnt.Name = 'CategoryComplaintCodes';
        insert jobevnt;
        CSS_FN_SIEBEL.insertResponse('response','service');
        CSS_FN_SIEBEL.insertResponse('response','GetApplicationList');
        /*CSS_FN_SIEBEL.insertResponse('response','GetAccountCodes');
CSS_FN_SIEBEL.insertResponse('response','FailModes');
CSS_FN_SIEBEL.insertResponse('response','FailCodes');
CSS_FN_SIEBEL.insertResponse('response','service');
*/
    }
    
    static testmethod void getServiceProviderDataTestMethod(){
        //Creating Test Data
        
        CSS_Integration_Details__c cid = CSS_TestData.createIntegrationDetails(false);
        cid.name = 'SPDataLookup';
        cid.ApplicationName__c = 'SPDataLookup';
        cid.End_Point__c = 'https://services-stg.cummins.com/csswarranty/serviceproviderdataTest';
        insert cid;
        
        
        Test.StartTest();
        Test.setMock(HttpCalloutMock.class , new CSS_MockHttpResponseGenerator());
        CSS_FN_SIEBEL.getServiceProviderData('SPCode','ServiceModelName','01-AUG-14','123');
        Test.stopTest();
    }
    static testmethod void getServiceProviderDataTestMethod111(){
        //Creating Test Data
        
        CSS_Integration_Details__c inte3 = new CSS_Integration_Details__c();
        Blob key3 = Blob.valueOf('12345678901234567890123456789012');
        string algo3 = 'AES256';
        inte3.Name = 'CSS_SPDataLookup';
        inte3.Username__c = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key3, Blob.valueOf('test')));
        inte3.Passcode__c = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key3, Blob.valueOf('test')));
        inte3.Key__c = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key3, Blob.valueOf('1234')));
        inte3.ApplicationName__c = 'CSS_SPDataLookup';
        inte3.End_Point__c = 'https://services-stg.cummins.com/csswarranty/serviceproviderdataTest';
        inte3.IsActive__c = true;
        insert inte3;
        Test.setMock(HttpCalloutMock.class , new CSS_MockHttpResponseGenerator());
        
        Test.StartTest();
        CSS_FN_SIEBEL.getServiceProviderData('SPCode','ServiceModelName','01-AUG-14','123');
        Test.stopTest();
    }
    
        static testmethod void getServiceProviderDataTestMethod10(){
        CSS_Integration_Details__c cid = CSS_TestData.createIntegrationDetails(false);
        cid.name = 'SPDataLookup';
        cid.ApplicationName__c = 'SPDataLookup';
        cid.End_Point__c = 'https://services-stg.cummins.com/csswarranty/serviceproviderdataTest';
        insert cid;
        Test.setMock(HttpCalloutMock.class , new CSS_MockHttpResponseGenerator());
            
            Test.StartTest();
            CSS_FN_SIEBEL.getServiceProviderData('SPCode','ServiceModelName','01-AUG-14','123');
            Test.stopTest();
    }
    
    static testmethod void getWarrantyDetailCoverageTestMethod(){
        //Creating Test Data
        List<CSS_JobEventTemporary__c> jobeventlist=new List<CSS_JobEventTemporary__c>();
        CSS_JobEventTemporary__c jobevent=new CSS_JobEventTemporary__c();
        jobevent.File_Name__c='Test';
        jobevent.Circuit_Description__c='rrrr';
        jobevent.Comp_Location__c='dfgh';
        jobevent.Effect__c='klkl';
        jobevent.Engine__c='bfr';
        jobevent.Fault_Code_Description__c = 'intake';
        jobevent.File_Name__c = 'testing';
        jobevent.FMI__c = 'htyu';
        jobevent.Lamp__c = 'nhgt';
        jobevent.Reason__c = 'yyyy';
        jobevent.Service_Model_Name__c = 'fault';
        jobevent.SPN__c = 'bfgfhhj';
         jobevent.Attribute1__c= '2014-05-08T00:00:00.000-05:00'; //string.valueof(system.now());
        jobevent.Attribute2__c='test2';
        jobevent.Attribute3__c='test3';
        jobevent.Attribute4__c='1.0';
        jobevent.Attribute5__c='test5';
        jobevent.Attribute6__c='test6';
        jobevent.Attribute7__c='test7';
        jobevent.Attribute8__c='test9';
        jobevent.Attribute9__c='test10';
        jobevent.Attribute10__c='test11';
        jobevent.Attribute11__c='2014-05-08T00:00:00.000-05:00';
        jobevent.Attribute12__c='test13';
        date d =  Date.today();
        jobevent.Attribute13__c=d;
        jobevent.Attribute14__c='test15';
        jobevent.Attribute15__c='test8';
        jobevent.Reason__c='tEst';
       jobevent.key__c='AccountCodes';
        jobevent.type__c='ClaimHistory';
        jobevent.Active__c=true;
        jobeventlist.add(jobevent);
        insert jobeventlist;
        CSS_Integration_Details__c cid = CSS_TestData.createIntegrationDetails(false);
        cid.name = 'CSS_SBL_WarrantyDetailCoverage';
        cid.ApplicationName__c = 'CSS_SBL_WarrantyDetailCoverage';
        cid.End_Point__c = 'https://services-stg.cummins.com/csswarranty/accodecoverage';
        insert cid;
        Test.setMock(HttpCalloutMock.class , new CSS_WS_SBL_GetWarrantyDetailCovrg_Test());
        
        Test.StartTest();
        //CSS_FN_SIEBEL.getWarrantyDetailCoverage(warrantyWrapperInputObj);
        date d1 = date.parse('10/10/17');
        date d2 = date.parse('10/12/16');
        
        CSS_FN_SIEBEL.getWarrantyDetailCoverage('73595986','sp123',d1,'failpoint','failmeasure','engappcode',d2,'syscode33445','comp123','f123','acc123','a1O3B0000007DQsUAM',true,'campNum','N','Second Call', '',false,null);
        
        Test.stopTest();
    }
    
     static testmethod void getWarrantyDetailCoverageTestMethod1(){
        //Creating Test Data
        CSS_Integration_Details__c cid = CSS_TestData.createIntegrationDetails(false);
        cid.name = 'CSS_SBL_WarrantyDetailCoverage';
        cid.ApplicationName__c = 'CSS_SBL_WarrantyDetailCoverage';
        cid.End_Point__c = 'https://services-stg.cummins.com/csswarranty/accodecoverage';
        insert cid;
        Test.setMock(HttpCalloutMock.class , new CSS_WS_SBL_GetWarrantyDetailCovrg_Test());
        
        Test.StartTest();
        //CSS_FN_SIEBEL.getWarrantyDetailCoverage(warrantyWrapperInputObj);
        date d1 = date.parse('10/10/17');
        date d2 = date.parse('10/12/16');
        
        CSS_FN_SIEBEL.getWarrantyDetailCoverage('73595986','sp123',d1,'failpoint','failmeasure','engappcode',d2,'syscode33445','comp123','f123','acc123','a1O3B0000007DQsUAM',true,'campNum','New Parts Warranty','Second Call', '',false,null);
        
        Test.stopTest();
    }
    
    static testmethod void getWarrantyDetailCoverageTestMethod2(){
        //Creating Test Data
        CSS_Integration_Details__c cid = CSS_TestData.createIntegrationDetails(false);
        cid.name = 'CSS_SBL_WarrantyDetailCoverage';
        cid.ApplicationName__c = 'CSS_SBL_WarrantyDetailCoverage';
        cid.End_Point__c = 'https://services-stg.cummins.com/csswarranty/accodecoverage';
        insert cid;
        Test.setMock(HttpCalloutMock.class , new CSS_WS_SBL_GetWarrantyDetailCovrg_Test());
        
        Test.StartTest();
        //CSS_FN_SIEBEL.getWarrantyDetailCoverage(warrantyWrapperInputObj);
        date d1 = date.parse('10/10/17');
        date d2 = date.parse('10/12/16');
        
        CSS_FN_SIEBEL.getWarrantyDetailCoverage('73595986','sp123',d1,'failpoint','failmeasure','engappcode',d2,'syscode33445','comp123','f123','acc123','a1O3B0000007DQsUAM',true,'campNum','Recon Parts Warranty','Second Call', '',false,null);
        
        Test.stopTest();
    }
    
     static testmethod void getWarrantyDetailCoverageTestMethod3(){
        //Creating Test Data
        CSS_Integration_Details__c cid = CSS_TestData.createIntegrationDetails(false);
        cid.name = 'CSS_SBL_WarrantyDetailCoverage';
        cid.ApplicationName__c = 'CSS_SBL_WarrantyDetailCoverage';
        cid.End_Point__c = 'https://services-stg.cummins.com/csswarranty/accodecoverage';
        insert cid;
        Test.setMock(HttpCalloutMock.class , new CSS_WS_SBL_GetWarrantyDetailCovrg_Test());
        
        Test.StartTest();
        //CSS_FN_SIEBEL.getWarrantyDetailCoverage(warrantyWrapperInputObj);
        date d1 = date.parse('10/10/17');
        date d2 = date.parse('10/12/16');
        
        CSS_FN_SIEBEL.getWarrantyDetailCoverage('73595986','sp123',d1,'failpoint','failmeasure','engappcode',d2,'syscode33445','comp123',null,'acc123','a1O3B0000007DQsUAM',true,'campNum','Recon Parts Warranty','Second Call', '',false,null);
        
        Test.stopTest();
    }
    
         static testmethod void getWarrantyDetailCoverageTestMethod4(){
        //Creating Test Data
        CSS_Integration_Details__c cid = CSS_TestData.createIntegrationDetails(false);
        cid.name = 'CSS_SBL_WarrantyDetailCoverage';
        cid.ApplicationName__c = 'CSS_SBL_WarrantyDetailCoverage';
        cid.End_Point__c = 'https://services-stg.cummins.com/csswarranty/accodecoverage';
        insert cid;
        Test.setMock(HttpCalloutMock.class , new CSS_WS_SBL_GetWarrantyDetailCovrg_Test());
        
        Test.StartTest();
        //CSS_FN_SIEBEL.getWarrantyDetailCoverage(warrantyWrapperInputObj);
        date d1 = date.parse('10/10/17');
        date d2 = date.parse('10/12/16');
        
        CSS_FN_SIEBEL.getWarrantyDetailCoverage('73595986','sp123',d1,'failpoint','failmeasure','engappcode',d2,'syscode33445','comp123',null,'acc123','a1O3B0000007DQsUAM',true,'campNum','Recon Parts Warranty','Second Call', 'Y',false,null);
        
        Test.stopTest();
    }
    
     static testmethod void getWarrantyDetailCoverageTestMethod5(){
        //Creating Test Data
        CSS_Integration_Details__c cid = CSS_TestData.createIntegrationDetails(false);
        cid.name = 'CSS_SBL_WarrantyDetailCoverage';
        cid.ApplicationName__c = 'CSS_SBL_WarrantyDetailCoverage';
        cid.End_Point__c = 'https://services-stg.cummins.com/csswarranty/accodecoverage';
        insert cid;
        Test.setMock(HttpCalloutMock.class , new CSS_WS_SBL_GetWarrantyDetailCovrg_Test());
        
        Test.StartTest();
        //CSS_FN_SIEBEL.getWarrantyDetailCoverage(warrantyWrapperInputObj);
        date d1 = date.parse('10/10/17');
        date d2 = date.parse('10/12/16');
        
        CSS_FN_SIEBEL.getWarrantyDetailCoverage('73595986','sp123',d1,'failpoint','failmeasure','engappcode',d2,'syscode33445','comp123',null,'acc123','a1O3B0000007DQsUAM',true,'campNum','Recon Parts Warranty','Second Call', 'Y',True,null);
        
        Test.stopTest();
    }
    
    static testmethod void getWarrantyDetailCoverageTestMethod6(){
        //Creating Test Data
        CSS_Integration_Details__c cid = CSS_TestData.createIntegrationDetails(false);
        cid.name = 'CSS_SBL_WarrantyDetailCoverage';
        cid.ApplicationName__c = 'CSS_SBL_WarrantyDetailCoverage';
        cid.End_Point__c = 'https://services-stg.cummins.com/csswarranty/accodecoverage';
        insert cid;
        Test.setMock(HttpCalloutMock.class , new CSS_WS_SBL_GetWarrantyDetailCovrg_Test());
        
        Test.StartTest();
        //CSS_FN_SIEBEL.getWarrantyDetailCoverage(warrantyWrapperInputObj);
        date d1 = date.parse('10/10/17');
        date d2 = date.parse('10/12/16');
        
        CSS_FN_SIEBEL.getWarrantyDetailCoverage('73595986','sp123',d1,'failpoint','failmeasure','engappcode',d2,'syscode33445','comp123',null,null,'a1O3B0000007DQsUAM',true,'campNum','Recon Parts Warranty','Second Call', 'Y',True,null);
        
        Test.stopTest();
    }
    
    static testmethod void getWarrantyDetailCoverageTestMethod7(){
        //Creating Test Data
        CSS_Integration_Details__c cid = CSS_TestData.createIntegrationDetails(false);
        cid.name = 'CSS_SBL_WarrantyDetailCoverage';
        cid.ApplicationName__c = 'CSS_SBL_WarrantyDetailCoverage';
        cid.End_Point__c = 'https://services-stg.cummins.com/csswarranty/accodecoverage';
        insert cid;
        Test.setMock(HttpCalloutMock.class , new CSS_WS_SBL_GetWarrantyDetailCovrg_Test());
        
        Test.StartTest();
        //CSS_FN_SIEBEL.getWarrantyDetailCoverage(warrantyWrapperInputObj);
        date d1 = date.parse('10/10/17');
        date d2 = date.parse('10/12/16');
        
        CSS_FN_SIEBEL.getWarrantyDetailCoverage('73595986','sp123',d1,'failpoint','failmeasure','engappcode',d2,'syscode33445','comp123',null,null,'a1O3B0000007DQsUAM',true,'campNum','Recon Parts Warranty','First Call', 'Y',True,null);
        
        Test.stopTest();
    }
    
        static testmethod void getWarrantyDetailCoverageTestMethod8(){
        //Creating Test Data
        CSS_Integration_Details__c cid = CSS_TestData.createIntegrationDetails(false);
        cid.name = 'CSS_SBL_WarrantyDetailCoverage';
        cid.ApplicationName__c = 'CSS_SBL_WarrantyDetailCoverage';
        cid.End_Point__c = 'https://services-stg.cummins.com/csswarranty/accodecoverage';
        insert cid;
        Test.setMock(HttpCalloutMock.class , new CSS_WS_SBL_GetWarrantyDetailCovrg1_Test());
        
        Test.StartTest();
        //CSS_FN_SIEBEL.getWarrantyDetailCoverage(warrantyWrapperInputObj);
        date d1 = date.parse('10/10/17');
        date d2 = date.parse('10/12/16');
        
        CSS_FN_SIEBEL.getWarrantyDetailCoverage('73595986','sp123',d1,'failpoint','failmeasure','engappcode',d2,'syscode33445','comp123',null,null,'a1O3B0000007DQsUAM',true,'campNum','Recon Parts Warranty','Second Call', 'Y',True,null);
        
        Test.stopTest();
    }
    
    static testmethod void getAccountCodesTestMethod(){
        //Creating Test Data
        CSS_Integration_Details__c cid = CSS_TestData.createIntegrationDetails(false);
        cid.name = 'CSS_SBL_AccountCodes';
        cid.ApplicationName__c = 'CSS_SBL_AccountCodes';
        cid.End_Point__c = 'https://services-stg.cummins.com/csswarranty/getaccountcode';
        insert cid;
        Test.setMock(HttpCalloutMock.class , new CSS_MockHttpResponseGenerator());
        CSS_FN_SIEBEL controller = new CSS_FN_SIEBEL();
        Test.StartTest();
        CSS_FN_SIEBEL.getAccountCodes();
        Test.stopTest();
    }
    
    /*static testmethod void getFailCodeTestMethod(){
CSS_Integration_Details__c cid = CSS_TestData.createIntegrationDetails(false);
cid.name = 'CSS_SBL_FailCodes';
cid.ApplicationName__c = 'CSS_SBL_FailCodes';
cid.End_Point__c = 'https://services-stg.cummins.com/csswarranty/getpartreturn';
cid.Method_Type__c = 'POST';
cid.Timeout__c = 120000;
insert cid;

//CSS_JobEventTemporary__c CssJET1=CSS_TestData.createJobEventTempObj(false);
CSS_JobEventTemporary__c CssJET=CSS_TestData.createJobEventTempObj(false);
CssJET.Key__c='FailCodeProcessedDate';
CssJET.Name ='FailCodeProcessedDate';
cssJET.Attribute1__c= string.valueOf(DAte.Today());//'BR1-BROKEN';
Insert CssJET;

Test.StartTest();
CSS_FN_SIEBEL.getFailCodes();
string responseBody = '{"Header":{"MessageIdentifier":"Identifier from MW","ReturnCode":"<MessageCode from Siebel>","ReturnCodeDescription":"<Message from Siebel>","Status":"Success"},"DataArea":[{"SystemCode":"WS","SystemName":"Broken Filter shell1","ComponentCode":"EF","ComponentName":"Electrical","FailureName":"","ServiceGroupCode":"345","Created":"2010-03-19T16:18:59.000-05:00","Active":"Y","UpdatedDate":"2010-03-19T16:18:59.000-05:00","BusinesUnit":"EBU"},{"SystemCode":"WS1","SystemName":"Broken Filter shell1","ComponentCode":"EF","ComponentName":"Electrical","FailureName":"","ServiceGroupCode":"345","Created":"2010-03-19T16:18:59.000-05:00","Active":"Y","UpdatedDate":"2010-03-19T16:18:59.000-05:00","BusinesUnit":"EBU"},{"SystemCode":"WS2","SystemName":"Broken Filter shell1","ComponentCode":"EF","ComponentName":"Electrical","FailureName":"","ServiceGroupCode":"345","Created":"2010-03-19T16:18:59.000-05:00","Active":"Y","UpdatedDate":"2010-03-19T16:18:59.000-05:00","BusinesUnit":"EBU"}]}';
string ServiceName = 'getFailCodes';
CSS_FN_SIEBEL.insertResponse(responseBody, ServiceName);
Test.stopTest();

}
static testmethod void getFailModeTestMethod(){
CSS_Integration_Details__c cid = CSS_TestData.createIntegrationDetails(false);
cid.name = 'CSS_SBL_FailModes';
cid.ApplicationName__c = 'CSS_SBL_FailModes';
//cid.End_Point__c = 'https://services-stg.cummins.com/csswarranty/getpartreturn';
cid.Method_Type__c = 'POST';
cid.AuthEnv__c = 'OAGOAuth';
cid.Timeout__c = 120000;
insert cid;

Test.StartTest();
CSS_FN_SIEBEL.getFailModes();
string responseBody = '{\r\n\t\"Header\": {\r\n\t\t\"MessageIdentifier\": \"Identifier from MW\",\r\n\t\t\"ReturnCode\": \"<MessageCode from Siebel>\",\r\n\t\t\"ReturnCodeDescription\": \"<Message from Siebel>\",\r\n\t\t\"Status\": \"Success\"\r\n\t},\r\n\t\"DataArea\": [{\r\n\t\t\t\"FailModeCode\": \"BR1-BROKEN\",\r\n\t\t\t\"Description\": \"Broken Filter shell1\",\r\n\t\t\t\"Active\": \"Y\",\r\n\t\t\t\"Created\": \"2010-03-19T16:18:59.000-05:00\",\r\n\t\t\t\"LastUpdated\": \"2010-03-19T16:18:59.000-05:00\",\r\n\t\t\t\"BusinessUnit\": \"EBU\"\r\n\t\t},\r\n\t\t{\r\n\t\t\t\"FailModeCode\": \"BR2-BROKEN\",\r\n\t\t\t\"Description\": \"Broken Filter shell2\",\r\n\t\t\t\"Active\": \"Y\",\r\n\t\t\t\"Created\": \"2010-03-19T16:18:59.000-05:00\",\r\n\t\t\t\"LastUpdated\": \"2010-03-19T16:18:59.000-05:00\",\r\n\t\t\t\"BusinessUnit\": \"EBU\"\r\n\t\t},\r\n\t\t{\r\n\t\t\t\"FailModeCode\": \"BR3-BROKEN\",\r\n\t\t\t\"Description\": \"Broken Filter shell3\",\r\n\t\t\t\"Active\": \"Y\",\r\n\t\t\t\"Created\": \"2010-03-19T16:18:59.000-05:00\",\r\n\t\t\t\"LastUpdated\": \"2010-03-19T16:18:59.000-05:00\",\r\n\t\t\t\"BusinessUnit\": \"EBU\"\r\n\t\t},\r\n\t\t{\r\n\t\t\t\"FailModeCode\": \"BR4-BROKEN\",\r\n\t\t\t\"Description\": \"Broken Filter shell4\",\r\n\t\t\t\"Active\": \"N\",\r\n\t\t\t\"Created\": \"2010-03-19T16:18:59.000-05:00\",\r\n\t\t\t\"LastUpdated\": \"2010-03-19T16:18:59.000-05:00\",\r\n\t\t\t\"BusinessUnit\": \"EBU\"\r\n\t\t}\r\n\t]\r\n}';
string ServiceName = 'getFailModes';
CSS_FN_SIEBEL.insertResponse(responseBody, ServiceName);

CSS_JobEventTemporary__c CssJET1=CSS_TestData.createJobEventTempObj(false);
CSS_JobEventTemporary__c CssJET=CSS_TestData.createJobEventTempObj(false);
CssJET.Key__c='FailModeProcessedDate';
CssJET.Name ='FailModeProcessedDate';
// cssJET.Attribute1__c='BR1-BROKEN';
Insert CssJET;
CssJET1.Key__c='FailModes';
CssJET1.Name ='FailModes';
cssJET.Attribute1__c='BR1-BROKEN';
Insert CssJET1;
CSS_FN_SIEBEL.getFailModes();
CSS_FN_SIEBEL.insertResponse(responseBody, ServiceName);
Test.stopTest();

}*/
    
    static testmethod void getPartReturnTestMethod(){
        //Creating Test Data
        CSS_Integration_Details__c cid = CSS_TestData.createIntegrationDetails(false);
        cid.name = 'CSS_SBL_GetPartReturns';
        cid.ApplicationName__c = 'CSS_SBL_getpartreturn';
        cid.End_Point__c = 'https://services-stg.cummins.com/csswarranty/getpartreturn';
        insert cid;
        Test.setMock(HttpCalloutMock.class , new CSS_WS_SBL_getPartReturnDetailsMock_Test());
        
        Test.StartTest();
        /*CSS_FN_SIEBEL.PartsReturnWrapperInput PartsWrapperInputObj = new CSS_FN_SIEBEL.PartsReturnWrapperInput();
PartsWrapperInputObj.Psn = '79655093';
PartsWrapperInputObj.DISTICHANNEL = '';
PartsWrapperInputObj.FailDate = '3/7/2017';
PartsWrapperInputObj.partsList = new List<CSS_getPartReturnInputWrapper.parts>();
CSS_getPartReturnInputWrapper.parts partsObj = new CSS_getPartReturnInputWrapper.parts();
partsObj.partnumber = '306354800';
partsObj.PRODUCTFAMILY = '';
partsObj.TERRITORYCLASS = '';
partsObj.ACCOUNTCODE = '';
partsObj.FAILCODE = '';
PartsWrapperInputObj.partsList.add(partsObj); */
        List<CSS_Parts_Options__c> lstparts = new List<CSS_Parts_Options__c>();
        CSS_Parts_Options__c parts = new CSS_Parts_Options__c();
        parts.Covered__c =0.0;
        parts.Fail_Code__c ='test';
        parts.Service_partnumber__c='test';
        parts.Account_Code__c = 'test1';
        CSS_Job_Order__c JO = CSS_TestData.createJobOrder(FALSE);
        JO.CSS_Channel_Code__c ='101';
        JO.Qsol_Engine_Family_Code__c ='122';
        
        Jo.Failure_Date__c=System.today();
        JO.ESN__c='79464646';
        JO.Territory_Class__c = '22';
        INSERT jO;
        parts.Service_Job__c = jo.id;   // Karthik added to pass testMethod
        lstparts.add(parts);
        insert lstparts;
        
        
        date d1 = date.parse('10/10/17');
        
        CSS_FN_SIEBEL.getPartsReturn(lstparts);
        Test.stopTest();
    }
    
    static testmethod void getFailcodesTestMethod(){
        //Creating Test Data
        CSS_Integration_Details__c cid = CSS_TestData.createIntegrationDetails(false);
        cid.name = 'CSS_SBL_FailCodes';
        cid.ApplicationName__c = 'CSS_SBL_FailCodes';
        cid.End_Point__c = 'https://api-ue-devnf-aw-ex.cummins.com/cmi-engine/failcodes';
        insert cid;
        
        Test.StartTest();
               
        CSS_FN_SIEBEL.getFailCodes();
        Test.stopTest();
    }
    
    static testmethod void getFailModesTestMethod(){
        //Creating Test Data
        CSS_Integration_Details__c cid = CSS_TestData.createIntegrationDetails(false);
        cid.name = 'CSS_SBL_FailModes';
        cid.ApplicationName__c = 'CSS_SBL_FailModes';
        cid.End_Point__c = 'https://api-ue-devnf-aw-ex.cummins.com/cmi-engine/failmodes';
        insert cid;
        
        Test.StartTest();
               
        CSS_FN_SIEBEL.getFailModes();
        Test.stopTest();
    }
    static testmethod void insertAccountPayCodesTestMethod(){
        //Creating Test Data
        CSS_Integration_Details__c cid = CSS_TestData.createIntegrationDetails(false);
        cid.name = 'CSS_SBL_AccountcodePaycodes';
        cid.ApplicationName__c = 'CSS_SBL_AccountcodePaycodes';
        cid.End_Point__c = 'https://api-ue-devnf2-aw-ex.cummins.com/cmi/warranty/v1/accountpaycode';
        insert cid;
        
        Test.StartTest();
               
        CSS_FN_SIEBEL.insertAccountPayCodes();
        Test.stopTest();
    }
    
    
    static testmethod void callPartsReturnTestMethod(){
        List<String> partName = new List<String>{'PartName1;;pn2;;pn3;;a1f3B000000QXEmQAO','PartName2','PartName3'};
            /*String partName1 = new String('PartName1');
insert partName1;
String partName2 = 'PartName2';
insert partName2;
String partName3 = 'PartName3';
insert partName3;
partName.addAll(partName1,partName2,partName3);
insert partName; */
            // CSS_FN_SIEBEL.callPartsReturn(partName);
            }
    static testmethod void insertFailCodeResponsetestmethod()
    {
        string responsecode = '';
        css_fn_siebel.insertFailCodeResponse(responsecode);
    }
    static testmethod void getJobEventRecordtestmethod()
    {
        CSS_JobEventTemporary__c jobevent = new CSS_JobEventTemporary__c();      
        jobevent = CSS_FN_SIEBEl.getJobEventRecord('GetTechInfo');      
    }
    static testmethod void getJobEventRecordtestmethod1()
    {
        
        CSS_JobEventTemporary__c jobevent1 = new CSS_JobEventTemporary__c();
        jobevent1.Name = 'GetTechInfo';
        jobevent1.Attribute1__c = System.now().format('YYYY-MM-dd');
        test.startTest();
        
        insert jobevent1;
        CSS_FN_SIEBEl.getJobEventRecord(jobevent1.Name);
        
        
        test.stopTest();
        
    }
    static testmethod void getSpCodelisttestmethod()
    {
        CSS_FN_SIEBEL.getSpCodelist('spCodeStr');
        css_fn_siebel.formatedDate('2018-03-14T10:52:03');
        //CSS_FN_SIEBEL.getFailCodes();
        //CSS_FN_SIEBEL.getFailModes();
        
        
    } 
    static testmethod void getCSSDetails() {
        CSS_Integration_Details__c cid = CSS_TestData.createIntegrationDetails(false);
        cid.name = 'CSS_SBL_CSSDetails';
        cid.ApplicationName__c = 'CSS_SBL_CSSDetails';
        cid.End_Point__c = 'https://api-ue-devnf-aw-ex.cummins.com/cmi-claims/claims';
        insert cid;  
        CSS_FN_SIEBEL.getCSSDetails('spCodeStr');
    } 
    
    static testmethod void getServiceProviderDataTestMethod1(){
        //Creating Test Data
        CSS_Integration_Details__c cid = CSS_TestData.createIntegrationDetails(false);
        cid.name = 'SPDataLookup';
        cid.ApplicationName__c = 'SPDataLookup';
        cid.End_Point__c = 'https://services-stg.cummins.com/csswarranty/serviceproviderdataTest';
        insert cid;       
        Test.setMock(HttpCalloutMock.class , new CSS_MockHttpResponseGenerator());
        Test.StartTest();
        CSS_FN_SIEBEL.getServiceProviderData('SPCode','ServiceModelName','01-AUG-14','123');
        Test.stopTest();
    }
    
    /*static testmethod void fetchSPDatatestmethod()
{
css_fn_siebel.fetchSPData(new string[] {'sp123-4587;;ServiceModelName;;2017-10-10;;123;;'}) ; 
}*/   
    
    static testmethod void insertresponsemethod1()
    {
        string responsebody='{'+
            '                \"DataArea\": ['+
            '                {'+
            '                                \"COVERAGETYPE\": \"CAP\",'+
            '                                \"DESCRIPTION\": \"CONNECTED PRODUCTS\",'+
            '                                \"ACCOUNTCODE\": \"PC\",'+
            '                                \"EDSFLAG\": \"EDSFLAG\",'+
            '                                \"BUSINESSUNIT\": \"BUSINESSUNIT\",'+
            '                                \"MULTIPSN\": \"MULTIPSN\",'+
            '                                \"CHRYSLERFLAG\": \"CHRYSLERFLAG\",'+
            '    \"PAYCODES\": ['+
            ' {'+
            '                                                  \"PAYCODE\": \"03\",'+
            '                                                  \"PAYCODEDESCRIPTION\": \"RECON DEALER NOW\"'+
            '                                }]'+
            '                }],'+
            ''+
            '                \"Header\": {'+
            '                                \"ReturnCodeDescription\":\"\",'+
            '                                \"Status\": \"Success\"'+
            '                }'+
            '}';
        
        String serviceName = 'GetAccountCodes';
        date d = system.today(); 
        CSS_JobEventTemporary__c jobevnt = new CSS_JobEventTemporary__c();
        jobevnt.Reason__c = 'test';
        jobevnt.Attribute1__c = '';
        jobevnt.Attribute1__c = 'test';
        jobevnt.Attribute1__c = 'date.today()';
        jobevnt.Attribute1__c = 'test';
        jobevnt.Active__c = true;
        jobevnt.Name = 'GetApplicationList';
        jobevnt.Key__c='ApplicationCodes_LastProcessed';
        insert jobevnt;
        
        CSS_JobEventTemporary__c jobevnt1 = new CSS_JobEventTemporary__c();
        jobevnt1.Reason__c = 'test';
        jobevnt1.Attribute1__c = 'test';
        jobevnt1.Attribute1__c = 'test';
        jobevnt1.Attribute1__c = 'test';
        jobevnt1.Attribute1__c = 'test';
        jobevnt1.Attribute1__c = 'test';
        jobevnt1.Name = 'GetApplicationList1';
        jobevnt1.Key__c='AccountCodes';
        insert jobevnt1;
        CSS_JobEventTemporary__c jobevnt2 = new CSS_JobEventTemporary__c();
        jobevnt2.Reason__c = 'test';
        jobevnt2.Attribute1__c = 'test';
        jobevnt2.Attribute1__c = 'test';
        jobevnt2.Attribute1__c = 'test';
        jobevnt2.Attribute1__c = 'test';
        jobevnt2.Attribute1__c = 'test';
        // jobevnt2.Attribute4__c = 'test';
        jobevnt2.Name = 'GetApplicationList2';
        jobevnt2.Key__c='AccountCodes';
        insert jobevnt2;
        css_fn_siebel.insertResponse(responsebody,serviceName);
        
        
    }
    //Test method for failmodes
    
    static testmethod void insertresponsemethod2()
    {
        string responsebody='{'+
            '                \"DataArea\": '+
            '                {'+
            '                "Details":[' +
            '                {' +
            '                                \"FailModeCode\": \"BR1-BROKEN\",'+
            '                                \"DESCRIPTION\": \"Broken Filter shell1\",'+
            '                                \"Active\": \"Y\",'+
            '                                \"BusinessUnit\": \"EBU\",'+
            '                                \"LastUpdated\": \"2010-03-19T16:18:59.000-05:00\",'+
            '                                \"Created\": \"2010-03-19T16:18:59.000-05:00\"'+
            '                }]'+
            '                },'  +
            ''+
            '                \"Header\": {'+
            '                                \"MessageIdentifier\":\"MessageIdentifier\",'+
            '                                \"ReturnCode\":\"ReturnCode\",'+
            '                                \"ReturnCodeDescription\":\"ReturnCodeDescription\",'+
            '                                \"Status\": \"Success\"'+
            '                }'+
            '}';
        
        String serviceName = 'getFailModes';
        date d = system.today(); 
        CSS_JobEventTemporary__c jobevnt = new CSS_JobEventTemporary__c();
        jobevnt.Reason__c = 'test';
        jobevnt.Attribute1__c = '';
        jobevnt.Attribute1__c = 'test';
        jobevnt.Attribute1__c = 'test';
        jobevnt.Attribute1__c = 'test';
        jobevnt.Active__c = true;
        jobevnt.Name = 'GetApplicationList';
        jobevnt.Key__c='AccountCodes_LastProcessed';
        insert jobevnt;
        
        CSS_JobEventTemporary__c jobevnt1 = new CSS_JobEventTemporary__c();
        jobevnt1.Reason__c = 'test';
        jobevnt1.Attribute1__c = 'test';
        jobevnt1.Attribute1__c = 'test';
        jobevnt1.Attribute1__c = 'test';
        jobevnt1.Attribute1__c = 'test';
        jobevnt1.Attribute1__c = 'test';
        jobevnt1.Name = 'GetApplicationList1';
        jobevnt1.Key__c='FailModes';
        insert jobevnt1;
        CSS_JobEventTemporary__c jobevnt2 = new CSS_JobEventTemporary__c();
        jobevnt2.Reason__c = 'test';
        jobevnt2.Attribute1__c = 'test';
        jobevnt2.Attribute1__c = 'test';
        jobevnt2.Attribute1__c = 'test';
        jobevnt2.Attribute1__c = 'test';
        jobevnt2.Attribute1__c = 'test';
        jobevnt2.Name = 'GetApplicationList2';
        jobevnt2.Key__c='FailModes';
        insert jobevnt2;
        css_fn_siebel.insertResponse(responsebody,serviceName);
        
        
    }
    static testmethod void insertresponsemethod3()
    {
        string responsebody='{'+
            '\"Header\":{ '+ 
            '\"MessageIdentifier\": \"Identifier from MW\",' + 
            '\"ReturnCode\":\"MessageCode from Siebel\",' +
            '\"ReturnCodeDescription\":\"Message from Siebel\",' +
            '\"Status\":\"Success\"},' +
            ' \"DataArea\": {'+
            '   \"Details\": ['+
            '   {'+
            '\"SystemCode\":\"WS\",' + 
            ' \"SystemName\":\"Broken Filter shell1\",' +
            '\"ComponentCode\":\"EF\",' +
            '\"ComponentName\":\"Electrical\",'+
            '\"FailureName\":\"test\",' +
            '\"ServiceGroupCode\":\"345\",' +
            '\"Created\":\"2010-03-19T16:18:59.000-05:00\", ' +
            '\"Active\":\"Y\", ' + 
            '\"UpdatedDate\":\"2010-03-19T16:18:59.000-05:00\",' +
            '\"BusinesUnit\":\"EBU\"' +
            '}'+
            ']}'+
            ' }';
        
        String serviceName = 'getFailcodes';
        date d = system.today(); 
        CSS_JobEventTemporary__c jobevnt = new CSS_JobEventTemporary__c();
        jobevnt.Reason__c = 'test';
        jobevnt.Attribute1__c = '';
        jobevnt.Attribute1__c = 'test';
        jobevnt.Attribute1__c = 'test';
        jobevnt.Attribute1__c = 'test';
        jobevnt.Active__c = true;
        jobevnt.Name = 'GetApplicationList';
        jobevnt.Key__c='AccountCodes_LastProcessed';
        insert jobevnt;
        
        CSS_JobEventTemporary__c jobevnt1 = new CSS_JobEventTemporary__c();
        jobevnt1.Reason__c = 'test';
        jobevnt1.Attribute1__c = 'test';
        jobevnt1.Attribute1__c = 'test';
        jobevnt1.Attribute1__c = 'test';
        jobevnt1.Attribute1__c = 'test';
        jobevnt1.Attribute1__c = 'test';
        jobevnt1.Name = 'GetApplicationList1';
        jobevnt1.Key__c='Failcodes';
        insert jobevnt1;
        CSS_JobEventTemporary__c jobevnt2 = new CSS_JobEventTemporary__c();
        jobevnt2.Reason__c = 'test';
        jobevnt2.Attribute1__c = 'test';
        jobevnt2.Attribute1__c = 'test';
        jobevnt2.Attribute1__c = 'test';
        jobevnt2.Attribute1__c = 'test';
        jobevnt2.Attribute1__c = 'test';
        jobevnt2.Name = 'GetApplicationList2';
        jobevnt2.Key__c='Failcodes';
        insert jobevnt2;
        css_fn_siebel.insertResponse(responsebody,serviceName);
        
        
    }
    static testmethod void insertresponseNegativemethod2()
    {
        string responsebody='{'+
            '                \"DataArea\": '+
            '                {'+
            '                "Details":[' +
            '                {' +
            '                                \"FailModeCode\": \"BR1-BROKEN\",'+
            '                                \"DESCRIPTION\": \"Broken Filter shell1\",'+
            '                                \"Active\": \"Y\",'+
            '                                \"BusinessUnit\": \"EBU\",'+
            '                                \"LastUpdated\": \"2010-03-19T16:18:59.000-05:00\",'+
            '                                \"Created\": \"2010-03-19T16:18:59.000-05:00\"'+
            '                }]'+
            '                },'  +
            ''+
            '                \"Header\": {'+
            '                                \"MessageIdentifier\":\"MessageIdentifier\",'+
            '                                \"ReturnCode\":\"ReturnCode\",'+
            '                                \"ReturnCodeDescription\":\"ReturnCodeDescription\",'+
            '                                \"Status\": \"Success\"'+
            '                }'+
            '}';
        
        String serviceName = 'getFailModes';
        date d = system.today(); 
        CSS_JobEventTemporary__c jobevnt = new CSS_JobEventTemporary__c();
        jobevnt.Reason__c = 'test';
        jobevnt.Attribute1__c = '';
        jobevnt.Attribute1__c = 'test';
        jobevnt.Attribute1__c = 'test';
        jobevnt.Attribute1__c = 'test';
        jobevnt.Active__c = true;
        jobevnt.Name = 'GetApplicationList';
        jobevnt.Key__c='FailModeProcessedDate';
        insert jobevnt;
        
        CSS_JobEventTemporary__c jobevnt1 = new CSS_JobEventTemporary__c();
        jobevnt1.Reason__c = 'test';
        jobevnt1.Attribute1__c = 'test';
        jobevnt1.Attribute1__c = 'test';
        jobevnt1.Attribute1__c = 'test';
        jobevnt1.Attribute1__c = 'test';
        jobevnt1.Attribute1__c = 'test';
        jobevnt1.Name = 'GetApplicationList1';
        jobevnt1.Key__c='FailModes';
        insert jobevnt1;
        CSS_JobEventTemporary__c jobevnt2 = new CSS_JobEventTemporary__c();
        jobevnt2.Reason__c = 'test';
        jobevnt2.Attribute1__c = 'test';
        jobevnt2.Attribute1__c = 'test';
        jobevnt2.Attribute1__c = 'test';
        jobevnt2.Attribute1__c = 'test';
        jobevnt2.Attribute1__c = 'test';
        jobevnt2.Name = 'GetApplicationList2';
        jobevnt2.Key__c='FailModes';
        insert jobevnt2;
        css_fn_siebel.insertResponse(responsebody,serviceName);
        
        
    }
    static testmethod void insertresponseNegativemethod3()
    {
        string responsebody='{'+
            '\"Header\":{ '+ 
            '\"MessageIdentifier\": \"Identifier from MW\",' + 
            '\"ReturnCode\":\"MessageCode from Siebel\",' +
            '\"ReturnCodeDescription\":\"Message from Siebel\",' +
            '\"Status\":\"Success\"},' +
            ' \"DataArea\": {'+
            '   \"Details\": ['+
            '   {'+
            '\"SystemCode\":\"WS\",' + 
            ' \"SystemName\":\"Broken Filter shell1\",' +
            '\"ComponentCode\":\"EF\",' +
            '\"ComponentName\":\"Electrical\",'+
            '\"FailureName\":\"test\",' +
            '\"ServiceGroupCode\":\"345\",' +
            '\"Created\":\"2010-03-19T16:18:59.000-05:00\", ' +
            '\"Active\":\"Y\", ' + 
            '\"UpdatedDate\":\"2010-03-19T16:18:59.000-05:00\",' +
            '\"BusinesUnit\":\"EBU\"' +
            '}'+
            ']}'+
            ' }';
        
        String serviceName = 'getFailcodes';
        date d = system.today(); 
        CSS_JobEventTemporary__c jobevnt = new CSS_JobEventTemporary__c();
        jobevnt.Reason__c = 'test';
        jobevnt.Attribute1__c = '';
        jobevnt.Attribute1__c = 'test';
        jobevnt.Attribute1__c = 'test';
        jobevnt.Attribute1__c = 'test';
        jobevnt.Active__c = true;
        jobevnt.Name = 'GetApplicationList';
        jobevnt.Key__c='FailCodeProcessedDate';
        insert jobevnt;
        
        CSS_JobEventTemporary__c jobevnt1 = new CSS_JobEventTemporary__c();
        jobevnt1.Reason__c = 'test';
        jobevnt1.Attribute1__c = 'test';
        jobevnt1.Attribute1__c = 'test';
        jobevnt1.Attribute1__c = 'test';
        jobevnt1.Attribute1__c = 'test';
        jobevnt1.Attribute1__c = 'test';
        jobevnt1.Name = 'GetApplicationList1';
        jobevnt1.Key__c='Failcodes';
        insert jobevnt1;
        CSS_JobEventTemporary__c jobevnt2 = new CSS_JobEventTemporary__c();
        jobevnt2.Reason__c = 'test';
        jobevnt2.Attribute1__c = 'test';
        jobevnt2.Attribute1__c = 'test';
        jobevnt2.Attribute1__c = 'test';
        jobevnt2.Attribute1__c = 'test';
        jobevnt2.Attribute1__c = 'test';
        jobevnt2.Name = 'GetApplicationList2';
        jobevnt2.Key__c='Failcodes';
        insert jobevnt2;
        css_fn_siebel.insertResponse(responsebody,serviceName);
        
        
    }
    //For submit Claims Test(Positive Testing)
    public static testmethod void testsubmitClaimsCalloutPass() 
    {
       
        List <CSS_Job_Order__c> lstjo = new List <CSS_Job_Order__c>();
        CSS_Job_Order__c jo = new CSS_Job_Order__c();
        jo.createdDate=dateTime.now();
        jo.ESN__c = '79464646';
        jo.Customer_Name__c='test';
        jo.Shop_Work_Order__c='uiafh';
        jo.Mileage__c=123;
        jo.Complaint_Type_Desc__c = 'CRUISE CONTROL';
        jo.Category_Desc__c = 'Fuel - Oil - Coolant';
        jo.Status__c = 'closed';
        jo.Service_Model__c = 'model';
        lstjo.add(jo);
        insert lstjo;
        
        Account acc = new Account();
        acc.name='Rtest';
        acc.CSS_DistributorCode__c='56270';
        acc.IAM_Service_Provider_Code__c='56270';
        acc.Enable_Claims__c = true;
        acc.Type = 'Customer';
        acc.CMI_Account_Status__c = 'Active';
        insert acc;
        
        List<CSS_Claims__c> claimsList = new list<CSS_Claims__c>();
        CSS_Claims__c claimsObj = new CSS_Claims__c();
        claimsobj.Claim_Submitted__c = date.today();
        // claimsobj.Name = 'claims';
        
        CSS_Job_Order__c SerRec = CSS_TestData.createJobOrder(true);
        
        claimsobj.Payment_Details__c = 'der';
        claimsobj.Customer_Name__c = 'name';
        claimsobj.Shop_Work_Order__c = 'wo';
        claimsobj.Location__c = 'code';
        claimsobj.Status__c = 'Submitted';
        claimsobj.Account__c = acc.id;
        claimsobj.Location_Code__c = '02850-02991';
        claimsobj.Location__c = 'Rtest';
        claimsobj.CSS_Job__c = SerRec.id;
        
        String grpName = 'CQ'+'-'+'12345-12345';
        Group testQue = new Group(Name=grpName, type='Queue');
        insert testQue;
        
        system.runas(new User(Id=UserInfo.getUserId()))
        { 
            
            QueueSObject tq = new QueueSObject(SobjectType='CSS_Claims__c', QueueId=testQue.Id);
            insert tq;
            //Id recTyIdpart = Schema.SObjectType.CSS_Parts_Options__c.getRecordTypeInfosByName().get('BMS Parts').getRecordTypeId();
            css_job_order__c joorder = css_testdata.createJobOrder(true);
            claimsobj = CSS_TestData.createclaims(true,joorder.Id); 
            //insert testclaimsRec;
        }
        
        
        claimsList.add(claimsObj);
        //insert claimsList;
        
        CSS_PSN__c psn=new CSS_PSN__c();
        CSS_Solution_Component__c sc1= new CSS_Solution_Component__c();
        CSS_Solution_Component__c sc2=new CSS_Solution_Component__c();
        List<CSS_Solution_Component__c> SolComp= new List<CSS_Solution_Component__c>();
        SolComp.add(sc1);
        SolComp.add(sc2);
        
        List<CSS_Claim_Submission__c> submID = new List<CSS_Claim_Submission__c>();
        CSS_Claim_Submission__c claimsSub = new CSS_Claim_Submission__c();
        claimsSub.Type__c = 'ytes';
        claimsSub.Rejection_Reason__c='test';
        claimsSub.Status__c= 'Submitted';
        claimsSub.CSS_Claims__c=claimsList[0].id;
        claimsSub.Siebel_Claim_JSON__c = '{"Header":{"Target":"CSSWarranty","Sender":{"ServiceName":"ClaimSubmission","SenderID":"CSS","MessageID":"UniqueID"}},"DataArea":{"WarrantyTrainedFlag":"Y","WarrantyStartDate":"09/1/2018","UnitNumber":"9800","TSRNumber":"","TechActualHrs":"2.0","SubmittedBy":"SPUSER","SRTPenaltyPercentage":"","SPTravelRate":"","SPLaborRate":"","SPInShopLaborRate":"","SPCertifiedFlag":"N","ServiceProviderCode":"03750","RONumber":"SO1234","RoadRelayWarrantyFlg":"N","RMAFlag":"N","RevisionBefore":"","ReviewAfter":"","ReplacementPart":"","RepairDescription":"","ReConPartsWarrantyFlg":"N","PolicyRequestID":"","PenaltyFlag":"N","PaccarFlag":"N","NewPartsWarrantyFlg":"N","MultiESNFlg":"N","ModelSeries":"T408","MissionDisablingFlag":"N","Manufacturer":"KENWORTH","manualAdjudicationFlag":"N","ListOfPromotionIds":{"PromotionIds":[{"PromotionID":"No Promotion Id"}]},"ListOfNotes":{"Notes":[{"NoteType":"SourceEnv","Note":"CGCDWTST"},{"NoteType":"Cause","Note":""},{"NoteType":"Correction","Note":"Failure Name =Engine Brake Rocker Lever Quantity =null Failure Name =Engine Brake Solenoid Valve Quantity =null Failure Name =Engine Control Module Cooling Plate Quantity =null Failure Name =Engine Intake Throttle Actuator Quantity =null Failure Name =Turbocharger Quantity =null "},{"NoteType":"Complaint","Note":null},{"NoteType":"99 Time Details","Note":"Test"},{"NoteType":"SRT","Note":""}]},"listOfFailureList":{"FailureList":[{"WarrantyId":"","SystemCode":"IN","SupportPlanID":"","PrimaryFailureFlag":"N","PayCode":"A","listOfTravelDetails":{"TravelDetails":[]},"listOfSRTs":{"SRTs":[{"SRTType":"Custom","SRTQty":"1","SRTPrcnt":"100","SRTHours":"0.5","SRTCode":"99-999","SRTAccessCode":"R","OverlapHrs":"","OutOfChasis":"Y","Offiste":"N","Justification":"Refer To Narrative","ExcludeOvrlpFlg":"N"}]},"listOfParts":{"Parts":[]},"listOfOtherClaimables":{"OtherClaimables":[]},"listOfFailureCylinder":{"FailureCylinder":[]},"FaultCode":"","FailMode":"2B","DeductibleAmount":"","CoveredTravelMiles":"0","CoveredTravelLabor":"0","CoveredTowingMiles":"0","CoveredPartsQuantity":"9999999","CoveredOCAmount":"9999999","CoveredMealsLodgingAmt":"0","CoveredLaborHours":"9999999","CoverageType":"","ComponentCode":"TD","CertificateNumber":"","CampaignTravelPrcnt":"0","CampaignTowingPrcnt":"0","CampaignPartsPrcnt":"0","CampaignOCPrcnt":"0","CampaignNumber":"","CampaignLabourPrcnt":"0","Bank":"","AuthorizationNum":"","ApproverCode":"","AccountCode":"62"}]},"ListOfComplaintCodes":{"ComplaintCodes":[{"ComplaintCode":"118"}]},"ListOfAdditionalESNs":{"AdditionalESNs":[]},"LicencePlateState":"","LastName":"","Justification":"","InfoOnlyFlag":"N","FirstName":"","FailurePoint":"10","FailureMeasure":"Miles","FailureDate":"09/6/2017","ESNCount":"1","EngineVIN":"1XKYA48X4GJ479251","EngineSerialNumber":"79812345","EngineApplicationCode":"130","ECMCalibBefore":"","ECMCalibAfter":"","DistributorCode":"03742","DISDNumber":"","DealerClaimNumber":"C0000090219-03","CustomerPossession":"No","CustomerName":"Butler Trucking- Only Failures","CSSJobID":"","Contact":"Miruthula Kanagaraj","ClaimSource":"Guidanz","ClaimFiledDate":"04/24/2019","CatastrophicFlag":"N","CampaignNumber":"","BISFlag":"N"}}';
        submID.add(claimsSub);
        insert submID;
        
        CSS_Integration_Details__c csInt = CSS_TestData.createIntegrationDetails(false);
        csInt.name = 'CSS_SBL_SubmitClaims';
        csInt.ApplicationName__c='CSS_SBL_SubmitClaims';
        csInt.End_Point__c='https://services-dev.cummins.com/csswarranty/claimsubmission';
        csInt.IsActive__c=true;
        insert csint;
        
        //List<CSS_Integration_Error__c> l1=CSS_FN_SIEBEL.callODMHeaderValidationClaimService(jo,claimsObj,psn,'JOB',SolComp,'sourceChevron');
        
        
        CSS_FN_SIEBEL.submitClaims(submID);
        
        Test.startTest();
        //test.setMock(HttpCalloutMock.class, new CSS_MockHttpResponseGenerator());
        test.setMock(HttpCalloutMock.class, new SingleRequestMockClaimsPass());
        Test.stopTest();
        
    }
    //For submit Claims Test(Negative Testing)
    public static testmethod void testClaimsCalloutFail() {
        
        CSS_Integration_Details__c csInt = CSS_TestData.createIntegrationDetails(false);
        csInt.name = 'CSS_SBL_SubmitClaims';
        csInt.ApplicationName__c='CSS_SBL_SubmitClaims';
        csInt.End_Point__c='https://services-dev.cummins.com/csswarranty/claimsubmission';
        csInt.IsActive__c=true;
        insert csint;
        
        List <CSS_Job_Order__c> lstjo = new List <CSS_Job_Order__c>();
        CSS_Job_Order__c jo = new CSS_Job_Order__c();
        jo.createdDate=dateTime.now();
        jo.ESN__c = '79464646';
        jo.Customer_Name__c='test';
        jo.Shop_Work_Order__c='uiafh';
        jo.Mileage__c=123;
        jo.Complaint_Type_Desc__c = 'CRUISE CONTROL';
        jo.Category_Desc__c = 'Fuel - Oil - Coolant';
        jo.Status__c = 'closed';
        jo.Service_Model__c = 'model';
        lstjo.add(jo);
        insert lstjo;
        
        CSS_Claims__c cl = new CSS_Claims__c();
        cl.CSS_Job__c=jo.id;
        insert cl;
        
        List<CSS_Claim_Submission__c> lstsRecord = new List<CSS_Claim_Submission__c>();
        CSS_Claim_Submission__c csub = new CSS_Claim_Submission__c();
        csub.Status__c='In Review';
        csub.Siebel_Claim_JSON__c = '{"Header":{"Target":"CSSWarranty","Sender":{"ServiceName":"ClaimSubmission","SenderID":"CSS","MessageID":"UniqueID"}},"DataArea":{"WarrantyTrainedFlag":"Y","WarrantyStartDate":"09/1/2018","UnitNumber":"9800","TSRNumber":"","TechActualHrs":"2.0","SubmittedBy":"SPUSER","SRTPenaltyPercentage":"","SPTravelRate":"","SPLaborRate":"","SPInShopLaborRate":"","SPCertifiedFlag":"N","ServiceProviderCode":"03750","RONumber":"SO1234","RoadRelayWarrantyFlg":"N","RMAFlag":"N","RevisionBefore":"","ReviewAfter":"","ReplacementPart":"","RepairDescription":"","ReConPartsWarrantyFlg":"N","PolicyRequestID":"","PenaltyFlag":"N","PaccarFlag":"N","NewPartsWarrantyFlg":"N","MultiESNFlg":"N","ModelSeries":"T408","MissionDisablingFlag":"N","Manufacturer":"KENWORTH","manualAdjudicationFlag":"N","ListOfPromotionIds":{"PromotionIds":[{"PromotionID":"No Promotion Id"}]},"ListOfNotes":{"Notes":[{"NoteType":"SourceEnv","Note":"CGCDWTST"},{"NoteType":"Cause","Note":""},{"NoteType":"Correction","Note":"Failure Name =Engine Brake Rocker Lever Quantity =null Failure Name =Engine Brake Solenoid Valve Quantity =null Failure Name =Engine Control Module Cooling Plate Quantity =null Failure Name =Engine Intake Throttle Actuator Quantity =null Failure Name =Turbocharger Quantity =null "},{"NoteType":"Complaint","Note":null},{"NoteType":"99 Time Details","Note":"Test"},{"NoteType":"SRT","Note":""}]},"listOfFailureList":{"FailureList":[{"WarrantyId":"","SystemCode":"IN","SupportPlanID":"","PrimaryFailureFlag":"N","PayCode":"A","listOfTravelDetails":{"TravelDetails":[]},"listOfSRTs":{"SRTs":[{"SRTType":"Custom","SRTQty":"1","SRTPrcnt":"100","SRTHours":"0.5","SRTCode":"99-999","SRTAccessCode":"R","OverlapHrs":"","OutOfChasis":"Y","Offiste":"N","Justification":"Refer To Narrative","ExcludeOvrlpFlg":"N"}]},"listOfParts":{"Parts":[]},"listOfOtherClaimables":{"OtherClaimables":[]},"listOfFailureCylinder":{"FailureCylinder":[]},"FaultCode":"","FailMode":"2B","DeductibleAmount":"","CoveredTravelMiles":"0","CoveredTravelLabor":"0","CoveredTowingMiles":"0","CoveredPartsQuantity":"9999999","CoveredOCAmount":"9999999","CoveredMealsLodgingAmt":"0","CoveredLaborHours":"9999999","CoverageType":"","ComponentCode":"TD","CertificateNumber":"","CampaignTravelPrcnt":"0","CampaignTowingPrcnt":"0","CampaignPartsPrcnt":"0","CampaignOCPrcnt":"0","CampaignNumber":"","CampaignLabourPrcnt":"0","Bank":"","AuthorizationNum":"","ApproverCode":"","AccountCode":"62"}]},"ListOfComplaintCodes":{"ComplaintCodes":[{"ComplaintCode":"118"}]},"ListOfAdditionalESNs":{"AdditionalESNs":[]},"LicencePlateState":"","LastName":"","Justification":"","InfoOnlyFlag":"N","FirstName":"","FailurePoint":"10","FailureMeasure":"Miles","FailureDate":"09/6/2017","ESNCount":"1","EngineVIN":"1XKYA48X4GJ479251","EngineSerialNumber":"79812345","EngineApplicationCode":"130","ECMCalibBefore":"","ECMCalibAfter":"","DistributorCode":"03742","DISDNumber":"","DealerClaimNumber":"C0000090219-03","CustomerPossession":"No","CustomerName":"Butler Trucking- Only Failures","CSSJobID":"","Contact":"Miruthula Kanagaraj","ClaimSource":"Guidanz","ClaimFiledDate":"04/24/2019","CatastrophicFlag":"N","CampaignNumber":"","BISFlag":"N"}}';
        lstsRecord.add(csub);
        insert lstsRecord;
        
        /* List< CSS_Integration_Error__c> lsterror = new  List< CSS_Integration_Error__c>();
CSS_Integration_Error__c errObj = new CSS_Integration_Error__c();
errObj.Error_Description__c = 'Submit Claims to Siebel HttpResponse is null' + ' *** External Message ** ' + 'OSB Service Callout action received SOAP Fault response';
errObj.Source__c = 'Siebel';
errObj.Processed_Data__c = 'CSS_FN_Siebel-Submit Claims to Siebel';
lsterror.add(errObj);
insert lsterror;

list<CSS_JobHistory__c> jobHistoryToInsertList = new list<CSS_JobHistory__c>();
CSS_JobHistory__c jobHist = new CSS_JobHistory__c();
//jobHist.CSS_Field_Name__c = 'Claim '+c.CSS_Claims__r.name+' was retuned with Error status from Siebel.';
jobHist.CSS_Job_Id__c = lstsRecord[0].Id;
jobHist.CSS_Object_Name__c = 'CSS_Claim__c';
jobHistoryToInsertList.add(jobHist);
insert jobHistoryToInsertList;  */
        
        Test.startTest();
        test.setMock(HttpCalloutMock.class, new SingleRequestMockClaimsFail());
        //css_utility.LogOutIntError('CSS_FN_Siebel-GetApprovalAuthCodes', 'Submit Claims to Siebel HttpResponse is null', 'OSB Service Callout action received SOAP Fault response', 'Siebel');
        
        //test.setMock(HttpCalloutMock.class, new CSS_MockHttpResponseGenerator());
        HttpResponse h = new HttpResponse();
        h.setBody('OSB Service Callout action received SOAP Fault response');
        h.setStatusCode(200);
        CSS_FN_SIEBEL.httpResTest = h;
        CSS_FN_SIEBEL.submitClaims(lstsRecord);
        
        string jsonRespBody = '{'+
'  "Header":{'+
'    "Status":"Success",'+
'    "ReturnCodeDescription":""'+
'  },'+
'  "DataArea":{'+
'    "Status":"Success",'+
'    "ClaimNumber":"1-3635823017",'+
'    "ErrorMessage":""'+
'  }'+
'}';
        h.setBody(jsonRespBody);
        h.setStatusCode(200);
        CSS_FN_SIEBEL.httpResTest = h;
        CSS_FN_SIEBEL.submitClaims(lstsRecord);
        CSS_FN_SIEBEL.httpResTest = null;
        CSS_FN_SIEBEL.submitClaims(lstsRecord);
         string jsonRespBody1 = '{'+
'  "Header":{'+
'    "Status":"Error",'+
'    "ReturnCodeDescription":""'+
'  },'+
'  "DataArea":{'+
'    "Status":"Success",'+
'    "ClaimNumber":"1-3635823017",'+
'    "ErrorMessage":""'+
'  }'+
'}';
        h.setBody(jsonRespBody1);
        h.setStatusCode(200);
        CSS_FN_SIEBEL.httpResTest = h;
        CSS_FN_SIEBEL.submitClaims(lstsRecord);

        Test.stopTest(); 
    }
    //For submit Claims Test
    global class SingleRequestMockClaimsPass implements HttpCalloutMock {
        
        global HTTPResponse respond(HTTPRequest req) {
            HttpResponse resp = new HttpResponse();
            resp.setStatusCode(200);
            resp.setBody('{'+
                         ''+
                         '    \"DataArea\": {'+
                         ''+
                         '        \"Status\": \"SUCCESS\",'+
                         ''+
                         '        \"ErrorMessage\": \"ERRRR\",'+
                         ''+
                         '        \"ClaimNumber\": \"C1-1\"'+
                         ''+
                         '    },'+
                         ''+
                         '    \"Header\": {'+
                         ''+
                         '        \"ReturnCodeDescription\": \"TEST\",'+
                         ''+
                         '        \"Status\": \"SUCCESS\"'+
                         ''+
                         '    }'+
                         ''+
                         '}');
            return resp;
        }
    }   
    //For submit Claims Test
    global class SingleRequestMockClaimsFail implements HttpCalloutMock {
        
        global HTTPResponse respond(HTTPRequest req) {
            HttpResponse resp = new HttpResponse();
            resp.setStatusCode(400);
            resp.setBody('{'+
                         ''+
                         '    \"DataArea\": {'+
                         
                         '    },'+
                         ''+
                         '    \"Header\": {'+
                         ''+
                         '        \"ReturnCodeDescription\": \"TEST\",'+
                         ''+
                         '        \"Status\": \"SUCCESS\"'+
                         ''+
                         '    }'+
                         ''+
                         '}');
            return resp;
        }
    }
    static testmethod void fetchSPDatatestmethod()
    {
        string sh1 = 'sp123-4587;;ServiceModelName;;2017-10-10;;123;;';
        list<string> sh = new list<string>();
        sh.add(sh1);
        CSS_Integration_Details__c inte3 = new CSS_Integration_Details__c();
        Blob key3 = Blob.valueOf('12345678901234567890123456789012');
        string algo3 = 'AES256';
        inte3.Name = 'CSS_SPDataLookup';
        inte3.Username__c = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key3, Blob.valueOf('test')));
        inte3.Passcode__c = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key3, Blob.valueOf('test')));
        inte3.Key__c = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key3, Blob.valueOf('1234')));
        inte3.ApplicationName__c = 'CSS_SPDataLookup';
        inte3.End_Point__c = 'https://services-stg.cummins.com/csswarranty/serviceproviderdataTest';
        inte3.IsActive__c = true;
        insert inte3;
        Test.setMock(HttpCalloutMock.class , new CSS_MockHttpResponseGenerator());
        test.startTest();
        css_fn_siebel.fetchSPDataClaims(sh);
        test.stopTest();
    }
    static testmethod void fetchSPDatatestmethod624()
    {
        string sh1 = 'sp123-4587;;ServiceModelName;;2017-10-10;;123;;';
        list<string> sh = new list<string>();
        sh.add(sh1);
        CSS_Integration_Details__c inte3 = new CSS_Integration_Details__c();
        Blob key3 = Blob.valueOf('12345678901234567890123456789012');
        string algo3 = 'AES256';
        inte3.Name = 'CSS_SPDataLookup';
        inte3.Username__c = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key3, Blob.valueOf('test')));
        inte3.Passcode__c = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key3, Blob.valueOf('test')));
        inte3.Key__c = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key3, Blob.valueOf('1234')));
        inte3.ApplicationName__c = 'CSS_SPDataLookup';
        inte3.End_Point__c = 'https://services-stg.cummins.com/csswarranty/serviceproviderdataTest';
        inte3.IsActive__c = true;
        insert inte3;
       // Test.setMock(HttpCalloutMock.class , new CSS_MockHttpResponseGenerator());
        test.startTest();
        css_fn_siebel.fetchSPDataClaims(sh);
        test.stopTest();
    }
     static testmethod void fetchSPDatatestmethod111()
    {
        string sh1 = 'sp123-4587;;ServiceModelName;;2017-10-10;;;;';
        list<string> sh = new list<string>();
        sh.add(sh1);
		 CSS_Integration_Details__c inte3 = new CSS_Integration_Details__c();
        Blob key3 = Blob.valueOf('12345678901234567890123456789012');
        string algo3 = 'AES256';
        inte3.Name = 'CSS_SPDataLookup';
        inte3.Username__c = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key3, Blob.valueOf('test')));
        inte3.Passcode__c = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key3, Blob.valueOf('test')));
        inte3.Key__c = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key3, Blob.valueOf('1234')));
        inte3.ApplicationName__c = 'CSS_SPDataLookup';
        inte3.End_Point__c = 'https://services-stg.cummins.com/csswarranty/serviceproviderdataTest';
        inte3.IsActive__c = true;
        insert inte3;
        css_claims__c claims=CSS_TestData.createclaims(true, null);
        string claimid= string.valueOf(claims.id);
        Test.setMock(HttpCalloutMock.class , new CSS_MockHttpResponseGenerator());
        test.starttest();
        css_fn_siebel.getServiceProviderDataClaims('12345','Test123','2017-10-10',null);
          css_fn_siebel.getServiceProviderDataClaims('12345','Test123','2017-10-10',claimid);
		test.stoptest();
    }
      static testmethod void fetchSPDatatestmethod112()
    {
        string sh1 = 'sp123-4587;;ServiceModelName;;2017-10-10;;;;';
        list<string> sh = new list<string>();
        sh.add(sh1);
		 CSS_Integration_Details__c inte3 = new CSS_Integration_Details__c();
        Blob key3 = Blob.valueOf('12345678901234567890123456789012');
        string algo3 = 'AES256';
        inte3.Name = 'CSS_SPDataLookup';
        inte3.Username__c = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key3, Blob.valueOf('test')));
        inte3.Passcode__c = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key3, Blob.valueOf('test')));
        inte3.Key__c = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key3, Blob.valueOf('1234')));
        inte3.ApplicationName__c = 'CSS_SPDataLookup';
        inte3.End_Point__c = 'https://services-stg.cummins.com/csswarranty/serviceproviderdataTest';
        inte3.IsActive__c = true;
        insert inte3;
        css_claims__c claims=CSS_TestData.createclaims(true, null);
        string claimid= string.valueOf(claims.id);
        Test.setMock(HttpCalloutMock.class , new CSS_MockHttpResponseGenerator());
        test.starttest();
       // css_fn_siebel.getServiceProviderDataClaims('12345','Test123','2017-10-10',null);
          css_fn_siebel.getServiceProviderDataClaims('12345','Test123','2017-10-10',claimid);
		test.stoptest();
    }
    static testmethod void testmethod1()
    {
        CSS_FN_SIEBEL.formatedDate('2018-02-10');
        css_fn_siebel.getspcodelist('spcodestr');
        CSS_Integration_Details__c cid1 = CSS_TestData.createIntegrationDetails(false);
        cid1.name = 'getMarketingApplicationCodes';
        cid1.ApplicationName__c = 'getMarketingApplicationCodes';
        cid1.End_Point__c = 'https://api-ue-devnf-aw-ex.cummins.com/cmi/warranty/v1/approvalauthcode';
        cid1.Method_Type__c = 'GET';
        insert cid1;
        CSS_FN_SIEBEL.getApplicationCodesData();
        css_fn_siebel.getSPInfoData();
        CSS_Integration_Details__c cid = CSS_TestData.createIntegrationDetails(false);
        cid.name = 'CSS_SBL_ApprovalAuthCode';
        cid.ApplicationName__c = 'CSS_SBL_ApprovalAuthCode';
        cid.End_Point__c = 'https://api-ue-devnf-aw-ex.cummins.com/cmi/warranty/v1/approvalauthcode';
        cid.Method_Type__c = 'GET';
        insert cid;
        css_fn_siebel.getApprovalAuthCode();
        css_fn_siebel.getTechInfoData();
        
    }
    
    static testmethod void insertresponseNegativemethod6()
    {
        string responsebody='{ "DataArea": [ { "WWID": "WWID", "LastName": "LastName", "ApprovalCode": "ApprovalCode", "ApprovalCodeActiveFlag": "ApprovalCodeActiveFlag", "FirstName": "FirstName", "AuthCode": [ "adfdfdfdf98953", "adasdasdasd87554" ] } ], "Header": { "MessageIdentifier": "MessageIdentifier", "ReturnCode": "ReturnCode", "ReturnCodeDescription": "ReturnCodeDescription", "Status": "Success" } }';
        
        String serviceName = 'GetApprovalAuthCodes';
        date d = system.today(); 
        CSS_JobEventTemporary__c jobevnt = new CSS_JobEventTemporary__c();
        jobevnt.Reason__c = 'test';
        jobevnt.Attribute1__c = '';
        jobevnt.Attribute1__c = 'test';
        jobevnt.Attribute1__c = 'test';
        jobevnt.Attribute1__c = 'test';
        jobevnt.Active__c = true;
        jobevnt.Name = 'GetApprovalAuthCodes';
        jobevnt.Key__c='ApprovalAuthCode_LastProcessed';
        insert jobevnt;
        CSS_JobEventTemporary__c jobevnt1 = new CSS_JobEventTemporary__c();
        jobevnt1.Reason__c = 'test';
        jobevnt1.Attribute1__c = '';
        jobevnt1.Attribute1__c = 'test';
        jobevnt1.Attribute1__c = 'test';
        jobevnt1.Attribute1__c = 'test';
        jobevnt1.Active__c = true;
        jobevnt1.Name = 'GetApprovalAuthCodes';
        jobevnt1.Key__c='ApprovalAuthCode';
        insert jobevnt1;
        css_fn_siebel.insertResponse(responsebody,serviceName);
    }
    static testmethod void Negativetestcaseinsertresponse7()
    {
        string responsebody='{ "DataArea": [ { "WWID": "WWID", "LastName": "LastName", "ApprovalCode": "ApprovalCode", "ApprovalCodeActiveFlag": "ApprovalCodeActiveFlag", "FirstName": "FirstName", "AuthCode": [ "adfdfdfdf98953", "adasdasdasd87554" ] }, { "WWID": "WWID", "LastName": "LastName", "ApprovalCode": "ApprovalCode", "ApprovalCodeActiveFlag": "ApprovalCodeActiveFlag", "FirstName": "FirstName", "AuthCode": [ "adfdfdfdf98953", "adasdasdasd87554" ] } ], "Header": { "MessageIdentifier": "MessageIdentifier", "ReturnCode": "ReturnCode", "ReturnCodeDescription": "ReturnCodeDescription", "Status": "Success" } }';
        String serviceName = 'GetApprovalAuthCodes';
        CG_SiebelApprovalAuthCodeResponseJ2A approvalAuthCodeResponse = new CG_SiebelApprovalAuthCodeResponseJ2A();
        try{
            approvalAuthCodeResponse = (CG_SiebelApprovalAuthCodeResponseJ2A)JSON.deserialize(responseBody, CG_SiebelApprovalAuthCodeResponseJ2A.class);
            system.assert(approvalAuthCodeResponse!=null);
        }
        catch(exception e)
        {
            system.debug('Catch block of json editor>>'+e.getMessage());
        }
        
        css_fn_siebel.insertResponse(responsebody,serviceName);
    }
    static testmethod void Negativetestcaseinsertresponse8()
    {
        string responsebody='{ "DataArea": [ { "WWID": "WWID", "LastName": "LastName", "ApprovalCode": "ApprovalCode", "ApprovalCodeActiveFlag": "ApprovalCodeActiveFlag", "FirstName": "FirstName", "AuthCode": [ "adfdfdfdf98953", "adasdasdasd87554" ] }, { "WWID": "WWID", "LastName": "LastName", "ApprovalCode": "ApprovalCode", "ApprovalCodeActiveFlag": "ApprovalCodeActiveFlag", "FirstName": "FirstName", "AuthCode": [ "adfdfdfdf98953", "adasdasdasd87554" ] } ], "Header": { "MessageIdentifier": "MessageIdentifier", "ReturnCode": "ReturnCode", "ReturnCodeDescription": "ReturnCodeDescription", "Status": "Success" } }';
        String serviceName = 'GetApprovalAuthCodes';
        CSS_JobEventTemporary__c jobevnt1 = new CSS_JobEventTemporary__c();
        jobevnt1.Reason__c = 'test';
        jobevnt1.Attribute1__c = '';
        jobevnt1.Attribute1__c = 'test';
        jobevnt1.Attribute1__c = 'test';
        jobevnt1.Attribute1__c = 'test';
        jobevnt1.Active__c = true;
        jobevnt1.Name = 'GetApprovalAuthCodes';
        jobevnt1.Key__c='ApprovalAuthCode';
        insert jobevnt1;
        CG_SiebelApprovalAuthCodeResponseJ2A approvalAuthCodeResponse = new CG_SiebelApprovalAuthCodeResponseJ2A();
        approvalAuthCodeResponse = (CG_SiebelApprovalAuthCodeResponseJ2A)JSON.deserialize(responseBody, CG_SiebelApprovalAuthCodeResponseJ2A.class);
        css_fn_siebel.insertResponse(responsebody,serviceName);
    }
    static testmethod void getServiceProviderDataIntaketestmethod()
    {
        css_job_order__c wo = new css_job_order__c();
        wo.JobLocation__c = '56230-56230';
        wo.Customer_Name__c='Gopal';
        wo.Shop_Work_Order__c ='234';
        insert wo;
        css_job_order__c wo1 = [select id,JobLocation__c,name,Customer_Name__c,Shop_Work_Order__c from css_job_order__c limit 1];
        
        date d = system.today();
        CSS_Integration_Details__c cid = CSS_TestData.createIntegrationDetails(false);
        cid.name = 'CSS_SPDataLookup';
        cid.ApplicationName__c = 'CSS_SPDataLookup';
        cid.End_Point__c = 'https://services-stg.cummins.com/csswarranty/serviceproviderdataTest';
        insert cid;
        String endPointURL = CSS_getConnnectionDetails.getConnection('CSS_SPDataLookup').End_Point__c;
        system.assert(endPointURL!=null);
        system.assertEquals('https://services-stg.cummins.com/csswarranty/serviceproviderdataTest',endPointURL);
        test.startTest();
        Test.setMock(HttpCalloutMock.class , new CG_getServiceProviderDataIntakemock_test());
        css_fn_siebel ah = new css_fn_siebel();
        
        ah.getServiceProviderDataIntake(wo1,'56230-56230','SPDataLookup',d,wo.id);
        test.stopTest();
    }
    static testmethod void getServiceProviderDataIntaketestmethod1()
    {
        css_job_order__c wo = new css_job_order__c();
        wo.JobLocation__c = '56230-56230';
        wo.Customer_Name__c='Gopal';
        wo.Shop_Work_Order__c ='234';
        insert wo;
        css_job_order__c wo1 = [select id,JobLocation__c,name,Customer_Name__c,Shop_Work_Order__c from css_job_order__c limit 1];
        CSS_Integration_Details__c cid = CSS_TestData.createIntegrationDetails(false);
        cid.name = 'CSS_SPDataLookup';
        cid.ApplicationName__c = 'CSS_SPDataLookup';
        cid.End_Point__c = 'https://services-stg.cummins.com/csswarranty/serviceproviderdataTest';
        insert cid;
        
        date d = system.today();
        String endPointURL = CSS_getConnnectionDetails.getConnection('CSS_SPDataLookup').End_Point__c;
        system.assert(endPointURL!=null);
        system.assertEquals('https://services-stg.cummins.com/csswarranty/serviceproviderdataTest',endPointURL);
        test.startTest();
        
        css_fn_siebel ah = new css_fn_siebel();
        
        ah.getServiceProviderDataIntake(wo1,'56230-56230','SPDataLookup',d,wo.id);
        test.stopTest();
    }
    static testmethod void getPartsReturnClaimsTestMethod(){
        
        List<CSS_Parts_Options__c> lstparts = new List<CSS_Parts_Options__c>();
        CSS_Integration_Details__c cid = CSS_TestData.createIntegrationDetails(false);
        cid.name = 'CSS_SBL_GetPartReturns';
        cid.ApplicationName__c = 'CSS_SBL_getpartreturn';
        cid.End_Point__c = 'https://services-stg.cummins.com/csswarranty/getpartreturn';
        insert cid;
        
        
        
        
        CSS_Job_Order__c JO = CSS_TestData.createJobOrder(FALSE);
        JO.CSS_Channel_Code__c ='101';
        JO.Qsol_Engine_Family_Code__c ='122';
        JO.Territory_Class__c = '22';
        INSERT jO;
        
        CSS_Claims__c cj = new CSS_Claims__c();
        cj.CSS_Channel_Code__c='101';
        cj.Territory_Class__c='100';
        cj.ESN__c='73806085';
        cj.Location_Code__c='02850-02991';
        cj.CSS_Channel_Of_Distribution__c='101-DISTRIBUTOR-BRANCH';
        cj.Territory_Class_Name__c='UNITED STATES';
        cj.Territory__c='';
        cj.CSS_Job__c=jo.id;
        //insert cj;
        String grpName = 'CQ'+'-'+'12345-12345';
        Group testQue = new Group(Name=grpName, type='Queue');
        insert testQue;
        
        system.runas(new User(Id=UserInfo.getUserId()))
        { 
            
            QueueSObject tq = new QueueSObject(SobjectType='CSS_Claims__c', QueueId=testQue.Id);
            insert tq;
            //Id recTyIdpart = Schema.SObjectType.CSS_Parts_Options__c.getRecordTypeInfosByName().get('BMS Parts').getRecordTypeId();
            css_job_order__c joorder = css_testdata.createJobOrder(true);
            cj = CSS_TestData.createclaims(true,joorder.Id); 
            //insert testclaimsRec;
        }
        CSS_Parts_Options__c parts = new CSS_Parts_Options__c();
        parts.Covered__c =0.0;
        parts.Fail_Code__c ='test';
        parts.Service_partnumber__c='test';
        parts.Account_Code__c = 'test1';
        parts.Service_Job__c = jo.id;  
        parts.CSS_Claims__c = cj.id;
        lstparts.add(parts);
        insert lstparts;
        CSS_Claims__c ch1 = [SELECT Id, CSS_Job__c, CSS_Channel_Code__c, ESN__c, Location_Code__c, CSS_Channel_Of_Distribution__c,Territory_Class_Name__c,Territory_Class__c,Territory__c FROM CSS_Claims__c WHERE Id =: lstparts[0].CSS_Claims__c];
        system.assert(ch1!=null);
        date d1 =system.today();
        Test.StartTest();
        Test.setMock(HttpCalloutMock.class , new getPartsReturnClaimsmock_test());
        CSS_FN_SIEBEL.getPartsReturnClaims(lstparts);
        test.stopTest();
    }
    
        static testmethod void getPartsReturnClaimsTestMethod11(){
        
        List<CSS_Parts_Options__c> lstparts = new List<CSS_Parts_Options__c>();
        CSS_Integration_Details__c cid = CSS_TestData.createIntegrationDetails(false);
        cid.name = 'CSS_SBL_GetPartReturns';
        cid.ApplicationName__c = 'CSS_SBL_getpartreturn';
        cid.End_Point__c = 'https://services-stg.cummins.com/csswarranty/getpartreturn';
        insert cid;
        
        
        
        
        CSS_Job_Order__c JO = CSS_TestData.createJobOrder(FALSE);
        JO.CSS_Channel_Code__c ='101';
        JO.Qsol_Engine_Family_Code__c ='122';
        JO.Territory_Class__c = '22';
        INSERT jO;
        
        CSS_Claims__c cj = new CSS_Claims__c();
        cj.CSS_Channel_Code__c='101';
        cj.Territory_Class__c='100';
        cj.ESN__c='73806085';
        cj.Location_Code__c='02850-02991';
        cj.CSS_Channel_Of_Distribution__c='101-DISTRIBUTOR-BRANCH';
        cj.Territory_Class_Name__c='UNITED STATES';
        cj.Territory__c='';
        cj.CSS_Job__c=jo.id;
        //insert cj;
        String grpName = 'CQ'+'-'+'12345-12345';
        Group testQue = new Group(Name=grpName, type='Queue');
        insert testQue;
        
        system.runas(new User(Id=UserInfo.getUserId()))
        { 
            
            QueueSObject tq = new QueueSObject(SobjectType='CSS_Claims__c', QueueId=testQue.Id);
            insert tq;
            //Id recTyIdpart = Schema.SObjectType.CSS_Parts_Options__c.getRecordTypeInfosByName().get('BMS Parts').getRecordTypeId();
            css_job_order__c joorder = css_testdata.createJobOrder(true);
            cj = CSS_TestData.createclaims(true,joorder.Id); 
            //insert testclaimsRec;
        }
        CSS_Parts_Options__c parts = new CSS_Parts_Options__c();
        parts.Covered__c =0.0;
        parts.Fail_Code__c ='test';
        parts.Service_partnumber__c='test';
        parts.Account_Code__c = 'test1';
        parts.Service_Job__c = jo.id;  
        parts.CSS_Claims__c = cj.id;
        lstparts.add(parts);
        insert lstparts;
        CSS_Claims__c ch1 = [SELECT Id, CSS_Job__c, CSS_Channel_Code__c, ESN__c, Location_Code__c, CSS_Channel_Of_Distribution__c,Territory_Class_Name__c,Territory_Class__c,Territory__c FROM CSS_Claims__c WHERE Id =: lstparts[0].CSS_Claims__c];
        system.assert(ch1!=null);
        date d1 =system.today();
        Test.StartTest();
        Test.setMock(HttpCalloutMock.class , new getPartsReturnClaimsmock_test());
        CSS_FN_SIEBEL.getPartsReturnClaims(lstparts);
        test.stopTest();
    }
    
    static testmethod void getPartsReturnClaimsTestMethod1(){
        
        List<CSS_Parts_Options__c> lstparts = new List<CSS_Parts_Options__c>();
        CSS_Integration_Details__c cid = CSS_TestData.createIntegrationDetails(false);
        cid.name = 'CSS_SBL_GetPartReturns';
        cid.ApplicationName__c = 'CSS_SBL_getpartreturn';
        cid.End_Point__c = 'https://services-stg.cummins.com/csswarranty/getpartreturn';
        insert cid;
        
        date d1 =system.today();
        CSS_Claims__c cj = new CSS_Claims__c();
        cj.CSS_Channel_Code__c='101';
        cj.Territory_Class__c='100';
        cj.ESN__c='73806085';
        cj.Location_Code__c='02850-02991';
        cj.CSS_Channel_Of_Distribution__c='101-DISTRIBUTOR-BRANCH';
        cj.Territory_Class_Name__c='UNITED STATES';
        cj.Territory__c='';
        
        //insert cj;
        String grpName = 'CQ'+'-'+'12345-12345';
        Group testQue = new Group(Name=grpName, type='Queue');
        insert testQue;
        
        system.runas(new User(Id=UserInfo.getUserId()))
        { 
            
            QueueSObject tq = new QueueSObject(SobjectType='CSS_Claims__c', QueueId=testQue.Id);
            insert tq;
            //Id recTyIdpart = Schema.SObjectType.CSS_Parts_Options__c.getRecordTypeInfosByName().get('BMS Parts').getRecordTypeId();
            css_job_order__c joorder = css_testdata.createJobOrder(true);
            cj = CSS_TestData.createclaims(true,joorder.Id); 
            //insert testclaimsRec;
        }
        CSS_Parts_Options__c parts = new CSS_Parts_Options__c();
        parts.Covered__c =0.0;
        parts.Fail_Code__c ='test';
        parts.Service_partnumber__c='test';
        parts.Account_Code__c = 'test1';
        
        parts.CSS_Claims__c = cj.id;
        lstparts.add(parts);
        insert lstparts;
        CSS_PSN__c ps = new CSS_PSN__c();
        ps.Primary__c = true;
        ps.CSS_Claims__c = cj.id ;
        ps.Qsol_Engine_Family_Code__c ='100';
        ps.Failure_Date__c =d1;
        ps.PSN__c = '73806085';
        insert ps;
        
        
        Test.StartTest();
        Test.setMock(HttpCalloutMock.class , new getPartsReturnClaimsmock_test());
        CSS_FN_SIEBEL.getPartsReturnClaims(lstparts);
        test.stopTest();
    }
    
    static testmethod void getPartsReturnClaimsTestMethod2(){
        
        List<CSS_Parts_Options__c> lstparts = new List<CSS_Parts_Options__c>();
        CSS_Integration_Details__c cid = CSS_TestData.createIntegrationDetails(false);
        cid.name = 'CSS_SBL_GetPartReturns';
        cid.ApplicationName__c = 'CSS_SBL_getpartreturn';
        cid.End_Point__c = 'https://services-stg.cummins.com/csswarranty/getpartreturn';
        insert cid;
        
        CSS_Job_Order__c JO = CSS_TestData.createJobOrder(FALSE);
        JO.CSS_Channel_Code__c ='101';
        JO.Qsol_Engine_Family_Code__c ='122';
        JO.Territory_Class__c = '22';
        INSERT jO;
        
        date d1 =system.today();
        CSS_Claims__c cj = new CSS_Claims__c();
        cj.CSS_Channel_Code__c='101';
        cj.Territory_Class__c='100';
        cj.ESN__c='73806085';
        cj.Location_Code__c='02850-02991';
        cj.CSS_Channel_Of_Distribution__c='101-DISTRIBUTOR-BRANCH';
        cj.Territory_Class_Name__c='UNITED STATES';
        cj.Territory__c='';
        cj.CSS_Job__c=jo.id;
        
        //insert cj;
        String grpName = 'CQ'+'-'+'12345-12345';
        Group testQue = new Group(Name=grpName, type='Queue');
        //insert testQue;
        
        system.runas(new User(Id=UserInfo.getUserId()))
        { 
            
            QueueSObject tq = new QueueSObject(SobjectType='CSS_Claims__c', QueueId=testQue.Id);
            //insert tq;
            //Id recTyIdpart = Schema.SObjectType.CSS_Parts_Options__c.getRecordTypeInfosByName().get('BMS Parts').getRecordTypeId();
            css_job_order__c joorder = css_testdata.createJobOrder(true);
            cj = CSS_TestData.createclaims(true,joorder.Id); 
            //insert testclaimsRec;
        }
        CSS_Parts_Options__c parts = new CSS_Parts_Options__c();
        parts.Covered__c =0.0;
        parts.Fail_Code__c ='test';
        parts.Service_partnumber__c='test';
        parts.Account_Code__c = 'test1';
        parts.Service_Job__c = jo.id;  
        parts.CSS_Claims__c = cj.id;
        lstparts.add(parts);
        insert lstparts;
        
        CSS_PSN__c ps = new CSS_PSN__c();
        ps.Primary__c = true;
        ps.CSS_Claims__c = cj.id ;
        ps.Qsol_Engine_Family_Code__c ='100';
        ps.Failure_Date__c =d1;
        ps.PSN__c = '73806085';
        insert ps;
            CSS_Claims__c ch1 = [SELECT Id, CSS_Job__c, CSS_Channel_Code__c, ESN__c, Location_Code__c, CSS_Channel_Of_Distribution__c,Territory_Class_Name__c,Territory_Class__c,Territory__c FROM CSS_Claims__c WHERE Id =: lstparts[0].CSS_Claims__c];
         CSS_Job_Order__c serJob = [SELECT Id, ESN__c, CSS_Channel_Code__c, Failure_Date__c, Territory_Class__c, Qsol_Engine_Family_Code__c FROM 
                          CSS_Job_Order__c WHERE Id =: ch1.CSS_Job__c];
        //date d1 =system.today();
        Test.StartTest();
        Test.setMock(HttpCalloutMock.class , new getPartsReturnClaimsmock_test());
        CSS_FN_SIEBEL.getPartsReturnClaims(lstparts);
        test.stopTest();
    }
    static testmethod void getPartsReturnClaimsTestMethod332(){
        
        List<CSS_Parts_Options__c> lstparts = new List<CSS_Parts_Options__c>();
        CSS_Integration_Details__c cid = CSS_TestData.createIntegrationDetails(false);
        cid.name = 'CSS_SBL_GetPartReturns';
        cid.ApplicationName__c = 'CSS_SBL_getpartreturn';
        cid.End_Point__c = 'https://services-stg.cummins.com/csswarranty/getpartreturn';
        insert cid;
        
        CSS_Job_Order__c JO = CSS_TestData.createJobOrder(FALSE);
        JO.CSS_Channel_Code__c ='101';
        JO.Qsol_Engine_Family_Code__c ='122';
        JO.Territory_Class__c = '22';
        INSERT jO; 
        
        date d1 =system.today();
        CSS_Claims__c cj = new CSS_Claims__c();
        cj.CSS_Channel_Code__c='101';
        cj.Territory_Class__c='100';
        cj.ESN__c='73806085';
        cj.Location_Code__c='02850-02991';
        cj.CSS_Channel_Of_Distribution__c='101-DISTRIBUTOR-BRANCH';
        cj.Territory_Class_Name__c='UNITED STATES';
        cj.Territory__c='';
        //cj.CSS_Job__c=jo.id;
        
        //insert cj;
        String grpName = 'CQ'+'-'+'12345-12345';
        Group testQue = new Group(Name=grpName, type='Queue');
        insert testQue;
        
        system.runas(new User(Id=UserInfo.getUserId()))
        { 
            
            QueueSObject tq = new QueueSObject(SobjectType='CSS_Claims__c', QueueId=testQue.Id);
            insert tq;
            //Id recTyIdpart = Schema.SObjectType.CSS_Parts_Options__c.getRecordTypeInfosByName().get('BMS Parts').getRecordTypeId();
            css_job_order__c joorder = css_testdata.createJobOrder(true);
            cj = CSS_TestData.createclaims(false,null); 
            cj.CSS_Channel_Code__c='101';
        cj.Territory_Class__c='100';
        cj.ESN__c='73806085';
        cj.Location_Code__c='02850-02991';
        cj.CSS_Channel_Of_Distribution__c='101-DISTRIBUTOR-BRANCH';
        cj.Territory_Class_Name__c='UNITED STATES';
        cj.Territory__c='';
            insert cj;
            //insert testclaimsRec;
        }
       CSS_Parts_Options__c parts = new CSS_Parts_Options__c();
        parts.Covered__c =0.0;
        parts.Fail_Code__c ='test';
        parts.Service_partnumber__c='test';
        parts.Account_Code__c = 'test1';
        parts.Service_Job__c = jo.id;  
        parts.CSS_Claims__c = cj.id;
       
        lstparts.add(parts);
        insert lstparts;
        
        CSS_PSN__c ps = new CSS_PSN__c();
        ps.Primary__c = true;
        ps.CSS_Claims__c = cj.id ;
        ps.Qsol_Engine_Family_Code__c ='100';
        ps.Failure_Date__c =d1;
         ps.Primary__c = true;
        ps.CSS_Claims__c =cj.id;
        ps.PSN__c = '73806085';
        insert ps;
        
       
            //CSS_Claims__c ch1 = [SELECT Id, CSS_Job__c, CSS_Channel_Code__c, ESN__c, Location_Code__c, CSS_Channel_Of_Distribution__c,Territory_Class_Name__c,Territory_Class__c,Territory__c FROM CSS_Claims__c WHERE Id =: lstparts[0].CSS_Claims__c];
        // CSS_Job_Order__c serJob = [SELECT Id, ESN__c, CSS_Channel_Code__c, Failure_Date__c, Territory_Class__c, Qsol_Engine_Family_Code__c FROM 
          //                CSS_Job_Order__c WHERE Id =: ch1.CSS_Job__c];
        //date d1 =system.today();
        Test.StartTest(); 
        Test.setMock(HttpCalloutMock.class , new getPartsReturnClaimsmock_test());
        CSS_FN_SIEBEL.getPartsReturnClaims(lstparts);
        test.stopTest();
    }
    static testmethod void getPartsReturnClaimsTestMethod3(){
        
        List<CSS_Parts_Options__c> lstparts = new List<CSS_Parts_Options__c>();
        CSS_Integration_Details__c cid = CSS_TestData.createIntegrationDetails(false);
        cid.name = 'CSS_SBL_GetPartReturns';
        cid.ApplicationName__c = 'CSS_SBL_getpartreturn';
        cid.End_Point__c = 'https://services-stg.cummins.com/csswarranty/getpartreturn';
        insert cid;
        
        CSS_Job_Order__c JO = CSS_TestData.createJobOrder(FALSE);
        JO.CSS_Channel_Code__c ='101';
        JO.Qsol_Engine_Family_Code__c ='122';
        JO.Territory_Class__c = '22';
        INSERT jO; 
        
        date d1 =system.today();
        CSS_Claims__c cj = new CSS_Claims__c();
        cj.CSS_Channel_Code__c='101';
        cj.Territory_Class__c='100';
        cj.ESN__c='73806085';
        cj.Location_Code__c='02850-02991';
        cj.CSS_Channel_Of_Distribution__c='101-DISTRIBUTOR-BRANCH';
        cj.Territory_Class_Name__c='UNITED STATES';
        cj.Territory__c='';
        //cj.CSS_Job__c=jo.id;
        
        //insert cj;
        String grpName = 'CQ'+'-'+'12345-12345';
        Group testQue = new Group(Name=grpName, type='Queue');
        insert testQue;
        
        system.runas(new User(Id=UserInfo.getUserId()))
        { 
            
            QueueSObject tq = new QueueSObject(SobjectType='CSS_Claims__c', QueueId=testQue.Id);
            insert tq;
            //Id recTyIdpart = Schema.SObjectType.CSS_Parts_Options__c.getRecordTypeInfosByName().get('BMS Parts').getRecordTypeId();
            css_job_order__c joorder = css_testdata.createJobOrder(true);
            cj = CSS_TestData.createclaims(true,joorder.Id); 
            //insert testclaimsRec;
        }
       /*CSS_Parts_Options__c parts = new CSS_Parts_Options__c();
        parts.Covered__c =0.0;
        parts.Fail_Code__c ='test';
        parts.Service_partnumber__c='test';
        parts.Account_Code__c = 'test1';
        parts.Service_Job__c = jo.id;  
        parts.CSS_Claims__c = cj.id;
        lstparts.add(parts);
        insert lstparts;*/
        
        CSS_PSN__c ps = new CSS_PSN__c();
        ps.Primary__c = true;
        ps.CSS_Claims__c = cj.id ;
        ps.Qsol_Engine_Family_Code__c ='100';
        ps.Failure_Date__c =d1;
        ps.CSS_Claims__c =cj.id;
        ps.PSN__c = '73806085';
        insert ps;
        
       
            //CSS_Claims__c ch1 = [SELECT Id, CSS_Job__c, CSS_Channel_Code__c, ESN__c, Location_Code__c, CSS_Channel_Of_Distribution__c,Territory_Class_Name__c,Territory_Class__c,Territory__c FROM CSS_Claims__c WHERE Id =: lstparts[0].CSS_Claims__c];
        // CSS_Job_Order__c serJob = [SELECT Id, ESN__c, CSS_Channel_Code__c, Failure_Date__c, Territory_Class__c, Qsol_Engine_Family_Code__c FROM 
          //                CSS_Job_Order__c WHERE Id =: ch1.CSS_Job__c];
        //date d1 =system.today();
        Test.StartTest(); 
        Test.setMock(HttpCalloutMock.class , new getPartsReturnClaimsmock_test());
        CSS_FN_SIEBEL.getPartsReturnClaims(lstparts);
        test.stopTest();
    }
    
    static testmethod void getPaymentDetailstestmethod()
    {
        CSS_Integration_Details__c cid = CSS_TestData.createIntegrationDetails(false);
        cid.name = 'CSS_SBL_SubmitClaims';
        cid.ApplicationName__c = 'CSS_SBL_SubmitClaims';
        cid.End_Point__c = 'https://services-stg.cummins.com/csswarranty/getsummitclaim';
        insert cid;
        
        
        
        CSS_Claims__c cj = new CSS_Claims__c();
        cj.CSS_Channel_Code__c='101';
        cj.Territory_Class__c='100';
        cj.ESN__c='73806085';
        cj.Location_Code__c='03742-03750';
        cj.CSS_Channel_Of_Distribution__c='101-DISTRIBUTOR-BRANCH';
        cj.Territory_Class_Name__c='UNITED STATES';
        cj.Territory__c='';
        
        //insert cj;
        String grpName = 'CQ'+'-'+'12345-12345';
        Group testQue = new Group(Name=grpName, type='Queue');
        insert testQue;
        
        system.runas(new User(Id=UserInfo.getUserId()))
        { 
            
            QueueSObject tq = new QueueSObject(SobjectType='CSS_Claims__c', QueueId=testQue.Id);
            insert tq;
            //Id recTyIdpart = Schema.SObjectType.CSS_Parts_Options__c.getRecordTypeInfosByName().get('BMS Parts').getRecordTypeId();
            css_job_order__c joorder = css_testdata.createJobOrder(true);
            cj = CSS_TestData.createclaims(true,joorder.Id); 
            //insert testclaimsRec;
        }
        
        CSS_Claim_Submission__c cla = new CSS_Claim_Submission__c();
        cla.CSS_Claims__c = cj.id;
        cla.Claim_Status__c = 'Summited';
        
        list<CSS_Claim_Submission__c> clalst = new list<CSS_Claim_Submission__c>();
        clalst.add(cla);
        insert clalst;
        test.starttest();
        
        css_fn_siebel.getPaymentDetails(clalst);
        test.stoptest();
    }
    static testmethod void inserttechinfodatatestmethod()
    {
        Account a= new Account();
        date d1=system.today();
        a.Product_Certification__c=false;
        a.WR_WWSPS_Cert_Date__c=d1;
        a.Territory__c='Unitead States';
        a.Warranty_Training_Certification__c=false;
        a.Region__c='North America';
        a.WWSPS_Profile_Status__c='Active';
        a.Promotion_Id_Flag__c=false;
        a.IAM_Service_Provider_Code__c='23456';
        a.CSS_DistributorCode__c='23456';
        a.CMI_Account_Status__c = 'Active';
        a.name='Gopal';
        insert a;
        date d2 = system.today();
        CSS_Accreditation__c CAuser = new CSS_Accreditation__c();
        CAuser.Account__c=a.id;
        system.debug('ACCOUNT ID--'+a.Id);
        CAuser.Service_Model_Name__c='K19';
        CAuser.StartDate__c=d2;
        CAuser.EndDate__c=d1;
        CAuser.QUAL_PROG_ID__c='';
        CAuser.Certification_Status__c='';
        insert CAuser;
        test.startTest();
        String json = '{ "DataArea": [{ "SP_CODE": 23456, "SPPROFILESTATUS": "Cancelled", "TECH_CERTIFICATION":[ { "SMNDETAILS": [ { "SMN": "K19" } ], "TechFName": "", "TechPromoID": "", "TechLogin": "", "TechLName": "" }] }], "Header": { "ReturnCodeDescription": "", "Status": "Success", "ReturnCode": "", "MessageIdentifier": "2017-06-04" } }';
        CSS_WPR_SBL_GetTechInfoResJSON obj = CSS_WPR_SBL_GetTechInfoResJSON.parse(json);
        css_fn_siebel.insertTechInfoData(obj);
        test.stopTest();
    }
    static testmethod void insertSPInfoDatatestmethod()
    {
        Account a = new Account ();
        a.Name = 'siva';
        a.IAM_Service_Provider_Code__c='23456';
        a.CSS_DistributorCode__c='23456';
        a.IAM_Service_Provider_Code__c='23456';
        insert a;
        system.debug('My Account details---'+a);
        string json = '{ "DataArea": [ { "PROMOTION_ID_FLAG": "Y", "SP_CERTIFICATION": [ { "SMN": "ISB CM2150", "OEM_NAME": "PETERBILT OF CANADA LTD", "OEM_CODE": "PETERBILT OF CANADA LTD", "START_DATE": "", "SERVICE_LEVEL": "", "PRODUCT_DETAILS": [ { "PRODUCT_RANGE": "TestingRange", "MARKET_APPLICATION": "Engine", "PRODUCT_TYPE": "Engine" } ], "END_DATE": "" } ], "SP_CODE": "23456", "PRODUCT_CERTIFICATION_FLAG": "Y", "SP_NAME": "Gopal", "SP_CHANNEL_OF_DISTRIBUTION": "101", "TERRITORY": "CANADA", "WRNTY_TRAINING_CERTIFICATION": "Y", "REGION": "NORTH AMERICA", "SP_CHANNEL_CODE": "101", "RSS_RESP_BRANCH_CODE": "101", "RSS_RESP_BRANCH_NAME": "101", "RESP_BRANCH_CODE": "101", "RESP_BRANCH_NAME": "101", "SP_BILL_TO_CODE": "101", "SP_BILL_TO_NAME": "101", "DIST_HQ_CODE": "101", "DIST_HQ_NAME": "101", "SP_FIRST_NAME": "101", "SP_LAST_NAME": "101", "SP_PHONE": "101", "SP_EMAIL": "101", "WWSPS_FLAG": "101", "ACCOUNT_STATUS": "101", "BUSINESS_UNIT": "101", "SP_RECERTIFICATION_DATE": "101", "CREATED_DATE": "101", "UPDATED_DATE": "101", "CERTIFICATION_END_DATE": "101", "WARRANTY_TRAINING_STATUS": "101" } ], "Header": { "ReturnCodeDescription": "", "Status": "Success", "ReturnCode": "", "MessageIdentifier": "2017-06-04" } }';
        CG_OP_GetSPInfoResJSON techInfoResJSON = CG_OP_GetSPInfoResJSON.parse(json);
        CSS_FN_SIEBEL.insertSPInfoData(techInfoResJSON);
        
    }
    static testmethod void updateAccreditationDatamethod(){
        string json = '{ "DataArea": [ { "PROMOTION_ID_FLAG": "Y", "SP_CERTIFICATION": [ { "SMN": "ISB CM2150", "OEM_NAME": "PETERBILT OF CANADA LTD", "OEM_CODE": "PETERBILT OF CANADA LTD", "START_DATE": "", "SERVICE_LEVEL": "", "PRODUCT_DETAILS": [ { "PRODUCT_RANGE": "TestingRange", "MARKET_APPLICATION": "Engine", "PRODUCT_TYPE": "Engine" } ], "END_DATE": "" } ], "SP_CODE": 23456, "PRODUCT_CERTIFICATION_FLAG": "Y", "SP_NAME": "Gopal", "SP_CHANNEL_OF_DISTRIBUTION": "101", "TERRITORY": "CANADA", "WRNTY_TRAINING_CERTIFICATION": "Y", "REGION": "NORTH AMERICA", "SP_CHANNEL_CODE": "101", "RSS_RESP_BRANCH_CODE": "101", "RSS_RESP_BRANCH_NAME": "101", "RESP_BRANCH_CODE": "101", "RESP_BRANCH_NAME": "101", "SP_BILL_TO_CODE": "101", "SP_BILL_TO_NAME": "101", "DIST_HQ_CODE": "101", "DIST_HQ_NAME": "101", "SP_FIRST_NAME": "101", "SP_LAST_NAME": "101", "SP_PHONE": "101", "SP_EMAIL": "101", "WWSPS_FLAG": "101", "ACCOUNT_STATUS": "101", "BUSINESS_UNIT": "101", "SP_RECERTIFICATION_DATE": "101", "CREATED_DATE": "101", "UPDATED_DATE": "101", "CERTIFICATION_END_DATE": "101", "WARRANTY_TRAINING_STATUS": "101" } ], "Header": { "ReturnCodeDescription": "", "Status": "Success", "ReturnCode": "", "MessageIdentifier": "2017-06-04" } }';
        CG_OP_GetSPInfoResJSON op = CG_OP_GetSPInfoResJSON.parse(json);
        system.assert(op.DataArea!=null);
        system.assert(op!=null);
        CG_OP_GetSPInfoResJSON obj = CG_OP_GetSPInfoResJSON.parse(json);
        System.assert(obj != null);
        
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
        User u = new User(Alias = 'kal2', Email='standarduser11@testorg.com', 
                          EmailEncodingKey='UTF-8', LastName='kal12', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = p.Id, 
                          TimeZoneSidKey='America/Los_Angeles', UserName='kal10@testorg.com', user_Location__c = '03520-04892',isActive = true);
        insert(u);
        
        Set<String> setAllSMNSet = new Set<String>();
        string st = '03520-04892';
        setAllSMNSet.add(st);
        //insert setAllSMNSet;
        
        Account a = new Account();
        a.Name = '03520-04892';
        // a.Location__c = '56270-56270';
        a.CSS_DistributorCode__c ='03520';
        a.IAM_Service_Provider_Code__c = '04892';
        
        insert a;
        
        CSS_UserLocation__c userloc = new CSS_UserLocation__c();
        userloc.name= '03520-04892';
        //userloc.location_name__c = '03520-04892';
        userloc.Location_code__c = '03520-04892';
        userloc.isActive__c = true;
        userloc.UserId__c = u.id;
        userloc.AccountId__c = a.id;
        insert userloc;
        
        CSS_Accreditation__c acc = new CSS_Accreditation__c();
        acc.Service_Model_Name__c = '03520-04892';
        acc.Account__c = a.id;
        insert acc;
        
        Map<String,id> mapSpCodeAccountIdMap = new Map<String,id>();
        mapSpCodeAccountIdMap.put('a.Location__c',a.id);
        // insert mapSpCodeAccountIdMap;
        
        CSS_FN_SIEBEL.updateAccreditationData(obj,setAllSMNSet,mapSpCodeAccountIdMap);
        
        
    }    
    
    static testmethod void CallGetClaimDetailsmethod(){
        system.debug('Inside CallGetClaimDetailsmethod method from Test');
        CSS_Integration_Details__c cid = CSS_TestData.createIntegrationDetails(false);
        cid.name = 'CSS_SBL_GetClaimDetails';
        cid.ApplicationName__c = 'CSS_SBL_GetClaimDetails';
        cid.Method_Type__c = 'GET';
        cid.End_Point__c = 'https://api-ue-devnf-aw-ex.cummins.com/cmi-claims/claims?sender=CSS&target=CSSWarranty&siebelClaimNumber=1-1011307897';
        insert cid;
        Test.setMock(HttpCalloutMock.class , new CSS_MockHttpResponseGenerator());
            
            Test.StartTest();
            CSS_GetClaimDetailsResponse resp = new CSS_GetClaimDetailsResponse();
            resp = CSS_FN_SIEBEL.CallGetClaimDetails('1-1011307897');
            Test.stopTest();
        
        //CSS_FN_SIEBEL.CallGetClaimDetails('C1-1');
        
    }
    static testmethod void getpartsdatamethod(){
        CSS_Integration_Details__c cid = CSS_TestData.createIntegrationDetails(false);
        cid.name = 'CSS_SBL_GetPartsData';
        cid.ApplicationName__c = 'CSS_SBL_GetPartsData';
        cid.Method_Type__c = 'GET';
        cid.End_Point__c = 'https://api-ue-devnf-aw-ex.cummins.com/cmi-engine/parts?sender=CSS&target=CSSWarranty&partNumberShort=3899283';
        insert cid;
        CSS_FN_SIEBEL.getpartsdata('23456');
        
    }
    static testmethod void getClaimDetailsmethod(){
        
        CSS_FN_SIEBEL.getClaimDetails('C0000190119');
        
    }  
    static testmethod void sendnotesdetailsmethod(){
        
    
        Test.StartTest();
        
        CSS_Integration_Details__c cid = CSS_TestData.createIntegrationDetails(false);
        cid.name = 'CG_SBL_SendNotesDetails';
        cid.ApplicationName__c = 'CG_SBL_SendNotesDetails';
        cid.Method_Type__c = 'POST';
        cid.End_Point__c = 'https://api-ue-devnf-aw-ex.cummins.com/cmi-claims/notes';
        insert cid;
        
        CSS_Claim_Submission__c cs=  new CSS_Claim_Submission__c();
        cs.name = 'SendNotesTest';
        cs.Individual_Claim_Id__c = 'C0000182919-01';
        cs.Siebel_Claim_Number__c = '1-2100290208';
        insert cs;
        
        List<Note> notesList = new List<Note>();
        Note nt = new Note();
        nt.ParentId = cs.Id;
        nt.title = 'SP Update';
        notesList.add(nt);
        insert notesList;
        
        CSS_FN_SIEBEL.sendnotesdetails(cs.Individual_Claim_Id__c,notesList);
        Test.stopTest();
    }
    
    static testmethod void paidclaimdetailsmethod(){
        
        string json='{ "DataArea": { "ClaimNumber": "c0989474", "IMSClaimNumber": "1820" }, "Header": { "Sender": { "MessageID": "MessageID", "ServiceName": "ServiceName", "SenderID": "SenderID" } } }';
        CG_PaidClaimsDetailsReqWrapper op= CG_PaidClaimsDetailsReqWrapper.parse(json);
        system.assert(op!=null);
        system.assert(op.Header!=null);
        system.assert(op.DataArea!=null);
        CG_PaidClaimsDetailsReqWrapper obj = CG_PaidClaimsDetailsReqWrapper.parse(json);
        System.assert(obj != null);
        CSS_Integration_Details__c inte3 = new CSS_Integration_Details__c();
         Blob key3 = Blob.valueOf('12345678901234567890123456789012');
            string algo3 = 'AES256';
            inte3.Name = 'CG_SBL_Getpaidclaimdetails';
            inte3.Username__c = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key3, Blob.valueOf('test')));
            inte3.Passcode__c = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key3, Blob.valueOf('test')));
            inte3.Key__c = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key3, Blob.valueOf('1234')));
            inte3.ApplicationName__c = 'GetCampaign';
            inte3.End_Point__c = 'https://services-stg.cummins.com/csswarranty/serviceproviderdata';
            inte3.IsActive__c = true;
            inte3.Timeout__c = 120000;
            inte3.Method_Type__c = 'POST';
            insert inte3;
            system.debug('***inte4***'+inte3);
        
        test.startTest();
        CSS_FN_SIEBEL.paidclaimdetails(obj);
        test.stopTest();
    }
    static testmethod void CSS_FN_SIEBEL_TEST_Method1(){
        // CSS_FN_SIEBEL.insertResponse('response','service')
        //CSS_FN_SIEBEL.insertResponse('response','service');
        //CSS_FN_SIEBEL.insertResponse('response','GetApplicationList');
        //CSS_FN_SIEBEL.insertResponse('response','getMarketingApplicationCodes');
        //  CSS_FN_SIEBEL.insertResponse('response','GetAccountCodes');
        CSS_FN_SIEBEL.storeApplicationOrCategoryComplaintList('service');      
        CSS_Integration_Details__c inteDetails = new CSS_Integration_Details__c(); 
        // inteDetails.Name = 'CSS_SBL_ApplicationCodes';
        inteDetails.Name = 'CSS_SBL_FailModes';
        inteDetails.ApplicationName__c = 'CSS_SBL_FailModes';
        inteDetails.End_Point__c = 'https://services-stg.cummins.com/csswarranty/failmodes';
        inteDetails.IsActive__c = true;
        inteDetails.Key__c = 'Iq387gGOWefsBz2QQLpFxBrJOxdR1EXXnAXj5NySofg=';
        inteDetails.Passcode__c = 'FmTHgD/+Vg2TwIHNXeX7I+kuaMp1Uskd4QJ7bTFHJCc=';
        inteDetails.Username__c = '4YUt8CU2IuJAC9oD98njLAdVi6CmK1+epo/qQV0ZE3c=';
        insert inteDetails;
        //   test.setMock(HttpCalloutMock.class, new CSS_MockHttpResponseGenerator());
        CSS_FN_SIEBEL.storeApplicationOrCategoryComplaintList('getFailModes');
        date d = system.today(); 
        CSS_JobEventTemporary__c jobevnt = new CSS_JobEventTemporary__c();
        jobevnt.Reason__c = 'test';
        jobevnt.Attribute13__c = d;
        jobevnt.Name = 'CategoryComplaintCodes';
        insert jobevnt;
        CSS_FN_SIEBEL.insertResponse('response','service');
        //CSS_FN_SIEBEL.insertResponse('response','getFailModes');
        /*CSS_FN_SIEBEL.insertResponse('response','GetAccountCodes');
CSS_FN_SIEBEL.insertResponse('response','FailModes');
CSS_FN_SIEBEL.insertResponse('response','FailCodes');
CSS_FN_SIEBEL.insertResponse('response','service');
*/
    }
    static testMethod void insertSpheaderdatamethod()
    {
        String json = '{'+
		'    \"Header\": {'+
		'        \"Status\": \"SUCCESS\",'+
		'        \"MessageIdentifier\": \"e639aac0-934b-11e9-a754-022059974d50\",'+
		'        \"ReturnCodeDescription\": \"Records Processed Successfully\"'+
		'    },'+
		'    \"DataArea\": {'+
		'        \"HeaderInfo\": ['+
		'            {'+
		'                \"SpCode\": \"10755\",'+
		'                \"SpRowId\": \"1-KX7-115\",'+
		'                \"SpName\": \" BEAM MACK SALES & SERVICE, INC. DBA BUFFALO TRUCK CENTER INC.\",'+
		'                \"ChannelOfDistribution\": \"110-DEALER\",'+
		'                \"ChannelCode\": \"110\",'+
		'                \"RssRespBranchCode\": \"02026\",'+
		'                \"RssRespBranchName\": \"EAST  - BUFFALO\",'+
		'                \"RespBranchCode\": \"02026\",'+
		'                \"RespBranchName\": \"EAST  - BUFFALO\",'+
		'                \"SpBillToCode\": \"02020\",'+
		'                \"SpBillToName\": \"EAST - BOSTON HQ\",'+
		'                \"DistHqCode\": \"02020\",'+
		'                \"DistHqName\": \"EAST - BOSTON HQ\",'+
		'                \"SpFirstName\": \"Keith\",'+
		'                \"SpLastName\": \"Miller\",'+
		'                \"SpPhone\": null,'+
		'                \"SpEmail\": \"keith@buffalotruckcenter.com\",'+
		'                \"WwspsFlag\": \"Y\",'+
		'                \"AccountStatus\": \"Active\",'+
		'                \"BusinessUnit\": \"EBU\",'+
		'                \"SpRecertificationDate\": \"2019-08-15T00:00:00\",'+
		'                \"SpCreatedDate\": \"2016-11-17T16:07:20\",'+
		'                \"SpUpdatedDate\": \"2019-06-07T13:15:15\",'+
		'                \"PromotionIdFlag\": \"Y\",'+
		'                \"ProductCertificationFlag\": \"Y\",'+
		'                \"CertificationEndDate\": \"2017-12-11T00:00:00\",'+
		'                \"WarrantyTrainingStatus\": \"R\",'+
		'                \"Territory\": \"UNITED STATES\",'+
		'                \"WrntyTrainingCertification\": \"Y\",'+
		'                \"Region\": \"NORTH AMERICA\",'+
		'                \"TerritoryCode\": \"100\",'+
		'                \"RegionCode\": \"USCA\",'+
		'                \"PrimaryOEMName\": \"VOLVO TRUCK NORTH AMERICA INC\",'+
		'                \"PrimaryOEMCode\": \"465\",'+
		'                \"PsbuProductCertification\": \"N\",'+
		'                \"RepairLevel\": \"N\",'+
		'                \"CostEffectiveExclusion\": \"N\",'+
		'                \"FreezeSubmitButton\": \"N\",'+
		'                \"DisableWebAccessFlag\": \"N\",'+
		'                \"Policy\": \"N\",'+
		'                \"CampaignTrp\": \"Y\",'+
		'                \"OutfileAllClaims\": \"N\",'+
		'                \"PmuSplitPayment\": \"Y\",'+
		'                \"DsId\": \"N\",'+
		'                \"DtnaFlag\": \"N\",'+
		'                \"Paccar\": \"N\",'+
		'                \"NewOEM\": \"N\",'+
		'                \"ViewDollarAmount\": \"N\",'+
		'                \"TechActualHoursRequired\": \"N\",'+
		'                \"GroupName\": null,'+
		'                \"ClaimAllowedDays\": \"365\",'+
		'                \"CmiSpExpirationDat\": \"2019-08-15T00:00:00\",'+
		'                \"LtaFlag\": \"N\",'+
		'                \"WarrantyFax\": \"716 825-2753\",'+
		'                \"WarrantyEmail\": null,'+
		'                \"CommunicationMethod\": null,'+
		'                \"CommunicationOccurrence\": null,'+
		'                \"MaxClaimAmt\": \"999999\",'+
		'                \"CutOffClaimAmt\": \"5000\",'+
		'                \"ScmDeductible\": \"7\",'+
		'                \"ScmDollarAmt\": \"70\",'+
		'                \"PhyAddress1\": \"271 DINGENS STREET\",'+
		'                \"PhyAddress2\": \"271 DINGENS STREET\",'+
		'                \"PhyAddress3\": \"271 DINGENS STREET\",'+
		'                \"PhyAddress4\": \"271 DINGENS STREET\",'+
		'                \"PhyCity\": \"BUFFALO\",'+
		'                \"PhyState\": \"NY\",'+
		'                \"PhyCountry\": \"USA\",'+
		'                \"PhyZipPostalCode\": \"14206\",'+
		'                \"MailAddress1\": \"271 DINGENS STREET\",'+
		'                \"MailAddress2\": \"271 DINGENS STREET\",'+
		'                \"MailAddress3\": \"271 DINGENS STREET\",'+
		'                \"MailAddress4\": \"271 DINGENS STREET\",'+
		'                \"MailCity\": \"BUFFALO\",'+
		'                \"MailState\": \"NY\",'+
		'                \"MailCountry\": \"USA\",'+
		'                \"MailZipPostalCode\": \"14206\"'+
		'            }'+
		'        ]'+
		'    }'+
		'}';
		
		 List<Account> AccountLst = new  List<Account>();
	    	Account acc = new Account();
            acc.name='BEAM MACK SALES & SERVICE, INC. DBA BUFFALO TRUCK CENTER INC. ';
            acc.CSS_DistributorCode__c='02850';
            acc.IAM_Service_Provider_Code__c='10755';
            acc.CSS_DBCode__c = '02026';
            acc.CSS_DealerCode__c = '10755';
            acc.Type='Dealer Account';
            acc.CMI_Account_Status__c = 'Active';
            AccountLst.add(acc);
            insert AccountLst;
		
		CG_WPR_SBL_SPHeader obj = CG_WPR_SBL_SPHeader.parse(json);
        boolean abc=CSS_FN_SIEBEL.insertSPHeaderData(obj);
}
    static testMethod void insertSPCertificationDatamethod()
    {
        String json = '{'+
		'    \"Header\": {'+
		'        \"Status\": \"SUCCESS\",'+
		'        \"MessageIdentifier\": \"025ae330-9348-11e9-a754-022059974d50\",'+
		'        \"ReturnCodeDescription\": \"Records Processed Successfully\"'+
		'    },'+
		'    \"DataArea\": {'+
		'        \"CertificationInfo\": ['+
		'            {'+
		'                \"SpCode\": \"26838\",'+
		'                \"SpRowId\": \"1-KX1-1541\",'+
		'                \"Smn\": \"6C8.3\",'+
		'                \"SpCertRowId\": \"1-E084-234\",'+
		'                \"OemCode\": \"212\",'+
		'                \"OemName\": \"HYUNDAI\",'+
		'                \"StartDate\": \"2018-10-11T00:00:00\",'+
		'                \"EndDate\": \"2999-12-31T00:00:00\",'+
		'                \"ServiceLevel\": \"FULL SERVICE\"'+
		'            },'+
		'            {'+
		'                \"SpCode\": \"26797\",'+
		'                \"SpRowId\": \"1-KX1-1537\",'+
		'                \"Smn\": \"6C8.3\",'+
		'                \"SpCertRowId\": \"1-E084-45\",'+
		'                \"OemCode\": \"212\",'+
		'                \"OemName\": \"HYUNDAI\",'+
		'                \"StartDate\": \"2018-10-11T00:00:00\",'+
		'                \"EndDate\": \"2999-12-31T00:00:00\",'+
		'                \"ServiceLevel\": \"REPAIR\"'+
		'            }'+
        '        ]'+
		'    }'+
		'}';
		CG_WPR_SBL_SPCertification obj = CG_WPR_SBL_SPCertification.parse(json);
        boolean spcer=CSS_FN_SIEBEL.insertSPCertificationData(obj);
    }
    static testMethod void insertSPAffiliationDataMethod()
    {
       string json='{ "Header": { "Status": "SUCCESS", "MessageIdentifier": "9cf45690-9331-11e9-a754-022059974d50", "ReturnCodeDescription": "Records Processed Successfully" },"DataArea": { "AffiliationInfo": [ { "Affiliation": "Affiliation", "Primary": "Primary", "LastUpdatedBy": "LastUpdatedBy", "LastUpdatedDate": "LastUpdatedDate", "AffiliationRowId": "AffiliationRowId", "SpCode": "SpCode" ,"SpRowId":"SpRowId" },{ "Affiliation": "Affiliation", "Primary": "Primary", "LastUpdatedBy": "LastUpdatedBy", "LastUpdatedDate": "LastUpdatedDate", "AffiliationRowId": "AffiliationRowId", "SpCode": "SpCode" ,"SpRowId":"SpRowId" },{ "Affiliation": "Affiliation", "Primary": "Primary", "LastUpdatedBy": "LastUpdatedBy", "LastUpdatedDate": "LastUpdatedDate", "AffiliationRowId": "AffiliationRowId", "SpCode": "SpCode" ,"SpRowId":"SpRowId" },{ "Affiliation": "Affiliation", "Primary": "Primary", "LastUpdatedBy": "LastUpdatedBy", "LastUpdatedDate": "LastUpdatedDate", "AffiliationRowId": "AffiliationRowId", "SpCode": "SpCode" ,"SpRowId":"SpRowId" }, { "Affiliation": "Affiliation", "Primary": "Primary", "LastUpdatedBy": "LastUpdatedBy", "LastUpdatedDate": "LastUpdatedDate", "AffiliationRowId": "AffiliationRowId", "SpCode": "SpCode" ,"SpRowId":"SpRowId" }, { "Affiliation": "Affiliation", "Primary": "Primary", "LastUpdatedBy": "LastUpdatedBy", "LastUpdatedDate": "LastUpdatedDate", "AffiliationRowId": "AffiliationRowId", "SpCode": "SpCode" ,"SpRowId":"SpRowId" }, { "Affiliation": "Affiliation", "Primary": "Primary", "LastUpdatedBy": "LastUpdatedBy", "LastUpdatedDate": "LastUpdatedDate", "AffiliationRowId": "AffiliationRowId", "SpCode": "SpCode" ,"SpRowId":"SpRowId" },{ "Affiliation": "Affiliation", "Primary": "Primary", "LastUpdatedBy": "LastUpdatedBy", "LastUpdatedDate": "LastUpdatedDate", "AffiliationRowId": "AffiliationRowId", "SpCode": "SpCode" ,"SpRowId":"SpRowId" },{ "Affiliation": "Affiliation", "Primary": "Primary", "LastUpdatedBy": "LastUpdatedBy", "LastUpdatedDate": "LastUpdatedDate", "AffiliationRowId": "AffiliationRowId", "SpCode": "SpCode" ,"SpRowId":"SpRowId" } ] } }';

	    List<Account> AccountLst = new  List<Account>();
	    	Account acc = new Account();
            acc.name='BEAM MACK SALES & SERVICE, INC. DBA BUFFALO TRUCK CENTER INC. ';
            acc.CSS_DistributorCode__c='02850';
            acc.IAM_Service_Provider_Code__c='10755';
            acc.CSS_DBCode__c = '02026';
            acc.CSS_DealerCode__c = '10755';
            acc.Type='Dealer Account';
            acc.CMI_Account_Status__c = 'Active';
            AccountLst.add(acc);
            insert AccountLst;
            

	    CG_WPR_SBL_SPAffiliations obj = CG_WPR_SBL_SPAffiliations.parse(json);
        boolean spa=CSS_FN_SIEBEL.insertSPAffiliationData(obj);
    }
   static testMethod void insertSPTechnicianDataMethod()
    {
         string json='{ "Header": { "Status": "SUCCESS", "MessageIdentifier": "9cf45690-9331-11e9-a754-022059974d50", "ReturnCodeDescription": "Records Processed Successfully" }, "DataArea": { "TechnicianInfo": [ { "PromotionId": "1044847", "FstName": "William", "LastName": "Denham", "SpCode": "20957", "SpRowId": "1-KWZ-567", "TechRowId": "1-MEN-5522" }, { "PromotionId": "1044839", "FstName": "Jason", "LastName": "Jones", "SpCode": "20957", "SpRowId": "1-KWZ-567", "TechRowId": "1-30ON-332" }, { "PromotionId": "A380825", "FstName": "David", "LastName": "Dillon", "SpCode": "20957", "SpRowId": "1-KWZ-567", "TechRowId": "1-MET-2764" }, { "PromotionId": "1072782", "FstName": "Gary", "LastName": "Fultz", "SpCode": "20957", "SpRowId": "1-KWZ-567", "TechRowId": "1-A5U0-4552" }, { "PromotionId": "1011165", "FstName": "Beth", "LastName": "Adkins", "SpCode": "20957", "SpRowId": "1-KWZ-567", "TechRowId": "1-A5TX-4693" }, { "PromotionId": "1044838", "FstName": "James", "LastName": "Crosier", "SpCode": "20957", "SpRowId": "1-KWZ-567", "TechRowId": "1-A5TL-6734" }, { "PromotionId": "1044845", "FstName": "Steve", "LastName": "Boucher", "SpCode": "20957", "SpRowId": "1-KWZ-567", "TechRowId": "1-MEQ-4317" }, { "PromotionId": "1045525", "FstName": "Steve", "LastName": "Adcock", "SpCode": "20957", "SpRowId": "1-KWZ-567", "TechRowId": "1-A5U0-5895" }, { "PromotionId": "B952795", "FstName": "Dirk", "LastName": "Abeln", "SpCode": "20957", "SpRowId": "1-KWZ-567", "TechRowId": "1-MEH-929" } ] } }';
	
		 List<Account> AccountLst = new  List<Account>();
	    	Account acc = new Account();
            acc.name='BEAM MACK SALES & SERVICE, INC. DBA BUFFALO TRUCK CENTER INC. ';
            acc.CSS_DistributorCode__c='02850';
            acc.IAM_Service_Provider_Code__c='10755';
            acc.CSS_DBCode__c = '02026';
            acc.CSS_DealerCode__c = '10755';
            acc.Type='Dealer Account';
            acc.CMI_Account_Status__c = 'Active';
            AccountLst.add(acc);
            insert AccountLst;
		
		CG_WPR_SBL_SPTechnicianInfo obj = CG_WPR_SBL_SPTechnicianInfo.parse(json);
        boolean sptech=CSS_FN_SIEBEL.insertSPTechnicianData(obj);
    }
    
    
     static testMethod void insertSPTechnicianSMNDataMethod()
     {
        string json='{ "Header": { "Status": "SUCCESS", "MessageIdentifier": "1c729cb0-9418-11e9-b738-126ffe1a44cc", "ReturnCodeDescription": "Records Processed Successfully" }, "DataArea": { "TechServiceModelInfo": [ { "ServiceModelName": "ISL9 CM2250", "SmnRowId": "1-D1SH-98", "SpCode": "87073", "SpRowId": "1-4H8U-3914", "CertPercentage": null, "TechRowId": "1-A5U3-3103" }, { "ServiceModelName": "ISL9 CM2250", "SmnRowId": "1-D1SH-99", "SpCode": "87203", "SpRowId": "1-80X2-3", "CertPercentage": null, "TechRowId": "1-A5U3-3125" }, { "ServiceModelName": "ISL9 CM2250", "SmnRowId": "1-D1SH-85", "SpCode": "87098", "SpRowId": "1-4H8U-3939", "CertPercentage": null, "TechRowId": "1-A5U3-4633" }, { "ServiceModelName": "ISL9 CM2250", "SmnRowId": "1-D1SH-84", "SpCode": "13092", "SpRowId": "1-KX5-178", "CertPercentage": null, "TechRowId": "1-A5U3-8429" }, { "ServiceModelName": "ISL9 CM2250", "SmnRowId": "1-D1SH-119", "SpCode": "84899", "SpRowId": "1-4ORI-27", "CertPercentage": null, "TechRowId": "1-A5U3-8803" }, { "ServiceModelName": "B6.7 CM2350 B136C", "SmnRowId": "1-DTGM-349", "SpCode": "30973", "SpRowId": "1-64KB-9", "CertPercentage": null, "TechRowId": "1-A5U6-137" }, { "ServiceModelName": "L9 CM2350 L120C", "SmnRowId": "1-DTGM-348", "SpCode": "30973", "SpRowId": "1-64KB-9", "CertPercentage": null, "TechRowId": "1-A5U6-137" }, { "ServiceModelName": "QSX15 CM2350 X105", "SmnRowId": "1-CWNC-4", "SpCode": "30973", "SpRowId": "1-64KB-9", "CertPercentage": null, "TechRowId": "1-A5U6-137" }, { "ServiceModelName": "ISL9 CM2250", "SmnRowId": "1-D1SH-42", "SpCode": "04972", "SpRowId": "1-KWZ-17", "CertPercentage": null, "TechRowId": "1-A5U6-2086" }, { "ServiceModelName": "ISL9 CM2250", "SmnRowId": "1-D1SH-49", "SpCode": "87133", "SpRowId": "1-7U3Q-15", "CertPercentage": null, "TechRowId": "1-A5U6-2805" }, { "ServiceModelName": "L9 CM2350 L120C", "SmnRowId": "1-DTGM-416", "SpCode": "03614", "SpRowId": "1-KXB-21", "CertPercentage": null, "TechRowId": "1-A5U6-3553" }, { "ServiceModelName": "ISL9 CM2250", "SmnRowId": "1-D1SH-87", "SpCode": "28749", "SpRowId": "1-KX3-1155", "CertPercentage": null, "TechRowId": "1-A5U6-3639" }, { "ServiceModelName": "ISL9 CM2250", "SmnRowId": "1-D1SH-72", "SpCode": "02002", "SpRowId": "1-KX7-4", "CertPercentage": null, "TechRowId": "1-A5U6-3881" }, { "ServiceModelName": "ISL9 CM2250", "SmnRowId": "1-D1SH-55", "SpCode": "28798", "SpRowId": "1-KX3-1204", "CertPercentage": null, "TechRowId": "1-A5U6-777" }, { "ServiceModelName": "ISL9 CM2250", "SmnRowId": "1-B8NV-1137", "SpCode": "29246", "SpRowId": "1-KX3-1652", "CertPercentage": null, "TechRowId": "1-A5U9-3750" }, { "ServiceModelName": "ISL9 CM2250", "SmnRowId": "1-D1SH-90", "SpCode": "29308", "SpRowId": "1-KX3-1714", "CertPercentage": null, "TechRowId": "1-AD73-84" }, { "ServiceModelName": "ISL9 CM2250", "SmnRowId": "1-D1SH-82", "SpCode": "66598", "SpRowId": "1-8R8F-1", "CertPercentage": null, "TechRowId": "1-AJ92-66" }, { "ServiceModelName": "ISL9 CM2250", "SmnRowId": "1-D1SH-76", "SpCode": "29125", "SpRowId": "1-KX3-1531", "CertPercentage": null, "TechRowId": "1-AR6I-81" }, { "ServiceModelName": "QSK38 CM2150 MCRS", "SmnRowId": "1-DGX5-2", "SpCode": "61670", "SpRowId": "1-KXB-1611", "CertPercentage": null, "TechRowId": "1-AU7M-18" }, { "ServiceModelName": "QSX15 CM2350 X105", "SmnRowId": "1-CWNC-7", "SpCode": "02857", "SpRowId": "1-KX5-23", "CertPercentage": null, "TechRowId": "1-AVET-1" }, { "ServiceModelName": "ISL9 CM2250", "SmnRowId": "1-D1SH-75", "SpCode": "29312", "SpRowId": "1-KX3-1718", "CertPercentage": null, "TechRowId": "1-AVET-45" }, { "ServiceModelName": "ISL9 CM2250", "SmnRowId": "1-D1SH-94", "SpCode": "32360", "SpRowId": "1-KX9-1578", "CertPercentage": null, "TechRowId": "1-AYM9-57" }, { "ServiceModelName": "ISL9 CM2250", "SmnRowId": "1-D1SH-93", "SpCode": "87203", "SpRowId": "1-80X2-3", "CertPercentage": null, "TechRowId": "1-AZV6-51" }, { "ServiceModelName": "QSX15 CM2350 X105", "SmnRowId": "1-CWNC-5", "SpCode": "92286", "SpRowId": "1-KX9-3045", "CertPercentage": null, "TechRowId": "1-B5XC-12" }, { "ServiceModelName": "ISL9 CM2250", "SmnRowId": "1-B8G2-951", "SpCode": "10838", "SpRowId": "1-KXB-79", "CertPercentage": null, "TechRowId": "1-B5XX-5" }, { "ServiceModelName": "QSF2.8 CM2880 F114", "SmnRowId": "1-DTGM-422", "SpCode": "04899", "SpRowId": "1-KX9-50", "CertPercentage": null, "TechRowId": "1-B6XD-128" }, { "ServiceModelName": "B6.7 CM2350 B136C", "SmnRowId": "1-DTGM-393", "SpCode": "39863", "SpRowId": "1-Z16-1", "CertPercentage": null, "TechRowId": "1-B6XD-187" }, { "ServiceModelName": "L9 CM2350 L120C", "SmnRowId": "1-DTGM-392", "SpCode": "39863", "SpRowId": "1-Z16-1", "CertPercentage": null, "TechRowId": "1-B6XD-187" }, { "ServiceModelName": "B6.7 CM2350 B136C", "SmnRowId": "1-DTGM-372", "SpCode": "08443", "SpRowId": "1-KX7-89", "CertPercentage": null, "TechRowId": "1-B6XD-208" }, { "ServiceModelName": "L9 CM2350 L120C", "SmnRowId": "1-DTGM-394", "SpCode": "56253", "SpRowId": "1-KX9-2596", "CertPercentage": null, "TechRowId": "1-B6XD-212" }, { "ServiceModelName": "B6.7 CM2350 B136C", "SmnRowId": "1-DTGM-391", "SpCode": "56271", "SpRowId": "1-KX1-2807", "CertPercentage": null, "TechRowId": "1-B6XD-86" }, { "ServiceModelName": "L9 CM2350 L120C", "SmnRowId": "1-DTGM-390", "SpCode": "56271", "SpRowId": "1-KX1-2807", "CertPercentage": null, "TechRowId": "1-B6XD-86" }, { "ServiceModelName": "B6.7 CM2350 B136C", "SmnRowId": "1-DTGM-329", "SpCode": "02025", "SpRowId": "1-KX9-7", "CertPercentage": null, "TechRowId": "1-B6XP-20" }, { "ServiceModelName": "ISL9 CM2250", "SmnRowId": "1-D1SH-53", "SpCode": "02025", "SpRowId": "1-KX9-7", "CertPercentage": null, "TechRowId": "1-B6XP-20" }, { "ServiceModelName": "L9 CM2350 L120C", "SmnRowId": "1-DTGM-328", "SpCode": "02025", "SpRowId": "1-KX9-7", "CertPercentage": null, "TechRowId": "1-B6XP-20" }, { "ServiceModelName": "ISL9 CM2250", "SmnRowId": "1-D1SH-108", "SpCode": "50139", "SpRowId": "1-1OZ3-10", "CertPercentage": null, "TechRowId": "1-B6XY-12" }, { "ServiceModelName": "ISL9 CM2250", "SmnRowId": "1-D1SH-14", "SpCode": "56807", "SpRowId": "1-KXB-1543", "CertPercentage": null, "TechRowId": "1-B6Y2-2" }, { "ServiceModelName": "QSG12/X12 CM2350 G110", "SmnRowId": "1-CWNC-6", "SpCode": "02409", "SpRowId": "1-KX3-23", "CertPercentage": null, "TechRowId": "1-B6Y9-130" }, { "ServiceModelName": "ISL9 CM2250", "SmnRowId": "1-D1SH-38", "SpCode": "84987", "SpRowId": "1-4UQP-1", "CertPercentage": null, "TechRowId": "1-B6Y9-98" }, { "ServiceModelName": "B6.7 CM2350 B136C", "SmnRowId": "1-DTGM-376", "SpCode": "02933", "SpRowId": "1-KX1-43", "CertPercentage": null, "TechRowId": "1-B6YF-19" }, { "ServiceModelName": "L9 CM2350 L120C", "SmnRowId": "1-DTGM-375", "SpCode": "02933", "SpRowId": "1-KX1-43", "CertPercentage": null, "TechRowId": "1-B6YF-19" }, { "ServiceModelName": "ISL9 CM2250", "SmnRowId": "1-B8IW-1040", "SpCode": "38369", "SpRowId": "1-KX3-2902", "CertPercentage": null, "TechRowId": "1-B6YI-15" }, { "ServiceModelName": "ISL9 CM2250", "SmnRowId": "1-D1SH-106", "SpCode": "02678", "SpRowId": "1-KX5-19", "CertPercentage": null, "TechRowId": "1-B6YI-50" }, { "ServiceModelName": "ISL9 CM2250", "SmnRowId": "1-D1SH-107", "SpCode": "37223", "SpRowId": "1-KWZ-2372", "CertPercentage": null, "TechRowId": "1-B6YI-67" }, { "ServiceModelName": "B6.7 CM2350 B136C", "SmnRowId": "1-DTGM-336", "SpCode": "22018", "SpRowId": "1-KX1-750", "CertPercentage": null, "TechRowId": "1-B6YL-30" }, { "ServiceModelName": "L9 CM2350 L120C", "SmnRowId": "1-DTGM-335", "SpCode": "22018", "SpRowId": "1-KX1-750", "CertPercentage": null, "TechRowId": "1-B6YL-30" }, { "ServiceModelName": "QSF2.8 CM2880 F114", "SmnRowId": "1-DTGM-353", "SpCode": "11685", "SpRowId": "1-KX5-142", "CertPercentage": null, "TechRowId": "1-B6Z4-2" }, { "ServiceModelName": "ISL9 CM2250", "SmnRowId": "1-D1SH-103", "SpCode": "33671", "SpRowId": "1-KX5-1877", "CertPercentage": null, "TechRowId": "1-B6ZH-2" }, { "ServiceModelName": "QSK38 CM2150 MCRS", "SmnRowId": "1-DGX5-5", "SpCode": "40803", "SpRowId": "1-KX7-2211", "CertPercentage": null, "TechRowId": "1-B770-2" }, { "ServiceModelName": "ISL9 CM2250", "SmnRowId": "1-D1SH-110", "SpCode": "02931", "SpRowId": "1-KWZ-13", "CertPercentage": null, "TechRowId": "1-BCCV-7" }, { "ServiceModelName": "ISL9 CM2250", "SmnRowId": "1-D1SH-109", "SpCode": "13222", "SpRowId": "1-KXB-133", "CertPercentage": null, "TechRowId": "1-BCRV-3" }, { "ServiceModelName": "QSK38 CM2150 MCRS", "SmnRowId": "1-DGX5-7", "SpCode": "40581", "SpRowId": "1-KX1-2793", "CertPercentage": null, "TechRowId": "1-BDLY-2" }, { "ServiceModelName": "QSK38 CM2150 MCRS", "SmnRowId": "1-DGX5-6", "SpCode": "40581", "SpRowId": "1-KX1-2793", "CertPercentage": null, "TechRowId": "1-BDMM-9" }, { "ServiceModelName": "ISL9 CM2250", "SmnRowId": "1-D1SH-111", "SpCode": "22888", "SpRowId": "1-KWZ-749", "CertPercentage": null, "TechRowId": "1-BFG8-1" }, { "ServiceModelName": "ISL9 CM2250", "SmnRowId": "1-D1SH-112", "SpCode": "56807", "SpRowId": "1-KXB-1543", "CertPercentage": null, "TechRowId": "1-BFTD-1" }, { "ServiceModelName": "ISL9 CM2250", "SmnRowId": "1-D1SH-113", "SpCode": "39307", "SpRowId": "1-KX1-2734", "CertPercentage": null, "TechRowId": "1-BG5R-2" }, { "ServiceModelName": "ISL9 CM2250", "SmnRowId": "1-D1SH-116", "SpCode": "32664", "SpRowId": "1-KWZ-1660", "CertPercentage": null, "TechRowId": "1-BGIC-11" }, { "ServiceModelName": "ISL9 CM2250", "SmnRowId": "1-D1SH-117", "SpCode": "04972", "SpRowId": "1-KWZ-17", "CertPercentage": null, "TechRowId": "1-BK5L-4" }, { "ServiceModelName": "ISL9 CM2250", "SmnRowId": "1-D1SH-97", "SpCode": "84744", "SpRowId": "1-4BU4-16", "CertPercentage": null, "TechRowId": "1-BK6R-2" }, { "ServiceModelName": "ISL9 CM2250", "SmnRowId": "1-D1SH-114", "SpCode": "97672", "SpRowId": "1-KXB-2749", "CertPercentage": null, "TechRowId": "1-BM6U-1" }, { "ServiceModelName": "QSK38 CM2150 MCRS", "SmnRowId": "1-DGX5-4", "SpCode": "05101", "SpRowId": "1-KX5-46", "CertPercentage": null, "TechRowId": "1-BM8W-1" }, { "ServiceModelName": "ISL9 CM2250", "SmnRowId": "1-D1SH-105", "SpCode": "02670", "SpRowId": "1-KX3-27", "CertPercentage": null, "TechRowId": "1-BPW5-11" }, { "ServiceModelName": "QSK38 CM2150 MCRS", "SmnRowId": "1-DGX5-3", "SpCode": "56273", "SpRowId": "1-KX9-2599", "CertPercentage": null, "TechRowId": "1-CYY6-3" }, { "ServiceModelName": "B6.7 CM2350 B136C", "SmnRowId": "1-DTGM-54", "SpCode": "39275", "SpRowId": "1-KWZ-2583", "CertPercentage": null, "TechRowId": "1-LYA-5636" }, { "ServiceModelName": "L9 CM2350 L120C", "SmnRowId": "1-DTGM-1", "SpCode": "39275", "SpRowId": "1-KWZ-2583", "CertPercentage": null, "TechRowId": "1-LYA-5636" }, { "ServiceModelName": "B6.7 CM2350 B136C", "SmnRowId": "1-DTGM-323", "SpCode": "02688", "SpRowId": "1-KX1-34", "CertPercentage": null, "TechRowId": "1-LYH-1758" }, { "ServiceModelName": "L9 CM2350 L120C", "SmnRowId": "1-DTGM-322", "SpCode": "02688", "SpRowId": "1-KX1-34", "CertPercentage": null, "TechRowId": "1-LYH-1758" }, { "ServiceModelName": "ISL9 CM2250", "SmnRowId": "1-NAU-2314", "SpCode": "22347", "SpRowId": "1-KX1-825", "CertPercentage": null, "TechRowId": "1-LYH-1981" }, { "ServiceModelName": "B6.7 CM2350 B136C", "SmnRowId": "1-DTGM-36", "SpCode": "24710", "SpRowId": "1-KX7-752", "CertPercentage": null, "TechRowId": "1-LYH-4307" }, { "ServiceModelName": "L9 CM2350 L120C", "SmnRowId": "1-DTGM-35", "SpCode": "24710", "SpRowId": "1-KX7-752", "CertPercentage": null, "TechRowId": "1-LYH-4307" }, { "ServiceModelName": "ISL9 CM2250", "SmnRowId": "1-D1SH-4", "SpCode": "11042", "SpRowId": "1-KXB-91", "CertPercentage": null, "TechRowId": "1-LYH-6802" }, { "ServiceModelName": "ISL9 CM2250", "SmnRowId": "1-NA6-13", "SpCode": "31869", "SpRowId": "1-KX9-1504", "CertPercentage": null, "TechRowId": "1-MEH-1126" }, { "ServiceModelName": "B6.7 CM2350 B136C", "SmnRowId": "1-DTGM-363", "SpCode": "56202", "SpRowId": "1-KX7-2396", "CertPercentage": null, "TechRowId": "1-MEH-1256" }, { "ServiceModelName": "L9 CM2350 L120C", "SmnRowId": "1-DTGM-354", "SpCode": "56202", "SpRowId": "1-KX7-2396", "CertPercentage": null, "TechRowId": "1-MEH-1256" }, { "ServiceModelName": "B6.7 CM2350 B136C", "SmnRowId": "1-DTGM-396", "SpCode": "56206", "SpRowId": "1-KX7-2397", "CertPercentage": null, "TechRowId": "1-MEH-1257" }, { "ServiceModelName": "L9 CM2350 L120C", "SmnRowId": "1-DTGM-395", "SpCode": "56206", "SpRowId": "1-KX7-2397", "CertPercentage": null, "TechRowId": "1-MEH-1257" }, { "ServiceModelName": "B6.7 CM2350 B136C", "SmnRowId": "1-DTGM-122", "SpCode": "56251", "SpRowId": "1-KX7-2402", "CertPercentage": null, "TechRowId": "1-MEH-1259" }, { "ServiceModelName": "L9 CM2350 L120C", "SmnRowId": "1-DTGM-121", "SpCode": "56251", "SpRowId": "1-KX7-2402", "CertPercentage": null, "TechRowId": "1-MEH-1259" }, { "ServiceModelName": "B6.7 CM2350 B136C", "SmnRowId": "1-DTGM-24", "SpCode": "56258", "SpRowId": "1-KX7-2403", "CertPercentage": null, "TechRowId": "1-MEH-1268" }, { "ServiceModelName": "L9 CM2350 L120C", "SmnRowId": "1-DTGM-23", "SpCode": "56258", "SpRowId": "1-KX7-2403", "CertPercentage": null, "TechRowId": "1-MEH-1268" }, { "ServiceModelName": "B6.7 CM2350 B136C", "SmnRowId": "1-DTGM-112", "SpCode": "56275", "SpRowId": "1-KX3-3134", "CertPercentage": null, "TechRowId": "1-MEH-1269" }, { "ServiceModelName": "L9 CM2350 L120C", "SmnRowId": "1-DTGM-111", "SpCode": "56275", "SpRowId": "1-KX3-3134", "CertPercentage": null, "TechRowId": "1-MEH-1269" }, { "ServiceModelName": "B6.7 CM2350 B136C", "SmnRowId": "1-DTGM-78", "SpCode": "56331", "SpRowId": "1-KX3-3136", "CertPercentage": null, "TechRowId": "1-MEH-1271" }, { "ServiceModelName": "B6.7 CM2350 B136C", "SmnRowId": "1-DTGM-288", "SpCode": "56331", "SpRowId": "1-KX3-3136", "CertPercentage": null, "TechRowId": "1-MEH-1272" }, { "ServiceModelName": "L9 CM2350 L120C", "SmnRowId": "1-DTGM-287", "SpCode": "56331", "SpRowId": "1-KX3-3136", "CertPercentage": null, "TechRowId": "1-MEH-1272" }, { "ServiceModelName": "B6.7 CM2350 B136C", "SmnRowId": "1-DTGM-74", "SpCode": "02074", "SpRowId": "1-KX1-14", "CertPercentage": null, "TechRowId": "1-MEH-1412" }, { "ServiceModelName": "L9 CM2350 L120C", "SmnRowId": "1-DTGM-73", "SpCode": "02074", "SpRowId": "1-KX1-14", "CertPercentage": null, "TechRowId": "1-MEH-1412" }, { "ServiceModelName": "B6.7 CM2350 B136C", "SmnRowId": "1-DTGM-163", "SpCode": "02231", "SpRowId": "1-KX5-13", "CertPercentage": null, "TechRowId": "1-MEH-1429" }, { "ServiceModelName": "B6.7 CM2350 B136C", "SmnRowId": "1-DTGM-179", "SpCode": "02364", "SpRowId": "1-KX1-21", "CertPercentage": null, "TechRowId": "1-MEH-1440" }, { "ServiceModelName": "L9 CM2350 L120C", "SmnRowId": "1-DTGM-178", "SpCode": "02364", "SpRowId": "1-KX1-21", "CertPercentage": null, "TechRowId": "1-MEH-1440" }, { "ServiceModelName": "B6.7 CM2350 B136C", "SmnRowId": "1-DTGM-334", "SpCode": "02369", "SpRowId": "1-KX3-21", "CertPercentage": null, "TechRowId": "1-MEH-1441" }, { "ServiceModelName": "B6.7 CM2350 B136C", "SmnRowId": "1-DTGM-140", "SpCode": "02402", "SpRowId": "1-KX5-15", "CertPercentage": null, "TechRowId": "1-MEH-1455" }, { "ServiceModelName": "L9 CM2350 L120C", "SmnRowId": "1-DTGM-139", "SpCode": "02402", "SpRowId": "1-KX5-15", "CertPercentage": null, "TechRowId": "1-MEH-1455" }, { "ServiceModelName": "B6.7 CM2350 B136C", "SmnRowId": "1-DTGM-417", "SpCode": "02405", "SpRowId": "1-KX9-13", "CertPercentage": null, "TechRowId": "1-MEH-1458" }, { "ServiceModelName": "B6.7 CM2350 B136C", "SmnRowId": "1-DTGM-333", "SpCode": "02670", "SpRowId": "1-KX3-27", "CertPercentage": null, "TechRowId": "1-MEH-1491" }, { "ServiceModelName": "L9 CM2350 L120C", "SmnRowId": "1-DTGM-332", "SpCode": "02670", "SpRowId": "1-KX3-27", "CertPercentage": null, "TechRowId": "1-MEH-1491" }, { "ServiceModelName": "B6.7 CM2350 B136C", "SmnRowId": "1-DTGM-30", "SpCode": "02678", "SpRowId": "1-KX5-19", "CertPercentage": null, "TechRowId": "1-MEH-1501" }, { "ServiceModelName": "L9 CM2350 L120C", "SmnRowId": "1-DTGM-29", "SpCode": "02678", "SpRowId": "1-KX5-19", "CertPercentage": null, "TechRowId": "1-MEH-1501" }, { "ServiceModelName": "B6.7 CM2350 B136C", "SmnRowId": "1-DTGM-66", "SpCode": "02949", "SpRowId": "1-KX9-32", "CertPercentage": null, "TechRowId": "1-MEH-1560" }, { "ServiceModelName": "L9 CM2350 L120C", "SmnRowId": "1-DTGM-65", "SpCode": "02949", "SpRowId": "1-KX9-32", "CertPercentage": null, "TechRowId": "1-MEH-1560" }, { "ServiceModelName": "L9 CM2350 L120C", "SmnRowId": "1-DTGM-61", "SpCode": "02991", "SpRowId": "1-KX7-44", "CertPercentage": null, "TechRowId": "1-MEH-1563" }, { "ServiceModelName": "L9 CM2350 L120C", "SmnRowId": "1-DTGM-70", "SpCode": "03615", "SpRowId": "1-KX7-50", "CertPercentage": null, "TechRowId": "1-MEH-1596" }, { "ServiceModelName": "B6.7 CM2350 B136C", "SmnRowId": "1-DTGM-221", "SpCode": "03735", "SpRowId": "1-KX3-37", "CertPercentage": null, "TechRowId": "1-MEH-1599" }, { "ServiceModelName": "L9 CM2350 L120C", "SmnRowId": "1-DTGM-220", "SpCode": "03735", "SpRowId": "1-KX3-37", "CertPercentage": null, "TechRowId": "1-MEH-1599" }, { "ServiceModelName": "B6.7 CM2350 B136C", "SmnRowId": "1-DTGM-77", "SpCode": "04976", "SpRowId": "1-KXB-30", "CertPercentage": null, "TechRowId": "1-MEH-1653" }, { "ServiceModelName": "L9 CM2350 L120C", "SmnRowId": "1-DTGM-76", "SpCode": "04976", "SpRowId": "1-KXB-30", "CertPercentage": null, "TechRowId": "1-MEH-1653" }, { "ServiceModelName": "ISL9 CM2250", "SmnRowId": "1-NAI-5042", "SpCode": "08522", "SpRowId": "1-KX1-68", "CertPercentage": null, "TechRowId": "1-MEH-1705" }, { "ServiceModelName": "QSX15 CM2350 X105", "SmnRowId": "1-B8GJ-2119", "SpCode": "08522", "SpRowId": "1-KX1-68", "CertPercentage": null, "TechRowId": "1-MEH-1705" }, { "ServiceModelName": "B6.7 CM2350 B136C", "SmnRowId": "1-DTGM-234", "SpCode": "08522", "SpRowId": "1-KX1-68", "CertPercentage": null, "TechRowId": "1-MEH-1706" }, { "ServiceModelName": "B6.7 CM2350 B136C", "SmnRowId": "1-DTGM-217", "SpCode": "02006", "SpRowId": "1-KX7-5", "CertPercentage": null, "TechRowId": "1-MEH-175" }, { "ServiceModelName": "L9 CM2350 L120C", "SmnRowId": "1-DTGM-210", "SpCode": "02006", "SpRowId": "1-KX7-5", "CertPercentage": null, "TechRowId": "1-MEH-175" }, { "ServiceModelName": "B6.7 CM2350 B136C", "SmnRowId": "1-DTGM-259", "SpCode": "02024", "SpRowId": "1-KX7-7", "CertPercentage": null, "TechRowId": "1-MEH-177" }, { "ServiceModelName": "L9 CM2350 L120C", "SmnRowId": "1-DTGM-258", "SpCode": "02024", "SpRowId": "1-KX7-7", "CertPercentage": null, "TechRowId": "1-MEH-177" }, { "ServiceModelName": "B6.7 CM2350 B136C", "SmnRowId": "1-DTGM-20", "SpCode": "13690", "SpRowId": "1-KX9-183", "CertPercentage": null, "TechRowId": "1-MEH-1818" }, { "ServiceModelName": "L9 CM2350 L120C", "SmnRowId": "1-DTGM-16", "SpCode": "13690", "SpRowId": "1-KX9-183", "CertPercentage": null, "TechRowId": "1-MEH-1818" }, { "ServiceModelName": "ISL9 CM2250", "SmnRowId": "1-D1SH-6", "SpCode": "22030", "SpRowId": "1-KXB-402", "CertPercentage": null, "TechRowId": "1-MEH-2064" }, { "ServiceModelName": "L9 CM2350 L120C", "SmnRowId": "1-DTGM-192", "SpCode": "22856", "SpRowId": "1-KX5-724", "CertPercentage": null, "TechRowId": "1-MEH-2095" }, { "ServiceModelName": "B6.7 CM2350 B136C", "SmnRowId": "1-DTGM-351", "SpCode": "02992", "SpRowId": "1-KX3-34", "CertPercentage": null, "TechRowId": "1-MEH-217" }, { "ServiceModelName": "L9 CM2350 L120C", "SmnRowId": "1-DTGM-350", "SpCode": "02992", "SpRowId": "1-KX3-34", "CertPercentage": null, "TechRowId": "1-MEH-217" }, { "ServiceModelName": "B6.7 CM2350 B136C", "SmnRowId": "1-DTGM-137", "SpCode": "32146", "SpRowId": "1-KX7-1469", "CertPercentage": null, "TechRowId": "1-MEH-2308" }, { "ServiceModelName": "L9 CM2350 L120C", "SmnRowId": "1-DTGM-136", "SpCode": "32146", "SpRowId": "1-KX7-1469", "CertPercentage": null, "TechRowId": "1-MEH-2308" }, { "ServiceModelName": "B6.7 CM2350 B136C", "SmnRowId": "1-DTGM-58", "SpCode": "56201", "SpRowId": "1-KX7-2395", "CertPercentage": null, "TechRowId": "1-MEH-2471" }, { "ServiceModelName": "L9 CM2350 L120C", "SmnRowId": "1-DTGM-57", "SpCode": "56201", "SpRowId": "1-KX7-2395", "CertPercentage": null, "TechRowId": "1-MEH-2471" }, { "ServiceModelName": "B6.7 CM2350 B136C", "SmnRowId": "1-DTGM-199", "SpCode": "56203", "SpRowId": "1-KX1-2805", "CertPercentage": null, "TechRowId": "1-MEH-2474" }, { "ServiceModelName": "L9 CM2350 L120C", "SmnRowId": "1-DTGM-198", "SpCode": "56203", "SpRowId": "1-KX1-2805", "CertPercentage": null, "TechRowId": "1-MEH-2474" }, { "ServiceModelName": "B6.7 CM2350 B136C", "SmnRowId": "1-DTGM-108", "SpCode": "56256", "SpRowId": "1-KX5-2575", "CertPercentage": null, "TechRowId": "1-MEH-2491" }, { "ServiceModelName": "L9 CM2350 L120C", "SmnRowId": "1-DTGM-107", "SpCode": "56256", "SpRowId": "1-KX5-2575", "CertPercentage": null, "TechRowId": "1-MEH-2491" }, { "ServiceModelName": "QSK38 CM2150 MCRS", "SmnRowId": "1-N9W-7082", "SpCode": "56273", "SpRowId": "1-KX9-2599", "CertPercentage": null, "TechRowId": "1-MEH-2494" }, { "ServiceModelName": "B6.7 CM2350 B136C", "SmnRowId": "1-DTGM-125", "SpCode": "56321", "SpRowId": "1-KXB-1338", "CertPercentage": null, "TechRowId": "1-MEH-2499" }, { "ServiceModelName": "L9 CM2350 L120C", "SmnRowId": "1-DTGM-124", "SpCode": "56321", "SpRowId": "1-KXB-1338", "CertPercentage": null, "TechRowId": "1-MEH-2499" }, { "ServiceModelName": "B6.7 CM2350 B136C", "SmnRowId": "1-DTGM-374", "SpCode": "02002", "SpRowId": "1-KX7-4", "CertPercentage": null, "TechRowId": "1-MEH-2652" }, { "ServiceModelName": "B6.7 CM2350 B136C", "SmnRowId": "1-DTGM-437", "SpCode": "02012", "SpRowId": "1-KX3-12", "CertPercentage": null, "TechRowId": "1-MEH-2662" }, { "ServiceModelName": "B6.7 CM2350 B136C", "SmnRowId": "1-DTGM-382", "SpCode": "02027", "SpRowId": "1-KX1-10", "CertPercentage": null, "TechRowId": "1-MEH-2673" }, { "ServiceModelName": "L9 CM2350 L120C", "SmnRowId": "1-DTGM-380", "SpCode": "02027", "SpRowId": "1-KX1-10", "CertPercentage": null, "TechRowId": "1-MEH-2673" }, { "ServiceModelName": "B6.7 CM2350 B136C", "SmnRowId": "1-DTGM-49", "SpCode": "02042", "SpRowId": "1-KX5-5", "CertPercentage": null, "TechRowId": "1-MEH-2677" }, { "ServiceModelName": "L9 CM2350 L120C", "SmnRowId": "1-DTGM-48", "SpCode": "02042", "SpRowId": "1-KX5-5", "CertPercentage": null, "TechRowId": "1-MEH-2677" }, { "ServiceModelName": "L9 CM2350 L120C", "SmnRowId": "1-DTGM-223", "SpCode": "02374", "SpRowId": "1-KX7-21", "CertPercentage": null, "TechRowId": "1-MEH-2733" }, { "ServiceModelName": "L9 CM2350 L120C", "SmnRowId": "1-DTGM-379", "SpCode": "02374", "SpRowId": "1-KX7-21", "CertPercentage": null, "TechRowId": "1-MEH-2737" }, { "ServiceModelName": "QSF2.8 CM2880 F114", "SmnRowId": "1-DTGM-253", "SpCode": "02401", "SpRowId": "1-KX1-25", "CertPercentage": null, "TechRowId": "1-MEH-2743" }, { "ServiceModelName": "B6.7 CM2350 B136C", "SmnRowId": "1-DTGM-255", "SpCode": "02405", "SpRowId": "1-KX9-13", "CertPercentage": null, "TechRowId": "1-MEH-2750" }, { "ServiceModelName": "L9 CM2350 L120C", "SmnRowId": "1-DTGM-254", "SpCode": "02405", "SpRowId": "1-KX9-13", "CertPercentage": null, "TechRowId": "1-MEH-2750" }, { "ServiceModelName": "L9 CM2350 L120C", "SmnRowId": "1-DTGM-377", "SpCode": "02652", "SpRowId": "1-KX7-31", "CertPercentage": null, "TechRowId": "1-MEH-2784" }, { "ServiceModelName": "B6.7 CM2350 B136C", "SmnRowId": "1-DTGM-100", "SpCode": "02661", "SpRowId": "1-KX1-31", "CertPercentage": null, "TechRowId": "1-MEH-2791" }, { "ServiceModelName": "L9 CM2350 L120C", "SmnRowId": "1-DTGM-99", "SpCode": "02661", "SpRowId": "1-KX1-31", "CertPercentage": null, "TechRowId": "1-MEH-2791" }, { "ServiceModelName": "B6.7 CM2350 B136C", "SmnRowId": "1-DTGM-286", "SpCode": "02669", "SpRowId": "1-KX9-21", "CertPercentage": null, "TechRowId": "1-MEH-2793" }, { "ServiceModelName": "L9 CM2350 L120C", "SmnRowId": "1-DTGM-285", "SpCode": "02669", "SpRowId": "1-KX9-21", "CertPercentage": null, "TechRowId": "1-MEH-2793" }, { "ServiceModelName": "B6.7 CM2350 B136C", "SmnRowId": "1-DTGM-284", "SpCode": "02672", "SpRowId": "1-KX9-22", "CertPercentage": null, "TechRowId": "1-MEH-2802" }, { "ServiceModelName": "L9 CM2350 L120C", "SmnRowId": "1-DTGM-283", "SpCode": "02672", "SpRowId": "1-KX9-22", "CertPercentage": null, "TechRowId": "1-MEH-2802" }, { "ServiceModelName": "B6.7 CM2350 B136C", "SmnRowId": "1-DTGM-225", "SpCode": "02677", "SpRowId": "1-KX1-33", "CertPercentage": null, "TechRowId": "1-MEH-2804" }, { "ServiceModelName": "L9 CM2350 L120C", "SmnRowId": "1-DTGM-224", "SpCode": "02677", "SpRowId": "1-KX1-33", "CertPercentage": null, "TechRowId": "1-MEH-2804" }, { "ServiceModelName": "B6.7 CM2350 B136C", "SmnRowId": "1-DTGM-34", "SpCode": "02682", "SpRowId": "1-KX5-20", "CertPercentage": null, "TechRowId": "1-MEH-2812" }, { "ServiceModelName": "L9 CM2350 L120C", "SmnRowId": "1-DTGM-33", "SpCode": "02682", "SpRowId": "1-KX5-20", "CertPercentage": null, "TechRowId": "1-MEH-2812" }, { "ServiceModelName": "B6.7 CM2350 B136C", "SmnRowId": "1-DTGM-72", "SpCode": "02837", "SpRowId": "1-KX7-35", "CertPercentage": null, "TechRowId": "1-MEH-2817" }, { "ServiceModelName": "L9 CM2350 L120C", "SmnRowId": "1-DTGM-71", "SpCode": "02837", "SpRowId": "1-KX7-35", "CertPercentage": null, "TechRowId": "1-MEH-2817" }, { "ServiceModelName": "B6.7 CM2350 B136C", "SmnRowId": "1-DTGM-406", "SpCode": "02932", "SpRowId": "1-KXB-17", "CertPercentage": null, "TechRowId": "1-MEH-2862" }, { "ServiceModelName": "L9 CM2350 L120C", "SmnRowId": "1-DTGM-405", "SpCode": "02932", "SpRowId": "1-KXB-17", "CertPercentage": null, "TechRowId": "1-MEH-2862" }, { "ServiceModelName": "B6.7 CM2350 B136C", "SmnRowId": "1-DTGM-135", "SpCode": "02933", "SpRowId": "1-KX1-43", "CertPercentage": null, "TechRowId": "1-MEH-2863" }, { "ServiceModelName": "L9 CM2350 L120C", "SmnRowId": "1-DTGM-134", "SpCode": "02933", "SpRowId": "1-KX1-43", "CertPercentage": null, "TechRowId": "1-MEH-2863" }, { "ServiceModelName": "B6.7 CM2350 B136C", "SmnRowId": "1-DTGM-369", "SpCode": "02992", "SpRowId": "1-KX3-34", "CertPercentage": null, "TechRowId": "1-MEH-2886" }, { "ServiceModelName": "L9 CM2350 L120C", "SmnRowId": "1-DTGM-368", "SpCode": "02992", "SpRowId": "1-KX3-34", "CertPercentage": null, "TechRowId": "1-MEH-2886" }, { "ServiceModelName": "B6.7 CM2350 B136C", "SmnRowId": "1-DTGM-293", "SpCode": "02992", "SpRowId": "1-KX3-34", "CertPercentage": null, "TechRowId": "1-MEH-2887" }, { "ServiceModelName": "L9 CM2350 L120C", "SmnRowId": "1-DTGM-292", "SpCode": "02992", "SpRowId": "1-KX3-34", "CertPercentage": null, "TechRowId": "1-MEH-2887" }, { "ServiceModelName": "B6.7 CM2350 B136C", "SmnRowId": "1-DTGM-91", "SpCode": "02992", "SpRowId": "1-KX3-34", "CertPercentage": null, "TechRowId": "1-MEH-2888" }, { "ServiceModelName": "B6.7 CM2350 B136C", "SmnRowId": "1-DTGM-228", "SpCode": "02992", "SpRowId": "1-KX3-34", "CertPercentage": null, "TechRowId": "1-MEH-2891" }, { "ServiceModelName": "L9 CM2350 L120C", "SmnRowId": "1-DTGM-227", "SpCode": "02992", "SpRowId": "1-KX3-34", "CertPercentage": null, "TechRowId": "1-MEH-2891" }, { "ServiceModelName": "B6.7 CM2350 B136C", "SmnRowId": "1-DTGM-12", "SpCode": "03735", "SpRowId": "1-KX3-37", "CertPercentage": null, "TechRowId": "1-MEH-2931" }, { "ServiceModelName": "B6.7 CM2350 B136C", "SmnRowId": "1-DTGM-308", "SpCode": "03750", "SpRowId": "1-KXB-25", "CertPercentage": null, "TechRowId": "1-MEH-2933" }, { "ServiceModelName": "L9 CM2350 L120C", "SmnRowId": "1-DTGM-307", "SpCode": "03750", "SpRowId": "1-KXB-25", "CertPercentage": null, "TechRowId": "1-MEH-2933" }, { "ServiceModelName": "B6.7 CM2350 B136C", "SmnRowId": "1-DTGM-15", "SpCode": "04405", "SpRowId": "1-KX5-39", "CertPercentage": null, "TechRowId": "1-MEH-2943" }, { "ServiceModelName": "L9 CM2350 L120C", "SmnRowId": "1-DTGM-14", "SpCode": "04405", "SpRowId": "1-KX5-39", "CertPercentage": null, "TechRowId": "1-MEH-2943" }, { "ServiceModelName": "L9 CM2350 L120C", "SmnRowId": "1-DTGM-95", "SpCode": "04897", "SpRowId": "1-KX9-49", "CertPercentage": null, "TechRowId": "1-MEH-2963" }, { "ServiceModelName": "B6.7 CM2350 B136C", "SmnRowId": "1-DTGM-38", "SpCode": "04975", "SpRowId": "1-KX9-51", "CertPercentage": null, "TechRowId": "1-MEH-2985" }, { "ServiceModelName": "L9 CM2350 L120C", "SmnRowId": "1-DTGM-37", "SpCode": "04975", "SpRowId": "1-KX9-51", "CertPercentage": null, "TechRowId": "1-MEH-2985" }, { "ServiceModelName": "B6.7 CM2350 B136C", "SmnRowId": "1-DTGM-146", "SpCode": "08440", "SpRowId": "1-KX9-56", "CertPercentage": null, "TechRowId": "1-MEH-3051" }, { "ServiceModelName": "L9 CM2350 L120C", "SmnRowId": "1-DTGM-145", "SpCode": "08440", "SpRowId": "1-KX9-56", "CertPercentage": null, "TechRowId": "1-MEH-3051" }, { "ServiceModelName": "B6.7 CM2350 B136C", "SmnRowId": "1-DTGM-434", "SpCode": "08440", "SpRowId": "1-KX9-56", "CertPercentage": null, "TechRowId": "1-MEH-3052" }, { "ServiceModelName": "L9 CM2350 L120C", "SmnRowId": "1-DTGM-433", "SpCode": "08440", "SpRowId": "1-KX9-56", "CertPercentage": null, "TechRowId": "1-MEH-3052" }, { "ServiceModelName": "B6.7 CM2350 B136C", "SmnRowId": "1-DTGM-197", "SpCode": "08440", "SpRowId": "1-KX9-56", "CertPercentage": null, "TechRowId": "1-MEH-3053" }, { "ServiceModelName": "L9 CM2350 L120C", "SmnRowId": "1-DTGM-196", "SpCode": "08440", "SpRowId": "1-KX9-56", "CertPercentage": null, "TechRowId": "1-MEH-3053" }, { "ServiceModelName": "B6.7 CM2350 B136C", "SmnRowId": "1-DTGM-28", "SpCode": "13293", "SpRowId": "1-KX1-235", "CertPercentage": null, "TechRowId": "1-MEH-3183" }, { "ServiceModelName": "L9 CM2350 L120C", "SmnRowId": "1-DTGM-27", "SpCode": "13293", "SpRowId": "1-KX1-235", "CertPercentage": null, "TechRowId": "1-MEH-3183" }, { "ServiceModelName": "B6.7 CM2350 B136C", "SmnRowId": "1-DTGM-182", "SpCode": "19721", "SpRowId": "1-KX3-395", "CertPercentage": null, "TechRowId": "1-MEH-3370" }, { "ServiceModelName": "L9 CM2350 L120C", "SmnRowId": "1-DTGM-180", "SpCode": "19721", "SpRowId": "1-KX3-395", "CertPercentage": null, "TechRowId": "1-MEH-3370" }, { "ServiceModelName": "ISL9 CM2250", "SmnRowId": "1-N9U-2478", "SpCode": "24477", "SpRowId": "1-KX9-848", "CertPercentage": null, "TechRowId": "1-MEH-3650" }, { "ServiceModelName": "ISL9 CM2250", "SmnRowId": "1-D1SH-1", "SpCode": "27158", "SpRowId": "1-KX9-1120", "CertPercentage": null, "TechRowId": "1-MEH-3730" }, { "ServiceModelName": "B6.7 CM2350 B136C", "SmnRowId": "1-DTGM-45", "SpCode": "56255", "SpRowId": "1-KX9-2598", "CertPercentage": null, "TechRowId": "1-MEH-4057" }, { "ServiceModelName": "L9 CM2350 L120C", "SmnRowId": "1-DTGM-44", "SpCode": "56255", "SpRowId": "1-KX9-2598", "CertPercentage": null, "TechRowId": "1-MEH-4057" }, { "ServiceModelName": "QSF2.8 CM2880 F114", "SmnRowId": "1-NAW-2719", "SpCode": "56273", "SpRowId": "1-KX9-2599", "CertPercentage": null, "TechRowId": "1-MEH-4067" }, { "ServiceModelName": "B6.7 CM2350 B136C", "SmnRowId": "1-DTGM-424", "SpCode": "56331", "SpRowId": "1-KX3-3136", "CertPercentage": null, "TechRowId": "1-MEH-4075" }, { "ServiceModelName": "ISL9 CM2250", "SmnRowId": "1-N9Y-6560", "SpCode": "56331", "SpRowId": "1-KX3-3136", "CertPercentage": null, "TechRowId": "1-MEH-4075" }, { "ServiceModelName": "QSF2.8 CM2880 F114", "SmnRowId": "1-DTGM-152", "SpCode": "56331", "SpRowId": "1-KX3-3136", "CertPercentage": null, "TechRowId": "1-MEH-4075" }, { "ServiceModelName": "QSX15 CM2350 X105", "SmnRowId": "1-442D-373", "SpCode": "56331", "SpRowId": "1-KX3-3136", "CertPercentage": null, "TechRowId": "1-MEH-4075" }, { "ServiceModelName": "B6.7 CM2350 B136C", "SmnRowId": "1-DTGM-165", "SpCode": "56333", "SpRowId": "1-KX1-2809", "CertPercentage": null, "TechRowId": "1-MEH-4078" }, { "ServiceModelName": "L9 CM2350 L120C", "SmnRowId": "1-DTGM-164", "SpCode": "56333", "SpRowId": "1-KX1-2809", "CertPercentage": null, "TechRowId": "1-MEH-4078" }, { "ServiceModelName": "B6.7 CM2350 B136C", "SmnRowId": "1-DTGM-103", "SpCode": "02021", "SpRowId": "1-KX7-6", "CertPercentage": null, "TechRowId": "1-MEH-4307" }, { "ServiceModelName": "L9 CM2350 L120C", "SmnRowId": "1-DTGM-143", "SpCode": "02024", "SpRowId": "1-KX7-7", "CertPercentage": null, "TechRowId": "1-MEH-4310" }, { "ServiceModelName": "B6.7 CM2350 B136C", "SmnRowId": "1-DTGM-162", "SpCode": "02025", "SpRowId": "1-KX9-7", "CertPercentage": null, "TechRowId": "1-MEH-4312" }, { "ServiceModelName": "B6.7 CM2350 B136C", "SmnRowId": "1-DTGM-40", "SpCode": "02027", "SpRowId": "1-KX1-10", "CertPercentage": null, "TechRowId": "1-MEH-4317" }, { "ServiceModelName": "L9 CM2350 L120C", "SmnRowId": "1-DTGM-39", "SpCode": "02027", "SpRowId": "1-KX1-10", "CertPercentage": null, "TechRowId": "1-MEH-4317" }, { "ServiceModelName": "L9 CM2350 L120C", "SmnRowId": "1-DTGM-131", "SpCode": "02369", "SpRowId": "1-KX3-21", "CertPercentage": null, "TechRowId": "1-MEH-4359" }, { "ServiceModelName": "B6.7 CM2350 B136C", "SmnRowId": "1-DTGM-358", "SpCode": "02401", "SpRowId": "1-KX1-25", "CertPercentage": null, "TechRowId": "1-MEH-4370" }, { "ServiceModelName": "L9 CM2350 L120C", "SmnRowId": "1-DTGM-357", "SpCode": "02401", "SpRowId": "1-KX1-25", "CertPercentage": null, "TechRowId": "1-MEH-4370" }, { "ServiceModelName": "ISL9 CM2250", "SmnRowId": "1-D1SH-13", "SpCode": "02402", "SpRowId": "1-KX5-15", "CertPercentage": null, "TechRowId": "1-MEH-4374" }, { "ServiceModelName": "B6.7 CM2350 B136C", "SmnRowId": "1-DTGM-195", "SpCode": "02931", "SpRowId": "1-KWZ-13", "CertPercentage": null, "TechRowId": "1-MEH-4475" }, { "ServiceModelName": "B6.7 CM2350 B136C", "SmnRowId": "1-DTGM-360", "SpCode": "02992", "SpRowId": "1-KX3-34", "CertPercentage": null, "TechRowId": "1-MEH-4496" }, { "ServiceModelName": "L9 CM2350 L120C", "SmnRowId": "1-DTGM-359", "SpCode": "02992", "SpRowId": "1-KX3-34", "CertPercentage": null, "TechRowId": "1-MEH-4496" }, { "ServiceModelName": "B6.7 CM2350 B136C", "SmnRowId": "1-DTGM-277", "SpCode": "02992", "SpRowId": "1-KX3-34", "CertPercentage": null, "TechRowId": "1-MEH-4501" }, { "ServiceModelName": "L9 CM2350 L120C", "SmnRowId": "1-DTGM-276", "SpCode": "02992", "SpRowId": "1-KX3-34", "CertPercentage": null, "TechRowId": "1-MEH-4501" }, { "ServiceModelName": "B6.7 CM2350 B136C", "SmnRowId": "1-DTGM-226", "SpCode": "02997", "SpRowId": "1-KXB-18", "CertPercentage": null, "TechRowId": "1-MEH-4506" }, { "ServiceModelName": "B6.7 CM2350 B136C", "SmnRowId": "1-DTGM-233", "SpCode": "03525", "SpRowId": "1-KX5-34", "CertPercentage": null, "TechRowId": "1-MEH-4529" }, { "ServiceModelName": "L9 CM2350 L120C", "SmnRowId": "1-DTGM-232", "SpCode": "03525", "SpRowId": "1-KX5-34", "CertPercentage": null, "TechRowId": "1-MEH-4529" }, { "ServiceModelName": "ISL9 CM2250", "SmnRowId": "1-D1SH-7", "SpCode": "03750", "SpRowId": "1-KXB-25", "CertPercentage": null, "TechRowId": "1-MEH-4552" }, { "ServiceModelName": "L9 CM2350 L120C", "SmnRowId": "1-DTGM-378", "SpCode": "03750", "SpRowId": "1-KXB-25", "CertPercentage": null, "TechRowId": "1-MEH-4552" }, { "ServiceModelName": "QSF2.8 CM2880 F114", "SmnRowId": "1-DTGM-56", "SpCode": "03750", "SpRowId": "1-KXB-25", "CertPercentage": null, "TechRowId": "1-MEH-4552" }, { "ServiceModelName": "QSF2.8 CM2880 F114", "SmnRowId": "1-DTGM-46", "SpCode": "04405", "SpRowId": "1-KX5-39", "CertPercentage": null, "TechRowId": "1-MEH-4563" }, { "ServiceModelName": "L9 CM2350 L120C", "SmnRowId": "1-DTGM-324", "SpCode": "04897", "SpRowId": "1-KX9-49", "CertPercentage": null, "TechRowId": "1-MEH-4582" }, { "ServiceModelName": "B6.7 CM2350 B136C", "SmnRowId": "1-DTGM-428", "SpCode": "04976", "SpRowId": "1-KXB-30", "CertPercentage": null, "TechRowId": "1-MEH-4599" }, { "ServiceModelName": "L9 CM2350 L120C", "SmnRowId": "1-DTGM-427", "SpCode": "04976", "SpRowId": "1-KXB-30", "CertPercentage": null, "TechRowId": "1-MEH-4599" }, { "ServiceModelName": "B6.7 CM2350 B136C", "SmnRowId": "1-DTGM-412", "SpCode": "05085", "SpRowId": "1-KX3-54", "CertPercentage": null, "TechRowId": "1-MEH-4609" }, { "ServiceModelName": "L9 CM2350 L120C", "SmnRowId": "1-DTGM-402", "SpCode": "05085", "SpRowId": "1-KX3-54", "CertPercentage": null, "TechRowId": "1-MEH-4609" }, { "ServiceModelName": "B6.7 CM2350 B136C", "SmnRowId": "1-DTGM-170", "SpCode": "08486", "SpRowId": "1-KX5-55", "CertPercentage": null, "TechRowId": "1-MEH-4647" }, { "ServiceModelName": "L9 CM2350 L120C", "SmnRowId": "1-DTGM-169", "SpCode": "08486", "SpRowId": "1-KX5-55", "CertPercentage": null, "TechRowId": "1-MEH-4647" }, { "ServiceModelName": "B6.7 CM2350 B136C", "SmnRowId": "1-DTGM-64", "SpCode": "08522", "SpRowId": "1-KX1-68", "CertPercentage": null, "TechRowId": "1-MEH-4648" }, { "ServiceModelName": "ISL9 CM2250", "SmnRowId": "1-N9M-5428", "SpCode": "87073", "SpRowId": "1-4H8U-3914", "CertPercentage": null, "TechRowId": "1-MEH-474" }, { "ServiceModelName": "ISL9 CM2250", "SmnRowId": "1-N9M-5428", "SpCode": "38548", "SpRowId": "1-KX5-2178", "CertPercentage": null, "TechRowId": "1-MEH-474" }, { "ServiceModelName": "ISL9 CM2250", "SmnRowId": "1-D1SH-8", "SpCode": "21699", "SpRowId": "1-KXB-378", "CertPercentage": null, "TechRowId": "1-MEH-5012" }, { "ServiceModelName": "ISL9 CM2250", "SmnRowId": "1-NAW-3389", "SpCode": "24667", "SpRowId": "1-KX1-1397", "CertPercentage": null, "TechRowId": "1-MEH-5180" }, { "ServiceModelName": "B6.7 CM2350 B136C", "SmnRowId": "1-DTGM-319", "SpCode": "56201", "SpRowId": "1-KX7-2395", "CertPercentage": null, "TechRowId": "1-MEH-5511" }, { "ServiceModelName": "L9 CM2350 L120C", "SmnRowId": "1-DTGM-318", "SpCode": "56201", "SpRowId": "1-KX7-2395", "CertPercentage": null, "TechRowId": "1-MEH-5511" }, { "ServiceModelName": "B6.7 CM2350 B136C", "SmnRowId": "1-DTGM-80", "SpCode": "56275", "SpRowId": "1-KX3-3134", "CertPercentage": null, "TechRowId": "1-MEH-5534" }, { "ServiceModelName": "L9 CM2350 L120C", "SmnRowId": "1-DTGM-79", "SpCode": "56275", "SpRowId": "1-KX3-3134", "CertPercentage": null, "TechRowId": "1-MEH-5534" }, { "ServiceModelName": "B6.7 CM2350 B136C", "SmnRowId": "1-DTGM-410", "SpCode": "02044", "SpRowId": "1-KX7-12", "CertPercentage": null, "TechRowId": "1-MEH-554" }, { "ServiceModelName": "L9 CM2350 L120C", "SmnRowId": "1-DTGM-409", "SpCode": "02044", "SpRowId": "1-KX7-12", "CertPercentage": null, "TechRowId": "1-MEH-554" }, { "ServiceModelName": "B6.7 CM2350 B136C", "SmnRowId": "1-DTGM-219", "SpCode": "56352", "SpRowId": "1-KX9-2605", "CertPercentage": null, "TechRowId": "1-MEH-5549" }, { "ServiceModelName": "ISL9 CM2250", "SmnRowId": "1-NAI-5003", "SpCode": "56352", "SpRowId": "1-KX9-2605", "CertPercentage": null, "TechRowId": "1-MEH-5549" }, { "ServiceModelName": "L9 CM2350 L120C", "SmnRowId": "1-DTGM-218", "SpCode": "56352", "SpRowId": "1-KX9-2605", "CertPercentage": null, "TechRowId": "1-MEH-5549" }, { "ServiceModelName": "QSF2.8 CM2880 F114", "SmnRowId": "1-DTGM-89", "SpCode": "56352", "SpRowId": "1-KX9-2605", "CertPercentage": null, "TechRowId": "1-MEH-5549" }, { "ServiceModelName": "QSK38 CM2150 MCRS", "SmnRowId": "1-DGX5-1", "SpCode": "56352", "SpRowId": "1-KX9-2605", "CertPercentage": null, "TechRowId": "1-MEH-5549" }, { "ServiceModelName": "QSX15 CM2350 X105", "SmnRowId": "1-4ZQV-70", "SpCode": "56352", "SpRowId": "1-KX9-2605", "CertPercentage": null, "TechRowId": "1-MEH-5549" }, { "ServiceModelName": "B6.7 CM2350 B136C", "SmnRowId": "1-DTGM-262", "SpCode": "02371", "SpRowId": "1-KX9-11", "CertPercentage": null, "TechRowId": "1-MEH-56" }, { "ServiceModelName": "B6.7 CM2350 B136C", "SmnRowId": "1-DTGM-271", "SpCode": "02074", "SpRowId": "1-KX1-14", "CertPercentage": null, "TechRowId": "1-MEH-563" }, { "ServiceModelName": "L9 CM2350 L120C", "SmnRowId": "1-DTGM-270", "SpCode": "02074", "SpRowId": "1-KX1-14", "CertPercentage": null, "TechRowId": "1-MEH-563" }, { "ServiceModelName": "QSF2.8 CM2880 F114", "SmnRowId": "1-DTGM-7", "SpCode": "02074", "SpRowId": "1-KX1-14", "CertPercentage": null, "TechRowId": "1-MEH-563" }, { "ServiceModelName": "QSG12/X12 CM2350 G110", "SmnRowId": "1-NA0-7901", "SpCode": "02074", "SpRowId": "1-KX1-14", "CertPercentage": null, "TechRowId": "1-MEH-563" }, { "ServiceModelName": "QSX15 CM2350 X105", "SmnRowId": "1-442F-263", "SpCode": "02074", "SpRowId": "1-KX1-14", "CertPercentage": null, "TechRowId": "1-MEH-563" }, { "ServiceModelName": "B6.7 CM2350 B136C", "SmnRowId": "1-DTGM-413", "SpCode": "02076", "SpRowId": "1-KX3-14", "CertPercentage": null, "TechRowId": "1-MEH-564" }, { "ServiceModelName": "L9 CM2350 L120C", "SmnRowId": "1-DTGM-411", "SpCode": "02076", "SpRowId": "1-KX3-14", "CertPercentage": null, "TechRowId": "1-MEH-564" }, { "ServiceModelName": "L9 CM2350 L120C", "SmnRowId": "1-DTGM-425", "SpCode": "02331", "SpRowId": "1-KX5-14", "CertPercentage": null, "TechRowId": "1-MEH-573" }, { "ServiceModelName": "B6.7 CM2350 B136C", "SmnRowId": "1-DTGM-3", "SpCode": "02080", "SpRowId": "1-KX5-10", "CertPercentage": null, "TechRowId": "1-MEH-5784" }, { "ServiceModelName": "L9 CM2350 L120C", "SmnRowId": "1-DTGM-2", "SpCode": "02080", "SpRowId": "1-KX5-10", "CertPercentage": null, "TechRowId": "1-MEH-5784" }, { "ServiceModelName": "B6.7 CM2350 B136C", "SmnRowId": "1-DTGM-211", "SpCode": "02170", "SpRowId": "1-KX3-16", "CertPercentage": null, "TechRowId": "1-MEH-5789" }, { "ServiceModelName": "L9 CM2350 L120C", "SmnRowId": "1-DTGM-209", "SpCode": "02170", "SpRowId": "1-KX3-16", "CertPercentage": null, "TechRowId": "1-MEH-5789" }, { "ServiceModelName": "L9 CM2350 L120C", "SmnRowId": "1-DTGM-190", "SpCode": "02363", "SpRowId": "1-KX7-19", "CertPercentage": null, "TechRowId": "1-MEH-5808" }, { "ServiceModelName": "L9 CM2350 L120C", "SmnRowId": "1-DTGM-43", "SpCode": "02374", "SpRowId": "1-KX7-21", "CertPercentage": null, "TechRowId": "1-MEH-5816" }, { "ServiceModelName": "B6.7 CM2350 B136C", "SmnRowId": "1-DTGM-92", "SpCode": "02374", "SpRowId": "1-KX7-21", "CertPercentage": null, "TechRowId": "1-MEH-5817" }, { "ServiceModelName": "B6.7 CM2350 B136C", "SmnRowId": "1-DTGM-201", "SpCode": "02402", "SpRowId": "1-KX5-15", "CertPercentage": null, "TechRowId": "1-MEH-5821" }, { "ServiceModelName": "L9 CM2350 L120C", "SmnRowId": "1-DTGM-200", "SpCode": "02402", "SpRowId": "1-KX5-15", "CertPercentage": null, "TechRowId": "1-MEH-5821" }, { "ServiceModelName": "B6.7 CM2350 B136C", "SmnRowId": "1-DTGM-371", "SpCode": "02402", "SpRowId": "1-KX5-15", "CertPercentage": null, "TechRowId": "1-MEH-5822" }, { "ServiceModelName": "L9 CM2350 L120C", "SmnRowId": "1-DTGM-370", "SpCode": "02402", "SpRowId": "1-KX5-15", "CertPercentage": null, "TechRowId": "1-MEH-5822" }, { "ServiceModelName": "B6.7 CM2350 B136C", "SmnRowId": "1-DTGM-299", "SpCode": "02402", "SpRowId": "1-KX5-15", "CertPercentage": null, "TechRowId": "1-MEH-5824" }, { "ServiceModelName": "L9 CM2350 L120C", "SmnRowId": "1-DTGM-298", "SpCode": "02402", "SpRowId": "1-KX5-15", "CertPercentage": null, "TechRowId": "1-MEH-5824" }, { "ServiceModelName": "B6.7 CM2350 B136C", "SmnRowId": "1-DTGM-176", "SpCode": "02676", "SpRowId": "1-KX3-30", "CertPercentage": null, "TechRowId": "1-MEH-5866" }, { "ServiceModelName": "L9 CM2350 L120C", "SmnRowId": "1-DTGM-175", "SpCode": "02676", "SpRowId": "1-KX3-30", "CertPercentage": null, "TechRowId": "1-MEH-5866" }, { "ServiceModelName": "B6.7 CM2350 B136C", "SmnRowId": "1-DTGM-155", "SpCode": "02943", "SpRowId": "1-KX5-30", "CertPercentage": null, "TechRowId": "1-MEH-5906" }, { "ServiceModelName": "L9 CM2350 L120C", "SmnRowId": "1-DTGM-153", "SpCode": "02943", "SpRowId": "1-KX5-30", "CertPercentage": null, "TechRowId": "1-MEH-5906" }, { "ServiceModelName": "B6.7 CM2350 B136C", "SmnRowId": "1-DTGM-362", "SpCode": "03050", "SpRowId": "1-KX9-33", "CertPercentage": null, "TechRowId": "1-MEH-5926" }, { "ServiceModelName": "L9 CM2350 L120C", "SmnRowId": "1-DTGM-361", "SpCode": "03050", "SpRowId": "1-KX9-33", "CertPercentage": null, "TechRowId": "1-MEH-5926" }, { "ServiceModelName": "B6.7 CM2350 B136C", "SmnRowId": "1-DTGM-290", "SpCode": "03050", "SpRowId": "1-KX9-33", "CertPercentage": null, "TechRowId": "1-MEH-5927" }, { "ServiceModelName": "L9 CM2350 L120C", "SmnRowId": "1-DTGM-289", "SpCode": "03050", "SpRowId": "1-KX9-33", "CertPercentage": null, "TechRowId": "1-MEH-5927" }, { "ServiceModelName": "L9 CM2350 L120C", "SmnRowId": "1-DTGM-189", "SpCode": "02392", "SpRowId": "1-KX9-12", "CertPercentage": null, "TechRowId": "1-MEH-596" }, { "ServiceModelName": "QSF2.8 CM2880 F114", "SmnRowId": "1-DTGM-229", "SpCode": "02392", "SpRowId": "1-KX9-12", "CertPercentage": null, "TechRowId": "1-MEH-596" }, { "ServiceModelName": "B6.7 CM2350 B136C", "SmnRowId": "1-DTGM-149", "SpCode": "03750", "SpRowId": "1-KXB-25", "CertPercentage": null, "TechRowId": "1-MEH-5965" }, { "ServiceModelName": "L9 CM2350 L120C", "SmnRowId": "1-DTGM-148", "SpCode": "03750", "SpRowId": "1-KXB-25", "CertPercentage": null, "TechRowId": "1-MEH-5965" }, { "ServiceModelName": "QSF2.8 CM2880 F114", "SmnRowId": "1-DTGM-191", "SpCode": "04405", "SpRowId": "1-KX5-39", "CertPercentage": null, "TechRowId": "1-MEH-5974" }, { "ServiceModelName": "QSF2.8 CM2880 F114", "SmnRowId": "1-DTGM-52", "SpCode": "04897", "SpRowId": "1-KX9-49", "CertPercentage": null, "TechRowId": "1-MEH-5982" }, { "ServiceModelName": "B6.7 CM2350 B136C", "SmnRowId": "1-DTGM-9", "SpCode": "04977", "SpRowId": "1-KX9-52", "CertPercentage": null, "TechRowId": "1-MEH-6000" }, { "ServiceModelName": "L9 CM2350 L120C", "SmnRowId": "1-DTGM-8", "SpCode": "04977", "SpRowId": "1-KX9-52", "CertPercentage": null, "TechRowId": "1-MEH-6000" }, { "ServiceModelName": "B6.7 CM2350 B136C", "SmnRowId": "1-DTGM-331", "SpCode": "04979", "SpRowId": "1-KX1-55", "CertPercentage": null, "TechRowId": "1-MEH-6004" }, { "ServiceModelName": "B6.7 CM2350 B136C", "SmnRowId": "1-DTGM-22", "SpCode": "02411", "SpRowId": "1-KX3-24", "CertPercentage": null, "TechRowId": "1-MEH-602" }, { "ServiceModelName": "L9 CM2350 L120C", "SmnRowId": "1-DTGM-21", "SpCode": "02411", "SpRowId": "1-KX3-24", "CertPercentage": null, "TechRowId": "1-MEH-602" }, { "ServiceModelName": "QSF2.8 CM2880 F114", "SmnRowId": "1-DTGM-84", "SpCode": "02416", "SpRowId": "1-KX1-26", "CertPercentage": null, "TechRowId": "1-MEH-603" }, { "ServiceModelName": "B6.7 CM2350 B136C", "SmnRowId": "1-DTGM-389", "SpCode": "16965", "SpRowId": "1-KX9-274", "CertPercentage": null, "TechRowId": "1-MEH-6189" }, { "ServiceModelName": "L9 CM2350 L120C", "SmnRowId": "1-DTGM-388", "SpCode": "16965", "SpRowId": "1-KX9-274", "CertPercentage": null, "TechRowId": "1-MEH-6189" }, { "ServiceModelName": "L9 CM2350 L120C", "SmnRowId": "1-DTGM-96", "SpCode": "02944", "SpRowId": "1-KX5-31", "CertPercentage": null, "TechRowId": "1-MEH-649" }, { "ServiceModelName": "B6.7 CM2350 B136C", "SmnRowId": "1-DTGM-172", "SpCode": "27855", "SpRowId": "1-KX5-1339", "CertPercentage": null, "TechRowId": "1-MEH-6543" }, { "ServiceModelName": "L9 CM2350 L120C", "SmnRowId": "1-DTGM-168", "SpCode": "27855", "SpRowId": "1-KX5-1339", "CertPercentage": null, "TechRowId": "1-MEH-6543" }, { "ServiceModelName": "B6.7 CM2350 B136C", "SmnRowId": "1-DTGM-344", "SpCode": "03611", "SpRowId": "1-KX7-49", "CertPercentage": null, "TechRowId": "1-MEH-669" }, { "ServiceModelName": "L9 CM2350 L120C", "SmnRowId": "1-DTGM-343", "SpCode": "03611", "SpRowId": "1-KX7-49", "CertPercentage": null, "TechRowId": "1-MEH-669" }, { "ServiceModelName": "QSK38 CM2150 MCRS", "SmnRowId": "1-NA4-7011", "SpCode": "40581", "SpRowId": "1-KX1-2793", "CertPercentage": null, "TechRowId": "1-MEH-6725" }, { "ServiceModelName": "B6.7 CM2350 B136C", "SmnRowId": "1-DTGM-116", "SpCode": "03735", "SpRowId": "1-KX3-37", "CertPercentage": null, "TechRowId": "1-MEH-674" }, { "ServiceModelName": "L9 CM2350 L120C", "SmnRowId": "1-DTGM-115", "SpCode": "03735", "SpRowId": "1-KX3-37", "CertPercentage": null, "TechRowId": "1-MEH-674" }, { "ServiceModelName": "B6.7 CM2350 B136C", "SmnRowId": "1-DTGM-133", "SpCode": "56202", "SpRowId": "1-KX7-2396", "CertPercentage": null, "TechRowId": "1-MEH-6748" }, { "ServiceModelName": "L9 CM2350 L120C", "SmnRowId": "1-DTGM-132", "SpCode": "56202", "SpRowId": "1-KX7-2396", "CertPercentage": null, "TechRowId": "1-MEH-6748" }, { "ServiceModelName": "B6.7 CM2350 B136C", "SmnRowId": "1-DTGM-257", "SpCode": "56206", "SpRowId": "1-KX7-2397", "CertPercentage": null, "TechRowId": "1-MEH-6750" }, { "ServiceModelName": "L9 CM2350 L120C", "SmnRowId": "1-DTGM-256", "SpCode": "56206", "SpRowId": "1-KX7-2397", "CertPercentage": null, "TechRowId": "1-MEH-6750" }, { "ServiceModelName": "B6.7 CM2350 B136C", "SmnRowId": "1-DTGM-346", "SpCode": "56253", "SpRowId": "1-KX9-2596", "CertPercentage": null, "TechRowId": "1-MEH-6757" }, { "ServiceModelName": "ISL9 CM2250", "SmnRowId": "1-442R-381", "SpCode": "56253", "SpRowId": "1-KX9-2596", "CertPercentage": null, "TechRowId": "1-MEH-6757" }, { "ServiceModelName": "L9 CM2350 L120C", "SmnRowId": "1-DTGM-345", "SpCode": "56253", "SpRowId": "1-KX9-2596", "CertPercentage": null, "TechRowId": "1-MEH-6757" }, { "ServiceModelName": "QSX15 CM2350 X105", "SmnRowId": "1-442R-392", "SpCode": "56253", "SpRowId": "1-KX9-2596", "CertPercentage": null, "TechRowId": "1-MEH-6757" }, { "ServiceModelName": "B6.7 CM2350 B136C", "SmnRowId": "1-DTGM-127", "SpCode": "56254", "SpRowId": "1-KX9-2597", "CertPercentage": null, "TechRowId": "1-MEH-6759" }, { "ServiceModelName": "L9 CM2350 L120C", "SmnRowId": "1-DTGM-126", "SpCode": "56254", "SpRowId": "1-KX9-2597", "CertPercentage": null, "TechRowId": "1-MEH-6759" }, { "ServiceModelName": "B6.7 CM2350 B136C", "SmnRowId": "1-DTGM-63", "SpCode": "56256", "SpRowId": "1-KX5-2575", "CertPercentage": null, "TechRowId": "1-MEH-6764" }, { "ServiceModelName": "L9 CM2350 L120C", "SmnRowId": "1-DTGM-62", "SpCode": "56256", "SpRowId": "1-KX5-2575", "CertPercentage": null, "TechRowId": "1-MEH-6764" }, { "ServiceModelName": "ISL9 CM2250", "SmnRowId": "1-D1SH-9", "SpCode": "56275", "SpRowId": "1-KX3-3134", "CertPercentage": null, "TechRowId": "1-MEH-6774" }, { "ServiceModelName": "B6.7 CM2350 B136C", "SmnRowId": "1-DTGM-231", "SpCode": "56332", "SpRowId": "1-KX9-2602", "CertPercentage": null, "TechRowId": "1-MEH-6784" }, { "ServiceModelName": "L9 CM2350 L120C", "SmnRowId": "1-DTGM-230", "SpCode": "56332", "SpRowId": "1-KX9-2602", "CertPercentage": null, "TechRowId": "1-MEH-6784" }, { "ServiceModelName": "B6.7 CM2350 B136C", "SmnRowId": "1-DTGM-94", "SpCode": "56350", "SpRowId": "1-KX9-2604", "CertPercentage": null, "TechRowId": "1-MEH-6789" }, { "ServiceModelName": "L9 CM2350 L120C", "SmnRowId": "1-DTGM-93", "SpCode": "56350", "SpRowId": "1-KX9-2604", "CertPercentage": null, "TechRowId": "1-MEH-6789" }, { "ServiceModelName": "B6.7 CM2350 B136C", "SmnRowId": "1-DTGM-32", "SpCode": "74663", "SpRowId": "1-KX1-2839", "CertPercentage": null, "TechRowId": "1-MEH-6841" }, { "ServiceModelName": "L9 CM2350 L120C", "SmnRowId": "1-DTGM-31", "SpCode": "74663", "SpRowId": "1-KX1-2839", "CertPercentage": null, "TechRowId": "1-MEH-6841" }, { "ServiceModelName": "QSF2.8 CM2880 F114", "SmnRowId": "1-DTGM-90", "SpCode": "04405", "SpRowId": "1-KX5-39", "CertPercentage": null, "TechRowId": "1-MEH-69" }, { "ServiceModelName": "B6.7 CM2350 B136C", "SmnRowId": "1-DTGM-98", "SpCode": "04897", "SpRowId": "1-KX9-49", "CertPercentage": null, "TechRowId": "1-MEH-697" }, { "ServiceModelName": "L9 CM2350 L120C", "SmnRowId": "1-DTGM-97", "SpCode": "04897", "SpRowId": "1-KX9-49", "CertPercentage": null, "TechRowId": "1-MEH-697" }, { "ServiceModelName": "QSX15 CM2350 X105", "SmnRowId": "1-CWNC-9", "SpCode": "02002", "SpRowId": "1-KX7-4", "CertPercentage": null, "TechRowId": "1-MEH-6974" }, { "ServiceModelName": "B6.7 CM2350 B136C", "SmnRowId": "1-DTGM-430", "SpCode": "02051", "SpRowId": "1-KX5-6", "CertPercentage": null, "TechRowId": "1-MEH-6985" }, { "ServiceModelName": "L9 CM2350 L120C", "SmnRowId": "1-DTGM-429", "SpCode": "02051", "SpRowId": "1-KX5-6", "CertPercentage": null, "TechRowId": "1-MEH-6985" }, { "ServiceModelName": "B6.7 CM2350 B136C", "SmnRowId": "1-DTGM-243", "SpCode": "02065", "SpRowId": "1-KXB-6", "CertPercentage": null, "TechRowId": "1-MEH-6987" }, { "ServiceModelName": "L9 CM2350 L120C", "SmnRowId": "1-DTGM-242", "SpCode": "02065", "SpRowId": "1-KXB-6", "CertPercentage": null, "TechRowId": "1-MEH-6987" }, { "ServiceModelName": "B6.7 CM2350 B136C", "SmnRowId": "1-DTGM-161", "SpCode": "02935", "SpRowId": "1-KX9-30", "CertPercentage": null, "TechRowId": "1-MEH-7063" }, { "ServiceModelName": "L9 CM2350 L120C", "SmnRowId": "1-DTGM-160", "SpCode": "02935", "SpRowId": "1-KX9-30", "CertPercentage": null, "TechRowId": "1-MEH-7063" }, { "ServiceModelName": "QSG12/X12 CM2350 G110", "SmnRowId": "1-B8GJ-2076", "SpCode": "02991", "SpRowId": "1-KX7-44", "CertPercentage": null, "TechRowId": "1-MEH-7074" }, { "ServiceModelName": "B6.7 CM2350 B136C", "SmnRowId": "1-DTGM-42", "SpCode": "02991", "SpRowId": "1-KX7-44", "CertPercentage": null, "TechRowId": "1-MEH-7075" }, { "ServiceModelName": "L9 CM2350 L120C", "SmnRowId": "1-DTGM-41", "SpCode": "02991", "SpRowId": "1-KX7-44", "CertPercentage": null, "TechRowId": "1-MEH-7075" }, { "ServiceModelName": "B6.7 CM2350 B136C", "SmnRowId": "1-DTGM-118", "SpCode": "02991", "SpRowId": "1-KX7-44", "CertPercentage": null, "TechRowId": "1-MEH-7076" }, { "ServiceModelName": "L9 CM2350 L120C", "SmnRowId": "1-DTGM-113", "SpCode": "02991", "SpRowId": "1-KX7-44", "CertPercentage": null, "TechRowId": "1-MEH-7076" }, { "ServiceModelName": "B6.7 CM2350 B136C", "SmnRowId": "1-DTGM-206", "SpCode": "02991", "SpRowId": "1-KX7-44", "CertPercentage": null, "TechRowId": "1-MEH-7079" }, { "ServiceModelName": "L9 CM2350 L120C", "SmnRowId": "1-DTGM-10", "SpCode": "04975", "SpRowId": "1-KX9-51", "CertPercentage": null, "TechRowId": "1-MEH-711" }, { "ServiceModelName": "B6.7 CM2350 B136C", "SmnRowId": "1-DTGM-205", "SpCode": "04970", "SpRowId": "1-KX1-54", "CertPercentage": null, "TechRowId": "1-MEH-7128" }, { "ServiceModelName": "L9 CM2350 L120C", "SmnRowId": "1-DTGM-204", "SpCode": "04970", "SpRowId": "1-KX1-54", "CertPercentage": null, "TechRowId": "1-MEH-7128" }, { "ServiceModelName": "B6.7 CM2350 B136C", "SmnRowId": "1-DTGM-142", "SpCode": "05085", "SpRowId": "1-KX3-54", "CertPercentage": null, "TechRowId": "1-MEH-7138" }, { "ServiceModelName": "B6.7 CM2350 B136C", "SmnRowId": "1-DTGM-367", "SpCode": "13293", "SpRowId": "1-KX1-235", "CertPercentage": null, "TechRowId": "1-MEH-7215" }, { "ServiceModelName": "L9 CM2350 L120C", "SmnRowId": "1-DTGM-366", "SpCode": "13293", "SpRowId": "1-KX1-235", "CertPercentage": null, "TechRowId": "1-MEH-7215" }, { "ServiceModelName": "B6.7 CM2350 B136C", "SmnRowId": "1-DTGM-174", "SpCode": "19180", "SpRowId": "1-KX1-477", "CertPercentage": null, "TechRowId": "1-MEH-7289" }, { "ServiceModelName": "L9 CM2350 L120C", "SmnRowId": "1-DTGM-173", "SpCode": "19180", "SpRowId": "1-KX1-477", "CertPercentage": null, "TechRowId": "1-MEH-7289" }, { "ServiceModelName": "B6.7 CM2350 B136C", "SmnRowId": "1-DTGM-55", "SpCode": "19180", "SpRowId": "1-KX1-477", "CertPercentage": null, "TechRowId": "1-MEH-7290" }, { "ServiceModelName": "L9 CM2350 L120C", "SmnRowId": "1-DTGM-53", "SpCode": "19180", "SpRowId": "1-KX1-477", "CertPercentage": null, "TechRowId": "1-MEH-7290" }, { "ServiceModelName": "ISL9 CM2250", "SmnRowId": "1-NAE-5237", "SpCode": "23049", "SpRowId": "1-KX5-740", "CertPercentage": null, "TechRowId": "1-MEH-7420" }, { "ServiceModelName": "B6.7 CM2350 B136C", "SmnRowId": "1-DTGM-247", "SpCode": "08486", "SpRowId": "1-KX5-55", "CertPercentage": null, "TechRowId": "1-MEH-744" }, { "ServiceModelName": "L9 CM2350 L120C", "SmnRowId": "1-DTGM-246", "SpCode": "08486", "SpRowId": "1-KX5-55", "CertPercentage": null, "TechRowId": "1-MEH-744" }, { "ServiceModelName": "B6.7 CM2350 B136C", "SmnRowId": "1-DTGM-263", "SpCode": "31514", "SpRowId": "1-KX9-1437", "CertPercentage": null, "TechRowId": "1-MEH-7530" }, { "ServiceModelName": "L9 CM2350 L120C", "SmnRowId": "1-DTGM-261", "SpCode": "31514", "SpRowId": "1-KX9-1437", "CertPercentage": null, "TechRowId": "1-MEH-7530" }, { "ServiceModelName": "B6.7 CM2350 B136C", "SmnRowId": "1-DTGM-158", "SpCode": "02653", "SpRowId": "1-KX7-32", "CertPercentage": null, "TechRowId": "1-MEH-7827" }, { "ServiceModelName": "B6.7 CM2350 B136C", "SmnRowId": "1-DTGM-83", "SpCode": "11600", "SpRowId": "1-KX9-118", "CertPercentage": null, "TechRowId": "1-MEH-785" }, { "ServiceModelName": "B6.7 CM2350 B136C", "SmnRowId": "1-DTGM-11", "SpCode": "03610", "SpRowId": "1-KX7-48", "CertPercentage": null, "TechRowId": "1-MEH-7863" }, { "ServiceModelName": "B6.7 CM2350 B136C", "SmnRowId": "1-DTGM-86", "SpCode": "08522", "SpRowId": "1-KX1-68", "CertPercentage": null, "TechRowId": "1-MEH-7898" }, { "ServiceModelName": "B6.7 CM2350 B136C", "SmnRowId": "1-DTGM-130", "SpCode": "56331", "SpRowId": "1-KX3-3136", "CertPercentage": null, "TechRowId": "1-MEH-8199" }, { "ServiceModelName": "ISL9 CM2250", "SmnRowId": "1-N9Y-6558", "SpCode": "56331", "SpRowId": "1-KX3-3136", "CertPercentage": null, "TechRowId": "1-MEH-8199" }, { "ServiceModelName": "L9 CM2350 L120C", "SmnRowId": "1-DTGM-129", "SpCode": "56331", "SpRowId": "1-KX3-3136", "CertPercentage": null, "TechRowId": "1-MEH-8199" }, { "ServiceModelName": "QSF2.8 CM2880 F114", "SmnRowId": "1-DTGM-128", "SpCode": "56331", "SpRowId": "1-KX3-3136", "CertPercentage": null, "TechRowId": "1-MEH-8199" }, { "ServiceModelName": "QSX15 CM2350 X105", "SmnRowId": "1-NAC-1499", "SpCode": "56331", "SpRowId": "1-KX3-3136", "CertPercentage": null, "TechRowId": "1-MEH-8199" }, { "ServiceModelName": "B6.7 CM2350 B136C", "SmnRowId": "1-DTGM-404", "SpCode": "74663", "SpRowId": "1-KX1-2839", "CertPercentage": null, "TechRowId": "1-MEH-8230" }, { "ServiceModelName": "L9 CM2350 L120C", "SmnRowId": "1-DTGM-403", "SpCode": "74663", "SpRowId": "1-KX1-2839", "CertPercentage": null, "TechRowId": "1-MEH-8230" }, { "ServiceModelName": "B6.7 CM2350 B136C", "SmnRowId": "1-DTGM-250", "SpCode": "02992", "SpRowId": "1-KX3-34", "CertPercentage": null, "TechRowId": "1-MEH-8336" }, { "ServiceModelName": "L9 CM2350 L120C", "SmnRowId": "1-DTGM-249", "SpCode": "02992", "SpRowId": "1-KX3-34", "CertPercentage": null, "TechRowId": "1-MEH-8336" }, { "ServiceModelName": "QSX15 CM2350 X105", "SmnRowId": "1-B8G0-647", "SpCode": "02992", "SpRowId": "1-KX3-34", "CertPercentage": null, "TechRowId": "1-MEH-8336" }, { "ServiceModelName": "B6.7 CM2350 B136C", "SmnRowId": "1-DTGM-144", "SpCode": "03615", "SpRowId": "1-KX7-50", "CertPercentage": null, "TechRowId": "1-MEH-8340" }, { "ServiceModelName": "B6.7 CM2350 B136C", "SmnRowId": "1-DTGM-203", "SpCode": "17181", "SpRowId": "1-KX7-251", "CertPercentage": null, "TechRowId": "1-MEH-840" }, { "ServiceModelName": "L9 CM2350 L120C", "SmnRowId": "1-DTGM-202", "SpCode": "17181", "SpRowId": "1-KX7-251", "CertPercentage": null, "TechRowId": "1-MEH-840" }, { "ServiceModelName": "B6.7 CM2350 B136C", "SmnRowId": "1-DTGM-26", "SpCode": "56202", "SpRowId": "1-KX7-2396", "CertPercentage": null, "TechRowId": "1-MEH-8520" }, { "ServiceModelName": "L9 CM2350 L120C", "SmnRowId": "1-DTGM-25", "SpCode": "56202", "SpRowId": "1-KX7-2396", "CertPercentage": null, "TechRowId": "1-MEH-8520" }, { "ServiceModelName": "ISL9 CM2250", "SmnRowId": "1-NA2-1036", "SpCode": "56335", "SpRowId": "1-KX9-2603", "CertPercentage": null, "TechRowId": "1-MEH-8529" }, { "ServiceModelName": "QSF2.8 CM2880 F114", "SmnRowId": "1-DTGM-222", "SpCode": "56335", "SpRowId": "1-KX9-2603", "CertPercentage": null, "TechRowId": "1-MEH-8529" }, { "ServiceModelName": "ISL9 CM2250", "SmnRowId": "1-D1SH-10", "SpCode": "03614", "SpRowId": "1-KXB-21", "CertPercentage": null, "TechRowId": "1-MEH-8597" }, { "ServiceModelName": "QSF2.8 CM2880 F114", "SmnRowId": "1-DTGM-291", "SpCode": "56331", "SpRowId": "1-KX3-3136", "CertPercentage": null, "TechRowId": "1-MEH-8728" }, { "ServiceModelName": "ISL9 CM2250", "SmnRowId": "1-4ZRF-71", "SpCode": "02074", "SpRowId": "1-KX1-14", "CertPercentage": null, "TechRowId": "1-MEH-8781" }, { "ServiceModelName": "B6.7 CM2350 B136C", "SmnRowId": "1-DTGM-184", "SpCode": "04976", "SpRowId": "1-KXB-30", "CertPercentage": null, "TechRowId": "1-MEH-8797" }, { "ServiceModelName": "L9 CM2350 L120C", "SmnRowId": "1-DTGM-183", "SpCode": "04976", "SpRowId": "1-KXB-30", "CertPercentage": null, "TechRowId": "1-MEH-8797" }, { "ServiceModelName": "QSF2.8 CM2880 F114", "SmnRowId": "1-DTGM-13", "SpCode": "93224", "SpRowId": "1-KX1-3255", "CertPercentage": null, "TechRowId": "1-MEH-9212" }, { "ServiceModelName": "QSX15 CM2350 X105", "SmnRowId": "1-CWNC-8", "SpCode": "93224", "SpRowId": "1-KX1-3255", "CertPercentage": null, "TechRowId": "1-MEH-9212" }, { "ServiceModelName": "QSX15 CM2350 X105", "SmnRowId": "1-CWNC-11", "SpCode": "99583", "SpRowId": "1-KX1-3926", "CertPercentage": null, "TechRowId": "1-MEH-9213" }, { "ServiceModelName": "B6.7 CM2350 B136C", "SmnRowId": "1-DTGM-240", "SpCode": "56350", "SpRowId": "1-KX9-2604", "CertPercentage": null, "TechRowId": "1-MEH-9247" }, { "ServiceModelName": "L9 CM2350 L120C", "SmnRowId": "1-DTGM-239", "SpCode": "56350", "SpRowId": "1-KX9-2604", "CertPercentage": null, "TechRowId": "1-MEH-9247" }, { "ServiceModelName": "ISL9 CM2250", "SmnRowId": "1-NAC-483", "SpCode": "22299", "SpRowId": "1-KX9-506", "CertPercentage": null, "TechRowId": "1-MEH-976" }, { "ServiceModelName": "B6.7 CM2350 B136C", "SmnRowId": "1-DTGM-236", "SpCode": "34138", "SpRowId": "1-KX5-1916", "CertPercentage": null, "TechRowId": "1-MEK-1274" }, { "ServiceModelName": "L9 CM2350 L120C", "SmnRowId": "1-DTGM-235", "SpCode": "34138", "SpRowId": "1-KX5-1916", "CertPercentage": null, "TechRowId": "1-MEK-1274" }, { "ServiceModelName": "QSK38 CM2150 MCRS", "SmnRowId": "1-N9U-1700", "SpCode": "56256", "SpRowId": "1-KX5-2575", "CertPercentage": null, "TechRowId": "1-MEK-1369" }, { "ServiceModelName": "B6.7 CM2350 B136C", "SmnRowId": "1-DTGM-60", "SpCode": "02025", "SpRowId": "1-KX9-7", "CertPercentage": null, "TechRowId": "1-MEK-1501" }, { "ServiceModelName": "L9 CM2350 L120C", "SmnRowId": "1-DTGM-59", "SpCode": "02025", "SpRowId": "1-KX9-7", "CertPercentage": null, "TechRowId": "1-MEK-1501" }, { "ServiceModelName": "B6.7 CM2350 B136C", "SmnRowId": "1-DTGM-326", "SpCode": "02370", "SpRowId": "1-KX1-22", "CertPercentage": null, "TechRowId": "1-MEK-1530" }, { "ServiceModelName": "L9 CM2350 L120C", "SmnRowId": "1-DTGM-325", "SpCode": "02370", "SpRowId": "1-KX1-22", "CertPercentage": null, "TechRowId": "1-MEK-1530" }, { "ServiceModelName": "QSX15 CM2350 X105", "SmnRowId": "1-CWNC-10", "SpCode": "02370", "SpRowId": "1-KX1-22", "CertPercentage": null, "TechRowId": "1-MEK-1530" }, { "ServiceModelName": "QSF2.8 CM2880 F114", "SmnRowId": "1-DTGM-104", "SpCode": "02843", "SpRowId": "1-KX5-22", "CertPercentage": null, "TechRowId": "1-MEK-1561" }, { "ServiceModelName": "B6.7 CM2350 B136C", "SmnRowId": "1-DTGM-171", "SpCode": "03615", "SpRowId": "1-KX7-50", "CertPercentage": null, "TechRowId": "1-MEK-1612" }, { "ServiceModelName": "L9 CM2350 L120C", "SmnRowId": "1-DTGM-117", "SpCode": "03750", "SpRowId": "1-KXB-25", "CertPercentage": null, "TechRowId": "1-MEK-1615" }, { "ServiceModelName": "ISL9 CM2250", "SmnRowId": "1-D1SH-23", "SpCode": "27158", "SpRowId": "1-KX9-1120", "CertPercentage": null, "TechRowId": "1-MEK-2186" }, { "ServiceModelName": "B6.7 CM2350 B136C", "SmnRowId": "1-DTGM-120", "SpCode": "56256", "SpRowId": "1-KX5-2575", "CertPercentage": null, "TechRowId": "1-MEK-2482" }, { "ServiceModelName": "L9 CM2350 L120C", "SmnRowId": "1-DTGM-119", "SpCode": "56256", "SpRowId": "1-KX5-2575", "CertPercentage": null, "TechRowId": "1-MEK-2482" }, { "ServiceModelName": "B6.7 CM2350 B136C", "SmnRowId": "1-DTGM-147", "SpCode": "56331", "SpRowId": "1-KX3-3136", "CertPercentage": null, "TechRowId": "1-MEK-2488" }, { "ServiceModelName": "QSG12/X12 CM2350 G110", "SmnRowId": "1-CWNC-12", "SpCode": "02653", "SpRowId": "1-KX7-32", "CertPercentage": null, "TechRowId": "1-MEK-2784" }, { "ServiceModelName": "B6.7 CM2350 B136C", "SmnRowId": "1-DTGM-436", "SpCode": "02669", "SpRowId": "1-KX9-21", "CertPercentage": null, "TechRowId": "1-MEK-2790" }, { "ServiceModelName": "L9 CM2350 L120C", "SmnRowId": "1-DTGM-435", "SpCode": "02669", "SpRowId": "1-KX9-21", "CertPercentage": null, "TechRowId": "1-MEK-2790" }, { "ServiceModelName": "L9 CM2350 L120C", "SmnRowId": "1-DTGM-397", "SpCode": "02670", "SpRowId": "1-KX3-27", "CertPercentage": null, "TechRowId": "1-MEK-2792" }, { "ServiceModelName": "QSF2.8 CM2880 F114", "SmnRowId": "1-DTGM-123", "SpCode": "02848", "SpRowId": "1-KX1-36", "CertPercentage": null, "TechRowId": "1-MEK-2798" }, { "ServiceModelName": "B6.7 CM2350 B136C", "SmnRowId": "1-DTGM-241", "SpCode": "02867", "SpRowId": "1-KX9-28", "CertPercentage": null, "TechRowId": "1-MEK-2813" }, { "ServiceModelName": "B6.7 CM2350 B136C", "SmnRowId": "1-DTGM-88", "SpCode": "56251", "SpRowId": "1-KX7-2402", "CertPercentage": null, "TechRowId": "1-MEK-3944" }, { "ServiceModelName": "L9 CM2350 L120C", "SmnRowId": "1-DTGM-87", "SpCode": "56251", "SpRowId": "1-KX7-2402", "CertPercentage": null, "TechRowId": "1-MEK-3944" }, { "ServiceModelName": "B6.7 CM2350 B136C", "SmnRowId": "1-DTGM-6", "SpCode": "02684", "SpRowId": "1-KX5-21", "CertPercentage": null, "TechRowId": "1-MEK-4262" }, { "ServiceModelName": "L9 CM2350 L120C", "SmnRowId": "1-DTGM-5", "SpCode": "02684", "SpRowId": "1-KX5-21", "CertPercentage": null, "TechRowId": "1-MEK-4262" }, { "ServiceModelName": "QSF2.8 CM2880 F114", "SmnRowId": "1-DTGM-4", "SpCode": "02684", "SpRowId": "1-KX5-21", "CertPercentage": null, "TechRowId": "1-MEK-4262" }, { "ServiceModelName": "B6.7 CM2350 B136C", "SmnRowId": "1-DTGM-373", "SpCode": "03615", "SpRowId": "1-KX7-50", "CertPercentage": null, "TechRowId": "1-MEK-4323" }, { "ServiceModelName": "B6.7 CM2350 B136C", "SmnRowId": "1-DTGM-18", "SpCode": "08494", "SpRowId": "1-KXB-42", "CertPercentage": null, "TechRowId": "1-MEK-4422" }, { "ServiceModelName": "L9 CM2350 L120C", "SmnRowId": "1-DTGM-17", "SpCode": "08494", "SpRowId": "1-KXB-42", "CertPercentage": null, "TechRowId": "1-MEK-4422" }, { "ServiceModelName": "ISL9 CM2250", "SmnRowId": "1-D1SH-45", "SpCode": "10328", "SpRowId": "1-KX5-73", "CertPercentage": null, "TechRowId": "1-MEK-4438" }, { "ServiceModelName": "QSX15 CM2350 X105", "SmnRowId": "1-CWNC-13", "SpCode": "19003", "SpRowId": "1-KX1-466", "CertPercentage": null, "TechRowId": "1-MEK-4640" }, { "ServiceModelName": "ISL9 CM2250", "SmnRowId": "1-B8H9-1245", "SpCode": "23241", "SpRowId": "1-KX9-634", "CertPercentage": null, "TechRowId": "1-MEK-4869" }, { "ServiceModelName": "B6.7 CM2350 B136C", "SmnRowId": "1-DTGM-252", "SpCode": "39274", "SpRowId": "1-KWZ-2582", "CertPercentage": null, "TechRowId": "1-MEK-5272" }, { "ServiceModelName": "L9 CM2350 L120C", "SmnRowId": "1-DTGM-251", "SpCode": "39274", "SpRowId": "1-KWZ-2582", "CertPercentage": null, "TechRowId": "1-MEK-5272" }, { "ServiceModelName": "L9 CM2350 L120C", "SmnRowId": "1-DTGM-401", "SpCode": "56202", "SpRowId": "1-KX7-2396", "CertPercentage": null, "TechRowId": "1-MEK-554" }, { "ServiceModelName": "L9 CM2350 L120C", "SmnRowId": "1-DTGM-294", "SpCode": "02198", "SpRowId": "1-KX9-9", "CertPercentage": null, "TechRowId": "1-MEK-5607" }, { "ServiceModelName": "B6.7 CM2350 B136C", "SmnRowId": "1-DTGM-279", "SpCode": "02932", "SpRowId": "1-KXB-17", "CertPercentage": null, "TechRowId": "1-MEK-5655" }, { "ServiceModelName": "L9 CM2350 L120C", "SmnRowId": "1-DTGM-278", "SpCode": "02932", "SpRowId": "1-KXB-17", "CertPercentage": null, "TechRowId": "1-MEK-5655" }, { "ServiceModelName": "B6.7 CM2350 B136C", "SmnRowId": "1-DTGM-311", "SpCode": "02991", "SpRowId": "1-KX7-44", "CertPercentage": null, "TechRowId": "1-MEK-5660" }, { "ServiceModelName": "L9 CM2350 L120C", "SmnRowId": "1-DTGM-302", "SpCode": "02991", "SpRowId": "1-KX7-44", "CertPercentage": null, "TechRowId": "1-MEK-5660" }, { "ServiceModelName": "B6.7 CM2350 B136C", "SmnRowId": "1-DTGM-216", "SpCode": "02992", "SpRowId": "1-KX3-34", "CertPercentage": null, "TechRowId": "1-MEK-5663" }, { "ServiceModelName": "ISL9 CM2250", "SmnRowId": "1-B8N8-1213", "SpCode": "02992", "SpRowId": "1-KX3-34", "CertPercentage": null, "TechRowId": "1-MEK-5663" }, { "ServiceModelName": "L9 CM2350 L120C", "SmnRowId": "1-DTGM-215", "SpCode": "02992", "SpRowId": "1-KX3-34", "CertPercentage": null, "TechRowId": "1-MEK-5663" }, { "ServiceModelName": "QSF2.8 CM2880 F114", "SmnRowId": "1-442Z-529", "SpCode": "02992", "SpRowId": "1-KX3-34", "CertPercentage": null, "TechRowId": "1-MEK-5663" }, { "ServiceModelName": "QSG12/X12 CM2350 G110", "SmnRowId": "1-NA2-3989", "SpCode": "02992", "SpRowId": "1-KX3-34", "CertPercentage": null, "TechRowId": "1-MEK-5663" }, { "ServiceModelName": "QSF2.8 CM2880 F114", "SmnRowId": "1-DTGM-381", "SpCode": "04405", "SpRowId": "1-KX5-39", "CertPercentage": null, "TechRowId": "1-MEK-5686" }, { "ServiceModelName": "ISL9 CM2250", "SmnRowId": "1-D1SH-122", "SpCode": "24985", "SpRowId": "1-KWZ-1092", "CertPercentage": null, "TechRowId": "1-MEK-6192" }, { "ServiceModelName": "ISL9 CM2250", "SmnRowId": "1-D1SH-122", "SpCode": "04972", "SpRowId": "1-KWZ-17", "CertPercentage": null, "TechRowId": "1-MEK-6192" }, { "ServiceModelName": "B6.7 CM2350 B136C", "SmnRowId": "1-DTGM-238", "SpCode": "02012", "SpRowId": "1-KX3-12", "CertPercentage": null, "TechRowId": "1-MEK-635" }, { "ServiceModelName": "L9 CM2350 L120C", "SmnRowId": "1-DTGM-237", "SpCode": "02012", "SpRowId": "1-KX3-12", "CertPercentage": null, "TechRowId": "1-MEK-635" }, { "ServiceModelName": "L9 CM2350 L120C", "SmnRowId": "1-DTGM-352", "SpCode": "02074", "SpRowId": "1-KX1-14", "CertPercentage": null, "TechRowId": "1-MEK-644" }, { "ServiceModelName": "B6.7 CM2350 B136C", "SmnRowId": "1-DTGM-432", "SpCode": "56251", "SpRowId": "1-KX7-2402", "CertPercentage": null, "TechRowId": "1-MEK-6489" }, { "ServiceModelName": "L9 CM2350 L120C", "SmnRowId": "1-DTGM-431", "SpCode": "56251", "SpRowId": "1-KX7-2402", "CertPercentage": null, "TechRowId": "1-MEK-6489" }, { "ServiceModelName": "B6.7 CM2350 B136C", "SmnRowId": "1-DTGM-102", "SpCode": "74663", "SpRowId": "1-KX1-2839", "CertPercentage": null, "TechRowId": "1-MEK-6565" }, { "ServiceModelName": "L9 CM2350 L120C", "SmnRowId": "1-DTGM-101", "SpCode": "74663", "SpRowId": "1-KX1-2839", "CertPercentage": null, "TechRowId": "1-MEK-6565" }, { "ServiceModelName": "B6.7 CM2350 B136C", "SmnRowId": "1-DTGM-330", "SpCode": "02661", "SpRowId": "1-KX1-31", "CertPercentage": null, "TechRowId": "1-MEK-6738" }, { "ServiceModelName": "L9 CM2350 L120C", "SmnRowId": "1-DTGM-321", "SpCode": "02661", "SpRowId": "1-KX1-31", "CertPercentage": null, "TechRowId": "1-MEK-6738" }, { "ServiceModelName": "B6.7 CM2350 B136C", "SmnRowId": "1-DTGM-419", "SpCode": "02992", "SpRowId": "1-KX3-34", "CertPercentage": null, "TechRowId": "1-MEK-6760" }, { "ServiceModelName": "L9 CM2350 L120C", "SmnRowId": "1-DTGM-418", "SpCode": "02992", "SpRowId": "1-KX3-34", "CertPercentage": null, "TechRowId": "1-MEK-6760" }, { "ServiceModelName": "L9 CM2350 L120C", "SmnRowId": "1-DTGM-85", "SpCode": "03525", "SpRowId": "1-KX5-34", "CertPercentage": null, "TechRowId": "1-MEK-6766" }, { "ServiceModelName": "B6.7 CM2350 B136C", "SmnRowId": "1-DTGM-245", "SpCode": "03525", "SpRowId": "1-KX5-34", "CertPercentage": null, "TechRowId": "1-MEK-6771" }, { "ServiceModelName": "L9 CM2350 L120C", "SmnRowId": "1-DTGM-244", "SpCode": "03525", "SpRowId": "1-KX5-34", "CertPercentage": null, "TechRowId": "1-MEK-6771" }, { "ServiceModelName": "B6.7 CM2350 B136C", "SmnRowId": "1-DTGM-159", "SpCode": "11738", "SpRowId": "1-KX1-167", "CertPercentage": null, "TechRowId": "1-MEK-6878" }, { "ServiceModelName": "L9 CM2350 L120C", "SmnRowId": "1-DTGM-154", "SpCode": "11738", "SpRowId": "1-KX1-167", "CertPercentage": null, "TechRowId": "1-MEK-6878" }, { "ServiceModelName": "B6.7 CM2350 B136C", "SmnRowId": "1-DTGM-187", "SpCode": "02022", "SpRowId": "1-KX1-9", "CertPercentage": null, "TechRowId": "1-MEK-7533" }, { "ServiceModelName": "ISL9 CM2250", "SmnRowId": "1-D1SH-12", "SpCode": "27915", "SpRowId": "1-KX3-970", "CertPercentage": null, "TechRowId": "1-MEK-7815" }, { "ServiceModelName": "B6.7 CM2350 B136C", "SmnRowId": "1-DTGM-265", "SpCode": "17181", "SpRowId": "1-KX7-251", "CertPercentage": null, "TechRowId": "1-MEK-8835" }, { "ServiceModelName": "L9 CM2350 L120C", "SmnRowId": "1-DTGM-264", "SpCode": "17181", "SpRowId": "1-KX7-251", "CertPercentage": null, "TechRowId": "1-MEK-8835" }, { "ServiceModelName": "B6.7 CM2350 B136C", "SmnRowId": "1-DTGM-385", "SpCode": "19721", "SpRowId": "1-KX3-395", "CertPercentage": null, "TechRowId": "1-MEK-957" }, { "ServiceModelName": "L9 CM2350 L120C", "SmnRowId": "1-DTGM-384", "SpCode": "19721", "SpRowId": "1-KX3-395", "CertPercentage": null, "TechRowId": "1-MEK-957" }, { "ServiceModelName": "ISL9 CM2250", "SmnRowId": "1-D1SH-18", "SpCode": "56256", "SpRowId": "1-KX5-2575", "CertPercentage": null, "TechRowId": "1-MEN-2243" }, { "ServiceModelName": "ISL9 CM2250", "SmnRowId": "1-D1SH-21", "SpCode": "92237", "SpRowId": "1-KX7-2994", "CertPercentage": null, "TechRowId": "1-MEN-2347" }, { "ServiceModelName": "L9 CM2350 L120C", "SmnRowId": "1-DTGM-320", "SpCode": "56332", "SpRowId": "1-KX9-2602", "CertPercentage": null, "TechRowId": "1-MEN-3564" }, { "ServiceModelName": "B6.7 CM2350 B136C", "SmnRowId": "1-DTGM-186", "SpCode": "33877", "SpRowId": "1-KX1-2261", "CertPercentage": null, "TechRowId": "1-MEN-4708" }, { "ServiceModelName": "L9 CM2350 L120C", "SmnRowId": "1-DTGM-185", "SpCode": "33877", "SpRowId": "1-KX1-2261", "CertPercentage": null, "TechRowId": "1-MEN-4708" }, { "ServiceModelName": "ISL9 CM2250", "SmnRowId": "1-D1SH-19", "SpCode": "90559", "SpRowId": "1-KX3-3331", "CertPercentage": null, "TechRowId": "1-MEN-4985" }, { "ServiceModelName": "ISL9 CM2250", "SmnRowId": "1-D1SH-2", "SpCode": "19518", "SpRowId": "1-KX5-417", "CertPercentage": null, "TechRowId": "1-MEN-843" }, { "ServiceModelName": "ISL9 CM2250", "SmnRowId": "1-D1SH-3", "SpCode": "38413", "SpRowId": "1-KWZ-2473", "CertPercentage": null, "TechRowId": "1-MEQ-1183" }, { "ServiceModelName": "B6.7 CM2350 B136C", "SmnRowId": "1-DTGM-317", "SpCode": "03616", "SpRowId": "1-KX9-38", "CertPercentage": null, "TechRowId": "1-MEQ-1442" }, { "ServiceModelName": "L9 CM2350 L120C", "SmnRowId": "1-DTGM-316", "SpCode": "03616", "SpRowId": "1-KX9-38", "CertPercentage": null, "TechRowId": "1-MEQ-1442" }, { "ServiceModelName": "ISL9 CM2250", "SmnRowId": "1-B8IG-687", "SpCode": "04405", "SpRowId": "1-KX5-39", "CertPercentage": null, "TechRowId": "1-MEQ-2665" }, { "ServiceModelName": "QSX15 CM2350 X105", "SmnRowId": "1-CWNC-14", "SpCode": "12792", "SpRowId": "1-KWZ-165", "CertPercentage": null, "TechRowId": "1-MEQ-2814" }, { "ServiceModelName": "ISL9 CM2250", "SmnRowId": "1-D1SH-44", "SpCode": "13076", "SpRowId": "1-KXB-131", "CertPercentage": null, "TechRowId": "1-MEQ-2824" }, { "ServiceModelName": "B6.7 CM2350 B136C", "SmnRowId": "1-DTGM-82", "SpCode": "39113", "SpRowId": "1-KX1-2705", "CertPercentage": null, "TechRowId": "1-MEQ-6905" }, { "ServiceModelName": "L9 CM2350 L120C", "SmnRowId": "1-DTGM-81", "SpCode": "39113", "SpRowId": "1-KX1-2705", "CertPercentage": null, "TechRowId": "1-MEQ-6905" }, { "ServiceModelName": "ISL9 CM2250", "SmnRowId": "1-B8G6-95", "SpCode": "23341", "SpRowId": "1-KX1-1099", "CertPercentage": null, "TechRowId": "1-MEQ-903" }, { "ServiceModelName": "B6.7 CM2350 B136C", "SmnRowId": "1-DTGM-167", "SpCode": "56334", "SpRowId": "1-KWZ-2658", "CertPercentage": null, "TechRowId": "1-MET-1123" }, { "ServiceModelName": "L9 CM2350 L120C", "SmnRowId": "1-DTGM-166", "SpCode": "56334", "SpRowId": "1-KWZ-2658", "CertPercentage": null, "TechRowId": "1-MET-1123" }, { "ServiceModelName": "QSF2.8 CM2880 F114", "SmnRowId": "1-DTGM-75", "SpCode": "02670", "SpRowId": "1-KX3-27", "CertPercentage": null, "TechRowId": "1-MET-1280" }, { "ServiceModelName": "QSX15 CM2350 X105", "SmnRowId": "1-CWNC-15", "SpCode": "56203", "SpRowId": "1-KX1-2805", "CertPercentage": null, "TechRowId": "1-MET-2114" }, { "ServiceModelName": "L9 CM2350 L120C", "SmnRowId": "1-DTGM-364", "SpCode": "56206", "SpRowId": "1-KX7-2397", "CertPercentage": null, "TechRowId": "1-MET-2115" }, { "ServiceModelName": "B6.7 CM2350 B136C", "SmnRowId": "1-DTGM-400", "SpCode": "02841", "SpRowId": "1-KX1-35", "CertPercentage": null, "TechRowId": "1-MET-230" }, { "ServiceModelName": "L9 CM2350 L120C", "SmnRowId": "1-DTGM-399", "SpCode": "02841", "SpRowId": "1-KX1-35", "CertPercentage": null, "TechRowId": "1-MET-230" }, { "ServiceModelName": "B6.7 CM2350 B136C", "SmnRowId": "1-DTGM-69", "SpCode": "02028", "SpRowId": "1-KX7-9", "CertPercentage": null, "TechRowId": "1-MET-2321" }, { "ServiceModelName": "L9 CM2350 L120C", "SmnRowId": "1-DTGM-67", "SpCode": "02028", "SpRowId": "1-KX7-9", "CertPercentage": null, "TechRowId": "1-MET-2321" }, { "ServiceModelName": "B6.7 CM2350 B136C", "SmnRowId": "1-DTGM-282", "SpCode": "02402", "SpRowId": "1-KX5-15", "CertPercentage": null, "TechRowId": "1-MET-2354" }, { "ServiceModelName": "L9 CM2350 L120C", "SmnRowId": "1-DTGM-281", "SpCode": "02402", "SpRowId": "1-KX5-15", "CertPercentage": null, "TechRowId": "1-MET-2354" }, { "ServiceModelName": "QSF2.8 CM2880 F114", "SmnRowId": "1-DTGM-214", "SpCode": "04897", "SpRowId": "1-KX9-49", "CertPercentage": null, "TechRowId": "1-MET-2438" }, { "ServiceModelName": "B6.7 CM2350 B136C", "SmnRowId": "1-DTGM-47", "SpCode": "08522", "SpRowId": "1-KX1-68", "CertPercentage": null, "TechRowId": "1-MET-2512" }, { "ServiceModelName": "ISL9 CM2250", "SmnRowId": "1-D1SH-15", "SpCode": "21952", "SpRowId": "1-KX9-478", "CertPercentage": null, "TechRowId": "1-MET-2810" }, { "ServiceModelName": "ISL9 CM2250", "SmnRowId": "1-D1SH-22", "SpCode": "27915", "SpRowId": "1-KX3-970", "CertPercentage": null, "TechRowId": "1-MET-3047" }, { "ServiceModelName": "B6.7 CM2350 B136C", "SmnRowId": "1-DTGM-51", "SpCode": "37679", "SpRowId": "1-KWZ-2422", "CertPercentage": null, "TechRowId": "1-MET-3282" }, { "ServiceModelName": "L9 CM2350 L120C", "SmnRowId": "1-DTGM-50", "SpCode": "37679", "SpRowId": "1-KWZ-2422", "CertPercentage": null, "TechRowId": "1-MET-3282" }, { "ServiceModelName": "L9 CM2350 L120C", "SmnRowId": "1-DTGM-365", "SpCode": "74792", "SpRowId": "1-KX1-2851", "CertPercentage": null, "TechRowId": "1-MET-3439" }, { "ServiceModelName": "QSF2.8 CM2880 F114", "SmnRowId": "1-DTGM-426", "SpCode": "02076", "SpRowId": "1-KX3-14", "CertPercentage": null, "TechRowId": "1-MET-3640" }, { "ServiceModelName": "ISL9 CM2250", "SmnRowId": "1-D1SH-27", "SpCode": "10328", "SpRowId": "1-KX5-73", "CertPercentage": null, "TechRowId": "1-MET-3822" }, { "ServiceModelName": "ISL9 CM2250", "SmnRowId": "1-D1SH-11", "SpCode": "27915", "SpRowId": "1-KX3-970", "CertPercentage": null, "TechRowId": "1-MET-4345" }, { "ServiceModelName": "B6.7 CM2350 B136C", "SmnRowId": "1-DTGM-151", "SpCode": "56202", "SpRowId": "1-KX7-2396", "CertPercentage": null, "TechRowId": "1-MET-4656" }, { "ServiceModelName": "L9 CM2350 L120C", "SmnRowId": "1-DTGM-150", "SpCode": "56202", "SpRowId": "1-KX7-2396", "CertPercentage": null, "TechRowId": "1-MET-4656" }, { "ServiceModelName": "B6.7 CM2350 B136C", "SmnRowId": "1-DTGM-177", "SpCode": "56332", "SpRowId": "1-KX9-2602", "CertPercentage": null, "TechRowId": "1-MET-4674" }, { "ServiceModelName": "B6.7 CM2350 B136C", "SmnRowId": "1-DTGM-213", "SpCode": "56334", "SpRowId": "1-KWZ-2658", "CertPercentage": null, "TechRowId": "1-MET-4677" }, { "ServiceModelName": "L9 CM2350 L120C", "SmnRowId": "1-DTGM-212", "SpCode": "56334", "SpRowId": "1-KWZ-2658", "CertPercentage": null, "TechRowId": "1-MET-4677" }, { "ServiceModelName": "B6.7 CM2350 B136C", "SmnRowId": "1-DTGM-268", "SpCode": "56335", "SpRowId": "1-KX9-2603", "CertPercentage": null, "TechRowId": "1-MET-4678" }, { "ServiceModelName": "L9 CM2350 L120C", "SmnRowId": "1-DTGM-267", "SpCode": "56335", "SpRowId": "1-KX9-2603", "CertPercentage": null, "TechRowId": "1-MET-4678" }, { "ServiceModelName": "B6.7 CM2350 B136C", "SmnRowId": "1-DTGM-68", "SpCode": "02364", "SpRowId": "1-KX1-21", "CertPercentage": null, "TechRowId": "1-MET-4928" }, { "ServiceModelName": "L9 CM2350 L120C", "SmnRowId": "1-DTGM-19", "SpCode": "02843", "SpRowId": "1-KX5-22", "CertPercentage": null, "TechRowId": "1-MET-4956" }, { "ServiceModelName": "QSF2.8 CM2880 F114", "SmnRowId": "1-DTGM-355", "SpCode": "04405", "SpRowId": "1-KX5-39", "CertPercentage": null, "TechRowId": "1-MET-5004" }, { "ServiceModelName": "B6.7 CM2350 B136C", "SmnRowId": "1-DTGM-110", "SpCode": "02044", "SpRowId": "1-KX7-12", "CertPercentage": null, "TechRowId": "1-MET-542" }, { "ServiceModelName": "L9 CM2350 L120C", "SmnRowId": "1-DTGM-109", "SpCode": "02044", "SpRowId": "1-KX7-12", "CertPercentage": null, "TechRowId": "1-MET-542" }, { "ServiceModelName": "B6.7 CM2350 B136C", "SmnRowId": "1-DTGM-248", "SpCode": "02231", "SpRowId": "1-KX5-13", "CertPercentage": null, "TechRowId": "1-MET-549" }, { "ServiceModelName": "B6.7 CM2350 B136C", "SmnRowId": "1-DTGM-423", "SpCode": "02028", "SpRowId": "1-KX7-9", "CertPercentage": null, "TechRowId": "1-MET-5937" }, { "ServiceModelName": "L9 CM2350 L120C", "SmnRowId": "1-DTGM-141", "SpCode": "02170", "SpRowId": "1-KX3-16", "CertPercentage": null, "TechRowId": "1-MET-5940" }, { "ServiceModelName": "B6.7 CM2350 B136C", "SmnRowId": "1-DTGM-188", "SpCode": "08440", "SpRowId": "1-KX9-56", "CertPercentage": null, "TechRowId": "1-MET-628" }, { "ServiceModelName": "L9 CM2350 L120C", "SmnRowId": "1-DTGM-181", "SpCode": "08440", "SpRowId": "1-KX9-56", "CertPercentage": null, "TechRowId": "1-MET-628" }, { "ServiceModelName": "ISL9 CM2250", "SmnRowId": "1-D1SH-5", "SpCode": "27915", "SpRowId": "1-KX3-970", "CertPercentage": null, "TechRowId": "1-MET-6341" }, { "ServiceModelName": "B6.7 CM2350 B136C", "SmnRowId": "1-DTGM-106", "SpCode": "56273", "SpRowId": "1-KX9-2599", "CertPercentage": null, "TechRowId": "1-MET-6554" }, { "ServiceModelName": "L9 CM2350 L120C", "SmnRowId": "1-DTGM-105", "SpCode": "56273", "SpRowId": "1-KX9-2599", "CertPercentage": null, "TechRowId": "1-MET-6554" }, { "ServiceModelName": "B6.7 CM2350 B136C", "SmnRowId": "1-DTGM-114", "SpCode": "05085", "SpRowId": "1-KX3-54", "CertPercentage": null, "TechRowId": "1-MET-6802" }, { "ServiceModelName": "B6.7 CM2350 B136C", "SmnRowId": "1-DTGM-194", "SpCode": "56324", "SpRowId": "1-KX7-2411", "CertPercentage": null, "TechRowId": "1-MET-7563" }, { "ServiceModelName": "L9 CM2350 L120C", "SmnRowId": "1-DTGM-193", "SpCode": "56324", "SpRowId": "1-KX7-2411", "CertPercentage": null, "TechRowId": "1-MET-7563" }, { "ServiceModelName": "QSF2.8 CM2880 F114", "SmnRowId": "1-DTGM-138", "SpCode": "93224", "SpRowId": "1-KX1-3255", "CertPercentage": null, "TechRowId": "1-MET-8666" }, { "ServiceModelName": "ISL9 CM2250", "SmnRowId": "1-442V-15", "SpCode": "93724", "SpRowId": "1-KX1-3364", "CertPercentage": null, "TechRowId": "1-Z4B-4" }, { "ServiceModelName": "B6.7 CM2350 B136C", "SmnRowId": "1-DTGM-157", "SpCode": "03050", "SpRowId": "1-KX9-33", "CertPercentage": null, "TechRowId": "1-19BB-4" }, { "ServiceModelName": "L9 CM2350 L120C", "SmnRowId": "1-DTGM-156", "SpCode": "03050", "SpRowId": "1-KX9-33", "CertPercentage": null, "TechRowId": "1-19BB-4" }, { "ServiceModelName": "ISL9 CM2250", "SmnRowId": "1-D1SH-20", "SpCode": "20761", "SpRowId": "1-KWZ-550", "CertPercentage": null, "TechRowId": "1-1UDH-31" }, { "ServiceModelName": "B6.7 CM2350 B136C", "SmnRowId": "1-DTGM-310", "SpCode": "74792", "SpRowId": "1-KX1-2851", "CertPercentage": null, "TechRowId": "1-1Y08-15" }, { "ServiceModelName": "L9 CM2350 L120C", "SmnRowId": "1-DTGM-309", "SpCode": "74792", "SpRowId": "1-KX1-2851", "CertPercentage": null, "TechRowId": "1-1Y08-15" }, { "ServiceModelName": "B6.7 CM2350 B136C", "SmnRowId": "1-DTGM-208", "SpCode": "56202", "SpRowId": "1-KX7-2396", "CertPercentage": null, "TechRowId": "1-1Y08-35" }, { "ServiceModelName": "L9 CM2350 L120C", "SmnRowId": "1-DTGM-207", "SpCode": "56202", "SpRowId": "1-KX7-2396", "CertPercentage": null, "TechRowId": "1-1Y08-35" }, { "ServiceModelName": "ISL9 CM2250", "SmnRowId": "1-D1SH-35", "SpCode": "10580", "SpRowId": "1-KX5-83", "CertPercentage": null, "TechRowId": "1-1ZFY-17" }, { "ServiceModelName": "ISL9 CM2250", "SmnRowId": "1-D1SH-17", "SpCode": "36733", "SpRowId": "1-KX1-2473", "CertPercentage": null, "TechRowId": "1-29CA-170" }, { "ServiceModelName": "B6.7 CM2350 B136C", "SmnRowId": "1-DTGM-383", "SpCode": "02370", "SpRowId": "1-KX1-22", "CertPercentage": null, "TechRowId": "1-29CA-217" }, { "ServiceModelName": "B6.7 CM2350 B136C", "SmnRowId": "1-DTGM-408", "SpCode": "02363", "SpRowId": "1-KX7-19", "CertPercentage": null, "TechRowId": "1-2DSM-21" }, { "ServiceModelName": "L9 CM2350 L120C", "SmnRowId": "1-DTGM-407", "SpCode": "02363", "SpRowId": "1-KX7-19", "CertPercentage": null, "TechRowId": "1-2DSM-21" }, { "ServiceModelName": "ISL9 CM2250", "SmnRowId": "1-D1SH-16", "SpCode": "10838", "SpRowId": "1-KXB-79", "CertPercentage": null, "TechRowId": "1-2GUF-13" }, { "ServiceModelName": "B6.7 CM2350 B136C", "SmnRowId": "1-DTGM-304", "SpCode": "08440", "SpRowId": "1-KX9-56", "CertPercentage": null, "TechRowId": "1-30ON-148" }, { "ServiceModelName": "L9 CM2350 L120C", "SmnRowId": "1-DTGM-303", "SpCode": "08440", "SpRowId": "1-KX9-56", "CertPercentage": null, "TechRowId": "1-30ON-148" }, { "ServiceModelName": "L9 CM2350 L120C", "SmnRowId": "1-DTGM-327", "SpCode": "02932", "SpRowId": "1-KXB-17", "CertPercentage": null, "TechRowId": "1-30ON-27" }, { "ServiceModelName": "L9 CM2350 L120C", "SmnRowId": "1-DTGM-260", "SpCode": "50697", "SpRowId": "1-2KH4-73", "CertPercentage": null, "TechRowId": "1-30ON-6" }, { "ServiceModelName": "L9 CM2350 L120C", "SmnRowId": "1-DTGM-266", "SpCode": "23989", "SpRowId": "1-KX1-1264", "CertPercentage": null, "TechRowId": "1-30ON-697" }, { "ServiceModelName": "B6.7 CM2350 B136C", "SmnRowId": "1-DTGM-269", "SpCode": "02027", "SpRowId": "1-KX1-10", "CertPercentage": null, "TechRowId": "1-30ON-911" }, { "ServiceModelName": "B6.7 CM2350 B136C", "SmnRowId": "1-DTGM-275", "SpCode": "02949", "SpRowId": "1-KX9-32", "CertPercentage": null, "TechRowId": "1-3895-21" }, { "ServiceModelName": "ISL9 CM2250", "SmnRowId": "1-D1SH-26", "SpCode": "02949", "SpRowId": "1-KX9-32", "CertPercentage": null, "TechRowId": "1-3895-21" }, { "ServiceModelName": "L9 CM2350 L120C", "SmnRowId": "1-DTGM-274", "SpCode": "02949", "SpRowId": "1-KX9-32", "CertPercentage": null, "TechRowId": "1-3895-21" }, { "ServiceModelName": "B6.7 CM2350 B136C", "SmnRowId": "1-DTGM-356", "SpCode": "02363", "SpRowId": "1-KX7-19", "CertPercentage": null, "TechRowId": "1-3C5A-16" }, { "ServiceModelName": "QSG12/X12 CM2350 G110", "SmnRowId": "1-CWNC-1", "SpCode": "02363", "SpRowId": "1-KX7-19", "CertPercentage": null, "TechRowId": "1-3C5A-16" }, { "ServiceModelName": "ISL9 CM2250", "SmnRowId": "1-D1SH-52", "SpCode": "37425", "SpRowId": "1-KX9-2264", "CertPercentage": null, "TechRowId": "1-3EMB-36" }, { "ServiceModelName": "ISL9 CM2250", "SmnRowId": "1-D1SH-24", "SpCode": "02949", "SpRowId": "1-KX9-32", "CertPercentage": null, "TechRowId": "1-3YDK-15" }, { "ServiceModelName": "ISL9 CM2250", "SmnRowId": "1-D1SH-50", "SpCode": "12648", "SpRowId": "1-KX3-118", "CertPercentage": null, "TechRowId": "1-44H1-41" }, { "ServiceModelName": "B6.7 CM2350 B136C", "SmnRowId": "1-DTGM-280", "SpCode": "56273", "SpRowId": "1-KX9-2599", "CertPercentage": null, "TechRowId": "1-4BV7-6" }, { "ServiceModelName": "B6.7 CM2350 B136C", "SmnRowId": "1-DTGM-273", "SpCode": "02992", "SpRowId": "1-KX3-34", "CertPercentage": null, "TechRowId": "1-4MR8-2" }, { "ServiceModelName": "L9 CM2350 L120C", "SmnRowId": "1-DTGM-272", "SpCode": "02992", "SpRowId": "1-KX3-34", "CertPercentage": null, "TechRowId": "1-4MR8-2" }, { "ServiceModelName": "ISL9 CM2250", "SmnRowId": "1-D1SH-25", "SpCode": "34922", "SpRowId": "1-KXB-1107", "CertPercentage": null, "TechRowId": "1-4SRP-24" }, { "ServiceModelName": "ISL9 CM2250", "SmnRowId": "1-D1SH-56", "SpCode": "27479", "SpRowId": "1-KX3-939", "CertPercentage": null, "TechRowId": "1-4ZOZ-39" }, { "ServiceModelName": "ISL9 CM2250", "SmnRowId": "1-D1SH-56", "SpCode": "24981", "SpRowId": "1-KX5-1096", "CertPercentage": null, "TechRowId": "1-4ZOZ-39" }, { "ServiceModelName": "ISL9 CM2250", "SmnRowId": "1-D1SH-57", "SpCode": "74792", "SpRowId": "1-KX1-2851", "CertPercentage": null, "TechRowId": "1-4ZP3-43" }, { "ServiceModelName": "B6.7 CM2350 B136C", "SmnRowId": "1-DTGM-313", "SpCode": "27732", "SpRowId": "1-KX9-1204", "CertPercentage": null, "TechRowId": "1-4ZP6-149" }, { "ServiceModelName": "L9 CM2350 L120C", "SmnRowId": "1-DTGM-312", "SpCode": "27732", "SpRowId": "1-KX9-1204", "CertPercentage": null, "TechRowId": "1-4ZP6-149" }, { "ServiceModelName": "L9 CM2350 L120C", "SmnRowId": "1-DTGM-347", "SpCode": "04975", "SpRowId": "1-KX9-51", "CertPercentage": null, "TechRowId": "1-4ZP6-178" }, { "ServiceModelName": "ISL9 CM2250", "SmnRowId": "1-D1SH-47", "SpCode": "02363", "SpRowId": "1-KX7-19", "CertPercentage": null, "TechRowId": "1-5LNN-16" }, { "ServiceModelName": "QSX15 CM2350 X105", "SmnRowId": "1-CWNC-2", "SpCode": "02991", "SpRowId": "1-KX7-44", "CertPercentage": null, "TechRowId": "1-5LNN-185" }, { "ServiceModelName": "ISL9 CM2250", "SmnRowId": "1-D1SH-115", "SpCode": "02374", "SpRowId": "1-KX7-21", "CertPercentage": null, "TechRowId": "1-5LNN-44" }, { "ServiceModelName": "L9 CM2350 L120C", "SmnRowId": "1-DTGM-398", "SpCode": "02374", "SpRowId": "1-KX7-21", "CertPercentage": null, "TechRowId": "1-5LNN-44" }, { "ServiceModelName": "ISL9 CM2250", "SmnRowId": "1-D1SH-46", "SpCode": "38568", "SpRowId": "1-KX5-2181", "CertPercentage": null, "TechRowId": "1-64AA-7" }, { "ServiceModelName": "B6.7 CM2350 B136C", "SmnRowId": "1-DTGM-421", "SpCode": "02434", "SpRowId": "1-KX9-15", "CertPercentage": null, "TechRowId": "1-6P77-21" }, { "ServiceModelName": "L9 CM2350 L120C", "SmnRowId": "1-DTGM-420", "SpCode": "02434", "SpRowId": "1-KX9-15", "CertPercentage": null, "TechRowId": "1-6P77-21" }, { "ServiceModelName": "B6.7 CM2350 B136C", "SmnRowId": "1-DTGM-342", "SpCode": "02012", "SpRowId": "1-KX3-12", "CertPercentage": null, "TechRowId": "1-6PUL-10" }, { "ServiceModelName": "L9 CM2350 L120C", "SmnRowId": "1-DTGM-341", "SpCode": "02012", "SpRowId": "1-KX3-12", "CertPercentage": null, "TechRowId": "1-6PUL-10" }, { "ServiceModelName": "B6.7 CM2350 B136C", "SmnRowId": "1-DTGM-338", "SpCode": "02002", "SpRowId": "1-KX7-4", "CertPercentage": null, "TechRowId": "1-6QQB-23" }, { "ServiceModelName": "L9 CM2350 L120C", "SmnRowId": "1-DTGM-337", "SpCode": "02002", "SpRowId": "1-KX7-4", "CertPercentage": null, "TechRowId": "1-6QQB-23" }, { "ServiceModelName": "B6.7 CM2350 B136C", "SmnRowId": "1-DTGM-340", "SpCode": "74792", "SpRowId": "1-KX1-2851", "CertPercentage": null, "TechRowId": "1-6SPT-4" }, { "ServiceModelName": "L9 CM2350 L120C", "SmnRowId": "1-DTGM-339", "SpCode": "74792", "SpRowId": "1-KX1-2851", "CertPercentage": null, "TechRowId": "1-6SPT-4" }, { "ServiceModelName": "ISL9 CM2250", "SmnRowId": "1-D1SH-61", "SpCode": "38307", "SpRowId": "1-KWZ-2451", "CertPercentage": null, "TechRowId": "1-6VVQ-37" }, { "ServiceModelName": "ISL9 CM2250", "SmnRowId": "1-D1SH-60", "SpCode": "23839", "SpRowId": "1-KX5-886", "CertPercentage": null, "TechRowId": "1-6WXK-41" }, { "ServiceModelName": "ISL9 CM2250", "SmnRowId": "1-B8IU-1387", "SpCode": "29170", "SpRowId": "1-KX3-1576", "CertPercentage": null, "TechRowId": "1-6YD6-14" }, { "ServiceModelName": "ISL9 CM2250", "SmnRowId": "1-D1SH-51", "SpCode": "50060", "SpRowId": "1-1KU3-1", "CertPercentage": null, "TechRowId": "1-756L-18" }, { "ServiceModelName": "ISL9 CM2250", "SmnRowId": "1-D1SH-59", "SpCode": "84376", "SpRowId": "1-307T-4", "CertPercentage": null, "TechRowId": "1-77OG-68" }, { "ServiceModelName": "ISL9 CM2250", "SmnRowId": "1-D1SH-54", "SpCode": "02862", "SpRowId": "1-KX5-24", "CertPercentage": null, "TechRowId": "1-A5RY-131" }, { "ServiceModelName": "ISL9 CM2250", "SmnRowId": "1-B8H9-356", "SpCode": "10992", "SpRowId": "1-KX5-112", "CertPercentage": null, "TechRowId": "1-A5RY-21" }, { "ServiceModelName": "B6.7 CM2350 B136C", "SmnRowId": "1-DTGM-301", "SpCode": "02027", "SpRowId": "1-KX1-10", "CertPercentage": null, "TechRowId": "1-A5RY-304" }, { "ServiceModelName": "L9 CM2350 L120C", "SmnRowId": "1-DTGM-300", "SpCode": "02027", "SpRowId": "1-KX1-10", "CertPercentage": null, "TechRowId": "1-A5RY-304" }, { "ServiceModelName": "B6.7 CM2350 B136C", "SmnRowId": "1-DTGM-315", "SpCode": "05085", "SpRowId": "1-KX3-54", "CertPercentage": null, "TechRowId": "1-A5RY-83" }, { "ServiceModelName": "L9 CM2350 L120C", "SmnRowId": "1-DTGM-314", "SpCode": "05085", "SpRowId": "1-KX3-54", "CertPercentage": null, "TechRowId": "1-A5RY-83" }, { "ServiceModelName": "B6.7 CM2350 B136C", "SmnRowId": "1-DTGM-297", "SpCode": "56334", "SpRowId": "1-KWZ-2658", "CertPercentage": null, "TechRowId": "1-A5S7-1229" }, { "ServiceModelName": "L9 CM2350 L120C", "SmnRowId": "1-DTGM-296", "SpCode": "56334", "SpRowId": "1-KWZ-2658", "CertPercentage": null, "TechRowId": "1-A5S7-1229" }, { "ServiceModelName": "QSX15 CM2350 X105", "SmnRowId": "1-CWNC-3", "SpCode": "02170", "SpRowId": "1-KX3-16", "CertPercentage": null, "TechRowId": "1-A5S7-1237" }, { "ServiceModelName": "B6.7 CM2350 B136C", "SmnRowId": "1-DTGM-295", "SpCode": "03050", "SpRowId": "1-KX9-33", "CertPercentage": null, "TechRowId": "1-A5S7-1260" }, { "ServiceModelName": "ISL9 CM2250", "SmnRowId": "1-D1SH-33", "SpCode": "99002", "SpRowId": "1-KXB-2814", "CertPercentage": null, "TechRowId": "1-A5S7-1339" }, { "ServiceModelName": "B6.7 CM2350 B136C", "SmnRowId": "1-DTGM-387", "SpCode": "00314", "SpRowId": "1-KX3-3", "CertPercentage": null, "TechRowId": "1-A5S7-1342" }, { "ServiceModelName": "L9 CM2350 L120C", "SmnRowId": "1-DTGM-386", "SpCode": "00314", "SpRowId": "1-KX3-3", "CertPercentage": null, "TechRowId": "1-A5S7-1342" }, { "ServiceModelName": "ISL9 CM2250", "SmnRowId": "1-D1SH-96", "SpCode": "87260", "SpRowId": "1-8IQ5-2", "CertPercentage": null, "TechRowId": "1-A5S7-1372" }, { "ServiceModelName": "ISL9 CM2250", "SmnRowId": "1-D1SH-121", "SpCode": "37223", "SpRowId": "1-KWZ-2372", "CertPercentage": null, "TechRowId": "1-A5S7-1713" }, { "ServiceModelName": "B6.7 CM2350 B136C", "SmnRowId": "1-DTGM-415", "SpCode": "02002", "SpRowId": "1-KX7-4", "CertPercentage": null, "TechRowId": "1-A5S7-216" }, { "ServiceModelName": "L9 CM2350 L120C", "SmnRowId": "1-DTGM-414", "SpCode": "02002", "SpRowId": "1-KX7-4", "CertPercentage": null, "TechRowId": "1-A5S7-216" }, { "ServiceModelName": "ISL9 CM2250", "SmnRowId": "1-D1SH-30", "SpCode": "66679", "SpRowId": "1-9BMD-1", "CertPercentage": null, "TechRowId": "1-A5S7-51" }, { "ServiceModelName": "B6.7 CM2350 B136C", "SmnRowId": "1-DTGM-306", "SpCode": "04972", "SpRowId": "1-KWZ-17", "CertPercentage": null, "TechRowId": "1-A5S7-722" }, { "ServiceModelName": "L9 CM2350 L120C", "SmnRowId": "1-DTGM-305", "SpCode": "04972", "SpRowId": "1-KWZ-17", "CertPercentage": null, "TechRowId": "1-A5S7-722" }, { "ServiceModelName": "ISL9 CM2250", "SmnRowId": "1-D1SH-101", "SpCode": "29290", "SpRowId": "1-KX3-1696", "CertPercentage": null, "TechRowId": "1-A5SG-108" }, { "ServiceModelName": "ISL9 CM2250", "SmnRowId": "1-D1SH-34", "SpCode": "87260", "SpRowId": "1-8IQ5-2", "CertPercentage": null, "TechRowId": "1-A5SG-1415" }, { "ServiceModelName": "ISL9 CM2250", "SmnRowId": "1-D1SH-31", "SpCode": "87258", "SpRowId": "1-8CS9-1", "CertPercentage": null, "TechRowId": "1-A5SG-1961" }, { "ServiceModelName": "ISL9 CM2250", "SmnRowId": "1-D1SH-43", "SpCode": "85207", "SpRowId": "1-6M7A-57", "CertPercentage": null, "TechRowId": "1-A5SG-2039" }, { "ServiceModelName": "ISL9 CM2250", "SmnRowId": "1-D1SH-41", "SpCode": "87095", "SpRowId": "1-4H8U-3936", "CertPercentage": null, "TechRowId": "1-A5SG-558" }, { "ServiceModelName": "ISL9 CM2250", "SmnRowId": "1-D1SH-32", "SpCode": "87048", "SpRowId": "1-4H8U-3889", "CertPercentage": null, "TechRowId": "1-A5SG-721" }, { "ServiceModelName": "ISL9 CM2250", "SmnRowId": "1-D1SH-28", "SpCode": "87127", "SpRowId": "1-7U3Q-26", "CertPercentage": null, "TechRowId": "1-A5SJ-1000" }, { "ServiceModelName": "ISL9 CM2250", "SmnRowId": "1-D1SH-29", "SpCode": "87134", "SpRowId": "1-7U3Q-11", "CertPercentage": null, "TechRowId": "1-A5SJ-1001" }, { "ServiceModelName": "ISL9 CM2250", "SmnRowId": "1-D1SH-100", "SpCode": "29307", "SpRowId": "1-KX3-1713", "CertPercentage": null, "TechRowId": "1-A5SJ-115" }, { "ServiceModelName": "ISL9 CM2250", "SmnRowId": "1-D1SH-70", "SpCode": "87100", "SpRowId": "1-4H8U-3941", "CertPercentage": null, "TechRowId": "1-A5SJ-1998" }, { "ServiceModelName": "ISL9 CM2250", "SmnRowId": "1-D1SH-77", "SpCode": "50148", "SpRowId": "1-1SO4-18", "CertPercentage": null, "TechRowId": "1-A5SJ-3487" }, { "ServiceModelName": "ISL9 CM2250", "SmnRowId": "1-D1SH-73", "SpCode": "66734", "SpRowId": "1-9XWJ-1", "CertPercentage": null, "TechRowId": "1-A5SJ-536" }, { "ServiceModelName": "ISL9 CM2250", "SmnRowId": "1-D1SH-80", "SpCode": "38102", "SpRowId": "1-KX3-2730", "CertPercentage": null, "TechRowId": "1-A5TF-4117" }, { "ServiceModelName": "ISL9 CM2250", "SmnRowId": "1-D1SH-40", "SpCode": "87120", "SpRowId": "1-7U3Q-18", "CertPercentage": null, "TechRowId": "1-A5TI-2235" }, { "ServiceModelName": "ISL9 CM2250", "SmnRowId": "1-D1SH-37", "SpCode": "66679", "SpRowId": "1-9BMD-1", "CertPercentage": null, "TechRowId": "1-A5TI-2688" }, { "ServiceModelName": "ISL9 CM2250", "SmnRowId": "1-D1SH-58", "SpCode": "29122", "SpRowId": "1-KX3-1528", "CertPercentage": null, "TechRowId": "1-A5TI-3033" }, { "ServiceModelName": "ISL9 CM2250", "SmnRowId": "1-D1SH-69", "SpCode": "84987", "SpRowId": "1-4UQP-1", "CertPercentage": null, "TechRowId": "1-A5TI-364" }, { "ServiceModelName": "ISL9 CM2250", "SmnRowId": "1-D1SH-79", "SpCode": "10085", "SpRowId": "1-KWZ-39", "CertPercentage": null, "TechRowId": "1-A5TI-6274" }, { "ServiceModelName": "ISL9 CM2250", "SmnRowId": "1-D1SH-118", "SpCode": "87112", "SpRowId": "1-7U3Q-14", "CertPercentage": null, "TechRowId": "1-A5TL-3621" }, { "ServiceModelName": "ISL9 CM2250", "SmnRowId": "1-D1SH-48", "SpCode": "87133", "SpRowId": "1-7U3Q-15", "CertPercentage": null, "TechRowId": "1-A5TL-4701" }, { "ServiceModelName": "ISL9 CM2250", "SmnRowId": "1-D1SH-39", "SpCode": "02670", "SpRowId": "1-KX3-27", "CertPercentage": null, "TechRowId": "1-A5TL-5765" }, { "ServiceModelName": "ISL9 CM2250", "SmnRowId": "1-D1SH-36", "SpCode": "84722", "SpRowId": "1-49U0-46", "CertPercentage": null, "TechRowId": "1-A5TU-2508" }, { "ServiceModelName": "ISL9 CM2250", "SmnRowId": "1-D1SH-78", "SpCode": "87126", "SpRowId": "1-7U3Q-5", "CertPercentage": null, "TechRowId": "1-A5TU-3894" }, { "ServiceModelName": "ISL9 CM2250", "SmnRowId": "1-D1SH-83", "SpCode": "02002", "SpRowId": "1-KX7-4", "CertPercentage": null, "TechRowId": "1-A5TU-4454" }, { "ServiceModelName": "ISL9 CM2250", "SmnRowId": "1-D1SH-104", "SpCode": "87134", "SpRowId": "1-7U3Q-11", "CertPercentage": null, "TechRowId": "1-A5TU-6737" }, { "ServiceModelName": "ISL9 CM2250", "SmnRowId": "1-D1SH-102", "SpCode": "87112", "SpRowId": "1-7U3Q-14", "CertPercentage": null, "TechRowId": "1-A5TU-7565" }, { "ServiceModelName": "ISL9 CM2250", "SmnRowId": "1-D1SH-68", "SpCode": "87202", "SpRowId": "1-80X2-2", "CertPercentage": null, "TechRowId": "1-A5TX-1168" }, { "ServiceModelName": "ISL9 CM2250", "SmnRowId": "1-D1SH-74", "SpCode": "87075", "SpRowId": "1-4H8U-3916", "CertPercentage": null, "TechRowId": "1-A5TX-3967" }, { "ServiceModelName": "ISL9 CM2250", "SmnRowId": "1-D1SH-95", "SpCode": "87100", "SpRowId": "1-4H8U-3941", "CertPercentage": null, "TechRowId": "1-A5TX-5257" }, { "ServiceModelName": "ISL9 CM2250", "SmnRowId": "1-D1SH-120", "SpCode": "84735", "SpRowId": "1-49U0-50", "CertPercentage": null, "TechRowId": "1-A5TX-5323" }, { "ServiceModelName": "ISL9 CM2250", "SmnRowId": "1-D1SH-71", "SpCode": "28700", "SpRowId": "1-KX3-1106", "CertPercentage": null, "TechRowId": "1-A5TX-7015" }, { "ServiceModelName": "ISL9 CM2250", "SmnRowId": "1-D1SH-88", "SpCode": "27967", "SpRowId": "1-KX3-982", "CertPercentage": null, "TechRowId": "1-A5TX-824" }, { "ServiceModelName": "ISL9 CM2250", "SmnRowId": "1-D1SH-62", "SpCode": "87120", "SpRowId": "1-7U3Q-18", "CertPercentage": null, "TechRowId": "1-A5U0-1040" }, { "ServiceModelName": "ISL9 CM2250", "SmnRowId": "1-D1SH-86", "SpCode": "28962", "SpRowId": "1-KX3-1368", "CertPercentage": null, "TechRowId": "1-A5U0-1333" }, { "ServiceModelName": "ISL9 CM2250", "SmnRowId": "1-D1SH-89", "SpCode": "29121", "SpRowId": "1-KX3-1527", "CertPercentage": null, "TechRowId": "1-A5U0-1785" }, { "ServiceModelName": "ISL9 CM2250", "SmnRowId": "1-D1SH-63", "SpCode": "56807", "SpRowId": "1-KXB-1543", "CertPercentage": null, "TechRowId": "1-A5U0-300" }, { "ServiceModelName": "ISL9 CM2250", "SmnRowId": "1-D1SH-64", "SpCode": "87127", "SpRowId": "1-7U3Q-26", "CertPercentage": null, "TechRowId": "1-A5U0-3433" }, { "ServiceModelName": "ISL9 CM2250", "SmnRowId": "1-D1SH-81", "SpCode": "87102", "SpRowId": "1-4H8U-3943", "CertPercentage": null, "TechRowId": "1-A5U0-4364" }, { "ServiceModelName": "ISL9 CM2250", "SmnRowId": "1-D1SH-66", "SpCode": "84818", "SpRowId": "1-4FNU-9", "CertPercentage": null, "TechRowId": "1-A5U0-4774" }, { "ServiceModelName": "ISL9 CM2250", "SmnRowId": "1-D1SH-67", "SpCode": "87122", "SpRowId": "1-7U3Q-27", "CertPercentage": null, "TechRowId": "1-A5U0-4787" }, { "ServiceModelName": "ISL9 CM2250", "SmnRowId": "1-D1SH-91", "SpCode": "87133", "SpRowId": "1-7U3Q-15", "CertPercentage": null, "TechRowId": "1-A5U0-6288" }, { "ServiceModelName": "ISL9 CM2250", "SmnRowId": "1-D1SH-92", "SpCode": "87131", "SpRowId": "1-7U3Q-12", "CertPercentage": null, "TechRowId": "1-A5U0-6618" }, { "ServiceModelName": "ISL9 CM2250", "SmnRowId": "1-D1SH-65", "SpCode": "87100", "SpRowId": "1-4H8U-3941", "CertPercentage": null, "TechRowId": "1-A5U3-1302" } ] } }';

	    List<Account> AccountLst = new  List<Account>();
	    	Account acc = new Account();
            acc.name='BEAM MACK SALES & SERVICE, INC. DBA BUFFALO TRUCK CENTER INC. ';
            acc.CSS_DistributorCode__c='02850';
            acc.IAM_Service_Provider_Code__c='10755';
            acc.CSS_DBCode__c = '02026';
            acc.CSS_DealerCode__c = '10755';
            acc.Type='Dealer Account';
            acc.CMI_Account_Status__c = 'Active';
            AccountLst.add(acc);
            insert AccountLst;
            
	    CG_WPR_SBL_SPTechnicianSMN obj = CG_WPR_SBL_SPTechnicianSMN.parse(json);
        boolean spa=CSS_FN_SIEBEL.insertSPTechnicianSMNData(obj);
    
   }

}