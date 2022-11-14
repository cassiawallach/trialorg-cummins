public class dbu_CouponProductUtility {

     public static Map<String,Set<String>> getCouponProducts(List<Ecom_Coupon_Product__c> CouponProduct){
        
        set<String> productInclusionList = new Set<String>();
         Set<String> productExclusionList = new Set<String>();
         Map<String,Set<String>> productMap = new Map<String,Set<String>>();
         for(Ecom_Coupon_Product__c couponProductObj : CouponProduct){
             if(couponProductObj.Ecom_Coupon_Product_Type__c == 'Inclusion'){
                 productInclusionList.add(couponProductObj.Ecom_Source_Product__c);
             }else if(couponProductObj.Ecom_Coupon_Product_Type__c == 'Exclusion'){
                 productExclusionList.add(couponProductObj.Ecom_Source_Product__c);
             }
         }
         productMap.put('Inclusion',productInclusionList);
         productMap.put('Exclusion',productExclusionList);
       
        return productMap;
    }
    
  /*  public static List<BogoProducts> getBOGOProducts(List<Ecom_Coupon_Product__c> CouponProduct){
        List<BogoProducts> bogoProductsList = new List<BogoProducts>();
        for(Ecom_Coupon_Product__c couponProductObj : CouponProduct){
            if(couponProductObj.Ecom_Coupon_Product_Type__c == 'Inclusion'){
                BogoProducts bogoProducts = new BogoProducts();
                bogoProducts.sourceProductId = couponProductObj.Ecom_Source_Product__c;
                bogoProducts.sourceProductQty = couponProductObj.Ecom_Source_Quantity__c;
                bogoProducts.targetProductId = couponProductObj.Ecom_Target_Product__c;
                bogoProducts.targetProductQty = couponProductObj.Ecom_Target_Quantity__c;
                bogoProducts.discount = couponProductObj.Ecom_Product_Discount_Amount__c;
                bogoProducts.productCartAmnt = couponProductObj.Ecom_Product_Cart_Amount__c;
                bogoProductsList.add(bogoProducts);
            }
        }
        return bogoProductsList;
    }*/
    public class BogoProducts{
        public String sourceProductId;
        public Decimal sourceProductQty;
        public String targetProductId;
        public Decimal targetProductQty;
        public Decimal discount; 
        public Decimal productCartAmnt;
    }
}