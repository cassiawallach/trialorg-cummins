@isTest
Public Class CSS_WS_ControllerClaim_Test {  
    Public Static testMethod Void testMethodsLists(){
        PageReference pageRef = Page.CSS_WS_ClaimFormat;
        Account DealerTest = new Account(
            IAM_Service_Provider_Code__c = '54732',
            CSS_DBCode__c = '54734',
            Type = 'Dealer Account',
            Name = 'Dummy Dealer',
            CMI_Account_Status__c = 'Active',
            BillingCountry = 'Mexico');
        insert DealerTest;
        
        Account DRTest = new Account(
            IAM_Service_Provider_Code__c = '54734',
            CSS_DBCode__c = '54734',
            Type = 'Distributor Account',
            Name = 'Dummy DR',
            CMI_Account_Status__c = 'Active',
            BillingCountry = 'Mexico');
        insert DRTest;
        
        Account CustomerTest = new Account(
            IAM_Service_Provider_Code__c = '1234',
            CSS_DBCode__c = '5432',
            Type = 'Customer',
            CMI_Account_Status__c = 'Active',
            Name = 'Sony');
        insert CustomerTest;
        
        CSS_WS_Make_And_Model__c AccsTest = new CSS_WS_Make_And_Model__c(
            CSS_WS_Make__c = '12349',
            CSS_WS_Engine_Family_Code__c = '12',
            CSS_WS_Model__c = 'XLF-123',
            Name = 'Sony1', 
            CSS_WS_Unique_Id__c = '123-abc-01');
        insert AccsTest;
        
        CSS_WS_Make_And_Model__c AccsTest2 = new CSS_WS_Make_And_Model__c(
            CSS_WS_Make__c = '12349',
            CSS_WS_Engine_Family_Code__c = '12',
            CSS_WS_Model__c = 'XLF-124',
            Name = 'Sony2', 
            CSS_WS_Unique_Id__c = '123-abc-02');
        insert AccsTest2;
        
        CSS_WS_Complaints_Master_Catalogue__c ComplaTest = new CSS_WS_Complaints_Master_Catalogue__c(
            Name = 'Break',
            CSS_WS_Code_Name__c = '900',
            CSS_WS_Desc_Text__c = 'Break');
        insert ComplaTest;
        
        CSS_WS_Account_Code_for_Warranty_Catalog__c AccsWarTest = new CSS_WS_Account_Code_for_Warranty_Catalog__c(
            CSS_WS_Account_Code__c = 'P90',
            CSS_WS_Usage__c = 'Warranty',
            Name = 'Account Test');
        insert AccsWarTest;
        
        CSS_WS_Engine_Application_Code__c EngineAppTest =  new CSS_WS_Engine_Application_Code__c(
            Application_Description__c = 'AUTOMOTIVE',
            Name = 'AUTOMOTIVE',
            Default_Measurement__c = 'KM');
        insert EngineAppTest;
        
        String start = '9/10/2014 5:04 PM';
        String[] datStart = start.split(' ');
        String Fail = '9/12/2015 5:04 PM';
        String[] datFail = Fail.split(' ');
        date var = system.today();
        
        CSS_WS_Warranty__c claim = new CSS_WS_Warranty__c(
            CSS_WS_Warranty_Start_Date__c = date.parse(datStart[0]),
            CSS_WS_Engine_Serial_Number__c = '10000000',
            CSS_WS_Service_Provider_DR__c = '54734',
            CSS_WS_Service_Provider_Dealer__c = '54732',
            CSS_WS_Policy_Flag__c = 'Warranty',
            CSS_WS_Account_Code__c = null,
            CSS_WS_Failure_Date_Time__c = date.parse(datFail[0]),
            CSS_WS_Engine_Family_Code__c = '12',
            CSS_WS_Manufacturer__c = AccsTest.CSS_WS_Make__c,
            CSS_WS_Customer_Name_Internal__c = CustomerTest.id,
            CSS_WS_Model_Series__c = 'XLF-124',
            Is_Clone__c = 1);
        insert claim; 
        
        Fail = '9/10/2015 5:04 PM';
        datFail = Fail.split(' ');
        
        CSS_WS_Policy_Campaign_Decision_table__c polCampaigns = new CSS_WS_Policy_Campaign_Decision_table__c(
            Name = 'Hello', 
            Policy_Campaign_Name__c = 'CamNameTest',
            Business_Name__c = CustomerTest.Name,
            Program_Start_Date__c = date.parse(datFail[0]),
            Program_End_Date__c = date.parse(datFail[0]).addDays(5),
            Years_In_Service__c = 1);
        insert polCampaigns;
        
        Blob key = Blob.valueOf('12345678901234567890123456789012');
        CSS_Integration_Details__c MxTestConnection1 = new CSS_Integration_Details__c(
            Name = 'MxEngData',
            ApplicationName__c = 'MxEngData',
            End_Point__c = 'https://api-ue-devnf-aw-ex.cummins.com/api/core-security-api/v1/auth/token/MxEngData',
            IsActive__c = True,
            Method_Type__c = 'GET',
            AuthEnv__c = 'MxAuthEngi',
            Key__c =  EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('https://api-ue-devnf-aw-ex.cummins.com/cmi-engine'))),
            Passcode__c = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('~6_5~e.~8D19I0Sw7YSNtq2kiAgK5bA.w3'))),
            Username__c = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('400529c8-31be-4749-acfe-7549baa2fcb2')))
        );        
        insert MxTestConnection1; 
        
        CSS_Integration_Details__c MxTestConnection2 = new CSS_Integration_Details__c(
            Name = 'MxAuthWarr',
            ApplicationName__c = 'MxAuthWarr',
            End_Point__c = 'https://api-ue-devnf-aw-ex.cummins.com/api/core-security-api/v1/auth/token',
            IsActive__c = True,
            Method_Type__c = 'POST',
            AuthEnv__c = '',
            Key__c =  EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('https://api-ue-devnf-aw-ex.cummins.com/cmi/warranty'))),
            Passcode__c = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('~6_5~e.~8D19I0Sw7YSNtq2kiAgK5bA.w3'))),
            Username__c = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('400529c8-31be-4749-acfe-7549baa2fcb2')))
        );        
        insert MxTestConnection2; 
        
        Test.StartTest();
        Test.setMock(HttpCalloutMock.class, new CSS_WS_WebServicesMock());
        Test.setCurrentPage(pageRef);
        System.currentPageReference().getParameters().put('id', claim.id);
        ApexPages.StandardController standardController = new ApexPages.StandardController(claim); 
        CSS_WS_ControllerClaim controller = new CSS_WS_ControllerClaim(standardController);
        controller.mapEngineApplication('AUTOMOTIVE');
        controller.getDistributorsSelectList();
        controller.getDealersSelectList();
        controller.getManufacturerSelectList();//Method getManufacturerSelectList        
        
        controller.getModelSeriesSelectList();//Method getModelSeriesSelectList
        claim.CSS_WS_Manufacturer__c = null; 
        controller.getModelSeriesSelectList();
        
        controller.getComplaintsSelectList();
        controller.getComplaintsRest1();
        controller.getComplaintsRest2();
        controller.getAccountCodesSelectList();
        controller.getPayCodeList();
        controller.reloadEngineApplication();
        controller.getEngineApplications();
        
        // test new functions for P101 claims - Jul10th2018
        controller.getDRtoChargeSelectList();
        claim.CSS_WS_Service_Provider_DR_ToCharge__c = '54734';
        controller.getDealersToChargeSelectList();
                
        claim.CSS_WS_Warranty_Start_Date__c = system.today();
        claim.CSS_WS_Customer_Name_Internal__c = CustomerTest.id; 
        claim.CSS_WS_Account_Code__c = 'P90';
        controller.getPolicyCampaignList();
        
        claim.CSS_WS_Service_Provider_DR__c = null;
        controller.getPolicyOptionsByDR();//When the Service_Provider_DR__c is null
        claim.CSS_WS_Service_Provider_DR__c = '54734';
        controller.getPolicyOptionsByDR();//When the Service_Provider_DR__c is from Mexico 
        claim.CSS_WS_Service_Provider_Dealer__c = '54734';
        controller.getPolicyOptionsByDROp();//When the Service_Provider_Dealer__c is Cummins MX
        DRTest.CSS_WS_Region_Name__c = 'USA';
        upsert DRtest;
        claim.CSS_WS_Service_Provider_Dealer__c = '54730';
        controller.getPolicyOptionsByDROp();//When the Service_Provider_DR__c is not from Mexico
        Test.StopTest();
    }
    
    Public Static testMethod Void testMethodsOthers(){
        PageReference pageRef = Page.CSS_WS_ClaimFormat;
        Test.setCurrentPage(pageRef);
        Account SPDLTest = new Account(
            IAM_Service_Provider_Code__c = '12345',
            CSS_DBCode__c = '54734',
            Type = 'Dealer Account',
            Name = 'DUMMY DEALER',
            CMI_Account_Status__c = 'Active',
            CSS_WS_Campaign_TRP__c = true,
            CSS_WS_Region_Code__c = 'USCA',
            BillingCountry = 'Mexico',
            CSS_WS_Claim_Allow_Days__c = 10,
            Warranty_Training_Certification__c = true,
            CSS_WS_Max_Claim_Amount__c = 9999);
        insert SPDLTest;
        
        String Fail = '01/11/2016 12:00 PM';
        String[] dat = Fail.split(' ');
        
        CSS_WS_Warranty__c claim = new CSS_WS_Warranty__c(
            CSS_WS_Service_Provider_DR__c = '54321',
            CSS_WS_Service_Provider_Dealer__c = '12345',
            CSS_WS_HasMessage__c = 'Test Message',
            CSS_WS_HasError__c = 1,
            CSS_WS_Failure_Date_Time__c = date.parse(dat[0]),
            CSS_WS_Failure_Point_Quantity__c = '0');
        insert claim;     
        
        ApexPages.StandardController standardController = new ApexPages.StandardController(claim); 
        CSS_WS_ControllerClaim controller = new CSS_WS_ControllerClaim(standardController);      
        Test.StartTest();//Method assignPayCode()
        controller.assignPayCode();//When Dr and Dealer are not the same
        Fail = '10/10/2016 12:00 PM';
        dat = Fail.split(' ');
        claim.CSS_WS_Failure_Date_Time__c = date.parse(dat[0]);
        controller.assignPayCode();
        Fail = '06/01/2016 12:00 PM';
        dat = Fail.split(' ');
        claim.CSS_WS_Failure_Date_Time__c = date.parse(dat[0]);
        controller.assignPayCode();
        Fail = '03/06/2016 12:00 PM';
        dat = Fail.split(' ');
        claim.CSS_WS_Failure_Date_Time__c = date.parse(dat[0]);
        controller.assignPayCode();
        Fail = '03/06/2015 12:00 PM';
        dat = Fail.split(' ');
        claim.CSS_WS_Failure_Date_Time__c = date.parse(dat[0]);
        controller.assignPayCode();       
        claim.CSS_WS_Service_Provider_Dealer__c = '54321';//When Dr and Dealer are the same      
        Fail = '10/10/2016 12:00 PM';
        dat = Fail.split(' ');
        claim.CSS_WS_Failure_Date_Time__c = date.parse(dat[0]);
        controller.assignPayCode();
        Fail = '07/07/2016 12:00 PM';
        dat = Fail.split(' ');
        claim.CSS_WS_Failure_Date_Time__c = date.parse(dat[0]);
        controller.assignPayCode();
        Fail = '06/01/2016 12:00 PM';
        dat = Fail.split(' ');
        claim.CSS_WS_Failure_Date_Time__c = date.parse(dat[0]);
        controller.assignPayCode();
        Fail = '03/06/2016 12:00 PM';
        dat = Fail.split(' ');
        claim.CSS_WS_Failure_Date_Time__c = date.parse(dat[0]);
        controller.assignPayCode();
        Fail = '03/06/2015 12:00 PM';
        dat = Fail.split(' ');
        claim.CSS_WS_Failure_Date_Time__c = date.parse(dat[0]);
        claim.CSS_WS_Account_Code__c = '35';
        controller.assignPayCode();        
        claim.CSS_WS_Account_Code__c = '52';
        controller.assignPayCode();        
        claim.CSS_WS_Warranty_Type__c = 'Parte';
        claim.CSS_WS_Claim_Type__c = 'Nuevo';
        controller.assignPayCode();
        claim.CSS_WS_Claim_Type__c = 'Recon';
        controller.assignPayCode();
        Fail = '07/07/2016 12:00 PM';
        dat = Fail.split(' ');
        claim.CSS_WS_Failure_Date_Time__c = dateTime.parse(Fail);
        claim.CSS_WS_Warranty_Start_Date__c = date.parse(dat[0]);
        claim.CSS_WS_Failure_Point_Quantity__c = '0';
        claim.CSS_WS_Claim_Type__c = 'Nuevo';
        controller.assignPayCode();
        claim.CSS_WS_Claim_Type__c = 'Recon';
        controller.assignPayCode();
        
        controller.clearTravelModeDetail();//Method clearTravelModeDetail()
        
        controller.alertCautionEnd();//Method alertCautionEnd()                     
                   
        Test.setMock(HttpCalloutMock.class, new CSS_WS_WebServicesMock());
        claim.CSS_WS_Engine_Serial_Number__c = '12345678'; 
        claim.CSS_WS_Warranty_Type__c = 'Motor';
        Fail = '06/01/2016 12:00 PM';
        dat = Fail.split(' ');
        claim.CSS_WS_Build_Date__c = date.parse(dat[0]);
        Fail = '05/01/2016 12:00 PM';
        dat = Fail.split(' ');
        claim.CSS_WS_Warranty_Start_Date__c = date.parse(dat[0]);
        controller.editWSDFlag = true;
        controller.changePolicyField();//Method changePolicyField()
        
        controller.clearSubTypeFailure();

        controller.checkTravelPercentage();
        claim.CSS_WS_Campaigns_TRPs__c = '19056';
        controller.checkTravelPercentage();
        
        Attachment attach = new Attachment();    
        attach.Name = 'Unit Test Attachment';
        Blob bodyBlob = Blob.valueOf('Unit Test Attachment Body');
        attach.body = bodyBlob;
        attach.parentId = claim.id;
        insert attach;
        controller.SelectedRowId = attach.id;
        controller.attachment_list.add(attach);
        controller.deleteAttachmentRow();
        Test.stopTest();
    }
    
    Public Static testMethod Void testMethodsSave_Header_HeaderDisabled_Policy(){
        Account SPDLTest = new Account(
            IAM_Service_Provider_Code__c = '12345',
            CSS_DBCode__c = '54734',
            Type = 'Dealer Account',
            Name = 'DUMMY DEALER',
            CMI_Account_Status__c = 'Active',
            CSS_WS_Campaign_TRP__c = true,
            CSS_WS_Region_Code__c = 'USCA',
            BillingCountry = 'Mexico',
            CSS_WS_Claim_Allow_Days__c = 10,
            Warranty_Training_Certification__c = true,
            CSS_WS_Max_Claim_Amount__c = 9999);
        insert SPDLTest;
        CSS_WS_Support_Engineer_Catalog__c Enginner = new CSS_WS_Support_Engineer_Catalog__c(
            CSS_WS_Engineer_Name__c =  'Tony',
            CSS_WS_DR_Code__c = '54321',
            Name = 'Tony');
        insert Enginner;
        
        PageReference pageRef = Page.CSS_WS_ClaimFormat;
        Test.setCurrentPage(pageRef);
        CSS_WS_Warranty__c claim = new CSS_WS_Warranty__c();    
        ApexPages.StandardController standardController = new ApexPages.StandardController (claim); 
        CSS_WS_ControllerClaim controller = new CSS_WS_ControllerClaim(standardController);      
        Test.StartTest();
        controller.continueSubmission();//The method saveHeader calls this method
        controller.savePolicy();//Try catch to the methods

        claim = new CSS_WS_Warranty__c(
            CSS_WS_Service_Provider_DR__c = '54734',
            CSS_WS_Service_Provider_Dealer__c = '12345',
            CSS_WS_HasMessage__c = 'Test Message',
            CSS_WS_HasError__c = 1);
        upsert claim;
        CSS_WS_Rescue__c RescueWar = new CSS_WS_Rescue__c(
            CSS_WS_Engine_Serial_Number__c = claim.CSS_WS_Engine_Serial_Number__c,
            CSS_WS_Service_Provider_Dealer__c = claim.CSS_WS_Service_Provider_Dealer__c,
            CSS_WS_TravelHoursRoundTripPolicy__c = 25,
            CSS_WS_TravelKmRoundTripPolicy__c = 10000,
            CSS_WS_Lodging_Amount__c = 10000);  
        insert RescueWar; 
        CSS_WS_Failure__c FailData = new CSS_WS_Failure__c(
            CSS_WS_EngineSystemCode__c = 'CH',
            CSS_WS_ComponentCode__c = 'CA',
            CSS_WS_FailureModeCode__c = 'SA',
            CSS_WS_Warranty__c = claim.id);
        insert FailData;
        
        standardController = new ApexPages.StandardController(claim); 
        controller = new CSS_WS_ControllerClaim(standardController);  
        controller.saveHeader();//HasError to the method saveHeader
        claim.CSS_WS_HasError__c = 2;
        controller.saveHeader();
        claim.CSS_WS_HasError__c = 4;
        controller.saveHeader();
        claim.CSS_WS_HasError__c = 0;
        
        Test.setMock(HttpCalloutMock.class, new CSS_WS_WebServicesMock());
        
        SPDLTest.CSS_WS_Warranty_Train_Cert__c = False;//Method saveHeader()
        upsert SPDLTest;
        controller.saveHeader();
        SPDLTest.CSS_WS_Warranty_Train_Cert__c = True;
        upsert SPDLTest;
        
        controller.saveHeaderDisabled();//Method saveHeaderDisabled()
        claim.CSS_WS_Policy_Flag__c = 'Policy';
        claim.CSS_WS_Account_Code__c = 'P88';       
        controller.saveHeaderDisabled();//Else of Method saveHeaderDisabled()
        
        controller.savePolicy();//Method savePolicy()
        claim.CSS_WS_Warranty_Subtype__c = 'No BIS';
        claim.CSS_WS_Engine_Serial_Number__c = '73279794';
        claim.CSS_WS_Engine_Family_Code__c = '080XL';
        claim.CSS_WS_Failure_Measure__c = 'KM';
        claim.CSS_WS_Failure_Point_Quantity__c = '10';
        claim.CSS_WS_Multi_ESN__c = false;
        claim.CSS_WS_Product_Application_Code__c = '12';
        claim.CSS_WS_Repair_Work_Order_Number__c = '151931';
        claim.CSS_WS_Service_Model__c = 'ISC8.3 CM2250';
        claim.CSS_WS_Account_Code__c = '67';
        claim.CSS_WS_Engine_Application_Code__c = '001'; 
        claim.CSS_WS_Customer_Name__c = 'Castores';
        claim.CSS_WS_Manufacturer__c = 'Kenworth';
        claim.CSS_WS_Model_Series__c = '999-99';
        claim.CSS_WS_Complaints1__c = '5000';
        claim.CSS_Authorization_Number__c = '9001';
        claim.CSS_WS_Catastrophic__c = 'No';
        claim.CSS_WS_Replacement_Part__c = 'Block';        
        claim.CSS_WS_Repair_Description__c = 'Test example';
        claim.CSS_WS_Quotation_Total_Amount__c = 1;
        claim.CSS_WS_Requested_Amount__c = 1;
        claim.CSS_WS_Authorized_Amount__c = 1;
        claim.CSS_WS_Product_Application_Description__c = 'General';
        claim.CSS_WS_Pay_Code__c = '90';       
        String Fail = '05/05/2010 12:00 PM';
        String[] dat = Fail.split(' ');
        claim.CSS_WS_Build_Date__c = date.parse(dat[0]);       
        Fail = '06/06/2010 12:00 PM';
        dat = Fail.split(' ');
        claim.CSS_WS_Warranty_Start_Date__c = date.parse(dat[0]);        
        Fail = '07/07/2010 12:00 PM';
        dat = Fail.split(' ');
        claim.CSS_WS_Engine_Trade_Out_conversion_date__c = date.parse(dat[0]);        
        Fail = '01/01/2015 12:00 PM';
        dat = Fail.split(' ');
        claim.CSS_WS_Failure_Date_Time__c = date.parse(dat[0]);        
        Fail = '03/01/2015 12:00 PM';
        dat = Fail.split(' ');
        claim.CSS_WS_Customer_Support_authorization_da__c = date.parse(dat[0]);      
        controller.LogInVariable = 'DRLoggedIn';//All the dates with DRLoggedIn
        controller.savePolicy();
        Fail = '06/01/2015 12:00 PM';
        dat = Fail.split(' ');
        claim.CSS_WS_Customer_Support_authorization_da__c = date.parse(dat[0]);
        controller.savePolicy();
        Fail = '10/01/2015 12:00 PM';
        dat = Fail.split(' ');
        claim.CSS_WS_Customer_Support_authorization_da__c = date.parse(dat[0]);
        controller.savePolicy();
        Fail = '01/01/2016 12:00 PM';
        dat = Fail.split(' ');
        claim.CSS_WS_Customer_Support_authorization_da__c = date.parse(dat[0]);
        controller.savePolicy();        
        controller.LogInVariable = 'DealerLoggedIn';//All the dates with DealerLoggedIn
        Fail = '03/01/2015 12:00 PM';
        dat = Fail.split(' ');
        claim.CSS_WS_Customer_Support_authorization_da__c = date.parse(dat[0]);
        controller.savePolicy();
        Fail = '06/01/2015 12:00 PM';
        dat = Fail.split(' ');
        claim.CSS_WS_Customer_Support_authorization_da__c = date.parse(dat[0]);
        controller.savePolicy();
        Fail = '10/01/2015 12:00 PM';
        dat = Fail.split(' ');
        claim.CSS_WS_Customer_Support_authorization_da__c = date.parse(dat[0]);
        controller.savePolicy();
        Fail = '01/01/2016 12:00 PM';
        dat = Fail.split(' ');
        claim.CSS_WS_Customer_Support_authorization_da__c = date.parse(dat[0]);
        controller.savePolicy();
        test.stopTest();
    }
    
    Public Static testMethod Void testMethodsSave_Failure_MultiESN_Narrative(){
        CSS_WS_Warranty__c claim = new CSS_WS_Warranty__c();    
        ApexPages.StandardController standardController = new ApexPages.StandardController (claim); 
        CSS_WS_ControllerClaim controller = new CSS_WS_ControllerClaim(standardController);      
        Test.StartTest();
        controller.saveFailure();//Try catch to the methods
        controller.saveMultiESN();
        controller.saveNarrative();
        
        Account SPDLTest = new Account(
            IAM_Service_Provider_Code__c = '54321',
            CSS_DBCode__c = '54734',
            Type = 'Dealer Account',
            Name = 'DUMMY DEALER',
            CMI_Account_Status__c = 'Active',
            CSS_WS_Campaign_TRP__c = true,
            CSS_WS_Region_Code__c = 'USCA',
            BillingCountry = 'Mexico',
            CSS_WS_Claim_Allow_Days__c = 10,
            Warranty_Training_Certification__c = true,
            CSS_WS_Max_Claim_Amount__c = 9999);
        insert SPDLTest;
        claim = new CSS_WS_Warranty__c(
            CSS_WS_Service_Provider_DR__c = '54734',
            CSS_WS_Service_Provider_Dealer__c = '54321',
            CSS_WS_HasMessage__c = 'Test Message',
            CSS_WS_HasError__c = 1,
            CSS_WS_Warranty_Start_date__c = system.today());
        upsert claim;
        
        standardController = new ApexPages.StandardController(claim); 
        controller = new CSS_WS_ControllerClaim(standardController);  
        controller.saveFailure();//Error in the methods
        controller.saveMultiESN();
        controller.saveNarrative();
        
        CSS_WS_Failure__c FailData = new CSS_WS_Failure__c(
            CSS_WS_EngineSystemCode__c = 'CH',
            CSS_WS_ComponentCode__c = 'CA',
            CSS_WS_FailureModeCode__c = 'SA',
            CSS_WS_Warranty__c = claim.id);
        insert FailData;
        
        controller.saveFailure();//Method saveFailure()        
        String Fail = '9/10/2016 5:04 PM';
        String[] dat = Fail.split(' ');
        claim.CSS_WS_Warranty_Subtype__c = 'No BIS';
        claim.CSS_WS_Engine_Serial_Number__c = '73279794';
        claim.CSS_WS_Engine_Family_Code__c = '080XL';
        claim.CSS_WS_Failure_Measure__c = 'KM';
        claim.CSS_WS_Failure_Point_Quantity__c = '10';
        claim.CSS_WS_Multi_ESN__c = false;
        claim.CSS_WS_Product_Application_Code__c = '12';
        claim.CSS_WS_Repair_Work_Order_Number__c = '151931';
        claim.CSS_WS_Service_Model__c = 'ISC8.3 CM2250';
        claim.CSS_WS_Account_Code__c = '67';
        claim.CSS_WS_Engine_Application_Code__c = '001'; 
        claim.CSS_WS_Customer_Name__c = 'Castores';
        claim.CSS_WS_Manufacturer__c = 'Kenworth';
        claim.CSS_WS_Model_Series__c = '999-99';
        claim.CSS_WS_Complaints1__c = '5000';
        claim.CSS_Authorization_Number__c = '9001';
        claim.CSS_WS_Catastrophic__c = 'No';
        claim.CSS_WS_Replacement_Part__c = 'Block';        
        claim.CSS_WS_Repair_Description__c = 'Test example';
        claim.CSS_WS_Quotation_Total_Amount__c = 1;
        claim.CSS_WS_Requested_Amount__c = 1;
        claim.CSS_WS_Authorized_Amount__c = 1;
        claim.CSS_WS_Product_Application_Description__c = 'General';
        claim.CSS_WS_Pay_Code__c = '90';       
        Fail = '05/06/2010 12:00 PM';
        dat = Fail.split(' ');
        claim.CSS_WS_Build_Date__c = date.parse(dat[0]);       
        Fail = '06/06/2010 12:00 PM';
        dat = Fail.split(' ');
        claim.CSS_WS_Warranty_Start_Date__c = date.parse(dat[0]);        
        Fail = '07/06/2010 12:00 PM';
        dat = Fail.split(' ');
        claim.CSS_WS_Engine_Trade_Out_conversion_date__c = date.parse(dat[0]);        
        Fail = '01/01/2015 12:00 PM';
        dat = Fail.split(' ');
        claim.CSS_WS_Failure_Date_Time__c = date.parse(dat[0]);        
        Fail = '03/01/2015 12:00 PM';
        dat = Fail.split(' ');
        claim.CSS_WS_Customer_Support_authorization_da__c = date.parse(dat[0]);
        claim.CSS_WS_HasError__c = 0;
        claim.CSS_WS_Policy_Flag__c = 'Policy WW';
        claim.CSS_WS_Engine_Serial_Number__c = '12345678';
        claim.CSS_WS_In_shop_Labor_Rate__c = '12';
        upsert claim;
        controller.saveFailure();  
        claim.Other_Approver_Picklist_WW__c = '176 - NORTHRUP, DARREL';
        controller.saveFailure();
        claim.CSS_WS_HasError__c = 1;
        controller.saveFailure();
        claim.CSS_WS_HasError__c = 0;
        claim.CSS_WS_Multi_ESN__c = True;
        controller.saveFailure();
        CSS_WS_Rescue__c RescueWar = new CSS_WS_Rescue__c(
            CSS_WS_Engine_Serial_Number__c = claim.CSS_WS_Engine_Serial_Number__c,
            CSS_WS_Service_Provider_Dealer__c = '54321',
            CSS_WS_TravelHoursRoundTripPolicy__c = 25,
            CSS_WS_TravelKmRoundTripPolicy__c = 10000,
            CSS_WS_Lodging_Amount__c = 10000,
            CSS_WS_RescueStatus__c = 'Authorized by Planta',
            CSS_WS_SignalBy__c = 'Warranty',
            CSS_WS_ServiceRequest__c = system.today(),
            CSS_WS_Warranty_Relationship__c = null);
        insert RescueWar; 
        SPDLTest = new Account(
            IAM_Service_Provider_Code__c = '54734',
            CSS_DBCode__c = '54734',
            Type = 'Dealer Account',
            Name = 'DUMMY DEALER',
            CMI_Account_Status__c = 'Active',
            CSS_WS_Campaign_TRP__c = true,
            CSS_WS_Region_Code__c = 'USCA',
            BillingCountry = 'Mexico',
            CSS_WS_Claim_Allow_Days__c = 10,
            Warranty_Training_Certification__c = true,
            CSS_WS_Max_Claim_Amount__c = 9999);
        insert SPDLTest;
        claim.CSS_WS_Policy_Flag__c = 'Warranty';
        claim.CSS_WS_RescueNumber__c = RescueWar.Name;
        claim.CSS_WS_Campaigns_TRPs__c = '123456';
        claim.CSS_WS_Campaign_Travel_Percentage__c = 100;
        claim.CSS_WS_Service_Provider_DR__c = '54734';
        claim.CSS_WS_Service_Provider_Dealer__c = '54734';
        upsert claim;
        controller.saveFailure();  
        
        controller.saveMultiESN();//Method saveMultiESN()
        
        controller.saveNarrative();//Method saveNarrative()
        controller.flagSRT = true;
        controller.saveNarrative();
        Test.stopTest();
    }
    
    Public Static testMethod Void testMethodsSave_SRT_Parts_Travel(){
        Account SPDLTest = new Account(
            IAM_Service_Provider_Code__c = '12345',
            CSS_DBCode__c = '54734',
            Type = 'Dealer Account',
            Name = 'DUMMY DEALER',
            CMI_Account_Status__c = 'Active',
            CSS_WS_Campaign_TRP__c = true,
            CSS_WS_Region_Code__c = 'USCA',
            BillingCountry = 'Mexico',
            CSS_WS_Territory_Code__c = 1,
            CSS_WS_Channel_Code__c = '1',
            CSS_WS_Claim_Allow_Days__c = 10,
            Warranty_Training_Certification__c = true,
            CSS_WS_Max_Claim_Amount__c = 9999);
        insert SPDLTest;
        
        CSS_WS_Warranty__c claim = new CSS_WS_Warranty__c();    
        ApexPages.StandardController standardController = new ApexPages.StandardController (claim); 
        CSS_WS_ControllerClaim controller = new CSS_WS_ControllerClaim(standardController);  
        controller.saveTravel();
        Test.StartTest();
        controller.saveSRT();//Try catch to the methods
        controller.saveParts();
        
        claim = new CSS_WS_Warranty__c(
            CSS_WS_Service_Provider_DR__c = '54734',
            CSS_WS_Service_Provider_Dealer__c = '12345',
            CSS_WS_HasMessage__c = 'Test Message',
            CSS_WS_HasError__c = 1,
            CSS_WS_Warranty_Start_Date__c = system.today());
        upsert claim;
        
        standardController = new ApexPages.StandardController(claim); 
        controller = new CSS_WS_ControllerClaim(standardController);  
        controller.saveSRT();//HasError to the methods
        controller.saveParts();
        
        claim.CSS_WS_HasError__c = 0;
        controller.saveSRT();//Method saveSRT() 
        claim.CSS_WS_Total_Amount_SRT__c = 10000;
        upsert claim;
        controller.saveSRT();
        
        controller.saveParts();//Method saveParts() 
        claim.CSS_WS_Total_Amount_SRT__c = 10;
        upsert claim;
        controller.showTravel = true;
        controller.saveParts();    
        controller.showTravel = false;
        controller.saveParts();
        claim.CSS_WS_Total_Amount_SRT__c = 10000;
        upsert claim;
        controller.saveParts();
        
        CSS_WS_Failure__c Failures = new CSS_WS_Failure__c( 
            CSS_WS_ComponentCode__c = '12',
            CSS_WS_EngineSystemCode__c = '13',
            CSS_WS_FailureModeName__c = '14',
            CSS_WS_FailureModeCode__c = '15',
            CSS_WS_Warranty__c = claim.Id);
        insert Failures;
        SPDLTest.CSS_WS_Territory_Name__c = 'Mexico';
        update SPDLTest;
        
        claim.CSS_WS_Pay_Code__c = 'R'; 
        claim.CSS_WS_Product_Application_Code__c = 'CH'; 
        claim.CSS_WS_Product_Application_Description__c = 'TestDescription'; 
        claim.CSS_WS_Marine_Application_Flag__c = ''; 
        claim.CSS_WS_Build_Date__c = system.today(); 
        claim.CSS_WS_Engine_Trade_Out_conversion_date__c = system.today(); 
        claim.CSS_WS_Approval_Code__c = 'AC'; 
        claim.CSS_WS_Account_Code_Type__c = 'AT'; 
        claim.CSS_WS_Towing_Amount__c = 10; 
        claim.CSS_WS_Covered_Travel_Labor__c = 20; 
        claim.CSS_WS_Covered_Travel_Miles__c = 20; 
        claim.CSS_WS_Covered_Meals_Lodging__c = 20; 
        claim.CSS_WS_Covered_Towing_Miles__c = 20; 
        claim.CSS_WS_Total_Amount_SRT_Hours__c = 20; 
        claim.CSS_WS_Policy_Flag__c = 'Warranty'; 
        claim.CSS_WS_Lodging__c = 1;
        claim.CSS_WS_Warranty_Subtype__c = 'No BIS';
        claim.CSS_WS_Engine_Serial_Number__c = '12345678';
        claim.CSS_WS_Engine_Family_Code__c = 'EF';
        claim.CSS_WS_Failure_Date_Time__c = system.today();
        claim.CSS_WS_Failure_Measure__c = 'KM';
        claim.CSS_WS_Failure_Point_Quantity__c = '12000';
        claim.CSS_WS_Multi_ESN__c = true;
        claim.CSS_WS_Repair_Work_Order_Number__c = 'RWON';
        claim.CSS_WS_Service_Model__c = 'SM';
        claim.CSS_WS_Warranty_Start_Date__c = system.today();
        claim.CSS_WS_Engine_Family_Code__c = '';
        claim.CSS_WS_Claim_Type__c = ''; 
        claim.CSS_WS_Engine_Application_Code__c = 'EA';
        upsert claim;
        
        controller.saveTravel();//Method saveTravel() 
        claim.CSS_WS_Travel_Hours__c = 10;
        claim.CSS_WS_Travel_Distance__c = 9;
        claim.CSS_WS_Total_Amount_SRT__c = 10;        
        upsert claim;
        controller.saveTravel(); 
        SPDLTest.CSS_WS_Region_Name__c = 'USA';
        upsert SPDLTest;
        controller.saveTravel();
        claim.CSS_WS_Travel_Hours__c = 8;
        controller.saveTravel();
        claim.CSS_WS_Towing_Amount__c = -1;
        controller.saveTravel();
        claim.CSS_WS_Towing_Amount__c = 0;
        claim.CSS_WS_HasError__c = 1;
        controller.saveTravel();
        claim.CSS_WS_HasError__c = 0;
        controller.saveTravel();
        SPDLTest.CSS_WS_Territory_Name__c = 'USA';
        SPDLTest.BillingCountry = 'Panama';
        upsert SPDLTest;
        
        CSS_WS_Travel_Prices__c TravelPricesHr = new CSS_WS_Travel_Prices__c(
            Local_Rate__c = 12,
            Name = 'HR_Adicional_Panama');
        insert TravelPricesHr;
        CSS_WS_Travel_Prices__c TravelPricesKm = new CSS_WS_Travel_Prices__c(
            Local_Rate__c = 12,
            Name = 'KM_Adicional_Panama');
        insert TravelPricesKm;
        
        controller.calculateTotalTravelAmount();//Try of the method calculateTotalTravelAmount()
        controller.saveTravel();
        claim.CSS_WS_Policy_Flag__c = 'Policy'; 
        upsert claim;
        controller.saveTravel();
        Test.stopTest();
    }
    
    Public Static testMethod Void testMethodsSave_Claimable_DLRDetails(){
        Account SPDLTest = new Account(
            IAM_Service_Provider_Code__c = '54734',
            CSS_DBCode__c = '54734',
            Type = 'Dealer Account',
            Name = 'DUMMY DEALER',
            CMI_Account_Status__c = 'Active',
            CSS_WS_Campaign_TRP__c = true,
            CSS_WS_Region_Code__c = 'USCA',
            BillingCountry = 'Mexico',
            CSS_WS_Claim_Allow_Days__c = 10,
            Warranty_Training_Certification__c = true,
            CSS_WS_Max_Claim_Amount__c = 9999);
        insert SPDLTest;
        
        CSS_WS_Warranty__c claim = new CSS_WS_Warranty__c(
            CSS_WS_DLR_Payment_Date__c = system.today(),
            CSS_WS_DLR_Credit_Number__c = '3001',
            CSS_WS_Total_Amount_Part__c = 50,
            CSS_WS_Warranty_Start_Date__c = System.today(),
            CSS_WS_Service_Provider_DR__c = '54321',
            CSS_WS_Service_Provider_Dealer__c = '54321'
        );
        insert claim;
        ApexPages.StandardController standardController = new ApexPages.StandardController (claim); 
        CSS_WS_ControllerClaim controller = new CSS_WS_ControllerClaim(standardController);      
        Test.StartTest();
        
        controller.saveClaimable();//Try catch to the methods
        controller.saveDLRDetails();
        
        claim = new CSS_WS_Warranty__c(
            CSS_WS_Service_Provider_DR__c = '54321',
            CSS_WS_Service_Provider_Dealer__c = '54321',
            CSS_WS_HasMessage__c = 'Test Message',
            CSS_WS_HasError__c = 1);
        upsert claim;
        
        standardController = new ApexPages.StandardController(claim); 
        controller = new CSS_WS_ControllerClaim(standardController);  
        controller.saveClaimable();//HasError to the saveClaimable
        
        claim.CSS_WS_HasError__c = 0;
        claim.CSS_WS_Warranty_Start_Date__c = system.today();
        controller.saveClaimable();//Method saveClaimable
        claim.CSS_WS_Total_Amount_SRT__c = 100000;
        upsert claim;
        controller.saveClaimable();
        claim.CSS_WS_Total_Amount_SRT__c = 10;
        upsert claim;
        claim.CSS_WS_HasError__c = 4;
        controller.saveClaimable();
        claim.CSS_WS_HasError__c = 0;
        claim.CSS_WS_Policy_Flag__c = 'Policy WW';
        controller.saveClaimable();
        
        controller.saveDLRDetails();//Method saveDLRDetails
        claim.CSS_WS_DLR_Payment_Date__c = system.today();
        controller.saveDLRDetails();
        claim.CSS_WS_DLR_Credit_Number__c = '3001';
        controller.saveDLRDetails();
        Test.stopTest();
    }
    
    Public Static testMethod Void testMethodsvalidatePreSubmitODM(){
        PageReference pageRef = Page.CSS_WS_ClaimFormat;        
        Account SPDLTest = new Account(
            IAM_Service_Provider_Code__c = '12345',
            CSS_DBCode__c = '54734',
            Type = 'Dealer Account',
            Name = 'DUMMY DEALER',
            CMI_Account_Status__c = 'Active',
            BillingCountry = 'Mexico',
            CSS_WS_Campaign_TRP__c = False);
        insert SPDLTest;
        CSS_WS_Warranty__c claim = new CSS_WS_Warranty__c(
            CSS_WS_Pay_Code__c = '01', 
            CSS_WS_Warranty_Subtype__c = 'BIS', 
            CSS_WS_Product_Application_Code__c = '12', 
            CSS_WS_Product_Application_Description__c = 'test',
            CSS_WS_Marine_Application_Flag__c = 'Y', 
            CSS_WS_Claim_Type__c = 'Nuevo', 
            CSS_WS_Multi_ESN__c = false, 
            CSS_WS_Build_Date__c = system.today(), 
            CSS_WS_Engine_Trade_Out_conversion_date__c = system.today(), 
            CSS_WS_Approval_Code__c = '12',
            CSS_WS_Account_Code_Type__c = 'Master', 
            CSS_WS_Towing_Amount__c = 1,
            CSS_WS_Total_Amount_SRT__c = 10,
            CSS_WS_Service_Provider_DR__c = SPDLTest.CSS_DBCode__c,
            CSS_WS_Service_Provider_Dealer__c = SPDLTest.IAM_Service_Provider_Code__c,
            CSS_WS_Total_Amount_Travel__c = 10);
        insert claim;
        CSS_WS_Failure__c Failures = new CSS_WS_Failure__c( 
            CSS_WS_ComponentCode__c = '12',
            CSS_WS_EngineSystemCode__c = '13',
            CSS_WS_FailureModeName__c = '14',
            CSS_WS_FailureModeCode__c = '15',
            CSS_WS_Warranty__c = claim.Id);
        insert Failures;
        CSS_WS_Warranty_Parts__c Parts = new CSS_WS_Warranty_Parts__c(                                                               
            CSS_WS_PartNumber__c = '12',
            CSS_WS_Unit_Part_Price__c = 13,                                                
            CSS_WS_WarrantyID__c = claim.Id);
        insert Parts;
        CSS_WS_Other_Claimable__c Claimables = new CSS_WS_Other_Claimable__c( 
            Name = 'Hello',                                                                       
            CSS_WS_Claimed_Reason__c = '12',
            CSS_WS_Description__c = '13',
            CSS_WS_Claimable__c = '14',
            CSS_WS_Requested_Amount__c = 15,                                               
            CSS_WS_Warranty__c = claim.Id);
        insert Claimables;
        CSS_WS_Warranty_SRT__c SRTs = new CSS_WS_Warranty_SRT__c( 
            CSS_WS_Access_Code__c = '12',
            CSS_WS_Description__c = '13',
            CSS_WS_Hours__c = 14,
            CSS_WS_Offsite__c = false,
            CSS_WS_Quantity__c = 16,
            CSS_WS_SRT__c = '00-900-00',
            CSS_WS_WarrantyID__c = claim.Id);
        insert SRTs;
        Blob key = Blob.valueOf('12345678901234567890123456789012');
        CSS_Integration_Details__c MxTestConnection1 = new CSS_Integration_Details__c(
            Name = 'MxPreSub',
            ApplicationName__c = 'MxPreSub',
            End_Point__c = 'https://api-ue-devnf-aw-ex.cummins.com/api/core-security-api/v1/auth/token/MxPreSub',
            IsActive__c = True,
            Method_Type__c = 'POST',
            AuthEnv__c = 'MxAuthClai',
            Key__c =  EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('https://api-ue-devnf-aw-ex.cummins.com/cmi-engine'))),
            Passcode__c = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('~6_5~e.~8D19I0Sw7YSNtq2kiAgK5bA.w3'))),
            Username__c = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('400529c8-31be-4749-acfe-7549baa2fcb2')))
        );        
        insert MxTestConnection1; 
        CSS_Integration_Details__c MxTestConnection2 = new CSS_Integration_Details__c(
            Name = 'MxAuthWarr',
            ApplicationName__c = 'MxAuthWarr',
            End_Point__c = 'https://api-ue-devnf-aw-ex.cummins.com/api/core-security-api/v1/auth/token',
            IsActive__c = True,
            Method_Type__c = 'POST',
            AuthEnv__c = '',
            Key__c =  EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('https://api-ue-devnf-aw-ex.cummins.com/cmi/warranty'))),
            Passcode__c = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('~6_5~e.~8D19I0Sw7YSNtq2kiAgK5bA.w3'))),
            Username__c = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('400529c8-31be-4749-acfe-7549baa2fcb2')))
        );        
        insert MxTestConnection2; 
        
        Test.setCurrentPage(pageRef);
        ApexPages.StandardController standardController = new ApexPages.StandardController(claim); 
        CSS_WS_ControllerClaim controller = new CSS_WS_ControllerClaim(standardController); 
        Test.startTest();
        controller.validatePreSubmitODM();
        Test.setMock(HttpCalloutMock.class, new CSS_WS_WebServicesMock());
        controller.validatePreSubmitODM();
        Test.stopTest();
    }
    
    Public Static testMethod Void testMethodsValidationRules(){
        PageReference pageRef = Page.CSS_WS_ClaimFormat;
        Account SPDLTest = new Account(
            IAM_Service_Provider_Code__c = '12345',
            CSS_DBCode__c = '54734',
            Type = 'Dealer Account',
            Name = 'DUMMY DEALER',
            CMI_Account_Status__c = 'Active',
            BillingCountry = 'Mexico',
            CSS_WS_Campaign_TRP__c = False);
        insert SPDLTest;
        CSS_WS_Warranty__c claim = new CSS_WS_Warranty__c(
            CSS_WS_Warranty_Type__c = 'Motor',
            CSS_WS_Warranty_Subtype__c = 'No BIS',
            CSS_WS_Warranty_Start_Date__c = System.today(),
            CSS_WS_Failure_Date_Time__c = System.today());  
        insert claim;
        Test.setCurrentPage(pageRef);
        ApexPages.StandardController standardController = new ApexPages.StandardController(claim); 
        CSS_WS_ControllerClaim controller = new CSS_WS_ControllerClaim(standardController); 
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new CSS_WS_WebServicesMock());  
        claim.CSS_WS_Warranty_Subtype__c = 'BIS';
        controller.R04165_SF44();//Rule SF44 and Else of warrantyChanges method
        claim.CSS_WS_Warranty_Type__c = 'Parte';
        controller.R04165_SF44();//When is part
        claim.CSS_WS_Warranty_Subtype__c = 'BIS';
        claim.CSS_WS_Warranty_Start_Date__c = null;
        controller.R04165_SF44();//Else Rule SF44 and warrantyChanges method
        
        
        String Fail = '9/11/2017 5:04 PM';
        String[] dat = Fail.split(' ');
        claim.CSS_WS_Failure_Date_Time__c = date.parse(dat[0]);
        controller.R040611_SF16();//Rule SF16, Failure Date cannot be greater than today       
        Fail = '9/11/2015 5:04 PM';
        dat = Fail.split(' ');
        claim.CSS_WS_Failure_Date_Time__c = date.parse(dat[0]);
        controller.R040611_SF16();//Else Rule SF16, Please ensure the Failure Date and Time are set correctly
        Fail = '9/11/2016 5:04 PM';
        dat = Fail.split(' ');
        claim.CSS_WS_Warranty_Start_Date__c = date.parse(dat[0]);
        controller.R040611_SF16();//Else Rule SF16, Failure Date should be greater than Warranty Start Date
        Fail = '9/11/2015 5:04 PM';
        dat = Fail.split(' ');
        claim.CSS_WS_Failure_Date_Time__c = date.parse(dat[0]);
        Fail = '9/11/2014 5:04 PM';
        dat = Fail.split(' ');
        claim.CSS_WS_Warranty_Start_Date__c = date.parse(dat[0]);
        controller.R040611_SF16();//Please ensure the Failure Date and Time are set correctly
        
        claim.CSS_WS_Failure_Point_Quantity__c = '-1';
        controller.R04067_SF17();//Failure Point cannot be less than zero
        claim.CSS_WS_Failure_Point_Quantity__c = '999999999';
        claim.CSS_WS_Failure_Measure__c = 'KM';
        claim.CSS_WS_Account_Code__c = '41';
        claim.CSS_WS_Policy_Flag__c = 'Warranty';
        controller.R04067_SF17();
        claim.CSS_WS_Failure_Measure__c = '';
        controller.R04067_SF17();//Call method R04023_SF50
        
        controller.R04190_SF36();//Else of Rule SF36
        Fail = '9/11/2020 5:04 PM';
        dat = Fail.split(' ');
        claim.CSS_WS_Warranty_Start_Date__c = date.parse(dat[0]);
        controller.R04190_SF36();//Rule SF36
        
        claim.CSS_WS_Engine_Serial_Number__c = '12345678';
        claim.CSS_WS_Service_Model__c = 'CLX-901';
        claim.CSS_WS_Multi_ESN__c = true;
        claim.CSS_WS_ESN_Count__c = '2';
        controller.R04328_SF48();//Engine Serial # has a different Service Model than that of Additional ESN. Please remove Additional ESN before changing this value
        
        claim.CSS_WS_Lodging__c = -1;
        claim.CSS_WS_Towing_Amount__c = -1;
        claim.CSS_WS_Travel_Hours__c = -1;
        claim.CSS_WS_Travel_Distance__c = -1;
        claim.CSS_WS_Service_Provider_DR__c = SPDLTest.CSS_DBCode__c;
        claim.CSS_WS_Service_Provider_Dealer__c = SPDLTest.IAM_Service_Provider_Code__c;
        controller.R040813_SF22();//Rule SF22
        controller.R040814_SF23();//Rule SF23
        controller.R040815_SF24();//Rule SF24
        controller.R040816_SF25();//Rule SF25
        claim.CSS_WS_Travel_Distance__c = 1;
        controller.R04133_SF72();//Rule SF72
        
        Fail = '9/11/2014 5:04 PM';
        dat = Fail.split(' ');
        claim.CSS_WS_Customer_Support_authorization_da__c = date.parse(dat[0]);
        Fail = '9/11/2015 5:04 PM';
        dat = Fail.split(' ');
        claim.CSS_WS_Failure_Date_Time__c = date.parse(dat[0]);
        controller.SF_P05();//Rule SF-P05
        
        claim.CSS_WS_Requested_Amount__c = 2;
        claim.CSS_WS_Quotation_Total_Amount__c = 1;
        //controller.SF_P07();//Rule SF-P07
        claim.CSS_WS_Authorized_Amount__c = 2;
        claim.CSS_WS_Requested_Amount__c = 1;
        controller.SF_P08();//Rule SF-P08
        
        //Method warrantyChanges          
        claim.CSS_WS_Warranty_Subtype__c = 'BIS';
        claim.CSS_WS_Warranty_Type__c = 'Motor';
        controller.warrantyChanges(); 
        claim.CSS_WS_Warranty_Subtype__c = 'No BIS';
        controller.editWSDFlag = false;
        controller.warrantyChanges(); 
        claim.CSS_WS_Warranty_Type__c = 'Parte';
        controller.warrantyChanges();
        
        //Method sendApprovalCode
        controller.sendApprovalCode();
        claim.CSS_WS_Account_Code__c = '35';
        controller.sendApprovalCode();
        claim.CSS_WS_Account_Code__c = '52';
        controller.sendApprovalCode();
        Test.stopTest();
    }
    
    Public Static testMethod Void testMethodsValidation(){
        PageReference pageRef = Page.CSS_WS_ClaimFormat;
        CSS_WS_Warranty__c claim = new CSS_WS_Warranty__c();  
        Test.setCurrentPage(pageRef);
        Test.setMock(HttpCalloutMock.class, new CSS_WS_WebServicesMock()); 
        Account SPDLTest = new Account(
            IAM_Service_Provider_Code__c = '12345',
            CSS_DBCode__c = '54734',
            Type = 'Dealer Account',
            Name = 'DUMMY DEALER',
            CMI_Account_Status__c = 'Active',
            BillingCountry = 'Mexico',
            CSS_WS_Campaign_TRP__c = False);
        
        insert SPDLTest;    
        insert claim;
        
        Blob key = Blob.valueOf('12345678901234567890123456789012');
        CSS_Integration_Details__c MxTestConnection1 = new CSS_Integration_Details__c(
            Name = 'MxHeadVal',
            ApplicationName__c = 'MxHeadVal',
            End_Point__c = 'https://api-ue-devnf-aw-ex.cummins.com/api/core-security-api/v1/auth/token/MxHeadVal',
            IsActive__c = True,
            Method_Type__c = 'POST',
            AuthEnv__c = 'MxAuthClai',
            Key__c =  EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('https://api-ue-devnf-aw-ex.cummins.com/cmi-engine'))),
            Passcode__c = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('~6_5~e.~8D19I0Sw7YSNtq2kiAgK5bA.w3'))),
            Username__c = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('400529c8-31be-4749-acfe-7549baa2fcb2')))
        );        
        insert MxTestConnection1; 
        
        ApexPages.StandardController standardController = new ApexPages.StandardController(claim); 
        CSS_WS_ControllerClaim controller = new CSS_WS_ControllerClaim(standardController);     
        test.startTest();
        //validateHeaderFields method
        controller.validateHeaderFields();//Validate DR should be selected
        claim.CSS_WS_Policy_Flag__c = 'Warranty';
        claim.CSS_WS_Service_Provider_DR__c = '54321';
        controller.validateHeaderFields();//Validate Dealer should be selected
        claim.CSS_WS_Service_Provider_Dealer__c = '12345';
        controller.validateHeaderFields();//Validate ESN should not be NULL
        claim.CSS_WS_Engine_Serial_Number__c = '12345678';
        claim.CSS_WS_Warranty_Type__c = null;
        claim.CSS_WS_Warranty_Subtype__c = null;
        controller.validateHeaderFields();//Validate Warranty Type should not be NULL
        claim.CSS_WS_Warranty_Type__c = 'Motor';
        controller.validateHeaderFields();//Validate Failure Date should not be NULL
        claim.CSS_WS_Failure_Date_Time__c = system.today();
        controller.validateHeaderFields();//Validate Warranty Sub-Type should not be NULL  
        claim.CSS_WS_Warranty_Type__c = 'Parte';
        controller.validateHeaderFields();//Validate End of Repair Date should not be NULL
        claim.CSS_WS_End_Repair_Date_Time__c = system.today();
        controller.validateHeaderFields();//Validate Claim Type should not be NULL
        claim.CSS_WS_Claim_Type__c = 'Nuevo';
        claim.CSS_WS_Policy_Flag__c = 'Policy';
        claim.CSS_WS_Account_Code__c = null;
        controller.validateHeaderFields();//Validate Account Code should not be NULL
        claim.CSS_WS_Account_Code__c = 'P90';
        controller.validateHeaderFields();//Validate Warranty Start Date should not be NULL
        claim.CSS_WS_Warranty_Start_Date__c = system.today();
        controller.validateHeaderFields();//Validate Service Model should not be NULL
        claim.CSS_WS_Service_Model__c = 'ISX CM871';
        controller.validateHeaderFields();//Validate Engine Application should not be NULL      
        claim.CSS_WS_Engine_Application_Code__c = '130'; 
        controller.validateHeaderFields();//Validate Customer Name should not be NULL
        claim.CSS_WS_Customer_Name__c = 'Castores';
        controller.validateHeaderFields();//Validate Manufacturer should not be NULL
        claim.CSS_WS_Manufacturer__c = 'Kenworth';
        controller.validateHeaderFields();//Validate Failure Point Quantity should not be NULL
        claim.CSS_WS_Failure_Point_Quantity__c = '1';
        controller.validateHeaderFields();//Validate Model Series should not be NULL 
        claim.CSS_WS_Model_Series__c = '999-99';
        controller.validateHeaderFields();//Validate Failure Measure should not be NULL 
        claim.CSS_WS_Failure_Measure__c = 'KM';
        controller.validateHeaderFields();//Validate Complaint #1 should not be NULL
        claim.CSS_WS_Complaints1__c = '5000';
        controller.validateHeaderFields();//Validate Repair/Work Order # should not be NULL
        claim.CSS_WS_Repair_Work_Order_Number__c = '151&?+';
        controller.validateHeaderFields();//Validate Repair/Work Order # should not containg special characters
        claim.CSS_WS_Repair_Work_Order_Number__c = '151931';
        claim.CSS_WS_Policy_Flag__c = 'Policy WW';
        controller.validateHeaderFields();//Validate Authorization Number should not be NULL
        claim.CSS_Authorization_Number__c = '9001';
        claim.CSS_WS_Policy_Flag__c = 'Warranty';
        claim.CSS_WS_Catastrophic__c = null;
        controller.validateHeaderFields();//Validate Catastrophic should not be NULL
        claim.CSS_WS_Catastrophic__c = 'Si';
        claim.CSS_WS_Replacement_Part__c = null;
        controller.validateHeaderFields();//Validate Replacement Part should not be NULL
        claim.CSS_WS_Replacement_Part__c = 'Block';
        controller.validateHeaderFields();//Rule SF65
        claim.CSS_WS_Warranty_Type__c = 'Motor';        
        claim.CSS_WS_Warranty_Subtype__c = 'No BIS';
        claim.CSS_WS_Multi_ESN__c = true;
        controller.validateHeaderFields();//Validate Repair Description should not be NULL
        claim.CSS_WS_Repair_Description__c = 'Test example';
        claim.CSS_WS_Campaigns_TRPs__c = '456789';
        claim.CSS_WS_Policy_Flag__c = 'Policy WW';
        controller.validateHeaderFields();//Please select an Pay Code
        claim.CSS_WS_Policy_Flag__c = 'Policy';
        claim.CSS_WS_Pay_Code__c = 'Dealer International';
        controller.validateHeaderFields();//Rule SF57
        SPDLTest.CSS_WS_Campaign_TRP__c = True; 
        SPDLTest.CSS_WS_Region_Name__c = null;
        upsert SPDLTest;
        controller.validateHeaderFields();//Return true  
        SPDLTest.CSS_WS_Region_Name__c = 'USA'; 
        upsert SPDLTest;
        controller.validateHeaderFields();//Else ValidateIfIsCentralAmerica
        SPDLTest.CSS_WS_Region_Name__c = 'Mexico';
        SPDLTest.CSS_WS_Campaign_TRP__c = False; 
        claim.CSS_WS_Policy_Flag__c = 'Policy WW';
        upsert SPDLTest;
        controller.validateHeaderFields();//ValidateIfIsCentralAmerica
        
        //validateHeaderFields method
        claim.CSS_WS_Policy_Flag__c = 'Policy';//Validate Policy
        claim.CSS_WS_Customer_Support_authorization_da__c = null;
        claim.CSS_WS_Account_Code__c = 'P88';
        controller.validatePolicyFields();//Customer Support Authorization Date should not be empty
        String[] dat = '10/10/2010 12:30 PM'.split(' ');
        claim.CSS_WS_Customer_Support_authorization_da__c = date.parse(dat[0]);
        claim.CSS_WS_Quotation_Total_Amount__c = null;
        controller.validatePolicyFields();//Quotation Total Amount should not be empty or cero
        claim.CSS_WS_Quotation_Total_Amount__c = 1;
        controller.validatePolicyFields();//Requested Amount should not be empty
        claim.CSS_WS_Requested_Amount__c = 1;
        controller.validatePolicyFields();//Authorized Amount should not be empty
        claim.CSS_WS_Authorized_Amount__c = 1;
        claim.CSS_WS_Requested_Amount__c = 13;
        claim.CSS_WS_Quotation_Total_Amount__c = 12;
        controller.validatePolicyFields();//Validate Requested Amount should NOT be greater than Quotation Amount
        claim.CSS_WS_Authorized_Amount__c = 12; 
        claim.CSS_WS_Requested_Amount__c = 11;
        controller.validatePolicyFields();//Validate Authorized Amount should NOT be greater than Requested Amount
        claim.CSS_WS_Authorized_Amount__c = 10; 
        controller.validatePolicyFields();//Support Evidence should not be null
        attachment att = new attachment();
        controller.attachment_list.add(att);
        controller.validatePolicyFields();//Return true
        // test new fields in Policy for P101 claims
        claim.CSS_WS_Account_Code__c = 'P101';
        claim.CSS_WS_Request_Justification__c = null;
        controller.validatePolicyFields();//Request Justification should not be empty
        claim.CSS_WS_Request_Justification__c = 'test';
        claim.CSS_WS_Service_Provider_DR_ToCharge__c = null;
        controller.validatePolicyFields();//DR should not be empty 
        claim.CSS_WS_Service_Provider_DR_ToCharge__c = '54321';
        claim.CSS_WS_Service_Provider_Dealer_ToCharge__c = null;
        controller.validatePolicyFields();//Dealer should not be empty 
        test.stopTest();
    }
    
    Public Static testMethod Void testMethodgetESNAndData(){
        PageReference pageRef = Page.CSS_WS_ClaimFormat; 
        CSS_WS_Warranty__c claim = new CSS_WS_Warranty__c(
            CSS_WS_Engine_Serial_Number__c = '27345678',
            CSS_WS_Campaigns_TRPs__c = '456789',
            CSS_WS_Failure_Date_Time__c = system.today());
        insert claim;   
        
        CSS_WS_Engine_Application_Code__c engineApplicationCode = new CSS_WS_Engine_Application_Code__c(
            Name = 'AdanCodeTest',
            Application_Description__c = 'SRTTest');
        insert engineApplicationCode;
        
        claim = new CSS_WS_Warranty__c(
            CSS_WS_Engine_Serial_Number__c = '27345678',
            CSS_WS_Campaigns_TRPs__c = '456789',
            CSS_WS_Failure_Date_Time__c = system.today());
            
        Blob key = Blob.valueOf('12345678901234567890123456789012');
        CSS_Integration_Details__c MxTestConnection1 = new CSS_Integration_Details__c(
            Name = 'MxEngData',
            ApplicationName__c = 'MxEngData',
            End_Point__c = 'https://api-ue-devnf-aw-ex.cummins.com/api/core-security-api/v1/auth/token/MxEngData',
            IsActive__c = True,
            Method_Type__c = 'GET',
            AuthEnv__c = 'MxAuthEngi',
            Key__c =  EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('https://api-ue-devnf-aw-ex.cummins.com/cmi-engine'))),
            Passcode__c = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('~6_5~e.~8D19I0Sw7YSNtq2kiAgK5bA.w3'))),
            Username__c = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('400529c8-31be-4749-acfe-7549baa2fcb2')))
        );        
        insert MxTestConnection1; 
        CSS_Integration_Details__c MxTestConnection2 = new CSS_Integration_Details__c(
            Name = 'MxAuthWarr',
            ApplicationName__c = 'MxAuthWarr',
            End_Point__c = 'https://api-ue-devnf-aw-ex.cummins.com/api/core-security-api/v1/auth/token',
            IsActive__c = True,
            Method_Type__c = 'POST',
            AuthEnv__c = '',
            Key__c =  EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('https://api-ue-devnf-aw-ex.cummins.com/cmi/warranty'))),
            Passcode__c = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('~6_5~e.~8D19I0Sw7YSNtq2kiAgK5bA.w3'))),
            Username__c = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('400529c8-31be-4749-acfe-7549baa2fcb2')))
        );        
        insert MxTestConnection2; 
        
        CSS_Integration_Details__c MxTestConnection3 = new CSS_Integration_Details__c(
            Name = 'MxCampData',
            ApplicationName__c = 'MxCampData',
            End_Point__c = 'https://api-ue-devnf-aw-ex.cummins.com/api/core-security-api/v1/auth/token/MxCampData',
            IsActive__c = True,
            Method_Type__c = 'GET',
            AuthEnv__c = 'MxAuthEngi',
            Key__c =  EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('https://api-ue-devnf-aw-ex.cummins.com/cmi-engine'))),
            Passcode__c = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('~6_5~e.~8D19I0Sw7YSNtq2kiAgK5bA.w3'))),
            Username__c = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('400529c8-31be-4749-acfe-7549baa2fcb2')))
        );        
        insert MxTestConnection3; 
        
        ApexPages.StandardController standardController = new ApexPages.StandardController (claim); 
        CSS_WS_ControllerClaim controller = new CSS_WS_ControllerClaim(standardController);  
        Test.setCurrentPage(pageRef);
        System.currentPageReference().getParameters().put('clone', '1');
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new CSS_WS_WebServicesMock());       
        controller.getESN();//ESN correct and Campaing correct
        controller.getESNPolicyP101();
        claim.CSS_WS_Engine_Serial_Number__c = '1234567R';
        controller.getESN();//ESN incorrect, delete the ESN method
        controller.getESN();//ESN is null on getESN
        controller.getCampaingsOp();//ESN is null on getCampaing
        controller.mapEngineApplication('SRTTest');
        System.assert(claim.id == null);
        System.currentPageReference().getParameters().put('clone', '1');
        controller.getRouter();
        Test.stopTest();
    }
    
    Public Static testMethod Void testMethodgetCampaings(){
        PageReference pageRef = Page.CSS_WS_ClaimFormat;
        CSS_WS_Failure_Master__c Fail =  new CSS_WS_Failure_Master__c(
            Name = 'Adan',
            Engine_Component_Code_Description__c = '12',
            Engine_System_Code_Description__c = '18',
            Engine_System_Code__c = 'XM',
            Engine_Component_Code__c = 'TO',
            CSS_WS_Unique_Id__c = '2-XM-TO');
        insert Fail;
        CSS_WS_Fail_Mode_Catalog__c FailMode = new CSS_WS_Fail_Mode_Catalog__c(
            Name = 'Adan2',
            CSS_WS_Name__c = 'Example',
            CSS_WS_FailMode__c = 'AH');
        insert FailMode;          
        CSS_WS_Warranty__c claim = new CSS_WS_Warranty__c(
            CSS_WS_Service_Provider_DR__c = '54321',
            CSS_WS_Service_Provider_Dealer__c = '12345',
            CSS_WS_Engine_Serial_Number__c = '12345678',
            CSS_WS_Policy_Flag__c = 'Warranty',
            CSS_WS_Customer_Name__c = 'Castores',
            CSS_WS_Manufacturer__c = 'Sony',
            CSS_WS_Account_Code__c = 'P88',
            CSS_WS_Failure_Date_Time__c = system.today(),
            CSS_WS_Warranty_Start_Date__c = system.today(),
            CSS_WS_Engine_Family_Code__c = '2',
            CSS_WS_Warranty_Type__c = 'Motor',
            CSS_WS_Warranty_Subtype__c = 'No BIS',
            CSS_WS_Engine_Application__c = 'AUTOMOTIVE',
            CSS_WS_Failure_Point_Quantity__c = '2',
            CSS_WS_Failure_Measure__c = 'Km',
            CSS_WS_Complaints1__c = 'Break Fail',
            CSS_WS_Repair_Work_Order_Number__c = '1103REPC',
            CSS_WS_Service_Model__c = 'AX-LM0',
            CSS_WS_Multi_ESN__c = true,
            CSS_WS_Catastrophic__c = 'No',
            CSS_WS_ESN_Count__c = '2',
            CSS_WS_Lodging__c = 1,
            CSS_WS_Towing_Amount__c = 1,
            CSS_WS_Travel_Hours__c = 1,
            CSS_WS_Travel_Distance__c = 1,
            CSS_WS_Campaigns_TRPs__c = '5667567567');
        insert claim;
        CSS_WS_Fail_Mode_Catalog__c failModes = new CSS_WS_Fail_Mode_Catalog__c( 
            CSS_WS_FailMode__c = 'OL', 
            CSS_WS_Name__c = 'failModesTest',
            Name = 'Hello'); 
        insert failModes;
        String FailDat = '9/11/2017 5:04 PM';
        String[] dat = FailDat.split(' ');
        CSS_WS_Rescue__c rescue = new CSS_WS_Rescue__c(
            CSS_WS_ServiceRequest__c = date.parse(dat[0]), 
            CSS_WS_Engine_Serial_Number__c = '12345678',
            CSS_WS_Service_Provider_Dealer__c = '12345',
            CSS_WS_Warranty_Relationship__c = null, 
            CSS_WS_RescueStatus__c = 'Authorized by Planta');
        insert rescue;
        
        Blob key = Blob.valueOf('12345678901234567890123456789012');
        CSS_Integration_Details__c MxTestConnection1 = new CSS_Integration_Details__c(
            Name = 'MxEngData',
            ApplicationName__c = 'MxEngData',
            End_Point__c = 'https://api-ue-devnf-aw-ex.cummins.com/api/core-security-api/v1/auth/token/MxEngData',
            IsActive__c = True,
            Method_Type__c = 'GET',
            AuthEnv__c = 'MxAuthEngi',
            Key__c =  EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('https://api-ue-devnf-aw-ex.cummins.com/cmi-engine'))),
            Passcode__c = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('~6_5~e.~8D19I0Sw7YSNtq2kiAgK5bA.w3'))),
            Username__c = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('400529c8-31be-4749-acfe-7549baa2fcb2')))
        );        
        insert MxTestConnection1; 
        
        CSS_Integration_Details__c MxTestConnection2 = new CSS_Integration_Details__c(
            Name = 'MxAuthWarr',
            ApplicationName__c = 'MxAuthWarr',
            End_Point__c = 'https://api-ue-devnf-aw-ex.cummins.com/api/core-security-api/v1/auth/token',
            IsActive__c = True,
            Method_Type__c = 'POST',
            AuthEnv__c = '',
            Key__c =  EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('https://api-ue-devnf-aw-ex.cummins.com/cmi/warranty'))),
            Passcode__c = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('~6_5~e.~8D19I0Sw7YSNtq2kiAgK5bA.w3'))),
            Username__c = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('400529c8-31be-4749-acfe-7549baa2fcb2')))
        );        
        insert MxTestConnection2; 
        
        CSS_Integration_Details__c MxTestConnection3 = new CSS_Integration_Details__c(
            Name = 'MxCampData',
            ApplicationName__c = 'MxCampData',
            End_Point__c = 'https://api-ue-devnf-aw-ex.cummins.com/api/core-security-api/v1/auth/token/MxCampData',
            IsActive__c = True,
            Method_Type__c = 'GET',
            AuthEnv__c = 'MxAuthEngi',
            Key__c =  EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('https://api-ue-devnf-aw-ex.cummins.com/cmi-engine'))),
            Passcode__c = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('~6_5~e.~8D19I0Sw7YSNtq2kiAgK5bA.w3'))),
            Username__c = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('400529c8-31be-4749-acfe-7549baa2fcb2')))
        );        
        insert MxTestConnection3; 
        
        ApexPages.StandardController standardController = new ApexPages.StandardController (claim); 
        CSS_WS_ControllerClaim controller = new CSS_WS_ControllerClaim(standardController);  
        Test.setCurrentPage(pageRef);
        Test.StartTest();
        controller.getCampaingsOp();
        Test.setMock(HttpCalloutMock.class, new CSS_WS_WebServicesMock());
        controller.getESN();//Finish execute
        upsert claim;
        controller.failureData();
        claim.CSS_WS_Engine_Serial_Number__c = '1234567r'; 
        controller.getESN();//Else "this.claim.CSS_WS_Engine_Serial_Number__c != null"
        claim.CSS_WS_Engine_Serial_Number__c = null;
        controller.getCampaingsOp();//Else "String.isEmpty(this.claim.CSS_WS_Engine_Serial_Number__c) == false && this.claim.CSS_WS_Failure_Date_Time__c != null"
        controller.getESN();//Else "this.ESNR.isNumeric() && this.ESNR.length()==8"
        Test.StopTest();
    }
    
    Public Static testMethod Void testMethodBackTabs(){
        PageReference pageRef = Page.CSS_WS_ClaimFormat;
        CSS_WS_Warranty__c claim = new CSS_WS_Warranty__c();    
        ApexPages.StandardController standardController = new ApexPages.StandardController (claim); 
        CSS_WS_ControllerClaim controller = new CSS_WS_ControllerClaim(standardController);  
        Test.setCurrentPage(pageRef);
        Test.StartTest();
        controller.backToHeaderDisabled();
        controller.backFailure();
        controller.backMultiESN();
        controller.backNarrative();
        controller.backSRT();
        controller.backParts();
        controller.backTravel();
        controller.backClaimable();    
        
        claim = new CSS_WS_Warranty__c(
            CSS_WS_Service_Provider_DR__c = '54321',
            CSS_WS_Service_Provider_Dealer__c = '12345',
            CSS_WS_Engine_Serial_Number__c = '12345678',
            CSS_WS_Policy_Flag__c = 'Warranty',
            CSS_WS_Customer_Name__c = 'Castores',
            CSS_WS_Manufacturer__c = 'Sony',
            CSS_WS_Account_Code__c = 'P88',
            CSS_WS_Failure_Date_Time__c = system.today(),
            CSS_WS_Warranty_Start_Date__c = system.today(),
            CSS_WS_Engine_Family_Code__c = '2',
            CSS_WS_Warranty_Type__c = 'Motor',
            CSS_WS_Warranty_Subtype__c = 'No BIS',
            CSS_WS_Engine_Application__c = 'AUTOMOTIVE',
            CSS_WS_Failure_Point_Quantity__c = '2',
            CSS_WS_Failure_Measure__c = 'Km',
            CSS_WS_Complaints1__c = 'Break Fail',
            CSS_WS_Repair_Work_Order_Number__c = '1103REPC',
            CSS_WS_Service_Model__c = 'AX-LM0',
            CSS_WS_Catastrophic__c = 'No',
            CSS_WS_ESN_Count__c = '2',
            CSS_WS_Lodging__c = 1,
            CSS_WS_Towing_Amount__c = 1,
            CSS_WS_Travel_Hours__c = 1,
            CSS_WS_Travel_Distance__c = 1,
            CSS_WS_Campaigns_TRPs__c = '5667567567');
        insert claim;   
        
        standardController = new ApexPages.StandardController (claim); 
        controller = new CSS_WS_ControllerClaim(standardController);  
        controller.backToHeaderDisabled();
        controller.backFailure();
        controller.backMultiESN();
        controller.backNarrative();
        controller.backSRT();
        controller.backParts();
        controller.backTravel();
        controller.backClaimable();
        
        controller.flagSRT = true;
        controller.showTravel = true;
        claim.CSS_WS_Multi_ESN__c = true;
        controller.backNarrative();
        controller.backParts();
        controller.backClaimable();
        Test.StopTest();
    }
    
    Public Static testMethod Void testGetRouter(){
        PageReference pageRef = Page.CSS_WS_ClaimFormat;
        CSS_WS_Warranty__c claim = new CSS_WS_Warranty__c(
            //CSS_WS_Warranty_Start_Date__c = date.parse(datStart[0]),
            CSS_WS_Engine_Serial_Number__c = '10000000',
            CSS_WS_Service_Provider_DR__c = '54321',
            CSS_WS_Service_Provider_Dealer__c = '12345',
            CSS_WS_Policy_Flag__c = 'Warranty',
            CSS_WS_Claim_Status__c = 'Pending US',
            CSS_WS_Account_Code__c = null,
            //CSS_WS_Failure_Date_Time__c = date.parse(datFail[0]),
            CSS_WS_Engine_Family_Code__c = '12',
            CSS_WS_Manufacturer__c = '12349',
            //CSS_WS_Customer_Name_Internal__c = CustomerTest.id,
            Is_Clone__c = 1);
        insert claim; 
        
        Blob key = Blob.valueOf('12345678901234567890123456789012');
        CSS_Integration_Details__c MxTestConnection1 = new CSS_Integration_Details__c(
            Name = 'MxSPData',
            ApplicationName__c = 'MxSPData',
            End_Point__c = 'https://api-ue-devnf-aw-ex.cummins.com/api/core-security-api/v1/auth/token/MxSPData',
            IsActive__c = True,
            Method_Type__c = 'GET',
            AuthEnv__c = 'MxAuthServ',
            Key__c =  EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('https://api-ue-devnf-aw-ex.cummins.com/cmi-engine'))),
            Passcode__c = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('~6_5~e.~8D19I0Sw7YSNtq2kiAgK5bA.w3'))),
            Username__c = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('400529c8-31be-4749-acfe-7549baa2fcb2')))
        );        
        insert MxTestConnection1; 
        
        CSS_Integration_Details__c MxTestConnection2 = new CSS_Integration_Details__c(
            Name = 'MxAuthWarr',
            ApplicationName__c = 'MxAuthWarr',
            End_Point__c = 'https://api-ue-devnf-aw-ex.cummins.com/api/core-security-api/v1/auth/token',
            IsActive__c = True,
            Method_Type__c = 'POST',
            AuthEnv__c = '',
            Key__c =  EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('https://api-ue-devnf-aw-ex.cummins.com/cmi/warranty'))),
            Passcode__c = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('~6_5~e.~8D19I0Sw7YSNtq2kiAgK5bA.w3'))),
            Username__c = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('400529c8-31be-4749-acfe-7549baa2fcb2')))
        );        
        insert MxTestConnection2; 
        
        Test.startTest();
        Test.setCurrentPage(pageRef);
        System.currentPageReference().getParameters().put('id', claim.id);
        System.currentPageReference().getParameters().put('clone', '1');
        ApexPages.StandardController standardController = new ApexPages.StandardController(claim); 
        CSS_WS_ControllerClaim controller = new CSS_WS_ControllerClaim(standardController);
        controller.getRouter();
        System.currentPageReference().getParameters().put('clone', '0');
        /*Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
        req1.setObjectId(claim.id);
        Approval.ProcessResult result = Approval.process(req1);
        controller.getRouter();*/
        controller.getRouter();
        Approval.LockResult lr = Approval.lock(claim, false);
        controller.getRouter();
        controller.getSPData();
        Test.setMock(HttpCalloutMock.class, new CSS_WS_WebServicesMock());
        claim.CSS_WS_Failure_Date_Time__c = system.today();
        controller.getSPData();
        Test.stopTest();
    }
    
    Public Static testMethod Void testGetRouterClone(){
        PageReference pageRef = Page.CSS_WS_ClaimFormat;
        
        Account DRTest = new Account(
            IAM_Service_Provider_Code__c = '54734',
            CSS_DBCode__c = '54734',
            Type = 'Distributor Account',
            Name = 'Dummy DR',
            CMI_Account_Status__c = 'Active',
            BillingCountry = 'Mexico');
        insert DRTest;
        
        CSS_WS_Warranty__c claim = new CSS_WS_Warranty__c(
            //CSS_WS_Warranty_Start_Date__c = date.parse(datStart[0]),
            CSS_WS_Engine_Serial_Number__c = '10000000',
            CSS_WS_Service_Provider_DR__c = '54734',
            CSS_WS_Service_Provider_Dealer__c = '54734',
            CSS_WS_Policy_Flag__c = 'Warranty',
            CSS_WS_Claim_Status__c = 'Paid',
            CSS_WS_Account_Code__c = null,
            //CSS_WS_Failure_Date_Time__c = date.parse(datFail[0]),
            CSS_WS_Engine_Family_Code__c = '12',
            CSS_WS_Manufacturer__c = '12349',
            //CSS_WS_Customer_Name_Internal__c = CustomerTest.id,
            Is_Clone__c = 2);
        insert claim; 
        
        Test.startTest();
        Test.setCurrentPage(pageRef);
        System.currentPageReference().getParameters().put('id', claim.id);
        System.currentPageReference().getParameters().put('clone', '2');
        ApexPages.StandardController standardController = new ApexPages.StandardController(claim); 
        CSS_WS_ControllerClaim controller = new CSS_WS_ControllerClaim(standardController);
        controller.getRouter();
        System.currentPageReference().getParameters().put('id', claim.id);
        System.currentPageReference().getParameters().put('clone', '0');
        standardController = new ApexPages.StandardController(claim); 
        controller = new CSS_WS_ControllerClaim(standardController);  
        controller.getRouter();
        Test.stopTest();
    }
        
    Public Static testMethod Void testSPDataValidateHeaderContinueHeader(){
        PageReference pageRef = Page.CSS_WS_ClaimFormat;
        CSS_WS_Warranty__c claim = new CSS_WS_Warranty__c(
            CSS_WS_Service_Provider_DR__c = '54734',
            CSS_WS_Service_Provider_Dealer__c = '12345',
            CSS_WS_Policy_Flag__c = 'Warranty',
            CSS_WS_Account_Code__c = null,
            CSS_WS_Failure_Date_Time__c = system.today(),
            CSS_WS_Engine_Family_Code__c = '12',
            CSS_WS_Manufacturer__c = '12349',
            Is_Clone__c = 1);
        insert claim; 
        Account SPDLTest = new Account(
            IAM_Service_Provider_Code__c = '12345',
            CSS_DBCode__c = '54734',
            Type = 'Dealer Account',
            Name = 'DUMMY DEALER',
            CMI_Account_Status__c = 'Active',
            CSS_WS_Campaign_TRP__c = true,
            CSS_WS_Region_Code__c = 'USCA',
            BillingCountry = 'Mexico',
            CSS_WS_Claim_Allow_Days__c = 10,
            Warranty_Training_Certification__c = true,
            CSS_WS_Max_Claim_Amount__c = 9999);
        insert SPDLTest;
        
        Blob key = Blob.valueOf('12345678901234567890123456789012');
        CSS_Integration_Details__c MxTestConnection1 = new CSS_Integration_Details__c(
            Name = 'MxSPData',
            ApplicationName__c = 'MxSPData',
            End_Point__c = 'https://api-ue-devnf-aw-ex.cummins.com/api/core-security-api/v1/auth/token/MxSPData',
            IsActive__c = True,
            Method_Type__c = 'GET',
            AuthEnv__c = 'MxAuthServ',
            Key__c =  EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('https://api-ue-devnf-aw-ex.cummins.com/cmi-engine'))),
            Passcode__c = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('~6_5~e.~8D19I0Sw7YSNtq2kiAgK5bA.w3'))),
            Username__c = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('400529c8-31be-4749-acfe-7549baa2fcb2')))
        );        
        insert MxTestConnection1; 
        
        CSS_Integration_Details__c MxTestConnection2 = new CSS_Integration_Details__c(
            Name = 'MxAuthWarr',
            ApplicationName__c = 'MxAuthWarr',
            End_Point__c = 'https://api-ue-devnf-aw-ex.cummins.com/api/core-security-api/v1/auth/token',
            IsActive__c = True,
            Method_Type__c = 'POST',
            AuthEnv__c = '',
            Key__c =  EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('https://api-ue-devnf-aw-ex.cummins.com/cmi/warranty'))),
            Passcode__c = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('~6_5~e.~8D19I0Sw7YSNtq2kiAgK5bA.w3'))),
            Username__c = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('400529c8-31be-4749-acfe-7549baa2fcb2')))
        );        
        insert MxTestConnection2; 
        
        CSS_Integration_Details__c MxTestConnection3 = new CSS_Integration_Details__c(
            Name = 'MxHeadVal',
            ApplicationName__c = 'MxHeadVal',
            End_Point__c = 'https://api-ue-devnf-aw-ex.cummins.com/api/core-security-api/v1/auth/token/MxHeadVal',
            IsActive__c = True,
            Method_Type__c = 'POST',
            AuthEnv__c = 'MxAuthClai',
            Key__c =  EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('https://api-ue-devnf-aw-ex.cummins.com/cmi-engine'))),
            Passcode__c = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('~6_5~e.~8D19I0Sw7YSNtq2kiAgK5bA.w3'))),
            Username__c = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('400529c8-31be-4749-acfe-7549baa2fcb2')))
        );        
        insert MxTestConnection3; 
        
        CSS_Integration_Details__c MxTestConnection4 = new CSS_Integration_Details__c(
            Name = 'MxAccCov',
            ApplicationName__c = 'MxAccCov',
            End_Point__c = 'https://api-ue-devnf-aw-ex.cummins.com/api/core-security-api/v1/auth/token/MxAccCov',
            IsActive__c = True,
            Method_Type__c = 'POST',
            AuthEnv__c = 'MxAuthWarr',
            Key__c =  EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('12345'))),
            Passcode__c = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('44D61a8cfd674608AD155831cEA89Bdc'))),
            Username__c = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('f0036e9ab48d4f37a16a6e7fa2566e85')))
        );        
        insert MxTestConnection4; 
        
        ApexPages.StandardController standardController = new ApexPages.StandardController (claim); 
        CSS_WS_ControllerClaim controller = new CSS_WS_ControllerClaim(standardController);  
        
        Test.startTest();
        controller.getSPData();
        Test.setMock(HttpCalloutMock.class, new CSS_WS_WebServicesMock());
        controller.getSPData();
        
        //claim.CSS_WS_Warranty_Subtype__c = 'BIS';
        claim.CSS_WS_Claim_Type__c = 'Herramienta de Servicio';
        claim.CSS_WS_Engine_Serial_Number__c = '73279794';
        claim.CSS_WS_Service_Provider_Dealer__c = '12345';
        claim.CSS_WS_Engine_Family_Code__c = '080XL';
        claim.CSS_WS_Failure_Measure__c = 'KM';
        claim.CSS_WS_Failure_Point_Quantity__c = '10';
        claim.CSS_WS_Multi_ESN__c = false;
        claim.CSS_WS_Product_Application_Code__c = '12';
        claim.CSS_WS_Repair_Work_Order_Number__c = '151931';
        claim.CSS_WS_Service_Model__c = 'ISC8.3 CM2250';
        String Fail = '06/04/2012';
        String[] dat = Fail.split(' ');
        claim.CSS_WS_Failure_Date_Time__c = date.parse(dat[0]);
        Fail = '05/06/2012 8:42 AM';
        dat = Fail.split(' ');
        claim.CSS_WS_Warranty_Start_Date__c = system.today();
        claim.CSS_WS_Policy_Flag__c = 'Warranty';
        claim.CSS_WS_Service_Provider_DR__c = '54734';
        claim.CSS_WS_Warranty_Type__c = 'Parte';
        claim.CSS_WS_Account_Code__c = '67';
        claim.CSS_WS_Engine_Application_Code__c = 'engine_application_code'; 
        claim.CSS_WS_Customer_Name__c = 'Castores';
        claim.CSS_WS_Manufacturer__c = 'Kenworth';
        claim.CSS_WS_Model_Series__c = '999-99';
        claim.CSS_WS_Complaints1__c = '5000';
        claim.CSS_WS_Complaints2__c = '5000';
        claim.CSS_WS_Complaints3__c = '5000';
        claim.CSS_Authorization_Number__c = '9001';
        claim.CSS_WS_Catastrophic__c = 'Si';
        claim.CSS_WS_Replacement_Part__c = 'Block';        
        claim.CSS_WS_Repair_Description__c = 'Test example';
        //claim.CSS_WS_Campaigns_TRPs__c = '456789';
        claim.CSS_WS_Build_Date__c = system.today();
        claim.CSS_WS_Engine_Trade_Out_conversion_date__c = system.today();
        claim.CSS_WS_Product_Application_Description__c = 'General';
        claim.CSS_WS_Pay_Code__c = '90';
        claim.CSS_WS_End_Repair_Date_Time__c = system.today();
        controller.validateHeader();
        
        controller.continueHeader();
        Test.stopTest();
    }
    
}