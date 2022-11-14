//Subbu test class update
@isTest
public class OSM_SW_OrderItemTriggerHandler_Test{
    static testmethod void testOrderItemTriggerHandler(){
        ccrz__E_Product__c prod = new ccrz__E_Product__c();
        prod.name = 'Service Tech Kit';
        prod.ccrz__SKU__c = '15458771';
        prod.ccrz__Quantityperunit__c = 3343;
        prod.ccrz__StartDate__c = system.today();
        prod.ccrz__EndDate__c = system.today()+1;
        prod.ccrz__ShortDesc__c = 'testing';
        prod.ccrz__ProductType__c = 'Add-On';
        prod.Group_Name__c = 'FluidWatch';
        insert prod;
        
        ccrz__E_Order__c ord = new ccrz__E_Order__c();
        ord.ccrz__OrderNumber__c = 2323444;
        insert ord;

        ccrz__E_Coupon__c coupon = new ccrz__E_Coupon__c();
            coupon.ccrz__CouponCode__c = 'TESTCOUPONTEST';
            coupon.ccrz__CouponName__c = 'testName';
            coupon.ccrz__MaxUse__c = 12;
            coupon.ccrz__TotalUsed__c = 1;
            coupon.ccrz__DiscountAmount__c = 10;
            coupon.ccrz__CouponType__c ='Price';
            coupon.ccrz__DiscountType__c  ='Price';
            coupon.ccrz__RuleType__c = 'General';
            coupon.ccrz__TargetQty__c = 5;
            coupon.ccrz__TargetRelation__c = 'Product';
            coupon.ccrz__TargetProduct__c = prod.Id;
            //coupon.OSM_Coupon_Discount_Target_Type__c='MSRP';
            //coupon.Subscription_Migration_Coupon__c = false;
            coupon.ccrz__Storefront__c='SoftwareStore';
            insert coupon;
        
        
        List<ccrz__E_OrderItem__c >itemList = new list <ccrz__E_OrderItem__c >();
        ccrz__E_OrderItem__c orditem = new ccrz__E_OrderItem__c();
        orditem.ccrz__Order__c = ord.id;
        orditem.ccrz__Price__c = 10;
        orditem.ccrz__Quantity__c =1;
        orditem.ccrz__SubAmount__c = 5;
        orditem.ccrz__OrderItemId__c = 'a1N4C000000IYOfUAO';
        orditem.ccrz__Product__c = prod.id;
        orditem.ccrz__Coupon__c = coupon.id;
        orditem.OSM_SW_Coupon_Applied__c=true;
        itemList.add(orditem);
        insert itemList;

        ccrz__E_Cart__c cart = new ccrz__E_Cart__c();
        cart.ccrz__Storefront__c = 'SoftwareStore';
        insert cart;

        List<ccrz__E_CartItem__c> cartitemList = new List<ccrz__E_CartItem__c>();
        ccrz__E_CartItem__c cartitem = new ccrz__E_CartItem__c();
        cartitem.ccrz__Cart__c = cart.id;
        cartitem.ccrz__Price__c = 10;
        cartitemList.add (cartitem);
        //update cartitemList;

        Test.starttest();
        //  OSM_SW_OrderItemTriggerHandler contr  = new OSM_SW_OrderItemTriggerHandler();
        OSM_SW_OrderItemTriggerHandler.OnAfterInsert(itemList);
      //  OSM_SW_OrderItemTriggerHandler.onAfterUpdate(itemList); Mar-1266
        List<ccrz__E_OrderItem__c> cc = [select id,ccrz__OrderItemStatus__c from ccrz__E_OrderItem__c where id=: itemList[0].Id];
        cc[0].ccrz__OrderItemStatus__c='Cancelled';
        update cc;
        Test.stoptest();
    }
}