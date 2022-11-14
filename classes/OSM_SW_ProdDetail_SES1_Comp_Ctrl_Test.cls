//@isTest //(SeeAllData=true)
//Test Class for the class OSM_SW_ProdDetail_SES1_Comp_Ctrl
//Test class update on 10th june
//Test class update on 22nd July - MAR-1861 Subbu K
//Test class update on 9th March

/************************************************
 History
 --------
 VERSION    AUTHOR          DATE            DETAILS
 1.0        Ashish        16/11/2021        MP-337
 1.1        Ashish        25/03/2022        MP-7107
 Subbu
 1.2		Charlynn	  09/08/2022		LL-33/LL-34/LL-35
 */
@isTest
public class OSM_SW_ProdDetail_SES1_Comp_Ctrl_Test {

    static testMethod void tetsMethod1() {

        User loggedInUser = [Select id from User where id =: UserInfo.getUserId()];
        TestProductSetupReq testReq = new TestProductSetupReq();
        testReq.permissionSetName = 'OSM_Support_Admin';
        testReq.accountGroupName = 'US/CAN_EBU_SIR_ACCGRP';
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
        ccrz__E_Product__c prod = transecRes.objSetupDate.componentList[0];
        Account a = transecRes.objSetupDate.account;
        Contact c = transecRes.objSetupDate.contact;
        Set < String > idSet = new Set < String > ();
        idSet.add(prod.id);

        System.debug('transecRes: ' + transecRes);

        // Creating Cart
       // List<ccrz__E_Cart__c> lstECart = TestingUtils.CreateCart(1, 'SoftwareStore', 'Cart', objUser.Id, true, 'Open', true);
          Id portal_PROFILE_ID = [SELECT Id FROM Profile WHERE Name = 'IAM_Site_Admin_Community' Limit 1 ].Id;
          //Id roleId=[select id,name from UserRole where name='CumminsFleetsCustomerUser' limit 1].id; 
           
         UserRole portalRole = [Select Id From UserRole Where PortalType = 'None' Limit 1];
          system.debug('portalRole is ' + portalRole);

          Profile profile1 = [Select Id from Profile where name = 'System Administrator'];
          User portalAccountOwner2 = new User(
          UserRoleId = portalRole.Id,
          ProfileId = profile1.Id,
          Username ='testproddetail'+Math.random()+'@test.com',
          Alias = 'batman',
          Email='bruce.wayne@wayneenterprises.com',
          EmailEncodingKey='UTF-8',
          Firstname='Bruce',
          Lastname='Wayne',
          LanguageLocaleKey='en_US',
          LocaleSidKey='en_US',
          TimeZoneSidKey='America/Chicago'
          );
          Database.insert(portalAccountOwner2);
          
          //creating account group..
          ccrz__E_AccountGroup__c accGrp = new ccrz__E_AccountGroup__c(
          Name = 'US/CAN_EBU_SIR_ACCGRP'
          );
          System.runAs(portalAccountOwner2){
              Database.insert(accGrp);
          }
          Account portalAccount2 = new Account(
          Name = 'TestAccount2',
          OwnerId = portalAccountOwner2.Id,
          OSM_Preferred_Billing_Frequency_Lock__c=false,
          BMS_Customer_ID__c='1234',
          OSM_Preferred_Payment_Method__c='po',
          OSM_Preferred_Payment_IsBolt_PO__c=false,
          ccrz__E_AccountGroup__c=accGrp.id
          );
          
          System.runAs(portalAccountOwner2){
              Database.insert(portalAccount2);
              //inserting custom setting...
              insert new OSM_Approval_Flow_Account_Groups__c(Account_Group_Name__c = 'US/CAN_EBU_SIR_ACCGRP0',Name='US/CAN_EBU_SIR_ACCGRP0',Product_SKU__c='123456-BUS');
              insert new OSM_Approval_Flow_Products__c(Name='Fleet Count',Product_SKU__c='123456-BUS');

          }

          //Create contact
          Contact contact1 = new Contact(
          FirstName = 'Test',
          Lastname = 'McTesty',
          IAM_Contact_Status__c='Pending',
          Username__c = 'testUserName9980@gmail.com',
          AccountId = portalAccount2.Id,
          Email ='test@test.com'
          );
          System.runAs(portalAccountOwner2){
              Database.insert(contact1);
          } 
          
          User testUser = new User();
          testUser.FirstName = 'Testttt';
          testUser.LastName = 'lasttt';
          testUser.UserName = 'testproddetail'+math.random()+'@test.com';//Updated 9/8 for prod failure
          testUser.Email = 'bruce.wayne@wayneenterprises.com';
          testUser.Alias = 'batman';
          testUser.ContactId = contact1.Id;
          testUser.CommunityNickname = 'test12345h';
          testUser.ProfileId =portal_PROFILE_ID;
          testUser.TimeZoneSidKey = 'America/Los_Angeles';
          testUser.isActive = true;
          testUser.LocaleSidKey = 'en_US';
          testUser.LanguageLocaleKey = 'en_US';
          testUser.EmailEncodingKey = 'ISO-8859-1';
            System.runAs(portalAccountOwner2){
                  insert testUser;
            
          }
           System.runAs(portalAccountOwner2) {

            PermissionSet ps = [SELECT Id FROM PermissionSet WHERE Name = 'OSM_Fleet_Admin_CC'];
            ccrz.cc_RemoteActionContext objRemotCtx = new ccrz.cc_RemoteActionContext();
            objRemotCtx.storefront = 'SoftwareStore';
            objRemotCtx.currentCartId = transecRes.cart.ccrz__EncryptedId__c;
            objRemotCtx.portalUserId = testuser.id;
            ccrz.cc_CallContext.initRemoteContext(objRemotCtx);

            ccrz__E_Spec__c spec = new ccrz__E_Spec__c();
            spec.name = 'CA Base';
            spec.imageText__c = 'test';
            spec.ccrz__Sequence__c = 500;
            insert spec;
            Set < String > childProdId = new Set < String > ();
            childProdId.add(transecRes.objSetupDate.compositeProduct.id);

            list < ccrz__E_ProductMedia__c > mlist = new list < ccrz__E_ProductMedia__c > ();
            ccrz__E_ProductMedia__c media = new ccrz__E_ProductMedia__c();
            media.ccrz__MediaType__c = 'Product Image Thumbnail';
            media.ccrz__Product__c = transecRes.objSetupDate.compositeProduct.id;
            mlist.add(media);
            insert mlist;
            
            Attachment att = new Attachment();
            att.name = 'MediaAttachment';
            att.parentId = mlist[0].id;
            att.Body = Blob.valueof('test');
            insert att;
            
            List < String > relatedProductList = new List < String > ();
            //Neha Sharma Code added here
            ccrz__E_RelatedProduct__c rp = new ccrz__E_RelatedProduct__c();
            rp.ccrz__Product__c = transecRes.objSetupDate.compositeProduct.id;
            rp.ccrz__RelatedProduct__c = transecRes.objSetupDate.compositeProduct.id;
            rp.ccrz__RelatedProductType__c = 'Accessories';
            rp.ccrz__EndDate__c = System.today() + 1;
            insert rp;
            
            relatedProductList.add(rp.id);
            ccrz__E_Subscription__c Sub = new ccrz__E_Subscription__c();
            Sub.ccrz__Sequence__c = 3;
            Sub.ccrz__Storefront__c = 'SoftwareStore';
            Sub.ccrz__SubscriptionStartDate__c = System.now().adddays(-2);
            Sub.OSM_Subscription_End_Date__c = System.now().adddays(5);
            Sub.ccrz__SubscriptionStatus__c = 'Active';
            Sub.ccrz__InstallmentLastDate__c = System.now();
            Sub.ccrz__SPT__c = transecRes.objSetupDate.subProdTermList[0].id;
            Sub.OSM_Free_Trial__c = false;
            Sub.ccrz__SubscriptionProduct__c = transecRes.objSetupDate.compositeProduct.Id;
            Sub.ccrz__RecurringPrice__c = 200;
            Sub.ccrz__OrderLastDate__c = System.now() + 10;
            Sub.ccrz__CurrencyISOCode__c = 'USD';
            Sub.ccrz__Quantity__c = 3;
            Sub.ccrz__Account__c = a.id;
            Sub.Subsequent_Next_Invoice_Due_Dt__c = System.now() + 15;
            Sub.Subsequent_Next_Invoice_Generation_Dt__c = System.now() + 15;
            Sub.OSM_Display_Product__c = transecRes.objSetupDate.compositeProduct.id;
            Insert Sub;
            ccrz__E_CompositeProduct__c compprod = new ccrz__E_CompositeProduct__c();
            compprod.ccrz__Component__c = transecRes.objSetupDate.compositeProduct.id;
            compprod.ccrz__Composite__c = transecRes.objSetupDate.compositeProduct.id;
            insert compprod;
            String parentId = transecRes.objSetupDate.compositeProduct.id;
            String portalUserId = transecRes.objSetupDate.loggedInUser.id;
            Date relatedDate = System.Today();
            Map < String, Object > jsonMap = new Map < String, Object > ();
            jsonMap.put('parentId', parentId);
            jsonMap.put('portalUserId', portalUserId);
            jsonMap.put('relatedDate', relatedProductList);
            jsonMap.put('renewProd', 'SKU-123');
            String JSONReq = JSON.serialize(jsonMap);
                  
            Map < String, Object > jsonMap2 = new Map < String, Object > ();
            jsonMap2.put('customerComment', 'testing');
            jsonMap2.put('quantityTotal', '1');
            jsonMap2.put('parentId', parentId);
            jsonMap2.put('unitPrice', '2');
            String JSONReq2 = JSON.serialize(jsonMap2);
            System.debug('JSONReq____' + JSONReq2);
            Test.StartTest();
            String successResponse = '{"createWithCoterm":false,"subcQty":"1","unitPrice":2,"monthlyPrice":1,"totalPrice":"7","availableCount":"10","billingFreq":"Monthly","productSkuSelected":"130129-BUS","selectedProdSku":"130129-BUS", "prodSubscriptions":"3","plan":"Pro","rfqDescription":"testing","subProdTermId":"' + transecRes.objSetupDate.subProdTermList[0].Id + '","parentId":"' + transecRes.objSetupDate.compositeProduct.Id + '","userId":"' + transecRes.objSetupDate.objUserID + '","isBundle":' + true + ',"isSubscribed":' + false + ',"relatedProd_selectedProdId":{"a2k3C000000HgVwQAK":[{"sfdcName":"Service Tech Kit 1","price":"3","qtyPerUnit":2,"addOnProPrice":0,"shortDesc":"Guidanz Mobile - 2 UsersINSITE™ Lite - 1 License","productId":"a2k3C000000LskAQAS","productSku":"CG-Lite-004-1","currencySymbol":"$ ","relProdSPT":"a3F3C000000RIO4UAO"}]}}';
            OSM_SW_ProdDetail_SES1_Comp_Ctrl.ProductSpecificationHeader pod = new OSM_SW_ProdDetail_SES1_Comp_Ctrl.ProductSpecificationHeader();
            pod.Id = 'test';
            pod.Value='test'; 
            OSM_SW_ProdDetail_SES1_Comp_Ctrl.ProductDetailWrapper pod1 = new OSM_SW_ProdDetail_SES1_Comp_Ctrl.ProductDetailWrapper();
            pod1.productName = 'test';
            pod1.pricePerLabel='test';
            pod1.pricePerValue = 11;
            pod1.prodSubscriptionPriceMonthly=11;
            pod1.prodSubscriptionPriceYearly = 11;
            pod1.subscriptionLength=new Map<String,Integer>();
            pod1.subscriptionBillingfrequency=new Map<String,Integer>();
            
            OSM_SW_ProdDetail_SES1_Comp_Ctrl.UserDetail pod11 = new OSM_SW_ProdDetail_SES1_Comp_Ctrl.UserDetail();
            pod11.fName = 'test';
            pod11.lName='test';
            pod11.email = 'test';
            pod11.phone='test';
            pod11.strAddress = 'test';
            pod11.company='test';
            pod11.contactId='test';
            pod11.requestedDate='test';
            // Call Apex Class Methods
             OSM_SW_ProdDetail_SES1_Comp_Ctrl.WarningMsg(objRemotCtx, '123456-BUS');
            OSM_SW_ProdDetail_SES1_Comp_Ctrl.submitRequestForApproval(objRemotCtx, JSONReq2);
            OSM_SW_ProdDetail_SES1_Comp_Ctrl.accountIdTest = transecRes.objSetupDate.account.Id;
            OSM_SW_ProdDetail_SES1_Comp_Ctrl.fetchProdDetailInfoForDA(objRemotCtx, JSONReq);
            OSM_SW_ProdDetail_SES1_Comp_Ctrl.saveCCPackageInClass(objRemotCtx, 'testccdata');
            OSM_SW_ProdDetail_SES1_Comp_Ctrl.MainWrapper mainWrp = new OSM_SW_ProdDetail_SES1_Comp_Ctrl.MainWrapper();
            OSM_SW_ProdDetail_SES1_Comp_Ctrl.SubProdTerm subProd = new OSM_SW_ProdDetail_SES1_Comp_Ctrl.SubProdTerm();
            OSM_SW_ProdDetail_SES1_Comp_Ctrl.UserDetail usrDetail = new OSM_SW_ProdDetail_SES1_Comp_Ctrl.UserDetail();
            OSM_SW_ProdDetail_SES1_Comp_Ctrl.ExistingCartItem existCart = new OSM_SW_ProdDetail_SES1_Comp_Ctrl.ExistingCartItem();
            existCart.monthlyPrice=1.01;
            OSM_SW_ProdDetail_SES1_Comp_Ctrl.AddOnProducts addOn = new OSM_SW_ProdDetail_SES1_Comp_Ctrl.AddOnProducts();
            OSM_SW_ProdDetail_SES1_Comp_Ctrl.addToCartExternal(objRemotCtx, successResponse);
            /*OSM_SW_ProdDetail_SES1_Comp_Ctrl.getUserCartItem(objRemotCtx.currentCartId, transecRes.objSetupDate.compositeProduct.id, childProdId, 'SoftwareStore', transecRes.objSetupDate.contact.id);
            OSM_SW_ProdDetail_SES1_Comp_Ctrl.createNewCart();

            OSM_SW_ProdDetail_SES1_Comp_Ctrl.getProductDetail(objRemotCtx,'15458776');
            OSM_SW_ProdDetail_SES1_Comp_Ctrl.FreeTrialDetails freeTrial=new OSM_SW_ProdDetail_SES1_Comp_Ctrl.FreeTrialDetails();
            freeTrial.maximumQty=0;
            freeTrial.freeDays=0;
            freeTrial.productId='';
            OSM_SW_ProdDetail_SES1_Comp_Ctrl.mediaWrapper mediaWrap=new OSM_SW_ProdDetail_SES1_Comp_Ctrl.mediaWrapper();
            mediaWrap.mediaName='testmedia';
            mediaWrap.sourceType='osm';
            mediaWrap.uri='https://test.com';
            
           OSM_SW_ProdDetail_SES1_Comp_Ctrl.ProductDetailsModel prodDetailModel=new OSM_SW_ProdDetail_SES1_Comp_Ctrl.ProductDetailsModel();
            prodDetailModel.objmediaWrpr=mediaWrap;*/
            test.StopTest();
        }
    }
    static testMethod void tetsMethod1_New() {

        User loggedInUser = [Select id from User where id =: UserInfo.getUserId()];
        TestProductSetupReq testReq = new TestProductSetupReq();
        testReq.permissionSetName = 'OSM_Support_Admin';
        testReq.accountGroupName = 'US/CAN_EBU_SIR_ACCGRP';
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
        ccrz__E_Product__c prod = transecRes.objSetupDate.componentList[0];
        Account a = transecRes.objSetupDate.account;
        Contact c = transecRes.objSetupDate.contact;
        Set < String > idSet = new Set < String > ();
        idSet.add(prod.id);

        System.debug('transecRes: ' + transecRes);

        // Create E Cart
        //List<ccrz__E_Cart__c> lstECart = TestingUtils.CreateCart(1, 'SoftwareStore', 'Cart', objUser.Id, true, 'Open', true);
          Id portal_PROFILE_ID = [SELECT Id FROM Profile WHERE Name = 'IAM_Site_Admin_Community' Limit 1 ].Id;
          //Id roleId=[select id,name from UserRole where name='CumminsFleetsCustomerUser' limit 1].id; 
           
         UserRole portalRole = [Select Id From UserRole Where PortalType = 'None' Limit 1];
          system.debug('portalRole is ' + portalRole);

          Profile profile1 = [Select Id from Profile where name = 'System Administrator'];
          User portalAccountOwner2 = new User(
          UserRoleId = portalRole.Id,
          ProfileId = profile1.Id,
          Username ='testproddetail'+Math.random()+'@test.com',
          Alias = 'batman',
          Email='bruce.wayne@wayneenterprises.com',
          EmailEncodingKey='UTF-8',
          Firstname='Bruce',
          Lastname='Wayne',
          LanguageLocaleKey='en_US',
          LocaleSidKey='en_US',
          TimeZoneSidKey='America/Chicago'
          );
          Database.insert(portalAccountOwner2);
          
          //creating account group..
          ccrz__E_AccountGroup__c accGrp = new ccrz__E_AccountGroup__c(
          Name = 'US/CAN_EBU_SIR_ACCGRP'
          );
          System.runAs(portalAccountOwner2){
              Database.insert(accGrp);
          }
          Account portalAccount2 = new Account(
          Name = 'TestAccount2',
          OwnerId = portalAccountOwner2.Id,
          OSM_Preferred_Billing_Frequency_Lock__c=false,
          BMS_Customer_ID__c='1234',
          OSM_Preferred_Payment_Method__c='po',
          OSM_Preferred_Payment_IsBolt_PO__c=false,
          ccrz__E_AccountGroup__c=accGrp.id
          );
          
          System.runAs(portalAccountOwner2){
              Database.insert(portalAccount2);
              //inserting custom setting...
              insert new OSM_Approval_Flow_Account_Groups__c(Account_Group_Name__c = 'US/CAN_EBU_SIR_ACCGRP0',Name='US/CAN_EBU_SIR_ACCGRP0',Product_SKU__c='123456-BUS');
              insert new OSM_Approval_Flow_Products__c(Name='Fleet Count',Product_SKU__c='123456-BUS');

          }

          //Create contact
          Contact contact1 = new Contact(
          FirstName = 'Test',
          Lastname = 'McTesty',
          IAM_Contact_Status__c='Pending',
          Username__c = 'testUserName9980@gmail.com',
          AccountId = portalAccount2.Id,
          Email ='test@test.com'
          );
          System.runAs(portalAccountOwner2){
              Database.insert(contact1);
          } 
          
          User testUser = new User();
          testUser.FirstName = 'Testttt';
          testUser.LastName = 'lasttt';
          testUser.UserName = 'testproddetail'+ math.random()+'@test.com'; //Subbu update 9/8
          testUser.Email = 'bruce.wayne@wayneenterprises.com';
          testUser.Alias = 'batman';
          testUser.ContactId = contact1.Id;
          testUser.CommunityNickname = 'test12345h';
          testUser.ProfileId =portal_PROFILE_ID;
          testUser.TimeZoneSidKey = 'America/Los_Angeles';
          testUser.isActive = true;
          testUser.LocaleSidKey = 'en_US';
          testUser.LanguageLocaleKey = 'en_US';
          testUser.EmailEncodingKey = 'ISO-8859-1';
            System.runAs(portalAccountOwner2){
                  insert testUser;
            
          }
           System.runAs(portalAccountOwner2) {

            PermissionSet ps = [SELECT Id FROM PermissionSet WHERE Name = 'OSM_Fleet_Admin_CC'];
            ccrz.cc_RemoteActionContext objRemotCtx = new ccrz.cc_RemoteActionContext();
            objRemotCtx.storefront = 'SoftwareStore';
            objRemotCtx.currentCartId = transecRes.cart.ccrz__EncryptedId__c;
            objRemotCtx.portalUserId = testuser.id;
            ccrz.cc_CallContext.initRemoteContext(objRemotCtx);

            ccrz__E_Spec__c spec = new ccrz__E_Spec__c();
            spec.name = 'CA Base';
            spec.imageText__c = 'test';
            spec.ccrz__Sequence__c = 500;
            insert spec;
            Set < String > childProdId = new Set < String > ();
            childProdId.add(transecRes.objSetupDate.compositeProduct.id);

            list < ccrz__E_ProductMedia__c > mlist = new list < ccrz__E_ProductMedia__c > ();
            ccrz__E_ProductMedia__c media = new ccrz__E_ProductMedia__c();
            media.ccrz__MediaType__c = 'Product Image Thumbnail';
            media.ccrz__Product__c = transecRes.objSetupDate.compositeProduct.id;
            mlist.add(media);
            insert mlist;
            
            Attachment att = new Attachment();
            att.name = 'MediaAttachment';
            att.parentId = mlist[0].id;
            att.Body = Blob.valueof('test');
            insert att;
            
            List < String > relatedProductList = new List < String > ();
            //Neha Sharma Code added here
            ccrz__E_RelatedProduct__c rp = new ccrz__E_RelatedProduct__c();
            rp.ccrz__Product__c = transecRes.objSetupDate.compositeProduct.id;
            rp.ccrz__RelatedProduct__c = transecRes.objSetupDate.compositeProduct.id;
            rp.ccrz__RelatedProductType__c = 'Accessories';
            rp.ccrz__EndDate__c = System.today() + 1;
            insert rp;
            
            relatedProductList.add(rp.id);
            ccrz__E_Subscription__c Sub = new ccrz__E_Subscription__c();
            Sub.ccrz__Sequence__c = 3;
            Sub.ccrz__Storefront__c = 'SoftwareStore';
            Sub.ccrz__SubscriptionStartDate__c = System.now().adddays(-2);
            Sub.OSM_Subscription_End_Date__c = System.now().adddays(5);
            Sub.ccrz__SubscriptionStatus__c = 'Active';
            Sub.ccrz__InstallmentLastDate__c = System.now();
            Sub.ccrz__SPT__c = transecRes.objSetupDate.subProdTermList[0].id;
            Sub.OSM_Free_Trial__c = false;
            Sub.ccrz__SubscriptionProduct__c = transecRes.objSetupDate.compositeProduct.Id;
            Sub.ccrz__RecurringPrice__c = 200;
            Sub.ccrz__OrderLastDate__c = System.now() + 10;
            Sub.ccrz__CurrencyISOCode__c = 'USD';
            Sub.ccrz__Quantity__c = 3;
            Sub.ccrz__Account__c = a.id;
            Sub.Subsequent_Next_Invoice_Due_Dt__c = System.now() + 15;
            Sub.Subsequent_Next_Invoice_Generation_Dt__c = System.now() + 15;
            Sub.OSM_Display_Product__c = transecRes.objSetupDate.compositeProduct.id;
            Insert Sub;
            ccrz__E_CompositeProduct__c compprod = new ccrz__E_CompositeProduct__c();
            compprod.ccrz__Component__c = transecRes.objSetupDate.compositeProduct.id;
            compprod.ccrz__Composite__c = transecRes.objSetupDate.compositeProduct.id;
            insert compprod;
            String parentId = transecRes.objSetupDate.compositeProduct.id;
            String portalUserId = transecRes.objSetupDate.loggedInUser.id;
            Date relatedDate = System.Today();
            Map < String, Object > jsonMap = new Map < String, Object > ();
            jsonMap.put('parentId', parentId);
            jsonMap.put('portalUserId', portalUserId);
            jsonMap.put('relatedDate', relatedProductList);
            String JSONReq = JSON.serialize(jsonMap);
               
            Map < String, Object > jsonMap2 = new Map < String, Object > ();
            jsonMap2.put('customerComment', 'testing');
            jsonMap2.put('quantityTotal', '1');
            jsonMap2.put('parentId', parentId);
            jsonMap2.put('unitPrice', '2');
            String JSONReq2 = JSON.serialize(jsonMap2);
            System.debug('JSONReq____' + JSONReq2);
            Test.StartTest();
            /*String successResponse = '{"subcQty":"1","unitPrice":2,"monthlyPrice":1,"totalPrice":"7","availableCount":"10","billingFreq":"Monthly","productSkuSelected":"130129-BUS","selectedProdSku":"130129-BUS", "prodSubscriptions":"3","plan":"Pro","rfqDescription":"testing","subProdTermId":"' + transecRes.objSetupDate.subProdTermList[0].Id + '","parentId":"' + transecRes.objSetupDate.compositeProduct.Id + '","userId":"' + transecRes.objSetupDate.objUserID + '","isBundle":' + true + ',"isSubscribed":' + false + ',"relatedProd_selectedProdId":{"a2k3C000000HgVwQAK":[{"sfdcName":"Service Tech Kit 1","price":"3","qtyPerUnit":2,"addOnProPrice":0,"shortDesc":"Guidanz Mobile - 2 UsersINSITE™ Lite - 1 License","productId":"a2k3C000000LskAQAS","productSku":"CG-Lite-004-1","currencySymbol":"$ ","relProdSPT":"a3F3C000000RIO4UAO"}]}}';
            OSM_SW_ProdDetail_SES1_Comp_Ctrl.ProductSpecificationHeader pod = new OSM_SW_ProdDetail_SES1_Comp_Ctrl.ProductSpecificationHeader();
            pod.Id = 'test';
            pod.Value='test';
            OSM_SW_ProdDetail_SES1_Comp_Ctrl.ProductDetailWrapper pod1 = new OSM_SW_ProdDetail_SES1_Comp_Ctrl.ProductDetailWrapper();
            pod1.productName = 'test';
            pod1.pricePerLabel='test';
            pod1.pricePerValue = 11;
            pod1.prodSubscriptionPriceMonthly=11;
            pod1.prodSubscriptionPriceYearly = 11;
            pod1.subscriptionLength=new Map<String,Integer>();
            pod1.subscriptionBillingfrequency=new Map<String,Integer>();
            
            OSM_SW_ProdDetail_SES1_Comp_Ctrl.UserDetail pod11 = new OSM_SW_ProdDetail_SES1_Comp_Ctrl.UserDetail();
            pod11.fName = 'test';
            pod11.lName='test';
            pod11.email = 'test';
            pod11.phone='test';
            pod11.strAddress = 'test';
            pod11.company='test';
            pod11.contactId='test';
            pod11.requestedDate='test';
            // Call Apex Class Methods
              OSM_SW_ProdDetail_SES1_Comp_Ctrl.WarningMsg(objRemotCtx, '123456-BUS');
            OSM_SW_ProdDetail_SES1_Comp_Ctrl.submitRequestForApproval(objRemotCtx, JSONReq2);
            OSM_SW_ProdDetail_SES1_Comp_Ctrl.accountIdTest = transecRes.objSetupDate.account.Id;
            OSM_SW_ProdDetail_SES1_Comp_Ctrl.fetchProdDetailInfoForDA(objRemotCtx, JSONReq);
             OSM_SW_ProdDetail_SES1_Comp_Ctrl.saveCCPackageInClass(objRemotCtx, 'testccdata');
            OSM_SW_ProdDetail_SES1_Comp_Ctrl.MainWrapper mainWrp = new OSM_SW_ProdDetail_SES1_Comp_Ctrl.MainWrapper();
            OSM_SW_ProdDetail_SES1_Comp_Ctrl.SubProdTerm subProd = new OSM_SW_ProdDetail_SES1_Comp_Ctrl.SubProdTerm();
            OSM_SW_ProdDetail_SES1_Comp_Ctrl.UserDetail usrDetail = new OSM_SW_ProdDetail_SES1_Comp_Ctrl.UserDetail();
            OSM_SW_ProdDetail_SES1_Comp_Ctrl.ExistingCartItem existCart = new OSM_SW_ProdDetail_SES1_Comp_Ctrl.ExistingCartItem();
            OSM_SW_ProdDetail_SES1_Comp_Ctrl.AddOnProducts addOn = new OSM_SW_ProdDetail_SES1_Comp_Ctrl.AddOnProducts();
            OSM_SW_ProdDetail_SES1_Comp_Ctrl.addToCartExternal(objRemotCtx, successResponse);
            OSM_SW_ProdDetail_SES1_Comp_Ctrl.getUserCartItem(objRemotCtx.currentCartId, transecRes.objSetupDate.compositeProduct.id, childProdId, 'SoftwareStore', transecRes.objSetupDate.contact.id);
            OSM_SW_ProdDetail_SES1_Comp_Ctrl.createNewCart();*/

            OSM_SW_ProdDetail_SES1_Comp_Ctrl.getProductDetail(objRemotCtx,'15458776');
            OSM_SW_ProdDetail_SES1_Comp_Ctrl.FreeTrialDetails freeTrial=new OSM_SW_ProdDetail_SES1_Comp_Ctrl.FreeTrialDetails();
            freeTrial.maximumQty=0;
            freeTrial.freeDays=0;
            freeTrial.productId='';
            OSM_SW_ProdDetail_SES1_Comp_Ctrl.mediaWrapper mediaWrap=new OSM_SW_ProdDetail_SES1_Comp_Ctrl.mediaWrapper();
            mediaWrap.mediaName='testmedia';
            mediaWrap.sourceType='osm';
            mediaWrap.uri='https://test.com';
            
           OSM_SW_ProdDetail_SES1_Comp_Ctrl.ProductDetailsModel prodDetailModel=new OSM_SW_ProdDetail_SES1_Comp_Ctrl.ProductDetailsModel();
            prodDetailModel.objmediaWrpr=mediaWrap;
            test.StopTest();
        }
    }
    static testMethod void tetsMethod5() {

        User loggedInUser = [Select id from User where id =: UserInfo.getUserId()];
        TestProductSetupReq testReq = new TestProductSetupReq();
        testReq.permissionSetName = 'OSM_Support_Admin';
        testReq.accountGroupName = 'US/CAN_EBU_SIR_ACCGRP';
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
        ccrz__E_Product__c prod = transecRes.objSetupDate.componentList[0];
        Account a = transecRes.objSetupDate.account;
        Contact c = transecRes.objSetupDate.contact;
        Set < String > idSet = new Set < String > ();
        idSet.add(prod.id);

        System.debug('transecRes: ' + transecRes);

        // Create E Cart
        //List<ccrz__E_Cart__c> lstECart = TestingUtils.CreateCart(1, 'SoftwareStore', 'Cart', objUser.Id, true, 'Open', true);
          Id portal_PROFILE_ID = [SELECT Id FROM Profile WHERE Name = 'IAM_Site_Admin_Community' Limit 1 ].Id;
          //Id roleId=[select id,name from UserRole where name='CumminsFleetsCustomerUser' limit 1].id; 
           
         UserRole portalRole = [Select Id From UserRole Where PortalType = 'None' Limit 1];
          system.debug('portalRole is ' + portalRole);

          Profile profile1 = [Select Id from Profile where name = 'System Administrator'];
          User portalAccountOwner2 = new User(
          UserRoleId = portalRole.Id,
          ProfileId = profile1.Id,
          Username ='testproddetail'+Math.random()+'@test.com',
          Alias = 'batman',
          Email='bruce.wayne@wayneenterprises.com',
          EmailEncodingKey='UTF-8',
          Firstname='Bruce',
          Lastname='Wayne',
          LanguageLocaleKey='en_US',
          LocaleSidKey='en_US',
          TimeZoneSidKey='America/Chicago'
          );
          Database.insert(portalAccountOwner2);
          
          //creating account group..
          ccrz__E_AccountGroup__c accGrp = new ccrz__E_AccountGroup__c(
          Name = 'US/CAN_EBU_SIR_ACCGRP'
          );
          System.runAs(portalAccountOwner2){
              Database.insert(accGrp);
          }
          Account portalAccount2 = new Account(
          Name = 'TestAccount2',
          OwnerId = portalAccountOwner2.Id,
          OSM_Preferred_Billing_Frequency_Lock__c=false,
          BMS_Customer_ID__c='1234',
          OSM_Preferred_Payment_Method__c='po',
          OSM_Preferred_Payment_IsBolt_PO__c=false,
          ccrz__E_AccountGroup__c=accGrp.id
          );
          
          System.runAs(portalAccountOwner2){
              Database.insert(portalAccount2);
              //inserting custom setting...
              insert new OSM_Approval_Flow_Account_Groups__c(Account_Group_Name__c = 'US/CAN_EBU_SIR_ACCGRP0',Name='US/CAN_EBU_SIR_ACCGRP0',Product_SKU__c='123456-BUS');
              insert new OSM_Approval_Flow_Products__c(Name='Fleet Count',Product_SKU__c='123456-BUS');

          }

          //Create contact
          Contact contact1 = new Contact(
          FirstName = 'Test',
          Lastname = 'McTesty',
          IAM_Contact_Status__c='Pending',
          Username__c = 'testUserName9980@gmail.com',
          AccountId = portalAccount2.Id,
          Email ='test@test.com'
          );
          System.runAs(portalAccountOwner2){
              Database.insert(contact1);
          } 
          
          User testUser = new User();
          testUser.FirstName = 'Testttt';
          testUser.LastName = 'lasttt';
          testUser.UserName = 'testproddetail'+ Math.random() +'@test.com';//Subbu update 9/8 
          testUser.Email = 'bruce.wayne@wayneenterprises.com';
          testUser.Alias = 'batman';
          testUser.ContactId = contact1.Id;
          testUser.CommunityNickname = 'test12345h';
          testUser.ProfileId =portal_PROFILE_ID;
          testUser.TimeZoneSidKey = 'America/Los_Angeles';
          testUser.isActive = true;
          testUser.LocaleSidKey = 'en_US';
          testUser.LanguageLocaleKey = 'en_US';
          testUser.EmailEncodingKey = 'ISO-8859-1';
            System.runAs(portalAccountOwner2){
                  insert testUser;
            
          }
           System.runAs(portalAccountOwner2) {

            PermissionSet ps = [SELECT Id FROM PermissionSet WHERE Name = 'OSM_Fleet_Admin_CC'];
            ccrz.cc_RemoteActionContext objRemotCtx = new ccrz.cc_RemoteActionContext();
            objRemotCtx.storefront = 'SoftwareStore';
            objRemotCtx.currentCartId = transecRes.cart.ccrz__EncryptedId__c;
            objRemotCtx.portalUserId = testuser.id;
            ccrz.cc_CallContext.initRemoteContext(objRemotCtx);

            ccrz__E_Spec__c spec = new ccrz__E_Spec__c();
            spec.name = 'CA Base';
            spec.imageText__c = 'test';
            spec.ccrz__Sequence__c = 500;
            insert spec;
            Set < String > childProdId = new Set < String > ();
            childProdId.add(transecRes.objSetupDate.compositeProduct.id);

            list < ccrz__E_ProductMedia__c > mlist = new list < ccrz__E_ProductMedia__c > ();
            ccrz__E_ProductMedia__c media = new ccrz__E_ProductMedia__c();
            media.ccrz__MediaType__c = 'Product Image Thumbnail';
            media.ccrz__Product__c = transecRes.objSetupDate.compositeProduct.id;
            mlist.add(media);
            insert mlist;
            
            Attachment att = new Attachment();
            att.name = 'MediaAttachment';
            att.parentId = mlist[0].id;
            att.Body = Blob.valueof('test');
            insert att;
            
            List < String > relatedProductList = new List < String > ();
            //Neha Sharma Code added here
            ccrz__E_RelatedProduct__c rp = new ccrz__E_RelatedProduct__c();
            rp.ccrz__Product__c = transecRes.objSetupDate.compositeProduct.id;
            rp.ccrz__RelatedProduct__c = transecRes.objSetupDate.compositeProduct.id;
            rp.ccrz__RelatedProductType__c = 'Accessories';
            rp.ccrz__EndDate__c = System.today() + 1;
            insert rp;
            
            relatedProductList.add(rp.id);
            
            List < ccrz__E_SubProdTerm__c > subProdTermsLst = new List < ccrz__E_SubProdTerm__c > ();
            for (ccrz__E_SubProdTerm__c objSup: transecRes.objSetupDate.subProdTermList) {
                objSup.ccrz__DisplayName__c = '1 Year';
                subProdTermsLst.add(objSup);
            }
            update subProdTermsLst;
            
            ccrz__E_Subscription__c Sub = new ccrz__E_Subscription__c();
            Sub.ccrz__Sequence__c = 3;
            Sub.ccrz__Storefront__c = 'SoftwareStore';
            Sub.ccrz__SubscriptionStartDate__c = System.now().adddays(-2);
            Sub.OSM_Subscription_End_Date__c = System.now().adddays(5);
            Sub.ccrz__SubscriptionStatus__c = 'Active';
            Sub.ccrz__InstallmentLastDate__c = System.now();
            Sub.ccrz__SPT__c = transecRes.objSetupDate.subProdTermList[0].id;
            Sub.OSM_Free_Trial__c = false;
            Sub.ccrz__SubscriptionProduct__c = transecRes.objSetupDate.compositeProduct.Id;
            Sub.ccrz__RecurringPrice__c = 200;
            Sub.ccrz__OrderLastDate__c = System.now() + 10;
            Sub.ccrz__CurrencyISOCode__c = 'USD';
            Sub.ccrz__Quantity__c = 3;
            Sub.ccrz__Account__c = a.id;
            Sub.Subsequent_Next_Invoice_Due_Dt__c = System.now() + 15;
            Sub.Subsequent_Next_Invoice_Generation_Dt__c = System.now() + 15;
            Sub.OSM_Display_Product__c = transecRes.objSetupDate.compositeProduct.id;
            Insert Sub;
            ccrz__E_CompositeProduct__c compprod = new ccrz__E_CompositeProduct__c();
            compprod.ccrz__Component__c = transecRes.objSetupDate.compositeProduct.id;
            compprod.ccrz__Composite__c = transecRes.objSetupDate.compositeProduct.id;
            insert compprod;
            String parentId = transecRes.objSetupDate.compositeProduct.id;
            String portalUserId = transecRes.objSetupDate.loggedInUser.id;
            Date relatedDate = System.Today();
            Map < String, Object > jsonMap = new Map < String, Object > ();
            jsonMap.put('parentId', parentId);
            jsonMap.put('portalUserId', portalUserId);
            jsonMap.put('relatedDate', relatedProductList);
            jsonMap.put('renewProd', '');
            jsonMap.put('renewAddOn', 'Add-On');
            String JSONReq = JSON.serialize(jsonMap);

            Map < String, Object > jsonMap2 = new Map < String, Object > ();
            jsonMap2.put('customerComment', 'testing');
            jsonMap2.put('quantityTotal', '1');
            jsonMap2.put('parentId', parentId);
            jsonMap2.put('unitPrice', '2');
            String JSONReq2 = JSON.serialize(jsonMap2);
            System.debug('JSONReq____' + JSONReq2);
            Test.StartTest();
            String successResponse = '{"subcQty":"1","unitPrice":2,"monthlyPrice":1,"totalPrice":"7","availableCount":"10","billingFreq":"Monthly","productSkuSelected":"130129-BUS","selectedProdSku":"130129-BUS", "prodSubscriptions":"3","plan":"Pro","rfqDescription":"testing","subProdTermId":"' + transecRes.objSetupDate.subProdTermList[0].Id + '","parentId":"' + transecRes.objSetupDate.compositeProduct.Id + '","userId":"' + transecRes.objSetupDate.objUserID + '","isBundle":' + true + ',"isSubscribed":' + false + ',"relatedProd_selectedProdId":{"a2k3C000000HgVwQAK":[{"sfdcName":"Service Tech Kit 1","price":"3","qtyPerUnit":2,"addOnProPrice":0,"shortDesc":"Guidanz Mobile - 2 UsersINSITE™ Lite - 1 License","productId":"a2k3C000000LskAQAS","productSku":"CG-Lite-004-1","currencySymbol":"$ ","relProdSPT":"a3F3C000000RIO4UAO"}]}}';
            OSM_SW_ProdDetail_SES1_Comp_Ctrl.ProductSpecificationHeader pod = new OSM_SW_ProdDetail_SES1_Comp_Ctrl.ProductSpecificationHeader();
            pod.Id = 'test';
            pod.Value='test';
            OSM_SW_ProdDetail_SES1_Comp_Ctrl.ProductDetailWrapper pod1 = new OSM_SW_ProdDetail_SES1_Comp_Ctrl.ProductDetailWrapper();
            pod1.productName = 'test';
            pod1.pricePerLabel='test';
            pod1.pricePerValue = 11;
            pod1.prodSubscriptionPriceMonthly=11;
            pod1.prodSubscriptionPriceYearly = 11;
            pod1.subscriptionLength=new Map<String,Integer>();
            pod1.subscriptionBillingfrequency=new Map<String,Integer>();
            pod1.selectedPowerGenProduct=false;
            pod1.GOMSPartNumber='test123';
            pod1.GOMSPartDefined =false;
            
            OSM_SW_ProdDetail_SES1_Comp_Ctrl.UserDetail pod11 = new OSM_SW_ProdDetail_SES1_Comp_Ctrl.UserDetail();
            pod11.fName = 'test';
            pod11.lName='test';
            pod11.email = 'test';
            pod11.phone='test';
            pod11.strAddress = 'test';
            pod11.company='test';
            pod11.contactId='test';
            pod11.requestedDate='test';
            // Call Apex Class Methods
            ccrz__E_SubProdTerm__c prodTerm = [select id, ccrz__InstallmentFrequency__c, OSM_Bill_Freq__c, ccrz__DisplayName__c, ccrz__CCProduct__r.ccrz__SKU__c, ccrz__OrderFrequency__c, ccrz__InstallmentCount__c, Billing_Display_Name__c, ccrz__CCProduct__c from ccrz__E_SubProdTerm__c where id =: subProdTermsLst[0].id];
              //priceListTestData();
               OSM_SW_ProdDetail_SES1_Comp_Ctrl.WarningMsg(objRemotCtx, '123456-BUS');
            OSM_SW_ProdDetail_SES1_Comp_Ctrl.submitRequestForApproval(objRemotCtx, JSONReq2);
            OSM_SW_ProdDetail_SES1_Comp_Ctrl.accountIdTest = transecRes.objSetupDate.account.Id;
            OSM_SW_ProdDetail_SES1_Comp_Ctrl.fetchProdDetailInfoForDA(objRemotCtx, JSONReq);
             OSM_SW_ProdDetail_SES1_Comp_Ctrl.saveCCPackageInClass(objRemotCtx, 'testccdata');
            OSM_SW_ProdDetail_SES1_Comp_Ctrl.MainWrapper mainWrp = new OSM_SW_ProdDetail_SES1_Comp_Ctrl.MainWrapper();
            OSM_SW_ProdDetail_SES1_Comp_Ctrl.SubProdTerm subProd = new OSM_SW_ProdDetail_SES1_Comp_Ctrl.SubProdTerm();
            OSM_SW_ProdDetail_SES1_Comp_Ctrl.UserDetail usrDetail = new OSM_SW_ProdDetail_SES1_Comp_Ctrl.UserDetail();
            OSM_SW_ProdDetail_SES1_Comp_Ctrl.ExistingCartItem existCart = new OSM_SW_ProdDetail_SES1_Comp_Ctrl.ExistingCartItem();
            OSM_SW_ProdDetail_SES1_Comp_Ctrl.AddOnProducts addOn = new OSM_SW_ProdDetail_SES1_Comp_Ctrl.AddOnProducts();
            OSM_SW_ProdDetail_SES1_Comp_Ctrl.addToCartExternal(objRemotCtx, successResponse);
            OSM_SW_ProdDetail_SES1_Comp_Ctrl.getUserCartItem(objRemotCtx.currentCartId, transecRes.objSetupDate.compositeProduct.id, childProdId, 'SoftwareStore', transecRes.objSetupDate.contact.id);
           
            test.StopTest();
        }
    }
    //Product list test data
    public static List < Map < String, Object >> productListTestData() {
        List < Map < String, Object >> prodList = new List < Map < String, Object >> ();
        Map < String, Object > prodMap = new Map < String, Object > ();

        ccrz__E_Product__c prod = new ccrz__E_Product__c();
        prod.name = 'Connected Advisor';
        prod.ccrz__SKU__c = '15458776';
        prod.ccrz__Quantityperunit__c = 3343;
        prod.ccrz__StartDate__c = system.today();
        prod.ccrz__EndDate__c = system.today() + 1;
        prod.ccrz__ShortDesc__c = 'testing';

        insert prod;


        String testData = '{EProductMediasS=({attachmentsS=({"sfid":' + prod.id + '}),"enabled":true,"locale":"en_US","mediaType":"Product Search Image","product"=' + prod.id + '})}';
        prodMap.put(testData, prod);
        prodList.add(prodMap);
        return prodList;
    }

    //Price list test data
    public static Map < String, Object > priceListTestData() {
        Map < String, Object > priceMap = new Map < String, Object > ();
        Map < String, Object > pricingMap = new Map < String, Object > ();
        Map < String, Object > subProdMap = new Map < String, Object > ();

        ccrz__E_Product__c prod = new ccrz__E_Product__c();
        prod.name = 'Connected Advisor';
        prod.ccrz__SKU__c = '16458876';
        prod.ccrz__Quantityperunit__c = 3343;
        prod.ccrz__StartDate__c = system.today();
        prod.ccrz__EndDate__c = system.today() + 1;
        prod.ccrz__ShortDesc__c = 'testing';

        insert prod;

        ccrz__E_SubProdTerm__c spt = new ccrz__E_SubProdTerm__c();
        spt.Billing_Display_Name__c = 'Monthly';
        spt.ccrz__CCProduct__c = prod.id;
        spt.ccrz__EffectiveEnd__c = system.now();
        spt.ccrz__EffectiveStart__c = system.now() + 2;
        insert spt;

        //  List<ccrz__E_PriceList__c> priceList=TestingUtils.createPriceList(1,'pricetest','SoftwareStore',true,'USD',true);
        ccrz__E_PriceList__c testPriceList = new ccrz__E_PriceList__c();
        //  ccrz__E_PriceList__c testPriceList = new ccrz__E_PriceList__c();
        testPriceList.Name = 'testPrice';
        //testPriceList.ccrz__StartDate__c = System.today().addMonths(-1);
        //testPriceList.ccrz__EndDate__c = System.today().addMonths(5);
        testPriceList.ccrz__CurrencyISOCode__c = 'USD';

        testPriceList.ccrz__Enabled__c = true;

        testPriceList.ccrz__Storefront__c = 'SoftwareStore';
        insert testPriceList;
        ccrz__E_PriceListItem__c priclelistItem = new ccrz__E_PriceListItem__c();
        //priclelistItem.Name='testPriceListItem';
        priclelistItem.ccrz__SubProdTerm__c = spt.id;
        priclelistItem.ccrz__Product__c = prod.id;
        priclelistItem.ccrz__Pricelist__c = testPriceList.id;
         insert priclelistItem;


        String priceTestData = '{itemType":null, "price":120.00,"priceList":testPriceList.Id, "sfid":prod.id}';
        Map < String, Map < String, Object >> subProductDataOuterMap = new Map < String, Map < String, Object >> ();
        Map < String, Object > subProductDataInnerMap1 = new Map < String, Map < String, Object >> ();
        Map < String, Object > subProductDataInnerMap2 = new Map < String, Object > ();
        subProductDataInnerMap1.put('price', '120.00');
        subProductDataInnerMap1.put('priceList', testPriceList.id);
        subProductDataInnerMap1.put('sfid', priclelistItem.id);
        subProductDataInnerMap2.put('price', '120.00');
        subProductDataInnerMap2.put('priceList', testPriceList.id);
        subProductDataInnerMap2.put('sfid', priclelistItem.id);
        subProductDataOuterMap.put('nonRecurringPrice', subProductDataInnerMap1);
        subProductDataOuterMap.put('recurringPrice', subProductDataInnerMap2);

        Map < String, Object > subProductData = new Map < string, Object > ();
        subProductData.put(spt.id, subProductDataOuterMap);

        //String subProductData='{nonRecurringPrice={"itemType":null,"price":120.00, "priceList":testPriceList.Id, "sfid":prod.id,"upfrontPricePercentage":null},recurringPrice={"itemType":null,"price":120.00,"priceList":testPriceList.Id,"recurringPricePercentage":null,"sfid":prod.id}}';
        //pricingMap.put('productPrice',priceTestData);
        subProdMap.put('subProductTerms', subProductData);
        //priceMap.put('productPrice',pricingMap);
        //priceMap.put('subProductTerms',subProdMap);
        return subProdMap;

    }
    public static Map < Id, ccrz__E_SubProdTerm__c > subProdTermData() {
        Map < id, ccrz__E_SubProdTerm__c > prodTermMap = new Map < id, ccrz__E_SubProdTerm__c > ();
        ccrz__E_Product__c prod = new ccrz__E_Product__c();
        prod.name = 'Connected Advisor';
        prod.ccrz__SKU__c = '16458876';
        prod.ccrz__Quantityperunit__c = 3343;
        prod.ccrz__StartDate__c = system.today();
        prod.ccrz__EndDate__c = system.today() + 1;
        prod.ccrz__ShortDesc__c = 'testing';
        // prod.    
        insert prod;

        ccrz__E_SubProdTerm__c spt = new ccrz__E_SubProdTerm__c();
        spt.Billing_Display_Name__c = 'Monthly';
        spt.ccrz__CCProduct__c = prod.id;
        spt.ccrz__EffectiveEnd__c = system.now();
        spt.ccrz__EffectiveStart__c = system.now() + 2;
        spt.ccrz__InstallmentFrequency__c = 2;
        spt.ccrz__InstallmentCount__c = 3;
        spt.ccrz__OrderFrequency__c = 5;
        spt.Billing_Display_Name__c = 'One';
        spt.ccrz__DisplayName__c = 'test';

        insert spt;
        ccrz__E_SubProdTerm__c prodTerm = [select id, ccrz__InstallmentFrequency__c, OSM_Bill_Freq__c, ccrz__DisplayName__c, ccrz__CCProduct__r.ccrz__SKU__c, ccrz__OrderFrequency__c, ccrz__InstallmentCount__c, Billing_Display_Name__c, ccrz__CCProduct__c from ccrz__E_SubProdTerm__c where id =: spt.id];
        prodTermMap.put(prodTerm.id, prodTerm);

        return prodTermMap;
    }
    
    public static Map<String, Object> getTestData(){
        
        Map<String, Object> testData = new Map<String, Object>();
        List<ccrz__E_PriceListItem__c> prices = new List<ccrz__E_PriceListItem__c>();
        ccrz__E_Product__c prod = new ccrz__E_Product__c();
        prod.name = 'Connected Advisor'; 
        prod.ccrz__SKU__c = '16458876ZZ';
        prod.ccrz__Quantityperunit__c = 3343;
        prod.ccrz__StartDate__c = system.today();
        prod.ccrz__EndDate__c = system.today() + 1;
        prod.ccrz__ShortDesc__c = 'testing';

        insert prod;
        
        ccrz__E_Product__c relprod = new ccrz__E_Product__c();
        relprod.name = 'Connected Advisor'; 
        relprod.ccrz__SKU__c = '16458876ZZY';
        relprod.ccrz__Quantityperunit__c = 3343;
        relprod.ccrz__StartDate__c = system.today();
        relprod.ccrz__EndDate__c = system.today() + 1;
        relprod.ccrz__ShortDesc__c = 'testing';

        insert relprod;
         testData.put('product',prod);
        testData.put('relprod',relprod);
        ccrz__E_RelatedProduct__c rp = new ccrz__E_RelatedProduct__c();
            rp.ccrz__Product__c = prod.id;
            rp.ccrz__RelatedProduct__c = relprod.id;
            rp.ccrz__RelatedProductType__c = 'Accessories';
            rp.ccrz__EndDate__c = System.today() + 1;
            insert rp;
        testData.put('rp',rp);
        ccrz__E_SubProdTerm__c spt = new ccrz__E_SubProdTerm__c();
        spt.Billing_Display_Name__c = 'One Time';
        spt.ccrz__CCProduct__c = prod.id; 
        spt.ccrz__EffectiveEnd__c = system.now();
        spt.ccrz__EffectiveStart__c = system.now() + 2;
        insert spt;
        testData.put('spt',spt);
        //  List<ccrz__E_PriceList__c> priceList=TestingUtils.createPriceList(1,'pricetest','SoftwareStore',true,'USD',true);
        ccrz__E_PriceList__c testPriceList = new ccrz__E_PriceList__c();
        //  ccrz__E_PriceList__c testPriceList = new ccrz__E_PriceList__c();
        testPriceList.Name = 'testPrice';
        //testPriceList.ccrz__StartDate__c = System.today().addMonths(-1);
        //testPriceList.ccrz__EndDate__c = System.today().addMonths(5);
        testPriceList.ccrz__CurrencyISOCode__c = 'USD';

        testPriceList.ccrz__Enabled__c = true;

        testPriceList.ccrz__Storefront__c = 'SoftwareStore';
        insert testPriceList;
        testData.put('pl', testPriceList);
        ccrz__E_PriceListItem__c priclelistItem = new ccrz__E_PriceListItem__c();
        //priclelistItem.Name='testPriceListItem';
        priclelistItem.ccrz__SubProdTerm__c = spt.id;
        priclelistItem.ccrz__Product__c = prod.id;
        priclelistItem.ccrz__Pricelist__c = testPriceList.id;
        priclelistItem.ccrz__Price__c = 30;
        priclelistItem.Distributor_Price__c = 25;
        prices.add(priclelistItem);
        
        ccrz__E_PriceListItem__c priclelistItem1 = new ccrz__E_PriceListItem__c();
        //priclelistItem.Name='testPriceListItem';
        priclelistItem1.ccrz__SubProdTerm__c = spt.id;
        priclelistItem1.ccrz__Product__c = prod.id;
        priclelistItem1.ccrz__Pricelist__c = testPriceList.id;
        priclelistItem1.ccrz__Price__c = 40;
        priclelistItem1.Distributor_Price__c = 40;
        prices.add(priclelistItem1);
     
       insert prices;
       testData.put('pli', prices);   
         return testData;
    }
    Public ccrz__E_Subscription__c getSubscription() {

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
        // JUHI Changes - prevent hard coding of ID
        testAccount.RecordTypeId = OSM_TestDataCreationUtility.getAccountRecordTypeID();
        testAccount.OwnerId = OSM_TestDataCreationUtility.getSystemAdministratorID();

        //testAccount.RecordTypeId = '0124C000000Cimc';
        //testAccount.OwnerId = '0054C0000016Fe3';
        testAccount.CSS_Timezone__c = '(GMT+05:30) India Standard Time (Asia/Kolkata)';
        testAccount.CMI_CId__c = '390';
        insert testAccount;
        system.debug('testAccount' + testAccount);

        //CC Order
        ccrz__E_Order__c o1 = new ccrz__E_Order__c();
        o1.ccrz__Storefront__c = 'SoftwareStore';
        o1.ccrz__Account__c = testAccount.Id;
        o1.ccrz__CurrencyISOCode__c = 'USD';
        //ol.ccrz__OrderStatus__c = 'Order Submitted';
        insert o1;
        //AccountId = o1.ccrz__Account__c;
        //MapOrdero.put(o1.id,o1);
        //orderlIst.add(o1);
        //System.debug('---CC Order---'+o1);

        /*ccrz__E_Order__c o11 = new ccrz__E_Order__c (id = o1.id);
        o11.ccrz__OrderStatus__c = 'Order Submitted';
        o11.ccrz__OrderDate__c = system.today();
        update o11;
        //MapOrdern.put(o1.id,o1);
                
        //Put CC Order data Into Map
        Map<Id,ccrz__E_Order__c> cor=new Map<Id,ccrz__E_Order__c>();
        cor.put(o1.id,o1); 
        set<id> ke=cor.keyset();*/

        //CC Product        
        ccrz__E_Product__c parentpro = new ccrz__E_Product__c();
        parentpro.Name = 'CA Base-DEF';
        parentpro.ccrz__SKU__c = '5678901-DEF';
        parentpro.ccrz__Quantityperunit__c = 1;
        parentpro.Group_Name__c = 'DA';
        parentpro.Product_Class_Code__c = 'SW-Web Access';
        insert parentpro;
        //productIdList.add(parentpro.id);
        //System.debug('---CC Parent Product---'+parentpro);

        ccrz__E_Product__c pro = new ccrz__E_Product__c();
        pro.Name = 'CA Base-OHT';
        pro.ccrz__SKU__c = '5678902-OHTTest';
        pro.ccrz__Quantityperunit__c = 1;
        pro.Group_Name__c = 'DA';
        pro.ccrz__ParentProduct__c = parentpro.id;
        pro.Product_Class_Code__c = 'SW-Web Access';
        insert pro;
        //productIdList.add(pro.id);
        //System.debug('---CC Product---'+pro);

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
        insert oi1;
        //System.debug('---CC OrderItem---'+oi1); 

        //CC Subscription
        ccrz__E_Subscription__c Sub = new ccrz__E_Subscription__c();
        Sub.ccrz__Sequence__c = 3;
        Sub.ccrz__Storefront__c = 'SoftwareStore';
        Sub.ccrz__SubscriptionStartDate__c = System.now().adddays(-2);
        Sub.OSM_Subscription_End_Date__c = System.now().adddays(5);
        Sub.ccrz__SubscriptionStatus__c = 'Active';
        Sub.ccrz__InstallmentLastDate__c = System.now();
        Sub.ccrz__CCOrder__c = o1.Id;
        Sub.ccrz__CCOrderItem__c = oi1.Id;
        Sub.OSM_Free_Trial__c = false;
        Sub.ccrz__SubscriptionProduct__c = pro.Id;
        Sub.ccrz__RecurringPrice__c = 200;
        Sub.ccrz__OrderLastDate__c = System.now() + 10;
        Sub.ccrz__CurrencyISOCode__c = 'USD';
        Sub.ccrz__Quantity__c = 3;
        Sub.ccrz__Account__c = testAccount.id;
        Sub.Subsequent_Next_Invoice_Due_Dt__c = System.now() + 15;
        Sub.Subsequent_Next_Invoice_Generation_Dt__c = System.now() + 15;
        Insert Sub;

        return sub;
    }
    
    static testMethod void tetsMethod4() {
        ccrz__E_Product__c prod2 = new ccrz__E_Product__c();
        prod2.name = 'Connected Advisor';
        prod2.ccrz__SKU__c = '15458776';
        prod2.ccrz__Quantityperunit__c = 3343;
        prod2.ccrz__StartDate__c = system.today();
        prod2.ccrz__EndDate__c = system.today() + 1;
        prod2.ccrz__ShortDesc__c = 'testing';
        prod2.Rule1__c=25;
        prod2.Rule2__c=50;

        insert prod2;
         OSM_SW_ProdDetail_SES1_Comp_Ctrl   proddetail = new OSM_SW_ProdDetail_SES1_Comp_Ctrl();
             proddetail.qty1=0;
             proddetail.qty2=2;

            
        
    }

    static testMethod void tetsMethod3() {

        User loggedInUser = [Select id from User where id =: UserInfo.getUserId()];



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
        ccrz__E_Product__c prod = transecRes.objSetupDate.componentList[0];
        Account a = transecRes.objSetupDate.account;
        Contact c = transecRes.objSetupDate.contact;
        Set < String > idSet = new Set < String > ();
        idSet.add(prod.id);

        System.debug('transecRes: ' + transecRes);

        // Create E Cart
        //List<ccrz__E_Cart__c> lstECart = TestingUtils.CreateCart(1, 'SoftwareStore', 'Cart', objUser.Id, true, 'Open', true);


        // Creating address
        
       
        System.runAs(transecRes.objSetupDate.loggedInUser) {
            ccrz.cc_RemoteActionContext objRemotCtx = new ccrz.cc_RemoteActionContext();
            objRemotCtx.storefront = 'SoftwareStore';
            objRemotCtx.currentCartId = transecRes.cart.ccrz__EncryptedId__c;
            objRemotCtx.portalUserId = transecRes.objSetupDate.objUserID;

            System.debug('transecRes.objSetupDate.account ' + transecRes.objSetupDate.account);


            ccrz.cc_CallContext.initRemoteContext(objRemotCtx);

            ccrz__E_Spec__c spec = new ccrz__E_Spec__c();
            spec.name = 'CA Base';
            spec.imageText__c = 'test';
            spec.ccrz__Sequence__c = 500;
            insert spec;


            Set < String > childProdId = new Set < String > ();
            childProdId.add(transecRes.objSetupDate.compositeProduct.id);

            list < ccrz__E_ProductMedia__c > mlist = new list < ccrz__E_ProductMedia__c > ();
            ccrz__E_ProductMedia__c media = new ccrz__E_ProductMedia__c();
            //media.ccrz__Product__c = quoteList[0].Display_Product__c ;
            media.ccrz__MediaType__c = 'Product Image Thumbnail';
            media.ccrz__Product__c = transecRes.objSetupDate.compositeProduct.id;
            mlist.add(media);
            insert mlist;
            Attachment att = new Attachment();
            att.name = 'MediaAttachment';
            att.parentId = mlist[0].id;
            att.Body = Blob.valueof('test');
            insert att;
            List < String > relatedProductList = new List < String > ();
            //Neha Sharma Code added here
            ccrz__E_RelatedProduct__c rp = new ccrz__E_RelatedProduct__c();
            rp.ccrz__Product__c = transecRes.objSetupDate.compositeProduct.id;
            rp.ccrz__RelatedProduct__c = transecRes.objSetupDate.compositeProduct.id;
            rp.ccrz__RelatedProductType__c = 'Accessories';
            rp.ccrz__EndDate__c = System.today() + 1;
            insert rp;
            relatedProductList.add(rp.id);
            ccrz__E_Subscription__c Sub = new ccrz__E_Subscription__c();
            Sub.ccrz__Sequence__c = 3;
            Sub.ccrz__Storefront__c = 'SoftwareStore';
            Sub.ccrz__SubscriptionStartDate__c = System.now().adddays(-2);
            Sub.OSM_Subscription_End_Date__c = System.now().adddays(5);
            Sub.ccrz__SubscriptionStatus__c = 'Active';
            Sub.ccrz__InstallmentLastDate__c = System.now();
            Sub.ccrz__SPT__c = transecRes.objSetupDate.subProdTermList[0].id;
            // Sub.ccrz__CCOrder__c=o1.Id;
            // Sub.ccrz__CCOrderItem__c=oi1.Id;
            Sub.OSM_Free_Trial__c = false;
            Sub.ccrz__SubscriptionProduct__c = transecRes.objSetupDate.compositeProduct.Id;
            Sub.ccrz__RecurringPrice__c = 200;
            Sub.ccrz__OrderLastDate__c = System.now() + 10;
            Sub.ccrz__CurrencyISOCode__c = 'USD';
            Sub.ccrz__Quantity__c = 3;
            Sub.ccrz__Account__c = a.id;
            Sub.Subsequent_Next_Invoice_Due_Dt__c = System.now() + 15;
            Sub.Subsequent_Next_Invoice_Generation_Dt__c = System.now() + 15;
            Sub.OSM_Display_Product__c = transecRes.objSetupDate.compositeProduct.id;
            Insert Sub;

            ccrz__E_CompositeProduct__c compprod = new ccrz__E_CompositeProduct__c();
            compprod.ccrz__Component__c = transecRes.objSetupDate.compositeProduct.id;
            compprod.ccrz__Composite__c = transecRes.objSetupDate.compositeProduct.id;
            insert compprod;

            //Map<Id, Id> mapParentToBaseProduct = new Map<Id, Id>();
            //productIdVsAddOnProducts.put(rp.ccrz__Product__c,addOnProducts);
            //End Here
            String parentId = transecRes.objSetupDate.compositeProduct.id;
            String portalUserId = transecRes.objSetupDate.objUserID;
            Date relatedDate = System.Today();
            Map < String, Object > jsonMap = new Map < String, Object > ();
            jsonMap.put('parentId', parentId);
            jsonMap.put('portalUserId', portalUserId);
            jsonMap.put('relatedDate', relatedProductList);
            String JSONReq = JSON.serialize(jsonMap);

            System.debug('JSONReq____' + JSONReq);
            Test.StartTest();



            OSM_SW_ProdDetail_SES1_Comp_Ctrl.getProductDetail(objRemotCtx, '123456-BUS');
            //OSM_SW_ProdDetail_SES1_Comp_Ctrl obj = new OSM_SW_ProdDetail_SES1_Comp_Ctrl();
           // OSM_SW_ProdDetail_SES1_Comp_Ctrl.WarningMsg(objRemotCtx, '123456-BUS');

 
            OSM_SW_ProdDetail_SES1_Comp_Ctrl.MainWrapper mainWrp = new OSM_SW_ProdDetail_SES1_Comp_Ctrl.MainWrapper();
            mainWrp.isFreeTrialAvailabel = true;
            mainWrp.isResellerAccount=false;
            //mainWrp.proratedPriceMap = new Map<String,Decimal>();
            mainWrp.sortSubsLength =  new List<OSM_SW_ProductDetailCommonUtility.SortWrapper>();
            mainWrp.freeTrialDetails = new OSM_SW_ProdDetail_SES1_Comp_Ctrl.FreeTrialDetails();
            mainWrp.isOneTimeFrequency = true;
            mainWrp.isRFQ = true;
            mainWrp.DAExceptionFlag = true;
            mainWrp.subscriptionEndDate = 'Test Date';
            mainWrp.existingCartItem = new OSM_SW_ProdDetail_SES1_Comp_Ctrl.ExistingCartItem();
            mainWrp.productTnCLink = 'testLink';
            mainWrp.GOMSPriceMsg=false;
            mainWrp.qty2=25;
            mainWrp.qty1=25;
            String tesd = OSM_SW_ProdDetail_SES1_Comp_Ctrl.blank;

             Map < String, Object > jsonMap2 = new Map < String, Object > ();
            jsonMap2.put('customerComment', 'testing');
            jsonMap2.put('quantityTotal', '1');
            jsonMap2.put('parentId', parentId);
            jsonMap2.put('unitPrice', '2');
            String JSONReq2 = JSON.serialize(jsonMap2);
            PageReference Page = Page.OSM_SW_ProdDetailPg;
            Test.setCurrentPage(Page);

            OSM_SW_ProdDetail_SES1_Comp_Ctrl.submitRequestForApproval(objRemotCtx, JSONReq2);
            a.BMS_Customer_ID_Junction__c=''; 
            a.BMS_Customer_ID__c='';
            a.BOLT_Account_Number__c='';
            update a;
            OSM_SW_ProdDetail_SES1_Comp_Ctrl.submitRequestForApproval(objRemotCtx, JSONReq2);
            // OSM_SW_ProdDetail_SES1_Comp_Ctrl.WarningMsg(objRemotCtx, '123456-BUS');
            //OSM_SW_ProdDetail_SES1_Comp_Ctrl.submitRequestForApproval(objRemotCtx, null);
            
            
            test.StopTest();
        }
    }
    
    //LL33/LL34/LL35 Code Start
    
    // Method:	singleApprovalTest
    // Purpose:	test the single approval flow where a Request for Approval has been approved.
    
    static testMethod void singleApproval_Approved() {

        User loggedInUser = [Select id from User where id =: UserInfo.getUserId()];
        TestProductSetupReq testReq = new TestProductSetupReq();
        testReq.permissionSetName = 'OSM_Support_Admin';
        testReq.accountGroupName = 'US/CAN_EBU_SIR_ACCGRP';
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
        ccrz__E_Product__c prod = transecRes.objSetupDate.componentList[0];
        Account a = transecRes.objSetupDate.account;
        Contact c = transecRes.objSetupDate.contact;
        Set < String > idSet = new Set < String > ();
        idSet.add(prod.id);

        System.debug('transecRes: ' + transecRes);

        // Creating Cart
       // List<ccrz__E_Cart__c> lstECart = TestingUtils.CreateCart(1, 'SoftwareStore', 'Cart', objUser.Id, true, 'Open', true);
          Id portal_PROFILE_ID = [SELECT Id FROM Profile WHERE Name = 'IAM_Site_Admin_Community' Limit 1 ].Id;
          //Id roleId=[select id,name from UserRole where name='CumminsFleetsCustomerUser' limit 1].id; 
           
         UserRole portalRole = [Select Id From UserRole Where PortalType = 'None' Limit 1];
          system.debug('portalRole is ' + portalRole);

          Profile profile1 = [Select Id from Profile where name = 'System Administrator'];
          User portalAccountOwner2 = new User(
          UserRoleId = portalRole.Id,
          ProfileId = profile1.Id,
          Username ='testproddetail'+Math.random()+'@test.com',
          Alias = 'batman',
          Email='bruce.wayne@wayneenterprises.com',
          EmailEncodingKey='UTF-8',
          Firstname='Bruce',
          Lastname='Wayne',
          LanguageLocaleKey='en_US',
          LocaleSidKey='en_US',
          TimeZoneSidKey='America/Chicago'
          );
          Database.insert(portalAccountOwner2);
          
          //creating account group..
          ccrz__E_AccountGroup__c accGrp = new ccrz__E_AccountGroup__c(
          Name = 'US/CAN_EBU_SIR_ACCGRP'
          );
          System.runAs(portalAccountOwner2){
              Database.insert(accGrp);
          }
        // Create test account
          Account portalAccount2 = new Account(
          Name = 'TestAccount2',
          OwnerId = portalAccountOwner2.Id,
          OSM_Preferred_Billing_Frequency_Lock__c=false,
          BMS_Customer_ID__c='1234',
          OSM_Preferred_Payment_Method__c='po',
          OSM_Preferred_Payment_IsBolt_PO__c=false,
          ccrz__E_AccountGroup__c=accGrp.id
          );
          
          System.runAs(portalAccountOwner2){
              Database.insert(portalAccount2);
              //inserting custom setting.s
              insert new OSM_Approval_Flow_Account_Groups__c(Account_Group_Name__c = 'US/CAN_EBU_SIR_ACCGRP0' , Name='US/CAN_EBU_SIR_ACCGRP0', Product_SKU__c='',Product_SKU_One_time__c='123456-BUS,130129-BUS,SKU-123');
              insert new OSM_Approval_Flow_Products__c(Name='Fleet Count',Product_SKU__c='123456-BUS');

          }

          //Create contact
          Contact contact1 = new Contact(
          FirstName = 'John',
          Lastname = 'Smith',
          IAM_Contact_Status__c='Pending',
          Username__c = 'JohnSmith9980@gmail.com',
          AccountId = portalAccount2.Id,
          Email ='JohnSmith9980@gmail.com'
          );
          System.runAs(portalAccountOwner2){
              Database.insert(contact1);
          } 
          
        //Create community user from contact
          User testUser = new User();
          testUser.FirstName = 'Testttt';
          testUser.LastName = 'lasttt';
          testUser.UserName = 'testproddetail' + Math.random() + '@test.com'; //Updated 9/8
          testUser.Email = 'bruce.wayne@wayneenterprises.com';
          testUser.Alias = 'batman';
          testUser.ContactId = contact1.Id;
          testUser.CommunityNickname = 'test12345h';
          testUser.ProfileId =portal_PROFILE_ID;
          testUser.TimeZoneSidKey = 'America/Los_Angeles';
          testUser.isActive = true;
          testUser.LocaleSidKey = 'en_US';
          testUser.LanguageLocaleKey = 'en_US';
          testUser.EmailEncodingKey = 'ISO-8859-1';
            System.runAs(portalAccountOwner2){
                  insert testUser;
            
          }
           System.runAs(portalAccountOwner2) {

            PermissionSet ps = [SELECT Id FROM PermissionSet WHERE Name = 'OSM_Fleet_Admin_CC'];
            ccrz.cc_RemoteActionContext objRemotCtx = new ccrz.cc_RemoteActionContext();
            objRemotCtx.storefront = 'SoftwareStore';
            objRemotCtx.currentCartId = transecRes.cart.ccrz__EncryptedId__c;
            objRemotCtx.portalUserId = testuser.id;
            ccrz.cc_CallContext.initRemoteContext(objRemotCtx);

            ccrz__E_Spec__c spec = new ccrz__E_Spec__c();
            spec.name = 'CA Base';
            spec.imageText__c = 'test';
            spec.ccrz__Sequence__c = 500;
            insert spec;
            Set < String > childProdId = new Set < String > ();
            childProdId.add(transecRes.objSetupDate.compositeProduct.id);

            list < ccrz__E_ProductMedia__c > mlist = new list < ccrz__E_ProductMedia__c > ();
            ccrz__E_ProductMedia__c media = new ccrz__E_ProductMedia__c();
            media.ccrz__MediaType__c = 'Product Image Thumbnail';
            media.ccrz__Product__c = transecRes.objSetupDate.compositeProduct.id;
            mlist.add(media);
            insert mlist;
            
            Attachment att = new Attachment();
            att.name = 'MediaAttachment';
            att.parentId = mlist[0].id;
            att.Body = Blob.valueof('test');
            insert att;
            
            List < String > relatedProductList = new List < String > ();
            //Neha Sharma Code added here
            ccrz__E_RelatedProduct__c rp = new ccrz__E_RelatedProduct__c();
            rp.ccrz__Product__c = transecRes.objSetupDate.compositeProduct.id;
            rp.ccrz__RelatedProduct__c = transecRes.objSetupDate.compositeProduct.id;
            rp.ccrz__RelatedProductType__c = 'Accessories';
            rp.ccrz__EndDate__c = System.today() + 1;
            insert rp;
            
            relatedProductList.add(rp.id);
            ccrz__E_Subscription__c Sub = new ccrz__E_Subscription__c();
            Sub.ccrz__Sequence__c = 3;
            Sub.ccrz__Storefront__c = 'SoftwareStore';
            Sub.ccrz__SubscriptionStartDate__c = System.now().adddays(-2);
            Sub.OSM_Subscription_End_Date__c = System.now().adddays(5);
            Sub.ccrz__SubscriptionStatus__c = 'Active';
            Sub.ccrz__InstallmentLastDate__c = System.now();
            Sub.ccrz__SPT__c = transecRes.objSetupDate.subProdTermList[0].id;
            Sub.OSM_Free_Trial__c = false;
            Sub.ccrz__SubscriptionProduct__c = transecRes.objSetupDate.compositeProduct.Id;
            Sub.ccrz__RecurringPrice__c = 200;
            Sub.ccrz__OrderLastDate__c = System.now() + 10;
            Sub.ccrz__CurrencyISOCode__c = 'USD';
            Sub.ccrz__Quantity__c = 3;
            Sub.ccrz__Account__c = a.id;
            Sub.Subsequent_Next_Invoice_Due_Dt__c = System.now() + 15;
            Sub.Subsequent_Next_Invoice_Generation_Dt__c = System.now() + 15;
            Sub.OSM_Display_Product__c = transecRes.objSetupDate.compositeProduct.id;
            Insert Sub;
               
            ccrz__E_CompositeProduct__c compprod = new ccrz__E_CompositeProduct__c();
            compprod.ccrz__Component__c = transecRes.objSetupDate.compositeProduct.id;
            compprod.ccrz__Composite__c = transecRes.objSetupDate.compositeProduct.id;
            insert compprod;
            String parentId = transecRes.objSetupDate.compositeProduct.id;
            String portalUserId = transecRes.objSetupDate.loggedInUser.id;
            Date relatedDate = System.Today();
            Map < String, Object > jsonMap = new Map < String, Object > ();
            jsonMap.put('parentId', parentId);
            jsonMap.put('portalUserId', portalUserId);
            jsonMap.put('relatedDate', relatedProductList);
            jsonMap.put('renewProd', 'SKU-123');
            String JSONReq = JSON.serialize(jsonMap);
                  
            Map < String, Object > jsonMap2 = new Map < String, Object > ();
            jsonMap2.put('customerComment', 'testing');
            jsonMap2.put('quantityTotal', '1');
            jsonMap2.put('parentId', parentId);
            jsonMap2.put('unitPrice', '2');
            String JSONReq2 = JSON.serialize(jsonMap2);
            System.debug('JSONReq____' + JSONReq2);
            Test.StartTest();
            String successResponse = '{"createWithCoterm":false,"subcQty":"1","unitPrice":2,"monthlyPrice":1,"totalPrice":"7","availableCount":"10","billingFreq":"Monthly","productSkuSelected":"130129-BUS","selectedProdSku":"130129-BUS", "prodSubscriptions":"3","plan":"Pro","rfqDescription":"testing","subProdTermId":"' + transecRes.objSetupDate.subProdTermList[0].Id + '","parentId":"' + transecRes.objSetupDate.compositeProduct.Id + '","userId":"' + transecRes.objSetupDate.objUserID + '","isBundle":' + true + ',"isSubscribed":' + false + ',"relatedProd_selectedProdId":{"a2k3C000000HgVwQAK":[{"sfdcName":"Service Tech Kit 1","price":"3","qtyPerUnit":2,"addOnProPrice":0,"shortDesc":"Guidanz Mobile - 2 UsersINSITE™ Lite - 1 License","productId":"a2k3C000000LskAQAS","productSku":"CG-Lite-004-1","currencySymbol":"$ ","relProdSPT":"a3F3C000000RIO4UAO"}]}}';
            OSM_SW_ProdDetail_SES1_Comp_Ctrl.ProductSpecificationHeader pod = new OSM_SW_ProdDetail_SES1_Comp_Ctrl.ProductSpecificationHeader();
            pod.Id = 'test';
            pod.Value='test'; 
            OSM_SW_ProdDetail_SES1_Comp_Ctrl.ProductDetailWrapper pod1 = new OSM_SW_ProdDetail_SES1_Comp_Ctrl.ProductDetailWrapper();
            pod1.productName = 'test';
            pod1.pricePerLabel='test';
            pod1.pricePerValue = 11;
            pod1.prodSubscriptionPriceMonthly=11;
            pod1.prodSubscriptionPriceYearly = 11;
            pod1.subscriptionLength=new Map<String,Integer>();
            pod1.subscriptionBillingfrequency=new Map<String,Integer>();
            
            OSM_SW_ProdDetail_SES1_Comp_Ctrl.UserDetail pod11 = new OSM_SW_ProdDetail_SES1_Comp_Ctrl.UserDetail();
            pod11.fName = 'test';
            pod11.lName='test';
            pod11.email = 'test';
            pod11.phone='test';
            pod11.strAddress = 'test';
            pod11.company='test';
            pod11.contactId='test';
            pod11.requestedDate='test';
            // Call Apex Class Methods
            OSM_SW_ProdDetail_SES1_Comp_Ctrl.WarningMsg(objRemotCtx, '123456-bus');
            OSM_SW_ProdDetail_SES1_Comp_Ctrl.submitRequestForApproval(objRemotCtx, JSONReq2);
            List<CC_Request_for_Approval__c> req = [SELECT Id, Product_Name__c,Request_Status__c FROM CC_Request_for_Approval__c];
               System.debug('req: ' + req);
               req[0].Request_Status__c = 'Approved';
               update req;
            OSM_SW_ProdDetail_SES1_Comp_Ctrl.accountIdTest = transecRes.objSetupDate.account.Id;
            OSM_SW_ProdDetail_SES1_Comp_Ctrl.fetchProdDetailInfoForDA(objRemotCtx, JSONReq);
			//System.assert(res.data);          
            //OSM_SW_ProdDetail_SES1_Comp_Ctrl.saveCCPackageInClass(objRemotCtx, 'testccdata');
            //OSM_SW_ProdDetail_SES1_Comp_Ctrl.MainWrapper mainWrp = new OSM_SW_ProdDetail_SES1_Comp_Ctrl.MainWrapper();
               //mainWrp = (OSM_SW_ProdDetail_SES1_Comp_Ctrl.MainWrapper) res.data;
               //System.debug('mainWrp: ' + mainWrp.showAddtoCartButtonAgain);
            
            test.StopTest();
        }
    }
    
    // Method:	singleApprovalTest
    // Purpose:	test the single approval flow where a Request for Approval is pending.
    
    static testMethod void singleApproval_PendingApproval() {

        User loggedInUser = [Select id from User where id =: UserInfo.getUserId()];
        TestProductSetupReq testReq = new TestProductSetupReq();
        testReq.permissionSetName = 'OSM_Support_Admin';
        testReq.accountGroupName = 'US/CAN_EBU_SIR_ACCGRP';
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
        ccrz__E_Product__c prod = transecRes.objSetupDate.componentList[0];
        Account a = transecRes.objSetupDate.account;
        Contact c = transecRes.objSetupDate.contact;
        Set < String > idSet = new Set < String > ();
        idSet.add(prod.id);

        System.debug('transecRes: ' + transecRes);

        // Creating Cart
       // List<ccrz__E_Cart__c> lstECart = TestingUtils.CreateCart(1, 'SoftwareStore', 'Cart', objUser.Id, true, 'Open', true);
          Id portal_PROFILE_ID = [SELECT Id FROM Profile WHERE Name = 'IAM_Site_Admin_Community' Limit 1 ].Id;
          //Id roleId=[select id,name from UserRole where name='CumminsFleetsCustomerUser' limit 1].id; 
           
         UserRole portalRole = [Select Id From UserRole Where PortalType = 'None' Limit 1];
          system.debug('portalRole is ' + portalRole);

          Profile profile1 = [Select Id from Profile where name = 'System Administrator'];
          User portalAccountOwner2 = new User(
          UserRoleId = portalRole.Id,
          ProfileId = profile1.Id,
          Username ='testproddetail'+Math.random()+'@test.com',
          Alias = 'batman',
          Email='bruce.wayne@wayneenterprises.com',
          EmailEncodingKey='UTF-8',
          Firstname='Bruce',
          Lastname='Wayne',
          LanguageLocaleKey='en_US',
          LocaleSidKey='en_US',
          TimeZoneSidKey='America/Chicago'
          );
          Database.insert(portalAccountOwner2);
          
          //creating account group..
          ccrz__E_AccountGroup__c accGrp = new ccrz__E_AccountGroup__c(
          Name = 'US/CAN_EBU_SIR_ACCGRP'
          );
          System.runAs(portalAccountOwner2){
              Database.insert(accGrp);
          }
        // Create test account
          Account portalAccount2 = new Account(
          Name = 'TestAccount2',
          OwnerId = portalAccountOwner2.Id,
          OSM_Preferred_Billing_Frequency_Lock__c=false,
          BMS_Customer_ID__c='1234',
          OSM_Preferred_Payment_Method__c='po',
          OSM_Preferred_Payment_IsBolt_PO__c=false,
          ccrz__E_AccountGroup__c=accGrp.id
          );
          
          System.runAs(portalAccountOwner2){
              Database.insert(portalAccount2);
              //inserting custom setting.s
              insert new OSM_Approval_Flow_Account_Groups__c(Account_Group_Name__c = 'US/CAN_EBU_SIR_ACCGRP0' , Name='US/CAN_EBU_SIR_ACCGRP0', Product_SKU__c='',Product_SKU_One_time__c='123456-BUS,130129-BUS,SKU-123');
              insert new OSM_Approval_Flow_Products__c(Name='Fleet Count',Product_SKU__c='123456-BUS');

          }

          //Create contact
          Contact contact1 = new Contact(
          FirstName = 'John',
          Lastname = 'Smith',
          IAM_Contact_Status__c='Pending',
          Username__c = 'JohnSmith9980@gmail.com',
          AccountId = portalAccount2.Id,
          Email ='JohnSmith9980@gmail.com'
          );
          System.runAs(portalAccountOwner2){
              Database.insert(contact1);
          } 
          
        //Create community user from contact
          User testUser = new User();
          testUser.FirstName = 'Testttt';
          testUser.LastName = 'lasttt';
          testUser.UserName = 'testproddetail'+Math.random()+'@test.com';//Updated 9/8
          testUser.Email = 'bruce.wayne@wayneenterprises.com';
          testUser.Alias = 'batman';
          testUser.ContactId = contact1.Id;
          testUser.CommunityNickname = 'test12345h';
          testUser.ProfileId =portal_PROFILE_ID;
          testUser.TimeZoneSidKey = 'America/Los_Angeles';
          testUser.isActive = true;
          testUser.LocaleSidKey = 'en_US';
          testUser.LanguageLocaleKey = 'en_US';
          testUser.EmailEncodingKey = 'ISO-8859-1';
            System.runAs(portalAccountOwner2){
                  insert testUser;
            
          }
           System.runAs(portalAccountOwner2) {

            PermissionSet ps = [SELECT Id FROM PermissionSet WHERE Name = 'OSM_Fleet_Admin_CC'];
            ccrz.cc_RemoteActionContext objRemotCtx = new ccrz.cc_RemoteActionContext();
            objRemotCtx.storefront = 'SoftwareStore';
            objRemotCtx.currentCartId = transecRes.cart.ccrz__EncryptedId__c;
            objRemotCtx.portalUserId = testuser.id;
            ccrz.cc_CallContext.initRemoteContext(objRemotCtx);

            ccrz__E_Spec__c spec = new ccrz__E_Spec__c();
            spec.name = 'CA Base';
            spec.imageText__c = 'test';
            spec.ccrz__Sequence__c = 500;
            insert spec;
            Set < String > childProdId = new Set < String > ();
            childProdId.add(transecRes.objSetupDate.compositeProduct.id);

            list < ccrz__E_ProductMedia__c > mlist = new list < ccrz__E_ProductMedia__c > ();
            ccrz__E_ProductMedia__c media = new ccrz__E_ProductMedia__c();
            media.ccrz__MediaType__c = 'Product Image Thumbnail';
            media.ccrz__Product__c = transecRes.objSetupDate.compositeProduct.id;
            mlist.add(media);
            insert mlist;
            
            Attachment att = new Attachment();
            att.name = 'MediaAttachment';
            att.parentId = mlist[0].id;
            att.Body = Blob.valueof('test');
            insert att;
            
            List < String > relatedProductList = new List < String > ();
            //Neha Sharma Code added here
            ccrz__E_RelatedProduct__c rp = new ccrz__E_RelatedProduct__c();
            rp.ccrz__Product__c = transecRes.objSetupDate.compositeProduct.id;
            rp.ccrz__RelatedProduct__c = transecRes.objSetupDate.compositeProduct.id;
            rp.ccrz__RelatedProductType__c = 'Accessories';
            rp.ccrz__EndDate__c = System.today() + 1;
            insert rp;
            
            relatedProductList.add(rp.id);
            ccrz__E_Subscription__c Sub = new ccrz__E_Subscription__c();
            Sub.ccrz__Sequence__c = 3;
            Sub.ccrz__Storefront__c = 'SoftwareStore';
            Sub.ccrz__SubscriptionStartDate__c = System.now().adddays(-2);
            Sub.OSM_Subscription_End_Date__c = System.now().adddays(5);
            Sub.ccrz__SubscriptionStatus__c = 'Active';
            Sub.ccrz__InstallmentLastDate__c = System.now();
            Sub.ccrz__SPT__c = transecRes.objSetupDate.subProdTermList[0].id;
            Sub.OSM_Free_Trial__c = false;
            Sub.ccrz__SubscriptionProduct__c = transecRes.objSetupDate.compositeProduct.Id;
            Sub.ccrz__RecurringPrice__c = 200;
            Sub.ccrz__OrderLastDate__c = System.now() + 10;
            Sub.ccrz__CurrencyISOCode__c = 'USD';
            Sub.ccrz__Quantity__c = 3;
            Sub.ccrz__Account__c = a.id;
            Sub.Subsequent_Next_Invoice_Due_Dt__c = System.now() + 15;
            Sub.Subsequent_Next_Invoice_Generation_Dt__c = System.now() + 15;
            Sub.OSM_Display_Product__c = transecRes.objSetupDate.compositeProduct.id;
            Insert Sub;
               
            ccrz__E_CompositeProduct__c compprod = new ccrz__E_CompositeProduct__c();
            compprod.ccrz__Component__c = transecRes.objSetupDate.compositeProduct.id;
            compprod.ccrz__Composite__c = transecRes.objSetupDate.compositeProduct.id;
            insert compprod;
            String parentId = transecRes.objSetupDate.compositeProduct.id;
            String portalUserId = transecRes.objSetupDate.loggedInUser.id;
            Date relatedDate = System.Today();
            Map < String, Object > jsonMap = new Map < String, Object > ();
            jsonMap.put('parentId', parentId);
            jsonMap.put('portalUserId', portalUserId);
            jsonMap.put('relatedDate', relatedProductList);
            jsonMap.put('renewProd', 'SKU-123');
            String JSONReq = JSON.serialize(jsonMap);
                  
            Map < String, Object > jsonMap2 = new Map < String, Object > ();
            jsonMap2.put('customerComment', 'testing');
            jsonMap2.put('quantityTotal', '1');
            jsonMap2.put('parentId', parentId);
            jsonMap2.put('unitPrice', '2');
            String JSONReq2 = JSON.serialize(jsonMap2);
            System.debug('JSONReq____' + JSONReq2);
            Test.StartTest();
            String successResponse = '{"createWithCoterm":false,"subcQty":"1","unitPrice":2,"monthlyPrice":1,"totalPrice":"7","availableCount":"10","billingFreq":"Monthly","productSkuSelected":"130129-BUS","selectedProdSku":"130129-BUS", "prodSubscriptions":"3","plan":"Pro","rfqDescription":"testing","subProdTermId":"' + transecRes.objSetupDate.subProdTermList[0].Id + '","parentId":"' + transecRes.objSetupDate.compositeProduct.Id + '","userId":"' + transecRes.objSetupDate.objUserID + '","isBundle":' + true + ',"isSubscribed":' + false + ',"relatedProd_selectedProdId":{"a2k3C000000HgVwQAK":[{"sfdcName":"Service Tech Kit 1","price":"3","qtyPerUnit":2,"addOnProPrice":0,"shortDesc":"Guidanz Mobile - 2 UsersINSITE™ Lite - 1 License","productId":"a2k3C000000LskAQAS","productSku":"CG-Lite-004-1","currencySymbol":"$ ","relProdSPT":"a3F3C000000RIO4UAO"}]}}';
            OSM_SW_ProdDetail_SES1_Comp_Ctrl.ProductSpecificationHeader pod = new OSM_SW_ProdDetail_SES1_Comp_Ctrl.ProductSpecificationHeader();
            pod.Id = 'test';
            pod.Value='test'; 
            OSM_SW_ProdDetail_SES1_Comp_Ctrl.ProductDetailWrapper pod1 = new OSM_SW_ProdDetail_SES1_Comp_Ctrl.ProductDetailWrapper();
            pod1.productName = 'test';
            pod1.pricePerLabel='test';
            pod1.pricePerValue = 11;
            pod1.prodSubscriptionPriceMonthly=11;
            pod1.prodSubscriptionPriceYearly = 11;
            pod1.subscriptionLength=new Map<String,Integer>();
            pod1.subscriptionBillingfrequency=new Map<String,Integer>();
            
            OSM_SW_ProdDetail_SES1_Comp_Ctrl.UserDetail pod11 = new OSM_SW_ProdDetail_SES1_Comp_Ctrl.UserDetail();
            pod11.fName = 'test';
            pod11.lName='test';
            pod11.email = 'test';
            pod11.phone='test';
            pod11.strAddress = 'test';
            pod11.company='test';
            pod11.contactId='test';
            pod11.requestedDate='test';
            // Call Apex Class Methods
            OSM_SW_ProdDetail_SES1_Comp_Ctrl.WarningMsg(objRemotCtx, '123456-bus');
            OSM_SW_ProdDetail_SES1_Comp_Ctrl.submitRequestForApproval(objRemotCtx, JSONReq2);
            OSM_SW_ProdDetail_SES1_Comp_Ctrl.accountIdTest = transecRes.objSetupDate.account.Id;
            ccrz.cc_RemoteActionResult res = OSM_SW_ProdDetail_SES1_Comp_Ctrl.fetchProdDetailInfoForDA(objRemotCtx, JSONReq);
			System.assert(res.data != null); 
            
            test.StopTest();
        }
    }
    
    // Method:	singleApprovalTest
    // Purpose:	test the single approval flow where a approval has been revoked.
    
    static testMethod void singleApproval_RevokeApproval() {

        User loggedInUser = [Select id from User where id =: UserInfo.getUserId()];
        TestProductSetupReq testReq = new TestProductSetupReq();
        testReq.permissionSetName = 'OSM_Support_Admin';
        testReq.accountGroupName = 'US/CAN_EBU_SIR_ACCGRP';
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
        ccrz__E_Product__c prod = transecRes.objSetupDate.componentList[0];
        Account a = transecRes.objSetupDate.account;
        Contact c = transecRes.objSetupDate.contact;
        Set < String > idSet = new Set < String > ();
        idSet.add(prod.id);

        System.debug('transecRes: ' + transecRes);

        // Creating Cart
       // List<ccrz__E_Cart__c> lstECart = TestingUtils.CreateCart(1, 'SoftwareStore', 'Cart', objUser.Id, true, 'Open', true);
          Id portal_PROFILE_ID = [SELECT Id FROM Profile WHERE Name = 'IAM_Site_Admin_Community' Limit 1 ].Id;
          //Id roleId=[select id,name from UserRole where name='CumminsFleetsCustomerUser' limit 1].id; 
           
         UserRole portalRole = [Select Id From UserRole Where PortalType = 'None' Limit 1];
          system.debug('portalRole is ' + portalRole);

          Profile profile1 = [Select Id from Profile where name = 'System Administrator'];
          User portalAccountOwner2 = new User(
          UserRoleId = portalRole.Id,
          ProfileId = profile1.Id,
          Username ='testproddetail'+Math.random()+'@test.com',
          Alias = 'batman',
          Email='bruce.wayne@wayneenterprises.com',
          EmailEncodingKey='UTF-8',
          Firstname='Bruce',
          Lastname='Wayne',
          LanguageLocaleKey='en_US',
          LocaleSidKey='en_US',
          TimeZoneSidKey='America/Chicago'
          );
          Database.insert(portalAccountOwner2);
          
          //creating account group..
          ccrz__E_AccountGroup__c accGrp = new ccrz__E_AccountGroup__c(
          Name = 'US/CAN_EBU_SIR_ACCGRP'
          );
          System.runAs(portalAccountOwner2){
              Database.insert(accGrp);
          }
        // Create test account
          Account portalAccount2 = new Account(
          Name = 'TestAccount2',
          OwnerId = portalAccountOwner2.Id,
          OSM_Preferred_Billing_Frequency_Lock__c=false,
          BMS_Customer_ID__c='1234',
          OSM_Preferred_Payment_Method__c='po',
          OSM_Preferred_Payment_IsBolt_PO__c=false,
          ccrz__E_AccountGroup__c=accGrp.id
          );
          
          System.runAs(portalAccountOwner2){
              Database.insert(portalAccount2);
              //inserting custom setting.s
              insert new OSM_Approval_Flow_Account_Groups__c(Account_Group_Name__c = 'US/CAN_EBU_SIR_ACCGRP0' , Name='US/CAN_EBU_SIR_ACCGRP0', Product_SKU__c='',Product_SKU_One_time__c='123456-BUS,130129-BUS,SKU-123');
              insert new OSM_Approval_Flow_Products__c(Name='Fleet Count',Product_SKU__c='123456-BUS');

          }

          //Create contact
          Contact contact1 = new Contact(
          FirstName = 'John',
          Lastname = 'Smith',
          IAM_Contact_Status__c='Pending',
          Username__c = 'JohnSmith9980@gmail.com',
          AccountId = portalAccount2.Id,
          Email ='JohnSmith9980@gmail.com'
          );
          System.runAs(portalAccountOwner2){
              Database.insert(contact1);
          } 
          
        //Create community user from contact
          User testUser = new User();
          testUser.FirstName = 'Testttt';
          testUser.LastName = 'lasttt';
          testUser.UserName = 'testproddetail'+Math.random()+'@test.com';//Updated 9/8
          testUser.Email = 'bruce.wayne@wayneenterprises.com';
          testUser.Alias = 'batman';
          testUser.ContactId = contact1.Id;
          testUser.CommunityNickname = 'test12345h';
          testUser.ProfileId =portal_PROFILE_ID;
          testUser.TimeZoneSidKey = 'America/Los_Angeles';
          testUser.isActive = true;
          testUser.LocaleSidKey = 'en_US';
          testUser.LanguageLocaleKey = 'en_US';
          testUser.EmailEncodingKey = 'ISO-8859-1';
            System.runAs(portalAccountOwner2){
                  insert testUser;
            
          }
           System.runAs(portalAccountOwner2) {

            PermissionSet ps = [SELECT Id FROM PermissionSet WHERE Name = 'OSM_Fleet_Admin_CC'];
            ccrz.cc_RemoteActionContext objRemotCtx = new ccrz.cc_RemoteActionContext();
            objRemotCtx.storefront = 'SoftwareStore';
            objRemotCtx.currentCartId = transecRes.cart.ccrz__EncryptedId__c;
            objRemotCtx.portalUserId = testuser.id;
            ccrz.cc_CallContext.initRemoteContext(objRemotCtx);

            ccrz__E_Spec__c spec = new ccrz__E_Spec__c();
            spec.name = 'CA Base';
            spec.imageText__c = 'test';
            spec.ccrz__Sequence__c = 500;
            insert spec;
            Set < String > childProdId = new Set < String > ();
            childProdId.add(transecRes.objSetupDate.compositeProduct.id);

            list < ccrz__E_ProductMedia__c > mlist = new list < ccrz__E_ProductMedia__c > ();
            ccrz__E_ProductMedia__c media = new ccrz__E_ProductMedia__c();
            media.ccrz__MediaType__c = 'Product Image Thumbnail';
            media.ccrz__Product__c = transecRes.objSetupDate.compositeProduct.id;
            mlist.add(media);
            insert mlist;
            
            Attachment att = new Attachment();
            att.name = 'MediaAttachment';
            att.parentId = mlist[0].id;
            att.Body = Blob.valueof('test');
            insert att;
            
            List < String > relatedProductList = new List < String > ();
            //Neha Sharma Code added here
            ccrz__E_RelatedProduct__c rp = new ccrz__E_RelatedProduct__c();
            rp.ccrz__Product__c = transecRes.objSetupDate.compositeProduct.id;
            rp.ccrz__RelatedProduct__c = transecRes.objSetupDate.compositeProduct.id;
            rp.ccrz__RelatedProductType__c = 'Accessories';
            rp.ccrz__EndDate__c = System.today() + 1;
            insert rp;
            
            relatedProductList.add(rp.id);
            ccrz__E_Subscription__c Sub = new ccrz__E_Subscription__c();
            Sub.ccrz__Sequence__c = 3;
            Sub.ccrz__Storefront__c = 'SoftwareStore';
            Sub.ccrz__SubscriptionStartDate__c = System.now().adddays(-2);
            Sub.OSM_Subscription_End_Date__c = System.now().adddays(5);
            Sub.ccrz__SubscriptionStatus__c = 'Active';
            Sub.ccrz__InstallmentLastDate__c = System.now();
            Sub.ccrz__SPT__c = transecRes.objSetupDate.subProdTermList[0].id;
            Sub.OSM_Free_Trial__c = false;
            Sub.ccrz__SubscriptionProduct__c = transecRes.objSetupDate.compositeProduct.Id;
            Sub.ccrz__RecurringPrice__c = 200;
            Sub.ccrz__OrderLastDate__c = System.now() + 10;
            Sub.ccrz__CurrencyISOCode__c = 'USD';
            Sub.ccrz__Quantity__c = 3;
            Sub.ccrz__Account__c = a.id;
            Sub.Subsequent_Next_Invoice_Due_Dt__c = System.now() + 15;
            Sub.Subsequent_Next_Invoice_Generation_Dt__c = System.now() + 15;
            Sub.OSM_Display_Product__c = transecRes.objSetupDate.compositeProduct.id;
            Insert Sub;
               
            ccrz__E_CompositeProduct__c compprod = new ccrz__E_CompositeProduct__c();
            compprod.ccrz__Component__c = transecRes.objSetupDate.compositeProduct.id;
            compprod.ccrz__Composite__c = transecRes.objSetupDate.compositeProduct.id;
            insert compprod;
            String parentId = transecRes.objSetupDate.compositeProduct.id;
            String portalUserId = transecRes.objSetupDate.loggedInUser.id;
            Date relatedDate = System.Today();
            Map < String, Object > jsonMap = new Map < String, Object > ();
            jsonMap.put('parentId', parentId);
            jsonMap.put('portalUserId', portalUserId);
            jsonMap.put('relatedDate', relatedProductList);
            jsonMap.put('renewProd', 'SKU-123');
            String JSONReq = JSON.serialize(jsonMap);
                  
            Map < String, Object > jsonMap2 = new Map < String, Object > ();
            jsonMap2.put('customerComment', 'testing');
            jsonMap2.put('quantityTotal', '1');
            jsonMap2.put('parentId', parentId);
            jsonMap2.put('unitPrice', '2');
            String JSONReq2 = JSON.serialize(jsonMap2);
            System.debug('JSONReq____' + JSONReq2);
            Test.StartTest();
            String successResponse = '{"createWithCoterm":false,"subcQty":"1","unitPrice":2,"monthlyPrice":1,"totalPrice":"7","availableCount":"10","billingFreq":"Monthly","productSkuSelected":"130129-BUS","selectedProdSku":"130129-BUS", "prodSubscriptions":"3","plan":"Pro","rfqDescription":"testing","subProdTermId":"' + transecRes.objSetupDate.subProdTermList[0].Id + '","parentId":"' + transecRes.objSetupDate.compositeProduct.Id + '","userId":"' + transecRes.objSetupDate.objUserID + '","isBundle":' + true + ',"isSubscribed":' + false + ',"relatedProd_selectedProdId":{"a2k3C000000HgVwQAK":[{"sfdcName":"Service Tech Kit 1","price":"3","qtyPerUnit":2,"addOnProPrice":0,"shortDesc":"Guidanz Mobile - 2 UsersINSITE™ Lite - 1 License","productId":"a2k3C000000LskAQAS","productSku":"CG-Lite-004-1","currencySymbol":"$ ","relProdSPT":"a3F3C000000RIO4UAO"}]}}';
            OSM_SW_ProdDetail_SES1_Comp_Ctrl.ProductSpecificationHeader pod = new OSM_SW_ProdDetail_SES1_Comp_Ctrl.ProductSpecificationHeader();
            pod.Id = 'test';
            pod.Value='test'; 
            OSM_SW_ProdDetail_SES1_Comp_Ctrl.ProductDetailWrapper pod1 = new OSM_SW_ProdDetail_SES1_Comp_Ctrl.ProductDetailWrapper();
            pod1.productName = 'test';
            pod1.pricePerLabel='test';
            pod1.pricePerValue = 11;
            pod1.prodSubscriptionPriceMonthly=11;
            pod1.prodSubscriptionPriceYearly = 11;
            pod1.subscriptionLength=new Map<String,Integer>();
            pod1.subscriptionBillingfrequency=new Map<String,Integer>();
            
            OSM_SW_ProdDetail_SES1_Comp_Ctrl.UserDetail pod11 = new OSM_SW_ProdDetail_SES1_Comp_Ctrl.UserDetail();
            pod11.fName = 'test';
            pod11.lName='test';
            pod11.email = 'test';
            pod11.phone='test';
            pod11.strAddress = 'test';
            pod11.company='test';
            pod11.contactId='test';
            pod11.requestedDate='test';
            // Call Apex Class Methods
            OSM_SW_ProdDetail_SES1_Comp_Ctrl.WarningMsg(objRemotCtx, '123456-bus');
            OSM_SW_ProdDetail_SES1_Comp_Ctrl.submitRequestForApproval(objRemotCtx, JSONReq2);
            List<CC_Request_for_Approval__c> req = [SELECT Id, Product_Name__c,Request_Status__c FROM CC_Request_for_Approval__c];
               System.debug('req: ' + req);
               req[0].Request_Status__c = 'Rejected';
               update req;
            OSM_SW_ProdDetail_SES1_Comp_Ctrl.accountIdTest = transecRes.objSetupDate.account.Id;
            ccrz.cc_RemoteActionResult res = OSM_SW_ProdDetail_SES1_Comp_Ctrl.fetchProdDetailInfoForDA(objRemotCtx, JSONReq);
			System.assert(res.data != null);
            
            test.StopTest();
        }
    }
    
    // Method:	singleApprovalTest
    // Purpose:	test the single approval flow where a Request for Approval has been rejected.
    
    static testMethod void singleApproval_ApprovalRejected() {

        User loggedInUser = [Select id from User where id =: UserInfo.getUserId()];
        TestProductSetupReq testReq = new TestProductSetupReq();
        testReq.permissionSetName = 'OSM_Support_Admin';
        testReq.accountGroupName = 'US/CAN_EBU_SIR_ACCGRP';
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
        ccrz__E_Product__c prod = transecRes.objSetupDate.componentList[0];
        Account a = transecRes.objSetupDate.account;
        Contact c = transecRes.objSetupDate.contact;
        Set < String > idSet = new Set < String > ();
        idSet.add(prod.id);

        System.debug('transecRes: ' + transecRes);

        // Creating Cart
       // List<ccrz__E_Cart__c> lstECart = TestingUtils.CreateCart(1, 'SoftwareStore', 'Cart', objUser.Id, true, 'Open', true);
          Id portal_PROFILE_ID = [SELECT Id FROM Profile WHERE Name = 'IAM_Site_Admin_Community' Limit 1 ].Id;
          //Id roleId=[select id,name from UserRole where name='CumminsFleetsCustomerUser' limit 1].id; 
           
         UserRole portalRole = [Select Id From UserRole Where PortalType = 'None' Limit 1];
          system.debug('portalRole is ' + portalRole);

          Profile profile1 = [Select Id from Profile where name = 'System Administrator'];
          User portalAccountOwner2 = new User(
          UserRoleId = portalRole.Id,
          ProfileId = profile1.Id,
          Username ='testproddetail'+Math.random()+'@test.com',
          Alias = 'batman',
          Email='bruce.wayne@wayneenterprises.com',
          EmailEncodingKey='UTF-8',
          Firstname='Bruce',
          Lastname='Wayne',
          LanguageLocaleKey='en_US',
          LocaleSidKey='en_US',
          TimeZoneSidKey='America/Chicago'
          );
          Database.insert(portalAccountOwner2);
          
          //creating account group..
          ccrz__E_AccountGroup__c accGrp = new ccrz__E_AccountGroup__c(
          Name = 'US/CAN_EBU_SIR_ACCGRP'
          );
          System.runAs(portalAccountOwner2){
              Database.insert(accGrp);
          }
        // Create test account
          Account portalAccount2 = new Account(
          Name = 'TestAccount2',
          OwnerId = portalAccountOwner2.Id,
          OSM_Preferred_Billing_Frequency_Lock__c=false,
          BMS_Customer_ID__c='1234',
          OSM_Preferred_Payment_Method__c='po',
          OSM_Preferred_Payment_IsBolt_PO__c=false,
          ccrz__E_AccountGroup__c=accGrp.id
          );
          
          System.runAs(portalAccountOwner2){
              Database.insert(portalAccount2);
              //inserting custom setting.s
              insert new OSM_Approval_Flow_Account_Groups__c(Account_Group_Name__c = 'US/CAN_EBU_SIR_ACCGRP0' , Name='US/CAN_EBU_SIR_ACCGRP0', Product_SKU__c='',Product_SKU_One_time__c='123456-BUS,130129-BUS,SKU-123');
              insert new OSM_Approval_Flow_Products__c(Name='Fleet Count',Product_SKU__c='123456-BUS');

          }

          //Create contact
          Contact contact1 = new Contact(
          FirstName = 'John',
          Lastname = 'Smith',
          IAM_Contact_Status__c='Pending',
          Username__c = 'JohnSmith9980@gmail.com',
          AccountId = portalAccount2.Id,
          Email ='JohnSmith9980@gmail.com'
          );
          System.runAs(portalAccountOwner2){
              Database.insert(contact1);
          } 
          
        //Create community user from contact
          User testUser = new User();
          testUser.FirstName = 'Testttt';
          testUser.LastName = 'lasttt';
          testUser.UserName = 'testproddetail'+Math.random()+'@test.com';//Updated 9/8
          testUser.Email = 'bruce.wayne@wayneenterprises.com';
          testUser.Alias = 'batman';
          testUser.ContactId = contact1.Id;
          testUser.CommunityNickname = 'test12345h';
          testUser.ProfileId =portal_PROFILE_ID;
          testUser.TimeZoneSidKey = 'America/Los_Angeles';
          testUser.isActive = true;
          testUser.LocaleSidKey = 'en_US';
          testUser.LanguageLocaleKey = 'en_US';
          testUser.EmailEncodingKey = 'ISO-8859-1';
            System.runAs(portalAccountOwner2){
                  insert testUser;
            
          }
           System.runAs(portalAccountOwner2) {

            PermissionSet ps = [SELECT Id FROM PermissionSet WHERE Name = 'OSM_Fleet_Admin_CC'];
            ccrz.cc_RemoteActionContext objRemotCtx = new ccrz.cc_RemoteActionContext();
            objRemotCtx.storefront = 'SoftwareStore';
            objRemotCtx.currentCartId = transecRes.cart.ccrz__EncryptedId__c;
            objRemotCtx.portalUserId = testuser.id;
            ccrz.cc_CallContext.initRemoteContext(objRemotCtx);

            ccrz__E_Spec__c spec = new ccrz__E_Spec__c();
            spec.name = 'CA Base';
            spec.imageText__c = 'test';
            spec.ccrz__Sequence__c = 500;
            insert spec;
            Set < String > childProdId = new Set < String > ();
            childProdId.add(transecRes.objSetupDate.compositeProduct.id);

            list < ccrz__E_ProductMedia__c > mlist = new list < ccrz__E_ProductMedia__c > ();
            ccrz__E_ProductMedia__c media = new ccrz__E_ProductMedia__c();
            media.ccrz__MediaType__c = 'Product Image Thumbnail';
            media.ccrz__Product__c = transecRes.objSetupDate.compositeProduct.id;
            mlist.add(media);
            insert mlist;
            
            Attachment att = new Attachment();
            att.name = 'MediaAttachment';
            att.parentId = mlist[0].id;
            att.Body = Blob.valueof('test');
            insert att;
            
            List < String > relatedProductList = new List < String > ();
            //Neha Sharma Code added here
            ccrz__E_RelatedProduct__c rp = new ccrz__E_RelatedProduct__c();
            rp.ccrz__Product__c = transecRes.objSetupDate.compositeProduct.id;
            rp.ccrz__RelatedProduct__c = transecRes.objSetupDate.compositeProduct.id;
            rp.ccrz__RelatedProductType__c = 'Accessories';
            rp.ccrz__EndDate__c = System.today() + 1;
            insert rp;
            
            relatedProductList.add(rp.id);
            ccrz__E_Subscription__c Sub = new ccrz__E_Subscription__c();
            Sub.ccrz__Sequence__c = 3;
            Sub.ccrz__Storefront__c = 'SoftwareStore';
            Sub.ccrz__SubscriptionStartDate__c = System.now().adddays(-2);
            Sub.OSM_Subscription_End_Date__c = System.now().adddays(5);
            Sub.ccrz__SubscriptionStatus__c = 'Active';
            Sub.ccrz__InstallmentLastDate__c = System.now();
            Sub.ccrz__SPT__c = transecRes.objSetupDate.subProdTermList[0].id;
            Sub.OSM_Free_Trial__c = false;
            Sub.ccrz__SubscriptionProduct__c = transecRes.objSetupDate.compositeProduct.Id;
            Sub.ccrz__RecurringPrice__c = 200;
            Sub.ccrz__OrderLastDate__c = System.now() + 10;
            Sub.ccrz__CurrencyISOCode__c = 'USD';
            Sub.ccrz__Quantity__c = 3;
            Sub.ccrz__Account__c = a.id;
            Sub.Subsequent_Next_Invoice_Due_Dt__c = System.now() + 15;
            Sub.Subsequent_Next_Invoice_Generation_Dt__c = System.now() + 15;
            Sub.OSM_Display_Product__c = transecRes.objSetupDate.compositeProduct.id;
            Insert Sub;
               
            ccrz__E_CompositeProduct__c compprod = new ccrz__E_CompositeProduct__c();
            compprod.ccrz__Component__c = transecRes.objSetupDate.compositeProduct.id;
            compprod.ccrz__Composite__c = transecRes.objSetupDate.compositeProduct.id;
            insert compprod;
            String parentId = transecRes.objSetupDate.compositeProduct.id;
            String portalUserId = transecRes.objSetupDate.loggedInUser.id;
            Date relatedDate = System.Today();
            Map < String, Object > jsonMap = new Map < String, Object > ();
            jsonMap.put('parentId', parentId);
            jsonMap.put('portalUserId', portalUserId);
            jsonMap.put('relatedDate', relatedProductList);
            jsonMap.put('renewProd', 'SKU-123');
            String JSONReq = JSON.serialize(jsonMap);
                  
            Map < String, Object > jsonMap2 = new Map < String, Object > ();
            jsonMap2.put('customerComment', 'testing');
            jsonMap2.put('quantityTotal', '1');
            jsonMap2.put('parentId', parentId);
            jsonMap2.put('unitPrice', '2');
            String JSONReq2 = JSON.serialize(jsonMap2);
            System.debug('JSONReq____' + JSONReq2);
            Test.StartTest();
            String successResponse = '{"createWithCoterm":false,"subcQty":"1","unitPrice":2,"monthlyPrice":1,"totalPrice":"7","availableCount":"10","billingFreq":"Monthly","productSkuSelected":"130129-BUS","selectedProdSku":"130129-BUS", "prodSubscriptions":"3","plan":"Pro","rfqDescription":"testing","subProdTermId":"' + transecRes.objSetupDate.subProdTermList[0].Id + '","parentId":"' + transecRes.objSetupDate.compositeProduct.Id + '","userId":"' + transecRes.objSetupDate.objUserID + '","isBundle":' + true + ',"isSubscribed":' + false + ',"relatedProd_selectedProdId":{"a2k3C000000HgVwQAK":[{"sfdcName":"Service Tech Kit 1","price":"3","qtyPerUnit":2,"addOnProPrice":0,"shortDesc":"Guidanz Mobile - 2 UsersINSITE™ Lite - 1 License","productId":"a2k3C000000LskAQAS","productSku":"CG-Lite-004-1","currencySymbol":"$ ","relProdSPT":"a3F3C000000RIO4UAO"}]}}';
            OSM_SW_ProdDetail_SES1_Comp_Ctrl.ProductSpecificationHeader pod = new OSM_SW_ProdDetail_SES1_Comp_Ctrl.ProductSpecificationHeader();
            pod.Id = 'test';
            pod.Value='test'; 
            OSM_SW_ProdDetail_SES1_Comp_Ctrl.ProductDetailWrapper pod1 = new OSM_SW_ProdDetail_SES1_Comp_Ctrl.ProductDetailWrapper();
            pod1.productName = 'test';
            pod1.pricePerLabel='test';
            pod1.pricePerValue = 11;
            pod1.prodSubscriptionPriceMonthly=11;
            pod1.prodSubscriptionPriceYearly = 11;
            pod1.subscriptionLength=new Map<String,Integer>();
            pod1.subscriptionBillingfrequency=new Map<String,Integer>();
            
            OSM_SW_ProdDetail_SES1_Comp_Ctrl.UserDetail pod11 = new OSM_SW_ProdDetail_SES1_Comp_Ctrl.UserDetail();
            pod11.fName = 'test';
            pod11.lName='test';
            pod11.email = 'test';
            pod11.phone='test';
            pod11.strAddress = 'test';
            pod11.company='test';
            pod11.contactId='test';
            pod11.requestedDate='test';
            // Call Apex Class Methods
            OSM_SW_ProdDetail_SES1_Comp_Ctrl.WarningMsg(objRemotCtx, '123456-bus');
            OSM_SW_ProdDetail_SES1_Comp_Ctrl.submitRequestForApproval(objRemotCtx, JSONReq2);
            List<CC_Request_for_Approval__c> req = [SELECT Id, Product_Name__c,Request_Status__c FROM CC_Request_for_Approval__c];
               System.debug('req: ' + req);
               req[0].Request_Status__c = 'Approval Revoked';
               update req;
            OSM_SW_ProdDetail_SES1_Comp_Ctrl.accountIdTest = transecRes.objSetupDate.account.Id;
            ccrz.cc_RemoteActionResult res = OSM_SW_ProdDetail_SES1_Comp_Ctrl.fetchProdDetailInfoForDA(objRemotCtx, JSONReq);
			System.assert(res.data != null);          
            
            test.StopTest();
        }
    }
    
    // Method:	singleApprovalTest
    // Purpose:	test the single approval flow where a Request for Approval has not been created yet.
    
    static testMethod void singleApproval_NoApprovalRequest() {

        User loggedInUser = [Select id from User where id =: UserInfo.getUserId()];
        TestProductSetupReq testReq = new TestProductSetupReq();
        testReq.permissionSetName = 'OSM_Support_Admin';
        testReq.accountGroupName = 'US/CAN_EBU_SIR_ACCGRP';
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
        ccrz__E_Product__c prod = transecRes.objSetupDate.componentList[0];
        Account a = transecRes.objSetupDate.account;
        Contact c = transecRes.objSetupDate.contact;
        Set < String > idSet = new Set < String > ();
        idSet.add(prod.id);

        System.debug('transecRes: ' + transecRes);

        // Creating Cart
       // List<ccrz__E_Cart__c> lstECart = TestingUtils.CreateCart(1, 'SoftwareStore', 'Cart', objUser.Id, true, 'Open', true);
          Id portal_PROFILE_ID = [SELECT Id FROM Profile WHERE Name = 'IAM_Site_Admin_Community' Limit 1 ].Id;
          //Id roleId=[select id,name from UserRole where name='CumminsFleetsCustomerUser' limit 1].id; 
           
         UserRole portalRole = [Select Id From UserRole Where PortalType = 'None' Limit 1];
          system.debug('portalRole is ' + portalRole);

          Profile profile1 = [Select Id from Profile where name = 'System Administrator'];
          User portalAccountOwner2 = new User(
          UserRoleId = portalRole.Id,
          ProfileId = profile1.Id,
          Username ='testproddetail'+Math.random()+'@test.com',
          Alias = 'batman',
          Email='bruce.wayne@wayneenterprises.com',
          EmailEncodingKey='UTF-8',
          Firstname='Bruce',
          Lastname='Wayne',
          LanguageLocaleKey='en_US',
          LocaleSidKey='en_US',
          TimeZoneSidKey='America/Chicago'
          );
          Database.insert(portalAccountOwner2);
          
          //creating account group..
          ccrz__E_AccountGroup__c accGrp = new ccrz__E_AccountGroup__c(
          Name = 'US/CAN_EBU_SIR_ACCGRP'
          );
          System.runAs(portalAccountOwner2){
              Database.insert(accGrp);
          }
        // Create test account
          Account portalAccount2 = new Account(
          Name = 'TestAccount2',
          OwnerId = portalAccountOwner2.Id,
          OSM_Preferred_Billing_Frequency_Lock__c=false,
          BMS_Customer_ID__c='1234',
          OSM_Preferred_Payment_Method__c='po',
          OSM_Preferred_Payment_IsBolt_PO__c=false,
          ccrz__E_AccountGroup__c=accGrp.id
          );
          
          System.runAs(portalAccountOwner2){
              Database.insert(portalAccount2);
              //inserting custom setting.s
              insert new OSM_Approval_Flow_Account_Groups__c(Account_Group_Name__c = 'US/CAN_EBU_SIR_ACCGRP0' , Name='US/CAN_EBU_SIR_ACCGRP0', Product_SKU__c='',Product_SKU_One_time__c='123456-BUS,130129-BUS,SKU-123');
              insert new OSM_Approval_Flow_Products__c(Name='Fleet Count',Product_SKU__c='123456-BUS');

          }

          //Create contact
          Contact contact1 = new Contact(
          FirstName = 'John',
          Lastname = 'Smith',
          IAM_Contact_Status__c='Pending',
          Username__c = 'JohnSmith9980@gmail.com',
          AccountId = portalAccount2.Id,
          Email ='JohnSmith9980@gmail.com'
          );
          System.runAs(portalAccountOwner2){
              Database.insert(contact1);
          } 
          
        //Create community user from contact
          User testUser = new User();
          testUser.FirstName = 'Testttt';
          testUser.LastName = 'lasttt';
          testUser.UserName = 'testproddetail'+Math.random()+'@test.com';
          testUser.Email = 'bruce.wayne@wayneenterprises.com';
          testUser.Alias = 'batman';
          testUser.ContactId = contact1.Id;
          testUser.CommunityNickname = 'test12345h';
          testUser.ProfileId =portal_PROFILE_ID;
          testUser.TimeZoneSidKey = 'America/Los_Angeles';
          testUser.isActive = true;
          testUser.LocaleSidKey = 'en_US';
          testUser.LanguageLocaleKey = 'en_US';
          testUser.EmailEncodingKey = 'ISO-8859-1';
            System.runAs(portalAccountOwner2){
                  insert testUser;
            
          }
           System.runAs(portalAccountOwner2) {

            PermissionSet ps = [SELECT Id FROM PermissionSet WHERE Name = 'OSM_Fleet_Admin_CC'];
            ccrz.cc_RemoteActionContext objRemotCtx = new ccrz.cc_RemoteActionContext();
            objRemotCtx.storefront = 'SoftwareStore';
            objRemotCtx.currentCartId = transecRes.cart.ccrz__EncryptedId__c;
            objRemotCtx.portalUserId = testuser.id;
            ccrz.cc_CallContext.initRemoteContext(objRemotCtx);

            ccrz__E_Spec__c spec = new ccrz__E_Spec__c();
            spec.name = 'CA Base';
            spec.imageText__c = 'test';
            spec.ccrz__Sequence__c = 500;
            insert spec;
            Set < String > childProdId = new Set < String > ();
            childProdId.add(transecRes.objSetupDate.compositeProduct.id);

            list < ccrz__E_ProductMedia__c > mlist = new list < ccrz__E_ProductMedia__c > ();
            ccrz__E_ProductMedia__c media = new ccrz__E_ProductMedia__c();
            media.ccrz__MediaType__c = 'Product Image Thumbnail';
            media.ccrz__Product__c = transecRes.objSetupDate.compositeProduct.id;
            mlist.add(media);
            insert mlist;
            
            Attachment att = new Attachment();
            att.name = 'MediaAttachment';
            att.parentId = mlist[0].id;
            att.Body = Blob.valueof('test');
            insert att;
            
            List < String > relatedProductList = new List < String > ();
            //Neha Sharma Code added here
            ccrz__E_RelatedProduct__c rp = new ccrz__E_RelatedProduct__c();
            rp.ccrz__Product__c = transecRes.objSetupDate.compositeProduct.id;
            rp.ccrz__RelatedProduct__c = transecRes.objSetupDate.compositeProduct.id;
            rp.ccrz__RelatedProductType__c = 'Accessories';
            rp.ccrz__EndDate__c = System.today() + 1;
            insert rp;
            
            relatedProductList.add(rp.id);
            ccrz__E_Subscription__c Sub = new ccrz__E_Subscription__c();
            Sub.ccrz__Sequence__c = 3;
            Sub.ccrz__Storefront__c = 'SoftwareStore';
            Sub.ccrz__SubscriptionStartDate__c = System.now().adddays(-2);
            Sub.OSM_Subscription_End_Date__c = System.now().adddays(5);
            Sub.ccrz__SubscriptionStatus__c = 'Active';
            Sub.ccrz__InstallmentLastDate__c = System.now();
            Sub.ccrz__SPT__c = transecRes.objSetupDate.subProdTermList[0].id;
            Sub.OSM_Free_Trial__c = false;
            Sub.ccrz__SubscriptionProduct__c = transecRes.objSetupDate.compositeProduct.Id;
            Sub.ccrz__RecurringPrice__c = 200;
            Sub.ccrz__OrderLastDate__c = System.now() + 10;
            Sub.ccrz__CurrencyISOCode__c = 'USD';
            Sub.ccrz__Quantity__c = 3;
            Sub.ccrz__Account__c = a.id;
            Sub.Subsequent_Next_Invoice_Due_Dt__c = System.now() + 15;
            Sub.Subsequent_Next_Invoice_Generation_Dt__c = System.now() + 15;
            Sub.OSM_Display_Product__c = transecRes.objSetupDate.compositeProduct.id;
            Insert Sub;
               
            ccrz__E_CompositeProduct__c compprod = new ccrz__E_CompositeProduct__c();
            compprod.ccrz__Component__c = transecRes.objSetupDate.compositeProduct.id;
            compprod.ccrz__Composite__c = transecRes.objSetupDate.compositeProduct.id;
            insert compprod;
            String parentId = transecRes.objSetupDate.compositeProduct.id;
            String portalUserId = transecRes.objSetupDate.loggedInUser.id;
            Date relatedDate = System.Today();
            Map < String, Object > jsonMap = new Map < String, Object > ();
            jsonMap.put('parentId', parentId);
            jsonMap.put('portalUserId', portalUserId);
            jsonMap.put('relatedDate', relatedProductList);
            jsonMap.put('renewProd', 'SKU-123');
            String JSONReq = JSON.serialize(jsonMap);
                  
            Map < String, Object > jsonMap2 = new Map < String, Object > ();
            jsonMap2.put('customerComment', 'testing');
            jsonMap2.put('quantityTotal', '1');
            jsonMap2.put('parentId', parentId);
            jsonMap2.put('unitPrice', '2');
            String JSONReq2 = JSON.serialize(jsonMap2);
            System.debug('JSONReq____' + JSONReq2);
            Test.StartTest();
            String successResponse = '{"createWithCoterm":false,"subcQty":"1","unitPrice":2,"monthlyPrice":1,"totalPrice":"7","availableCount":"10","billingFreq":"Monthly","productSkuSelected":"130129-BUS","selectedProdSku":"130129-BUS", "prodSubscriptions":"3","plan":"Pro","rfqDescription":"testing","subProdTermId":"' + transecRes.objSetupDate.subProdTermList[0].Id + '","parentId":"' + transecRes.objSetupDate.compositeProduct.Id + '","userId":"' + transecRes.objSetupDate.objUserID + '","isBundle":' + true + ',"isSubscribed":' + false + ',"relatedProd_selectedProdId":{"a2k3C000000HgVwQAK":[{"sfdcName":"Service Tech Kit 1","price":"3","qtyPerUnit":2,"addOnProPrice":0,"shortDesc":"Guidanz Mobile - 2 UsersINSITE™ Lite - 1 License","productId":"a2k3C000000LskAQAS","productSku":"CG-Lite-004-1","currencySymbol":"$ ","relProdSPT":"a3F3C000000RIO4UAO"}]}}';
            OSM_SW_ProdDetail_SES1_Comp_Ctrl.ProductSpecificationHeader pod = new OSM_SW_ProdDetail_SES1_Comp_Ctrl.ProductSpecificationHeader();
            pod.Id = 'test';
            pod.Value='test'; 
            OSM_SW_ProdDetail_SES1_Comp_Ctrl.ProductDetailWrapper pod1 = new OSM_SW_ProdDetail_SES1_Comp_Ctrl.ProductDetailWrapper();
            pod1.productName = 'test';
            pod1.pricePerLabel='test';
            pod1.pricePerValue = 11;
            pod1.prodSubscriptionPriceMonthly=11;
            pod1.prodSubscriptionPriceYearly = 11;
            pod1.subscriptionLength=new Map<String,Integer>();
            pod1.subscriptionBillingfrequency=new Map<String,Integer>();
            
            OSM_SW_ProdDetail_SES1_Comp_Ctrl.UserDetail pod11 = new OSM_SW_ProdDetail_SES1_Comp_Ctrl.UserDetail();
            pod11.fName = 'test';
            pod11.lName='test';
            pod11.email = 'test';
            pod11.phone='test';
            pod11.strAddress = 'test';
            pod11.company='test';
            pod11.contactId='test';
            pod11.requestedDate='test';
            // Call Apex Class Methods
            OSM_SW_ProdDetail_SES1_Comp_Ctrl.WarningMsg(objRemotCtx, '123456-bus');
            OSM_SW_ProdDetail_SES1_Comp_Ctrl.submitRequestForApproval(objRemotCtx, JSONReq2);
            List<CC_Request_for_Approval__c> req = [SELECT Id, Product_Name__c,Request_Status__c FROM CC_Request_for_Approval__c];
            System.debug('req: ' + req);
            req[0].Request_Status__c = 'Order Cancelled';
               update req;
            OSM_SW_ProdDetail_SES1_Comp_Ctrl.accountIdTest = transecRes.objSetupDate.account.Id;
            ccrz.cc_RemoteActionResult res = OSM_SW_ProdDetail_SES1_Comp_Ctrl.fetchProdDetailInfoForDA(objRemotCtx, JSONReq);
			System.assert(res.data != null);          
            
            test.StopTest();
        }
    }
    //LL-33/LL-34/LL-35 Code End
    
   
}