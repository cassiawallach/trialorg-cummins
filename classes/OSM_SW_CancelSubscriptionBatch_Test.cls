@isTest 
public class OSM_SW_CancelSubscriptionBatch_Test 
{
    static testMethod void testMethod1() 
    {
    
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
        testReq.componentProductSKU = '1301298-BUS';
        testReq.componentProductGroupName = 'DA';
        testReq.componentProductPackageName = 'Base';
        
        
        testReq.priceListName = 'TestPriceList';
        testReq.specName = 'TestName';
        
        
        TestCompletedTransactionSetUpRes transecRes = new TestCompletedTransactionSetUpRes();
                                
                                transecRes = OSM_TestDataCreationUtility.createProductSetUp(testReq);
        System.runAs ( transecRes.objSetupDate.loggedInUser   ) {
        
        ccrz__E_Subscription__c subscription = new ccrz__E_Subscription__c();
        
        subscription.ccrz__Sequence__c = 500;
        subscription.ccrz__Storefront__c = 'SoftwareStore';
        subscription.ccrz__Account__c = transecRes.objSetupDate.account.Id;
        subscription.ccrz__CCOrder__c = transecRes.order.Id;
        subscription.ccrz__CCOrderItem__c = transecRes.orderItem.Id;
        subscription.ccrz__CurrencyISOCode__c = 'USD';
        subscription.ccrz__Quantity__c = 1;
        subscription.ccrz__RecurringPrice__c = 40;
        subscription.ccrz__RecurringPriceSubAmt__c = 40;
        subscription.ccrz__SubscriptionStartDate__c = System.today().addMonths(-2);
        subscription.OSM_Subscription_End_Date__c = System.today().addMonths(5);
        subscription.OSM_Display_Product__c = transecRes.objSetupDate.compositeProduct.Id;
        subscription.ccrz__SPT__c = transecRes.objSetupDate.subProdTermList[0].Id;
        subscription.ccrz__SubscriptionProduct__c = transecRes.objSetupDate.componentList[0].Id;
        subscription.ccrz__SubscriptionStatus__c = 'Active';
        subscription.ccrz__InstallmentCountRemaining__c = 5;
        subscription.ccrz__User__c = transecRes.objSetupDate.objUserID;
        
        subscription.Next_Invoice_Generation_Date__c = System.today().addMonths(-1);
        subscription.Subsequent_Next_Invoice_Due_Dt__c = System.today();
        subscription.Subsequent_Next_Invoice_Generation_Dt__c = System.today();
            
        //subscription.Current_Invoice_Due_Date__c = System.today().addMonths(-2);
        //subscription.Current_Invoice_Generation_Date__c = System.today().addMonths(-2);
            
        subscription.ccrz__CurrencyISOCode__c='USD';
        //subscription.ccrz__InstallmentAddress__c=contactAddressID;
        //subscription.ccrz__OrderAddress__c=contactAddressID;
        subscription.ccrz__InstallmentNextDate__c=System.today().addMonths(-1);
                    
            subscription.Recurring_Invoice_Start_Date__c = System.today().addMonths(-2);
        
        subscription.ccrz__SPTInstallmentCount__c = 12;
         subscription.ccrz__InstallmentCountRemaining__c = 11;
         
         insert subscription;
        
        
        
        
        System.debug('transecRes: '+transecRes);
        
        
            Date CurDate = system.today();
                
            ccrz__E_Subscription__c subscription1 = transecRes.subscription;
            subscription1.ccrz__SubscriptionStatus__c = 'Partial Cancellation Requested';
            subscription1.OSM_Subscription_Cancellation_Date__c = system.today();
            subscription1.ccrz__Quantity__c = -1;
            subscription1.OSM_Parent_Subscription__c = subscription.Id;

            update subscription1;
            
            List<ccrz__E_Subscription__c> subList = [Select id, ccrz__SubscriptionStatus__c, 
                                                     OSM_Subscription_Cancellation_Date__c, ccrz__Account__c, 
                                                     OSM_Parent_Subscription__c, OSM_Parent_Subscription__r.ccrz__Quantity__c, 
                                                     ccrz__CCOrder__c, ccrz__CCOrderItem__c, ccrz__CCOrderItem__r.ccrz__Quantity__c, 
                                                     ccrz__Storefront__c, ccrz__Quantity__c 
                                                     from ccrz__E_Subscription__c 
                                                     where ccrz__SubscriptionStatus__c ='Partial Cancellation Requested' 
                                                     and OSM_Subscription_Cancellation_Date__c =: CurDate 
                                                     and ccrz__Storefront__c ='SoftwareStore'
                                                     and ccrz__Quantity__c > 0 
                                                     and OSM_Parent_Subscription__c != null 
                                                     and OSM_Subscription_Cancellation_Date__c != null 
                                                     and ccrz__CCOrder__c != null 
                                                     and ccrz__CCOrderItem__c != null];
            System.debug(subList.size());
            
            Test.startTest();
            
            OSM_SW_CancelSubscriptionBatch obj = new OSM_SW_CancelSubscriptionBatch();
            DataBase.executeBatch(obj); 
            
            Test.stopTest();
        }
    } 
    
    static testMethod void testMethod1_N() 
    {
    
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
        testReq.componentProductSKU = '1301298-BUS';
        testReq.componentProductGroupName = 'DA';
        testReq.componentProductPackageName = 'Base';
        
        
        testReq.priceListName = 'TestPriceList';
        testReq.specName = 'TestName';
        
        
        TestCompletedTransactionSetUpRes transecRes = new TestCompletedTransactionSetUpRes();
                                
                                transecRes = OSM_TestDataCreationUtility.createProductSetUp(testReq);
        System.runAs ( transecRes.objSetupDate.loggedInUser   ) {
        
        ccrz__E_Subscription__c subscription = new ccrz__E_Subscription__c();
        
        subscription.ccrz__Sequence__c = 500;
        subscription.ccrz__Storefront__c = 'SoftwareStore';
        subscription.ccrz__Account__c = transecRes.objSetupDate.account.Id;
        subscription.ccrz__CCOrder__c = transecRes.order.Id;
        subscription.ccrz__CCOrderItem__c = transecRes.orderItem.Id;
        subscription.ccrz__CurrencyISOCode__c = 'USD';
        subscription.ccrz__Quantity__c = 1;
        subscription.ccrz__RecurringPrice__c = 40;
        subscription.ccrz__RecurringPriceSubAmt__c = 40;
        subscription.ccrz__SubscriptionStartDate__c = System.today().addMonths(-2);
        subscription.OSM_Subscription_End_Date__c = System.today().addMonths(5);
        subscription.OSM_Display_Product__c = transecRes.objSetupDate.compositeProduct.Id;
        subscription.ccrz__SPT__c = transecRes.objSetupDate.subProdTermList[0].Id;
        subscription.ccrz__SubscriptionProduct__c = transecRes.objSetupDate.componentList[0].Id;
        subscription.ccrz__SubscriptionStatus__c = 'Active';
        subscription.ccrz__InstallmentCountRemaining__c = 5;
        subscription.ccrz__User__c = transecRes.objSetupDate.objUserID;
        
        subscription.Next_Invoice_Generation_Date__c = System.today().addMonths(-1);
        subscription.Subsequent_Next_Invoice_Due_Dt__c = System.today();
        subscription.Subsequent_Next_Invoice_Generation_Dt__c = System.today();
            
        //subscription.Current_Invoice_Due_Date__c = System.today().addMonths(-2);
        //subscription.Current_Invoice_Generation_Date__c = System.today().addMonths(-2);
            
        subscription.ccrz__CurrencyISOCode__c='USD';
        //subscription.ccrz__InstallmentAddress__c=contactAddressID;
        //subscription.ccrz__OrderAddress__c=contactAddressID;
        subscription.ccrz__InstallmentNextDate__c=System.today().addMonths(-1);
                    
            subscription.Recurring_Invoice_Start_Date__c = System.today().addMonths(-2);
        
        subscription.ccrz__SPTInstallmentCount__c = 12;
         subscription.ccrz__InstallmentCountRemaining__c = 11;
         
         insert subscription;
        
        
        
        
        System.debug('transecRes: '+transecRes);
        
        
            Date CurDate = system.today();
                
            ccrz__E_Subscription__c subscription1 = transecRes.subscription;
            subscription1.ccrz__SubscriptionStatus__c = 'Partial Cancellation Requested';
            subscription1.OSM_Subscription_Cancellation_Date__c = system.today();
            subscription1.ccrz__Quantity__c = -10;
            subscription1.OSM_Parent_Subscription__c = subscription.Id;
             subscription1.ccrz__SubscriptionStatus__c = 'InActive';
            update subscription1;
            
            List<ccrz__E_Subscription__c> subList = [Select id, ccrz__SubscriptionStatus__c, 
                                                     OSM_Subscription_Cancellation_Date__c, ccrz__Account__c, 
                                                     OSM_Parent_Subscription__c, OSM_Parent_Subscription__r.ccrz__Quantity__c, 
                                                     ccrz__CCOrder__c, ccrz__CCOrderItem__c, ccrz__CCOrderItem__r.ccrz__Quantity__c, 
                                                     ccrz__Storefront__c, ccrz__Quantity__c 
                                                     from ccrz__E_Subscription__c 
                                                     where ccrz__SubscriptionStatus__c ='Partial Cancellation Requested' 
                                                     and OSM_Subscription_Cancellation_Date__c =: CurDate 
                                                     and ccrz__Storefront__c ='SoftwareStore'
                                                     and ccrz__Quantity__c > 0 
                                                     and OSM_Parent_Subscription__c != null 
                                                     and OSM_Subscription_Cancellation_Date__c != null 
                                                     and ccrz__CCOrder__c != null 
                                                     and ccrz__CCOrderItem__c != null];
            System.debug(subList.size());
            
            Test.startTest();
            
            OSM_SW_CancelSubscriptionBatch obj = new OSM_SW_CancelSubscriptionBatch();
            DataBase.executeBatch(obj); 
            
            Test.stopTest();
        }
    } 
    
    
    
}