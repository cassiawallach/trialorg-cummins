@IsTest
Public Class CSS_WS_OtherClaimablesControllerTest{

    Public Static TestMethod Void testingMethods1(){
        PageReference pageRef = Page.CSS_WS_ClaimFormat;
        Account SPDLTest = new Account(
            IAM_Service_Provider_Code__c = '55893',
            CSS_DBCode__c = '55893',
            Type = 'Distributor Account',
            Name = 'DUMMY DEALER',
            CMI_Account_Status__c = 'Active',
            BillingCountry = 'Mexico',
            CSS_WS_Channel_Code__c = '110');
        insert SPDLTest;
        
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
            CSS_WS_Covered_OC_Amount__c = 99999);
        insert Claim;
        
        List<CSS_WS_Failure__c> Failures = new List<CSS_WS_Failure__c>();
        Failures.add(new CSS_WS_Failure__c(CSS_WS_EngineSystemCode__c = 'BK', CSS_WS_ComponentCode__c = 'CA', CSS_WS_FailureModeCode__c = '21', CSS_WS_Warranty__c = Claim.Id));
        insert Failures;
        
        List<CSS_WS_Other_Claimable__c> OtherClaimables = new List<CSS_WS_Other_Claimable__c>();
        OtherClaimables.add(new CSS_WS_Other_Claimable__c(CSS_WS_Description__c = 'Ties', CSS_WS_Claimable__c = 'Ties', CSS_WS_Requested_Amount__c = 12.00, CSS_WS_Warranty__c = Claim.Id));
        OtherClaimables.add(new CSS_WS_Other_Claimable__c(CSS_WS_Description__c = 'Oil', CSS_WS_Claimable__c = 'Oil', CSS_WS_Requested_Amount__c = 23.00, CSS_WS_Warranty__c = Claim.Id));
        OtherClaimables.add(new CSS_WS_Other_Claimable__c(CSS_WS_Description__c = 'Lorem Ipsum', CSS_WS_Claimable__c = 'Unlisted', CSS_WS_Requested_Amount__c = 35.99, CSS_WS_Warranty__c = Claim.Id));
        insert OtherClaimables;
        
        ApexPages.StandardController standardController = new ApexPages.StandardController(Claim);
        CSS_WS_DynamicOtherClaimablesController controller = new CSS_WS_DynamicOtherClaimablesController(standardController);
        
        Test.startTest();
        controller.BeforeSaveClaimables();
        controller.SaveClaimables();
        controller.Claimable = 'Oil';
        controller.Description = 'Oil';
        controller.RequestAmount = 34.99;
        controller.AddNewClaimable();
        
        controller.ClaimableToDelete = 1;
        controller.DeleteClaimable();
        
        controller.CheckClaimablesRepeated();
        Test.setMock(HttpCalloutMock.class, new CSS_WS_WebServicesMock());
        controller.OtherClaimablesCallODM();
        Test.stopTest();
    }
    
    Public Static TestMethod Void testingMethods2(){
        PageReference pageRef = Page.CSS_WS_ClaimFormat;
        Account SPDLTest = new Account(
            IAM_Service_Provider_Code__c = '54734',
            CSS_DBCode__c = '54734',
            Type = 'Distributor Account',
            Name = 'DUMMY DEALER',
            CMI_Account_Status__c = 'Active', 
            BillingCountry = 'Mexico',
            CSS_WS_Channel_Code__c = '110');
        insert SPDLTest;
        
        CSS_WS_Warranty__c Claim2 = new CSS_WS_Warranty__c(
            CSS_WS_Campaigns_TRPs__c = null,
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
            CSS_WS_Repair_Work_Order_Number__c = '09867');
        insert Claim2;
        
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
            CSS_WS_Repair_Work_Order_Number__c = '0987');
        insert Claim;
        
        List<CSS_WS_Failure__c> Failures = new List<CSS_WS_Failure__c>();
        Failures.add(new CSS_WS_Failure__c(CSS_WS_EngineSystemCode__c = 'BK', CSS_WS_ComponentCode__c = 'CA', CSS_WS_FailureModeCode__c = '21', CSS_WS_Warranty__c = Claim.Id));
        insert Failures;
        
        List<CSS_WS_Other_Claimable__c> OtherClaimables = new List<CSS_WS_Other_Claimable__c>();
        OtherClaimables.add(new CSS_WS_Other_Claimable__c(CSS_WS_Description__c = 'Oil', CSS_WS_Claimable__c = 'Oil', CSS_WS_Requested_Amount__c = 23.00, CSS_WS_Warranty__c = Claim.Id));
        insert OtherClaimables;
        
        ApexPages.StandardController standardController = new ApexPages.StandardController(Claim);
        CSS_WS_DynamicOtherClaimablesController controller = new CSS_WS_DynamicOtherClaimablesController(standardController);
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new CSS_WS_WebServicesMock());
        controller.SaveClaimables();
        Test.stopTest();
    }
    
    Public Static TestMethod Void testingMethods3(){
        PageReference pageRef = Page.CSS_WS_ClaimFormat;
        Account SPDLTest = new Account(
            IAM_Service_Provider_Code__c = '54734',
            CSS_DBCode__c = '54734',
            Type = 'Distributor Account',
            Name = 'DUMMY DEALER',
            CMI_Account_Status__c = 'Active',
            BillingCountry = 'Mexico',
            CSS_WS_Channel_Code__c = '110');
        insert SPDLTest;
        
        CSS_WS_Warranty__c Claim = new CSS_WS_Warranty__c(
            CSS_WS_Campaigns_TRPs__c = '12345',
            CSS_WS_Campaign_OC_Percentage__c = 50,
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
            CSS_WS_Repair_Work_Order_Number__c = '0987');
        insert Claim;
        
        List<CSS_WS_Failure__c> Failures = new List<CSS_WS_Failure__c>();
        Failures.add(new CSS_WS_Failure__c(CSS_WS_EngineSystemCode__c = 'BK', CSS_WS_ComponentCode__c = 'CA', CSS_WS_FailureModeCode__c = '21', CSS_WS_Warranty__c = Claim.Id));
        insert Failures;
        
        List<CSS_WS_Other_Claimable__c> OtherClaimables = new List<CSS_WS_Other_Claimable__c>();
        OtherClaimables.add(new CSS_WS_Other_Claimable__c(CSS_WS_Description__c = 'Oil', CSS_WS_Claimable__c = 'Oil', CSS_WS_Requested_Amount__c = 23.00, CSS_WS_Warranty__c = Claim.Id));
        insert OtherClaimables;
        
        ApexPages.StandardController standardController = new ApexPages.StandardController(Claim);
        CSS_WS_DynamicOtherClaimablesController controller = new CSS_WS_DynamicOtherClaimablesController(standardController);
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new CSS_WS_WebServicesMock());
        controller.SaveClaimables();
        Test.stopTest();
    }
    
    Public Static TestMethod Void testingMethods4(){
        PageReference pageRef = Page.CSS_WS_ClaimFormat;
        Account SPDLTest = new Account(
            IAM_Service_Provider_Code__c = '54734',
            CSS_DBCode__c = '54734',
            Type = 'Distributor Account',
            Name = 'DUMMY DEALER',
            CMI_Account_Status__c = 'Active',
            BillingCountry = 'Mexico',
            CSS_WS_Channel_Code__c = '110');
        insert SPDLTest;
        
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
            CSS_WS_Repair_Work_Order_Number__c = '0987');
        insert Claim;
        
        List<CSS_WS_Failure__c> Failures = new List<CSS_WS_Failure__c>();
        Failures.add(new CSS_WS_Failure__c(CSS_WS_EngineSystemCode__c = 'BK', CSS_WS_ComponentCode__c = 'CA', CSS_WS_FailureModeCode__c = '21', CSS_WS_Warranty__c = Claim.Id));
        insert Failures;
        
        List<CSS_WS_Other_Claimable__c> OtherClaimables = new List<CSS_WS_Other_Claimable__c>();
        OtherClaimables.add(new CSS_WS_Other_Claimable__c(CSS_WS_Description__c = 'Oil', CSS_WS_Claimable__c = 'Oil', CSS_WS_Requested_Amount__c = 23.00, CSS_WS_Warranty__c = Claim.Id));
        insert OtherClaimables;
        
        ApexPages.StandardController standardController = new ApexPages.StandardController(Claim);
        CSS_WS_DynamicOtherClaimablesController controller = new CSS_WS_DynamicOtherClaimablesController(standardController);
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new CSS_WS_WebServicesMock());
        controller.SaveClaimables();
        Test.stopTest();
    }
}