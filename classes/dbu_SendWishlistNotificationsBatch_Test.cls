@isTest 
public class dbu_SendWishlistNotificationsBatch_Test {

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
    
    static testMethod void testMethod1() {
        /*
        select id,
            ccrz__Product__c,
            ccrz__Cart__c,
            ccrz__Product__r.Name,
            ccrz__Product__r.id,
            ccrz__Product__r.ccrz__SKU__c,
            ccrz__Product__r.dbu_Inventory_Status_Check__c,
            ccrz__Cart__r.ccrz__Contact__c,
            ccrz__Cart__r.ccrz__Contact__r.Email,
            ccrz__Cart__r.ccrz__Contact__r.FirstName,
            ccrz__Cart__r.ccrz__Contact__r.LastName,
            ccrz__Cart__r.ccrz__CartType__c,
            ccrz__Cart__r.id,DBU_SaveForLater__c 
            FROM ccrz__E_CartItem__c 
            WHERE ccrz__Cart__r.ccrz__CartType__c = \'WishList\'
            and DBU_SaveForLater__c = \'WishList\' 
            and ccrz__Product__r.dbu_Inventory_Status_Check__c = true 
            and ccrz__Cart__r.ccrz__Contact__c != NULL'*/
        
        UserRole userRole_1 = [SELECT Id FROM UserRole WHERE DeveloperName = 'CEO' LIMIT 1];
        Profile profile_1 = [SELECT Id FROM Profile WHERE name = 'IAM User' LIMIT 1];
        User admin = [SELECT Id, Username, UserRoleId FROM User WHERE Profile.Name = 'System Administrator' and IsActive = true LIMIT 1];
        admin.UserRoleId = userRole_1.Id;
        update admin; 
		//system.debug('Wittman');
        System.runAs(admin){          
        
        string FIRSTNAME				=	'Test1';
        string LASTNAME					=	'Customers';
        
        Id AccountRecordType = Schema.SObjectType.Account.getRecordTypeInfosByName().get('IAM Global').getRecordTypeId();
        //Id ContactRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('IAM').getRecordTypeId();
        
        //Get Profile Id - IAM User
        Id profileId = [Select Id From Profile Where Name='IAM User'].id;
        
        //Get Permission Sets
        List<PermissionSet> PermSetList = [SELECT id FROM PermissionSet where Name = 'B2BCommerceGuestCloneDefaultOwner' OR Name = 'eCommerce' LIMIT 2];
        
        //Setup Account for Logged In user
        Account acc 							=	dbu_FactoryDataTest.createIAMAccount('Identity Individual Users12yTest', AccountRecordType);
        insert acc;
                
        
        //Setup Contact for Logged In user - without Wishlist
        //Contact con								=	dbu_FactoryDataTest.createIAMContact(FIRSTNAME, LASTNAME, acc.id, ContactRecordTypeId);
        	String orgId = UserInfo.getOrganizationId();  
            String dateString = String.valueof(Datetime.now()).replace(' ','').replace(':','').replace('-','');  
            Integer randomInt = Integer.valueOf(math.rint(math.random()*1000000));  
            String uniqueName = orgId + dateString + randomInt;
        	//con.Username__c							=	uniqueName + '@test' + orgId + '.org';
            
	        Contact con = new Contact(LastName = LASTNAME, FirstName = FIRSTNAME ,AccountId = acc.id, Email = 'jhankarbeats@oldschool.com');  
            con.Username__c = uniqueName + '@test' + orgId + '.org';         
        	insert con;          
        
        //Setup user for Logged In user
        //user usr								=	dbu_FactoryDataTest.createIAMUser(FIRSTNAME, LASTNAME, con.id, profileId);
        //insert usr;        
        
       
        	
            ccrz__E_PriceList__c TestPricelist = dbu_FactoryDataTest.createPriceList('TestPricelist');
            insert TestPricelist;
            
            //Setup Products
            list<ccrz__E_Product__c> TestProductList = new list<ccrz__E_Product__c>();
            ccrz__E_Product__c TestProduct1 			= dbu_FactoryDataTest.createProduct('TestProduct1', true, true, true, false);
        	TestProduct1.dbu_Inventory_Status_Check__c 	= true;
        	TestProduct1.dbu_Product_Status__c			= 'In Stock';
        	TestProduct1.dbu_Crate_Engine__c 			= true;
        	TestProductList.add(TestProduct1);
            
            ccrz__E_Product__c TestProduct2 = dbu_FactoryDataTest.createProduct('TestProduct2', false, false, true, false);
        	TestProduct2.dbu_Inventory_Status_Check__c 	= true;
            TestProductList.add(TestProduct2);
            
            ccrz__E_Product__c TestProduct3 = dbu_FactoryDataTest.createProduct('TestProduct3', true, false, false, true);
        	TestProduct3.dbu_Inventory_Status_Check__c 	= true;
        	TestProduct3.dbu_Crate_Engine__c = true;    
        	TestProductList.add(TestProduct3);
            
            ccrz__E_Product__c TestProduct4 = dbu_FactoryDataTest.createProduct('TestProduct4', false, true, false, true);
        	TestProduct4.dbu_Inventory_Status_Check__c 	= true;
            TestProductList.add(TestProduct4);
            
            ccrz__E_Product__c TestProduct5 = dbu_FactoryDataTest.createProduct('TestProduct5', false, false, false, true);
        	TestProduct5.dbu_Inventory_Status_Check__c 	= true;
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
            
            
            list<ccrz__E_Product__c> ProductRet = [SELECT id FROM ccrz__E_Product__c WHERE Name = 'TestProduct1'];
            list<ccrz__E_PriceListItem__c> Pricelines = [select ccrz__Product__c,ccrz__Price__c from ccrz__E_PriceListItem__c where ccrz__Product__c in : ProductRet];
            list<ccrz__E_CartItem__c> crtLinesList = new list<ccrz__E_CartItem__c>();  
            
            //ccrz__E_Cart__c		 cartItem				=	dbu_FactoryDataTest.createCart('MyCart', 'Cart', usr.id, con.id, acc.id, true);
            //cartItem.ccrz__Contact__c					=	con.id;
            //cartItem.ccrz__CartType__c					=	'WishList';            
            //insert cartItem;

            ccrz__E_Cart__c	cartItem						=	new ccrz__E_Cart__c();
            cartItem.ccrz__Name__c						=	'MyCart';
            cartItem.ccrz__CartType__c					=	'Wishlist';
            cartItem.ccrz__CurrencyISOCode__c				=	'USD';
            cartItem.ccrz__ActiveCart__c					=	true;
            cartItem.ccrz__Storefront__c					=	'CSSNAStore';
            cartItem.ccrz__CartStatus__c					=	'Open'; 
            cartItem.ccrz__Contact__c					=	con.id;
            insert cartItem;            
            
            double Qcounter = 0;    
            for(ccrz__E_PriceListItem__c PrcLn : Pricelines){
                ccrz__E_CartItem__c crtline  = dbu_FactoryDataTest.createCartItem(cartItem.id, (double)PrcLn.ccrz__Price__c, Qcounter, PrcLn.ccrz__Product__c);                               
                crtline.DBU_SaveForLater__c  = 'WishList';
                Qcounter = Qcounter + 1;                
                crtLinesList.add(crtline);
            }
            
            insert crtLinesList;
           
        
        Test.startTest();
        
        dbu_SendWishlistNotificationsBatch obj = new dbu_SendWishlistNotificationsBatch();
        DataBase.executeBatch(obj); 
        
        
        Test.stopTest();        	    
    }
    }  
    

}