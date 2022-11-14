/*************************************************************
Name:  IAM_NewAccountRegistration_Test
Copyright © 2020  Cummins
=============================================================
=============================================================
Purpose:                                                            
This is test class for IAM_NewAccountRegistration_Test class.
This class is used for register the new account. and this class is creates the Account, Contact, Account provisoing and Contact provsioning records
for users. Based on application settings in App mapping object, we have given the access to users. And we are using this class in New Account and
Existing account registration. In new registration flow, we are creating all the records and sending to approval if approval needed on application.
In Existing account registration, we are not creating the Account, Just provding the access to contact and sending to approval. After registration is completed
then we are redirecting to confirmation page.                          
=============================================================
=============================================================
History                                                            
-------                                                            
VERSION  AUTHOR                   DATE              DETAIL                                
1.0 -    Keerthy Gurumurthy     23/04/2018        INITIAL DEVELOPMENT 
1.1 -    Sushma Rajput          08/13/2020        Changes for INC0365700,INC0303446
1.2 -    Karthik Golakaram      09/02/2020        Changes for Reclaim Changes.
1.3 -    Nishant Verma          02/10/2020        Changes for fluidwtach.
1.4 -    Shubhangi Sardar       05/02/2021        Added comment to push to production_Test
1.5 -    Shubhangi Sardar       09/06/2021        Added comment to push to production LDAP Sync Issue.
1.6 -    Anupam Adhikari        09/22/2021        Added comment to push to production RSW changes.
1.7 -    Anupam Adhikari        12/07/2021        Added comment to push to production Conn Sol SOQL 101 issue.
1.8 -    Sandeep Vuyyuru        17/01/2021        Added chnages for Marketplace/Guidanz as prod issue 101 SOQL issue. 
1.9 -    Chetan Gaikwad         11/04/2022        Added changes for RSW SP code validation
2.0 -    Suresh Rathod          04/05/2022        Added changes for Guidanz Service Portal Enhancement and breakfix
2.1 -    Ganesh K M             15/07/2022        Added changes for Policy Resource System New App Onboarding 
2.2 -    Chetan Gaikwad			07/28/2022	 	  Added to push for deployment
*****************************************************/
@isTest
public class IAM_NewAccountRegistration_Test {
    
    /* Return EDQ service response body*/
    private static String getEDQResBody(String verifiedFlag) {
        return '{ "AddressCleanse": { "ResponseNotifications": { "Status": "Success", "ReturnCodeDescription": "" }, "Location": [ { "Locator": { "LongitudeMeas": "", "LatitudeMeas": "" }, "GeographicalArea": { "GeographicalAreaName": "", "StreetAddress": { "FullAddress": "351 MCALLISTER DR&#124;SAINT JOHN NB  E2J 2S8", "AddressLine1txt": "351 MCALLISTER DR", "AddressLine4txt": "", "StreetAddressID": "", "AddressLine2txt": "", "AddressLine3txt": "", "StateProvinceTypeind": "P", "AddressType": "R" }, "AddressValidation": { "VerificationDescription": "Verified; 4 - Premise; Identified and parsed; Primary postal code verified; Score 100", "VerificationCode": "V44-I44-P6-100", "VerifiedFlag": "'+verifiedFlag+'", "GeoAccuracyCodeDescription": "Unable to geocode; 0 - None", "GeoAccuracyCode": "U0", "GeoDistance": "" }, "AddressError": { "ErrorDescription": "", "ErrorFlag": "N" }, "GeographicalAreaSubName": "", "Country": { "CountryID": "CA", "CountryName": "CA", "CountryNameDescription": "CANADA" }, "PostalCode": { "PostalCodeNum": "E2J 2S8" }, "City": { "TerritoryID": "NB", "CityID": "SAINT JOHN" }, "County": { "CountyID": "" }, "CountryGroup": { "CountryGroupID": "AMERICAS", "SubRegion": "NORTHERN AMERICA" } } }, { "Locator": { "LongitudeMeas": "", "LatitudeMeas": "" }, "GeographicalArea": { "GeographicalAreaName": "", "StreetAddress": { "FullAddress": "351 MCALLISTER DR&#124;&#124;&#124;&#124;&#124;&#124;SAINT JOHN&#124;&#124;NB&#124;E2J 2S8", "AddressLine1txt": "351 MCALLISTER DR", "AddressLine4txt": "", "StreetAddressID": "", "AddressLine2txt": "", "AddressLine3txt": "", "StateProvinceTypeind": "", "AddressType": "S" }, "AddressValidation": { "VerificationDescription": "", "VerificationCode": "", "VerifiedFlag": "", "GeoAccuracyCodeDescription": "", "GeoAccuracyCode": "", "GeoDistance": "" }, "AddressError": { "ErrorDescription": "", "ErrorFlag": "N" }, "GeographicalAreaSubName": "", "Country": { "CountryID": "CA", "CountryName": "CA", "CountryNameDescription": "CANADA" }, "PostalCode": { "PostalCodeNum": "E2J 2S8" }, "City": { "TerritoryID": "NB", "CityID": "SAINT JOHN" }, "County": { "CountyID": "" }, "CountryGroup": { "CountryGroupID": "", "SubRegion": "" } } } ] } }';
    }
    
    /* Return GL service response body */
    private static String getGLResBody(String hqcode, String spcode) {
        return '{"getSPSearchResultsReturn":{"cumminsLocationDTO":{"branchDTO":{"zipCode":"E3C 2E7","durationText":"1 hour 11 mins","spName":"Eastern Canada - Fredericton","countyDistrict":{"nil":true},"hqCode":"'+hqcode+'","tollFreePhone":{"nil":true},"tollFreeFax":{"nil":true},"latitude":45.9072283,"city Name":"Fredericton","stateName":"New Brunswick","distanceText":"69.8 mi","marketProgram":{"nil":true},"spcode":"'+spcode+'","fax":"506 451-1927","spLocType":101,"email":{"nil":true},"longitude":-66.62141839999998,"address3":{"nil":true},"address2":{"nil":true},"address1":"321  Doak Road","webAddress":{"nil":true},"custServicePhone":{"nil":true},"amenityComments":{"nil":true},"distanceValue":0,"countryName":"Canada","busi nessPhone":"506 451-1929","emergencyPhone":{"nil":true}},"hqDTO":{"nil":true}},"errorCode":{"nil":true},"spDTO":{"nil":true},"paginationDTO":{"nil":true},"la ngId":1,"omrResultFlag":{"nil":true}}}';
    }
    
    private static Account createSampleParentAcc(){
	Account accSampleRecord3 = new Account(name='AccountTest4',
                                   CMI_Account_Status__c='Inactive',
                                   CMI_CDA_Status__c='New Customer Request',
                                   Type='Distributor Account',
                                   CMI_CId__c = 'Test',
                                   CSS_DistributorCode__c = '10010',
                                   IAM_Service_Provider_Code__c = '01339',
                                   CSS_DealerCode__c = 'Test',
                                   CSS_DBCode__c = 'Test'  
                                   );
    
    insert accSampleRecord3; 
       return [SELECT Id, Name, IAM_Service_Provider_Code__c FROM Account WHERE Id = :accSampleRecord3.Id]; 
    }
    /* Create and return parent account*/
    private static Account createParentAccount() {
        Account acc = new Account();
        acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('IAM').getRecordTypeId();
        acc.name = 'Test Account Test Class';
        acc.IAM_Service_Provider_Code__c = '1234';
        acc.BillingCountryCode = 'CA';
        acc.CMI_Address2__c = '';
        acc.BillingStreet = '351 MCALLISTER DR'; 
        acc.BillingCity = 'Fredericton';
        acc.BillingCountry='Canada';
        acc.BillingStateCode = 'NB';
        acc.BillingPostalCode = 'E3C 2E7';
        acc.BillingState='New Brunswick';
        acc.CSS_DistributorCode__c='1234';
        acc.Type = 'Distributor Account';
        insert acc;
        
        return [SELECT Id, Name, IAM_Service_Provider_Code__c FROM Account WHERE Id = :acc.Id];
    }
    
    /* Create and return default parent account */
    private static Account createDefaultParentAccount() {
        Account acc = new Account();
        acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('IAM').getRecordTypeId();
        acc.name = 'Cummins - Canada';
        acc.IAM_Service_Provider_Code__c = '1234';
        acc.BillingCountryCode = 'CA';
        acc.CMI_Address2__c = '';
        acc.BillingStreet = '351 MCALLISTER DR'; 
        acc.BillingCity = 'Fredericton';
        acc.BillingCountry='Canada';
        acc.BillingStateCode = 'NB';
        acc.BillingPostalCode = 'E3C 2E7';
        acc.BillingState='New Brunswick';
        acc.CSS_DistributorCode__c='1234';
        acc.Type = 'Internal';
        insert acc;
        return acc;
    }
    
    /* Return test account data */
    private static Account getAccount() {
        Account acc = new account();
        acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('IAM').getRecordTypeId();
        acc.name = 'Test Account';
        //acc.parentid = parentAcc.Id;
        acc.BillingCountryCode = 'CA';
        acc.CMI_Address2__c = '';
        acc.BillingStreet = '351 MCALLISTER DR'; 
        acc.BillingCity = 'SAINT JOHN';
        acc.BillingCountry='Canada';
        acc.BillingStateCode = 'NB';
        acc.BillingPostalCode = 'E2J 2S8';
        acc.BillingState='New Brunswick';        

        acc.CSS_DistributorCode__c='1234';
        acc.CSS_DealerCode__c='test';
        
        acc.Type = 'Dealer Account';
        acc.IAM_Service_Provider_Code__c = '23475';
        
        acc.CSS_Locale__c = 'English(United States)';
        acc.CSS_Language__c = 'English';
        acc.CSS_Timezone__c = '(GMT-05:00) Eastern Standard Time (America/Panama)';
        return acc;
    }
    
    /* Return test account data */
    private static Account getAccount01() {
       //Account acct = [Select Id from Account where Name = 'Test Account Test Class' Limit 1];
       //Account acct = createParentAccount();
        Account acc = new account();
        acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('IAM').getRecordTypeId();
        acc.name = 'Test Account RSW';
        //acc.parentid = acct.Id;
        acc.BillingCountryCode = 'CA';
        acc.CMI_Address2__c = '';
        acc.BillingStreet = '351 MCALLISTER DR'; 
        acc.BillingCity = 'SAINT JOHN';
        acc.BillingCountry='Canada';
        acc.BillingStateCode = 'NB';
        acc.BillingPostalCode = 'E2J 2S8';
        acc.BillingState='New Brunswick';        

        acc.CSS_DistributorCode__c='1234';
        acc.CSS_DealerCode__c='test';
        
        acc.Type = 'CIHR';
        acc.IAM_Service_Provider_Code__c = '23451';
        
        acc.CSS_Locale__c = 'English(United States)';
        acc.CSS_Language__c = 'English';
        acc.CSS_Timezone__c = '(GMT-05:00) Eastern Standard Time (America/Panama)';
        return acc;
    }
    
    /* Return test contact data */
    private static Contact getContact() {
        Contact con = new contact();
        con.RecordTypeId = Schema.SObjectType.contact.getRecordTypeInfosByName().get('IAM').getRecordTypeId();
        con.FirstName = 'Fname';
        con.LastName = 'Lname';
        con.Email = 'fnamelname@test.com';
        con.phone = '1112223335';
        return con;
    } 
    
    /* Create IAM_Contact_Provisioning__c object record  */
    private static void createUserSubscription(Id conId, String appName, String appRole, Id accAccFeatureId) {
        IAM_Contact_Provisioning__c obj = new IAM_Contact_Provisioning__c();
        obj.IAM_Contact__c= conId; 
        obj.IAM_Start_Date__c = Date.today();
        obj.IAM_End_Date__c = Date.today() + 365;
        obj.IAM_Application_Name__c = appName;
        obj.IAM_Role__c = appRole;
        if(appName == Label.IAM_Guidanz_Mobile_App_Name){
            obj.IAM_Guidanz_Mobile_Roles__c = appRole;
            obj.IAM_swregExpire__c = 'IAM-2020';
        }
        if(appName == Label.IAM_AppName_QSOL){
            System.debug('Printing Role Name for Guidanz mobile application');
            obj.IAM_Qsolexpiration__c = 'IAM-2020';
        }
        obj.IAM_License_Type__c = '';
        obj.IAM_Status__c = 'Active';
        obj.IAM_Account_Application__c = accAccFeatureId;
        obj.IAM_Subscription_Name__c = appName;        
        obj.RecordtypeId = Schema.SObjectType.IAM_Contact_Provisioning__c.getRecordTypeInfosByName().get(appName).getRecordTypeId();                 
        insert obj;      
    } 
    
    static testmethod void testCreateosmSubscrptionForFluiwatch(){
        Account acc = new Account();
        acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('IAM').getRecordTypeId();
        acc.name = 'OSM subtest class';
        acc.IAM_Service_Provider_Code__c = '99201';
        acc.BillingCountryCode = 'CA';
        acc.CMI_Address2__c = '';
        acc.BillingStreet = '391 MCALLISTER DR'; 
        acc.BillingCity = 'Fredericton';
        acc.BillingCountry='Canada';
        acc.BillingStateCode = 'NB';
        acc.BillingPostalCode = 'E2C 1E7';
        acc.BillingState='New Brunswick';
        acc.CSS_DistributorCode__c='99201';
        acc.Type = 'Distributor Account';
        insert acc;
        
        IAM_Application__c app = new IAM_Application__c();
        app.IAM_Application_Name__c = System.Label.IAM_OSM_App_Name;
        app.IAM_Account_Name__c = acc.id;
        app.IAM_Status__c = 'Active';
        app.IAM_Role__c = System.Label.IAM_OSM_ContPro_Default_Roles;
        insert app;
        
        Contact con = new contact();
        con.RecordTypeId = Schema.SObjectType.contact.getRecordTypeInfosByName().get('IAM').getRecordTypeId();
        con.FirstName = 'Fnamet';
        con.LastName = 'Lnamet';
        con.Email = 'fnamelnamet@test.com';
        con.Username__c = 'fnamelnamet@test.com';
        con.phone = '1012023035';
        con.IAM_Contact_Status__c = 'Active';
        con.CMI_Contact_Type__c = 'Secondary';
        insert con;
        
        test.startTest();
        //IAM_NewAccountRegistration.CreateosmSubscrptionForFluiwatch(acc.Id, con.Id);
        IAM_NewAccountRegistration.createFWSubscriptionfromOSM(acc.Id, con.Id);
        test.stopTest();
             
    }
    
    /* Test EDQ_AccessToken Class */
    static testmethod void edqAccessTokenTest() {
        String jsonStr = '{ "access_token": "lm6KXDoEgwYudGtKDBoSIxq6kxAG6L5LfUhtdWSpNyehpRiaqby5Cz", "token_type": "dummy", "expires_in": 15, "refresh_token": "lm6KXDoEgwYudGtKDBoSIxq6kxAG6L5LfUhtdWSpNyehpRiaqby5Cz", "scope": "no" }';
        Test.startTest();
        IAM_EDQ_accessToken.parse(jsonStr);
        Test.stopTest();
    }
    
    /* Test edq callout (IAM_EDQ_AddressCleanse) with positive(Verified Flag = Y and AddressType = S) response*/
    static testmethod void edqCallTestPositive() {
        PageReference pg = Page.IAM_NewRegistration;        
        Test.setCurrentPage(pg);
        App_Mapping__c app = IAM_TestData.getCumpasApp();
        IAM_TestData.create_IAM_EDQ_oAuth_CS();
        ApexPages.currentPage().getParameters().put('appid',app.Id);
        ApexPages.StandardController sc = new ApexPages.StandardController(new Account());
        IAM_NewAccountRegistration obj = new IAM_NewAccountRegistration(sc);
        obj.acc = getAccount();
        obj.newCon = getContact();      
                
        String responseBodyEdqInfo = getEDQResBody('Y');
        Test.setMock(HttpCalloutMock.class, new IAM_SingleRequestMock(200, 'Success', responseBodyEdqInfo, null));
        IAM_EDQ_LocationResParser resp = IAM_EDQ_AddressCleanse.EDQAddress(getAccount());        
        
        System.debug('### Test Class 1 - ');
        Test.startTest();
            obj.EDQAddress();
            //System.assertEquals(true, obj.EDQpop);
            
        Test.stopTest();
    }
    
    /* Test edq callout (IAM_EDQ_AddressCleanse) with positive(Verified Flag = Y and AddressType = R) response*/
    static testmethod void edqCallAddressTypeTest() {
        PageReference pg = Page.IAM_NewRegistration;        
        Test.setCurrentPage(pg);
        App_Mapping__c app = IAM_TestData.getCumpasApp();
        IAM_TestData.create_IAM_EDQ_oAuth_CS();
        ApexPages.currentPage().getParameters().put('appid',app.Id);
        ApexPages.StandardController sc = new ApexPages.StandardController(new Account());
        IAM_NewAccountRegistration obj = new IAM_NewAccountRegistration(sc);
        obj.acc = getAccount();
        obj.newCon = getContact();        
                
        String responseBodyEdqInfo = getEDQResBody('Y');
        Test.setMock(HttpCalloutMock.class, new IAM_SingleRequestMock(200, 'Success', responseBodyEdqInfo, null));
        IAM_EDQ_LocationResParser resp = IAM_EDQ_AddressCleanse.EDQAddress(getAccount());        
        
        System.debug('### Test Class 1 - ');
        Test.startTest();
            obj.EDQAddress();
            //System.assertEquals(true, obj.EDQpop);
            
        Test.stopTest();
    }
    
    /* Test edq callout (IAM_EDQ_AddressCleanse) with positive(Verified Flag = N) response*/
    static testmethod void edqCallTestVerifiedFlag() {
        PageReference pg = Page.IAM_NewRegistration;        
        Test.setCurrentPage(pg);
        App_Mapping__c app = IAM_TestData.getCumpasApp();
        IAM_TestData.create_IAM_EDQ_oAuth_CS();
        ApexPages.currentPage().getParameters().put('appid',app.Id);
        ApexPages.StandardController sc = new ApexPages.StandardController(new Account());
        IAM_NewAccountRegistration obj = new IAM_NewAccountRegistration(sc);
        obj.acc = getAccount();
        obj.newCon = getContact();
        obj.getItems();
        obj.getAddress();
                
        String responseBodyEdqInfo = getEDQResBody('N');
        Test.setMock(HttpCalloutMock.class, new IAM_SingleRequestMock(200, 'Success', responseBodyEdqInfo, null));
        IAM_EDQ_LocationResParser resp = IAM_EDQ_AddressCleanse.EDQAddress(getAccount());        
        
        System.debug('### Test Class 1 - ');
        Test.startTest();
            obj.EDQAddress();
            //System.assertEquals(true, obj.EDQpop);
            
        Test.stopTest();
    }
    
    /* Test edq callout (IAM_EDQ_AddressCleanse) with negative(error) response*/
    static testmethod void edqCallTestNegative() {
        PageReference pg = Page.IAM_NewRegistration;        
        Test.setCurrentPage(pg);
        App_Mapping__c app = IAM_TestData.getCumpasApp();
        IAM_TestData.create_IAM_EDQ_oAuth_CS();
        ApexPages.currentPage().getParameters().put('appid',app.Id);
        ApexPages.StandardController sc = new ApexPages.StandardController(new Account());
        IAM_NewAccountRegistration obj = new IAM_NewAccountRegistration(sc);
        obj.acc = getAccount();
        obj.newCon = getContact();        
                
        String responseBodyEdqInfo = '{{"ResponseNotifications":{"Status":"Success","ReturnCodeDescription":""},"Location":[{"Locator":{"LongitudeMeas":"","LatitudeMeas":""},"GeographicalArea":{"GeographicalAreaName":"","StreetAddress":{"FullAddress":"351 MCALLISTER DR&#124;SAINT JOHN NB  E2J 2S8","AddressLine1txt":"351 MCALLISTER DR","AddressLine4txt":"","StreetAddressID":"","AddressLine2txt":"","AddressLine3txt":"","StateProvinceTypeind":"P","AddressType":"R"},"AddressValidation":{"VerificationDescription":"Verified; 4 - Premise; Identified and parsed; Primary postal code verified; Score 100","VerificationCode":"V44-I44-P6-100","VerifiedFlag":"Y","GeoAccuracyCodeDescription":"Unable to geocode; 0 - None","GeoAccuracyCode":"U0","GeoDistance":""},"AddressError":{"ErrorDescription":"","ErrorFlag":"N"},"GeographicalAreaSubName":"","Country":{"CountryID":"CA","CountryName":"CA","CountryNameDescription":"CANADA"},"PostalCode":{"PostalCodeNum":"E2J 2S8"},"City":{"TerritoryID":"NB","CityID":"SAINT JOHN"},"County":{"CountyID":""},"CountryGroup":{"CountryGroupID":"AMERICAS","SubRegion":"NORTHERN AMERICA"}}},{"Locator":{"LongitudeMeas":"","LatitudeMeas":""},"GeographicalArea":{"GeographicalAreaName":"","StreetAddress":{"FullAddress":"351 MCALLISTER DR&#124;&#124;&#124;&#124;&#124;&#124;SAINT JOHN&#124;&#124;NB&#124;E2J 2S8","AddressLine1txt":"351 MCALLISTER DR","AddressLine4txt":"","StreetAddressID":"","AddressLine2txt":"","AddressLine3txt":"","StateProvinceTypeind":"","AddressType":"S"},"AddressValidation":{"VerificationDescription":"","VerificationCode":"","VerifiedFlag":"","GeoAccuracyCodeDescription":"","GeoAccuracyCode":"","GeoDistance":""},"AddressError":{"ErrorDescription":"","ErrorFlag":"N"},"GeographicalAreaSubName":"","Country":{"CountryID":"CA","CountryName":"CA","CountryNameDescription":"CANADA"},"PostalCode":{"PostalCodeNum":"E2J 2S8"},"City":{"TerritoryID":"NB","CityID":"SAINT JOHN"},"County":{"CountyID":""},"CountryGroup":{"CountryGroupID":"","SubRegion":""}}}]}}';
        Test.setMock(HttpCalloutMock.class, new IAM_SingleRequestMock(200, 'Success', responseBodyEdqInfo, null));
        IAM_EDQ_LocationResParser resp = IAM_EDQ_AddressCleanse.EDQAddress(getAccount());        
        
        System.debug('### Test Class 1 - ');
        Test.startTest();
            obj.EDQAddress();
        
        
        //System.assertEquals(false, obj.EDQpop);
        Test.stopTest();
    }
    
    /* Test GL webservice callout - IAM_GL_webservice to get parent distributer Id */
    static testmethod void glWebServiceCallTest() {
        Account parentAcc = createParentAccount();
        IAM_TestData.create_IAM_GL_Service_CS();
        Test.startTest();
        String responseBodyGLService = getGLResBody(parentAcc.IAM_Service_Provider_Code__c, parentAcc.IAM_Service_Provider_Code__c);
        Test.setMock(HttpCalloutMock.class, new IAM_SingleRequestMock(200, 'Success', responseBodyGLService, null));
        Account acc = getAccount();
        IAM_GL_webservice.makeCallout(acc.billingStreet, acc.BillingCity, acc.BillingCountry, acc.BillingPostalCode);        
        //System.assertEquals(parentAcc.Id, IAM_GL_webservice.parentDistributorId);
        Test.stopTest();
    }
    
    /* Test GL webservice error callout - IAM_GL_webservice to get null parent distributer Id */
    static testmethod void glWebServiceCallExceptionTest() {
        Account parentAcc = createParentAccount();
        IAM_TestData.create_IAM_GL_Service_CS();
        Test.startTest();
        String responseBodyGLService = 'Error';
        Test.setMock(HttpCalloutMock.class, new IAM_SingleRequestMock(400, 'Error', responseBodyGLService, null));
        
        Account acc = getAccount();
        IAM_GL_webservice.makeCallout(acc.billingStreet, acc.BillingCity, acc.BillingCountry, acc.BillingPostalCode);        
        //System.assertEquals(null, IAM_GL_webservice.parentDistributorId);
        Test.stopTest();
    }
    
    /* Test IAM_OAG_getoAuthToken to get the access token */
    static testmethod void iamOAGGetAccessTokenCall() {
        IAM_TestData.create_IAM_EDQ_oAuth_CS();
        String responseBodyAccessToken = '{"access_token":"lm6KXDoEgwYudGtKDBoSIxq6kxAG6L5LfUhtdWSpNyehpRiaqby5Cz","token_type":"Bearer","expires_in":24000,"refresh_token":"Lgu8pdoi9UlcessC285G28GiNh10MUI3Tf8o3WvX9WPFw4","scope":"CDH"}';
        Test.startTest();
            Test.setMock(HttpCalloutMock.class, new IAM_SingleRequestMock(200, 'Success', responseBodyAccessToken, null));
            String accessToken = IAM_OAG_getoAuthToken.getAccessToken('IAM_EDQ_oAuth');
            
            //System.assertEquals('lm6KXDoEgwYudGtKDBoSIxq6kxAG6L5LfUhtdWSpNyehpRiaqby5Cz', accessToken);
        Test.stopTest();
    }
    
    /* Test capcha with no input  */
    static testmethod void blankCaptchaValueTest() {
        PageReference pg = Page.IAM_NewRegistration;        
        Test.setCurrentPage(pg);
        App_Mapping__c app = IAM_TestData.getCumpasApp();
        IAM_TestData.create_IAM_EDQ_oAuth_CS();
        ApexPages.currentPage().getParameters().put('appid',app.Id);
        ApexPages.StandardController sc = new ApexPages.StandardController(new Account());
        IAM_NewAccountRegistration obj = new IAM_NewAccountRegistration(sc);
        obj.acc = getAccount();
        obj.newCon = getContact();        
                
        String responseBodyEdqInfo = getEDQResBody('Y');
        Test.setMock(HttpCalloutMock.class, new IAM_SingleRequestMock(200, 'Success', responseBodyEdqInfo, null));
        IAM_EDQ_LocationResParser resp = IAM_EDQ_AddressCleanse.EDQAddress(getAccount());
        Account parentAcc = createParentAccount();
        System.debug('### Test Class 1 - ');
        Test.startTest();
            obj.EDQAddress();
           // System.assertEquals(true, obj.EDQpop);
            obj.input = '';
            //System.assertEquals(false, obj.isCaptchaValid());
            //System.assertEquals(Label.IAM_Missing_Captcha, obj.result);
        Test.stopTest();
    }
    
    /* Test capcha with invalid input  */
    static testmethod void invalidCaptchaValueTest() {
        PageReference pg = Page.IAM_NewRegistration;        
        Test.setCurrentPage(pg);
        App_Mapping__c app = IAM_TestData.getCumpasApp();
        IAM_TestData.create_IAM_EDQ_oAuth_CS();
        ApexPages.currentPage().getParameters().put('appid',app.Id);
        ApexPages.StandardController sc = new ApexPages.StandardController(new Account());
        IAM_NewAccountRegistration obj = new IAM_NewAccountRegistration(sc);
        obj.acc = getAccount();
        obj.newCon = getContact();        
                
        String responseBodyEdqInfo = getEDQResBody('Y');
        Test.setMock(HttpCalloutMock.class, new IAM_SingleRequestMock(200, 'Success', responseBodyEdqInfo, null));
        IAM_EDQ_LocationResParser resp = IAM_EDQ_AddressCleanse.EDQAddress(getAccount());
        Account parentAcc = createParentAccount();
        System.debug('### Test Class 1 - ');
        Test.startTest();
            obj.EDQAddress();
            //System.assertEquals(true, obj.EDQpop);
            obj.input = '677';
            //System.assertEquals(false, obj.isCaptchaValid());
            //System.assertEquals(Label.IAM_Invalid_Captcha, obj.result);
        Test.stopTest();
    }
    
    /* Test EDQ popup showAddress pencil icon */
    static testmethod void showAddressTest() {
        PageReference pg = Page.IAM_NewRegistration;        
        Test.setCurrentPage(pg);
        App_Mapping__c app = IAM_TestData.getCumpasApp();
        IAM_TestData.create_IAM_EDQ_oAuth_CS();
        ApexPages.currentPage().getParameters().put('appid',app.Id);
        ApexPages.StandardController sc = new ApexPages.StandardController(new Account());
        IAM_NewAccountRegistration obj = new IAM_NewAccountRegistration(sc);
        obj.acc = getAccount();
        obj.newCon = getContact();        
                
        String responseBodyEdqInfo = getEDQResBody('Y');
        Test.setMock(HttpCalloutMock.class, new IAM_SingleRequestMock(200, 'Success', responseBodyEdqInfo, null));
        IAM_EDQ_LocationResParser resp = IAM_EDQ_AddressCleanse.EDQAddress(getAccount());
        Account parentAcc = createParentAccount();
        System.debug('### Test Class 1 - ');
        Test.startTest();
            obj.EDQAddress();
            //System.assertEquals(true, obj.EDQpop);
            obj.showAddress();
            //System.assertEquals(false, obj.EDQpop);
        Test.stopTest();
    }
    
    /* Cumpas Registration - New Account - Set Parent Account to Default Cummins Account */
    static testmethod void defaultParentAccountTest() {
        PageReference pg = Page.IAM_NewRegistration;        
        Test.setCurrentPage(pg);
        App_Mapping__c app = IAM_TestData.getCumpasApp();
        IAM_TestData.create_IAM_EDQ_oAuth_CS();
        IAM_TestData.create_IAM_GL_Service_CS();
        ApexPages.currentPage().getParameters().put('appid',app.Id);
        ApexPages.StandardController sc = new ApexPages.StandardController(new Account());
        IAM_NewAccountRegistration obj = new IAM_NewAccountRegistration(sc);
        obj.acc = getAccount();
        obj.newCon = getContact();        
                
        String responseBodyEdqInfo = getEDQResBody('Y');
        Test.setMock(HttpCalloutMock.class, new IAM_SingleRequestMock(200, 'Success', responseBodyEdqInfo, null));
        IAM_EDQ_LocationResParser resp = IAM_EDQ_AddressCleanse.EDQAddress(getAccount());
        Account parentAcc = createDefaultParentAccount();
        System.debug('### Test Class 1 - ');
        Test.startTest();
            obj.EDQAddress();
            //System.assertEquals(true, obj.EDQpop);
            obj.input = '' + obj.getChar1() + obj.getChar2() + obj.getChar3() + obj.getChar4() + obj.getChar5() + obj.getChar6();     
            //System.assertEquals(true, obj.isCaptchaValid());
            
            String responseBodyGLService = '';
            Test.setMock(HttpCalloutMock.class, new IAM_SingleRequestMock(400, 'Error', responseBodyGLService, null));
            
            Account acc = obj.acc;
            IAM_GL_webservice.makeCallout(acc.billingStreet, acc.BillingCity, acc.BillingCountry, acc.BillingPostalCode);        
            //System.assertEquals(null, IAM_GL_webservice.parentDistributorId);
            //System.assertEquals(false, obj.isUserExist(obj.newCon.Email));
            PageReference pgRef = obj.send();           
            //System.assertEquals(true, pgRef != null);
        Test.stopTest();
    }
    
    /* Cumpas Registration - New Account */
    static testmethod void cumpasNewAccRegistrationTest() {
        String uniqueUserName = 'standarduser' + DateTime.now().getTime() + '@testorg.com';
        // This code runs as the system user
        
        PageReference pg = Page.IAM_NewRegistration;        
        Test.setCurrentPage(pg);
        App_Mapping__c app = IAM_TestData.getCumpasApp();
        IAM_TestData.create_IAM_EDQ_oAuth_CS();
        IAM_TestData.create_IAM_GL_Service_CS();
        ApexPages.currentPage().getParameters().put('appid',app.Id);
        ApexPages.StandardController sc = new ApexPages.StandardController(new Account());
        IAM_NewAccountRegistration obj = new IAM_NewAccountRegistration(sc);
        obj.acc = getAccount();
        obj.newCon = getContact();        
                
        String responseBodyEdqInfo = getEDQResBody('Y');
        Test.setMock(HttpCalloutMock.class, new IAM_SingleRequestMock(200, 'Success', responseBodyEdqInfo, null));
        IAM_EDQ_LocationResParser resp = IAM_EDQ_AddressCleanse.EDQAddress(getAccount());
        Account parentAcc = createParentAccount();
        System.debug('### Test Class 1 - ');
        Test.startTest();
            obj.EDQAddress();
            //System.assertEquals(true, obj.EDQpop);
            obj.isEdqAddress = false;
            obj.input = '' + obj.getChar1() + obj.getChar2() + obj.getChar3() + obj.getChar4() + obj.getChar5() + obj.getChar6();     
            //System.assertEquals(true, obj.isCaptchaValid());
            //System.debug('### SP Code - '+parentAcc.IAM_Service_Provider_Code__c);
            String responseBodyGLService = getGLResBody(parentAcc.IAM_Service_Provider_Code__c, parentAcc.IAM_Service_Provider_Code__c);
            Test.setMock(HttpCalloutMock.class, new IAM_SingleRequestMock(200, 'Success', responseBodyGLService, null));
            
            Account acc = obj.acc;
            IAM_GL_webservice.makeCallout(acc.billingStreet, acc.BillingCity, acc.BillingCountry, acc.BillingPostalCode);        
            //System.assertEquals(parentAcc.Id, IAM_GL_webservice.parentDistributorId);
            //System.assertEquals(false, obj.isUserExist(obj.newCon.Email));
            PageReference pgRef = obj.send();           
            //System.assertEquals(true, pgRef != null);       
        
    }
    
    /* Cumpas Registration - Existing Account */
    static testmethod void cumpasExistAccRegistrationTest() {
        PageReference pg = Page.IAM_NewRegistration;        
        Test.setCurrentPage(pg);
        App_Mapping__c app = IAM_TestData.getCumpasApp();
        IAM_TestData.create_IAM_EDQ_oAuth_CS();
        IAM_TestData.create_IAM_GL_Service_CS();
        ApexPages.currentPage().getParameters().put('appid',app.Id);
        ApexPages.StandardController sc = new ApexPages.StandardController(new Account());
        IAM_NewAccountRegistration obj = new IAM_NewAccountRegistration(sc);
        Account existingAcc = getAccount();
        
        insert existingAcc;
        User u = [SELECT Id FROM User WHERE Profile.Name = 'System Administrator'
                  AND UserRoleId != null AND IsActive = true LIMIT 1];
        System.runAs(u) {
        obj.acc = getAccount();
        obj.newCon = getContact();        
                
        String responseBodyEdqInfo = getEDQResBody('Y');
        Test.setMock(HttpCalloutMock.class, new IAM_SingleRequestMock(200, 'Success', responseBodyEdqInfo, null));
        IAM_EDQ_LocationResParser resp = IAM_EDQ_AddressCleanse.EDQAddress(getAccount());
        Account parentAcc = createParentAccount();
        System.debug('### Test Class 1 - ');
        Test.startTest();
            obj.EDQAddress();
            //System.assertEquals(true, obj.EDQpop);
            obj.input = '' + obj.getChar1() + obj.getChar2() + obj.getChar3() + obj.getChar4() + obj.getChar5() + obj.getChar6();     
            //System.assertEquals(true, obj.isCaptchaValid());
            
            String responseBodyGLService = getGLResBody(parentAcc.IAM_Service_Provider_Code__c, parentAcc.IAM_Service_Provider_Code__c);
            Test.setMock(HttpCalloutMock.class, new IAM_SingleRequestMock(200, 'Success', responseBodyGLService, null));
            
            Account acc = obj.acc;
            IAM_GL_webservice.makeCallout(acc.billingStreet, acc.BillingCity, acc.BillingCountry, acc.BillingPostalCode);        
            //System.assertEquals(parentAcc.Id, IAM_GL_webservice.parentDistributorId);
            //System.assertEquals(false, obj.isUserExist(obj.newCon.Email));
            PageReference pgRef = obj.send();           
            //System.assertEquals(true, pgRef != null);
            //System.assertEquals(existingAcc.Id, obj.newCon.AccountId);
        Test.stopTest();
        }
    }
    
    /* Cumpas Registration - Existing Account (primary contact exist) */
    static testmethod void cumpasExiAccRegWithParentPrimaryCon() {
        PageReference pg = Page.IAM_NewRegistration;        
        Test.setCurrentPage(pg);
        App_Mapping__c app = IAM_TestData.getCumpasApp();
        IAM_TestData.create_IAM_EDQ_oAuth_CS();
        IAM_TestData.create_IAM_GL_Service_CS();
        ApexPages.currentPage().getParameters().put('appid',app.Id);
        ApexPages.StandardController sc = new ApexPages.StandardController(new Account());
        IAM_NewAccountRegistration obj = new IAM_NewAccountRegistration(sc);
        Account existingAcc = getAccount();
        insert existingAcc;       
        
        Contact existingCon = getContact();
        existingCon.AccountId = existingAcc.Id;
        existingCon.Email = 'tef56st1@abc.com'; 
        existingCon.Username__c = 'tef56st1@abc.com.iamdev';
        existingCon.CMI_Contact_Type__c = 'Primary';
        existingCon.IAM_Contact_Status__c = 'Active';
        existingCon.RecordTypeid=Schema.SObjectType.contact.getRecordTypeInfosByName().get('IAM').getRecordTypeId();        
        insert existingCon;       
        
        List<Contact> conList = new List<Contact>();
        conList.add(existingCon);
        IAM_CreateUser.CreateUser(conList);      
       
        obj.acc = getAccount();
        obj.newCon = getContact();        
                
        String responseBodyEdqInfo = getEDQResBody('Y');
        Test.setMock(HttpCalloutMock.class, new IAM_SingleRequestMock(200, 'Success', responseBodyEdqInfo, null));
        IAM_EDQ_LocationResParser resp = IAM_EDQ_AddressCleanse.EDQAddress(getAccount());
        Account parentAcc = createParentAccount();
        System.debug('### Test Class 1 - ');
        Test.startTest();
            obj.EDQAddress();
            //System.assertEquals(true, obj.EDQpop);
            obj.input = '' + obj.getChar1() + obj.getChar2() + obj.getChar3() + obj.getChar4() + obj.getChar5() + obj.getChar6();     
            //System.assertEquals(true, obj.isCaptchaValid());
            
            String responseBodyGLService = getGLResBody(parentAcc.IAM_Service_Provider_Code__c, parentAcc.IAM_Service_Provider_Code__c);
            Test.setMock(HttpCalloutMock.class, new IAM_SingleRequestMock(200, 'Success', responseBodyGLService, null));
            
            Account acc = obj.acc;
            IAM_GL_webservice.makeCallout(acc.billingStreet, acc.BillingCity, acc.BillingCountry, acc.BillingPostalCode);        
            //System.assertEquals(parentAcc.Id, IAM_GL_webservice.parentDistributorId);
            //System.assertEquals(false, obj.isUserExist(obj.newCon.Email));          
        Test.stopTest();
        
        PageReference pgRef = obj.send();           
        //System.assertEquals(false, obj.errordiv);
        //System.assertEquals(true, pgRef != null);
        //System.assertEquals(existingAcc.Id, obj.newCon.AccountId);
    }
    
    /* RSW Registration - Existing Account (No Account Access Feature Available) */
    static testmethod void rswExistAccNoAccAccessRegTest() {
        PageReference pg = Page.IAM_NewRegistration;        
        Test.setCurrentPage(pg);
        App_Mapping__c app = IAM_TestData.getRSWApp();
        IAM_TestData.create_IAM_EDQ_oAuth_CS();
        IAM_TestData.create_IAM_GL_Service_CS();
        ApexPages.currentPage().getParameters().put('appid',app.Id);
        ApexPages.StandardController sc = new ApexPages.StandardController(new Account());
        IAM_NewAccountRegistration obj = new IAM_NewAccountRegistration(sc);
        Account existingAcc = getAccount();
        existingAcc.Type = 'Dealer Account';
        insert existingAcc;
        
        Account acc2 = IAM_NewAccountRegistration_Test.createAccountRSW1('84931');
        Account acc3 = IAM_NewAccountRegistration_Test.createAccountRSW1('84631');
        Account acc4 = IAM_NewAccountRegistration_Test.createAccountRSW1('94731');
        Account acc5 = IAM_NewAccountRegistration_Test.createAccountRSW1('90731');
        Account acc6 = IAM_NewAccountRegistration_Test.createAccountRSW1('94701');
        
        obj.acc = getAccount();
        obj.rswReason = 'Other';
        List<Account> a = [SELECT IAM_Service_Provider_Code__c FROM Account WHERE Id = :existingAcc.Id];
        obj.rswPreferCode = a[0].IAM_Service_Provider_Code__c;
        obj.rswAdditionalCode = acc2.IAM_Service_Provider_Code__c;
        obj.rswAdditionalCode1 = acc3.IAM_Service_Provider_Code__c;
        obj.rswAdditionalCode2 = acc4.IAM_Service_Provider_Code__c;
        obj.rswAdditionalCode3 = acc5.IAM_Service_Provider_Code__c;
        obj.rswAdditionalCode4 = acc6.IAM_Service_Provider_Code__c;
        obj.newCon = getContact();        
                
        String responseBodyEdqInfo = getEDQResBody('Y');
        Test.setMock(HttpCalloutMock.class, new IAM_SingleRequestMock(200, 'Success', responseBodyEdqInfo, null));
        IAM_EDQ_LocationResParser resp = IAM_EDQ_AddressCleanse.EDQAddress(getAccount());
        Account parentAcc = createParentAccount();
        System.debug('### Test Class 1 - ');
        Test.startTest();
            obj.EDQAddress();
            //System.assertEquals(true, obj.EDQpop);
            obj.input = '' + obj.getChar1() + obj.getChar2() + obj.getChar3() + obj.getChar4() + obj.getChar5() + obj.getChar6();     
            //System.assertEquals(true, obj.isCaptchaValid());
            
            String responseBodyGLService = getGLResBody(parentAcc.IAM_Service_Provider_Code__c, parentAcc.IAM_Service_Provider_Code__c);
            Test.setMock(HttpCalloutMock.class, new IAM_SingleRequestMock(200, 'Success', responseBodyGLService, null));
            
            Account acc = obj.acc;
            IAM_GL_webservice.makeCallout(acc.billingStreet, acc.BillingCity, acc.BillingCountry, acc.BillingPostalCode);        
            //System.assertEquals(parentAcc.Id, IAM_GL_webservice.parentDistributorId);
            //System.assertEquals(false, obj.isUserExist(obj.newCon.Email));
            PageReference pgRef = obj.send();  
            //System.assertEquals(true, obj.errordiv);
            //System.assertEquals(true, pgRef == null);
        Test.stopTest();
    }
    
      public static Account createAccountRSW1(String customerCode) {
        Account acc = new account();
        acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('IAM').getRecordTypeId();
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
        acc.IAM_Service_Provider_Code__c = customerCode;
        insert acc;
        return acc;
    }
    
    //PRS Changes - Start
    
    /* PRS Registration - Existing Account (No Account Access Feature Available) 
    static testmethod void prsExistAccNoAccAccessRegTest() {
        PageReference pg = Page.IAM_NewRegistration;        
        Test.setCurrentPage(pg);
        App_Mapping__c app = IAM_TestData.getPRSApp();
        IAM_TestData.create_IAM_EDQ_oAuth_CS();
        IAM_TestData.create_IAM_GL_Service_CS();
        ApexPages.currentPage().getParameters().put('appid',app.Id);
        ApexPages.StandardController sc = new ApexPages.StandardController(new Account());
        IAM_NewAccountRegistration obj = new IAM_NewAccountRegistration(sc);
        Account existingAcc = getAccount();
        existingAcc.Type = 'Dealer Account';
        insert existingAcc;
        
        Account acc2 = IAM_NewAccountRegistration_Test.createAccountRSW1('84931');
        Account acc3 = IAM_NewAccountRegistration_Test.createAccountRSW1('84631');
        Account acc4 = IAM_NewAccountRegistration_Test.createAccountRSW1('94731');
        Account acc5 = IAM_NewAccountRegistration_Test.createAccountRSW1('90731');
        Account acc6 = IAM_NewAccountRegistration_Test.createAccountRSW1('94701');
        
        obj.acc = getAccount();
        obj.prsReason = 'Cummins General Access';
        List<Account> a = [SELECT IAM_Service_Provider_Code__c FROM Account WHERE Id = :existingAcc.Id];
        obj.prsPreferCode = a[0].IAM_Service_Provider_Code__c;
        obj.prsAdditionalCode = acc2.IAM_Service_Provider_Code__c;
        obj.prsAdditionalCode1 = acc3.IAM_Service_Provider_Code__c;
        obj.prsAdditionalCode2 = acc4.IAM_Service_Provider_Code__c;
        obj.prsAdditionalCode3 = acc5.IAM_Service_Provider_Code__c;
        obj.prsAdditionalCode4 = acc6.IAM_Service_Provider_Code__c;
        obj.newCon = getContact();        
                
        String responseBodyEdqInfo = getEDQResBody('Y');
        Test.setMock(HttpCalloutMock.class, new IAM_SingleRequestMock(200, 'Success', responseBodyEdqInfo, null));
        IAM_EDQ_LocationResParser resp = IAM_EDQ_AddressCleanse.EDQAddress(getAccount());
        Account parentAcc = createParentAccount();
        System.debug('### Test Class 1 - ');
        Test.startTest();
            obj.EDQAddress();
            //System.assertEquals(true, obj.EDQpop);
            obj.input = '' + obj.getChar1() + obj.getChar2() + obj.getChar3() + obj.getChar4() + obj.getChar5() + obj.getChar6();     
            //System.assertEquals(true, obj.isCaptchaValid());
            
            String responseBodyGLService = getGLResBody(parentAcc.IAM_Service_Provider_Code__c, parentAcc.IAM_Service_Provider_Code__c);
            Test.setMock(HttpCalloutMock.class, new IAM_SingleRequestMock(200, 'Success', responseBodyGLService, null));
            
            Account acc = obj.acc;
            IAM_GL_webservice.makeCallout(acc.billingStreet, acc.BillingCity, acc.BillingCountry, acc.BillingPostalCode);        
            //System.assertEquals(parentAcc.Id, IAM_GL_webservice.parentDistributorId);
            //System.assertEquals(false, obj.isUserExist(obj.newCon.Email));
            PageReference pgRef = obj.send();  
            //System.assertEquals(true, obj.errordiv);
            //System.assertEquals(true, pgRef == null);
        Test.stopTest();
    }
    */
    //PRS Changes - End
    /* RSW Registration - Existing Account (Account Access Feature Available) */
    static testmethod void rswExistAccWithAccAccessRegTest() {
        User u = [SELECT Id FROM User WHERE Profile.Name = 'System Administrator'
                  AND UserRoleId != null AND IsActive = true LIMIT 1];
        System.runAs(u) {
        PageReference pg = Page.IAM_NewRegistration;        
        Test.setCurrentPage(pg);
        App_Mapping__c app = IAM_TestData.getRSWApp();
        IAM_TestData.create_IAM_EDQ_oAuth_CS();
        IAM_TestData.create_IAM_GL_Service_CS();
        ApexPages.currentPage().getParameters().put('appid',app.Id);
        ApexPages.StandardController sc = new ApexPages.StandardController(new Account());
        IAM_NewAccountRegistration obj = new IAM_NewAccountRegistration(sc);
         Account parentAcct = createSampleParentAcc();
        Account existingAcc = getAccount01();
         existingAcc.ParentId = parentAcct.Id;  
        insert existingAcc;
        
        Contact existingCon = getContact();
        existingCon.AccountId = existingAcc.Id;
        existingCon.Email = 'tef56st1kr@abc.com'; 
        existingCon.Username__c = 'tef56st1kr@abc.com.iamdev';
        existingCon.CMI_Contact_Type__c = 'Primary';
        existingCon.IAM_Contact_Status__c = 'Active';
        existingCon.RecordtypeId=Schema.SObjectType.contact.getRecordTypeInfosByName().get('IAM').getRecordTypeId();        
        insert existingCon;       
        
        IAM_TestData.createAccountSubscription(existingAcc.Id, app.Name, app.IAM_Default_Role__c,existingCon);
        IAM_TestData.createAccountSubscription(existingAcc.ParentId, app.Name, app.IAM_Default_Role__c,existingCon);
        obj.acc = getAccount01();
        obj.rswReason = 'Other';
        obj.rswOtherReason = 'Test';
        obj.rswPreferCode = obj.acc.IAM_Service_Provider_Code__c;
        obj.rswAdditionalCode = '123';
        obj.rswAdditionalCode1 = '123';
        obj.rswAdditionalCode2 = '123';
        obj.rswAdditionalCode3 = '123';
        obj.rswAdditionalCode4 = '123';
        obj.newCon = getContact();       
                
        String responseBodyEdqInfo = getEDQResBody('Y');
        Test.setMock(HttpCalloutMock.class, new IAM_SingleRequestMock(200, 'Success', responseBodyEdqInfo, null));
        IAM_EDQ_LocationResParser resp = IAM_EDQ_AddressCleanse.EDQAddress(getAccount());
        Account parentAcc = createParentAccount();
        System.debug('### Test Class 1 - ');
        Test.startTest();
            obj.EDQAddress();
            obj.input = '' + obj.getChar1() + obj.getChar2() + obj.getChar3() + obj.getChar4() + obj.getChar5() + obj.getChar6();     
            //System.assertEquals(true, obj.isCaptchaValid());
            
            String responseBodyGLService = getGLResBody(parentAcc.IAM_Service_Provider_Code__c, parentAcc.IAM_Service_Provider_Code__c);
            Test.setMock(HttpCalloutMock.class, new IAM_SingleRequestMock(200, 'Success', responseBodyGLService, null));
            
            Account acc = obj.acc;
            IAM_GL_webservice.makeCallout(acc.billingStreet, acc.BillingCity, acc.BillingCountry, acc.BillingPostalCode);        
            //System.assertEquals(parentAcc.Id, IAM_GL_webservice.parentDistributorId);
            //System.assertEquals(false, obj.isUserExist(obj.newCon.Email));
            PageReference pgRef = obj.send();  
            //System.assertEquals(false, obj.errordiv);
            //System.assertEquals(true, pgRef != null);
        Test.stopTest();
        }
    }
    
    //PRS Changes - Start
    /* PRS Registration - Existing Account (Account Access Feature Available) 
    static testmethod void prsExistAccWithAccAccessRegTest() {
        User u = [SELECT Id FROM User WHERE Profile.Name = 'System Administrator'
                  AND UserRoleId != null AND IsActive = true LIMIT 1];
        System.runAs(u) {
        PageReference pg = Page.IAM_NewRegistration;        
        Test.setCurrentPage(pg);
        App_Mapping__c app = IAM_TestData.getPRSApp();
        IAM_TestData.create_IAM_EDQ_oAuth_CS();
        IAM_TestData.create_IAM_GL_Service_CS();
        ApexPages.currentPage().getParameters().put('appid',app.Id);
        ApexPages.StandardController sc = new ApexPages.StandardController(new Account());
        IAM_NewAccountRegistration obj = new IAM_NewAccountRegistration(sc);
         Account parentAcct = createSampleParentAcc();
        Account existingAcc = getAccount01();
         existingAcc.ParentId = parentAcct.Id;  
        insert existingAcc;
        
        Contact existingCon = getContact();
        existingCon.AccountId = existingAcc.Id;
        existingCon.Email = 'tef56st1kr@abc.com'; 
        existingCon.Username__c = 'tef56st1kr@abc.com.iamdev';
        existingCon.CMI_Contact_Type__c = 'Primary';
        existingCon.IAM_Contact_Status__c = 'Active';
        existingCon.RecordtypeId=Schema.SObjectType.contact.getRecordTypeInfosByName().get('IAM').getRecordTypeId();        
        insert existingCon;       
        
        IAM_TestData.createAccountSubscription(existingAcc.Id, app.Name, app.IAM_Default_Role__c,existingCon);
        IAM_TestData.createAccountSubscription(existingAcc.ParentId, app.Name, app.IAM_Default_Role__c,existingCon);
        obj.acc = getAccount01();
        obj.prsReason = 'Cummins General Access';        
        obj.prsPreferCode = obj.acc.IAM_Service_Provider_Code__c;
        obj.prsAdditionalCode = '123';
        obj.prsAdditionalCode1 = '123';
        obj.prsAdditionalCode2 = '123';
        obj.prsAdditionalCode3 = '123';
        obj.prsAdditionalCode4 = '123';
        obj.newCon = getContact();       
                
        String responseBodyEdqInfo = getEDQResBody('Y');
        Test.setMock(HttpCalloutMock.class, new IAM_SingleRequestMock(200, 'Success', responseBodyEdqInfo, null));
        IAM_EDQ_LocationResParser resp = IAM_EDQ_AddressCleanse.EDQAddress(getAccount());
        Account parentAcc = createParentAccount();
        System.debug('### Test Class 1 - ');
        Test.startTest();
            obj.EDQAddress();
            obj.input = '' + obj.getChar1() + obj.getChar2() + obj.getChar3() + obj.getChar4() + obj.getChar5() + obj.getChar6();     
            //System.assertEquals(true, obj.isCaptchaValid());
            
            String responseBodyGLService = getGLResBody(parentAcc.IAM_Service_Provider_Code__c, parentAcc.IAM_Service_Provider_Code__c);
            Test.setMock(HttpCalloutMock.class, new IAM_SingleRequestMock(200, 'Success', responseBodyGLService, null));
            
            Account acc = obj.acc;
            IAM_GL_webservice.makeCallout(acc.billingStreet, acc.BillingCity, acc.BillingCountry, acc.BillingPostalCode);        
            //System.assertEquals(parentAcc.Id, IAM_GL_webservice.parentDistributorId);
            //System.assertEquals(false, obj.isUserExist(obj.newCon.Email));
            PageReference pgRef = obj.send();  
            //System.assertEquals(false, obj.errordiv);
            //System.assertEquals(true, pgRef != null);
        Test.stopTest();
        }
    }
    */
    //PRS Changes - End
    /* RSW Registration - Existing Account (Account Access Feature Available) - As part of RSW change @Anupam*/
    static testmethod void rswExistAccWithAccAccessTest() {
        User u = [SELECT Id FROM User WHERE Profile.Name = 'System Administrator'
                  AND UserRoleId != null AND IsActive = true LIMIT 1];
        System.runAs(u) {
        PageReference pg = Page.IAM_NewRegistration;        
        Test.setCurrentPage(pg);
        App_Mapping__c app = IAM_TestData.getRSWApp();
        IAM_TestData.create_IAM_EDQ_oAuth_CS();
        IAM_TestData.create_IAM_GL_Service_CS();
        ApexPages.currentPage().getParameters().put('appid',app.Id);
        ApexPages.StandardController sc = new ApexPages.StandardController(new Account());
        IAM_NewAccountRegistration obj = new IAM_NewAccountRegistration(sc);
         //Account parentAcct = createSampleParentAcc();
        Account existingAcc = getAccount();
         //existingAcc.ParentId = parentAcct.Id;  
        insert existingAcc;
        
        Contact existingCon = getContact();
        existingCon.AccountId = existingAcc.Id;
        existingCon.Email = 'tef56st1kr@abc.com'; 
        existingCon.Username__c = 'tef56st1kr@abc.com.iamdev';
        existingCon.CMI_Contact_Type__c = 'Primary';
        existingCon.IAM_Contact_Status__c = 'Active';
        existingCon.RecordtypeId=Schema.SObjectType.contact.getRecordTypeInfosByName().get('IAM').getRecordTypeId();        
        insert existingCon;       
        
        IAM_TestData.createAccountSubscription(existingAcc.Id, app.Name, app.IAM_Default_Role__c,existingCon);
        //IAM_TestData.createAccountSubscription(existingAcc.ParentId, app.Name, app.IAM_Default_Role__c,existingCon);
        obj.acc = getAccount();
        obj.rswReason = 'Other';
        obj.rswOtherReason = 'Test';
        obj.rswPreferCode = obj.acc.IAM_Service_Provider_Code__c;
        obj.rswAdditionalCode = '123';
        obj.rswAdditionalCode1 = '123';
        obj.rswAdditionalCode2 = '123';
        obj.rswAdditionalCode3 = '123';
        obj.rswAdditionalCode4 = '123';
        obj.newCon = getContact();       
                
        String responseBodyEdqInfo = getEDQResBody('Y');
        Test.setMock(HttpCalloutMock.class, new IAM_SingleRequestMock(200, 'Success', responseBodyEdqInfo, null));
        IAM_EDQ_LocationResParser resp = IAM_EDQ_AddressCleanse.EDQAddress(getAccount());
        Account parentAcc = createParentAccount();
        System.debug('### Test Class 1 - ');
        Test.startTest();
            obj.EDQAddress();
            obj.input = '' + obj.getChar1() + obj.getChar2() + obj.getChar3() + obj.getChar4() + obj.getChar5() + obj.getChar6();     
            //System.assertEquals(true, obj.isCaptchaValid());
            
            String responseBodyGLService = getGLResBody(parentAcc.IAM_Service_Provider_Code__c, parentAcc.IAM_Service_Provider_Code__c);
            Test.setMock(HttpCalloutMock.class, new IAM_SingleRequestMock(200, 'Success', responseBodyGLService, null));
            
            Account acc = obj.acc;
            IAM_GL_webservice.makeCallout(acc.billingStreet, acc.BillingCity, acc.BillingCountry, acc.BillingPostalCode);        
            //System.assertEquals(parentAcc.Id, IAM_GL_webservice.parentDistributorId);
            //System.assertEquals(false, obj.isUserExist(obj.newCon.Email));
            PageReference pgRef = obj.send();  
            //System.assertEquals(false, obj.errordiv);
            //System.assertEquals(true, pgRef != null);
        Test.stopTest();
        }
    }
    
    /* RSW Registration - Existing Account (Account Access Feature Available) - As part of RSW change @Anupam*/
    static testmethod void rswExistAccWithAccAccessTest02() {
        User u = [SELECT Id FROM User WHERE Profile.Name = 'System Administrator'
                  AND UserRoleId != null AND IsActive = true LIMIT 1];
        System.runAs(u) {
        PageReference pg = Page.IAM_NewRegistration;        
        Test.setCurrentPage(pg);
        App_Mapping__c app = IAM_TestData.getRSWApp();
        IAM_TestData.create_IAM_EDQ_oAuth_CS();
        IAM_TestData.create_IAM_GL_Service_CS();
        ApexPages.currentPage().getParameters().put('appid',app.Id);
        ApexPages.StandardController sc = new ApexPages.StandardController(new Account());
        IAM_NewAccountRegistration obj = new IAM_NewAccountRegistration(sc);
         Account parentAcct = createSampleParentAcc();
        Account existingAcc = getAccount01();
         existingAcc.ParentId = parentAcct.Id;  
        insert existingAcc;
        
        Contact existingCon = getContact();
        existingCon.AccountId = existingAcc.Id;
        existingCon.Email = 'tef56st1kr@abc.com'; 
        existingCon.Username__c = 'tef56st1kr@abc.com.iamdev';
        existingCon.CMI_Contact_Type__c = 'Primary';
        existingCon.IAM_Contact_Status__c = 'Active';
        existingCon.RecordtypeId=Schema.SObjectType.contact.getRecordTypeInfosByName().get('IAM').getRecordTypeId();        
        insert existingCon;       
        
        //IAM_TestData.createAccountSubscription(existingAcc.Id, app.Name, app.IAM_Default_Role__c,existingCon);
        IAM_TestData.createAccountSubscription(existingAcc.ParentId, app.Name, app.IAM_Default_Role__c,existingCon);
        obj.acc = getAccount01();
        obj.rswReason = 'Other';
        obj.rswOtherReason = 'Test';
        obj.rswPreferCode = obj.acc.IAM_Service_Provider_Code__c;
        obj.rswAdditionalCode = '123';
        obj.rswAdditionalCode1 = '123';
        obj.rswAdditionalCode2 = '123';
        obj.rswAdditionalCode3 = '123';
        obj.rswAdditionalCode4 = '123';
        obj.newCon = getContact();       
                
        String responseBodyEdqInfo = getEDQResBody('Y');
        Test.setMock(HttpCalloutMock.class, new IAM_SingleRequestMock(200, 'Success', responseBodyEdqInfo, null));
        IAM_EDQ_LocationResParser resp = IAM_EDQ_AddressCleanse.EDQAddress(getAccount());
        Account parentAcc = createParentAccount();
        System.debug('### Test Class 1 - ');
        Test.startTest();
            obj.EDQAddress();
            obj.input = '' + obj.getChar1() + obj.getChar2() + obj.getChar3() + obj.getChar4() + obj.getChar5() + obj.getChar6();     
            //System.assertEquals(true, obj.isCaptchaValid());
            
            String responseBodyGLService = getGLResBody(parentAcc.IAM_Service_Provider_Code__c, parentAcc.IAM_Service_Provider_Code__c);
            Test.setMock(HttpCalloutMock.class, new IAM_SingleRequestMock(200, 'Success', responseBodyGLService, null));
            
            Account acc = obj.acc;
            IAM_GL_webservice.makeCallout(acc.billingStreet, acc.BillingCity, acc.BillingCountry, acc.BillingPostalCode);        
            //System.assertEquals(parentAcc.Id, IAM_GL_webservice.parentDistributorId);
            //System.assertEquals(false, obj.isUserExist(obj.newCon.Email));
            PageReference pgRef = obj.send();  
            //System.assertEquals(false, obj.errordiv);
            //System.assertEquals(true, pgRef != null);
        Test.stopTest();
        }
    }
    
    /* Connected Solutions Registration - New Account */
    static testmethod void daNewAccRegistrationTest1() {
        PageReference pg = Page.IAM_NewRegistration;        
        Test.setCurrentPage(pg);
        App_Mapping__c app = IAM_TestData.getDAApp();
        IAM_TestData.create_IAM_EDQ_oAuth_CS();
        IAM_TestData.create_IAM_GL_Service_CS();
        ApexPages.currentPage().getParameters().put('appid',app.Id);
        ApexPages.StandardController sc = new ApexPages.StandardController(new Account());
        IAM_NewAccountRegistration obj = new IAM_NewAccountRegistration(sc);
        obj.acc = getAccount();
        obj.acc.IAM_Primary_Market_Segment__c = 'Mining';
        obj.acc.CMI_Telematics_Service_Provider__c = 'zonar';
        obj.newCon = getContact();        
                
        String responseBodyEdqInfo = getEDQResBody('Y');
        Test.setMock(HttpCalloutMock.class, new IAM_SingleRequestMock(200, 'Success', responseBodyEdqInfo, null));
        IAM_EDQ_LocationResParser resp = IAM_EDQ_AddressCleanse.EDQAddress(getAccount());
        Account parentAcc = createParentAccount();
        System.debug('### Test Class 1 - ');
        Test.startTest();
            obj.EDQAddress();
            //System.assertEquals(true, obj.EDQpop);
            obj.input = '' + obj.getChar1() + obj.getChar2() + obj.getChar3() + obj.getChar4() + obj.getChar5() + obj.getChar6();     
            //System.assertEquals(true, obj.isCaptchaValid());
            
            String responseBodyGLService = getGLResBody(parentAcc.IAM_Service_Provider_Code__c, parentAcc.IAM_Service_Provider_Code__c);
            Test.setMock(HttpCalloutMock.class, new IAM_SingleRequestMock(200, 'Success', responseBodyGLService, null));
            
            Account acc = obj.acc;
            IAM_GL_webservice.makeCallout(acc.billingStreet, acc.BillingCity, acc.BillingCountry, acc.BillingPostalCode);        
            //System.assertEquals(parentAcc.Id, IAM_GL_webservice.parentDistributorId);
            //System.assertEquals(false, obj.isUserExist(obj.newCon.Email));
            PageReference pgRef = obj.send();           
            //System.assertEquals(false, obj.errordiv);
            //System.assertEquals(true, pgRef != null);
        Test.stopTest();
    }
    
    /* Connected Solutions Registration - New Account */
    static testmethod void daNewAccRegistrationTest2() {
        PageReference pg = Page.IAM_NewRegistration;        
        Test.setCurrentPage(pg);
        App_Mapping__c app = IAM_TestData.getDAApp();
        IAM_TestData.create_IAM_EDQ_oAuth_CS();
        IAM_TestData.create_IAM_GL_Service_CS();
        ApexPages.currentPage().getParameters().put('appid',app.Id);
        ApexPages.StandardController sc = new ApexPages.StandardController(new Account());
        IAM_NewAccountRegistration obj = new IAM_NewAccountRegistration(sc);
        obj.acc = getAccount();
        obj.acc.IAM_Primary_Market_Segment__c = 'Mining';
        obj.acc.CMI_Telematics_Service_Provider__c = 'Other TSP';
        obj.acc.CMI_Other_TSP__c = 'Other';
        obj.newCon = getContact();        
                
        String responseBodyEdqInfo = getEDQResBody('Y');
        Test.setMock(HttpCalloutMock.class, new IAM_SingleRequestMock(200, 'Success', responseBodyEdqInfo, null));
        IAM_EDQ_LocationResParser resp = IAM_EDQ_AddressCleanse.EDQAddress(getAccount());
        Account parentAcc = createParentAccount();
        System.debug('### Test Class 1 - ');
        Test.startTest();
            obj.EDQAddress();
            //System.assertEquals(true, obj.EDQpop);
            obj.input = '' + obj.getChar1() + obj.getChar2() + obj.getChar3() + obj.getChar4() + obj.getChar5() + obj.getChar6();     
            //System.assertEquals(true, obj.isCaptchaValid());
            
            String responseBodyGLService = getGLResBody(parentAcc.IAM_Service_Provider_Code__c, parentAcc.IAM_Service_Provider_Code__c);
            Test.setMock(HttpCalloutMock.class, new IAM_SingleRequestMock(200, 'Success', responseBodyGLService, null));
            
            Account acc = obj.acc;
            IAM_GL_webservice.makeCallout(acc.billingStreet, acc.BillingCity, acc.BillingCountry, acc.BillingPostalCode);        
            //System.assertEquals(parentAcc.Id, IAM_GL_webservice.parentDistributorId);
            //System.assertEquals(false, obj.isUserExist(obj.newCon.Email));
            PageReference pgRef = obj.send();           
            //System.assertEquals(false, obj.errordiv);
            //System.assertEquals(true, pgRef != null);
        Test.stopTest();
    }
    
    /* Connected Solutions Registration - Existing Account (No Primary Contact Available) */
    static testmethod void daExistingAccRegNoParentPrimaryCon() {
        PageReference pg = Page.IAM_NewRegistration;        
        Test.setCurrentPage(pg);
        App_Mapping__c app = IAM_TestData.getDAApp();
        IAM_TestData.create_IAM_EDQ_oAuth_CS();
        IAM_TestData.create_IAM_GL_Service_CS();
        ApexPages.currentPage().getParameters().put('appid',app.Id);
        ApexPages.StandardController sc = new ApexPages.StandardController(new Account());
        IAM_NewAccountRegistration obj = new IAM_NewAccountRegistration(sc);
        Account existingAcc = getAccount();
        insert existingAcc;
        obj.acc = getAccount();
        obj.acc.IAM_Primary_Market_Segment__c = 'Mining';
        obj.acc.CMI_Telematics_Service_Provider__c = 'zonar';
        obj.newCon = getContact();        
                
        String responseBodyEdqInfo = getEDQResBody('Y');
        Test.setMock(HttpCalloutMock.class, new IAM_SingleRequestMock(200, 'Success', responseBodyEdqInfo, null));
        IAM_EDQ_LocationResParser resp = IAM_EDQ_AddressCleanse.EDQAddress(getAccount());
        Account parentAcc = createParentAccount();
        System.debug('### Test Class 1 - ');
        Test.startTest();
            obj.EDQAddress();
            //System.assertEquals(true, obj.EDQpop);
            obj.input = '' + obj.getChar1() + obj.getChar2() + obj.getChar3() + obj.getChar4() + obj.getChar5() + obj.getChar6();     
            //System.assertEquals(true, obj.isCaptchaValid());
            
            String responseBodyGLService = getGLResBody(parentAcc.IAM_Service_Provider_Code__c, parentAcc.IAM_Service_Provider_Code__c);
            Test.setMock(HttpCalloutMock.class, new IAM_SingleRequestMock(200, 'Success', responseBodyGLService, null));
            
            Account acc = obj.acc;
            IAM_GL_webservice.makeCallout(acc.billingStreet, acc.BillingCity, acc.BillingCountry, acc.BillingPostalCode);        
            //System.assertEquals(parentAcc.Id, IAM_GL_webservice.parentDistributorId);
            //System.assertEquals(false, obj.isUserExist(obj.newCon.Email));          
        Test.stopTest();
        PageReference pgRef = obj.send();           
        /*System.assertEquals(true, obj.errordiv);
        System.assertEquals(true, pgRef == null);
        List<ApexPages.Message> pageMessages = ApexPages.getMessages();
        System.assertNotEquals(0, pageMessages.size());
        System.assertEquals(Label.IAM_Contact_Cummins_Care_Message, pageMessages[0].getSummary());*/
    }
    
    /* Connected Solutions Registration - Existing Account 
    * (Existing Account Primary User is having subscription for Connected Solutions) */
    static testmethod void daExistingAccRegWithParentPrimaryCon() {
        User u = [SELECT Id FROM User WHERE Profile.Name = 'System Administrator'
                  AND UserRoleId != null AND IsActive = true LIMIT 1];
        System.runAs(u) {
        PageReference pg = Page.IAM_NewRegistration;        
        Test.setCurrentPage(pg);
        App_Mapping__c app = IAM_TestData.getDAApp();
        IAM_TestData.create_IAM_EDQ_oAuth_CS();
        IAM_TestData.create_IAM_GL_Service_CS();
        ApexPages.currentPage().getParameters().put('appid',app.Id);
        ApexPages.StandardController sc = new ApexPages.StandardController(new Account());
        IAM_NewAccountRegistration obj = new IAM_NewAccountRegistration(sc);
        Account existingAcc = getAccount();
        insert existingAcc;        
         
        Contact existingCon = getContact();
        existingCon.AccountId = existingAcc.Id;
        existingCon.Email = 'tef56st1@abc.com'; 
        existingCon.Username__c = 'tef56st1@abc.com.iamdev';
        existingCon.CMI_Contact_Type__c = 'Primary';
        existingCon.IAM_Contact_Status__c = 'Active';
        existingCon.RecordtypeId=Schema.SObjectType.contact.getRecordTypeInfosByName().get('IAM').getRecordTypeId();        
        insert existingCon;
        
        List<Contact> conList = new List<Contact>();
        conList.add(existingCon);
        //IAM_CreateUser.CreateUser(conList);
        
         IAM_Application__c accAccessObj = IAM_TestData.createAccountSubscription(existingAcc.Id, app.Name, app.IAM_Default_Role__c,existingCon);
        createUserSubscription(existingCon.Id, app.Name, app.IAM_Default_Role__c, accAccessObj.Id);
        
        obj.acc = getAccount();
        obj.acc.IAM_Primary_Market_Segment__c = 'Mining';
        obj.acc.CMI_Telematics_Service_Provider__c = 'zonar';
        obj.newCon = getContact();        
                
        String responseBodyEdqInfo = getEDQResBody('Y');
        Test.setMock(HttpCalloutMock.class, new IAM_SingleRequestMock(200, 'Success', responseBodyEdqInfo, null));
        IAM_EDQ_LocationResParser resp = IAM_EDQ_AddressCleanse.EDQAddress(getAccount());
        Account parentAcc = createParentAccount();
        System.debug('### Test Class 1 - ');
        Test.startTest();
            obj.EDQAddress();
            //System.assertEquals(true, obj.EDQpop);
            obj.input = '' + obj.getChar1() + obj.getChar2() + obj.getChar3() + obj.getChar4() + obj.getChar5() + obj.getChar6();     
            //System.assertEquals(true, obj.isCaptchaValid());
            
            String responseBodyGLService = getGLResBody(parentAcc.IAM_Service_Provider_Code__c, parentAcc.IAM_Service_Provider_Code__c);
            Test.setMock(HttpCalloutMock.class, new IAM_SingleRequestMock(200, 'Success', responseBodyGLService, null));
            
            Account acc = obj.acc;
            IAM_GL_webservice.makeCallout(acc.billingStreet, acc.BillingCity, acc.BillingCountry, acc.BillingPostalCode);        
            //System.assertEquals(parentAcc.Id, IAM_GL_webservice.parentDistributorId);
            //System.assertEquals(false, obj.isUserExist(obj.newCon.Email));
            obj.primaryUserHasDAAccess(existingAcc.Id); 
        Test.stopTest();
               
        //PageReference pgRef = obj.send();           
        //System.assertEquals(false, obj.errordiv);
        //System.assertEquals(true, pgRef != null);
        //System.assertEquals(existingAcc.Id, obj.newCon.AccountId);
        }
    }
    
    /* Connected Solutions Registration - Existing Account 
    * (Existing Account Primary User do not have subscription for Connected Solutions) */
    static testmethod void daExistingAccRegWithParentPrimaryCon2() {
        User u = [SELECT Id FROM User WHERE Profile.Name = 'System Administrator'
                  AND UserRoleId != null AND IsActive = true LIMIT 1];
        System.runAs(u) {
        PageReference pg = Page.IAM_NewRegistration;        
        Test.setCurrentPage(pg);
        App_Mapping__c app = IAM_TestData.getDAApp();
        IAM_TestData.create_IAM_EDQ_oAuth_CS();
        IAM_TestData.create_IAM_GL_Service_CS();
        ApexPages.currentPage().getParameters().put('appid',app.Id);
        ApexPages.StandardController sc = new ApexPages.StandardController(new Account());
        IAM_NewAccountRegistration obj = new IAM_NewAccountRegistration(sc);
        Account existingAcc = getAccount();
        insert existingAcc;              
        
        Contact existingCon = getContact();
        existingCon.AccountId = existingAcc.Id;
        existingCon.Email = 'tef56st1@abc.com'; 
        existingCon.Username__c = 'tef56st1@abc.com.iamdev';
        existingCon.CMI_Contact_Type__c = 'Primary';
        existingCon.IAM_Contact_Status__c = 'Active'; 
        existingCon.RecordtypeId=Schema.SObjectType.contact.getRecordTypeInfosByName().get('IAM').getRecordTypeId();       
        insert existingCon;       
        
        List<Contact> conList = new List<Contact>();
        conList.add(existingCon);
        //IAM_CreateUser.CreateUser(conList);      
       
        IAM_Application__c accAccessObj = IAM_TestData.createAccountSubscription(existingAcc.Id, app.Name, app.IAM_Default_Role__c,existingCon);
       
        obj.acc = getAccount();
        obj.acc.IAM_Primary_Market_Segment__c = 'Mining';
        obj.acc.CMI_Telematics_Service_Provider__c = 'zonar';
        obj.newCon = getContact();        
                
        String responseBodyEdqInfo = getEDQResBody('Y');
        Test.setMock(HttpCalloutMock.class, new IAM_SingleRequestMock(200, 'Success', responseBodyEdqInfo, null));
        IAM_EDQ_LocationResParser resp = IAM_EDQ_AddressCleanse.EDQAddress(getAccount());
        Account parentAcc = createParentAccount();
        System.debug('### Test Class 1 - ');
        Test.startTest();
            obj.EDQAddress();
            //System.assertEquals(true, obj.EDQpop);
            obj.input = '' + obj.getChar1() + obj.getChar2() + obj.getChar3() + obj.getChar4() + obj.getChar5() + obj.getChar6();     
            //System.assertEquals(true, obj.isCaptchaValid());
            
            String responseBodyGLService = getGLResBody(parentAcc.IAM_Service_Provider_Code__c, parentAcc.IAM_Service_Provider_Code__c);
            Test.setMock(HttpCalloutMock.class, new IAM_SingleRequestMock(200, 'Success', responseBodyGLService, null));
            
            Account acc = obj.acc;
            IAM_GL_webservice.makeCallout(acc.billingStreet, acc.BillingCity, acc.BillingCountry, acc.BillingPostalCode);        
            //System.assertEquals(parentAcc.Id, IAM_GL_webservice.parentDistributorId);
            //System.assertEquals(false, obj.isUserExist(obj.newCon.Email));          
        Test.stopTest();
        
        PageReference pgRef = obj.send();           
        //System.assertEquals(false, obj.errordiv);
        //System.assertEquals(true, pgRef != null);
        //System.assertEquals(existingAcc.Id, obj.newCon.AccountId);
        }
    }
    
    /* Guidanz Mobile Registration - New Account */
    static testmethod void guiMobNewAccRegistrationTest() {
        system.debug('inside guiMobNewAccRegistrationTest method--->');
        PageReference pg = Page.IAM_NewRegistration;        
        Test.setCurrentPage(pg);
        App_Mapping__c app = IAM_TestData.getGuidanzMobileApp();
        IAM_TestData.create_IAM_EDQ_oAuth_CS();
        IAM_TestData.create_IAM_GL_Service_CS();
        ApexPages.currentPage().getParameters().put('appid',app.Id);
        ApexPages.StandardController sc = new ApexPages.StandardController(new Account());
        IAM_NewAccountRegistration obj = new IAM_NewAccountRegistration(sc);
        obj.acc = getAccount();
        obj.newCon = getContact();        
                
        String responseBodyEdqInfo = getEDQResBody('Y');
        Test.setMock(HttpCalloutMock.class, new IAM_SingleRequestMock(200, 'Success', responseBodyEdqInfo, null));
        IAM_EDQ_LocationResParser resp = IAM_EDQ_AddressCleanse.EDQAddress(getAccount());
        Account parentAcc = createParentAccount();
        System.debug('### Test Class 1 - ');
        Test.startTest();
            obj.EDQAddress();
            //System.assertEquals(true, obj.EDQpop);
            obj.input = '' + obj.getChar1() + obj.getChar2() + obj.getChar3() + obj.getChar4() + obj.getChar5() + obj.getChar6();     
            //System.assertEquals(true, obj.isCaptchaValid());
            
            String responseBodyGLService = getGLResBody(parentAcc.IAM_Service_Provider_Code__c, parentAcc.IAM_Service_Provider_Code__c);
            Test.setMock(HttpCalloutMock.class, new IAM_SingleRequestMock(200, 'Success', responseBodyGLService, null));
            
            Account acc = obj.acc;
            IAM_GL_webservice.makeCallout(acc.billingStreet, acc.BillingCity, acc.BillingCountry, acc.BillingPostalCode);        
            //System.assertEquals(parentAcc.Id, IAM_GL_webservice.parentDistributorId);
            //System.assertEquals(false, obj.isUserExist(obj.newCon.Email));
            PageReference pgRef = obj.send();           
            //System.assertEquals(true, pgRef != null);
        Test.stopTest();
    }
    
    /* Guidanz Mobile Registration - Existing Account (With Account Access Subscriton available for existing account) */
    static testmethod void guiMobExiAccRegWithAccAcessTest() {
        /*User u = [SELECT Id FROM User WHERE Profile.Name = 'System Administrator'
                  AND UserRoleId != null AND IsActive = true LIMIT 1];
        System.runAs(u) {*/
        system.debug('inside guiMobExiAccRegWithAccAcessTest method--->');
        PageReference pg = Page.IAM_NewRegistration;        
        Test.setCurrentPage(pg);
        App_Mapping__c app = IAM_TestData.getGuidanzMobileApp();
            system.debug('app data-->'+app);
        IAM_TestData.create_IAM_EDQ_oAuth_CS();
        IAM_TestData.create_IAM_GL_Service_CS();
        ApexPages.currentPage().getParameters().put('appid',app.Id);
        ApexPages.StandardController sc = new ApexPages.StandardController(new Account());
        IAM_NewAccountRegistration obj = new IAM_NewAccountRegistration(sc);
        //Account existingAcc = createSampleParentAcc();
        Account existingAcc = getAccount();
        existingAcc.Name = 'FnameLname';
        existingAcc.IAM_Service_Provider_Code__c = '';
        insert existingAcc;        
        
        IAM_Application__c accAccessObj = IAM_TestData.createAccountSubscription(existingAcc.Id, app.Name,'Guidanz Mobile Service Dealer');
        
        obj.acc = getAccount();
        //obj.acc = createSampleParentAcc();
        obj.newCon = getContact();        
                
        String responseBodyEdqInfo = getEDQResBody('Y');
        Test.setMock(HttpCalloutMock.class, new IAM_SingleRequestMock(200, 'Success', responseBodyEdqInfo, null));
        IAM_EDQ_LocationResParser resp = IAM_EDQ_AddressCleanse.EDQAddress(getAccount());
        Account parentAcc = createParentAccount();
        System.debug('### Test Class 1 - ');
        Test.startTest();
            obj.EDQAddress();
            //System.assertEquals(true, obj.EDQpop);
            obj.input = '' + obj.getChar1() + obj.getChar2() + obj.getChar3() + obj.getChar4() + obj.getChar5() + obj.getChar6();     
            //System.assertEquals(true, obj.isCaptchaValid());
            
            String responseBodyGLService = getGLResBody(parentAcc.IAM_Service_Provider_Code__c, parentAcc.IAM_Service_Provider_Code__c);
            Test.setMock(HttpCalloutMock.class, new IAM_SingleRequestMock(200, 'Success', responseBodyGLService, null));
            
            Account acc = obj.acc;
            IAM_GL_webservice.makeCallout(acc.billingStreet, acc.BillingCity, acc.BillingCountry, acc.BillingPostalCode);        
            //System.assertEquals(parentAcc.Id, IAM_GL_webservice.parentDistributorId);
            //System.assertEquals(false, obj.isUserExist(obj.newCon.Email));
            PageReference pgRef = obj.send();           
            //System.assertEquals(true, pgRef != null);
        Test.stopTest();
        //}
    }
    
    /* Guidanz Mobile Registration - Existing Account (No Account Access Subscriton available for existing account) */
    static testmethod void guiMobExiAccRegNoAccAcessTest() {
        PageReference pg = Page.IAM_NewRegistration;        
        Test.setCurrentPage(pg);
        App_Mapping__c app = IAM_TestData.getGuidanzMobileApp();
        IAM_TestData.create_IAM_EDQ_oAuth_CS();
        IAM_TestData.create_IAM_GL_Service_CS();
        ApexPages.currentPage().getParameters().put('appid',app.Id);
        ApexPages.StandardController sc = new ApexPages.StandardController(new Account());
        IAM_NewAccountRegistration obj = new IAM_NewAccountRegistration(sc);
        Account existingAcc = getAccount();
        existingAcc.Name = 'FnameLname';
        existingAcc.IAM_Service_Provider_Code__c = '';
        insert existingAcc; 
        
        obj.acc = getAccount();
        obj.newCon = getContact();        
                
        String responseBodyEdqInfo = getEDQResBody('Y');
        Test.setMock(HttpCalloutMock.class, new IAM_SingleRequestMock(200, 'Success', responseBodyEdqInfo, null));
        IAM_EDQ_LocationResParser resp = IAM_EDQ_AddressCleanse.EDQAddress(getAccount());
        Account parentAcc = createParentAccount();
        System.debug('### Test Class 1 - ');
        Test.startTest();
            obj.EDQAddress();
            //System.assertEquals(true, obj.EDQpop);
            obj.input = '' + obj.getChar1() + obj.getChar2() + obj.getChar3() + obj.getChar4() + obj.getChar5() + obj.getChar6();     
            //System.assertEquals(true, obj.isCaptchaValid());
            
            String responseBodyGLService = getGLResBody(parentAcc.IAM_Service_Provider_Code__c, parentAcc.IAM_Service_Provider_Code__c);
            Test.setMock(HttpCalloutMock.class, new IAM_SingleRequestMock(200, 'Success', responseBodyGLService, null));
            
            Account acc = obj.acc;
            IAM_GL_webservice.makeCallout(acc.billingStreet, acc.BillingCity, acc.BillingCountry, acc.BillingPostalCode);        
            //System.assertEquals(parentAcc.Id, IAM_GL_webservice.parentDistributorId);
            //System.assertEquals(false, obj.isUserExist(obj.newCon.Email));
            PageReference pgRef = obj.send();           
            //System.assertEquals(true, pgRef != null);
        Test.stopTest();
    }
    
    /* EDS Registration - New Account */
    static testmethod void edsNewAccRegistrationTest() {
        PageReference pg = Page.IAM_NewRegistration;        
        Test.setCurrentPage(pg);
        App_Mapping__c app = IAM_TestData.getEDSApp();
        IAM_TestData.create_IAM_EDQ_oAuth_CS();
        IAM_TestData.create_IAM_GL_Service_CS();
        ApexPages.currentPage().getParameters().put('appid',app.Id);
        ApexPages.StandardController sc = new ApexPages.StandardController(new Account());
        IAM_NewAccountRegistration obj = new IAM_NewAccountRegistration(sc);
        obj.acc = getAccount();
        obj.newCon = getContact();        
                
        String responseBodyEdqInfo = getEDQResBody('Y');
        Test.setMock(HttpCalloutMock.class, new IAM_SingleRequestMock(200, 'Success', responseBodyEdqInfo, null));
        IAM_EDQ_LocationResParser resp = IAM_EDQ_AddressCleanse.EDQAddress(getAccount());
        Account parentAcc = createParentAccount();
        System.debug('### Test Class 1 - ');
        Test.startTest();
            obj.EDQAddress();
            //System.assertEquals(true, obj.EDQpop);
            obj.input = '' + obj.getChar1() + obj.getChar2() + obj.getChar3() + obj.getChar4() + obj.getChar5() + obj.getChar6();     
            //System.assertEquals(true, obj.isCaptchaValid());
            
            String responseBodyGLService = getGLResBody(parentAcc.IAM_Service_Provider_Code__c, parentAcc.IAM_Service_Provider_Code__c);
            Test.setMock(HttpCalloutMock.class, new IAM_SingleRequestMock(200, 'Success', responseBodyGLService, null));
            
            Account acc = obj.acc;
            IAM_GL_webservice.makeCallout(acc.billingStreet, acc.BillingCity, acc.BillingCountry, acc.BillingPostalCode);        
            //System.assertEquals(parentAcc.Id, IAM_GL_webservice.parentDistributorId);
            //System.assertEquals(false, obj.isUserExist(obj.newCon.Email));
            PageReference pgRef = obj.send();    
            /* Need To check these aserts in UAT - because of validation rule that eds can not be created before qsol
            * it can fail in UAT */
            //System.assertEquals(false, obj.errordiv);
            //System.assertEquals(true, pgRef != null);
        Test.stopTest();
    }
    
    /* EDS Registration - Existing Account (With Account Access Subscriton available for existing account) */
    static testmethod void edsExiAccRegWithAccAcessTest() {
        PageReference pg = Page.IAM_NewRegistration;        
        Test.setCurrentPage(pg);
        App_Mapping__c app = IAM_TestData.getEDSApp();
        IAM_TestData.create_IAM_EDQ_oAuth_CS();
        IAM_TestData.create_IAM_GL_Service_CS();
        ApexPages.currentPage().getParameters().put('appid',app.Id);
        ApexPages.StandardController sc = new ApexPages.StandardController(new Account());
        IAM_NewAccountRegistration obj = new IAM_NewAccountRegistration(sc);
        Account existingAcc = getAccount();
        insert existingAcc; 
        
        Contact existingCon = getContact();
        existingCon.AccountId = existingAcc.Id;
        existingCon.Email = 'tef56st1kr@abc.com'; 
        existingCon.Username__c = 'tef56st1kr1@abc.com.iamdev';
        existingCon.CMI_Contact_Type__c = 'Primary';
        existingCon.IAM_Contact_Status__c = 'Active'; 
        existingCon.RecordtypeId=Schema.SObjectType.contact.getRecordTypeInfosByName().get('IAM').getRecordTypeId();       
        insert existingCon;  
        
        /* before EDS there is a need to create QSOL account subscription*/
        IAM_Application__c accAccessQSOLObj = IAM_TestData.createAccountSubscription(existingAcc.Id, 'QuickServe Online', 'QSOL LOP');
        IAM_Application__c accAccessObj = IAM_TestData.createAccountSubscription(existingAcc.Id, app.Name, app.IAM_Default_Role__c);

        obj.acc = getAccount();
        obj.newCon = getContact();        
                
        String responseBodyEdqInfo = getEDQResBody('Y');
        Test.setMock(HttpCalloutMock.class, new IAM_SingleRequestMock(200, 'Success', responseBodyEdqInfo, null));
        IAM_EDQ_LocationResParser resp = IAM_EDQ_AddressCleanse.EDQAddress(getAccount());
        Account parentAcc = createParentAccount();
        System.debug('### Test Class 1 - ');
        Test.startTest();
            obj.EDQAddress();
            
            //System.assertEquals(true, obj.EDQpop);
            obj.input = '' + obj.getChar1() + obj.getChar2() + obj.getChar3() + obj.getChar4() + obj.getChar5() + obj.getChar6();     
            //System.assertEquals(true, obj.isCaptchaValid());
            
            String responseBodyGLService = getGLResBody(parentAcc.IAM_Service_Provider_Code__c, parentAcc.IAM_Service_Provider_Code__c);
            Test.setMock(HttpCalloutMock.class, new IAM_SingleRequestMock(200, 'Success', responseBodyGLService, null));
            
            Account acc = obj.acc;
            IAM_GL_webservice.makeCallout(acc.billingStreet, acc.BillingCity, acc.BillingCountry, acc.BillingPostalCode);        
            //System.assertEquals(parentAcc.Id, IAM_GL_webservice.parentDistributorId);
            //System.assertEquals(false, obj.isUserExist(obj.newCon.Email));
            PageReference pgRef = obj.send();    
            //System.assertEquals(true, obj.errordiv);
            //System.assertEquals(true, pgRef == null);
        Test.stopTest();
    }
    
    /* EDS Registration - Existing Account (With Account Access Subscriton and Primary Contact
    * available for existing account) */
    static testmethod void edsExiAccRegWithAccAcNContactTest() {
        PageReference pg = Page.IAM_NewRegistration;        
        Test.setCurrentPage(pg);
        App_Mapping__c app = IAM_TestData.getEDSApp();
        IAM_TestData.create_IAM_EDQ_oAuth_CS();
        IAM_TestData.create_IAM_GL_Service_CS();
        ApexPages.currentPage().getParameters().put('appid',app.Id);
        ApexPages.StandardController sc = new ApexPages.StandardController(new Account());
        IAM_NewAccountRegistration obj = new IAM_NewAccountRegistration(sc);
        Account existingAcc = getAccount();
        insert existingAcc;        
        
        
        
        Contact existingCon = getContact();
        existingCon.AccountId = existingAcc.Id;
        existingCon.Email = 'tef56st1@abc.com'; 
        existingCon.Username__c = 'tef56st1@abc.com.iamdev';
        existingCon.CMI_Contact_Type__c = 'Primary';
        existingCon.IAM_Contact_Status__c = 'Active';        
        insert existingCon;       
        
        List<Contact> conList = new List<Contact>();
        conList.add(existingCon);
        //IAM_CreateUser.CreateUser(conList);  
        
        /* before EDS there is a need to create QSOL account subscription*/
        IAM_Application__c accAccessQSOLObj = IAM_TestData.createAccountSubscription(existingAcc.Id, 'QuickServe Online', 'QSOL LOP');
       IAM_Application__c accAccessObj = IAM_TestData.createAccountSubscription(existingAcc.Id, app.Name, app.IAM_Default_Role__c);
        
        obj.acc = getAccount();
        obj.newCon = getContact();        
                
        String responseBodyEdqInfo = getEDQResBody('Y');
        Test.setMock(HttpCalloutMock.class, new IAM_SingleRequestMock(200, 'Success', responseBodyEdqInfo, null));
        IAM_EDQ_LocationResParser resp = IAM_EDQ_AddressCleanse.EDQAddress(getAccount());
        Account parentAcc = createParentAccount();
        System.debug('### Test Class 1 - ');
        Test.startTest();
            obj.EDQAddress();
            //System.assertEquals(true, obj.EDQpop);
            obj.input = '' + obj.getChar1() + obj.getChar2() + obj.getChar3() + obj.getChar4() + obj.getChar5() + obj.getChar6();     
            //System.assertEquals(true, obj.isCaptchaValid());
            
            String responseBodyGLService = getGLResBody(parentAcc.IAM_Service_Provider_Code__c, parentAcc.IAM_Service_Provider_Code__c);
            Test.setMock(HttpCalloutMock.class, new IAM_SingleRequestMock(200, 'Success', responseBodyGLService, null));
            
            Account acc = obj.acc;
            IAM_GL_webservice.makeCallout(acc.billingStreet, acc.BillingCity, acc.BillingCountry, acc.BillingPostalCode);        
            //System.assertEquals(parentAcc.Id, IAM_GL_webservice.parentDistributorId);
            //System.assertEquals(false, obj.isUserExist(obj.newCon.Email));
            PageReference pgRef = obj.send();      
           // System.assertEquals(true, obj.errordiv);
            //System.assertEquals(true, pgRef == null);
        Test.stopTest();
    }
    
    /* EDS Registration - Existing Account (No Account Access Subscriton and Primary Contact
    * available for existing account) */
    static testmethod void edsExiAccRegNoAccAcessTest() {
        PageReference pg = Page.IAM_NewRegistration;        
        Test.setCurrentPage(pg);
        App_Mapping__c app = IAM_TestData.getEDSApp();
        IAM_TestData.create_IAM_EDQ_oAuth_CS();
        IAM_TestData.create_IAM_GL_Service_CS();
        ApexPages.currentPage().getParameters().put('appid',app.Id);
        ApexPages.StandardController sc = new ApexPages.StandardController(new Account());
        IAM_NewAccountRegistration obj = new IAM_NewAccountRegistration(sc);
        Account existingAcc = getAccount();
        insert existingAcc;         
        
        obj.acc = getAccount();
        obj.newCon = getContact();        
                
        String responseBodyEdqInfo = getEDQResBody('Y');
        Test.setMock(HttpCalloutMock.class, new IAM_SingleRequestMock(200, 'Success', responseBodyEdqInfo, null));
        IAM_EDQ_LocationResParser resp = IAM_EDQ_AddressCleanse.EDQAddress(getAccount());
        Account parentAcc = createParentAccount();
        System.debug('### Test Class 1 - ');
        Test.startTest();
            obj.EDQAddress();
            //System.assertEquals(true, obj.EDQpop);
            obj.input = '' + obj.getChar1() + obj.getChar2() + obj.getChar3() + obj.getChar4() + obj.getChar5() + obj.getChar6();     
            //System.assertEquals(true, obj.isCaptchaValid());
            
            String responseBodyGLService = getGLResBody(parentAcc.IAM_Service_Provider_Code__c, parentAcc.IAM_Service_Provider_Code__c);
            Test.setMock(HttpCalloutMock.class, new IAM_SingleRequestMock(200, 'Success', responseBodyGLService, null));
            
            Account acc = obj.acc;
            IAM_GL_webservice.makeCallout(acc.billingStreet, acc.BillingCity, acc.BillingCountry, acc.BillingPostalCode);        
            //System.assertEquals(parentAcc.Id, IAM_GL_webservice.parentDistributorId);
            //System.assertEquals(false, obj.isUserExist(obj.newCon.Email));
            PageReference pgRef = obj.send();
            //System.assertEquals(false, obj.errordiv);
            //System.assertEquals(true, pgRef != null);
        Test.stopTest();
    }
    
    /* EDS Registration - Existing Account (No Account Access Subscriton but Primary Contact
    * available for existing account) */
    static testmethod void edsExiAccRegNoAccAcNContactTest() {
        PageReference pg = Page.IAM_NewRegistration;        
        Test.setCurrentPage(pg);
        App_Mapping__c app = IAM_TestData.getEDSApp();
        IAM_TestData.create_IAM_EDQ_oAuth_CS();
        IAM_TestData.create_IAM_GL_Service_CS();
        ApexPages.currentPage().getParameters().put('appid',app.Id);
        ApexPages.StandardController sc = new ApexPages.StandardController(new Account());
        IAM_NewAccountRegistration obj = new IAM_NewAccountRegistration(sc);
        Account existingAcc = getAccount();
        insert existingAcc; 
        
        
        Contact existingCon = getContact();
        existingCon.AccountId = existingAcc.Id;
        existingCon.Email = 'tef56st1@abc.com'; 
        existingCon.Username__c = 'tef56st1@abc.com.iamdev';
        existingCon.CMI_Contact_Type__c = 'Primary';
        existingCon.IAM_Contact_Status__c = 'Active';        
        insert existingCon;       
        
        List<Contact> conList = new List<Contact>();
        conList.add(existingCon);
        //IAM_CreateUser.CreateUser(conList);  
        
         /* before EDS there is a need to create QSOL account subscription*/
        IAM_Application__c accAccessQSOLObj = IAM_TestData.createAccountSubscription(existingAcc.Id, 'QuickServe Online', 'QSOL LOP');
        
        obj.acc = getAccount();
        obj.newCon = getContact();        
                
        String responseBodyEdqInfo = getEDQResBody('Y');
        Test.setMock(HttpCalloutMock.class, new IAM_SingleRequestMock(200, 'Success', responseBodyEdqInfo, null));
        IAM_EDQ_LocationResParser resp = IAM_EDQ_AddressCleanse.EDQAddress(getAccount());
        Account parentAcc = createParentAccount();
        System.debug('### Test Class 1 - ');
        Test.startTest();
            obj.EDQAddress();
            //System.assertEquals(true, obj.EDQpop);
            obj.input = '' + obj.getChar1() + obj.getChar2() + obj.getChar3() + obj.getChar4() + obj.getChar5() + obj.getChar6();     
            //System.assertEquals(true, obj.isCaptchaValid());
            
            String responseBodyGLService = getGLResBody(parentAcc.IAM_Service_Provider_Code__c, parentAcc.IAM_Service_Provider_Code__c);
            Test.setMock(HttpCalloutMock.class, new IAM_SingleRequestMock(200, 'Success', responseBodyGLService, null));
            
            Account acc = obj.acc;
            IAM_GL_webservice.makeCallout(acc.billingStreet, acc.BillingCity, acc.BillingCountry, acc.BillingPostalCode);        
            //System.assertEquals(parentAcc.Id, IAM_GL_webservice.parentDistributorId);
            //System.assertEquals(false, obj.isUserExist(obj.newCon.Email));
            PageReference pgRef = obj.send();    
           // System.assertEquals(false, obj.errordiv);
            //System.assertEquals(true, pgRef != null);
        Test.stopTest();
    }
    
    /* Initialization test */
    static testmethod void initializationTest() {
        PageReference pg = Page.IAM_NewRegistration;        
        Test.setCurrentPage(pg);
        App_Mapping__c app = IAM_TestData.getCumpasApp();
        ApexPages.currentPage().getParameters().put('appid',app.Id);
        ApexPages.StandardController sc = new ApexPages.StandardController(new Account());
        IAM_NewAccountRegistration obj = new IAM_NewAccountRegistration(sc);    
        Test.startTest();
        obj.getsiteadminval();
        obj.setsiteadminval('');
        obj.regionerror = '';
        obj.errorAccountName = '';
        obj.errormarket = '';
        obj.IsConAlreadyExist = false;
        obj.IsConExitForDiffAcc = false;
        obj.errorContactPhone = '';
        obj.errorPostalcode = '';
        obj.errorAddress = '';
        obj.errorCity = '';
        obj.errorccfname = '';
        obj.errorothertsp = '';
        obj.errorccemail = '';
        obj.errorcclname = '';
        obj.errorContactFirstName = '';
        obj.errorContactLastName = '';
        obj.errorContactEmail = '';
        obj.errorContactEmail1 = '';
        obj.errorStateerror = '';
        obj.errorStateCountry = '';
        obj.errorContactEmail2 = '';
        obj.ins = false;
        obj.upd = false;
        obj.emailerrorstatus = '';
        obj.EDQAddressType = '';
        obj.SelectedAddress = '';
        obj.errorRswReason = '';
        Test.stopTest();
    }
    
    /* Reset button test */
    static testmethod void resetButtonTest() {
        PageReference pg = Page.IAM_NewRegistration;        
        Test.setCurrentPage(pg);
        App_Mapping__c app = IAM_TestData.getCumpasApp();
        ApexPages.currentPage().getParameters().put('appid',app.Id);
        ApexPages.StandardController sc = new ApexPages.StandardController(new Account());
        IAM_NewAccountRegistration obj = new IAM_NewAccountRegistration(sc);
        obj.acc = getAccount();
        obj.newCon = getContact();   
       
        //System.assertEquals('Test Account', obj.acc.Name);
        //System.assertEquals('Fname', obj.newCon.FirstName);
        Test.startTest();
        PageReference pgRef = obj.BusinessTabreset();
        Test.setCurrentPage(pgRef);
        //System.assertEquals(true, pgRef != null);
        Test.stopTest();
    }
    
    /* Maeketplace Registration - New Account */
    static testmethod void marketplaceNewAccRegistrationTest() {
        PageReference pg = Page.IAM_NewRegistration;        
        Test.setCurrentPage(pg);
        App_Mapping__c app = IAM_TestData.getMarketplaceApp();
        IAM_TestData.create_IAM_EDQ_oAuth_CS();
        IAM_TestData.create_IAM_GL_Service_CS();
        ApexPages.currentPage().getParameters().put('appid',app.Id);
        ApexPages.StandardController sc = new ApexPages.StandardController(new Account());
        IAM_NewAccountRegistration obj = new IAM_NewAccountRegistration(sc);
        obj.selectOnClick();
        obj.getAnswers();
        obj.isRepairEngine = Label.IAM_Yes_Label;
        obj.fetchAnswerOne();
        obj.isOwnVehicle = Label.IAM_No_Label;
        obj.fetchAnswerTwo();
        obj.acc = getAccount();
        obj.newCon = getContact();        
                
        String responseBodyEdqInfo = getEDQResBody('Y');
        Test.setMock(HttpCalloutMock.class, new IAM_SingleRequestMock(200, 'Success', responseBodyEdqInfo, null));
        IAM_EDQ_LocationResParser resp = IAM_EDQ_AddressCleanse.EDQAddress(getAccount());
        Account parentAcc = createParentAccount();
        System.debug('### Test Class 1 - ');
        Test.startTest();
            obj.EDQAddress();
            //System.assertEquals(true, obj.EDQpop);
            obj.input = '' + obj.getChar1() + obj.getChar2() + obj.getChar3() + obj.getChar4() + obj.getChar5() + obj.getChar6();     
            //System.assertEquals(true, obj.isCaptchaValid());
            
            String responseBodyGLService = getGLResBody(parentAcc.IAM_Service_Provider_Code__c, parentAcc.IAM_Service_Provider_Code__c);
            Test.setMock(HttpCalloutMock.class, new IAM_SingleRequestMock(200, 'Success', responseBodyGLService, null));
            
            Account acc = obj.acc;
            IAM_GL_webservice.makeCallout(acc.billingStreet, acc.BillingCity, acc.BillingCountry, acc.BillingPostalCode);        
            //System.assertEquals(parentAcc.Id, IAM_GL_webservice.parentDistributorId);
            //System.assertEquals(false, obj.isUserExist(obj.newCon.Email));
            PageReference pgRef = obj.send();
            //System.assertEquals(true, obj.errordiv);
            //System.assertEquals(true, pgRef == null);
        Test.stopTest();
    }
    
    /* IAM_Reclaim - Popup test */
    static testmethod void recliamPopupTest() {
        PageReference pg = Page.IAM_Reclaim;        
        Test.setCurrentPage(pg);
        App_Mapping__c app = IAM_TestData.getCumpasApp();
        ApexPages.currentPage().getParameters().put('appid',app.Id);
        ApexPages.StandardController sc = new ApexPages.StandardController(new Account());
        IAM_NewAccountRegistration obj = new IAM_NewAccountRegistration(sc);
        obj.acc = getAccount();
        obj.newCon = getContact();
       
        Test.startTest();
            obj.closePopup_reclaim();           
            //System.assertEquals(false, obj.reclaimPopup);
        Test.stopTest();
    }   
    
    /* Reclaim Test */
    static testmethod void sendReclaimTest() {
        PageReference pg = Page.IAM_Reclaim;        
        Test.setCurrentPage(pg);
        App_Mapping__c app = IAM_TestData.getCumpasApp();
        IAM_TestData.create_IAM_EDQ_oAuth_CS();
        IAM_TestData.create_IAM_GL_Service_CS();
        ApexPages.currentPage().getParameters().put('appid',app.Id);
        ApexPages.StandardController sc = new ApexPages.StandardController(new Account());
        IAM_NewAccountRegistration obj = new IAM_NewAccountRegistration(sc);
        Account existingAcc = getAccount();
        
        insert existingAcc;
        
        IAM_Application__c accAccessObj = IAM_TestData.createAccountSubscription(existingAcc.Id, app.Name, app.IAM_Default_Role__c);
        
        Contact existingCon = getContact();
        existingCon.AccountId = existingAcc.Id;
        existingCon.Email = 'tef56st1@abc.com'; 
        existingCon.Username__c = 'tef56st1@abc.com.iamdev';
        existingCon.CMI_Contact_Type__c = 'Primary';
        existingCon.IAM_Contact_Status__c = 'Reclaim';        
        insert existingCon;
        
        obj.acc = getAccount();
        //obj.newCon = getContact();
        obj.newCon = existingCon;
        
        Test.startTest();
        PageReference pgRef = obj.send_reclaim();
        //System.assert(!obj.isExistingUser(obj.newCon.Username__c, obj.newCon.Id));
        //System.assertEquals(true, obj.errordiv);
        //System.assertEquals(true, pgRef == null);
        Test.stopTest();
    }
    
    /* Dup Account Selection Test */
    static testmethod void dupAccountSelectionTest() {
        PageReference pg = Page.IAM_NewRegistration;        
        Test.setCurrentPage(pg);
        App_Mapping__c app = IAM_TestData.getCumpasApp();
        IAM_TestData.create_IAM_EDQ_oAuth_CS();
        IAM_TestData.create_IAM_GL_Service_CS();
        ApexPages.currentPage().getParameters().put('appid',app.Id);
        ApexPages.StandardController sc = new ApexPages.StandardController(new Account());
        IAM_NewAccountRegistration obj = new IAM_NewAccountRegistration(sc);
        Account existingAcc = getAccount();
        
        insert existingAcc;
        
        Contact existingCon = getContact();
        existingCon.AccountId = existingAcc.Id;
        existingCon.Email = 'tef56st1@abcd.com'; 
        existingCon.Username__c = 'tef56st1@abcd.com.iamdev';
        existingCon.CMI_Contact_Type__c = 'Primary';
        existingCon.IAM_Contact_Status__c = 'Reclaim';        
        insert existingCon;
        
        obj.acc = getAccount();
        //obj.newCon = getContact();
        obj.newCon = existingCon;        
                
        String responseBodyEdqInfo = getEDQResBody('Y');
        Test.setMock(HttpCalloutMock.class, new IAM_SingleRequestMock(200, 'Success', responseBodyEdqInfo, null));
        IAM_EDQ_LocationResParser resp = IAM_EDQ_AddressCleanse.EDQAddress(getAccount());
        Account parentAcc = createParentAccount();
        System.debug('### Test Class 1 - ');
        Test.startTest();
            obj.EDQAddress();
            IAM_NewAccountRegistration.validateUserName('testusername@gmail.com');
            obj.EDQCityR='R';
            obj.EDQStreetR='Street';
            obj.EDQStreet2R='Semi';
            obj.EDQStateR='StateR';
            obj.EDQCountryR='CountryR';
            obj.occupationlist='occupationlist';
            obj.EDQzipR='12312';
            obj.EDQAddressSelectcon();
            obj.isOSMEnabled('23455');
            obj.getDistributorInfoPage(app.id,obj.Acc.id);
            obj.erroroccupationlist='No Occupation';
            obj.isPrimaryContactExist(existingAcc.id);
            obj.send_reclaim_poc();
            //obj.send_reclaim_poc();
            //System.assertEquals(true, obj.EDQpop);
            obj.input = '' + obj.getChar1() + obj.getChar2() + obj.getChar3() + obj.getChar4() + obj.getChar5() + obj.getChar6();     
            //System.assertEquals(true, obj.isCaptchaValid());
            
            String responseBodyGLService = getGLResBody(parentAcc.IAM_Service_Provider_Code__c, parentAcc.IAM_Service_Provider_Code__c);
            Test.setMock(HttpCalloutMock.class, new IAM_SingleRequestMock(200, 'Success', responseBodyGLService, null));
            
            Account acc = obj.acc;
            IAM_GL_webservice.makeCallout(acc.billingStreet, acc.BillingCity, acc.BillingCountry, acc.BillingPostalCode);        
            //System.assertEquals(parentAcc.Id, IAM_GL_webservice.parentDistributorId);
            //System.assertEquals(false, obj.isUserExist(obj.newCon.Email));
            ApexPages.currentPage().getParameters().put('accountID',existingAcc.Id);
            PageReference pgRef = obj.dupAccountSelection();            
            //System.assertEquals(true, pgRef != null);
        Test.stopTest();
    } 
    static testmethod void OSMNewAccRegistrationTest1() {
        PageReference pg = Page.IAM_NewRegistration;        
        Test.setCurrentPage(pg);
        App_Mapping__c app = IAM_TestData.getMarketplaceApp();
        IAM_TestData.create_IAM_EDQ_oAuth_CS();
        IAM_TestData.create_IAM_GL_Service_CS();
        ApexPages.currentPage().getParameters().put('appid',app.Id);
        ApexPages.StandardController sc = new ApexPages.StandardController(new Account());
        IAM_NewAccountRegistration obj = new IAM_NewAccountRegistration(sc);
        obj.acc = getAccount();
        //obj.acc.IAM_Primary_Market_Segment__c = 'Mining';
        //obj.acc.CMI_Telematics_Service_Provider__c = 'zonar';
        obj.newCon = getContact();        
                
        String responseBodyEdqInfo = getEDQResBody('Y');
        Test.setMock(HttpCalloutMock.class, new IAM_SingleRequestMock(200, 'Success', responseBodyEdqInfo, null));
        IAM_EDQ_LocationResParser resp = IAM_EDQ_AddressCleanse.EDQAddress(getAccount());
        Account parentAcc = createParentAccount();
        System.debug('### Test Class 1 - ');
        Test.startTest();
            obj.EDQAddress();
            //System.assertEquals(true, obj.EDQpop);
            obj.input = '' + obj.getChar1() + obj.getChar2() + obj.getChar3() + obj.getChar4() + obj.getChar5() + obj.getChar6();     
            //System.assertEquals(true, obj.isCaptchaValid());
            
            String responseBodyGLService = getGLResBody(parentAcc.IAM_Service_Provider_Code__c, parentAcc.IAM_Service_Provider_Code__c);
            Test.setMock(HttpCalloutMock.class, new IAM_SingleRequestMock(200, 'Success', responseBodyGLService, null));
            
            Account acc = obj.acc;
            IAM_GL_webservice.makeCallout(acc.billingStreet, acc.BillingCity, acc.BillingCountry, acc.BillingPostalCode);        
            //System.assertEquals(parentAcc.Id, IAM_GL_webservice.parentDistributorId);
            //System.assertEquals(false, obj.isUserExist(obj.newCon.Email));
            PageReference pgRef = obj.send();           
            //System.assertEquals(false, obj.errordiv);
            //System.assertEquals(true, pgRef != null);
        Test.stopTest();
    } 
    //added to increase test coverage
    static testmethod void testNewAccRegConst() {
        PageReference pg = Page.IAM_NewRegistration;        
        Test.setCurrentPage(pg);
        App_Mapping__c app = IAM_TestData.getMarketplaceApp();
        Account accts = getAccount();
        insert accts;
        Contact conts = getContact();
        conts.AccountId = accts.Id;
        conts.Email = 'tef56st1@abc.com'; 
        conts.Username__c = 'tef56st1@abc.com.iamdev';
        conts.CMI_Contact_Type__c = 'Primary';
        conts.IAM_Contact_Status__c = 'Active';        
        insert conts; 
        
        IAM_TestData.create_IAM_EDQ_oAuth_CS();
        IAM_TestData.create_IAM_GL_Service_CS();
        ApexPages.currentPage().getParameters().put('appid',app.Id);
        ApexPages.currentPage().getParameters().put('id',accts.Id);
        ApexPages.currentPage().getParameters().put('cid',conts.Id);
        ApexPages.StandardController sc = new ApexPages.StandardController(new Account());
        ApexPages.StandardController sc1 = new ApexPages.StandardController(new Contact());
        IAM_NewAccountRegistration obj = new IAM_NewAccountRegistration(sc);
        IAM_NewAccountRegistration obj1 = new IAM_NewAccountRegistration(sc1);
        obj.acc = getAccount();
        //obj.acc.IAM_Primary_Market_Segment__c = 'Mining';
        //obj.acc.CMI_Telematics_Service_Provider__c = 'zonar';
        obj.newCon = getContact();        
                
    }
	/*Added to increase test coverage*/
    static testmethod void fluidwatchtestmethod()
    {
        Account acc = new Account();
        acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('IAM').getRecordTypeId();
        acc.name = 'OSM subtest class1';
        acc.IAM_Service_Provider_Code__c = '99201';
        acc.BillingCountryCode = 'CA';
        acc.CMI_Address2__c = '';
        acc.BillingStreet = '391 MCALLISTER DR'; 
        acc.BillingCity = 'Fredericton';
        acc.BillingCountry='Canada';
        acc.BillingStateCode = 'NB';
        acc.BillingPostalCode = 'E2C 1E7';
        acc.BillingState='New Brunswick';
        acc.CSS_DistributorCode__c='99201';
        acc.Type = 'Distributor Account';
        insert acc;
        
        Contact con = new contact();
        con.RecordTypeId = Schema.SObjectType.contact.getRecordTypeInfosByName().get('IAM').getRecordTypeId();
        con.FirstName = 'Fnamet';
        con.LastName = 'Lnamet';
        con.Email = 'fnamelnamet@test.com';
        con.Username__c = 'fnamelnamet@test.com';
        con.phone = '1012023035';
        con.IAM_Contact_Status__c = 'Active';
        con.CMI_Contact_Type__c = 'Secondary';
        insert con;
        
        test.startTest();
        IAM_NewAccountRegistration.createosmSubscrptionForFluiwatch(acc.Id, con.Id);
        test.stopTest();
        
    }
    /* Guidanz Service Portal Test without Account Feature Access */
    static testmethod void guiServicePortalTest1() {
        PageReference pg = Page.IAM_NewRegistration;        
        Test.setCurrentPage(pg);
        IAM_TestData.create_IAM_EDQ_oAuth_CS();
        IAM_TestData.create_IAM_GL_Service_CS();
        App_Mapping__c app = IAM_TestData.getGuiServicePortalApp();
        Account accFSL = IAM_TestData.createAccountWithFSLCustomerCode();
        Contact con = IAM_TestData.createContact(accFSL.Id);
        
        ApexPages.currentPage().getParameters().put('appid',app.Id);
        ApexPages.StandardController sc = new ApexPages.StandardController(new Account());
        IAM_NewAccountRegistration obj = new IAM_NewAccountRegistration(sc);
        
        obj.acc = getAccountWithFSLERPCode();
        obj.newCon = getContact();
        obj.erpCustomerCode='123456';
        String responseBodyEdqInfo = getEDQResBody('Y');
        Test.setMock(HttpCalloutMock.class, new IAM_SingleRequestMock(200, 'Success', responseBodyEdqInfo, null));
        IAM_EDQ_LocationResParser resp = IAM_EDQ_AddressCleanse.EDQAddress(getAccount());
        Account parentAcc = createParentAccount();
        Test.startTest();
            obj.EDQAddress();
            obj.input = '' + obj.getChar1() + obj.getChar2() + obj.getChar3() + obj.getChar4() + obj.getChar5() + obj.getChar6();     
            String responseBodyGLService = getGLResBody(parentAcc.IAM_Service_Provider_Code__c, parentAcc.IAM_Service_Provider_Code__c);
            Test.setMock(HttpCalloutMock.class, new IAM_SingleRequestMock(200, 'Success', responseBodyGLService, null));
            Account acc = obj.acc;
            IAM_GL_webservice.makeCallout(acc.billingStreet, acc.BillingCity, acc.BillingCountry, acc.BillingPostalCode);        
            PageReference pgRef = obj.send();
        Test.stopTest();
    }

    /* Guidanz Service Portal Test with Account Feature Access */
    static testmethod void guiServicePortalTest2() {
        PageReference pg = Page.IAM_NewRegistration;        
        Test.setCurrentPage(pg);
        IAM_TestData.create_IAM_EDQ_oAuth_CS();
        IAM_TestData.create_IAM_GL_Service_CS();
        App_Mapping__c app = IAM_TestData.getGuiServicePortalApp();
        Account accFSL = IAM_TestData.createAccountWithFSLCustomerCode();
        Contact con = IAM_TestData.createContact(accFSL.Id);
        IAM_Application__c accApp = IAM_TestData.createAccountSubscription(accFSL.Id, Label.IAM_AppName_GuidanzServicePortal,
        'General User', con);
        ApexPages.currentPage().getParameters().put('appid',app.Id);
        ApexPages.StandardController sc = new ApexPages.StandardController(new Account());
        IAM_NewAccountRegistration obj = new IAM_NewAccountRegistration(sc);
        
        obj.acc = getAccountWithFSLERPCode();
        obj.newCon = getContact();
        obj.erpCustomerCode='123456';
        String responseBodyEdqInfo = getEDQResBody('Y');
        Test.setMock(HttpCalloutMock.class, new IAM_SingleRequestMock(200, 'Success', responseBodyEdqInfo, null));
        IAM_EDQ_LocationResParser resp = IAM_EDQ_AddressCleanse.EDQAddress(getAccount());
        Account parentAcc = createParentAccount();
        Test.startTest();
            obj.EDQAddress();
            obj.input = '' + obj.getChar1() + obj.getChar2() + obj.getChar3() + obj.getChar4() + obj.getChar5() + obj.getChar6();     
            String responseBodyGLService = getGLResBody(parentAcc.IAM_Service_Provider_Code__c, parentAcc.IAM_Service_Provider_Code__c);
            Test.setMock(HttpCalloutMock.class, new IAM_SingleRequestMock(200, 'Success', responseBodyGLService, null));
            Account acc = obj.acc;
            IAM_GL_webservice.makeCallout(acc.billingStreet, acc.BillingCity, acc.BillingCountry, acc.BillingPostalCode);        
            PageReference pgRef = obj.send();
        Test.stopTest();
    }

    /* Guidanz Service Portal Test without existing Contact */
    static testmethod void guiServicePortalTest3() {
        PageReference pg = Page.IAM_NewRegistration;        
        Test.setCurrentPage(pg);
        IAM_TestData.create_IAM_EDQ_oAuth_CS();
        IAM_TestData.create_IAM_GL_Service_CS();
        App_Mapping__c app = IAM_TestData.getGuiServicePortalApp();
        Account accFSL = IAM_TestData.createAccountWithFSLCustomerCode();
        
        ApexPages.currentPage().getParameters().put('appid',app.Id);
        ApexPages.StandardController sc = new ApexPages.StandardController(new Account());
        IAM_NewAccountRegistration obj = new IAM_NewAccountRegistration(sc);
        
        obj.acc = getAccountWithFSLERPCode();
        obj.newCon = getContact();
        obj.erpCustomerCode='123456';
        String responseBodyEdqInfo = getEDQResBody('Y');
        Test.setMock(HttpCalloutMock.class, new IAM_SingleRequestMock(200, 'Success', responseBodyEdqInfo, null));
        IAM_EDQ_LocationResParser resp = IAM_EDQ_AddressCleanse.EDQAddress(getAccount());
        Account parentAcc = createParentAccount();
        Test.startTest();
            obj.EDQAddress();
            obj.input = '' + obj.getChar1() + obj.getChar2() + obj.getChar3() + obj.getChar4() + obj.getChar5() + obj.getChar6();     
            String responseBodyGLService = getGLResBody(parentAcc.IAM_Service_Provider_Code__c, parentAcc.IAM_Service_Provider_Code__c);
            Test.setMock(HttpCalloutMock.class, new IAM_SingleRequestMock(200, 'Success', responseBodyGLService, null));
            Account acc = obj.acc;
            IAM_GL_webservice.makeCallout(acc.billingStreet, acc.BillingCity, acc.BillingCountry, acc.BillingPostalCode);        
            PageReference pgRef = obj.send();
        Test.stopTest();
    }

    /* Guidanz Service Portal Test without existing Account  */
    static testmethod void guiServicePortalTest4() {
        PageReference pg = Page.IAM_NewRegistration;        
        Test.setCurrentPage(pg);
        IAM_TestData.create_IAM_EDQ_oAuth_CS();
        IAM_TestData.create_IAM_GL_Service_CS();
        App_Mapping__c app = IAM_TestData.getGuiServicePortalApp();
        
        ApexPages.currentPage().getParameters().put('appid',app.Id);
        ApexPages.StandardController sc = new ApexPages.StandardController(new Account());
        IAM_NewAccountRegistration obj = new IAM_NewAccountRegistration(sc);
        
        obj.acc = getAccountWithFSLERPCode();
        obj.newCon = getContact();
        obj.erpCustomerCode='123456';
        String responseBodyEdqInfo = getEDQResBody('Y');
        Test.setMock(HttpCalloutMock.class, new IAM_SingleRequestMock(200, 'Success', responseBodyEdqInfo, null));
        IAM_EDQ_LocationResParser resp = IAM_EDQ_AddressCleanse.EDQAddress(getAccount());
        Account parentAcc = createParentAccount();
        Test.startTest();
            obj.EDQAddress();
            obj.input = '' + obj.getChar1() + obj.getChar2() + obj.getChar3() + obj.getChar4() + obj.getChar5() + obj.getChar6();     
            String responseBodyGLService = getGLResBody(parentAcc.IAM_Service_Provider_Code__c, parentAcc.IAM_Service_Provider_Code__c);
            Test.setMock(HttpCalloutMock.class, new IAM_SingleRequestMock(200, 'Success', responseBodyGLService, null));
            Account acc = obj.acc;
            IAM_GL_webservice.makeCallout(acc.billingStreet, acc.BillingCity, acc.BillingCountry, acc.BillingPostalCode);        
            PageReference pgRef = obj.send();
        Test.stopTest();
    }

    /* Return test account data */
    private static Account getAccountWithFSLERPCode() {
        Account acc = new Account();
        acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Guidanz').getRecordTypeId();
        acc.name = 'Test Account';
        acc.BillingCountryCode = 'CA';
        acc.CMI_Address2__c = '';
        acc.BillingStreet = '351 MCALLISTER DR'; 
        acc.BillingCity = 'SAINT JOHN';
        acc.BillingCountry='Canada';
        acc.BillingStateCode = 'NB';
        acc.BillingPostalCode = 'E2J 2S8';
        acc.BillingState='New Brunswick';        

        acc.CSS_DistributorCode__c='1234';
        acc.CSS_DealerCode__c='test';
        
        acc.Type = 'Dealer Account';
        acc.IAM_Service_Provider_Code__c = '2345';
        
        acc.CSS_Locale__c = 'English(United States)';
        acc.CSS_Language__c = 'English';
        acc.CSS_Timezone__c = '(GMT-05:00) Eastern Standard Time (America/Panama)';
        acc.FSL_ERP_Customer_Code__c = '123456';
        return acc;
    }
}