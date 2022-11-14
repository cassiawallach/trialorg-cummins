/************************************************************
Name:  OSM_BMSGetPDFRetryIntBatch_Test
Copyright © 2018  Cummins
=============================================================
=============================================================
Purpose:                                                            
This is batch class for BMSGetPDF Integration 
=============================================================
=============================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE              DETAIL                                
1.0 -   Neha Mehta         18/01/2019   INITIAL DEVELOPMENT
2.0 -   Dhiraj         13/06/2021   Defect for MAR-1738       
Redeploying due to deletion by Guidanz team in UAT   


*************************************************************/
@isTest
public class OSM_BMSGetPDFRetryIntBatch_Test{

public static testMethod void pdfRecievedMethod_test(){

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
        testAccount.CSS_DistributorCode__c='03520';
        testAccount.CSS_DBCode__c='020400';
        testAccount.BMS_Customer_ID__c='22925';
        testAccount.Customer_Location_Code__c = '123';
    
        insert testAccount;
    
        Contact contact1 = new Contact(
        FirstName = 'Test',
        Lastname = 'McTesty',
        AccountId = testAccount.Id,
        //IAM_Cummins_login_ID__c='test',
        Username__c='testusernameunique1234321@gmail.com',
        Email = 'testusernameunique1234321@gmail.com'
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
            testSubProdTerm.Operation__c ='*';
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
            
            
            ccrz__E_PriceListItem__c priceListItem=new ccrz__E_PriceListItem__c();
            priceListItem.ccrz__SubProdTerm__c=testSubProdTerm.id;
            priceListItem.ccrz__Product__c=product.id;
            priceListItem.ccrz__Price__c=10;
            priceListItem.Distributor_Price__c=0;
            priceListItem.ccrz__Pricelist__c=testPriceList.id;
            priceListItem.ccrz__RecurringPrice__c=false;
            insert priceListItem;
            
            List<ccrz__E_Cart__c> lstECart = new List<ccrz__E_Cart__c>();       
            ccrz__E_Cart__c testCart = new ccrz__E_Cart__c();
            testCart.ccrz__Storefront__c = 'Software';
            testCart.ccrz__CartType__c = 'Cart';
            testCart.ccrz__ActiveCart__c = true;
            testCart.ccrz__CartStatus__c='Open';
            testCart.ccrz__User__c = UserInfo.getUserId();
            testCart.ccrz__EncryptedId__c = 'encrypt';
            lstECart.add(testCart);
            insert lstECart;
            
            ccrz__E_CartItem__c testCartItem = new ccrz__E_CartItem__c();
            testCartItem.ccrz__Cart__c = lstECart[0].id;
            testCartItem.ccrz__Quantity__c = 10;
            testCartItem.ccrz__OriginalQuantity__c = 11;
            testCartItem.ccrz__Product__c = Product.id;
            testCartItem.ccrz__SubProdTerm__c =testSubProdTerm.id;
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
            testCartItem.ccrz__UnitOfMeasure__c ='EA';
            
            insert testCartItem;

            CC_Tax__c tax=new CC_Tax__c();
            tax.CalculatedTax__c='10';
            tax.CC_Cart_Item__c=testCartItem.id;
            tax.EffectiveRate__c='10';
            tax.JurisdictionId__c='1112';
            tax.JurisdictionLevel__c='CITY';
            tax.NonTaxable__c='NonTaxable';
            insert tax;     
        
            ccrz__E_ContactAddr__c contactAddress = new ccrz__E_ContactAddr__c();
            contactAddress.Account__c = testAccount.id;
            contactAddress.ccrz__AddressFirstline__c = '1460 N National Rd';
            contactAddress.ccrz__City__c = 'Scottsdale';
            contactAddress.ccrz__State__c='Arizona';
            contactAddress.ccrz__StateISOCode__c='AZ';
            contactAddress.ccrz__PostalCode__c='85259';
            insert contactAddress;
            
            ccrz__E_Order__c testOrder = new ccrz__E_Order__c();
            testOrder.ccrz__Name__c = 'TestOrder';
            testOrder.ccrz__Contact__c = contact1.id;
            testOrder.ccrz__Account__c=testAccount.Id;
            testOrder.BMS_BranchLocation__c='E4';
            testOrder.Order_Source_Type__c='OSM';
            testOrder.BMS_OrderRefNumber__c=12345;
            testOrder.ccrz__OriginatedCart__c=testCart.id;
            testOrder.ccrz__BillTo__c=contactAddress.id;
            testOrder.ccrz__ShipTo__c=contactAddress.id;
            testOrder.OrderProcessedforFSD__c=true;
            insert testOrder;
            
            List<ccrz__E_OrderItem__c> testOrderItemList = new List<ccrz__E_OrderItem__c>();
            ccrz__E_OrderItem__c testOrderItem = new ccrz__E_OrderItem__c();
            testOrderItem.ccrz__Order__c = testOrder.id;
            testOrderItem.ccrz__Product__c = product.id;
            testOrderItem.ccrz__Price__c = 450;
            testOrderItem.ccrz__Quantity__c = 2;
            testOrderItem.ccrz__SubAmount__c = 200;
            testOrderItem.ccrz__SubProdTerm__c=testSubProdTerm.id;
            testOrderItemList.add(testOrderItem);           
            insert testOrderItemList;
            
           
              
            List<ccrz__E_Invoice__c> lstCCInvoices = new List<ccrz__E_Invoice__c>();
            for(Integer i=0; i<10; i++){
            ccrz__E_Invoice__c ccInvoices = new ccrz__E_Invoice__c();
            ccInvoices.ccrz__CCOrder__c = testOrder.id;
            ccInvoices.ccrz__Contact__c = contact1.id;
            ccInvoices.ccrz__CurrencyCode__c = 'USD';
            ccInvoices.ccrz__Status__c = 'Open';
            ccInvoices.ccrz__Storefront__c = 'Software';
            ccInvoices.ccrz__DateIssued__c = System.today().addMonths(2);
            ccInvoices.ccrz__OriginalAmount__c = 200;
            ccInvoices.ccrz__Terms__c = 'TestDataTerms';
            ccInvoices.BMS_PONumber__c='123456';
            ccInvoices.BMS_InvoiceNumber__c=123456;
            ccInvoices.Recurring_Invoice__c=false;
            ccInvoices.OSM_SW_Is_Bolt_PO__c=false;
            ccInvoices.OSM_SW_IsIntercompanyInvoice__c=false;
            ccInvoices.OSM_PDF_Received__c=false;

            lstCCInvoices.add(ccInvoices);
        }
        insert lstCCInvoices;
        Test.StartTest();
         OSM_BMSGetPDFRetryInt.pdfRecievedMethod(lstCCInvoices);

        Test.StopTest();
        }
        }