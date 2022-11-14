@isTest
public class IAM_Contact_Prov_HelperTest{
    @isTest   
     static void callApexclass(){
        
        CSS_Integration_Details__c integrationDetail = new CSS_Integration_Details__c ();
        integrationDetail.Name = 'IAM_LDAP_oAuth';
        integrationDetail.ApplicationName__c = 'IAM_LDAP_oAuth';
        integrationDetail.AuthEnv__c  = 'OAGoAuth';
        integrationDetail.End_Point__c = 'https://services-dev-oauth.cummins.com/api/oauth/token/ldaputil';
        integrationDetail.grant_type__c = 'client_credentials';
        integrationDetail.IsActive__c = true;
        integrationDetail.Key__c = 'thAQWe/AIgUevs8IGTdk4Ddx50z3F9xiqm2Hl/QMu/MuVcRJFcWzFgYxxXvpN2LZEs43hkxTJ3t67B0nx7a1qg==';
        integrationDetail.Logging__c = 'LDAPUtil';
        integrationDetail.Method_Type__c = 'POST';
        integrationDetail.Name = 'IAM_LDAP_oAuth';
        integrationDetail.Passcode__c = 'Il3eUr1gk32ejCbujtRoFDgyeVhp+MdwlVe5n/L2Tlk3uQejsj9shK0YOC5Dy/k5HFxa4Ac6EexF+dRmHCEl8Q==';
        integrationDetail.Timeout__c = 120000.0;
        integrationDetail.Username__c = 'Z7xm9X6ImVl6ND7zTJ2j/jScb740y2NP/TOoSV9vC+U=';
    
        insert integrationDetail;
    
          account pacc=new account();
        pacc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('IAM').getRecordTypeId();
        pacc.name = 'parentAcc';
        pacc.Type='Distributor Account';
        insert pacc;
        
        account acc=new account();
        acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('IAM').getRecordTypeId();
        acc.name = 'test852';
        acc.parentid = pacc.id;
        acc.BillingCountryCode = 'US';
        acc.BillingStreet = 'test1'; 
        acc.BillingCity = 'Nevada';
        //   acc.BillingCountry='United States';
        acc.BillingStateCode = 'CA';
        acc.BillingPostalCode = '95959';
        acc.BillingState='California';

        acc.CSS_DistributorCode__c='test';
        acc.CSS_DealerCode__c='prash';
        acc.CSS_Timezone__c = '(GMT+05:00) Pakistan Standard Time (Asia/Karachi)';
        acc.CSS_Locale__c = 'Albanian(Albania)';
        acc.CSS_Language__c = 'Swedish';
        //(GMT+05:00) Pakistan Standard Time (Asia/Karachi)
        
        insert acc;
        
        contact Con=new contact();
        con.RecordTypeId = Schema.SObjectType.contact.getRecordTypeInfosByName().get('IAM').getRecordTypeId();
        Con.FirstName = 'test1221';
        Con.LastName = 'test852432';
        Con.Email = 'test012120@eiam.com';
        Con.phone = '1112223335';
        Con.MailingStreet = 'Test Street';
        Con.MailingCity = 'Test City';
        Con.MailingPostalCode = '11111';
        Con.MailingCountryCode = 'US';
        Con.MailingStateCode = 'IN';
        Con.iam_Contact_Status__c = 'Active';
        con.Username__c = 'jomboison@abc.com';
        Con.AccountId = acc.Id;
        Con.CMI_Contact_Type__c = 'Primary';
        
        insert Con;
         Id profId  = [SELECT Id,Name FROM Profile Where name = 'IAM_Site_Admin_Community'].Id;
         
         User uesrSampleRecord = new User(
            LastName = 'lstTest',
            FirstName = 'frstTest',
            Email = 'lstTest@test.com',
            Alias = 'lsTest',
            Username = 'lstTest@test.com',
            CommunityNickname = 'lstest1234Test',
            LocaleSidKey= 'en_US',
            TimeZoneSidKey ='GMT',
            ProfileID = profId,
            LanguageLocaleKey = 'en_US',
            EmailEncodingKey = 'UTF-8',
            contactId = Con.Id,
            IAM_UID__c = 'Amartest2133@abc.com',
            IAM_Final_Approver__c='Y',
            isActive = true
        );
        
        //insert uesrSampleRecord;
        
        
        App_Mapping__c app=new App_Mapping__c();
        app.name='Marketplace';
        app.Back_page__c='https://login.salesforce.com/';
        app.Login_Url__c='https://www.facebook.com/';
        app.IAM_App_Protected_By__c = 'SM';
        app.IAM_Default_Role__c = 'Test';
        insert app; 
        
        IAM_Application__c afa=new IAM_Application__c();
        afa.IAM_Account_Name__c=acc.Id;
        afa.IAM_Application_Name__c='CUMPAS 2.0';
        afa.IAM_Role__c='Vendor User';
        afa.IAM_Subscription_Start_Date__c=Date.newInstance(2018,1,1);
        afa.IAM_Subscription_End_Date__c=Date.newInstance(2020,1,1);
        afa.IAM_Subscription_Name__c='EDS App';
        afa.IAM_Subscription_Count__c=10;
        afa.IAM_Free_Subscription__c=false;
        insert afa;
        
        set<Id> conproIds = new set<Id>();
        IAM_Contact_Provisioning__c conP=new IAM_Contact_Provisioning__c();
        conP.RecordTypeId = Schema.SObjectType.IAM_Contact_Provisioning__c.getRecordTypeInfosByName().get('CUMPAS 2.0').getRecordTypeId();
        conP.IAM_Account_Application__c=afa.Id;
        conP.IAM_Contact__c=con.Id;
        conP.IAM_Application_Name__c='CUMPAS 2.0';
        conP.IAM_Role__c= 'Vendor User';
        conP.IAM_Start_Date__c=System.Today();
        conP.IAM_Status__c='Active';
        insert conP;
        conproIds.add(conP.id);
        
        list<Contact> lstcont = new list<Contact>();
        lstcont.add(Con);
        Test.startTest();
        IAM_Contact_Prov_Helper obj = new IAM_Contact_Prov_Helper();
        IAM_Contact_Prov_Helper.CreationOfUser(lstcont);
        IAM_Contact_Prov_Helper.UpdateToActive(conproIds);
        Test.stopTest();
     }
     
      @Istest
    static void test22()
    {
   // List<contact> c = [select id,FirstName,LastName,Email,phone,MailingStreet ,MailingCity,MailingPostalCode,MailingCountryCode,MailingStateCode,iam_Contact_Status__c,Username__c ,AccountId from contact where Username__c = 'jomboison@abc.com'];
   // c[0].Username__c='unique123';
        account pacc=new account();
        pacc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('IAM').getRecordTypeId();
        pacc.name = 'parentAcc2';
        pacc.type='Distributor Account';
        insert pacc;
        
        account acc=new account();
        acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('IAM').getRecordTypeId();
        acc.name = 'test85222';
        acc.parentid = pacc.id;
        acc.BillingCountryCode = 'US';
        acc.BillingStreet = 'test1'; 
        acc.BillingCity = 'Nevada';
        //   acc.BillingCountry='United States';
        acc.BillingStateCode = 'CA';
        acc.BillingPostalCode = '95959';
        acc.BillingState='California';

        acc.CSS_DistributorCode__c='test';
        acc.CSS_DealerCode__c='prash';
        acc.CSS_Timezone__c = '(GMT+05:00) Pakistan Standard Time (Asia/Karachi)';
        acc.CSS_Locale__c = 'Albanian(Albania)';
        acc.CSS_Language__c = 'Swedish';
        //(GMT+05:00) Pakistan Standard Time (Asia/Karachi)
        
        insert acc;
      
       List<contact> cc=new List<contact>();
        contact Con=new contact();
        con.RecordTypeId = Schema.SObjectType.contact.getRecordTypeInfosByName().get('IAM').getRecordTypeId();
        Con.FirstName = 'funiq';
        Con.LastName = 'luniq';
        Con.Email = 'fluniq@eiam.com';
        Con.phone = '1112223335';
        Con.MailingStreet = 'Test Street';
        Con.MailingCity = 'Test City';
        Con.MailingPostalCode = '11111';
        Con.MailingCountryCode = 'US';
        Con.MailingStateCode = 'IN';
        Con.iam_Contact_Status__c = 'Active';
        con.Username__c = 'unique123@abc.com';
        Con.AccountId = acc.Id;
        cc.add(Con);
        
        insert cc;
        
    IAM_Contact_Prov_Helper.CreationOfUser(cc);
    }

}