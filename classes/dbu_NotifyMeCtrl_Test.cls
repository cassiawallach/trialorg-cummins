@isTest
public class dbu_NotifyMeCtrl_Test {

      
    private static string ACCOUNT_REGION 		=	'US and Canada';
    private static string TIMEZONE 				=	'America/Panama';
    private static string EMAIL_ENCODING 		=	'ISO-8859-1';
    private static string LOCALE				=	'English(United States)';
    private static string LANGUAGE				=	'English';
    private static string BILLING_COUNTRY		=	'United States';
    private static string EMAIL					=	'testuser9@gmail.com'; 
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
        user u = [select id,Contactid from User where Email = 'xyztestuser9@gmail.com'];               
        account acc = [select id from account where name = 'Identity Individual Users12yTest'];        
        contact cnts = [select id from contact where id =: u.Contactid];
        string ContactID = u.Contactid;        
        

        
        system.runAs(u){
            
            string storelanguage = 'US';
            string storeCountry = 'US';  
            string emailaddress = 'testuser@notifyme.in';
            ccrz__E_Product__c ProductRet = [SELECT id FROM ccrz__E_Product__c WHERE Name = 'TestProduct2'];
            system.debug('ProductRet > ' + ProductRet);
            
        	string urlparam = 'https://fulluat-cumminscss.cs25.force.com/CSSNAStore/s/product/'+(string)ProductRet.id+'/'+'TestProduct2';
                //'cummins%20solenoid%203054291';    
            system.debug('urlparam >' + urlparam);
            
            dbu_NotifyMeCtrl.RecordNotifyMeData( urlparam,  storeCountry,  storelanguage, emailaddress);

            
        }        
            Test.stopTest();        
        
        //.RecordNotifyMeData();
    }
    
    @isTest
    static void testmethod2(){

        Test.startTest();
        user u = [select id,Contactid from User where Email = 'xyztestuser9@gmail.com'];               
        account acc = [select id from account where name = 'Identity Individual Users12yTest'];        
        contact cnts = [select id from contact where id =: u.Contactid];
        string ContactID = u.Contactid;        
        ccrz__E_Product__c ProductRet = [SELECT id FROM ccrz__E_Product__c WHERE Name = 'TestProduct2'];
        system.debug('ProductRet > ' + ProductRet);       
        
        dbu_Emailer__c eachemailer = new dbu_Emailer__c();
        eachemailer.dbu_Contact_Email__c = 'test@justNotifyme.com';
        eachemailer.CurrencyIsoCode		= 'USD';
        eachemailer.dbu_Email_for_NotifyMe__c = true;
        eachemailer.dbu_Email_Contact__c = cnts.id;
        eachemailer.dbu_Store_Country__c = 'US';
        eachemailer.dbu_Store_Language__c = 'US';
        insert eachemailer;
        
        
        
        dbu_Email_Content__c CURRENCTEMAILCONTENT 	= new dbu_Email_Content__c ();
        CURRENCTEMAILCONTENT.CC_Product_Name__c		= ProductRet.id;
        CURRENCTEMAILCONTENT.dbu_Emailer__c = eachemailer.id;
        CURRENCTEMAILCONTENT.CurrencyIsoCode = 'USD';
		CURRENCTEMAILCONTENT.dbu_Product_Price__c = 89;
        CURRENCTEMAILCONTENT.dbu_Product_URI__c = 'WWW.GOOGLE.COM';
        CURRENCTEMAILCONTENT.dbu_NotifyMe_Email_Sending_Initiated__c = false;
        CURRENCTEMAILCONTENT.dbu_NotifyMe_Email_Sent__c = false;
        CURRENCTEMAILCONTENT.dbu_Product_Inventory_Status__c = false;
		insert CURRENCTEMAILCONTENT;
        
        list<dbu_Email_Content__c> currenctelctn = [Select id, 
                                                    CC_Product_Name__c, 
                                                    dbu_NotifyMe_Email_Sending_Initiated__c,
                                                    dbu_Emailer_Email_Address__c, 
                                                    dbu_NotifyMe_Email_Sent__c, 
                                                    dbu_Product_Inventory_Status__c, 
                                                    dbu_Product_Name__c, 
                                                    dbu_Product_Price__c, 
                                                    dbu_Product_URI__c, 
                                                    dbu_Emailer__r.dbu_Store_Country__c, 
                                                    dbu_Emailer__r.dbu_Store_Language__c, 
                                                    dbu_Emailer__r.dbu_Email_for_NotifyMe__c, 
                                                    dbu_Emailer__r.dbu_Email_Contact__c, 
                                                    dbu_Emailer__r.dbu_Contact_Name__c, 
                                                    dbu_Emailer__r.dbu_Contact_Email__c,
                                                    CurrencyIsoCode  
                                                    from dbu_Email_Content__c 
                                                    where dbu_Emailer__r.dbu_Email_for_NotifyMe__c = true 
                                                    and dbu_Emailer__r.dbu_Email_for_Wishlist__c = false 
                                                    and dbu_NotifyMe_Email_Sent__c = false 
                                                    and dbu_NotifyMe_Email_Sending_Initiated__c =false]; 
        
        system.runAs(u){
			dbu_NotifyMeCtrl.ProceedToSendNotifyMeEmail(currenctelctn);                        
        } 
        Test.stopTest();
       
        
    }
}