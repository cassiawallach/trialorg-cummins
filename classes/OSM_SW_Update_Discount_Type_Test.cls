@istest
public class OSM_SW_Update_Discount_Type_Test {
    
    testmethod static void testupdatediscounttype(){
        TestProductSetupReq testProductSetupReq1 = OSM_TestDataCreationUtility.populatedTestProductSetupReq();
        TestCompletedTransactionSetUpRes testCompletedTransactionSetUpRes1 = OSM_TestDataCreationUtility.createProductSetUp(testProductSetupReq1);
        ccrz__E_Coupon__c coupon = new ccrz__E_Coupon__c();
            coupon.ccrz__CouponCode__c = Label.VOTECH100OFFINSITE;
            coupon.ccrz__CouponName__c = 'testName';
            coupon.ccrz__MaxUse__c = 12;
            coupon.ccrz__TotalUsed__c = 1;
            coupon.ccrz__DiscountAmount__c = 10;
            coupon.ccrz__CouponType__c ='Price';
            coupon.ccrz__RuleType__c = 'General';
            coupon.ccrz__TargetQty__c = 5;
            coupon.ccrz__TargetRelation__c = 'Product';
            coupon.ccrz__TargetProduct__c = TestCompletedTransactionSetUpRes1.objSetupDate.compositeProduct.Id;
            coupon.ccrz__Storefront__c='SoftwareStore';
            insert coupon;
        
    }

}