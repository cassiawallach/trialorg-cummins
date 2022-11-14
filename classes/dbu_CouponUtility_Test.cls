/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 09-15-2022
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
@isTest
private class dbu_CouponUtility_Test {
    
    @isTest
    private static void getCartTotalCouponTest(){
          
        Id iamRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('IAM').getRecordTypeId();
        Id ContactRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('IAM').getRecordTypeId();
        Account createAccount= dbu_TestDataCreationUtility.createAccount(iamRecordTypeId);
        createAccount.BillingCountry = 'Canada';
        insert createAccount;
        Contact createContact= dbu_TestDataCreationUtility.createContact(createAccount, ContactRecordTypeId);
        createContact.Ecom_Email_Subscriber__c = true;
        insert createContact;
        ccrz__E_ContactAddr__c createContactAddr= dbu_TestDataCreationUtility.createContactAddr();
        createContactAddr.ccrz__Country__c='Canada';
        createContactAddr.ccrz__PostalCode__c='V4N3P8';
        insert createContactAddr;
        
        ccrz__E_Cart__c cart = dbu_CouponFactoryDataTest.createCart();
        insert cart;
        ccrz__E_Product__c productObj = dbu_FactoryDataTest.createProduct('Test',true, true, true,true);
        insert productObj;
        ccrz__E_Product__c productObj1 = dbu_FactoryDataTest.createProduct('Test product',true, true, true,true);
        productObj1.dbu_Has_Core_Child__c = true;
        productObj1.dbu_Has_Core_Charge__c = true;
        insert productObj1;
        ccrz__E_Product__c productObj2 = dbu_FactoryDataTest.createProduct('Test-product',true, true, true,true);
        insert productObj2;
        ccrz__E_CartItem__c cartItem = dbu_CouponFactoryDataTest.createCartItem(cart.Id,productObj.Id);
        insert cartItem;
        ccrz__E_CartItem__c cartItem1 = dbu_CouponFactoryDataTest.createCartItem(cart.Id,productObj1.Id);
        insert cartItem1;
        ccrz__E_CartItem__c cartItem2 = dbu_CouponFactoryDataTest.createCartItem(cart.Id,productObj2.Id);
        insert cartItem2;
        Ecom_Coupon__c coupon = dbu_CouponFactoryDataTest.createCoupon('test','Cart Total');
        coupon.Ecom_Coupon_Type__c = 'Percentage';
        insert coupon;
        Ecom_Coupon_Product__c couponProduct = dbu_CouponFactoryDataTest.createCouponProduct(coupon.Id,'Exclusion');
        couponProduct.Ecom_Source_Product__c = productObj.Id;
        insert couponProduct;
        ccrz__E_Category__c categoryObj = dbu_CouponFactoryDataTest.createCategory('Test', '900');
        insert categoryObj;
        Ecom_Coupon_Category__c couponCategory = dbu_CouponFactoryDataTest.createCouponCategory(coupon.Id,'Exclusion', categoryObj.Id);
        insert couponCategory;
        ccrz__E_ProductCategory__c productCategory = dbu_CouponFactoryDataTest.createProductCategory(categoryObj.Id,productObj.Id);
        insert productCategory;
        Ecom_Coupon_Contact__c ecomContact = dbu_CouponFactoryDataTest.createCouponContact(coupon.Id,'Inclusion');
        ecomContact.Ecom_Max_Number_Of_Use__c = 1.00;
        insert ecomContact;
        Ecom_Coupon__c couponData =  [SELECT Id,
                                      Ecom_Active__c,
                                      Ecom_Type__c,
                                      Ecom_Min_Quantity__c,
                                      Ecom_Cart_Total_Amount__c,
                                      Ecom_Discount_On_Each_Quantity__c,
                                      Ecom_Coupon_Type__c,
                                      CurrencyIsoCode,
                                      Ecom_Include_All_Register_Customers__c,
                                      Ecom_Include_Guest_Customers__c,
                                      Ecom_Rule_Type__c,
                                      Ecom_Start_Date__c,
                                      Ecom_End_Date__c,
                                      Ecom_Store__c,
                                      Ecom_Discount_Amount__c,
                                      (SELECT Id,Ecom_Source_Product__c,Ecom_Source_Quantity__c,Ecom_Target_Product__c,Ecom_Target_Quantity__c,Ecom_Rule_Type__c,Ecom_Coupon_Product_Type__c  FROM Ecom_Coupon_Products__r),
                                      (SELECT Id, Ecom_Source_Category__c,Ecom_Target_Category__c,Ecom_Source_Quantity__c,Ecom_Target_Quantity__c,Ecom_Rule_Type__c,Ecom_Coupon_Category_Type__c FROM Ecom_Coupon_Categories__r),
                                      (SELECT Id,Contact__c,Contact__r.Email,Ecom_Coupon_Contact_Type__c,Ecom_Coupon__c,Ecom_Max_Number_Of_Use__c FROM Ecom_Coupon_Contacts__r)
                                      FROM Ecom_Coupon__c 
                                      WHERE Name =:coupon.Name AND Ecom_Active__c = true];
        Test.startTest();  
        dbu_CouponUtility.getCartTotalCoupon(cart.Id,couponData);
        dbu_CouponUtility.getCartTotalCouponGuest(cart.Id,couponData);
        dbu_CouponUtility.getCartTotalCouponIncludedCust(cart.Id,couponData);
        dbu_CouponUtility.getCouponInclusionExclusionIds(cart.Id,couponData);
        Test.stopTest(); 
    }
    
     @isTest
    private static void getCartTotalCouponTest2(){
        
        Id iamRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('IAM').getRecordTypeId();
        Id ContactRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('IAM').getRecordTypeId();
        Account createAccount= dbu_TestDataCreationUtility.createAccount(iamRecordTypeId);
        createAccount.BillingCountry = 'Canada';
        insert createAccount;
        Contact createContact= dbu_TestDataCreationUtility.createContact(createAccount, ContactRecordTypeId);
        insert createContact;
        ccrz__E_ContactAddr__c createContactAddr= dbu_TestDataCreationUtility.createContactAddr();
        createContactAddr.ccrz__Country__c='Canada';
        createContactAddr.ccrz__PostalCode__c='V4N3P8';
        insert createContactAddr;
        
        ccrz__E_Cart__c cart = dbu_CouponFactoryDataTest.createCart();
        insert cart;
        ccrz__E_Product__c productObj = dbu_FactoryDataTest.createProduct('Test1',true, true, true,true);
        insert productObj;
        
        
        ccrz__E_CartItem__c cartItem = dbu_CouponFactoryDataTest.createCartItem(cart.Id,productObj.Id);
        insert cartItem;
      
        Ecom_Coupon__c coupon = dbu_CouponFactoryDataTest.createCoupon('test','Cart Total');
        coupon.Ecom_Coupon_Type__c = 'Percentage';
        coupon.Ecom_Discount_On_Each_Quantity__c = false;
        insert coupon;
       
       
        Ecom_Coupon__c couponData =  [SELECT Id,
                                      Ecom_Active__c,
                                      Ecom_Type__c,
                                      Ecom_Min_Quantity__c,
                                      Ecom_Cart_Total_Amount__c,
                                      Ecom_Discount_On_Each_Quantity__c,
                                      Ecom_Coupon_Type__c,
                                      CurrencyIsoCode,
                                      Ecom_Include_All_Register_Customers__c,
                                      Ecom_Include_Guest_Customers__c,
                                      Ecom_Rule_Type__c,
                                      Ecom_Start_Date__c,
                                      Ecom_End_Date__c,
                                      Ecom_Store__c,
                                      Ecom_Discount_Amount__c,
                                      (SELECT Id,Ecom_Source_Product__c,Ecom_Source_Quantity__c,Ecom_Target_Product__c,Ecom_Target_Quantity__c,Ecom_Rule_Type__c,Ecom_Coupon_Product_Type__c  FROM Ecom_Coupon_Products__r),
                                      (SELECT Id, Ecom_Source_Category__c,Ecom_Target_Category__c,Ecom_Source_Quantity__c,Ecom_Target_Quantity__c,Ecom_Rule_Type__c,Ecom_Coupon_Category_Type__c FROM Ecom_Coupon_Categories__r),
                                      (SELECT Id,Contact__c,Contact__r.Email,Ecom_Coupon_Contact_Type__c,Ecom_Coupon__c,Ecom_Max_Number_Of_Use__c FROM Ecom_Coupon_Contacts__r)
                                      FROM Ecom_Coupon__c 
                                      WHERE Name =:coupon.Name AND Ecom_Active__c = true];
        Test.startTest();  
        dbu_CouponUtility.getCartTotalCoupon(cart.Id,couponData);
        dbu_CouponUtility.getCartTotalCouponGuest(cart.Id,couponData);
        Test.stopTest(); 
    }
    
    
    @isTest
    private static void getGeneralTypeCouponTest(){
        ccrz__E_Cart__c cart = dbu_CouponFactoryDataTest.createCart();
        insert cart;
        ccrz__E_Product__c productObj = dbu_FactoryDataTest.createProduct('Test-General',true, true, true,true);
        insert productObj;
        ccrz__E_Product__c productObj1 = dbu_FactoryDataTest.createProduct('Test_product',true, true, true,true);
        productObj1.dbu_Has_Core_Child__c = true;
        productObj1.dbu_Has_Core_Charge__c = true;
        insert productObj1;
        ccrz__E_Product__c productObj2 = dbu_FactoryDataTest.createProduct('TestProduct',true, true, true,true);
        insert productObj2;
        ccrz__E_CartItem__c cartItem = dbu_CouponFactoryDataTest.createCartItem(cart.Id,productObj.Id);
        insert cartItem;
        ccrz__E_CartItem__c cartItem1 = dbu_CouponFactoryDataTest.createCartItem(cart.Id,productObj1.Id);
        insert cartItem1;
        ccrz__E_CartItem__c cartItem2 = dbu_CouponFactoryDataTest.createCartItem(cart.Id,productObj2.Id);
        insert cartItem2;
        Ecom_Coupon__c coupon = dbu_CouponFactoryDataTest.createCoupon('test','General');
        coupon.Ecom_Coupon_Type__c = 'Percentage';
        coupon.Ecom_Min_Quantity__c = 1;
        coupon.Ecom_Customer_Groups__c = 'New;Returning;Abandoned Cart;Email Subscribers';
        insert coupon;
        Ecom_Coupon_Product__c couponProduct = dbu_CouponFactoryDataTest.createCouponProduct(coupon.Id,'Inclusion');
        couponProduct.Ecom_Source_Product__c = productObj.Id;
        insert couponProduct;
        ccrz__E_Category__c categoryObj = dbu_CouponFactoryDataTest.createCategory('Test-Cate', '900');
        insert categoryObj;
        Ecom_Coupon_Category__c couponCategory = dbu_CouponFactoryDataTest.createCouponCategory(coupon.Id,'Inclusion', categoryObj.Id);
        insert couponCategory;
        ccrz__E_ProductCategory__c productCategory = dbu_CouponFactoryDataTest.createProductCategory(categoryObj.Id,productObj.Id);
        insert productCategory;
        Ecom_Coupon__c couponData =  [SELECT Id,
                                      Ecom_Active__c,
                                      Ecom_Type__c,
                                      Ecom_Discount_On_Each_Quantity__c,
                                      Ecom_Cart_Total_Amount__c,
                                      Ecom_Customer_Groups__c,
                                      Ecom_Coupon_Type__c,
                                      CurrencyIsoCode,
                                      Ecom_Include_All_Register_Customers__c,
                                      Ecom_Include_Guest_Customers__c,
                                      Ecom_Rule_Type__c,
                                      Ecom_Start_Date__c,
                                      Ecom_End_Date__c,
                                      Ecom_Store__c,
                                      Ecom_Discount_Amount__c,
                                      Ecom_Min_Quantity__c,
                                      (SELECT Id,Ecom_Source_Product__c,Ecom_Source_Quantity__c,Ecom_Target_Product__c,Ecom_Target_Quantity__c,Ecom_Rule_Type__c,Ecom_Coupon_Product_Type__c  FROM Ecom_Coupon_Products__r),
                                      (SELECT Id, Ecom_Source_Category__c,Ecom_Target_Category__c,Ecom_Source_Quantity__c,Ecom_Target_Quantity__c,Ecom_Rule_Type__c,Ecom_Coupon_Category_Type__c FROM Ecom_Coupon_Categories__r),
                                      (SELECT Id,Contact__c,Contact__r.Email,Ecom_Coupon_Contact_Type__c,Ecom_Coupon__c FROM Ecom_Coupon_Contacts__r)
                                      FROM Ecom_Coupon__c 
                                      WHERE Name =:coupon.Name AND Ecom_Active__c = true];
        Test.startTest();  
        dbu_CouponUtility.getGeneralTypeCoupon(cart.Id,couponData);
        dbu_CouponUtility.getCouponInclusionExclusionIds(cart.Id,couponData);
        dbu_CouponUtility.getAbandonedCartIds(cart.Id,couponData);
        //dbu_CouponUtility.getCartTotalCouponGuest(cart.Id,couponData);
        //dbu_CouponUtility.getCartTotalCouponIncludedCust(cart.Id,couponData);
        Test.stopTest(); 
    }
    
    @isTest
    private static void getCustomerGroupTest(){
        ccrz__E_Cart__c cart = dbu_CouponFactoryDataTest.createCart();
        insert cart;
        ccrz__E_Product__c productObj = dbu_FactoryDataTest.createProduct('Test',true, true, true,true);
        insert productObj;
        ccrz__E_Product__c productObj1 = dbu_FactoryDataTest.createProduct('Test product',true, true, true,true);
        productObj1.dbu_Has_Core_Child__c = true;
        productObj1.dbu_Has_Core_Charge__c = true;
        insert productObj1;
        ccrz__E_Product__c productObj2 = dbu_FactoryDataTest.createProduct('Test-product',true, true, true,true);
        insert productObj2;
        ccrz__E_CartItem__c cartItem = dbu_CouponFactoryDataTest.createCartItem(cart.Id,productObj.Id);
        insert cartItem;
        ccrz__E_CartItem__c cartItem1 = dbu_CouponFactoryDataTest.createCartItem(cart.Id,productObj1.Id);
        insert cartItem1;
        ccrz__E_CartItem__c cartItem2 = dbu_CouponFactoryDataTest.createCartItem(cart.Id,productObj2.Id);
        insert cartItem2;
        Ecom_Coupon__c coupon = dbu_CouponFactoryDataTest.createCoupon('test','Cart Total');
        coupon.Ecom_Coupon_Type__c = 'Percentage';
        coupon.Ecom_Customer_Groups__c = 'Returning;Email Subscribers';
        insert coupon;
        Ecom_Coupon_Product__c couponProduct = dbu_CouponFactoryDataTest.createCouponProduct(coupon.Id,'Exclusion');
        couponProduct.Ecom_Source_Product__c = productObj.Id;
        insert couponProduct;
        ccrz__E_Category__c categoryObj = dbu_CouponFactoryDataTest.createCategory('Test', '900');
        insert categoryObj;
        Ecom_Coupon_Category__c couponCategory = dbu_CouponFactoryDataTest.createCouponCategory(coupon.Id,'Exclusion', categoryObj.Id);
        insert couponCategory;
        ccrz__E_ProductCategory__c productCategory = dbu_CouponFactoryDataTest.createProductCategory(categoryObj.Id,productObj.Id);
        insert productCategory;
        Ecom_Coupon__c couponData =  [SELECT Id,
                                      Ecom_Active__c,
                                      Ecom_Type__c,
                                      Ecom_Discount_On_Each_Quantity__c,
                                      Ecom_Min_Quantity__c,
                                      Ecom_Customer_Groups__c,
                                      Ecom_Cart_Total_Amount__c,
                                      Ecom_Coupon_Type__c,
                                      CurrencyIsoCode,
                                      Ecom_Include_All_Register_Customers__c,
                                      Ecom_Include_Guest_Customers__c,
                                      Ecom_Rule_Type__c,
                                      Ecom_Start_Date__c,
                                      Ecom_End_Date__c,
                                      Ecom_Store__c,
                                      Ecom_Discount_Amount__c,
                                      (SELECT Id,Ecom_Source_Product__c,Ecom_Source_Quantity__c,Ecom_Target_Product__c,Ecom_Target_Quantity__c,Ecom_Rule_Type__c,Ecom_Coupon_Product_Type__c  FROM Ecom_Coupon_Products__r),
                                      (SELECT Id, Ecom_Source_Category__c,Ecom_Target_Category__c,Ecom_Source_Quantity__c,Ecom_Target_Quantity__c,Ecom_Rule_Type__c,Ecom_Coupon_Category_Type__c FROM Ecom_Coupon_Categories__r),
                                      (SELECT Id,Contact__c,Contact__r.Email,Ecom_Coupon_Contact_Type__c,Ecom_Coupon__c FROM Ecom_Coupon_Contacts__r)
                                      FROM Ecom_Coupon__c 
                                      WHERE Name =:coupon.Name AND Ecom_Active__c = true];
        Test.startTest();  
        dbu_CouponUtility.getAbandonedCartIds(cart.Id,couponData);
        Test.stopTest(); 
    }
    
    @isTest
    private static void ruleTypeShippingTest1(){
        
        ccrz__E_Product__c productObj = dbu_FactoryDataTest.createProduct('TestProduct1',true, true, true,true);
        productObj.dbu_Crate_Engine__c = false;
        insert productObj;
        
        ccrz__E_Spec__c ccSpec = new ccrz__E_Spec__c();
        ccSpec.Name = 'Shipment Weight';
        ccSpec.ccrz__IsVisibleInCatalog__c = true;
        insert ccSpec;
        
        ccrz__E_ProductSpec__c prodSpec = new ccrz__E_ProductSpec__c();
        prodSpec.ccrz__SpecValue__c = '40 lb';
        prodSpec.ccrz__Product__c = productObj.Id;
        prodSpec.ccrz__Spec__c = ccSpec.Id;
        Insert prodSpec;
        
        ccrz__E_Cart__c cart = dbu_CouponFactoryDataTest.createCart();
        insert cart;
        ccrz__E_CartItem__c cartItem = dbu_CouponFactoryDataTest.createCartItem(cart.Id,productObj.Id);
        insert cartItem;
        
        Ecom_Coupon__c coupon = dbu_CouponFactoryDataTest.createCoupon('testShipping','Shipping');
        coupon.Ecom_Coupon_Type__c = 'Free Shipping';
        coupon.Ecom_Max_Weight__c = 200.00;
        coupon.Ecom_Min_Weight__c = 1.00;
        coupon.Ecom_Cart_Total_Amount__c = null;
        coupon.Ecom_Min_Quantity__c = null;
        insert coupon;
        
        Ecom_Coupon__c couponData =  [SELECT Id,
                                      Ecom_Active__c,
                                      Ecom_Type__c,
                                      Ecom_Max_Weight__c,
                                      Ecom_Min_Weight__c,
                                      Ecom_Discount_On_Each_Quantity__c,
                                      Ecom_Min_Quantity__c,
                                      Ecom_Customer_Groups__c,
                                      Ecom_Cart_Total_Amount__c,
                                      Ecom_Coupon_Type__c,
                                      CurrencyIsoCode,
                                      Ecom_Include_All_Register_Customers__c,
                                      Ecom_Include_Guest_Customers__c,
                                      Ecom_Rule_Type__c,
                                      Ecom_Start_Date__c,
                                      Ecom_End_Date__c,
                                      Ecom_Store__c,
                                      Ecom_Discount_Amount__c,
                                      (SELECT Id,Ecom_Source_Product__c,Ecom_Source_Quantity__c,Ecom_Target_Product__c,Ecom_Target_Quantity__c,Ecom_Rule_Type__c,Ecom_Coupon_Product_Type__c  FROM Ecom_Coupon_Products__r),
                                      (SELECT Id, Ecom_Source_Category__c,Ecom_Target_Category__c,Ecom_Source_Quantity__c,Ecom_Target_Quantity__c,Ecom_Rule_Type__c,Ecom_Coupon_Category_Type__c FROM Ecom_Coupon_Categories__r),
                                      (SELECT Id,Contact__c,Contact__r.Email,Ecom_Coupon_Contact_Type__c,Ecom_Coupon__c FROM Ecom_Coupon_Contacts__r)
                                      FROM Ecom_Coupon__c 
                                      WHERE Name =:coupon.Name AND Ecom_Active__c = true];
        Test.startTest();  
        dbu_CouponUtility.getCouponInclusionExclusionIds(cart.Id,couponData);
        Test.stopTest(); 
    }
    
    @isTest
    private static void ruleTypeShippingTest2(){
        
        ccrz__E_Product__c productObj = dbu_FactoryDataTest.createProduct('Test',true, true, true,true);
        insert productObj;
        ccrz__E_Product__c productObj1 = dbu_FactoryDataTest.createProduct('Test product',true, true, true,true);
        productObj1.dbu_Has_Core_Child__c = true;
        productObj1.dbu_Has_Core_Charge__c = true;
        insert productObj1;
        ccrz__E_Product__c productObj2 = dbu_FactoryDataTest.createProduct('Test-product',true, true, true,true);
        insert productObj2;
        
        ccrz__E_Spec__c ccSpec = new ccrz__E_Spec__c();
        ccSpec.Name = 'Shipment Weight';
        ccSpec.ccrz__IsVisibleInCatalog__c = true;
        insert ccSpec;
        
        ccrz__E_ProductSpec__c prodSpec = new ccrz__E_ProductSpec__c();
        prodSpec.ccrz__SpecValue__c = '40 lb';
        prodSpec.ccrz__Product__c = productObj.Id;
        prodSpec.ccrz__Spec__c = ccSpec.Id;
        Insert prodSpec;
        
        ccrz__E_Cart__c cart = dbu_CouponFactoryDataTest.createCart();
        insert cart;
        ccrz__E_CartItem__c cartItem = dbu_CouponFactoryDataTest.createCartItem(cart.Id,productObj.Id);
        insert cartItem;
        ccrz__E_CartItem__c cartItem1 = dbu_CouponFactoryDataTest.createCartItem(cart.Id,productObj1.Id);
        insert cartItem1;
        ccrz__E_CartItem__c cartItem2 = dbu_CouponFactoryDataTest.createCartItem(cart.Id,productObj2.Id);
        insert cartItem2;
        
        Ecom_Coupon__c coupon = dbu_CouponFactoryDataTest.createCoupon('testShipping','Shipping');
        coupon.Ecom_Coupon_Type__c = 'Free Shipping';
        coupon.Ecom_Max_Weight__c = 200.00;
        coupon.Ecom_Min_Weight__c = null;
        coupon.Ecom_Cart_Total_Amount__c = null;
        coupon.Ecom_Min_Quantity__c = null;
        insert coupon;
        
        Ecom_Coupon__c couponData =  [SELECT Id,
                                      Ecom_Active__c,
                                      Ecom_Type__c,
                                      Ecom_Max_Weight__c,
                                      Ecom_Min_Weight__c,
                                      Ecom_Discount_On_Each_Quantity__c,
                                      Ecom_Min_Quantity__c,
                                      Ecom_Customer_Groups__c,
                                      Ecom_Cart_Total_Amount__c,
                                      Ecom_Coupon_Type__c,
                                      CurrencyIsoCode,
                                      Ecom_Include_All_Register_Customers__c,
                                      Ecom_Include_Guest_Customers__c,
                                      Ecom_Rule_Type__c,
                                      Ecom_Start_Date__c,
                                      Ecom_End_Date__c,
                                      Ecom_Store__c,
                                      Ecom_Discount_Amount__c,
                                      (SELECT Id,Ecom_Source_Product__c,Ecom_Source_Quantity__c,Ecom_Target_Product__c,Ecom_Target_Quantity__c,Ecom_Rule_Type__c,Ecom_Coupon_Product_Type__c  FROM Ecom_Coupon_Products__r),
                                      (SELECT Id, Ecom_Source_Category__c,Ecom_Target_Category__c,Ecom_Source_Quantity__c,Ecom_Target_Quantity__c,Ecom_Rule_Type__c,Ecom_Coupon_Category_Type__c FROM Ecom_Coupon_Categories__r),
                                      (SELECT Id,Contact__c,Contact__r.Email,Ecom_Coupon_Contact_Type__c,Ecom_Coupon__c FROM Ecom_Coupon_Contacts__r)
                                      FROM Ecom_Coupon__c 
                                      WHERE Name =:coupon.Name AND Ecom_Active__c = true];
        Test.startTest();  
        dbu_CouponUtility.getCouponInclusionExclusionIds(cart.Id,couponData);
        Test.stopTest(); 
    }
    
    @isTest
    private static void ruleTypeShippingTest3(){
        
        ccrz__E_Product__c productObj = dbu_FactoryDataTest.createProduct('Test',true, true, true,true);
        insert productObj;
        ccrz__E_Product__c productObj1 = dbu_FactoryDataTest.createProduct('Test product',true, true, true,true);
        productObj1.dbu_Has_Core_Child__c = true;
        productObj1.dbu_Has_Core_Charge__c = true;
        insert productObj1;
        ccrz__E_Product__c productObj2 = dbu_FactoryDataTest.createProduct('Test-product',true, true, true,true);
        insert productObj2;
        
        ccrz__E_Spec__c ccSpec = new ccrz__E_Spec__c();
        ccSpec.Name = 'Shipment Weight';
        ccSpec.ccrz__IsVisibleInCatalog__c = true;
        insert ccSpec;
        
        ccrz__E_ProductSpec__c prodSpec = new ccrz__E_ProductSpec__c();
        prodSpec.ccrz__SpecValue__c = '40 lb';
        prodSpec.ccrz__Product__c = productObj.Id;
        prodSpec.ccrz__Spec__c = ccSpec.Id;
        Insert prodSpec;
        
        ccrz__E_Cart__c cart = dbu_CouponFactoryDataTest.createCart();
        insert cart;
        ccrz__E_CartItem__c cartItem = dbu_CouponFactoryDataTest.createCartItem(cart.Id,productObj.Id);
        insert cartItem;
        ccrz__E_CartItem__c cartItem1 = dbu_CouponFactoryDataTest.createCartItem(cart.Id,productObj1.Id);
        insert cartItem1;
        ccrz__E_CartItem__c cartItem2 = dbu_CouponFactoryDataTest.createCartItem(cart.Id,productObj2.Id);
        insert cartItem2;
        
        Ecom_Coupon__c coupon = dbu_CouponFactoryDataTest.createCoupon('testShipping','Shipping');
        coupon.Ecom_Coupon_Type__c = 'Free Shipping';
        coupon.Ecom_Max_Weight__c = null;
        coupon.Ecom_Min_Weight__c = 10.00;
        coupon.Ecom_Cart_Total_Amount__c = null;
        coupon.Ecom_Min_Quantity__c = null;
        insert coupon;
        
        Ecom_Coupon__c couponData =  [SELECT Id,
                                      Ecom_Active__c,
                                      Ecom_Type__c,
                                      Ecom_Max_Weight__c,
                                      Ecom_Min_Weight__c, 
                                      Ecom_Discount_On_Each_Quantity__c,
                                      Ecom_Min_Quantity__c,
                                      Ecom_Customer_Groups__c,
                                      Ecom_Cart_Total_Amount__c,
                                      Ecom_Coupon_Type__c,
                                      CurrencyIsoCode,
                                      Ecom_Include_All_Register_Customers__c,
                                      Ecom_Include_Guest_Customers__c,
                                      Ecom_Rule_Type__c,
                                      Ecom_Start_Date__c,
                                      Ecom_End_Date__c,
                                      Ecom_Store__c,
                                      Ecom_Discount_Amount__c,
                                      (SELECT Id,Ecom_Source_Product__c,Ecom_Source_Quantity__c,Ecom_Target_Product__c,Ecom_Target_Quantity__c,Ecom_Rule_Type__c,Ecom_Coupon_Product_Type__c  FROM Ecom_Coupon_Products__r),
                                      (SELECT Id, Ecom_Source_Category__c,Ecom_Target_Category__c,Ecom_Source_Quantity__c,Ecom_Target_Quantity__c,Ecom_Rule_Type__c,Ecom_Coupon_Category_Type__c FROM Ecom_Coupon_Categories__r),
                                      (SELECT Id,Contact__c,Contact__r.Email,Ecom_Coupon_Contact_Type__c,Ecom_Coupon__c FROM Ecom_Coupon_Contacts__r)
                                      FROM Ecom_Coupon__c 
                                      WHERE Name =:coupon.Name AND Ecom_Active__c = true];
        Test.startTest();  
        dbu_CouponUtility.getCouponInclusionExclusionIds(cart.Id,couponData);
        Test.stopTest(); 
    }
    
    @isTest
    private static void ruleTypeShippingTest4(){
        
        ccrz__E_Product__c productObj = dbu_FactoryDataTest.createProduct('Test',true, true, true,true);
        insert productObj;
        ccrz__E_Product__c productObj1 = dbu_FactoryDataTest.createProduct('Test product',true, true, true,true);
        productObj1.dbu_Has_Core_Child__c = true;
        productObj1.dbu_Has_Core_Charge__c = true;
        insert productObj1;
        ccrz__E_Product__c productObj2 = dbu_FactoryDataTest.createProduct('Test-product',true, true, true,true);
        insert productObj2;
        
        ccrz__E_Spec__c ccSpec = new ccrz__E_Spec__c();
        ccSpec.Name = 'Shipment Weight';
        ccSpec.ccrz__IsVisibleInCatalog__c = true;
        insert ccSpec;
        
        ccrz__E_ProductSpec__c prodSpec = new ccrz__E_ProductSpec__c();
        prodSpec.ccrz__SpecValue__c = '40 lb';
        prodSpec.ccrz__Product__c = productObj.Id;
        prodSpec.ccrz__Spec__c = ccSpec.Id;
        Insert prodSpec;
        
        ccrz__E_Cart__c cart = dbu_CouponFactoryDataTest.createCart();
        insert cart;
        ccrz__E_CartItem__c cartItem = dbu_CouponFactoryDataTest.createCartItem(cart.Id,productObj.Id);
        insert cartItem;
        ccrz__E_CartItem__c cartItem1 = dbu_CouponFactoryDataTest.createCartItem(cart.Id,productObj1.Id);
        insert cartItem1;
        ccrz__E_CartItem__c cartItem2 = dbu_CouponFactoryDataTest.createCartItem(cart.Id,productObj2.Id);
        insert cartItem2;
        
        Ecom_Coupon__c coupon = dbu_CouponFactoryDataTest.createCoupon('testShipping','Shipping');
        coupon.Ecom_Coupon_Type__c = 'Free Shipping';
        coupon.Ecom_Max_Weight__c = null;
        coupon.Ecom_Min_Weight__c = null;
        coupon.Ecom_Cart_Total_Amount__c = 100.00;
        coupon.Ecom_Min_Quantity__c = null;
        insert coupon;
        
        Ecom_Coupon__c couponData =  [SELECT Id,
                                      Ecom_Active__c,
                                      Ecom_Type__c,
                                      Ecom_Max_Weight__c,
                                      Ecom_Min_Weight__c, 
                                      Ecom_Discount_On_Each_Quantity__c,
                                      Ecom_Min_Quantity__c,
                                      Ecom_Customer_Groups__c,
                                      Ecom_Cart_Total_Amount__c,
                                      Ecom_Coupon_Type__c,
                                      CurrencyIsoCode,
                                      Ecom_Include_All_Register_Customers__c,
                                      Ecom_Include_Guest_Customers__c,
                                      Ecom_Rule_Type__c,
                                      Ecom_Start_Date__c,
                                      Ecom_End_Date__c,
                                      Ecom_Store__c,
                                      Ecom_Discount_Amount__c,
                                      (SELECT Id,Ecom_Source_Product__c,Ecom_Source_Quantity__c,Ecom_Target_Product__c,Ecom_Target_Quantity__c,Ecom_Rule_Type__c,Ecom_Coupon_Product_Type__c  FROM Ecom_Coupon_Products__r),
                                      (SELECT Id, Ecom_Source_Category__c,Ecom_Target_Category__c,Ecom_Source_Quantity__c,Ecom_Target_Quantity__c,Ecom_Rule_Type__c,Ecom_Coupon_Category_Type__c FROM Ecom_Coupon_Categories__r),
                                      (SELECT Id,Contact__c,Contact__r.Email,Ecom_Coupon_Contact_Type__c,Ecom_Coupon__c FROM Ecom_Coupon_Contacts__r)
                                      FROM Ecom_Coupon__c 
                                      WHERE Name =:coupon.Name AND Ecom_Active__c = true];
        Test.startTest();  
        dbu_CouponUtility.getCouponInclusionExclusionIds(cart.Id,couponData);
        Test.stopTest(); 
    }
    @isTest
    private static void ruleTypeShippingTest5(){
        
        ccrz__E_Product__c productObj = dbu_FactoryDataTest.createProduct('Test',true, true, true,true);
        insert productObj;
        ccrz__E_Product__c productObj1 = dbu_FactoryDataTest.createProduct('Test product',true, true, true,true);
        productObj1.dbu_Has_Core_Child__c = true;
        productObj1.dbu_Has_Core_Charge__c = true;
        insert productObj1;
        ccrz__E_Product__c productObj2 = dbu_FactoryDataTest.createProduct('Test-product',true, true, true,true);
        insert productObj2;
        
        ccrz__E_Spec__c ccSpec = new ccrz__E_Spec__c();
        ccSpec.Name = 'Shipment Weight';
        ccSpec.ccrz__IsVisibleInCatalog__c = true;
        insert ccSpec;
        
        ccrz__E_ProductSpec__c prodSpec = new ccrz__E_ProductSpec__c();
        prodSpec.ccrz__SpecValue__c = '40 lb';
        prodSpec.ccrz__Product__c = productObj.Id;
        prodSpec.ccrz__Spec__c = ccSpec.Id;
        Insert prodSpec;
        
        ccrz__E_Cart__c cart = dbu_CouponFactoryDataTest.createCart();
        insert cart;
        ccrz__E_CartItem__c cartItem = dbu_CouponFactoryDataTest.createCartItem(cart.Id,productObj.Id);
        insert cartItem;
        ccrz__E_CartItem__c cartItem1 = dbu_CouponFactoryDataTest.createCartItem(cart.Id,productObj1.Id);
        insert cartItem1;
        ccrz__E_CartItem__c cartItem2 = dbu_CouponFactoryDataTest.createCartItem(cart.Id,productObj2.Id);
        insert cartItem2;
        
        Ecom_Coupon__c coupon = dbu_CouponFactoryDataTest.createCoupon('testShipping','Shipping');
        coupon.Ecom_Coupon_Type__c = 'Free Shipping';
        coupon.Ecom_Max_Weight__c = 200.00;
        coupon.Ecom_Min_Weight__c = null;
        coupon.Ecom_Cart_Total_Amount__c = 100.00;
        coupon.Ecom_Min_Quantity__c = null;
        insert coupon;
        
        Ecom_Coupon__c couponData =  [SELECT Id,
                                      Ecom_Active__c,
                                      Ecom_Type__c,
                                      Ecom_Max_Weight__c,
                                      Ecom_Min_Weight__c,
                                      Ecom_Discount_On_Each_Quantity__c,
                                      Ecom_Min_Quantity__c,
                                      Ecom_Customer_Groups__c,
                                      Ecom_Cart_Total_Amount__c,
                                      Ecom_Coupon_Type__c,
                                      CurrencyIsoCode,
                                      Ecom_Include_All_Register_Customers__c,
                                      Ecom_Include_Guest_Customers__c,
                                      Ecom_Rule_Type__c,
                                      Ecom_Start_Date__c,
                                      Ecom_End_Date__c,
                                      Ecom_Store__c,
                                      Ecom_Discount_Amount__c,
                                      (SELECT Id,Ecom_Source_Product__c,Ecom_Source_Quantity__c,Ecom_Target_Product__c,Ecom_Target_Quantity__c,Ecom_Rule_Type__c,Ecom_Coupon_Product_Type__c  FROM Ecom_Coupon_Products__r),
                                      (SELECT Id, Ecom_Source_Category__c,Ecom_Target_Category__c,Ecom_Source_Quantity__c,Ecom_Target_Quantity__c,Ecom_Rule_Type__c,Ecom_Coupon_Category_Type__c FROM Ecom_Coupon_Categories__r),
                                      (SELECT Id,Contact__c,Contact__r.Email,Ecom_Coupon_Contact_Type__c,Ecom_Coupon__c FROM Ecom_Coupon_Contacts__r)
                                      FROM Ecom_Coupon__c 
                                      WHERE Name =:coupon.Name AND Ecom_Active__c = true];
        Test.startTest();  
        dbu_CouponUtility.getCouponInclusionExclusionIds(cart.Id,couponData);
        Test.stopTest(); 
    }
    
    @isTest
    private static void ruleTypeShippingTest6(){
        
        ccrz__E_Product__c productObj = dbu_FactoryDataTest.createProduct('Test',true, true, true,true);
        insert productObj;
        ccrz__E_Product__c productObj1 = dbu_FactoryDataTest.createProduct('Test product',true, true, true,true);
        productObj1.dbu_Has_Core_Child__c = true;
        productObj1.dbu_Has_Core_Charge__c = true;
        insert productObj1;
        ccrz__E_Product__c productObj2 = dbu_FactoryDataTest.createProduct('Test-product',true, true, true,true);
        insert productObj2;
        
        ccrz__E_Spec__c ccSpec = new ccrz__E_Spec__c();
        ccSpec.Name = 'Shipment Weight';
        ccSpec.ccrz__IsVisibleInCatalog__c = true;
        insert ccSpec;
        
        ccrz__E_ProductSpec__c prodSpec = new ccrz__E_ProductSpec__c();
        prodSpec.ccrz__SpecValue__c = '40 lb';
        prodSpec.ccrz__Product__c = productObj.Id;
        prodSpec.ccrz__Spec__c = ccSpec.Id;
        Insert prodSpec;
        
        ccrz__E_Cart__c cart = dbu_CouponFactoryDataTest.createCart();
        insert cart;
        ccrz__E_CartItem__c cartItem = dbu_CouponFactoryDataTest.createCartItem(cart.Id,productObj.Id);
        insert cartItem;
        ccrz__E_CartItem__c cartItem1 = dbu_CouponFactoryDataTest.createCartItem(cart.Id,productObj1.Id);
        insert cartItem1;
        ccrz__E_CartItem__c cartItem2 = dbu_CouponFactoryDataTest.createCartItem(cart.Id,productObj2.Id);
        insert cartItem2;
        
        Ecom_Coupon__c coupon = dbu_CouponFactoryDataTest.createCoupon('testShipping','Shipping');
        coupon.Ecom_Coupon_Type__c = 'Free Shipping';
        coupon.Ecom_Max_Weight__c = null;
        coupon.Ecom_Min_Weight__c = 10.00;
        coupon.Ecom_Cart_Total_Amount__c = 100.00;
        coupon.Ecom_Min_Quantity__c = null;
        insert coupon;
        
        Ecom_Coupon__c couponData =  [SELECT Id,
                                      Ecom_Active__c,
                                      Ecom_Type__c,
                                      Ecom_Max_Weight__c,
                                      Ecom_Min_Weight__c,  
                                      Ecom_Discount_On_Each_Quantity__c,
                                      Ecom_Min_Quantity__c,
                                      Ecom_Customer_Groups__c,
                                      Ecom_Cart_Total_Amount__c,
                                      Ecom_Coupon_Type__c,
                                      CurrencyIsoCode,
                                      Ecom_Include_All_Register_Customers__c,
                                      Ecom_Include_Guest_Customers__c,
                                      Ecom_Rule_Type__c,
                                      Ecom_Start_Date__c,
                                      Ecom_End_Date__c,
                                      Ecom_Store__c,
                                      Ecom_Discount_Amount__c,
                                      (SELECT Id,Ecom_Source_Product__c,Ecom_Source_Quantity__c,Ecom_Target_Product__c,Ecom_Target_Quantity__c,Ecom_Rule_Type__c,Ecom_Coupon_Product_Type__c  FROM Ecom_Coupon_Products__r),
                                      (SELECT Id, Ecom_Source_Category__c,Ecom_Target_Category__c,Ecom_Source_Quantity__c,Ecom_Target_Quantity__c,Ecom_Rule_Type__c,Ecom_Coupon_Category_Type__c FROM Ecom_Coupon_Categories__r),
                                      (SELECT Id,Contact__c,Contact__r.Email,Ecom_Coupon_Contact_Type__c,Ecom_Coupon__c FROM Ecom_Coupon_Contacts__r)
                                      FROM Ecom_Coupon__c 
                                      WHERE Name =:coupon.Name AND Ecom_Active__c = true];
        Test.startTest();  
        dbu_CouponUtility.getCouponInclusionExclusionIds(cart.Id,couponData);
        Test.stopTest(); 
    }
    @isTest
    private static void ruleTypeShippingTest7(){
        
        ccrz__E_Product__c productObj = dbu_FactoryDataTest.createProduct('Test',true, true, true,true);
        insert productObj;
        ccrz__E_Product__c productObj1 = dbu_FactoryDataTest.createProduct('Test product',true, true, true,true);
        productObj1.dbu_Has_Core_Child__c = true;
        productObj1.dbu_Has_Core_Charge__c = true;
        insert productObj1;
        ccrz__E_Product__c productObj2 = dbu_FactoryDataTest.createProduct('Test-product',true, true, true,true);
        insert productObj2;
        
        ccrz__E_Spec__c ccSpec = new ccrz__E_Spec__c();
        ccSpec.Name = 'Shipment Weight';
        ccSpec.ccrz__IsVisibleInCatalog__c = true;
        insert ccSpec;
        
        ccrz__E_ProductSpec__c prodSpec = new ccrz__E_ProductSpec__c();
        prodSpec.ccrz__SpecValue__c = '40 lb';
        prodSpec.ccrz__Product__c = productObj.Id;
        prodSpec.ccrz__Spec__c = ccSpec.Id;
        Insert prodSpec;
        
        ccrz__E_Cart__c cart = dbu_CouponFactoryDataTest.createCart();
        insert cart;
        ccrz__E_CartItem__c cartItem = dbu_CouponFactoryDataTest.createCartItem(cart.Id,productObj.Id);
        insert cartItem;
        ccrz__E_CartItem__c cartItem1 = dbu_CouponFactoryDataTest.createCartItem(cart.Id,productObj1.Id);
        insert cartItem1;
        ccrz__E_CartItem__c cartItem2 = dbu_CouponFactoryDataTest.createCartItem(cart.Id,productObj2.Id);
        insert cartItem2;
        
        Ecom_Coupon__c coupon = dbu_CouponFactoryDataTest.createCoupon('testShipping','Shipping');
        coupon.Ecom_Coupon_Type__c = 'Free Shipping';
        coupon.Ecom_Max_Weight__c = 200.00;
        coupon.Ecom_Min_Weight__c = 10.00;
        coupon.Ecom_Cart_Total_Amount__c = 100.00;
        coupon.Ecom_Min_Quantity__c = null;
        insert coupon;
        
        Ecom_Coupon__c couponData =  [SELECT Id,
                                      Ecom_Active__c,
                                      Ecom_Type__c,
                                      Ecom_Max_Weight__c,
                                      Ecom_Min_Weight__c, 
                                      Ecom_Discount_On_Each_Quantity__c,
                                      Ecom_Min_Quantity__c,
                                      Ecom_Customer_Groups__c,
                                      Ecom_Cart_Total_Amount__c,
                                      Ecom_Coupon_Type__c,
                                      CurrencyIsoCode,
                                      Ecom_Include_All_Register_Customers__c,
                                      Ecom_Include_Guest_Customers__c,
                                      Ecom_Rule_Type__c,
                                      Ecom_Start_Date__c,
                                      Ecom_End_Date__c,
                                      Ecom_Store__c,
                                      Ecom_Discount_Amount__c,
                                      (SELECT Id,Ecom_Source_Product__c,Ecom_Source_Quantity__c,Ecom_Target_Product__c,Ecom_Target_Quantity__c,Ecom_Rule_Type__c,Ecom_Coupon_Product_Type__c  FROM Ecom_Coupon_Products__r),
                                      (SELECT Id, Ecom_Source_Category__c,Ecom_Target_Category__c,Ecom_Source_Quantity__c,Ecom_Target_Quantity__c,Ecom_Rule_Type__c,Ecom_Coupon_Category_Type__c FROM Ecom_Coupon_Categories__r),
                                      (SELECT Id,Contact__c,Contact__r.Email,Ecom_Coupon_Contact_Type__c,Ecom_Coupon__c FROM Ecom_Coupon_Contacts__r)
                                      FROM Ecom_Coupon__c 
                                      WHERE Name =:coupon.Name AND Ecom_Active__c = true];
        Test.startTest();  
        dbu_CouponUtility.getCouponInclusionExclusionIds(cart.Id,couponData);
        Test.stopTest(); 
    }
    @isTest
    private static void ruleTypeShippingTest8(){
        
        ccrz__E_Product__c productObj = dbu_FactoryDataTest.createProduct('Test',true, true, true,true);
        insert productObj;
        ccrz__E_Product__c productObj1 = dbu_FactoryDataTest.createProduct('Test product',true, true, true,true);
        productObj1.dbu_Has_Core_Child__c = true;
        productObj1.dbu_Has_Core_Charge__c = true;
        insert productObj1;
        ccrz__E_Product__c productObj2 = dbu_FactoryDataTest.createProduct('Test-product',true, true, true,true);
        insert productObj2;
        
        ccrz__E_Spec__c ccSpec = new ccrz__E_Spec__c();
        ccSpec.Name = 'Shipment Weight';
        ccSpec.ccrz__IsVisibleInCatalog__c = true;
        insert ccSpec;
        
        ccrz__E_ProductSpec__c prodSpec = new ccrz__E_ProductSpec__c();
        prodSpec.ccrz__SpecValue__c = '40 lb';
        prodSpec.ccrz__Product__c = productObj.Id;
        prodSpec.ccrz__Spec__c = ccSpec.Id;
        Insert prodSpec;
        
        ccrz__E_Cart__c cart = dbu_CouponFactoryDataTest.createCart();
        insert cart;
        ccrz__E_CartItem__c cartItem = dbu_CouponFactoryDataTest.createCartItem(cart.Id,productObj.Id);
        insert cartItem;
        ccrz__E_CartItem__c cartItem1 = dbu_CouponFactoryDataTest.createCartItem(cart.Id,productObj1.Id);
        insert cartItem1;
        ccrz__E_CartItem__c cartItem2 = dbu_CouponFactoryDataTest.createCartItem(cart.Id,productObj2.Id);
        insert cartItem2;
        
        Ecom_Coupon__c coupon = dbu_CouponFactoryDataTest.createCoupon('testShipping','Shipping');
        coupon.Ecom_Coupon_Type__c = 'Free Shipping';
        coupon.Ecom_Max_Weight__c = 200.00;
        coupon.Ecom_Min_Weight__c = 10.00;
        coupon.Ecom_Cart_Total_Amount__c = 100.00;
        coupon.Ecom_Min_Quantity__c = 1;
        insert coupon;
        
        Ecom_Coupon__c couponData =  [SELECT Id,
                                      Ecom_Active__c,
                                      Ecom_Type__c,
                                      Ecom_Max_Weight__c,
                                      Ecom_Min_Weight__c,
                                      Ecom_Discount_On_Each_Quantity__c,
                                      Ecom_Min_Quantity__c,
                                      Ecom_Customer_Groups__c,
                                      Ecom_Cart_Total_Amount__c,
                                      Ecom_Coupon_Type__c,
                                      CurrencyIsoCode,
                                      Ecom_Include_All_Register_Customers__c,
                                      Ecom_Include_Guest_Customers__c,
                                      Ecom_Rule_Type__c,
                                      Ecom_Start_Date__c,
                                      Ecom_End_Date__c,
                                      Ecom_Store__c,
                                      Ecom_Discount_Amount__c,
                                      (SELECT Id,Ecom_Source_Product__c,Ecom_Source_Quantity__c,Ecom_Target_Product__c,Ecom_Target_Quantity__c,Ecom_Rule_Type__c,Ecom_Coupon_Product_Type__c  FROM Ecom_Coupon_Products__r),
                                      (SELECT Id, Ecom_Source_Category__c,Ecom_Target_Category__c,Ecom_Source_Quantity__c,Ecom_Target_Quantity__c,Ecom_Rule_Type__c,Ecom_Coupon_Category_Type__c FROM Ecom_Coupon_Categories__r),
                                      (SELECT Id,Contact__c,Contact__r.Email,Ecom_Coupon_Contact_Type__c,Ecom_Coupon__c FROM Ecom_Coupon_Contacts__r)
                                      FROM Ecom_Coupon__c 
                                      WHERE Name =:coupon.Name AND Ecom_Active__c = true];
        Test.startTest();  
        dbu_CouponUtility.getCouponInclusionExclusionIds(cart.Id,couponData);
        Test.stopTest(); 
    }
    @isTest
    private static void ruleTypeShippingTest9(){
        
        ccrz__E_Product__c productObj = dbu_FactoryDataTest.createProduct('Test',true, true, true,true);
        insert productObj;
        ccrz__E_Product__c productObj1 = dbu_FactoryDataTest.createProduct('Test product',true, true, true,true);
        productObj1.dbu_Has_Core_Child__c = true;
        productObj1.dbu_Has_Core_Charge__c = true;
        insert productObj1;
        ccrz__E_Product__c productObj2 = dbu_FactoryDataTest.createProduct('Test-product',true, true, true,true);
        insert productObj2;
        
        ccrz__E_Spec__c ccSpec = new ccrz__E_Spec__c();
        ccSpec.Name = 'Shipment Weight';
        ccSpec.ccrz__IsVisibleInCatalog__c = true;
        insert ccSpec;
        
        ccrz__E_ProductSpec__c prodSpec = new ccrz__E_ProductSpec__c();
        prodSpec.ccrz__SpecValue__c = '40 lb';
        prodSpec.ccrz__Product__c = productObj.Id;
        prodSpec.ccrz__Spec__c = ccSpec.Id;
        Insert prodSpec;
        
        ccrz__E_Cart__c cart = dbu_CouponFactoryDataTest.createCart();
        insert cart;
        ccrz__E_CartItem__c cartItem = dbu_CouponFactoryDataTest.createCartItem(cart.Id,productObj.Id);
        insert cartItem;
        ccrz__E_CartItem__c cartItem1 = dbu_CouponFactoryDataTest.createCartItem(cart.Id,productObj1.Id);
        insert cartItem1;
        ccrz__E_CartItem__c cartItem2 = dbu_CouponFactoryDataTest.createCartItem(cart.Id,productObj2.Id);
        insert cartItem2;
        
        Ecom_Coupon__c coupon = dbu_CouponFactoryDataTest.createCoupon('testShipping','Shipping');
        coupon.Ecom_Coupon_Type__c = 'Free Shipping';
        coupon.Ecom_Max_Weight__c = null;
        coupon.Ecom_Min_Weight__c = null;
        coupon.Ecom_Cart_Total_Amount__c = 100.00;
        coupon.Ecom_Min_Quantity__c = 1;
        insert coupon;
        
        Ecom_Coupon__c couponData =  [SELECT Id,
                                      Ecom_Active__c,
                                      Ecom_Type__c,
                                      Ecom_Max_Weight__c,
                                      Ecom_Min_Weight__c,   
                                      Ecom_Discount_On_Each_Quantity__c,
                                      Ecom_Min_Quantity__c,
                                      Ecom_Customer_Groups__c,
                                      Ecom_Cart_Total_Amount__c,
                                      Ecom_Coupon_Type__c,
                                      CurrencyIsoCode,
                                      Ecom_Include_All_Register_Customers__c,
                                      Ecom_Include_Guest_Customers__c,
                                      Ecom_Rule_Type__c,
                                      Ecom_Start_Date__c,
                                      Ecom_End_Date__c,
                                      Ecom_Store__c,
                                      Ecom_Discount_Amount__c,
                                      (SELECT Id,Ecom_Source_Product__c,Ecom_Source_Quantity__c,Ecom_Target_Product__c,Ecom_Target_Quantity__c,Ecom_Rule_Type__c,Ecom_Coupon_Product_Type__c  FROM Ecom_Coupon_Products__r),
                                      (SELECT Id, Ecom_Source_Category__c,Ecom_Target_Category__c,Ecom_Source_Quantity__c,Ecom_Target_Quantity__c,Ecom_Rule_Type__c,Ecom_Coupon_Category_Type__c FROM Ecom_Coupon_Categories__r),
                                      (SELECT Id,Contact__c,Contact__r.Email,Ecom_Coupon_Contact_Type__c,Ecom_Coupon__c FROM Ecom_Coupon_Contacts__r)
                                      FROM Ecom_Coupon__c 
                                      WHERE Name =:coupon.Name AND Ecom_Active__c = true];
        Test.startTest();  
        dbu_CouponUtility.getCouponInclusionExclusionIds(cart.Id,couponData);
        Test.stopTest(); 
    }
    @isTest
    private static void ruleTypeShippingTest10(){
        
        ccrz__E_Product__c productObj = dbu_FactoryDataTest.createProduct('Test',true, true, true,true);
        insert productObj;
        ccrz__E_Product__c productObj1 = dbu_FactoryDataTest.createProduct('Test product',true, true, true,true);
        productObj1.dbu_Has_Core_Child__c = true;
        productObj1.dbu_Has_Core_Charge__c = true;
        insert productObj1;
        ccrz__E_Product__c productObj2 = dbu_FactoryDataTest.createProduct('Test-product',true, true, true,true);
        insert productObj2;
        
        ccrz__E_Spec__c ccSpec = new ccrz__E_Spec__c();
        ccSpec.Name = 'Shipment Weight';
        ccSpec.ccrz__IsVisibleInCatalog__c = true;
        insert ccSpec;
        
        ccrz__E_ProductSpec__c prodSpec = new ccrz__E_ProductSpec__c();
        prodSpec.ccrz__SpecValue__c = '40 lb';
        prodSpec.ccrz__Product__c = productObj.Id;
        prodSpec.ccrz__Spec__c = ccSpec.Id;
        Insert prodSpec;
        
        ccrz__E_Cart__c cart = dbu_CouponFactoryDataTest.createCart();
        insert cart;
        ccrz__E_CartItem__c cartItem = dbu_CouponFactoryDataTest.createCartItem(cart.Id,productObj.Id);
        insert cartItem;
        ccrz__E_CartItem__c cartItem1 = dbu_CouponFactoryDataTest.createCartItem(cart.Id,productObj1.Id);
        insert cartItem1;
        ccrz__E_CartItem__c cartItem2 = dbu_CouponFactoryDataTest.createCartItem(cart.Id,productObj2.Id);
        insert cartItem2;
        
        Ecom_Coupon__c coupon = dbu_CouponFactoryDataTest.createCoupon('testShipping','Shipping');
        coupon.Ecom_Coupon_Type__c = 'Free Shipping';
        coupon.Ecom_Max_Weight__c = 200.00;
        coupon.Ecom_Min_Weight__c = 10;
        coupon.Ecom_Cart_Total_Amount__c = null;
        coupon.Ecom_Min_Quantity__c = 1;
        insert coupon;
        
        Ecom_Coupon__c couponData =  [SELECT Id,
                                      Ecom_Active__c,
                                      Ecom_Type__c,
                                      Ecom_Max_Weight__c,
                                      Ecom_Min_Weight__c,  
                                      Ecom_Discount_On_Each_Quantity__c,
                                      Ecom_Min_Quantity__c,
                                      Ecom_Customer_Groups__c,
                                      Ecom_Cart_Total_Amount__c,
                                      Ecom_Coupon_Type__c,
                                      CurrencyIsoCode,
                                      Ecom_Include_All_Register_Customers__c,
                                      Ecom_Include_Guest_Customers__c,
                                      Ecom_Rule_Type__c,
                                      Ecom_Start_Date__c,
                                      Ecom_End_Date__c,
                                      Ecom_Store__c,
                                      Ecom_Discount_Amount__c,
                                      (SELECT Id,Ecom_Source_Product__c,Ecom_Source_Quantity__c,Ecom_Target_Product__c,Ecom_Target_Quantity__c,Ecom_Rule_Type__c,Ecom_Coupon_Product_Type__c  FROM Ecom_Coupon_Products__r),
                                      (SELECT Id, Ecom_Source_Category__c,Ecom_Target_Category__c,Ecom_Source_Quantity__c,Ecom_Target_Quantity__c,Ecom_Rule_Type__c,Ecom_Coupon_Category_Type__c FROM Ecom_Coupon_Categories__r),
                                      (SELECT Id,Contact__c,Contact__r.Email,Ecom_Coupon_Contact_Type__c,Ecom_Coupon__c FROM Ecom_Coupon_Contacts__r)
                                      FROM Ecom_Coupon__c 
                                      WHERE Name =:coupon.Name AND Ecom_Active__c = true];
        Test.startTest();  
        dbu_CouponUtility.getCouponInclusionExclusionIds(cart.Id,couponData);
        Test.stopTest(); 
    }
    @isTest
    private static void ruleTypeShippingTest11(){
        
        ccrz__E_Product__c productObj = dbu_FactoryDataTest.createProduct('Test',true, true, true,true);
        insert productObj;
        ccrz__E_Product__c productObj1 = dbu_FactoryDataTest.createProduct('Test product',true, true, true,true);
        productObj1.dbu_Has_Core_Child__c = true;
        productObj1.dbu_Has_Core_Charge__c = true;
        insert productObj1;
        ccrz__E_Product__c productObj2 = dbu_FactoryDataTest.createProduct('Test-product',true, true, true,true);
        insert productObj2;
        
        ccrz__E_Spec__c ccSpec = new ccrz__E_Spec__c();
        ccSpec.Name = 'Shipment Weight';
        ccSpec.ccrz__IsVisibleInCatalog__c = true;
        insert ccSpec;
        
        ccrz__E_ProductSpec__c prodSpec = new ccrz__E_ProductSpec__c();
        prodSpec.ccrz__SpecValue__c = '40 lb';
        prodSpec.ccrz__Product__c = productObj.Id;
        prodSpec.ccrz__Spec__c = ccSpec.Id;
        Insert prodSpec;
        
        ccrz__E_Cart__c cart = dbu_CouponFactoryDataTest.createCart();
        insert cart;
        ccrz__E_CartItem__c cartItem = dbu_CouponFactoryDataTest.createCartItem(cart.Id,productObj.Id);
        insert cartItem;
        ccrz__E_CartItem__c cartItem1 = dbu_CouponFactoryDataTest.createCartItem(cart.Id,productObj1.Id);
        insert cartItem1;
        ccrz__E_CartItem__c cartItem2 = dbu_CouponFactoryDataTest.createCartItem(cart.Id,productObj2.Id);
        insert cartItem2;
        
        Ecom_Coupon__c coupon = dbu_CouponFactoryDataTest.createCoupon('testShipping','Shipping');
        coupon.Ecom_Coupon_Type__c = 'Free Shipping';
        coupon.Ecom_Max_Weight__c = 200.00;
        coupon.Ecom_Min_Weight__c = null;
        coupon.Ecom_Cart_Total_Amount__c = 100.00;
        coupon.Ecom_Min_Quantity__c = 1;
        insert coupon;
        
        Ecom_Coupon__c couponData =  [SELECT Id,
                                      Ecom_Active__c,
                                      Ecom_Type__c,
                                      Ecom_Max_Weight__c,
                                      Ecom_Min_Weight__c, 
                                      Ecom_Discount_On_Each_Quantity__c,
                                      Ecom_Min_Quantity__c,
                                      Ecom_Customer_Groups__c,
                                      Ecom_Cart_Total_Amount__c,
                                      Ecom_Coupon_Type__c,
                                      CurrencyIsoCode,
                                      Ecom_Include_All_Register_Customers__c,
                                      Ecom_Include_Guest_Customers__c,
                                      Ecom_Rule_Type__c,
                                      Ecom_Start_Date__c,
                                      Ecom_End_Date__c,
                                      Ecom_Store__c,
                                      Ecom_Discount_Amount__c,
                                      (SELECT Id,Ecom_Source_Product__c,Ecom_Source_Quantity__c,Ecom_Target_Product__c,Ecom_Target_Quantity__c,Ecom_Rule_Type__c,Ecom_Coupon_Product_Type__c  FROM Ecom_Coupon_Products__r),
                                      (SELECT Id, Ecom_Source_Category__c,Ecom_Target_Category__c,Ecom_Source_Quantity__c,Ecom_Target_Quantity__c,Ecom_Rule_Type__c,Ecom_Coupon_Category_Type__c FROM Ecom_Coupon_Categories__r),
                                      (SELECT Id,Contact__c,Contact__r.Email,Ecom_Coupon_Contact_Type__c,Ecom_Coupon__c FROM Ecom_Coupon_Contacts__r)
                                      FROM Ecom_Coupon__c 
                                      WHERE Name =:coupon.Name AND Ecom_Active__c = true];
        Test.startTest();  
        dbu_CouponUtility.getCouponInclusionExclusionIds(cart.Id,couponData);
        Test.stopTest(); 
    }
    @isTest
    private static void ruleTypeShippingTest12(){
        
        ccrz__E_Product__c productObj = dbu_FactoryDataTest.createProduct('Test',true, true, true,true);
        insert productObj;
        ccrz__E_Product__c productObj1 = dbu_FactoryDataTest.createProduct('Test product',true, true, true,true);
        productObj1.dbu_Has_Core_Child__c = true;
        productObj1.dbu_Has_Core_Charge__c = true;
        insert productObj1;
        ccrz__E_Product__c productObj2 = dbu_FactoryDataTest.createProduct('Test-product',true, true, true,true);
        insert productObj2;
        
        ccrz__E_Spec__c ccSpec = new ccrz__E_Spec__c();
        ccSpec.Name = 'Shipment Weight';
        ccSpec.ccrz__IsVisibleInCatalog__c = true;
        insert ccSpec;
        
        ccrz__E_ProductSpec__c prodSpec = new ccrz__E_ProductSpec__c();
        prodSpec.ccrz__SpecValue__c = '40 lb';
        prodSpec.ccrz__Product__c = productObj.Id;
        prodSpec.ccrz__Spec__c = ccSpec.Id;
        Insert prodSpec;
        
        ccrz__E_Cart__c cart = dbu_CouponFactoryDataTest.createCart();
        insert cart;
        ccrz__E_CartItem__c cartItem = dbu_CouponFactoryDataTest.createCartItem(cart.Id,productObj.Id);
        insert cartItem;
        ccrz__E_CartItem__c cartItem1 = dbu_CouponFactoryDataTest.createCartItem(cart.Id,productObj1.Id);
        insert cartItem1;
        ccrz__E_CartItem__c cartItem2 = dbu_CouponFactoryDataTest.createCartItem(cart.Id,productObj2.Id);
        insert cartItem2;
        
        Ecom_Coupon__c coupon = dbu_CouponFactoryDataTest.createCoupon('testShipping','Shipping');
        coupon.Ecom_Coupon_Type__c = 'Free Shipping';
        coupon.Ecom_Max_Weight__c = null;
        coupon.Ecom_Min_Weight__c = 10.00;
        coupon.Ecom_Cart_Total_Amount__c = 100.00;
        coupon.Ecom_Min_Quantity__c = 1;
        insert coupon;
        
        Ecom_Coupon__c couponData =  [SELECT Id,
                                      Ecom_Active__c,
                                      Ecom_Type__c,
                                      Ecom_Max_Weight__c,
                                      Ecom_Min_Weight__c, 
                                      Ecom_Discount_On_Each_Quantity__c,
                                      Ecom_Min_Quantity__c,
                                      Ecom_Customer_Groups__c,
                                      Ecom_Cart_Total_Amount__c,
                                      Ecom_Coupon_Type__c,
                                      CurrencyIsoCode,
                                      Ecom_Include_All_Register_Customers__c,
                                      Ecom_Include_Guest_Customers__c,
                                      Ecom_Rule_Type__c,
                                      Ecom_Start_Date__c,
                                      Ecom_End_Date__c,
                                      Ecom_Store__c,
                                      Ecom_Discount_Amount__c,
                                      (SELECT Id,Ecom_Source_Product__c,Ecom_Source_Quantity__c,Ecom_Target_Product__c,Ecom_Target_Quantity__c,Ecom_Rule_Type__c,Ecom_Coupon_Product_Type__c  FROM Ecom_Coupon_Products__r),
                                      (SELECT Id, Ecom_Source_Category__c,Ecom_Target_Category__c,Ecom_Source_Quantity__c,Ecom_Target_Quantity__c,Ecom_Rule_Type__c,Ecom_Coupon_Category_Type__c FROM Ecom_Coupon_Categories__r),
                                      (SELECT Id,Contact__c,Contact__r.Email,Ecom_Coupon_Contact_Type__c,Ecom_Coupon__c FROM Ecom_Coupon_Contacts__r)
                                      FROM Ecom_Coupon__c 
                                      WHERE Name =:coupon.Name AND Ecom_Active__c = true];
        Test.startTest();  
        dbu_CouponUtility.getCouponInclusionExclusionIds(cart.Id,couponData);
        Test.stopTest(); 
    }
    @isTest
    private static void ruleTypeShippingTest13(){
        
        ccrz__E_Product__c productObj = dbu_FactoryDataTest.createProduct('Test',true, true, true,true);
        insert productObj;
        ccrz__E_Product__c productObj1 = dbu_FactoryDataTest.createProduct('Test product',true, true, true,true);
        productObj1.dbu_Has_Core_Child__c = true;
        productObj1.dbu_Has_Core_Charge__c = true;
        insert productObj1;
        ccrz__E_Product__c productObj2 = dbu_FactoryDataTest.createProduct('Test-product',true, true, true,true);
        insert productObj2;
        
        ccrz__E_Spec__c ccSpec = new ccrz__E_Spec__c();
        ccSpec.Name = 'Shipment Weight';
        ccSpec.ccrz__IsVisibleInCatalog__c = true;
        insert ccSpec;
        
        ccrz__E_ProductSpec__c prodSpec = new ccrz__E_ProductSpec__c();
        prodSpec.ccrz__SpecValue__c = '40 lb';
        prodSpec.ccrz__Product__c = productObj.Id;
        prodSpec.ccrz__Spec__c = ccSpec.Id;
        Insert prodSpec;
        
        ccrz__E_Cart__c cart = dbu_CouponFactoryDataTest.createCart();
        insert cart;
        ccrz__E_CartItem__c cartItem = dbu_CouponFactoryDataTest.createCartItem(cart.Id,productObj.Id);
        insert cartItem;
        ccrz__E_CartItem__c cartItem1 = dbu_CouponFactoryDataTest.createCartItem(cart.Id,productObj1.Id);
        insert cartItem1;
        ccrz__E_CartItem__c cartItem2 = dbu_CouponFactoryDataTest.createCartItem(cart.Id,productObj2.Id);
        insert cartItem2;
        
        Ecom_Coupon__c coupon = dbu_CouponFactoryDataTest.createCoupon('testShipping','Shipping');
        coupon.Ecom_Coupon_Type__c = 'Free Shipping';
        coupon.Ecom_Max_Weight__c = 200.00;
        coupon.Ecom_Min_Weight__c = null;
        coupon.Ecom_Cart_Total_Amount__c = null;
        coupon.Ecom_Min_Quantity__c = 1;
        insert coupon;
        
        Ecom_Coupon__c couponData =  [SELECT Id,
                                      Ecom_Active__c,
                                      Ecom_Type__c,
                                      Ecom_Max_Weight__c,
                                      Ecom_Min_Weight__c, 
                                      Ecom_Discount_On_Each_Quantity__c,
                                      Ecom_Min_Quantity__c,
                                      Ecom_Customer_Groups__c,
                                      Ecom_Cart_Total_Amount__c,
                                      Ecom_Coupon_Type__c,
                                      CurrencyIsoCode,
                                      Ecom_Include_All_Register_Customers__c,
                                      Ecom_Include_Guest_Customers__c,
                                      Ecom_Rule_Type__c,
                                      Ecom_Start_Date__c,
                                      Ecom_End_Date__c,
                                      Ecom_Store__c,
                                      Ecom_Discount_Amount__c,
                                      (SELECT Id,Ecom_Source_Product__c,Ecom_Source_Quantity__c,Ecom_Target_Product__c,Ecom_Target_Quantity__c,Ecom_Rule_Type__c,Ecom_Coupon_Product_Type__c  FROM Ecom_Coupon_Products__r),
                                      (SELECT Id, Ecom_Source_Category__c,Ecom_Target_Category__c,Ecom_Source_Quantity__c,Ecom_Target_Quantity__c,Ecom_Rule_Type__c,Ecom_Coupon_Category_Type__c FROM Ecom_Coupon_Categories__r),
                                      (SELECT Id,Contact__c,Contact__r.Email,Ecom_Coupon_Contact_Type__c,Ecom_Coupon__c FROM Ecom_Coupon_Contacts__r)
                                      FROM Ecom_Coupon__c 
                                      WHERE Name =:coupon.Name AND Ecom_Active__c = true];
        Test.startTest();  
        dbu_CouponUtility.getCouponInclusionExclusionIds(cart.Id,couponData);
        Test.stopTest(); 
    }
    @isTest
    private static void ruleTypeShippingTest14(){
        
        ccrz__E_Product__c productObj = dbu_FactoryDataTest.createProduct('Test',true, true, true,true);
        insert productObj;
        ccrz__E_Product__c productObj1 = dbu_FactoryDataTest.createProduct('Test product',true, true, true,true);
        productObj1.dbu_Has_Core_Child__c = true;
        productObj1.dbu_Has_Core_Charge__c = true;
        insert productObj1;
        ccrz__E_Product__c productObj2 = dbu_FactoryDataTest.createProduct('Test-product',true, true, true,true);
        insert productObj2;
        
        ccrz__E_Spec__c ccSpec = new ccrz__E_Spec__c();
        ccSpec.Name = 'Shipment Weight';
        ccSpec.ccrz__IsVisibleInCatalog__c = true;
        insert ccSpec;
        
        ccrz__E_ProductSpec__c prodSpec = new ccrz__E_ProductSpec__c();
        prodSpec.ccrz__SpecValue__c = '40 lb';
        prodSpec.ccrz__Product__c = productObj.Id;
        prodSpec.ccrz__Spec__c = ccSpec.Id;
        Insert prodSpec;
        
        ccrz__E_Cart__c cart = dbu_CouponFactoryDataTest.createCart();
        insert cart;
        ccrz__E_CartItem__c cartItem = dbu_CouponFactoryDataTest.createCartItem(cart.Id,productObj.Id);
        insert cartItem;
        ccrz__E_CartItem__c cartItem1 = dbu_CouponFactoryDataTest.createCartItem(cart.Id,productObj1.Id);
        insert cartItem1;
        ccrz__E_CartItem__c cartItem2 = dbu_CouponFactoryDataTest.createCartItem(cart.Id,productObj2.Id);
        insert cartItem2;
        
        Ecom_Coupon__c coupon = dbu_CouponFactoryDataTest.createCoupon('testShipping','Shipping');
        coupon.Ecom_Coupon_Type__c = 'Free Shipping';
        coupon.Ecom_Max_Weight__c = null;
        coupon.Ecom_Min_Weight__c = 10;
        coupon.Ecom_Cart_Total_Amount__c = null;
        coupon.Ecom_Min_Quantity__c = 1;
        insert coupon;
        
        Ecom_Coupon__c couponData =  [SELECT Id,
                                      Ecom_Active__c,
                                      Ecom_Type__c,
                                      Ecom_Max_Weight__c,
                                      Ecom_Min_Weight__c,  
                                      Ecom_Discount_On_Each_Quantity__c,
                                      Ecom_Min_Quantity__c,
                                      Ecom_Customer_Groups__c,
                                      Ecom_Cart_Total_Amount__c,
                                      Ecom_Coupon_Type__c,
                                      CurrencyIsoCode,
                                      Ecom_Include_All_Register_Customers__c,
                                      Ecom_Include_Guest_Customers__c,
                                      Ecom_Rule_Type__c,
                                      Ecom_Start_Date__c,
                                      Ecom_End_Date__c,
                                      Ecom_Store__c,
                                      Ecom_Discount_Amount__c,
                                      (SELECT Id,Ecom_Source_Product__c,Ecom_Source_Quantity__c,Ecom_Target_Product__c,Ecom_Target_Quantity__c,Ecom_Rule_Type__c,Ecom_Coupon_Product_Type__c  FROM Ecom_Coupon_Products__r),
                                      (SELECT Id, Ecom_Source_Category__c,Ecom_Target_Category__c,Ecom_Source_Quantity__c,Ecom_Target_Quantity__c,Ecom_Rule_Type__c,Ecom_Coupon_Category_Type__c FROM Ecom_Coupon_Categories__r),
                                      (SELECT Id,Contact__c,Contact__r.Email,Ecom_Coupon_Contact_Type__c,Ecom_Coupon__c FROM Ecom_Coupon_Contacts__r)
                                      FROM Ecom_Coupon__c 
                                      WHERE Name =:coupon.Name AND Ecom_Active__c = true];
        Test.startTest();  
        dbu_CouponUtility.getCouponInclusionExclusionIds(cart.Id,couponData);
        Test.stopTest(); 
    }
    @isTest
    private static void ruleTypeShippingTest15(){
        
        ccrz__E_Product__c productObj = dbu_FactoryDataTest.createProduct('Test',true, true, true,true);
        insert productObj;
        ccrz__E_Product__c productObj1 = dbu_FactoryDataTest.createProduct('Test product',true, true, true,true);
        productObj1.dbu_Has_Core_Child__c = true;
        productObj1.dbu_Has_Core_Charge__c = true;
        insert productObj1;
        ccrz__E_Product__c productObj2 = dbu_FactoryDataTest.createProduct('Test-product',true, true, true,true);
        insert productObj2;
        
        ccrz__E_Spec__c ccSpec = new ccrz__E_Spec__c();
        ccSpec.Name = 'Shipment Weight';
        ccSpec.ccrz__IsVisibleInCatalog__c = true;
        insert ccSpec;
        
        ccrz__E_ProductSpec__c prodSpec = new ccrz__E_ProductSpec__c();
        prodSpec.ccrz__SpecValue__c = '40 lb';
        prodSpec.ccrz__Product__c = productObj.Id;
        prodSpec.ccrz__Spec__c = ccSpec.Id;
        Insert prodSpec;
        
        ccrz__E_Cart__c cart = dbu_CouponFactoryDataTest.createCart();
        insert cart;
        ccrz__E_CartItem__c cartItem = dbu_CouponFactoryDataTest.createCartItem(cart.Id,productObj.Id);
        insert cartItem;
        ccrz__E_CartItem__c cartItem1 = dbu_CouponFactoryDataTest.createCartItem(cart.Id,productObj1.Id);
        insert cartItem1;
        ccrz__E_CartItem__c cartItem2 = dbu_CouponFactoryDataTest.createCartItem(cart.Id,productObj2.Id);
        insert cartItem2;
        
        Ecom_Coupon__c coupon = dbu_CouponFactoryDataTest.createCoupon('testShipping','Shipping');
        coupon.Ecom_Coupon_Type__c = 'Free Shipping';
        coupon.Ecom_Max_Weight__c = null;
        coupon.Ecom_Min_Weight__c = null;
        coupon.Ecom_Cart_Total_Amount__c = null;
        coupon.Ecom_Min_Quantity__c = 1;
        insert coupon;
        
        Ecom_Coupon__c couponData =  [SELECT Id,
                                      Ecom_Active__c,
                                      Ecom_Type__c,
                                      Ecom_Max_Weight__c,
                                      Ecom_Min_Weight__c,               
                                      Ecom_Min_Quantity__c,
                                      Ecom_Discount_On_Each_Quantity__c,
                                      Ecom_Customer_Groups__c,
                                      Ecom_Cart_Total_Amount__c,
                                      Ecom_Coupon_Type__c,
                                      CurrencyIsoCode,
                                      Ecom_Include_All_Register_Customers__c,
                                      Ecom_Include_Guest_Customers__c,
                                      Ecom_Rule_Type__c,
                                      Ecom_Start_Date__c,
                                      Ecom_End_Date__c,
                                      Ecom_Store__c,
                                      Ecom_Discount_Amount__c,
                                      (SELECT Id,Ecom_Source_Product__c,Ecom_Source_Quantity__c,Ecom_Target_Product__c,Ecom_Target_Quantity__c,Ecom_Rule_Type__c,Ecom_Coupon_Product_Type__c  FROM Ecom_Coupon_Products__r),
                                      (SELECT Id, Ecom_Source_Category__c,Ecom_Target_Category__c,Ecom_Source_Quantity__c,Ecom_Target_Quantity__c,Ecom_Rule_Type__c,Ecom_Coupon_Category_Type__c FROM Ecom_Coupon_Categories__r),
                                      (SELECT Id,Contact__c,Contact__r.Email,Ecom_Coupon_Contact_Type__c,Ecom_Coupon__c FROM Ecom_Coupon_Contacts__r)
                                      FROM Ecom_Coupon__c 
                                      WHERE Name =:coupon.Name AND Ecom_Active__c = true];
        Test.startTest();  
        dbu_CouponUtility.getCouponInclusionExclusionIds(cart.Id,couponData);
        Test.stopTest(); 
    }
    
}