public class OSM_SW_UpdateMigrationCoupon {
    
    @InvocableMethod(label='Update Migration Coupon' description='Update Migration coupon should be available to use after a purchase that used it has been cancelled. ')
    public static void Updatecouponcode(List<Id> orderItemIds){
        ccrz__E_Order__c objOrder  =[select id from ccrz__E_Order__c limit 1 ];
        
        list<id> accountids = new list<id>();
        Set<String> couponNames=new Set<String>();
        List<ccrz__E_OrderItem__c> orderitems =[select id,ccrz__Coupon__c,ccrz__Order__c,ccrz__Order__r.ccrz__Account__c,OSM_SW_Coupon_Applied__c,ccrz__Coupon__r.Subscription_Migration_Coupon__c,ccrz__Coupon__r.ccrz__CouponCode__c,ccrz__OrderItemStatus__c from ccrz__E_OrderItem__c where id IN:orderItemIds and OSM_SW_Coupon_Applied__c=true];
       
        for(ccrz__E_OrderItem__c item :orderitems){
            if(item.ccrz__Coupon__c !=null && item.ccrz__Coupon__r.Subscription_Migration_Coupon__c){
                accountids.add(item.ccrz__Order__r.ccrz__Account__c);
                couponNames.add(item.ccrz__Coupon__r.ccrz__CouponCode__c);
            }
        }
        if(accountids.size()>0){
           try{
                list<account> accounts =[select id,Is_Coupon_Already_Used__c from account where id IN:accountids];
                List<OSM_Accounts_Coupon_Details__c> couponCustomerDetailsList=new List<OSM_Accounts_Coupon_Details__c>();
                for(account acc :accounts)
                {
                    acc.Is_Coupon_Already_Used__c=false;  
                    couponCustomerDetailsList=[select id,Customer_Name__c,Coupon_Code__c,Date_Generated__c,Is_Coupon_Used__c from OSM_Accounts_Coupon_Details__c where Customer_Name__c=:acc.id];
                    if(couponCustomerDetailsList!=null && couponCustomerDetailsList.size()>0)
                    {
                        for(OSM_Accounts_Coupon_Details__c couponDet:couponCustomerDetailsList)
                        {
                           if(couponNames.contains(couponDet.Coupon_Code__c))
                            couponDet.Is_Coupon_Used__c=false;
                        }
                    }
                }     
                update accounts;
               
                if(couponCustomerDetailsList!=null && couponCustomerDetailsList.size()>0)
                update couponCustomerDetailsList;
                
            }catch(exception ex){
                
            }
        }
      }

}