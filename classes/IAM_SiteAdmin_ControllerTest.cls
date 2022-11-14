@isTest
public class IAM_SiteAdmin_ControllerTest {

    static testMethod void myUnitTest1()  {
                              
        account acc=new account();
        acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('IAM').getRecordTypeId();
        acc.name = 'test852';
        acc.BillingCountryCode = 'US';
        acc.BillingStreet = 'test1'; 
        acc.BillingCity = 'test';
        acc.BillingStateCode = 'IN';
        acc.BillingPostalCode = '87652';
        acc.CSS_DistributorCode__c = '14';
        //acc.CSS_DBCode__c = '12345';
        acc.CSS_DealerCode__c = '56';
        insert acc;

        
        contact Con=new contact();
        con.RecordTypeId = Schema.SObjectType.contact.getRecordTypeInfosByName().get('IAM').getRecordTypeId();
        Con.FirstName = 'test1';
        Con.LastName = 'test852';
        Con.Email = 'test852@gmail.com';
        con.Username__c = 'test852@gmail.com';
        Con.phone = '1112223335';
        Con.MailingStreet = 'Test Street';
        Con.MailingCity = 'Test City';
        Con.MailingPostalCode = '11111';
        Con.MailingCountryCode = 'US';
        Con.MailingStateCode = 'IN';
        Con.AccountId = acc.Id;
        con.IAM_Contact_Status__c = 'active';        
       /// Con.CMI_Contact_Type__c = 'Primary';
        insert Con;
        
        contact Con1=new contact();
        con1.RecordTypeId = Schema.SObjectType.contact.getRecordTypeInfosByName().get('IAM').getRecordTypeId();
        Con1.FirstName = 'test11';
        Con1.LastName = 'test851';
        Con1.Email = 'test851@gmail.com';
        con1.Username__c= 'test851@gmail.com';
        Con1.phone = '1112223331';
        Con1.MailingStreet = 'Test Street';
        Con1.MailingCity = 'Test City';
        Con1.MailingPostalCode = '11111';
        Con1.MailingCountryCode = 'US';
        Con1.MailingStateCode = 'IN';
        Con1.AccountId = acc.Id;
        con1.IAM_Contact_Status__c = 'active';
       // Con1.CMI_Contact_Type__c = 'Primary';
        insert Con1;
            
        App_Mapping__c app=new App_Mapping__c();
        app.name='Market Place';
        app.Back_page__c='https://login.salesforce.com/';
        app.Login_Url__c='https://www.facebook.com/';
        app.IAM_App_Protected_By__c = 'SM';
        app.IAM_Default_Role__c = 'OSM Fleet Admin';
        insert app;             
   
        Test.startTest();
        ApexPages.currentPage().getParameters().put('appid', app.id);
        IAM_SiteAdmin_Controller idm=new IAM_SiteAdmin_Controller();
        idm.strAccountId=acc.id;
        string accid = string.valueof(acc.id);
        idm.newCon.FirstName='test856';
        idm.newCon.LastName='test123';
        idm.newCon.phone='7415826936';
        idm.newCon.Email='test123432@ggg.com';
        idm.newCon.CMI_Contact_Type__c = 'Primary';
        idm.newCon.recordtypeid = Schema.SObjectType.contact.getRecordTypeInfosByName().get('IAM').getRecordTypeId();
        idm.selectedContactId = Con1.id;
        idm.getaccTypes();
        idm.generateData();
        idm.show_upload_popup();
        idm.hide_upload_popup();
        idm.getFilterApps();
        idm.getFilterRole();
        idm.getUserSearch();
        //idm.getRecordsbySelectedOrder();     
        idm.previous();
        idm.next();
        idm.getPageRecords();
        idm.refreshPageSize();
        idm.getPaginationSizeOptions();
        idm.addNewUser();
        idm.getPendingApprovals();
        idm.getDeniedRequests();
        idm.EditAccount();
        idm.getComapanyAndContactInfo();
        idm.updateUser();
        idm.getEditUserInfo();
        idm.resetUserPassword();
        idm.deactivateMultipleUser();
        idm.activeteSelectedUsers();
        idm.deleteApplication();
        idm.rejectApprovalRequest();
        idm.approveRequest();
        idm.approvalHistory();
        IAM_SiteAdmin_Controller.ApprovalStepWrapper asw = new IAM_SiteAdmin_Controller.ApprovalStepWrapper();
        Test.stopTest();
   }
   
   static testMethod void myUnitTest22(){
                             
        account acc=new account();
        acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('IAM').getRecordTypeId();
        acc.name = 'test852';
        acc.BillingCountryCode = 'US';
        acc.BillingStreet = 'test1'; 
        acc.BillingCity = 'test';
        acc.BillingStateCode = 'IN';
        acc.BillingPostalCode = '87652';
        acc.CSS_DistributorCode__c = '1234';
        acc.IAM_WWSPS_Regions__c = 'US and Canada';
        acc.CSS_DealerCode__c = '456';
        acc.type = 'OEM';
        insert acc;
        
        account acc1=new account();
        acc1.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('IAM').getRecordTypeId();
        acc1.name = 'test85234';
        acc1.BillingCountryCode = 'US';
        acc1.BillingStreet = 'test1'; 
        acc1.BillingCity = 'test';
        acc1.BillingStateCode = 'IN';
        acc1.BillingPostalCode = '87652';
        acc1.CSS_DistributorCode__c = '1234';
        //acc.CSS_DBCode__c = '12345';
        acc1.CSS_DealerCode__c = '456';
        acc1.type = 'Fleet';
        acc1.CMI_Account_Status__c = System.Label.IAM_Status_Pending;
        insert acc1;
        
        account acc2=new account();
        acc2.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('IAM').getRecordTypeId();
        acc2.name = 'test8523423';
        acc2.BillingCountryCode = 'US';
        acc2.BillingStreet = 'test1234'; 
        acc2.BillingCity = 'Columbus';
        acc2.BillingStateCode = 'IN';
        acc2.BillingPostalCode = '40723';
        acc2.CSS_DistributorCode__c = '1234';
        acc2.CSS_DealerCode__c = '456';
        acc2.type = 'Fleet';
        acc2.CMI_Account_Status__c = System.Label.IAM_Status_Inactive;
        insert acc2;
        
        contact Con=new contact();
        con.RecordTypeId = Schema.SObjectType.contact.getRecordTypeInfosByName().get('IAM').getRecordTypeId();
        Con.FirstName = 'mytest1';
        Con.LastName = 'test85223';
        Con.Email = 'test852@gmail.com';
        con.Username__c= 'test852@gmail.com';
        Con.phone = '1112223335';
        Con.MailingStreet = 'Test Street';
        Con.MailingCity = 'Tempa';
        Con.MailingPostalCode = '11111';
        Con.MailingCountryCode = 'US';
        Con.MailingStateCode = 'FL';
        Con.AccountId = acc.Id;
        con.IAM_Contact_Status__c = 'active';
        
       /// Con.CMI_Contact_Type__c = 'Primary';
        insert Con;
        
        contact Con1=new contact();
        con1.RecordTypeId = Schema.SObjectType.contact.getRecordTypeInfosByName().get('IAM').getRecordTypeId();
        Con1.FirstName = 'test11';
        Con1.LastName = 'test851';
        Con1.Email = 'test851@gmail.com';
        con1.Username__c= 'test851@gmail.com';
        Con1.phone = '1112223331';
        Con1.MailingStreet = 'Test Street';
        Con1.MailingCity = 'Test City';
        Con1.MailingPostalCode = '11111';
        Con1.MailingCountryCode = 'US';
        Con1.MailingStateCode = 'IN';
        Con1.AccountId = acc.Id;
        con1.IAM_Contact_Status__c = 'active';
       // Con1.CMI_Contact_Type__c = 'Primary';
        Con1.IAM_Site_Admin__c = true;
        Con1.IAM_Site_Admin_Role__c = System.Label.IAM_Manage_Subscription;
        insert Con1;
        

     User u = new User(
     ProfileId = [SELECT Id FROM Profile WHERE Name = 'EIDM_Community'].Id,
     LastName = 'test852',
     Email = 'test000@eidm.com',
     Username = 'test000@eidm.com' + System.currentTimeMillis(),
     CompanyName = 'eidm',
     Contactid=con.id,
     Title = 'title',
     Alias = 'alias',
     TimeZoneSidKey = 'America/Los_Angeles',
     EmailEncodingKey = 'UTF-8',
     LanguageLocaleKey = 'en_US',
     LocaleSidKey = 'en_US',
     IsActive=true );
    
    User u1 = new User(
     ProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id,
     LastName = 'test8522',
     Email = 'test0002@eidm.com',
     Username = 'test0002@eidm.com' + System.currentTimeMillis(),
     CompanyName = 'eidm',
     Title = 'title',
     Alias = 'alias',
     TimeZoneSidKey = 'America/Los_Angeles',
     EmailEncodingKey = 'UTF-8',
     LanguageLocaleKey = 'en_US',
     LocaleSidKey = 'en_US',
     IAM_Account__c = acc.id,
     IsActive=true );
     insert u1;
     List<User> lstUser = new List<User>();
     lstUser.add(u1);
     
     IAM_Application__c app2 = new IAM_Application__c();
     app2.IAM_Application_Name__c = '   Marketplace';
     app2.IAM_Role__c = 'OSM Fleet Admin';
     app2.IAM_Subscription_Start_Date__c = Date.today();
     app2.IAM_Subscription_End_Date__c = Date.today() + 360;
     app2.IAM_Status__c = 'Active';
     app2.IAM_Account_Name__c = acc.id;
     app2.recordtypeid = Schema.getGlobalDescribe().get('IAM_Application__c').getDescribe().getRecordTypeInfosByName().get('Marketplace').getRecordTypeId();
     insert app2;
     
     IAM_Contact_Provisioning__c idmContPro = new IAM_Contact_Provisioning__c();
     idmContPro.recordtypeid = app2.recordtypeid = Schema.getGlobalDescribe().get('IAM_Contact_Provisioning__c').getDescribe().getRecordTypeInfosByName().get('Marketplace').getRecordTypeId();
     idmContPro.IAM_Account_Application__c = app2.id;
     idmContPro.IAM_Contact__c = Con.id;
     idmContPro.IAM_Application_Name__c = app2.IAM_Application_Name__c;
     idmContPro.IAM_Role__c = app2.IAM_Role__c;
     idmContPro.IAM_Status__c = Con.IAM_Contact_Status__c;
     idmContPro.IAM_Start_Date__c = app2.IAM_Subscription_Start_Date__c;
     idmContPro.IAM_End_Date__c = app2.IAM_Subscription_End_Date__c;
     insert idmContPro;
     
     List<account> accList = new List<account>();
     accList.add(acc);
        App_Mapping__c app=new App_Mapping__c();
        app.name='TestApp';
        app.Back_page__c='https://login.salesforce.com/';
        app.Login_Url__c='https://www.facebook.com/';
        app.IAM_App_Protected_By__c = 'SM';
        app.IAM_Default_Role__c = 'OSM Fleet Admin';
        insert app;        
   
        
        ApexPages.currentPage().getParameters().put('appid', app.id);
        IAM_SiteAdmin_Controller idm=new IAM_SiteAdmin_Controller();
        idm.strAccountId=acc.id;
        string accid = string.valueof(acc.id);
        idm.lstAccounts = accList;
        idm.newCon.FirstName='test856';
        idm.newCon.LastName='test123';
        idm.newCon.phone='7415826936';
        idm.newCon.Email='test123432@ggg.com';
        idm.newCon.CMI_Contact_Type__c = 'Primary';
        idm.newCon.recordtypeid = Schema.SObjectType.contact.getRecordTypeInfosByName().get('IAM').getRecordTypeId();
        idm.selectedSortField = 'LastName';
        idm.selectedSortOrder = 'Ascending';
        idm.rejectApproveReason = 'my test reject';
        List<Contact> lstCont = new List<Contact>();
        lstCont.add(Con);
        lstCont.add(Con1);
        idm.objUser.addAll(lstUser);
       // idm.isDefaultCompany = false;
        List<String> lstContId = new List<String>();
        lstContId.add(Con.id);
        lstContId.add(Con1.id);
        idm.getOrderedContactList(lstCont,idm.selectedSortField,idm.selectedSortOrder);
        idm.getRecordsbySelectedOrder();
        IAM_SiteAdmin_Controller.getApproverId(acc.id);
        idm.updateContact(lstContId,System.Label.IAM_User_Deactivated_Lable,idm.rejectApproveReason,'my test comments');
        idm.updateContact(lstContId,System.Label.IAM_User_Activated_Label,idm.rejectApproveReason,'my test comments');                               
        idm.createApplication(Con);
        Test.startTest();
        idm.lstContact = [Select IAM_Internal__c, id, IAM_Contact_Status__c,
                 IAM_Approved__c, Name, Email, AccountId, Account.Name, Phone, LastName, FirstName, IAM_Site_Admin__c,IAM_Cummins_login_ID__c,
                 (select id,IAM_Application_Name__c,IAM_Role__c from Contact_Provisionings__r where IAM_Status__c =: System.Label.IAM_Status_Active) from Contact  
                 where id =: Con.id];    
        idm.selectedApp = 'Marketplace';
        System.debug('test...objUser... '+ idm.objUser);
        System.debug('test...lstAccounts... '+ idm.lstAccounts);
        idm.getRoles();
        idm.getFilterApps();
        idm.getAccType();
        idm.getRegion();
        idm.regionIs = 'US and Canada';
        idm.accountType = 'OEM';
        idm.getCompanies();
        idm.getApplications();
        //idm.getFilterRole();
        idm.isActiveInaciveUsers = false;
        idm.getActiveInactiveUsers();
        idm.strAccountId = acc.id;
        idm.userSearchText = 'my user';
        idm.getUserSearch();
        idm.selectedSortOrder = 'Descending';
        idm.getOrderedContactList(lstCont,idm.selectedSortField,idm.selectedSortOrder);
        idm.getRecordsbySelectedOrder();
        ApexPages.currentPage().getParameters().put('get_pageNumber', '1');
        idm.getPageNumberRecord();
        idm.strContactId = Con.id;
        idm.getEditUserInfo();
        idm.createApplication(Con1);
        List<account> lstAcc = new List<account>();
        lstAcc.add(acc1);
        lstAcc.add(acc2);
        idm.getStatisticsTableValue(lstAcc);
        List<String> lstUsrId = new List<String>();
        lstUsrId.add(u1.id);
        IAM_SiteAdmin_Controller.activateDeactivateUser(lstUsrId, System.Label.IAM_User_Deactivated_Lable);
        Test.stopTest();
   }
   
   static testMethod void myUnitTest33()  {
        Test.startTest();               
        account acc=new account();
        acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('IAM').getRecordTypeId();
        acc.name = 'testing892';
        acc.BillingCountryCode = 'US';
        acc.BillingStreet = 'test1'; 
        acc.BillingCity = 'test';
        acc.BillingStateCode = 'IN';
        acc.BillingPostalCode = '87652';
        //acc.CSS_DistributorCode__c = '14';
        acc.IAM_Service_Provider_Code__c = '123';
        //acc.CSS_DBCode__c = '12345';
        //acc.CSS_DealerCode__c = '6';
        acc.Type = 'Dealer Account';
        insert acc;

        
        contact Con=new contact();
        con.RecordTypeId = Schema.SObjectType.contact.getRecordTypeInfosByName().get('IAM').getRecordTypeId();
        Con.FirstName = 'test1';
        Con.LastName = 'test852';
        Con.Email = 'test852@gmail.com';
        con.Username__c= 'test852@gmail.com';
        Con.phone = '1112223335';
        Con.MailingStreet = 'Test Street';
        Con.MailingCity = 'Test City';
        Con.MailingPostalCode = '11111';
        Con.MailingCountryCode = 'US';
        Con.MailingStateCode = 'IN';
        Con.AccountId = acc.Id;
        con.IAM_Contact_Status__c = 'active';
        Con.Username__c= 'test_user0000@eidm.com' + System.Label.css_org;
        insert Con;
        
        contact Con1=new contact();
        con1.RecordTypeId = Schema.SObjectType.contact.getRecordTypeInfosByName().get('IAM').getRecordTypeId();
        Con1.FirstName = 'test11';
        Con1.LastName = 'test851';
        Con1.Email = 'test851@gmail.com';
        con1.Username__c= 'test851@gmail.com';
        Con1.phone = '1112223331';
        Con1.MailingStreet = 'Test Street';
        Con1.MailingCity = 'Test City';
        Con1.MailingPostalCode = '11111';
        Con1.MailingCountryCode = 'US';
        Con1.MailingStateCode = 'IN';
        Con1.AccountId = acc.Id;
        con1.IAM_Contact_Status__c = 'active';
        Con1.Username__c= 'teest85y2@gmail.com';
        insert Con1;
        

     User u = new User(
     ProfileId = [SELECT Id FROM Profile WHERE Name = 'EIDM_Community'].Id,
     LastName = 'test852',
     Email = 'test_user0124@eidm.com',
     Username = 'test_user0000@eidm.com',
     CompanyName = 'eidm',
     Contactid=con.id,
     Title = 'title',
     Alias = 'alias',
     TimeZoneSidKey = 'America/Los_Angeles',
     EmailEncodingKey = 'UTF-8',
     LanguageLocaleKey = 'en_US',
     LocaleSidKey = 'en_US',
     IsActive=true );
     //insert u;
    
    User u1 = new User(
     ProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id,
     LastName = 'test8522',
     Email = 'test0002@eidm.com',
     Username = 'test0002@eidm.com',
     CompanyName = 'eidm',
     Title = 'title',
     Alias = 'alias',
     TimeZoneSidKey = 'America/Los_Angeles',
     EmailEncodingKey = 'UTF-8',
     LanguageLocaleKey = 'en_US',
     LocaleSidKey = 'en_US',
     IsActive=true );
  
        App_Mapping__c app=new App_Mapping__c();
        app.name='TestApp';
        app.Back_page__c='https://login.salesforce.com/';
        app.Login_Url__c='https://www.facebook.com/';
        app.IAM_App_Protected_By__c = 'SM';
        app.IAM_Default_Role__c = 'OSM Fleet Admin';
        insert app;  
        
    IAM_Application__c app2 = new IAM_Application__c();
    app2.IAM_Application_Name__c = 'Market place';
    app2.IAM_Role__c = 'CSS_DN_ADMIN';
    app2.IAM_Status__c = 'Active';
    app2.IAM_Account_Name__c = acc.id;
    //app2.IAM_App_Protected_By__c = 'SM';
    insert app2;      
    
    List < SelectOption > accountRoles = new List < SelectOption > ();
    accountRoles.add(new SelectOption('Test1', 'Test1'));
    accountRoles.add(new SelectOption('Test2', 'Test2'));
    
    List<String> setAppRoles = new List<String> ();
    setAppRoles.add('test1');
    setAppRoles.add('test2');
    
     List<account> accList = new list<account>();
     accList.add(acc);  
        Approval.ProcessSubmitRequest app1 = new Approval.ProcessSubmitRequest();
        app1.setObjectId(con.id);
        Approval.ProcessResult result = Approval.process(app1);
        string strCons = '';
        strCons = string.valueof(con.id)+','+string.valueof(con1.id);
        ApexPages.currentPage().getParameters().put('appid', app.id);
        
        Apexpages.currentpage().getParameters().put('sele_user',u.id);
        ApexPages.CurrentPage().getParameters().put('conid',con.id);
        ApexPages.CurrentPage().getParameters().put('accid',acc.id);
        ApexPages.currentPage().getParameters().put('sele_user1',u.id);
        IAM_SiteAdmin_Controller idm=new IAM_SiteAdmin_Controller();
        idm.strAccountId=acc.id;
        string accid = string.valueof(acc.id);
        string consid = string.valueof(con.id);
        idm.application = app2;
        idm.lstAccounts = accList;
        //idm.recordId = con.id;
        idm.generateData();
        idm.getItems();
        idm.getAccType();
//      idm.showPopup();
        IAM_Application__c iamApp = new IAM_Application__c();
        iamApp.IAM_Application_Name__c = 'Marketplace';
        iamApp.IAM_Role__c = 'OSM Fleet Admin';
        iamApp.IAM_Subscription_Start_Date__c = Date.today();
        iamApp.IAM_Subscription_End_Date__c = Date.today() + 360;
        iamApp.IAM_Status__c = 'Active';
        iamApp.IAM_Account_Name__c = acc.id;
        iamApp.recordtypeid = Schema.getGlobalDescribe().get('IAM_Application__c').getDescribe().getRecordTypeInfosByName().get('Marketplace').getRecordTypeId();
        insert iamApp;
         
        IAM_Contact_Provisioning__c idmContPro = new IAM_Contact_Provisioning__c();
        idmContPro.recordtypeid = iamApp.recordtypeid = Schema.getGlobalDescribe().get('IAM_Contact_Provisioning__c').getDescribe().getRecordTypeInfosByName().get('Marketplace').getRecordTypeId();
        idmContPro.IAM_Account_Application__c = iamApp.id;
        idmContPro.IAM_Contact__c = con.id;
        idmContPro.IAM_Application_Name__c = iamApp.IAM_Application_Name__c;
        idmContPro.IAM_Role__c = iamApp.IAM_Role__c;
        idmContPro.IAM_Status__c = con.IAM_Contact_Status__c;
        idmContPro.IAM_Start_Date__c = iamApp.IAM_Subscription_Start_Date__c;
        idmContPro.IAM_End_Date__c = iamApp.IAM_Subscription_End_Date__c;
        insert idmContPro;
        idm.accountSelectedApp = 'Marketplace';
        idm.selectedApp = 'Marketplace';
        idm.selectedRole = 'OSM Fleet Admin';
        idm.lstContact = [Select IAM_Internal__c, id, IAM_Contact_Status__c,
                 IAM_Approved__c, Name, Email, AccountId, Account.Name, Phone, LastName, FirstName, IAM_Site_Admin__c,IAM_Cummins_login_ID__c,
                 (select id,IAM_Application_Name__c,IAM_Role__c from Contact_Provisionings__r where IAM_Status__c =: System.Label.IAM_Status_Active) from Contact  
                 where id =: con.id];    
        
        idm.getFilterRole();
        idm.newCon = Con;
        System.debug('before calling addNewUser() test ....  '+ idm.newCon);
        idm.objAccount = acc;
        System.debug('before calling addNewUser() test ....  '+ idm.objAccount);
        idm.addNewUser();
        Test.stopTest();
    
                                                            
   }
   
   static testMethod void myUnitTest44(){
                       
        account acc=new account();
        acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('IAM').getRecordTypeId();
        acc.name = 'test852';
        acc.BillingCountryCode = 'US';
        acc.BillingStreet = 'test1'; 
        acc.BillingCity = 'test';
        acc.BillingStateCode = 'IN';
        acc.BillingPostalCode = '87652';
        acc.CSS_DistributorCode__c = '1234';
        //acc.CSS_DBCode__c = '12345';
        acc.CSS_DealerCode__c = '456';
        acc.IAM_Service_Provider_Code__c = '12345';
        acc.CMI_Region__c = 'US and Canada';
        acc.Type = 'Dealer';
        insert acc;
        List<account> accList = new List<account>();
        accList.add(acc);
        
        contact Con=new contact();
        con.RecordTypeId = Schema.SObjectType.contact.getRecordTypeInfosByName().get('IAM').getRecordTypeId();
        Con.FirstName = 'test1';
        Con.LastName = 'test852';
        Con.Email = 'test852@gmail.com';
        con.Username__c= 'test852@gmail.com';
        Con.phone = '1112223335';
        Con.MailingStreet = 'Test Street';
        Con.MailingCity = 'Test City';
        Con.MailingPostalCode = '11111';
        Con.MailingCountryCode = 'US';
        Con.MailingStateCode = 'IN';
        Con.AccountId = acc.Id;
        con.IAM_Contact_Status__c = System.Label.IAM_Status_Active;
        Con.Username__c= 'test_user000@eidm.com' + System.Label.css_org;
        Con.IAM_Site_Admin__c = true;
        Con.IAM_Site_Admin_Role__c = System.Label.IAM_Manage_Subscription;
        insert Con;
        
        Approval.ProcessSubmitRequest app1 = new Approval.ProcessSubmitRequest();
        app1.setObjectId(con.id);
        Approval.ProcessResult result = Approval.process(app1);
        
        List<ProcessInstanceWorkitem> workItem = [Select Id FROM ProcessInstanceWorkitem WHERE ProcessInstance.TargetObjectId = : con.id];
        System.debug('workItem......  ' +workItem);
        if(!workItem.isEmpty()){
            Apexpages.currentPage().getParameters().put('myParamRej',string.valueof(workItem[0].id));
            Apexpages.currentPage().getParameters().put('myParamApprove',string.valueof(workItem[0].id));
        }
        App_Mapping__c app=new App_Mapping__c();
        app.name='Online Login';
        app.Back_page__c='https://login.salesforce.com/';
        app.Login_Url__c='https://www.facebook.com/';
        app.IAM_App_Protected_By__c = 'SM';
        app.IAM_Default_Role__c = 'OSM Fleet Admin';
        insert app;  
        
        User u = new User(
        ProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id,
        LastName = 'test852',
        Email = 'test_user0124@eidm.com',
        Username = 'test_user0000@eidm.com',
        CompanyName = 'eidm',
        //Contactid=con.id,
        Title = 'title',
        Alias = 'alias',
        TimeZoneSidKey = 'America/Los_Angeles',
        EmailEncodingKey = 'UTF-8',
        LanguageLocaleKey = 'en_US',
        LocaleSidKey = 'en_US',
        IsActive=true );
        insert u;

        User u1 = new User(
        ProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id,
        LastName = 'test8522',
        Email = 'test0002@eidm.com',
        Username = 'test0002@eidm.com',
        CompanyName = 'eidm',
        Title = 'title',
        Alias = 'alias',
        TimeZoneSidKey = 'America/Los_Angeles',
        EmailEncodingKey = 'UTF-8',
        LanguageLocaleKey = 'en_US',
        LocaleSidKey = 'en_US',
        IsActive=true );
        insert u1;
        
        IAM_SiteAdmin_Controller idm = new IAM_SiteAdmin_Controller();
        idm.strAccountId=acc.id;
        idm.newCon = Con;
        
        idm.objAccount = acc;
        
        IAM_SiteAdmin_Controller.ApprovalData appData = new IAM_SiteAdmin_Controller.ApprovalData('test','user','test.user@gmail.com','test acc','Marketplace','test.user','my reject comments');
        
        idm.mapContactIdToUser = new Map <string, User>();
        idm.mapContactIdToUser.put(string.valueof(u.id), u);
        idm.mapContactIdToUser.put(string.valueof(u1.id), u1);
        String strids = string.valueof(u.id)+','+string.valueof(u1.id);
        Apexpages.currentpage().getParameters().put('get_selectedUsers',strids);
        System.debug('before call test ..idm.mapContactIdToUser.  ' +idm.mapContactIdToUser);
        

        Test.startTest();
            idm.deactivateMultipleUser();
            idm.activeteSelectedUsers();
            idm.updateUser();
            idm.rejectApprovalRequest();
            idm.approveRequest();
        Test.stopTest();
        
                                                   
   }
   
   static testMethod void myUnitTest55()  {
                       
        account acc=new account();
        acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('IAM').getRecordTypeId();
        acc.name = 'test852';
        acc.BillingCountryCode = 'US';
        acc.BillingStreet = 'test1'; 
        acc.BillingCity = 'test';
        acc.BillingStateCode = 'IN';
        acc.BillingPostalCode = '87652';
        acc.CSS_DistributorCode__c = '1234';
        acc.IAM_WWSPS_Regions__c = 'US and Canada';
        //acc.CSS_DBCode__c = '12345';
        acc.CSS_DealerCode__c = '456';
        acc.IAM_Service_Provider_Code__c = '12345';
        acc.CMI_Region__c = 'US and Canada';
        acc.Type = 'Distributor Account';
        insert acc;
        
        account acc1=new account();
        acc1.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('IAM').getRecordTypeId();
        acc1.name = 'test8523434';
        acc1.CSS_DealerCode__c = '45634';
        acc1.IAM_Service_Provider_Code__c = '122234';
        acc1.CMI_Region__c = 'US and Canada';
        acc1.Type = 'Customer';
        acc1.ParentId = acc.id;
        insert acc1;
        
        account acc2=new account();
        acc2.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('IAM').getRecordTypeId();
        acc2.name = 'test8232521234';
        acc2.CSS_DealerCode__c = '45634';
        acc2.IAM_Service_Provider_Code__c = '122235';
        acc2.CMI_Region__c = 'US and Canada';
        acc2.Type = 'Customer';
        acc2.ParentId = acc1.id;
        insert acc2;
        
        account acc3=new account();
        acc3.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('IAM').getRecordTypeId();
        acc3.name = 'test85234342';
        acc3.CSS_DealerCode__c = '45634';
        acc3.IAM_Service_Provider_Code__c = '122246';
        acc3.CMI_Region__c = 'US and Canada';
        acc3.Type = 'Customer';
        acc3.ParentId = acc2.id;
        insert acc3;
        
        account acc4=new account();
        acc4.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('IAM').getRecordTypeId();
        acc4.name = 'test85234343';
        acc4.CSS_DealerCode__c = '45634';
        acc4.IAM_Service_Provider_Code__c = '122237';
        acc4.CMI_Region__c = 'US and Canada';
        acc4.Type = 'Customer';
        acc4.ParentId = acc3.id;
        insert acc4;
        
        account acc5=new account();
        acc5.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('IAM').getRecordTypeId();
        acc5.name = 'test85234344';
        acc5.CSS_DealerCode__c = '45634';
        acc5.IAM_Service_Provider_Code__c = '122238';
        acc5.CMI_Region__c = 'US and Canada';
        acc5.Type = 'Customer';
        acc5.ParentId = acc4.id;
        insert acc5;
        
        account acc6=new account();
        acc6.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('IAM').getRecordTypeId();
        acc6.name = 'test85234344';
        acc6.CSS_DealerCode__c = '45634';
        acc6.IAM_Service_Provider_Code__c = '122239';
        acc6.CMI_Region__c = 'US and Canada';
        acc6.Type = 'Customer';
        acc6.ParentId = acc5.id;
        insert acc6;
        
        account acc7=new account();
        acc7.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('IAM').getRecordTypeId();
        acc7.name = 'test85234345';
        acc7.CSS_DealerCode__c = '45634';
        acc7.IAM_Service_Provider_Code__c = '122230';
        acc7.CMI_Region__c = 'US and Canada';
        acc7.Type = 'Customer';
        acc7.ParentId = acc6.id;
        insert acc7;
        
        account acc8=new account();
        acc8.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('IAM').getRecordTypeId();
        acc8.name = 'test85234346';
        acc8.CSS_DealerCode__c = '45634';
        acc8.IAM_Service_Provider_Code__c = '1222321';
        acc8.CMI_Region__c = 'US and Canada';
        acc8.Type = 'Customer';
        acc8.ParentId = acc7.id;
        insert acc8;
        
        List<account> accList = new List<account>();
        accList.add(acc8);
        accList.add(acc7);
        accList.add(acc6);
        accList.add(acc5);
        accList.add(acc4);
        accList.add(acc3);
        accList.add(acc2);
        accList.add(acc1);
        accList.add(acc);
       
        
        App_Mapping__c app=new App_Mapping__c();
        app.name='Online Login';
        app.Back_page__c='https://login.salesforce.com/';
        app.Login_Url__c='https://www.facebook.com/';
        app.IAM_App_Protected_By__c = 'SM';
        app.IAM_Default_Role__c = 'OSM Fleet Admin';
        insert app;        
        
  
        
        List < SelectOption > accountRoles = new List < SelectOption > ();
        accountRoles.add(new SelectOption('Test1', 'Test1'));
        accountRoles.add(new SelectOption('Test2', 'Test2'));
        
        List<String> setAppRoles = new List<String> ();
        setAppRoles.add('test1');
        setAppRoles.add('test2');
    
        IAM_SiteAdmin_Controller idm = new IAM_SiteAdmin_Controller();
        
        idm.regionIs = 'ALL';
        idm.accountType ='ALL';
        idm.accountSelectedApp = 'Marketplace';
        idm.newCon.FirstName='test856Update';
        idm.newCon.LastName='test123Con';
        idm.newCon.phone='74158266666';
        idm.newCon.Email='test123432Update@ggg.com';
        idm.newCon.CMI_Contact_Type__c = 'Primary';
        idm.newCon.AccountId = acc.id;
        idm.newCon.recordtypeid = Schema.SObjectType.contact.getRecordTypeInfosByName().get('IAM').getRecordTypeId();
        idm.unlockUser();
        idm.getRegion();
        
        Test.startTest();
        idm.lstAccounts = accList;
        idm.getChildsAccounts();
        
        idm.getAccType();
        idm.regionIs = 'US and Canada';
        idm.getAccType();
        idm.donothing();
        Test.stopTest();
       
    }
   
   
   
}