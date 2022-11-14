//This is the test class for OSM_SW_Batch_Subscription_Helper class recompiling
@isTest
   public class OSM_SW_Batch_Subscription_Helper_Test 
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
           
            List<Account> accIdList23 = new List<Account>();
            accIdList23=[Select Name,Next_Invoice_Generation_Date__c,Is_Active_Subscription_Exists__c,OSM_Preferred_Payment_IsBolt_PO__c,OSM_Preferred_Payment_Method__c,
            Bolt_Credit_Hold__c,CMI_Primary_Contact__c,id from account where id=:acc.Id];
           
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
            
            
            Map<Id, OSM_Integration_Log__c> invoiceNotCreatedLogs = new Map<Id, OSM_Integration_Log__c>();
            Map<Id, Date> mapAccountToNextInvoiceGenDate = new Map<Id, Date>();
            Map<Id,Account> accountMap2 = new Map<Id,Account>();
            for(account acc2 : accIdList23)
            {
            accountMap2.put(acc2.id,acc2);
            mapAccountToNextInvoiceGenDate.put(acc2.Id,acc2.Next_Invoice_Generation_Date__c.Date());
            }
            
            Map<String, ccrz__E_Invoice__c> accIdToInsertedInvoice = new Map<String, ccrz__E_Invoice__c>();
            
            ccrz__E_Invoice__c invoice = new ccrz__E_Invoice__c();
            invoice.Payment_Method__c='po';
            insert invoice;
            
            List<ccrz__E_Invoice__c> ccl1 =[select id,  Payment_Method__c from ccrz__E_Invoice__c limit 1];
            accIdToInsertedInvoice.put(acc.Id,ccl1[0]);
            
             Map<Id,Decimal> orderIdVsOrderTaxMap2 = new Map<Id,Decimal>();
             Map<Id,OSM_SW_Batch_Subscription_Helper.SingleInvoiceForAccountWrapper>  accoundVsWrapperMap;
            OSM_SW_Batch_Subscription_Helper helper = new OSM_SW_Batch_Subscription_Helper();
        OSM_ReturnWrapper returnWrapper = helper.createInvoicesForAccount(accountMap2);
        accoundVsWrapperMap = returnWrapper.accountIdVsInvoiceWrapperMap;
        
        orderIdVsOrderTaxMap2 = OSM_SW_VertexActions.getVirtualVertexQuoteTax(accoundVsWrapperMap );
            
        ccrz__E_Order__c order= new ccrz__E_Order__c();
        
        subsList[0].ccrz__CCOrder__c=order.id;
        update subsList;
        
        List<ccrz__E_Invoice__c> ccl =[select id,  Payment_Method__c from ccrz__E_Invoice__c limit 1];
        ccrz__E_InvoiceItem__c invoiceItem=new ccrz__E_InvoiceItem__c();
        invoiceItem.ccrz__Invoice__c=ccl[0].id;
        invoiceItem.CC_Subscription__c=subsList[0].id;
        invoiceItem.ccrz__Type__c='Item';
        invoiceItem.OSM_Bypass_Flow__c = true;
        
        List<ccrz__E_InvoiceItem__c> lsitem = new List<ccrz__E_InvoiceItem__c>();
        lsitem.add(invoiceItem);
        insert lsitem;
        
        Map<Object,  Object> accToInvoiceItemsAndSubss = new Map<Object,  Object>();
        accToInvoiceItemsAndSubss.put(acc.id+'INVOICEITEMS',lsitem);
       
       CC_Tax__c tax = new CC_Tax__c();
       
        OSM_Order_Subscription__c orderSub = new OSM_Order_Subscription__c();
        orderSub.OSM_CCSubscription__c     = subsList[0].id;
        orderSub.CCQuantity__c             = 55;
        orderSub.OSM_CCOrder__c            = order.id;
       // orderSub.CC_Order_Item__c          =null;
        orderSub.Billing_Frequency__c      = 'Monthly';
        //insert orderSub;
        
        List<OSM_Order_Subscription__c> lstoos = new List<OSM_Order_Subscription__c>();
        lstoos.add(orderSub);
        Map<Id,List<OSM_Order_Subscription__c>> subsIdInfoMapForAccount = new Map<Id,List<OSM_Order_Subscription__c>>();
        subsIdInfoMapForAccount.put(subsList[0].id,lstoos);
        
        
            Test.startTest();
            
            Map<String, ccrz__E_Invoice__c> mapAccToInsertedInvoice = OSM_SW_Batch_Subscription_Helper.getInvoicesToInsert(accoundVsWrapperMap,orderIdVsOrderTaxMap2,mapAccountToNextInvoiceGenDate,invoiceNotCreatedLogs );
            OSM_SW_Batch_Subscription_Helper.getInvoiceItemsAndSubssToUpsert(accoundVsWrapperMap,orderIdVsOrderTaxMap2,mapAccountToNextInvoiceGenDate,accIdToInsertedInvoice);
     
            OSM_SW_Batch_Subscription_Helper.getJunctionObjectsToUpserted(accoundVsWrapperMap,orderIdVsOrderTaxMap2,mapAccountToNextInvoiceGenDate,accIdToInsertedInvoice,accToInvoiceItemsAndSubss);
            
            OSM_SW_Batch_Subscription_Helper.getEmailMessagesToSent(accoundVsWrapperMap,orderIdVsOrderTaxMap2,mapAccountToNextInvoiceGenDate,invoiceNotCreatedLogs,null,null);
            
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
            
             try{
              OSM_SW_Batch_Subscription_Helper.populateJunctionObjects(subsIdInfoMapForAccount);
              }catch(exception ex)
              {}
            
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
    
    static testMethod void testMethod3() 
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
       
    private static  testmethod void testMethod4(){
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
           
            List<Account> accIdList23 = new List<Account>();
            accIdList23=[Select Name,Next_Invoice_Generation_Date__c,Is_Active_Subscription_Exists__c,OSM_Preferred_Payment_IsBolt_PO__c,OSM_Preferred_Payment_Method__c,
            Bolt_Credit_Hold__c,CMI_Primary_Contact__c,id from account where id=:acc.Id];
           
        
            Map<Id, Date> mapAccountToNextInvoiceGenDate = new Map<Id, Date>();
            Map<Id,Account> accountMap2 = new Map<Id,Account>();
            for(account acc2 : accIdList23)
            {
            accountMap2.put(acc2.id,acc2);
            mapAccountToNextInvoiceGenDate.put(acc2.Id,acc2.Next_Invoice_Generation_Date__c.Date());
            }
          
             Map<Id,Decimal> orderIdVsOrderTaxMap2 = new Map<Id,Decimal>();
             Map<Id,OSM_SW_Batch_Subscription_Helper.SingleInvoiceForAccountWrapper>  accoundVsWrapperMap;
            OSM_SW_Batch_Subscription_Helper helper = new OSM_SW_Batch_Subscription_Helper();
        OSM_ReturnWrapper returnWrapper = helper.createInvoicesForAccount(accountMap2);
        accoundVsWrapperMap = returnWrapper.accountIdVsInvoiceWrapperMap;
        orderIdVsOrderTaxMap2 = OSM_SW_VertexActions.getVirtualVertexQuoteTax(accoundVsWrapperMap );
            
        Map<String, ccrz__E_Invoice__c> accIdToInsertedInvoice2 = new Map<String, ccrz__E_Invoice__c>();
            ccrz__E_Invoice__c invoice2 = new ccrz__E_Invoice__c();
            invoice2.Payment_Method__c='po';
            insert invoice2;
            List<ccrz__E_Invoice__c> ccl2 =[select id,  Payment_Method__c from ccrz__E_Invoice__c limit 1];
            accIdToInsertedInvoice2.put(acc.Id,invoice2);
            // Failure 2
            Test.startTest();
           try{
            OSM_SW_Batch_Subscription_Helper.getInvoiceItemsAndSubssToUpsertLatest(accoundVsWrapperMap,orderIdVsOrderTaxMap2,mapAccountToNextInvoiceGenDate,accIdToInsertedInvoice2);
            
             }catch(exception ex){
            
        }
            Test.stopTest();
       }
    } 
}