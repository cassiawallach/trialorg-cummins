/**********************************************************************
Name:  OSM_SW_Update_Discount_Type
Copyright © 2020  Cummins
======================================================
======================================================
Purpose:                                                            
The purpose of this is to update discount type field value as part of MAR-345                                 
======================================================
======================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE              DETAIL                                
1.0 -    Nandigam Sasi     19/08/2020         INITIAL DEVELOPMENT          
*****************************************************/
trigger OSM_SW_Update_Discount_Type on ccrz__E_Coupon__c (before insert, before update) {
    
    if(trigger.isBefore && (trigger.isInsert||trigger.isupdate)){
       for(ccrz__E_Coupon__c rec:trigger.new){
         if(rec.ccrz__CouponType__c!=null && rec.ccrz__CouponType__c!=' ')
         rec.ccrz__DiscountType__c=rec.ccrz__CouponType__c;
      } 
    }
     
}