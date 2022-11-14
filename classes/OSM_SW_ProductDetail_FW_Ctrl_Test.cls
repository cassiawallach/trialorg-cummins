// 22/Jul/21 MAR-1861 Subbu K
// MP-135 Updated -18-11-2021
// MP-337 Updated -19-11-2021
@isTest
public class OSM_SW_ProductDetail_FW_Ctrl_Test {

 
    
    @testSetup
    static void setup(){
        ccrz__E_Product__c prod = new ccrz__E_Product__c();
        prod.name = 'Test Prod 1';
        prod.ccrz__productStatus__c = 'Released';
        prod.ccrz__Quantityperunit__c = 1;
        prod.ccrz__SKU__c = 'NGEOK-B-1';
        prod.ccrz__StartDate__c = System.today().addMonths(-1);
        prod.ccrz__EndDate__c = System.today().addMonths(4);
        prod.Group_Name__c = 'FluidWatch';
        prod.ccrz__LongDesc__c = 'Long Description';
        prod.ccrz__productType__c = 'Aggregated';
        prod.product_Class_Code__c = 'Fluidwatch';
        prod.Rule1__c = 25;
        prod.Rule2__c = 50;
        insert prod;
        
        ccrz__E_Product__c prod1 = new ccrz__E_Product__c();
        prod1.name = 'Test Prod 2';
        prod1.ccrz__productStatus__c = 'Released';
        prod1.ccrz__Quantityperunit__c = 1;
        prod1.ccrz__SKU__c = 'NGEOK-B-1-F1';
        prod1.ccrz__StartDate__c = System.today().addMonths(-1);
        prod1.ccrz__EndDate__c = System.today().addMonths(4);
        prod1.Group_Name__c = 'FluidWatch';
        prod1.ccrz__LongDesc__c = 'Long Description';
        prod1.ccrz__productType__c = 'Bundle';
        prod1.product_Class_Code__c = 'Fluidwatch';
        prod1.Rule1__c = 25;
        prod1.Rule2__c = 50;
        insert prod1;
        
        ccrz__E_Product__c prod2 = new ccrz__E_Product__c();
        prod2.name = 'Test Prod 3';
        prod2.ccrz__productStatus__c = 'Released';
        prod2.ccrz__Quantityperunit__c = 1;
        prod2.ccrz__SKU__c = 'NGEOK-C-1';
        prod2.ccrz__StartDate__c = System.today().addMonths(-1);
        prod2.ccrz__EndDate__c = System.today().addMonths(4);
        prod2.Group_Name__c = 'FluidWatch';
        prod2.ccrz__LongDesc__c = 'Long Description';
        prod2.ccrz__productType__c = 'Aggregated';
        prod2.product_Class_Code__c = 'Fluidwatch';
        prod2.ccrz__ShortDescRT__c = 'short';
        prod2.Rule1__c = 25;
        prod2.Rule2__c = 50;
        insert prod2;

        ccrz__E_PriceList__c testPriceList = new ccrz__E_PriceList__c();
        testPriceList.Name = 'testPrice';
        testPriceList.ccrz__CurrencyISOCode__c = 'USD';
        testPriceList.ccrz__Enabled__c = true;
        testPriceList.ccrz__Storefront__c = 'SoftwareStore';
        insert testPriceList;
        
        ccrz__E_PriceListItem__c priclelistItem = new ccrz__E_PriceListItem__c();
        priclelistItem.ccrz__Product__c = prod1.id;
        priclelistItem.ccrz__Pricelist__c = testPriceList.id;
        insert priclelistItem;
        
        
        list < ccrz__E_ProductMedia__c > mlist = new list < ccrz__E_ProductMedia__c > ();
        ccrz__E_ProductMedia__c media = new ccrz__E_ProductMedia__c();
        media.ccrz__MediaType__c = 'Product Image Thumbnail';
        media.ccrz__Product__c = prod1.id;
        mlist.add(media);
        
        ccrz__E_ProductMedia__c media1 = new ccrz__E_ProductMedia__c();
        media1.ccrz__MediaType__c = 'Product Image Thumbnail';
        media1.ccrz__Product__c = prod2.id;
        mlist.add(media1);
        
        insert mlist;
        
        Attachment att = new Attachment();
        att.name = 'MediaAttachment';
        att.parentId = mlist[0].id;
        att.Body = Blob.valueof('test');
        insert att;
        
        Attachment att1 = new Attachment();
        att1.name = 'MediaAttachment';
        att1.parentId = mlist[1].id;
        att1.Body = Blob.valueof('test');
        insert att1;
        
        ccrz__E_RelatedProduct__c rp = new ccrz__E_RelatedProduct__c();
        rp.ccrz__Product__c = prod.id;
        rp.ccrz__RelatedProduct__c = prod2.id;
        rp.ccrz__RelatedProductType__c = 'Accessories';
        rp.ccrz__EndDate__c = System.today() + 1;
        insert rp;
        
        ccrz__E_RelatedProduct__c rp1 = new ccrz__E_RelatedProduct__c();
        rp1.ccrz__Product__c = prod1.id;
        rp1.ccrz__RelatedProduct__c = prod2.id;
        rp1.ccrz__RelatedProductType__c = 'Accessories';
        rp1.ccrz__EndDate__c = System.today() + 1;
        insert rp1;

        ccrz__E_CompositeProduct__c compprod = new ccrz__E_CompositeProduct__c();
        compprod.ccrz__Component__c = prod2.id;
        compprod.ccrz__Composite__c = prod.id;
        insert compprod;
    }
    
    static testMethod void tetsMethod1() {
        User loggedInUser = [Select id from User where id =: UserInfo.getUserId()];
        Set < String > idSet = new Set < String > ();
        Id portal_PROFILE_ID = [SELECT Id FROM Profile WHERE Name = 'IAM_Site_Admin_Community' Limit 1 ].Id;
           
        UserRole portalRole = [Select Id From UserRole Where PortalType = 'None' Limit 1];
        system.debug('portalRole is ' + portalRole);

        Profile profile1 = [Select Id from Profile where name = 'System Administrator'];
        User portalAccountOwner2 = new User(
            UserRoleId = portalRole.Id,
            ProfileId = profile1.Id,
            Username ='test24446@test.com',
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
            OSM_Preferred_Payment_Method__c='cc',
            OSM_Preferred_Payment_IsBolt_PO__c=false,
            ccrz__E_AccountGroup__c=accGrp.id
        );
          
        System.runAs(portalAccountOwner2){
            Database.insert(portalAccount2);
        }

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
          testUser.UserName = 'test2@test.com';
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

        // Creating address
        System.runAs(portalAccountOwner2) {
            PermissionSet ps = [SELECT Id FROM PermissionSet WHERE Name = 'OSM_Fleet_Admin_CC'];
            ccrz__E_Product__c prod = [SELECT Id FROM ccrz__E_Product__c WHERE ccrz__SKU__c = 'NGEOK-B-1'];
            ccrz__E_Product__c prod1 = [SELECT Id FROM ccrz__E_Product__c WHERE ccrz__productType__c != 'Aggregated'];
            ccrz__E_Product__c prod2 = [SELECT Id FROM ccrz__E_Product__c WHERE ccrz__SKU__c = 'NGEOK-C-1'];
            ccrz__E_Cart__c cart = new ccrz__E_Cart__c();
            cart.ccrz__Name__c = 'Test Cart';
            cart.ccrz__EncryptedId__c = 'b1db8041-b381-44be-bb01-c2d65066bab7';
            cart.ccrz__Storefront__c = 'SoftwareStore';
            cart.ccrz__Account__c = portalAccount2.Id;
            cart.ccrz__CartStatus__c = 'Open';
            cart.ccrz__CartType__c = 'Cart';
            cart.ccrz__ActiveCart__c = true;
            cart.ccrz__Contact__c = contact1.Id;
            insert cart;
            
            ccrz__E_CartItem__c cartItm = new ccrz__E_CartItem__c();
            cartItm.ccrz__DisplayProduct__c = prod.Id;
            cartItm.ccrz__Product__c = prod2.Id;
            cartItm.ccrz__StoreID__c = 'SoftwareStore';
            cartItm.ccrz__Cart__c = cart.Id;
            cartItm.ccrz__Price__c = 10;
            cartItm.ccrz__Quantity__c = 2;
            insert cartItm;
        
            ccrz.cc_RemoteActionContext objRemotCtx = new ccrz.cc_RemoteActionContext();
            objRemotCtx.storefront = 'SoftwareStore';
            objRemotCtx.portalUserId = testuser.id;
            objRemotCtx.currentCartId = cart.ccrz__EncryptedId__c;

            ccrz.cc_CallContext.initRemoteContext(objRemotCtx);            
            
            String parentId = prod.Id;
            String portalUserId = portalAccountOwner2.Id;
            Date relatedDate = System.Today();
            Map < String, Object > jsonMap = new Map < String, Object > ();
            jsonMap.put('parentId', parentId);
            jsonMap.put('portalUserId', portalUserId);
            String JSONReq = JSON.serialize(jsonMap);

            Map < String, Object > jsonMap2 = new Map < String, Object > ();
            jsonMap2.put('customerComment', 'testing');
            jsonMap2.put('quantityTotal', '1');
            jsonMap2.put('parentId', parentId);
            jsonMap2.put('unitPrice', '2');
            String JSONReq2 = JSON.serialize(jsonMap2);
            System.debug('JSONReq____' + JSONReq2);
            Test.StartTest();
            String successResponse = '{"subcQty":"1","unitPrice":2,"monthlyPrice":1,"totalPrice":"7","availableCount":"10","billingFreq":"Monthly","productSkuSelected":"NGEOK-B-1-F1","selectedProdSku":"NGEOK-B-1", "prodSubscriptions":"1","plan":"Pro","rfqDescription":"testing","subProdTermId":"","parentId":"' + prod.Id + '","userId":"' + portalAccountOwner2.Id + '","isBundle":' + true + ',"isSubscribed":' + false + ',"relatedProd_selectedProdId":{}}';
            Apexpages.currentPage().getParameters().put('sku', 'NGEOK-B-1');
            
            OSM_SW_ProductDetail_FW_Ctrl ctrl = new OSM_SW_ProductDetail_FW_Ctrl();
            
            OSM_SW_ProductDetail_FW_Ctrl.UserDetail pod11 = new OSM_SW_ProductDetail_FW_Ctrl.UserDetail();            
            OSM_SW_ProductDetail_FW_Ctrl.accountIdTest = portalAccount2.Id;
            OSM_SW_ProductDetail_FW_Ctrl.fetchProdDetailInfoForDA(objRemotCtx, JSONReq);
            OSM_SW_ProductDetail_FW_Ctrl.WarningMsg(objRemotCtx, 'NGEOK-B-1');
            OSM_SW_ProductDetail_FW_Ctrl.saveCCPackageInClass(objRemotCtx, 'testccdata');
            OSM_SW_ProductDetail_FW_Ctrl.getProductDetail(objRemotCtx, 'NGEOK-B-1-F1');
            test.StopTest();
            /*OSM_SW_ProductDetail_FW_Ctrl.addToCartExternal(objRemotCtx, successResponse);
            OSM_SW_ProductDetail_FW_Ctrl.getUserCartItem(objRemotCtx.currentCartId, (string)prod.id, new set<string>{prod1.id}, 'SoftwareStore', contact1.id);
            OSM_SW_ProductDetail_FW_Ctrl.createNewCart();
            test.StopTest();*/
        }       
    }
    
        static testMethod void tetsMethod1_New() {
        User loggedInUser = [Select id from User where id =: UserInfo.getUserId()];
        Set < String > idSet = new Set < String > ();
        Id portal_PROFILE_ID = [SELECT Id FROM Profile WHERE Name = 'IAM_Site_Admin_Community' Limit 1 ].Id;
           
        UserRole portalRole = [Select Id From UserRole Where PortalType = 'None' Limit 1];
        system.debug('portalRole is ' + portalRole);

        Profile profile1 = [Select Id from Profile where name = 'System Administrator'];
        User portalAccountOwner2 = new User(
            UserRoleId = portalRole.Id,
            ProfileId = profile1.Id,
            Username ='test24446@test.com',
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
            OSM_Preferred_Payment_Method__c='cc',
            OSM_Preferred_Payment_IsBolt_PO__c=false,
            ccrz__E_AccountGroup__c=accGrp.id
        );
          
        System.runAs(portalAccountOwner2){
            Database.insert(portalAccount2);
        }

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
          testUser.UserName = 'test2@test.com';
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

        // Creating address
        System.runAs(portalAccountOwner2) {
            PermissionSet ps = [SELECT Id FROM PermissionSet WHERE Name = 'OSM_Fleet_Admin_CC'];
            ccrz__E_Product__c prod = [SELECT Id FROM ccrz__E_Product__c WHERE ccrz__SKU__c = 'NGEOK-B-1'];
            ccrz__E_Product__c prod1 = [SELECT Id FROM ccrz__E_Product__c WHERE ccrz__productType__c != 'Aggregated'];
            ccrz__E_Product__c prod2 = [SELECT Id FROM ccrz__E_Product__c WHERE ccrz__SKU__c = 'NGEOK-C-1'];
            ccrz__E_Cart__c cart = new ccrz__E_Cart__c();
            cart.ccrz__Name__c = 'Test Cart';
            cart.ccrz__EncryptedId__c = 'b1db8041-b381-44be-bb01-c2d65066bab7';
            cart.ccrz__Storefront__c = 'SoftwareStore';
            cart.ccrz__Account__c = portalAccount2.Id;
            cart.ccrz__CartStatus__c = 'Open';
            cart.ccrz__CartType__c = 'Cart';
            cart.ccrz__ActiveCart__c = true;
            cart.ccrz__Contact__c = contact1.Id;
            insert cart;
            
            ccrz__E_CartItem__c cartItm = new ccrz__E_CartItem__c();
            cartItm.ccrz__DisplayProduct__c = prod.Id;
            cartItm.ccrz__Product__c = prod2.Id;
            cartItm.ccrz__StoreID__c = 'SoftwareStore';
            cartItm.ccrz__Cart__c = cart.Id;
            cartItm.ccrz__Price__c = 10;
            cartItm.ccrz__Quantity__c = 2;
            insert cartItm;
        
            ccrz.cc_RemoteActionContext objRemotCtx = new ccrz.cc_RemoteActionContext();
            objRemotCtx.storefront = 'SoftwareStore';
            objRemotCtx.portalUserId = testuser.id;
            objRemotCtx.currentCartId = cart.ccrz__EncryptedId__c;

            ccrz.cc_CallContext.initRemoteContext(objRemotCtx);            
            
            String parentId = prod.Id;
            String portalUserId = portalAccountOwner2.Id;
            Date relatedDate = System.Today();
            Map < String, Object > jsonMap = new Map < String, Object > ();
            jsonMap.put('parentId', parentId);
            jsonMap.put('portalUserId', portalUserId);
            String JSONReq = JSON.serialize(jsonMap);

            Map < String, Object > jsonMap2 = new Map < String, Object > ();
            jsonMap2.put('customerComment', 'testing');
            jsonMap2.put('quantityTotal', '1');
            jsonMap2.put('parentId', parentId);
            jsonMap2.put('unitPrice', '2');
            String JSONReq2 = JSON.serialize(jsonMap2);
            System.debug('JSONReq____' + JSONReq2);
            Test.StartTest();
            String successResponse = '{"subcQty":"1","unitPrice":2,"monthlyPrice":1,"totalPrice":"7","availableCount":"10","billingFreq":"Monthly","productSkuSelected":"NGEOK-B-1-F1","selectedProdSku":"NGEOK-B-1", "prodSubscriptions":"1","plan":"Pro","rfqDescription":"testing","subProdTermId":"","parentId":"' + prod.Id + '","userId":"' + portalAccountOwner2.Id + '","isBundle":' + true + ',"isSubscribed":' + false + ',"relatedProd_selectedProdId":{}}';
            Apexpages.currentPage().getParameters().put('sku', 'NGEOK-B-1');
            
            OSM_SW_ProductDetail_FW_Ctrl ctrl = new OSM_SW_ProductDetail_FW_Ctrl();
            
            OSM_SW_ProductDetail_FW_Ctrl.addToCartExternal(objRemotCtx, successResponse);
            OSM_SW_ProductDetail_FW_Ctrl.getUserCartItem(objRemotCtx.currentCartId, (string)prod.id, new set<string>{prod1.id}, 'SoftwareStore', contact1.id);
            OSM_SW_ProductDetail_FW_Ctrl.createNewCart();
            test.StopTest();
        }       
    }
    
    static testMethod void tetsMethod2() {
        OSM_SW_ProductDetail_FW_Ctrl.SubProdTerm subProd = new OSM_SW_ProductDetail_FW_Ctrl.SubProdTerm();
        subProd.sfId = 'assd';
        subProd.nonRecurringPriceListId = 'assd';
        subProd.nonRecurringPriceListItemId = 'assd';
        subProd.recurringPriceListId = 'assd';
        subProd.recurringPriceListItemId = 'assd';
        subProd.nonRecurringPrice = 1.0;
        subProd.recurringPrice = 1.0;
        OSM_SW_ProductDetail_FW_Ctrl.UserDetail usrDetail = new OSM_SW_ProductDetail_FW_Ctrl.UserDetail();
        usrDetail.fName = 's';
        usrDetail.lName = 's';
        usrDetail.email = 's@test.com';
        usrDetail.phone = 's';
        usrDetail.strAddress = 's';
        usrDetail.company = 's';
        usrDetail.contactId = 's';
        usrDetail.requestedDate = 's';
        OSM_SW_ProductDetail_FW_Ctrl.AddOnProducts addOn = new OSM_SW_ProductDetail_FW_Ctrl.AddOnProducts();
        addOn.quantity = 1;
        addOn.Prices = 1.0;
        addOn.TotalPrice = 1.0;
        addOn.productId = 'abc';
        addOn.productName = 'ads';
        addOn.productSku = 'addw';
        addOn.productShortDesc = 'serv vweef';
        addOn.supportingText = 'ww';
        addOn.bundleCount = 1;
        OSM_SW_ProductDetail_FW_Ctrl.FreeTrialDetails freeTrial=new OSM_SW_ProductDetail_FW_Ctrl.FreeTrialDetails();            
        freeTrial.maximumQty=0;
        freeTrial.freeDays=0;
        freeTrial.productId='';
        OSM_SW_ProductDetail_FW_Ctrl.ProductDetailWrapper prodWrap = new OSM_SW_ProductDetail_FW_Ctrl.ProductDetailWrapper();
        prodWrap.productName = 'q';
        prodWrap.sfId = 'q';
        prodWrap.buttonName = 'q';
        prodWrap.sku = 'q';
        prodWrap.longDesc = 'q';
        prodWrap.pricePerLabel = 'q';
        prodWrap.pricePerValue = 1.0;
        prodWrap.prodSubscriptionPriceMonthly = 1.0;
        prodWrap.prodSubscriptionPriceYearly = 1.0;
        prodWrap.selectedPowerGenProduct = true;
        //prodWrap.subProdTermMap = new Map<String,SubProdTerm>();
        prodWrap.subscriptionLength = new Map<String,Integer>();
        prodWrap.subscriptionBillingfrequency = new Map<String,Integer>();
        OSM_SW_ProductDetail_FW_Ctrl.ProductSpecificationHeader prdSpec = new OSM_SW_ProductDetail_FW_Ctrl.ProductSpecificationHeader();
        prdSpec.Id = 'q';
        prdSpec.Value = 'q';
        OSM_SW_ProductDetail_FW_Ctrl.MainWrapper mainW = new OSM_SW_ProductDetail_FW_Ctrl.MainWrapper();
        mainW.isFreeTrialAvailabel = true;
        mainW.sortSubsLength = new List<OSM_SW_ProductDetailCommonUtility.SortWrapper>();
        mainW.ShowRequestForApprovalButton = true;
        mainW.DAExceptionFlag = true;
        mainW.isRFQ = true;
        mainW.isOneTimeFrequency = true;
        mainW.showFinalInlineMessage = true;
        mainW.showReRequestForApproval = true;
        mainW.pendingForApprovalMsg = true;
        mainW.GOMSUser = true;
        mainW.GOMSPriceMsg = true;      
        mainW.productTnCLink = 'q';
        mainW.relatedProductSubscEndDate = 'q';
    }
}