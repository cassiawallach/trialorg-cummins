@isTest
public class dbu_FactoryDataTest {
    
    //TEST DATA VARIABLES
    private static string BILLING_COUNTRY       =   'United States';
    private static string ACCOUNT_REGION        =   'US and Canada';
    private static string TIMEZONE              =   'America/Panama';
    private static string EMAIL_ENCODING        =   'ISO-8859-1';
    private static string LOCALE                =   'en_US';
    private static string LANGUAGE              =   'English';
    private static string USERNAME              =   '38788ullmann@cmiuser.com.fulluat'; 
    private static string EMAIL                 =   'testuserkaazzanrussia@gmail.com'; 
    private static string FEDID                 =   'testuserkaazzanrussia@gmail.com';
    private static string COMPANY_NAME          =   'test user company';   
    private static string PHONE                 =   '83689376493';   
    private static string STATUS                =   'Active';
    private static string NICKNAME              =   'NickCustomer';
    private static string EMAIL_ENCODING_USER   =   'UTF-8';
    private static string STOREFRONT			=   'CSSNAStore';
    private static string PRODUCTGROUPNAME		=   'Ecom';
    private static Date START_DATE				=	Date.parse('6/20/2019');
    private static Date END_DATE				=	Date.parse('12/31/2099');
    private static string CurrencyISOCode		=	'USD';
    private static string PRODUCTURI			=	'https://cssna-parts.gdc-rad.com/4940181.png';
        
    
    //Get RecordTypeID 
    //public static Id AccountRecordType = Schema.SObjectType.Account.getRecordTypeInfosByName().get('IAM Global').getRecordTypeId();
    //public static Id ContactRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('IAM').getRecordTypeId();
    
    //Get Profile Id - IAM User
    //private static Id profileId = [Select Id From Profile Where Name='IAM User'].id;
    
    //Get User Role
    //UserRole userrole = [Select Id, DeveloperName From UserRole Where DeveloperName = 'CEO' Limit 1];
    
    public static Account createIAMAccount(string accountName , ID AccountRecordType){
        Account objAccount                              =   new Account();
        objAccount.Name                                 =   accountName;
        objAccount.Type                                 =   'Customer';
        objAccount.CMI_Account_Status__c                =   STATUS;
        objAccount.IAM_WWSPS_Regions__c                 =   ACCOUNT_REGION;
        objAccount.CSS_EmailEncoding__c                 =   EMAIL_ENCODING;
        objAccount.CSS_Timezone__c                      =   TIMEZONE;
        objAccount.ERP_System__c                        =   'No ERP System';
        objAccount.IA_CSSEnabled__c                     =   true;
       	objAccount.CSS_Locale__c                        =   LOCALE;
        objAccount.CSS_Language__c                      =   LANGUAGE;
        objAccount.BillingCountry                       =   BILLING_COUNTRY;
        objAccount.ShippingCountry                      =   BILLING_COUNTRY;
        objAccount.RecordTypeId                         =   AccountRecordType;
        
        return objAccount;
    }
    
    public static ccrz__E_AccountGroup__c createAccountGroup(string AGName, string selectionMethod){
        ccrz__E_AccountGroup__c objAccountGroup				=	new ccrz__E_AccountGroup__c();
        objAccountGroup.Name								=	AGName;
        objAccountGroup.ccrz__PriceListSelectionMethod__c	=	selectionMethod;
        return objAccountGroup;
    }
    
    public static ccrz__E_AccountGroupPriceList__c createAccountGroupPriceList(ID AccGroupId, ID curPriceListId){
        ccrz__E_AccountGroupPriceList__c objAccountGroupPriceList = new ccrz__E_AccountGroupPriceList__c();
        objAccountGroupPriceList.ccrz__StartDate__c				  = START_DATE;
        objAccountGroupPriceList.ccrz__EndDate__c				  = END_DATE;
        objAccountGroupPriceList.ccrz__Sequence__c				  = 500;
        objAccountGroupPriceList.ccrz__Enable__c				  = true;
        objAccountGroupPriceList.ccrz__AccountGroup__c			  = AccGroupId;
        objAccountGroupPriceList.ccrz__Pricelist__c				  = curPriceListId;
        return objAccountGroupPriceList;
    }    

    public static Contact createIAMContact(string FIRSTNAME, string LASTNAME, ID AccountID, ID ContactRecordTypeId){
        Contact objContact                              =   new Contact();
        objContact.FirstName                            =   FIRSTNAME;
        objContact.LastName                             =   LASTNAME;
		       
        objContact.CMI_Contact_Type__c                  =   'Secondary';
        objContact.IAM_Ext_Legacy_Uid__c                =   EMAIL;
        objContact.dbu_Company_Name__c                  =   COMPANY_NAME; 
        objContact.Phone                                =   PHONE;
        objContact.Email                                =   EMAIL;
        objContact.IAM_Contact_Status__c                =   STATUS;
        objContact.RecordTypeId                         =   ContactRecordTypeId;
        //objContact.Username__c                          =   EMAIL;
        objContact.MailingCountry                       =   BILLING_COUNTRY;
        objContact.OtherCountry                         =   BILLING_COUNTRY;
        objContact.IAM_Work_Group_Id__c                 =   'null-P';
        objContact.IAM_Contact_source__c                =   'LDAP';
		
        objContact.AccountId                            =   AccountID;
        
        return objContact;
    }
    
    public static user createIAMUser(string FIRSTNAME, string LASTNAME, ID ContactID, ID profileId){
        user objUser                                =   new User();
        objUser.FirstName                           =   FIRSTNAME;
        objUser.LastName                            =   LASTNAME;
        objUser.Alias                               =   'Tsr';
        objUser.CompanyName                         =   COMPANY_NAME;
        objUser.Username                            =   USERNAME;
        objUser.Email                               =   EMAIL;
        objUser.Country                             =   BILLING_COUNTRY;
        objUser.CommunityNickname                   =   NICKNAME;
        objUser.TimeZoneSidKey                      =   TIMEZONE;
        objUser.LocaleSidKey                        =   LOCALE;
        //objUser.FederationIdentifier                =   FEDID;

        objUser.ProfileId                           =   profileId;
        objUser.ContactId                           =   ContactID;
        objUser.Phone                               =   PHONE;
        objUser.EmailEncodingKey                    =   EMAIL_ENCODING_USER;
        objUser.CSS_User_MultiLocValues__c          =   'null-P';
        objUser.UserGroup__c                        =   'EDS_User';
        objUser.IAM_UID__c                          =   EMAIL;
        objUser.IAM_Abocode__c                      =   '1';
        objUser.IAM_Final_Approver__c               =   'N';
        objUser.IAM_WorkGroup_id__c                 =   'null-P';
        objUser.tableauId__c                        =   LASTNAME;
        objUser.activeEquipmentDuration__c          =   '21';
        objUser.sessionTimeout__c                   =   '86400000';
        objUser.LanguageLocaleKey					=	LOCALE;
        //objUser.UserRoleId							=	ID.valueof((string.valueof(userrole.Id)));
        objUser.ccrz__CC_CurrencyCode__c 			=	'USD';
        return objUser;
    }
    
    public static ccrz__E_Product__c createProduct(string ProductName, Boolean Taxable, Boolean Nonreturnable, Boolean PickupOnly, Boolean AvailableToShip){
        ccrz__E_Product__c objProduct				=	new ccrz__E_Product__c();
        objProduct.Name								=	ProductName;
        objProduct.ccrz__SKU__c						=	ProductName;
        objProduct.ccrz__Quantityperunit__c			=	1.000000;
        objProduct.ccrz__ProductType__c				=	'Product';
        objProduct.ccrz__UnitOfMeasure__c			=	'Each';
        objProduct.ccrz__Taxable__c					=	Taxable;
        objProduct.dbu_Non_Returnable__c			=	Nonreturnable;
        objProduct.dbu_Pick_Up_Only__c				=	PickupOnly;
        objProduct.dbu_Available_to_ship__c			=	AvailableToShip;
        objProduct.ccrz__ProductStatus__c			=	'Released';
        objProduct.ccrz__StartDate__c				=	START_DATE;
        objProduct.ccrz__EndDate__c					=	END_DATE;
        objProduct.Group_Name__c					=	PRODUCTGROUPNAME;
        objProduct.ccrz__Storefront__c				=	STOREFRONT;
        objProduct.ccrz__LeadTime__c				=	1;
        objProduct.ccrz__ShortDescRT__c				=	ProductName;
        objProduct.dbu_Part_Number__c				=	ProductName+'so2mx';
        
        return objProduct;
    }
    
    public static ccrz__E_PriceList__c createPriceList(string PricelistName){
        ccrz__E_PriceList__c objPriceList 			=	new ccrz__E_PriceList__c();
        objPriceList.Name							=	PricelistName;
        objPriceList.ccrz__Storefront__c			=	STOREFRONT;
        objPriceList.ccrz__CurrencyISOCode__c		=	CurrencyISOCode;
        objPriceList.ccrz__Enabled__c				=	true;
        objPriceList.ccrz__CustomerTypeCode__c		=	'General';
        objPriceList.ccrz__StartDate__c				=	START_DATE;
        objPriceList.ccrz__EndDate__c				=	END_DATE;
        
        return objPriceList;
    }
    
    
    public static ccrz__E_RelatedProduct__c createRelatedProduct(id RelatdProd, id Prod, string prodType){
        ccrz__E_RelatedProduct__c objRelatedProduct = new ccrz__E_RelatedProduct__c();
        objRelatedProduct.ccrz__RelatedProduct__c	=	RelatdProd;
		objRelatedProduct.ccrz__Product__c			=	Prod;
		objRelatedProduct.ccrz__RelatedProductType__c	=	prodType;
		objRelatedProduct.ccrz__EndDate__c			=	END_DATE;
		objRelatedProduct.ccrz__Sequence__c			=	500;
		objRelatedProduct.ccrz__Enabled__c			=	true;
		objRelatedProduct.ccrz__StartDate__c		=	START_DATE;
            
        return objRelatedProduct;
    }
    
    
    public static ccrz__E_PriceListItem__c createPriceListItem (string PricelistItemName, double ORIGINAL_PRICE, double DISCOUNT_AMT, string DISCOUNT_TYPE, double PRICE, ID ProductID, ID PricelistID){
        ccrz__E_PriceListItem__c objPriceListItem 	=	new ccrz__E_PriceListItem__c();
        objPriceListItem.ccrz__Pricelist__c			=	PricelistID;
        objPriceListItem.ccrz__StartDate__c			=	START_DATE;
        objPriceListItem.ccrz__EndDate__c   		=	END_DATE;
        objPriceListItem.dbu_Original_Price__c		=	ORIGINAL_PRICE;
        objPriceListItem.dbu_Discount_Amount__c		=	DISCOUNT_AMT;
        objPriceListItem.dbu_Discount_Type__c		=	DISCOUNT_TYPE;
        objPriceListItem.ccrz__Price__c				=	PRICE;
        objPriceListItem.ccrz__Product__c   		=	ProductID;
            
        return objPriceListItem;
    }
    
    public static ccrz__E_ProductMedia__c createProductMedia(ID ProductID, string MEDIATYPE){
        ccrz__E_ProductMedia__c objProductMedia 	=	new ccrz__E_ProductMedia__c();
        objProductMedia.ccrz__StartDate__c			=	START_DATE;
        objProductMedia.ccrz__EndDate__c			=	END_DATE;
        objProductMedia.ccrz__Product__c			=	ProductID;
        objProductMedia.ccrz__Sequence__c			=	500;
        objProductMedia.ccrz__Locale__c				=	'en_US';
        objProductMedia.ccrz__MediaType__c			=	MEDIATYPE;
        objProductMedia.ccrz__ProductMediaSource__c =	'URI';
        objProductMedia.ccrz__URI__c				=	PRODUCTURI;
        
        return objProductMedia;
        
    }
    
    public static ccrz__E_ProductInventoryItem__c createProductInventoryItem(string ProductInventoryItemName, ID ProductID, double QuantityAvailable, string availablemessage, string status){
        ccrz__E_ProductInventoryItem__c objProductInventory = new ccrz__E_ProductInventoryItem__c();
        objProductInventory.Name					=	ProductInventoryItemName;
		objProductInventory.ccrz__ProductItem__c	=	ProductID;
        objProductInventory.ccrz__QtyAvailable__c	=	QuantityAvailable;
        objProductInventory.ccrz__Status__c			=	status;
        objProductInventory.ccrz__AvailabilityMessage__c = availablemessage;

        return objProductInventory;
    }
    
    
    public static ccrz__E_Cart__c createCart(string Name, string cartOrWishlist, id usrId, id cntId, id accId, boolean cartActive){
        ccrz__E_Cart__c	objCart						=	new ccrz__E_Cart__c();
        objCart.ccrz__Name__c						=	Name;
        objCart.ccrz__CartType__c					=	cartOrWishlist;
        objCart.ccrz__CurrencyISOCode__c			=	CurrencyISOCode;
        objCart.ccrz__ActiveCart__c					=	cartActive;
        objCart.ccrz__Storefront__c					=	STOREFRONT;
        objCart.ccrz__CartStatus__c					=	'Open';
        
        return objCart;
    }
    
    public static ccrz__E_CartItem__c createCartItem(id cartid, double itemPrice, double itemqty, id productId){
        ccrz__E_CartItem__c objCartIem				=	new ccrz__E_CartItem__c();
        objCartIem.ccrz__Cart__c					=	cartid;
        objCartIem.ccrz__StoreID__c					=	'CSSNAStore';
        objCartIem.ccrz__ItemStatus__c				=	'Available';
        objCartIem.ccrz__UnitOfMeasure__c			=	'Each';
        objCartIem.ccrz__ProductType__c				=	'Product';
        objCartIem.ccrz__cartItemType__c			=	'Major';
        objCartIem.ccrz__PricingType__c				=	'auto';
        objCartIem.ccrz__OriginalItemPrice__c		=	itemPrice;
        objCartIem.ccrz__OriginalQuantity__c		=	itemqty;
		objCartIem.ccrz__Quantity__c				=	itemqty;
        objCartIem.ccrz__Price__c					=	itemPrice;
        objCartIem.ccrz__SubAmount__c				=	itemPrice * itemqty;
        objCartIem.ccrz__Product__c					=	productId;
                        
        return objCartIem;
    }
    
    public static ccrz__E_ContactAddr__c createContactAddress(string add1,string add2,string state ,string  zip,string country,string city){
        ccrz__E_ContactAddr__c objContAdd			=	new ccrz__E_ContactAddr__c();
        objContAdd.ccrz__Country__c					=	country;       
        objContAdd.ccrz__AddressFirstline__c		=	add1;
        objContAdd.ccrz__AddressSecondline__c		=	add2;
        objContAdd.ccrz__City__c					=	city;
        objContAdd.ccrz__State__c					=	state;
        objContAdd.ccrz__PostalCode__c				=	zip;
		objContAdd.ccrz__ShippingComments__c		=	'shiping commenta';
        return objContAdd;
    }
    
    public static dbu_Store_Location__c createStoreLocation(){
        dbu_Store_Location__c objStoreLoc = new dbu_Store_Location__c();
        objStoreLoc.dbu_Business_Hours__c = 'Mon- Fri';
        objStoreLoc.dbu_City__c='Maple City';
        objStoreLoc.dbu_Country__c='Canada';
        objStoreLoc.dbu_Geo_Location__Latitude__s=null;
        objStoreLoc.dbu_Geo_Location__Longitude__s=null;
        objStoreLoc.dbu_Phone__c='123567';
        objStoreLoc.dbu_StoreCode__c='12345';
        objStoreLoc.dbu_Street__c='Charles street';
        objStoreLoc.dbu_ZipCode__c='12345';
        objStoreLoc.Name='Cummins-Store';
        return objStoreLoc;
    }
    
    
    
    
}