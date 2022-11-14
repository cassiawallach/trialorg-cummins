@isTest
public without sharing class CSS_TestData_WithoutSharing {
    
    public Static User getTestUser(Boolean doInsert, String testLastName, String testConId){
        Profile p = [Select Id,Name from Profile where Name = 'CSS_Dealer_Data_ExChange_Admin']; 
        //UserRole empRole = [Select Id From UserRole Where Name = 'Dealer New Customer User' Limit 1];
        UserRole empRole = [Select Id From UserRole Where PortalType = 'CustomerPortal' Limit 1];
        
        User user1 = new User(
            Username = System.now().millisecond() + testLastName + 'test12345@test.com',
            ContactId=testConId,
            ProfileId = p.Id,
            //UserRoleId = empRole.Id,
            Alias = 'test123',
            Email = 'test12345@test.com',
            EmailEncodingKey = 'UTF-8',
            LastName = testLastName,
            CommunityNickname = testLastName+'test12345',
            TimeZoneSidKey = 'America/Los_Angeles',
            LocaleSidKey = 'en_US',
            LanguageLocaleKey = 'en_US'
        );
        
        if(doInsert){
            insert user1;
        }
        
        return user1;
    }
    
    public Static User getTestUser(Boolean doInsert, String testLastName, String testConId, String profileName){
        Profile p = [Select Id,Name from Profile where Name = :profileName]; 
        //UserRole empRole = [Select Id From UserRole Where Name = 'Dealer New Customer User' Limit 1];
        UserRole empRole = [Select Id From UserRole Where PortalType = 'CustomerPortal' Limit 1];
        
        User user1 = new User(
            Username = System.now().millisecond() + testLastName + 'test12345@test.com',
            ContactId=testConId,
            ProfileId = p.Id,
            //UserRoleId = empRole.Id,
            Alias = 'test123',
            Email = 'test12345@test.com',
            EmailEncodingKey = 'UTF-8',
            LastName = testLastName,
            CommunityNickname = testLastName+'test12345',
            TimeZoneSidKey = 'America/Los_Angeles',
            LocaleSidKey = 'en_US',
            LanguageLocaleKey = 'en_US'
        );
        
        if(doInsert){
            insert user1;
        }
        
        return user1;
    }
    
}