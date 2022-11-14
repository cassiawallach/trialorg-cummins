@isTest

private class IAM_shareAccountRecordsTest{
    @isTest
    static void testmethod02(){
        Account accSampleRecord01 = new Account(name='Test Data',
                                       CMI_Account_Status__c='Pending',
                                       CMI_CDA_Status__c='New Customer Request',
                                       type='Distributor Account');
        
       insert accSampleRecord01;
       
       Account accSampleRecord02 = new Account(name='AccountTest1',
                                       CMI_Account_Status__c='Pending',
                                       CMI_CDA_Status__c='New Customer Request',
                                       parentId = accSampleRecord01.id                                                                          
                                       );
        
       insert accSampleRecord02;
       
       User u,u2;
       
        //UserRole role = [SELECT Id,Name FROM UserRole WHERE name = 'CFSE East Asia'];
        
        Profile prof = [SELECT Id,Name FROM Profile WHERE name = 'IAM_Distributor_User'];
        
        User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
        
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        
        User u1 = new User(Alias = 'standt1',Country='United Kingdom',Email='demo1@testing.com',EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',LocaleSidKey='en_US',ProfileId = p.Id,TimeZoneSidKey='America/Los_Angeles', UserName='dprobertdemo164@test.org');
        insert u1;
        system.debug('===u1=='+u1);
        
        system.debug('==thisUser =='+thisUser);
        System.runAs (u1) {
        Id profId =[SELECT Id FROM Profile WHERE name = 'IAM_Distributor_User'].id;
        system.debug('==profId ===='+profId);
        // UserRole role = [SELECT Id,Name FROM UserRole  WHERE name = 'NA Sales Rep'];
         //system.debug('==role01===='+role);
         u = new User(firstname= 'Test',
                          lastname='Data',
                          Alias='Tdxx',
                          email = 'Testdata0983@test.com',
                          username= 'Testdata0983@test.com', 
                          profileId= prof.id, 
                          emailencodingkey='UTF-8',
                          languagelocalekey='en_US',
                          localesidkey='en_US',
                          timezonesidkey='America/Los_Angeles',
                          CompanyName = 'Test Data',
                         // UserRoleId = role.id, 
                          IAM_Account__c = string.valueOf(accSampleRecord01.id));
         insert u;  
         
        // UserRole role2 = [SELECT Id,Name FROM UserRole  WHERE name = 'NA Sales Admin'];
        
        
         u2 = new User(firstname= 'Test1',
                          lastname='Data1',
                          Alias='Tdax',
                          email = 'Testdata09831@test.com',
                          username= 'Testdata09831@test.com', 
                          profileId= prof.id, 
                          emailencodingkey='UTF-8',
                          languagelocalekey='en_US',
                          localesidkey='en_US',
                          timezonesidkey='America/Los_Angeles',
                          CompanyName = 'Test Data',
                         // UserRoleId = role2.id, 
                          IAM_Account__c = string.valueOf(accSampleRecord02.id));
         insert u2; 
         //IAM_Internal_User_Record_Sharing.updateUserOnAccountChange(u2,u1);
        }
        Test.startTest();
        User user01 = [SELECT Id,Name,UserRole.Name,UserRoleId,profileId,Profile.ID,IAM_Account__c,CompanyName FROM USER WHERE Id =: u.id LIMIT 1];
        User user02 = [SELECT Id,Name,UserRole.Name,UserRoleId,profileId,Profile.ID,IAM_Account__c,CompanyName FROM USER WHERE Id =: u2.id LIMIT 1];
        //User user01 = [SELECT Id,Name,UserRole.Name,UserRoleId,profileId,Profile.ID,IAM_Account__c,CompanyName FROM USER WHERE lastname='Data' LIMIT 1];
        //User user02 = [SELECT Id,Name,UserRole.Name,UserRoleId,profileId,Profile.ID,IAM_Account__c,CompanyName FROM USER WHERE lastname='Data1' LIMIT 1];
        system.debug('==user01==='+user01);
        system.debug('==user02==='+user02);
        IAM_Internal_User_Record_Sharing recordSharing = new IAM_Internal_User_Record_Sharing();
        IAM_Internal_User_Record_Sharing.shareAccountRecords(user02);
        IAM_Internal_User_Record_Sharing.shareAccountRecordsOnUpdate(user02 ,user01 );
        //IAM_Internal_User_Record_Sharing.updateUserOnAccountChange(user02,user01);
        IAM_Internal_User_Record_Sharing.createAccountShareRecords('AccountTest02',u2.id);
        Test.stopTest();
    }
}