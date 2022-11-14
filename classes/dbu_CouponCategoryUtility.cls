public class dbu_CouponCategoryUtility {
    public static List<CategoryWrapper> categoryList = new List<CategoryWrapper>();
    public static Map<String,Set<String>> getCouponCategories(List<Ecom_Coupon_Category__c> couponCategoryList,List<ccrz__E_CartItem__c> cartItems){
        Set<String> categoryIdList = new Set<String>();
        Set<String> producIdList = new Set<String>();
        Set<String> productIdExclusionList = new Set<String>();
        Set<String> productIdInclusionList = new Set<String>();
        Map<String,CategoryWrapper> categoryWrapperMap = new Map<String,CategoryWrapper>();
        List<ccrz__E_ProductCategory__c> productCategoryList;
        Map<String,String> categoryMap = new Map<String,String>();
        Map<String,Set<String>> categorywithroductIdsMap = new Map<String,Set<String>>();
        
        system.debug('couponCategoryList.size()===='+couponCategoryList.size());
        System.debug('cartItems size========'+cartItems.size());
        if(couponCategoryList.size()>0){
            for(Ecom_Coupon_Category__c couponCategoryObj : couponCategoryList){
                if(couponCategoryObj.Ecom_Coupon_Category_Type__c == 'Exclusion'){
                    if(couponCategoryObj.Ecom_Target_Category__c != null){
                        categoryMap.put(couponCategoryObj.Ecom_Target_Category__c,'Exclusion');
                    }
                    categoryMap.put(couponCategoryObj.Ecom_Source_Category__c, 'Exclusion');
                }else if(couponCategoryObj.Ecom_Coupon_Category_Type__c == 'Inclusion'){
                    if(couponCategoryObj.Ecom_Target_Category__c != null){
                        categoryMap.put(couponCategoryObj.Ecom_Target_Category__c,'Inclusion');
                    }
                    categoryMap.put(couponCategoryObj.Ecom_Source_Category__c, 'Inclusion');
                }
            }
            for(ccrz__E_CartItem__c cartItemObj : cartItems){
                producIdList.add(cartItemObj.ccrz__Product__c);
            }
            System.debug('producIdList====='+producIdList);
            productCategoryList = [SELECT Id,
                                   ccrz__Product__c,
                                   ccrz__Category__c,
                                   ccrz__Category__r.ccrz__ParentCategory__c,
                                   ccrz__Category__r.ccrz__ParentCategory__r.ccrz__ParentCategory__c
                                   FROM ccrz__E_ProductCategory__c WHERE ccrz__Product__c IN: producIdList];
            System.debug('productCategoryList.size()======='+productCategoryList.size());
            System.debug('productCategoryList ======='+productCategoryList);
            for(ccrz__E_ProductCategory__c productCateObj : productCategoryList){
                CategoryWrapper categoryWrapperObj = new CategoryWrapper();
                categoryWrapperObj.category = productCateObj.ccrz__Category__r.ccrz__ParentCategory__r.ccrz__ParentCategory__c;
                categoryWrapperObj.subCategory = productCateObj.ccrz__Category__r.ccrz__ParentCategory__c;
                categoryWrapperObj.subSubCategory = productCateObj.ccrz__Category__c;
                categoryWrapperMap.put(productCateObj.ccrz__Product__c,categoryWrapperObj);
            }
            for(String productId : categoryWrapperMap.keyset()){
                CategoryWrapper categoryWrapperObj = categoryWrapperMap.get(productId);
                if((categoryMap.containskey(categoryWrapperObj.category) && categoryMap.get(categoryWrapperObj.category) == 'Exclusion') ||
                   (categoryMap.containskey(categoryWrapperObj.subCategory) && categoryMap.get(categoryWrapperObj.subCategory) == 'Exclusion') || 
                   (categoryMap.containskey(categoryWrapperObj.subSubCategory) &&  categoryMap.get(categoryWrapperObj.subSubCategory) == 'Exclusion')){
                       productIdExclusionList.add(productId);
                   }else if((categoryMap.containskey(categoryWrapperObj.category) && categoryMap.get(categoryWrapperObj.category) == 'Inclusion') ||
                            (categoryMap.containskey(categoryWrapperObj.subCategory) && categoryMap.get(categoryWrapperObj.subCategory) == 'Inclusion') || 
                            (categoryMap.containskey(categoryWrapperObj.subSubCategory) &&  categoryMap.get(categoryWrapperObj.subSubCategory) == 'Inclusion')){
                                productIdInclusionList.add(productId);
                               /* CategoryWrapper categoryWrapperBOGO = new CategoryWrapper();
                                if(categoryMap.containskey(categoryWrapperObj.category)){
                                    categoryWrapperBOGO.productId = productId;
                                    categoryWrapperBOGO.category = categoryWrapperObj.category;
                                }else if(categoryMap.containskey(categoryWrapperObj.subCategory)){
                                    categoryWrapperBOGO.productId = productId;
                                    categoryWrapperBOGO.category = categoryWrapperObj.subCategory;
                                }else if(categoryMap.containskey(categoryWrapperObj.subSubCategory )){
                                    categoryWrapperBOGO.productId = productId;
                                    categoryWrapperBOGO.category = categoryWrapperObj.subSubCategory;
                                }
                                categoryList.add(categoryWrapperBOGO);*/
                                
                            }
                
            }
           // system.debug('categoryList '+ categoryList);
        }
        System.debug('productIdExclusionList===='+productIdExclusionList);
        
        categorywithroductIdsMap.put('Exclusion',productIdExclusionList);
        categorywithroductIdsMap.put('Inclusion',productIdInclusionList);
        return categorywithroductIdsMap;
    }
   // public static List<dbu_CouponProductUtility.BogoProducts> getBOGOCategories(List<Ecom_Coupon_Category__c> couponCategoryList,List<ccrz__E_CartItem__c> cartItems){
        
       // getCouponCategories(couponCategoryList,cartItems);
      //  List<dbu_CouponProductUtility.BogoProducts> bogoProductList = new List<dbu_CouponProductUtility.BogoProducts>();
       /* for(Ecom_Coupon_Category__c couponCategory : couponCategoryList){
            dbu_CouponProductUtility.BogoProducts bogoProductObj = new dbu_CouponProductUtility.BogoProducts();
            for(CategoryWrapper categoryWrapperObj : categoryList){
                if(couponCategory.Ecom_Source_Category__c == categoryWrapperObj.category){
                    bogoProductObj.sourceProductId = categoryWrapperObj.productId;
                    bogoProductObj.sourceProductQty = couponCategory.Ecom_Source_Quantity__c;
                }
                system.debug('Ecom_Target_Category__c ' + couponCategory.Ecom_Target_Category__c);
                if(couponCategory.Ecom_Target_Category__c == categoryWrapperObj.category){
                    bogoProductObj.targetProductId = categoryWrapperObj.productId;
                    bogoProductObj.targetProductQty = couponCategory.Ecom_Target_Quantity__c;
                }
                bogoProductObj.discount = couponCategory.Ecom_Category_Discount_Amount__c;
                bogoProductObj.productCartAmnt = couponCategory.Ecom_Category_Cart_Amount__c;
            }
            bogoProductList.add(bogoProductObj);
            
        }
        system.debug('bogoProductList '+ bogoProductList);*/
      //  return bogoProductList;
   // } 
    public class CategoryWrapper{
        public String productId;
        public String category; 
        public String subCategory; 
        public String subSubCategory; 
    }
    
    
}