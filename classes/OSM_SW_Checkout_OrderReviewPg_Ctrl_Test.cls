@isTest
// Update Sharad Sahu 14 April 2021
// Update Sharad Sahu 14 April 2021
// Update Sharad Sahu 15 April 2021
// update Sangeeta 12th April 2021
// update Swetha 20th Jan 2022
// update Swetha 1st March 2022
// Updated on 04/04/2022
public class OSM_SW_Checkout_OrderReviewPg_Ctrl_Test {

    static testMethod void tetsMethod1() { 
        TestProductSetupReq testReq = new TestProductSetupReq();
        testReq.permissionSetName = 'OSM_Support_Admin';

        testReq.accountGroupName = 'TestingAccountGroup';
        testReq.accountName = 'TestingAccount';

        testReq.compositeProductName = 'Connected Diagnostics';
        testReq.compositeProductSKU = '123456-BUS';
        testReq.compositeProductGroupName = 'DA';
        testReq.compositeProductProductType = 'Aggregated';
        testReq.componentProductName = 'CD Base-BUS';
        testReq.componentProductStatus = 'Released';
        testReq.componentProductSKU = '130129-BUS';
        testReq.componentProductGroupName = 'DA';
        testReq.componentProductPackageName = 'Base';


        testReq.priceListName = 'TestPriceList';
        testReq.specName = 'TestName';


        TestCompletedTransactionSetUpRes transecRes = new TestCompletedTransactionSetUpRes();

        transecRes = OSM_TestDataCreationUtility.createProductSetUp(testReq);


        System.debug('transecRes: ' + transecRes);
        //transecRes.cart.ccrz__EncryptedId__c = cartIdEncrypted;
        
        ccrz__E_CartItem__c objCartLine = transecRes.cartItem;
        objCartLine.Prorated_Coupon_Discount__c = 0;
        update objCartLine;
        
        Account objAcc = new Account();
        objAcc.Id = transecRes.objSetupDate.account.Id;
        objAcc.IAM_Service_Provider_Code__c = '123456';
        
        update objAcc;
        
        System.runAs(transecRes.objSetupDate.loggedInUser) {
            test.StartTest();
            // Create RemoteActionContext Class Data 
            ccrz.cc_RemoteActionContext objRemoteClass = new ccrz.cc_RemoteActionContext();

            objRemoteClass.storefront = 'SoftwareStore';
            objRemoteClass.currentCartId = transecRes.cart.ccrz__EncryptedId__c;
            objRemoteClass.portalUserId = transecRes.objSetupDate.objUserID;
            objRemoteClass.userLocale = 'en_US';
            // Call Apex Class Methods
            try{
                
                OSM_SW_Checkout_OrderReviewPg_Ctrl.fetchCartDetails(objRemoteClass);
                
            }
            catch(Exception ex){}
            
            try{
                ccrz.ccLog.log('=====OSM_SW_Checkout_OrderReviewPg_Ctrl.checkOneBMSCreditLimit start +++'+DateTime.now().getTime());
                OSM_SW_Checkout_OrderReviewPg_Ctrl.checkOneBMSCreditLimit(objRemoteClass,true,'22876','123456');
                ccrz.ccLog.log('=====OSM_SW_Checkout_OrderReviewPg_Ctrl.checkOneBMSCreditLimit ends +++'+DateTime.now().getTime());
            }catch(Exception ex){}
            
             try{
                ccrz.ccLog.log('=====OSM_SW_Checkout_OrderReviewPg_Ctrl.postApplyCoupon start +++'+DateTime.now().getTime());
                OSM_SW_Checkout_OrderReviewPg_Ctrl.postApplyCoupon(objRemoteClass);
                ccrz.ccLog.log('=====OSM_SW_Checkout_OrderReviewPg_Ctrl.postApplyCoupon ends +++'+DateTime.now().getTime());
            }catch(Exception ex){}
            
            // Stop Test
            test.StopTest();
        }
    }

    static testMethod void tetsMethod2() {
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
test.StartTest();
         Account objAcc = new Account();
        objAcc.Id = transecRes.objSetupDate.account.Id;
        objAcc.IAM_Service_Provider_Code__c = '123456';
         
            update objAcc; 
        
        System.debug('transecRes: ' + transecRes);
        System.runAs(transecRes.objSetupDate.loggedInUser) {
            //transecRes.cart.ccrz__EncryptedId__c = cartIdEncrypted;
      //ccrz__E_AccountGroup__c  objAG = new ccrz__E_AccountGroup__c(); //Added By Dhiraj
            //objAG.Name = 'US/CAN_Other_SSOEMS_ACCGRP'; //Added By Dhiraj
            //insert objAG; //Added By Dhiraj
            //Account
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
            //testAccount.OSM_Accountgroupbatch__c=true; //Added By Dhiraj
            //testAccount.ccrz__E_AccountGroup__c = objAG.id; //Added By Dhiraj

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
            testCart.OSM_SW_IAM_Account_Id_For_Third_Party__c=testAccount.Id;
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


            //test.StartTest();
            // Create RemoteActionContext Class Data 
            ccrz.cc_RemoteActionContext objRemoteClass = new ccrz.cc_RemoteActionContext();

            objRemoteClass.storefront = 'SoftwareStore';
            objRemoteClass.currentCartId = testCart.ccrz__EncryptedId__c;
            objRemoteClass.portalUserId = transecRes.objSetupDate.objUserID;
            objRemoteClass.userLocale = 'en_US';
            objRemoteClass.effAccountId=testAccount.Id;
            
            // Call Apex Class Methods
            try{
                OSM_SW_Checkout_OrderReviewPg_Ctrl.fetchCartDetails(objRemoteClass);
            }
            catch(Exception ex){}
            
            try{
                OSM_SW_Checkout_OrderReviewPg_Ctrl.checkOneBMSCreditLimit(objRemoteClass,true,'22876','123456');
            }
            catch(Exception ex){}
            
             try{
                OSM_SW_Checkout_OrderReviewPg_Ctrl.postApplyCoupon(objRemoteClass);
                OSM_SW_Checkout_OrderReviewPg_Ctrl.updatepurchasercomments(objRemoteClass,'test comm');
            }catch(Exception ex){}
            
            // Stop Test
            test.StopTest();
        }
    }
}