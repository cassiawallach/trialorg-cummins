@IsTest
Private Class CSS_WS_Claim_Reliability_Async_Test{

    Public Static TestMethod Void testfutureMethod(){
        Account SPDLTest = new Account(
            IAM_Service_Provider_Code__c = '12345',
            CSS_DBCode__c = '12346',
            Type = 'Dealer Account',
            Name = 'DUMMY DEALER',
            CMI_Account_Status__c = 'Active',
            Warranty_Training_Certification__c = true,
            BillingCountry = 'MEXICO');
        insert SPDLTest;
             
        CSS_WS_Warranty__c claim = new CSS_WS_Warranty__c(
            CSS_WS_Service_Provider_Dealer__c = '12345',
            CSS_WS_Service_Provider_DR__c = '12346',
            CSS_WS_Complaints1__c = 'Complaints1',
            CSS_WS_Promotion_ID__c = '1234',
            CSS_WS_Claim_Narrative__c = 'Narrative',
            CSS_WS_Warranty_Subtype__c = 'BIS',
            CSS_WS_Total_Amount_Travel__c = 100,
            CSS_WS_Towing_Amount__c = 50,
            CSS_WS_Policy_Flag__c = 'Policy');
        insert claim;        
  
        CSS_WS_Failure__c failure = new CSS_WS_Failure__c (
            CSS_WS_Warranty__c = claim.Id);
        insert failure;
        
        CSS_WS_Warranty_Parts__c part = new CSS_WS_Warranty_Parts__c(
            CSS_WS_Part_Return_Flag__c = true, 
            CSS_WS_WarrantyID__c = claim.Id);
        insert part;        
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new CSS_WS_WebServicesMock()); 
        CSS_WS_Claim_Reliability_Async.claimReliabilityWSCallout(claim.Id);
        Test.stopTest();
    }
    
}