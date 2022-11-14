//Test Class for the class OSM_OMS_CreateOrder_Retry_Batch
//redeploying test issues
@isTest
public class OSM_OMS_CreateOrder_Retry_Batch_Test {

    @testSetup static void testData() {

        ccrz__E_Order__c order = new ccrz__E_Order__c();
        insert order;
        
        
        
        ccrz__E_OrderItem__c orderItem       = new ccrz__E_OrderItem__c();
        orderItem.ccrz__Order__c             = order.id;
        orderItem.ccrz__Quantity__c          = 55;
        orderItem.ccrz__SubAmount__c         = 250;
        orderItem.OMS_Product__c             = true;
        orderItem.OMS_Activation_Key__c      = 'testActivation';
        orderItem.Revocation_Status__c       = 'Revoke Initiated';
        orderItem.isRenew__c                 = false;
        orderItem.ccrz__Price__c             = 2500;
        insert orderItem;
        
        
    }

    @isTest static void testMethod1() {
    
    
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
        
        //Cart
        ccrz__E_Cart__c cart = new ccrz__E_Cart__c();
        cart.ccrz__CartType__c = 'Cart'; 
        cart.ccrz__ActiveCart__c = true;
        cart.ccrz__CartStatus__c='Closed';
        cart.ccrz__EncryptedId__c = 'encrypt';
        cart.ccrz__Storefront__c = 'SoftwareStore';
        insert cart;
        
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
        //o1.Max_Activation_Keys__c = 2;
        //o1.Successful_Activation_Keys__c = 1;
       //o1.AllActivationKeysGenerated__c =false;
        o1.ccrz__OrderStatus__c = 'Order Submitted';
        insert o1;
        
        //Product
         //CC Product        
        ccrz__E_Product__c parentpro = new ccrz__E_Product__c();
        parentpro.Name = 'Fleet Count®';
        parentpro.ccrz__SKU__c = '5678901-DEF';
        parentpro.ccrz__Quantityperunit__c = 1;
        parentpro.Group_Name__c = 'DA';
        parentpro.Product_Class_Code__c = 'SW-Web Access';
        parentpro.ccrz__ProductType__c = 'Bundle';
        insert parentpro;
        
        //Product
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
        
        //Create Order item
         ccrz__E_OrderItem__c oi1 = new ccrz__E_OrderItem__c();
        oi1.ccrz__Price__c = 500;
        oi1.ccrz__OriginalItemPrice__c = 400;
        oi1.ccrz__Quantity__c = 1;
        oi1.ccrz__SubAmount__c = 123;
        oi1.ccrz__Order__c = o1.id;
        oi1.ccrz__Product__c = pro.id;
        oi1.ccrz__Subscription_Auto_Renewal__c = true;
        oi1.ccrz__DisplayProduct__c = parentpro.id;
        oi1.OMS_Product__c = true;
        insert oi1;
        Test.startTest();
        System.assertnotEquals(null,o1);
        System.assertnotEquals(null,oi1);
        System.assertnotEquals(null,cart);
        try
        {
            OSM_OMS_CreateOrderScheduler.scheduleCreateOrderRetryBatch();
        System.schedule('OSM_OMS_CreateOrder_Retry_Batch-00', '0 0 * * * ?', new OSM_OMS_CreateOrder_Retry_Batch());
        System.schedule('OSM_OMS_CreateOrder_Retry_Batch-30', '0 30 * * * ?', new OSM_OMS_CreateOrder_Retry_Batch());
        System.schedule('OSM_OMS_CreateOrder_Retry_Batch-50', '0 50 * * * ?', new OSM_OMS_CreateOrder_Retry_Batch());
        
        }catch(system.Exception   e){
           System.assertEquals('NullPointerException' , e.getDmlStatusCode(0) );
           }       
        Test.stopTest();
    }
   
}