@isTest
private class dbu_CouponProductUtility_Test {

    @isTest
    public static void getCouponProductsTest(){
        Ecom_Coupon__c coupon = dbu_CouponFactoryDataTest.createCoupon('test','Cart Total');
        coupon.Ecom_Coupon_Type__c = 'Percentage';
        insert coupon;
        ccrz__E_Product__c productObj = dbu_FactoryDataTest.createProduct('Test',true, true, true,true);
        insert productObj;
        Ecom_Coupon_Product__c couponProduct = dbu_CouponFactoryDataTest.createCouponProduct(coupon.Id,'Exclusion');
        couponProduct.Ecom_Source_Product__c = productObj.Id;
        insert couponProduct;
        List<Ecom_Coupon_Product__c> couponProductList = new List<Ecom_Coupon_Product__c>();
        couponProductList.add(couponProduct);
        
        Test.startTest(); 
        dbu_CouponProductUtility.getCouponProducts(couponProductList);
        Test.stopTest();
    }
}