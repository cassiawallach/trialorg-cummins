//Test Class for the class OSM_WS_SubmitOrderBusiness_Handler
/************************************************************
Name:  OSM_WS_SubmitOrder_Test
Copyright © 2018  Cummins

=============================================================
=============================================================
Purpose:                                                                                             
=============================================================
=============================================================
History                                                             
-------                                                            
VERSION  AUTHOR             DATE              DETAIL                                
1.0 -   Neha Mehta         23/10/2018     INITIAL DEVELOPMENT 
2.0 -   Ashish Goyal       08/01/2020     INITIAL DEVELOPMENT 
3.0 -   Nandigam Sasi      10/03/2021     Updated Test classs
4.0 -   Ashish Goyal       05/04/2021     Updated Test classs
5.0 -   Sharad Sahu        13/04/2021     Updated Test classs
6.0 -   Pratima            22/04/2021     Updated Test classs
7.0 -   Singaiah           29/04/2021     Updated Test classs for MAR-1633 
8.0 -   Sangeeta Rani         14/05/2021    updated test class
9.0 -   Sangeeta Rani         14/05/2021    updated test class for MAR-1733
10.0 -  Dhiraj         07/06/2021    updated test class done
11.0 -  Dhiraj         29/06/2021    updated test class done
12.0 - Sangeets        29th july     updated
13.0 - Sharad          03th Aug     updated 
13.0 - sangeeta          16th Aug 2021    updated 
14.0 - Ashish          19/10/2021    updated 
13.0 - sangeeta        21st Oct 2021    updated 
15.0 - Swetha            20th Dec 2021  Updated test class
14.0 - Ashish          29/03/2022    updated 
15.0 - Swetha       08/06/2022 Updated Test Methods
********************************** ******************************/

@isTest 
public class OSM_WS_SubmitOrder_Test {
    Set<Id> setOrdItemId = new Set<Id>();
    
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

		//Added here
        ccrz__E_PriceListItem__c priceListItem = new ccrz__E_PriceListItem__c();
        priceListItem.ccrz__SubProdTerm__c = testSubProdTerm.id;
        priceListItem.ccrz__Product__c = product.id;
        priceListItem.ccrz__Price__c = 10;
        priceListItem.Distributor_Price__c = 0;
        priceListItem.ccrz__Pricelist__c = testPriceList.id;
        priceListItem.ccrz__RecurringPrice__c = false;
        insert priceListItem;

        //Added here
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
        ccInvoices.ccrz__CCOrder__c = testOrder.id; // Updated for Bug - 719
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
    
    public static testMethod void getOrderInfoForDATest() {
        Test.StartTest();
        
        Test.setMock(HttpCalloutMock.class, new Mock_OSM_MuleSoft_MW_Services(Label.OSM_SubmitOrder_ServiceName));
        
        ccrz__E_Order__c testOrder = [SELECT Id FROM ccrz__E_Order__c LIMIT 1];
        ccrz__E_OrderItem__c testOrderItem = [SELECT Id FROM ccrz__E_OrderItem__c LIMIT 1];
        
        Set<Id> setOrdItemId = new Set<Id>();
        setOrdItemId.add(testOrderItem.id);
        
        OSM_ReturnWrapper returnWrapper =  OSM_WS_SubmitOrderBusiness_Handler.getOrderInfo(testorder.id, 'Submit',null,'test',false,null);
         system.assertNotEquals(null, returnWrapper, 'The method should return the value on Submit');
         returnWrapper =   OSM_WS_SubmitOrderBusiness_Handler.getOrderInfo(testorder.id, 'Submit',setOrdItemId,'test',false,null);
         system.assertNotEquals(null, returnWrapper, 'The method should return the value on Submit with set of Order Items');
         returnWrapper =  OSM_WS_SubmitOrderBusiness_Handler.getOrderInfo(testorder.id, 'Cancel',null,'test',false,null);
         system.assertNotEquals(null, returnWrapper, 'The method should return the value on Cancel');
         returnWrapper =  OSM_WS_SubmitOrderBusiness_Handler.getOrderInfo(testorder.id, 'Cancel',setOrdItemId,'test',false,null);
         system.assertNotEquals(null, returnWrapper, 'The method should return the value on Cancel with set of Order Items');
        
        Test.StopTest();
    }
    
    public static testMethod void getOrderInfoForSESTest() 
    {
               
        ccrz__E_Cart__c cart = [SELECT Id, OSM_SW_Is_third_Party_BMS_Payment__c FROM ccrz__E_Cart__c LIMIT 1];
        cart.OSM_SW_Is_third_Party_BMS_Payment__c = false;
        update cart;
        system.assertEquals(false, cart.OSM_SW_Is_third_Party_BMS_Payment__c, 'The value of the boolean - is third party BMS Payment should be updated to false');        
         Test.starttest();   
        ccrz__E_Order__c testOrder = [SELECT Id FROM ccrz__E_Order__c LIMIT 1];
        ccrz__E_OrderItem__c testOrderItem = [SELECT Id FROM ccrz__E_OrderItem__c LIMIT 1];
        
        Set<Id> setOrdItemId = new Set<Id>();
        setOrdItemId.add(testOrderItem.id);
        
        Test.setMock(HttpCalloutMock.class, new Mock_OSM_MuleSoft_MW_Services(Label.OSM_SubmitOrder_ServiceName));
        
        OSM_ReturnWrapper returnWrapper =  OSM_WS_SubmitOrderBusiness_Handler.getOrderInfo(testorder.id, 'CANCEL',null,'test',false,null);
         system.assertNotEquals(null, returnWrapper, 'The method should return the value on Cancel');
          returnWrapper =   OSM_WS_SubmitOrderBusiness_Handler.getOrderInfo(testorder.id, 'CANCEL',setOrdItemId,'test',false,null);
         system.assertNotEquals(null, returnWrapper, 'The method should return the value on Cancel with order set items');
         returnWrapper =   OSM_WS_SubmitOrderBusiness_Handler.getOrderInfo(testorder.id, 'Submit',null,'test',false,null);
         system.assertNotEquals(null, returnWrapper, 'The method should return the value on Submit');
          returnWrapper =   OSM_WS_SubmitOrderBusiness_Handler.getOrderInfo(testorder.id, 'Submit',setOrdItemId,'test',false,null);
         system.assertNotEquals(null, returnWrapper, 'The method should return the value on Submit with order items');
        
        OSM_WS_SubmitOrderInfo_RESONSE.parse('{"header":{"status":"Success","returnCodeDescription":"","sender":{"messageID":"2-c3bd34a1-d376-11ea-9fde-12e0d26de8c8","serviceName":"FSD SubmitOrder","senderId":"Mrktplc"},"target":{"targetId":"ONEBMS"},"location":{"locationId":"02680"}},"dataArea":{"distributorCode":"02680","customerCode":"472849","headerList":{"branchLocation":"07","orderSourceType":"OSMCM","remitToName":"PACIFIC REGION CORPORATE","remitToAddress":"4711 N BASIN AVE (97217)","remitToState":"OR","remitToCity":"PORTLAND","remitToPostalCode":"97217","PdfRemittoAddress":"REMIT TO: Lockbox 138324 POB 398324 San Francisco, CA  94139","purchaseOrderNumber":"0707010312","totalDiscount":"","invoiceTotal":"-1200","invoiceNumber":"1417","orderReferenceNumber":"67710","invoiceDate":"2020-07-31T00:00:00.000-05:00","createDate":"2020-07-31T00:00:00.000-05:00"}}}');
        
        Test.stoptest();
    }

    public static testMethod void getOrderInfoForDATest4() 
    {
               
        Account acc = [SELECT Id, Customer_Location_Code__c FROM Account LIMIT 1];
        acc.Customer_Location_Code__c = null;
        update acc;
        system.assertEquals(null, acc.Customer_Location_Code__c, 'The value of the Customer Location Code should be updated to null');       
        
        ccrz__E_ContactAddr__c cont = [SELECT Id, ccrz__AddressFirstline__c, ccrz__AddressSecondline__c, ccrz__CountryISOCode__c, ccrz__City__c, ccrz__AddressThirdline__c FROM ccrz__E_ContactAddr__c LIMIT 1];
        cont.ccrz__AddressFirstline__c = 'ABC DEF';
        cont.ccrz__AddressSecondline__c = 'ABC DEF';        
        cont.ccrz__CountryISOCode__c = null;
        cont.ccrz__City__c = null;
        cont.ccrz__AddressThirdline__c = null;
        update cont;
        system.assertEquals('ABC DEF', cont.ccrz__AddressFirstline__c, 'The value of the Address should be updated to ABC DEF');       
        system.assertEquals(null, cont.ccrz__City__c, 'The value of the city should be updated to null');       
        
        ccrz__E_Order__c testorder = [SELECT Id, BMS_OrderRefNumber__c FROM ccrz__E_Order__c LIMIT 1];
        testorder.BMS_OrderRefNumber__c = null;
        update testorder;
        system.assertEquals(null, testorder.BMS_OrderRefNumber__c, 'The value of the order ref number should be updated to null');       
        
         ccrz__E_OrderItem__c testOrderItem = [SELECT Id FROM ccrz__E_OrderItem__c LIMIT 1];
        
        Set<Id> setOrdItemId = new Set<Id>();
        setOrdItemId.add(testOrderItem.id);
        Test.StartTest();
        Test.setMock(HttpCalloutMock.class, new Mock_OSM_MuleSoft_MW_Services(Label.OSM_SubmitOrder_ServiceName));

         OSM_ReturnWrapper returnWrapper =  OSM_WS_SubmitOrderBusiness_Handler.getOrderInfo(testorder.id, 'Cancel',null,'test',false,null);
         system.assertNotEquals(null, returnWrapper, 'The method should return the value on Cancel');
         returnWrapper =   OSM_WS_SubmitOrderBusiness_Handler.getOrderInfo(testorder.id, 'Cancel',setOrdItemId,'test',false,null);
         system.assertNotEquals(null, returnWrapper, 'The method should return the value on Cancel with order items');
         returnWrapper =   OSM_WS_SubmitOrderBusiness_Handler.getOrderInfo(testorder.id, 'Submit',null,'test',false,null);
         system.assertNotEquals(null, returnWrapper, 'The method should return the value on Submit');
         returnWrapper =  OSM_WS_SubmitOrderBusiness_Handler.getOrderInfo(testorder.id, 'Submit',setOrdItemId,'test',false,null);
         system.assertNotEquals(null, returnWrapper, 'The method should return the value on Submit with order items');
        
        Test.StopTest();
    }

    public static testMethod void submitOrderMethod5() {
        Test.StartTest();
        
        ccrz__E_Order__c testOrder = [SELECT Id FROM ccrz__E_Order__c LIMIT 1];
        
        OSM_WS_GeneralizedSubmitOrdrInpWrapper inputWrapperObj = new OSM_WS_GeneralizedSubmitOrdrInpWrapper();
        inputWrapperObj.dataArea = new OSM_WS_GeneralizedSubmitOrdrInpWrapper.DataArea();
        inputWrapperObj.header = new OSM_WS_GeneralizedSubmitOrdrInpWrapper.Header();
        inputWrapperObj.header.sender = new OSM_WS_GeneralizedSubmitOrdrInpWrapper.Sender();
        inputWrapperObj.header.target = new OSM_WS_GeneralizedSubmitOrdrInpWrapper.Target();
        
        OSM_WS_GeneralizedSubmitOrdrInpWrapper.FSDList fsdList;
        inputWrapperObj.dataArea.headerList = new List <OSM_WS_GeneralizedSubmitOrdrInpWrapper.FSDList> ();
        
        OSM_WS_GeneralizedSubmitOrderInputWrap.TaxList taxList;
        inputWrapperObj.dataArea.taxList = new List <OSM_WS_GeneralizedSubmitOrdrInpWrapper.TaxList> ();
        
        OSM_WS_GeneralizedSubmitOrderInputWrap.ChargeList chargeList;
        inputWrapperObj.dataArea.chargeList = new List <OSM_WS_GeneralizedSubmitOrdrInpWrapper.ChargeList> ();
        
        OSM_WS_GeneralizedSubmitOrderInputWrap.R_PARTSLIST_SUBMIT partList;
        inputWrapperObj.dataArea.partList = new List <OSM_WS_GeneralizedSubmitOrdrInpWrapper.PartList> ();
        
        OSM_WS_GeneralizedSubmitOrderOutputWrap returnWrapper =  OSM_WS_SubmitOrderInfoService.callSubmitOrderService(inputWrapperObj);
        system.assertNotEquals(null, returnWrapper, 'The method should return the value from the method');
        
        Test.StopTest();
    }
    
    public static testMethod void getOrderInfoForDATes44t() 
    {
	    
        ccrz__E_Cart__c cart = [SELECT Id, OSM_SW_Is_third_Party_BMS_Payment__c FROM ccrz__E_Cart__c LIMIT 1];
        cart.OSM_SW_Is_third_Party_BMS_Payment__c = false;
        update cart;
        system.assertEquals(false, cart.OSM_SW_Is_third_Party_BMS_Payment__c, 'The value of the boolean - is third party BMS Payment should be updated to false');         
        Test.StartTest();
        ccrz__E_Order__c testOrder = [SELECT Id FROM ccrz__E_Order__c LIMIT 1];
        ccrz__E_OrderItem__c testOrderItem = [SELECT Id FROM ccrz__E_OrderItem__c LIMIT 1];
        
        Set<Id> setOrdItemId = new Set<Id>();
        setOrdItemId.add(testOrderItem.id);
         
        Test.setMock(HttpCalloutMock.class, new Mock_OSM_MuleSoft_MW_Services(Label.OSM_SubmitOrder_ServiceName));
        
        OSM_ReturnWrapper returnWrapper =    OSM_WS_SubmitOrderBusiness_Handler.getOrderInfo(testorder.id, 'Submit',null,'test',false,null);
        system.assertNotEquals(null, returnWrapper, 'The method should return the value on Submit');
        returnWrapper =    OSM_WS_SubmitOrderBusiness_Handler.getOrderInfo(testorder.id, 'Submit',setOrdItemId,'test',false,null);
        system.assertNotEquals(null, returnWrapper, 'The method should return the value on Submit with list of order items');
        returnWrapper =    OSM_WS_SubmitOrderBusiness_Handler.getOrderInfo(testorder.id, 'Cancel',null,'test',false,null);
        system.assertNotEquals(null, returnWrapper, 'The method should return the value on Cancel');
        returnWrapper =    OSM_WS_SubmitOrderBusiness_Handler.getOrderInfo(testorder.id, 'Cancel',setOrdItemId,'test',false,null);
        system.assertNotEquals(null, returnWrapper, 'The method should return the value on Cancel with order items');
        
        Test.StopTest();
    }
    
    public static testMethod void getOrderInfoForFW() 
    {
        Test.StartTest();
        
        ccrz__E_Order__c testOrder = [SELECT Id FROM ccrz__E_Order__c LIMIT 1];
        OSM_ReturnWrapper returnWrapper =   OSM_FW_SubmitOrder_Handler.getOrderInfo(testorder.id,false,null);
        
        Test.StopTest();
        
        system.assertNotEquals(null, returnWrapper, 'The method should return the value');
    }
    
    public static testMethod void getOrderInfoForFW2() 
    {
               
        Account acc = [SELECT Id, IAM_Service_Provider_Code__c FROM Account LIMIT 1];
        acc.IAM_Service_Provider_Code__c = '02680';
        update acc;
        system.assertEquals('02680', acc.IAM_Service_Provider_Code__c, 'The value of the Service Provider code was updated successfully.');
        Test.StartTest();
        ccrz__E_Order__c testOrder = [SELECT Id FROM ccrz__E_Order__c LIMIT 1];
        
        Test.setMock(HttpCalloutMock.class, new Mock_OSM_MuleSoft_MW_Services('Fluidwatch'));
        OSM_ReturnWrapper returnWrapper =  OSM_FW_SubmitOrder_Handler.getOrderInfo(testorder.id,false,null);
        
        Test.StopTest();
        
        system.assertNotEquals(null, returnWrapper, 'The method should return the value');
    }
    
    public static testMethod void getOrderInfoForFW3() 
    {        
        Test.StartTest();
        
        ccrz__E_Order__c testOrder = [SELECT Id FROM ccrz__E_Order__c LIMIT 1];
        Account acc = [SELECT Id, IAM_Service_Provider_Code__c FROM Account LIMIT 1];
        acc.IAM_Service_Provider_Code__c = '02680';
        update acc;
        
        system.assertEquals('02680', acc.IAM_Service_Provider_Code__c, 'The value of the Service Provider code was updated successfully.');
        
        Test.setMock(HttpCalloutMock.class, new Mock_OSM_MuleSoft_MW_Services('Fluidwatch'));
        OSM_ReturnWrapper returnWrapper = OSM_FW_SubmitOrder_Handler.getOrderInfo(testorder.id,false,null);
        Test.StopTest();
        
        system.assertNotEquals(null, returnWrapper, 'The method should return the value');
        
    }
    
    public static testMethod void test_OSM_FW_SubmitOrder_Batch() {
        Test.StartTest();
        
        ccrz__E_Order__c testOrder = [SELECT Id, ccrz__OrderStatus__c FROM ccrz__E_Order__c LIMIT 1];
        //Setup an integration
        OSM_Integration_Log__c log = new OSM_Integration_Log__c();
        log.CC_Order__c = testOrder.Id;
        log.Status__c = 'Failure';
        log.Target__c = 'WINLIMS';
       	log.Service_Name__c ='SubmitOrder';
        insert log;
       
        //Execute the batch to run the integration.
        Id logid = Database.executeBatch(new OSM_FW_SubmitOrder_Batch(), 1);
        
        Test.StopTest();
        
        system.assertNotEquals(null,logid, 'The batch should be sent for processing.');
        
    }
   }