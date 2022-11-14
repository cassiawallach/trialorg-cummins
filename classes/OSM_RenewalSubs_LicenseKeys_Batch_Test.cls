// test updated by Ashish (29/03/2022) for MP-698
//Subbu update 
//Update by Swetha and Subbu to pick up for test class
//Updated by Pooja 8/5/2022 story 1054
@isTest
public class OSM_RenewalSubs_LicenseKeys_Batch_Test {
    @testSetup
    static void setup() {
        CSS_Integration_Details__c objCID3 = new CSS_Integration_Details__c(AuthEnv__c = 'OMS_Auth',
                                                                           IsActive__c = true,
                                                                           Timeout__c = 120000,
                                                                           Method_Type__c = 'POST',
                                                                           ApplicationName__c = 'OMS',
                                                                           Name = 'OMS_Auth',
                                                                           Key__c = '694a2e07-c2dc-4473-81da-b693866d37b6',
                                                                           Passcode__c = 'f6e1b39a-ad95-4d12-ab73-148afbfa8dcb',
                                                                           End_Point__c = 'https://services-test-oauth.cummins.com/api/oauth/token/cso');
        insert objCID3;
        
        CSS_Integration_Details__c objCID4 = new CSS_Integration_Details__c(AuthEnv__c = 'OMS',
                                                                           IsActive__c = true,
                                                                           Timeout__c = 120000,
                                                                           Method_Type__c = 'POST',
                                                                           ApplicationName__c = 'OMS',
                                                                           Name = 'OMS_CreateOrder_Service',
                                                                           Key__c = '694a2e07-c2dc-4473-81da-b693866d37b6',
                                                                           Passcode__c = 'f6e1b39a-ad95-4d12-ab73-148afbfa8dcb',
                                                                           End_Point__c = 'https://services-test.cummins.com/cso/oms/order');
        insert objCID4;
        
        CSS_Integration_Details__c objCID5 = new CSS_Integration_Details__c(AuthEnv__c = 'OMS',
                                                                           IsActive__c = true,
                                                                           Timeout__c = 120000,
                                                                           Method_Type__c = 'PUT',
                                                                           ApplicationName__c = 'OMS',
                                                                           Name = 'OMS_GetOrder_Service',
                                                                           Key__c = '694a2e07-c2dc-4473-81da-b693866d37b6',
                                                                           Passcode__c = 'f6e1b39a-ad95-4d12-ab73-148afbfa8dcb',
                                                                           End_Point__c = 'https://services-test.cummins.com/cso/oms/order');
        insert objCID5;
    }
    
    
    static testMethod void call_OMS_GetAndCreateOrder() {
        
        //Account
        Account testaccount = new Account();
        testAccount.Name = 'testacc1';
        testAccount.BillingStreet = 'Street';
        testAccount.BillingCity = 'City';
        testAccount.BillingState = '';
        testAccount.BOLT_Account_Number__c = '999';
        testAccount.BillingPostalCode = '11000';
        testAccount.BillingCountry = 'United States';
        testAccount.CMI_Region__c = 'India';
        testAccount.CSS_Locale__c = 'English(India)';
        // testAccount.RecordTypeId = OSM_TestDataCreationUtility.getAccountRecordTypeID();
        // testAccount.OwnerId = OSM_TestDataCreationUtility.getSystemAdministratorID();
        testAccount.CSS_Timezone__c = '(GMT+05:30) India Standard Time (Asia/Kolkata)';
        insert testAccount;
        
        system.debug('testAccount' + testAccount);
        
        ccrz__E_Cart__c cart = new ccrz__E_Cart__c();
        cart.ccrz__CartType__c = 'Cart'; 
        cart.ccrz__ActiveCart__c = true;
        cart.ccrz__CartStatus__c='Closed';
        cart.ccrz__EncryptedId__c = 'encrypt';
        cart.ccrz__Storefront__c = 'SoftwareStore';
        insert cart;
        
        ccrz__E_CartItem__c cartItem = new ccrz__E_CartItem__c();
        cartItem.ccrz__Cart__c = cart.id;
        cartItem.ccrz__Quantity__c = 2;
        cartItem.ccrz__Price__c = 10;
        cartItem.ccrz__ProductType__c = 'Bundle';
        cartItem.isRenew__c = true;
        insert cartItem;

        //CC Order
        ccrz__E_Order__c o1 = new ccrz__E_Order__c();
        o1.ccrz__Storefront__c = 'SoftwareStore';
        o1.ccrz__Account__c = testAccount.Id;
        o1.ccrz__CurrencyISOCode__c = 'USD';
        o1.ByPassFlow__c = true;
        o1.ccrz__OrderStatus__c='Order Submitted';
        o1.OSM_SW_Is_InterCompany_Order__c=false;
        o1.OSM_SW_Should_mail_Send__c=true;
        o1.Activation_Key_Failure_Mail_Sent__c=true;
        o1.ccrz__OriginatedCart__c = cart.Id;
        insert o1;
        
        //CC Product        
        ccrz__E_Product__c parentpro = new ccrz__E_Product__c();
        parentpro.Name = 'Fleet Count®';
        parentpro.ccrz__SKU__c = '5678901-DEF';
        parentpro.ccrz__Quantityperunit__c = 1;
        parentpro.Group_Name__c = 'DA';
        parentpro.Product_Class_Code__c = 'SW-Web Access';
        parentpro.ccrz__ProductType__c = 'Bundle';
        insert parentpro;
        
        //CC Product
        ccrz__E_Product__c pro = new ccrz__E_Product__c();
        pro.Name = 'INSITE';
        pro.ccrz__SKU__c = '5678902-OHT';
        pro.ccrz__Quantityperunit__c = 1;
        pro.Group_Name__c = 'DA';
        pro.ccrz__ParentProduct__c = parentpro.id;
        pro.Product_Class_Code__c = 'SW-Web Access';
        pro.ccrz__ProductType__c = 'Bundle';
        insert pro;

        //CC OrderItem
        ccrz__E_OrderItem__c oi1 = new ccrz__E_OrderItem__c();
        oi1.ccrz__Price__c = 500;
        oi1.ccrz__OriginalItemPrice__c = 400;
        oi1.ccrz__Quantity__c = 1;
        oi1.ccrz__SubAmount__c = 123;
        oi1.ccrz__Order__c = o1.id;
        oi1.ccrz__Product__c = pro.id;
        oi1.ccrz__Subscription_Auto_Renewal__c = true;
        oi1.ccrz__DisplayProduct__c = parentpro.id;
        insert oi1;
        
        ccrz__E_OrderItem__c oi2 = new ccrz__E_OrderItem__c();
        oi2.ccrz__Price__c = 500;
        oi2.ccrz__OriginalItemPrice__c = 400;
        oi2.ccrz__Quantity__c = 1;
        oi2.ccrz__SubAmount__c = 123;
        oi2.ccrz__Order__c = o1.id;
        oi2.ccrz__Product__c = pro.id;
        oi2.ccrz__Subscription_Auto_Renewal__c = true;
        oi2.ccrz__DisplayProduct__c = parentpro.id;
        insert oi2;
        
        //CC Subscription
        ccrz__E_Subscription__c Sub = new ccrz__E_Subscription__c();
        Sub.ccrz__Sequence__c = 3;
        Sub.ccrz__Storefront__c = 'SoftwareStore';
        Sub.ccrz__SubscriptionStartDate__c = System.now();
        Sub.ccrz__SubscriptionStatus__c = 'Renew';
        Sub.ccrz__InstallmentLastDate__c = System.now();
        Sub.ccrz__CCOrder__c = o1.Id;
        Sub.ccrz__CCOrderItem__c = oi1.Id;
        Sub.OSM_Free_Trial__c = false;
        Sub.ccrz__SubscriptionProduct__c = pro.Id;
        Sub.ccrz__RecurringPrice__c = 200;
        Sub.ccrz__OrderLastDate__c = System.now() + 10;
        Sub.ccrz__CurrencyISOCode__c = 'USD';
        Sub.ccrz__Quantity__c = 3;
        Sub.ccrz__Account__c = testAccount.id;
        Sub.Subsequent_Next_Invoice_Due_Dt__c = System.now() + 15;
        Sub.Subsequent_Next_Invoice_Generation_Dt__c = System.now() + 15;
        Sub.Is_Renewal_Subscription__c = true;
        Insert Sub;
        
        //CC Order Item License
        OSM_Order_Item_License__c ordItemLic = new OSM_Order_Item_License__c();
        ordItemLic.Activation_Key__c         = 'testActivationKey';
        ordItemLic.CC_Order_Item__c          = oi1.Id;
        ordItemLic.Parent_Activation_Key__c  = null;
        ordItemLic.OMS_Item_Id__c            = '1234';
        ordItemLic.Tool_Instance_Key__c      = '12345';
        ordItemLic.Status__c                 = 'New';
        ordItemLic.type__c                   = 'Basic';
        insert ordItemLic;
        
        ccrz__E_CompositeProduct__c compositeProduct = new ccrz__E_CompositeProduct__c();
        compositeProduct.ccrz__Quantity__c = 1;
        compositeProduct.ccrz__Composite__c = pro.id;
        compositeProduct.ccrz__Component__c = pro.id;
        compositeProduct.ccrz__Sequence__c = 500;
        compositeProduct.Unit__c = 'Licenses';
        insert compositeProduct;
        
        Test.startTest();
        System.assertnotEquals(null,o1);
        try{
            
            OSM_RenewalSubs_LicenseKeys_Batch iamRenwBatch = new OSM_RenewalSubs_LicenseKeys_Batch();
            database.executebatch(iamRenwBatch,1);
            
        }catch(system.Exception   e){
           System.assertEquals('NullPointerException' , e.getDmlStatusCode(0) );          
        }
       
        SchedulableContext sc = null;
        OSM_RenewalSubs_LicenseKeys_Batch tsc = new OSM_RenewalSubs_LicenseKeys_Batch();
        tsc.execute(sc);
        Test.stopTest();
    }
}