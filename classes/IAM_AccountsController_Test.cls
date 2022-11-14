/************************************************************
Name:  IAM_AccountsController_Test
Copyright © 2019  Cummins
=============================================================
=============================================================
Purpose:                                                            
This is test class for IAM_AccountsController_Test class.                           
=============================================================
=============================================================
History                                                            
-------                                                            
VERSION  AUTHOR                     DATE              DETAIL                                
1.0 -    Karthik Golakaram         20/04/2019        INITIAL DEVELOPMENT  
1.1 -    Nishant Verma             02/10/2020        Fluidwatch Changes for site admin page 
1.2 -    Karthik Raj Golakaram     01/29/2021        Making Changes for OSM High Prod issue - INC1022619
1.3 -    Shubhangi Sardar          21/01/2021        Added comment to push to prod 
1.4 -    Karthik Raj Golakaram     03/25/2021        Made changes for OSM bulk user edit Changes Test
1.5 -    Vinod Kankatala           06/01/2021        Added Guidanz Mobile Power Plus subscription
1.6 -    Anupam Adhikari           08/10/2021        Added FT Guidanz Beta Testing changes.
1.7 -    Anupam Adhikari           09/09/2021        Added changes for Expired Reclaim scenarios
1.8 -    Shubhangi Sardar          09/23/2021        Added comment to push to prod
1.9 -    Anupam Adhikari           11/08/2021        changes for lehacy users scenarios
2.0 -    Anupam Adhikari           11/16/2021        changes Activ users receiving pending sub scenario
2.1 -    Anupam Adhikari           11/23/2021        changes for Fluids Registration
2.2 -    Suresh Rathod             08/02/2022        Added Cummins API Portal changes
2.3 -    Anupam Adhikari           03/14/2022        Added comment to push to prod - FTNPBU End Date change 
2.4 -    Chetan Gaikwad            05/04/2022        Added comment to push to prod - code optimization for bulk user assignment
2.5 -    Suresh Rathod Nanavath    29/06/2022        Added comment to push to prod- code for module update
*****************************************************/
/********************************************************************************
***********************************************************************************/ 
@isTest
private class IAM_AccountsController_Test {
    
    /* Function used to create sample record for this test Class
*/
@TestSetup
Static void InitData(){

    Test.startTest();
    list<IAM_Application__c> lstApplication = new list<IAM_Application__c>();
    list<IAM_Contact_Provisioning__c> lstconPro = new list<IAM_Contact_Provisioning__c>();
    
    Account accSampleRecord = new Account(name='AccountTest1',
                                   CMI_Account_Status__c='Pending',
                                   CMI_CDA_Status__c='New Customer Request',
                                   CSS_DistributorCode__c = '10010',
                                   IAM_Service_Provider_Code__c = '1339',
                                   Type='Dealer Account'
                                   );
    
    insert accSampleRecord;
    
    Account accSampleRecord2 = new Account(name='AccountTest2',
                                   CMI_Account_Status__c='Pending',
                                   CMI_CDA_Status__c='New Customer Request',
                                          IAM_Service_Provider_Code__c='554332');
    
    insert accSampleRecord2;
    
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
    
    
    Account accSampleRecord4 = new Account(name='AccountTest3',
                                   CMI_Account_Status__c = 'Active',
                                   type='Distributor Account',
                                   CMI_CDA_Status__c='New Customer Request',
                                   ParentId = accSampleRecord3.id,
                                   IAM_Service_Provider_Code__c='332019'        
                                   );
    
    insert accSampleRecord4;
    
    Account accSampleRecord5 = new Account(name='AccountTest5',
                                    CMI_Account_Status__c = 'Active',
                                    CMI_CDA_Status__c='New Customer Request',
                                    ParentId = accSampleRecord4.id,
                                    CMI_Region__c = 'East Asia',
                                    CMI_Cummins_Support_Email__c = 'abc123@gmail.com'
                                    );
    
    insert accSampleRecord5;
    
    Account accSampleRecord6 = new Account(name='AccountTest7',
                                    CMI_Account_Status__c = 'Active',
                                    CMI_CDA_Status__c='New Customer Request',
                                    ParentId = accSampleRecord3.id,
                                    CMI_Region__c = 'East Asia',
                                    IAM_Internal_Account__c = True,
                                    Type = 'Internal',
                                    CMI_Cummins_Support_Email__c = 'abc987@gmail.com'
                                    );
    
    insert accSampleRecord6;
    
    
    CMI_TSP__c CMITSP = new CMI_TSP__c();
    CMITSP.CMI_Account_Name__c = accSampleRecord4.id;
    CMITSP.CMI_TSP_Name__c = 'Shaw Tracking';
    CMITSP.CMI_TSP_Id__c = 'Test';
    insert CMITSP;
    
    //CMI_Account_Status__c = 'Active',
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
    
    Contact contSampleRecord1 = new Contact(
        FirstName = 'Test02',
        LastName ='User02',
        Email = 'lstTest2323@test.com',
        AccountId = accSampleRecord3.ID,
        IAM_Contact_Status__c = 'Active',
        CMI_Contact_Type__c = 'Secondary',
        Username__c = 'Amartest213@abc.com',
        Phone = '9743800309'
    );
    
    insert contSampleRecord1;
    
    Contact contSampleRecord2 = new Contact(
        FirstName = 'Test02xx',
        LastName ='User02xx',
        Email = 'lstTestData2323xx@test.com',
        AccountId = accSampleRecord4.ID,
        IAM_Contact_Status__c = 'Pending',
        CMI_Contact_Type__c = 'Secondary',
        Username__c = 'Amartest213xx@abc.com',
        Phone = '9743800309'
    );
    
    insert contSampleRecord2;
    
    Contact contSampleRecordGuidanzMobTest = new Contact(
        FirstName = 'Test02',
        LastName ='User02',
        Email = 'lstTest2323xdx@test.com',
        AccountId = accSampleRecord.ID,
        IAM_Contact_Status__c = 'Active',
        CMI_Contact_Type__c = 'Secondary',
        Username__c = 'Amartest21dfd3@abc.com',
        Phone = '9743800309'
    );
    insert contSampleRecordGuidanzMobTest;
    
    Contact contconnectedsol = new Contact(
        FirstName = 'Test02',
        LastName ='User02',
        Email = 'lstTest2323jjl@test.com',
        AccountId = accSampleRecord3.ID,
        IAM_Contact_Status__c = 'Active',
        CMI_Contact_Type__c = 'Secondary',
        Username__c = 'Amartest213uio@abc.com',
     
        Phone = '9743800309'
    );
    
    insert contconnectedsol;
    
    Contact contRecord = new Contact(
        FirstName = 'Testwe',
        LastName ='Userfr',
        Email = 'Testuser1234@test.com',
        AccountId = accSampleRecord.ID,
        IAM_Contact_Status__c = 'Active',
        CMI_Contact_Type__c = 'Secondary',
        Username__c ='Testuser1234@test.com',
        Phone = '9743800309'
    );
    
    insert contRecord;
    
    
    Contact contRecordfield = new Contact(
        FirstName = 'Testwe',
        LastName ='Userfr',
        Email = 'Testuser1234@testfieldtest.com',
        AccountId = accSampleRecord2.ID,
        IAM_Contact_Status__c = 'Active',
        CMI_Contact_Type__c = 'Secondary',
        Username__c ='Testuser1234@testfieldtest.com',
        Phone = '9743800309'
    );
    
    insert contRecordfield;
    // Profile id of 'IAM_Site_Admin_Community'
    //String profId = '00eZ0000000FMDr';
    Id profId  = [SELECT Id,Name FROM Profile Where name = 'IAM_Site_Admin_Community'].Id;
    
    User uesrSampleRecord = new User(
        LastName = 'lstTest',
        FirstName = 'frstTest',
        Email = 'lstTest@test.com',
        Alias = 'lsTest',
        Username = 'lstTest@test.com',
        CommunityNickname = 'lstest1234',
        LocaleSidKey= 'en_US',
        TimeZoneSidKey ='GMT',
        ProfileID = profId,
        LanguageLocaleKey = 'en_US',
        EmailEncodingKey = 'UTF-8',
        contactId = contSampleRecord.Id,
        isActive = true
    );
    
   insert uesrSampleRecord;
   
    
    User uesrSampleRecord2 = new User(
        LastName = 'User02',
        FirstName = 'Test02',
        Email = 'lstTest2323@test.com',
        Alias = 'lsTes2',
        Username = 'lstTest2323@test.com',
        LocaleSidKey= 'en_US',
        TimeZoneSidKey ='GMT',
        ProfileID = profId,
        LanguageLocaleKey = 'en_US',
        EmailEncodingKey = 'UTF-8',
        isActive = false,
        contactId = contSampleRecord1.Id
        );
    
    //insert uesrSampleRecord2;
    
    User uesrSampleRecord3 = new User(
        LastName = 'User02',
        FirstName = 'Test02',
        Email = 'lstTestData2323@test.com',
        Alias = 'lsTes2',
        Username = 'lstTestData2323@test.com',
        LocaleSidKey= 'en_US',
        TimeZoneSidKey ='GMT',
        ProfileID = profId,
        LanguageLocaleKey = 'en_US',
        EmailEncodingKey = 'UTF-8',
        isActive = false,
        contactId = contSampleRecord2.Id
        );
    
    IAM_Application_Groups__c iamAppGrp = new IAM_Application_Groups__c ();
        iamAppGrp.IAM_Application_Name__c = 'PowerSpec';
        iamAppGrp.IAM_Role_Name__c = 'PowerSpec_Basic';
        iamAppGrp.IAM_DN_value__c = 'cn=PowerSpec_Basic,ou=APP_PowerSpec,ou=application,dc=cummins,dc=com';
        iamAppGrp.Name = 'Power Spec 1.6';
        iamAppGrp.IAM_Group_Type__c = 'static';
        insert iamAppGrp;
   // insert uesrSampleRecord3;
    
    Test.stopTest();
    
    IAM_Application__c iamAppSampleRecord = new IAM_Application__c(    
        IAM_Account_Name__c = accSampleRecord.ID,
        IAM_Application_Name__c = 'EDS',
        IAM_Role__c='EDS_ADMIN_USER',
        IAM_Status__c='Active',
        IAM_Subscription_Count__c= 10,
        IAM_Provisioned_User_Count__c=5,
        IAM_Subscription_End_Date__c= System.today() + 5,
        IAM_Subscription_Name__c='TestSubscription1',
        IAM_Free_Subscription__c= False,
        IAM_Subscription_Start_Date__c=System.today(),
        IAM_Customer_Code__c='1339'
    );
    //insert iamAppSampleRecord ;
    lstApplication.add(iamAppSampleRecord);
    
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
    
    //insert cumpasApplication;
    lstApplication.add(cumpasApplication);
    
    IAM_Application__c connectedSolApplication = new IAM_Application__c(    
        IAM_Account_Name__c = accSampleRecord.ID,
        IAM_Application_Name__c = 'Connected Solutions',
        IAM_Role__c='PrimaryContact',
        IAM_Status__c='Active',
        IAM_Subscription_Count__c= 10,
        IAM_Provisioned_User_Count__c=5,
        IAM_Subscription_End_Date__c= System.today() + 5,
        IAM_Subscription_Name__c='TestSubscription1',
        IAM_Free_Subscription__c= True,
        IAM_Subscription_Start_Date__c=System.today(),
        IAM_Customer_Code__c='1339'
    );
    
    //insert connectedSolApplication;
    lstApplication.add(connectedSolApplication);
    
    IAM_Application__c connectedSolApplication02 = new IAM_Application__c(    
        IAM_Account_Name__c = accSampleRecord2.ID,
        IAM_Application_Name__c = 'Connected Solutions',
        IAM_Role__c='PrimaryContact',
        IAM_Status__c='Inactive',
        IAM_Subscription_Count__c= 10,
        IAM_Provisioned_User_Count__c=5,
        IAM_Subscription_End_Date__c= System.today() + 5,
        IAM_Subscription_Name__c='TestSubscription1',
        IAM_Free_Subscription__c= True,
        IAM_Subscription_Start_Date__c=System.today(),
        IAM_Customer_Code__c='554332'
    );
    
    //insert connectedSolApplication02;
    lstApplication.add(connectedSolApplication02);
    
    IAM_Application__c connectedSolApplication03 = new IAM_Application__c(    
        IAM_Account_Name__c = accSampleRecord3.ID,
        IAM_Application_Name__c = 'Connected Solutions',
        IAM_Role__c='PrimaryContact',
        IAM_Status__c='Active',
        IAM_Subscription_Count__c= 10,
        IAM_Provisioned_User_Count__c=5,
        IAM_Subscription_End_Date__c= System.today() + 5,
        IAM_Subscription_Name__c='TestSubscription234av',
        IAM_Free_Subscription__c= True,
        IAM_Source__c = 'Marketplace',
        IAM_Subscription_Start_Date__c=System.today(),
        IAM_Customer_Code__c='01339'
    );
    
    //insert connectedSolApplication03;
    lstApplication.add(connectedSolApplication03);
    
    IAM_Application__c cumminsServiceTraining = new IAM_Application__c(    
        IAM_Account_Name__c = accSampleRecord.ID,
        IAM_Application_Name__c = 'Cummins Service Training',
        IAM_Role__c='Service Training User',
        IAM_Status__c='Active',
        IAM_Subscription_Count__c= 10,
        IAM_Provisioned_User_Count__c=5,
        IAM_Subscription_End_Date__c= System.today() + 5,
        IAM_Subscription_Name__c='TestSubscription399890',
        IAM_Free_Subscription__c= False,
        IAM_Subscription_Start_Date__c=System.today(),
        IAM_Customer_Code__c='1339'
    );
    
    lstApplication.add(cumminsServiceTraining);
    
    IAM_Application__c QuickServeOnline = new IAM_Application__c(    
        IAM_Account_Name__c = accSampleRecord3.ID,
        IAM_Application_Name__c = 'QuickServe Online',
        IAM_Role__c='QSOL Dealer',
        IAM_Status__c='Active',
        IAM_Subscription_Count__c= 10,
        IAM_Provisioned_User_Count__c=5,
        IAM_Subscription_End_Date__c= System.today() + 5,
        IAM_Subscription_Name__c='TestSubscriptionquickServeOnline',
        IAM_Free_Subscription__c= False,
        IAM_Qsolexpiration__c = 'Test',
        IAM_Subscription_Start_Date__c=System.today(),
        IAM_Customer_Code__c='01339'
    );
    
    lstApplication.add(QuickServeOnline);
    
    IAM_Application__c GuidanzMobileTest02 = new IAM_Application__c(    
        IAM_Account_Name__c = accSampleRecord3.ID,
        IAM_Application_Name__c = 'Guidanz Mobile',
        IAM_Role__c='Guidanz Mobile Campaign Dealer',
        IAM_Status__c='Active',
        IAM_Subscription_Count__c= 10,
        IAM_Provisioned_User_Count__c=5,
        IAM_Subscription_End_Date__c= System.today() + 5,
        IAM_Subscription_Name__c='TestSubscription1GuidanzMobTest02',
        IAM_Free_Subscription__c= False,
        IAM_Subscription_Start_Date__c=System.today(),
        IAM_swregExpire__c = 'Test',
        IAM_Customer_Code__c='01339'
        );
        
    lstApplication.add(GuidanzMobileTest02);
    
    IAM_Application__c connectedSolApplication04 = new IAM_Application__c(    
        IAM_Account_Name__c = accSampleRecord3.ID,
        IAM_Application_Name__c = 'Marketplace',
        IAM_Role__c='OSM Sales User',
        IAM_Status__c='Active',
        IAM_Subscription_Count__c= 10,
        IAM_Provisioned_User_Count__c=5,
        IAM_Subscription_End_Date__c= System.today() + 5,
        IAM_Subscription_Name__c='TestSubscription3997',
        IAM_Free_Subscription__c= False,
        IAM_Subscription_Start_Date__c=System.today(),
        IAM_Customer_Code__c='01339'
    );
    
    //insert connectedSolApplication04;
    //lstApplication.add(connectedSolApplication04);
    
    IAM_Application__c GuidanzApplication02 = new IAM_Application__c(    
        IAM_Account_Name__c = accSampleRecord.ID,
        IAM_Application_Name__c = 'Guidanz',
        IAM_Role__c='Advanced',
        IAM_Status__c='Active',
        IAM_Subscription_Count__c= 10,
        IAM_Provisioned_User_Count__c=5,
        IAM_Subscription_End_Date__c= System.today() + 5,
        IAM_Subscription_Name__c='TestSubscription1',
        IAM_Free_Subscription__c= False,
        IAM_Subscription_Start_Date__c=System.today(),
        IAM_Customer_Code__c='1339'
    );
    
    //insert GuidanzApplication02;
    lstApplication.add(GuidanzApplication02);
    
    IAM_Application__c MarketplaceApplication02 = new IAM_Application__c(    
        IAM_Account_Name__c = accSampleRecord.ID,
        IAM_Application_Name__c = 'Marketplace',
        IAM_Role__c='OSM Business Admin',
        IAM_Status__c='Active',
        IAM_Subscription_Count__c= 10,
        IAM_Provisioned_User_Count__c=5,
        IAM_Subscription_End_Date__c= System.today() + 5,
        IAM_Subscription_Name__c='TestSubscription1',
        IAM_Free_Subscription__c= False,
        IAM_Subscription_Start_Date__c=System.today(),
        IAM_Customer_Code__c='1339'
    );
    
    //insert MarketplaceApplication02;
    //lstApplication.add(MarketplaceApplication02);
    
         IAM_Application__c GuidanzMobile = new IAM_Application__c(    
        IAM_Account_Name__c = accSampleRecord.ID,
        IAM_Application_Name__c = 'Guidanz Mobile',
        IAM_Role__c='Guidanz Mobile Campaign Dealer',
        IAM_Status__c='Active',
        IAM_Subscription_Count__c= 10,
        IAM_Provisioned_User_Count__c=5,
        IAM_Subscription_End_Date__c= System.today() + 5,
        IAM_Subscription_Name__c='TestSubscription1GuidanzMob',
        IAM_Free_Subscription__c= False,
        IAM_Subscription_Start_Date__c=System.today(),
        IAM_swregExpire__c = 'Test',
             IAM_Customer_Code__c='1339'
        );
    
    //insert GuidanzMobile;   
    lstApplication.add(GuidanzMobile);
    
    IAM_Application__c GuidanzMobileTest = new IAM_Application__c(    
        IAM_Account_Name__c = accSampleRecord4.ID,
        IAM_Application_Name__c = 'Connected Solutions',
        IAM_Role__c='PrimaryContact',
        //IAM_Status__c='Active',
        IAM_Status__c='Inactive',
        IAM_Subscription_Count__c= 10,
        IAM_Provisioned_User_Count__c=5,
        IAM_Subscription_End_Date__c= System.today() + 5,
        IAM_Subscription_Name__c='TestSubscription1GuidanzMobTest',
        IAM_Free_Subscription__c= False,
        IAM_Subscription_Start_Date__c=System.today(),
        IAM_swregExpire__c = 'Test',
        IAM_Customer_Code__c='332019'
        );
    
    //insert GuidanzMobile;   
    lstApplication.add(GuidanzMobileTest);
    
    insert lstApplication;

 IAM_Contact_Provisioning__c iamContSampleRecord = new IAM_Contact_Provisioning__c(
        //IAM_Account_Application__c = iamAppSampleRecord.ID,
        IAM_Account_Application__c = cumpasApplication.ID,
        RecordTypeId = Schema.SObjectType.IAM_Contact_Provisioning__c.getRecordTypeInfosByName().get('CUMPAS 2.0').getRecordTypeId(),
        IAM_Application_Name__c = 'CUMPAS 2.0',
        IAM_Contact__c= contSampleRecord.Id,
        IAM_End_Date__c= System.today() + 5,
        IAM_Role__c='Dealer User',
        IAM_Start_Date__c=System.today(),
        IAM_Status__c='Active',
        IAM_Cumpas_Modularity__c = 'Core Returns'
        //recordtypeid = Schema.SObjectType.IAM_Contact_Provisioning__c.getRecordTypeInfosByName().get('EDS').getRecordTypeId()
    );
    insert iamContSampleRecord;    
    lstconPro.add(iamContSampleRecord);
    
    IAM_Contact_Provisioning__c iamContSampleRecord1 = new IAM_Contact_Provisioning__c(
        IAM_Account_Application__c = cumpasApplication.ID,
        RecordTypeId = Schema.SObjectType.IAM_Contact_Provisioning__c.getRecordTypeInfosByName().get('CUMPAS 2.0').getRecordTypeId(),
        IAM_Application_Name__c = 'CUMPAS 2.0',
        IAM_Contact__c= contSampleRecord1.Id,
        IAM_End_Date__c= System.today() + 5,
        IAM_Role__c='Dealer User',
        IAM_Start_Date__c=System.today(),
        IAM_Status__c='Active',
        IAM_Cumpas_Modularity__c = 'View Credit'
        );
   insert iamContSampleRecord1; 
   lstconPro.add(iamContSampleRecord1);
   
   IAM_Contact_Provisioning__c iamContSampleRecord1Test = new IAM_Contact_Provisioning__c(
        IAM_Account_Application__c = cumpasApplication.ID,
        RecordTypeId = Schema.SObjectType.IAM_Contact_Provisioning__c.getRecordTypeInfosByName().get('CUMPAS 2.0').getRecordTypeId(),
        IAM_Application_Name__c = 'CUMPAS 2.0',
        IAM_Contact__c= contSampleRecord.Id,
        IAM_End_Date__c= System.today() + 5,
        IAM_Role__c='Dealer User',
        IAM_Start_Date__c=System.today(),
        IAM_Status__c='Active',
        IAM_Cumpas_Modularity__c = 'View Credit'
        );
   //insert iamContSampleRecord1Test;   
   //lstconPro.add(iamContSampleRecord1Test);
   
   IAM_Contact_Provisioning__c iamContSampleRecord1Test02 = new IAM_Contact_Provisioning__c(
        IAM_Account_Application__c = cumpasApplication.ID,
        RecordTypeId = Schema.SObjectType.IAM_Contact_Provisioning__c.getRecordTypeInfosByName().get('CUMPAS 2.0').getRecordTypeId(),
        IAM_Application_Name__c = 'CUMPAS 2.0',
        IAM_Contact__c= contSampleRecord.Id,
        IAM_End_Date__c= System.today() + 5,
        IAM_Role__c='Dealer User',
        IAM_Start_Date__c=System.today(),
        IAM_Status__c='Active',
        IAM_Cumpas_Modularity__c = 'View Credit'
        );
        
   //insert iamContSampleRecord1Test02; 
   //lstconPro.add(iamContSampleRecord1Test02);
   
   
   
   IAM_Contact_Provisioning__c iamContSampleRecordConnectedSol = new IAM_Contact_Provisioning__c(
        IAM_Account_Application__c = connectedSolApplication03.ID,
        RecordTypeId = Schema.SObjectType.IAM_Contact_Provisioning__c.getRecordTypeInfosByName().get('Connected Solutions').getRecordTypeId(),
        IAM_Application_Name__c = 'Connected Solutions',
        IAM_Contact__c= contSampleRecord1.Id,
        IAM_End_Date__c= System.today() + 5,
        IAM_Role__c='PrimaryContact',
        IAM_Start_Date__c=System.today(),
        IAM_Status__c='Active'
        );
   //insert iamContSampleRecordConnectedSol; 
   lstconPro.add(iamContSampleRecordConnectedSol);
   
   IAM_Contact_Provisioning__c iamContSampleRecordGuidanzMob = new IAM_Contact_Provisioning__c(
        IAM_Account_Application__c = GuidanzMobile.ID,
        RecordTypeId = Schema.SObjectType.IAM_Contact_Provisioning__c.getRecordTypeInfosByName().get('Guidanz Mobile').getRecordTypeId(),
        IAM_Application_Name__c = 'Guidanz Mobile',
        IAM_Contact__c= contSampleRecord.Id,
        IAM_End_Date__c= System.today() + 5,
        IAM_Role__c='Guidanz Mobile Campaign Dealer',
        IAM_Start_Date__c=System.today(),
        IAM_Status__c='Active'
        );
   //insert iamContSampleRecordGuidanzMob; 
   lstconPro.add(iamContSampleRecordGuidanzMob);
   
   //insert lstconPro;
   
    
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
    
   /*IAM_Application__c MarketplaceApplication09 = new IAM_Application__c(    
        IAM_Account_Name__c = accSampleRecord5.ID,
        IAM_Application_Name__c = 'Marketplace',
        IAM_Role__c='OSM Storefront Admin',
        IAM_Status__c='Active',
        IAM_Subscription_Count__c= 10,
        IAM_Provisioned_User_Count__c=5,
        IAM_Subscription_End_Date__c= System.today() + 5,
        IAM_Subscription_Name__c='TestSubscription1',
        IAM_Free_Subscription__c= False,
        IAM_Subscription_Start_Date__c=System.today(),
        IAM_Customer_Code__c='1339'
    );
    
    insert MarketplaceApplication09; */  
       
  Contact contSampleRecordosm = new Contact(
        FirstName = 'Test',
        LastName ='User',
        Email = 'lstTestosm@test.com',
        AccountId = accSampleRecord4.ID,
        IAM_Contact_Status__c = 'Active',
        CMI_Contact_Type__c = 'Secondary',
        IAM_Legacy_User__c=true,
        IAM_Internal__c=true,
        recordtypeid=Schema.SObjectType.Contact.getRecordTypeInfosByName().get('IAM').getRecordTypeId(),
        Username__c = 'lstTestosm@abc.com',
        Phone = '9743800309'
    );
    insert contSampleRecordosm;
       IAM_Application__c fleetfitrcd = new IAM_Application__c(    
        IAM_Account_Name__c = accSampleRecord4.ID,
        IAM_Application_Name__c = 'Fleetguard FIT',
        IAM_Role__c='User',
        IAM_Status__c='Active',
        IAM_Subscription_Count__c= 10,
        IAM_Provisioned_User_Count__c=5,
        IAM_Subscription_End_Date__c= System.today() + 5,
        IAM_Free_Subscription__c= False,
        IAM_Subscription_Start_Date__c=System.today()
    );
    insert fleetfitrcd;
    
    IAM_Application__c fieldTestGM = new IAM_Application__c(    
        IAM_Account_Name__c = accSampleRecord4.ID,
        IAM_Application_Name__c = 'Field Test Guidanz Mobile',
        IAM_Subscription_Name__c = 'Field Test CMP Guidanz Mobile',
        IAM_Role__c='Field Test CMP Guidanz Mobile',
        IAM_Status__c='Active',
        IAM_swregExpire__c = 'CMPF-12/31/2100',
        IAM_Total_Units__c = 2,
        recordtypeID=Schema.SObjectType.IAM_Application__c.getRecordTypeInfosByName().get('Field Test Guidanz Mobile').getRecordTypeId(),
        IAM_Subscription_Count__c= 10,
        IAM_Provisioned_User_Count__c=5,
        IAM_Subscription_End_Date__c= System.today() + 5,
        IAM_Free_Subscription__c= False,
        IAM_Subscription_Start_Date__c=System.today()
    );
    insert fieldTestGM;
    
    IAM_Application__c fieldTestGMBeta = new IAM_Application__c(    
        IAM_Account_Name__c = accSampleRecord6.ID,
        IAM_Application_Name__c = 'Field Test Guidanz Mobile',
        IAM_Subscription_Name__c = 'Beta Testing Guidanz Mobile',
        IAM_Role__c='Beta Testing Guidanz Mobile',
        IAM_Status__c='Active',
        IAM_swregExpire__c = 'BTGF-12/31/2100',
        IAM_Total_Units__c = 2,
        recordtypeID=Schema.SObjectType.IAM_Application__c.getRecordTypeInfosByName().get('Field Test Guidanz Mobile').getRecordTypeId(),
        IAM_Subscription_Count__c= 10,
        IAM_Provisioned_User_Count__c=5,
        IAM_Subscription_End_Date__c= System.today() + 5,
        IAM_Free_Subscription__c= False,
        IAM_Subscription_Start_Date__c=System.today()
    );
    insert fieldTestGMBeta;
    
    Contact contSampleRecordFTGM = new Contact(
        FirstName = 'Test',
        LastName ='User',
        Email = 'lstTestFTGM@test.com',
        AccountId = accSampleRecord6.ID,
        IAM_Contact_Status__c = 'Active',
        CMI_Contact_Type__c = 'Secondary',
        IAM_Legacy_User__c=true,
        IAM_Internal__c=true,
        recordtypeid=Schema.SObjectType.Contact.getRecordTypeInfosByName().get('IAM').getRecordTypeId(),
        Username__c = 'lstTestFTGM@abc.com',
        Phone = '9743800309'
    );
    insert contSampleRecordFTGM;
}
    
     
    @isTest
    static void testGetsObjectInfo(){
         Test.startTest();
        Account accRecord = [Select Id From Account Where name = 'AccountTest1'];
        
        Contact contRecord = [Select Id From Contact Where FirstName = 'Test' and LastName = 'User' LIMIT 1];
        
        IAM_Application__c iamAppRecord = [Select Id from IAM_Application__c 
                                                        where IAM_Account_Name__c = :accRecord.ID AND IAM_Application_Name__c = 'CUMPAS 2.0' LIMIT 1];
        
        IAM_Contact_Provisioning__c iamContactRecord = [Select Id from IAM_Contact_Provisioning__c 
                                                        where IAM_Account_Application__c = :iamAppRecord.ID LIMIT 1];
                                                        
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        
        //HttpResponse res = CalloutClass.getInfoFromExternalService();                                              
       
        IAM_AccountsController.getsObjectInfo(accRecord.Id);
        IAM_AccountsController.getsObjectInfo(contRecord.Id);
        IAM_AccountsController.getsObjectInfo(iamAppRecord.Id);
        IAM_AccountsController.getsObjectInfo(iamContactRecord.Id);
        Test.stopTest();
    }
    
    @isTest
    static void testUnlockButton(){
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        
        //HttpResponse res = CalloutClass.getInfoFromExternalService();
        Test.StartTest();
        Contact contRecord = [Select Id From Contact Where FirstName = 'Test' and LastName = 'User' LIMIT 1];
        IAM_AccountsController.unlockButton(contRecord.Id);
        
        User userRecord = [Select Id From User where Email = 'lstTest@test.com'];
        UserLogin userLoginRecord=[Select IsPasswordLocked from UserLogin where userid=:userRecord.id];
        //userLoginRecord.IsPasswordLocked = true;
  
        update userLoginRecord;
        
        IAM_AccountsController.unlockButton(contRecord.Id);    
        Test.StopTest(); 
    }
    
    @isTest
    static void testContact(){   
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        
        //HttpResponse res = CalloutClass.getInfoFromExternalService();
             
        Contact contRecord = [Select Id From Contact Where FirstName = 'Test' and LastName = 'User' LIMIT 1 ];
        Contact contact= [SELECT Id,Name FROM Contact WHERE Email = 'lstTest2323@test.com'];
        Contact cont = [SELECT Id,Name FROM Contact WHERE Email = 'lstTest@test.com' LIMIT 1];
        Account accRecord = [Select Id From Account Where name = 'AccountTest1'];
        User user = [SELECT Id,Name FROM User WHERE Username = 'lstTest@test.com' or Email='lstTest@test.com'];
        map<string,list<string>> applicationmap = new map<string,list<string>>(); 
        list<string> lstroles = new list<string>();
        lstroles.add('Channel Admin');
        lstroles.add('External User');
        applicationmap.put('EDS',lstroles);
        
        IAM_AccountsController.resetButton(contRecord.Id);
        
        Test.startTest();
        IAM_AccountsController.wrkGrpRegions(contRecord.Id);
        IAM_AccountsController.getAccountList('regionName');
        IAM_AccountsController.ProcessSubscriptionAppRec(contRecord.Id, 'TestSubscription1', new List<String>{'EDS_AUTHOR', 'EDS_ADMIN_USER'},applicationmap,4);
        IAM_AccountsController.ProcessSubscriptionAppRec(contact.Id, 'TestSubscription1', new List<String>{'EDS_AUTHOR', 'EDS_ADMIN_USER'},applicationmap,4);
        IAM_AccountsController.ProcessSubscriptionAppRec(contact.Id, 'TestSubscription1', new List<String>{'EDS_AUTHOR', 'EDS_ADMIN_USER'},applicationmap,4);
        IAM_AccountsController.ProcessSubscriptionAppRec(contact.Id, 'TestSubscription399890', new List<String>{'EDS_AUTHOR', 'EDS_ADMIN_USER'},applicationmap,4);
        //IAM_AccountsController.ProcessSubscriptionAppRec(cont.Id, 'TestSubscription1', new List<String>{'EDS_AUTHOR', 'EDS_ADMIN_USER'},applicationmap);
        //IAM_AccountsController.AccountsList(contRecord.Id, '0014C00000CmgDwQAJ');
        IAM_AccountsController.AccountsList(contRecord.Id, accRecord.Id,'Test');
        //IAM_AccountsController.AccountsList(contRecord.Id, 'selectedDistributor');
        IAM_AccountsController.assaignWrokGrpID(contRecord.Id, new List<Account>());
        IAM_AccountsController.getPrimaryLocation(contRecord.Id);
        
        IAM_AccountsController.saveApplication(contRecord.Id, new Map<String,String>{'Application' => 'EDS', 'Subscription' => 'TestSubscription1'});
        IAM_AccountsController.saveFreeApp(contRecord.Id, new Map<String,String>{'Application' => 'EDS', 'Role' => 'EDS_ADMIN_USER'}, 'EDS');
       // IAM_AccountsController.saveFreeAppCumpas(contRecord.Id, new Map<String,String>{'Application' => 'EDS', 'Role' => 'EDS_ADMIN_USER'}, 'EDS', new List<String>{'AB'});
        
        IAM_AccountsController.setPassword(contRecord.Id , 'Reset Password');
        IAM_AccountsController.setPassword(contRecord.Id , 'Unlock');
        //System.runAs(user){
            //IAM_AccountsController.GetSubcriptionNames(contRecord.Id, 'Test');
            IAM_AccountsController.getApplicationNames(contRecord.Id, 'TestSubscription1'); 
        //}
        Test.stopTest();
    }
   
   @isTest
    static void testContact02(){   
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        
        //HttpResponse res = CalloutClass.getInfoFromExternalService();
             
        Contact contRecord = [Select Id,IAM_Site_Admin__c,IAM_Legacy_User__c,IAM_Site_Admin_Role__c,FirstName,LastName,Email,IAM_Internal__c, Account.OwnerId,Account.CMI_Account_Num__c,Phone,IAM_Contact_Status__c,IAM_Applications__c,IAM_Final_Approver__c,Username__c,IAM_Work_Group_Id__c,CMI_Contact_Type__c,IAM_is_Member_of__c,IAM_Product_Group_Access__c,Account.Location__c,Account.Recordtype.Name,Account.BillingStreet,Account.BillingCity,Account.BillingCountry,Account.BillingPostalCode,Account.IAM_ABO_Code_Formula__c,Account.IAM_Service_Provider_Code__c,Account.CSS_DBCode__c,Account.CSS_DistributorCode__c,Account.parentid,Accountid,Account.Name,Account.CMI_Account_Status__c,Account.CSS_Language__c,Account.CMI_CDA_Status__c,Account.CMI_CId__c,Account.CSS_EmailEncoding__c,Account.CSS_Timezone__c,Account.CSS_Locale__c,Account.Type,Account.IAM_WWSPS_Regions__c,Account.IAM_Movex_Customer_Code__c From Contact Where FirstName = 'Test' and LastName = 'User' LIMIT 1 ];
        //contact where id=:recordid Limit 1];
            
       
        Contact contact= [SELECT Id,Name FROM Contact WHERE Email = 'lstTest2323@test.com'];
        Contact cont = [SELECT Id,Name FROM Contact WHERE Email = 'lstTest@test.com' LIMIT 1];
        Account accRecord = [Select Id From Account Where name = 'AccountTest1'];
        User user = [SELECT Id,Name,username,IAM_Deactivation_Mail_Sent__c,FederationIdentifier,IAM_UID__c,isActive FROM User WHERE Username = 'lstTest@test.com' or Email='lstTest@test.com'];
        
        map<string,list<string>> applicationmap = new map<string,list<string>>(); 
        list<string> lstroles = new list<string>();
        lstroles.add('Channel Admin');
        lstroles.add('External User');
        applicationmap.put('EDS',lstroles);
        
        Test.startTest();
        
        IAM_AccountsController.resetButton(contRecord.Id);
        
        //IAM_AccountsController.accUpdate(contRecord.Id, 'Activate','Other','Other');
        IAM_AccountsController.accUpdate(contRecord.Id, 'De-Activate','Other','Other');
        IAM_AccountsController.accUpdate(contRecord.Id, 'De-Activate','Test','Test');
        IAM_AccountsController.accUpdate(contRecord.Id, 'Activate','Test','Test');
        IAM_AccountsController.ActivateContact(contRecord.Id, 'Activate');
        IAM_AccountsController.ActivateContact(contRecord.Id, 'Test');
        IAM_AccountsController.ActivateContact(contRecord.Id , 'De-Activate');
        IAM_AccountsController.ActivateContact(contRecord.Id , ''); //added on 14/05
              
        IAM_AccountsController.appDelete(contRecord.Id, 'De-Activate','Test');        
        IAM_AccountsController.getApplicationNames(contRecord.Id, 'TestSubscription1');        
        IAM_AccountsController.getModularandRole(contRecord.Id, 'Test');
        IAM_AccountsController.getModularandRole(contRecord.Id, 'Connected Solutions');
        IAM_AccountsController.getModularandRole(cont.Id, 'CUMPAS 2.0');
        
        //System.runAs(user){
            //IAM_AccountsController.GetSubcriptionNames(contRecord.Id, 'Test');
            IAM_AccountsController.getApplicationNames(contRecord.Id, 'TestSubscription1'); 
        //}
        Test.stopTest();
    }
    
   @isTest
    static void testContact1(){
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        User user = [SELECT Id,Name FROM User WHERE Username = 'lstTest@test.com' OR Email='lstTest@test.com' ];
        Test.startTest();
        //HttpResponse res = CalloutClass.getInfoFromExternalService();
        Contact contRecord = [Select Id From Contact Where FirstName = 'Test' and LastName = 'User' LIMIT 1];
        IAM_AccountsController.ActivateContact(contRecord.Id , 'De-Activate');
        IAM_AccountsController.ActivateContact(contRecord.Id , 'Test');
         
        Test.stopTest();
    }
    
    @isTest
    static void testAccount(){
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        Test.startTest();
        //HttpResponse res = CalloutClass.getInfoFromExternalService();
        Account accRecord = [Select Id From Account Where name = 'AccountTest1'];
        
         Account accRecord2 = [Select Id From Account Where name = 'AccountTest2'];
         
         Account accRecord3 = [Select Id From Account Where name = 'AccountTest3'];
        
        Account acc = [SELECT RecordType.name, CMI_Account_Status__c, CMI_Moratorium_End_Date__c, CMI_CDA_Status__c,
                       CMI_Request_withdrawn__c, CMI_Moratorium__c
                       FROM Account where id=  :accRecord2.Id];
        
       
        
        IAM_AccountsController.SendPCInfo(accRecord2.Id, 'Activate');
        IAM_AccountsController.SendPCInfo(accRecord2.Id, 'De-Activate');
        IAM_AccountsController.SendPCInfo(accRecord2.Id, 'ErrorData');
        //IAM_AccountsController.SendPCInfo('IncorrectId', 'ErrorData'); Check to know how to cover exception code in controller class
        IAM_AccountsController.SendPCInfo(accRecord3.Id, 'De-Activate');
        IAM_AccountsController.accUpdate(accRecord.Id, 'Activate','Other','Other');
        IAM_AccountsController.accUpdate(accRecord.Id, 'De-Activate','Other','Other');
        IAM_AccountsController.accUpdate(accRecord.Id, 'Generate Service Agreement','Other','Other');
        IAM_AccountsController.accUpdate(accRecord.Id, 'ErrorData','Other','Other');
        IAM_AccountsController.accUpdate(accRecord.Id, 'Activate','Test','Test');       
        IAM_AccountsController.generateCDA(accRecord.Id, 'Activate');        
         IAM_AccountsController.generateUser(accRecord.Id, 'Activate');
        //acc.IsCustomerPortal=true;
        //update acc;
        //IAM_AccountsController.generateCDA(accRecord.Id, 'Activate');
        Test.stopTest();
        
    }
    
    // Test method to check validation condition generateUser method
    @isTest
    static void testGenerateUserPart1(){
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        Test.startTest();
        //HttpResponse res = CalloutClass.getInfoFromExternalService();
         Account accRecord = [Select Id From Account Where name = 'AccountTest1'];
        Account accRecord2 = [Select Id From Account Where name = 'AccountTest2'];
        Account acc = [SELECT RecordType.name, CMI_Account_Status__c, CMI_Moratorium_End_Date__c, CMI_CDA_Status__c,
                       CMI_Request_withdrawn__c, CMI_Moratorium__c
                       FROM Account where id=:accRecord2.Id];
        
       // acc.RecordtypeId='0124C000000ClDQQA0';
        acc.RecordtypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('PC_API').getRecordTypeId();
        acc.IsCustomerPortal=false;
        acc.CMI_Account_Status__c='Active-Indemnified';
        acc.CMI_Moratorium_End_Date__c=date.today()-5;
        acc.CMI_CDA_Status__c='';
        acc.CMI_Request_withdrawn__c=false;
        acc.CMI_Moratorium__c='Yes';
        
        update acc;
        
        IAM_AccountsController.generateUser(accRecord2.Id, 'Activate');
        Test.stopTest();
    }
    
    @isTest
    static void testGenerateUserPart2(){
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        Test.startTest();
        //HttpResponse res = CalloutClass.getInfoFromExternalService();
         Account accRecord2 = [Select Id From Account Where name = 'AccountTest2'];
        Account acc = [SELECT RecordType.name, CMI_Account_Status__c, CMI_Moratorium_End_Date__c, CMI_CDA_Status__c,
                       CMI_Request_withdrawn__c, CMI_Moratorium__c
                       FROM Account where id=:accRecord2.Id];
        
        acc.CMI_Request_withdrawn__c = True;    
        update acc;
        
        IAM_AccountsController.generateUser(accRecord2.Id, 'Activate');
        Test.stopTest();
    }
    
    
    
    @isTest
    static void testIAMContactProvisioning(){
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        
        //HttpResponse res = CalloutClass.getInfoFromExternalService();
        Test.startTest();
        Account accRecord = [Select Id From Account Where name = 'AccountTest1'];
        
        IAM_Application__c iamAppRecord = [Select Id from IAM_Application__c 
                                                        where IAM_Account_Name__c = :accRecord.ID AND IAM_Application_Name__c = 'CUMPAS 2.0' LIMIT 1];
        
        IAM_Contact_Provisioning__c iamContactRecord = [Select Id from IAM_Contact_Provisioning__c 
                                                        where IAM_Account_Application__c = :iamAppRecord.ID AND IAM_Application_Name__c = 'CUMPAS 2.0' LIMIT 1 ];
         // Id recordId_IAM_Contact_Provisioning = 'a3H4C000000Hk9wUAC';        
        //Test for IDM_Contact_Provisioning__c
        //IAM_AccountsController.getsObjectInfo(iamContactRecord.Id);
        //System.assertEquals('IAM_Contact_Provisioning__c', IAM_AccountsController.getName(iamContactRecord.Id));
        
        IAM_Contact_Provisioning__c contactProvi = [Select id, IAM_Status__c 
                                                    from IAM_Contact_Provisioning__c 
                                                    where id=:iamContactRecord.Id LIMIT 1];
        contactProvi.IAM_Status__c = 'Active';
        //update contactProvi;
        
        IAM_AccountsController.AppDeleteSingle(iamContactRecord.Id,'Test','Test');   
        Test.stopTest();
    }    
    
     @isTest
    static void testGetSubcriptionNames(){
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        
        //HttpResponse res = CalloutClass.getInfoFromExternalService();
        Test.startTest();
        Account accRecord = [Select Id From Account Where name = 'AccountTest1'];
        system.debug('==accRecord==='+accRecord);
        IAM_Application__c iamAppRecord = [Select Id from IAM_Application__c 
                                                        where IAM_Account_Name__c = :accRecord.ID AND IAM_Application_Name__c = 'CUMPAS 2.0' LIMIT 1];
        system.debug('==iamAppRecord ==='+iamAppRecord );
        list<IAM_Contact_Provisioning__c> conpro = [SELECT Id,Name,IAM_Application_Name__c,IAM_Account_Application__c FROM IAM_Contact_Provisioning__c  WHERE IAM_Application_Name__c = 'CUMPAS 2.0'];
        system.debug('===conpro====='+conpro);
        IAM_Contact_Provisioning__c iamContactRecord = [Select Id from IAM_Contact_Provisioning__c 
                                                        where IAM_Account_Application__c = :iamAppRecord.ID LIMIT 1];
        
        IAM_AccountsController.GetSubcriptionNames(iamContactRecord.Id, 'Test');
        Test.stopTest();
    }
    
    @isTest
    static void testIAM_Application(){
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        Test.startTest();
        //HttpResponse res = CalloutClass.getInfoFromExternalService();
        Account accRecord = [Select Id From Account Where name = 'AccountTest1'];
        Contact con =  [SELECT Id,Name FROM Contact WHERE Email = 'lstTest2323xdx@test.com'];
        
        IAM_Application__c iamAppRecord = [Select Id from IAM_Application__c 
                                                        where IAM_Account_Name__c = :accRecord.ID LIMIT 1];
                                                        
        IAM_Application__c connectedSolution = [Select Id from IAM_Application__c 
                                                        where IAM_Account_Name__c = :accRecord.ID AND IAM_Application_Name__c = 'Connected Solutions' LIMIT 1];                                            
        //Id recordId_IAM_Application = 'a1iZ0000001eGwRIAU';
        
        //Test for IAM_Application__c
       // IAM_AccountsController.getsObjectInfo(iamAppRecord.Id);
       // System.assertEquals('IAM_Application__c', IAM_AccountsController.getName(iamAppRecord.Id));
        
        IAM_AccountsController.deactivateAccountSub(iamAppRecord.Id,'Test','Test');
        IAM_AccountsController.deactivateAccountSub(connectedSolution.Id,'Test','Test');
        
        //update cmiApplication;
        IAM_AccountsController.generateCDA(iamAppRecord.id, 'Activate');
        IAM_AccountsController.deactivateAccountSub(iamAppRecord.Id,'Test','Test');
        Test.stopTest();     
    }
    
    @isTest
    static void testIAM_ApplicationMethods()
    {
    // Test.StartTest();
        list<String> modularity = new list<String>();
        list<String> roleNames = new list<String>();
        list<IAM_Contact_Provisioning__c> lstconpro = new list<IAM_Contact_Provisioning__c>();
        list<String> rolesNames = new list<String>();
        list<String> rolesNamesMarketplace = new list<String>();
        rolesNamesMarketplace.add('OSM Business Admin');
        rolesNames.add('Advanced');
        set<id> conIds = new set<id>();
        map<String,String> app = new map<String,String>();
        //Application
        app.put('Application','CUMPAS 2.0');
        modularity.add('Core Returns');
        roleNames.add('Dealer User');
        list<Account> lstAccount = new list<Account>();
       
        IAM_Contact_Provisioning__c conpro = [SELECT Id,Name,IAM_Contact__c ,IAM_Role__c ,IAM_DA_Customer_List__c,IAM_DA_Calibaration_Role__c   FROM IAM_Contact_Provisioning__c LIMIT 1];
        
        Contact conTest = [SELECT Id,Name FROM Contact WHERE email = 'Testuser1234@test.com' limit 1];
        lstconpro.add(conpro);
        
        IAM_Application__c application = [SELECT Id,Name FROM IAM_Application__c LIMIT 1];
        
        Test.StartTest();
        IAM_Application__c cumpasApp = [SELECT Id,Name FROM IAM_Application__c Where IAM_Application_Name__c = 'CUMPAS 2.0' limit 1];
        Contact con = [SELECT Id,Name,AccountId FROM Contact WHERE email = 'lstTest@test.com' limit 1];
        conIds.add(con.id);
        Account account = [SELECT Id,Name FROM Account WHERE Id =:con.AccountId limit 1];
        User user = [SELECT Id,Name,Username FROM User LIMIT 1];
        
       //IAM_AccountsController.getProfile();
        //IAM_AccountsController.getUserInfo();
        IAM_AccountsController.getsApplicationName(conpro.id);
        IAM_AccountsController.getApplicationNRoleNames(conpro.id);
        IAM_AccountsController.updateRoles(conpro.id,'Guidanz Mobile Campaign Distributor','Test');
        IAM_AccountsController.updateAppCumpas(conpro.id,'Dealer User','Core Returns');
        IAM_AccountsController.updateAppCumpas(conpro.id,'Dealer User','XXX');
        IAM_AccountsController.getUserType(con.id);
        IAM_AccountsController.getUserType(conpro.id);
        IAM_AccountsController.getUserReclaimStatus(con.id);
        
          IAM_AccountsController.getPrimaryLocation(con.id);
        //IAM_AccountsController.getPrimaryLocation(conTest.id);
        //conTest
        
        IAM_AccountsController.removeWrokGrpID(con.id,lstAccount);
        IAM_AccountsController.saveFreeAppCumpas(con.id,app,'CUMPAS 2.0',modularity,roleNames);       
        IAM_AccountsController.CreateConProv(conIds,application);
        IAM_AccountsController.UpdateUserFlag(conIds);
        IAM_AccountsController.updatefeatureAccess(application,lstconpro,true,true);
        IAM_AccountsController.getContacts1(application.id);
        IAM_AccountsController.saveFreeAppGuidanz(con.id,'Guidanz',rolesNames);
        IAM_AccountsController.saveFreeAppGuidanz(con.id,'Guidanz',rolesNames);
        IAM_AccountsController.saveFreeAppMarketPlace(con.id,'Marketplace',rolesNamesMarketplace);  
        IAM_AccountsController.appDelete(con.Id, 'De-Activate','Other');
        IAM_AccountsController.appDelete(conpro.Id, 'De-Activate','Test');
        IAM_AccountsController.getModularandRole(conpro.Id, 'EDS');   
        IAM_AccountsController.updateRolesConnectedSolution(conpro.id,'PrimaryContact','Test');
       
       
       //Added on 14/05/2020 
       //IAM_AccountsController.decrypt(user.Username);
      // IAM_AccountsController.encryptTheUserID(user.Username);
       
        Test.StopTest();
    }
    
    //Sushma Method on 13/05/2020
  /*  @isTest
    static void testIAM_ApplicationMethods2(){
        list<String> modularity = new list<String>();
        list<String> roleNames = new list<String>();
        list<IAM_Contact_Provisioning__c> lstconpro = new list<IAM_Contact_Provisioning__c>();
        list<String> rolesNames = new list<String>();
        list<String> rolesNamesMarketplace = new list<String>();
        rolesNamesMarketplace.add('OSM Business Admin');
        rolesNames.add('Advanced');
        set<id> conIds = new set<id>();
        map<String,String> app = new map<String,String>();
        //Application
        app.put('Application','CUMPAS 2.0');
        modularity.add('Core Returns');
        roleNames.add('Dealer User');
        list<Account> lstAccount = new list<Account>();
       
        IAM_Contact_Provisioning__c conpro = [SELECT Id,Name,IAM_Contact__c FROM IAM_Contact_Provisioning__c LIMIT 1];
        
        Contact conTest = [SELECT Id,Name FROM Contact WHERE email = 'Testuser1234@test.com' limit 1];
        lstconpro.add(conpro);
        
        IAM_Application__c application = [SELECT Id,Name FROM IAM_Application__c LIMIT 1];
        
        Test.StartTest();
        IAM_Application__c cumpasApp = [SELECT Id,Name FROM IAM_Application__c Where IAM_Application_Name__c = 'CUMPAS 2.0' limit 1];
        Contact con = [SELECT Id,Name,AccountId FROM Contact WHERE email = 'lstTest@test.com' limit 1];
        conIds.add(con.id);
        Account account = [SELECT Id,Name FROM Account WHERE Id =:con.AccountId limit 1];
        User user = [SELECT Id,Name,Username FROM User LIMIT 1];
        
        Test.StopTest();
        //IAM_AccountsController.decrypt(user.Username);
        //IAM_AccountsController.encryptTheUserID(user.Username);
       // IAM_AccountsController.updateRolesConnectedSolution(conpro.id,'test','test');
        
        }*/
     
    @isTest
    static void testIAM_SendToPc(){
    
        list<String> modularity = new list<String>();
        list<String> roleNames = new list<String>();
        list<IAM_Contact_Provisioning__c> lstconpro = new list<IAM_Contact_Provisioning__c>();
        list<String> rolesNames = new list<String>();
        list<String> rolesNamesMarketplace = new list<String>();
        rolesNamesMarketplace.add('OSM Business Admin');
        rolesNames.add('Advanced');
        set<id> conIds = new set<id>();
        set<id> contactIds = new set<id>();
        map<String,String> app = new map<String,String>();
        //Application
        app.put('Application','CUMPAS 2.0');
        modularity.add('Core Returns');
        roleNames.add('Dealer User');
        list<Account> lstAccount = new list<Account>();
        IAM_Contact_Provisioning__c conpro = [SELECT Id,Name,IAM_Contact__c FROM IAM_Contact_Provisioning__c LIMIT 1];
        lstconpro.add(conpro);
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        Test.startTest();
        IAM_Application__c application = [SELECT Id,Name FROM IAM_Application__c LIMIT 1];
        IAM_Application__c applicationTest = [SELECT Id,Name FROM IAM_Application__c WHERE IAM_Subscription_Name__c = 'TestSubscription1GuidanzMobTest' LIMIT 1];
        IAM_Application__c application02 = [SELECT Id,Name,IAM_Account_Name__c  FROM IAM_Application__c WHERE IAM_Status__c='Inactive' LIMIT 1];
        
        //CMI_CDA_Status__c,IAM_Status__c,IAM_Account_Name__c,IAM_Subscription_End_Date__c,  IAM_Subscription_Start_Date__c,IAM_Account_Name__r.CMI_CId__c from IAM_Application__c where id=:recordid
        
        
        
        Contact contact = [SELECT id,name FROM Contact WHERE email ='lstTest2323@test.com'];
        contactIds.add(contact.id);
        CMI_TSP__c tsp = new CMI_TSP__c ();
        tsp.CMI_TSP_Name__c = 'DriverTech';
        tsp.CMI_TSP_Id__c = 'Testing';
        tsp.CMI_Account_Name__c = application02.IAM_Account_Name__c ;
        insert tsp;
        
        IAM_Application__c cumpasApp = [SELECT Id,Name FROM IAM_Application__c Where IAM_Application_Name__c = 'CUMPAS 2.0'];
        Contact con = [SELECT Id,Name,AccountId FROM Contact WHERE email = 'lstTest@test.com' LIMIT 1];
        conIds.add(con.id);       
       
        Account account = [SELECT Id,Name FROM Account WHERE Id =:con.AccountId];
        //User user = [SELECT Id,Name,isActive  FROM User LIMIT 1];       
        
        IAM_AccountsController.SendPCInfo(applicationTest.id,'Activate');
         applicationTest.IAM_Status__c = 'Inactive';
        update applicationTest;
        IAM_AccountsController.appActivateDA(applicationTest.id,'Activate');
        IAM_AccountsController.SendPCInfo(account.id,'De-Activate');
        IAM_AccountsController.SendPCInfo(application.id,'Activate');
        IAM_AccountsController.SendPCInfo(application.id,'De-Activate');
        IAM_AccountsController.SendPCInfo(application.id,'Test');
        IAM_AccountsController.appActivateDA(application02.id,'Activate');        
        IAM_AccountsController.appActivateDA(application02.id,'Activate');
       // IAM_AccountsController.CreateConProv(contactIds,application);
        //contactIds       
        Test.stopTest();    
    }
     
    @isTest
    static void testIAM_test02(){
        Test.startTest();
        IAM_Application__c application = [SELECT Id,Name FROM IAM_Application__c LIMIT 1];
        //Account acc = [select id from account where IAM_Service_Provider_Code__c='332019' ];
        Account acc = new Account(name='AccountTest3Fix',
                                   CMI_Account_Status__c = 'Active',
                                   type='Dealer',
                                   IAM_Service_Provider_Code__c='987825'        
                                   );
    
    insert acc;
        IAM_Application__c app = new IAM_Application__c(    
        IAM_Account_Name__c = acc.ID,
        IAM_Application_Name__c = 'Marketplace',
        IAM_Role__c='OSM Sales User',
        IAM_Status__c='Active',
        IAM_Subscription_Count__c= 10,
        IAM_Provisioned_User_Count__c=5,
        IAM_Subscription_End_Date__c= System.today() + 5,
        IAM_Subscription_Name__c='TestSubscription3997',
        IAM_Free_Subscription__c= False,
        IAM_Subscription_Start_Date__c=System.today(),
        IAM_Customer_Code__c='01339'
    );
    
    insert app;
        //IAM_Application__c app = [SELECT Id,Name FROM IAM_Application__c  WHERE IAM_Subscription_Name__c='TestSubscription3997'];
        IAM_Application__c application02 = [SELECT Id,Name FROM IAM_Application__c WHERE IAM_Subscription_Name__c = 'TestSubscription1Test' LIMIT 1];
        IAM_Application__c application05 = [SELECT Id,Name FROM IAM_Application__c WHERE IAM_Subscription_Name__c = 'TestSubscription1Test' LIMIT 1];
              
        IAM_Application__c application03 = [SELECT Id,Name FROM IAM_Application__c WHERE IAM_Subscription_Name__c = 'TestSubscription234av' LIMIT 1];
        //TestSubscription1GuidanzMob
        IAM_Application__c application04 = [SELECT Id,Name FROM IAM_Application__c WHERE IAM_Subscription_Name__c = 'TestSubscription1GuidanzMob' LIMIT 1];
        Contact con = [SELECT Id,Name,AccountId FROM Contact LIMIT 1];
        Contact contact = [SELECT Id,Name,AccountId FROM Contact WHERE Email = 'lstTest@test.com'];
                Account account = [SELECT Id,Name FROM Account WHERE Id =:con.AccountId];
        IAM_Contact_Provisioning__c  conpro = [SELECT Id,Name FROM IAM_Contact_Provisioning__c  LIMIT 1];
        
        IAM_AccountsController.saveAssignedSubscription('Test02 User02','PrimaryContact',app.id,'Test');      
        IAM_AccountsController.saveAssignedSubscription('Amartest@abc.com','Dealer User',application.id,'Test');
        IAM_AccountsController.saveAssignedSubscription('Amartest213@abc.com','PrimaryContact',application03.id,'Test Data');
        IAM_AccountsController.saveAssignedSubscription('Amartest213uio@abc.com','PrimaryContact',application03.id,'Test Data');
        IAM_AccountsController.saveAssignedSubscription('Amartest@abc.com','Guidanz Mobile Campaign Dealer',application04.id,'Test Data');
        
        Test.stopTest();
    
    }
    
    @isTest
    static void testIAM_test022(){
        Test.startTest();

        IAM_Application__c application = [SELECT Id,Name FROM IAM_Application__c LIMIT 1];
        //Account acc = [select id from account where IAM_Service_Provider_Code__c='332019' ];
       Account acc = new Account(name='AccountTest3Fix',
                                   CMI_Account_Status__c = 'Active',
                                   type='Dealer',
                                   IAM_Service_Provider_Code__c='987826'        
                                   );
    
    
    insert acc;
           IAM_Application__c app = new IAM_Application__c(    
        IAM_Account_Name__c = acc.ID,
        IAM_Application_Name__c = 'Marketplace',
        IAM_Role__c='OSM Sales User',
        IAM_Status__c='Active',
        IAM_Subscription_Count__c= 10,
        IAM_Provisioned_User_Count__c=5,
        IAM_Subscription_End_Date__c= System.today() + 5,
        IAM_Subscription_Name__c='TestSubscription3997',
        IAM_Free_Subscription__c= False,
        IAM_Subscription_Start_Date__c=System.today(),
        IAM_Customer_Code__c='01339'
    );
    
    insert app;     
        //IAM_Application__c app = [SELECT Id,Name FROM IAM_Application__c  WHERE IAM_Subscription_Name__c='TestSubscription3997'];
        IAM_Application__c application02 = [SELECT Id,Name FROM IAM_Application__c WHERE IAM_Subscription_Name__c = 'TestSubscription1Test' LIMIT 1];
        IAM_Application__c application05 = [SELECT Id,Name FROM IAM_Application__c WHERE IAM_Subscription_Name__c = 'TestSubscription1Test' LIMIT 1];
              
        IAM_Application__c application03 = [SELECT Id,Name FROM IAM_Application__c WHERE IAM_Subscription_Name__c = 'TestSubscription234av' LIMIT 1];
        //TestSubscription1GuidanzMob
        IAM_Application__c application04 = [SELECT Id,Name FROM IAM_Application__c WHERE IAM_Subscription_Name__c = 'TestSubscription1GuidanzMob' LIMIT 1];
        Contact con = [SELECT Id,Name,AccountId FROM Contact LIMIT 1];
        Contact contact = [SELECT Id,Name,AccountId FROM Contact WHERE Email = 'lstTest@test.com'];
       
        Account account = [SELECT Id,Name FROM Account WHERE Id =:con.AccountId];
        IAM_Contact_Provisioning__c  conpro = [SELECT Id,Name FROM IAM_Contact_Provisioning__c  LIMIT 1];        
        IAM_AccountsController.saveAssignedSubscription('Amartest@abc.com','Dealer User',application.id,'View Credit');        
        IAM_AccountsController.saveAssignedSubscription('Test02 User02','PrimaryContact',app.id,'Core Returns');       
        IAM_AccountsController.saveAssignedSubscription('Test User','Dealer User',application02.id,'View Credit');        
        IAM_AccountsController.saveAssignedSubscription('Amartest@abc.com','Dealer User',application02.id,'View Credit');
        IAM_AccountsController.saveAssignedSubscription('Amartest@abc.com','Dealer User',application05.id,'View Credit');
        IAM_AccountsController.saveAssignedSubscription('Amartest@abc.com','Test Data',application02.id,'Test Data');
        IAM_AccountsController.saveAssignedSubscription('Amartest@abc.com','Dealer User',application02.id,'Test');
        
        Test.stopTest();    
    }
      
    @isTest
    static void testIAM_test03(){
        Test.startTest();
        IAM_Application__c application = [SELECT Id,Name FROM IAM_Application__c LIMIT 1];
        //Account acc = [select id from account where IAM_Service_Provider_Code__c='332019' ];
       Account acc = new Account(name='AccountTest3Fix',
                                   CMI_Account_Status__c = 'Active',
                                   type='Dealer',
                                   IAM_Service_Provider_Code__c='987827'        
                                   );
    
    
    insert acc;
        IAM_Application__c app = new IAM_Application__c(    
        IAM_Account_Name__c = acc.ID,
        IAM_Application_Name__c = 'Marketplace',
        IAM_Role__c='OSM Sales User',
        IAM_Status__c='Active',
        IAM_Subscription_Count__c= 10,
        IAM_Provisioned_User_Count__c=5,
        IAM_Subscription_End_Date__c= System.today() + 5,
        IAM_Subscription_Name__c='TestSubscription3997',
        IAM_Free_Subscription__c= False,
        IAM_Subscription_Start_Date__c=System.today(),
        IAM_Customer_Code__c='01339'
    );
    
    insert app;
        //IAM_Application__c app = [SELECT Id,Name FROM IAM_Application__c  WHERE IAM_Subscription_Name__c='TestSubscription3997'];
        IAM_Application__c application02 = [SELECT Id,Name FROM IAM_Application__c WHERE IAM_Subscription_Name__c = 'TestSubscription1Test' LIMIT 1];
        IAM_Application__c application03 = [SELECT Id,Name FROM IAM_Application__c WHERE IAM_Subscription_Name__c = 'TestSubscription234av' LIMIT 1];
        
        Contact con = [SELECT Id,Name,AccountId FROM Contact LIMIT 1];
        
        Contact contact = [SELECT Id,Name,IAM_Contact_Status__c  FROM Contact WHERE Email = 'lstTestData2323xx@test.com'];
        
        Account account = [SELECT Id,Name FROM Account WHERE Id =:con.AccountId];
        IAM_Contact_Provisioning__c  conpro = [SELECT Id,Name FROM IAM_Contact_Provisioning__c  LIMIT 1];
        User user = [SELECT Id,Name FROM User WHERE Username = 'lstTest@test.com' OR Email='lstTest@test.com'];
        
        IAM_AccountsController.saveAssignedSubscription(con.name,'Dealer User',application.id,'View Credit');
        IAM_AccountsController.saveAssignedSubscription('Test02 User02','PrimaryContact',app.id,'Core Returns');
        IAM_AccountsController.SendPCInfo(account.id,'Activate');
        IAM_AccountsController.SendPCInfo(application.id,'Activate');
        IAM_AccountsController.UserHavePerm(application.id);
        IAM_AccountsController.getAppFeatStatus(application.id);
        IAM_AccountsController.getAppFeatStatus(conpro.id);
        IAM_AccountsController.getRoles(application.id);
        IAM_AccountsController.getRoles(application02.id);
        IAM_AccountsController.getRoles(application03.id);
        IAM_AccountsController.getContacts(application.id,'PrimaryContact','Core Returns');
        IAM_AccountsController.getGuidanzRole(con.id,'Guidanz');
        IAM_AccountsController.getMarketPlaceRole(con.id,'Marketplace');
        IAM_AccountsController.getConnectedSolutionRole(con.id,'Connected Solutions');
        IAM_AccountsController.showLocationType(con.id,account.id);
        IAM_AccountsController.appDAUpdate(application.id,'Generate Service Agreement');
        IAM_AccountsController.appActivateDA(application.id,'Activate');
        IAM_AccountsController.encryptUserID('Test Data');
        //IAM_AccountsController.getUserType(Id.valueOf('0039000000tfKiS'));
        IAM_AccountsController.setpass(user.id);
       // IAM_AccountsController.ActivateContact(con.id , 'Activate');
        //IAM_AccountsController.ActivateContact(contact.id , 'Activate');
        Test.stopTest();   
    }
    
   @isTest
    static void testIAM_test04(){
    
        IAM_Application__c application = [SELECT Id,Name, CMI_CDA_Status__c,IAM_Status__c,IAM_Account_Name__c,IAM_Subscription_End_Date__c,  IAM_Subscription_Start_Date__c,IAM_Account_Name__r.CMI_CId__c FROM IAM_Application__c LIMIT 1];
        //Account acc = [select id from account where IAM_Service_Provider_Code__c='332019' ];
        Account acc = new Account(name='AccountTest3Fix',
                                   CMI_Account_Status__c = 'Active',
                                   type='Dealer',
                                   IAM_Service_Provider_Code__c='987828'        
                                   );
    
    
    insert acc;
        IAM_Application__c app = new IAM_Application__c(    
        IAM_Account_Name__c = acc.ID,
        IAM_Application_Name__c = 'Marketplace',
        IAM_Role__c='OSM Sales User',
        IAM_Status__c='Active',
        IAM_Subscription_Count__c= 10,
        IAM_Provisioned_User_Count__c=5,
        IAM_Subscription_End_Date__c= System.today() + 5,
        IAM_Subscription_Name__c='TestSubscription3997',
        IAM_Free_Subscription__c= False,
        IAM_Subscription_Start_Date__c=System.today(),
        IAM_Customer_Code__c='01339'
    );
    
    insert app;
        //IAM_Application__c app = [SELECT Id,Name FROM IAM_Application__c  WHERE IAM_Subscription_Name__c='TestSubscription3997'];
        IAM_Application__c application02 = [SELECT Id,Name FROM IAM_Application__c WHERE IAM_Subscription_Name__c = 'TestSubscription1Test' LIMIT 1];
        Test.startTest();
        IAM_Application__c application03 = [SELECT Id,Name FROM IAM_Application__c WHERE IAM_Subscription_Name__c = 'TestSubscription234av' LIMIT 1];
        //TestSubscription1GuidanzMob
        IAM_Application__c application04 = [SELECT Id,Name FROM IAM_Application__c WHERE IAM_Subscription_Name__c = 'TestSubscription1GuidanzMob' LIMIT 1];
        Contact con = [SELECT Id,Name,AccountId FROM Contact LIMIT 1];
        Account account = [SELECT Id,Name FROM Account WHERE Id =:con.AccountId];
        IAM_Contact_Provisioning__c  conpro = [SELECT Id,Name FROM IAM_Contact_Provisioning__c  LIMIT 1];
        
       
        //For guidanz Mobile -- Amartest@abc.com 
        IAM_AccountsController.SendPCInfo(account.id,'Activate');
        IAM_AccountsController.SendPCInfo(application.id,'Activate');
        IAM_AccountsController.UserHavePerm(application.id);
        IAM_AccountsController.getAppFeatStatus(application.id);
        IAM_AccountsController.getAppFeatStatus(conpro.id);
        IAM_AccountsController.getRoles(application.id);
        IAM_AccountsController.getContacts(application.id,'PrimaryContact','Core Returns');
         IAM_AccountsController.getGuidanzRole(con.id,'Guidanz');
        IAM_AccountsController.getMarketPlaceRole(con.id,'Marketplace');
        IAM_AccountsController.getConnectedSolutionRole(con.id,'Connected Solutions');
        IAM_AccountsController.showLocationType(con.id,account.id);
        IAM_AccountsController.appDAUpdate(application.id,'Generate Service Agreement');
        IAM_AccountsController.appActivateDA(application.id,'Activate');
        IAM_AccountsController.encryptUserID('Test Data');
        //IAM_AccountsController.getUserType(Id.valueOf('0039000000tfKiS'));
        
        Test.stopTest();    
    }  
     
     @isTest
    static void testIAM_test05(){
        
        Test.startTest();
        //IAM_Application__c application = [SELECT Id,Name FROM IAM_Application__c LIMIT 1];
        IAM_Application__c app = [SELECT Id,Name,(SELECT Id,Name,IAM_Status__c,IAM_Reject_Reason__c,IAM_Reason__c FROM Contact_Provisionings__r LIMIT 1) FROM IAM_Application__c  WHERE IAM_Subscription_Count__c= 7 LIMIT 1];
        //IAM_Application__c application02 = [SELECT Id,Name FROM IAM_Application__c WHERE IAM_Subscription_Name__c = 'TestSubscription1Test' LIMIT 1];
        //IAM_Application__c application03 = [SELECT Id,Name FROM IAM_Application__c WHERE IAM_Subscription_Name__c = 'TestSubscription234av' LIMIT 1];
        //TestSubscription1GuidanzMob
        //IAM_Application__c application04 = [SELECT Id,Name FROM IAM_Application__c WHERE IAM_Subscription_Name__c = 'TestSubscription1GuidanzMob' LIMIT 1];
        Contact con = [SELECT Id,Name,AccountId FROM Contact LIMIT 1];
        Account account = [SELECT Id,Name FROM Account WHERE Id =:con.AccountId];
        Contact contact= [SELECT Id,Name FROM Contact WHERE Email = 'lstTest2323@test.com'];
        
        map<string,list<string>> applicationmap = new map<string,list<string>>(); 
        list<string> lstroles = new list<string>();
        list<string> lstrolesMarketPlace = new list<string>();
        list<string> lstQuickSolOnline = new list<string>();
        list<string> lstrolesCST = new list<string>();
        list<string> lstConnectedSolRole = new list<string>();
        list<string> lstGuidanzMob = new list<string>();
        lstConnectedSolRole.add('PrimaryContact');
        lstrolesCST.add('Service Training User');
        lstrolesMarketPlace.add('OSM Role');
        lstQuickSolOnline.add('QSOL Dealer');
        lstGuidanzMob.add('Guidanz Mobile Campaign Dealer');
        lstroles.add('Channel Admin');
        lstroles.add('External User');
        applicationmap.put('EDS',lstroles);
        applicationmap.put('IAM_Promotion__c',lstroles);
        applicationmap.put('Marketplace',lstrolesMarketPlace);
        applicationmap.put('Cummins Service Training',lstrolesCST);
        applicationmap.put('Connected Solutions',lstConnectedSolRole);
        applicationmap.put('QuickServe Online',lstQuickSolOnline);
        applicationmap.put('Guidanz Mobile',lstGuidanzMob);
               
        Contact cont = [SELECT Id,Name FROM Contact WHERE Email = 'lstTest@test.com' LIMIT 1];
        
        //IAM_Contact_Provisioning__c  conpro = [SELECT Id,Name FROM IAM_Contact_Provisioning__c  LIMIT 1];
        system.debug('===Inside test05 app=='+app.Contact_Provisionings__r);
        IAM_AccountsController.deactivateConProvisionings(app,'Other','Testing');
        IAM_AccountsController.deactivateConProvisionings(app,'Test','Testing');
        IAM_AccountsController.ProcessSubscriptionAppRec(cont.Id, 'TestSubscription1', new List<String>{'EDS_AUTHOR', 'EDS_ADMIN_USER'},applicationmap,4);
        IAM_AccountsController.ProcessSubscriptionAppRec(cont.Id, 'TestSubscription1', new List<String>{'EDS_AUTHOR', 'EDS_ADMIN_USER'},applicationmap,4);
        contact.IAM_Internal__c = true;
        update contact;
        //IAM_AccountsController.ProcessSubscriptionAppRec(contact.Id, 'TestSubscription1', new List<String>{'EDS_AUTHOR', 'EDS_ADMIN_USER'},applicationmap);
        //IAM_AccountsController.ProcessSubscriptionAppRec(contact.Id, 'TestSubscription1', new List<String>{'EDS_AUTHOR', 'EDS_ADMIN_USER'},applicationmap);
        //IAM_AccountsController.ProcessSubscriptionAppRec(contact.Id, 'TestSubscriptionquickServeOnline', new List<String>{'EDS_AUTHOR', 'EDS_ADMIN_USER'},applicationmap);
        //IAM_AccountsController.ProcessSubscriptionAppRec(contact.Id, 'TestSubscription1GuidanzMobTest02', new List<String>{'EDS_AUTHOR', 'EDS_ADMIN_USER'},applicationmap);
        
        Test.stopTest();  
    }
    
    @isTest
    static void testIAM_test06(){    
        
        //IAM_Application__c application = [SELECT Id,Name FROM IAM_Application__c LIMIT 1];
        IAM_Application__c app = [SELECT Id,Name,(SELECT Id,Name,IAM_Status__c,IAM_Reject_Reason__c,IAM_Reason__c FROM Contact_Provisionings__r LIMIT 1) FROM IAM_Application__c  WHERE IAM_Subscription_Count__c= 7 LIMIT 1];
        //IAM_Application__c application02 = [SELECT Id,Name FROM IAM_Application__c WHERE IAM_Subscription_Name__c = 'TestSubscription1Test' LIMIT 1];
        //IAM_Application__c application03 = [SELECT Id,Name FROM IAM_Application__c WHERE IAM_Subscription_Name__c = 'TestSubscription234av' LIMIT 1];
        //TestSubscription1GuidanzMob
        //IAM_Application__c application04 = [SELECT Id,Name FROM IAM_Application__c WHERE IAM_Subscription_Name__c = 'TestSubscription1GuidanzMob' LIMIT 1];
        //Contact con = [SELECT Id,Name,AccountId FROM Contact LIMIT 1];
        Account acctS = [SELECT Id,Name FROM Account WHERE Name = 'AccountTest5' Limit 1];
        //Contact contact= [SELECT Id,Name FROM Contact WHERE Email = 'lstTest2323@test.com'];
           /* Account accSampleRecord5 = new Account(name='AccountTest511',
                                    CMI_Account_Status__c = 'Active',
                                    CMI_CDA_Status__c='New Customer Request',
                                    //ParentId = accSampleRecord4.id,
                                    CMI_Region__c = 'East Asia',
                                    CMI_Cummins_Support_Email__c = 'abc123@gmail.com',
                                    recordtypeid=Schema.getGlobalDescribe().get('Account').getDescribe().getRecordTypeInfosByName().get('IAM').getRecordTypeId()
                                    //IAM_Service_Provider_Code__c='13321'
                                    );
    
    insert accSampleRecord5;*/
    
    //CMI_Account_Status__c = 'Active',
    Contact contSampleRecord = new Contact(
        FirstName = 'Test1234',
        LastName ='User',
        Email = 'lstTest2323@test.com',
        AccountId = acctS.Id,
        IAM_Contact_Status__c = 'Pending',
        CMI_Contact_Type__c = 'Primary',
        recordtypeid=Schema.getGlobalDescribe().get('Contact').getDescribe().getRecordTypeInfosByName().get('IAM').getRecordTypeId(),
        Username__c = 'Amartesttestt@abc.com',
        Phone = '9743800309'
    );
    insert contSampleRecord;
        Test.startTest();   
        map<string,list<string>> applicationmap = new map<string,list<string>>(); 
        list<string> lstroles = new list<string>();
        list<string> lstrolesMarketPlace = new list<string>();
        list<string> lstQuickSolOnline = new list<string>();
        list<string> lstrolesCST = new list<string>();
        list<string> lstConnectedSolRole = new list<string>();
        list<string> lstGuidanzMob = new list<string>();
        lstConnectedSolRole.add('PrimaryContact');
        lstrolesCST.add('Service Training User');
        lstrolesMarketPlace.add('OSM Role');
        lstQuickSolOnline.add('QSOL Dealer');
        lstGuidanzMob.add('Guidanz Mobile Campaign Dealer');
        lstroles.add('Channel Admin');
        lstroles.add('External User');
        applicationmap.put('EDS',lstroles);
        applicationmap.put('IAM_Promotion__c',lstroles);
        applicationmap.put('Marketplace',lstrolesMarketPlace);
        applicationmap.put('Cummins Service Training',lstrolesCST);
        applicationmap.put('Connected Solutions',lstConnectedSolRole);
        applicationmap.put('QuickServe Online',lstQuickSolOnline);
        applicationmap.put('Guidanz Mobile',lstGuidanzMob);
               
        //Contact cont = [SELECT Id,Name FROM Contact WHERE Email = 'lstTest@test.com' LIMIT 1];
        
        //IAM_Contact_Provisioning__c  conpro = [SELECT Id,Name FROM IAM_Contact_Provisioning__c  LIMIT 1];
        system.debug('===Inside test06 app=='+app.Contact_Provisionings__r);      
        
        contSampleRecord.IAM_Internal__c = true;
        update contSampleRecord;
        IAM_AccountsController.ProcessSubscriptionAppRec(contSampleRecord.Id, 'TestSubscription1', new List<String>{'EDS_AUTHOR', 'EDS_ADMIN_USER'},applicationmap,1);
        IAM_AccountsController.ProcessSubscriptionAppRec(contSampleRecord.Id, 'TestSubscription1', new List<String>{'EDS_AUTHOR', 'EDS_ADMIN_USER'},applicationmap,1);
        IAM_AccountsController.ProcessSubscriptionAppRec(contSampleRecord.Id, 'TestSubscriptionquickServeOnline', new List<String>{'EDS_AUTHOR', 'EDS_ADMIN_USER'},applicationmap,1);
        IAM_AccountsController.ProcessSubscriptionAppRec(contSampleRecord.Id, 'TestSubscription1GuidanzMobTest02', new List<String>{'EDS_AUTHOR', 'EDS_ADMIN_USER'},applicationmap,1);
        
        Test.stopTest();   
    }
    
   
    @isTest
    static void testIAM_test07(){
    set<Id> conIds = new set<Id>();
    //IAM_Application__c app = [SELECT Id,Name FROM IAM_Application__c WHERE IAM_Subscription_Name__c='TestSubscription3997'];
    IAM_Application__c appConnected = [SELECT Id,Name FROM IAM_Application__c WHERE IAM_Subscription_Name__c='TestSubscription1GuidanzMobTest'];
    //Contact con = [SELECT Id,Name FROM Contact WHERE Email = 'lstTest2323jjl@test.com'];
    //Account acc = [SELECT Id,Name FROM Account WHERE name ='AccountTest3'];
    Account acc = new Account(name='AccountTest3Fix',
                                   CMI_Account_Status__c = 'Active',
                                   type='Dealer',
                                   IAM_Service_Provider_Code__c='987829'        
                                   );
    
    insert acc;
          
    Contact con = new Contact(
        FirstName = 'Amar Test',
        LastName ='User Test class',
        Email = 'lstTest12defed@test.com',
        AccountId = acc.ID,
        IAM_Contact_Status__c = 'Inactive',
        CMI_Contact_Type__c = 'Secondary',
        Username__c = 'lstTest12defed@test.com',
        Phone = '9743800309'
    );
    
    insert con;
        
     Contact con2 = new Contact(
        FirstName = 'Amar Test',
        LastName ='User Test class',
        Email = 'lstTest12dettt@test.com',
        AccountId = acc.ID,
        IAM_Contact_Status__c = 'Inactive',
        CMI_Contact_Type__c = 'Secondary',
        Username__c = 'lstTest12dettt@test.com',
        Phone = '9743800309'
    );
    
    insert con2;
        
    IAM_Application__c MarketPlaceApp = new IAM_Application__c(    
        IAM_Account_Name__c = acc.ID,
        IAM_Application_Name__c = 'Marketplace',
        IAM_Role__c='OSM Sales User',
        IAM_Status__c='Active',
        IAM_Subscription_Count__c= 10,
        IAM_Provisioned_User_Count__c=5,
        IAM_Subscription_End_Date__c= System.today() + 5,
        IAM_Subscription_Name__c='TestSubscriptionMarketplace',
        IAM_Free_Subscription__c= False,
        IAM_Subscription_Start_Date__c=System.today()
    );
    insert   MarketPlaceApp;
        
    IAM_Application__c connectedSolApplication03 = new IAM_Application__c(    
        IAM_Account_Name__c = acc.ID,
        IAM_Application_Name__c = 'Connected Solutions',
        IAM_Role__c='PrimaryContact',
        IAM_Status__c='Active',
        IAM_Subscription_Count__c= 10,
        IAM_Provisioned_User_Count__c=5,
        IAM_Subscription_End_Date__c= System.today() + 5,
        IAM_Subscription_Name__c='TestSubscriptionConnectedSolution',
        IAM_Free_Subscription__c= False,
        IAM_Source__c = 'Marketplace',
        IAM_Subscription_Start_Date__c=System.today()
    );
    
    //insert connectedSolApplication03;
           
    Test.startTest();
   /* IAM_Contact_Provisioning__c iamContSampleRecordConnectedSol = new IAM_Contact_Provisioning__c(
        IAM_Account_Application__c = appConnected.ID,
        RecordTypeId = Schema.SObjectType.IAM_Contact_Provisioning__c.getRecordTypeInfosByName().get('Connected Solutions').getRecordTypeId(),
        IAM_Application_Name__c = 'Connected Solutions',
        IAM_Contact__c= con.Id,
        IAM_End_Date__c= System.today() + 5,
        IAM_Role__c='PrimaryContact',
        IAM_Start_Date__c=System.today(),
        IAM_Status__c='Active'
        );
   insert iamContSampleRecordConnectedSol; 
   
   IAM_Contact_Provisioning__c marketplaceconpro = new IAM_Contact_Provisioning__c(
        IAM_Account_Application__c = MarketPlaceApp.ID,
        RecordTypeId = Schema.SObjectType.IAM_Contact_Provisioning__c.getRecordTypeInfosByName().get('Marketplace').getRecordTypeId(),
        IAM_Application_Name__c = 'Marketplace',
        IAM_Contact__c= con.Id,
        IAM_End_Date__c= System.today() + 5,
        IAM_Role__c='OSM Sales User',
        IAM_Start_Date__c=System.today(),
        IAM_Status__c='Active'
        );
   insert marketplaceconpro; */
      
    Id profId  = [SELECT Id,Name FROM Profile Where name = 'IAM_Site_Admin_Community'].Id;
    
    User newUser = new User(
    profileId = profId,
    username = 'newUser@yahoo.com',
    email = 'pb@ff.com',
    emailencodingkey = 'UTF-8',
    localesidkey = 'en_US',
    languagelocalekey = 'en_US',
    timezonesidkey = 'America/Los_Angeles',
    alias='nuser',
    lastname='lastname',
    contactId = con2.id,
    isActive = true
    );
       
    insert newUser;
    set<id> Idcon2 = new set<id>();
    Idcon2.add(con2.id); 
    conIds.add(newUser.contactId);
    
    IAM_AccountsController.CreateConProv(conIds,MarketPlaceApp);
    IAM_AccountsController.CreateConProv(Idcon2,MarketPlaceApp);
    MarketPlaceApp.IAM_Status__c = 'Inactive';
    update MarketPlaceApp; 
    IAM_AccountsController.appActivateDA(MarketPlaceApp.id,'Activate');
    Test.stopTest();
    }  
    
    @isTest
    static void testIAM_test08(){
    set<Id> conIds = new set<Id>();
    //IAM_Application__c app = [SELECT Id,Name FROM IAM_Application__c WHERE IAM_Subscription_Name__c='TestSubscription3997'];
    //IAM_Application__c appConnected = [SELECT Id,Name FROM IAM_Application__c WHERE IAM_Subscription_Name__c='TestSubscription1GuidanzMobTest'];
    //Contact con = [SELECT Id,Name FROM Contact WHERE Email = 'lstTest2323jjl@test.com'];
   
    List<Contact> con=[Select id,IAM_Contact_Status__c,Account.CMI_Account_Status__c from Contact where username__c='Testuser1234@testfieldtest.com'];
    List<IAM_Application__c> iamCN=[Select id from IAM_Application__c where IAM_Account_Name__c=:con[0].Accountid and IAM_Application_NAme__c='Connected Solutions' and IAM_Status__c='Inactive' LIMIT 1];
    Test.startTest();
   
   
    IAM_AccountsController.appActivateDA(iamCN[0].id,'Activate');
    Test.stopTest();
    }   
    
    //RSW
    
    @isTest
    static void testIAM_testrsw(){
    set<Id> conIds = new set<Id>();
    //IAM_Application__c app = [SELECT Id,Name FROM IAM_Application__c WHERE IAM_Subscription_Name__c='TestSubscription3997'];
    //IAM_Application__c appConnected = [SELECT Id,Name FROM IAM_Application__c WHERE IAM_Subscription_Name__c='TestSubscription1GuidanzMobTest'];
    //Contact con = [SELECT Id,Name FROM Contact WHERE Email = 'lstTest2323jjl@test.com'];
    Account acc = [SELECT Id,Name FROM Account WHERE name ='AccountTest5'];
    
   
        
    Contact con = new Contact(
        FirstName = 'Amar Test',
        LastName ='User Test class',
        Email = 'lstTest12defed@test.com',
        AccountId = acc.ID,
        IAM_Contact_Status__c = 'active',
        CMI_Contact_Type__c = 'Secondary',
        Username__c = 'lstTest12defedunique@test.com',
        Phone = '9743800309'
    );
    
    insert con;
        
    IAM_Application__c rsw = new IAM_Application__c(    
        IAM_Account_Name__c = acc.ID,
        IAM_Application_Name__c = 'Rapid Serve Web',
        IAM_Role__c='Basic',
        IAM_Status__c='Active',
        IAM_Subscription_Count__c= 10,
        IAM_Provisioned_User_Count__c=5,
        IAM_Subscription_End_Date__c= System.today() + 5,
        IAM_Subscription_Name__c='TestSubscriptionConnectedSolution',
        IAM_Free_Subscription__c= true,
        IAM_Subscription_Start_Date__c=System.today()
    );
    
    insert rsw;
       
     List<String> roles= new List<String>();
     roles.add('Basic');  
    Test.StartTest();   
    IAM_AccountsController.getRSWRole(con.id,'Rapid Serve Web');
    IAM_AccountsController.saveFreeAppRSW(con.id,'Rapid Serve Web',roles);
    Test.stopTest();
    }
    
    @isTest
    static void testIAM_testosm(){
       
  
       List<Contact> contSampleRecordosm=[Select id,Name,Account.id,IAM_Contact_Status__c,IAM_Legacy_User__c,IAM_Internal__c,Username__c 
                                          from Contact where username__c='lstTestosm@abc.com'];
      List<string> OSMroles = new List<String>();
        OSMroles.add('OSM Storefront Admin');
        List<IAM_Application__c> appMarketPlace=[select id,IAM_Subscription_Name__c,IAM_Application_Name__c,  IAM_Subscription_Start_Date__c,  IAM_Subscription_End_Date__c,IAM_Role__c,IAM_Status__c 
                                                 from IAM_Application__c where IAM_Application_Name__c=:OSMroles 
                                                 and IAM_Status__c='Active' and IAM_Account_Name__c=:contSampleRecordosm[0].Accountid Limit 1];
        
        IAM_AccountsController.saveFreeAppMarketPlace(contSampleRecordosm[0].id,'Marketplace',OSMroles);
        //IAM_AccountsController.saveFreeAppFleetguardFit(contSampleRecordosm.id,'Fleetguard FIT','User');
        //IAM_AccountsController.getFleetguardFitRole(fleetfitrcd.id,'Fleetguard FIT');
        //IAM_AccountsController.encryptTheUserID('username');
        //IAM_AccountsController.decrypt('username');
    }
    
     @isTest
    static void testIAM_testfleetguardFit(){
         Account accSampleRecordosm = new Account(name='AccountTest1',
                                   CMI_Account_Status__c='Pending',
                                   CMI_CDA_Status__c='New Customer Request',
                                   CSS_DistributorCode__c = '10010',
                                   IAM_Service_Provider_Code__c = '1349',
                                   Type='Dealer Account'
                                   );
    
    insert accSampleRecordosm;
       Contact con = new Contact(
        FirstName = 'Amar Test',
        LastName ='User Test class',
        Email = 'lstTest12defed@test.com',
        AccountId = accSampleRecordosm.ID,
        IAM_Contact_Status__c = 'active',
        CMI_Contact_Type__c = 'Secondary',
        Username__c = 'lstTest12defedunique@test.com',
        Phone = '9743800309'
    );
        insert con;
  
        IAM_Application__c fleetfitrcd = new IAM_Application__c(    
        IAM_Account_Name__c = accSampleRecordosm.ID,
        IAM_Application_Name__c = 'Fleetguard FIT',
        IAM_Role__c='User',
        IAM_Status__c='Active',
        IAM_Subscription_Count__c= 10,
        IAM_Provisioned_User_Count__c=5,
        IAM_Subscription_End_Date__c= System.today() + 5,
        IAM_Subscription_Name__c='MarketPlace',
        IAM_Free_Subscription__c= False,
        IAM_Subscription_Start_Date__c=System.today()
    );
    insert fleetfitrcd;
    
      List<string> OSMroles = new List<String>();
        OSMroles.add('OSM Storefront Admin');
       // IAM_AccountsController.saveFreeAppMarketPlace(contSampleRecordosm.id,'Marketplace',OSMroles);
        //IAM_AccountsController.saveFreeAppFleetguardFit(contSampleRecordosm.id,'Fleetguard FIT','User');
        IAM_AccountsController.getFleetguardFitRole(con.id,'Fleetguard FIT');
      
       
        //IAM_AccountsController.ActivateContact(contSampleRecordosm.id,'Activate');
        //IAM_AccountsController.encryptTheUserID('username');
        //IAM_AccountsController.decrypt('username');
    }
    
    
    //new fleet
      @isTest
    static void testIAM_testfleetguardFitn5(){
         Account accSampleRecordosm = new Account(name='AccountTest1',
                                   CMI_Account_Status__c='Pending',
                                   CMI_CDA_Status__c='New Customer Request',
                                   CSS_DistributorCode__c = '10010',
                                   IAM_Service_Provider_Code__c = '1349',
                                   Type='Dealer Account'
                                   );
    
    insert accSampleRecordosm;
       Contact con = new Contact(
        FirstName = 'Amar Test',
        LastName ='User Test class',
        Email = 'lstTest12defed@test.com',
        AccountId = accSampleRecordosm.ID,
        IAM_Contact_Status__c = 'active',
        CMI_Contact_Type__c = 'Secondary',
        Username__c = 'lstTest12defedunique@test.com',
        Phone = '9743800309'
    );
        insert con;
  
        IAM_Application__c fleetfitrcd = new IAM_Application__c(    
        IAM_Account_Name__c = accSampleRecordosm.ID,
        IAM_Application_Name__c = 'Fleetguard FIT',
        IAM_Role__c='User',
        IAM_Status__c='Active',
        IAM_Subscription_Count__c= 10,
        IAM_Provisioned_User_Count__c=5,
        IAM_Subscription_End_Date__c= System.today() + 5,
        IAM_Subscription_Name__c='MarketPlace',
        IAM_Free_Subscription__c= False,
        IAM_Subscription_Start_Date__c=System.today()
    );
    insert fleetfitrcd;
    
      List<string> OSMroles = new List<String>();
        OSMroles.add('OSM Storefront Admin');
       // IAM_AccountsController.saveFreeAppMarketPlace(contSampleRecordosm.id,'Marketplace',OSMroles);
        //IAM_AccountsController.saveFreeAppFleetguardFit(contSampleRecordosm.id,'Fleetguard FIT','User');
   
        IAM_AccountsController.getUserInfo();
        IAM_AccountsController.setPassword('0031b00000ghobZ','Active');
        //IAM_AccountsController.ActivateContact(contSampleRecordosm.id,'Activate');
        //IAM_AccountsController.encryptTheUserID('username');
        //IAM_AccountsController.decrypt('username');
    }
    
    //new fleet
    
    @isTest
    static void testIAM_testfleetguardFit2(){
        
        List<User> userList = new List<User>();
        set<id> accntIds = new Set<id>();
        IAM_Application_Groups__c iamAPP = [Select Id, IAM_DN_value__c, IAM_Role_Name__c 
                                           from IAM_Application_Groups__c where Name =: 'Power Spec 1.6'];
         Account accSampleRecordosm = new Account(name='AccountTest1',
                                   CMI_Account_Status__c='Pending',
                                   CMI_CDA_Status__c='New Customer Request',
                                   CSS_DistributorCode__c = '10010',
                                   IAM_Service_Provider_Code__c = '1349',
                                   Type='Dealer Account'
                                   );
    
    insert accSampleRecordosm;
        accntIds.add(accSampleRecordosm.Id);
       
  Contact contSampleRecordosm = new Contact(
        FirstName = 'Test',
        LastName ='User',
        Email = 'lstTestosm@test.com',
        AccountId = accSampleRecordosm.ID,
        IAM_Contact_Status__c = 'Active',
        CMI_Contact_Type__c = 'Secondary',
        IAM_Legacy_User__c=true,
        IAM_Internal__c=true,
        recordtypeid=Schema.SObjectType.Contact.getRecordTypeInfosByName().get('IAM').getRecordTypeId(),
        Username__c = 'lstTestosm@abc2.com',
        Phone = '9743800309'
    );
    insert contSampleRecordosm;
        
        Id profId  = [SELECT Id,Name FROM Profile Where name = 'IAM_Site_Admin_Community'].Id;
    
    User uesrSampleRecord = new User(
        LastName = 'lstTest',
        FirstName = 'frstfitTwoTest',
        Email = 'lstTest@FWtest.com',
        Alias = 'lsTTest',
        Username = 'lstTest@fitTwotest.com',
        CommunityNickname = 'lstestfitTo1234',
        LocaleSidKey= 'en_US',
        TimeZoneSidKey ='GMT',
        ProfileID = profId,
        LanguageLocaleKey = 'en_US',
        EmailEncodingKey = 'UTF-8',
        contactId = contSampleRecordosm.Id,
        isActive = true
    );
    insert uesrSampleRecord;
    userList.add(uesrSampleRecord);
        
        IAM_Application__c sPowerspec = new IAM_Application__c(    
        IAM_Account_Name__c = accSampleRecordosm.ID,
        IAM_Application_Name__c = 'PowerSpec',
        IAM_Subscription_Name__c = 'PowerSpec',
        IAM_Role__c='PowerSpec_Basic',
        IAM_Status__c='Active',
        IAM_Subscription_Count__c= 10,
        IAM_Provisioned_User_Count__c=5,
        IAM_Subscription_End_Date__c= System.today() + 5,
        IAM_Free_Subscription__c= False,
        IAM_Subscription_Start_Date__c=System.today()
    );
        insert sPowerspec;
    //insert appFeatureList;
        List<IAM_Application__c> powerSpecAccRecords = [select id,IAM_Role__c,IAM_Status__c,IAM_Account_Name__c,RecordTypeid,IAM_Subscription_End_Date__c 
                                                        from IAM_Application__c where IAM_Account_Name__c in: accntIds and 
                                                        IAM_Application_Name__c = 'PowerSpec' and IAM_Role__c includes ('PowerSpec_Basic')];
      
 
        IAM_AccountsController.ActivateContact(contSampleRecordosm.id,'Activate');
        //IAM_AccountsController.encryptTheUserID('username');
        //IAM_AccountsController.decrypt('username');
    }
    
    
       @isTest
    static void testIAM_testfleetguardFit3(){
       test.Starttest();
       List<Contact> con=[Select id from Contact where username__c='lstTestosm@abc.com'];
        IAM_AccountsController.getFleetguardFitRole(con[0].id,'Fleetguard FIT');
        IAM_AccountsController.saveFreeAppFleetguardFit(con[0].id,'Fleetguard FIT','User');
        test.Stoptest();
       
    }
       @isTest
    static void testIAM_testfleetguardFit5(){
         test.Starttest();
        List<User> userList = new List<User>();
        set<id> accntIds = new Set<id>();
        IAM_Application_Groups__c iamAPP = [Select Id, IAM_DN_value__c, IAM_Role_Name__c 
                                           from IAM_Application_Groups__c where Name =: 'Power Spec 1.6'];
       Account accSampleRecordosm = new Account(name='AccountTest1',
                                   CMI_Account_Status__c='Pending',
                                   CMI_CDA_Status__c='New Customer Request',
                                   CSS_DistributorCode__c = '10010',
                                   IAM_Service_Provider_Code__c = '1349',
                                   Type='Dealer Account'
                                   );
    
    insert accSampleRecordosm;
        accntIds.add(accSampleRecordosm.Id);
       
  Contact contSampleRecordosm = new Contact(
        FirstName = 'Test',
        LastName ='User',
        Email = 'lstTestosm@test.com',
        AccountId = accSampleRecordosm.ID,
        IAM_Contact_Status__c = 'Active',
        CMI_Contact_Type__c = 'Secondary',
        IAM_Legacy_User__c=true,
        IAM_Internal__c=true,
        recordtypeid=Schema.SObjectType.Contact.getRecordTypeInfosByName().get('IAM').getRecordTypeId(),
        Username__c = 'lstTestosm@abc2.com',
        Phone = '9743800309'
    );
    insert contSampleRecordosm;
        
        Id profId  = [SELECT Id,Name FROM Profile Where name = 'IAM_Site_Admin_Community'].Id;
    
    User uesrSampleRecord = new User(
        LastName = 'lstTest',
        FirstName = 'frstfitFvTest',
        Email = 'lstTest@Fvtest.com',
        Alias = 'fvTest',
        Username = 'lstTest@fitfvtest.com',
        CommunityNickname = 'lstestfitFv1234',
        LocaleSidKey= 'en_US',
        TimeZoneSidKey ='GMT',
        ProfileID = profId,
        LanguageLocaleKey = 'en_US',
        EmailEncodingKey = 'UTF-8',
        contactId = contSampleRecordosm.Id,
        isActive = true
    );
    insert uesrSampleRecord;
    userList.add(uesrSampleRecord);
        
        IAM_Application__c sPowerspec = new IAM_Application__c(    
        IAM_Account_Name__c = accSampleRecordosm.ID,
        IAM_Application_Name__c = 'PowerSpec',
        IAM_Subscription_Name__c = 'PowerSpec',
        IAM_Role__c='PowerSpec_Basic',
        IAM_Status__c='Active',
        IAM_Subscription_Count__c= 10,
        IAM_Provisioned_User_Count__c=5,
        IAM_Subscription_End_Date__c= System.today() + 5,
        IAM_Free_Subscription__c= False,
        IAM_Subscription_Start_Date__c=System.today()
    );
        insert sPowerspec;
    //insert appFeatureList;
        List<IAM_Application__c> powerSpecAccRecords = [select id,IAM_Role__c,IAM_Status__c,IAM_Account_Name__c,RecordTypeid,IAM_Subscription_End_Date__c 
                                                        from IAM_Application__c where IAM_Account_Name__c in: accntIds and 
                                                        IAM_Application_Name__c = 'PowerSpec' and IAM_Role__c includes ('PowerSpec_Basic')];
      
        IAM_AccountsController.getFleetguardFitRole(contSampleRecordosm.id,'Fleetguard FIT');
        test.stopTest();
    }
      @isTest
    static void testIAM_testfleetguardFit4(){
       test.Starttest();
        List<User> userList = new List<User>();
        set<id> accntIds = new Set<id>();
        IAM_Application_Groups__c iamAPP = [Select Id, IAM_DN_value__c, IAM_Role_Name__c 
                                           from IAM_Application_Groups__c where Name =: 'Power Spec 1.6'];
       Account accSampleRecordosm = new Account(name='AccountTest1',
                                   CMI_Account_Status__c='Active',
                                   CMI_CDA_Status__c='New Customer Request',
                                   CSS_DistributorCode__c = '1237',
                                   IAM_Service_Provider_Code__c = '89756',
                                   Type='Dealer Account'
                                   );
    
    insert accSampleRecordosm;
        accntIds.add(accSampleRecordosm.Id);
        
        IAM_Application__c fleetfitrcd = new IAM_Application__c(    
        IAM_Account_Name__c = accSampleRecordosm.ID,
        IAM_Application_Name__c = 'Fleetguard FIT',
        IAM_Role__c='User',
        IAM_Status__c='Active',
        IAM_Subscription_Count__c= 10,
        IAM_Provisioned_User_Count__c=5,
        IAM_Subscription_End_Date__c= System.today() + 5,
        IAM_Subscription_Name__c='MarketPlace',
        IAM_Free_Subscription__c= False,
        IAM_Subscription_Start_Date__c=System.today()
    );
        insert fleetfitrcd;
  Contact contSampleRecordosm = new Contact(
        FirstName = 'Test22',
        LastName ='Use12r',
        Email = 'lstTestosm@test.com',
        AccountId = accSampleRecordosm.ID,
        IAM_Contact_Status__c = 'Active',
        CMI_Contact_Type__c = 'Secondary',
        IAM_Legacy_User__c=true,
        IAM_Internal__c=false,
        recordtypeid=Schema.SObjectType.Contact.getRecordTypeInfosByName().get('IAM').getRecordTypeId(),
        Username__c = 'lstTestosm@abc2.com.nishantTest122',
        Phone = '9743800309'
    );
    insert contSampleRecordosm;
        
        Id profId  = [SELECT Id,Name FROM Profile Where name = 'IAM_Site_Admin_Community'].Id;
    
    User uesrSampleRecord = new User(
        LastName = 'lstTest',
        FirstName = 'frstfitFrTest',
        Email = 'lstTest@FWtest.com',
        Alias = 'frTest',
        Username = 'lstTest@fitfrtest.com',
        CommunityNickname = 'lstestfitFr1234',
        LocaleSidKey= 'en_US',
        TimeZoneSidKey ='GMT',
        ProfileID = profId,
        LanguageLocaleKey = 'en_US',
        EmailEncodingKey = 'UTF-8',
        contactId = contSampleRecordosm.Id,
        isActive = true
    );
    insert uesrSampleRecord;
    userList.add(uesrSampleRecord);
        
        IAM_Application__c sPowerspec = new IAM_Application__c(    
        IAM_Account_Name__c = accSampleRecordosm.ID,
        IAM_Application_Name__c = 'PowerSpec',
        IAM_Subscription_Name__c = 'PowerSpec',
        IAM_Role__c='PowerSpec_Basic',
        IAM_Status__c='Active',
        IAM_Subscription_Count__c= 10,
        IAM_Provisioned_User_Count__c=5,
        IAM_Subscription_End_Date__c= System.today() + 5,
        IAM_Free_Subscription__c= False,
        IAM_Subscription_Start_Date__c=System.today()
    );
        insert sPowerspec;
    //insert appFeatureList;
        List<IAM_Application__c> powerSpecAccRecords = [select id,IAM_Role__c,IAM_Status__c,IAM_Account_Name__c,RecordTypeid,IAM_Subscription_End_Date__c 
                                                        from IAM_Application__c where IAM_Account_Name__c in: accntIds and 
                                                        IAM_Application_Name__c = 'PowerSpec' and IAM_Role__c includes ('PowerSpec_Basic')];
        
        IAM_AccountsController.saveFreeAppFleetguardFit(contSampleRecordosm.id,'Fleetguard FIT','User');
        //IAM_AccountsController.saveFreeAppFleetguardFit(contSampleRecordosm.id,'Fleetguard FIT','User');
        test.Stoptest();
       
    }
    @isTest
    static void testIAM_testOSMNewfucntionlity(){
        Account accSampleRecordosm = new Account(name='AccountTest1FixFW',
                                                 CMI_Account_Status__c='Active',
                                                 CMI_CDA_Status__c='New Customer Request',
                                                 CSS_DistributorCode__c = '1237',
                                                 IAM_Service_Provider_Code__c = '897561',
                                                 Type='Dealer Account'
                                                );
        
        insert accSampleRecordosm;
        IAM_Application__c fleetfitrcd = new IAM_Application__c(    
            IAM_Account_Name__c = accSampleRecordosm.ID,
            IAM_Application_Name__c = 'MarketPlace',
            IAM_Role__c='OSM Storefront Admin',
            IAM_Status__c='Active',
            IAM_Subscription_Count__c= 10,
            IAM_Provisioned_User_Count__c=5,
            IAM_Subscription_End_Date__c= System.today() + 5,
            IAM_Subscription_Name__c='MarketPlace',
            IAM_Free_Subscription__c= False,
            IAM_Subscription_Start_Date__c=System.today()
        );
        insert fleetfitrcd;
        
        Id profId  = [SELECT Id,Name FROM Profile Where name = 'IAM_Admin_user'].Id;
        
        User uesrSampleRecord = new User(
            LastName = 'lstTest',
            FirstName = 'frstTest',
            Email = 'lstTest@test.com',
            Alias = 'lsTest',
            Username = 'Testuser1234@test.com.testnishantosryetyddddgh',
            CommunityNickname = 'lstest1234cbxfds',
            LocaleSidKey= 'en_US',
            TimeZoneSidKey ='GMT',
            ProfileID = profId,
            LanguageLocaleKey = 'en_US',
            EmailEncodingKey = 'UTF-8',
            isActive = true
        );
    
   insert uesrSampleRecord;
   
        string uid=userinfo.getUserId();
        User user = [SELECT Id,Name FROM User WHERE id =:uid];
        /*system.runAs(user){
        Permissionset ps =[SELECT Id,Label,Name,NamespacePrefix,ProfileId FROM PermissionSet where Name='OSM_Distributor_Admin'];
       PermissionSetAssignment psa = new PermissionSetAssignment (PermissionSetId = ps.id, AssigneeId =uesrSampleRecord.id );
                           insert psa;
        }*/
          //system.runAs(uesrSampleRecord){
        Test.startTest();
            IAM_AccountsController.getRoles(fleetfitrcd.id);
        Test.stopTest();
        //}
        
    }
    
     @isTest
    static void testIAM_testUSer3(){
       test.Starttest();
       List<Contact> con=[Select id,IAM_Contact_Status__c,Account.CMI_Account_Status__c from Contact where username__c='lstTestosm@abc.com'];
       List<User> usr= [Select id,isActive from user where contactid=:con[0].id ];
        Profile p = [SELECT Id FROM Profile WHERE Name='IAM User']; 
        User u = new User(Alias = 'standt', Email='standarduser@testorg.com', 
            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName='lstTestosm@abc.com',contactid=con[0].id,isActive=false);
       insert u;
           
       IAM_AccountsController.ActivateContact(con[0].id,'Activate');
       IAM_AccountsController.ActivateContact(con[0].id,'De-Activate');
       IAM_AccountsController.ConValue(con,'Active');
        test.Stoptest();
       
    }
    
    
    
    //test method for Field test 
     @isTest
    static void testIAM_FieldTestGM(){
       test.Starttest();
        List<String> appRoles= new List<String>();
       appRoles.add('Field Test CMP Guidanz Mobile');
        Date dEndDate = System.today() + 3;
       List<Contact> con=[Select id,Name,IAM_Internal__c,Account.Type,Account.IAM_Internal_Account__c,IAM_Contact_Status__c,Account.CMI_Account_Status__c,Accountid from Contact where username__c='lstTestosm@abc.com'];
       List<IAM_Application__c> fieldTest=[Select id,IAM_Subscription_Name__c,IAM_Subscription_End_Date__C,
                                           IAM_Application_Name__c,IAM_Subscription_Start_Date__c,IAM_Role__c,
                                           IAM_Status__c,IAM_swregExpire__c,IAM_Remaining_Units__c
                                           from IAM_Application__c where IAM_Account_Name__c=:con[0].Accountid and IAM_Application_Name__c='Field Test Guidanz Mobile' and IAM_Status__c = 'Active' AND IAM_Role__c IN :appRoles LIMIT 1];
       List<User> usr= [Select id,isActive from user where contactid=:con[0].id ];
        Profile p = [SELECT Id FROM Profile WHERE Name='IAM User']; 
        User u = new User(Alias = 'standt', Email='standarduser@testorg.com', 
            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName='lstTestosm@abc.com',contactid=con[0].id,isActive=false);
       insert u;
                  
       IAM_AccountsController.getGuidanzFieldTestRole(con[0].id,'Field Test Guidanz Mobile');
       IAM_AccountsController.getSWRegExpireValue('Field Test IAS Guidanz Mobile',fieldTest[0].IAM_Subscription_End_Date__c);
       IAM_AccountsController.getSWRegExpireValue('Field Test CMP Guidanz Mobile',fieldTest[0].IAM_Subscription_End_Date__c);
       IAM_AccountsController.getSWRegExpireValue('Field Test SRV Guidanz Mobile',fieldTest[0].IAM_Subscription_End_Date__c);
       IAM_AccountsController.getSWRegExpireValue('Field Test PS PRO Guidanz Mobile',fieldTest[0].IAM_Subscription_End_Date__c);
       IAM_AccountsController.getSWRegExpireValue('Field Test Power Plus Lite Guidanz Mobile',fieldTest[0].IAM_Subscription_End_Date__c);
       IAM_AccountsController.getSWRegExpireValue('Beta Testing Guidanz Mobile',fieldTest[0].IAM_Subscription_End_Date__c);
       IAM_AccountsController.getNPBUDignExpireValue('BASIC',fieldTest[0].IAM_Subscription_End_Date__c);
       IAM_AccountsController.getNPBUDignExpireValue('Manufacturing',fieldTest[0].IAM_Subscription_End_Date__c);
       IAM_AccountsController.getNPBUDignExpireValue('Advance',fieldTest[0].IAM_Subscription_End_Date__c);
       IAM_AccountsController.getNPBUDignExpireValue('Pro',fieldTest[0].IAM_Subscription_End_Date__c);
       IAM_AccountsController.saveFreeAppGuidanzMobileFT(con[0].id,'Field Test Guidanz Mobile',appRoles,dEndDate,1);
       
        test.Stoptest();
       
    }
      @isTest
    static void testIAM_testfleetguardFW(){
       test.Starttest();
        List<User> userList = new List<User>();
        //userList = [Select Id FROM User where Email =: 'lstTest@test.com' Limit 1];
        //IAM_Application_Groups__c iamAPP = IAM_Application_Groups__c.getValues('Power Spec 1.6');
        set<id> accntIds = new Set<id>();
        IAM_Application_Groups__c iamAPP = [Select Id, IAM_DN_value__c, IAM_Role_Name__c 
                                           from IAM_Application_Groups__c where Name =: 'Power Spec 1.6'];
       //List<Contact> con=[Select id from Contact where username__c='lstTestosm@abc.com'];
       Account accSampleRecord4 = new Account(name='AccountTestfiFWt24511',
                                   CMI_Account_Status__c = 'Active',
                                   type='Dealer',
                                   IAM_Service_Provider_Code__c='332009'        
                                   );
    
    insert accSampleRecord4;
        accntIds.add(accSampleRecord4.Id);
            
  Contact contSampleRecordosm = new Contact(
        FirstName = 'Testfit',
        LastName ='Userfit',
        Email = 'lstTestosm@testFIT1.com.tFluidWatch',
        AccountId = accSampleRecord4.ID,
        IAM_Contact_Status__c = 'Active',
        CMI_Contact_Type__c = 'Secondary',
        //IAM_Legacy_User__c=true,
        //IAM_Internal__c=true,
        recordtypeid=Schema.SObjectType.Contact.getRecordTypeInfosByName().get('IAM').getRecordTypeId(),
        Username__c = 'lstTestosm@testFIT.com.tFluidWatch',
        Phone = '9743800309'
    );
    insert contSampleRecordosm;
        
    Id profId  = [SELECT Id,Name FROM Profile Where name = 'IAM_Site_Admin_Community'].Id;
    
    User uesrSampleRecord = new User(
        LastName = 'lstTest',
        FirstName = 'frstFWTest',
        Email = 'lstTest@FWtest.com',
        Alias = 'lsFWTest',
        Username = 'lstTest@FWtest.com',
        CommunityNickname = 'lstestFW1234',
        LocaleSidKey= 'en_US',
        TimeZoneSidKey ='GMT',
        ProfileID = profId,
        LanguageLocaleKey = 'en_US',
        EmailEncodingKey = 'UTF-8',
        contactId = contSampleRecordosm.Id,
        isActive = true
    );
    insert uesrSampleRecord;
    userList.add(uesrSampleRecord);    
        
       IAM_Application__c fleetfitrcd = new IAM_Application__c(    
        IAM_Account_Name__c = accSampleRecord4.ID,
        IAM_Application_Name__c = 'FluidWatch',
        IAM_Role__c='Sample Fluid Registration User',
        IAM_Status__c='Active',
        IAM_Subscription_Count__c= 10,
        IAM_Provisioned_User_Count__c=5,
        IAM_Subscription_End_Date__c= System.today() + 5,
        IAM_Free_Subscription__c= False,
        IAM_Subscription_Start_Date__c=System.today()
    );
        insert fleetfitrcd;
        
        //User sUserRec = IAM_TestData.createUser(contSampleRecordosm, accSampleRecord4, 'System Administrator');
        //userList.add(sUserRec);
        //Email = 'lstTest@test.com'
        
        IAM_Application__c sPowerspec = new IAM_Application__c(    
        IAM_Account_Name__c = accSampleRecord4.ID,
        IAM_Application_Name__c = 'PowerSpec',
        IAM_Subscription_Name__c = 'PowerSpec',
        IAM_Role__c='PowerSpec_Basic',
        IAM_Status__c='Active',
        IAM_Subscription_Count__c= 10,
        IAM_Provisioned_User_Count__c=5,
        IAM_Subscription_End_Date__c= System.today() + 5,
        IAM_Free_Subscription__c= False,
        IAM_Subscription_Start_Date__c=System.today()
    );
        insert sPowerspec;
    //insert appFeatureList;
        List<IAM_Application__c> powerSpecAccRecords = [select id,IAM_Role__c,IAM_Status__c,IAM_Account_Name__c,RecordTypeid,IAM_Subscription_End_Date__c 
                                                        from IAM_Application__c where IAM_Account_Name__c in: accntIds and 
                                                        IAM_Application_Name__c = 'PowerSpec' and IAM_Role__c includes ('PowerSpec_Basic')];
        list<string> role = new list<String>();
        role.add('Sample Fluid Registration User');
        IAM_AccountsController.getFluidwatchRole(contSampleRecordosm.id,'FluidWatch');
        IAM_AccountsController.saveFreeAppFluidWatch(contSampleRecordosm.id,'FluidWatch',role);
        test.Stoptest();
       
    }
    
    @isTest
    Static void testGetContacts(){
        Account accSampleRecord4 = new Account(name='AccountTestfiFWt24511',
                                   CMI_Account_Status__c = 'Active',
                                   type='Dealer',
                                   IAM_Service_Provider_Code__c='3320091'        
                                   );
    
    insert accSampleRecord4;
    
     IAM_Application__c fleetfitrcd = new IAM_Application__c(    
        IAM_Account_Name__c = accSampleRecord4.ID,
        IAM_Application_Name__c = 'Cummins Service Training',
        IAM_Role__c='Service Training User',
        IAM_Status__c='Active',
        IAM_Subscription_Count__c= 10,
        IAM_Provisioned_User_Count__c=5,
        IAM_Subscription_End_Date__c= System.today() + 5,
        IAM_Free_Subscription__c= False,
        IAM_Subscription_Start_Date__c=System.today(),
        IAM_Subscription_Name__c='Cummins Service Training'
    );
    insert fleetfitrcd;
    
    IAM_Application__c fleetfitrcdqsol = new IAM_Application__c(    
        IAM_Account_Name__c = accSampleRecord4.ID,
        IAM_Application_Name__c = 'QuickServe Online',
        IAM_Role__c='QSOL Dealer',
        IAM_Status__c='Active',
        IAM_Subscription_Count__c= 10,
        IAM_Provisioned_User_Count__c=5,
        IAM_Subscription_End_Date__c= System.today() + 5,
        IAM_Free_Subscription__c= False,
        IAM_Subscription_Start_Date__c=System.today(),
        IAM_Subscription_Name__c='QuickServe Online EBU',
        IAM_Qsolexpiration__c='02-NOV-2100EBUACTVE'
    );
    insert fleetfitrcdqsol;
    List<String> roleName= new List<String>();
    
    test.StartTest();
       IAM_AccountsController.getContacts(fleetfitrcd.id,'Service Training User','Part Order'); 
       IAM_AccountsController.getFluidwatchRole(fleetfitrcd.id,'Service Training User');
       
    test.StopTest();
        
    }
    
    
     @isTest
    Static void testGetContacts12(){
        Account accSampleRecord4 = new Account(name='AccountTestfiFWt24511',
                                   CMI_Account_Status__c = 'Active',
                                   type='Dealer',
                                   IAM_Service_Provider_Code__c='33200912'        
                                   );
    
    insert accSampleRecord4;
    
     IAM_Application__c fleetfitrcd = new IAM_Application__c(    
        IAM_Account_Name__c = accSampleRecord4.ID,
        IAM_Application_Name__c = 'Cummins Service Training',
        IAM_Role__c='Service Training User',
        IAM_Status__c='Active',
        IAM_Subscription_Count__c= 10,
        IAM_Provisioned_User_Count__c=5,
        IAM_Subscription_End_Date__c= System.today() + 5,
        IAM_Free_Subscription__c= False,
        IAM_Subscription_Start_Date__c=System.today(),
        IAM_Subscription_Name__c='Cummins Service Training'
    );
    insert fleetfitrcd;
    
    List<String> roleName= new List<String>();
      //Date newDate = Date.newInstance();
    test.StartTest();
       IAM_AccountsController.getContacts(fleetfitrcd.id,'Service Training User','Part Order'); 
       IAM_AccountsController.saveFreeAppFluidWatch(fleetfitrcd.id,'dummy user',roleName);
       IAM_AccountsController.getFleetguardFitRole(fleetfitrcd.id,'Service Training User');
       IAM_AccountsController.getUserReclaimStatus(fleetfitrcd.id);
       IAM_AccountsController.deactivateAccountSub(fleetfitrcd.id,'Service Training User','Part Order');
       //IAM_AccountsController.saveFreeAppGuidanz(fleetfitrcd.id,'Service Training User','Part Order',newDate);
       IAM_AccountsController.saveFreeAppRSW(fleetfitrcd.id,'Service Training User',roleName);
    test.StopTest();
        
    }
    
    //@Anupam changes for Global Dealer Portal and Fluids Registration
    
    @isTest
    static void testIAM_testGDP(){
        Test.StartTest();  
        Account accSampleRecord5 = new Account(name='AccountTest6',Type = 'Dealer Account',
                                    CMI_Account_Status__c = 'Active',
                                    CMI_CDA_Status__c='New Customer Request',
                                    //ParentId = accSampleRecord4.id,
                                    //CMI_Region__c = 'East Asia',
                                    CMI_Cummins_Support_Email__c = 'abc123@gmail.com'
                                    );
    
    insert accSampleRecord5;
    set<Id> conIds = new set<Id>();
    //IAM_Application__c app = [SELECT Id,Name FROM IAM_Application__c WHERE IAM_Subscription_Name__c='TestSubscription3997'];
    //IAM_Application__c appConnected = [SELECT Id,Name FROM IAM_Application__c WHERE IAM_Subscription_Name__c='TestSubscription1GuidanzMobTest'];
    //Contact con = [SELECT Id,Name FROM Contact WHERE Email = 'lstTest2323jjl@test.com'];
    Account acc = [SELECT Id,Name FROM Account WHERE name ='AccountTest6'];
    
        List<IAM_Application__c> appListToInsert = new List<IAM_Application__c>();
   IAM_Application__c gdp = new IAM_Application__c();    
        gdp.IAM_Account_Name__c = acc.Id;
        gdp.IAM_Application_Name__c = 'Global Dealer Portal';
        gdp.IAM_Role__c='Dealer User';
        gdp.IAM_Status__c='Active';
        //IAM_Subscription_Count__c= 10,
        //IAM_Provisioned_User_Count__c=5,
        //IAM_Subscription_End_Date__c= System.today() + 5,
        //IAM_Subscription_Name__c='TestSubscriptionGDP',
        //IAM_Free_Subscription__c= true,
        //IAM_Subscription_Start_Date__c=System.today(),
        gdp.recordtypeid = Schema.SObjectType.IAM_Application__c.getRecordTypeInfosByName().get('Global Dealer Portal').getRecordTypeId();
    	appListToInsert.add(gdp);
    
    //insert gdp;
        
     IAM_Application__c fluidsReg = new IAM_Application__c();    
        fluidsReg.IAM_Account_Name__c = acc.Id;
        fluidsReg.IAM_Application_Name__c = 'Fluids Registration';
        fluidsReg.IAM_Role__c='Sample Fluid Registration User';
        fluidsReg.IAM_Status__c='Active';
        //IAM_Subscription_Count__c= 10,
        //IAM_Provisioned_User_Count__c=5,
        fluidsReg.IAM_Subscription_End_Date__c= System.today() + 100;
        //IAM_Subscription_Name__c='TestSubscriptionGDP',
        //IAM_Free_Subscription__c= true,
        fluidsReg.IAM_Subscription_Start_Date__c=System.today();
        fluidsReg.recordtypeid = Schema.SObjectType.IAM_Application__c.getRecordTypeInfosByName().get('Fluids Registration').getRecordTypeId();
        appListToInsert.add(fluidsReg);
        
        insert appListToInsert;
        
    Contact con = new Contact(
        FirstName = 'Anupam Test',
        LastName ='User Test class',
        Email = 'lstTest12gdp@test.com',
        AccountId = acc.ID,
        IAM_Contact_Status__c = 'active',
        CMI_Contact_Type__c = 'Secondary',
        Username__c = 'lstTest12defeduniquee@test.com',
        Phone = '9743800309'
    );
    
    insert con;
        
    
       
     List<String> roles= new List<String>();
     List<String> fluidRegRoles= new List<String>();
     roles.add('Dealer User');
     fluidRegRoles.add('Sample Fluid Registration User');  
     
    IAM_AccountsController.getGlobalDealerPortalRole(con.id,'Global Dealer Portal');
    IAM_AccountsController.saveFreeAppGlobalDealerPortal(con.id,'Global Dealer Portal',roles);
    IAM_AccountsController.getFluidRegisterRole(con.id,'Fluids Registration');
    IAM_AccountsController.saveFreeAppFluidRegister(con.id,'Fluids Registration',fluidRegRoles);
    Test.stopTest();
    }
    
    @isTest
    Static void testFTGuidanzMobElsePart(){
        
        List<String> appRoles= new List<String>();
        appRoles.add('Beta Testing Guidanz Mobile');
        Date dEndDate = System.today() + 3;
        List<Contact> con=[Select id,Name,IAM_Internal__c,Account.Type,Account.IAM_Internal_Account__c,IAM_Contact_Status__c,Account.CMI_Account_Status__c,Accountid from Contact where username__c='lstTestFTGM@abc.com'];
        
        List<IAM_Application__c> fieldTestGM=[Select id,IAM_Subscription_Name__c,IAM_Subscription_End_Date__C,
                                           IAM_Application_Name__c,IAM_Subscription_Start_Date__c,IAM_Role__c,
                                           IAM_Status__c,IAM_swregExpire__c,IAM_Remaining_Units__c
                                           from IAM_Application__c where IAM_Account_Name__c=:con[0].Accountid and IAM_Application_Name__c='Field Test Guidanz Mobile' and IAM_Status__c = 'Active' AND IAM_Role__c IN :appRoles LIMIT 1];
        Test.startTest();
        IAM_AccountsController.saveFreeAppGuidanzMobileFT(con[0].id,'Field Test Guidanz Mobile',appRoles,dEndDate,1);
        Test.stopTest();
        
    }
    
    @isTest
    static void testIAM_test17(){
    set<Id> conIds = new set<Id>();
        set<id> Idcon2 = new set<id>();
    //IAM_Application__c app = [SELECT Id,Name FROM IAM_Application__c WHERE IAM_Subscription_Name__c='TestSubscription3997'];
    IAM_Application__c appConnected = [SELECT Id,Name FROM IAM_Application__c WHERE IAM_Subscription_Name__c='TestSubscription1GuidanzMobTest'];
    //Contact con = [SELECT Id,Name FROM Contact WHERE Email = 'lstTest2323jjl@test.com'];
    //Account acc = [SELECT Id,Name FROM Account WHERE name ='AccountTest3'];
    /*Account acc9 = new Account(name='AccountTest3Fix',
                                   CMI_Account_Status__c = 'Active',
                                   type='Dealer',
                                   IAM_Service_Provider_Code__c='987829'        
                                   );
    
    insert acc9;*/
        Account acc9 = [Select ID from Account where CMI_Cummins_Support_Email__c =: 'abc987@gmail.com' limit 1];
          
    Contact con = new Contact(
        FirstName = 'Amar Test',
        LastName ='User Test class',
        Email = 'lstTest12defed@test.com',
        AccountId = acc9.ID,
        IAM_Contact_Status__c = 'Inactive',
        CMI_Contact_Type__c = 'Primary',
        Username__c = 'lstTest12defed@test.com',
        Phone = '9743800309'
    );
    
    insert con;
     Idcon2.add(con.Id);   
     Contact con2 = new Contact(
        FirstName = 'Amar Test',
        LastName ='User Test class',
        Email = 'lstTest12dettt@test.com',
        AccountId = acc9.ID,
        IAM_Contact_Status__c = 'Inactive',
        CMI_Contact_Type__c = 'Primary',
        Username__c = 'lstTest12dettt@test.com',
        Phone = '9743800309'
    );
    
    insert con2;
        
    IAM_Application__c MarketPlaceApp = new IAM_Application__c(    
        IAM_Account_Name__c = acc9.ID,
        IAM_Application_Name__c = 'Marketplace',
        IAM_Role__c='OSM Sales User',
        IAM_Status__c='Active',
        IAM_Subscription_Count__c= 10,
        IAM_Provisioned_User_Count__c=5,
        IAM_Subscription_End_Date__c= System.today() + 5,
        IAM_Subscription_Name__c='TestSubscriptionMarketplace',
        IAM_Free_Subscription__c= False,
        IAM_Subscription_Start_Date__c=System.today()
    );
    insert   MarketPlaceApp;
        
    IAM_Application__c connectedSolApplication03 = new IAM_Application__c(    
        IAM_Account_Name__c = acc9.ID,
        IAM_Application_Name__c = 'Connected Solutions',
        IAM_Role__c='PrimaryContact',
        IAM_Status__c='Active',
        IAM_Subscription_Count__c= 10,
        IAM_Provisioned_User_Count__c=5,
        IAM_Subscription_End_Date__c= System.today() + 5,
        IAM_Subscription_Name__c='TestSubscriptionConnectedSolution',
        IAM_Free_Subscription__c= False,
        IAM_Source__c = 'Marketplace',
        IAM_Subscription_Start_Date__c=System.today()
    );
    
    //insert connectedSolApplication03;
           
    Test.startTest();
   /* IAM_Contact_Provisioning__c iamContSampleRecordConnectedSol = new IAM_Contact_Provisioning__c(
        IAM_Account_Application__c = appConnected.ID,
        RecordTypeId = Schema.SObjectType.IAM_Contact_Provisioning__c.getRecordTypeInfosByName().get('Connected Solutions').getRecordTypeId(),
        IAM_Application_Name__c = 'Connected Solutions',
        IAM_Contact__c= con.Id,
        IAM_End_Date__c= System.today() + 5,
        IAM_Role__c='PrimaryContact',
        IAM_Start_Date__c=System.today(),
        IAM_Status__c='Active'
        );
   insert iamContSampleRecordConnectedSol; */
   
   IAM_Contact_Provisioning__c marketplaceconpro = new IAM_Contact_Provisioning__c(
        IAM_Account_Application__c = MarketPlaceApp.ID,
        RecordTypeId = Schema.SObjectType.IAM_Contact_Provisioning__c.getRecordTypeInfosByName().get('Marketplace').getRecordTypeId(),
        IAM_Application_Name__c = 'Marketplace',
        IAM_Contact__c= con2.Id,
        IAM_End_Date__c= System.today() + 5,
        IAM_Role__c='OSM Sales User',
        IAM_Start_Date__c=System.today(),
        IAM_Status__c='Active'
        );
   insert marketplaceconpro; 
      
    Id profId  = [SELECT Id,Name FROM Profile Where name = 'IAM_Site_Admin_Community'].Id;
    
    User newUser = new User(
    profileId = profId,
    username = 'newUser@yahoo.com',
    email = 'pb@ff.com',
    emailencodingkey = 'UTF-8',
    localesidkey = 'en_US',
    languagelocalekey = 'en_US',
    timezonesidkey = 'America/Los_Angeles',
    alias='nuser',
    lastname='lastname',
    contactId = con.id,
    isActive = true
    );
       
    insert newUser;
    
    Idcon2.add(con2.id); 
    conIds.add(newUser.contactId);
    
    IAM_AccountsController.CreateConProv(Idcon2,MarketPlaceApp);
    Test.stopTest();
    } 
    
    /* Test Guidanz Service Portal Roles */
    static testMethod void guidanzServicePortalTest1() {
        Account acc = IAM_TestData.createAccount();
        Contact con = IAM_TestData.createContact(acc.Id);
        IAM_Application__c appAccess = IAM_TestData.createAccountSubscription(acc.Id, Label.IAM_AppName_GuidanzServicePortal,
        'General User', con);
        Test.startTest();
        	IAM_AccountsController.getGuidanzServicePortalRole(con.Id, Label.IAM_AppName_GuidanzServicePortal);
        Test.stopTest();            
    }
    
    /* Test Guidanz Service Portal Roles */
    static testMethod void guidanzServicePortalTest2() {
        Account acc = IAM_TestData.createAccount();
        Contact con = IAM_TestData.createContact(acc.Id);
        Test.startTest();
        	IAM_AccountsController.getGuidanzServicePortalRole(con.Id, Label.IAM_AppName_GuidanzServicePortal);
        Test.stopTest();            
    }
    //Start-changes for Cummins API Portal-@Suresh  
    @isTest
    static void testIAM_testCumminsAPIPortal(){
        Test.StartTest();  
        Account accSampleRecord = new Account(name='CumminsAPITest7',Type = 'Dealer Account',
                                              CMI_Account_Status__c = 'Active',
                                              CMI_CDA_Status__c='New Customer Request',
                                              CMI_Cummins_Support_Email__c = 'abcxyz123@gmail.com'
                                             );
        
        insert accSampleRecord;
        set<Id> conIds = new set<Id>();
        Account acc = [SELECT Id,Name FROM Account WHERE name ='CumminsAPITest7'];
       Contact con = new Contact(
            FirstName = 'Cummins API',
            LastName ='User Test class',
            Email = 'lstTest12cap@test.com',
            AccountId = acc.ID,
            IAM_Contact_Status__c = 'active',
            CMI_Contact_Type__c = 'Secondary',
            Username__c = 'lstTest12defeduniqueecap@test.com',
            Phone = '9743800309'
        );
        
        insert con;
         Contact cont = new Contact(
            FirstName = 'Cummins API Portal',
            LastName ='User Test class',
            Email = 'lstTest123cap@test.com',
            AccountId = acc.ID,
            IAM_Contact_Status__c = 'Pending',
            CMI_Contact_Type__c = 'Secondary',
            Username__c = 'lstTest123defeduniqueecap@test.com',
            Phone = '9743800309'
        );
        
        insert cont;
		
        List<String> roles= new List<String>();
        roles.add('API Owner');  
        
        IAM_AccountsController.getCumminsAPIPortalRole(con.id,'Cummins API Portal');
        IAM_AccountsController.saveFreeAppCumminsAPIPortal(con.id,'Cummins API Portal',roles);
        IAM_AccountsController.getFluidRegisterRole(con.id,'Cummins API Portal');
        IAM_AccountsController.saveFreeAppFluidRegister(con.id,'Cummins API Portal',roles);
        
        IAM_Application__c cap = new IAM_Application__c();    
        cap.IAM_Account_Name__c = acc.Id;
        cap.IAM_Application_Name__c = 'Cummins API Portal';
        cap.IAM_Role__c='API Owner';
        cap.IAM_Status__c='Active';
        cap.recordtypeid = Schema.SObjectType.IAM_Application__c.getRecordTypeInfosByName().get('Cummins API Portal').getRecordTypeId();
        insert cap;
        
        IAM_Contact_Provisioning__c c = new IAM_Contact_Provisioning__c(
            IAM_Account_Application__c = cap.ID,
            RecordTypeId = Schema.SObjectType.IAM_Contact_Provisioning__c.getRecordTypeInfosByName().get('Cummins API Portal').getRecordTypeId(),
            IAM_Application_Name__c = 'Cummins API Portal',
            IAM_Contact__c= con.Id,
            IAM_Assigned_Units__c=2,
            IAM_Remaining_Units__c=1,
            IAM_End_Date__c= System.today() + 5,
            IAM_Role__c='API owner',
            IAM_Start_Date__c=System.today(),
            IAM_Status__c='Active'
        );
        insert c; 
        
        IAM_AccountsController.getCumminsAPIPortalRole(con.id,'Cummins API Portal');
        IAM_AccountsController.saveFreeAppCumminsAPIPortal(con.id,'Cummins API Portal',roles);
        IAM_AccountsController.getFluidRegisterRole(con.id,'Cummins API Portal');
        IAM_AccountsController.saveFreeAppFluidRegister(con.id,'Cummins API Portal',roles);
         IAM_AccountsController.getCumminsAPIPortalRole(cont.id,'Cummins API Portal');
        IAM_AccountsController.saveFreeAppCumminsAPIPortal(cont.id,'Cummins API Portal',roles);
        IAM_AccountsController.getFluidRegisterRole(cont.id,'Cummins API Portal');
        IAM_AccountsController.saveFreeAppFluidRegister(cont.id,'Cummins API Portal',roles);
         IAM_AccountsController.AppDeleteSingle(c.id,'Test','Test');  
        c.IAM_Assigned_Units__c=1;
        update c;
        IAM_AccountsController.AppDeleteSingle(c.id,'Test','Test');  
        Test.stopTest();
    }
    //End-changes for Cummins API Portal-@Suresh    
}