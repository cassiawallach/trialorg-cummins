//Test Class for OSM_SW_EffectiveAccountModalCtrl
//updated by Sangeeta 27th/04/2021
//Update by Karthik Raj G 05/24/2022 -Mp854 details
@isTest
public class OSM_SW_EffectiveAccountModalCtrl_Test {
    
    static testMethod void EffectiveAccountModalCtrl_Test(){
     TestProductSetupReq testProductSetupReq1=OSM_TestDataCreationUtility.populatedTestProductSetupReq();
      TestCompletedTransactionSetUpRes testCompletedTransactionSetUpRes1=OSM_TestDataCreationUtility.createProductSetUp(testProductSetupReq1);
      Account account=testCompletedTransactionSetUpRes1.objSetupDate.account;
      account.PaymentType__c = 'CHARGE';
      account.BMSAvailableCredit__c=500;
      account.BMS_Customer_ID__c ='1234';
      test.StartTest();
       User usr = [Select id from User where Id = :UserInfo.getUserId()];
      Id portal_PROFILE_ID = [SELECT Id FROM Profile WHERE Name = 'IAM_Site_Admin_Community' Limit 1 ].Id;
       UserRole portalRole = [Select Id From UserRole Where PortalType = 'None' Limit 1];
       Profile profile1 = [Select Id from Profile where name = 'System Administrator'];
        User portalAccountOwner2 = new User(
        UserRoleId = portalRole.Id,
        ProfileId = profile1.Id,
        Username ='test24446@test.com',
        Alias = 'batman',
        Email='bruce.wayne@wayneenterprises.com',
        EmailEncodingKey='UTF-8',
        Firstname='Bruce',
        Lastname='Wayne',
        LanguageLocaleKey='en_US',
        LocaleSidKey='en_US',
        TimeZoneSidKey='America/Chicago'
        );
        Database.insert(portalAccountOwner2);
        Account portalAccount1 = new Account(
        Name = 'TestAccount',
        OwnerId = portalAccountOwner2.Id,
        
        BMS_Customer_ID__c='1234'
        );
        System.runAs(portalAccountOwner2){
            Database.insert(portalAccount1);
        }

        //Create contact
        Contact contact1 = new Contact(
        FirstName = 'Test999',
        Lastname = 'McTesty999',
        Username__c = 'testUserName999@gmail.com',
        AccountId = portalAccount1.Id,
        IAM_Contact_Status__c='Pending',
        IAM_Contact_Owner__c= usr.id,   
        Email ='test@999test.com'
        );
        System.runAs(portalAccountOwner2){
            Database.insert(contact1);
        }
        User testUser = new User();
        testUser.FirstName = 'Testttt';
        testUser.LastName = 'lasttt';
        testUser.UserName = 'test299@test.com';
        testUser.Email = 'bruce.wayne@wayneenterprises.com';
        testUser.Alias = 'batman';
        testUser.ContactId = contact1.Id;
        testUser.CommunityNickname = 'test12345zxcw';
        testUser.ProfileId =portal_PROFILE_ID;
        testUser.TimeZoneSidKey = 'America/Los_Angeles';
        testUser.isActive = true;
        testUser.LocaleSidKey = 'en_US';
        testUser.LanguageLocaleKey = 'en_US';
        testUser.EmailEncodingKey = 'ISO-8859-1';
        //testUser.UserRoleId = portalRole.Id;
        System.runAs(portalAccountOwner2){
        insert testUser;
          
        }
         
     System.RunAs(usr)
     {                 
         try{          
          //test.StartTest();
          ccrz.cc_RemoteActionContext objRemotCtx = new ccrz.cc_RemoteActionContext();
          objRemotCtx.storefront='SoftwareStore';
          objRemotCtx.currentCartId=testCompletedTransactionSetUpRes1.cart.ccrz__EncryptedId__c;
          objRemotCtx.portalUserId=testUser.id;
           
          OSM_SW_EffectiveAccountModalCtrl ctrl= new OSM_SW_EffectiveAccountModalCtrl();
          ctrl.showEffectiveAccount=true;
          OSM_SW_EffectiveAccountModalCtrl.getContactsList(objRemotCtx, portalAccount1.id);
          OSM_SW_EffectiveAccountModalCtrl.updateLatestContact(objRemotCtx, contact1.id, portalAccount1.id);
          test.StopTest();
          }
          catch(Exception ex){}
      }
  }
    
    
    static testMethod void EffectiveAccountModalCtrl_Test1(){
        ccrz.cc_RemoteActionContext objRemotCtx = new ccrz.cc_RemoteActionContext();
          objRemotCtx.storefront='SoftwareStore';
        OSM_SW_EffectiveAccountModalCtrl ctrl= new OSM_SW_EffectiveAccountModalCtrl();
          ctrl.showEffectiveAccount=true;
          OSM_SW_EffectiveAccountModalCtrl.getContactsList(objRemotCtx, null);
          OSM_SW_EffectiveAccountModalCtrl.updateLatestContact(objRemotCtx, null, null);
        
    }

}