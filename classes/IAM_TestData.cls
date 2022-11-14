/************************************************************
Name:  IAM_TestData
Copyright © 2019  Cummins
=============================================================
=============================================================
Purpose:                                                            
Below class will make maily three parts. LDAP oAuthcall. call request builder class to build JSON request and parser class to parse the JSON.
JSON mainly consists of the data regarding the Contact.  2                      
=============================================================
=============================================================
History                                                            
-------                                                            
VERSION         AUTHOR                DATE              DETAIL                                
1.0 -    Shubhangi Sardar          11/16/2018        INITIAL DEVELOPMENT
1.1 -    Karthik Raj Golakaram     11/16/2020     Made changes for Mule API.Add CSS integratoin method 
1.2 -    Karthik Raj Golakaram     01/08/2021     Made changes for AWS IDP name changes
1.3 -    Anupam Adhikari           12/11/2021     added changes for Global Dealer Portal 
1.4      Sandeep Vuyyuru           03/03/2022     Made changes for the PowerSpec Request Access enhancement    
*****************************************************/
/********************************************************************************
***********************************************************************************/

@isTest
public class IAM_TestData {

    //Method to create CSS Integration Record added by Karthik Golakaram 12-11-2020.
    Public Static CSS_Integration_Details__c createIntegrationDetails(String appName){
        
        CSS_Integration_Details__c iamCDH = new CSS_Integration_Details__c();
        Blob key = Blob.valueOf('12345678901234567890123456789012');
        iamCDH.Name = appName;
        iamCDH.ApplicationName__c =appName.left(10);
        iamCDH.End_Point__c = 'https://testconnection.com';
        iamCDH.IsActive__c = TRUE;
        iamCDH.Key__c = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('1234')));
        iamCDH.Passcode__c = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('1234')));
        iamCDH.Username__c = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('1234')));
        //Added below two lines for IAM purpose by Karthik Golakaram
        iamCDH.Logging__c ='IAMCDH' ;
        iamCDH.Method_Type__c ='POST' ;
        iamCDH.AuthEnv__c='IAMCDH' ;
        iamCDH.grant_type__c='Client_credentials';
        iamCDH.Resource__c='https://testconnections.com';
        iamCDH.Timeout__c=120000;
          
        insert iamCDH;
        return iamCDH;
  }
  
  //End of code addition -KArthik Golakaram -12/11/2020


    /* Return - CUMPAS - App Mapping Record*/
    public static App_Mapping__c getCumpasApp() {
        return getAppMapping('CUMPAS 2.0', 'OAM12c', true, 'IAM_Cumpas_BusinessAdmins', true, false, true, 'Company',
                            false, 'Dealer User', null, null, null);
    }
    
    /* Return - Connected Solutions - App Mapping Record*/
    public static App_Mapping__c getDAApp() {
        return getAppMapping('Connected Solutions','SAML', true, 'IAM_DA_BusinessAdmins', false, false, true, 'Company',
                            true, 'PrimaryContact;AccountManager;ServiceTechnician;Operator', null, null, null);
    }
    
    /* Return - Guidanz Mobile - App Mapping Record*/
    public static App_Mapping__c getGuidanzMobileApp() {
        return getAppMapping('Guidanz Mobile','SM', false, null, false, true, true, 'Individual',
                            false, 'Guidanz Mobile User', null, null, null);
    }
    
    /* Return - EDS - App Mapping Record*/
    public static App_Mapping__c getEDSApp() {
        return getAppMapping('EDS','SAML', false, null, false, true, false, null, false, 'Technician', null, null, null);
    }
    
    /* Return - Marketplace - App Mapping Record*/
    public static App_Mapping__c getMarketplaceApp() {
        return getAppMapping('Marketplace','SAML', true, null, false, false, true, 'Company;Individual', false, 
                             'User', null, null, null);
    }
    
    /* Return - Rapid Serve Web - App Mapping Record*/
    public static App_Mapping__c getRSWApp() {
        return getAppMapping('Rapid Serve Web','SAML', true, null, true, false, true, 'Individual', true, 
                             'Basic', null, null, null);
    }
    
    /* Return - Identity and Access Management - App Mapping Record*/
    public static App_Mapping__c getIAMApp() {
        return getAppMapping('Identity and Access Management','SAML', false, 'Identity and Access Management', false, 
                             false, false, null, false, 'User', null, null, null);
    }

    /*Return - Global Dealer Portal - App Mapping Record*/
    public static App_Mapping__c getGDPApp() {
        return getAppMapping('Global Dealer Portal','SAML', true, null, true, false, false, null, true, 
                             'Non-Dealer User', null, null, null);
    }
    
    /*Return - Guidanz Service Portal - App Mapping Record*/
    public static App_Mapping__c getGuiServicePortalApp() {
        return getAppMapping(Label.IAM_AppName_GuidanzServicePortal,'SAML', false, null, true, false, true,
                             'Individual', true,'General User', null, null, null);
    }
    
    /* Create and return app mapping record */
    private static App_Mapping__c getAppMapping(String name, String protectedBy, Boolean approvalNeeded, 
    String queueName, Boolean authRequired, Boolean paidSubscription, Boolean reg, String regType, Boolean reqAccess, 
    String role, String emailAccount, String emailContact, String emailGroup) {
        App_Mapping__c app = new App_Mapping__c();
        app.Name = name;
        app.IAM_App_Protected_By__c = protectedBy;
        app.IAM_Approval_Needed__c = approvalNeeded;        
        app.IAM_approver_queue_name__c = queueName;
        app.IAM_Authroization_Required__c = authRequired;        
        app.IAM_Paid_Subscription__c = paidSubscription;
        app.Registration__c = reg;
        app.IAM_Registration_Type__c = regType;
        app.IAM_Request_Access__c = reqAccess;        
        app.IAM_Default_Role__c = role;        
        app.IAM_Approver_Email_Account_Feature_Field__c = emailAccount;
        app.IAM_Approver_Email_Contact_Field__c = emailContact;
        app.IAM_Approver_Email_Group__c = emailGroup;
        insert app;
        return app;
    }
    
    /* Create and return app mapping record */
    public static App_Mapping__c getHighRadiusApp() {
        App_Mapping__c app = new App_Mapping__c();
        app.Name = 'HighRadius';
        app.Registration__c = True;
        app.IAM_Registration_Type__c = 'Basic';
        app.IAM_Request_Access__c = True;        
        app.IAM_Default_Role__c = 'User'; 
        app.IAM_App_Protected_By__c ='SAML';       
        insert app;
        return app;
    }
    
    /* Create and return PoweSpec app mapping record */
    public static App_Mapping__c getPoweSpecApp() {
        App_Mapping__c app = new App_Mapping__c();
        app.Name = 'PowerSpec';
        app.Registration__c = True;
        app.IAM_Registration_Type__c = '';
        app.IAM_Request_Access__c = True;        
        app.IAM_Default_Role__c = 'PowerSpec_Basic'; 
        app.IAM_App_Protected_By__c ='SAML';       
        insert app;
        return app;
    }
    
    /* Create - CSS_Integration_Details__c - IAM_GL_Service */
    public static void create_IAM_GL_Service_CS() {
        createCSSIntegrationDetails('IAM_GL_Service', 'IAM_GL_Service', null, 'https://services-stg.cummins.com/iamgl/getspsearchresults',
        null, true, 'rZAd55IuOWyWUkvYaYqixRv2DPXOGc9QQP5XssF8cH6O3aCoePMrMK/dZ50jN5F6aqI/LFOVVKtE4QzlUKDxWA==', null, 'POST', 'wOXXcO0IDYfpb8RvkBN6ut8UaHhHdLM0IcvcQLR/NhsVRBgClv0XJvjJorIhNsMsu60kbGmqrvDXZAfr8vzVSw==', null, 'mNMF0ONaExTlp94fe62/6lKzyrlOf3VZTodR6iqsGXU=');
    }
    
    /* Create - CSS_Integration_Details__c - IAM_GL_Service */
    public static void create_IAM_EDQ_oAuth_CS() {
        createCSSIntegrationDetails('IAM_EDQ_oAuth', 'IAM_EDQ_oAuth', 'OAGoAuth', 'https://services-stg-oauth.cummins.com/api/oauth/token/cdh',
        'client_credentials', true, 'rZAd55IuOWyWUkvYaYqixRv2DPXOGc9QQP5XssF8cH6O3aCoePMrMK/dZ50jN5F6aqI/LFOVVKtE4QzlUKDxWA==', 'CDH', 'POST', 'wOXXcO0IDYfpb8RvkBN6ut8UaHhHdLM0IcvcQLR/NhsVRBgClv0XJvjJorIhNsMsu60kbGmqrvDXZAfr8vzVSw==', 120000, 'mNMF0ONaExTlp94fe62/6lKzyrlOf3VZTodR6iqsGXU=');
    }
    
    /* Create - CSS_Integration_Details__c - IAM_CDH_SyncCustomer */
    public static void create_CDH_SynCust_CS() {
        createCSSIntegrationDetails('IAM_CDH_Sync_Customer', 'IAM_CDH_Sync_Customer', 'OAGoAuth', 'https://guidanzu-dev.cummins.com/ServiceTraining/public/WS/sfim/update_service_training_user_status.php',
        'client_credentials', true, 'jb6sFHd/KsMjdprFnsnLjPgCf+19v/kh49PHL/bjYO7DmigbFZdIaXN7gVS0/fg06Fx9fPolnF3guPkOncLwHA==',
        'LADAPUtil', 'POST', 'lhBxWDMxDkfiIXb2hsMD/sC0HJUv4CRi4HlvvXUtopNctqUHq07R8MVrFKNqGJELb2meudGeoTKfD7yjHDdUJA==',
         120000, 'SHnBSQhHEqF+DQgb+tSI6K6+EqIKGt/1yWj/4tG4KG4=');
    }
    
    /* Create Custom Setting CSS_Integration_Details__c */
    public static void createCSSIntegrationDetails(String name, String appName, String authEnv, String endpoint, 
        String grantType, Boolean isActive, String key, String logging, String methodType, String passcode, 
        Integer timeout, String username) {
        CSS_Integration_Details__c obj = new CSS_Integration_Details__c();
        obj.Name = name;
        obj.ApplicationName__c = appName;
        obj.AuthEnv__c = authEnv;
        obj.End_Point__c = endpoint;
        obj.grant_type__c = grantType;
        obj.IsActive__c = isActive;
        obj.Key__c = key;
        obj.Logging__c = logging;
        obj.Method_Type__c = methodType;
        obj.Passcode__c = passcode;
        obj.Timeout__c = timeout;
        obj.Username__c = username;
        insert obj;
    }
    
    public static Account createAccount() {
        Account acc = new account();
        acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('IAM').getRecordTypeId();
        acc.name = 'Test Account';
        acc.BillingCountryCode = 'CA';
        acc.CMI_Address2__c = '';
        acc.BillingStreet = '351 MCALLISTER DR'; 
        acc.BillingCity = 'SAINT JOHN';
        acc.BillingCountry='Canada';
        acc.BillingStateCode = 'NB';
        acc.BillingPostalCode = 'E2J 2S8';
        acc.BillingState='New Brunswick';        

        acc.CSS_DistributorCode__c='56330';
        acc.CSS_DealerCode__c='test';
        
        acc.Type = 'Dealer Account';
        acc.IAM_Service_Provider_Code__c = '123';
        insert acc;
        return acc;
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
        con.IAM_Contact_Status__c = 'Active';
        con.CMI_Contact_Type__c='Secondary';
        //con.IAM_Contact_source__c='QSOL';
        insert con;
        return con;
    }
    
    /* Create User */
    public static User createUser(Contact con, Account acc, String profileName) {
        List<profile> pf = [select Id,Name from Profile WHERE Name = :profileName limit 1];
        User newUser = new User();
        newUser.FirstName = con.FirstName;
        newUser.LastName = con.LastName;
        newUser.Email = con.Email;   
        newUser.CompanyName = acc.Name;        
        newUser.CommunityNickname = 'tts';
        newUser.Username = con.Username__c ;
        newUser.Alias = 'tts';
        newUser.TimeZoneSidKey = 'GMT';
        newUser.LocaleSidKey= 'en_US';
        newUser.EmailEncodingKey = 'UTF-8';
        newUser.LanguageLocaleKey = 'en_US';         
        newUser.ProfileId = pf[0].Id ;                                  
        newUser.ContactId = con.Id;                   
        newUser.isActive = true;
        newUser.Street = '123 Test St';
        newUser.FederationIdentifier = '2468741';
        insert newUser;
        return newUser;
    }
    
    /* Create test User data */
    public static void createUser(Contact con) {
        List<Contact> conList = new List<Contact>();
        conList.add(con);
        IAM_CreateUser.CreateUser(conList); 
    }
    
    /* Create and return IAM_Application__c record for given Account */
    public static IAM_Application__c createAccountSubscription(Id accId, String appName, String subName, Date stDate, 
        Date edDate, String subType, String source, String swExpire, String qsolExpire, String role, String licenseType, Boolean free) {
        IAM_Application__c obj = new IAM_Application__c();
        obj.IAM_Account_Name__c = accId;                
        obj.IAM_Subscription_Start_Date__c = stDate;
        obj.IAM_Subscription_End_Date__c = edDate;
        obj.IAM_Subscription_Count__c = 9999;
        obj.IAM_Application_Name__c = appName;
        obj.IAM_Role__c = role;
        if(appName == Label.IAM_Guidanz_Mobile_App_Name){
            System.debug('Printing Role Name for Guidanz mobile application');
            obj.IAM_Guidanz_Mobile_Roles__c = role;
            obj.IAM_swregExpire__c = swExpire;
        }
        if(appName == Label.IAM_AppName_QSOL){
            System.debug('Printing Role Name for Guidanz mobile application');
            obj.IAM_Qsolexpiration__c = qsolExpire;
        }
        obj.IAM_Status__c = 'Active';
        obj.IAM_Subscription_Name__c = subName;
        obj.RecordtypeId = Schema.SObjectType.IAM_Application__c.getRecordTypeInfosByName().get(appName).getRecordTypeId();
        System.debug('#### Account access obj '+obj);
        //insert obj;
        return obj;
    }
    
    /* Create and return IAM_Application__c record for given Account */
    public static IAM_Application__c createAccountSubscription(Id accId, String appName, String appRole,Contact con) {
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
        obj.IAM_Status__c = 'Active';
        obj.IAM_Subscription_Name__c = appName;
        //obj.RecordtypeId = Schema.SObjectType.IAM_Application__c.getRecordTypeInfosByName().get(appName).getRecordTypeId();
        System.debug('#### Account access obj '+obj);
        //User u = [SELECT Id FROM User WHERE UserName=:Con.Username__c];
        //System.runAs(u){
            insert obj;
        //}
        return obj;
    } 
    
    
      /* Create and return IAM_Application__c record for given Account -Added by Karthik */
    public static IAM_Application__c createAccountSubscription(Id accId, String appName, String appRole) {
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
        obj.IAM_Status__c = 'Active';
        obj.IAM_Subscription_Name__c = appName;
        //obj.RecordtypeId = Schema.SObjectType.IAM_Application__c.getRecordTypeInfosByName().get(appName).getRecordTypeId();
        System.debug('#### Account access obj '+obj);
        User u = [select id, Name, ProfileId, isActive  from User where Profile.Name = 'System Administrator' and isActive=true limit 1];
        System.runAs(u){
            insert obj;
        }
        return obj;
    } 
    
    
    /* Create IAM_Contact_Provisioning__c object record  */
    public static void createUserSubscription(Id conId, Id accAccFeatureId, String appName, String subName, 
        Date stDate, Date edDate, String subType, String source, String swExpire, String qsolExpire, String role, 
        String licenseType) {
        IAM_Contact_Provisioning__c obj = new IAM_Contact_Provisioning__c();
        obj.IAM_Contact__c= conId; 
        obj.IAM_Start_Date__c = stDate;
        obj.IAM_End_Date__c = edDate;
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
        obj.IAM_License_Type__c = licenseType;
        obj.IAM_Status__c = subType;
        obj.IAM_Account_Application__c = accAccFeatureId;
        obj.IAM_Subscription_Name__c = subName;        
        obj.RecordtypeId = Schema.SObjectType.IAM_Contact_Provisioning__c.getRecordTypeInfosByName().get(appName).getRecordTypeId();                 
        User u = [select id, Name, ProfileId, isActive  from User where Profile.Name = 'System Administrator' and isActive=true limit 1];
        System.runAs(u){
            insert obj;
        }
        System.debug('#### User access obj '+obj);
    }

    /* Create and return IAM_Application__c count record for given Account  */
    public static IAM_Application__c createAccountSubscriptionGMFT(Id accId, String appName, 
    String appRole) {
        IAM_Application__c obj = new IAM_Application__c();
        obj.IAM_Account_Name__c = accId;                
        obj.IAM_Subscription_Start_Date__c = Date.today();
        obj.IAM_Total_Units__c = 10;
        obj.IAM_Subscription_Count__c = 9999;
        obj.IAM_Application_Name__c = appName;
        obj.IAM_Role__c = appRole;
        obj.IAM_Guidanz_Mobile_Roles__c = appRole;
        obj.IAM_Status__c = 'Active';
        obj.IAM_Subscription_Name__c = appRole;
        obj.RecordtypeId = Schema.SObjectType.IAM_Application__c.getRecordTypeInfosByName().get(appName).getRecordTypeId();
        System.debug('#### Account access obj '+obj);
        User u = [select id, Name, ProfileId, isActive  from User where Profile.Name = 'System Administrator' and isActive=true limit 1];
        System.runAs(u){
            insert obj;
        }
        return obj;
    }
    
    /* Create IAM_Contact_Provisioning__c count object record  */
    public static void createUserSubscriptionGMFT(Id conId, Id accAccFeatureId, String appName,
    String role) {
        IAM_Contact_Provisioning__c obj = new IAM_Contact_Provisioning__c();
        obj.IAM_Contact__c= conId; 
        obj.IAM_Application_Name__c = appName;
        obj.IAM_Role__c = role;
        obj.IAM_Guidanz_Mobile_Roles__c = role;
        obj.IAM_Assigned_Units__c = 4;
        obj.IAM_Remaining_Units__c = 4;
        obj.IAM_Status__c = 'Active';
        obj.IAM_Account_Application__c = accAccFeatureId;
        obj.IAM_Subscription_Name__c = role;        
        obj.RecordtypeId = Schema.SObjectType.IAM_Contact_Provisioning__c.getRecordTypeInfosByName().get(appName).getRecordTypeId();                 
        User u = [select id, Name, ProfileId, isActive  from User where Profile.Name = 'System Administrator' and isActive=true limit 1];
        System.runAs(u){
            insert obj;
        }
        System.debug('#### User access obj '+obj);
    }
    
    public static String testResponseCDH() {
        return        '{  '+
        '   "createOrganization_Output":{  '+
        '      "Error_spcMessage":"",'+
        '      "Object_spcId":"",'+
        '      "Process_spcInstance_spcId":"1-4NC3OP",'+
        '      "ExternalSourceName":"IAM",'+
        '      "AccntId":"",'+
        '      "RealtimePubSub":true,'+
        '      "Id":"BILL TO&#124;C000338724",'+
        '      "ListOfSwiOrganizationIO":{  '+
        '         "Account":{  '+
        '            "DistributorCode":"",'+
        '            "InsuranceNumber":"",'+
        '            "AnnualRevenueVanilla":"",'+
        '            "PartyName":"AGGREKO",'+
        '            "LineofBusiness":"",'+
        '            "ParentHQDUNS":"",'+
        '            "CurrencyCode":"USD",'+
        '            "CumulativeSales":"",'+
        '            "AccountStatus":"Active",'+
        '            "UpdatedBy":"1-2Q2X",'+
        '            "FacilityFlag":"N",'+
        '            "PartyTypeCode":"Organization",'+
        '            "GrossPotentialValue":"",'+
        '            "MasterAccountId":"1-F1QE0",'+
        '            "EmployeeHere":"",'+
        '            "Status":"",'+
        '            "ErrorDescription":"",'+
        '            "FederalTaxNumber":"",'+
        '            "Updated":"01/10/2019 11:43:35",'+
        '            "AccountRegion":"",'+
        '            "IntegrationId":"",'+
        '            "CDHPartyName":"",'+
        '            "MainFaxNumber":"NA",'+
        '            "Unionized":"",'+
        '            "GlobalMatchId":"IAM&#124;BILL TO&#124;C000338724",'+
        '            "ListOfAccount_BusinessAddress":{  '+
        '               "Account_BusinessAddress":{  '+
        '                  "AddressSurvivorshipFlag":"",'+
        '                  "NCOALinkNewMoveType":"",'+
        '                  "Latitude":"",'+
        '                  "NCOALinkNewMoveEffectiveDate":"",'+
        '                  "UpdatedBy":"1-2Q2X",'+
        '                  "AddressCleanseGeoAccuracyCode":"U0",'+
        '                  "AddressCleanseVerifiedFlag":"Y",'+
        '                  "LargePrisonFlag":"",'+
        '                  "AddressId":"BILL TO&#124;C000338722",'+
        '                  "AddressCleanseGeoAccuracyDistance":"",'+
        '                  "AddressLink":"",'+
        '                  "ErrorDescription":"",'+
        '                  "Updated":"01/10/2019 10:55:08",'+
        '                  "MetroArea":"",'+
        '                  "City":"COLUMBUS",'+
        '                  "Longitude":"",'+
        '                  "EmailAddress":"",'+
        '                  "Province":"",'+
        '                  "Neighborhood":"",'+
        '                  "AddressLine3":"",'+
        '                  "AddressName":"IAM&#124;BILL TO&#124;C000338722",'+
        '                  "AddressLine2":"",'+
        '                  "AddressLine1":"400 JACKSON ST",'+
        '                  "State":"IN",'+
        '                  "AddressLine4":"",'+
        '                  "Country":"",'+
        '                  "Region":"AMERICAS",'+
        '                  "AIAUCMIntegrationId":"",'+
        '                  "AddressCleanseGeoAccuracyStatus":"Unable to geocode; 0 - None",'+
        '                  "DSFSeasonalIndicator":"",'+
        '                  "AllAddrCombination":"400 JACKSON ST&#124;&#124;&#124;&#124;COLUMBUS&#124;IN&#124;&#124;47201-6783&#124;US",'+
        '                  "PostalCode":"47201-6783",'+
        '                  "AddressCleanseVerifiedStatus":"Verified; 4 - Premise; Identified and parsed; Primary and secondary postal codes verified; Score 100",'+
        '                  "County":"",'+
        '                  "AddressIntegrationId":"",'+
        '                  "OptOutInaccurateRecordFlag":"",'+
        '                  "BillAddressFlag":"N",'+
        '                  "BusinessAddressEndDate":"",'+
        '                  "searchspec":"",'+
        '                  "PostalAddressFlags":"",'+
        '                  "CountryCode":"US",'+
        '                  "SubRegion":"NORTHERN AMERICA",'+
        '                  "IsPrimaryMVG":"Y",'+
        '                  "ErrorFlag":"N",'+
        '                  "StateProvinceFlag":"S",'+
        '                  "DSFDeliveryType":"",'+
        '                  "CDHAddressLine4":"",'+
        '                  "CDHAddressLine3":"",'+
        '                  "ShipAddressFlag":"N",'+
        '                  "CDHAddressLine2":"",'+
        '                  "DeliveryPointBarcode":"",'+
        '                  "CDHAddressLine1":"",'+
        '                  "operation":"",'+
        '                  "CarrierRouteCode":"",'+
        '                  "AddressCleanseVerificationCode":"V44-I44-P8-100"'+
        '               }'+
        '            },'+
        '            "ListOfAccount_CrossReference":{  '+
        '               "Account_CrossReference":[  '+
        '                  {  '+
        '                     "Site":125373,'+
        '                     "InactiveDate":"",'+
        '                     "DimensionType":"SOURCE SYSTEM ADDITIONAL INFO",'+
        '                     "AddrRejectionReasonCd":"",'+
        '                     "BUUsage":"",'+
        '                     "ExternalId1":"125373&#124;380053",'+
        '                     "ProspectFlag":"",'+
        '                     "ServiceProviderRegion":"",'+
        '                     "AddressVerificationflag":"",'+
        '                     "AssociatedBillToSiteId":"125373&#124;380053",'+
        '                     "InactiveFlag":"A",'+
        '                     "AccountNumber":380053,'+
        '                     "Name":"BOLT&#124;125373&#124;380053",'+
        '                     "GlobalId":"125373&#124;380053",'+
        '                     "AutomergeGlobalId":"BOLT&#124;125373&#124;380053",'+
        '                     "Type":"BILL TO",'+
        '                     "LastMaintenanceDate":"",'+
        '                     "RecordType":"",'+
        '                     "ECNAtSource":"",'+
        '                     "EBSOU":"",'+
        '                     "ServiceProviderCode":"",'+
        '                     "SourceSystem":"BOLT",'+
        '                     "AddressVerificationCode":"",'+
        '                     "LegacyUCMCustNo":""'+
        '                  },'+
        '                  {  '+
        '                     "Site":87339,'+
        '                     "InactiveDate":"",'+
        '                     "DimensionType":"SOURCE SYSTEM ADDITIONAL INFO",'+
        '                     "AddrRejectionReasonCd":"",'+
        '                     "BUUsage":"",'+
        '                     "ExternalId1":"87339&#124;361658",'+
        '                     "ProspectFlag":"",'+
        '                     "ServiceProviderRegion":"",'+
        '                     "AddressVerificationflag":"",'+
        '                     "AssociatedBillToSiteId":"87339&#124;361658",'+
        '                     "InactiveFlag":"A",'+
        '                     "AccountNumber":361658,'+
        '                     "Name":"BOLT&#124;87339&#124;361658",'+
        '                     "GlobalId":"87339&#124;361658",'+
        '                     "AutomergeGlobalId":"BOLT&#124;87339&#124;361658",'+
        '                     "Type":"BILL TO",'+
        '                     "LastMaintenanceDate":"",'+
        '                     "RecordType":"",'+
        '                     "ECNAtSource":"",'+
        '                     "EBSOU":"US CMI Columbus A3B",'+
        '                     "ServiceProviderCode":"",'+
        '                     "SourceSystem":"BOLT",'+
        '                     "AddressVerificationCode":"",'+
        '                     "LegacyUCMCustNo":""'+
        '                  },'+
        '                  {  '+
        '                     "Site":"04509",'+
        '                     "InactiveDate":"05/26/2006 00:00:00",'+
        '                     "DimensionType":"SOURCE SYSTEM ADDITIONAL INFO",'+
        '                     "AddrRejectionReasonCd":"",'+
        '                     "BUUsage":"",'+
        '                     "ExternalId1":"BILL TO&#124;04509",'+
        '                     "ProspectFlag":"",'+
        '                     "ServiceProviderRegion":"",'+
        '                     "AddressVerificationflag":"",'+
        '                     "AssociatedBillToSiteId":"BILL TO&#124;04509",'+
        '                     "InactiveFlag":"A",'+
        '                     "AccountNumber":361658,'+
        '                     "Name":"IMS&#124;BILL TO&#124;04509",'+
        '                     "GlobalId":"",'+
        '                     "AutomergeGlobalId":"",'+
        '                     "Type":"BILL TO",'+
        '                     "LastMaintenanceDate":"26/05/2006",'+
        '                     "RecordType":"A",'+
        '                     "ECNAtSource":"",'+
        '                     "EBSOU":"",'+
        '                     "ServiceProviderCode":"",'+
        '                     "SourceSystem":"IMS",'+
        '                     "AddressVerificationCode":"",'+
        '                     "LegacyUCMCustNo":""'+
        '                  },'+
        '                  {  '+
        '                     "Site":"04509",'+
        '                     "InactiveDate":"05/26/2006 00:00:00",'+
        '                     "DimensionType":"SOURCE SYSTEM ADDITIONAL INFO",'+
        '                     "AddrRejectionReasonCd":"",'+
        '                     "BUUsage":"",'+
        '                     "ExternalId1":"SHIP TO&#124;04509",'+
        '                     "ProspectFlag":"",'+
        '                     "ServiceProviderRegion":"",'+
        '                     "AddressVerificationflag":"",'+
        '                     "AssociatedBillToSiteId":"BILL TO&#124;04509",'+
        '                     "InactiveFlag":"A",'+
        '                     "AccountNumber":361658,'+
        '                     "Name":"IMS&#124;SHIP TO&#124;04509",'+
        '                     "GlobalId":"",'+
        '                     "AutomergeGlobalId":"",'+
        '                     "Type":"SHIP TO",'+
        '                     "LastMaintenanceDate":"26/05/2006",'+
        '                     "RecordType":"A",'+
        '                     "ECNAtSource":"",'+
        '                     "EBSOU":"",'+
        '                     "ServiceProviderCode":"",'+
        '                     "SourceSystem":"IMS",'+
        '                     "AddressVerificationCode":"",'+
        '                     "LegacyUCMCustNo":""'+
        '                  },'+
        '                  {  '+
        '                     "Site":"1&#124;617&#124;2466",'+
        '                     "InactiveDate":"",'+
        '                     "DimensionType":"SOURCE SYSTEM ADDITIONAL INFO",'+
        '                     "AddrRejectionReasonCd":"",'+
        '                     "BUUsage":"",'+
        '                     "ExternalId1":"1&#124;617&#124;2466",'+
        '                     "ProspectFlag":"",'+
        '                     "ServiceProviderRegion":"",'+
        '                     "AddressVerificationflag":"",'+
        '                     "AssociatedBillToSiteId":"1&#124;2466",'+
        '                     "InactiveFlag":"A",'+
        '                     "AccountNumber":2466,'+
        '                     "Name":"SOMSUS&#124;1&#124;617&#124;2466",'+
        '                     "GlobalId":"",'+
        '                     "AutomergeGlobalId":"SOMSUS&#124;1&#124;617&#124;2466",'+
        '                     "Type":"SHIP TO",'+
        '                     "LastMaintenanceDate":"",'+
        '                     "RecordType":"",'+
        '                     "ECNAtSource":"",'+
        '                     "EBSOU":"",'+
        '                     "ServiceProviderCode":"",'+
        '                     "SourceSystem":"SOMSUS",'+
        '                     "AddressVerificationCode":"",'+
        '                     "LegacyUCMCustNo":1284188'+
        '                  },'+
        '                  {  '+
        '                     "Site":"1&#124;2&#124;2466A",'+
        '                     "InactiveDate":"",'+
        '                     "DimensionType":"SOURCE SYSTEM ADDITIONAL INFO",'+
        '                     "AddrRejectionReasonCd":"",'+
        '                     "BUUsage":"",'+
        '                     "ExternalId1":"1&#124;2&#124;2466A",'+
        '                     "ProspectFlag":"",'+
        '                     "ServiceProviderRegion":"",'+
        '                     "AddressVerificationflag":"",'+
        '                     "AssociatedBillToSiteId":"1&#124;2466A",'+
        '                     "InactiveFlag":"I",'+
        '                     "AccountNumber":"2466A",'+
        '                     "Name":"SOMSUS&#124;1&#124;2&#124;2466A",'+
        '                     "GlobalId":"",'+
        '                     "AutomergeGlobalId":"SOMSUS&#124;1&#124;2&#124;2466A",'+
        '                     "Type":"SHIP TO",'+
        '                     "LastMaintenanceDate":"",'+
        '                     "RecordType":"",'+
        '                     "ECNAtSource":"",'+
        '                     "EBSOU":"",'+
        '                     "ServiceProviderCode":"",'+
        '                     "SourceSystem":"SOMSUS",'+
        '                     "AddressVerificationCode":"",'+
        '                     "LegacyUCMCustNo":""'+
        '                  },'+
        '                  {  '+
        '                     "Site":"1-525554994142989",'+
        '                     "InactiveDate":"",'+
        '                     "DimensionType":"SOURCE SYSTEM ADDITIONAL INFO",'+
        '                     "AddrRejectionReasonCd":"",'+
        '                     "BUUsage":"",'+
        '                     "ExternalId1":"1-525554994142989",'+
        '                     "ProspectFlag":"",'+
        '                     "ServiceProviderRegion":"",'+
        '                     "AddressVerificationflag":"",'+
        '                     "AssociatedBillToSiteId":"1-525554994142989",'+
        '                     "InactiveFlag":"A",'+
        '                     "AccountNumber":"1-525554994142989",'+
        '                     "Name":"CARE&#124;1-525554994142989",'+
        '                     "GlobalId":"",'+
        '                     "AutomergeGlobalId":"CARE&#124;100071712",'+
        '                     "Type":"SHIP TO",'+
        '                     "LastMaintenanceDate":"",'+
        '                     "RecordType":"",'+
        '                     "ECNAtSource":100071712,'+
        '                     "EBSOU":"",'+
        '                     "ServiceProviderCode":"",'+
        '                     "SourceSystem":"CARE",'+
        '                     "AddressVerificationCode":"",'+
        '                     "LegacyUCMCustNo":""'+
        '                  },'+
        '                  {  '+
        '                     "Site":399367,'+
        '                     "InactiveDate":"",'+
        '                     "DimensionType":"SOURCE SYSTEM ADDITIONAL INFO",'+
        '                     "AddrRejectionReasonCd":"",'+
        '                     "BUUsage":"",'+
        '                     "ExternalId1":"399367&#124;361658",'+
        '                     "ProspectFlag":"",'+
        '                     "ServiceProviderRegion":"",'+
        '                     "AddressVerificationflag":"",'+
        '                     "AssociatedBillToSiteId":"399367&#124;361658",'+
        '                     "InactiveFlag":"A",'+
        '                     "AccountNumber":361658,'+
        '                     "Name":"PSBUCPG&#124;399367&#124;361658",'+
        '                     "GlobalId":"",'+
        '                     "AutomergeGlobalId":"PSBUCPG&#124;399367&#124;361658",'+
        '                     "Type":"BILL TO",'+
        '                     "LastMaintenanceDate":"",'+
        '                     "RecordType":"",'+
        '                     "ECNAtSource":100071712,'+
        '                     "EBSOU":"",'+
        '                     "ServiceProviderCode":"",'+
        '                     "SourceSystem":"PSBUCPG",'+
        '                     "AddressVerificationCode":"",'+
        '                     "LegacyUCMCustNo":""'+
        '                  },'+
        '                  {  '+
        '                     "Site":"BILL TO&#124;C000338724",'+
        '                     "InactiveDate":"",'+
        '                     "DimensionType":"SOURCE SYSTEM ADDITIONAL INFO",'+
        '                     "AddrRejectionReasonCd":"",'+
        '                     "BUUsage":"",'+
        '                     "ExternalId1":"BILL TO&#124;C000338724",'+
        '                     "ProspectFlag":"",'+
        '                     "ServiceProviderRegion":"",'+
        '                     "AddressVerificationflag":"Y",'+
        '                     "AssociatedBillToSiteId":"BILL TO&#124;C000338724",'+
        '                     "InactiveFlag":"A",'+
        '                     "AccountNumber":"C000338724",'+
        '                     "Name":"IAM&#124;BILL TO&#124;C000338724",'+
        '                     "GlobalId":"",'+
        '                     "AutomergeGlobalId":"IAM&#124;BILL TO&#124;C000338724",'+
        '                     "Type":"BILL TO",'+
        '                     "LastMaintenanceDate":"",'+
        '                     "RecordType":"",'+
        '                     "ECNAtSource":"",'+
        '                     "EBSOU":"",'+
        '                     "ServiceProviderCode":"",'+
        '                     "SourceSystem":"IAM",'+
        '                     "AddressVerificationCode":"V44-I44-P7-100",'+
        '                     "LegacyUCMCustNo":""'+
        '                  },'+
        '                  {  '+
        '                     "Site":"BILL TO&#124;30451",'+
        '                     "InactiveDate":"",'+
        '                     "DimensionType":"SOURCE SYSTEM ADDITIONAL INFO",'+
        '                     "AddrRejectionReasonCd":"",'+
        '                     "BUUsage":"",'+
        '                     "ExternalId1":"BILL TO&#124;30451",'+
        '                     "ProspectFlag":"",'+
        '                     "ServiceProviderRegion":"",'+
        '                     "AddressVerificationflag":"",'+
        '                     "AssociatedBillToSiteId":"BILL TO&#124;30451",'+
        '                     "InactiveFlag":"A",'+
        '                     "AccountNumber":30451,'+
        '                     "Name":"IAM&#124;BILL TO&#124;30451",'+
        '                     "GlobalId":"",'+
        '                     "AutomergeGlobalId":"IAM&#124;BILL TO&#124;30451",'+
        '                     "Type":"BILL TO",'+
        '                     "LastMaintenanceDate":"",'+
        '                     "RecordType":"",'+
        '                     "ECNAtSource":"",'+
        '                     "EBSOU":"",'+
        '                     "ServiceProviderCode":"",'+
        '                     "SourceSystem":"IAM",'+
        '                     "AddressVerificationCode":"",'+
        '                     "LegacyUCMCustNo":""'+
        '                  }'+
        '               ]'+
        '            },'+
        '            "AccountTypeCode":"Customer",'+
        '            "ReferenceFlag":"",'+
        '            "AccountValue":"",'+
        '            "YTDNetContribution":"",'+
        '            "Region":"",'+
        '            "FreightTermsInfo":"",'+
        '            "Id":"BILL TO&#124;C000338724",'+
        '            "ListOfRelatedSalesRep":{  '+
        '               "RelatedSalesRep":{  '+
        '                  "Position":"0-5220",'+
        '                  "Division":"Siebel Administration",'+
        '                  "Login":"SADMIN"'+
        '               }'+
        '            },'+
        '            "AIAUCMIntegrationId":"",'+
        '            "AnnualRevenue":"",'+
        '            "NumberofEmployees":"",'+
        '            "Referenciable":"",'+
        '            "OwnershipType":"External",'+
        '            "RowId":"1-F1QE0",'+
        '            "PrimaryContactId":"No Match Row Id",'+
        '            "DateFormed":"",'+
        '            "CleanseFlag":"Y",'+
        '            "DUNSNumber":"",'+
        '            "PartnerFlag":"N",'+
        '            "Employees":"",'+
        '            "TotalMeters":"",'+
        '            "ListOfRelatedOrganization":{  '+
        '               "RelatedOrganization":{  '+
        '                  "Organization":"0-R9NH"'+
        '               }'+
        '            },'+
        '            "InternalOrgFlag":"N",'+
        '            "InvestorFlag":"N",'+
        '            "MainPhoneNumber":3373677884,'+
        '            "OwnershipSubType":"",'+
        '            "RevenueGrowth":"",'+
        '            "ServiceProviderCode":"",'+
        '            "TotalPotentialVolume":"",'+
        '            "LegalPartyName":"",'+
        '            "LastUpdateSDQ":"01/10/2019 11:43:35",'+
        '            "DrugSpentCurrencyCode":"USD",'+
        '            "ServiceProviderFlag":"",'+
        '            "ParentAccountId":"",'+
        '            "PendingReviewStatus":"Suspect",'+
        '            "ErrorFlag":"N",'+
        '            "DomesticUltimateDUNS":"",'+
        '            "FinancingMethod":"",'+
        '            "GroupTypeCode":"ORGANIZATION",'+
        '            "LegalStatus":"",'+
        '            "LastYearSales":"",'+
        '            "AccountNumber":361658,'+
        '            "GlobalUltimateDUNS":"",'+
        '            "ECN":100071712,'+
        '            "Partners":"",'+
        '            "Type":"Customer",'+
        '            "HomePage":"",'+
        '            "DontCall":"N",'+
        '            "RestrictedPartyFlag":"",'+
        '            "EntityCode":"",'+
        '            "Alias":"",'+
        '            "ClientFlag":"Y",'+
        '            "CreditAgencyNumber":"",'+
        '            "PartyUId":"96A64FC2-8971-11e6-A106-800C06F8FE80",'+
        '            "CurrentVolume":"",'+
        '            "FreightTerms":"",'+
        '            "Expertise":"",'+
        '            "Location":"BOLT&#124;87339&#124;361658"'+
        '         },'+
        '         "ExternalSystemId":"IAM"'+
        '      },'+
        '      "Error_spcCode":"",'+
        '      "GlobalId":"IAM&#124;BILL TO&#124;C000338724"'+
        '   },'+
        '   "Header":{  '+
        '      "Status":"Success",'+
        '      "ReturnCodeDescription":""'+
        '   }'+
        '}';
    }

    public static Account createAccountWithFSLCustomerCode() {
        Account acc = new account();
        acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Guidanz').getRecordTypeId();
        acc.name = 'Test Account';
        acc.CMI_Account_Status__c = 'Active';
        acc.BillingCountryCode = 'CA';
        acc.CMI_Address2__c = '';
        acc.BillingStreet = '351 MCALLISTER DR'; 
        acc.BillingCity = 'SAINT JOHN';
        acc.BillingCountry='Canada';
        acc.BillingStateCode = 'NB';
        acc.BillingPostalCode = 'E2J 2S8';
        acc.BillingState='New Brunswick';        

        acc.CSS_DistributorCode__c='56330';
        acc.CSS_DealerCode__c='test';
        
        acc.Type = 'Dealer Account';
        acc.IAM_Service_Provider_Code__c = '123';
        acc.FSL_ERP_Customer_Code__c = '123456';
        insert acc;
        return acc;
    }
}