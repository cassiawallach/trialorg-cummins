@isTest
//Added for Mar-1653
//Added for Mar-1655
// updated by Sharad 6/3/2021
// updated by Sharad 6/8/2021
public class OSM_SW_InvoiceTriggerHandler_Test {
    public static final Id PROFILEID=TestingUtils.SYS_ADMIN_PROFILE_ID;
    Static TestMethod Void OnBeforeInsert_Test(){
        List<ccrz__E_Invoice__c> invoiceList=new List<ccrz__E_Invoice__c>();
        User usr=TestingUtils.createUser('12340',PROFILEID,true);
        List<ccrz__E_AccountGroup__c> accGrpId=TestingUtils.createAccountGroup(1,'TetsAccountGroup','none',true);
        List<Account> accId=TestingUtils.createAccount(1,'testAccount',accGrpId[0].id,usr.id,true);
        List<Contact> con=TestingUtils.createContact(1,accId[0].id,usr.id,true);
        ccrz__E_Order__c order=TestingUtils.createOrder(con[0].id,'testOrder',true);  
        List<ccrz__E_Invoice__c> cc_Invoice=TestingUtils.createCCInvoices(1,order.id,con[0].id,'Pending','cart',true);
         cc_Invoice[0].ccrz__Status__c='Test';
         invoiceList.add(cc_Invoice[0]);
         
        update invoiceList;
      //  Update cc;
        //put CC Invoice into map
        Map<Id,ccrz__E_Invoice__c> cmap=new  Map<Id,ccrz__E_Invoice__c>();
        cmap.put(cc_Invoice[0].id,cc_Invoice[0]);
        Test.startTest();
        
          
        OSM_SW_InvoiceTriggerHandler it=new OSM_SW_InvoiceTriggerHandler();
        OSM_SW_InvoiceTriggerHandler.OnBeforeInsert(cmap);
        
        //OSM_SW_InvoiceTriggerHandler.OnAfterUpdate(cmap,cmap);
        //OSM_SW_InvoiceTriggerHandler.OnBeforeUpdate(cmap,cmap);
        OSM_SW_InvoiceTriggerHandler.OnAfterBulkSOQL();
         OSM_SW_InvoiceTriggerHandler.populateInvoiceOnTransectionPayment(cmap);
        Test.stopTest();
    }
     // OnAfterInsert
     Static TestMethod void OnAfterInsert_Test(){
        List<ccrz__E_Invoice__c> invoiceList=new List<ccrz__E_Invoice__c>();
        User usr=TestingUtils.createUser('12340',PROFILEID,true);
        List<ccrz__E_AccountGroup__c> accGrpId=TestingUtils.createAccountGroup(1,'TetsAccountGroup','none',true);
        List<Account> accId=TestingUtils.createAccount(1,'testAccount',accGrpId[0].id,usr.id,true);
        List<Contact> con=TestingUtils.createContact(1,accId[0].id,usr.id,true);
        ccrz__E_Order__c order=TestingUtils.createOrder(con[0].id,'testOrder',true); 
        ccrz__E_TransactionPayment__c transPayment= TestingUtils.createTransactionPayment(order.id,true);
         
        List<ccrz__E_Invoice__c> cc_Invoice=TestingUtils.createCCInvoices(1,order.id,con[0].id,'Paid','cart',true);
         cc_Invoice[0].Recurring_Invoice__c=true;
         cc_Invoice[0].ccrz__BillTo__c=accId[0].id;
         invoiceList.add(cc_Invoice[0]);
         update invoiceList;
      
        //put CC Invoice into map
        Map<Id,ccrz__E_Invoice__c> cmap=new  Map<Id,ccrz__E_Invoice__c>();
        cmap.put(invoiceList[0].id,invoiceList[0]);
        
        Test.StartTest();
        OSM_SW_InvoiceTriggerHandler.OnAfterInsert(cmap);
         OSM_SW_InvoiceTriggerHandler.populateInvoiceOnTransectionPayment(cmap);
        Test.StopTest();
       
     
     }
      // OnAfterUpdate
     Static TestMethod void OnAfterUpdateWithSubscription_Test(){
        List<ccrz__E_Invoice__c> invoiceList=new List<ccrz__E_Invoice__c>();
        User usr=TestingUtils.createUser('12340',PROFILEID,true);
        List<ccrz__E_AccountGroup__c> accGrpId=TestingUtils.createAccountGroup(1,'TetsAccountGroup','none',true);
        List<Account> accId=TestingUtils.createAccount(1,'testAccount',accGrpId[0].id,usr.id,true);
        List<Contact> con=TestingUtils.createContact(1,accId[0].id,usr.id,true);
        ccrz__E_Order__c order=TestingUtils.createOrder(con[0].id,'testOrder',true); 
        //ccrz__E_TransactionPayment__c transPayment= TestingUtils.createTransactionPayment(order.id,true);
          
        List<ccrz__E_Invoice__c> cc_Invoice=TestingUtils.createCCInvoices(1,order.id,con[0].id,'Open','cart',true);
         cc_Invoice[0].Recurring_Invoice__c=true;
         cc_Invoice[0].ccrz__BillTo__c=accId[0].id;
         cc_Invoice[0].Payment_Method__c='cc';
         cc_Invoice[0].ccrz__Status__c='Paid';
         invoiceList.add(cc_Invoice[0]);
         update invoiceList;
         
         
        //put CC Invoice into map
        Map<Id,ccrz__E_Invoice__c> cmap=new  Map<Id,ccrz__E_Invoice__c>();
        cmap.put(invoiceList[0].id,invoiceList[0]);
        List<Id> invoiceIds=new List<Id>();
        invoiceIds.add(invoiceList[0].id);
        ccrz__E_Subscription__c subscription=new ccrz__E_Subscription__c();
        subscription.ccrz__Account__c=accId[0].id;
        subscription.ccrz__CCOrder__c=order.id;
        subscription.ccrz__Sequence__c=12;
        subscription.ccrz__Storefront__c='SoftwareStore';
        subscription.ccrz__SubscriptionStartDate__c=Date.Today();
        subscription.ccrz__SubscriptionStatus__c='Active';
        subscription.ccrz__InstallmentCountRemaining__c=0;
        insert subscription;
        ccrz__E_InvoiceItem__c invoiceItem=new ccrz__E_InvoiceItem__c();
        invoiceItem.ccrz__Invoice__c=invoiceList[0].id;
        invoiceItem.CC_Subscription__c=subscription.id;
        invoiceItem.ccrz__Type__c='Item';
      //  invoiceItem.CC_Subscription__r.ccrz__InstallmentCountRemaining__c=1000;
       // invoiceItem.CC_Subscription__r.Last_Installment_Paid__c=true;
        insert invoiceItem;
        Test.StartTest();
        OSM_SW_InvoiceTriggerHandler.OnAfterUpdate(cmap,cmap);
        OSM_SW_InvoiceTriggerHandler.updateInfoOnInvoiceAndSubscription(invoiceIds);
         OSM_SW_InvoiceTriggerHandler.populateInvoiceOnTransectionPayment(cmap);
         //subscription.ccrz__InstallmentCountRemaining__c=10;
         //update subscription;
         //OSM_SW_InvoiceTriggerHandler.updateInfoOnInvoiceAndSubscription(invoiceIds);
        Test.StopTest();
       
     
     }
      // OnAfterUpdate
     Static TestMethod void OnAfterUpdateWithNullSubscription_Test(){
        List<ccrz__E_Invoice__c> invoiceList=new List<ccrz__E_Invoice__c>();
        User usr=TestingUtils.createUser('12340',PROFILEID,true);
        List<ccrz__E_AccountGroup__c> accGrpId=TestingUtils.createAccountGroup(1,'TetsAccountGroup','none',true);
        List<Account> accId=TestingUtils.createAccount(1,'testAccount',accGrpId[0].id,usr.id,true);
        List<Contact> con=TestingUtils.createContact(1,accId[0].id,usr.id,true);
        ccrz__E_Order__c order=TestingUtils.createOrder(con[0].id,'testOrder',true); 
        //ccrz__E_TransactionPayment__c transPayment= TestingUtils.createTransactionPayment(order.id,true);
          
        List<ccrz__E_Invoice__c> cc_Invoice=TestingUtils.createCCInvoices(1,order.id,con[0].id,'Open','cart',true);
         cc_Invoice[0].Recurring_Invoice__c=true;
         cc_Invoice[0].ccrz__BillTo__c=accId[0].id;
         cc_Invoice[0].Payment_Method__c='cc';
         cc_Invoice[0].ccrz__Status__c='Paid';
         invoiceList.add(cc_Invoice[0]);
         update invoiceList;
         
         
        //put CC Invoice into map
        Map<Id,ccrz__E_Invoice__c> cmap=new  Map<Id,ccrz__E_Invoice__c>();
        cmap.put(invoiceList[0].id,invoiceList[0]);
        List<Id> invoiceIds=new List<Id>();
        invoiceIds.add(invoiceList[0].id);
        /*ccrz__E_Subscription__c subscription=new ccrz__E_Subscription__c();
        subscription.ccrz__Account__c=accId[0].id;
        subscription.ccrz__CCOrder__c=order.id;
        subscription.ccrz__Sequence__c=12;
        subscription.ccrz__Storefront__c='SoftwareStore';
        subscription.ccrz__SubscriptionStartDate__c=Date.Today();
        subscription.ccrz__SubscriptionStatus__c='Active';
        subscription.ccrz__InstallmentCountRemaining__c=0;
        insert subscription;*/
        ccrz__E_InvoiceItem__c invoiceItem=new ccrz__E_InvoiceItem__c();
        invoiceItem.ccrz__Invoice__c=invoiceList[0].id;
       // invoiceItem.CC_Subscription__c=subscription.id;
        invoiceItem.ccrz__Type__c='Item';
      //  invoiceItem.CC_Subscription__r.ccrz__InstallmentCountRemaining__c=1000;
       // invoiceItem.CC_Subscription__r.Last_Installment_Paid__c=true;
        insert invoiceItem;
        Test.StartTest();
        OSM_SW_InvoiceTriggerHandler.OnAfterUpdate(cmap,cmap);
        OSM_SW_InvoiceTriggerHandler.updateInfoOnInvoiceAndSubscription(invoiceIds);
         OSM_SW_InvoiceTriggerHandler.populateInvoiceOnTransectionPayment(cmap);
        Test.StopTest();
       
     
     }

    // OnBeforeUpdate
     Static TestMethod void OnBeforeUpdate_Test(){
        List<ccrz__E_Invoice__c> invoiceList=new List<ccrz__E_Invoice__c>();
        User usr=TestingUtils.createUser('12340',PROFILEID,true);
        List<ccrz__E_AccountGroup__c> accGrpId=TestingUtils.createAccountGroup(1,'TetsAccountGroup','none',true);
        List<Account> accId=TestingUtils.createAccount(1,'testAccount',accGrpId[0].id,usr.id,true);
        List<Contact> con=TestingUtils.createContact(1,accId[0].id,usr.id,true);
        ccrz__E_Order__c order=TestingUtils.createOrder(con[0].id,'testOrder',true); 
        ccrz__E_TransactionPayment__c transPayment= TestingUtils.createTransactionPayment(order.id,true);
         
        List<ccrz__E_Invoice__c> cc_Invoice=TestingUtils.createCCInvoices(1,order.id,con[0].id,'Open','cart',true);
         cc_Invoice[0].Recurring_Invoice__c=true;
         cc_Invoice[0].ccrz__BillTo__c=accId[0].id;
         cc_Invoice[0].Payment_Method__c='cc';
          cc_Invoice[0].ccrz__Status__c='Closed';

         invoiceList.add(cc_Invoice[0]);
         update invoiceList;
      
        //put CC Invoice into map
        Map<Id,ccrz__E_Invoice__c> cmap=new  Map<Id,ccrz__E_Invoice__c>();
        cmap.put(invoiceList[0].id,invoiceList[0]);
        
        Test.StartTest();
        OSM_SW_InvoiceTriggerHandler.OnBeforeUpdate(cmap,cmap);
        OSM_SW_InvoiceTriggerHandler.populateInvoiceOnTransectionPayment(cmap);
        Test.StopTest();
       
     
     }
     }