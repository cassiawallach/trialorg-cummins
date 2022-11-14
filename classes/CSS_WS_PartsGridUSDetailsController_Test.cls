@IsTest
Public Class CSS_WS_PartsGridUSDetailsController_Test{
    Public Static TestMethod Void methodDistributor(){
        CSS_WS_Warranty__c claim = new CSS_WS_Warranty__c(
            CSS_WS_Warranty_Start_Date__c = system.today(),
            CSS_WS_Engine_Serial_Number__c = '10000000',
            CSS_WS_Service_Provider_DR__c = '54321',
            CSS_WS_Service_Provider_Dealer__c = '54321',
            CSS_WS_Policy_Flag__c = 'Warranty',
            CSS_WS_Account_Code__c = null,
            CSS_WS_Failure_Date_Time__c = system.today(),
            CSS_WS_Engine_Family_Code__c = '12',
            CSS_WS_Model_Series__c = 'XLF-124',
            Is_Clone__c = 1,
            CSS_WS_Total_Amount_Other_Claimables__c = 100, 
            CSS_WS_Total_Amount_Part__c = 100, 
            CSS_WS_Total_Amount_SRT__c = 100, 
            CSS_WS_Total_Amount_Travel__c = 100,
            CSS_WS_US_Details_Status__c = 'Success Response',
            CSS_WS_Failure_Point_Quantity__c = '1200');
        insert claim; 
        
        CSS_WS_Warranty_Parts__c partsWarranty = new CSS_WS_Warranty_Parts__c(
            CSS_WS_PartNumber__c = '90001', 
            CSS_WS_Quantity__c = 2, 
            CSS_WS_Description__c = 'Example', 
            CSS_WS_Siebel_Unit_Part_Price__c = 1, 
            CSS_WS_Unit_Part_Price__c = 1.2,
            CSS_WS_WarrantyID__c = claim.id);
        insert partsWarranty;
        
        CSS_WS_Failure__c Failures = new CSS_WS_Failure__c( 
            CSS_WS_ComponentCode__c = '12',
            CSS_WS_EngineSystemCode__c = '13',
            CSS_WS_FailureModeName__c = '14',
            CSS_WS_FailureModeCode__c = '15',
            CSS_WS_Warranty__c = claim.Id);
        insert Failures;
        
        Account SPDLTest = new Account(
            IAM_Service_Provider_Code__c = '54321',
            CSS_DBCode__c = '54321',
            Type = 'Distributor Account',
            Name = 'DUMMY DEALER',
            CMI_Account_Status__c = 'Active',
            CSS_WS_Region_Code__c = 'USCA',
            BillingCountry = 'MEXICO',
            CSS_WS_Claim_Allow_Days__c = 10,
            Warranty_Training_Certification__c = true,
            CSS_WS_Max_Claim_Amount__c = 9999);
        insert SPDLTest;
        
        system.debug(SPDLTest);
        
        CSS_WS_US_Details__c detail1 =  new CSS_WS_US_Details__c(
            CSS_WS_Type_Section__c = 'Parts',
            CSS_WS_Part_Number__c = '90001',
            CSS_WS_Claim__c = claim.id);
        insert detail1; 
        
        CSS_WS_US_Details__c detail2 =  new CSS_WS_US_Details__c(
            CSS_WS_Type_Section__c = 'Parts',
            CSS_WS_Part_Number__c = '90002',
            CSS_WS_Claim__c = claim.id);
        insert detail2; 
           
        Test.StartTest();
        CSS_WS_PartsGridUSDetailsController jobUSDetailsParts = new CSS_WS_PartsGridUSDetailsController();
        jobUSDetailsParts.claim = claim.id;
        System.enqueueJob(jobUSDetailsParts);
        Test.setMock(HttpCalloutMock.class, new CSS_WS_WebServicesMock());
        System.enqueueJob(jobUSDetailsParts);
        Test.stopTest();
    }
    
    Public Static TestMethod Void methodDealer(){
        CSS_WS_Warranty__c claim = new CSS_WS_Warranty__c(
            CSS_WS_Warranty_Start_Date__c = system.today(),
            CSS_WS_Engine_Serial_Number__c = '10000000',
            CSS_WS_Service_Provider_DR__c = '54734',
            CSS_WS_Service_Provider_Dealer__c = '54322',
            CSS_WS_Policy_Flag__c = 'Warranty',
            CSS_WS_Account_Code__c = null,
            CSS_WS_Failure_Date_Time__c = system.today(),
            CSS_WS_Engine_Family_Code__c = '12',
            CSS_WS_Model_Series__c = 'XLF-124',
            Is_Clone__c = 1,
            CSS_WS_US_Details_Status__c = 'Success Response',
            CSS_WS_Failure_Point_Quantity__c = '1200');
        insert claim; 
        
        CSS_WS_Warranty_Parts__c partsWarranty = new CSS_WS_Warranty_Parts__c(
            CSS_WS_PartNumber__c = '90001', 
            CSS_WS_Quantity__c = 2, 
            CSS_WS_Description__c = 'Example', 
            CSS_WS_Siebel_Unit_Part_Price__c = 1, 
            CSS_WS_Unit_Part_Price__c = 1.2,
            CSS_WS_WarrantyID__c = claim.id);
        insert partsWarranty;
        
        CSS_WS_Failure__c Failures = new CSS_WS_Failure__c( 
            CSS_WS_ComponentCode__c = '12',
            CSS_WS_EngineSystemCode__c = '13',
            CSS_WS_FailureModeName__c = '14',
            CSS_WS_FailureModeCode__c = '15',
            CSS_WS_Warranty__c = claim.Id);
        insert Failures;
        
        Account SPDLTest = new Account(
            IAM_Service_Provider_Code__c = '54322',
            CSS_DBCode__c = '54734',
            Type = 'Dealer Account',
            Name = 'DUMMY DEALER',
            CMI_Account_Status__c = 'Active',
            CSS_WS_Region_Code__c = 'USCA',
            BillingCountry = 'MEXICO',
            CSS_WS_Claim_Allow_Days__c = 10,
            Warranty_Training_Certification__c = true,
            CSS_WS_Max_Claim_Amount__c = 9999);
        insert SPDLTest;
        
        CSS_WS_US_Details__c detail1 =  new CSS_WS_US_Details__c(
            CSS_WS_Type_Section__c = 'Parts',
            CSS_WS_Part_Number__c = '90001',
            CSS_WS_Claim__c = claim.id);
        insert detail1; 
        
        CSS_WS_US_Details__c detail2 =  new CSS_WS_US_Details__c(
            CSS_WS_Type_Section__c = 'Parts',
            CSS_WS_Part_Number__c = '90002',
            CSS_WS_Claim__c = claim.id);
        insert detail2; 
           
        Test.StartTest();
        CSS_WS_PartsGridUSDetailsController jobUSDetailsParts = new CSS_WS_PartsGridUSDetailsController();
        jobUSDetailsParts.claim = claim.id;
        System.enqueueJob(jobUSDetailsParts);
        Test.setMock(HttpCalloutMock.class, new CSS_WS_WebServicesMock());
        System.enqueueJob(jobUSDetailsParts);   
        Test.stopTest();
    }
}