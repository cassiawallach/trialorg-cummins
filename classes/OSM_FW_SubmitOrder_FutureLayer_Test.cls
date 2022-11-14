//Test Class for the class OSM_FW_SubmitOrder_FutureLayer
/************************************************************
Name:  OSM_FW_SubmitOrder_FutureLayer_Test
Copyright © 2018  Cummins

=============================================================
=============================================================
Purpose:                                                                                             
=============================================================
=============================================================
History                                                            
-------                                                            
VERSION  AUTHOR             DATE              DETAIL                                
1.0 -   Sharad           06/09/2021     INITIAL DEVELOPMENT 
********************************** ******************************/
@isTest   
public class OSM_FW_SubmitOrder_FutureLayer_Test {
    @testSetup
    static void setup(){
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
            AccountId = testAccount.Id, Username__c = 'testqwerty123@gmail.com',
            Email = System.now().millisecond() + 'test@test.com',
            recordtypeid=Schema.SObjectType.Contact.getRecordTypeInfosByName().get('IAM').getRecordTypeId()
        );
        insert contact1;
        ccrz__E_Product__c product = new ccrz__E_Product__c();
        product.name = 'CA Base-DEF';
        product.ccrz__ProductStatus__c = 'Released';
        product.ccrz__Quantityperunit__c = 1;
        product.ccrz__SKU__c = '5678901-DEF';
        product.ccrz__StartDate__c = System.today().addMonths(-1);
        product.ccrz__EndDate__c = System.today().addMonths(4);
        product.Group_Name__c = 'FluidWatch';
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
        testCart.Third_Party_BMS_Customer_ID__c = '12345';
        testCart.OSM_SW_Is_third_Party_BMS_Payment__c = true;
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
        tax.NonTaxable__c = '123';
        tax.Taxable__c = '123';
        tax.Discount_Amount__c = 1;
        insert tax;

        ccrz__E_ContactAddr__c contactAddress = new ccrz__E_ContactAddr__c();
        contactAddress.Account__c = testAccount.id;
        contactAddress.ccrz__AddressFirstline__c = '1460 N National Rd';
        contactAddress.ccrz__City__c = 'Scottsdale';
        contactAddress.ccrz__State__c = 'Arizona';
        contactAddress.ccrz__StateISOCode__c = 'AZ';
        contactAddress.ccrz__PostalCode__c = '85259';
        contactAddress.ccrz__CountryISOCode__c = 'US';
        insert contactAddress;
        
        ccrz__E_Coupon__c coupon = new ccrz__E_Coupon__c();
        coupon.ccrz__CouponCode__c = Label.VOTECH100OFFINSITE;
        coupon.ccrz__CouponName__c = 'testName';
        coupon.ccrz__MaxUse__c = 12;
        coupon.ccrz__TotalUsed__c = 1;
        coupon.ccrz__DiscountAmount__c = 10;
        coupon.ccrz__CouponType__c ='Price';
        coupon.ccrz__DiscountType__c  ='Price';
        coupon.ccrz__RuleType__c = 'General';
        coupon.ccrz__TargetQty__c = 5;
        coupon.ccrz__TargetRelation__c = 'Product';
        coupon.ccrz__Storefront__c='SoftwareStore';
        //coupon.ccrz__TargetProduct__c = TestCompletedTransactionSetUpRes1.objSetupDate.compositeProduct.Id;
        //insert coupon;

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
        testOrderItem.Vertex_Tax__c= 40.5;
        //testOrderItem.ccrz__Coupon__c  = coupon.id;
        //insert testOrderItem;
        testOrderItemList.add(testOrderItem);
        insert testOrderItemList;
         
        

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
        insert ccInvoices;
        
        
        //
        ccrz__E_InvoiceItem__c invoiceItem_Item = new ccrz__E_InvoiceItem__c();
        invoiceItem_Item.ccrz__CCOrderItem__c  = testOrderItem.id;
        invoiceItem_Item.ccrz__OriginalAmount__c = 1000;
        invoiceItem_Item.ccrz__Invoice__c = ccInvoices.id;
        invoiceItem_Item.Quantity__c = 1;
        invoiceItem_Item.ccrz__Status__c = 'Open';
        invoiceItem_Item.ccrz__Type__c = 'Tax';
        invoiceItem_Item.IsCredited__c= true;
        invoiceItem_Item.ccrz__OriginalAmount__c=123;
        invoiceItem_Item.OSM_Bypass_Flow__c = true;
        insert invoiceItem_Item;
        //
        
        ccrz__E_TransactionPayment__c transactionPayment = new ccrz__E_TransactionPayment__c();
        transactionPayment.ccrz__Storefront__c = 'SoftwareStore';
        transactionPayment.ccrz__Token__c = 'TestToken';
        transactionPayment.ccrz__TransactionCode__c = 'TestTransactionCode';
        transactionPayment.ccrz__CCOrder__c = testOrder.id;
        transactionPayment.ccrz__InvoiceAppliedTo__c = ccInvoices.id;
        transactionPayment.ccrz__BillTo__c = testAccount.id;
        transactionPayment.ccrz__SoldTo__c = testAccount.id;
        transactionPayment.ccrz__Account__c = testAccount.id;
        transactionPayment.ccrz__Contact__c = contact1.id;
        transactionPayment.ccrz__AccountNumber__c = '1';
        insert transactionPayment;
        
        List < CSS_Integration_Details__c > settingsList = new List < CSS_Integration_Details__c > ();
        CSS_Integration_Details__c con = new CSS_Integration_Details__c();
        con.Name = 'BMS_PO_Auth';
        con.ApplicationName__c = 'BMS_PO_Auth';
        con.End_Point__c = 'https://api-ue-devnf-aw-ex.cummins.com/api/core-security-api/v1/auth/token';
        con.Username__c = '1a5b0057-8bbc-4784-9501-2f0ac9919503';
        con.Passcode__c = 'Af1/r82APwR__9rUu/gfTk=h5s.Io0Q/';
        con.Resource__c= 'https://api-ue-devnf-aw-ex.cummins.com/marketplace/salesorders';
        con.IsActive__c = true;
        con.Method_Type__c = 'POST';

        CSS_Integration_Details__c con1 = new CSS_Integration_Details__c();
        con1.Name = 'BMS_PO_SubmitOrder';
        con1.ApplicationName__c = 'BMS_PO_SubmitOrder';
        con1.AuthEnv__c = 'BMS_PO_Auth';
        con1.End_Point__c = 'https://api-ue-devnf3-aw-ex.cummins.com/marketplace/salesorders';
        con1.Method_Type__c = 'POST';
        con1.Username__c = '1ebed545196240749e6a847585ca16f0';
        con1.Passcode__c = '5ED106EC31b144c4B98a897412ee22dA';
        con1.IsActive__c = true;

        settingsList.add(con);
        settingsList.add(con1);
        insert settingsList;
    }
    
    public static testMethod void testMethod1() {
        Test.StartTest();
        
        Test.setMock(HttpCalloutMock.class, new Mock_OSM_MuleSoft_MW_Services(Label.OSM_SubmitOrder_ServiceName));
        ccrz__E_Order__c testOrder = [SELECT Id FROM ccrz__E_Order__c LIMIT 1];
        ccrz__E_OrderItem__c testOrderItem = [SELECT Id FROM ccrz__E_OrderItem__c LIMIT 1];
        Set<Id> setOrdItemId = new Set<Id>();
        setOrdItemId.add(testOrderItem.id);
        OSM_FW_SubmitOrder_FutureLayer.callFWSubmitOrderFuture(testorder.id,false,null);
        Test.StopTest();
    }
}