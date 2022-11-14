//Test Class for the class OSM_SW_SubscriptionDetailView_Ctrl
@isTest
global class OSM_SW_SubscriptionDetailView_Ctrl_Test 
{
    static testMethod void testFetchSubscriptionDetails()
    {
       // OSM_SW_SubscriptionDetailView_Ctrl.dodummy();
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
        
         Id SYS_ADMIN_PROFILE_ID = [SELECT Id FROM Profile WHERE Name = 'System Administrator' Limit 1].Id;
        
        //User Record
        Double randomNumber = math.random();
        User user1 = TestingUtils.createUser('testingUser' + randomNumber, SYS_ADMIN_PROFILE_ID, true);
        System.debug('_______user1____' + user1);
        
        //Parent account
        Account parentAccount = new Account();
        parentAccount.Name = 'testacc1';
        parentAccount.BillingStreet = 'Street';
        parentAccount.BillingCity = 'City';
        parentAccount.BillingState = '';
        parentAccount.BOLT_Account_Number__c = '999';
        parentAccount.BillingPostalCode = '11000';
        parentAccount.BillingCountry = 'United States';
        parentAccount.CMI_Region__c = 'India';
        parentAccount.CSS_Locale__c = 'English(India)';
        parentAccount.CSS_Timezone__c = '(GMT+05:30) India Standard Time (Asia/Kolkata)';
        parentAccount.CSS_DistributorCode__c = '02861';
        insert parentAccount;
        
        //Account
        Account testaccount = new Account();
        testAccount.Name = 'testacc';
        //testAccount.ParentId = parentAccount.id;
        testAccount.BillingStreet = 'Street';
        testAccount.BillingCity = 'City';
        testAccount.BillingState = '';
        testAccount.BOLT_Account_Number__c = '999';
        testAccount.BillingPostalCode = '11000';
        testAccount.BillingCountry = 'United States';
        testAccount.CMI_Region__c = 'India';
        testAccount.CSS_Locale__c = 'English(India)';
        testAccount.CSS_Timezone__c = '(GMT+05:30) India Standard Time (Asia/Kolkata)';
        testAccount.IAM_Service_Provider_Code__c = '02860';
        testAccount.CSS_DistributorCode__c = '02860';
        testAccount.type = 'Distributor Account';
        testAccount.CHANNEL_OF_DISTRIBUTION__c = 'Distributor Account';
        insert testAccount;
        system.debug('testAccount' + testAccount);

        //conatct record
       // List < Contact > contacts = TestingUtils.createContact(2, testAccount.id, user1.id, true);
       
        Contact contacts = new Contact(
            FirstName = 'Test',
            Lastname = 'McTesty',
            AccountId = testAccount.Id, Username__c = 'test43254@gmail.com',
            Email = System.now().millisecond() + 'test@test.com'
        );
        insert contacts;
        
        //CC Order
        Set < Id > OrderId = new Set < Id > ();
        ccrz__E_Order__c o1 = new ccrz__E_Order__c();
        o1.ccrz__Storefront__c = 'SoftwareStore';
        o1.ccrz__Account__c = testAccount.Id;
        o1.OrderProcessedforFSD__c = true;
        o1.IsInterCompanyProcessSuccess__c = false;
        //o1.ccrz__AbsoluteDiscount__c = 
        o1.ccrz__CurrencyISOCode__c = 'USD';
        //ol.ccrz__OrderStatus__c = 'Order Submitted';
        insert o1;
        OrderId.add(o1.id);

        ccrz__E_Product__c pro = new ccrz__E_Product__c();
        pro.Name = 'CA Base-OHT';
        pro.ccrz__SKU__c = '5678902-OHT';
        pro.ccrz__Quantityperunit__c = 1;
        pro.Group_Name__c = 'DA';
        //pro.ccrz__ParentProduct__c = parentpro.id;
        pro.Product_Class_Code__c = 'SW-Web Access';
        insert pro;
        // productIdList.add(pro.id);
        System.debug('---CC Product---' + pro);

        ccrz__E_Product__c pro1 = new ccrz__E_Product__c();
        pro1.Name = 'guidenz';
        pro1.ccrz__SKU__c = '5678902-OHT11';
        pro1.ccrz__Quantityperunit__c = 1;
        pro1.Group_Name__c = 'SES';
        //pro.ccrz__ParentProduct__c = parentpro.id;
        pro1.Product_Class_Code__c = 'SW-Web Access';
        insert pro1;

        //insert spt
        ccrz__E_SubProdTerm__c spt = new ccrz__E_SubProdTerm__c();
        spt.Billing_Display_Name__c = 'Monthly';
        spt.ccrz__CCProduct__c = pro1.id;
        spt.ccrz__EffectiveEnd__c = system.now();
        spt.ccrz__EffectiveStart__c = system.now() + 2;
        insert spt;

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
        oi1.Dn_Price__c = 1000;
        insert oi1;
        System.debug('---CC OrderItem---' + oi1);

        ccrz__E_OrderItem__c oi11 = new ccrz__E_OrderItem__c();
        oi11.ccrz__Price__c = 500;
        oi11.ccrz__OriginalItemPrice__c = 400;
        oi11.ccrz__Quantity__c = 1;
        oi11.ccrz__SubAmount__c = 123;
        oi11.ccrz__Order__c = o1.id;
        oi11.ccrz__Product__c = pro.id;
        oi11.ccrz__Subscription_Auto_Renewal__c = true;
        oi11.ccrz__DisplayProduct__c = pro.id;
        oi11.Original_Sales_Order_Item__c = oi1.id;
        oi11.ccrz__SubProdTerm__c = spt.id;
        oi11.Dn_Price__c = 1000;
        insert oi11;



        ccrz__E_PriceList__c price = new ccrz__E_PriceList__c();
        price.ccrz__Desc__c = 'test1111';
        price.ccrz__Storefront__c = 'SoftwareStore';
        insert price;

        ccrz__E_PriceListItem__c priceItem = new ccrz__E_PriceListItem__c();
        priceItem.Distributor_Price__c = 20;
        priceItem.ccrz__Pricelist__c = price.id;
        priceItem.ccrz__SubProdTerm__c = spt.id;
        priceItem.ccrz__Product__c = pro1.id;
        priceItem.ccrz__RecurringPrice__c = false;
        priceItem.Distributor_Price__c = 1000;
        insert priceItem;
        Map < Id, ccrz__E_PriceListItem__c > mapSubProdIdToPriceListItem = new Map < Id, ccrz__E_PriceListItem__c > ();
        mapSubProdIdToPriceListItem.put(priceItem.ccrz__SubProdTerm__c, priceItem);

        //create Invoice 
        ccrz__E_Invoice__c invoice = new ccrz__E_Invoice__c();
        invoice.ccrz__CCOrder__c = o1.id;
        invoice.ccrz__Contact__c = contacts.id;
        invoice.ccrz__User__c = user1.id;
        invoice.ccrz__BillTo__c = testaccount.id;
        invoice.ccrz__SoldTo__c = testaccount.id;
        invoice.ccrz__CurrencyCode__c = 'USD';
        invoice.ccrz__DateIssued__c = System.today();
        invoice.ccrz__DateDue__c = System.today();
        invoice.ccrz__OriginalAmount__c = 10000;
        invoice.ccrz__RemainingAmount__c = 0.00;
        invoice.ccrz__Storefront__c = 'SoftwareStore';
        invoice.OSM_Child_Account__c = testAccount.Id;
        insert invoice;

        //invoice items
        ccrz__E_InvoiceItem__c invoiceItem_Item = new ccrz__E_InvoiceItem__c();
        invoiceItem_Item.ccrz__OriginalAmount__c = 1000;
        invoiceItem_Item.ccrz__Invoice__c = invoice.id;
        invoiceItem_Item.ccrz__CCOrderItem__c = oi11.id;
        invoiceItem_Item.ccrz__CCOrder__c = o1.id;
        invoiceItem_Item.Quantity__c = 1;
        //invoiceItem_Item.CC_Subscription__c = subscriptionID;
        invoiceItem_Item.ccrz__Status__c = 'Open';
        invoiceItem_Item.ccrz__Type__c = 'Item';
        insert invoiceItem_Item;

        //Transaction Payment
        ccrz__E_TransactionPayment__c transactionPayment = new ccrz__E_TransactionPayment__c();
        transactionPayment.Transaction_Status__c = 'Order Placed Success';
        transactionPayment.ccrz__Storefront__c = 'SoftwareStore';
        transactionPayment.ccrz__Token__c = 'TestToken';
        transactionPayment.ccrz__TransactionCode__c = 'TestTransactionCode';
        transactionPayment.ccrz__CCOrder__c = o1.id;
        transactionPayment.ccrz__InvoiceAppliedTo__c = invoice.id;
        transactionPayment.ccrz__BillTo__c = testaccount.id;
        transactionPayment.ccrz__SoldTo__c = testaccount.id;
        transactionPayment.ccrz__Account__c = testaccount.id;
        transactionPayment.ccrz__Contact__c = contacts.id;
        transactionPayment.ccrz__User__c = user1.id;
        transactionPayment.ccrz__AccountType__c = 'po';
        insert transactionPayment;

        ccrz__E_ContactAddr__c contactAddress = new ccrz__E_ContactAddr__c();
        contactAddress.Account__c = testAccount.id;
        contactAddress.ccrz__AddressFirstline__c = '1460 N National Rd';
        contactAddress.ccrz__City__c = 'Scottsdale';
        contactAddress.ccrz__State__c = 'Arizona';
        contactAddress.ccrz__StateISOCode__c = 'AZ';
        contactAddress.ccrz__PostalCode__c = '85259';
        contactAddress.Bolt_Site__c = true;
        contactAddress.Site_Use_Status__c = true;
        contactAddress.Bolt_Active__c = true;
        insert contactAddress;

        ccrz__E_AccountAddressBook__c addressBook = new ccrz__E_AccountAddressBook__c();
        addressBook.ccrz__E_ContactAddress__c = contactAddress.id;
        addressBook.ccrz__Account__c = testAccount.id;
        insert addressBook;
        
         ccrz__E_Subscription__c objSubsc1 = new ccrz__E_Subscription__c();
       objSubsc1.ccrz__Quantity__c = 1;
       objSubsc1.ccrz__SubscriptionStatus__c = Label.OSM_Subscription_Status_Renew;
       objSubsc1.OSM_Subscription_End_Date__c = System.now().addDays(10);
       objSubsc1.ccrz__SubscriptionStartDate__c = System.now();
       objSubsc1.ccrz__Sequence__c=1;
       objSubsc1.ccrz__Storefront__c='SoftwareStore';
       objSubsc1.OSM_Display_Product__c=pro1.Id;
       insert objSubsc1;
       
        List<OSM_Order_Subscription__c> oslst = new List<OSM_Order_Subscription__c>();
        OSM_Order_Subscription__c newobb = new OSM_Order_Subscription__c();
            newobb.OSM_CCOrder__c = o1.id;
            newobb.OSM_CCSubscription__c = objSubsc1.Id;
            newobb.Billing_Frequency__c = 'Monthly';
            oslst.add(newobb);
            
        OSM_Order_Subscription__c newobb2 = new OSM_Order_Subscription__c();
            newobb2.OSM_CCOrder__c = o1.id;
            newobb2.OSM_CCSubscription__c = objSubsc1.Id;
            newobb2.Billing_Frequency__c = 'Yearly';
            oslst.add(newobb2);
            
        OSM_Order_Subscription__c newobb3 = new OSM_Order_Subscription__c();
            newobb3.OSM_CCOrder__c = o1.id;
            newobb3.OSM_CCSubscription__c = objSubsc1.Id;
            newobb3.Billing_Frequency__c = 'One time';
            oslst.add(newobb3);
            
        OSM_Order_Subscription__c newobb4 = new OSM_Order_Subscription__c();
            newobb4.OSM_CCOrder__c = o1.id;
            newobb4.OSM_CCSubscription__c = objSubsc1.Id;
            newobb4.Billing_Frequency__c = 'Quarterly';
            oslst.add(newobb4);
            
            insert oslst;
        
        System.debug('transecRes: '+transecRes);
        System.runAs ( transecRes.objSetupDate.loggedInUser   ) {
            
            //System.runAs(TestingUtils.createUser('12340',TestingUtils.SYS_ADMIN_PROFILE_ID,true)){
            OSM_WS_GeneralizedInputWrapper inputAPiWrapper = new OSM_WS_GeneralizedInputWrapper();
            //inputAPiWrapper.messageID = 'MSG1234';
            //inputAPiWrapper.customerId = customerId;
            inputAPiWrapper.initiator = 'ECommerce';
            inputAPiWrapper.timeStamp='2018-03-20T19:47:00.000Z';
            //system.debug('customerId_in_test'+customerId);
            
            OSM_WS_GetProductDetail_RES productsDetailFromAPI = OSM_WS_CS_Services.GetProductsWS(inputAPiWrapper);
            List<OSM_WS_GetProductDetail_RES.ProductSubscriptionInfo> productSubscriptionInfo = productsDetailFromAPI.productSubscriptionInfo;
            
            ccrz.cc_RemoteActionContext objRemotCtx = new ccrz.cc_RemoteActionContext();
            objRemotCtx.storefront='SoftwareStore';
            objRemotCtx.currentCartId=transecRes.cart.ccrz__EncryptedId__c;
            objRemotCtx.portalUserId=transecRes.objSetupDate.objUserID;
            objRemotCtx.effAccountId=transecRes.objSetupDate.account.Id;
            
            ccrz.cc_CallContext.initRemoteContext(objRemotCtx);
            try{
                Test.StartTest();
                
                
                OSM_SW_SubscriptionDetailView_Ctrl.fetchSubscriptionDetails(objRemotCtx, transecRes.subscription.ID);
                
                OSM_SW_SubscriptionDetailView_Ctrl.saveSubscriptionDetails(objRemotCtx, transecRes.subscription.ID, String.valueOf(System.today().addMonths(7)), String.valueOf(5));

            OSM_SW_SubscriptionDetailView_Ctrl.fetchSubscriptionDetails(objRemotCtx, objSubsc1.ID);
                
            OSM_SW_SubscriptionDetailView_Ctrl.saveSubscriptionDetails(objRemotCtx, objSubsc1.ID, String.valueOf(System.today().addMonths(7)), String.valueOf(5));
                
                Test.StopTest();
            }
            Catch(Exception ex){}
        } 
    }
    
    static testMethod void testSaveSubscriptionDetails()
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
        System.debug('transecRes: '+transecRes);
        
        //For remote action context 
        
        ccrz.cc_RemoteActionContext objRemotCtx = new ccrz.cc_RemoteActionContext();
        objRemotCtx.storefront='SoftwareStore';
        objRemotCtx.currentCartId=transecRes.cart.ccrz__EncryptedId__c;
        objRemotCtx.portalUserId=transecRes.objSetupDate.objUserID;
        
        ccrz.cc_CallContext.initRemoteContext(objRemotCtx);
        //System.debug(ccrz.cc_CallContext.currAccountId);
        System.runAs ( transecRes.objSetupDate.loggedInUser) 
            
        {
            CSS_Integration_Details__c csInt=new CSS_Integration_Details__c();
            csInt.name='COSM-Product';
            csInt.ApplicationName__c='GetProduct';
            csInt.End_Point__c='https://connectedsolutions-dev.cummins.com/appSubscriptionInternal/v1/subscription/products ';
            csInt.IsActive__c=true;
            csInt.AuthEnv__c='DA';
            csInt.Method_Type__c='POST';
            csInt.Timeout__c=120000;
            insert csInt;
            
            CSS_Integration_Details__c conDetails=new CSS_Integration_Details__c();
            conDetails.name='DA';
            conDetails.Key__c='appSubscription-api-key';
            conDetails.Passcode__c='OPJQg+I3X+t8OWbfMJexpQwIGiXRzXKROBieKx/jBlA=';
            insert conDetails;
            
            String json = '{'+
                '   \"customerID\": \"390\"'+
                '}';        
            OSM_WS_GeneralizedInputWrapper obj=OSM_WS_GeneralizedInputWrapper.parse(json);
            try{
                Test.StartTest();
                OSM_SW_SubscriptionDetailView_Ctrl.fetchSubscriptionDetails(objRemotCtx, transecRes.subscription.ID);
                Test.setMock(HttpCalloutMock.class,new SingleRequestMockProductPass());
                OSM_SW_SubscriptionDetailView_Ctrl.saveSubscriptionDetails(objRemotCtx, transecRes.subscription.ID, String.valueOf(System.today().addMonths(1)), String.valueOf(2));
                OSM_WS_CS_Services.GetProductsWS(obj);
                Test.StopTest();
            }
            Catch(Exception ex){}
        }
        
        
    }
    //For Product Interface Test
    global class SingleRequestMockProductPass implements HttpCalloutMock{
        global HTTPResponse respond(HTTPRequest req){
            HttpResponse resp=new HttpResponse();
            resp.setHeader('Content-Type', 'application/json');
            resp.setHeader('appSubscription-api-key', 'OPJQg+I3X+t8OWbfMJexpQwIGiXRzXKROBieKx/jBlA=');          
            resp.setBody('Status: null,Status Code: 200,Response Body:{"customerID":"390","productSubscriptionInfo":[{"productID":"1234567","availableCount":0,"totalSubscriptionCount":2068},{"productID":"3456789","message":"Not supported by equipment"},{"productID":"4567890","message":"Not supported by equipment"},{"productID":"5678901","availableCount":0,"totalSubscriptionCount":142}]}');
            resp.setStatusCode(200);
            return resp;
        }
    }
    public static void productSubscriptionInfoList(){
        /* List<OSM_WS_GetProductDetail_RES.ProductSubscriptionInfo> productSubscriptionInfoList=new List<OSM_WS_GetProductDetail_RES.ProductSubscriptionInfo>();
OSM_WS_GetProductDetail_RES.ProductSubscriptionInfo productSubscriptionInfom =new OSM_WS_GetProductDetail_RES.ProductSubscriptionInfo();
productSubscriptionInfom.productID='123-4567';
productSubscriptionInfom.availableCount=1;
productSubscriptionInfom.totalSubscriptionCount=2069;
productSubscriptionInfoList.add(productSubscriptionInfom);
// insert productSubscriptionInfoList;*/
        OSM_WS_CS_Services_Test.testProductCalloutPass();
        
    }
    
}