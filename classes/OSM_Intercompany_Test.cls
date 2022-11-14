/******
Name:  OSM_Intercompany_Test
Copyright © 2018  Cummins
=============================================================
=============================================================
Purpose:                                                                                             
=============================================================
=============================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE              DETAIL                                
1.0 -   Neha Mehta       19/12/2018     INITIAL DEVELOPMENT 
*******/
@isTest
public class OSM_Intercompany_Test{
     // Create CC Invoices
    public static testMethod void createTestDataPositive(){
    //Create account
        Account testaccount = new Account();
        testAccount.Name = 'testaccount';
        testAccount.BillingStreet = 'Street';
        testAccount.BillingCity = 'City';
        testAccount.BillingState = '';
        testAccount.BOLT_Account_Number__c = '999';
        testAccount.BillingPostalCode = '11000';
        testAccount.BillingCountry = 'United States';
        testAccount.CMI_Region__c = 'India';
        testAccount.CSS_Locale__c = 'English(India)';         
        testAccount.RecordTypeId = OSM_TestDataCreationUtility.getAccountRecordTypeID();
        testAccount.OwnerId = OSM_TestDataCreationUtility.getSystemAdministratorID();
        testAccount.CSS_Timezone__c = '(GMT+05:30) India Standard Time (Asia/Kolkata)';
        testAccount.CSS_DistributorCode__c='02850';
        testAccount.CSS_DBCode__c='020400';
        testAccount.BMS_Customer_ID__c='22925';
       // testAccount.OSM_Location_ID__c='03520-020400';
        insert testAccount;     
        
        //Create child account
        Account testChildAccount = new Account();
        testChildAccount.Name = 'testchildaccount';
        testChildAccount.BillingStreet = 'Street';
        testChildAccount.BillingCity = 'City';
        testChildAccount.BillingState = '';
        testChildAccount.BOLT_Account_Number__c = '999';
        testChildAccount.BillingPostalCode = '11000';
        testChildAccount.BillingCountry = 'United States';
        testChildAccount.CMI_Region__c = 'India';
        testChildAccount.CSS_Locale__c = 'English(India)';         
        testChildAccount.RecordTypeId = OSM_TestDataCreationUtility.getAccountRecordTypeID();
        testChildAccount.OwnerId = OSM_TestDataCreationUtility.getSystemAdministratorID();
        testChildAccount.CSS_Timezone__c = '(GMT+05:30) India Standard Time (Asia/Kolkata)';
        testChildAccount.CSS_DistributorCode__c='02850';
        testChildAccount.CSS_DBCode__c='02850';
        //testChildAccount.BMS_Customer_ID__c='22925';
       // testAccount.OSM_Location_ID__c='03520-020400';
        insert testChildAccount; 
        //Create contact
        
        Contact contact1 = new Contact(
        FirstName = 'Test',
        Lastname = 'McTesty',
        AccountId = testAccount.Id,IAM_Cummins_login_ID__c='test',
        Email = System.now().millisecond() + 'test@test.com'
        );
        Database.insert(contact1);
       
        ccrz__E_Order__c testOrder = new ccrz__E_Order__c();
        testOrder.ccrz__Name__c = 'TestOrder';
        testOrder.ccrz__Contact__c = contact1.id;
        testOrder.ccrz__Account__c=testChildAccount.Id;
        testOrder.BMS_BranchLocation__c='E4';
        testOrder.Order_Source_Type__c='OSM';
        testOrder.BMS_OrderRefNumber__c=12345;
        Database.insert(testOrder);
          //CC OrderItem
             ccrz__E_Product__c pro = new ccrz__E_Product__c();
        pro.Name = 'CA Base-OHT';
        pro.ccrz__SKU__c = '5678902-OHT';
        pro.ccrz__Quantityperunit__c = 1;
        pro.Group_Name__c = 'DA';
        //pro.ccrz__ParentProduct__c = parentpro.id;
        pro.Product_Class_Code__c = 'SW-Web Access';
        insert pro;
        ccrz__E_OrderItem__c oi1 = new ccrz__E_OrderItem__c();
        oi1.ccrz__Price__c = 500;
        oi1.ccrz__OriginalItemPrice__c = 400;
        oi1.ccrz__Quantity__c = 1;
        oi1.ccrz__OriginalQuantity__c=1;
        oi1.ccrz__SubAmount__c = 123;
        oi1.ccrz__Order__c = testOrder.id;
        oi1.ccrz__Product__c = pro.id;
        oi1.ccrz__Subscription_Auto_Renewal__c = true;
        oi1.ccrz__DisplayProduct__c = pro.id;
        oi1.Dn_Price__c = 1000;
        insert oi1;
      //  List<ccrz__E_Invoice__c> lstCCInvoices = new List<ccrz__E_Invoice__c>();
        //for(Integer i=0; i<10; i++){
            ccrz__E_Invoice__c ccInvoices = new ccrz__E_Invoice__c();
            ccInvoices.ccrz__CCOrder__c = testOrder.id;
            ccInvoices.ccrz__Contact__c = contact1.id;
            ccInvoices.ccrz__CurrencyCode__c = 'USD';
            ccInvoices.ccrz__Status__c = 'Open';
            ccInvoices.ccrz__Storefront__c = 'Software';
            ccInvoices.ccrz__DateIssued__c = System.today().addMonths(2);
            ccInvoices.ccrz__OriginalAmount__c = 200;
            ccInvoices.ccrz__Terms__c = 'TestDataTerms';
            ccInvoices.BMS_PONumber__c='123456';
            ccInvoices.BMS_InvoiceNumber__c=123456;
            ccInvoices.OSM_Child_Account__c=testChildAccount.id;
           // ccInvoices.ICInvoice_Number__c='1234';
            ccInvoices.ICInvoice_Date__c = System.today();
           // lstCCInvoices.add(ccInvoices);
    //    }
      //   Database.insert(lstCCInvoices);
           insert ccInvoices;
           Set<Id> setInvoiceId=new Set<Id>();
         //  for(ccrz__E_Invoice__c invoiceId:lstCCInvoices){
             setInvoiceId.add(ccInvoices.id);
         //    }
        test.starttest();
        OSM_Intercompany_Generalized_REQ req=new OSM_Intercompany_Generalized_REQ();
          OSM_Intercompany_Generalized_RES res= new OSM_Intercompany_Generalized_RES(); 
          OSM_Intercompany_REQ req1=new OSM_Intercompany_REQ();
          OSM_Intercompany_RES res1=new OSM_Intercompany_RES();
        OSM_Intercompany_FutureLayerHandler.callIntercompanyInvoiceAPI(setInvoiceId,false,true);
             test.stoptest();
}
    // Create CC Invoices
    public static testMethod void createTestDataNegative(){
    //Create account
        Account testaccount = new Account();
        testAccount.Name = 'testaccount';
        testAccount.BillingStreet = 'Street';
        testAccount.BillingCity = 'City';
        testAccount.BillingState = '';
        testAccount.BOLT_Account_Number__c = '999';
        testAccount.BillingPostalCode = '11000';
        testAccount.BillingCountry = 'United States';
        testAccount.CMI_Region__c = 'India';
        testAccount.CSS_Locale__c = 'English(India)';         
        testAccount.RecordTypeId = OSM_TestDataCreationUtility.getAccountRecordTypeID();
        testAccount.OwnerId = OSM_TestDataCreationUtility.getSystemAdministratorID();
        testAccount.CSS_Timezone__c = '(GMT+05:30) India Standard Time (Asia/Kolkata)';
        testAccount.CSS_DistributorCode__c='03520';
       // testAccount.CSS_DBCode__c='020400';
        testAccount.BMS_Customer_ID__c='22925';
       // testAccount.OSM_Location_ID__c='03520-020400';
        insert testAccount;     //Create contact
        //Create child account
        Account testChildAccount = new Account();
        testChildAccount.Name = 'testchildaccount';
        testChildAccount.BillingStreet = 'Street';
        testChildAccount.BillingCity = 'City';
        testChildAccount.BillingState = '';
        testChildAccount.BOLT_Account_Number__c = '999';
        testChildAccount.BillingPostalCode = '11000';
        testChildAccount.BillingCountry = 'United States';
        testChildAccount.CMI_Region__c = 'India';
        testChildAccount.CSS_Locale__c = 'English(India)';         
        testChildAccount.RecordTypeId = OSM_TestDataCreationUtility.getAccountRecordTypeID();
        testChildAccount.OwnerId = OSM_TestDataCreationUtility.getSystemAdministratorID();
        testChildAccount.CSS_Timezone__c = '(GMT+05:30) India Standard Time (Asia/Kolkata)';
        testChildAccount.CSS_DistributorCode__c='02850';
        testChildAccount.CSS_DBCode__c='02850';
        testChildAccount.BMS_Customer_ID__c='22925';
       // testAccount.OSM_Location_ID__c='03520-020400';
        insert testChildAccount; 

        Contact contact1 = new Contact(
        FirstName = 'Test',
        Lastname = 'McTesty',
        AccountId = testAccount.Id,IAM_Cummins_login_ID__c='test',
        Email = System.now().millisecond() + 'test@test.com'
        );
        Database.insert(contact1);
       
        ccrz__E_Order__c testOrder = new ccrz__E_Order__c();
        testOrder.ccrz__Name__c = 'TestOrder';
        testOrder.ccrz__Contact__c = contact1.id;
        testOrder.ccrz__Account__c=testChildAccount.Id;
        testOrder.BMS_BranchLocation__c='E4';
        testOrder.Order_Source_Type__c='OSMCM';
        testOrder.BMS_OrderRefNumber__c=12345;
        Database.insert(testOrder);
    //    List<ccrz__E_Invoice__c> lstCCInvoices = new List<ccrz__E_Invoice__c>();
      //  for(Integer i=0; i<10; i++){
            ccrz__E_Invoice__c ccInvoices = new ccrz__E_Invoice__c();
            ccInvoices.ccrz__CCOrder__c = testOrder.id;
            ccInvoices.ccrz__Contact__c = contact1.id;
            ccInvoices.ccrz__CurrencyCode__c = 'USD';
            ccInvoices.ccrz__Status__c = 'Open';
            ccInvoices.ccrz__Storefront__c = 'Software';
            ccInvoices.ccrz__DateIssued__c = System.today().addMonths(2);
            ccInvoices.ccrz__OriginalAmount__c = 200;
            ccInvoices.ccrz__Terms__c = 'TestDataTerms';
            ccInvoices.BMS_PONumber__c='123456';
            ccInvoices.BMS_InvoiceNumber__c=123456;
          //  ccInvoices.ICInvoice_Number__c='1234';
          ccInvoices.ICInvoice_Date__c = System.today();
            ccInvoices.OSM_SW_IsIntercompanyInvoice__c=true;
            ccInvoices.OSM_SW_IsBoltARInvoiceDone__c=true;
            ccInvoices.OSM_SW_isBoltJournalEntryDone__c=true;
             ccInvoices.OSM_Child_Account__c=testChildAccount.id;

            insert ccInvoices;
       //     lstCCInvoices.add(ccInvoices);
      //  }
       //  Database.insert(lstCCInvoices);
         Set<Id> setInvoiceId=new Set<Id>();
     //    for(ccrz__E_Invoice__c invoiceId:lstCCInvoices){
             setInvoiceId.add(ccInvoices.id);
      //   }
        test.starttest();
      //   Test.setMock(HttpCalloutMock.class, new OMS_Intercompany_Mock()); 
      OSM_Intercompany_Generalized_REQ req=new OSM_Intercompany_Generalized_REQ();
      OSM_Intercompany_Generalized_RES res= new OSM_Intercompany_Generalized_RES();  
      OSM_Intercompany_REQ req1=new OSM_Intercompany_REQ();
      OSM_Intercompany_RES res1=new OSM_Intercompany_RES();
      String json='{"Header":{"Target":{"TargetID":"BMS"},"Sender":{"ServiceName":"IntercompanyRequest","SenderID":"Mrktplc"}},"DataArea":{"LocationID":"02850-02651","CustomerCode":"26976","CInvoice_Header":[{"ORDER_SOURCE_TYPE":"OSM","ICInvoice_Number":"000001715","ICInvoice_Date":"2019-01-28","BRANCH_LOCATION":"V9","BMS_PO_NUMBER":"S1V9010074","BMS_OE_REFERENCE":334931,"BMS_INVOICE_NUMBER":71,"Attribute03":"","Attribute02":"","Attribute01":0}],"Attribute03":"","Attribute02":"","Attribute01":0}}';
      String resJson='{"DataArea":{"DistributorCode":"02850","CustomerCode":26976,"Attribute01":"","Attribute03":"","Attribute02":""},"Header":{"Sender":{"ServiceName":"IntercompanyRequest","SenderID":"Mrktplc"},"Status":"Success","Target":{"TargetID":"BMS"},"StatusMessage":"Success"}}';
        OSM_Intercompany_REQ.parse(json);
        OSM_Intercompany_RES.parse(resJson);
         OSM_Intercompany_FutureLayerHandler.callIntercompanyInvoiceAPI(setInvoiceId,false,false);
         OSM_WS_RetryInterCompanyInvoiceInt invoiceInt=new OSM_WS_RetryInterCompanyInvoiceInt();
         OSM_Intercompany_Generalized_REQ.parse(json);
         OSM_Intercompany_Generalized_RES.parse(resJson);
         Database.executeBatch(invoiceInt);
          OSM_WS_RetryInterCompanyIntSchedular schedular=new OSM_WS_RetryInterCompanyIntSchedular();        
         test.stoptest();
}

}