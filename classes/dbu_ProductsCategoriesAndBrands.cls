public without sharing class dbu_ProductsCategoriesAndBrands {
    public static Set<String> coreProducIdList;
    @AuraEnabled(cacheable=true)
    public static List<ProductBrandAndCategory> getProductCategoryInCart(String  urlParam){
        string cartId;
        List<ProductBrandAndCategory> productBrandAndCategoryList = new List<ProductBrandAndCategory>();
        List<ProductBrandAndCategory> productBrandAndCategoryList1 = new List<ProductBrandAndCategory>();
        //String  urlParam = 'https://csodev-cumminscss.cs90.force.com/CSSNAStore/s/order?cartId=a1y1F000001F9TYQA0&store=US#no-back-button';
        if(String.isNotBlank(urlParam)){
            ApexPages.PageReference ref = new ApexPages.PageReference(urlParam);
            Map<String, String> params = ref.getParameters();
            if(params.size() > 0 && params.containsKey('cartId')){
                cartId = params.get('cartId');
            } 
            if(cartId != null){
                productBrandAndCategoryList = getBrandAndCategory(cartId,productBrandAndCategoryList);
            }
            if(coreProducIdList.size() > 0){
                productBrandAndCategoryList1 = getCoreProductBrandAndCategory(productBrandAndCategoryList);
                productBrandAndCategoryList.addAll(productBrandAndCategoryList1);
            }
        }
        system.debug('new productBrandAndCategoryList ' + productBrandAndCategoryList);
        return productBrandAndCategoryList;
    }
    
    private static List<ProductBrandAndCategory> getBrandAndCategory(String cartId,List<ProductBrandAndCategory> productBrandAndCategoryList){
        List<ccrz__E_CartItem__c> cartItems;
        Set<String> productIdList = new Set<String>();
        List<ccrz__E_ProductCategory__c> productCategoryList;
        coreProducIdList = new Set<String>();
        cartItems = [SELECT Id,
                     ccrz__Product__c,
                     ccrz__Product__r.dbu_Has_Core_Child__c,
                     ccrz__Product__r.dbu_Has_Core_Charge__c
                     FROM ccrz__E_CartItem__c WHERE ccrz__Cart__c =: cartId];
        
        if(cartItems.size() > 0){
            for(ccrz__E_CartItem__c cartItemObj : cartItems){
                if(cartItemObj.ccrz__Product__r.dbu_Has_Core_Child__c && cartItemObj.ccrz__Product__r.dbu_Has_Core_Charge__c){
                    coreProducIdList.add(cartItemObj.ccrz__Product__c);
                }else {
                    productIdList.add(cartItemObj.ccrz__Product__c);
                }
            }
        }
        productCategoryList = [SELECT Id,
                               ccrz__Product__c,
                               ccrz__Product__r.Name,
                               ccrz__Category__r.ccrz__ParentCategory__r.Name,
                               ccrz__Category__r.ccrz__ParentCategory__r.ccrz__ParentCategory__r.Name
                               FROM ccrz__E_ProductCategory__c WHERE ccrz__Product__c IN: productIdList];
        
        if(productCategoryList.size() > 0){
            for(ccrz__E_ProductCategory__c productCateObj : productCategoryList){
                ProductBrandAndCategory productBrandAndCategoryObj = new ProductBrandAndCategory();
                productBrandAndCategoryObj.productId = productCateObj.ccrz__Product__c;
                productBrandAndCategoryObj.productName = productCateObj.ccrz__Product__r.Name;
                productBrandAndCategoryObj.productBrand = productCateObj.ccrz__Category__r.ccrz__ParentCategory__r.ccrz__ParentCategory__r.Name;
                productBrandAndCategoryObj.productSubCategory = productCateObj.ccrz__Category__r.ccrz__ParentCategory__r.Name;
                productBrandAndCategoryList.add(productBrandAndCategoryObj);
            }
        }
        system.debug('productBrandAndCategoryList ' + productBrandAndCategoryList);
        return productBrandAndCategoryList;
    }
    private static List<ProductBrandAndCategory> getCoreProductBrandAndCategory(List<ProductBrandAndCategory> productBrandAndCategoryList){
        List<ccrz__E_RelatedProduct__c> relatedProductList = new List<ccrz__E_RelatedProduct__c>();
        Map<String,String> relatedProductMap = new Map<String,String>();
        List<ProductBrandAndCategory> ProductBrandAndCategoryList1 = new List<ProductBrandAndCategory>();
        relatedProductList = [SELECT id,
                              ccrz__Product__c,
                              ccrz__RelatedProduct__c
                              FROM ccrz__E_RelatedProduct__c WHERE ccrz__RelatedProduct__c  IN : coreProducIdList AND ccrz__RelatedProductType__c ='Core Charge'];
        
        for(ccrz__E_RelatedProduct__c relatedProductObj : relatedProductList){
            relatedProductMap.put(relatedProductObj.ccrz__Product__c, relatedProductObj.ccrz__RelatedProduct__c);
        }
        
        for(ProductBrandAndCategory productBrandAndCategoryObj1 : productBrandAndCategoryList){
            if(relatedProductMap.containskey(productBrandAndCategoryObj1.productId)){
                ProductBrandAndCategory productBrandAndCategoryObj = new ProductBrandAndCategory();
                productBrandAndCategoryObj.productId = relatedProductMap.get(productBrandAndCategoryObj1.productId);
                //productBrandAndCategoryObj.productName = 
                productBrandAndCategoryObj.productBrand = productBrandAndCategoryObj1.productBrand;
                productBrandAndCategoryObj.productSubCategory = productBrandAndCategoryObj1.productSubCategory;
                ProductBrandAndCategoryList1.add(productBrandAndCategoryObj);
            }
        }
        return ProductBrandAndCategoryList1;
    }
    public class ProductBrandAndCategory{
       @AuraEnabled public String productId;
       @AuraEnabled public String productName;
       @AuraEnabled public String productBrand;
       @AuraEnabled public String productSubCategory;
    }
}