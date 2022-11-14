@IsTest
Private Class CSS_WS_RSW_US_Async_Test{

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
        
        CSS_WS_Rescue__c rescue = new CSS_WS_Rescue__c ();
        insert rescue ;
        
        String rescueNumber = [SELECT Name FROM CSS_WS_Rescue__c WHERE Id =: rescue.Id].Name;
        
        CSS_WS_Warranty__c claim = new CSS_WS_Warranty__c(
            CSS_WS_Service_Provider_Dealer__c = '12345',
            CSS_WS_Service_Provider_DR__c = '12346',
            CSS_WS_Complaints1__c = 'Complaints1',
            CSS_WS_Promotion_ID__c = '1234',
            CSS_WS_Claim_Narrative__c = 'Narrative',
            CSS_WS_Warranty_Subtype__c = 'BIS',
            CSS_WS_Total_Amount_Travel__c = 100,
            CSS_WS_Towing_Amount__c = 50,
            CSS_WS_Policy_Flag__c = 'Policy WW',
            CSS_WS_RescueNumber__c = rescueNumber);
        insert claim;
        
        CSS_WS_MultiESN__c multi = new CSS_WS_MultiESN__c (
            CSS_WS_Warranty__c = claim.Id);
        insert multi;
        
        CSS_WS_Failure__c failure = new CSS_WS_Failure__c (
            CSS_WS_Warranty__c = claim.Id);
        insert failure;
        
        CSS_WS_Other_Claimable__c oc = new CSS_WS_Other_Claimable__c(
            CSS_WS_Warranty__c = claim.Id);
        insert oc;
        
        CSS_WS_Warranty_Parts__c part = new CSS_WS_Warranty_Parts__c(
            CSS_WS_Part_Return_Flag__c = true, 
            CSS_WS_WarrantyID__c = claim.Id);
        insert part;
        
        CSS_WS_Warranty_SRT__c srt = new CSS_WS_Warranty_SRT__c(
            CSS_WS_SRT__c = '00-210',
            CSS_WS_WarrantyID__c = claim.Id);        
        insert srt;        
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new CSS_WS_WebServicesMock()); 
        CSS_WS_RSW_US_Async.claimSubmissionWSCallout(claim.Id);
        Test.stopTest();
        String siebelClaimNumber = [SELECT CSS_WS_Siebel_Claim_Number__c FROM CSS_WS_Warranty__c WHERE Id =: claim.Id].CSS_WS_Siebel_Claim_Number__c;
    }
    
    Public Static TestMethod Void testfutureMethodCampaign(){
        Account SPDLTest = new Account(
            IAM_Service_Provider_Code__c = '12345',
            CSS_DBCode__c = '12346',
            Type = 'Dealer Account',
            Name = 'DUMMY DEALER',
            CMI_Account_Status__c = 'Active',
            Warranty_Training_Certification__c = true,
            BillingCountry = 'MEXICO');
        insert SPDLTest;
        
        CSS_WS_Rescue__c rescue = new CSS_WS_Rescue__c ();
        insert rescue ;
        
        String rescueNumber = [SELECT Name FROM CSS_WS_Rescue__c WHERE Id =: rescue.Id].Name;
        
        CSS_WS_Warranty__c claim = new CSS_WS_Warranty__c(
            CSS_WS_Service_Provider_Dealer__c = '12345',
            CSS_WS_Service_Provider_DR__c = '12346',
            CSS_WS_Complaints1__c = 'Complaints1',
            CSS_WS_Promotion_ID__c = '1234',
            CSS_WS_Claim_Narrative__c = 'Narrative',
            CSS_WS_Warranty_Subtype__c = 'BIS',
            CSS_WS_Total_Amount_Travel__c = 100,
            CSS_WS_Towing_Amount__c = 50,
            CSS_WS_Policy_Flag__c = 'Policy WW',
            CSS_WS_Campaigns_TRPs__c = '1234',
            CSS_WS_Campaign_Travel_Percentage__c = 100,
            CSS_WS_Campaign_Towing_Percentage__c = 100,
            CSS_WS_RescueNumber__c = rescueNumber);
        insert claim;
        
        CSS_WS_Failure__c failure = new CSS_WS_Failure__c (
            CSS_WS_Warranty__c = claim.Id);
        insert failure;              
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new CSS_WS_WebServicesMock()); 
        CSS_WS_RSW_US_Async.claimSubmissionWSCallout(claim.Id);
        Test.stopTest();
        String siebelClaimNumber = [SELECT CSS_WS_Siebel_Claim_Number__c FROM CSS_WS_Warranty__c WHERE Id =: claim.Id].CSS_WS_Siebel_Claim_Number__c;
    }
    
    Public Static TestMethod Void testfutureMethodCampaignCero(){
        Account SPDLTest = new Account(
            IAM_Service_Provider_Code__c = '12345',
            CSS_DBCode__c = '12346',
            Type = 'Dealer Account',
            Name = 'DUMMY DEALER',
            CMI_Account_Status__c = 'Active',
            Warranty_Training_Certification__c = true,
            BillingCountry = 'MEXICO');
        insert SPDLTest;
        
        CSS_WS_Rescue__c rescue = new CSS_WS_Rescue__c ();
        insert rescue ;
        
        String rescueNumber = [SELECT Name FROM CSS_WS_Rescue__c WHERE Id =: rescue.Id].Name;
        
        CSS_WS_Warranty__c claim = new CSS_WS_Warranty__c(
            CSS_WS_Service_Provider_Dealer__c = '12345',
            CSS_WS_Service_Provider_DR__c = '12346',
            CSS_WS_Complaints1__c = 'Complaints1',
            CSS_WS_Promotion_ID__c = '1234',
            CSS_WS_Claim_Narrative__c = 'Narrative',
            CSS_WS_Warranty_Subtype__c = 'BIS',
            CSS_WS_Total_Amount_Travel__c = 100,
            CSS_WS_Towing_Amount__c = 50,
            CSS_WS_Policy_Flag__c = 'Policy WW',
            CSS_WS_Campaigns_TRPs__c = '1234',
            CSS_WS_Campaign_Travel_Percentage__c = 0,
            CSS_WS_Campaign_Towing_Percentage__c = 0,
            CSS_WS_RescueNumber__c = rescueNumber);
        insert claim;
        
        CSS_WS_Failure__c failure = new CSS_WS_Failure__c (
            CSS_WS_Warranty__c = claim.Id);
        insert failure;              
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new CSS_WS_WebServicesMock()); 
        CSS_WS_RSW_US_Async.claimSubmissionWSCallout(claim.Id);
        Test.stopTest();
        String siebelClaimNumber = [SELECT CSS_WS_Siebel_Claim_Number__c FROM CSS_WS_Warranty__c WHERE Id =: claim.Id].CSS_WS_Siebel_Claim_Number__c;
    }
    
    Public Static TestMethod Void testfutureMethodNotCampaign(){
        Account SPDLTest = new Account(
            IAM_Service_Provider_Code__c = '12345',
            CSS_DBCode__c = '12346',
            Type = 'Dealer Account',
            Name = 'DUMMY DEALER',
            CMI_Account_Status__c = 'Active',
            Warranty_Training_Certification__c = true,
            BillingCountry = 'MEXICO');
        insert SPDLTest;
        
        CSS_WS_Rescue__c rescue = new CSS_WS_Rescue__c ();
        insert rescue ;
        
        String rescueNumber = [SELECT Name FROM CSS_WS_Rescue__c WHERE Id =: rescue.Id].Name;
        
        CSS_WS_Warranty__c claim = new CSS_WS_Warranty__c(
            CSS_WS_Service_Provider_Dealer__c = '12345',
            CSS_WS_Service_Provider_DR__c = '12346',
            CSS_WS_Complaints1__c = 'Complaints1',
            CSS_WS_Promotion_ID__c = '1234',
            CSS_WS_Claim_Narrative__c = 'Narrative',
            CSS_WS_Warranty_Subtype__c = 'BIS',
            CSS_WS_Total_Amount_Travel__c = 100,
            CSS_WS_Towing_Amount__c = 50,
            CSS_WS_Policy_Flag__c = 'Policy WW',
            CSS_WS_Covered_Travel_Labor__c = 9999,
            CSS_WS_Covered_Travel_Miles__c = 9999,
            CSS_WS_Covered_Meals_Lodging__c = 9999,
            CSS_WS_Total_Amount_SRT_Hours__c = 10,
            CSS_WS_Travel_Hours__c = 10,
            CSS_WS_Lodging__c = 100,
            CSS_WS_Covered_Towing_Miles__c = 100,
            CSS_WS_RescueNumber__c = rescueNumber);
        insert claim;
        
        CSS_WS_Failure__c failure = new CSS_WS_Failure__c (
            CSS_WS_Warranty__c = claim.Id);
        insert failure;              
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new CSS_WS_WebServicesMock()); 
        CSS_WS_RSW_US_Async.claimSubmissionWSCallout(claim.Id);
        Test.stopTest();
        String siebelClaimNumber = [SELECT CSS_WS_Siebel_Claim_Number__c FROM CSS_WS_Warranty__c WHERE Id =: claim.Id].CSS_WS_Siebel_Claim_Number__c;
    }

    Public Static TestMethod Void testfutureMethodNotCampaignCA(){
        Account SPDLTest = new Account(
            IAM_Service_Provider_Code__c = '12345',
            CSS_DBCode__c = '12346',
            Type = 'Dealer Account',
            Name = 'DUMMY DEALER',
            CMI_Account_Status__c = 'Active',
            Warranty_Training_Certification__c = true,
            BillingCountry = 'PANAMA');
        insert SPDLTest;
        
        CSS_WS_Rescue__c rescue = new CSS_WS_Rescue__c ();
        insert rescue ;
        
        String rescueNumber = [SELECT Name FROM CSS_WS_Rescue__c WHERE Id =: rescue.Id].Name;
        
        CSS_WS_Warranty__c claim = new CSS_WS_Warranty__c(
            CSS_WS_Service_Provider_Dealer__c = '12345',
            CSS_WS_Service_Provider_DR__c = '12346',
            CSS_WS_Complaints1__c = 'Complaints1',
            CSS_WS_Promotion_ID__c = '1234',
            CSS_WS_Claim_Narrative__c = 'Narrative',
            CSS_WS_Warranty_Subtype__c = 'BIS',
            CSS_WS_Total_Amount_Travel__c = 100,
            CSS_WS_Towing_Amount__c = 50,
            CSS_WS_Policy_Flag__c = 'Policy WW',
            CSS_WS_Covered_Travel_Labor__c = 9999,
            CSS_WS_Covered_Travel_Miles__c = 9999,
            CSS_WS_Covered_Meals_Lodging__c = 9999,
            CSS_WS_Total_Amount_SRT_Hours__c = 10,
            CSS_WS_Travel_Hours__c = 10,
            CSS_WS_Lodging__c = 100,
            CSS_WS_Covered_Towing_Miles__c = 100,
            CSS_WS_RescueNumber__c = rescueNumber);
        insert claim;
        
        CSS_WS_Failure__c failure = new CSS_WS_Failure__c (
            CSS_WS_Warranty__c = claim.Id);
        insert failure;
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new CSS_WS_WebServicesMock()); 
        CSS_WS_RSW_US_Async.claimSubmissionWSCallout(claim.Id);
        Test.stopTest();
        String siebelClaimNumber = [SELECT CSS_WS_Siebel_Claim_Number__c FROM CSS_WS_Warranty__c WHERE Id =: claim.Id].CSS_WS_Siebel_Claim_Number__c;
    }
}