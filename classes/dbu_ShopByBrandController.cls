public class dbu_ShopByBrandController {
    
    public class productWrapper{
        public productWrapper(){}
        @AuraEnabled public List<ccrz__E_Product__c> prodList;
        @AuraEnabled public List<ccrz__E_Category__c> subCategoryList;
        @AuraEnabled public Map<String,Boolean> inventoryStatus;
        @AuraEnabled public Map<String,String> Coreprice;
        @AuraEnabled public Map<String,Integer> prodAgainstSubCate;
        
    }
    
    /* @AuraEnabled
public static List<ccrz__E_Category__c> getSubCategoryByParentCategoryName(String parentCategoryName){
List<ccrz__E_Category__c> subCategoryList = [SELECT Id,Name,ccrz__ParentCategory__r.Name from ccrz__E_Category__c 
WHERE ccrz__ParentCategory__r.Name =:  parentCategoryName];
if(subCategoryList.size() > 0){
return subCategoryList;
}else{
return null;
}
}*/
    
    @AuraEnabled
    public static productWrapper getSubCategoryByParentCategoryName(String locationCode,String parentCategoryName) {
        System.debug('locationCode>>>>>>>>>>>>>>>>>'+locationCode);
        System.debug('parentCategoryName>>>>>>>>>>>>>>>>>'+parentCategoryName);
        Set<Id> subCateIds = new Set<Id>();
        Map<String,Boolean> inventoryStatusMap = new Map<String,Boolean>();
        Map<String,Integer> mapOfProdAgainstSubCate = new Map<String,Integer>();
        Map<String,String> corepricemap= new Map<String,String>();
        ccrz__E_Category__c cateObj = new ccrz__E_Category__c();
        List<ccrz__E_Category__c> subCategoryList = [SELECT Id,Name,ccrz__ParentCategory__r.Name,ccrz__ParentCategory__r.ccrz__LongDescRT__c from ccrz__E_Category__c 
                                                     WHERE ccrz__ParentCategory__r.Name =:  parentCategoryName LIMIT 200];
        
        //  System.debug('CateDesc======'+subCategoryList[0].ccrz__ParentCategory__c);
        if(subCategoryList.size() > 0){
            for(ccrz__E_Category__c subCateObj : subCategoryList){
                subCateIds.add(subCateObj.Id); 
            }
        }
        List<ccrz__E_Category__c> categoryIds = [SELECT Id FROM ccrz__E_Category__c WHERE ccrz__ParentCategory__c IN : subCateIds LIMIT 1000];
        System.debug('categoryIds============='+categoryIds);
        list<ccrz__E_Product__c> lstproduct = new list<ccrz__E_Product__c>();
        List<ccrz__E_ProductCategory__c> prodCatList = new List<ccrz__E_ProductCategory__c>();
        set<Id> prdCatSet = new set<Id>();
        
        prodCatList = [Select id,ccrz__Product__c 
                       from ccrz__E_ProductCategory__c 
                       WHERE ccrz__Product__r.ccrz__ProductStatus__c = 'Released' and 
                       ccrz__Product__r.ccrz__Storefront__c = 'CSSNAStore' and 
                       ccrz__Product__r.Group_Name__c = 'Ecom'  and 
                       ccrz__Product__r.ccrz__ProductType__c = 'Product' and 
                       ccrz__Product__r.DBU_Product_Location__c INCLUDES (:locationCode) and
                       ccrz__Category__c IN : categoryIds LIMIT 500];
        System.debug('prodCatList====='+prodCatList);
        
        if(prodCatList != null){
            for(ccrz__E_ProductCategory__c prdCatRec:prodCatList){
                if(prdCatRec.ccrz__Product__c != null){
                    prdCatSet.add(prdCatRec.ccrz__Product__c);
                }
            }
        }
        //get the country cureency iso mapping from custom settings
        Map<string,string> countryCurrencyMap = new Map<string,string>();
        for(dbu_CountryCurrencyMapping__c eachsetting : (list<dbu_CountryCurrencyMapping__c>)dbu_CountryCurrencyMapping__c.getall().values()){
            system.debug('dbuCountryCode__c > ' + (string)eachsetting.get('dbuCountryCode__c'));
            system.debug('dbuCurrencyCode__c > ' + (string)eachsetting.get('dbuCurrencyCode__c'));
            countryCurrencyMap.put((string)eachsetting.get('dbuCountryCode__c'), (string)eachsetting.get('dbuCurrencyCode__c'));
        }
        system.debug('countryCurrencyMap > ' + countryCurrencyMap);
        
        string currencyISOvalue = (string)countryCurrencyMap.get(locationCode);   
        string   storeLocation;
        
        if(locationCode == 'US')
        {
            storeLocation = 'US';

        }
        else if (locationCode == 'CA')
        {
            
            storeLocation = 'EN';
        }
        

        

        try{
            if(prdCatSet <> null){
                lstproduct = [select id, name,dbu_Image_Src__c,ccrz__SKU__c,ccrz__AverageRating__c,ccrz__Quantityperunit__c,dbu_Has_Core_Charge__c,
                              (select id,CurrencyIsoCode,ccrz__Price__c,dbu_Original_Price__c ,dbu_Discount_Percent__c from ccrz__E_PriceListItems__r where ccrz__Price__c != null AND CurrencyIsoCode =: currencyISOvalue  limit 1),
                              (select id, name, ccrz__Category__r.Name from ccrz__Promotions__r  WHERE  ccrz__Enabled__c = true  AND ccrz__EndDate__c >= today AND ccrz__StartDate__c <= today AND ccrz__Storefront__c = 'CSSNAStore' AND dbu_store_location__c INCLUDES(:storeLocation)  LIMIT 1 ),
                              (select id,ccrz__MediaType__c, ccrz__URI__c from ccrz__E_ProductMedias__r WHERE ccrz__MediaType__c =: 'Product Image' limit 1) 
                              from ccrz__E_Product__c where name != null AND ID IN:prdCatSet AND Group_Name__c='Ecom'  Order By createdDate desc LIMIT 1000];
            }
            set<string> ProductIDSet= new set<string>();
            for(ccrz__E_Product__c prodObj : lstproduct){
                ProductIDSet.add(prodObj.id);

            }
            corepricemap=dbu_ProductCtrl.fetchcorepricebyproductid(ProductIDSet,currencyISOvalue);
            //-------
           /* List<ccrz__E_ProductCategory__c > listProdCategoryBasedOnProdId = [SELECT Id,ccrz__Product__c,ccrz__Category__r.ccrz__ParentCategory__c 
                                                                               FROM ccrz__E_ProductCategory__c WHERE ccrz__Product__c IN : ProductIDSet AND
                                                                               ccrz__Product__r.ccrz__ProductStatus__c = 'Released' AND 
                                                                               ccrz__Product__r.ccrz__Storefront__c = 'CSSNAStore' AND 
                                                                               ccrz__Product__r.Group_Name__c = 'Ecom'  AND 
                                                                               ccrz__Product__r.ccrz__ProductType__c = 'Product' AND 
                                                                               ccrz__Product__r.DBU_Product_Location__c INCLUDES (:locationCode)];
            Map<String, List<ccrz__E_ProductCategory__c>> mapOfSubCateAndProdCount = new Map<String, List<ccrz__E_ProductCategory__c>>();
            for(ccrz__E_ProductCategory__c prodCateObj : listProdCategoryBasedOnProdId){
                if(mapOfSubCateAndProdCount.containsKey(prodCateObj.ccrz__Category__r.ccrz__ParentCategory__c )) {
                    List<ccrz__E_ProductCategory__c > pCateList = mapOfSubCateAndProdCount.get(prodCateObj.ccrz__Category__r.ccrz__ParentCategory__c);
                    pCateList.add(prodCateObj);
                    mapOfSubCateAndProdCount.put(prodCateObj.ccrz__Category__r.ccrz__ParentCategory__c,pCateList);
                } else {
                    mapOfSubCateAndProdCount.put(prodCateObj.ccrz__Category__r.ccrz__ParentCategory__c, new List<ccrz__E_ProductCategory__c> { prodCateObj });
                }
            }
            
            system.debug('mapOfSubCateAndProdCount====='+mapOfSubCateAndProdCount.size());
            for(String catIds : mapOfSubCateAndProdCount.keySet()){
                if(catIds != null){
                    mapOfProdAgainstSubCate.put(catIds,mapOfSubCateAndProdCount.get(catIds).size());
                    System.debug('CatIDS===='+catIds);
                    System.debug('Total SIze===='+mapOfSubCateAndProdCount.get(catIds).size());
                }
            }*/
            // --- Checking inventory----
            Map<string,double> productInventorymapping = new Map<string,double>();
            list<AggregateResult> productInventory = new list<AggregateResult>();
            productInventory = [select SUM(ccrz__QtyAvailable__c) TOTALQUANTITY, ccrz__ProductItem__c PRODUCTID
                                from ccrz__E_ProductInventoryItem__c 
                                where ccrz__ProductItem__c IN : ProductIDSet 
                                and CurrencyIsoCode =: currencyISOvalue 
                                GROUP BY ccrz__ProductItem__c LIMIT 1000];
            system.debug('inventorySize===='+productInventory.size());
            
            if(productInventory.size() > 0){
                for(AggregateResult pi : productInventory){            
                    productInventorymapping.put((string)pi.get('PRODUCTID'),(double)pi.get('TOTALQUANTITY'));
                    system.debug('productInventorymapping > ' + productInventorymapping);
                } 
            }  
            System.debug('==productInventory====='+productInventorymapping);
            
            for(String ids : ProductIDSet){
                boolean stockstatus = false;
                double inventoryQuantity = 0;
                //   if(productInventorymapping.size() > 0){                                                  
                if((double)productInventorymapping.get(ids) != null){       
                    inventoryQuantity = (double)productInventorymapping.get(ids);
                    if(inventoryQuantity > 0){
                        stockstatus = true;
                    }else{
                        stockstatus = false;
                    } 
                }else{
                    stockstatus = false; 
                }
                inventoryStatusMap.put(ids,stockstatus);
                // }     
                
            }
            system.debug('====inventoryStatusMap====='+inventoryStatusMap);
        }catch (Exception ex){
            System.debug(ex.getMessage()+'\t'+ex.getLineNumber());
        }
        System.debug('size========'+lstproduct.size());
        System.debug('products========'+lstproduct);
        productWrapper wrapObj = new productWrapper();
        wrapObj.prodList = lstproduct;
        wrapObj.subCategoryList = subCategoryList;
        wrapObj.inventoryStatus = inventoryStatusMap;
        wrapObj.Coreprice=corepricemap;
      //  wrapObj.prodAgainstSubCate = mapOfProdAgainstSubCate;
      system.debug('Testwrapper'+wrapObj);
        return wrapObj;
    }
}