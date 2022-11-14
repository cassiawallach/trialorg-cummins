// Update sharad 16 Sept 21
//updated by sharad
//Last Modified By: Swetha  for-OMG- 955 

@IsTest
public class OSM_WS_RetryVertexJobs_Test{

    public static final Id PROFILEID=TestingUtils.SYS_ADMIN_PROFILE_ID;
    
    static testMethod void testVertexJobs()
    {
         User usr=TestingUtils.createUser('12340',PROFILEID,true);
         List<ccrz__E_AccountGroup__c> accGrpId=TestingUtils.createAccountGroup(1,'TetsAccountGroup','none',true);
         List<Account> accId=TestingUtils.createAccount(1,'testAccount',accGrpId[0].id,usr.id,true);
         List<Contact> con=TestingUtils.createContact(1,accId[0].id,usr.id,true);
         ccrz__E_Order__c order=TestingUtils.createOrder(con[0].id,'testOrder',true);  
         List<ccrz__E_Invoice__c> invoiceList=TestingUtils.createCCInvoices(1,order.id,con[0].id,'Pending','Cart',true);
        invoiceList[0].Invoice_Type__c = 'Credit Memo';
        Database.update(invoiceList);
        
         List<OSM_Orders_In_Invoice__c> orderInvoiceList=new List<OSM_Orders_In_Invoice__c>();
         OSM_Orders_In_Invoice__c orderInvoice=new OSM_Orders_In_Invoice__c();
         orderInvoice.OSM_SW_Is_Refund_Request__c=true;
        orderInvoice.Vertex_Call_Status__c='Success';
         orderInvoice.CC_Invoice__c=invoiceList[0].id;
         //orderInvoice.CC_Invoice__r.Recurring_Invoice__c=true;
         orderInvoice.CC_Order__c=order.Id;
         orderInvoiceList.add(orderInvoice);
         insert orderInvoiceList;

         Test.StartTest();
             OSM_WS_ScheduleVertexBatchJob scheduleVertex=new OSM_WS_ScheduleVertexBatchJob();
             scheduleVertex.execute(null);
             OSM_WS_RetryVertexJobs retryVertexJob=new OSM_WS_RetryVertexJobs();
             retryVertexJob.execute(null,orderInvoiceList);
         Test.StopTest();
    }
    
    
    static testMethod void testVertexJobs2(){
    
        TestProductSetupReq testReq = new TestProductSetupReq();
        testReq.permissionSetName = 'OSM_Support_Admin';
        testReq.accountGroupName = 'TestingAccountGroup';
        testReq.accountName = 'TestingAccount';
        testReq.compositeProductName = 'Connected Diagnostics';
        testReq.compositeProductSKU = '1234567-BUS';
        testReq.compositeProductGroupName = 'DA';
        testReq.compositeProductProductType = 'Aggregated';
        testReq.componentProductName = 'CD Base-BUS';
        testReq.componentProductStatus = 'Released';
        testReq.componentProductSKU = '1234568-BUS';
        testReq.componentProductGroupName = 'DA';
        testReq.componentProductPackageName = 'Base';
        testReq.priceListName = 'TestPriceList';
        testReq.specName = 'TestName';

        TestCompletedTransactionSetUpRes transecRes = new TestCompletedTransactionSetUpRes();
                                
        transecRes = OSM_TestDataCreationUtility.createProductSetUp(testReq);
        
        List<OSM_Orders_In_Invoice__c> orderInvoiceList=new List<OSM_Orders_In_Invoice__c>();
         OSM_Orders_In_Invoice__c orderInvoice=new OSM_Orders_In_Invoice__c();
         orderInvoice.OSM_SW_Is_Refund_Request__c=true;
         orderInvoice.CC_Invoice__c=transecRes.invoice.Id;
         //orderInvoice.CC_Invoice__r.Recurring_Invoice__c=true;
         orderInvoice.CC_Order__c=transecRes.order.Id;
         orderInvoiceList.add(orderInvoice);
         insert orderInvoiceList;
         
         OSM_InvoiceLine_And_OrderLine__c objItems = new OSM_InvoiceLine_And_OrderLine__c();
         objItems.OSM_Orders_In_Invoice__c = orderInvoiceList[0].Id;
         objItems.Quantity__c = 2;
         objItems.Sales_Amount__c = 2;
         objItems.CC_Invoice_Item__c = transecRes.invoiceItems[0].Id;
         objItems.CC_Order_Item__c = transecRes.orderItem.Id;
         insert objItems;
        
        List<CSS_Integration_Details__c> lstCustomSetting = new List<CSS_Integration_Details__c>(); 
        CSS_Integration_Details__c intDetails = new CSS_Integration_Details__c();
        intDetails.ApplicationName__c = 'OSMVertex';
        intDetails.Name = 'OSMVertex';
        intDetails.End_Point__c = 'https://services-test-oauth.cummins.com/api/oauth/token/cso';
        intDetails.IsActive__c = true;
        intDetails.Key__c = '694a2e07-c2dc-4473-81da-b693866d37b6';
        intDetails.Passcode__c = 'f6e1b39a-ad95-4d12-ab73-148afbfa8dcb';
        
        lstCustomSetting.add(intDetails);
        
        CSS_Integration_Details__c intDetails1 = new CSS_Integration_Details__c();
        intDetails1.ApplicationName__c = 'getVertexInvoiceTax';
        intDetails1.Name = 'getVertexInvoiceTax';
        intDetails1.AuthEnv__c = 'OSMBolt';
        intDetails1.End_Point__c = 'https://services-test.cummins.com/cso/taxinvoice';
        intDetails1.IsActive__c = true;
        intDetails1.Key__c = 'appSubscription-api-key';
        intDetails1.Method_Type__c = 'GET';
        intDetails1.Passcode__c = '';
        intDetails1.Timeout__c = 120000;
        lstCustomSetting.add(intDetails1);
        
        insert lstCustomSetting;
        Test.StartTest();
            
             OSM_WS_ScheduleVertexBatchJob scheduleVertex=new OSM_WS_ScheduleVertexBatchJob();
             scheduleVertex.execute(null);
        
             OSM_WS_RetryVertexJobs retryVertexJob=new OSM_WS_RetryVertexJobs();
             retryVertexJob.execute(null,orderInvoiceList);
        
         Test.StopTest();
     }
     
     static testMethod void testVertexJobs3(){
    
        TestProductSetupReq testReq = new TestProductSetupReq();
        testReq.permissionSetName = 'OSM_Support_Admin';
        testReq.accountGroupName = 'TestingAccountGroup';
        testReq.accountName = 'TestingAccount';
        testReq.compositeProductName = 'Connected Diagnostics';
        testReq.compositeProductSKU = '1234567-BUS';
        testReq.compositeProductGroupName = 'DA';
        testReq.compositeProductProductType = 'Aggregated';
        testReq.componentProductName = 'CD Base-BUS';
        testReq.componentProductStatus = 'Released';
        testReq.componentProductSKU = '1234568-BUS';
        testReq.componentProductGroupName = 'DA';
        testReq.componentProductPackageName = 'Base';
        testReq.priceListName = 'TestPriceList';
        testReq.specName = 'TestName';
        TestCompletedTransactionSetUpRes transecRes = new TestCompletedTransactionSetUpRes();
		
         transecRes = OSM_TestDataCreationUtility.createProductSetUp(testReq);
        System.debug('transecRes: '+transecRes);

        ccrz__E_ContactAddr__c objAddress = new ccrz__E_ContactAddr__c();
            objAddress.ccrz__AddressFirstline__c = '1460 N National Rd';
            objAddress.ccrz__AddressSecondline__c = '';
            objAddress.ccrz__City__c = 'Columbus';
            objAddress.ccrz__CompanyName__c = 'HCL';
            objAddress.ccrz__Country__c = 'United States';
            objAddress.ccrz__CountryISOCode__c = 'US';
            objAddress.ccrz__FirstName__c = 'Sharad';
            objAddress.ccrz__Email__c = 'test@gamil.com';
            objAddress.ccrz__LastName__c = 'Sahu';
            objAddress.ccrz__PostalCode__c = '47201';
            objAddress.ccrz__StateISOCode__c = 'IN';
            objAddress.ccrz__State__c = 'Indiana';
            
            insert objAddress;
        
        ccrz__E_Order__c ordrObj = new ccrz__E_Order__c();
        ordrObj.Id = transecRes.order.Id;
        ordrObj.ccrz__BillTo__c = objAddress.Id;
        ordrObj.ccrz__ShipTo__c = objAddress.Id;
        
        update ordrObj;
        
        List<OSM_Orders_In_Invoice__c> orderInvoiceList=new List<OSM_Orders_In_Invoice__c>();
         OSM_Orders_In_Invoice__c orderInvoice=new OSM_Orders_In_Invoice__c();
         orderInvoice.OSM_SW_Is_Refund_Request__c=true;
         orderInvoice.CC_Invoice__c=transecRes.invoice.Id;
         orderInvoice.CC_Order__c=transecRes.order.Id;
         orderInvoiceList.add(orderInvoice);
         insert orderInvoiceList;
         
         OSM_InvoiceLine_And_OrderLine__c objItems = new OSM_InvoiceLine_And_OrderLine__c();
         objItems.OSM_Orders_In_Invoice__c = orderInvoiceList[0].Id;
         objItems.Quantity__c = 2;
         objItems.Sales_Amount__c = 2;
         objItems.CC_Invoice_Item__c = transecRes.invoiceItems[0].Id;
         objItems.CC_Order_Item__c = transecRes.orderItem.Id;
         insert objItems;
        
        List<CSS_Integration_Details__c> lstCustomSetting = new List<CSS_Integration_Details__c>(); 
        CSS_Integration_Details__c intDetails = new CSS_Integration_Details__c();
        intDetails.ApplicationName__c = 'OSMVertex';
        intDetails.Name = 'OSMVertex';
        intDetails.End_Point__c = 'https://services-test-oauth.cummins.com/api/oauth/token/cso';
        intDetails.IsActive__c = true;
        intDetails.Key__c = '694a2e07-c2dc-4473-81da-b693866d37b6';
        intDetails.Passcode__c = 'f6e1b39a-ad95-4d12-ab73-148afbfa8dcb';
        
        lstCustomSetting.add(intDetails);
        
        CSS_Integration_Details__c intDetails1 = new CSS_Integration_Details__c();
        intDetails1.ApplicationName__c = 'getVertexInvoiceTax';
        intDetails1.Name = 'getVertexInvoiceTax';
        intDetails1.AuthEnv__c = 'OSMBolt';
        intDetails1.End_Point__c = 'https://services-test.cummins.com/cso/taxinvoice';
        intDetails1.IsActive__c = true;
        intDetails1.Key__c = 'appSubscription-api-key';
        intDetails1.Method_Type__c = 'GET';
        intDetails1.Passcode__c = '';
        intDetails1.Timeout__c = 120000;
        lstCustomSetting.add(intDetails1);
        
        insert lstCustomSetting;

        Test.StartTest();
         
             OSM_WS_ScheduleVertexBatchJob scheduleVertex=new OSM_WS_ScheduleVertexBatchJob();
             scheduleVertex.execute(null);
         
             OSM_WS_RetryVertexJobs retryVertexJob=new OSM_WS_RetryVertexJobs();
             retryVertexJob.execute(null,orderInvoiceList);
         
         Test.StopTest();
     }
     
}