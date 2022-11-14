@isTest
private class dbu_CouponServiceHandler_Test {
   @isTest
    private static void updateCartwithCouponDetailsTest1(){
        ccrz__E_Cart__c cart = dbu_CouponFactoryDataTest.createCart();
        insert cart;
        ccrz__E_CartItem__c cartItem = dbu_CouponFactoryDataTest.createCartItem(cart.Id,null);
        insert cartItem;
        Ecom_Coupon__c coupon = dbu_CouponFactoryDataTest.createCoupon('test','Cart Total');
        insert coupon;
        Test.startTest();  
        dbu_CouponServiceHandler.updateCartwithCouponDetails(cart.Id,'test');
        Test.stopTest(); 
    }
    @isTest
    private static void updateCartwithCouponDetailsTest2(){
        ccrz__E_Cart__c cart = dbu_CouponFactoryDataTest.createCart();
        insert cart;
        ccrz__E_CartItem__c cartItem = dbu_CouponFactoryDataTest.createCartItem(cart.Id,null);
        insert cartItem;
        Ecom_Coupon__c coupon = dbu_CouponFactoryDataTest.createCoupon('test','Cart Total');
        coupon.Ecom_Include_All_Register_Customers__c = false;
        insert coupon;
        Test.startTest();  
        dbu_CouponServiceHandler.updateCartwithCouponDetails(cart.Id,'test');
        Test.stopTest(); 
    }
    @isTest
    private static void updateCartwithCouponDetailsTest3(){
        ccrz__E_Cart__c cart = dbu_CouponFactoryDataTest.createCart();
        insert cart;
        ccrz__E_CartItem__c cartItem = dbu_CouponFactoryDataTest.createCartItem(cart.Id,null);
        insert cartItem;
        Ecom_Coupon__c coupon = dbu_CouponFactoryDataTest.createCoupon('test','Cart Total');
        coupon.Ecom_Include_All_Register_Customers__c = false;
        coupon.Ecom_Include_Guest_Customers__c = false;
        insert coupon;
        Test.startTest();  
        dbu_CouponServiceHandler.updateCartwithCouponDetails(cart.Id,'test');
        Test.stopTest(); 
    }
    @isTest
    private static void updateCartwithCouponDetailsTest4(){
        ccrz__E_Cart__c cart = dbu_CouponFactoryDataTest.createCart();
        insert cart;
        ccrz__E_CartItem__c cartItem = dbu_CouponFactoryDataTest.createCartItem(cart.Id,null);
        insert cartItem;
        Ecom_Coupon__c coupon = dbu_CouponFactoryDataTest.createCoupon('test','General');
        coupon.Ecom_Include_All_Register_Customers__c = false;
        coupon.Ecom_Include_Guest_Customers__c = false;
        insert coupon;
        Test.startTest();  
        dbu_CouponServiceHandler.updateCartwithCouponDetails(cart.Id,'test');
        Test.stopTest(); 
    }
    @isTest
    private static void updateCartwithCouponDetailsTest5(){
        ccrz__E_Cart__c cart = dbu_CouponFactoryDataTest.createCart();
        insert cart;
        ccrz__E_CartItem__c cartItem = dbu_CouponFactoryDataTest.createCartItem(cart.Id,null);
        insert cartItem;
        Ecom_Coupon__c coupon = dbu_CouponFactoryDataTest.createCoupon('test','General');
        coupon.Ecom_Active__c = false;
        coupon.Ecom_Include_All_Register_Customers__c = false;
        coupon.Ecom_Include_Guest_Customers__c = false;
        insert coupon;
        Test.startTest();  
        dbu_CouponServiceHandler.updateCartwithCouponDetails(cart.Id,'test');
        Test.stopTest(); 
    }
    @isTest
    private static void removeAppliedCouponTest(){
        ccrz__E_Cart__c cart = dbu_CouponFactoryDataTest.createCart();
        insert cart;
        ccrz__E_CartItem__c cartItem = dbu_CouponFactoryDataTest.createCartItem(cart.Id,null);
        insert cartItem;
        Ecom_Coupon__c coupon = dbu_CouponFactoryDataTest.createCoupon('test','General');
        insert coupon;
        Ecom_Cart_Coupon__c cartCoupon = dbu_CouponFactoryDataTest.createCouponCart(cart.Id,coupon.Id);
        insert cartCoupon;
        Test.startTest();  
        dbu_CouponServiceHandler.removeAppliedCoupon(cart.Id);
        Test.stopTest(); 
    }
    
    @isTest
    private static void freeShipping(){
        ccrz__E_Cart__c cart = dbu_CouponFactoryDataTest.createCart();
        insert cart;
        ccrz__E_CartItem__c cartItem = dbu_CouponFactoryDataTest.createCartItem(cart.Id,null);
        insert cartItem;
        Ecom_Coupon__c coupon = dbu_CouponFactoryDataTest.createCoupon('test','Shipping');
        coupon.Ecom_Include_All_Register_Customers__c = false;
        coupon.Ecom_Include_Guest_Customers__c = false;
        insert coupon;
        Test.startTest();  
        dbu_CouponServiceHandler.updateCartwithCouponDetails(cart.Id,'test');
        Test.stopTest(); 
    }
    
    @isTest
    private static void couponExpired(){
        ccrz__E_Cart__c cart = dbu_CouponFactoryDataTest.createCart();
        insert cart;
        ccrz__E_CartItem__c cartItem = dbu_CouponFactoryDataTest.createCartItem(cart.Id,null);
        insert cartItem;
        Ecom_Coupon__c coupon = dbu_CouponFactoryDataTest.createCoupon('test','General');
        coupon.Ecom_Start_Date__c = Datetime.now() - 5;
        coupon.Ecom_End_Date__c  = Datetime.now() - 1;
        coupon.Ecom_Include_All_Register_Customers__c = false;
        coupon.Ecom_Include_Guest_Customers__c = false;
        insert coupon;
        Test.startTest();  
        dbu_CouponServiceHandler.updateCartwithCouponDetails(cart.Id,'test');
        Test.stopTest(); 
    }
    
    @isTest
    private static void couponMaxUsed(){
        ccrz__E_Cart__c cart = dbu_CouponFactoryDataTest.createCart();
        insert cart;
        ccrz__E_CartItem__c cartItem = dbu_CouponFactoryDataTest.createCartItem(cart.Id,null);
        insert cartItem;
        Ecom_Coupon__c coupon = dbu_CouponFactoryDataTest.createCoupon('test','General');
        coupon.Ecom_Coupon_Used__c = 5;
        coupon.Ecom_Coupon_Max_Usage__c  = 4;
        coupon.Ecom_Include_All_Register_Customers__c = false;
        coupon.Ecom_Include_Guest_Customers__c = false;
        insert coupon;
        Test.startTest();  
        dbu_CouponServiceHandler.updateCartwithCouponDetails(cart.Id,'test');
        Test.stopTest(); 
    } 
}