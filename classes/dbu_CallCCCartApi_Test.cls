/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 09-05-2022
 * @last modified by  : Devaraj
**/
@isTest 
public class dbu_CallCCCartApi_Test { 
    
    
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
            insert objCart;
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
        ccrz__E_Product__c objProduct1 = new ccrz__E_Product__c(dbu_Has_Core_Charge__c = true, Name = 'Test Product', ccrz__SKU__c = 'Abcdeef-5', ccrz__Storefront__c = 'Storefront',   ccrz__StartDate__c = date.newInstance(2020,05,22), ccrz__EndDate__c = date.newInstance(2099,05,22), ccrz__ProductType__c = 'Product');
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
        ccrz__E_Product__c objProduct1 = new ccrz__E_Product__c(dbu_Has_Core_Charge__c = true, Name = 'Test Product', ccrz__SKU__c = 'Abcdee-5', ccrz__Storefront__c = 'Storefront',    ccrz__StartDate__c = date.newInstance(2020,05,22), ccrz__EndDate__c = date.newInstance(2099,05,22), ccrz__ProductType__c = 'Product', DBU_Product_Location__c = 'CA');
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
                                dbu_CallCCCartApi.fetchCartItemsByCartId(objCart[0].Id);
                                dbu_CartCtrl.updateCartItem(objProduct[0].Id,objCart[0].Id,price,quantity,'US');
                                dbu_CartCtrl.updateCartItemShopCart(objProduct[0].Id,objCart[0].Id,price,quantity,'US');
                                //dbu_CartCtrl.updateCartItemCore(objProduct[0].Id,objCart[0].Id,2.00,'US');
                 }
                /*28th Jandbu_CartCtrl.insertCartItem(objProduct[0].Id,objCart[0].Id,price,quantity,'false','US',12,'US');
                dbu_CartCtrl.insertCartItem(objProduct[0].Id,objCart[0].Id,price,quantity,'false','US',12,'US');
                dbu_CartCtrl.insertCartItemGuest(objProduct[0].Id,objCart[0].Id,price,quantity,'US',12,'US');
                dbu_CartCtrl.insertCartItemGuest(objProduct[0].Id,objCart[0].Id,price,quantity,'US',12,'US');
                dbu_CartCtrl.generateResponse(objCart[0].Id);*/
                 Test.stopTest();

            }
            
        }
    }
    
    static testMethod void unitTest0(){
        
        Test.startTest();
        //Account acc = [select id from Account where name = 'Test Acc' Limit 1];
        //List<ccrz__E_Cart__c> objCart = [select Id from ccrz__E_Cart__c];
        
        
        Id AccountRecordType = Schema.SObjectType.Account.getRecordTypeInfosByName().get('IAM Global').getRecordTypeId();
        Id ContactRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('IAM').getRecordTypeId();        
          
        UserRole userRole_1 = [SELECT Id FROM UserRole WHERE DeveloperName = 'CEO' LIMIT 1];
        Profile profile_1 = [SELECT Id FROM Profile WHERE name = 'IAM User' LIMIT 1];
        User admin = [SELECT Id, Username, UserRoleId FROM User WHERE Profile.Name = 'System Administrator' and IsActive = true LIMIT 1];
        admin.UserRoleId = userRole_1.Id;
        update admin;        
        
        System.runAs(admin){        
        
            
            Account acc =   dbu_FactoryDataTest.createIAMAccount('Identity Individual Users12yTest', AccountRecordType);
            insert acc;            
            
            String orgId = UserInfo.getOrganizationId();  
            String dateString =   
                String.valueof(Datetime.now()).replace(' ','').replace(':','').replace('-','');  
            Integer randomInt = Integer.valueOf(math.rint(math.random()*1000000));  
            String uniqueName = orgId + dateString + randomInt;
            //con.Username__c                           =   uniqueName + '@test' + orgId + '.org';
            
            Contact con = new Contact(LastName = 'DAYAN', FirstName = 'MOSHE'  ,AccountId = acc.id, Email= 'klemen@jo.com');  
            con.Username__c = uniqueName + '@test' + orgId + '.org'; 
            insert con;            
            
            user usr                                =   new User();
            usr.FirstName                           =   'MOSHE';
            usr.LastName                            =   'DAYAN';
            usr.Alias                               =   'Tsr';
            usr.CompanyName                         =   'IAI AEROSPACE';
            usr.Username                            =   string.valueof(Math.random())+'moshedayan@lionsgate.org.efraim';
            usr.Email                               =   'xyz'+'moshedayan@lionsgate.org';
            usr.Country                             =   'United States';
            usr.CommunityNickname                   =   'NickCustomer';
            usr.TimeZoneSidKey                      =   'America/Panama';
            usr.LocaleSidKey                        =   'en_US';            
            usr.ProfileId                           =   profile_1.id;
            usr.ContactId                           =   con.id;
            usr.Phone                               =   '83689376493';
            usr.EmailEncodingKey                    =   'UTF-8';
            usr.CSS_User_MultiLocValues__c          =   'null-P';
            usr.UserGroup__c                        =   'EDS_User';
            usr.IAM_UID__c                          =   'moshedayan@lionsgate.org';
            usr.IAM_Abocode__c                      =   '1';
            usr.IAM_Final_Approver__c               =   'N';
            usr.IAM_WorkGroup_id__c                 =   'null-P';
            usr.tableauId__c                        =   'DAYAN';
            usr.activeEquipmentDuration__c          =   '21';
            usr.sessionTimeout__c                   =   '86400000';
            usr.LanguageLocaleKey                   =   'en_US';
            usr.PortalRole                          = 'Manager';
            usr.IsActive = true;
            usr.ccrz__CC_CurrencyCode__c            =   'USD';
            insert usr;            
            
            
            ccrz__E_Product__c ProductRet1 = [SELECT id FROM ccrz__E_Product__c WHERE Name = 'Test Product' limit 1];
            system.debug('ProductRet1 > ' + ProductRet1);
            ccrz__E_PriceListItem__c Priceline1 = [select ccrz__Price__c from ccrz__E_PriceListItem__c where ccrz__Product__c =: ProductRet1.id limit 1];
            system.debug('Priceline1 > ' + Priceline1);  
            
            
            
            //system.runAs(usr){
                
            //}
            
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
            ccrz.cc_CallContext.currContact= con;
            ccrz.cc_CallContext.storeFrontSettings = storefrontsettings;
            ccrz.cc_CallContext.initRemoteContext(ctx);
            
            ccrz__E_Cart__c currcart = new ccrz__E_Cart__c();
            currcart.ccrz__Name__c                  =   'MyCart';
            currcart.ccrz__CartType__c              =   'Cart';
            currcart.ccrz__CurrencyISOCode__c       =   'USD';
            currcart.ccrz__ActiveCart__c            =   true;
            currcart.ccrz__Storefront__c            =   'CSSNAStore';
            currcart.ccrz__CartStatus__c            =   'Open';  
            currcart.ccrz__User__c                  =   usr.id;
            currcart.ccrz__Contact__c               =   con.id;
            currcart.ccrz__Account__c               =   acc.id;  
            currcart.dbu_Cart_StoreCountry__c       =   'US';
            insert currcart;            
            
            ccrz__E_CartItem__c shipcartline  = dbu_FactoryDataTest.createCartItem(currcart.id, (double)Priceline1.ccrz__Price__c, 1, ProductRet1.id);  
            shipcartline.dbu_isShipTo__c = true;
            shipcartline.dbu_Estimated_Delivery__c = 'November 2 - November - 8';
            shipcartline.dbu_Estimated_PickUp__c = 'November 2';
            insert shipcartline;      
            
            
            dbu_CallCCCartApi.fetchCartItemsByCartId(currcart.id);
            
        }           
        
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
                                    
                                  insert objCart1;
                                    ccrz__E_CartItem__c objccCartItem = new ccrz__E_CartItem__c(ccrz__ProductType__c = 'Product', ccrz__UnitOfMeasure__c = 'Each', ccrz__StoreID__c = 'CSSNAStore',ccrz__RequestDate__c = Date.today(),ccrz__OriginalItemPrice__c = 100.00, ccrz__OriginalQuantity__c = 1.00, ccrz__Cart__c = objCart1.Id, ccrz__Quantity__c= 4.00, ccrz__Product__c = objProduct[0].Id, ccrz__Price__c = 100.00, ccrz__SubAmount__c = 400.00);
                                    insert objccCartItem;
                                    objCart = [select Id from ccrz__E_Cart__c];
                                   
                                    dbu_CartCtrl.getRelatedProductByProductId(objProduct[0].Id);
                                    /////////
                                    dbu_CallCCCartApi.fetchCartItemsByCartId(objCart[0].Id);
                                
                                    dbu_CartCtrl dbuCart = new dbu_CartCtrl();
                                    dbu_CartCtrl.fetchLstCartItemsByCartId(objCart[0].Id);
                                    dbu_CartCtrl.fetchLstCartItemsByCartId(objCart[0].Id,'cart');
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
                                dbu_CartCtrl.insertCartItemForCrateEngine(objProduct[0].Id,objCart[0].Id,price,quantity, null, null, null, null, null, null, null, null, null, null,'US','US','','');
                                dbu_CartCtrl.insertCartItemGuestForCrateEngine(objProduct[0].Id,objCart[0].Id,price,quantity, null, null, null, null, null, null, null, null, null, null,'US','','','');
                                
                                 dbu_CartCtrl.insertCartItemGuest(objProduct[0].Id,objCart[0].Id,price,quantity,'US',12,'US');
                                
                 }
                 
                //dbu_CartCtrl.insertCartItem(objProduct[0].Id,objCart[0].Id,price,quantity,'false','US',12,'US');
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
        ccrz__E_Product__c objProduct1 = new ccrz__E_Product__c(CurrencyIsoCode = 'USD',dbu_Has_Core_Charge__c = true, Name = 'Test Product', ccrz__SKU__c = 'Abcdee-5', ccrz__Storefront__c = 'Storefront',    ccrz__StartDate__c = date.newInstance(2020,05,22), ccrz__EndDate__c = date.newInstance(2099,05,22), ccrz__ProductType__c = 'Product');
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
                                        dbu_CartCtrl.insertCartItem(objProduct[0].Id,objCart[0].Id,price,quantity,'false','US',12,'US');
                                        dbu_CartCtrl.deleteCartItem(objCartItem[0].Id, objCart[0].Id);
                                        dbu_CartCtrl.deleteCartItemOnShopCart(objCartItem[0].Id, objCart[0].Id);
                                        dbu_CartCtrl.fetchCartSize(objCart[0].Id);
                                        dbu_CartCtrl.fetchCartId(objCart[0].Id);
                                        dbu_CartCtrl.fetchLstCartItemsAfterDelete(objCart[0].Id,'');
                                    }
                                    ///////////////
                                    //ccrz__E_Cart__c objCart1 = new ccrz__E_Cart__c(dbu_Cart_StoreCountry__c = 'US', ccrz__CartStatus__c = 'Open', ccrz__CartType__c = 'Cart', ccrz__ActiveCart__c = true, ccrz__TotalDiscount__c = 100.00, ccrz__Name__c = 'Test Cart', ccrz__Storefront__c = 'CSSNAStore', ccrz__User__c = user.Id);
                                    //insert objCart1;
                                //dbu_CartCtrl.insertCartItem(objProduct[0].ccrz__SKU__c,objCart[0].Id,price,quantity,'false','US',12,'US');
                                //dbu_CartCtrl.insertCartItem(objProduct[0].Id,objCart[0].Id,price,quantity,'true', 'US','US');
                                //dbu_CartCtrl.insertCartItemForCrateEngine(objProduct[0].Id,objCart[0].Id,price,quantity, null, null, null, null, null, null, null, null, null, null,'US','US');
                                //dbu_CartCtrl.insertCartItemGuestForCrateEngine(objProduct[0].Id,objCart[0].Id,price,quantity, null, null, null, null, null, null, null, null, null, null,'US','US');
                                
                                 //dbu_CartCtrl.insertCartItemGuest(objProduct[0].Id,objCart[0].Id,price,quantity,'US',12);
                 }
                dbu_CallCCCartApi.fetchCartItemsByCartIdAfterTax(objCart[0].Id);
        
                //List<ccrz__E_Cart__c> objCarta = [select Id from ccrz__E_Cart__c where ccrz__Name__c = 'Test Cart'];
        
                
                dbu_CartCtrl.fetchLstCartItemsByCartIdwithStoreLocation(objCart[0].Id,'', 'US');
                dbu_CallCCCartApi.createCart('US','US');
                List<String> plist = new List<String>();
                plist.add(objProduct1.Id);
                dbu_CallCCCartApi.getProductAvailabilMapLocal(plist, objProduct1.CurrencyIsoCode);
                Test.stopTest();
           // }
            
        //}
    }
    
    @isTest
    static void testmethod1(){
        dbu_CallCCCartApi.createCartCCApi('US','US');    
            
    }    
    
    @isTest
    static void testmethod2(){
        
        
        Account acar = [select id from account where name = 'Test Acc'];  
        
        ccrz__E_Cart__c obwjCart = new ccrz__E_Cart__c(dbu_Cart_StoreCountry__c = 'US', ccrz__CartStatus__c = 'Open', ccrz__CartType__c = 'Cart', ccrz__ActiveCart__c = true, ccrz__TotalDiscount__c = 100.00, ccrz__Name__c = 'Tesional Cart', ccrz__Storefront__c = 'CSSNAStore', ccrz__Account__c = acar.Id);
        insert obwjCart;          
        
        ccrz__E_Product__c objwProduct = new ccrz__E_Product__c(dbu_Has_Core_Charge__c = true, Name = 'Tesional Product', ccrz__SKU__c = 'Abaaacdef-5', ccrz__Storefront__c = 'Storefront', ccrz__StartDate__c = date.newInstance(2020,05,22), ccrz__EndDate__c = date.newInstance(2099,05,22), ccrz__ProductType__c = 'Product');
             insert objwProduct;  

        ccrz__E_CartItem__c obwjccCartItem = new ccrz__E_CartItem__c(ccrz__ProductType__c = 'Product', ccrz__UnitOfMeasure__c = 'Each', ccrz__StoreID__c = 'CSSNAStore',ccrz__RequestDate__c = Date.today(),ccrz__OriginalItemPrice__c = 100.00, ccrz__OriginalQuantity__c = 1.00, ccrz__Cart__c = obwjCart.Id, ccrz__Quantity__c= 4.00, ccrz__Product__c = objwProduct.Id, ccrz__Price__c = 100.00, ccrz__SubAmount__c = 400.00);
            insert obwjccCartItem; 
        
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
        appliedCoupon.ccrz__Cart__c = obwjCart.id;
        appliedCoupon.CurrencyIsoCode = 'USD';
        appliedCoupon.Name = 'BOOM';
        appliedCoupon.ccrz__Coupon__c = CARTCOUPON.id;
        insert appliedCoupon;
        system.debug('appliedCoupon 1> ' + appliedCoupon.id + appliedCoupon.ccrz__Cart__c);
                
        dbu_CallCCCartApi.insertCartItemForCrateEngine((string)objwProduct.ccrz__SKU__c ,(String)obwjCart.id ,98, 10, 'BELGRADE','JNA','UIS','1992',
                                                       TRUE,TRUE,TRUE,TRUE,
                                                       TRUE,TRUE,'US','');         
        
        dbu_CallCCCartApi.insertCartItem((string)objwProduct.ccrz__SKU__c ,(String)obwjCart.id,122,3);
        
        dbu_CallCCCartApi.deleteCartItemCCApi((String)obwjccCartItem.id, (String)obwjCart.id);
      
        ccrz__E_ContactAddr__c objAddr = new ccrz__E_ContactAddr__c(ccrz__FirstName__c = 'TestFirstName1',ccrz__LastName__c = 'TestLastName1', ccrz__State__c = 'California', ccrz__City__c = 'Sunnyvale', ccrz__Country__c = 'United States',ccrz__PostalCode__c = '94085');
        insert objAddr;
        obwjCart.dbu_Pick_Up_From_Store__c = objAddr.Id;
        obwjCart.ccrz__ShipTo__c                =   objAddr.id;
        obwjCart.ccrz__BillTo__c                =   objAddr.id;
       dbu_CallCCCartApi.setCCAddress(obwjCart,obwjCart);
        
    }
    
}
//UAT Deployment updated