//Subbu class fix
@isTest
public class TestingUtils {
    
    // Setup Test Data
    public static final Id SYS_ADMIN_PROFILE_ID = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id; 
    
    // Admin User
    public static User ADMIN_USER {
        get{
            if ( null == ADMIN_USER ){
                ADMIN_USER = [Select Id, Name from User where ProfileId = :SYS_ADMIN_PROFILE_ID and IsActive = true LIMIT 1];
            }
            return ADMIN_USER;
        }
        private set;
    }
    
    // Create User
    public static User createUser ( String lName, Id profileId, Boolean doInsert ) {
        
        Integer nameEnd = (lName.length() < 8) ? lName.length()-1 : 8;
        
        User testUser = new User();
        testUser.FirstName = 'Testttt';
        testUser.LastName = lName;
        testUser.UserName = lName + '@test.com';
        testUser.Email = lName + '@test.com';
        testUser.Alias = lName.substring( 0, nameEnd );
        testUser.CommunityNickname = lName.substring( 0, nameEnd );
        testUser.ProfileId = profileId;
        testUser.TimeZoneSidKey = 'America/New_York';
        testUser.isActive = true;
        testUser.LocaleSidKey = 'en_US';
        testUser.LanguageLocaleKey = 'en_US';
        testUser.EmailEncodingKey = 'ISO-8859-1';
        
        if ( doInsert ){
            System.runAs(ADMIN_USER){
                insert testUser;
            }
        }
        return testUser;
    }
    
    // Create Portal User
    public static User createPortalUser ( String lName, Id portalRoleId, /*Id contactId,*/Id profileId, Boolean doInsert ) {
        
        Integer nameEnd = (lName.length() < 8) ? lName.length()-1 : 8;
        
        User testUser = new User();
        //testUser.UserRoleId = portalRoleId;
        testUser.FirstName = 'Testttt';
        testUser.LastName = lName;
        //testUser.ContactId = contactId;
        testUser.UserName = LName + '@test.com';
        testUser.Email = lName + '@test.com';
        testUser.Alias = lName.substring( 0, nameEnd );
        testUser.CommunityNickname = lName.substring( 0, nameEnd );
        testUser.ProfileId = profileId;
        testUser.TimeZoneSidKey = 'America/New_York';
        testUser.isActive = true;
        testUser.LocaleSidKey = 'en_US';
        testUser.LanguageLocaleKey = 'en_US';
        testUser.EmailEncodingKey = 'ISO-8859-1';
        
        if ( doInsert ){
            System.runAs(ADMIN_USER){
                insert testUser;
            }
        }
        return testUser;
    }
    
    // Create Portal User - with Contact ID	
    public static User createPortalUser ( String lName, Id portalRoleId, Id contactId,Id profileId, Boolean doInsert ) {	
        	
        Integer nameEnd = (lName.length() < 8) ? lName.length()-1 : 8;	
        	
        User testUser = new User();	
        //testUser.UserRoleId = portalRoleId;	
        testUser.FirstName = 'Testttt';	
        testUser.LastName = lName;	
        testUser.ContactId = contactId;	
        testUser.UserName = LName + '@test.com';	
        testUser.Email = lName + '@test.com';	
        testUser.Alias = lName.substring( 0, nameEnd );	
        testUser.CommunityNickname = lName.substring( 0, nameEnd );	
        testUser.ProfileId = profileId;	
        testUser.TimeZoneSidKey = 'America/New_York';	
        testUser.isActive = true;	
        testUser.LocaleSidKey = 'en_US';	
        testUser.LanguageLocaleKey = 'en_US';	
        testUser.EmailEncodingKey = 'ISO-8859-1';	
        	
        if ( doInsert ){	
            System.runAs(ADMIN_USER){	
                insert testUser;	
            }	
        }	
        return testUser;	
    }

    //Create Contact
    public static List<Contact> createContact(Integer numToCreate, Id AccountId, Id UserId, Boolean doInsert){ 
        List<Contact> lstContact = new List<Contact>();
        
        for(Integer i=0; i<numToCreate; i++){
            Contact testContact = new Contact();
            testContact.FirstName = 'FirstName';
            testContact.LastName = 'LastName' + i;
            testContact.AccountId = AccountId;
            testContact.MobilePhone = '9999999999';
            testContact.Email = 'testEmail' + i + '@test.com';
            testContact.IAM_Contact_Status__c = 'Active';
            testContact.Username__c='testusernameunique1234321@gmail.com';
            testContact.CMI_Contact_Type__c='Primary';
            //Added by Sangeeta on 21-09-2018 to fix test class
            //testContact.IDM_Contact_Status__c = 'Active';
            if(UserId!=null)
                testContact.OwnerId = UserId;
            
            lstContact.add(testContact);
        }
        if(doInsert)
            insert lstContact;
        return lstContact;
    }    
    
   // Create Request For quote
    public static List<ccrz__E_RequestForQuote__c> createRequestForQuote(Integer numToCreate, String status, Integer discountPercent,Integer discountPrice,Integer costPerSubs, String operation, String salesUserComments,Id productId,Id contactId, Boolean doInsert){
        List<ccrz__E_RequestForQuote__c> lstRequestForQuote = new List<ccrz__E_RequestForQuote__c>();
        
        for(Integer i=0; i<numToCreate; i++){
            ccrz__E_RequestForQuote__c testRequestForQuote = new ccrz__E_RequestForQuote__c();
            testRequestForQuote.Status__c = status;
            testRequestForQuote.Discounted_Percentage__c = discountPercent;
            testRequestForQuote.Discounted_Price__c = discountPrice;
            testRequestForQuote.Cost_Subscription__c = costPerSubs;
            testRequestForQuote.Operation__c = operation;
            testRequestForQuote.CC_Product__c = productId;
            testRequestForQuote.ccrz__Contact__c =contactId;
            testRequestForQuote.Sales_User_Comments__c = salesUserComments;
            
            lstRequestForQuote.add(testRequestForQuote);
        }
        if(doInsert)
            insert lstRequestForQuote;
        return lstRequestForQuote;
    }
    
    // Create CC Order
    public static ccrz__E_Order__c createOrder(Id contactId,String orderName, Boolean doInsert){
        
            ccrz__E_Order__c testOrder = new ccrz__E_Order__c();
            testOrder.ccrz__Name__c = orderName ;
            testOrder.ccrz__Contact__c = contactId;
            
        if(doInsert)
            insert testOrder;
        return testOrder;
    }
    
    // Create CC Order Items
    public static ccrz__E_OrderItem__c createOrderItems(Id orderId, Id productId ,Boolean doInsert){
        
            ccrz__E_OrderItem__c testOrderItem = new ccrz__E_OrderItem__c();
            testOrderItem.ccrz__Order__c = orderId;
            testOrderItem.ccrz__Product__c = productId;
            testOrderItem.ccrz__Price__c = 450;
            testOrderItem.ccrz__Quantity__c = 2;
            testOrderItem.ccrz__SubAmount__c = 200;
        
        if(doInsert)
            insert testOrderItem;
        return testOrderItem;
    }
    
      // Create CC Order Items - Extra parameters	
      public static ccrz__E_OrderItem__c createOrderItems(Id orderId, Id productId , id displayProductId, Boolean doInsert){	
            	
        ccrz__E_OrderItem__c testOrderItem = new ccrz__E_OrderItem__c();	
        testOrderItem.ccrz__Order__c = orderId;	
        testOrderItem.ccrz__Product__c = productId;	
        testOrderItem.ccrz__Price__c = 450;	
        testOrderItem.ccrz__Quantity__c = 2;	
        testOrderItem.ccrz__SubAmount__c = 200;	
        testOrderItem.ccrz__DisplayProduct__c = displayProductId;	
    if(doInsert)	
        insert testOrderItem;	
    return testOrderItem;	
    }

    // Create Price List
    public static List<ccrz__E_PriceList__c> createPriceList(Integer numToCreate, String name, String storefront, Boolean isEnable, String currencyIsoCode, Boolean doInsert){
        List<ccrz__E_PriceList__c> lstPriceList = new List<ccrz__E_PriceList__c>();
        
        for(Integer i=0; i<numToCreate; i++){
            ccrz__E_PriceList__c testPriceList = new ccrz__E_PriceList__c();
            testPriceList.Name = name + i;
            testPriceList.ccrz__StartDate__c = System.today().addMonths(-1);
            testPriceList.ccrz__EndDate__c = System.today().addMonths(5);
            testPriceList.ccrz__CurrencyISOCode__c = currencyIsoCode;
            testPriceList.ccrz__Enabled__c = isEnable;
            testPriceList.ccrz__Storefront__c = storefront;
            
            lstPriceList.add(testPriceList);
        }
        if(doInsert)
            insert lstPriceList;
        return lstPriceList;
    }
    
    // Create Price List Item
    public static List<ccrz__E_PriceListItem__c> createPriceListItem(Integer numToCreate, Id subProdTerm, List<ccrz__E_PriceList__c> lstPriceList, List<ccrz__E_Product__c> lstEProduct, Boolean doInsert){
        List<ccrz__E_PriceListItem__c> lstPriceListItem = new List<ccrz__E_PriceListItem__c>();
     
        
        for(Integer i=0; i<numToCreate; i++){
            ccrz__E_PriceListItem__c testPriceListItem = new ccrz__E_PriceListItem__c();
            testPriceListItem.ccrz__StartDate__c = System.today().addMonths(-1);
            testPriceListItem.ccrz__EndDate__c = System.today().addMonths(5);
            testPriceListItem.ccrz__Pricelist__c = lstPriceList[i].Id;
            testPriceListItem.ccrz__Product__c = lstEProduct[i].Id;
            testPriceListItem.ccrz__SubProdTerm__c = subProdTerm;
            
            lstPriceListItem.add(testPriceListItem);
        }
        if(doInsert)
            insert lstPriceListItem;
        return lstPriceListItem;
    }
    
    // Create Account Group
    public static List<ccrz__E_AccountGroup__c> createAccountGroup(Integer numToCreate, String accGrpName, String priceListSelectionMethod, Boolean doInsert){
        List<ccrz__E_AccountGroup__c> lstAccountGroup = new List<ccrz__E_AccountGroup__c>();
        
        for(Integer i=0; i<numToCreate; i++){
            ccrz__E_AccountGroup__c testAccGrp = new ccrz__E_AccountGroup__c();
            testAccGrp.Name = accGrpName + i;
            testAccGrp.ccrz__PriceListSelectionMethod__c = priceListSelectionMethod;
            testAccGrp.ccrz__Desc__c = 'test Description' + i;
            
            lstAccountGroup.add(testAccGrp);
        }
        if(doInsert)
            insert lstAccountGroup;
        return lstAccountGroup;
    }
    
    // Create Account Group Price List
    public static List<ccrz__E_AccountGroupPriceList__c> createAccGrpPriceList(Integer numToCreate, List<ccrz__E_AccountGroup__c> lstAccountGroup, List<ccrz__E_PriceList__c> lstPriceList, Boolean isEnable, Double sequence, Boolean doInsert){
        List<ccrz__E_AccountGroupPriceList__c> lstAccGrpPriceList = new List<ccrz__E_AccountGroupPriceList__c>();
        
        for(Integer i=0; i<numToCreate; i++){
            ccrz__E_AccountGroupPriceList__c accGrpPriceList = new ccrz__E_AccountGroupPriceList__c();
            accGrpPriceList.ccrz__AccountGroup__c = lstAccountGroup[i].Id;
            accGrpPriceList.ccrz__Pricelist__c = lstPriceList[i].Id;
            accGrpPriceList.ccrz__Enable__c = isEnable;
            accGrpPriceList.ccrz__StartDate__c = System.today().addMonths(-1);
            accGrpPriceList.ccrz__EndDate__c = System.today().addMonths(4);
            accGrpPriceList.ccrz__Sequence__c = sequence + i;
            
            lstAccGrpPriceList.add(accGrpPriceList);
        }
        if(doInsert)
            insert lstAccGrpPriceList;
        return lstAccGrpPriceList;
    }
    
    //Create Account
    public static List<Account> createAccount(Integer numToCreate, String accName, Id accGrpId, Id ownerId, Boolean doInsert){
        List<Account> lstAccount = new List<Account>();
        
        for(Integer i=0; i<numToCreate; i++){
            Account testAccount = new Account();
            testAccount.Name = accName + i;
            testAccount.BMS_Customer_ID__c = '53453';
            testAccount.CSS_DistributorCode__c= '04959';
            testAccount.ccrz__E_AccountGroup__c = accGrpId;
            testAccount.BillingStreet = 'Street'+i;
            testAccount.BillingCity = 'City'+ i;
            testAccount.BillingState = 'Illinois';
            testAccount.BOLT_Account_Number__c = '390';
            testAccount.BillingPostalCode = '11000'+ i;
            testAccount.BillingCountry = 'United States';
            testAccount.CMI_Region__c = 'India';
            testAccount.CSS_Locale__c = 'English(India)';
            testAccount.OSM_Preferred_Billing_Frequency_Lock__c=false;
            testAccount.OSM_Preferred_Billing_Frequency__c='one year';
            // JUHI Changes - prevent hard coding of ID
        testAccount.RecordTypeId = OSM_TestDataCreationUtility.getAccountRecordTypeID();
        //testAccount.RecordTypeId = '0124C000000Cimc';
            //testAccount.OwnerId = ADMIN_USER.id;
            testAccount.OSM_Preferred_Payment_Method__c = 'po';
            testAccount.OwnerId = ownerId;
            testAccount.CMI_Cid__c = '390';
           // testAccount.IDM_Primary_Market_Segment__c = 'Bus';
            testAccount.IAM_Primary_Market_Segment__c = 'Bus';
            testAccount.CSS_Timezone__c = '(GMT+05:30) India Standard Time (Asia/Kolkata)';
            testAccount.CSS_DistributorCode__c ='12345';
           // testAccount.Next_Invoice_Generation_Date__c = System.today();
           // testAccount.Is_Active_Subscription_Exists__c = true;
            lstAccount.add(testAccount);
        }
        if(doInsert)
            insert lstAccount;
        return lstAccount;
    }
        
    // Create E Cart    
    public static List<ccrz__E_Cart__c> CreateCart(Integer numToCreate, String storefront, String carttype, Id userid, Boolean activecart, String status, Boolean doInsert,Id accountId){
        List<ccrz__E_Cart__c> lstECart = new List<ccrz__E_Cart__c>();
        
        for(Integer i=0; i<numToCreate; i++){
            ccrz__E_Cart__c testCart = new ccrz__E_Cart__c();
            testCart.ccrz__Storefront__c = storefront;
            testCart.ccrz__Account__c = accountId;
            testCart.ccrz__CartType__c = carttype;
            testCart.ccrz__ActiveCart__c = activecart;
            testCart.ccrz__CartStatus__c=status;
            testCart.ccrz__User__c = userid;
            testCart.ccrz__EncryptedId__c = 'encrypt' + i ;
            testCart.OSM_Payment_Method__c='cc';
            lstECart.add(testCart);
        }   
        if(doInsert)
            insert lstECart;
        return lstECart;
    }
   
    // Create Composite Product
    public static ccrz__E_Product__c createCompositeProduct (String name,String sku, String gname, String productType, Boolean doInsert){
    ccrz__E_Product__c ccCompositeProduct = new ccrz__E_Product__c();
       
        ccCompositeProduct.name = name;
        ccCompositeProduct.ccrz__ProductStatus__c = 'Released';
        ccCompositeProduct.ccrz__Quantityperunit__c = 1;
        ccCompositeProduct.ccrz__SKU__c = sku ;
        ccCompositeProduct.ccrz__StartDate__c = System.today().addMonths(-1);
        ccCompositeProduct.ccrz__EndDate__c = System.today().addMonths(4);
        ccCompositeProduct.Group_Name__c = gname;
        ccCompositeProduct.ccrz__LongDesc__c = 'Long Description';
        ccCompositeProduct.ccrz__ProductType__c = productType;
        ccCompositeProduct.Product_Class_Code__c = 'SW-Web Access';
        
      
        if(doInsert)
          insert ccCompositeProduct;
      return ccCompositeProduct;
    }
    
    // Create E Products
    public static List<ccrz__E_Product__c> createEProduct(Integer numToCreate, String name, String status, Integer quantity, String sku, String gname, Boolean doInsert){
        List<ccrz__E_Product__c> lstEProduct = new List<ccrz__E_Product__c>();
        
        for(Integer i=0; i<numToCreate; i++){
            ccrz__E_Product__c testProduct = new ccrz__E_Product__c();
            testProduct.name = name + i;
            testProduct.ccrz__ProductStatus__c = status;
            testProduct.ccrz__Quantityperunit__c = quantity;
            testProduct.ccrz__SKU__c = sku + i;
            testProduct.ccrz__StartDate__c = System.today().addMonths(-1);
            testProduct.ccrz__EndDate__c = System.today().addMonths(4);
            testProduct.Group_Name__c = gname;
            testProduct.Package__c = 'Base';
            testProduct.Product_Class_Code__c = 'SW-Web Access';
            testProduct.ccrz__Storefront__c = 'SoftwareStore';
            lstEProduct.add(testProduct);
        }
        if(doInsert)
            insert lstEProduct;
        return lstEProduct;
    }
    
     // Create E Products - different Parameters	
     public static List<ccrz__E_Product__c> createEProduct(Integer numToCreate, String name, String status, Integer quantity, String sku, String gname, string packageName, String productType, Boolean doInsert){	
        List<ccrz__E_Product__c> lstEProduct = new List<ccrz__E_Product__c>();	
        	
        for(Integer i=0; i<numToCreate; i++){	
            ccrz__E_Product__c testProduct = new ccrz__E_Product__c();	
            testProduct.name = name + i;	
            testProduct.ccrz__ProductStatus__c = status;	
            testProduct.ccrz__Quantityperunit__c = quantity;	
            testProduct.ccrz__SKU__c = sku + i;	
            testProduct.ccrz__StartDate__c = System.today().addMonths(-1);	
            testProduct.ccrz__EndDate__c = System.today().addMonths(4);	
            testProduct.Group_Name__c = gname;	
            testProduct.Package__c = packageName;	
            testProduct.ccrz__ProductType__c = productType;	
            testProduct.Product_Class_Code__c = 'SW-Web Access';	
            testProduct.ccrz__Storefront__c = 'SoftwareStore';	
            lstEProduct.add(testProduct);	
        }	
        if(doInsert)	
            insert lstEProduct;	
        return lstEProduct;	
    }

    // Create CC Component Products
    public static List<ccrz__E_Product__c> createCcComponentProducts(Integer numToCreate, String name, String status, Integer quantity, String sku, String gname, String packageName, Boolean doInsert){
        List<ccrz__E_Product__c> lstCcComponentProducts = new List<ccrz__E_Product__c>();
        
        for(Integer i=0; i<numToCreate; i++){
            ccrz__E_Product__c testCcComponentProduct = new ccrz__E_Product__c();
            testCcComponentProduct.name = name+'ComponentProduct' + i;
            testCcComponentProduct.ccrz__ProductStatus__c = status;
            testCcComponentProduct.ccrz__Quantityperunit__c = quantity;
            testCcComponentProduct.ccrz__SKU__c = sku + i;
            testCcComponentProduct.ccrz__StartDate__c = System.today().addMonths(-1);
            testCcComponentProduct.ccrz__EndDate__c = System.today().addMonths(4);
            testCcComponentProduct.Group_Name__c = gname;
            testCcComponentProduct.Package__c = packageName;
            testCcComponentProduct.Product_Class_Code__c = 'SW-Web Access';
            testCcComponentProduct.ccrz__Storefront__c = 'SoftwareStore';
            lstCcComponentProducts.add(testCcComponentProduct);
        }
        if(doInsert)
            insert lstCcComponentProducts;
        return lstCcComponentProducts;
    }
    
    // Create SubProdTerm
    public static List<ccrz__E_SubProdTerm__c> createSubProdTerm(Integer numToCreate, String name,Id productid,string operation, Boolean doInsert){
        List<ccrz__E_SubProdTerm__c> lstESubProdTerm = new List<ccrz__E_SubProdTerm__c>();
        
        for(Integer i=0; i<numToCreate; i++){
            ccrz__E_SubProdTerm__c testSubProdTerm = new ccrz__E_SubProdTerm__c();
            testSubProdTerm.name = name + i;
            testSubProdTerm.ccrz__EffectiveStart__c = System.today().addMonths(-1);
            testSubProdTerm.ccrz__EffectiveEnd__c = System.today().addMonths(4);
            testSubProdTerm.ccrz__CCProduct__c = productid;
            testSubProdTerm.Operation__c =operation;
            testSubProdTerm.ccrz__Enabled__c = true;
            testSubProdTerm.ccrz__Storefront__c = 'SoftwareStore';
            testSubProdTerm.Billing_Display_Name__c = 'Monthly';
            testSubProdTerm.ccrz__DisplayName__c = 'Monthly';	
            testSubProdTerm.ccrz__OrderFrequency__c = 1;
            lstESubProdTerm.add(testSubProdTerm);
        }
        if(doInsert)
            insert lstESubProdTerm;
        return lstESubProdTerm;
    }
    
     // Create SubProdTerm -Different Parameters	
     public static List<ccrz__E_SubProdTerm__c> createSubProdTerm(Integer numToCreate, String name,Id productid,string operation, String billingDisplayName, Boolean doInsert){	
        List<ccrz__E_SubProdTerm__c> lstESubProdTerm = new List<ccrz__E_SubProdTerm__c>();	
        	
        for(Integer i=0; i<numToCreate; i++){	
            ccrz__E_SubProdTerm__c testSubProdTerm = new ccrz__E_SubProdTerm__c();	
            testSubProdTerm.name = name + i;	
            testSubProdTerm.ccrz__EffectiveStart__c = System.today().addMonths(-1);	
            testSubProdTerm.ccrz__EffectiveEnd__c = System.today().addMonths(4);	
            testSubProdTerm.ccrz__CCProduct__c = productid;	
            testSubProdTerm.Operation__c =operation;	
            testSubProdTerm.ccrz__Enabled__c = true;	
            testSubProdTerm.ccrz__Storefront__c = 'SoftwareStore';	
            testSubProdTerm.Billing_Display_Name__c = billingDisplayName;	
            testSubProdTerm.ccrz__DisplayName__c = billingDisplayName;	
            testSubProdTerm.ccrz__OrderFrequency__c = 1;	
            lstESubProdTerm.add(testSubProdTerm);	
        }	
        if(doInsert)	
            insert lstESubProdTerm;	
        return lstESubProdTerm;	
    }	

    // Create E CartItem
    public static List<ccrz__E_CartItem__c> createCartItem(Integer numToCreate, String storefront, String cartid, String carttype, Integer quantity , Id Productid, Id subprodterm, Decimal price, Boolean doInsert){
        List<ccrz__E_CartItem__c> lstECartItem = new List<ccrz__E_CartItem__c>();
        
        for(Integer i=0; i<numToCreate; i++){
            ccrz__E_CartItem__c testCartItem = new ccrz__E_CartItem__c();
            testCartItem.ccrz__Cart__c = cartid;
            testCartItem.ccrz__Quantity__c = quantity;
            testCartItem.ccrz__OriginalQuantity__c = quantity;
            testCartItem.ccrz__Product__c = Productid;
            testCartItem.ccrz__SubProdTerm__c = subprodterm;
            testCartItem.ccrz__Price__c = price;
            testCartItem.ccrz__RecurringPrice__c = price;
            testCartItem.ccrz__RecurringPriceSubAmt__c = price;
            testCartItem.ccrz__StoreID__c = storefront;
            testCartItem.ccrz__OriginalItemPrice__c = 100;
            testCartItem.ccrz__DisplayProduct__c = ProductId;
            testCartItem.ccrz__ProductType__c = 'Product';
            testCartItem.ccrz__cartItemType__c = carttype;
            testCartItem.ccrz__SubAmount__c = price;
            testCartItem.ccrz__Subscription_Duration__c = 12;
            testCartItem.ccrz__Subscription_Frequency__c = 4;
            testCartItem.ccrz__UnitOfMeasure__c = 'cm';
            testCartItem.ccrz__StoreID__c = 'SoftwareStore';
            
            lstECartItem.add(testCartItem);
        }       
        if(doInsert)
            insert lstECartItem;
        return lstECartItem;
    }
    
    // Create CC Composite Products with one composite product and list of component products
    public static List<ccrz__E_CompositeProduct__c> createCcCompProducts (Id compositeProductId, List<ccrz__E_Product__c> listComponentProduct, Boolean doInsert){
    
        List<ccrz__E_CompositeProduct__c> listCcCompProducts = new List<ccrz__E_CompositeProduct__c>();
            
        for(Integer i=0; i<listComponentProduct.size(); i++){
            ccrz__E_CompositeProduct__c ccCompProducts = new ccrz__E_CompositeProduct__c();
            ccCompProducts.ccrz__Composite__c = compositeProductId;
            ccCompProducts.ccrz__Quantity__c = 1;
            ccCompProducts.ccrz__Component__c = listComponentProduct[i].id;
            
            listCcCompProducts.add(ccCompProducts);
        }
        
        if(doInsert)
            insert listCcCompProducts;
        return listCcCompProducts;
    }
    
    // Create CC Spec
    public static List<ccrz__E_Spec__c> createCcSpecs (Integer numToCreate,String specName, Boolean doInsert){
    
        List<ccrz__E_Spec__c> listCcSpec = new List<ccrz__E_Spec__c>();
            
        for(Integer i=0; i<numToCreate; i++){
            ccrz__E_Spec__c ccSpec = new ccrz__E_Spec__c();
            ccSpec.Name = 'TestCCProductSpec' + i;
            ccSpec.ccrz__DisplayName__c = '1 Year';
            
            listCcSpec.add(ccSpec);
        }
        
        if(doInsert)
            insert listCcSpec;
        return listCcSpec;
    }
    
    
    // Create CC Product Spec
    public static List<ccrz__E_ProductSpec__c> createCcProductSpecs (Integer numToCreate,Id productId, List<ccrz__E_Spec__c> listCcSpec, Boolean doInsert){
    
        List<ccrz__E_ProductSpec__c> listCcProductSpec = new List<ccrz__E_ProductSpec__c>();
            
        for(Integer i=0; i<numToCreate; i++){
            ccrz__E_ProductSpec__c ccProductSpec = new ccrz__E_ProductSpec__c();
            ccProductSpec.ccrz__Product__c = productId;
            ccProductSpec.ccrz__Spec__c = listCcSpec[i].Id;
            
            listCcProductSpec.add(ccProductSpec);
        }
        
        if(doInsert)
            insert listCcProductSpec;
        return listCcProductSpec;
    }
    
    //Create CC Category
    /*Parent category*/
    public static ccrz__E_Category__c createParentCategory(String name, String categoryId, boolean doInsert){
        ccrz__E_Category__c ccParentCategory = new ccrz__E_Category__c();
        ccParentCategory.Name = 'Parent'+name + categoryId;
        ccParentCategory.ccrz__CategoryID__c = categoryId;
        ccParentCategory.ccrz__EndDate__c = System.today().addMonths(4);
        ccParentCategory.ccrz__Sequence__c = 0;
        ccParentCategory.ccrz__StartDate__c = System.today().addDays(-1);
        
        if(doInsert)
            insert ccParentCategory ;
        return ccParentCategory;
        
    } 
    
    /*Child Category*/
    public static ccrz__E_Category__c createChildCategory(String name, String categoryId,Id parentCategory, boolean doInsert){
        ccrz__E_Category__c ccChildCategory = new ccrz__E_Category__c();
        ccChildCategory.Name = 'Child'+ name + categoryId;
        ccChildCategory.ccrz__CategoryID__c = categoryId;
        ccChildCategory.ccrz__EndDate__c = System.today().addMonths(4);
        ccChildCategory.ccrz__Sequence__c = 100;
        ccChildCategory.ccrz__StartDate__c = System.today().addDays(-1);
        ccChildCategory.ccrz__ParentCategory__c = parentCategory;
        
        if(doInsert)
            insert ccChildCategory ;
        return ccChildCategory;       
    }
    
    //Create CC Featured Products
    public static List<ccrz__E_FeaturedProduct__c> createCCFeaturedProducts(Integer numToCreate, String name, String storefront, Id prodId, Id childCategory, boolean doInsert){
        List<ccrz__E_FeaturedProduct__c> lstCCFeaturedProducts = new List<ccrz__E_FeaturedProduct__c>();
        for(Integer i=0; i<numToCreate; i++){
            ccrz__E_FeaturedProduct__c ccFeaturedProducts = new ccrz__E_FeaturedProduct__c();
            ccFeaturedProducts.Name = name + i;
            ccFeaturedProducts.ccrz__Product__c = prodId ;
            ccFeaturedProducts.ccrz__Storefront__c = storefront;
            ccFeaturedProducts.CC_Category__c = childCategory;
            ccFeaturedProducts.ccrz__Enabled__c= true;
            ccFeaturedProducts.ccrz__Type__c = 'Featured';
            lstCCFeaturedProducts.add(ccFeaturedProducts);
        }
        
        if(doInsert)
            insert lstCCFeaturedProducts ;
        return lstCCFeaturedProducts;
    }
     
    // Create CC Invoices
    public static List<ccrz__E_Invoice__c> createCCInvoices(Integer numToCreate, Id orderId, Id contactId, String status, String storefront, Boolean doInsert){
        List<ccrz__E_Invoice__c> lstCCInvoices = new List<ccrz__E_Invoice__c>();
        for(Integer i=0; i<numToCreate; i++){
            ccrz__E_Invoice__c ccInvoices = new ccrz__E_Invoice__c();
            ccInvoices.ccrz__CCOrder__c = orderId;
            ccInvoices.ccrz__Contact__c = contactId;
            ccInvoices.ccrz__CurrencyCode__c = 'USD';
            ccInvoices.ccrz__Status__c = status;
            ccInvoices.ccrz__Storefront__c = storefront;
            ccInvoices.ccrz__DateIssued__c = System.today().addMonths(2);
            ccInvoices.ccrz__OriginalAmount__c = 200;
            ccInvoices.ccrz__Terms__c = 'TestDataTerms';
            lstCCInvoices.add(ccInvoices);
        }
        
        if(doInsert)
            insert lstCCInvoices;
        return lstCCInvoices;
    }
    
    //Added by Neha Mehta
    public static ccrz__E_TransactionPayment__c createTransactionPayment(Id odr,Boolean doInsert){
    ccrz__E_TransactionPayment__c transPayment=new ccrz__E_TransactionPayment__c();
   // transPayment.ccrz__InvoiceAppliedTo__c=invoice.id;
    transPayment.ccrz__CCOrder__c=odr;
    if(doInsert)
            insert transPayment;
      return transPayment;
    }
    // Code Start for MP-862
    public static ccrz__E_ContactAddr__c createContactAddress(Id accountId,Boolean doInsert){
    ccrz__E_ContactAddr__c  conAddrs=new ccrz__E_ContactAddr__c ();
    conAddrs.ccrz__FirstName__c = 'STANADYNE (CHANGSHU)';
    conAddrs.ccrz__LastName__c = 'CORPORATION';
    conAddrs.ccrz__AddressFirstline__c = '155#HUANGSHI ROAD,SOUTHEAST DEVELOPMENT ZONE';
    conAddrs.ccrz__AddressSecondline__c = 'TEST22';
    conAddrs.ccrz__AddressThirdline__c = 'TEST22';
    conAddrs.Account__c = accountId;
    conAddrs.Bolt_Active__c = true;
    conAddrs.BOLT_Operating_Unit__c = 'CN CFS Wuhan 745';
    conAddrs.Bolt_Site__c = true;
    conAddrs.ccrz__City__c = 'CHANGSHU';
    conAddrs.ccrz__ContactAddrId__c = '41252';
    //conAddrs.ccrz__Country__c = 
    conAddrs.ccrz__CountryISOCode__c = 'CN';
    conAddrs.ccrz__PostalCode__c = 'TEST22';
    conAddrs.Site_Use_Status__c = true;
    //conAddrs.ccrz__State__c = 
    conAddrs.ccrz__StateISOCode__c = 'TEST22';
    conAddrs.ccrz__Partner_Id__c = '357915';
    
    if(doInsert)
            insert conAddrs;
      return conAddrs;
    }
    public static ccrz__E_Subscription__c createSubscription(Id accountId,Id prodId,Id ccOrderId, Id ccOrderItemId,String status,Boolean doInsert){
    ccrz__E_Subscription__c Sub=new ccrz__E_Subscription__c();
        Sub.ccrz__Sequence__c=3;
        Sub.ccrz__Storefront__c='SoftwareStore';
        Sub.ccrz__SubscriptionStartDate__c=System.now().adddays(-2);
        Sub.OSM_Subscription_End_Date__c=System.now().adddays(5);
        Sub.ccrz__SubscriptionStatus__c= status;
        Sub.ccrz__InstallmentLastDate__c=System.now();
        Sub.ccrz__CCOrder__c=ccOrderId;
        Sub.ccrz__CCOrderItem__c=ccOrderItemId;
        Sub.OSM_Free_Trial__c=false;
        Sub.ccrz__SubscriptionProduct__c=prodId;
        Sub.ccrz__RecurringPrice__c = 200;
        Sub.ccrz__OrderLastDate__c = System.now() + 10;
        Sub.ccrz__CurrencyISOCode__c = 'USD';
        Sub.ccrz__Quantity__c = 3;
        Sub.ccrz__Account__c = accountId;
        Sub.Subsequent_Next_Invoice_Due_Dt__c = System.now() + 15;
        Sub.Subsequent_Next_Invoice_Generation_Dt__c = System.now() + 15;
         if(doInsert)
            insert Sub;
      return Sub;
    }
    
    //Updated for User Story - 883
    public static ccrz__E_AccountGroup__c inertAccountGroup() {
        ccrz__E_AccountGroup__c accGrp = new ccrz__E_AccountGroup__c();
        accGrp.Name = 'US/CAN_EBU_SIR_ACCGRP';
        insert accGrp ;
        return accGrp;
    }

    public static Account inertPortalAccountUnderGroup( String groupId ) {
        Account portalAccount2 = new Account();
        portalAccount2.Name = 'TestAccount2';
        portalAccount2.OwnerId = UserInfo.getUserId();
        portalAccount2.OSM_Preferred_Billing_Frequency_Lock__c=false;
        portalAccount2.BMS_Customer_ID__c='1234';
        portalAccount2.OSM_Preferred_Payment_Method__c='cc';
        portalAccount2.OSM_Preferred_Payment_IsBolt_PO__c=false;
        portalAccount2.ccrz__E_AccountGroup__c=groupId;
        insert portalAccount2;
        return portalAccount2;
    }

    public static Contact inertContact( String accountId ) {
        Contact contact1 = new Contact();
        contact1.FirstName = 'Test';
        contact1.Lastname = 'McTesty';
        contact1.IAM_Contact_Status__c='Pending';
        contact1.Username__c = 'testUserName9980@gmail.com';
        contact1.AccountId = accountId;
        contact1.Email ='test@test.com';
        insert contact1;
        return contact1;
    }
	
    public static Contact inertActiveContact( String accountId ) {
        Contact con = new Contact();
        con.FirstName = 'Test';
        con.Lastname = 'McTesty';
        con.AccountId = accountId;
        con.IAM_Contact_Status__c = 'Active';
        con.Username__c='Test666uni12'+'test@test.com';
        con.Email = 'test' + 'test@test.com';
        insert con;
        return con;
    }

    public static ccrz__E_Product__c insertProduct() {
        ccrz__E_Product__c prod = new ccrz__E_Product__c();
        prod.name = 'Connected Advisor';
        prod.ccrz__SKU__c = 'INS-Pro-P-02300';
        prod.ccrz__Quantityperunit__c = 3343;
        prod.ccrz__StartDate__c = system.today();
        prod.ccrz__EndDate__c = system.today()+1;
        prod.ccrz__ShortDesc__c = 'testing';
        insert prod;
        return prod;
    }

    public static List<ccrz__E_Order__c> insertOrderList() {
        List<ccrz__E_Order__c> ordList = new List<ccrz__E_Order__c>();
        ccrz__E_Order__c ord = new ccrz__E_Order__c();
        //ord.ccrz__TotalAmount__c = 20;
        ord.ccrz__OrderStatus__c = 'Order Submitted' ;
        ord.ByPassFlow__c = true;
        ordList.add(ord);
        insert ordList;
        return ordList;
    }
    
    public static ccrz__E_Order__c insertOrder( String contactId ) {
        ccrz__E_Order__c order = new ccrz__E_Order__c();
        order.ccrz__Contact__c=contactId;
        order.Activation_Key_Failure_Mail_Sent__c=false;
        order.ByPassFlow__c=true;
        insert order;
        return order;
    }

    public static List<ccrz__E_OrderItem__c> insertOrderItemList( List<ccrz__E_Order__c> ordList, ccrz__E_Product__c prod ) {
        List<ccrz__E_OrderItem__c> ordItemLst = new List<ccrz__E_OrderItem__c>();

        if( ordList != null && ordList.size() > 0 ) {
            for( ccrz__E_Order__c ord : ordList ) {
                ccrz__E_OrderItem__c orderItem = new ccrz__E_OrderItem__c();
                orderItem.ccrz__Order__c = ord.Id; 
                orderItem.ccrz__Price__c = 50.00;
                orderItem.OMS_Item_ID__c='1234';
                orderItem.OSM_Tool_Instance_Key__c='123456';
                orderItem.OMS_Instance_ID__c='F159DF1D';
                orderItem.OMS_Product__c=true; // Updated for US-867
                orderItem.OrderItemConfirmationMailSent__c=false;
                orderItem.ccrz__Quantity__c = 1;
                orderItem.ccrz__SubAmount__c = 50.00;
                orderItem.ccrz__Product__c=prod.id;
                orderItem.ccrz__DisplayProduct__c=prod.id;
                orderItem.OMS_Product__c=true;
                orderItem.OMS_Order_ID__c = '123';
                orderItem.isRenew__c=false;
                orderItem.OSM_Is_Refund_Intercompany_Call_Done__c = false;
                ordItemLst.add(orderItem);
            }
        }
        
        insert ordItemLst;
        return ordItemLst;
    }
    
    public static List<ccrz__E_OrderItem__c> insertChildOrderItemList( List<ccrz__E_Order__c> ordList, ccrz__E_Product__c prod, String orderItemId ) {
        List<ccrz__E_OrderItem__c> ordItemLst = new List<ccrz__E_OrderItem__c>();

        if( ordList != null && ordList.size() > 0 ) {
            for( ccrz__E_Order__c ord : ordList ) {
                ccrz__E_OrderItem__c orderItem = new ccrz__E_OrderItem__c();
                orderItem.ccrz__ParentOrderItem__c = orderItemId;
                orderItem.ccrz__Order__c = ord.Id; 
                orderItem.ccrz__Price__c = 50.00;
                orderItem.OMS_Item_ID__c='1234';
                orderItem.OrderItemConfirmationMailSent__c=false;
                orderItem.OSM_Tool_Instance_Key__c='123456';
                orderItem.OMS_Instance_ID__c='F159DF1D';
                orderItem.OMS_Product__c=true;
                //orderItem.OMS_Activation_Key__c='C8QV7BPP1BJ2';
                orderItem.ccrz__Quantity__c = 1;
                orderItem.ccrz__SubAmount__c = 50.00;
                orderItem.ccrz__Product__c=prod.id;
                orderItem.ccrz__DisplayProduct__c=prod.id;
                orderItem.OMS_Product__c=true;
                orderItem.OMS_Order_ID__c = '123';
                orderItem.isRenew__c=false;
                ordItemLst.add(orderItem);
            }
        }
        
        insert ordItemLst;
        return ordItemLst;
    }

    public static List<ccrz__E_Subscription__c> insertSubscriptionList( List<ccrz__E_OrderItem__c> ordItemLst, ccrz__E_Product__c prod ) {
        
        List<ccrz__E_Subscription__c> subList = new List<ccrz__E_Subscription__c>();

        if( ordItemLst != null && ordItemLst.size() > 0 ) {
            for( ccrz__E_OrderItem__c ord : ordItemLst ) {
            ccrz__E_Subscription__c sub = new ccrz__E_Subscription__c();
            sub.OSM_Display_Product__c = prod.id;
            sub.ccrz__SubscriptionProduct__c = prod.id;
            sub.ccrz__Quantity__c = 10;
            sub.ccrz__Sequence__c = 2;
            //sub.ccrz__SPT__c = spt.Billing_Display_Name__c;
            sub.ccrz__Storefront__c = 'SoftwareStore';
            sub.ccrz__SubscriptionStartDate__c  = system.today();
            sub.ccrz__SubscriptionStatus__c = 'Active';
            sub.ccrz__CCOrderItem__c = ord.Id;
            sub.OSM_Subscription_End_Date__c = system.now()+2;
            //sub.OSM_Free_Trial__c =true;
            //sub.OSM_Display_Product__r.ccrz__ShortDesc__c = 'test description';
            subList.add(sub);
            }
        }
        
        insert subList;
        return subList;
    }

    public static List<ccrz__E_RequestForQuote__c> insertRequestQuote( ccrz__E_Product__c prod ) {
        List<ccrz__E_RequestForQuote__c> quoteList = new List<ccrz__E_RequestForQuote__c>();
        ccrz__E_RequestForQuote__c req = new ccrz__E_RequestForQuote__c();
        //req.ccrz__Account__c = objResponseProductSetup.account.id;
        req.ccrz__Storefront__c = 'SoftwareStore';
        req.Display_Product__c = prod.id;
        req.Status__c = 'Requested';
        req.Expired_Date__c = system.today();
        req.Quantity__c = 2;
        //req.CC_Product__c = objResponseProductSetup.compositeProduct.id;
        quoteList.add(req);
        insert quoteList;
        return quoteList;
    }

    public static List<ccrz__E_ProductMedia__c> insertProductMediaList( List<ccrz__E_RequestForQuote__c> quoteList ) {

        list<ccrz__E_ProductMedia__c> mlist = new list<ccrz__E_ProductMedia__c>(); 

        if( quoteList != null && quoteList.size() > 0 ) {
            for( ccrz__E_RequestForQuote__c qut : quoteList ) {
                ccrz__E_ProductMedia__c media = new ccrz__E_ProductMedia__c();
                media.ccrz__Product__c = qut.Display_Product__c;
                media.ccrz__MediaType__c = 'Product Image Thumbnail';
                mlist.add(media);
            }
        }
        
        insert mlist;
        return mlist;
    }

    public static ccrz__E_SubProdTerm__c insertSubProdTerm( ccrz__E_Product__c prod ) {
        ccrz__E_SubProdTerm__c spt = new ccrz__E_SubProdTerm__c();
        spt.Billing_Display_Name__c = 'Monthly';
        spt.ccrz__CCProduct__c = prod.id;
        spt.ccrz__EffectiveEnd__c = system.now();
        spt.ccrz__EffectiveStart__c = system.now()+2;
        insert spt;
        return spt;
    }

    public static List<ccrz__E_Invoice__c> insertInvoiceList( Contact contact1 ) {

        List<ccrz__E_Invoice__c> invList = new List<ccrz__E_Invoice__c>();
        ccrz__E_Invoice__c inv = new ccrz__E_Invoice__c();
        inv.BMS_InvoiceDate__c = system.today();
        inv.IntercompanyCalled__c = true;
        inv.OSM_SW_IsIntercompanyInvoice__c = true;
        inv.ccrz__Contact__c=contact1.id;
        invList.add(inv);
        insert invList;
        return invList;
    }

    public static List<ccrz__E_InvoiceItem__c> insertInvoiceItemList( List<ccrz__E_Invoice__c> invList, String orderId, String orderItemId ) {

        List<ccrz__E_InvoiceItem__c> invitemList = new list<ccrz__E_InvoiceItem__c>();

        if( invList != null && invList.size() > 0 ) {
            for( ccrz__E_Invoice__c inv : invList ) {
                ccrz__E_InvoiceItem__c invitem = new ccrz__E_InvoiceItem__c();
                invitem.ccrz__Invoice__c = invList[0].id;
                invitem.ccrz__CCOrder__c = orderId;
                invitem.ccrz__CCOrderItem__c = orderItemId;
                invitem.OSM_Bypass_Flow__c=true;
                invitemList.add(invitem);
            }
        }
        
        insert invitemList;
        return invitemList;
    }

    public static OSM_Order_Item_License__c insertOILParentActivationKey( String orderItemId ) {

        OSM_Order_Item_License__c ParentActivationKey = new OSM_Order_Item_License__c();
        ParentActivationKey.Activation_Key__c         = 'testActivationKey';
        ParentActivationKey.CC_Order_Item__c          = orderItemId;
        ParentActivationKey.Parent_Activation_Key__c  = null;
        ParentActivationKey.OMS_Item_Id__c            = '1234';
        ParentActivationKey.Tool_Instance_Key__c      = '12345';
        ParentActivationKey.Status__c                 = 'Revoke Intitiated';
        ParentActivationKey.type__c                   = 'Tool instance';
        insert ParentActivationKey;
        return ParentActivationKey;
    }

    public static OSM_Order_Item_License__c insertOrderItemLicense( String orderItemId, String parentActivationKeyId ) {

        OSM_Order_Item_License__c orderItemLicense2 = new OSM_Order_Item_License__c();
        orderItemLicense2.Activation_Key__c         = 'testActivationKey';
        orderItemLicense2.CC_Order_Item__c          = orderItemId;
        orderItemLicense2.Parent_Activation_Key__c  = parentActivationKeyId;
        orderItemLicense2.OMS_Item_Id__c            = '1234';
        orderItemLicense2.Tool_Instance_Key__c      = '12345';
        orderItemLicense2.Status__c                 = 'Revoked/ReIssue';
        orderItemLicense2.type__c                   = 'Tool instance';
        insert orderItemLicense2;
        return orderItemLicense2;
    }

    public static OSM_Order_Item_License__c insertNewOILParentActivationKey( String orderItemId ) {

        OSM_Order_Item_License__c license = new OSM_Order_Item_License__c();
        license.CC_Order_Item__c=orderItemId;
        license.Status__c ='New';
        license.OMS_Item_Id__c='1234';
        license.Tool_Instance_Key__c='123456';
        license.Activation_Key__c='C8QV7BPP1BJ2';
        insert license;
        return license;
    }

    public static OSM_Order_Item_License__c insertNewOrderItemLicense( String orderItemId, String parentActivationKeyId ) {

        OSM_Order_Item_License__c licenseChild = new OSM_Order_Item_License__c();
        licenseChild.CC_Order_Item__c=orderItemId;
        licenseChild.Status__c ='New';
        licenseChild.OMS_Item_Id__c='1234';
        licenseChild.Tool_Instance_Key__c='123456';
        licenseChild.Parent_Activation_Key__c=parentActivationKeyId;
        licenseChild.Activation_Key__c='C8QV7BPP1BJ2';
        insert licenseChild;
        return licenseChild;
    }

    public static OSM_Integration_Log__c insertIntegrationLog( String invoiceId ) {

        OSM_Integration_Log__c objIntLog = new OSM_Integration_Log__c();
        objIntLog.Service_Name__c = 'test';
        objIntLog.Status__c = 'Failure';
        objIntLog.Target__c = 'OSM';
        objIntLog.Invoice__c = invoiceId;
        insert objIntLog;
        return objIntLog;
    }

    public static Account insertAccount(){
        Account testaccount = new Account();
        testAccount.Name = 'testacc';
        testAccount.BillingStreet = 'Street';
        testAccount.BillingCity = 'City';
        testAccount.BillingState = '';
        testAccount.BOLT_Account_Number__c = '999';
        testAccount.BillingPostalCode = '11000';
        testAccount.BillingCountry = 'United States';
        testAccount.CMI_Region__c = 'India';
        testAccount.CSS_Locale__c = 'English(India)';         
        testAccount.RecordTypeId = OSM_TestDataCreationUtility.getAccountRecordTypeID();
        testAccount.OwnerId = OSM_TestDataCreationUtility.getSystemAdministratorID();
        testAccount.CSS_Timezone__c = '(GMT+05:30) India Standard Time (Asia/Kolkata)';
        insert testAccount;
        return testAccount;
    }

    public static ccrz__E_Spec__c insertSpec(){
        ccrz__E_Spec__c spec=new ccrz__E_Spec__c();
        spec.name='CA Base';
        spec.imageText__c='test';
        spec.ccrz__Sequence__c =500;
        insert spec;
        return spec;
    }

    public static List<ccrz__E_ProductMedia__c> insertProductMedia( String prodId ){
        List<ccrz__E_ProductMedia__c> mlist = new list<ccrz__E_ProductMedia__c>(); 
        ccrz__E_ProductMedia__c media = new ccrz__E_ProductMedia__c();
        media.ccrz__MediaType__c = 'Product Image Thumbnail';
        media.ccrz__Product__c = prodId;
        mlist.add(media);
        insert mlist;
        return mlist;
    }

    public static Attachment insertAttachment( String prodMediaId ){
        Attachment att = new Attachment();
        att.name = 'MediaAttachment';
        att.parentId = prodMediaId;
        att.Body = Blob.valueof('test');
        insert att;
        return att;
    }

    public static ccrz__E_RelatedProduct__c insertRelatedProduct( String prodId ){
        ccrz__E_RelatedProduct__c rp = new ccrz__E_RelatedProduct__c();
        rp.ccrz__Product__c = prodId;
        rp.ccrz__RelatedProduct__c=prodId;
        rp.ccrz__RelatedProductType__c='Accessories';
        rp.ccrz__EndDate__c=System.today() +1;
        insert rp;
        return rp;
    }

    public static ccrz__E_Subscription__c insertSingleSubscription( String prodId, String subProdTerm, String accountId ){
        ccrz__E_Subscription__c Sub = new ccrz__E_Subscription__c();
        Sub.ccrz__Sequence__c=3;
        Sub.ccrz__Storefront__c='SoftwareStore';
        Sub.ccrz__SubscriptionStartDate__c=System.now().adddays(-2);
        Sub.OSM_Subscription_End_Date__c=System.now().adddays(5);
        Sub.ccrz__SubscriptionStatus__c= 'Active';
        Sub.ccrz__InstallmentLastDate__c=System.now();
        Sub.ccrz__SPT__c=subProdTerm;
        Sub.OSM_Free_Trial__c=false;
        Sub.ccrz__SubscriptionProduct__c = prodId;
        Sub.ccrz__RecurringPrice__c = 200;
        Sub.ccrz__OrderLastDate__c = System.now() + 10;
        Sub.ccrz__CurrencyISOCode__c = 'USD';
        Sub.ccrz__Quantity__c = 3;
        Sub.ccrz__Account__c = accountId;
        Sub.Subsequent_Next_Invoice_Due_Dt__c = System.now() + 15;
        Sub.Subsequent_Next_Invoice_Generation_Dt__c = System.now() + 15;
        Sub.OSM_Display_Product__c=prodId;
        insert Sub;
        return Sub;
    }

    public static ccrz__E_CompositeProduct__c insertCompositeProduct( String prodId ){
        ccrz__E_CompositeProduct__c compprod = new ccrz__E_CompositeProduct__c();
        compprod.ccrz__Component__c = prodId;
        compprod.ccrz__Composite__c = prodId;
        insert compprod;
        return compprod;
    }

    public static OSM_Maintenance_Message__c insertMaintenanceMessage( ){
        OSM_Maintenance_Message__c om=new OSM_Maintenance_Message__c();
        om.Start_Date__c=System.today();
        om.End_Date__c=System.today()+2;
        om.Start_Time__c=Time.newInstance(1, 0, 0, 0);
        om.End_Time__c=Time.newInstance(2, 0, 0, 0);
        om.System_Available__c=false;
        insert om;
        return om;
    }

}