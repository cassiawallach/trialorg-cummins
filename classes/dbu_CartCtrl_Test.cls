/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 07-19-2022
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
@isTest
public class dbu_CartCtrl_Test { 
     
    @testSetup static void testSetup() {
        ccrz__E_PriceList__c objTestPriceList = dbu_FactoryDataTest.createPriceList('Test Price List');
        objTestPriceList.ccrz__CurrencyISOCode__c = 'US';
        insert objTestPriceList;
        Account objAcc = new Account(Name = 'Test Acc', BillingCity = 'Sunnyvale', Billingstate = 'California', BillingPostalCode = '94085', BillingCountry = 'United States', BillingStreet = '330 Potrero', ShippingStreet= 'Sunnyvale', shippingCity = 'Sunnyvale', ShippingState = 'California', shippingPostalCode = '94085', shippingCountry = 'United States');
         insert objAcc;
        ccrz__E_ContactAddr__c objShipTo = new ccrz__E_ContactAddr__c(ccrz__FirstName__c = 'TestFirstName',ccrz__LastName__c = 'TestLastName', ccrz__State__c = 'California', ccrz__City__c = 'Sunnyvale', ccrz__Country__c = 'United States',ccrz__PostalCode__c = '94085');
            insert objShipTo;
        ccrz__E_ContactAddr__c objBillTo = new ccrz__E_ContactAddr__c(ccrz__FirstName__c = 'TestFirstName',ccrz__LastName__c = 'TestLastName', ccrz__State__c = 'California', ccrz__City__c = 'Sunnyvale', ccrz__Country__c = 'United States',ccrz__PostalCode__c = '94085');
            insert objBillTo;
        ccrz__E_Cart__c objCart = new ccrz__E_Cart__c(dbu_Cart_StoreCountry__c = 'US', ccrz__CartStatus__c = 'Open', ccrz__CartType__c = 'Cart', ccrz__ActiveCart__c = true, ccrz__TotalDiscount__c = 100.00, ccrz__Name__c = 'Test Cart', ccrz__Storefront__c = 'CSSNAStore', ccrz__Account__c = objAcc.Id, ccrz__ShipTo__c = objShipTo.Id);
            insert objCart;//Upsert
         ccrz__E_Cart__c objCartupdate = new ccrz__E_Cart__c(dbu_Cart_StoreCountry__c = 'US', ccrz__CartStatus__c = 'Open', ccrz__CartType__c = 'Cart', ccrz__ActiveCart__c = true, ccrz__TotalDiscount__c = 100.00, ccrz__Name__c = 'CartUpdate', ccrz__Storefront__c = 'CSSNAStore', ccrz__Account__c = objAcc.Id, ccrz__ShipTo__c = objShipTo.Id);
            insert objCartupdate;//Upsert 
       
        
        ccrz__E_Product__c objProduct = new ccrz__E_Product__c(dbu_Has_Core_Charge__c = true, Name = 'Test Product', ccrz__SKU__c = 'Abcdef-5', ccrz__Storefront__c = 'Storefront', ccrz__StartDate__c = date.newInstance(2020,05,22), ccrz__EndDate__c = date.newInstance(2099,05,22), ccrz__ProductType__c = 'Product');
        insert objProduct;

        
        ccrz__E_ProductMedia__c objProductMedia = dbu_FactoryDataTest.createProductMedia(objProduct.Id, 'Product Search Image');
        insert objProductMedia;
        ccrz__E_PriceListItem__c objPriceListItem = dbu_FactoryDataTest.createPriceListItem('Test Item', 100, 20, 'Absolute', 200, objProduct.Id, objTestPriceList.Id);
        insert objPriceListItem;
        
        ccrz__E_ProductInventoryItem__c objProdInv = dbu_FactoryDataTest.createProductInventoryItem('Test Env', objProduct.Id, 10, 'Test', 'In Stock');
        insert objProdInv;
        ccrz__E_CartItem__c objccCartItem = new ccrz__E_CartItem__c(ccrz__ProductType__c = 'Product', ccrz__UnitOfMeasure__c = 'Each', ccrz__StoreID__c = 'CSSNAStore',ccrz__RequestDate__c = Date.today(),ccrz__OriginalItemPrice__c = 100.00, ccrz__OriginalQuantity__c = 1.00, ccrz__Cart__c = objCart.Id, ccrz__Quantity__c= 4.00, ccrz__Product__c = objProduct.Id, ccrz__Price__c = 100.00, ccrz__SubAmount__c = 400.00);
            insert objccCartItem;
        ccrz__E_Product__c objProduct1 = new ccrz__E_Product__c(dbu_Has_Core_Charge__c = true, Name = 'Test Product', ccrz__SKU__c = 'Abcdeef-5', ccrz__Storefront__c = 'Storefront',   ccrz__StartDate__c = date.newInstance(2020,05,22), ccrz__EndDate__c = date.newInstance(2099,05,22), ccrz__ProductType__c = 'Product',dbu_Pick_Up_Only__c = true,dbu_Available_to_ship__c=true);
        insert objProduct1;
        ccrz__E_PriceListItem__c objPriceListItem1 = dbu_FactoryDataTest.createPriceListItem('Test Item', 100, 20, 'Absolute', 200, objProduct1.Id, objTestPriceList.Id);
        insert objPriceListItem1;
        ccrz__E_RelatedProduct__c objRelatedProduct = dbu_FactoryDataTest.createRelatedProduct(objProduct1.id, objProduct.Id, 'Core Charge'); 
        insert objRelatedProduct;
        
    }
    
    
    static testMethod void unitTest() {
        ///////////
        Account acc = [select id from Account where name = 'Test Acc' Limit 1];
        ccrz__E_Cart__c objCart3 = new ccrz__E_Cart__c(ccrz__CartStatus__c = 'Open', ccrz__CartType__c = 'Cart', ccrz__ActiveCart__c = true, ccrz__TotalDiscount__c = 100.00, ccrz__Name__c = 'Test Cart', ccrz__Storefront__c = 'CSSNAStore',dbu_Cart_StoreCountry__c = 'US');
        insert objCart3;
        List<ccrz__E_Product__c> objProduct = [select Id from ccrz__E_Product__c];
        System.debug('objProduct============='+objProduct);
        List<ccrz__E_PriceList__c> objTestPriceList = [select Id from ccrz__E_PriceList__c];
        ccrz__E_Product__c objProduct1 = new ccrz__E_Product__c(dbu_Has_Core_Charge__c = true, Name = 'Test Product', ccrz__SKU__c = 'Abcdee-5', ccrz__Storefront__c = 'Storefront',    ccrz__StartDate__c = date.newInstance(2020,05,22), ccrz__EndDate__c = date.newInstance(2099,05,22), ccrz__ProductType__c = 'Product', DBU_Product_Location__c = 'CA',dbu_Available_to_ship__c=true,dbu_Pick_Up_Only__c=true);
        insert objProduct1;
        ccrz__E_PriceListItem__c objPriceListItem1 = dbu_FactoryDataTest.createPriceListItem('Test Item', 100, 20, 'Absolute', 200, objProduct1.Id, objTestPriceList[0].Id);
        insert objPriceListItem1;
        ccrz__E_RelatedProduct__c objRelatedProduct = dbu_FactoryDataTest.createRelatedProduct(objProduct1.id, objProduct[0].Id, 'Core Charge'); 
        insert objRelatedProduct;
        //////////
        List<ccrz__E_Cart__c> objCart = [select Id from ccrz__E_Cart__c];
        if(objCart.size() > 0){
            dbu_CartCtrl.fetchLstCartItemsByCartId(objCart[0].Id);
            dbu_CartCtrl.fetchLstCartItemsByCartId(objCart[0].Id,'');
            dbu_CartCtrl.fetchLstCartItemsByCartIdAfterTax(objCart[0].Id);
            dbu_CartCtrl.calculateTax(objCart[0].Id);
            List<ccrz__E_CartItem__c> objCartItem = [select Id from ccrz__E_CartItem__c];
            if(objCartItem.size() > 0){
                dbu_lstCartItemAndCartWrapper objlstCartItemAndCartWrapper = new dbu_lstCartItemAndCartWrapper();
                objlstCartItemAndCartWrapper.cart = objCart[0];
                objlstCartItemAndCartWrapper.lstCartItem = objCartItem;
                String s = JSON.serialize(objlstCartItemAndCartWrapper);
                dbu_CartCtrl.updateCartAndCartItem(s);
                dbu_CartCtrl.deleteCartItem(objCartItem[0].Id, objCart[0].Id);
                dbu_CartCtrl.deleteCartItemOnShopCart(objCartItem[0].Id, objCart[0].Id);
                dbu_CartCtrl.fetchCartSize(objCart[0].Id);
                dbu_CartCtrl.fetchCartId(objCart[0].Id);
                dbu_CartCtrl.fetchLstCartItemsAfterDelete(objCart[0].Id,'');
                dbu_CartCtrl.mergeCart('US',objCart[0].id);
                dbu_CartCtrl.getCartItems(objCart[0].id);

                //dbu_CartCtrl.generateResponse(objCart[0].Id);
            }
            
            if(objProduct.size() > 0){
                            dbu_CartCtrl.getRelatedProductByProductId(objProduct[0].Id);
                            double quantity = 1.00, price = 100.00;
                            String orgId = UserInfo.getOrganizationId();  
                            String dateString =   
                            String.valueof(Datetime.now()).replace(' ','').replace(':','').replace('-','');  
                            Integer randomInt = Integer.valueOf(math.rint(math.random()*1000000));  
                            String uniqueName = orgId + dateString + randomInt;  
                            Profile prof = [select id from profile where name LIKE '%System Administrator%' limit 1];
                            User user = new User(  FirstName = 'test',  
                            LastName = 'test',  
                            email = uniqueName + '@test' + orgId + '.org',  
                            Username = uniqueName + '@test' + orgId + '.org',  
                            EmailEncodingKey = 'ISO-8859-1',  
                            Alias = uniqueName.substring(18, 23),  
                            TimeZoneSidKey = 'America/Los_Angeles',  
                            LocaleSidKey = 'en_US',  
                            LanguageLocaleKey = 'en_US',  
                            ProfileId = prof.Id  
                            );  
                            insert user;
                Test.startTest();
                            system.runAs(user){
                                Map<string,object> storefrontsettings = new Map<string,object>{
                                'Name' => 'CSSNAStore',
                                 'Customer Portal Acct Group Name' => 'PortalAccount',
                                    'Root Category ID' => '999999',
                                    'Customer Portal Account Name' => 'PortalAccount',
                                    'Salesforce Server URL' => 'http://sfserverurl',
                                    'Site Secure Domain' => System.Label.dbu_SiteSecureDomainTestclass,
                                        'E Commerce Type' => 'B2C',
                                        'Cart From Email' => 'Do Not Use Org Wide Email',
                                        'Order From Email' => 'Do Not Use Org Wide Email',
                                        'SEO Title Detail' => 'CloudBurst Direct',
                                        'SEO Keywords' => 'SEO Keywords',
                                        'SEO Description' => 'SEO Description',
                                        'SEO Title Site' => 'B2C Information Technology Sales',
                                        'SearchRank_ExactProductNum' => 700.0,
                                        'SearchRank_inDisplayName' => 200.0,
                                        'SearchRank_inProdNum' => 100.0,
                                        'SearchRank_ShortDesc' => 50.0,
                                        'Dev Mode' => true,
                                        'Allow Anonymous Checkout' => true,
                                        'Quoting Enabled' => true,
                                        'Send Confirmation Email' => true,
                                        'Display Coupon on Cart' => true,
                                        'Filter Orders Based on Owner' => true                  
                                    };
                                   
                                   ccrz.cc_RemoteActionContext ctx = new ccrz.cc_RemoteActionContext();
                                    ctx.storefront = 'CSSNAStore';
                                    ccrz.cc_CallContext.currAccountId = acc.id;
                                    ccrz.cc_CallContext.userCurrency = 'USD';
                                    ccrz.cc_CallContext.effAccountId = acc.id;
                                    //ccrz.cc_CallContext.currCartId = cartID;
                                    ccrz.cc_CallContext.userLocale    = 'en_US';
                                    ccrz.cc_CallContext.isGuest    = false;
                                    //ccrz.cc_CallContext.currContact= cnts;
                                    ccrz.cc_CallContext.storeFrontSettings = storefrontsettings;
                                    ccrz.cc_CallContext.initRemoteContext(ctx);
                                    ///////////
                                    ccrz__E_Cart__c objCart1 = new ccrz__E_Cart__c(ccrz__CartStatus__c = 'Open', ccrz__CartType__c = 'Cart', ccrz__ActiveCart__c = true, ccrz__TotalDiscount__c = 100.00, ccrz__Name__c = 'Test Cart', ccrz__Storefront__c = 'CSSNAStore', ccrz__User__c = user.Id ,dbu_Cart_StoreCountry__c = 'US');
                                insert objCart1;
                                //dbu_CartCtrl.insertCartItem(objProduct[0].Id,objCart[0].Id,price,quantity,'false','US',12);
                                //dbu_CartCtrl.insertCartItem(objProduct[0].Id,objCart[0].Id,price,quantity,'false','US',12);
                                /*28th Jandbu_CartCtrl.insertCartItemForCrateEngine(objProduct[0].Id,objCart[0].Id,price,quantity, null, null, null, null, null, null, null, null, null, null,'US');
                                dbu_CartCtrl.insertCartItemGuestForCrateEngine(objProduct[0].Id,objCart[0].Id,price,quantity, null, null, null, null, null, null, null, null, null, null,'US');
                                */
                                dbu_CartCtrl.generateResponse(objCart[0].Id);
                                 dbu_CartCtrl.insertCartItemGuest(objProduct[0].Id,objCart[0].Id,price,quantity,'US',12,'US');
                                
                                dbu_CartCtrl.updateCartItem(objProduct[0].Id,objCart[0].Id,price,quantity,'US');
                                dbu_CartCtrl.updateCartItemShopCart(objProduct[0].Id,objCart[0].Id,price,quantity,'US');
                                //dbu_CartCtrl.updateCartItemCore(objProduct[0].Id,objCart[0].Id,2.00,'US');
                                dbu_InventoryCheck_Result__c objInventory = new dbu_InventoryCheck_Result__c(API_response__c = 'test', Cart__c =objCart[0].Id, product__c = objProduct[0].Id);
                                insert objInventory;
                                dbu_CartCtrl.checkInventoryAPIInterval(objCart[0].Id);
                                dbu_CartCtrl.updateShippingMethod(true, String.valueOf(objCart[0].Id), String.valueOf(objCartItem[0].Id),String.valueOf(objProduct[0].Id));
                                dbu_CartCtrl.fetchLstCartItemsByCartIdwithStoreLocation(String.valueOf(objCart[0].Id),'', 'US');
                 }
                /*28th Jandbu_CartCtrl.insertCartItem(objProduct[0].Id,objCart[0].Id,price,quantity,'false','US',12);
                dbu_CartCtrl.insertCartItem(objProduct[0].Id,objCart[0].Id,price,quantity,'false','US',12);
                dbu_CartCtrl.insertCartItemGuest(objProduct[0].Id,objCart[0].Id,price,quantity,'US',12);
                dbu_CartCtrl.insertCartItemGuest(objProduct[0].Id,objCart[0].Id,price,quantity,'US',12);
                dbu_CartCtrl.generateResponse(objCart[0].Id);*/
                Test.stopTest();

            }
            
        }
    }
    
    @isTest
    static void testmethod1(){
        Test.startTest();
        List<ccrz__E_Cart__c> objCart = [select Id,dbu_optEmailNotification__c,ccrz__CartStatus__c,ccrz__CartType__c,ccrz__ActiveCart__c,createdDate from ccrz__E_Cart__c];

        system.debug('objCart > ' + objCart[0]);
          List<ccrz__E_CartItem__c> objCartItem = [select Id,ccrz__Product__c from ccrz__E_CartItem__c];
        
      Account acar = [select id from account where name = 'Test Acc'];  
        
        ccrz__E_Cart__c obwjCart = new ccrz__E_Cart__c(dbu_Cart_StoreCountry__c = 'US', ccrz__CartStatus__c = 'Open', ccrz__CartType__c = 'Cart', ccrz__ActiveCart__c = true, ccrz__TotalDiscount__c = 100.00, ccrz__Name__c = 'Tesional Cart', ccrz__Storefront__c = 'CSSNAStore', ccrz__Account__c = acar.Id);
        insert obwjCart;                 

        ccrz__E_Product__c objwProduct = new ccrz__E_Product__c(dbu_Has_Core_Charge__c = true, Name = 'Tesional Product', ccrz__SKU__c = 'Abaaacdef-5', ccrz__Storefront__c = 'Storefront', ccrz__StartDate__c = date.newInstance(2020,05,22), ccrz__EndDate__c = date.newInstance(2099,05,22), ccrz__ProductType__c = 'Product',dbu_Available_to_ship__c=true,dbu_Pick_Up_Only__c=true);
             insert objwProduct;
        
        //create a coupon 
        ccrz__E_Coupon__c CARTCOUPON = new ccrz__E_Coupon__c();
        CARTCOUPON.ccrz__CouponName__c = 'copon for cart';
        CARTCOUPON.ccrz__CouponCode__c = 'T90MBT';
        CARTCOUPON.ccrz__CouponType__c = 'Percentage';
        CARTCOUPON.OSM_Coupon_Discount_Target_Type__c = 'MSRP';
        CARTCOUPON.ccrz__DiscountAmount__c = 10.00;
        CARTCOUPON.ccrz__MaxUse__c = 20000;
        CARTCOUPON.ccrz__Storefront__c = 'CSSNAStore';
        CARTCOUPON.ccrz__DiscountType__c = 'Percentage';
        CARTCOUPON.ccrz__RuleType__c = 'CartTotal';
        CARTCOUPON.ccrz__TotalUsed__c = 0;
        CARTCOUPON.ccrz__StartDate__c = date.parse('9/1/2020');
        CARTCOUPON.ccrz__EndDate__c = date.parse('9/1/2099');  
        insert CARTCOUPON;        
          
            
        ccrz__E_CartCoupon__c appliedCoupon = new ccrz__E_CartCoupon__c();
        appliedCoupon.ccrz__Cart__c = objCart[0].id;
        appliedCoupon.CurrencyIsoCode = 'USD';
        appliedCoupon.Name = 'BOOM';
        appliedCoupon.ccrz__Coupon__c = CARTCOUPON.id;
        insert appliedCoupon;
        system.debug('appliedCoupon 1> ' + appliedCoupon.id + appliedCoupon.ccrz__Cart__c);
        
        ccrz__E_CartCoupon__c appliedCoupon1 = new ccrz__E_CartCoupon__c();
        appliedCoupon1.ccrz__Cart__c = obwjCart.id;
        appliedCoupon1.CurrencyIsoCode = 'USD';
        appliedCoupon1.Name = 'MRBEAN';
        appliedCoupon1.ccrz__Coupon__c = CARTCOUPON.id;
        insert appliedCoupon1;
        system.debug('appliedCoupon 2> ' + appliedCoupon1.id + appliedCoupon1.ccrz__Cart__c);
        
        dbu_CartCtrl.insertCartItemGuest((string)objCartItem[0].ccrz__Product__c ,(string)objCart[0].id , 89, 7, 'US', 88,'US');
        
        dbu_CartCtrl.insertCartItemGuest((string)objwProduct.ID ,(string)obwjCart.id , 79, 8, 'US', 99,'US');
        
        dbu_CartCtrl.insertCartItemGuestForCrateEngine((String)objwProduct.ID,(STRING)obwjCart.ID,87,1,'YUGOSLAVIA','JNA-1992','REPUBLIKA SRPSKA','1992',
                                                                    TRUE,true,true,true,
                                                                    true,true, 'US','US','alabama','');      
        dbu_CartCtrl.updateCartItemCommon((STRING)objCartItem[0].ID,(STRING)objCart[0].Id,67,9, 'US');
        
        dbu_CartCtrl.fetchLstCartItemsByCartIdAfterQuantityUpdate((STRING)objCart[0].Id, '' ); 
        dbu_CartCtrl.checkMarketingEmailFlag((STRING)objCart[0].Id,true);
        dbu_CartCtrl.mergeCart('US',objCart[0].id);
         List<ccrz__E_Cart__c> objCarUpdate = [select Id,dbu_optEmailNotification__c,ccrz__CartStatus__c,ccrz__CartType__c,ccrz__ActiveCart__c,createdDate from ccrz__E_Cart__c where ccrz__Name__c = 'CartUpdate'];
         dbu_CartCtrl.updateCartStatus(objCarUpdate);
        Test.stopTest();
    }   
    
    
    static testMethod void unitTest1() {
        Account acc = [select id from Account where name = 'Test Acc' Limit 1];
        List<ccrz__E_Product__c> objProduct = [select Id,ccrz__SKU__c from ccrz__E_Product__c];
        System.debug('objProduct============='+objProduct); 
        List<ccrz__E_PriceList__c> objTestPriceList = [select Id from ccrz__E_PriceList__c];
        ccrz__E_Product__c objProduct1 = new ccrz__E_Product__c(dbu_Has_Core_Charge__c = true, Name = 'Test Product', ccrz__SKU__c = 'Abcdee-5', ccrz__Storefront__c = 'Storefront',    ccrz__StartDate__c = date.newInstance(2020,05,22), ccrz__EndDate__c = date.newInstance(2099,05,22), ccrz__ProductType__c = 'Product');
        insert objProduct1;
        ccrz__E_PriceListItem__c objPriceListItem1 = dbu_FactoryDataTest.createPriceListItem('Test Item', 100, 20, 'Absolute', 200, objProduct1.Id, objTestPriceList[0].Id);
        insert objPriceListItem1;
        
        List<ccrz__E_Cart__c> objCart;
        //////////
        //List<ccrz__E_Cart__c> objCart = [select Id from ccrz__E_Cart__c];
        //if(objCart.size() > 0){
            
            //if(objProduct.size() > 0){
                            
                            double quantity = 1.00, price = 100.00;
                            String orgId = UserInfo.getOrganizationId();  
                            String dateString =   
                            String.valueof(Datetime.now()).replace(' ','').replace(':','').replace('-','');  
                            Integer randomInt = Integer.valueOf(math.rint(math.random()*1000000));  
                            String uniqueName = orgId + dateString + randomInt;  
                            Profile prof = [select id from profile where name LIKE '%System Administrator%' limit 1];
                            User user = new User(  FirstName = 'test',  
                            LastName = 'test',  
                            email = uniqueName + '@test' + orgId + '.org',  
                            Username = uniqueName + '@test' + orgId + '.org',  
                            EmailEncodingKey = 'ISO-8859-1',  
                            Alias = uniqueName.substring(18, 23),  
                            TimeZoneSidKey = 'America/Los_Angeles',  
                            LocaleSidKey = 'en_US',  
                            LanguageLocaleKey = 'en_US',  
                            ProfileId = prof.Id  
                            );  
                            insert user;
                            Test.startTest();
                            system.runAs(user){
                                
                                //Account acc = [select id from Account where name = 'Test Acc' Limit 1];
                                Map<string,object> storefrontsettings = new Map<string,object>{
                                'Name' => 'CSSNAStore',
                                 'Customer Portal Acct Group Name' => 'PortalAccount',
                                    'Root Category ID' => '999999',
                                    'Customer Portal Account Name' => 'PortalAccount',
                                    'Salesforce Server URL' => 'http://sfserverurl',
                                    'Site Secure Domain' => System.Label.dbu_SiteSecureDomainTestclass,
                                        'E Commerce Type' => 'B2C',
                                        'Cart From Email' => 'Do Not Use Org Wide Email',
                                        'Order From Email' => 'Do Not Use Org Wide Email',
                                        'SEO Title Detail' => 'CloudBurst Direct',
                                        'SEO Keywords' => 'SEO Keywords',
                                        'SEO Description' => 'SEO Description',
                                        'SEO Title Site' => 'B2C Information Technology Sales',
                                        'SearchRank_ExactProductNum' => 700.0,
                                        'SearchRank_inDisplayName' => 200.0,
                                        'SearchRank_inProdNum' => 100.0,
                                        'SearchRank_ShortDesc' => 50.0,
                                        'Dev Mode' => true,
                                        'Allow Anonymous Checkout' => true,
                                        'Quoting Enabled' => true,
                                        'Send Confirmation Email' => true,
                                        'Display Coupon on Cart' => true,
                                        'Filter Orders Based on Owner' => true                  
                                    };
                                   
                                   ccrz.cc_RemoteActionContext ctx = new ccrz.cc_RemoteActionContext();
                                    ctx.storefront = 'CSSNAStore';
                                    ccrz.cc_CallContext.currAccountId = acc.id;
                                    ccrz.cc_CallContext.userCurrency = 'USD';
                                    ccrz.cc_CallContext.effAccountId = acc.id;
                                    //ccrz.cc_CallContext.currCartId = cartID;
                                    ccrz.cc_CallContext.userLocale    = 'en_US';
                                    ccrz.cc_CallContext.isGuest    = false;
                                    //ccrz.cc_CallContext.currContact= cnts;
                                    ccrz.cc_CallContext.storeFrontSettings = storefrontsettings;
                                    ccrz.cc_CallContext.initRemoteContext(ctx);
                                    //////////
                                    
                                    
                                    ccrz__E_RelatedProduct__c objRelatedProduct = dbu_FactoryDataTest.createRelatedProduct(objProduct1.id, objProduct[0].Id, 'Core Charge'); 
                                    insert objRelatedProduct;
                                    ccrz__E_Cart__c objCart1 = new ccrz__E_Cart__c(ccrz__User__c=user.id, ccrz__CartStatus__c = 'Open', ccrz__CartType__c = 'Cart', ccrz__ActiveCart__c = true, ccrz__TotalDiscount__c = 100.00, ccrz__Name__c = 'Test Cart', ccrz__Storefront__c = 'CSSNAStore', ccrz__Account__c = acc.Id,dbu_Cart_StoreCountry__c = 'US');
                                    objCart1.OwnerId = user.id;
                                  insert objCart1;
                                 ccrz__E_Cart__c objCart2 = new ccrz__E_Cart__c(ccrz__User__c=user.id, ccrz__CartStatus__c = 'Open', ccrz__CartType__c = 'Cart', ccrz__ActiveCart__c = true, ccrz__TotalDiscount__c = 100.00, ccrz__Name__c = 'Test Cart2', ccrz__Storefront__c = 'CSSNAStore', ccrz__Account__c = acc.Id,dbu_Cart_StoreCountry__c = 'US');
                                  insert objCart2;
                                    ccrz__E_CartItem__c objccCartItem = new ccrz__E_CartItem__c(ccrz__ProductType__c = 'Product', ccrz__UnitOfMeasure__c = 'Each', ccrz__StoreID__c = 'CSSNAStore',ccrz__RequestDate__c = Date.today(),ccrz__OriginalItemPrice__c = 100.00, ccrz__OriginalQuantity__c = 1.00, ccrz__Cart__c = objCart1.Id, ccrz__Quantity__c= 4.00, ccrz__Product__c = objProduct[0].Id, ccrz__Price__c = 100.00, ccrz__SubAmount__c = 400.00);
                                    insert objccCartItem;
                                    objCart = [select Id from ccrz__E_Cart__c];
                                   
                                    dbu_CartCtrl.getRelatedProductByProductId(objProduct[0].Id);
                                    /////////
                                    
                                    dbu_CartCtrl dbuCart = new dbu_CartCtrl();
                                    dbu_CartCtrl.fetchLstCartItemsByCartId(objCart[0].Id);
                                    dbu_CartCtrl.fetchLstCartItemsByCartId(objCart[0].Id,'');
                                    dbu_CartCtrl.fetchLstCartItemsByCartIdAfterTax(objCart[0].Id);
                                    //dbu_CartCtrl.calculateTax(objCart[0].Id);
                                    List<ccrz__E_CartItem__c> objCartItem = [select Id from ccrz__E_CartItem__c];
                                    if(objCartItem.size() > 0){
                                        dbu_lstCartItemAndCartWrapper objlstCartItemAndCartWrapper = new dbu_lstCartItemAndCartWrapper();
                                        objlstCartItemAndCartWrapper.cart = objCart[0];
                                        objlstCartItemAndCartWrapper.lstCartItem = objCartItem;
                                        String s = JSON.serialize(objlstCartItemAndCartWrapper);
                                        
                                    }
                                 
                                //dbu_CartCtrl.insertCartItem(objProduct[0].ccrz__SKU__c,objCart[0].Id,price,quantity,'false','US',12);
                                //dbu_CartCtrl.insertCartItem(objProduct[0].Id,objCart[0].Id,price,quantity,'true', 'US');
                                dbu_CartCtrl.insertCartItemForCrateEngine(objProduct[0].Id,objCart[0].Id,price,quantity, null, null, null, null, null, null, null, null, null, null,'US','US',null,'');
                                dbu_CartCtrl.insertCartItemGuestForCrateEngine(objProduct[0].Id,objCart[0].Id,price,quantity, null, null, null, null, null, null, null, null, null, null,'US','US',null,'');
                                
                                 dbu_CartCtrl.insertCartItemGuest(objProduct[0].Id,objCart[0].Id,price,quantity,'US',12,'US');
                                dbu_CartCtrl.updateCartItemToDefaultShip(objCart[0].Id);
                                
                 }
                 
                //dbu_CartCtrl.insertCartItem(objProduct[0].Id,objCart[0].Id,price,quantity,'false','US',12);
                dbu_CartCtrl.insertCartItemGuest(objProduct[0].Id,objCart[0].Id,price,quantity,'US',12,'US');
                //dbu_callCCApiRelatedCart.getProductList(new List<String>{objProduct[0].Id});
                Test.stopTest();
           // }
            
        //}
    }
    
    static testMethod void unitTest3() {
        Account acc = [select id from Account where name = 'Test Acc' Limit 1];
        List<ccrz__E_Product__c> objProduct = [select Id,ccrz__SKU__c from ccrz__E_Product__c];
        System.debug('objProduct============='+objProduct); 
        List<ccrz__E_PriceList__c> objTestPriceList = [select Id from ccrz__E_PriceList__c];
        ccrz__E_Product__c objProduct1 = new ccrz__E_Product__c(dbu_Has_Core_Charge__c = true, Name = 'Test Product', ccrz__SKU__c = 'Abcdee-5', ccrz__Storefront__c = 'Storefront',    ccrz__StartDate__c = date.newInstance(2020,05,22), ccrz__EndDate__c = date.newInstance(2099,05,22), ccrz__ProductType__c = 'Product');
        insert objProduct1;
        ccrz__E_PriceListItem__c objPriceListItem1 = dbu_FactoryDataTest.createPriceListItem('Test Item', 100, 20, 'Absolute', 200, objProduct1.Id, objTestPriceList[0].Id);
        insert objPriceListItem1;
        
        List<ccrz__E_Cart__c> objCart;
        //////////
        //List<ccrz__E_Cart__c> objCart = [select Id from ccrz__E_Cart__c];
        //if(objCart.size() > 0){
            
            //if(objProduct.size() > 0){
                            
                            double quantity = 1.00, price = 100.00;
                            String orgId = UserInfo.getOrganizationId();  
                            String dateString =   
                            String.valueof(Datetime.now()).replace(' ','').replace(':','').replace('-','');  
                            Integer randomInt = Integer.valueOf(math.rint(math.random()*1000000));  
                            String uniqueName = orgId + dateString + randomInt;  
                            Profile prof = [select id from profile where name LIKE '%System Administrator%' limit 1];
                            User user = new User(  FirstName = 'test',  
                            LastName = 'test',  
                            email = uniqueName + '@test' + orgId + '.org',  
                            Username = uniqueName + '@test' + orgId + '.org',  
                            EmailEncodingKey = 'ISO-8859-1',  
                            Alias = uniqueName.substring(18, 23),  
                            TimeZoneSidKey = 'America/Los_Angeles',  
                            LocaleSidKey = 'en_US',  
                            LanguageLocaleKey = 'en_US',  
                            ProfileId = prof.Id  
                            );  
                            insert user;
                            Test.startTest();
                            system.runAs(user){
                                
                                //Account acc = [select id from Account where name = 'Test Acc' Limit 1];
                                Map<string,object> storefrontsettings = new Map<string,object>{
                                'Name' => 'CSSNAStore',
                                 'Customer Portal Acct Group Name' => 'PortalAccount',
                                    'Root Category ID' => '999999',
                                    'Customer Portal Account Name' => 'PortalAccount',
                                    'Salesforce Server URL' => 'http://sfserverurl',
                                    'Site Secure Domain' => System.Label.dbu_SiteSecureDomainTestclass,
                                        'E Commerce Type' => 'B2C',
                                        'Cart From Email' => 'Do Not Use Org Wide Email',
                                        'Order From Email' => 'Do Not Use Org Wide Email',
                                        'SEO Title Detail' => 'CloudBurst Direct',
                                        'SEO Keywords' => 'SEO Keywords',
                                        'SEO Description' => 'SEO Description',
                                        'SEO Title Site' => 'B2C Information Technology Sales',
                                        'SearchRank_ExactProductNum' => 700.0,
                                        'SearchRank_inDisplayName' => 200.0,
                                        'SearchRank_inProdNum' => 100.0,
                                        'SearchRank_ShortDesc' => 50.0,
                                        'Dev Mode' => true,
                                        'Allow Anonymous Checkout' => true,
                                        'Quoting Enabled' => true,
                                        'Send Confirmation Email' => true,
                                        'Display Coupon on Cart' => true,
                                        'Filter Orders Based on Owner' => true                  
                                    };
                                   
                                   ccrz.cc_RemoteActionContext ctx = new ccrz.cc_RemoteActionContext();
                                    ctx.storefront = 'CSSNAStore';
                                    ccrz.cc_CallContext.currAccountId = acc.id;
                                    ccrz.cc_CallContext.userCurrency = 'USD';
                                    ccrz.cc_CallContext.effAccountId = acc.id;
                                    //ccrz.cc_CallContext.currCartId = cartID;
                                    ccrz.cc_CallContext.userLocale    = 'en_US';
                                    ccrz.cc_CallContext.isGuest    = false;
                                    //ccrz.cc_CallContext.currContact= cnts;
                                    ccrz.cc_CallContext.storeFrontSettings = storefrontsettings;
                                    ccrz.cc_CallContext.initRemoteContext(ctx);
                                    //////////
                                    
                                    
                                    ccrz__E_RelatedProduct__c objRelatedProduct = dbu_FactoryDataTest.createRelatedProduct(objProduct1.id, objProduct[0].Id, 'Core Charge'); 
                                    insert objRelatedProduct;
                                    ccrz__E_Cart__c objCart1 = new ccrz__E_Cart__c(ccrz__User__c=user.id, ccrz__CartStatus__c = 'Open', ccrz__CartType__c = 'Cart', ccrz__ActiveCart__c = true, ccrz__TotalDiscount__c = 100.00, ccrz__Name__c = 'Test Cart', ccrz__Storefront__c = 'CSSNAStore', ccrz__Account__c = acc.Id, dbu_Cart_StoreCountry__c = 'US');
                                    insert objCart1;
                                    dbu_CartCtrl.insertCartItem('Abcdef-5',objCart1.Id,price,quantity,'false','US',12,'US');
                                    ccrz__E_CartItem__c objccCartItem = new ccrz__E_CartItem__c(ccrz__ProductType__c = 'Product', ccrz__UnitOfMeasure__c = 'Each', ccrz__StoreID__c = 'CSSNAStore',ccrz__RequestDate__c = Date.today(),ccrz__OriginalItemPrice__c = 100.00, ccrz__OriginalQuantity__c = 1.00, ccrz__Cart__c = objCart1.Id, ccrz__Quantity__c= 4.00, ccrz__Product__c = objProduct[0].Id, ccrz__Price__c = 100.00, ccrz__SubAmount__c = 400.00);
                                    insert objccCartItem;
                                    objCart = [select Id from ccrz__E_Cart__c];
                                   
                                    dbu_CartCtrl.getRelatedProductByProductId(objProduct[0].Id);
                                    /////////
                                    
                                    dbu_CartCtrl dbuCart = new dbu_CartCtrl();
                                    /*dbu_CartCtrl.fetchLstCartItemsByCartId(objCart[0].Id);
                                    dbu_CartCtrl.fetchLstCartItemsByCartId(objCart[0].Id,'');
                                    dbu_CartCtrl.fetchLstCartItemsByCartIdAfterTax(objCart[0].Id);*/
                                    //dbu_CartCtrl.calculateTax(objCart[0].Id);
                                    List<ccrz__E_CartItem__c> objCartItem = [select Id from ccrz__E_CartItem__c];
                                    if(objCartItem.size() > 0){
                                        dbu_lstCartItemAndCartWrapper objlstCartItemAndCartWrapper = new dbu_lstCartItemAndCartWrapper();
                                        objlstCartItemAndCartWrapper.cart = objCart[0];
                                        objlstCartItemAndCartWrapper.lstCartItem = objCartItem;
                                        String s = JSON.serialize(objlstCartItemAndCartWrapper);
                                        dbu_CartCtrl.updateCartAndCartItem(s);
                                        dbu_CartCtrl.insertCartItem('Abcdef-5',objCart[0].Id,price,quantity,'false','US',12,'US');
                                        dbu_CartCtrl.updateCartItem(objProduct[0].Id,'',price,quantity,'US');
                                        dbu_CartCtrl.deleteCartItem(objCartItem[0].Id, objCart[0].Id);
                                        dbu_CartCtrl.deleteCartItemOnShopCart(objCartItem[0].Id, objCart[0].Id);
                                        dbu_CartCtrl.fetchCartSize(objCart[0].Id);
                                        dbu_CartCtrl.fetchCartId(objCart[0].Id);
                                        dbu_CartCtrl.fetchLstCartItemsAfterDelete(objCart[0].Id,'');
                                                dbu_CartCtrl.mergeCart('US',objCart[0].id);
                                           dbu_CartCtrl.createCybersourceURLLog(String.valueOf(objCart[0].id), 'Stringurl');
                                       
                                    }
                                    ///////////////
                                    //ccrz__E_Cart__c objCart1 = new ccrz__E_Cart__c(dbu_Cart_StoreCountry__c = 'US', ccrz__CartStatus__c = 'Open', ccrz__CartType__c = 'Cart', ccrz__ActiveCart__c = true, ccrz__TotalDiscount__c = 100.00, ccrz__Name__c = 'Test Cart', ccrz__Storefront__c = 'CSSNAStore', ccrz__User__c = user.Id);
                                    //insert objCart1;
                                //dbu_CartCtrl.insertCartItem(objProduct[0].ccrz__SKU__c,objCart[0].Id,price,quantity,'false','US',12);
                                //dbu_CartCtrl.insertCartItem(objProduct[0].Id,objCart[0].Id,price,quantity,'true', 'US');
                                //dbu_CartCtrl.insertCartItemForCrateEngine(objProduct[0].Id,objCart[0].Id,price,quantity, null, null, null, null, null, null, null, null, null, null,'US');
                                //dbu_CartCtrl.insertCartItemGuestForCrateEngine(objProduct[0].Id,objCart[0].Id,price,quantity, null, null, null, null, null, null, null, null, null, null,'US');
                                
                                 //dbu_CartCtrl.insertCartItemGuest(objProduct[0].Id,objCart[0].Id,price,quantity,'US',12);
                 }
                dbu_CallCCCartApi.fetchCartItemsByCartIdAfterTax(objCart[0].Id);
                dbu_CartCtrl.fetchLstCartItemsByCartIdwithStoreLocation(objCart[0].Id,'', 'US');
                Test.stopTest();
           // }
            
        //}
    }
    
}
//UAT Deployment