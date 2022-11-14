@isTest
private class dbu_CouponCategoryUtility_Test {

    @isTest
    private static void getCouponCategoriesTest(){
        
        ccrz__E_Product__c productObj = dbu_FactoryDataTest.createProduct('Test',true, true, true,true);
        insert productObj;
        
        ccrz__E_Cart__c cart = dbu_CouponFactoryDataTest.createCart();
        insert cart;
        
        List<ccrz__E_CartItem__c> listCartItems = new List<ccrz__E_CartItem__c>();
        ccrz__E_CartItem__c cartItem = dbu_CouponFactoryDataTest.createCartItem(cart.Id,productObj.Id);
        listCartItems.add(cartItem);
        insert listCartItems;
        
        Ecom_Coupon__c coupon = dbu_CouponFactoryDataTest.createCoupon('test','Cart Total');
        insert coupon;
        
        
        ccrz__E_Category__c category =  dbu_CouponFactoryDataTest.createCategory('Cummins','1');
        insert category;
        
          ccrz__E_Category__c subCategory =  dbu_CouponFactoryDataTest.createCategory('Cummins Batteries','2');
        subCategory.ccrz__ParentCategory__c = category.Id;
        insert subCategory;
        
          ccrz__E_Category__c subSubCategory =  dbu_CouponFactoryDataTest.createCategory('Batteries','3');
        subSubCategory.ccrz__ParentCategory__c = subCategory.Id;
        insert subSubCategory;
        
       // List<ccrz__E_ProductCategory__c> listProductCategory = new List<ccrz__E_ProductCategory__c>();
        ccrz__E_ProductCategory__c productCategory =  dbu_CouponFactoryDataTest.createProductCategory(subSubCategory.Id,productObj.Id);
        insert productCategory;
        
         List<Ecom_Coupon_Category__c>  listCouponCategory = new List<Ecom_Coupon_Category__c>();
        Ecom_Coupon_Category__c couponCategory = dbu_CouponFactoryDataTest.createCouponCategory(coupon.Id,'Inclusion',category.Id);
        listCouponCategory.add(couponCategory);
        insert listCouponCategory;
        
        Test.startTest();  
        dbu_CouponCategoryUtility.getCouponCategories(listCouponCategory,listCartItems);
        Test.stopTest(); 
    }
}