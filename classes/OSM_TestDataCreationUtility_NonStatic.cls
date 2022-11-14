@isTest(SeeAllData = true)
public class OSM_TestDataCreationUtility_NonStatic 
{
    public TestCompletedTransactionSetUpRes createProductSetUp(TestProductSetupReq testProductSetupReq)
    {
    
        TestProductSetupRes testProductSetupRes = new TestProductSetupRes();
        /* NOT SURE*/
        UserRole portalRole = [Select Id From UserRole Where PortalType = 'None' Limit 1];
        
        // Query Profile Id
        //List<Profile> listObjProfile = [Select id, name from profile where name = 'CloudBurst Customer Community Profile'];
        
        // Create User
        //Sharad 20 Sept: Comment this because we have to create portel user
        /*
        User objUser;
        
        if(listObjProfile.size() > 0){
            objUser = TestingUtils.createUser('TestUserDA', listObjProfile[0].Id, true);  
        }else{
            listObjProfile = [Select id, name from profile where name = 'Customer Community Plus User'];
            if(listObjProfile.size() > 0){
                objUser = TestingUtils.createUser('TestUserDA', listObjProfile[0].Id, true); 
            }
        } */
        
        // New Code for portal user
        
        Profile profile1 = [Select Id from Profile where name = 'System Administrator'];
        User portalAccountOwner1 = new User(
            id=UserInfo.getUserId(),
        UserRoleId =  UserInfo.getUserRoleId(),
        ProfileId = UserInfo.getProfileId(),
        Username = System.now().millisecond() + 'test210@test.com.osm',
        Email=UserInfo.getUserEmail(),
        EmailEncodingKey='UTF-8',
        Firstname=UserInfo.getFirstName(),
        Lastname=UserInfo.getLastName(),
        LanguageLocaleKey='en_US',    
        LocaleSidKey='en_US',
        TimeZoneSidKey='America/Chicago'
        );
        //Database.insert(portalAccountOwner1);
       
        testProductSetupRes.loggedInUser =portalAccountOwner1;
        System.runAs ( portalAccountOwner1 ) {
        
        // till here
        
            if(null != testProductSetupReq && null != testProductSetupReq.permissionSetName 
               && null != testProductSetupReq.accountGroupName && null != testProductSetupReq.accountName 
               && null != testProductSetupReq.compositeProductName && null != testProductSetupReq.compositeProductSKU 
               && null != testProductSetupReq.compositeProductGroupName && null != testProductSetupReq.compositeProductProductType 
               && null != testProductSetupReq.componentProductName && null != testProductSetupReq.componentProductStatus 
               && null != testProductSetupReq.componentProductSKU && null != testProductSetupReq.componentProductGroupName 
               && null != testProductSetupReq.componentProductPackageName && null != testProductSetupReq.priceListName 
               && null != testProductSetupReq.specName)
            {
                
                
                //example
                //testProductSetupReq.permissionSetName = 'OSM_Business_Admin';
                
                // get User ID of a particular permission set
                List<PermissionSetAssignment> lstcurrentUserPerSet = [SELECT Id, PermissionSet.Name, AssigneeId 
                                                                      FROM PermissionSetAssignment 
                                                                      WHERE PermissionSet.Name = :testProductSetupReq.permissionSetName];
                
                //ID objUserID = lstcurrentUserPerSet[0].AssigneeId;
                
                ID objUserID = portalAccountOwner1.Id;
                
                if(null != objUserID)
                {
                    // create products - product, spec, category, subprodterms, pricelists
                    
                    //Create Account Group
                    List<ccrz__E_AccountGroup__c> listAccountGrp = TestingUtils.createAccountGroup(1, testProductSetupReq.accountGroupName, 'Best Price', true);
                    
                    //Create Account
                    List<Account> listAccount = TestingUtils.createAccount(1, testProductSetupReq.accountName, listAccountGrp[0].Id, objUserID, true) ;
                    
                    //Create Contact
                    List<Contact> listContact  = TestingUtils.createContact(1, listAccount[0].Id, objUserID, true);
                    
                    
                  /*  String portalUserName = System.now().millisecond() + 'test12345@test.com.osm';
                     Profile portalProfile = [SELECT Id FROM Profile where name = 'IAM_Site_Admin_Community' Limit 1];
                    User user1 = new User(
                    Username = portalUserName,
                    ContactId = listContact[0].Id,
                    ProfileId = portalProfile.Id,
                    Alias = 'test123',
                    Email = 'test12345@test.com',
                    EmailEncodingKey = 'UTF-8',
                    LastName = 'McTesty',
                    CommunityNickname = 'test12345',
                    TimeZoneSidKey = 'America/Los_Angeles',
                    LocaleSidKey = 'en_US',
                    LanguageLocaleKey = 'en_US'
                    );
                    Database.insert(user1);
                    objUserID = user1.Id; 
                    */
                    
                    
                    objUserID = getPortalUser().Id;
                    System.debug('$$$$$$$$$$$$$$$$$$$$$$$$$$$: '+getPortalUser().email);
                    System.debug('$$$$$$$$$$$$$$$$$$$$$$$$$$$: '+getPortalUser().contact.accountId);
                    System.debug('$$$$$$$$$$$$$$$$$$$$$$$$$$$: '+getPortalUser().contactId);
                   /*  String accId = getPortalUser().contact.accountId;
                    String contId = getPortalUser().contactId;
                    Contact contactToUpdate = [select id,accountid from contact where id=:contId limit 1];
                    contactToUpdate.accountid = listAccount[0].Id;
                    update contactToUpdate;
                   */ 
                    
                    
                    //Create single Product to pass as Composite (Main Product)
                    ccrz__E_Product__c compositeProduct = TestingUtils.createCompositeProduct(testProductSetupReq.compositeProductName, testProductSetupReq.compositeProductSKU, testProductSetupReq.compositeProductGroupName, testProductSetupReq.compositeProductProductType, true);
                    
                    //Create List of Component Products
                    List<ccrz__E_Product__c> lstComponentProductsCombined = new List<ccrz__E_Product__c>();
                    List<ccrz__E_Product__c> lstComponentProductsBase = TestingUtils.createCcComponentProducts(1, testProductSetupReq.componentProductName, testProductSetupReq.componentProductStatus, 1, testProductSetupReq.componentProductSKU, testProductSetupReq.componentProductGroupName, testProductSetupReq.componentProductPackageName, true);
                    
                    lstComponentProductsCombined.addAll(lstComponentProductsBase);
                    
                    //Create CC Composite Product
                    List<ccrz__E_CompositeProduct__c> listCcCompositeProducts = TestingUtils.createCcCompProducts(compositeProduct.Id, lstComponentProductsCombined, true);
                    
                    // Create E SubProdTerm for composite product
                    List<ccrz__E_SubProdTerm__c> lstESubProdTerm = new List<ccrz__E_SubProdTerm__c>();
                    lstESubProdTerm.addAll(TestingUtils.createSubProdTerm(1, 'TestSubProdTerm ' + testProductSetupReq.compositeProductName, lstComponentProductsBase[0].Id, '*', true));
                    
                    // Create PriceList
                    List<ccrz__E_PriceList__c> lstPriceList = TestingUtils.createPriceList(1, testProductSetupReq.priceListName, 'SoftwareStore', true, 'USD', true);
                    
                    //Create Price List Item
                    List<ccrz__E_PriceListItem__c> lstPriceListItem = TestingUtils.createPriceListItem(1,lstESubProdTerm[0].Id, lstPriceList, lstComponentProductsCombined, true);
                    
                    //Create Account Group PriceList
                    List<ccrz__E_AccountGroupPriceList__c> lstAccGrpPriceList = TestingUtils.createAccGrpPriceList(1, listAccountGrp, lstPriceList, true, 500, true);
                    
                    // Create CC Spec
                    List<ccrz__E_Spec__c> lstCcSpec = TestingUtils.createCcSpecs(1, testProductSetupReq.specName, true);
                    
                    // Create CC Product Spec
                    List<ccrz__E_ProductSpec__c> lstCcProdSpec = TestingUtils.createCcProductSpecs(1, compositeProduct.Id, lstCcSpec, true);
                    
                    
                    testProductSetupRes.objUserID = objUserID;
                    
                    testProductSetupRes.accountGroup = listAccountGrp[0];
                    testProductSetupRes.account = [Select Id, Name, ccrz__E_AccountGroup__c , BillingStreet , BillingCity , BillingState , BOLT_Account_Number__c , BillingPostalCode , BillingCountry , CMI_Region__c , CSS_Locale__c , RecordTypeId , OSM_Preferred_Payment_Method__c , OwnerId , CMI_Cid__c , IAM_Primary_Market_Segment__c , CSS_Timezone__c,CSS_DistributorCode__c  from Account where Id  =: listAccount[0].Id];
                    
                    testProductSetupRes.contact = [Select Id, FirstName , LastName , AccountId , MobilePhone , Email , IAM_Contact_Status__c  from Contact where Id =: listContact[0].Id];
                    
                    testProductSetupRes.compositeProduct = compositeProduct;
                    testProductSetupRes.componentList = new List<ccrz__E_Product__c>();
                    testProductSetupRes.componentList.addAll(lstComponentProductsBase);
                    
                    testProductSetupRes.compositeProductObjectList = new List<ccrz__E_CompositeProduct__c>();
                    testProductSetupRes.compositeProductObjectList.addAll(listCcCompositeProducts);
                    
                    testProductSetupRes.priceList = lstPriceList[0];
                    testProductSetupRes.subProdTermList = new List<ccrz__E_SubProdTerm__c>();
                    testProductSetupRes.subProdTermList.addAll(lstESubProdTerm);
                    testProductSetupRes.priceListItemList = new List<ccrz__E_PriceListItem__c>();
                    testProductSetupRes.priceListItemList.addAll(lstPriceListItem);
                    
                    TestCompletedTransactionSetUpRes testCompletedTransactionSetUpRes = new TestCompletedTransactionSetUpRes();
                    
                    testCompletedTransactionSetUpRes = createCompletedTransactionFlowTestData(testProductSetupRes, 40,6,listAccount);
                    
                    testCompletedTransactionSetUpRes.objSetupDate = new TestProductSetupRes();
                    
                    testCompletedTransactionSetUpRes.objSetupDate = testProductSetupRes;
                    
                    return testCompletedTransactionSetUpRes;
                }
                else
                {
                    System.debug('Null value present in request');
                }
            }
            else
            {
                System.debug('Invalid Permission set');
            }
        }
        return null;
    }
    
    public TestCompletedTransactionSetUpRes createCompletedTransactionFlowTestData(TestProductSetupRes testProductSetupRes, Decimal amount, Decimal taxAmount,List<Account> listAccount)
    {
        TestCompletedTransactionSetUpRes testCompletedTransactionSetUpRes = new TestCompletedTransactionSetUpRes();
        
        if(null != testProductSetupRes && null != testProductSetupRes.accountGroup 
           && null != testProductSetupRes.objUserID && null != testProductSetupRes.priceList 
           && null != testProductSetupRes.account && null != testProductSetupRes.contact && null != testProductSetupRes.compositeProduct 
           && null != testProductSetupRes.componentList && testProductSetupRes.componentList.size() > 0 
           && null != testProductSetupRes.compositeProductObjectList && testProductSetupRes.compositeProductObjectList.size() > 0 
           && null != testProductSetupRes.subProdTermList && testProductSetupRes.subProdTermList.size() > 0 
           && null != testProductSetupRes.priceListItemList && testProductSetupRes.priceListItemList.size() > 0)
        {
            // create cart
            List<ccrz__E_Cart__c> lstECart = TestingUtils.CreateCart(1, 'SoftwareStore', 'Cart', testProductSetupRes.objUserID, true, 'Closed', true,listAccount[0].Id);
            
            // add to cart items
            List<ccrz__E_CartItem__c> lstECartItem = TestingUtils.createCartItem(1, 'SoftwareStore', lstECart[0].Id, 'Cart', 1, testProductSetupRes.compositeProduct.ID, testProductSetupRes.subProdTermList[0].Id, 500, true);
            
            //Create Order
            ccrz__E_Order__c testOrder = TestingUtils.createOrder(testProductSetupRes.contact.ID,'test order',true);
            testOrder.ccrz__Account__c = testProductSetupRes.account.ID;
            testOrder.ccrz__OriginatedCart__c = lstECart[0].Id;
            update testOrder;
            
            //Create Order Item
            ccrz__E_OrderItem__c testOrderItem = TestingUtils.createOrderItems(testOrder.Id, testProductSetupRes.componentList[0].ID,true);
            
            // create contact address
            ccrz__E_ContactAddr__c contactAddress = createContactAddress(testProductSetupRes.account.ID);
            
            // create subscription and osm order subscriptions
            ccrz__E_Subscription__c subscription = createSubscription(testProductSetupRes.account.ID, testOrder.ID, 
                                                                      testOrderItem.ID, testProductSetupRes.compositeProduct.ID, 
                                                                      testProductSetupRes.componentlist[0].ID, testProductSetupRes.objUserID, 
                                                                      testProductSetupRes.subProdTermList[0].ID, contactAddress.ID, amount, 'Active', true);
                                                                      
             ccrz__E_Subscription__c subscription1 = createSubscription(testProductSetupRes.account.ID, testOrder.ID, 
                                                                      testOrderItem.ID, testProductSetupRes.compositeProduct.ID, 
                                                                      testProductSetupRes.componentlist[0].ID, testProductSetupRes.objUserID, 
                                                                      testProductSetupRes.subProdTermList[0].ID, contactAddress.ID, amount, 'Expired', true);
                                                                      
            OSM_Order_Subscription__c orderSubscriptionjunction = createOrderSubscriptionjunction(testOrder.ID, testOrderItem.ID, 
                                                                                                  subscription.ID, testProductSetupRes.contact.ID, true);
            
            // create invoices
            ccrz__E_Invoice__c invoice = createInvoice(testOrder.ID, testProductSetupRes.account.ID, 
                                                       testProductSetupRes.contact.ID, testProductSetupRes.objUserID, amount, true);
            System.debug('Created Invoice'+invoice);
            // create invoice items and order invoice junction
            ccrz__E_InvoiceItem__c invoiceItem_Item = createInvoiceItem_Item(testOrder.ID, testOrderItem.ID, invoice.ID, subscription.ID, 'Item', amount, true);
            
            ccrz__E_InvoiceItem__c invoiceItem_Tax = createInvoiceItem_Item(testOrder.ID, null, invoice.ID, null, 'Tax', taxAmount, true);
            
            // create invoice and order junction
            OSM_Orders_In_Invoice__c orderInInvoice = createOrderInInvoice(testOrder.ID, invoice.ID, 'Success', taxAmount, true);
            
            OSM_InvoiceLine_And_OrderLine__c invoiceLineAndOrderLine = createInvoiceLineAndOrderLine(testOrderItem.ID, invoiceItem_Item.ID, 
                                                                                                     orderInInvoice.ID, taxAmount, amount, true);
            
            // create transaction payment
            ccrz__E_TransactionPayment__c transactionPayment = createTransactionPayment(testOrder.ID, invoice.ID, testProductSetupRes.account.ID, 
                                                                                        testProductSetupRes.contact.ID, testProductSetupRes.objUserID, 
                                                                                        'Order Placed Success', 'po', true);
            
            testCompletedTransactionSetUpRes.cart = lstECart[0];
            testCompletedTransactionSetUpRes.cartItem = lstECartItem[0];
            testCompletedTransactionSetUpRes.order = testOrder;
            testCompletedTransactionSetUpRes.orderItem = testOrderItem;
            testCompletedTransactionSetUpRes.subscription = subscription;
            testCompletedTransactionSetUpRes.orderSubscriptionjunction = orderSubscriptionjunction;
            testCompletedTransactionSetUpRes.invoice = invoice;
            testCompletedTransactionSetUpRes.invoiceItems = new List<ccrz__E_InvoiceItem__c>();
            testCompletedTransactionSetUpRes.invoiceItems.add(invoiceItem_Item);
            testCompletedTransactionSetUpRes.invoiceItems.add(invoiceItem_Tax);
            testCompletedTransactionSetUpRes.orderInInvoice = orderInInvoice;
            testCompletedTransactionSetUpRes.invoiceLineAndOrderLine = invoiceLineAndOrderLine;
            testCompletedTransactionSetUpRes.transactionPayment = transactionPayment;
            
        }
        else
        {
            System.debug('Null value present in request');
            return null;
        }
        
        return testCompletedTransactionSetUpRes;
    }
    
    public static ccrz__E_ContactAddr__c createContactAddress(ID accountID)
    {
        ccrz__E_ContactAddr__c contactAddress = new ccrz__E_ContactAddr__c();
        contactAddress.Account__c = accountID;
        contactAddress.ccrz__AddressFirstline__c = 'Test address line 1';
        contactAddress.ccrz__City__c = 'Columbus';
        insert contactAddress;
        
        return contactAddress;
    }
    
    public static ccrz__E_Subscription__c createSubscription(ID accountId, ID orderID, ID orderItemID,
                                                             ID compositeProductID, ID componentProductID, ID userID, 
                                                             ID subProdTermID, ID contactAddressID, Decimal recurringPrice, String status, Boolean doInsert)
    {
        ccrz__E_Subscription__c subscription = new ccrz__E_Subscription__c();
        
        subscription.ccrz__Sequence__c = 500;
        subscription.ccrz__Storefront__c = 'SoftwareStore';
        subscription.ccrz__Account__c = accountID;
        subscription.ccrz__CCOrder__c = orderID;
        subscription.ccrz__CCOrderItem__c = orderItemID;
        subscription.ccrz__CurrencyISOCode__c = 'USD';
        subscription.ccrz__Quantity__c = 1;
        subscription.ccrz__RecurringPrice__c = recurringPrice;
        subscription.ccrz__RecurringPriceSubAmt__c = recurringPrice;
        subscription.ccrz__SubscriptionStartDate__c = System.today().addMonths(-2);
        subscription.OSM_Subscription_End_Date__c = System.today().addMonths(5);
        subscription.OSM_Display_Product__c = compositeProductID;
        subscription.ccrz__SPT__c = subProdTermID;
        subscription.ccrz__SubscriptionProduct__c = componentProductID;
        subscription.ccrz__SubscriptionStatus__c = status;
        subscription.ccrz__InstallmentCountRemaining__c = 5;
        subscription.ccrz__User__c = userID;
        
        subscription.Next_Invoice_Generation_Date__c = System.today().addMonths(-1);
        subscription.Subsequent_Next_Invoice_Due_Dt__c = System.today();
        subscription.Subsequent_Next_Invoice_Generation_Dt__c = System.today();
            
        //subscription.Current_Invoice_Due_Date__c = System.today().addMonths(-2);
        //subscription.Current_Invoice_Generation_Date__c = System.today().addMonths(-2);
            
        subscription.ccrz__CurrencyISOCode__c='USD';
        subscription.ccrz__InstallmentAddress__c=contactAddressID;
        subscription.ccrz__OrderAddress__c=contactAddressID;
        subscription.ccrz__InstallmentNextDate__c=System.today().addMonths(-1);
                    
            subscription.Recurring_Invoice_Start_Date__c = System.today().addMonths(-2);
        
        subscription.ccrz__SPTInstallmentCount__c = 12;
            subscription.ccrz__InstallmentCountRemaining__c = 11;
        
        if(doInsert)
            insert subscription;
        
        return subscription;
    }
    
    public static OSM_Order_Subscription__c createOrderSubscriptionjunction(ID orderID, ID orderItemID, ID subscriptionID,
                                                                            ID contactID, Boolean doInsert)
    {
        OSM_Order_Subscription__c orderSubscriptionjunction = new OSM_Order_Subscription__c();
        orderSubscriptionjunction.CC_Order_Item__c = orderItemID;
        orderSubscriptionjunction.OSM_CCOrder__c = orderID;
        orderSubscriptionjunction.OSM_CCSubscription__c = subscriptionID;
        orderSubscriptionjunction.Contact__c = contactID;
        orderSubscriptionjunction.CCQuantity__c = 1;
        orderSubscriptionjunction.Billing_Frequency__c = 'Monthly';
        
        if(doInsert)
            insert orderSubscriptionjunction;
        
        return orderSubscriptionjunction;
    }
    
    public static ccrz__E_Invoice__c createInvoice(ID orderID, ID accountID, ID contactID, ID objUserID, Decimal amount, Boolean doInsert)
    {
        ccrz__E_Invoice__c invoice = new ccrz__E_Invoice__c();
        invoice.ccrz__CCOrder__c = orderID;
        invoice.ccrz__Contact__c = contactID;
        invoice.ccrz__User__c = objUserID;
        invoice.ccrz__BillTo__c = accountID;
        invoice.ccrz__SoldTo__c = accountID;
        invoice.ccrz__CurrencyCode__c = 'USD';
        invoice.ccrz__DateIssued__c = System.today();
        invoice.ccrz__DateDue__c = System.today();
        invoice.ccrz__OriginalAmount__c = amount;
        invoice.ccrz__RemainingAmount__c = 0.00;
        invoice.ccrz__Storefront__c = 'SoftwareStore';
        invoice.PDF_REMITTO_ADDRESS__c = 'REMIT TO:';
        
        if(doInsert)
            insert invoice;
        
        return invoice;
    }
    
    // create invoice items and order invoice junction
    public static ccrz__E_InvoiceItem__c createInvoiceItem_Item(ID orderID, ID orderItemID, ID invoiceID, ID subscriptionID, String type, Decimal amount, Boolean doInsert)
    {
        ccrz__E_InvoiceItem__c invoiceItem_Item = new ccrz__E_InvoiceItem__c();
        invoiceItem_Item.ccrz__OriginalAmount__c = amount;
        invoiceItem_Item.ccrz__Invoice__c = invoiceID;
        invoiceItem_Item.ccrz__CCOrderItem__c = orderItemID;
        invoiceItem_Item.ccrz__CCOrder__c = orderID;
        invoiceItem_Item.Quantity__c = 1;
        invoiceItem_Item.CC_Subscription__c = subscriptionID;
        invoiceItem_Item.ccrz__Status__c = 'Open';
        invoiceItem_Item.ccrz__Type__c = type;
        invoiceItem_Item.OSM_Bypass_Flow__c = true;
        if(doInsert)
            insert invoiceItem_Item;
        
        return invoiceItem_Item;
    }
    
    public static OSM_Orders_In_Invoice__c createOrderInInvoice(ID orderId, ID invoiceID, String vertextCallStatus, Decimal vertexTax, Boolean doInsert)
    {
        OSM_Orders_In_Invoice__c orderInInvoice = new OSM_Orders_In_Invoice__c();
        orderInInvoice.CC_Invoice__c = invoiceID;
        orderInInvoice.CC_Order__c = orderID;
        orderInInvoice.Vertex_Call_Status__c = vertextCallStatus;
        orderInInvoice.Vertex_Invoice_Call_Time__c = System.today();
        orderInInvoice.Vertex_Tax__c = vertexTax;
        
        if(doInsert)
            insert orderInInvoice;
        
        return orderInInvoice;
    }
    
    public static OSM_InvoiceLine_And_OrderLine__c createInvoiceLineAndOrderLine(ID orderItemID, ID invoiceItem_ItemID, 
                                                                                 ID orderInInvoiceID, Decimal vertexTax, 
                                                                                 Decimal salesAmount, Boolean doInsert)
    { 
        OSM_InvoiceLine_And_OrderLine__c invoiceLineAndOrderLine = new OSM_InvoiceLine_And_OrderLine__c();
        invoiceLineAndOrderLine.OSM_Orders_In_Invoice__c = orderInInvoiceID;
        invoiceLineAndOrderLine.CC_Invoice_Item__c = invoiceItem_ItemID;
        invoiceLineAndOrderLine.CC_Order_Item__c = orderItemID;
        invoiceLineAndOrderLine.Vertex_Tax__c = vertexTax;
        invoiceLineAndOrderLine.Quantity__c = 1;
        invoiceLineAndOrderLine.Sales_Amount__c = salesAmount;
        
        if(doInsert)
            insert invoiceLineAndOrderLine;
        
        return invoiceLineAndOrderLine;
    }
    
    public static ccrz__E_TransactionPayment__c createTransactionPayment(ID orderID, ID invoiceID, 
                                                                         ID accountID, ID contactID, 
                                                                         ID userID, String transactionStatus, String accountType, Boolean doInsert)
    { 
        ccrz__E_TransactionPayment__c transactionPayment = new ccrz__E_TransactionPayment__c();
        transactionPayment.Transaction_Status__c = transactionStatus;
        transactionPayment.ccrz__Storefront__c = 'SoftwareStore';
        transactionPayment.ccrz__Token__c = 'TestToken';
        transactionPayment.ccrz__TransactionCode__c = 'TestTransactionCode';
        transactionPayment.ccrz__CCOrder__c = orderID;
        transactionPayment.ccrz__InvoiceAppliedTo__c = invoiceID;
        transactionPayment.ccrz__BillTo__c = accountID;
        transactionPayment.ccrz__SoldTo__c = accountID;
        transactionPayment.ccrz__Account__c = accountID;
        transactionPayment.ccrz__Contact__c = contactID;
        transactionPayment.ccrz__User__c = userID;
        transactionPayment.ccrz__AccountType__c = accountType;
        if(doInsert)
            insert transactionPayment;
        
        return transactionPayment;
    }    
    
      public static ccrz__E_TransactionPayment__c createTransactionPayment1(ID orderID, ID invoiceID, 
                                                                         ID accountID, ID contactID, 
                                                                         ID userID, String transactionStatus, String accountType, Boolean doInsert)
    { 
        ccrz__E_TransactionPayment__c transactionPayment1 = new ccrz__E_TransactionPayment__c();
        transactionPayment1.Transaction_Status__c = transactionStatus;
        transactionPayment1.ccrz__Storefront__c = 'SoftwareStore';
        transactionPayment1.ccrz__Token__c = 'TestToken';
        transactionPayment1.ccrz__TransactionCode__c = 'TestTransactionCode';
        transactionPayment1.ccrz__CCOrder__c = orderID;
        transactionPayment1.ccrz__InvoiceAppliedTo__c = invoiceID;
        transactionPayment1.ccrz__BillTo__c = accountID;
        transactionPayment1.ccrz__SoldTo__c = accountID;
        transactionPayment1.ccrz__Account__c = accountID;
        transactionPayment1.ccrz__Contact__c = contactID;
        transactionPayment1.ccrz__User__c = userID;
        transactionPayment1.ccrz__AccountType__c = accountType;
        transactionPayment1.OSM_Order_Update_Integration_Failure__c= true;
        if(doInsert)
            insert transactionPayment1;
        
        return transactionPayment1;
    }    
    
    public static TestProductSetupReq populatedTestProductSetupReq()
    {
        TestProductSetupReq testProductSetupReq = new TestProductSetupReq();
        
        testProductSetupReq.permissionSetName = 'OSM_Business_Admin';
        
        testProductSetupReq.accountGroupName = 'Test_Account_Group'; 
        testProductSetupReq.accountName = 'Test_Account'; 
        
        testProductSetupReq.compositeProductName = 'Test_Product'; 
        testProductSetupReq.compositeProductSKU = 'Test-0001'; 
        testProductSetupReq.compositeProductGroupName = 'DA';
        testProductSetupReq.compositeProductProductType = 'Aggregated'; 
        
        testProductSetupReq.componentProductName = 'Base'; 
        testProductSetupReq.componentProductStatus = 'Released'; 
        testProductSetupReq.componentProductSKU = 'Test-0002'; 
        testProductSetupReq.componentProductGroupName = 'DA'; 
        testProductSetupReq.componentProductPackageName = 'Base'; 
        
        testProductSetupReq.priceListName = 'Test_PriceList'; 
        
        testProductSetupReq.specName = 'Test_Spec';
        
        return testProductSetupReq;
    }
    
    public static User createObjUser()
    {
        /* NOT SURE*/
        UserRole portalRole = [Select Id From UserRole Where PortalType = 'None' Limit 1];
        
        // Query Profile Id
        List<Profile> listObjProfile = [Select id, name from profile where name = 'CloudBurst Customer Community Profile'];
        
        // Create User
        User objUser;
        
        if(listObjProfile.size() > 0){
            objUser = TestingUtils.createUser('TestUserDA', listObjProfile[0].Id, true);  
        }else{
            listObjProfile = [Select id, name from profile where name = 'Customer Community Plus User'];
            if(listObjProfile.size() > 0){
                objUser = TestingUtils.createUser('TestUserDA', listObjProfile[0].Id, true); 
            }
        } 
        
        return objUser;
    }
    
    public static User getPortalUser()
    {
    /*
        String profileId = Label.OSM_FleetUserProfileId;
        User usr = [select id,name,email  from user where profileid= :profileId and isactive=true and contactId!=null limit 1  ];
        return usr;
        */
       return [select id,name,email,ProfileId, firstname, lastname, contactId, contact.accountId  from user where profile.Name= 'IAM_Site_Admin_Community' and isactive=true and contactId!=null limit 1];
    }
    
    public static ID getSystemAdministratorID()
    {
    /*
        String profileId = Label.OSM_FleetUserProfileId;
        User usr = [select id,name,email  from user where profileid= :profileId and isactive=true and contactId!=null limit 1  ];
        return usr;
        */
        //User usr = [select id,name,email,ProfileId  from user where profile.Name= 'System Administrator' and isactive=true limit 1];
        
        //return usr.ID;
        return UserInfo.getUserId();
    }
    
    public static ID getAccountRecordTypeID()
    {
        return Schema.SObjectType.Account.getRecordTypeInfosByName().get('PC_API').getRecordTypeId();
    }
    
    
}