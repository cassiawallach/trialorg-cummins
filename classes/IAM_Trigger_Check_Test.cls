/*********************************************************************************
Author       :   Sushma Rajput
Description  :   Unit test class for  IAM_Trigger_Check with 90%
********************************************************************************
History                                                            
-------                                                            
VERSION       AUTHOR                      DATE               DETAIL
1.0 -      Sushma Rajput                17/10/2019        Initial Development                             
1.1 -      Shubhangi Sardar             05/02/2021        Added comment to push to production 
1.2 -      Karthik Raj Golakaram        04/13/2021        Added comments for push to production
1.3 -      Anupam Adhikari              11/23/2021        Added comments for push to production
1.4 -      Shubhangi Sardar             12/08/2021        Added Guidanz Service Portal app in main class
*********************************************************************************************
*/

@isTest
public class IAM_Trigger_Check_Test{
    
    //@testSetup
    public static void createTestData(){
    
    Account a= new Account();       
        a.Name = 'Test Company';
        a.RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('IAM').getRecordTypeId();  
        a.phone = '6884382997';
        a.BillingCity='Columbus';
        a.BillingStreet='340 Brown Street';
        a.BillingCountry='United States';
        a.BillingPostalCode='47201';
        a.BillingState='Indiana';
        insert a;
        
        contact Con=new contact();
        con.RecordTypeId = Schema.SObjectType.contact.getRecordTypeInfosByName().get('IAM').getRecordTypeId();
        Con.FirstName = 'test1';
        Con.LastName = 'test852';
        Con.AccountId = a.Id;
        con.IAM_Cummins_Login_ID__c='test000@eiam.com';   
        Con.Email = 'test000@eiam.com';     
        Con.IAM_Internal__c = True;
        con.IAM_Site_Admin__c = False;
        con.CMI_Contact_Type__c = 'secondary';
        insert Con;
        
        List<profile> pf = [select Id,Name from Profile WHERE Name = 'IAM_FleetguardUser' limit 1];
        
        //User Creation
        User newUser = new User();
        
        newUser.FirstName = 'UserFirstName';
        newUser.LastName = 'test';
        newUser.Email = 'test000@eiam.com';   
        newUser.CompanyName = 'IT Test Company';        
        newUser.CommunityNickname = 'reds';
        newUser.Username = 'Sandeep@test.com' ;
        newUser.Alias = 'test';
        newUser.TimeZoneSidKey = 'GMT';
        newUser.LocaleSidKey= 'en_US';
        newUser.EmailEncodingKey = 'UTF-8';
        newUser.LanguageLocaleKey = 'en_US';         
        newUser.ProfileId = pf[0].Id ;                                  
        newUser.ContactId =Con.Id;                   
        newUser.isActive = TRUE;
        newUser.Street = '123 Test St';
        newUser.FederationIdentifier = '2468741';
        insert newUser;
         
     IAM_Application__c appli2 = new IAM_Application__c();
        appli2.IAM_Application_Name__c = 'Repair logistics and Service';
        appli2.IAM_Role__c = 'RLS Admin';
        appli2.IAM_Status__c = 'Active';
        appli2.IAM_Account_Name__c = a.id;
        appli2.IAM_Subscription_Name__c = 'test';
        insert appli2;
          
        
        //IAM Contact Provisioning
        List<IAM_Contact_Provisioning__c> lstconApp = new List<IAM_Contact_Provisioning__c>();
        IAM_Contact_Provisioning__c conApp = new IAM_Contact_Provisioning__c();
        //conApp.IAM_Application_Name__c = 'Marketplace';
        //conApp.IAM_Role__c = 'Supervisor';   
        conApp.RecordTypeId = Schema.SObjectType.IAM_Contact_Provisioning__c.getRecordTypeInfosByName().get('CUMPAS 2.0').getRecordTypeId();
        conApp.IAM_Application_Name__c = 'CUMPAS 2.0';     
        conApp.IAM_Status__c = 'Active';
        conApp.IAM_Contact__c = Con.id; 
        conApp.IAM_Account_Application__c = appli2.id;
        //insert conApp;
    
         CSS_Integration_Details__c csID = new CSS_Integration_Details__c();
        csID.NAme='IAM_LDAP_oAuth';
        csID.ApplicationName__c ='IAM_LDAP_oAuth';
        csID.End_Point__c = 'https://services-dev-oauth.cummins.com/api/oauth/token/ldaputil';
        csId.IsActive__c = true;
        csID.Key__c='jb6sFHd/KsMjdprFnsnLjPgCf+19v/kh49PHL/bjYO7DmigbFZdIaXN7gVS0/fg06Fx9fPolnF3guPkOncLwHA==';
        csID.Passcode__c = 'lhBxWDMxDkfiIXb2hsMD/sC0HJUv4CRi4HlvvXUtopNctqUHq07R8MVrFKNqGJELb2meudGeoTKfD7yjHDdUJA==';
        csId.Username__c = 'SHnBSQhHEqF+DQgb+tSI6K6+EqIKGt/1yWj/4tG4KG4=';
        csId.Logging__c ='LADAPUtil';
        csId.AuthEnv__c = 'OAGoAuth';
        csId.Method_Type__c = 'POST';
        csId.grant_type__c = 'client_credentials';
        insert csID;
    }    
   static testMethod void testCheckReclaimUser() {
   
   Test.startTest();
        
        List<Account> acc = [Select id,Name From Account WHERE Name = 'Test Company'];
        List<Contact> con = [SELECT Id,Phone,IAM_Cummins_login_ID__c,CMI_User_Id__c,IAM_Ext_Legacy_Uid__c,Email,FirstName,LastName,IAM_Contact_Status__c,CMI_Contact_Type__c,IAM_Applications__c,IAM_is_Member_of__c,IAM_Product_Group_Access__c,IAM_Qsolexpiration__c,IAM_Qsolview__c,IAM_swregexpire__c,IAM_Work_Group_Id__c,AccountId,Account.Name,Account.CSS_Locale__c,Account.CSS_Language__c,Account.CSS_Timezone__c,Account.Type,IAM_Final_Approver__c,Account.IAM_ABO_Code_Formula__c,IAM_Internal__c,Account.IAM_Service_Provider_Code__c,Account.CSS_DBCode__c,Account.CSS_DistributorCode__c,Account.CMI_Account_Num__c,Account.Location__c,Account.BillingCity,Account.BillingCountry,Account.BillingPostalCode,Account.IAM_Movex_Customer_Code__c,Account.BillingStreet,Account.OwnerId,Account.IAM_WWSPS_Regions__c FROM Contact ];
       
        IAM_Trigger_Check.checkApplicationAccess('sushma.rajput@test.com');
        // IAM_UserCreation.validateEmail('sush  ma.rajput@test.com');
        //IAM_UserCreation.CreateUsers(new List<Contact>(), new Map<Id, Boolean>(), new Map<Id, Account>(), True, 'Test');
        
   Test.stopTest();
    
    }


@Istest
    static void testTriggerCheckTest()
    {
    //User userrec= [Select Id, Name, Profile.Name, ProfileId  from User Where Profile.UserLicense.Name ='Force.com - App Subscription' AND IsActive=true AND Profile.name NOT IN (:System.Label.IAM_System_Admin,:System.Label.IAM_Distributor,'IAM_Distributor_Admin_Platform','IAM_CIHR_Platform') Limit 1];
     Profile p = [SELECT Id FROM Profile WHERE Name='IAM_Admin_User']; 
        User userrec = new User(Alias = 'standt', Email='standarduser@testorg.com', 
            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName='standarduserprod@testorg.com');
            insert userrec;
    //User uesrSampleRecord= [Select Id, Name, Profile.Name, ProfileId  from User Where Profile.UserLicense.Name ='Salesforce' and IsActive=true Limit 1];
    string uid=userrec.Id;
    
    
    List<PermissionSet> ps = [SELECT Id FROM PermissionSet WHERE Name IN ('IAM_Promotion_Business_Admin_Permission_Set_SF','IAM_Cumpas_Business_Admin_Permission_Set_SF','IAM_EDS_Business_Admin_Permission_Set_SF','IAM_Guidanz_Business_Admin_Permission_Set_SF','IAM_Guidanz_Mobile_Business_Admin_Permission_Set','IAM_OSM_Business_Admin_Permission_Set','IAM_QSOL_Business_Admin_Permission_Set_SF','IAM_RLS_Business_Admin_Permission_Set','IAM_WWSPS_Business_Admin_Permission_Set_SF','IAM_DA_Business_Admin_Permission_Set','IAM_Distributor_PermissionSet')];
    List<PermissionSetAssignment> pslst = new List<PermissionSetAssignment>();
    PermissionSetAssignment p1  =new PermissionSetAssignment(AssigneeId = userrec.id, PermissionSetId = ps[0].Id);
    PermissionSetAssignment p2  =new PermissionSetAssignment(AssigneeId = userrec.id, PermissionSetId = ps[1].Id);
    PermissionSetAssignment p3  =new PermissionSetAssignment(AssigneeId = userrec.id, PermissionSetId = ps[2].Id);
    PermissionSetAssignment p4  =new PermissionSetAssignment(AssigneeId = userrec.id, PermissionSetId = ps[3].Id);
    PermissionSetAssignment p5  =new PermissionSetAssignment(AssigneeId = userrec.id, PermissionSetId = ps[4].Id);
    PermissionSetAssignment p6  =new PermissionSetAssignment(AssigneeId = userrec.id, PermissionSetId = ps[5].Id);
    PermissionSetAssignment p7  =new PermissionSetAssignment(AssigneeId = userrec.id, PermissionSetId = ps[6].Id);
    PermissionSetAssignment p8  =new PermissionSetAssignment(AssigneeId = userrec.id, PermissionSetId = ps[7].Id);
    PermissionSetAssignment p9  =new PermissionSetAssignment(AssigneeId = userrec.id, PermissionSetId = ps[8].Id);
    PermissionSetAssignment p10 =new PermissionSetAssignment(AssigneeId = userrec.id, PermissionSetId = ps[9].Id);
   
        
    pslst.add(p2);
    pslst.add(p3);
    pslst.add(p4);
    pslst.add(p5);
    pslst.add(p6);
    pslst.add(p7);
    pslst.add(p8);
    pslst.add(p9);
    pslst.add(p10);
    pslst.add(p1);

    insert pslst;

    IAM_Trigger_Check.checkApplicationAccess(uid);
    }
    
    
    @Istest
    static void testTriggerCheckTest2()
    {
     
    User userrec= [Select Id, Name, Profile.Name, ProfileId  from User Where Profile.UserLicense.Name ='Salesforce' and IsActive=true Limit 1];
    string uid=userrec.Id;
    
    IAM_Trigger_Check.checkApplicationAccess(uid);
    }

    
    @Istest
    static void testTriggerCheckTest3()
    {
     
    User userrec= [Select Id, Name, Profile.Name, ProfileId  from User Where Profile.Name =:System.Label.IAM_System_Admin and IsActive=true Limit 1];
    string uid=userrec.Id;
    
    IAM_Trigger_Check.checkApplicationAccess(uid);
    }





}