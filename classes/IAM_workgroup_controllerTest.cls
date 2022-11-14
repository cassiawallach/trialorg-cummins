@isTest
public class IAM_workgroup_controllerTest{
    
    @TestSetup
    static void InitData(){
    
    
    
        Account accSampleRecord = new Account(name='AccountTest1',
                                   CMI_Account_Status__c='Pending',
                                   CMI_CDA_Status__c='New Customer Request',
                                   CMI_CId__c = '2458',
                                   IAM_Service_Provider_Code__c = 'Test',
                                   CSS_DistributorCode__c = 'Data',
                                   type='Distributor Account');
    
        insert accSampleRecord;
    
        Account accSampleRecord2 = new Account(name='AccountTest2',
                                   CMI_Account_Status__c='Active',
                                   CMI_CDA_Status__c='New Customer Request',
                                   ParentId = accSampleRecord.id,
                                   IAM_Service_Provider_Code__c = 'Test1',
                                   CSS_DistributorCode__c = 'Data1',
                                   type='Distributor Account');
    
         insert accSampleRecord2;
        
         Account accSampleRecord3 = new Account(name='AccountTest2',
                                   CMI_Account_Status__c='Active',
                                   CMI_CDA_Status__c='New Customer Request',
                                   ParentId = accSampleRecord2.id,
                                   IAM_Service_Provider_Code__c = 'Test2',
                                   CSS_DistributorCode__c = 'Data2',
                                   type='Distributor Account');
    
         insert accSampleRecord3;
    
         Account accSampleRecord4 = new Account(name='AccountTest2',
                                   CMI_Account_Status__c='Active',
                                   CMI_CDA_Status__c='New Customer Request',
                                   ParentId = accSampleRecord3.id,
                                   IAM_Service_Provider_Code__c = 'Test3',
                                   CSS_DistributorCode__c = 'Data3',
                                   type='Distributor Account');
    
        insert accSampleRecord4;
        
        Account accSampleRecord5 = new Account(name='AccountTest2',
                                   CMI_Account_Status__c='Active',
                                   CMI_CDA_Status__c='New Customer Request',
                                   ParentId = accSampleRecord4.id,
                                   IAM_Service_Provider_Code__c = 'Test4',
                                   CSS_DistributorCode__c = 'Data4',
                                   type='Distributor Account');
    
        insert accSampleRecord5;
        
        Account accSampleRecord6 = new Account(name='AccountTest2',
                                   CMI_Account_Status__c='Active',
                                   CMI_CDA_Status__c='New Customer Request',
                                   ParentId = accSampleRecord5.id,
                                   IAM_Service_Provider_Code__c = 'Test5',
                                   CSS_DistributorCode__c = 'Data5',
                                   type='Distributor Account');
    
        insert accSampleRecord6;
        
         Account accSampleRecord7 = new Account(name='AccountTest2',
                                   CMI_Account_Status__c='Active',
                                   CMI_CDA_Status__c='New Customer Request',
                                   ParentId = accSampleRecord6.id,
                                   IAM_Service_Provider_Code__c = 'Test7',
                                   CSS_DistributorCode__c = 'Data7',
                                   type='Distributor Account');
    
        insert accSampleRecord7;
        
        Account accSampleRecord8 = new Account(name='AccountTest2',
                                   CMI_Account_Status__c='Active',
                                   CMI_CDA_Status__c='New Customer Request',
                                   ParentId = accSampleRecord7.id,
                                   IAM_Service_Provider_Code__c = 'Test6',
                                   CSS_DistributorCode__c = 'Data6',
                                   type='Distributor Account');
    
        insert accSampleRecord8 ;
        
        Account accSampleRecord9 = new Account(name='AccountTest2',
                                   CMI_Account_Status__c='Active',
                                   CMI_CDA_Status__c='New Customer Request',
                                   ParentId = accSampleRecord8.id,
                                   IAM_Service_Provider_Code__c = 'Test9',
                                   CSS_DistributorCode__c = 'Data9',
                                   type='Customer');
    
        insert accSampleRecord9 ;
        
        system.debug('==accSampleRecord =='+accSampleRecord);
        system.debug('==accSampleRecord2 =='+accSampleRecord2);
        system.debug('==accSampleRecord3 =='+accSampleRecord3);
        system.debug('==accSampleRecord4 =='+accSampleRecord4);
        system.debug('==accSampleRecord5 =='+accSampleRecord5);
        system.debug('==accSampleRecord6 =='+accSampleRecord6);
        system.debug('==accSampleRecord7 =='+accSampleRecord7);
        system.debug('==accSampleRecord8 =='+accSampleRecord8);
        system.debug('==accSampleRecord9 =='+accSampleRecord9);
                
        Contact contSampleRecord = new Contact(
        FirstName = 'Test',
        LastName ='User',
        Email = 'testrecord@abc.com',
        Username__c = 'amar31322@abc.com',
        AccountId = accSampleRecord.ID,
        IAM_Contact_Status__c = 'Active',
        IAM_Work_Group_Id__c = 'Test',  
        CMI_Contact_Type__c = 'Primary'
        );
    
        insert contSampleRecord;
        
         
    
        /*User uesrSampleRecord = new User(
        LastName = 'lstTest',
        FirstName = 'frstTest',
        Email = 'testrecord12@abc.com',
        Alias = 'tXXe',
        Username = 'amar3132212@abc.com',
        CommunityNickname = 'testtst',
        LocaleSidKey= 'en_US',
        TimeZoneSidKey ='GMT',
        ProfileID = profId,
        LanguageLocaleKey = 'en_US',
        EmailEncodingKey = 'UTF-8',
        isActive=TRUE,
        contactId = contSampleRecord.Id
    );
    
   insert uesrSampleRecord; */
   
    }
    
     @isTest   
     static void callApexclass(){
    Contact con = [SELECT Id,Name FROM Contact WHERE name LIKE '%Test%' LIMIT 1]; 
    PageReference pageRef = Page.IAM_Authorize;
    Test.setCurrentPage(pageRef);
    ApexPages.currentPage().getParameters().put('contact_id',con.id);
    IAM_workgroup_controller obj = new IAM_workgroup_controller();
    obj.AssignIdmGroupId();
   
     }
     
     @isTest
     static void testflow(){
     Account testAccount = [SELECT id,Name FROM Account WHERE Name='AccountTest1' LIMIT 1];
       
        
        Contact cont = new Contact();
        cont.FirstName='jjj';
        cont.LastName='lloki';
        cont.Accountid= testAccount.id;
        cont.Username__c= 'Azdt@abc.com';
        insert cont;
        
        id profId = [select id,Name from Profile where name='IAM_Site_Admin_Community'].id;
           User tuser = new User(  firstname = 'xxx',
                                lastName = 'yyyy',
                                email = 'amrbac@kkk.com',
                                Username = 'amrbac@kkk.com',
                                EmailEncodingKey = 'ISO-8859-1',
                                Alias = 'ldjf',
                                TimeZoneSidKey = 'America/Los_Angeles',
                                LocaleSidKey = 'en_US',
                                LanguageLocaleKey = 'en_US',
                                ProfileId = profId,
                                contactId = cont.Id,
                                IAM_Account_Number__c = '2458'
                               );
        insert tuser; 
        PageReference pageRef = Page.IAM_Authorize;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('contact_id',cont.id);
        system.runAs(tuser){
        IAM_workgroup_controller obj = new IAM_workgroup_controller();
        }
     }
     
     @isTest
     static void testflow02(){
     Account testAccount = [SELECT id,Name FROM Account WHERE Name='AccountTest1' LIMIT 1];
       
        
        Contact cont = new Contact();
        cont.FirstName='jjj';
        cont.LastName='lloki';
        cont.Accountid= testAccount.id;
        cont.Username__c = 'Azdt@abc.com';
        insert cont;
        
        id profId = [select id,Name from Profile where name='IAM_Site_Admin_Community'].id;
           User tuser = new User(  firstname = 'xxx',
                                lastName = 'yyyy',
                                email = 'amrbac@kkk.com',
                                Username = 'amrbac@kkk.com',
                                EmailEncodingKey = 'ISO-8859-1',
                                Alias = 'ldjf',
                                TimeZoneSidKey = 'America/Los_Angeles',
                                LocaleSidKey = 'en_US',
                                LanguageLocaleKey = 'en_US',
                                ProfileId = profId,
                                contactId = cont.Id,
                                IAM_Account_Number__c = 'dfdd'
                               );
        insert tuser; 
        PageReference pageRef = Page.IAM_Authorize;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('contact_id',cont.id);
        system.runAs(tuser){
        IAM_workgroup_controller obj = new IAM_workgroup_controller();
        }
     }
}