@isTest
Public Class CSS_WS_DynamicFailureController_Test{
    
    Public Static testMethod Void testingMethods1(){
        PageReference pageRef = Page.CSS_WS_ClaimFormat;
        CSS_WS_Warranty__c Claim = new CSS_WS_Warranty__c(
            CSS_WS_Campaigns_TRPs__c = '',
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
            //CSS_Authorization_Number__c = 982,
            CSS_WS_Approval_Code__c = '1234',
            CSS_WS_GSQ_Failure_Flag__c = '0 - Not consumed',
            CSS_WS_Service_Model__c = 'ISBE CM2150',
            CSS_WS_Towing_Amount__c = 67.55);
        insert Claim;
        
        Account SPDLTest = new Account(
            IAM_Service_Provider_Code__c = '55893',
            CSS_DBCode__c = '55893',
            Type = 'Dealer Account',
            Name = 'DUMMY DEALER',
            CMI_Account_Status__c = 'Active',
            BillingCountry = 'MEXICO');
        insert SPDLTest;
        
        List<CSS_WS_Failure__c> Failures = new List<CSS_WS_Failure__c>();
        Failures.add(
            new CSS_WS_Failure__c(
                CSS_WS_ComponentCode__c = 'CV',
                CSS_WS_EngineSystem__c = 'FAN DRIVES',
                CSS_WS_EngineSystemCode__c = 'SG',
                CSS_WS_FailureModeCode__c = '22',
                CSS_WS_ComponentName__c = 'COVER',
                CSS_WS_FailureModeName__c = 'CODING ERROR',
                CSS_WS_Warranty__c = Claim.Id));
        Failures.add(
            new CSS_WS_Failure__c(
                CSS_WS_ComponentCode__c = 'FW',
                CSS_WS_EngineSystem__c = 'FLYWH/FLEX',
                CSS_WS_EngineSystemCode__c = 'SN',
                CSS_WS_FailureModeCode__c = '22',
                CSS_WS_ComponentName__c = 'ISOLATOR CAPSCREW',
                CSS_WS_FailureModeName__c = 'CODING ERROR',
                CSS_WS_Warranty__c = Claim.Id));
        insert Failures;
        
        List<CSS_WS_Failure_Master__c> FailuresMaster = new List<CSS_WS_Failure_Master__c>();
        FailuresMaster.add(
            new CSS_WS_Failure_Master__c(
                Engine_Family_Code__c = '46',
                Engine_Component_Code__c = 'CV',
                Engine_System_Code_Description__c = 'FAN DRIVES',
                Engine_System_Code__c = 'SG',
                Engine_Component_Code_Description__c = 'COVER',
                CSS_WS_Unique_Id__c = '46-SG-CV'));
        FailuresMaster.add(
            new CSS_WS_Failure_Master__c(
                Engine_Family_Code__c = '46',
                Engine_Component_Code__c = 'FW',
                Engine_System_Code_Description__c = 'FAN DRIVES',
                Engine_System_Code__c = 'SG',
                Engine_Component_Code_Description__c = 'COVER',
                CSS_WS_Unique_Id__c = '46-SG-FW'));
        FailuresMaster.add(
            new CSS_WS_Failure_Master__c(
                Engine_Family_Code__c = '46',
                Engine_Component_Code__c = 'QP',
                Engine_System_Code_Description__c = 'FAN DRIVES',
                Engine_System_Code__c = 'WE',
                Engine_Component_Code_Description__c = 'COVER',
                CSS_WS_Unique_Id__c = '46-WE-QP'));
        insert FailuresMaster;
        
        ApexPages.StandardController standardController = new ApexPages.StandardController(Claim);
        CSS_WS_DynamicFailureController controller = new CSS_WS_DynamicFailureController(standardController);
        
        Test.setCurrentPage(pageRef);
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new CSS_WS_WebServicesMock());
        controller.ClassIni();
        controller.CallWSToGetGSQFailure();
        controller.EngineSystemSelectListValue = 'WE&FAN DRIVES';
        controller.FailureModeSelectListValue = '0&CODING ERROR';
        controller.ComponentSelectListValue = 'QP&MOUNTING BRACKET';
        controller.AddNewFailure();
        controller.SetNameAndCodeOfFailure();
        controller.SetComponentList();
        controller.SaveFailures();
        controller.ValidateDuplicatedFailureCodes();
        controller.validateFailure();
        controller.CallWSToGetAccCoverage();
        System.debug('AccCoverageResponse: ' + JSON.serialize(controller.AccCoverageResponse));
        controller.UpdateClaimWithResponse();
        controller.FailureToDelete = 1;
        controller.DeleteFailure();
        Test.stopTest();
    }
    
    Public Static testMethod Void testingMethods2(){
        PageReference pageRef = Page.CSS_WS_ClaimFormat;
        CSS_WS_Warranty__c Claim = new CSS_WS_Warranty__c(
            CSS_WS_Campaigns_TRPs__c = null,
            CSS_WS_Engine_Serial_Number__c = '11111111',
            CSS_WS_Engine_Family_Code__c = '46',
            CSS_WS_Service_Provider_Dealer__c = '55893',
            CSS_WS_Failure_Date_Time__c = Date.today(),
            CSS_WS_Failure_Point_Quantity__c = '2',
            CSS_WS_Failure_Measure__c = 'Km',
            CSS_WS_Warranty_Start_Date__c = Date.today(),
            CSS_WS_Warranty_Type__c = 'Parte',
            CSS_WS_Claim_Type__c = 'Recon',
            CSS_WS_Policy_Flag__c = 'Policy WW',
            CSS_WS_Pay_Code__c = 'R',
            CSS_WS_Account_Code__c = '65',
            CSS_WS_Account_Code_Type__c = '01',
            CSS_WS_Product_Application_Code__c = '02',
            CSS_WS_Warranty_Subtype__c = null,
            CSS_WS_Multi_ESN__c = true,
            CSS_WS_Service_Provider_DR__c = '55893',
            CSS_WS_Total_Labor__c = 1234.00,
            CSS_WS_Approval_Code__c = '1234',
            CSS_WS_Towing_Amount__c = 67.55);
        insert Claim;
        
        Account SPDLTest = new Account(
            IAM_Service_Provider_Code__c = '55893',
            CSS_DBCode__c = '55893',
            Type = 'Distributor Account',
            Name = 'DUMMY DEALER',
            CMI_Account_Status__c = 'Active',
            BillingCountry = 'MEXICO');
        insert SPDLTest;
        
        List<CSS_WS_Failure__c> Failures = new List<CSS_WS_Failure__c>();
        Failures.add(
            new CSS_WS_Failure__c(
                CSS_WS_ComponentCode__c = 'CV',
                CSS_WS_EngineSystem__c = 'FAN DRIVES',
                CSS_WS_EngineSystemCode__c = 'SG',
                CSS_WS_FailureModeCode__c = '22',
                CSS_WS_ComponentName__c = 'COVER',
                CSS_WS_FailureModeName__c = 'CODING ERROR',
                CSS_WS_Warranty__c = Claim.Id));
        Failures.add(
            new CSS_WS_Failure__c(
                CSS_WS_ComponentCode__c = 'FW',
                CSS_WS_EngineSystem__c = 'FLYWH/FLEX',
                CSS_WS_EngineSystemCode__c = 'SN',
                CSS_WS_FailureModeCode__c = '22',
                CSS_WS_ComponentName__c = 'ISOLATOR CAPSCREW',
                CSS_WS_FailureModeName__c = 'CODING ERROR',
                CSS_WS_Warranty__c = Claim.Id));
        insert Failures;
        
        List<CSS_WS_Failure_Master__c> FailuresMaster = new List<CSS_WS_Failure_Master__c>();
        FailuresMaster.add(
            new CSS_WS_Failure_Master__c(
                Engine_Family_Code__c = '46',
                Engine_Component_Code__c = 'CV',
                Engine_System_Code_Description__c = 'FAN DRIVES',
                Engine_System_Code__c = 'SG',
                Engine_Component_Code_Description__c = 'COVER',
                CSS_WS_Unique_Id__c = '46-SG-CV'));
        FailuresMaster.add(
            new CSS_WS_Failure_Master__c(
                Engine_Family_Code__c = '46',
                Engine_Component_Code__c = 'FW',
                Engine_System_Code_Description__c = 'FAN DRIVES',
                Engine_System_Code__c = 'SG',
                Engine_Component_Code_Description__c = 'COVER',
                CSS_WS_Unique_Id__c = '46-SG-FW'));
        insert FailuresMaster;
        
         Blob key = Blob.valueOf('12345678901234567890123456789012');
        CSS_Integration_Details__c MxTestConnection1 = new CSS_Integration_Details__c(
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
            Name = 'MxFailVal',
            ApplicationName__c = 'MxFailVal',
            End_Point__c = 'https://api-ue-devnf-aw-ex.cummins.com/api/core-security-api/v1/auth/token/MxFailVal',
            IsActive__c = True,
            Method_Type__c = 'POST',
            AuthEnv__c = 'MxAuthClai',
            Key__c =  EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('https://api-ue-devnf-aw-ex.cummins.com/cmi-engine'))),
            Passcode__c = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('~6_5~e.~8D19I0Sw7YSNtq2kiAgK5bA.w3'))),
            Username__c = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('400529c8-31be-4749-acfe-7549baa2fcb2')))
        );        
        insert MxTestConnection3; 
        
        ApexPages.StandardController standardController = new ApexPages.StandardController(Claim);
        CSS_WS_DynamicFailureController controller = new CSS_WS_DynamicFailureController(standardController);
        Test.setCurrentPage(pageRef);
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new CSS_WS_WebServicesMock());
        controller.CallWSToGetAccCoverage();
        controller.FailureCallWSODM();
        controller.DisplayErrorHandler('Testing');
        Test.stopTest();
    }
    
    Public Static testMethod Void testingMethods3(){
        PageReference pageRef = Page.CSS_WS_ClaimFormat;
        CSS_WS_Warranty__c Claim = new CSS_WS_Warranty__c(
            CSS_WS_Campaigns_TRPs__c = null,
            CSS_WS_Engine_Serial_Number__c = '11111111',
            CSS_WS_Engine_Family_Code__c = '46',
            CSS_WS_Service_Provider_Dealer__c = '55893',
            CSS_WS_Failure_Date_Time__c = Date.today(),
            CSS_WS_Failure_Point_Quantity__c = '2',
            CSS_WS_Failure_Measure__c = 'Km',
            CSS_WS_Warranty_Start_Date__c = Date.today(),
            CSS_WS_Warranty_Type__c = 'Parte',
            CSS_WS_Claim_Type__c = 'Recon',
            CSS_WS_Policy_Flag__c = 'Policy WW',
            CSS_WS_Pay_Code__c = 'R',
            CSS_WS_Account_Code__c = '65',
            CSS_WS_Account_Code_Type__c = '01',
            CSS_WS_Product_Application_Code__c = '02',
            CSS_WS_Warranty_Subtype__c = null,
            CSS_WS_Multi_ESN__c = true,
            CSS_WS_Service_Provider_DR__c = '55893',
            CSS_WS_Total_Labor__c = 1234.00,
            CSS_WS_Approval_Code__c = '1234',
            CSS_WS_Towing_Amount__c = 67.55);
        insert Claim;
        
        Account SPDLTest = new Account(
            IAM_Service_Provider_Code__c = '55893',
            CSS_DBCode__c = '55893',
            Type = 'Dealer Account',
            Name = 'DUMMY DEALER',
            CMI_Account_Status__c = 'Active',
            BillingCountry = 'MEXICO');
        insert SPDLTest;
        
        List<CSS_WS_Failure_Master__c> FailuresMaster = new List<CSS_WS_Failure_Master__c>();
        FailuresMaster.add(
            new CSS_WS_Failure_Master__c(
                Engine_Family_Code__c = '46',
                Engine_Component_Code__c = 'CV',
                Engine_System_Code_Description__c = 'FAN DRIVES',
                Engine_System_Code__c = 'SG',
                Engine_Component_Code_Description__c = 'COVER',
                CSS_WS_Unique_Id__c = '46-SG-CV'));
        FailuresMaster.add(
            new CSS_WS_Failure_Master__c(
                Engine_Family_Code__c = '46',
                Engine_Component_Code__c = 'FW',
                Engine_System_Code_Description__c = 'FAN DRIVES',
                Engine_System_Code__c = 'SG',
                Engine_Component_Code_Description__c = 'COVER',
                CSS_WS_Unique_Id__c = '46-SG-FW'));
        insert FailuresMaster;
        
        Blob key = Blob.valueOf('12345678901234567890123456789012');
        CSS_Integration_Details__c MxTestConnection1 = new CSS_Integration_Details__c(
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
        
        ApexPages.StandardController standardController = new ApexPages.StandardController(Claim);
        CSS_WS_DynamicFailureController controller = new CSS_WS_DynamicFailureController(standardController);
        
        Test.setCurrentPage(pageRef);
        Test.startTest();
        controller.EngineSystemSelectListValue = '';
        controller.FailureModeSelectListValue = '';
        controller.ComponentSelectListValue = '';
        controller.SetNameAndCodeOfFailure();
        List<selectOption> GetFailureModeList = controller.GetFailureModeList;
        List<selectOption> GetFailureList = controller.GetFailureList;
        Test.setMock(HttpCalloutMock.class, new CSS_WS_WebServicesMock());
        controller.CallWSToGetAccCoverage();
        controller.FailuresWithError = 0;
        controller.UpdateClaimWithResponse();
        Test.stopTest();
    }
    
    Public Static testMethod Void testingMethods4(){
        PageReference pageRef = Page.CSS_WS_ClaimFormat;
        // Create a claim to do the test case
        CSS_WS_Warranty__c Claim = new CSS_WS_Warranty__c(
            CSS_WS_Campaigns_TRPs__c = '',
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
            CSS_WS_Account_Code__c = '35',
            CSS_WS_Account_Code_Type__c = '01',
            CSS_WS_Product_Application_Code__c = '02',
            CSS_WS_Warranty_Subtype__c = null,
            CSS_WS_Multi_ESN__c = true,
            CSS_WS_Service_Provider_DR__c = '55893',
            CSS_WS_Total_Labor__c = 1234.00,
            //CSS_Authorization_Number__c = 982,
            CSS_WS_Approval_Code__c = '1234',
            CSS_WS_GSQ_Failure_Flag__c = '0 - Not consumed',
            CSS_WS_Service_Model__c = 'ISBE CM2150',
            CSS_WS_Towing_Amount__c = 67.55);
        insert Claim;
        
        Account SPDLTest = new Account(
            IAM_Service_Provider_Code__c = '55893',
            CSS_DBCode__c = '55893',
            Type = 'Distributor Account',
            Name = 'DUMMY DEALER',
            CMI_Account_Status__c = 'Active',
            BillingCountry = 'MEXICO');
        insert SPDLTest;
        
        List<CSS_WS_Failure_Master__c> FailuresMaster = new List<CSS_WS_Failure_Master__c>();
        FailuresMaster.add(
            new CSS_WS_Failure_Master__c(
                Engine_Family_Code__c = '46',
                Engine_Component_Code__c = 'CV',
                Engine_System_Code_Description__c = 'FAN DRIVES',
                Engine_System_Code__c = 'SG',
                Engine_Component_Code_Description__c = 'COVER',
                CSS_WS_Unique_Id__c = '46-SG-CV'));
        FailuresMaster.add(
            new CSS_WS_Failure_Master__c(
                Engine_Family_Code__c = '46',
                Engine_Component_Code__c = 'FW',
                Engine_System_Code_Description__c = 'FAN DRIVES',
                Engine_System_Code__c = 'SG',
                Engine_Component_Code_Description__c = 'COVER',
                CSS_WS_Unique_Id__c = '46-SG-FW'));
        FailuresMaster.add(
            new CSS_WS_Failure_Master__c(
                Engine_Family_Code__c = '46',
                Engine_Component_Code__c = 'QP',
                Engine_System_Code_Description__c = 'FAN DRIVES',
                Engine_System_Code__c = 'WE',
                Engine_Component_Code_Description__c = 'COVER',
                CSS_WS_Unique_Id__c = '46-WE-QP'));
        insert FailuresMaster;
        
        Blob key = Blob.valueOf('12345678901234567890123456789012');
        CSS_Integration_Details__c MxTestConnection1 = new CSS_Integration_Details__c(
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
            Name = 'MxFailVal',
            ApplicationName__c = 'MxFailVal',
            End_Point__c = 'https://api-ue-devnf-aw-ex.cummins.com/api/core-security-api/v1/auth/token/MxFailVal',
            IsActive__c = True,
            Method_Type__c = 'POST',
            AuthEnv__c = 'MxAuthClai',
            Key__c =  EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('https://api-ue-devnf-aw-ex.cummins.com/cmi-engine'))),
            Passcode__c = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('~6_5~e.~8D19I0Sw7YSNtq2kiAgK5bA.w3'))),
            Username__c = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('400529c8-31be-4749-acfe-7549baa2fcb2')))
        );        
        insert MxTestConnection3; 
        
         CSS_Integration_Details__c MxTestConnection4 = new CSS_Integration_Details__c(
            Name = 'MxGsqFai',
            ApplicationName__c = 'MxGsqFai',
            End_Point__c = 'https://api-ue-devnf-aw-ex.cummins.com/api/core-security-api/v1/auth/token/MxGsqFai',
            IsActive__c = True,
            Method_Type__c = 'GET',
            AuthEnv__c = 'MxAuthEngi',
            Key__c =  EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('https://api-ue-devnf-aw-ex.cummins.com/cmi-engine'))),
            Passcode__c = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('~6_5~e.~8D19I0Sw7YSNtq2kiAgK5bA.w3'))),
            Username__c = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('400529c8-31be-4749-acfe-7549baa2fcb2')))
        );        
        insert MxTestConnection4; 
        
        ApexPages.StandardController standardController = new ApexPages.StandardController(Claim);
        CSS_WS_DynamicFailureController controller = new CSS_WS_DynamicFailureController(standardController);
        
        Test.setCurrentPage(pageRef);
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new CSS_WS_WebServicesMock());
        controller.ClassIni();
        controller.CallWSToGetGSQFailure();
        List<selectOption> GetFailureModeList = controller.GetFailureModeList;
        List<selectOption> GetFailureList = controller.GetFailureList;
        controller.EngineSystemSelectListValue = 'WE&FAN DRIVES';
        controller.FailureModeSelectListValue = '0&CODING ERROR';
        controller.ComponentSelectListValue = 'QP&MOUNTING BRACKET';
        controller.SetNameAndCodeOfFailure();
        controller.CallWSToGetAccCoverage();
        System.debug('AccCoverageResponse: ' + JSON.serialize(controller.AccCoverageResponse));
        controller.UpdateClaimWithResponse();
        controller.FailureCallWSODM();
        Test.stopTest();
    }
    
    Public Static testMethod Void testAll(){
        PageReference pageRef = Page.CSS_WS_ClaimFormat;
        CSS_WS_Warranty__c Claim = new CSS_WS_Warranty__c(
            CSS_WS_Campaigns_TRPs__c = '',
            CSS_WS_Engine_Serial_Number__c = '11111111',
            CSS_WS_Engine_Family_Code__c = '46',
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
            CSS_WS_Approval_Code__c = '1234',
            CSS_WS_Towing_Amount__c = 67.55,
            CSS_WS_Service_Provider_DR__c = '863',
            CSS_WS_Service_Provider_Dealer__c = '54871');
        insert Claim;
        
        List<CSS_WS_Failure__c> Failures = new List<CSS_WS_Failure__c>();
        Failures.add(
            new CSS_WS_Failure__c(
                CSS_WS_ComponentCode__c = 'CV',
                CSS_WS_EngineSystem__c = 'FAN DRIVES',
                CSS_WS_EngineSystemCode__c = 'SG',
                CSS_WS_FailureModeCode__c = '22',
                CSS_WS_ComponentName__c = 'COVER',
                CSS_WS_FailureModeName__c = 'CODING ERROR',
                CSS_WS_Warranty__c = Claim.Id));
        Failures.add(
            new CSS_WS_Failure__c(
                CSS_WS_ComponentCode__c = 'FW',
                CSS_WS_EngineSystem__c = 'FLYWH/FLEX',
                CSS_WS_EngineSystemCode__c = 'SN',
                CSS_WS_FailureModeCode__c = '22',
                CSS_WS_ComponentName__c = 'ISOLATOR CAPSCREW',
                CSS_WS_FailureModeName__c = 'CODING ERROR',
                CSS_WS_Warranty__c = Claim.Id));
        insert Failures;
        
        List<CSS_WS_Failure_Master__c> FailuresMaster = new List<CSS_WS_Failure_Master__c>();
        FailuresMaster.add(
            new CSS_WS_Failure_Master__c(
                Engine_Family_Code__c = '46',
                Engine_Component_Code__c = 'CV',
                Engine_System_Code_Description__c = 'FAN DRIVES',
                Engine_System_Code__c = 'SG',
                Engine_Component_Code_Description__c = 'COVER',
                CSS_WS_Unique_Id__c = '46-SG-CV'));
        FailuresMaster.add(
            new CSS_WS_Failure_Master__c(
                Engine_Family_Code__c = '46',
                Engine_Component_Code__c = 'FW',
                Engine_System_Code_Description__c = 'FAN DRIVES',
                Engine_System_Code__c = 'SG',
                Engine_Component_Code_Description__c = 'COVER',
                CSS_WS_Unique_Id__c = '46-SG-FW'));
        insert FailuresMaster;
        
        ApexPages.StandardController standardController = new ApexPages.StandardController(Claim);
        CSS_WS_DynamicFailureController controller = new CSS_WS_DynamicFailureController(standardController);
         
        controller.FailuresWithError = 0;
        Test.setCurrentPage(pageRef);        
        controller.UpdateClaimWithResponse();
        controller.FailureCallWSODM();
    }
    
}