/************************************************************
Name:  IAM_GuiAssign_ConProv_Queueable_Test
Copyright © 2020  Cummins
=============================================================
=============================================================
Purpose:                                                            
This is test Class for IAM_GuiAssign_ConProv_Queueable class.                       
=============================================================
=============================================================
History                                                            
-------                                                            
VERSION  AUTHOR                   DATE              DETAIL                                
1.0 -    Anupam Adhikari       24/01/2022        INITIAL DEVELOPMENT         
*****************************************************/
@isTest
public class IAM_GuiAssign_ConProv_Queueable_Test {
    
    @testSetup
    Static Void testDataSetup(){
        
        List<Account> accListToInsert = new List<Account>();
        List<IAM_Application__c> guiAppFeatureList = new List<IAM_Application__c>();
        
        Test.startTest();
        Account accP=new Account();
        accP.Name='AccountPp';
        accP.Type='Distributor Account';
        accP.BillingStreet='1260 N MARR ROAD';
        accP.BillingCity='COLUMBUS';
        accP.BillingState='Indiana';
        accP.BillingCountry='United States';
        accP.BillingPostalCode='47201';    
        insert accP;        
        
        Account acc1=new Account(); 
        acc1.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('IAM').getRecordTypeId();
        acc1.Name='Account12';
        acc1.Type='Dealer Account';
        acc1.ParentId=accP.Id;
        acc1.BillingStreet='1260 N MARR ROAD';
        acc1.BillingCity='COLUMBUS';
        acc1.BillingState='Indiana';
        acc1.BillingCountry='United States';
        acc1.BillingPostalCode='47201';
        acc1.IAM_Service_Provider_Code__c = '019900';
        accListToInsert.add(acc1);
        insert accListToInsert;
        
        IAM_Application__c accProv1 = IAM_TestData.createAccountSubscription(acc1.Id, 'QuickServe Online', 'QSOL Dealer');
        IAM_Application__c accProv2 = IAM_TestData.createAccountSubscription(acc1.Id, 'EDS', 'Advanced');
        
        IAM_Application__c newApp = new IAM_Application__c();
        newApp.IAM_Application_Name__c = 'Guidanz';
        newApp.IAM_Role__c = 'Advanced';
        newApp.IAM_Status__c = System.Label.IAM_Active;
        newApp.IAM_Account_Name__c = acc1.Id;
        newApp.IAM_Subscription_Start_Date__c = system.today();
        newApp.IAM_Subscription_End_Date__c = system.today() + 36500;
        newApp.recordtypeId = Schema.SObjectType.IAM_Application__c.getRecordTypeInfosByName().get('Guidanz').getRecordTypeId();
        guiAppFeatureList.add(newApp);
        insert guiAppFeatureList;
        
        List<contact> cons=new List<contact>();
        Contact c=new Contact();
        c.RecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('IAM').getRecordTypeId();
        c.FirstName = 'myfirstn';
        c.LastName ='mylastn';
        c.Email = 'myemail2@abc.com';
        c.Username__c = 'myuserid2@abc.com';
        c.AccountId = accListToInsert[0].ID;
        c.IAM_from_Registration__c=true;
        c.IAM_Contact_Status__c = 'Active';
        c.CMI_Contact_Type__c = 'Secondary';
        c.IAM_Legacy_User__c = True;
        cons.add(c);
        insert cons;
        
        Id profId  = [SELECT Id,Name FROM Profile Where name = 'IAM_User_Community_License'].Id;
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
            contactId = c.Id,
            isActive = true
        );
        insert uesrSampleRecord;
        
        List<IAM_Contact_Provisioning__c> conProvList = New List<IAM_Contact_Provisioning__c>();
        
        IAM_Contact_Provisioning__c conProv1 = new IAM_Contact_Provisioning__c();
        conProv1.IAM_Contact__c= c.Id; 
        conProv1.IAM_Start_Date__c = System.Today();
        conProv1.IAM_End_Date__c = System.Today() + 365;
        conProv1.IAM_Application_Name__c = 'QuickServe Online';
        conProv1.IAM_Role__c = 'QSOL Dealer';
        conProv1.IAM_Qsolexpiration__c = 'IAM-2020';
        conProv1.IAM_License_Type__c = 'Test';
        conProv1.IAM_Status__c = 'Active';
        conProv1.IAM_Account_Application__c = accProv1.Id;
        conProv1.IAM_Subscription_Name__c = 'QuickServeOnline EBU';        
        conProv1.RecordtypeId = Schema.SObjectType.IAM_Contact_Provisioning__c.getRecordTypeInfosByName().get('QuickServe Online').getRecordTypeId();
        conProvList.add(conProv1);
        
        IAM_Contact_Provisioning__c conProv2 = new IAM_Contact_Provisioning__c();
        conProv2.IAM_Contact__c= c.Id; 
        conProv2.IAM_Start_Date__c = System.Today();
        conProv2.IAM_End_Date__c = System.Today() + 365;
        conProv2.IAM_Application_Name__c = 'EDS';
        conProv2.IAM_Role__c = 'Advanced';
        //conProv2.IAM_Qsolexpiration__c = 'IAM-2020';
        conProv2.IAM_License_Type__c = 'Test';
        conProv2.IAM_Status__c = 'Active';
        conProv2.IAM_Account_Application__c = accProv1.Id;
        conProv2.IAM_Subscription_Name__c = 'QuickServeOnline EBU';        
        conProv2.RecordtypeId = Schema.SObjectType.IAM_Contact_Provisioning__c.getRecordTypeInfosByName().get('EDS').getRecordTypeId();
        conProvList.add(conProv2);
        
        IAM_Contact_Provisioning__c conProv3 = new IAM_Contact_Provisioning__c();
        conProv3.IAM_Contact__c = c.Id;
        conProv3.IAM_Account_Application__c = guiAppFeatureList[0].Id;
        conProv3.IAM_Application_Name__c = 'Guidanz';
        conProv3.IAM_Role__c = 'Advanced';
        conProv3.IAM_Status__c = System.Label.IAM_Active;
        conProv3.IAM_Start_Date__c = system.today();
        conProv3.IAM_End_Date__c = System.Today() + 365;
        //conProv3.IAM_User__c = addConP.IAM_User__c;
        conProv3.recordtypeId = Schema.SObjectType.IAM_Contact_Provisioning__c.getRecordTypeInfosByName().get('Guidanz').getRecordTypeId();
        conProvList.add(conProv3);       
        if(conProvList.size() > 0){
            insert conProvList;
        }        
        Test.stopTest();       
    }
    
    static testMethod void guidanzConProvMethod1(){
        Set<Id> activeContactId = new Set<Id>();
        Map<Id, Id> mapConIdNewUser = New Map<Id, Id>();
        List<IAM_Contact_Provisioning__c> userFeatureList = new List<IAM_Contact_Provisioning__c>();
        List<IAM_Contact_Provisioning__c> guidanzUserList = new List<IAM_Contact_Provisioning__c>();
        Map<Id, IAM_Contact_Provisioning__c> mapGuidanzConprov = new Map<Id, IAM_Contact_Provisioning__c>();
        Map<Id, List<IAM_Contact_Provisioning__c>> mapOtherConprov = new Map<Id, List<IAM_Contact_Provisioning__c>>();
        
        List<Contact> conListOfPartnerAcc = [Select Id, IAM_Contact_Status__c, IAM_Contact_Owner__c, IAM_Legacy_User__c FROM Contact WHERE 
                                             (IAM_Contact_Status__c =: System.Label.IAM_Active OR IAM_Contact_Status__c =: System.Label.IAM_Reclaim)];
        if(conListOfPartnerAcc.size() > 0){
            for(Contact con : conListOfPartnerAcc){
                activeContactId.add(con.Id);
            }           
            userFeatureList = [Select Id, IAM_Contact__c, IAM_Application_Name__c, IAM_Role__c, IAM_Status__c,
                               IAM_Contact__r.IAM_Contact_Owner__c,IAM_Contact__r.FirstName,IAM_Contact__r.LastName,
                               IAM_Contact__r.Email,IAM_Contact__r.Username__c,IAM_Contact__r.Account.Name,
                               IAM_Contact__r.IAM_Ext_Legacy_Uid__c,IAM_Contact__r.IAM_is_Member_of__c,IAM_Contact__r.IAM_Work_Group_Id__c,
                               IAM_Contact__r.IAM_Product_Group_Access__c,IAM_Contact__r.Account.CMI_Account_Num__c,IAM_Contact__r.AccountId,
                               IAM_Contact__r.Phone,IAM_User__c,IAM_Contact__r.IAM_Qsolexpiration__c,IAM_Contact__r.IAM_swregexpire__c,
                               IAM_Contact__r.IAM_NpbuDiagExpire__c,IAM_Contact__r.Account.IAM_WWSPS_Regions__c,IAM_Contact__r.Account.Type,
                               IAM_Contact__r.Account.IAM_ABO_Code_Formula__c,IAM_Contact__r.IAM_Final_Approver__c,IAM_Contact__r.Account.IAM_Service_Provider_Code__c,
                               IAM_Contact__r.Account.CSS_DBCode__c,IAM_Contact__r.Account.CSS_DistributorCode__c,IAM_Contact__r.CMI_Contact_Type__c,
                               IAM_Contact__r.Account.OwnerId,IAM_Contact__r.Account.Location__c,IAM_Contact__r.Account.BillingStreet,
                               IAM_Contact__r.Account.BillingCity,IAM_Contact__r.Account.BillingCountry,IAM_Contact__r.Account.BillingPostalCode,
                               IAM_Contact__r.Account.CSS_Locale__c,IAM_Contact__r.Account.CSS_Language__c,IAM_Contact__r.Account.CSS_Timezone__c,
                               IAM_Contact__r.IAM_Applications__c,IAM_Contact__r.IAM_Application_Roles__c,IAM_Contact__r.IAM_Legacy_User__c,
                               IAM_Contact__r.IAM_Internal__c, IAM_Contact__r.IAM_Contact_Status__c, IAM_Guidanz_Skip_Validation__c,IAM_End_Date__c,
                               IAM_Account_Application__c
                               FROM IAM_Contact_Provisioning__c where IAM_Contact__c IN : activeContactId 
                               //AND (IAM_Application_Name__c = 'Guidanz' OR IAM_Application_Name__c = 'EDS') 
                               AND IAM_Status__c =: System.Label.IAM_Active AND IAM_End_Date__c >=: System.today()];
            
            for(IAM_Contact_Provisioning__c cProv : userFeatureList){
                if(cProv.IAM_Application_Name__c == 'Guidanz'){
                    guidanzUserList.add(cProv);
                    if(!mapGuidanzConprov.containsKey(cProv.IAM_Contact__c)){
                        mapGuidanzConprov.put(cProv.IAM_Contact__c, cProv);//map of Guidanz record where user is Customer Community User
                    }
                    if(!mapConIdNewUser.containsKey(cProv.IAM_Contact__c)){
                        mapConIdNewUser.put(cProv.IAM_Contact__c, cProv.IAM_Contact__r.IAM_Contact_Owner__c);
                    }
                }else{
                    if(!mapOtherConprov.containsKey(cProv.IAM_Contact__c)){
                        mapOtherConprov.put(cProv.IAM_Contact__c, new List<IAM_Contact_Provisioning__c>{cProv});
                    }else{
                        mapOtherConprov.get(cProv.IAM_Contact__c).add(cProv);
                    }
                }
            }           
            IAM_GuiAssign_ConProv_Queueable iam= new IAM_GuiAssign_ConProv_Queueable(mapGuidanzConprov,mapOtherConprov,mapConIdNewUser);
            Test.StartTest();
            System.enqueueJob(iam);
            Test.StopTest();
        }       
    }
}