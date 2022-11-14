//Created by Nandigam Sasi as part of MAR-1492
//updated by Sangeeta Rani
@istest
public class OSM_OverrideStandButtons_Ctrl_Test {
    public static final Id PROFILEID=TestingUtils.SYS_ADMIN_PROFILE_ID;
    //Order and Order Item
    static testMethod void tetsMethod1() {
        
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
        System.debug('transecRes: ' + transecRes);
        
        
        ccrz__E_Order__c newOrdr = new ccrz__E_Order__c();
        newOrdr = transecRes.order.clone(false, true);
        newOrdr.ccrz__OrderStatus__c = 'Approved';
        newOrdr.Original_Sales_Order__c = transecRes.order.Id;
        insert newOrdr;
        
        ccrz__E_Invoice__c newInvoice = new ccrz__E_Invoice__c();
        newInvoice = transecRes.invoice.clone(false, true);
        newInvoice.ccrz__CCOrder__c = newOrdr.Id;
        newInvoice.Original_Sales_Order_Invoice_Number__c = transecRes.invoice.Id;
        insert newInvoice;
        
        ccrz__E_TransactionPayment__c newTP = new ccrz__E_TransactionPayment__c();
        newTP = transecRes.transactionPayment.clone(false, true);
        newTP.ccrz__CCOrder__c = newOrdr.Id;
        newTP.ccrz__InvoiceAppliedTo__c = newInvoice.Id;
        insert newTP;
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
        testAccount.RecordTypeId = OSM_TestDataCreationUtility.getAccountRecordTypeID();
        testAccount.OwnerId = OSM_TestDataCreationUtility.getSystemAdministratorID();
        
        testAccount.CSS_Timezone__c = '(GMT+05:30) India Standard Time (Asia/Kolkata)';
        insert testAccount;
        ccrz__E_Product__c pro = new ccrz__E_Product__c();
        pro.Name = 'CA Base-OHT';
        pro.ccrz__SKU__c = '5678902-OHT';
        pro.ccrz__Quantityperunit__c = 1;
        pro.Group_Name__c = 'DA';
        pro.Product_Class_Code__c = 'SW-Web Access';
        insert pro;
        ccrz__E_Order__c o12 = new ccrz__E_Order__c ();
        o12.ccrz__Storefront__c = 'SoftwareStore';
        o12.ccrz__Account__c = testAccount.Id;
        o12.ccrz__CurrencyISOCode__c = 'USD';
        insert o12;
        ccrz__E_Order__c o1 = new ccrz__E_Order__c ();
        o1.ccrz__Storefront__c = 'SoftwareStore';
        o1.ccrz__Account__c = testAccount.Id;
        o1.ccrz__CurrencyISOCode__c = 'USD';
        o1.ccrz__OrderStatus__c ='Cancellation Pending';
        o1.Original_Sales_Order__c =o12.Id;
        insert o1;
        ccrz__E_OrderItem__c oi1 = new ccrz__E_OrderItem__c();
        oi1.ccrz__Price__c = 500;
        oi1.ccrz__OriginalItemPrice__c = 400;
        oi1.ccrz__Quantity__c = 1;
        oi1.ccrz__SubAmount__c = 123;
        oi1.ccrz__Order__c = o1.id;
        oi1.ccrz__Product__c = pro.id;
        oi1.ccrz__Subscription_Auto_Renewal__c = true;
        oi1.ccrz__DisplayProduct__c = pro.id;
        oi1.OSM_SW_Is_Included_Product__c=false;
        oi1.isRenew__c = true;
        insert oi1;
        ccrz__E_Invoice__c invc = new ccrz__E_Invoice__c();
        invc.ccrz__CCOrder__c = o1.id;
        invc.ccrz__Status__c = 'Open';
        invc.ccrz__Storefront__c = 'SoftwareStore';
        invc.ccrz__CurrencyCode__c = 'USD';
        invc.Payment_Method__c = 'po';
        insert invc;
        try {
            Test.startTest();
            ApexPages.StandardController sc = new ApexPages.StandardController(o12);
            OSM_OverrideStdButton_Order_Ctrl testAccPlan = new OSM_OverrideStdButton_Order_Ctrl(sc);
            PageReference pageRef = Page.OSM_OverrideStdButton_Order_Pg;
            pageRef.getParameters().put('id', String.valueOf(o12.Id));
            testAccPlan.deleteinvoice();
            Test.setCurrentPage(pageRef);
            
            ApexPages.StandardController sc1 = new ApexPages.StandardController(oi1);
            OSM_OverrideStdButton_OrderItem_Ctrl testAccPlan2 = new OSM_OverrideStdButton_OrderItem_Ctrl(sc1);
            PageReference pageRef2 = Page.OSM_OverrideStdButton_OrderItem_Pg;
            pageRef2.getParameters().put('id', String.valueOf(oi1.Id));
            testAccPlan2.deleteinvoice();
            Test.setCurrentPage(pageRef2);
            
            Test.stopTest();
        }
        Catch(Exception ex) {
            
        }
    }
    //invoice and invoiceitem
    static testMethod void tetsMethod2() {
        List<ccrz__E_Invoice__c> invoiceList=new List<ccrz__E_Invoice__c>();
        User usr=TestingUtils.createUser('12340',PROFILEID,true);
        List<ccrz__E_AccountGroup__c> accGrpId=TestingUtils.createAccountGroup(1,'TetsAccountGroup','none',true);
        List<Account> accId=TestingUtils.createAccount(1,'testAccount',accGrpId[0].id,usr.id,true);
        List<Contact> con=TestingUtils.createContact(1,accId[0].id,usr.id,true);
        ccrz__E_Order__c order=TestingUtils.createOrder(con[0].id,'testOrder',true); 
        List<ccrz__E_Invoice__c> cc_Invoice=TestingUtils.createCCInvoices(1,order.id,con[0].id,'Open','cart',true);
        cc_Invoice[0].Recurring_Invoice__c=true;
        cc_Invoice[0].ccrz__BillTo__c=accId[0].id;
        cc_Invoice[0].Payment_Method__c='cc';
        cc_Invoice[0].ccrz__Status__c='Paid';
        invoiceList.add(cc_Invoice[0]);
        update invoiceList;
        Map<Id,ccrz__E_Invoice__c> cmap=new  Map<Id,ccrz__E_Invoice__c>();
        cmap.put(invoiceList[0].id,invoiceList[0]);
        List<Id> invoiceIds=new List<Id>();
        invoiceIds.add(invoiceList[0].id);
        ccrz__E_Subscription__c subscription=new ccrz__E_Subscription__c();
        subscription.ccrz__Account__c=accId[0].id;
        subscription.ccrz__CCOrder__c=order.id;
        subscription.ccrz__Sequence__c=12;
        subscription.ccrz__Storefront__c='SoftwareStore';
        subscription.ccrz__SubscriptionStartDate__c=Date.Today();
        subscription.ccrz__SubscriptionStatus__c='Active';
        subscription.ccrz__InstallmentCountRemaining__c=0;
        insert subscription;
        ccrz__E_InvoiceItem__c invoiceItem=new ccrz__E_InvoiceItem__c();
        invoiceItem.ccrz__Invoice__c=invoiceList[0].id;
        invoiceItem.CC_Subscription__c=subscription.id;
        invoiceItem.ccrz__Type__c='Item';
        insert invoiceItem;
        Test.startTest();
        ApexPages.StandardController sc2 = new ApexPages.StandardController(subscription);
        OSM_OverrideStdButton_Subscription_Ctrl testAccPlan3 = new OSM_OverrideStdButton_Subscription_Ctrl(sc2);
        PageReference pageRef3 = Page.OSM_OverrideStdButton_Subscription_Pg ;
        pageRef3.getParameters().put('id', String.valueOf(subscription.Id));
        testAccPlan3.deleteinvoice();
        Test.setCurrentPage(pageRef3);
        
        ApexPages.StandardController sc1 = new ApexPages.StandardController(invoiceItem);
        OSM_OverrideStdButton_InvoiceItem_Ctrl testAccPlan2 = new OSM_OverrideStdButton_InvoiceItem_Ctrl(sc1);
        PageReference pageRef2 = Page.OSM_OverrideStdButton_InvoiceItem_Pg;
        pageRef2.getParameters().put('id', String.valueOf(invoiceItem.Id));
        testAccPlan2.deleteinvoice();
        Test.setCurrentPage(pageRef2);
        
        ApexPages.StandardController sc = new ApexPages.StandardController(invoiceList[0]);
        OSM_OverrideStdButton_Invoice_Ctrl testAccPlan = new OSM_OverrideStdButton_Invoice_Ctrl(sc);
        PageReference pageRef = Page.OSM_OverrideStdButton_Invoice_Pg;
        testAccPlan.deleteinvoice();
        Test.setCurrentPage(pageRef);
        Test.stopTest();
        
    }
    
    
}