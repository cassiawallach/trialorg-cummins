@isTest
public class IAM_Contact_Trigger_HelperTest{
    
    @TestSetup
    static void BuildData(){

    Account accP=new Account();
    accP.Name='AccountP';
    accP.Type='Distributor Account';
    accP.BillingStreet='1260 N MARR ROAD';
    accP.BillingCity='COLUMBUS';
    accP.BillingState='Indiana';
    accP.BillingCountry='United States';
    accP.BillingPostalCode='47201';
    
    insert accP;
        
        
    Account acc1=new Account(); 
    acc1.Name='Account1';
    acc1.Type='Dealer Account';
    acc1.ParentId=accP.Id;
    acc1.BillingStreet='1260 N MARR ROAD';
    acc1.BillingCity='COLUMBUS';
    acc1.BillingState='Indiana';
    acc1.BillingCountry='United States';
    acc1.BillingPostalCode='47201';
    
insert acc1;

Account acc2=new Account(); 
    acc2.Name='Account1';
    acc2.Type='Dealer Account';
    acc2.ParentId=accP.Id;
    acc2.BillingStreet='1260 N MARR ROAD';
    acc2.BillingCity='COLUMBUS';
    acc2.BillingState='Indiana';
    acc2.BillingCountry='United States';
    acc2.BillingPostalCode='47201';
    
insert acc2;

List<Contact> lst=new List<Contact>(); 
Contact c=new Contact();
c.FirstName = 'myfirst';
c.LastName ='mylast';
c.Email = 'myemail@abc.com';
c.Username__c = 'myuserid@abc.com';
c.AccountId = acc1.ID;
c.IAM_from_Registration__c=true;
c.IAM_Contact_Status__c = 'Active';
c.CMI_Contact_Type__c = 'Primary';
c.Recordtypeid=Schema.SObjectType.Contact.getRecordTypeInfosByName().get('IAM').getRecordTypeId();

Contact c2=new Contact();
c2.FirstName = 'myfirst2';
c2.LastName ='mylast2';
c2.Email = 'myemail2@abc.com';
c2.Username__c = 'myuserid2@abc.com';
c2.AccountId = acc1.ID;
c2.IAM_from_Registration__c=false;
c2.IAM_Contact_Status__c = 'Pending';
c2.CMI_Contact_Type__c = 'Primary';
c2.Recordtypeid=Schema.SObjectType.Contact.getRecordTypeInfosByName().get('IAM').getRecordTypeId();    
//insert c; 
lst.add(c);
lst.add(c2);

Contact cc=new Contact();
cc.FirstName = 'myfirstreclaim';
cc.LastName ='mylastrecliam';
cc.Email = 'myemailrecliam@dd.com';
cc.Username__c = 'myuserid99@test.com';
cc.AccountId = acc1.ID;
cc.IAM_Contact_Status__c = 'Active';
cc.CMI_Contact_Type__c = 'Primary';
cc.IAM_Contact_source__c = 'SwReg';
cc.Recordtypeid=Schema.SObjectType.Contact.getRecordTypeInfosByName().get('IAM').getRecordTypeId();

//insert cc;
lst.add(cc);
insert lst;
 IAM_Contact_Trigger_Helper.onBeforeInsertandAfterInsert(lst,true,false);
 IAM_Contact_Trigger_Helper.onBeforeInsertandAfterInsert(lst,false,true);
 
 List<Contact> lstupdate=new List<Contact>();
c.IAM_from_Registration__c=false;
c.AccountId = acc2.ID;

//update lst; 

cc.LastName = 'lnametet';
update cc;  

c2.IAM_Contact_Status__c = 'Active';
//update c2;
update lst;

cc.IAM_Contact_Status__c='Rejected';
cc.Username__c='myuseridchanged@test.com';
update cc;

List<String> lstt= new List<String>();
lstt.add('myuseridchanged@test.com');
IAM_Contact_Trigger_Helper.changeUsernameOfRejectedContact(lstt);

}
    
    @isTest   
     static void Test1()
     {
     
     }
}