/*************************************************************************************
Name:  IAM_Reclaim_ConProv_Process_Queable_Test
Copyright © 2019  Cummins
**************************************************************************************
Purpose: Test class of IAM_Reclaim_ConProv_Process_Queable
**************************************************************************************
History
--------------------------------------------------------------------------------------
VERSION       AUTHOR                  DATE               DETAIL                                
1.0      Karthik Golakram          09/02/2020        INITIAL DEVELOPMENT
1.1      Shubhangi sardar          06/09/2020        LDAP Sync Issue
1.2      Shubhangi Sardar          08/19/2021        QSOL, EDS, CST app creation logic
1.3      Shubhangi Sardar          09/16/2021        QSOL, EDS, CST app creation logic
**************************************************************************************
**************************************************************************************/

@isTest
private class IAM_Reclaim_ConProv_Process_Queable_Test {

    @testSetup
    static void createTestData(){
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
        //acc.CSS_DistributorCode__c='1234';
        acc.Type = 'Dealer Account';
        insert acc;

        List<Contact> conList = new List<contact>();
        Contact con = new contact();
        con.RecordTypeId = Schema.SObjectType.contact.getRecordTypeInfosByName().get('IAM').getRecordTypeId();
        con.FirstName = 'Fname';
        con.LastName = 'Lname';
        con.Email = 'fnamelname@test.com';
        con.phone = '1112223335';
        con.AccountId = acc.Id;
        con.Username__c = 'fnamelname@test.com';
        con.IAM_Contact_Status__c = 'Active';
        con.IAM_Legacy_User__c = false;
        con.IAM_Ext_Legacy_UID__c = 'fnamelname';
        con.IAM_Applications__c = 'cn=css_dn_tech,ou=app_css,ou=application,dc=cummins,dc=com|cn=eds_wrkgrp_admin_user,ou=APP_EDS,ou=application,dc=cummins,dc=com|cn=DBU_DN_DEALER_USERS,ou=App_DBU_Commerce,ou=application,dc=cummins,dc=com|cn=cumpas_order,ou=app_cumpas,ou=application,dc=cummins,dc=com|cn=SERVICE_TRAINING_DN_USERS,ou=APP_SERVICE_TRAINING,ou=application,dc=cummins,dc=com|cn=QuickServe_Dealers,ou=APP_QuickServe,ou=application,dc=cummins,dc=com';
        con.IAM_is_Member_of__c = 'cn=ATLAS_Universal_CAMPAIGN_DEALER,ou=APP_ATLAS_UNIVERSAL,ou=application,dc=cummins,dc=com|cn=ATLAS_Universal_FLEET,ou=APP_ATLAS_UNIVERSAL,ou=application,dc=cummins,dc=com';
        conList.add(con);
        
        Contact con1 = new contact();
        con1.RecordTypeId = Schema.SObjectType.contact.getRecordTypeInfosByName().get('IAM').getRecordTypeId();
        con1.FirstName = 'Fname1';
        con1.LastName = 'Lname1';
        con1.Email = 'fnamelname1@test.com';
        con1.phone = '11122233351';
        con1.AccountId = acc.Id;
        con1.Username__c = 'fnamelname1@test.com';
        con1.IAM_Contact_Status__c = 'Active';
        con1.IAM_Legacy_User__c = false;
        con1.IAM_Ext_Legacy_UID__c = 'fnamelname1';
        con1.IAM_Applications__c = 'cn=css_dn_tech,ou=app_css,ou=application,dc=cummins,dc=com|cn=eds_wrkgrp_admin_user,ou=APP_EDS,ou=application,dc=cummins,dc=com|cn=DBU_DN_DEALER_USERS,ou=App_DBU_Commerce,ou=application,dc=cummins,dc=com|cn=cumpas_order,ou=app_cumpas,ou=application,dc=cummins,dc=com|cn=SERVICE_TRAINING_DN_USERS,ou=APP_SERVICE_TRAINING,ou=application,dc=cummins,dc=com|cn=QuickServe_Dealers,ou=APP_QuickServe,ou=application,dc=cummins,dc=com';
        conList.add(con1);
        
        Contact con2 = new contact();
        con2.RecordTypeId = Schema.SObjectType.contact.getRecordTypeInfosByName().get('IAM').getRecordTypeId();
        con2.FirstName = 'Fname2';
        con2.LastName = 'Lname2';
        con2.Email = 'fnamelname2@test.com';
        con2.phone = '11122233352';
        con2.AccountId = acc.Id;
        con2.Username__c = 'fnamelname2@test.com';
        con2.IAM_Contact_Status__c = 'Active';
        con2.IAM_Legacy_User__c = false;
        con2.IAM_Ext_Legacy_UID__c = 'fnamelname2';
        con2.IAM_is_Member_of__c = 'cn=ATLAS_Universal_CAMPAIGN_DEALER,ou=APP_ATLAS_UNIVERSAL,ou=application,dc=cummins,dc=com|cn=ATLAS_Universal_FLEET,ou=APP_ATLAS_UNIVERSAL,ou=application,dc=cummins,dc=com';
        conList.add(con2);
        
        insert conList;        
        
        List<IAM_Application__c> appList = new List<IAM_Application__c>();
        
        IAM_Application__c appQSOL = new IAM_Application__c();
        appQSOL.IAM_Application_Name__c = 'QuickServe Online';
        appQSOL.IAM_Account_Name__c = acc.Id;
        appQSOL.IAM_Subscription_Name__c = 'QuickServe Online EBU';
        appQSOL.IAM_Role__c = 'QSOL Dealer';
        appQSOL.RecordtypeID = Schema.SObjectType.IAM_Application__c.getRecordTypeInfosByName().get('QuickServe Online').getRecordTypeID();
        appQSOL.IAM_Free_Subscription__c = false;
        appQSOL.IAM_Subscription_Start_Date__c = System.Today();
        appQSOL.IAM_Subscription_End_Date__c = System.Today()+35600;
        appQSOl.IAM_Qsolexpiration__c = '02-OCT2100EBUACTIVE';
        appQSOL.IAM_Status__c = 'Active';
        appList.add(appQSOL);
        
        IAM_Application__c appCST = new IAM_Application__c();
        appCST.IAM_Application_Name__c = 'Cummins Service Training';
        appCST.IAM_Account_Name__c = acc.Id;
        appCST.IAM_Subscription_Name__c = 'Cummins Service Training';
        appCST.IAM_Role__c = 'Service Training User';
        appCST.RecordtypeId = Schema.SObjectType.IAM_Application__c.getRecordTypeInfosByName().get('Cummins Service Training').getRecordTypeID();
        appCST.IAM_Free_Subscription__c = false;
        appCST.IAM_Subscription_Start_Date__c = System.Today();
        appCST.IAM_Subscription_End_Date__c = System.Today()+35600;
        appCST.IAM_Qsolexpiration__c = '02-OCT2100EBUACTIVE';
        appCST.IAM_Status__c = 'Active';
        appList.add(appCST);
        
        IAM_Application__c appEDS = new IAM_Application__c();
        appEDS.IAM_Application_Name__c = 'EDS';
        appEDS.IAM_Account_Name__c = acc.Id;
        appEDS.IAM_Subscription_Name__c = 'QuickServe Online EBU';
        appEDS.IAM_Role__c = 'Workgroup Administrator';
        appEDS.RecordtypeID = Schema.SObjectType.IAM_Application__c.getRecordTypeInfosByName().get('EDS').getRecordTypeID();
        appEDS.IAM_Free_Subscription__c = false;
        appEDS.IAM_Subscription_Start_Date__c = System.Today();
        appEDS.IAM_Subscription_End_Date__c = System.Today()+35600;
        appEDS.IAM_Qsolexpiration__c = '02-OCT2100EBUACTIVE';
        appEDS.IAM_Status__c = 'Active';
        appList.add(appEDS);
        
        IAM_Application__c appCumpas = new IAM_Application__c();
        appCumpas.IAM_Application_Name__c = 'CUMPAS 2.0';
        appCumpas.IAM_Role__c = 'Dealer User';
        appCumpas.IAM_Account_Name__c = acc.Id;
        appCumpas.RecordtypeID = Schema.SObjectType.IAM_Application__c.getRecordTypeInfosByName().get('CUMPAS 2.0').getRecordTypeID();
        appCumpas.IAM_Free_Subscription__c = true;
        appCumpas.IAM_Subscription_Start_Date__c = System.Today();
        appCumpas.IAM_Subscription_End_Date__c = System.Today()+35600;
        appCumpas.IAM_Status__c = 'Active';
        appCumpas.IAM_Cumpas_Modularity__c='View Credit';        
        appList.add(appCumpas);
        
        
        IAM_Application__c appGuidanz = new IAM_Application__c();
        appGuidanz.IAM_Application_Name__c = 'Guidanz';
        appGuidanz.IAM_Role__c = 'Technician';
        appGuidanz.IAM_Account_Name__c = acc.Id;
        appGuidanz.RecordtypeID = Schema.SObjectType.IAM_Application__c.getRecordTypeInfosByName().get('Guidanz').getRecordTypeID();
        appGuidanz.IAM_Free_Subscription__c = true;
        appGuidanz.IAM_Subscription_Start_Date__c = System.Today();
        appGuidanz.IAM_Subscription_End_Date__c = System.Today()+35600;
        appGuidanz.IAM_Status__c='Active';
        appList.add(appGuidanz);
        
        IAM_Application__c appGM = new IAM_Application__c();
        appGM.IAM_Application_Name__c = 'Guidanz Mobile';
        appGM.IAM_Account_Name__c = acc.Id;
        appGM.IAM_Subscription_Name__c = 'Guidanz Mobile Campaign';
        appGM.IAM_Role__c = 'Guidanz Mobile Campaign Dealer';
        appGM.IAM_Guidanz_Mobile_Roles__c = 'Guidanz Mobile Campaign Dealer';
        appGM.RecordtypeID = Schema.SObjectType.IAM_Application__c.getRecordTypeInfosByName().get('Guidanz Mobile').getRecordTypeID();
        appGM.IAM_Free_Subscription__c = false;
        appGM.IAM_Subscription_Start_Date__c = System.Today();
        appGM.IAM_Subscription_End_Date__c = System.Today()+35600;
        appGM.IAM_swregExpire__c = 'CMP0-12-08-20';
        appGM.IAM_Status__c = 'Active';
        appList.add(appGM);

        insert appList;
        
        /* Insert Application Groups - Custom setting */
        List<IAM_Application_Groups__c> lstAppGroup = new List<IAM_Application_Groups__c>();
        IAM_Application_Groups__c appQSOLCS = new IAM_Application_Groups__c();
        appQSOLCS.IAM_Application_Name__c ='QuickServe Online';
        appQSOLCS.Name = 'QSOl1';
        appQSOLCS.IAM_DN_value__c = 'cn=QuickServe_Dealers,ou=APP_QuickServe,ou=application,dc=cummins,dc=com';
        appQSOLCS.IAM_Role_Name__c = 'QSOL Dealer';
        appQSOLCS.IAM_Free_application__c = false;
        appQSOLCS.IAM_Group_Type__c = 'static';
        lstAppGroup.add(appQSOLCS);
         
        IAM_Application_Groups__c appEDSCS = new IAM_Application_Groups__c();
        appEDSCS.IAM_Application_Name__c ='EDS';
        appEDSCS.Name = 'EDS1';
        appEDSCS.IAM_DN_value__c = 'cn=eds_wrkgrp_admin_user,ou=APP_EDS,ou=application,dc=cummins,dc=com';
        appEDSCS.IAM_Role_Name__c = 'Workgroup Administrator';
        appEDSCS.IAM_Free_application__c = false;
        appEDSCS.IAM_Group_Type__c = 'static';
        lstAppGroup.add(appEDSCS);

         
        IAM_Application_Groups__c appCSTCS = new IAM_Application_Groups__c();
        appCSTCS.IAM_Application_Name__c ='Cummins Service Training';
        appCSTCS.Name = 'CST1';
        appCSTCS.IAM_DN_value__c = 'cn=SERVICE_TRAINING_DN_USERS,ou=APP_SERVICE_TRAINING,ou=application,dc=cummins,dc=com';
        appCSTCS.IAM_Role_Name__c = 'Service Training User';
        appCSTCS.IAM_Free_application__c = false;
        appCSTCS.IAM_Group_Type__c = 'static';
        lstAppGroup.add(appCSTCS);
        
        IAM_Application_Groups__c appCumpasCS = new IAM_Application_Groups__c();
        appCumpasCS.IAM_Application_Name__c ='CUMPAS 2.0';
        appCumpasCS.Name = 'Cumpas21';
        appCumpasCS.IAM_DN_value__c = 'cn=DBU_DN_DEALER_USERS,ou=App_DBU_commerce,ou=application,dc=cummins,dc=com';
        appCumpasCS.IAM_Role_Name__c = 'Dealer Admin';
        appCumpasCS.IAM_Free_application__c = true;
        appCumpasCS.IAM_Group_Type__c = 'static';
        lstAppGroup.add(appCumpasCS);

        IAM_Application_Groups__c appCumpasModCS = new IAM_Application_Groups__c();
        appCumpasModCS.IAM_Application_Name__c ='CUMPAS 2.0';
        appCumpasModCS.Name = 'Cumpas22';
        appCumpasModCS.IAM_DN_value__c = 'cn=cumpas_order,ou=app_cumpas,ou=application,dc=cummins,dc=com';
        appCumpasModCS.IAM_Role_Name__c = 'Parts Order';
        appCumpasModCS.IAM_Free_application__c = true;
        appCumpasModCS.IAM_Group_Type__c = 'static';
        lstAppGroup.add(appCumpasModCS);
        
        IAM_Application_Groups__c appGuidanzcs = new IAM_Application_Groups__c();
        appGuidanzcs.IAM_Application_Name__c ='Guidanz';
        appGuidanzcs.Name = 'Guidanz21';
        appGuidanzcs.IAM_DN_value__c = 'cn=css_dn_tech,ou=app_css,ou=application,dc=cummins,dc=com';
        appGuidanzcs.IAM_Role_Name__c = 'Technician';
        appGuidanzcs.IAM_Free_application__c = true;
        appGuidanzcs.IAM_Group_Type__c = 'static';
        lstAppGroup.add(appGuidanzcs);

        IAM_Application_Groups__c appGuidanzcs1 = new IAM_Application_Groups__c();
        appGuidanzcs1.IAM_Application_Name__c ='Guidanz';
        appGuidanzcs1.Name = 'Guidanz22';
        appGuidanzcs1.IAM_DN_value__c = 'cn=CSS_DN_Advanced,ou=APP_CSS,ou=application,dc=cummins,dc=com';
        appGuidanzcs1.IAM_Role_Name__c = 'Advanced';
        appGuidanzcs1.IAM_Free_application__c = true;
        appGuidanzcs1.IAM_Group_Type__c = 'static';
        lstAppGroup.add(appGuidanzcs1);
                
        IAM_Application_Groups__c appGMCS = new IAM_Application_Groups__c();
        appGMCS.IAM_Application_Name__c = 'Guidanz Mobile';
        appGMCS.Name = 'GuidanzMobile21';
        appGMCS.IAM_DN_value__c = 'cn=ATLAS_Universal_CAMPAIGN_DEALER,ou=APP_ATLAS_UNIVERSAL,ou=application,dc=cummins,dc=com';
        appGMCS.IAM_Role_Name__c = 'Guidanz Mobile Campaign Dealer';
        appGMCS.IAM_Free_application__c = false;
        appGMCS.IAM_Group_Type__c = 'dynamic';
        lstAppGroup.add(appGMCS);

        IAM_Application_Groups__c appGM1 = new IAM_Application_Groups__c();
        appGM1.IAM_Application_Name__c = 'Guidanz Mobile';
        appGM1.Name = 'GuidanzMobile22';
        appGM1.IAM_DN_value__c = 'cn=ATLAS_Universal_FLEET,ou=APP_ATLAS_UNIVERSAL,ou=application,dc=cummins,dc=com';
        appGM1.IAM_Role_Name__c = 'Guidanz Mobile Immediate Assessment Fleet';
        appGM1.IAM_Free_application__c = false;
        appGMCS.IAM_Group_Type__c = 'dynamic';
        lstAppGroup.add(appGM1);
        
        insert lstAppGroup;
    }
    
    /* Test reclaimed con pro job */
    static testMethod void reclaimConProvTest1() {      
        List<Contact> reclaimedConList= getContact('fnamelname@test.com');
        IAM_Reclaim_ConProv_Process_Queable reclaimconPro
        = new IAM_Reclaim_ConProv_Process_Queable(reclaimedConList[0]);
        Test.startTest();
          System.enqueueJob(reclaimconPro);
        Test.stopTest();        
    }
    
    /* Test reclaimed con pro job */
    static testMethod void reclaimConProvTest2() {      
        List<Contact> reclaimedConList= getContact('fnamelname1@test.com');
        IAM_Reclaim_ConProv_Process_Queable reclaimconPro
        = new IAM_Reclaim_ConProv_Process_Queable(reclaimedConList[0]);
        Test.startTest();
          System.enqueueJob(reclaimconPro);
        Test.stopTest();        
    }
    
    /* Test reclaimed con pro job */
    static testMethod void reclaimConProvTest3() {      
        List<Contact> reclaimedConList= getContact('fnamelname2@test.com');
        IAM_Reclaim_ConProv_Process_Queable reclaimconPro
        = new IAM_Reclaim_ConProv_Process_Queable(reclaimedConList[0]);
        Test.startTest();
          System.enqueueJob(reclaimconPro);
        Test.stopTest();        
    }
    
    /* Test reclaimed con pro job */
    static testMethod void reclaimConProvTest4() {
        List<IAM_Application__c> appListGM = [
            SELECT IAM_Status__c
              FROM IAM_Application__c
             WHERE IAM_Application_Name__c = 'Guidanz Mobile'
        ];
        appListGM[0].IAM_Status__c = 'Inactive';
        update appListGM[0];
        List<Contact> reclaimedConList= getContact('fnamelname@test.com');
        IAM_Reclaim_ConProv_Process_Queable reclaimconPro
        = new IAM_Reclaim_ConProv_Process_Queable(reclaimedConList[0]);
        Test.startTest();
          System.enqueueJob(reclaimconPro);
        Test.stopTest();        
    }
    
    /* Test reclaimed con pro job */
    static testMethod void reclaimConProvTest5() {
        List<Contact> reclaimedConList = getContact('fnamelname@test.com');
        
        /*IAM_Application__c appGuidanz = new IAM_Application__c();
        appGuidanz.IAM_Application_Name__c = 'Guidanz';
        appGuidanz.IAM_Role__c = 'Advanced';
        appGuidanz.IAM_Account_Name__c = reclaimedConList[0].AccountId;
        appGuidanz.RecordtypeID = Schema.SObjectType.IAM_Application__c.getRecordTypeInfosByName().get('Guidanz').getRecordTypeID();
        appGuidanz.IAM_Free_Subscription__c = true;
        appGuidanz.IAM_Subscription_Start_Date__c = System.Today();
        appGuidanz.IAM_Subscription_End_Date__c = System.Today()+35600;
        appGuidanz.IAM_Status__c='Active';
        insert appGuidanz;*/
        
        List<IAM_Application__c> appListGuidanz = [
            SELECT Id, IAM_Subscription_End_Date__c
              FROM IAM_Application__c
             WHERE IAM_Application_Name__c = 'Guidanz'
        ];
        
        IAM_Contact_Provisioning__c conAppGuidanz = new IAM_Contact_Provisioning__c();
        conAppGuidanz.IAM_Contact__c= reclaimedConList[0].Id; 
        conAppGuidanz.IAM_Start_Date__c = Date.today();
        conAppGuidanz.IAM_End_Date__c = appListGuidanz[0].IAM_Subscription_End_Date__c;
        conAppGuidanz.IAM_Application_Name__c = 'Guidanz';
        conAppGuidanz.IAM_Role__c = 'Technician';
        conAppGuidanz.IAM_Status__c = 'Active';
        conAppGuidanz.IAM_Account_Application__c = appListGuidanz[0].Id;
        conAppGuidanz.RecordtypeId = Schema.SObjectType.IAM_Contact_Provisioning__c.getRecordTypeInfosByName().get('Guidanz').getRecordTypeId();
		insert conAppGuidanz;        

        IAM_Reclaim_ConProv_Process_Queable reclaimconPro
        = new IAM_Reclaim_ConProv_Process_Queable(reclaimedConList[0]);
        Test.startTest();
          System.enqueueJob(reclaimconPro);
        Test.stopTest();        
    }
    
    /* Test reclaimed con pro job - QSOL Inactive at Account Level */
    static testMethod void reclaimConProvTest6() {
        List<IAM_Application__c> appListQSOL = [
            SELECT IAM_Status__c
              FROM IAM_Application__c
             WHERE IAM_Application_Name__c = 'QuickServe Online'
        ];
        appListQSOL[0].IAM_Status__c = 'Inactive';
        update appListQSOL[0];
        List<Contact> reclaimedConList= getContact('fnamelname@test.com');
        IAM_Reclaim_ConProv_Process_Queable reclaimconPro
        = new IAM_Reclaim_ConProv_Process_Queable(reclaimedConList[0]);
        Test.startTest();
          System.enqueueJob(reclaimconPro);
        Test.stopTest();        
    }
    
    /* Test reclaimed con pro job - QSOL Active But EDS & CST Inactive at Account Level */
    static testMethod void reclaimConProvTest7() {
        List<IAM_Application__c> appListEDSCST = [
            SELECT IAM_Status__c
              FROM IAM_Application__c
             WHERE IAM_Application_Name__c = 'Cummins Service Training'
                OR IAM_Application_Name__c = 'EDS'
        ];
        List<IAM_Application__c> appListToUpdate = new List<IAM_Application__c>();
        for(IAM_Application__c accApp : appListEDSCST) {
            accApp.IAM_Status__c = 'Inactive';
            appListToUpdate.add(accApp);
        }        
        update appListToUpdate;
        List<Contact> reclaimedConList= getContact('fnamelname@test.com');
        IAM_Reclaim_ConProv_Process_Queable reclaimconPro
        = new IAM_Reclaim_ConProv_Process_Queable(reclaimedConList[0]);
        Test.startTest();
          System.enqueueJob(reclaimconPro);
        Test.stopTest();
    }
    
    /* Test reclaimed con pro job */
    static testMethod void reclaimConProvTest8() {
        List<Contact> reclaimedConList= getContact('fnamelname@test.com');
        List<IAM_Application__c> appListGM = [
            SELECT Id, IAM_Subscription_Name__c, IAM_Subscription_End_Date__c
              FROM IAM_Application__c
             WHERE IAM_Application_Name__c = 'Guidanz Mobile'
        ];
        
        IAM_Contact_Provisioning__c conAppGuidanzM = new IAM_Contact_Provisioning__c();
        conAppGuidanzM.IAM_Contact__c= reclaimedConList[0].Id; 
        conAppGuidanzM.IAM_Start_Date__c = Date.today();
        conAppGuidanzM.IAM_End_Date__c = appListGM[0].IAM_Subscription_End_Date__c;
        conAppGuidanzM.IAM_Application_Name__c = 'Guidanz Mobile';
        conAppGuidanzM.IAM_Role__c = 'Guidanz Mobile Campaign Dealer';
        conAppGuidanzM.IAM_Guidanz_Mobile_Roles__c = 'Guidanz Mobile Campaign Dealer';
        conAppGuidanzM.IAM_Status__c = 'Active';
        conAppGuidanzM.IAM_Account_Application__c = appListGM[0].Id;
        conAppGuidanzM.IAM_Subscription_Name__c = 'Guidanz Mobile Campaign';
        conAppGuidanzM.IAM_swregExpire__c = 'CMP0-12-08-20';        
        conAppGuidanzM.RecordtypeId = Schema.SObjectType.IAM_Contact_Provisioning__c.getRecordTypeInfosByName().get('Guidanz Mobile').getRecordTypeId();
		insert conAppGuidanzM;        
        
        IAM_Reclaim_ConProv_Process_Queable reclaimconPro
        = new IAM_Reclaim_ConProv_Process_Queable(reclaimedConList[0]);
        Test.startTest();
          System.enqueueJob(reclaimconPro);
        Test.stopTest();        
    }
    
    /* Test reclaimed con pro job - Test exception */
    static testMethod void reclaimConProvTest9() {
        try {
            IAM_Reclaim_ConProv_Process_Queable reclaimconPro
            = new IAM_Reclaim_ConProv_Process_Queable(null);
            Test.startTest();
              System.enqueueJob(reclaimconPro);
        Test.stopTest();     
        } catch(Exception e) {
            System.debug('Exception - '+e.getMessage());
        }
    }
    
    /* Test reclaimed con pro job - Delete Application Groups */
    static testMethod void reclaimConProvTest10() {
        try {
            delete [SELECT Id FROM IAM_Application_Groups__c LIMIT 100];
            List<Contact> reclaimedConList= getContact('fnamelname@test.com');
            IAM_Reclaim_ConProv_Process_Queable reclaimconPro
            = new IAM_Reclaim_ConProv_Process_Queable(reclaimedConList[0]);
            Test.startTest();
              System.enqueueJob(reclaimconPro);
        	Test.stopTest();     
        } catch(Exception e) {
            System.debug('Exception - '+e.getMessage());
        }
    }

    /* Return list of reclaimed Contact */
    static List<Contact> getContact(String username) {
      return [
          SELECT Id
               , FirstName
               , LastName
               , Email
               , Phone
               , IAM_AppId__c
               , Account.OwnerId
               , Account.CMI_Account_Num__c
               , IAM_Internal__c
               , Accountid
               , Account.Name
               , CMI_Contact_Type__c
               , Account.Type
               , Username__c
               , IAM_Final_Approver__c
               , Account.IAM_ABO_Code_Formula__c
               , IAM_Applications__c
               , Account.IAM_Service_Provider_Code__c
               , Account.CSS_DBCode__c
               , Account.CSS_DistributorCode__c
               , Account.ParentId
               , IAM_is_Member_of__c
               , IAM_Work_Group_Id__c
               , IAM_Qsolexpiration__c
               , IAM_Qsolview__c
               , IAM_Product_Group_Access__c
               , Account.Location__c
               , Account.BillingStreet
               , Account.BillingCity
               , Account.BillingCountry
               , Account.BillingPostalCode
               , Account.CSS_Locale__c
               , Account.CSS_Language__c
               , Account.CSS_Timezone__c
               , Account.IAM_Movex_Customer_Code__c
               , Account.IAM_WWSPS_Regions__c
               , IAM_contact_check__c
               , IAM_Contact_status__c
               , IAM_Promotion__c
               , IAM_swregexpire__c
               , IAM_Legacy_User__c
               , IAM_Ext_Legacy_Uid__c
               , IAM_Site_Admin__c
            FROM Contact
           WHERE Username__c = :username
        ];
    }
}