@isTest(SeeAllData = True)
public class CSS_Service_Job_Sharing_Test {
    public static testMethod void testShare() {
       // test.startTest();
        Profile p = [SELECT Id FROM Profile WHERE Name='CSS_Service_Supervisor' LIMIT 1];
        UserRole ur = [SELECT id 
                       from UserRole 
                       WHERE PortalType = 'None' LIMIT 1];
        User newUser = new User( Alias = 'standt', Email='test1@gmail.com', UserRoleId = ur.Id ,
                                EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                                LocaleSidKey='en_US', ProfileId = p.Id, 
                                TimeZoneSidKey='America/Los_Angeles', UserName='test11newUser@gmail.com');
        
        User newUserA = new User(Alias = 'standtA', Email='test1A@gmail.com', UserRoleId = ur.Id ,
                                 EmailEncodingKey='UTF-8', LastName='TestingA', LanguageLocaleKey='en_US', 
                                 LocaleSidKey='en_US', ProfileId = p.Id, 
                                 TimeZoneSidKey='America/Los_Angeles', UserName='test11AQnewUser@gmail.com');
        User newUserB = new User(Alias = 'standtA', Email='test1A@gmail.com', UserRoleId = ur.Id ,
                                 EmailEncodingKey='UTF-8', LastName='TestingA', LanguageLocaleKey='en_US', 
                                 LocaleSidKey='en_US', ProfileId = p.Id, 
                                 TimeZoneSidKey='America/Los_Angeles', UserName='test11AQnewUser2@gmail.com');
        
        insert newUser;
        insert newUserA;
        insert newUserB;
        Contact contact1;
        Contact contact2;
        Contact contact3;
        Contact contact4;
        Account newAccount1;
        Account newAccount2;
        AccountTeamMember newAccount1TeamMember;
        AccountTeamMember newAccount1TeamMember2;
        System.runAs(newUser) {
            
            // Creating Accounts
            newAccount1 = new Account(ownerId=newUser.id,Name='account1');
            insert newAccount1;
            
            newAccount1TeamMember = new AccountTeamMember(UserId = newUserA.Id, AccountId = newAccount1.Id, TeamMemberRole = 'HQ Oversight');
            insert newAccount1TeamMember;
            
            newAccount1TeamMember2 = new AccountTeamMember(UserId = newUserB.Id, AccountId = newAccount1.Id, TeamMemberRole = 'HQ Oversight');
            insert newAccount1TeamMember2;
            
            newAccount2 = new Account(ownerId=newUser.id,Name='account2',parentid=newAccount1.Id);
            insert newAccount2;
            // }
            // }
            // System.runAs(newUserA) {
            //Creating Contacts
            contact1 = new Contact(ownerId=newUser.id, LastName = 'lastname',accountID=newAccount1.id);
            insert contact1;
            
            contact2 = new Contact(ownerId=newUser.id, LastName = 'lastname',accountID=newAccount1.id);
            insert contact2;
            
            contact3 = new Contact(ownerId=newUser.id, LastName = 'lastname',accountID=newAccount2.id);
            insert contact3;
            
            contact4 = new Contact(ownerId=newUser.id, LastName = 'lastname',accountID=newAccount2.id);
            insert contact4;
        }
        //Creating Community Users
        profile p1 = [SELECT Id FROM Profile WHERE UserType = 'PowerCustomerSuccess' LIMIT 1];
        
        User newUser1 = new User(Alias = 'standt1', Email='test1@gmail.com', 
                                 EmailEncodingKey='UTF-8', LastName='Testing1', LanguageLocaleKey='en_US', 
                                 LocaleSidKey='en_US', ProfileId = p1.Id, 
                                 TimeZoneSidKey='America/Los_Angeles', UserName='test12newUser@gmail.com',contactid = contact1.id);
        insert newUser1;
        
        User newUser2 = new User(Alias = 'standt2', Email='test1@gmail.com', 
                                 EmailEncodingKey='UTF-8', LastName='Testing2', LanguageLocaleKey='en_US', 
                                 LocaleSidKey='en_US', ProfileId = p1.Id, 
                                 TimeZoneSidKey='America/Los_Angeles', UserName='test13newUser@gmail.com', contactid = contact2.id);
        insert newUser2;       
        User newUser3 = new User(Alias = 'standt3', Email='test1@gmail.com', 
                                 EmailEncodingKey='UTF-8', LastName='Testing3', LanguageLocaleKey='en_US', 
                                 LocaleSidKey='en_US', ProfileId = p1.Id,
                                 TimeZoneSidKey='America/Los_Angeles', UserName='test14newUser@gmail.com', contactid = contact3.id);
        insert newUser3;
        
        User newUser4 = new User(Alias = 'standt4', Email='test1@gmail.com', 
                                 EmailEncodingKey='UTF-8', LastName='Testing4', LanguageLocaleKey='en_US', 
                                 LocaleSidKey='en_US', ProfileId = p1.Id,
                                 TimeZoneSidKey='America/Los_Angeles', UserName='test15newUser@gmail.com',contactid = contact4.id);
        insert newUser4;
        
     //   User supuser  = [select Id,AccountId, userName, profile.name,User_Location__c from User where profile.name like '%Supervisor%' and AccountId!= null and User_Location__c!=null and isActive=true  limit 1];
        
        //User supuseraccountnull  = [select Id,AccountId, userName, profile.name,User_Location__c from User where profile.name like '%SUPERVISOR%' and AccountId = null and isActive=true  limit 1];
        
        //Creating Job Order       
        System.runAs(newUser1){
            CSS_Job_Order__c job1 = new CSS_Job_Order__c(ownerId = newUser1.id,Customer_Name__c='varun');
            insert job1;
        }
        
        System.runAs(newUser3){
            CSS_Job_Order__c job2 = new CSS_Job_Order__c(ownerId = newUser3.id,Customer_Name__c='gyan');
            insert job2;
        }
        
        
    } 
    public static testMethod void testDealerScenario(){
        Profile p = [SELECT Id,Name FROM Profile WHERE Name ='CSS_Service_Supervisor' LIMIT 1];
        UserRole ur = [SELECT id from UserRole WHERE PortalType = 'None' LIMIT 1];
        User newUser = new User( Alias = 'standt', Email='testingAdmin@gmail.com', UserRoleId = ur.Id ,
                                EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                                LocaleSidKey='en_US', ProfileId = p.Id, isActive = true,
                                TimeZoneSidKey='America/Los_Angeles', UserName='test11newUser1@gmail.com',User_Location__c = 'SameLocation'); 
        insert newUser;        
        Contact contact1;
        Contact contact2;
        Contact contact3;
        Contact contact4;
        Account newAccount1;
        Account newAccount2;
        AccountTeamMember newAccount1TeamMember;          
        System.runAs(newUser) {
            
            // Creating Accounts
            newAccount1 = new Account(ownerId=newUser.id,Name='account1');
            insert newAccount1;
            
            newAccount1TeamMember = new AccountTeamMember(UserId = newUser.Id, AccountId = newAccount1.Id, TeamMemberRole = 'HQ Oversight');
            insert newAccount1TeamMember;
            
            newAccount2 = new Account(ownerId=newUser.id,Name='account2',parentid=newAccount1.Id);
            insert newAccount2;
            contact1 = new Contact(ownerId=newUser.id, LastName = 'lastname',accountID=newAccount1.id);
            insert contact1;
            
            contact2 = new Contact(ownerId=newUser.id, LastName = 'lastname',accountID=newAccount1.id);
            insert contact2;
            
            contact3 = new Contact(ownerId=newUser.id, LastName = 'lastname',accountID=newAccount2.id);
            insert contact3;
            
            contact4 = new Contact(ownerId=newUser.id, LastName = 'lastname',accountID=newAccount2.id);
            insert contact4;
        }
        User portalUser1;
        User portalUser2;       
        Profile profile1 = [SELECT Id,Name FROM Profile WHERE Name ='CSS_Dealer_Advanced' LIMIT 1];                                
        Profile profile2 = [SELECT Id,Name FROM Profile WHERE Name ='CSS_Dealer_Technician' LIMIT 1];        
        portalUser1 = new User( Alias = 'standt', Email='test1@gmail.com', 
                               EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                               LocaleSidKey='en_US', ProfileId = profile1.Id, isActive = true,
                               TimeZoneSidKey='America/Los_Angeles', UserName='testdelaer1@gmail.com',
                               User_Location__c = 'Location1',ContactId = contact1.Id);
        insert portalUser1;            
        portalUser2 = new User( Alias = 'standt', Email='test1@gmail.com',
                               EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                               LocaleSidKey='en_US', ProfileId = profile2.Id, isActive = true,
                               TimeZoneSidKey='America/Los_Angeles', UserName='testdelaer2@gmail.com',
                               User_Location__c = 'Location1',ContactId = contact2.Id);
        insert portalUser2; 
        User loggedInUser = [select Id from User where id = :UserInfo.getUserId() LIMIT 1];    
        User distribUser1;
        User distribUser2;
        system.runAs(loggedInUser){        
            distribUser1 = new User( Alias = 'standt', Email='test1@gmail.com', 
                                    EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                                    LocaleSidKey='en_US', ProfileId = profile2.Id, isActive = true,PortalRole = 'Manager',
                                    TimeZoneSidKey='America/Los_Angeles', UserName='testdistributor1@gmail.com',
                                    User_Location__c = 'Location1',ContactId = contact3.Id);
            insert distribUser1;            
            distribUser2 = new User( Alias = 'standt', Email='test1@gmail.com',
                                    EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                                    LocaleSidKey='en_US', ProfileId = profile2.Id, isActive = true,PortalRole = 'Manager',
                                    TimeZoneSidKey='America/Los_Angeles', UserName='testdistributor2@gmail.com',
                                    User_Location__c = 'Location1',ContactId = contact4.Id);
            insert distribUser2;      
        }
         Group Q = new Group();
            Q.Type = 'Queue';
            //Q.OwnerId=objUser1.id;
            Q.Name = 'JQ'+'-'+'03520-04892';
                insert Q;
            QueueSObject q1 = new QueueSObject(SobjectType='CSS_Job_Order__c', QueueId=Q.Id);
			insert q1;
        System.runAs(portalUser1){
            
            
            CSS_Job_Order__c job1 = new CSS_Job_Order__c(ownerId = portalUser1.id,Customer_Name__c='Anirudh',CSS_Job_Location_Code__c='03520-04892');
            insert job1;            
        }
        System.runAs(distribUser1){
            
            CSS_Job_Order__c job2 = new CSS_Job_Order__c(ownerId = distribUser1.id,Customer_Name__c='Anirudh',CSS_Job_Location_Code__c='03520-04892');
            insert job2;            
        }  
       // test.stopTest();
    }
}