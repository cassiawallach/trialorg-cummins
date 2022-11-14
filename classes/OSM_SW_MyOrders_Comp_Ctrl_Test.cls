/************************************************ Added for 1236
 History
 --------
 VERSION    AUTHOR          DATE            DETAILS
 1.0        Ashish          24/02/2021      Test Class Fixes
 2.0      Sharad Sahu       02/03/2021      Test Class Fixes
 3.0      Sangeeta Rani     23/07/2021      update
  2.0      Sangeeta      28/07/2021      update
 5.0      Sangeeta Rani     09/09/2021      update
 4.0      Subbu K           07/22/2021      MAR-1861
 6.0      Subbu K           09/09/2021      MAR-1842
  2.0      Sangeeta      19/10/2021      update
  //update
  // updated by Sharad
    // updated by Sharad   // updated by Sharad 
    //updated by shaad 23 oct 21
    // updated by sharad 15 Dec 21
    // updated by sharad 21 Dec 21
    // updated by Ashish 01 Feb 22
    // updated by Ashish 03 Feb 22
    // updated by Subbu 03 03 22
    // updates by Ashish 12/04/22
    // updated by swetha 22 Mar 22
 */
@isTest  

Public class OSM_SW_MyOrders_Comp_Ctrl_Test {
    
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

        //For    remote action context 

        ccrz.cc_RemoteActionContext objRemotCtx = new ccrz.cc_RemoteActionContext();
        objRemotCtx.storefront = 'SoftwareStore';
        objRemotCtx.currentCartId = transecRes.cart.ccrz__EncryptedId__c;
        objRemotCtx.portalUserId = transecRes.objSetupDate.objUserID;
 objRemotCtx.effAccountId = transecRes.objSetupDate.account.Id;
        ccrz.cc_CallContext.initRemoteContext(objRemotCtx);
        //System.debug(ccrz.cc_CallContext.currAccountId);
        try {
            test.StartTest();
            // Create RemoteActionContext Class Data 
            ccrz.cc_RemoteActionContext objRemoteClass = new ccrz.cc_RemoteActionContext();

            // Call Apex Class Methods
            OSM_SW_MyOrders_Comp_Ctrl.getOrderInfo(objRemoteClass, transecRes.order.id,'','');

            OSM_SW_MyOrders_Comp_Ctrl.callFSDAPI(objRemoteClass, transecRes.order.id);
            //OSM_SW_MyOrders_Comp_Ctrl.checkGOMSUser(objRemoteClass, transecRes.order.id);

            OSM_SW_OrderCancelUtilForPage.callFSDAPIFromBatch(transecRes.order.id);
            OSM_SW_OrderCancelUtilForPage.updateSubsc(transecRes.order.id);
            OSM_SW_OrderCancelUtilForPage.updateTP(transecRes.order.id);

            List < String > setId = new List < String > ();
            setId.add(transecRes.orderItem.Id);
            OSM_SW_MyOrders_Comp_Ctrl.callCancelOrder(transecRes.order.id);
            OSM_SW_MyOrders_Comp_Ctrl.callCancelAPI(objRemoteClass, setId);
            OSM_SW_MyOrders_Comp_Ctrl.callRevokeAPI(objRemoteClass, setId);

            // Stop Test
            test.StopTest();
        }
        Catch(Exception ex) {

        }
    }
    static testMethod void tetsMethod2() {

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

        //Creating cc order record
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
        //pro.ccrz__ParentProduct__c = parentpro.id;
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
        ccrz__E_TransactionPayment__c newTP = new ccrz__E_TransactionPayment__c();
        newTP = transecRes.transactionPayment.clone(false, true);
        newTP.ccrz__CCOrder__c = o12.Id;
        newTP.ccrz__InvoiceAppliedTo__c = newInvoice.Id;
        insert newTP;
        try {
            test.StartTest();
             Set<Id> idSet = new Set<Id>();
            idSet.add(o1.Id);

            OSM_SW_OrderCancelUtilForPage.callFSDAPIFromBatch(transecRes.order.id);
            OSM_SW_OrderCancelUtilForPage.updateSubsc(transecRes.order.id);
            OSM_SW_OrderCancelUtilForPage.updateTP(transecRes.order.id);
            OSM_SW_OrderCancelUtilForPage.updateIntercompanyOrderCancelSucess(transecRes.order.id);
            OSM_SW_OrderCancelUtilForPage.updateIntercompanyOrder(transecRes.order.id);
            OSM_SW_OrderCancelUtilForPage.updateOrderCancel(idSet);
            
            test.StopTest();
        }
        Catch(Exception ex) {

        }
    }


    static testMethod void tetsMethod3() {

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


        ccrz__E_OrderItem__c objItem = new ccrz__E_OrderItem__c();
        objItem.Id = transecRes.orderItem.Id;
        objItem.OMS_Product__c = true;
        objItem.OMS_Item_ID__c = 'testId';
        objItem.OMS_Activation_Key__c = 'testId';
        objItem.OSM_Tool_Instance_Key__c = 'testId';

        update objItem;

        //For remote action context 

        ccrz.cc_RemoteActionContext objRemotCtx = new ccrz.cc_RemoteActionContext();
        objRemotCtx.storefront = 'SoftwareStore';
        objRemotCtx.currentCartId = transecRes.cart.ccrz__EncryptedId__c;
        objRemotCtx.portalUserId = transecRes.objSetupDate.objUserID;
 objRemotCtx.effAccountId = transecRes.objSetupDate.account.Id;
        ccrz.cc_CallContext.initRemoteContext(objRemotCtx);
        //System.debug(ccrz.cc_CallContext.currAccountId);
        try {
            test.StartTest();
            // Create RemoteActionContext Class Data 
            ccrz.cc_RemoteActionContext objRemoteClass = new ccrz.cc_RemoteActionContext();

            // Call Apex Class Methods
            OSM_SW_MyOrders_Comp_Ctrl.getOrderInfo(objRemoteClass, transecRes.order.id,'','');

            OSM_SW_MyOrders_Comp_Ctrl.callFSDAPI(objRemoteClass, transecRes.order.id);
            //OSM_SW_MyOrders_Comp_Ctrl.checkGOMSUser(objRemoteClass, transecRes.order.id);
            OSM_SW_OrderCancelUtilForPage.callFSDAPIFromBatch(transecRes.order.id);
            OSM_SW_OrderCancelUtilForPage.updateSubsc(transecRes.order.id);
            OSM_SW_OrderCancelUtilForPage.updateTP(transecRes.order.id);

            List < String > setId = new List < String > ();
            setId.add(transecRes.orderItem.Id);
            OSM_SW_MyOrders_Comp_Ctrl.callCancelOrder(transecRes.order.id);
            OSM_SW_MyOrders_Comp_Ctrl.callCancelAPI(objRemoteClass, setId);
            OSM_SW_MyOrders_Comp_Ctrl.callRevokeAPI(objRemoteClass, setId);
            
            // Stop Test
            test.StopTest();
        }
        Catch(Exception ex) {

        }
    }
    static testMethod void tetsMethod4() {

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


        ccrz__E_OrderItem__c objItem = new ccrz__E_OrderItem__c();
        objItem.Id = transecRes.orderItem.Id;
        objItem.OMS_Product__c = true;
        objItem.OMS_Item_ID__c = 'testId';
        objItem.OMS_Activation_Key__c = 'testId';
        objItem.OSM_Tool_Instance_Key__c = 'testId';
        objItem.ccrz__Quantity__c = 5;
        objItem.Number_of_Bundles__c= 6;

        update objItem;

        //For remote action context 

        ccrz.cc_RemoteActionContext objRemotCtx = new ccrz.cc_RemoteActionContext();
        objRemotCtx.storefront = 'SoftwareStore';
        objRemotCtx.currentCartId = transecRes.cart.ccrz__EncryptedId__c;
        objRemotCtx.portalUserId = transecRes.objSetupDate.objUserID;
 objRemotCtx.effAccountId = transecRes.objSetupDate.account.Id;
        ccrz.cc_CallContext.initRemoteContext(objRemotCtx);
        //System.debug(ccrz.cc_CallContext.currAccountId);
        try {
            test.StartTest();
            // Create RemoteActionContext Class Data 
            ccrz.cc_RemoteActionContext objRemoteClass = new ccrz.cc_RemoteActionContext();

            // Call Apex Class Methods
            OSM_SW_MyOrders_Comp_Ctrl.getOrderInfo(objRemoteClass, transecRes.order.id,'','');
            List < String > setId = new List < String > ();
            setId.add(transecRes.orderItem.Id);
            OSM_SW_MyOrders_Comp_Ctrl.callCancelOrder(transecRes.order.id);
            OSM_SW_MyOrders_Comp_Ctrl.callCancelAPI(objRemoteClass, setId);
            OSM_SW_MyOrders_Comp_Ctrl.callRevokeAPI(objRemoteClass, setId);
            OSM_SW_MyOrders_Comp_Ctrl.callFSDAPI(objRemoteClass, transecRes.order.id);
            //OSM_SW_MyOrders_Comp_Ctrl.checkGOMSUser(objRemoteClass, transecRes.order.id);
            OSM_SW_OrderCancelUtilForPage.callFSDAPIFromBatch(transecRes.order.id);
            OSM_SW_OrderCancelUtilForPage.updateSubsc(transecRes.order.id);
            OSM_SW_OrderCancelUtilForPage.updateTP(transecRes.order.id);

            

            // Stop Test
            test.StopTest();
        }
        Catch(Exception ex) {

        }
    }

    static testMethod void tetsMethod5() {

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


        ccrz__E_OrderItem__c objItem = new ccrz__E_OrderItem__c();
        objItem.Id = transecRes.orderItem.Id;
        objItem.OMS_Product__c = true;
        objItem.OMS_Item_ID__c = 'testId';
        objItem.OMS_Activation_Key__c = 'testId';
        objItem.OSM_Tool_Instance_Key__c = '';
        objItem.ccrz__Quantity__c = 5;
        objItem.Number_of_Bundles__c= 6;

        update objItem;

        //For remote action context 

        ccrz.cc_RemoteActionContext objRemotCtx = new ccrz.cc_RemoteActionContext();
        objRemotCtx.storefront = 'SoftwareStore';
        objRemotCtx.currentCartId = transecRes.cart.ccrz__EncryptedId__c;
        objRemotCtx.portalUserId = transecRes.objSetupDate.objUserID;
 objRemotCtx.effAccountId = transecRes.objSetupDate.account.Id;
        ccrz.cc_CallContext.initRemoteContext(objRemotCtx);
        //System.debug(ccrz.cc_CallContext.currAccountId);
        try {
            test.StartTest();
            // Create RemoteActionContext Class Data 
            ccrz.cc_RemoteActionContext objRemoteClass = new ccrz.cc_RemoteActionContext();

            // Call Apex Class Methods
            OSM_SW_MyOrders_Comp_Ctrl.getOrderInfo(objRemoteClass, transecRes.order.id,'','');

            OSM_SW_MyOrders_Comp_Ctrl.callFSDAPI(objRemoteClass, transecRes.order.id);
           // OSM_SW_MyOrders_Comp_Ctrl.checkGOMSUser(objRemoteClass, transecRes.order.id);
            OSM_SW_OrderCancelUtilForPage.callFSDAPIFromBatch(transecRes.order.id);
            OSM_SW_OrderCancelUtilForPage.updateSubsc(transecRes.order.id);
            OSM_SW_OrderCancelUtilForPage.updateTP(transecRes.order.id);

            List < String > setId = new List < String > ();
            setId.add(transecRes.orderItem.Id);
            OSM_SW_MyOrders_Comp_Ctrl.callCancelOrder(transecRes.order.id);
            OSM_SW_MyOrders_Comp_Ctrl.callCancelAPI(objRemoteClass, setId);
            OSM_SW_MyOrders_Comp_Ctrl.callRevokeAPI(objRemoteClass, setId);

            // Stop Test
            test.StopTest();
        }
        Catch(Exception ex) {

        }
    }

    static testMethod void tetsMethod6() {

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


        ccrz__E_OrderItem__c objItem = new ccrz__E_OrderItem__c();
        objItem.Id = transecRes.orderItem.Id;
        objItem.OMS_Product__c = true;
        objItem.OMS_Item_ID__c = '';
        objItem.OMS_Activation_Key__c = 'testId';
        objItem.OSM_Tool_Instance_Key__c = '';
        objItem.ccrz__Quantity__c = 5;
        objItem.Number_of_Bundles__c= 6;

        update objItem;
        OSM_Order_Item_License__c orderItemLicense = new OSM_Order_Item_License__c();
        orderItemLicense.Activation_Key__c = '1234';
        orderItemLicense.CC_Order_Item__c = objItem.id;
        orderItemLicense.OMS_Item_Id__c = '1234';
        orderItemLicense.Tool_Instance_Id__c = '1234';
        orderItemLicense.Status__c = 'New';
        insert orderItemLicense;

        //For remote action context 

        ccrz.cc_RemoteActionContext objRemotCtx = new ccrz.cc_RemoteActionContext();
        objRemotCtx.storefront = 'SoftwareStore';
        objRemotCtx.currentCartId = transecRes.cart.ccrz__EncryptedId__c;
        objRemotCtx.portalUserId = transecRes.objSetupDate.objUserID;
         objRemotCtx.effAccountId = transecRes.objSetupDate.account.Id;

        ccrz.cc_CallContext.initRemoteContext(objRemotCtx);
        //System.debug(ccrz.cc_CallContext.currAccountId);
        try {
            test.StartTest();
            // Create RemoteActionContext Class Data 
            ccrz.cc_RemoteActionContext objRemoteClass = new ccrz.cc_RemoteActionContext();

            // Call Apex Class Methods
            OSM_SW_MyOrders_Comp_Ctrl.getOrderInfo(objRemoteClass, transecRes.order.id,'','');

            OSM_SW_MyOrders_Comp_Ctrl.callFSDAPI(objRemoteClass, transecRes.order.id);
            OSM_SW_MyOrders_Comp_Ctrl.checkGOMSUser(objRemoteClass, transecRes.order.id);
            OSM_SW_OrderCancelUtilForPage.callFSDAPIFromBatch(transecRes.order.id);
            OSM_SW_OrderCancelUtilForPage.updateSubsc(transecRes.order.id);
            OSM_SW_OrderCancelUtilForPage.updateTP(transecRes.order.id);

            List < String > setId = new List < String > ();
            setId.add(transecRes.orderItem.Id);
            OSM_SW_MyOrders_Comp_Ctrl.callCancelOrder(transecRes.order.id);
            OSM_SW_MyOrders_Comp_Ctrl.callCancelAPI(objRemoteClass, setId);
            OSM_SW_MyOrders_Comp_Ctrl.callRevokeAPI(objRemoteClass, setId);
            
            // Stop Test
            test.StopTest();
        }
        Catch(Exception ex) {

        }
    }
    
static testMethod void myOrders_Comp_Ctrl_Test() {

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

          Id portal_PROFILE_ID = [SELECT Id FROM Profile WHERE Name = 'IAM_Site_Admin_Community' Limit 1 ].Id;
          //Id roleId=[select id,name from UserRole where name='CumminsFleetsCustomerUser' limit 1].id; 
           
         UserRole portalRole = [Select Id From UserRole Where PortalType = 'None' Limit 1];
          system.debug('portalRole is ' + portalRole);

          Profile profile1 = [Select Id from Profile where name = 'System Administrator'];
          User portalAccountOwner2 = new User(
          UserRoleId = portalRole.Id,
          ProfileId = profile1.Id,
          Username ='test24446@test.com',
          Alias = 'batman',
          Email='bruce.wayne@wayneenterprises.com',
          EmailEncodingKey='UTF-8',
          Firstname='Bruce',
          Lastname='Wayne',
          LanguageLocaleKey='en_US',
          LocaleSidKey='en_US',
          TimeZoneSidKey='America/Chicago'
          );
          Database.insert(portalAccountOwner2);
          Account portalAccount2 = new Account(
          Name = 'TestAccount2',
          OwnerId = portalAccountOwner2.Id,
          OSM_Preferred_Billing_Frequency_Lock__c=false,
          BMS_Customer_ID__c='1234',
          OSM_Preferred_Payment_Method__c='po',
          OSM_Preferred_Payment_IsBolt_PO__c=false
          );
          System.runAs(portalAccountOwner2){
              Database.insert(portalAccount2);
          }

          //Create contact
          Contact contact1 = new Contact(
          FirstName = 'Test',
          Lastname = 'McTesty',
          Username__c = 'testUserName7789@gmail.com',
          AccountId = portalAccount2.Id,
          IAM_Contact_Status__c='Pending',
          Email ='test@test.com'
          );
          System.runAs(portalAccountOwner2){
              Database.insert(contact1);
          } 
          
          User testUser = new User();
          testUser.FirstName = 'Testttt';
          testUser.LastName = 'lasttt';
          testUser.UserName = 'test2abc7878@test.com';
          testUser.Email = 'bruce.wayne@wayneenterprises.com';
          testUser.Alias = 'batman';
          testUser.ContactId = contact1.Id;
          testUser.CommunityNickname = 'test12345h';
          testUser.ProfileId =portal_PROFILE_ID;
          testUser.TimeZoneSidKey = 'America/Los_Angeles';
          testUser.isActive = true;
          testUser.LocaleSidKey = 'en_US';
          testUser.LanguageLocaleKey = 'en_US';
          testUser.EmailEncodingKey = 'ISO-8859-1';
            System.runAs(portalAccountOwner2){
                  insert testUser;
            
          }
        // Creating address
        System.runAs(portalAccountOwner2) {
            
            Contact contact = transecRes.objSetupDate.contact;
            contact.CMI_Contact_Type__c= 'Primary';
            update contact;
            
            Account account = transecRes.objSetupDate.account;
            RecordType recid =[select id from recordType where name='WWSPS' limit 1]; 
            account.RecordTypeId= recid.id;
            account.Type = 'Distributor Account';
            account.OSM_Service_Level__c= 'asdAccount';
             account.Name= 'sdf';
             account.EBU_Channel_of_Distribution__c= 'BUS OEM';
               account.PSBU_Channel_of_Distribution__c= 'EXPORT HOUSE';
           account.BillingCountry = 'United States';
        account.CMI_Region__c = 'India';
        account.CSS_Locale__c = 'English(India)';
             account.OSM_HHP_Dealer__c= true;
              account.CMI_Region__c= 'India';
              account.BUSINESS_UNIT__c= 'India';
            account.DTNA__c = true;
            account.CMI_CId__c = 'Test';
            account.CSS_DBCode__c = 'Test';
            account.CSS_DealerCode__c = 'Test';
            account.Type = 'Distributor Account';
            account.CMI_Account_Status__c='Expired';
            account.CSS_DistributorCode__c = '10010';
            account.IAM_Service_Provider_Code__c = '1339';
            account.CMI_CDA_Status__c='New Customer Request';
            account.Bolt_Customer_Account_Status__c = 'Active';
            account.CHANNEL_OF_DISTRIBUTION__c = Label.COD_CIHR_List.split(',')[0].substring(0,4) + Label.COD_CIHR_List.split(',')[0];
            //update account;
            
            ccrz__E_Order__c order = new ccrz__E_Order__c();
            order.Id = transecRes.order.id;
            order.ccrz__OrderStatus__c = 'Order Submitted';
            update order;
            
            /*ccrz__E_TransactionPayment__c newTP = new ccrz__E_TransactionPayment__c();
            newTP = transecRes.transactionPayment.clone(false, true);
            newTP.ccrz__CCOrder__c = order.Id;
            //newTP.ccrz__InvoiceAppliedTo__c = newInvoice.Id;
            insert newTP;*/
        
            ccrz__E_Product__c pro = new ccrz__E_Product__c();
            pro.Group_Name__c = 'DA';
            pro.Name = 'Service Tech Kit';
            pro.ccrz__SKU__c = 'INS-Pro-P-02300';
            pro.ccrz__Quantityperunit__c = 1;
            pro.ccrz__ProductType__c = 'Product';
            pro.Product_Range__c = 'Service Plus';
            pro.isIAMProvisioningRequired__c = true;
            pro.Product_Class_Code__c = 'SW-Web Access';
            pro.LicenseName__c = 'Service Plus Basic';
            pro.Id = transecRes.objSetupDate.compositeProduct.Id;
            update pro;
            
            ccrz__E_OrderItem__c objItem = new ccrz__E_OrderItem__c();
            objItem.Id = transecRes.orderItem.Id;
            objItem.OMS_Product__c = true;
            objItem.ccrz__Product__c = pro.Id;
            objItem.ccrz__DisplayProduct__c = pro.Id;
            update objItem;
            
            List<OSM_Order_Item_License__c> OrdrItemLst = new List<OSM_Order_Item_License__c>();
            OSM_Order_Item_License__c ParentActivationKey = new OSM_Order_Item_License__c();
            ParentActivationKey.Activation_Key__c         = 'testActivationKey';
            ParentActivationKey.CC_Order_Item__c          = transecRes.orderItem.Id;
            ParentActivationKey.Parent_Activation_Key__c  = null;
            ParentActivationKey.OMS_Item_Id__c            = '1234';
            ParentActivationKey.Tool_Instance_Key__c      = '12345';
            ParentActivationKey.Status__c                 = 'New';
            ParentActivationKey.type__c                   = 'Basic';
            //insert ParentActivationKey;
            OrdrItemLst.add(ParentActivationKey);
            
            OSM_Order_Item_License__c orderItemLicense2 = new OSM_Order_Item_License__c();
            orderItemLicense2.Activation_Key__c         = 'testActivationKey';
            orderItemLicense2.CC_Order_Item__c          = transecRes.orderItem.Id;
            orderItemLicense2.Parent_Activation_Key__c  = ParentActivationKey.Id;
            orderItemLicense2.OMS_Item_Id__c            = '1234';
            orderItemLicense2.Tool_Instance_Key__c      = '12345';
            orderItemLicense2.Status__c                 = 'New';
            orderItemLicense2.type__c                   = 'Functional';
            //insert orderItemLicense2;
            OrdrItemLst.add(orderItemLicense2);
            
            insert OrdrItemLst;

            ccrz.cc_RemoteActionContext objRemotCtx = new ccrz.cc_RemoteActionContext();
            //objRemotCtx.portalUserId = transecRes.objSetupDate.objUserID;
            objRemotCtx.portalUserId = testUser.id;
             objRemotCtx.effAccountId = transecRes.objSetupDate.account.Id;
            ccrz.cc_CallContext.initRemoteContext(objRemotCtx);
            
            OSM_Application_Feature__mdt lstAppFeature = [SELECT MasterLabel, Label, DeveloperName, Product_Name__c, 
                                                                        Role_Feature__c, User_Type__c 
                                                                 FROM OSM_Application_Feature__mdt 
                                                                 WHERE DeveloperName='Guidanz_Mobile_SIR_GZ_Mobile_P_002' limit 1];
            Map<String,OSM_Application_Feature__mdt> appF = new Map<String,OSM_Application_Feature__mdt>();
            appF.put('key', lstAppFeature);
            
            List<IAM_Application__c> appList = new List<IAM_Application__c>();
            IAM_Application__c app = new IAM_Application__c(IAM_Status__c='Active',
                                                            IAM_Role__c='PrimaryContact',
                                                            IAM_Source__c = 'Marketplace',
                                                            IAM_Subscription_Count__c= 10,
                                                            IAM_Provisioned_User_Count__c=1,
                                                            IAM_Free_Subscription__c= False,
                                                            IAM_Account_Name__c = account.ID,
                                                            IAM_Subscription_Name__c='TestSubscription1',
                                                            IAM_Subscription_Start_Date__c=System.today(),
                                                            IAM_Reject_Reason__c = 'Cancellation Comments',
                                                            IAM_Subscription_End_Date__c= System.today() + 5,
                                                            IAM_Application_Name__c = 'Cummins Service Training');
            
            //insert app;
            appList.add(app);
            
            IAM_Application__c app2 = new IAM_Application__c(IAM_Status__c='Active',
                                                            IAM_swregExpire__c = 'test',
                                                            IAM_Role__c='PrimaryContact',
                                                            IAM_Source__c = 'Marketplace',
                                                            IAM_Subscription_Count__c= 10,
                                                            IAM_Free_Subscription__c= False,
                                                            IAM_Provisioned_User_Count__c=1,
                                                            IAM_Account_Name__c = account.ID,
                                                            IAM_Application_Name__c = 'Guidanz Mobile',
                                                            IAM_Subscription_Name__c='TestSubscription1',
                                                            IAM_Subscription_Start_Date__c=System.today(),
                                                            IAM_Reject_Reason__c = 'Cancellation Comments',
                                                            IAM_Subscription_End_Date__c= System.today() + 5);
            
            //insert app2;
            appList.add(app2);
            
            insert appList;
            
            Test.startTest(); 
            OSM_SW_MyOrders_Comp_Ctrl.getOrderInfo(objRemotCtx, transecRes.order.id,'','');
            OSM_SW_MyOrders_Comp_Ctrl.checkIAMUserProvisionedCount(objRemotCtx, transecRes.order.id);
            OSM_SW_MyOrders_Comp_Ctrl.createOsmIamProvisioningDetail('test', 1, account, new Map<String, OSM_Application_Feature__mdt>{'test' => lstAppFeature}, 'EBU',pro.ccrz__SKU__c);
           // OSM_SW_MyOrders_Comp_Ctrl.createOsmIamProvisioningDetail('test', 1, account, new Map<String, OSM_Application_Feature__mdt>{'test~SIR' => lstAppFeature}, 'CPG',pro.ccrz__SKU__c);
            
            
            ccrz__E_Product__c comp = new ccrz__E_Product__c();
            comp.QSOLType__c = 'EBU';
            comp.isIAMProvisioningRequired__c = true;
            comp.Id = transecRes.objSetupDate.componentList[0].Id;
            update comp;
            
            pro.QSOLType__c = 'EBU';
            pro.Name = 'Guidanz Mobile (Includes Immediate Assessment)';
            update pro;
            
            List<OSM_Subscription_Account_Provision__c> subsList = new List<OSM_Subscription_Account_Provision__c>();
            OSM_Subscription_Account_Provision__c objSAP = new OSM_Subscription_Account_Provision__c(Subscription_Status__c = 'Active',
                                                                                                     Account_Features_Access__c = app.Id,User_Count__c=1,
                                                                                                     CC_Subscription__c = transecRes.subscription.Id);
            //insert objSAP;
            subsList.add(objSAP);
            
            OSM_Subscription_Account_Provision__c objSAP2 = new OSM_Subscription_Account_Provision__c(Subscription_Status__c = 'Active',
                                                                                                     Account_Features_Access__c = app2.Id,User_Count__c=1,
                                                                                                     CC_Subscription__c = transecRes.subscription.Id);
            //insert objSAP2;
            subsList.add(objSAP2);
            
            OSM_SW_MyOrders_Comp_Ctrl.checkIAMUserProvisionedCount(objRemotCtx, transecRes.order.id);
            OSM_SW_MyOrders_Comp_Ctrl.checkGOMSUser(objRemotCtx, transecRes.order.id);
            OSM_SW_MyOrders_Comp_Ctrl.createOsmIamProvisioningDetail('test',6,account,appF,'CPG','test');
            
            Test.stopTest();
           
            
        }
    }
    static testMethod void tetsMethod7() {  
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
       
          Id portal_PROFILE_ID = [SELECT Id FROM Profile WHERE Name = 'IAM_Site_Admin_Community' Limit 1 ].Id;
          //Id roleId=[select id,name from UserRole where name='CumminsFleetsCustomerUser' limit 1].id; 
           
         UserRole portalRole = [Select Id From UserRole Where PortalType = 'None' Limit 1];
          system.debug('portalRole is ' + portalRole);

          Profile profile1 = [Select Id from Profile where name = 'System Administrator'];
          User portalAccountOwner2 = new User(
          UserRoleId = portalRole.Id,
          ProfileId = profile1.Id,
          Username ='test24fgfdg446@test.com',
          Alias = 'batman',
          Email='bruce.wayne@wayneenterprises.com',
          EmailEncodingKey='UTF-8',
          Firstname='Bruce',
          Lastname='Wayne',
          LanguageLocaleKey='en_US',
          LocaleSidKey='en_US',
          TimeZoneSidKey='America/Chicago'
          );
          Database.insert(portalAccountOwner2);
          Account portalAccount2 = new Account(
          Name = 'TestAccount2',
          OwnerId = portalAccountOwner2.Id,
          OSM_Preferred_Billing_Frequency_Lock__c=false,
          BMS_Customer_ID__c='1234',
          OSM_Preferred_Payment_Method__c='po',
          OSM_Preferred_Payment_IsBolt_PO__c=false
          );
          System.runAs(portalAccountOwner2){
              Database.insert(portalAccount2);
          }

          //Create contact
          Contact contact1 = new Contact(
          FirstName = 'Test',
          Lastname = 'McTesty',
          Username__c = 'testUserName7789@gmail.com',
          AccountId = portalAccount2.Id,
          IAM_Contact_Status__c='Pending',
          Email ='test@test.com'
          );
          System.runAs(portalAccountOwner2){
              Database.insert(contact1);
          } 
          
          User testUser = new User();
          testUser.FirstName = 'Testttt';
          testUser.LastName = 'lasttt';
          testUser.UserName = 'test2abc454542@test.com';
          testUser.Email = 'bruce.wayne@wayneenterprises.com';
          testUser.Alias = 'batman';
          testUser.ContactId = contact1.Id;
          testUser.CommunityNickname = 'test12345h';
          testUser.ProfileId =portal_PROFILE_ID;
          testUser.TimeZoneSidKey = 'America/Los_Angeles';
          testUser.isActive = true;
          testUser.LocaleSidKey = 'en_US';
          testUser.LanguageLocaleKey = 'en_US';
          testUser.EmailEncodingKey = 'ISO-8859-1';
            System.runAs(portalAccountOwner2){
                  insert testUser;
            
          }
        // Creating address
        System.runAs(portalAccountOwner2) {
           
            ccrz__E_Order__c order = new ccrz__E_Order__c();
            order.Id = transecRes.order.id;
            order.ccrz__OrderStatus__c = 'Order Submitted';
            update order;
            ccrz__E_Product__c pro = new ccrz__E_Product__c();
            pro.Group_Name__c = 'DA';
            pro.Name = 'Service Tech Kit';
            pro.ccrz__SKU__c = 'INS-Pro-P-02300';
            pro.ccrz__Quantityperunit__c = 1;
            pro.ccrz__ProductType__c = 'Product';
            pro.Product_Range__c = 'Service Plus';
            pro.isIAMProvisioningRequired__c = true;
            pro.Product_Class_Code__c = 'SW-Web Access';
            pro.LicenseName__c = 'Service Plus Basic';
            pro.Id = transecRes.objSetupDate.compositeProduct.Id;
            update pro;
            
            ccrz.cc_RemoteActionContext objRemotCtx = new ccrz.cc_RemoteActionContext();
            //objRemotCtx.portalUserId = transecRes.objSetupDate.objUserID;
            objRemotCtx.portalUserId = testUser.id;
             objRemotCtx.effAccountId = transecRes.objSetupDate.account.Id;
            ccrz.cc_CallContext.initRemoteContext(objRemotCtx);
            
            
             Test.startTest();
            OSM_SW_MyOrders_Comp_Ctrl.checkIAMUserProvisionedCount(objRemotCtx, order.id);
            
            ccrz__E_Product__c comp = new ccrz__E_Product__c();
            comp.QSOLType__c = 'EBU';
            comp.isIAMProvisioningRequired__c = true;
            comp.Id = transecRes.objSetupDate.componentList[0].Id;
            update comp;
            
            pro.QSOLType__c = 'EBU';
            pro.Name = 'QuickServe Online';
            update pro;
            
            OSM_SW_MyOrders_Comp_Ctrl.checkIAMUserProvisionedCount(objRemotCtx, transecRes.order.id);
            OSM_SW_MyOrders_Comp_Ctrl obj01 = new OSM_SW_MyOrders_Comp_Ctrl();
            OSM_SW_MyOrders_Comp_Ctrl.OrderDetail obj02 = new OSM_SW_MyOrders_Comp_Ctrl.OrderDetail();
            OSM_SW_MyOrders_Comp_Ctrl.OSM_IAMProvisioningDetails objWarp = new OSM_SW_MyOrders_Comp_Ctrl.OSM_IAMProvisioningDetails();
           
            Test.stopTest();
           
            
        }
          
    }
   
   static testMethod void tetsMethod8() {  
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

          Id portal_PROFILE_ID = [SELECT Id FROM Profile WHERE Name = 'IAM_Site_Admin_Community' Limit 1 ].Id;
          //Id roleId=[select id,name from UserRole where name='CumminsFleetsCustomerUser' limit 1].id; 
           
         UserRole portalRole = [Select Id From UserRole Where PortalType = 'None' Limit 1];
          system.debug('portalRole is ' + portalRole);

          Profile profile1 = [Select Id from Profile where name = 'System Administrator'];
          User portalAccountOwner2 = new User(
          UserRoleId = portalRole.Id,
          ProfileId = profile1.Id,
          Username ='test24899446@test.com',
          Alias = 'batman',
          Email='bruce.wayne@wayneenterprises.com',
          EmailEncodingKey='UTF-8',
          Firstname='Bruce',
          Lastname='Wayne',
          LanguageLocaleKey='en_US',
          LocaleSidKey='en_US',
          TimeZoneSidKey='America/Chicago'
          );
          Database.insert(portalAccountOwner2);
          Account portalAccount2 = new Account(
          Name = 'TestAccount2',
          OwnerId = portalAccountOwner2.Id,
          OSM_Preferred_Billing_Frequency_Lock__c=false,
          BMS_Customer_ID__c='1234',
          OSM_Preferred_Payment_Method__c='po',
          OSM_Preferred_Payment_IsBolt_PO__c=false
          );
          System.runAs(portalAccountOwner2){
              Database.insert(portalAccount2);
          }

          //Create contact
          Contact contact1 = new Contact(
          FirstName = 'Test',
          Lastname = 'McTesty',
          Username__c = 'testUserName7789@gmail.com',
          AccountId = portalAccount2.Id,
          IAM_Contact_Status__c='Pending',
          Email ='test@test.com'
          );
          System.runAs(portalAccountOwner2){
              Database.insert(contact1);
          } 
          
          User testUser = new User();
          testUser.FirstName = 'Testttt';
          testUser.LastName = 'lasttt';
          testUser.UserName = 'test2abv78782@test.com';
          testUser.Email = 'bruce.wayne@wayneenterprises.com';
          testUser.Alias = 'batman';
          testUser.ContactId = contact1.Id;
          testUser.CommunityNickname = 'test12345h';
          testUser.ProfileId =portal_PROFILE_ID;
          testUser.TimeZoneSidKey = 'America/Los_Angeles';
          testUser.isActive = true;
          testUser.LocaleSidKey = 'en_US';
          testUser.LanguageLocaleKey = 'en_US';
          testUser.EmailEncodingKey = 'ISO-8859-1';
            System.runAs(portalAccountOwner2){
                  insert testUser;
            
          }
        // Creating address
        System.runAs(portalAccountOwner2) {
           
            ccrz__E_Order__c order = new ccrz__E_Order__c();
            order.Id = transecRes.order.id;
            order.ccrz__OrderStatus__c = 'Order Submitted';
            update order;
            ccrz__E_Product__c pro = new ccrz__E_Product__c();
            pro.Group_Name__c = 'DA';
            pro.Name = 'Service Tech Kit';
            pro.ccrz__SKU__c = 'INS-Pro-P-02300';
            pro.ccrz__Quantityperunit__c = 1;
            pro.ccrz__ProductType__c = 'Product';
            pro.Product_Range__c = 'Service Plus';
            pro.isIAMProvisioningRequired__c = true;
            pro.Product_Class_Code__c = 'SW-Web Access';
            pro.LicenseName__c = 'Service Plus Basic';
            pro.Id = transecRes.objSetupDate.compositeProduct.Id;
            update pro;
            
            ccrz.cc_RemoteActionContext objRemotCtx = new ccrz.cc_RemoteActionContext();
            //objRemotCtx.portalUserId = transecRes.objSetupDate.objUserID;
            objRemotCtx.portalUserId = testUser.id;
             objRemotCtx.effAccountId = transecRes.objSetupDate.account.Id;
            ccrz.cc_CallContext.initRemoteContext(objRemotCtx);
            
            List<String> orderItemIdlst = new List<String>();
            List<String> orderItemIdlst2 = new List<String>();//LL36 @Vishnu 9th Aug 2022
            orderItemIdlst.add(transecRes.orderItem.Id);
            
             Test.startTest();
            OSM_SW_MyOrders_Comp_Ctrl.checkIAMUserProvisionedCount(objRemotCtx, order.id);
            
            ccrz__E_Product__c comp = new ccrz__E_Product__c();
            comp.QSOLType__c = 'EBU';
            comp.isIAMProvisioningRequired__c = true;
            comp.Id = transecRes.objSetupDate.componentList[0].Id;
            update comp;
            
            pro.QSOLType__c = 'EBU';
            pro.Name = 'QuickServe Online';
            update pro;
            OSM_SW_MyOrders_Comp_Ctrl.UpdateTPRecordForFW(transecRes.order.id);
            OSM_SW_MyOrders_Comp_Ctrl.CallRefundSubmitOrderForFW(transecRes.order.id);
            OSM_SW_MyOrders_Comp_Ctrl.checkIAMUserProvisionedCount(objRemotCtx, transecRes.order.id);
            OSM_SW_MyOrders_Comp_Ctrl.callRefundReq(objRemotCtx,  orderItemIdlst,orderItemIdlst2)  ;
            OSM_SW_MyOrders_Comp_Ctrl.callCreateCreditMemo(objRemotCtx,  orderItemIdlst,transecRes.order.id);

            Test.stopTest();
           
            
        }
          
    }

    static testMethod void tetsMethod90() {  
        TestProductSetupReq testReq = new TestProductSetupReq();
        testReq.permissionSetName = 'OSM_Support_Admin';
        testReq.accountGroupName = 'TestingAccountGroup';
        testReq.accountName = 'TestingAccount';
        testReq.compositeProductName = 'Connected Diagnostics';
        testReq.compositeProductSKU = '1234567-BUS';
        testReq.compositeProductGroupName = 'SES';
        testReq.compositeProductProductType = 'Aggregated';
        testReq.componentProductName = 'CD Base-BUS';
        testReq.componentProductStatus = 'Released';
        testReq.componentProductSKU = '1301298-BUS';
        testReq.componentProductGroupName = 'SES';
        testReq.componentProductPackageName = 'Base';
        testReq.priceListName = 'TestPriceList';
        testReq.specName = 'TestName';

        TestCompletedTransactionSetUpRes transecRes = new TestCompletedTransactionSetUpRes();
        transecRes = OSM_TestDataCreationUtility.createProductSetUp(testReq);

          Id portal_PROFILE_ID = [SELECT Id FROM Profile WHERE Name = 'IAM_Site_Admin_Community' Limit 1 ].Id;
          //Id roleId=[select id,name from UserRole where name='CumminsFleetsCustomerUser' limit 1].id; 
           
         UserRole portalRole = [Select Id From UserRole Where PortalType = 'None' Limit 1];
          system.debug('portalRole is ' + portalRole);

          Profile profile1 = [Select Id from Profile where name = 'System Administrator'];
          User portalAccountOwner2 = new User(
          UserRoleId = portalRole.Id,
          ProfileId = profile1.Id,
          Username ='test24ggh446@test.com',
          Alias = 'batman',
          Email='bruce.wayne@wayneenterprises.com',
          EmailEncodingKey='UTF-8',
          Firstname='Bruce',
          Lastname='Wayne',
          LanguageLocaleKey='en_US',
          LocaleSidKey='en_US',
          TimeZoneSidKey='America/Chicago'
          );
          Database.insert(portalAccountOwner2);
          Account portalAccount2 = new Account(
          Name = 'TestAccount2',
          OwnerId = portalAccountOwner2.Id,
          OSM_Preferred_Billing_Frequency_Lock__c=false,
          BMS_Customer_ID__c='1234',
          OSM_Preferred_Payment_Method__c='po',
          OSM_Preferred_Payment_IsBolt_PO__c=false
          );
          System.runAs(portalAccountOwner2){
              Database.insert(portalAccount2);
          }

          //Create contact
          Contact contact1 = new Contact(
          FirstName = 'Test',
          Lastname = 'McTesty',
          Username__c = 'testUserName7789@gmail.com',
          AccountId = portalAccount2.Id,
          IAM_Contact_Status__c='Pending',
          Email ='test@test.com'
          );
          System.runAs(portalAccountOwner2){
              Database.insert(contact1);
          } 
          
          User testUser = new User();
          testUser.FirstName = 'Testttt';
          testUser.LastName = 'lasttt';
          testUser.UserName = 'test21bm4ls@test.com';
          testUser.Email = 'bruce.wayne@wayneenterprises.com';
          testUser.Alias = 'batman';
          testUser.ContactId = contact1.Id;
          testUser.CommunityNickname = 'test12345h';
          testUser.ProfileId =portal_PROFILE_ID;
          testUser.TimeZoneSidKey = 'America/Los_Angeles';
          testUser.isActive = true;
          testUser.LocaleSidKey = 'en_US';
          testUser.LanguageLocaleKey = 'en_US';
          testUser.EmailEncodingKey = 'ISO-8859-1';
            System.runAs(portalAccountOwner2){
                  insert testUser;
            
          }
        // Creating address
        System.runAs(portalAccountOwner2) {
           
            ccrz__E_Order__c order = new ccrz__E_Order__c();
            order.Id = transecRes.order.id;
            order.ccrz__OrderStatus__c = 'Order Submitted';
            update order;
            ccrz__E_Product__c pro = new ccrz__E_Product__c();
            pro.Group_Name__c = 'SES';
            pro.Name = 'Service Tech Kit';
            pro.ccrz__SKU__c = 'INS-Pro-P-02300';
            pro.ccrz__Quantityperunit__c = 1;
            pro.ccrz__ProductType__c = 'Product';
            pro.Product_Range__c = 'Service Plus';
            pro.isIAMProvisioningRequired__c = true;
            pro.Product_Class_Code__c = 'SW-Web Access';
            pro.LicenseName__c = 'Service Plus Basic';
            //pro.Id = transecRes.objSetupDate.compositeProduct.Id;
            insert pro;
            
            
            
            ccrz__E_Product__c pro1 = new ccrz__E_Product__c();
            pro1.Group_Name__c = 'SES';
            pro1.ccrz__SKU__c = 'INS-Pro-P-023002';
            pro1.ccrz__Quantityperunit__c = 1;
            pro1.ccrz__ProductType__c = 'Bundle';
            pro1.Id = transecRes.objSetupDate.componentList[0].Id;
            update pro1;
            
            ccrz__E_RelatedProduct__c relObj = new ccrz__E_RelatedProduct__c();
            relObj.ccrz__Product__c = transecRes.objSetupDate.componentList[0].Id;
            relObj.ccrz__RelatedProduct__c = pro.Id;
            relObj.ccrz__RelatedProductType__c = 'Accessories';
            relObj.ccrz__StartDate__c = System.Today();
            relObj.ccrz__EndDate__c = System.Today()+1;
            relObj.ccrz__Enabled__c = true;
            
            insert relObj;
            
            
            
            ccrz.cc_RemoteActionContext objRemotCtx = new ccrz.cc_RemoteActionContext();
            //objRemotCtx.portalUserId = transecRes.objSetupDate.objUserID;
            objRemotCtx.portalUserId = testUser.id;
             objRemotCtx.effAccountId = transecRes.objSetupDate.account.Id;
            ccrz.cc_CallContext.initRemoteContext(objRemotCtx);
            
            List<String> orderItemIdlst = new List<String>();
            List<String> orderItemIdlst2 = new List<String>();
            orderItemIdlst.add(transecRes.orderItem.Id);
            
            Test.startTest();
            
            
                OSM_SW_MyOrders_Comp_Ctrl.checkAddOnSubscription(objRemotCtx,order.id);

            Test.stopTest();
           
            
        }
          
    }
}