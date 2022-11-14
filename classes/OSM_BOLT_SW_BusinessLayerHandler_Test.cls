/*************************************************
 History
 --------
 VERSION    AUTHOR          DATE            DETAILS
 1.0        Ashish          03/03/2021      Test Class Fixes
 2.0        Ashish          05/03/2021      Test Class Fixes
 3.0        Ashish          05/03/2021      Test Class Fixes
 4.0        Ashish          05/03/2021      Test Class Fixes
 5.0        Ashish          19/03/2021      Test Class Fixes
 6.0        Ashish          31/03/2021      Test Class Fixes
 7.0        Ashish          31/03/2021      Test Class Fixes
 8.0        Ashish          21/04/2021      Test Class Fixes
 9.0        Sangeeta Rani   10/05/2021      Test class update
 9.1        Ashish          20/05/2021      Test Class Fixes
 10.0       Ashish          21/05/2021      Test Class Fixes
 11.0       Ashish          07/06/2021      Test Class Fixes
 12.0       Dhiraj          11/06/2021     
 13.0       Ashish          25/06/2021      Test Class Fixes
 14.0       Ashish          28/06/2021      Test Class Fixes
 14.1       Sharad          28 June 2021
 15.0       Ashish          29/06/2021      Test Class Fixes  
 16.0       Ashish          13/07/2021      Test Class Fixes  
 17.0       Sangeeta        29/07/2021      Test Class Fixes 
 18.0       Ashish          28/07/2021      Test Class Fixes
 18.1       Ashish          17/08/2021      Test Class Fixes 
 18.2       Sangeeta        09/09/2021      Test Class Fixes  
 18.3       Sangeeta        14/09/2021      Test Class Fixes 
 19.0       Sangeeta        22/09/2021      Test Class Fixes
 19.1       Ashish G        11/24/2021      Test Class Fixes
 19.1       Ashish G        02/15/2022      Test Class Fixes
 19.1       Ashish G        02/09/2022      Test Class Fixes
 Test class addition for deployment done
 */
@isTest
global class OSM_BOLT_SW_BusinessLayerHandler_Test{

    public static testMethod void ARInvoiceWrapperTest(){
      
        
        List<Id> productIdList = new List<Id>();
        String AccountId;
        Map<ID,ccrz__E_Order__c> MapOrdero= new Map<ID,ccrz__E_Order__c>();
        Map<ID,ccrz__E_Order__c> MapOrdern= new Map<ID,ccrz__E_Order__c>();
        List<ccrz__E_Order__c> orderlIst = new List<ccrz__E_Order__c>();
       
        //Create Custom setting records
        CSS_Integration_Details__c cd = new CSS_Integration_Details__c();
        cd.name = 'getARInvoice';
        cd.ApplicationName__c = 'getAR';
        cd.AuthEnv__c = 'OSMBolt';
        cd.End_Point__c = 'https://services-dev.cummins.com/cso/arinvoice';
        cd.IsActive__c = true;
        cd.Key__c = 'appSubscription-api-key';
        cd.Logging__c = null;
        cd.Method_Type__c = 'POST';
        cd.Passcode__c = null;
        cd.Timeout__c = 120000; 
        cd.Username__c = null;
        insert cd;
        
        CSS_Integration_Details__c cd1 = new CSS_Integration_Details__c();
        cd1.name = 'OSMBolt';
        cd1.ApplicationName__c = 'OSMBolt';
        cd1.AuthEnv__c = null;
        cd1.End_Point__c = 'https://services-dev-oauth.cummins.com/api/oauth/token/cso';
        cd1.IsActive__c = true;
        cd1.Key__c = '604ffcd5-29fa-49ca-b284-c2250850d1f0';
        cd1.Logging__c = null;
        cd1.Method_Type__c = null;
        cd1.Passcode__c = '79a7327f-86d8-4c15-94fd-fa7a44ca1d41';
        cd1.Timeout__c = null;  
        cd1.Username__c = null;
        insert cd1;
        
        Id SYS_ADMIN_PROFILE_ID = [SELECT Id FROM Profile WHERE Name = 'System Administrator' Limit 1].Id;
        //User Record
        Double randomNumber = math.random();
        User user1 = TestingUtils.createUser('testinUser' + randomNumber, SYS_ADMIN_PROFILE_ID, true);
        // Account Test Data creation
        List<ccrz__E_AccountGroup__c> accntGroup = TestingUtils.createAccountGroup(1, 'TestingProdUtilAccountGrp', 'Best Price', true);
        List<Account> accountList=new List<Account>();
        List<Account> acnt = TestingUtils.createAccount(1, 'TestingProdUtilAccount', accntGroup[0].id, user1.id, false);
        for(Account acc:acnt){
        acc.Bolt_BC_Code__c= '390';
        acc.RecordTypeId = OSM_TestDataCreationUtility.getAccountRecordTypeID();
        acc.OwnerId = OSM_TestDataCreationUtility.getSystemAdministratorID();
        acc.Type='Distributor Branch Account';
        acc.CSS_DistributorCode__c='11000';
        acc.BillingPostalCode = '11000';
        acc.IAM_Service_Provider_Code__c='11000';
        acc.Bolt_Payment_Terms__c='test';
        acc.CSS_DBCode__c = '020400';
        acc.Customer_Location_Code__c = '123';
        acc.EBU_Channel_of_Distribution__c = 'CIHR';
        acc.CSS_Timezone__c = '(GMT+05:30) India Standard Time (Asia/Kolkata)';
        accountList.add(acc);
        }
        insert accountList; 
        
        Account testAccount=[Select id,name from Account where type=:'Distributor Branch Account' limit 1];
        //conatct record
        List < Contact > contacts = TestingUtils.createContact(1, testAccount.id, user1.id, true);
        ccrz__E_ContactAddr__c conAddrs =TestingUtils.createContactAddress(testAccount.id,true);
        //CC Order Test Data creation
        ccrz__E_Order__c o1 = new ccrz__E_Order__c ();
        o1.ccrz__Storefront__c = 'SoftwareStore';
        o1.ccrz__Account__c = testAccount.Id;
        o1.ccrz__CurrencyISOCode__c = 'USD';
        o1.OSM_SW_Is_Bolt_PO__c = true;
        o1.OSM_SW_isBoltJournalEntryDone__c= true;
        o1.IsReversalBoltJournalEntryDone__c= true;
        o1.OSM_Discount_On_BOLT__c=10.1;
        
        insert o1;
        orderlIst.add(o1);
        AccountId = o1.ccrz__Account__c;
        MapOrdero.put(o1.id,o1);
        orderlIst.add(o1);
        
        
        ccrz__E_Order__c o11 = new ccrz__E_Order__c (id = o1.id);
        o11.ccrz__OrderStatus__c = 'Order Submitted';
        o11.ccrz__OrderDate__c = system.today();
        update o11;
        MapOrdern.put(o1.id,o1);
        
        //Put CC Order data Into Map
        Map<Id,ccrz__E_Order__c> cor=new Map<Id,ccrz__E_Order__c>();
        cor.put(o1.id,o1); 
        set<id> ke=cor.keyset();
        //Product Test Data creation
        List<ccrz__E_Product__c> listProd = TestingUtils.createEProduct(1, 'guidenz', 'Released', 1,'5678902-OHT11','SES',true);
        
        //CC OrderItem Test Data creation
        ccrz__E_OrderItem__c oi1 = new ccrz__E_OrderItem__c();
        oi1.ccrz__Price__c = 500;
        oi1.ccrz__OriginalItemPrice__c = 400;
        oi1.ccrz__Quantity__c = 1;
        oi1.ccrz__SubAmount__c = 123;
        oi1.ccrz__Order__c = o1.id;
        oi1.ccrz__Product__c = listProd[0].id;
        oi1.ccrz__Subscription_Auto_Renewal__c = true;
        oi1.ccrz__DisplayProduct__c = listProd[0].id;
        oi1.ccrz__PercentDiscount__c =8.33;  
        oi1.CurrencyIsoCode='USD';
        insert oi1;
        Set<Id> setOrdItemId = new Set<Id>();
        setOrdItemId.add(oi1.id);
        
        //CC Subscription Test Data creation
        ccrz__E_Subscription__c Sub=TestingUtils.createSubscription(testaccount.id,listProd[0].id,o1.id,oi1.id,'Active',true);
        
        //Order Subscrciption Junction
        OSM_Order_Subscription__c osj = new OSM_Order_Subscription__c();
        osj.OSM_CCOrder__c = o1.id;
        osj.CC_Order_Item__c = oi1.id;
        //osj.CCProduct__c = pro.id;
        osj.CCQuantity__c = 1;
        osj.OSM_CCSubscription__c = Sub.id;
        osj.Billing_Frequency__c = 'Monthly';
        insert osj;
       //Invoice Records Creation
       List<ccrz__E_Invoice__c> invc= TestingUtils.createCCInvoices(1, o1.id, contacts[0].Id ,'Paid','SoftwareStore',false);
        List<ccrz__E_Invoice__c> listInvc= new List<ccrz__E_Invoice__c>();
        for(ccrz__E_Invoice__c invc1:invc){
        invc1.ccrz__BillAddress__c =conAddrs.id;
        invc1.CreditMemo_Number__c='I-0000001561C';
        invc1.OSM_SW_IsIntercompanyInvoice__c = false;
        listInvc.add(invc1);
        }
        insert listInvc;
        List<Id>Listinv = new List<Id>();
        Listinv.add(listInvc[0].id);
        //Test Data creation
        List<ccrz__E_InvoiceItem__c> invitemList = new list<ccrz__E_InvoiceItem__c>();
        ccrz__E_InvoiceItem__c invitem = new ccrz__E_InvoiceItem__c();
        invitem.ccrz__Invoice__c = listInvc[0].id;
        invitem.ccrz__CCOrder__c = orderlIst[0].id;
        invitem.ccrz__CCOrderItem__c = oi1.id;
        invitem.ccrz__OriginalAmount__c = 10.0;
         invitem.Vertex_Tax__c = 3.0;
        invitem.CurrencyIsoCode = 'USD';
        invitem.OSM_Bypass_Flow__c=true;
        invitemList.add(invitem);
        insert invitemList;
        //Transaction payment Test Data creation
        ccrz__E_TransactionPayment__c  ctpayment = new ccrz__E_TransactionPayment__c();
        ctpayment.ccrz__AccountType__c = 'PO';
        //ctpayment.ccrz__AccountNumber__c='123';
        ctpayment.Transaction_Status__c = 'Order Placed Success';
        ctpayment.ccrz__Storefront__c = 'SoftwareStore';
        ctpayment.ccrz__CCOrder__c = o1.id;
        ctpayment.ccrz__InvoiceAppliedTo__c = listInvc[0].id;
        ctpayment.Bolt_JE_Call_Status__c = 'Pending';
         ctpayment.Bolt_JE_Reversal_Call_Status__c = 'Pending';
        ctpayment.Bolt_JE_Reversal_Call_Status__c = 'Failure';
        ctpayment.Bolt_JE_Reversal_Call_Status__c = 'Success';
        ctpayment.Bolt_AR_Call_Status__c = 'Pending';
        ctpayment.Bolt_Credit_Memo_Call_Status__c = 'Pending';
        insert ctpayment;
        
        Map<Id,Id>mapCTPInvcid = new Map<Id,Id>();
        mapCTPInvcid.put(ctpayment.id,ctpayment.id);
        system.debug('@@@@@@'+mapCTPInvcid);
        boolean isProcess = true;
        
        OSM_Integration_Log__c objIntLog = new OSM_Integration_Log__c();
        objIntLog.Transaction_Payment__c = ctpayment.id;
        objIntLog.Unique_Message_Identifier__c ='testUniqueMessageIdentifier';
        objIntLog.Service_Name__c = 'Journal Entry';
        objIntLog.Invoice__c = listInvc[0].id;
        insert objIntLog;
        Test.starttest();
        OSM_BOLT_SW_BusinessLayerHandler handler = new OSM_BOLT_SW_BusinessLayerHandler();
        // Checking the Negative scenarios
        OSM_BOLT_SW_BusinessLayerHandler.setARInvoiceOutboundWrapper(Listinv,mapCTPInvcid,'state',null);
        OSM_BOLT_SW_BusinessLayerHandler.setJournalEntryWrapper(Listinv,mapCTPInvcid,'state',null);
        // Checking the positive scenarios
        OSM_BOLT_SW_BusinessLayerHandler.setARInvoiceOutboundWrapper(Listinv,mapCTPInvcid,'state',setOrdItemId);
        OSM_BOLT_SW_BusinessLayerHandler.setJournalEntryWrapper(Listinv,mapCTPInvcid,'state',setOrdItemId);
        OSM_SW_General_Util.getuserType(Userinfo.getUserId());
        System.assertNotEquals(null,Listinv,'Invoice not created.');
        System.assertEquals(false, listInvc[0].OSM_SW_IsIntercompanyInvoice__c);
        System.assertEquals('Journal Entry', objIntLog.Service_Name__c);
        System.assertNotEquals(null,ctpayment.ccrz__InvoiceAppliedTo__c,'Transaction payment invoice not Mapped');
        Test.stoptest();
    }
    
     public static testMethod void ARInvoiceWrapperTest1(){
        
        List<Id> productIdList = new List<Id>();
        String AccountId;
        Map<ID,ccrz__E_Order__c> MapOrdero= new Map<ID,ccrz__E_Order__c>();
        Map<ID,ccrz__E_Order__c> MapOrdern= new Map<ID,ccrz__E_Order__c>();
        List<ccrz__E_Order__c> orderlIst = new List<ccrz__E_Order__c>();
        
        //Create Custom setting records
        CSS_Integration_Details__c cd = new CSS_Integration_Details__c();
        cd.name = 'getARInvoice';
        cd.ApplicationName__c = 'getAR';
        cd.AuthEnv__c = 'OSMBolt';
        cd.End_Point__c = 'https://services-dev.cummins.com/cso/arinvoice';
        cd.IsActive__c = true;
        cd.Key__c = 'appSubscription-api-key';
        cd.Logging__c = null;
        cd.Method_Type__c = 'POST';
        cd.Passcode__c = null;
        cd.Timeout__c = 120000; 
        cd.Username__c = null;
        insert cd;
        
        CSS_Integration_Details__c cd1 = new CSS_Integration_Details__c();
        cd1.name = 'OSMBolt';
        cd1.ApplicationName__c = 'OSMBolt';
        cd1.AuthEnv__c = null;
        cd1.End_Point__c = 'https://services-dev-oauth.cummins.com/api/oauth/token/cso';
        cd1.IsActive__c = true;
        cd1.Key__c = '604ffcd5-29fa-49ca-b284-c2250850d1f0';
        cd1.Logging__c = null;
        cd1.Method_Type__c = null;
        cd1.Passcode__c = '79a7327f-86d8-4c15-94fd-fa7a44ca1d41';
        cd1.Timeout__c = null;  
        cd1.Username__c = null;
        insert cd1;
        
        Id SYS_ADMIN_PROFILE_ID = [SELECT Id FROM Profile WHERE Name = 'System Administrator' Limit 1].Id;
        //User Record
        Double randomNumber = math.random();
        User user1 = TestingUtils.createUser('testinUser' + randomNumber, SYS_ADMIN_PROFILE_ID, true);
        // Account record fetch
        List<ccrz__E_AccountGroup__c> accntGroup = TestingUtils.createAccountGroup(1, 'TestingProdUtilAccountGrp', 'Best Price', true);
        List<Account> accountList=new List<Account>();
        List<Account> acnt = TestingUtils.createAccount(1, 'TestingProdUtilAccount', accntGroup[0].id, user1.id, false);
        for(Account acc:acnt){
        acc.Bolt_BC_Code__c= '390';
        acc.RecordTypeId = OSM_TestDataCreationUtility.getAccountRecordTypeID();
        acc.OwnerId = OSM_TestDataCreationUtility.getSystemAdministratorID();
        acc.Type='Distributor Branch Account';
        acc.CSS_DistributorCode__c='11000';
        acc.BillingPostalCode = '11000';
        acc.IAM_Service_Provider_Code__c='11000';
        acc.Bolt_Payment_Terms__c='test';
        acc.CSS_DBCode__c = '020400';
        acc.Customer_Location_Code__c = '123';
        acc.EBU_Channel_of_Distribution__c = 'CIHR';
        acc.CSS_Timezone__c = '(GMT+05:30) India Standard Time (Asia/Kolkata)';
        accountList.add(acc);
        }
        insert accountList;  
        List < Contact > contacts = TestingUtils.createContact(1, accountList[0].id, user1.id, true);
        ccrz__E_ContactAddr__c conAddrs =TestingUtils.createContactAddress(accountList[0].id,true);  
        //CC Order
        ccrz__E_Order__c o1 = new ccrz__E_Order__c ();
        o1.ccrz__Storefront__c = 'SoftwareStore';
        o1.ccrz__Account__c = accountList[0].Id;
        o1.ccrz__CurrencyISOCode__c = 'USD';
        o1.OSM_SW_Is_Bolt_PO__c = true;
        o1.OSM_SW_isBoltJournalEntryDone__c= true;
        o1.IsReversalBoltJournalEntryDone__c= true;
        o1.OSM_Discount_On_BOLT__c=10.2;
        
        insert o1;
        AccountId = o1.ccrz__Account__c;
        MapOrdero.put(o1.id,o1);
        orderlIst.add(o1);
        System.debug('---CC Order---'+o1);
        
        ccrz__E_Order__c o11 = new ccrz__E_Order__c (id = o1.id);
        o11.ccrz__OrderStatus__c = 'Order Submitted';
        o11.ccrz__OrderDate__c = system.today();
        update o11;
        MapOrdern.put(o1.id,o1);
        
        //Put CC Order data Into Map
        Map<Id,ccrz__E_Order__c> cor=new Map<Id,ccrz__E_Order__c>();
        cor.put(o1.id,o1); 
        set<id> ke=cor.keyset();
        
        List<ccrz__E_Product__c> listProd = TestingUtils.createEProduct(1, 'guidenz', 'Released', 1,'5678902-OHT11','SES',true);
        
        //CC OrderItem
        ccrz__E_OrderItem__c oi1 = new ccrz__E_OrderItem__c();
        oi1.ccrz__Price__c = 500;
        oi1.ccrz__OriginalItemPrice__c = 400;
        oi1.ccrz__Quantity__c = 1;
        oi1.ccrz__SubAmount__c = 123;
        oi1.ccrz__Order__c = o1.id;
        oi1.ccrz__Product__c = listProd[0].id;
        oi1.ccrz__Subscription_Auto_Renewal__c = true;
        oi1.ccrz__DisplayProduct__c = listProd[0].id;
        oi1.ccrz__PercentDiscount__c =8.33;  
        oi1.CurrencyIsoCode='USD';
        insert oi1;
         Set<Id> setOrdItemId = new Set<Id>();
        setOrdItemId.add(oi1.id);
        System.debug('---CC OrderItem---'+oi1); 
        //CC Subscription
        ccrz__E_Subscription__c Sub=TestingUtils.createSubscription(accountList[0].id,listProd[0].id,o1.id,oi1.id,'Active',true);
        
        //Order Subscrciption Junction
        OSM_Order_Subscription__c osj = new OSM_Order_Subscription__c();
        osj.OSM_CCOrder__c = o1.id;
        osj.CC_Order_Item__c = oi1.id;
        //osj.CCProduct__c = pro.id;
        osj.CCQuantity__c = 1;
        osj.OSM_CCSubscription__c = Sub.id;
        osj.Billing_Frequency__c = 'Monthly';
        insert osj;
       //Invoice records
       List<ccrz__E_Invoice__c> invc= TestingUtils.createCCInvoices(1, o1.id, contacts[0].Id ,'Paid','SoftwareStore',false);
        List<ccrz__E_Invoice__c> listInvc= new List<ccrz__E_Invoice__c>();
        for(ccrz__E_Invoice__c invc1:invc){
        invc1.ccrz__BillAddress__c =conAddrs.id;
        invc1.CreditMemo_Number__c='I-0000001561C';
        invc1.OSM_SW_IsIntercompanyInvoice__c = false;
        listInvc.add(invc1);
        }
        insert listInvc;
        List<Id>Listinv = new List<Id>();
        Listinv.add(listInvc[0].id);
          
         
        List<ccrz__E_InvoiceItem__c> invitemList = new list<ccrz__E_InvoiceItem__c>();
        ccrz__E_InvoiceItem__c invitem = new ccrz__E_InvoiceItem__c();
        invitem.ccrz__Invoice__c = listInvc[0].id;
        invitem.ccrz__CCOrder__c = orderlIst[0].id;
        invitem.ccrz__CCOrderItem__c = oi1.id;
        invitem.ccrz__OriginalAmount__c = 10.0;
         invitem.Vertex_Tax__c = 3.0;
         invitem.CurrencyIsoCode = 'USD';
        invitem.OSM_Bypass_Flow__c=true;
        invitemList.add(invitem);
        insert invitemList;
        
        //Transaction payment
        ccrz__E_TransactionPayment__c  ctpayment = new ccrz__E_TransactionPayment__c();
        ctpayment.Transaction_Status__c = 'Order Placed Success';
        ctpayment.ccrz__Storefront__c = 'SoftwareStore';
        ctpayment.ccrz__CCOrder__c = o1.id;
        ctpayment.ccrz__InvoiceAppliedTo__c = listInvc[0].id;
        ctpayment.Bolt_JE_Reversal_Call_Status__c = 'Pending';
        ctpayment.Bolt_JE_Reversal_Call_Status__c = 'Failure';
        ctpayment.Bolt_JE_Reversal_Call_Status__c = 'Success';
        ctpayment.Bolt_AR_Call_Status__c = 'Success';
        ctpayment.Bolt_Credit_Memo_Call_Status__c = 'Success';
        insert ctpayment;
        
        Map<Id,Id>mapCTPInvcid = new Map<Id,Id>();
        mapCTPInvcid.put(ctpayment.id,ctpayment.id);
        system.debug('@@@@@@'+mapCTPInvcid);
        boolean isProcess = true;

        OSM_Integration_Log__c objIntLog = new OSM_Integration_Log__c();
        objIntLog.Transaction_Payment__c = ctpayment.id;
        objIntLog.Unique_Message_Identifier__c ='testUniqueMessageIdentifier';
        objIntLog.Service_Name__c = 'JournalEntryReversal';
        objIntLog.Invoice__c = listInvc[0].id;
        insert objIntLog;   
         
        Test.starttest();
        // Checking Negative scenarios 
        OSM_BOLT_SW_BusinessLayerHandler handler = new OSM_BOLT_SW_BusinessLayerHandler();
        OSM_BOLT_SW_BusinessLayerHandler.setARInvoiceOutboundWrapper(Listinv,mapCTPInvcid,'Order Cancel',null);
        OSM_BOLT_SW_BusinessLayerHandler.setJournalEntryWrapper(Listinv,mapCTPInvcid,'state',null);
        // Checking normal flow
        OSM_BOLT_SW_BusinessLayerHandler.setARInvoiceOutboundWrapper(Listinv,mapCTPInvcid,'state',setOrdItemId);
        OSM_BOLT_SW_BusinessLayerHandler.setJournalEntryWrapper(Listinv,mapCTPInvcid,'state',setOrdItemId);
        OSM_SW_General_Util.getuserType(Userinfo.getUserId());
        System.assertNotEquals(null,Listinv,'Invoice not created.');
        System.assertEquals(false, listInvc[0].OSM_SW_IsIntercompanyInvoice__c);
        System.assertEquals('JournalEntryReversal', objIntLog.Service_Name__c);
        System.assertNotEquals(null,ctpayment.ccrz__InvoiceAppliedTo__c,'Transaction payment invoice not Mapped'); 
        Test.stoptest();
    }

    public static testMethod void ARInvoiceWrapperTest11(){
        
      List<Id> productIdList = new List<Id>();
      String AccountId;
      Map<ID,ccrz__E_Order__c> MapOrdero= new Map<ID,ccrz__E_Order__c>();
      Map<ID,ccrz__E_Order__c> MapOrdern= new Map<ID,ccrz__E_Order__c>();
      List<ccrz__E_Order__c> orderlIst = new List<ccrz__E_Order__c>();
      
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User']; 
          String orgId = UserInfo.getOrganizationId();
          String dateString = String.valueof(Datetime.now().getTime());
          String uniqueName = orgId + dateString +'@test.com';
          User u = new User(Alias = 'standt', Email='standarduser@testorg.com', 
          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
          LocaleSidKey='en_US', ProfileId = p.Id, 
          TimeZoneSidKey='America/Los_Angeles', UserName=uniqueName);
          insert u;
     
     
     
      //Create Custom setting records
      CSS_Integration_Details__c cd = new CSS_Integration_Details__c();
      cd.name = 'getARInvoice';
      cd.ApplicationName__c = 'getAR';
      cd.AuthEnv__c = 'OSMBolt';
      cd.End_Point__c = 'https://services-dev.cummins.com/cso/arinvoice';
      cd.IsActive__c = true;
      cd.Key__c = 'appSubscription-api-key';
      cd.Logging__c = null;
      cd.Method_Type__c = 'POST';
      cd.Passcode__c = null;
      cd.Timeout__c = 120000; 
      cd.Username__c = null;
      insert cd;
      
      CSS_Integration_Details__c cd1 = new CSS_Integration_Details__c();
      cd1.name = 'OSMBolt';
      cd1.ApplicationName__c = 'OSMBolt';
      cd1.AuthEnv__c = null;
      cd1.End_Point__c = 'https://services-dev-oauth.cummins.com/api/oauth/token/cso';
      cd1.IsActive__c = true;
      cd1.Key__c = '604ffcd5-29fa-49ca-b284-c2250850d1f0';
      cd1.Logging__c = null;
      cd1.Method_Type__c = null;
      cd1.Passcode__c = '79a7327f-86d8-4c15-94fd-fa7a44ca1d41';
      cd1.Timeout__c = null;  
      cd1.Username__c = null;
      insert cd1;
      
        Id SYS_ADMIN_PROFILE_ID = [SELECT Id FROM Profile WHERE Name = 'System Administrator' Limit 1].Id;
        //User Record
        Double randomNumber = math.random();
        User user1 = TestingUtils.createUser('testinUser' + randomNumber, SYS_ADMIN_PROFILE_ID, true);
        List<ccrz__E_AccountGroup__c> accntGroup = TestingUtils.createAccountGroup(1, 'TestingProdUtilAccountGrp', 'Best Price', true);
        List<Account> accountList=new List<Account>();
        List<Account> acnt = TestingUtils.createAccount(1, 'TestingProdUtilAccount', accntGroup[0].id, user1.id, false);
        for(Account acc:acnt){
        acc.Bolt_BC_Code__c= '390';
        acc.RecordTypeId = OSM_TestDataCreationUtility.getAccountRecordTypeID();
        acc.OwnerId = OSM_TestDataCreationUtility.getSystemAdministratorID();
        acc.Type='Distributor Branch Account';
        acc.CSS_DistributorCode__c='11000';
        acc.BillingPostalCode = '11000';
        acc.IAM_Service_Provider_Code__c='11000';
        acc.Bolt_Payment_Terms__c='test';
        acc.CSS_DBCode__c = '020400';
        acc.Customer_Location_Code__c = '123';
        acc.EBU_Channel_of_Distribution__c = 'CIHR';
        acc.CSS_Timezone__c = '(GMT+05:30) India Standard Time (Asia/Kolkata)';
        accountList.add(acc);
        }
        insert accountList; 
         Account testAccount=[Select id,name from Account where type=:'Distributor Branch Account' limit 1];
       List < Contact > contacts = TestingUtils.createContact(1, testAccount.id, user1.id, true);
         
      ccrz__E_ContactAddr__c conAddrs = new ccrz__E_ContactAddr__c();
      conAddrs.ccrz__FirstName__c = 'STANADYNE (CHANGSHU)';
      conAddrs.ccrz__LastName__c = 'CORPORATION';
      conAddrs.ccrz__AddressFirstline__c = '155#HUANGSHI ROAD,SOUTHEAST DEVELOPMENT ZONE';
      conAddrs.ccrz__AddressSecondline__c = 'TEST22';
      conAddrs.ccrz__AddressThirdline__c = 'TEST22';
      conAddrs.Account__c = testAccount.id;
      conAddrs.Bolt_Active__c = true;
      conAddrs.BOLT_Operating_Unit__c = 'CN CFS Wuhan 745';
      conAddrs.Bolt_Site__c = true;
      conAddrs.ccrz__City__c = 'CHANGSHU';
      conAddrs.ccrz__ContactAddrId__c = '41252';
      //conAddrs.ccrz__Country__c = 
      conAddrs.ccrz__CountryISOCode__c = 'CN';
      conAddrs.ccrz__PostalCode__c = 'TEST22';
      conAddrs.Site_Use_Status__c = true;
      //conAddrs.ccrz__State__c = 
      conAddrs.ccrz__StateISOCode__c = 'TEST22';
      insert conAddrs;
      //CC Order
      ccrz__E_Order__c o1 = new ccrz__E_Order__c ();
      o1.ccrz__Storefront__c = 'SoftwareStore';
      o1.ccrz__Account__c = testAccount.Id;
      o1.ccrz__CurrencyISOCode__c = 'USD';
      o1.OSM_SW_Is_Bolt_PO__c = true;
      o1.OSM_SW_isBoltJournalEntryDone__c= true;
      o1.IsReversalBoltJournalEntryDone__c= true;
      o1.OSM_Discount_On_BOLT__c=10.1;
      
      insert o1;
      AccountId = o1.ccrz__Account__c;
      MapOrdero.put(o1.id,o1);
      orderlIst.add(o1);
      System.debug('---CC Order---'+o1);
      
      ccrz__E_Order__c o11 = new ccrz__E_Order__c (id = o1.id);
      o11.ccrz__OrderStatus__c = 'Order Submitted';
      o11.ccrz__OrderDate__c = system.today();
      update o11;
      MapOrdern.put(o1.id,o1);
      
      //Put CC Order data Into Map
      Map<Id,ccrz__E_Order__c> cor=new Map<Id,ccrz__E_Order__c>();
      cor.put(o1.id,o1); 
      set<id> ke=cor.keyset();
            
      List<ccrz__E_Product__c> listProd = TestingUtils.createEProduct(1, 'guidenz', 'Released', 1,'5678902-OHT11','SES',true);
        
      //CC OrderItem
      ccrz__E_OrderItem__c oi1 = new ccrz__E_OrderItem__c();
      oi1.ccrz__Price__c = 500;
      oi1.ccrz__OriginalItemPrice__c = 400;
      oi1.ccrz__Quantity__c = 1;
      oi1.ccrz__SubAmount__c = 123;
      oi1.ccrz__Order__c = o1.id;
      oi1.ccrz__Product__c = listProd[0].id;
      oi1.ccrz__Subscription_Auto_Renewal__c = true;
      oi1.ccrz__DisplayProduct__c = listProd[0].id;
      oi1.ccrz__PercentDiscount__c =8.33;  
      oi1.CurrencyIsoCode='USD';
      insert oi1;
      Set<Id> setOrdItemId = new Set<Id>();
      setOrdItemId.add(oi1.id);
      System.debug('---CC OrderItem---'+oi1); 
      
      ccrz__E_Subscription__c Sub=TestingUtils.createSubscription(accountList[0].id,listProd[0].id,o1.id,oi1.id,'Active',true);
        
      //Order Subscrciption Junction
      OSM_Order_Subscription__c osj = new OSM_Order_Subscription__c();
      osj.OSM_CCOrder__c = o1.id;
      osj.CC_Order_Item__c = oi1.id;
      //osj.CCProduct__c = pro.id;
      osj.CCQuantity__c = 1;
      osj.OSM_CCSubscription__c = Sub.id;
      osj.Billing_Frequency__c = 'Monthly';
      insert osj;
     
      List<ccrz__E_Invoice__c> invc= TestingUtils.createCCInvoices(1, o1.id, contacts[0].Id ,'Paid','SoftwareStore',false);
        List<ccrz__E_Invoice__c> listInvc= new List<ccrz__E_Invoice__c>();
        for(ccrz__E_Invoice__c invc1:invc){
        invc1.ccrz__BillAddress__c =conAddrs.id;
        invc1.CreditMemo_Number__c='I-0000001561C';
        invc1.OSM_SW_IsIntercompanyInvoice__c = true;
        listInvc.add(invc1);
        }
        insert listInvc;
        List<Id>Listinv = new List<Id>();
        Listinv.add(listInvc[0].id);
             
      List<ccrz__E_InvoiceItem__c> invitemList = new list<ccrz__E_InvoiceItem__c>();
      ccrz__E_InvoiceItem__c invitem = new ccrz__E_InvoiceItem__c();
      invitem.ccrz__Invoice__c = listInvc[0].id;
      invitem.ccrz__CCOrder__c = orderlIst[0].id;
      invitem.ccrz__CCOrderItem__c = oi1.id;
      invitem.ccrz__OriginalAmount__c = 10.0;
       invitem.Vertex_Tax__c = 3.0;
      invitem.CurrencyIsoCode = 'USD';
      invitem.OSM_Bypass_Flow__c=true;
      invitemList.add(invitem);
      insert invitemList;
      //Transaction payment
      ccrz__E_TransactionPayment__c  ctpayment = new ccrz__E_TransactionPayment__c();
      ctpayment.ccrz__AccountType__c = 'PO';
      ctpayment.Transaction_Status__c = 'Order Placed Success';
      ctpayment.ccrz__Storefront__c = 'SoftwareStore';
      ctpayment.ccrz__CCOrder__c = o1.id;
      ctpayment.ccrz__InvoiceAppliedTo__c = listInvc[0].id;
      ctpayment.Bolt_JE_Call_Status__c = 'Pending';
       ctpayment.Bolt_JE_Reversal_Call_Status__c = 'Pending';
      ctpayment.Bolt_JE_Reversal_Call_Status__c = 'Failure';
      ctpayment.Bolt_JE_Reversal_Call_Status__c = 'Success';
      ctpayment.Bolt_AR_Call_Status__c = 'Pending';
      ctpayment.Bolt_Credit_Memo_Call_Status__c = 'Pending';
      insert ctpayment;
      
      Map<Id,Id>mapCTPInvcid = new Map<Id,Id>();
      mapCTPInvcid.put(ctpayment.id,ctpayment.id);
      system.debug('@@@@@@'+mapCTPInvcid);
      boolean isProcess = true;
      
      OSM_Integration_Log__c objIntLog = new OSM_Integration_Log__c();
      objIntLog.Transaction_Payment__c = ctpayment.id;
      objIntLog.Unique_Message_Identifier__c ='testUniqueMessageIdentifier';
      objIntLog.Service_Name__c = 'Journal Entry';
      //objIntLog.Service_Name__c = 'JournalEntryReversal';
      objIntLog.Invoice__c = listInvc[0].id;
      insert objIntLog;
      Test.starttest();
      OSM_BOLT_SW_BusinessLayerHandler handler = new OSM_BOLT_SW_BusinessLayerHandler();
      OSM_BOLT_SW_BusinessLayerHandler.setARInvoiceOutboundWrapper(Listinv,mapCTPInvcid,'Order Cancel',null);
      OSM_BOLT_SW_BusinessLayerHandler.setJournalEntryWrapper(Listinv,mapCTPInvcid,'Order Cancel',null);
      OSM_BOLT_SW_BusinessLayerHandler.setARInvoiceOutboundWrapper(Listinv,mapCTPInvcid,'state',setOrdItemId);
      OSM_BOLT_SW_BusinessLayerHandler.setJournalEntryWrapper(Listinv,mapCTPInvcid,'state',setOrdItemId);
      OSM_SW_General_Util.getuserType(Userinfo.getUserId());
      System.assertNotEquals(null,Listinv,'Invoice not created.');
      System.assertEquals(true, listInvc[0].OSM_SW_IsIntercompanyInvoice__c);
      System.assertEquals('Journal Entry', objIntLog.Service_Name__c);
      System.assertNotEquals(null,ctpayment.ccrz__InvoiceAppliedTo__c,'Transaction payment invoice not Mapped'); 
      Test.stoptest();
  }
}