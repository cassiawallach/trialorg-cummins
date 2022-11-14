@isTest
public with sharing class dbu_CouponCtrl_Test {
    /*
    private static string ACCOUNT_REGION 		=	'US and Canada';
    private static string TIMEZONE 				=	'(GMT-05:00) Eastern Standard Time (America/Panama)';
    private static string EMAIL_ENCODING 		=	'General US & Western Europe (ISO-8859-1, ISO-LATIN-1)';
    private static string LOCALE				=	'English(United States)';
    private static string LANGUAGE				=	'English';
    private static string BILLING_COUNTRY		=	'United States';
	private static string EMAIL					=	'testuser@gmail.com';    
    private static string COMPANY_NAME			=	'test user company';   
    private static string PHONE					=	'83689376493';   
    private static string STATUS				=	'Active';
    private static string FIRSTNAME				=	'Test';
    private static string LASTNAME				=	'Customer';
    private static string NICKNAME				=	'NickCustomer';
    private static string EMAIL_ENCODING_USER	=	'Unicode (UTF-8)';
    private static string USERNAME              =   'testuserkaazzanrussia@gmail.com.Tatarstan'; 
    
    
    @testSetup 
    static void SettingUpTestData() {

            //Get RecordTypeID 
            Id AccountRecordType = Schema.SObjectType.Account.getRecordTypeInfosByName().get('IAM Global').getRecordTypeId();
            
            //Get Profile Id - IAM User
            Id profileId = [Select Id From Profile Where Name='IAM User'].id;
            
            //Get Permission Sets
            List<PermissionSet> PermSetList = [SELECT id FROM PermissionSet where Name = 'B2BCommerceGuestCloneDefaultOwner' OR Name = 'eCommerce' LIMIT 2];
            
            //Setup Account for Logged In user
            Account acc 							=	dbu_FactoryDataTest.createIAMAccount('Identity Individual Users12yTest', AccountRecordType);
            insert acc;

			ccrz__E_PriceList__c TestPricelist = dbu_FactoryDataTest.createPriceList('TestPricelist');
            insert TestPricelist;
            
            //Setup Products
            list<ccrz__E_Product__c> TestProductList = new list<ccrz__E_Product__c>();
            ccrz__E_Product__c TestProduct1 = dbu_FactoryDataTest.createProduct('TestProduct1', true, true, true, false);
            TestProduct1.dbu_Crate_Engine__c = true;
        	TestProductList.add(TestProduct1);
            
            ccrz__E_Product__c TestProduct2 = dbu_FactoryDataTest.createProduct('TestProduct2', false, false, true, false);
            TestProductList.add(TestProduct2);
            
            ccrz__E_Product__c TestProduct3 = dbu_FactoryDataTest.createProduct('TestProduct3', true, false, false, true);
        	TestProduct3.dbu_Crate_Engine__c = true;    
        	TestProductList.add(TestProduct3);
            
            ccrz__E_Product__c TestProduct4 = dbu_FactoryDataTest.createProduct('TestProduct4', false, true, false, true);
            TestProductList.add(TestProduct4);
            
            ccrz__E_Product__c TestProduct5 = dbu_FactoryDataTest.createProduct('TestProduct5', false, false, false, true);
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
        
        /*
        ccrz__E_Rule__c ruleObj = new ccrz__E_Rule__c();
        ruleObj.ccrz__Name__c = 'MyCoupon';
        ruleObj.ccrz__RuleType__c = 'General';
        ruleObj.ccrz__RuleSource__c = 'Coupon';
        ruleObj.ccrz__Enabled__c = true;
        ruleObj.ccrz__StartDate__c = Date.parse('12/11/2019');
        ruleObj.ccrz__EndDate__c = Date.parse('12/11/2099');
        insert ruleObj;
        */
        /*
        ccrz__E_Coupon__c myCoupon = new ccrz__E_Coupon__c();
        myCoupon.ccrz__CouponName__c	 = 'MyCoupon';
        myCoupon.ccrz__CouponCode__c				 = 'MYC1';        
        myCoupon.ccrz__DiscountAmount__c			 =  12;
        myCoupon.ccrz__MaxUse__c = 20000;
        myCoupon.ccrz__Storefront__c = 'SoftwareStore';
        //myCoupon.ccrz__Rule__c = ruleObj.Id;
        myCoupon.ccrz__RuleType__c = 'General';
        myCoupon.ccrz__CouponType__c = 'Percentage';
        myCoupon.ccrz__DiscountType__c = 'Percentage';
        myCoupon.ccrz__StartDate__c = Date.parse('12/11/2019');
        myCoupon.ccrz__EndDate__c = Date.parse('12/11/2099');
        myCoupon.ccrz__Enabled__c = true;
        myCoupon.ccrz__TotalUsed__c = 55;
       // myCoupon.ccrz__CartTotalAmount__c = 50.00;
        myCoupon.dbu_Gift_Card__c = true;
        //myCoupon.dbu_Gift_Card_Amount__c = 550.00;
        //myCoupon.ccrz__SourceProduct__c = objProduct.Id;
        insert myCoupon;            
        
    }    
    */
    /*
	@isTest
    static void testmethod1(){                             
                        
        Test.startTest();
        account acc = [select id from account where name = 'Identity Individual Users12yTest'];
        ccrz__E_PriceList__c plista = [select id from ccrz__E_PriceList__c where Name = 'TestPricelist'];
        
       	ccrz__E_AccountGroup__c accgroup = dbu_FactoryDataTest.createAccountGroup('pityor', 'Best Price');
		insert accgroup;
            
		ccrz__E_AccountGroupPriceList__c accGroupPL = dbu_FactoryDataTest.createAccountGroupPriceList(accgroup.Id , plista.ID);
		insert accGroupPL;            
            
		acc.ccrz__E_AccountGroup__c					=	accgroup.id;
        update acc;    

        ccrz__E_Product__c ProductRet1 = [SELECT id FROM ccrz__E_Product__c WHERE Name = 'TestProduct1'];
        system.debug('ProductRet1 > ' + ProductRet1);
		ccrz__E_PriceListItem__c Priceline1 = [select ccrz__Price__c from ccrz__E_PriceListItem__c where ccrz__Product__c =: ProductRet1.id];
		system.debug('Priceline1 > ' + Priceline1);           

        ccrz__E_Product__c ProductRet2 = [SELECT id FROM ccrz__E_Product__c WHERE Name = 'TestProduct1'];
        system.debug('ProductRet2 > ' + ProductRet2);
		ccrz__E_PriceListItem__c Priceline2 = [select ccrz__Price__c from ccrz__E_PriceListItem__c where ccrz__Product__c =: ProductRet2.id];
		system.debug('Priceline2 > ' + Priceline2);      
        
            
        ccrz__E_Cart__c currcart = new ccrz__E_Cart__c();
        currcart.ccrz__Name__c					=	'MyCart';
        currcart.ccrz__CartType__c				=	'Cart';
        currcart.ccrz__CurrencyISOCode__c		=	'USD';
        currcart.ccrz__ActiveCart__c			=	true;
        currcart.ccrz__Storefront__c			=	'SoftwareStore';
        currcart.ccrz__CartStatus__c			=	'Open';  
        currcart.ccrz__Account__c				=	acc.id;            
        insert currcart;
        
        ccrz__E_CartItem__c cartline  = dbu_FactoryDataTest.createCartItem(currcart.id, (double)Priceline2.ccrz__Price__c, 1, ProductRet2.id);  
        insert cartline;         
    	
        ccrz__E_Coupon__c currentCoupon = [select id,ccrz__CouponCode__c from ccrz__E_Coupon__c where ccrz__CouponCode__c = 'MYC1'];
        
            
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
            ccrz.cc_CallContext.userLocale	= 'en_US';
            //ccrz.cc_CallContext.currContact= cnts;
            ccrz.cc_CallContext.storeFrontSettings = storefrontsettings;
            ccrz.cc_CallContext.initRemoteContext(ctx);                        

        dbu_CouponCtrl.couponVerified(currentCoupon.ccrz__CouponCode__c);
        dbu_CouponCtrl.couponVerified('MOSCOW');
        dbu_CouponCtrl.updateCartwithCouponDetails(currcart.Id,currentCoupon.ccrz__CouponCode__c);
        dbu_CouponCtrl.fetchLstCartItemsByCartIdAfterCoupon(currcart.Id);
        dbu_CouponCtrl.removeAppliedCoupon(currentCoupon.ccrz__CouponCode__c);            
                
        
        

        Test.stopTest();
        
        
        
    }
    */

/*================================================*/
/*This is temporay, will change it after UAT deployment*/
/*================================================*/

@isTest
    static void testmethod1(){    
        dbu_CouponCtrl.couponVerified('testCoupon');
        dbu_CouponCtrl.fetchLstCartItemsByCartIdAfterCoupon('testcartid');
        dbu_CouponCtrl.removeAppliedCoupon('testcartid');
        dbu_CouponCtrl.updateCartwithCouponDetails('00B61000002eeErEAI', 'testCouponCode');
    }
}