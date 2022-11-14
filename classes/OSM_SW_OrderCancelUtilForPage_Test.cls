//Test Class for the class OSM_WS_RetryJournalEntryReversalJob*****
/************************************************
 History
 --------
 VERSION    AUTHOR          DATE            DETAILS
 1.0        Ashish G        07/12/2021      MP-389
 1.1       Karthik Raj G    05/16/2022      MP-858
 recompile3
 */
@isTest
public class OSM_SW_OrderCancelUtilForPage_Test {
    
    public static testMethod void OrderCancellationTestMethod(){
    
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
        insert testAccount;
        system.debug('testAccount'+testAccount);
            
        //CC Order
        ccrz__E_Order__c o1 = new ccrz__E_Order__c ();
        o1.ccrz__Storefront__c = 'SoftwareStore';
        o1.ccrz__Account__c = testAccount.Id;
        o1.ccrz__CurrencyISOCode__c = 'USD';
        o1.OrderProcessedforFSD__c = true;
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
        oi1.isRenew__c=true;
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
        invc.ccrz__CurrencyCode__c = 'USD';
        insert invc;
        
        //Transaction payment
        ccrz__E_TransactionPayment__c  ctpayment = new ccrz__E_TransactionPayment__c();
        ctpayment.ccrz__AccountType__c = 'po';
        ctpayment.Transaction_Status__c = 'Order Placed Success';
        ctpayment.ccrz__Storefront__c = 'SoftwareStore';
        ctpayment.ccrz__CCOrder__c = o1.id;
        ctpayment.ccrz__InvoiceAppliedTo__c = invc.id;
        insert ctpayment;
        
        //Cancelling the order
        ccrz__E_Order__c o12 = new ccrz__E_Order__c (id = o11.id);
        o12.ccrz__OrderStatus__c = 'Cancelled';
        o12.ccrz__OrderDate__c = system.today();
        update o12;
    }
    
    
    public static testMethod void OrderCancellationTestMethod2(){
    
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
        insert testAccount;
        system.debug('testAccount'+testAccount);
            
        //CC Order
        ccrz__E_Order__c o1 = new ccrz__E_Order__c ();
        o1.ccrz__Storefront__c = 'SoftwareStore';
        o1.ccrz__Account__c = testAccount.Id;
        o1.ccrz__CurrencyISOCode__c = 'USD';
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
        /*OSM_Order_Subscription__c osj = new OSM_Order_Subscription__c();
        osj.OSM_CCOrder__c = o1.id;
        osj.CC_Order_Item__c = oi1.id;
        //osj.CCProduct__c = pro.id;
        osj.CCQuantity__c = 1;
        osj.OSM_CCSubscription__c = Sub.id;
        osj.Billing_Frequency__c = 'Monthly';
        insert osj;*/
        
        //Invoice
        ccrz__E_Invoice__c invc = new ccrz__E_Invoice__c();
        invc.ccrz__CCOrder__c = o1.id;
        invc.ccrz__Status__c = 'Paid';
        invc.ccrz__Storefront__c = 'SoftwareStore';
        invc.ccrz__CurrencyCode__c = 'USD';
        insert invc;
        
        //Transaction payment
        ccrz__E_TransactionPayment__c  ctpayment = new ccrz__E_TransactionPayment__c();
        ctpayment.ccrz__AccountType__c = 'po';
        ctpayment.Transaction_Status__c = 'Order Placed Success';
        ctpayment.ccrz__Storefront__c = 'SoftwareStore';
        ctpayment.ccrz__CCOrder__c = o1.id;
        ctpayment.ccrz__InvoiceAppliedTo__c = invc.id;
        insert ctpayment;
        
        //Cancelling the order
        ccrz__E_Order__c o12 = new ccrz__E_Order__c (id = o11.id);
        o12.ccrz__OrderStatus__c = 'Cancelled';
        o12.ccrz__OrderDate__c = system.today();
        update o12;
    }
    
    
    
    public static testMethod void InvoiceRevokeTestMethod(){
    
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
        insert testAccount;
        system.debug('testAccount'+testAccount);
            
        //CC Order
        ccrz__E_Order__c o12 = new ccrz__E_Order__c ();
        o12.ccrz__Storefront__c = 'SoftwareStore';
        o12.ccrz__Account__c = testAccount.Id;
        o12.ccrz__CurrencyISOCode__c = 'USD';
        insert o12;
        
        ccrz__E_Order__c o1 = new ccrz__E_Order__c ();
        o1.ccrz__Storefront__c = 'SoftwareStore';
        o1.ccrz__Account__c = testAccount.Id;
        o1.ccrz__CurrencyISOCode__c = 'USD';
        o1.Original_Sales_Order__c =o12.Id;
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
        oi1.OSM_SW_Is_Included_Product__c=false;
        oi1.isRenew__c = true;
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
        invc.ccrz__Status__c = 'Open';
        invc.ccrz__Storefront__c = 'SoftwareStore';
        invc.ccrz__CurrencyCode__c = 'USD';
        invc.Payment_Method__c = 'po';
        insert invc;
        
        //Transaction payment
        ccrz__E_TransactionPayment__c  ctpayment = new ccrz__E_TransactionPayment__c();
        ctpayment.ccrz__AccountType__c = 'po';
        ctpayment.Transaction_Status__c = 'Order Placed Success';
        ctpayment.ccrz__Storefront__c = 'SoftwareStore';
        ctpayment.ccrz__CCOrder__c = o1.id;
        ctpayment.ccrz__InvoiceAppliedTo__c = invc.id;
        insert ctpayment;
        
        //Revoking the invoice
        ccrz__E_Invoice__c inv1 = new ccrz__E_Invoice__c (id = invc.id);
        inv1.ccrz__Status__c = 'Revoked';
        update inv1;
        
        List<Id> invList = new List<Id>();
        invList.add(inv1.id);
        Test.startTest();
        OSM_SW_OrderCancelUtilForPage.callFSDAPIFromBatch(o1.Id);
        OSM_SW_OrderCancelUtilForPage.updateIntercompanyOrder(o12.Id);
        OSM_SW_OrderCancelUtilForPage.updateIntercompanyOrderCancelSucess(o12.Id);
        OSM_SW_OrderCancelUtilForPage.updateSubsc(o12.Id);
        OSM_SW_OrderCancelUtilForPage.updateTP(o12.Id);
        Set<Id> idSet = new Set<Id>();
        idSet.add(o1.Id);
        Set<Id> idSet1 = new Set<Id>();
        idSet1.add(oi1.Id);
        OSM_SW_OrderCancelUtilForPage.updateOrderCancel(idSet);
        OSM_SW_OrderCancelUtilForPage.updateOrderItemCancel(idSet1);
        Test.stopTest();
    }


}