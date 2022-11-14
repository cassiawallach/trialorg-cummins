/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 05-31-2022
 * @last modified by  : Devaraj
**/
@isTest
public class dbu_callCCApi_Test {   
    
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
    private static string USERNAME              =   'testuserkaazzanrussia@gmail.com';     
    private static string USERID              =   '';     
    
    @testSetup 
    static void SettingUpTestData() {
                
        UserRole userRole_1 = [SELECT Id FROM UserRole WHERE DeveloperName = 'CEO' LIMIT 1];
        Profile profile_1 = [SELECT Id FROM Profile WHERE name = 'IAM User' LIMIT 1];
        User admin = [SELECT Id, Username, UserRoleId FROM User WHERE Profile.Name = 'System Administrator' and IsActive = true LIMIT 1];
        admin.UserRoleId = userRole_1.Id;
        update admin;
        
        System.runAs(admin) {        
        
        //string FIRSTNAME				=	'Test2';
        //string LASTNAME					=	'Customers';

        Id AccountRecordType = Schema.SObjectType.Account.getRecordTypeInfosByName().get('IAM Global').getRecordTypeId();
        //Id ContactRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('IAM').getRecordTypeId();
        
        //Get Profile Id - IAM User
        Id profileId = [Select Id From Profile Where Name='IAM User'].id;
        
        //Get Permission Sets
        //List<PermissionSet> PermSetList = [SELECT id FROM PermissionSet where Name = 'B2BCommerceGuestCloneDefaultOwner' OR Name = 'eCommerce' LIMIT 2];
        
        //Setup Account for Logged In user
        Account acc 							=	dbu_FactoryDataTest.createIAMAccount('Identity Individual Users12yTest', AccountRecordType);
        insert acc; 
        
        
        //Setup Contact for Logged In user - without Wishlist
        //Contact con								=	dbu_FactoryDataTest.createIAMContact(FIRSTNAME, LASTNAME, acc.id, ContactRecordTypeId);
        //insert con;  
        //string usr = userinfo.getUserId();
            
        //Contact con = new Contact(LastName = LASTNAME, AccountId = acc.id);
        //insert con;        
		//USERID = userinfo.getUserId();
            
       // system.runAs(usr){
			ccrz__E_PriceList__c TestPricelist = dbu_FactoryDataTest.createPriceList('TestPricelist');
            insert TestPricelist;
            
            //Setup Products
            list<ccrz__E_Product__c> TestProductList = new list<ccrz__E_Product__c>();
            ccrz__E_Product__c TestProduct1 = dbu_FactoryDataTest.createProduct('TestProduct1', true, true, true, false);
            TestProduct1.dbu_Crate_Engine__c = true;
            TestProduct1.dbu_Has_Core_Charge__c = true;
            TestProduct1.DBU_Product_Location__c = 'US';
        	TestProductList.add(TestProduct1);
            
            ccrz__E_Product__c TestProduct2 = dbu_FactoryDataTest.createProduct('TestProduct2', false, false, true, false);
            //TestProduct2.dbu_Core_Charge_Amount__c = 100;
            TestProduct2.dbu_Has_Core_Charge__c = true;
            TestProduct2.dbu_Has_Core_Child__c = true;
            TestProduct2.DBU_Product_Location__c = 'US';
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
        //}            
       // }
        }      
    }    
    
    @isTest public static void Testmethod1(){
        
        //Get user
        //string usr = userinfo.getUserId();
        //user u = [select id,Contactid from User where username = 'testcssna@gmail.com'];        
        //user u = [select id,Contactid from User where username =: ID.valueOf(USERID)];        
        //user ussr = [select id from user where id =: userinfo.getUserId()];
        account acc = [select id from account where name = 'Identity Individual Users12yTest'];        
        //contact cnts = [select id from contact where id =: u.Contactid];
        
        //string ContactID = u.Contactid; 

        //system.runAs(u){
            ccrz__E_Product__c ProductRet = [SELECT id FROM ccrz__E_Product__c WHERE Name = 'TestProduct1']; 
            ccrz__E_Product__c ProductRet2= [SELECT id FROM ccrz__E_Product__c WHERE Name = 'TestProduct2'];
            ccrz__E_RelatedProduct__c relProd1 = dbu_FactoryDataTest.createRelatedProduct(ProductRet2.id, ProductRet.id, 'Core Charge');
            insert relProd1;
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
            //ccrz.cc_CallContext.currContact= cnts;
            ccrz.cc_CallContext.storeFrontSettings = storefrontsettings;
            ccrz.cc_CallContext.initRemoteContext(ctx);             
            String urlParam = 'https://csodev-cumminscss.cs90.force.com/CSSNAStore/s/checkout?cartId=a1y1F00000149OzQAI&store=US';
            list<dbu_CCAPIResponseWrapper> retrivedProductdetails =  dbu_callCCApi.fetchProductDetails((string)ProductRet.id, urlParam);
        	dbu_callCCApi.productInventoryDetails((string)ProductRet.id,'US');
            system.debug('retrivedProductdetails > ' + retrivedProductdetails);
            
            Test.stopTest();
        //}
       
    }
	
}