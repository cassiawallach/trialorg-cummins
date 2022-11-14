/************************************************************
Name:  IAM_CreateUser_Test
Copyright © 2019  Cummins
=============================================================
=============================================================
Purpose:                                                            
This is test class for IAM_CreateUser_Test class.Extra                          
=============================================================
=============================================================
History                                                            
-------                                                            
VERSION  AUTHOR                   DATE              DETAIL                                
1.0 -    Keerthy GuruMurthy     23/04/2018        INITIAL DEVELOPMENT  
1.1 -    Nishanth Verma         11/13/2020   MAde changes for fluid Watch.
1.2 -    Karthik Raj Golakaram  02/12/2021   Made changes for Shop Online.
1.3 -    Karthik Raj Golakaram  04/23/2021   Made changes for Partner Federation Test
1.4 -    Chetan  Gaikwad        04/29/2021   Cahnges for Site admin portal 
1.5 -    Lavanya Javvadi        02/08/2022   Changes for Billing address- state population 
1.6 -    Suresh Rathod          03/28/2022   Added to push for deployment
1.7 -    Chetan Gaikwad			07/28/2022	 Added to push for deployment
******************************************************/
/********************************************************************************
***********************************************************************************/
@isTest
public class IAM_CreateUser_Test {
    @Istest
    static void test_accesToken(){
        IAM_accesToken at=new IAM_accesToken();
        at.access_token='asdf';
        at.token_type='type';
        at.expires_in=20;
        at.refresh_token='yes';
        at.scope='yes';
        String myJSON = JSON.serialize(at);
        IAM_accesToken.parse(myJSON);  
    }
    
    static testMethod void testMethodOSMRole(){
        
        String osmStoreFront=System.LAbel.IAM_OSM_ContPro_Default_Roles;
        
        List<IAM_PermissionSet_Assignment__c> cstList = new List<IAM_PermissionSet_Assignment__c>();
        IAM_PermissionSet_Assignment__c cst1 = new IAM_PermissionSet_Assignment__c();
        cst1.Name='Distributor Admin';
        cst1.IAM_Permission_Set_Name__c ='OSM_Distributor_Admin';
        cstList.add(cst1);
        
        IAM_PermissionSet_Assignment__c cst2 = new IAM_PermissionSet_Assignment__c();
        cst2.Name=osmStoreFront;
        cst2.IAM_Permission_Set_Name__c =osmStoreFront;
        cstList.add(cst2);
        
        insert cstList;
        
        Account acc1 = new Account();
        acc1.Name = 'TestAccount1';
        acc1.Type = 'Distributor Account';
        acc1.recordtypeid = Schema.SObjectType.Account.getRecordTypeInfosByName().get(System.Label.IAM_WWSPS).getRecordTypeId();
        insert acc1;
        
        
        Account acc = new Account();
        acc.Name = 'TestAccount';
        acc.IAM_Service_Provider_Code__c = '123';
        acc.Type = 'Dealer Account';
        acc.CSS_DistributorCode__c = '1234';
        acc.CSS_DBCode__c = '12345';
        acc.CSS_DealerCode__c = '456';
        insert acc;
        
        List<contact> cl = new List<contact>();
        
        Contact con1 = new contact();
        con1.lastName = 'internal';
        con1.AccountId = acc.id;
        con1.firstName = 'Test';
        con1.Email = 'testContact1@test.com';
        con1.IAM_Contact_Status__c = 'Active';
        con1.CMI_Contact_Type__c = 'primary';
        con1.phone = '8989898989';
        Con1.Username__c = 'test_internaluser_helper';
        con1.IAM_Internal__c =true;
        con1.IAM_Legacy_User__c =true;
        cl.add(con1); 
        
        Contact con2 = new contact();
        con2.lastName = 'ExternalIam';
        con2.AccountId = acc.id;
        con2.firstName = 'Test';
        con2.Email = 'testContact1@test.com';
        con2.IAM_Contact_Status__c = 'Active';
        con2.CMI_Contact_Type__c = 'secondary';
        con2.phone = '8989898989';
        Con2.Username__c = 'test_externaluser_iam@eidm.com';
        con2.IAM_Internal__c =false;
        con2.IAM_Legacy_User__c =false;
        cl.add(con2);
        
        Id PCRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Product_Connectivity').getRecordTypeId();
        List<contact> createcl = new List<contact>();           
        Contact con3 = new contact();
        con3.lastName = 'ExternalnonIam';
        con3.AccountId = acc.id;
        con3.firstName = 'Test';
        con3.Email = 'testContact3@test.com';
        con3.IAM_Contact_Status__c = 'Pending';
        con3.CMI_Contact_Type__c = 'secondary';
        con3.phone = '8989898989';
        Con3.Username__c = 'test_externaluser_nonIam@eidm.com';
        con3.IAM_Internal__c =false;
        con3.IAM_Legacy_User__c =false;
        //con3.RecordTypeId = PCRecordTypeId;
        createcl.add(con3);
        insert createcl;
        
        insert cl;
        IAM_Application__c accApp = IAM_TestData.createAccountSubscription(acc.Id, 'Marketplace',
        'Distributor Admin;'+Label.IAM_OSM_ContPro_Default_Roles, con3);
        IAM_Application__c app = [Select Id,IAM_Application_Name__c from IAM_Application__c where IAM_Application_Name__c = 'Marketplace' and IAM_Account_Name__c=:acc.id Limit 1];
        
        list<IAM_Contact_Provisioning__c> lstconpro = new list<IAM_Contact_Provisioning__c>();
        
        IAM_Contact_Provisioning__c conApp1 = new IAM_Contact_Provisioning__c();
        conApp1.IAM_Application_Name__c = app.IAM_Application_Name__c;
        conApp1.IAM_Role__c = 'Distributor Admin';
        conApp1.IAM_Status__c = 'Active';
        conApp1.IAM_Contact__c = con1.id; 
        conApp1.IAM_Account_Application__c = app.id;
        conApp1.recordtypeid = Schema.getGlobalDescribe().get('IAM_Contact_Provisioning__c').getDescribe().getRecordTypeInfosByName().get('Marketplace').getRecordTypeId();
        lstconpro.add(conapp1);
        
        IAM_Contact_Provisioning__c conApp2 = new IAM_Contact_Provisioning__c();
        conApp2.IAM_Application_Name__c = app.IAM_Application_Name__c;
        conApp2.IAM_Role__c = osmStoreFront;
        conApp2.IAM_Status__c = 'Active';
        conApp2.IAM_Contact__c = con2.id; 
        conApp2.IAM_Account_Application__c = app.id;
        conApp2.recordtypeid = Schema.getGlobalDescribe().get('IAM_Contact_Provisioning__c').getDescribe().getRecordTypeInfosByName().get('Marketplace').getRecordTypeId();
        
        lstconpro.add(conapp2);
        
        insert lstconpro;
        IAM_CreateUser.CreateUser(cl);
        IAM_CreateUser.CreateUserFromActivate(createcl);
    }
    
    static testMethod void testMethodGuidanz(){
        Account acc = new Account();
        acc.Name = 'TestAccount';
        acc.IAM_Service_Provider_Code__c = '123';
        acc.Type = 'Dealer Account';
        acc.CSS_DistributorCode__c = '1234';
        acc.CSS_DBCode__c = '12345';
        acc.CSS_DealerCode__c = '456';
        insert acc;
        
        List<IAM_Application__c> appList = new List<IAM_Application__c>();
        IAM_Application__c app2=new IAM_Application__c();
        app2.RecordTypeId = Schema.SObjectType.IAM_Application__c.getRecordTypeInfosByName().get('Guidanz').getRecordTypeId(); 
        app2.IAM_Application_Name__c='Guidanz';
        app2.IAM_Role__c='Technician;Warranty';
        app2.IAM_Subscription_Count__c=99999;
        app2.IAM_Account_Name__c=acc.Id;
        appList.add(app2);
        
        IAM_Application__c app6=new IAM_Application__c();
        app6.RecordTypeId = Schema.SObjectType.IAM_Application__c.getRecordTypeInfosByName().get('QuickServe Online').getRecordTypeId(); 
        app6.IAM_Application_Name__c='QuickServe Online';
        app6.IAM_Role__c='QSOL Dealer';
        app6.IAM_Subscription_Count__c=9999;
        app6.IAM_Account_Name__c=acc.Id;
        app6.IAM_Qsolexpiration__c='exp123';
        app6.IAM_Subscription_Name__c='QuickServe Online';
        app6.IAM_Status__c='Active';
        appList.add(app6);
        insert appList;
        
        List<Contact> conlist = new List<Contact>();
        Contact con3= new Contact();
        con3.Accountid=acc.id;
        con3.FirstName='Testingfhgfhfhhgfhgfhgfhgfhgf';
        con3.LastName='lastdnamehhkjhkjhkhkkhkjhkjhkjhkjh';
        con3.email='oh611dsfftestuser33@gmail.com';
        con3.IAM_Contact_Status__c='Active';
        con3.Username__c='Usernamffegivencummins33@gmail.com';
        con3.CMI_Contact_Type__c='Primary';
        con3.recordtypeid=Schema.SObjectType.Contact.getRecordTypeInfosByName().get('IAM').getRecordTypeId();
        con3.IAM_Final_Approver__c='Y';
        con3.IAM_Applications__c='qwerty';
        con3.CMI_Contact_Type__c='Primary';
        con3.IAM_is_Member_of__c='abc';
        con3.IAM_Work_Group_Id__c='abcd';
        con3.IAM_Product_Group_Access__c='xyz';
        con3.IAM_Internal__c=false;
        con3.phone='687687687';
        conlist.add(con3);
        insert conlist;
        
        List<IAM_Contact_Provisioning__c> conproList = new List<IAM_Contact_Provisioning__c>();
        IAM_Contact_Provisioning__c co3=new IAM_Contact_Provisioning__c();
        co3.RecordTypeId = Schema.SObjectType.IAM_Contact_Provisioning__c.getRecordTypeInfosByName().get('Guidanz').getRecordTypeId(); 
        co3.IAM_Application_Name__c='Guidanz';                                
        co3.IAM_Role__c='Technician';
        co3.IAM_Contact__c=con3.Id;
        co3.IAM_Status__c ='Active';
        co3.IAM_Account_Application__c=app2.id;
        conproList.add(co3);
        
        IAM_Contact_Provisioning__c co1=new IAM_Contact_Provisioning__c();
        co1.RecordTypeId = Schema.SObjectType.IAM_Contact_Provisioning__c.getRecordTypeInfosByName().get('QuickServe Online').getRecordTypeId(); 
        co1.IAM_Application_Name__c='QuickServe Online';
        co1.IAM_Role__c='QSOL Dealer';
        co1.IAM_Contact__c=con3.Id;
        co1.IAM_Status__c ='Active';
        co1.IAM_Qsolexpiration__c='exp123';
        co1.IAM_Subscription_Name__c='QuickServe Online';
        co1.IAM_Account_Application__c=app6.id;
        conproList.add(co1);
        insert conproList;
        
        IAM_CreateUser iam=new IAM_CreateUser(conlist);
        IAM_CreateUser.Bmsinstance='123443';
        IAM_CreateUser.Customernumber='131323';
        Test.StartTest();
            System.enqueueJob(iam);
        Test.StopTest();
        
        IAM_CreateUser.CreateUser(conlist);
    }
    
    static testMethod void testMethodShopOnline(){
        Account acc = new Account();
        acc.Name = 'TestAccount';
        acc.IAM_Service_Provider_Code__c = '123';
        acc.Type = 'CIHR';
        acc.CSS_DistributorCode__c = '1234';
        acc.CSS_DBCode__c = '12345';
        acc.CSS_DealerCode__c = '456';
        acc.CSS_FleetCode__c='123';
        acc.IAM_WWSPS_Regions__c='US and Canada';
        insert acc;
        
        List<IAM_Application__c> appList = new List<IAM_Application__c>();
        IAM_Application__c app2=new IAM_Application__c();
        app2.RecordTypeId = Schema.SObjectType.IAM_Application__c.getRecordTypeInfosByName().get('Shop Cummins Online Store').getRecordTypeId(); 
        app2.IAM_Application_Name__c='Shop Cummins Online Store';
        app2.IAM_Role__c='User';
        app2.IAM_Subscription_Count__c=99999;
        app2.IAM_Account_Name__c=acc.Id;
        appList.add(app2);
        
        IAM_Application__c appGz=new IAM_Application__c();
        appGz.RecordTypeId = Schema.SObjectType.IAM_Application__c.getRecordTypeInfosByName().get('Guidanz Mobile').getRecordTypeId(); 
        appGz.IAM_Application_Name__c='Guidanz Mobile';
        appGz.IAM_Role__c='Guidanz Mobile Registered Fleet';
        appGz.IAM_Subscription_Count__c=99999;
        appGz.IAM_Account_Name__c=acc.Id;
        appList.add(appGz);
        
        IAM_Application__c appCumpas=new IAM_Application__c();
        appCumpas.RecordTypeId = Schema.SObjectType.IAM_Application__c.getRecordTypeInfosByName().get('CUMPAS 2.0').getRecordTypeId(); 
        appCumpas.IAM_Application_Name__c='CUMPAS 2.0';
        appCumpas.IAM_Role__c='Dealer User';
        appCumpas.IAM_Subscription_Count__c=99999;
        appCumpas.IAM_Account_Name__c=acc.Id;
        appList.add(appCumpas);
        
        insert appList;
        
        List<Contact> conlist = new List<Contact>();
        Contact con3= new Contact();
        con3.Accountid=acc.id;
        con3.FirstName='Testingfhgfhfhhgfhgfhgfhgfhgf';
        con3.LastName='lastdnamehhkjhkjhkhkkhkjhkjhkjhkjh';
        con3.email='oh611dsfftestuser33@gmail.com';
        con3.IAM_Contact_Status__c='Active';
        con3.Username__c='Usernamffegivencummins33@gmail.com';
        con3.CMI_Contact_Type__c='Primary';
        con3.recordtypeid=Schema.SObjectType.Contact.getRecordTypeInfosByName().get('IAM').getRecordTypeId();
        con3.IAM_Final_Approver__c='Y';
        con3.IAM_Applications__c='qwerty';
        con3.CMI_Contact_Type__c='Secondary';
        con3.IAM_is_Member_of__c='abc';
        con3.IAM_Work_Group_Id__c='abcd';
        con3.IAM_Product_Group_Access__c='xyz';
        con3.IAM_Internal__c=false;
        con3.phone='687687687';
        conlist.add(con3);
        insert conlist;
        
        List<IAM_Contact_Provisioning__c> conproList = new List<IAM_Contact_Provisioning__c>();
        IAM_Contact_Provisioning__c co3=new IAM_Contact_Provisioning__c();
        co3.RecordTypeId = Schema.SObjectType.IAM_Contact_Provisioning__c.getRecordTypeInfosByName().get('Shop Cummins Online Store').getRecordTypeId(); 
        co3.IAM_Application_Name__c='Shop Cummins Online Store';                                
        co3.IAM_Role__c='User';
        co3.IAM_Contact__c=con3.Id;
        co3.IAM_Status__c ='Active';
        co3.IAM_Account_Application__c=app2.id;
        conproList.add(co3);
        
        IAM_Contact_Provisioning__c conGM=new IAM_Contact_Provisioning__c();
        conGM.RecordTypeId = Schema.SObjectType.IAM_Contact_Provisioning__c.getRecordTypeInfosByName().get('Guidanz Mobile').getRecordTypeId(); 
        conGM.IAM_Application_Name__c='Guidanz Mobile';                                
        conGM.IAM_Role__c='Guidanz Mobile Campaign Dealer';
        conGM.IAM_Contact__c=con3.Id;
        conGM.IAM_Status__c ='Active';
        conGM.IAM_Account_Application__c=appGz.id;
        conproList.add(conGM);
       
        insert conproList;
        
        IAM_CreateUser iam=new IAM_CreateUser(conlist);
        IAM_CreateUser.Bmsinstance='123443';
        IAM_CreateUser.Customernumber='131323';
        Test.StartTest();
            System.enqueueJob(iam);
        Test.StopTest();
        
        IAM_CreateUser.CreateUser(conlist);
    }
}