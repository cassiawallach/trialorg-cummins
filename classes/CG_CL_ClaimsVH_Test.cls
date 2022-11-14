/**********************************************************************
Name:CG_CL_ClaimsVH_Test
Copyright Â© 2018  Cummins
===============================================================
===============================================================
Purpose:                                                            
-------  
this is test class for CG_CL_ClaimsVH Controller.
===============================================================
===============================================================
History      

-------                                                            
VERSION    AUTHOR                 DATE                DETAIL                                 
1.0 -      Rajasekhar Hindupur     1/29/2018           INITIAL DEVELOPMENT                    
***********************************************************************/

@isTest
// public class CG_CL_ClaimsVH_Test {
global class CG_CL_ClaimsVH_Test {
    public static Testmethod void CG_CL_ClaimsVH_Method(){
        test.startTest();
        CSS_Claims__c testclaimsRec = new CSS_Claims__c();
        CSS_PSN__c testpsnNewRec = new CSS_PSN__c();
        
        testclaimsRec.Customer_Name__c='TestCustomer';
        testclaimsRec.Customer_Code__c = '1234';
        testclaimsRec.Contact_Last_Name__c = 'T';
        testclaimsRec.Address__c = 'T';
        testclaimsRec.Customer_Contact_Phone__c = null;
        testclaimsRec.Email_Address__c = 'rp@sct.com';

        
        insert testclaimsRec;
        testpsnNewRec.psn__c = '79464646';
        testpsnNewRec.Primary__C = true;
        testpsnNewRec.failure_Date__c = date.today() - 20;
        testpsnNewRec.css_claims__C = testclaimsRec.id;
        insert testpsnNewRec;
        
        
        string cId;
        CSS_Job_Order__c JO = CSS_TestData.createJobOrder(true);
        cId=ApexPages.CurrentPage().getParameters().get('id');
        PageReference pageRef = Page.CG_ClaimsVH;
        pageRef.getParameters().put('id',testclaimsRec.id);
        Test.setCurrentPage(pageRef); 
        CG_CL_ClaimsVH claimsvh = new CG_CL_ClaimsVH();
        claimsvh.nvClaimsIntake();
        claimsvh.nvClaimsCC();
        claimsvh.nvClaimsWC();
        claimsvh.nvClaimsFC();
        claimsvh.nvClaimsVS();
        claimsvh.nvClaimsSRTs();
        claimsvh.nvClaimsPOC();
        claimsvh.nvClaimsJobNotes();
        // String id = ApexPages.currentPage().getParameters().get('id');
        claimsvh.pgSave();
        claimsvh.nvClaimsVH();
        claimsvh.nvClaimsPSN();
        claimsvh.CampaignsWSCall();
        test.stopTest();
    }
     public static Testmethod void CG_CL_ClaimsVH_Method_new(){
        test.startTest();
        CSS_Claims__c testclaimsRec = new CSS_Claims__c();
        CSS_PSN__c testpsnNewRec = new CSS_PSN__c();
        
        testclaimsRec.Customer_Name__c='TestCustomer';
        testclaimsRec.Customer_Code__c = '1234';
        testclaimsRec.Contact_Last_Name__c = 'T';
        testclaimsRec.Address__c = 'T';
        testclaimsRec.Customer_Contact_Phone__c = null;
        testclaimsRec.Email_Address__c = 'rp@sct.com';
        testclaimsRec.Status__c = 'Submitted';
         testclaimsRec.Pending_Authorization__c ='Not Authorized';
        testclaimsRec.TSR1__c = '1234';
        testclaimsRec.TSR2__c = '1234';
        testclaimsRec.TSR3__c = '1234';
        testclaimsRec.TSR4__c = '1234';
        testclaimsRec.TSR5__c = '1234';
        testclaimsRec.TSR6__c = '1234';
        testclaimsRec.TSR7__c = '1234';
        testclaimsRec.TSR8__c = '1234';
        testclaimsRec.TSR9__c = '1234';
        testclaimsRec.TSR10__c = '1234';
        testclaimsRec.Country__c = '1234';
        testclaimsRec.State__c = '1234';
        testclaimsRec.ZipCode__c = '12345-1234';
        testclaimsRec.FieldActionWebServiceResult__c='Error';
        
        insert testclaimsRec;
        testpsnNewRec.psn__c = '79464646';
        testpsnNewRec.Primary__C = true;
        testpsnNewRec.failure_Date__c = date.today() - 20;
        testpsnNewRec.css_claims__C = testclaimsRec.id;
        insert testpsnNewRec;
        
        
        string cId;
        CSS_Job_Order__c JO = CSS_TestData.createJobOrder(true);
        cId=ApexPages.CurrentPage().getParameters().get('id');
        PageReference pageRef = Page.CG_ClaimsVH;
        pageRef.getParameters().put('id',testclaimsRec.id);
        Test.setCurrentPage(pageRef); 
        CG_CL_ClaimsVH claimsvh = new CG_CL_ClaimsVH();
      //  claimsvh.nvClaimsIntake();
        claimsvh.nvClaimsCC();
      //  claimsvh.nvClaimsWC();
        claimsvh.nvClaimsFC();
      //  claimsvh.nvClaimsVS();
        claimsvh.nvClaimsSRTs();
        claimsvh.nvClaimsPOC();
      //  claimsvh.nvClaimsJobNotes();
        // String id = ApexPages.currentPage().getParameters().get('id');
     //   claimsvh.pgSave();
      //  claimsvh.nvClaimsVH();
        claimsvh.nvClaimsPSN();
        claimsvh.CampaignsWSCall();
        test.stopTest();
    }
    static testmethod void getWarrantyDetailCoverageTestMethod(){
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
    public static Testmethod void CG_CL_ClaimsVH_Method_newNew(){
        test.startTest();
        CSS_Claims__c testclaimsRec = new CSS_Claims__c();
        CSS_PSN__c testpsnNewRec = new CSS_PSN__c();
        
        testclaimsRec.Customer_Name__c='TestCustomer';
        testclaimsRec.Customer_Code__c = '1234';
        testclaimsRec.Contact_Last_Name__c = 'T';
        testclaimsRec.Address__c = 'T';
        testclaimsRec.Customer_Contact_Phone__c = null;
        testclaimsRec.Email_Address__c = 'rp@sct.com';
        testclaimsRec.Status__c = 'Submitted';
         testclaimsRec.Pending_Authorization__c ='Not Authorized';
        testclaimsRec.TSR1__c = '1234';
        testclaimsRec.TSR2__c = '1234';
        testclaimsRec.TSR3__c = '1234';
        testclaimsRec.TSR4__c = '1234';
        testclaimsRec.TSR5__c = '1234';
        testclaimsRec.TSR6__c = '1234';
        testclaimsRec.TSR7__c = '1234';
        testclaimsRec.TSR8__c = '1234';
        testclaimsRec.TSR9__c = '1234';
        testclaimsRec.TSR10__c = '1234';
        testclaimsRec.Country__c = '1234';
        testclaimsRec.State__c = '1234';
        testclaimsRec.ZipCode__c = '12345-1234';
        testclaimsRec.FieldActionWebServiceResult__c='Error';
        
        insert testclaimsRec;
        testpsnNewRec.psn__c = '79464646';
        testpsnNewRec.Primary__C = true;
        testpsnNewRec.failure_Date__c = date.today() - 20;
        testpsnNewRec.css_claims__C = testclaimsRec.id;
        insert testpsnNewRec;
        
        
        string cId;
        CSS_Job_Order__c JO = CSS_TestData.createJobOrder(true);
        cId=ApexPages.CurrentPage().getParameters().get('id');
        PageReference pageRef = Page.CG_ClaimsVH;
        pageRef.getParameters().put('id',testclaimsRec.id);
        Test.setCurrentPage(pageRef); 
        CG_CL_ClaimsVH claimsvh = new CG_CL_ClaimsVH();
      	 Test.setMock(HttpCalloutMock.class, new SingleRequestMockComponent());
         String id = ApexPages.currentPage().getParameters().get('id');
         Test.setMock(HttpCalloutMock.class, new CG_OP_CampaignsresJSONMOck_Test());
        	CSS_Integration_Details__c conDetails = new CSS_Integration_Details__c();
        conDetails.Name = 'GetCampaign';
        conDetails.AuthEnv__c = 'OAGOAUTH';
        conDetails.ApplicationName__c = 'GetCampaign';
        conDetails.End_Point__c = 'Test';
        conDetails.Method_Type__c = 'POST';
        conDetails.Timeout__c = 2.0;
        insert conDetails;
         claimsvh.CampaignsWSCall();
         test.stopTest();
    }
    global class SingleRequestMockComponent implements HttpCalloutMock {
        
        global HTTPResponse respond(HTTPRequest req) {
            HttpResponse resp = new HttpResponse();
            resp.setStatusCode(200);
             resp.setBody('{ "DataArea": { "Details": [ { "CampaignDesc": "TRP FOR MCRS FUEL PUMP FAILURES TO INSTALL EPLV SYSTEM ON ENGINES", "CampaignEndDate": "2017-12-31", "CampaignStartDate": "2016-08-23", "SrtList": [ { "SrtCode": "00-901-00", "SrtDescription": "Administrative Time - Open and Close Repair Order (Shop Repairs)" } ], "FailCode": "WFHA", "FailMode": "SR", "InShopSrtLimitFlag": "N", "Status": "Approved", "MultipleTimes": "N", "BusinessUnit": "CMI", "CampaignType": "TRP", "CompleteIndicator": "N", "PartList": [ { "PartQuantity": 1, "PartNumber": 540571400, "PartDescription": "KIT,SERVICE" } ], "CampaignNumber": "1820" } ] }, "Header": { "ReturnCodeDescription": "ReturnCodeDescription", "Status": "Success" } }');
               system.debug('inside Mock' + resp);
            return resp;
        }
    }
    public static Testmethod void CG_CL_ClaimsVH_Method111(){
        test.startTest();
        CSS_Claims__c testclaimsRec = new CSS_Claims__c();
        CSS_PSN__c testpsnNewRec = new CSS_PSN__c();
         CSS_Claims__c testclaimsRec1 = new CSS_Claims__c();
        testclaimsRec.Customer_Name__c='TestCustomer';
        testclaimsRec.Customer_Code__c = '1234';
        testclaimsRec.Contact_Last_Name__c = 'T';
        testclaimsRec.Address__c = 'T';
        testclaimsRec.Customer_Contact_Phone__c = null;
        testclaimsRec.Email_Address__c = 'rp@sct.com';
        testclaimsRec.Status__c = 'Draft';
        testclaimsRec.TSR1__c = '1234';
        testclaimsRec.TSR2__c = '1234';
        testclaimsRec.TSR3__c = '1234';
        testclaimsRec.TSR4__c = '1234';
        testclaimsRec.TSR5__c = '1234';
        testclaimsRec.TSR6__c = '1234';
        testclaimsRec.TSR7__c = '1234';
        testclaimsRec.TSR8__c = '1234';
        testclaimsRec.TSR9__c = '1234';
        testclaimsRec.TSR10__c = '1234';
        testclaimsRec.Country__c = '1234';
        testclaimsRec.State__c = '1234';
        testclaimsRec.ZipCode__c = '12345-1234';
        
        insert testclaimsRec;
        
         testclaimsRec1.Customer_Name__c='TestCustomer';
        testclaimsRec1.Customer_Code__c = '1234';
        testclaimsRec1.Contact_Last_Name__c = 'T';
        testclaimsRec1.Address__c = 'T';
        testclaimsRec1.Customer_Contact_Phone__c = null;
        testclaimsRec1.Email_Address__c = 'rp@sct.com';
        testclaimsRec1.Status__c = 'Draft';
        testclaimsRec1.TSR1__c = '1234';
        testclaimsRec1.TSR2__c = '1234';
        testclaimsRec1.TSR3__c = '1234';
        testclaimsRec1.TSR4__c = '1234';
        testclaimsRec1.TSR5__c = '1234';
        testclaimsRec1.TSR6__c = '1234';
        testclaimsRec1.TSR7__c = '1234';
        testclaimsRec1.TSR8__c = '1234';
        testclaimsRec1.TSR9__c = '1234';
        testclaimsRec1.TSR10__c = '1234';
        testclaimsRec1.Country__c = '1234';
        testclaimsRec1.State__c = '1234';
        testclaimsRec1.ZipCode__c = '12345-1234';
        testclaimsRec1.Multi_PSN_Claim__c= true;
        insert testclaimsRec1; 
        testpsnNewRec.psn__c = '79464646';
        testpsnNewRec.Primary__C = true;
        testpsnNewRec.failure_Date__c = date.today() - 20;
        testpsnNewRec.css_claims__C = testclaimsRec.id;
        insert testpsnNewRec;
        CSS_Solution_Component__c solComRef = CSS_TestData.createSRT(false,null,null);
        solComRef.System_Code__c = 'Test';
        solComRef.CSS_Claims__c=testclaimsRec1.id;
        solComRef.Component_Code__c = 'Test';
        solComRef.Failure_Mode__c = 'Test';
        solComRef.Selected_Component__c =true;
        solComRef.AccountCodeType__c = 'Test-Test';
        solComRef.AccountCode_Call_Status__c = 'Failure';
        solComRef.Failure_Point__c=11.0;
        solComRef.Failure_Measure__c = null;
             //  solComRef.Failure_Date__c=date.parse('12-27-2018');
        solComRef.Failure_Date__c=date.today();
        solComRef.AccountCode__c = '';
        solComRef.AccountCodeEdit__c='test';
        solComRef.Type__c = 'Campaign';
        solComRef.Status__c='Approved';
        insert solComRef;
        string cId;
        CSS_Job_Order__c JO = CSS_TestData.createJobOrder(true);
        cId=ApexPages.CurrentPage().getParameters().get('id');
       /* PageReference pageRef = Page.CG_ClaimsVH;
        pageRef.getParameters().put('id',testclaimsRec.id);
        Test.setCurrentPage(pageRef); 
        CG_CL_ClaimsVH claimsvh = new CG_CL_ClaimsVH();
        claimsvh.nvClaimsIntake();
        claimsvh.nvClaimsCC();
        claimsvh.nvClaimsWC();
        claimsvh.nvClaimsFC();
        claimsvh.nvClaimsVS();
        claimsvh.nvClaimsSRTs();
        claimsvh.nvClaimsPOC();
        claimsvh.nvClaimsJobNotes();
        // String id = ApexPages.currentPage().getParameters().get('id');
        claimsvh.pgSave();
        claimsvh.nvClaimsVH();*/
        PageReference pageRef1 = Page.CG_ClaimsVH;
        pageRef1.getParameters().put('id',testclaimsRec1.id);
           Test.setCurrentPage(pageRef1); 
         CG_CL_ClaimsVH claimsvh1 = new CG_CL_ClaimsVH();
        claimsvh1.checkAccountCode=true;
        test.stopTest();
    }
    public static Testmethod void CG_CL_ClaimsVH_Method1(){
        test.startTest();
        CSS_Claims__c testclaimsRec = new CSS_Claims__c();
        CSS_PSN__c testpsnNewRec = new CSS_PSN__c();
         CSS_Claims__c testclaimsRec1 = new CSS_Claims__c();
        testclaimsRec.Customer_Name__c='TestCustomer';
        testclaimsRec.Customer_Code__c = '1234';
        testclaimsRec.Contact_Last_Name__c = 'T';
        testclaimsRec.Address__c = 'T';
        testclaimsRec.Customer_Contact_Phone__c = null;
        testclaimsRec.Email_Address__c = 'rp@sct.com';
        testclaimsRec.Status__c = 'Draft';
        testclaimsRec.TSR1__c = '1234';
        testclaimsRec.TSR2__c = '1234';
        testclaimsRec.TSR3__c = '1234';
        testclaimsRec.TSR4__c = '1234';
        testclaimsRec.TSR5__c = '1234';
        testclaimsRec.TSR6__c = '1234';
        testclaimsRec.TSR7__c = '1234';
        testclaimsRec.TSR8__c = '1234';
        testclaimsRec.TSR9__c = '1234';
        testclaimsRec.TSR10__c = '1234';
        testclaimsRec.Country__c = '1234';
        testclaimsRec.State__c = '1234';
        testclaimsRec.ZipCode__c = '12345-1234';
        
        insert testclaimsRec;
        
         testclaimsRec1.Customer_Name__c='TestCustomer';
        testclaimsRec1.Customer_Code__c = '1234';
        testclaimsRec1.Contact_Last_Name__c = 'T';
        testclaimsRec1.Address__c = 'T';
        testclaimsRec1.Customer_Contact_Phone__c = null;
        testclaimsRec1.Email_Address__c = 'rp@sct.com';
        testclaimsRec1.Status__c = 'Draft';
        testclaimsRec1.TSR1__c = '1234';
        testclaimsRec1.TSR2__c = '1234';
        testclaimsRec1.TSR3__c = '1234';
        testclaimsRec1.TSR4__c = '1234';
        testclaimsRec1.TSR5__c = '1234';
        testclaimsRec1.TSR6__c = '1234';
        testclaimsRec1.TSR7__c = '1234';
        testclaimsRec1.TSR8__c = '1234';
        testclaimsRec1.TSR9__c = '1234';
        testclaimsRec1.TSR10__c = '1234';
        testclaimsRec1.Country__c = '1234';
        testclaimsRec1.State__c = '1234';
        testclaimsRec1.ZipCode__c = '12345-1234';
        testclaimsRec1.Multi_PSN_Claim__c= true;
        insert testclaimsRec1; 
        testpsnNewRec.psn__c = '79464646';
        testpsnNewRec.Primary__C = true;
        testpsnNewRec.failure_Date__c = date.today() - 20;
        testpsnNewRec.css_claims__C = testclaimsRec.id;
        insert testpsnNewRec;
        CSS_Solution_Component__c solComRef = CSS_TestData.createSRT(false,null,null);
        solComRef.System_Code__c = 'Test';
        solComRef.CSS_Claims__c=testclaimsRec.id;
        solComRef.Component_Code__c = 'Test';
        solComRef.Failure_Mode__c = 'Test';
        solComRef.Selected_Component__c =true;
        solComRef.AccountCodeType__c = 'Test-Test';
        solComRef.AccountCode_Call_Status__c = 'Failure';
        solComRef.Failure_Point__c=11.0;
        solComRef.Failure_Measure__c = null;
             //  solComRef.Failure_Date__c=date.parse('12-27-2018');
        solComRef.Failure_Date__c=date.today();
        solComRef.AccountCode__c = '';
        solComRef.AccountCodeEdit__c='test';
        solComRef.Type__c = 'Campaign';
        solComRef.Status__c='Approved';
        insert solComRef;
        string cId;
        CSS_Job_Order__c JO = CSS_TestData.createJobOrder(true);
        cId=ApexPages.CurrentPage().getParameters().get('id');
        PageReference pageRef = Page.CG_ClaimsVH;
        pageRef.getParameters().put('id',testclaimsRec.id);
        Test.setCurrentPage(pageRef); 
        CG_CL_ClaimsVH claimsvh = new CG_CL_ClaimsVH();
        claimsvh.nvClaimsIntake();
        claimsvh.nvClaimsCC();
        claimsvh.nvClaimsWC();
        claimsvh.nvClaimsFC();
        claimsvh.nvClaimsVS();
        claimsvh.nvClaimsSRTs();
        claimsvh.nvClaimsPOC();
        claimsvh.nvClaimsJobNotes();
        // String id = ApexPages.currentPage().getParameters().get('id');
        claimsvh.pgSave();
        claimsvh.nvClaimsVH();
        PageReference pageRef1 = Page.CG_ClaimsVH;
        pageRef1.getParameters().put('id',testclaimsRec1.id);
           Test.setCurrentPage(pageRef1); 
         CG_CL_ClaimsVH claimsvh1 = new CG_CL_ClaimsVH();
        claimsvh1.checkAccountCode=true;
        test.stopTest();
    }
    public static Testmethod void CG_CL_ClaimsVH_Method2(){
        test.startTest();
        CSS_Claims__c testclaimsRec = new CSS_Claims__c();
        CSS_PSN__c testpsnNewRec = new CSS_PSN__c();
        
        testclaimsRec.Customer_Name__c='TestCustomer';
        testclaimsRec.Customer_Code__c = '1234';
        testclaimsRec.Contact_Last_Name__c = 'T';
        testclaimsRec.Address__c = 'T';
        testclaimsRec.Customer_Contact_Phone__c = null;
        testclaimsRec.Email_Address__c = 'rp@sct.com';
        testclaimsRec.Status__c = 'Draft';
        testclaimsRec.TSR1__c = '1234';
        testclaimsRec.TSR2__c = '1234';
        testclaimsRec.TSR3__c = '1234';
        testclaimsRec.TSR4__c = '1234';
        testclaimsRec.TSR5__c = '1234';
        testclaimsRec.TSR6__c = '1234';
        testclaimsRec.TSR7__c = '1234';
        testclaimsRec.TSR8__c = '1234';
        testclaimsRec.TSR9__c = '1234';
        testclaimsRec.TSR10__c = '1234';
        testclaimsRec.Country__c = '1234';
        testclaimsRec.State__c = '1234';
        testclaimsRec.ZipCode__c = '12345-1234';
        
        insert testclaimsRec;
        testpsnNewRec.psn__c = '79464646';
        testpsnNewRec.Primary__C = true;
        testpsnNewRec.failure_Date__c = date.today() - 20;
        testpsnNewRec.css_claims__C = testclaimsRec.id;
        insert testpsnNewRec;
        
        
        string cId;
        CSS_Job_Order__c JO = CSS_TestData.createJobOrder(true);
        cId=null;
        PageReference pageRef = Page.CG_ClaimsVH;
        pageRef.getParameters().put('id',cId);
        Test.setCurrentPage(pageRef); 
        CG_CL_ClaimsVH claimsvh = new CG_CL_ClaimsVH();
        claimsvh.nvClaimsIntake();
        claimsvh.nvClaimsCC();
        claimsvh.nvClaimsWC();
        claimsvh.nvClaimsFC();
        claimsvh.nvClaimsVS();
        claimsvh.nvClaimsSRTs();
        claimsvh.nvClaimsPOC();
        claimsvh.nvClaimsJobNotes();
        claimsvh.nvClaimsPSN();
        // String id = ApexPages.currentPage().getParameters().get('id');
        claimsvh.pgSave();
        claimsvh.nvClaimsVH();
        test.stopTest();
    }
    
}