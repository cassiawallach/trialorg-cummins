@isTest
public class OSM_SW_SubscriptionTriggerHndlrUtilTest {
    
    public static testMethod void subsUtiltest(){
        List<Id> productIdList = new List<Id>();
        String AccountId;
        Map<ID,ccrz__E_Order__c> MapOrdero= new Map<ID,ccrz__E_Order__c>();
        Map<ID,ccrz__E_Order__c> MapOrdern= new Map<ID,ccrz__E_Order__c>();
        List<ccrz__E_Order__c> orderlIst = new List<ccrz__E_Order__c>();
        List<Id> subsid = new List<Id>();
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
        Sub.OSM_Free_Trial__c=true;
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
     
        subsid.add(sub.id);     
        
        OSM_Incremental_Count__c oic = new OSM_Incremental_Count__c();
        oic.name = 'first';
        oic.Current_Count__c = '0';
        insert oic;
        
        OSM_WS_FreeTrialUpdateReqWrapper wrap = new OSM_WS_FreeTrialUpdateReqWrapper();
        wrap.PreviousQuantity = 2;
        wrap.CurrentQuantity = 5;
        wrap.PreviousEndDate = system.today().adddays(-5);
        wrap.CurrentEndDate = system.today();
        wrap.subscriptionId = sub.id;
        
        String jsonstr =  json.serialize(wrap);
        
        String json = '{'+
                    '  \"PreviousQuantity\": 2,'+
                    '  \"CurrentQuantity\": 5,'+
                    '  \"PreviousEndDate\": \"2018-04-27T17:44:39.688Z\",'+
                    '  \"CurrentEndDate\": \"2018-05-27T17:44:39.688Z\",'+
                    '  \"subscriptionId\": \"S-0000000148\"'+
                    '}';
        
        strnglst.add(jsonstr);  
        
        test.starttest();
        OSM_SW_SubscriptionTriggerHandlerUtility.CallFreeTrialBusinessLayerForInsert(subsid);
        OSM_SW_SubscriptionTriggerHandlerUtility.callIAMProvisioningBusinessLayerForInsert(subsid, true, true);
        OSM_SW_SubscriptionTriggerHandlerUtility.CallFreeTrialBusinessLayerForUpdate(strnglst);
        
        //OSM_SW_SubscriptionTriggerHandlerUtility.FreeTrialSubscriptionOnUpdate(strnglst);
        test.stoptest();
    }
}