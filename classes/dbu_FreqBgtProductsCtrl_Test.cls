@isTest
public class dbu_FreqBgtProductsCtrl_Test {
    //Amado carillo fuentes      
    private static string ACCOUNT_REGION 		=	'US and Canada';
    private static string TIMEZONE 				=	'America/Panama';
    private static string EMAIL_ENCODING 		=	'ISO-8859-1';
    private static string LOCALE				=	'English(United States)';
    private static string LANGUAGE				=	'English';
    private static string BILLING_COUNTRY		=	'United States';
    private static string EMAIL					=	'nazgul@ringwraiths.com';    
    private static string COMPANY_NAME			=	'test user company';   
    private static string PHONE					=	'83689376493';   
    private static string STATUS				=	'Active';
    private static string FIRSTNAME				=	'Test';
    private static string LASTNAME				=	'Customer';
    private static string NICKNAME				=	'NickCustomer';
    private static string EMAIL_ENCODING_USER	=	'UTF-8';
    private static string USERNAME              =   '38788ullmann@cmiuser.com.fulluat'; 
    private static Date START_DATE				=	Date.parse('6/20/2019');
    private static Date END_DATE				=	Date.parse('12/31/2099');    

    @testsetup 
    static void settingTestData(){
    	
        UserRole userRole_1 = [SELECT Id FROM UserRole WHERE DeveloperName = 'CEO' LIMIT 1];
        Profile profile_1 = [SELECT Id FROM Profile WHERE name = 'IAM User' LIMIT 1];
        User admin = [SELECT Id, Username, UserRoleId FROM User WHERE Profile.Name = 'System Administrator' and IsActive = true LIMIT 1];
        admin.UserRoleId = userRole_1.Id;
        update admin;  
        system.debug('orestein');
        
        System.runAs(admin){
            //Get RecordTypeID 
            Id AccountRecordType = Schema.SObjectType.Account.getRecordTypeInfosByName().get('IAM Global').getRecordTypeId();
            Id ContactRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('IAM').getRecordTypeId();
            
            //Get Profile Id - IAM User
            Id profileId = [Select Id From Profile Where Name='IAM User'].id;
            
            //Get Permission Sets
            List<PermissionSet> PermSetList = [SELECT id FROM PermissionSet where Name = 'B2BCommerceGuestCloneDefaultOwner' OR Name = 'eCommerce' LIMIT 2];
            
            //Setup Account for Logged In user
            Account acc 							=	dbu_FactoryDataTest.createIAMAccount('Identity Individual Users12yTest', AccountRecordType);
            insert acc;
            
            
            String orgId = UserInfo.getOrganizationId();  
            String dateString =   
                String.valueof(Datetime.now()).replace(' ','').replace(':','').replace('-','');  
            Integer randomInt = Integer.valueOf(math.rint(math.random()*1000000));  
            String uniqueName = orgId + dateString + randomInt;
            //con.Username__c							=	uniqueName + '@test' + orgId + '.org';
            
            Contact con = new Contact(LastName = LASTNAME, FirstName = FIRSTNAME ,AccountId = acc.id, Email= 'klemen@jo.com');  
            con.Username__c = uniqueName + '@test' + orgId + '.org'; 
            insert con;
            
            
            //Setup user for Logged In user                        
            user usr                                =   new User();
            usr.FirstName                           =   FIRSTNAME;
            usr.LastName                            =   LASTNAME;
            usr.Alias                               =   'Tsr';
            usr.CompanyName                         =   COMPANY_NAME;
            usr.Username                            =   string.valueof(Math.random())+USERNAME;
            usr.Email                               =   'xyz'+EMAIL;
            usr.Country                             =   BILLING_COUNTRY;
            usr.CommunityNickname                   =   NICKNAME;
            usr.TimeZoneSidKey                      =   TIMEZONE;
            usr.LocaleSidKey                        =   'en_US';
            //objUser.FederationIdentifier                =   FEDID;
            
            usr.ProfileId                           =   profileId;
            usr.ContactId                           =   con.id;
            usr.Phone                               =   PHONE;
            usr.EmailEncodingKey                    =   EMAIL_ENCODING_USER;
            usr.CSS_User_MultiLocValues__c          =   'null-P';
            usr.UserGroup__c                        =   'EDS_User';
            usr.IAM_UID__c                          =   EMAIL;
            usr.IAM_Abocode__c                      =   '1';
            usr.IAM_Final_Approver__c               =   'N';
            usr.IAM_WorkGroup_id__c                 =   'null-P';
            usr.tableauId__c                        =   LASTNAME;
            usr.activeEquipmentDuration__c          =   '21';
            usr.sessionTimeout__c                   =   '86400000';
            usr.LanguageLocaleKey					=	'en_US';
            //objUser.UserRoleId							=	ID.valueof((string.valueof(userrole.Id)));
            usr.PortalRole 							= 'Manager';
            usr.IsActive = true;
            usr.ccrz__CC_CurrencyCode__c 			=	'USD';
            insert usr;            
            
                   
            //Setup PriceList 
            string storeCountry = 'US';    
            system.runAs(usr){
                ccrz__E_PriceList__c TestPricelist = dbu_FactoryDataTest.createPriceList('TestPricelist');
                insert TestPricelist;
                
                //Setup Products
                list<ccrz__E_Product__c> TestProductList = new list<ccrz__E_Product__c>();
                ccrz__E_Product__c TestProduct1 = dbu_FactoryDataTest.createProduct('TestProduct1', true, true, true, false);
                TestProduct1.DBU_Product_Location__c = storeCountry;
                TestProduct1.dbu_Crate_Engine__c = false;
                TestProduct1.dbu_Has_Core_Child__c = false;
                TestProduct1.dbu_Has_Core_Charge__c = false;
                TestProduct1.DBU_Product_Location__c = 'US';
                TestProduct1.ccrz__Storefront__c = 'CSSNAStore';
                TestProductList.add(TestProduct1);
                
                ccrz__E_Product__c TestProduct2 = dbu_FactoryDataTest.createProduct('TestProduct2', false, false, true, false);
                TestProduct2.DBU_Product_Location__c = storeCountry;
                TestProductList.add(TestProduct2);
                
                ccrz__E_Product__c TestProduct3 = dbu_FactoryDataTest.createProduct('TestProduct3', true, false, false, true);
                TestProduct3.dbu_Crate_Engine__c = true; 
                TestProduct3.DBU_Product_Location__c = storeCountry;
                TestProductList.add(TestProduct3);
                
                ccrz__E_Product__c TestProduct4 = dbu_FactoryDataTest.createProduct('TestProduct4', false, true, false, true);
                TestProduct4.DBU_Product_Location__c = storeCountry;
                TestProduct4.dbu_Has_Core_Charge__c = true;
                TestProductList.add(TestProduct4);
                
                ccrz__E_Product__c TestProduct5 = dbu_FactoryDataTest.createProduct('TestProduct5', false, false, false, true);
                TestProduct5.DBU_Product_Location__c = storeCountry;
                TestProductList.add(TestProduct5);
                
                List<ccrz__E_PriceListItem__c> ProductPriceListItems = new list<ccrz__E_PriceListItem__c>();
                list<ccrz__E_ProductMedia__c>  ProductsMediaList	 = new list<ccrz__E_ProductMedia__c>();
                list<ccrz__E_ProductInventoryItem__c> ProductsINvlist = new list<ccrz__E_ProductInventoryItem__c>();
                
                Database.SaveResult[] TestProductInsertedList = Database.insert(TestProductList, false);                
                Integer Count = 0;
                for (Database.SaveResult sr : TestProductInsertedList) {            
                    if (sr.isSuccess()) {
                        // Operation was successful, so get the ID of the record that was processed
                        System.debug('Successfully inserted account. Account ID: ' + sr.getId());
                        
                        //Setup Product Media 
                        ccrz__E_ProductMedia__c TestProductMedia1 = dbu_FactoryDataTest.createProductMedia(sr.getId(), 'Product Image');
                        ProductsMediaList.add(TestProductMedia1);
                        
                        ccrz__E_ProductMedia__c TestProductMedia2 = dbu_FactoryDataTest.createProductMedia(sr.getId(), 'Product Search Image');
                        ProductsMediaList.add(TestProductMedia2);
                        
                        //Setup Product Inventory Item
                        string ProductInventoryItemName =	'ProdInv'+Count;
                        double QuantityAvailable		=	10+Count;
                        string availablemessage 		=	'In stock';
                        string status					=	'In Stock';
                        ccrz__E_ProductInventoryItem__c TestProdInventory = dbu_FactoryDataTest.createProductInventoryItem(ProductInventoryItemName, sr.getId(), QuantityAvailable, availablemessage, status);
                        ProductsINvlist.add(TestProdInventory);
                        
                        string PricelistitemName = 'PricelistItem'+Count;
                        double OriginalPrice	 = 100+Count;
                        double discountAmt 		 = 15+Count;
                        double Price 			 = OriginalPrice - discountAmt;                
                        
                        //Setup PriceListItem for the product
                        ccrz__E_PriceListItem__c TestPriceListItem =  dbu_FactoryDataTest.createPriceListItem(PricelistitemName, OriginalPrice, discountAmt, 'Absolute', Price, sr.getId(), TestPricelist.id);                
                        ProductPriceListItems.add(TestPriceListItem);
                        
                        
                    }
                    else {
                        // Operation failed, so get all errors                
                        for(Database.Error err : sr.getErrors()) {
                            System.debug('The following error has occurred.');                    
                            System.debug(err.getStatusCode() + ': ' + err.getMessage());
                            System.debug('Account fields that affected this error: ' + err.getFields());
                        }
                    }
                }
                
                //insert pricelist items
                insert ProductPriceListItems;
                
                //insert product medias
                insert ProductsMediaList;
                
                //insert Product inventory 
                insert ProductsINvlist;
                
                
                //declaring core product
                ccrz__E_Product__c TestProductcorechild = dbu_FactoryDataTest.createProduct('TestProductcorechild', false, false, true, false);
                TestProductcorechild.dbu_Has_Core_Charge__c = true;
                TestProductcorechild.dbu_Has_Core_Child__c = true;
                TestProductcorechild.DBU_Product_Location__c = storeCountry;                   
                insert TestProductcorechild;
                
                ccrz__E_ProductMedia__c TestProductcorechildmedia = dbu_FactoryDataTest.createProductMedia(TestProductcorechild.id, 'Product Image');
                insert TestProductcorechildmedia;
                
                string ProductInventoryItemNamecore  	=	'ProdInvcore';
                double QuantityAvailablecore 			=	99;
                string availablemessagecore  			=	'In stock';
                string statuscore 						=	'In Stock'; 
                
                ccrz__E_ProductInventoryItem__c TestProdInventorycore = dbu_FactoryDataTest.createProductInventoryItem(ProductInventoryItemNamecore, TestProductcorechild.id, QuantityAvailablecore, availablemessagecore, statuscore);            
                insert TestProdInventorycore;
                
                string PricelistitemNamecore		 	= 'PricelistItemcore';
                double OriginalPricecore				= 199;
                double discountAmtcore			 		= 15;
                double Pricecore			 			= OriginalPricecore - discountAmtcore;              
                
                ccrz__E_PriceListItem__c TestPriceListItem =  dbu_FactoryDataTest.createPriceListItem(PricelistitemNamecore, OriginalPricecore, discountAmtcore, 'Absolute', Pricecore, TestProductcorechild.id , TestPricelist.id);                
                insert TestPriceListItem;
                
                //create product relation
                ccrz__E_RelatedProduct__c Testrelation		=	new ccrz__E_RelatedProduct__c();
                Testrelation.ccrz__RelatedProduct__c 		=	TestProductcorechild.id;
                Testrelation.ccrz__Product__c				=	TestProduct4.id;
                Testrelation.ccrz__RelatedProductType__c	=	'Core Charge';
                Testrelation.ccrz__StartDate__c				=	START_DATE;
                Testrelation.ccrz__EndDate__c				=	END_DATE;
                Testrelation.ccrz__Sequence__c				=	500;
                Testrelation.ccrz__Enabled__c				=	true;
                insert Testrelation;
                
            }
            
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
        }
        
        
        
    }
    
    @isTest
    static void testmethod1(){
        
        //Get user
        Map<string,object> storefrontsettings = new Map<string,object>{
            'Name' => 'CSSNAStore',
                'Customer Portal Acct Group Name' => 'PortalAccount',   
                'Root Category ID' => '999999',
                'Customer Portal Account Name' => 'PortalAccount',
                'Salesforce Server URL' => 'http://sfserverurl',
                'Site Secure Domain' => 'csodev-cumminscss.cs90.force.com/CSSNAStore',
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
                    
        user u = [select id,Contactid from User where Email = 'xyznazgul@ringwraiths.com'];        
        //user ussr = [select id from user where id =: userinfo.getUserId()];
        account acc = [select id from account where name = 'Identity Individual Users12yTest'];
        
        contact cnts = [select id from contact where id =: u.Contactid];
        string ContactID = u.Contactid;        
        string storeCountry = 'US';    
        
        system.runAs(u){
            list<ccrz__E_Product__c> ProductRet = [SELECT id FROM ccrz__E_Product__c WHERE Name = 'TestProduct1'];
            Test.startTest();
            
            ccrz.cc_RemoteActionContext ctx = new ccrz.cc_RemoteActionContext();
            ctx.storefront = 'CSSNAStore';
            ccrz.cc_CallContext.currAccountId = acc.id;
            ccrz.cc_CallContext.userCurrency = 'USD';
            ccrz.cc_CallContext.effAccountId = acc.id;
            //ccrz.cc_CallContext.currCartId = cartID;
            ccrz.cc_CallContext.userLocale	= 'en_US';
            ccrz.cc_CallContext.currContact= cnts;
            ccrz.cc_CallContext.storeFrontSettings = storefrontsettings;
            ccrz.cc_CallContext.initRemoteContext(ctx);  

            Map<string,object> InsertWithoutCart = dbu_FreqBgtProductsCtrl.insertOrUpdateMultipleCartitemsInFreqBgtProds(JSON.serialize(new list<object>{(string)ProductRet[0].id}), '', storeCountry, 'US');
            
			Test.stopTest();            
        }
        
    }
    
    @isTest
    static void testmethod2(){
        
        //Get user
        Map<string,object> storefrontsettings = new Map<string,object>{
            'Name' => 'CSSNAStore',
                'Customer Portal Acct Group Name' => 'PortalAccount',   
                'Root Category ID' => '999999',
                'Customer Portal Account Name' => 'PortalAccount',
                'Salesforce Server URL' => 'http://sfserverurl',
                'Site Secure Domain' => 'csodev-cumminscss.cs90.force.com/CSSNAStore',
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
                    
        user u = [select id,Contactid from User where Email = 'xyznazgul@ringwraiths.com'];        
        //user ussr = [select id from user where id =: userinfo.getUserId()];
        account acc = [select id from account where name = 'Identity Individual Users12yTest'];
        
        contact cnts = [select id,accountid from contact where id =: u.Contactid];
        string ContactID = u.Contactid;        
        string storeCountry = 'US';    
        
        system.runAs(u){
            list<ccrz__E_Product__c> ProductRet = [SELECT id FROM ccrz__E_Product__c WHERE Name = 'TestProduct1'];
            Test.startTest();
            
            ccrz.cc_RemoteActionContext ctx = new ccrz.cc_RemoteActionContext();
            ctx.storefront = 'CSSNAStore';
            ccrz.cc_CallContext.currAccountId = acc.id;
            ccrz.cc_CallContext.userCurrency = 'USD';
            ccrz.cc_CallContext.effAccountId = acc.id;
            //ccrz.cc_CallContext.currCartId = cartID;
            ccrz.cc_CallContext.userLocale	= 'en_US';
            ccrz.cc_CallContext.currContact= cnts;
            ccrz.cc_CallContext.storeFrontSettings = storefrontsettings;
            ccrz.cc_CallContext.initRemoteContext(ctx);  

            ccrz__E_Cart__c currcart = new ccrz__E_Cart__c();
            currcart.ccrz__Name__c					=	'MyCart';
            currcart.ccrz__CartType__c				=	'Cart';
            currcart.ccrz__CurrencyISOCode__c		=	'USD';
            currcart.ccrz__ActiveCart__c			=	true;
            currcart.ccrz__Storefront__c			=	'CSSNAStore';
            currcart.ccrz__CartStatus__c			=	'Open';  
            currcart.ccrz__User__c					=	u.id;
            currcart.ccrz__Contact__c				=	cnts.id;
            currcart.ccrz__Account__c				=	cnts.accountid;  
            currcart.dbu_Cart_StoreCountry__c		=	storeCountry;
            currcart.dbu_storeLanguage__c			=	storeCountry;
            insert currcart;            
            
            ccrz__E_CartItem__c cartline  = dbu_FactoryDataTest.createCartItem(currcart.id, 78, 1, ProductRet[0].id);  
            insert cartline;              
            
            Map<string,object> InsertWithCart = dbu_FreqBgtProductsCtrl.insertOrUpdateMultipleCartitemsInFreqBgtProds(JSON.serialize(new list<object>{(string)ProductRet[0].id}), (string)currcart.id, storeCountry, 'US');
            
			Test.stopTest();            
        }        
        
    }
    
    @isTest
    static void testmethod3(){
        
        //Get user
        Map<string,object> storefrontsettings = new Map<string,object>{
            'Name' => 'CSSNAStore',
                'Customer Portal Acct Group Name' => 'PortalAccount',   
                'Root Category ID' => '999999',
                'Customer Portal Account Name' => 'PortalAccount',
                'Salesforce Server URL' => 'http://sfserverurl',
                'Site Secure Domain' => 'csodev-cumminscss.cs90.force.com/CSSNAStore',
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
                    
        user u = [select id,Contactid from User where Email = 'xyznazgul@ringwraiths.com'];        
        //user ussr = [select id from user where id =: userinfo.getUserId()];
        account acc = [select id from account where name = 'Identity Individual Users12yTest'];
        
        contact cnts = [select id,accountid from contact where id =: u.Contactid];
        string ContactID = u.Contactid;        
        string storeCountry = 'US';    
        
        system.runAs(u){
            list<ccrz__E_Product__c> ProductRet = [SELECT id FROM ccrz__E_Product__c WHERE Name = 'TestProduct1'];
            Test.startTest();
            
            ccrz.cc_RemoteActionContext ctx = new ccrz.cc_RemoteActionContext();
            ctx.storefront = 'CSSNAStore';
            ccrz.cc_CallContext.currAccountId = acc.id;
            ccrz.cc_CallContext.userCurrency = 'USD';
            ccrz.cc_CallContext.effAccountId = acc.id;
            //ccrz.cc_CallContext.currCartId = cartID;
            ccrz.cc_CallContext.userLocale	= 'en_US';
            ccrz.cc_CallContext.currContact= cnts;
            ccrz.cc_CallContext.storeFrontSettings = storefrontsettings;
            ccrz.cc_CallContext.initRemoteContext(ctx);  

            ccrz__E_Cart__c currcart = new ccrz__E_Cart__c();
            currcart.ccrz__Name__c					=	'MyCart';
            currcart.ccrz__CartType__c				=	'Cart';
            currcart.ccrz__CurrencyISOCode__c		=	'USD';
            currcart.ccrz__ActiveCart__c			=	true;
            currcart.ccrz__Storefront__c			=	'CSSNAStore';
            currcart.ccrz__CartStatus__c			=	'Open';  
            currcart.ccrz__User__c					=	u.id;
            currcart.ccrz__Contact__c				=	cnts.id;
            currcart.ccrz__Account__c				=	cnts.accountid;  
            currcart.dbu_Cart_StoreCountry__c		=	storeCountry;
            currcart.dbu_storeLanguage__c			=	storeCountry;
            insert currcart;            
            
            ccrz__E_CartItem__c cartline  = dbu_FactoryDataTest.createCartItem(currcart.id, 78, 1, ProductRet[0].id);  
            insert cartline;              
            
            ccrz__E_Coupon__c currCrtCoupon = [select id from ccrz__E_Coupon__c where ccrz__CouponCode__c = 'T90MBT'];
            
            ccrz__E_CartCoupon__c appliedCoupon = new ccrz__E_CartCoupon__c();
            appliedCoupon.ccrz__Cart__c = currcart.id;
            appliedCoupon.CurrencyIsoCode = 'USD';
            appliedCoupon.Name = 'T90MBT';
            appliedCoupon.ccrz__Coupon__c = currCrtCoupon.id;
            insert appliedCoupon;            
            
            Map<string,object> InsertWithCart = dbu_FreqBgtProductsCtrl.insertOrUpdateMultipleCartitemsInFreqBgtProds(JSON.serialize(new list<object>{(string)ProductRet[0].id}), (string)currcart.id, storeCountry, 'US');
            
			Test.stopTest();            
        }        
        
    }    
    
}