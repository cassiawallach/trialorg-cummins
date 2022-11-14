/**********************************************************************
Name:EVL_UpdateUserLocations_Test
Copyright © 2022  Cummins
======================================================
======================================================
Purpose:                                                            
------- Test class for EVL_UpdateUserLocations
======================================================
======================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE               DETAIL                                
1.0 -   Ramya Sanikommu    06/15/2022       INITIAL DEVELOPMENT(VGRS2-614)
***********************************************************************/
@isTest
public class EVL_UpdateUserLocations_Test {
    @testSetup static void dataSetup() 
    {
        Profile p = [SELECT Id FROM Profile WHERE Name='CSS_Service_Advanced']; 
        User u = new User(Alias = 'standt', Email='standarduser4@testorg.com', 
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US',  ProfileId = p.Id, 
                          TimeZoneSidKey='America/Los_Angeles', UserName='UtilityTestUser4@testorg.com',User_Location__c = '56270-56255');
        insert u;
        
        Account acc = new Account();
        acc.name='562';
        acc.CSS_DistributorCode__c='56270';
        acc.IAM_Service_Provider_Code__c='56270';
        acc.Enable_Claims__c = true;
        acc.IAM_Service_Provider_Code__c = '56255';
        acc.Type = 'Customer';
        acc.CSS_DBCode__c = '33333';
        acc.Region__c = 'US and Canada';
        acc.CMI_Account_Status__c = 'Active';
        acc.ownerid=u.id;
        insert acc;
        
        CSS_UserLocation__c userLocation = new CSS_UserLocation__c(AccountId__c=acc.id,isActive__c=true,isPrimary__c=true,UserId__c=userInfo.getUserId(),Location_code__c='56270-56255',Location_Source__c = 'ARF',isClaims__c = true);
        insert userLocation;
        
        Group grp = new Group(Name='JQ-111-111', Type='Queue');
        insert grp;
        
    }
    
    //
    public static testmethod void InactivateLocUsers(){
        List<List<String>> locs = new List<List<String>>();
        List<String> strLocation = new List<String>();
        strLocation.add('56270-56255');
        locs.add(strLocation);
        Test.startTest();
        	EVL_UpdateUserLocations.getUserLocations(locs);
        Test.stopTest();
        List<CSS_UserLocation__c> locUser = [Select Id,isActive__c,isPrimary__c from CSS_UserLocation__c where Location_code__c='56270-56255' ];
        System.assertEquals(false, locUser[0].isActive__c, 'User Inactivated');
        
    }

}