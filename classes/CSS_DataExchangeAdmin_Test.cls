/**********************************************************************
Name:CSS_DataExchangeAdmin_Test
Copyright © 2011  Cummins
======================================================
Purpose:     Test class for CSS_DataExchangeAdmin class                                                       
======================================================
History                                                            
VERSION  AUTHOR            DATE                DETAIL                                 
1.0 -    Rakesh Kumar    04/03/2017      INITIAL DEVELOPMENT  
2.0 -    Vamshi Krishna  04/06/2018      Story-137899 
***********************************************************************/
@IsTest(SeeAllData=false)
public class CSS_DataExchangeAdmin_Test {
    
    Static User adminUser = new User();
    //User user1;
   // Static User user1 = new User();
   Static String recordType_Id = Schema.SObjectType.Account.getRecordTypeInfosByName().get('CSS').getRecordTypeId();     
    @testSetup
    Static void createTestData(){
        adminUser = CSS_TestData.createTestUser(false);
        adminUser.Username ='css-cmi3@cummins.com';
        if(adminUser.Id != null)
            update adminUser;
        Account acc;
        Contact con ;
        List<Account> accList = new List<Account>();
        
        // Creating test data
        system.runAs(adminUser){
            // Create Account Test data  
            acc = new Account(Name='parentAccount', CSS_DistributorCode__c='11111', CSS_DealerCode__c='22222', RecordTypeId=recordType_Id);
            insert acc; //RecordTypeId=recordType_Id
            //system.assertNotEquals(null, acc.Id);
            accList.add(new Account(Name='childAccount1', CSS_DE_Parent__c=acc.Id, RecordTypeId=recordType_Id));
            accList.add(new Account(Name='childAccount2', CSS_DE_Parent__c=acc.Id, RecordTypeId=recordType_Id));
            insert accList;
            //Create contact Test data 
            con = new Contact(LastName = 'Daniel', AccountId = acc.Id);
            insert con; 
            //system.assertNotEquals(null, con.id);
        }
        
        Profile p = [Select Id,Name from Profile where Name = 'CSS_Dealer_Data_ExChange_Admin']; 
        UserRole empRole = [Select Id From UserRole Where PortalType = 'None' Limit 1];
        //Create New User 
        user user1 = new User(
                                Username = System.now().millisecond() + 'test123@cummins.com',
                                ContactId = con.Id,
                                ProfileId = p.Id,
                                //UserRoleId = empRole.Id,
                                PortalRole  = 'Manager',
                                Alias = 'test123',
                                Email = 'test12345@test.com',
                                EmailEncodingKey = 'UTF-8',
                                LastName = 'testUser1',
                                CommunityNickname = 'test12345',
                                TimeZoneSidKey = 'America/Los_Angeles',
                                LocaleSidKey = 'en_US',
                                LanguageLocaleKey = 'en_US'
                            );
        insert user1;
        
    }
    
    // test method to cover the data exchange admin 
  static testMethod void TestMethod1(){
        List<User> userList = [SELECT LastName FROM User WHERE LastName='testUser1'];
        //System.assert(userList.size()>0);
        
        system.runAs(userList[0]){
            
            Test.startTest();
            List<Account> accList = [SELECT Id, Name FROM Account LIMIT 10000];
            //System.assert(accList.size()==3, 'Accounts are not created');
            
            List<Contact> conList = [SELECT Id, Name FROM Contact LIMIT 10000];
            //System.assert(conList.size()==1, 'Contacts are not created');
            
            CSS_DataExchangeAdmin cdea = new CSS_DataExchangeAdmin();
            //system.assert(cdea.accsMap.size()==2, 'Accounts map is not populated');
            //system.assert(cdea.locationsOptions.size()==4, 'Select Options are not created properly');
            
            //Test for single account selection
            for(Account a : cdea.accsMap.values()){
                if(a.Name=='childAccount1'){
                    a.Name = 'childAccount1New';
                    cdea.selectedLocationId = a.Id;
                }
            }
            
            cdea.processSelectedLocation();
            cdea.deSave();
            
            List<Account> accListNew1 = [SELECT Id, Name FROM Account WHERE Name LIKE 'childAccount1%' LIMIT 10000];
            //System.assertEquals('childAccount1New', accListNew1[0].Name, 'Single account not updated correctly');
            
            //Test for selection All
            for(Account a : cdea.accsMap.values()){
                a.Name = a.Name+'New';
            }
            cdea.selectedLocationId = '--Select All--';
            cdea.processSelectedLocation();
            cdea.deSave();
            
            for(Account a : [SELECT Id, Name FROM Account WHERE Id IN :cdea.accsMap.keySet() LIMIT 10000]){
                String tName = a.Name;
                //System.assert(tName.containsIgnoreCase('New'), 'All accounts not updated correctly');
            }
            Test.stopTest();             
        }          
    }

 
}