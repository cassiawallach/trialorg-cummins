/************************************************************
Name:  IAM_partnerJITImplementation_Test
Copyright © 2019  Cummins
=============================================================
=============================================================
Purpose:
This is test class for IAM_PartnerJITImplementation class.                                                            
This Main class provides logic for inbound just-in-time provisioning of single sign-on users in your Salesforce organization.                         
=============================================================
=============================================================
History                                                            
-------                                                            
VERSION       AUTHOR                      DATE               DETAIL                                
1.0 -    Karthik Raj Golakaram          1/16/2020        INITIAL DEVELOPMENT
2.0 -    Souvik Lahiri                  7/28/2022        Added changes for 
*****************************************************/

@isTest
public with sharing class IAM_partnerJITImplementation_Test {
   
    public Static String samlSSOproviderId='0LE1F0000000ALu';
    public Static String communityId='0DM610000008sC7';
    public Static String portalId='06061000000Pdeo';
    public static String assertion='134dsafdsfdagadfg';
    public Static Map<integer,string> monthToMonthNameMap=new Map<Integer,String>{1=>'JAN',2=>'FEB',3=>'MAR',4=>'APR',5=>'MAY',6=>'JUN',7=>'JUL',8=>'AUG',9=>'SEP',10=>'OCT',11=>'NOV',12=>'DEC'};
    
    
   
    @TestSetup
       static void testData(){
        Account acnt= new Account();
        acnt.Name='Test Partner Name';
        acnt.IAM_Service_Provider_Code__c = '1234453';
        acnt.IAM_Partner_Location_Code__c='12334';
        acnt.Type='CIHR';
        acnt.BillingState = 'Kashmir';
        acnt.BillingCity = 'Test City';
        acnt.BillingCountry = 'India';
        acnt.BillingStreet = '123 Test Street';
        acnt.BillingPostalCode = '123456';
        insert acnt;
        
        List<IAM_Application__c> iamApps= new List<IAM_Application__c>();
        
        IAM_Application__c qsol= new IAM_application__c();
        qsol.IAM_application_Name__c='QuickServe Online';
        qsol.IAM_Role__c='QSOL CIHR';
        qsol.IAM_Status__c='Active';
        qsol.IAM_Subscription_Start_Date__c=System.today();
        qsol.IAM_Subscription_End_Date__c=System.today().addDays(36500);
        qsol.IAM_Account_Name__c=acnt.id;
        qsol.IAM_Customer_Code__c=acnt.IAM_Service_Provider_Code__c;
        qsol.IAM_Free_Subscription__c=false;
        qsol.IAM_From_JIT_Execution__c=true;
        qsol.IAM_Subscription_Name__c='QuickServe Online EBU';
        qsol.IAM_Qsolexpiration__c=String.valueOf(qsol.IAM_Subscription_End_Date__c.day())+'-'+monthToMonthNameMap.get(qsol.IAM_Subscription_End_Date__c.month())+'-'+String.valueOf(qsol.IAM_Subscription_End_Date__c.year())+'EBUACTIVE';
        
        iamApps.add(qsol);
        
        IAM_Application__c cst= new IAM_application__c();
        cst.IAM_application_Name__c='Cummins Service Training';
        cst.IAM_Role__c='Service Training User';
        cst.IAM_Status__c='Active';
        cst.IAM_Subscription_Start_Date__c=System.today();
        cst.IAM_Subscription_End_Date__c=System.today().addDays(36500);
        cst.IAM_Account_Name__c=acnt.id;
        cst.IAM_Customer_Code__c=acnt.IAM_Service_Provider_Code__c;
        cst.IAM_Free_Subscription__c=false;
        cst.IAM_From_JIT_Execution__c=true;
        cst.IAM_Subscription_Name__c='Cummins Service Training';
        
        iamApps.add(cst);
        
        IAM_Application__c eds= new IAM_application__c();
        eds.IAM_application_Name__c='EDS';
        eds.IAM_Role__c='Technician';
        eds.IAM_Status__c='Active';
        eds.IAM_Subscription_Start_Date__c=System.today();
        eds.IAM_Subscription_End_Date__c=System.today().addDays(36500);
        eds.IAM_Account_Name__c=acnt.id;
        eds.IAM_Customer_Code__c=acnt.IAM_Service_Provider_Code__c;
        eds.IAM_Free_Subscription__c=false;
        eds.IAM_From_JIT_Execution__c=true;
        eds.IAM_Subscription_Name__c='QuickServe Online EBU';
        
        iamApps.add(eds);
        
        insert iamApps;
        
        Contact c=new Contact();
        c.FirstName='fname';
        c.LastName='LName';
        c.RecordTypeId=Schema.sObjectType.Contact.getRecordTypeInfosByName().get('IAM').getRecordtypeId();
        c.Username__c='56789098765';
        c.email='oh611@cummins.com';
        c.IAM_contact_Status__c='Active';
        c.IAM_LEgacy_User__c=True;
        c.Accountid=acnt.id;
        insert c;
        
        User u = new User(
                         ProfileId = [SELECT Id FROM Profile WHERE Name = 'IAM User'].Id,
                         LastName = 'last',
                         Email = 'puser000@amamama.com',
                         Username = 'puser000@amamama.com' + System.currentTimeMillis(),
                         CompanyName = 'TEST',
                         Title = 'title',
                         Alias = 'alias',
                         TimeZoneSidKey = 'America/Los_Angeles',
                         EmailEncodingKey = 'UTF-8',
                         LanguageLocaleKey = 'en_US',
                         LocaleSidKey = 'en_US',
                         FederationIdentifier='56789098765',
                         contactid=c.id
                    );
       insert u;
           
        List<IAM_Contact_Provisioning__c> conProvList = New List<IAM_Contact_Provisioning__c>();
        IAM_Contact_Provisioning__c conProv1 = new IAM_Contact_Provisioning__c();
        conProv1.IAM_Contact__c= c.Id; 
        conProv1.IAM_Start_Date__c = System.Today();
        conProv1.IAM_End_Date__c = System.Today() + 365;
        conProv1.IAM_Application_Name__c = 'QuickServe Online';
        conProv1.IAM_Role__c = 'QSOL CIHR';
        conProv1.IAM_Qsolexpiration__c = 'IAM-2020';
        conProv1.IAM_License_Type__c = 'Test';
        conProv1.IAM_Status__c = 'Active';
        conProv1.IAM_Account_Application__c = iamApps[0].Id;
        conProv1.IAM_Subscription_Name__c = 'QuickServe Online EBU';        
        conProv1.RecordtypeId = Schema.SObjectType.IAM_Contact_Provisioning__c.getRecordTypeInfosByName().get('QuickServe Online').getRecordTypeId();
        conProvList.add(conProv1);
        Test.startTest();
           insert conProvList;
        Test.stopTest();
    }
    
    
    static testMethod void createUser(){
        String federationIdentifier='5898989';
        Map<String,String> attributes=new Map<String,String>{'givenname'=>'TestUser','sn'=>'lastname','email'=>'testemail@gmail.com','uid'=>'5898989','location_num'=>'12334'};
        
        IAM_PartnerJITImplementation iamJit= new IAM_PartnerJITImplementation();
        Test.StartTest();
        iamJit.createUser(samlSSOproviderId,communityId,portalId,federationIdentifier,attributes,assertion);
        Test.StopTest();
    }
    
    Static testMethod void updateUser(){
        String federationIdentifier='56789098765';
        Map<String,String> attributes=new Map<String,String>{'givenname'=>'TestUser','sn'=>'lastname','email'=>'testemail@gmail.com','uid'=>'56789098765','location_num'=>'12334'};
        List<User> usr=[SELECT id FROM User WHERE FederationIdentifier='56789098765'];
        IAM_PartnerJITImplementation iamJit= new IAM_PartnerJITImplementation();
        Test.StartTest();
        iamJit.updateUser(usr[0].id,samlSSOproviderId,communityId,portalId,federationIdentifier,attributes,assertion);
        iamJit.handleAccountvalidation(false,usr[0],attributes);
        iamJit.assignPermissionSets(usr[0].id);
        Test.StopTest();
    }
    
    Static testMethod void createAccountAccessFeatures(){
    	Boolean bIsCumpasTrue = True;
        User usr=[SELECT id FROM User WHERE FederationIdentifier='56789098765'];
        Contact con=[SELECT id FROM Contact WHERE Username__c='56789098765'];
        Account acnt=[SELECT id,IAM_Service_Provider_Code__C FROM Account WHERE IAM_Service_Provider_Code__C='1234453'];
        Map<String,String> attributes=new Map<String,String>{'givenname'=>'TestUser','sn'=>'lastname','email'=>'testemail@gmail.com','uid'=>'56789098765','location_num'=>'12334'};
        Map<String,IAM_Application__c> acntAppMap= new Map<String,IAM_Application__c>();
        Map<String,IAM_Contact_Provisioning__c> conAppMap= new Map<String,IAM_contact_Provisioning__c>();
        Test.StartTest();
        IAM_PartnerJITImplementation iamJit= new IAM_PartnerJITImplementation();
        iamJit.createAccountAccessFeatures(usr,acnt,con,acntAppMap,conAppMap,attributes,bIsCumpasTrue);
        Test.StopTest();
    }
    
    Static testMethod void handleContactAccessValidate(){
    	Boolean bIsPartnerCode = False;
        List<IAM_Contact_Provisioning__c> conProvList = [Select Id, IAM_Contact__c, IAM_Application_Name__c, IAM_Role__c,IAM_Subscription_Name__c
                              FROM IAM_Contact_Provisioning__c where IAM_Application_Name__c = 'QuickServe Online'
                              AND IAM_Status__c =: System.Label.IAM_Active Limit 1];
        Map<String,String> attributes=new Map<String,String>{'givenname'=>'TestUser','sn'=>'lastname','email'=>'testemail@gmail.com','uid'=>'56789098765','location_num'=>'12334'};
        Test.StartTest();
        IAM_PartnerJITImplementation.handleContactAccessValidation(conProvList,attributes,bIsPartnerCode);
        Test.StopTest();
    }
}