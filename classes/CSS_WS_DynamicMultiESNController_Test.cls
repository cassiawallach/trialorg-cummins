@isTest
Public Class CSS_WS_DynamicMultiESNController_Test{
    Public Static TestMethod void TestMethod1(){
        PageReference pageRef = Page.CSS_WS_ClaimFormat;
        CSS_WS_Warranty__c Claim = new CSS_WS_Warranty__c(
            //CSS_WS_Campaigns_TRPs__c = 'XF444',
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
            CSS_WS_HasError__c = 0,
            CSS_WS_Account_Code__c = '65',
            CSS_WS_Account_Code_Type__c = '01',
            CSS_WS_Product_Application_Code__c = '02',
            CSS_WS_Warranty_Subtype__c = null,
            CSS_WS_Multi_ESN__c = true,
            CSS_WS_Service_Provider_DR__c = '55893',
            CSS_WS_Total_Labor__c = 1234.00,
            CSS_Authorization_Number__c = '982',
            CSS_WS_Approval_Code__c = '1234',
            CSS_WS_Towing_Amount__c = 67.55);
        
        Account SPDLTest = new Account(
            IAM_Service_Provider_Code__c = '55893',
            CSS_DBCode__c = '55893',
            Type = 'Dealer Account',
            Name = 'DUMMY DEALER',
            CMI_Account_Status__c = 'Active',
            BillingCountry = 'MEXICO');
        insert SPDLTest;
        
        CSS_WS_Engine_Application_Code__c ApplicationCode = new CSS_WS_Engine_Application_Code__c(
            Name = '130',
            Application_Description__c = 'Sample description',
            Default_Measurement__c = 'Km',
            Automotive_Flag__c = 'N',
            Marine_Flag__c = 'Y');
        insert ApplicationCode;
        
        ApexPages.StandardController standardController = new ApexPages.StandardController(Claim);
        CSS_WS_DynamicMultiESNController controller = new CSS_WS_DynamicMultiESNController(standardController);
        Test.setCurrentPage(pageRef);
        
        Test.startTest();
        controller.SaveMultiESNs();
        insert Claim;
        List<CSS_WS_Failure__c> Failures = new List<CSS_WS_Failure__c>();
        Failures.add(new CSS_WS_Failure__c(
            CSS_WS_ComponentCode__c = 'CV',
            CSS_WS_EngineSystem__c = 'FAN DRIVES',
            CSS_WS_EngineSystemCode__c = 'SG',
            CSS_WS_FailureModeCode__c = '22',
            CSS_WS_ComponentName__c = 'COVER',
            CSS_WS_FailureModeName__c = 'CODING ERROR',
            CSS_WS_Warranty__c = Claim.Id));
        Failures.add(new CSS_WS_Failure__c(
            CSS_WS_ComponentCode__c = 'FW',
            CSS_WS_EngineSystem__c = 'FLYWH/FLEX',
            CSS_WS_EngineSystemCode__c = 'SN',
            CSS_WS_FailureModeCode__c = '22',
            CSS_WS_ComponentName__c = 'ISOLATOR CAPSCREW',
            CSS_WS_FailureModeName__c = 'CODING ERROR',
            CSS_WS_Warranty__c = Claim.Id));
        
        List<CSS_WS_MultiESN__c> ESNs = new List<CSS_WS_MultiESN__c>();
        ESNs.add(new CSS_WS_MultiESN__c(
            CSS_WS_BIS_2__c='BIS',
            CSS_WS_Detail__c='loremipsum',
            CSS_WS_ESNCalibrationStart__c='45',
            CSS_WS_ESNCalibrationEnd__c='56',
            CSS_WS_MultiESN__c='12345678',
            CSS_WS_FailureDate__c=Date.today(),
            CSS_WS_FailurePointType__c='23',
            CSS_WS_FailurePoint__c='12',
            CSS_WS_WarrantyStartDate__c=Date.today(),
            CSS_WS_Warranty__c = Claim.Id));
        ESNs.add(new CSS_WS_MultiESN__c(
            CSS_WS_BIS_2__c='No BIS',
            CSS_WS_Detail__c='loremipsum',
            CSS_WS_ESNCalibrationStart__c='56',
            CSS_WS_ESNCalibrationEnd__c='67',
            CSS_WS_MultiESN__c='22222222',
            CSS_WS_FailureDate__c=Date.today(),
            CSS_WS_FailurePointType__c='34',
            CSS_WS_FailurePoint__c='23',
            CSS_WS_WarrantyStartDate__c=Date.today(),
            CSS_WS_Warranty__c = Claim.Id));
        insert Failures;
        
        controller.LoadPreviousESNs();
        insert ESNs;
        controller.LoadPreviousESNs();
        claim.CSS_WS_HasError__c = 0;
        controller.SaveMultiESNs();
        
        //Response of the Web services are Null
        controller.PositionOfThisESN = 1;
        controller.MultiESNCallWSToGetEngineData();
        controller.ValidateIfESNsAreCorrect();
        controller.MultiESNCallWSToGetAccCoverage();
        controller.MultiESNCallWSODM();

        //Variables
        controller.SearchWithThisESN = 'Hola';
        controller.BISValue = 'BIS';
        controller.Detail = 'Lorem Ipsum';
        controller.ECMCalibrationBefore = '09';
        controller.ECMCalibrationAfter = '98';
        controller.MultiESN = '44444444';
        controller.FailureDate = Date.today();
        controller.FailurePointType = 'Km';
        controller.FailurePoint = '23';
        controller.UOMFail = '45';
        controller.WarrantyStartDate = Date.today();
        
        Test.setMock(HttpCalloutMock.class, new CSS_WS_WebServicesMock());
        controller.PositionOfThisESN = 1;
        controller.MultiESNCallWSToGetEngineData();
        Test.stopTest();
    }
    
    Public Static TestMethod void TestMethod2(){
        PageReference pageRef = Page.CSS_WS_ClaimFormat;
        CSS_WS_Warranty__c Claim = new CSS_WS_Warranty__c(
            //CSS_WS_Campaigns_TRPs__c = 'XF444',
            CSS_WS_Engine_Serial_Number__c = '11111111',
            CSS_WS_Engine_Family_Code__c = '10',
            CSS_WS_Service_Provider_Dealer__c = '55893',
            CSS_WS_Failure_Date_Time__c = Date.today(),
            CSS_WS_Failure_Point_Quantity__c = '2',
            CSS_WS_Failure_Measure__c = 'Km',
            CSS_WS_Warranty_Start_Date__c = Date.today(),
            CSS_WS_Warranty_Type__c = 'Parte',
            CSS_WS_Claim_Type__c = 'Herramienta de Servicio',
            CSS_WS_Policy_Flag__c = 'Warranty',
            CSS_WS_Pay_Code__c = 'R',
            CSS_WS_HasError__c = 0,
            CSS_WS_Account_Code__c = '65',
            CSS_WS_Account_Code_Type__c = '01',
            CSS_WS_Product_Application_Code__c = '02',
            CSS_WS_Warranty_Subtype__c = null,
            CSS_WS_Multi_ESN__c = true,
            CSS_WS_Service_Model__c = 'ISX CM871',
            CSS_WS_Service_Provider_DR__c = '55894',
            CSS_WS_Total_Labor__c = 1234.00,
            CSS_Authorization_Number__c = '982',
            CSS_WS_Approval_Code__c = '1234',
            CSS_WS_Towing_Amount__c = 67.55);
        insert claim;
        
        Account SPDLTest = new Account(
            IAM_Service_Provider_Code__c = '55893',
            CSS_DBCode__c = '55894',
            Type = 'Dealer Account',
            Name = 'DUMMY DEALER',
            CMI_Account_Status__c = 'Active',
            BillingCountry = 'MEXICO');
        insert SPDLTest;
        
        CSS_WS_Engine_Application_Code__c ApplicationCode = new CSS_WS_Engine_Application_Code__c(
            Name = '130',
            Application_Description__c = 'Sample description',
            Default_Measurement__c = 'Km',
            Automotive_Flag__c = 'N',
            Marine_Flag__c = 'Y');
        insert ApplicationCode;
        
        List<CSS_WS_Failure__c> Failures = new List<CSS_WS_Failure__c>();
        Failures.add(new CSS_WS_Failure__c(
            CSS_WS_ComponentCode__c = 'CV',
            CSS_WS_EngineSystem__c = 'FAN DRIVES',
            CSS_WS_EngineSystemCode__c = 'SG',
            CSS_WS_FailureModeCode__c = '22',
            CSS_WS_ComponentName__c = 'COVER',
            CSS_WS_FailureModeName__c = 'CODING ERROR',
            CSS_WS_Warranty__c = Claim.Id));
        Failures.add(new CSS_WS_Failure__c(
            CSS_WS_ComponentCode__c = 'FW',
            CSS_WS_EngineSystem__c = 'FLYWH/FLEX',
            CSS_WS_EngineSystemCode__c = 'SN',
            CSS_WS_FailureModeCode__c = '22',
            CSS_WS_ComponentName__c = 'ISOLATOR CAPSCREW',
            CSS_WS_FailureModeName__c = 'CODING ERROR',
            CSS_WS_Warranty__c = Claim.Id));
        insert Failures;
        
        List<CSS_WS_MultiESN__c> ESNs = new List<CSS_WS_MultiESN__c>();
        ESNs.add(new CSS_WS_MultiESN__c(
            CSS_WS_BIS_2__c='BIS',
            CSS_WS_Detail__c='loremipsum',
            CSS_WS_ESNCalibrationStart__c='45',
            CSS_WS_ESNCalibrationEnd__c='56',
            CSS_WS_MultiESN__c='12345678',
            CSS_WS_FailureDate__c=Date.today(),
            CSS_WS_FailurePointType__c='23',
            CSS_WS_FailurePoint__c='12',
            CSS_WS_WarrantyStartDate__c=Date.today(),
            CSS_WS_Warranty__c = Claim.Id));
        ESNs.add(new CSS_WS_MultiESN__c(
            CSS_WS_BIS_2__c='No BIS',
            CSS_WS_Detail__c='loremipsum',
            CSS_WS_ESNCalibrationStart__c='56',
            CSS_WS_ESNCalibrationEnd__c='67',
            CSS_WS_MultiESN__c='22222222',
            CSS_WS_FailureDate__c=Date.today(),
            CSS_WS_FailurePointType__c='34',
            CSS_WS_FailurePoint__c='23',
            CSS_WS_WarrantyStartDate__c=Date.today(),
            CSS_WS_Warranty__c = Claim.Id));
        insert ESNs;
        
        ApexPages.StandardController standardController = new ApexPages.StandardController(Claim);
        CSS_WS_DynamicMultiESNController controller = new CSS_WS_DynamicMultiESNController(standardController);
        Test.setCurrentPage(pageRef);
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new CSS_WS_WebServicesMock());
        //Response of the Web services are not Null
        controller.PositionOfThisESN = 1;
        controller.MultiESNCallWSToGetEngineData();
        claim.CSS_WS_Engine_Family_Code__c = '49';
        controller.MultiESNCallWSToGetEngineData();
        claim.CSS_WS_Service_Model__c = 'ISX CM872';
        controller.MultiESNCallWSToGetEngineData();
        
        controller.ValidateIfESNsAreCorrect();
        controller.MultiESNCallWSToGetAccCoverage();
        controller.MultiESNCallWSODM(); 
 
        controller.ESNToDelete = 1;
        controller.DeleteESN();
        
        controller.SetDefaultValues();
        claim.CSS_WS_Warranty_Subtype__c = 'BIS';
        controller.SetDefaultValues();
        
        controller.getEngineApplication('130');
        
        controller.DisplayErrorHandler('Example', null);
        controller.DisplayErrorHandler('Example', 1);
        Test.stopTest();
    }
}