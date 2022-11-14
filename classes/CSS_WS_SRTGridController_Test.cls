@IsTest
Public Class CSS_WS_SRTGridController_Test{

    Public Static TestMethod Void testingMethodsWithPreviousSRTs(){
        PageReference pageRef = Page.CSS_WS_ClaimFormat;
        CSS_WS_Warranty__c Claim = new CSS_WS_Warranty__c(
            CSS_WS_Campaigns_TRPs__c = 'XF123',
            CSS_WS_Engine_Serial_Number__c = '11111111',
            CSS_WS_Engine_Family_Code__c = '46',
            CSS_WS_Service_Provider_Dealer__c = '55893',
            CSS_WS_Failure_Date_Time__c = Date.today(),
            CSS_WS_Failure_Point_Quantity__c = '2',
            CSS_WS_Failure_Measure__c = 'Km',
            CSS_WS_Warranty_Start_Date__c = Date.today(),
            CSS_WS_Warranty_Type__c = 'Parte',
            CSS_WS_Claim_Type__c = 'Herramienta de Servicio',
            CSS_WS_Policy_Flag__c = 'Policy',
            CSS_WS_Pay_Code__c = 'R',
            CSS_WS_Account_Code__c = '65',
            CSS_WS_Account_Code_Type__c = '01',
            CSS_WS_Product_Application_Code__c = '02',
            CSS_WS_Warranty_Subtype__c = null,
            CSS_WS_Multi_ESN__c = true,
            CSS_WS_Service_Provider_DR__c = '55893',
            CSS_WS_Total_Labor__c = 1234.00,
            CSS_Authorization_Number__c = '982',
            CSS_WS_Approval_Code__c = '1234',
            CSS_WS_Towing_Amount__c = 67.55,
            CSS_WS_Covered_OC_Amount__c = 99999,
            CSS_WS_Covered_Labor_Hours__c = 9999,
            CSS_WS_Service_Model__c = '56',
            CSS_WS_Access_Code__c = '98');
        insert Claim;
        
        CSS_WS_Failure__c fail =  new CSS_WS_Failure__c(
            CSS_WS_EngineSystemCode__c = 'XO', 
            CSS_WS_ComponentCode__c = 'LO', 
            CSS_WS_FailureModeCode__c = 'CA', 
            CSS_WS_Warranty__c = Claim.Id);
        insert fail;
        
        Account SPDLTest = new Account(
            IAM_Service_Provider_Code__c = '55893',
            CSS_DBCode__c = '55893',
            Type = 'Dealer Account',
            Name = 'DUMMY DEALER',
            CMI_Account_Status__c = 'Active',
            BillingCountry = 'MEXICO');
        insert SPDLTest;
        
        CSS_WS_Warranty_SRT__c WarrantyToInsert = new CSS_WS_Warranty_SRT__c(
            CSS_WS_Adjust_Percentage__c=100,
            CSS_WS_Access_Code__c='R',
            CSS_WS_Actual_Hours__c=9.2,
            CSS_WS_Amount__c=215.28,
            CSS_WS_Description__c='Crankshaft-RemoveandInstall-QSF3.8CM2350F107',
            CSS_WS_Extended_Hours__c=11.5,
            CSS_WS_Hours__c=11.5,
            CSS_WS_Hours_Percentage__c=100,
            CSS_WS_Labor_Rate__c=1,
            CSS_WS_Offsite__c=false,
            CSS_WS_OutOfChassis__c=true,
            CSS_WS_Overlap_Hours__c=2.3,
            CSS_WS_Quantity__c=2,
            CSS_WS_Requested_Amount__c=1.00,
            CSS_WS_SRT__c='19-611-00',
            CSS_WS_Total__c=1,
            CSS_WS_WarrantyID__c= Claim.Id);
        insert WarrantyToInsert;
        
        Blob key = Blob.valueOf('12345678901234567890123456789012');
        CSS_Integration_Details__c MxTestConnection1 = new CSS_Integration_Details__c(
            Name = 'MxSRTData',
            ApplicationName__c = 'MxSRTData',
            End_Point__c = 'https://api-ue-devnf-aw-ex.cummins.com/api/core-security-api/v1/auth/token/MxSRTData',
            IsActive__c = True,
            Method_Type__c = 'GET',
            AuthEnv__c = 'MxAuthEngi',
            Key__c =  EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('https://api-ue-devnf-aw-ex.cummins.com/cmi-engine'))),
            Passcode__c = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('~6_5~e.~8D19I0Sw7YSNtq2kiAgK5bA.w3'))),
            Username__c = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('400529c8-31be-4749-acfe-7549baa2fcb2')))
        );        
        insert MxTestConnection1; 
        
        CSS_Integration_Details__c MxTestConnection2 = new CSS_Integration_Details__c(
            Name = 'MxSRTOver2',
            ApplicationName__c = 'MxSRTOver2',
            End_Point__c = 'https://api-ue-devnf-aw-ex.cummins.com/api/core-security-api/v1/auth/token/MxSRTOver2',
            IsActive__c = True,
            Method_Type__c = 'POST',
            AuthEnv__c = 'MxAuthEngi',
            Key__c =  EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('https://api-ue-devnf-aw-ex.cummins.com/cmi-engine'))),
            Passcode__c = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('~6_5~e.~8D19I0Sw7YSNtq2kiAgK5bA.w3'))),
            Username__c = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('400529c8-31be-4749-acfe-7549baa2fcb2')))
        );        
        insert MxTestConnection2;
        
        CSS_Integration_Details__c MxTestConnection3 = new CSS_Integration_Details__c(
            Name = 'MxSRTVal',
            ApplicationName__c = 'MxSRTVal',
            End_Point__c = 'https://api-ue-devnf-aw-ex.cummins.com/api/core-security-api/v1/auth/token/MxSRTVal',
            IsActive__c = True,
            Method_Type__c = 'POST',
            AuthEnv__c = 'MxAuthClai',
            Key__c =  EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('https://api-ue-devnf-aw-ex.cummins.com/cmi-engine'))),
            Passcode__c = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('~6_5~e.~8D19I0Sw7YSNtq2kiAgK5bA.w3'))),
            Username__c = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('400529c8-31be-4749-acfe-7549baa2fcb2')))
        );        
        insert MxTestConnection3; 
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new CSS_WS_WebServicesMock());
        ApexPages.StandardController standardController = new ApexPages.StandardController(Claim);
        CSS_WS_SRTGridController controller = new CSS_WS_SRTGridController(standardController);       
        Test.setCurrentPage(pageRef);
        controller.SaveSRTGrids();//Rule SF-P11 and is diferent of Warranty
        controller.TotalAmountSRTHoursExtended = 100;        
        Claim.CSS_WS_Policy_Flag__c = 'Warranty';
        Claim.CSS_WS_Campaign_Labor_Percentage__c = 0;
        upsert claim;
        controller.SaveSRTGrids();//Warranty whit campaing
        Claim.CSS_WS_Campaign_Labor_Percentage__c = 80;        
        upsert claim;
        controller.SaveSRTGrids();//Warranty whit campaing and Covered_Labor_Hours__c > TotalAmountSRTHoursExtended
        Claim.CSS_WS_Campaigns_TRPs__c = '';
        Claim.CSS_WS_Policy_Flag__c = 'Policy WW';       
        upsert claim;
        controller.SaveSRTGrids();//Warranty not campaing
        claim.CSS_WS_Covered_Labor_Hours__c = 101;
        upsert claim;
        controller.SaveSRTGrids();
        Test.stopTest();
    }
    
    Public Static TestMethod Void testingMethodsWithOutPreviousSRTs(){
        PageReference pageRef = Page.CSS_WS_ClaimFormat;
        CSS_WS_Warranty__c Claim = new CSS_WS_Warranty__c(
            CSS_WS_Campaigns_TRPs__c = null,
            CSS_WS_Engine_Serial_Number__c = '11111111',
            CSS_WS_Engine_Family_Code__c = '46',
            CSS_WS_Service_Provider_Dealer__c = '55893',
            CSS_WS_Service_Provider_DR__c = '55893',
            CSS_WS_Failure_Date_Time__c = Date.today(),
            CSS_WS_Failure_Point_Quantity__c = '2',
            CSS_WS_Failure_Measure__c = 'Km',
            CSS_WS_Warranty_Start_Date__c = Date.today(),
            CSS_WS_Warranty_Type__c = 'Parte',
            CSS_WS_Claim_Type__c = 'Herramienta de Servicio',
            CSS_WS_Policy_Flag__c = 'Warranty',
            CSS_WS_Pay_Code__c = 'R',
            CSS_WS_Account_Code__c = '65',
            CSS_WS_Account_Code_Type__c = '01',
            CSS_WS_Product_Application_Code__c = '02',
            CSS_WS_Warranty_Subtype__c = null,
            CSS_WS_Multi_ESN__c = true,
            CSS_WS_Total_Labor__c = 1234.00,
            CSS_Authorization_Number__c = '982',
            CSS_WS_Approval_Code__c = '1234',
            CSS_WS_Towing_Amount__c = 67.55,
            CSS_WS_Covered_OC_Amount__c = 99999,
            CSS_WS_Covered_Labor_Hours__c = 9999,
            CSS_WS_Service_Model__c = '56',
            CSS_WS_Access_Code__c = 'R');
        insert Claim;
        
        CSS_WS_Failure__c fail =  new CSS_WS_Failure__c(
            CSS_WS_EngineSystemCode__c = 'XO', 
            CSS_WS_ComponentCode__c = 'LO', 
            CSS_WS_FailureModeCode__c = 'CA', 
            CSS_WS_Warranty__c = Claim.Id);
        insert fail;
        
        Account SPDLTest = new Account(
            IAM_Service_Provider_Code__c = '55893',
            CSS_DBCode__c = '55893',
            Type = 'Distributor Account',
            Name = 'DUMMY DEALER',
            CMI_Account_Status__c = 'Active',
            BillingCountry = 'Mexico');
        insert SPDLTest;
        
        Blob key = Blob.valueOf('12345678901234567890123456789012');
        CSS_Integration_Details__c MxTestConnection1 = new CSS_Integration_Details__c(
            Name = 'MxSRTData',
            ApplicationName__c = 'MxSRTData',
            End_Point__c = 'https://api-ue-devnf-aw-ex.cummins.com/api/core-security-api/v1/auth/token/MxSRTData',
            IsActive__c = True,
            Method_Type__c = 'GET',
            AuthEnv__c = 'MxAuthEngi',
            Key__c =  EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('https://api-ue-devnf-aw-ex.cummins.com/cmi-engine'))),
            Passcode__c = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('~6_5~e.~8D19I0Sw7YSNtq2kiAgK5bA.w3'))),
            Username__c = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('400529c8-31be-4749-acfe-7549baa2fcb2')))
        );        
        insert MxTestConnection1; 
        
        CSS_Integration_Details__c MxTestConnection2 = new CSS_Integration_Details__c(
            Name = 'MxSRTOver2',
            ApplicationName__c = 'MxSRTOver2',
            End_Point__c = 'https://api-ue-devnf-aw-ex.cummins.com/api/core-security-api/v1/auth/token/MxSRTOver2',
            IsActive__c = True,
            Method_Type__c = 'POST',
            AuthEnv__c = 'MxAuthEngi',
            Key__c =  EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('https://api-ue-devnf-aw-ex.cummins.com/cmi-engine'))),
            Passcode__c = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('~6_5~e.~8D19I0Sw7YSNtq2kiAgK5bA.w3'))),
            Username__c = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('400529c8-31be-4749-acfe-7549baa2fcb2')))
        );        
        insert MxTestConnection2;
        
        CSS_Integration_Details__c MxTestConnection3 = new CSS_Integration_Details__c(
            Name = 'MxSRTVal',
            ApplicationName__c = 'MxSRTVal',
            End_Point__c = 'https://api-ue-devnf-aw-ex.cummins.com/api/core-security-api/v1/auth/token/MxSRTVal',
            IsActive__c = True,
            Method_Type__c = 'POST',
            AuthEnv__c = 'MxAuthClai',
            Key__c =  EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('https://api-ue-devnf-aw-ex.cummins.com/cmi-engine'))),
            Passcode__c = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('~6_5~e.~8D19I0Sw7YSNtq2kiAgK5bA.w3'))),
            Username__c = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('400529c8-31be-4749-acfe-7549baa2fcb2')))
        );        
        insert MxTestConnection3; 
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new CSS_WS_WebServicesMock());
        ApexPages.StandardController standardController = new ApexPages.StandardController(Claim);
        CSS_WS_SRTGridController controller = new CSS_WS_SRTGridController(standardController);        
        Test.setCurrentPage(pageRef);
        
        controller.SRTsList.add(new CSS_WS_SRTGridController.CreateNewSRT(1, false, 1.1, 'R', 1.1, 2.2, 'R', 1.1, 1.1, 1.1, 1.1, true, true,
                                                                          1.1, 1.1, 1.1, '07-018-00', 1.1, '123', 'PRIMARY', Claim.Id));
        controller.SRTsList.add(new CSS_WS_SRTGridController.CreateNewSRT(2, false, 1.1, 'R', 1.1, 2.2, 'R', 1.1, 1.1, 1.1, 1.1, true, true,
                                                                          1.1, 1.1, 1.1, '07-018-00', 1.1, '123', 'PRIMARY', Claim.Id));
        controller.SRTsList.add(new CSS_WS_SRTGridController.CreateNewSRT(2, false, 1.1, 'R', 1.1, 2.2, 'R', 1.1, 1.1, 1.1, 1.1, true, true,
                                                                          1.1, 1.1, 1.1, '99-999', 1.1, '123', 'PRIMARY', Claim.Id));
        controller.SRTToUpdate = 2;
        
        controller.DeleteSRT();
        controller.SRCallODMWebService();
        controller.SaveSRTGrids();        
        controller.CheckOutOfChassis();
        controller.SRTToUpdate = 2;
        controller.AssignSRTDescription();
        

        Test.stopTest();
    }
    
    Public Static TestMethod Void testingMethodsGetSRTInfo(){
        PageReference pageRef = Page.CSS_WS_ClaimFormat;
        CSS_WS_Warranty__c Claim = new CSS_WS_Warranty__c(
            CSS_WS_Campaigns_TRPs__c = '12345',
            CSS_WS_Engine_Serial_Number__c = '11111111',
            CSS_WS_Engine_Family_Code__c = '46',
            CSS_WS_Service_Provider_Dealer__c = '55893',
            CSS_WS_Failure_Date_Time__c = Date.today(),
            CSS_WS_Failure_Point_Quantity__c = '2',
            CSS_WS_Failure_Measure__c = 'Km',
            CSS_WS_Warranty_Start_Date__c = Date.today(),
            CSS_WS_Warranty_Type__c = 'Parte',
            CSS_WS_Claim_Type__c = 'Herramienta de Servicio',
            CSS_WS_Policy_Flag__c = 'Warranty',
            CSS_WS_Pay_Code__c = 'R',
            CSS_WS_Account_Code__c = '65',
            CSS_WS_Account_Code_Type__c = '01',
            CSS_WS_Product_Application_Code__c = '02',
            CSS_WS_Warranty_Subtype__c = null,
            CSS_WS_Multi_ESN__c = true,
            CSS_WS_Service_Provider_DR__c = '55893',
            CSS_WS_Total_Labor__c = 1234.00,
            CSS_Authorization_Number__c = '982',
            CSS_WS_Approval_Code__c = '1234',
            CSS_WS_Towing_Amount__c = 67.55,
            CSS_WS_Covered_OC_Amount__c = 99999,
            CSS_WS_Covered_Labor_Hours__c = 9999,
            CSS_WS_Service_Model__c = '56',
            CSS_WS_Access_Code__c = '98');
        insert Claim;
        
        Account SPDLTest = new Account(
            IAM_Service_Provider_Code__c = '55893',
            CSS_DBCode__c = '55893',
            Type = 'Dealer Account',
            Name = 'DUMMY DEALER',
            CMI_Account_Status__c = 'Active',
            BillingCountry = 'MEXICO');
        insert SPDLTest;
        
        CSS_WS_Warranty_SRT__c tem = new CSS_WS_Warranty_SRT__c(
            CSS_WS_Description__c = 'Example',
            CSS_WS_SRT__c = '07-018-00',
            CSS_WS_Access_Code__c = 'P28',
            CSS_WS_WarrantyID__c = Claim.Id);
        insert tem;
        
        Blob key = Blob.valueOf('12345678901234567890123456789012');
        CSS_Integration_Details__c MxTestConnection1 = new CSS_Integration_Details__c(
            Name = 'MxSRTData',
            ApplicationName__c = 'MxSRTData',
            End_Point__c = 'https://api-ue-devnf-aw-ex.cummins.com/api/core-security-api/v1/auth/token/MxSRTData',
            IsActive__c = True,
            Method_Type__c = 'GET',
            AuthEnv__c = 'MxAuthEngi',
            Key__c =  EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('https://api-ue-devnf-aw-ex.cummins.com/cmi-engine'))),
            Passcode__c = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('~6_5~e.~8D19I0Sw7YSNtq2kiAgK5bA.w3'))),
            Username__c = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('400529c8-31be-4749-acfe-7549baa2fcb2')))
        );        
        insert MxTestConnection1; 
        
        CSS_Integration_Details__c MxTestConnection2 = new CSS_Integration_Details__c(
            Name = 'MxSRTOver2',
            ApplicationName__c = 'MxSRTOver2',
            End_Point__c = 'https://api-ue-devnf-aw-ex.cummins.com/api/core-security-api/v1/auth/token/MxSRTOver2',
            IsActive__c = True,
            Method_Type__c = 'POST',
            AuthEnv__c = 'MxAuthEngi',
            Key__c =  EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('https://api-ue-devnf-aw-ex.cummins.com/cmi-engine'))),
            Passcode__c = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('~6_5~e.~8D19I0Sw7YSNtq2kiAgK5bA.w3'))),
            Username__c = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('400529c8-31be-4749-acfe-7549baa2fcb2')))
        );        
        insert MxTestConnection2;
        
        CSS_Integration_Details__c MxTestConnection3 = new CSS_Integration_Details__c(
            Name = 'MxSRTVal',
            ApplicationName__c = 'MxSRTVal',
            End_Point__c = 'https://api-ue-devnf-aw-ex.cummins.com/api/core-security-api/v1/auth/token/MxSRTVal',
            IsActive__c = True,
            Method_Type__c = 'POST',
            AuthEnv__c = 'MxAuthClai',
            Key__c =  EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('https://api-ue-devnf-aw-ex.cummins.com/cmi-engine'))),
            Passcode__c = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('~6_5~e.~8D19I0Sw7YSNtq2kiAgK5bA.w3'))),
            Username__c = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('400529c8-31be-4749-acfe-7549baa2fcb2')))
        );        
        insert MxTestConnection3; 
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new CSS_WS_WebServicesMock());
        ApexPages.StandardController standardController = new ApexPages.StandardController(Claim);
        CSS_WS_SRTGridController controller = new CSS_WS_SRTGridController(standardController);        
        Test.setCurrentPage(pageRef);
        controller.IsCampaign = true;
        controller.SetSRTOptionList();
        controller.GetSRTInfo();
        tem.CSS_WS_SRT__c = '99-999-00';
        upsert tem;
        claim.CSS_WS_Campaigns_TRPs__c = null;
        upsert claim;
        controller.IsCampaign = false;
        controller.GetSRTInfo();        
        
        claim.CSS_WS_ECM_Calibration_After__c = '12';
        claim.CSS_WS_ECM_Calibration_Before__c = '13';
        upsert claim;
        controller.Rule1108();
        Test.stopTest();
    }
    
    Public Static TestMethod Void testingMethodsGetSRTInfo2(){
        PageReference pageRef = Page.CSS_WS_ClaimFormat;
        CSS_WS_Warranty__c Claim = new CSS_WS_Warranty__c(
            CSS_WS_Engine_Serial_Number__c = '11111111',
            CSS_WS_Engine_Family_Code__c = '46',
            CSS_WS_Service_Provider_Dealer__c = '55893',
            CSS_WS_Failure_Date_Time__c = Date.today(),
            CSS_WS_Failure_Point_Quantity__c = '2',
            CSS_WS_Failure_Measure__c = 'Km',
            CSS_WS_Warranty_Start_Date__c = Date.today(),
            CSS_WS_Warranty_Type__c = 'Parte',
            CSS_WS_Claim_Type__c = 'Herramienta de Servicio',
            CSS_WS_Policy_Flag__c = 'Warranty',
            CSS_WS_Pay_Code__c = 'R',
            CSS_WS_Account_Code__c = '65',
            CSS_WS_Account_Code_Type__c = '01',
            CSS_WS_Product_Application_Code__c = '02',
            CSS_WS_Warranty_Subtype__c = null,
            CSS_WS_Multi_ESN__c = true,
            CSS_WS_Service_Provider_DR__c = '55893',
            CSS_WS_Total_Labor__c = 1234.00,
            CSS_Authorization_Number__c = '982',
            CSS_WS_Approval_Code__c = '1234',
            CSS_WS_Towing_Amount__c = 67.55,
            CSS_WS_Covered_OC_Amount__c = 99999,
            CSS_WS_Covered_Labor_Hours__c = 9999,
            CSS_WS_Service_Model__c = '56',
            CSS_WS_Access_Code__c = '98');
        insert Claim;
        
        Account SPDLTest = new Account(
            IAM_Service_Provider_Code__c = '55893',
            CSS_DBCode__c = '55893',
            Type = 'Dealer Account',
            Name = 'DUMMY DEALER',
            CMI_Account_Status__c = 'Active',
            BillingCountry = 'MEXICO');
        insert SPDLTest;
        
        CSS_WS_Warranty_SRT__c tem = new CSS_WS_Warranty_SRT__c(
            CSS_WS_Description__c = 'Example',
            CSS_WS_SRT__c = '07-018-00',
            CSS_WS_Access_Code__c = 'P28',
            CSS_WS_WarrantyID__c = Claim.Id);
        insert tem;
        
        Blob key = Blob.valueOf('12345678901234567890123456789012');
        CSS_Integration_Details__c MxTestConnection1 = new CSS_Integration_Details__c(
            Name = 'MxSRTData',
            ApplicationName__c = 'MxSRTData',
            End_Point__c = 'https://api-ue-devnf-aw-ex.cummins.com/api/core-security-api/v1/auth/token/MxSRTData',
            IsActive__c = True,
            Method_Type__c = 'GET',
            AuthEnv__c = 'MxAuthEngi',
            Key__c =  EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('https://api-ue-devnf-aw-ex.cummins.com/cmi-engine'))),
            Passcode__c = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('~6_5~e.~8D19I0Sw7YSNtq2kiAgK5bA.w3'))),
            Username__c = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('400529c8-31be-4749-acfe-7549baa2fcb2')))
        );        
        insert MxTestConnection1; 
        
        CSS_Integration_Details__c MxTestConnection2 = new CSS_Integration_Details__c(
            Name = 'MxSRTOver2',
            ApplicationName__c = 'MxSRTOver2',
            End_Point__c = 'https://api-ue-devnf-aw-ex.cummins.com/api/core-security-api/v1/auth/token/MxSRTOver2',
            IsActive__c = True,
            Method_Type__c = 'POST',
            AuthEnv__c = 'MxAuthEngi',
            Key__c =  EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('https://api-ue-devnf-aw-ex.cummins.com/cmi-engine'))),
            Passcode__c = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('~6_5~e.~8D19I0Sw7YSNtq2kiAgK5bA.w3'))),
            Username__c = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('400529c8-31be-4749-acfe-7549baa2fcb2')))
        );        
        insert MxTestConnection2;
        
        CSS_Integration_Details__c MxTestConnection3 = new CSS_Integration_Details__c(
            Name = 'MxSRTVal',
            ApplicationName__c = 'MxSRTVal',
            End_Point__c = 'https://api-ue-devnf-aw-ex.cummins.com/api/core-security-api/v1/auth/token/MxSRTVal',
            IsActive__c = True,
            Method_Type__c = 'POST',
            AuthEnv__c = 'MxAuthClai',
            Key__c =  EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('https://api-ue-devnf-aw-ex.cummins.com/cmi-engine'))),
            Passcode__c = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('~6_5~e.~8D19I0Sw7YSNtq2kiAgK5bA.w3'))),
            Username__c = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('400529c8-31be-4749-acfe-7549baa2fcb2')))
        );        
        insert MxTestConnection3; 
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new CSS_WS_WebServicesMock());
        ApexPages.StandardController standardController = new ApexPages.StandardController(Claim);
        CSS_WS_SRTGridController controller = new CSS_WS_SRTGridController(standardController);        
        Test.setCurrentPage(pageRef);
        controller.IsCampaign = true;
        controller.SetSRTOptionList();
        controller.GetSRTInfo();
        tem.CSS_WS_SRT__c = '99-999-00';
        upsert tem;
        claim.CSS_WS_Campaigns_TRPs__c = null;
        upsert claim;
        controller.IsCampaign = false;
        controller.GetSRTInfo();        
        
        claim.CSS_WS_ECM_Calibration_After__c = '12';
        claim.CSS_WS_ECM_Calibration_Before__c = '13';
        upsert claim;
        controller.Rule1108();
        Test.stopTest();
    }
    
    Public Static TestMethod Void testingMethodsGetSRTOverlapInfo(){
        PageReference pageRef = Page.CSS_WS_ClaimFormat;
        CSS_WS_Warranty__c Claim = new CSS_WS_Warranty__c(
            CSS_WS_Campaigns_TRPs__c = '12345',
            CSS_WS_Engine_Serial_Number__c = '11111111',
            CSS_WS_Engine_Family_Code__c = '46',
            CSS_WS_Service_Provider_Dealer__c = '55893',
            CSS_WS_Failure_Date_Time__c = Date.today(),
            CSS_WS_Failure_Point_Quantity__c = '2',
            CSS_WS_Failure_Measure__c = 'Km',
            CSS_WS_Warranty_Start_Date__c = Date.today(),
            CSS_WS_Warranty_Type__c = 'Parte',
            CSS_WS_Claim_Type__c = 'Herramienta de Servicio',
            CSS_WS_Policy_Flag__c = 'Warranty',
            CSS_WS_Pay_Code__c = 'R',
            CSS_WS_Account_Code__c = '65',
            CSS_WS_Account_Code_Type__c = '01',
            CSS_WS_Product_Application_Code__c = '02',
            CSS_WS_Warranty_Subtype__c = null,
            CSS_WS_Multi_ESN__c = true,
            CSS_WS_Service_Provider_DR__c = '55893',
            CSS_WS_Total_Labor__c = 1234.00,
            CSS_Authorization_Number__c = '982',
            CSS_WS_Approval_Code__c = '1234',
            CSS_WS_Towing_Amount__c = 67.55,
            CSS_WS_Covered_OC_Amount__c = 99999,
            CSS_WS_Covered_Labor_Hours__c = 9999,
            CSS_WS_Service_Model__c = '56',
            CSS_WS_Access_Code__c = 'A');
        insert Claim;
        
        Account SPDLTest = new Account(
            IAM_Service_Provider_Code__c = '55893',
            CSS_DBCode__c = '55893',
            Type = 'Dealer Account',
            Name = 'DUMMY DEALER',
            CMI_Account_Status__c = 'Active',
            BillingCountry = 'MEXICO');
        insert SPDLTest;
        
        CSS_WS_Warranty_SRT__c tem = new CSS_WS_Warranty_SRT__c(
            CSS_WS_Description__c = 'Example',
            CSS_WS_SRT__c = '01-03H',
            CSS_WS_Access_Code__c = 'P28',
            CSS_WS_WarrantyID__c = Claim.Id,
            CSS_WS_Extended_Hours__c = 1,
            CSS_WS_Actual_Hours__c = 1,
            CSS_WS_Amount__c = 1,
            CSS_WS_Quantity__c = 1);
        insert tem;
        
        Blob key = Blob.valueOf('12345678901234567890123456789012');
        CSS_Integration_Details__c MxTestConnection1 = new CSS_Integration_Details__c(
            Name = 'MxSRTData',
            ApplicationName__c = 'MxSRTData',
            End_Point__c = 'https://api-ue-devnf-aw-ex.cummins.com/api/core-security-api/v1/auth/token/MxSRTData',
            IsActive__c = True,
            Method_Type__c = 'GET',
            AuthEnv__c = 'MxAuthEngi',
            Key__c =  EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('https://api-ue-devnf-aw-ex.cummins.com/cmi-engine'))),
            Passcode__c = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('~6_5~e.~8D19I0Sw7YSNtq2kiAgK5bA.w3'))),
            Username__c = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('400529c8-31be-4749-acfe-7549baa2fcb2')))
        );        
        insert MxTestConnection1; 
        
        CSS_Integration_Details__c MxTestConnection2 = new CSS_Integration_Details__c(
            Name = 'MxSRTOver2',
            ApplicationName__c = 'MxSRTOver2',
            End_Point__c = 'https://api-ue-devnf-aw-ex.cummins.com/api/core-security-api/v1/auth/token/MxSRTOver2',
            IsActive__c = True,
            Method_Type__c = 'POST',
            AuthEnv__c = 'MxAuthEngi',
            Key__c =  EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('https://api-ue-devnf-aw-ex.cummins.com/cmi-engine'))),
            Passcode__c = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('~6_5~e.~8D19I0Sw7YSNtq2kiAgK5bA.w3'))),
            Username__c = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('400529c8-31be-4749-acfe-7549baa2fcb2')))
        );        
        insert MxTestConnection2;
        
        CSS_Integration_Details__c MxTestConnection3 = new CSS_Integration_Details__c(
            Name = 'MxSRTVal',
            ApplicationName__c = 'MxSRTVal',
            End_Point__c = 'https://api-ue-devnf-aw-ex.cummins.com/api/core-security-api/v1/auth/token/MxSRTVal',
            IsActive__c = True,
            Method_Type__c = 'POST',
            AuthEnv__c = 'MxAuthClai',
            Key__c =  EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('https://api-ue-devnf-aw-ex.cummins.com/cmi-engine'))),
            Passcode__c = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('~6_5~e.~8D19I0Sw7YSNtq2kiAgK5bA.w3'))),
            Username__c = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('400529c8-31be-4749-acfe-7549baa2fcb2')))
        );        
        insert MxTestConnection3; 
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new CSS_WS_WebServicesMock());
        ApexPages.StandardController standardController = new ApexPages.StandardController(Claim);
        CSS_WS_SRTGridController controller = new CSS_WS_SRTGridController(standardController);        
        Test.setCurrentPage(pageRef);
        controller.warrantyId = Claim.Id;
        controller.getSRTOptions2 = null;
        controller.SRTData = null;
        controller.SRTOverlap = null;
        controller.TableTotals = null;
        controller.selectedSRT = null;
        controller.LoadSRTs = null;
        controller.disableRows = null;
        controller.GetSRTOverlapInfo();
        Test.stopTest();
    }
    
    Public Static TestMethod Void testingMethodGSQSRTs(){
        PageReference pageRef = Page.CSS_WS_ClaimFormat;
        CSS_WS_Warranty__c Claim = new CSS_WS_Warranty__c(
            CSS_WS_Campaigns_TRPs__c = 'XF123',
            CSS_WS_Engine_Serial_Number__c = '11111111',
            CSS_WS_Engine_Family_Code__c = '46',
            CSS_WS_Service_Provider_Dealer__c = '55893',
            CSS_WS_Failure_Date_Time__c = Date.today(),
            CSS_WS_Failure_Point_Quantity__c = '2',
            CSS_WS_Failure_Measure__c = 'Km',
            CSS_WS_Warranty_Start_Date__c = Date.today(),
            CSS_WS_Warranty_Type__c = 'Parte',
            CSS_WS_Claim_Type__c = 'Herramienta de Servicio',
            CSS_WS_Policy_Flag__c = 'Policy',
            CSS_WS_Pay_Code__c = 'R',
            CSS_WS_Account_Code__c = '65',
            CSS_WS_Account_Code_Type__c = '01',
            CSS_WS_Product_Application_Code__c = '02',
            CSS_WS_Warranty_Subtype__c = null,
            CSS_WS_Multi_ESN__c = true,
            CSS_WS_Service_Provider_DR__c = '55893',
            CSS_WS_Total_Labor__c = 1234.00,
            CSS_Authorization_Number__c = '982',
            CSS_WS_Approval_Code__c = '1234',
            CSS_WS_Towing_Amount__c = 67.55,
            CSS_WS_Covered_OC_Amount__c = 99999,
            CSS_WS_Covered_Labor_Hours__c = 9999,
            CSS_WS_Service_Model__c = '56',
            CSS_WS_Equipment_Code__c = 'EQ7742',
            CSS_WS_GSQ_SRT_Flag__c = '0 - Not consumed',
            CSS_WS_Labor_Rate__c = '31',
            CSS_WS_In_shop_Labor_Rate__c = '31',
            CSS_WS_Access_Code__c = '98');
        insert Claim;
        
        CSS_WS_Failure__c fail =  new CSS_WS_Failure__c(
            CSS_WS_EngineSystemCode__c = 'XO', 
            CSS_WS_ComponentCode__c = 'LO', 
            CSS_WS_FailureModeCode__c = 'CA',
            CSS_WS_Failure_ID__c = 'F12000000', 
            CSS_WS_Warranty__c = Claim.Id);
        insert fail;
        
        Account SPDLTest = new Account(
            IAM_Service_Provider_Code__c = '55893',
            CSS_DBCode__c = '55893',
            Type = 'Dealer Account',
            Name = 'DUMMY DEALER',
            CMI_Account_Status__c = 'Active',
            BillingCountry = 'MEXICO');
        insert SPDLTest;  
        
        Blob key = Blob.valueOf('12345678901234567890123456789012');
        CSS_Integration_Details__c MxTestConnection1 = new CSS_Integration_Details__c(
            Name = 'MxSRTData',
            ApplicationName__c = 'MxSRTData',
            End_Point__c = 'https://api-ue-devnf-aw-ex.cummins.com/api/core-security-api/v1/auth/token/MxSRTData',
            IsActive__c = True,
            Method_Type__c = 'GET',
            AuthEnv__c = 'MxAuthEngi',
            Key__c =  EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('https://api-ue-devnf-aw-ex.cummins.com/cmi-engine'))),
            Passcode__c = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('~6_5~e.~8D19I0Sw7YSNtq2kiAgK5bA.w3'))),
            Username__c = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('400529c8-31be-4749-acfe-7549baa2fcb2')))
        );        
        insert MxTestConnection1; 
        
        CSS_Integration_Details__c MxTestConnection2 = new CSS_Integration_Details__c(
            Name = 'MxSRTOver2',
            ApplicationName__c = 'MxSRTOver2',
            End_Point__c = 'https://api-ue-devnf-aw-ex.cummins.com/api/core-security-api/v1/auth/token/MxSRTOver2',
            IsActive__c = True,
            Method_Type__c = 'POST',
            AuthEnv__c = 'MxAuthEngi',
            Key__c =  EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('https://api-ue-devnf-aw-ex.cummins.com/cmi-engine'))),
            Passcode__c = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('~6_5~e.~8D19I0Sw7YSNtq2kiAgK5bA.w3'))),
            Username__c = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('400529c8-31be-4749-acfe-7549baa2fcb2')))
        );        
        insert MxTestConnection2;
        
        CSS_Integration_Details__c MxTestConnection3 = new CSS_Integration_Details__c(
            Name = 'MxSRTVal',
            ApplicationName__c = 'MxSRTVal',
            End_Point__c = 'https://api-ue-devnf-aw-ex.cummins.com/api/core-security-api/v1/auth/token/MxSRTVal',
            IsActive__c = True,
            Method_Type__c = 'POST',
            AuthEnv__c = 'MxAuthClai',
            Key__c =  EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('https://api-ue-devnf-aw-ex.cummins.com/cmi-engine'))),
            Passcode__c = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('~6_5~e.~8D19I0Sw7YSNtq2kiAgK5bA.w3'))),
            Username__c = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('400529c8-31be-4749-acfe-7549baa2fcb2')))
        );        
        insert MxTestConnection3;    
        
        CSS_Integration_Details__c MxTestConnection4 = new CSS_Integration_Details__c(
            Name = 'MxGsqSrt',
            ApplicationName__c = 'MxGsqSrt',
            End_Point__c = 'https://api-ue-devnf-aw-ex.cummins.com/api/core-security-api/v1/auth/token/MxGsqSrt',
            IsActive__c = True,
            Method_Type__c = 'POST',
            AuthEnv__c = 'MxAuthEngi',
            Key__c =  EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('https://api-ue-devnf-aw-ex.cummins.com/cmi-engine'))),
            Passcode__c = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('~6_5~e.~8D19I0Sw7YSNtq2kiAgK5bA.w3'))),
            Username__c = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('400529c8-31be-4749-acfe-7549baa2fcb2')))
        );        
        insert MxTestConnection4;  
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new CSS_WS_WebServicesMock());
        ApexPages.StandardController standardController = new ApexPages.StandardController(Claim);
        CSS_WS_SRTGridController controller = new CSS_WS_SRTGridController(standardController);       
        Test.setCurrentPage(pageRef);
        controller.GSQSRTData();
        controller.SaveGSQSRTData();    
        controller.LoadGSQSRTEdition();    
        controller.SRTToAdd = 0;        
        controller.AddGSQSRT();  
        ///controller.CheckSelected(); 
        controller.enableDisabledSelectAll();
        controller.SelectAll = true;
        controller.AddAllSelectedClaims();
        Test.stopTest();
    }
}