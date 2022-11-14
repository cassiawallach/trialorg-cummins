/********************************************************************************
=============================================================
Purpose:                                                            
This is handler class of OSM_SW_ContactAccessRoleUpdate_Test                   
=============================================================
=============================================================
History                                                            
-------                                                            
VERSION       AUTHOR                      DATE               DETAIL                                
1.0 -         Nandigam Sasi               09/03/2020        INITIAL DEVELOPMENT 
1.1 -         Nandigam Sasi               22/04/2020        Updated  

*****************************************************/
/********************************************************************************
***********************************************************************************/


@isTest
public class OSM_SW_ContactAccessRoleUpdate_Test {
    
    
    /* Update Account Access & Feature Object Test */
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
}