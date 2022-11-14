//Updated By Nandigam Sasi as part of MAR-1548
//Updated By Nandigam Sasi as part of MAR-1675
/************************************************
 History
 --------
 VERSION    AUTHOR          DATE            DETAILS
 1.0        Ashish          13/05/2021      Test Class Fixes
 */
 @IsTest
public class OSM_OMS_InterCompanyScheduler_Test{
     static testMethod void OSM_OMS_InterCompanyScheduler_TestMethod(){
       Id SYS_ADMIN_PROFILE_ID = [SELECT Id FROM Profile WHERE Name = 'System Administrator' Limit 1 ].Id; 
        //User Record
        Double randomNumber = math.random();
        User user1=TestingUtils.createUser('testqw'+randomNumber,SYS_ADMIN_PROFILE_ID,true);
        //Parent account
        Account parentAccount = new Account();
        parentAccount.Name = 'testacc1';
         parentAccount.type=' Distributor HQ';
        parentAccount.BillingStreet = 'Street';
        parentAccount.BillingCity = 'City';
        parentAccount.BillingState = '';
        parentAccount.BOLT_Account_Number__c = '999';
        parentAccount.BillingPostalCode = '11000';
        parentAccount.BillingCountry = 'United States';
        parentAccount.CMI_Region__c = 'India';
        parentAccount.CSS_Locale__c = 'English(India)';
        parentAccount.CSS_Timezone__c = '(GMT+05:30) India Standard Time (Asia/Kolkata)';
        insert parentAccount;
        //Account
        Account testaccount = new Account();
        testAccount.Name = 'testacc';
        
        //testAccount.ParentId=parentAccount.id;
        testAccount.BillingStreet = 'Street';
        testAccount.BillingCity = 'City';
        testAccount.BillingState = '';
        testAccount.BOLT_Account_Number__c = '999';
        testAccount.BillingPostalCode = '11000';
        testAccount.BillingCountry = 'United States';
        testAccount.CMI_Region__c = 'India';
        testAccount.CSS_Locale__c = 'English(India)';
        testAccount.CSS_Timezone__c = '(GMT+05:30) India Standard Time (Asia/Kolkata)';
        insert testAccount;
        system.debug('testAccount'+testAccount);
        
        //conatct record
        List<Contact> contacts=TestingUtils.createContact(1,testAccount.id,user1.id,true);
        //CC Order
        Set<Id>OrderId = new Set<Id>();
        ccrz__E_Order__c o1 = new ccrz__E_Order__c ();
        o1.ccrz__Storefront__c = 'SoftwareStore';
        o1.ccrz__Account__c = testAccount.Id;
        o1.OrderProcessedforFSD__c=true;
        o1.IsInterCompanyProcessSuccess__c=false;
        //o1.ccrz__AbsoluteDiscount__c = 
        o1.ccrz__CurrencyISOCode__c = 'USD';
        o1.ccrz__OrderStatus__c = 'Order Submitted';
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
        System.debug('---CC Product---'+pro);
        
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
        spt.ccrz__EffectiveStart__c = system.now()+2;
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
        oi1.Dn_Price__c=1000;
        insert oi1;
        System.debug('---CC OrderItem---'+oi1); 
        
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
        oi11.Dn_Price__c=1000;
        insert oi11;
        
        
        
        ccrz__E_PriceList__c price = new ccrz__E_PriceList__c();
        price.ccrz__Desc__c = 'test1111';
        price.ccrz__Storefront__c = 'SoftwareStore';
        insert price;
        
        ccrz__E_PriceListItem__c priceItem  = new ccrz__E_PriceListItem__c ();
        priceItem.Distributor_Price__c = 20;
        priceItem.ccrz__Pricelist__c = price.id;
        priceItem.ccrz__SubProdTerm__c = spt.id;
        priceItem.ccrz__Product__c = pro1.id;
        priceItem.ccrz__RecurringPrice__c = false;
        priceItem.Distributor_Price__c=1000;
        insert priceItem;
        Map<Id, ccrz__E_PriceListItem__c > mapSubProdIdToPriceListItem = new Map<Id, ccrz__E_PriceListItem__c >();
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
        insert invoice; 
        
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
        
        system.runAs(user1)
        {
          
        Test.StartTest();
        OSM_OMS_InterCompanyScheduler sh1 = new OSM_OMS_InterCompanyScheduler();
        
        String sch = '0 0 23 * * ?'; 
        system.schedule('Test Territory Check', sch, sh1); 
            String CRON_EXP = '0 0 0,6,12,18 * * ?';
        System.schedule('OSM InterCompanyInvoice RetryBatch 12345345',CRON_EXP, new OSM_InterCompanyInvoice_RetryBatch());
        Test.stopTest(); 
        }
 }
 
}