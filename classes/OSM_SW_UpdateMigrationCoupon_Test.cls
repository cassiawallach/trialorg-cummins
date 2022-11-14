@istest
//updated by sangeeta on 21st May
public class OSM_SW_UpdateMigrationCoupon_Test {
    static testMethod void OSM_Email_ProductLine(){
        
        ccrz__E_Product__c prod = new ccrz__E_Product__c();
        prod.name = 'Connected Advisor';
        prod.ccrz__SKU__c = '15458776';
        prod.ccrz__Quantityperunit__c = 3343;
        prod.ccrz__StartDate__c = system.today();
        prod.ccrz__EndDate__c = system.today()+1;
        prod.ccrz__ShortDesc__c = 'testing';
        insert prod;
        ccrz__E_Coupon__c coupon = new ccrz__E_Coupon__c();
        coupon.ccrz__CouponCode__c = Label.VOTECH100OFFINSITE;
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
        coupon.Subscription_Migration_Coupon__c = true;
        coupon.ccrz__Storefront__c='SoftwareStore';
        insert coupon;
        Account portalAccount2 = new Account(
            Name = 'TestAccount2',
            Type= 'Distributor Branch Account',
            OSM_Preferred_Billing_Frequency_Lock__c=false,
            BMS_Customer_ID__c='1234',
            OSM_Preferred_Payment_Method__c='po',
            OSM_Preferred_Payment_IsBolt_PO__c=false,
            IAM_Service_Provider_Code__c='123'
        );
        
        Database.insert(portalAccount2);
        
          Contact contact1 = new Contact();
            contact1.FirstName = 'Test';
            contact1.Lastname = 'McTesty';
            contact1.IAM_Contact_Status__c='Pending';
            contact1.Username__c = 'testUserName9980@gmail.com';
            contact1.AccountId = portalAccount2.Id;
            contact1.Email ='test@test.com';
            insert contact1; 
            
            
        List<ccrz__E_Order__c> ordList = new List<ccrz__E_Order__c>();
        ccrz__E_Order__c ord = new ccrz__E_Order__c();
        ord.ccrz__OrderStatus__c = 'Order Submitted' ;
        ord.ByPassFlow__c = true;
        ord.ccrz__Account__c=portalAccount2.id;
        ord.ccrz__Contact__c=contact1.id;
        ordList.add(ord);
        insert ordList;
        
        List<ccrz__E_OrderItem__c> ordItemLst = new List<ccrz__E_OrderItem__c>();
        ccrz__E_OrderItem__c orditem = new ccrz__E_OrderItem__c();
        orditem.ccrz__Quantity__c = 1;
        orditem.ccrz__DisplayProduct__c  = prod.id;
        orditem.ccrz__Price__c = 30;
        orditem.ccrz__SubAmount__c = 50;
        orditem.ccrz__AdjustmentAmount__c =100;
        ordItem.ccrz__Coupon__c = coupon.id;
        ordItem.OSM_SW_Coupon_Applied__c=true;
        orditem.Vertex_Tax__c = 2;
        orditem.ccrz__OrderItemStatus__c ='Order Submitted';   
        orditem.Date_Revoke__c = date.today();
        orditem.ccrz__Product__c = prod.id;
        orditem.ccrz__Order__c  = ordList[0].Id;
        ordItemLst.add(orditem);
        insert ordItemLst;
        orditem.ccrz__OrderItemStatus__c ='Cancelled';
        update ordItemLst;
        List<ccrz__E_OrderItem__c> ordItemLst1 = new List<ccrz__E_OrderItem__c>();
        ccrz__E_OrderItem__c orditem1 = new ccrz__E_OrderItem__c();
        orditem1.ccrz__Quantity__c = 1;
        orditem1.ccrz__DisplayProduct__c  = prod.id;
        orditem1.ccrz__Price__c = 30;
        orditem1.ccrz__SubAmount__c = 50;
        orditem.ccrz__AdjustmentAmount__c =200;
        orditem1.Vertex_Tax__c = 2;
        orditem1.ccrz__OrderItemStatus__c ='Order Submitted';        
        orditem1.Date_Revoke__c = date.today();
        orditem1.ccrz__Product__c = prod.id;
        ordItem.ccrz__Coupon__c = coupon.id;
        ordItem.OSM_SW_Coupon_Applied__c=true;
        orditem1.ccrz__Order__c  = ordList[0].Id;
        ordItemLst1.add(orditem1);
        insert ordItemLst1;
        orditem1.ccrz__OrderItemStatus__c ='Cancelled';
        update ordItemLst1;
        List<ccrz__E_Subscription__c> subList = new List<ccrz__E_Subscription__c>();
        ccrz__E_Subscription__c sub = new ccrz__E_Subscription__c();
        sub.OSM_Display_Product__c = prod.id;
        sub.ccrz__SubscriptionProduct__c = prod.id;
        sub.ccrz__Quantity__c = 10;
        sub.ccrz__Sequence__c = 2;
        sub.ccrz__Storefront__c = 'SoftwareStore';
        sub.ccrz__SubscriptionStartDate__c  = system.today();
        sub.ccrz__SubscriptionStatus__c = 'Active';
        sub.ccrz__CCOrderItem__c = ordItemLst[0].Id;
        sub.OSM_Subscription_End_Date__c = system.now()+2;
        subList.add(sub);
        insert subList;  
    }
    
}