@isTest
public class IAM_createConProvforContactTest{
    static testMethod void testMethod1(){
        
    
        Account acc = new Account();
        acc.Name = 'TestAccount';
        acc.IAM_Service_Provider_Code__c = '123';
        acc.Type = 'Dealer Account';
        acc.CSS_DistributorCode__c = '1234';
        acc.CSS_DBCode__c = '12345';
        acc.CSS_DealerCode__c = '456';
        insert acc;
        
        Contact con = new contact();
        con.lastName = 'Test';
        con.AccountId = acc.id;
        con.firstName = 'contact';
        con.Email = 'testContact@test.com';
        con.IAM_Contact_Status__c = 'Active';
        con.CMI_Contact_Type__c = 'Primary';
        con.phone = '8989898989';
        con.IAM_Application_Roles__c = 'Advanced';
        con.IAM_Promotion__c = '12345';
        con.IAM_Applications__c = 'cn=CSS_DN_Advanced,ou=APP_CSS,ou=application,dc=cummins,dc=com';
        con.IAM_is_member_of__c = 'cn=CSS_DN_Advanced,ou=APP_CSS,ou=application,dc=cummins,dc=com';
        Con.Username__c = 'test_user_helper6@eidm.com';
        Con.recordtypeid=Schema.getGlobalDescribe().get('Contact').getDescribe().getRecordTypeInfosByName().get('IAM').getRecordTypeId();
        
        insert con;
        
        User us1 = [select ProfileId,LastName,Email,Username,CompanyName,IAM_Application_Roles__c,IAM_Applicationgroups__c from user where ContactId =: con.id];
        
        IAM_Application__c app = new IAM_Application__c();
        app.IAM_Application_Name__c = 'Guidanz';
        app.IAM_Role__c = 'Advanced';
        app.IAM_Status__c = 'Active';
        app.IAM_Account_Name__c = acc.id;
        app.IAM_Subscription_Name__c = 'test';
        app.recordtypeid = Schema.getGlobalDescribe().get('IAM_Application__c').getDescribe().getRecordTypeInfosByName().get('Guidanz').getRecordTypeId();
        insert app;
        
        
        IAM_Contact_Provisioning__c conApp = new IAM_Contact_Provisioning__c();
        conApp.IAM_Application_Name__c = app.IAM_Application_Name__c;
        conApp.IAM_Role__c = 'Advanced';
        //conApp.IAM_Start_Date__c = system.now();
        conApp.IAM_Status__c = 'Active';
        conApp.IAM_Contact__c = con.id; 
        conApp.IAM_Account_Application__c = app.id;
        conApp.recordtypeid = Schema.getGlobalDescribe().get('IAM_Contact_Provisioning__c').getDescribe().getRecordTypeInfosByName().get('Guidanz').getRecordTypeId();
        insert conApp;
        
        List<Contact> lstCont = new List<Contact> ();
        lstCont.add(con);
        String contId = con.id;
        
        IAM_Application_Groups__c iamAppGrp1 = new IAM_Application_Groups__c ();
        iamAppGrp1.IAM_Application_Name__c = 'Guidanz';
        iamAppGrp1.IAM_Role_Name__c = 'Advanced';
        iamAppGrp1.IAM_DN_value__c = 'cn=CSS_DN_Advanced,ou=APP_CSS,ou=application,dc=cummins,dc=com';
        iamAppGrp1.Name = 'Guidanz';
        insert iamAppGrp1;
        
        User usr = [Select id,IAM_Final_Approver__c from User where Id = :UserInfo.getUserId()];
        System.RunAs(us1){
            Test.startTest();
                IAM_createConProvforContact.createConApps('test_user_helper6@eidm.com','testContact@test.com',contId,true);
                IAM_createConProvforContact.createConApps('test_user_helper6@eidm.com','testContact@test.com',contId,false);
                IAM_createConProvforContact.insertUpdateDataRecord(lstCont,'insert');
                IAM_createConProvforContact.insertUpdateDataRecord(lstCont,'update');
                IAM_createConProvforContact.reclaimConUpdate('test_user_helper6@eidm.com','testContact@test.com',contId);
            Test.stopTest();
        }
    }   
        
    static testMethod void testMethod2(){
        Account acc = new Account();
        acc.Name = 'TestAccount';
        acc.IAM_Service_Provider_Code__c = '123';
        acc.Type = 'Dealer Account';
        acc.CSS_DistributorCode__c = '1234';
        acc.CSS_DBCode__c = '12345';
        acc.CSS_DealerCode__c = '456';
        insert acc;
        
        Contact con = new contact();
        con.lastName = 'Test';
        con.AccountId = acc.id;
        con.firstName = 'contact';
        con.Email = 'testContact1@test.com';
        con.IAM_Contact_Status__c = 'Active';
        con.CMI_Contact_Type__c = 'Primary';
        con.phone = '8989898989';
        con.IAM_Application_Roles__c = 'Service Training User';
        con.IAM_Promotion__c = '12345';
        con.IAM_Applications__c = 'cn=SERVICE_TRAINING_DN_USERS,ou=APP_SERVICE_TRAINING,ou=application,dc=cummins,dc=com';
        //con.IAM_is_member_of__c = 'cn=SERVICE_TRAINING_DN_USERS,ou=APP_SERVICE_TRAINING,ou=application,dc=cummins,dc=com';
        Con.Username__c = 'test_user_helper1@eidm.com';
        Con.recordtypeid=Schema.getGlobalDescribe().get('Contact').getDescribe().getRecordTypeInfosByName().get('IAM').getRecordTypeId();
        insert con;
        
        User us1 = [select ProfileId,LastName,Email,Username,CompanyName,IAM_Application_Roles__c,IAM_Applicationgroups__c from user where ContactId =: con.id];
        
        
        //Applicatio for QSOL because of test class failure and validation rule we have.
        IAM_Application__c appQSOL = new IAM_Application__c();
        appQSOL.IAM_Application_Name__c = 'QuickServe Online';
        appQSOL.IAM_Role__c = 'QSOL Dealer';
        appQSOL.IAM_Status__c = 'Active';
        appQSOL.IAM_Account_Name__c = acc.id;
        appQSOL.IAM_Subscription_Name__c = 'QuickServe Online EBU';
        appQSOL.recordtypeid = Schema.getGlobalDescribe().get('IAM_Application__c').getDescribe().getRecordTypeInfosByName().get('QuickServe Online').getRecordTypeId();
        appqSOL.IAM_Qsolexpiration__c='12344';
        insert appQSOL;
        
        IAM_Contact_Provisioning__c conAppQSOL = new IAM_Contact_Provisioning__c();
        conAppQSOL.IAM_Application_Name__c = appQSOL.IAM_Application_Name__c;
        conAppQSOL.IAM_Role__c = 'QSOL Dealer';
        //conApp1.IAM_Start_Date__c = system.now();
        conAppQSOL.IAM_Status__c = 'Active';
        conAppQSOL.IAM_Contact__c = con.id; 
        conAppQSOL.IAM_Account_Application__c = appQSOL.id;
        conAppQSOL.IAM_QSOLexpiration__c='12344';
        conAppQSOL.IAM_Subscription_Name__c='QuickServe Online EBU';
        conAppQSOL.recordtypeid = Schema.getGlobalDescribe().get('IAM_Contact_Provisioning__c').getDescribe().getRecordTypeInfosByName().get('QuickServe Online').getRecordTypeId();
        insert conAppQSOL;
        
        //end 
        
        
        
        IAM_Application__c app1 = new IAM_Application__c();
        app1.IAM_Application_Name__c = 'Cummins Service Training';
        app1.IAM_Role__c = 'Service Training User';
        app1.IAM_Status__c = 'Active';
        app1.IAM_Account_Name__c = acc.id;
        app1.IAM_Subscription_Name__c = 'QuickServe Online EBU';
        app1.recordtypeid = Schema.getGlobalDescribe().get('IAM_Application__c').getDescribe().getRecordTypeInfosByName().get('Cummins Service Training').getRecordTypeId();
        insert app1;
        
        IAM_Contact_Provisioning__c conApp1 = new IAM_Contact_Provisioning__c();
        conApp1.IAM_Application_Name__c = app1.IAM_Application_Name__c;
        conApp1.IAM_Role__c = 'Service Training User';
        //conApp1.IAM_Start_Date__c = system.now();
        conApp1.IAM_Status__c = 'Active';
        conApp1.IAM_Contact__c = con.id; 
        conApp1.IAM_Subscription_Name__c='QuickServe Online EBU';
        conApp1.IAM_Account_Application__c = app1.id;
        conApp1.recordtypeid = Schema.getGlobalDescribe().get('IAM_Contact_Provisioning__c').getDescribe().getRecordTypeInfosByName().get('Cummins Service Training').getRecordTypeId();
        insert conApp1;
        
        IAM_Application_Groups__c iamAppGrp2 = new IAM_Application_Groups__c ();
        iamAppGrp2.IAM_Application_Name__c = 'Cummins Service Training';
        iamAppGrp2.IAM_Role_Name__c = 'Service Training User';
        iamAppGrp2.IAM_DN_value__c = 'cn=SERVICE_TRAINING_DN_USERS,ou=APP_SERVICE_TRAINING,ou=application,dc=cummins,dc=com';
        iamAppGrp2.Name = 'Cummins Service Training';
        insert iamAppGrp2;
        
        String contId = con.id;
        
        User usr = [Select id,IAM_Final_Approver__c from User where Id = :UserInfo.getUserId()];
        System.RunAs(usr){
            Test.startTest();
                IAM_createConProvforContact.createConApps('test_user_helper1@eidm.com','testContact1@test.com',contId,true);
                //IAM_createConProvforContact.createConApps('test_user_helper1@eidm.com','testContact1@test.com',contId,false);
                
            Test.stopTest();
        }
        
    }
    
    static testMethod void testMethod3(){
        Account acc = new Account();
        acc.Name = 'TestAccount';
        acc.IAM_Service_Provider_Code__c = '123';
        acc.Type = 'Dealer Account';
        acc.CSS_DistributorCode__c = '1234';
        acc.CSS_DBCode__c = '12345';
        acc.CSS_DealerCode__c = '456';
        insert acc;
        
        Contact con = new contact();
        con.lastName = 'Test';
        con.AccountId = acc.id;
        con.firstName = 'contact';
        con.Email = 'testContact2@test.com';
        con.IAM_Contact_Status__c = 'Active';
        con.CMI_Contact_Type__c = 'Primary';
        con.phone = '8989898989';
        con.IAM_Application_Roles__c = 'WWSPS CEA';
        con.IAM_Promotion__c = '12345';
        //con.IAM_Applications__c = 'cn=WWSPSCEA_USERS,ou=APP_WWSPSCEA,ou=application,dc=cummins,dc=com';
        con.IAM_is_member_of__c = 'cn=WWSPSCEA_USERS,ou=APP_WWSPSCEA,ou=application,dc=cummins,dc=com';
        Con.Username__c = 'test_user_helper2@eidm.com';
        Con.recordtypeid=Schema.getGlobalDescribe().get('Contact').getDescribe().getRecordTypeInfosByName().get('IAM').getRecordTypeId();
        insert con;
        
        User us1 = [select ProfileId,LastName,Email,Username,CompanyName,IAM_Application_Roles__c,IAM_Applicationgroups__c from user where ContactId =: con.id];
        
        
        IAM_Application__c app2 = new IAM_Application__c();
        app2.IAM_Application_Name__c = 'WWSPS';
        app2.IAM_Role__c = 'WWSPS CEA';
        app2.IAM_Status__c = 'Active';
        app2.IAM_Account_Name__c = acc.id;
        app2.IAM_Subscription_Name__c = 'test';
        app2.recordtypeid = Schema.getGlobalDescribe().get('IAM_Application__c').getDescribe().getRecordTypeInfosByName().get('WWSPS').getRecordTypeId();
        insert app2;
        
        IAM_Contact_Provisioning__c conApp2 = new IAM_Contact_Provisioning__c();
        conApp2.IAM_Application_Name__c = app2.IAM_Application_Name__c;
        conApp2.IAM_Role__c = 'WWSPS CEA';
        //conApp1.IAM_Start_Date__c = system.now();
        conApp2.IAM_Status__c = 'Active';
        conApp2.IAM_Contact__c = con.id; 
        conApp2.IAM_Account_Application__c = app2.id;
        conApp2.recordtypeid = Schema.getGlobalDescribe().get('IAM_Contact_Provisioning__c').getDescribe().getRecordTypeInfosByName().get('WWSPS').getRecordTypeId();
        insert conApp2;
        
        IAM_Application_Groups__c iamAppGrp3 = new IAM_Application_Groups__c ();
        iamAppGrp3.IAM_Application_Name__c = 'WWSPS';
        iamAppGrp3.IAM_Role_Name__c = 'WWSPS CEA';
        iamAppGrp3.IAM_DN_value__c = 'cn=WWSPSCEA_USERS,ou=APP_WWSPSCEA,ou=application,dc=cummins,dc=com';
        iamAppGrp3.Name = 'WWSPS';
        insert iamAppGrp3;
        
        String contId = con.id;
        
        User usr = [Select id,IAM_Final_Approver__c from User where Id = :UserInfo.getUserId()];
        System.RunAs(usr){
            Test.startTest();
                IAM_createConProvforContact.createConApps('test_user_helper2@eidm.com','testContact2@test.com',contId,true);
                //IAM_createConProvforContact.createConApps('test_user_helper2@eidm.com','testContact2@test.com',contId,false);
                
            Test.stopTest();
        }
        
    }
    
    static testMethod void testMethod4(){
        Account acc = new Account();
        acc.Name = 'TestAccount';
        acc.IAM_Service_Provider_Code__c = '123';
        acc.Type = 'Dealer Account';
        acc.CSS_DistributorCode__c = '1234';
        acc.CSS_DBCode__c = '12345';
        acc.CSS_DealerCode__c = '456';
        insert acc;
        
        Contact con = new contact();
        con.lastName = 'Test';
        con.AccountId = acc.id;
        con.firstName = 'contact';
        con.Email = 'testContact3@test.com';
        con.IAM_Contact_Status__c = 'Active';
        con.CMI_Contact_Type__c = 'Primary';
        con.phone = '8989898989';
        con.IAM_Application_Roles__c = 'Dealer Admin';
        con.IAM_Promotion__c = '12345';
        con.IAM_Applications__c = 'cn=DBU_DN_COMMERCE_ADMIN_DEALER,ou=App_DBU_Commerce,ou=application,dc=cummins,dc=com';
        //con.IAM_is_member_of__c = 'cn=DBU_DN_COMMERCE_ADMIN_DEALER,ou=App_DBU_Commerce,ou=application,dc=cummins,dc=com';
        Con.Username__c = 'test_user_helper3@eidm.com';
        Con.recordtypeid=Schema.getGlobalDescribe().get('Contact').getDescribe().getRecordTypeInfosByName().get('IAM').getRecordTypeId();
        insert con;
        
        User us1 = [select ProfileId,LastName,Email,Username,CompanyName,IAM_Application_Roles__c,IAM_Applicationgroups__c from user where ContactId =: con.id];
        
        
        IAM_Application__c app3 = new IAM_Application__c();
        app3.IAM_Application_Name__c = 'CUMPAS 2.0';
        app3.IAM_Role__c = 'Dealer Admin';
        app3.IAM_Status__c = 'Active';
        app3.IAM_Account_Name__c = acc.id;
        app3.IAM_Subscription_Name__c = 'test';
        app3.recordtypeid = Schema.getGlobalDescribe().get('IAM_Application__c').getDescribe().getRecordTypeInfosByName().get('CUMPAS 2.0').getRecordTypeId();
        insert app3;
        
        IAM_Contact_Provisioning__c conApp3 = new IAM_Contact_Provisioning__c();
        conApp3.IAM_Application_Name__c = app3.IAM_Application_Name__c;
        conApp3.IAM_Role__c = 'Dealer Admin';
        //conApp1.IAM_Start_Date__c = system.now();
        conApp3.IAM_Status__c = 'Active';
        conApp3.IAM_Contact__c = con.id; 
        conApp3.IAM_Account_Application__c = app3.id;
        conApp3.recordtypeid = Schema.getGlobalDescribe().get('IAM_Contact_Provisioning__c').getDescribe().getRecordTypeInfosByName().get('CUMPAS 2.0').getRecordTypeId();
        insert conApp3;
        
        IAM_Application_Groups__c iamAppGrp4 = new IAM_Application_Groups__c ();
        iamAppGrp4.IAM_Application_Name__c = 'CUMPAS 2.0';
        iamAppGrp4.IAM_Role_Name__c = 'Dealer User';
        iamAppGrp4.IAM_DN_value__c = 'cn=DBU_DN_COMMERCE_ADMIN_DEALER,ou=App_DBU_Commerce,ou=application,dc=cummins,dc=com';
        iamAppGrp4.Name = 'CUMPAS 2.0';
        iamAppGrp4.IAM_Free_application__c = true;
        insert iamAppGrp4;
        
        String contId = con.id;
        
        User usr = [Select id,IAM_Final_Approver__c from User where Id = :UserInfo.getUserId()];
        System.RunAs(usr){
            Test.startTest();
                IAM_createConProvforContact.createConApps('test_user_helper3@eidm.com','testContact3@test.com',contId,true);
                //IAM_createConProvforContact.createConApps('test_user_helper3@eidm.com','testContact3@test.com',contId,false);
                
            Test.stopTest();
        }
        
    }
    
    static testMethod void testMethod5(){
        Account acc = new Account();
        acc.Name = 'TestAccount';
        acc.IAM_Service_Provider_Code__c = '123';
        acc.Type = 'Dealer Account';
        acc.CSS_DistributorCode__c = '1234';
        acc.CSS_DBCode__c = '12345';
        acc.CSS_DealerCode__c = '456';
        insert acc;
        
        Contact con = new contact();
        con.lastName = 'Test';
        con.AccountId = acc.id;
        con.firstName = 'contact';
        con.Email = 'testContact4@test.com';
        con.IAM_Contact_Status__c = 'Active';
        con.CMI_Contact_Type__c = 'Primary';
        con.phone = '8989898989';
        con.IAM_Application_Roles__c = 'Technician';
        con.IAM_Promotion__c = '12345';
        //con.IAM_Applications__c = 'cn=eds_user,ou=APP_EDS,ou=application,dc=cummins,dc=com';
        con.IAM_is_member_of__c = 'cn=eds_user,ou=APP_EDS,ou=application,dc=cummins,dc=com';
        Con.Username__c = 'test_user_helper4@eidm.com';
        Con.recordtypeid=Schema.getGlobalDescribe().get('Contact').getDescribe().getRecordTypeInfosByName().get('IAM').getRecordTypeId();
        insert con;
        
        User us1 = [select ProfileId,LastName,Email,Username,CompanyName,IAM_Application_Roles__c,IAM_Applicationgroups__c,IAM_Promotion__c from user where ContactId =: con.id];
        
        
        IAM_Application__c app5 = new IAM_Application__c();
        app5.IAM_Application_Name__c = 'QuickServe Online';
        app5.RecordTypeId = Schema.SObjectType.IAM_Application__c.getRecordTypeInfosByName().get('QuickServe Online').getRecordTypeId();
        app5.IAM_Role__c = 'QSOL Dealer';
        app5.IAM_Status__c = 'Active';
        app5.IAM_Account_Name__c = acc.id;
        app5.IAM_Subscription_Name__c = 'QuickServe Online EBU';  
        app5.IAM_Qsolexpiration__c = 'test';
        insert app5;
        
        IAM_Contact_Provisioning__c conApp5 = new IAM_Contact_Provisioning__c();
        conApp5.IAM_Application_Name__c = app5.IAM_Application_Name__c;
        conApp5.RecordTypeId = Schema.SObjectType.IAM_Contact_Provisioning__c.getRecordTypeInfosByName().get('QuickServe Online').getRecordTypeId();
        conApp5.IAM_Role__c = 'QSOL Dealer';
        //conApp.IAM_Start_Date__c = system.now();
        conApp5.IAM_Status__c = 'Active';
        conApp5.IAM_Contact__c = con.id; 
        conApp5.IAM_Subscription_Name__c = 'QuickServe Online EBU';
        conApp5.IAM_Qsolexpiration__c = 'test';
        conApp5.IAM_Account_Application__c = app5.id;
        insert conApp5;
        
        IAM_Application__c app4 = new IAM_Application__c();
        app4.IAM_Application_Name__c = 'EDS';
        app4.IAM_Role__c = 'Technician';
        app4.IAM_Status__c = 'Active';
        app4.IAM_Account_Name__c = acc.id;
        app4.IAM_Subscription_Name__c = 'test';
        app4.IAM_Qsolexpiration__c = 'test expire';
        app4.recordtypeid = Schema.getGlobalDescribe().get('IAM_Application__c').getDescribe().getRecordTypeInfosByName().get('EDS').getRecordTypeId();
        insert app4;
        
        IAM_Contact_Provisioning__c conApp4 = new IAM_Contact_Provisioning__c();
        conApp4.IAM_Application_Name__c = app4.IAM_Application_Name__c;
        conApp4.IAM_Role__c = 'Technician';
        //conApp4.IAM_Start_Date__c = system.now();
        conApp4.IAM_Status__c = 'Active';
        conApp4.IAM_Contact__c = con.id; 
        conApp4.IAM_Account_Application__c = app4.id;
        conApp4.IAM_Qsolexpiration__c = 'test expire';
        conApp4.IAM_DA_Customer_List__c = '123456';
        conApp4.IAM_Subscription_Name__c='QuickServe Online EBU';
        //conApp4.IAM_User_Type__c = 'Internal';
        conApp4.IAM_User__c = us1.id;
        conApp4.recordtypeid = Schema.getGlobalDescribe().get('IAM_Contact_Provisioning__c').getDescribe().getRecordTypeInfosByName().get('EDS').getRecordTypeId();
        insert conApp4;
        
        IAM_Application_Groups__c iamAppGrp5 = new IAM_Application_Groups__c ();
        iamAppGrp5.IAM_Application_Name__c = 'EDS';
        iamAppGrp5.IAM_Role_Name__c = 'Technician';
        iamAppGrp5.IAM_DN_value__c = 'cn=eds_user,ou=APP_EDS,ou=application,dc=cummins,dc=com';
        iamAppGrp5.Name = 'EDS';
        iamAppGrp5.IAM_Free_application__c = true;
        insert iamAppGrp5;
        
        String contId = con.id;
        
        User usr = [Select id,IAM_Final_Approver__c from User where Id = :UserInfo.getUserId()];
        System.RunAs(usr){
            Test.startTest();
                IAM_createConProvforContact.createConApps('test_user_helper4@eidm.com','testContact4@test.com',contId,true);
                //IAM_createConProvforContact.createConApps('test_user_helper4@eidm.com','testContact4@test.com',contId,false);
                
            Test.stopTest();
        }
        
    }
    
    static testMethod void testMethod6(){
        Account acc = new Account();
        acc.Name = 'TestAccount';
        acc.IAM_Service_Provider_Code__c = '123';
        acc.Type = 'Dealer Account';
        acc.CSS_DistributorCode__c = '1234';
        acc.CSS_DBCode__c = '12345';
        acc.CSS_DealerCode__c = '456';
        insert acc;
        
        Contact con = new contact();
        con.lastName = 'Test';
        con.AccountId = acc.id;
        con.firstName = 'contact';
        con.Email = 'testContact5@test.com';
        con.IAM_Contact_Status__c = 'Active';
        con.CMI_Contact_Type__c = 'Primary';
        con.phone = '8989898989';
        con.IAM_Application_Roles__c = 'QSOL Dealer';
        con.IAM_Promotion__c = '12345';
        //con.IAM_Applications__c = 'cn=QuickServe_Dealers,ou=APP_QuickServe,ou=application,dc=cummins,dc=com';
        con.IAM_is_member_of__c = 'cn=QuickServe_Dealers,ou=APP_QuickServe,ou=application,dc=cummins,dc=com';
        Con.Username__c = 'test_user_helper5@eidm.com';
        Con.recordtypeid=Schema.getGlobalDescribe().get('Contact').getDescribe().getRecordTypeInfosByName().get('IAM').getRecordTypeId();
        insert con;
        
        User us1 = [select ProfileId,LastName,Email,Username,CompanyName,IAM_Application_Roles__c,IAM_Applicationgroups__c,IAM_Promotion__c from user where ContactId =: con.id];
        
        
        IAM_Application__c app5 = new IAM_Application__c();
        app5.IAM_Application_Name__c = 'QuickServe Online';
        app5.RecordTypeId = Schema.SObjectType.IAM_Application__c.getRecordTypeInfosByName().get('QuickServe Online').getRecordTypeId();
        app5.IAM_Role__c = 'QSOL Dealer';
        app5.IAM_Status__c = 'Active';
        app5.IAM_Account_Name__c = acc.id;
        app5.IAM_Subscription_Name__c = 'test';  
        app5.IAM_Qsolexpiration__c = 'test';
        insert app5;
        
        IAM_Contact_Provisioning__c conApp5 = new IAM_Contact_Provisioning__c();
        conApp5.IAM_Application_Name__c = app5.IAM_Application_Name__c;
        conApp5.RecordTypeId = Schema.SObjectType.IAM_Contact_Provisioning__c.getRecordTypeInfosByName().get('QuickServe Online').getRecordTypeId();
        conApp5.IAM_Role__c = 'QSOL Dealer';
        //conApp.IAM_Start_Date__c = system.now();
        conApp5.IAM_Status__c = 'Active';
        conApp5.IAM_Contact__c = con.id; 
        //conApp5.IAM_User__c = us1.id;
        conApp5.IAM_Qsolexpiration__c = 'test';
        conApp5.IAM_Account_Application__c = app5.id;
        insert conApp5;
        
        IAM_Application_Groups__c iamAppGrp6 = new IAM_Application_Groups__c ();
        iamAppGrp6.IAM_Application_Name__c = 'QuickServe Online';
        iamAppGrp6.IAM_Role_Name__c = 'QSOL Dealer';
        iamAppGrp6.IAM_DN_value__c = 'cn=QuickServe_Dealers,ou=APP_QuickServe,ou=application,dc=cummins,dc=com';
        iamAppGrp6.Name = 'QuickServe Online';
        insert iamAppGrp6;
        
        String contId = con.id;
        
        User usr = [Select id,IAM_Final_Approver__c from User where Id = :UserInfo.getUserId()];
        System.RunAs(usr){
            Test.startTest();
                IAM_createConProvforContact.createConApps('test_user_helper5@eidm.com','testContact5@test.com',contId,true);
                //IAM_createConProvforContact.createConApps('test_user_helper5@eidm.com','testContact5@test.com',contId,false);
                
            Test.stopTest();
        }
        
    }
    
    static testMethod void testMethod7(){
        Account acc = new Account();
        acc.Name = 'TestAccount';
        acc.IAM_Service_Provider_Code__c = '123';
        acc.Type = 'Dealer Account';
        acc.CSS_DistributorCode__c = '1234';
        acc.CSS_DBCode__c = '12345';
        acc.CSS_DealerCode__c = '456';
        insert acc;
        
        Contact con = new contact();
        con.lastName = 'Test';
        con.AccountId = acc.id;
        con.firstName = 'contact';
        con.Email = 'testContact6@test.com';
        con.IAM_Contact_Status__c = 'Active';
        con.CMI_Contact_Type__c = 'Secondary';
        con.phone = '8989898989';
        con.IAM_Application_Roles__c = 'Guidanz Mobile Campaign Dealer';
        con.IAM_Promotion__c = '12345';
        //con.IAM_Applications__c = 'cn=ATLAS_Universal_CAMPAIGN_DEALER,ou=APP_ATLAS_UNIVERSAL,ou=application,dc=cummins,dc=com';
        con.IAM_is_member_of__c = 'cn=ATLAS_Universal_CAMPAIGN_DEALER,ou=APP_ATLAS_UNIVERSAL,ou=application,dc=cummins,dc=com';
        Con.Username__c = 'test_user_helper6@eidm.com';
        Con.recordtypeid=Schema.getGlobalDescribe().get('Contact').getDescribe().getRecordTypeInfosByName().get('IAM').getRecordTypeId();
        insert con;
        
        List<User> usr1=[select id,Username from User where username='test_user_helper6@eidm.com'];
        
        IAM_Application__c app6 = new IAM_Application__c();
        app6.IAM_Application_Name__c = System.Label.IAM_AppName_guidanzmobile;
        app6.RecordTypeId = Schema.SObjectType.IAM_Application__c.getRecordTypeInfosByName().get(System.Label.IAM_AppName_guidanzmobile).getRecordTypeId();
        app6.IAM_Role__c = 'Guidanz Mobile Campaign Dealer';
        app6.IAM_Status__c = 'Active';
        app6.IAM_Account_Name__c = acc.id;
        app6.IAM_Guidanz_Mobile_Roles__c = 'Guidanz Mobile Campaign Dealer';
        app6.IAM_Subscription_Name__c = 'test';    
        insert app6;
        
        IAM_Contact_Provisioning__c conApp6 = new IAM_Contact_Provisioning__c();
        conApp6.IAM_Application_Name__c = app6.IAM_Application_Name__c;
        conApp6.RecordTypeId = Schema.SObjectType.IAM_Contact_Provisioning__c.getRecordTypeInfosByName().get(System.Label.IAM_AppName_guidanzmobile).getRecordTypeId();
        conApp6.IAM_Role__c = 'Guidanz Mobile Campaign Dealer';
        //conApp.IAM_Start_Date__c = system.now();
        conApp6.IAM_Status__c = 'Active';
        conApp6.IAM_Contact__c = con.id; 
        //conApp6.IAM_User__c = us1.id;
        conApp6.IAM_Account_Application__c = app6.id;
        insert conApp6;
        
        
        IAM_Application_Groups__c iamAppGrp7 = new IAM_Application_Groups__c ();
        iamAppGrp7.IAM_Application_Name__c = System.Label.IAM_AppName_guidanzmobile;
        iamAppGrp7.IAM_Role_Name__c = 'Guidanz Mobile Campaign Dealer';
        iamAppGrp7.IAM_DN_value__c = 'cn=ATLAS_Universal_CAMPAIGN_DEALER,ou=APP_ATLAS_UNIVERSAL,ou=application,dc=cummins,dc=com';
        iamAppGrp7.Name = System.Label.IAM_AppName_guidanzmobile;
        insert iamAppGrp7;
        
        Contact con1 = new contact();
        con1.lastName = 'Test';
        con1.AccountId = acc.id;
        con1.firstName = 'contact';
        con1.Email = 'testContact7@test.com';
        con1.IAM_Contact_Status__c = 'Active';
        con1.phone = '8989898989';
        con1.IAM_Application_Roles__c = 'Guidanz Mobile Campaign Dealer';
        con1.IAM_Promotion__c = '12345';
        //con.IAM_is_member_of__c = 'cn=User,ou=INSITE,ou=application,dc=cummins,dc=com';
        Con1.Username__c = 'test_user_helper7@eidm.com';
        Con1.recordtypeid=Schema.getGlobalDescribe().get('Contact').getDescribe().getRecordTypeInfosByName().get('IAM').getRecordTypeId();
        con1.IAM_Applications__c = 'cn=CUMPAS_Core,ou=APP_CUMPAS,ou=application,dc=cummins,dc=com|cn=QuickServe_Dealers,ou=APP_QuickServe,ou=application,dc=cummins,dc=com';
        insert con1;
        
        IAM_Application__c app7 = new IAM_Application__c();
        app7.IAM_Application_Name__c = 'CUMPAS 2.0';
        app7.RecordTypeId = Schema.SObjectType.IAM_Application__c.getRecordTypeInfosByName().get('CUMPAS 2.0').getRecordTypeId();
        app7.IAM_Role__c = 'Dealer User;Dealer Admin';
        app7.IAM_Status__c = 'Active';
        app7.IAM_Account_Name__c = acc.id;
        app7.IAM_Subscription_Name__c = 'test';    
        insert app7;
        
        IAM_Contact_Provisioning__c conApp7 = new IAM_Contact_Provisioning__c();
        conApp7.IAM_Application_Name__c = app7.IAM_Application_Name__c;
        conApp7.IAM_Role__c = 'Dealer User';
        conApp7.IAM_Status__c = 'Active';
        conApp7.IAM_Contact__c = con1.id; 
        conApp7.IAM_Account_Application__c = app7.id;
        conApp7.recordtypeid = Schema.getGlobalDescribe().get('IAM_Contact_Provisioning__c').getDescribe().getRecordTypeInfosByName().get('CUMPAS 2.0').getRecordTypeId();
        insert conApp7;
        
        IAM_Application_Groups__c iamAppGrp8 = new IAM_Application_Groups__c ();
        iamAppGrp8.IAM_Application_Name__c = 'CUMPAS 2.0';
        iamAppGrp8.IAM_Role_Name__c = 'Dealer User;Dealer Admin';
        iamAppGrp8.IAM_DN_value__c = 'cn=CUMPAS_Core,ou=APP_CUMPAS,ou=application,dc=cummins,dc=com';
        iamAppGrp8.Name = 'CUMPAS 2.0';
        iamAppGrp8.IAM_Free_application__c = true;
        insert iamAppGrp8;
        
        Test.startTest();    
        Contact con2 = new contact();
        con2.lastName = 'Test1';
        con2.AccountId = acc.id;
        con2.firstName = 'contact1';
        con2.Email = 'testContact9@test.com';
        con2.IAM_Contact_Status__c = 'Active';
        con2.phone = '8989898989';
        con2.IAM_Application_Roles__c = 'Guidanz Mobile Campaign Dealer';
        con2.IAM_Promotion__c = '12345';
        //con.IAM_is_member_of__c = 'cn=User,ou=INSITE,ou=application,dc=cummins,dc=com';
        Con2.Username__c = 'test_user_helper9@eidm.com';
        con2.IAM_Applications__c = 'cn=QuickServe_Dealers,ou=APP_QuickServe,ou=application,dc=cummins,dc=com';
        Con2.recordtypeid=Schema.getGlobalDescribe().get('Contact').getDescribe().getRecordTypeInfosByName().get('IAM').getRecordTypeId();
        insert con2;
        
      
        IAM_Application__c app5 = new IAM_Application__c();
        app5.IAM_Application_Name__c = 'QuickServe Online';
        app5.RecordTypeId = Schema.SObjectType.IAM_Application__c.getRecordTypeInfosByName().get('QuickServe Online').getRecordTypeId();
        app5.IAM_Role__c = 'QSOL Dealer';
        app5.IAM_Status__c = 'Active';
        app5.IAM_Account_Name__c = acc.id;
        app5.IAM_Subscription_Name__c = 'test';  
        app5.IAM_Qsolexpiration__c = 'test';
        insert app5;
        
        IAM_Contact_Provisioning__c conApp5 = new IAM_Contact_Provisioning__c();
        conApp5.IAM_Application_Name__c = app5.IAM_Application_Name__c;
        conApp5.RecordTypeId = Schema.SObjectType.IAM_Contact_Provisioning__c.getRecordTypeInfosByName().get('QuickServe Online').getRecordTypeId();
        conApp5.IAM_Role__c = 'QSOL Dealer';
        //conApp.IAM_Start_Date__c = system.now();
        conApp5.IAM_Status__c = 'Active';
        conApp5.IAM_Contact__c = con2.id; 
        //conApp5.IAM_User__c = us1.id;
        conApp5.IAM_Qsolexpiration__c = 'test';
        conApp5.IAM_Account_Application__c = app5.id;
        insert conApp5;
        
        IAM_Application_Groups__c iamAppGrp6 = new IAM_Application_Groups__c ();
        iamAppGrp6.IAM_Application_Name__c = 'QuickServe Online';
        iamAppGrp6.IAM_Role_Name__c = 'QSOL Dealer';
        iamAppGrp6.IAM_DN_value__c = 'cn=QuickServe_Dealers,ou=APP_QuickServe,ou=application,dc=cummins,dc=com';
        iamAppGrp6.Name = 'QuickServe Online';
        insert iamAppGrp6;
        
        IAM_Application_Groups__c iamAppGrp5 = new IAM_Application_Groups__c ();
        iamAppGrp5.IAM_Application_Name__c = 'EDS';
        iamAppGrp5.IAM_Role_Name__c = 'Technician';
        iamAppGrp5.IAM_DN_value__c = 'cn=eds_user,ou=APP_EDS,ou=application,dc=cummins,dc=com';
        iamAppGrp5.Name = 'EDS';
        iamAppGrp5.IAM_Free_application__c = true;
        insert iamAppGrp5;
        
        IAM_Application_Groups__c iamAppGrp2 = new IAM_Application_Groups__c ();
        iamAppGrp2.IAM_Application_Name__c = 'Cummins Service Training';
        iamAppGrp2.IAM_Role_Name__c = 'Service Training User';
        iamAppGrp2.IAM_DN_value__c = 'cn=SERVICE_TRAINING_DN_USERS,ou=APP_SERVICE_TRAINING,ou=application,dc=cummins,dc=com';
        iamAppGrp2.Name = 'Cummins Service Training';
        insert iamAppGrp2;
        
        IAM_Application_Groups__c iamAppGrp3 = new IAM_Application_Groups__c ();
        iamAppGrp3.IAM_Application_Name__c = 'WWSPS';
        iamAppGrp3.IAM_Role_Name__c = 'WWSPS CEA';
        iamAppGrp3.IAM_DN_value__c = 'cn=WWSPSCEA_USERS,ou=APP_WWSPSCEA,ou=application,dc=cummins,dc=com';
        iamAppGrp3.Name = 'WWSPS';
        insert iamAppGrp3;
        
        String contId = con.id;
        
        //User usr = [Select id,IAM_Final_Approver__c from User where Id = :UserInfo.getUserId()];
       // System.RunAs(usr1[0]){
            
                IAM_createConProvforContact.createConApps('test_user_helper6@eidm.com','testContact6@test.com',contId,true);
                //IAM_createConProvforContact.createConApps('test_user_helper6@eidm.com','testContact6@test.com',contId,false);
                contId = con1.id;
                IAM_createConProvforContact.createConApps('test_user_helper7@eidm.com','testContact7@test.com',contId,true);
                //IAM_createConProvforContact.createConApps('test_user_helper7@eidm.com','testContact7@test.com',contId,false);
                contId = con2.id;
                IAM_createConProvforContact.createConApps('test_user_helper9@eidm.com','testContact9@test.com',contId,true);
                //IAM_createConProvforContact.createConApps('test_user_helper@eidm.com','testContact9@test.com',contId,false);
            
        //}
        
        Test.stopTest();
        
    }
    
}