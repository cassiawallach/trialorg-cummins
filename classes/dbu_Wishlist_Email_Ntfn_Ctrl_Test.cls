@isTest
public class dbu_Wishlist_Email_Ntfn_Ctrl_Test {

    private static string ACCOUNT_REGION 		=	'US and Canada';
    private static string TIMEZONE 				=	'America/Panama';
    private static string EMAIL_ENCODING 		=	'ISO-8859-1';
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
        //system.debug('junker');
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
            
            Contact con = new Contact(LastName = LASTNAME, FirstName = FIRSTNAME ,AccountId = acc.id, Email= 'klemen@jo.com');  
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
        
        Test.startTest();
			user u = [select id,Contactid from User where Email = 'xyztestuser@gmail.com'];    
        	ccrz__E_Product__c TestProduct3 = [select id from ccrz__E_Product__c where Name = 'TestProduct3']; 	
        	contact cnts = [select id,accountid from contact where id =: u.Contactid];
        
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
            WLItem.dbu_Cart_StoreCountry__c		=	'CA';
        	WLItem.dbu_storeLanguage__c			=	'FR';
            insert WLItem; 
        
            ccrz__E_CartItem__c wishlistlinewl  = dbu_FactoryDataTest.createCartItem(WLItem.id, 77, 1, TestProduct3.id);  
            wishlistlinewl.DBU_SaveForLater__c =  'WishList';
            insert  wishlistlinewl;	 

        	list<id> eachdbuemailer = new list<id>();	
        	
        	dbu_Emailer__c eachEmailer = new dbu_Emailer__c();
        	eachEmailer.dbu_Contact_Email__c = 'kirov@gmail.com';            
            eachEmailer.dbu_Email_Contact__c = u.Contactid;
            eachEmailer.dbu_Email_for_Wishlist__c = false;
            eachEmailer.dbu_Email_Sending_Initiated__c = false;
            eachEmailer.dbu_Email_Sent__c = false;
            eachEmailer.dbu_Wishlist_Country__c = 'CA';
        	eachEmailer.dbu_Wishlist_Language__c = 'FR';
        	insert eachEmailer;
        	eachdbuemailer.add(eachEmailer.id);
        
        	dbu_Email_Content__c eachdbuemailContent = new dbu_Email_Content__c();
	       	eachdbuemailContent.CC_Product_Name__c = TestProduct3.id;
            eachdbuemailContent.dbu_Product_Inventory_Status__c = true;
            eachdbuemailContent.dbu_Product_Price__c = 76;            
            eachdbuemailContent.dbu_WishlistItem_ID__c = wishlistlinewl.id;
            eachdbuemailContent.dbu_Product_URI__c = 'www.google.com';
            eachdbuemailContent.dbu_Emailer__c = eachEmailer.id;
            insert eachdbuemailContent; 
        
        	dbu_Wishlist_Email_Notification_Ctrl wishlistTemplateController = new dbu_Wishlist_Email_Notification_Ctrl();
        	wishlistTemplateController.dbuEmailerId = eachEmailer.id;
        	wishlistTemplateController.getEachProduct();
        
        Test.stopTest();
    }
}