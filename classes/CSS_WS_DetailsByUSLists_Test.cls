@IsTest
Public Class CSS_WS_DetailsByUSLists_Test {
    Public Static testMethod Void listMethods(){
        CSS_WS_Warranty__c claim = new CSS_WS_Warranty__c(
            CSS_WS_Warranty_Start_Date__c = system.today(),
            CSS_WS_Engine_Serial_Number__c = '10000000',
            CSS_WS_Service_Provider_DR__c = '54734',
            CSS_WS_Service_Provider_Dealer__c = '54732',
            CSS_WS_Policy_Flag__c = 'Warranty',
            CSS_WS_Account_Code__c = null,
            CSS_WS_Failure_Date_Time__c = system.today(),
            CSS_WS_Engine_Family_Code__c = '12',
            CSS_WS_Model_Series__c = 'XLF-124',
            Is_Clone__c = 1);
        insert claim; 
        
        CSS_WS_US_Details__c detail =  new CSS_WS_US_Details__c(
        	CSS_WS_Type_Section__c = 'Parts',
            CSS_WS_Part_Number__c = '90001',
            CSS_WS_Claim__c = claim.id);
        insert detail;
        
        detail =  new CSS_WS_US_Details__c(
        	CSS_WS_Type_Section__c = 'Other Claimables',
            CSS_WS_Description__c = 'Example',
            CSS_WS_Claim__c = claim.id);
        insert detail;
        
        detail =  new CSS_WS_US_Details__c(
            CSS_WS_SRT_Code__c = '00-901',
        	CSS_WS_Type_Section__c = 'SRTs',
            CSS_WS_Claim__c = claim.id);
        insert detail;
        
        Test.StartTest();
        Test.setMock(HttpCalloutMock.class, new CSS_WS_WebServicesMock());
        System.currentPageReference().getParameters().put('id', claim.id);
        ApexPages.StandardController standardController = new ApexPages.StandardController(claim); 
        CSS_WS_DetailsByUSLists controller = new CSS_WS_DetailsByUSLists(standardController);
        Test.StopTest();
    }
}