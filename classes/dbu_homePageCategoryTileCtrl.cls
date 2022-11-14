public class dbu_homePageCategoryTileCtrl {
    public class BreadCrumbWrapper{
        
        @AuraEnabled public String brandName;
        @AuraEnabled public String subCategoryName;
        @AuraEnabled public String productName;
        @AuraEnabled public String subCategoryId;  
    }
    
    @AuraEnabled(cacheable=true)  
    public static BreadCrumbWrapper getBreadCrumb(String productId){ 
        BreadCrumbWrapper wrapObj = new BreadCrumbWrapper();
        try{
        
        ccrz__E_ProductCategory__c prodCateObj = new ccrz__E_ProductCategory__c();
        ccrz__E_Category__c subCateObj = new ccrz__E_Category__c();
        ccrz__E_Category__c brandObj = new ccrz__E_Category__c();
        prodCateObj = [SELECT Id,ccrz__Category__r.Name,ccrz__Category__c,ccrz__Category__r.ccrz__ParentCategory__c,ccrz__Product__r.Name FROM ccrz__E_ProductCategory__c WHERE ccrz__Product__c =: productId AND ccrz__Category__r.ccrz__ParentCategory__c != null AND ccrz__Category__r.dbu_isPromotion__c=false LIMIT 1];
        wrapObj.productName = prodCateObj.ccrz__Product__r.Name;
        if(prodCateObj!=null)
        {
        subCateObj = [SELECT Id, ccrz__ParentCategory__r.Name, ccrz__ParentCategory__c FROM ccrz__E_Category__c WHERE Id =: prodCateObj.ccrz__Category__c AND dbu_isPromotion__c=false];
        wrapObj.subCategoryName = subCateObj.ccrz__ParentCategory__r.Name;
        wrapObj.subCategoryId = subCateObj.ccrz__ParentCategory__c;
        system.debug('subCategoryName'+wrapObj.subCategoryName);
        system.debug('subCategoryName'+wrapObj.subCategoryId);
        brandObj = [SELECT Id, ccrz__ParentCategory__r.Name  FROM ccrz__E_Category__c WHERE Id =: subCateObj.ccrz__ParentCategory__c AND dbu_isPromotion__c=false];
        wrapObj.brandName = brandObj.ccrz__ParentCategory__r.Name;
        }
    }
        catch(Exception e)
        {
            system.debug('Exception Message'+e.getMessage() +''+'Exception Line number'+e.getLineNumber());
        }
        return wrapObj;   
    }
    
    @AuraEnabled
    public static List<ccrz__E_CategoryMedia__c> getProdCategoryMedia(){
        List<ccrz__E_CategoryMedia__c> categoryMediaList  = [SELECT Id,ccrz__Locale__c,ccrz__Category__c,ccrz__Category__r.Name,ccrz__StaticResourceName__c,ccrz__MediaType__c,ccrz__FilePath__c FROM ccrz__E_CategoryMedia__c Where ccrz__StaticResourceName__c = 'CumminsParts'];
        if(categoryMediaList.size() > 0){
            return categoryMediaList;
        }else{
            return null;
        }
    }
    
    @AuraEnabled(cacheable=true)  
    public static List<ccrz__E_Category__c> getProductBreadCrumb(String categoryId){
        
        List<ccrz__E_Category__c> ccrzECategoryList = new List<ccrz__E_Category__c>();
        try
        {
        ccrzECategoryList = [Select Id,Name,ccrz__ParentCategory__c From ccrz__E_Category__c WHERE Id=:categoryId AND dbu_isPromotion__c=false LIMIT 1];
        system.debug('details'+ccrzECategoryList);
        }
        catch(Exception e)
        {
            system.debug('Exception Message'+e.getMessage() +''+'Exception Line number'+e.getLineNumber()); 
        }
        return ccrzECategoryList;
    }
    @AuraEnabled(cacheable=true)  
    public static List<ccrz__E_Category__c> getProductBreadCrumbSubCategory(String categoryId){
    
        List<ccrz__E_Category__c> ccrzECategoryList = new List<ccrz__E_Category__c>();
        try
        {
        ccrz__E_Category__c category = [Select Id,ccrz__ParentCategory__c From ccrz__E_Category__c WHERE Id=:categoryId AND dbu_isPromotion__c=false  LIMIT 1];
        ccrzECategoryList = [Select Id,Name,ccrz__ParentCategory__c From ccrz__E_Category__c WHERE Id= : category.ccrz__ParentCategory__c AND dbu_isPromotion__c=false LIMIT 1];
        }
        catch(Exception e)
        {
            system.debug('Exception'+ e.getLineNumber());  
        }
        return ccrzECategoryList;
    }
    
    @AuraEnabled(cacheable=true)  
    public static  Map<String,String> fetchhomePageCategoryDetails(String country){
        Map<String,String> categoryMap= new Map<String,String> ();
        try
        {
        string currencyCode;
        string storeLocation;
    
        if(country == 'US')
        {
            currencyCode = 'USD';
            storeLocation='US';
        }
        else if (country == 'EN' || country == 'FR')
        {
            currencyCode = 'CAD';
            storeLocation='CA';
        }
        List<ccrz__E_Category__c> ccrzECategoryList = new List<ccrz__E_Category__c>();
    
        ccrzECategoryList = [SELECT Id,Name FROM ccrz__E_Category__c WHERE ccrz__ParentCategory__c = NULL AND Storefront__c='CSSNAStore' AND dbu_isPromotion__c = false AND dbu_Category_Location__c INCLUDES (:country) ORDER BY ccrz__Sequence__c];
         
        //Start CECI 955
        List<ccrz__E_Product__c> prodList = [select id  from ccrz__E_Product__c WHERE Id IN (select ccrz__Product__c from ccrz__E_Promo__c     
                                                WHERE ccrz__Enabled__c = true 
                                                AND ccrz__EndDate__c >= today
                                                AND ccrz__StartDate__c <= today
                                                AND ccrz__Storefront__c = 'CSSNAStore'
                                                AND dbu_store_location__c INCLUDES (:country)) 
                                                AND  ccrz__ProductStatus__c='Released' AND ccrz__StartDate__c <= today AND ccrz__EndDate__c>= today
                                                AND ccrz__Storefront__c INCLUDES ('CSSNAStore') AND DBU_Product_Location__c INCLUDES (:storeLocation)];
    
        
        
        for(ccrz__E_Category__c categoryval:ccrzECategoryList ){        
            categoryMap.put(String.valueof(categoryval.id),String.valueof(categoryval.name));
            if(prodList.size()>0){     
                //Deals are present            
                categoryMap.put('Showdeals','true');
            } else{
               //Deals are unavailable
               categoryMap.put('Showdeals','false');
            }
        }
        system.debug('Map'+categoryMap);
        //End CECI 955  
    }
    catch(Exception e)
    {
        system.debug('Exception Message'+e.getMessage() +''+'Exception Line number'+e.getLineNumber());
    }
       return categoryMap;
    }
    
    @AuraEnabled(cacheable=true)  
    public static List<ccrz__E_Category__c> getSubCategoryByCategoryName(String categoryName){
        System.debug('categoryName>>> 10 ' + categoryName);
        List<ccrz__E_Category__c> ccrzECategoryList = new List<ccrz__E_Category__c>();
        ccrz__E_Category__c category = [Select Id From ccrz__E_Category__c WHERE Name=:categoryName LIMIT 1][0];
        System.debug('category>>> 13 ' + category);
        ccrzECategoryList = [SELECT Id,Name FROM ccrz__E_Category__c WHERE ccrz__ParentCategory__c =:category.Id AND Storefront__c='CSSNAStore'  ORDER BY ccrz__Sequence__c];
        return ccrzECategoryList;
    }
    @AuraEnabled(cacheable=true)  
    public static List<ccrz__E_Category__c> getSubCategoryByCategoryId(String categoryId,string country)
    {
        
        List<ccrz__E_Category__c> ccrzECategoryList = new List<ccrz__E_Category__c>();
        
        ccrzECategoryList = [SELECT Id,Name,dbu_Community_Page_Name__c,dbu_Category_Location__c FROM ccrz__E_Category__c WHERE ccrz__ParentCategory__c =:categoryId AND Storefront__c='CSSNAStore' AND dbu_isPromotion__c = false AND dbu_Category_Location__c INCLUDES (:country) ORDER BY ccrz__Sequence__c];
        system.debug('Categorylist'+ccrzECategoryList);
        return ccrzECategoryList;
    }
    // For Sub Sub Category Name With Product Count
    @AuraEnabled(cacheable=true)  
    //public static List<dbu_SubSubCategoryNamewithCountWrapper> getSubCategoryWithProductByCategoryId(String categoryId){
    public static List<dbu_SubSubCategoryNamewithCountWrapper> getSubCategoryWithProductByCategoryId(String categoryId,string country){
        //country = 'CA';
        Set<ID> setSubCategoryID = new Set<ID>();
        List<ccrz__E_Category__c> ccrzECategoryList = new List<ccrz__E_Category__c>();
            
        //ccrzECategoryList = [SELECT Id,Name FROM ccrz__E_Category__c WHERE ccrz__ParentCategory__c =:categoryId AND Storefront__c='CSSNAStore'  ORDER BY ccrz__Sequence__c];
        ccrzECategoryList = [SELECT Id,Name FROM ccrz__E_Category__c WHERE ccrz__ParentCategory__c =:categoryId AND Storefront__c='CSSNAStore' AND dbu_isPromotion__c = false ORDER BY Name ASC];
        
        System.debug('ccrzECategoryList=>'+ ccrzECategoryList);
        for(ccrz__E_Category__c subCategory : ccrzECategoryList){            
    setSubCategoryID.add(subCategory.Id);
        }
        System.debug('setSubCategoryID=>'+ setSubCategoryID);
        System.debug('setSubCategoryID.size()=>'+ setSubCategoryID.size());
        
        //List<AggregateResult> ccrzEProductCategoryList = [SELECT ccrz__Category__c,COUNT(Id) Total FROM ccrz__E_ProductCategory__c  WHERE ccrz__Category__c IN : setSubCategoryID GROUP BY ccrz__Category__c];
    List<AggregateResult> ccrzEProductCategoryList = [SELECT ccrz__Category__c,COUNT(Id) Total FROM ccrz__E_ProductCategory__c  
                                                            WHERE ccrz__Product__r.ccrz__ProductStatus__c = 'Released' and
                                                            ccrz__Product__r.ccrz__Storefront__c = 'CSSNAStore' and
                                                            ccrz__Product__r.Group_Name__c = 'Ecom'  and
                                                            ccrz__Product__r.ccrz__ProductType__c = 'Product' and
                                                            ccrz__Product__r.DBU_Product_Location__c INCLUDES (:country) and
                                                            ccrz__Category__c IN : setSubCategoryID
                                                            GROUP BY ccrz__Category__c
                                                            HAVING COUNT(ccrz__Category__c) > 0];
        System.debug('ccrzEProductCategoryList=>'+ ccrzEProductCategoryList);
    List<String> subSubCategoryIdList = new List<String>();
        for(AggregateResult result :ccrzEProductCategoryList)
        {
            subSubCategoryIdList.add((String)result.get('ccrz__Category__c'));
        }
        list<dbu_SubSubCategoryNamewithCountWrapper> SubSubCategorywrapperlist = new list<dbu_SubSubCategoryNamewithCountWrapper>();
        //dbu_SubSubCategoryNamewithCountWrapper wrapperSubSubCategoryNamewithCount = new dbu_SubSubCategoryNamewithCountWrapper();
        
        for(ccrz__E_Category__c SubSubCatName :ccrzECategoryList)
        {
            if(!subSubCategoryIdList.contains(SubSubCatName.Id))
            {
                continue;
            }
            
            dbu_SubSubCategoryNamewithCountWrapper wrapperSubSubCategoryNamewithCount = new dbu_SubSubCategoryNamewithCountWrapper();
            System.debug('SubSubCatName=>'+ SubSubCatName);
                
            wrapperSubSubCategoryNamewithCount.subsubcategoryName = (String)SubSubCatName.get('Name');
                wrapperSubSubCategoryNamewithCount.subsubcategoryid = (String)SubSubCatName.get('Id');
                System.debug('wrapperSubSubCategoryNamewithCount.subsubcategoryName=>'+ wrapperSubSubCategoryNamewithCount.subsubcategoryName);  
            System.debug('wrapperSubSubCategoryNamewithCount.subsubcategoryid=>'+ wrapperSubSubCategoryNamewithCount.subsubcategoryid);  
    wrapperSubSubCategoryNamewithCount.subsubcategoryproductCount = 0;
                for(AggregateResult ProductCount :ccrzEProductCategoryList)
                {
                    System.debug('Inside A For');
                    
                        String ccrzcategoryID = (String)ProductCount.get('ccrz__Category__c');
                    
                    //System.debug('(String)ProductCount.get('ccrz__Category__c')'+  (String)ProductCount.get('ccrz__Category__c'));
                    
                    System.debug('wrapperSubSubCategoryNamewithCount.productid' +  ccrzcategoryID);
                    
                    if(wrapperSubSubCategoryNamewithCount.subsubcategoryid == ccrzcategoryID)
                    {
                            //System.debug('Inside If');
                        wrapperSubSubCategoryNamewithCount.subsubcategoryproductCount = (Integer)ProductCount.get('Total');
                    }  
                }
            
            SubSubCategorywrapperlist.add(wrapperSubSubCategoryNamewithCount);
        }
        System.debug('SubSubCategorywrapperlist OUT=>'+ SubSubCategorywrapperlist);
        
        return SubSubCategorywrapperlist;
    }
    
    // For Description
    @AuraEnabled(cacheable=true)  
    public static String getDescriptionBySubCategoryId(String categoryId){
        System.debug('Inside Method>>>19');
        //System.debug('categoryName>>> 20 ' + categoryName);
        //ccrz__E_Category__c category = [Select Id,ccrz__ParentCategory__c From ccrz__E_Category__c WHERE Name=:categoryName LIMIT 1][0];
        ccrz__E_Category__c ccrzECategoryList = [SELECT Id,ccrz__LongDescRT__c,Name FROM ccrz__E_Category__c WHERE  Id =:categoryId];
        return ccrzECategoryList.ccrz__LongDescRT__c;
    }
        @AuraEnabled(cacheable=true)  
    //public static list<dbu_CCAPIResponseWrapper> getProductDetailsBySubCategoryId(String categoryId, Integer pageNumber, Integer numberofrecords,String sortOption){
    public static list<dbu_CCAPIResponseWrapper> getAllProductDetailsBySubCategoryId(String categoryId, String sortOption,string country){ 
        
        list<dbu_CCAPIResponseWrapper> wrapperlist = new list<dbu_CCAPIResponseWrapper>();
        try{
        System.debug('Inside Method>>>19');
        System.debug('categoryId>>> ' + categoryId);
        System.debug('sortOption>>>' + sortOption);
        System.debug('country>>>' + country);  
        //country = 'CA';
        System.debug('country>>>' + country);
        Map<String,Object>  productmap = new  Map<String,Object>();  
        Set<String> categories = (Set<String>)JSON.deserialize(categoryId, Set<String>.class);
        List<ccrz__E_ProductCategory__c> lsttotalProductsNumber = new List<ccrz__E_ProductCategory__c>();
        //List<ccrz__E_ProductCategory__c> ccrzEProductCategoryList = new List<ccrz__E_ProductCategory__c>();
        List<ccrz__E_Category__c> categoryIds = new List<ccrz__E_Category__c>();
        categoryIds = [Select Id,ccrz__ParentCategory__c From ccrz__E_Category__c WHERE ccrz__ParentCategory__c IN:categories];
        
        System.debug('categoryIds>>> ' + categoryIds);
    
        if( categoryIds == null || categoryIds.isEmpty()){
                categoryIds = [Select Id,ccrz__ParentCategory__c From ccrz__E_Category__c WHERE Id IN:categories];
        }
        System.debug('categoryId>>>  ' + categoryId);
        System.debug('categories>>>  ' + categories);
        System.debug('categoryIds>>>  ' + categoryIds);
        System.debug('categoryIds.size()>>> ' + categoryIds.size());
        
        //lsttotalProductsNumber  = [SELECT Id,ccrz__Product__r.ccrz__SKU__c,ccrz__Product__r.ccrz__ProductStatus__c,ccrz__Product__r.ccrz__Storefront__c, ccrz__Product__r.Name,ccrz__Product__r.Group_Name__c,ccrz__Product__r.ccrz__ProductType__c FROM ccrz__E_ProductCategory__c WHERE ccrz__Product__r.ccrz__ProductStatus__c = 'Released' and ccrz__Product__r.ccrz__Storefront__c = 'CSSNAStore' and ccrz__Product__r.Group_Name__c = 'Ecom'  and ccrz__Product__r.ccrz__ProductType__c = 'Product' and ccrz__Category__c IN : categoryIds];
        //Integer totalProductsNumber = lsttotalProductsNumber.size();
            /****************************************************************************************************************
         Integer totalProductsNumber  = [SELECT COUNT()
                                        FROM ccrz__E_ProductCategory__c
                                        WHERE ccrz__Product__r.ccrz__ProductStatus__c = 'Released' and
                                        ccrz__Product__r.ccrz__Storefront__c = 'CSSNAStore' and
                                        ccrz__Product__r.Group_Name__c = 'Ecom'  and
                                        ccrz__Product__r.ccrz__ProductType__c = 'Product' and
                                        ccrz__Product__r.DBU_Product_Location__c INCLUDES (:country) and
                                        ccrz__Category__c IN : categoryIds];
        //Integer totalProductsNumber  = lstCount.get('expr0');
        ****************************************************************************************************************/
            /*List<AggregateResult> ccrzEProductCategoryListProCount = [SELECT  COUNT(Id),ccrz__Product__r.ccrz__SKU__c
                                                                    FROM ccrz__E_ProductCategory__c
                                                                    WHERE ccrz__Product__r.ccrz__ProductStatus__c = 'Released' and
                                                                    ccrz__Product__r.ccrz__Storefront__c = 'CSSNAStore' and
                                                                    ccrz__Product__r.Group_Name__c = 'Ecom'  and
                                                                    ccrz__Product__r.ccrz__ProductType__c = 'Product' and
                                                                    ccrz__Product__r.DBU_Product_Location__c INCLUDES (:country) and
                                                                    ccrz__Category__c IN : categoryIds
                                                                    GROUP BY ccrz__Product__r.ccrz__SKU__c];
        
        System.debug('ccrzEProductCategoryList>>>  ' + ccrzEProductCategoryListProCount.size());
        System.debug('ccrzEProductCategoryList>>>  ' + ccrzEProductCategoryListProCount);*/
        
        
    
        
        
        //ccrzEProductCategoryList = [SELECT Id,ccrz__Product__r.ccrz__SKU__c FROM ccrz__E_ProductCategory__c WHERE ccrz__Category__c IN : categoryIds LIMIT:numberofrecords OFFSET:recorsdToSkip];
        //ccrzEProductCategoryList = [SELECT Id,ccrz__Product__r.ccrz__SKU__c,ccrz__Product__r.ccrz__ProductStatus__c,ccrz__Product__r.ccrz__Storefront__c, ccrz__Product__r.Name,ccrz__Product__r.Group_Name__c,ccrz__Product__r.ccrz__ProductType__c FROM ccrz__E_ProductCategory__c WHERE ccrz__Product__r.ccrz__ProductStatus__c = 'Released' and ccrz__Product__r.ccrz__Storefront__c = 'CSSNAStore' and ccrz__Product__r.Group_Name__c = 'Ecom'  and ccrz__Product__r.ccrz__ProductType__c = 'Product' and ccrz__Category__c IN : categoryIds LIMIT:numberofrecords OFFSET:recorsdToSkip];
        
        List<AggregateResult> ccrzEProductCategoryList = [SELECT COUNT(Id),ccrz__Product__r.ccrz__SKU__c FROM ccrz__E_ProductCategory__c
                                    WHERE ccrz__Product__r.ccrz__ProductStatus__c = 'Released' and
                                    ccrz__Product__r.ccrz__Storefront__c = 'CSSNAStore' and
                                    ccrz__Product__r.Group_Name__c = 'Ecom'  and
                                    ccrz__Product__r.ccrz__ProductType__c = 'Product' and
                                    ccrz__Product__r.DBU_Product_Location__c INCLUDES (:country) and
                                    ccrz__Category__c IN : categoryIds
                                    GROUP BY ccrz__Product__r.ccrz__SKU__c
                                    LIMIT 50000];
        
        System.debug('ccrzEProductCategoryList>>>  ' + ccrzEProductCategoryList.size());
        System.debug('ccrzEProductCategoryList>>>  ' + ccrzEProductCategoryList);
        Integer totalProductsNumber = ccrzEProductCategoryList.size();
        
        set<string> skuset = new set<string>();
        for(AggregateResult sku : ccrzEProductCategoryList){
                skuset.add((String)sku.get('ccrz__SKU__c'));
            //skuset.add(sku.ccrz__Product__r.ccrz__SKU__c);
        }
        System.debug('skuset>>>  ' + skuset.size());
        System.debug('skuset>>>  ' + skuset);
        
        
        //Start of In Stock Out Stock 29th Jan 2021
        //get the country cureency iso mapping from custom settings
        Map<string,string> countryCurrencyMap = new Map<string,string>();
        
        for(dbu_CountryCurrencyMapping__c eachsetting : (list<dbu_CountryCurrencyMapping__c>)dbu_CountryCurrencyMapping__c.getall().values())
        {
            System.debug('dbuCountryCode__c > ' + (string)eachsetting.get('dbuCountryCode__c'));
            System.debug('dbuCurrencyCode__c > ' + (string)eachsetting.get('dbuCurrencyCode__c'));
            
            countryCurrencyMap.put((string)eachsetting.get('dbuCountryCode__c'), (string)eachsetting.get('dbuCurrencyCode__c'));
        }
        System.debug('countryCurrencyMap > ' + countryCurrencyMap);
        
        string CurrencyISOcodeValue = (string)countryCurrencyMap.get(country);
        
        System.debug('CurrencyISOcodeValue > ' + CurrencyISOcodeValue);
        
        //CHECK FOR INVENTORY
        Map<string,double> productInventorymapping = new Map<string,double>();
        list<AggregateResult> productInventory = new list<AggregateResult>();
        
        productInventory = [SELECT SUM(ccrz__QtyAvailable__c) TOTALQUANTITY, ccrz__ProductItem__c PRODUCTID
                            FROM ccrz__E_ProductInventoryItem__c
                            WHERE ccrz__ProductItem__r.ccrz__SKU__c IN : skuset
                            AND CurrencyIsoCode =: CurrencyISOcodeValue
                            GROUP BY ccrz__ProductItem__c];
        System.debug(productInventory);
        
        if(productInventory.size() > 0)
        {
            for(AggregateResult pi : productInventory)
            {            
                productInventorymapping.put((string)pi.get('PRODUCTID'),(double)pi.get('TOTALQUANTITY'));
                System.debug('productInventorymapping > ' + productInventorymapping);
            }      
            System.debug('productInventorymapping > ' + productInventorymapping);
            System.debug('productInventorymapping size > ' + productInventorymapping.size());  
        }
        //End of In Stock Out Stock 29th Jan 2021
    
        
        /****************************************************************************************************************
         ccrzEProductCategoryList = [SELECT Id,ccrz__Product__r.ccrz__SKU__c,ccrz__Product__r.ccrz__ProductStatus__c,
                                    ccrz__Product__r.ccrz__Storefront__c, ccrz__Product__r.Name,ccrz__Product__r.Group_Name__c,
                                    ccrz__Product__r.ccrz__ProductType__c
                                    FROM ccrz__E_ProductCategory__c
                                    WHERE ccrz__Product__r.ccrz__ProductStatus__c = 'Released' and
                                            ccrz__Product__r.ccrz__Storefront__c = 'CSSNAStore' and
                                            ccrz__Product__r.Group_Name__c = 'Ecom'  and
                                            ccrz__Product__r.ccrz__ProductType__c = 'Product' AND
                                            ccrz__Product__r.DBU_Product_Location__c INCLUDES (:storeCountry) and
                                            ccrz__Category__c IN : categoryIds
                                            LIMIT:numberofrecords OFFSET:recorsdToSkip];
            
            System.debug('ccrzEProductCategoryList>>>  ' + ccrzEProductCategoryList.size());
            System.debug('ccrzEProductCategoryList>>>  ' + ccrzEProductCategoryList);
        
            set<string> skuset = new set<string>();
            for(ccrz__E_ProductCategory__c sku:ccrzEProductCategoryList){
            skuset.add(sku.ccrz__Product__r.ccrz__SKU__c);
            }
            System.debug('skuset>>>  ' + skuset.size());
            System.debug('skuset>>>  ' + skuset);
            ****************************************************************************************************************/
        //productmap = fetchProductResult(skuset);
        productmap = fetchProductResult(skuset, country);
        
        System.debug('productmap>>>  ' + productmap.size());
        System.debug('productmap>>>  ' + productmap);
        
       
        
        //For Price
        ccrz__E_PriceListItem__c [] pricedata ;
        if(productmap.get('pricedata')!=null)
        {
            pricedata= (ccrz__E_PriceListItem__c [])productmap.get('pricedata');
            system.debug('pricedata'+pricedata);
        }
        
        if (productmap.get(ccrz.ccAPIProduct.PRODUCTLIST) != null)
        {
            system.debug('inside product list if ');
            List<Map<String, Object>> outputProductList = (List<Map<String, Object>>)productmap.get(ccrz.ccAPIProduct.PRODUCTLIST);
            system.debug('outputProductList'+outputProductList.size());
            system.debug('outputProductList'+outputProductList);
            
            if(outputProductList!=null && outputProductList.size()>0 )
            {
                for(Map<String, Object> productItem:outputProductList)
                {
                    dbu_CCAPIResponseWrapper wrapper = new dbu_CCAPIResponseWrapper();
                    wrapper.productCount = totalProductsNumber;
                    System.debug('wrapper.productCount=>'+ wrapper.productCount);
                    System.debug('obsfid=>'+ (String)productItem.get('sfid'));
                    
                    //For Price
                    wrapper.sfid = (String)productItem.get('sfid');
                    
                    //Start of In Stock Out Stock 29th Jan 2021
                    boolean stockstatus = false;
                    double inventoryQuantity = 0;
                    if(productInventorymapping.size() > 0){                                                  
                        if((double)productInventorymapping.get(wrapper.sfid) != null){      
                            inventoryQuantity = (double)productInventorymapping.get(wrapper.sfid);
                            if(inventoryQuantity > 0){
                                stockstatus = true;
                            }else{
                                stockstatus = false;
                            }                                                              
                        }  
                    }                                                                                                  
                    system.debug('stockstatus - ' + stockstatus);                                                  
                    system.debug('inventoryQuantity > ' + inventoryQuantity);
                    
                    wrapper.stockstatus = stockstatus;
                    wrapper.inventoryQuantity = inventoryQuantity;
                    
                    //End of In Stock Out Stock 29th Jan 2021
                    
                    system.debug('priceinwrapper => 82 '+ wrapper.price);
                    if(pricedata!=null)
                    {
                        for(ccrz__E_PriceListItem__c price:pricedata)
                        {
                            System.debug('price.ccrz__Product__c>>> ' + price.ccrz__Product__c);
                            System.debug('wrapper.sfid>>> ' + wrapper.sfid);
                            
                            if(price.ccrz__Product__c == wrapper.sfid)
                            {
                                System.debug('Inside If>>>90 ');
                                
                                if(price.ccrz__Price__c != 0 || price.ccrz__Price__c != null){
                                    wrapper.price = price.ccrz__Price__c;
                                    System.debug('wrapper.price'+  wrapper.price);  
                                }
                                
                                //wrapper.price = price.ccrz__Price__c;
                                //System.debug('wrapper.price'+  wrapper.price);
                            }
                        }
                    }
                    system.debug('priceinwrapper =>'+ wrapper.price);
                    system.debug('sfidinforloop=>>'+wrapper.sfid);
                    
                    wrapper.shortDesc = (String)productItem.get('shortDesc');
                    wrapper.SKU =(String)productItem.get('SKU');
                    //wrapper.sfid = (String)productItem.get('sfid');
                    wrapper.sfdcName = (String)productItem.get('sfdcName');
                    List<Map<String,Object >> productMedia = (List<Map<String,Object >>)productItem.get('EProductMediasS');
                    system.debug('productMedia'+productMedia);
                
                        List<dbu_EProductMediaWrapper> productMediaList = new List<dbu_EProductMediaWrapper>();
                        if(productMedia!=null && productMedia.size()>0)
                        {
                        for(Map<String,Object> mediaItem : productMedia)
                        {
                            if((String)mediaItem.get('mediaType')=='Product Image')
                            {
                                dbu_EProductMediaWrapper media = new dbu_EProductMediaWrapper();
                                media.URI = (String)mediaItem.get('URI');
                                media.mediaType = (String)mediaItem.get('mediaType');
                                media.sfid = (String)mediaItem.get('sfid');
                                productMediaList.add(media);
                                break;
                            }
                        }
                    }
                    wrapper.EProductMediasS =productMediaList;
                    wrapperlist.add(wrapper);
                    System.debug('wrapper=>'+ wrapper);
                }
            }
        }
    }
    catch(Exception e )
    {
        system.debug('Exception Message'+e.getMessage() +''+'Exception Line number'+e.getLineNumber());
    }
        System.debug('wrapperlist=>'+ wrapperlist.size());
        System.debug('wrapperlist=>'+ wrapperlist);
        return wrapperlist;
    }
    
    @AuraEnabled(cacheable=true)  
    //public static list<dbu_CCAPIResponseWrapper> getProductDetailsBySubCategoryId(String categoryId, Integer pageNumber, Integer numberofrecords,String sortOption){
    public static list<dbu_CCAPIResponseWrapper> getProductDetailsBySubCategoryId(String categoryId, Integer pageNumber, Integer numberofrecords,String sortOption,string country){  
        list<dbu_CCAPIResponseWrapper> wrapperlist = new list<dbu_CCAPIResponseWrapper>();
        try{
        System.debug('Inside Method>>>19');
        System.debug('categoryId>>> ' + categoryId);
        System.debug('pageNumber>>> ' + pageNumber);
        System.debug('numberofrecords>>>' + numberofrecords);
        System.debug('sortOption>>>' + sortOption);
        System.debug('country>>>' + country);  
        //country = 'CA';
        System.debug('country>>>' + country);
        Map<String,Object>  productmap = new  Map<String,Object>();  
        Set<String> categories = (Set<String>)JSON.deserialize(categoryId, Set<String>.class);
       
        List<ccrz__E_ProductCategory__c> lsttotalProductsNumber = new List<ccrz__E_ProductCategory__c>();
        //List<ccrz__E_ProductCategory__c> ccrzEProductCategoryList = new List<ccrz__E_ProductCategory__c>();
        List<ccrz__E_Category__c> categoryIds = new List<ccrz__E_Category__c>();
        categoryIds = [Select Id,ccrz__ParentCategory__c From ccrz__E_Category__c WHERE ccrz__ParentCategory__c IN:categories];
        
        System.debug('categoryIds>>> ' + categoryIds);
    
        if( categoryIds == null || categoryIds.isEmpty()){
                categoryIds = [Select Id,ccrz__ParentCategory__c From ccrz__E_Category__c WHERE Id IN:categories];
        }
        System.debug('categoryId>>>  ' + categoryId);
        System.debug('categories>>>  ' + categories);
        System.debug('categoryIds>>>  ' + categoryIds);
        System.debug('categoryIds.size()>>> ' + categoryIds.size());
        
        //lsttotalProductsNumber  = [SELECT Id,ccrz__Product__r.ccrz__SKU__c,ccrz__Product__r.ccrz__ProductStatus__c,ccrz__Product__r.ccrz__Storefront__c, ccrz__Product__r.Name,ccrz__Product__r.Group_Name__c,ccrz__Product__r.ccrz__ProductType__c FROM ccrz__E_ProductCategory__c WHERE ccrz__Product__r.ccrz__ProductStatus__c = 'Released' and ccrz__Product__r.ccrz__Storefront__c = 'CSSNAStore' and ccrz__Product__r.Group_Name__c = 'Ecom'  and ccrz__Product__r.ccrz__ProductType__c = 'Product' and ccrz__Category__c IN : categoryIds];
        //Integer totalProductsNumber = lsttotalProductsNumber.size();
            /****************************************************************************************************************
         Integer totalProductsNumber  = [SELECT COUNT()
                                        FROM ccrz__E_ProductCategory__c
                                        WHERE ccrz__Product__r.ccrz__ProductStatus__c = 'Released' and
                                        ccrz__Product__r.ccrz__Storefront__c = 'CSSNAStore' and
                                        ccrz__Product__r.Group_Name__c = 'Ecom'  and
                                        ccrz__Product__r.ccrz__ProductType__c = 'Product' and
                                        ccrz__Product__r.DBU_Product_Location__c INCLUDES (:country) and
                                        ccrz__Category__c IN : categoryIds];
        //Integer totalProductsNumber  = lstCount.get('expr0');
        ****************************************************************************************************************/
            List<AggregateResult> ccrzEProductCategoryListProCount = [SELECT  COUNT(Id),ccrz__Product__r.ccrz__SKU__c
                                                                    FROM ccrz__E_ProductCategory__c
                                                                    WHERE ccrz__Product__r.ccrz__ProductStatus__c = 'Released' and
                                                                    ccrz__Product__r.ccrz__Storefront__c = 'CSSNAStore' and
                                                                    ccrz__Product__r.Group_Name__c = 'Ecom'  and
                                                                    ccrz__Product__r.ccrz__ProductType__c = 'Product' and
                                                                    ccrz__Product__r.DBU_Product_Location__c INCLUDES (:country) and
                                                                    ccrz__Category__c IN : categoryIds
                                                                    GROUP BY ccrz__Product__r.ccrz__SKU__c];
        
        System.debug('ccrzEProductCategoryList>>>  ' + ccrzEProductCategoryListProCount.size());
        System.debug('ccrzEProductCategoryList>>>  ' + ccrzEProductCategoryListProCount);
        Integer totalProductsNumber = ccrzEProductCategoryListProCount.size();
        
        Integer recorsdToSkip = (pageNumber -1)*numberofrecords;
        
        System.debug('totalProductsNumber>>>  ' + totalProductsNumber);
        System.debug('recorsdToSkip>>>  ' + recorsdToSkip);
        
        //ccrzEProductCategoryList = [SELECT Id,ccrz__Product__r.ccrz__SKU__c FROM ccrz__E_ProductCategory__c WHERE ccrz__Category__c IN : categoryIds LIMIT:numberofrecords OFFSET:recorsdToSkip];
        //ccrzEProductCategoryList = [SELECT Id,ccrz__Product__r.ccrz__SKU__c,ccrz__Product__r.ccrz__ProductStatus__c,ccrz__Product__r.ccrz__Storefront__c, ccrz__Product__r.Name,ccrz__Product__r.Group_Name__c,ccrz__Product__r.ccrz__ProductType__c FROM ccrz__E_ProductCategory__c WHERE ccrz__Product__r.ccrz__ProductStatus__c = 'Released' and ccrz__Product__r.ccrz__Storefront__c = 'CSSNAStore' and ccrz__Product__r.Group_Name__c = 'Ecom'  and ccrz__Product__r.ccrz__ProductType__c = 'Product' and ccrz__Category__c IN : categoryIds LIMIT:numberofrecords OFFSET:recorsdToSkip];
        
        List<AggregateResult> ccrzEProductCategoryList = [SELECT COUNT(Id),ccrz__Product__r.ccrz__SKU__c FROM ccrz__E_ProductCategory__c
                                    WHERE ccrz__Product__r.ccrz__ProductStatus__c = 'Released' and
                                    ccrz__Product__r.ccrz__Storefront__c = 'CSSNAStore' and
                                    ccrz__Product__r.Group_Name__c = 'Ecom'  and
                                    ccrz__Product__r.ccrz__ProductType__c = 'Product' and
                                    ccrz__Product__r.DBU_Product_Location__c INCLUDES (:country) and
                                    ccrz__Category__c IN : categoryIds
                                    GROUP BY ccrz__Product__r.ccrz__SKU__c
                                    LIMIT:numberofrecords OFFSET:recorsdToSkip];
        
        System.debug('ccrzEProductCategoryList>>>  ' + ccrzEProductCategoryList.size());
        System.debug('ccrzEProductCategoryList>>>  ' + ccrzEProductCategoryList);
        
        set<string> skuset = new set<string>();
        for(AggregateResult sku : ccrzEProductCategoryList){
                skuset.add((String)sku.get('ccrz__SKU__c'));
            //skuset.add(sku.ccrz__Product__r.ccrz__SKU__c);
        }
        System.debug('skuset>>>  ' + skuset.size());
        System.debug('skuset>>>  ' + skuset);
        
        
        //Start of In Stock Out Stock 29th Jan 2021
        //get the country cureency iso mapping from custom settings
        Map<string,string> countryCurrencyMap = new Map<string,string>();
        
        for(dbu_CountryCurrencyMapping__c eachsetting : (list<dbu_CountryCurrencyMapping__c>)dbu_CountryCurrencyMapping__c.getall().values())
        {
            System.debug('dbuCountryCode__c > ' + (string)eachsetting.get('dbuCountryCode__c'));
            System.debug('dbuCurrencyCode__c > ' + (string)eachsetting.get('dbuCurrencyCode__c'));
            
            countryCurrencyMap.put((string)eachsetting.get('dbuCountryCode__c'), (string)eachsetting.get('dbuCurrencyCode__c'));
        }
        System.debug('countryCurrencyMap > ' + countryCurrencyMap);
        
        string CurrencyISOcodeValue = (string)countryCurrencyMap.get(country);
        
        System.debug('CurrencyISOcodeValue > ' + CurrencyISOcodeValue);
        
        //CHECK FOR INVENTORY
        Map<string,double> productInventorymapping = new Map<string,double>();
        list<AggregateResult> productInventory = new list<AggregateResult>();
        
        productInventory = [SELECT SUM(ccrz__QtyAvailable__c) TOTALQUANTITY, ccrz__ProductItem__c PRODUCTID
                            FROM ccrz__E_ProductInventoryItem__c
                            WHERE ccrz__ProductItem__r.ccrz__SKU__c IN : skuset
                            AND CurrencyIsoCode =: CurrencyISOcodeValue
                            GROUP BY ccrz__ProductItem__c];
        System.debug(productInventory);
        
        if(productInventory.size() > 0)
        {
            for(AggregateResult pi : productInventory)
            {            
                productInventorymapping.put((string)pi.get('PRODUCTID'),(double)pi.get('TOTALQUANTITY'));
                System.debug('productInventorymapping > ' + productInventorymapping);
            }      
            System.debug('productInventorymapping > ' + productInventorymapping);
            System.debug('productInventorymapping size > ' + productInventorymapping.size());  
        }
        //End of In Stock Out Stock 29th Jan 2021
    
        
        /****************************************************************************************************************
         ccrzEProductCategoryList = [SELECT Id,ccrz__Product__r.ccrz__SKU__c,ccrz__Product__r.ccrz__ProductStatus__c,
                                    ccrz__Product__r.ccrz__Storefront__c, ccrz__Product__r.Name,ccrz__Product__r.Group_Name__c,
                                    ccrz__Product__r.ccrz__ProductType__c
                                    FROM ccrz__E_ProductCategory__c
                                    WHERE ccrz__Product__r.ccrz__ProductStatus__c = 'Released' and
                                            ccrz__Product__r.ccrz__Storefront__c = 'CSSNAStore' and
                                            ccrz__Product__r.Group_Name__c = 'Ecom'  and
                                            ccrz__Product__r.ccrz__ProductType__c = 'Product' AND
                                            ccrz__Product__r.DBU_Product_Location__c INCLUDES (:storeCountry) and
                                            ccrz__Category__c IN : categoryIds
                                            LIMIT:numberofrecords OFFSET:recorsdToSkip];
            
            System.debug('ccrzEProductCategoryList>>>  ' + ccrzEProductCategoryList.size());
            System.debug('ccrzEProductCategoryList>>>  ' + ccrzEProductCategoryList);
        
            set<string> skuset = new set<string>();
            for(ccrz__E_ProductCategory__c sku:ccrzEProductCategoryList){
            skuset.add(sku.ccrz__Product__r.ccrz__SKU__c);
            }
            System.debug('skuset>>>  ' + skuset.size());
            System.debug('skuset>>>  ' + skuset);
            ****************************************************************************************************************/
        //productmap = fetchProductResult(skuset);
        productmap = fetchProductResult(skuset, country);
        
        
        System.debug('productmap>>>  ' + productmap.size());
       
        
       
        
        //For Price
        ccrz__E_PriceListItem__c [] pricedata ;
        if(productmap.get('pricedata')!=null)
        {
            pricedata= (ccrz__E_PriceListItem__c [])productmap.get('pricedata');
            system.debug('pricedata'+pricedata);
        }
            //START CECI-960
        Map<String,String> promotionmap=new Map<String,String>();
        if(productmap.get('promotiondata')!=null)
        {
            promotionmap=(Map<String,String>)productmap.get('promotiondata');
            system.debug('promotionmappradeep'+promotionmap);
        }
    
        Map<String,String> corepricemap=new Map<String,String>();
        if(productmap.get('corepricedata')!=null)
        {
            corepricemap=(Map<String,String>)productmap.get('corepricedata');
        }
            //END CECI-960
        if (productmap.get(ccrz.ccAPIProduct.PRODUCTLIST) != null)
        {
            system.debug('inside product list if ');
            List<Map<String, Object>> outputProductList = (List<Map<String, Object>>)productmap.get(ccrz.ccAPIProduct.PRODUCTLIST);
            system.debug('outputProductList'+outputProductList.size());
            system.debug('outputProductList'+outputProductList);
            
            if(outputProductList!=null && outputProductList.size()>0 )
            {
                for(Map<String, Object> productItem:outputProductList)
                {
                    String sfid=(String)productItem.get('sfid');
                    dbu_CCAPIResponseWrapper wrapper = new dbu_CCAPIResponseWrapper();
                    wrapper.productCount = totalProductsNumber;
                    System.debug('wrapper.productCount=>'+ wrapper.productCount);
                    System.debug('obsfid=>'+ (String)productItem.get('sfid'));
                    
                    //For Price
                    wrapper.sfid = (String)productItem.get('sfid');
                
                    //Start of In Stock Out Stock 29th Jan 2021
                    boolean stockstatus = false;
                    double inventoryQuantity = 0;
                    if(productInventorymapping.size() > 0){                                                  
                        if((double)productInventorymapping.get(wrapper.sfid) != null){      
                            inventoryQuantity = (double)productInventorymapping.get(wrapper.sfid);
                            if(inventoryQuantity > 0){
                                stockstatus = true;
                            }else{
                                stockstatus = false;
                            }                                                              
                        }  
                    }                                                                                                  
                    system.debug('stockstatus - ' + stockstatus);                                                  
                    system.debug('inventoryQuantity > ' + inventoryQuantity);
                    
                    wrapper.stockstatus = stockstatus;
                    wrapper.inventoryQuantity = inventoryQuantity;
                    
                    //End of In Stock Out Stock 29th Jan 2021
                    
                    system.debug('priceinwrapper => 82 '+ wrapper.price);
                    if(pricedata!=null)
                    {
                        
                        for(ccrz__E_PriceListItem__c price:pricedata)
                        {   //START CECI-960
                            Double pricevalue;
                            Decimal coreCharge=0;
                            Double totalPrice;
                            Double originalPrice = 0;
                            Double totalOriginalPrice;
                            System.debug('price.ccrz__Product__c>>> ' + price.ccrz__Product__c);
                            System.debug('wrapper.sfid>>> ' + wrapper.sfid);
                            
                            if(price.ccrz__Product__c == wrapper.sfid)
                            {
                                System.debug('Inside If>>>90 ');
                                
                                /*if(price.ccrz__Price__c != 0 || price.ccrz__Price__c != null){
                                    wrapper.price = price.ccrz__Price__c;
                                    wrapper.discountPercentage = Integer.valueOf(price.dbu_Discount_Percent__c);
                                    wrapper.originalPrice =  Integer.valueOf(price.dbu_Original_Price__c);
                                    System.debug('wrapper.price'+  wrapper.price);  
                                }*/
                            if(price.ccrz__Product__r.dbu_Has_Core_Charge__c)
                            {
                                if(corePriceMap.get(wrapper.sfid) != null)
                                {
                                    coreCharge = Decimal.valueof(corepricemap.get(wrapper.sfid));
                                }
                                pricevalue = Double.valueof(price.ccrz__Price__c);
                            
                                totalPrice = pricevalue+coreCharge;
    
                                wrapper.price = totalPrice;
                                wrapper.corecharge=coreCharge;
    
                                if(price.dbu_Original_Price__c != null && price.dbu_Original_Price__c != 0){
                                    originalPrice = Double.valueOf(price.dbu_Original_Price__c);
                                }

                                totalOriginalPrice = originalPrice + coreCharge;
                                wrapper.originalPrice = totalOriginalPrice;
                                if(totalOriginalPrice != 0){
                                    Decimal discountpercentage=(((totalOriginalPrice - Totalprice)*100)/totalOriginalPrice);
                                    wrapper.discountPercentage = Integer.valueof(discountpercentage.round(System.RoundingMode.HALF_EVEN));
                                }
                            } 
                            else
                            {
                                wrapper.price = price.ccrz__Price__c;
                                if(price.dbu_Discount_Percent__c != null){
                                    wrapper.originalPrice= price.dbu_Original_Price__c; //Integer.valueOf(price.dbu_Original_Price__c);
                                    wrapper.discountPercentage = Integer.valueOf(price.dbu_Discount_Percent__c.round(System.RoundingMode.HALF_EVEN));
                                }
                            }
                            
                               //END CECI-960
                                //wrapper.price = price.ccrz__Price__c;
                                //System.debug('wrapper.price'+  wrapper.price);
                            }
                        }
                    }
                    system.debug('priceinwrapper =>'+ wrapper.price);
                    system.debug('sfidinforloop=>>'+wrapper.sfid);
                    
                    wrapper.shortDesc = (String)productItem.get('shortDesc');
                    wrapper.SKU =(String)productItem.get('SKU');
                    //wrapper.sfid = (String)productItem.get('sfid');
                    wrapper.sfdcName = (String)productItem.get('sfdcName');
                    List<Map<String,Object >> productMedia = (List<Map<String,Object >>)productItem.get('EProductMediasS');
                    system.debug('productMedia'+productMedia);
                
                        List<dbu_EProductMediaWrapper> productMediaList = new List<dbu_EProductMediaWrapper>();
                        if(productMedia!=null && productMedia.size()>0)
                        {
                        for(Map<String,Object> mediaItem : productMedia)
                        {
                            if((String)mediaItem.get('mediaType')=='Product Image')
                            {
                                dbu_EProductMediaWrapper media = new dbu_EProductMediaWrapper();
                                media.URI = (String)mediaItem.get('URI');
                                media.mediaType = (String)mediaItem.get('mediaType');
                                media.sfid = (String)mediaItem.get('sfid');
                                productMediaList.add(media);
                                break;
                            }
                        }
                    }
                        //START CECI-960
                    if(promotionmap.containsKey(wrapper.sfid))
                    {
                        system.debug('sfid'+wrapper.sfid);
                        wrapper.promotionCategory= promotionmap.get(wrapper.sfid);
                        system.debug('promotion'+wrapper.promotionCategory);
                    }
                       //END CECI-960
                    wrapper.EProductMediasS =productMediaList;
                    wrapperlist.add(wrapper);
                    System.debug('wrapper=>'+ wrapper);
                }
            }
        }
    }
    catch(Exception e)
    {
        system.debug('Exception Message'+e.getMessage() +''+'Exception Line number'+e.getLineNumber());
    }
        System.debug('wrapperlist=>'+ wrapperlist.size());
        System.debug('wrapperlist=>'+ wrapperlist);
        return wrapperlist;
    }
    
    //public static Map<String,Object> fetchProductResult(Set<String> productSKUSet)
    //public static Map<String,Object> fetchProductResult(List<String> productSKUSet, String storeCountry)
    public static Map<String,Object> fetchProductResult(Set<String> productSKUSet, String storeCountry)
    {
        System.debug('productSKUSet>>>  ' + productSKUSet.size());
        System.debug('productSKUSet>>>  ' + productSKUSet);
        
        //list<ccrz__E_ProductCategory__c> CategoryData;
        list<ccrz__E_PriceListItem__c> pricedata;
        
        set<string> searchIdSet = new set<string>();
        
        Map<String,String> promotion=new  Map<String,String>();
        Map<String,String> corepricedata=new  Map<String,String>();
        List<ccrz__E_Product__c> productList = [SELECT Id FROM ccrz__E_Product__c WHERE ccrz__SKU__c IN:productSKUSet];
        System.debug('productList>>>  ' + productList.size());
        System.debug('productList>>>  ' + productList);
    
        Map<string,string> countryCurrencyMap = new Map<string,string>();
          for(dbu_CountryCurrencyMapping__c eachsetting : (list<dbu_CountryCurrencyMapping__c>)dbu_CountryCurrencyMapping__c.getall().values())
          {
                system.debug('dbuCountryCode__c > ' + (string)eachsetting.get('dbuCountryCode__c'));
                   system.debug('dbuCurrencyCode__c > ' + (string)eachsetting.get('dbuCurrencyCode__c'));
                     countryCurrencyMap.put((string)eachsetting.get('dbuCountryCode__c'), (string)eachsetting.get('dbuCurrencyCode__c'));
            }
                            system.debug('countryCurrencyMap > ' + countryCurrencyMap);
                            
       string currencyISOvalue = (string)countryCurrencyMap.get(storeCountry); 
        system.debug('currencyISOvalue > ' + currencyISOvalue);
        
        for(ccrz__E_Product__c p:productList)
        {
            searchIdSet.add(p.Id);
        }
        if(searchIdSet!=null && searchIdSet.size()>0){
            
            //pricedata=dbu_ProductCtrl.fetchPriceBySearchResult(searchIdSet);
            pricedata = fetchPriceBySearchResult(searchIdSet,storeCountry);
            //START CECI-960
            promotion=dbu_CallCCWishListApi.getProductPromotiontag(searchIdSet,storeCountry);
            
            corepricedata=dbu_ProductCtrl.fetchcorepricebyproductid(searchIdSet,currencyISOvalue);
            //END CECI-960
            
            //CategoryData=dbu_ProductCtrl.fetchCategoryBySearchResult(searchIdSet);
            //system.debug('CategoryData'+CategoryData);
        }
    
        
        System.debug('pricedata>>>  ' + pricedata.size());
        System.debug('pricedata>>>  ' + pricedata);
        //############### INPUT DATA FOR CC PRODUCT FETCH() ##########################
        Map<string,object> ProductInputData = new Map<string,object>{
            ccrz.ccApi.API_VERSION => ccrz.ccApi.CURRENT_VERSION,                  
                ccrz.ccApi.SIZING => new Map<String, Object> {
                    ccrz.ccApiProduct.ENTITYNAME => new Map<String, Object> {
                        ccrz.ccApi.SZ_DATA => ccrz.ccApi.SZ_XL
                            //ccrz.ccApi.SZ_REL => New List<String>{'E_ProductMedias__r'}    
                            }
                },
                    ccrz.ccApiProduct.PRODUCTSKULIST => productSKUSet,                    
                    ccrz.ccApiProduct.PRODUCTSTOREFRONT => 'CSSNAStore',
                    //ccrz.ccApiProduct.PARAM_INCLUDE_PRICING =>true,
                    ccrz.ccApiProduct.TYPES => new Set<String>{'Product'},
            'dBUProductLocation' => storeCountry
        };
            
            //############### FIRE CC PRODUCT FETCH() ##########################
    
           
    
        Map<string, object> ProductsApiResponse = new Map<string, object>();
        try
        {
            ProductsApiResponse = ccrz.ccApiProduct.fetch(ProductInputData);
            system.debug('ProductsApiResponse ::' +ProductsApiResponse.size());
            system.debug('ProductsApiResponse ::' +Json.serialize(ProductsApiResponse) );
            system.debug(ProductsApiResponse.get(ccrz.ccApi.SUCCESS));
            system.debug('pricedata'+pricedata.size());
            //ProductsApiResponse.put('pricedata',pricedata);
        }
        catch(Exception e)
        {
            System.debug('Error' + e.getStackTraceString());
            System.debug('Error' + e.getMessage());
        }
        /*************************************************
        Map<string, object> ProductsApiResponse = ccrz.ccApiProduct.fetch(ProductInputData);
        system.debug('ProductsApiResponse ::' +ProductsApiResponse.size());
        system.debug('ProductsApiResponse ::' +Json.serialize(ProductsApiResponse) );
        system.debug(ProductsApiResponse.get(ccrz.ccApi.SUCCESS));
        system.debug('pricedata'+pricedata.size());
    *************************************************/
        
        //ProductsApiResponse.put('CategoryData',CategoryData);
        ProductsApiResponse.put('pricedata',pricedata);
        //START CECI-960
        ProductsApiResponse.put('promotiondata',promotion);
        system.debug('Testdata'+ProductsApiResponse.get('promotiondata'));
        ProductsApiResponse.put('corepricedata',corepricedata);
        //END CECI-960
        system.debug('ProductsApiResponsemap'+ProductsApiResponse);
        return ProductsApiResponse;                
    }
    public static list<ccrz__E_PriceListItem__c> fetchPriceBySearchResult(set<string> searchid, String storeCountry){
            system.debug('searchid > ' + searchid);
            system.debug('storeCountry > ' + storeCountry);
        list<ccrz__E_PriceListItem__c> price = new list<ccrz__E_PriceListItem__c>();
        try{
            //get the country cureency iso mapping from custom settings
            Map<string,string> countryCurrencyMap = new Map<string,string>();
            for(dbu_CountryCurrencyMapping__c eachsetting : (list<dbu_CountryCurrencyMapping__c>)dbu_CountryCurrencyMapping__c.getall().values()){
                system.debug('dbuCountryCode__c > ' + (string)eachsetting.get('dbuCountryCode__c'));
                system.debug('dbuCurrencyCode__c > ' + (string)eachsetting.get('dbuCurrencyCode__c'));
                countryCurrencyMap.put((string)eachsetting.get('dbuCountryCode__c'), (string)eachsetting.get('dbuCurrencyCode__c'));
            }
            system.debug('countryCurrencyMap > ' + countryCurrencyMap);
            
            string currencyISOvalue = (string)countryCurrencyMap.get(storeCountry);
            
            system.debug('currencyISOvalue > ' + currencyISOvalue);
            
            if(searchid!=null ){
                price= [select id,name,ccrz__Price__c,ccrz__Product__c,ccrz__Product__r.dbu_Has_Core_Charge__c,dbu_Discount_Percent__c,dbu_Original_Price__c from ccrz__E_PriceListItem__c where ccrz__Product__c IN:searchid AND ccrz__Pricelist__r.ccrz__CurrencyISOCode__c = :currencyISOvalue] ;
                
                system.debug('price'+price);
            }
        }
        catch(Exception e)
        {
            system.debug('exception Message'+e.getMessage()+''+'Exception line number'+e.getLineNumber());    
        }
        return price;
    }
    }