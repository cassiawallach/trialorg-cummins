@isTest
private class dbu_CouponContactUtility_Test {
    
    @isTest
    public static void getCouponContactsTest(){
        
         Ecom_Coupon__c coupon = dbu_CouponFactoryDataTest.createCoupon('test','Cart Total');
        insert coupon;
        
        List<Ecom_Coupon_Contact__c> listEcomContactInclusion = new List<Ecom_Coupon_Contact__c>();
        Ecom_Coupon_Contact__c ecomContactInclusion =  dbu_CouponFactoryDataTest.createCouponContact(coupon.Id,'Inclusion');
        listEcomContactInclusion.add(ecomContactInclusion);
        insert listEcomContactInclusion;
        
         List<Ecom_Coupon_Contact__c> listEcomContactExclusion = new List<Ecom_Coupon_Contact__c>();
        Ecom_Coupon_Contact__c ecomContactExclusion =  dbu_CouponFactoryDataTest.createCouponContact(coupon.Id,'Exclusion');
        listEcomContactExclusion.add(ecomContactExclusion);
        insert listEcomContactExclusion;
        
        Test.startTest();  
        dbu_CouponContactUtility.getCouponContacts(listEcomContactInclusion);
        dbu_CouponContactUtility.getCouponContacts(listEcomContactExclusion);
        Test.stopTest();
        
    }
    


}