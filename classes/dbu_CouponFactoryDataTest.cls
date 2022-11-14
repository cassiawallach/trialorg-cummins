/**
 * @description       : 
 * @author            : HCL team
 * @group             : 
 * @last modified on  : 09-15-2022 
 * @last modified by  : HCL team
**/
@isTest
public class dbu_CouponFactoryDataTest {

    // Get Coupon Object
    public static Ecom_Coupon__c createCoupon(String couponName,String ruleType){
        Ecom_Coupon__c coupon 								= 	new Ecom_Coupon__c();
        coupon.Name 										= 	couponName;
        coupon.Ecom_Active__c 								= 	true;
        coupon.Ecom_Type__c 								= 	'Coupon';
        coupon.Ecom_Cart_Total_Amount__c 					= 	100.00;
        coupon.CurrencyIsoCode 								= 	'USD';
        coupon.Ecom_Include_All_Register_Customers__c 		= 	true;
        coupon.Ecom_Include_Guest_Customers__c 				= 	true;
        coupon.Ecom_Rule_Type__c 							= 	ruleType;
        coupon.Ecom_Start_Date__c 							= 	Datetime.now();
        coupon.Ecom_End_Date__c 							= 	Datetime.now() + 1;
        coupon.Ecom_Store__c 								= 	'United States';
        coupon.Ecom_Discount_Amount__c 						= 	10.00;
        return coupon;
    }
    // Get Coupon related Product Object
    public static Ecom_Coupon_Product__c createCouponProduct(String couponId,String productType){
        
        Ecom_Coupon_Product__c couponProduct 				= 	new Ecom_Coupon_Product__c();
        couponProduct.Ecom_Coupon__c 						= 	couponId;
        //couponProduct.Ecom_Source_Product__c 				= 	productObj.Id;
        couponProduct.Ecom_Source_Quantity__c 				= 	5;
        //couponProduct.Ecom_Target_Product__c 				= 	'';
        couponProduct.Ecom_Target_Quantity__c 				= 	6;
        couponProduct.Ecom_Rule_Type__c 					= 	'Normal';
        couponProduct.Ecom_Coupon_Product_Type__c 			= 	productType;
        return couponProduct;
    }
    // Get Coupon related Category Object
    public static Ecom_Coupon_Category__c createCouponCategory(String couponId,String categoryType, string categoryId){
        Ecom_Coupon_Category__c couponCategory 				= 	new Ecom_Coupon_Category__c();
        couponCategory.Ecom_Coupon__c 						= 	couponId;
        couponCategory.Ecom_Source_Category__c 				= 	categoryId;
        //couponCategory.Ecom_Target_Category__c 			= 	'';
        couponCategory.Ecom_Source_Quantity__c 				= 	5;
       // couponCategory.Ecom_Target_Quantity__c 			= 	7;
        couponCategory.Ecom_Rule_Type__c 					= 	'Normal';
        couponCategory.Ecom_Coupon_Category_Type__c 		= 	categoryType;
        return couponCategory;
    }
    // Get Coupon related Contact Object
    public static Ecom_Coupon_Contact__c createCouponContact(String couponId, String contactType){
        Ecom_Coupon_Contact__c couponContact 				= 	new Ecom_Coupon_Contact__c();
        couponContact.Contact__c 							=	dbu_FactoryDataTest.createIAMContact('fName', 'lName',dbu_FactoryDataTest.createIAMAccount('Test Account' , null).id,null).id;
        couponContact.Ecom_Coupon_Contact_Type__c 			= 	contactType;
        couponContact.Ecom_Coupon__c 						= 	couponId;
        return couponContact;
    }
    // Get  Cart Object
    public static ccrz__E_Cart__c createCart(){
        ccrz__E_Cart__c cart 								= 	new ccrz__E_Cart__c();
        cart.dbu_storeLanguage__c 							= 	'US';
        cart.ccrz__CartStatus__c 							= 	'Open';
        cart.ccrz__CartType__c 								= 	'Cart';
        cart.ccrz__ActiveCart__c 							= 	true;
        cart.ccrz__TotalDiscount__c 						= 	20.00;
        cart.ccrz__Name__c 									= 	'Test Cart';
        cart.ccrz__Storefront__c 							= 	'CSSNAStore';
        //cart.ccrz__Account__c 							= 	objAcc.Id;
        return cart;
    }
    // Get  CartItem Object
    public static ccrz__E_CartItem__c createCartItem(String cartId, String productObj){
    
        ccrz__E_CartItem__c cartitem = new ccrz__E_CartItem__c();
        cartitem.ccrz__ProductType__c 						=	'Product';
        cartitem.ccrz__UnitOfMeasure__c						=	'Each';
        cartitem.ccrz__StoreID__c 							= 	'CSSNAStore';
        cartitem.ccrz__Cart__c								= 	cartId;
        cartitem.ccrz__Quantity__c							= 	4.00;
        cartitem.ccrz__Product__c 							=	productObj;
        cartitem.ccrz__Price__c								= 	100.00;
        cartitem.ccrz__SubAmount__c							= 	400.00;
       	return cartitem;
    }
    //Get Category Object
    public static ccrz__E_Category__c createCategory(String categoryName,String categoryID){
        ccrz__E_Category__c category 						= 	new ccrz__E_Category__c();
        category.Name 										= 	categoryName;
        category.ccrz__CategoryID__c 						= 	categoryID;
       	category.Storefront__c 								= 	'CSSNAStore';
        category.ccrz__Sequence__c 							= 	500.0;
      //  category.ccrz__ParentCategory__c 					=	'';
        return category;
    }
    
    // Get Product Category Object
    public static ccrz__E_ProductCategory__c createProductCategory(String subSubCategory,string product){
    //  ccrz__E_Product__c product =   dbu_FactoryDataTest.createProduct('Test',true, true, true,true);
     //   insert product;
        ccrz__E_ProductCategory__c productCategory 			= 	new ccrz__E_ProductCategory__c();
        productCategory.ccrz__Product__c 					=	product;
        productCategory.ccrz__Category__c 					=	subSubCategory;
        return productCategory;
    }
    // Get Coupon Cart Object
    public static Ecom_Cart_Coupon__c createCouponCart(String cartId,String couponId){
        Ecom_Cart_Coupon__c cartCoupon = new Ecom_Cart_Coupon__c();
        cartCoupon.CC_Cart__c = cartId;
        cartCoupon.Ecom_Coupon__c = couponId;
        return cartCoupon;
    }
  
}