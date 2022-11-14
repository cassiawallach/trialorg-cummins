/**********************************************************************
Name: CSS_WS_SBL_Test
Copyright © 2016  Cummins
======================================================
======================================================
Purpose:    Test Class for CSS_WS_SBL
                                                          
======================================================
======================================================
History                                                            
-------                                                            
VERSION       AUTHOR                   DATE          DETAIL                                 
1.0       Nisha Mendiratta          04/10/2016    INITIAL DEVELOPMENT 
2.0       Venkat                    05/10/2016    INITIAL dEVELOPMENT

***********************************************************************/


@isTest
public class CSS_WS_SBL_Test{
    
     // method to Test getAllSRTDetails
    static TestMethod void getTechInfoService() {
        CSS_getTechInfoReqJ2A techinforeq = new CSS_getTechInfoReqJ2A();
        CSS_getTechInfoResponseJ2A techinfores = new CSS_getTechInfoResponseJ2A();
        // Set mock callout class 
        Blob key = Blob.valueOf('12345678901234567890123456789012');
        string algo = 'AES256';
        
        CSS_Integration_Details__c inte = new CSS_Integration_Details__c();
        inte.Name = 'CSS_SBL_TECHINFO';
        inte.Username__c = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('test')));
        inte.Passcode__c = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('test')));
        inte.Key__c = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('1234')));
        inte.ApplicationName__c = 'CSS_SBL_TECHINFO';
        inte.End_Point__c = 'abc.com';
        inte.IsActive__c = true;
        inte.Method_Type__c = 'GET';
        insert inte;
        CSS_getConnnectionDetails.getConnection('CSS_SBL_TECHINFO');   
       
        Test.setMock(HttpCalloutMock.class, new CSS_MockHttpResponseGenerator());
        Test.startTest();
       techinfores = CSS_WS_SBL.getTechInfo(techinforeq);
        Test.stopTest();
 
    }        
    // method to Test basic Coverage
    static TestMethod void getBasicCoverageService() {
        CSS_getBasicCoverageReqJ2A coveragereq = new CSS_getBasicCoverageReqJ2A();
        CSS_getBasicCoverageReqJ2A.DataArea reqDA = new CSS_getBasicCoverageReqJ2A.DataArea();
        CSS_getBasicCoverageResponseJ2A coverageresp = new CSS_getBasicCoverageResponseJ2A();
        reqDA.ESN = '79464646';
        reqDA.Region = 'NORTH AMERICA';
        reqDA.Territory = 'UNITED STATES';
        reqDA.EngineApplicationCode = 'UKEA';//'130';// Please call CSS_Utility.getCodes() 
        Date d = system.today();
        string warantySDate = DateTime.newInstance(d.year(),d.month(),d.day()).format('MM/d/YYYY');
        reqDA.WarrantyStartDate = warantySDate;//'5/1/2010';//String.Valueof(workJob.Warranty_Start_Date__c);
        CSS_Job_Order__c JobOrder = new CSS_Job_Order__c();
        JobOrder = CSS_TestData.createJobOrder(true);
        reqDA.JobId = JobOrder.id;
        coveragereq.DataArea = reqDA;
        // Set mock callout class 
        Blob key = Blob.valueOf('12345678901234567890123456789012');
        string algo = 'AES256';
        
        CSS_Integration_Details__c inte = new CSS_Integration_Details__c();
        inte.Name = 'CSS_SBL_BCOVER';
        inte.Username__c = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('test')));
        inte.Passcode__c = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('test')));
        inte.Key__c = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('1234')));
        inte.ApplicationName__c = 'CSS_SBL_BCOVER';
        inte.End_Point__c = 'abc.com';
        inte.IsActive__c = true;
        inte.Method_Type__c = 'GET';
        insert inte;
        CSS_getConnnectionDetails.getConnection('CSS_SBL_BCOVER');   
       // CG_OP_OAGWrapper accessTokenOPWrap =  CG_WS_Mule.getAccessToken(CSS_getConnnectionDetails.getConnection('CSS_SBL_BCOVER').AuthEnv__c,'CSS_SBL_BCOVER');//Added By Prabhakar OAG to Mule 19/05/2020
   
        Test.setMock(HttpCalloutMock.class, new CSS_SBLgetBasicCoverageMockup_Test());
        Test.startTest();
        coverageresp = CSS_WS_SBL.getBasicCoverage(coveragereq);
        Test.stopTest();
        
    }
    static TestMethod void getBasicCoverageServiceNew() {
        CSS_getBasicCoverageReqJ2A coveragereq = new CSS_getBasicCoverageReqJ2A();
        CSS_getBasicCoverageReqJ2A.DataArea reqDA = new CSS_getBasicCoverageReqJ2A.DataArea();
        reqDA.ESN = '79384192';
        reqDA.EngineApplicationCode = '130';
        reqDA.Region = 'NORTH AMERICA';
        //reqDA.ESN = '79384192';
        reqDA.Territory = '100';
        reqDA.WarrantyStartDate = '22-Jan-20';
        CSS_getBasicCoverageResponseJ2A coverageresp = new CSS_getBasicCoverageResponseJ2A();
        CSS_Job_Order__c JobOrder = new CSS_Job_Order__c();
        JobOrder = CSS_TestData.createJobOrder(true);
        reqDA.JobId = JobOrder.id;
        coveragereq.DataArea = reqDA;
        // Set mock callout class   
        
        Blob key = Blob.valueOf('12345678901234567890123456789012');
        string algo = 'AES256';
        
        CSS_Integration_Details__c inte = new CSS_Integration_Details__c();
        inte.Name = 'CSS_SBL_BCOVER';
        inte.Username__c = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('test')));
        inte.Passcode__c = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('test')));
        inte.Key__c = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('1234')));
        inte.ApplicationName__c = 'CSS_SBL_BCOVER';
        inte.End_Point__c = 'abc.com';
        inte.IsActive__c = true;
        inte.Method_Type__c = 'GET';
        insert inte;
        CSS_getConnnectionDetails.getConnection('CSS_SBL_BCOVER');
       
        Test.setMock(HttpCalloutMock.class, new CSS_SBLgetBasicCoverageMockup_Test());
        Test.startTest();
       coverageresp = CSS_WS_SBL.getBasicCoverage(coveragereq);
        CSS_WS_SBL.getClaimsBasicCoverage(coveragereq,true);
        
        Test.stopTest();
 
    }
    static TestMethod void getBasicCoverageClaimServiceNew() {
        CSS_getBasicCoverageReqJ2A coveragereq = new CSS_getBasicCoverageReqJ2A();
        CSS_getBasicCoverageReqJ2A.DataArea reqDA = new CSS_getBasicCoverageReqJ2A.DataArea();
        reqDA.ESN = '79384192';
        CSS_getBasicCoverageResponseJ2A coverageresp = new CSS_getBasicCoverageResponseJ2A();
        CSS_Claims__c claim = new CSS_Claims__c();
        claim.AccessCode__c = 'test';
        insert claim;
        CSS_PSN__c psn = new CSS_PSN__c();
        psn = CSS_TestData.createpsn(true, claim.id);
        reqDA.JobId = psn.id;
        coveragereq.DataArea = reqDA;
        // Set mock callout class    
       
        Test.setMock(HttpCalloutMock.class, new CSS_SBLgetBasicCoverageMockup_Test());
        Test.startTest();
        CSS_WS_SBL.getBasicCoverage(coveragereq);
        coverageresp = CSS_WS_SBL.getClaimsBasicCoverage(coveragereq,true);
        
        Test.stopTest();
 
    }
    // method to Test Engine Data
    static TestMethod void getBasicEngineData() {
        CSS_getEngineDataReqJ2A enginereq = new CSS_getEngineDataReqJ2A();
        
        CSS_getEngineDataReqJ2A.DataArea Req = new CSS_getEngineDataReqJ2A.DataArea();
        Req.ESN='79384192';
        enginereq.DataArea = Req;
        
        CSS_getEngineDataResponseJ2A engineresp = new CSS_getEngineDataResponseJ2A();
        // Set mock callout class 
        Blob key = Blob.valueOf('12345678901234567890123456789012');
        string algo = 'AES256';
        
        CSS_Integration_Details__c inte = new CSS_Integration_Details__c();
        inte.Name = 'CSS_SBL_ENGDATA';
        inte.Username__c = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('test')));
        inte.Passcode__c = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('test')));
        inte.Key__c = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('1234')));
        inte.ApplicationName__c = 'CSS_SBL_ENGDATA';
        inte.End_Point__c = 'abc.com';
        inte.IsActive__c = true;
        inte.Method_Type__c = 'GET';
        insert inte;
        CSS_getConnnectionDetails.getConnection('CSS_SBL_ENGDATA');   
       
        Test.setMock(HttpCalloutMock.class, new CSS_MockHttpResponseGenerator());
        Test.startTest();
        engineresp = CSS_WS_SBL.getEngineData(enginereq);
        Test.stopTest();
  }        
    // method to Test DetailCoverage
    static TestMethod void getBasicDetailCoverage() {
        CSS_getDetailCoverageReqJ2A detailcoveragereq = new CSS_getDetailCoverageReqJ2A();
         CSS_getDetailCoveResponseJ2A detailcoverageresp = new  CSS_getDetailCoveResponseJ2A();
        // Set mock callout class    
       CSS_getDetailCoverageReqJ2A.DataArea Req = new CSS_getDetailCoverageReqJ2A.DataArea();
        Req.ESN = '79464646';
        Req.EngineApplicationCode = '130';
        //Req.Region = 'MEXICO';
        //Req.Territory = 'MEXICO';
        Req.WarrantyStartDate = '10/14/2013';
        Req.NewPartsWrntyFlg = 'Y';
        detailcoveragereq.DataArea = Req;
        Test.setMock(HttpCalloutMock.class, new CSS_MockHttpResponseGenerator());
        Test.startTest();
       detailcoverageresp = CSS_WS_SBL.getDetailCoverage(detailcoveragereq);
        Test.stopTest();
  }        
    
    static TestMethod void prepareReqJSONForApplCategoryList(){
        String senderID;
        String messageID;
        String serviceName = 'GetComplaintsList';
        Datetime currentDate = System.now();
        String currDate = currentDate.format('YYYY-MM-dd') +'T00:00:00';
        CSS_WPR_SBL_ApplnCategoryListReqJSON ApplnCatListReqJSON = new CSS_WPR_SBL_ApplnCategoryListReqJSON();
        ApplnCatListReqJSON =  CSS_WS_SBL.prepareReqJSONForApplCategoryList(senderID, serviceName, messageID, currDate);
    }
     @isTest static void testAccessToken(){
        Test.setMock(HttpCalloutMock.class, new CSS_AccessToken_SRT_Test());
        CSS_WS_SBL.getAccessTokenOfOAGOAuth();
    }
    static TestMethod void passCatchBlocks(){
        CSS_WS_SBL.getTechInfo(null);
        CSS_WS_SBL.getBasicCoverage(null);
        CSS_WS_SBL.getClaimsBasicCoverage(null,null);
        CSS_WS_SBL.getEngineData(null);
        CSS_WS_SBL.getDetailCoverage(null);
        CSS_WS_SBL.prepareReqJSONForApplCategoryList(null,null,null,null);
        CSS_WS_SBL.getAccessTokenOfOAGOAuth();
    }
    
}