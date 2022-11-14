@isTest(SeeAllData = true)
public class OSM_TestDataCreationUtility 
{
    
    
    public static TestCompletedTransactionSetUpRes createProductSetUp(TestProductSetupReq testProductSetupReq)
    {
		
		OSM_TestDataCreationUtility_NonStatic testData = new OSM_TestDataCreationUtility_NonStatic();
		return testData.createProductSetUp(testProductSetupReq);
    }
    
    public static TestCompletedTransactionSetUpRes createCompletedTransactionFlowTestData(TestProductSetupRes testProductSetupRes, Decimal amount, Decimal taxAmount)
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
            List<ccrz__E_Cart__c> lstECart = TestingUtils.CreateCart(1, 'SoftwareStore', 'Cart', testProductSetupRes.objUserID, true, 'Closed', true,testProductSetupRes.account.ID);
            
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
        system.debug('---'+ [select id,name,email,ProfileId, firstname, lastname, contactId, contact.accountId  from user where profile.Name= 'IAM_Site_Admin_Community' and isactive=true and contactId!=null limit 1]);
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