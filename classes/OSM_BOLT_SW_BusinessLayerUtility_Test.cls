/************************************************
 History
 --------
 VERSION    AUTHOR          DATE            DETAILS
 1.0        Ashish          03/03/2021      Test Class Fixes
 2.0        Ashish          05/03/2021      Test Class Fixes
 3.0        Ashish          05/03/2021      Test Class Fixes
 4.0        Ashish          05/03/2021      Test Class Fixes
 5.0        Ashish          06/03/2021      Test Class Fixes
 6.0        Ashish          12/03/2021      Test Class Fixes
 7.0        Ashish          17/03/2021      Test Class Fixes
 8.0        Ashish          24/06/2021      Test Class Fixes
 9.0        Ashish          25/06/2021      Test Class Fixes
 */
@isTest
   Public class OSM_BOLT_SW_BusinessLayerUtility_Test{
   static testmethod void testBusinessLayerUtility(){
   List<Id> id1 = new List<Id>();
   Map<Id, Id> Mapid = new Map<Id,Id>();
   Test.starttest();
   string state = 'Order Placed';
   OSM_BOLT_SW_BusinessLayerUtility.getARInvoiceServices(id1, Mapid,state);
   OSM_BOLT_SW_BusinessLayerUtility.getJournalEntryServices(id1, Mapid,state);
   Test.stoptest();
   
   } 
   
   static testmethod void testBusinessLayerUtility1(){  
       
   List<Id> id1 = new List<Id>();
   List<Id>OSMId = new List<Id>();
   Account acc = new Account();
   acc.Name = 'testName';
   acc.AccountNumber = '5555555';
   acc.Vertex_Customer_Class_Code__c = '65941515';
   acc.Bolt_BC_Code__c = 'testingcode';
   acc.Bolt_Acc_Site_Reference__c='testingcodeqq';
   insert acc;
   
   ccrz__E_Order__c ord = new ccrz__E_Order__c();
   ord.ccrz__Account__c = acc.id;
   ord.ccrz__OrderDate__c= system.today();
   ord.ccrz__OrderNumber__c = 00006;
   insert ord;
   
   list<ccrz__E_Invoice__c>incList = new list<ccrz__E_Invoice__c>();
   Map<Id, Id> Mapid = new Map<Id,Id>();   
   
   ccrz__E_Invoice__c inc = new ccrz__E_Invoice__c();
  inc.ccrz__OriginalAmount__c=52.00;
  inc.ccrz__Terms__c='testing22222';
  inc.ccrz__CurrencyCode__c='USD';
  inc.ccrz__CCOrder__c=ord.id;
  incList.add(inc);
  insert incList;
 
   incList = new list<ccrz__E_Invoice__c>();
   incList = [Select Id from ccrz__E_Invoice__c];
   
   for(ccrz__E_Invoice__c obj : incList){
       id1.add(obj.Id);
   }
   
   system.assertEquals(1,incList.size());
     
   ccrz__E_TransactionPayment__c tran = new ccrz__E_TransactionPayment__c();
   tran.ccrz__InvoiceAppliedFor__c = id1[0];
   tran.ccrz__InvoiceAppliedTo__c = id1[0];
   tran.Bolt_AR_Call_Status__c = 'Pending';
   tran.Bolt_JE_Call_Status__c = 'Pending';
   insert tran;
   
   Mapid.put(id1[0],tran.Id);
   
   Test.starttest();
   string state = 'Order Placed';
   OSM_BOLT_SW_BusinessLayerUtility.getARInvoiceServices(id1, Mapid,state);
   OSM_BOLT_SW_BusinessLayerUtility.getJournalEntryServices(id1, Mapid,state);
   Test.stoptest();
   
   }       
      static testmethod void testBusinessLayerUtility2(){
       
   List<Id> id1 = new List<Id>();
   List<Id>OSMId = new List<Id>();
   
   Account acc = new Account();
   acc.Name = 'testName';
   acc.AccountNumber = '5555555';
   acc.Vertex_Customer_Class_Code__c = '65941515';
   acc.Bolt_BC_Code__c = 'testingcode';
   acc.Bolt_Acc_Site_Reference__c='testingcodeqq';
   insert acc;
   
   ccrz__E_Order__c ord = new ccrz__E_Order__c();
   ord.ccrz__Account__c = acc.id;
   ord.ccrz__OrderDate__c= system.today();
   ord.ccrz__OrderNumber__c = 00006;
   insert ord;
   
   list<ccrz__E_Invoice__c>incList = new list<ccrz__E_Invoice__c>();
   Map<Id, Id> Mapid = new Map<Id,Id>();   
   
   ccrz__E_Invoice__c inc = new ccrz__E_Invoice__c();
  inc.ccrz__OriginalAmount__c=52.00;
  inc.ccrz__Terms__c='testing22222';
  inc.ccrz__CurrencyCode__c='MZN';
  inc.ccrz__CCOrder__c=ord.id;
  incList.add(inc);
  insert incList;
 
   incList = new list<ccrz__E_Invoice__c>();
   incList = [Select Id from ccrz__E_Invoice__c];
   
   for(ccrz__E_Invoice__c obj : incList){
       id1.add(obj.Id);
   }
   
   system.assertEquals(1,incList.size());
   
   ccrz__E_TransactionPayment__c tran = new ccrz__E_TransactionPayment__c();
   tran.ccrz__InvoiceAppliedFor__c = id1[0];
   tran.ccrz__InvoiceAppliedTo__c = id1[0];
   tran.Bolt_AR_Call_Status__c = 'Pending';
   tran.Bolt_JE_Call_Status__c = 'Pending';
   insert tran;
   
   Mapid.put(id1[0],tran.Id);
   
   Test.starttest();
   string state = 'Order Placed';
   OSM_BOLT_SW_BusinessLayerUtility.getARInvoiceServices(id1, Mapid,state);
   OSM_BOLT_SW_BusinessLayerUtility.getJournalEntryServices(id1, Mapid,state);
   OSM_BOLT_SW_BusinessLayerHandler.setARInvoiceOutboundWrapper(id1,Mapid,state,null);
   Test.stoptest();
   
   }       
}