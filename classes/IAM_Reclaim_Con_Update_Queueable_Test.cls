/************************************************************
Name:  IAM_Reclaim_Con_Update_Queueable_Test
Copyright © 2020  Cummins
=============================================================
=============================================================
Purpose:                                                            
This is test Class for Reclaim Process Contact Update.  
Made changes to identify the user location.                        
=============================================================
=============================================================
History                                                            
-------                                                            
VERSION  AUTHOR                   DATE              DETAIL                                
1.0 -    Karthik Golakram       09/02/2020        INITIAL DEVELOPMENT 
1.1 -    Shubhangi              02/12/2021       NPBU changes 
1.2 -    Shubhangi Sardar       09/06/2021       LDAP Sync Issue 
1.3 -    Vineet Srivastav       09/17/2021       DN Value changes          
1.4 -    Anupam Adhikari        09/09/2021       Expired Reclaim issue
*****************************************************/

@isTest
Private Class IAM_Reclaim_Con_Update_Queueable_Test{

    @testSetup
    Static Void testReclaimData(){
          Account a= new Account();
        a.Name='Reclaim Account';
        a.Type='Dealer Account';
        a.Recordtypeid= Schema.sObjectType.Account.getRecordTypeInfosByName().get('WWSPS').getRecordTypeId();
        a.IAM_Service_Provider_Code__c='4234151';
        a.CSS_DistributorCode__c='00000';
        a.IAM_WWSPS_Regions__c='Us and Canada';
        a.IAM_Movex_Customer_Code__c='12323231';
       // a.CSS_Locale__c='English(United States)';
        //a.CSS_Language__c='English';
        //a.CSS_Timezone__c='(GMT-05:00) Eastern Standard Time (America/Panama)';
        insert a;
        
        
        List<IAM_Application__c> appList= new List<IAM_Application__c>();
        
        IAM_Application__c appQSOL= new IAM_Application__c();
        appQSOL.IAM_Application_Name__c='QuickServe Online';
        appQSOL.IAM_Account_Name__c=a.id;
        appQSOL.IAM_Subscription_Name__c='QuickServe Online EBU';
        appQSOL.IAM_Role__c='QSOL Dealer';
        appQSOL.RecordtypeID=Schema.SObjectType.IAM_Application__c.getRecordTypeInfosByName().get('QuickServe Online').getRecordTypeID();
        appQSOL.IAM_Free_Subscription__c=false;
        appQSOL.IAM_Subscription_Start_Date__c=System.Today();
        appQSOL.IAM_Subscription_End_Date__c=System.Today()+35600;
        appQSOl.IAM_Qsolexpiration__c='02-OCT2100EBUACTIVE';
        appQSOL.IAM_Status__c='Active';
        appList.add(appQSOL);
        
        IAM_Application__c appCST= new IAM_Application__c();
        appCST.IAM_Application_Name__c='Cummins Service Training';
        appCST.IAM_Account_Name__c=a.id;
        appCST.IAM_Subscription_Name__c='Cummins Service Training';
        appCST.IAM_Role__c='Service Training User';
        appCST.RecordtypeID=Schema.SObjectType.IAM_Application__c.getRecordTypeInfosByName().get('Cummins Service Training').getRecordTypeID();
        appCST.IAM_Free_Subscription__c=false;
        appCST.IAM_Subscription_Start_Date__c=System.Today();
        appCST.IAM_Subscription_End_Date__c=System.Today()+35600;
        appCST.IAM_Qsolexpiration__c='02-OCT2100EBUACTIVE';
        appCST.IAM_Status__c='Active';
        appList.add(appCST);
        
        IAM_Application__c appEDS= new IAM_Application__c();
        appEDS.IAM_Application_Name__c='EDS';
        appEDS.IAM_Account_Name__c=a.id;
        appEDS.IAM_Subscription_Name__c='QuickServe Online EBU';
        appEDS.IAM_Role__c='Technician';
        appEDS.RecordtypeID=Schema.SObjectType.IAM_Application__c.getRecordTypeInfosByName().get('EDS').getRecordTypeID();
        appEDS.IAM_Free_Subscription__c=false;
        appEDS.IAM_Subscription_Start_Date__c=System.Today();
        appEDS.IAM_Subscription_End_Date__c=System.Today()+35600;
        appEDS.IAM_Qsolexpiration__c='02-OCT2100EBUACTIVE';
        appEDS.IAM_Status__c='Active';
        appList.add(appEDS);
        
        IAM_Application__c appCumpas= new IAM_Application__c();
        appCumpas.IAM_Application_Name__c='CUMPAS 2.0';
        //appEDS.IAM_Subscription_Name__c='QuickServe Online EBU';
        appCumpas.IAM_Role__c='Technician';
        appCumpas.IAM_Account_Name__c=a.id;
        appCumpas.RecordtypeID=Schema.SObjectType.IAM_Application__c.getRecordTypeInfosByName().get('CUMPAS 2.0').getRecordTypeID();
        appCumpas.IAM_Free_Subscription__c=true;
        appCumpas.IAM_Subscription_Start_Date__c=System.Today();
        appCumpas.IAM_Subscription_End_Date__c=System.Today()+35600;
        appCumpas.IAM_Qsolexpiration__c='02-OCT2100EBUACTIVE';
        appCumpas.IAM_Status__c='Active';
        appCumpas.IAM_Cumpas_Modularity__c='Parts Order';
        
        appList.add(appCumpas);
        
        
         IAM_Application__c appGuidanz= new IAM_Application__c();
        appGuidanz.IAM_Application_Name__c='Guidanz';
        //appEDS.IAM_Subscription_Name__c='QuickServe Online EBU';
        appGuidanz.IAM_Role__c='Technician';
        appGuidanz.IAM_Account_Name__c=a.id;
        appGuidanz.RecordtypeID=Schema.SObjectType.IAM_Application__c.getRecordTypeInfosByName().get('Guidanz').getRecordTypeID();
        appGuidanz.IAM_Free_Subscription__c=true;
        appGuidanz.IAM_Subscription_Start_Date__c=System.Today();
        appGuidanz.IAM_Subscription_End_Date__c=System.Today()+35600;
        appGuidanz.IAM_Qsolexpiration__c='02-OCT2100EBUACTIVE';
        appGuidanz.IAM_Status__c='Active';
        appGuidanz.IAM_Cumpas_Modularity__c='Parts Order';
        
        appList.add(appGuidanz);
        
        insert appList;
        
        Contact c=new Contact();
        c.FirstName='Reclaim first';
        c.LastName='Reclaim Last';
        c.Email='oh611@cummins.com';
        c.Accountid=a.id;
        c.Username__c='extlegacy1';
        c.IAM_Contact_Status__c='Reclaim';
        c.Recordtypeid=Schema.sObjectType.Contact.getRecordtypeInfosByName().get('IAM').getRecordTypeId();
        c.IAM_Legacy_User__c=true;
        c.IAM_Ext_Legacy_UID__c='extlegacy';
        c.IAM_Applications__c='cn=SERVICE_TRAINING_DN_USERS,ou=APP_SERVICE_TRAINING,ou=application,dc=cummins,dc=com|cn=DBU_DN_DEALER_USERS,ou=App_DBU_commerce,ou=application,dc=cummins,dc=com|cn=QuickServe_Dealers,ou=APP_QuickServe,ou=application,dc=cummins,dc=com|cn=eds_user,ou=APP_EDS,ou=application,dc=cummins,dc=com';
        
        insert c;
        
         List<IAM_Application_Groups__c> lstAppGroup = IAM_Application_Groups__c.getall().values();
         IAM_Application_Groups__c appQSOLCS= new IAM_Application_Groups__c();
         appQSOLCS.IAM_Application_Name__c='QuickServe Online';
         appQSOLCS.Name='QSOl1';
         appQSOLCS.IAM_DN_value__c='cn=QuickServe_Dealers,ou=APP_QuickServe,ou=application,dc=cummins,dc=com';
         appQSOLCS.IAM_Role_Name__c='QSOL Dealer';
         lstAppGroup.add(appQSOLCS);
         
         IAM_Application_Groups__c appEDSCS= new IAM_Application_Groups__c();
         appEDSCS.IAM_Application_Name__c='EDS';
         appEDSCS.Name='EDS1';
         appEDSCS.IAM_DN_value__c='cn=eds_user,ou=APP_EDS,ou=application,dc=cummins,dc=com';
         appEDSCS.IAM_Role_Name__c='Technician';
         lstAppGroup.add(appEDSCS);

         
         IAM_Application_Groups__c appCSTCS= new IAM_Application_Groups__c();
         appCSTCS.IAM_Application_Name__c='Cummins Service Training';
         appCSTCS.Name='CST1';
         appCSTCS.IAM_DN_value__c='cn=SERVICE_TRAINING_DN_USERS,ou=APP_SERVICE_TRAINING,ou=application,dc=cummins,dc=com';
         appCSTCS.IAM_Role_Name__c='Service Training User';
         lstAppGroup.add(appCSTCS);
         
         IAM_Application_Groups__c appCumpasCS= new IAM_Application_Groups__c();
         appCumpasCS.IAM_Application_Name__c='CUMPAS 2.0';
         appCumpasCS.Name='Cumpas21';
         appCumpasCS.IAM_DN_value__c='cn=DBU_DN_DEALER_USERS,ou=App_DBU_commerce,ou=application,dc=cummins,dc=com';
         appCumpasCS.IAM_Role_Name__c='Dealer User';
        lstAppGroup.add(appCumpasCS);
        
        IAM_Application_Groups__c appGuidanzcs= new IAM_Application_Groups__c();
         appGuidanzcs.IAM_Application_Name__c='Guidanz';
         appGuidanzcs.Name='Guidanz21';
         appGuidanzcs.IAM_DN_value__c='cn=css_dn_tech,ou=app_css,ou=application,dc=cummins,dc=com';
         appGuidanzcs.IAM_Role_Name__c='Technician';
        lstAppGroup.add(appGuidanzcs);
        insert lstAppGroup;
        
        //guidanz Contact
        Contact guidanzCon= new Contact();
        guidanzCon.FirstName='FirstGuidanz';
        guidanzCon.LastName='LastGuidanz';
        guidanzCon.email='oh611@cummins.com';
        guidanzCon.RecordTypeID=Schema.sObjectType.Contact.getRecordTypeInfosByName().get('Guidanz').getRecordTypeId();
        guidanzCon.Accountid=a.id;
        
        insert guidanzCon;
        
        User guidanzUser= new User();
        guidanzUser.FirstName='userFname';
        guidanzUser.LastName='lastName';
        guidanzUser.email='oh611@cummins.com';
        guidanzUser.alias='23ews';
        guidanzUser.Username='userguidanzuser@gmail.com';
        guidanzUser.ContactId=guidanzCon.id;
        guidanzUser.FederationIdentifier='userLegacy12g';
        guidanzUser.IAM_UID__c='userLegacy12';
        guidanzUser.ProfileId=System.Label.IAM_CSS_Dealer_Technician_Profile_ID;
        guidanzUser.EmailEncodingKey='UTF-8';
        guidanzUser.LanguageLocaleKey='en_US';
        guidanzUser.LocaleSidKey='en_US';
        guidanzUser.TimeZoneSidKey='America/Los_Angeles';
        
        insert guidanzUser;
        
        
        Contact conReclaim= new Contact();
        conReclaim.FirstName='firstReclaim';
        conReclaim.LastName='lastReclaim';
        conReclaim.email='oh611@cummins.com';
        conReclaim.Username__c='userLegacy12g';
        conReclaim.RecordTypeId=Schema.sObjectType.Contact.getRecordTypeInfosByName().get('IAM').getRecordTypeId();
        conReclaim.IAM_Contact_Status__c='Reclaim';
        conReclaim.IAM_Ext_Legacy_UID__c='userLegacy12g';
        conReclaim.IAM_Legacy_User__c=true;
        conReclaim.IAM_Applications__c='cn=SERVICE_TRAINING_DN_USERS,ou=APP_SERVICE_TRAINING,ou=application,dc=cummins,dc=com|cn=DBU_DN_DEALER_USERS,ou=App_DBU_commerce,ou=application,dc=cummins,dc=com|cn=QuickServe_Dealers,ou=APP_QuickServe,ou=application,dc=cummins,dc=com|cn=eds_user,ou=APP_EDS,ou=application,dc=cummins,dc=com|cn=css_dn_tech,ou=app_css,ou=application,dc=cummins,dc=com';
        
        insert conReclaim;
    }
    
    Static testMethod Void reclaimContactUpdate1(){
    
        String newUsername='testreclaimuserguidanz2@gmail.com';
        String newEmail='oh611@cummins.com';
        String randomString='123232322';
        Boolean isDuplicateUser=false;
        
         List<Contact> conReclaim=[Select id,firstname,lastname,email,phone,IAM_AppId__c,Account.OwnerId,Account.CMI_Account_Num__c,IAM_Internal__c,Accountid,Account.Name,CMI_Contact_Type__c,Account.Type,
                                     Username__c,IAM_Final_Approver__c,Account.IAM_ABO_Code_Formula__c,IAM_Applications__c,Account.IAM_Service_Provider_Code__c,
                                     Account.CSS_DBCode__c,Account.CSS_DistributorCode__c,Account.parentid,IAM_is_Member_of__c,IAM_Work_Group_Id__c,IAM_Qsolexpiration__c,
                                     IAM_Qsolview__c,IAM_Product_Group_Access__c,Account.Location__c,Account.BillingStreet,Account.BillingCity,Account.BillingCountry,
                                     Account.BillingPostalCode,Account.CSS_Locale__c,Account.CSS_Language__c,Account.CSS_Timezone__c,Account.IAM_Movex_Customer_Code__c,
                                     Account.IAM_WWSPS_Regions__c,IAM_contact_check__c,IAM_Contact_status__c,IAM_swregexpire__c,IAM_Legacy_User__c,IAM_Ext_Legacy_Uid__c,IAM_Site_Admin__c,IAM_NpbuDiagExpire__c From contact where Username__c='userLegacy12g'];
        
        List<user> usrGuidanz=[select id,IAM_Promotion__c,IAM_NpbuDiagExpire__c from User where username='userguidanzuser@gmail.com'];
        Contact conGuidanz=[Select id,firstname,lastname,email,recordtypeid,IAM_NpbuDiagExpire__c from Contact where firstName='FirstGuidanz' and LastName='LastGuidanz'];
        //List<IAM_Contact_Provisioning__c> conDel= [SELECT id,IAM_Reject_Reason__c,IAM_Reason__c FROM IAM_Contact_Provisioning__c WHERE IAM_Contact__C=:conReclaim[0].Id];
        Map<String,Boolean> reclaimTracker = new Map<String,Boolean>();
        reclaimTracker.put('Is_Guidanz_User_Update',True);
        reclaimTracker.put('Is_Create_User',True);
        reclaimTracker.put('Is_Guidanz_User_Update',true);
         
        IAM_Reclaim_Contact_Update_Queueable iam= new IAM_Reclaim_Contact_Update_Queueable(usrGuidanz[0],conGuidanz.id,conReclaim[0],newUSername,newEmail,true,reclaimTracker,false);
        Test.StartTest();
        System.enqueueJob(iam);
        Test.StopTest();
    }

    Static testMethod Void reclaimContactUpdate2(){
    
        String newUsername='testreclaimuserguidanz2@gmail.com';
        String newEmail='oh611@cummins.com';
        String randomString='123232322';
        Boolean isDuplicateUser=false;
        
         List<Contact> conReclaim=[Select id,firstname,lastname,email,phone,IAM_AppId__c,Account.OwnerId,Account.CMI_Account_Num__c,IAM_Internal__c,Accountid,Account.Name,CMI_Contact_Type__c,Account.Type,
                                     Username__c,IAM_Final_Approver__c,Account.IAM_ABO_Code_Formula__c,IAM_Applications__c,Account.IAM_Service_Provider_Code__c,
                                     Account.CSS_DBCode__c,Account.CSS_DistributorCode__c,Account.parentid,IAM_is_Member_of__c,IAM_Work_Group_Id__c,IAM_Qsolexpiration__c,
                                     IAM_Qsolview__c,IAM_Product_Group_Access__c,Account.Location__c,Account.BillingStreet,Account.BillingCity,Account.BillingCountry,
                                     Account.BillingPostalCode,Account.CSS_Locale__c,Account.CSS_Language__c,Account.CSS_Timezone__c,Account.IAM_Movex_Customer_Code__c,
                                     Account.IAM_WWSPS_Regions__c,IAM_contact_check__c,IAM_Contact_status__c,IAM_swregexpire__c,IAM_Legacy_User__c,IAM_Ext_Legacy_Uid__c,IAM_Site_Admin__c,IAM_NpbuDiagExpire__c From contact where Username__c='userLegacy12g'];
        
        List<user> usrGuidanz=[select id,IAM_Promotion__c,IAM_NpbuDiagExpire__c from User where username='userguidanzuser@gmail.com'];
        Contact conGuidanz=[Select id,firstname,lastname,email,recordtypeid,IAM_NpbuDiagExpire__c from Contact where firstName='FirstGuidanz' and LastName='LastGuidanz'];
        Map<String,Boolean> reclaimTracker = new Map<String,Boolean>();
        reclaimTracker.put('Is_Guidanz_User_Update',True);
        reclaimTracker.put('Is_Create_User',True);
        reclaimTracker.put('Is_Guidanz_User_Update',true);
         
        IAM_Reclaim_Contact_Update_Queueable iam= new IAM_Reclaim_Contact_Update_Queueable(usrGuidanz[0],conGuidanz.id,conReclaim[0],newUSername,newEmail,false,reclaimTracker,false);
        Test.StartTest();
        System.enqueueJob(iam);
        Test.StopTest();
    }
    
    @isTest
    Static void testupdateUserFeature(){
        
        Account accSampleRecord = new Account(name='AccountTest1',
                                   CMI_Account_Status__c='Active',
                                   CMI_CDA_Status__c='New Customer Request',
                                   CSS_DistributorCode__c = '10010',
                                   IAM_Service_Provider_Code__c = '1339',
                                   Type='Dealer Account'
                                   );    
    insert accSampleRecord;
        
        Contact contSampleRecord = new Contact(
        FirstName = 'Test',
        LastName ='User',
        Email = 'lstTest@test.com',
        AccountId = accSampleRecord.ID,
        IAM_Contact_Status__c = 'Pending',
        CMI_Contact_Type__c = 'Secondary',
        recordtypeid=Schema.getGlobalDescribe().get('Contact').getDescribe().getRecordTypeInfosByName().get('IAM').getRecordTypeId(),
        Username__c = 'Amartest@abc.com',
        Phone = '9743800309'
    );   
    insert contSampleRecord;
        
        IAM_Application__c cumpasApplication = new IAM_Application__c(    
        IAM_Account_Name__c = accSampleRecord.ID,
        IAM_Application_Name__c = 'CUMPAS 2.0',
        IAM_Role__c='Dealer User',
        IAM_Status__c='Active',
        IAM_Subscription_Count__c= 7,
        IAM_Provisioned_User_Count__c=5,
        IAM_Subscription_End_Date__c= System.today() + 5,
        IAM_Subscription_Name__c='TestSubscription1Test',
        IAM_Free_Subscription__c= True,
        IAM_Subscription_Start_Date__c=System.today(),
        IAM_Cumpas_Modularity__c = 'View Credit',
        IAM_Customer_Code__c='1339'
    );
    insert cumpasApplication;
        
        IAM_Contact_Provisioning__c iamContSampleRecord = new IAM_Contact_Provisioning__c(
        //IAM_Account_Application__c = iamAppSampleRecord.ID,
        IAM_Account_Application__c = cumpasApplication.ID,
        RecordTypeId = Schema.SObjectType.IAM_Contact_Provisioning__c.getRecordTypeInfosByName().get('CUMPAS 2.0').getRecordTypeId(),
        IAM_Application_Name__c = 'CUMPAS 2.0',
        IAM_Contact__c= contSampleRecord.Id,
        IAM_End_Date__c= System.today() + 5,
        IAM_Role__c='Dealer User',
        IAM_Start_Date__c=System.today(),
        IAM_Status__c='Pending',
        IAM_Cumpas_Modularity__c = 'Core Returns'
        //recordtypeid = Schema.SObjectType.IAM_Contact_Provisioning__c.getRecordTypeInfosByName().get('EDS').getRecordTypeId()
    );
    insert iamContSampleRecord;
        
        Test.startTest();
        IAM_Reclaim_Contact_Update_Queueable.updateUserFeature(contSampleRecord.id);
        Test.stopTest();
        
    }

}