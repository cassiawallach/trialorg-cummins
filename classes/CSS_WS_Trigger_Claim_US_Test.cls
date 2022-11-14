@IsTest
Public Class CSS_WS_Trigger_Claim_US_Test{

    Static TestMethod Void TestTrigger(){
        CSS_WS_Warranty__c Claim = new CSS_WS_Warranty__c(
            CSS_WS_Claim_Status__c = 'Pending DR', 
            CSS_WS_Account_Code__c = 'P88',
            CSS_WS_Policy_Flag__c = 'Policy',
            CSS_WS_Login_Variable__c = 'DealerLoggedIn',
            CSS_WS_Service_Provider_Dealer__c = '12325', 
            CSS_WS_Service_Provider_DR__c = '12345');        
        insert Claim; 
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new CSS_WS_WebServicesMock());
        update Claim;
        Claim.CSS_WS_Claim_Status__c = 'Pending TSM';
        update Claim;
        Claim.CSS_WS_Claim_Status__c = 'Pending Planta Payment Policy';
        update Claim;         
        Claim.CSS_WS_Account_Code__c = 'P80';
        update Claim;
        Claim.CSS_WS_Account_Code__c = 'P88';
        Claim.CSS_WS_Login_Variable__c = 'DRLoggedIn';
        Claim.CSS_WS_Claim_Status__c = 'Pending TSM';
        update Claim;
        update Claim;
        Claim.CSS_WS_DLR_Credit_Number__c = '12345';
        Claim.CSS_WS_Login_Variable__c = 'DealerLoggedIn';
        Claim.CSS_WS_Claim_Status__c = 'Paid';
        update Claim;
        Claim.CSS_WS_Claim_Status__c = 'Approved for Payment';
        update Claim;      
        Claim.CSS_WS_Claim_Status__c = 'Pending US';
        Claim.CSS_WS_Policy_Flag__c = 'Warranty';
        update Claim;
        Claim.CSS_WS_Claim_Status__c = 'Approved for Reliability';
        Claim.CSS_WS_Policy_Flag__c = 'Policy';
        update Claim;
        Test.stopTest();
    }
    
    Static TestMethod Void TestMail(){
        Profile profile2 =[SELECT Id, usertype FROM Profile where name='System Administrator' Limit 1];
        User userApproval = new User(
            Username = System.now().millisecond() + 'testApproval@test.com',
            ProfileId = profile2.Id,
            Alias = 'test4',
            Email = 'test4@test.com',
            EmailEncodingKey = 'UTF-8',
            LastName = 'McTesty',
            TimeZoneSidKey = 'America/Los_Angeles',
            LocaleSidKey = 'en_US',
            IsActive = true,
            LanguageLocaleKey = 'en_US');
        insert userApproval;

        Profile profile1 =[SELECT Id, usertype FROM Profile where name='System Administrator' Limit 1];
        User users = new User(
            Username = System.now().millisecond() + 'test4@test.com',
            ProfileId = profile1.Id,
            Alias = 'test3',
            Email = 'test3@test.com',
            EmailEncodingKey = 'UTF-8',
            LastName = 'McTesty',
            TimeZoneSidKey = 'America/Los_Angeles',
            LocaleSidKey = 'en_US',
            IsActive = true,
            LanguageLocaleKey = 'en_US',
            Community_Approver__c = userApproval.Id);
        insert users;
      
        Test.startTest();
        System.runAs(users){
            CSS_WS_Warranty__c Claim = new CSS_WS_Warranty__c(
                CSS_WS_Claim_Status__c = 'Pending DR', 
                CSS_WS_Service_Provider_Dealer__c = '12345', 
                CSS_WS_Service_Provider_DR__c = '12345',
                CSS_WS_Submited_by__c = users.Id,
                CSS_WS_Account_Code__c = 'P88',
                CSS_WS_Login_Variable__c = 'DRLoggedIn',
                CSS_WS_Policy_Flag__c = 'Policy');       
            insert Claim; 
            Claim.CSS_WS_Claim_Status__c = 'Pending DR Payment to DL';
            update Claim;
        }
        Test.stopTest();
    }
    
}