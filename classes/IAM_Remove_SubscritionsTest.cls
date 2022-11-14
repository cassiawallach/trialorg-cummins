@isTest
public class IAM_Remove_SubscritionsTest{

    @TestSetup
    Static void InitData(){
    Account accSampleRecord = new Account(name='AccountTest1',
                                   CMI_Account_Status__c='Pending',
                                   CMI_CDA_Status__c='New Customer Request',
                                   Type='Dealer Account');
    
    insert accSampleRecord;
    
    Account accSampleRecord2 = new Account(name='AccountTest2',
                                   CMI_Account_Status__c='Pending',
                                   CMI_CDA_Status__c='New Customer Request');
    
    insert accSampleRecord2;
    
    Account accSampleRecord3 = new Account(name='AccountTest3',
                                   CMI_Account_Status__c='Inactive',
                                   CMI_CDA_Status__c='New Customer Request');
    
    insert accSampleRecord3;
    
    
    Contact contSampleRecord = new Contact(
        FirstName = 'Test',
        LastName ='User',
        Email = 'lstTest@test.com',
        AccountId = accSampleRecord.ID,
        IAM_Contact_Status__c = 'Active',
        CMI_Contact_Type__c = 'Primary',
        Username__c= 'Amartest@abc.com',
        Phone = '9743800309'
    );
    
    insert contSampleRecord;
    
    Contact contSampleRecord1 = new Contact(
        FirstName = 'Test02',
        LastName ='User02',
        Email = 'lstTest2323@test.com',
        AccountId = accSampleRecord3.ID,
        IAM_Contact_Status__c = 'Active',
        CMI_Contact_Type__c = 'Primary',
        Username__c= 'Amartest213@abc.com',
        Phone = '9743800309'
    );
    
    insert contSampleRecord1;
    
    // Profile id of 'IAM_Site_Admin_Community'
    //String profId = '00eZ0000000FMDr';
    Id profId  = [SELECT Id,Name FROM Profile Where name = 'IAM_Site_Admin_Community'].Id;
    
   
    
    IAM_Application__c iamAppSampleRecord = new IAM_Application__c(    
        IAM_Account_Name__c = accSampleRecord.ID,
        IAM_Application_Name__c = 'EDS',
        IAM_Role__c='EDS_ADMIN_USER',
        IAM_Status__c='Active',
        IAM_Subscription_Count__c= 10,
        IAM_Provisioned_User_Count__c=5,
        IAM_Subscription_End_Date__c= System.today() + 5,
        IAM_Subscription_Name__c='TestSubscription1',
        IAM_Free_Subscription__c= False,
        IAM_Subscription_Start_Date__c=System.today()
    );
    insert iamAppSampleRecord ;
    
    IAM_Application__c cumpasApplication = new IAM_Application__c(    
        IAM_Account_Name__c = accSampleRecord.ID,
        IAM_Application_Name__c = 'CUMPAS 2.0',
        IAM_Role__c='Dealer User',
        IAM_Status__c='Active',
        IAM_Subscription_Count__c= 10,
        IAM_Provisioned_User_Count__c=5,
        IAM_Subscription_End_Date__c= System.today() + 5,
        IAM_Subscription_Name__c='TestSubscription1',
        IAM_Free_Subscription__c= False,
        IAM_Subscription_Start_Date__c=System.today()
    );
    
    insert cumpasApplication;
    
    IAM_Application__c connectedSolApplication = new IAM_Application__c(    
        IAM_Account_Name__c = accSampleRecord.ID,
        IAM_Application_Name__c = 'Connected Solutions',
        IAM_Role__c='PrimaryContact',
        IAM_Status__c='Active',
        IAM_Subscription_Count__c= 10,
        IAM_Provisioned_User_Count__c=5,
        IAM_Subscription_End_Date__c= System.today() + 5,
        IAM_Subscription_Name__c='TestSubscription1',
        IAM_Free_Subscription__c= False,
        IAM_Subscription_Start_Date__c=System.today()
    );
    
    insert connectedSolApplication;
    
    IAM_Application__c connectedSolApplication02 = new IAM_Application__c(    
        IAM_Account_Name__c = accSampleRecord3.ID,
        IAM_Application_Name__c = 'Connected Solutions',
        IAM_Role__c='PrimaryContact',
        IAM_Status__c='Inactive',
        IAM_Subscription_Count__c= 10,
        IAM_Provisioned_User_Count__c=5,
        IAM_Subscription_End_Date__c= System.today() + 5,
        IAM_Subscription_Name__c='TestSubscription1',
        IAM_Free_Subscription__c= False,
        IAM_Subscription_Start_Date__c=System.today()
    );
    
    insert connectedSolApplication02;
    
    IAM_Application__c connectedSolApplication03 = new IAM_Application__c(    
        IAM_Account_Name__c = accSampleRecord3.ID,
        IAM_Application_Name__c = 'Connected Solutions',
        IAM_Role__c='PrimaryContact',
        IAM_Status__c='Active',
        IAM_Subscription_Count__c= 10,
        IAM_Provisioned_User_Count__c=5,
        IAM_Subscription_End_Date__c= System.today() + 5,
        IAM_Subscription_Name__c='TestSubscription234',
        IAM_Free_Subscription__c= False,
        IAM_Subscription_Start_Date__c=System.today()
    );
    
    insert connectedSolApplication03;
    
    IAM_Application__c connectedSolApplication04 = new IAM_Application__c(    
        IAM_Account_Name__c = accSampleRecord3.ID,
        IAM_Application_Name__c = 'Marketplace',
        IAM_Role__c='OSM Sales User',
        IAM_Status__c='Active',
        IAM_Subscription_Count__c= 10,
        IAM_Provisioned_User_Count__c=5,
        IAM_Subscription_End_Date__c= System.today() + 5,
        IAM_Subscription_Name__c='TestSubscription3997',
        IAM_Free_Subscription__c= False,
        IAM_Subscription_Start_Date__c=System.today()
    );
    
    insert connectedSolApplication04;
    
    IAM_Application__c GuidanzApplication02 = new IAM_Application__c(    
        IAM_Account_Name__c = accSampleRecord.ID,
        IAM_Application_Name__c = 'Guidanz',
        IAM_Role__c='Advanced',
        IAM_Status__c='Active',
        IAM_Subscription_Count__c= 10,
        IAM_Provisioned_User_Count__c=5,
        IAM_Subscription_End_Date__c= System.today() + 5,
        IAM_Subscription_Name__c='TestSubscription1',
        IAM_Free_Subscription__c= False,
        IAM_Subscription_Start_Date__c=System.today()
    );
    
    insert GuidanzApplication02;
    
    IAM_Application__c MarketplaceApplication02 = new IAM_Application__c(    
        IAM_Account_Name__c = accSampleRecord.ID,
        IAM_Application_Name__c = 'Marketplace',
        IAM_Role__c='OSM Business Admin',
        IAM_Status__c='Active',
        IAM_Subscription_Count__c= 10,
        IAM_Provisioned_User_Count__c=5,
        IAM_Subscription_End_Date__c= System.today() + 5,
        IAM_Subscription_Name__c='TestSubscription1',
        IAM_Free_Subscription__c= False,
        IAM_Subscription_Start_Date__c=System.today()
    );
    
    insert MarketplaceApplication02;
    
    

 IAM_Contact_Provisioning__c iamContSampleRecord = new IAM_Contact_Provisioning__c(
        IAM_Account_Application__c = iamAppSampleRecord.ID,
        RecordTypeId = Schema.SObjectType.IAM_Contact_Provisioning__c.getRecordTypeInfosByName().get('CUMPAS 2.0').getRecordTypeId(),
        IAM_Application_Name__c = 'CUMPAS 2.0',
        IAM_Contact__c= contSampleRecord.Id,
        IAM_End_Date__c= System.today() + 5,
        IAM_Role__c='Dealer User',
        IAM_Start_Date__c=System.today(),
        IAM_Status__c='Active'
        //recordtypeid = Schema.SObjectType.IAM_Contact_Provisioning__c.getRecordTypeInfosByName().get('EDS').getRecordTypeId()
    );
    //insert iamContSampleRecord;    
    
    }
    
    @isTest
    static void testGetsObjectInfo(){
        
        IAM_Remove_Subscritions expiresubscription = new IAM_Remove_Subscritions();
        Test.startTest();
        Database.executeBatch(expiresubscription,10);
        Test.stopTest();
    }
    
    
    
    
}