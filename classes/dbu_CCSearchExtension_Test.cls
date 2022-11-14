/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 08-25-2022
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
@isTest
public class dbu_CCSearchExtension_Test {
      
    
    private static string ACCOUNT_REGION        =   'US and Canada';
    private static string TIMEZONE              =   '(GMT-05:00) Eastern Standard Time (America/Panama)';
    private static string EMAIL_ENCODING        =   'General US & Western Europe (ISO-8859-1, ISO-LATIN-1)';
    private static string LOCALE                =   'English(United States)';
    private static string LANGUAGE              =   'English';
    private static string BILLING_COUNTRY       =   'United States';
    private static string EMAIL                 =   'testuser@gmail.com';    
    private static string COMPANY_NAME          =   'test user company';   
    private static string PHONE                 =   '83689376493';   
    private static string STATUS                =   'Active';
    private static string FIRSTNAME             =   'Test';
    private static string LASTNAME              =   '1Customer23';
    private static string NICKNAME              =   '1NickCustomer123';
    private static string EMAIL_ENCODING_USER   =   'Unicode (UTF-8)';
    private static string USERNAME              =   'testcssna@gmail.com'; 
    
     
    @testSetup 
    static void SettingUpTestData() {
        
        //UserRole userrole = [Select Id, DeveloperName From UserRole Where DeveloperName = 'CEO' Limit 1];
        
        //User adminUser = [Select Id, UserRoleId From User Where Profile.Name='System Administrator' AND IsActive=true AND UserRoleId =: userrole.Id Limit 1];
        
        //adminUser.UserRoleId = userRole.Id;
        
        //System.runAs(adminUser){
        
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
        Account acc                             =   dbu_FactoryDataTest.createIAMAccount('Identity Individual Users12yTest', AccountRecordType);
        insert acc;
        
        //Setup Contact for Logged In user - without Wishlist
        
        //Contact con                             =   dbu_FactoryDataTest.createIAMContact(FIRSTNAME, LASTNAME, acc.id, ContactRecordTypeId);
        //con.Username__c                         =   UserInfo.getUserName();
        //insert con;
            String orgId = UserInfo.getOrganizationId();  
            String dateString = String.valueof(Datetime.now()).replace(' ','').replace(':','').replace('-','');  
            Integer randomInt = Integer.valueOf(math.rint(math.random()*1000000));  
            String uniqueName = orgId + dateString + randomInt;
            //con.Username__c                           =   uniqueName + '@test' + orgId + '.org';
            
            Contact con = new Contact(LastName = LASTNAME, FirstName = FIRSTNAME ,AccountId = acc.id, Email = 'jhankarbeats@oldschool.com');  
            con.Username__c = uniqueName + '@test' + orgId + '.org';         
            insert con;        
            
        //user objUser = dbu_FactoryDataTest.createIAMUser(FIRSTNAME, LASTNAME, con.id, profileId);
        //insert objUser;
        
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
        
     
            ccrz__E_PriceList__c TestPricelist = dbu_FactoryDataTest.createPriceList('TestPricelist');
            insert TestPricelist;
            
            //Setup Products
            list<ccrz__E_Product__c> TestProductList = new list<ccrz__E_Product__c>();
            ccrz__E_Product__c TestProduct1 = dbu_FactoryDataTest.createProduct('ring', true, true, true, false);
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
            Database.SaveResult[] TestProductInsertedList = Database.insert(TestProductList, false); 
            
            ccrz__E_Product__c TestProduct6 = dbu_FactoryDataTest.createProduct('79464646', true, true, true, false);
            insert TestProduct6;
            
            ccrz__E_ProductMedia__c TestProductMedia6 = dbu_FactoryDataTest.createProductMedia(TestProduct6.id, 'Product Image');
            insert TestProductMedia6;
            
            string PricelistitemName6 = 'PricelistItem6';
            double OriginalPrice6     = 1067;
            double discountAmt6       = 152;
            double Price6             = OriginalPrice6 - discountAmt6;               
            
            ccrz__E_PriceListItem__c TestPriceListItem6 =  dbu_FactoryDataTest.createPriceListItem(PricelistitemName6, OriginalPrice6, discountAmt6, 'Absolute', Price6, TestProduct6.id, TestPricelist.id);                
            insert TestPriceListItem6;         
            
            string ProductInventoryItemName6 =   'ProdInv6';
            double QuantityAvailable6        =   106;
            string availablemessage6         =   'In stock';
            string status6                   =   'In Stock';
            ccrz__E_ProductInventoryItem__c TestProdInventory6 = dbu_FactoryDataTest.createProductInventoryItem(ProductInventoryItemName6, TestProduct6.id, QuantityAvailable6, availablemessage6, status6);
            insert TestProdInventory6;            
            
            ccrz__E_Category__c ccParentCategory = new ccrz__E_Category__c();
            ccParentCategory.Name = 'Aftertreatment';
            ccParentCategory.Storefront__c = 'CSSNAStore';
            ccParentCategory.ccrz__CategoryID__c = '999999';
            ccParentCategory.ccrz__EndDate__c = Date.parse('6/20/2099');//System.today().addMonths(4);
            ccParentCategory.ccrz__Sequence__c = 1;
            ccParentCategory.ccrz__StartDate__c = Date.parse('6/20/2019');//System.today().addDays(-1);
            insert ccParentCategory;
            
            ccrz__E_Category__c ccChildCategory = new ccrz__E_Category__c();
            ccChildCategory.Name = 'CumminsR2.8TurboDiesel';
            ccChildCategory.Storefront__c = 'CSSNAStore';
            ccChildCategory.ccrz__CategoryID__c = '3444';
            ccChildCategory.ccrz__EndDate__c = Date.parse('6/20/2099');//System.today().addMonths(4);
            ccChildCategory.ccrz__Sequence__c = 3;
            ccChildCategory.ccrz__StartDate__c = Date.parse('6/20/2019');//System.today().addDays(-1);
            ccChildCategory.ccrz__ParentCategory__c = ccParentCategory.id;
            insert ccChildCategory;
            
            ccrz__E_ProductCategory__c prodCategory = new ccrz__E_ProductCategory__c();
            prodCategory.ccrz__Product__c = TestProduct6.id;
            prodCategory.ccrz__Category__c = ccChildCategory.id;
            prodCategory.ccrz__EndDate__c = Date.parse('6/20/2099');//System.today().addMonths(4);
            prodCategory.ccrz__StartDate__c = Date.parse('6/20/2019');//System.today().addDays(-1);
            insert prodCategory;
            
            List<ccrz__E_PriceListItem__c> ProductPriceListItems = new list<ccrz__E_PriceListItem__c>();
            list<ccrz__E_ProductMedia__c>  ProductsMediaList     = new list<ccrz__E_ProductMedia__c>();
            list<ccrz__E_ProductInventoryItem__c> ProductsINvlist = new list<ccrz__E_ProductInventoryItem__c>();
            
                           
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
                    string ProductInventoryItemName =   'ProdInv'+Count;
                    double QuantityAvailable        =   10+Count;
                    string availablemessage         =   'In stock';
                    string status                   =   'In Stock';
                    ccrz__E_ProductInventoryItem__c TestProdInventory = dbu_FactoryDataTest.createProductInventoryItem(ProductInventoryItemName, sr.getId(), QuantityAvailable, availablemessage, status);
                    ProductsINvlist.add(TestProdInventory);
                    
                    string PricelistitemName = 'PricelistItem'+Count;
                    double OriginalPrice     = 100+Count;
                    double discountAmt       = 15+Count;
                    double Price             = OriginalPrice - discountAmt;                
                    
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
        
        
        }
        
    }

    static testMethod void testParse() {
        
        //user u = [select id,Contactid from User where username = 'testcssna@gmail.com'];  
        //system.debug('userlist'+u);
        //user ussr = [select id from user where id =: userinfo.getUserId()];
        
        UserRole userRole_1 = [SELECT Id FROM UserRole WHERE DeveloperName = 'CEO' LIMIT 1];
        Profile profile_1 = [SELECT Id FROM Profile WHERE name = 'IAM User' LIMIT 1];
        User admin = [SELECT Id, Username, UserRoleId FROM User WHERE Profile.Name = 'System Administrator' and IsActive = true LIMIT 1];
        admin.UserRoleId = userRole_1.Id;
        update admin; 

        System.runAs(admin){         
        
        account acc = [select id from account where name = 'Identity Individual Users12yTest'];
        
        //contact cnts = [select id from contact where id =: u.Contactid];
        //string ContactID = u.Contactid; 
        ccrz__E_Product__c  prod = [Select id from ccrz__E_Product__c where Name =:'79464646'];       
        ccrz__E_ProductCategory__c prodCate = [Select id from ccrz__E_ProductCategory__c where ccrz__Product__c=:prod.id];
        
       
            test.startTest(); 
            
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
            ccrz.cc_CallContext.userLocale = 'en_US';
            // ccrz.cc_CallContext.isGuest=true;
            
            //ccrz.cc_CallContext.currContact= cnts;
            ccrz.cc_CallContext.storeFrontSettings = storefrontsettings;
            ccrz.cc_CallContext.initRemoteContext(ctx);
            
            
            dbu_CCSearchExtension obj = new dbu_CCSearchExtension();
            dbu_CCSearchExtension.getSearchResultFornormal('79464646','US','USD','En');
            set<string> partsset = new set<string>();
            partsset.add('79464646');
            
            //dbu_CCSearchExtension.fetchProductResult(partsset);
            dbu_CCSearchExtension.getSearchResultForESN('https://csodev-cumminscss.cs90.force.com/CSSNAStore/s/dbu-search?searchText=79464646&store=US');
            test.stopTest();
        
        }
        
    }
    
    static testmethod void testParse2(){
        //user u = [select id,Contactid from User where username = 'testcssna@gmail.com'];  
        //system.debug('userlist'+u);
        //user ussr = [select id from user where id =: userinfo.getUserId()];
        UserRole userRole_1 = [SELECT Id FROM UserRole WHERE DeveloperName = 'CEO' LIMIT 1];
        Profile profile_1 = [SELECT Id FROM Profile WHERE name = 'IAM User' LIMIT 1];
        User admin = [SELECT Id, Username, UserRoleId FROM User WHERE Profile.Name = 'System Administrator' and IsActive = true LIMIT 1];
        admin.UserRoleId = userRole_1.Id;
        update admin; 

        System.runAs(admin){         
        
        account acc = [select id from account where name = 'Identity Individual Users12yTest'];
        
        //contact cnts = [select id from contact where id =: u.Contactid];
        //string ContactID = u.Contactid;        
        
        
            test.startTest(); 
            
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
            ccrz.cc_CallContext.userLocale = 'en_US';
            // ccrz.cc_CallContext.isGuest=true;
            //ccrz.cc_CallContext.currContact= cnts;
            ccrz.cc_CallContext.storeFrontSettings = storefrontsettings;
            ccrz.cc_CallContext.initRemoteContext(ctx);
            
            
            dbu_CCSearchExtension obj = new dbu_CCSearchExtension();
            /*dbu_CCSearchExtension.getSearchResultFornormal('ring');
set<string> partsset = new set<string>();
partsset.add('3976787 ');

dbu_CCSearchExtension.fetchProductResult(partsset);*/
            dbu_CCSearchExtension.getSearchResultForESN('https://csodev-cumminscss.cs90.force.com/CSSNAStore/s/dbu-search?searchText=ring&store=CA');
            dbu_CCSearchExtension.fetchbrandBySearchResult(new Set<String>{'https://csodev-cumminscss.cs90.force.com/CSSNAStore/s/dbu-search?searchText=ring&store=CA'});
            //dbu_CCSearchExtension.getExternalIp();
            
            ccrz__E_Product__c cce = new ccrz__E_Product__c();
            cce.ccrz__SKU__c = 'test';
            cce.ccrz__Storefront__c = 'CSSNAStore';
            cce.ccrz__ProductStatus__c = 'Released';
            cce.ccrz__StartDate__c = Date.TODAY()-1;
            cce.ccrz__EndDate__c = Date.TODAY()+2;
            cce.DBU_Product_Location__c = 'US';
            cce.dbu_Has_Core_Charge__c = true;
            cce.dbu_Has_Core_Child__c = false;
            insert cce;
            
            dbu_CCSearchExtension.Intermidiatormethod(new set<String>{cce.ID},'US','Normal Search');
            
            dbu_partsresponse__c partResp = new dbu_partsresponse__c();
            partResp.Number_Z__c = '2';
            partResp.dbu_ESNNumber__c = 'Test';
            insert partResp;
            dbu_CCSearchExtension.searchInLocalESNResponse('Test','US','US','US');
            test.stopTest();
        }
    }
    
    static testmethod void testParse3(){
        UserRole userRole_1 = [SELECT Id FROM UserRole WHERE DeveloperName = 'CEO' LIMIT 1];
        Profile profile_1 = [SELECT Id FROM Profile WHERE name = 'IAM User' LIMIT 1];
        User admin = [SELECT Id, Username, UserRoleId FROM User WHERE Profile.Name = 'System Administrator' and IsActive = true LIMIT 1];
        admin.UserRoleId = userRole_1.Id;
        update admin; 

        System.runAs(admin){         
        
        account acc = [select id from account where name = 'Identity Individual Users12yTest'];
        test.startTest(); 
            
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
                        
            dbu_CCSearchExtension.BrandResponse b = new dbu_CCSearchExtension.BrandResponse();
            b.combinedBrands = new list<string>{'aaa'};
            b.ProductBrandListMap = new Map<string,set<string>>{'aaa' => new set<string>{'aaa'}};
            try{
                 //Change by Ravi
               // dbu_CCSearchExtension.getExternalIp();
            }
            catch(Exception e){}
            try{
                dbu_CCSearchExtension.getSearchResultFornormal(null,null,null,null);
            }
            catch(Exception e){}
            try{
                dbu_CCSearchExtension.fetchbrandBySearchResult(null);
            }
            catch(Exception e){}
            test.stopTest();
        }
    }
    
}
//Prod Deployment 23-09-2022