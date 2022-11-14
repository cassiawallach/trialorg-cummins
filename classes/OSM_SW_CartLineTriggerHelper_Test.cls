//Test Class for the class OSM_SW_CartLineTriggerHelper*******
// Update sharad 15 March 2021
//Vignesh - 03/19/2021 - Added Comment here to have GIT pick as a Test Class Execution for OSM March minor Prod release
//Vignesh - 04/06/2021 - Added Comment here to have GIT pick as a Test Class Execution for OSM April minor Prod release
//Vamsi - 04/14/2021 - Added Comment here to have GIT pick as a Test Class Execution for DBU Canada Prod release
//Vignesh - 04/26/2021 - Added Comment here to have GIT pick as a Test Class Execution for OSM minor_Apr2021Release release
//Vamsi - 04/28/2021 - Added Comment here to have GIT pick as a Test Class Execution for DBU Canada Prod release
//Vignesh - 05/07/2021 - Added Comment here to have GIT pick as a Test Class Execution for minor_BOLT_issue release
//Vignesh - 05/27/2021 - Added Comment here to have GIT pick as a Test Class Execution for OSM June major Prod release
//Vignesh - 07/14/2021 - Added Comment here to have GIT pick as a Test Class Execution for "minor_Production_fixes"
//Vignesh - 08/18/2021 - Added Comment here to have GIT pick as a Test Class Execution for "minor_Production_fixes0820"
//Vignesh - 01/04/2022 - Added Comment here to have GIT pick as a Test Class Execution for "minor_SP_Stories"
//Shadman - 01/07/2022 - Added Comment here to have GIT pick as a Test Class Execution for "minor_IAM_otherProdissues"
//Vignesh - 03/14/2022 - Added Comment here to have GIT pick as a Test Class Execution for "minor_prod_email_acctgrp_fixes"
//Vignesh - 05/12/2022 - Added Comment here to have GIT pick as a Test Class Execution for "major_QuarterlySubscriptionFeature"
//Subbu - 05/20/2022 - Added Comment here to habe GIT pick up as a Test Class Execution for "Major_Q2_June_SPandprodissues"
//Subbu updated
@IsTest
public class OSM_SW_CartLineTriggerHelper_Test{
   static testMethod void setPrimaryitem_Test(){
     TestProductSetupReq testReq = new TestProductSetupReq();
        testReq.permissionSetName = 'OSM_Support_Admin';
        
        testReq.accountGroupName = 'TestingAccountGroup';
        testReq.accountName = 'TestingAccount';
        
        
        testReq.compositeProductName = 'Connected Diagnostics';
        testReq.compositeProductSKU = '1234567-BUS';
        testReq.compositeProductGroupName = 'SES';
        testReq.compositeProductProductType = 'Bundle';
        
        testReq.componentProductName = 'CD Base-BUS';
        testReq.componentProductStatus = 'Released';
        testReq.componentProductSKU = '1301298-BUS';
        testReq.componentProductGroupName = 'SES';
        testReq.componentProductPackageName = 'Base';
        
        
        testReq.priceListName = 'TestPriceList';
        testReq.specName = 'TestName';
        
        ccrz__E_Product__c ccCompositeProduct1 = new ccrz__E_Product__c();
       
        ccCompositeProduct1.name = 'testProd1';
        ccCompositeProduct1.ccrz__ProductStatus__c = 'Released';
        ccCompositeProduct1.ccrz__Quantityperunit__c = 1;
        ccCompositeProduct1.ccrz__SKU__c = '1301298-BUS';
        ccCompositeProduct1.ccrz__StartDate__c = System.today().addMonths(-1);
        ccCompositeProduct1.ccrz__EndDate__c = System.today().addMonths(4);
        ccCompositeProduct1.Group_Name__c = 'SES';
        ccCompositeProduct1.ccrz__LongDesc__c = 'Long Description';
        ccCompositeProduct1.ccrz__ProductType__c = 'Bundle';
        ccCompositeProduct1.Product_Class_Code__c = 'SW-Web Access';
        ccCompositeProduct1.QSOL_Power_Generation__c=True;
        insert ccCompositeProduct1;
        
         
         
        TestCompletedTransactionSetUpRes transecRes = new TestCompletedTransactionSetUpRes();
                                
        transecRes = OSM_TestDataCreationUtility.createProductSetUp(testReq);
         
        ccrz__E_CartItem__c testCartItem1 = new ccrz__E_CartItem__c();
            testCartItem1.ccrz__Cart__c = transecRes.cart.id;
            testCartItem1.ccrz__Quantity__c = 100;
            testCartItem1.ccrz__OriginalQuantity__c = 100;
            testCartItem1.ccrz__Product__c =ccCompositeProduct1.id ;
            testCartItem1.ccrz__SubProdTerm__c =transecRes.objSetupDate.subProdTermList[0].id;
            testCartItem1.ccrz__Price__c = 100;
            testCartItem1.ccrz__RecurringPrice__c = 100;
            testCartItem1.ccrz__RecurringPriceSubAmt__c = 100;
            //testCartItem1.ccrz__StoreID__c = storefront;
            testCartItem1.ccrz__OriginalItemPrice__c = 100;
            testCartItem1.ccrz__DisplayProduct__c = ccCompositeProduct1.id;
            testCartItem1.ccrz__ProductType__c = 'Product';
            testCartItem1.ccrz__cartItemType__c = 'Cart';
            testCartItem1.ccrz__SubAmount__c = 100;
            testCartItem1.ccrz__Subscription_Duration__c = 12;
            testCartItem1.ccrz__Subscription_Frequency__c = 4;
            testCartItem1.ccrz__UnitOfMeasure__c = 'cm';
            testCartItem1.ccrz__StoreID__c = 'SoftwareStore';
            insert testCartItem1;
         
        System.runAs ( transecRes.objSetupDate.loggedInUser   ) {
        
        System.debug('transecRes: '+transecRes);

        //For remote action context 

        ccrz.cc_RemoteActionContext objRemotCtx = new ccrz.cc_RemoteActionContext();
        objRemotCtx.storefront='SoftwareStore';
        objRemotCtx.currentCartId=transecRes.cart.ccrz__EncryptedId__c;
        objRemotCtx.portalUserId=transecRes.objSetupDate.objUserID;
        

        ccrz.cc_CallContext.initRemoteContext(objRemotCtx);
         
        //System.debug(ccrz.cc_CallContext.currAccountId);
      //  List<ccrz__E_CartItem__c> lstCartLineItem =new List<ccrz__E_CartItem__c>();
        List<ccrz__E_CartItem__c> lstCartLineItem=new List<ccrz__E_CartItem__c>();
        lstCartLineItem.add(transecRes.cartItem);
        lstCartLineItem.add(testCartItem1);
        List<Id> lstCartId=new List<Id>();
        lstCartId.add(transecRes.cart.id);
        OSM_SW_CartLineTriggerHelper helper=new OSM_SW_CartLineTriggerHelper();
        Map<Id,ccrz__E_CartItem__c> mapCartLineItem= new Map<Id,ccrz__E_CartItem__c>();
        mapCartLineItem.put(transecRes.cartItem.id,transecRes.cartItem);
        System.debug('transecRes___'+transecRes.cartItem);
        Test.StartTest();
            OSM_SW_CartLineTriggerHelper.setPrimaryitem(lstCartLineItem);
            OSM_SW_CartLineTriggerHelper.deleteDuplicateCartLineItem(lstCartLineItem);
            helper.deleteDuplicateCartLine(transecRes.objSetupDate.compositeProduct.Id,lstCartId);
            //OSM_SW_CartLineTriggerHelper.deleteDuplicateCartLine()
             OSM_SW_CartLineTriggerHelper.deleteAddonProduct(lstCartLineItem);
            OSM_SW_CartLineTriggerHelper.updateRemoveAccountPreferredBillFre(mapCartLineItem);
            OSM_SW_CartLineTriggerHelper.updateTotalPrice(lstCartLineItem,mapCartLineItem);
           OSM_SW_CartLineTriggerHelper.deleteDuplicateCartLineItemBefore(lstCartLineItem);
           //OSM_SW_CartPg_Ctrl.callOneBMS(objRemotCtx);
            
        Test.StopTest();
        }
     }
    
    static testMethod void updateOriginalQtyTest(){
     TestProductSetupReq testReq = new TestProductSetupReq();
        testReq.permissionSetName = 'OSM_Support_Admin';
        
        testReq.accountGroupName = 'TestingAccountGroup';
        testReq.accountName = 'TestingAccount';
        
        
        testReq.compositeProductName = 'Connected Diagnostics';
        testReq.compositeProductSKU = '1234567-BUS';
        testReq.compositeProductGroupName = 'DA';
        testReq.compositeProductProductType = 'Bundle';
        
        testReq.componentProductName = 'CD Base-BUS';
        testReq.componentProductStatus = 'Released';
        testReq.componentProductSKU = '1301298-BUS';
        testReq.componentProductGroupName = 'DA';
        testReq.componentProductPackageName = 'Base';
        
        
        testReq.priceListName = 'TestPriceList';
        testReq.specName = 'TestName';
        
        
        TestCompletedTransactionSetUpRes transecRes = new TestCompletedTransactionSetUpRes();
                                
        transecRes = OSM_TestDataCreationUtility.createProductSetUp(testReq);
        
        System.runAs ( transecRes.objSetupDate.loggedInUser   ) {
        
        System.debug('transecRes: '+transecRes);

        //For remote action context 

        ccrz.cc_RemoteActionContext objRemotCtx = new ccrz.cc_RemoteActionContext();
        objRemotCtx.storefront='SoftwareStore';
        objRemotCtx.currentCartId=transecRes.cart.ccrz__EncryptedId__c;
        objRemotCtx.portalUserId=transecRes.objSetupDate.objUserID;
        

        ccrz.cc_CallContext.initRemoteContext(objRemotCtx);
         
        //System.debug(ccrz.cc_CallContext.currAccountId);
      //  List<ccrz__E_CartItem__c> lstCartLineItem =new List<ccrz__E_CartItem__c>();
        List<ccrz__E_CartItem__c> lstCartLineItem=new List<ccrz__E_CartItem__c>();
        lstCartLineItem.add(transecRes.cartItem);
        List<Id> lstCartId=new List<Id>();
        lstCartId.add(transecRes.cart.id);
        OSM_SW_CartLineTriggerHelper helper=new OSM_SW_CartLineTriggerHelper();
        Map<Id,ccrz__E_CartItem__c> mapCartLineItem= new Map<Id,ccrz__E_CartItem__c>();
        mapCartLineItem.put(transecRes.cartItem.id,transecRes.cartItem);
        Test.StartTest();
            for(Id lineId : mapCartLineItem.keySet())
            {
               ccrz__E_CartItem__c line =  mapCartLineItem.get(lineId);
                line.ccrz__PricingType__c ='external';
                line.ccrz__OriginalQuantity__c=13;
                //line.ccrz__DisplayProduct__c = 'Connected Diagnostics';
                line.ccrz__Price__c=500;
            }
            update mapCartLineItem.values();
        Test.StopTest();
        }
     }
 static testMethod void setPrimaryitem_Test5(){    
       Account testaccount = new Account();
            testAccount.Name = 'testacc';
            testAccount.BillingStreet = 'Street';
            testAccount.BillingCity = 'City';
            testAccount.BillingCountry = 'United States';
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
                AccountId = testAccount.Id, Username__c = 'testusernameunik1@gmail.com',
                Email = System.now().millisecond() + 'test@test.com'
            );
            insert contact1;
            ccrz__E_Product__c prod = new ccrz__E_Product__c();
            prod.name = 'Connected Advisor';
            prod.ccrz__SKU__c = '15458776';
            prod.ccrz__Quantityperunit__c = 3343;
            prod.ccrz__StartDate__c = system.today();
            prod.ccrz__EndDate__c = system.today() + 1;
            prod.ccrz__ShortDesc__c = 'testing';
            prod.Group_Name__c = 'SES';
            prod.QSOL_Power_Generation__c=True;
            insert prod;
            
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

            // List<ccrz__E_Cart__c> lstECart = new List<ccrz__E_Cart__c>();       
            ccrz__E_Cart__c testCart = new ccrz__E_Cart__c();
            testCart.ccrz__Storefront__c = 'Software';
            testCart.ccrz__CartType__c = 'Cart';
            testCart.ccrz__ActiveCart__c = true;
            testCart.ccrz__CartStatus__c = 'Open';
            testCart.ccrz__User__c = UserInfo.getUserId();
            testCart.ccrz__EncryptedId__c = 'encrypt';
            testCart.ccrz__BillTo__c = objAddress.Id;
            testCart.ccrz__ShipTo__c = objAddress.Id;
            testCart.ccrz__TaxAmount__c = 12;
            testCart.ccrz__Account__c=testAccount.Id;
            testCart.Is_Vertax_Tax_calculation_Failed__c = false;
            testCart.OSM_SW_Is_third_Party_BMS_Payment__c=true;
            
            testCart.ccrz__EncryptedId__c = '31f2c7a5-9977-49ae-bfd8-40038e681111';
            insert testCart;
            //insert lstECart;

            ccrz__E_CartItem__c testCartItem = new ccrz__E_CartItem__c();
            testCartItem.ccrz__Cart__c = testCart.id;
            testCartItem.ccrz__Quantity__c = 10;
            testCartItem.ccrz__OriginalQuantity__c = 11;
            testCartItem.ccrz__Product__c = prod.id;
            //testCartItem.ccrz__SubProdTerm__c =testSubProdTerm.id;
            testCartItem.ccrz__Price__c = 15;
            testCartItem.ccrz__RecurringPrice__c = 25;
            testCartItem.ccrz__RecurringPriceSubAmt__c = 12;
            testCartItem.ccrz__StoreID__c = 'SoftwareStore';
            testCartItem.ccrz__OriginalItemPrice__c = 100;
            testCartItem.ccrz__DisplayProduct__c = prod.Id;
            testCartItem.ccrz__ProductType__c = 'Product';
            testCartItem.ccrz__cartItemType__c = 'Major';
            testCartItem.ccrz__SubAmount__c = 10;
            testCartItem.ccrz__Subscription_Duration__c = 12;
            testCartItem.ccrz__Subscription_Frequency__c = 4;
            testCartItem.ccrz__UnitOfMeasure__c = 'EA';
            testCartItem.Vertex_tax__c = null;
            testCartItem.OSM_Renew_Subscription_Start_Date__c=system.today();
            testCartItem.OSM_Renew_Subscription_End_Date__c=system.today() + 1;
            
            insert testCartItem;
            
            List<ccrz__E_CartItem__c> ci= new List<ccrz__E_CartItem__c>();
            ci.add(testCartItem);
            Map<Id,ccrz__E_CartItem__c> mapCartLineItem= new Map<Id,ccrz__E_CartItem__c>();
        mapCartLineItem.put(testCartItem.id,testCartItem);
        OSM_SW_CartLineTriggerHelper.updateRemoveAccountPreferredBillFre(mapCartLineItem);
        OSM_SW_CartLineTriggerHelper.deleteDuplicateCartLineItem(ci);
}

static testMethod void setPrimaryitem_Test6(){    
       Account testaccount = new Account();
            testAccount.Name = 'testacc';
            testAccount.BillingStreet = 'Street';
            testAccount.BillingCity = 'City';
            testAccount.BillingCountry = 'United States';
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
            
            ccrz__E_Product__c prod = new ccrz__E_Product__c();
            prod.name = 'Connected Advisor';
            prod.ccrz__SKU__c = '15458776';
            prod.ccrz__Quantityperunit__c = 3343;
            prod.ccrz__StartDate__c = system.today();
            prod.ccrz__EndDate__c = system.today() + 1;
            prod.ccrz__ShortDesc__c = 'testing';
            prod.Group_Name__c = 'SES';
            prod.QSOL_Power_Generation__c=True;
           
            prod.ccrz__ProductType__c= 'Bundle';
            insert prod;
           
            ccrz__E_Product__c prod1 = new ccrz__E_Product__c();          
            prod1.Group_Name__c = 'SES';           
            prod1.ccrz__ProductType__c= 'Bundle';
            prod1.ccrz__SKU__c = '1234567-BUS';
            insert prod1;

            // List<ccrz__E_Cart__c> lstECart = new List<ccrz__E_Cart__c>();       
            ccrz__E_Cart__c testCart = new ccrz__E_Cart__c();
            testCart.ccrz__Storefront__c = 'SoftwareStore';
            testCart.ccrz__CartType__c = 'Cart';
            testCart.ccrz__ActiveCart__c = true;
            testCart.ccrz__CartStatus__c = 'Open';           
            testCart.ccrz__EncryptedId__c = '31f2c7a5-9977-49ae-bfd8-40038e681111';
            insert testCart;
            //insert lstECart;

            ccrz__E_CartItem__c testCartItem = new ccrz__E_CartItem__c();
            testCartItem.ccrz__Cart__c = testCart.id;
            testCartItem.ccrz__Quantity__c = 10;
            testCartItem.ccrz__OriginalQuantity__c = 11;
            testCartItem.ccrz__Product__c = prod.id;
            testCartItem.ccrz__ParentCartItem__c= null;
            //testCartItem.ccrz__SubProdTerm__c =testSubProdTerm.id;
            testCartItem.ccrz__Price__c = 15;
            testCartItem.ccrz__RecurringPrice__c = 25;
            testCartItem.ccrz__RecurringPriceSubAmt__c = 12;
            testCartItem.ccrz__StoreID__c = 'SoftwareStore';
            testCartItem.ccrz__OriginalItemPrice__c = 100;
           testCartItem.ccrz__DisplayProduct__c = prod1.Id;
            testCartItem.ccrz__ProductType__c = 'Product';
            testCartItem.ccrz__cartItemType__c = 'Major';
            testCartItem.ccrz__SubAmount__c = 10;
            testCartItem.ccrz__Subscription_Duration__c = 12;
             testCartItem.ccrz__Subscription_Frequency__c = 4;
            testCartItem.ccrz__UnitOfMeasure__c = 'EA';
            testCartItem.Vertex_tax__c = null;
            testCartItem.OSM_Renew_Subscription_Start_Date__c=system.today();
            testCartItem.OSM_Renew_Subscription_End_Date__c=system.today() + 1;
            
            insert testCartItem;
            List<ccrz__E_CartItem__c> ci= new List<ccrz__E_CartItem__c>();
            ci.add(testCartItem);
        
       OSM_SW_CartLineTriggerHelper.updatedAddOnFieldOnCartLineItemBefore(ci);
}


/*static testMethod void setPrimaryitem_Test7(){    
       Account testaccount = new Account();
            testAccount.Name = 'testacc';
            testAccount.BillingStreet = 'Street';
            testAccount.BillingCity = 'City';
            testAccount.BillingCountry = 'United States';
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
                AccountId = testAccount.Id, Username__c = 'testusernameunik1@gmail.com',
                Email = System.now().millisecond() + 'test@test.com'
            );
            insert contact1;
            ccrz__E_Product__c prod = new ccrz__E_Product__c();
            prod.name = 'Connected Advisor';
            prod.ccrz__SKU__c = '15458776';
            prod.ccrz__Quantityperunit__c = 3343;
            prod.ccrz__StartDate__c = system.today();
            prod.ccrz__EndDate__c = system.today() + 1;
            prod.ccrz__ShortDesc__c = 'testing';
            prod.Group_Name__c = 'DA';
            prod.QSOL_Power_Generation__c=True;
            prod.ccrz__ProductType__c= 'Bundle';
            insert prod;
            
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

            // List<ccrz__E_Cart__c> lstECart = new List<ccrz__E_Cart__c>();       
            ccrz__E_Cart__c testCart = new ccrz__E_Cart__c();
            testCart.ccrz__Storefront__c = 'Software';
            testCart.ccrz__CartType__c = 'Cart';
            testCart.ccrz__ActiveCart__c = true;
            testCart.ccrz__CartStatus__c = 'Open';
            testCart.ccrz__User__c = UserInfo.getUserId();
            testCart.ccrz__EncryptedId__c = 'encrypt';
            testCart.ccrz__BillTo__c = objAddress.Id;
            testCart.ccrz__ShipTo__c = objAddress.Id;
            testCart.ccrz__TaxAmount__c = 12;
            testCart.ccrz__Account__c=testAccount.Id;
            testCart.Is_Vertax_Tax_calculation_Failed__c = false;
            testCart.OSM_SW_Is_third_Party_BMS_Payment__c=true;
            
            testCart.ccrz__EncryptedId__c = '31f2c7a5-9977-49ae-bfd8-40038e681111';
            insert testCart;
            //insert lstECart;

            ccrz__E_CartItem__c testCartItem = new ccrz__E_CartItem__c();
            testCartItem.ccrz__Cart__c = testCart.id;
            testCartItem.ccrz__Quantity__c = 10;
            testCartItem.ccrz__OriginalQuantity__c = 11;
            testCartItem.ccrz__Product__c = prod.id;
            testCartItem.ccrz__ParentCartItem__c= null;
            //testCartItem.ccrz__SubProdTerm__c =testSubProdTerm.id;
            testCartItem.ccrz__Price__c = 15;
            testCartItem.ccrz__RecurringPrice__c = 25;
            testCartItem.ccrz__RecurringPriceSubAmt__c = 12;
            testCartItem.ccrz__StoreID__c = 'SoftwareStore';
            testCartItem.ccrz__OriginalItemPrice__c = 100;
            testCartItem.ccrz__DisplayProduct__c = prod.Id;
            testCartItem.ccrz__ProductType__c = 'Product';
            testCartItem.ccrz__cartItemType__c = 'Major';
            testCartItem.ccrz__SubAmount__c = 10;
            testCartItem.ccrz__Subscription_Duration__c = 12;
            testCartItem.ccrz__Subscription_Frequency__c = 4;
            testCartItem.ccrz__UnitOfMeasure__c = 'EA';
            testCartItem.Vertex_tax__c = null;
            testCartItem.OSM_Renew_Subscription_Start_Date__c=system.today();
            testCartItem.OSM_Renew_Subscription_End_Date__c=system.today() + 1;
            
            insert testCartItem;
            
            List<ccrz__E_CartItem__c> ci= new List<ccrz__E_CartItem__c>();
            ci.add(testCartItem);
            
           // Map<Id,ccrz__E_CartItem__c> mapCartLineItem= new Map<Id,ccrz__E_CartItem__c>();
        //mapCartLineItem.put(testCartItem.id,testCartItem);
        //OSM_SW_CartLineTriggerHelper.updateRemoveAccountPreferredBillFre(mapCartLineItem);
        OSM_SW_CartLineTriggerHelper.deleteDuplicateCartLineItem(ci);
       //OSM_SW_CartLineTriggerHelper.updatedAddOnFieldOnCartLineItemBefore(ci);
}*/
static testMethod void removeoldPowerGeneratorProductmethod(){    
       Account testaccount = new Account();
            testAccount.Name = 'testacc';
            testAccount.BillingStreet = 'Street';
            testAccount.BillingCity = 'City';
            testAccount.BillingCountry = 'United States';
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
            
            ccrz__E_Product__c prod = new ccrz__E_Product__c();
            prod.name = 'Connected Advisor';
            prod.ccrz__SKU__c = '15458776';
            prod.ccrz__Quantityperunit__c = 3343;
            prod.ccrz__StartDate__c = system.today();
            prod.ccrz__EndDate__c = system.today() + 1;
            prod.ccrz__ShortDesc__c = 'testing';
            prod.Group_Name__c = 'SES';
            prod.QSOL_Power_Generation__c=True;
           
            prod.ccrz__ProductType__c= 'Bundle';
            insert prod;
           
            ccrz__E_Product__c prod1 = new ccrz__E_Product__c();          
            prod1.Group_Name__c = 'SES';           
            prod1.ccrz__ProductType__c= 'Bundle';
            prod1.ccrz__SKU__c = '1234567-BUS';
            insert prod1;

            // List<ccrz__E_Cart__c> lstECart = new List<ccrz__E_Cart__c>();       
            ccrz__E_Cart__c testCart = new ccrz__E_Cart__c();
            testCart.ccrz__Storefront__c = 'SoftwareStore';
            testCart.ccrz__CartType__c = 'Cart';
            testCart.ccrz__ActiveCart__c = true;
            testCart.ccrz__CartStatus__c = 'Open';           
            testCart.ccrz__EncryptedId__c = '31f2c7a5-9977-49ae-bfd8-40038e681111';
            insert testCart;
            //insert lstECart;

            ccrz__E_CartItem__c testCartItem = new ccrz__E_CartItem__c();
            testCartItem.ccrz__Cart__c = testCart.id;
            testCartItem.ccrz__Quantity__c = 10;
            testCartItem.ccrz__OriginalQuantity__c = 11;
            testCartItem.ccrz__Product__c = prod.id;
            testCartItem.ccrz__ParentCartItem__c= null;
            //testCartItem.ccrz__SubProdTerm__c =testSubProdTerm.id;
            testCartItem.ccrz__Price__c = 15;
            testCartItem.ccrz__RecurringPrice__c = 25;
            testCartItem.ccrz__RecurringPriceSubAmt__c = 12;
            testCartItem.ccrz__StoreID__c = 'SoftwareStore';
            testCartItem.ccrz__OriginalItemPrice__c = 100;
           testCartItem.ccrz__DisplayProduct__c = prod1.Id;
            testCartItem.ccrz__ProductType__c = 'Product';
            testCartItem.ccrz__cartItemType__c = 'Major';
            testCartItem.ccrz__SubAmount__c = 10;
            testCartItem.ccrz__Subscription_Duration__c = 12;
             testCartItem.ccrz__Subscription_Frequency__c = 4;
            testCartItem.ccrz__UnitOfMeasure__c = 'EA';
            testCartItem.Vertex_tax__c = null;
            testCartItem.OSM_Renew_Subscription_Start_Date__c=system.today();
            testCartItem.OSM_Renew_Subscription_End_Date__c=system.today() + 1;
            
            insert testCartItem;
            List<ccrz__E_CartItem__c> ci= new List<ccrz__E_CartItem__c>();
            ci.add(testCartItem);
        
       OSM_SW_CartLineTriggerHelper.removeoldPowerGeneratorProduct(ci);
}
}