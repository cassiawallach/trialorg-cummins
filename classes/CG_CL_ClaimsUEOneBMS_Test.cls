/**********************************************************************
Name:CG_CL_ClaimsCustOneBMS_Test
Copyright Â© 2018  Cummins
===============================================================
===============================================================
Purpose:                                                            
-------  
This is test class for CG_CL_ClaimsCustOneBMS Controller.
===============================================================
===============================================================
History      

-------                                                            
VERSION    AUTHOR                 DATE                DETAIL                                 
1.0 -      Kalpana Vemula     02/13/2018           INITIAL DEVELOPMENT                    
***********************************************************************/
@isTest
public class CG_CL_ClaimsUEOneBMS_Test {
    
    public static Testmethod void CG_CL_ClaimsUEOneBMS_Method(){ 
        Test.setMock(WebServiceMock.class, new CSS_GetEngineDataPlate_Test()); 
        Test.setMock(HttpCalloutMock.class, new CSS_MockHttpResponseGenerator());
        Test.setMock(HttpCalloutMock.class, new CG_CampaignMock_Test());
        
        CG_CL_ClaimsUEOneBMS claimsUEOneBMS = new CG_CL_ClaimsUEOneBMS();
        claimsUEOneBMS.ExternReturnDateFlag = true;
        claimsUEOneBMS.recconFlag = true;
        claimsUEOneBMS.productAppdesc = 'sneha';
        claimsUEOneBMS.productAppcode ='test';
        Id testsaveClaimedid;
        CSS_Integration_Details__c conDetails = new CSS_Integration_Details__c();
        conDetails.Name = 'GetCampaign';
        conDetails.AuthEnv__c = 'OAGOAUTH';
        conDetails.ApplicationName__c = 'GetCampaign';
        conDetails.End_Point__c = 'Test';
        conDetails.Method_Type__c = 'POST';
        conDetails.Timeout__c = 2.0;
        insert conDetails;
        
        CSS_PSN__c testpsnNewRec = new CSS_PSN__c();
        CSS_Claims__c testclaimsRec = new CSS_Claims__c();
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
        testclaimsRec.EtoConversionDate__c =system.today(); 
        //testclaimsRec.ProductApplicationCode__c= 'test' ;
        //testclaimsREc.ProductApplicationDesp__c='AUTOMOTIVE' ;  
        testclaimsRec.IsCopyclaim__c = true;
        //testclaimsRec.recursupd = true;
        insert testclaimsRec;
        
        testpsnNewRec.psn__c = '';
        testpsnNewRec.Primary__C = true;
        testpsnNewRec.failure_Date__c = system.today()+20;
        testpsnNewRec.css_claims__C = testclaimsRec.id;
        insert testpsnNewRec;
        CG_CL_ClaimsIntake testobj=new CG_CL_ClaimsIntake();
        testobj.filterApplication = 'AUTOMOTIVE';
        
        CSS_JobEventTemporary__c  jobEventRef = CSS_TestData.createJobEventTempObj(false);
        jobEventRef.Attribute1__c ='ApplicationCodes';
        jobEventRef.Attribute2__c='TestAtt1';
        jobEventRef.Attribute3__c='AUTOMOTIVE';
        jobEventRef.Attribute5__c = testobj.filterApplication;
        jobEventRef.Key__c='AccountCodes';
        jobEventRef.Reason__c='{"DataArea": {"Details": [{"ApplicationCode": "123","Description": "abc","BusinessUnit": "EBU","AutomotiveFlag": "Y","MarineFlag": "","ActiveFlag": "Y","DefaultUom": "miles"},{"ApplicationCode": "555","Description": "zxcv","BusinessUnit": "PSBU","AutomotiveFlag": "","MarineFlag": "N","ActiveFlag": "Y","DefaultUom": "miles"}]},"Header": {"ReturnCodeDescription": "","Status": "Success"}}';
        insert  jobEventRef;
        
        CSS_JobEventTemporary__c JETproductcode = new CSS_JobEventTemporary__c();
        JETproductcode.Key__c = 'FailCodes';
        JETproductcode.Attribute1__c = 'BB';
        JETproductcode.Attribute3__c = 'AUTOMOTIVE';
        JETproductcode.Attribute2__c = 'TE-ST';
        JETproductcode.Attribute5__c = 'zxcv';
        JETproductcode.Reason__c='{"DataArea": {"Details": [{"ApplicationCode": "123","Description": "abc","BusinessUnit": "EBU","AutomotiveFlag": "Y","MarineFlag": "","ActiveFlag": "Y","DefaultUom": "miles"},{"ApplicationCode": "555","Description": "zxcv","BusinessUnit": "PSBU","AutomotiveFlag": "","MarineFlag": "N","ActiveFlag": "Y","DefaultUom": "miles"}]},"Header": {"ReturnCodeDescription": "","Status": "Success"}}';
        insert JETproductcode;
        CSS_JobEventTemporary__c JETproductcode1 = new CSS_JobEventTemporary__c();
        JETproductcode1.Key__c = 'MarketingApplicationCodes';
        JETproductcode1.Attribute1__c = 'BB';
        JETproductcode1.Attribute3__c = 'AUTOMOTIVE';
        JETproductcode1.Attribute2__c = 'TE-ST';
        JETproductcode1.Attribute5__c = 'zxcv';
        JETproductcode1.Reason__c='{"DataArea": {"Details": [{"ApplicationCode": "123","Description": "abc","BusinessUnit": "EBU","AutomotiveFlag": "Y","MarineFlag": "","ActiveFlag": "Y","DefaultUom": "miles"},{"ApplicationCode": "555","Description": "zxcv","BusinessUnit": "PSBU","AutomotiveFlag": "","MarineFlag": "N","ActiveFlag": "Y","DefaultUom": "miles"}]},"Header": {"ReturnCodeDescription": "","Status": "Success"}}';
        insert JETproductcode1;
        
        //string sQSOLConn = CSS_getConnnectionDetails.getConnection('FailCodes').Key__c;   
        testclaimsRec =[Select Id,CSS_Job__r.General_Symptoms__c,Account__c,CSS_Job__r.Category_Desc__c,CSS_Job__r.Complaint_Type_Desc__c,CSS_Job__r.Category2_Desc__c,
                        CSS_Job__r.Complaint_Type2_Desc__c,CSS_Job__r.Category3_Desc__c,CSS_Job__r.Complaint_Type3_Desc__c,CSS_Job__r.Category4_Desc__c,
                        CSS_Job__r.Complaint_Type4_Desc__c,CSS_Job__r.Category5_Desc__c,CSS_Job__r.Complaint_Type5_Desc__c,Claims_General_Symptoms__c,
                        Claims_Preventive_Maintenance__c,SP_WarrantyCertificationEndDate__c,ProductApplicationCode__c,Claims_Category__c,Claims_Category2__c,Claims_Category3__c,Claims_Category4__c,Claims_Category5__c,
                        Complaint_Type_Desc__c,Complaint_Type2_Desc__c,Complaint_Type3_Desc__c,Complaint_Type4_Desc__c,Complaint_Type5_Desc__c,IsCopyclaim__c,
                        Claims_Expedited_Service__c,Status__c,ODM_Status__c,Claims_Additional_Comments__c,Claims_Category_Desc__c,Claims_Category2_Desc__c,
                        Claims_Category3_Desc__c,Claims_Category4_Desc__c,Claims_Category5_Desc__c,Claims_Complaint_Type__c,Claims_Complaint_Type2__c,
                        Claims_Complaint_Type3__c,Claims_Complaint_Type4__c,account__r.RSS_RESP_BRANCH_CODE__c,SP_PrimaryOEMCode__c,Claims_Complaint_Type5__c,CSS_Job__r.createdDate,Customer_Name__c,Location__c,
                        Location_Code__c,CSS_Job__c,CSS_Job__r.name,Shop_Work_Order__c,SP_Country__c,EngineFamilyName__c,LastModifiedDate,Name, ESN__c, createdDate,Region__c,Territory__c,
                        CoverageResponse__c,Claim_Submitted__c,Account__r.Enable_Claims__c,Account__r.Warranty_Training_Status__c,Distributor_Authorization_FN__c,
                        CreatedBy.Name,Account__r.Warranty_Training_Certification__c,TSR1__c,TSR2__c,TSR3__c,TSR4__c,TSR5__c,TSR6__c,TSR7__c,TSR8__c,TSR9__c,
                        TSR10__c,CSS_Job__r.CSS_In_Shop_Labor_Rate__c,CSS_Job__r.CSS_Field_Service_Labor_Rate__c,CSS_Job__r.CSS_Travel_Rate__c, Catastrophic__c,
                        DesignPhaseCode__c, Service_Model__c,CSS_Channel_Of_Distribution__c,SP_LTA_FLAG__c,SP_PACCAR__c,SP_ACCOUNT_STATUS__c,SP_TERRITORY_CODE__c,
                        SP_PromotionId__c,Repair_Location__c, BillToCode__c, BuildDate__c, EngineFamilyCode__c, EtoConversionDate__c, MarineFlag__c, OemCode__c, 
                        ProductApplicationDesp__c, warrantyIndicatorFlag__c, SP_CHANNEL_OF_DISTRIBUTION__c, CSS_Channel_Code__c, SP_CLAIM_ALLOWED_DAYS__c, 
                        SP_Group_Name__c, SP_CMI_SP_EXPIRATION__c, SP_SCMDollarAmt__c,SP_WarrantyTrainingStatus__c,SP_State__c,SP_SCMDeductiblePercentage__c,
                        SP_OUTFILE_ALL_CLAIMS__c, SP_REGION__c, SP_REGIONCODE__c, SP_TERRITORY__c, CSS_Job__r.Shop_Work_Order__c,Automotive_App_Flag__c,  
                        (Select Id,Name,PSN__c,Make__c,Model__c,Before_In_Service__c,Mission_Disabling__c,Calibration_After__c,Calibration_Before__c,VIN__c,
                         Service_Model__c,Application__c,ApplicationCode__c,Qsol_Engine_Family_Code__c, Failure_Date__c,Mileage__c,Mileage_Measure__c,Justification__c,Unit_Number__c,
                         Warranty_Start_Date__c,Product_Hours__c,CoverageFlag__c, CSS_Claims__c from CSS_PSNs__r where Primary__c=true Limit 1) 
                        from CSS_Claims__c where id=:testclaimsRec.id];
        
        
        Profile p = [SELECT Id FROM Profile WHERE Name='CSS_Service_Advanced']; 
        User usr = new User(Alias = 'standt', Email='standarduser4@testorg.com', 
                            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                            LocaleSidKey='en_US',  ProfileId = p.Id, 
                            TimeZoneSidKey='America/Los_Angeles', UserName='UtilityTestUser14@testorg.com',User_Location__c = '56270-56270');
        insert usr;
        
        CSS_accountLanguage__c accLan = new CSS_accountLanguage__c();
        accLan.CSS_QsolLanguage__c = 'en';
        accLan.Name = 'en_US';
        insert accLan;
        system.debug('usr**'+usr);
        testobj.psnRec = testpsnNewRec;
        testobj.filterMake = 'ACE';
        testobj.filterModel = 'QSB-44-T2';
        testobj.userObj = usr;
        ClaimsUEOneBMS.mainContr = testObj;
        
        
        //Start
        test.startTest();
        
        Test.setMock(HttpCalloutMock.class, new CG_CampaignMock_Test());
        Test.setMock(HttpCalloutMock.class, new CSS_getEngineDataResponseJ2A_Mockup_Test());
        Test.setMock(HttpCalloutMock.class, new CSS_GetServiceProviderResponseMock_Test());
        CSS_GetServiceProviderResponse resobj = CSS_FN_SIEBEL.getServiceProviderDataWrapper('SPCode','','FailureDate','jobClaimNo');
        claimsUEOneBMS.startRequest();
        claimsUEOneBMS.getItems();
        claimsUEOneBMS.getApplication();
        claimsUEOneBMS.recconFlag = true;
        //claimsUEOneBMS.startRequest();
        claimsUEOneBMS.updateproductappcode();
        claimsUEOneBMS.getMake();
        claimsUEOneBMS.getModel();
        claimsUEOneBMS.getUnitType();
        
        test.stoptest();
    }
    
    public static Testmethod void CG_CL_ClaimsUEOneBMS_Method2(){ 
        Test.setMock(WebServiceMock.class, new CSS_GetEngineDataPlate_Test()); 
        // Test.setMock(WebServiceMock.class, new CSS_GetDocs_Test());
        Test.setMock(HttpCalloutMock.class, new CG_CampaignMock_Test());
        
        CG_CL_ClaimsUEOneBMS claimsUEOneBMS = new CG_CL_ClaimsUEOneBMS();
        Id testsaveClaimedid;
        CG_CL_ClaimsIntake testobj=new CG_CL_ClaimsIntake();
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
        testpsnNewRec.failure_Date__c = date.today()+20;
        testpsnNewRec.Warranty_Start_Date__c=date.today()+12;
        testpsnNewRec.css_claims__C = testclaimsRec.id;
        insert testpsnNewRec;
        
        testclaimsRec =[Select Id,CSS_Job__r.General_Symptoms__c,Account__c,CSS_Job__r.Category_Desc__c,CSS_Job__r.Complaint_Type_Desc__c,CSS_Job__r.Category2_Desc__c,
                        CSS_Job__r.Complaint_Type2_Desc__c,CSS_Job__r.Category3_Desc__c,CSS_Job__r.Complaint_Type3_Desc__c,CSS_Job__r.Category4_Desc__c,
                        CSS_Job__r.Complaint_Type4_Desc__c,CSS_Job__r.Category5_Desc__c,CSS_Job__r.Complaint_Type5_Desc__c,Claims_General_Symptoms__c,
                        Claims_Preventive_Maintenance__c,SP_WarrantyCertificationEndDate__c,ProductApplicationCode__c,Claims_Category__c,Claims_Category2__c,Claims_Category3__c,Claims_Category4__c,Claims_Category5__c,
                        Complaint_Type_Desc__c,Complaint_Type2_Desc__c,Complaint_Type3_Desc__c,Complaint_Type4_Desc__c,Complaint_Type5_Desc__c,IsCopyclaim__c,
                        Claims_Expedited_Service__c,Status__c,ODM_Status__c,Claims_Additional_Comments__c,Claims_Category_Desc__c,Claims_Category2_Desc__c,
                        Claims_Category3_Desc__c,Claims_Category4_Desc__c,Claims_Category5_Desc__c,Claims_Complaint_Type__c,Claims_Complaint_Type2__c,
                        Claims_Complaint_Type3__c,Claims_Complaint_Type4__c,account__r.RSS_RESP_BRANCH_CODE__c,SP_PrimaryOEMCode__c,Claims_Complaint_Type5__c,CSS_Job__r.createdDate,Customer_Name__c,Location__c,
                        Location_Code__c,CSS_Job__c,CSS_Job__r.name,Shop_Work_Order__c,SP_Country__c,EngineFamilyName__c,LastModifiedDate,Name, ESN__c, createdDate,Region__c,Territory__c,
                        CoverageResponse__c,Claim_Submitted__c,Account__r.Enable_Claims__c,Account__r.Warranty_Training_Status__c,Distributor_Authorization_FN__c,
                        CreatedBy.Name,Account__r.Warranty_Training_Certification__c,TSR1__c,TSR2__c,TSR3__c,TSR4__c,TSR5__c,TSR6__c,TSR7__c,TSR8__c,TSR9__c,
                        TSR10__c,CSS_Job__r.CSS_In_Shop_Labor_Rate__c,CSS_Job__r.CSS_Field_Service_Labor_Rate__c,CSS_Job__r.CSS_Travel_Rate__c, Catastrophic__c,
                        DesignPhaseCode__c, Service_Model__c,CSS_Channel_Of_Distribution__c,SP_LTA_FLAG__c,SP_PACCAR__c,SP_ACCOUNT_STATUS__c,SP_TERRITORY_CODE__c,
                        SP_PromotionId__c,Repair_Location__c, BillToCode__c, BuildDate__c, EngineFamilyCode__c, EtoConversionDate__c, MarineFlag__c, OemCode__c, 
                        ProductApplicationDesp__c, warrantyIndicatorFlag__c, SP_CHANNEL_OF_DISTRIBUTION__c, CSS_Channel_Code__c, SP_CLAIM_ALLOWED_DAYS__c, 
                        SP_Group_Name__c, SP_CMI_SP_EXPIRATION__c, SP_SCMDollarAmt__c,SP_WarrantyTrainingStatus__c,SP_State__c,SP_SCMDeductiblePercentage__c,
                        SP_OUTFILE_ALL_CLAIMS__c, SP_REGION__c, SP_REGIONCODE__c, SP_TERRITORY__c, CSS_Job__r.Shop_Work_Order__c,Automotive_App_Flag__c,  
                        (Select Id,Name,PSN__c,Make__c,Model__c,Before_In_Service__c,Mission_Disabling__c,Calibration_After__c,Calibration_Before__c,VIN__c,
                         Service_Model__c,Application__c,ApplicationCode__c,Qsol_Engine_Family_Code__c, Failure_Date__c,Mileage__c,Mileage_Measure__c,Justification__c,Unit_Number__c,
                         Warranty_Start_Date__c,Product_Hours__c,CoverageFlag__c, CSS_Claims__c from CSS_PSNs__r where Primary__c=true Limit 1) 
                        from CSS_Claims__c where id=:testclaimsRec.id];
        
        Profile p = [SELECT Id FROM Profile WHERE Name='CSS_Service_Advanced']; 
        User usr = new User(Alias = 'standt', Email='standarduser4@testorg.com', 
                            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                            LocaleSidKey='en_US',  ProfileId = p.Id, 
                            TimeZoneSidKey='America/Los_Angeles', UserName='UtilityTestUser14@testorg.com',User_Location__c = '56270-56270');
        insert usr;
        system.debug('usr**'+usr);
        CSS_accountLanguage__c accLan = new CSS_accountLanguage__c();
        accLan.CSS_QsolLanguage__c = 'en';
        accLan.Name = 'en_US';
        insert accLan;
        testobj.psnRec = testpsnNewRec;
        testobj.filterMake = 'ACE';
        testobj.filterModel = 'QSB-44-T2';
        testobj.userObj = usr;
        
        ClaimsUEOneBMS.mainContr = testObj;
        CSS_Integration_Details__c conDetails = new CSS_Integration_Details__c();
        conDetails.Name = 'GetCampaign';
        conDetails.AuthEnv__c = 'OAGOAUTH';
        conDetails.ApplicationName__c = 'GetCampaign';
        conDetails.End_Point__c = 'Test';
        conDetails.Method_Type__c = 'POST';
        conDetails.Timeout__c = 2.0;
        insert conDetails;
        test.startTest();
        
        test.stoptest();
    }
    
    public static Testmethod void TestForCompareDates() {
        
        CSS_Claims__c testclaimsRec = new CSS_Claims__c(); 
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
        
        CSS_PSN__c testpsnNewRec = new CSS_PSN__c();
        testpsnNewRec.psn__c = '';
        testpsnNewRec.Primary__C = true;
        testpsnNewRec.failure_Date__c = date.today()+20;
        testpsnNewRec.Warranty_Start_Date__c=date.today()+12;
        testpsnNewRec.css_claims__C = testclaimsRec.id;
        insert testpsnNewRec;
        
        CG_CL_ClaimsIntake testobj=new CG_CL_ClaimsIntake();
        testobj.psnRec = testpsnNewRec;
        testobj.filterMake = 'ACE';
        testobj.filterModel = 'QSB-44-T2';
        
        apexpages.currentPage().getparameters().put('id',testclaimsRec.id);
        CSS_Claim_Submission__c claimsub = new CSS_Claim_Submission__c();
        claimsub.CSS_Claims__c = testclaimsRec.id;
        claimsub.Status__c='Submitted';
        claimsub.Batch_Processed_Date__c=system.now()-4;
        insert claimsub;
        
        
        Test.startTest();
        CG_CL_ClaimsUEOneBMS b = new CG_CL_ClaimsUEOneBMS();
        b.mainContr = testObj;
        b.builddateErrFlag=false;
        b.warrantyDate = Date.Today()+1;
        b.billdateVal=system.today()+2;
        b.PSN='10000000';
        b.CompareDates();
        b.warrStDtHidden = '';
        b.ReadonlyWSD = false;
        
        test.stopTest();
    }
    
    
    public static Testmethod void TestForCompareDates2() {
        System.debug('in TestForCompareDates2 method...');
        
        CSS_Claims__c testclaimsRec = new CSS_Claims__c(); 
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
        
        CSS_PSN__c testpsnNewRec = new CSS_PSN__c();
        testpsnNewRec.psn__c = '79464646';
        testpsnNewRec.Primary__C = true;
        testpsnNewRec.failure_Date__c = date.today()+20;
        testpsnNewRec.Warranty_Start_Date__c=date.today()+12;
        testpsnNewRec.css_claims__C = testclaimsRec.id;
        insert testpsnNewRec;
        
        CG_CL_ClaimsIntake testobj=new CG_CL_ClaimsIntake();
        testobj.psnRec = testpsnNewRec;
        testobj.filterMake = 'ACE';
        testobj.filterModel = 'QSB-44-T2';
        
        apexpages.currentPage().getparameters().put('id',testclaimsRec.id);
        CSS_Claim_Submission__c claimsub = new CSS_Claim_Submission__c();
        claimsub.CSS_Claims__c = testclaimsRec.id;
        claimsub.Status__c='Submitted';
        claimsub.Batch_Processed_Date__c=system.now()-4;
        insert claimsub;
        
        System.debug('after insert...');
        
        Test.startTest();
        CG_CL_ClaimsUEOneBMS b = new CG_CL_ClaimsUEOneBMS();
        b.mainContr = testObj;
        b.builddateErrFlag=false;
        b.warrantyDate = Date.Today()+1;
        b.warrStDtHidden='7/31/2019';
        b.billdateVal=system.today()+10;
        //b.PSN='10000000';
        System.debug('before...');
        b.CompareDates();
        System.debug('after...');
        
        b.warrStDtHidden = '';
        b.ReadonlyWSD = false;
        
        test.stopTest();
    }
    public static Testmethod void TestForCompareDates4() {
        System.debug('in TestForCompareDates2 method...');
        
        CSS_Claims__c testclaimsRec = new CSS_Claims__c(); 
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
        
        CSS_PSN__c testpsnNewRec = new CSS_PSN__c();
        testpsnNewRec.psn__c = '79464646';
        testpsnNewRec.Primary__C = true;
        testpsnNewRec.failure_Date__c = date.today()+20;
        testpsnNewRec.Warranty_Start_Date__c=date.today()-10;
        testpsnNewRec.css_claims__C = testclaimsRec.id;
        insert testpsnNewRec;
        
        CG_CL_ClaimsIntake testobj=new CG_CL_ClaimsIntake();
        testobj.psnRec = testpsnNewRec;
        testobj.filterMake = 'ACE';
        testobj.filterModel = 'QSB-44-T2';
        
        apexpages.currentPage().getparameters().put('id',testclaimsRec.id);
        CSS_Claim_Submission__c claimsub = new CSS_Claim_Submission__c();
        claimsub.CSS_Claims__c = testclaimsRec.id;
        claimsub.Status__c='Submitted';
        claimsub.Batch_Processed_Date__c=system.now()-4;
        insert claimsub;
        
        System.debug('after insert...');
        
        Test.startTest();
        CG_CL_ClaimsUEOneBMS b = new CG_CL_ClaimsUEOneBMS();
        b.mainContr = testObj;
        b.builddateErrFlag=false;
        b.warrantyDate = Date.Today()+1;
        b.billdateVal=system.today()+32;
        b.PSN=null;
        System.debug('before...');
        b.CompareDates();
        System.debug('after...');
        
        b.warrStDtHidden = '';
        b.ReadonlyWSD = false;
        
        test.stopTest();
    }
    public static Testmethod void TestForCompareDates3() {
        System.debug('in TestForCompareDates2 method...');
        
        CSS_Claims__c testclaimsRec = new CSS_Claims__c(); 
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
        
        CSS_PSN__c testpsnNewRec = new CSS_PSN__c();
        testpsnNewRec.psn__c = '79464646';
        testpsnNewRec.Primary__C = true;
        testpsnNewRec.failure_Date__c = date.today()+20;
        testpsnNewRec.Warranty_Start_Date__c=date.today()+12;
        testpsnNewRec.css_claims__C = testclaimsRec.id;
        insert testpsnNewRec;
        
        CG_CL_ClaimsIntake testobj=new CG_CL_ClaimsIntake();
        testobj.psnRec = testpsnNewRec;
        testobj.filterMake = 'ACE';
        testobj.filterModel = 'QSB-44-T2';
        
        apexpages.currentPage().getparameters().put('id',testclaimsRec.id);
        CSS_Claim_Submission__c claimsub = new CSS_Claim_Submission__c();
        claimsub.CSS_Claims__c = testclaimsRec.id;
        claimsub.Status__c='Submitted';
        claimsub.Batch_Processed_Date__c=system.now()-4;
        insert claimsub;
        
        System.debug('after insert...');
        
        Test.startTest();
        CG_CL_ClaimsUEOneBMS b = new CG_CL_ClaimsUEOneBMS();
        b.mainContr = testObj;
        b.builddateErrFlag=false;
        b.warrantyDate = Date.Today()+1;
        b.billdateVal=system.today()+2;
        b.PSN='10000000';
        System.debug('before...');
        b.warrStDtHidden = '09/06/2019';
        b.CompareDates();
        System.debug('after...');
        CSS_PSN__c testpsnNewRec1 = new CSS_PSN__c();
        testpsnNewRec1.psn__c = '79464646';
        testpsnNewRec1.Primary__C = true;
        testpsnNewRec1.failure_Date__c = date.today()+20;
        testpsnNewRec1.Warranty_Start_Date__c=date.today()+12;
        testpsnNewRec1.css_claims__C = testclaimsRec.id;
        insert testpsnNewRec1;
        b.CompareDates();
        // b.warrStDtHidden = '';
        b.ReadonlyWSD = false;
        
        test.stopTest();
    }
    
    public static Testmethod void TestMakeBISReadOnlymethod(){
        CG_CL_ClaimsIntake BL = new CG_CL_ClaimsIntake();
        bl.wsdReadOnlyFromContr=true;
        bl.warrantyStartDateValidate=true;
        bl.FormattedDate='';
        css_claims__c claim = new css_claims__c();
        claim.Customer_Name__c='Gopal';
        claim.Customer_Code__c='123';
        
        insert claim;
        css_psn__c psn = new css_psn__c();
        psn.CSS_Claims__c= claim.id;
        psn.Warranty_Start_Date__c=system.today()+12;
        psn.Before_In_Service__c=false;
        psn.Failure_Date__c=system.today();
        PSN.Unit_Type__c='';
        //  psn.Justification__c='Field Action';
        insert psn;
        bl.psnRec=psn;
        Id RecordTypeIdmkmdl = Schema.SObjectType.CSS_Make_Model_Access__c.getRecordTypeInfosByName().get('SRTData').getRecordTypeId();
        
        CSS_Make_Model_Access__c nw = new CSS_Make_Model_Access__c();
        nw.Configuration__c='Work Boat';
        nw.make__c='MARINE';
        nw.model__c ='WORKBOAT';
        NW.RecordTypeId=RecordTypeIdmkmdl;
        insert nw;
        Account a = new Account();
        a.Name = 'Test Account';
        // a.Location__c = '56270-56270';
        a.CSS_DistributorCode__c ='56270';
        a.IAM_Service_Provider_Code__c = '56270';
        a.IAM_Service_Provider_Code__c = '56270';
        
        a.Type='Dealer Account';
        a.Region__c = 'US and Canada';
        a.CMI_Account_Status__c = 'Active';
        a.IAM_Service_Provider_Code__c = '562551';
        insert a;
        LIst<CSS_Accreditation__c> accredList = new List<CSS_Accreditation__c>();
        CSS_Accreditation__c acc = new CSS_Accreditation__c();
        acc.Service_Model_Name__c = 'ISBE CM800';
        acc.Account__c = a.id;
        insert acc;
        accredList.add(acc);
        BL.filterMake='MARINE';
        BL.filterModel='WORKBOAT';
        CG_CL_ClaimsUEOneBMS onebms = new CG_CL_ClaimsUEOneBMS();
        onebms.FailureStDtHidden=string.valueOf(Date.today());
        
        onebms.mainContr = BL;
        onebms.MakeBISReadOnly();
        onebms.MakeWSDReadOnly();
        onebms.searchConfigUnit();
        onebms.getFormatDate();
        onebms.getFormattedFailureDate();
        onebms.getJustification();
        onebms.getlicensePlateList();
        onebms.checkFailureDate();
        onebms.mainContr.psnRec.Warranty_Start_Date__c=null;
        onebms.mainContr.psnRec.Failure_Date__c=null;
        onebms.getFormatDate();
        onebms.getFormattedFailureDate();
        //List<SelectOption> so= onebms.getUnitType();
        // onebms.getCampaignDetails();
        
    }    
     /*static testmethod void startrequest(){
         CG_CL_ClaimsUEOneBMS IntakeJob2 = new CG_CL_ClaimsUEOneBMS();
        CG_CL_IntakeVH invh = new CG_CL_IntakeVH();
        CG_CL_IntakeRJ inrj = new CG_CL_IntakeRJ();
       // IntakeJob1.mainContrVH = invh;
        //IntakeJob1.mainContrRJ = inrj;
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
     }*/
    
          
        
         
    public static Testmethod void TestMakeBISmethod1(){
        
         
        
        CSS_Job_Order__c JO = new CSS_Job_Order__c();
        JO.Customer_Name__c = 'Test-KG';
        JO.Application__c = 'Recreational Vehicle';
        JO.Model__c = 'RTest';
        JO.Make__c = 'CSSTest';
        JO.Notes__c = 'CAMPCOMMENTS';
        JO.Failure_Point__c = 122;
        JO.Failure_Point_Measure__c = 'Miles';
        JO.VIN__c = '12345677890';
        insert JO;
        
        CSS_Claims__c testclaimsRec = new CSS_Claims__c(); 
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
        
        //apexpages.currentPage().getparameters().put('id',testclaimsRec.id);
        CSS_Claim_Submission__c claimsub = new CSS_Claim_Submission__c();
        claimsub.CSS_Claims__c = testclaimsRec.id;
        claimsub.Status__c='Submitted';
        claimsub.Batch_Processed_Date__c=system.now()-4;
        insert claimsub;
        
        CG_CL_ClaimsIntake claimIntake = new CG_CL_ClaimsIntake();
        claimIntake.mainFlag = 'true';
        //insert claimIntake;
        css_psn__c psn = new css_psn__c();
        psn.CSS_Claims__c= testclaimsRec.id;
        psn.Warranty_Start_Date__c=system.today();
        psn.Before_In_Service__c=false;
        psn.Failure_Date__c=system.today();
        psn.Unit_Type__c='';
        psn.PSN__c = '79464646';
        //  psn.Justification__c='Field Action';
        insert psn;
        
        list<CSS_Parts_Options__c> lstparts = new list <CSS_Parts_Options__c>(); 
        CSS_Parts_Options__c parts = new CSS_Parts_Options__c();
        //parts.FailurepartId__c = solComp.Id;
        parts.selected_part__c = True;
        parts.Service_partnumber__c = '540571401';
        parts.OEM__c = 'OEMWRS';
        parts.Part_Name__c = 'TestPartCamp';
        parts.ReturnToFactory__c = 'Campaign-TRP-ATC';
        parts.Replacement_Reason__c = 'Campaign-TRP-ATC';
        parts.Quantity__c = 55;
        parts.Notes__c = 'Hai how are you guys';
        parts.Service_Job__c = JO.id;
        insert parts;
        lstparts.add(parts);
        
        list<CSS_Solution_Component__c> lstsolcomp = new list<CSS_Solution_Component__c>();
        CSS_Solution_Component__c solComp = new CSS_Solution_Component__c();
        solComp.Component_Id__c ='F0051000';
        solComp.Service_Job__c = JO.id;
        solComp.Action__c = '';
        solComp.Type__c = 'Campaign';
        solcomp.CSS_Claims__c=testclaimsRec.id;
        solcomp.ODM_Status__c ='YTBV';
        solComp.Campaign_Description__c = 'Hey Hai Man Camp';
        solComp.CampaignPartsPercentage__c = '20';
        solcomp.Performed_Review__c = True;
        insert solComp;
        lstsolcomp.add(solComp);
        
        list < Attachment > attachmentList = new list < Attachment > ();
        Attachment attach = new Attachment();
        attach.Name = 'Unit Test Attachment1';
        Blob bodyBlob1 = Blob.valueOf('Unit Test Attachment Body');
        attach.body = bodyBlob1;
        attach.parentId = JO.id;
        attachmentList.add(attach);
        
        list<Note> ClaimNotesList=new list<Note>();  
        note not1 = new note();
        not1.Body='Testing';
        not1.ParentId=claimsub.Id;
        not1.Title='Claims';
        insert not1;
        
        list<CSS_SRT__C> lstsrt = new list<CSS_SRT__C>();
        CSS_SRT__C srtobj = new CSS_SRT__C();
        srtobj.Access_Code__c = 'test';
        Test.setMock(HttpCalloutMock.class, new CSS_getEngineDataFrmSiebel_Test()); 
       //  Test.setMock(HttpCalloutMock.class, new CG_WS_QSOLMock());
        CSS_getEngineDataResponseJ2A enginereq = new CSS_getEngineDataResponseJ2A();        
        CSS_getEngineDataResponseJ2A.DataArea Req = new CSS_getEngineDataResponseJ2A.DataArea();
        
        Req.WarrantyStartDate = '2013-10-14T00:00:00.000-04:00';
        Req.buildDate= '2013-10-14T00:00:00.000-04:00';
        Req.EtoConversionDate='2013-10-14T00:00:00.000-04:00';
        CG_CL_ClaimsUEOneBMS POPUP = new CG_CL_ClaimsUEOneBMS();
        
    }
    
    public static Testmethod void TestForMakeWSDReadOnly(){
        
        CG_CL_ClaimsIntake BL = new CG_CL_ClaimsIntake();
        bl.wsdReadOnlyFromContr = true;
        bl.warrantyStartDateValidate = true;
        bl.FormattedDate='';
        
        css_claims__c claim = new css_claims__c();
        claim.Customer_Name__c='Oliver Trucking';
        claim.Customer_Code__c='123456';
        insert claim;
        
        css_psn__c psn = new css_psn__c();
        psn.CSS_Claims__c= claim.id;
        psn.Before_In_Service__c= true;
        insert psn;
        
        bl.psnRec=psn;
        Id RecordTypeIdmkmdl = Schema.SObjectType.CSS_Make_Model_Access__c.getRecordTypeInfosByName().get('SRTData').getRecordTypeId();
        
        CG_CL_ClaimsUEOneBMS onebms = new CG_CL_ClaimsUEOneBMS();
        onebms.mainContr = BL;
        onebms.MakeWSDReadOnly();
    }
    
    public static Testmethod void TestForCheckFailureDate(){
        
        CG_CL_ClaimsIntake BL = new CG_CL_ClaimsIntake();
        bl.wsdReadOnlyFromContr = true;
        bl.warrantyStartDateValidate = true;
        bl.FormattedDate='';
        
        css_claims__c claim = new css_claims__c();
        claim.Customer_Name__c='Oliver Trucking';
        claim.Customer_Code__c='123456';
        insert claim;
        
        css_psn__c psn = new css_psn__c();
        psn.CSS_Claims__c= claim.id;
        psn.Before_In_Service__c= true;
        psn.Failure_Date__c = date.today()-2;
        insert psn;
        
        bl.psnRec=psn;
        Id RecordTypeIdmkmdl = Schema.SObjectType.CSS_Make_Model_Access__c.getRecordTypeInfosByName().get('SRTData').getRecordTypeId();
        
        CG_CL_ClaimsUEOneBMS onebms = new CG_CL_ClaimsUEOneBMS();
        onebms.mainContr = BL;
        onebms.checkFailureDate();
    }
    
    public static Testmethod void TestForNoOnPopUp(){
        
        CG_CL_ClaimsIntake BL = new CG_CL_ClaimsIntake();
        bl.existingPSN = '79464646';
        
        css_claims__c claim = new css_claims__c();
        claim.Customer_Name__c='Oliver Trucking';
        claim.Customer_Code__c='123456';
        insert claim;    
        
        /*  css_psn__c psn = new css_psn__c();
psn.CSS_Claims__c= claim.id;
psn.PSN__c= '79464646';
psn.Make__c = 'test';
insert psn; */
        
        css_header_nav__c headNav = new css_header_nav__c();
        headNav.Name = 'Sneha';
        headNav.RSWButtonEnable__c = true;
        insert headNav;
        
        CG_CL_ClaimsUEOneBMS onebms = new CG_CL_ClaimsUEOneBMS();
        onebms.mainContr = BL;
        BL.filterMake = 'test';
        onebms.recconFlag=true;
        onebms.noOnPopUp();
        //onebms.startRequest();
    }
    
    
    public static Testmethod void TestForYesOnPopUp(){
        
        //Test.setMock(WebServiceMock.class, new CSS_GetEngineDataPlate_Test()); 
        // Test.setMock(WebServiceMock.class, new CSS_GetWarrantyDocs_Test());
        //Test.setMock(HttpCalloutMock.class, new CG_CampaignMock_Test());
        Account acc = new Account();
        acc.name='Kenworth Sales Co';
        acc.CSS_DistributorCode__c='02650';
        acc.IAM_Service_Provider_Code__c='97895';
        acc.Product_Certification__c = true;
        acc.CERTIFICATION_END_DATE__c = system.today() + 30;
        acc.Region__c = 'North America';
        acc.type='Dealer Account';
        insert acc;

        Id testsaveClaimedid;
        CG_CL_ClaimsIntake testobj=new CG_CL_ClaimsIntake();
        CSS_Claims__c testclaimsRec = new CSS_Claims__c();
        CSS_PSN__c testpsnNewRec = new CSS_PSN__c();
        testclaimsRec.Customer_Name__c='TestCustomer';
        testclaimsRec.Customer_Code__c = '1234';
        testclaimsRec.Contact_Last_Name__c = 'T';
        testclaimsRec.Address__c = 'T';
        testclaimsRec.Customer_Contact_Phone__c = null;
        testclaimsRec.Email_Address__c = 'rp@sct.com';
        testclaimsRec.Status__c = 'Draft';
        testclaimsRec.Account__c = acc.id;
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
        testclaimsRec.ETOOldESN__c='78565656';
        testclaimsRec.EtoConversionDate__c=system.today();
        testclaimsRec.IsCopyclaim__c=true; 
        testclaimsRec.SP_WarrantyCertificationEndDate__c=string.valueOf(date.today());
        insert testclaimsRec;
        
        Id testclaimsRecId = testclaimsRec.Id;
        
        List<CSS_PSN__c> delPsn =new List<CSS_PSN__c>();
        CSS_PSN__c testpsnNewRec1 = new CSS_PSN__c();
        testpsnNewRec1.psn__c = '79464646';
        testpsnNewRec1.Primary__C = false;
        testpsnNewRec1.failure_Date__c = system.today()-2;
        testpsnNewRec1.Warranty_Start_Date__c=date.today()+12;
        testpsnNewRec1.css_claims__C = testclaimsRec.id;
        insert testpsnNewRec1;
        
        delPsn.add(testpsnNewRec);
        Id testpsnNewRecId = testpsnNewRec.Id;
        List<CSS_Solution_Component__c> delFailures=new List<CSS_Solution_Component__c>();
        CSS_Solution_Component__c solRec =new CSS_Solution_Component__c();
        solRec.ODM_Status__c = 'YTBV';
        solRec.CSS_Claims__c=testclaimsRec.Id;
        insert solRec;
        delFailures.add(solRec);
       
        List<CSS_SRT__c> delSRTs=new List<CSS_SRT__c>();
        CSS_SRT__c srtRec = new CSS_SRT__c();
        srtRec.ODM_Status__c = 'YTBV';
        srtRec.CSS_Claims__c=testclaimsRec.Id;
        insert srtRec;
        delSRTs.add(srtRec);
        
        List<CSS_Claim_Submission__c> delClaimSubmission=new List<CSS_Claim_Submission__c>();
        CSS_Claim_Submission__c sub=new CSS_Claim_Submission__c();
        sub.CSS_Claims__c=testclaimsRec.Id;
        insert sub;
        delClaimSubmission.add(sub);
        /* List<Note> delNotes=new List<Note>();
Note n=new Note();
n.ParentId=testclaimsRec.id;
insert n;
delNotes.add(n);
List<Attachment> delatt=new List<Attachment>();
Attachment a=new Attachment();
a.ParentId=testclaimsRec.id;
insert a;
delatt.add(a);*/
        
        testclaimsRec =[Select Id,CSS_Job__r.General_Symptoms__c,Account__c,CSS_Job__r.Category_Desc__c,CSS_Job__r.Complaint_Type_Desc__c,CSS_Job__r.Category2_Desc__c,
                        CSS_Job__r.Complaint_Type2_Desc__c,CSS_Job__r.Category3_Desc__c,CSS_Job__r.Complaint_Type3_Desc__c,CSS_Job__r.Category4_Desc__c,
                        CSS_Job__r.Complaint_Type4_Desc__c,CSS_Job__r.Category5_Desc__c,CSS_Job__r.Complaint_Type5_Desc__c,Claims_General_Symptoms__c,
                        Claims_Preventive_Maintenance__c,SP_WarrantyCertificationEndDate__c,ProductApplicationCode__c,Claims_Category__c,Claims_Category2__c,Claims_Category3__c,Claims_Category4__c,Claims_Category5__c,
                        Complaint_Type_Desc__c,Complaint_Type2_Desc__c,Complaint_Type3_Desc__c,Complaint_Type4_Desc__c,Complaint_Type5_Desc__c,IsCopyclaim__c,
                        Claims_Expedited_Service__c,Status__c,ODM_Status__c,Claims_Additional_Comments__c,Claims_Category_Desc__c,Claims_Category2_Desc__c,
                        Claims_Category3_Desc__c,Claims_Category4_Desc__c,Claims_Category5_Desc__c,Claims_Complaint_Type__c,Claims_Complaint_Type2__c,
                        Claims_Complaint_Type3__c,Claims_Complaint_Type4__c,account__r.RSS_RESP_BRANCH_CODE__c,SP_PrimaryOEMCode__c,Claims_Complaint_Type5__c,CSS_Job__r.createdDate,Customer_Name__c,Location__c,
                        Location_Code__c,CSS_Job__c,CSS_Job__r.name,Shop_Work_Order__c,SP_Country__c,EngineFamilyName__c,LastModifiedDate,Name, ESN__c, createdDate,Region__c,Territory__c,
                        CoverageResponse__c,Claim_Submitted__c,Account__r.Enable_Claims__c, Account__r.Region__c,Account__r.CERTIFICATION_END_DATE__c,Account__r.Product_Certification__c,Account__r.Warranty_Training_Status__c,Distributor_Authorization_FN__c,
                        CreatedBy.Name,Account__r.Warranty_Training_Certification__c,TSR1__c,TSR2__c,TSR3__c,TSR4__c,TSR5__c,TSR6__c,TSR7__c,TSR8__c,TSR9__c,
                        TSR10__c,CSS_Job__r.CSS_In_Shop_Labor_Rate__c,CSS_Job__r.CSS_Field_Service_Labor_Rate__c,CSS_Job__r.CSS_Travel_Rate__c, Catastrophic__c,
                        DesignPhaseCode__c, Service_Model__c,CSS_Channel_Of_Distribution__c,SP_LTA_FLAG__c,SP_PACCAR__c,SP_ACCOUNT_STATUS__c,SP_TERRITORY_CODE__c,
                        SP_PromotionId__c,Repair_Location__c, BillToCode__c, BuildDate__c, EngineFamilyCode__c, EtoConversionDate__c, MarineFlag__c, OemCode__c, 
                        ProductApplicationDesp__c, warrantyIndicatorFlag__c, SP_CHANNEL_OF_DISTRIBUTION__c, CSS_Channel_Code__c, SP_CLAIM_ALLOWED_DAYS__c, 
                        SP_Group_Name__c, SP_CMI_SP_EXPIRATION__c, SP_SCMDollarAmt__c,SP_WarrantyTrainingStatus__c,SP_State__c,SP_SCMDeductiblePercentage__c,
                        SP_OUTFILE_ALL_CLAIMS__c, SP_REGION__c, SP_REGIONCODE__c, SP_TERRITORY__c, CSS_Job__r.Shop_Work_Order__c,Automotive_App_Flag__c,  
                        (Select Id,Name,PSN__c,Make__c,Model__c,Before_In_Service__c,Mission_Disabling__c,Calibration_After__c,Calibration_Before__c,VIN__c,
                         Service_Model__c,Application__c,ApplicationCode__c,Qsol_Engine_Family_Code__c, Failure_Date__c,Mileage__c,Mileage_Measure__c,Justification__c,Unit_Number__c,
                         Warranty_Start_Date__c,Product_Hours__c,CoverageFlag__c, CSS_Claims__c from CSS_PSNs__r where Primary__c=true Limit 1) 
                        from CSS_Claims__c limit 1];
        
        Profile p = [SELECT Id FROM Profile WHERE Name='CSS_Service_Advanced']; 
        User usr = new User(Alias = 'standt', Email='standarduser4@testorg.com', 
                            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                            LocaleSidKey='en_US',  ProfileId = p.Id, 
                            TimeZoneSidKey='America/Los_Angeles', UserName='UtilityTestUser14@testorg.com',User_Location__c = '56270-56270');
        insert usr;
        system.debug('usr**'+usr);
        CSS_accountLanguage__c accLan = new CSS_accountLanguage__c();
        accLan.CSS_QsolLanguage__c = 'en';
        accLan.Name = 'en_US';
        insert accLan;
        testobj.psnRec = testpsnNewRec;
        testobj.filterMake = 'ACE';
        testobj.filterModel = 'QSB-44-T2';
        testobj.userObj = usr;
        testObj.claimsRec=testclaimsRec;
        
        CSS_Integration_Details__c inte = new CSS_Integration_Details__c();
        Blob key = Blob.valueOf('12345678901234567890123456789012');
        string algo = 'AES256';
        inte.Name = 'CSS_SPDataLookup';
        inte.Username__c = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('test')));
        inte.Passcode__c = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('test')));
        inte.Key__c = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('1234')));
        inte.ApplicationName__c = 'CSS_SPDataLookup';
        inte.End_Point__c = 'https://services-stg.cummins.com/csswarranty/serviceproviderdata';
        inte.IsActive__c = true;
        insert inte;
        CSS_Integration_Details__c conDetails = new CSS_Integration_Details__c();
        conDetails.Name = 'GetCampaign';
        conDetails.AuthEnv__c = 'OAGOAUTH';
        conDetails.ApplicationName__c = 'GetCampaign';
        conDetails.End_Point__c = 'https://services-stg.cummins.com/csswarranty/GetCampaign';
        conDetails.Method_Type__c = 'POST';
        conDetails.Timeout__c = 2.0;
        condetails.IsActive__c=true;
        insert conDetails;
        system.debug('***inte***'+inte);
        CG_CL_ClaimsUEOneBMS claimsUEOneBMS = new CG_CL_ClaimsUEOneBMS();
        //claimsUEOneBMS.warrStDtHidden = 'test';
        claimsUEOneBMS.warrStDtHidden = '10/2/2019';
        claimsUEOneBMS.recconFlag=true;
   //     ClaimsUEOneBMS.mainContr = testObj;
        Test.setMock(HttpCalloutMock.class, new CSS_getEngineDataResponseJ2A_Mockup_Test());
        //Test.setMock(HttpCalloutMock.class, new CSS_GetServiceProviderResponseMock_Test());
        // Test.setMock(HttpCalloutMock.class, new CSS_GetSerProResponseNewMock_Test());
        system.debug('start>>>');
        //test.startTest();
       // claimsUEOneBMS.startRequest();
        system.debug('stop>>>');
        //test.stopTest();
        CSS_Solution_Component__c solRec1 =new CSS_Solution_Component__c();
        solRec1.ODM_Status__c = 'YTBV';
        solRec1.CSS_Claims__c=testclaimsRec.Id;
        insert solRec1;
        list<CSS_Parts_Options__c> lstparts = new list <CSS_Parts_Options__c>(); 
        CSS_Parts_Options__c partRec1 =new CSS_Parts_Options__c();
        partRec1.selected_part__c=true;
        partRec1.Service_partnumber__c='542679';
        partRec1.OEM__c='OEMWRS';
        partRec1.Part_Name__c='Test';
        partRec1.ReturnToFactory__c='Campaign-TRP-ATC';
        PartRec1.Replacement_Reason__c='Campaign-TRP-ATC';
        partrec1.Quantity__c=55;
        partrec1.Notes__c='Hai';
        //partrec.Service_Job__c=''
        partRec1.ODM_Status__c = 'YTBV';
        partRec1.CSS_Claims__c=testclaimsRec.Id;
        //insert partRec;
        lstparts.add(partrec1);
        //delete lstparts;
        CSS_SRT__c srtRec1 = new CSS_SRT__c();
        srtRec1.ODM_Status__c = 'YTBV';
        srtRec1.CSS_Claims__c=testclaimsRec.Id;
        insert srtRec1;
        
        Test.setMock(HttpCalloutMock.class, new CSS_getEngineDataFrmSiebel_Test()); 
        CSS_getEngineDataResponseJ2A enginereq = new CSS_getEngineDataResponseJ2A();        
        CSS_getEngineDataResponseJ2A.DataArea Req = new CSS_getEngineDataResponseJ2A.DataArea();
        
        Req.WarrantyStartDate = '2015-02-09';
        Req.buildDate= '2015-02-09';
        Req.EtoConversionDate='2015-02-09';
        Req.ShipDate='2015-02-09';
        Test.setMock(WebServiceMock.class, new CSS_GetEngineDataPlate_Test()); 
        Test.setMock(WebServiceMock.class, new CSS_GetWarrantyDocs_Test());
        Test.setMock(HttpCalloutMock.class, new CG_CampaignMock_Test());
        String json = '{\"DataArea\":{\"Policy\": \"Y\",\"GroupName\": \"\",\"RegionCode\": \"USCA\",\"PromotionId\": \"Y\",'+
            '\"RepairLevel\": \"N\",\"ViewDollarAmount\": \"N\",\"PrimaryOEMName\": \"CUMMINS\",\"AccountStatus\": \"Active\",'+
            '\"MaxClaimAmt\": \"999999\",\"WWSPSSPFlag\": \"Y\",\"CommunicationOccurrence\": \"\",\"FreezeSubmitButton\": \"N\",'+
            '\"Territory\": \"UNITED STATES\",\"LTAFlag\": \"N\",\"SPCountry\": \"USA\",\"CommunicationMethod\": \"\",'+
            '\"PACCAR\": \"N\",\"State\": \"PA\",\"BusinessUnit\": \"CMI\",\"Region\": \"NORTH AMERICA\",\"WarrantyFax\": \"215 785-6151\",'+
            '\"SCMDollarAmt\": \"30000\",'+
            '\"WarrantyEmail\": \"anthony.j.miriello@cummins.com\",'+
            '\"DistributorHQName\": \"CSSNA- EAST REGION\",'+
            '\"SCMDeductiblePercentage\": \"3\",'+
            '\"ChannelCode\": \"101\",'+
            '\"DSID\": \"N\",'+
            '\"FieldServiceLaborRate\": \"137\",'+
            '\"TravelRate\": \"1.21\",'+
            '\"ClaimAllowedDays\": \"365\",'+
            '\"WarrantyCertificationEndDate\": \"2017-12-11 00:00:00.0\",'+
            '\"WarrantyTrainingCertification\": \"N\",'+
            '\"NewOEM\": \"N\",'+
            '\"TerritoryCode\": \"100\",'+
            '\"PSBUProductCertification\": \"N\",'+
            '\"DTNAFlag\": \"N\",'+
            '\"ChannelOfDistribution\": \"101-DISTRIBUTOR-BRANCH\",'+
            '\"PrimaryOEMCode\": \"103\",'+
            '\"OutfileAllClaims\": \"N\",'+
            '\"DisableWebAccessFlag\": \"N\",'+
            '\"ProductCertification\": \"N\",'+
            '\"CutOffClaimAmt\": \"250\",'+
            '\"DistributorHQCode\": \"02850\",'+
            '\"WarrantyTrainingStatus\": \"R\",'+
            '\"CMISPExpirationDate\": \"2019-06-25 00:00:00.0\",'+
            '\"InShopLaborRate\": \"137\",'+
            '\"CostEffectiveExclusion\": \"N\",\"PMUSplitPayment\": \"Y\",\"TechActualHoursRequired\": \"N\",\"CampaignTRP\": \"Y\"},\"Header\": {\"Status\": \"Success\"}}';
        CSS_GetServiceProviderResponse obj = CSS_GetServiceProviderResponse.parse(json);
     //   claimsUEOneBMS.spdataAssign(obj);
     CG_CL_ClaimsIntake mainContr = new CG_CL_ClaimsIntake();
        testclaimsRec.Id = testclaimsRecId;
        mainContr.claimsRec = testclaimsRec;
        mainContr.psnRec = testpsnNewRec;
        testpsnNewRec.css_claims__C = testclaimsRec.id;
        
        //mainContr.psnRec = testpsnNewRec;
        
        List<CSS_Parts_Options__c> delParts=new List<CSS_Parts_Options__c>();
        CSS_Parts_Options__c partRec =new CSS_Parts_Options__c();
        partRec.ODM_Status__c = 'YTBV';
        partRec.CSS_Claims__c=mainContr.claimsRec.id;
        insert partRec;
        delParts.add(partRec);
        CSS_PSN__c psn = new CSS_PSN__c();
        psn.CSS_Claims__c = testclaimsRec.id;
        psn.License_Plate_State__c = 'Select One'; 
        psn.Unit_Number__c = '';
        psn.Mileage__c = null;
        psn.Product_Hours__c = null;
        psn.Before_In_Service__c = false;
        psn.Mission_Disabling__c = false;
        psn.Calibration_Before__c = '';
        psn.Revision_Before__c = '';
        psn.Calibration_After__c = '';
        psn.Revision_After__c = '';
        psn.Justification__c = '';
        psn.Failure_Date__c = system.today();
        psn.Failure_Date__c = system.today();
        insert psn;
        psn.Failure_Date__c = system.today()-1;
        psn.Failure_Date__c = system.today()-1;
        update psn;
        mainContr.psnRec = psn;
       
        
        
        
       claimsUEOneBMS.mainContr = mainContr;
        claimsUEOneBMS.yesOnPopUp();
       // claimsUEOneBMS.startRequest();
    }
    
    
    public static Testmethod void TestForGetEngineDataWS(){
        
        Test.setMock(WebServiceMock.class, new CSS_GetEngineDataPlate_Test()); 
        Test.setMock(WebServiceMock.class, new CSS_GetWarrantyDocs_Test());
        Test.setMock(HttpCalloutMock.class, new CG_CampaignMock_Test());
        
        CG_CL_ClaimsUEOneBMS claimsUEOneBMS = new CG_CL_ClaimsUEOneBMS();
        Id testsaveClaimedid;
        claimsUEOneBMS.recconFlag=true;
        
        CG_CL_ClaimsIntake testobj=new CG_CL_ClaimsIntake();
        CSS_Claims__c testclaimsRec = new CSS_Claims__c();
        testclaimsRec.ProductApplicationCode__c = 'test';
        testclaimsRec.ProductApplicationDesp__c = 'ing';
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
        testclaimsRec.SP_WarrantyCertificationEndDate__c = string.valueOf(date.Today());
        testclaimsRec.SP_WarrantyTrainingStatus__c='R';
        testclaimsRec.SP_WarrantyCertificationEndDate__c=string.valueOf(date.Today());
        insert testclaimsRec;
        Id testclaimsRecId = testclaimsRec.Id;
        
        CSS_PSN__c testpsnNewRec = new CSS_PSN__c();
        testpsnNewRec.psn__c = '79464646';
        testpsnNewRec.Primary__C = true;
        testpsnNewRec.failure_Date__c = date.today()+200;
        testpsnNewRec.Warranty_Start_Date__c=date.today()+12;
        testpsnNewRec.css_claims__C = testclaimsRec.id;
        testpsnNewRec.ProductAppcodeErrorflag__c = true;
        insert testpsnNewRec;
        Id testpsnNewRecId = testpsnNewRec.Id;
        
        testclaimsRec =[Select Id,CSS_Job__r.General_Symptoms__c,Account__c,CSS_Job__r.Category_Desc__c,CSS_Job__r.Complaint_Type_Desc__c,CSS_Job__r.Category2_Desc__c,
                        CSS_Job__r.Complaint_Type2_Desc__c,CSS_Job__r.Category3_Desc__c,CSS_Job__r.Complaint_Type3_Desc__c,CSS_Job__r.Category4_Desc__c,
                        CSS_Job__r.Complaint_Type4_Desc__c,CSS_Job__r.Category5_Desc__c,CSS_Job__r.Complaint_Type5_Desc__c,Claims_General_Symptoms__c,
                        Claims_Preventive_Maintenance__c,SP_WarrantyCertificationEndDate__c,ProductApplicationCode__c,Claims_Category__c,Claims_Category2__c,Claims_Category3__c,Claims_Category4__c,Claims_Category5__c,
                        Complaint_Type_Desc__c,Complaint_Type2_Desc__c,Complaint_Type3_Desc__c,Complaint_Type4_Desc__c,Complaint_Type5_Desc__c,IsCopyclaim__c,
                        Claims_Expedited_Service__c,Status__c,ODM_Status__c,Claims_Additional_Comments__c,Claims_Category_Desc__c,Claims_Category2_Desc__c,
                        Claims_Category3_Desc__c,Claims_Category4_Desc__c,Claims_Category5_Desc__c,Claims_Complaint_Type__c,Claims_Complaint_Type2__c,
                        Claims_Complaint_Type3__c,Claims_Complaint_Type4__c,account__r.RSS_RESP_BRANCH_CODE__c,SP_PrimaryOEMCode__c,Claims_Complaint_Type5__c,CSS_Job__r.createdDate,Customer_Name__c,Location__c,
                        Location_Code__c,CSS_Job__c,CSS_Job__r.name,Shop_Work_Order__c,SP_Country__c,EngineFamilyName__c,LastModifiedDate,Name, ESN__c, createdDate,Region__c,Territory__c,
                        CoverageResponse__c,Claim_Submitted__c,Account__r.Enable_Claims__c,Account__r.Warranty_Training_Status__c,Distributor_Authorization_FN__c,
                        CreatedBy.Name,Account__r.Warranty_Training_Certification__c,TSR1__c,TSR2__c,TSR3__c,TSR4__c,TSR5__c,TSR6__c,TSR7__c,TSR8__c,TSR9__c,
                        TSR10__c,CSS_Job__r.CSS_In_Shop_Labor_Rate__c,CSS_Job__r.CSS_Field_Service_Labor_Rate__c,CSS_Job__r.CSS_Travel_Rate__c, Catastrophic__c,
                        DesignPhaseCode__c, Service_Model__c,CSS_Channel_Of_Distribution__c,SP_LTA_FLAG__c,SP_PACCAR__c,SP_ACCOUNT_STATUS__c,SP_TERRITORY_CODE__c,
                        SP_PromotionId__c,Repair_Location__c, BillToCode__c, BuildDate__c, EngineFamilyCode__c, EtoConversionDate__c, MarineFlag__c, OemCode__c, 
                        ProductApplicationDesp__c, warrantyIndicatorFlag__c, SP_CHANNEL_OF_DISTRIBUTION__c, CSS_Channel_Code__c, SP_CLAIM_ALLOWED_DAYS__c, 
                        SP_Group_Name__c, SP_CMI_SP_EXPIRATION__c, SP_SCMDollarAmt__c,SP_WarrantyTrainingStatus__c,SP_State__c,SP_SCMDeductiblePercentage__c,
                        SP_OUTFILE_ALL_CLAIMS__c, SP_REGION__c, SP_REGIONCODE__c, SP_TERRITORY__c, CSS_Job__r.Shop_Work_Order__c,Automotive_App_Flag__c,  
                        (Select Id,Name,PSN__c,Make__c,Model__c,Before_In_Service__c,Mission_Disabling__c,Calibration_After__c,Calibration_Before__c,VIN__c,
                         Service_Model__c,Application__c,ApplicationCode__c,Qsol_Engine_Family_Code__c, Failure_Date__c,Mileage__c,Mileage_Measure__c,Justification__c,Unit_Number__c,
                         Warranty_Start_Date__c,Product_Hours__c,CoverageFlag__c, CSS_Claims__c from CSS_PSNs__r where Primary__c=true Limit 1) 
                        from CSS_Claims__c where id=:testclaimsRec.id];
        //  testclaimsRec.Failure_Date__c=System.today()+1;
        
        Profile p = [SELECT Id FROM Profile WHERE Name='CSS_Service_Advanced']; 
        User usr = new User(Alias = 'standt', Email='standarduser4@testorg.com', 
                            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                            LocaleSidKey='en_US',  ProfileId = p.Id, 
                            TimeZoneSidKey='America/Los_Angeles', UserName='UtilityTestUser14@testorg.com',User_Location__c = '56270-56270');
        insert usr;
        system.debug('usr**'+usr);
        CSS_accountLanguage__c accLan = new CSS_accountLanguage__c();
        accLan.CSS_QsolLanguage__c = 'en';
        accLan.Name = 'en_US';
        insert accLan;
        account a = new account();
        a.name = 'test';
        a.CSS_DistributorCode__c= '56270';
        a.IAM_Service_Provider_Code__c= '56270';
        a.Type='Dealer Account';
        a.Region__c = 'US and Canada';
        a.CMI_Account_Status__c = 'Active';
        // a.IAM_Service_Provider_Code__c = '562551';
        //a.IAM_Service_Provider_Code__c = '33333';
        
        insert a;
        CSS_Accreditation__c a1 = new CSS_Accreditation__c();
        a1.Service_Model_Name__c = 'nkm';
        a1.Account__c = a.Id;
        a1.StartDate__c = date.today();
        a1.EndDate__c = date.today()+30;
        // a1.Make__c = 'ACE';
        //  a1.Model__c = 'QSB-44-T2';
        insert a1;
        //  mainContr = [SELECT id, EndDate__c,Service_Model_Name__c,StartDate__c,Account__c,Account__r.Location__c FROM  where Account__r.Location__c =: mainContr.userObj.User_Location__c];
        
        /* testobj.psnRec = testpsnNewRec;
testobj.filterMake = 'ACE';
testobj.filterModel = 'QSB-44-T2';
testobj.userObj = user;*/
        
        //ClaimsUEOneBMS.mainContr = testObj;
        CSS_Integration_Details__c conDetails = new CSS_Integration_Details__c();
        conDetails.Name = 'GetCampaign';
        conDetails.AuthEnv__c = 'OAGOAUTH';
        conDetails.ApplicationName__c = 'GetCampaign';
        conDetails.End_Point__c = 'Test';
        conDetails.Method_Type__c = 'POST';
        conDetails.Timeout__c = 2.0;
        insert conDetails;
        
        List<CSS_List_Of_Values__c> listOfValue = new List<CSS_List_Of_Values__c>();
        CSS_List_Of_Values__c lOfValue = new CSS_List_Of_Values__c();
        lOfValue.Code__c = '123';
        lOfValue.Name = 'test';
        insert lOfValue;
        
        listOfValue.add(lOfValue);
        
        
        CG_CL_ClaimsIntake mainContr = new CG_CL_ClaimsIntake();
        testclaimsRec.Id = testclaimsRecId;
        mainContr.claimsRec = testclaimsRec;
        mainContr.userObj = usr;
        mainContr.psnRec = testpsnNewRec;
        mainContr.psnRec.Id = testpsnNewRec.Id;
        mainContr.psnRec.Failure_Date__c=System.today()+1;
        mainContr.filterMake = 'ACE';
        mainContr.filterModel = 'QSB-44-T2';
        mainContr.psnRec.PSN__c=null;
        claimsUEOneBMS.mainContr = mainContr;
        
        CSS_Integration_Details__c inteDetails = new CSS_Integration_Details__c();
        inteDetails.Name = 'CSS_SPDataLookup';
        inteDetails.ApplicationName__c = 'CSS_SPDataLookup';
        inteDetails.End_Point__c = 'https://services-stg.cummins.com/csswarranty/serviceproviderdata';
        inteDetails.IsActive__c = true;
        inteDetails.Key__c = 'DqOMliimooXThF1e2jaIPuaiu3SQndU0mwfHxspQYC0';
        inteDetails.Passcode__c = 'S8wjknFfHQk80axJn3OibETXc/600kyrLA8oUaxFKJ4=';
        inteDetails.Username__c = 'qay1+7OVYoeaAeq5V5oXd+XpT8T5kyqP4YcyQI+pLdM=';
        insert inteDetails;    
        test.startTest();
        
        Test.setMock(HttpCalloutMock.class, new CSS_getEngineDataFrmSiebel_Test());
        Test.setMock(HttpCalloutMock.class, new CSS_getEngineDataResponseJ2A_Mockup_Test());
        Test.setMock(HttpCalloutMock.class, new CSS_GetSPDataWSMock_Test());
        Test.setMock(HttpCalloutMock.class, new CG_CampaignMock_Test());
        
        system.debug('TESTING');
        claimsUEOneBMS.getCampaignDetails();
        String json = '{\"DataArea\":{\"Policy\": \"Y\",\"GroupName\": \"\",\"RegionCode\": \"USCA\",\"PromotionId\": \"Y\",'+
            '\"RepairLevel\": \"N\",\"ViewDollarAmount\": \"N\",\"PrimaryOEMName\": \"CUMMINS\",\"AccountStatus\": \"Active\",'+
            '\"MaxClaimAmt\": \"999999\",\"WWSPSSPFlag\": \"Y\",\"CommunicationOccurrence\": \"\",\"FreezeSubmitButton\": \"N\",'+
            '\"Territory\": \"UNITED STATES\",\"LTAFlag\": \"N\",\"SPCountry\": \"USA\",\"CommunicationMethod\": \"\",'+
            '\"PACCAR\": \"N\",\"State\": \"PA\",\"BusinessUnit\": \"CMI\",\"Region\": \"NORTH AMERICA\",\"WarrantyFax\": \"215 785-6151\",'+
            '\"SCMDollarAmt\": \"30000\",'+
            '\"WarrantyEmail\": \"anthony.j.miriello@cummins.com\",'+
            '\"DistributorHQName\": \"CSSNA- EAST REGION\",'+
            '\"SCMDeductiblePercentage\": \"3\",'+
            '\"ChannelCode\": \"101\",'+
            '\"DSID\": \"N\",'+
            '\"FieldServiceLaborRate\": \"137\",'+
            '\"TravelRate\": \"1.21\",'+
            '\"ClaimAllowedDays\": \"365\",'+
            '\"WarrantyCertificationEndDate\": \"2017-12-11 00:00:00.0\",'+
            '\"WarrantyTrainingCertification\": \"Y\",'+
            '\"NewOEM\": \"N\",'+
            '\"TerritoryCode\": \"100\",'+
            '\"PSBUProductCertification\": \"N\",'+
            '\"DTNAFlag\": \"N\",'+
            '\"ChannelOfDistribution\": \"101-DISTRIBUTOR-BRANCH\",'+
            '\"PrimaryOEMCode\": \"103\",'+
            '\"OutfileAllClaims\": \"N\",'+
            '\"DisableWebAccessFlag\": \"N\",'+
            '\"ProductCertification\": \"Y\",'+
            '\"CutOffClaimAmt\": \"250\",'+
            '\"DistributorHQCode\": \"02850\",'+
            '\"WarrantyTrainingStatus\": \"G\",'+
            '\"CMISPExpirationDate\": \"2019-06-25 00:00:00.0\",'+
            '\"InShopLaborRate\": \"137\",'+
            '\"CostEffectiveExclusion\": \"N\",\"PMUSplitPayment\": \"Y\",\"TechActualHoursRequired\": \"N\",\"CampaignTRP\": \"Y\"},\"Header\": {\"Status\": \"Success\"}}';
        CSS_GetServiceProviderResponse obj = CSS_GetServiceProviderResponse.parse(json);
        claimsUEOneBMS.spdataAssign(obj);
        CG_CL_ClaimsIntake mainContr1 = new CG_CL_ClaimsIntake();
        mainContr1.filterApplication = 'zxcv';
        
        CSS_JobEventTemporary__c JETproductcode = new CSS_JobEventTemporary__c();
        JETproductcode.Key__c = 'MarketingApplicationCodes';
        JETproductcode.Attribute1__c = 'test';
        JETproductcode.Attribute3__c = 'ing';
        JETproductcode.Attribute2__c = 'TE-ST';
        //JETproductcode.Attribute5__c = 'Testing';
        JETproductcode.Attribute5__c = 'zxcv';
        JETproductcode.Reason__c='{"DataArea": {"Details": [{"ApplicationCode": "123","Description": "abc","BusinessUnit": "EBU","AutomotiveFlag": "Y","MarineFlag": "","ActiveFlag": "Y","DefaultUom": "miles"},{"ApplicationCode": "555","Description": "zxcv","BusinessUnit": "PSBU","AutomotiveFlag": "","MarineFlag": "N","ActiveFlag": "Y","DefaultUom": "miles"}]},"Header": {"ReturnCodeDescription": "","Status": "Success"}}';
        insert JETproductcode;
        claimsUEOneBMS.getApplication();
        //claimsUEOneBMS.ProductAppcodeErrorflag__c=true;81,946
        claimsUEOneBMS.startRequest();
        claimsUEOneBMS.updateproductappcode();
        claimsUEOneBMS.parseQSOLDate('12 Jan 2019');
        claimsUEOneBMS.parseQSOLDate('12 Feb 2019');
        claimsUEOneBMS.parseQSOLDate('12 Mar 2019');
        claimsUEOneBMS.parseQSOLDate('12 Apr 2019');
        claimsUEOneBMS.parseQSOLDate('12 May 2019');
        claimsUEOneBMS.parseQSOLDate('12 Jun 2019');
        claimsUEOneBMS.parseQSOLDate('12 Jul 2019');
        claimsUEOneBMS.parseQSOLDate('12 Aug 2019');
        claimsUEOneBMS.parseQSOLDate('12 Sep 2019');
        claimsUEOneBMS.parseQSOLDate('12 Oct 2019');
        claimsUEOneBMS.parseQSOLDate('12 Nov 2019');
        claimsUEOneBMS.parseQSOLDate('12 Dec 2019');
        
        test.stoptest();
        
    }
     public static Testmethod void TestForGetEngineDataWS111(){
        
        Profile p = [SELECT Id FROM Profile WHERE Name='CSS_Service_Advanced']; 
        User usr = new User(Alias = 'standt', Email='standarduser4@testorg.com', 
                            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                            LocaleSidKey='en_US',  ProfileId = p.Id, 
                            TimeZoneSidKey='America/Los_Angeles', UserName='UtilityTestUser14@testorg.com',User_Location__c = '56270-56270');
        insert usr;
        system.debug('usr**'+usr);
        CSS_accountLanguage__c accLan = new CSS_accountLanguage__c();
        accLan.CSS_QsolLanguage__c = 'en';
        accLan.Name = 'en_US';
        insert accLan;
         LIst<Account> alist = new list<Account>();
        Account a = new Account();
            a.name='Kenworth Sales Co';
            a.CSS_DistributorCode__c='02466';
            a.IAM_Service_Provider_Code__c='19134';
            a.Type='Dealer Account';
            a.CMI_Account_Status__c = 'Active';
            alist.add(a);
            insert alist; 
        
        CSS_Accreditation__c a1 = new CSS_Accreditation__c();
        a1.Service_Model_Name__c = 'nkm';
        a1.Account__c = a.Id;
        a1.StartDate__c = date.today();
        a1.EndDate__c = date.today()+30;
        insert a1;
        
        
        
        Test.setMock(WebServiceMock.class, new CSS_GetEngineDataPlate_Test()); 
         Test.setMock(WebServiceMock.class, new CSS_GetWarrantyDocs_Test());
        Test.setMock(HttpCalloutMock.class, new CG_CampaignMock_Test());
        
        CG_CL_ClaimsUEOneBMS claimsUEOneBMS = new CG_CL_ClaimsUEOneBMS();
        Id testsaveClaimedid;
        claimsUEOneBMS.recconFlag=true;
        
        CG_CL_ClaimsIntake testobj=new CG_CL_ClaimsIntake();
        CSS_Claims__c testclaimsRec = new CSS_Claims__c();
        testclaimsRec.Account__c = a.id;
        testclaimsRec.ProductApplicationCode__c = 'test';
        testclaimsRec.ProductApplicationDesp__c = 'ing';
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
        testclaimsRec.ShipDate__c=System.today();
        testclaimsRec.ZipCode__c = '12345-1234';
        testclaimsRec.SP_WarrantyTrainingStatus__c='R';
        testclaimsRec.SP_WarrantyCertificationEndDate__c=string.valueOf(date.Today());
        insert testclaimsRec;
        Id testclaimsRecId = testclaimsRec.Id;
        
        CSS_PSN__c testpsnNewRec = new CSS_PSN__c();
        testpsnNewRec.psn__c = '79464646';
        testpsnNewRec.Primary__C = true;
        testpsnNewRec.failure_Date__c = date.today()-2;
        testpsnNewRec.Warranty_Start_Date__c=date.today()-30;
        testpsnNewRec.css_claims__C = testclaimsRec.id;
        testpsnNewRec.ProductAppcodeErrorflag__c = true;
        testpsnNewRec.Before_In_Service__c=false;
        insert testpsnNewRec;
        Id testpsnNewRecId = testpsnNewRec.Id;
        
        testclaimsRec =[Select Id, (Select Id,Name from CSS_PSNs__r where Primary__c=true Limit 1)
                        FROM CSS_Claims__c where id=:testclaimsRec.id];
        
        
      
        //accredList = [SELECT id, EndDate__c,Service_Model_Name__c,StartDate__c,Account__c,Account__r.Location__c FROM  where Account__r.Location__c =: mainContr.userObj.User_Location__c];
        
        /* testobj.psnRec = testpsnNewRec;
testobj.filterMake = 'ACE';
testobj.filterModel = 'QSB-44-T2';
testobj.userObj = usr;*/
        
        //ClaimsUEOneBMS.mainContr = testObj;
        CSS_Integration_Details__c conDetails = new CSS_Integration_Details__c();
        conDetails.Name = 'GetCampaign';
        conDetails.AuthEnv__c = 'OAGOAUTH';
        conDetails.ApplicationName__c = 'GetCampaign';
        conDetails.End_Point__c = 'Test';
        conDetails.Method_Type__c = 'POST';
        conDetails.Timeout__c = 2.0;
        insert conDetails;
        
        List<CSS_List_Of_Values__c> listOfValue = new List<CSS_List_Of_Values__c>();
        CSS_List_Of_Values__c lOfValue = new CSS_List_Of_Values__c();
        lOfValue.Code__c = '123';
        lOfValue.Name = 'test';
        insert lOfValue;
        
        listOfValue.add(lOfValue);
        
        
        CG_CL_ClaimsIntake mainContr = new CG_CL_ClaimsIntake();
        mainContr.claimsRec = testclaimsRec;
        testclaimsRec.Id = testclaimsRecId;
        //mainContr.claimsRec.Id = null;
        mainContr.userObj = usr;
        mainContr.psnRec = testpsnNewRec;
        mainContr.psnRec.Id = testpsnNewRec.Id;
        mainContr.psnRec.Failure_Date__c=System.today()+1;
        mainContr.psnRec.PSN__c = '79464646';
        mainContr.filterMake = 'ACE';
        mainContr.filterModel = 'QSB-44-T2';
        mainContr.filterUnitType ='test';
        mainContr.tempFailureDate=System.today();
        mainContr.LocationManualClaims = '02466';
        //inContr.psnRec.PSN__c=null;
        claimsUEOneBMS.mainContr = mainContr;
        
        CSS_Integration_Details__c inteDetails = new CSS_Integration_Details__c();
        inteDetails.Name = 'CSS_SPDataLookup';
        inteDetails.ApplicationName__c = 'CSS_SPDataLookup';
        inteDetails.End_Point__c = 'https://services-test.cummins.com/csswarranty/serviceproviderdata';
        inteDetails.IsActive__c = true;
        inteDetails.Key__c = '+WDulWUQbMMb2guLV/cW5n+ZhMSgt7VNDue7rXLsdAM=';
        inteDetails.Passcode__c = 'r0C6S7iRAglNefdDV7/nyVKep7nsKI+XYcsKpk3SEq8=';
        inteDetails.Username__c = 'QX/NdXx6Zy6IedZLJtAfd6gasrDgW5oWjpxCbtIkHEU=';
        insert inteDetails;  
        
        CSS_JobEventTemporary__c JETproductcode = new CSS_JobEventTemporary__c();
        JETproductcode.Key__c = 'MarketingApplicationCodes';
        JETproductcode.Attribute1__c = 'test';
        JETproductcode.Attribute3__c = 'ing';
        JETproductcode.Attribute2__c = 'TE-ST';
        //JETproductcode.Attribute5__c = 'Testing';
        JETproductcode.Attribute5__c = 'zxcv';
        JETproductcode.Reason__c='{"DataArea": {"Details": [{"ApplicationCode": "123","Description": "abc","BusinessUnit": "EBU","AutomotiveFlag": "Y","MarineFlag": "","ActiveFlag": "Y","DefaultUom": "miles"},{"ApplicationCode": "555","Description": "zxcv","BusinessUnit": "PSBU","AutomotiveFlag": "","MarineFlag": "N","ActiveFlag": "Y","DefaultUom": "miles"}]},"Header": {"ReturnCodeDescription": "","Status": "Success"}}';
        insert JETproductcode;
        
        test.startTest();
    
          system.debug('TESTING');
       
       
        CG_CL_ClaimsIntake mainContr1 = new CG_CL_ClaimsIntake();
        mainContr1.filterApplication = 'zxcv';
        
        
      
        Test.setMock(HttpCalloutMock.class, new CSS_GetServiceProviderResponseMock_Test());
	    system.debug('OP Response');
        claimsUEOneBMS.recconFlag = true;
        claimsUEOneBMS.startRequest();
       
        
        test.stoptest();
        
    }
    public static Testmethod void TestForGetEngineDataWS1(){
        
        Profile p = [SELECT Id FROM Profile WHERE Name='CSS_Service_Advanced']; 
        User usr = new User(Alias = 'standt', Email='standarduser4@testorg.com', 
                            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                            LocaleSidKey='en_US',  ProfileId = p.Id, 
                            TimeZoneSidKey='America/Los_Angeles', UserName='UtilityTestUser14@testorg.com',User_Location__c = '56270-56270');
        insert usr;
        system.debug('usr**'+usr);
        CSS_accountLanguage__c accLan = new CSS_accountLanguage__c();
        accLan.CSS_QsolLanguage__c = 'en';
        accLan.Name = 'en_US';
        insert accLan;
         LIst<Account> alist = new list<Account>();
        Account a = new Account();
            a.name='Kenworth Sales Co';
            a.CSS_DistributorCode__c='02466';
            a.IAM_Service_Provider_Code__c='19134';
            a.Type='Dealer Account';
            a.CMI_Account_Status__c = 'Active';
            alist.add(a);
            insert alist; 
        
        CSS_Accreditation__c a1 = new CSS_Accreditation__c();
        a1.Service_Model_Name__c = 'nkm';
        a1.Account__c = a.Id;
        a1.StartDate__c = date.today();
        a1.EndDate__c = date.today()+30;
        insert a1;
        
        
        
        Test.setMock(WebServiceMock.class, new CSS_GetEngineDataPlate_Test()); 
         Test.setMock(WebServiceMock.class, new CSS_GetWarrantyDocs_Test());
        Test.setMock(HttpCalloutMock.class, new CG_CampaignMock_Test());
        
        CG_CL_ClaimsUEOneBMS claimsUEOneBMS = new CG_CL_ClaimsUEOneBMS();
        Id testsaveClaimedid;
        claimsUEOneBMS.recconFlag=true;
        
        CG_CL_ClaimsIntake testobj=new CG_CL_ClaimsIntake();
        CSS_Claims__c testclaimsRec = new CSS_Claims__c();
        testclaimsRec.Account__c = a.id;
        testclaimsRec.ProductApplicationCode__c = 'test';
        testclaimsRec.ProductApplicationDesp__c = 'ing';
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
        testclaimsRec.ShipDate__c=System.today();
        testclaimsRec.ZipCode__c = '12345-1234';
        testclaimsRec.SP_WarrantyTrainingStatus__c='R';
        testclaimsRec.SP_WarrantyCertificationEndDate__c=string.valueOf(date.Today());
        insert testclaimsRec;
        Id testclaimsRecId = testclaimsRec.Id;
        
        CSS_PSN__c testpsnNewRec = new CSS_PSN__c();
        testpsnNewRec.psn__c = '79464646';
        testpsnNewRec.Primary__C = true;
        testpsnNewRec.failure_Date__c = date.today()-2;
        testpsnNewRec.Warranty_Start_Date__c=date.today()-30;
        testpsnNewRec.css_claims__C = testclaimsRec.id;
        testpsnNewRec.ProductAppcodeErrorflag__c = true;
        testpsnNewRec.Before_In_Service__c=false;
        insert testpsnNewRec;
        Id testpsnNewRecId = testpsnNewRec.Id;
        
        testclaimsRec =[Select Id, (Select Id,Name from CSS_PSNs__r where Primary__c=true Limit 1)
                        FROM CSS_Claims__c where id=:testclaimsRec.id];
        
        
      
        //accredList = [SELECT id, EndDate__c,Service_Model_Name__c,StartDate__c,Account__c,Account__r.Location__c FROM  where Account__r.Location__c =: mainContr.userObj.User_Location__c];
        
        /* testobj.psnRec = testpsnNewRec;
testobj.filterMake = 'ACE';
testobj.filterModel = 'QSB-44-T2';
testobj.userObj = usr;*/
        
        //ClaimsUEOneBMS.mainContr = testObj;
        CSS_Integration_Details__c conDetails = new CSS_Integration_Details__c();
        conDetails.Name = 'GetCampaign';
        conDetails.AuthEnv__c = 'OAGOAUTH';
        conDetails.ApplicationName__c = 'GetCampaign';
        conDetails.End_Point__c = 'Test';
        conDetails.Method_Type__c = 'POST';
        conDetails.Timeout__c = 2.0;
        insert conDetails;
        
        List<CSS_List_Of_Values__c> listOfValue = new List<CSS_List_Of_Values__c>();
        CSS_List_Of_Values__c lOfValue = new CSS_List_Of_Values__c();
        lOfValue.Code__c = '123';
        lOfValue.Name = 'test';
        insert lOfValue;
        
        listOfValue.add(lOfValue);
        
        
        CG_CL_ClaimsIntake mainContr = new CG_CL_ClaimsIntake();
        mainContr.claimsRec = testclaimsRec;
        testclaimsRec.Id = testclaimsRecId;
        //mainContr.claimsRec.Id = null;
        mainContr.userObj = usr;
        mainContr.psnRec = testpsnNewRec;
        mainContr.psnRec.Id = testpsnNewRec.Id;
        mainContr.psnRec.Failure_Date__c=System.today()+1;
        mainContr.psnRec.PSN__c = '79464646';
        mainContr.filterMake = 'ACE';
        mainContr.filterModel = 'QSB-44-T2';
        mainContr.filterUnitType ='test';
        mainContr.tempFailureDate=System.today();
        mainContr.LocationManualClaims = '02466';
        //inContr.psnRec.PSN__c=null;
        claimsUEOneBMS.mainContr = mainContr;
        
        CSS_Integration_Details__c inteDetails = new CSS_Integration_Details__c();
        inteDetails.Name = 'CSS_SPDataLookup';
        inteDetails.ApplicationName__c = 'CSS_SPDataLookup';
        inteDetails.End_Point__c = 'https://services-test.cummins.com/csswarranty/serviceproviderdata';
        inteDetails.IsActive__c = true;
        inteDetails.Key__c = '+WDulWUQbMMb2guLV/cW5n+ZhMSgt7VNDue7rXLsdAM=';
        inteDetails.Passcode__c = 'r0C6S7iRAglNefdDV7/nyVKep7nsKI+XYcsKpk3SEq8=';
        inteDetails.Username__c = 'QX/NdXx6Zy6IedZLJtAfd6gasrDgW5oWjpxCbtIkHEU=';
        insert inteDetails;  
        
        CSS_JobEventTemporary__c JETproductcode = new CSS_JobEventTemporary__c();
        JETproductcode.Key__c = 'MarketingApplicationCodes';
        JETproductcode.Attribute1__c = 'test';
        JETproductcode.Attribute3__c = 'ing';
        JETproductcode.Attribute2__c = 'TE-ST';
        //JETproductcode.Attribute5__c = 'Testing';
        JETproductcode.Attribute5__c = 'zxcv';
        JETproductcode.Reason__c='{"DataArea": {"Details": [{"ApplicationCode": "123","Description": "abc","BusinessUnit": "EBU","AutomotiveFlag": "Y","MarineFlag": "","ActiveFlag": "Y","DefaultUom": "miles"},{"ApplicationCode": "555","Description": "zxcv","BusinessUnit": "PSBU","AutomotiveFlag": "","MarineFlag": "N","ActiveFlag": "Y","DefaultUom": "miles"}]},"Header": {"ReturnCodeDescription": "","Status": "Success"}}';
        insert JETproductcode;
        
        test.startTest();
        
        
        
        Test.setMock(HttpCalloutMock.class, new CSS_getEngineDataFrmSiebel_Test());
        Test.setMock(HttpCalloutMock.class, new CSS_getEngineDataResponseJ2A_Mockup_Test());
        Test.setMock(HttpCalloutMock.class, new CSS_GetSPDataWSMock_Test());
        Test.setMock(HttpCalloutMock.class, new CG_CampaignMock_Test());
        
        system.debug('TESTING');
        claimsUEOneBMS.getCampaignDetails();
       
        CG_CL_ClaimsIntake mainContr1 = new CG_CL_ClaimsIntake();
        mainContr1.filterApplication = 'zxcv';
        
        
        claimsUEOneBMS.getApplication();
        Test.setMock(HttpCalloutMock.class, new CSS_GetServiceProviderResponseMock_Test());
	    system.debug('OP Response');
        claimsUEOneBMS.recconFlag = true;
        claimsUEOneBMS.startRequest();
        claimsUEOneBMS.updateproductappcode();
        claimsUEOneBMS.parseQSOLDate('12 Jan 2019');
        claimsUEOneBMS.parseQSOLDate('12 Feb 2019');
        claimsUEOneBMS.parseQSOLDate('12 Mar 2019');
        claimsUEOneBMS.parseQSOLDate('12 Apr 2019');
        claimsUEOneBMS.parseQSOLDate('12 May 2019');
        claimsUEOneBMS.parseQSOLDate('12 Jun 2019');
        claimsUEOneBMS.parseQSOLDate('12 Jul 2019');
        claimsUEOneBMS.parseQSOLDate('12 Aug 2019');
        claimsUEOneBMS.parseQSOLDate('12 Sep 2019');
        claimsUEOneBMS.parseQSOLDate('12 Oct 2019');
        claimsUEOneBMS.parseQSOLDate('12 Nov 2019');
        claimsUEOneBMS.parseQSOLDate('12 Dec 2019');
        
        test.stoptest();
        
    }
     public static Testmethod void TestForGetEngineDataWS2(){
        
        Test.setMock(WebServiceMock.class, new CSS_GetEngineDataPlate_Test()); 
        Test.setMock(WebServiceMock.class, new CSS_GetWarrantyDocs_Test());
        Test.setMock(HttpCalloutMock.class, new CG_CampaignMock_Test());
        
        CG_CL_ClaimsUEOneBMS claimsUEOneBMS = new CG_CL_ClaimsUEOneBMS();
        Id testsaveClaimedid;
        claimsUEOneBMS.recconFlag=true;
        
        CG_CL_ClaimsIntake testobj=new CG_CL_ClaimsIntake();
        CSS_Claims__c testclaimsRec = new CSS_Claims__c();
        testclaimsRec.ProductApplicationCode__c = 'test';
        testclaimsRec.ProductApplicationDesp__c = 'ing';
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
        testclaimsRec.SP_WarrantyCertificationEndDate__c = string.valueOf(date.Today());
        testclaimsRec.SP_WarrantyTrainingStatus__c='R';
        testclaimsRec.SP_WarrantyCertificationEndDate__c=string.valueOf(date.Today());
        insert testclaimsRec;
        Id testclaimsRecId = testclaimsRec.Id;
        
        CSS_PSN__c testpsnNewRec = new CSS_PSN__c();
        testpsnNewRec.psn__c = '79464646';
        testpsnNewRec.Primary__C = true;
        testpsnNewRec.failure_Date__c = date.today()+200;
        testpsnNewRec.Warranty_Start_Date__c=date.today()+12;
        testpsnNewRec.css_claims__C = testclaimsRec.id;
        testpsnNewRec.ProductAppcodeErrorflag__c = true;
        insert testpsnNewRec;
        Id testpsnNewRecId = testpsnNewRec.Id;
        
        testclaimsRec =[Select Id,CSS_Job__r.General_Symptoms__c,Account__c,CSS_Job__r.Category_Desc__c,CSS_Job__r.Complaint_Type_Desc__c,CSS_Job__r.Category2_Desc__c,
                        CSS_Job__r.Complaint_Type2_Desc__c,CSS_Job__r.Category3_Desc__c,CSS_Job__r.Complaint_Type3_Desc__c,CSS_Job__r.Category4_Desc__c,
                        CSS_Job__r.Complaint_Type4_Desc__c,CSS_Job__r.Category5_Desc__c,CSS_Job__r.Complaint_Type5_Desc__c,Claims_General_Symptoms__c,
                        Claims_Preventive_Maintenance__c,SP_WarrantyCertificationEndDate__c,ProductApplicationCode__c,Claims_Category__c,Claims_Category2__c,Claims_Category3__c,Claims_Category4__c,Claims_Category5__c,
                        Complaint_Type_Desc__c,Complaint_Type2_Desc__c,Complaint_Type3_Desc__c,Complaint_Type4_Desc__c,Complaint_Type5_Desc__c,IsCopyclaim__c,
                        Claims_Expedited_Service__c,Status__c,ODM_Status__c,Claims_Additional_Comments__c,Claims_Category_Desc__c,Claims_Category2_Desc__c,
                        Claims_Category3_Desc__c,Claims_Category4_Desc__c,Claims_Category5_Desc__c,Claims_Complaint_Type__c,Claims_Complaint_Type2__c,
                        Claims_Complaint_Type3__c,Claims_Complaint_Type4__c,account__r.RSS_RESP_BRANCH_CODE__c,SP_PrimaryOEMCode__c,Claims_Complaint_Type5__c,CSS_Job__r.createdDate,Customer_Name__c,Location__c,
                        Location_Code__c,CSS_Job__c,CSS_Job__r.name,Shop_Work_Order__c,SP_Country__c,EngineFamilyName__c,LastModifiedDate,Name, ESN__c, createdDate,Region__c,Territory__c,
                        CoverageResponse__c,Claim_Submitted__c,Account__r.Enable_Claims__c,Account__r.Warranty_Training_Status__c,Distributor_Authorization_FN__c,
                        CreatedBy.Name,Account__r.Warranty_Training_Certification__c,TSR1__c,TSR2__c,TSR3__c,TSR4__c,TSR5__c,TSR6__c,TSR7__c,TSR8__c,TSR9__c,
                        TSR10__c,CSS_Job__r.CSS_In_Shop_Labor_Rate__c,CSS_Job__r.CSS_Field_Service_Labor_Rate__c,CSS_Job__r.CSS_Travel_Rate__c, Catastrophic__c,
                        DesignPhaseCode__c, Service_Model__c,CSS_Channel_Of_Distribution__c,SP_LTA_FLAG__c,SP_PACCAR__c,SP_ACCOUNT_STATUS__c,SP_TERRITORY_CODE__c,
                        SP_PromotionId__c,Repair_Location__c, BillToCode__c, BuildDate__c, EngineFamilyCode__c, EtoConversionDate__c, MarineFlag__c, OemCode__c, 
                        ProductApplicationDesp__c, warrantyIndicatorFlag__c, SP_CHANNEL_OF_DISTRIBUTION__c, CSS_Channel_Code__c, SP_CLAIM_ALLOWED_DAYS__c, 
                        SP_Group_Name__c, SP_CMI_SP_EXPIRATION__c, SP_SCMDollarAmt__c,SP_WarrantyTrainingStatus__c,SP_State__c,SP_SCMDeductiblePercentage__c,
                        SP_OUTFILE_ALL_CLAIMS__c, SP_REGION__c, SP_REGIONCODE__c, SP_TERRITORY__c, CSS_Job__r.Shop_Work_Order__c,Automotive_App_Flag__c,  
                        (Select Id,Name,PSN__c,Make__c,Model__c,Before_In_Service__c,Mission_Disabling__c,Calibration_After__c,Calibration_Before__c,VIN__c,
                         Service_Model__c,Application__c,ApplicationCode__c,Qsol_Engine_Family_Code__c, Failure_Date__c,Mileage__c,Mileage_Measure__c,Justification__c,Unit_Number__c,
                         Warranty_Start_Date__c,Product_Hours__c,CoverageFlag__c, CSS_Claims__c from CSS_PSNs__r where Primary__c=true Limit 1) 
                        from CSS_Claims__c where id=:testclaimsRec.id];
        //  testclaimsRec.Failure_Date__c=System.today()+1;
        
        Profile p = [SELECT Id FROM Profile WHERE Name='CSS_Service_Advanced']; 
        User usr = new User(Alias = 'standt', Email='standarduser4@testorg.com', 
                            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                            LocaleSidKey='en_US',  ProfileId = p.Id, 
                            TimeZoneSidKey='America/Los_Angeles', UserName='UtilityTestUser14@testorg.com',User_Location__c = '56270-56270');
        insert usr;
        system.debug('usr**'+usr);
        CSS_accountLanguage__c accLan = new CSS_accountLanguage__c();
        accLan.CSS_QsolLanguage__c = 'en';
        accLan.Name = 'en_US';
        insert accLan;
        account a = new account();
        a.name = 'test';
        a.CSS_DistributorCode__c= '56270';
        a.IAM_Service_Provider_Code__c= '56270';
        a.Type='Dealer Account';
        a.Region__c = 'US and Canada';
        a.CMI_Account_Status__c = 'Active';
        // a.IAM_Service_Provider_Code__c = '562551';
        //a.IAM_Service_Provider_Code__c = '33333';
        
        insert a;
        CSS_Accreditation__c a1 = new CSS_Accreditation__c();
        a1.Service_Model_Name__c = 'nkm';
        a1.Account__c = a.Id;
        a1.StartDate__c = date.today()+30;
        a1.EndDate__c = date.today()-2;
        // a1.Make__c = 'ACE';
        //  a1.Model__c = 'QSB-44-T2';
        insert a1;
        //  mainContr = [SELECT id, EndDate__c,Service_Model_Name__c,StartDate__c,Account__c,Account__r.Location__c FROM  where Account__r.Location__c =: mainContr.userObj.User_Location__c];
        
        /* testobj.psnRec = testpsnNewRec;
testobj.filterMake = 'ACE';
testobj.filterModel = 'QSB-44-T2';
testobj.userObj = user;*/
        
        //ClaimsUEOneBMS.mainContr = testObj;
        CSS_Integration_Details__c conDetails = new CSS_Integration_Details__c();
        conDetails.Name = 'GetCampaign';
        conDetails.AuthEnv__c = 'OAGOAUTH';
        conDetails.ApplicationName__c = 'GetCampaign';
        conDetails.End_Point__c = 'Test';
        conDetails.Method_Type__c = 'POST';
        conDetails.Timeout__c = 2.0;
        insert conDetails;
        
        List<CSS_List_Of_Values__c> listOfValue = new List<CSS_List_Of_Values__c>();
        CSS_List_Of_Values__c lOfValue = new CSS_List_Of_Values__c();
        lOfValue.Code__c = '123';
        lOfValue.Name = 'test';
        insert lOfValue;
        
        listOfValue.add(lOfValue);
        
        
        CG_CL_ClaimsIntake mainContr = new CG_CL_ClaimsIntake();
        testclaimsRec.Id = testclaimsRecId;
        mainContr.claimsRec = testclaimsRec;
        mainContr.userObj = usr;
        mainContr.psnRec = testpsnNewRec;
        mainContr.psnRec.Id = testpsnNewRec.Id;
        mainContr.psnRec.Failure_Date__c=System.today()+1;
        mainContr.filterMake = 'ACE';
        mainContr.filterModel = 'QSB-44-T2';
        mainContr.psnRec.PSN__c=null;
        claimsUEOneBMS.mainContr = mainContr;
        
        CSS_Integration_Details__c inteDetails = new CSS_Integration_Details__c();
        inteDetails.Name = 'CSS_SPDataLookup';
        inteDetails.ApplicationName__c = 'CSS_SPDataLookup';
        inteDetails.End_Point__c = 'https://services-stg.cummins.com/csswarranty/serviceproviderdata';
        inteDetails.IsActive__c = true;
        inteDetails.Key__c = 'DqOMliimooXThF1e2jaIPuaiu3SQndU0mwfHxspQYC0';
        inteDetails.Passcode__c = 'S8wjknFfHQk80axJn3OibETXc/600kyrLA8oUaxFKJ4=';
        inteDetails.Username__c = 'qay1+7OVYoeaAeq5V5oXd+XpT8T5kyqP4YcyQI+pLdM=';
        insert inteDetails;    
        test.startTest();
        
        Test.setMock(HttpCalloutMock.class, new CSS_getEngineDataFrmSiebel_Test());
        Test.setMock(HttpCalloutMock.class, new CSS_getEngineDataResponseJ2A_Mockup_Test());
        Test.setMock(HttpCalloutMock.class, new CSS_GetSPDataWSMock_Test());
        Test.setMock(HttpCalloutMock.class, new CG_CampaignMock_Test());
          Test.setMock(HttpCalloutMock.class, new CSS_GetServiceProviderResponseMock_Test());
        
        system.debug('TESTING');
        claimsUEOneBMS.getCampaignDetails();
        String json = '{\"DataArea\":{\"Policy\": \"Y\",\"GroupName\": \"\",\"RegionCode\": \"USCA\",\"PromotionId\": \"Y\",'+
            '\"RepairLevel\": \"N\",\"ViewDollarAmount\": \"N\",\"PrimaryOEMName\": \"CUMMINS\",\"AccountStatus\": \"Active\",'+
            '\"MaxClaimAmt\": \"999999\",\"WWSPSSPFlag\": \"Y\",\"CommunicationOccurrence\": \"\",\"FreezeSubmitButton\": \"N\",'+
            '\"Territory\": \"UNITED STATES\",\"LTAFlag\": \"N\",\"SPCountry\": \"USA\",\"CommunicationMethod\": \"\",'+
            '\"PACCAR\": \"N\",\"State\": \"PA\",\"BusinessUnit\": \"CMI\",\"Region\": \"NORTH AMERICA\",\"WarrantyFax\": \"215 785-6151\",'+
            '\"SCMDollarAmt\": \"30000\",'+
            '\"WarrantyEmail\": \"anthony.j.miriello@cummins.com\",'+
            '\"DistributorHQName\": \"CSSNA- EAST REGION\",'+
            '\"SCMDeductiblePercentage\": \"3\",'+
            '\"ChannelCode\": \"101\",'+
            '\"DSID\": \"N\",'+
            '\"FieldServiceLaborRate\": \"137\",'+
            '\"TravelRate\": \"1.21\",'+
            '\"ClaimAllowedDays\": \"365\",'+
            '\"WarrantyCertificationEndDate\": \"2017-12-11 00:00:00.0\",'+
            '\"WarrantyTrainingCertification\": \"Y\",'+
            '\"NewOEM\": \"N\",'+
            '\"TerritoryCode\": \"100\",'+
            '\"PSBUProductCertification\": \"N\",'+
            '\"DTNAFlag\": \"N\",'+
            '\"ChannelOfDistribution\": \"101-DISTRIBUTOR-BRANCH\",'+
            '\"PrimaryOEMCode\": \"103\",'+
            '\"OutfileAllClaims\": \"N\",'+
            '\"DisableWebAccessFlag\": \"N\",'+
            '\"ProductCertification\": \"Y\",'+
            '\"CutOffClaimAmt\": \"250\",'+
            '\"DistributorHQCode\": \"02850\",'+
            '\"WarrantyTrainingStatus\": \"G\",'+
            '\"CMISPExpirationDate\": \"2019-06-25 00:00:00.0\",'+
            '\"InShopLaborRate\": \"137\",'+
            '\"CostEffectiveExclusion\": \"N\",\"PMUSplitPayment\": \"Y\",\"TechActualHoursRequired\": \"N\",\"CampaignTRP\": \"Y\"},\"Header\": {\"Status\": \"Success\"}}';
        CSS_GetServiceProviderResponse obj = CSS_GetServiceProviderResponse.parse(json);
        claimsUEOneBMS.spdataAssign(obj);
        CG_CL_ClaimsIntake mainContr1 = new CG_CL_ClaimsIntake();
        mainContr1.filterApplication = 'zxcv';
        
        CSS_JobEventTemporary__c JETproductcode = new CSS_JobEventTemporary__c();
        JETproductcode.Key__c = 'MarketingApplicationCodes';
        JETproductcode.Attribute1__c = 'test';
        JETproductcode.Attribute3__c = 'ing';
        JETproductcode.Attribute2__c = 'TE-ST';
        //JETproductcode.Attribute5__c = 'Testing';
        JETproductcode.Attribute5__c = 'zxcv';
        JETproductcode.Reason__c='{"DataArea": {"Details": [{"ApplicationCode": "123","Description": "abc","BusinessUnit": "EBU","AutomotiveFlag": "Y","MarineFlag": "","ActiveFlag": "Y","DefaultUom": "miles"},{"ApplicationCode": "555","Description": "zxcv","BusinessUnit": "PSBU","AutomotiveFlag": "","MarineFlag": "N","ActiveFlag": "Y","DefaultUom": "miles"}]},"Header": {"ReturnCodeDescription": "","Status": "Success"}}';
        insert JETproductcode;
        claimsUEOneBMS.getApplication();
        //claimsUEOneBMS.ProductAppcodeErrorflag__c=true;81,946
       // claimsUEOneBMS.startRequest();
        claimsUEOneBMS.updateproductappcode();
        claimsUEOneBMS.parseQSOLDate('12 Jan 2019');
        claimsUEOneBMS.parseQSOLDate('12 Feb 2019');
        claimsUEOneBMS.parseQSOLDate('12 Mar 2019');
        claimsUEOneBMS.parseQSOLDate('12 Apr 2019');
        claimsUEOneBMS.parseQSOLDate('12 May 2019');
        claimsUEOneBMS.parseQSOLDate('12 Jun 2019');
        claimsUEOneBMS.parseQSOLDate('12 Jul 2019');
        claimsUEOneBMS.parseQSOLDate('12 Aug 2019');
        claimsUEOneBMS.parseQSOLDate('12 Sep 2019');
        claimsUEOneBMS.parseQSOLDate('12 Oct 2019');
        claimsUEOneBMS.parseQSOLDate('12 Nov 2019');
        claimsUEOneBMS.parseQSOLDate('12 Dec 2019');
        
        test.stoptest();
        
    }
     
    public static Testmethod void CG_CL_ClaimsUEOneBMS_Method11(){ 
        Test.setMock(WebServiceMock.class, new CSS_GetEngineDataPlate_Test()); 
        Test.setMock(HttpCalloutMock.class, new CSS_MockHttpResponseGenerator());
        Test.setMock(HttpCalloutMock.class, new CG_CampaignMock_Test());
        
        CG_CL_ClaimsUEOneBMS claimsUEOneBMS = new CG_CL_ClaimsUEOneBMS();
        claimsUEOneBMS.ExternReturnDateFlag = true;
        claimsUEOneBMS.recconFlag = true;
        claimsUEOneBMS.productAppdesc = 'sneha';
        claimsUEOneBMS.productAppcode ='test';
        Id testsaveClaimedid;
        CSS_Integration_Details__c conDetails = new CSS_Integration_Details__c();
        conDetails.Name = 'GetCampaign';
        conDetails.AuthEnv__c = 'OAGOAUTH';
        conDetails.ApplicationName__c = 'GetCampaign';
        conDetails.End_Point__c = 'Test';
        conDetails.Method_Type__c = 'POST';
        conDetails.Timeout__c = 2.0;
        insert conDetails;
        
        CSS_PSN__c testpsnNewRec = new CSS_PSN__c();
        CSS_Claims__c testclaimsRec = new CSS_Claims__c();
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
        testclaimsRec.EtoConversionDate__c =system.today(); 
        //testclaimsRec.ProductApplicationCode__c= 'test' ;
        //testclaimsREc.ProductApplicationDesp__c='AUTOMOTIVE' ;  
        testclaimsRec.IsCopyclaim__c = true;
        testclaimsRec.ProductApplicationCode__c = 'BB';
        testclaimsRec.ProductApplicationDesp__c = 'BB';
        //testclaimsRec.recursupd = true;
        insert testclaimsRec;
        
        testpsnNewRec.psn__c = '';
        testpsnNewRec.Primary__C = true;
        testpsnNewRec.failure_Date__c = system.today()+20;
        testpsnNewRec.css_claims__C = testclaimsRec.id;
        insert testpsnNewRec;
        CG_CL_ClaimsIntake testobj=new CG_CL_ClaimsIntake();
        testobj.filterApplication = 'abc';
        
        CSS_JobEventTemporary__c  jobEventRef = CSS_TestData.createJobEventTempObj(false);
        jobEventRef.Attribute1__c ='ApplicationCodes';
        jobEventRef.Attribute2__c='TestAtt1';
        jobEventRef.Attribute3__c='AUTOMOTIVE';
        jobEventRef.Attribute5__c = testobj.filterApplication;
        jobEventRef.Key__c='AccountCodes';
        jobEventRef.Reason__c='{"DataArea": {"Details": [{"ApplicationCode": "123","Description": "abc","BusinessUnit": "EBU","AutomotiveFlag": "Y","MarineFlag": "","ActiveFlag": "Y","DefaultUom": "miles"},{"ApplicationCode": "555","Description": "zxcv","BusinessUnit": "PSBU","AutomotiveFlag": "","MarineFlag": "N","ActiveFlag": "Y","DefaultUom": "miles"}]},"Header": {"ReturnCodeDescription": "","Status": "Success"}}';
        insert  jobEventRef;
        
        CSS_JobEventTemporary__c JETproductcode = new CSS_JobEventTemporary__c();
        JETproductcode.Key__c = 'FailCodes';
        JETproductcode.Attribute1__c = 'BB';
        JETproductcode.Attribute3__c = 'AUTOMOTIVE';
        JETproductcode.Attribute2__c = 'TE-ST';
        JETproductcode.Attribute5__c = 'zxcv';
        JETproductcode.Reason__c='{"DataArea": {"Details": [{"ApplicationCode": "123","Description": "abc","BusinessUnit": "EBU","AutomotiveFlag": "Y","MarineFlag": "","ActiveFlag": "Y","DefaultUom": "miles"},{"ApplicationCode": "555","Description": "zxcv","BusinessUnit": "PSBU","AutomotiveFlag": "","MarineFlag": "N","ActiveFlag": "Y","DefaultUom": "miles"}]},"Header": {"ReturnCodeDescription": "","Status": "Success"}}';
        insert JETproductcode;
        CSS_JobEventTemporary__c JETproductcode1 = new CSS_JobEventTemporary__c();
        JETproductcode1.Key__c = 'MarketingApplicationCodes';
        JETproductcode1.Attribute1__c = 'BB';
        JETproductcode1.Attribute3__c = 'BB';
        JETproductcode1.Attribute2__c = 'TE-ST';
        JETproductcode1.Attribute5__c = 'zxcv';
        JETproductcode1.Reason__c='{"DataArea": {"Details": [{"ApplicationCode": "123","Description": "abc","BusinessUnit": "EBU","AutomotiveFlag": "Y","MarineFlag": "","ActiveFlag": "Y","DefaultUom": "miles"},{"ApplicationCode": "555","Description": "zxcv","BusinessUnit": "PSBU","AutomotiveFlag": "","MarineFlag": "N","ActiveFlag": "Y","DefaultUom": "miles"}]},"Header": {"ReturnCodeDescription": "","Status": "Success"}}';
        insert JETproductcode1;
        CSS_JobEventTemporary__c JETproductcode11 = new CSS_JobEventTemporary__c();
        JETproductcode11.Key__c = 'MarketingApplicationCodes';
        JETproductcode11.Attribute1__c = 'BB';
        JETproductcode11.Attribute3__c = 'BB';
        JETproductcode11.Attribute2__c = '123';
        JETproductcode11.Attribute5__c = 'abc';
        JETproductcode11.Reason__c='{"DataArea": {"Details": [{"ApplicationCode": "123","Description": "abc","BusinessUnit": "EBU","AutomotiveFlag": "Y","MarineFlag": "","ActiveFlag": "Y","DefaultUom": "miles"},{"ApplicationCode": "555","Description": "zxcv","BusinessUnit": "PSBU","AutomotiveFlag": "","MarineFlag": "N","ActiveFlag": "Y","DefaultUom": "miles"}]},"Header": {"ReturnCodeDescription": "","Status": "Success"}}';
        insert JETproductcode11;
        
        //string sQSOLConn = CSS_getConnnectionDetails.getConnection('FailCodes').Key__c;   
        testclaimsRec =[Select Id,CSS_Job__r.General_Symptoms__c,Account__c,CSS_Job__r.Category_Desc__c,CSS_Job__r.Complaint_Type_Desc__c,CSS_Job__r.Category2_Desc__c,
                        CSS_Job__r.Complaint_Type2_Desc__c,CSS_Job__r.Category3_Desc__c,CSS_Job__r.Complaint_Type3_Desc__c,CSS_Job__r.Category4_Desc__c,
                        CSS_Job__r.Complaint_Type4_Desc__c,CSS_Job__r.Category5_Desc__c,CSS_Job__r.Complaint_Type5_Desc__c,Claims_General_Symptoms__c,
                        Claims_Preventive_Maintenance__c,SP_WarrantyCertificationEndDate__c,ProductApplicationCode__c,Claims_Category__c,Claims_Category2__c,Claims_Category3__c,Claims_Category4__c,Claims_Category5__c,
                        Complaint_Type_Desc__c,Complaint_Type2_Desc__c,Complaint_Type3_Desc__c,Complaint_Type4_Desc__c,Complaint_Type5_Desc__c,IsCopyclaim__c,
                        Claims_Expedited_Service__c,Status__c,ODM_Status__c,Claims_Additional_Comments__c,Claims_Category_Desc__c,Claims_Category2_Desc__c,
                        Claims_Category3_Desc__c,Claims_Category4_Desc__c,Claims_Category5_Desc__c,Claims_Complaint_Type__c,Claims_Complaint_Type2__c,
                        Claims_Complaint_Type3__c,Claims_Complaint_Type4__c,account__r.RSS_RESP_BRANCH_CODE__c,SP_PrimaryOEMCode__c,Claims_Complaint_Type5__c,CSS_Job__r.createdDate,Customer_Name__c,Location__c,
                        Location_Code__c,CSS_Job__c,CSS_Job__r.name,Shop_Work_Order__c,SP_Country__c,EngineFamilyName__c,LastModifiedDate,Name, ESN__c, createdDate,Region__c,Territory__c,
                        CoverageResponse__c,Claim_Submitted__c,Account__r.Enable_Claims__c,Account__r.Warranty_Training_Status__c,Distributor_Authorization_FN__c,
                        CreatedBy.Name,Account__r.Warranty_Training_Certification__c,TSR1__c,TSR2__c,TSR3__c,TSR4__c,TSR5__c,TSR6__c,TSR7__c,TSR8__c,TSR9__c,
                        TSR10__c,CSS_Job__r.CSS_In_Shop_Labor_Rate__c,CSS_Job__r.CSS_Field_Service_Labor_Rate__c,CSS_Job__r.CSS_Travel_Rate__c, Catastrophic__c,
                        DesignPhaseCode__c, Service_Model__c,CSS_Channel_Of_Distribution__c,SP_LTA_FLAG__c,SP_PACCAR__c,SP_ACCOUNT_STATUS__c,SP_TERRITORY_CODE__c,
                        SP_PromotionId__c,Repair_Location__c, BillToCode__c, BuildDate__c, EngineFamilyCode__c, EtoConversionDate__c, MarineFlag__c, OemCode__c, 
                        ProductApplicationDesp__c, warrantyIndicatorFlag__c, SP_CHANNEL_OF_DISTRIBUTION__c, CSS_Channel_Code__c, SP_CLAIM_ALLOWED_DAYS__c, 
                        SP_Group_Name__c, SP_CMI_SP_EXPIRATION__c, SP_SCMDollarAmt__c,SP_WarrantyTrainingStatus__c,SP_State__c,SP_SCMDeductiblePercentage__c,
                        SP_OUTFILE_ALL_CLAIMS__c, SP_REGION__c, SP_REGIONCODE__c, SP_TERRITORY__c, CSS_Job__r.Shop_Work_Order__c,Automotive_App_Flag__c,  
                        (Select Id,Name,PSN__c,Make__c,Model__c,Before_In_Service__c,Mission_Disabling__c,Calibration_After__c,Calibration_Before__c,VIN__c,
                         Service_Model__c,Application__c,ApplicationCode__c,Qsol_Engine_Family_Code__c, Failure_Date__c,Mileage__c,Mileage_Measure__c,Justification__c,Unit_Number__c,
                         Warranty_Start_Date__c,Product_Hours__c,CoverageFlag__c, CSS_Claims__c from CSS_PSNs__r where Primary__c=true Limit 1) 
                        from CSS_Claims__c where id=:testclaimsRec.id];
        
        
        Profile p = [SELECT Id FROM Profile WHERE Name='CSS_Service_Advanced']; 
        User usr = new User(Alias = 'standt', Email='standarduser4@testorg.com', 
                            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                            LocaleSidKey='en_US',  ProfileId = p.Id, 
                            TimeZoneSidKey='America/Los_Angeles', UserName='UtilityTestUser14@testorg.com',User_Location__c = '56270-56270');
        insert usr;
        
        CSS_accountLanguage__c accLan = new CSS_accountLanguage__c();
        accLan.CSS_QsolLanguage__c = 'en';
        accLan.Name = 'en_US';
        insert accLan;
        system.debug('usr**'+usr);
        testobj.psnRec = testpsnNewRec;
        testobj.filterMake = 'ACE';
        testobj.filterModel = 'QSB-44-T2';
        testobj.userObj = usr;
        testobj.claimsRec=testclaimsRec;
        ClaimsUEOneBMS.mainContr = testObj;
        
        
        //Start
        test.startTest();
        
        Test.setMock(HttpCalloutMock.class, new CG_CampaignMock_Test());
        Test.setMock(HttpCalloutMock.class, new CSS_getEngineDataResponseJ2A_Mockup_Test());
        Test.setMock(HttpCalloutMock.class, new CSS_GetServiceProviderResponseMock_Test());
       // claimsUEOneBMS.startRequest();
        claimsUEOneBMS.getItems();
        claimsUEOneBMS.getApplication();
        claimsUEOneBMS.recconFlag = true;
        //claimsUEOneBMS.startRequest();
        claimsUEOneBMS.updateproductappcode();
        claimsUEOneBMS.getMake();
        claimsUEOneBMS.getModel();
        claimsUEOneBMS.getUnitType();
        
        test.stoptest();
    }
    public static Testmethod void CG_CL_ClaimsUEOneBMS_Method111(){ 
        Test.setMock(WebServiceMock.class, new CSS_GetEngineDataPlate_Test()); 
        Test.setMock(HttpCalloutMock.class, new CSS_MockHttpResponseGenerator());
        Test.setMock(HttpCalloutMock.class, new CG_CampaignMock_Test());
        
        CG_CL_ClaimsUEOneBMS claimsUEOneBMS = new CG_CL_ClaimsUEOneBMS();
        claimsUEOneBMS.ExternReturnDateFlag = true;
        claimsUEOneBMS.recconFlag = true;
        claimsUEOneBMS.productAppdesc = 'sneha';
        claimsUEOneBMS.productAppcode ='test';
        Id testsaveClaimedid;
        CSS_Integration_Details__c conDetails = new CSS_Integration_Details__c();
        conDetails.Name = 'GetCampaign';
        conDetails.AuthEnv__c = 'OAGOAUTH';
        conDetails.ApplicationName__c = 'GetCampaign';
        conDetails.End_Point__c = 'Test';
        conDetails.Method_Type__c = 'POST';
        conDetails.Timeout__c = 2.0;
        insert conDetails;
        
        CSS_PSN__c testpsnNewRec = new CSS_PSN__c();
        CSS_Claims__c testclaimsRec = new CSS_Claims__c();
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
        testclaimsRec.EtoConversionDate__c =system.today(); 
        //testclaimsRec.ProductApplicationCode__c= 'test' ;
        //testclaimsREc.ProductApplicationDesp__c='AUTOMOTIVE' ;  
        testclaimsRec.IsCopyclaim__c = true;
        testclaimsRec.ProductApplicationCode__c = 'BB';
        testclaimsRec.ProductApplicationDesp__c = 'BB';
        //testclaimsRec.recursupd = true;
        insert testclaimsRec;
        
        testpsnNewRec.psn__c = '';
        testpsnNewRec.Primary__C = true;
        testpsnNewRec.failure_Date__c = system.today()+20;
        testpsnNewRec.css_claims__C = testclaimsRec.id;
        insert testpsnNewRec;
        CG_CL_ClaimsIntake testobj=new CG_CL_ClaimsIntake();
        testobj.filterApplication = 'abc';
        
        CSS_JobEventTemporary__c  jobEventRef = CSS_TestData.createJobEventTempObj(false);
        jobEventRef.Attribute1__c ='ApplicationCodes';
        jobEventRef.Attribute2__c='TestAtt1';
        jobEventRef.Attribute3__c='AUTOMOTIVE';
        jobEventRef.Attribute5__c = testobj.filterApplication;
        jobEventRef.Key__c='AccountCodes';
        jobEventRef.Reason__c='{"DataArea": {"Details": [{"ApplicationCode": "123","Description": "abc","BusinessUnit": "EBU","AutomotiveFlag": "Y","MarineFlag": "","ActiveFlag": "Y","DefaultUom": "miles"},{"ApplicationCode": "555","Description": "zxcv","BusinessUnit": "PSBU","AutomotiveFlag": "","MarineFlag": "N","ActiveFlag": "Y","DefaultUom": "miles"}]},"Header": {"ReturnCodeDescription": "","Status": "Success"}}';
        insert  jobEventRef;
        
        CSS_JobEventTemporary__c JETproductcode = new CSS_JobEventTemporary__c();
        JETproductcode.Key__c = 'FailCodes';
        JETproductcode.Attribute1__c = 'BB';
        JETproductcode.Attribute3__c = 'AUTOMOTIVE';
        JETproductcode.Attribute2__c = 'TE-ST';
        JETproductcode.Attribute5__c = 'zxcv';
        JETproductcode.Reason__c='{"DataArea": {"Details": [{"ApplicationCode": "123","Description": "abc","BusinessUnit": "EBU","AutomotiveFlag": "Y","MarineFlag": "","ActiveFlag": "Y","DefaultUom": "miles"},{"ApplicationCode": "555","Description": "zxcv","BusinessUnit": "PSBU","AutomotiveFlag": "","MarineFlag": "N","ActiveFlag": "Y","DefaultUom": "miles"}]},"Header": {"ReturnCodeDescription": "","Status": "Success"}}';
        insert JETproductcode;
        CSS_JobEventTemporary__c JETproductcode1 = new CSS_JobEventTemporary__c();
        JETproductcode1.Key__c = 'MarketingApplicationCodes';
        JETproductcode1.Attribute1__c = 'BB';
        JETproductcode1.Attribute3__c = 'BB';
        JETproductcode1.Attribute2__c = 'TE-ST';
        JETproductcode1.Attribute5__c = 'zxcv';
        JETproductcode1.Reason__c='{"DataArea": {"Details": [{"ApplicationCode": "123","Description": "abc","BusinessUnit": "EBU","AutomotiveFlag": "Y","MarineFlag": "","ActiveFlag": "Y","DefaultUom": "miles"},{"ApplicationCode": "555","Description": "zxcv","BusinessUnit": "PSBU","AutomotiveFlag": "","MarineFlag": "N","ActiveFlag": "Y","DefaultUom": "miles"}]},"Header": {"ReturnCodeDescription": "","Status": "Success"}}';
        insert JETproductcode1;
        CSS_JobEventTemporary__c JETproductcode11 = new CSS_JobEventTemporary__c();
        JETproductcode11.Key__c = 'MarketingApplicationCodes';
        JETproductcode11.Attribute1__c = 'BB';
        JETproductcode11.Attribute3__c = 'BB';
        JETproductcode11.Attribute2__c = '123';
        JETproductcode11.Attribute5__c = 'abc';
        JETproductcode11.Reason__c='{"DataArea": {"Details": [{"ApplicationCode": "123","Description": "abc","BusinessUnit": "EBU","AutomotiveFlag": "Y","MarineFlag": "","ActiveFlag": "Y","DefaultUom": "miles"},{"ApplicationCode": "555","Description": "zxcv","BusinessUnit": "PSBU","AutomotiveFlag": "","MarineFlag": "N","ActiveFlag": "Y","DefaultUom": "miles"}]},"Header": {"ReturnCodeDescription": "","Status": "Success"}}';
        insert JETproductcode11;
        
        //string sQSOLConn = CSS_getConnnectionDetails.getConnection('FailCodes').Key__c;   
        testclaimsRec =[Select Id,CSS_Job__r.General_Symptoms__c,Account__c,CSS_Job__r.Category_Desc__c,CSS_Job__r.Complaint_Type_Desc__c,CSS_Job__r.Category2_Desc__c,
                        CSS_Job__r.Complaint_Type2_Desc__c,CSS_Job__r.Category3_Desc__c,CSS_Job__r.Complaint_Type3_Desc__c,CSS_Job__r.Category4_Desc__c,
                        CSS_Job__r.Complaint_Type4_Desc__c,CSS_Job__r.Category5_Desc__c,CSS_Job__r.Complaint_Type5_Desc__c,Claims_General_Symptoms__c,
                        Claims_Preventive_Maintenance__c,SP_WarrantyCertificationEndDate__c,ProductApplicationCode__c,Claims_Category__c,Claims_Category2__c,Claims_Category3__c,Claims_Category4__c,Claims_Category5__c,
                        Complaint_Type_Desc__c,Complaint_Type2_Desc__c,Complaint_Type3_Desc__c,Complaint_Type4_Desc__c,Complaint_Type5_Desc__c,IsCopyclaim__c,
                        Claims_Expedited_Service__c,Status__c,ODM_Status__c,Claims_Additional_Comments__c,Claims_Category_Desc__c,Claims_Category2_Desc__c,
                        Claims_Category3_Desc__c,Claims_Category4_Desc__c,Claims_Category5_Desc__c,Claims_Complaint_Type__c,Claims_Complaint_Type2__c,
                        Claims_Complaint_Type3__c,Claims_Complaint_Type4__c,account__r.RSS_RESP_BRANCH_CODE__c,SP_PrimaryOEMCode__c,Claims_Complaint_Type5__c,CSS_Job__r.createdDate,Customer_Name__c,Location__c,
                        Location_Code__c,CSS_Job__c,CSS_Job__r.name,Shop_Work_Order__c,SP_Country__c,EngineFamilyName__c,LastModifiedDate,Name, ESN__c, createdDate,Region__c,Territory__c,
                        CoverageResponse__c,Claim_Submitted__c,Account__r.Enable_Claims__c,Account__r.Warranty_Training_Status__c,Distributor_Authorization_FN__c,
                        CreatedBy.Name,Account__r.Warranty_Training_Certification__c,TSR1__c,TSR2__c,TSR3__c,TSR4__c,TSR5__c,TSR6__c,TSR7__c,TSR8__c,TSR9__c,
                        TSR10__c,CSS_Job__r.CSS_In_Shop_Labor_Rate__c,CSS_Job__r.CSS_Field_Service_Labor_Rate__c,CSS_Job__r.CSS_Travel_Rate__c, Catastrophic__c,
                        DesignPhaseCode__c, Service_Model__c,CSS_Channel_Of_Distribution__c,SP_LTA_FLAG__c,SP_PACCAR__c,SP_ACCOUNT_STATUS__c,SP_TERRITORY_CODE__c,
                        SP_PromotionId__c,Repair_Location__c, BillToCode__c, BuildDate__c, EngineFamilyCode__c, EtoConversionDate__c, MarineFlag__c, OemCode__c, 
                        ProductApplicationDesp__c, warrantyIndicatorFlag__c, SP_CHANNEL_OF_DISTRIBUTION__c, CSS_Channel_Code__c, SP_CLAIM_ALLOWED_DAYS__c, 
                        SP_Group_Name__c, SP_CMI_SP_EXPIRATION__c, SP_SCMDollarAmt__c,SP_WarrantyTrainingStatus__c,SP_State__c,SP_SCMDeductiblePercentage__c,
                        SP_OUTFILE_ALL_CLAIMS__c, SP_REGION__c, SP_REGIONCODE__c, SP_TERRITORY__c, CSS_Job__r.Shop_Work_Order__c,Automotive_App_Flag__c,  
                        (Select Id,Name,PSN__c,Make__c,Model__c,Before_In_Service__c,Mission_Disabling__c,Calibration_After__c,Calibration_Before__c,VIN__c,
                         Service_Model__c,Application__c,ApplicationCode__c,Qsol_Engine_Family_Code__c, Failure_Date__c,Mileage__c,Mileage_Measure__c,Justification__c,Unit_Number__c,
                         Warranty_Start_Date__c,Product_Hours__c,CoverageFlag__c, CSS_Claims__c from CSS_PSNs__r where Primary__c=true Limit 1) 
                        from CSS_Claims__c where id=:testclaimsRec.id];
        
        
        Profile p = [SELECT Id FROM Profile WHERE Name='CSS_Service_Advanced']; 
        User usr = new User(Alias = 'standt', Email='standarduser4@testorg.com', 
                            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                            LocaleSidKey='en_US',  ProfileId = p.Id, 
                            TimeZoneSidKey='America/Los_Angeles', UserName='UtilityTestUser14@testorg.com',User_Location__c = '56270-56270');
        insert usr;
        
        CSS_accountLanguage__c accLan = new CSS_accountLanguage__c();
        accLan.CSS_QsolLanguage__c = 'en';
        accLan.Name = 'en_US';
        insert accLan;
        system.debug('usr**'+usr);
        testobj.psnRec = testpsnNewRec;
        testobj.filterMake = 'ACE';
        testobj.filterModel = 'QSB-44-T2';
        testobj.userObj = usr;
        testobj.claimsRec=testclaimsRec;
        ClaimsUEOneBMS.mainContr = testObj;
        
        
        //Start
        test.startTest();
        
        
        //claimsUEOneBMS.startRequest();
        
        
        
        test.stoptest();
    }
    public static Testmethod void CG_CL_ClaimsUEOneBMS_Method12(){ 
        Test.setMock(WebServiceMock.class, new CSS_GetEngineDataPlate_Test()); 
        Test.setMock(HttpCalloutMock.class, new CSS_MockHttpResponseGenerator());
        Test.setMock(HttpCalloutMock.class, new CG_CampaignMock_Test());
        
        CG_CL_ClaimsUEOneBMS claimsUEOneBMS = new CG_CL_ClaimsUEOneBMS();
        claimsUEOneBMS.ExternReturnDateFlag = true;
        claimsUEOneBMS.recconFlag = true;
        claimsUEOneBMS.productAppdesc = 'sneha';
        claimsUEOneBMS.productAppcode ='test';
        Id testsaveClaimedid;
        CSS_Integration_Details__c conDetails = new CSS_Integration_Details__c();
        conDetails.Name = 'GetCampaign';
        conDetails.AuthEnv__c = 'OAGOAUTH';
        conDetails.ApplicationName__c = 'GetCampaign';
        conDetails.End_Point__c = 'Test';
        conDetails.Method_Type__c = 'POST';
        conDetails.Timeout__c = 2.0;
        insert conDetails;
        
        CSS_PSN__c testpsnNewRec = new CSS_PSN__c();
        CSS_Claims__c testclaimsRec = new CSS_Claims__c();
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
        testclaimsRec.EtoConversionDate__c =system.today(); 
        //testclaimsRec.ProductApplicationCode__c= 'test' ;
        //testclaimsREc.ProductApplicationDesp__c='AUTOMOTIVE' ;  
        testclaimsRec.IsCopyclaim__c = true;
        testclaimsRec.ProductApplicationCode__c = 'BB';
        testclaimsRec.ProductApplicationDesp__c = 'BB';
        //testclaimsRec.recursupd = true;
        insert testclaimsRec;
        
        testpsnNewRec.psn__c = '';
        testpsnNewRec.Primary__C = true;
        testpsnNewRec.failure_Date__c = system.today()+20;
        testpsnNewRec.css_claims__C = testclaimsRec.id;
        insert testpsnNewRec;
        CG_CL_ClaimsIntake testobj=new CG_CL_ClaimsIntake();
        testobj.filterApplication = 'abc';
		testobj.tempFailureDate  = system.today();      
        CSS_JobEventTemporary__c  jobEventRef = CSS_TestData.createJobEventTempObj(false);
        jobEventRef.Attribute1__c ='ApplicationCodes';
        jobEventRef.Attribute2__c='TestAtt1';
        jobEventRef.Attribute3__c='AUTOMOTIVE';
        jobEventRef.Attribute5__c = testobj.filterApplication;
        jobEventRef.Key__c='AccountCodes';
        jobEventRef.Reason__c='{"DataArea": {"Details": [{"ApplicationCode": "123","Description": "abc","BusinessUnit": "EBU","AutomotiveFlag": "Y","MarineFlag": "","ActiveFlag": "Y","DefaultUom": "miles"},{"ApplicationCode": "555","Description": "zxcv","BusinessUnit": "PSBU","AutomotiveFlag": "","MarineFlag": "N","ActiveFlag": "Y","DefaultUom": "miles"}]},"Header": {"ReturnCodeDescription": "","Status": "Success"}}';
        insert  jobEventRef;
        
        CSS_JobEventTemporary__c JETproductcode = new CSS_JobEventTemporary__c();
        JETproductcode.Key__c = 'FailCodes';
        JETproductcode.Attribute1__c = 'BB';
        JETproductcode.Attribute3__c = 'AUTOMOTIVE';
        JETproductcode.Attribute2__c = 'TE-ST';
        JETproductcode.Attribute5__c = 'zxcv';
        JETproductcode.Reason__c='{"DataArea": {"Details": [{"ApplicationCode": "123","Description": "abc","BusinessUnit": "EBU","AutomotiveFlag": "Y","MarineFlag": "","ActiveFlag": "Y","DefaultUom": "miles"},{"ApplicationCode": "555","Description": "zxcv","BusinessUnit": "PSBU","AutomotiveFlag": "","MarineFlag": "N","ActiveFlag": "Y","DefaultUom": "miles"}]},"Header": {"ReturnCodeDescription": "","Status": "Success"}}';
        insert JETproductcode;
        
        
        
        Profile p = [SELECT Id FROM Profile WHERE Name='CSS_Service_Advanced']; 
        User usr = new User(Alias = 'standt', Email='standarduser4@testorg.com', 
                            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                            LocaleSidKey='en_US',  ProfileId = p.Id, 
                            TimeZoneSidKey='America/Los_Angeles', UserName='UtilityTestUser14@testorg.com',User_Location__c = '56270-56270');
        insert usr;
        
        CSS_accountLanguage__c accLan = new CSS_accountLanguage__c();
        accLan.CSS_QsolLanguage__c = 'en';
        accLan.Name = 'en_US';
        insert accLan;
        system.debug('usr**'+usr);
        testobj.psnRec = testpsnNewRec;
        testobj.filterMake = 'ACE';
        testobj.filterModel = 'QSB-44-T2';
        testobj.userObj = usr;
        testobj.claimsRec=testclaimsRec;
        ClaimsUEOneBMS.mainContr = testObj;
        
        
        //Start
        test.startTest();
        
        Test.setMock(HttpCalloutMock.class, new CG_CampaignMock_Test());
        Test.setMock(HttpCalloutMock.class, new CSS_getEngineDataResponseJ2A_Mockup_Test());
        Test.setMock(HttpCalloutMock.class, new CSS_GetServiceProviderResponseMock_Test());
       // claimsUEOneBMS.startRequest();
        claimsUEOneBMS.getItems();
        claimsUEOneBMS.getApplication();
        claimsUEOneBMS.recconFlag = true;
        claimsUEOneBMS.startRequest();
        claimsUEOneBMS.updateproductappcode();
        claimsUEOneBMS.getMake();
        claimsUEOneBMS.getModel();
        claimsUEOneBMS.getUnitType();
        
        test.stoptest();
    }
    public static Testmethod void CG_CL_ClaimsUEOneBMS_Method13(){ 
       // Test.setMock(WebServiceMock.class, new CSS_GetEngineDataPlate_Test()); 
       // Test.setMock(HttpCalloutMock.class, new CSS_MockHttpResponseGenerator());
       // Test.setMock(HttpCalloutMock.class, new CG_CampaignMock_Test());
        
        CG_CL_ClaimsUEOneBMS claimsUEOneBMS = new CG_CL_ClaimsUEOneBMS();
        claimsUEOneBMS.ExternReturnDateFlag = true;
        claimsUEOneBMS.recconFlag = true;
        claimsUEOneBMS.productAppdesc = 'sneha';
        claimsUEOneBMS.productAppcode ='test';
        Id testsaveClaimedid;
        CSS_Integration_Details__c conDetails = new CSS_Integration_Details__c();
        conDetails.Name = 'GetCampaign';
        conDetails.AuthEnv__c = 'OAGOAUTH';
        conDetails.ApplicationName__c = 'GetCampaign';
        conDetails.End_Point__c = 'Test';
        conDetails.Method_Type__c = 'POST';
        conDetails.Timeout__c = 2.0;
        insert conDetails;
        
        CSS_PSN__c testpsnNewRec = new CSS_PSN__c();
        CSS_Claims__c testclaimsRec = new CSS_Claims__c();
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
        testclaimsRec.EtoConversionDate__c =system.today(); 
        //testclaimsRec.ProductApplicationCode__c= 'test' ;
        //testclaimsREc.ProductApplicationDesp__c='AUTOMOTIVE' ;  
        testclaimsRec.IsCopyclaim__c = true;
        testclaimsRec.ProductApplicationCode__c = 'BB';
        testclaimsRec.ProductApplicationDesp__c = 'BB';
        //testclaimsRec.recursupd = true;
        insert testclaimsRec;
        
        //testpsnNewRec.psn__c = '';
        testpsnNewRec.PSN__c = '79464646';
        testpsnNewRec.Primary__C = true;
        testpsnNewRec.failure_Date__c = system.today()+20;
        testpsnNewRec.css_claims__C = testclaimsRec.id;
        insert testpsnNewRec;
        CG_CL_ClaimsIntake testobj=new CG_CL_ClaimsIntake();
        testobj.filterApplication = 'abc';
        
        
        CSS_JobEventTemporary__c  jobEventRef = CSS_TestData.createJobEventTempObj(false);
        jobEventRef.Attribute1__c ='ApplicationCodes';
        jobEventRef.Attribute2__c='TestAtt1';
        jobEventRef.Attribute3__c='AUTOMOTIVE';
        jobEventRef.Attribute5__c = testobj.filterApplication;
        jobEventRef.Key__c='AccountCodes';
        jobEventRef.Reason__c='{"DataArea": {"Details": [{"ApplicationCode": "123","Description": "abc","BusinessUnit": "EBU","AutomotiveFlag": "Y","MarineFlag": "","ActiveFlag": "Y","DefaultUom": "miles"},{"ApplicationCode": "555","Description": "zxcv","BusinessUnit": "PSBU","AutomotiveFlag": "","MarineFlag": "N","ActiveFlag": "Y","DefaultUom": "miles"}]},"Header": {"ReturnCodeDescription": "","Status": "Success"}}';
        insert  jobEventRef;
        
        CSS_JobEventTemporary__c JETproductcode = new CSS_JobEventTemporary__c();
        JETproductcode.Key__c = 'FailCodes';
        JETproductcode.Attribute1__c = 'BB';
        JETproductcode.Attribute3__c = 'AUTOMOTIVE';
        JETproductcode.Attribute2__c = 'TE-ST';
        JETproductcode.Attribute5__c = 'zxcv';
        JETproductcode.Reason__c='{"DataArea": {"Details": [{"ApplicationCode": "123","Description": "abc","BusinessUnit": "EBU","AutomotiveFlag": "Y","MarineFlag": "","ActiveFlag": "Y","DefaultUom": "miles"},{"ApplicationCode": "555","Description": "zxcv","BusinessUnit": "PSBU","AutomotiveFlag": "","MarineFlag": "N","ActiveFlag": "Y","DefaultUom": "miles"}]},"Header": {"ReturnCodeDescription": "","Status": "Success"}}';
        insert JETproductcode;
        CSS_JobEventTemporary__c JETproductcode1 = new CSS_JobEventTemporary__c();
        JETproductcode1.Key__c = 'MarketingApplicationCodes';
        JETproductcode1.Attribute1__c = 'BB';
        JETproductcode1.Attribute3__c = 'BB';
        JETproductcode1.Attribute2__c = 'TE-ST';
        JETproductcode1.Attribute5__c = 'zxcv';
        JETproductcode1.Reason__c='{"DataArea": {"Details": [{"ApplicationCode": "123","Description": "abc","BusinessUnit": "EBU","AutomotiveFlag": "Y","MarineFlag": "","ActiveFlag": "Y","DefaultUom": "miles"},{"ApplicationCode": "555","Description": "zxcv","BusinessUnit": "PSBU","AutomotiveFlag": "","MarineFlag": "N","ActiveFlag": "Y","DefaultUom": "miles"}]},"Header": {"ReturnCodeDescription": "","Status": "Success"}}';
        insert JETproductcode1;
        CSS_JobEventTemporary__c JETproductcode11 = new CSS_JobEventTemporary__c();
        JETproductcode11.Key__c = 'MarkpplicationCodes';
        JETproductcode11.Attribute1__c = 'BB';
        JETproductcode11.Attribute3__c = 'BB';
        JETproductcode11.Attribute2__c = '123';
        JETproductcode11.Attribute5__c = 'abc';
        JETproductcode11.Reason__c='{"DataArea": {"Details": [{"ApplicationCode": "123","Description": "abc","BusinessUnit": "EBU","AutomotiveFlag": "Y","MarineFlag": "","ActiveFlag": "Y","DefaultUom": "miles"},{"ApplicationCode": "555","Description": "zxcv","BusinessUnit": "PSBU","AutomotiveFlag": "","MarineFlag": "N","ActiveFlag": "Y","DefaultUom": "miles"}]},"Header": {"ReturnCodeDescription": "","Status": "Success"}}';
        insert JETproductcode11;
        
        //string sQSOLConn = CSS_getConnnectionDetails.getConnection('FailCodes').Key__c;   
        testclaimsRec =[Select Id,CSS_Job__r.General_Symptoms__c,Account__c,CSS_Job__r.Category_Desc__c,CSS_Job__r.Complaint_Type_Desc__c,CSS_Job__r.Category2_Desc__c,
                        CSS_Job__r.Complaint_Type2_Desc__c,CSS_Job__r.Category3_Desc__c,CSS_Job__r.Complaint_Type3_Desc__c,CSS_Job__r.Category4_Desc__c,
                        CSS_Job__r.Complaint_Type4_Desc__c,CSS_Job__r.Category5_Desc__c,CSS_Job__r.Complaint_Type5_Desc__c,Claims_General_Symptoms__c,
                        Claims_Preventive_Maintenance__c,SP_WarrantyCertificationEndDate__c,ProductApplicationCode__c,Claims_Category__c,Claims_Category2__c,Claims_Category3__c,Claims_Category4__c,Claims_Category5__c,
                        Complaint_Type_Desc__c,Complaint_Type2_Desc__c,Complaint_Type3_Desc__c,Complaint_Type4_Desc__c,Complaint_Type5_Desc__c,IsCopyclaim__c,
                        Claims_Expedited_Service__c,Status__c,ODM_Status__c,Claims_Additional_Comments__c,Claims_Category_Desc__c,Claims_Category2_Desc__c,
                        Claims_Category3_Desc__c,Claims_Category4_Desc__c,Claims_Category5_Desc__c,Claims_Complaint_Type__c,Claims_Complaint_Type2__c,
                        Claims_Complaint_Type3__c,Claims_Complaint_Type4__c,account__r.RSS_RESP_BRANCH_CODE__c,SP_PrimaryOEMCode__c,Claims_Complaint_Type5__c,CSS_Job__r.createdDate,Customer_Name__c,Location__c,
                        Location_Code__c,CSS_Job__c,CSS_Job__r.name,Shop_Work_Order__c,SP_Country__c,EngineFamilyName__c,LastModifiedDate,Name, ESN__c, createdDate,Region__c,Territory__c,
                        CoverageResponse__c,Claim_Submitted__c,Account__r.Enable_Claims__c,Account__r.Warranty_Training_Status__c,Distributor_Authorization_FN__c,
                        CreatedBy.Name,Account__r.Warranty_Training_Certification__c,TSR1__c,TSR2__c,TSR3__c,TSR4__c,TSR5__c,TSR6__c,TSR7__c,TSR8__c,TSR9__c,
                        TSR10__c,CSS_Job__r.CSS_In_Shop_Labor_Rate__c,CSS_Job__r.CSS_Field_Service_Labor_Rate__c,CSS_Job__r.CSS_Travel_Rate__c, Catastrophic__c,
                        DesignPhaseCode__c, Service_Model__c,CSS_Channel_Of_Distribution__c,SP_LTA_FLAG__c,SP_PACCAR__c,SP_ACCOUNT_STATUS__c,SP_TERRITORY_CODE__c,
                        SP_PromotionId__c,Repair_Location__c, BillToCode__c, BuildDate__c, EngineFamilyCode__c, EtoConversionDate__c, MarineFlag__c, OemCode__c, 
                        ProductApplicationDesp__c, warrantyIndicatorFlag__c, SP_CHANNEL_OF_DISTRIBUTION__c, CSS_Channel_Code__c, SP_CLAIM_ALLOWED_DAYS__c, 
                        SP_Group_Name__c, SP_CMI_SP_EXPIRATION__c, SP_SCMDollarAmt__c,SP_WarrantyTrainingStatus__c,SP_State__c,SP_SCMDeductiblePercentage__c,
                        SP_OUTFILE_ALL_CLAIMS__c, SP_REGION__c, SP_REGIONCODE__c, SP_TERRITORY__c, CSS_Job__r.Shop_Work_Order__c,Automotive_App_Flag__c,  
                        (Select Id,Name,PSN__c,Make__c,Model__c,Before_In_Service__c,Mission_Disabling__c,Calibration_After__c,Calibration_Before__c,VIN__c,
                         Service_Model__c,Application__c,ApplicationCode__c,Qsol_Engine_Family_Code__c, Failure_Date__c,Mileage__c,Mileage_Measure__c,Justification__c,Unit_Number__c,
                         Warranty_Start_Date__c,Product_Hours__c,CoverageFlag__c, CSS_Claims__c from CSS_PSNs__r where Primary__c=true Limit 1) 
                        from CSS_Claims__c where id=:testclaimsRec.id];
        
        
        Profile p = [SELECT Id FROM Profile WHERE Name='CSS_Service_Advanced']; 
        User usr = new User(Alias = 'standt', Email='standarduser4@testorg.com', 
                            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                            LocaleSidKey='en_US',  ProfileId = p.Id, 
                            TimeZoneSidKey='America/Los_Angeles', UserName='UtilityTestUser14@testorg.com',User_Location__c = '56270-56270');
        insert usr;
        
        CSS_accountLanguage__c accLan = new CSS_accountLanguage__c();
        accLan.CSS_QsolLanguage__c = 'en';
        accLan.Name = 'en_US';
        insert accLan;
        system.debug('usr**'+usr);
        testobj.psnRec = testpsnNewRec;
        testobj.filterMake = 'ACE';
        testobj.filterModel = 'QSB-44-T2';
        testobj.userObj = usr;
        testobj.claimsRec=testclaimsRec;
        ClaimsUEOneBMS.mainContr = testObj;
        
        
        //Start
        test.startTest();
        
        //Test.setMock(HttpCalloutMock.class, new CG_CampaignMock_Test());
        //Test.setMock(HttpCalloutMock.class, new CSS_getEngineDataResponseJ2A_Mockup_Test());
       // Test.setMock(HttpCalloutMock.class, new CSS_GetServiceProviderResponseMock_Test());
       // claimsUEOneBMS.startRequest();
        claimsUEOneBMS.getItems();
        claimsUEOneBMS.getApplication();
        claimsUEOneBMS.recconFlag = true;
        //claimsUEOneBMS.startRequest();
        claimsUEOneBMS.updateproductappcode();
        claimsUEOneBMS.getMake();
        claimsUEOneBMS.getModel();
        claimsUEOneBMS.getUnitType();
        
        test.stoptest();
    }
    public static Testmethod void CG_CL_ClaimsUEOneBMS_Method131(){ 
       // Test.setMock(WebServiceMock.class, new CSS_GetEngineDataPlate_Test()); 
       // Test.setMock(HttpCalloutMock.class, new CSS_MockHttpResponseGenerator());
       // Test.setMock(HttpCalloutMock.class, new CG_CampaignMock_Test());
        Test.setMock(HttpCalloutMock.class, new CG_WS_QSOLMock());  
       
        Id testsaveClaimedid;
          CSS_Integration_Details__c inteDetails = new CSS_Integration_Details__c();
        inteDetails.Name = 'CSS_SPDataLookup';
        inteDetails.ApplicationName__c = 'CSS_SPDataLookup';
        inteDetails.End_Point__c = 'https://services-stg.cummins.com/csswarranty/serviceproviderdata';
        inteDetails.IsActive__c = true;
        inteDetails.Key__c = 'DqOMliimooXThF1e2jaIPuaiu3SQndU0mwfHxspQYC0';
        inteDetails.Passcode__c = 'S8wjknFfHQk80axJn3OibETXc/600kyrLA8oUaxFKJ4=';
        inteDetails.Username__c = 'qay1+7OVYoeaAeq5V5oXd+XpT8T5kyqP4YcyQI+pLdM=';
        insert inteDetails; 
        CSS_Integration_Details__c conDetails = new CSS_Integration_Details__c();
        conDetails.Name = 'GetCampaign';
        conDetails.AuthEnv__c = 'OAGOAUTH';
        conDetails.ApplicationName__c = 'GetCampaign';
        conDetails.End_Point__c = 'Test';
        conDetails.Method_Type__c = 'POST';
        conDetails.Timeout__c = 2.0;
        insert conDetails;
      /*  CSS_Integration_Details__c conDetails8 = new CSS_Integration_Details__c();
        conDetails8.Name = 'GetEngineDataPlateQSOLREST';
        conDetails8.AuthEnv__c = 'OAGOAUTH';
        conDetails8.ApplicationName__c = 'GetEngineDataPlateQSOLREST';
        conDetails8.End_Point__c = 'Test';
        conDetails8.Method_Type__c = 'POST';
        conDetails8.Timeout__c = 2.0;
        conDetails8.Username__c='testy';
        conDetails8.Passcode__c = 'test';
        conDetails8.Method_Type__c = 'test';
        insert conDetails8;*/
         CG_CL_ClaimsUEOneBMS IntakeJob2 = new CG_CL_ClaimsUEOneBMS();
        CG_CL_IntakeVH invh = new CG_CL_IntakeVH();
        CG_CL_IntakeRJ inrj = new CG_CL_IntakeRJ();
       // IntakeJob1.mainContrVH = invh;
        //IntakeJob1.mainContrRJ = inrj;
        CSS_Integration_Details__c conDetails1 = new CSS_Integration_Details__c();
        conDetails1.Name = 'GetEngineDataPlateQSOLREST';
        conDetails1.AuthEnv__c = 'OAGOAUTH';
        conDetails1.ApplicationName__c = 'GetEngineDataPlateQSOLREST';
        conDetails1.End_Point__c = 'Test';
        conDetails1.Method_Type__c = 'POST';
       conDetails1.Username__c = 'POST';
       conDetails1.Passcode__c = 'POST';
        conDetails1.Timeout__c = 2.0;
        insert conDetails1;
        CSS_PSN__c testpsnNewRec = new CSS_PSN__c();
        CSS_Claims__c testclaimsRec = new CSS_Claims__c();
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
        testclaimsRec.EtoConversionDate__c =system.today(); 
        //testclaimsRec.ProductApplicationCode__c= 'test' ;
        //testclaimsREc.ProductApplicationDesp__c='AUTOMOTIVE' ;  
        testclaimsRec.IsCopyclaim__c = true;
        testclaimsRec.ProductApplicationCode__c = 'BB';
        testclaimsRec.ProductApplicationDesp__c = 'BB';
        //testclaimsRec.recursupd = true;
        insert testclaimsRec;
        
        //testpsnNewRec.psn__c = '';
        testpsnNewRec.PSN__c = '79464646';
        testpsnNewRec.Primary__C = true;
        testpsnNewRec.failure_Date__c = system.today()+20;
        testpsnNewRec.css_claims__C = testclaimsRec.id;
        insert testpsnNewRec;
        CG_CL_ClaimsIntake testobj=new CG_CL_ClaimsIntake();
        testobj.filterApplication = 'abc';
         Account acc = new Account();
         acc.name='Rajesh';
         insert acc;
         Contact con = new Contact();
         con.lastname='rajesh';
         con.FirstName='Test2';
         con.AccountId=acc.Id;
         insert con;
         List<Asset> lstAsset = new List<Asset>();
         Asset ass = new Asset();
         ass.Name='test';
         ass.SerialNumber =  testpsnNewRec.PSN__c;
         ass.Type__c='Products';
         ass.AccountId=acc.Id;
         ass.ContactId=con.Id;
         insert ass;

      
        CSS_JobEventTemporary__c  jobEventRef = CSS_TestData.createJobEventTempObj(false);
        jobEventRef.Attribute1__c ='ApplicationCodes';
        jobEventRef.Attribute2__c='TestAtt1';
        jobEventRef.Attribute3__c='AUTOMOTIVE';
        jobEventRef.Attribute5__c = testobj.filterApplication;
        jobEventRef.Key__c='AccountCodes';
        jobEventRef.Reason__c='{"DataArea": {"Details": [{"ApplicationCode": "123","Description": "abc","BusinessUnit": "EBU","AutomotiveFlag": "Y","MarineFlag": "","ActiveFlag": "Y","DefaultUom": "miles"},{"ApplicationCode": "555","Description": "zxcv","BusinessUnit": "PSBU","AutomotiveFlag": "","MarineFlag": "N","ActiveFlag": "Y","DefaultUom": "miles"}]},"Header": {"ReturnCodeDescription": "","Status": "Success"}}';
        insert  jobEventRef;
        
        CSS_JobEventTemporary__c JETproductcode = new CSS_JobEventTemporary__c();
        JETproductcode.Key__c = 'FailCodes';
        JETproductcode.Attribute1__c = 'BB';
        JETproductcode.Attribute3__c = 'AUTOMOTIVE';
        JETproductcode.Attribute2__c = 'TE-ST';
        JETproductcode.Attribute5__c = 'zxcv';
        JETproductcode.Reason__c='{"DataArea": {"Details": [{"ApplicationCode": "123","Description": "abc","BusinessUnit": "EBU","AutomotiveFlag": "Y","MarineFlag": "","ActiveFlag": "Y","DefaultUom": "miles"},{"ApplicationCode": "555","Description": "zxcv","BusinessUnit": "PSBU","AutomotiveFlag": "","MarineFlag": "N","ActiveFlag": "Y","DefaultUom": "miles"}]},"Header": {"ReturnCodeDescription": "","Status": "Success"}}';
        insert JETproductcode;
        CSS_JobEventTemporary__c JETproductcode1 = new CSS_JobEventTemporary__c();
        JETproductcode1.Key__c = 'MarketingApplicationCodes';
        JETproductcode1.Attribute1__c = 'BB';
        JETproductcode1.Attribute3__c = 'BB';
        JETproductcode1.Attribute2__c = 'TE-ST';
        JETproductcode1.Attribute5__c = 'zxcv';
        JETproductcode1.Reason__c='{"DataArea": {"Details": [{"ApplicationCode": "123","Description": "abc","BusinessUnit": "EBU","AutomotiveFlag": "Y","MarineFlag": "","ActiveFlag": "Y","DefaultUom": "miles"},{"ApplicationCode": "555","Description": "zxcv","BusinessUnit": "PSBU","AutomotiveFlag": "","MarineFlag": "N","ActiveFlag": "Y","DefaultUom": "miles"}]},"Header": {"ReturnCodeDescription": "","Status": "Success"}}';
        insert JETproductcode1;
        CSS_JobEventTemporary__c JETproductcode11 = new CSS_JobEventTemporary__c();
        JETproductcode11.Key__c = 'MarkpplicationCodes';
        JETproductcode11.Attribute1__c = 'BB';
        JETproductcode11.Attribute3__c = 'BB';
        JETproductcode11.Attribute2__c = '123';
        JETproductcode11.Attribute5__c = 'abc';
        JETproductcode11.Reason__c='{"DataArea": {"Details": [{"ApplicationCode": "123","Description": "abc","BusinessUnit": "EBU","AutomotiveFlag": "Y","MarineFlag": "","ActiveFlag": "Y","DefaultUom": "miles"},{"ApplicationCode": "555","Description": "zxcv","BusinessUnit": "PSBU","AutomotiveFlag": "","MarineFlag": "N","ActiveFlag": "Y","DefaultUom": "miles"}]},"Header": {"ReturnCodeDescription": "","Status": "Success"}}';
        insert JETproductcode11;
        
        //string sQSOLConn = CSS_getConnnectionDetails.getConnection('FailCodes').Key__c;   
        testclaimsRec =[Select Id,CSS_Job__r.General_Symptoms__c,Account__c,CSS_Job__r.Category_Desc__c,CSS_Job__r.Complaint_Type_Desc__c,CSS_Job__r.Category2_Desc__c,
                        CSS_Job__r.Complaint_Type2_Desc__c,CSS_Job__r.Category3_Desc__c,CSS_Job__r.Complaint_Type3_Desc__c,CSS_Job__r.Category4_Desc__c,
                        CSS_Job__r.Complaint_Type4_Desc__c,CSS_Job__r.Category5_Desc__c,CSS_Job__r.Complaint_Type5_Desc__c,Claims_General_Symptoms__c,
                        Claims_Preventive_Maintenance__c,SP_WarrantyCertificationEndDate__c,ProductApplicationCode__c,Claims_Category__c,Claims_Category2__c,Claims_Category3__c,Claims_Category4__c,Claims_Category5__c,
                        Complaint_Type_Desc__c,Complaint_Type2_Desc__c,Complaint_Type3_Desc__c,Complaint_Type4_Desc__c,Complaint_Type5_Desc__c,IsCopyclaim__c,
                        Claims_Expedited_Service__c,Status__c,ODM_Status__c,Claims_Additional_Comments__c,Claims_Category_Desc__c,Claims_Category2_Desc__c,
                        Claims_Category3_Desc__c,Claims_Category4_Desc__c,Claims_Category5_Desc__c,Claims_Complaint_Type__c,Claims_Complaint_Type2__c,
                        Claims_Complaint_Type3__c,Claims_Complaint_Type4__c,account__r.RSS_RESP_BRANCH_CODE__c,SP_PrimaryOEMCode__c,Claims_Complaint_Type5__c,CSS_Job__r.createdDate,Customer_Name__c,Location__c,
                        Location_Code__c,CSS_Job__c,CSS_Job__r.name,Shop_Work_Order__c,SP_Country__c,EngineFamilyName__c,LastModifiedDate,Name, ESN__c, createdDate,Region__c,Territory__c,
                        CoverageResponse__c,Claim_Submitted__c,Account__r.Enable_Claims__c,Account__r.Warranty_Training_Status__c,Distributor_Authorization_FN__c,
                        CreatedBy.Name,Account__r.Warranty_Training_Certification__c,TSR1__c,TSR2__c,TSR3__c,TSR4__c,TSR5__c,TSR6__c,TSR7__c,TSR8__c,TSR9__c,
                        TSR10__c,CSS_Job__r.CSS_In_Shop_Labor_Rate__c,CSS_Job__r.CSS_Field_Service_Labor_Rate__c,CSS_Job__r.CSS_Travel_Rate__c, Catastrophic__c,
                        DesignPhaseCode__c, Service_Model__c,CSS_Channel_Of_Distribution__c,SP_LTA_FLAG__c,SP_PACCAR__c,SP_ACCOUNT_STATUS__c,SP_TERRITORY_CODE__c,
                        SP_PromotionId__c,Repair_Location__c, BillToCode__c, BuildDate__c, EngineFamilyCode__c, EtoConversionDate__c, MarineFlag__c, OemCode__c, 
                        ProductApplicationDesp__c, warrantyIndicatorFlag__c, SP_CHANNEL_OF_DISTRIBUTION__c, CSS_Channel_Code__c, SP_CLAIM_ALLOWED_DAYS__c, 
                        SP_Group_Name__c, SP_CMI_SP_EXPIRATION__c, SP_SCMDollarAmt__c,SP_WarrantyTrainingStatus__c,SP_State__c,SP_SCMDeductiblePercentage__c,
                        SP_OUTFILE_ALL_CLAIMS__c, SP_REGION__c, SP_REGIONCODE__c, SP_TERRITORY__c, CSS_Job__r.Shop_Work_Order__c,Automotive_App_Flag__c,  
                        (Select Id,Name,PSN__c,Make__c,Model__c,Before_In_Service__c,Mission_Disabling__c,Calibration_After__c,Calibration_Before__c,VIN__c,
                         Service_Model__c,Application__c,ApplicationCode__c,Qsol_Engine_Family_Code__c, Failure_Date__c,Mileage__c,Mileage_Measure__c,Justification__c,Unit_Number__c,
                         Warranty_Start_Date__c,Product_Hours__c,CoverageFlag__c, CSS_Claims__c from CSS_PSNs__r where Primary__c=true Limit 1) 
                        from CSS_Claims__c where id=:testclaimsRec.id];
        
        
        Profile p = [SELECT Id FROM Profile WHERE Name='CSS_Service_Advanced']; 
        User usr = new User(Alias = 'standt', Email='standarduser4@testorg.com', 
                            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                            LocaleSidKey='en_US',  ProfileId = p.Id, 
                            TimeZoneSidKey='America/Los_Angeles', UserName='UtilityTestUser14@testorg.com',User_Location__c = '56270-56270');
        insert usr;
        
        CSS_accountLanguage__c accLan = new CSS_accountLanguage__c();
        accLan.CSS_QsolLanguage__c = 'en';
        accLan.Name = 'en_US';
        insert accLan;
        system.debug('usr**'+usr);
        testobj.psnRec = testpsnNewRec;
        testobj.filterMake = 'ACE';
        testobj.filterModel = 'QSB-44-T2';
        testobj.userObj = usr;
        testobj.claimsRec=testclaimsRec;
         testobj.LocationManualClaims = '02466';
      
       
        system.debug('inteDetails '+inteDetails);
        //Start
        test.startTest();
        system.runAs(usr){
            
       
          system.debug('inteDetails1 '+inteDetails);
          Test.setMock(HttpCalloutMock.class , new CSS_MockHttpResponseGenerator());
         Test.setMock(HttpCalloutMock.class, new CSS_GetServiceProviderResponseMock_Test());
        //Test.setMock(HttpCalloutMock.class, new CG_CampaignMock_Test());
        //Test.setMock(HttpCalloutMock.class, new CSS_getEngineDataResponseJ2A_Mockup_Test());
       // Test.setMock(HttpCalloutMock.class, new CSS_GetServiceProviderResponseMock_Test());
       // claimsUEOneBMS.startRequest();
         CG_CL_ClaimsUEOneBMS claimsUEOneBMS = new CG_CL_ClaimsUEOneBMS();
        ClaimsUEOneBMS.mainContr = testObj;
        claimsUEOneBMS.ExternReturnDateFlag = true;
        claimsUEOneBMS.recconFlag = true;
        claimsUEOneBMS.productAppdesc = 'sneha';
        claimsUEOneBMS.productAppcode ='test';
        claimsUEOneBMS.getItems();
        claimsUEOneBMS.getApplication();
        claimsUEOneBMS.recconFlag = true;
        //claimsUEOneBMS.startRequest();
        claimsUEOneBMS.updateproductappcode();
        claimsUEOneBMS.getMake();
        claimsUEOneBMS.getModel();
        claimsUEOneBMS.getUnitType();
        claimsUEOneBMS.parseQSOLDate('01 Jan 2019');
        claimsUEOneBMS.getFormatDate();
        claimsUEOneBMS.getFormattedFailureDate();
         claimsUEOneBMS.getJustification();
          claimsUEOneBMS.getlicensePlateList();
        }
        test.stoptest();
    }
    public static Testmethod void CG_CL_ClaimsUEOneBMS_Method14(){ 
        Test.setMock(WebServiceMock.class, new CSS_GetEngineDataPlate_Test()); 
        Test.setMock(HttpCalloutMock.class, new CSS_MockHttpResponseGenerator());
        Test.setMock(HttpCalloutMock.class, new CG_CampaignMock_Test());
        Account acc = new Account();
        acc.name='Kenworth Sales Co';
        acc.CSS_DistributorCode__c='02466';
        acc.IAM_Service_Provider_Code__c='19134';
        acc.Type='Dealer Account';
        acc.CMI_Account_Status__c = 'Active';
        insert acc;

        CG_CL_ClaimsUEOneBMS claimsUEOneBMS = new CG_CL_ClaimsUEOneBMS();
        claimsUEOneBMS.ExternReturnDateFlag = true;
        claimsUEOneBMS.recconFlag = true;
        claimsUEOneBMS.productAppdesc = 'sneha';
        claimsUEOneBMS.productAppcode ='test';
        Id testsaveClaimedid;
        CSS_Integration_Details__c conDetails = new CSS_Integration_Details__c();
        conDetails.Name = 'GetCampaign';
        conDetails.AuthEnv__c = 'OAGOAUTH';
        conDetails.ApplicationName__c = 'GetCampaign';
        conDetails.End_Point__c = 'Test';
        conDetails.Method_Type__c = 'POST';
        conDetails.Timeout__c = 2.0;
        insert conDetails;
        
        CSS_PSN__c testpsnNewRec = new CSS_PSN__c();
        CSS_Claims__c testclaimsRec = new CSS_Claims__c();
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
        testclaimsRec.EtoConversionDate__c =system.today(); 
        //testclaimsRec.ProductApplicationCode__c= 'test' ;
        //testclaimsREc.ProductApplicationDesp__c='AUTOMOTIVE' ;  
        testclaimsRec.IsCopyclaim__c = true;
        testclaimsRec.ProductApplicationCode__c = 'BB';
        testclaimsRec.ProductApplicationDesp__c = 'BB';
        //testclaimsRec.recursupd = true;
        insert testclaimsRec;
        
        testpsnNewRec.psn__c = '';
        testpsnNewRec.Primary__C = true;
        testpsnNewRec.failure_Date__c = system.today()+20;
        testpsnNewRec.css_claims__C = testclaimsRec.id;
        insert testpsnNewRec;
        CG_CL_ClaimsIntake testobj=new CG_CL_ClaimsIntake();
        testobj.filterApplication = 'abc';
        testobj.claimsRec.id = null;
        
        CSS_JobEventTemporary__c  jobEventRef = CSS_TestData.createJobEventTempObj(false);
        jobEventRef.Attribute1__c ='ApplicationCodes';
        jobEventRef.Attribute2__c='TestAtt1';
        jobEventRef.Attribute3__c='AUTOMOTIVE';
        jobEventRef.Attribute5__c = testobj.filterApplication;
        jobEventRef.Key__c='AccountCodes';
        jobEventRef.Reason__c='{"DataArea": {"Details": [{"ApplicationCode": "123","Description": "abc","BusinessUnit": "EBU","AutomotiveFlag": "Y","MarineFlag": "","ActiveFlag": "Y","DefaultUom": "miles"},{"ApplicationCode": "555","Description": "zxcv","BusinessUnit": "PSBU","AutomotiveFlag": "","MarineFlag": "N","ActiveFlag": "Y","DefaultUom": "miles"}]},"Header": {"ReturnCodeDescription": "","Status": "Success"}}';
        insert  jobEventRef;
        
        CSS_JobEventTemporary__c JETproductcode = new CSS_JobEventTemporary__c();
        JETproductcode.Key__c = 'FailCodes';
        JETproductcode.Attribute1__c = 'BB';
        JETproductcode.Attribute3__c = 'AUTOMOTIVE';
        JETproductcode.Attribute2__c = 'TE-ST';
        JETproductcode.Attribute5__c = 'zxcv';
        JETproductcode.Reason__c='{"DataArea": {"Details": [{"ApplicationCode": "123","Description": "abc","BusinessUnit": "EBU","AutomotiveFlag": "Y","MarineFlag": "","ActiveFlag": "Y","DefaultUom": "miles"},{"ApplicationCode": "555","Description": "zxcv","BusinessUnit": "PSBU","AutomotiveFlag": "","MarineFlag": "N","ActiveFlag": "Y","DefaultUom": "miles"}]},"Header": {"ReturnCodeDescription": "","Status": "Success"}}';
        insert JETproductcode;
        CSS_JobEventTemporary__c JETproductcode1 = new CSS_JobEventTemporary__c();
        JETproductcode1.Key__c = 'MarketingApplicationCodes';
        JETproductcode1.Attribute1__c = 'BB';
        JETproductcode1.Attribute3__c = 'BB';
        JETproductcode1.Attribute2__c = '123';
        JETproductcode1.Attribute5__c = 'abc';
        JETproductcode1.Reason__c='{"DataArea": {"Details": [{"ApplicationCode": "123","Description": "abc","BusinessUnit": "EBU","AutomotiveFlag": "Y","MarineFlag": "","ActiveFlag": "Y","DefaultUom": "miles"},{"ApplicationCode": "555","Description": "zxcv","BusinessUnit": "PSBU","AutomotiveFlag": "","MarineFlag": "N","ActiveFlag": "Y","DefaultUom": "miles"}]},"Header": {"ReturnCodeDescription": "","Status": "Success"}}';
        insert JETproductcode1;
        CSS_JobEventTemporary__c JETproductcode11 = new CSS_JobEventTemporary__c();
        JETproductcode11.Key__c = 'MarkpplicationCodes';
        JETproductcode11.Attribute1__c = 'BB';
        JETproductcode11.Attribute3__c = 'BB';
        JETproductcode11.Attribute2__c = '1dd23';
        JETproductcode11.Attribute5__c = 'abdc';
        JETproductcode11.Reason__c='{"DataArea": {"Details": [{"ApplicationCode": "123","Description": "abc","BusinessUnit": "EBU","AutomotiveFlag": "Y","MarineFlag": "","ActiveFlag": "Y","DefaultUom": "miles"},{"ApplicationCode": "555","Description": "zxcv","BusinessUnit": "PSBU","AutomotiveFlag": "","MarineFlag": "N","ActiveFlag": "Y","DefaultUom": "miles"}]},"Header": {"ReturnCodeDescription": "","Status": "Success"}}';
        insert JETproductcode11;
        
        //string sQSOLConn = CSS_getConnnectionDetails.getConnection('FailCodes').Key__c;   
        testclaimsRec =[Select Id,CSS_Job__r.General_Symptoms__c,Account__c,CSS_Job__r.Category_Desc__c,CSS_Job__r.Complaint_Type_Desc__c,CSS_Job__r.Category2_Desc__c,
                        CSS_Job__r.Complaint_Type2_Desc__c,CSS_Job__r.Category3_Desc__c,CSS_Job__r.Complaint_Type3_Desc__c,CSS_Job__r.Category4_Desc__c,
                        CSS_Job__r.Complaint_Type4_Desc__c,CSS_Job__r.Category5_Desc__c,CSS_Job__r.Complaint_Type5_Desc__c,Claims_General_Symptoms__c,
                        Claims_Preventive_Maintenance__c,SP_WarrantyCertificationEndDate__c,ProductApplicationCode__c,Claims_Category__c,Claims_Category2__c,Claims_Category3__c,Claims_Category4__c,Claims_Category5__c,
                        Complaint_Type_Desc__c,Complaint_Type2_Desc__c,Complaint_Type3_Desc__c,Complaint_Type4_Desc__c,Complaint_Type5_Desc__c,IsCopyclaim__c,
                        Claims_Expedited_Service__c,Status__c,ODM_Status__c,Claims_Additional_Comments__c,Claims_Category_Desc__c,Claims_Category2_Desc__c,
                        Claims_Category3_Desc__c,Claims_Category4_Desc__c,Claims_Category5_Desc__c,Claims_Complaint_Type__c,Claims_Complaint_Type2__c,
                        Claims_Complaint_Type3__c,Claims_Complaint_Type4__c,account__r.RSS_RESP_BRANCH_CODE__c,SP_PrimaryOEMCode__c,Claims_Complaint_Type5__c,CSS_Job__r.createdDate,Customer_Name__c,Location__c,
                        Location_Code__c,CSS_Job__c,CSS_Job__r.name,Shop_Work_Order__c,SP_Country__c,EngineFamilyName__c,LastModifiedDate,Name, ESN__c, createdDate,Region__c,Territory__c,
                        CoverageResponse__c,Claim_Submitted__c,Account__r.Enable_Claims__c,Account__r.Warranty_Training_Status__c,Distributor_Authorization_FN__c,
                        CreatedBy.Name,Account__r.Warranty_Training_Certification__c,TSR1__c,TSR2__c,TSR3__c,TSR4__c,TSR5__c,TSR6__c,TSR7__c,TSR8__c,TSR9__c,
                        TSR10__c,CSS_Job__r.CSS_In_Shop_Labor_Rate__c,CSS_Job__r.CSS_Field_Service_Labor_Rate__c,CSS_Job__r.CSS_Travel_Rate__c, Catastrophic__c,
                        DesignPhaseCode__c, Service_Model__c,CSS_Channel_Of_Distribution__c,SP_LTA_FLAG__c,SP_PACCAR__c,SP_ACCOUNT_STATUS__c,SP_TERRITORY_CODE__c,
                        SP_PromotionId__c,Repair_Location__c, BillToCode__c, BuildDate__c, EngineFamilyCode__c, EtoConversionDate__c, MarineFlag__c, OemCode__c, 
                        ProductApplicationDesp__c, warrantyIndicatorFlag__c, SP_CHANNEL_OF_DISTRIBUTION__c, CSS_Channel_Code__c, SP_CLAIM_ALLOWED_DAYS__c, 
                        SP_Group_Name__c, SP_CMI_SP_EXPIRATION__c, SP_SCMDollarAmt__c,SP_WarrantyTrainingStatus__c,SP_State__c,SP_SCMDeductiblePercentage__c,
                        SP_OUTFILE_ALL_CLAIMS__c, SP_REGION__c, SP_REGIONCODE__c, SP_TERRITORY__c, CSS_Job__r.Shop_Work_Order__c,Automotive_App_Flag__c,  
                        (Select Id,Name,PSN__c,Make__c,Model__c,Before_In_Service__c,Mission_Disabling__c,Calibration_After__c,Calibration_Before__c,VIN__c,
                         Service_Model__c,Application__c,ApplicationCode__c,Qsol_Engine_Family_Code__c, Failure_Date__c,Mileage__c,Mileage_Measure__c,Justification__c,Unit_Number__c,
                         Warranty_Start_Date__c,Product_Hours__c,CoverageFlag__c, CSS_Claims__c from CSS_PSNs__r where Primary__c=true Limit 1) 
                        from CSS_Claims__c where id=:testclaimsRec.id];
        
        
        Profile p = [SELECT Id FROM Profile WHERE Name='CSS_Service_Advanced']; 
        User usr = new User(Alias = 'standt', Email='standarduser4@testorg.com', 
                            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                            LocaleSidKey='en_US',  ProfileId = p.Id, 
                            TimeZoneSidKey='America/Los_Angeles', UserName='UtilityTestUser14@testorg.com',User_Location__c = '56270-56270');
        insert usr;
        
        CSS_accountLanguage__c accLan = new CSS_accountLanguage__c();
        accLan.CSS_QsolLanguage__c = 'en';
        accLan.Name = 'en_US';
        insert accLan;
        system.debug('usr**'+usr);
        testobj.psnRec = testpsnNewRec;
        testobj.filterMake = 'ACE';
        testobj.filterModel = 'QSB-44-T2';
        testobj.userObj = usr;
        testobj.claimsRec.id=null;
        testobj.LocationManualClaims = '19134';
        ClaimsUEOneBMS.mainContr = testObj;
        
        
        //Start
        test.startTest();
        
        // Test.setMock(HttpCalloutMock.class, new CG_CampaignMock_Test());
        // Test.setMock(HttpCalloutMock.class, new CSS_getEngineDataResponseJ2A_Mockup_Test());
        //Test.setMock(HttpCalloutMock.class, new CSS_GetServiceProviderResponseMock_Test());
        claimsUEOneBMS.getCampaignDetails();
       // claimsUEOneBMS.startRequest();
        claimsUEOneBMS.getItems();
        claimsUEOneBMS.getApplication();
        claimsUEOneBMS.recconFlag = true;
       claimsUEOneBMS.startRequest();
        claimsUEOneBMS.updateproductappcode();
        claimsUEOneBMS.getMake();
        claimsUEOneBMS.getModel();
        claimsUEOneBMS.getUnitType();
        
        test.stoptest();
    }
}