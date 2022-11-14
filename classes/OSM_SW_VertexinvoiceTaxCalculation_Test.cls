//updated by swetha for MP-431
@IsTest
public class OSM_SW_VertexinvoiceTaxCalculation_Test {

    @testSetup static void setup() {
        CSS_Integration_Details__c objCID1 = new CSS_Integration_Details__c(AuthEnv__c = 'OSMBolt',
	                                                                       IsActive__c = true,
	                                                                       Timeout__c = 120000,
	                                                                       Method_Type__c = 'POST',
	                                                                       ApplicationName__c = 'getVertexQuoteTax',
	                                                                       Name = 'getVertexQuoteTax',
	                                                                       End_Point__c = 'https://services-dev.cummins.com/cso/taxquote');
        insert objCID1;
        
        CSS_Integration_Details__c objCID2 = new CSS_Integration_Details__c(AuthEnv__c = 'OSMBolt',
	                                                                       IsActive__c = true,
	                                                                       Timeout__c = 120000,
	                                                                       Method_Type__c = 'POST',
	                                                                       ApplicationName__c = 'getVertexInvoiceTax',
	                                                                       Name = 'getVertexInvoiceTax',
	                                                                       End_Point__c = 'https://services-dev.cummins.com/cso/taxinvoice');
        insert objCID2;
    }
    
    static testMethod void getVirtualVertexQuoteTax_Test() {
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

        // Creating address
        System.runAs(transecRes.objSetupDate.loggedInUser) {
            
            Test.StartTest();

            OSM_SW_Batch_Subscription_Helper.InvoiceLineAndOrderLineWrapper objLineWrapper = new OSM_SW_Batch_Subscription_Helper.InvoiceLineAndOrderLineWrapper();
            objLineWrapper.junc = transecRes.invoiceLineAndOrderLine;
            objLineWrapper.invoice = transecRes.invoice;
            objLineWrapper.order = transecRes.order;
            objLineWrapper.orderId = transecRes.order.Id;
            objLineWrapper.invoiceid = transecRes.invoice.Id;
            objLineWrapper.orderLineId = transecRes.orderItem.Id;
            objLineWrapper.qty = 10;
            objLineWrapper.totalSalesAmt = 10;
            objLineWrapper.vertexTax = 2;
            
            OSM_SW_Batch_Subscription_Helper.SingleInvoiceForAccountWrapper objWrapper = new OSM_SW_Batch_Subscription_Helper.SingleInvoiceForAccountWrapper();
            objWrapper.acc = transecRes.objSetupDate.account;
            objWrapper.invoiceLineOrderLineWrapperLst = new List<OSM_SW_Batch_Subscription_Helper.InvoiceLineAndOrderLineWrapper>{objLineWrapper};
            
            try {
                
                OSM_SW_VertexActions.getVirtualVertexQuoteTax(new Map < Id, OSM_SW_Batch_Subscription_Helper.SingleInvoiceForAccountWrapper >{transecRes.objSetupDate.account.Id => objWrapper});
            
                ccrz__E_ContactAddr__c objAddress = new ccrz__E_ContactAddr__c();
                objAddress.ccrz__AddressFirstline__c = '1460 N National Rd';
                objAddress.ccrz__AddressSecondline__c = '';
                objAddress.ccrz__City__c = 'Columbus';
                objAddress.ccrz__CompanyName__c = 'HCL';
                objAddress.ccrz__Country__c = 'United States';
                objAddress.ccrz__CountryISOCode__c = 'US';
                objAddress.ccrz__FirstName__c = 'Sharad';
                objAddress.ccrz__Email__c = 'test@gamil.com';
                objAddress.ccrz__LastName__c = 'Sahu';
                objAddress.ccrz__PostalCode__c = '47201';
                objAddress.ccrz__StateISOCode__c = 'IN';
                objAddress.ccrz__State__c = 'Indiana';
                insert objAddress;
    
                ccrz__E_Cart__c updateCart = new ccrz__E_Cart__c();
                updateCart.Id = transecRes.cart.Id;
                updateCart.ccrz__BillTo__c = objAddress.Id;
                updateCart.ccrz__ShipTo__c = objAddress.Id;
                updateCart.ccrz__TotalDiscount__c = 25;
                update updateCart;
                
                ccrz__E_CartItem__c updatecartItem = transecRes.cartItem;
                updatecartItem.Prorated_Coupon_Discount__c = 10;
                update updatecartItem;
                
                ccrz__E_Order__c updateOrder = new ccrz__E_Order__c();
                updateOrder.Id = transecRes.order.Id;
                updateOrder.ccrz__BillTo__c = objAddress.Id;
                updateOrder.ccrz__ShipTo__c = objAddress.Id;
                update updateOrder;
                
                OSM_SW_VertexActions.getVirtualVertexQuoteTax(new Map < Id, OSM_SW_Batch_Subscription_Helper.SingleInvoiceForAccountWrapper >{transecRes.objSetupDate.account.Id => objWrapper});
                OSM_SW_VertexActions.getVirtualVertexQuoteTax(new Map < Id, OSM_SW_Batch_Subscription_Helper.SingleInvoiceForAccountWrapper >());
            
            } catch (Exception ex) {
                system.debug('--xx------ex---112--'+ex);
                system.debug('--xx------getcause---112--'+ex.getcause());
                system.debug('--xx------getLineNumber---112--'+ex.getLineNumber());
                system.debug('--xx------getMessage---112--'+ex.getMessage());
                system.debug('--xx------getStackTraceString---112--'+ex.getStackTraceString());
                system.debug('--xx------getTypeName---112--'+ex.getTypeName());
            }

            Test.StopTest();
        }
    }
    
    static testMethod void testVertexJobs() {

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

        // Creating address
        System.runAs(transecRes.objSetupDate.loggedInUser) {

            ccrz__E_ContactAddr__c objAddress = new ccrz__E_ContactAddr__c();
            objAddress.ccrz__AddressFirstline__c = '1460 N National Rd';
            objAddress.ccrz__AddressSecondline__c = '';
            objAddress.ccrz__City__c = 'Columbus';
            objAddress.ccrz__CompanyName__c = 'HCL';
            objAddress.ccrz__Country__c = 'United States';
            objAddress.ccrz__CountryISOCode__c = 'US';
            objAddress.ccrz__FirstName__c = 'Sharad';
            objAddress.ccrz__Email__c = 'test@gamil.com';
            objAddress.ccrz__LastName__c = 'Sahu';
            objAddress.ccrz__PostalCode__c = '47201';
            objAddress.ccrz__StateISOCode__c = 'IN';
            objAddress.ccrz__State__c = 'Indiana';
            insert objAddress;

            ccrz__E_Cart__c updateCart = new ccrz__E_Cart__c();
            updateCart.Id = transecRes.cart.Id;
            updateCart.ccrz__BillTo__c = objAddress.Id;
            updateCart.ccrz__ShipTo__c = objAddress.Id;
            updateCart.ccrz__TotalDiscount__c = 25;
            update updateCart;
            
            ccrz__E_CartItem__c updatecartItem = transecRes.cartItem;
            updatecartItem.Prorated_Coupon_Discount__c = 10;
            update updatecartItem;
            
            ccrz__E_Order__c updateOrder = new ccrz__E_Order__c();
            updateOrder.Id = transecRes.order.Id;
            updateOrder.ccrz__BillTo__c = objAddress.Id;
            updateOrder.ccrz__ShipTo__c = objAddress.Id;
            update updateOrder;
            
            Test.StartTest();

            OSM_SW_Addresses objAddress1 = new OSM_SW_Addresses();
            OSM_SW_Addresses.Address objAddressInner = new OSM_SW_Addresses.Address();
            objAddressInner.address1 = '1460 N National Rd';
            objAddressInner.address2 = '';
            objAddressInner.city = 'Columbus';
            objAddressInner.state = 'IN';
            objAddressInner.country = 'US';
            objAddressInner.postalCode = '47201';
            objAddress1.billingAddress = objAddressInner;
            objAddress1.shippingAddress = objAddressInner;
            //    Test.setMock(HttpCalloutMock.class,new OMS_Vertex_Mock());
            
            try {
                OSM_SW_VertexActions.getVertexQuoteTax(updateCart.Id, null);
                OSM_SW_VertexActions.getVertexQuoteTax(updateCart.Id, objAddress1);
            } catch (Exception ex) {}

            Test.StopTest();

        }

    }
    static testMethod void testVertexJobs2() {


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

        // Creating address
        System.runAs(transecRes.objSetupDate.loggedInUser) {

            ccrz__E_ContactAddr__c objAddress = new ccrz__E_ContactAddr__c();
            objAddress.ccrz__AddressFirstline__c = '1460 N National Rd';
            objAddress.ccrz__AddressSecondline__c = '';
            objAddress.ccrz__City__c = 'Columbus';
            objAddress.ccrz__CompanyName__c = 'HCL';
            objAddress.ccrz__Country__c = 'United States';
            objAddress.ccrz__CountryISOCode__c = 'US';
            objAddress.ccrz__FirstName__c = 'Sharad';
            objAddress.ccrz__Email__c = 'test@gamil.com';
            objAddress.ccrz__LastName__c = 'Sahu';
            objAddress.ccrz__PostalCode__c = '47201';
            objAddress.ccrz__StateISOCode__c = 'IN';
            objAddress.ccrz__State__c = 'Indiana';

            insert objAddress;



            ccrz__E_Cart__c updateCart = new ccrz__E_Cart__c();

            updateCart.Id = transecRes.cart.Id;
            updateCart.ccrz__BillTo__c = objAddress.Id;
            updateCart.ccrz__ShipTo__c = objAddress.Id;

            update updateCart;

            ccrz__E_Order__c updateOrder = new ccrz__E_Order__c();

            updateOrder.Id = transecRes.order.Id;
            updateOrder.ccrz__BillTo__c = objAddress.Id;
            updateOrder.ccrz__ShipTo__c = objAddress.Id;

            update updateOrder;




            Test.StartTest();

            List < Id > lstJunctionObjId = new List < Id > ();
            lstJunctionObjId.add(transecRes.orderInInvoice.Id);
            //  Test.setMock(HttpCalloutMock.class,new OMS_Vertex_Mock());

            OSM_SW_VertexinvoiceTaxCalculation.calculateInvoiceTax(lstJunctionObjId);
            OSM_SW_VertexinvoiceTaxCalculation.calculateInvoiceTaxFuture(lstJunctionObjId);
            OSM_SW_VertexinvoiceTaxCalculation.CalculateRefundInvoiceTaxFuture(lstJunctionObjId);
            OSM_SW_VertexinvoiceTaxCalculation.CalculateRefundInvoiceTax(lstJunctionObjId);

            Test.StopTest();

        }






    }

    static testMethod void testVertexJobs3() {


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

        // Creating address
        System.runAs(transecRes.objSetupDate.loggedInUser) {

            ccrz__E_ContactAddr__c objAddress = new ccrz__E_ContactAddr__c();
            objAddress.ccrz__AddressFirstline__c = '1460 N National Rd';
            objAddress.ccrz__AddressSecondline__c = '';
            objAddress.ccrz__City__c = 'Columbus';
            objAddress.ccrz__CompanyName__c = 'HCL';
            objAddress.ccrz__Country__c = 'United States';
            objAddress.ccrz__CountryISOCode__c = 'US';
            objAddress.ccrz__FirstName__c = 'Sharad';
            objAddress.ccrz__Email__c = 'test@gamil.com';
            objAddress.ccrz__LastName__c = 'Sahu';
            objAddress.ccrz__PostalCode__c = '47201';
            objAddress.ccrz__StateISOCode__c = 'IN';
            objAddress.ccrz__State__c = 'Indiana';

            insert objAddress;



            ccrz__E_Cart__c updateCart = new ccrz__E_Cart__c();

            updateCart.Id = transecRes.cart.Id;
            updateCart.ccrz__BillTo__c = objAddress.Id;
            updateCart.ccrz__ShipTo__c = objAddress.Id;

            update updateCart;

            ccrz__E_Order__c updateOrder = new ccrz__E_Order__c();

            updateOrder.Id = transecRes.order.Id;
            updateOrder.ccrz__BillTo__c = objAddress.Id;
            updateOrder.ccrz__ShipTo__c = objAddress.Id;

            //update updateOrder;




            Test.StartTest();

            List < Id > lstJunctionObjId = new List < Id > ();
            lstJunctionObjId.add(transecRes.orderInInvoice.Id);

            OSM_SW_VertexinvoiceTaxCalculation.calculateInvoiceTax(lstJunctionObjId);
            OSM_SW_VertexinvoiceTaxCalculation.calculateInvoiceTaxFuture(lstJunctionObjId);
            OSM_SW_VertexinvoiceTaxCalculation.CalculateRefundInvoiceTaxFuture(lstJunctionObjId);
            OSM_SW_VertexinvoiceTaxCalculation.CalculateRefundInvoiceTax(lstJunctionObjId);

            // to cover class OSM_VERTEX_WS_CalculateTaxRes

            OSM_VERTEX_WS_CalculateTaxRes objRes = new OSM_VERTEX_WS_CalculateTaxRes();
            objRes.Header = new OSM_VERTEX_WS_CalculateTaxRes.Header();
            objRes.Header.Transaction_Z = new OSM_VERTEX_WS_CalculateTaxRes.Transaction_Z();
            objRes.Header.Sender = new OSM_VERTEX_WS_CalculateTaxRes.Sender();
            objRes.Header.Target = new OSM_VERTEX_WS_CalculateTaxRes.Target();
            objRes.Header.ReturnCodeDescription = '';
            objRes.Header.Transaction_Z.QuotationResponseDocumentNumber = '';
            objRes.Header.Transaction_Z.InvoiceResponseDocumentNumber = '';
            objRes.Header.Transaction_Z.Transaction_Type = '';
            objRes.Header.Transaction_Z.DocumentDate = '';

            objRes.Header.Sender.ServiceName = '';
            objRes.Header.Sender.SenderID = '';

            objRes.Header.Target.TargetID = '';


            OSM_VERTEX_WS_CalculateTaxReq.parse('{"Header":{"Transaction":{"Trusted_ID":"","TransactionID":"","Transaction_Type":"SALE","InvoiceRequestDocumentNumber":"I-0000000948","DocumentDate":"2018-09-18"}}}');



            OSM_VERTEX_WS_GeneralizedInputWrapper testObj = new OSM_VERTEX_WS_GeneralizedInputWrapper();
            testObj.DataArea = new OSM_VERTEX_WS_GeneralizedInputWrapper.DataArea();

            OSM_VERTEX_WS_GeneralizedInputWrapper.ProductList objProductlst = new OSM_VERTEX_WS_GeneralizedInputWrapper.ProductList();
            objProductlst.DiscountPercentage = '';
            objProductlst.BC = '';
            objProductlst.RC = '';

            OSM_VERTEX_WS_GeneralizedInputWrapper.Seller objSel = new OSM_VERTEX_WS_GeneralizedInputWrapper.Seller();
            objSel.Company_Code = '';
            objSel.Division_Code = '';
            Test.StopTest();

        }
    }
    static testMethod void testVertexJobs4() {
        //Account
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
        testAccount.CSS_DistributorCode__c = '02850';
        testAccount.CSS_DBCode__c = '020400';
        testAccount.BMS_Customer_ID__c = '22925';
        testAccount.Customer_Location_Code__c = '123';
        insert testAccount;

        Contact contact1 = new Contact(
            FirstName = 'Test',
            Lastname = 'McTesty',
            AccountId = testAccount.Id, Username__c = 'test43254@gmail.com',
            Email = System.now().millisecond() + 'test@test.com'
        );
        insert contact1;
        ccrz__E_Product__c product = new ccrz__E_Product__c();

        product.name = 'CA Base-DEF';
        product.ccrz__ProductStatus__c = 'Released';
        product.ccrz__Quantityperunit__c = 1;
        product.ccrz__SKU__c = '5678901-DEF';
        product.ccrz__StartDate__c = System.today().addMonths(-1);
        product.ccrz__EndDate__c = System.today().addMonths(4);
        product.Group_Name__c = 'DA';
        product.ccrz__LongDesc__c = 'Long Description';
        product.ccrz__ProductType__c = 'Product';
        product.Product_Class_Code__c = 'SW-Web Access';

        insert product;

        ccrz__E_SubProdTerm__c testSubProdTerm = new ccrz__E_SubProdTerm__c();
        testSubProdTerm.name = 'SubProd';
        testSubProdTerm.ccrz__EffectiveStart__c = System.today().addMonths(-1);
        testSubProdTerm.ccrz__EffectiveEnd__c = System.today().addMonths(4);
        testSubProdTerm.ccrz__CCProduct__c = product.id;
        testSubProdTerm.Operation__c = '*';
        testSubProdTerm.ccrz__Enabled__c = true;
        testSubProdTerm.ccrz__Storefront__c = 'SoftwareStore';
        testSubProdTerm.Billing_Display_Name__c = 'Monthly';
        insert testSubProdTerm;

        ccrz__E_PriceList__c testPriceList = new ccrz__E_PriceList__c();
        testPriceList.Name = 'DEF_PL';
        testPriceList.ccrz__StartDate__c = System.today().addMonths(-1);
        testPriceList.ccrz__EndDate__c = System.today().addMonths(5);
        testPriceList.ccrz__CurrencyISOCode__c = 'USD';
        testPriceList.ccrz__Enabled__c = true;
        testPriceList.ccrz__Storefront__c = 'SoftwareStore';
        insert testPriceList;


        ccrz__E_PriceListItem__c priceListItem = new ccrz__E_PriceListItem__c();
        priceListItem.ccrz__SubProdTerm__c = testSubProdTerm.id;
        priceListItem.ccrz__Product__c = product.id;
        priceListItem.ccrz__Price__c = 10;
        priceListItem.Distributor_Price__c = 0;
        priceListItem.ccrz__Pricelist__c = testPriceList.id;
        priceListItem.ccrz__RecurringPrice__c = false;
        insert priceListItem;

        List < ccrz__E_Cart__c > lstECart = new List < ccrz__E_Cart__c > ();
        ccrz__E_Cart__c testCart = new ccrz__E_Cart__c();
        testCart.ccrz__Storefront__c = 'Software';
        testCart.ccrz__CartType__c = 'Cart';
        testCart.ccrz__ActiveCart__c = true;
        testCart.ccrz__CartStatus__c = 'Open';
        testCart.ccrz__User__c = UserInfo.getUserId();
        testCart.ccrz__EncryptedId__c = 'encrypt';
        lstECart.add(testCart);
        insert lstECart;

        ccrz__E_CartItem__c testCartItem = new ccrz__E_CartItem__c();
        testCartItem.ccrz__Cart__c = lstECart[0].id;
        testCartItem.ccrz__Quantity__c = 10;
        testCartItem.ccrz__OriginalQuantity__c = 11;
        testCartItem.ccrz__Product__c = Product.id;
        testCartItem.ccrz__SubProdTerm__c = testSubProdTerm.id;
        testCartItem.ccrz__Price__c = 15;
        testCartItem.ccrz__RecurringPrice__c = 25;
        testCartItem.ccrz__RecurringPriceSubAmt__c = 12;
        testCartItem.ccrz__StoreID__c = 'SoftwareStore';
        testCartItem.ccrz__OriginalItemPrice__c = 100;
        testCartItem.ccrz__DisplayProduct__c = Product.Id;
        testCartItem.ccrz__ProductType__c = 'Product';
        testCartItem.ccrz__cartItemType__c = 'Major';
        testCartItem.ccrz__SubAmount__c = 10;
        testCartItem.ccrz__Subscription_Duration__c = 12;
        testCartItem.ccrz__Subscription_Frequency__c = 4;
        testCartItem.ccrz__UnitOfMeasure__c = 'EA';

        insert testCartItem;

        CC_Tax__c tax = new CC_Tax__c();
        tax.CalculatedTax__c = '10';
        tax.CC_Cart_Item__c = testCartItem.id;
        tax.EffectiveRate__c = '10';
        tax.JurisdictionId__c = '1112';
        tax.JurisdictionLevel__c = 'CITY';
        tax.NonTaxable__c = 'NonTaxable';
        insert tax;

        ccrz__E_ContactAddr__c contactAddress = new ccrz__E_ContactAddr__c();
        contactAddress.Account__c = testAccount.id;
        contactAddress.ccrz__AddressFirstline__c = '1460 N National Rd';
        contactAddress.ccrz__City__c = 'Scottsdale';
        contactAddress.ccrz__State__c = 'Arizona';
        contactAddress.ccrz__StateISOCode__c = 'AZ';
        contactAddress.ccrz__PostalCode__c = '85259';
        insert contactAddress;

        ccrz__E_Order__c testOrder = new ccrz__E_Order__c();
        testOrder.ccrz__Name__c = 'TestOrder';
        testOrder.ccrz__Contact__c = contact1.id;
        testOrder.ccrz__Account__c = testAccount.Id;
        testOrder.BMS_BranchLocation__c = 'E4';
        testOrder.Order_Source_Type__c = 'OSM';
        testOrder.BMS_OrderRefNumber__c = 12345;
        testOrder.ccrz__OriginatedCart__c = testCart.id;
        testOrder.ccrz__BillTo__c = contactAddress.id;
        testOrder.ccrz__ShipTo__c = contactAddress.id;
        insert testOrder;

        List < ccrz__E_OrderItem__c > testOrderItemList = new List < ccrz__E_OrderItem__c > ();
        ccrz__E_OrderItem__c testOrderItem = new ccrz__E_OrderItem__c();
        testOrderItem.ccrz__Order__c = testOrder.id;
        testOrderItem.ccrz__Product__c = product.id;
        testOrderItem.ccrz__Price__c = 450;
        testOrderItem.ccrz__Quantity__c = 2;
        testOrderItem.ccrz__SubAmount__c = 200;
        testOrderItem.ccrz__SubProdTerm__c = testSubProdTerm.id;
        testOrderItemList.add(testOrderItem);
        insert testOrderItemList;



        //        List<ccrz__E_Invoice__c> lstCCInvoices = new List<ccrz__E_Invoice__c>();
        // for(Integer i=0; i<10; i++){
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


        //  lstCCInvoices.add(ccInvoices);
        // }
        // insert lstCCInvoices;
        insert ccInvoices;
        ccrz__E_TransactionPayment__c transactionPayment = new ccrz__E_TransactionPayment__c();
        // transactionPayment.Transaction_Status__c = transactionStatus;
        transactionPayment.ccrz__Storefront__c = 'SoftwareStore';
        transactionPayment.ccrz__Token__c = 'TestToken';
        transactionPayment.ccrz__TransactionCode__c = 'TestTransactionCode';
        transactionPayment.ccrz__CCOrder__c = testOrder.id;
        // transactionPayment.ccrz__InvoiceAppliedTo__c = lstCCInvoices[0].id;
        transactionPayment.ccrz__InvoiceAppliedTo__c = ccInvoices.id;
        transactionPayment.ccrz__BillTo__c = testAccount.id;
        transactionPayment.ccrz__SoldTo__c = testAccount.id;
        transactionPayment.ccrz__Account__c = testAccount.id;
        transactionPayment.ccrz__Contact__c = contact1.id;
        //  transactionPayment.ccrz__User__c = userID;
        //  transactionPayment.ccrz__AccountType__c = accountType;
        transactionPayment.ccrz__AccountNumber__c = '1';
        insert transactionPayment;
        OSM_SW_Addresses objAddress1 = new OSM_SW_Addresses();
        OSM_SW_Addresses.Address objAddressInner = new OSM_SW_Addresses.Address();
        objAddressInner.address1 = '1460 N National Rd';
        objAddressInner.address2 = '';
        objAddressInner.city = 'Columbus';
        objAddressInner.state = 'IN';
        objAddressInner.country = 'US';
        objAddressInner.postalCode = '47201';
        //insert objAddressInner;
        objAddress1.billingAddress = objAddressInner;
        objAddress1.shippingAddress = objAddressInner;
        // insert objAddress1;

        Test.StartTest();

        //    Test.setMock(HttpCalloutMock.class,new OMS_SubmitOrder_Mock());   
        try {
            OSM_SW_VertexActions.getVertexQuoteTax(testCart.Id, objAddress1);
        } catch (Exception ex) {}

        Test.StopTest();

    }
}