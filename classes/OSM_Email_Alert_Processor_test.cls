@istest
public class OSM_Email_Alert_Processor_test{

static  testmethod void  EmailAlertTest(){
//create test account
list<account> tstAcc = new list<Account>();
Account acc = new Account();
acc.name = 'OSM_Test_Acc';
acc.OSM_Preferred_Payment_Method__c = 'PO';
tstAcc.add(acc);
insert tstAcc;
//create a contact with above acc id

contact con = new contact();
//con.name = 'testcon1';
con.lastname = 'testLn';
con.Email = 'test@gmail.com';
con.IAM_Contact_Status__c = 'Active';
//con.IDM_Contact_Status__c = 'Active';
con.AccountId = tstAcc[0].id;
Insert con;

// create invoice linking above account

list<ccrz__E_Invoice__c> newInv = new list<ccrz__E_Invoice__c>();
ccrz__E_Invoice__c inv = new ccrz__E_Invoice__c();
inv.ccrz__BillTo__c =con.AccountId;
inv.Recurring_Invoice__c = true;
newInv.add(inv);
Insert newInv;

        
     test.startTest();
     
     OSM_Email_Alert_Processor newEmailObj = new OSM_Email_Alert_Processor();
     //Map<Id,ccrz__E_Invoice__c> invoiceMapDb = new Map<Id,ccrz__E_Invoice__c>();
     
     Map<String,String> strmap = new Map<String,String>();
     strmap.put(String.valueof(userinfo.getUserEmail()),String.valueof(userinfo.getUserId()));
     Map<String,Map<String,String>> invoiceIdVsEmailMap = new Map<String,Map<String,String>>();
     invoiceIdVsEmailMap.put(string.valueof(con.id),strmap);
    // invoiceMapDb.put(newInv[0].id,newInv[0]);
     //OSM_Email_Alert_Processor.sendRecurringInvoiceEmails(invoiceIdVsEmailMap);
     
     test.stoptest();
}

static  testmethod void  EmailAlertTest1(){
//create test account
list<account> tstAcc = new list<Account>();
Account acc = new Account();
acc.name = 'OSM_Test_Acc';
acc.OSM_Preferred_Payment_Method__c = '';
tstAcc.add(acc);
insert tstAcc;
//create a contact with above acc id

contact con = new contact();
//con.name = 'testcon1';
con.lastname = 'testLn';
con.Email = 'test@gmail.com';
con.IAM_Contact_Status__c = 'Active';
con.AccountId = tstAcc[0].id;
Insert con;

// create invoice linking above account

//list<ccrz__E_Invoice__c> newInv = new list<ccrz__E_Invoice__c>();
ccrz__E_Invoice__c inv = new ccrz__E_Invoice__c();
inv.ccrz__BillTo__c =con.AccountId;
inv.Recurring_Invoice__c = true;
inv.ownerid = userinfo.getuserid();

Insert inv;


ccrz__E_Invoice__c inv2 = new ccrz__E_Invoice__c();
inv2.ccrz__BillTo__c =con.AccountId;
inv2.Recurring_Invoice__c = true;

Insert inv2;
        
     test.startTest();
     
     OSM_Email_Alert_Processor newEmailObj = new OSM_Email_Alert_Processor();
     //Map<Id,ccrz__E_Invoice__c> invoiceMapDb = new Map<Id,ccrz__E_Invoice__c>();
     Map<Id,ccrz__E_Invoice__c> invoiceMapDb = new Map<Id,ccrz__E_Invoice__c>();
     invoiceMapDb.put(inv.id,inv);
     List<String> abc = new List<String>();
    abc.add(con.Email);
     Map<Id,List<String>> accIdVsContactMap = new Map<Id,List<String>>();
     accIdVsContactMap.put(con.AccountId,abc);
     
     //Map<Id,String> accIdVsPaymentMethod = new Map<Id,String> ();
     //accIdVsPaymentMethod.put(con.AccountId,string.valueof(acc.OSM_Preferred_Payment_Method__c));
     //Map<Id,List<String>> accIdVsContactMap = new Map<Id,List<String>>();
     Map<String,String> strmap = new Map<String,String>();
     Set<String> ownerIds = new Set<String>();
     ownerIds.add(inv.ownerid);
     OSM_SW_Batch_Subscription_Helper.SingleInvoiceForAccountWrapper singleInvWrap;
     //singleInvWrap.orderOwnerIds = ownerIds;
     Map<String,Set<String>> invoiceIdVsOwnerMap = new Map<String,Set<String>>();
     invoiceIdVsOwnerMap.put(inv.id,ownerIds);
     strmap.put(String.valueof(userinfo.getUserEmail()),String.valueof(userinfo.getUserId()));
     Map<String,Map<String,String>> invoiceIdVsEmailMap = new Map<String,Map<String,String>>();
     invoiceIdVsEmailMap.put(string.valueof(inv.id),strmap);
    // invoiceMapDb.put(newInv[0].id,newInv[0]);
     OSM_Email_Alert_Processor.sendRecurringInvoiceEmails(invoiceIdVsEmailMap);
     
     test.stoptest();
}


static  testmethod void  EmailAlertTest2(){
//create test account
list<account> tstAcc = new list<Account>();
Account acc = new Account();
acc.name = 'OSM_Test_Acc';
acc.OSM_Preferred_Payment_Method__c = 'cc';
tstAcc.add(acc);
insert tstAcc;
//create a contact with above acc id

contact con = new contact();
//con.name = 'testcon1';
con.lastname = 'testLn';
con.Email = 'test@gmail.com';
con.IAM_Contact_Status__c = 'Active';
con.AccountId = tstAcc[0].id;
Insert con;

// create invoice linking above account

//list<ccrz__E_Invoice__c> newInv = new list<ccrz__E_Invoice__c>();
ccrz__E_Invoice__c inv = new ccrz__E_Invoice__c();
inv.ccrz__BillTo__c =con.AccountId;
inv.Recurring_Invoice__c = true;
inv.ownerid = userinfo.getuserid();

Insert inv;


ccrz__E_Invoice__c inv2 = new ccrz__E_Invoice__c();
inv2.ccrz__BillTo__c =con.AccountId;
inv2.Recurring_Invoice__c = true;

Insert inv2;
  List<String> emailName = new List<String>{'OSM_Recurring_Invoice_PO','OSM_Recurring_Invoice_CC'};  
 list<EmailTemplate> email = [Select id,name from EmailTemplate where name =''];
    EmailTemplate em =  new EmailTemplate();
    //em.name ='OSM_Recurring_Invoice_PO'; 
    email.add(em);
     
     test.startTest();
     
     OSM_Email_Alert_Processor newEmailObj = new OSM_Email_Alert_Processor();
     //Map<Id,ccrz__E_Invoice__c> invoiceMapDb = new Map<Id,ccrz__E_Invoice__c>();
     Map<Id,ccrz__E_Invoice__c> invoiceMapDb = new Map<Id,ccrz__E_Invoice__c>();
     invoiceMapDb.put(inv.id,inv);
     List<String> abc = new List<String>();
    abc.add(con.Email);
     Map<Id,List<String>> accIdVsContactMap = new Map<Id,List<String>>();
     accIdVsContactMap.put(con.AccountId,abc);
     
     //Map<Id,String> accIdVsPaymentMethod = new Map<Id,String> ();
     //accIdVsPaymentMethod.put(con.AccountId,string.valueof(acc.OSM_Preferred_Payment_Method__c));
     //Map<Id,List<String>> accIdVsContactMap = new Map<Id,List<String>>();
     Map<String,String> strmap = new Map<String,String>();
     Set<String> ownerIds = new Set<String>();
     ownerIds.add(inv.ownerid);
     OSM_SW_Batch_Subscription_Helper.SingleInvoiceForAccountWrapper singleInvWrap;
     //singleInvWrap.orderOwnerIds = ownerIds;
     Map<String,Set<String>> invoiceIdVsOwnerMap = new Map<String,Set<String>>();
     invoiceIdVsOwnerMap.put(inv.id,ownerIds);
     strmap.put(String.valueof(userinfo.getUserEmail()),String.valueof(userinfo.getUserId()));
     Map<String,Map<String,String>> invoiceIdVsEmailMap = new Map<String,Map<String,String>>();
     invoiceIdVsEmailMap.put(string.valueof(inv.id),strmap);
    // invoiceMapDb.put(newInv[0].id,newInv[0]);
     OSM_Email_Alert_Processor.sendRecurringInvoiceEmails(invoiceIdVsEmailMap);
     
     test.stoptest();
}
}