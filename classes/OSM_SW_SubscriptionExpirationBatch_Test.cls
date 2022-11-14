//Update by Subbu to fix deployment issue
//Update by Swetha 
//Subbu updated again
@isTest
public class OSM_SW_SubscriptionExpirationBatch_Test{
    static testMethod void tetsMethod1(){
        
        
        /*TestProductSetupReq testReq = new TestProductSetupReq();
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
TestProductSetupRes objResponseProductSetup = new TestProductSetupRes();
objResponseProductSetup = OSM_TestDataCreationUtility.createProductSetUp(testReq);
System.debug('objResponseProductSetup: '+objResponseProductSetup);


TestCompletedTransactionSetUpRes transecRes = new TestCompletedTransactionSetUpRes();
transecRes = OSM_TestDataCreationUtility.createCompletedTransactionFlowTestData(objResponseProductSetup, 40, 6);
System.debug('transecRes: '+transecRes);
ccrz__E_Subscription__c sub = transecRes.subscription;
sub.OSM_Subscription_End_Date__c = system.today()-1; 
sub.ccrz__Quantity__c= 2;
sub.ccrz__SubscriptionStatus__c = 'Active';
update sub;*/
        
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
        System.debug('transecRes: '+transecRes);
        
        OSM_Integration_Log__c log = new OSM_Integration_Log__c();
        log.Service_Name__c = 'Scheduled: OSM_Subscription_Expiration_Process';
        log.Status__c = 'Processed';
        //  insert log;
        User u1 = [SELECT id from User WHERE Id =: Userinfo.getUserId() LIMIT 1];
        
        System.runas(u1)
        {
            ccrz__E_Subscription__c objSubsc = new ccrz__E_Subscription__c();
            objSubsc.Id = transecRes.subscription.Id;
            objSubsc.OSM_Subscription_End_Date__c = System.now().addDays(-1);
            update objSubsc;
            
            
            ccrz__E_Subscription__c objSubsc2 = new ccrz__E_Subscription__c();
            objSubsc2 = transecRes.subscription.clone(false,false,false,false);
            objSubsc2.ccrz__Quantity__c = 1;
            objSubsc2.ccrz__SubscriptionStatus__c =  'Expired';
            objSubsc2.OSM_Subscription_End_Date__c = System.now().addDays(10);
            objSubsc2.ccrz__SubscriptionStartDate__c = System.now();
            insert objSubsc2;
            
            ccrz__E_Subscription__c objSubsc1 = new ccrz__E_Subscription__c();
            objSubsc1 = transecRes.subscription.clone(false,false,false,false);
            objSubsc1.ccrz__Quantity__c = 1;
            objSubsc1.ccrz__SubscriptionStatus__c = Label.OSM_Subscription_Status_Renew;
            objSubsc1.OSM_Subscription_End_Date__c = System.now().addDays(10);
            objSubsc1.ccrz__SubscriptionStartDate__c = System.now();
            objSubsc1.Renewed_From_Subscription__c = objSubsc2.Id;
            insert objSubsc1;
            
            OSM_Order_Subscription__c newobb = new OSM_Order_Subscription__c();
            newobb.OSM_CCOrder__c = transecRes.orderSubscriptionjunction.OSM_CCOrder__c;
            newobb.OSM_CCSubscription__c = objSubsc1.Id;
            newobb.Billing_Frequency__c = 'Monthly';
            insert newobb;
            test.StartTest();
            OSM_SW_SubscriptionExpirationBatch batch = new OSM_SW_SubscriptionExpirationBatch();
            database.executebatch(batch);
            OSM_SW_SubscriptionRenewToActiveBatch batch2 = new OSM_SW_SubscriptionRenewToActiveBatch();
            database.executebatch(batch2);
            test.StopTest();
        }
    }
    
    static testMethod void tetsMethodforCancleAPI(){
        
        ccrz__E_Order__c ord = new ccrz__E_Order__c();
        ord.ccrz__OrderNumber__c = 2323444;
        ord.ccrz__OrderStatus__c='Cancellation Pending';
        insert ord;
        
        List<ccrz__E_OrderItem__c >itemList = new list <ccrz__E_OrderItem__c >();
        ccrz__E_OrderItem__c orditem = new ccrz__E_OrderItem__c();
        Set<id> idSet=new set<id>();
        orditem.ccrz__Order__c = ord.id;
        orditem.ccrz__Price__c = 10;
        orditem.ccrz__Quantity__c =1;
        orditem.ccrz__SubAmount__c = 5;
        orditem.ccrz__OrderItemId__c = 'a1N4C000000IYOfUAO';
        orditem.CancelLicenseAPICalled__c=false;
        orditem.OMS_Product__c=true;
        orditem.isRenew__c=false;
        idSet.add(orditem.id);
        itemList.add(orditem);
        insert itemList;
        
        List<ccrz__E_Invoice__c> invoiceList=new List<ccrz__E_Invoice__c>();
        User usr = [Select id from User where Id = :UserInfo.getUserId()];
        List<ccrz__E_AccountGroup__c> accGrpId=TestingUtils.createAccountGroup(1,'TestAccountGroup','none',true);
        List<Account> accId=TestingUtils.createAccount(1,'testAccount',accGrpId[0].id,usr.id,true);
        List<Contact> con=TestingUtils.createContact(1,accId[0].id,usr.id,true);
        ccrz__E_Order__c order=TestingUtils.createOrder(con[0].id,'testOrder',true);
        List<ccrz__E_Invoice__c> cc_Invoice=TestingUtils.createCCInvoices(1,order.id,con[0].id,'Open','cart',true);
        cc_Invoice[0].Recurring_Invoice__c=true;
        cc_Invoice[0].ccrz__BillTo__c=accId[0].id;
        cc_Invoice[0].Payment_Method__c='cc';
        cc_Invoice[0].ccrz__Status__c='Closed';
        invoiceList.add(cc_Invoice[0]);
        update invoiceList;
        
        ccrz__E_TransactionPayment__c transPayment=TestingUtils.createTransactionPayment(ord.id,true);
        transPayment.ccrz__InvoiceAppliedTo__c=invoiceList[0].id;
        transPayment.ccrz__AccountType__c='cc';
        transPayment.Transaction_Status__c='Recurring Payment Success';
        transPayment.ccrz__CCOrder__c=ord.Id;
        
        update transPayment;
        
        test.StartTest();
        OSM_SW_CancelAPIBatch batch = new OSM_SW_CancelAPIBatch (idSet);
        database.executebatch(batch);
        
        test.StopTest();
    }
}