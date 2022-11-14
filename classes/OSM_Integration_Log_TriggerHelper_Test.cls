//Test Class for flow deployment
@isTest
public class OSM_Integration_Log_TriggerHelper_Test {
    public static User u ;

    @TestSetup
    Static void createDate(){
          
        //Preparing the test data
        id blankUserId;
        User portalAccountOwner = new User(
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

        List<Profile> siteAdminProfile = [SELECT id FROM Profile WHERE Name='IAM_Site_Admin_Community' LIMIT 1];
        List<PermissionSet> storefrontAdmin = [SELECT id FROM PermissionSet WHERE Name='OSM_Storefront_Admin' LIMIT 1];
        system.RunAs(portalAccountOwner){
            ccrz__E_Category__c electronicServiceCategory = TestingUtils.createParentCategory('Electronic Service Category','EST001',true);

            List<ccrz__E_AccountGroup__c> accntGroup = TestingUtils.createAccountGroup(1, 'TestingProdUtilAccountGrp', 'Best Price', true);
            List<Account> acnt = TestingUtils.createAccount(1, 'TestingProdUtilAccount', accntGroup[0].id, portalAccountOwner.id, true);
            List<Contact> portalContact = TestingUtils.createContact(1, acnt[0].id, blankUserId, true);
            User portalUser = TestingUtils.createPortalUser( 'testuser', blankUserId, portalContact[0].id,siteAdminProfile[0].id, true );

            PermissionSetAssignment psa = new PermissionSetAssignment(PermissionSetId = storefrontAdmin[0].id, AssigneeId = portalUser.id);
            insert psa;   

            //Price List and Price List Items
            List<ccrz__E_PriceList__c> priceList = TestingUtils.createPriceList(1, 'Test Price List', 'SoftwareStore', true, 'USD', true);
            List<ccrz__E_AccountGroupPriceList__c> agpl = TestingUtils.createAccGrpPriceList(1, accntGroup, priceList, true, 500, true);
            //End of the Creation of Price List.


            //Product Creation
            List<ccrz__E_Product__c> allProductsToInsert = new List<ccrz__E_Product__c>();
            List<ccrz__E_Product__c> guidanzAggregateProduct = TestingUtils.createEProduct(1,'Cummins Guidanz™ Service Package','Released',1,'CG-Base-003','SES','','Aggregated',false);
            List<ccrz__E_Product__c> guidanzBundleProduct = TestingUtils.createEProduct(1,'Cummins Guidanz™ Service Package','Released',1,'CG-Base-003-1','SES','Base','Bundle',false);
            List<ccrz__E_Product__c> insiteAggregatedProduct = TestingUtils.createEProduct(1,'INSITE® Pro (MR/HD Plus)','Released',1,'INS-Pro-00345','SES','','Aggregated',false);
            List<ccrz__E_Product__c> insiteProduct = TestingUtils.createEProduct(1,'INSITE® Pro (MR/HD Plus)','Released',1,'INS-Pro-00345-1','SES','Base','Product',false);
            List<ccrz__E_Product__c> connectedAdvisorProduct = TestingUtils.createEProduct(1,'Connected Advisor','Released',1,'1-BUS','DA','','Aggregated',false);
            List<ccrz__E_Product__c> caBaseProduct = TestingUtils.createEProduct(1,'CA Base-BUS','Released',1,'5678903-BUS','DA','Base','Product',false);
            List<ccrz__E_Product__c> guidanzMobileAggregate = TestingUtils.createEProduct(1,'Guidanz Mobile (Includes Immediate Assessment)','Released',1,'GZ-Mobile-00045','SES','','Aggregated',false);
            List<ccrz__E_Product__c> guidanzMobileProduct = TestingUtils.createEProduct(1,'Guidanz Mobile (Includes Immediate Assessment)','Released',1,'GZ-Mobile-00045-1','SES','Base','Product',false);
            List<ccrz__E_Product__c> insiteLiteAggregate = TestingUtils.createEProduct(1,'INSITE™ Lite (MR/HD Plus)','Released',1,'INS-Lite-00045','SES','','Aggregated',false);
            List<ccrz__E_Product__c> insiteLiteProduct = TestingUtils.createEProduct(1,'INSITE™ Lite (MR/HD Plus)','Released',1,'INS-Lite-00045-1','SES','Base','Product',false);
            
            
            allProductsToInsert.addAll(guidanzAggregateProduct);
            allProductsToInsert.addAll(guidanzBundleProduct);
            allProductsToInsert.addAll(insiteAggregatedProduct);
            allProductsToInsert.addAll(insiteProduct);
            allProductsToInsert.addAll(connectedAdvisorProduct);
            allProductsToInsert.addAll(caBaseProduct);
            allProductsToInsert.addAll(guidanzMobileAggregate);
            allProductsToInsert.addAll(guidanzMobileProduct);
            allProductsToInsert.addAll(insiteLiteAggregate);
            allProductsToInsert.addAll(insiteLiteProduct);
            insert allProductsToInsert;
            //End of Product Creation

            //Start Product specs
            List<ccrz__E_Spec__c> specs = TestingUtils.createCcSpecs (3, 'product detail', true);
            List<ccrz__E_ProductSpec__c> allProductSpecs = new List<ccrz__E_ProductSpec__c>();
            List<ccrz__E_ProductSpec__c> guidanzProductSpecs = TestingUtils.createCcProductSpecs(1, guidanzBundleProduct[0].id, specs, false);
            List<ccrz__E_ProductSpec__c> insiteProductSpecs = TestingUtils.createCcProductSpecs(1, insiteProduct[0].id, specs, false);
            List<ccrz__E_ProductSpec__c> daProductSpecs = TestingUtils.createCcProductSpecs(1, caBaseProduct[0].id, specs, false);
            List<ccrz__E_ProductSpec__c> guidanzMobileProductSpecs = TestingUtils.createCcProductSpecs(1, guidanzMobileProduct[0].id, specs, false);
            List<ccrz__E_ProductSpec__c> insiteLiteProductSpecs = TestingUtils.createCcProductSpecs(1, insiteLiteProduct[0].id, specs, false);
            allProductSpecs.addAll(guidanzProductSpecs);
            allProductSpecs.addAll(insiteProductSpecs);
            allProductSpecs.addAll(daProductSpecs);
            allProductSpecs.addAll(guidanzMobileProductSpecs);
            allProductSpecs.addAll(insiteLiteProductSpecs);
            insert allProductSpecs;
            //End of Product Specs

            //Creation Of SubProd Terms
            List<ccrz__E_SubProdTerm__c> allSubProdTermsToInsert = new List<ccrz__E_SubProdTerm__c>();
            List<ccrz__E_SubProdTerm__c> guidanzSubProdTerm = TestingUtils.createSubProdTerm(1, 'Cummins Guidanz Service Package- 1 month One Time', guidanzBundleProduct[0].id,'*', false);
            List<ccrz__E_SubProdTerm__c> insiteSubProdTerm = TestingUtils.createSubProdTerm(1, 'INSITE™ Pro (MR/HD Plus)- 1 Year One Time', insiteProduct[0].id,'*', false);
            List<ccrz__E_SubProdTerm__c> caBaseProductSubProdTerm = TestingUtils.createSubProdTerm(1, 'CA Base-BUS- 1 Year Monthly', caBaseProduct[0].id,'*', false);
            List<ccrz__E_SubProdTerm__c> guidanzSubProdTermYear = TestingUtils.createSubProdTerm(1, 'Cummins Guidanz Service Package- 1 Year One Time', guidanzBundleProduct[0].id,'*', 'Yearly',false);
            List<ccrz__E_SubProdTerm__c> guidanzMobileSubProdTermYear = TestingUtils.createSubProdTerm(1, 'Guidanz Mobile (Includes Immediate Assessment)- 1 Year One Time', guidanzMobileProduct[0].id,'*', 'Yearly',false);
            List<ccrz__E_SubProdTerm__c> insiteLiteSubProdTermQuarterly = TestingUtils.createSubProdTerm(1, 'INSITE™ Lite (MR/HD Plus)- 1 Quarter One Time', insiteLiteProduct[0].id,'*', 'Quarterly',false);
            allSubProdTermsToInsert.addAll(guidanzSubProdTerm);
            allSubProdTermsToInsert.addAll(insiteSubProdTerm);
            allSubProdTermsToInsert.addAll(caBaseProductSubProdTerm);
            allSubProdTermsToInsert.addAll(guidanzSubProdTermYear);
            allSubProdTermsToInsert.addAll(guidanzMobileSubProdTermYear);
            allSubProdTermsToInsert.addAll(insiteLiteSubProdTermQuarterly);
            insert allSubProdTermsToInsert;
            //End of SubProdTerms

            //Creation Of Component Products

            //End of Component Products

            //Creation of Composite Product
            List<ccrz__E_CompositeProduct__c> allCompositeProductToInsert = new List<ccrz__E_CompositeProduct__c>();
            List<ccrz__E_CompositeProduct__c> guidanzCompositeProduct = TestingUtils.createCcCompProducts (guidanzAggregateProduct[0].id, guidanzBundleProduct, false);
            List<ccrz__E_CompositeProduct__c> InsiteCompositeProduct = TestingUtils.createCcCompProducts (insiteAggregatedProduct[0].id, insiteProduct, false);
            List<ccrz__E_CompositeProduct__c> guidanzMobileCompositeProduct = TestingUtils.createCcCompProducts (guidanzMobileAggregate[0].id, guidanzMobileProduct, false);
            List<ccrz__E_CompositeProduct__c> insiteLiteCompositeProduct = TestingUtils.createCcCompProducts (insiteLiteAggregate[0].id, insiteLiteProduct, false);
            allCompositeProductToInsert.addAll(guidanzCompositeProduct);
            allCompositeProductToInsert.addAll(InsiteCompositeProduct);
            allCompositeProductToInsert.addAll(guidanzMobileCompositeProduct);
            allCompositeProductToInsert.addAll(insiteLiteCompositeProduct);
            insert allCompositeProductToInsert;
            //End of Creation of Composite Product.

            //Cart Creation and CartItems
            List<ccrz__E_Cart__c> cartDetails = TestingUtils.CreateCart(1, 'SoftwareStore', 'Cart', portalUser.id, true, 'Open', true,acnt[0].id);
            List<ccrz__E_CartItem__c> allCartItemsToInsert = new List<ccrz__E_CartItem__c>();
            List<ccrz__E_CartItem__c> guidanzCartItem = TestingUtils.createCartItem(1, 'SoftwareStore', cartDetails[0].id, 'Major', 1 , guidanzBundleProduct[0].id, guidanzSubProdTermYear[0].id, 180, false);
            List<ccrz__E_CartItem__c> insiteCartItem = TestingUtils.createCartItem(1, 'SoftwareStore', cartDetails[0].id, 'Major', 1 , insiteProduct[0].id, insiteSubProdTerm[0].id, 180, false);
            List<ccrz__E_CartItem__c> daCartItem = TestingUtils.createCartItem(1, 'SoftwareStore', cartDetails[0].id, 'Major', 1 , caBaseProduct[0].id, caBaseProductSubProdTerm[0].id, 180, false);
            List<ccrz__E_CartItem__c> insiteLiteCartItem = TestingUtils.createCartItem(1, 'SoftwareStore', cartDetails[0].id, 'Major', 1 , insiteLiteProduct[0].id, insiteLiteSubProdTermQuarterly[0].id, 180, false);
            
            allCartItemsToInsert.addAll(guidanzCartItem);
            allCartItemsToInsert.addAll(insiteCartItem);
            allCartItemsToInsert.addAll(daCartItem);
            allCartItemsToInsert.addAll(insiteLiteCartItem);

            insert allCartItemsToInsert;
            //End of CartItem Creations


            //SubscriptionInformation Creations


            //End of Subscription Creations

            //Create Order
            ccrz__E_ContactAddr__c contactAddress = OSM_TestDataCreationUtility_NonStatic.createContactAddress(acnt[0].id);
            ccrz__E_Order__c orderDetails = TestingUtils.createOrder(portalContact[0].id,'Test Order Product Util', true);
            ccrz__E_OrderItem__c orderItemDetails = TestingUtils.createOrderItems(orderDetails.id, insiteProduct[0].id, insiteAggregatedProduct[0].id, true);
            ccrz__E_OrderItem__c orderItemDetailsGuidanz = TestingUtils.createOrderItems(orderDetails.id, guidanzBundleProduct[0].id, guidanzAggregateProduct[0].id, true);
            ccrz__E_OrderItem__c orderItemDetailsInsiteLite = TestingUtils.createOrderItems(orderDetails.id, insiteLiteProduct[0].id, insiteLiteAggregate[0].id, true);
            List<ccrz__E_Subscription__c> allSubscriptionsToInsert = new List<ccrz__E_Subscription__c>();

            ccrz__E_Subscription__c subscriptionDetails = OSM_TestDataCreationUtility_NonStatic.createSubscription(acnt[0].id, orderDetails.id, orderItemDetails.id,
            insiteAggregatedProduct[0].id, insiteProduct[0].id, portalUser.id, insiteSubProdTerm[0].id, contactAddress.id, 200, 'Active', false);
            subscriptionDetails.OneTimePerDayPrice__c= 2;
            DateTime subDateTime = DateTime.newInstance(2021, 7, 7, 7, 8, 12);
            subscriptionDetails.ccrz__InstallmentNextDate__c= subDateTime.addMonths(6);
            subscriptionDetails.Next_Invoice_Generation_Date__c = subDateTime.addYears(2);

            ccrz__E_Subscription__c subscriptionDetailsGuidanz = OSM_TestDataCreationUtility_NonStatic.createSubscription(acnt[0].id, orderDetails.id, orderItemDetailsGuidanz.id,
            guidanzAggregateProduct[0].id, guidanzBundleProduct[0].id, portalUser.id, guidanzSubProdTermYear[0].id, contactAddress.id, 200, 'Active', false);
            DateTime subguidanzDateTime = DateTime.newInstance(2021, 7, 7, 7, 8, 12);
            subscriptionDetailsGuidanz.ccrz__InstallmentNextDate__c= subguidanzDateTime.addMonths(6);
            subscriptionDetailsGuidanz.Next_Invoice_Generation_Date__c = subguidanzDateTime.addYears(2);




            ccrz__E_Subscription__c subscriptionDetailsInsiteLite = OSM_TestDataCreationUtility_NonStatic.createSubscription(acnt[0].id, orderDetails.id, orderItemDetailsInsiteLite.id,
            insiteLiteAggregate[0].id, insiteLiteProduct[0].id, portalUser.id, insiteLiteSubProdTermQuarterly[0].id, contactAddress.id, 200, 'Active', false);
            allSubscriptionsToInsert.add(subscriptionDetails);
            allSubscriptionsToInsert.add(subscriptionDetailsGuidanz);
            allSubscriptionsToInsert.add(subscriptionDetailsInsiteLite);
            insert allSubscriptionsToInsert;
            //End of Order Creations

            //Create Cart Items

            //End of Cart Items

            //Create Invoices
            List<ccrz__E_Invoice__c> invoiceDetails = TestingUtils.createCCInvoices(1, orderDetails.id, portalContact[0].id, 'open', 'SoftwareStore', true);
            ccrz__E_InvoiceItem__c invoiceItems = OSM_TestDataCreationUtility_NonStatic.createInvoiceItem_Item(orderDetails.id, orderItemDetails.id, invoiceDetails[0].id, subscriptionDetails.id, 'Item', 120, true);
            ccrz__E_TransactionPayment__c transactionPaymentDetails = OSM_TestDataCreationUtility_NonStatic.createTransactionPayment(orderDetails.id, invoiceDetails[0].id,acnt[0].id, portalContact[0].id, 
                                                                                                                                        portalUser.id , 'Order Placed Success', 'cc', true);
            //End of Invoices

            List<ccrz__E_RequestForQuote__c> quoteDetails = TestingUtils.createRequestForQuote(1, 'Requested', 5, 25, 5, 
                                                                    'Send', 'String salesUserComments', insiteLiteProduct[0].id, portalContact[0].id, false);
            quoteDetails[0].CC_SubProdTerm__c = insiteLiteSubProdTermQuarterly[0].id;
            insert quoteDetails;

        }

    }

    public static User getUserDetails() {
        if(u==null){ 
            u = [SELECT id FROM User WHERE Username = 'testuser@test.com'];
        } 
        return u;
    }    
    
    static testMethod void createOSMIntegrationLogs(){
        User testRunUser = getUserDetails();
        List<Account> acnt = [SELECT id,OSM_Preferred_Billing_Frequency__c FROM Account WHERE Name ='TestingProdUtilAccount0' LIMIT 1];
        ccrz__E_Order__c orderDetail = [SELECT id,Name FROM ccrz__E_Order__c WHERE ccrz__Name__c = 'Test Order Product Util' Limit 1];
        ccrz__E_Invoice__c InvoiceDetails = [SELECT id FROM ccrz__E_Invoice__c WHERE ccrz__CCOrder__c =: orderDetail.id];
        ccrz__E_TransactionPayment__c transactionPayment = [SELECT id FROM ccrz__E_TransactionPayment__c WHERE ccrz__CCOrder__c=:orderDetail.id AND ccrz__InvoiceAppliedTo__c=:InvoiceDetails.id];
        OSM_Integration_Log__c osmLog = new OSM_Integration_Log__c();
        osmLog.Account__c = acnt[0].id;
        osmLog.CC_Order__c = orderDetail.id;
        osmLog.Invoice__c = InvoiceDetails.id;
        osmLog.Transaction_Payment__c = transactionPayment.id;
        osmLog.Service_Name__c = 'Journal Entry';
        osmLog.Status__c = 'Success';
        osmLog.Source__c = 'OSM';
        osmLog.Target__c = 'BOLT';
        osmlog.Response__c = '{"Status":"Success","ReturnCodeDescription":"Journal Entry Information Received Successfully"}';
        osmLog.Request__c = '{"Header":{"Target":{"TargetID":"BOLT"},"Sender":{"ServiceName":"Journal Entry","SenderID":"OSM"},"JE_CTRL_TBL_ROW":{"SYSTEM_CODE":"OSM_01","STATUS":null,"Order_Number":"00008437","LAST_UPDATED_BY":"-1","LAST_UPDATE_DATE":"2021-10-01","CREATION_DATE":"2021-10-01","CREATED_BY":"-1","BATCH_ID":"20211001043921008437","BATCH_AMOUNT":"35.00"}},"DataArea":{"JE_INV_INBND_STG_ROW":{"USER_JE_SOURCE_NAME":"US OSM","USER_JE_CATEGORY_NAME":"Sales Invoices","USER_CURRENCY_CONVERSION_TYPE":"User","SYSTEM_CODE":"OSM_01","REFERENCE9":null,"REFERENCE8":null,"REFERENCE7":null,"REFERENCE6":"20211001043921008437","REFERENCE5":"MKTPLC eCOMMERCE TRANSACTIONS","REFERENCE4":null,"REFERENCE3":"JE001 MKTPLC TRANSACTIONS","REFERENCE2":"MKTPLC","REFERENCE10":"MKTPLC","REFERENCE1":"BC598RC207 MKTPLC","LEDGER_NAME":"US Primary USD","LEDGER_ID":"2041","LAST_UPDATED_BY":"-1","LAST_UPDATE_DATE":"2021-10-01","JOURNAL_ID":null,"JE_INV_INBND_STG_ROW_LINES":[{"SEGMENT7":"0000","SEGMENT6":"00000","SEGMENT5":null,"SEGMENT4":"1291000","SEGMENT3":"2071000","SEGMENT2":"207","SEGMENT1":"598","ENTERED_DR":"0","ENTERED_CR":"35.00","ACCOUNTED_DR":"0","ACCOUNTED_CR":"35.00"},{"SEGMENT7":"0000","SEGMENT6":"00000","SEGMENT5":null,"SEGMENT4":"2296000","SEGMENT3":"2071000","SEGMENT2":"207","SEGMENT1":"598","ENTERED_DR":"0.00","ENTERED_CR":"0","ACCOUNTED_DR":"0.00","ACCOUNTED_CR":"0.00"},{"SEGMENT7":"0000","SEGMENT6":"00000","SEGMENT5":"000","SEGMENT4":"0080000","SEGMENT3":"2071000","SEGMENT2":"207","SEGMENT1":"598","ENTERED_DR":"35.00","ENTERED_CR":"0","ACCOUNTED_DR":"35.00","ACCOUNTED_CR":"0.00"}],"INVOICE_DATE":"2021-10-01","GROUP_ID":"20211001043921008437","DATE_CREATED":"2021-10-01","CURRENCY_CONVERSION_RATE":"1","CURRENCY_CONVERSION_DATE":"2021-10-01","CURRENCY_CODE":"USD","CREATION_DATE":"2021-10-01","CREATED_BY":"-1","CHART_OF_ACCOUNTS_ID":"50368","ACTUAL_FLAG":"A","ACCOUNTING_DATE":"2021-10-01"}}}';
        osmLog.Logged_In_User__c = UserInfo.getUserId();
        insert osmLog;

        ccrz__E_TransactionPayment__c tcp =[SELECT id,OSM_0020009_ENTERED_CR__c,BATCH_AMOUNT__c FROM ccrz__E_TransactionPayment__c WHERE ccrz__CCOrder__c=:orderDetail.id AND ccrz__InvoiceAppliedTo__c=:InvoiceDetails.id];
        System.assertEquals('35.00', tcp.BATCH_AMOUNT__c, 'Success');
    }

    static testMethod void createOSMIntegrationLogs2(){
        User testRunUser = getUserDetails();
        List<Account> acnt = [SELECT id,OSM_Preferred_Billing_Frequency__c FROM Account WHERE Name ='TestingProdUtilAccount0' LIMIT 1];
        ccrz__E_Order__c orderDetail = [SELECT id,Name FROM ccrz__E_Order__c WHERE ccrz__Name__c = 'Test Order Product Util' Limit 1];
        ccrz__E_Invoice__c InvoiceDetails = [SELECT id FROM ccrz__E_Invoice__c WHERE ccrz__CCOrder__c =: orderDetail.id];
        ccrz__E_TransactionPayment__c transactionPayment = [SELECT id FROM ccrz__E_TransactionPayment__c WHERE ccrz__CCOrder__c=:orderDetail.id AND ccrz__InvoiceAppliedTo__c=:InvoiceDetails.id];
        OSM_Integration_Log__c osmLog = new OSM_Integration_Log__c();
        osmLog.Account__c = acnt[0].id;
        osmLog.CC_Order__c = orderDetail.id;
        osmLog.Invoice__c = InvoiceDetails.id;
        osmLog.Transaction_Payment__c = transactionPayment.id;
        osmLog.Service_Name__c = 'AR Invoice';
        osmLog.Status__c = 'Success';
        osmLog.Source__c = 'OSM';
        osmLog.Target__c = 'BOLT';
        osmlog.Response__c = '{"Header":{"Status":"Success","ReturnCodeDescription":"Invoice Information received successfully in Middleware"}}';
        osmLog.Request__c = '{"Header":{"Target":{"TargetID":"BOLT"},"Sender":{"ServiceName":"AR Invoice","SenderID":"OSM"}},"DataArea":{"AR_INV_INBND_STG_ROW":{"VAT_AMOUNT":"","TRX_TYPE":"INV","TRX_NUMBER":"00008421","TRX_DATE":"2021-10-01","TRANSACTION_INFO_CONTEXT":"NON GIEA","TRANSACTION_ID":"AR-INVOICES-OSM_01-20211001421","TERM_NAME":"123","TAX_CODE":"","SIGN":"","SET_OF_BOOKS_ID":"","SEGMENT7":"0000","SEGMENT6":"00000","SEGMENT5":"000","SEGMENT4":"0080000","SEGMENT3":"2071000","SEGMENT2":"207","SEGMENT1":"598","PURCHASE_ORDER":"4040013398","ORIG_SYSTEM_BILL_CUSTOMER_REF":"12345","ORIG_SYSTEM_BILL_ADDRESS_REF":"12345","ORACLE_CUSTOMER_NUMBER":"12345","OPERATING_UNIT":"US CBS Columbus 598","LINK_TO_LINE_ATTRIBUTE2":"","LINE_TYPE":"LINE","INVOICE_TYPE":"O","INVOICE_REF_FOR_CREDIT_MEMO":"","INTERFACE_LINE_CONTEXT":"NON GIEA","INTERFACE_LINE_ATTRIBUTE4":"1","INTERFACE_LINE_ATTRIBUTE3":"12345","INTERFACE_LINE_ATTRIBUTE2":"INVTP-0000002074","INTERFACE_LINE_ATTRIBUTE1":"598207","GL_DATE":"2021-10-01","ENTITY_CODE":"OSM_01","CUST_TRX_TYPE_NAME":"598207i","CUST_TRX_TYPE_ID":"","CURRENCY_CODE":"USD","CONVERSION_TYPE":"","CONVERSION_RATE":"","CONVERSION_DATE":"","COMMENTS":null,"CODE_COMBINATION_ID":"","BILL_TO_CUSTOMER_NUM":"12345","BATCH_SOURCE_NAME":"USCBSC","BATCH_NUMBER":"421","BATCH_DATE":"2021-10-01","AMOUNT":"35.00","ACCOUNT_CLASS":""}}}';
        osmLog.Logged_In_User__c = UserInfo.getUserId();
        insert osmLog;

        ccrz__E_TransactionPayment__c tcp =[SELECT id,OSM_0020009_ENTERED_CR__c,AMOUNT__c FROM ccrz__E_TransactionPayment__c WHERE ccrz__CCOrder__c=:orderDetail.id AND ccrz__InvoiceAppliedTo__c=:InvoiceDetails.id];
        System.assertEquals('35.00', tcp.AMOUNT__c, 'Success');
    }

    static testMethod void createOSMIntegrationInterCompny(){
        User testRunUser = getUserDetails();
        List<Account> acnt = [SELECT id,OSM_Preferred_Billing_Frequency__c FROM Account WHERE Name ='TestingProdUtilAccount0' LIMIT 1];
        ccrz__E_Order__c orderDetail = [SELECT id,Name FROM ccrz__E_Order__c WHERE ccrz__Name__c = 'Test Order Product Util' Limit 1];
        ccrz__E_Invoice__c InvoiceDetails = [SELECT id FROM ccrz__E_Invoice__c WHERE ccrz__CCOrder__c =: orderDetail.id];
        ccrz__E_TransactionPayment__c transactionPayment = [SELECT id FROM ccrz__E_TransactionPayment__c WHERE ccrz__CCOrder__c=:orderDetail.id AND ccrz__InvoiceAppliedTo__c=:InvoiceDetails.id];
        OSM_Integration_Log__c osmLog = new OSM_Integration_Log__c();
        osmLog.Account__c = acnt[0].id;
        osmLog.CC_Order__c = orderDetail.id;
        osmLog.Invoice__c = InvoiceDetails.id;
        osmLog.Transaction_Payment__c = transactionPayment.id;
        osmLog.Service_Name__c = 'IntercompanyRequest';
        osmLog.Status__c = 'Success';
        osmLog.Source__c = 'OSM';
        osmLog.Target__c = 'BOLT';
        osmlog.Response__c = '{"DataArea":{"DistributorCode":"02930","CustomerCode":3901614,"Attribute01":"","Attribute03":"","Attribute02":""},"Header":{"Sender":{"ServiceName":"IntercompanyRequest","SenderID":"MRKTPLC"},"Status":"Success","Target":{"TargetID":"BMS"},"StatusMessage":""}}';
        osmLog.Request__c = '{"R_PARTSLIST_SUBMIT":[{"UOM":"Each","SELLING_PRICE":0,"QUANTITY":1,"PRODUCT":"MRKTPLC","NONSTOCK_TYPE":"","LINE_TYPE":"","ITEM_NUMBER":"CG-Lite-005","ITEM_COST":800.00,"DESCRIPTION":"Cummins Guidanz Service ","CUSTOMER_PO_NUMBER":"","Attribute03":0,"Attribute02":0,"Attribute01":0}],"Header":{"Target":{"TargetID":"BMS"},"Sender":{"ServiceName":"IntercompanyRequest","SenderID":"MRKTPLC"}},"DataArea":{"LocationID":"02930-02930","CustomerCode":"3901614","Attribute03":"","Attribute02":"","Attribute01":0},"CInvoice_Header":[{"PO_VENDOR":"","ORDER_SOURCE_TYPE":"OSM","INVOICE_TOTAL":0,"ICInvoice_Number":"00031843","ICInvoice_Date":"2022-07-20","CREDIT_MEMO":"","BRANCH_LOCATION":"96","BMS_PO_NUMBER":"9696049865","BMS_OE_REFERENCE":249681,"BMS_INVOICE_NUMBER":10846,"Attribute03":"","Attribute02":"","Attribute01":0}],"ChargeList":[{"MISC_CHARGE_AMOUNT":0,"MISC_CHARGE":"","Attribute02":0,"Attribute01":0}]}';
        osmLog.Logged_In_User__c = UserInfo.getUserId();
        insert osmLog;

        ccrz__E_TransactionPayment__c tcp =[SELECT id,OSM_0020009_ENTERED_CR__c,AMOUNT__c,BMS_PO_NUMBER__c FROM ccrz__E_TransactionPayment__c WHERE ccrz__CCOrder__c=:orderDetail.id AND ccrz__InvoiceAppliedTo__c=:InvoiceDetails.id];
        System.assertEquals('9696049865', tcp.BMS_PO_NUMBER__c, 'Success');
    }
    
}