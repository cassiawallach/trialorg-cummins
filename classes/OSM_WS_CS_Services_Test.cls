/************************************************************
Name:  OSM_WS_CS_Services_Test
Copyright © 2018  Cummins
=============================================================
=============================================================
Purpose:                                                            
This is test class for OSM_WS_CS_Services class.                          
=============================================================
=============================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE              DETAIL                                
1.0 -   Mouilka G            07/04/2018     INITIAL DEVELOPMENT          

*************************************************************/
//Updated on 04/04/2022
@isTest
global class OSM_WS_CS_Services_Test{
    
    //For Product Interface Test
    public static testmethod void testProductCalloutPass() {
        
        CSS_Integration_Details__c csInt = new CSS_Integration_Details__c();
        csInt.name = 'COSM-Product';
        csInt.ApplicationName__c='GetProduct';
        csInt.End_Point__c='https://connectedsolutions-stg.cummins.com/appSubscriptionInternal/v1/subscription/products';
        csInt.IsActive__c=true;
        csInt.AuthEnv__c='DA';
        csInt.Method_Type__c='POST';
        csInt.Timeout__c=120000;
        insert csint;
        
        CSS_Integration_Details__c conDetails = new CSS_Integration_Details__c(); //Getting custom setting data
        conDetails.name = 'DA';
        conDetails.Key__c = 'appSubscription-api-key';
        conDetails.Passcode__c = 'OPJQg+I3X+t8OWbfMJexpQwIGiXRzXKROBieKx/jBlA=';
        insert conDetails;
        String json = '{'+
                        '   \"timeStamp\": \"2018-09-16T10:20:32.000Z\",'+
                        '   \"messageID\": \"DA_2018-09-16T10:20:32.000Z\",'+
                        '   \"initiator\": \"OSM\",'+
                        '   \"customerID\": \"390\"'+
                        '}';
        OSM_WS_GeneralizedInputWrapper objjj = OSM_WS_GeneralizedInputWrapper.parse(json);
        Test.StartTest();
        Test.setMock(HttpCalloutMock.class, new SingleRequestMockProductPass());
        OSM_WS_CS_Services.GetProductsWS(objjj);
        Test.Stoptest();
          
    }
    
    //For Product Interface Test
    public static testmethod void testProductCalloutFail() {
        
        CSS_Integration_Details__c csInt = new CSS_Integration_Details__c();
        csInt.name = 'COSM-Product';
        csInt.ApplicationName__c='GetProduct';
        csInt.End_Point__c='https://connectedsolutions-stg.cummins.com/appSubscriptionInternal/v1/subscription/products';
        csInt.AuthEnv__c='DA';
        csInt.IsActive__c=true;
        insert csint;
        
        CSS_Integration_Details__c conDetails = new CSS_Integration_Details__c(); //Getting custom setting data
        conDetails.name = 'DA';
        conDetails.Key__c = 'appSubscription-api-key';
        conDetails.Passcode__c = 'OPJQg+I3X+t8OWbfMJexpQwIGiXRzXKROBieKx/jBlA=';
        insert conDetails;
        
        
        String json = '{'+
                        '   \"timeStamp\": \"2018-09-16T10:20:32.000Z\",'+
                        '   \"messageID\": \"DA_2018-09-16T10:20:32.000Z\",'+
                        '   \"initiator\": \"OSM\",'+
                        '   \"customerID\": \"390000\"'+
                        '}';
        OSM_WS_GeneralizedInputWrapper objj = OSM_WS_GeneralizedInputWrapper.parse(json);
        Test.StartTest();
        Test.setMock(HttpCalloutMock.class, new SingleRequestMockProductFail());
        OSM_WS_CS_Services.GetProductsWS(objj);
        Test.Stoptest(); 
    }
    
    //For Product Interface Test
    global class SingleRequestMockProductPass implements HttpCalloutMock {
           
            global HTTPResponse respond(HTTPRequest req) {
                HttpResponse resp = new HttpResponse();
                resp.setStatusCode(200);
                //resp.setBody('{Status: null,Status Code: 401,Response Body: [{"errorCode":"AUTHERR-002","errorDescription":"Authentication Token has been rejected."}]}');
                resp.setBody('{"timeStamp":"2018-09-16T10:20:32.000Z","messageID":"DA_2018-09-16T10:20:32.000Z","initiator":"OSM","customerID":"390"}');
                return resp;
            }
    }   
    
    //For Product Interface Test
    global class SingleRequestMockProductFail implements HttpCalloutMock {
           
            global HTTPResponse respond(HTTPRequest req) {
                HttpResponse resp = new HttpResponse();
                resp.setStatusCode(400);
                resp.setBody('{Status: null,Status Code: 401,Response Body: [{"errorCode":"AUTHERR-002","errorDescription":"Authentication Token has been rejected."}]}');
                return resp;
            }
    }
    
    //For Cancellation Interface Test
    public static testmethod void testCancellationCalloutPass() {
        
        List<Id> productIdList = new List<Id>();
        String AccountId;
        Map<ID,ccrz__E_Order__c> MapOrdero= new Map<ID,ccrz__E_Order__c>();
        Map<ID,ccrz__E_Order__c> MapOrdern= new Map<ID,ccrz__E_Order__c>();
        List<ccrz__E_Order__c> orderlIst = new List<ccrz__E_Order__c>();

        //Account
        Account testaccount = new Account();
        testAccount.Name = 'testacc';
        testAccount.BillingStreet = 'Street';
        testAccount.BillingCity = 'City';
        testAccount.BillingState = '';
        testAccount.BOLT_Account_Number__c = '999';
        testAccount.BillingPostalCode = '11000';
        testAccount.BillingCountry = 'United States';
        testAccount.CMI_Region__c = 'India';
        testAccount.CSS_Locale__c = 'English(India)';
        // JUHI Changes - prevent hard coding of ID
        testAccount.RecordTypeId = OSM_TestDataCreationUtility.getAccountRecordTypeID();
        testAccount.OwnerId = OSM_TestDataCreationUtility.getSystemAdministratorID();
        
        //testAccount.RecordTypeId = '0124C000000Cimc';
        //testAccount.OwnerId = '0054C0000016Fe3';
        testAccount.CSS_Timezone__c = '(GMT+05:30) India Standard Time (Asia/Kolkata)';
        testAccount.CMI_CId__c = '390';
        insert testAccount;
        system.debug('testAccount'+testAccount);
            
        //CC Order
        ccrz__E_Order__c o1 = new ccrz__E_Order__c ();
        o1.ccrz__Storefront__c = 'SoftwareStore';
        o1.ccrz__Account__c = testAccount.Id;
        o1.ccrz__CurrencyISOCode__c = 'USD';
        //ol.ccrz__OrderStatus__c = 'Order Submitted';
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
        
        //CC Product        
        ccrz__E_Product__c parentpro = new ccrz__E_Product__c();
        parentpro.Name = 'CA Base-DEF';
        parentpro.ccrz__SKU__c = '5678901-DEF';
        parentpro.ccrz__Quantityperunit__c = 1;
        parentpro.Group_Name__c = 'DA';
        parentpro.Product_Class_Code__c = 'SW-Web Access';
        insert parentpro;
        productIdList.add(parentpro.id);
        System.debug('---CC Parent Product---'+parentpro);
        
        ccrz__E_Product__c pro = new ccrz__E_Product__c();
        pro.Name = 'CA Base-OHT';
        pro.ccrz__SKU__c = '5678902-OHT';
        pro.ccrz__Quantityperunit__c = 1;
        pro.Group_Name__c = 'DA';
        pro.ccrz__ParentProduct__c = parentpro.id;
        pro.Product_Class_Code__c = 'SW-Web Access';
        insert pro;
        productIdList.add(pro.id);
        System.debug('---CC Product---'+pro);
        
        //CC OrderItem
        ccrz__E_OrderItem__c oi1 = new ccrz__E_OrderItem__c();
        oi1.ccrz__Price__c = 500;
        oi1.ccrz__OriginalItemPrice__c = 400;
        oi1.ccrz__Quantity__c = 1;
        oi1.ccrz__SubAmount__c = 123;
        oi1.ccrz__Order__c = o1.id;
        oi1.ccrz__Product__c = pro.id;
        oi1.ccrz__Subscription_Auto_Renewal__c = true;
        oi1.ccrz__DisplayProduct__c = pro.id;
        insert oi1;
        System.debug('---CC OrderItem---'+oi1); 
        
        //CC Subscription
        ccrz__E_Subscription__c Sub=new ccrz__E_Subscription__c();
        Sub.ccrz__Sequence__c=3;
        Sub.ccrz__Storefront__c='SoftwareStore';
        Sub.ccrz__SubscriptionStartDate__c=System.now().adddays(-2);
        Sub.OSM_Subscription_End_Date__c=System.now().adddays(5);
        Sub.ccrz__SubscriptionStatus__c= 'Active';
        Sub.ccrz__InstallmentLastDate__c=System.now();
        Sub.ccrz__CCOrder__c=o1.Id;
        Sub.ccrz__CCOrderItem__c=oi1.Id;
        Sub.OSM_Free_Trial__c=false;
        Sub.ccrz__SubscriptionProduct__c=pro.Id;
        Sub.ccrz__RecurringPrice__c = 200;
        Sub.ccrz__OrderLastDate__c = System.now() + 10;
        Sub.ccrz__CurrencyISOCode__c = 'USD';
        Sub.ccrz__Quantity__c = 3;
        Sub.ccrz__Account__c = testAccount.id;
        Sub.Subsequent_Next_Invoice_Due_Dt__c = System.now() + 15;
        Sub.Subsequent_Next_Invoice_Generation_Dt__c = System.now() + 15;
        Insert Sub;
        System.debug('---CC Subscription---'+Sub);

        //Order Subscrciption Junction
        OSM_Order_Subscription__c osj = new OSM_Order_Subscription__c();
        osj.OSM_CCOrder__c = o1.id;
        osj.CC_Order_Item__c = oi1.id;
        //osj.CCProduct__c = pro.id;
        osj.CCQuantity__c = 1;
        osj.OSM_CCSubscription__c = Sub.id;
        osj.Billing_Frequency__c = 'Monthly';
        insert osj;
        
        //Invoice
        ccrz__E_Invoice__c invc = new ccrz__E_Invoice__c();
        invc.ccrz__CCOrder__c = o1.id;
        invc.ccrz__Status__c = 'Paid';
        invc.ccrz__Storefront__c = 'SoftwareStore';
        insert invc;
        
        //Transaction payment
        ccrz__E_TransactionPayment__c  ctpayment = new ccrz__E_TransactionPayment__c();
        ctpayment.ccrz__AccountType__c = 'po';
        ctpayment.Transaction_Status__c = 'Order Cancel Success';
        ctpayment.ccrz__Storefront__c = 'SoftwareStore';
        ctpayment.ccrz__CCOrder__c = o1.id;
        ctpayment.ccrz__InvoiceAppliedTo__c = invc.id;
        insert ctpayment;   
        
        ccrz__E_TransactionPayment__c ctpay = [Select ccrz__CCOrder__r.name from ccrz__E_TransactionPayment__c where id = :ctpayment.id];   
        String sname = ctpay.ccrz__CCOrder__r.name;
        system.debug('sname'+sname);
        
        CSS_Integration_Details__c csInt = new CSS_Integration_Details__c();
        csInt.name = 'GetCancel';
        csInt.ApplicationName__c='GetCancel';
        csInt.End_Point__c='https://connectedsolutions-dev.cummins.com/appSubscriptionInternal/v1/subscription/cancelSubscription';
        csInt.AuthEnv__c='DA';        
        csInt.Method_Type__c='POST';
        csInt.Timeout__c=120000;
        csInt.IsActive__c=true;
        insert csint;
        
        CSS_Integration_Details__c conDetails = new CSS_Integration_Details__c(); //Getting custom setting data
        conDetails.name = 'DA';
        conDetails.Key__c = 'appSubscription-api-key';
        conDetails.Passcode__c = 'OPJQg+I3X+t8OWbfMJexpQwIGiXRzXKROBieKx/jBlA=';
        insert conDetails;
        
        String json = '{'+
                    '   \"timeStamp\": \"2018-09-16T01:42:18.000Z\",'+
                    '   \"orderID\": \"O-0000101039\",'+
                    '   \"messageID\": \"DA_2018-09-16T01:42:18.000Z\",'+
                    '   \"initiator\": \"OSM\",'+
                    '   \"customerID\": \"390\",'+
                    '   \"cancelDate\": \"2018-09-16T01:42:18.000Z\"'+
                    '}';
        OSM_WS_GeneralizedInputWrapper obj = OSM_WS_GeneralizedInputWrapper.parse(json);
        
        Test.StartTest();
        Test.setMock(HttpCalloutMock.class, new SingleRequestMockCancelPass());
        OSM_WS_CS_Services.callGetCancellationWS(obj);
        Test.Stoptest();
          
    }
    
    //For Cancellation Interface Test
    public static testmethod void testCancellationCalloutFail() {

        List<Id> productIdList = new List<Id>();
        String AccountId;
        Map<ID,ccrz__E_Order__c> MapOrdero= new Map<ID,ccrz__E_Order__c>();
        Map<ID,ccrz__E_Order__c> MapOrdern= new Map<ID,ccrz__E_Order__c>();
        List<ccrz__E_Order__c> orderlIst = new List<ccrz__E_Order__c>();

        //Account
        Account testaccount = new Account();
        testAccount.Name = 'testacc';
        testAccount.BillingStreet = 'Street';
        testAccount.BillingCity = 'City';
        testAccount.BillingState = '';
        testAccount.BOLT_Account_Number__c = '999';
        testAccount.BillingPostalCode = '11000';
        testAccount.BillingCountry = 'United States';
        testAccount.CMI_Region__c = 'India';
        testAccount.CSS_Locale__c = 'English(India)';
        // JUHI Changes - prevent hard coding of ID
        testAccount.RecordTypeId = OSM_TestDataCreationUtility.getAccountRecordTypeID();
        testAccount.OwnerId = OSM_TestDataCreationUtility.getSystemAdministratorID();
        
        //testAccount.RecordTypeId = '0124C000000Cimc';
        //testAccount.OwnerId = '0054C0000016Fe3';
        testAccount.CSS_Timezone__c = '(GMT+05:30) India Standard Time (Asia/Kolkata)';
        testAccount.CMI_CId__c  = '390';
        insert testAccount;
        system.debug('testAccount'+testAccount);
            
        //CC Order
        ccrz__E_Order__c o1 = new ccrz__E_Order__c ();
        o1.ccrz__Storefront__c = 'SoftwareStore';
        o1.ccrz__Account__c = testAccount.Id;
        o1.ccrz__CurrencyISOCode__c = 'USD';
        //ol.ccrz__OrderStatus__c = 'Order Submitted';
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
        
        //CC Product        
        ccrz__E_Product__c parentpro = new ccrz__E_Product__c();
        parentpro.Name = 'CA Base-DEF';
        parentpro.ccrz__SKU__c = '5678901-DEF';
        parentpro.ccrz__Quantityperunit__c = 1;
        parentpro.Group_Name__c = 'DA';
        parentpro.Product_Class_Code__c = 'SW-Web Access';
        insert parentpro;
        productIdList.add(parentpro.id);
        System.debug('---CC Parent Product---'+parentpro);
        
        ccrz__E_Product__c pro = new ccrz__E_Product__c();
        pro.Name = 'CA Base-OHT';
        pro.ccrz__SKU__c = '5678902-OHT';
        pro.ccrz__Quantityperunit__c = 1;
        pro.Group_Name__c = 'DA';
        pro.ccrz__ParentProduct__c = parentpro.id;
        pro.Product_Class_Code__c = 'SW-Web Access';
        insert pro;
        productIdList.add(pro.id);
        System.debug('---CC Product---'+pro);
        
        //CC OrderItem
        ccrz__E_OrderItem__c oi1 = new ccrz__E_OrderItem__c();
        oi1.ccrz__Price__c = 500;
        oi1.ccrz__OriginalItemPrice__c = 400;
        oi1.ccrz__Quantity__c = 1;
        oi1.ccrz__SubAmount__c = 123;
        oi1.ccrz__Order__c = o1.id;
        oi1.ccrz__Product__c = pro.id;
        oi1.ccrz__Subscription_Auto_Renewal__c = true;
        oi1.ccrz__DisplayProduct__c = pro.id;
        insert oi1;
        System.debug('---CC OrderItem---'+oi1); 
        
        //CC Subscription
        ccrz__E_Subscription__c Sub=new ccrz__E_Subscription__c();
        Sub.ccrz__Sequence__c=3;
        Sub.ccrz__Storefront__c='SoftwareStore';
        Sub.ccrz__SubscriptionStartDate__c=System.now().adddays(-2);
        Sub.OSM_Subscription_End_Date__c=System.now().adddays(5);
        Sub.ccrz__SubscriptionStatus__c= 'Active';
        Sub.ccrz__InstallmentLastDate__c=System.now();
        Sub.ccrz__CCOrder__c=o1.Id;
        Sub.ccrz__CCOrderItem__c=oi1.Id;
        Sub.OSM_Free_Trial__c=false;
        Sub.ccrz__SubscriptionProduct__c=pro.Id;
        Sub.ccrz__RecurringPrice__c = 200;
        Sub.ccrz__OrderLastDate__c = System.now() + 10;
        Sub.ccrz__CurrencyISOCode__c = 'USD';
        Sub.ccrz__Quantity__c = 3;
        Sub.ccrz__Account__c = testAccount.id;
        Sub.Subsequent_Next_Invoice_Due_Dt__c = System.now() + 15;
        Sub.Subsequent_Next_Invoice_Generation_Dt__c = System.now() + 15;
        Insert Sub;
        System.debug('---CC Subscription---'+Sub);

        //Order Subscrciption Junction
        OSM_Order_Subscription__c osj = new OSM_Order_Subscription__c();
        osj.OSM_CCOrder__c = o1.id;
        osj.CC_Order_Item__c = oi1.id;
        //osj.CCProduct__c = pro.id;
        osj.CCQuantity__c = 1;
        osj.OSM_CCSubscription__c = Sub.id;
        osj.Billing_Frequency__c = 'Monthly';
        insert osj;
        
        //Invoice
        ccrz__E_Invoice__c invc = new ccrz__E_Invoice__c();
        invc.ccrz__CCOrder__c = o1.id;
        invc.ccrz__Status__c = 'Paid';
        invc.ccrz__Storefront__c = 'SoftwareStore';
        insert invc;
        
        //Transaction payment
        ccrz__E_TransactionPayment__c  ctpayment = new ccrz__E_TransactionPayment__c();
        ctpayment.ccrz__AccountType__c = 'po';
        ctpayment.Transaction_Status__c = 'Order Cancel Success';
        ctpayment.ccrz__Storefront__c = 'SoftwareStore';
        ctpayment.ccrz__CCOrder__c = o1.id;
        ctpayment.ccrz__InvoiceAppliedTo__c = invc.id;
        insert ctpayment;   
    
        ccrz__E_TransactionPayment__c ctpay = [Select ccrz__CCOrder__r.name from ccrz__E_TransactionPayment__c where id = :ctpayment.id];   
        String sname = ctpay.ccrz__CCOrder__r.name;
        system.debug('sname'+sname);
    
        CSS_Integration_Details__c csInt = new CSS_Integration_Details__c();
        csInt.name = 'GetCancel';
        csInt.ApplicationName__c='GetCancel';
        csInt.End_Point__c='https://connectedsolutions-dev.cummins.com/appSubscriptionInternal/v1/subscription/cancelSubscription';
        csInt.AuthEnv__c='DA';
        csInt.Method_Type__c='POST';
        csInt.Timeout__c=120000;
        csInt.IsActive__c=true;
        insert csint;
        
        CSS_Integration_Details__c conDetails = new CSS_Integration_Details__c(); //Getting custom setting data
        conDetails.name = 'DA';
        conDetails.Key__c = 'appSubscription-api-key';
        conDetails.Passcode__c = 'OPJQg+I3X+t8OWbfMJexpQwIGiXRzXKROBieKx/jBlA=';
        insert conDetails;
        
        String json = '{'+
                    '   \"timeStamp\": \"2018-09-16T01:42:18.000Z\",'+
                    '   \"orderID\": \"O-0000101039\",'+
                    '   \"messageID\": \"DA_2018-09-16T01:42:18.000Z\",'+
                    '   \"initiator\": \"OSM\",'+
                    '   \"customerID\": \"3900000\",'+
                    '   \"cancelDate\": \"2018-09-16T01:42:18.000Z\"'+
                    '}';
        OSM_WS_GeneralizedInputWrapper obj = OSM_WS_GeneralizedInputWrapper.parse(json);
        
        Test.StartTest();
        Test.setMock(HttpCalloutMock.class, new SingleRequestMockCancelFail());
        OSM_WS_CS_Services.callGetCancellationWS(obj);
        Test.Stoptest(); 
    }
    
    //For Cancellation Interface Test
    global class SingleRequestMockCancelPass implements HttpCalloutMock {
           
            global HTTPResponse respond(HTTPRequest req) {
                HttpResponse resp = new HttpResponse();
                resp.setStatusCode(200);
                resp.setBody('{"timeStamp":"2018-09-16T01:42:18.000Z","orderID":"O-0000101039","messageID":"DA_2018-09-16T01:42:18.000Z","initiator":"OSM","customerID":"390","cancelDate":"2018-09-16T01:42:18.000Z"}');
                return resp;
            }
    }   
    
    //For Cancellation Interface Test
    global class SingleRequestMockCancelFail implements HttpCalloutMock {
           
            global HTTPResponse respond(HTTPRequest req) {
                HttpResponse resp = new HttpResponse();
                resp.setStatusCode(400);
                resp.setBody('{"errorCode":"VALERR-001","errorDescription":"Invalid CustomerID","errorLocation":"customerInformationData"}');
                return resp;
            }
    }
    
    
    public static testmethod void testCancellationCalloutFailException() {

        List<Id> productIdList = new List<Id>();
        String AccountId;
        Map<ID,ccrz__E_Order__c> MapOrdero= new Map<ID,ccrz__E_Order__c>();
        Map<ID,ccrz__E_Order__c> MapOrdern= new Map<ID,ccrz__E_Order__c>();
        List<ccrz__E_Order__c> orderlIst = new List<ccrz__E_Order__c>();

        //Account
        Account testaccount = new Account();
        testAccount.Name = 'testacc';
        testAccount.BillingStreet = 'Street';
        testAccount.BillingCity = 'City';
        testAccount.BillingState = '';
        testAccount.BOLT_Account_Number__c = '999';
        testAccount.BillingPostalCode = '11000';
        testAccount.BillingCountry = 'United States';
        testAccount.CMI_Region__c = 'India';
        testAccount.CSS_Locale__c = 'English(India)';
        // JUHI Changes - prevent hard coding of ID
        testAccount.RecordTypeId = OSM_TestDataCreationUtility.getAccountRecordTypeID();
        testAccount.OwnerId = OSM_TestDataCreationUtility.getSystemAdministratorID();
        
        //testAccount.RecordTypeId = '0124C000000Cimc';
        //testAccount.OwnerId = '0054C0000016Fe3';
        testAccount.CSS_Timezone__c = '(GMT+05:30) India Standard Time (Asia/Kolkata)';
        testAccount.CMI_CId__c  = '390';
        insert testAccount;
        system.debug('testAccount'+testAccount);
            
        //CC Order
        ccrz__E_Order__c o1 = new ccrz__E_Order__c ();
        o1.ccrz__Storefront__c = 'SoftwareStore';
        o1.ccrz__Account__c = testAccount.Id;
        o1.ccrz__CurrencyISOCode__c = 'USD';
        //ol.ccrz__OrderStatus__c = 'Order Submitted';
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
        
        //CC Product        
        ccrz__E_Product__c parentpro = new ccrz__E_Product__c();
        parentpro.Name = 'CA Base-DEF';
        parentpro.ccrz__SKU__c = '5678901-DEF';
        parentpro.ccrz__Quantityperunit__c = 1;
        parentpro.Group_Name__c = 'DA';
        parentpro.Product_Class_Code__c = 'SW-Web Access';
        insert parentpro;
        productIdList.add(parentpro.id);
        System.debug('---CC Parent Product---'+parentpro);
        
        ccrz__E_Product__c pro = new ccrz__E_Product__c();
        pro.Name = 'CA Base-OHT';
        pro.ccrz__SKU__c = '5678902-OHT';
        pro.ccrz__Quantityperunit__c = 1;
        pro.Group_Name__c = 'DA';
        pro.ccrz__ParentProduct__c = parentpro.id;
        pro.Product_Class_Code__c = 'SW-Web Access';
        insert pro;
        productIdList.add(pro.id);
        System.debug('---CC Product---'+pro);
        
        //CC OrderItem
        ccrz__E_OrderItem__c oi1 = new ccrz__E_OrderItem__c();
        oi1.ccrz__Price__c = 500;
        oi1.ccrz__OriginalItemPrice__c = 400;
        oi1.ccrz__Quantity__c = 1;
        oi1.ccrz__SubAmount__c = 123;
        oi1.ccrz__Order__c = o1.id;
        oi1.ccrz__Product__c = pro.id;
        oi1.ccrz__Subscription_Auto_Renewal__c = true;
        oi1.ccrz__DisplayProduct__c = pro.id;
        insert oi1;
        System.debug('---CC OrderItem---'+oi1); 
        
        //CC Subscription
        ccrz__E_Subscription__c Sub=new ccrz__E_Subscription__c();
        Sub.ccrz__Sequence__c=3;
        Sub.ccrz__Storefront__c='SoftwareStore';
        Sub.ccrz__SubscriptionStartDate__c=System.now().adddays(-2);
        Sub.OSM_Subscription_End_Date__c=System.now().adddays(5);
        Sub.ccrz__SubscriptionStatus__c= 'Active';
        Sub.ccrz__InstallmentLastDate__c=System.now();
        Sub.ccrz__CCOrder__c=o1.Id;
        Sub.ccrz__CCOrderItem__c=oi1.Id;
        Sub.OSM_Free_Trial__c=false;
        Sub.ccrz__SubscriptionProduct__c=pro.Id;
        Sub.ccrz__RecurringPrice__c = 200;
        Sub.ccrz__OrderLastDate__c = System.now() + 10;
        Sub.ccrz__CurrencyISOCode__c = 'USD';
        Sub.ccrz__Quantity__c = 3;
        Sub.ccrz__Account__c = testAccount.id;
        Sub.Subsequent_Next_Invoice_Due_Dt__c = System.now() + 15;
        Sub.Subsequent_Next_Invoice_Generation_Dt__c = System.now() + 15;
        Insert Sub;
        System.debug('---CC Subscription---'+Sub);

        //Order Subscrciption Junction
        OSM_Order_Subscription__c osj = new OSM_Order_Subscription__c();
        osj.OSM_CCOrder__c = o1.id;
        osj.CC_Order_Item__c = oi1.id;
        //osj.CCProduct__c = pro.id;
        osj.CCQuantity__c = 1;
        osj.OSM_CCSubscription__c = Sub.id;
        osj.Billing_Frequency__c = 'Monthly';
        insert osj;
        
        //Invoice
        ccrz__E_Invoice__c invc = new ccrz__E_Invoice__c();
        invc.ccrz__CCOrder__c = o1.id;
        invc.ccrz__Status__c = 'Paid';
        invc.ccrz__Storefront__c = 'SoftwareStore';
        insert invc;
        
        //Transaction payment
        ccrz__E_TransactionPayment__c  ctpayment = new ccrz__E_TransactionPayment__c();
        ctpayment.ccrz__AccountType__c = 'po';
        ctpayment.Transaction_Status__c = 'Order Cancel Success';
        ctpayment.ccrz__Storefront__c = 'SoftwareStore';
        ctpayment.ccrz__CCOrder__c = o1.id;
        ctpayment.ccrz__InvoiceAppliedTo__c = invc.id;
        insert ctpayment;   
    
        ccrz__E_TransactionPayment__c ctpay = [Select ccrz__CCOrder__r.name from ccrz__E_TransactionPayment__c where id = :ctpayment.id];   
        String sname = ctpay.ccrz__CCOrder__r.name;
        system.debug('sname'+sname);
    
        CSS_Integration_Details__c csInt = new CSS_Integration_Details__c();
        csInt.name = 'GetCancel';
        csInt.ApplicationName__c='GetCancel';
        //csInt.End_Point__c='https://connectedsolutions-dev.cummins.com/appSubscriptionInternal/v1/subscription/cancelSubscription';
        csInt.AuthEnv__c='DA';
        csInt.Method_Type__c='POST';
        csInt.Timeout__c=120000;
        csInt.IsActive__c=true;
        insert csint;
        
        CSS_Integration_Details__c conDetails = new CSS_Integration_Details__c(); //Getting custom setting data
        conDetails.name = 'DA';
        conDetails.Key__c = 'appSubscription-api-key';
        conDetails.Passcode__c = 'OPJQg+I3X+t8OWbfMJexpQwIGiXRzXKROBieKx/jBlA=';
        insert conDetails;
        
        String json = '{'+
                    '   \"timeStamp\": \"2018-09-16T01:42:18.000Z\",'+
                    '   \"orderID\": \"O-0000101039\",'+
                    '   \"messageID\": \"DA_2018-09-16T01:42:18.000Z\",'+
                    '   \"initiator\": \"OSM\",'+
                    '   \"customerID\": \"3900000\",'+
                    '   \"cancelDate\": \"2018-09-16T01:42:18.000Z\"'+
                    '}';
        OSM_WS_GeneralizedInputWrapper obj = OSM_WS_GeneralizedInputWrapper.parse(json);
        
        Test.StartTest();
        Test.setMock(HttpCalloutMock.class, new SingleRequestMockCancelFailExp());
        OSM_WS_CS_Services.callGetCancellationWS(obj);
        Test.Stoptest(); 
    }
    
    //For Cancellation Interface Test
    global class SingleRequestMockCancelPassExp implements HttpCalloutMock {
           
            global HTTPResponse respond(HTTPRequest req) {
                HttpResponse resp = new HttpResponse();
                resp.setStatusCode(200);
                resp.setBody('{"timeStamp":"2018-09-16T01:42:18.000Z","orderID":"O-0000101039","messageID":"DA_2018-09-16T01:42:18.000Z","initiator":"OSM","customerID":"390","cancelDate":"2018-09-16T01:42:18.000Z"}');
                return resp;
            }
    }   
    
    //For Cancellation Interface Test
    global class SingleRequestMockCancelFailExp implements HttpCalloutMock {
           
            global HTTPResponse respond(HTTPRequest req) {
                HttpResponse resp = new HttpResponse();
                resp.setStatusCode(400);
                resp.setBody('{"errorCode":"VALERR-001","errorDescription":"Invalid CustomerID","errorLocation":"customerInformationData"}');
                return resp;
            }
    }
    
    
    
    //For Order Interface Test
    public static testmethod void testOrderCalloutPass() {
    
        List<Id> productIdList = new List<Id>();
        String AccountId;
        Map<ID,ccrz__E_Order__c> MapOrdero= new Map<ID,ccrz__E_Order__c>();
        Map<ID,ccrz__E_Order__c> MapOrdern= new Map<ID,ccrz__E_Order__c>();
        List<ccrz__E_Order__c> orderlIst = new List<ccrz__E_Order__c>();

        //Account
        Account testaccount = new Account();
        testAccount.Name = 'testacc';
        testAccount.BillingStreet = 'Street';
        testAccount.BillingCity = 'City';
        testAccount.BillingState = '';
        testAccount.BOLT_Account_Number__c = '999';
        testAccount.BillingPostalCode = '11000';
        testAccount.BillingCountry = 'United States';
        testAccount.CMI_Region__c = 'India';
        testAccount.CSS_Locale__c = 'English(India)';
        // JUHI Changes - prevent hard coding of ID
        testAccount.RecordTypeId = OSM_TestDataCreationUtility.getAccountRecordTypeID();
        testAccount.OwnerId = OSM_TestDataCreationUtility.getSystemAdministratorID();
        
        //testAccount.RecordTypeId = '0124C000000Cimc';
        //testAccount.OwnerId = '0054C0000016Fe3';
        testAccount.CSS_Timezone__c = '(GMT+05:30) India Standard Time (Asia/Kolkata)';
        testAccount.CMI_CId__c = '390';
        insert testAccount;
        system.debug('testAccount'+testAccount);
            
        //CC Order
        ccrz__E_Order__c o1 = new ccrz__E_Order__c ();
        o1.ccrz__Storefront__c = 'SoftwareStore';
        o1.ccrz__Account__c = testAccount.Id;
        o1.ccrz__CurrencyISOCode__c = 'USD';
        //ol.ccrz__OrderStatus__c = 'Order Submitted';
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
        
        //CC Product        
        ccrz__E_Product__c parentpro = new ccrz__E_Product__c();
        parentpro.Name = 'CA Base-DEF';
        parentpro.ccrz__SKU__c = '5678901-DEF';
        parentpro.ccrz__Quantityperunit__c = 1;
        parentpro.Group_Name__c = 'DA';
        parentpro.Product_Class_Code__c = 'SW-Web Access';
        insert parentpro;
        productIdList.add(parentpro.id);
        System.debug('---CC Parent Product---'+parentpro);
        
        ccrz__E_Product__c pro = new ccrz__E_Product__c();
        pro.Name = 'CA Base-OHT';
        pro.ccrz__SKU__c = '5678902-OHT';
        pro.ccrz__Quantityperunit__c = 1;
        pro.Group_Name__c = 'DA';
        pro.ccrz__ParentProduct__c = parentpro.id;
        pro.Product_Class_Code__c = 'SW-Web Access';
        insert pro;
        productIdList.add(pro.id);
        System.debug('---CC Product---'+pro);
        
        //CC OrderItem
        ccrz__E_OrderItem__c oi1 = new ccrz__E_OrderItem__c();
        oi1.ccrz__Price__c = 500;
        oi1.ccrz__OriginalItemPrice__c = 400;
        oi1.ccrz__Quantity__c = 1;
        oi1.ccrz__SubAmount__c = 123;
        oi1.ccrz__Order__c = o1.id;
        oi1.ccrz__Product__c = pro.id;
        oi1.ccrz__Subscription_Auto_Renewal__c = true;
        oi1.ccrz__DisplayProduct__c = pro.id;
        insert oi1;
        System.debug('---CC OrderItem---'+oi1); 
        
        //CC Subscription
        ccrz__E_Subscription__c Sub=new ccrz__E_Subscription__c();
        Sub.ccrz__Sequence__c=3;
        Sub.ccrz__Storefront__c='SoftwareStore';
        Sub.ccrz__SubscriptionStartDate__c=System.now().adddays(-2);
        Sub.OSM_Subscription_End_Date__c=System.now().adddays(5);
        Sub.ccrz__SubscriptionStatus__c= 'Active';
        Sub.ccrz__InstallmentLastDate__c=System.now();
        Sub.ccrz__CCOrder__c=o1.Id;
        Sub.ccrz__CCOrderItem__c=oi1.Id;
        Sub.OSM_Free_Trial__c=false;
        Sub.ccrz__SubscriptionProduct__c=pro.Id;
        Sub.ccrz__RecurringPrice__c = 200;
        Sub.ccrz__OrderLastDate__c = System.now() + 10;
        Sub.ccrz__CurrencyISOCode__c = 'USD';
        Sub.ccrz__Quantity__c = 3;
        Sub.ccrz__Account__c = testAccount.id;
        Sub.Subsequent_Next_Invoice_Due_Dt__c = System.now() + 15;
        Sub.Subsequent_Next_Invoice_Generation_Dt__c = System.now() + 15;
        Insert Sub;
        System.debug('---CC Subscription---'+Sub);

        //Order Subscrciption Junction
        OSM_Order_Subscription__c osj = new OSM_Order_Subscription__c();
        osj.OSM_CCOrder__c = o1.id;
        osj.CC_Order_Item__c = oi1.id;
        //osj.CCProduct__c = pro.id;
        osj.CCQuantity__c = 1;
        osj.OSM_CCSubscription__c = Sub.id;
        osj.Billing_Frequency__c = 'Monthly';
        insert osj;
        
        //Invoice
        ccrz__E_Invoice__c invc = new ccrz__E_Invoice__c();
        invc.ccrz__CCOrder__c = o1.id;
        invc.ccrz__Status__c = 'Paid';
        invc.ccrz__Storefront__c = 'SoftwareStore';
        insert invc;
        
        //Transaction payment
        ccrz__E_TransactionPayment__c  ctpayment = new ccrz__E_TransactionPayment__c();
        ctpayment.ccrz__AccountType__c = 'po';
        ctpayment.Transaction_Status__c = 'Order Placed Success';
        ctpayment.ccrz__Storefront__c = 'SoftwareStore';
        ctpayment.ccrz__CCOrder__c = o1.id;
        ctpayment.ccrz__InvoiceAppliedTo__c = invc.id;
        insert ctpayment;   
        
        ccrz__E_TransactionPayment__c ctpay = [Select ccrz__CCOrder__r.name from ccrz__E_TransactionPayment__c where id = :ctpayment.id];   
        String sname = ctpay.ccrz__CCOrder__r.name;
        system.debug('sname'+sname);
    
    
        CSS_Integration_Details__c csInt = new CSS_Integration_Details__c();
        csInt.name = 'GetOrder';
        csInt.ApplicationName__c='GetOrder';
        csInt.End_Point__c='https://connectedsolutions-dev.cummins.com/appSubscriptionInternal/v1/subscription/orderUpdates';
        csInt.AuthEnv__c='DA';
        csInt.Method_Type__c='POST';
        csInt.Timeout__c=120000;
        csInt.IsActive__c=true;
        insert csint;
        
        CSS_Integration_Details__c conDetails = new CSS_Integration_Details__c(); //Getting custom setting data
        conDetails.name = 'DA';
        conDetails.Key__c = 'appSubscription-api-key';
        conDetails.Passcode__c = 'OPJQg+I3X+t8OWbfMJexpQwIGiXRzXKROBieKx/jBlA=';
        insert conDetails;
        
        
        String json = '{'+
                    '   \"timeStamp\": \"2018-09-16T09:44:36.000Z\",'+
                    '   \"orderLineItems\": ['+
                    '      {'+
                    '         \"subscriptionType\": \"New\",'+
                    '         \"subscriptionQuantity\": 2,'+
                    '         \"startDate\": \"2018-09-16T09:43:02.000Z\",'+
                    '         \"productID\": \"5678901\",'+
                    '         \"pricePerUnit\": 40,'+
                    '         \"freeTrial\": \"No\",'+
                    '         \"expirationDate\": \"2019-09-15T09:43:02.000Z\",'+
                    '         \"equipmentGroups\": null,'+
                    '         \"currencyType\": \"USD\"'+
                    '      }'+
                    '   ],'+
                    '   \"orderId\": \"O-0000101039\",'+
                    '   \"nextInvoiceDate\": \"2018-10-08T09:32:00.000Z\",'+
                    '   \"messageID\": \"DA_2018-09-16T09:44:36.000Z\",'+
                    '   \"initiator\": \"OSM\",'+
                    '   \"customerId\": \"390\",'+
                    '   \"createdDate\": \"2018-09-16T09:44:30.000Z\"'+
                    '}';
        OSM_WS_GeneralizedInputWrapper obj = OSM_WS_GeneralizedInputWrapper.parse(json);
        
        Test.StartTest();
        Test.setMock(HttpCalloutMock.class, new SingleRequestMockOrderPass());
        OSM_WS_CS_Services.callGetOrderWS(obj);
        Test.Stoptest();
          
    }
    
    //For Order Interface Test
    public static testmethod void testOrderCalloutFail() {
        
        List<Id> productIdList = new List<Id>();
        String AccountId;
        Map<ID,ccrz__E_Order__c> MapOrdero= new Map<ID,ccrz__E_Order__c>();
        Map<ID,ccrz__E_Order__c> MapOrdern= new Map<ID,ccrz__E_Order__c>();
        List<ccrz__E_Order__c> orderlIst = new List<ccrz__E_Order__c>();

        //Account
        Account testaccount = new Account();
        testAccount.Name = 'testacc';
        testAccount.BillingStreet = 'Street';
        testAccount.BillingCity = 'City';
        testAccount.BillingState = '';
        testAccount.BOLT_Account_Number__c = '999';
        testAccount.BillingPostalCode = '11000';
        testAccount.BillingCountry = 'United States';
        testAccount.CMI_Region__c = 'India';
        testAccount.CSS_Locale__c = 'English(India)';
        // JUHI Changes - prevent hard coding of ID
        testAccount.RecordTypeId = OSM_TestDataCreationUtility.getAccountRecordTypeID();
        testAccount.OwnerId = OSM_TestDataCreationUtility.getSystemAdministratorID();
        
        //testAccount.RecordTypeId = '0124C000000Cimc';
        //testAccount.OwnerId = '0054C0000016Fe3';
        testAccount.CSS_Timezone__c = '(GMT+05:30) India Standard Time (Asia/Kolkata)';
        testAccount.CMI_CId__c = '390';
        insert testAccount;
        system.debug('testAccount'+testAccount);
            
        //CC Order
        ccrz__E_Order__c o1 = new ccrz__E_Order__c ();
        o1.ccrz__Storefront__c = 'SoftwareStore';
        o1.ccrz__Account__c = testAccount.Id;
        o1.ccrz__CurrencyISOCode__c = 'USD';
        //ol.ccrz__OrderStatus__c = 'Order Submitted';
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
        
        //CC Product        
        ccrz__E_Product__c parentpro = new ccrz__E_Product__c();
        parentpro.Name = 'CA Base-DEF';
        parentpro.ccrz__SKU__c = '5678901-DEF';
        parentpro.ccrz__Quantityperunit__c = 1;
        parentpro.Group_Name__c = 'DA';
        parentpro.Product_Class_Code__c = 'SW-Web Access';
        insert parentpro;
        productIdList.add(parentpro.id);
        System.debug('---CC Parent Product---'+parentpro);
        
        ccrz__E_Product__c pro = new ccrz__E_Product__c();
        pro.Name = 'CA Base-OHT';
        pro.ccrz__SKU__c = '5678902-OHT';
        pro.ccrz__Quantityperunit__c = 1;
        pro.Group_Name__c = 'DA';
        pro.ccrz__ParentProduct__c = parentpro.id;
        pro.Product_Class_Code__c = 'SW-Web Access';
        insert pro;
        productIdList.add(pro.id);
        System.debug('---CC Product---'+pro);
        
        //CC OrderItem
        ccrz__E_OrderItem__c oi1 = new ccrz__E_OrderItem__c();
        oi1.ccrz__Price__c = 500;
        oi1.ccrz__OriginalItemPrice__c = 400;
        oi1.ccrz__Quantity__c = 1;
        oi1.ccrz__SubAmount__c = 123;
        oi1.ccrz__Order__c = o1.id;
        oi1.ccrz__Product__c = pro.id;
        oi1.ccrz__Subscription_Auto_Renewal__c = true;
        oi1.ccrz__DisplayProduct__c = pro.id;
        insert oi1;
        System.debug('---CC OrderItem---'+oi1); 
        
        //CC Subscription
        ccrz__E_Subscription__c Sub=new ccrz__E_Subscription__c();
        Sub.ccrz__Sequence__c=3;
        Sub.ccrz__Storefront__c='SoftwareStore';
        Sub.ccrz__SubscriptionStartDate__c=System.now().adddays(-2);
        Sub.OSM_Subscription_End_Date__c=System.now().adddays(5);
        Sub.ccrz__SubscriptionStatus__c= 'Active';
        Sub.ccrz__InstallmentLastDate__c=System.now();
        Sub.ccrz__CCOrder__c=o1.Id;
        Sub.ccrz__CCOrderItem__c=oi1.Id;
        Sub.OSM_Free_Trial__c=false;
        Sub.ccrz__SubscriptionProduct__c=pro.Id;
        Sub.ccrz__RecurringPrice__c = 200;
        Sub.ccrz__OrderLastDate__c = System.now() + 10;
        Sub.ccrz__CurrencyISOCode__c = 'USD';
        Sub.ccrz__Quantity__c = 3;
        Sub.ccrz__Account__c = testAccount.id;
        Sub.Subsequent_Next_Invoice_Due_Dt__c = System.now() + 15;
        Sub.Subsequent_Next_Invoice_Generation_Dt__c = System.now() + 15;
        Insert Sub;
        System.debug('---CC Subscription---'+Sub);

        //Order Subscrciption Junction
        OSM_Order_Subscription__c osj = new OSM_Order_Subscription__c();
        osj.OSM_CCOrder__c = o1.id;
        osj.CC_Order_Item__c = oi1.id;
        //osj.CCProduct__c = pro.id;
        osj.CCQuantity__c = 1;
        osj.OSM_CCSubscription__c = Sub.id;
        osj.Billing_Frequency__c = 'Monthly';
        insert osj;
        
        //Invoice
        ccrz__E_Invoice__c invc = new ccrz__E_Invoice__c();
        invc.ccrz__CCOrder__c = o1.id;
        invc.ccrz__Status__c = 'Paid';
        invc.ccrz__Storefront__c = 'SoftwareStore';
        insert invc;
        
        //Transaction payment
        ccrz__E_TransactionPayment__c  ctpayment = new ccrz__E_TransactionPayment__c();
        ctpayment.ccrz__AccountType__c = 'po';
        ctpayment.Transaction_Status__c = 'Order Placed Success';
        ctpayment.ccrz__Storefront__c = 'SoftwareStore';
        ctpayment.ccrz__CCOrder__c = o1.id;
        ctpayment.ccrz__InvoiceAppliedTo__c = invc.id;
        insert ctpayment;   
        
        ccrz__E_TransactionPayment__c ctpay = [Select ccrz__CCOrder__r.name from ccrz__E_TransactionPayment__c where id = :ctpayment.id];   
        String sname = ctpay.ccrz__CCOrder__r.name;
        system.debug('sname'+sname);
        
        CSS_Integration_Details__c csInt = new CSS_Integration_Details__c();
        csInt.name = 'GetOrder';
        csInt.ApplicationName__c='GetOrder';
        csInt.End_Point__c='https://connectedsolutions-dev.cummins.com/appSubscriptionInternal/v1/subscription/orderUpdates';
        csInt.AuthEnv__c='DA';
        csInt.Method_Type__c='POST';
        csInt.Timeout__c=120000;
        csInt.IsActive__c=true;
        insert csint;
        
        CSS_Integration_Details__c conDetails = new CSS_Integration_Details__c(); //Getting custom setting data
        conDetails.name = 'DA';
        conDetails.Key__c = 'appSubscription-api-key';
        conDetails.Passcode__c = 'OPJQg+I3X+t8OWbfMJexpQwIGiXRzXKROBieKx/jBlA=';
        insert conDetails;
        
        String json = '{'+
                    '   \"timeStamp\": \"2018-09-16T09:44:36.000Z\",'+
                    '   \"orderLineItems\": ['+
                    '      {'+
                    '         \"subscriptionType\": \"New\",'+
                    '         \"subscriptionQuantity\": 2,'+
                    '         \"startDate\": \"2018-09-16T09:43:02.000Z\",'+
                    '         \"productID\": \"5678901\",'+
                    '         \"pricePerUnit\": 40,'+
                    '         \"freeTrial\": \"No\",'+
                    '         \"expirationDate\": \"2019-09-15T09:43:02.000Z\",'+
                    '         \"equipmentGroups\": null,'+
                    '         \"currencyType\": \"USD\"'+
                    '      }'+
                    '   ],'+
                    '   \"orderId\": \"O-0000101039\",'+
                    '   \"nextInvoiceDate\": \"2018-10-08T09:32:00.000Z\",'+
                    '   \"messageID\": \"DA_2018-09-16T09:44:36.000Z\",'+
                    '   \"initiator\": \"OSM\",'+
                    '   \"customerId\": \"390\",'+
                    '   \"createdDate\": \"2018-09-16T09:44:30.000Z\"'+
                    '}';
        OSM_WS_GeneralizedInputWrapper obj = OSM_WS_GeneralizedInputWrapper.parse(json);
        
        Test.StartTest();
        Test.setMock(HttpCalloutMock.class, new SingleRequestMockOrderFail());
        OSM_WS_CS_Services.callGetOrderWS(obj);
        Test.Stoptest(); 
    }
    
    //For Order Interface Test
    global class SingleRequestMockOrderPass implements HttpCalloutMock {
           
            global HTTPResponse respond(HTTPRequest req) {
                HttpResponse resp = new HttpResponse();
                resp.setStatusCode(200);
                resp.setBody('{"timeStamp":"2018-09-16T09:44:36.000Z","orderLineItems":[{"subscriptionType":"New","subscriptionQuantity":2,"startDate":"2018-09-16T09:43:02.000Z","productID":"5678901","pricePerUnit":40.0,"freeTrial":"No","expirationDate":"2019-09-15T09:43:02.000Z","equipmentGroups":null,"currencyType":"USD"}],"orderId":"O-0000101039","nextInvoiceDate":"2018-10-08T09:32:00.000Z","messageID":"DA_2018-09-16T09:44:36.000Z","initiator":"OSM","customerId":"390","createdDate":"2018-09-16T09:44:30.000Z"}');
                return resp;
            }
    }   
    
    //For Order Interface Test
    global class SingleRequestMockOrderFail implements HttpCalloutMock {
           
            global HTTPResponse respond(HTTPRequest req) {
                HttpResponse resp = new HttpResponse();
                resp.setStatusCode(400);
                resp.setBody('{"errorCode":"VALERR-001","errorDescription":"Invalid CustomerID","errorLocation":"customerInformationData"}');
                return resp;
            }
    }
    
    
    public static testmethod void testOrderCalloutFailException() {
        
        List<Id> productIdList = new List<Id>();
        String AccountId;
        Map<ID,ccrz__E_Order__c> MapOrdero= new Map<ID,ccrz__E_Order__c>();
        Map<ID,ccrz__E_Order__c> MapOrdern= new Map<ID,ccrz__E_Order__c>();
        List<ccrz__E_Order__c> orderlIst = new List<ccrz__E_Order__c>();

        //Account
        Account testaccount = new Account();
        testAccount.Name = 'testacc';
        testAccount.BillingStreet = 'Street';
        testAccount.BillingCity = 'City';
        testAccount.BillingState = '';
        testAccount.BOLT_Account_Number__c = '999';
        testAccount.BillingPostalCode = '11000';
        testAccount.BillingCountry = 'United States';
        testAccount.CMI_Region__c = 'India';
        testAccount.CSS_Locale__c = 'English(India)';
        // JUHI Changes - prevent hard coding of ID
        testAccount.RecordTypeId = OSM_TestDataCreationUtility.getAccountRecordTypeID();
        testAccount.OwnerId = OSM_TestDataCreationUtility.getSystemAdministratorID();
        
        //testAccount.RecordTypeId = '0124C000000Cimc';
        //testAccount.OwnerId = '0054C0000016Fe3';
        testAccount.CSS_Timezone__c = '(GMT+05:30) India Standard Time (Asia/Kolkata)';
        testAccount.CMI_CId__c = '390';
        insert testAccount;
        system.debug('testAccount'+testAccount);
            
        //CC Order
        ccrz__E_Order__c o1 = new ccrz__E_Order__c ();
        o1.ccrz__Storefront__c = 'SoftwareStore';
        o1.ccrz__Account__c = testAccount.Id;
        o1.ccrz__CurrencyISOCode__c = 'USD';
        //ol.ccrz__OrderStatus__c = 'Order Submitted';
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
        
        //CC Product        
        ccrz__E_Product__c parentpro = new ccrz__E_Product__c();
        parentpro.Name = 'CA Base-DEF';
        parentpro.ccrz__SKU__c = '5678901-DEF';
        parentpro.ccrz__Quantityperunit__c = 1;
        parentpro.Group_Name__c = 'DA';
        parentpro.Product_Class_Code__c = 'SW-Web Access';
        insert parentpro;
        productIdList.add(parentpro.id);
        System.debug('---CC Parent Product---'+parentpro);
        
        ccrz__E_Product__c pro = new ccrz__E_Product__c();
        pro.Name = 'CA Base-OHT';
        pro.ccrz__SKU__c = '5678902-OHT';
        pro.ccrz__Quantityperunit__c = 1;
        pro.Group_Name__c = 'DA';
        pro.ccrz__ParentProduct__c = parentpro.id;
        pro.Product_Class_Code__c = 'SW-Web Access';
        insert pro;
        productIdList.add(pro.id);
        System.debug('---CC Product---'+pro);
        
        //CC OrderItem
        ccrz__E_OrderItem__c oi1 = new ccrz__E_OrderItem__c();
        oi1.ccrz__Price__c = 500;
        oi1.ccrz__OriginalItemPrice__c = 400;
        oi1.ccrz__Quantity__c = 1;
        oi1.ccrz__SubAmount__c = 123;
        oi1.ccrz__Order__c = o1.id;
        oi1.ccrz__Product__c = pro.id;
        oi1.ccrz__Subscription_Auto_Renewal__c = true;
        oi1.ccrz__DisplayProduct__c = pro.id;
        insert oi1;
        System.debug('---CC OrderItem---'+oi1); 
        
        //CC Subscription
        ccrz__E_Subscription__c Sub=new ccrz__E_Subscription__c();
        Sub.ccrz__Sequence__c=3;
        Sub.ccrz__Storefront__c='SoftwareStore';
        Sub.ccrz__SubscriptionStartDate__c=System.now().adddays(-2);
        Sub.OSM_Subscription_End_Date__c=System.now().adddays(5);
        Sub.ccrz__SubscriptionStatus__c= 'Active';
        Sub.ccrz__InstallmentLastDate__c=System.now();
        Sub.ccrz__CCOrder__c=o1.Id;
        Sub.ccrz__CCOrderItem__c=oi1.Id;
        Sub.OSM_Free_Trial__c=false;
        Sub.ccrz__SubscriptionProduct__c=pro.Id;
        Sub.ccrz__RecurringPrice__c = 200;
        Sub.ccrz__OrderLastDate__c = System.now() + 10;
        Sub.ccrz__CurrencyISOCode__c = 'USD';
        Sub.ccrz__Quantity__c = 3;
        Sub.ccrz__Account__c = testAccount.id;
        Sub.Subsequent_Next_Invoice_Due_Dt__c = System.now() + 15;
        Sub.Subsequent_Next_Invoice_Generation_Dt__c = System.now() + 15;
        Insert Sub;
        System.debug('---CC Subscription---'+Sub);

        //Order Subscrciption Junction
        OSM_Order_Subscription__c osj = new OSM_Order_Subscription__c();
        osj.OSM_CCOrder__c = o1.id;
        osj.CC_Order_Item__c = oi1.id;
        //osj.CCProduct__c = pro.id;
        osj.CCQuantity__c = 1;
        osj.OSM_CCSubscription__c = Sub.id;
        osj.Billing_Frequency__c = 'Monthly';
        insert osj;
        
        //Invoice
        ccrz__E_Invoice__c invc = new ccrz__E_Invoice__c();
        invc.ccrz__CCOrder__c = o1.id;
        invc.ccrz__Status__c = 'Paid';
        invc.ccrz__Storefront__c = 'SoftwareStore';
        insert invc;
        
        //Transaction payment
        ccrz__E_TransactionPayment__c  ctpayment = new ccrz__E_TransactionPayment__c();
        ctpayment.ccrz__AccountType__c = 'po';
        ctpayment.Transaction_Status__c = 'Order Placed Success';
        ctpayment.ccrz__Storefront__c = 'SoftwareStore';
        ctpayment.ccrz__CCOrder__c = o1.id;
        ctpayment.ccrz__InvoiceAppliedTo__c = invc.id;
        insert ctpayment;   
        
        ccrz__E_TransactionPayment__c ctpay = [Select ccrz__CCOrder__r.name from ccrz__E_TransactionPayment__c where id = :ctpayment.id];   
        String sname = ctpay.ccrz__CCOrder__r.name;
        system.debug('sname'+sname);
        
        CSS_Integration_Details__c csInt = new CSS_Integration_Details__c();
        csInt.name = 'GetOrder';
        csInt.ApplicationName__c='GetOrder';
        //csInt.End_Point__c='https://connectedsolutions-dev.cummins.com/appSubscriptionInternal/v1/subscription/orderUpdates';
        csInt.AuthEnv__c='DA';
        csInt.Method_Type__c='POST';
        csInt.Timeout__c=120000;
        csInt.IsActive__c=true;
        insert csint;
        
        CSS_Integration_Details__c conDetails = new CSS_Integration_Details__c(); //Getting custom setting data
        conDetails.name = 'DA';
        conDetails.Key__c = 'appSubscription-api-key';
        conDetails.Passcode__c = 'OPJQg+I3X+t8OWbfMJexpQwIGiXRzXKROBieKx/jBlA=';
        insert conDetails;
        
        String json = '{'+
                    '   \"timeStamp\": \"2018-09-16T09:44:36.000Z\",'+
                    '   \"orderLineItems\": ['+
                    '      {'+
                    '         \"subscriptionType\": \"New\",'+
                    '         \"subscriptionQuantity\": 2,'+
                    '         \"startDate\": \"2018-09-16T09:43:02.000Z\",'+
                    '         \"productID\": \"5678901\",'+
                    '         \"pricePerUnit\": 40,'+
                    '         \"freeTrial\": \"No\",'+
                    '         \"expirationDate\": \"2019-09-15T09:43:02.000Z\",'+
                    '         \"equipmentGroups\": null,'+
                    '         \"currencyType\": \"USD\"'+
                    '      }'+
                    '   ],'+
                    '   \"orderId\": \"O-0000101039\",'+
                    '   \"nextInvoiceDate\": \"2018-10-08T09:32:00.000Z\",'+
                    '   \"messageID\": \"DA_2018-09-16T09:44:36.000Z\",'+
                    '   \"initiator\": \"OSM\",'+
                    '   \"customerId\": \"390\",'+
                    '   \"createdDate\": \"2018-09-16T09:44:30.000Z\"'+
                    '}';
        OSM_WS_GeneralizedInputWrapper obj = OSM_WS_GeneralizedInputWrapper.parse(json);
        
        Test.StartTest();
        Test.setMock(HttpCalloutMock.class, new SingleRequestMockOrderFailExp());
        OSM_WS_CS_Services.callGetOrderWS(obj);
        Test.Stoptest(); 
    }
    
    //For Order Interface Test
    global class SingleRequestMockOrderPassExp implements HttpCalloutMock {
           
            global HTTPResponse respond(HTTPRequest req) {
                HttpResponse resp = new HttpResponse();
                resp.setStatusCode(200);
                resp.setBody('{"timeStamp":"2018-09-16T09:44:36.000Z","orderLineItems":[{"subscriptionType":"New","subscriptionQuantity":2,"startDate":"2018-09-16T09:43:02.000Z","productID":"5678901","pricePerUnit":40.0,"freeTrial":"No","expirationDate":"2019-09-15T09:43:02.000Z","equipmentGroups":null,"currencyType":"USD"}],"orderId":"O-0000101039","nextInvoiceDate":"2018-10-08T09:32:00.000Z","messageID":"DA_2018-09-16T09:44:36.000Z","initiator":"OSM","customerId":"390","createdDate":"2018-09-16T09:44:30.000Z"}');
                return resp;
            }
    }   
    
    //For Order Interface Test
    global class SingleRequestMockOrderFailExp implements HttpCalloutMock {
           
            global HTTPResponse respond(HTTPRequest req) {
                HttpResponse resp = new HttpResponse();
                resp.setStatusCode(400);
                resp.setBody('{"errorCode":"VALERR-001","errorDescription":"Invalid CustomerID","errorLocation":"customerInformationData"}');
                return resp;
            }
    }
    //For OSM_WS_CallOutServices
    public static testMethod void getAccessToken_test(){
     CSS_Integration_Details__c csInt = new CSS_Integration_Details__c();
        csInt.name = 'GetOrder';
        csInt.ApplicationName__c='GetOrder';
        //csInt.End_Point__c='https://connectedsolutions-dev.cummins.com/appSubscriptionInternal/v1/subscription/orderUpdates';
        csInt.AuthEnv__c='DA';
        csInt.Method_Type__c='POST';
        csInt.Timeout__c=120000;
        csInt.IsActive__c=true;
        insert csint;
        
        CSS_Integration_Details__c conDetails = new CSS_Integration_Details__c(); //Getting custom setting data
        conDetails.name = 'DA';
        conDetails.Key__c = 'appSubscription-api-key';
        conDetails.Passcode__c = 'OPJQg+I3X+t8OWbfMJexpQwIGiXRzXKROBieKx/jBlA=';
        insert conDetails;
        Test.StartTest();
        OSM_WS_CallOutServices.getAccessToken(csInt.AuthEnv__c);
        Test.StopTest();
    
    }
    
}