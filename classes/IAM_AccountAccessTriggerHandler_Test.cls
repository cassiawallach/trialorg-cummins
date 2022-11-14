/********************************************************************************

=============================================================
Purpose:                                                            
This is handler class of IAM_AccountAccessTriggerHandler_Test . Comment                        
=============================================================
=============================================================

History                                                            
-------                                                            

VERSION       AUTHOR                      DATE               DETAIL                                
1.0 -    Karthik Raj Golakaram          23/04/2020        INITIAL DEVELOPMENT 
1.1 -    Shubhangi Sardar               05/02/2021        Added test cases for FT - NPBU app
1.2 -    Shubhangi Sardar               21/01/2021        Added comment to push to prod
1.3 -    Shubhangi Sardar               05/02/2021        Added test cases for PS Pro
1.4 -    Shubhangi Sardar               12/03/2021        Code commit to push to prod 
1.5 -    Vinod Kankatala                06/01/2021        Added Guidanz Mobile Power Plus subscription
1.6 -    Anupam Adhikari                08/10/2021        Added FT Guidanz Beta Testing changes.
1.7 -    Shubhangi Sardar               09/23/2021        Code commit to push to prod 
1.8      Sandeep Vuyyuru                11/04/2022        MarketPLace and Guidanz Mobile 101 soql issue on registration
1.9      Pragnya Sheelam                15/06/2022        MarketPlace Deactivation
2.0 -    Chetan Gaikwad                 17/08/2022        code commit to push changes to prod
*****************************************************/
/********************************************************************************
***********************************************************************************/
/* AutorenewSubscriptio   ns method commented by Lavanya, As New Schedule class implemented for AutorenewSubscriptions */
//Test coverage for the class OSM_SW_ContactAccessRoleUpdate
//TEst Class Execution for Guidanz Mobile Count.


@isTest

public class IAM_AccountAccessTriggerHandler_Test {
    
    /* Insert Account Access & Feature Object Test */

    static testmethod void insertTest1() {
        Account acc = IAM_TestData.createAccount();
        Contact con = IAM_TestData.createContact(acc.Id);
        Contact loginUserCon = getContact();
        User u = IAM_TestData.createUser(loginUserCon, acc, Label.IAM_Profile_Admin_User);
        PermissionSet ps = [SELECT Id FROM PermissionSet WHERE Name = 'IAM_Cumpas_Business_Admin_Permission_Set_SF'];
         
        //PermissionSet ps = [SELECT Id FROM PermissionSet WHERE Name = 'IAM_Distributor_PermissionSet'];
        // Assign the above inserted user for the above Permission Set.
        //IAM_Application__c appAcceIAM_TestDatassObj = IAM_TestData.createAccountSubscription(acc.Id, 'QuickServe Online', 'QSOL Dealer');

        Test.startTest();

        System.runAs(u) {
           insert new PermissionSetAssignment(AssigneeId = u.id, PermissionSetId = ps.Id);
            IAM_TestData.createAccountSubscription(acc.Id, 'CUMPAS 2.0', 'Dealer User');
            //appAccessObj.IAM_Subscription_End_Date__c = Date.today() + 366;
            //update appAccessObj;
        }        
        Test.stopTest();
    }


    /* Update Account Access & Feature Object Test */

    static testmethod void updateTest1() {
        Account acc = IAM_TestData.createAccount();
        Contact con = IAM_TestData.createContact(acc.Id);
        Contact loginUserCon = getContact();
        User u = IAM_TestData.createUser(loginUserCon, acc, Label.IAM_Profile_Admin_User);
        PermissionSet ps = [SELECT Id FROM PermissionSet WHERE Name = 'IAM_Cumpas_Business_Admin_Permission_Set_SF'];

        Test.startTest();        
        System.runAs(u) {
            try { 
                insert new PermissionSetAssignment(AssigneeId = u.id, PermissionSetId = ps.Id);
                IAM_Application__c appAccessObj = createAccountSubscription(acc.Id, 'CUMPAS 2.0', 'Dealer User', 'Active');
                IAM_TestData.createUserSubscription(con.Id, appAccessObj.Id, 'CUMPAS 2.0', 'CUMPAS', Date.today(), 
                Date.today()+365, 'Active', '', '', '', 'Dealer User', '');
                appAccessObj.IAM_Role__c = 'Dealer Admin';
                update appAccessObj;
            } catch(Exception e) {
                System.assert(String.isNotBlank(e.getMessage()));
            }
        }        
        Test.stopTest();
    }


    /* Update Account Access & Feature Object Test  */

    static testmethod void updateTest2() {
        Account acc = IAM_TestData.createAccount();
        Contact con = IAM_TestData.createContact(acc.Id);
        Contact loginUserCon = getContact();
        User u = IAM_TestData.createUser(loginUserCon, acc, Label.IAM_Profile_Admin_User);
        PermissionSet ps = [SELECT Id FROM PermissionSet WHERE Name = 'IAM_Cumpas_Business_Admin_Permission_Set_SF'];

        Test.startTest();        
        System.runAs(u) {
            try { 
                insert new PermissionSetAssignment(AssigneeId = u.id, PermissionSetId = ps.Id);
                IAM_Application__c appAccessObj = createAccountSubscription(acc.Id, 'CUMPAS 2.0', 'Dealer User', 'Pending');
                IAM_TestData.createUserSubscription(con.Id, appAccessObj.Id, 'CUMPAS 2.0', 'CUMPAS', Date.today(), 
                Date.today()+365, 'Pending Account Approval', '', '', '', 'Dealer User', '');
                appAccessObj.IAM_Status__c = 'Active';
                update appAccessObj;
            } catch(Exception e) {
                System.assert(String.isNotBlank(e.getMessage()));
            }
        }        
        Test.stopTest();
    }

    
    /* Update Account Access & Feature Object Test */

    static testmethod void updateTest3() {
        Account acc = IAM_TestData.createAccount();   
        Contact loginUserCon = getContact();            
        User u = IAM_TestData.createUser(loginUserCon, acc, Label.IAM_Profile_Admin_User);
        PermissionSet ps = [SELECT Id FROM PermissionSet WHERE Name = 'IAM_Cumpas_Business_Admin_Permission_Set_SF'];

        System.runAs(u) {
            insert new PermissionSetAssignment(AssigneeId = u.id, PermissionSetId = ps.Id);
            Contact con = createContact(acc.Id);        
            IAM_Application__c appAccessObj = createAccountSubscription(acc.Id, 'CUMPAS 2.0', 'Dealer User', 'Pending');
            IAM_TestData.createUserSubscription(con.Id, appAccessObj.Id, 'CUMPAS 2.0', 'CUMPAS', Date.today(), 
                                               Date.today()+365, 'Pending Account Approval', '', '', '', 'Dealer User', '');            

            Test.startTest();
            try {
                IAM_Application__c appAccessObj1 = [SELECT Id, IAM_Reject_Reason__c, IAM_Status__c FROM IAM_Application__c
                                                  WHERE Id = :appAccessObj.Id];
                appAccessObj1.IAM_Reject_Reason__c = 'Other';
                appAccessObj1.IAM_Status__c = 'Inactive';
                update appAccessObj1;

            } catch(Exception e) {
                System.assert(String.isNotBlank(e.getMessage()));
            }                
        Test.stopTest();
        }
    }

static testmethod void updateTest3_clone() {
        Account acc = IAM_TestData.createAccount();   
        Contact loginUserCon = getContact();            
        User u = IAM_TestData.createUser(loginUserCon, acc, Label.IAM_Profile_Admin_User);
        PermissionSet ps = [SELECT Id FROM PermissionSet WHERE Name = 'IAM_Cumpas_Business_Admin_Permission_Set_SF'];

        System.runAs(u) {
            insert new PermissionSetAssignment(AssigneeId = u.id, PermissionSetId = ps.Id);
            Contact con = createContact(acc.Id);        
            IAM_Application__c appAccessObj = createAccountSubscription(acc.Id, 'CUMPAS 2.0', 'Dealer User', 'Pending');
            IAM_TestData.createUserSubscription(con.Id, appAccessObj.Id, 'CUMPAS 2.0', 'CUMPAS', Date.today(), 
                                               Date.today()+365, 'Pending Account Approval', '', '', '', 'Dealer User', '');            

            Test.startTest();
            try {
                IAM_Application__c appAccessObj1 = [SELECT Id, IAM_Reject_Reason__c, IAM_Status__c FROM IAM_Application__c
                                                  WHERE Id = :appAccessObj.Id];
                appAccessObj1.IAM_Reject_Reason__c = 'Other';
                appAccessObj1.IAM_Status__c = 'Active';
                update appAccessObj1;

            } catch(Exception e) {
                System.assert(String.isNotBlank(e.getMessage()));
            }                
        Test.stopTest();
        }
    }


    /* UpdateAccRole and deactivateConProvisionings */
    static testmethod void updateTest4() {
        // Account acc = IAM_TestData.createAccount();
        // Contact con = createContact(acc.Id);
        // IAM_Application__c accFeature = createAccountSubscription(acc.Id,Label.IAM_Guidanz_Mobile_App_Name,'User','Active');
        Account acc = IAM_TestData.createAccount();   
        Contact loginUserCon = getContact();            
        User u = IAM_TestData.createUser(loginUserCon, acc, Label.IAM_Profile_Admin_User);
        PermissionSet ps = [SELECT Id FROM PermissionSet WHERE Name = 'IAM_Cumpas_Business_Admin_Permission_Set_SF'];

        System.runAs(u) {
            insert new PermissionSetAssignment(AssigneeId = u.id, PermissionSetId = ps.Id);
            Contact con = createContact(acc.Id);        
            IAM_Application__c appAccessObj = createAccountSubscription(acc.Id, 'CUMPAS 2.0', 'Dealer User', 'Active');
            IAM_TestData.createUserSubscription(con.Id, appAccessObj.Id, 'CUMPAS 2.0', 'CUMPAS', Date.today(), 
                                                Date.today()+365, 'Active', '', '', '', 'Dealer User', '');  
            IAM_Application__c accFeature = createAccountSubscription(acc.Id,'Guidanz Mobile','Guidanz Mobile User','Active');
            IAM_TestData.createUserSubscription(con.Id, appAccessObj.Id, 'Guidanz Mobile', 'Guidanz', Date.today(), 
                                                Date.today()+365, 'Active', '', '', '', 'Guidanz Mobile User', '');  


            Test.startTest();
            try {
                List<IAM_Application__c> appAccessObj1 = [SELECT Id,IAM_Account_Name__c,IAM_Application_Name__c,IAM_Qsolexpiration__c,IAM_swregExpire__c, IAM_Reject_Reason__c, IAM_Status__c FROM IAM_Application__c
                                                    WHERE IAM_Account_Name__c = :acc.Id];

                //appAccessObj1.IAM_Reject_Reason__c = 'Other'
                //appAccessObj1.IAM_Status__c = 'Inactive';
                //update appAccessObj1;
                IAM_AccountAccessTriggerHandler.deactivateConProvisionings(appAccessObj1);
                IAM_AccountAccessTriggerHandler.UpdateAccRole(appAccessObj1);
            } catch(Exception e) {
                System.assert(String.isNotBlank(e.getMessage()));
            }                
            Test.stopTest();
        }    
    }


    static testmethod void beforeInsertExceptionTest() {
        Account acc = IAM_TestData.createAccount();
        Contact con = IAM_TestData.createContact(acc.Id);
        Contact loginUserCon = getContact();
        User u = IAM_TestData.createUser(loginUserCon, acc, Label.IAM_Profile_Admin_User);
        Test.startTest();        
        System.runAs(u) {
            try {
                IAM_TestData.createAccountSubscription(acc.Id, 'CUMPAS 2.0', 'Dealer User'); 
            } catch (Exception e) {
                System.assert(String.isNotBlank(e.getMessage()));
            }                       
        }        
        Test.stopTest();
    }

    

    /* Update Account Access & Feature Object Test */
    static testmethod void beforeupdateExceptionTest() {
        Account acc = IAM_TestData.createAccount();
        Contact con = IAM_TestData.createContact(acc.Id);
        Contact loginUserCon = getContact();
        User u = IAM_TestData.createUser(loginUserCon, acc, Label.IAM_Profile_Admin_User);
        PermissionSet ps = [SELECT Id FROM PermissionSet WHERE Name = 'IAM_Cumpas_Business_Admin_Permission_Set_SF'];
        IAM_Application__c appAccessObj = IAM_TestData.createAccountSubscription(acc.Id, 'QuickServe Online', 'QSOL Dealer');
        Test.startTest();        

        System.runAs(u) {
            try {
                insert new PermissionSetAssignment(AssigneeId = u.id, PermissionSetId = ps.Id);
                appAccessObj.IAM_Role__c = 'Dealer Admin';
                update appAccessObj;
            } catch(Exception e) {
                System.assert(String.isNotBlank(e.getMessage()));
            }
        }        
        Test.stopTest();
    }


    static testmethod void guidanzFieldTest(){
        Account acc = IAM_TestData.createAccount();
        Contact con = IAM_TestData.createContact(acc.Id);
        Contact loginUserCon = getContact(); 
        IAM_Application__c appAccessObjCMP = createAccountSubscription(acc.Id, Label.IAM_App_GuidanzMobileFieldTest,
                                                              'Field Test CMP Guidanz Mobile','Active');
        IAM_Application__c appAccessObjIAS = createAccountSubscription(acc.Id, Label.IAM_App_GuidanzMobileFieldTest,
                                                               'Field Test IAS Guidanz Mobile','Active');
        IAM_Application__c appAccessObjSRV = createAccountSubscription(acc.Id, Label.IAM_App_GuidanzMobileFieldTest,
                                                               'Field Test SRV Guidanz Mobile','Active');

        //IAM_Application__c appAccessObjPSPRO = createAccountSubscription(acc.Id, Label.IAM_App_GuidanzMobileFieldTest,
                                                               //'Field Test PS PRO Guidanz Mobile','Active');

        List<IAM_Application__c> appList = [
            SELECT IAM_swregExpire__c
            FROM IAM_Application__c
            WHERE IAM_Role__c = 'Field Test IAS Guidanz Mobile'
            AND IAM_Status__c = 'Active'
            AND IAM_Account_Name__c = :acc.Id
        ];

        if(!appList.isEmpty()) {
           // System.assert(String.isNotBlank(appList[0].IAM_swregExpire__c));   
        }
    }

    

      static testmethod void guidanzFieldTestUpdateUseSub(){
        Account acc = IAM_TestData.createAccount();
        Contact con = IAM_TestData.createContact(acc.Id);
        Contact loginUserCon = getContact(); 
        IAM_Application__c appAccessObjIAS = createAccountSubscription(acc.Id, Label.IAM_App_GuidanzMobileFieldTest,
                                                               'Field Test IAS Guidanz Mobile','Active');

      createUserSubscription(con.Id, appAccessObjIAS.Id, Label.IAM_App_GuidanzMobileFieldTest,
                             'Field Test IAS Guidanz Mobile', 'Field Test IAS Guidanz Mobile');        

      List<IAM_Application__c> app = [
          SELECT IAM_swregExpire__c, IAM_Subscription_End_Date__c FROM IAM_Application__c WHERE Id = :appAccessObjIAS.Id];
      System.debug('#### app -'+app);
      app[0].IAM_Subscription_End_Date__c = Date.today().addDays(20);
      Test.startTest();
          update app[0];
      Test.stopTest();
      

      List<IAM_Contact_Provisioning__c> conProFetched = [
          SELECT IAM_swregExpire__c, IAM_End_Date__c FROM IAM_Contact_Provisioning__c];
      System.debug('#### app -'+conProFetched);
      //System.assert(String.isNotBlank(conProFetched[0].IAM_swregExpire__c));       
  }  

    static testmethod void guidanzFieldTestNPBU(){
        Account acc = IAM_TestData.createAccount();
        Contact con = IAM_TestData.createContact(acc.Id);
        Contact loginUserCon = getContact(); 

        IAM_Application__c appBasic = createAccountSubscription(acc.Id, Label.IAM_FT_NPBU_Diagnostics,
                                                               'BASIC','Active');
        IAM_Application__c appManufaturing = createAccountSubscription(acc.Id, Label.IAM_FT_NPBU_Diagnostics,
                                                               'Manufacturing','Active');
        IAM_Application__c appAdvance = createAccountSubscription(acc.Id, Label.IAM_FT_NPBU_Diagnostics,
                                                               'Advance','Active');
        IAM_Application__c appPro = createAccountSubscription(acc.Id, Label.IAM_FT_NPBU_Diagnostics,
                                                               'Pro','Active');

        List<IAM_Application__c> appList = [
            SELECT IAM_NpbuDiagExpire__c
            FROM IAM_Application__c
            WHERE IAM_Role__c = 'BASIC'
            AND IAM_Status__c = 'Active'
            AND IAM_Account_Name__c = :acc.Id
        ];

        if(!appList.isEmpty()) {
            //System.assert(String.isNotBlank(appList[0].IAM_NpbuDiagExpire__c));   
        }

    }
   

    /* Get test contact data to create user */

    public static Contact getContact() {
        Contact con = new contact();
        con.FirstName = 'LogInFname';
        con.LastName = 'LonInLname';
        con.Email = 'LogInFname@test.com';
        con.Username__c = 'LogInFname@test.com';
        con.phone = '1112223335';
        con.IAM_Contact_Status__c = 'Active';
        return con;
    }

    /* Create test contact data */

    public static Contact createContact(Id accId) {
        Contact con = new contact();
        con.AccountId = accId;
        con.RecordTypeId = Schema.SObjectType.contact.getRecordTypeInfosByName().get('IAM').getRecordTypeId();
        con.FirstName = 'Fname';
        con.LastName = 'Lname';
        con.Email = 'fnamelname@test.com';
        con.Username__c = 'fnamelname@test.com';
        con.phone = '1112223335';
        con.IAM_Contact_Status__c = 'Pending';
        User u = [select id, Name, ProfileId, isActive  from User where Profile.Name = 'System Administrator' and isActive=true limit 1];
        System.runAs(u){
           insert con;
        }
        return con;
    }

    
    /* Create and return IAM_Application__c record for given Account */
    public static IAM_Application__c createAccountSubscription(Id accId, String appName, String appRole, String Status) {
        IAM_Application__c obj = new IAM_Application__c();
        obj.IAM_Account_Name__c = accId;                
        obj.IAM_Subscription_Start_Date__c = Date.today();
        obj.IAM_Subscription_End_Date__c = Date.today() + 365;
        obj.IAM_Subscription_Count__c = 9999;
        obj.IAM_Application_Name__c = appName;
        obj.IAM_Role__c = appRole;

        if(appName == Label.IAM_Guidanz_Mobile_App_Name){
            System.debug('Printing Role Name for Guidanz mobile application');
            obj.IAM_Guidanz_Mobile_Roles__c = appRole;
            obj.IAM_swregExpire__c = 'IAM-2020';
        }

        if(appName == Label.IAM_AppName_QSOL){
            System.debug('Printing Role Name for Guidanz mobile application');
            obj.IAM_Qsolexpiration__c = 'IAM-2020';
        }

        if(appName == 'CUMPAS 2.0') {
            obj.IAM_Cumpas_Modularity__c = 'View Credit;Core Returns';
        }

        if(appName==Label.IAM_App_GuidanzMobileFieldTest){
          obj.IAM_Guidanz_Mobile_Roles__c = appRole;  
        }

        obj.IAM_Status__c = status;
        obj.IAM_Subscription_Name__c = appName;
        obj.RecordtypeId = Schema.SObjectType.IAM_Application__c.getRecordTypeInfosByName().get(appName).getRecordTypeId();
        System.debug('#### Account access obj '+obj);

        User u = [select id, Name, ProfileId, isActive  from User where Profile.Name = 'System Administrator' and isActive=true limit 1];
        System.runAs(u){
            insert obj;
        }
        return obj;
    }

    /* Create IAM_Contact_Provisioning__c object record  */

    public static void createUserSubscription(Id conId, Id accAccFeatureId, String appName, String subName, String role) {
        IAM_Contact_Provisioning__c obj = new IAM_Contact_Provisioning__c();
        obj.IAM_Contact__c= conId; 
        obj.IAM_Start_Date__c = Date.today();
        obj.IAM_End_Date__c = Date.today() + 365;
        obj.IAM_Application_Name__c = appName;
        obj.IAM_Role__c = role;

        if(appName == Label.IAM_Guidanz_Mobile_App_Name){
            obj.IAM_Guidanz_Mobile_Roles__c = role;
            obj.IAM_swregExpire__c = 'IAM-2020';
        }

        if(appName == Label.IAM_AppName_QSOL){
            System.debug('Printing Role Name for Guidanz mobile application');
            obj.IAM_Qsolexpiration__c = 'IAM-2020';
        }

        if(appName == 'CUMPAS 2.0') {
            obj.IAM_Cumpas_Modularity__c = 'View Credit;Core Returns';    
        }

        obj.IAM_Status__c = 'Active';
        obj.IAM_Account_Application__c = accAccFeatureId;
        obj.IAM_Subscription_Name__c = subName;        
        obj.RecordtypeId = Schema.SObjectType.IAM_Contact_Provisioning__c.getRecordTypeInfosByName().get(appName).getRecordTypeId();                 
        User u = [select id, Name, ProfileId, isActive  from User where Profile.Name = 'System Administrator' and isActive=true limit 1];

        System.runAs(u){
            insert obj;
        }
        System.debug('#### User access obj '+obj);
    }

 
   
/* Test coverage for the class AccountUpdateFields method */
    @isTest
    public static void AccountUpdateFieldstest() {
        Account acc = IAM_TestData.createAccount();
        Contact con = IAM_TestData.createContact(acc.Id); 
        List<IAM_Application__c> app= new List<IAM_Application__c>();
        
        IAM_Application__c app1 = new IAM_Application__c();
        app1.IAM_Application_Name__c = 'Connected Solutions';
        app1.RecordTypeId=Schema.SObjectType.IAM_Application__c.getRecordTypeInfosByName().get('QuickServe Online').getRecordTypeId();
        app1.IAM_Role__c = 'Technician';
        app1.IAM_Status__c = 'Pending';
        app1.IAM_Account_Name__c = acc.id;
        app1.IAM_Subscription_Name__c = 'test';
        app1.IAM_Subscription_Start_Date__c=System.today();
        app1.IAM_Subscription_End_Date__c= System.today() + 3;
        app1.IAM_Subscription_Count__c = 10;
        app1.IAM_Free_Subscription__c= true;
        app1.IAM_License_Type__c = 'test';
        app1.IAM_Qsolexpiration__c = 'test';
        app1.IAM_Source__c = 'Marketplace';
        insert app1;
        app.add(app1);
        IAM_AccountAccessTriggerHandler.AccountUpdateFields(app);
    }
    

 /* Test coverage for the class updateFields method */
    @isTest
    public static void updateFieldstest() {
        Account acc = IAM_TestData.createAccount();
        Contact con = IAM_TestData.createContact(acc.Id); 
        List<IAM_Application__c> app= new List<IAM_Application__c>();
        List<IAM_Application__c> app3= new List<IAM_Application__c>();
        List<IAM_Application__c> app9= new List<IAM_Application__c>();
        
        IAM_Application__c app1 = new IAM_Application__c();
        app1.IAM_Application_Name__c = 'QuickServe Online';
        app1.RecordTypeId=Schema.SObjectType.IAM_Application__c.getRecordTypeInfosByName().get('QuickServe Online').getRecordTypeId();
        app1.IAM_Role__c = 'QSOL Dealer';
        app1.IAM_Status__c = 'Pending';
        app1.IAM_Account_Name__c = acc.id;
        app1.IAM_Subscription_Name__c = 'test';
        app1.IAM_Subscription_Start_Date__c=System.today();
        app1.IAM_Subscription_End_Date__c= System.today() + 3;
        app1.IAM_Subscription_Count__c = 10;
        app1.IAM_Free_Subscription__c= true;
        app1.IAM_License_Type__c = 'test';
        app1.IAM_Qsolexpiration__c = 'test';
        app1.IAM_Source__c = 'Marketplace';
        insert app1;
        app.add(app1);
        
        IAM_Application__c app4 = new IAM_Application__c();
        app4.IAM_Application_Name__c = 'Field Test Guidanz Mobile';
        app4.RecordTypeId=Schema.SObjectType.IAM_Application__c.getRecordTypeInfosByName().get('QuickServe Online').getRecordTypeId();
        app4.IAM_Role__c = 'Field Test SRV Guidanz Mobile';
        app4.IAM_Status__c = 'Pending';
        app4.IAM_Account_Name__c = acc.id;
        app4.IAM_Subscription_Name__c = 'test';
        app4.IAM_Subscription_Start_Date__c=System.today();
        app4.IAM_Subscription_End_Date__c= System.today() + 3;
        app4.IAM_Subscription_Count__c = 10;
        app4.IAM_Free_Subscription__c= true;
        app4.IAM_License_Type__c = 'test';
        app4.IAM_Qsolexpiration__c = 'test';
        app4.IAM_Source__c = 'Marketplace';
        insert app4;
        app.add(app4);
        
        IAM_Application__c app5 = new IAM_Application__c();
        app5.IAM_Application_Name__c = 'Field Test Guidanz Mobile';
        app5.RecordTypeId=Schema.SObjectType.IAM_Application__c.getRecordTypeInfosByName().get('QuickServe Online').getRecordTypeId();
        app5.IAM_Role__c = 'Field Test CMP Guidanz Mobile';
        app5.IAM_Status__c = 'Pending';
        app5.IAM_Account_Name__c = acc.id;
        app5.IAM_Subscription_Name__c = 'test';
        app5.IAM_Subscription_Start_Date__c=System.today();
        app5.IAM_Subscription_End_Date__c= System.today() + 3;
        app5.IAM_Subscription_Count__c = 10;
        app5.IAM_Free_Subscription__c= true;
        app5.IAM_License_Type__c = 'test';
        app5.IAM_Qsolexpiration__c = 'test';
        app5.IAM_Source__c = 'Marketplace';
        insert app5;
        app.add(app5);
        
        IAM_Application__c app6 = new IAM_Application__c();
        app6.IAM_Application_Name__c = 'Field Test Guidanz Mobile';
        app6.RecordTypeId=Schema.SObjectType.IAM_Application__c.getRecordTypeInfosByName().get('QuickServe Online').getRecordTypeId();
        app6.IAM_Role__c = 'Field Test Power Plus Lite Guidanz Mobile';
        app6.IAM_Status__c = 'Pending';
        app6.IAM_Account_Name__c = acc.id;
        app6.IAM_Subscription_Name__c = 'test';
        app6.IAM_Subscription_Start_Date__c=System.today();
        app6.IAM_Subscription_End_Date__c= System.today() + 3;
        app6.IAM_Subscription_Count__c = 10;
        app6.IAM_Free_Subscription__c= true;
        app6.IAM_License_Type__c = 'test';
        app6.IAM_Qsolexpiration__c = 'test';
        app6.IAM_Source__c = 'Marketplace';
        insert app6;
        app.add(app6);
        
        IAM_Application__c app13 = new IAM_Application__c();
        app13.IAM_Application_Name__c = 'Field Test Guidanz Mobile';
        app13.RecordTypeId=Schema.SObjectType.IAM_Application__c.getRecordTypeInfosByName().get('QuickServe Online').getRecordTypeId();
        app13.IAM_Role__c = 'Field Test PS PRO Guidanz Mobile';
        app13.IAM_Status__c = 'Pending';
        app13.IAM_Account_Name__c = acc.id;
        app13.IAM_Subscription_Name__c = 'test';
        app13.IAM_Subscription_Start_Date__c=System.today();
        app13.IAM_Subscription_End_Date__c= System.today() + 3;
        app13.IAM_Subscription_Count__c = 10;
        app13.IAM_Free_Subscription__c= true;
        app13.IAM_License_Type__c = 'test';
        app13.IAM_Qsolexpiration__c = 'test';
        app13.IAM_Source__c = 'Marketplace';
        insert app13;
        app.add(app13);
        
        IAM_Application__c app7 = new IAM_Application__c();
        app7.IAM_Application_Name__c = 'Field Test Guidanz Mobile';
        app7.RecordTypeId=Schema.SObjectType.IAM_Application__c.getRecordTypeInfosByName().get('QuickServe Online').getRecordTypeId();
        app7.IAM_Role__c = 'Field Test PS PRO Guidanz Mobile';
        app7.IAM_Status__c = 'Pending';
        app7.IAM_Account_Name__c = acc.id;
        app7.IAM_Subscription_Name__c = 'test';
        app7.IAM_Subscription_Start_Date__c=System.today();
        app7.IAM_Subscription_End_Date__c= System.today() + 3;
        app7.IAM_Subscription_Count__c = 10;
        app7.IAM_Free_Subscription__c= true;
        app7.IAM_License_Type__c = 'test';
        app7.IAM_Qsolexpiration__c = 'test';
        app7.IAM_Source__c = 'Marketplace';
        insert app7;
        app.add(app7);
        
        IAM_Application__c app2 = new IAM_Application__c();
        app2.IAM_Application_Name__c = 'FT - NPBU Diagnostics';
        app2.RecordTypeId=Schema.SObjectType.IAM_Application__c.getRecordTypeInfosByName().get('QuickServe Online').getRecordTypeId();
        app2.IAM_Role__c = 'BASIC';
        app2.IAM_Status__c = 'Pending';
        app2.IAM_Account_Name__c = acc.id;
        app2.IAM_Subscription_Name__c = 'test';
        app2.IAM_Subscription_Start_Date__c=System.today();
        app2.IAM_Subscription_End_Date__c= System.today() + 3;
        app2.IAM_Subscription_Count__c = 10;
        app2.IAM_Free_Subscription__c= true;
        app2.IAM_License_Type__c = 'test';
        app2.IAM_Qsolexpiration__c = 'test';
        app2.IAM_Source__c = 'Marketplace';
        insert app2;
        app3.add(app2);
        
        IAM_Application__c app10 = new IAM_Application__c();
        app10.IAM_Application_Name__c = 'FT - NPBU Diagnostics';
        app10.RecordTypeId=Schema.SObjectType.IAM_Application__c.getRecordTypeInfosByName().get('QuickServe Online').getRecordTypeId();
        app10.IAM_Role__c = 'Manufacturing';
        app10.IAM_Status__c = 'Pending';
        app10.IAM_Account_Name__c = acc.id;
        app10.IAM_Subscription_Name__c = 'test';
        app10.IAM_Subscription_Start_Date__c=System.today();
        app10.IAM_Subscription_End_Date__c= System.today() + 3;
        app10.IAM_Subscription_Count__c = 10;
        app10.IAM_Free_Subscription__c= true;
        app10.IAM_License_Type__c = 'test';
        app10.IAM_Qsolexpiration__c = 'test';
        app10.IAM_Source__c = 'Marketplace';
        insert app10;
        app3.add(app10);
        
        IAM_Application__c app11 = new IAM_Application__c();
        app11.IAM_Application_Name__c = 'FT - NPBU Diagnostics';
        app11.RecordTypeId=Schema.SObjectType.IAM_Application__c.getRecordTypeInfosByName().get('QuickServe Online').getRecordTypeId();
        app11.IAM_Role__c = 'Advance';
        app11.IAM_Status__c = 'Pending';
        app11.IAM_Account_Name__c = acc.id;
        app11.IAM_Subscription_Name__c = 'test';
        app11.IAM_Subscription_Start_Date__c=System.today();
        app11.IAM_Subscription_End_Date__c= System.today() + 3;
        app11.IAM_Subscription_Count__c = 10;
        app11.IAM_Free_Subscription__c= true;
        app11.IAM_License_Type__c = 'test';
        app11.IAM_Qsolexpiration__c = 'test';
        app11.IAM_Source__c = 'Marketplace';
        insert app11;
        app3.add(app11);
        
        IAM_Application__c app12 = new IAM_Application__c();
        app12.IAM_Application_Name__c = 'FT - NPBU Diagnostics';
        app12.RecordTypeId=Schema.SObjectType.IAM_Application__c.getRecordTypeInfosByName().get('QuickServe Online').getRecordTypeId();
        app12.IAM_Role__c = 'Pro';
        app12.IAM_Status__c = 'Pending';
        app12.IAM_Account_Name__c = acc.id;
        app12.IAM_Subscription_Name__c = 'test';
        app12.IAM_Subscription_Start_Date__c=System.today();
        app12.IAM_Subscription_End_Date__c= System.today() + 3;
        app12.IAM_Subscription_Count__c = 10;
        app12.IAM_Free_Subscription__c= true;
        app12.IAM_License_Type__c = 'test';
        app12.IAM_Qsolexpiration__c = 'test';
        app12.IAM_Source__c = 'Marketplace';
        insert app12;
        app3.add(app12);
        
        IAM_Application__c app8 = new IAM_Application__c();
        app8.IAM_Application_Name__c = 'Guidanz Mobile';
        app8.RecordTypeId=Schema.SObjectType.IAM_Application__c.getRecordTypeInfosByName().get('QuickServe Online').getRecordTypeId();
        app8.IAM_Role__c = 'Units';
        app8.IAM_Status__c = 'Pending';
        app8.IAM_Account_Name__c = acc.id;
        app8.IAM_Subscription_Name__c = 'test';
        app8.IAM_Subscription_Start_Date__c=System.today();
        app8.IAM_Subscription_End_Date__c= System.today() + 3;
        app8.IAM_Subscription_Count__c = 10;
        app8.IAM_Free_Subscription__c= true;
        app8.IAM_License_Type__c = 'test';
        app8.IAM_Qsolexpiration__c = 'test';
        app8.IAM_Source__c = 'Marketplace';
        insert app8;
        app9.add(app8);
        
        IAM_AccountAccessTriggerHandler.updateFields(app,true);
        IAM_AccountAccessTriggerHandler.updateFields(app,false);
        IAM_AccountAccessTriggerHandler.updateFields(app3,true);
        IAM_AccountAccessTriggerHandler.updateFields(app3,false);
        IAM_AccountAccessTriggerHandler.updateFields(app9,true);
        IAM_AccountAccessTriggerHandler.updateFields(app9,false);
    }
/* Test coverage for the class updateConProSubEndDate method */
    @isTest
    public static void updateConProSubEndDatetest() {
        Account acc = new account();
        acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('IAM').getRecordTypeId();
        acc.name = 'Test Account';
        acc.BillingCountryCode = 'CA';
        //acc.CMI_Address2__c = '';
        acc.BillingStreet = '351 MCALLISTER DR'; 
        acc.BillingCity = 'SAINT JOHN';
        acc.BillingCountry='Canada';
        acc.BillingStateCode = 'NB';
        acc.BillingPostalCode = 'E2J 2S8';
        acc.BillingState='New Brunswick';        
        acc.CSS_DistributorCode__c='56330';
        acc.CSS_DealerCode__c='test';
        acc.IAM_Internal_Account__c=false;
        acc.Type = 'Customer';
        acc.IAM_Service_Provider_Code__c = '123';
        insert acc;
        
        Contact con = IAM_TestData.createContact(acc.Id);
        
        List<IAM_Application__c> app= new List<IAM_Application__c>();
        Map<Id, IAM_Application__c> oldAppMap = new Map<Id, IAM_Application__c>();
        Map<Id, IAM_Application__c> newAppMap = new Map<Id, IAM_Application__c>();
        
        IAM_Application__c app4 = new IAM_Application__c();
        app4.IAM_Application_Name__c = 'Field Test Guidanz Mobile';
        app4.RecordTypeId=Schema.SObjectType.IAM_Application__c.getRecordTypeInfosByName().get('Guidanz').getRecordTypeId();
        app4.IAM_Role__c = 'Technician';
        app4.IAM_Status__c = 'Active';
        app4.IAM_Account_Name__c = acc.id;
        app4.IAM_Subscription_Name__c = 'test';
        app4.IAM_Subscription_Start_Date__c=System.today();
        app4.IAM_Subscription_End_Date__c= System.today() + 3;
        app4.IAM_Subscription_Count__c = 10;
        app4.IAM_Free_Subscription__c= true;
        app4.IAM_License_Type__c = 'test';
        app4.IAM_Qsolexpiration__c = 'test';
        app4.IAM_Source__c = 'Marketplace';
        app.add(app4);
        insert app4;       
        oldAppMap.put(app4.id,app4);
        app4.IAM_Subscription_End_Date__c= System.today() + 5;
        newAppMap.put(app4.id,app4);
        update app4;
        
        system.debug('app4'+app4.id);
        
        IAM_Application__c app5 = new IAM_Application__c();
        app5.IAM_Application_Name__c = 'Field Test Guidanz Mobile';
        app5.RecordTypeId=Schema.SObjectType.IAM_Application__c.getRecordTypeInfosByName().get('Guidanz').getRecordTypeId();
        app5.IAM_Role__c = 'Technician';
        app5.IAM_Status__c = 'Active';
        app5.IAM_Account_Name__c = acc.id;
        app5.IAM_Subscription_Name__c = 'test';
        app5.IAM_Subscription_Start_Date__c=System.today();
        app5.IAM_Subscription_End_Date__c= System.today() + 3;
        app5.IAM_Subscription_Count__c = 10;
        app5.IAM_Free_Subscription__c= true;
        app5.IAM_License_Type__c = 'test';
        app5.IAM_Qsolexpiration__c = 'test';
        app5.IAM_Source__c = 'Marketplace';
        insert app5;        
        newAppMap.put(app5.id,app5);
                
        List<IAM_Contact_Provisioning__c> icp= new List<IAM_Contact_Provisioning__c>();
        IAM_Contact_Provisioning__c obj = new IAM_Contact_Provisioning__c();
        obj.IAM_Contact__c= con.id; 
        obj.IAM_Start_Date__c = System.today();
        obj.IAM_End_Date__c = System.today()+1;
        obj.IAM_Application_Name__c = 'QuickServe Online';
        obj.IAM_Role__c = 'QSOL Distributor';
        obj.IAM_License_Type__c = 'test';
        obj.IAM_Status__c = 'Active';
        //obj.IAM_Account_Application__c = app4.id;
        obj.IAM_Account_Application__c = app[0].id;
        obj.IAM_Subscription_Name__c = 'test'; 
        //obj.IAM_Reject_Reason__c ='Subscription Expired';
        obj.IAM_Qsolexpiration__c = 'test';
        obj.RecordtypeId = Schema.SObjectType.IAM_Contact_Provisioning__c.getRecordTypeInfosByName().get('QuickServe Online').getRecordTypeId();   
        User u = [select id, Name, ProfileId, isActive  from User where Profile.Name = 'System Administrator' and isActive=true limit 1];
        System.runAs(u){
            insert obj;
        }
        icp.add(obj);
        
        List<IAM_Contact_Provisioning__c> conProList = [
            SELECT Id
            , IAM_End_Date__c
            , IAM_Account_Application__c,IAM_Status__c,IAM_Contact__r.Account.Type,IAM_Contact__r.Account.IAM_Internal_Account__c
            FROM IAM_Contact_Provisioning__c where IAM_Account_Application__c = :app4.id AND IAM_Status__c = 'Active' AND 
            IAM_Contact__r.Account.Type =: acc.Type AND IAM_Contact__r.Account.IAM_Internal_Account__c =: acc.IAM_Internal_Account__c
        ];
        system.debug('#### conProList'+conProList);
        IAM_AccountAccessTriggerHandler.updateConProSubEndDate(app,oldAppMap,newAppMap);
        
        //Account acc1 = IAM_TestData.createAccount();
        //Contact con1 = IAM_TestData.createContact(acc1.Id); 
        List<IAM_Application__c> applist123 = new List<IAM_Application__c>();
        List<IAM_Contact_Provisioning__c> icp1= new List<IAM_Contact_Provisioning__c>();
        
        IAM_Application__c app2 = new IAM_Application__c();
        app2.IAM_Application_Name__c = 'CUMPAS 2.0';
        app2.RecordTypeId=Schema.SObjectType.IAM_Application__c.getRecordTypeInfosByName().get('QuickServe Online').getRecordTypeId();
        app2.IAM_Role__c = 'Dealer User';
        app2.IAM_Status__c = 'Active';
        app2.IAM_Account_Name__c = acc.id;
        app2.IAM_Subscription_Name__c = 'test';
        app2.IAM_Subscription_Start_Date__c=System.today();
        app2.IAM_Subscription_End_Date__c= System.today()+1;
        app2.IAM_Subscription_Count__c = 9999;
        app2.IAM_Free_Subscription__c= true;
        app2.IAM_License_Type__c = 'test';
        app2.IAM_Qsolexpiration__c = 'test';
        app2.IAM_Source__c = 'Marketplace';
        app2.IAM_Cumpas_Modularity__c='View Credit';
        insert app2;
        system.debug('#### IAM_Application app2'+app2);
        applist123.add(app2);
        
        IAM_Contact_Provisioning__c obj7 = new IAM_Contact_Provisioning__c();
        obj7.IAM_Contact__c= con.id; 
        obj7.IAM_Start_Date__c = System.today();
        obj7.IAM_End_Date__c = System.today()+1;
        obj7.IAM_Application_Name__c = 'CUMPAS 2.0';
        obj7.IAM_Role__c = 'Dealer User';        
        obj7.IAM_Status__c = 'Active';
        obj7.IAM_Account_Application__c = app2.id;
        obj7.IAM_Cumpas_Modularity__c = 'View Credit';
        obj7.RecordtypeId = Schema.SObjectType.IAM_Contact_Provisioning__c.getRecordTypeInfosByName().get('CUMPAS 2.0').getRecordTypeId();   
        insert obj7;
              
        IAM_Contact_Provisioning__c obj1 = new IAM_Contact_Provisioning__c();
        obj1.IAM_Contact__c= con.id; 
        obj1.IAM_Start_Date__c = System.today();
        obj1.IAM_End_Date__c = System.today()+1;
        obj1.IAM_Application_Name__c = 'QuickServe Online';
        obj1.IAM_Role__c = 'QSOL Distributor';
        obj1.IAM_License_Type__c = 'test';
        obj1.IAM_Status__c = 'Active';
        obj1.IAM_Account_Application__c = app2.id;
        obj1.IAM_Subscription_Name__c = 'test'; 
        //obj.IAM_Reject_Reason__c ='Subscription Expired';
        obj1.IAM_Qsolexpiration__c='test';
        obj1.IAM_Cumpas_Modularity__c = 'View Credit';
        obj1.RecordtypeId = Schema.SObjectType.IAM_Contact_Provisioning__c.getRecordTypeInfosByName().get('QuickServe Online').getRecordTypeId();   
        User u1 = [select id, Name, ProfileId, isActive  from User where Profile.Name = 'System Administrator' and isActive=true limit 1];
        System.runAs(u1){
            insert obj1;
            system.debug('#### IAM_Application obj1'+obj1);
        }
        icp1.add(obj1);
        IAM_AccountAccessTriggerHandler.UpdateAccRole(applist123);
        
    }    
   /* Test coverage for the class AutorenewSubscriptions method */
    @isTest
    public static void AutorenewSubscriptionstest() {
        Account acc = IAM_TestData.createAccount();
        Contact con = IAM_TestData.createContact(acc.Id); 
        List<IAM_Application__c> app= new List<IAM_Application__c>();
        List<IAM_Contact_Provisioning__c> icp= new List<IAM_Contact_Provisioning__c>();
        
        IAM_Application__c app1 = new IAM_Application__c();
        app1.IAM_Application_Name__c = 'QuickServe Online';
        app1.RecordTypeId=Schema.SObjectType.IAM_Application__c.getRecordTypeInfosByName().get('QuickServe Online').getRecordTypeId();
        app1.IAM_Role__c = 'Technician';
        app1.IAM_Status__c = 'Active';
        app1.IAM_Account_Name__c = acc.id;
        app1.IAM_Subscription_Name__c = 'test';
        app1.IAM_Subscription_Start_Date__c=System.today();
        app1.IAM_Subscription_End_Date__c= System.today() + 3;
        app1.IAM_Subscription_Count__c = 10;
        app1.IAM_Free_Subscription__c= true;
        app1.IAM_License_Type__c = 'test';
        app1.IAM_Qsolexpiration__c = 'test';
        app1.IAM_Source__c = 'Marketplace';
        insert app1;
        
        IAM_Application__c app2 = new IAM_Application__c();
        app2.IAM_Application_Name__c = 'QuickServe Online';
        app2.RecordTypeId=Schema.SObjectType.IAM_Application__c.getRecordTypeInfosByName().get('QuickServe Online').getRecordTypeId();
        app2.IAM_Role__c = 'Technician';
        app2.IAM_Status__c = 'Inactive';
        app2.IAM_Account_Name__c = acc.id;
        app2.IAM_Subscription_Name__c = 'test';
        app2.IAM_Subscription_Start_Date__c=System.today();
        app2.IAM_Subscription_End_Date__c= System.today()+1;
        app2.IAM_Subscription_Count__c = 10;
        app2.IAM_Free_Subscription__c= true;
        app2.IAM_License_Type__c = 'test';
        app2.IAM_Qsolexpiration__c = 'test';
        app2.IAM_Source__c = 'Marketplace';
        insert app2;
        app.add(app1);
              
        IAM_Contact_Provisioning__c obj = new IAM_Contact_Provisioning__c();
        obj.IAM_Contact__c= con.id; 
        obj.IAM_Start_Date__c = System.today();
        obj.IAM_End_Date__c = System.today()+1;
        obj.IAM_Application_Name__c = 'QuickServe Online';
        obj.IAM_Role__c = 'QSOL Distributor';
        obj.IAM_License_Type__c = 'test';
        obj.IAM_Status__c = 'Inactive';
        obj.IAM_Account_Application__c = app2.id;
        obj.IAM_Subscription_Name__c = 'test'; 
        obj.IAM_Reject_Reason__c ='Subscription Expired';
        obj.RecordtypeId = Schema.SObjectType.IAM_Contact_Provisioning__c.getRecordTypeInfosByName().get('QuickServe Online').getRecordTypeId();   
        User u = [select id, Name, ProfileId, isActive  from User where Profile.Name = 'System Administrator' and isActive=true limit 1];
        System.runAs(u){
            insert obj;
        }
        icp.add(obj);
        
        IAM_AccountAccessTriggerHandler.AutorenewSubscriptions(app);
    }     
   @isTest
    public static void AccountAccessValidationForDistributortest() {
        Account acc = new account();
        acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('IAM').getRecordTypeId();
        acc.name = 'Test Account';
        acc.BillingCountryCode = 'CA';
        //acc.CMI_Address2__c = '';
        acc.BillingStreet = '351 MCALLISTER DR'; 
        acc.BillingCity = 'SAINT JOHN';
        acc.BillingCountry='Canada';
        acc.BillingStateCode = 'NB';
        acc.BillingPostalCode = 'E2J 2S8';
        acc.BillingState='New Brunswick';        
        acc.CSS_DistributorCode__c='56330';
        acc.CSS_DealerCode__c='test';
        acc.IAM_Internal_Account__c=false;
        acc.Type = 'Internal';
        acc.IAM_Service_Provider_Code__c = '123';
        insert acc;
        
        list<IAM_Application__c> obj = new list<IAM_Application__c>();
        IAM_Application__c app5 = new IAM_Application__c();
        app5.IAM_Application_Name__c = 'Guidanz';
        app5.RecordTypeId=Schema.SObjectType.IAM_Application__c.getRecordTypeInfosByName().get('Guidanz').getRecordTypeId();
        app5.IAM_Role__c = 'Technician';
        app5.IAM_Status__c = 'Active';
        app5.IAM_Account_Name__c = acc.id;
        app5.IAM_Subscription_Name__c = 'test';
        app5.IAM_Subscription_Start_Date__c=System.today();
        app5.IAM_Subscription_End_Date__c= System.today() + 3;
        app5.IAM_Subscription_Count__c = 10;
        app5.IAM_Free_Subscription__c= true;
        app5.IAM_License_Type__c = 'test';
        app5.IAM_Qsolexpiration__c = 'test';
        app5.IAM_Source__c = 'Marketplace';
        insert app5;
        obj.add(app5);
       // List<IAM_WWSPS_HQ_Regions__mdt> ActualAccountName=[Select id,MasterLabel from IAM_WWSPS_HQ_Regions__mdt where MasterLabel Like :userRoleSplit LIMIT 1];
        
        IAM_AccountAccessTriggerHandler.AccountAccessValidationForDistributor(obj,true);
        IAM_AccountAccessTriggerHandler.AccountAccessValidationForDistributor(obj,false);
    } 
    @isTest
    public static void onBeforeInsertAndUpdatetest() {
        
        Account acc = IAM_TestData.createAccount();
        Contact con = IAM_TestData.createContact(acc.Id);
        
        list<IAM_Application__c> obj = new list<IAM_Application__c>();
        list<IAM_Application__c> obj1 = new list<IAM_Application__c>();
        
        list<IAM_Application__c> objold = new list<IAM_Application__c>();
        map<id, IAM_Application__c> mapOldIdIamApplication = new map<id, IAM_Application__c>();
        map<id, IAM_Application__c> mapNewIdIamApplication = new map<id, IAM_Application__c>();
        //map<id, IAM_Application__c> mapOldIdIamApplication1 = new map<id, IAM_Application__c>();
        
        IAM_Application__c app5 = new IAM_Application__c();
        app5.IAM_Application_Name__c = 'Guidanz';
        app5.RecordTypeId=Schema.SObjectType.IAM_Application__c.getRecordTypeInfosByName().get('Guidanz').getRecordTypeId();
        app5.IAM_Role__c = 'Technician';
        app5.IAM_Status__c = 'Active';
        app5.IAM_Account_Name__c = acc.id;
        app5.IAM_Subscription_Name__c = 'test';
        app5.IAM_Subscription_Start_Date__c=System.today();
        app5.IAM_Subscription_End_Date__c= System.today() + 3;
        app5.IAM_Subscription_Count__c = 10;
        app5.IAM_Free_Subscription__c= true;
        app5.IAM_License_Type__c = 'test';
        app5.IAM_Qsolexpiration__c = 'test';
        app5.IAM_Source__c = 'Marketplace';
        app5.IAM_Cumpas_Modularity__c = 'View Credit';
        insert app5;
        obj.add(app5);
        app5.IAM_Subscription_Count__c=9999;
        //app5.IAM_Role__c = 'Beta Testing Guidanz Mobile';
        update app5;
        objold.add(app5);
        mapNewIdIamApplication.put(app5.id,app5);
        mapOldIdIamApplication.put(app5.id,app5);
        
        
        IAM_AccountAccessTriggerHandler.onBeforeInsertAndUpdate(obj,objold,mapNewIdIamApplication,mapOldIdIamApplication,true,false);
       // IAM_AccountAccessTriggerHandler.onBeforeInsertAndUpdate(obj1,objold,mapNewIdIamApplication,mapOldIdIamApplication1,true,false);
    }
    
    //added as part of FT Guidanz Mobile changes - @Anupam
    @isTest
    public static void autoCreateUserFeatureForGuidanzTest() {
        
        list<IAM_Application__c> appFeatureList = new list<IAM_Application__c>();
        set<Id> accIdSet = new set<Id>();
        List<Contact> conRecList = new List<Contact>();
        
        Account acc = IAM_TestData.createAccount();
        acc.Type = 'Individual';
        update acc;
        Contact con = IAM_TestData.createContact(acc.Id);
        
        IAM_Application__c app = new IAM_Application__c();
        app.IAM_Application_Name__c = 'Field Test Guidanz Mobile';
        app.RecordTypeId=Schema.SObjectType.IAM_Application__c.getRecordTypeInfosByName().get('Field Test Guidanz Mobile').getRecordTypeId();
        app.IAM_Role__c = 'Field Test SRV Guidanz Mobile';
        app.IAM_Guidanz_Mobile_Roles__c = 'Field Test SRV Guidanz Mobile';
        app.IAM_Status__c = 'Active';
        app.IAM_swregExpire__c = 'SRVF-12/31/2100';
        app.IAM_Account_Name__c = acc.id;
        app.IAM_Subscription_Name__c = 'Field Test SRV Guidanz Mobile';
        app.IAM_Subscription_Start_Date__c=System.today();
        app.IAM_Subscription_End_Date__c= System.today() + 5;
        app.IAM_Subscription_Count__c = 10;
        app.IAM_Total_Units__c = 6;
        app.IAM_Free_Subscription__c= true;
        app.IAM_License_Type__c = 'test';
        app.IAM_Qsolexpiration__c = 'test';
        app.IAM_Source__c = 'IAM';
        appFeatureList.add(app);
        insert app;
        
        List<IAM_Application__c> appList = [Select Id, IAM_Status__c, IAM_Role__c, IAM_Application_Name__c, Account_Type__c,IAM_Subscription_Name__c,
                                           IAM_Account_Name__c,IAM_Guidanz_Mobile_Roles__c,IAM_swregExpire__c,IAM_Subscription_Start_Date__c,
                                            IAM_Subscription_End_Date__c,IAM_Assigned_Units__c,IAM_Remaining_Units__c,IAM_Total_Units__c,IAM_Source__c
                                            from IAM_Application__c where IAM_Role__c = 'Field Test SRV Guidanz Mobile' limit 1];
        
        accIdSet.add(appList[0].IAM_Account_Name__c);
        
        conRecList = [select Id,AccountId,Account.Name,IAM_Contact_Owner__c from Contact where AccountId IN : accIdSet AND IAM_Contact_Status__c = 'Active'];
        
        
        Test.startTest();
        IAM_AccountAccessTriggerHandler.autoCreateUserFeatureForGuidanz(appList);
        Test.stopTest();
        
    }
    
    /*Test coverage for the class updateConProSubEndDate method */
    @isTest
    public static void updateConProSubEndDatetest2() {
    
        Account acc = new account();
        acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('IAM').getRecordTypeId();
        acc.name = 'Test Account';
        acc.BillingCountryCode = 'CA';
        //acc.CMI_Address2__c = '';
        acc.BillingStreet = '351 MCALLISTER DR'; 
        acc.BillingCity = 'SAINT JOHN';
        acc.BillingCountry='Canada';
        acc.BillingStateCode = 'NB';
        acc.BillingPostalCode = 'E2J 2S8';
        acc.BillingState='New Brunswick';        
        acc.CSS_DistributorCode__c='56330';
        acc.CSS_DealerCode__c='test';
        acc.IAM_Internal_Account__c=false;
        acc.Type = 'Customer';
        acc.IAM_Service_Provider_Code__c = '123';
        insert acc;
        
        Contact con = IAM_TestData.createContact(acc.Id);
       
        List<IAM_Application__c> app= new List<IAM_Application__c>();
        Map<Id, IAM_Application__c> oldAppMap = new Map<Id, IAM_Application__c>();
        Map<Id, IAM_Application__c> newAppMap = new Map<Id, IAM_Application__c>();
        
        IAM_Application__c app4 = new IAM_Application__c();
        app4.IAM_Application_Name__c = 'Field Test Guidanz Mobile';
        app4.RecordTypeId=Schema.SObjectType.IAM_Application__c.getRecordTypeInfosByName().get('Guidanz').getRecordTypeId();
        app4.IAM_Role__c = 'Technician';
        app4.IAM_Status__c = 'Active';
        app4.IAM_Account_Name__c = acc.id;
        app4.IAM_Subscription_Name__c = 'test';
        app4.IAM_Subscription_Start_Date__c=System.today();
        app4.IAM_Subscription_End_Date__c= System.today() + 3;
        app4.IAM_Subscription_Count__c = 10;
        app4.IAM_Free_Subscription__c= true;
        app4.IAM_License_Type__c = 'test';
        app4.IAM_Qsolexpiration__c = 'test';
        app4.IAM_Source__c = 'Marketplace';
        app.add(app4);
        insert app4;       
        oldAppMap.put(app4.id,app4);
        app4.IAM_Subscription_End_Date__c= System.today() + 5;
        newAppMap.put(app4.id,app4);
        update app4;
        
        system.debug('app4'+app4.id);
        
        IAM_Application__c app5 = new IAM_Application__c();
        app5.IAM_Application_Name__c = 'Field Test Guidanz Mobile';
        app5.RecordTypeId=Schema.SObjectType.IAM_Application__c.getRecordTypeInfosByName().get('Guidanz').getRecordTypeId();
        app5.IAM_Role__c = 'Technician';
        app5.IAM_Status__c = 'Active';
        app5.IAM_Account_Name__c = acc.id;
        app5.IAM_Subscription_Name__c = 'test';
        app5.IAM_Subscription_Start_Date__c=System.today();
        app5.IAM_Subscription_End_Date__c= System.today() + 3;
        app5.IAM_Subscription_Count__c = 10;
        app5.IAM_Free_Subscription__c= true;
        app5.IAM_License_Type__c = 'test';
        app5.IAM_Qsolexpiration__c = 'test';
        app5.IAM_Source__c = 'Marketplace';
        insert app5;        
        newAppMap.put(app5.id,app5);
        
        IAM_AccountAccessTriggerHandler.updateConProSubEndDate(app,oldAppMap,newAppMap);
    
    }
    
     
}