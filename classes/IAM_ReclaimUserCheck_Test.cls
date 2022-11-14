@isTest
public class IAM_ReclaimUserCheck_Test{
     
    
    static testMethod void Test1(){
        String encryptedText;
        String randomText;
        String externalnumber;
        String randomNumber;
     
           User u=[Select id,isActive from user where profile.name='System Administrator' AND isActive=true Limit 1];
            
            System.runAs(u) {
            //Create account
            Account portalAccount1 = new Account(
            Name = 'TestAccount',
            OwnerId = u.Id,
            RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('IAM').getRecordTypeId()
            );
            Database.insert(portalAccount1);
            
            //Create contact
            Contact contact1 = new Contact(
            FirstName = 'Test',
            Lastname = 'McTesty',
            AccountId = portalAccount1.Id,
            RecordTypeId=Schema.SObjectType.Contact.getRecordTypeInfosByName().get('IAM').getRecordTypeId(),
            Email ='test@test.com',
            IAM_Cummins_login_ID__c =  'testReclaim123@mail.com',
            IAM_Final_Approver__c = 'N',
            IAM_Qsolexpiration__c = 'testABC',
            IAM_swregexpire__c ='testCon',
            IAM_Internal__c = true,
            IAM_Applications__c = 'CSS_DN_Advanced',
            CMI_Contact_Type__c = 'Primary',
            IAM_is_Member_of__c = 'testMemeber'   
            );
            Database.insert(contact1);
            
            //Create user
            Profile portalProfile = [select Id,Name from Profile WHERE Name = 'IAM User' limit 1];
                
            User user1 = new User(
            Username ='your.user@gmail1234.com.iamdev',
            ContactId = contact1.Id,
            ProfileId = portalProfile.Id,
            Alias = 'test123',
            Email = 'test12345@test.com',
            EmailEncodingKey = 'UTF-8',
            LastName = 'McTesty',
            CommunityNickname = 'test12345',
            TimeZoneSidKey = 'America/Los_Angeles',
            LocaleSidKey = 'en_US',
            LanguageLocaleKey = 'en_US',
            IAM_Random_Number__c='123456',
            IAM_UID__c=contact1.IAM_Cummins_login_ID__c
           
            );
           insert user1;
               
             user u11=[select id,IAM_External_User_Num__c,IAM_Random_Number__c from user where Id=:user1.Id];
                
                externalnumber=u11.IAM_External_User_Num__c;
                Blob key = Blob.valueOf('1234567890123456');
                Blob dest=Blob.valueOf(externalnumber);
                Blob encrypted1 = Crypto.encryptWithManagedIV('AES128',key, dest);
                encryptedText = EncodingUtil.base64Encode(encrypted1);
                
                randomNumber=u11.IAM_Random_Number__c;
                Blob key2 = Blob.valueOf('1234567890123456');
                Blob dest2=Blob.valueOf(randomNumber);
                Blob encrypted2 = Crypto.encryptWithManagedIV('AES128',key2, dest2);
                //randomText = encrypted2.toString(); 
                randomText = EncodingUtil.base64Encode(encrypted2);
            }   
        
        Test.startTest();
        
        Test.setCurrentPageReference(new PageReference('Page.IAM_CIHR_Reclaim_User_Check')); 
        //System.currentPageReference().getParameters().put('Username', encryptedText);
        System.currentPageReference().getParameters().put('uNumber', externalnumber);
        
        System.currentPageReference().getParameters().put('randomNumber',randomNumber);
        System.currentPageReference().getParameters().put('appid','123456789');
        System.currentPageReference().getParameters().put('lang','en');
        IAM_ReclaimUserCheck iam=new IAM_ReclaimUserCheck();
        
        PageReference pppp=iam.send_reclaim_userCheck();
          
        Test.stopTest();
                
            
    }
    static testMethod void Test2(){
        String encryptedText;
        String randomText;
        String externalnumber;
        String randomNumber;
     
           User u=[Select id,isActive from user where profile.name='System Administrator' AND isActive=true Limit 1];
            
            System.runAs(u) {
            //Create account
            Account portalAccount1 = new Account(
            Name = 'TestAccount',
            OwnerId = u.Id,
            RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('IAM').getRecordTypeId()
            );
            Database.insert(portalAccount1);
            
            //Create contact
            Contact contact1 = new Contact(
            FirstName = 'Test',
            Lastname = 'McTesty',
            AccountId = portalAccount1.Id,
            RecordTypeId=Schema.SObjectType.Contact.getRecordTypeInfosByName().get('IAM').getRecordTypeId(),
            Email ='test@test.com',
            IAM_Cummins_login_ID__c =  'testReclaim123@mail.com',
            IAM_Final_Approver__c = 'N',
            IAM_Qsolexpiration__c = 'testABC',
            IAM_swregexpire__c ='testCon',
            IAM_Internal__c = true,
            IAM_Applications__c = 'CSS_DN_Advanced',
            CMI_Contact_Type__c = 'Primary',
            IAM_is_Member_of__c = 'testMemeber'   
            );
            Database.insert(contact1);
            
            //Create user
            Profile portalProfile = [select Id,Name from Profile WHERE Name = 'IAM User' limit 1];
                
            User user1 = new User(
            Username ='your.user@gmail1234.com.iamdev',
            ContactId = contact1.Id,
            ProfileId = portalProfile.Id,
            Alias = 'test123',
            Email = 'test12345@test.com',
            EmailEncodingKey = 'UTF-8',
            LastName = 'McTesty',
            CommunityNickname = 'test12345',
            TimeZoneSidKey = 'America/Los_Angeles',
            LocaleSidKey = 'en_US',
            LanguageLocaleKey = 'en_US',
            IAM_Random_Number__c='123456',
            IAM_UID__c=contact1.IAM_Cummins_login_ID__c
           
            );
           insert user1;
               
             user u11=[select id,IAM_External_User_Num__c,IAM_Random_Number__c from user where Id=:user1.Id];
                
                externalnumber=u11.IAM_External_User_Num__c;
                Blob key = Blob.valueOf('1234567890123456');
                Blob dest=Blob.valueOf(externalnumber);
                Blob encrypted1 = Crypto.encryptWithManagedIV('AES128',key, dest);
                encryptedText = EncodingUtil.base64Encode(encrypted1);
                
                randomNumber=u11.IAM_Random_Number__c;
                Blob key2 = Blob.valueOf('1234567890123456');
                Blob dest2=Blob.valueOf(randomNumber);
                Blob encrypted2 = Crypto.encryptWithManagedIV('AES128',key2, dest2);
                //randomText = encrypted2.toString(); 
                randomText = EncodingUtil.base64Encode(encrypted2);
            }   
        
        Test.startTest();
        
        Test.setCurrentPageReference(new PageReference('Page.IAM_CIHR_Reclaim_User_Check')); 
        System.currentPageReference().getParameters().put('Username', encryptedText);
        //System.currentPageReference().getParameters().put('uNumber', externalnumber);
        
        System.currentPageReference().getParameters().put('randomNumber',randomText);
        System.currentPageReference().getParameters().put('appid','123456789');
        System.currentPageReference().getParameters().put('lang','en');
        IAM_ReclaimUserCheck iam=new IAM_ReclaimUserCheck();
        
        PageReference pppp=iam.send_reclaim_userCheck();
          
        Test.stopTest();
                
            
    }
}