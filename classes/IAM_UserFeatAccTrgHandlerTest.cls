@isTest
public class IAM_UserFeatAccTrgHandlerTest{


 @testSetup
    static void BuildData(){
    
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
    
insert acc1;
List<contact> cons=new List<contact>();
Contact c=new Contact();
c.RecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('IAM').getRecordTypeId();
c.FirstName = 'myfirstn';
c.LastName ='mylastn';
c.Email = 'myemail2@abc.com';
c.Username__c = 'myuserid2@abc.com';
c.AccountId = acc1.ID;
c.IAM_from_Registration__c=true;
c.IAM_Contact_Status__c = 'Active';
c.CMI_Contact_Type__c = 'Primary';
   
Contact ct=new Contact();
ct.RecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('IAM').getRecordTypeId();
ct.FirstName = 'myfirssstn';
ct.LastName ='mylassstn';
ct.Email = 'myemails2@abct.com';
ct.Username__c = 'myuserissd2@abct.com';
ct.AccountId = acc1.ID;
ct.IAM_from_Registration__c=true;
ct.IAM_Contact_Status__c = 'Active';
ct.CMI_Contact_Type__c = 'Primary'; 

cons.add(c);
cons.add(ct);
insert cons; 

List<IAM_Application__c> app=new List<IAM_Application__c>();
IAM_Application__c app1=new IAM_Application__c();
app1.RecordTypeId = Schema.SObjectType.IAM_Application__c.getRecordTypeInfosByName().get('CUMPAS 2.0').getRecordTypeId(); 
app1.IAM_Application_Name__c='CUMPAS 2.0';
app1.IAM_Role__c='Dealer User;Dealer Admin';
app1.IAM_Cumpas_Modularity__c='View Credit';
app1.IAM_Subscription_Count__c=99;
app1.IAM_Account_Name__c=acc1.Id;

IAM_Application__c app2=new IAM_Application__c();
app2.RecordTypeId = Schema.SObjectType.IAM_Application__c.getRecordTypeInfosByName().get('EDS').getRecordTypeId(); 
app2.IAM_Application_Name__c='EDS';
app2.IAM_Role__c='Technician;Workgroup Administrator';
app2.IAM_Subscription_Count__c=99;
app2.IAM_Account_Name__c=acc1.Id;
app2.IAM_Subscription_Name__c='QSOL cpg';
        
IAM_Application__c app3=new IAM_Application__c();
app3.RecordTypeId = Schema.SObjectType.IAM_Application__c.getRecordTypeInfosByName().get('EDS').getRecordTypeId(); 
app3.IAM_Application_Name__c='Cummins Service Training';
app3.IAM_Role__c='Service Training User';
app3.IAM_Subscription_Count__c=99;
app3.IAM_Account_Name__c=acc1.Id;
app3.IAM_Subscription_Name__c='QSOL cpg';

app.add(app1);
app.add(app2);
app.add(app3);
//app.IAM_Subscription_Start_Date__c
//app.IAM_Subscription_End_Date__c
insert app;


List<IAM_Contact_Provisioning__c> conPLst=new List<IAM_Contact_Provisioning__c>();
IAM_Contact_Provisioning__c conP2=new IAM_Contact_Provisioning__c();
conP2.RecordTypeId = Schema.SObjectType.IAM_Contact_Provisioning__c.getRecordTypeInfosByName().get('CUMPAS 2.0').getRecordTypeId(); 
conP2.IAM_Application_Name__c='CUMPAS 2.0';
conP2.IAM_Role__c='Dealer User';
conP2.IAM_Cumpas_Modularity__c='View Credit';
conP2.IAM_Account_Application__c=app1.Id;
conP2.IAM_Contact__c=c.Id;
conP2.IAM_Status__c ='Active';

IAM_Contact_Provisioning__c conP1=new IAM_Contact_Provisioning__c();
conP1.RecordTypeId = Schema.SObjectType.IAM_Contact_Provisioning__c.getRecordTypeInfosByName().get('QuickServe Online').getRecordTypeId(); 
conP1.IAM_Application_Name__c='QuickServe Online';
conP1.IAM_Role__c='QSOL Dealer';
conP1.IAM_Qsolexpiration__c='testExp';
conP1.IAM_Account_Application__c=app1.Id;
conP1.IAM_Subscription_Name__c='QSOL cpg';
conP1.IAM_Contact__c=c.Id;
conP1.IAM_Status__c ='Active';

IAM_Contact_Provisioning__c conP=new IAM_Contact_Provisioning__c();
conP.RecordTypeId = Schema.SObjectType.IAM_Contact_Provisioning__c.getRecordTypeInfosByName().get('EDS').getRecordTypeId(); 
conP.IAM_Application_Name__c='EDS';
conP.IAM_Role__c='Technician;Workgroup Administrator';
conP.IAM_Contact__c=c.Id;
conP.IAM_Account_Application__c=app2.Id;

IAM_Contact_Provisioning__c conP3=new IAM_Contact_Provisioning__c();
conP3.RecordTypeId = Schema.SObjectType.IAM_Contact_Provisioning__c.getRecordTypeInfosByName().get('EDS').getRecordTypeId(); 
conP3.IAM_Application_Name__c='EDS';
conP3.IAM_Role__c='Technician;Workgroup Administrator';
conP3.IAM_Contact__c=ct.Id;
conP3.IAM_Account_Application__c=app2.Id;
IAM_Contact_Provisioning__c conP6=new IAM_Contact_Provisioning__c();
conP6.RecordTypeId = Schema.SObjectType.IAM_Contact_Provisioning__c.getRecordTypeInfosByName().get('Archer').getRecordTypeId(); 
conP6.IAM_Application_Name__c='Archer';
conP6.IAM_Role__c='Technician;Workgroup Administrator';
conP6.IAM_Contact__c=ct.Id;

IAM_Contact_Provisioning__c conP11=new IAM_Contact_Provisioning__c();
conP11.RecordTypeId = Schema.SObjectType.IAM_Contact_Provisioning__c.getRecordTypeInfosByName().get('QuickServe Online').getRecordTypeId(); 
conP11.IAM_Application_Name__c='QuickServe Online';
conP11.IAM_Role__c='QSOL Dealer';
conP11.IAM_Qsolexpiration__c='testExp';
conP11.IAM_Account_Application__c=app1.Id;
conP11.IAM_Subscription_Name__c='QSOL cpg';
conP11.IAM_Contact__c=ct.Id;
conP11.IAM_Status__c ='Active';
        
IAM_Contact_Provisioning__c coo=new IAM_Contact_Provisioning__c();
coo.RecordTypeId = Schema.SObjectType.IAM_Contact_Provisioning__c.getRecordTypeInfosByName().get('Cummins Service Training').getRecordTypeId(); 
coo.IAM_Application_Name__c='Cummins Service Training';
coo.IAM_Role__c='Service Training User';
coo.IAM_Contact__c=c.Id;
coo.IAM_Status__c ='Active';
coo.IAM_Account_Application__c=app3.Id;
coo.IAM_Promotion__c='12345';

IAM_Contact_Provisioning__c co=new IAM_Contact_Provisioning__c();
co.RecordTypeId = Schema.SObjectType.IAM_Contact_Provisioning__c.getRecordTypeInfosByName().get('Cummins Service Training').getRecordTypeId(); 
co.IAM_Application_Name__c='Cummins Service Training';
co.IAM_Role__c='Service Training User';
co.IAM_Contact__c=ct.Id;
co.IAM_Status__c ='Active';
co.IAM_Account_Application__c=app3.Id;
co.IAM_Promotion__c='12345';

IAM_Contact_Provisioning__c co1=new IAM_Contact_Provisioning__c();
co1.RecordTypeId = Schema.SObjectType.IAM_Contact_Provisioning__c.getRecordTypeInfosByName().get('Guidanz Mobile').getRecordTypeId(); 
co1.IAM_Application_Name__c='Guidanz Mobile';
co1.IAM_Role__c='Guidanz Mobile Campaign Employee';
co1.IAM_Guidanz_Mobile_Roles__c='Guidanz Mobile Campaign Employee';
co1.IAM_Contact__c=c.Id;
co1.IAM_Status__c ='Active';
co1.IAM_swregExpire__c='SRV0-02/14/2019';
co1.IAM_Account_Application__c=app3.Id;

try{
insert conP;
}catch(Exception e) {
System.assert(String.isNotBlank(e.getMessage()));}
try{
insert co;
}catch(Exception e) {
System.assert(String.isNotBlank(e.getMessage()));}

conPLst.add(conP1);
conPLst.add(conP11);
conPLst.add(conP2);
conPLst.add(coo);
conPLst.add(conP3);
conPLst.add(co1);

insert conPLst;

CSS_Integration_Details__c css_intg = new CSS_Integration_Details__c();
        css_intg.Name = 'IAM_LDAP_oAuth';
        css_intg.ApplicationName__c = 'IAM_LDAP_oAuth';
        css_intg.IsActive__c = true;
        css_intg.End_Point__c = 'https://services-dev-oauth.cummins.com/api/oauth/token/ldaputil';
        css_intg.Key__c = 'thAQWe/AIgUevs8IGTdk4Ddx50z3F9xiqm2Hl/QMu/MuVcRJFcWzFgYxxXvpN2LZEs43hkxTJ3t67B0nx7a1qg==';
        css_intg.Username__c = 'Z7xm9X6ImVl6ND7zTJ2j/jScb740y2NP/TOoSV9vC+U=';
        css_intg.Passcode__c = 'Il3eUr1gk32ejCbujtRoFDgyeVhp+MdwlVe5n/L2Tlk3uQejsj9shK0YOC5Dy/k5HFxa4Ac6EexF+dRmHCEl8Q==';
        css_intg.AuthEnv__c = 'OAGoAuth';
        css_intg.Logging__c = 'LDAPUtil';
        css_intg.Method_Type__c = 'POST';
        css_intg.Timeout__c = 120000;
        insert css_intg;
        

//conPLst.add(conP2);
//update conPLst;
    }
   
    @Istest
    static void test1()
    {    
    List<IAM_Contact_Provisioning__c> cc=new list<IAM_Contact_Provisioning__c>();  
  List<IAM_Contact_Provisioning__c> c2=[Select  id, Iam_role__c,IAM_Status__c from IAM_Contact_Provisioning__c where IAM_Application_Name__c ='EDS'];
  c2[0].IAM_Status__c ='Active';
  c2[0].IAM_Role__c='Workgroup Administrator;Distributor DFSE';
  //c2[1].IAM_Status__c ='Active';
  //c2[1].IAM_Role__c='Distributor DFSE';
  
  List<IAM_Contact_Provisioning__c> c3=[Select  id, Iam_role__c,IAM_Status__c from IAM_Contact_Provisioning__c where IAM_Application_Name__c='QuickServe Online'];
  c3[0].IAM_Qsolexpiration__c='testup';
  
  
 cc.addall(c2);
  //cc.add(c3[0]);
  //cc.add(c4);
  update cc;
    }
    
    @Istest
    static void test2()
    {   
    List<IAM_Contact_Provisioning__c> cc=new list<IAM_Contact_Provisioning__c>();    
  IAM_Contact_Provisioning__c c3=[Select  id, Iam_role__c,IAM_Status__c from IAM_Contact_Provisioning__c where IAM_Application_Name__c ='Cummins Service Training' LIMIT 1];
  c3.IAM_Status__c ='Inactive';
  
  IAM_Contact_Provisioning__c c4=[Select  id, Iam_role__c,IAM_Status__c from IAM_Contact_Provisioning__c where IAM_Application_Name__c='Guidanz Mobile' LIMIT 1];
  c4.IAM_swregExpire__c='SRV0-02/14/2020';
 c4.IAM_Status__c ='Active';
 cc.add(c3);
 cc.add(c4);
  update cc;
  
 /* User u=[select id from user where profile.name='IAM_Admin_User' and Isactive=true limit 1];
  system.runas(u){
          
    Account acc1=new Account(); 
    acc1.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('IAM').getRecordTypeId();
    acc1.Name='Account12';
    acc1.Type='Dealer Account';
    //acc1.ParentId=accP.Id;
    acc1.BillingStreet='1260 N MARR ROAD';
    acc1.BillingCity='COLUMBUS';
    acc1.BillingState='Indiana';
    acc1.BillingCountry='United States';
    acc1.BillingPostalCode='47201';
    
insert acc1;
List<contact> cons=new List<contact>();
Contact c=new Contact();
c.RecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('IAM').getRecordTypeId();
c.FirstName = 'myfirstn';
c.LastName ='mylastn';
c.Email = 'myggemail2@abc.com';
c.IAM_Cummins_login_ID__c = 'myusvverid2@abc.com';
c.AccountId = acc1.ID;
c.IAM_from_Registration__c=true;
c.IAM_Contact_Status__c = 'Active';
c.CMI_Contact_Type__c = 'Primary';
  insert c;
  List<IAM_Contact_Provisioning__c> conPLst=new List<IAM_Contact_Provisioning__c>();
IAM_Contact_Provisioning__c conP2=new IAM_Contact_Provisioning__c();
conP2.RecordTypeId = Schema.SObjectType.IAM_Contact_Provisioning__c.getRecordTypeInfosByName().get('CUMPAS 2.0').getRecordTypeId(); 
conP2.IAM_Application_Name__c='CUMPAS 2.0';
conP2.IAM_Role__c='Dealer User';
conP2.IAM_Cumpas_Modularity__c='View Credit';
conP2.IAM_Contact__c=c.Id;
conP2.IAM_Status__c ='Active';
conPLst.add(conP2);
insert conPLst;
  IAM_UserFeatureAndAccessTriggerHandler.onBeforeInsertOrUpdate(conPLst);
  
  }*/
}

    
     @Istest
    static void test4()
    {
        Contact con=[select id , name from contact where FirstName = 'myfirstn' LIMIT 1];
        List<IAM_Contact_Provisioning__c> clst=[Select id,IAM_Application_Name__c,IAM_Username__c,IAM_End_Date__c, Iam_role__c,IAM_Status__c,IAM_Contact__c from IAM_Contact_Provisioning__c where IAM_Contact__c=:con.Id];
        Set<Id> sid = new Set<Id>();
        for(IAM_Contact_Provisioning__c cp:clst)
        {
            sid.add(cp.id);
        }
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        IAM_UserApp_Deactivation.deactivateCallOut(sid);
        IAM_UserApp_Deactivation.deactivationPayload(clst[0]);
        IAM_UserFeatureAndAccessTriggerHandler.contactAccessValidationForDistributor(clst,true);
    }
     @Istest
    static void test5()
    {
        Set<Id> sid = new Set<Id>();
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        IAM_UserApp_Deactivation.deactivateCallOut(sid);
    }
     @istest
    static void test55()
    {
                Contact con=[select id , name from contact where FirstName = 'myfirstn' LIMIT 1];
                con.IAM_From_Registration__c=false;
                update con;
        List<IAM_Contact_Provisioning__c> clst=[Select id,IAM_Application_Name__c,IAM_From_Registration__c,IAM_Username__c,IAM_End_Date__c, Iam_role__c,IAM_Status__c from IAM_Contact_Provisioning__c where IAM_Contact__c=:con.Id];
        system.debug('@@@@@@@@'+clst);       
       IAM_Application__c aa=[select id from IAM_Application__c where IAM_Application_Name__c='EDS'];
       IAM_Application__c bb=[select id from IAM_Application__c where IAM_Application_Name__c='EDS'];
        
IAM_Contact_Provisioning__c conP=new IAM_Contact_Provisioning__c();
conP.RecordTypeId = Schema.SObjectType.IAM_Contact_Provisioning__c.getRecordTypeInfosByName().get('EDS').getRecordTypeId(); 
conP.IAM_Application_Name__c='EDS';
conP.IAM_Role__c='Technician;Workgroup Administrator';
conP.IAM_Contact__c=con.Id;
conP.IAM_Subscription_Name__c='QSOL CPG';
conP.IAM_Account_Application__c=aa.Id;

IAM_Contact_Provisioning__c co=new IAM_Contact_Provisioning__c();
co.RecordTypeId = Schema.SObjectType.IAM_Contact_Provisioning__c.getRecordTypeInfosByName().get('Cummins Service Training').getRecordTypeId(); 
co.IAM_Application_Name__c='Cummins Service Training';
co.IAM_Role__c='Service Training User';
co.IAM_Contact__c=con.Id;
co.IAM_Status__c ='Active';
co.IAM_Account_Application__c=bb.Id;
co.IAM_Promotion__c='12345';
try{
insert conP;
}catch(Exception e) {
                System.assert(String.isNotBlank(e.getMessage()));
    }
try{
insert co;
}catch(Exception e) {
                System.assert(String.isNotBlank(e.getMessage()));
    }
    }
    
     static testmethod void test66()
    {
       Account acc = IAM_TestData.createAccount();
        Contact con = IAM_TestData.createContact(acc.Id);
        Contact loginUserCon = getContact();
        User u = IAM_TestData.createUser(loginUserCon, acc, Label.IAM_Profile_Admin_User);
        PermissionSet ps = [SELECT Id FROM PermissionSet WHERE Name = 'IAM_Cumpas_Business_Admin_Permission_Set_SF'];
       // IAM_Application__c appAccessObj = IAM_TestData.createAccountSubscription(acc.Id, 'CUMPAS 2.0', 'Dealer User');
        Test.startTest();        
        System.runAs(u) {
        try{
        insert new PermissionSetAssignment(AssigneeId = u.id, PermissionSetId = ps.Id);
                IAM_Application__c appAccessObj = createAccountSubscription(acc.Id, 'CUMPAS 2.0', 'Dealer User', 'Active');
                IAM_TestData.createUserSubscription(con.Id, appAccessObj.Id, 'CUMPAS 2.0', 'CUMPAS', Date.today(), 
                Date.today()+365, 'Active', '', '', '', 'Dealer User', '');
                 } catch(Exception e) {
                System.assert(String.isNotBlank(e.getMessage()));
            }
        }
    }
    
      public static IAM_Application__c createAccountSubscription(Id accId, String appName, String appRole, String Status) {
        IAM_Application__c obj = new IAM_Application__c();
        obj.IAM_Account_Name__c = accId;                
        obj.IAM_Subscription_Start_Date__c = Date.today();
        obj.IAM_Subscription_End_Date__c = Date.today() + 365;
        obj.IAM_Subscription_Count__c = 9999;
        obj.IAM_Application_Name__c = appName;
        obj.IAM_Role__c = appRole;
        if(appName == Label.IAM_Guidanz_Mobile_App_Name){
            System.debug('Printing Role Name for Guidanz mobile application');
            obj.IAM_Guidanz_Mobile_Roles__c = appRole;
            obj.IAM_swregExpire__c = 'IAM-2020';
        }
        if(appName == Label.IAM_AppName_QSOL){
            System.debug('Printing Role Name for Guidanz mobile application');
            obj.IAM_Qsolexpiration__c = 'IAM-2020';
        }
        if(appName == 'CUMPAS 2.0') {
            obj.IAM_Cumpas_Modularity__c = 'View Credit;Core Returns';
        }
        obj.IAM_Status__c = status;
        obj.IAM_Subscription_Name__c = appName;
        obj.RecordtypeId = Schema.SObjectType.IAM_Application__c.getRecordTypeInfosByName().get(appName).getRecordTypeId();
        System.debug('#### Account access obj '+obj);
        User u = [select id, Name, ProfileId, isActive  from User where Profile.Name = 'System Administrator' and isActive=true limit 1];
        System.runAs(u){
            insert obj;
        }
        return obj;
    } 
      public static Contact getContact() {
        Contact con = new contact();
        con.FirstName = 'LogInFname';
        con.LastName = 'LonInLname';
        con.Email = 'LogInFname@test.com';
        con.Username__c = 'LogInFname@test.com';
        con.phone = '1112223335';
        con.IAM_Contact_Status__c = 'Active';
        return con;
    }

}