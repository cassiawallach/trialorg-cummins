/**
* @description :
* @author : Yash Sethi
* @group :
* @last modified on : 07-15-2022
* @last modified by : ChangeMeIn@UserSettingsUnder.SFDoc
**/
public class dbu_dealsPageController 
{

    @AuraEnabled(cacheable = true)
    public static integer productCountWhenFilter(string categoryIds, string country)
    {
        string currencyCode;
        string productLocation;
        List<ccrz__E_Category__c> brandCategoryList = [select id, name, ccrz__ProductCount__c from ccrz__E_Category__c WHERE dbu_isPromotion__c = FALSE 
                                                                AND ccrz__ParentCategory__c = null
                                                                AND dbu_Category_Location__c INCLUDES (:country)
                                                                AND Storefront__c = 'CSSNAStore'];

        List<string> brandIds = new List<string>();
        for(ccrz__E_Category__c brand : brandCategoryList)
        {
            brandIds.add(brand.id);
        }

        system.debug('brandIds ::: '+brandIds);
        List<String> categoryIdsSet = (List<String>)JSON.deserialize(categoryIds, List<String>.class);

        system.debug('categoryIdsSet before adding child ::::: '+categoryIdsSet);
 
        List<string> childCategoryIds = new List<string>();
        List<string> parentCategoryIds = new List<string>();

        for(string cId : categoryIdsSet)
        {
            id digit18ID = cId;
            if(brandIds.contains(digit18ID))
            {
                parentCategoryIds.add(digit18ID);
            }
        }

        system.debug('parentCategoryIds :::: '+parentCategoryIds);

        List<ccrz__E_Category__c> childCategoryList = new List<ccrz__E_Category__c>();
        List<ccrz__E_Category__c> grandChildCategoryList = new List<ccrz__E_Category__c>();

        if(parentCategoryIds != null && !parentCategoryIds.isEmpty())
        {
            childCategoryList = [select id from ccrz__E_Category__c WHERE ccrz__ParentCategory__c IN :parentCategoryIds];
            grandChildCategoryList = [select id from ccrz__E_Category__c WHERE ccrz__ParentCategory__c IN :childCategoryList];
            for(ccrz__E_Category__c child : childCategoryList)
            {
                childCategoryIds.add(child.id);
            }
            for(ccrz__E_Category__c child : grandChildCategoryList)
            {
                childCategoryIds.add(child.id);
            }
            
        }

        system.debug('childCategoryIds :::: '+childCategoryIds);

        if(!childCategoryIds.isEmpty() && childCategoryIds != null)
        {
            categoryIdsSet.addAll(childCategoryIds);
        }

        List<dbu_productDetailsWrapper> productDetailWrapperList = new List<dbu_productDetailsWrapper>();

        List<string> productIdList = new List<string>();

        system.debug('categoryIdsSet after adding child ::::: '+categoryIdsSet);

        if(categoryIdsSet != null && !categoryIdsSet.isEmpty())
        {
            List<ccrz__E_ProductCategory__c> productCategoryList = [SELECT ccrz__Product__r.id, ccrz__Product__r.name
                                                        FROM ccrz__E_ProductCategory__c
                                                        WHERE ccrz__Product__r.ccrz__ProductStatus__c = 'Released'
                                                        AND ccrz__Product__r.ccrz__Storefront__c = 'CSSNAStore'
                                                        AND ccrz__Category__c IN :categoryIdsSet];

            for(ccrz__E_ProductCategory__c productCategory : productCategoryList)
            {
                
                system.debug('** '+productCategory.ccrz__Product__r.name);
                productIdList.add(productCategory.ccrz__Product__r.id);
            }
        }

        system.debug('productIdList ::: '+productIdList.size());
        List<ccrz__E_Product__c> prodList = new List<ccrz__E_Product__c>();
        if(productIdList != null && !productIdList.isEmpty())
        {
            if(country == 'US')
            {
                currencyCode = 'USD';
                productLocation = 'US';

            }
            else if (country == 'EN' || country == 'FR')
            {
                currencyCode = 'CAD';
                productLocation = 'CA';
            }

           
            prodList = [select id, name, dbu_Part_Number__c, ccrz__SKU__c, dbu_Has_Core_Charge__c
                                        from ccrz__E_Product__c WHERE Id IN (select ccrz__Product__c from ccrz__E_Promo__c 
                                                WHERE ccrz__Enabled__c = true 
                                                AND ccrz__EndDate__c >= today
                                                AND ccrz__StartDate__c <= today
                                                AND ccrz__Storefront__c = 'CSSNAStore'
                                                AND dbu_store_location__c INCLUDES (:country)) 
                                        AND ccrz__ProductStatus__c = 'Released' 
                                        AND ccrz__Storefront__c = 'CSSNAStore'
                                        AND ccrz__StartDate__c <= today 
                                        AND ccrz__EndDate__c>= today
                                        AND dbu_Has_Core_Child__c = False
                                        AND DBU_Product_Location__c INCLUDES (:productLocation)
                                        AND id IN :productIdList];
        }

        system.debug('count :: '+prodList.size());
        return prodList.size();
    }


    /**
    * @description : This Is a utility method used to wrap products into a specific format and uses dbu_productDetailsWrapper class
    * @author : Yash Sethi
    * @group :
    * @last modified on : 07-15-2022
    * @last modified by : ChangeMeIn@UserSettingsUnder.SFDoc
    **/
    public static List<dbu_productDetailsWrapper> productUtility (list<string> productIds, string country, integer pageNumber, integer numberofrecords)
    {
        
        string currencyCode;
        string productLocation;
        Integer recorsdToSkip = (pageNumber -1)*numberofrecords;

        if(country == 'US')
        {
            currencyCode = 'USD';
            productLocation = 'US';

        }
        else if (country == 'EN' || country == 'FR')
        {
            currencyCode = 'CAD';
            productLocation = 'CA';
        }

        system.debug('product size in utility param ::: '+productIds.size());
        List<ccrz__E_Product__c> prodList = [select id, name, dbu_Part_Number__c, ccrz__SKU__c, dbu_Has_Core_Charge__c,
        (select name, ccrz__ImageURI__c, ccrz__Category__r.Name from ccrz__Promotions__r LIMIT 1), 
        (select id, name, ccrz__URI__c from ccrz__E_ProductMedias__r LIMIT 1),
        (select id, ccrz__QtyAvailable__c, ccrz__Status__c from ccrz__Product_Inventory_Items__r WHERE CurrencyIsoCode = :currencyCode LIMIT 1),
        (select id, name, ccrz__Price__c, dbu_Original_Price__c, dbu_Discount_Percent__c from ccrz__E_PriceListItems__r WHERE ccrz__Pricelist__r.ccrz__CurrencyISOCode__c =:currencyCode LIMIT 1)
        from ccrz__E_Product__c WHERE Id IN (select ccrz__Product__c from ccrz__E_Promo__c 
                                                WHERE ccrz__Enabled__c = true 
                                                AND ccrz__EndDate__c >= today
                                                AND ccrz__StartDate__c <= today
                                                AND ccrz__Storefront__c = 'CSSNAStore'
                                                AND dbu_store_location__c INCLUDES (:country)) 
                                        AND ccrz__ProductStatus__c = 'Released' 
                                        AND ccrz__Storefront__c = 'CSSNAStore'
                                        AND ccrz__StartDate__c <= today 
                                        AND ccrz__EndDate__c>= today
                                        AND dbu_Has_Core_Child__c = False
                                        AND DBU_Product_Location__c INCLUDES (:productLocation)
                                        AND id IN :productIds LIMIT:numberofrecords OFFSET:recorsdToSkip];

                                                                                        
        List <dbu_productDetailsWrapper> productDetailWrapperList = new List<dbu_productDetailsWrapper>();
        
        system.debug('eligible products :: '+prodList.size());

        set<string> prodIdSet = new set<string>();
        List<string>ProductIdList = new List<string>();
        Map<string,double> productInventoryMap = new Map<string,double>();

        if(!prodList.isEmpty())
        {
            for(ccrz__E_Product__c product : prodList)
            {
                prodIdSet.add((string)product.id);
                ProductIdList.add(product.id);
            }

            map<string, string> corePriceMap = dbu_ProductCtrl.fetchcorepricebyproductid(prodIdSet, currencyCode);
            productInventoryMap = ccLogicProductFind.getProductInventorydetails(currencyCode, ProductIdList); 

            for(ccrz__E_Product__c product : prodList)
            {
                system.debug('eligible product id :: ' +product.id);
                system.debug('eligible product name :: ' +product.name);

                // Map<string,double> productInventoryMap = new Map<string,double>();
                // List<string>ProductIdList = new List<string>();
                // ProductIdList.add(product.id);

                // set<string> prodIdSet = new set<string>();
                // prodIdSet.add((string)product.id);
                
                //map<string, string> corePriceMap = dbu_ProductCtrl.fetchcorepricebyproductid(prodIdSet, currencyCode);
                dbu_productDetailsWrapper productDetail = new dbu_productDetailsWrapper();
                productDetail.productCount = prodList.size();
                productDetail.sfId = product.id;
                productDetail.productName = product.name;
                productDetail.partNumber = product.dbu_Part_Number__c;
                productDetail.SKU = product.ccrz__SKU__c; 
                if(product.ccrz__E_PriceListItems__r.size() > 0)
                {
                    if(product.dbu_Has_Core_Charge__c)
                    {         
                        decimal coreCharge= 0;
                        if(corePriceMap.get(product.id) != null)
                        {
                            coreCharge = Decimal.valueof(corepricemap.get(product.id));
                        }
                        Decimal Totalprice = coreCharge + product.ccrz__E_PriceListItems__r[0].ccrz__Price__c;
                        productDetail.price = Totalprice;
                        
                        Decimal originalPrice = coreCharge + product.ccrz__E_PriceListItems__r[0].dbu_Original_Price__c;
                        productDetail.originalPrice = originalPrice;
                        
                        productDetail.discountPercentage = (((originalPrice - Totalprice)*100)/originalPrice).round(System.RoundingMode.HALF_EVEN);
                             
                    }

                    else
                    {
                        productDetail.price = product.ccrz__E_PriceListItems__r[0].ccrz__Price__c;
                        productDetail.originalPrice = product.ccrz__E_PriceListItems__r[0].dbu_Original_Price__c;
                        productDetail.discountPercentage = Integer.valueOf(product.ccrz__E_PriceListItems__r[0].dbu_Discount_Percent__c);
                    }

                    
                } 
                

                if(product.ccrz__Promotions__r.size() > 0)
                {
                    productDetail.saleTag = product.ccrz__Promotions__r[0].ccrz__Category__r.Name;
                    productDetail.promotionImageURI = product.ccrz__Promotions__r[0].ccrz__ImageURI__c;
                }
                
                if(product.ccrz__E_ProductMedias__r.size() > 0)
                {
                    productDetail.productImageURI = product.ccrz__E_ProductMedias__r[0].ccrz__URI__c;
                }

                //productInventoryMap = ccLogicProductFind.getProductInventorydetails(currencyCode, ProductIdList); 
                                 
                if(productInventoryMap.size() > 0)
                {                                                   
                    if((double)productInventoryMap.get(product.id) != null){        
                        double inventoryQuantity = (double)productInventoryMap.get(Product.id);
                        if(inventoryQuantity > 0)
                        {
                            productDetail.inventoryStatus = True;
                            productDetail.inventoryQuantity = inventoryQuantity;
                        }else
                        {
                            productDetail.inventoryStatus = False; 
                            productDetail.inventoryQuantity = inventoryQuantity;
                        }                                                               
                    }    
                }

                productDetailWrapperList.add(productDetail);
                
            }
        }

        return productDetailWrapperList;
    }

    /**
    * @description : This method is used to fetch all categories and brands having an active peomotion product
    * @author : Yash Sethi
    * @group :
    * @last modified on : 07-15-2022
    * @last modified by : ChangeMeIn@UserSettingsUnder.SFDoc
    **/
    @AuraEnabled(cacheable = true)
    public static map<string, List<ccrz__E_Category__c>> fetchCategoriesForDealsPage(string country)
    {
        string productLocation;

        if(country == 'US')
        {
            productLocation = 'US';
        }
        else if (country == 'EN' || country == 'FR')
        {
            productLocation = 'CA';
        }

        map<string, List<ccrz__E_Category__c>> categoryMap = new map<string, List<ccrz__E_Category__c>>();
        List<ccrz__E_Category__c> promotionCategoryList = new List<ccrz__E_Category__c>();
        List<ccrz__E_Category__c> brandCategoryList = new List<ccrz__E_Category__c>();
        List<ccrz__E_Category__c> subCategoryList = new List<ccrz__E_Category__c>();
        list<string> prodIds = new List<string>();
        list<string> categoryIds = new List<string>();

        List<ccrz__E_Promo__c> promoList = [select ccrz__Product__c from ccrz__E_Promo__c 
                        WHERE ccrz__Enabled__c = true 
                        AND ccrz__EndDate__c >= today
                        AND ccrz__StartDate__c <= today
                        AND ccrz__Storefront__c = 'CSSNAStore'
                        AND dbu_store_location__c INCLUDES (:country)
                    AND ccrz__Product__r.ccrz__ProductStatus__c = 'Released' 
                    AND ccrz__Product__r.ccrz__Storefront__c = 'CSSNAStore'
                    AND ccrz__Product__r.ccrz__StartDate__c <= today 
                    AND ccrz__Product__r.ccrz__EndDate__c>= today
                    AND ccrz__Product__r.dbu_Has_Core_Child__c = False
                    AND ccrz__Product__r.DBU_Product_Location__c INCLUDES (:productLocation)];

        for(ccrz__E_Promo__c promo : promoList)
        {
            prodIds.add(promo.ccrz__Product__c);
        }
        

        list<ccrz__E_ProductCategory__c> productCategoryList = [SELECT ccrz__Category__r.name, ccrz__Category__r.ccrz__ParentCategory__c, ccrz__Category__r.ccrz__ParentCategory__r.ccrz__ParentCategory__c,
        ccrz__Category__r.ccrz__LongDescRT__c, ccrz__Category__r.ccrz__ShortDescRT__c,
        ccrz__Category__r.ccrz__ParentCategory__r.ccrz__ParentCategory__r.ccrz__ParentCategory__c,
        ccrz__Category__r.ccrz__ParentCategory__r.ccrz__ParentCategory__r.ccrz__ParentCategory__r.name,
		ccrz__Category__r.ccrz__ParentCategory__r.ccrz__ParentCategory__r.ccrz__ParentCategory__r.ccrz__ParentCategory__r.name,
        ccrz__Category__r.ccrz__ParentCategory__r.ccrz__ParentCategory__r.dbu_isPromotion__c,
        ccrz__Category__r.ccrz__ParentCategory__r.ccrz__ParentCategory__r.ccrz__ShortDescRT__c,
        ccrz__Category__r.ccrz__ParentCategory__r.ccrz__ParentCategory__r.ccrz__LongDescRT__c,
        ccrz__Category__r.ccrz__ParentCategory__r.ccrz__ParentCategory__r.name,
        ccrz__Category__r.ccrz__ParentCategory__r.name,
        ccrz__Category__r.ccrz__ParentCategory__r.ccrz__ShortDescRT__c,
        ccrz__Category__r.ccrz__ParentCategory__r.ccrz__LongDescRT__c,
        ccrz__Category__r.ccrz__ParentCategory__r.id,
                                                                    ccrz__Category__r.dbu_isPromotion__c, ccrz__Category__r.dbu_Category_Location__c, ccrz__Product__c 
                                                                    from ccrz__E_ProductCategory__c
                                                                    WHERE ccrz__Product__c IN :prodIds
                                                                    AND ccrz__Category__r.dbu_Category_Location__c INCLUDES (:country)];

        for(ccrz__E_ProductCategory__c pc : productCategoryList)
        {
            system.debug('main parent :: '+pc.ccrz__Category__r.ccrz__ParentCategory__c);
            system.debug('main parent :: '+pc.ccrz__Category__r.dbu_isPromotion__c);
            
            system.debug('***************************************');
            if(pc.ccrz__Category__r.ccrz__ParentCategory__c != null && pc.ccrz__Category__r.dbu_isPromotion__c == true)
            {
                if(!promotionCategoryList.contains(pc.ccrz__Category__r))
                {
                    promotionCategoryList.add(pc.ccrz__Category__r);
                }
                
            }
            if(pc.ccrz__Category__r.ccrz__ParentCategory__c != null && pc.ccrz__Category__r.dbu_isPromotion__c == false)
            {
                system.debug('sub category');
                if(!subCategoryList.contains(pc.ccrz__Category__r) && (pc.ccrz__Category__r.ccrz__ParentCategory__r.ccrz__ParentCategory__r.ccrz__ParentCategory__r.name == null))
                {
                    subCategoryList.add(pc.ccrz__Category__r);
                }
            }
            if(pc.ccrz__Category__r.ccrz__ParentCategory__r.ccrz__ParentCategory__r.ccrz__ParentCategory__c == null && pc.ccrz__Category__r.ccrz__ParentCategory__r.ccrz__ParentCategory__r.dbu_isPromotion__c == false)
            {
                if(!brandCategoryList.contains(pc.ccrz__Category__r.ccrz__ParentCategory__r.ccrz__ParentCategory__r))
                {
                    brandCategoryList.add(pc.ccrz__Category__r.ccrz__ParentCategory__r.ccrz__ParentCategory__r);
                }
            }        
        }

        categoryMap.put('promotionCategoryList', promotionCategoryList);
        categoryMap.put('brandCategoryList', brandCategoryList);
        categoryMap.put('allSubCategoryList', subCategoryList);

        return categoryMap;
    }

       /**
    * @description : This method is used to fetch top 5 products with discounts applied
    * @author : Vaishnavi Suthram
    * @group :
    * @last modified on : 07-15-2022
    * @last modified by : ChangeMeIn@UserSettingsUnder.SFDoc
    **/    
    @AuraEnabled(cacheable = true) 
    public static List<dbu_productDetailsWrapper> fetchProductsForClearance(string country, string fetchProductsBy)
    {

        string currencyCode;
        string productCountryCode;
        if(country == 'US')
        {
            currencyCode = 'USD';
            productCountryCode = 'US';
        }
        else if (country == 'EN' || country == 'FR')
        {
            currencyCode = 'CAD';
            productCountryCode = 'CA';
        }

        List<ccrz__E_PriceListItem__c> productList = [SELECT ccrz__Product__r.name,dbu_Core_Discount_Percent__c,dbu_Discount_Percent__c,ccrz__Product__r.DBU_Product_Location__c,ccrz__Product__r.dbu_Has_Core_Child__c,ccrz__Product__r.ccrz__EndDate__c,ccrz__Product__r.ccrz__StartDate__c,ccrz__Product__r.ccrz__Storefront__c,ccrz__Product__c,ccrz__Product__r.ccrz__productStatus__c FROM ccrz__E_PriceListItem__c 
                                                        WHERE ccrz__Product__c in (select ccrz__Product__c from ccrz__E_Promo__c WHERE ccrz__Enabled__c = true AND ccrz__EndDate__c >= today AND ccrz__StartDate__c <= today AND dbu_store_location__c INCLUDES (:country) AND ccrz__Storefront__c = 'CSSNAStore') 
                                                        AND dbu_Core_Discount_Percent__c != null
                                                        AND ccrz__Pricelist__r.ccrz__CurrencyISOCode__c =:currencyCode
                                                        AND ccrz__Product__r.ccrz__productStatus__c = 'Released'
                                                        AND ccrz__Product__r.ccrz__Storefront__c = 'CSSNAStore'
                                                        AND ccrz__Product__r.ccrz__StartDate__c <= today 
                                                        AND ccrz__Product__r.ccrz__EndDate__c>= today
                                                        AND ccrz__Product__r.dbu_Has_Core_Child__c = False
                                                        AND ccrz__Product__r.DBU_Product_Location__c INCLUDES (:productCountryCode)
                                                        ORDER BY dbu_Core_Discount_Percent__c DESC 
                                                        LIMIT 5
                                                        ];
        Set<String> prodSFID = new Set<String>();
        Set<String> prodID = new Set<String>();//Added CECI-958
        for(ccrz__E_PriceListItem__c productID : productList)
        {
            prodSFID.add(productID.ccrz__Product__c);
            system.debug(productID.ccrz__Product__r.name +'<==> '+ productID.dbu_Discount_Percent__c +'<==> '+ productID.ccrz__Product__r.DBU_Product_Location__c);

        }
        Map<String,String> productCoreChargeMap = dbu_ProductCtrl.fetchcorepricebyproductid(prodSFID, currencyCode);
        List<ccrz__E_Product__c> productList1 = [SELECT Id, name, ccrz__Sequence__c,dbu_Has_Core_Charge__c,ccrz__SKU__c,
                                        (select name, ccrz__ImageURI__c, ccrz__Category__r.Name from ccrz__Promotions__r LIMIT 1), 
                                        (select id, name, ccrz__URI__c from ccrz__E_ProductMedias__r LIMIT 1),
                                        (select id, name, ccrz__Price__c, dbu_Core_Discount_Percent__c, dbu_Original_Price__c, dbu_Discount_Percent__c, ccrz__Pricelist__r.Name from ccrz__E_PriceListItems__r WHERE ccrz__Pricelist__r.ccrz__CurrencyISOCode__c = :currencyCode LIMIT 1)
                                        FROM ccrz__E_Product__c WHERE Id IN (select ccrz__Product__c from ccrz__E_Promo__c 
                                                        WHERE ccrz__Enabled__c = true 
                                                        AND ccrz__EndDate__c >= today
                                                        AND ccrz__StartDate__c <= today
                                                        AND ccrz__Storefront__c = 'CSSNAStore'
                                                        AND dbu_store_location__c INCLUDES (:country)) 
                                            AND Id = :prodSFID 
                                            AND ccrz__ProductStatus__c = 'Released' 
                                            AND ccrz__Storefront__c = 'CSSNAStore'
                                            AND ccrz__StartDate__c <= today 
                                            AND ccrz__EndDate__c>= today
                                            AND dbu_Has_Core_Child__c = False
                                            AND DBU_Product_Location__c INCLUDES (:productCountryCode)
                                        ];
                //START CECI-958
            for(ccrz__E_Product__c productID : productList1)
            {
             prodID.add(productId.id);
                                           
            }                             

           Map<string,string> CategoryMap =dbu_ProductCtrl.getcategoryfromproductid(prodID,country);//Added CECI-958
           SYSTEM.DEBUG('catmap'+CategoryMap );
            Map<string,string> BrandMap = dbu_ProductCtrl.getBrandfromproductid(prodID,country); //Added CECI-958  
            SYSTEM.DEBUG('brandmap'+BrandMap );                        
              //END CECI-958
        List <dbu_productDetailsWrapper> productWrapperList = new List<dbu_productDetailsWrapper>();

        if(!productList.isEmpty())
        {
            for(ccrz__E_Product__c product : productList1)
            {
                dbu_productDetailsWrapper prodDetail = new dbu_productDetailsWrapper();
                Double price;
                Double coreCharge = 0;
                Double totalPrice;
                Double originalPrice = 0;
                Double totalOriginalPrice;
                prodDetail.sfId = product.id;
                prodDetail.productName = product.name;
                prodDetail.sequence = product.ccrz__Sequence__c;
                prodDetail.SKU=product.ccrz__SKU__c;
                //START CECI-958
               
                if(BrandMap.containsKey( prodDetail.sfId ))
                {
                    
                    SYSTEM.DEBUG('Inside'+BrandMap.get( prodDetail.sfId ));
                    prodDetail.Brandname=BrandMap.get( prodDetail.sfId );
                }
               
                 if(CategoryMap.containsKey( prodDetail.sfId ))
                {
                   
                    SYSTEM.DEBUG('Insidecat'+CategoryMap.get( prodDetail.sfId ));
                    prodDetail.Categoryname=CategoryMap.get( prodDetail.sfId );
                }
                //END CECI-958
                

                
                if(product.ccrz__E_PriceListItems__r.size() > 0){
                    prodDetail.priceListName = product.ccrz__E_PriceListItems__r[0].ccrz__Pricelist__r.Name;  
                    if(product.dbu_Has_Core_Charge__c = true  && productCoreChargeMap.size() > 0)
                    {
                        price = double.valueof(product.ccrz__E_PriceListItems__r[0].ccrz__Price__c);
                        if(productCoreChargeMap.get(product.id) != null)
                        {
                            coreCharge = double.valueof(productCoreChargeMap.get(product.id));
                        }
                        totalPrice = price + coreCharge;
                        prodDetail.price =  totalPrice;
                        if(product.ccrz__E_PriceListItems__r[0].dbu_Original_Price__c != null)
                        {
                            originalPrice = product.ccrz__E_PriceListItems__r[0].dbu_Original_Price__c;
                        }
                        //originalPrice = product.ccrz__E_PriceListItems__r[0].dbu_Original_Price__c;
                        totalOriginalPrice = originalPrice + coreCharge;
                        prodDetail.originalPrice = totalOriginalPrice;
                        Decimal discountpercentage=(((totalOriginalPrice - totalPrice)*100)/totalOriginalPrice);
                        prodDetail.discountPercentage = Integer.valueof(discountpercentage.round(System.RoundingMode.HALF_EVEN));
                    }else {
                        prodDetail.price = double.valueof(product.ccrz__E_PriceListItems__r[0].ccrz__Price__c);
                        prodDetail.originalPrice = product.ccrz__E_PriceListItems__r[0].dbu_Original_Price__c;
                        prodDetail.discountPercentage = Integer.valueOf(product.ccrz__E_PriceListItems__r[0].dbu_Core_Discount_Percent__c);
                    }
                    

                }
                if(product.ccrz__E_ProductMedias__r.size() > 0){
                    prodDetail.productImageURI = product.ccrz__E_ProductMedias__r[0].ccrz__URI__c;
                }
                if(product.ccrz__Promotions__r.size() > 0){
                    prodDetail.promotionImageURI = product.ccrz__Promotions__r[0].ccrz__ImageURI__c;
                    prodDetail.saleTag = product.ccrz__Promotions__r[0].ccrz__Category__r.Name;
                }
                productWrapperList.add(prodDetail);


            }
        }
                     system.debug('product.name->>'+ productWrapperList.size());
                     system.debug('Final'+ productWrapperList);
        return productWrapperList;
    }


    /**
    * @description : This method is used to fetch all products from Category Ids
    * @author : Yash Sethi
    * @group :
    * @last modified on : 07-15-2022
    * @last modified by : ChangeMeIn@UserSettingsUnder.SFDoc
    **/
    @AuraEnabled(cacheable = true)
    public static List<dbu_productDetailsWrapper> fetchProductsFromCategoryIds(string categoryIds, string country, integer pageNumber, integer numberofrecords)
    {
       
            List<ccrz__E_Category__c> brandCategoryList = [select id, name, ccrz__ProductCount__c from ccrz__E_Category__c WHERE dbu_isPromotion__c = FALSE 
                                                                AND ccrz__ParentCategory__c = null
                                                                AND dbu_Category_Location__c INCLUDES (:country)];

            List<string> brandIds = new List<string>();
            for(ccrz__E_Category__c brand : brandCategoryList)
            {
                brandIds.add(brand.id);
            }

            system.debug('brandIds ::: '+brandIds);
            List<String> categoryIdsSet = (List<String>)JSON.deserialize(categoryIds, List<String>.class);

            system.debug('categoryIdsSet before adding child ::::: '+categoryIdsSet);
    
            List<string> childCategoryIds = new List<string>();
            List<string> parentCategoryIds = new List<string>();

            for(string cId : categoryIdsSet)
            {
                id digit18ID = cId;
                if(brandIds.contains(digit18ID))
                {
                    parentCategoryIds.add(digit18ID);
                }
            }

            system.debug('parentCategoryIds :::: '+parentCategoryIds);

            List<ccrz__E_Category__c> childCategoryList = new List<ccrz__E_Category__c>();
            List<ccrz__E_Category__c> grandChildCategoryList = new List<ccrz__E_Category__c>();

            if(parentCategoryIds != null && !parentCategoryIds.isEmpty())
            {
                childCategoryList = [select id from ccrz__E_Category__c WHERE ccrz__ParentCategory__c IN :parentCategoryIds];
                grandChildCategoryList = [select id from ccrz__E_Category__c WHERE ccrz__ParentCategory__c IN :childCategoryList];
                for(ccrz__E_Category__c child : childCategoryList)
                {
                    childCategoryIds.add(child.id);
                }
                for(ccrz__E_Category__c child : grandChildCategoryList)
                {
                    childCategoryIds.add(child.id);
                }
                
            }

            system.debug('childCategoryIds :::: '+childCategoryIds);

            if(!childCategoryIds.isEmpty() && childCategoryIds != null)
            {
                categoryIdsSet.addAll(childCategoryIds);
            }

            List<dbu_productDetailsWrapper> productDetailWrapperList = new List<dbu_productDetailsWrapper>();

            List<string> productIdList = new List<string>();

            system.debug('categoryIdsSet after adding child ::::: '+categoryIdsSet);

            if(categoryIdsSet != null && !categoryIdsSet.isEmpty())
            {
                List<ccrz__E_ProductCategory__c> productCategoryList = [SELECT ccrz__Product__r.id, ccrz__Product__r.name
                                                            FROM ccrz__E_ProductCategory__c
                                                            WHERE ccrz__Product__r.ccrz__ProductStatus__c = 'Released'
                                                            AND ccrz__Product__r.ccrz__Storefront__c = 'CSSNAStore'
                                                            AND ccrz__Category__c IN :categoryIdsSet];

                for(ccrz__E_ProductCategory__c productCategory : productCategoryList)
                {
                    
                    system.debug('** '+productCategory.ccrz__Product__r.name);
                    productIdList.add(productCategory.ccrz__Product__r.id);
                }
            }

            system.debug('productIdList ::: '+productIdList.size());
            if(productIdList != null && !productIdList.isEmpty())
            {
                productDetailWrapperList = productUtility(productIdList, country, pageNumber, numberofrecords);
            }

            system.debug(productDetailWrapperList.size());
            return productDetailWrapperList;       
    }

     
}