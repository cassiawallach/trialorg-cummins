@isTest
public class dbu_UserValidation_Test {

    @isTest
    public static void validateUserTest(){
        ccrz__E_Order__c orderObj = new ccrz__E_Order__c();
        insert orderObj;
        
        //String uniqueUserName = 'standarduser' + DateTime.now().getTime() + '@testorg.com';
		//Profile p = [SELECT Id FROM Profile WHERE Name='IAM User'];        
        //User u = new User(Alias = 'guest', Email='standarduser@testorg.com',
        //EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
        //LocaleSidKey='en_US', ProfileId = p.Id,
        //TimeZoneSidKey='America/Los_Angeles',
        //UserName=uniqueUserName);
        
        UserRole userRole_1 = [SELECT Id FROM UserRole WHERE DeveloperName = 'CEO' LIMIT 1];
        //Profile profile_1 = [SELECT Id FROM Profile WHERE name = 'IAM User' LIMIT 1];
        User u = [SELECT Id, Username, UserRoleId FROM User WHERE (Profile.Name = 'CSSNA Community Profile' OR Profile.Name = 'CSSNAStore Community Profile') and IsActive = true LIMIT 1];
        u.UserRoleId = userRole_1.Id;
        //update u;        
        
        orderObj.OwnerId = u.id;
        
        ccrz__E_Cart__c cartObj = new ccrz__E_Cart__c();
        insert cartObj;
        cartObj.OwnerId = u.Id;
       
        Test.startTest();
        System.runAs(u) {
            dbu_UserValidation.validateUser(orderObj.Id); 
            dbu_UserValidation.validateUserForCart(cartObj.Id);
        }
        Test.stopTest();
    }
    @isTest
    public static void validateUserTest1(){
        ccrz__E_Order__c orderObj1 = new ccrz__E_Order__c();
        //String uniqueUserName = 'standarduser1' + DateTime.now().getTime() + '@testorg.com';
        //Profile p = [SELECT Id FROM Profile WHERE Name='IAM User'];        
        //User u = new User(Alias = 'Usr', Email='standarduser@testorg.com',
        //EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
        //LocaleSidKey='en_US',ProfileId = p.Id,
        //TimeZoneSidKey='America/Los_Angeles',
        //UserName=uniqueUserName);
        
        UserRole userRole_1 = [SELECT Id FROM UserRole WHERE DeveloperName = 'CEO' LIMIT 1];
       // user u = [select id,Contactid from User where Email = 'xyztestuser@gmail.com'];
        Profile profile_1 = [SELECT Id FROM Profile LIMIT 1];
        User u = [SELECT Id, Username,UserType, UserRoleId FROM User WHERE IsActive = true LIMIT 1];
        system.debug('u.UserType ' + u.UserType);
        u.UserRoleId = userRole_1.Id;
        //update u;        
        
        
        orderObj1.OwnerId = u.id;
        
        Test.startTest();
        System.runAs(u) {
            dbu_UserValidation.validateUser(orderObj1.Id); 
            dbu_UserValidation.validateUserForCart('12345');
        }
        Test.stopTest();
    }
    @isTest
    public static void validateUserTest2(){
        ccrz__E_Order__c orderObj1 = new ccrz__E_Order__c();
        insert orderObj1;
        
        //UserRole userRole_1 = [SELECT Id FROM UserRole WHERE DeveloperName = 'CEO' LIMIT 1];
        //Profile profile_1 = [SELECT Id FROM Profile WHERE name = 'IAM User' LIMIT 1];
        //User usr = [SELECT Id, Username, UserRoleId FROM User WHERE Profile.Name = 'IAM User' and IsActive = true LIMIT 1];
        //usr.UserRoleId = userRole_1.Id;
        
        UserRole userRole_1 = [SELECT Id FROM UserRole WHERE DeveloperName = 'CEO' LIMIT 1];
        Profile profile_1 = [SELECT Id FROM Profile WHERE name = 'IAM User' LIMIT 1];
        User u = [SELECT Id, Username, UserRoleId FROM User WHERE Profile.Name = 'IAM User' and IsActive = true LIMIT 1];
        u.UserRoleId = userRole_1.Id;
        //update u;        
        
        
        
        orderObj1.OwnerId = u.id;
        
        Test.startTest();
        System.runAs(u) {
            System.debug('Current User: ' + UserInfo.getUserType());
            System.debug('Current Profile: ' + UserInfo.getProfileId());
            dbu_UserValidation.validateUser(orderObj1.Id); 
            //dbu_UserValidation.validateUserForCart('12345');
        }
        Test.stopTest();
    }
}