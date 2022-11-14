/*
 * This class provides utility methods used by test classes.  Each storefront should have
 * its own extension for this class.  The constructor should not be overridden unless
 * the overriding class calls the super constructor.  Extending classes must implement the
 * configureSettings() method.
 * 
 * The following is an example for a fictitious storefront
 * named "CloudBurst". Note the abbrevation for "CloudBurst" used here is "CB" in the class
 * name.
 *
 * public without sharing class CCCBTestUtil extends OSM_TestUtil {
 *   public override void configureSettings() {
 *      STOREFRONT = 'DefaultStore';
 *      COMMUNITY_PROFILE = 'CloudCraze Customer Community User';
 *      GUEST_USER_PROFILE = 'CloudBurst Customer Community Profile';
 *      DEFAULT_PRICE_METHOD = OSM_TestUtilSettings.PRICE_METHOD_BEST;
 *      COMMUNITY_NAME = 'CloudBurst Customer Community';
 *   }
 * }
 * 
*/
public virtual without sharing class OSM_TestUtil {

    /* 
    *   These settings must be set by the extending class.
    */
    // The CloudCraze Storefront name. Case-sensitive
    public String STOREFRONT {get;set;}

    // The Profile name for the authenticated user
    public String COMMUNITY_PROFILE {get;set;}

    // The Profile name for the anonymous user.
    public String GUEST_USER_PROFILE {get;set;}

    // The name of the Community
    public String COMMUNITY_NAME {get;set;}

    // The username of the site guest user. This is in email format.
    public String GUEST_USERNAME {get;set;}

    // The default pricing method to use
    public String DEFAULT_PRICE_METHOD {get;set;}

    // A unique key used to build external ids
    public String KEY {get; set;}

    public OSM_TestUtil(){
        System.assert(Test.isRunningTest(), 'OSM_TestUtil may only be used by test classes.');

        configureSettings();

        GUEST_USERNAME = getGuestUsername();
    }

    public virtual void configureSettings(){
        // These settings are configured in `, or in extensions for this class
        COMMUNITY_PROFILE = OSM_TestUtilSettings.DEFAULT_COMMUNITY_PROFILE;
        GUEST_USER_PROFILE = OSM_TestUtilSettings.DEFAULT_GUEST_USER_PROFILE;
        COMMUNITY_NAME = OSM_TestUtilSettings.DEFAULT_COMMUNITY_NAME;
        STOREFRONT = OSM_TestUtilSettings.DEFAULT_STOREFRONT;
        DEFAULT_PRICE_METHOD = OSM_TestUtilSettings.DEFAULT_PRICE_METHOD;
        KEY = String.valueOf(DateTime.now().getTime());
    }

    // This method must return the Name field of the Site Guest User 
    // for the community. If the 
    public String getGuestUsername(){
        User u = [
            SELECT
                Username
            FROM
                User
            WHERE
                Name = :COMMUNITY_NAME + ' Site Guest User'
            LIMIT
                1
        ];
        return u.Username;
    }

    // public virtual CCAviStorefrontSettings__c createStorefrontSettings(){
    //     CCAviStorefrontSettings__c settings = new CCAviStorefrontSettings__c(
    //             Name = STOREFRONT
    //     );
    //     return settings;
    // } 
    
    public Profile getCustomerCommunityProfile(){
        Profile p;
        try {
        p = [
            SELECT
                Id
                ,Name
            FROM
                Profile
            WHERE
                Name = :COMMUNITY_PROFILE
            LIMIT
            1
        ];
        }catch(Exception e){
            System.assertNotEquals(null, p, 'You must create a profile named ' + COMMUNITY_PROFILE + ' or modify this test case.');
        }
        return p;
    }

    public virtual ccrz__E_AccountGroup__c createAccountGroup(String groupName, String priceMethod){
        if(priceMethod == null){
            priceMethod = DEFAULT_PRICE_METHOD;
        }

        ccrz__E_AccountGroup__c actGrp = new ccrz__E_AccountGroup__c(
            Name = groupName,
            ccrz__PriceListSelectionMethod__c = priceMethod
        );
        return actGrp;
    }

    public virtual Account createAccount(ccrz__E_AccountGroup__c accountGroup){
        Account a1 = new Account  (Name='Test Account');
        a1.BillingStreet = '33 N LaSalle';
        a1.BillingCity = 'Chicago';
        a1.BillingState = 'Illinois';
        a1.BillingCountry = 'United States';
        a1.BillingPostalCode = '60602';
        a1.ShippingStreet = '33 N LaSalle';
        a1.ShippingCity = 'Chicago';
        a1.ShippingState = 'Illinois';
        a1.ShippingCountry = 'United States';
        a1.ShippingPostalCode = '60602';
        if(accountGroup != null){
            a1.ccrz__E_AccountGroup__c = accountGroup.Id;
        }
        return a1;
    }   

    public virtual ccrz__E_PriceList__c createPriceList(String plName, String storefront){
        ccrz__E_PriceList__c pl = new ccrz__E_PriceList__c(
                Name = plName,
                ccrz__CurrencyISOCode__c = 'USD',
                ccrz__Enabled__c = true,
                ccrz__StartDate__c = Date.today(),
                ccrz__EndDate__c = Date.today().addDays(30),
                ccrz__Storefront__c = storefront
        );
        return pl;
    }   

    public virtual ccrz__E_AccountGroupPriceList__c createAccountGroupPriceList(ccrz__E_AccountGroup__c accountGroup, ccrz__E_Pricelist__c priceList){
        ccrz__E_AccountGroupPriceList__c agpl = new ccrz__E_AccountGroupPriceList__c (
            ccrz__AccountGroup__c = accountGroup.Id,
            ccrz__Pricelist__c = priceList.Id,
            ccrz__Sequence__c = 100,
            ccrz__Enable__c = true,
            ccrz__StartDate__c = Date.today(),
            ccrz__EndDate__c = Date.today().addDays(30)
        );
        return agpl;
    }

    public virtual List<ccrz__E_PriceListItem__c> createPriceListItems(List<ccrz__E_Product__c> products, ccrz__E_PriceList__c priceList){
        List<ccrz__E_PriceListItem__c> pliList = new List<ccrz__E_PriceListItem__c>();
        for(ccrz__E_Product__c prod :products){
            ccrz__E_PriceListItem__c item = new ccrz__E_PriceListItem__c(
                    ccrz__EndDate__c = Date.today().addDays(30),
                    ccrz__Price__c = 10,
                    ccrz__PriceList__c = priceList.Id,
                    ccrz__Product__c = prod.Id,
                    ccrz__StartDate__c = Date.today(),
                    ccrz__UnitOfMeasure__c = 'Each'
            );
            pliList.add(item);
        }
        return pliList;
    }

    public virtual Contact createContact(Account a, String emailAddress){
        Contact con = new Contact(
            FirstName='Test',
            Lastname='User',
            Accountid=a.id,
            Email=emailAddress
        );
        return con;
    }

    public virtual User createUser(Profile p, Contact c, String username, String emailAddress, String firstName, String lastName, String alias){
        User u = new User(
            FirstName         = firstName,
            LastName          = lastName,
            Email             = emailAddress,
            Alias             = alias,
            Username          = username,
            LocaleSidKey      = 'en_US',
            TimeZoneSidKey    = 'GMT',
            ProfileID         = p.id,
            LanguageLocaleKey = 'en_US',
            EmailEncodingKey  = 'UTF-8',
            ContactId         = c.id
        );
        return u;
    }

    public virtual ccrz__E_Product__c createProduct(String name, String sku, String productType, String storefront){
        if(productType == null){
            productType = 'Product';
        }
        // Create Product
        ccrz__E_Product__c prod = new ccrz__E_Product__c();
        prod.Name = name;
        prod.ccrz__SKU__c = sku;
        prod.ccrz__ProductType__c = productType;
        prod.ccrz__ProductStatus__c = 'Released';
        prod.ccrz__Storefront__c = storefront;
        return prod;
    }

    public virtual ccrz__E_Product__c createProduct(String name, String sku, String storefront){
        return createProduct(name, sku, 'Product', storefront);
    }

    public virtual ccrz__E_Product__c createProduct(String name, String sku){
        return createProduct(name, sku, STOREFRONT);
    }

    public virtual ccrz__E_Spec__c createSpec(String name, String description, String displayName,  Integer sequence,  String specGroup, Boolean isVisible){
        ccrz__E_Spec__c spec = new ccrz__E_Spec__c();
        spec.Name = name; 
        spec.ccrz__Desc__c = description;
        spec.ccrz__DisplayName__c = displayName; 
        spec.ccrz__IsVisibleInCatalog__c = isVisible;
        spec.ccrz__Sequence__c = sequence;
        spec.ccrz__SpecGroup__c = specGroup;
        return spec;
    }

    public virtual List<ccrz__E_ProductSpec__c> createProductSpecs(ccrz__E_Product__c product, Map<ccrz__E_Spec__c, String> specToValueMap){
        List<ccrz__E_ProductSpec__c> prodSpecList = new List<ccrz__E_ProductSpec__c>();
        ccrz__E_ProductSpec__c newProdSpec;
        for(ccrz__E_Spec__c theSpec :specToValueMap.keySet()){
            newProdSpec = new ccrz__E_ProductSpec__c(
                ccrz__Product__c = product.Id,
                ccrz__Spec__c = theSpec.Id,
                ccrz__SpecValue__c = specToValueMap.get(theSpec)
            );
            prodSpecList.add(newProdSpec);
        }
        return prodSpecList;
    }
    
    public static ccrz__E_ProductMedia__c createProductMedia(Id parentId, Boolean enabled, String description, String alt_message, String media_type, String product_media_source){
            ccrz__E_ProductMedia__c pm = new ccrz__E_ProductMedia__c  ();

            if(parentId != null){
                pm.ccrz__Product__c = parentId;
                pm.ccrz__AltMessage__c = alt_message;
                pm.ccrz__Enabled__c = enabled;
                pm.ccrz__MediaType__c = media_type;
                pm.ccrz__ProductMediaSource__c = product_media_source;
                pm.ccrz__ProductDescription__c = description;
            }
            return pm;
    }

    // Create contact address - owner is the portal user or guest (Site Guest User)
    // cart and order link to CC Contact Address for billto/shipto.
    public virtual ccrz__E_ContactAddr__c createContactAddress(User portalUser, String line1, String line2, String line3, String city, String state, String country, String postalCode ){
        ccrz__E_ContactAddr__c addr = new ccrz__E_ContactAddr__c(
            ownerId = portalUser.Id,
            ccrz__AddressFirstline__c = line1,
            ccrz__AddressSecondline__c = line2,
            ccrz__AddressThirdline__c = line3,
            ccrz__City__c = city,
            ccrz__State__c = state,
            ccrz__Country__c = country,
            ccrz__PostalCode__c = postalCode
        );
        return addr;
    }

    public enum ADDRESS_TYPE {BILLING,SHIPPING}
    public static final Map<ADDRESS_TYPE, String> ADDRESS_TYPE_MAP = new Map<ADDRESS_TYPE, String>{
        ADDRESS_TYPE.BILLING => 'Billing',
        ADDRESS_TYPE.SHIPPING => 'Shipping'
    };

    public virtual ccrz__E_AccountAddressBook__c createAccountAddressBook(Account acct, ADDRESS_TYPE addrType, ccrz__E_ContactAddr__c contactAddr, User portalUser, Boolean isDefault){
        String addressType = ADDRESS_TYPE_MAP.get(addrType);

        ccrz__E_AccountAddressBook__c addrBook = new ccrz__E_AccountAddressBook__c(
            ccrz__Account__c = acct.Id,
            ccrz__AccountId__c = acct.Id,
            ccrz__AddressType__c = addressType, // Billing/Shipping
            ccrz__E_ContactAddress__c = contactAddr.Id,
            ccrz__Default__c = isDefault,
            ccrz__Owner__c = portalUser.Id
        );
        return addrBook;
    }   

    // Type = Cart/Wishlist
    public virtual ccrz__E_Cart__c createCart(Account acct, ccrz__E_ContactAddr__c billToAddr, ccrz__E_ContactAddr__c shipToAddr, User portalUser, Contact portalContact, String cartType, String storefront){
        String cartName = 'Shopping Cart';

        ccrz__E_Cart__c cart = new ccrz__E_Cart__c(
            ccrz__Account__c = acct.Id,
            ccrz__ActiveCart__c = true,
            ccrz__BillTo__c = billToAddr.Id,
            ccrz__CartStatus__c = 'Open',
            ccrz__CartType__c = cartType,
            ccrz__Contact__c = portalContact.Id,
            ccrz__BuyerFirstName__c = portalContact.Firstname,
            ccrz__BuyerLastName__c = portalContact.Lastname,
            ccrz__Name__c = cartName,
            ccrz__ShipTo__c = shipToAddr.Id,
            ccrz__Storefront__c = storefront,
            ccrz__CurrencyISOCode__c = 'USD',
            ccrz__User__c = portalUser.Id,
            ccrz__CartId__c = 'Cart' + KEY,
            ccrz__EncryptedId__c = 'enc123'
        );

        return cart;
    }

    public virtual ccrz__E_CartItem__c createCartItem(ccrz__E_Cart__c cart, Decimal price, Decimal quantity, ccrz__E_Product__c product, ccrz__E_CartItem__c parentCartItem){
        ccrz__E_CartItem__c cartItem = new ccrz__E_CartItem__c(
            ccrz__Cart__c = cart.Id,
            ccrz__Price__c = price,
            ccrz__OriginalItemPrice__c = price,
            ccrz__Quantity__c = quantity,
            ccrz__SubAmount__c = price * quantity,  
            ccrz__CartItemType__c = product.ccrz__ProductType__c, // Major/Minor/Coupon
            ccrz__ProductType__c = product.ccrz__ProductType__c, // Major/Minor/Coupon
            ccrz__Product__c = product.Id,
            ccrz__UnitOfMeasure__c = 'Each',
            ccrz__ItemStatus__c = 'Available',
            ccrz__CartItemId__c = 'CartItem' + KEY
        );
        if(parentCartItem != null){
            cartItem.ccrz__ParentCartItem__c = parentCartItem.Id;
        }
        return cartItem;
    }

    public virtual ccrz__E_Category__c createCategory(String categoryId) {
        ccrz__E_Category__c category = new ccrz__E_Category__c(
            ccrz__CategoryID__c = categoryId
        );
        return category;
    }

    public virtual ccrz__E_ProductCategory__c createProductCategory(ccrz__E_Product__c product, String productCategoryId, ccrz__E_Category__c category) {
        ccrz__E_ProductCategory__c productCategory = new ccrz__E_ProductCategory__c (
            ccrz__Category__c = category.id,
            ccrz__Product__c = product.id,
            ccrz__ProductCategoryId__c = productCategoryId
        );
        return productCategory;
    }


    public virtual ccrz__E_Order__c createOrder(Id cartId, Id accountId, Id contactId, Id ownerId, Id shipToId, Id billToId){
        ccrz__E_Order__c theOrder = new ccrz__E_Order__c();
        theOrder.ccrz__OriginatedCart__c = cartId;
        theOrder.ccrz__Account__c = accountId;
        theOrder.ccrz__Contact__c = contactId;
        theOrder.OwnerId = ownerId;
        theOrder.ccrz__ShipTo__c = shipToId;
        theOrder.ccrz__BillTo__c = billToId;
        theOrder.ccrz__EncryptedId__c = 'encOrder123';
        theOrder.ccrz__Storefront__c = STOREFRONT;
        return theOrder;

    }

    public static ccrz__E_OrderItem__c createOrderItem(Id orderId, String orderItemId, String lineType, Id productId, Id parentOrderItemId, Id parentProductId, Decimal price, Decimal quantity, Decimal subAmount){
        ccrz__E_OrderItem__c oi = new ccrz__E_OrderItem__c();
        oi.ccrz__Order__c = orderId;
        // oi.ccrz__OrderItemId__c = orderItemId;
        oi.ccrz__OrderLineType__c = lineType;
        oi.ccrz__Product__c = productId;
        oi.ccrz__ParentOrderItem__c = parentOrderItemId;
        oi.ccrz__ParentProduct__c = parentProductId;
        oi.ccrz__Price__c = price;
        oi.ccrz__Quantity__c = quantity;
        oi.ccrz__SubAmount__c = subAmount;
        return oi;
    }

    public virtual ccrz__E_TransactionPayment__c createTransactionPayment(Id orderId, String uid){
        ccrz__E_TransactionPayment__c tp = new ccrz__E_TransactionPayment__c();
        tp.ccrz__CCOrder__c = orderId;
        tp.ccrz__TransactionPaymentId__c = uid;
        tp.ccrz__Amount__c = 1.0;
        tp.ccrz__AccountNumber__c = 'abc';
        tp.ccrz__AccountType__c = 'abc';
        tp.ccrz__TransactionCode__c = 'tcode';
        tp.ccrz__ExpirationMonth__c = 12;
        tp.ccrz__ExpirationYear__c = 2030;

        return tp;
    }   


    /**
    * Initialize test data and return a map of objects created. In general, do not override this method
    * if you can override the create*() methods instead.
    *
    * @return Map of objects inserted
    */
    public virtual Map<String, Object> initData() {

        // CCAviStorefrontSettings__c settings = createStorefrontSettings();
        // insert settings;

        Profile userProfile = getCustomerCommunityProfile();

        /*
        * Account Group
        */
        ccrz__E_AccountGroup__c userAccountGroup = createAccountGroup('accountGroup', null);
        insert userAccountGroup;

        /*
        * Account
        */
        Account userAccount = createAccount(userAccountGroup);
        insert userAccount;

        /*
        * Contact
        */
        Contact userContact = createContact(userAccount, 'contact@email.com');
        userContact.Username__c = 'testuser@rv.com'; 
        insert userContact;

        /*
        * Portal User
        */
        Id curUserId = UserInfo.getUserId();
        User curUser = [Select Id from User where Id = :curUserId limit 1];
        User portalUser;
        List<User> user1 = new List<User>();
            user1 = [SELECT Id, Username, ContactId, ProfileId, Alias, Email, EmailEncodingKey, LastName, CommunityNickname, TimeZoneSidKey,
                                LocaleSidKey, LanguageLocaleKey FROM User WHERE ContactId =: userContact.Id];
        System.runAs(curUser){
            if(user1 != null && user1.size() > 0){
                portalUser = user1[0];
            }
            else{
                portalUser = createUser(userProfile, userContact, 'username@email.com', 'contact@email.com', 'firstName', 'lastName', 'alias');
                insert portalUser;
            }
        }

        /*
        * Contact Address
        */
        ccrz__E_ContactAddr__c address = createContactAddress(
            portalUser,
            'line1',
            'line2',
            'line3',
            'city',
            'state',
            'country',
            '11111'
        );
        insert address;

        /*
        * Account Address Book
        */
        List<ccrz__E_AccountAddressBook__c> addrBookList = new List<ccrz__E_AccountAddressBook__c>();
        ccrz__E_AccountAddressBook__c shippingAddressBook = createAccountAddressBook(userAccount,ADDRESS_TYPE.SHIPPING, address, portalUser, true);
        ccrz__E_AccountAddressBook__c billingAddressBook = createAccountAddressBook(userAccount,ADDRESS_TYPE.BILLING, address, portalUser, true);
        addrBookList.add(shippingAddressBook);
        addrBookList.add(billingAddressBook);
        insert addrBookList;

        /*
        * CCRZ Call Context
        */
        ccrz.cc_CallContext.currAccount = userAccount;
        ccrz.cc_CallContext.currAccountId = userAccount.Id;
        ccrz.cc_CallContext.currAccountGroup = userAccountGroup;
        ccrz.cc_CallContext.currUserId = portalUser.id;
        ccrz.cc_CallContext.currUser = portalUser;
        ccrz.cc_CallContext.storefront = STOREFRONT;
        ccrz.cc_CallContext.effAccountId = userAccount.Id;
        ccrz.cc_CallContext.currContact = userContact;
        ccrz.cc_CallContext.isOnBehalf = true;

        /*
        * Product
        */
        ccrz__E_Product__c product = createProduct('Product 1', 'product-01', 'Product', STOREFRONT);
        insert product;

        /*
        * Parent Product
        */
        ccrz__E_Product__c parentProduct = createProduct('Parent Product', 'product-02');
        insert parentProduct;

        List<ccrz__E_Product__c> productList = new List<ccrz__E_Product__c>();
        productList.add(product);

        /*
        * Spec
        */
        ccrz__E_Spec__c spec = createSpec('ColorRed', 'The color red', 'Red', 10,  'Color', true);
        insert spec;


        Map<ccrz__E_Spec__c, String> specToValueMap = new Map<ccrz__E_Spec__c, String>{
                spec => 'Red'
        };
        List<ccrz__E_ProductSpec__c> productSpecs = createProductSpecs(product, specToValueMap);
        insert productSpecs;

        /*
        * Category
        */
        ccrz__E_Category__c category = createCategory('300000');
        insert category;

        /*
        * Product Category
        */
        ccrz__E_ProductCategory__c productCategory = createProductCategory(product, '1001', category);
        insert productCategory;

        /*
        * Related Product Group
        */
        /*
        ccrz__E_RelatedProductGroup__c relatedProductGroup = createRelatedProductGroup('group 1', '2001');
        insert relatedProductGroup;
        */

        /*
        * Price List
        */
        ccrz__E_PriceList__c priceList = createPriceList('General', STOREFRONT);
        insert priceList;

        ccrz__E_AccountGroupPriceList__c agrpPriceList =  createAccountGroupPriceList(userAccountGroup, priceList);
        insert agrpPriceList;


        /*
        * Product Media
        */
        /*
        ccrz__E_ProductMedia__c productMedia = createProductMedia(product,'Product Image Thumbnail');
        insert productMedia;
        */

        /*
        * Attachment
        */
        /*
        Attachment attachment = createAttachment('Product Image', productMedia);
        insert attachment;
        */

        /*
        * Price List Item
        */
        List<ccrz__E_PriceListItem__c> priceListItems = createPriceListItems(productList, priceList);
        insert priceListItems;

        /*
        * Composite Products
        */
//        List<ccrz__E_CompositeProduct__c> compositeProducts = createCompositeProducts(productList, parentProduct, relatedProductGroup);
//        insert compositeProducts;

        /*
        * Cart
        */
        ccrz__E_Cart__c cart = createCart(userAccount, address, address, portalUser, userContact, 'Cart', STOREFRONT);
        insert cart;

        /*
        * Cart Item
        * - Normal Cart
        */
        ccrz__E_CartItem__c cartItem = createCartItem(cart, 9.99, 1, product, null);
        insert cartItem;

        /*
        * Order
        *
        */
        ccrz__E_Order__c theOrder = createOrder(cart.Id, userAccount.Id, userContact.Id, portalUser.Id, address.Id, address.Id);
        insert theOrder;

        /*
        * Order Item
        *
        */
        ccrz__E_OrderItem__c parentOrderItem = createOrderItem(theOrder.Id, 'oi1', 'Major', parentProduct.Id, null, null, 1.00, 1, 1.00);
        insert parentOrderItem;
        ccrz__E_OrderItem__c childOrderItem = createOrderItem(theOrder.Id, 'oi2', 'Minor', product.Id, parentOrderItem.Id, parentProduct.Id, 1.00, 1, 1.00);
        insert childOrderItem;
        List<ccrz__E_OrderItem__c> orderItems = new List<ccrz__E_OrderItem__c>();
        orderItems.add(parentOrderItem);
        orderItems.add(childOrderItem);


        /*
        ccrz__E_TransactionPayment__c tp = createTransactionPayment(theOrder.Id, 'uid');
        insert tp;
        */

        Map<String,Object> resultMap = new Map<String,Object>();
        //resultMap.put('order', theOrder);
        // resultMap.put('storefrontSettings', settings);
        resultMap.put('userProfile', userProfile);
        resultMap.put('userAccountGroup', userAccountGroup);
        resultMap.put('userAccount', userAccount);
        resultMap.put('userContact', userContact);
        resultMap.put('portalUser', portalUser);
        resultMap.put('contactAddress', address);
        resultMap.put('accountAddressBooks', addrBookList);
        resultMap.put('product', product);
        resultMap.put('parentProduct', parentProduct);
        resultMap.put('productList', productList);
        resultMap.put('spec', spec);
        resultMap.put('productSpecs', productSpecs);
        resultMap.put('category', category);
        resultMap.put('productCategory', productCategory);
        resultMap.put('priceList', priceList);
        resultMap.put('accountGroupPriceList', agrpPricelist);
        resultMap.put('priceListItems', priceListItems);
        resultMap.put('cart', cart);
        resultMap.put('cartItem', cartItem);
        resultMap.put('order', theOrder);
        resultMap.put('orderItems', orderItems);
        resultMap.put('shippingAddressBook', shippingAddressBook);
        resultMap.put('billingAddressBook', billingAddressBook);
        resultMap.put('shippingContactAddress', address);
        resultMap.put('billingContactAddress', address);

        //resultMap.put('transactionPayment', tp);

        return resultMap;
    } 

    public virtual ccrz__E_Cart__c getCart() {
        String key = 'Cart' + KEY;

        return [
            SELECT
                Id,
                ccrz__EncryptedId__c,
                ccrz__Account__c,
                ccrz__ActiveCart__c,
                ccrz__BillTo__c,
                ccrz__CartStatus__c,
                ccrz__CartType__c,
                ccrz__Contact__c,
                ccrz__BuyerFirstName__c,
                ccrz__BuyerLastName__c,
                ccrz__Name__c,
                ccrz__ShipTo__c,
                ccrz__Storefront__c,
                ccrz__CurrencyISOCode__c,
                ccrz__User__c
            FROM
                ccrz__E_Cart__c
            WHERE
                ccrz__CartId__c = :key
        ];
    }

    public virtual ccrz__E_CartItem__c getCartItem() {
        String key = 'CartItem' + KEY;
        return [
            SELECT
                Id,
                ccrz__Cart__c,
                ccrz__Price__c,
                ccrz__Quantity__c,
                ccrz__SubAmount__c,  
                ccrz__CartItemType__c,
                ccrz__ProductType__c,
                ccrz__Product__c,
                ccrz__UnitOfMeasure__c,
                ccrz__ItemStatus__c
            FROM
                ccrz__E_CartItem__c
            WHERE
                ccrz__CartItemId__c = :key
        ];
    }
    
    public virtual Account getAccount() {
        return [SELECT Id, Name FROM Account WHERE Name = 'Test Account'];
    }  

    public virtual Contact getContact() {
        return [SELECT Id, Name FROM Contact WHERE Email = 'contact@email.com'];
    }  

    public virtual User getPortalUser() {
        return [SELECT Id, Name, FirstName, LastName, Email, Username, ContactId FROM User WHERE Username = 'username@email.com'];
    } 

    public virtual ccrz__E_Order__c getOrder() {
        return [SELECT Id, Name, ccrz__EncryptedId__c FROM ccrz__E_Order__c WHERE ccrz__EncryptedId__c = 'encOrder123'];
    }

    public virtual ccrz__E_Product__c getProduct() {
        return [SELECT Id, Name, ccrz__SKU__c FROM ccrz__E_Product__c WHERE Name = 'Product 1'];
    }

            
}