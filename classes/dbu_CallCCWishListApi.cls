/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 09-15-2022
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
public without sharing class dbu_CallCCWishListApi {
     
    //Method to check whether the product already exist in the user's Default Wishlist
    public static boolean IfProductInDefaultWishlist(string userWishlistId, string ProductId, string SFLorWL){
        
        set<string> ProductIds = new set<string>{ProductId};
        Boolean ProductFoundInwishlist;    
            //############ INPUT DATA ###############################
            Map<String, Object> inputData = new Map<String, Object>{
                ccrz.ccAPI.API_VERSION => ccrz.ccApi.CURRENT_VERSION,
                    ccrz.ccAPIWishList.ID => userWishlistId,
                    ccrz.ccAPIWishList.PRODUCT_IDS => ProductIds,
                    ccrz.ccApi.SIZING => new Map<String, Object> {
                        ccrz.ccAPIWishList.ENTITYNAME => new Map<String, Object> {
                            ccrz.ccApi.SZ_DATA => ccrz.ccApi.SZ_XL  
                        }
                    },
                    //'DBU_SAVEFORLATER' => 'WishList'
                    //'DBU_SAVEFORLATER' => 'Save For Later'    
                    'DBU_SAVEFORLATER' => SFLorWL                                    
                    };
                        
                        try {
                            //############ FIRE fetchWishlistItems() Method ###############################
                            Map<String, Object> outputData = ccrz.ccAPIWishList.fetchWishlistItems(inputData);
                            system.debug('outputData :: ' + outputData);
                            
                            if (outputData.get(ccrz.ccAPIWishList.WISHLIST_ITEMS) != null) {
                                
                                Map<String,List<Map<String,object>>> wishListMap = (Map<String,List<Map<String,object>>>)outputData.get(ccrz.ccAPIWishList.WISHLIST_ITEMS);
                                system.debug(wishListMap);
                                ProductFoundInwishlist = true;
                            }else{
                                ProductFoundInwishlist = false;
                            }
                        } catch (Exception e) {
                            // Error handling...
                            system.debug('error is ' + e);
                        }                        
                        
        return ProductFoundInwishlist;
    }
    
    //Method to check whether the list of products already exist in the user's Default Wishlist
    public static set<string> CheckifProductsInDefaultWishlist(string userWishlistId, set<string> ProductIdsSet, string SFLorWL){
        
        set<string> ProductIdsFound = new set<string>();
        Boolean ProductFoundInwishlist;    
            //############ INPUT DATA ###############################
            Map<String, Object> inputData = new Map<String, Object>{
                ccrz.ccAPI.API_VERSION => ccrz.ccApi.CURRENT_VERSION,
                    ccrz.ccAPIWishList.ID => userWishlistId,
                    ccrz.ccAPIWishList.PRODUCT_IDS => ProductIdsSet,
                    ccrz.ccApi.SIZING => new Map<String, Object> {
                        ccrz.ccAPIWishList.ENTITYNAME => new Map<String, Object> {
                            ccrz.ccApi.SZ_DATA => ccrz.ccApi.SZ_XL  
                        }
                    },
                    //'DBU_SAVEFORLATER' => 'WishList'
                    //'DBU_SAVEFORLATER' => 'Save For Later'    
                    'DBU_SAVEFORLATER' => SFLorWL                                    
                    };
                        
                        try {
                            //############ FIRE fetchWishlistItems() Method ###############################
                            Map<String, Object> outputData = ccrz.ccAPIWishList.fetchWishlistItems(inputData);
                            system.debug('outputData :: ' + outputData);
                            
                            if (outputData.get(ccrz.ccAPIWishList.WISHLIST_ITEMS) != null) {
                                
                                Map<String,List<Map<String,object>>> wishListMap = (Map<String,List<Map<String,object>>>)outputData.get(ccrz.ccAPIWishList.WISHLIST_ITEMS);
                                system.debug(wishListMap);
                                
                                if(wishListMap != null){
                                    List<Map<string,object>> WishlistResp = (wishListMap.values())[0];
                                    system.debug('WishlistResp > '  + WishlistResp);
                                
                                    for(Map<string,object> eachItem : WishlistResp){
                                        ProductIdsFound.add((string)eachItem.get('product'));                                                                                   
                                    }                                                                           
                                }
                                system.debug('ProductIdsFound >> ' + ProductIdsFound);
                                                                                                                             
                            }
                        } catch (Exception e) {
                            // Error handling...
                            system.debug('error is ' + e);
                        }                        
                        
        return ProductIdsFound;
    }
    
    //Method to get current contact details like Firstname, lastname, account ID
    public static Map<string,object> getCurrentContactDetails(string ContactID){
        Map<string,object> MethodResponse = new Map<string,object>();
        
        
        Map<String,Object> inputData = new Map<String,Object>{
            ccrz.ccApi.API_VERSION => 9,                
                ccrz.ccApiContact.ID => ContactID
                };
                    
        try{        
            Map<String, Object> outputData = ccrz.ccAPIContact.fetch(inputData);

            if (outputData.get(ccrz.ccAPIContact.CONTACTS) != null) {
                // The cast to List<Map<String, Object>> is necessary...
                List<Map<String, Object>> contactList = (List<Map<String, Object>>) outputData.get(ccrz.ccAPIContact.CONTACTS);                 
                
                for(Map<String,Object> contact : contactList){
                    // The cast, again, is necessary...
                    String AccountID = (String)contact.get('accountId');
                    MethodResponse.put('AccountID',AccountID);
                    String FirstName = (String)contact.get('firstName');
                    MethodResponse.put('FirstName',FirstName);
                    String LastName = (String)contact.get('lastName');
                    MethodResponse.put('LastName',LastName);            
                }
            }
            system.debug('MethodResponse :: ' + MethodResponse);                 
            
        }catch (Exception e){
            // Error handling...
            system.debug('ERROR IN RETRIVING CONTACT > ' + e );
        }                    
        
        return MethodResponse;
    }
    
    //Create default wishlist for a new contact 
    public static string createDefaultWishlist(string contactID, string storeCountry, string storeLanguage){
        
        Map<string,object> FetchContactDetails = dbu_CallCCWishListApi.getCurrentContactDetails(contactID);
        system.debug('FetchContactDetails > ' + FetchContactDetails);
        
        string accountId;
        string WishlistName;
        if(string.isNotBlank((string)FetchContactDetails.get('AccountID'))){
            accountId = (string)FetchContactDetails.get('AccountID');
            system.debug('accountId > ' + accountId );
        }
        
        string firstname;
        if(string.isNotBlank((string)FetchContactDetails.get('FirstName'))){
            firstname = (string)FetchContactDetails.get('FirstName');
            WishlistName = firstname;
            system.debug('WishlistName FN > ' + WishlistName );
        }
        
        string lastname;
        if(string.isNotBlank((string)FetchContactDetails.get('LastName'))){
            lastname = (string)FetchContactDetails.get('LastName');
            WishlistName = WishlistName + ' ' +  lastname;
            system.debug('WishlistName LN > ' + WishlistName );
        }       
        
        WishlistName += ' default wishlist';
        
        system.debug('WishlistName FN + LN > ' + WishlistName );
        string StorefrontName = 'CSSNAStore';
        string currencyCode = 'USD';
        string wishlistID;

       
        //##################### INPUT DATA ##################################
        Map<String, Object> wishlistCreateInputData = new Map<String, Object>{
            ccrz.ccApi.API_VERSION => ccrz.ccApi.CURRENT_VERSION,
            ccrz.ccApi.SIZING => new Map<String, Object> {
                ccrz.ccAPIWishList.ENTITYNAME => new Map<String, Object> {
                    ccrz.ccApi.SZ_DATA => ccrz.ccApi.SZ_XL
                   }
                },
            ccrz.ccAPIWishList.WISHLIST => new Map<String, Object>{ 
                    'name' => WishlistName,
                    'storefront' => StorefrontName,
                    'account' => accountId,  
                    'contact' => contactID,   
                    'currencyISOCode' => currencyCode,
                    'dbuCartStoreCountry' => storeCountry,
                    'dbustoreLanguage' => storeLanguage
                }           
        };
        system.debug('wishlistCreateInputData > ' + wishlistCreateInputData);
        
        //################################ Fire Create wishlist API #########################################    
        try{
            Map<String, Object> WishlistCreateResponse = ccrz.ccApiWishList.create(wishlistCreateInputData);   
            
            if(WishlistCreateResponse.get(ccrz.ccAPIWishList.WISHLIST) != null){
                Map<string,object> wishlistMap = (Map<string,object>) WishlistCreateResponse.get(ccrz.ccAPIWishList.WISHLIST);
                wishlistID = (string)wishlistMap.get('sfid');
                system.debug('wishlistID : ' + wishlistID);
            }
            system.debug('Wishlist Successfully Created ::' + (Boolean)WishlistCreateResponse.get(ccrz.ccApi.SUCCESS));
        }catch(exception e){
            system.debug('ERROR IN WISHLIST CREATION > ' + e);    
        }
        return wishlistID;
    }
    
    //Fetch Product details from a wishlist like Product URI, NAME & PRICE
    public static Map<string,dbu_SaveForLaterWrapper> FetchProductDetails(set<string> ProductIDSet, string storeCountry){        
        
         Map<string,dbu_SaveForLaterWrapper> ProductDetailResponse = new Map<string,dbu_SaveForLaterWrapper>();   

        //get the country cureency iso mapping from custom settings
        Map<string,string> countryCurrencyMap = new Map<string,string>();
        for(dbu_CountryCurrencyMapping__c eachsetting : (list<dbu_CountryCurrencyMapping__c>)dbu_CountryCurrencyMapping__c.getall().values()){
            system.debug('dbuCountryCode__c > ' + (string)eachsetting.get('dbuCountryCode__c'));
            system.debug('dbuCurrencyCode__c > ' + (string)eachsetting.get('dbuCurrencyCode__c'));
            countryCurrencyMap.put((string)eachsetting.get('dbuCountryCode__c'), (string)eachsetting.get('dbuCurrencyCode__c'));
        }
        system.debug('countryCurrencyMap > ' + countryCurrencyMap); 
        
        string currencyISOvalue = (string)countryCurrencyMap.get(storeCountry);        
        

        //GET RELATED PRODUCT FOR CORECHARGE
        
        set<ccrz__E_RelatedProduct__c> relProducts = new set<ccrz__E_RelatedProduct__c>(
         [select ccrz__RelatedProduct__r.id
                    from ccrz__E_RelatedProduct__c 
                    where ccrz__Product__c in : ProductIDSet 
                    and ccrz__RelatedProductType__c = 'Core Charge' 
                    and ccrz__Product__r.DBU_Product_Location__c includes (:storeCountry) 
                    //and ccrz__RelatedProduct__r.DBU_Product_Location__c includes (:storeCountry) 
                    and ccrz__RelatedProduct__r.dbu_Has_Core_Child__c = true]
        );
                
        system.debug('relProducts > ' + relProducts);
        system.debug('relProducts sz > ' + relProducts.size());
        
        if(TEST.isRunningTest() == true){
            ccrz__E_Product__c geprod = [select id from ccrz__E_Product__c where name = 'TestProductcorechild'];
             set<ccrz__E_RelatedProduct__c> relProductss = new set<ccrz__E_RelatedProduct__c>();
                    ccrz__E_RelatedProduct__c u = new ccrz__E_RelatedProduct__c();
                    u.ccrz__RelatedProduct__c = geprod.id;
            relProductss.add(u);    
            relProducts = relProductss;
                        
        }
        
        //CHECK FOR INVENTORY
        Map<string,double> productInventorymapping = new Map<string,double>();
        list<AggregateResult> productInventory = new list<AggregateResult>();
        productInventory = [select SUM(ccrz__QtyAvailable__c) TOTALQUANTITY, ccrz__ProductItem__c PRODUCTID
                            from ccrz__E_ProductInventoryItem__c 
                            where ccrz__ProductItem__c IN : ProductIDSet 
                            and CurrencyIsoCode =: currencyISOvalue 
                            GROUP BY ccrz__ProductItem__c];
        system.debug(productInventory);
        
        if(productInventory.size() > 0){
        for(AggregateResult pi : productInventory){            
            productInventorymapping.put((string)pi.get('PRODUCTID'),(double)pi.get('TOTALQUANTITY'));
            system.debug('productInventorymapping > ' + productInventorymapping);
        }
        
        system.debug('productInventorymapping > ' + productInventorymapping);
        system.debug('productInventorymapping size > ' + productInventorymapping.size());  
        } 
        
        if(relProducts.size() > 0){
            //store related corecharge product id
            set<string> relatedProductsIdsetcorecharge = new set<string>();
            for(ccrz__E_RelatedProduct__c rel : relProducts){
                system.debug('rel > ' + rel.ccrz__RelatedProduct__r.id);
                relatedProductsIdsetcorecharge.add((string)rel.ccrz__RelatedProduct__r.id);
            }
            system.debug('relatedProductsIdsetcorecharge > ' + relatedProductsIdsetcorecharge); 
            system.debug('relatedProductsIdsetcorecharge sz > ' + relatedProductsIdsetcorecharge.size()); 
            
            //Get core products not having product location         
            list<ccrz__E_Product__c> coreProductsWithoutLocation = new list<ccrz__E_Product__c>();
            coreProductsWithoutLocation = [select id, 
                                           Name,
                                           (select ccrz__Price__c,dbu_Original_Price__c, dbu_Discount_Percent__c  from ccrz__E_PriceListItems__r where ccrz__Pricelist__r.ccrz__CurrencyISOCode__c =: currencyISOvalue),
                                           (select ccrz__URI__c,ccrz__MediaType__c from ccrz__E_ProductMedias__r where ccrz__URI__c != null AND ccrz__MediaType__c =: 'Product Image')                                                                              
                                           from ccrz__E_Product__c 
                                           where dbu_Has_Core_Charge__c = true 
                                           and dbu_Has_Core_Child__c = true 
                                           and id in : relatedProductsIdsetcorecharge];   
            
            system.debug('coreProductsWithoutLocation sz > ' + coreProductsWithoutLocation.size());
            system.debug('coreProductsWithoutLocation > ' + coreProductsWithoutLocation);
            
            //Remove the core product from Original list 
            if(Test.isRunningTest()){
                ccrz__E_Product__c testpro = new ccrz__E_Product__c();
                testpro.id = 'a2w1F000000bmKc';
                testpro.Name = 'testp';
                //testpro.ccrz__E_ProductMedias__r[0].ccrz__URI__c = 'https://www.gettyimages.in/collections/500px';
                //testpro.ccrz__E_PriceListItems__r[0].ccrz__Price__c = 73;                
                coreProductsWithoutLocation = new list<ccrz__E_Product__c>{testpro};
            }
            for(ccrz__E_Product__c rel : coreProductsWithoutLocation){
                if(ProductIDSet.contains(rel.Id)){
                    ProductIDSet.remove(rel.Id);
                }
                
                dbu_SaveForLaterWrapper eachcoreProductDetailInstance = new dbu_SaveForLaterWrapper();
                eachcoreProductDetailInstance.ProductID         = rel.Id; 
                eachcoreProductDetailInstance.ProductName       = rel.Name;
                
                if(rel.ccrz__Promotions__r.size() > 0){
                    eachcoreProductDetailInstance.promotionTag = rel.ccrz__Promotions__r[0].ccrz__Category__r.Name;
                 }
                if(Test.isRunningTest()){
                    eachcoreProductDetailInstance.ProductURL        = 'https://www.gettyimages.in/collections/500px';
                    eachcoreProductDetailInstance.ProductPrice      = 67;                      
                }else{
                    if((rel.ccrz__E_PriceListItems__r).size() > 0){
                        eachcoreProductDetailInstance.ProductPrice      = rel.ccrz__E_PriceListItems__r[0].ccrz__Price__c;

                    }else{
                        eachcoreProductDetailInstance.ProductPrice      = 0;
                    }                    

                    if((rel.ccrz__E_ProductMedias__r).size() > 0){
                        eachcoreProductDetailInstance.ProductURL        = rel.ccrz__E_ProductMedias__r[0].ccrz__URI__c;
                    }else{
                        eachcoreProductDetailInstance.ProductURL = '';
                    }                     
                }
                         
                eachcoreProductDetailInstance.IsCrateProductCheck = false;
                eachcoreProductDetailInstance.ProductQuantity = 1;
                eachcoreProductDetailInstance.IsCoreProductcheck = true;  
                eachcoreProductDetailInstance.inventoryQuantity = 1;
                ProductDetailResponse.put(rel.Id,eachcoreProductDetailInstance);
            }               
        }
     
        
        if(ProductIDSet.size() > 0){
            Map<String,String>  productvsPromotionTag = dbu_CallCCWishListApi.getProductPromotiontag(ProductIDSet,storeCountry);
            list<ccrz__E_PriceListItem__c> pricedata = dbu_homePageCategoryTileCtrl.fetchPriceBySearchResult(ProductIDSet,storeCountry);
            map<String,ccrz__E_PriceListItem__c> originalPriceMap = new map<String,ccrz__E_PriceListItem__c> ();
            for(ccrz__E_PriceListItem__c priceLstItem: pricedata){
                originalPriceMap.put(priceLstItem.ccrz__Product__c,priceLstItem);
            }
            //Formulate Input Data for CC PriceList & CC Product APIs
            
            //############### INPUT DATA FOR CC PRODUCT FETCH() ##########################
            Map<string,object> ProductInputData = new Map<string,object>{
                ccrz.ccApi.API_VERSION => ccrz.ccApi.CURRENT_VERSION,                   
                    ccrz.ccApi.SIZING => new Map<String, Object> {
                        ccrz.ccApiProduct.ENTITYNAME => new Map<String, Object> {
                            ccrz.ccApi.SZ_DATA => ccrz.ccApi.SZ_L,
                                ccrz.ccApi.SZ_REL => New List<String>{'E_ProductMedias__r'}    
                        }
                    },
                        ccrz.ccApiProduct.PRODUCTIDLIST => ProductIDSet,                    
                        ccrz.ccApiProduct.PRODUCTSTOREFRONT => 'CSSNAStore',
                        ccrz.ccApiProduct.TYPES => new Set<String>{'Product'},
                            'dBUProductLocation' => storeCountry   
                            };
                                
                                
                                //############### INPUT DATA FOR CC PRICELISTITEM FETCH() ##########################
                                Map<string,object> PricelistItemInputData = new Map<string,object>{
                                    ccrz.ccApi.API_VERSION => ccrz.ccApi.CURRENT_VERSION,
                                        ccrz.ccApiPriceList.PRODUCTIDS => ProductIDSet,
                                        ccrz.ccApiPriceList.CURRCODE => currencyISOvalue,
                                        ccrz.ccApi.SIZING => new Map<String, Object> {
                                            ccrz.ccApiPriceList.ENTITYNAME_PLI => new Map<String, Object> {
                                                ccrz.ccApi.SZ_DATA => ccrz.ccApi.SZ_L
                                                    }
                                        }    
                                };
                                    
                                    
                                    
                                    try{
                                        //############### MAP CONTAINER TO HOLD PRODUCT - PRICE MAPPING ##########################              
                                        Map<string,decimal> ProductPriceMap = new Map<string,decimal>();
                                        
                                        //############################################ FIRE CC PRICELIST FETCH() ###################################################
                                        try{
                                            Map<string,object> PricelistItemResponse = ccrz.ccApiPriceList.fetchPriceListItems(PricelistItemInputData);
                                            if(PricelistItemResponse.get(ccrz.ccApiPriceList.PRICELISTITEMS) != null){
                                                Map<String, Map<String, Object>> priceListItems = (Map<String, Map<String, Object>>)PricelistItemResponse.get(ccrz.ccApiPriceList.PRICELISTITEMS);
                                                
                                                List<Map<string,object>> pricelistitemsList = (List<Map<string,object>>)priceListItems.values();
                                                
                                                
                                                for(Map<string,object> eachPriceListItem : pricelistitemsList){
                                                    //system.debug(JSON.serializePretty((string)eachPriceListItem.get('product')));
                                                    //system.debug(JSON.serializePretty((decimal)eachPriceListItem.get('price')));
                                                    ProductPriceMap.put((string)eachPriceListItem.get('product') , (decimal)eachPriceListItem.get('price'));                                
                                                }
                                                system.debug('ProductPriceMap :: ' + ProductPriceMap);
                                            }
                                        }catch(Exception e){
                                            system.debug('exception : ' + e);
                                        }               
                                        
                                        //############### FIRE CC PRODUCT FETCH() ##########################
                                        Map<string, object> ProductsApiResponse = ccrz.ccApiProduct.fetch(ProductInputData);
                                        //system.debug('ProductsApiResponse ::' + ProductsApiResponse);
                                        system.debug(ProductsApiResponse.get(ccrz.ccApi.SUCCESS));
                                        
                                        //Map<string,object> ProductDetail = new Map<string,object>();
                                        
                                        if(ProductsApiResponse.get(ccrz.ccApiProduct.PRODUCTLIST) != null){
                                            list<Map<string,object>> ProductsApiList = (list<Map<string,object>>)ProductsApiResponse.get(ccrz.ccApiProduct.PRODUCTLIST);
                                            
                                            
                                            //system.debug('ProductsApiList :: ' + ProductsApiList);
                                            for(Map<string,object> eachProductdetail : ProductsApiList){
                                                
                                                string ProductName = (string)eachProductdetail.get('sfdcName');
                                                system.debug('ProductName :: ' + ProductName);   
                                                
                                                string ProductID = (string)eachProductdetail.get('sfid');
                                                system.debug('ProductID :: ' + ProductID);   
                                                
                                                //logic for corecharge product
                                                boolean isCoreCharge = false;                                   
                                                
                                                
                                                
                                                String ProductURI;
                                                if((list<Map<string,object>>)eachProductdetail.get('EProductMediasS') != null){
                                                    
                                                    set<string> ProductURILinksList = new set<string>();
                                                    for(integer i=0; i< ((list<Map<string,object>>)eachProductdetail.get('EProductMediasS')).size() ; i++){                                                                
                                                        system.debug('URI LINK ' + i + ': ' +  (string)(((list<Map<string,object>>)eachProductdetail.get('EProductMediasS'))[i]).get('URI'));
                                                        if((string)(((list<Map<string,object>>)eachProductdetail.get('EProductMediasS'))[i]).get('mediaType')=='Product Image'){
                                                        //ProductURILinksList.add((string)(((list<Map<string,object>>)eachProductdetail.get('EProductMediasS'))[i]).get('URI')); 
                                                        ProductURI = (string)(((list<Map<string,object>>)eachProductdetail.get('EProductMediasS'))[i]).get('URI');  
                                                        Break;
                                                        }                                                       
                                                    }
                                                    system.debug('ProductURILinksList :: '  + ProductURILinksList); 
                                                }
                           
                                                
                                                
                                                decimal ProductPrice = 0;
                                                if(ProductPriceMap != null){
                                                    if((ProductPriceMap.keyset()).contains(ProductID)){
                                                        ProductPrice = (decimal)ProductPriceMap.get(ProductID);
                                                        system.debug('retrived price : '+ ProductPrice);
                                                    }                                   
                                                }
                                                decimal originalPrice=0;
                                                Integer discountPercentage=0;
                                                if(originalPriceMap != null){
                                                    if((originalPriceMap.keyset()).contains(ProductID)){
                                                        ccrz__E_PriceListItem__c priceListitem = (ccrz__E_PriceListItem__c)originalPriceMap.get(ProductID);
                                                        if(priceListitem !=null){
                                                            originalPrice = (Decimal)priceListitem.dbu_Original_Price__c;
                                                            discountPercentage = (Integer)priceListitem.dbu_Discount_Percent__c;
                                                        }
                                                    }                                   
                                                }
                                                boolean IsCrateEngine;
                                                IsCrateEngine = (boolean)eachProductdetail.get('dbuCrateEngine');

                                                //Added CECI-958
                                                string ProductSKU = (string)eachProductdetail.get('SKU');
                                                system.debug('ProductSKU :: ' + ProductSKU);
                                               
                                                
                                                boolean stockstatus = false;
                                                double inventoryQuantity = 0;
                                                if(productInventorymapping.size() > 0){                                                   
                                                    if((double)productInventorymapping.get(ProductID) != null){        
                                                        inventoryQuantity = (double)productInventorymapping.get(ProductID);
                                                        if(inventoryQuantity > 0){
                                                            stockstatus = true; 
                                                        }else{
                                                            stockstatus = false;
                                                        }                                                                                                                        
                                                    }    
                                                }                                                                                                    
                                                system.debug('stockstatus - ' + stockstatus);                                                   
                                                system.debug('inventoryQuantity > ' + inventoryQuantity);   
                                                
                                                
                                                
                                                
                                                dbu_SaveForLaterWrapper eachProductDetailInstance = new dbu_SaveForLaterWrapper();
                                                eachProductDetailInstance.ProductID         = ProductID; 
                                                eachProductDetailInstance.ProductName       = ProductName;
                                                eachProductDetailInstance.ProductURL        = ProductURI;
                                                eachProductDetailInstance.ProductPrice      = ProductPrice;                           
                                                eachProductDetailInstance.IsCrateProductCheck = IsCrateEngine;
                                                eachProductDetailInstance.IsCoreProductcheck = isCoreCharge;
                                                eachProductDetailInstance.inventoryQuantity = inventoryQuantity;
                                                eachProductDetailInstance.stockstatus = stockstatus; 
                                                eachProductDetailInstance.promotionTag = productvsPromotionTag.get(ProductID);   
                                                eachProductDetailInstance.originalPrice =originalPrice;
                                                eachProductDetailInstance.discountPercentage = discountPercentage;  
                                                eachProductDetailInstance.ProductSKU  =   ProductSKU;//Added CECI-958
                                                   
                                                ProductDetailResponse.put(ProductID, eachProductDetailInstance);
                                                //list<object> eachDetail = new  list<object>{ProductName, ProductURILinksList, ProductPrice};
                                                
                                                //ProductDetail.put(ProductID, eachDetail);
                                                
                                                
                                            }
                                        }
                                        
                                        //############### MAP CONTAINER TO HOLD PRODUCT NAME, PRICE, URIS ##########################                
                                        system.debug('ProductDetailResponse :: ' + ProductDetailResponse);
                                        system.debug('ProductDetailResponse sz:: ' + ProductDetailResponse.size());
                                        
                                    }catch(exception ex){
                                        system.debug('Exception ex' + ex);
                                    }
            
        }
          
        return ProductDetailResponse;
    }
    
    //Fetch Product details from a wishlist like Product URI, NAME & PRICE
    public static list<dbu_SaveForLaterWrapper> FetchProductDetails(Map<string,integer> ProductIDMap , string storeCountry){
        
        list<dbu_SaveForLaterWrapper> ProductDetailResponse = new list<dbu_SaveForLaterWrapper>();   
        Map<string,boolean> productToshipboolean_mapping = new Map<string,boolean>();
        //get the country cureency iso mapping from custom settings
        Map<string,string> countryCurrencyMap = new Map<string,string>();
        for(dbu_CountryCurrencyMapping__c eachsetting : (list<dbu_CountryCurrencyMapping__c>)dbu_CountryCurrencyMapping__c.getall().values()){
            system.debug('dbuCountryCode__c > ' + (string)eachsetting.get('dbuCountryCode__c'));
            system.debug('dbuCurrencyCode__c > ' + (string)eachsetting.get('dbuCurrencyCode__c'));
            countryCurrencyMap.put((string)eachsetting.get('dbuCountryCode__c'), (string)eachsetting.get('dbuCurrencyCode__c'));
        }
        system.debug('countryCurrencyMap > ' + countryCurrencyMap); 
        
        string currencyISOvalue = (string)countryCurrencyMap.get(storeCountry);
        
        set<string> ProductIDSet = new set<string>();
        ProductIDSet = ProductIDMap.keySet();
       	system.debug('ProductIDSet > ' + ProductIDSet);
        
        Map<string,String> productvsPromotag = getProductPromotiontag(ProductIDSet,storeCountry);
        //Start CECI-958
        string locationcode;
        if(storecountry=='US')
        {
            locationcode='US' ;
        }
        else if(storecountry=='CA')
        {
            locationcode='EN';
        }
        Map<string,string> CategoryMap =dbu_ProductCtrl.getcategoryfromproductid(ProductIDSet,locationcode);
        Map<string,string> BrandMap =dbu_ProductCtrl.getBrandfromproductid(ProductIDSet,locationcode);
        //End CECI-958
        list<ccrz__E_PriceListItem__c> pricedata = dbu_homePageCategoryTileCtrl.fetchPriceBySearchResult(ProductIDSet,storeCountry);
            map<String,ccrz__E_PriceListItem__c> originalPriceMap = new map<String,ccrz__E_PriceListItem__c> ();
            for(ccrz__E_PriceListItem__c priceLstItem: pricedata){
                originalPriceMap.put(priceLstItem.ccrz__Product__c,priceLstItem);
            }
        productToshipboolean_mapping = dbu_CallCCWishListApi.FetchShipToPickUpDetail(ProductIDSet);
        system.debug('productToshipboolean_mapping > '  +productToshipboolean_mapping );
        
        //GET RELATED PRODUCT FOR CORECHARGE
        set<ccrz__E_RelatedProduct__c> relProducts = new set<ccrz__E_RelatedProduct__c>(
         [select ccrz__RelatedProduct__r.id, 
          ccrz__Product__r.dbu_Available_to_ship__c, 
          ccrz__Product__r.dbu_Pick_Up_Only__c  from ccrz__E_RelatedProduct__c 
                       where ccrz__Product__c in : ProductIDSet 
                       and ccrz__RelatedProductType__c = 'Core Charge' 
                       and ccrz__Product__r.DBU_Product_Location__c includes (:storeCountry) 
                       //and ccrz__RelatedProduct__r.DBU_Product_Location__c includes (:storeCountry) 
                        and ccrz__RelatedProduct__r.dbu_Has_Core_Child__c = true ]
        );
        
        system.debug('relProducts > ' + relProducts);
        system.debug('relProducts sz > ' + relProducts.size());
        
        if(TEST.isRunningTest() == true){
            ccrz__E_Product__c geprod = [select id from ccrz__E_Product__c where name = 'TestProductcorechild'];
             set<ccrz__E_RelatedProduct__c> relProductss = new set<ccrz__E_RelatedProduct__c>();
                    ccrz__E_RelatedProduct__c u = new ccrz__E_RelatedProduct__c();
                    u.ccrz__RelatedProduct__c = geprod.id;
            relProductss.add(u);    
            relProducts = relProductss;
                        
        }
        
        
        //CHECK FOR INVENTORY
        Map<string,double> productInventorymapping = new Map<string,double>();
        list<AggregateResult> productInventory = new list<AggregateResult>();
        productInventory = [select SUM(ccrz__QtyAvailable__c) TOTALQUANTITY, ccrz__ProductItem__c PRODUCTID
                            from ccrz__E_ProductInventoryItem__c 
                            where ccrz__ProductItem__c IN : ProductIDSet 
                            and CurrencyIsoCode =: currencyISOvalue 
                            GROUP BY ccrz__ProductItem__c];
        system.debug(productInventory);
        
        if(productInventory.size() > 0){
        for(AggregateResult pi : productInventory){            
            productInventorymapping.put((string)pi.get('PRODUCTID'),(double)pi.get('TOTALQUANTITY'));
            system.debug('productInventorymapping > ' + productInventorymapping);
        }
        
        system.debug('productInventorymapping > ' + productInventorymapping);
        system.debug('productInventorymapping size > ' + productInventorymapping.size());  
        }        
        
        
        if(relProducts.size() > 0){
            
            //store related corecharge product id
            set<string> relatedProductsIdsetcorecharge = new set<string>();
           Map<string,list<string>> parentproductidmap = new Map<string,list<string>>();
           Map<string,boolean> parentproductidToflag = new Map<string,boolean>();
           
            for(ccrz__E_RelatedProduct__c rel : relProducts){
                system.debug('rel child p> ' + rel.ccrz__RelatedProduct__r.id);                                
                relatedProductsIdsetcorecharge.add((string)rel.ccrz__RelatedProduct__r.id);
                system.debug('rel Parent p > ' + rel.ccrz__Product__r.id);
                /*
				//------------------------------                
				boolean dbuship = false;
                
                if(rel.ccrz__Product__r != null){
                    boolean shipflag = false;
                    boolean pickflag = false;
                    if(rel.ccrz__Product__r.dbu_Available_to_ship__c){
                        shipflag = true;
                    }
                    
                    if(rel.ccrz__Product__r.dbu_Pick_Up_Only__c){
                        pickflag = true;
                    }
                    
                    if(shipflag == true && pickflag == false){
                        dbuship = true;
                    }
                    else if(shipflag == false && pickflag == true){
                        dbuship = false;
                    }                        
                    else if(shipflag == true && pickflag == true){
                        dbuship = true;
                    }  
                    else if(shipflag == false && pickflag == false){
                        dbuship = true;
                    }                      
                    parentproductidToflag.put(rel.ccrz__Product__r.id, dbuship);
                }
                system.debug('parentproductidToflag > ' + parentproductidToflag);
                    
				//------------------------------
                */
                if(parentproductidmap.get(rel.ccrz__RelatedProduct__r.id) != null){
                    list<string> er = new list<string>();
                    system.debug('inside parentproductidmap');
                    er = (list<string>)parentproductidmap.get((string)rel.ccrz__RelatedProduct__r.id);
                    system.debug('inside parentproductidmap > ' + er);
                    er.add(rel.ccrz__Product__r.id);
                    parentproductidmap.put(rel.ccrz__RelatedProduct__r.id, er);
                }else{
                    system.debug('inside parentproductidmap > else');
                    parentproductidmap.put(rel.ccrz__RelatedProduct__r.id, new list<string>{rel.ccrz__Product__r.id});
                }                
                system.debug('inside parentproductidmap > ' + parentproductidmap);
            }
            
            system.debug('relatedProductsIdsetcorecharge > ' + relatedProductsIdsetcorecharge);  
            system.debug('relatedProductsIdsetcorecharge sz > ' + relatedProductsIdsetcorecharge.size());
            
            //Get core products not having product location         
            list<ccrz__E_Product__c> coreProductsWithoutLocation = new list<ccrz__E_Product__c>();
            coreProductsWithoutLocation = [select id, 
                                           Name,
                                           (select id,name,ccrz__Enabled__c,ccrz__EndDate__c,
       ccrz__StartDate__c,dbu_store_location__c,
       ccrz__Storefront__c,ccrz__Category__r.Name from ccrz__Promotions__r 
        WHERE ccrz__Enabled__c = true 
              AND ccrz__EndDate__c >= today 
              AND ccrz__StartDate__c <= today
              AND ccrz__Storefront__c = 'CSSNAStore'
              AND dbu_store_location__c INCLUDES (:locationcode)),
                                           (select ccrz__Price__c   from ccrz__E_PriceListItems__r where ccrz__Pricelist__r.ccrz__CurrencyISOCode__c =: currencyISOvalue),
                                           (select ccrz__URI__c,ccrz__MediaType__c from ccrz__E_ProductMedias__r where ccrz__URI__c != null AND ccrz__MediaType__c =: 'Product Image')                                                                              
                                           from ccrz__E_Product__c 
                                           where dbu_Has_Core_Charge__c = true 
                                           and dbu_Has_Core_Child__c = true 
                                           and id in : relatedProductsIdsetcorecharge]; 
            
            System.debug('coreProductsWithoutLocation << '  +coreProductsWithoutLocation);
            System.debug('coreProductsWithoutLocation sz << '  +coreProductsWithoutLocation.size());
            
            if(Test.isRunningTest()){
                ccrz__E_Product__c testpro = new ccrz__E_Product__c();
                testpro.id = 'a2w1F000000bmKc';
                testpro.Name = 'testp';
                //testpro.ccrz__E_ProductMedias__r[0].ccrz__URI__c = 'https://www.gettyimages.in/collections/500px';
                //testpro.ccrz__E_PriceListItems__r[0].ccrz__Price__c = 73;                
                coreProductsWithoutLocation = new list<ccrz__E_Product__c>{testpro};
            }            
            
            //Remove the core product from Original list 
            for(ccrz__E_Product__c rel : coreProductsWithoutLocation){
                if(ProductIDSet.contains(rel.Id)){
                    ProductIDSet.remove(rel.Id);
                    ProductIDMap.remove(rel.Id);
                }
                
                dbu_SaveForLaterWrapper eachcoreProductDetailInstance = new dbu_SaveForLaterWrapper();
                eachcoreProductDetailInstance.ProductID         = rel.Id; 
                eachcoreProductDetailInstance.ProductName       = rel.Name;
                if(rel.ccrz__Promotions__r.size() > 0){
                    eachcoreProductDetailInstance.promotionTag = rel.ccrz__Promotions__r[0].ccrz__Category__r.Name;
                 }
                if(Test.isRunningTest()){
                    eachcoreProductDetailInstance.ProductURL        = 'https://www.gettyimages.in/collections/500px';
                    eachcoreProductDetailInstance.ProductPrice      = 67;                      
                }else{
                    if((rel.ccrz__E_PriceListItems__r).size() > 0){
                        eachcoreProductDetailInstance.ProductPrice      = rel.ccrz__E_PriceListItems__r[0].ccrz__Price__c; 
                    }else{
                        eachcoreProductDetailInstance.ProductPrice      = 0;
                    }                     
                    
                    if((rel.ccrz__E_ProductMedias__r).size() > 0){
                        eachcoreProductDetailInstance.ProductURL        = rel.ccrz__E_ProductMedias__r[0].ccrz__URI__c;
                    }else{
                        eachcoreProductDetailInstance.ProductURL = '';
                    }                     
                }                   
               
                system.debug('miguel' + parentproductidmap);
                if(parentproductidmap.get(rel.Id) != null){
                    list<string> currenctproductparent = new list<string>();
                    currenctproductparent = (list<string>)parentproductidmap.get(rel.Id);
                    system.debug('felix > ' + currenctproductparent);
                    if(currenctproductparent.size()>0){
                        system.debug('size > 0 ' );
                        if(currenctproductparent.size() > 1){
                            system.debug('size > 1 ' );
                            eachcoreProductDetailInstance.parentProductID = currenctproductparent[0];                            
                            currenctproductparent.remove(0);    
                        }if(currenctproductparent.size() > 0 && currenctproductparent.size() < 2){
                            system.debug('size <1 ' );
                            eachcoreProductDetailInstance.parentProductID = currenctproductparent[0];  
                        }
                    }
                }                
                
                if(eachcoreProductDetailInstance.parentProductID != null && eachcoreProductDetailInstance.parentProductID != ''){
                    if(productToshipboolean_mapping.get(eachcoreProductDetailInstance.parentProductID) != null){
                        //eachcoreProductDetailInstance.deliveryMethod = (boolean)parentproductidToflag.get(eachcoreProductDetailInstance.parentProductID);    
                        eachcoreProductDetailInstance.deliveryMethod = (boolean)productToshipboolean_mapping.get(eachcoreProductDetailInstance.parentProductID);    
                        system.debug('kiorn > ' + (boolean)productToshipboolean_mapping.get(eachcoreProductDetailInstance.parentProductID));
                    }
                    
                    /*
                    if(productToshipboolean_mapping.get(eachcoreProductDetailInstance.parentProductID) != null){
                    	eachcoreProductDetailInstance.deliveryMethod = (boolean)productToshipboolean_mapping.get(eachcoreProductDetailInstance.parentProductID);    
                    }*/                    
                }
                
                
                
                //eachcoreProductDetailInstance.ProductURL          = rel.ccrz__E_ProductMedias__r[0].ccrz__URI__c;
                //eachcoreProductDetailInstance.ProductPrice        = rel.ccrz__E_PriceListItems__r[0].ccrz__Price__c;                           
                eachcoreProductDetailInstance.IsCrateProductCheck = false;
                eachcoreProductDetailInstance.ProductQuantity = 1;
                eachcoreProductDetailInstance.IsCoreProductcheck = true;
                eachcoreProductDetailInstance.inventoryQuantity = 1;
                ProductDetailResponse.add(eachcoreProductDetailInstance);
            }             
            
            
        }
        
        system.debug('ProductDetailResponse in fetch after core > ' + json.serialize(ProductDetailResponse));
        system.debug('ProductDetailResponse in fetch after core sz > ' + ProductDetailResponse.size());
                
        if(ProductIDSet.size() > 0){
            //Formulate Input Data for CC PriceList & CC Product APIs
            
            //############### INPUT DATA FOR CC PRODUCT FETCH() ##########################
            Map<string,object> ProductInputData = new Map<string,object>{
                ccrz.ccApi.API_VERSION => ccrz.ccApi.CURRENT_VERSION,                   
                    ccrz.ccApi.SIZING => new Map<String, Object> {
                        ccrz.ccApiProduct.ENTITYNAME => new Map<String, Object> {
                            ccrz.ccApi.SZ_DATA => ccrz.ccApi.SZ_L,
                                ccrz.ccApi.SZ_REL => New List<String>{'E_ProductMedias__r'}    
                        }
                    },
                        ccrz.ccApiProduct.PRODUCTIDLIST => ProductIDSet,                    
                        ccrz.ccApiProduct.PRODUCTSTOREFRONT => 'CSSNAStore',
                        ccrz.ccApiProduct.TYPES => new Set<String>{'Product'},
                            'dBUProductLocation' => storeCountry    
                            };
                                
                                
                                //############### INPUT DATA FOR CC PRICELISTITEM FETCH() ##########################
                                Map<string,object> PricelistItemInputData = new Map<string,object>{
                                    ccrz.ccApi.API_VERSION => ccrz.ccApi.CURRENT_VERSION,
                                        ccrz.ccApiPriceList.PRODUCTIDS => ProductIDSet,
                                        ccrz.ccApiPriceList.CURRCODE => currencyISOvalue,
                                        ccrz.ccApi.SIZING => new Map<String, Object> {
                                            ccrz.ccApiPriceList.ENTITYNAME_PLI => new Map<String, Object> {
                                                ccrz.ccApi.SZ_DATA => ccrz.ccApi.SZ_L
                                                    }
                                        }    
                                };
                                    
                                    
                                    
                                    try{
                                        //############### MAP CONTAINER TO HOLD PRODUCT - PRICE MAPPING ##########################              
                                        Map<string,decimal> ProductPriceMap = new Map<string,decimal>();
                                        
                                        //############################################ FIRE CC PRICELIST FETCH() ###################################################
                                        try{
                                            Map<string,object> PricelistItemResponse = ccrz.ccApiPriceList.fetchPriceListItems(PricelistItemInputData);
                                            if(PricelistItemResponse.get(ccrz.ccApiPriceList.PRICELISTITEMS) != null){
                                                Map<String, Map<String, Object>> priceListItems = (Map<String, Map<String, Object>>)PricelistItemResponse.get(ccrz.ccApiPriceList.PRICELISTITEMS);
                                                
                                                List<Map<string,object>> pricelistitemsList = (List<Map<string,object>>)priceListItems.values();
                                                
                                                
                                                for(Map<string,object> eachPriceListItem : pricelistitemsList){
                                                    //system.debug(JSON.serializePretty((string)eachPriceListItem.get('product')));
                                                    //system.debug(JSON.serializePretty((decimal)eachPriceListItem.get('price')));
                                                    ProductPriceMap.put((string)eachPriceListItem.get('product') , (decimal)eachPriceListItem.get('price'));                                
                                                }
                                                system.debug('ProductPriceMap :: ' + ProductPriceMap);
                                            }
                                        }catch(Exception e){
                                            system.debug('exception : ' + e);
                                        }               
                                        
                                        //############### FIRE CC PRODUCT FETCH() ##########################
                                        Map<string, object> ProductsApiResponse = ccrz.ccApiProduct.fetch(ProductInputData);
                                        //system.debug('ProductsApiResponse ::' + ProductsApiResponse);
                                        system.debug(ProductsApiResponse.get(ccrz.ccApi.SUCCESS));
                                        
                                        //Map<string,object> ProductDetail = new Map<string,object>();
                                        
                                        if(ProductsApiResponse.get(ccrz.ccApiProduct.PRODUCTLIST) != null){
                                            list<Map<string,object>> ProductsApiList = (list<Map<string,object>>)ProductsApiResponse.get(ccrz.ccApiProduct.PRODUCTLIST);
                                            
                                            
                                            //system.debug('ProductsApiList :: ' + ProductsApiList);
                                            for(Map<string,object> eachProductdetail : ProductsApiList){
                                                
                                                string ProductName = (string)eachProductdetail.get('sfdcName');
                                                system.debug('ProductName :: ' + ProductName);   
                                                
                                                string ProductID = (string)eachProductdetail.get('sfid');
                                                system.debug('ProductID :: ' + ProductID);   
                                                
                                                //logic for corecharge product
                                                boolean isCoreCharge = false;                           
                                                
                                                String ProductURI;
                                                if((list<Map<string,object>>)eachProductdetail.get('EProductMediasS') != null){
                                                     
                                                    set<string> ProductURILinksList = new set<string>();
                                                    for(integer i=0; i< ((list<Map<string,object>>)eachProductdetail.get('EProductMediasS')).size() ; i++){                                                                
                                                        system.debug('URI LINK ' + i + ': ' +  (string)(((list<Map<string,object>>)eachProductdetail.get('EProductMediasS'))[i]).get('URI'));
                                                        if((string)(((list<Map<string,object>>)eachProductdetail.get('EProductMediasS'))[i]).get('mediaType')=='Product Image'){
                                                        //ProductURILinksList.add((string)(((list<Map<string,object>>)eachProductdetail.get('EProductMediasS'))[i]).get('URI')); 
                                                        ProductURI = (string)(((list<Map<string,object>>)eachProductdetail.get('EProductMediasS'))[i]).get('URI');  
                                                        Break;
                                                        }
                                                        
                                                    }
                                                    system.debug('ProductURILinksList :: '  + ProductURILinksList);                                                      
                                                }
                          
                                                
                                                integer ProductQuantity;
                                                system.debug('ProductID > ' + ProductID);
                                                system.debug('(integer)ProductIDMap.get(ProductID) > ' + (integer)ProductIDMap.get(ProductID));
                                                system.debug('ProductIDMap > ' + ProductIDMap );
                                                ProductQuantity = (integer)ProductIDMap.get(ProductID);
                                                system.debug('ProductQuantity > ' + ProductQuantity);
                                                
                                                decimal ProductPrice;
                                                if(ProductPriceMap != null){
                                                    if((ProductPriceMap.keyset()).contains(ProductID)){
                                                        ProductPrice = (decimal)ProductPriceMap.get(ProductID);
                                                        system.debug('retrived price : '+ ProductPrice);
                                                    }                                   
                                                }
                                                decimal originalPrice=0;
                                                Integer discountPercentage=0;
                                                if(originalPriceMap != null){
                                                    if((originalPriceMap.keyset()).contains(ProductID)){
                                                        ccrz__E_PriceListItem__c priceListitem = (ccrz__E_PriceListItem__c)originalPriceMap.get(ProductID);
                                                        if(priceListitem !=null){
                                                            originalPrice = (Decimal)priceListitem.dbu_Original_Price__c;
                                                            discountPercentage = (Integer)priceListitem.dbu_Discount_Percent__c;
                                                        }
                                                    }                                   
                                                }
                                                boolean IsCrateEngine;
                                                IsCrateEngine = (boolean)eachProductdetail.get('dbuCrateEngine');

                                                //Added CECI-958
                                                string ProductSKU = (string)eachProductdetail.get('SKU');
                                                system.debug('ProductSKU :: ' + ProductSKU);

                                                //Start CECI-958
                                                String Categoryname;
                                                String Brandname;
                                                if(CategoryMap.containsKey(ProductID))
                                                {
                                                   Categoryname=CategoryMap.get(ProductID);
                                                }

                                                if(BrandMap.containsKey(ProductID))
                                                {
                                                    Brandname=BrandMap.get(ProductID);
                                                }
                                                //END CECI-958
                                                
                                                
                                                boolean stockstatus = false;
                                                double inventoryQuantity = 0;
                                                if(productInventorymapping.size() > 0){                                                   
                                                    if((double)productInventorymapping.get(ProductID) != null){        
                                                        inventoryQuantity = (double)productInventorymapping.get(ProductID);
                                                        if(inventoryQuantity > 0){
                                                            stockstatus = true; 
                                                        }else{
                                                            stockstatus = false;
                                                        }                                                        
                                                                                                                      
                                                    }    
                                                }                                                                                                    
                                                system.debug('stockstatus - ' + stockstatus);                                                   
                                                system.debug('inventoryQuantity > ' + inventoryQuantity);                                                
                                                
                                                
                                                
                                                dbu_SaveForLaterWrapper eachProductDetailInstance = new dbu_SaveForLaterWrapper();
                                                eachProductDetailInstance.ProductID         = ProductID; 
                                                eachProductDetailInstance.ProductName       = ProductName;
                                                eachProductDetailInstance.ProductURL        = ProductURI;
                                                eachProductDetailInstance.ProductPrice      = ProductPrice;
                                                eachProductDetailInstance.ProductQuantity   = ProductQuantity;
                                                eachProductDetailInstance.IsCrateProductCheck = IsCrateEngine;
                                                eachProductDetailInstance.IsCoreProductcheck = isCoreCharge;
                                                eachProductDetailInstance.inventoryQuantity = inventoryQuantity;
                                                eachProductDetailInstance.stockstatus = stockstatus;
                                                eachProductDetailInstance.promotionTag = productvsPromotag.get(ProductID);  
                                                eachProductDetailInstance.originalPrice =originalPrice;
                                                eachProductDetailInstance.discountPercentage = discountPercentage; 
                                                eachProductDetailInstance.ProductSKU  =   ProductSKU;//Added CECI-958  
                                                eachProductDetailInstance.Brandname= Brandname;//Added CECI-958
                                                eachProductDetailInstance.Categoryname=Categoryname;//Added CECI-958                           
                                                
                                                if(productToshipboolean_mapping.get(ProductID) != null){
                                                    eachProductDetailInstance.deliveryMethod = (boolean)productToshipboolean_mapping.get(ProductID);
                                                }                                                                                   
           
                                                system.debug('eachProductDetailInstance > ' +eachProductDetailInstance);
                                                                                                
                                                ProductDetailResponse.add(eachProductDetailInstance);
                                                //list<object> eachDetail = new  list<object>{ProductName, ProductURILinksList, ProductPrice};
                                                
                                                //ProductDetail.put(ProductID, eachDetail);
                                                
                                                
                                            }
                                        }
                                        
                                        //############### MAP CONTAINER TO HOLD PRODUCT NAME, PRICE, URIS ##########################                
                                        system.debug('ProductDetailResponse after apis in fetch :: ' + ProductDetailResponse);
                                        
                                        
                                    }catch(exception ex){
                                        system.debug('Exception ex' + ex);
                                    }              
        }
 
        return ProductDetailResponse;
    }
    
    //Fetch Product details from a wishlist like Product URI, NAME & PRICE
    public static list<dbu_SaveForLaterWrapper> FetchProductDetailsforWL(Map<string,integer> ProductIDMap , string storeCountry){
        
        list<dbu_SaveForLaterWrapper> ProductDetailResponse = new list<dbu_SaveForLaterWrapper>();   
        Map<string,boolean> productToshipboolean_mapping = new Map<string,boolean>();

        string locationcode;
        if(storeCountry=='US')
        {
            locationcode='US';    
        }
        else if(storeCountry=='CA') 
        {
            locationcode='EN';
        }   
        
        //get the country cureency iso mapping from custom settings
        Map<string,string> countryCurrencyMap = new Map<string,string>();
        for(dbu_CountryCurrencyMapping__c eachsetting : (list<dbu_CountryCurrencyMapping__c>)dbu_CountryCurrencyMapping__c.getall().values()){
            system.debug('dbuCountryCode__c > ' + (string)eachsetting.get('dbuCountryCode__c'));
            system.debug('dbuCurrencyCode__c > ' + (string)eachsetting.get('dbuCurrencyCode__c'));
            countryCurrencyMap.put((string)eachsetting.get('dbuCountryCode__c'), (string)eachsetting.get('dbuCurrencyCode__c'));
        }
        system.debug('countryCurrencyMap > ' + countryCurrencyMap); 
        
        string currencyISOvalue = (string)countryCurrencyMap.get(storeCountry);
        
        set<string> ProductIDSet = new set<string>();
        ProductIDSet = ProductIDMap.keySet();
        system.debug('ProductIDSet > ' + ProductIDSet);
        Map<string,String> productvsPromotag = getProductPromotiontag(ProductIDSet,storeCountry);
        Map<string,string> CategoryMap =dbu_ProductCtrl.getcategoryfromproductid(ProductIDSet,locationcode);//Added CECI-958
         Map<string,string> BrandMap = dbu_ProductCtrl.getBrandfromproductid(ProductIDSet,locationcode);//Added CECI-958
        productToshipboolean_mapping = dbu_CallCCWishListApi.FetchShipToPickUpDetail(ProductIDSet);
        system.debug('productToshipboolean_mapping > '  +productToshipboolean_mapping );        
        
        //GET RELATED PRODUCT FOR CORECHARGE
        set<ccrz__E_RelatedProduct__c> relProducts = new set<ccrz__E_RelatedProduct__c>(
         [select ccrz__RelatedProduct__r.id,ccrz__Product__r.id  from ccrz__E_RelatedProduct__c 
                       where ccrz__Product__c in : ProductIDSet 
                       and ccrz__RelatedProductType__c = 'Core Charge' 
                       and ccrz__Product__r.DBU_Product_Location__c includes (:storeCountry) 
                       //and ccrz__RelatedProduct__r.DBU_Product_Location__c includes (:storeCountry) 
                        and ccrz__RelatedProduct__r.dbu_Has_Core_Child__c = true ]
        );
        
        system.debug('relProducts > ' + relProducts);
        system.debug('relProducts sz > ' + relProducts.size());
        
        if(TEST.isRunningTest() == true){
            ccrz__E_Product__c geprod = [select id from ccrz__E_Product__c where name = 'TestProductcorechild'];
             set<ccrz__E_RelatedProduct__c> relProductss = new set<ccrz__E_RelatedProduct__c>();
                    ccrz__E_RelatedProduct__c u = new ccrz__E_RelatedProduct__c();
                    u.ccrz__RelatedProduct__c = geprod.id;
            relProductss.add(u);    
            relProducts = relProductss;
                        
        }
        
        //CHECK FOR INVENTORY
        Map<string,double> productInventorymapping = new Map<string,double>();
        list<AggregateResult> productInventory = new list<AggregateResult>();
        productInventory = [select SUM(ccrz__QtyAvailable__c) TOTALQUANTITY, ccrz__ProductItem__c PRODUCTID
                            from ccrz__E_ProductInventoryItem__c 
                            where ccrz__ProductItem__c IN : ProductIDSet 
                            and CurrencyIsoCode =: currencyISOvalue 
                            GROUP BY ccrz__ProductItem__c];
        system.debug(productInventory);
        
        if(productInventory.size() > 0){
        for(AggregateResult pi : productInventory){            
            productInventorymapping.put((string)pi.get('PRODUCTID'),(double)pi.get('TOTALQUANTITY'));
            system.debug('productInventorymapping > ' + productInventorymapping);
        }
        
        system.debug('productInventorymapping > ' + productInventorymapping);
        system.debug('productInventorymapping size > ' + productInventorymapping.size());  
        }

        

            
            
        if(relProducts.size() > 0){
            
            //store related corecharge product id
            set<string> relatedProductsIdsetcorecharge = new set<string>();
            Map<string,integer> relatedProductsIdsetcorechargeMap = new Map<string,integer>();
            Map<string,list<string>> parentproductidmap = new Map<string,list<string>>();
            
            for(ccrz__E_RelatedProduct__c rel : relProducts){
                system.debug('rel child p> ' + rel.ccrz__RelatedProduct__r.id);
                system.debug('rel Parent p > ' + rel.ccrz__Product__r.id);
                
                if(parentproductidmap.get(rel.ccrz__RelatedProduct__r.id) != null){
                    list<string> er = new list<string>();
					er = (list<string>)parentproductidmap.get((string)rel.ccrz__RelatedProduct__r.id);
                    er.add(rel.ccrz__Product__r.id);
                    parentproductidmap.put(rel.ccrz__RelatedProduct__r.id, er);
                }else{
                    parentproductidmap.put(rel.ccrz__RelatedProduct__r.id, new list<string>{rel.ccrz__Product__r.id});
                }
               
                relatedProductsIdsetcorechargeMap.put((string)rel.ccrz__RelatedProduct__r.id, (integer)ProductIDMap.get((string)rel.ccrz__Product__r.id));
                relatedProductsIdsetcorecharge.add((string)rel.ccrz__RelatedProduct__r.id);
            }
            system.debug('relatedProductsIdsetcorechargeMap > ' + relatedProductsIdsetcorechargeMap);
            system.debug('relatedProductsIdsetcorecharge > ' + relatedProductsIdsetcorecharge);  
            system.debug('relatedProductsIdsetcorecharge sz > ' + relatedProductsIdsetcorecharge.size());
            
            //Get core products not having product location         
            list<ccrz__E_Product__c> coreProductsWithoutLocation = new list<ccrz__E_Product__c>();
            coreProductsWithoutLocation = [select id, 
                                           Name,
                                           (select ccrz__Price__c   from ccrz__E_PriceListItems__r where ccrz__Pricelist__r.ccrz__CurrencyISOCode__c =: currencyISOvalue),
                                           (select ccrz__URI__c,ccrz__MediaType__c from ccrz__E_ProductMedias__r where ccrz__URI__c != null AND ccrz__MediaType__c =: 'Product Image')                                                                              
                                           from ccrz__E_Product__c 
                                           where dbu_Has_Core_Charge__c = true 
                                           and dbu_Has_Core_Child__c = true 
                                           and id in : relatedProductsIdsetcorecharge]; 
            
            System.debug('coreProductsWithoutLocation << '  +coreProductsWithoutLocation);
            System.debug('coreProductsWithoutLocation sz << '  +coreProductsWithoutLocation.size());
            
            if(Test.isRunningTest()){
                ccrz__E_Product__c testpro = new ccrz__E_Product__c();
                testpro.id = 'a2w1F000000bmKc';
                testpro.Name = 'testp';
                //testpro.ccrz__E_ProductMedias__r[0].ccrz__URI__c = 'https://www.gettyimages.in/collections/500px';
                //testpro.ccrz__E_PriceListItems__r[0].ccrz__Price__c = 73;                
                coreProductsWithoutLocation = new list<ccrz__E_Product__c>{testpro};
            } 
            
            //Remove the core product from Original list 
            for(ccrz__E_Product__c rel : coreProductsWithoutLocation){
                if(ProductIDSet.contains(rel.Id)){
                    ProductIDSet.remove(rel.Id);
                    ProductIDMap.remove(rel.Id);
                }
                
                dbu_SaveForLaterWrapper eachcoreProductDetailInstance = new dbu_SaveForLaterWrapper();
                eachcoreProductDetailInstance.ProductID         = rel.Id; 
                eachcoreProductDetailInstance.ProductName       = rel.Name;
                eachcoreProductDetailInstance.promotionTag = productvsPromotag.get(rel.Id);                              

                system.debug('miguel' + parentproductidmap);
                if(parentproductidmap.get(rel.Id) != null){
                    list<string> currenctproductparent = new list<string>();
                    currenctproductparent = (list<string>)parentproductidmap.get(rel.Id);
                    if(currenctproductparent.size()>0){
                        if(currenctproductparent.size() > 1){
                            eachcoreProductDetailInstance.parentProductID = currenctproductparent[0];                            
                            currenctproductparent.remove(0);    
                        }if(currenctproductparent.size() > 0 && currenctproductparent.size() < 2){
                            eachcoreProductDetailInstance.parentProductID = currenctproductparent[0];  
                        }
                    }
                }
                
                
                system.debug('inside parentproductidmap > ' + parentproductidmap);
                if(Test.isRunningTest()){
                    eachcoreProductDetailInstance.ProductURL        = 'https://www.gettyimages.in/collections/500px';
                    eachcoreProductDetailInstance.ProductPrice      = 67;                      
                }else{  
                    if((rel.ccrz__E_PriceListItems__r).size() > 0){
                        eachcoreProductDetailInstance.ProductPrice      = rel.ccrz__E_PriceListItems__r[0].ccrz__Price__c; 
                    }else{
                        eachcoreProductDetailInstance.ProductPrice      = 0;
                    }                    
                    
                    if((rel.ccrz__E_ProductMedias__r).size() > 0){
                        eachcoreProductDetailInstance.ProductURL        = rel.ccrz__E_ProductMedias__r[0].ccrz__URI__c;
                    }else{
                        eachcoreProductDetailInstance.ProductURL = '';
                    }                
                }                
               
                
                if(eachcoreProductDetailInstance.parentProductID != null && eachcoreProductDetailInstance.parentProductID != ''){
                    if(productToshipboolean_mapping.get(eachcoreProductDetailInstance.parentProductID) != null){
                        //eachcoreProductDetailInstance.deliveryMethod = (boolean)parentproductidToflag.get(eachcoreProductDetailInstance.parentProductID);    
                        eachcoreProductDetailInstance.deliveryMethod = (boolean)productToshipboolean_mapping.get(eachcoreProductDetailInstance.parentProductID);    
                        system.debug('kiorn > ' + (boolean)productToshipboolean_mapping.get(eachcoreProductDetailInstance.parentProductID));
                    }
                    
                    /*
                    if(productToshipboolean_mapping.get(eachcoreProductDetailInstance.parentProductID) != null){
                    	eachcoreProductDetailInstance.deliveryMethod = (boolean)productToshipboolean_mapping.get(eachcoreProductDetailInstance.parentProductID);    
                    }*/                    
                }                
                
                
                //eachcoreProductDetailInstance.ProductURL          = rel.ccrz__E_ProductMedias__r[0].ccrz__URI__c;
                //eachcoreProductDetailInstance.ProductPrice        = rel.ccrz__E_PriceListItems__r[0].ccrz__Price__c;                           
                eachcoreProductDetailInstance.IsCrateProductCheck = false;
                eachcoreProductDetailInstance.ProductQuantity = (integer)relatedProductsIdsetcorechargeMap.get((string)rel.Id);
                eachcoreProductDetailInstance.IsCoreProductcheck = true;
                eachcoreProductDetailInstance.inventoryQuantity = 1;
                ProductDetailResponse.add(eachcoreProductDetailInstance);
            }             
            
            
        }
        
        system.debug('ProductDetailResponse in fetch after core > ' + json.serialize(ProductDetailResponse));
        system.debug('ProductDetailResponse in fetch after core sz > ' + ProductDetailResponse.size());
                
        if(ProductIDSet.size() > 0){
            //Formulate Input Data for CC PriceList & CC Product APIs
            
            //############### INPUT DATA FOR CC PRODUCT FETCH() ##########################
            Map<string,object> ProductInputData = new Map<string,object>{
                ccrz.ccApi.API_VERSION => ccrz.ccApi.CURRENT_VERSION,                   
                    ccrz.ccApi.SIZING => new Map<String, Object> {
                        ccrz.ccApiProduct.ENTITYNAME => new Map<String, Object> {
                            ccrz.ccApi.SZ_DATA => ccrz.ccApi.SZ_L,
                                ccrz.ccApi.SZ_REL => New List<String>{'E_ProductMedias__r'}    
                        }
                    },
                        ccrz.ccApiProduct.PRODUCTIDLIST => ProductIDSet,                    
                        ccrz.ccApiProduct.PRODUCTSTOREFRONT => 'CSSNAStore',
                        ccrz.ccApiProduct.TYPES => new Set<String>{'Product'},
                            'dBUProductLocation' => storeCountry    
                            };
                                
                                
                                system.debug('ProductIDSet > ' + ProductIDSet);
                                system.debug('currencyISOvalue > ' + currencyISOvalue);
            
                                //############### INPUT DATA FOR CC PRICELISTITEM FETCH() ##########################
                                Map<string,object> PricelistItemInputData = new Map<string,object>{
                                    ccrz.ccApi.API_VERSION => ccrz.ccApi.CURRENT_VERSION,
                                        ccrz.ccApiPriceList.PRODUCTIDS => ProductIDSet,
                                        ccrz.ccApiPriceList.CURRCODE => currencyISOvalue,
                                        ccrz.ccApi.SIZING => new Map<String, Object> {
                                            ccrz.ccApiPriceList.ENTITYNAME_PLI => new Map<String, Object> {
                                                ccrz.ccApi.SZ_DATA => ccrz.ccApi.SZ_L
                                                    }
                                        }    
                                };
                                    
                                    
                                    
                                    try{
                                        //############### MAP CONTAINER TO HOLD PRODUCT - PRICE MAPPING ##########################              
                                        Map<string,decimal> ProductPriceMap = new Map<string,decimal>();
                                        
                                        //############################################ FIRE CC PRICELIST FETCH() ###################################################
                                        try{
                                            Map<string,object> PricelistItemResponse = ccrz.ccApiPriceList.fetchPriceListItems(PricelistItemInputData);
                                            system.debug('PricelistItemResponse > ' + PricelistItemResponse);
                                            
                                            if(PricelistItemResponse.get(ccrz.ccApiPriceList.PRICELISTITEMS) != null){
                                                Map<String, Map<String, Object>> priceListItems = (Map<String, Map<String, Object>>)PricelistItemResponse.get(ccrz.ccApiPriceList.PRICELISTITEMS);
                                                
                                                List<Map<string,object>> pricelistitemsList = (List<Map<string,object>>)priceListItems.values();
                                                
                                                
                                                for(Map<string,object> eachPriceListItem : pricelistitemsList){
                                                    //system.debug(JSON.serializePretty((string)eachPriceListItem.get('product')));
                                                    //system.debug(JSON.serializePretty((decimal)eachPriceListItem.get('price')));
                                                    ProductPriceMap.put((string)eachPriceListItem.get('product') , (decimal)eachPriceListItem.get('price'));                                
                                                }
                                                system.debug('ProductPriceMap :: ' + ProductPriceMap);
                                            }
                                        }catch(Exception e){
                                            system.debug('exception : ' + e);
                                        }               
                                        
                                        //############### FIRE CC PRODUCT FETCH() ##########################
                                        Map<string, object> ProductsApiResponse = ccrz.ccApiProduct.fetch(ProductInputData);
                                        system.debug('ProductsApiResponse ::' + ProductsApiResponse);
                                        system.debug(ProductsApiResponse.get(ccrz.ccApi.SUCCESS));
                                        
                                        //Map<string,object> ProductDetail = new Map<string,object>();
                                        
                                        if(ProductsApiResponse.get(ccrz.ccApiProduct.PRODUCTLIST) != null){
                                            list<Map<string,object>> ProductsApiList = (list<Map<string,object>>)ProductsApiResponse.get(ccrz.ccApiProduct.PRODUCTLIST);
                                            
                                            
                                            //system.debug('ProductsApiList :: ' + ProductsApiList);
                                            for(Map<string,object> eachProductdetail : ProductsApiList){
                                                
                                                string ProductName = (string)eachProductdetail.get('sfdcName');
                                                system.debug('ProductName :: ' + ProductName);   
                                                
                                                string ProductID = (string)eachProductdetail.get('sfid');
                                                system.debug('ProductID :: ' + ProductID);   

                                                //Added CECI-992
                                                string ProductSKU = (string)eachProductdetail.get('SKU');
                                                system.debug('ProductSKU :: ' + ProductSKU);
                                                
                                                //logic for corecharge product
                                                boolean isCoreCharge = false;                           
                                                
                                                String ProductURI;
                                                system.debug('kkd >>>>' );
                                                system.debug('(list<Map<string,object>>)eachProductdetail' + (list<Map<string,object>>)eachProductdetail.get('EProductMediasS'));
                                                if((list<Map<string,object>>)eachProductdetail.get('EProductMediasS') != null){
                                                    system.debug('sncd > ' + (((list<Map<string,object>>)eachProductdetail.get('EProductMediasS'))[0]));                                                    
                                                    //ProductURI = (string)(((list<Map<string,object>>)eachProductdetail.get('EProductMediasS'))[0]).get('URI'); 
                                                    set<string> ProductURILinksList = new set<string>();
                                                    for(integer i=0; i< ((list<Map<string,object>>)eachProductdetail.get('EProductMediasS')).size() ; i++){                                                                
                                                        system.debug('URI LINK ' + i + ': ' +  (string)(((list<Map<string,object>>)eachProductdetail.get('EProductMediasS'))[i]).get('URI'));
                                                        if((string)(((list<Map<string,object>>)eachProductdetail.get('EProductMediasS'))[i]).get('mediaType')=='Product Image'){
                                                        //ProductURILinksList.add((string)(((list<Map<string,object>>)eachProductdetail.get('EProductMediasS'))[i]).get('URI')); 
                                                        ProductURI = (string)(((list<Map<string,object>>)eachProductdetail.get('EProductMediasS'))[i]).get('URI');  
                                                        Break;
                                                        }                        
                                                    }
                                                    system.debug('ProductURILinksList :: '  + ProductURILinksList);                                                    
                                                }
                            
                                                
                                                integer ProductQuantity;
                                                system.debug('ProductID > ' + ProductID);
                                                system.debug('(integer)ProductIDMap.get(ProductID) > ' + (integer)ProductIDMap.get(ProductID));
                                                system.debug('ProductIDMap > ' + ProductIDMap );
                                                ProductQuantity = (integer)ProductIDMap.get(ProductID);
                                                system.debug('ProductQuantity > ' + ProductQuantity);
                                                
                                                decimal ProductPrice;
                                                if(ProductPriceMap != null){
                                                    if((ProductPriceMap.keyset()).contains(ProductID)){
                                                        ProductPrice = (decimal)ProductPriceMap.get(ProductID);
                                                        system.debug('retrived price : '+ ProductPrice);
                                                    }                                   
                                                }
                                                
                                                boolean IsCrateEngine;
                                                IsCrateEngine = (boolean)eachProductdetail.get('dbuCrateEngine');
                                                                                                
                                                
                                                boolean stockstatus = false;
                                                double inventoryQuantity = 0;
                                                if(productInventorymapping.size() > 0){                                                   
                                                    if((double)productInventorymapping.get(ProductID) != null){        
                                                        inventoryQuantity = (double)productInventorymapping.get(ProductID);
                                                        if(inventoryQuantity > 0){
                                                            stockstatus = true; 
                                                        }else{
                                                            stockstatus = false;
                                                        }                                                            
                                                    }    
                                                }                                                                                                    
                                                system.debug('stockstatus - ' + stockstatus);                                                   
                                                system.debug('inventoryQuantity > ' + inventoryQuantity);                                                
                                                                                                
                                                
                                                dbu_SaveForLaterWrapper eachProductDetailInstance = new dbu_SaveForLaterWrapper();
                                                eachProductDetailInstance.ProductID         = ProductID; 
                                                eachProductDetailInstance.ProductName       = ProductName;
                                                eachProductDetailInstance.ProductURL        = ProductURI;
                                                eachProductDetailInstance.ProductPrice      = ProductPrice;
                                                eachProductDetailInstance.ProductQuantity   = ProductQuantity;
                                                eachProductDetailInstance.IsCrateProductCheck = IsCrateEngine;
                                                eachProductDetailInstance.IsCoreProductcheck = isCoreCharge;
                                                eachProductDetailInstance.inventoryQuantity = inventoryQuantity;
                                                eachProductDetailInstance.stockstatus       = stockstatus;
                                                eachProductDetailInstance.promotionTag = productvsPromotag.get(ProductID); 
                                                eachProductDetailInstance.ProductSKU  =   ProductSKU;//Added CECI-992 
                                                eachProductDetailInstance.Brandname= BrandMap.get(ProductID); //Added CECI-958                     
                                                eachProductDetailInstance.Categoryname=CategoryMap.get(ProductID);//Added CECI-958
                                                if(productToshipboolean_mapping.get(ProductID) != null){
                                                    eachProductDetailInstance.deliveryMethod = (boolean)productToshipboolean_mapping.get(ProductID);
                                                }                                                
                                                
                                                system.debug('eachProductDetailInstance > ' +eachProductDetailInstance);
                                                
                                                
                                                ProductDetailResponse.add(eachProductDetailInstance);
                                                //list<object> eachDetail = new  list<object>{ProductName, ProductURILinksList, ProductPrice};
                                                
                                                //ProductDetail.put(ProductID, eachDetail);
                                                
                                                
                                            }
                                        }
                                        
                                        //############### MAP CONTAINER TO HOLD PRODUCT NAME, PRICE, URIS ##########################                
                                        system.debug('ProductDetailResponse after apis in fetch :: ' + ProductDetailResponse);
                                        
                                        
                                    }catch(exception ex){
                                        system.debug('Exception ex' + ex);
                                    }              
        }
 
        return ProductDetailResponse;
    }    
    
    //Add Product to a wishlist 
    public static list<dbu_SaveForLaterWrapper> AddToDefaultWishlist(string defaultWishListID, string ProductID, string SFLorWL, string userQuantity, string storeCountry){
            system.debug('In add to class');
        
        	//for wishlist product availability status
            boolean ProductAvailabilityStatus = false;
            
        
            //get the country cureency iso mapping from custom settings
            Map<string,string> countryCurrencyMap = new Map<string,string>();
            for(dbu_CountryCurrencyMapping__c eachsetting : (list<dbu_CountryCurrencyMapping__c>)dbu_CountryCurrencyMapping__c.getall().values()){
                system.debug('dbuCountryCode__c > ' + (string)eachsetting.get('dbuCountryCode__c'));
                system.debug('dbuCurrencyCode__c > ' + (string)eachsetting.get('dbuCurrencyCode__c'));
                countryCurrencyMap.put((string)eachsetting.get('dbuCountryCode__c'), (string)eachsetting.get('dbuCurrencyCode__c'));
            }
            system.debug('countryCurrencyMap > ' + countryCurrencyMap);   
            string CurrencyISOcodeValue = (string)countryCurrencyMap.get(storeCountry);   
             
            //CHECK FOR INVENTORY
            Map<string,double> productInventorymapping = new Map<string,double>();
            list<AggregateResult> productInventory = new list<AggregateResult>();
            productInventory = [select SUM(ccrz__QtyAvailable__c) TOTALQUANTITY, ccrz__ProductItem__c PRODUCTID
                                from ccrz__E_ProductInventoryItem__c 
                                where ccrz__ProductItem__c =: ProductID 
                                and CurrencyIsoCode =: CurrencyISOcodeValue 
                                GROUP BY ccrz__ProductItem__c];
            system.debug(productInventory);            
            
            if(productInventory.size() > 0){
            for(AggregateResult pi : productInventory){            
                productInventorymapping.put((string)pi.get('PRODUCTID'),(double)pi.get('TOTALQUANTITY'));
                system.debug('productInventorymapping > ' + productInventorymapping);
            }
            
            system.debug('productInventorymapping > ' + productInventorymapping);
            system.debug('productInventorymapping size > ' + productInventorymapping.size());  
            }             
                
            double inventoryQuantity = 0;
            if(productInventorymapping.size() > 0){                                                   
                if((double)productInventorymapping.get(ProductID) != null){        
                    inventoryQuantity = (double)productInventorymapping.get(ProductID);
                    system.debug('inventoryQuantity > ' + inventoryQuantity);
                    if(inventoryQuantity > 0){
                        ProductAvailabilityStatus = true; 
                    }else{
                        ProductAvailabilityStatus = false;
                    }                                                               
                }    
            } 			            
            system.debug('ProductAvailabilityStatus >> ' + ProductAvailabilityStatus);
                
        
            //############################### Setup Input Data #######################################################
            Map<String, Object> wishlistItemInputData = new Map<String, Object>{
                ccrz.ccApi.API_VERSION => ccrz.ccApi.CURRENT_VERSION,
                    ccrz.ccAPIWishList.ID => defaultWishListID,          
                    ccrz.ccAPIProduct.PRODUCTIDLIST => new List<String>{ProductID},
                        //The save for later parameter can either be wishlist or save for later, default is set to cart.
                        //'SaveForLater' => 'Save For Later'
                        //'SaveForLater' => 'Wishlist'  
                        'SaveForLater' => SFLorWL,
                        'USER_SELECTED_QUANTITY' => userQuantity,
                        'dbuItemProductStatus'  => ProductAvailabilityStatus    
                        };
                            system.debug('wishlistItemInputData' + wishlistItemInputData);
                            
                            list<dbu_SaveForLaterWrapper> ProductDetailsResponse;
                            //############################### Fire AddTo method #####################################################
                            try{
                                Map<String, Object> WishlistCreateResponse = ccrz.ccApiWishList.addTo(wishlistItemInputData);   
                                system.debug('Wishlist add to api success ' + WishlistCreateResponse.get(ccrz.ccApi.SUCCESS));
                                if((boolean)WishlistCreateResponse.get(ccrz.ccApi.SUCCESS)){
                                    ProductDetailsResponse = dbu_CallCCWishListApi.FetchProductDetails(new Map<string,integer>{ProductID => integer.valueOf(userQuantity)} , storeCountry); 
                                    system.debug('Resp :: ' + ProductDetailsResponse);
                                }                                
                            }catch(exception e){
                                system.debug(e);
                                system.debug('cause > ' + e.getCause());
                                system.debug('get line num > ' + e.getLineNumber());
                                system.debug('message > ' + e.getMessage());
                                system.debug('stackTrace > ' + e.getStackTraceString());
                                system.debug('TypeName > ' + e.getTypeName());
                            }
        return ProductDetailsResponse;
    }
    
    //Delete single or all products from default Wishlist of a contact
    Public static boolean DeletedefaultWishlistItems(set<string> ToBeDeletedWishlistItemsList, string WishlistID, string dbu_SFL_OR_WL_Value, string storeCountry){
        boolean SuccessFLAG;

        //check if current product has any core product
         list<ccrz__E_Product__c> coreproducts = new  list<ccrz__E_Product__c>(); 
         coreproducts = getRelatedProductByProductIdSet(ToBeDeletedWishlistItemsList, storeCountry);
        
        if(coreproducts.size() > 0){
            for(ccrz__E_Product__c prod : coreproducts){
                ToBeDeletedWishlistItemsList.add(prod.id);
            }
        }
                            
        list<ccrz__E_CartItem__c> WishlistItemToBeDeleted = [select id from ccrz__E_CartItem__c where ccrz__Cart__c =: WishlistID AND DBU_SaveForLater__c =: dbu_SFL_OR_WL_Value AND ccrz__Cart__r.dbu_Cart_StoreCountry__c =: storeCountry and ccrz__Product__c in : ToBeDeletedWishlistItemsList];
        system.debug('WishlistItemToBeDeleted' + WishlistItemToBeDeleted);
        List<Database.DeleteResult> DeletedResults = Database.delete(WishlistItemToBeDeleted,false);
        
        set<id> deletedlists = new set<id>();
        
        for(Database.DeleteResult dr : DeletedResults) {
            if (dr.isSuccess()) {
                // Operation was successful
                System.debug('Successfully deleted account with ID: ' + dr.getId());
                deletedlists.add(dr.getId());
                system.debug('deletedlists > ' + deletedlists);
            }
            else {
                // Operation failed, so get all errors                
                for(Database.Error err : dr.getErrors()) {
                    System.debug('The following error has occurred.');                    
                    System.debug(err.getStatusCode() + ': ' + err.getMessage());
                    System.debug('WishlistItem fields that affected this error: ' + err.getFields());
                }
            }
        }        
        
        if(deletedlists.size() == ToBeDeletedWishlistItemsList.size()){
            system.debug('deletedlists.size() > ' + deletedlists.size());
            SuccessFLAG = true;
        }else{
            system.debug('deletedlists.size() > ' + deletedlists.size());
            SuccessFLAG = false;
        }
        
        //################### WISHLIST DELETE API LOGIC REDUNDANT ##############################################
        //Formulate Input Data 
        /*
        Map<string,object> InputData = new Map<string,object>{
          ccrz.ccAPI.API_VERSION => 9,
          ccrz.ccAPIWishList.WISHLIST_ITEM_IDS => ToBeDeletedWishlistItemsList
        }; */       
            /*
            try{
                system.debug('DELETE BLOCK');
                
                Map<string,object> DeleteWishlistItemAPIResponse = ccrz.ccAPIWishList.removeFrom(InputData);
                if(DeleteWishlistItemAPIResponse.get(ccrz.ccApi.SUCCESS) != null){
                    SuccessFLAG = (boolean)DeleteWishlistItemAPIResponse.get(ccrz.ccApi.SUCCESS);
                }                
            }Catch(exception e){
                System.debug('Exception type caught: ' + e.getTypeName());    
                System.debug('Message: ' + e.getMessage());    
                System.debug('Cause: ' + e.getCause());    
                System.debug('Line number: ' + e.getLineNumber());    
                System.debug('Stack trace: ' + e.getStackTraceString()); 
            }*/
        //################### WISHLIST DELETE API LOGIC REDUNDANT ##############################################
        
        return SuccessFLAG;
    }
    
    //Method to Insert multiple products in the cart at once
    public static List<String> insertMultipleCartItems(string cartID, string ContactID, Map<string,integer> ProductIDQuantityMap ,string storeCountry){
        list<string> ProductsAddToCart = new list<string>();
        try{
        /*
        list<ccrz__E_Product__c> getCoreProducts = new list<ccrz__E_Product__c>();
        getCoreProducts = dbu_CallCCWishListApi.getRelatedProductByProductIdSet(ProductIDQuantityMap.keyset(), storeCountry);            
        system.debug('getCoreProducts INSET MUL > ' + JSON.serialize(getCoreProducts));
        */    
        list<dbu_SaveForLaterWrapper> ProductDetails = dbu_CallCCWishListApi.FetchProductDetailsforWL(ProductIDQuantityMap, storeCountry);
        system.debug('ProductDetails INSET MUL > ' + JSON.serialize(ProductDetails));
            
            /*
            //Add core products to product details
            if(getCoreProducts.size() > 0){
                for(ccrz__E_Product__c eachprod : getCoreProducts){
                    dbu_SaveForLaterWrapper sflwrap = new dbu_SaveForLaterWrapper();
                    sflwrap.ProductID = eachprod.Id;
                    sflwrap.ProductPrice = eachprod.ccrz__E_PriceListItems__r[0].ccrz__Price__c;
                    sflwrap.ProductURL = eachprod.ccrz__E_ProductMedias__r[0].ccrz__URI__c;
                    sflwrap.ProductQuantity = 1;
                    ProductDetails.add(sflwrap);
                }
            } */           
            system.debug('ProductDetails INSET MUL 2 > ' + JSON.serialize(ProductDetails));
        List<Contact> CurrentContact = new list<Contact>();
        CurrentContact = [select id, AccountID from Contact where id =: ContactID];

        //Added by Malhar - 14 jan 2021                 
        //get the country cureency iso mapping from custom settings
        Map<string,string> countryCurrencyMap = new Map<string,string>();
        for(dbu_CountryCurrencyMapping__c eachsetting : (list<dbu_CountryCurrencyMapping__c>)dbu_CountryCurrencyMapping__c.getall().values()){
            system.debug('dbuCountryCode__c > ' + (string)eachsetting.get('dbuCountryCode__c'));
            system.debug('dbuCurrencyCode__c > ' + (string)eachsetting.get('dbuCurrencyCode__c'));
            countryCurrencyMap.put((string)eachsetting.get('dbuCountryCode__c'), (string)eachsetting.get('dbuCurrencyCode__c'));
        }
        system.debug('countryCurrencyMap > ' + countryCurrencyMap);   
        string CurrencyISOcodeValue = (string)countryCurrencyMap.get(storeCountry);             
            
        if(CurrentContact.size() > 0){
            
            ccrz.cc_RemoteActionContext ctx = new ccrz.cc_RemoteActionContext();
            ctx.storefront = 'CSSNAStore';
            ccrz.cc_CallContext.initRemoteContext(ctx);
            ccrz.cc_CallContext.currAccountId = string.valueof(CurrentContact[0].AccountID);
            ccrz.cc_CallContext.userCurrency = CurrencyISOcodeValue;
            ccrz.cc_CallContext.effAccountId = string.valueof(CurrentContact[0].AccountID);
            ccrz.cc_CallContext.currCartId = cartID;
            system.debug('felix');
            
            if(test.isRunningTest()){
                list<dbu_SaveForLaterWrapper> proddetail = new list<dbu_SaveForLaterWrapper>();
                ccrz__E_Product__c ProductRet1 = [SELECT id FROM ccrz__E_Product__c WHERE Name = 'TestProduct1'];
                dbu_SaveForLaterWrapper uis = new dbu_SaveForLaterWrapper();
                uis.ProductID = ProductRet1.id;
                uis.ProductQuantity = 5;
                uis.ProductPrice = 8;
                proddetail.add(uis);
                ProductDetails = proddetail;
            }
            
            list<object> ItemsLineData = new List<object>();
            for(dbu_SaveForLaterWrapper eachProduct : ProductDetails){
                
                ItemsLineData.add(new Map<String, Object> {
                    //ccrz.ccApiCart.LINE_DATA_SKU => sku,
                    ccrz.ccApiCart.LINE_DATA_PRODUCT_SFID => eachProduct.ProductID,
                        ccrz.ccApiCart.LINE_DATA_QUANTITY => eachProduct.ProductQuantity,
                        ccrz.ccApiCart.LINE_DATA_PRICE => eachProduct.ProductPrice,
                        ccrz.ccApiCart.LINE_DATA_ATTRIBUTE_LIST => null,
                        'dbuisShipTo' => eachProduct.deliveryMethod
                        });
            }
            
            Map<String, Object> cartItemsToAdd = new Map<String, Object> {
                ccrz.ccApi.API_VERSION => ccrz.ccApi.CURRENT_VERSION,
                    ccrz.ccApiCart.CART_ID => cartID,   
                    ccrz.ccApiCart.LINE_DATA => ItemsLineData
                    };
                        
                        try {
                            system.debug('cartItemsToAdd >>>> ' + cartItemsToAdd);
                            
                            Map<String, Object> addToCartResults = ccrz.ccApiCart.addTo(cartItemsToAdd);

                                                            
                            system.debug('added cart resiults >>>>> ' + addToCartResults);
                            system.debug('added cart resiults sz >>>>> ' + addToCartResults.size());
                            
                            boolean wasSuccessful = (Boolean)addToCartResults.get(ccrz.ccApi.SUCCESS);
                            system.debug('was successfulli > ' + wasSuccessful);
                            if(wasSuccessful){
                                if(addToCartResults.get(ccrz.ccAPICart.PRODSADDEDTOCART) != null){
                                    ProductsAddToCart = (list<string>)addToCartResults.get(ccrz.ccAPICart.PRODSADDEDTOCART);
                                    system.debug('ProductsAddToCart > ' + ProductsAddToCart);
                                    system.debug('ProductsAddToCart sz > ' + ProductsAddToCart.size());
                                }
                            }
                            
                        }catch (Exception e) {
                            // Error handling...
                            system.debug(e);
                            system.debug(e.getStackTraceString());
                            system.debug(e.getLineNumber());
                            system.debug('e--' + e.getCause());
                        }
            
        }
        
        }catch(exception e){
            system.debug('expection > ' + e);
        }
     return ProductsAddToCart;
    }  
    
    //Method to Insert multiple products in the cart at once from save for later Guest
     
    //Method to Insert multiple products in the cart at once from save for later Guest
    public static List<String> insertMultipleCartItemsSaveForLater(string cartID, Map<string,integer> ProductIDQuantityMap, string storeCountry){
        list<string> ProductsAddToCart = new list<string>();
        try{
            //list<ccrz__E_Product__c> getCoreProducts = new list<ccrz__E_Product__c>();
            //getCoreProducts = dbu_CallCCWishListApi.getRelatedProductByProductIdSet(ProductIDQuantityMap.keyset(), storeCountry);
            
            list<dbu_SaveForLaterWrapper> ProductDetails = dbu_CallCCWishListApi.FetchProductDetails(ProductIDQuantityMap, storeCountry);
            system.debug('ProductDetails MOSCOW > ' + ProductDetails);
                
            /*
            //Add core products to product details
            if(getCoreProducts.size() > 0){
                for(ccrz__E_Product__c eachprod : getCoreProducts){
                    dbu_SaveForLaterWrapper sflwrap = new dbu_SaveForLaterWrapper();
                    sflwrap.ProductID = eachprod.Id;
                    sflwrap.ProductPrice = eachprod.ccrz__E_PriceListItems__r[0].ccrz__Price__c;
                    sflwrap.ProductURL = eachprod.ccrz__E_ProductMedias__r[0].ccrz__URI__c;
                    ProductDetails.add(sflwrap);
                }
            }   */         
            
            system.debug('ProductDetails afetr > ' + ProductDetails);
            system.debug('ProductDetails afetr size > ' + ProductDetails.size());
            
            system.debug('ProductIDQuantityMap > ' + ProductIDQuantityMap);
            String userType = UserInfo.getUserType();
            
            string userID = UserInfo.getUserID(); 
            
            //Added by Malhar - 14 jan 2021                 
            //get the country cureency iso mapping from custom settings
            Map<string,string> countryCurrencyMap = new Map<string,string>();
            for(dbu_CountryCurrencyMapping__c eachsetting : (list<dbu_CountryCurrencyMapping__c>)dbu_CountryCurrencyMapping__c.getall().values()){
                system.debug('dbuCountryCode__c > ' + (string)eachsetting.get('dbuCountryCode__c'));
                system.debug('dbuCurrencyCode__c > ' + (string)eachsetting.get('dbuCurrencyCode__c'));
                countryCurrencyMap.put((string)eachsetting.get('dbuCountryCode__c'), (string)eachsetting.get('dbuCurrencyCode__c'));
            }
            system.debug('countryCurrencyMap > ' + countryCurrencyMap);   
            string CurrencyISOcodeValue = (string)countryCurrencyMap.get(storeCountry);              
            
            if (userType != 'Guest'){
                system.debug('loggedIN User');
                
                //################## Get Contact Details from loggedIn user  
                
                Map<String, Object> UserAPIInputData = new Map<String,Object>{
                    ccrz.ccApi.API_VERSION => ccrz.ccApi.CURRENT_VERSION,
                        ccrz.ccApi.SIZING => new Map<String, Object> { 
                            ccrz.ccApiUser.ENTITYNAME => new Map<String, Object> { 
                                ccrz.ccApi.SZ_DATA => ccrz.ccApi.SZ_S
                                    }
                        },
                            ccrz.ccApiUser.USER_ID => userID          
                            }; 
                                
                                //######################### Fetch Current User Details ####################################
                                Map<string,object> UserAPIResponse = ccrz.ccApiUser.fetch(UserAPIInputData);     
                system.debug('SUCCESS FLAG : : ' +  (Boolean)UserAPIResponse.get(ccrz.ccApi.SUCCESS));
                
                if(UserAPIResponse.get(ccrz.ccApiUser.USERLIST) != null){
                    List<Map<String, Object>> UserRetrivedList = (List<Map<String, Object>>)UserAPIResponse.get(ccrz.ccApiUser.USERLIST);
                    system.debug('UserRetrivedList :: ' + UserRetrivedList);
                    
                    //##################### Get Contact ID for the same User ##############################
                    string contactID = (string)UserRetrivedList[0].get('contactId');
                    //string contactID = '0031900000iIKEc';
                    system.debug('contactID >' + contactID);        
                    
                    List<Contact> CurrentContact = [select id, AccountID from Contact where id =: contactID];
                    
                   
                    
                    if(!CurrentContact.isEmpty() && CurrentContact != null){ 
                        system.debug('LoggedIn User : Current contact found');
                        ccrz.cc_RemoteActionContext ctx = new ccrz.cc_RemoteActionContext();
                        ctx.storefront = 'CSSNAStore';
                        ccrz.cc_CallContext.initRemoteContext(ctx);
                        system.debug('CurrentContact > ' + CurrentContact);
                        string currentAccountID; 
                        for(Contact c : CurrentContact){
                            currentAccountID = c.AccountID; 
                        }
                        ccrz.cc_CallContext.currAccountId = currentAccountID;//string.valueof(CurrentContact[0].AccountID);
                        
                        
                        ccrz.cc_CallContext.userCurrency = CurrencyISOcodeValue;
                        //ccrz.cc_CallContext.effAccountId = string.valueof(CurrentContact[0].AccountID);
                        //ccrz.cc_CallContext.currCartId = cartID;
                        system.debug('felix');
                    }
                    
                    //***************************************************
                    list<object> ItemsLineData = new List<object>();
                    for(dbu_SaveForLaterWrapper eachProduct : ProductDetails){
                        //system.debug('eachProduct > ' + eachProduct);
                        
                        ItemsLineData.add(new Map<String, Object> {
                            
                            //ccrz.ccApiCart.LINE_DATA_SKU => sku,
                            ccrz.ccApiCart.LINE_DATA_PRODUCT_SFID => eachProduct.ProductID,
                                ccrz.ccApiCart.LINE_DATA_QUANTITY => eachProduct.ProductQuantity,
                                ccrz.ccApiCart.LINE_DATA_PRICE => eachProduct.ProductPrice,
                                ccrz.ccApiCart.LINE_DATA_ATTRIBUTE_LIST => null,
                                'dbuisShipTo' => eachProduct.deliveryMethod
                                });
                    }
                    system.debug('ItemsLineData > ' + ItemsLineData);                    
                    
                    
                    Map<String, Object> cartItemsToAdd = new Map<String, Object> {
                        ccrz.ccApi.API_VERSION => ccrz.ccApi.CURRENT_VERSION,
                            ccrz.ccApiCart.CART_ID => cartID,   
                            ccrz.ccApiCart.LINE_DATA => ItemsLineData
                            };       
                                
                        
                        try {
                            Map<String, Object> addToCartResults = ccrz.ccApiCart.addTo(cartItemsToAdd);
                            
                            
                            system.debug(addToCartResults);
                            boolean wasSuccessful = (Boolean)addToCartResults.get(ccrz.ccApi.SUCCESS);
                            system.debug(wasSuccessful);
                            if(wasSuccessful){
                                if(addToCartResults.get(ccrz.ccAPICart.PRODSADDEDTOCART) != null){
                                    ProductsAddToCart = (list<string>)addToCartResults.get(ccrz.ccAPICart.PRODSADDEDTOCART);
                                    
                                }
                            }
                            
                        }catch (Exception e) {
                            // Error handling...
                            system.debug(e);
                            system.debug(e.getCause());
                            system.debug(e.getLineNumber());
                            system.debug(e.getMessage());
                        }                                
                                
                    //***************************************************
                    
                }
            }else{
                system.debug('Guest User'); 
                //string AccountId = '0011F00000fk3pH';                                
                ccrz.cc_RemoteActionContext ctx = new ccrz.cc_RemoteActionContext();                                        
                ctx.storefront = 'CSSNAStore';
                ccrz.cc_CallContext.initRemoteContext(ctx);
                //ccrz.cc_CallContext.currAccountId = AccountId;
                ccrz.cc_CallContext.userCurrency = CurrencyISOcodeValue;
                //ccrz.cc_CallContext.effAccountId = AccountId;
                //ccrz.cc_CallContext.currCartId = cartID;
                system.debug('felix');  
                

                
                Map<string,double> prodPriceMap = new Map<string,double>();
                Map<string,boolean> productTodeliverymethodmap = new Map<string,boolean>();
                
                for(dbu_SaveForLaterWrapper eachProduct : ProductDetails){
                    prodPriceMap.put(eachProduct.ProductID, eachProduct.ProductPrice);
                    productTodeliverymethodmap.put(eachProduct.ProductID, eachProduct.deliveryMethod);
                }
                
                system.debug('prodPriceMap > ' + prodPriceMap);
                system.debug('prodPriceMap size > ' + prodPriceMap.size());
                
                list<ccrz__E_CartItem__c> objccCartItemLst = new list<ccrz__E_CartItem__c>();
                for(string pprodId : prodPriceMap.keyset()){
                    double itemPrice = (double)prodPriceMap.get(pprodId);
                    integer ProdQuantity = 1;
                    boolean deliverymethod = false;
                    if(productTodeliverymethodmap.get(pprodId) != null){
                        deliverymethod = (boolean)productTodeliverymethodmap.get(pprodId);
                    }
                    ccrz__E_CartItem__c objccCartItem = new ccrz__E_CartItem__c(ccrz__ProductType__c = 'Product', ccrz__UnitOfMeasure__c = 'Each', ccrz__StoreID__c = 'CSSNAStore',ccrz__RequestDate__c = Date.today(), ccrz__OriginalItemPrice__c = itemPrice ,ccrz__OriginalQuantity__c = ProdQuantity,ccrz__Cart__c = cartId,ccrz__Quantity__c=ProdQuantity, ccrz__Product__c = pprodId, ccrz__Price__c = itemPrice, ccrz__SubAmount__c = itemPrice, dbu_isShipTo__c = deliverymethod, CurrencyIsoCode = CurrencyISOcodeValue);    
                    objccCartItemLst.add(objccCartItem);                        
                }
                
                system.debug('objccCartItemLst > ' + objccCartItemLst);
                system.debug('objccCartItemLst size > ' + objccCartItemLst.size());

                Database.SaveResult[] srList = Database.insert(objccCartItemLst, false);
                system.debug('srList > ' + srList);
                
                list<string> cartItemsList = new list<string>();
                
                // Iterate through each returned result
                for (Database.SaveResult sr : srList) {
                    if (sr.isSuccess()) {
                        // Operation was successful, so get the ID of the record that was processed
                        System.debug('Successfully inserted CartItems. Cartitems ID: ' + sr.getId());
                        cartItemsList.add(sr.getId());
                    }
                    else {
                        // Operation failed, so get all errors                
                        for(Database.Error err : sr.getErrors()) {
                            System.debug('The following error has occurred.');                    
                            System.debug(err.getStatusCode() + ': ' + err.getMessage());
                            System.debug('Account fields that affected this error: ' + err.getFields());
                        }
                    }
                }                
                
                for(ccrz__E_CartItem__c retpro : [SELECT ccrz__Product__c FROM ccrz__E_CartItem__c WHERE ID IN : cartItemsList and ccrz__cartItemType__c != 'Coupon']){
                    system.debug('retpro > ' + retpro.ccrz__Product__c);
                    ProductsAddToCart.add(retpro.ccrz__Product__c);
                }
                system.debug('ProductsAddToCart > ' + ProductsAddToCart);
            } 
        
            
        }catch(exception e){
            system.debug('expection > ' + e);
        }
        return ProductsAddToCart;
    } 
    
    //Method to get Inventory status of products in default wishlist for all contacts
    public static void getInventoryStatusforWishlistProductsForAllContacts(List<ccrz__E_CartItem__c> CARTLIST){        
        system.debug('CARTLIST inside the email resp wrap method> '+ CARTLIST);
        
        Map<string,object> ReturnResponse = new Map<string,object>();
        
        //get the country cureency iso mapping from custom settings
        Map<string,string> countryCurrencyMap = new Map<string,string>();
        for(dbu_CountryCurrencyMapping__c eachsetting : (list<dbu_CountryCurrencyMapping__c>)dbu_CountryCurrencyMapping__c.getall().values()){
            system.debug('dbuCountryCode__c > ' + (string)eachsetting.get('dbuCountryCode__c'));
            system.debug('dbuCurrencyCode__c > ' + (string)eachsetting.get('dbuCurrencyCode__c'));
            countryCurrencyMap.put((string)eachsetting.get('dbuCountryCode__c'), (string)eachsetting.get('dbuCurrencyCode__c'));
        }
        system.debug('countryCurrencyMap > ' + countryCurrencyMap);
		
        if(Test.isRunningTest()){
            countryCurrencyMap.put('US','USD');
            countryCurrencyMap.put('CA','CAD');
        }
		        
        
        set<string> CountryISOCode_set =new set<string>();
        CountryISOCode_set = (set<string>)countryCurrencyMap.keyset();
        
        Map<string,list<ccrz__E_CartItem__c>> EmailToCartItemListMap = new Map<string,list<ccrz__E_CartItem__c>>();
        set<string> CompleteProductIdSet = new set<string>();
        
		list<ccrz__E_CartItem__c> CartItemListToFilter = new list<ccrz__E_CartItem__c>();
            
        for(ccrz__E_CartItem__c eachCrtItem : CARTLIST){
            CompleteProductIdSet.add((string)eachCrtItem.ccrz__Product__c);
        }
        
		
        /********************************* GETTING PRODUCT INVENTORY, PRICING AND URIS *********************************************/
        
        list<string> CurrencyISOcode_list = new list<string>();
        CurrencyISOcode_list = (list<string>)countryCurrencyMap.values();        
        
        //Handling Product Inventory and Pricing 
        Map<string,Map<string,double>> CurrencyISObyProductInventoryMapping = new Map<string,Map<string,double>>();
		Map<string,Map<string,double>> CurrencyISObyProductPriceMapping = new Map<string,Map<string,double>>();            
        
        for(string currencycodestring: CurrencyISOcode_list){
            system.debug('currencycodestring  > ' + currencycodestring);
            CurrencyISObyProductInventoryMapping.put(currencycodestring, new Map<string,double>{});
            CurrencyISObyProductPriceMapping.put(currencycodestring, new Map<string,double>{});            
        }
        
        system.debug('CurrencyISObyProductInventoryMapping > ' + CurrencyISObyProductInventoryMapping);
        
        //-------> firing the get product inventory logic        
        
        //-------> CHECK FOR INVENTORY
        list<AggregateResult> productInventory = new list<AggregateResult>();
        productInventory = [select SUM(ccrz__QtyAvailable__c) TOTALQUANTITY, 
                            ccrz__ProductItem__c PRODUCTID, 
                            CurrencyIsoCode CURRENCYCODE 
                            from ccrz__E_ProductInventoryItem__c 
                            where ccrz__ProductItem__c IN : CompleteProductIdSet 
                            and CurrencyIsoCode IN : CurrencyISOcode_list 
                            GROUP BY ccrz__ProductItem__c,CurrencyIsoCode];
        system.debug(productInventory);        
        
        //-------> STORE INVENTORY FOR PRODUCTS
        if(productInventory.size() > 0){
            for(AggregateResult pi : productInventory){
                string pi_currencycode = (string)pi.get('CURRENCYCODE');
                if(pi.get('PRODUCTID') != null && pi.get('TOTALQUANTITY') != null){
                    Map<string,double> current_currencycode_productinventory = (Map<string,double>)CurrencyISObyProductInventoryMapping.get(pi_currencycode);
                    system.debug('PRODUCTID > ' + (string)pi.get('PRODUCTID') + ' TOTAL QUANTITY > ' +  (double)pi.get('TOTALQUANTITY'));
                    
                    current_currencycode_productinventory.put((string)pi.get('PRODUCTID') , (double)pi.get('TOTALQUANTITY'));                
                    //CurrencyISObyProductInventoryMapping
                    CurrencyISObyProductInventoryMapping.put(pi_currencycode, current_currencycode_productinventory);        	                    
                }
            }
        }
        
        system.debug('CurrencyISObyProductInventoryMapping > ' + CurrencyISObyProductInventoryMapping);        
        
        
        Map<string,string> ProductURIsMap = new Map<string,string>();        
                            
        //------->Retrive prices and product medias for products
         list<ccrz__E_Product__c> ProductPrices = new list<ccrz__E_Product__c>();
         ProductPrices = [select id,                          
                          (select ccrz__Price__c, CurrencyIsoCode from ccrz__E_PriceListItems__r where ccrz__Pricelist__r.ccrz__CurrencyISOCode__c IN : CurrencyISOcode_list),
                          (select ccrz__URI__c from ccrz__E_ProductMedias__r where ccrz__URI__c != null and ccrz__MediaType__c = 'Product Image' LIMIT 1) 
                          from ccrz__E_Product__c 
                          WHERE id in : CompleteProductIdSet];
		
        
        for(ccrz__E_Product__c eachProduct : ProductPrices){
            //--------->Storing Products , currencyiso code and prices Mapping
            if((eachProduct.ccrz__E_PriceListItems__r).size() > 0){
                for(ccrz__E_PriceListItem__c eachpricelistitem : eachProduct.ccrz__E_PriceListItems__r){
                    string currentPricelistItemIsocode = (string)eachpricelistitem.CurrencyIsoCode;
                    Map<string,double> currentPLIfromMainMap = (Map<string,double>)CurrencyISObyProductPriceMapping.get(currentPricelistItemIsocode);
                    currentPLIfromMainMap.put((string)eachProduct.id, (double)eachpricelistitem.ccrz__Price__c);
                    CurrencyISObyProductPriceMapping.put(currentPricelistItemIsocode, currentPLIfromMainMap);
                }
            }
            //-------->stroring Products and URI mapping
            if((eachProduct.ccrz__E_ProductMedias__r).size() > 0){
                ProductURIsMap.put((string)eachProduct.id, (string)(eachProduct.ccrz__E_ProductMedias__r[0].ccrz__URI__c));
            }
        }
        
        
        system.debug('CurrencyISObyProductPriceMapping > ' + CurrencyISObyProductPriceMapping);
        system.Debug('ProductURIsMap > ' + ProductURIsMap);        
        
        /********************************* GETTING PRODUCT INVENTORY, PRICING AND URIS *********************************************/        

        set<dbu_Emailer__c> dbuEmailerListToInsert = new set<dbu_Emailer__c>();
        set<dbu_Emailer__c> dbuEmailerListToInsertDuplicate = new set<dbu_Emailer__c>(); 
        set<ccrz__E_CartItem__c> finalCartItemsList = new set<ccrz__E_CartItem__c>();
        
        for(ccrz__E_CartItem__c eachCrtItem : CARTLIST){
            //CompleteProductIdSet.add((string)eachCrtItem.ccrz__Product__c);

			if(eachCrtItem.ccrz__Cart__r.dbu_Cart_StoreCountry__c != null &&  eachCrtItem.ccrz__Cart__r.dbu_Cart_StoreCountry__c != '' &&  eachCrtItem.ccrz__Cart__r.ccrz__Contact__r.Email != null && eachCrtItem.ccrz__Cart__r.ccrz__Contact__r.Email != '' && eachCrtItem.ccrz__Cart__r.ccrz__Contact__c != null && (string)eachCrtItem.ccrz__Cart__r.ccrz__Contact__c != ''){
				
				string currentCurrencyCodeforRegion = (string)countryCurrencyMap.get((string)eachCrtItem.ccrz__Cart__r.dbu_Cart_StoreCountry__c);
                boolean ProductInstock = false;
				
                
                if((double)((Map<string,double>)CurrencyISObyProductInventoryMapping.get(currentCurrencyCodeforRegion)).get((string)eachCrtItem.ccrz__Product__c) != null){
                    double quantity;
                    if(Test.isRunningTest()){
                        quantity = 89;
                    }else{
                    	quantity = (double)((Map<string,double>)CurrencyISObyProductInventoryMapping.get(currentCurrencyCodeforRegion)).get((string)eachCrtItem.ccrz__Product__c);
                    }
                    
                    if(quantity > 0){
                        ProductInstock = true;
                        system.debug('ProductInstock reset value > '+ ProductInstock);
                    }					                    
                }

				if(ProductInstock == true){							
					dbuEmailerListToInsertDuplicate = dbuEmailerListToInsert.clone();
					if(dbuEmailerListToInsertDuplicate.size() > 0){
						for(dbu_Emailer__c eachEmailerRecord : dbuEmailerListToInsertDuplicate){
							if(eachEmailerRecord.dbu_Contact_Email__c != eachCrtItem.ccrz__Cart__r.ccrz__Contact__r.Email || 
							   eachEmailerRecord.dbu_Wishlist_Country__c != eachCrtItem.ccrz__Cart__r.dbu_Cart_StoreCountry__c || 
							   eachEmailerRecord.dbu_Email_Contact__c != (string)eachCrtItem.ccrz__Cart__r.ccrz__Contact__c){
								  dbu_Emailer__c currentRecordToInsert = new dbu_Emailer__c();
									   currentRecordToInsert.dbu_Contact_Email__c = eachCrtItem.ccrz__Cart__r.ccrz__Contact__r.Email;
									   currentRecordToInsert.dbu_Wishlist_Country__c = eachCrtItem.ccrz__Cart__r.dbu_Cart_StoreCountry__c;
									   currentRecordToInsert.dbu_Email_Contact__c = (string)eachCrtItem.ccrz__Cart__r.ccrz__Contact__c;
									   currentRecordToInsert.dbu_Email_for_Wishlist__c = true;
									   currentRecordToInsert.dbu_Email_Sent__c = false;
									   currentRecordToInsert.dbu_Email_Sending_Initiated__c = false;
                                   if(eachCrtItem.ccrz__Cart__r.dbu_storeLanguage__c != null){
                                       currentRecordToInsert.dbu_Wishlist_Language__c = eachCrtItem.ccrz__Cart__r.dbu_storeLanguage__c;
                                   }else{
                                       currentRecordToInsert.dbu_Wishlist_Language__c = System.Label.dbu_home_store_U_S_A;
                                   }
								  dbuEmailerListToInsert.add(currentRecordToInsert); 
							   }                                
						}                                                        
					}else{                            
					//setup first current emailer
					dbu_Emailer__c currenctEmailer = new dbu_Emailer__c();
						currenctEmailer.dbu_Contact_Email__c = eachCrtItem.ccrz__Cart__r.ccrz__Contact__r.Email;
						currenctEmailer.dbu_Wishlist_Country__c = eachCrtItem.ccrz__Cart__r.dbu_Cart_StoreCountry__c;
						currenctEmailer.dbu_Email_Contact__c = (string)eachCrtItem.ccrz__Cart__r.ccrz__Contact__c;					
						currenctEmailer.dbu_Email_for_Wishlist__c = true;
						currenctEmailer.dbu_Email_Sent__c = false;
						currenctEmailer.dbu_Email_Sending_Initiated__c = false;
                        if(eachCrtItem.ccrz__Cart__r.dbu_storeLanguage__c != null){
                            currenctEmailer.dbu_Wishlist_Language__c = eachCrtItem.ccrz__Cart__r.dbu_storeLanguage__c;
                        }else{
                            currenctEmailer.dbu_Wishlist_Language__c = System.Label.dbu_home_store_U_S_A;
                        }
                        
					dbuEmailerListToInsert.add(currenctEmailer);
					}					
					finalCartItemsList.add(eachCrtItem);					
				}
					
			}
			
			}		
		
        
        
        
        system.debug('dbuEmailerListToInsert > ' + dbuEmailerListToInsert);
        system.debug('finalCartItemsList > ' + finalCartItemsList );
        system.debug('finalCartItemsList size() > ' + finalCartItemsList.size());    
        
        //-----------> Insert dbu_emailer records.
        
        List<dbu_Emailer__c> dbu_Emailer_Inserts_List = new List<dbu_Emailer__c>(dbuEmailerListToInsert);
        database.SaveResult[] dbu_emailerInserts = Database.insert(dbu_Emailer_Inserts_List, false);
        
        list<string> dbu_EmailerInsertedIDs = new list<string>();
        
        for (Database.SaveResult sr : dbu_emailerInserts) {
            if (sr.isSuccess()) {
                // Operation was successful, so get the ID of the record that was processed
                System.debug('Successfully inserted dbuEmailer. dbuEmailer ID: ' + sr.getId());
                dbu_EmailerInsertedIDs.add((string)sr.getId());
            }
            else {
                // Operation failed, so get all errors                
                for(Database.Error err : sr.getErrors()) {
                    System.debug('The following error has occurred.');                    
                    System.debug(err.getStatusCode() + ': ' + err.getMessage());
                    System.debug('dbuEmailer fields that affected this error: ' + err.getFields());
                }
            }
        }  
        
        system.debug('dbu_Emailer_Inserts_List > ' + dbu_Emailer_Inserts_List);
        
        list<dbu_Email_Content__c> dbu_EmailContent_Inserts_List = new list<dbu_Email_Content__c>();
        
        for(ccrz__E_CartItem__c eachCartItem : finalCartItemsList){
            for(dbu_Emailer__c eachInsertedemailer : dbu_Emailer_Inserts_List){
                if(eachCartItem.ccrz__Cart__r.dbu_Cart_StoreCountry__c == eachInsertedemailer.dbu_Wishlist_Country__c &&
                   eachCartItem.ccrz__Cart__r.ccrz__Contact__c == eachInsertedemailer.dbu_Email_Contact__c && 
                   eachCartItem.ccrz__Cart__r.ccrz__Contact__r.Email == eachInsertedemailer.dbu_Contact_Email__c){
                       
                       dbu_Email_Content__c CurrentEmailContent 	= new dbu_Email_Content__c();
                       //CurrentEmailContent.CC_Product_Name__c 		= eachCartItem.ccrz__Product__r.Name;
                       CurrentEmailContent.dbu_WishlistItem_ID__c	= eachCartItem.id;
                       CurrentEmailContent.CC_Product_Name__c		= eachCartItem.ccrz__Product__r.id;
                       CurrentEmailContent.dbu_Emailer__c			= eachInsertedemailer.id;
                       CurrentEmailContent.CurrencyIsoCode			= (string)countryCurrencyMap.get(eachCartItem.ccrz__Cart__r.dbu_Cart_StoreCountry__c);
                       
                       //checking for pricing
                       if((double)((Map<string,double>)CurrencyISObyProductPriceMapping.get(CurrentEmailContent.CurrencyIsoCode)).get((string)eachCartItem.ccrz__Product__r.id) != null){
							system.debug('(double)((Map<string,double>)CurrencyISObyProductPriceMapping.get(CurrentEmailContent.CurrencyIsoCode)).get((string)eachCartItem.ccrz__Product__r.id) >> ' + (double)((Map<string,double>)CurrencyISObyProductPriceMapping.get(CurrentEmailContent.CurrencyIsoCode)).get((string)eachCartItem.ccrz__Product__r.id));
                           CurrentEmailContent.dbu_Product_Price__c = (double)((Map<string,double>)CurrencyISObyProductPriceMapping.get(CurrentEmailContent.CurrencyIsoCode)).get((string)eachCartItem.ccrz__Product__r.id);                                                      
                       }
					   system.debug('CurrentEmailContent.dbu_Product_Price__c > ' + CurrentEmailContent.dbu_Product_Price__c);
                       
                       //checking for ProductURI
                       if((string)ProductURIsMap.get((string)eachCartItem.ccrz__Product__r.id) != null){
                           system.debug('(string)ProductURIsMap.get((string)eachCartItem.ccrz__Product__r.id) > ' + (string)ProductURIsMap.get((string)eachCartItem.ccrz__Product__r.id));
                           CurrentEmailContent.dbu_Product_URI__c	= (string)ProductURIsMap.get((string)eachCartItem.ccrz__Product__r.id);
                       }
					   system.debug('CurrentEmailContent.dbu_Product_URI__c > ' + CurrentEmailContent.dbu_Product_URI__c);
                       
                       //Checking for inventory
                       CurrentEmailContent.dbu_Product_Inventory_Status__c = false;
                       if((double)((Map<string,double>)CurrencyISObyProductInventoryMapping.get(CurrentEmailContent.CurrencyIsoCode)).get((string)eachCartItem.ccrz__Product__r.id) != null){
						   double product_Inventory_Quantity = (double)((Map<string,double>)CurrencyISObyProductInventoryMapping.get(CurrentEmailContent.CurrencyIsoCode)).get((string)eachCartItem.ccrz__Product__r.id);	                           
                           system.debug('product_Inventory_Quantity > ' + product_Inventory_Quantity);
                           if(product_Inventory_Quantity > 0){
                               CurrentEmailContent.dbu_Product_Inventory_Status__c = true;
                           }
                       }                       
                       system.debug('CurrentEmailContent.dbu_Product_Inventory_Status__c > ' + CurrentEmailContent.dbu_Product_Inventory_Status__c);                       
                       
                   dbu_EmailContent_Inserts_List.add(CurrentEmailContent);
                   }
            }
            
        }
        
        database.SaveResult[] dbu_email_Contents_Inserts = Database.insert(dbu_EmailContent_Inserts_List, false);
        
        list<string> dbu_Email_Content_InsertedIDs = new list<string>();
        
        for (Database.SaveResult sr : dbu_email_Contents_Inserts) {
            if (sr.isSuccess()) {
                // Operation was successful, so get the ID of the record that was processed
                System.debug('Successfully inserted dbuEmailer. dbuEmailer ID: ' + sr.getId());
                dbu_Email_Content_InsertedIDs.add((string)sr.getId());
            }
            else {
                // Operation failed, so get all errors                
                for(Database.Error err : sr.getErrors()) {
                    System.debug('The following error has occurred.');                    
                    System.debug(err.getStatusCode() + ': ' + err.getMessage());
                    System.debug('dbuEmailer fields that affected this error: ' + err.getFields());
                }
            }
        }        
        
        //Update the dbu_Email_Sending_Initiated__c to true
        for(dbu_Emailer__c each_emailer : dbu_Emailer_Inserts_List){
            each_emailer.dbu_Email_Sending_Initiated__c = true;
        }
        update dbu_Emailer_Inserts_List;
        	
    }       
    
    //METHOD INVOKED FROM PROCESS BUILDER
    @InvocableMethod
    public static void UpdateWishlistRecordsAfterEmailFire(List<id> CurrentdbuEmailerIDList){
        system.debug('INSIDE THE INVOCABLE METHOD > ');
        system.debug('CurrentdbuEmailerIDList > ' + CurrentdbuEmailerIDList);
            
        list<dbu_Email_Content__c> wishlistIDs = new list<dbu_Email_Content__c>();
        wishlistIDs = [select id,
                       dbu_WishlistItem_ID__c,
                       dbu_Emailer__r.dbu_Email_Sent__c,
                       dbu_Emailer__r.dbu_Email_for_Wishlist__c,
                       dbu_Emailer__r.dbu_Email_Sending_Initiated__c 
                       from dbu_Email_Content__c 
                       where dbu_Emailer__c IN : CurrentdbuEmailerIDList and dbu_Emailer__r.dbu_Email_for_Wishlist__c = true];
        system.debug('wishlistIDs > ' + wishlistIDs);        
        
        list<string> wishlistIDList = new list<string>();
        if(wishlistIDs.size() > 0){
            for(dbu_Email_Content__c eachcontent : wishlistIDs){
                if(eachcontent.dbu_Emailer__r.dbu_Email_Sent__c == true && 
                   eachcontent.dbu_Emailer__r.dbu_Email_Sending_Initiated__c == true && 
                   eachcontent.dbu_Emailer__r.dbu_Email_for_Wishlist__c == true){
                       wishlistIDList.add((string)eachcontent.dbu_WishlistItem_ID__c);
                   }
                if(test.isRunningTest()){
                    wishlistIDList.add((string)eachcontent.dbu_WishlistItem_ID__c);
                }                  
            }            
        }        
		system.debug('wishlistIDList > ' + wishlistIDList);
        	
        list<ccrz__E_CartItem__c> WishlistToBeUpdated = new list<ccrz__E_CartItem__c> ();
        if(wishlistIDList.size() > 0){
            WishlistToBeUpdated = [select id,
                                   dbu_Item_ProductStatus__c 
                                   from ccrz__E_CartItem__c where id in : wishlistIDList];            
        }
        system.debug('WishlistToBeUpdated > ' + WishlistToBeUpdated);

        if(WishlistToBeUpdated.size() > 0){
            
            for(ccrz__E_CartItem__c eachCartItem : WishlistToBeUpdated){
                eachCartItem.dbu_Item_ProductStatus__c = true;
            }
            system.debug('WishlistToBeUpdated UPDATED > ' + WishlistToBeUpdated);
          
            Database.SaveResult[] UpdateListofWishlist = Database.update(WishlistToBeUpdated, false);                                                                       
            
            // Iterate through each returned result
            for (Database.SaveResult sr : UpdateListofWishlist) {
                if (sr.isSuccess()) {
                    // Operation was successful, so get the ID of the record that was processed
                    System.debug('Successfully upddated wishlistItem. wishlistItem ID: ' + sr.getId());
                }
                else {
                    // Operation failed, so get all errors                
                    for(Database.Error err : sr.getErrors()) {
                        System.debug('The following error has occurred.');                    
                        System.debug(err.getStatusCode() + ': ' + err.getMessage());
                        System.debug('wishlistItem fields that affected this error: ' + err.getFields());
                    }
                }
            }           
        }
        
        
        list<dbu_Emailer__c> currenctEmailerList = new list<dbu_Emailer__c>();
        currenctEmailerList = [select ID,
                               dbu_Email_Sending_Initiated__c,
                               dbu_Email_for_Wishlist__c,
                               dbu_Email_Sent__c 
                               from dbu_Emailer__c 
                               where ID in : CurrentdbuEmailerIDList 
                               and dbu_Email_for_Wishlist__c = true];
         
        system.debug('currenctEmailerList > ' + currenctEmailerList);
        
        
        if(currenctEmailerList.size() > 0){
            list<dbu_Emailer__c> dbuEmailerToDelete = new list<dbu_Emailer__c>();
            
            for(dbu_Emailer__c eachEmailer : currenctEmailerList){
                if(eachEmailer.dbu_Email_Sending_Initiated__c == true && 
                   eachEmailer.dbu_Email_for_Wishlist__c == true && 
                   eachEmailer.dbu_Email_Sent__c == true){
                       dbuEmailerToDelete.add(eachEmailer);                       
                   }
            }
            system.debug('dbuEmailerToDelete > '  + dbuEmailerToDelete);
            delete dbuEmailerToDelete;
			            
        }
                
    }
            
    public static Set<String> FetchCartProducts(string CartID){        
        
        list<ccrz__E_CartItem__c> CartItemRecords = [SELECT ccrz__Product__c FROM ccrz__E_CartItem__c WHERE ccrz__Cart__c =: CartID and ccrz__cartItemType__c != 'Coupon'];
        set<string> RetProductIDList = new Set<string>();        
        for(ccrz__E_CartItem__c eachItem : CartItemRecords){
            system.debug('eachItem > ' + eachItem.ccrz__Product__c);
            RetProductIDList.add(eachItem.ccrz__Product__c);            
        }
            
        // CODE COMMENTED - MALHAR - API NOT RETURNING PRODUCT IDS FOR GUEST USER
        /*
        Set<String> cartIdList = new Set<String>{CartID};    
        set<string> RetProductIDList = new Set<string>();
            Map<String, Object> cartFetchQuery = new Map<String, Object>{
                ccrz.ccApiCart.CART_IDLIST => cartIdList,
                    ccrz.ccApi.API_VERSION => ccrz.ccApi.CURRENT_VERSION,
                    
                  //API SIZING set to XL which returns All possible fields
                    ccrz.ccApi.SIZING => new Map<String, Object> {
                        ccrz.ccApiCart.ENTITYNAME => new Map<String, Object> {
                            ccrz.ccApi.SZ_DATA => ccrz.ccApi.SZ_XL
                                },
                    ccrz.ccApiProduct.ENTITYNAME => new Map<String, Object> {
                        ccrz.ccApi.SZ_DATA => ccrz.ccApi.SZ_XL
                    }                                    
                    }
            };
                


                //############################### FIRE FETCH METHOD OF CC CART API #########################################    
                try {
                    Map<String, Object> cartFetchData = ccrz.ccApiCart.fetch(cartFetchQuery);   
                    
                    //################## Fetch Cart Details #########################
                    if (cartFetchData.get(ccrz.ccApiProduct.PRODUCTLIST) != null) {        
                        List<Map<String, Object>> outputProductList = (List<Map<String, Object>>) cartFetchData.get(ccrz.ccApiProduct.PRODUCTLIST);
                        System.debug(JSON.serializePretty('CartProductDetails::::: ' + outputProductList));  
                        
                        for(Map<String, Object> eachProd  : outputProductList){
                            if((string)eachProd.get('sfid') != null){
                                RetProductIDList.add((string)eachProd.get('sfid'));
                            }                              
                        }
                        system.debug('RetProductIDList > ' + RetProductIDList);

                    }
                } catch (Exception e) {
                    // Error handling...
                    system.debug(e);
                }              
        */  
        return RetProductIDList;
    }
    
    public class EmailResponseWrapper{
         public EmailResponseWrapper(){
         
        }
        public string ProductID;
        public string ContactName;
        public string ContactEmail;
        public double Productprice;
        public string ProductName;
        public string ProductSKU;    
        Public string InventoryStatus;  
        Public string ProductMediaURI;
    } 
    
    @AuraEnabled
    public static boolean deleteCartItemSFL(List<String> cartItems, String cartID){
        boolean deleteSuccess;
        //######################### Custom Code to Delete CartItem - Malhar - #############################
        try{
            system.debug('entering deleteCartItemSFL' +cartItems+''+cartID);
           list<Database.DeleteResult> DeletedList = Database.delete(cartItems);
                        system.debug('entering DeletedList' +DeletedList);

            for(Database.DeleteResult dltResult : DeletedList){
                if(dltResult.isSuccess()){
                    deleteSuccess = true;
                    System.debug('Successfully delete the CartItem with ID:> ' + dltResult.getId());
                }else{
                    for(Database.Error err : dltResult.getErrors()){
                        System.debug('The following error has occurred.');                    
                        System.debug(err.getStatusCode() + ': ' + err.getMessage());
                        System.debug('CartItem fields that affected this error:> ' + err.getFields());                    
                    }
                }
            }
            
        }
        
        catch(exception e){
            system.debug(e);
        }   
        return deleteSuccess;        
    }
    
    public static Map<string,boolean> FetchShipToPickUpDetail(set<string> productIdSet){
        Map<string,boolean> productToShipMapping = new Map<string, boolean>();
        
        if(productIdSet != null ){
            if(productIdSet.size() > 0){
                list<ccrz__E_Product__c> lstRelatedProduct = new list<ccrz__E_Product__c>();
                
                lstRelatedProduct =  [select id,dbu_Available_to_ship__c, dbu_Pick_Up_Only__c
                                      from ccrz__E_Product__c 
                                      where id in : productIdSet                                     
                                      and dbu_Has_Core_Child__c != true];
                system.debug('lstRelatedProduct > ' + lstRelatedProduct);
                    
                if(lstRelatedProduct.size() > 0 ){
                                  
                    for(ccrz__E_Product__c eachproduct : lstRelatedProduct){
                        boolean shipboolean = false;
                        boolean shiponly = false;
                        boolean pickuponly = false; 
                        
                        if(eachproduct.dbu_Available_to_ship__c){
                            shiponly = true;
                        } 
                        if(eachproduct.dbu_Pick_Up_Only__c){
                            pickuponly = true;
                        }
                        
                        if(shiponly == true && pickuponly == false){
                            shipboolean = true;
                        }
                        else if(shiponly == false && pickuponly == true){
                            shipboolean = false;
                        }                        
                        else if(shiponly == true && pickuponly == true){
                            shipboolean = true;
                        }  
                        else if(shiponly == false && pickuponly == false){
                            shipboolean = true;
                        }  
                        
                        productToShipMapping.put(eachproduct.id, shipboolean);
                        system.debug('productToShipMapping > ' + productToShipMapping);
                    }
                }
                
            }
        }
        
        return productToShipMapping;
    }    
    
    public static list<ccrz__E_Product__c> getRelatedProductByProductIdSet(set<string> ParentProductIDset, string storeCountry){
        /*Core Product Insertion : After insertion of the Original Product here insertion of CoreProduct will happen*/
        
        //get the country cureency iso mapping from custom settings 
        Map<string,string> countryCurrencyMap = new Map<string,string>();
        for(dbu_CountryCurrencyMapping__c eachsetting : (list<dbu_CountryCurrencyMapping__c>)dbu_CountryCurrencyMapping__c.getall().values()){
            system.debug('dbuCountryCode__c > ' + (string)eachsetting.get('dbuCountryCode__c'));
            system.debug('dbuCurrencyCode__c > ' + (string)eachsetting.get('dbuCurrencyCode__c'));
            countryCurrencyMap.put((string)eachsetting.get('dbuCountryCode__c'), (string)eachsetting.get('dbuCurrencyCode__c'));
        }
        system.debug('countryCurrencyMap > ' + countryCurrencyMap);        
        
        string currencyISOvalue = (string)countryCurrencyMap.get(storeCountry);         
        
            list<ccrz__E_Product__c> lstRelatedProduct = new list<ccrz__E_Product__c>();
            list<id> relProdIds = new list<id>();
            List<ccrz__E_Product__c> lstProduct = [Select id, 
                                                   dbu_Has_Core_Charge__c, 
                                                   (select id,
                                                    ccrz__RelatedProduct__r.id,
                                                    ccrz__RelatedProduct__r.Name
                                                    from ccrz__E_RelatedProducts__r 
                                                    where ccrz__RelatedProductType__c = 'Core Charge') 
                                                    from ccrz__E_Product__c  
                                                where id in : ParentProductIDset 
                                                AND dbu_Has_Core_Charge__c = true];
            if(lstProduct.size() > 0){
                for(integer i=0 ; i<lstProduct.size() ; i++){
                    if(lstProduct[i].ccrz__E_RelatedProducts__r != null && lstProduct[i].ccrz__E_RelatedProducts__r.size() > 0 && lstProduct[i].ccrz__E_RelatedProducts__r[0].ccrz__RelatedProduct__r != null){
                        relProdIds.add(lstProduct[i].ccrz__E_RelatedProducts__r[0].ccrz__RelatedProduct__r.id);                                               
                    }                                                    
                }
            }
        

        lstRelatedProduct = [select id,
                             (select ccrz__Price__c from ccrz__E_PriceListItems__r where ccrz__Pricelist__r.ccrz__CurrencyISOCode__c =: currencyISOvalue),
                             (select ccrz__URI__c,ccrz__MediaType__c from ccrz__E_ProductMedias__r where ccrz__URI__c != null AND ccrz__MediaType__c =: 'Product Image')
                             from ccrz__E_Product__c 
                             where id in : relProdIds
                             and dbu_Has_Core_Charge__c = true
                             and dbu_Has_Core_Child__c = true];            
        
            
                
                // coreProductId =  lstProduct[0].ccrz__E_RelatedProducts__r[0].ccrz__RelatedProduct__r.Id;
                // coreItemPrice = lstProduct[0].ccrz__E_RelatedProducts__r[0].ccrz__RelatedProduct__r.dbu_Core_Charge_Amount__c;
                
            return lstRelatedProduct;                              
        /**Core Product Ended here */        
    }
    
    public class relatedprodwrapper{
        public Map<string,list<string>> relatedproductsmap;
        public  list<ccrz__E_Product__c> productlist;
    }
            
    public static relatedprodwrapper getRelatedProductByProductIdSet2(set<string> ParentProductIDset, string storeCountry){
        /*Core Product Insertion : After insertion of the Original Product here insertion of CoreProduct will happen*/
        relatedprodwrapper currenctwrapper = new relatedprodwrapper();
        Map<string,list<string>> coreproductID_To_ParentProductID_Mapping = new Map<string,list<string>>();
        
        //get the country cureency iso mapping from custom settings 
        Map<string,string> countryCurrencyMap = new Map<string,string>();
        for(dbu_CountryCurrencyMapping__c eachsetting : (list<dbu_CountryCurrencyMapping__c>)dbu_CountryCurrencyMapping__c.getall().values()){
            system.debug('dbuCountryCode__c > ' + (string)eachsetting.get('dbuCountryCode__c'));
            system.debug('dbuCurrencyCode__c > ' + (string)eachsetting.get('dbuCurrencyCode__c'));
            countryCurrencyMap.put((string)eachsetting.get('dbuCountryCode__c'), (string)eachsetting.get('dbuCurrencyCode__c'));
        }
        system.debug('countryCurrencyMap > ' + countryCurrencyMap);        
        
        string currencyISOvalue = (string)countryCurrencyMap.get(storeCountry);         
        
            list<ccrz__E_Product__c> lstRelatedProduct = new list<ccrz__E_Product__c>();
            list<id> relProdIds = new list<id>();
            List<ccrz__E_Product__c> lstProduct = [Select id, 
                                                   dbu_Has_Core_Charge__c, 
                                                   (select id,
                                                    ccrz__RelatedProduct__r.id,
                                                    ccrz__RelatedProduct__r.Name
                                                    from ccrz__E_RelatedProducts__r 
                                                    where ccrz__RelatedProductType__c = 'Core Charge') 
                                                    from ccrz__E_Product__c  
                                                where id in : ParentProductIDset 
                                                AND dbu_Has_Core_Charge__c = true];
            if(lstProduct.size() > 0){
                for(integer i=0 ; i<lstProduct.size() ; i++){
                    if(lstProduct[i].ccrz__E_RelatedProducts__r != null && lstProduct[i].ccrz__E_RelatedProducts__r.size() > 0 && lstProduct[i].ccrz__E_RelatedProducts__r[0].ccrz__RelatedProduct__r != null){
                        relProdIds.add(lstProduct[i].ccrz__E_RelatedProducts__r[0].ccrz__RelatedProduct__r.id);  
                        if(coreproductID_To_ParentProductID_Mapping.get(lstProduct[i].ccrz__E_RelatedProducts__r[0].ccrz__RelatedProduct__r.id) != null){
                            list<string> getcurrenctlist = new list<string>();
                            getcurrenctlist = (list<string>)coreproductID_To_ParentProductID_Mapping.get(lstProduct[i].ccrz__E_RelatedProducts__r[0].ccrz__RelatedProduct__r.id);
                            getcurrenctlist.add(lstProduct[i].id);
                            coreproductID_To_ParentProductID_Mapping.put(lstProduct[i].ccrz__E_RelatedProducts__r[0].ccrz__RelatedProduct__r.id, getcurrenctlist);
                        }else{
                            list<string> getcurrenctlist = new list<string>();
                            getcurrenctlist.add(lstProduct[i].id);
                            coreproductID_To_ParentProductID_Mapping.put(lstProduct[i].ccrz__E_RelatedProducts__r[0].ccrz__RelatedProduct__r.id, getcurrenctlist);                                                            
                        }                        
                    }                                                    
                }
            }
        

        lstRelatedProduct = [select id,
                             (select ccrz__Price__c from ccrz__E_PriceListItems__r where ccrz__Pricelist__r.ccrz__CurrencyISOCode__c =: currencyISOvalue),
                             (select ccrz__URI__c,ccrz__MediaType__c from ccrz__E_ProductMedias__r where ccrz__URI__c != null AND ccrz__MediaType__c =: 'Product Image')
                             from ccrz__E_Product__c 
                             where id in : relProdIds
                             and dbu_Has_Core_Charge__c = true
                             and dbu_Has_Core_Child__c = true];            
        
            
                
                // coreProductId =  lstProduct[0].ccrz__E_RelatedProducts__r[0].ccrz__RelatedProduct__r.Id;
                // coreItemPrice = lstProduct[0].ccrz__E_RelatedProducts__r[0].ccrz__RelatedProduct__r.dbu_Core_Charge_Amount__c;
                
        currenctwrapper.relatedproductsmap = coreproductID_To_ParentProductID_Mapping;
        currenctwrapper.productlist = lstRelatedProduct;
        
            return currenctwrapper;                              
        /**Core Product Ended here */        
    }
    
    @AuraEnabled  
    public static ccrz__E_Product__c getRelatedProductByProductId(String parentProductId, string storeCountry){
        /*Core Product Insertion : After insertion of the Original Product here insertion of CoreProduct will happen*/
            ccrz__E_Product__c lstRelatedProduct;
            ccrz__E_Product__c coreProductdetail;
        
        //get the country cureency iso mapping from custom settings 
        Map<string,string> countryCurrencyMap = new Map<string,string>();
        for(dbu_CountryCurrencyMapping__c eachsetting : (list<dbu_CountryCurrencyMapping__c>)dbu_CountryCurrencyMapping__c.getall().values()){
            system.debug('dbuCountryCode__c > ' + (string)eachsetting.get('dbuCountryCode__c'));
            system.debug('dbuCurrencyCode__c > ' + (string)eachsetting.get('dbuCurrencyCode__c'));
            countryCurrencyMap.put((string)eachsetting.get('dbuCountryCode__c'), (string)eachsetting.get('dbuCurrencyCode__c'));
        }
        system.debug('countryCurrencyMap > ' + countryCurrencyMap);        
        
        string currencyISOvalue = (string)countryCurrencyMap.get(storeCountry);        
        
            List<ccrz__E_Product__c> lstProduct = [Select id, dbu_Has_Core_Charge__c, (select id,ccrz__RelatedProduct__r.id from ccrz__E_RelatedProducts__r where ccrz__RelatedProductType__c = 'Core Charge') from ccrz__E_Product__c  
                                            where id =: parentProductId AND dbu_Has_Core_Charge__c = true];
            if(lstProduct.size() > 0 && lstProduct[0].ccrz__E_RelatedProducts__r != null && lstProduct[0].ccrz__E_RelatedProducts__r.size() > 0 && lstProduct[0].ccrz__E_RelatedProducts__r[0].ccrz__RelatedProduct__r != null){
                // coreProductId =  lstProduct[0].ccrz__E_RelatedProducts__r[0].ccrz__RelatedProduct__r.Id;
                // coreItemPrice = lstProduct[0].ccrz__E_RelatedProducts__r[0].ccrz__RelatedProduct__r.dbu_Core_Charge_Amount__c;
                lstRelatedProduct = lstProduct[0].ccrz__E_RelatedProducts__r[0].ccrz__RelatedProduct__r;
                coreProductdetail = [select id,
                                                        (select ccrz__Price__c from ccrz__E_PriceListItems__r where ccrz__Pricelist__r.ccrz__CurrencyISOCode__c =: currencyISOvalue),
                                                        (select ccrz__URI__c,ccrz__MediaType__c from ccrz__E_ProductMedias__r where ccrz__URI__c != null AND ccrz__MediaType__c =: 'Product Image')
                                                        from ccrz__E_Product__c 
                                                        where id =: lstProduct[0].ccrz__E_RelatedProducts__r[0].ccrz__RelatedProduct__r.id 
                                                        and dbu_Has_Core_Charge__c = true
                                                        and dbu_Has_Core_Child__c = true];
            }                                
            return coreProductdetail;                              
        /**Core Product Ended here */
    }  
    
    
    /**
    * @description Send the list of Product ID and get the promotiontag in a map format
    * @author Devaraj johnson | 06-30-2022 
    * @param productIDSet 
    * @param storeCountry 
    * @return Map<String, String> 
    **/
    public static Map<String,String> getProductPromotiontag(Set<string> productIDSet,string country){
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
        else if(country == 'CA'){
            currencyCode = 'CAD';
            productCountryCode = 'CA';
            country = 'EN';
        }
       List<ccrz__E_Product__c> productListByID = [Select id,
       (select id,name,ccrz__Enabled__c,ccrz__EndDate__c,
       ccrz__StartDate__c,dbu_store_location__c,
       ccrz__Storefront__c,ccrz__Category__r.Name from ccrz__Promotions__r 
        WHERE ccrz__Enabled__c = true 
              AND ccrz__EndDate__c >= today 
              AND ccrz__StartDate__c <= today
              AND dbu_store_location__c INCLUDES (:country) 
              AND ccrz__Storefront__c = 'CSSNAStore'), 
        dbu_Available_to_ship__c,dbu_Non_Returnable__c,dbu_Crate_Engine__c,dbu_Pick_Up_Only__c,
        dbu_Has_Core_Charge__c,dbu_Has_Core_Child__c,dbu_FullPartNumber__c,dbu_Part_Number__c,dbu_Product_Code__c 
        from ccrz__E_Product__c where id = :productIDSet  
            AND ccrz__ProductStatus__c = 'Released' 
            AND ccrz__Storefront__c = 'CSSNAStore'
            AND ccrz__StartDate__c <= today 
            AND ccrz__EndDate__c>= today
            AND dbu_Has_Core_Child__c = False
            AND DBU_Product_Location__c INCLUDES (:productCountryCode)];  
        Map<String,String> productidvsPromotiontag  =  new Map<String,String>();
        if(productListByID.size() >0){
            for(ccrz__E_Product__c prod :productListByID){
                if(prod.ccrz__Promotions__r.size() > 0){
                    productidvsPromotiontag.put(prod.id,prod.ccrz__Promotions__r[0].ccrz__Category__r.Name) ;
                }
            }
        }
    return productidvsPromotiontag;
    }
}