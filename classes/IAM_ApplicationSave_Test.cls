/*************************************************************************************
Name:  IAM_ApplicationSaveTest
Copyright © 2019  Cummins
**************************************************************************************
Purpose: Test Class for IAM_ApplicationSave for all methods
**************************************************************************************
History
--------------------------------------------------------------------------------------
VERSION         AUTHOR            DATE              DETAIL                                
1.0      Karthik Golakaram      10/12/2019      INITIAL DEVELOPMENT 
1.1      Anupam Adhikari        09/17/2021      Added Reclaim Change
1.2      Sandeep Vuyyuru        10/13/2021      Useing this for Pentest telease
1.3      Anupam Adhikari        10/21/2021      Useing this for Pentest release V2
**************************************************************************************
**************************************************************************************/
@isTest
public class IAM_ApplicationSave_Test {
    
    /* Create Test Data */
    @testSetup
    static void BuildData() {
    
        Account accP=new Account();
        accP.Name='AccountPp';
        accP.Type='Dealer Account';
        accP.BillingStreet='1260 N MARR ROAD';
        accP.BillingCity='COLUMBUS';
        accP.BillingState='Indiana';
        accP.BillingCountry='United States';
        accP.BillingPostalCode='47201';
        accp.type='Distributor Account';    
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
        insert acc1;

        Account acc2=new Account(); 
        acc2.Name='Account133';
        acc2.Type='Dealer Account';
        acc2.ParentId=accP.Id;
        acc2.BillingStreet='1260 N MARR ROAD';
        acc2.BillingCity='COLUMBUS';
        acc2.BillingState='Indiana';
        acc2.BillingCountry='United States';
        acc2.BillingPostalCode='47201';    
        insert acc2;

        Contact c2=new Contact();
        c2.RecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('IAM').getRecordTypeId();
        c2.FirstName = 'myfirstn';
        c2.LastName ='mylastn';
        c2.Email = 'myemail2@abc.com';
        c2.Username__c = 'myuserid2@abc.com';
        c2.AccountId = acc1.ID;
        c2.IAM_from_Registration__c=true;
        c2.IAM_Contact_Status__c = 'Active';
        c2.CMI_Contact_Type__c = 'Primary';
        insert c2; 
 
        Contact c=new Contact();
        c.RecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('IAM').getRecordTypeId();
        c.FirstName = 'myfirstn22';
        c.LastName ='mylastn22';
        c.Email = 'myemail222@abc.com';
        c.Username__c = 'myuserid222@abc.com';
        c.AccountId = acc2.ID;
        c.IAM_from_Registration__c=true;
        c.IAM_Contact_Status__c = 'Active';
        c.CMI_Contact_Type__c = 'Primary';
        insert c;

        List<IAM_Application__c> app=new List<IAM_Application__c>();
        IAM_Application__c app1=new IAM_Application__c();
        app1.RecordTypeId = Schema.SObjectType.IAM_Application__c.getRecordTypeInfosByName().get('CUMPAS 2.0').getRecordTypeId(); 
        app1.IAM_Application_Name__c='CUMPAS 2.0';
        app1.IAM_Role__c='Dealer User;Dealer Admin';
        app1.IAM_Cumpas_Modularity__c='View Credit';
        app1.IAM_Status__c = 'Active';
        app1.IAM_Subscription_Count__c=7;
        app1.IAM_Provisioned_User_Count__c=5;
        app1.IAM_Free_Subscription__c= True;
        app1.IAM_Subscription_Start_Date__c = Date.Today();
        app1.IAM_Subscription_End_Date__c = Date.Today() + 365;
        app1.IAM_Account_Name__c=acc1.Id;

        IAM_Application__c app5=new IAM_Application__c();
        app5.RecordTypeId = Schema.SObjectType.IAM_Application__c.getRecordTypeInfosByName().get('CUMPAS 2.0').getRecordTypeId(); 
        app5.IAM_Application_Name__c='CUMPAS 2.0';
        app5.IAM_Role__c='Dealer User;Dealer Admin';
        app5.IAM_Cumpas_Modularity__c='View Credit';
        app5.IAM_Subscription_Count__c=7;
        app5.IAM_Provisioned_User_Count__c=5;
        app5.IAM_Free_Subscription__c= True;
        app5.IAM_Status__c = 'Active';
        app5.IAM_Subscription_Start_Date__c = Date.Today();
        app5.IAM_Subscription_End_Date__c = Date.Today() + 365;
        app5.IAM_Account_Name__c=acc2.Id;

        IAM_Application__c appQSOL = new IAM_Application__c();
        appQSOL.IAM_Application_Name__c = 'QuickServe Online';
        appQSOL.IAM_Account_Name__c = acc1.Id;
        appQSOL.IAM_Subscription_Name__c = 'QuickServeOnline EBU';
        appQSOL.IAM_Role__c = 'QSOL Dealer';
        appQSOL.IAM_Subscription_Count__c=9999;
        appQSOL.RecordtypeID = Schema.SObjectType.IAM_Application__c.getRecordTypeInfosByName().get('QuickServe Online').getRecordTypeID();
        appQSOL.IAM_Free_Subscription__c = false;
        appQSOL.IAM_Subscription_Start_Date__c = System.Today();
        appQSOL.IAM_Subscription_End_Date__c = System.Today()+35600;
        appQSOl.IAM_Qsolexpiration__c = '02-OCT2100EBUACTIVE';
        appQSOL.IAM_Status__c = 'Active';

        IAM_Application__c app4=new IAM_Application__c();
        app4.RecordTypeId = Schema.SObjectType.IAM_Application__c.getRecordTypeInfosByName().get('Connected Solutions').getRecordTypeId(); 
        app4.IAM_Application_Name__c='Connected Solutions';
        app4.IAM_Role__c='Operator';
        app4.IAM_Subscription_Count__c=10;
        app4.IAM_Provisioned_User_Count__c=5;
        app4.IAM_Free_Subscription__c= True;
        app4.IAM_Status__c = 'Active';
        app4.IAM_Subscription_Start_Date__c = Date.Today();
        app4.IAM_Subscription_End_Date__c = Date.Today() + 365;
        app4.IAM_Account_Name__c=acc1.Id;

        app.add(app1);
        app.add(appQSOL);
        app.add(app4);
        app.add(app5);
        insert app;

        List<IAM_Contact_Provisioning__c> conPLst=new List<IAM_Contact_Provisioning__c>();
        IAM_Contact_Provisioning__c co=new IAM_Contact_Provisioning__c();
        co.RecordTypeId = Schema.SObjectType.IAM_Contact_Provisioning__c.getRecordTypeInfosByName().get('Connected Solutions').getRecordTypeId(); 
        co.IAM_Application_Name__c='Connected Solutions';
        co.IAM_Role__c='Operator';
        co.IAM_Contact__c=c.Id;
        co.IAM_Status__c ='Active';
        co.IAM_Start_Date__c = Date.Today();
        co.IAM_End_Date__c = Date.Today() + 365;
        co.IAM_Account_Application__c=app4.id;

        IAM_Contact_Provisioning__c conP2=new IAM_Contact_Provisioning__c();
        conP2.RecordTypeId = Schema.SObjectType.IAM_Contact_Provisioning__c.getRecordTypeInfosByName().get('CUMPAS 2.0').getRecordTypeId(); 
        conP2.IAM_Application_Name__c='CUMPAS 2.0';
        conP2.IAM_Role__c='Dealer User';
        conP2.IAM_Cumpas_Modularity__c='View Credit';
        conP2.IAM_Contact__c=c.Id;
        conP2.IAM_Status__c ='Active';
        co.IAM_Start_Date__c = Date.Today();
        co.IAM_End_Date__c = Date.Today() + 365;
        conP2.IAM_Account_Application__c=app5.id;
        
        IAM_Contact_Provisioning__c conR=new IAM_Contact_Provisioning__c();
        conR.RecordTypeId = Schema.SObjectType.IAM_Contact_Provisioning__c.getRecordTypeInfosByName().get('Connected Solutions').getRecordTypeId(); 
        conR.IAM_Application_Name__c='Connected Solutions';
        conR.IAM_Role__c='Operator';
        conR.IAM_Contact__c=c2.Id;
        conR.IAM_Status__c ='Active';
        co.IAM_Start_Date__c = Date.Today();
        co.IAM_End_Date__c = Date.Today() + 365;
        conR.IAM_Account_Application__c=app4.id;
                
        conPLst.add(conP2);
        conPLst.add(co);
        conPLst.add(conR);
        insert conPLst;
    }

    /* Test Connected Solution Application */
    static testmethod void test1() {   
        Contact con=[select id , name from contact where FirstName = 'myfirstn'];
        Map<string,string> appRole= new Map<string,string>() ; 
        appRole.put('Role','Operator');
        appRole.put('Application','Connected Solutions');
        appRole.put('custList','2322');
        appRole.put('usertype','External');
        String appn='Connected Solutions';
        Test.startTest();
            User u = [select id, Name, ProfileId, isActive  from User where Profile.Name = 'System Administrator' and isActive=true limit 1];
            System.runAs(u){
                IAM_ApplicationSave.saveFreeApplication(con.id,appRole,appn);
                String appn2='Repair logistics and Service';
                IAM_ApplicationSave.saveFreeApplication(con.id,appRole,appn2);
            }
        Test.stopTest();
    }

    /* Test CUMPAS Application */
    static testmethod void testAppCumpass() {   
        Contact con=[select id ,AccountId, name from contact where FirstName = 'myfirstn'];
        Map<string,string> appRole= new Map<string,string>() ;
        Map<string,string> appInfoData= new Map<string,string>() ;
        appRole.put('Role','Dealer User');
        appRole.put('Application','CUMPAS 2.0');
        String appn='CUMPAS 2.0';        
        appInfoData.put('Role','QSOL Dealer');
        appInfoData.put('Subscription','QuickServeOnline EBU');
        appInfoData.put('Application','QuickServe Online');
        List<IAM_Application__c> accApp=[Select id,IAM_Subscription_Name__c,IAM_Subscription_Start_Date__c,
                                         IAM_Subscription_Count__c,IAM_Provisioned_User_Count__c, IAM_Subscription_End_Date__c 
                                         from IAM_Application__c where IAM_Account_Name__c=:con.AccountId and IAM_Subscription_Name__c=:appInfoData.get('Subscription') limit 1];
        List<String> modularity=new List<String>{'View Credit'};
        List<String> roleNames=new List<String>{'Dealer User'};
        Test.startTest();
            User u = [select id, Name, ProfileId, isActive  from User where Profile.Name = 'System Administrator' and isActive=true limit 1];
            System.runAs(u){
                IAM_ApplicationSave.saveFreeApplicationCumpass(con.id,appRole,appn,modularity,roleNames);
                IAM_ApplicationSave.saveSubApplication(con.id,appInfoData);
            }
        Test.stopTest();
    }

    /* Test Duplicate Application Scenario 1 - CUMPAS 2.0 Application */
    static testmethod void testDuplicateScenarioe1(){   
        Contact con=[select id ,name,AccountId,IAM_Contact_Status__c from contact where FirstName = 'myfirstn22'];
        IAM_Application__c appFeatureRec = [Select Id, IAM_Application_Name__c, IAM_Role__c, IAM_Account_Name__c
                                           from IAM_Application__c where IAM_Application_Name__c =: 'CUMPAS 2.0'
                                           and IAM_Account_Name__c =: con.AccountId];
        
        Map<string,string> appRole= new Map<string,string>() ; 
        appRole.put('Role','Dealer User');
        appRole.put('Application','CUMPAS 2.0');
        appRole.put('custList','2322');
        appRole.put('usertype','External');
        String appn4='CUMPAS 2.0';
        Test.startTest();
            User u = [select id, Name, ProfileId, isActive  from User where Profile.Name = 'System Administrator' and isActive=true limit 1];
            System.runAs(u){
                IAM_ApplicationSave.saveFreeApplication(con.id,appRole,appn4);
            }
        Test.stopTest();
    }
    
    /* Test Duplication Application Scenario 2 - CUMPAS 2.0 application */
    static testmethod void testDuplicateScenarioe2(){
        Account accRec = [Select Id, Name from Account where Name = 'Account12' and Type = 'Dealer Account' Limit 1];
        Contact con=[select id ,name,AccountId,IAM_Contact_Status__c,Email,FirstName,LastName,Username__c from contact where FirstName = 'myfirstn'];
        Contact con2=[select id ,name,AccountId,IAM_Contact_Status__c,Email,FirstName,LastName,Username__c from contact where FirstName = 'myfirstn22'];
        
        IAM_Application__c appFeatureRec = [Select Id, IAM_Application_Name__c, IAM_Role__c, IAM_Account_Name__c
                                            from IAM_Application__c where IAM_Application_Name__c =: 'Connected Solutions'
                                            and IAM_Account_Name__c =: con.AccountId];
        Map<string,string> appRole= new Map<string,string>() ; 
        appRole.put('Role','Operator');
        appRole.put('Application','Connected Solutions');
        String appn7='Connected Solutions';
        List<String> modularity=new List<String>{'View Credit'};
        List<String> roleNames=new List<String>{'Dealer User'};
        Test.startTest();
            User u = [select id, Name, ProfileId, isActive  from User where Profile.Name = 'System Administrator' and isActive=true limit 1];
            System.runAs(u){
                IAM_ApplicationSave.saveFreeApplicationCumpass(con.id,appRole,appn7,modularity,roleNames);
            }
        Test.stopTest();
    }
}