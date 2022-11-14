/**********************************************************************
Name:EVL_LoginUserCacheVariables
Copyright © 2020  Cummins
======================================================
======================================================
Purpose: Test Classes for EVL_LoginUserCacheVariables                                                       
======================================================
======================================================
History                                                            
VERSION  	AUTHOR            			DATE                DETAIL                                 
1.0 	 	Krishnamoorthi N			06/26/2020			INITIAL DEVELOPMENT 
***********************************************************************/
@IsTest
public class EVL_LoginUserCacheVariables_Test {
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
            EVL_LoginUserCacheVariables.getUserAttributes();
            EVL_LoginUserCacheVariables.addLocations('test-P12345678901244','test',u.Id,'profile');
            Test.stopTest();
        
        }
    }
    
    static testMethod void myTest1(){
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User']; 
        User u = new User(Alias = 'standt1', Email='standarduser1@testorg.com', 
            EmailEncodingKey='UTF-8', LastName='Testing111', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName='standardusertest111@testorg.com',User_Location__c='test-S12345');
        insert u;
          
        CSS_UserLocation__c  usloc = new CSS_UserLocation__c (UserId__c=u.id,Location_code__c='test-S12345',isActive__c=true);
        insert usloc ;
        EVL_LoginUserCacheVariables.addLocations('test-S12345678901244','test',u.Id,'profile');
        Set<String> locIds = new Set<String>();
        locIds.add('test-S12345678901244');
        locIds.add('test-S12345678901244');
        locIds.add('test-S12345678901244');
    }
    
    static testMethod void myTest2(){
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User']; 
        User u = new User(Alias = 'standt1', Email='standarduser1@testorg.com', 
            EmailEncodingKey='UTF-8', LastName='Testing111', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName='standardusertester111@testorg.com',User_Location__c='test-P12345');
        insert u;
          
        CSS_UserLocation__c  usloc = new CSS_UserLocation__c (UserId__c=u.id,Location_code__c='test-P12345',isActive__c=true);
        insert usloc ;
        EVL_LoginUserCacheVariables.addLocations('test-P12345678901244','test',u.Id,'profile');
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
       		EVL_LoginUserCacheVariables.addLocations('test-S12345678901244','test',u.Id,'profile');
        	Test.stopTest();
        }
    }

    static testMethod void myTest4() {
    	
        Account a=new Account();
        a.name='name';
        a.CSS_DistributorCode__c='test';
        a.IAM_Service_Provider_Code__c='S12345';
        a.Type='Dealer Account';
        a.Region__c = 'US and Canada';
        a.CMI_Account_Status__c = 'Active';
        //a.IAM_Service_Provider_Code__c = '88888';
        insert a;
        
        contact con = new contact();
        con.lastName='Krishna';
        con.FirstName = 'Moorthi';
        con.AccountId = a.Id;
        insert con;
        
    	Profile p = [SELECT Id FROM Profile WHERE Name='EVL_Dealer_Advanced']; 
        User u = new User(Alias = 'standt1', Email='standarduser1@testorg.com', 
            EmailEncodingKey='UTF-8', LastName='Testing111', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p.Id, contactId = con.Id,
            TimeZoneSidKey='America/Los_Angeles', UserName='standardusersasi111@testorg.com',User_Location__c='test-S12345');
        insert u;
        
        CSS_UserLocation__c  usloc = new CSS_UserLocation__c (UserId__c=u.id,Location_code__c='test-S12345',isActive__c=true);
        insert usloc ;
        
        Set<String> locIds = new Set<String>();
        locIds.add('test-S12345');

        System.runAs(u){
        	Test.startTest();
       		EVL_LoginUserCacheVariables.addUsersToQueues(locIds);
        	Test.stopTest();
        }
    }
}