@isTest
public class IAM_SendEmailAlert_Test {
    
  @isTest
 //@testSetup
    static void BuildData(){
    //Static TestMethod void  InitData(){
    
      Account accP=new Account();
    accP.Name='AccountPp';
    accP.Type='Distributor Account';
    accP.BillingStreet='1260 N MARR ROAD';
    accP.BillingCity='COLUMBUS';
    accP.BillingState='Indiana';
    accP.BillingCountry='United States';
    accP.BillingPostalCode='47201';
    accP.CSS_Locale__c='en_US';
    accP.CSS_Language__c='en_US';
    accP.CSS_Timezone__c='America/New_York';
    accP.IAM_Service_Provider_Code__c = '123';
    accP.CSS_DistributorCode__c = '1234';
    accP.CSS_DBCode__c = '12345';
    accP.CSS_DealerCode__c = '456';
    accP.IAM_Movex_Customer_Code__c='3456';
    accP.IAM_Service_Provider_Code__c='ghgh';
    
    insert accP;
        
    Account accP2=new Account();
    accP2.Name='AccountPpp';
    accP2.Type='Distributor Account';
    accP2.BillingStreet='1260 N MARR ROAD';
    accP2.BillingCity='COLUMBUS';
    accP2.BillingState='Indiana';
    accP2.BillingCountry='United States';
    accP2.BillingPostalCode='47201';
    accP2.CSS_Locale__c='en_US';
    accP2.CSS_Language__c='en_US';
    accP2.CSS_Timezone__c='America/New_York';
    accP2.IAM_Service_Provider_Code__c = '1235';
    accP2.CSS_DistributorCode__c = '12345';
    accP2.CSS_DBCode__c = '123455';
    accP2.CSS_DealerCode__c = '4565';
    accP2.IAM_Movex_Customer_Code__c='34565';
    accP2.IAM_Service_Provider_Code__c='ghttgh';
    accP2.ParentId=accP.Id;
    
    insert accP2;    
        
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
    acc1.IAM_WWSPS_Regions__c='US and Canada';
    acc1.CSS_Locale__c='en_US';
    acc1.CSS_Language__c='en_US';
    acc1.CSS_Timezone__c='America/New_York';
    acc1.IAM_Service_Provider_Code__c = '1223';
    acc1.CSS_DistributorCode__c = '12324';
    acc1.CSS_DBCode__c = '122345';
    acc1.CSS_DealerCode__c = '4526';
    acc1.IAM_Movex_Customer_Code__c='34256';
    acc1.IAM_Service_Provider_Code__c='gqhgh';
   
    
insert acc1;
    List<Contact> conlst=new List<Contact>();
    
    Contact con= new Contact();
    con.Accountid=accP.id;
    con.FirstName='Testin';
    con.LastName='lastdname';
    con.email='oh611dsfftestuser@cummins.com';
    con.IAM_Contact_Status__c='Active';
    con.IAM_Cummins_Login_ID__c='Usernamffegivencummins@cummins.com';
    con.CMI_Contact_Type__c='Primary';
    con.IAM_Final_Approver__c='Y';
    con.IAM_Applications__c='qwerty';
    con.CMI_Contact_Type__c='Primary';
    con.IAM_is_Member_of__c='abc';
    con.IAM_Work_Group_Id__c='abcd';
    con.IAM_Product_Group_Access__c='xyz';
    con.phone='687687687';
    
   // conlst.add(con);
   
    Contact con3= new Contact();
    con3.Accountid=accP.id;
    con3.FirstName='Testingfhgfhfhhgfhgfhgfhgfhgf';
    con3.LastName='lastdnamehhkjhkjhkhkkhkjhkjhkjhkjh';
    con3.email='oh611dsfftestuser33@cummins.com';
    con3.IAM_Contact_Status__c='Active';
    con3.IAM_Cummins_Login_ID__c='Usernamffegivencummins33@cummins.com';
    con3.CMI_Contact_Type__c='Primary';
    con3.IAM_Final_Approver__c='Y';
    con3.IAM_Applications__c='qwerty';
    con3.CMI_Contact_Type__c='Primary';
    con3.IAM_is_Member_of__c='abc';
    con3.IAM_Work_Group_Id__c='abcd';
    con3.IAM_Product_Group_Access__c='xyz';
    con3.IAM_Internal__c=True;
    con3.phone='687687687';
    
    
    //test.startTest();
    //IAM_CreateUser.CreateUser(conlst);
    //Test.StopTest();
    
   Contact con2= new Contact();
    con2.Accountid=acc1.id;
    con2.FirstName='Testin2';
    con2.LastName='lastdname2';
    con2.email='oh611dsfftestuserhh@cummins.com';
    con2.IAM_Contact_Status__c='Pending';
    con2.IAM_Cummins_Login_ID__c='Usernamffegivencumminshh@cummins.com';
    con2.CMI_Contact_Type__c='Primary';
    conlst.add(con);
    conlst.add(con2);
    conlst.add(con3);
    
    insert conlst ;
    
    List<IAM_Application__c> app=new List<IAM_Application__c>();
IAM_Application__c app1=new IAM_Application__c();
app1.RecordTypeId = Schema.SObjectType.IAM_Application__c.getRecordTypeInfosByName().get('CUMPAS 2.0').getRecordTypeId(); 
app1.IAM_Application_Name__c='CUMPAS 2.0';
app1.IAM_Role__c='Dealer User;Dealer Admin';
app1.IAM_Cumpas_Modularity__c='View Credit';
app1.IAM_Subscription_Count__c=99;
app1.IAM_Account_Name__c=acc1.Id;

IAM_Application__c app5=new IAM_Application__c();
app5.RecordTypeId = Schema.SObjectType.IAM_Application__c.getRecordTypeInfosByName().get('CUMPAS 2.0').getRecordTypeId(); 
app5.IAM_Application_Name__c='CUMPAS 2.0';
app5.IAM_Role__c='Distributor Admin';
app5.IAM_Cumpas_Modularity__c='View Credit';
app5.IAM_Subscription_Count__c=0;
app5.IAM_Account_Name__c=accP.Id;
app5.IAM_Cumpas_Dist_CS_Rep__c=con3.Id;
app5.IAM_Cumpas_Distributor_Sales_Rep__c=con3.Id;

IAM_Application__c app2=new IAM_Application__c();
app2.RecordTypeId = Schema.SObjectType.IAM_Application__c.getRecordTypeInfosByName().get('EDS').getRecordTypeId(); 
app2.IAM_Application_Name__c='Guidanz';
app2.IAM_Role__c='Technician;Warranty';
app2.IAM_Subscription_Count__c=99;
app2.IAM_Account_Name__c=accP.Id;
        
IAM_Application__c app3=new IAM_Application__c();
app3.RecordTypeId = Schema.SObjectType.IAM_Application__c.getRecordTypeInfosByName().get('Cummins Service Training').getRecordTypeId(); 
app3.IAM_Application_Name__c='Cummins Service Training';
app3.IAM_Role__c='Service Training User';
app3.IAM_Subscription_Count__c=99;
app3.IAM_Account_Name__c=acc1.Id;

IAM_Application__c app4=new IAM_Application__c();
app4.RecordTypeId = Schema.SObjectType.IAM_Application__c.getRecordTypeInfosByName().get('Connected Solutions').getRecordTypeId(); 
app4.IAM_Application_Name__c='Connected Solutions';
app4.IAM_Role__c='Operator';
app4.IAM_Subscription_Count__c=99;
app4.IAM_Account_Name__c=acc1.Id;

IAM_Application__c app6=new IAM_Application__c();
app6.RecordTypeId = Schema.SObjectType.IAM_Application__c.getRecordTypeInfosByName().get('QuickServe Online').getRecordTypeId(); 
app6.IAM_Application_Name__c='QuickServe Online';
app6.IAM_Role__c='QSOL Dealer';
app6.IAM_Subscription_Count__c=99;
app6.IAM_Account_Name__c=acc1.Id;
app6.IAM_Qsolexpiration__c='exp123';
app6.IAM_Subscription_Name__c='QuickServe Online';
app6.IAM_Status__c='Active';

app.add(app1);
app.add(app2);
app.add(app3);
app.add(app4);
app.add(app5);
app.add(app6);
//app.IAM_Subscription_Start_Date__c
//app.IAM_Subscription_End_Date__c
insert app;

List<IAM_Contact_Provisioning__c> conPLst=new List<IAM_Contact_Provisioning__c>();

IAM_Contact_Provisioning__c co=new IAM_Contact_Provisioning__c();
co.RecordTypeId = Schema.SObjectType.IAM_Contact_Provisioning__c.getRecordTypeInfosByName().get('EDS').getRecordTypeId(); 
co.IAM_Application_Name__c='EDS';
co.IAM_Role__c='Technician';
co.IAM_Contact__c=con.Id;
co.IAM_Status__c ='Active';
co.IAM_Account_Application__c=app2.id;

IAM_Contact_Provisioning__c co1=new IAM_Contact_Provisioning__c();
co1.RecordTypeId = Schema.SObjectType.IAM_Contact_Provisioning__c.getRecordTypeInfosByName().get('QuickServe Online').getRecordTypeId(); 
co1.IAM_Application_Name__c='QuickServe Online';
co1.IAM_Role__c='QSOL Dealer';
co1.IAM_Contact__c=con.Id;
co1.IAM_Status__c ='Active';
co1.IAM_Qsolexpiration__c='exp123';
co1.IAM_Subscription_Name__c='QuickServe Online';
co1.IAM_Account_Application__c=app6.id;

IAM_Contact_Provisioning__c conP2=new IAM_Contact_Provisioning__c();
conP2.RecordTypeId = Schema.SObjectType.IAM_Contact_Provisioning__c.getRecordTypeInfosByName().get('CUMPAS 2.0').getRecordTypeId(); 
conP2.IAM_Application_Name__c='CUMPAS 2.0';
conP2.IAM_Role__c='Distributor Admin';
conP2.IAM_Cumpas_Modularity__c='View Credit';
conP2.IAM_Contact__c=con.Id;
conP2.IAM_Status__c ='Active';
conP2.IAM_Account_Application__c=app5.id;

conPLst.add(conP2);
conPLst.add(co);
conPLst.add(co1);


insert conPLst;
Test.startTest();
IAM_Sendemailalert.sendemail(con.Id,accP2.Id);
IAM_Sendemailalert.updateDistributorInfo(accP2.Id);
 
  Test.stopTest();
    } 
 

}