@isTest
public class OSM_SW_ProrationUtility_Test {
       public static ccrz__E_Subscription__c testData(){
         User loggedInUser=[Select id from User where id=:UserInfo.getUserId()];  
      //Create account
        Account testaccount = new Account();
        testAccount.Name = 'testaccount';
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
       // testAccount.OSM_Location_ID__c='03520-020400';
        insert testAccount;   
                 
         ccrz__E_Cart__c testCart = new ccrz__E_Cart__c();
            testCart.ccrz__Storefront__c = 'SoftwareStore';
            testCart.ccrz__CartType__c = 'Cart';
            testCart.ccrz__ActiveCart__c = true;
            testCart.ccrz__CartStatus__c='Closed';
            testCart.ccrz__User__c = loggedInUser.Id;
            testCart.ccrz__EncryptedId__c = 'encrypt';
            insert testCart;
            
            Contact testContact = new Contact();
            testContact.FirstName = 'FirstName';
            testContact.LastName = 'LastName';
            testContact.AccountId = testAccount.id;
            testContact.MobilePhone = '9999999999';
            testContact.Email = 'testEmail' + '@test.com';
            testContact.IAM_Contact_Status__c = 'Active';
            testContact.Username__c = 'testEmailuni21232' + '@test.com';
         
            if(loggedInUser!=null)
            testContact.OwnerId = loggedInUser.Id;
            insert testContact;
            ccrz__E_ContactAddr__c contactAddress=createContactAddress(testAccount.id);
         //Create Order
         ccrz__E_Order__c testOrder = TestingUtils.createOrder(testContact.Id,'test order',true);
         testOrder.ccrz__Account__c =testAccount.id;
         testOrder.ccrz__OriginatedCart__c = testCart.Id;
         update testOrder;
          // Create Invoice
          ccrz__E_Invoice__c ccInvoices = new ccrz__E_Invoice__c();
            ccInvoices.ccrz__CCOrder__c = testOrder.Id;
            ccInvoices.ccrz__Contact__c = testContact.Id;
            ccInvoices.ccrz__CurrencyCode__c = 'USD';
            ccInvoices.ccrz__Status__c = 'Open';
            ccInvoices.ccrz__Storefront__c = 'SoftwareStore';
            ccInvoices.ccrz__DateIssued__c = System.today().addMonths(2);
            ccInvoices.ccrz__OriginalAmount__c = 200;
            ccInvoices.ccrz__Terms__c = 'TestDataTerms';
            ccInvoices.ccrz__DateDue__c= System.today().addMonths(4);
            insert ccInvoices;
         
         
         List<ccrz__E_Product__c> componentlist=new List<ccrz__E_Product__c>();
         
         ccrz__E_Product__c ccCompositeProduct = new ccrz__E_Product__c();
       
        ccCompositeProduct.name = 'Connected Advisor';
        ccCompositeProduct.ccrz__ProductStatus__c = 'Released';
        ccCompositeProduct.ccrz__Quantityperunit__c = 1;
        ccCompositeProduct.ccrz__SKU__c = '5678000-DEF' ;
        ccCompositeProduct.ccrz__StartDate__c = System.today().addMonths(-1);
        ccCompositeProduct.ccrz__EndDate__c = System.today().addMonths(4);
        ccCompositeProduct.Group_Name__c = 'DA';
        ccCompositeProduct.ccrz__LongDesc__c = 'Long Description';
        ccCompositeProduct.ccrz__ProductType__c ='Product';
        ccCompositeProduct.Product_Class_Code__c = 'SW-Web Access';
       // insert ccCompositeProduct;
        componentlist.add(ccCompositeProduct);
        insert componentlist;
        ccrz__E_SubProdTerm__c testSubProdTerm = new ccrz__E_SubProdTerm__c();
            testSubProdTerm.name = 'testProd';
            testSubProdTerm.ccrz__EffectiveStart__c = System.today().addMonths(-1);
            testSubProdTerm.ccrz__EffectiveEnd__c = System.today().addMonths(4);
            testSubProdTerm.ccrz__CCProduct__c = componentlist[0].id;
           // testSubProdTerm.Operation__c ='*';
            testSubProdTerm.ccrz__Enabled__c = true;
            testSubProdTerm.ccrz__Storefront__c = 'SoftwareStore';
            testSubProdTerm.Billing_Display_Name__c = 'One';
            testSubProdTerm.ccrz__OrderFrequency__c=2;
            testSubProdTerm.ccrz__DisplayName__c='1 Year';
            insert testSubProdTerm;

        //Create Order Item
        ccrz__E_OrderItem__c testOrderItem = TestingUtils.createOrderItems(testOrder.Id,componentList[0].ID,true);
        ccrz__E_Subscription__c subscriptionDetail=createSubscription(testAccount.id, testOrder.id, 
                                                                      testOrderItem.id, ccCompositeProduct.id, 
                                                                      componentlist[0].id, loggedInuser.id, 
                                                                      testSubProdTerm.id,ccInvoices.id, contactAddress.id, -1, 'Active', true);
                                                                  
     ccrz__E_Subscription__c SubscriptionData=[Select id,Monthly_Price__c,ccrz__SPT__r.ccrz__DisplayName__c,PerDayDnPrice__c,Monthly_Dn_Price__c,Current_Invoice_Due_Date__c,ccrz__SPT__r.ccrz__OrderFrequency__c,Latest_Invoice__r.ccrz__DateDue__c,ccrz__InstallmentNextDate__c,ccrz__SubscriptionStartDate__c,Purchase_Date__c,Last_Installment_Generated__c,ccrz__CCOrderItem__c,ccrz__CCOrder__c,OSM_Display_Product__c,ccrz__InstallmentCountRemaining__c,ccrz__Account__c,OSM_Subscription_End_Date__c,OneTimePerDayPrice__c,ccrz__Storefront__c,ccrz__SPT__c,ccrz__SPT__r.Billing_Display_Name__c from ccrz__E_Subscription__c where id=:subscriptionDetail.id];
     return SubscriptionData;
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
                                                             ID subProdTermID,ID ccInvoicesID,ID contactAddressID, Decimal recurringPrice, String status, Boolean doInsert)
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
        subscription.ccrz__InstallmentCountRemaining__c = 0;
        subscription.ccrz__User__c = userID;
        subscription.OSM_Subscription_End_Date__c=System.today().addMonths(4);
        subscription.Next_Invoice_Generation_Date__c = System.today().addMonths(-1);
        subscription.Subsequent_Next_Invoice_Due_Dt__c = System.today();
        subscription.Subsequent_Next_Invoice_Generation_Dt__c = System.today();
        subscription.Latest_Invoice__c=ccInvoicesID;
        subscription.ccrz__CurrencyISOCode__c='USD';
        subscription.ccrz__InstallmentAddress__c=contactAddressID;
        subscription.ccrz__OrderAddress__c=contactAddressID;
        subscription.ccrz__InstallmentNextDate__c=System.today().addMonths(-1);           
        subscription.Recurring_Invoice_Start_Date__c = System.today().addMonths(-2);
        subscription.ccrz__SPTInstallmentCount__c = 12;
        subscription.OneTimePerDayPrice__c=10;
        subscription.Purchase_Date__c=System.today();
        subscription.Monthly_Price__c=20;
        subscription.PerDayDnPrice__c=20;
        subscription.Monthly_Dn_Price__c=10;
        
        
        if(doInsert)
            insert subscription;
        
        return subscription;
    }
    
    static testMethod void getCalculatedProrationTest(){
        
        ccrz__E_Subscription__c SubscriptionData=testData();
        Test.StartTest();
        OSM_SW_ProrationUtility.getCalculatedProrationAmount(SubscriptionData,'One');
        OSM_SW_ProrationUtility.priceCalculationNonOneTimeSubscription(SubscriptionData,'One',System.Today());
        OSM_SW_ProrationUtility.getReccInvoiceStartDate(SubscriptionData,'Monthly');
        Test.StopTest();
    }
    
    static testMethod void getCalculatedProrationMonthlyTest(){  

        ccrz__E_Subscription__c SubscriptionData=testData();
        Test.StartTest();
        OSM_SW_ProrationUtility.getCalculatedProrationAmount(SubscriptionData,'Monthly');
        OSM_SW_ProrationUtility.priceCalculationNonOneTimeSubscription(SubscriptionData,'Monthly',System.Today());
       Test.StopTest();

    }

    static testMethod void getCalculatedProrationQuarterlyTest(){  
        ccrz__E_Subscription__c SubscriptionData=testData();
        Test.StartTest();
        OSM_SW_ProrationUtility.getCalculatedProrationAmount(SubscriptionData,'Quarterly');
        Test.StopTest();
    }
    
    static testMethod void getCalculatedProrationYearlyTest(){  
        ccrz__E_Subscription__c SubscriptionData=testData();
        Test.StartTest();
        OSM_SW_ProrationUtility.getCalculatedProrationAmount(SubscriptionData,'Yearly');
        OSM_SW_ProrationUtility.getCalculatedProrationAmount(SubscriptionData,'Yearly','DnPrice');
        OSM_SW_ProrationUtility.priceCalculationNonOneTimeSubscription(SubscriptionData,'Yearly',system.today(),'DnPrice');
        OSM_SW_ProrationUtility.priceCalculationOneTimeSubscription(SubscriptionData,'One',system.today(),'DnPrice');
        OSM_SW_ProrationUtility.priceCalculationNonOneTimeSubscription(SubscriptionData,'One',system.today(),'DnPrice');
        Test.StopTest();
        

    }

}