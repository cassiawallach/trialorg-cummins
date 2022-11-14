/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 09-15-2022
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
public without sharing class ccLogicProductFind 
{
        
    public static list<string> SearchProductIDs(string searchKey, string storeCountry){
        
        list<List<ccrz__E_Product__c>> ProductIDlist = new list<List<ccrz__E_Product__c>>();
        list<string> returnProductsIDsList = new list<string>();

        //performing SOSL Search        
        ProductIDlist = [FIND :searchKey IN  All fields 
                         RETURNING ccrz__E_Product__c(Id 
                                                      WHERE ccrz__ProductStatus__c = 'Released' 
                                                      AND ccrz__ProductType__c != 'Coupon' 
                                                      AND ccrz__Storefront__c includes ('CSSNAStore') 
                                                      AND ccrz__StartDate__c <= TODAY 
                                                      AND ccrz__EndDate__c >= TODAY 
                                                      AND  DBU_Product_Location__c INCLUDES (:storeCountry) 
                                                      AND  (dbu_Has_Core_Charge__c= true or dbu_Has_Core_Charge__c= false) 
                                                      AND dbu_Has_Core_Child__c=false) LIMIT 100];
        
        if(!ProductIDlist[0].isEmpty()){
            system.debug('ProductIDlist[0] SOSL ESN > ' + ProductIDlist[0]);
            for(ccrz__E_Product__c eachProductID : ProductIDlist[0]){
                returnProductsIDsList.add(string.valueof(eachProductID.Id));
            }
            system.debug('returnProductsIDsList > ' + returnProductsIDsList);
            
        }
        
        if(test.isRunningTest()){
            list<ccrz__E_Product__c>  prod = [Select id from ccrz__E_Product__c where Name like : '%'+searchKey+'%'];
            system.debug('prod > ' + prod);
            for(ccrz__E_Product__c eachp : prod){
                returnProductsIDsList.add(eachp.id);
            }
            system.debug('returnProductsIDsList > ' + returnProductsIDsList);            
        }        
        
       return returnProductsIDsList; 
    }
    
    
    public static GrandCategoryResponse retriveParentCategoryNames(set<string> categoriesIDset){
        List<ccrz__E_Category__c> parentcategoriesList = new List<ccrz__E_Category__c >();
        set<id> grandparentcategoriesIDset = new set<id>();
        GrandCategoryResponse grandCatResp = new GrandCategoryResponse();
        if(categoriesIDset.size() > 0){
            parentcategoriesList = [select Id, 
                                            Name
                                            FROM ccrz__E_Category__c 
                                            WHERE Id IN :categoriesIDset];
             
            if(parentcategoriesList.size() > 0 && parentcategoriesList != null){
                for(ccrz__E_Category__c eachgrandcategory :parentcategoriesList){                    
                    grandparentcategoriesIDset.add(eachgrandcategory.ccrz__ParentCategory__r.Id);
                }                
            }
            
            grandCatResp.GrandCategorylist  = parentcategoriesList;
            grandCatResp.GrandCategoryIDSet = grandparentcategoriesIDset;
            
        }
        return grandCatResp;
    }
    
    
    public static ProductCategoryResponse retriveProductCategories(set<string> searchedProductsIdsList){
        ProductCategoryResponse ProdCategoryResp = new ProductCategoryResponse();
        List<ccrz__E_ProductCategory__c> ProductCategoriesList = new List<ccrz__E_ProductCategory__c>();
        set<string> GrandCategoryIDSet = new set<string>();
        Map<string,set<string>> ProductIdToCategoryNameMap = new Map<string,set<string>>();        
        if(searchedProductsIdsList != null && searchedProductsIdsList.size() > 0){
            ProductCategoriesList = [select id,
                                     name,
                                     ccrz__Product__c,
                                     ccrz__Category__r.dbu_isPromotion__c,
                                     ccrz__Category__r.name, 
                                     ccrz__Category__r.id,
                                     ccrz__Category__r.ccrz__ParentCategory__c,
                                     ccrz__Category__r.ccrz__ParentCategory__r.ccrz__ParentCategory__c, 
                                     ccrz__Category__r.ccrz__ParentCategory__r.ccrz__ParentCategory__r.Name 
                                     from ccrz__E_ProductCategory__c 
                                     where ccrz__Product__c IN :searchedProductsIdsList AND ccrz__Category__r.dbu_isPromotion__c=false];
            
            system.debug('ProductCategoriesList > ' + ProductCategoriesList);
            
            if(ProductCategoriesList.size() > 0){
                for(ccrz__E_ProductCategory__c eachcategory :ProductCategoriesList){
                    //parentcat.add(category.ccrz__Category__r.name);
                    //ParentCategoryIDSet.add(eachcategory.ccrz__Category__r.id);
                    if(eachcategory.ccrz__Category__r != null){
                        //system.debug('io > ' + eachcategory.ccrz__Category__r.ccrz__ParentCategory__c);
                        if(eachcategory.ccrz__Category__r.ccrz__ParentCategory__r != null){
                            GrandCategoryIDSet.add(eachcategory.ccrz__Category__r.ccrz__ParentCategory__r.ccrz__ParentCategory__r.Name);
                            //system.debug('io ko > ' + eachcategory.ccrz__Category__r.ccrz__ParentCategory__r.ccrz__ParentCategory__c);    
                            if(ProductIdToCategoryNameMap.get(eachcategory.ccrz__Product__c) != null){
                                set<string> productGrandId = new set<string>();
                                productGrandId = (set<string>)ProductIdToCategoryNameMap.get(eachcategory.ccrz__Product__c);
                                productGrandId.add(eachcategory.ccrz__Category__r.ccrz__ParentCategory__r.ccrz__ParentCategory__r.Name);
                                ProductIdToCategoryNameMap.put(eachcategory.ccrz__Product__c, productGrandId);
                                system.debug('ProductIdToCategoryNameMapinside>>>>>'+ProductIdToCategoryNameMap);
                            }else{
                                ProductIdToCategoryNameMap.put(eachcategory.ccrz__Product__c,new set<string>{eachcategory.ccrz__Category__r.ccrz__ParentCategory__r.ccrz__ParentCategory__r.Name});
                                system.debug('ProductIdToCategoryNameMapinsideelse>>>>>'+ProductIdToCategoryNameMap);
                            }
                        }
                    }         
                }                
            }
            system.debug('ProductIdToCategoryNameMap>>>>>'+ProductIdToCategoryNameMap);
            
            
            ProdCategoryResp.productBrandMap  = ProductIdToCategoryNameMap;
            ProdCategoryResp.productCategoryIDSet = GrandCategoryIDSet;
        }
        return ProdCategoryResp;
        
    }
       
    
    public static list<string> convertlistOfIDToString(list<id> listofID ){
        list<string> listofString = new list<string>();
            if(listofID != null && listofID.size() > 0){
                for(id eachID : listofID){
                    listofString.add(string.valueOf(eachID));
                }                   
            }
        return listofString;
    }
      
    
    public static Map<string,object> getProductDetailedInformation_Normal_Search(set<string> productIDset, string storeCountry){
        system.debug('<<<<<<<<<<<<<<<< entering in getProductDetailedInformation_Normal_Search >>>>>>>>>>>');
        system.debug('productIDset > ' + productIDset);
        
        //get the country cureency iso mapping from custom settings
        Map<string,string> countryCurrencyMap = new Map<string,string>();
        for(dbu_CountryCurrencyMapping__c eachsetting : (list<dbu_CountryCurrencyMapping__c>)dbu_CountryCurrencyMapping__c.getall().values()){
            system.debug('dbuCountryCode__c > ' + (string)eachsetting.get('dbuCountryCode__c'));
            system.debug('dbuCurrencyCode__c > ' + (string)eachsetting.get('dbuCurrencyCode__c'));
            countryCurrencyMap.put((string)eachsetting.get('dbuCountryCode__c'), (string)eachsetting.get('dbuCurrencyCode__c'));
        }
        system.debug('countryCurrencyMap > ' + countryCurrencyMap);        
        string currencyISOvalue = (string)countryCurrencyMap.get(storeCountry); 
        if(test.isRunningTest()){
            currencyISOvalue = 'USD';
        }
        
        List<ccrz__E_Product__c> ProductDetailslist = new List<ccrz__E_Product__c>();
        list<string> ProductIDslist = new list<string>();
        Map<string,object> ProductreturnMap = new map<string,object>();
        //START CECI-1213 
        string locationcode;
        if(currencyISOvalue=='USD')
        {
            locationcode='US';
        }
        else if(currencyISOvalue=='CAD')
        {
            locationcode='EN';
        }
        //END CECI-1213
        
        if(productIDset.size() > 0 && productIDset != null){            
        Map<id,ccrz__E_Product__c> productDetailsMap = new Map<id,ccrz__E_Product__c>([SELECT Id,
                              Name,
                              OwnerId,
                              ccrz__SKU__c,
                              ccrz__ShortDesc__c,
                              ccrz__ProductStatus__c,
                              ccrz__ProductType__c,
                              ccrz__StartDate__c,
                              ccrz__ShortDescRT__c,
                              ccrz__UnitOfMeasure__c,
                              ccrz__AvailabilityMessageRT__c,
                              ccrz__EndDate__c,
                              ccrz__AverageRating__c,
                              ccrz__Taxable__c,
                              DBU_Product_Location__c, 
                              dbu_Has_Core_Child__c,
                              dbu_Has_Core_Charge__c,
                              createddate,
                              dbu_FullPartNumber__c, 
                              dbu_Part_Number__c, 
                              (select name, ccrz__ImageURI__c, ccrz__Category__r.Name from ccrz__Promotions__r  
                                WHERE ccrz__Enabled__c = true 
                                AND ccrz__EndDate__c >= today
                                AND ccrz__StartDate__c <= today
                                AND ccrz__Storefront__c = 'CSSNAStore'
                                AND dbu_store_location__c INCLUDES (:locationcode)
                                LIMIT 1), 
                              (SELECT Id, Name, RecordTypeId, ccrz__Product__c, ccrz__AltMessage__c, ccrz__Enabled__c, ccrz__EndDate__c, ccrz__FilePath__c, ccrz__MediaType__c, ccrz__ProductDescription__c, ccrz__ProductMediaId__c, ccrz__ProductMediaSource__c, ccrz__Sequence__c, ccrz__StartDate__c, ccrz__StaticResourceName__c, ccrz__URI__c FROM ccrz__E_ProductMedias__r WHERE (ccrz__StartDate__c <=TODAY AND ccrz__EndDate__c >= TODAY) AND ccrz__Enabled__c = TRUE AND ccrz__URI__c != NULL AND ccrz__MediaType__c = 'Product Image' ), 
                              (select id, Name, ccrz__Price__c, ccrz__Product__c,dbu_Discount_Percent__c,dbu_Original_Price__c FROM ccrz__E_PriceListItems__r where ccrz__Pricelist__r.ccrz__CurrencyISOCode__c = :currencyISOvalue),
                              (select id, name, ccrz__Product__c,ccrz__Category__r.name from ccrz__Product_Categories__r where ccrz__Category__r.dbu_isPromotion__c=false)                                                                                       
                              FROM ccrz__E_Product__c 
                              WHERE ccrz__Storefront__c includes ('CSSNAStore')  
                              AND  (ccrz__ProductStatus__c = 'Released' OR ccrz__ProductStatus__c = 'Not Orderable')   
                              AND  (ccrz__StartDate__c = null or ccrz__StartDate__c <= TODAY) 
                              AND  (ccrz__EndDate__c = null or ccrz__EndDate__c >= TODAY) 
                              AND  DBU_Product_Location__c INCLUDES (:storeCountry)  
                              AND  ((dbu_Has_Core_Charge__c= true or dbu_Has_Core_Charge__c= false) AND dbu_Has_Core_Child__c=false)
                              AND Id in :productIDset LIMIT 100]); 
        
            if(productDetailsMap.size() > 0){
                ProductDetailslist = productDetailsMap.values();
                ProductIDslist =  convertlistOfIDToString(new list<id>(productDetailsMap.keyset()));                            
            } 
            system.debug('ProductIDslist'+ProductIDslist);
            system.debug('currencyISOvalue'+currencyISOvalue);
        }
        Set<String> productIdsSet = new Set<String>(ProductIDslist);
        //CECI-960 get core price map.
        Map<string,string> coreProductMap = new map<string,string>();
        coreProductMap = dbu_ProductCtrl.fetchcorepricebyproductid(productIdsSet, currencyISOvalue);
        ProductreturnMap.put('productList' , ProductDetailslist);
        ProductreturnMap.put('productIDsList' , ProductIDslist);
        ProductreturnMap.put('coreProductMap' , coreProductMap);
        system.debug('ProductreturnMap > ' + ProductreturnMap);
        
        return ProductreturnMap;                        
    }   
    
    
    /**
    * @description modified for CECI-960,989
    * @author ChangeMeIn@UserSettingsUnder.SFDoc | 07-05-2022 
    * @param productPartNumberset 
    * @param storeCountry 
    * @return Map<string, object> 
    **/
    public static Map<string,object> getProductDetailedInformation_ExistingESN_or_PCCIntegration_Search(set<string> productPartNumberset, string storeCountry){
        system.debug('<<<<<<<<<<<<<<<< entering in getProductDetailedInformation_ExistingESN_or_PCCIntegration_Search >>>>>>>>>>>');
        //get the country cureency iso mapping from custom settings
        Map<string,string> countryCurrencyMap = new Map<string,string>();
        for(dbu_CountryCurrencyMapping__c eachsetting : (list<dbu_CountryCurrencyMapping__c>)dbu_CountryCurrencyMapping__c.getall().values()){
            system.debug('dbuCountryCode__c > ' + (string)eachsetting.get('dbuCountryCode__c'));
            system.debug('dbuCurrencyCode__c > ' + (string)eachsetting.get('dbuCurrencyCode__c'));
            countryCurrencyMap.put((string)eachsetting.get('dbuCountryCode__c'), (string)eachsetting.get('dbuCurrencyCode__c'));
        }
        system.debug('countryCurrencyMap > ' + countryCurrencyMap);        
        string currencyISOvalue = (string)countryCurrencyMap.get(storeCountry); 
        if(test.isRunningTest()){
            currencyISOvalue = 'USD';
        }
        //START CECI-1213 
        string locationcode;
        if(currencyISOvalue=='USD')
        {
            locationcode='US';
        }
        else if(currencyISOvalue=='CAD')
        {
            locationcode='EN';
        }
        //END CECI-1213
        List<ccrz__E_Product__c> ProductDetailslist = new List<ccrz__E_Product__c>();
        list<string> ProductIDslist = new list<string>();

        Map<string,object> ProductreturnMap = new map<string,object>();
    
        if(productPartNumberset.size() > 0 && productPartNumberset != null){            
        Map<id,ccrz__E_Product__c> productDetailsMap = new Map<id,ccrz__E_Product__c>([SELECT Id,
                              Name,
                              OwnerId,
                              ccrz__SKU__c,
                              ccrz__ProductStatus__c,
                              ccrz__ProductType__c,
                              ccrz__StartDate__c,
                              ccrz__ShortDescRT__c,
                              ccrz__UnitOfMeasure__c,
                              ccrz__AvailabilityMessageRT__c,
                              ccrz__EndDate__c,
                              ccrz__AverageRating__c,
                              ccrz__Taxable__c,
                              DBU_Product_Location__c, 
                              dbu_Has_Core_Child__c,
                              dbu_Has_Core_Charge__c,
                              createddate,
                              dbu_FullPartNumber__c, 
                              dbu_Part_Number__c,
                              ccrz__ShortDesc__c, 
                              (select name, ccrz__ImageURI__c, ccrz__Category__r.Name from ccrz__Promotions__r  
                              WHERE ccrz__Enabled__c = true 
                              AND ccrz__EndDate__c >= today
                              AND ccrz__StartDate__c <= today
                              AND ccrz__Storefront__c = 'CSSNAStore'
                              AND dbu_store_location__c INCLUDES (:locationcode) 
                              LIMIT 1), 
                              (SELECT Id, Name, RecordTypeId, ccrz__Product__c, ccrz__AltMessage__c, ccrz__Enabled__c, ccrz__EndDate__c, ccrz__FilePath__c, ccrz__MediaType__c, ccrz__ProductDescription__c, ccrz__ProductMediaId__c, ccrz__ProductMediaSource__c, ccrz__Sequence__c, ccrz__StartDate__c, ccrz__StaticResourceName__c, ccrz__URI__c FROM ccrz__E_ProductMedias__r WHERE (ccrz__StartDate__c <=TODAY AND ccrz__EndDate__c >= TODAY) AND ccrz__Enabled__c = TRUE AND ccrz__URI__c != NULL AND ccrz__MediaType__c = 'Product Image' ), 
                              (select id, Name, ccrz__Price__c, ccrz__Product__c,dbu_Discount_Percent__c,dbu_Original_Price__c FROM ccrz__E_PriceListItems__r where ccrz__Pricelist__r.ccrz__CurrencyISOCode__c = :currencyISOvalue),
                              (select id, name, ccrz__Product__c,ccrz__Category__r.name from ccrz__Product_Categories__r)                                                                                       
                              FROM ccrz__E_Product__c 
                              WHERE  dbu_Part_Number__c in : productPartNumberset  
                              AND  ccrz__Storefront__c includes ('CSSNAStore')  
                              AND  (ccrz__ProductStatus__c = 'Released' OR ccrz__ProductStatus__c = 'Not Orderable')   
                              AND  (ccrz__StartDate__c = null or ccrz__StartDate__c <= TODAY) 
                              AND  (ccrz__EndDate__c = null or ccrz__EndDate__c >= TODAY) 
                              AND  DBU_Product_Location__c INCLUDES (:storeCountry)  
                              AND  (dbu_Has_Core_Charge__c= true or dbu_Has_Core_Charge__c= false) 
                              AND dbu_Has_Core_Child__c=false ORDER BY Id LIMIT 100]); 
        
            if(productDetailsMap.size() > 0){
                ProductDetailslist = productDetailsMap.values();
                ProductIDslist =  convertlistOfIDToString(new list<id>(productDetailsMap.keyset()));                            
            } 
            
        }

        Set<String> productIdSet = new Set<String>(ProductIDslist);
        //CECI-960 get core price map.
        Map<string,string> coreProductMap = new map<string,string>();
        coreProductMap = dbu_ProductCtrl.fetchcorepricebyproductid(productIdSet, currencyISOvalue);
        ProductreturnMap.put('productList' , ProductDetailslist);
        ProductreturnMap.put('productIDsList' , ProductIDslist);
        ProductreturnMap.put('coreProductMap' , coreProductMap);
        system.debug('ProductreturnMap > ' + ProductreturnMap);
        
        return ProductreturnMap;                        
    }   
    
    
    public static Map<string,double> getProductInventorydetails(string currencyISOvalue, list<string> productIds){
        Map<string,double> productInventorymapping = new Map<string,double>();
        list<AggregateResult> productInventory = new list<AggregateResult>();
        productInventory = [select SUM(ccrz__QtyAvailable__c) TOTALQUANTITY, ccrz__ProductItem__c PRODUCTID
                             from ccrz__E_ProductInventoryItem__c
                             where ccrz__ProductItem__c IN : productIds and 
                             CurrencyIsoCode =: currencyISOvalue
                             GROUP BY ccrz__ProductItem__c];
        system.debug('productInventory > ' + productInventory);
        if(productInventory.size() > 0){
            for(AggregateResult pi : productInventory){
                productInventorymapping.put((string)pi.get('PRODUCTID'),(double)pi.get('TOTALQUANTITY'));
            }
            system.debug('productInventorymapping > ' + productInventorymapping);
            system.debug('productInventorymapping size > ' + productInventorymapping.size());
        } 
        return productInventorymapping;
        
    }    
                
    
    public static string extractSearchkeyFromURL(string urlParameter){
        string SearchKey;
        if(String.isNotBlank(urlParameter)){
            ApexPages.PageReference ref = new ApexPages.PageReference(urlParameter);
            Map<String, String> params = new Map<String, String>();
            params = ref.getParameters();
            System.debug('URL PARAMETERS >> ' + params.size());
            if(params.size() > 0 && params.containsKey('searchText')){                
                SearchKey = params.get('searchText');
                System.debug('SearchKey ==> '+SearchKey);
            }else{                
                SearchKey = urlParameter; 
                system.debug('SearchKey in else ==> '+SearchKey);
            }            
        }
        return SearchKey;
    }
    
    
    public static Map<string,string> getCurrentStore(string urlParameter){
        Map<string,string> StoreCurrencyandcurrencyISOcode = new Map<string,string>();
        string storelanguage;
        string storeCountry;
        string currencyISOvalue;
        if(String.isNotBlank(urlParameter)){
            ApexPages.PageReference ref = new ApexPages.PageReference(urlParameter);
            Map<String, String> params = new Map<String, String>();
            params = ref.getParameters();
            System.debug('URL PARAMETERS >> ' + params.size());        
            
            if(params.size() > 0 && params.containsKey('store')){
                storelanguage = params.get('store');
                system.debug('storelanguage > ' + storelanguage);
                //for USA
                if(storelanguage == system.label.dbu_home_store_U_S_A){
                    storeCountry = system.label.dbu_home_store_U_S_A;
                    currencyISOvalue = system.label.dbu_home_store_country_currency_code_USA;
                }else if(storelanguage == system.label.dbu_home_store_Canada){
                    storeCountry = system.label.dbu_home_store_Canada_CA;//CA
                    currencyISOvalue= system.label.dbu_home_store_country_currency_code_Canada;                    
                }else if(storelanguage == system.label.dbu_home_store_Canada_French){
                    storeCountry = system.label.dbu_home_store_Canada_CA;//CA
                    currencyISOvalue= system.label.dbu_home_store_country_currency_code_Canada;
                }                
            }            
        }
        StoreCurrencyandcurrencyISOcode.put('StoreCountry', storeCountry);
        StoreCurrencyandcurrencyISOcode.put('storelanguage', storelanguage);
        StoreCurrencyandcurrencyISOcode.put('currencyISOCode', currencyISOvalue);
        return StoreCurrencyandcurrencyISOcode;
    }
    
    
    public static list<string> iterateCategoryToList(list<ccrz__E_ProductCategory__c> productcategoryList){
        list<string> categoryList = new list<string>();
        for(ccrz__E_ProductCategory__c eachCategory : productcategoryList){
            categoryList.add(eachCategory.ccrz__Category__r.name);
        }        
        return categoryList;
    }
    
    
    public static list<string> fetchCategoryBySearchResult(set<string> searchid){
        List<ccrz__E_ProductCategory__c> totalCategory = new List<ccrz__E_ProductCategory__c>();

        list<string> categoryNames = new list<string>();
        set<string> categoryNamesset = new set<string>();
        list<string> FinalNameslist = new list<string>();
        try{
            if(searchid!=null ){
                totalCategory=[select id,name,ccrz__Product__c,ccrz__Category__r.name,ccrz__Category__r.dbu_isPromotion__c
                               from ccrz__E_ProductCategory__c where ccrz__Product__c IN:searchid AND ccrz__Category__r.dbu_isPromotion__c = false] ;
                
                //system.debug('ccrz__Spec__r.name'+totalCategory[0].ccrz__Category__r.name);
                system.debug('totalCategories > '+totalCategory);
                
                if(totalCategory.size() > 0){
                    for(ccrz__E_ProductCategory__c eachCategory : totalCategory){
                        categoryNames.add(eachCategory.ccrz__Category__r.name);
                    }
                    if(categoryNames.size() > 0){
                        categoryNamesset.addAll(categoryNames);
                        FinalNameslist.addAll(categoryNamesset);
                    }
                }
            }            
            
        }
        catch(Exception E){
            system.debug('Exception Message'+e.getMessage() +''+'Exception Line number'+e.getLineNumber());
        }
        return FinalNameslist;
    }
    
    
    public static PCCRefinedResultResponse refinePCCIntegrationSearchResults(dbu_EsnSearchResponseWrapper partsApiResponsewrap){
        system.debug('<<<<<<<<<<<<<<<< entering in refinePCCIntegrationSearchResults >>>>>>>>>>>');
        List<dbu_EsnSearchResponseWrapper.PartLists> partLists = new List<dbu_EsnSearchResponseWrapper.PartLists>();
        List<dbu_partsresponse__c> esnResultTobeSaved = new List<dbu_partsresponse__c>();
        PCCRefinedResultResponse refinePCC_resultsResponse = new PCCRefinedResultResponse();
        //List<String> Systems = new List<String>();
        Set<string> setPartNumbers = new Set<string>();
        
        partLists = partsApiResponsewrap.DataArea.PartLists;
                system.debug('partLists 1 > '+ partLists);
        
        if(partLists.size()>0){
            for(dbu_EsnSearchResponseWrapper.Parts part: partLists[0].Parts){   
                system.debug('part 21 > '+ part);
                
                dbu_partsresponse__c response = new dbu_partsresponse__c();
                
                response.Number_Z__c = part.Number_Z;
                system.debug('part.Number_Z >' + part.Number_Z);
                
                response.dbu_ESNNumber__c = partLists[0].ESN;
                system.debug('partLists[0].ESN >' + partLists[0].ESN);
                
                response.dbu_Description__c = part.Description ;
                system.debug('part.Description >' + part.Description);

                //CECI-978 - Abhilash - Commented below code to allow upsert by guesr user
                //response.OwnerId = UserInfo.getUserId();
                
                esnResultTobeSaved.add(response);
                system.debug('esnResultTobeSaved > ' + esnResultTobeSaved);
                
                //Systems.addAll(part.Systems);
                //system.debug('Systems>>>>>>>> ' + Systems);
                
                //CECI-978 - Abhilash - Removed 100 Limit
                if(!setPartNumbers.contains(part.Number_Z)){
                    setPartNumbers.add(part.Number_Z);                                            
                }
                system.debug('setPartNumbers > '+ setPartNumbers); 
                
                
            }             
        }
        

        refinePCC_resultsResponse.partsResponseData = esnResultTobeSaved;
        refinePCC_resultsResponse.partNumbersList = setPartNumbers;
        
        system.debug('refinePCC_resultsResponse > ' + refinePCC_resultsResponse);
            
        
        return refinePCC_resultsResponse;
    }
    
    //Sandeep
    public static PCCRefinedResultResponse refinePCCIntegrationSearchResultsGSN(dbu_GsnSearchResponseWrapper partsApiResponsewrap, String gsnNumber){  
        List<dbu_GsnSearchResponseWrapper.mbom> mbomList = new List<dbu_GsnSearchResponseWrapper.mbom>();

        List<dbu_partsresponse__c> gsnResultTobeSaved = new List<dbu_partsresponse__c>();
        PCCRefinedResultResponse refinePCC_resultsResponse = new PCCRefinedResultResponse();
        Set<string> setPartNumbers = new Set<string>();
        
        mbomList = partsApiResponsewrap.mbom;
        
        for(dbu_GsnSearchResponseWrapper.mbom eachmBom : mbomList){
            if(eachmBom.groups.size() > 0 && eachmBom.groups[0].Parts.size() > 0 ){
                for(dbu_GsnSearchResponseWrapper.Parts partList : eachmBom.groups[0].Parts){
                    if(partList.data!=null){
                        dbu_partsresponse__c response = new dbu_partsresponse__c();
                        response.Number_Z__c = partList.data.partNo;
                        response.dbu_ESNNumber__c = gsnNumber; //storing the GSN number
                        response.dbu_Description__c = partList.data.partDesc;
                        response.OwnerId = UserInfo.getUserId();
                    
                        gsnResultTobeSaved.add(response);

                        //CECI-978 - Abhilash - Removed 100 Limit
                        if(!setPartNumbers.contains(partList.data.partNo))
                            setPartNumbers.add(partList.data.partNo);                                            
                    }
                }
            }
        }   
        refinePCC_resultsResponse.partsResponseData = gsnResultTobeSaved;
        refinePCC_resultsResponse.partNumbersList = setPartNumbers;
        
        system.debug('refinePCC_resultsResponse > ' + refinePCC_resultsResponse);  
        return refinePCC_resultsResponse;
    }
    
   public static RefinedResultResponseGSN refineGSNIntegrationSearchResults(dbu_GsnSearchResponseWrapper partsApiGSNResponsewrap){
      
       system.debug('<<<<<<<<<<<<<<<< entering in refineGSNIntegrationSearchResults >>>>>>>>>>>');
      // List<dbu_EsnSearchResponseWrapper.PartLists> partLists = new List<dbu_EsnSearchResponseWrapper.PartLists>();
       List<dbu_GsnSearchResponseWrapper.Mbom> mbom = new List<dbu_GsnSearchResponseWrapper.Mbom>();
       List<dbu_GsnSearchResponseWrapper.Groups> groupslist = new List<dbu_GsnSearchResponseWrapper.Groups>();
       List<dbu_GsnSearchResponseWrapper.parts> Partslist = new List<dbu_GsnSearchResponseWrapper.parts>();  
       List<dbu_partsresponse__c> gsnResultTobeSaved = new List<dbu_partsresponse__c>();
       
       RefinedResultResponseGSN refineGSN_resultsResponse = new RefinedResultResponseGSN ();
       
        mbom=partsApiGSNResponsewrap.mbom;             
        
        for(dbu_GsnSearchResponseWrapper.mbom grouplistToParts:mbom){    
            for(dbu_GsnSearchResponseWrapper.groups groupsIte:grouplistToParts.groups){ 
              for(dbu_GsnSearchResponseWrapper.parts PartsIte:groupsIte.parts){
                 dbu_partsresponse__c response = new dbu_partsresponse__c();
              }
            }
          }
        
        return refineGSN_resultsResponse; 
   }
    public static wrapperFrameResponse frameResponseWrapper(string storeCountry, String storeLanguage, String CountryISOcode, Map<string,object> ProductandBrandData){
        system.debug('<<<<<<<<<<<<<<<< entering in frame respoonse wrapper >>>>>>>>>>>');
        list<string> ProductIdList = new list<string>();
        dbu_CCSearchExtension.BrandResponse CombinedbrandData = new dbu_CCSearchExtension.BrandResponse();
        list<ccrz__E_Product__c> productDetailsList = new list<ccrz__E_Product__c>();
        list<string> AllBrandData = new list<string>();
        list<string> CategoryData = new list<string>();
        Map<string,set<string>> ProductBrandMapping = new Map<string,set<string>>();
        Map<string,double> productInventoryMap = new Map<string,double>();
        dbu_CCSearchResponse searchResult = new dbu_CCSearchResponse();
        List<dbu_Search_Results__c> esnResultTobeSaved = new List<dbu_Search_Results__c>();        
        wrapperFrameResponse ResponseToReturn = new wrapperFrameResponse();   
        Map<String,String> coreProductMap = new Map<String,String>();
        searchResult.products = new List<dbu_CCAPISearchResponseWrapper>();        
        searchResult.Categories = new List<String>();  
        
        try{
        //Populate Product Details
        if(ProductandBrandData.get('productList') != null && ((list<ccrz__E_Product__c>)ProductandBrandData.get('productList')).size() > 0 ){
            productDetailsList =  (list<ccrz__E_Product__c>)ProductandBrandData.get('productList') ;         
        }
        
        //Populate ProductIds
        if(ProductandBrandData.get('productIDsList') != null && ((list<string>)ProductandBrandData.get('productIDsList')).size() > 0 ){
            ProductIdList = (list<string>)ProductandBrandData.get('productIDsList');
        }      
        
        //Populate Brand Data
        if(ProductandBrandData.get('newbrans') != null){
            CombinedbrandData = (dbu_CCSearchExtension.BrandResponse)ProductandBrandData.get('newbrans');
            AllBrandData = CombinedbrandData.combinedBrands;
            ProductBrandMapping = ((dbu_CCSearchExtension.BrandResponse)ProductandBrandData.get('newbrans')).ProductBrandListMap;
        }
        
        //get ProductInventory details
        if(ProductIdList.size() > 0){
            productInventoryMap = getProductInventorydetails(CountryISOcode, ProductIdList);            
        }
        
        //get category data
        if(ProductandBrandData.get('CategoryData') != null && ((list<string>)ProductandBrandData.get('CategoryData')).size() > 0){
            CategoryData = (list<string>)ProductandBrandData.get('CategoryData');
        }
         //Populate Core price data
         system.debug('Coreproductdata'+ProductandBrandData.get('coreProductMap'));
         if(ProductandBrandData.get('coreProductMap') != null && ((Map<String,String>)ProductandBrandData.get('coreProductMap')).size() > 0 ){
            system.debug('Coreproductdatainside'+ProductandBrandData.get('coreProductMap'));
            coreProductMap =  ((Map<String,String>)ProductandBrandData.get('coreProductMap')) ;         
        }
        
        
        //> starting to Building Wrapper ################################
        
        //Populate Global Categories Data
        searchResult.Categories =  CategoryData;
        
        //Populate Global Brands Data
        searchResult.Brands =  AllBrandData;
        
        //Populate Product Data
        if(productDetailsList.size() > 0){
            for(ccrz__E_Product__c eachProduct : productDetailsList){
                
                //wrapper for saving esn search
                dbu_Search_Results__c response = new dbu_Search_Results__c();
                
                //wrapper to populate product Data
                dbu_CCAPISearchResponseWrapper wrapper=new dbu_CCAPISearchResponseWrapper();
                
                wrapper.sfid = eachProduct.id;
                wrapper.sfdcName = eachProduct.Name;
                wrapper.SKU=eachProduct.ccrz__SKU__c;//Added CECI-958
                wrapper.productType = eachProduct.ccrz__ProductType__c;
                wrapper.productStatus = eachProduct.ccrz__ProductStatus__c;
                wrapper.shortDesc = eachProduct.ccrz__ShortDesc__c;
                
                Decimal discountPercentage;
                //populate Price data                
                if((eachProduct.ccrz__E_PriceListItems__r).size() > 0){
                    if(eachProduct.dbu_Has_Core_Charge__c){
                        Double price = 0;
                        Double coreCharge = 0;
                        Double totalPrice;
                        Double originalPrice = 0;
                        Double originalTotalPrice = 0;
                        price = eachProduct.ccrz__E_PriceListItems__r[0].ccrz__Price__c;
                        if(coreProductMap.get(eachProduct.id) != null)
                        {
                            coreCharge = Double.valueof(coreProductMap.get(eachProduct.id));
                        }
                        //coreCharge = Double.valueOf(coreProductMap.get(eachProduct.id));
                        wrapper.price = price + coreCharge;
                        if(eachProduct.ccrz__E_PriceListItems__r[0].dbu_Original_Price__c !=null){
                            originalPrice = eachProduct.ccrz__E_PriceListItems__r[0].dbu_Original_Price__c;
                        }   
                        originalTotalPrice = originalPrice + coreCharge;
                        wrapper.originalPrice =    originalTotalPrice; 
                        wrapper.hasCoreCharge = eachProduct.dbu_Has_Core_Charge__c;
                       // wrapper.coreCharge = Double.valueOf(coreProductMap.get(eachProduct.id));
                        wrapper.coreCharge =coreCharge;
                        if(originalTotalPrice <> 0){
                            discountPercentage = Decimal.valueOf(((((originalTotalPrice - (price + coreCharge)))*100) / originalTotalPrice)).round(System.RoundingMode.HALF_EVEN);
                            wrapper.discountPercentage = Integer.valueOf(discountPercentage.round(System.RoundingMode.HALF_EVEN));
                        }
                   }else{ 
                        wrapper.price = eachProduct.ccrz__E_PriceListItems__r[0].ccrz__Price__c;
                        if(eachProduct.ccrz__E_PriceListItems__r[0].dbu_Original_Price__c != null){
                        	wrapper.originalPrice = eachProduct.ccrz__E_PriceListItems__r[0].dbu_Original_Price__c;
                        }
                        if(eachProduct.ccrz__E_PriceListItems__r[0].dbu_Discount_Percent__c <> 0 && eachProduct.ccrz__E_PriceListItems__r[0].dbu_Discount_Percent__c != Null)
                        {
                            system.debug('ifInside'+eachProduct.ccrz__E_PriceListItems__r[0].dbu_Discount_Percent__c);
                            //discountPercentage = (eachProduct.ccrz__E_PriceListItems__r[0].dbu_Discount_Percent__c);    
                        discountPercentage = (eachProduct.ccrz__E_PriceListItems__r[0].dbu_Discount_Percent__c).round(System.RoundingMode.HALF_EVEN);
                        wrapper.discountPercentage = Integer.valueOf(discountPercentage.round(System.RoundingMode.HALF_EVEN));
                        system.debug('discountPercentagewrapper'+wrapper.discountPercentage);
                        }
                        
                    }
                }
                
                //Populate Product Brand
                wrapper.ProductBrand = new list<string>();
                if(ProductBrandMapping != null){
                    if((ProductBrandMapping.get(eachProduct.id)) != null){                        
                        list<string> finalstrlist = new list<string>();
                        finalstrlist.addAll((set<string>)ProductBrandMapping.get(eachProduct.id));
                        wrapper.ProductBrand = finalstrlist;
                        //wrapper.ProductBrand = (set<string>)ProductBrandMapping.get(eachProduct.id);
                    }
                }
                
                
                //populate Product Category
                wrapper.ProductCategory = new list<string>();
                if((eachProduct.ccrz__Product_Categories__r).size() > 0){                    
                    if((eachProduct.ccrz__Product_Categories__r).size() > 1){
                        wrapper.ProductCategory = iterateCategoryToList(eachProduct.ccrz__Product_Categories__r);                        
                    }else{
                        wrapper.ProductCategory = new list<string>{eachProduct.ccrz__Product_Categories__r[0].ccrz__Category__r.name};                       
                    }                                        
                }
                
                               
                //populate ProductInventory
                wrapper.invstatus = 'Out of Stock';                
                if(productInventoryMap.size() > 0){                                                   
                    if((double)productInventoryMap.get(eachProduct.id) != null){        
                        double inventoryQuantity = (double)productInventoryMap.get(eachProduct.id);
                        if(inventoryQuantity > 0){
                            wrapper.invstatus = 'In Stock'; 
                        }else{
                            wrapper.invstatus = 'Out of Stock'; 
                        }                                                               
                    }    
                }
                
                //populate ProductMedia
                if((eachProduct.ccrz__E_ProductMedias__r).size() > 0){
                    wrapper.URI = eachProduct.ccrz__E_ProductMedias__r[0].ccrz__URI__c;                    
                }
                
                //Populate Promotion CECI-960
                if((eachProduct.ccrz__Promotions__r).size() > 0){
                    wrapper.promotionTag = eachProduct.ccrz__Promotions__r[0].ccrz__Category__r.Name;                    
                }
                system.debug('wrapper > ' + wrapper);
                
                //Add product wrapper to main wrapper
                searchResult.products.add(wrapper); 
                response.dbu_Inventory__c  = wrapper.invstatus;
                response.dbu_productName__c= wrapper.sfdcName;                
                esnResultTobeSaved.add(response);
                                
            }
            system.debug('esnResultTobeSaved > ' + esnResultTobeSaved);
            system.debug('esnResultTobeSaved length > ' + esnResultTobeSaved.size());
            system.debug('searchResult > ' + searchResult);
                    
            
        }
        
        //FRAMING FINAL RESPONSE TO SEND
        ResponseToReturn.ESNSearchResultsResp = esnResultTobeSaved;
        ResponseToReturn.FramedProductData = searchResult;
        }
        catch(Exception e){
           system.debug('Search EXCEPTION  -> ' + e.getMessage() + '--' +  e.getLineNumber() + '--' + e.getStackTraceString());
        }
        return ResponseToReturn;

        
        
    }
    
    
    public static set<string> existingESNResponseSearchResult(string searchkey){
        system.debug('<<<<<<<<<<<<<<<< entering in existingESNResponseSearchResult >>>>>>>>>>>');
        List<dbu_partsresponse__c> existingESNResponseList = new List<dbu_partsresponse__c>();
        set<string> partNumbersset = new set<string>();
        
        //CECI-978 - Abhilash - Added date filter based on the number of days stored in custom label - Start
        Date dtToUpdateCache  = System.Today() - Integer.ValueOf(System.Label.dbu_cache_update_days);

        //CECI-978 - Abhilash - below SOQL is updated with date filter and search based on VIN. 100 limit is removed.
        Integer queryRowsLimit = Limits.getLimitQueryRows();
        system.debug('queryRowsLimit --> '+ queryRowsLimit);

        existingESNResponseList = [SELECT Id,
                                   Number_Z__c,
                                   dbu_ESNNumber__c,
                                   dbu_Description__c
                                   FROM dbu_partsresponse__c
                                   WHERE
                                (dbu_ESNNumber__c=:searchkey OR dbu_VINNumber__c =: searchkey)
                                and LastModifiedDate >= :dtToUpdateCache LIMIT :queryRowsLimit];
        
        //CECI-978 - Abhilash - End
        system.debug('existingESNResponseList > ' + existingESNResponseList);
        
        if(existingESNResponseList.size() > 0){
            for(dbu_partsresponse__c eachPartResponse : existingESNResponseList){
                partNumbersset.add(eachPartResponse.Number_Z__c);
            }
        }
        
        system.debug('partNumbersset > ' + partNumbersset);        
        
        return partNumbersset;

    }
          
    
    public class wrapperFrameResponse{
        public List<dbu_Search_Results__c> ESNSearchResultsResp;
        public dbu_CCSearchResponse FramedProductData;
        public dbu_CCVINProductInformation VINProductInfo; //Lahari change
        
    }

    
    public class ProductCategoryResponse{
        public Map<string,set<string>> productBrandMap;
        public set<string> productCategoryIDSet;
    }    

    
    public class GrandCategoryResponse{
        public List<ccrz__E_Category__c> GrandCategorylist;
        public set<id> GrandCategoryIDSet;
    }  
    
     
    public class PCCRefinedResultResponse{
        public List<dbu_partsresponse__c> partsResponseData;
        public Set<string> partNumbersList; 
    }
    
     public class RefinedResultResponseGSN{
       public List<dbu_partsresponse__c> partsResponseData;
        public Set<string> partNumbersList; 
     }
        
}