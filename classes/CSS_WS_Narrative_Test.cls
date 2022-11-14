@isTest
Public Class CSS_WS_Narrative_Test{
    
    Public Static TestMethod Void testValidateNarrative(){
        PageReference pageRef = Page.CSS_WS_ClaimFormat;
        CSS_WS_Warranty__c claim = new CSS_WS_Warranty__c(
            CSS_WS_Engine_Serial_Number__c = '12345678',
            CSS_WS_Policy_Flag__c = 'Warranty',
            CSS_WS_Account_Code__c = null,
            CSS_WS_Failure_Date_Time__c = system.today(),
            CSS_WS_Engine_Family_Code__c = '12');
        insert claim;
            
        Test.setCurrentPage(pageRef);
        ApexPages.StandardController standardController = new ApexPages.StandardController(claim); 
        CSS_WS_Narrative controller = new CSS_WS_Narrative(standardController);  
        Test.StartTest();
        Test.setMock(HttpCalloutMock.class, new CSS_WS_WebServicesMock()); 
        controller.getPromotionIDs();
        controller.saveNarratives();
        claim.CSS_WS_Promotion_ID__c = 'No Promotion Id';
        controller.saveNarratives();
        controller.validateNarrative();
        Test.StopTest();
    } 
}