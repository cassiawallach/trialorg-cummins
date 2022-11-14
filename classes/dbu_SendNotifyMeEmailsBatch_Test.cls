@isTest
public class dbu_SendNotifyMeEmailsBatch_Test {
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

       
        	
            ccrz__E_PriceList__c TestPricelist = dbu_FactoryDataTest.createPriceList('TestPricelist');
            insert TestPricelist;
            
            //Setup Products
            list<ccrz__E_Product__c> TestProductList = new list<ccrz__E_Product__c>();
            ccrz__E_Product__c TestProduct1 			= dbu_FactoryDataTest.createProduct('TestProduct1', true, true, true, false);
        	TestProduct1.dbu_Inventory_Status_Check__c 	= true;
        	TestProduct1.dbu_Product_Status__c			= 'In Stock';
        	TestProduct1.dbu_Crate_Engine__c 			= true;
            TestProduct1.DBU_Product_Location__c = 'US';
        	TestProductList.add(TestProduct1);
            
            ccrz__E_Product__c TestProduct2 = dbu_FactoryDataTest.createProduct('TestProduct2', false, false, true, false);
        	TestProduct2.dbu_Inventory_Status_Check__c 	= true;
            TestProduct2.DBU_Product_Location__c = 'US';
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
            
            
            list<ccrz__E_Product__c> ProductRet = [SELECT id FROM ccrz__E_Product__c WHERE Name = 'TestProduct2'];
            list<ccrz__E_PriceListItem__c> Pricelines = [select ccrz__Product__c,ccrz__Price__c from ccrz__E_PriceListItem__c where ccrz__Product__c in : ProductRet];

            dbu_Emailer__c eachemailer = new dbu_Emailer__c();
            eachemailer.dbu_Contact_Email__c = 'test@justNotifyme.com';
            eachemailer.CurrencyIsoCode		= 'USD';
            eachemailer.dbu_Email_for_NotifyMe__c = true;
            eachemailer.dbu_Email_Contact__c = con.id;
            eachemailer.dbu_Store_Country__c = 'US';
            eachemailer.dbu_Store_Language__c = 'US';
            insert eachemailer;            
            
            dbu_Email_Content__c CURRENCTEMAILCONTENT 	= new dbu_Email_Content__c ();
            CURRENCTEMAILCONTENT.CC_Product_Name__c		= ProductRet[0].id;
            CURRENCTEMAILCONTENT.dbu_Emailer__c = eachemailer.id;
            CURRENCTEMAILCONTENT.CurrencyIsoCode = 'USD';
            CURRENCTEMAILCONTENT.dbu_Product_Price__c = 89;
            CURRENCTEMAILCONTENT.dbu_Product_URI__c = 'WWW.GOOGLE.COM';
            CURRENCTEMAILCONTENT.dbu_NotifyMe_Email_Sending_Initiated__c = false;
            CURRENCTEMAILCONTENT.dbu_NotifyMe_Email_Sent__c = false;
            CURRENCTEMAILCONTENT.dbu_Product_Inventory_Status__c = false;
            insert CURRENCTEMAILCONTENT;            
            
          
            
           
           
        
        Test.startTest();
        
        dbu_SendNotifyMeEmailsBatch obj = new dbu_SendNotifyMeEmailsBatch();
        DataBase.executeBatch(obj); 
        
        
        Test.stopTest();        	    
    }
    }  
    
}