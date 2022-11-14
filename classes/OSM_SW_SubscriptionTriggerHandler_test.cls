//Test Class for the class OSM_SW_SubscriptionTriggerHandler
/***********************************************************/
// Updated Sharad
// Updated Sharad
// Update Dhiraj
@isTest
public class OSM_SW_SubscriptionTriggerHandler_test{

    public static testMethod void handletest(){
        
        List<Id> productIdList = new List<Id>();
        Map<ID,ccrz__E_Subscription__c> mapbeforeupdate= new Map<ID,ccrz__E_Subscription__c>();
        Map<ID,ccrz__E_Subscription__c> mapafterupdate= new Map<ID,ccrz__E_Subscription__c>();
        List<ccrz__E_Order__c> orderlIst = new List<ccrz__E_Order__c>();
        List<ccrz__E_Subscription__c> subsid = new List<ccrz__E_Subscription__c>();
        List<String> strnglst = new List<String>();
        
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
        System.debug('---CC Order---'+o1);
        
        ccrz__E_Order__c o11 = new ccrz__E_Order__c (id = o1.id);
        o11.ccrz__OrderStatus__c = 'Order Submitted';
        o11.ccrz__OrderDate__c = system.today();
        update o11;
        
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
        Sub.OSM_Free_Trial__c=true;
        Sub.ccrz__SubscriptionProduct__c=pro.Id;
        Sub.ccrz__RecurringPrice__c = 200;
        Sub.ccrz__OrderLastDate__c = System.now() + 10;
        Sub.ccrz__CurrencyISOCode__c = 'USD';
        Sub.ccrz__Quantity__c = 3;
        Sub.ccrz__SPTOrderCount__c = 5;
        Sub.ccrz__SPTOrderFrequencyUOM__c = 'Yearly';
        Sub.ccrz__Account__c = testAccount.id;
        Sub.Subsequent_Next_Invoice_Due_Dt__c = System.now() + 15;
        Sub.Subsequent_Next_Invoice_Generation_Dt__c = System.now() + 15;
        Insert Sub;
        System.debug('---CC Subscription---'+Sub);
     
        subsid.add(sub);   
        
        ccrz__E_Subscription__c Sub2=new ccrz__E_Subscription__c(id = Sub.id);
        Sub2.ccrz__Sequence__c=3;
        Sub2.ccrz__Storefront__c='SoftwareStore';
        Sub2.ccrz__SubscriptionStartDate__c=System.now().adddays(-2);
        Sub2.OSM_Subscription_End_Date__c=System.now().adddays(15);
        Sub2.ccrz__SubscriptionStatus__c= 'Active';
        Sub2.ccrz__InstallmentLastDate__c=System.now();
        Sub2.ccrz__CCOrder__c=o1.Id;
        Sub2.ccrz__CCOrderItem__c=oi1.Id;
        Sub2.OSM_Free_Trial__c=true;
        Sub2.ccrz__SubscriptionProduct__c=pro.Id;
        Sub2.ccrz__RecurringPrice__c = 200;
        Sub2.ccrz__OrderLastDate__c = System.now() + 10;
        Sub2.ccrz__CurrencyISOCode__c = 'USD';
        Sub2.ccrz__Quantity__c = 5;
        Sub2.ccrz__SPTOrderCount__c = 5;
        Sub2.ccrz__SPTOrderFrequency__c = 1;
        Sub2.ccrz__SPTOrderFrequencyUOM__c = 'Yearly';
        Sub2.ccrz__Account__c = testAccount.id;
        Sub2.Subsequent_Next_Invoice_Due_Dt__c = System.now() + 15;
        Sub2.Subsequent_Next_Invoice_Generation_Dt__c = System.now() + 15;
        update Sub2;
        System.debug('---CC Subscription---'+Sub);
        
        OSM_Incremental_Count__c oic = new OSM_Incremental_Count__c();
        oic.name = 'first';
        oic.Current_Count__c = '0';
        insert oic;
        mapbeforeupdate.put(Sub2.id,Sub2);
        mapafterupdate.put(Sub2.id,Sub2);
        
        OSM_SW_SubscriptionTriggerHandler.OnBeforeInsert(subsid);
        OSM_SW_SubscriptionTriggerHandler.OnBeforeUpdate(mapbeforeupdate);
        OSM_SW_SubscriptionTriggerHandler.OnAfterUpdate(mapbeforeupdate,mapafterupdate);
        
    }
    
    
    public static testMethod void handletest2(){
        
        List<Id> productIdList = new List<Id>();
        Map<ID,ccrz__E_Subscription__c> mapbeforeupdate= new Map<ID,ccrz__E_Subscription__c>();
        Map<ID,ccrz__E_Subscription__c> mapafterupdate= new Map<ID,ccrz__E_Subscription__c>();
        List<ccrz__E_Order__c> orderlIst = new List<ccrz__E_Order__c>();
        List<ccrz__E_Subscription__c> subsid = new List<ccrz__E_Subscription__c>();
        List<String> strnglst = new List<String>();
        
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
        testAccount.CSS_Timezone__c = '(GMT+05:30) India Standard Time (Asia/Kolkata)';
        testAccount.CMI_CId__c = '390';
        insert testAccount;
        system.debug('testAccount'+testAccount);
        
        Account acc2 = new Account(id = testaccount.id);
        acc2.OSM_Preferred_Payment_Method__c = '';
        acc2.OSM_Preferred_Billing_Frequency_Lock__c = false;
        acc2.OSM_Preferred_Billing_Frequency__c = '';
        update acc2;        
            
        //CC Order
        ccrz__E_Order__c o1 = new ccrz__E_Order__c ();
        o1.ccrz__Storefront__c = 'SoftwareStore';
        o1.ccrz__Account__c = testAccount.Id;
        o1.ccrz__CurrencyISOCode__c = 'USD';
        //ol.ccrz__OrderStatus__c = 'Order Submitted';
        insert o1;
        System.debug('---CC Order---'+o1);
        
        ccrz__E_Order__c o11 = new ccrz__E_Order__c (id = o1.id);
        o11.ccrz__OrderStatus__c = 'Order Submitted';
        o11.ccrz__OrderDate__c = system.today();
        update o11;
        
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
        
        ccrz__E_SubProdTerm__c proterm = new ccrz__E_SubProdTerm__c();
        proterm.ccrz__CCProduct__c = pro.id;
        proterm.Operation__c = '/';
        proterm.ccrz__EffectiveStart__c = system.today();
        proterm.ccrz__EffectiveEnd__c = system.today().adddays(2);
        proterm.ccrz__Storefront__c = 'SoftwareStore';
        insert proterm;
        
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
        Sub.ccrz__SPTOrderCount__c = 1;
        Sub.ccrz__Quantity__c = 3;  
        Sub.ccrz__SPTOrderFrequency__c = 1.00;      
        Sub.ccrz__Account__c = testAccount.id;
        Sub.Subsequent_Next_Invoice_Due_Dt__c = System.now() + 15;
        Sub.Subsequent_Next_Invoice_Generation_Dt__c = System.now() + 15;
        Sub.ccrz__SPTOrderFrequencyUOM__c = 'Monthly';      
        Insert Sub;
        System.debug('---CC Subscription---'+Sub);
     
        subsid.add(sub);
    
        ccrz__E_Subscription__c Sub2=new ccrz__E_Subscription__c(id = Sub.id);
        Sub2.ccrz__Sequence__c=3;
        Sub2.ccrz__Storefront__c='SoftwareStore';
        Sub2.ccrz__SubscriptionStartDate__c=System.now().adddays(-2);
        Sub2.OSM_Subscription_End_Date__c=System.now().adddays(15);
        Sub2.ccrz__SubscriptionStatus__c= 'Active';
        Sub2.ccrz__InstallmentLastDate__c=System.now();
        Sub2.ccrz__CCOrder__c=o1.Id;
        Sub2.ccrz__CCOrderItem__c=oi1.Id;
        Sub2.OSM_Free_Trial__c=true;
        Sub2.ccrz__SubscriptionProduct__c=pro.Id;
        Sub2.ccrz__RecurringPrice__c = 200;
        Sub2.ccrz__OrderLastDate__c = System.now() + 10;
        Sub2.ccrz__CurrencyISOCode__c = 'USD';
        Sub2.ccrz__Quantity__c = 5;
        Sub2.ccrz__SPTOrderCount__c = 5;
        Sub2.ccrz__SPTOrderFrequency__c = 1;
        //Sub2.Non_One_Time_Non_Cancelled_Order__c = 1;
        //Sub2.Sum_Of_One_Time_Non_Cancelled__c = 120;
        Sub2.ccrz__SPTOrderFrequencyUOM__c = 'Yearly';
        Sub2.ccrz__Account__c = testAccount.id;
        Sub2.Subsequent_Next_Invoice_Due_Dt__c = System.now() + 15;
        Sub2.Subsequent_Next_Invoice_Generation_Dt__c = System.now() + 15;
        Sub2.Recurring_Invoice_Start_Date__c = System.now() + 15;
        Sub2.ccrz__SPT__c = proterm.id;
        update Sub2;
        System.debug('---CC Subscription---'+Sub);
                
        OSM_Order_Subscription__c osub = new OSM_Order_Subscription__c();
        osub.OSM_CCOrder__c = o11.id;
        osub.OSM_CCSubscription__c = Sub2.id;
        osub.Billing_Frequency__c = 'Yearly';
        osub.CCQuantity__c = 2;
        insert osub;
        
        ccrz__E_PriceList__c pl = new ccrz__E_PriceList__c();
        pl.ccrz__StartDate__c = system.today();
        pl.ccrz__EndDate__c = system.today().adddays(2);
        pl.ccrz__Storefront__c = 'SoftwareStore';
        insert pl;
        
        ccrz__E_PriceListItem__c plitem = new ccrz__E_PriceListItem__c();
        plitem.ccrz__Product__c = pro.id;
        plitem.ccrz__Pricelist__c = pl.id;
        plitem.ccrz__SubProdTerm__c = proterm.id;
        insert plitem;
        
        OSM_Incremental_Count__c oic = new OSM_Incremental_Count__c();
        oic.name = 'first';
        oic.Current_Count__c = '0';
        insert oic;
        mapbeforeupdate.put(Sub2.id,Sub2);
        mapafterupdate.put(Sub2.id,Sub2);
        
        OSM_SW_SubscriptionTriggerHandler.OnBeforeInsert(subsid);
        OSM_SW_SubscriptionTriggerHandler.OnBeforeUpdate(mapbeforeupdate);
        OSM_SW_SubscriptionTriggerHandler.OnAfterUpdate(mapbeforeupdate,mapafterupdate);
        
        List<Id> sid=new List<Id>();
        sid.add(subsid[0].Id);
        
        OSM_SW_SubscriptionTriggerHandlerUtility.callIAMProvisioningBusinessLayerForInsert(sid,true,true);
        
    }
}