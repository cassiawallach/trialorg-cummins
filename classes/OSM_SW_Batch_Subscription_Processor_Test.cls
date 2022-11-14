//Test Class for the class OSM_SW_Batch_Subscription_Processor
/************************************************
 History
 --------
 VERSION    AUTHOR          DATE            DETAILS
 1.0        Ashish          06/07/2021      Test Class Fixes
 2.0        Subbu	    07/28/2021      MAR-1861
 */
@isTest
public class OSM_SW_Batch_Subscription_Processor_Test 
{
    static testMethod void testMethod1() 
    { 
       TestProductSetupReq testReq = new TestProductSetupReq();
        testReq.permissionSetName = 'OSM_Support_Admin';
        
        testReq.accountGroupName = 'TestingAccountGroup';
        testReq.accountName = 'TestingAccount';
          
        testReq.compositeProductName = 'Connected Diagnostics';
        testReq.compositeProductSKU = 'CG-Lite-004';
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
        
        Profile profile1 = [Select Id, Name from Profile where id =:transecRes.objSetupDate.loggedInUser.ProfileId];
        
        System.debug('TEST User : ' + transecRes.objSetupDate.loggedInUser);
        System.debug('TEST Profile : ' + profile1);
        
        System.Runas(transecRes.objSetupDate.loggedInUser){
        
        Map<id,Account> accountMap=new Map<id,Account>();
        Date CurDate = system.TODAY();
        System.debug('System.today :   ' + CurDate);
        Account acc = transecRes.objSetupDate.account;
        acc.Next_Invoice_Generation_Date__c = CurDate;
        acc.Is_Active_Subscription_Exists__c = true;
        acc.BillingCountry='Canada';
        
        update acc;
        accountMap.put(acc.id,acc);

        List<Account> accList = [Select id, name, CMI_Primary_Contact__c, Next_Invoice_Generation_Date__c, 
                                 OSM_Preferred_Payment_Method__c, 
                                 (
                                     Select id,ccrz__Account__c,ccrz__AccountNumber__c,ccrz__AccountType__c 
                                     from ccrz__TransactionPayments__r 
                                     where ccrz__AccountType__c='po' 
                                     and Transaction_Status__c in ('Order Placed Success','Recurring Payment Success') 
                                     order by createddate desc limit 1
                                 ), 
                                 (
                                     select id  from contacts where IAM_Contact_Status__c='Active'
                                 ) 
                                 from account 
                                 where Next_Invoice_Generation_Date__c =:CurDate 
                                 and Is_Active_Subscription_Exists__c=true 
                                and id = :acc.iD];
        
        System.debug('Account List size Test : ' + accList.size());
        System.debug(accList);
        System.assertEquals(1, accList.size());
        System.debug('list>>>>>>>>'+accList);
        List<String> accIdList = new List<String>();
            accIdList.add(acc.iD);
            
            List<ccrz__E_Subscription__c> subsList = new List<ccrz__E_Subscription__c>([select id,ccrz__InstallmentAddress__c,ccrz__SPT__r.Billing_Display_Name__c,Recurring_Invoice_Start_Date__c,ccrz__Storefront__c,ccrz__RecurringPriceSubAmt__c,ccrz__OrderAddress__c,ccrz__InstallmentCountRemaining__c,Last_Installment_Paid__c,ccrz__Quantity__c,OSM_Subscription_End_Date__c,
                                                                                 ccrz__SubscriptionProduct__c,ccrz__SubscriptionStartDate__c,ccrz__SubscriptionProduct__r.ccrz__SKU__c,ccrz__Account__c,Contact__c,ccrz__CurrencyISOCode__c,
                                                                                 OSM_Free_Trial__c,Subsequent_Next_Invoice_Due_Dt__c,Subsequent_Next_Invoice_Generation_Dt__c,
                                                                                 ccrz__User__c,ccrz__InstallmentLastDate__c,ccrz__InstallmentNextDate__c,Latest_Invoice__c,
                                                                                 Next_Invoice_Generation_Date__c,OSM_Display_Product__c,ccrz__RecurringPrice__c,
                                                                                 ccrz__SPT__c,ccrz__SubscriptionStatus__c from ccrz__E_Subscription__c 
    where  ccrz__InstallmentCountRemaining__c>0 and ccrz__SubscriptionStatus__c='Active' and ccrz__Storefront__c='SoftwareStore' 
    and OSM_Subscription_End_Date__c> :System.Now() and ccrz__SubscriptionStartDate__c< :System.now()   
    and ccrz__Account__c in :accIdList]);
            
            System.debug('Subscription List size Test : ' + accList.size());
            
            OSM_InvoiceLine_And_OrderLine__c objItems = new OSM_InvoiceLine_And_OrderLine__c();
         objItems.OSM_Orders_In_Invoice__c = transecRes.orderInInvoice.Id;
         objItems.Quantity__c = 2;
         objItems.Sales_Amount__c = 2;
         objItems.CC_Invoice_Item__c = transecRes.invoiceItems[0].Id;
         objItems.CC_Order_Item__c = transecRes.orderItem.Id;
         insert objItems;
            
            List<CSS_Integration_Details__c> lstCustomSetting = new List<CSS_Integration_Details__c>(); 
        CSS_Integration_Details__c intDetails = new CSS_Integration_Details__c();
        intDetails.ApplicationName__c = 'OSMVertex';
        intDetails.Name = 'OSMVertex';
        intDetails.End_Point__c = 'https://services-test-oauth.cummins.com/api/oauth/token/cso';
        intDetails.IsActive__c = true;
        intDetails.Key__c = '694a2e07-c2dc-4473-81da-b693866d37b6';
        intDetails.Passcode__c = 'f6e1b39a-ad95-4d12-ab73-148afbfa8dcb';
        
        lstCustomSetting.add(intDetails);
        
        CSS_Integration_Details__c intDetails1 = new CSS_Integration_Details__c();
        intDetails1.ApplicationName__c = 'getVertexQuoteTax';
        intDetails1.Name = 'getVertexQuoteTax';
        intDetails1.AuthEnv__c = 'OSMBolt';
        intDetails1.End_Point__c = 'https://services-test.cummins.com/cso/taxinvoice';
        intDetails1.IsActive__c = true;
        intDetails1.Key__c = 'appSubscription-api-key';
        intDetails1.Method_Type__c = 'GET';
        intDetails1.Passcode__c = '';
        intDetails1.Timeout__c = 120000;
        lstCustomSetting.add(intDetails1);
        
        insert lstCustomSetting;
        
         Contact contact1 = new Contact(
            FirstName = 'Test',
            Lastname = 'McTesty',
            AccountId = acc.Id, Username__c = 'testqwerty123@gmail.com',
            Email = System.now().millisecond() + 'test@test.com',
            recordtypeid=Schema.SObjectType.Contact.getRecordTypeInfosByName().get('IAM').getRecordTypeId()
        );
        insert contact1;
        
         ccrz__E_Cart__c testCart = new ccrz__E_Cart__c();
        testCart.ccrz__Storefront__c = 'Software';
        testCart.ccrz__CartType__c = 'Cart';
        testCart.ccrz__ActiveCart__c = true;
        testCart.ccrz__CartStatus__c = 'Open';
        testCart.ccrz__User__c = UserInfo.getUserId();
        insert testCart;
        
         
        ccrz__E_Order__c testOrder = new ccrz__E_Order__c();
        testOrder.ccrz__Name__c = 'TestOrder';
        testOrder.ccrz__Contact__c = contact1.id;
        testOrder.ccrz__Account__c = acc.Id;
        testOrder.BMS_BranchLocation__c = 'E4';
        testOrder.Order_Source_Type__c = 'OSM';
        testOrder.BMS_OrderRefNumber__c = 12345;
        
        testOrder.ccrz__OriginatedCart__c = testCart.id;
        insert testOrder;
        
        ccrz__E_Invoice__c ccInvoices = new ccrz__E_Invoice__c();

        ccInvoices.ccrz__CCOrder__c = testOrder.id;
        ccInvoices.ccrz__Contact__c = contact1.id;
        ccInvoices.ccrz__CurrencyCode__c = 'USD';
        ccInvoices.ccrz__Status__c = 'Open';
        ccInvoices.ccrz__Storefront__c = 'Software';
        ccInvoices.ccrz__DateIssued__c = System.today().addMonths(2);
        ccInvoices.ccrz__OriginalAmount__c = 200;
        ccInvoices.ccrz__Terms__c = 'TestDataTerms';
        ccInvoices.BMS_PONumber__c = '123456';
        ccInvoices.BMS_InvoiceNumber__c = 123456;
        ccInvoices.Recurring_Intercompany_Generated__c=false;
        ccInvoices.Recurring_Invoice__c=true;
        
        
        insert ccInvoices;
            
            // SUCCESS
            Test.startTest();
            try
            {
            OSM_SW_Batch_Subscription_Processor obj1 = new OSM_SW_Batch_Subscription_Processor();
            obj1.accIdLst = accIdList;
            DataBase.executeBatch(obj1); 
            
             OSM_IntercompanyOfRecurringBatch obj2=new  OSM_IntercompanyOfRecurringBatch();
             DataBase.executeBatch(obj2); 
             
            }
            Catch(Exception ex){}
            Test.stopTest();
            
       } 
    }
    
    static testMethod void testMethod2() 
    {
       TestProductSetupReq testReq = new TestProductSetupReq();
        testReq.permissionSetName = 'OSM_Support_Admin';
        
        testReq.accountGroupName = 'TestingAccountGroup';
        testReq.accountName = 'TestingAccount';
          
        testReq.compositeProductName = 'Connected Diagnostics';
        testReq.compositeProductSKU = 'CG-Lite-004';
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
        
        Profile profile1 = [Select Id, Name from Profile where id =:transecRes.objSetupDate.loggedInUser.ProfileId];
        
        System.debug('TEST User : ' + transecRes.objSetupDate.loggedInUser);
        System.debug('TEST Profile : ' + profile1);
        
        System.Runas(transecRes.objSetupDate.loggedInUser){
        
        Map<id,Account> accountMap=new Map<id,Account>();
        Date CurDate = system.TODAY();
        System.debug('System.today : ' + CurDate);
        Account acc = transecRes.objSetupDate.account;
        acc.Next_Invoice_Generation_Date__c = CurDate;
        acc.Is_Active_Subscription_Exists__c = true;
        
        update acc;
        accountMap.put(acc.id,acc);

        List<Account> accList = [Select id, name, CMI_Primary_Contact__c, Next_Invoice_Generation_Date__c, 
                                 OSM_Preferred_Payment_Method__c, 
                                 (
                                     Select id,ccrz__Account__c,ccrz__AccountNumber__c,ccrz__AccountType__c 
                                     from ccrz__TransactionPayments__r 
                                     where ccrz__AccountType__c='po' 
                                     and Transaction_Status__c in ('Order Placed Success','Recurring Payment Success') 
                                     order by createddate desc limit 1
                                 ), 
                                 (
                                     select id  from contacts where IAM_Contact_Status__c='Active'
                                 ) 
                                 from account 
                                 where Next_Invoice_Generation_Date__c =:CurDate 
                                 and Is_Active_Subscription_Exists__c=true 
                                and id = :acc.iD];
        
        System.debug('Account List size Test : ' + accList.size());
        System.debug(accList);
        System.assertEquals(1, accList.size());
        System.debug('list>>>>>>>>'+accList);
        List<String> accIdList = new List<String>();
            accIdList.add(acc.iD);
            
            List<ccrz__E_Subscription__c> subsList = new List<ccrz__E_Subscription__c>([select id,ccrz__InstallmentAddress__c,ccrz__SPT__r.Billing_Display_Name__c,Recurring_Invoice_Start_Date__c,ccrz__Storefront__c,ccrz__RecurringPriceSubAmt__c,ccrz__OrderAddress__c,ccrz__InstallmentCountRemaining__c,Last_Installment_Paid__c,ccrz__Quantity__c,OSM_Subscription_End_Date__c,
                                                                                 ccrz__SubscriptionProduct__c,ccrz__SubscriptionStartDate__c,ccrz__SubscriptionProduct__r.ccrz__SKU__c,ccrz__Account__c,Contact__c,ccrz__CurrencyISOCode__c,
                                                                                 OSM_Free_Trial__c,Subsequent_Next_Invoice_Due_Dt__c,Subsequent_Next_Invoice_Generation_Dt__c,
                                                                                 ccrz__User__c,ccrz__InstallmentLastDate__c,ccrz__InstallmentNextDate__c,Latest_Invoice__c,
                                                                                 Next_Invoice_Generation_Date__c,OSM_Display_Product__c,ccrz__RecurringPrice__c,
                                                                                 ccrz__SPT__c,ccrz__SubscriptionStatus__c from ccrz__E_Subscription__c 
    where  ccrz__InstallmentCountRemaining__c>0 and ccrz__SubscriptionStatus__c='Active' and ccrz__Storefront__c='SoftwareStore' 
    and OSM_Subscription_End_Date__c> :System.Now() and ccrz__SubscriptionStartDate__c< :System.now()   
    and ccrz__Account__c in :accIdList]);
            
            System.debug('Subscription List size Test : ' + accList.size());
            
            List<CSS_Integration_Details__c> lstCustomSetting = new List<CSS_Integration_Details__c>(); 
        CSS_Integration_Details__c intDetails = new CSS_Integration_Details__c();
        intDetails.ApplicationName__c = 'OSMVertex';
        intDetails.Name = 'OSMVertex';
        intDetails.End_Point__c = 'https://services-test-oauth.cummins.com/api/oauth/token/cso';
        intDetails.IsActive__c = true;
        intDetails.Key__c = '694a2e07-c2dc-4473-81da-b693866d37b6';
        intDetails.Passcode__c = 'f6e1b39a-ad95-4d12-ab73-148afbfa8dcb';
        
        lstCustomSetting.add(intDetails);
        
        CSS_Integration_Details__c intDetails1 = new CSS_Integration_Details__c();
        intDetails1.ApplicationName__c = 'getVertexQuoteTax';
        intDetails1.Name = 'getVertexQuoteTax';
        intDetails1.AuthEnv__c = 'OSMBolt';
        intDetails1.End_Point__c = 'https://services-test.cummins.com/cso/taxinvoice';
        intDetails1.IsActive__c = true;
        intDetails1.Key__c = 'appSubscription-api-key';
        intDetails1.Method_Type__c = 'GET';
        intDetails1.Passcode__c = '';
        intDetails1.Timeout__c = 120000;
        lstCustomSetting.add(intDetails1);
        
        insert lstCustomSetting;
        
            
            // Failure 1
            Test.startTest();
            
            OSM_SW_Batch_Subscription_Processor obj2 = new OSM_SW_Batch_Subscription_Processor();
            obj2.accIdLst = accIdList;
            obj2.testNumber = 'test1';
            DataBase.executeBatch(obj2); 
            
            Test.stopTest();
            
            
       } 
    }
    
    static testMethod void testMethod3() 
    {
       TestProductSetupReq testReq = new TestProductSetupReq();
        testReq.permissionSetName = 'OSM_Support_Admin';
        
        testReq.accountGroupName = 'TestingAccountGroup';
        testReq.accountName = 'TestingAccount';
          
        testReq.compositeProductName = 'Connected Diagnostics';
        testReq.compositeProductSKU = 'CG-Lite-004';
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
        
        Profile profile1 = [Select Id, Name from Profile where id =:transecRes.objSetupDate.loggedInUser.ProfileId];
        
        System.debug('TEST User : ' + transecRes.objSetupDate.loggedInUser);
        System.debug('TEST Profile : ' + profile1);
        
        System.Runas(transecRes.objSetupDate.loggedInUser){
        
        Map<id,Account> accountMap=new Map<id,Account>();
        Date CurDate = system.TODAY();
        System.debug('System.today : ' + CurDate);
        Account acc = transecRes.objSetupDate.account;
        acc.Next_Invoice_Generation_Date__c = CurDate;
        acc.Is_Active_Subscription_Exists__c = true;
        
        update acc;
        accountMap.put(acc.id,acc);

        List<Account> accList = [Select id, name, CMI_Primary_Contact__c, Next_Invoice_Generation_Date__c, 
                                 OSM_Preferred_Payment_Method__c, 
                                 (
                                     Select id,ccrz__Account__c,ccrz__AccountNumber__c,ccrz__AccountType__c 
                                     from ccrz__TransactionPayments__r 
                                     where ccrz__AccountType__c='po' 
                                     and Transaction_Status__c in ('Order Placed Success','Recurring Payment Success') 
                                     order by createddate desc limit 1
                                 ), 
                                 (
                                     select id  from contacts where IAM_Contact_Status__c='Active'
                                 ) 
                                 from account 
                                 where Next_Invoice_Generation_Date__c =:CurDate 
                                 and Is_Active_Subscription_Exists__c=true 
                                and id = :acc.iD];
        
        System.debug('Account List size Test : ' + accList.size());
        System.debug(accList);
        System.assertEquals(1, accList.size());
        System.debug('list>>>>>>>>'+accList);
        List<String> accIdList = new List<String>();
            accIdList.add(acc.iD);
            
            List<ccrz__E_Subscription__c> subsList = new List<ccrz__E_Subscription__c>([select id,ccrz__InstallmentAddress__c,ccrz__SPT__r.Billing_Display_Name__c,Recurring_Invoice_Start_Date__c,ccrz__Storefront__c,ccrz__RecurringPriceSubAmt__c,ccrz__OrderAddress__c,ccrz__InstallmentCountRemaining__c,Last_Installment_Paid__c,ccrz__Quantity__c,OSM_Subscription_End_Date__c,
                                                                                 ccrz__SubscriptionProduct__c,ccrz__SubscriptionStartDate__c,ccrz__SubscriptionProduct__r.ccrz__SKU__c,ccrz__Account__c,Contact__c,ccrz__CurrencyISOCode__c,
                                                                                 OSM_Free_Trial__c,Subsequent_Next_Invoice_Due_Dt__c,Subsequent_Next_Invoice_Generation_Dt__c,
                                                                                 ccrz__User__c,ccrz__InstallmentLastDate__c,ccrz__InstallmentNextDate__c,Latest_Invoice__c,
                                                                                 Next_Invoice_Generation_Date__c,OSM_Display_Product__c,ccrz__RecurringPrice__c,
                                                                                 ccrz__SPT__c,ccrz__SubscriptionStatus__c from ccrz__E_Subscription__c 
    where  ccrz__InstallmentCountRemaining__c>0 and ccrz__SubscriptionStatus__c='Active' and ccrz__Storefront__c='SoftwareStore' 
    and OSM_Subscription_End_Date__c> :System.Now() and ccrz__SubscriptionStartDate__c< :System.now()   
    and ccrz__Account__c in :accIdList]);
            
            System.debug('Subscription List size Test : ' + accList.size());
            
            List<CSS_Integration_Details__c> lstCustomSetting = new List<CSS_Integration_Details__c>(); 
        CSS_Integration_Details__c intDetails = new CSS_Integration_Details__c();
        intDetails.ApplicationName__c = 'OSMVertex';
        intDetails.Name = 'OSMVertex';
        intDetails.End_Point__c = 'https://services-test-oauth.cummins.com/api/oauth/token/cso';
        intDetails.IsActive__c = true;
        intDetails.Key__c = '694a2e07-c2dc-4473-81da-b693866d37b6';
        intDetails.Passcode__c = 'f6e1b39a-ad95-4d12-ab73-148afbfa8dcb';
        
        lstCustomSetting.add(intDetails);
        
        CSS_Integration_Details__c intDetails1 = new CSS_Integration_Details__c();
        intDetails1.ApplicationName__c = 'getVertexQuoteTax';
        intDetails1.Name = 'getVertexQuoteTax';
        intDetails1.AuthEnv__c = 'OSMBolt';
        intDetails1.End_Point__c = 'https://services-test.cummins.com/cso/taxinvoice';
        intDetails1.IsActive__c = true;
        intDetails1.Key__c = 'appSubscription-api-key';
        intDetails1.Method_Type__c = 'GET';
        intDetails1.Passcode__c = '';
        intDetails1.Timeout__c = 120000;
        lstCustomSetting.add(intDetails1);
        
        insert lstCustomSetting;
        
            // Failure 2
            Test.startTest();
            
            OSM_SW_Batch_Subscription_Processor obj3 = new OSM_SW_Batch_Subscription_Processor();
            obj3.accIdLst = accIdList;
            obj3.testNumber = 'test2';
            DataBase.executeBatch(obj3); 
            
            Test.stopTest();
       } 
    }
    
    static testMethod void testMethod4() 
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
        
        Profile profile1 = [Select Id, Name from Profile where id =:transecRes.objSetupDate.loggedInUser.ProfileId];
        
        System.debug('TEST User : ' + transecRes.objSetupDate.loggedInUser);
        System.debug('TEST Profile : ' + profile1);
        
        System.Runas(transecRes.objSetupDate.loggedInUser){
        
        Map<id,Account> accountMap=new Map<id,Account>();
        Date CurDate = system.TODAY();
        System.debug('System.today : ' + CurDate);
        Account acc = transecRes.objSetupDate.account;
        acc.Next_Invoice_Generation_Date__c = CurDate;
        acc.Is_Active_Subscription_Exists__c = true;
        acc.OSM_Preferred_Payment_IsBolt_PO__c = true;
        acc.OSM_Preferred_Payment_Method__c = 'po';
        acc.Bolt_Credit_Hold__c = true;
        
        update acc;
        accountMap.put(acc.id,acc);

        List<Account> accList = [Select id, name, CMI_Primary_Contact__c, Next_Invoice_Generation_Date__c, 
                                 OSM_Preferred_Payment_Method__c, 
                                 (
                                     Select id,ccrz__Account__c,ccrz__AccountNumber__c,ccrz__AccountType__c 
                                     from ccrz__TransactionPayments__r 
                                     where ccrz__AccountType__c='po' 
                                     and Transaction_Status__c in ('Order Placed Success','Recurring Payment Success') 
                                     order by createddate desc limit 1
                                 ), 
                                 (
                                     select id  from contacts where IAM_Contact_Status__c='Active'
                                 ) 
                                 from account 
                                 where Next_Invoice_Generation_Date__c =:CurDate 
                                 and Is_Active_Subscription_Exists__c=true 
                                and id = :acc.iD];
        
        System.debug('Account List size Test : ' + accList.size());
        System.debug(accList);
        System.assertEquals(1, accList.size());
        System.debug('list>>>>>>>>'+accList);
        List<String> accIdList = new List<String>();
            accIdList.add(acc.iD);
            
            List<ccrz__E_Subscription__c> subsList = new List<ccrz__E_Subscription__c>([select id,ccrz__InstallmentAddress__c,ccrz__SPT__r.Billing_Display_Name__c,Recurring_Invoice_Start_Date__c,ccrz__Storefront__c,ccrz__RecurringPriceSubAmt__c,ccrz__OrderAddress__c,ccrz__InstallmentCountRemaining__c,Last_Installment_Paid__c,ccrz__Quantity__c,OSM_Subscription_End_Date__c,
                                                                                 ccrz__SubscriptionProduct__c,ccrz__SubscriptionStartDate__c,ccrz__SubscriptionProduct__r.ccrz__SKU__c,ccrz__Account__c,Contact__c,ccrz__CurrencyISOCode__c,
                                                                                 OSM_Free_Trial__c,Subsequent_Next_Invoice_Due_Dt__c,Subsequent_Next_Invoice_Generation_Dt__c,
                                                                                 ccrz__User__c,ccrz__InstallmentLastDate__c,ccrz__InstallmentNextDate__c,Latest_Invoice__c,
                                                                                 Next_Invoice_Generation_Date__c,OSM_Display_Product__c,ccrz__RecurringPrice__c,
                                                                                 ccrz__SPT__c,ccrz__SubscriptionStatus__c from ccrz__E_Subscription__c 
    where  ccrz__InstallmentCountRemaining__c>0 and ccrz__SubscriptionStatus__c='Active' and ccrz__Storefront__c='SoftwareStore' 
    and OSM_Subscription_End_Date__c> :System.Now() and ccrz__SubscriptionStartDate__c< :System.now()   
    and ccrz__Account__c in :accIdList]);
            
            System.debug('Subscription List size Test : ' + accList.size());
            
            List<CSS_Integration_Details__c> lstCustomSetting = new List<CSS_Integration_Details__c>(); 
        CSS_Integration_Details__c intDetails = new CSS_Integration_Details__c();
        intDetails.ApplicationName__c = 'OSMVertex';
        intDetails.Name = 'OSMVertex';
        intDetails.End_Point__c = 'https://services-test-oauth.cummins.com/api/oauth/token/cso';
        intDetails.IsActive__c = true;
        intDetails.Key__c = '694a2e07-c2dc-4473-81da-b693866d37b6';
        intDetails.Passcode__c = 'f6e1b39a-ad95-4d12-ab73-148afbfa8dcb';
        
        lstCustomSetting.add(intDetails);
        
        CSS_Integration_Details__c intDetails1 = new CSS_Integration_Details__c();
        intDetails1.ApplicationName__c = 'getVertexQuoteTax';
        intDetails1.Name = 'getVertexQuoteTax';
        intDetails1.AuthEnv__c = 'OSMBolt';
        intDetails1.End_Point__c = 'https://services-test.cummins.com/cso/taxinvoice';
        intDetails1.IsActive__c = true;
        intDetails1.Key__c = 'appSubscription-api-key';
        intDetails1.Method_Type__c = 'GET';
        intDetails1.Passcode__c = '';
        intDetails1.Timeout__c = 120000;
        lstCustomSetting.add(intDetails1);
        
        insert lstCustomSetting;
        
            
            // Failure 2
            Test.startTest();
            
            OSM_SW_Batch_Subscription_Processor obj3 = new OSM_SW_Batch_Subscription_Processor();
            obj3.accIdLst = accIdList;
            obj3.testNumber = 'test3';
            DataBase.executeBatch(obj3); 
            
            Test.stopTest();
       } 
    }
    
    static testMethod void testMethod5() 
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
        
        Profile profile1 = [Select Id, Name from Profile where id =:transecRes.objSetupDate.loggedInUser.ProfileId];
        
        System.debug('TEST User : ' + transecRes.objSetupDate.loggedInUser);
        System.debug('TEST Profile : ' + profile1);
        
        System.Runas(transecRes.objSetupDate.loggedInUser){
        
        Map<id,Account> accountMap=new Map<id,Account>();
        Date CurDate = system.TODAY();
        System.debug('System.today : ' + CurDate);
        Account acc = transecRes.objSetupDate.account;
        acc.Next_Invoice_Generation_Date__c = CurDate;
        acc.Is_Active_Subscription_Exists__c = true;
        
        update acc;
        accountMap.put(acc.id,acc);

        List<Account> accList = [Select id, name, CMI_Primary_Contact__c, Next_Invoice_Generation_Date__c, 
                                 OSM_Preferred_Payment_Method__c, 
                                 (
                                     Select id,ccrz__Account__c,ccrz__AccountNumber__c,ccrz__AccountType__c 
                                     from ccrz__TransactionPayments__r 
                                     where ccrz__AccountType__c='po' 
                                     and Transaction_Status__c in ('Order Placed Success','Recurring Payment Success') 
                                     order by createddate desc limit 1
                                 ), 
                                 (
                                     select id  from contacts where IAM_Contact_Status__c='Active'
                                 ) 
                                 from account 
                                 where Next_Invoice_Generation_Date__c =:CurDate 
                                 and Is_Active_Subscription_Exists__c=true 
                                and id = :acc.iD];
        
        System.debug('Account List size Test : ' + accList.size());
        System.debug(accList);
        System.assertEquals(1, accList.size());
        System.debug('list>>>>>>>>'+accList);
        List<String> accIdList = new List<String>();
            accIdList.add(acc.iD);
            
            List<ccrz__E_Subscription__c> subsList = new List<ccrz__E_Subscription__c>([select id,ccrz__InstallmentAddress__c,ccrz__SPT__r.Billing_Display_Name__c,Recurring_Invoice_Start_Date__c,ccrz__Storefront__c,ccrz__RecurringPriceSubAmt__c,ccrz__OrderAddress__c,ccrz__InstallmentCountRemaining__c,Last_Installment_Paid__c,ccrz__Quantity__c,OSM_Subscription_End_Date__c,
                                                                                 ccrz__SubscriptionProduct__c,ccrz__SubscriptionStartDate__c,ccrz__SubscriptionProduct__r.ccrz__SKU__c,ccrz__Account__c,Contact__c,ccrz__CurrencyISOCode__c,
                                                                                 OSM_Free_Trial__c,Subsequent_Next_Invoice_Due_Dt__c,Subsequent_Next_Invoice_Generation_Dt__c,
                                                                                 ccrz__User__c,ccrz__InstallmentLastDate__c,ccrz__InstallmentNextDate__c,Latest_Invoice__c,
                                                                                 Next_Invoice_Generation_Date__c,OSM_Display_Product__c,ccrz__RecurringPrice__c,
                                                                                 ccrz__SPT__c,ccrz__SubscriptionStatus__c from ccrz__E_Subscription__c 
    where  ccrz__InstallmentCountRemaining__c>0 and ccrz__SubscriptionStatus__c='Active' and ccrz__Storefront__c='SoftwareStore' 
    and OSM_Subscription_End_Date__c> :System.Now() and ccrz__SubscriptionStartDate__c< :System.now()   
    and ccrz__Account__c in :accIdList]);
            
            System.debug('Subscription List size Test : ' + subsList.size());
            
            subsList[0].ccrz__CurrencyISOCode__c = null;
            update subsList;
            // Failure 2
            
            List<CSS_Integration_Details__c> lstCustomSetting = new List<CSS_Integration_Details__c>(); 
        CSS_Integration_Details__c intDetails = new CSS_Integration_Details__c();
        intDetails.ApplicationName__c = 'OSMVertex';
        intDetails.Name = 'OSMVertex';
        intDetails.End_Point__c = 'https://services-test-oauth.cummins.com/api/oauth/token/cso';
        intDetails.IsActive__c = true;
        intDetails.Key__c = '694a2e07-c2dc-4473-81da-b693866d37b6';
        intDetails.Passcode__c = 'f6e1b39a-ad95-4d12-ab73-148afbfa8dcb';
        
        lstCustomSetting.add(intDetails);
        
        CSS_Integration_Details__c intDetails1 = new CSS_Integration_Details__c();
        intDetails1.ApplicationName__c = 'getVertexQuoteTax';
        intDetails1.Name = 'getVertexQuoteTax';
        intDetails1.AuthEnv__c = 'OSMBolt';
        intDetails1.End_Point__c = 'https://services-test.cummins.com/cso/taxinvoice';
        intDetails1.IsActive__c = true;
        intDetails1.Key__c = 'appSubscription-api-key';
        intDetails1.Method_Type__c = 'GET';
        intDetails1.Passcode__c = '';
        intDetails1.Timeout__c = 120000;
        lstCustomSetting.add(intDetails1);
        
        insert lstCustomSetting;
        
            Test.startTest();
            
            OSM_SW_Batch_Subscription_Processor obj3 = new OSM_SW_Batch_Subscription_Processor();
            obj3.accIdLst = accIdList;
            obj3.testNumber = 'test4';
            DataBase.executeBatch(obj3); 
            
            Test.stopTest();
       } 
    }
    
    static testMethod void testMethod6() 
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
        
        Profile profile1 = [Select Id, Name from Profile where id =:transecRes.objSetupDate.loggedInUser.ProfileId];
        
        System.debug('TEST User : ' + transecRes.objSetupDate.loggedInUser);
        System.debug('TEST Profile : ' + profile1);
        
        System.Runas(transecRes.objSetupDate.loggedInUser){
        
        Map<id,Account> accountMap=new Map<id,Account>();
        Date CurDate = system.TODAY();
        System.debug('System.today : ' + CurDate);
        Account acc = transecRes.objSetupDate.account;
        acc.Next_Invoice_Generation_Date__c = CurDate;
        acc.Is_Active_Subscription_Exists__c = true;
        
        update acc;
        accountMap.put(acc.id,acc);

        List<Account> accList = [Select id, name, CMI_Primary_Contact__c, Next_Invoice_Generation_Date__c, 
                                 OSM_Preferred_Payment_Method__c, 
                                 (
                                     Select id,ccrz__Account__c,ccrz__AccountNumber__c,ccrz__AccountType__c 
                                     from ccrz__TransactionPayments__r 
                                     where ccrz__AccountType__c='po' 
                                     and Transaction_Status__c in ('Order Placed Success','Recurring Payment Success') 
                                     order by createddate desc limit 1
                                 ), 
                                 (
                                     select id  from contacts where IAM_Contact_Status__c='Active'
                                 ) 
                                 from account 
                                 where Next_Invoice_Generation_Date__c =:CurDate 
                                 and Is_Active_Subscription_Exists__c=true 
                                and id = :acc.iD];
        
        System.debug('Account List size Test : ' + accList.size());
        System.debug(accList);
        System.assertEquals(1, accList.size());
        System.debug('list>>>>>>>>'+accList);
        List<String> accIdList = new List<String>();
            accIdList.add(acc.iD);
            
            List<ccrz__E_Subscription__c> subsList = new List<ccrz__E_Subscription__c>([select id,ccrz__InstallmentAddress__c,ccrz__SPT__r.Billing_Display_Name__c,Recurring_Invoice_Start_Date__c,ccrz__Storefront__c,ccrz__RecurringPriceSubAmt__c,ccrz__OrderAddress__c,ccrz__InstallmentCountRemaining__c,Last_Installment_Paid__c,ccrz__Quantity__c,OSM_Subscription_End_Date__c,
                                                                                 ccrz__SubscriptionProduct__c,ccrz__SubscriptionStartDate__c,ccrz__SubscriptionProduct__r.ccrz__SKU__c,ccrz__Account__c,Contact__c,ccrz__CurrencyISOCode__c,
                                                                                 OSM_Free_Trial__c,Subsequent_Next_Invoice_Due_Dt__c,Subsequent_Next_Invoice_Generation_Dt__c,
                                                                                 ccrz__User__c,ccrz__InstallmentLastDate__c,ccrz__InstallmentNextDate__c,Latest_Invoice__c,
                                                                                 Next_Invoice_Generation_Date__c,OSM_Display_Product__c,ccrz__RecurringPrice__c,
                                                                                 ccrz__SPT__c,ccrz__SubscriptionStatus__c from ccrz__E_Subscription__c 
    where  ccrz__InstallmentCountRemaining__c>0 and ccrz__SubscriptionStatus__c='Active' and ccrz__Storefront__c='SoftwareStore' 
    and OSM_Subscription_End_Date__c> :System.Now() and ccrz__SubscriptionStartDate__c< :System.now()   
    and ccrz__Account__c in :accIdList]);
            
            System.debug('Subscription List size Test : ' + subsList.size());
            
            subsList[0].Next_Invoice_Generation_Date__c = null;
            update subsList;
            
            List<CSS_Integration_Details__c> lstCustomSetting = new List<CSS_Integration_Details__c>(); 
        CSS_Integration_Details__c intDetails = new CSS_Integration_Details__c();
        intDetails.ApplicationName__c = 'OSMVertex';
        intDetails.Name = 'OSMVertex';
        intDetails.End_Point__c = 'https://services-test-oauth.cummins.com/api/oauth/token/cso';
        intDetails.IsActive__c = true;
        intDetails.Key__c = '694a2e07-c2dc-4473-81da-b693866d37b6';
        intDetails.Passcode__c = 'f6e1b39a-ad95-4d12-ab73-148afbfa8dcb';
        
        lstCustomSetting.add(intDetails);
        
        CSS_Integration_Details__c intDetails1 = new CSS_Integration_Details__c();
        intDetails1.ApplicationName__c = 'getVertexQuoteTax';
        intDetails1.Name = 'getVertexQuoteTax';
        intDetails1.AuthEnv__c = 'OSMBolt';
        intDetails1.End_Point__c = 'https://services-test.cummins.com/cso/taxinvoice';
        intDetails1.IsActive__c = true;
        intDetails1.Key__c = 'appSubscription-api-key';
        intDetails1.Method_Type__c = 'GET';
        intDetails1.Passcode__c = '';
        intDetails1.Timeout__c = 120000;
        lstCustomSetting.add(intDetails1);
        
        insert lstCustomSetting;
        
            // Failure 2
            Test.startTest();
            
            OSM_SW_Batch_Subscription_Processor obj3 = new OSM_SW_Batch_Subscription_Processor();
            obj3.accIdLst = accIdList;
            obj3.testNumber = 'test5';
            DataBase.executeBatch(obj3); 
            
            Test.stopTest();
       } 
    }
    
    static testMethod void testMethod7() 
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
        
        Profile profile1 = [Select Id, Name from Profile where id =:transecRes.objSetupDate.loggedInUser.ProfileId];
        
        System.debug('TEST User : ' + transecRes.objSetupDate.loggedInUser);
        System.debug('TEST Profile : ' + profile1);
        
        System.Runas(transecRes.objSetupDate.loggedInUser){
        
        Map<id,Account> accountMap=new Map<id,Account>();
        Date CurDate = system.TODAY();
        System.debug('System.today : ' + CurDate);
        Account acc = transecRes.objSetupDate.account;
        acc.Next_Invoice_Generation_Date__c = CurDate;
        acc.Is_Active_Subscription_Exists__c = true;
        acc.OSM_Preferred_Payment_IsBolt_PO__c = true;
        acc.OSM_Preferred_Payment_Method__c = 'po';
        acc.Bolt_Credit_Hold__c = true;
        
        update acc;
        accountMap.put(acc.id,acc);

        List<Account> accList = [Select id, name, CMI_Primary_Contact__c, Next_Invoice_Generation_Date__c, 
                                 OSM_Preferred_Payment_Method__c, 
                                 (
                                     Select id,ccrz__Account__c,ccrz__AccountNumber__c,ccrz__AccountType__c 
                                     from ccrz__TransactionPayments__r 
                                     where ccrz__AccountType__c='po' 
                                     and Transaction_Status__c in ('Order Placed Success','Recurring Payment Success') 
                                     order by createddate desc limit 1
                                 ), 
                                 (
                                     select id  from contacts where IAM_Contact_Status__c='Active'
                                 ) 
                                 from account 
                                 where Next_Invoice_Generation_Date__c =:CurDate 
                                 and Is_Active_Subscription_Exists__c=true 
                                and id = :acc.iD];
        
        System.debug('Account List size Test : ' + accList.size());
        System.debug(accList);
        System.assertEquals(1, accList.size());
        System.debug('list>>>>>>>>'+accList);
        List<String> accIdList = new List<String>();
            accIdList.add(acc.iD);
            
            List<ccrz__E_Subscription__c> subsList = new List<ccrz__E_Subscription__c>([select id,ccrz__InstallmentAddress__c,ccrz__SPT__r.Billing_Display_Name__c,Recurring_Invoice_Start_Date__c,ccrz__Storefront__c,ccrz__RecurringPriceSubAmt__c,ccrz__OrderAddress__c,ccrz__InstallmentCountRemaining__c,Last_Installment_Paid__c,ccrz__Quantity__c,OSM_Subscription_End_Date__c,
                                                                                 ccrz__SubscriptionProduct__c,ccrz__SubscriptionStartDate__c,ccrz__SubscriptionProduct__r.ccrz__SKU__c,ccrz__Account__c,Contact__c,ccrz__CurrencyISOCode__c,
                                                                                 OSM_Free_Trial__c,Subsequent_Next_Invoice_Due_Dt__c,Subsequent_Next_Invoice_Generation_Dt__c,
                                                                                 ccrz__User__c,ccrz__InstallmentLastDate__c,ccrz__InstallmentNextDate__c,Latest_Invoice__c,
                                                                                 Next_Invoice_Generation_Date__c,OSM_Display_Product__c,ccrz__RecurringPrice__c,
                                                                                 ccrz__SPT__c,ccrz__SubscriptionStatus__c from ccrz__E_Subscription__c 
    where  ccrz__InstallmentCountRemaining__c>0 and ccrz__SubscriptionStatus__c='Active' and ccrz__Storefront__c='SoftwareStore' 
    and OSM_Subscription_End_Date__c> :System.Now() and ccrz__SubscriptionStartDate__c< :System.now()   
    and ccrz__Account__c in :accIdList]);
            
            System.debug('Subscription List size Test : ' + subsList.size());
            
            subsList[0].Next_Invoice_Generation_Date__c = null;
            update subsList;
            // Failure 2
            Test.startTest();
            
            OSM_SW_Batch_Subscription_Processor obj3 = new OSM_SW_Batch_Subscription_Processor();
            //obj3.accIdLst = accIdList;
            //obj3.testNumber = 'test5';
            DataBase.executeBatch(obj3); 
            
            Test.stopTest();
       } 
    }
    
    static testMethod void testMethod8() 
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
        
        Profile profile1 = [Select Id, Name from Profile where id =:transecRes.objSetupDate.loggedInUser.ProfileId];
        
        System.debug('TEST User : ' + transecRes.objSetupDate.loggedInUser);
        System.debug('TEST Profile : ' + profile1);
        
        System.Runas(transecRes.objSetupDate.loggedInUser){
        
        Map<id,Account> accountMap=new Map<id,Account>();
        Date CurDate = system.TODAY();
        System.debug('System.today : ' + CurDate);
        Account acc = transecRes.objSetupDate.account;
        acc.Next_Invoice_Generation_Date__c = CurDate-6;
        acc.Is_Active_Subscription_Exists__c = true;
        acc.OSM_Preferred_Payment_IsBolt_PO__c = true;
        acc.OSM_Preferred_Payment_Method__c = 'po';
        acc.Bolt_Credit_Hold__c = true;
        
        update acc;
        accountMap.put(acc.id,acc);

        List<Account> accList = [Select id, name, CMI_Primary_Contact__c, Next_Invoice_Generation_Date__c, 
                                 OSM_Preferred_Payment_Method__c, 
                                 (
                                     Select id,ccrz__Account__c,ccrz__AccountNumber__c,ccrz__AccountType__c 
                                     from ccrz__TransactionPayments__r 
                                     where ccrz__AccountType__c='po' 
                                     and Transaction_Status__c in ('Order Placed Success','Recurring Payment Success') 
                                     order by createddate desc limit 1
                                 ), 
                                 (
                                     select id  from contacts where IAM_Contact_Status__c='Active'
                                 ) 
                                 from account 
                                 where Next_Invoice_Generation_Date__c =:CurDate 
                                 and Is_Active_Subscription_Exists__c=true 
                                and id = :acc.iD];
        
        System.debug('Account List size Test : ' + accList.size());
        System.debug(accList);
        //System.assertEquals(1, accList.size());
        System.debug('list>>>>>>>>'+accList);
        List<String> accIdList = new List<String>();
            accIdList.add(acc.iD);
            
            List<ccrz__E_Subscription__c> subsList = new List<ccrz__E_Subscription__c>([select id,ccrz__InstallmentAddress__c,ccrz__SPT__r.Billing_Display_Name__c,Recurring_Invoice_Start_Date__c,ccrz__Storefront__c,ccrz__RecurringPriceSubAmt__c,ccrz__OrderAddress__c,ccrz__InstallmentCountRemaining__c,Last_Installment_Paid__c,ccrz__Quantity__c,OSM_Subscription_End_Date__c,
                                                                                 ccrz__SubscriptionProduct__c,ccrz__SubscriptionStartDate__c,ccrz__SubscriptionProduct__r.ccrz__SKU__c,ccrz__Account__c,Contact__c,ccrz__CurrencyISOCode__c,
                                                                                 OSM_Free_Trial__c,Subsequent_Next_Invoice_Due_Dt__c,Subsequent_Next_Invoice_Generation_Dt__c,
                                                                                 ccrz__User__c,ccrz__InstallmentLastDate__c,ccrz__InstallmentNextDate__c,Latest_Invoice__c,
                                                                                 Next_Invoice_Generation_Date__c,OSM_Display_Product__c,ccrz__RecurringPrice__c,
                                                                                 ccrz__SPT__c,ccrz__SubscriptionStatus__c from ccrz__E_Subscription__c 
    where  ccrz__InstallmentCountRemaining__c>0 and ccrz__SubscriptionStatus__c='Active' and ccrz__Storefront__c='SoftwareStore' 
    and OSM_Subscription_End_Date__c> :System.Now() and ccrz__SubscriptionStartDate__c< :System.now()   
    and ccrz__Account__c in :accIdList]);
            
            System.debug('Subscription List size Test : ' + accList.size());
            
            
            List<CSS_Integration_Details__c> lstCustomSetting = new List<CSS_Integration_Details__c>(); 
        CSS_Integration_Details__c intDetails = new CSS_Integration_Details__c();
        intDetails.ApplicationName__c = 'OSMVertex';
        intDetails.Name = 'OSMVertex';
        intDetails.End_Point__c = 'https://services-test-oauth.cummins.com/api/oauth/token/cso';
        intDetails.IsActive__c = true;
        intDetails.Key__c = '694a2e07-c2dc-4473-81da-b693866d37b6';
        intDetails.Passcode__c = 'f6e1b39a-ad95-4d12-ab73-148afbfa8dcb';
        
        lstCustomSetting.add(intDetails);
        
        CSS_Integration_Details__c intDetails1 = new CSS_Integration_Details__c();
        intDetails1.ApplicationName__c = 'getVertexQuoteTax';
        intDetails1.Name = 'getVertexQuoteTax';
        intDetails1.AuthEnv__c = 'OSMBolt';
        intDetails1.End_Point__c = 'https://services-test.cummins.com/cso/taxinvoice';
        intDetails1.IsActive__c = true;
        intDetails1.Key__c = 'appSubscription-api-key';
        intDetails1.Method_Type__c = 'GET';
        intDetails1.Passcode__c = '';
        intDetails1.Timeout__c = 120000;
        lstCustomSetting.add(intDetails1);
        
        insert lstCustomSetting;
            
            // Failure 2
            Test.startTest();
            
            OSM_SW_Batch_Subscription_Processor obj3 = new OSM_SW_Batch_Subscription_Processor();
            obj3.accIdLst = accIdList;
            obj3.testNumber = 'test3';
            DataBase.executeBatch(obj3); 
                       
            Test.stopTest();
       } 
    }
    
    
      
  
    static testMethod void testMethod9() 
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
        
        Profile profile1 = [Select Id, Name from Profile where id =:transecRes.objSetupDate.loggedInUser.ProfileId];
        
        System.debug('TEST User : ' + transecRes.objSetupDate.loggedInUser);
        System.debug('TEST Profile : ' + profile1);
        
        System.Runas(transecRes.objSetupDate.loggedInUser){
        
        Map<id,Account> accountMap=new Map<id,Account>();
        Date CurDate = system.TODAY();
        System.debug('System.today : ' + CurDate);
        Account acc = transecRes.objSetupDate.account;
        acc.Next_Invoice_Generation_Date__c = CurDate-6;
        acc.Is_Active_Subscription_Exists__c = true;
        acc.OSM_Preferred_Payment_IsBolt_PO__c = true;
        acc.OSM_Preferred_Payment_Method__c = 'po';
        acc.Bolt_Credit_Hold__c = true;
        
        update acc;
        accountMap.put(acc.id,acc);

        List<Account> accList = [Select id, name, CMI_Primary_Contact__c, Next_Invoice_Generation_Date__c, 
                                 OSM_Preferred_Payment_Method__c, 
                                 (
                                     Select id,ccrz__Account__c,ccrz__AccountNumber__c,ccrz__AccountType__c 
                                     from ccrz__TransactionPayments__r 
                                     where ccrz__AccountType__c='po' 
                                     and Transaction_Status__c in ('Order Placed Success','Recurring Payment Success') 
                                     order by createddate desc limit 1
                                 ), 
                                 (
                                     select id  from contacts where IAM_Contact_Status__c='Active'
                                 ) 
                                 from account 
                                 where Next_Invoice_Generation_Date__c =:CurDate 
                                 and Is_Active_Subscription_Exists__c=true 
                                and id = :acc.iD];
        
        System.debug('Account List size Test : ' + accList.size());
        System.debug(accList);
        //System.assertEquals(1, accList.size());
        System.debug('list>>>>>>>>'+accList);
        List<String> accIdList = new List<String>();
            accIdList.add(acc.iD);
            
            List<ccrz__E_Subscription__c> subsList = new List<ccrz__E_Subscription__c>([select id,ccrz__InstallmentAddress__c,ccrz__SPT__r.Billing_Display_Name__c,Recurring_Invoice_Start_Date__c,ccrz__Storefront__c,ccrz__RecurringPriceSubAmt__c,ccrz__OrderAddress__c,ccrz__InstallmentCountRemaining__c,Last_Installment_Paid__c,ccrz__Quantity__c,OSM_Subscription_End_Date__c,
                                                                                 ccrz__SubscriptionProduct__c,ccrz__SubscriptionStartDate__c,ccrz__SubscriptionProduct__r.ccrz__SKU__c,ccrz__Account__c,Contact__c,ccrz__CurrencyISOCode__c,
                                                                                 OSM_Free_Trial__c,Subsequent_Next_Invoice_Due_Dt__c,Subsequent_Next_Invoice_Generation_Dt__c,
                                                                                 ccrz__User__c,ccrz__InstallmentLastDate__c,ccrz__InstallmentNextDate__c,Latest_Invoice__c,
                                                                                 Next_Invoice_Generation_Date__c,OSM_Display_Product__c,ccrz__RecurringPrice__c,
                                                                                 ccrz__SPT__c,ccrz__SubscriptionStatus__c from ccrz__E_Subscription__c 
    where  ccrz__InstallmentCountRemaining__c>0 and ccrz__SubscriptionStatus__c='Active' and ccrz__Storefront__c='SoftwareStore' 
    and OSM_Subscription_End_Date__c> :System.Now() and ccrz__SubscriptionStartDate__c< :System.now()   
    and ccrz__Account__c in :accIdList]);
            
            System.debug('Subscription List size Test : ' + accList.size());
            
            
            // Failure 2
            Test.startTest();
            
            OSM_SW_Batch_Subscription_Processor obj3 = new OSM_SW_Batch_Subscription_Processor();
            obj3.accIdLst = accIdList;
            obj3.testNumber = 'test3';
            DataBase.executeBatch(obj3); 
            
            
            
            OSM_Email_RecurringInvNotGenerated_Ctrl.LineItemDetail obj123 = new OSM_Email_RecurringInvNotGenerated_Ctrl.LineItemDetail();
            obj123.name = 'test User';
            obj123.uri = 'test User';
            obj123.imageUrl = 'testURL';
            obj123.shortDec = 'testURL';
             OSM_Email_RecurringInvNotGenerated_Ctrl iii = new OSM_Email_RecurringInvNotGenerated_Ctrl();
            boolean sss = iii.isSandbox();
            
            List<ccrz__E_ProductMedia__c> val = iii.mediaList;
            Id idval = iii.logId;
            
            Test.stopTest();
       } 
    }
    
    static testMethod void testMethod10() 
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
        
        Profile profile1 = [Select Id, Name from Profile where id =:transecRes.objSetupDate.loggedInUser.ProfileId];
        
        System.debug('TEST User : ' + transecRes.objSetupDate.loggedInUser);
        System.debug('TEST Profile : ' + profile1);
        
        System.Runas(transecRes.objSetupDate.loggedInUser){
        
        Map<id,Account> accountMap=new Map<id,Account>();
        Date CurDate = system.TODAY();
        System.debug('System.today : ' + CurDate);
        Account acc = transecRes.objSetupDate.account;
        acc.Next_Invoice_Generation_Date__c = CurDate;
        acc.Is_Active_Subscription_Exists__c = true;
        acc.OSM_Preferred_Payment_IsBolt_PO__c = true;
        acc.OSM_Preferred_Payment_Method__c = 'po';
        acc.Bolt_Credit_Hold__c = true;
        
        update acc;
        accountMap.put(acc.id,acc);

        List<Account> accList = [Select id, name, CMI_Primary_Contact__c, Next_Invoice_Generation_Date__c, 
                                 OSM_Preferred_Payment_Method__c, 
                                 (
                                     Select id,ccrz__Account__c,ccrz__AccountNumber__c,ccrz__AccountType__c 
                                     from ccrz__TransactionPayments__r 
                                     where ccrz__AccountType__c='po' 
                                     and Transaction_Status__c in ('Order Placed Success','Recurring Payment Success') 
                                     order by createddate desc limit 1
                                 ), 
                                 (
                                     select id  from contacts where IAM_Contact_Status__c='Active'
                                 ) 
                                 from account 
                                 where Next_Invoice_Generation_Date__c =:CurDate 
                                 and Is_Active_Subscription_Exists__c=true 
                                and id = :acc.iD];
        
        System.debug('Account List size Test : ' + accList.size());
        System.debug(accList);
        System.assertEquals(1, accList.size());
        System.debug('list>>>>>>>>'+accList);
        List<String> accIdList = new List<String>();
            accIdList.add(acc.iD);
            
            List<ccrz__E_Subscription__c> subsList = new List<ccrz__E_Subscription__c>([select id,ccrz__InstallmentAddress__c,ccrz__SPT__r.Billing_Display_Name__c,Recurring_Invoice_Start_Date__c,ccrz__Storefront__c,ccrz__RecurringPriceSubAmt__c,ccrz__OrderAddress__c,ccrz__InstallmentCountRemaining__c,Last_Installment_Paid__c,ccrz__Quantity__c,OSM_Subscription_End_Date__c,
                                                                                 ccrz__SubscriptionProduct__c,ccrz__SubscriptionStartDate__c,ccrz__SubscriptionProduct__r.ccrz__SKU__c,ccrz__Account__c,Contact__c,ccrz__CurrencyISOCode__c,
                                                                                 OSM_Free_Trial__c,Subsequent_Next_Invoice_Due_Dt__c,Subsequent_Next_Invoice_Generation_Dt__c,
                                                                                 ccrz__User__c,ccrz__InstallmentLastDate__c,ccrz__InstallmentNextDate__c,Latest_Invoice__c,
                                                                                 Next_Invoice_Generation_Date__c,OSM_Display_Product__c,ccrz__RecurringPrice__c,
                                                                                 ccrz__SPT__c,ccrz__SubscriptionStatus__c from ccrz__E_Subscription__c 
    where  ccrz__InstallmentCountRemaining__c>0 and ccrz__SubscriptionStatus__c='Active' and ccrz__Storefront__c='SoftwareStore' 
    and OSM_Subscription_End_Date__c> :System.Now() and ccrz__SubscriptionStartDate__c< :System.now()   
    and ccrz__Account__c in :accIdList]);
            
            System.debug('Subscription List size Test : ' + subsList.size());
            
            subsList[0].Next_Invoice_Generation_Date__c = null;
            update subsList;
            // Failure 2
            
            List<CSS_Integration_Details__c> lstCustomSetting = new List<CSS_Integration_Details__c>(); 
        CSS_Integration_Details__c intDetails = new CSS_Integration_Details__c();
        intDetails.ApplicationName__c = 'OSMVertex';
        intDetails.Name = 'OSMVertex';
        intDetails.End_Point__c = 'https://services-test-oauth.cummins.com/api/oauth/token/cso';
        intDetails.IsActive__c = true;
        intDetails.Key__c = '694a2e07-c2dc-4473-81da-b693866d37b6';
        intDetails.Passcode__c = 'f6e1b39a-ad95-4d12-ab73-148afbfa8dcb';
        
        lstCustomSetting.add(intDetails);
        
        CSS_Integration_Details__c intDetails1 = new CSS_Integration_Details__c();
        intDetails1.ApplicationName__c = 'getVertexQuoteTax';
        intDetails1.Name = 'getVertexQuoteTax';
        intDetails1.AuthEnv__c = 'OSMBolt';
        intDetails1.End_Point__c = 'https://services-test.cummins.com/cso/taxinvoice';
        intDetails1.IsActive__c = true;
        intDetails1.Key__c = 'appSubscription-api-key';
        intDetails1.Method_Type__c = 'GET';
        intDetails1.Passcode__c = '';
        intDetails1.Timeout__c = 120000;
        lstCustomSetting.add(intDetails1);
        
        insert lstCustomSetting;
        
            Test.startTest();
            
            OSM_SW_Batch_Subscription_Processor obj3 = new OSM_SW_Batch_Subscription_Processor();
            //obj3.accIdLst = accIdList;
            //obj3.testNumber = 'test5';
            DataBase.executeBatch(obj3); 
            
            Test.stopTest();
       } 
    }
    
    static testMethod void testMethod11() 
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
        
        Profile profile1 = [Select Id, Name from Profile where id =:transecRes.objSetupDate.loggedInUser.ProfileId];
        
        System.debug('TEST User : ' + transecRes.objSetupDate.loggedInUser);
        System.debug('TEST Profile : ' + profile1);
        
        System.Runas(transecRes.objSetupDate.loggedInUser){
        
        Map<id,Account> accountMap=new Map<id,Account>();
        Date CurDate = system.TODAY();
        System.debug('System.today : ' + CurDate);
        Account acc = transecRes.objSetupDate.account;
        acc.Next_Invoice_Generation_Date__c = CurDate;
        acc.Is_Active_Subscription_Exists__c = true;
        acc.OSM_Preferred_Payment_IsBolt_PO__c = true;
        acc.OSM_Preferred_Payment_Method__c = 'po';
        acc.Bolt_Credit_Hold__c = true;
        acc.IAM_Cummins_Support_User__c=transecRes.objSetupDate.loggedInUser.id;
        
        update acc;
        accountMap.put(acc.id,acc);

        List<Account> accList = [Select id, name, CMI_Primary_Contact__c, Next_Invoice_Generation_Date__c, 
                                 OSM_Preferred_Payment_Method__c, 
                                 (
                                     Select id,ccrz__Account__c,ccrz__AccountNumber__c,ccrz__AccountType__c 
                                     from ccrz__TransactionPayments__r 
                                     where ccrz__AccountType__c='po' 
                                     and Transaction_Status__c in ('Order Placed Success','Recurring Payment Success') 
                                     order by createddate desc limit 1
                                 ), 
                                 (
                                     select id  from contacts where IAM_Contact_Status__c='Active'
                                 ) 
                                 from account 
                                 where Next_Invoice_Generation_Date__c =:CurDate 
                                 and Is_Active_Subscription_Exists__c=true 
                                and id = :acc.iD];
        
        System.debug('Account List size Test : ' + accList.size());
        System.debug(accList);
        System.assertEquals(1, accList.size());
        System.debug('list>>>>>>>>'+accList);
        List<String> accIdList = new List<String>();
            accIdList.add(acc.iD);
            
            List<ccrz__E_Subscription__c> subsList = new List<ccrz__E_Subscription__c>([select id,ccrz__InstallmentAddress__c,ccrz__SPT__r.Billing_Display_Name__c,Recurring_Invoice_Start_Date__c,ccrz__Storefront__c,ccrz__RecurringPriceSubAmt__c,ccrz__OrderAddress__c,ccrz__InstallmentCountRemaining__c,Last_Installment_Paid__c,ccrz__Quantity__c,OSM_Subscription_End_Date__c,
                                                                                 ccrz__SubscriptionProduct__c,ccrz__SubscriptionStartDate__c,ccrz__SubscriptionProduct__r.ccrz__SKU__c,ccrz__Account__c,Contact__c,ccrz__CurrencyISOCode__c,
                                                                                 OSM_Free_Trial__c,Subsequent_Next_Invoice_Due_Dt__c,Subsequent_Next_Invoice_Generation_Dt__c,
                                                                                 ccrz__User__c,ccrz__InstallmentLastDate__c,ccrz__InstallmentNextDate__c,Latest_Invoice__c,
                                                                                 Next_Invoice_Generation_Date__c,OSM_Display_Product__c,ccrz__RecurringPrice__c,
                                                                                 ccrz__SPT__c,ccrz__SubscriptionStatus__c from ccrz__E_Subscription__c 
    where  ccrz__InstallmentCountRemaining__c>0 and ccrz__SubscriptionStatus__c='Active' and ccrz__Storefront__c='SoftwareStore' 
    and OSM_Subscription_End_Date__c> :System.Now() and ccrz__SubscriptionStartDate__c< :System.now()   
    and ccrz__Account__c in :accIdList]);
            
            System.debug('Subscription List size Test : ' + accList.size());
            
            
            // Failure 2
            
            List<CSS_Integration_Details__c> lstCustomSetting = new List<CSS_Integration_Details__c>(); 
        CSS_Integration_Details__c intDetails = new CSS_Integration_Details__c();
        intDetails.ApplicationName__c = 'OSMVertex';
        intDetails.Name = 'OSMVertex';
        intDetails.End_Point__c = 'https://services-test-oauth.cummins.com/api/oauth/token/cso';
        intDetails.IsActive__c = true;
        intDetails.Key__c = '694a2e07-c2dc-4473-81da-b693866d37b6';
        intDetails.Passcode__c = 'f6e1b39a-ad95-4d12-ab73-148afbfa8dcb';
        
        lstCustomSetting.add(intDetails);
        
        CSS_Integration_Details__c intDetails1 = new CSS_Integration_Details__c();
        intDetails1.ApplicationName__c = 'getVertexQuoteTax';
        intDetails1.Name = 'getVertexQuoteTax';
        intDetails1.AuthEnv__c = 'OSMBolt';
        intDetails1.End_Point__c = 'https://services-test.cummins.com/cso/taxinvoice';
        intDetails1.IsActive__c = true;
        intDetails1.Key__c = 'appSubscription-api-key';
        intDetails1.Method_Type__c = 'GET';
        intDetails1.Passcode__c = '';
        intDetails1.Timeout__c = 120000;
        lstCustomSetting.add(intDetails1);
        
        insert lstCustomSetting;
        
            Test.startTest();
            
            OSM_SW_Batch_Subscription_Processor obj3 = new OSM_SW_Batch_Subscription_Processor();
            obj3.accIdLst = accIdList;
            obj3.testNumber = 'test3';
            DataBase.executeBatch(obj3); 
            OSM_SW_Batch_Subscription_Processor obj4 = new OSM_SW_Batch_Subscription_Processor('test');
            OSM_SW_Batch_Subscription_Processor obj5 = new OSM_SW_Batch_Subscription_Processor(new List<String>{'1234'});
            
            Test.stopTest();
       } 
    }  
}