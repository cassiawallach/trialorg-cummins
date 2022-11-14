//MP-401 Updated By Singaiah 14-12-2021
//MP-466&MP-346 Updated By Singaiah 16-12-2021
// update sharad 22 Dec 21
//updated by Sangeeta on 4th Jan 2022 to fix MP-465
// Updated by Karthik for MP-714 - 03/25/2022
//Update by Singaiah for MP-661
// Updated by Karthik for -MP-744
// Updated by Karthik for -MP-621
//redeploy
@isTest
public class OSM_SW_ProductDetailCommonUtility_Test {
   
public static User u ;

    @TestSetup
    static void createData(){
      
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

    static testMethod void staleMethods(){
        User testRunUser = getUserDetails(); 
        system.debug('Printing test run details for the test'+testRunUSer);
        Test.StartTest();
            OSM_SW_ProductDetailCommonUtility  prodDetails = new OSM_SW_ProductDetailCommonUtility ();
            List<Account> acnt = [SELECT id FROM Account WHERE Name ='TestingProdUtilAccount0'] ;
            List<ccrz__E_Product__c> product = [SELECT id FROM ccrz__E_Product__c WHERE Name = 'INSITE® Pro (MR/HD Plus)0'];
            system.debug('Printing product details'+product);
            Map<string,Object> emptyMap = new Map<String,object>();
            System.runAs(testRunUser){
                double returnValue =  OSM_SW_ProductDetailCommonUtility.getCalculatedProrationPrice();
                Map<string,object> returnMap = OSM_SW_ProductDetailCommonUtility.getProrationDetails(acnt[0].id,'SoftwareStore',product[0].id);
                boolean cartPresent =OSM_SW_ProductDetailCommonUtility.checkProductFirstCartLineItem(acnt[0].id,'SoftwareStore');
                prodDetails.getProductCartItemdetails(acnt[0].id, 'SoftwareStore',product[0].id);
                system.assertEquals(0,returnValue);
                system.assertEquals(emptyMap,returnMap);
                system.assertEquals(true,cartPresent);
            }
        Test.StopTest();
    }

    static testMethod void  updateAccountBillingFrequencyTestbillingFrequency(){
        User testRunUser = getUserDetails(); 
        Test.StartTest();
        List<Account> acnt = [SELECT id FROM Account WHERE Name ='TestingProdUtilAccount0' LIMIT 1];
        System.RunAs(testRunUser) { 
            Boolean checkAccountBillingFrequency = OSM_SW_ProductDetailCommonUtility.updateAccountBillingFrequency(acnt[0].Id, 'Quarterly', 'SoftwareStore');
            system.AssertEquals(false,checkAccountBillingFrequency);
        }
        Test.StopTest();
    }

    static testMethod void  updateAccountBillingFrequencyTestNoBillingFrequency(){
        User testRunUser = getUserDetails();
        Test.StartTest();
        List<Account> acnt = [SELECT id,OSM_Preferred_Billing_Frequency__c FROM Account WHERE Name ='TestingProdUtilAccount0' LIMIT 1];
        acnt[0].OSM_Preferred_Billing_Frequency__c = '';
        Update acnt[0];
        System.RunAs(testRunUser) {
            Boolean checkAccountBillingFrequency = OSM_SW_ProductDetailCommonUtility.updateAccountBillingFrequency(acnt[0].Id, 'Quarterly', 'SoftwareStore');
            system.AssertEquals(true,checkAccountBillingFrequency);
        }
        Test.StopTest();
    }

    static testMethod void getBillingFrequenciesAndSubscriptionsTest(){
        User testRunUser = getUserDetails();
        Test.StartTest();
        List<Account> acnt = [SELECT id,OSM_Preferred_Billing_Frequency__c FROM Account WHERE Name ='TestingProdUtilAccount0' LIMIT 1];
        List<ccrz__E_Product__c> product = [SELECT id FROM ccrz__E_Product__c WHERE Name = 'INSITE® Pro (MR/HD Plus)0'];
        List<ccrz__E_SubProdTerm__c> subProdTerm = [SELECT id, Billing_Display_Name__c, BillingFrequency_Sequence__c, ccrz__DisplayName__c
                                                         , Subs_Year_Multipler__c, Subs_Length_Sequence__c FROM ccrz__E_SubProdTerm__c WHERE Name ='INSITE™ Pro (MR/HD Plus)- 1 Year One Time0'];
        Map<id,ccrz__E_SubProdTerm__c> subProdTermMap = new Map<id,ccrz__E_SubProdTerm__c>();
        subProdTermMap.put(subProdTerm[0].id,subProdTerm[0]);
        System.RunAs(testRunUser) {
            Map<string,object> returnMap = OSM_SW_ProductDetailCommonUtility.getBillingFrequenciesAndSubscriptions(subProdTermMap,acnt[0].id,'SoftwareStore',product[0].id);
            system.assertEquals(true,!returnMap.isEmpty());
        }
        Test.StopTest();
    }

    static testMethod void getBillingFrequenciesAndSubscriptionsFreeTest(){
        User testRunUser = getUserDetails();
        User adminUser = new User(id=UserInfo.getUserId());
        Test.StartTest();
        List<Account> acnt = [SELECT id,OSM_Preferred_Billing_Frequency__c FROM Account WHERE Name ='TestingProdUtilAccount0' LIMIT 1];
        List<ccrz__E_Product__c> product = [SELECT id FROM ccrz__E_Product__c WHERE Name = 'INSITE® Pro (MR/HD Plus)0'];
        List<ccrz__E_SubProdTerm__c> subProdTerm = [SELECT id, Billing_Display_Name__c, BillingFrequency_Sequence__c, ccrz__DisplayName__c
                                                         , Subs_Year_Multipler__c, Subs_Length_Sequence__c FROM ccrz__E_SubProdTerm__c WHERE Name ='INSITE™ Pro (MR/HD Plus)- 1 Year One Time0'];
        Map<id,ccrz__E_SubProdTerm__c> subProdTermMap = new Map<id,ccrz__E_SubProdTerm__c>();
        subProdTermMap.put(subProdTerm[0].id,subProdTerm[0]);
        System.RunAs(adminUser) {
            Map<string,object> returnMapFree = OSM_SW_ProductDetailCommonUtility.getBillingFrequenciesAndSubscriptionsWithAccBillFre(subProdTermMap,'Monthly',acnt[0].id,'SoftwareStore',product[0].id);
            system.assertEquals(true,!returnMapFree.isEmpty());
        }
        Test.StopTest();
    }

    static testMethod void updateCartItemToInavlidOrDeleteTest(){
        User testRunUser = getUserDetails();
        Test.StartTest();
        List<Account> acnt = [SELECT id,OSM_Preferred_Billing_Frequency__c FROM Account WHERE Name ='TestingProdUtilAccount0' LIMIT 1];
        System.RunAs(testRunUser) {
            OSM_SW_ProductDetailCommonUtility.updateCartItemToInavlidOrDelete(acnt[0].id,'quarterly','SoftwareStore');
        }
        Test.StopTest();
    }

    static testMethod void createOrderSubscriptionJunctionTest() {
        User testRunUser = getUserDetails();
        Test.StartTest();
        List<Account> acnt = [SELECT id,OSM_Preferred_Billing_Frequency__c FROM Account WHERE Name ='TestingProdUtilAccount0' LIMIT 1];
        List<ccrz__E_Product__c> product = [SELECT id FROM ccrz__E_Product__c WHERE Name = 'INSITE® Pro (MR/HD Plus)0' AND ccrz__ProductType__c='Product'];
        ccrz__E_Order__c orderDetail = [SELECT id,Name FROM ccrz__E_Order__c WHERE ccrz__Name__c = 'Test Order Product Util' Limit 1];
        ccrz__E_OrderItem__c orderDetailItem = [SELECT id,ccrz__Product__c FROM ccrz__E_OrderItem__c WHERE ccrz__Order__c =: orderDetail.id AND ccrz__Product__c=:product[0].id];
        Map<Id,Integer> productIds = new Map<Id,Integer>{product[0].id => 1};
        Map<string,string> prodToOrderItem = new Map<string,string>{orderDetailItem.ccrz__Product__c => orderDetailItem.id};
        System.RunAs(testRunUser) {
            OSM_SW_ProductDetailCommonUtility.createOrderSubscriptionJunction(productIds,'SoftwareStore',acnt[0].id,orderDetail.id,prodToOrderItem);
        }
        Test.StopTest();
    }

    static testMethod void getCalculatedProrationAmountTest() {
        User testRunUser = getUserDetails();
        Test.StartTest();
        List<Account> acnt = [SELECT id,OSM_Preferred_Billing_Frequency__c FROM Account WHERE Name ='TestingProdUtilAccount0' LIMIT 1];
        List<ccrz__E_Product__c> product = [SELECT id FROM ccrz__E_Product__c WHERE Name = 'INSITE® Pro (MR/HD Plus)0' AND ccrz__ProductType__c='Product'];
        ccrz__E_Subscription__c subscriptionDetails = [SELECT id,Purchase_Date__c,ccrz__Account__c,OneTimePerDayPrice__c,OSM_Subscription_End_Date__c
                                                            , ccrz__InstallmentNextDate__c,ccrz__SubscriptionStartDate__c,ccrz__RecurringPrice__c
                                                            , Current_Invoice_Due_Date__c,ccrz__SPT__c,ccrz__SPT__r.Billing_Display_Name__c,ccrz__SPT__r.ccrz__OrderFrequency__c
                                                            , Next_Invoice_Generation_Date__c, Last_Installment_Generated__c FROM ccrz__E_Subscription__c WHERE ccrz__Account__c =: acnt[0].id AND ccrz__SubscriptionProduct__c=:product[0].id] ;
        System.RunAs(testRunUser) {
            Decimal prorationAmount = OSM_SW_ProductDetailCommonUtility.getCalculatedProrationAmount(subscriptionDetails,'Monthly','Yearly');
            Integer numberOfDays = OSM_SW_ProductDetailCommonUtility.getDaysInMonths(2028,7);
            System.debug('prorationAmount'+prorationAmount);
            System.debug('numberOfDays'+numberOfDays);
            System.assertEquals(0,prorationAmount);
            System.assertEquals(31,numberOfDays);
            //system.assertEquals();
        }
        Test.StopTest();
    }

    static testMethod void getProratedAmountInLastBillingCycleTest() {
        User testRunUser = getUserDetails();
        Test.StartTest();
        List<Account> acnt = [SELECT id,OSM_Preferred_Billing_Frequency__c FROM Account WHERE Name ='TestingProdUtilAccount0' LIMIT 1];
        List<ccrz__E_Product__c> product = [SELECT id FROM ccrz__E_Product__c WHERE Name = 'INSITE® Pro (MR/HD Plus)0' AND ccrz__ProductType__c='Product'];
        ccrz__E_Subscription__c subscriptionDetails = [SELECT id,Purchase_Date__c,ccrz__Account__c,OneTimePerDayPrice__c,OSM_Subscription_End_Date__c
                                                            , ccrz__InstallmentNextDate__c,ccrz__SubscriptionStartDate__c,ccrz__RecurringPrice__c
                                                            , Current_Invoice_Due_Date__c,ccrz__SPT__c,ccrz__SPT__r.Billing_Display_Name__c,ccrz__SPT__r.ccrz__OrderFrequency__c
                                                            , Next_Invoice_Generation_Date__c, Last_Installment_Generated__c FROM ccrz__E_Subscription__c WHERE ccrz__Account__c =: acnt[0].id AND ccrz__SubscriptionProduct__c=:product[0].id];

        
        date myDate = System.today().addMonths(-8);
        List<ccrz__E_Product__c> productInsiteLite = [SELECT id FROM ccrz__E_Product__c WHERE Name = 'INSITE™ Lite (MR/HD Plus)0' AND ccrz__ProductType__c='Product'];
        ccrz__E_Subscription__c subscriptionDetailsInsiteLite = [SELECT id,Purchase_Date__c,ccrz__Account__c,OneTimePerDayPrice__c,OSM_Subscription_End_Date__c
                                                            , ccrz__InstallmentNextDate__c,ccrz__SubscriptionStartDate__c,ccrz__RecurringPrice__c
                                                            , Current_Invoice_Due_Date__c,ccrz__SPT__c,ccrz__SPT__r.Billing_Display_Name__c,ccrz__SPT__r.ccrz__OrderFrequency__c
                                                            , Next_Invoice_Generation_Date__c, Last_Installment_Generated__c FROM ccrz__E_Subscription__c WHERE ccrz__Account__c =: acnt[0].id AND ccrz__SubscriptionProduct__c=:productInsiteLite[0].id];
        System.RunAs(testRunUser) {
            Decimal proratedamount1 = OSM_SW_ProductDetailCommonUtility.getProratedAmountInLastBillingCycle(subscriptionDetails,myDate,true,15);
            Decimal proratedamount2 = OSM_SW_ProductDetailCommonUtility.getProratedAmountInLastBillingCycleNew(subscriptionDetails,myDate,true,15);
            Decimal proratedAmount3 = OSM_SW_ProductDetailCommonUtility.getProratedAmountInLastBillingCycle(subscriptionDetails,myDate,false,15);
            Decimal proratedAmount4 = OSM_SW_ProductDetailCommonUtility.getProratedAmountInLastBillingCycleNew(subscriptionDetails,myDate,false,15);
            Decimal proratedAmount5 = OSM_SW_ProductDetailCommonUtility.getProratedAmountInLastBillingCycleNew(subscriptionDetailsInsiteLite,myDate,true,15);
            Decimal proratedAmount6 = OSM_SW_ProductDetailCommonUtility.getProratedAmountInLastBillingCycle(subscriptionDetailsInsiteLite,myDate,false,15);
            System.debug('proratedamount1'+proratedamount1);
            System.debug('proratedamount2'+proratedamount2);
            System.debug('proratedamount3'+proratedamount3);
            System.debug('proratedamount4'+proratedamount4);
            System.debug('proratedamount5'+proratedamount5);
            System.debug('proratedamount6'+proratedamount6);
            //System.assertEquals(198.00,proratedamount1);
            //System.assertEquals(198.00,proratedamount2);
            //System.assertEquals(2641.32,proratedamount3);
            //System.assertEquals(2641.32,proratedamount4);
            //System.assertEquals(63.36,proratedamount5);
            //System.assertEquals(879.12,proratedamount6); 
        }
        Test.StopTest();
    }

    static testMethod void getProratedAmountInLastBillingCycleTestYearly() {
        User testRunUser = getUserDetails();
        Test.StartTest();
        List<Account> acnt = [SELECT id,OSM_Preferred_Billing_Frequency__c FROM Account WHERE Name ='TestingProdUtilAccount0' LIMIT 1];
        List<ccrz__E_Product__c> product = [SELECT id FROM ccrz__E_Product__c WHERE Name = 'Cummins Guidanz™ Service Package0' AND ccrz__ProductType__c='Bundle'];
        ccrz__E_Subscription__c subscriptionDetails = [SELECT id,Purchase_Date__c,ccrz__Account__c,OneTimePerDayPrice__c,OSM_Subscription_End_Date__c
                                                            , ccrz__InstallmentNextDate__c,ccrz__SubscriptionStartDate__c,ccrz__RecurringPrice__c
                                                            , Current_Invoice_Due_Date__c,ccrz__SPT__c,ccrz__SPT__r.Billing_Display_Name__c,ccrz__SPT__r.ccrz__OrderFrequency__c
                                                            , Next_Invoice_Generation_Date__c, Last_Installment_Generated__c FROM ccrz__E_Subscription__c WHERE ccrz__Account__c =: acnt[0].id AND ccrz__SubscriptionProduct__c=:product[0].id and ccrz__SubscriptionStatus__c = 'Active'];
        date myDate = System.today().addMonths(-8);
        System.RunAs(testRunUser) {
            Decimal prorationAmount1 = OSM_SW_ProductDetailCommonUtility.getProratedAmountInLastBillingCycle(subscriptionDetails,myDate,true,15);
            Decimal prorationAmount2 = OSM_SW_ProductDetailCommonUtility.getProratedAmountInLastBillingCycleNew(subscriptionDetails,myDate,true,15);
            Decimal prorationAmount3 = OSM_SW_ProductDetailCommonUtility.getProratedAmountInLastBillingCycle(subscriptionDetails,myDate,false,15);
            Decimal prorationAmount4 = OSM_SW_ProductDetailCommonUtility.getProratedAmountInLastBillingCycleNew(subscriptionDetails,myDate,false,15);
            //System.assertEquals(15.84, prorationAmount1);
            //System.assertEquals(15.84, prorationAmount2);
            //System.assertEquals(221.76, prorationAmount3);
        }
        Test.StopTest();
    }

    static testMethod void getProratedAmountOfOtherProductTest() {
        User testRunUser = getUserDetails();
        Test.StartTest();
        List<Account> acnt = [SELECT id,OSM_Preferred_Billing_Frequency__c FROM Account WHERE Name ='TestingProdUtilAccount0' LIMIT 1];
        List<ccrz__E_Product__c> product = [SELECT id FROM ccrz__E_Product__c WHERE Name = 'Cummins Guidanz™ Service Package0' AND ccrz__ProductType__c='Bundle'];
        ccrz__E_Subscription__c subscriptionDetails = [SELECT id,Purchase_Date__c,ccrz__Account__c,OneTimePerDayPrice__c,OSM_Subscription_End_Date__c
                                                            , ccrz__InstallmentNextDate__c,ccrz__SubscriptionStartDate__c,ccrz__RecurringPrice__c
                                                            , Current_Invoice_Due_Date__c,ccrz__SPT__c,ccrz__SPT__r.Billing_Display_Name__c,ccrz__SPT__r.ccrz__OrderFrequency__c
                                                            , Next_Invoice_Generation_Date__c, Last_Installment_Generated__c FROM ccrz__E_Subscription__c WHERE ccrz__Account__c =: acnt[0].id AND ccrz__SubscriptionProduct__c=:product[0].id and ccrz__SubscriptionStatus__c = 'Active'];
        date myDate = System.today().addMonths(-8);
        System.RunAs(testRunUser) {
            Decimal proratedAmountProductMonthly = OSM_SW_ProductDetailCommonUtility.getProratedAmountOfOtherProduct(subscriptionDetails,'Yearly','Monthly',15);
            Decimal proratedAmountProductQuarterly = OSM_SW_ProductDetailCommonUtility.getProratedAmountOfOtherProduct(subscriptionDetails,'Yearly','Quarterly',15);
            Decimal proratedAmountProductYearly = OSM_SW_ProductDetailCommonUtility.getProratedAmountOfOtherProduct(subscriptionDetails,'Yearly','Yearly',15);
        }
        Test.StopTest();
    }

    static testMethod void getInvoiceNextRequiredDateTest() {
        User testRunUser = getUserDetails();
        Test.StartTest();
        List<Account> acnt = [SELECT id,OSM_Preferred_Billing_Frequency__c FROM Account WHERE Name ='TestingProdUtilAccount0' LIMIT 1];
        List<ccrz__E_Product__c> product = [SELECT id FROM ccrz__E_Product__c WHERE Name = 'INSITE® Pro (MR/HD Plus)0' AND ccrz__ProductType__c='Product'];
        ccrz__E_Subscription__c subscriptionDetails = [SELECT id,Purchase_Date__c,ccrz__Account__c,OneTimePerDayPrice__c,OSM_Subscription_End_Date__c
                                                            , ccrz__InstallmentNextDate__c,ccrz__SubscriptionStartDate__c,ccrz__RecurringPrice__c
                                                            , Current_Invoice_Due_Date__c,ccrz__SPT__c,ccrz__SPT__r.Billing_Display_Name__c,ccrz__SPT__r.ccrz__OrderFrequency__c
                                                            , Next_Invoice_Generation_Date__c, Last_Installment_Generated__c,OSM_Display_Product__c, ccrz__SubscriptionProduct__c
                                                             FROM ccrz__E_Subscription__c WHERE ccrz__Account__c =: acnt[0].id AND ccrz__SubscriptionProduct__c=:product[0].id];
        ccrz__E_Order__c orderDetail = [SELECT id,Name FROM ccrz__E_Order__c WHERE ccrz__Name__c = 'Test Order Product Util' Limit 1];
        List<ccrz__E_OrderItem__c> orderDetailItem = [SELECT id,ccrz__Product__c,ccrz__DisplayProduct__c,ccrz__DisplayProduct__r.Name FROM ccrz__E_OrderItem__c WHERE ccrz__Order__c =: orderDetail.id AND ccrz__Product__c=:product[0].id];
        List<Id> orderDetailItemIds = new List<Id>(); 
        for(ccrz__E_OrderItem__c items :  orderDetailItem) {
            orderDetailItemIds.add(items.id);
        }
        ccrz__E_Invoice__c InvoiceDetails = [SELECT id FROM ccrz__E_Invoice__c WHERE ccrz__CCOrder__c =: orderDetail.id];
        Map<string,string> mapProdToSPT = new Map<string,string>{subscriptionDetails.ccrz__SubscriptionProduct__c => subscriptionDetails.ccrz__SPT__c};
        Map<string,string> prodToDisplayProd = new Map<string,string>{subscriptionDetails.ccrz__SubscriptionProduct__c => subscriptionDetails.OSM_Display_Product__c};
        System.RunAs(testRunUser) {
            Map<string,Map<string,Object>> InvoiceNextDueDate = OSM_SW_ProductDetailCommonUtility.getInvoiceNextRequiredDate(orderDetailItemIds,true,string.valueOf(InvoiceDetails.id),string.valueOf(acnt[0].id),mapProdToSPT,'SoftwareStore',prodToDisplayProd);
            ccrz__E_Cart__c returnedCartDetails = OSM_SW_ProductDetailCommonUtility.createNewCart();
            System.assertEquals(true,!InvoiceNextDueDate.isEmpty());
            System.assertEquals(true,returnedCartDetails!=null);
        }
        Test.StopTest();
    }

    static testMethod void creatOrderInvoiceJunctionEntriesTest() {
        User testRunUser = getUserDetails();
        Test.StartTest();
        List<Account> acnt = [SELECT id,OSM_Preferred_Billing_Frequency__c FROM Account WHERE Name ='TestingProdUtilAccount0' LIMIT 1];
        List<ccrz__E_Product__c> product = [SELECT id FROM ccrz__E_Product__c WHERE Name = 'INSITE® Pro (MR/HD Plus)0' AND ccrz__ProductType__c='Product'];
        ccrz__E_Order__c orderDetail = [SELECT id,Name FROM ccrz__E_Order__c WHERE ccrz__Name__c = 'Test Order Product Util' Limit 1];
        ccrz__E_Invoice__c InvoiceDetails = [SELECT id,ccrz__CCOrder__c FROM ccrz__E_Invoice__c WHERE ccrz__CCOrder__c =: orderDetail.id];
        List<ccrz__E_InvoiceItem__c> invoiceItem = [SELECT id,ccrz__CCOrderItem__c,Quantity__c,ccrz__OriginalAmount__c from ccrz__E_InvoiceItem__c WHERE ccrz__Invoice__c =:InvoiceDetails.id ];
        System.RunAs(testRunUser) {
            OSM_SW_ProductDetailCommonUtility.creatOrderInvoiceJunctionEntries(InvoiceDetails,invoiceItem);
            OSM_SW_ProductDetailCommonUtility.updateInvoiceOnSubscription(orderDetail.id,InvoiceDetails.id);
        }
        Test.StopTest();
    }

    static testMethod void deletePreOrderSubscriptionsTest() {
        User testRunUser = getUserDetails();
        Test.StartTest();
        List<Account> acnt = [SELECT id,OSM_Preferred_Billing_Frequency__c FROM Account WHERE Name ='TestingProdUtilAccount0' LIMIT 1];
        List<ccrz__E_Product__c> product = [SELECT id FROM ccrz__E_Product__c WHERE Name = 'INSITE® Pro (MR/HD Plus)0' AND ccrz__ProductType__c='Product'];
        ccrz__E_Order__c orderDetail = [SELECT id,Name FROM ccrz__E_Order__c WHERE ccrz__Name__c = 'Test Order Product Util' Limit 1];
        List<ccrz__E_OrderItem__c> orderDetailItem = [SELECT id,ccrz__Product__c FROM ccrz__E_OrderItem__c WHERE ccrz__Order__c =: orderDetail.id AND ccrz__Product__c=:product[0].id];
        List<Id> orderItemIds = new List<Id>(); 
        for(ccrz__E_OrderItem__c items :  orderDetailItem) {
            orderItemIds.add(items.id);
        }
        ccrz__E_Cart__c cartDetails = [SELECT id
                                              FROM ccrz__E_Cart__c WHERE ccrz__Account__c =:acnt[0].id];
        ccrz__E_CartItem__c cartItemDetails = [SELECT id, ccrz__Product__c, ccrz__Cart__r.ccrz__Account__c, ccrz__StoreID__c 
                                                    , ccrz__Price__c, ccrz__DisplayProduct__c, ccrz__SubAmount__c, isRenew__c, ccrz__DisplayProduct__r.Name, withCoTerm__c
                                                     FROM ccrz__E_CartItem__c WHERE ccrz__Cart__c=:cartDetails.id and ccrz__Product__c=:product[0].id];
        Map<Id,ccrz__E_CartItem__c> productToCartItem = new Map<id,ccrz__E_CartItem__c>{cartItemDetails.ccrz__Product__c => cartItemDetails};
        OSM_SW_cc_hk_Subscriptions.orderItemIdToDeleteLst = orderItemIds;
        System.runAs(testRunUser) {
            OSM_SW_ProductDetailCommonUtility.deletePreOrderSubscriptoins(productToCartItem, orderItemIds);
        }
        Test.StopTest();
    }

    static testMethod void getRenewedSubscriptionEndDateTest() {
        USer testRunUser = getUserDetails();
        Test.StartTest();
        Datetime myDateTime = Datetime.newInstance(2024, 2, 17);
        System.RunAs(testRunUser) {
            DateTime weekly = OSM_SW_ProductDetailCommonUtility.getRenewedSubscriptionEndDate('1 Week',myDateTime);
            DateTime monthly = OSM_SW_ProductDetailCommonUtility.getRenewedSubscriptionEndDate('1 Month',myDateTime);
            DateTime quarterly = OSM_SW_ProductDetailCommonUtility.getRenewedSubscriptionEndDate('1 Quarter',myDateTime);
            DateTime yearly =  OSM_SW_ProductDetailCommonUtility.getRenewedSubscriptionEndDate('1 Year',myDateTime);

            Date weeklyDate = Date.newInstance(2024,02,24);
            Date monthlyDate = Date.newInstance(2024,03,17);
            Date quarterlyDate = Date.newInstance(2024,05,17);
            Date yearlyDate = Date.newInstance(2025,02,17);

            System.assertEquals(weeklyDate, weekly.date());
            System.assertEquals(monthlyDate,monthly.date());
            System.assertEquals(quarterlyDate,quarterly.date());
            System.assertEquals(yearlyDate,yearly.date());
        }
        Test.StopTest();
    }

    static testMethod void updateRecnNonRecurSubAmountOnOrderItemsTest() {
        User testRunUser = getUserDetails();
        Test.StartTest();
        List<Account> acnt = [SELECT id,OSM_Preferred_Billing_Frequency__c FROM Account WHERE Name ='TestingProdUtilAccount0' LIMIT 1];
        List<ccrz__E_Product__c> product = [SELECT id FROM ccrz__E_Product__c WHERE Name = 'INSITE® Pro (MR/HD Plus)0' AND ccrz__ProductType__c='Product'];
        ccrz__E_Order__c orderDetail = [SELECT id,Name FROM ccrz__E_Order__c WHERE ccrz__Name__c = 'Test Order Product Util' Limit 1];
        List<ccrz__E_OrderItem__c> orderDetailItem = [SELECT id,ccrz__Product__c,ccrz__Price__c,ccrz__Quantity__c,ccrz__RecurringPrice__c
                                                           , ccrz__RecurringPriceSubAmt__c,ccrz__PricingType__c,Dn_Price__c,Number_of_Bundles__c
                                                           , Number_of_Counts__c,isRenew__c,OSM_SW_Product_Link__c,OSM_Renew_Subscription_End_Date__c
                                                           , OSM_Renew_Subscription_Start_Date__c,ccrz__OrderItemStatus__c FROM ccrz__E_OrderItem__c WHERE ccrz__Order__c =: orderDetail.id AND ccrz__Product__c=:product[0].id];
        ccrz__E_Cart__c cartDetails = [SELECT id
                                              FROM ccrz__E_Cart__c WHERE ccrz__Account__c =:acnt[0].id];
        ccrz__E_CartItem__c cartItemDetails = [SELECT id, ccrz__Product__c, ccrz__Cart__r.ccrz__Account__c, ccrz__StoreID__c 
                                                    , ccrz__Price__c, ccrz__DisplayProduct__c, ccrz__SubAmount__c, isRenew__c, ccrz__DisplayProduct__r.Name, withCoTerm__c, Dn_Price__c
                                                    , Number_of_Bundles__c, Number_of_Counts__c, OSM_SW_Product_Link__c, OSM_Renew_Subscription_End_Date__c 
                                                     FROM ccrz__E_CartItem__c WHERE ccrz__Cart__c=:cartDetails.id and ccrz__Product__c=:product[0].id];
        Map<Id,ccrz__E_CartItem__c> productToCartItem = new Map<id,ccrz__E_CartItem__c>{cartItemDetails.ccrz__Product__c => cartItemDetails};
        System.RunAs(testRunUser) {
            OSM_SW_ProductDetailCommonUtility.updateRecnNonRecurSubAmountOnOrderItems(orderDetailItem,productToCartItem);
            OSM_SW_ProductDetailCommonUtility.updateRecnNonRecurSubAmountOnOrderItems(orderDetailItem);
        }
        Test.StopTest();
    }

    static testMethod void updateInvoiceTest() {
        User testRunUser = getUserDetails();
        Test.StartTest();
        List<Account> acnt = [SELECT id,OSM_Preferred_Billing_Frequency__c FROM Account WHERE Name ='TestingProdUtilAccount0' LIMIT 1];
        List<ccrz__E_Product__c> product = [SELECT id FROM ccrz__E_Product__c WHERE Name = 'INSITE® Pro (MR/HD Plus)0' AND ccrz__ProductType__c='Product'];
        ccrz__E_Order__c orderDetail = [SELECT id,Name FROM ccrz__E_Order__c WHERE ccrz__Name__c = 'Test Order Product Util' Limit 1];
        List<ccrz__E_Invoice__c> InvoiceDetails = [SELECT id,ccrz__CCOrder__c,ccrz__SoldTo__c,ccrz__DateDue__c FROM ccrz__E_Invoice__c WHERE ccrz__CCOrder__c =: orderDetail.id];
        List<ccrz__E_InvoiceItem__c> invoiceItem = [SELECT id,ccrz__CCOrderItem__c,Quantity__c,ccrz__OriginalAmount__c,ccrz__Invoice__c,ccrz__Type__c,CC_Subscription__c from ccrz__E_InvoiceItem__c WHERE ccrz__Invoice__c =:InvoiceDetails[0].id ];
        System.runAs(testRunUser) {
            OSM_SW_ProductDetailCommonUtility.updateInvoice(InvoiceDetails,invoiceItem);
        }
        Test.StopTest();
    }

    static testMethod void updateInvoiceOrderItemsTest() {
        User testRunUser = getUserDetails();
        Test.StartTest();
        List<Account> acnt = [SELECT id,OSM_Preferred_Billing_Frequency__c FROM Account WHERE Name ='TestingProdUtilAccount0' LIMIT 1];
        List<ccrz__E_Product__c> product = [SELECT id FROM ccrz__E_Product__c WHERE Name = 'INSITE® Pro (MR/HD Plus)0' AND ccrz__ProductType__c='Product'];
        ccrz__E_Order__c orderDetail = [SELECT id,Name FROM ccrz__E_Order__c WHERE ccrz__Name__c = 'Test Order Product Util' Limit 1];
        List<ccrz__E_Invoice__c> InvoiceDetails = [SELECT id,ccrz__CCOrder__c,ccrz__SoldTo__c,ccrz__DateDue__c FROM ccrz__E_Invoice__c WHERE ccrz__CCOrder__c =: orderDetail.id];
        List<ccrz__E_InvoiceItem__c> invoiceItem = [SELECT id,ccrz__CCOrderItem__c,Quantity__c,ccrz__OriginalAmount__c, ccrz__Invoice__c,CC_Subscription__c from ccrz__E_InvoiceItem__c WHERE ccrz__Invoice__c =:InvoiceDetails[0].id ];
        ccrz__E_Cart__c cartDetails = [SELECT id
                                        FROM ccrz__E_Cart__c WHERE ccrz__Account__c =:acnt[0].id];
        ccrz__E_CartItem__c cartItemDetails = [SELECT id, ccrz__Product__c, ccrz__Cart__r.ccrz__Account__c, ccrz__StoreID__c 
                                                    , ccrz__Price__c, ccrz__DisplayProduct__c, ccrz__SubAmount__c, isRenew__c, ccrz__DisplayProduct__r.Name, withCoTerm__c
                                                    , Dn_Price__c, Number_of_Bundles__c, Number_of_Counts__c, OSM_SW_Product_Link__c, OSM_Renew_Subscription_End_Date__c
                                                        FROM ccrz__E_CartItem__c WHERE ccrz__Cart__c=:cartDetails.id and ccrz__Product__c=:product[0].id];
        Map<Id,ccrz__E_CartItem__c> productToCartItem = new Map<id,ccrz__E_CartItem__c>{cartItemDetails.ccrz__Product__c => cartItemDetails};
        Map<string,string> productIds = new Map<string,string>{cartItemDetails.ccrz__Product__c => 'INSITE® Pro (MR/HD Plus)0'};
        Set<string> productIdsSet = new Set<string>{cartItemDetails.ccrz__Product__c};
        System.runAs(testRunUser) {
            OSM_SW_ProductDetailCommonUtility.updateInvoiceOrderItems(productToCartItem,invoiceItem,string.valueOf(acnt[0].id),productIds,'SoftwareStore');
            OSM_SW_ProductDetailCommonUtility.updateInvoiceItems(invoiceItem,string.valueOf(acnt[0].id),productIds,'SoftwareStore');
            OSM_SW_ProductDetailCommonUtility.setQuoteToInactivate(string.valueOf(acnt[0].id),productIdsSet,'SoftwareStore');
        }
        Test.stopTest();
    }

    static testMethod void lockAccountPreferredBillFre() {
        User testRunUser = getUserDetails();
        Test.StartTest();
        List<Account> acnt = [SELECT id,OSM_Preferred_Billing_Frequency__c FROM Account WHERE Name ='TestingProdUtilAccount0' LIMIT 1];
        List<ccrz__E_Product__c> product = [SELECT id FROM ccrz__E_Product__c WHERE Name = 'INSITE® Pro (MR/HD Plus)0' AND ccrz__ProductType__c='Product'];
        List<ccrz__E_SubProdTerm__c> subProdTerm = [SELECT id, Billing_Display_Name__c, BillingFrequency_Sequence__c, ccrz__DisplayName__c
                                                      , Subs_Year_Multipler__c, Subs_Length_Sequence__c FROM ccrz__E_SubProdTerm__c WHERE Name ='INSITE™ Pro (MR/HD Plus)- 1 Year One Time0'];
        set<string> productIds = new Set<string>{product[0].id};
        set<string> strProdTerm = new Set<string>{subProdTerm[0].id};
        System.runAs(testRunUser) {
            Boolean preferredBill1 = OSM_SW_ProductDetailCommonUtility.lockAccountPreferredBillFre(string.valueOf(acnt[0].id),productIds,'SoftwareStore',strProdTerm);  
            Boolean preferredBill2 = OSM_SW_ProductDetailCommonUtility.lockAccountPreferredBillFre(string.valueOf(acnt[0].id),productIds,'SoftwareStore',strProdTerm,true); 

            System.assertEquals(false,preferredBill1);
            System.assertEquals(false,preferredBill2);
        }                                          
        Test.StopTest();
    }

    static testMethod void guidanzMobileProductTest() {
        User testRunUser = getUserDetails();
        Test.StartTest();
        List<Account> acnt = [SELECT id,OSM_Preferred_Billing_Frequency__c FROM Account WHERE Name ='TestingProdUtilAccount0' LIMIT 1];
        List<ccrz__E_Product__c> product = [SELECT id FROM ccrz__E_Product__c WHERE Name = 'Guidanz Mobile (Includes Immediate Assessment)0' AND ccrz__ProductType__c='Aggregated'];
        System.runAs(testRunUser) {
            Boolean isGuidanzMobile = OSM_SW_ProductDetailCommonUtility.isIncludedGuidenzMobileProduct(product[0].id);
            Integer isIAMAccessRecord = OSM_SW_ProductDetailCommonUtility.getGuidenzMobileIAMAccessRecord(acnt[0].id);
            Integer isMobileRenewRecord = OSM_SW_ProductDetailCommonUtility.getGuidenzMobileRenewedRec(acnt[0].id);
            System.assertEquals(true,isGuidanzMobile);
            System.assertEquals(0,isIAMAccessRecord);
            System.assertEquals(0,isMobileRenewRecord);
        }
        Test.StopTest();
    }

    static testMethod void getOneTimePerDayPriceTest() {
        User testRunUser = getUserDetails();
        Test.StartTest();
        List<Account> acnt = [SELECT id,OSM_Preferred_Billing_Frequency__c FROM Account WHERE Name ='TestingProdUtilAccount0' LIMIT 1];
        List<ccrz__E_Product__c> productInsiteLite = [SELECT id FROM ccrz__E_Product__c WHERE Name = 'INSITE™ Lite (MR/HD Plus)0' AND ccrz__ProductType__c='Product'];
        ccrz__E_Subscription__c subscriptionDetailsInsiteLite = [SELECT id,Purchase_Date__c,ccrz__Account__c,OneTimePerDayPrice__c,OSM_Subscription_End_Date__c, ccrz__SubscriptionProduct__c
                                                            , ccrz__InstallmentNextDate__c,ccrz__SubscriptionStartDate__c,ccrz__RecurringPrice__c
                                                            , Current_Invoice_Due_Date__c,ccrz__SPT__c,ccrz__SPT__r.Billing_Display_Name__c,ccrz__SPT__r.ccrz__OrderFrequency__c, ccrz__SPT__r.ccrz__DisplayName__c
                                                            , Next_Invoice_Generation_Date__c, Last_Installment_Generated__c FROM ccrz__E_Subscription__c WHERE ccrz__Account__c =: acnt[0].id AND ccrz__SubscriptionProduct__c=:productInsiteLite[0].id];

        ccrz__E_RequestForQuote__c requestQuote = [SELECT id,Discounted_Price__c,Discounted_Percentage__c,Cost_Subscription__c,CC_SubProdTerm__c FROM ccrz__E_RequestForQuote__c WHERE CC_Product__c =: productInsiteLite[0].id];
        Set<string> billNames = new Set<string>{subscriptionDetailsInsiteLite.ccrz__SPT__r.ccrz__DisplayName__c};
        Set<string> products = new Set<string>{subscriptionDetailsInsiteLite.ccrz__SubscriptionProduct__c};
        Set<string> stores = new Set<string>{'SoftwareStore'};
        System.runAs(testRunUser) {
            List<ccrz__E_PriceListItem__c> pricelistItems = OSM_SW_ProductDetailCommonUtility.getProductRecurringPrices(billNames,products,stores);
            Decimal oneTimePrice = OSM_SW_ProductDetailCommonUtility.getOneTimePerDayPrice(requestQuote,subscriptionDetailsInsiteLite);
            System.assertEquals(true,pricelistItems.isEmpty());
        }
        Test.StopTest();
    }

    static testMethod void deletePreOrderSubscriptionsRenewTest() {
        User testRunUser = getUserDetails();
        Test.StartTest();
        List<Account> acnt = [SELECT id,OSM_Preferred_Billing_Frequency__c FROM Account WHERE Name ='TestingProdUtilAccount0' LIMIT 1];
        List<ccrz__E_Product__c> product = [SELECT id FROM ccrz__E_Product__c WHERE Name = 'Cummins Guidanz™ Service Package0' AND ccrz__ProductType__c='Bundle'];
        List<ccrz__E_Product__c> aggregateproduct = [SELECT id FROM ccrz__E_Product__c WHERE Name = 'Cummins Guidanz™ Service Package0' AND ccrz__ProductType__c='Aggregated'];
        
        ccrz__E_Subscription__c subscriptionDetails = [SELECT id,Purchase_Date__c,ccrz__Account__c,OneTimePerDayPrice__c,OSM_Subscription_End_Date__c
        , ccrz__InstallmentNextDate__c,ccrz__SubscriptionStartDate__c,ccrz__RecurringPrice__c
        , Current_Invoice_Due_Date__c,ccrz__SPT__c,ccrz__SPT__r.Billing_Display_Name__c,ccrz__SPT__r.ccrz__OrderFrequency__c
        , Next_Invoice_Generation_Date__c, Last_Installment_Generated__c,OSM_Display_Product__c, ccrz__SubscriptionProduct__c
         FROM ccrz__E_Subscription__c WHERE ccrz__Account__c =: acnt[0].id AND ccrz__SubscriptionProduct__c=:product[0].id AND ccrz__SubscriptionStatus__c = 'Active'];
        
        
        ccrz__E_Order__c orderDetail = [SELECT id,Name FROM ccrz__E_Order__c WHERE ccrz__Name__c = 'Test Order Product Util' Limit 1];
        List<ccrz__E_SubProdTerm__c> subProdTerm = [SELECT id, Billing_Display_Name__c, BillingFrequency_Sequence__c, ccrz__DisplayName__c
        , Subs_Year_Multipler__c, Subs_Length_Sequence__c FROM ccrz__E_SubProdTerm__c WHERE Name ='Cummins Guidanz Service Package- 1 month One Time0'];

        ccrz__E_OrderItem__c orderItemDetailsGuidanzRenew = TestingUtils.createOrderItems(orderDetail.id, product[0].id, aggregateproduct[0].id, false);
        orderItemDetailsGuidanzRenew.ccrz__SubProdTerm__c =subProdTerm[0].id;
        insert orderItemDetailsGuidanzRenew;
        ccrz__E_ContactAddr__c contactAddress1 = OSM_TestDataCreationUtility_NonStatic.createContactAddress(acnt[0].id);

        ccrz__E_Cart__c cartDetails = [SELECT id, ccrz__ActiveCart__c, ccrz__CartStatus__c FROM ccrz__E_Cart__c WHERE ccrz__Account__c =:acnt[0].id];
        cartDetails.ccrz__ActiveCart__c = false;
        cartDetails.ccrz__CartStatus__c = 'Closed';
        update cartDetails;

        //List<ccrz__E_Cart__c> cartDetailsNew = TestingUtils.CreateCart(1, 'SoftwareStore', 'Cart', testRunUser.id, true, 'Open', true,acnt[0].id);
        List<ccrz__E_Cart__c> cartDetailsNew = [SELECT id FROM ccrz__E_Cart__c WHERE ccrz__Account__c=:acnt[0].id];
        List<ccrz__E_CartItem__c> guidanzCartItemRenew = TestingUtils.createCartItem(1, 'SoftwareStore', cartDetailsNew[0].id, 'Major', 1 , product[0].id, subProdTerm[0].id, 180, false);
        guidanzCartItemRenew[0].isRenew__c = true;
        insert guidanzCartItemRenew;

        ccrz__E_Subscription__c subscriptionDetailsGuidanzRenew = OSM_TestDataCreationUtility_NonStatic.createSubscription(acnt[0].id, orderDetail.id, orderItemDetailsGuidanzRenew.id,
        aggregateproduct[0].id, product[0].id, testRunUser.id, subProdTerm[0].id, contactAddress1.id, 200, 'Renew', false);
        DateTime subguidanzDateTimeRenew = DateTime.newInstance(2023, 7, 7, 7, 8, 12);
        subscriptionDetailsGuidanzRenew.ccrz__InstallmentNextDate__c= subguidanzDateTimeRenew.addMonths(6);
        subscriptionDetailsGuidanzRenew.Next_Invoice_Generation_Date__c = subguidanzDateTimeRenew.addYears(2);
        subscriptionDetailsGuidanzRenew.Renewed_From_Subscription__c = subscriptionDetails.id;
        insert subscriptionDetailsGuidanzRenew;

        List<Id> orderItemIds = new List<Id>(); 
        orderItemIds.add(orderItemDetailsGuidanzRenew.id);
        Map<Id,ccrz__E_CartItem__c> productToCartItem = new Map<id,ccrz__E_CartItem__c>{guidanzCartItemRenew[0].ccrz__Product__c => guidanzCartItemRenew[0]};
        Map<id,ccrz__E_SubProdTerm__c> subProdMap = new Map<id,ccrz__E_SubProdTerm__c>{subProdTerm[0].id=>subProdTerm[0]};
        OSM_SW_cc_hk_Subscriptions.orderItemIdToDeleteLst = orderItemIds;
        OSM_SW_ProductDetaiServiceCls.DiscountedPriceWrapper  discount=  new OSM_SW_ProductDetaiServiceCls.DiscountedPriceWrapper();
        System.runAs(testRunUser) {
            OSM_SW_ProductDetailCommonUtility.deletePreOrderSubscriptoins(productToCartItem, orderItemIds);
            OSM_SW_ProductDetailCommonUtility.getMonth(5);
            OSM_SW_ProductDetailCommonUtility.getFinalPriceYearly(subProdMap,discount);
        }
        Test.StopTest(); 

    }
}