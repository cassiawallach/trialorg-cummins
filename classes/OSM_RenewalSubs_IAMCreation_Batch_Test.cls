@isTest
public class OSM_RenewalSubs_IAMCreation_Batch_Test {
    public static ccrz__E_Subscription__c setUpSubscription(ID accountID, ID subscriptionProductID) {
        ccrz__E_Subscription__c subscription = new ccrz__E_Subscription__c();
        subscription.ccrz__Quantity__c = 2;
        subscription.ccrz__SubscriptionStatus__c = 'Active';
        subscription.OSM_Subscription_End_Date__c = System.now() + Integer.valueof(365);
        subscription.ccrz__SubscriptionStartDate__c = System.now();
        subscription.ccrz__Account__c = accountID;
        subscription.ccrz__SubscriptionProduct__c = subscriptionProductID;
        subscription.ccrz__Sequence__c = 500;
        subscription.ccrz__Storefront__c = 'SoftwareStore';  
        subscription.Is_Renewal_Subscription__c = true;      
        return subscription;
    }
    
    
    public static ccrz__E_Product__c setUpProduct(String name, String sku, String productType, String qsolType)
    {
        ccrz__E_Product__c product = new ccrz__E_Product__c();
        product.isIAMProvisioningRequired__c = true;
        product.QSOLType__c = qsolType;
        product.Name = name;
        product.ccrz__ProductType__c = productType;
        product.ccrz__SKU__c = sku;
        product.ccrz__Storefront__c = 'SoftwareStore';
        product.ccrz__StartDate__c = system.today();
        product.ccrz__EndDate__c = system.today() + 1;
        
        return product;
    }
    
    public static ccrz__E_CompositeProduct__c setUpCompositeProduct(ID compositeID, ID componentID, Integer qty, String unit)
    {
        ccrz__E_CompositeProduct__c compositeProduct = new ccrz__E_CompositeProduct__c();
        compositeProduct.ccrz__Quantity__c = qty;
        compositeProduct.ccrz__Composite__c = compositeID;
        compositeProduct.ccrz__Component__c = componentID;
        compositeProduct.ccrz__Sequence__c = 500;
        compositeProduct.Unit__c = unit;
        
        return compositeProduct;
    }
    
    
    public static Account setUpAccount() {
        Account acc = new Account();
        acc.Name = 'Test Account';
        acc.CHANNEL_OF_DISTRIBUTION__c = 'ABCDFLEET';
        acc.Business_Unit__c = 'EBU';        
        return acc;
    }
    
    
    static testMethod void createIAMRecordTest() {
        Account acc = setUpAccount();
        insert acc;
        
        // Create Bundle Product
        ccrz__E_Product__c bundle_product = setUpProduct('Cummins Guidanz', 'CG-123', 'Bundle', '');
        insert bundle_product;
        
        // create a QSOL EBU Product
        ccrz__E_Product__c qsol_product = setUpProduct('QuickServe® Online Kit (QSOL, EDS, CVCOL )', 'QSOL-EBU-123', 'Product', 'EBU');
        insert qsol_product;
        
        // create a Guidanz Mobile Product
        ccrz__E_Product__c mobile_product = setUpProduct('Guidanz Mobile (Includes Immediate Assessment)', 'GZ-Mobile-005-1', 'Product', '');
        insert mobile_product;
        
        ccrz__E_CompositeProduct__c comp_1 = setUpCompositeProduct(bundle_product.ID, qsol_product.ID, 9999, 'Users');
        insert comp_1;
        
        ccrz__E_CompositeProduct__c comp_2 = setUpCompositeProduct(bundle_product.ID, mobile_product.ID, 2, 'Users');
        insert comp_2;
        
        //ccrz__E_Subscription__c subscription = setUpSubscription(acc.ID, bundle_product.ID);
        //insert subscription;
        
       
        
        Account acc2 = new Account();
        acc2.Name = 'TestAccount99';
        acc2.CHANNEL_OF_DISTRIBUTION__c = 'ABCDFLEET';
        acc2.Business_Unit__c = 'EBU';
        acc2.recordtypeid= Schema.SObjectType.Account.getRecordTypeInfosByName().get('WWSPS').getRecordTypeId();
        acc2.type='Votech';
        acc2.EBU_Channel_of_Distribution__c='Fleet';
        acc2.PSBU_Channel_of_Distribution__c='Fleet';
        insert acc2;
        
        //CC Order
        ccrz__E_Order__c o1 = new ccrz__E_Order__c();
        o1.ccrz__Storefront__c = 'SoftwareStore';
        o1.ccrz__Account__c = acc2.Id;
        o1.ccrz__CurrencyISOCode__c = 'USD';
        o1.ByPassFlow__c = true;
        o1.ccrz__OrderStatus__c='Order Submitted';
        o1.OSM_SW_Is_InterCompany_Order__c=false;
        o1.OSM_SW_Should_mail_Send__c=true;
        o1.Activation_Key_Failure_Mail_Sent__c=true;
        //o1.ccrz__OriginatedCart__c = cart.Id;
        o1.OSM_SW_IAM_Provisioning__c=true;
        insert o1;
        
        ccrz__E_Subscription__c subscription2 = setUpSubscription(acc2.ID, mobile_product.ID);
        subscription2.ccrz__CCOrder__c = o1.Id;
        insert subscription2;
         
        OSM_Order_Subscription__c osmOS = new OSM_Order_Subscription__c();
        osmOS.OSM_CCSubscription__c=subscription2.id;
        osmOS.OSM_CCOrder__c=o1.id;
        osmOS.Billing_Frequency__c='One Time';
        insert osmOS;
        IAM_Application__c app1 = new IAM_Application__c(IAM_Status__c='Inactive',
                                                        IAM_swregExpire__c = 'test',
                                                        IAM_Role__c='Guidanz Mobile Immediate Assessment Fleet',
                                                        IAM_Source__c = 'Marketplace',
                                                        IAM_Subscription_Count__c= 10,
                                                        IAM_Free_Subscription__c= False,
                                                        IAM_Provisioned_User_Count__c=1,
                                                        IAM_Account_Name__c = acc2.ID,
                                                        IAM_Application_Name__c = 'Guidanz Mobile',
                                                        IAM_Subscription_Name__c='TestSubscription1',
                                                        IAM_Subscription_Start_Date__c=System.today(),
                                                        IAM_Reject_Reason__c = 'Cancellation Comments',
                                                        IAM_Subscription_End_Date__c= System.today() + 5);
        
        insert app1;
        Test.startTest();
            OSM_RenewalSubs_IAMCreation_Batch btch = new OSM_RenewalSubs_IAMCreation_Batch();
            String sch = '0 0 23 * * ?';
            system.schedule('IAM Renewal Job', sch, btch); 
       System.assertNotEquals(null,app1,'IAM Application not created.');
       System.assertEquals('Inactive', app1.IAM_Status__c);    
        Test.stopTest();
    }
}