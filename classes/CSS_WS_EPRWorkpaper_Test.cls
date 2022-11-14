@IsTest
Public Class CSS_WS_EPRWorkpaper_Test {
    Public Static testMethod Void EPRWorkpaperTest(){
        CSS_WS_Warranty__c claim = new CSS_WS_Warranty__c(
            CSS_WS_Warranty_Start_Date__c = system.today(),
            CSS_WS_Engine_Serial_Number__c = '10000000',
            CSS_WS_Service_Provider_DR__c = '54734',
            CSS_WS_Service_Provider_Dealer__c = '54734',
            CSS_WS_Policy_Flag__c = 'Warranty',
            CSS_WS_Account_Code__c = null,
            CSS_WS_Failure_Date_Time__c = system.today(),
            CSS_WS_Engine_Family_Code__c = '12',
            CSS_WS_Model_Series__c = 'XLF-124',
            Is_Clone__c = 1);
        insert claim; 
        
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
            CSS_WS_EPR_Note__c = 'MESSAGE: Service Support Center ***IMPORTANT**EPR**PART REQUEST - Review...',
            CSS_WS_EPR_Attention__c = 'Service Support Center',
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
            CSS_WS_Part_Return_Flag__c = true,
            CSS_WS_Shipping_Company__c = 'FEDEX',
            CSS_WS_Tracking_Guide_Code__c = '123456789',
            CSS_WS_EPR_Note__c = 'MESSAGE: Service Support Center ***IMPORTANT**EPR**PART REQUEST - Review...',
            CSS_WS_EPR_Attention__c = 'Service Support Center',
            CSS_WS_WarrantyID__c = claim.Id,
            CSS_WS_priceBook__c = null));       
        insert parts;

        Account DealerTest = new Account(
            IAM_Service_Provider_Code__c = '54734',
            CSS_DBCode__c = '54734',
            Type = 'Distributor Account',
            Name = 'Dummy Dealer',
            CMI_Account_Status__c = 'Active',
            BillingCountry = 'Mexico');
        insert DealerTest;
        
        Test.StartTest();
        System.currentPageReference().getParameters().put('id', claim.id);
        ApexPages.StandardController standardController = new ApexPages.StandardController(claim); 
        CSS_WS_EPRWorkpaper controller = new CSS_WS_EPRWorkpaper(standardController);
        controller.getParts();
        controller.getAcountAddress();
        Test.StopTest();
    }
}