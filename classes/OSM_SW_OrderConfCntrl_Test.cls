//update by sangeeta on 12th May 2021
//update by Singaiah on 4 June 2021
//update by Swetha on 28th Jan 2022
//update by Swetha on 10th Feb 2022
//Updated on 04/04/2022
//Update Subbu
@IsTest
public class OSM_SW_OrderConfCntrl_Test {
     @testSetup
    static void setup(){
        IAMDistributorCodeGroupEmail__c customSettingIAM = new IAMDistributorCodeGroupEmail__c();
        customSettingIAM.Group_Email__c = 'test@testtt.com';
        customSettingIAM.Distributor_Code__c = '02850';
        customSettingIAM.Name = '02850';
        insert customSettingIAM;
    }  
    
    static testMethod void testParse() {
        Profile profileId = [SELECT Id FROM Profile WHERE Name = 'Standard User' LIMIT 1];
        
        User usr = new User(LastName = 'LIVESTON',
                           FirstName='JASON',
                           Alias = 'jliv',
                           Email = 'jason.liveston@asdf11.com',
                           Username = 'jason.liveston@asdf111.com',
                           ProfileId = profileId.id,
                           TimeZoneSidKey = 'GMT',
                           LanguageLocaleKey = 'en_US',
                           EmailEncodingKey = 'UTF-8',
                           LocaleSidKey = 'en_US'
                           );
        insert usr;
        RecordType recid =[select id from recordType where name='wwsps' limit 1];  
       
        System.runAs ( usr   ) {
        Account acc= new Account();
        acc.Name = 'name';
            acc.BillingStreet = '340 WINT LN';
            acc.BillingCity ='COLUMBUS';
            acc.BillingState = 'Indiana';
            acc.BillingPostalCode = '47201-6690';
             acc.RecordTypeId= recid.id;
             acc.BillingCountry = 'United States';
            // acc.IAM_For_W_Code_Creation_From_WWSPS__c=true;
        insert acc;
        
        contact c = new contact();
        c.AccountId = acc.Id;
        c.LastName = 'test';
            c.firstName = 'test';
            c.Email = 'test@test.com';
            c.Username__c = 'testuniquenwss12@test.com';
            
        insert c;
        
         ccrz__E_Cart__c cart = new ccrz__E_Cart__c();
            cart.OSM_Payment_Method__c = 'po';
            cart.ccrz__Account__c = acc.id;
            //cart.ccrz__EncryptedId__c=;
            insert cart;

            ccrz__E_Cart__c childCart = new ccrz__E_Cart__c();
            childCart.OSM_Payment_Method__c = 'po';
            childCart.ccrz__Account__c = acc.id;
            childCart.ccrz__EncryptedId__c = cart.id;
            childCart.OSM_SW_Is_third_Party_BMS_Payment__c=true;
            insert childCart;
            
        ccrz__E_ContactAddr__c conadd = new ccrz__E_ContactAddr__c();
        conadd.Account__c=acc.Id;
        insert conadd;
        ccrz__E_Order__c o1 = new ccrz__E_Order__c();
        o1.ccrz__Storefront__c = 'SoftwareStore';
        o1.ccrz__Account__c = acc.Id;
        o1.ccrz__CurrencyISOCode__c = 'USD';
        o1.ccrz__OriginatedCart__c=childCart.Id;
        insert o1;
        o1.ccrz__EncryptedId__c=o1.id;
        update o1;
             ccrz__E_Order__c newOrdr = new ccrz__E_Order__c();
        //newOrdr = transecRes.order.clone(false, true);
        newOrdr.ccrz__OrderStatus__c = 'Approved';
        //newOrdr.Original_Sales_Order__c = transecRes.order.Id;
        newOrdr.OSM_Bill_From__c='Cummins Inc';
        insert newOrdr;
        newOrdr.ccrz__EncryptedId__c=newOrdr.id;
        newOrdr.ccrz__EncryptedId__c = '4a2ae0c4-0556-44a4-b8a4-c8502dd6fc28';
             
        update  newOrdr;
           //  system.debug('Order Id'+newOrdr.id);
            //  system.debug('Order Id'+newOrdr.ccrz__EncryptedId__c);
       ccrz__E_OrderItem__c objItem = new ccrz__E_OrderItem__c();
        objItem.IsRevokeLicenseSucess__c = false;
        objItem.Revocation_Status__c = '';
      
        ccrz__E_Invoice__c newInvoice = new ccrz__E_Invoice__c();
        newInvoice.ccrz__CCOrder__c = newOrdr.Id;
        newInvoice.Original_Sales_Order__c=newOrdr.Id;
        newInvoice.OSM_SW_IsIntercompanyInvoice__c=true;
        insert newInvoice;
            
        OSM_SW_OrderConfCntrl tt = new OSM_SW_OrderConfCntrl();
        ccrz.cc_RemoteActionContext objRemotCtx = new ccrz.cc_RemoteActionContext();
        objRemotCtx.storefront='SoftwareStore';
        objRemotCtx.effAccountId=acc.Id;
        String pageUrl ='?o='+o1.id+'&portalUser';
          OSM_SW_OrderConfCntrl.addShippingAddress(objRemotCtx,pageUrl);
            ccrz.cc_CallContext.initRemoteContext(objRemotCtx);
        }
            
    }

   
static testMethod void testParse2() {
         TestProductSetupReq testReq = new TestProductSetupReq();
        testReq.permissionSetName = 'OSM_Support_Admin';        
        testReq.accountGroupName = 'TestingAccountGroup Test';
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
        
     //   System.debug('transecRes: '+transecRes);
        
        Test.StartTest();
        User usr = [Select id from User where Id =: UserInfo.getUserId()];


        Id portal_PROFILE_ID = [SELECT Id FROM Profile WHERE Name = 'IAM_Site_Admin_Community' Limit 1 ].Id;
        //Id   roleId=[select id,name from UserRole where name='CumminsFleetsCustomerUser' limit 1].id; 

        UserRole portalRole = [Select Id From UserRole Where PortalType = 'None' Limit 1];
       // system.debug('portalRole is ' + portalRole);

        Profile profile1 = [Select Id from Profile where name = 'System Administrator'];
        
             
        User portalAccountOwner2 = new User(
            UserRoleId = portalRole.Id,
            ProfileId = profile1.Id,
            Username = 'test24446@test.com',
            Alias = 'batman',
            Email = 'bruce.wayne@wayneenterprises.com',
            EmailEncodingKey = 'UTF-8',
            Firstname = 'Bruce',
            Lastname = 'Wayne',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            TimeZoneSidKey = 'America/Chicago'
        );
        Database.insert(portalAccountOwner2);
        
         System.runAs(portalAccountOwner2) {
        Account portalAccount1 = new Account(
            Name = 'TestAccount1',
            OwnerId = portalAccountOwner2.Id,
            OSM_Preferred_Billing_Frequency_Lock__c = true,
            BMS_Customer_ID__c = '1234',
            OSM_Preferred_Payment_Method__c = 'po',
            OSM_Preferred_Payment_IsBolt_PO__c = false,
            type = 'Dealer Account'
            
            
        );
        ccrz.cc_RemoteActionContext objRemotCtx = new ccrz.cc_RemoteActionContext();
        objRemotCtx.storefront='SoftwareStore';
        objRemotCtx.currentCartId=transecRes.cart.ccrz__EncryptedId__c;
        objRemotCtx.portalUserId=transecRes.objSetupDate.objUserID;
        ccrz.cc_CallContext.initRemoteContext(objRemotCtx);
       
        ccrz__E_Cart__c cart = transecRes.cart;
        cart.OSM_Payment_Method__c = 'po';
        cart.ccrz__Account__c = portalAccount1.id;
        cart.ccrz__EncryptedId__c = objRemotCtx.currentCartId;
        cart.OSM_SW_Is_third_Party_BMS_Payment__c = true;
        update cart;
        
        ccrz__E_Product__c product = transecRes.objSetupDate.compositeProduct;
        
        ccrz__E_CartItem__c cartItem = transecRes.cartItem;
        //cartItem.ccrz__ParentCartItem__c=childCart.id;
        cartItem.ccrz__Product__c = product.id;
        cartItem.ccrz__Quantity__c = 2;
        // cartItem.ccrz__ItemTotal__c=10;
        cartItem.ccrz__Price__c = 10;
        cartItem.ccrz__ProductType__c = 'Bundle';
        update cartItem;
        
        ccrz__E_CartItem__c cartItemChild = new ccrz__E_CartItem__c();
        cartItemChild.ccrz__Cart__c = cart.id;
        cartItemChild.OSM_SW_AddOn_Product_Of__c = cartItem.id;
        cartItemChild.ccrz__Product__c = product.id;
        cartItemChild.ccrz__ParentCartItem__c = cartItem.id;
        cartItemChild.ccrz__Quantity__c = 2;
        cartItemChild.ccrz__Price__c = 10;
        cartItemChild.ccrz__ProductType__c = 'Bundle';
        insert cartItemChild;
             
        set<string> prodid = new set<string>();
        ccrz__E_Product__c prod = new ccrz__E_Product__c();
        prod.name = 'Guidanz';
        prod.ccrz__SKU__c = '15458776';
        prod.ccrz__Quantityperunit__c = 3343;
        prod.ccrz__StartDate__c = system.today();
        prod.ccrz__EndDate__c = system.today()+1;
        prod.ccrz__ShortDesc__c = 'testing';
        prod.ccrz__ProductStatus__c='Released';
        insert prod;
        String prodidstring = String.valueof(prod.id);
        prodid.add(prodidstring); 
        
        ccrz__E_SubProdTerm__c subProdTermObj = new ccrz__E_SubProdTerm__c();
        subProdTermObj.ccrz__CCProduct__c = prodidstring;
        subProdTermObj.ccrz__DisplayName__c = 'Test SubProdTerm';
        subProdTermObj.ccrz__EffectiveEnd__c = system.today() + 50;
        subProdTermObj.ccrz__EffectiveStart__c = system.today();
        insert subProdTermObj;
        
        List<ccrz__E_Subscription__c> subList = new List<ccrz__E_Subscription__c>();
        ccrz__E_Subscription__c sub = new ccrz__E_Subscription__c();
        sub.OSM_Display_Product__c = prod.id;
        sub.ccrz__Quantity__c = 10;
        sub.ccrz__Sequence__c = 2;
        sub.ccrz__Account__c = transecRes.objSetupDate.account.Id;
        sub.ccrz__Storefront__c ='SoftwareStore';
        sub.ccrz__SubscriptionStartDate__c  = system.today();
        sub.OSM_Subscription_End_Date__c  = System.today()+50;
        sub.ccrz__SubscriptionStatus__c = 'Active';
        sub.ccrz__SubscriptionProduct__c = prod.id;
        sub.OSM_Free_Trial__c =false;
        sub.ccrz__SPT__c = subProdTermObj.Id;
        //sub.OSM_Display_Product__r.ccrz__ShortDesc__c = 'test description';
        subList.add(sub);
        insert subList;
      //  System.debug('SubList ' + subList[0].id);
        
        OSM_Order_Subscription__c objSubsc = new OSM_Order_Subscription__c();
        objSubsc.CC_Order_Item__c = transecRes.orderItem.Id;
        objSubsc.OSM_CCSubscription__c = subList[0].id;
        objSubsc.OSM_CCOrder__c = transecRes.order.Id;
        objSubsc.Billing_Frequency__c = 'Monthly';
        insert objSubsc;
      //  System.debug('transecRes.orderSubscriptionjunction: '+objSubsc);
        
        ccrz__E_Order__c newOrdr = new ccrz__E_Order__c();
        newOrdr = transecRes.order.clone(false, true);
        newOrdr.ccrz__OrderStatus__c = 'Approved';
        newOrdr.Original_Sales_Order__c = transecRes.order.Id;
        newOrdr.OSM_Bill_From__c='Cummins Inc';
        insert newOrdr;
        newOrdr.ccrz__EncryptedId__c=newOrdr.id;
        newOrdr.ccrz__EncryptedId__c = '4a2ae0c4-0556-44a4-b8a4-c8502dd6fc28';
             
        update  newOrdr;
            // system.debug('Order Id'+newOrdr.id);
              //system.debug('Order Id'+newOrdr.ccrz__EncryptedId__c);
       ccrz__E_OrderItem__c objItem = new ccrz__E_OrderItem__c();
        objItem.IsRevokeLicenseSucess__c = false;
        objItem.Revocation_Status__c = '';
        objItem.Id = transecRes.orderItem.Id;
       // objItem.ccrz__Order__c = transecRes.objItem.ccrz__Order__c; 
        update objItem;
             
         //system.debug('objItem-->'+objItem);
        
        ccrz__E_Invoice__c newInvoice = new ccrz__E_Invoice__c();
        newInvoice = transecRes.invoice.clone(false, true);
        newInvoice.ccrz__CCOrder__c = newOrdr.Id;
        newInvoice.Original_Sales_Order_Invoice_Number__c = transecRes.invoice.Id;
        newInvoice.Original_Sales_Order__c=newOrdr.Id;
        newInvoice.OSM_SW_IsIntercompanyInvoice__c=true;
        insert newInvoice;
        
        ccrz__E_TransactionPayment__c newTP = new ccrz__E_TransactionPayment__c();
        newTP = transecRes.transactionPayment.clone(false, true);
        newTP.ccrz__CCOrder__c = newOrdr.Id;
        newTP.ccrz__InvoiceAppliedTo__c = newInvoice.Id;
        newTP.ccrz__AccountType__c='cc';
        insert newTP;
        OSM_Features_Maintenance__c osmFeaMaint = new OSM_Features_Maintenance__c();
        osmFeaMaint.Name='Partial_Cancellation';
        osmFeaMaint.PO_Partial_Cancellation__c='ON';
        osmFeaMaint.CC_Partial_Cancellation__c='ON';
        insert osmFeaMaint;
        Test.setCurrentPageReference(new PageReference('Page.myPage')); 
        System.currentPageReference().getParameters().put('o', newOrdr.ccrz__EncryptedId__c);   
        //Test.StartTest();
         OSM_SW_OrderConfCntrl tt = new OSM_SW_OrderConfCntrl();
       // ccrz.cc_RemoteActionContext objRemotCtx = new ccrz.cc_RemoteActionContext();
        
        String pageUrl ='?o='+newOrdr.id+'&portalUser';
          OSM_SW_OrderConfCntrl.addShippingAddress(objRemotCtx,pageUrl);
          OSM_SW_OrderConfCntrl.callInterCompanyPDF(objRemotCtx,pageUrl);
          OSM_SW_OrderConfCntrl.savePdf(newInvoice.id);
          System.assertEquals(true, newInvoice.OSM_SW_IsIntercompanyInvoice__c);
          System.assertNotEquals(null,newInvoice,'The Invoice not Genarated');
         
             
        Test.StopTest();
         }
    }
  }