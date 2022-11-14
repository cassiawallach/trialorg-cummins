/************************************************************
Name:  OSM_GOMS_Retry_Batch_Test
Copyright © 2019  Cummins
=============================================================
=============================================================
Purpose:                                                            
This is test class for OSM_GOMS_Retry_Batch class.                          
=============================================================
=============================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE              DETAIL                                
1.0 -    Rupesh Ranjan     15/06/2020        INITIAL DEVELOPMENT  
2.0 -    Sangeeta Rani     10/05/2021        Updated   
3.0 -    Subbu K           07/28/2021        MAR-1861 
4.0 -    Swetha k          06/07/2022        
this test classs for Goms_Mule_Integration
*****************************************************/
@isTest
public class OSM_GOMS_Retry_Batch_Test{
    static testMethod void OSM_GOMS_Cancel_Retry_Batch_Test_BatchMethod(){  
        /*ccrz__E_Invoice__c  invc = new ccrz__E_Invoice__c ();
        invc.Is_GOMS_Integration_Processed__c = true;
        invc.Is_GOMS_Intercompany_Invoice__c= true;
        invc.GOMS_Invoice_ID__c = '123';
        insert invc;

        OSM_GOMS_Retry_Batch batchtest= new OSM_GOMS_Retry_Batch();
        Database.QueryLocator ql = batchtest.start(null);
        batchtest.execute(null,lstInv);
        batchtest.Finish(null);
        */
        Set<Id> set_InvId = new Set<Id>();
        for(ccrz__E_Invoice__c invObj : [SELECT Id FROM ccrz__E_Invoice__c WHERE Original_Sales_Order_Invoice_Number__c = null]){
            set_InvId.add(invObj.Id);
        }
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new Mock_GOMS_Mule_Integration());
        GOMS_Integration_BaseClass.callIntegrationMethod(set_InvId, false);
        Test.stopTest();  
    }
    
    
    static testMethod void OSM_GOMS_Cancel_Retry_Batch_Test_BatchMethod2(){  
        Set<Id> set_InvId = new Set<Id>();
        List<ccrz__E_Invoice__c> list_Invoice = new List<ccrz__E_Invoice__c>();
        for(ccrz__E_Invoice__c invObj : [SELECT Id, IsRecurringIntercompanyInvoice__c FROM ccrz__E_Invoice__c WHERE Original_Sales_Order_Invoice_Number__c != null]){
            set_InvId.add(invObj.Id);
            invObj.IsRecurringIntercompanyInvoice__c = true;
            list_Invoice.add(invObj);
        }
       
        Test.startTest();
        update list_Invoice;
        Test.setMock(HttpCalloutMock.class, new Mock_GOMS_Mule_Integration());
        GOMS_Integration_BaseClass.callIntegrationMethod(set_InvId, false);
        
        Test.stopTest();  
    }
    

    static testMethod void OSM_GOMS_Cancel_Retry_Batch_Test_BatchMethod3(){  
        Set<Id> set_InvId = new Set<Id>();
        for(ccrz__E_Invoice__c invObj : [SELECT Id FROM ccrz__E_Invoice__c WHERE Original_Sales_Order_Invoice_Number__c = null]){
            set_InvId.add(invObj.Id);
        }
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new Mock_GOMS_Mule_Integration_Failure());
        GOMS_Integration_BaseClass.callIntegrationMethod(set_InvId, false);
        Test.stopTest();
    }
    
    static testMethod void OSM_GOMS_Retry_BatchMethod4(){  
         List<ccrz__E_Invoice__c> set_InvId = new List<ccrz__E_Invoice__c>();
        for(ccrz__E_Invoice__c invObj : [SELECT Id FROM ccrz__E_Invoice__c WHERE Original_Sales_Order_Invoice_Number__c = null]){
            set_InvId.add(invObj);
        }

        
        Test.startTest();
        OSM_GOMS_Retry_Batch batchtest= new OSM_GOMS_Retry_Batch();
        Database.QueryLocator ql = batchtest.start(null);
        batchtest.execute(null,set_InvId);
        batchtest.Finish(null);
        
        Test.stopTest();  
    }
    
    @testSetup
    static void setup(){
        CSS_Integration_Details__c conDetails4 = new CSS_Integration_Details__c();
        conDetails4.name = 'GOMS Mule Auth';
        conDetails4.End_Point__c = 'http://example.com/example/test3';
        conDetails4.Resource__c = 'http://example.com/example/test2';
        conDetails4.Username__c= 'appSubscription-api-key';
        conDetails4.Passcode__c = 'OPJQg+I3X+t8OWbfMJexpQwIGiXRzXKROBieKx/jBlA=';
        insert conDetails4;
        
        CSS_Integration_Details__c conDetails = new CSS_Integration_Details__c();
        conDetails.name = Label.GOSM_Invoice_Integration;
        conDetails.End_Point__c = 'http://example.com/example/test';
        conDetails.Resource__c = 'http://example.com/example/test2';
        conDetails.Username__c= 'appSubscription-api-key';
        conDetails.Passcode__c = 'OPJQg+I3X+t8OWbfMJexpQwIGiXRzXKROBieKx/jBlA=';
        conDetails.AuthEnv__c = 'GOMS Mule Auth';
        conDetails.Method_Type__c = 'POST';
        insert conDetails;
        
        Id SYS_ADMIN_PROFILE_ID = [SELECT Id FROM Profile WHERE Name = 'System Administrator' Limit 1].Id;
        
        //User Record
        Double randomNumber = math.random();
        User user1 = TestingUtils.createUser('testingUser' + randomNumber, SYS_ADMIN_PROFILE_ID, true);
        //system.debug('_______user1____' + user1);
        
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
        //system.debug('testAccount' + testAccount);

        //conatct record
        List < Contact > contacts = TestingUtils.createContact(1, testAccount.id, user1.id, true);
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
        //system.debug('---CC Product---' + pro);

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
        //system.debug('---CC OrderItem---' + oi1);

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
        invoice.ccrz__Contact__c = contacts[0].id;
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
        invoice.Is_GOMS_Intercompany_Invoice__c= true;
        insert invoice;
        
        ccrz__E_Invoice__c invoice2 = new ccrz__E_Invoice__c();
        invoice2.ccrz__CCOrder__c = o1.id;
        invoice2.ccrz__Contact__c = contacts[0].id;
        invoice2.ccrz__User__c = user1.id;
        invoice2.ccrz__BillTo__c = testaccount.id;
        invoice2.ccrz__SoldTo__c = testaccount.id;
        invoice2.ccrz__CurrencyCode__c = 'USD';
        invoice2.ccrz__DateIssued__c = System.today();
        invoice2.ccrz__DateDue__c = System.today();
        invoice2.ccrz__OriginalAmount__c = 10000;
        invoice2.ccrz__RemainingAmount__c = 0.00;
        invoice2.ccrz__Storefront__c = 'SoftwareStore';
        invoice2.OSM_Child_Account__c = testAccount.Id;
        invoice2.Is_GOMS_Intercompany_Invoice__c= true;
        invoice2.Original_Sales_Order_Invoice_Number__c = invoice.Id;
        insert invoice2;
        
        OSM_Orders_In_Invoice__c OrdrInv = new OSM_Orders_In_Invoice__c();
        OrdrInv.CC_Invoice__c = invoice2.Id;
        OrdrInv.CC_Order__c = o1.id;
        insert OrdrInv;

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
        transactionPayment.ccrz__Contact__c = contacts[0].id;
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
    }
}