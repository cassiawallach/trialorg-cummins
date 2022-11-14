@isTest
public class CSS_LoginUserCacheVariables_Test {
   
    static testMethod void myTest() {
    
    Profile p = [SELECT Id FROM Profile WHERE Name='Standard User']; 
        User u = new User(Alias = 'standt1', Email='standardusernandigam1@testorg.com', 
            EmailEncodingKey='UTF-8', LastName='Testing111', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName='standardusernandigamsas111@testorg.com',User_Location__c='test-P12345');
          insert u;
          Account a=new Account();
        a.name='name';
        a.CSS_DistributorCode__c='test';
        a.IAM_Service_Provider_Code__c='P12345';
        a.Type='Dealer Account';
        a.Region__c = 'US and Canada';
        a.CMI_Account_Status__c = 'Active';
        a.IAM_Service_Provider_Code__c = '562551';
		a.BMS_Enabled__c = true;
        insert a;
            System.runAs(u){
            
            
         Test.startTest();
       
        CSS_LoginUserCacheVariables.getUserAttributes();
        CSS_LoginUserCacheVariables.addLocations('test-P12345678901244','test',u.Id,'profile');
                CSS_LoginUserCacheVariables loginuser = new CSS_LoginUserCacheVariables();
                CSS_LoginUserCacheVariables.getUnitTypeSubTyp('test');
        Test.stopTest();
        
        }
        }
    //written this method to cover else part
    static testMethod void myTest1(){
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User']; 
        User u = new User(Alias = 'standt1', Email='standarduser1@testorg.com', 
            EmailEncodingKey='UTF-8', LastName='Testing111', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName='standardusertest111@testorg.com',User_Location__c='test-S12345');
          insert u;
          
          CSS_UserLocation__c  usloc = new CSS_UserLocation__c (UserId__c=u.id,Location_code__c='test-S12345',isActive__c=true);
          insert usloc ;
        CSS_LoginUserCacheVariables.addLocations('test-S12345678901244','test',u.Id,'profile');
        Set<String> locIds = new Set<String>();
        locIds.add('test-S12345678901244');
        locIds.add('test-S12345678901244');
        locIds.add('test-S12345678901244');
        CSS_LoginUserCacheVariables.addUsersToQueues(locIds);
    }
    
    
    //written this method to cover else part
    static testMethod void myTest2(){
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User']; 
        User u = new User(Alias = 'standt1', Email='standarduser1@testorg.com', 
            EmailEncodingKey='UTF-8', LastName='Testing111', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName='standardusertester111@testorg.com',User_Location__c='test-P12345');
          insert u;
          
          CSS_UserLocation__c  usloc = new CSS_UserLocation__c (UserId__c=u.id,Location_code__c='test-P12345',isActive__c=true);
          insert usloc ;
        CSS_LoginUserCacheVariables.addLocations('test-P12345678901244','test',u.Id,'profile');
    }
    
    
     static testMethod void myTest3() {
    
    Profile p = [SELECT Id FROM Profile WHERE Name='Standard User']; 
        User u = new User(Alias = 'standt1', Email='standarduser1@testorg.com', 
            EmailEncodingKey='UTF-8', LastName='Testing111', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName='standardusersasi111@testorg.com',User_Location__c='test-S12345');
          insert u;
           Account a=new Account();
        a.name='name';
        a.CSS_DistributorCode__c='test';
        a.IAM_Service_Provider_Code__c='S12345';
         a.Type='Dealer Account';
         a.Region__c = 'US and Canada';
        a.CMI_Account_Status__c = 'Active';
        a.IAM_Service_Provider_Code__c = '562551';

        insert a;
            System.runAs(u){
            
           
         Test.startTest();
       
       
        CSS_LoginUserCacheVariables.addLocations('test-S12345678901244','test',u.Id,'profile');
        Test.stopTest();
        
        }
        }
   }