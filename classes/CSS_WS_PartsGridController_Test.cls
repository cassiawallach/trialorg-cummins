@IsTest
Public Class CSS_WS_PartsGridController_Test{
    
    Public Static TestMethod Void testNormalPart(){
        PageReference pageRef = Page.CSS_WS_ClaimFormat;
        Account SPDLTest = new Account(
            IAM_Service_Provider_Code__c = '12345',
            CSS_DBCode__c = '54734',
            Type = 'Dealer Account',
            Name = 'DUMMY DEALER',
            CMI_Account_Status__c = 'Active',
            BillingCountry = 'Mexico');
        insert SPDLTest;
        
        CSS_WS_Warranty__c claim = new CSS_WS_Warranty__c(
            CSS_WS_Campaigns_TRPs__c = 'XF123',
            CSS_WS_Engine_Serial_Number__c = '11111111',
            CSS_WS_Engine_Family_Code__c = '46',
            CSS_WS_Service_Provider_Dealer__c = '12345',
            CSS_WS_Service_Provider_DR__c = '54734',
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
            CSS_WS_Covered_OC_Amount__c = 99999);
        insert claim;
        
        CSS_WS_Failure__c fail =  new CSS_WS_Failure__c(
            CSS_WS_EngineSystemCode__c = 'XO', 
            CSS_WS_ComponentCode__c = 'LO', 
            CSS_WS_FailureModeCode__c = 'CA', 
            CSS_WS_Warranty__c = claim.Id);
        insert fail;
        
        ApexPages.StandardController standardController = new ApexPages.StandardController(claim);
        CSS_WS_PartsGridController controller = new CSS_WS_PartsGridController(standardController);
        
        List<CSS_WS_Warranty_Parts__c> parts = new List <CSS_WS_Warranty_Parts__c>();
        parts.add(new CSS_WS_Warranty_Parts__c(
            CSS_WS_PartNumber__c = '528408300',
            CSS_WS_Quantity__c = 2,
            CSS_WS_ReplacementReasonPicklist__c = 'Root Cause',
            CSS_WS_Superseaded__c = 'sas',
            CSS_WS_PartService__c = 'Y',
            CSS_WS_Kit__c = true,
            CSS_WS_Description__c = 'slfjslj',
            CSS_WS_Unit_Part_Price__c = 18.8,
            CSS_WS_SubTotal__c = 150.50,
            CSS_WS_Part_Return_Flag__c = true,
            CSS_WS_Shipping_Company__c = 'XBU en SLP',
            CSS_WS_Tracking_Guide_Code__c = 'N/A',
            CSS_WS_Waiver_Process__c = '',
            CSS_WS_WarrantyID__c = claim.Id,
            CSS_WS_priceBook__c = null));
        
        parts.add(new CSS_WS_Warranty_Parts__c(
            CSS_WS_PartNumber__c = '123132',
            CSS_WS_Quantity__c = 2,
            CSS_WS_ReplacementReasonPicklist__c = 'Root Cause',
            CSS_WS_Superseaded__c = 'sas',
            CSS_WS_PartService__c = 'Y',
            CSS_WS_Kit__c = true,
            CSS_WS_Description__c = 'slfjslj',
            CSS_WS_Unit_Part_Price__c = 18.8,
            CSS_WS_SubTotal__c = 150.50,
            CSS_WS_WarrantyID__c = claim.Id,
            CSS_WS_priceBook__c = null));       
        insert parts;

        Account DealerTest = new Account(
            IAM_Service_Provider_Code__c = '23456',
            CSS_DBCode__c = '54734',
            Type = 'Dealer Account',
            Name = 'Dummy Dealer',
            CMI_Account_Status__c = 'Active',
            BillingCountry = 'Mexico');
        insert DealerTest;
        
        CSS_WS_Parts_In_Promotion__c partP = new CSS_WS_Parts_In_Promotion__c(
            Name = '123132',
            Long_Part_Number__c = '12312300',
            Description__c = 'testPart', 
            DLR_Price__c = 10, 
            DR_Price__c = 10);
        insert partP;
        
        Blob key = Blob.valueOf('12345678901234567890123456789012');
        CSS_Integration_Details__c MxTestConnection1 = new CSS_Integration_Details__c(
            Name = 'MxPrtsData',
            ApplicationName__c = 'MxPrtsData',
            End_Point__c = 'https://api-ue-devnf-aw-ex.cummins.com/api/core-security-api/v1/auth/token/MxPrtsData',
            IsActive__c = True,
            Method_Type__c = 'GET',
            AuthEnv__c = 'MxAuthEngi',
            Key__c =  EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('https://api-ue-devnf-aw-ex.cummins.com/cmi-engine'))),
            Passcode__c = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('~6_5~e.~8D19I0Sw7YSNtq2kiAgK5bA.w3'))),
            Username__c = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('400529c8-31be-4749-acfe-7549baa2fcb2')))
        );        
        insert MxTestConnection1; 
        
        CSS_Integration_Details__c MxTestConnection2 = new CSS_Integration_Details__c(
            Name = 'MxPrtsVal',
            ApplicationName__c = 'MxPrtsVal',
            End_Point__c = 'https://api-ue-devnf-aw-ex.cummins.com/api/core-security-api/v1/auth/token/MxPrtsVal',
            IsActive__c = True,
            Method_Type__c = 'POST',
            AuthEnv__c = 'MxAuthClai',
            Key__c =  EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('https://api-ue-devnf-aw-ex.cummins.com/cmi-engine'))),
            Passcode__c = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('~6_5~e.~8D19I0Sw7YSNtq2kiAgK5bA.w3'))),
            Username__c = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('400529c8-31be-4749-acfe-7549baa2fcb2')))
        );        
        insert MxTestConnection2;
        
        CSS_Integration_Details__c MxTestConnection3 = new CSS_Integration_Details__c(
            Name = 'MxPartRet',
            ApplicationName__c = 'MxPartRet',
            End_Point__c = 'https://api-ue-devnf-aw-ex.cummins.com/api/core-security-api/v1/auth/token/MxPartRet',
            IsActive__c = True,
            Method_Type__c = 'POST',
            AuthEnv__c = 'MxAuthEngi',
            Key__c =  EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('https://api-ue-devnf-aw-ex.cummins.com/cmi-engine'))),
            Passcode__c = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('~6_5~e.~8D19I0Sw7YSNtq2kiAgK5bA.w3'))),
            Username__c = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('400529c8-31be-4749-acfe-7549baa2fcb2')))
        );        
        insert MxTestConnection3; 
        
        Test.startTest();
        controller.executeMakePartList();
        controller.PartList.add(new CSS_WS_PartsGridController.CreateNewPart(1, '123132', 12, 'ROOT CAUSE', '23424', 'Y', true, 'Lorem', 112.12, 121.12, claim.Id, 'PRICE BOOK', 
                                                                             true, true, 12.4, 12.4, '528408300', true, 'test_123', 'test_123', 'test_123', 'test_123', 'test_123', 'test_123'));        
        controller.PartToUpdate = 1;
        controller.GetPartsInfo();
        controller.PartList.add(new CSS_WS_PartsGridController.CreateNewPart(1, '123132', 12, 'ROOT CAUSE', '23424', 'Y', true, 'Lorem', 112.12, 121.12, claim.Id, 'PRICE BOOK', 
                                                                             true, true, 12.4, 12.4, '1234123000', true, 'test_123', 'test_123', 'test_123', 'test_123', 'test_123', 'test_123'));
        controller.PartToUpdate = 1;
        Test.setMock(HttpCalloutMock.class, new CSS_WS_WebServicesMock());
        controller.GetPartsInfo();
        controller.PartToFind = 1;
        controller.getERPFlag();
        controller.SPPreferencesDlr = DealerTest;
        controller.SPPreferencesDist = DealerTest;
        controller.getERPFlag();
        controller.GetPartsInfo();
        controller.executeMakePartList();
        controller.makePartList(parts);
        parts[0].CSS_WS_priceBook__c = '1231_MOMO';
        parts[0].CSS_WS_PartNumber__c = '528408300';
        parts[0].CSS_WS_Long_Part_Number_del__c = '528408300';
        parts[0].CSS_WS_ReplacementReasonPicklist__c = 'Root Cause';
        controller.getERPFlag();
        controller.makePartList(parts);
        controller.computeSubTotal();
        controller.SumPartsAmount();
        controller.addRow();
        parts[0].CSS_WS_ReplacementReasonPicklist__c = 'Progressive Damage';
        controller.getERPFlag();
        controller.DeletePart();
        controller.setPriceValues(controller.PartList[0].Part.CSS_WS_PartNumber__c, '2323.2');
        controller.SPPreferencesDlr.BillingCountry = 'Mexico';
        controller.SPPreferencesDist.BillingCountry = 'Mexico';
        claim.CSS_WS_Pay_Code__c = 'S';
        claim.CSS_WS_Pay_Code__c = 'C';
        claim.CSS_WS_Account_Code__c = '35';
        claim.CSS_WS_Pay_Code__c = 'R';
        claim.CSS_WS_Engine_Serial_Number__c = '10000000';
        controller.EmptyValues(new CSS_WS_Warranty_Parts__c());
        controller.UpdateMap(new CSS_WS_Warranty_Parts__c(), 1);
        controller.DisplayErrorHandler('Error!! D:');
        controller.SumPartsAmount();
        controller.CheckRepeatedPart(new CSS_WS_Warranty_Parts__c (), 1);
        controller.GetODMPartsInfo(claim.CSS_WS_Service_Provider_Dr__c, DealerTest);
        controller.SavePartsGrids();
        controller.getSavedPartsList('123');
        controller.getShippingCompanyList();
        controller.getWaiverProcessList();
        controller.ValidateShippingCompany();
        controller.AddNewPart();
        Test.stopTest();
    }
    
    Public Static TestMethod Void testPartsNoWarranty(){ 
        PageReference pageRef = Page.CSS_WS_ClaimFormat;
        Account SPDLTest = new Account(
            IAM_Service_Provider_Code__c = '12345',
            CSS_DBCode__c = '54734',
            Type = 'Dealer Account',
            Name = 'DUMMY DEALER',
            CMI_Account_Status__c = 'Active',
            BillingCountry = 'Mexico');
        insert SPDLTest;
        
        CSS_WS_Warranty__c claim = new CSS_WS_Warranty__c(
            CSS_WS_Campaigns_TRPs__c = 'XF123',
            CSS_WS_Engine_Serial_Number__c = '11111111',
            CSS_WS_Engine_Family_Code__c = '46',
            CSS_WS_Service_Provider_Dealer__c = '12345',
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
            CSS_WS_Service_Provider_DR__c = '54734',
            CSS_WS_Total_Labor__c = 1234.00,
            CSS_Authorization_Number__c = '982',
            CSS_WS_Approval_Code__c = '1234',
            CSS_WS_Towing_Amount__c = 67.55,
            CSS_WS_Covered_OC_Amount__c = 99999);
        insert claim;
        
        ApexPages.StandardController standardController = new ApexPages.StandardController(claim);
        CSS_WS_PartsGridController controller = new CSS_WS_PartsGridController(standardController);
        List<CSS_WS_Warranty_Parts__c> parts = new List <CSS_WS_Warranty_Parts__c>();
        
        parts = [SELECT CSS_WS_PartNumber__c, CSS_WS_Quantity__c, CSS_WS_ReplacementReasonPicklist__c, CSS_WS_Superseaded__c,
            CSS_WS_PartService__c, CSS_WS_Kit__c, CSS_WS_Description__c, CSS_WS_Unit_Part_Price__c, CSS_WS_SubTotal__c, 
            CSS_WS_WarrantyID__c FROM CSS_WS_Warranty_Parts__c WHERE CSS_WS_PartNumber__c = '' LIMIT 10];
        
        CSS_WS_Warranty_Parts__c part = new CSS_WS_Warranty_Parts__c(
            CSS_WS_PartNumber__c = '528408300',
            CSS_WS_Quantity__c = 2,
            CSS_WS_ReplacementReasonPicklist__c = 'Root Cause',
            CSS_WS_Superseaded__c = 'sas',
            CSS_WS_PartService__c = 'Y',
            CSS_WS_Kit__c = true,
            CSS_WS_Description__c = 'slfjslj',
            CSS_WS_Unit_Part_Price__c = 18.8,
            CSS_WS_SubTotal__c = 150.50,
            CSS_WS_WarrantyID__c = claim.Id);
        insert part;
        
        Account DealerTest = new Account(
            IAM_Service_Provider_Code__c = '23456',
            CSS_DBCode__c = '54734',
            Type = 'Dealer Account',
            Name = 'Dummy Dealer',
            CMI_Account_Status__c = 'Active',
            BillingCountry = 'Mexico');
        insert DealerTest;
        
        Blob key = Blob.valueOf('12345678901234567890123456789012');
        CSS_Integration_Details__c MxTestConnection1 = new CSS_Integration_Details__c(
            Name = 'MxPrtsData',
            ApplicationName__c = 'MxPrtsData',
            End_Point__c = 'https://api-ue-devnf-aw-ex.cummins.com/api/core-security-api/v1/auth/token/MxPrtsData',
            IsActive__c = True,
            Method_Type__c = 'GET',
            AuthEnv__c = 'MxAuthEngi',
            Key__c =  EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('https://api-ue-devnf-aw-ex.cummins.com/cmi-engine'))),
            Passcode__c = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('~6_5~e.~8D19I0Sw7YSNtq2kiAgK5bA.w3'))),
            Username__c = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('400529c8-31be-4749-acfe-7549baa2fcb2')))
        );        
        insert MxTestConnection1; 
        
        CSS_Integration_Details__c MxTestConnection2 = new CSS_Integration_Details__c(
            Name = 'MxPrtsVal',
            ApplicationName__c = 'MxPrtsVal',
            End_Point__c = 'https://api-ue-devnf-aw-ex.cummins.com/api/core-security-api/v1/auth/token/MxPrtsVal',
            IsActive__c = True,
            Method_Type__c = 'POST',
            AuthEnv__c = 'MxAuthClai',
            Key__c =  EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('https://api-ue-devnf-aw-ex.cummins.com/cmi-engine'))),
            Passcode__c = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('~6_5~e.~8D19I0Sw7YSNtq2kiAgK5bA.w3'))),
            Username__c = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('400529c8-31be-4749-acfe-7549baa2fcb2')))
        );        
        insert MxTestConnection2;
        
        CSS_Integration_Details__c MxTestConnection3 = new CSS_Integration_Details__c(
            Name = 'MxPartRet',
            ApplicationName__c = 'MxPartRet',
            End_Point__c = 'https://api-ue-devnf-aw-ex.cummins.com/api/core-security-api/v1/auth/token/MxPartRet',
            IsActive__c = True,
            Method_Type__c = 'POST',
            AuthEnv__c = 'MxAuthEngi',
            Key__c =  EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('https://api-ue-devnf-aw-ex.cummins.com/cmi-engine'))),
            Passcode__c = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('~6_5~e.~8D19I0Sw7YSNtq2kiAgK5bA.w3'))),
            Username__c = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('400529c8-31be-4749-acfe-7549baa2fcb2')))
        );        
        insert MxTestConnection3;
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new CSS_WS_WebServicesMock());
        controller.getPartsInfo();
        controller.makePartList(parts);
        controller.computeSubTotal();
        controller.SumPartsAmount();
        controller.addRow();
        controller.DeletePart();
        controller.EmptyValues(part);
        controller.UpdateMap(part, 1);
        controller.DisplayErrorHandler('Error!! D:');
        controller.SumPartsAmount();
        controller.CheckRepeatedPart(part, 1);
        controller.GetODMPartsInfo(claim.CSS_WS_Service_Provider_Dr__c, DealerTest);
        controller.SavePartsGrids();
        controller.getSavedPartsList('123');
        controller.AddNewPart();
        controller.PartToDelete = 1;
        controller.DeletePart();
        Test.stopTest();
    }
    
    Public Static TestMethod Void partsPolicy(){
        PageReference pageRef = Page.CSS_WS_ClaimFormat;
        Account SPDLTest = new Account(
            IAM_Service_Provider_Code__c = '12345',
            CSS_DBCode__c = '54734',
            Type = 'Dealer Account',
            Name = 'DUMMY DEALER',
            CMI_Account_Status__c = 'Active',
            BillingCountry = 'Mexico');
        insert SPDLTest;
        
        CSS_WS_Warranty__c claim = new CSS_WS_Warranty__c(
            CSS_WS_Campaigns_TRPs__c = 'XF123',
            CSS_WS_Engine_Serial_Number__c = '11111111',
            CSS_WS_Engine_Family_Code__c = '46',
            CSS_WS_Service_Provider_Dealer__c = '12345',
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
            CSS_WS_Service_Provider_DR__c = '54734',
            CSS_WS_Total_Labor__c = 1234.00,
            CSS_Authorization_Number__c = '982',
            CSS_WS_Approval_Code__c = '1234',
            CSS_WS_Towing_Amount__c = 67.55,
            CSS_WS_Covered_OC_Amount__c = 99999);
        insert claim;
        
        CSS_WS_Warranty_Parts__c part = new CSS_WS_Warranty_Parts__c(
            CSS_WS_PartNumber__c = '528408300',
            CSS_WS_Quantity__c = 2,
            CSS_WS_ReplacementReasonPicklist__c = 'Progressive Damage',
            CSS_WS_Long_Part_Number_del__c = '528408300',
            CSS_WS_Superseaded__c = 'sas',
            CSS_WS_PartService__c = 'Y',
            CSS_WS_Kit__c = true,
            CSS_WS_Description__c = 'slfjslj',
            CSS_WS_Unit_Part_Price__c = 18.8,
            CSS_WS_SubTotal__c = 150.50,
            CSS_WS_WarrantyID__c = claim.Id);
        insert part;
        
        Blob key = Blob.valueOf('12345678901234567890123456789012');
        CSS_Integration_Details__c MxTestConnection1 = new CSS_Integration_Details__c(
            Name = 'MxPrtsData',
            ApplicationName__c = 'MxPrtsData',
            End_Point__c = 'https://api-ue-devnf-aw-ex.cummins.com/api/core-security-api/v1/auth/token/MxPrtsData',
            IsActive__c = True,
            Method_Type__c = 'GET',
            AuthEnv__c = 'MxAuthEngi',
            Key__c =  EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('https://api-ue-devnf-aw-ex.cummins.com/cmi-engine'))),
            Passcode__c = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('~6_5~e.~8D19I0Sw7YSNtq2kiAgK5bA.w3'))),
            Username__c = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('400529c8-31be-4749-acfe-7549baa2fcb2')))
        );        
        insert MxTestConnection1; 
        
        CSS_Integration_Details__c MxTestConnection2 = new CSS_Integration_Details__c(
            Name = 'MxPrtsVal',
            ApplicationName__c = 'MxPrtsVal',
            End_Point__c = 'https://api-ue-devnf-aw-ex.cummins.com/api/core-security-api/v1/auth/token/MxPrtsVal',
            IsActive__c = True,
            Method_Type__c = 'POST',
            AuthEnv__c = 'MxAuthClai',
            Key__c =  EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('https://api-ue-devnf-aw-ex.cummins.com/cmi-engine'))),
            Passcode__c = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('~6_5~e.~8D19I0Sw7YSNtq2kiAgK5bA.w3'))),
            Username__c = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('400529c8-31be-4749-acfe-7549baa2fcb2')))
        );        
        insert MxTestConnection2;
        
        CSS_Integration_Details__c MxTestConnection3 = new CSS_Integration_Details__c(
            Name = 'MxPartRet',
            ApplicationName__c = 'MxPartRet',
            End_Point__c = 'https://api-ue-devnf-aw-ex.cummins.com/api/core-security-api/v1/auth/token/MxPartRet',
            IsActive__c = True,
            Method_Type__c = 'POST',
            AuthEnv__c = 'MxAuthEngi',
            Key__c =  EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('https://api-ue-devnf-aw-ex.cummins.com/cmi-engine'))),
            Passcode__c = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('~6_5~e.~8D19I0Sw7YSNtq2kiAgK5bA.w3'))),
            Username__c = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('400529c8-31be-4749-acfe-7549baa2fcb2')))
        );        
        insert MxTestConnection3;
        
        Test.startTest();
        SPDLTest.Warranty_Training_Certification__c = true;
        upsert SPDLTest;
        Test.setMock(HttpCalloutMock.class, new CSS_WS_WebServicesMock());
        ApexPages.StandardController standardController = new ApexPages.StandardController(claim);
        CSS_WS_PartsGridController controller = new CSS_WS_PartsGridController(standardController);
        CSS_WS_PartsGridController.CreateNewPart newPart = new CSS_WS_PartsGridController.CreateNewPart(controller.PartCounter++,
                 '123132', 0, 'Progressive Damage', '123', '123', true, '123', 0, 0, claim.Id, 'PRICE BOOK',true, true, 12, 12, '1234210000X', true, 'test_123', 'test_123', 'test_123', 'test_123', 'test_123', 'test_123');
        controller.getERPFlag();
        CSS_WS_Parts_In_Promotion__c partP = new CSS_WS_Parts_In_Promotion__c(
            Name = '3007689',
            Long_Part_Number__c = '300768900',
            Description__c = 'testPart', 
            DLR_Price__c = 10, 
            DR_Price__c = 10);
        insert partP;

        controller.PartToUpdate = 1;
        controller.PartList.add(newPart);
        controller.getPartInPromotion('3007689');
        controller.getERPFlag();
        controller.UpdatePart();
        controller.countParts();
        Test.stopTest();
    }
}