/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 09-15-2022
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
@isTest
public class dbu_CallCCWishListApi_Test {
    
    
      
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
    
    @testSetup 
    static void SettingUpTestData() {
        
        //UserRole userrole = [Select Id, DeveloperName From UserRole Where DeveloperName = 'CEO' Limit 1];

        //User adminUser = [Select Id, UserRoleId From User Where Profile.Name='System Administrator' AND IsActive=true AND UserRoleId =: userrole.Id Limit 1];
        
        //adminUser.UserRoleId = userRole.Id;
        
        
        UserRole userRole_1 = [SELECT Id FROM UserRole WHERE DeveloperName = 'CEO' LIMIT 1];
        Profile profile_1 = [SELECT Id FROM Profile WHERE name = 'IAM User' LIMIT 1];
        User admin = [SELECT Id, Username, UserRoleId FROM User WHERE Profile.Name = 'System Administrator' and IsActive = true LIMIT 1];
        admin.UserRoleId = userRole_1.Id;
        update admin;   
             
        
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

            //Setup Contact for Logged In user - without Wishlist
            //Contact con								=	dbu_FactoryDataTest.createIAMContact(FIRSTNAME, LASTNAME, acc.id, ContactRecordTypeId);
        	//con.Username__c							=	UserInfo.getUserName();
        	String orgId = UserInfo.getOrganizationId();  
            String dateString =   
            String.valueof(Datetime.now()).replace(' ','').replace(':','').replace('-','');  
            Integer randomInt = Integer.valueOf(math.rint(math.random()*1000000));  
            String uniqueName = orgId + dateString + randomInt;
        	//con.Username__c							=	uniqueName + '@test' + orgId + '.org';
            
	        Contact con = new Contact(LastName = LASTNAME, FirstName = FIRSTNAME ,AccountId = acc.id);  
            con.Username__c = uniqueName + '@test' + orgId + '.org'; 
            insert con;
        
            
            //Setup user for Logged In user
            
            //user usr								=	dbu_FactoryDataTest.createIAMUser(FIRSTNAME, LASTNAME, con.id, profileId);
            //insert usr;

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
           
            
            /*
            //Assigning Permission Sets
            List<PermissionSetAssignment> PermSetAssgmtList = new list<PermissionSetAssignment>();
            for(PermissionSet Perm : PermSetList){
                PermissionSetAssignment psa = new PermissionSetAssignment
                    (PermissionSetId = Perm.id, AssigneeId = usr.id);
                PermSetAssgmtList.add(psa);            
            }
            insert PermSetAssgmtList; 
            */
        	/*
            //Update contact with the UserID
            List<Contact> upcon = [select id, IAM_Contact_Owner__c FROM Contact WHERE id =: con.id];
            for(Contact c : upcon){
                c.IAM_Contact_Owner__c = usr.id;
            }
            update upcon;
            */
        
            //Setup PriceList 
        string storeCountry = 'US';    
        system.runAs(usr){
			ccrz__E_PriceList__c TestPricelist = dbu_FactoryDataTest.createPriceList('TestPricelist');
            insert TestPricelist;
			           
            //Setup Products
            list<ccrz__E_Product__c> TestProductList = new list<ccrz__E_Product__c>();
            ccrz__E_Product__c TestProduct1 = dbu_FactoryDataTest.createProduct('TestProduct1', true, true, true, false);
            TestProduct1.DBU_Product_Location__c = storeCountry;
            TestProduct1.dbu_Crate_Engine__c = true;
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
            
        }
        
        
        
		        
        
        

        
        //Setup Cart
        //Setup WishList
        
        
    }
    
    @isTest
    static void testmethod1(){
        system.debug('ulrich');
        
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
            
            
            ccrz__E_Product__c ProductRet = [SELECT id FROM ccrz__E_Product__c WHERE Name = 'TestProduct1'];
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
            
            
            dbu_SaveForLaterWrapper wrapperCls = new dbu_SaveForLaterWrapper();
            wrapperCls.ProductID 	=	 ProductRet.id;
            wrapperCls.ProductName	=	'TestProduct1';
            wrapperCls.ProductPrice	=	100;
            wrapperCls.ProductURL	=	'https://cssna-parts.gdc-rad.com/4940181.png';
            wrapperCls.ProductQuantity	=	6;
            wrapperCls.IsCrateProductCheck = true;
			wrapperCls.IsCoreProductcheck = false;         
            List<dbu_SaveForLaterWrapper> AddtoList = dbu_SaveForLatetGeneric.AddProductTo_WishList_or_SaveForLater_forLoggedInUser(ProductRet.id, storeCountry, '6', 'Save For Later','US');
            system.debug('AddtoList >'+ AddtoList);
            
            ccrz__E_Product__c ProductRet2 = [SELECT id FROM ccrz__E_Product__c WHERE Name = 'TestProduct2'];
            
            dbu_SaveForLaterWrapper wrapperCls2 = new dbu_SaveForLaterWrapper();
            wrapperCls2.ProductID 	=	 ProductRet2.id;
            wrapperCls2.ProductName	=	'TestProduct2';
            wrapperCls2.ProductPrice	=	101;
            wrapperCls2.ProductURL	=	'https://cssna-parts.gdc-rad.com/4940181.png';
            wrapperCls2.ProductQuantity	=	3;
            wrapperCls2.IsCrateProductCheck = false;
            wrapperCls2.IsCoreProductcheck = false;
            
            List<dbu_SaveForLaterWrapper> AddtoList2 = dbu_SaveForLatetGeneric.AddProductTo_WishList_or_SaveForLater_forLoggedInUser(ProductRet2.id, storeCountry, '3', 'Save For Later','US');
            
            
            List<dbu_SaveForLaterWrapper> FthWLitems = dbu_SaveForLatetGeneric.fetchLoggedInUserWishlistItems('Save For Later', storeCountry,'US');
            system.debug(FthWLitems);	
            
            ccrz__E_Product__c ProductRetcore = [SELECT id FROM ccrz__E_Product__c WHERE Name = 'TestProductcorechild'];            
            
            List<dbu_SaveForLaterWrapper> AddtoList3 = dbu_SaveForLatetGeneric.AddProductTo_WishList_or_SaveForLater_forLoggedInUser(ProductRetcore.id, storeCountry, '3', 'Save For Later','US');
            //List<dbu_SaveForLaterWrapper> AddtoList4 = dbu_SaveForLatetGeneric.AddProductTo_WishList_or_SaveForLater_forLoggedInUser(ProductRetcore.id, storeCountry, '3', 'WishList');
            
                

            Test.stopTest();            
        }

    }
    
    @isTest
    static void testmethod11(){
        system.debug('ulrich');
        
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
        
		test.startTest();                        
        user u = [select id,Contactid from User where Email = 'xyznazgul@ringwraiths.com'];        
        //user ussr = [select id from user where id =: userinfo.getUserId()];
        account acc = [select id from account where name = 'Identity Individual Users12yTest'];
        
    	contact cnts = [select id from contact where id =: u.Contactid];
        string ContactID = u.Contactid;        
        string storeCountry = 'US';
        system.runAs(u){
            
            

            
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
            
                                 
            ccrz__E_Product__c ProductRetcore = [SELECT id FROM ccrz__E_Product__c WHERE Name = 'TestProductcorechild'];            
            
			            
            List<dbu_SaveForLaterWrapper> AddtoList4 = dbu_SaveForLatetGeneric.AddProductTo_WishList_or_SaveForLater_forLoggedInUser(ProductRetcore.id, storeCountry, '3', 'WishList','US');
            
          //insert wishlist
           ccrz__E_Cart__c WLItem =	new ccrz__E_Cart__c();
           WLItem.ccrz__Name__c					=	'MyWishlist';
           WLItem.ccrz__CartType__c				=	'Wishlist';
            WLItem.ccrz__CurrencyISOCode__c		=	'USD';
            WLItem.ccrz__ActiveCart__c			=	false;
            WLItem.ccrz__Storefront__c			=	'CSSNAStore';
            WLItem.ccrz__CartStatus__c			=	'Open';  
            WLItem.ccrz__User__c				=	u.id;
            WLItem.ccrz__Contact__c				=	cnts.id;
            WLItem.ccrz__Account__c				=	acc.id;
            WLItem.dbu_Cart_StoreCountry__c		=	storeCountry;
           insert WLItem;            

			List<dbu_SaveForLaterWrapper> AddtoList5 = dbu_SaveForLatetGeneric.AddProductTo_WishList_or_SaveForLater_forLoggedInUser(ProductRetcore.id, storeCountry, '3', 'WishList','US');            
            List<dbu_SaveForLaterWrapper> AddtoList6 = dbu_SaveForLatetGeneric.AddProductTo_WishList_or_SaveForLater_forLoggedInUser(ProductRetcore.id, storeCountry, '3', 'Save For Later','US');            
			List<dbu_SaveForLaterWrapper> FthWLitems = dbu_SaveForLatetGeneric.fetchLoggedInUserWishlistItems('Save For Later', storeCountry,'US');
            boolean isproductcheck = dbu_CallCCWishListApi.IfProductInDefaultWishlist((string)WLItem.id,ProductRetcore.id, 'Save For Later');
            Test.stopTest();            
        }

    }    
    
    
    @isTest
    static void testmethod2(){
        system.debug('ulrich 2');
        
        //Get user
		string storeCountry = 'US';
        user u = [select id,Contactid from User where Email = 'xyznazgul@ringwraiths.com'];        
        //user ussr = [select id from user where id =: userinfo.getUserId()];
        account acc = [select id from account where name = 'Identity Individual Users12yTest'];
        
    	contact cnts = [select id from contact where id =: u.Contactid];
        string ContactID = u.Contactid; 
        
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
        
        
        system.runAs(u){
    	
            
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

            
    	//INSERT WISHLIST AND WISHLIST ITEMS
    	string WishListID = dbu_CallCCWishListApi.createDefaultWishlist(ContactID, storeCountry,'US');
        
        ccrz__E_Product__c ProductRet2 = [SELECT id FROM ccrz__E_Product__c WHERE Name = 'TestProduct2'];
            
        list<dbu_SaveForLaterWrapper> ProdAddedToWishlist = dbu_CallCCWishListApi.AddToDefaultWishlist(WishListID, string.valueof(ProductRet2.id) , 'Save For Later', '5', storeCountry);    
        boolean IsDeleted = dbu_SaveForLatetGeneric.deleteDefaultWishlist_WishListItem_OR_SaveforLaterItem(string.valueof(ProductRet2.id), 'Save For Later', storeCountry);    
    	system.debug(IsDeleted);
        }
    }
    
    @isTest
    static void testmethod3(){

        user u = [select id,Contactid from User where Email = 'xyznazgul@ringwraiths.com'];
        //user ussr = [select id from user where id =: userinfo.getUserId()];
        account acc = [select id from account where name = 'Identity Individual Users12yTest'];
        string storeCountry = 'US';
    	contact cnts = [select id from contact where id =: u.Contactid];
        string ContactID = u.Contactid;
                            
        
        List<ccrz__E_Product__c> ProductRetlst = [SELECT id, 
                                           (select ccrz__Price__c	from ccrz__E_PriceListItems__r where ccrz__Pricelist__r.ccrz__CurrencyISOCode__c =: 'USD'),
                                           (select ccrz__URI__c from ccrz__E_ProductMedias__r where ccrz__URI__c != null)                                                                                                                                                                           
                                           FROM ccrz__E_Product__c];
        system.debug('ProductRetlst > ' +ProductRetlst.size());        
        
        list<string> ProductIDList = new list<string>();
        
        for(ccrz__E_Product__c Prod : ProductRetlst){
            ProductIDList.add((string)Prod.id);
        }

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
        
        
        List<dbu_SaveForLaterWrapper> retProductList = dbu_SaveForLatetGeneric.fetchProductDetailsByProductID(JSON.serialize(ProductIDList), storeCountry);
        
        system.debug('retProductList > ' + retProductList);
        //system.assertEquals(5, retProductList.size());
    }
    
    @isTest
    static void testmethod4(){           

        user usrId = [select id,Contactid from User where Email = 'xyznazgul@ringwraiths.com'];
        //user ussr = [select id from user where id =: userinfo.getUserId()];
        account acc = [select id from account where name = 'Identity Individual Users12yTest'];
        string storeCountry = 'US';
    	contact cnt = [select id,AccountId from contact where id =: usrId.Contactid];
        string ContactID = usrId.Contactid;

        system.runAs(usrId){                        
        Test.startTest();
            
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
                        
                        
            ccrz.cc_RemoteActionContext ctx = new ccrz.cc_RemoteActionContext();
            ctx.storefront = 'CSSNAStore';
            ccrz.cc_CallContext.currAccountId = acc.id;
            ccrz.cc_CallContext.userCurrency = 'USD';
            ccrz.cc_CallContext.effAccountId = acc.id;
            //ccrz.cc_CallContext.currCartId = cartID;
            ccrz.cc_CallContext.userLocale	= 'en_US';
            ccrz.cc_CallContext.currContact= cnt;
            ccrz.cc_CallContext.storeFrontSettings = storefrontsettings;
            ccrz.cc_CallContext.initRemoteContext(ctx);   
            
            
        ccrz__E_Cart__c currentUserCart =  dbu_FactoryDataTest.createCart('MyCart', 'Cart', usrId.id, usrId.ContactId, cnt.accountid, true);
        currentUserCart.dbu_Cart_StoreCountry__c = storeCountry;
        insert currentUserCart;
        system.debug('currentUserCart.id > ' + currentUserCart.id);
        
        list<ccrz__E_Product__c> ProductRet = [SELECT id FROM ccrz__E_Product__c];
        
        list<ccrz__E_PriceListItem__c> Pricelines = [select ccrz__Product__c,ccrz__Price__c from ccrz__E_PriceListItem__c where ccrz__Product__c in : ProductRet];
        system.debug('Pricelines > ' + Pricelines);
        
        list<ccrz__E_CartItem__c> crtLinesList = new list<ccrz__E_CartItem__c>();
        
        double Qcounter = 0;    
        for(ccrz__E_PriceListItem__c PrcLn : Pricelines){
            ccrz__E_CartItem__c crtline = dbu_FactoryDataTest.createCartItem(currentUserCart.id, (double)PrcLn.ccrz__Price__c, Qcounter, PrcLn.ccrz__Product__c);
            Qcounter = Qcounter + 1;
            crtLinesList.add(crtline);
        }
        
		list<string> CLIlist = new list<string>();
        insert crtLinesList;
        
		list<ccrz__E_CartItem__c> cl = new list<ccrz__E_CartItem__c>();
        cl = [select id from ccrz__E_CartItem__c where ccrz__Cart__c =: currentUserCart.id];
        system.debug('cl > ' + cl);
        for(ccrz__E_CartItem__c c : cl){
            CLIlist.add(c.Id);
        }
        
        system.debug('CLIlist > ' +CLIlist); 
        
        list<string> GCP = dbu_SaveForLatetGeneric.GetCartProducts((string)currentUserCart.id);
        
        boolean delCLI = dbu_SaveForLatetGeneric.deleteCartItemSFLGeneric(JSON.serialize(CLIlist),(string)currentUserCart.id);
        system.debug('CLIlist > ' +CLIlist);
        string cId = dbu_SaveForLatetGeneric.getcurrentCartItemCartID(CLIlist[0]);
        
     
        Test.stopTest();
        
        
    }
    }
    
             

    @isTest
    static void testmethod5(){
        system.debug('ulrich 5');
        Test.startTest();
        //Get user
        string storeCountry = 'US';
        string storeLanguage = 'US';
        user u = [select id,Contactid from User where Email = 'xyznazgul@ringwraiths.com'];
        //user ussr = [select id from user where id =: userinfo.getUserId()];
        account acc = [select id from account where name = 'Identity Individual Users12yTest'];
        system.runAs(u){
    	contact cnts = [select id,accountid from contact where id =: u.Contactid];
        string ContactID = u.Contactid;
            
            
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
                        
        ccrz__E_Product__c ProductRet1 = [SELECT id FROM ccrz__E_Product__c WHERE Name = 'TestProduct1'];
        system.debug('ProductRet1 > ' + ProductRet1);
		ccrz__E_PriceListItem__c Priceline1 = [select ccrz__Price__c from ccrz__E_PriceListItem__c where ccrz__Product__c =: ProductRet1.id];
		system.debug('Priceline1 > ' + Priceline1);           

        ccrz__E_Product__c ProductRet2 = [SELECT id FROM ccrz__E_Product__c WHERE Name = 'TestProduct1'];
        system.debug('ProductRet2 > ' + ProductRet2);
		ccrz__E_PriceListItem__c Priceline2 = [select ccrz__Price__c from ccrz__E_PriceListItem__c where ccrz__Product__c =: ProductRet2.id];
		system.debug('Priceline2 > ' + Priceline2);  
            
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
            
          //insert wishlist
           ccrz__E_Cart__c WLItem =	new ccrz__E_Cart__c();
           WLItem.ccrz__Name__c					=	'MyWishlist';
           WLItem.ccrz__CartType__c				=	'Wishlist';
            WLItem.ccrz__CurrencyISOCode__c		=	'USD';
            WLItem.ccrz__ActiveCart__c			=	false;
            WLItem.ccrz__Storefront__c			=	'CSSNAStore';
            WLItem.ccrz__CartStatus__c			=	'Open';  
            WLItem.ccrz__User__c				=	u.id;
            WLItem.ccrz__Contact__c				=	cnts.id;
            WLItem.ccrz__Account__c				=	cnts.accountid;
            WLItem.dbu_Cart_StoreCountry__c		=	storeCountry;
           insert WLItem;
            
           ccrz__E_CartItem__c wishlistline  = dbu_FactoryDataTest.createCartItem(WLItem.id, (double)Priceline1.ccrz__Price__c, 1, ProductRet1.id);  
           wishlistline.DBU_SaveForLater__c =  'Save For Later';
           insert  wishlistline;	
           
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
           insert currcart;
           
           ccrz__E_CartItem__c cartline  = dbu_FactoryDataTest.createCartItem(currcart.id, (double)Priceline2.ccrz__Price__c, 1, ProductRet2.id);  
           insert cartline;
            
            List<Map<string,object>> prodQtyMapList = new list<Map<string,object>>();
            Map<string,object> Ty1 = new Map<string,object>();
            Map<string,object> Ty2 = new Map<string,object>();
			Ty1.put('id',(string)ProductRet1.id);
            Ty1.put('Quantity', 5);
            prodQtyMapList.add(Ty1);
            Ty2.put('id',(string)ProductRet2.id);
            Ty2.put('Quantity', 5);
            prodQtyMapList.add(Ty2);
                
                       
            Map<string,list<dbu_SaveForLaterWrapper>> ProdtsAddedtoCart = dbu_SaveForLatetGeneric.AddProductToCart_From_WishList('Save For Later', JSON.serialize(prodQtyMapList), storeCountry, storeLanguage);
            system.debug('ProdtsAddedtoCart > ' + ProdtsAddedtoCart);
        Test.stopTest();
        //boolean IsDeleted = dbu_SaveForLatetGeneric.deleteDefaultWishlist_WishListItem_OR_SaveforLaterItem(string.valueof(ProductRet2.id), 'Save For Later');    
    	//system.debug(IsDeleted);
        }
        
        
    }

  
}