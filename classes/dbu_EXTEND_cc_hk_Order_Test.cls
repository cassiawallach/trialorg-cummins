/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 07-13-2022
 * @last modified by  : Devaraj for common class
**/
@isTest
public class dbu_EXTEND_cc_hk_Order_Test {
   
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
            String orgId = UserInfo.getOrganizationId();  
            String dateString = String.valueof(Datetime.now()).replace(' ','').replace(':','').replace('-','');  
            Integer randomInt = Integer.valueOf(math.rint(math.random()*1000000));  
            String uniqueName = orgId + dateString + randomInt;            
            
            Contact con = new Contact(LastName = LASTNAME, FirstName = FIRSTNAME ,AccountId = acc.id, Email= 'klemen@jo.com');  
            con.Username__c = uniqueName + '@test' + orgId + '.org'; 
            insert con;
                
           //Setup addresses
            list<ccrz__E_ContactAddr__c> addressList = new list<ccrz__E_ContactAddr__c>();
            ccrz__E_ContactAddr__c pickupaddress = new ccrz__E_ContactAddr__c ();
            pickupaddress.ccrz__FirstName__c = 'AMICAM';
            pickupaddress.ccrz__LastName__c = 'YEHUD';
            pickupaddress.dbu_PickUp_Store_Name__c = 'Cummins Sales & Service - Fairbanks';
            pickupaddress.ccrz__AddressFirstline__c = 'ARIEL SHARON STREET';
            pickupaddress.ccrz__City__c = 'TEL AVIV';
            pickupaddress.ccrz__State__c = 'TEL AVIV';
            pickupaddress.ccrz__Country__c = 'ISRAEL';
            pickupaddress.ccrz__PostalCode__c = '90001';
            pickupaddress.CurrencyIsoCode = 'USD';
            pickupaddress.dbu_StartEndTimeOfStore__c = '8:00 AM - 5:00 PM YST';
            pickupaddress.dbu_zone__c = 'MDC';
            pickupaddress.dbu_TimeZone__c = 'YST';
            pickupaddress.dbu_StoreSFId__c = 'ASHKELON';
            pickupaddress.ccrz__ShippingComments__c = 'pickup';
            addressList.add(pickupaddress);
            
            ccrz__E_ContactAddr__c shipToaddress = new ccrz__E_ContactAddr__c ();
            shipToaddress.ccrz__FirstName__c = 'ITZHAK';
            shipToaddress.ccrz__LastName__c = 'STEIN';
            shipToaddress.ccrz__AddressFirstline__c = 'GOLDA MEIR STREET';
            shipToaddress.ccrz__City__c = 'ASHDOD';
            shipToaddress.ccrz__State__c = 'GOLAN HEIGHTS';
            shipToaddress.ccrz__Country__c = 'ISRAEL';
            shipToaddress.ccrz__PostalCode__c = '90001';
            shipToaddress.CurrencyIsoCode = 'USD'; 
            shipToaddress.ccrz__ShippingComments__c = 'shipto';
            addressList.add(shipToaddress);
            
            ccrz__E_ContactAddr__c BillingAddress = new ccrz__E_ContactAddr__c ();
            BillingAddress.ccrz__FirstName__c = 'MOTTA';
            BillingAddress.ccrz__LastName__c = 'GUR';                    
            BillingAddress.ccrz__AddressFirstline__c = 'GOLDA MEIR STREET';
            BillingAddress.ccrz__City__c = 'ASHDOD';
            BillingAddress.ccrz__State__c = 'GOLAN HEIGHTS';
            BillingAddress.ccrz__Country__c = 'ISRAEL';
            BillingAddress.ccrz__PostalCode__c = '90001';
            BillingAddress.CurrencyIsoCode = 'USD';  
            BillingAddress.ccrz__ShippingComments__c = 'billto';
            addressList.add(BillingAddress);
            
            insert addressList;                
                
            
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
                TestProduct1.dbu_Crate_Engine__c = true;
                TestProduct1.dbu_Available_to_ship__c = true;
                TestProduct1.dbu_Pick_Up_Only__c = false;                
                TestProductList.add(TestProduct1);
                
                ccrz__E_Product__c TestProduct2 = dbu_FactoryDataTest.createProduct('TestProduct2', false, false, true, false);
                TestProduct2.DBU_Product_Location__c = storeCountry;
                TestProduct2.dbu_Available_to_ship__c = true;
                TestProduct2.dbu_Pick_Up_Only__c = false;
                TestProductList.add(TestProduct2);
                
                ccrz__E_Product__c TestProduct3 = dbu_FactoryDataTest.createProduct('TestProduct3', true, false, false, true);
                TestProduct3.DBU_Product_Location__c = storeCountry;
                TestProduct3.dbu_Available_to_ship__c = true;
                TestProduct3.dbu_Pick_Up_Only__c = false;                
                TestProductList.add(TestProduct3);
                
                ccrz__E_Product__c TestProduct4 = dbu_FactoryDataTest.createProduct('TestProduct4', false, true, false, true);
                TestProduct4.DBU_Product_Location__c = storeCountry;
                TestProduct4.dbu_Has_Core_Charge__c = true;
                TestProduct4.dbu_Available_to_ship__c = false;
                TestProduct4.dbu_Pick_Up_Only__c = true;                
                TestProductList.add(TestProduct4);
                
                ccrz__E_Product__c TestProduct5 = dbu_FactoryDataTest.createProduct('TestProduct5', false, false, false, true);
                TestProduct5.DBU_Product_Location__c = storeCountry;
                TestProduct5.dbu_Available_to_ship__c = false;
                TestProduct5.dbu_Pick_Up_Only__c = true;                
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
                
                system.debug('TestProduct4 id > ' + TestProduct4.id);
                
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
    static void testmethod5(){
        
        Test.startTest();
        
        string storeCountry = 'US';
        string storeLanguage = 'US';  
        
        list<dbu_CountryCurrencyMapping__c> kavkaz = new list<dbu_CountryCurrencyMapping__c>();
        dbu_CountryCurrencyMapping__c cusBazarak = new dbu_CountryCurrencyMapping__c();
        cusBazarak.dbuCountryCode__c = 'US';
        cusBazarak.dbuCurrencyCode__c = 'USD';
        cusBazarak.Name = 'United States of America';
        kavkaz.add(cusBazarak);
        
        
        dbu_CountryCurrencyMapping__c cusBazarakCan = new dbu_CountryCurrencyMapping__c();
        cusBazarakCan.dbuCountryCode__c = 'CA';
        cusBazarakCan.dbuCurrencyCode__c = 'CAD';
        cusBazarakCan.Name = 'Canada';
        kavkaz.add(cusBazarakCan);
        insert kavkaz;           
        
        //SHIP
        ccrz__E_Product__c ProductRet1 = [SELECT id FROM ccrz__E_Product__c WHERE Name = 'TestProduct3'];
        system.debug('ProductRet1 > ' + ProductRet1);
        ccrz__E_PriceListItem__c Priceline1 = [select ccrz__Price__c from ccrz__E_PriceListItem__c where ccrz__Product__c =: ProductRet1.id];
        system.debug('Priceline1 > ' + Priceline1);           
        
        //PICKUP
        ccrz__E_Product__c ProductRet2 = [SELECT id FROM ccrz__E_Product__c WHERE Name = 'TestProduct5'];
        system.debug('ProductRet2 > ' + ProductRet2);
        ccrz__E_PriceListItem__c Priceline2 = [select ccrz__Price__c from ccrz__E_PriceListItem__c where ccrz__Product__c =: ProductRet2.id];
        system.debug('Priceline2 > ' + Priceline2);          
        
        list<ccrz__E_ContactAddr__c> contactaddresslist = new list<ccrz__E_ContactAddr__c>();
        contactaddresslist = [select id,ccrz__ShippingComments__c from ccrz__E_ContactAddr__c];
        string billto;
        string shipto;
        string pickup;
        
        if(contactaddresslist.size() > 0){
            for(ccrz__E_ContactAddr__c eachaddress : contactaddresslist){
                if(eachaddress.ccrz__ShippingComments__c == 'billto'){
                    billto = eachaddress.id;    
                }
                
                if(eachaddress.ccrz__ShippingComments__c == 'shipto'){
                    shipto = eachaddress.id;
                }
                
                if(eachaddress.ccrz__ShippingComments__c == 'pickup'){
                    pickup = eachaddress.id;
                }            
            }            
        }
        
        
        
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
            		currcart.ccrz__BillTo__c				=	billto;
            		currcart.ccrz__ShipTo__c				=	shipto;
            		currcart.dbu_Pick_Up_From_Store__c		=	pickup;
                    insert currcart;         
    
            		list<ccrz__E_CartItem__c> cartlineitemslist = new list<ccrz__E_CartItem__c>();
                    ccrz__E_CartItem__c shipcartline  = dbu_FactoryDataTest.createCartItem(currcart.id, (double)Priceline1.ccrz__Price__c, 1, ProductRet1.id);  
                    shipcartline.dbu_isShipTo__c = true;
            		shipcartline.dbu_Estimated_Delivery__c = 'November 2 - November - 8';
            		shipcartline.dbu_Estimated_PickUp__c = '';
            		cartlineitemslist.add(shipcartline);		
            
            
                    ccrz__E_CartItem__c pickcartline  = dbu_FactoryDataTest.createCartItem(currcart.id, (double)Priceline2.ccrz__Price__c, 1, ProductRet2.id);  
                    pickcartline.dbu_isShipTo__c = false;
            		pickcartline.dbu_Estimated_Delivery__c = '';
            		pickcartline.dbu_Estimated_PickUp__c = 'October 29';
            		cartlineitemslist.add(pickcartline);
            		
            		insert cartlineitemslist;
            		
                    Map<string,object> InputMap = new Map<string,object>{
                    	'placeStep' => 'fetchCartItems',
                        'cartItems' => cartlineitemslist,
                        'cartId' => currcart.id                            
                    };
            		
            		dbu_EXTEND_cc_hk_Order orderhook = new dbu_EXTEND_cc_hk_Order();
                    orderhook.place(InputMap);
            		
                    ccrz__E_Order__c currorder = new ccrz__E_Order__c();
                    currorder.ccrz__OrderNumber__c = 1124669;
                    currorder.ccrz__Name__c = 'MY ORDER';
                    currorder.ccrz__OriginatedCart__c = currcart.id;
                    currorder.ccrz__PaymentMethod__c = 'credit card';
                    currorder.ccrz__Storefront__c = 'CSSNAStore';
                    currorder.ccrz__CurrencyISOCode__c = 'USD';
                    currorder.ccrz__EncryptedId__c = 'Arakanovici-IO278ci3-'+Math.random();
                    currorder.ccrz__OrderStatus__c = 'Open';
                    currorder.ccrz__OrderDate__c = Date.parse('6/20/2020');
                    currorder.ccrz__BillTo__c = billto;
                    currorder.ccrz__ShipTo__c = shipto;
                    currorder.ccrz__User__c = u.id;
                    currorder.ccrz__Account__c = cnts.accountid;
                	currorder.ccrz__BuyerEmail__c = 'gentlemenofcali@colombia.com';
                    Map<string,object> InputMap1 = new Map<string,object>{
                    	'placeStep' => 'createOrderPre',
                        'order' => currorder,
                        'cartId' => currcart.id                            
                    };            		
            
					orderhook.place(InputMap1);
            		
            		insert currorder;
            
            		
                    list<ccrz__E_OrderItem__c> orderlineslist = new list<ccrz__E_OrderItem__c>();
                    for(integer i=0 ;i<=1 ; i++){
                        ccrz__E_OrderItem__c eachorderline = new ccrz__E_OrderItem__c();
                        eachorderline.ccrz__Order__c = currorder.Id;
                        eachorderline.ccrz__Quantity__c = 1;
                        eachorderline.ccrz__PricingType__c = 'auto';                        
                        eachorderline.ccrz__OrderLineType__c = 'Major';
                        eachorderline.ccrz__ProductType__c = 'Product';
                            eachorderline.ccrz__UnitOfMeasure__c = 'Each';
                            eachorderline.ccrz__OrderItemStatus__c = 'Order Submitted';
                            
                            eachorderline.ccrz__StoreId__c = 'CSSNAStore';
                            eachorderline.ccrz__ItemStatus__c = 'Available';                            
                            eachorderline.ccrz__OriginalQuantity__c = 1;
                        if(i<1){
                            eachorderline.ccrz__OrderItemId__c = shipcartline.id;                        
                            eachorderline.ccrz__OriginalItemPrice__c = Priceline1.ccrz__Price__c;  
                            eachorderline.ccrz__SubAmount__c = Priceline1.ccrz__Price__c;
                            eachorderline.ccrz__Price__c = Priceline1.ccrz__Price__c;   
                        	eachorderline.ccrz__Product__c = ProductRet1.id;                            
                        }else{
                            eachorderline.ccrz__OrderItemId__c = pickcartline.id;                        
                            eachorderline.ccrz__OriginalItemPrice__c = Priceline2.ccrz__Price__c;  
                            eachorderline.ccrz__SubAmount__c = Priceline2.ccrz__Price__c;
                            eachorderline.ccrz__Price__c = Priceline2.ccrz__Price__c;     
                        	eachorderline.ccrz__Product__c = ProductRet2.id;                            
                        }
                        orderlineslist.add(eachorderline);
                    }
            		
                    Map<string,object> InputMap2 = new Map<string,object>{
                    	'placeStep' => 'orderItemsPre',
                        'cartItems' => cartlineitemslist,
                        'orderItems' => orderlineslist,    
                        'cartId' => currcart.id,
						'order' => currorder                            
                    };        					
                        
					orderhook.place(InputMap2);                        
            		
            
        }        
        
        
        Test.stopTest();
        
    }    
    
}