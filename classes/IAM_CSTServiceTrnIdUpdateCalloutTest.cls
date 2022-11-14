@isTest(SeeAllData=true)
public class IAM_CSTServiceTrnIdUpdateCalloutTest{
    static testMethod void testMethod1(){
        Account acc = new Account();
        acc.Name = 'TestAccount';
        acc.IAM_Service_Provider_Code__c = '123892';
        acc.Type = 'Distributor Account';
        acc.CSS_DistributorCode__c = '1234';
        acc.CSS_DBCode__c = '12345';
        acc.CSS_DealerCode__c = '456';
        acc.recordtypeid = Schema.SObjectType.Account.getRecordTypeInfosByName()
                  .get(System.Label.IAM_WWSPS).getRecordTypeId();
        insert acc;
        
        Contact con = new contact();
        con.lastName = 'TestContact';
        con.AccountId = acc.id;
        con.firstName = 'firstContact';
        con.Email = 'testContact@test.com';
        con.IAM_Contact_Status__c = System.Label.IAM_Status_Active;
        con.phone = '8989898989';
        con.IAM_Applications__c = 'abcd';
        con.IAM_Qsolexpiration__c = 'testABC';
        con.IAM_swregexpire__c ='testCon';
        con.IAM_Qsolview__c = 'testCon';
        con.IAM_Final_Approver__c = 'Y';
        con.Username__c= 'test_user_helper@eidm.com';
        insert con;
        
    
        IAM_Application__c app5 = new IAM_Application__c();
        app5.IAM_Application_Name__c = System.Label.IAM_AppName_QSOL;
        app5.IAM_Role__c = 'QSOL Dealer';
        app5.IAM_Status__c = 'Active';
        app5.IAM_Account_Name__c = acc.id;
        app5.IAM_Subscription_Name__c = 'test';
        app5.IAM_Qsolexpiration__c = 'test expire';
        app5.recordtypeid = Schema.getGlobalDescribe().get('IAM_Application__c').getDescribe().getRecordTypeInfosByName().get(System.Label.IAM_AppName_QSOL).getRecordTypeId();
        insert app5;
        
        IAM_Contact_Provisioning__c conApp4 = new IAM_Contact_Provisioning__c();
        conApp4.IAM_Application_Name__c = app5.IAM_Application_Name__c;
        conApp4.IAM_Role__c = 'QSOL Dealer';
        conApp4.IAM_Status__c = 'Active';
        conApp4.IAM_Contact__c = con.id; 
        conApp4.IAM_Account_Application__c = app5.id;
        conApp4.IAM_Qsolexpiration__c = 'test expire';
        conApp4.IAM_DA_Customer_List__c = '123456';
        conApp4.IAM_Promotion__c = '12345';
        //conApp4.IAM_User__c = us1.id;
        conApp4.recordtypeid = Schema.getGlobalDescribe().get('IAM_Contact_Provisioning__c').getDescribe().getRecordTypeInfosByName().get(System.Label.IAM_AppName_QSOL).getRecordTypeId();
        insert conApp4;
        
        
        
        Set<Id> setIds = new Set<Id>();
        setIds.add(conApp4.id);
        
        
        
        
        IAM_Application_Groups__c iamAppGrp2 = new IAM_Application_Groups__c ();
        iamAppGrp2.IAM_Application_Name__c = System.Label.IAM_AppName_QSOL;
        iamAppGrp2.IAM_Role_Name__c = 'QSOL Dealer';
        iamAppGrp2.IAM_DN_value__c = 'cn=QuickServe_Dealers,ou=APP_QuickServe,ou=application,dc=cummins,dc=com';
        iamAppGrp2.Name = System.Label.IAM_AppName_QSOL;
        insert iamAppGrp2;
        
        CSS_Integration_Details__c css_intg = new CSS_Integration_Details__c();
        css_intg.Name = 'IAM_CST_User';
        css_intg.ApplicationName__c = 'IAM_CST_User';
        css_intg.IsActive__c = true;
        css_intg.End_Point__c = 'https://services-stg-oauth.cummins.com/api/oauth/token/ldaputil';
        css_intg.Key__c = 'thAQWe/AIgUevs8IGTdk4Ddx50z3F9xiqm2Hl/QMu/MuVcRJFcWzFgYxxXvpN2LZEs43hkxTJ3t67B0nx7a1qg==';
        css_intg.Username__c = 'Z7xm9X6ImVl6ND7zTJ2j/jScb740y2NP/TOoSV9vC+U=';
        css_intg.Passcode__c = 'Il3eUr1gk32ejCbujtRoFDgyeVhp+MdwlVe5n/L2Tlk3uQejsj9shK0YOC5Dy/k5HFxa4Ac6EexF+dRmHCEl8Q==';
        css_intg.AuthEnv__c = 'OAGoAuth';
        css_intg.Logging__c = 'LDAPUtil';
        css_intg.Method_Type__c = 'POST';
        css_intg.Timeout__c = 120000;
        insert css_intg;
        String body = '{"totalSize": 0,"userMessage": "Unknown Service Training ID","records": {}}';
        
        User usr = [Select id,IAM_Final_Approver__c from User where Id = :UserInfo.getUserId()];
        System.RunAs(usr){
            Test.startTest();
            Test.setMock(HttpCalloutMock.class, new IAM_SingleRequestMock(200, 'Success', body, null));
            IAM_CSTServiceTrnIdUpdateCallout.cstUserServiceTrainingIdUpdate(setIds);
          //  IAM_CSTServiceTrnIdUpdateCallout.sendEmail(con);
            IAM_CSTServiceTrnIdUpdateCallout.cmiError('test error');
            Test.setMock(HttpCalloutMock.class, new IAM_SingleRequestMock(200, 'Success', body, null));
            //IAM_CSTServiceTrnIdUpdateCallout.getResponse('puser000@amamama.com.eidmdev','12345');
            Test.stopTest();
        }
    }   
        
    static testMethod void testMethod2(){
        Account acc = new Account();
        acc.Name = 'TestAccount';
        acc.IAM_Service_Provider_Code__c = '123098';
        acc.Type = 'Distributor Account';
        acc.CSS_DistributorCode__c = '1234';
        acc.CSS_DBCode__c = '12345';
        acc.CSS_DealerCode__c = '456';
        acc.recordtypeid = Schema.SObjectType.Account.getRecordTypeInfosByName()
                  .get(System.Label.IAM_WWSPS).getRecordTypeId();
        insert acc;
        
            Contact con1 = new contact();
        con1.lastName = 'TestContact1';
        con1.AccountId = acc.id;
        con1.firstName = 'firstContact';
        con1.Email = 'testContact@test.com';
        con1.IAM_Contact_Status__c = System.Label.IAM_Status_Active;
        con1.phone = '8989898989';
        con1.IAM_Applications__c = 'abcd';
        con1.IAM_Qsolexpiration__c = 'testABC';
        con1.IAM_swregexpire__c ='testCon';
        con1.IAM_Qsolview__c = 'testCon';
        con1.IAM_Final_Approver__c = 'Y';
        con1.username__c = 'test_user_helper1@eidm.com';
        insert con1;
        
    
        
        User us2 = new User(
             ProfileId = [SELECT Id FROM Profile WHERE Name = 'IAM_Site_Admin_Community'].Id,
             LastName = 'lastIDMdev',
             Email = 'puser000@amamama.com',
             Username = 'puser000@amamama.com.eidmdev1',
             CompanyName = 'TESTIDMDEV',
             Title = 'title',
             Alias = 'alias',
             TimeZoneSidKey = 'America/Los_Angeles',
             EmailEncodingKey = 'UTF-8',
             LanguageLocaleKey = 'en_US',
             LocaleSidKey = 'en_US',ContactId=con1.id);  
        //insert us2; 
        
        IAM_Application__c app5 = new IAM_Application__c();
        app5.IAM_Application_Name__c = System.Label.IAM_AppName_QSOL;
        app5.IAM_Role__c = 'QSOL Dealer';
        app5.IAM_Status__c = 'Active';
        app5.IAM_Account_Name__c = acc.id;
        app5.IAM_Subscription_Name__c = 'test';
        app5.IAM_Qsolexpiration__c = 'test expire';
        app5.recordtypeid = Schema.getGlobalDescribe().get('IAM_Application__c').getDescribe().getRecordTypeInfosByName().get(System.Label.IAM_AppName_QSOL).getRecordTypeId();
        insert app5;
        
        IAM_Contact_Provisioning__c conApp5 = new IAM_Contact_Provisioning__c();
        conApp5.IAM_Application_Name__c = app5.IAM_Application_Name__c;
        conApp5.IAM_Role__c = 'QSOL Dealer';
        conApp5.IAM_Status__c = 'Active';
        conApp5.IAM_Contact__c = con1.id; 
        conApp5.IAM_Account_Application__c = app5.id;
        conApp5.IAM_Qsolexpiration__c = 'test expire';
        conApp5.IAM_DA_Customer_List__c = '123456';
        conApp5.IAM_Promotion__c = '12345';
        conApp5.IAM_User__c = us2.id;
        conApp5.recordtypeid = Schema.getGlobalDescribe().get('IAM_Contact_Provisioning__c').getDescribe().getRecordTypeInfosByName().get(System.Label.IAM_AppName_QSOL).getRecordTypeId();
        insert conApp5;
        
        Set<Id> setIds = new Set<Id>();
        setIds.add(conApp5.id);
            IAM_Application_Groups__c iamAppGrp2 = new IAM_Application_Groups__c ();
        iamAppGrp2.IAM_Application_Name__c = System.Label.IAM_AppName_QSOL;
        iamAppGrp2.IAM_Role_Name__c = 'QSOL Dealer';
        iamAppGrp2.IAM_DN_value__c = 'cn=QuickServe_Dealers,ou=APP_QuickServe,ou=application,dc=cummins,dc=com';
        iamAppGrp2.Name = System.Label.IAM_AppName_QSOL;
        insert iamAppGrp2;
        
        CSS_Integration_Details__c css_intg = new CSS_Integration_Details__c();
        css_intg.Name = 'IAM_CST_User';
        css_intg.ApplicationName__c = 'IAM_CST_User';
        css_intg.IsActive__c = true;
        css_intg.End_Point__c = 'https://services-stg-oauth.cummins.com/api/oauth/token/ldaputil';
        css_intg.Key__c = 'thAQWe/AIgUevs8IGTdk4Ddx50z3F9xiqm2Hl/QMu/MuVcRJFcWzFgYxxXvpN2LZEs43hkxTJ3t67B0nx7a1qg==';
        css_intg.Username__c = 'Z7xm9X6ImVl6ND7zTJ2j/jScb740y2NP/TOoSV9vC+U=';
        css_intg.Passcode__c = 'Il3eUr1gk32ejCbujtRoFDgyeVhp+MdwlVe5n/L2Tlk3uQejsj9shK0YOC5Dy/k5HFxa4Ac6EexF+dRmHCEl8Q==';
        css_intg.AuthEnv__c = 'OAGoAuth';
        css_intg.Logging__c = 'LDAPUtil';
        css_intg.Method_Type__c = 'POST';
        css_intg.Timeout__c = 120000;
        insert css_intg;
        String body = '{"totalSize": 0,"userMessage": "Unknown Service Training ID","records": {}}';
        
        User usr = [Select id,IAM_Final_Approver__c from User where Id = :UserInfo.getUserId()];
        System.RunAs(usr){
            Test.startTest();
            Test.setMock(HttpCalloutMock.class, new IAM_SingleRequestMock(200, 'Success', body, null));
            IAM_CSTServiceTrnIdUpdateCallout.cstUserServiceTrainingIdUpdate(setIds);
            Test.stopTest();
        }
    }
    
}