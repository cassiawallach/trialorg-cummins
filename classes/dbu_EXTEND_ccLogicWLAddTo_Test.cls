@isTest
private class dbu_EXTEND_ccLogicWLAddTo_Test {

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
    
    @isTest private static void testmethod1(){
        
        UserRole userRole_1 = [SELECT Id FROM UserRole WHERE DeveloperName = 'CEO' LIMIT 1];
        Profile profile_1 = [SELECT Id FROM Profile WHERE name = 'IAM User' LIMIT 1];
        User admin = [SELECT Id, Username, UserRoleId FROM User WHERE Profile.Name = 'System Administrator' and IsActive = true LIMIT 1];
        admin.UserRoleId = userRole_1.Id;
        update admin; 

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
        /*
        	String orgId = UserInfo.getOrganizationId();  
            String dateString =   
            String.valueof(Datetime.now()).replace(' ','').replace(':','').replace('-','');  
            Integer randomInt = Integer.valueOf(math.rint(math.random()*1000000));  
            String uniqueName = orgId + dateString + randomInt;
        	//con.Username__c							=	uniqueName + '@test' + orgId + '.org';
            
	        Contact con = new Contact(LastName = LASTNAME, FirstName = FIRSTNAME ,AccountId = acc.id);  
            con.Username__c = uniqueName + '@test' + orgId + '.org'; 
            insert con;        
        */
        
        //Setup user for Logged In user
        //user usr								=	dbu_FactoryDataTest.createIAMUser(FIRSTNAME, LASTNAME, con.id, profileId);
        //usr.Username							=	'junka@nazi.com';
        //insert usr;        
        /*
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
           */ 
            
            
            
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

            list<ccrz__E_Product__c> ProductRet = [SELECT id FROM ccrz__E_Product__c WHERE Name = 'TestProduct1'];
            list<ccrz__E_PriceListItem__c> Pricelines = [select ccrz__Product__c,ccrz__Price__c from ccrz__E_PriceListItem__c where ccrz__Product__c in : ProductRet];
            list<ccrz__E_CartItem__c> crtLinesList = new list<ccrz__E_CartItem__c>();              
            
           //ccrz__E_Cart__c WLItem				=	dbu_FactoryDataTest.createCart('MyWishlist', 'Wishlist', usr.id, con.id, acc.id, true);
        ccrz__E_Cart__c	WLItem						=	new ccrz__E_Cart__c();
        WLItem.ccrz__Name__c						=	'MyWishlist';
        WLItem.ccrz__CartType__c					=	'Wishlist';
        WLItem.ccrz__CurrencyISOCode__c				=	'USD';
        WLItem.ccrz__ActiveCart__c					=	true;
        WLItem.ccrz__Storefront__c					=	'CSSNAStore';
        WLItem.ccrz__CartStatus__c					=	'Open';                            
            insert WLItem;            
            
            
            double Qcounter = 0;
            string CurrentProductID;
            for(ccrz__E_PriceListItem__c PrcLn : Pricelines){
                CurrentProductID = string.valueof(PrcLn.ccrz__Product__c);
                ccrz__E_CartItem__c crtline  = dbu_FactoryDataTest.createCartItem(WLItem.id, (double)PrcLn.ccrz__Price__c, Qcounter, PrcLn.ccrz__Product__c);
                crtline.DBU_SaveForLater__c	 = 'WishList';
                Qcounter = Qcounter + 1;
                crtLinesList.add(crtline);
            }            
            
            insert crtLinesList;
         
            Map<string,object> InputData = new Map<string,object>{
                'originalInputData' => new Map<string,object>{
					'wlId' => string.valueOf(WLItem.id),                        
                            'SaveForLater' => 'Save For Later'
                },
                'productIdList' => new list<string>{CurrentProductID}    
            };
                
            Test.startTest();    
            dbu_EXTEND_ccLogicWLAddTo logicWLAddTo = new dbu_EXTEND_ccLogicWLAddTo();
            logicWLAddTo.insertWishListItems(InputData);
            Test.stopTest();
            
        
        }    
    }
    
        @isTest private static void testmethod2(){
            
        UserRole userRole_1 = [SELECT Id FROM UserRole WHERE DeveloperName = 'CEO' LIMIT 1];
        Profile profile_1 = [SELECT Id FROM Profile WHERE name = 'IAM User' LIMIT 1];
        User admin = [SELECT Id, Username, UserRoleId FROM User WHERE Profile.Name = 'System Administrator' and IsActive = true LIMIT 1];
        admin.UserRoleId = userRole_1.Id;
        update admin; 

        System.runAs(admin){              
        string FIRSTNAME				=	'Test2';
        string LASTNAME					=	'Customers';
        
        Id AccountRecordType = Schema.SObjectType.Account.getRecordTypeInfosByName().get('IAM Global').getRecordTypeId();
        Id ContactRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('IAM').getRecordTypeId();
        
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
        	/* 
        	String orgId = UserInfo.getOrganizationId();  
            String dateString =   
            String.valueof(Datetime.now()).replace(' ','').replace(':','').replace('-','');  
            Integer randomInt = Integer.valueOf(math.rint(math.random()*1000000));  
            String uniqueName = orgId + dateString + randomInt;
        	//con.Username__c							=	uniqueName + '@test' + orgId + '.org';
            
	        Contact con = new Contact(LastName = LASTNAME, FirstName = FIRSTNAME ,AccountId = acc.id);  
            con.Username__c = uniqueName + '@test' + orgId + '.org'; 
            insert con;                 
        	*/
        //Setup user for Logged In user
        //user usr								=	dbu_FactoryDataTest.createIAMUser(FIRSTNAME, LASTNAME, con.id, profileId);
        //usr.Username							=	'junkasa@nazi.com';
        //insert usr;        
        //string usr = userinfo.getUserId();
        /*
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
        */
        //system.runAs(usr){
            
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

            list<ccrz__E_Product__c> ProductRet = [SELECT id FROM ccrz__E_Product__c WHERE Name = 'TestProduct1'];
            list<ccrz__E_PriceListItem__c> Pricelines = [select ccrz__Product__c,ccrz__Price__c from ccrz__E_PriceListItem__c where ccrz__Product__c in : ProductRet];
            list<ccrz__E_CartItem__c> crtLinesList = new list<ccrz__E_CartItem__c>();              
            
            //ccrz__E_Cart__c WLItem				=	dbu_FactoryDataTest.createCart('MyWishlist', 'Wishlist', usr.id, con.id, acc.id, true);
        ccrz__E_Cart__c	WLItem						=	new ccrz__E_Cart__c();
        WLItem.ccrz__Name__c						=	'MyWishlist';
        WLItem.ccrz__CartType__c					=	'Wishlist';
        WLItem.ccrz__CurrencyISOCode__c				=	'USD';
        WLItem.ccrz__ActiveCart__c					=	true;
        WLItem.ccrz__Storefront__c					=	'CSSNAStore';
        WLItem.ccrz__CartStatus__c					=	'Open';                            
            insert WLItem;
            
            double Qcounter = 0;
            string CurrentProductID;
            for(ccrz__E_PriceListItem__c PrcLn : Pricelines){
                CurrentProductID = string.valueof(PrcLn.ccrz__Product__c);
                ccrz__E_CartItem__c crtline  = dbu_FactoryDataTest.createCartItem(WLItem.id, (double)PrcLn.ccrz__Price__c, Qcounter, PrcLn.ccrz__Product__c);
                crtline.DBU_SaveForLater__c	 = 'WishList';
                Qcounter = Qcounter + 1;
                crtLinesList.add(crtline);
            }            
            
            insert crtLinesList;
         
            Map<string,object> InputData = new Map<string,object>{
                'originalInputData' => new Map<string,object>{
					'wlId' => string.valueOf(WLItem.id),                        
                            'SaveForLater' => 'Save For Later'
                },
                'productIdList' => new list<string>{CurrentProductID}    
            };
                
            Test.startTest();    
            dbu_EXTEND_ccLogicWLAddTo logicWLAddTo = new dbu_EXTEND_ccLogicWLAddTo();
            logicWLAddTo.insertWishListItems(InputData);
            Test.stopTest();
            
        //}
    }
        }
}