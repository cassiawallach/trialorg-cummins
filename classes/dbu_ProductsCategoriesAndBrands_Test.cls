@isTest
public class dbu_ProductsCategoriesAndBrands_Test {
    
    public static ccrz__E_Category__c createCategory(String categoryName,String categoryID){
        ccrz__E_Category__c category 						= 	new ccrz__E_Category__c();
        category.Name 										= 	categoryName;
        category.ccrz__CategoryID__c 						= 	categoryID;
       	category.Storefront__c 								= 	'CSSNAStore';
        category.ccrz__Sequence__c 							= 	500.0;
        return category;
    }
    
    public static ccrz__E_ProductCategory__c createProductCategory(String subSubCategory,string product){
        ccrz__E_ProductCategory__c productCategory 			= 	new ccrz__E_ProductCategory__c();
        productCategory.ccrz__Product__c 					=	product;
        productCategory.ccrz__Category__c 					=	subSubCategory;
        return productCategory;
    }
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

    @isTest
    public static void getProductCategoryInCartTest(){
        ccrz__E_Product__c productObj = dbu_FactoryDataTest.createProduct('Product Test',true, true, true,true);
        insert productObj;
        ccrz__E_Product__c coreProductObj = dbu_FactoryDataTest.createProduct('Core Product Test',true, true, true,true);
        coreProductObj.dbu_Has_Core_Child__c = true;
        coreProductObj.dbu_Has_Core_Charge__c = true;
        insert coreProductObj;
        
        ccrz__E_Category__c category = createCategory('Cummins Test','1');
        insert category;
       
        ccrz__E_ProductCategory__c productCategory = createProductCategory(category.Id,productObj.id);
        insert productCategory;
        
        ccrz__E_RelatedProduct__c relatedproduct = new ccrz__E_RelatedProduct__c();
        relatedproduct.ccrz__Product__c = productObj.Id;
        relatedproduct.ccrz__RelatedProduct__c = coreProductObj.Id;
        relatedproduct.ccrz__RelatedProductType__c = 'Core Charge';
        insert relatedproduct;
        
        //ccrz__E_Cart__c cart = dbu_CouponFactoryDataTest.createCart();
        ccrz__E_Cart__c cart 								= 	new ccrz__E_Cart__c();
        cart.dbu_storeLanguage__c 							= 	'US';
        cart.ccrz__CartStatus__c 							= 	'Open';
        cart.ccrz__CartType__c 								= 	'Cart';
        cart.ccrz__ActiveCart__c 							= 	true;
        cart.ccrz__TotalDiscount__c 						= 	20.00;
        cart.ccrz__Name__c 									= 	'Test Cart';
        cart.ccrz__Storefront__c 							= 	'CSSNAStore';
        //cart.ccrz__Account__c 							= 	objAcc.Id;        
        insert cart;
        
        ccrz__E_CartItem__c cartItem1 = createCartItem(cart.Id,productObj.Id);
        insert cartItem1;
        
        ccrz__E_CartItem__c cartItem = createCartItem(cart.Id,coreProductObj.Id);
        insert cartItem;
        String UrlPram = 'https://csodev-cumminscss.cs90.force.com/CSSNAStore/s/order?cartId='+cart.Id+'&store=US#no-back-button';
        Test.startTest();  
        dbu_ProductsCategoriesAndBrands.getProductCategoryInCart(UrlPram);
        Test.stopTest(); 
    }
}