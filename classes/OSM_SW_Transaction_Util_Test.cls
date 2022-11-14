//This is the test class of OSM_SW_Transaction_Util
////MP-661 Updated By Singaiah 05-04-2022
//Updated by Subbu
@isTest
public class OSM_SW_Transaction_Util_Test 
{
    static testMethod void testFetchOrderAndOrderItems()
    {
        /*TestProductSetupReq testProductSetupReq = OSM_TestDataCreationUtility.populatedTestProductSetupReq();

TestProductSetupRes testProductSetupRes = OSM_TestDataCreationUtility.createProductSetUp(testProductSetupReq);
TestCompletedTransactionSetUpRes testCompletedTransactionSetUpRes = OSM_TestDataCreationUtility.createCompletedTransactionFlowTestData(testProductSetupRes, 210.00, 10.00);*/
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
        
        System.Runas(transecRes.objSetupDate.loggedInUser){
            test.startTest();
            
            System.debug('transecRes: '+transecRes);
            
            
            List<Id> idList = new List<Id>();
            idList.add(transecRes.order.ID);
            
            List<Id> orderItemIdList = new List<Id>();
            orderItemIdList.add(transecRes.orderItem.ID); 
            
            List<String> accountList=new List<String>();
            account a=transecRes.objSetupDate.account;
            a.Name = null;
            accountList.add(a.id); 
            
            //subscription list
            List<id> subList=new List<id>();
            OSM_Order_Subscription__c  orderSub1=transecRes.orderSubscriptionjunction;
            ccrz__E_Subscription__c sub1=transecRes.subscription;
            subList.add(sub1.id);
            
            OSM_SW_Transaction_Util.fetchOrderAndOrderItems(idList);
            
            OSM_SW_Transaction_Util.fetchActiveSubscriptionForAccount(String.valueOf(transecRes.objSetupDate.account.Id),idList);
            
            idList.add(transecRes.objSetupDate.account.ID);        
            OSM_SW_Transaction_Util.fetchActiveSubscriptionForInvoiceForAccount(idList);
            
            OSM_SW_Transaction_Util.fetchActiveSubscriptionForAccountWithoutFreeTrial(idList);
            
            OSM_SW_Transaction_Util.fetchAllOrderInfoForSubscriptions(idList);
            
            OSM_SW_Transaction_Util.fetchAllOrderInfoForSubscriptionsWithOneTime(subList);
            
            OSM_SW_Transaction_Util.createOrderSubscriptionJunction(orderItemIdList);
            OSM_SW_Transaction_Util.fetchAllOrderInfoForSubscriptions(subList);
            OSM_SW_Transaction_Util.updateAccountFieldsForAllOperations(accountList,'Order_Placed');
            OSM_SW_Transaction_Util.updateAccountFieldsForAllOperations(accountList,'Revoke_Invoice');
            OSM_SW_Transaction_Util.updateAccountFieldsForAllOperations(accountList,'OSM_Subscription_Expiration_Process');
            OSM_SW_Transaction_Util.updateAccountFieldsForAllOperations(accountList,'Cancelled');
            OSM_SW_Transaction_Util.updateAccountFieldsForAllOperations(accountList,' ');
            OSM_SW_Transaction_Util.updateAccountFieldsForAllOperations(accountList,'Success');
            OSM_SW_Transaction_Util.updateAccountFieldsForAllOperations(accountList,'Success');
            OSM_SW_Transaction_Util.updateAccountFieldsForAllOperations(accountList,'OSM Invoice Payment');
            OSM_SW_Transaction_Util.updateAccountFieldsForAllOperations(accountList,'Recurring_InvoiceCreation');
            OSM_SW_Transaction_Util.updateAccountFieldsForAllOperations(accountList,'Recurring_InvoiceCreation');
            OSM_SW_Transaction_Util.updateAccountFieldsForAllOperations(accountList,'Recurring_InvoiceCreation');
           
            /*Account a123 = new Account();
            accountList.add('do');
            OSM_SW_Transaction_Util.updateAccountFieldsForAllOperations(accountList,'null');*/
            
            test.stopTest();
        } 
        
    }
    
    static testMethod void test2()
    {
    List<String> alist=new List<String>();
        account acc= new account(name='test');
        acc.OSM_Preferred_Billing_Frequency_Lock__c=false;
                      acc.OSM_Preferred_Payment_Method__c='';
                      acc.OSM_Preferred_Billing_Frequency__c='';
                      acc.Is_Active_Subscription_Exists__c=false;
                      acc.Next_Invoice_Generation_Date__c=null;
                      insert acc;
        alist.add(acc.Id);
            List<ccrz__E_Subscription__c> esub= new List<ccrz__E_Subscription__c>();
            ccrz__E_Subscription__c su=new ccrz__E_Subscription__c();
            List<OSM_Integration_Log__c> il = new List<OSM_Integration_Log__c>();
            esub.add(su);
            system.debug('CHECK=='+su.OSM_Order_Subscriptions__r);
            OSM_SW_Transaction_Util.populateAccountFields(esub,acc,'Success',il);
            List<OSM_Integration_Log__c> il2 = new List<OSM_Integration_Log__c>();
            OSM_SW_Transaction_Util.updateAccountFields(alist,'Success',il2);
    }
}