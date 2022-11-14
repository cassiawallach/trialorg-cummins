public without sharing class dbu_SaveForLatetGeneric {

    @AuraEnabled(cacheable=true)
    public static List<dbu_SaveForLaterWrapper> fetchProductDetailsByProductID(string ProductIDList, string storeCountry){
        
        list<dbu_SaveForLaterWrapper> SaveForLaterResponse = new list<dbu_SaveForLaterWrapper>();          
        
        list<object> ProductIDS = (list<object>)JSON.deserializeUntyped(ProductIDList);
        system.debug('ProductIDSet :: ' + ProductIDS);
         
        set<string> ProductIDSet= new set<string>();
        for(object o : ProductIDS){
            ProductIDSet.add(string.valueOf(o));
        }
        
        
        //get the country cureency iso mapping from custom settings
        Map<string,string> countryCurrencyMap = new Map<string,string>();
        for(dbu_CountryCurrencyMapping__c eachsetting : (list<dbu_CountryCurrencyMapping__c>)dbu_CountryCurrencyMapping__c.getall().values()){
            system.debug('dbuCountryCode__c > ' + (string)eachsetting.get('dbuCountryCode__c'));
            system.debug('dbuCurrencyCode__c > ' + (string)eachsetting.get('dbuCurrencyCode__c'));
            countryCurrencyMap.put((string)eachsetting.get('dbuCountryCode__c'), (string)eachsetting.get('dbuCurrencyCode__c'));
        }
        system.debug('countryCurrencyMap > ' + countryCurrencyMap);   
        string CurrencyISOcodeValue = (string)countryCurrencyMap.get(storeCountry);
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
        Map<string,string> BrandMap = dbu_ProductCtrl.getBrandfromproductid(ProductIDSet,locationcode);
       //END CECI-958
        

        system.debug(ProductIDSet);
        
        
        
        //GET RELATED PRODUCT FOR CORECHARGE
        set<ccrz__E_RelatedProduct__c> relProducts = new set<ccrz__E_RelatedProduct__c>(
         [select ccrz__RelatedProduct__r.id from ccrz__E_RelatedProduct__c 
                       where ccrz__Product__c in : ProductIDSet and ccrz__RelatedProductType__c = 'Core Charge' 
                       and ccrz__Product__r.DBU_Product_Location__c includes (:storeCountry) and ccrz__RelatedProduct__r.dbu_Has_Core_Child__c = true]);
                
        system.debug('relProducts > ' + relProducts);
        
        //CHECK FOR INVENTORY
        Map<string,double> productInventorymapping = new Map<string,double>();
        list<AggregateResult> productInventory = new list<AggregateResult>();
        productInventory = [select SUM(ccrz__QtyAvailable__c) TOTALQUANTITY, ccrz__ProductItem__c PRODUCTID
                            from ccrz__E_ProductInventoryItem__c 
                            where ccrz__ProductItem__c IN : ProductIDSet 
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
        
        
        if(relProducts.size() > 0){
            //store related corecharge product id
            set<string> relatedProductsIdsetcorecharge = new set<string>();
            for(ccrz__E_RelatedProduct__c rel : relProducts){
                system.debug('rel > ' + rel.ccrz__RelatedProduct__r.id);
                relatedProductsIdsetcorecharge.add((string)rel.ccrz__RelatedProduct__r.id);
            }
            system.debug('relatedProductsIdsetcorecharge > ' + relatedProductsIdsetcorecharge);            
            
            //Get core products not having product location         
            list<ccrz__E_Product__c> coreProductsWithoutLocation = new list<ccrz__E_Product__c>();
            coreProductsWithoutLocation = [select id, Name, (select ccrz__Price__c  from ccrz__E_PriceListItems__r where ccrz__Pricelist__r.ccrz__CurrencyISOCode__c =: CurrencyISOcodeValue),(select ccrz__URI__c,ccrz__MediaType__c from ccrz__E_ProductMedias__r where ccrz__URI__c != null AND ccrz__MediaType__c =: 'Product Image') from ccrz__E_Product__c where dbu_Has_Core_Charge__c = true and dbu_Has_Core_Child__c = true and id in : relatedProductsIdsetcorecharge]; 
                                    
            system.debug('coreProductsWithoutLocation > ' + coreProductsWithoutLocation);
            
         
            
            //Remove the core product from Original list 
            for(ccrz__E_Product__c rel : coreProductsWithoutLocation){
                if(ProductIDSet.contains(rel.Id)){
                    ProductIDSet.remove(rel.Id);
                }

                
                dbu_SaveForLaterWrapper eachcoreProductDetailInstance = new dbu_SaveForLaterWrapper();
                eachcoreProductDetailInstance.ProductID         = rel.Id; 
                if(Test.isRunningTest() == true){
                    eachcoreProductDetailInstance.ProductName       = 'Testcoreprodct';
                    eachcoreProductDetailInstance.ProductURL        = 'https://www.cssna-parts.com';
                    eachcoreProductDetailInstance.ProductPrice      = 99;                           
                    eachcoreProductDetailInstance.IsCrateProductCheck = false;
                    eachcoreProductDetailInstance.IsCoreProductcheck = true;     
                    eachcoreProductDetailInstance.ProductQuantity = 1;
                    eachcoreProductDetailInstance.inventoryQuantity = 1;
                }else{
                    eachcoreProductDetailInstance.ProductName       = rel.Name;
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
                    //eachcoreProductDetailInstance.ProductURL          = rel.ccrz__E_ProductMedias__r[0].ccrz__URI__c;
                    //eachcoreProductDetailInstance.ProductPrice        = rel.ccrz__E_PriceListItems__r[0].ccrz__Price__c;                           
                    eachcoreProductDetailInstance.IsCrateProductCheck = false;
                    eachcoreProductDetailInstance.IsCoreProductcheck = true;     
                    eachcoreProductDetailInstance.ProductQuantity = 1;
                    eachcoreProductDetailInstance.inventoryQuantity = 1;                    
                }

                SaveForLaterResponse.add(eachcoreProductDetailInstance);
            }            
            
        }

        
        
        if(ProductIDSet.size() > 0){
            //Formulate Input Data for CC PriceList & CC Product APIs
            Map<String,String>  productvsPromotionTag = dbu_CallCCWishListApi.getProductPromotiontag(ProductIDSet,storeCountry);
            list<ccrz__E_PriceListItem__c> pricedata = dbu_homePageCategoryTileCtrl.fetchPriceBySearchResult(ProductIDSet,storeCountry);
            map<String,ccrz__E_PriceListItem__c> originalPriceMap = new map<String,ccrz__E_PriceListItem__c> ();
            for(ccrz__E_PriceListItem__c priceLstItem: pricedata){
                originalPriceMap.put(priceLstItem.ccrz__Product__c,priceLstItem);
            }
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
                                        ccrz.ccApiPriceList.CURRCODE => CurrencyISOcodeValue,
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
                                                //system.debug('ProductName :: ' + ProductName);   
                                                
                                                string ProductID = (string)eachProductdetail.get('sfid');
                                                //system.debug('ProductID :: ' + ProductID);   
                                                
                                                //logic for corecharge product
                                                boolean isCoreCharge = false;
                                                
                                                String ProductURI;
                                                if((list<Map<string,object>>)eachProductdetail.get('EProductMediasS') != null){
                                                    //ProductURI = (string)(((list<Map<string,object>>)eachProductdetail.get('EProductMediasS'))[0]).get('URI'); 
                                                    set<string> ProductURILinksList = new set<string>();
                                                    for(integer i=0; i< ((list<Map<string,object>>)eachProductdetail.get('EProductMediasS')).size() ; i++){                                                                
                                                        if((string)(((list<Map<string,object>>)eachProductdetail.get('EProductMediasS'))[i]).get('mediaType')=='Product Image'){
                                                        //ProductURILinksList.add((string)(((list<Map<string,object>>)eachProductdetail.get('EProductMediasS'))[i]).get('URI')); 
                                                        ProductURI = (string)(((list<Map<string,object>>)eachProductdetail.get('EProductMediasS'))[i]).get('URI');  
                                                        Break;
                                                        } 
                                                    }                                                    
                                                }

                                                //system.debug('ProductURILinksList :: '  + ProductURILinksList);                            
                                                
                                                decimal ProductPrice;
                                                if(ProductPriceMap != null){
                                                    if((ProductPriceMap.keyset()).contains(ProductID)){
                                                        ProductPrice = (decimal)ProductPriceMap.get(ProductID);
                                                        //system.debug('retrived price : '+ ProductPrice);
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
                                                eachProductDetailInstance.ProductID    = ProductID; 
                                                eachProductDetailInstance.ProductName  = ProductName;
                                                eachProductDetailInstance.ProductURL   = ProductURI;
                                                eachProductDetailInstance.ProductPrice = ProductPrice;
                                                eachProductDetailInstance.IsCrateProductCheck = IsCrateEngine;
                                                eachProductDetailInstance.IsCoreProductcheck = isCoreCharge;
                                                eachProductDetailInstance.inventoryQuantity = inventoryQuantity;
                                                eachProductDetailInstance.stockstatus = stockstatus;
                                                eachProductDetailInstance.promotionTag = productvsPromotionTag.get(ProductID);
                                                eachProductDetailInstance.originalPrice =originalPrice;
                                                eachProductDetailInstance.discountPercentage = discountPercentage;
                                                eachProductDetailInstance.ProductSKU  =   ProductSKU;//Added CECI-958
                                                eachProductDetailInstance.Brandname= Brandname;//Added CECI-958
                                                eachProductDetailInstance.Categoryname=Categoryname;//Added CECI-958
                                                
                                                SaveForLaterResponse.add(eachProductDetailInstance);
                                                //list<object> eachDetail = new  list<object>{ProductName, ProductURILinksList, ProductPrice};
                                                
                                                //ProductDetail.put(ProductID, eachDetail);
                                                
                                                
                                            }
                                        }
                                        
                                        //############### MAP CONTAINER TO HOLD PRODUCT NAME, PRICE, URIS ##########################                
                                        system.debug('saveforlater_Response :: ' + SaveForLaterResponse);
                                        
                                        
                                    }catch(exception ex){
                                        system.debug('Exception ex' + ex);
                                    }              
        }                     
        
        return SaveForLaterResponse;
    }
    
    @AuraEnabled
    public static List<dbu_SaveForLaterWrapper> AddProductTo_WishList_or_SaveForLater_forLoggedInUser(string ProductId, string storeCountry, string ProductQuantity ,string dbu_SFL_OR_WL_Value, string storeLanguage){
        system.debug('entering the apex method' +ProductId +''+dbu_SFL_OR_WL_Value);
        String userType = UserInfo.getUserType();
        
        string userID = UserInfo.getUserID();
        //string userID = '00519000003F8rm';
        list<dbu_SaveForLaterWrapper> ProductAddToResponse;
        
        if (userType != 'Guest' && userID != null) {            
            system.debug('loggedIN User');
            
            //################## Get Contact Details from loggedIn user            
            
            //userID = '0053C000003Qsnl';
            
            Map<String, Object> UserAPIInputData = new Map<String,Object>{
                ccrz.ccApi.API_VERSION => ccrz.ccApi.CURRENT_VERSION,
                    ccrz.ccApi.SIZING => new Map<String, Object> { 
                        ccrz.ccApiUser.ENTITYNAME => new Map<String, Object> { 
                            ccrz.ccApi.SZ_DATA => ccrz.ccApi.SZ_S
                                }
                    },
                        ccrz.ccApiUser.USER_ID => userID          
                        };
                            
                            try{
                                //######################### Fetch Current User Details ####################################
                                Map<string,object> UserAPIResponse = ccrz.ccApiUser.fetch(UserAPIInputData);     
                                system.debug('SUCCESS FLAG : : ' +  (Boolean)UserAPIResponse.get(ccrz.ccApi.SUCCESS));
                                
                                if(UserAPIResponse.get(ccrz.ccApiUser.USERLIST) != null){
                                    List<Map<String, Object>> UserRetrivedList = (List<Map<String, Object>>)UserAPIResponse.get(ccrz.ccApiUser.USERLIST);
                                    system.debug('UserRetrivedList :: ' + UserRetrivedList);
                                    
                                    //##################### Get Contact ID for the same User ##############################
                                    string contactID = (string)UserRetrivedList[0].get('contactId');                                    
                                    system.debug('contactID >' + contactID);
                                    
                                    //##################### Check whether Wishlist exist for current User #################
                                    list<ccrz__E_Cart__c> defaultWishlistIDForCurrentContact = new list<ccrz__E_Cart__c>();
                                    defaultWishlistIDForCurrentContact = [select id from ccrz__E_Cart__c where ccrz__CartType__c =: 'WishList' And dbu_Cart_StoreCountry__c =: storeCountry And ccrz__Contact__c =: contactID and ccrz__CartStatus__c =: 'Open' and ccrz__ActiveCart__c = false];
                                    system.debug('defaultWishlistIDForCurrentContact >> ' + defaultWishlistIDForCurrentContact); 
                                    string currentContactWishlistID; 
                                    
                                    if(defaultWishlistIDForCurrentContact.isEmpty()){
                                        system.debug('No wishlist found for the current contact');
                                        
                                        //############ Call Logic to create a wishlist for the current contact ############
                                        currentContactWishlistID = dbu_CallCCWishListApi.createDefaultWishlist(contactID, storeCountry, storeLanguage);
                                        
                                        system.debug('wishlist created >>>>>>>');
                                        //Add Product to the wishlist as Save for Later or Wishlist                                        
                                        if(dbu_SFL_OR_WL_Value == 'WishList'){
                                            system.debug('In the wishlist if loop');
                                            
                                            //check if the Product is an core product or not.                                            
                                            ccrz__E_Product__c relatedCoreProduct = dbu_CallCCWishListApi.getRelatedProductByProductId(ProductId, storeCountry);                                            
                                            
                                            //Add Product & Return the Product URI , NAME AND PRICING
                                            ProductAddToResponse = dbu_CallCCWishListApi.AddToDefaultWishlist(currentContactWishlistID, ProductId, dbu_SFL_OR_WL_Value, ProductQuantity, storeCountry);
                                            list<dbu_SaveForLaterWrapper> coreProductAddToResponse = new list<dbu_SaveForLaterWrapper>();
                                             coreProductAddToResponse = dbu_CallCCWishListApi.AddToDefaultWishlist(currentContactWishlistID, (string)relatedCoreProduct.Id, dbu_SFL_OR_WL_Value, '1', storeCountry);
                                            system.debug('coreProductAddToResponse wishlist for new WL> ' + coreProductAddToResponse);
                                            
                                        }else if(dbu_SFL_OR_WL_Value == 'Save For Later'){
                                            system.debug('In the save for later if loop');
                                            
                                            //check if the Product is an core product or not.                                            
                                            ccrz__E_Product__c relatedCoreProduct = dbu_CallCCWishListApi.getRelatedProductByProductId(ProductId, storeCountry);                                            
                                            
                                            //Add Product & Return the Product URI , NAME AND PRICING                                            
                                            ProductAddToResponse = dbu_CallCCWishListApi.AddToDefaultWishlist(currentContactWishlistID, ProductId, dbu_SFL_OR_WL_Value, ProductQuantity, storeCountry);
                                            list<dbu_SaveForLaterWrapper> coreProductAddToResponse = new list<dbu_SaveForLaterWrapper>();
                                             coreProductAddToResponse = dbu_CallCCWishListApi.AddToDefaultWishlist(currentContactWishlistID, (string)relatedCoreProduct.Id, dbu_SFL_OR_WL_Value, '1', storeCountry);
                                            system.debug('coreProductAddToResponse saveforlater for new WL > ' + coreProductAddToResponse);                                                
                                        }
                                                                                
                                        
                                    }else{                                        
                                        system.debug('wishlist found for the current contact');
                                        
                                        //########### Get get Default Wishlist for the current User #######################
                                        currentContactWishlistID = string.valueof(defaultWishlistIDForCurrentContact[0].id);
                                        
                                        //Check if Prpduct already exist in the user's default wishlist as Wishlist or saveforlater
                                        //set<string> prodIdSet = new set<string>();
                                        //prodIdSet.add(productid);
                                        //boolean IfProductExist = dbu_CallCCWishListApi.IfProductInDefaultWishlist(currentContactWishlistID , ProductId, dbu_SFL_OR_WL_Value);
                                        //system.debug('IfProductExist :: ' + IfProductExist);

                                        //Add Product to the wishlist as Save for Later or Wishlist                                        
                                        if(dbu_SFL_OR_WL_Value == 'WishList'){
                                            //Add Product & Return the Product URI , NAME AND PRICING
                                            
                                            //check if the Product is an core product or not.                                            
                                            ccrz__E_Product__c relatedCoreProduct = dbu_CallCCWishListApi.getRelatedProductByProductId(ProductId, storeCountry);                                            
                                            
                                            ProductAddToResponse = dbu_CallCCWishListApi.AddToDefaultWishlist(currentContactWishlistID, ProductId, dbu_SFL_OR_WL_Value, ProductQuantity, storeCountry);
                                            list<dbu_SaveForLaterWrapper> coreProductAddToResponse = new list<dbu_SaveForLaterWrapper>();
                                            coreProductAddToResponse = dbu_CallCCWishListApi.AddToDefaultWishlist(currentContactWishlistID, (string)relatedCoreProduct.Id, dbu_SFL_OR_WL_Value, '1', storeCountry);
                                            system.debug('coreProductAddToResponse wishlist for existing WL > ' + coreProductAddToResponse);                                               
                                            
                                        }else if(dbu_SFL_OR_WL_Value == 'Save For Later'){
                                            //Add Product & Return the Product URI , NAME AND PRICING
                                            
                                            //check if the Product is an core product or not.                                            
                                            ccrz__E_Product__c relatedCoreProduct = dbu_CallCCWishListApi.getRelatedProductByProductId(ProductId, storeCountry);                                            
                                            
                                            ProductAddToResponse = dbu_CallCCWishListApi.AddToDefaultWishlist(currentContactWishlistID, ProductId, dbu_SFL_OR_WL_Value, ProductQuantity, storeCountry);
                                            list<dbu_SaveForLaterWrapper> coreProductAddToResponse = new list<dbu_SaveForLaterWrapper>();
                                             coreProductAddToResponse = dbu_CallCCWishListApi.AddToDefaultWishlist(currentContactWishlistID, (string)relatedCoreProduct.Id, dbu_SFL_OR_WL_Value, '1', storeCountry);
                                            system.debug('coreProductAddToResponse saveforlater for existing WL > ' + coreProductAddToResponse);
                                            
                                        }                                        
                                        
                                    }                                    
                                    
                                }
                            }catch(Exception e){
                                system.debug('Exception : : ' + e);
                                system.debug('exception stacktrace > ' + e.getStackTraceString());
                                system.debug('exp  linenum > ' + e.getLineNumber());
                                system.debug('exp  msg > ' + e.getMessage());
                                system.debug('exp  msg > ' + e.getTypeName());
                            }

        }
        return ProductAddToResponse;
    }
    
    @AuraEnabled
    public static List<dbu_SaveForLaterWrapper> fetchLoggedInUserWishlistItems( string dbu_SFL_OR_WL_Value, string storeCountry, string storeLanguage ){
        
        system.debug('entering to the fetchwishlistiotems method>>>' +dbu_SFL_OR_WL_Value);
        String userType = UserInfo.getUserType();
        
        //string userID = '00519000003F8rm';
        //string userID = '00519000003F8rm';
        string userID = UserInfo.getUserID();
        
                
        list<dbu_SaveForLaterWrapper> ProductDetails;
        
        if (userType != 'Guest' && userID != null) {            
            system.debug('loggedIN User');
            

            //################## Get Contact Details from loggedIn user            
            
            //userID = '0053C000003Qsnl';
            
            Map<String, Object> UserAPIInputData = new Map<String,Object>{
                ccrz.ccApi.API_VERSION => ccrz.ccApi.CURRENT_VERSION,
                    ccrz.ccApi.SIZING => new Map<String, Object> { 
                        ccrz.ccApiUser.ENTITYNAME => new Map<String, Object> { 
                            ccrz.ccApi.SZ_DATA => ccrz.ccApi.SZ_S
                                }
                    },
                        ccrz.ccApiUser.USER_ID => userID          
                        };
                            
                            
                            try{
                                //######################### Fetch Current User Details ####################################
                                Map<string,object> UserAPIResponse = ccrz.ccApiUser.fetch(UserAPIInputData);     
                                system.debug('SUCCESS FLAG : : ' +  (Boolean)UserAPIResponse.get(ccrz.ccApi.SUCCESS));
                                
                                if(UserAPIResponse.get(ccrz.ccApiUser.USERLIST) != null){
                                    List<Map<String, Object>> UserRetrivedList = (List<Map<String, Object>>)UserAPIResponse.get(ccrz.ccApiUser.USERLIST);
                                    system.debug('UserRetrivedList :: ' + UserRetrivedList);
                                    
                                    //##################### Get Contact ID for the same User ##############################
                                    string contactID = (string)UserRetrivedList[0].get('contactId');
                                    system.debug('contactID >' + contactID);
                                    
                                    //##################### Check whether Wishlist exist for current User #################
                                    list<ccrz__E_Cart__c> defaultWishlistIDForCurrentContact = new list<ccrz__E_Cart__c>();
                                     defaultWishlistIDForCurrentContact = [select id from ccrz__E_Cart__c where ccrz__CartType__c =: 'WishList' and dbu_Cart_StoreCountry__c =: storeCountry And ccrz__Contact__c =: contactID and ccrz__CartStatus__c =: 'Open' and ccrz__ActiveCart__c = false];
                                    system.debug('defaultWishlistIDForCurrentContact >> ' + defaultWishlistIDForCurrentContact); 
                                    string currentContactWishlistID; 
                                    
                                    if(defaultWishlistIDForCurrentContact.isEmpty()){
                                        system.debug('No wishlist found for the current contact');
                                        
                                        //############ Call Logic to create a wishlist for the current contact ############
                                        currentContactWishlistID = dbu_CallCCWishListApi.createDefaultWishlist(contactID, storeCountry, storeLanguage);
                                        

                                    }else{                                        
                                        system.debug('wishlist found for the current contact');
                                        
                                        //########### Get get Default Wishlist for the current User #######################
                                        currentContactWishlistID = string.valueof(defaultWishlistIDForCurrentContact[0].id); 
                                        system.debug('currentContactWishlistID :: ' + currentContactWishlistID);
                                        Map<string,integer> ProductIDMap = new Map<string,integer>(); 
                                        system.debug('dbu_SFL_OR_WL_Value > ' +dbu_SFL_OR_WL_Value);
                                                    //############ INPUT DATA ###############################
                                                    Map<String, Object> inputData = new Map<String, Object>{
                                                        ccrz.ccAPI.API_VERSION => ccrz.ccApi.CURRENT_VERSION,
                                                            ccrz.ccAPIWishList.ID => currentContactWishlistID,                                                            
                                                            ccrz.ccApi.SIZING => new Map<String, Object> {
                                                                ccrz.ccAPIWishList.ENTITYNAME => new Map<String, Object> {
                                                                    ccrz.ccApi.SZ_DATA => ccrz.ccApi.SZ_XL  
                                                                }
                                                            },
                                                            //'DBU_SAVEFORLATER' => 'WishList'
                                                            //'DBU_SAVEFORLATER' => 'Save For Later'    
                                                            'DBU_SAVEFORLATER' => dbu_SFL_OR_WL_Value                                    
                                                            };
                                                                
                                                                try {
                                                                    //############ FIRE fetchWishlistItems() Method ###############################
                                                                    Map<String, Object> outputData = ccrz.ccAPIWishList.fetchWishlistItems(inputData);
                                                                    system.debug('outputData :: ' + outputData);
                                                                    
                                                                    if (outputData.get(ccrz.ccAPIWishList.WISHLIST_ITEMS) != null) {
                                                                        
                                                                        Map<String,List<Map<String,object>>> wishListMap = (Map<String,List<Map<String,object>>>)outputData.get(ccrz.ccAPIWishList.WISHLIST_ITEMS);
                                                                        system.debug(wishListMap);
                                                                        
                                                                        for(Map<string,object> eachItem : (wishListMap.values())[0]){
                                                                            ProductIDMap.put((string)eachItem.get('product'), integer.valueof((decimal)eachItem.get('quantity')));                                                                             
                                                                        } 
                                                                        
                                                                        ProductDetails = dbu_CallCCWishListApi.FetchProductDetails(ProductIDMap, storeCountry);
                                                                        system.debug('ProductDetails :: ' + ProductDetails);                                                                        
                                                                    }
                                                                } catch (Exception e) {
                                                                    // Error handling...
                                                                    system.debug('error is ' + e);
                                                                }                                                                 
                                                                
                                    }                                    
                                    
                                }
                            }catch(Exception e){
                                system.debug('Exception : : ' + e);
                            }                            
                      
        }
        if(ProductDetails == null){
            ProductDetails = new list<dbu_SaveForLaterWrapper>();           
        }
        return ProductDetails;
    }

    @AuraEnabled
    public static List<dbu_SaveForLaterWrapper> fetchLoggedInUserWishlistItemswithInventoryCheck( string dbu_SFL_OR_WL_Value, string storeCountry, string storeLanguage){
        
        system.debug('entering to the fetchwishlistiotems method>>>' +dbu_SFL_OR_WL_Value);
        String userType = UserInfo.getUserType();
        
        //string userID = '00519000003F8rm';
        //string userID = '00519000003F8rm';
        string userID = UserInfo.getUserID();
        
                
        list<dbu_SaveForLaterWrapper> ProductDetails;
        
        if (userType != 'Guest' && userID != null) {            
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
                            
                            
                            try{
                                //######################### Fetch Current User Details ####################################
                                Map<string,object> UserAPIResponse = ccrz.ccApiUser.fetch(UserAPIInputData);     
                                system.debug('SUCCESS FLAG : : ' +  (Boolean)UserAPIResponse.get(ccrz.ccApi.SUCCESS));
                                
                                if(UserAPIResponse.get(ccrz.ccApiUser.USERLIST) != null){
                                    List<Map<String, Object>> UserRetrivedList = (List<Map<String, Object>>)UserAPIResponse.get(ccrz.ccApiUser.USERLIST);
                                    system.debug('UserRetrivedList :: ' + UserRetrivedList);
                                    
                                    //##################### Get Contact ID for the same User ##############################
                                    string contactID = (string)UserRetrivedList[0].get('contactId');
                                    system.debug('contactID >' + contactID);
                                    
                                    //##################### Check whether Wishlist exist for current User #################
                                    list<ccrz__E_Cart__c> defaultWishlistIDForCurrentContact = new list<ccrz__E_Cart__c>();
                                     defaultWishlistIDForCurrentContact = [select id from ccrz__E_Cart__c where ccrz__CartType__c =: 'WishList' and dbu_Cart_StoreCountry__c =: storeCountry And ccrz__Contact__c =: contactID and ccrz__CartStatus__c =: 'Open' and ccrz__ActiveCart__c = false];
                                    system.debug('defaultWishlistIDForCurrentContact >> ' + defaultWishlistIDForCurrentContact); 
                                    string currentContactWishlistID; 
                                    
                                    if(defaultWishlistIDForCurrentContact.isEmpty()){
                                        system.debug('No wishlist found for the current contact');
                                        
                                        //############ Call Logic to create a wishlist for the current contact ############
                                        currentContactWishlistID = dbu_CallCCWishListApi.createDefaultWishlist(contactID, storeCountry, storeLanguage);
                                        

                                    }else{                                        
                                        system.debug('wishlist found for the current contact');
                                        
                                        //########### Get get Default Wishlist for the current User #######################
                                        currentContactWishlistID = string.valueof(defaultWishlistIDForCurrentContact[0].id); 
                                        system.debug('currentContactWishlistID :: ' + currentContactWishlistID);
                                        Map<string,integer> ProductIDMap = new Map<string,integer>(); 
                                        system.debug('dbu_SFL_OR_WL_Value > ' +dbu_SFL_OR_WL_Value);
                                                    //############ INPUT DATA ###############################
                                                    Map<String, Object> inputData = new Map<String, Object>{
                                                        ccrz.ccAPI.API_VERSION => ccrz.ccApi.CURRENT_VERSION,
                                                            ccrz.ccAPIWishList.ID => currentContactWishlistID,                                                            
                                                            ccrz.ccApi.SIZING => new Map<String, Object> {
                                                                ccrz.ccAPIWishList.ENTITYNAME => new Map<String, Object> {
                                                                    ccrz.ccApi.SZ_DATA => ccrz.ccApi.SZ_XL  
                                                                }
                                                            },
                                                            //'DBU_SAVEFORLATER' => 'WishList'
                                                            //'DBU_SAVEFORLATER' => 'Save For Later'    
                                                            'DBU_SAVEFORLATER' => dbu_SFL_OR_WL_Value                                    
                                                            };
                                                                
                                                                try {
                                                                    //############ FIRE fetchWishlistItems() Method ###############################
                                                                    Map<String, Object> outputData = ccrz.ccAPIWishList.fetchWishlistItems(inputData);
                                                                    system.debug('outputData :: ' + outputData);
                                                                    
                                                                    if (outputData.get(ccrz.ccAPIWishList.WISHLIST_ITEMS) != null) {
                                                                        
                                                                        Map<String,List<Map<String,object>>> wishListMap = (Map<String,List<Map<String,object>>>)outputData.get(ccrz.ccAPIWishList.WISHLIST_ITEMS);
                                                                        system.debug(wishListMap);
                                                                        
                                                                        for(Map<string,object> eachItem : (wishListMap.values())[0]){
                                                                            ProductIDMap.put((string)eachItem.get('product'), integer.valueof((decimal)eachItem.get('quantity')));                                                                             
                                                                        } 
                                                                        
                                                                        ProductDetails = dbu_CallCCWishListApi.FetchProductDetailsforWL(ProductIDMap, storeCountry);
                                                                        system.debug('ProductDetails :: ' + ProductDetails);                                                                        
                                                                    }
                                                                } catch (Exception e) {
                                                                    // Error handling...
                                                                    system.debug('error is ' + e);
                                                                }                                                                 
                                                                
                                    }                                    
                                    
                                }
                            }catch(Exception e){
                                system.debug('Exception : : ' + e);
                            }                            
                      
        }
        if(ProductDetails == null){
            ProductDetails = new list<dbu_SaveForLaterWrapper>();           
        }
        return ProductDetails;
    }
    
    
    @AuraEnabled
    public static boolean deleteDefaultWishlist_WishListItem_OR_SaveforLaterItem(string ProductId, string SFL_OR_WL_Value, string storeCountry){
        
        String userType = UserInfo.getUserType();
        
        string userID = UserInfo.getUserID();
        //string userID = '0031900000iIKEc';
        //list<dbu_SaveForLaterWrapper> DeletedProductDetails;
        
        boolean DELETESUCCESSFLAG;
        
        if (userType != 'Guest' && userID != null) {            
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
                            
                            try{
                                //######################### Fetch Current User Details ####################################
                                Map<string,object> UserAPIResponse = ccrz.ccApiUser.fetch(UserAPIInputData);     
                                system.debug('SUCCESS FLAG : : ' +  (Boolean)UserAPIResponse.get(ccrz.ccApi.SUCCESS));
                                
                                if(UserAPIResponse.get(ccrz.ccApiUser.USERLIST) != null){
                                    List<Map<String, Object>> UserRetrivedList = (List<Map<String, Object>>)UserAPIResponse.get(ccrz.ccApiUser.USERLIST);
                                    system.debug('UserRetrivedList :: ' + UserRetrivedList);
                                    
                                    //##################### Get Contact ID for the same User ##############################
                                    string contactID = (string)UserRetrivedList[0].get('contactId');
                                    system.debug('contactID >' + contactID);
                                    
                                    //##################### Check whether Wishlist exist for current User #################
                                    list<ccrz__E_Cart__c> defaultWishlistIDForCurrentContact = new list<ccrz__E_Cart__c>();
                                     defaultWishlistIDForCurrentContact = [select id from ccrz__E_Cart__c where ccrz__CartType__c =: 'WishList' And ccrz__Contact__c =: contactID and dbu_Cart_StoreCountry__c =: storeCountry and ccrz__CartStatus__c =: 'Open' and ccrz__ActiveCart__c = false];
                                    system.debug('defaultWishlistIDForCurrentContact >> ' + defaultWishlistIDForCurrentContact); 
                                    string currentContactWishlistID; 
                                    
                                    if(defaultWishlistIDForCurrentContact.isEmpty()){
                                        system.debug('No wishlist found for the current contact');                                                                                

                                    }else{                                        
                                        system.debug('wishlist found for the current contact');
                                        
                                        //########### Get get Default Wishlist for the current User #######################
                                        currentContactWishlistID = string.valueof(defaultWishlistIDForCurrentContact[0].id); 
                                        system.debug('currentContactWishlistID :: ' + currentContactWishlistID);
                                        
                                        //Logic to delete the Product in wishlist
                                            set<string> ProductsToDelete = new set<string>();
                                            system.debug('ProductId >> ' + ProductId);
                                            ProductsToDelete.add(ProductId);
                                            system.debug('ProductsToDelete >> ' + ProductsToDelete);
                                            //string SFL_OR_WL_Value = 'WishList';
                                            DELETESUCCESSFLAG = dbu_CallCCWishListApi.DeletedefaultWishlistItems(ProductsToDelete, currentContactWishlistID, SFL_OR_WL_Value, storeCountry); 
                                            system.debug('DELETESUCCESSFLAG >> ' + DELETESUCCESSFLAG);
                                    }                                    
                                    
                                }
                            }catch(Exception e){
                                System.debug('Exception type caught: ' + e.getTypeName());    
                                System.debug('Message: ' + e.getMessage());    
                                System.debug('Cause: ' + e.getCause());    
                                System.debug('Line number: ' + e.getLineNumber());    
                                System.debug('Stack trace: ' + e.getStackTraceString()); 
                            }                    
        }
        return DELETESUCCESSFLAG;
    }
    
    @AuraEnabled
    public static Map<string,list<dbu_SaveForLaterWrapper>> AddProductToCart_From_WishList(string dbu_SFL_OR_WL_Value, string productqty, string storeCountry,string storeLanguage){                        
        
        list<ProductQuantityWrapper> productqtyObj = (list<ProductQuantityWrapper>)JSON.deserializeStrict(productqty,list<ProductQuantityWrapper>.class);
        
        Map<string,integer> ProductQuantityMapping = new Map<string,integer>();
        
        if(!ProductQuantityMapping.isEmpty() || ProductQuantityMapping != null){
            for(ProductQuantityWrapper  eachwrap : productqtyObj){
                ProductQuantityMapping.put(eachwrap.id,eachwrap.Quantity);
            }            
        }
                      
        system.debug('ProductQuantityMapping > ' + ProductQuantityMapping);
        
        
        
        String userType = UserInfo.getUserType();
        
        string userID = UserInfo.getUserID();        
        //string userID = '00519000003F8rm';
        Map<string,list<dbu_SaveForLaterWrapper>> AddResponse = new Map<string,list<dbu_SaveForLaterWrapper>>();
        if (userType != 'Guest' || userID != null) {            
            system.debug('loggedIN User');   
            
            //################## Get Contact Details from loggedIn user  
            //userID = '0053C000003Qsnl';
            Map<String, Object> UserAPIInputData = new Map<String,Object>{
                ccrz.ccApi.API_VERSION => ccrz.ccApi.CURRENT_VERSION,
                    ccrz.ccApi.SIZING => new Map<String, Object> { 
                        ccrz.ccApiUser.ENTITYNAME => new Map<String, Object> { 
                            ccrz.ccApi.SZ_DATA => ccrz.ccApi.SZ_S
                                }
                    },
                        ccrz.ccApiUser.USER_ID => userID          
                        };
                            
                            try{
                                //######################### Fetch Current User Details ####################################
                                Map<string,object> UserAPIResponse = ccrz.ccApiUser.fetch(UserAPIInputData);     
                                system.debug('SUCCESS FLAG : : ' +  (Boolean)UserAPIResponse.get(ccrz.ccApi.SUCCESS));
                                
                                if(UserAPIResponse.get(ccrz.ccApiUser.USERLIST) != null){
                                    List<Map<String, Object>> UserRetrivedList = (List<Map<String, Object>>)UserAPIResponse.get(ccrz.ccApiUser.USERLIST);
                                    system.debug('UserRetrivedList :: ' + UserRetrivedList);
                                    
                                    //##################### Get Contact ID for the same User ##############################
                                    string contactID = (string)UserRetrivedList[0].get('contactId');
                                    //string contactID = '0033C00000Lzqjf';
                                    system.debug('contactID >' + contactID);            
                                     
                                    
                                    //##################### Check whether Wishlist exist for current User #################
                                    list<ccrz__E_Cart__c> defaultWishlistIDForCurrentContact = new list<ccrz__E_Cart__c> ();
                                    defaultWishlistIDForCurrentContact = [select id from ccrz__E_Cart__c where ccrz__CartType__c =: 'WishList' And dbu_Cart_StoreCountry__c =: storeCountry And ccrz__Contact__c =: contactID and ccrz__CartStatus__c =: 'Open' and ccrz__ActiveCart__c = false];
                                    system.debug('defaultWishlistIDForCurrentContact >> ' + defaultWishlistIDForCurrentContact); 
                                    
                                    //#################### Get Current Contact's Active cart ##############################
                                    list<ccrz__E_Cart__c> currentCartOfContact = new list<ccrz__E_Cart__c>();
                                    currentCartOfContact = [select id from ccrz__E_Cart__c where ccrz__ActiveCart__c = true AND ccrz__Contact__c =:contactID And dbu_Cart_StoreCountry__c =: storeCountry AND ccrz__CartType__c =:'Cart' AND ccrz__CartStatus__c =: 'Open'];
                                    system.debug('currentCartOfContact > ' + currentCartOfContact);
                                    string CurrentCartID;
                                    
                                    if(!currentCartOfContact.isEmpty()){
                                        //Current Cart found
                                        CurrentCartID = currentCartOfContact[0].id;
                                    }else{
                                        //If current cart absent then create new cart 
                                        CurrentCartID = dbu_CallCCCartApi.createCartCCApi(storeCountry,storeLanguage);
                                    }
                                    
                                    Map<string,integer> existingCartProductIDsMap = new Map<string,integer>();
                                    //check if any product is an crate engine product
                                    list<ccrz__E_Product__c> checkedCrateProducts = new list<ccrz__E_Product__c>();
                                    checkedCrateProducts = [select id from ccrz__E_Product__c where dbu_Crate_Engine__c = true and id in : ProductQuantityMapping.keyset()];
                                    if(checkedCrateProducts.size() > 0){
                                        for(ccrz__E_Product__c eachProduct : checkedCrateProducts){
                                            if((ProductQuantityMapping.keyset()).contains(eachProduct.id)){
                                                //add to crate product to existing Map
                                                existingCartProductIDsMap.put((string)eachProduct.id , (integer)ProductQuantityMapping.get((string)eachProduct.id)); 
                                                //Remove crate product from main map
                                                ProductQuantityMapping.remove((string)eachProduct.id);                             
                                            }
                                        }
                                    }
                                    
                                    system.debug('existingCartProductIDsMap size after creta > ' + existingCartProductIDsMap.size());                                                                              
                                    system.debug('existingCartProductIDsMap after creta > ' + existingCartProductIDsMap);                                                                                                                                                            

                                    system.debug('ProductQuantityMapping size after creta > ' + ProductQuantityMapping.size());                                                                              
                                    system.debug('ProductQuantityMapping after creta > ' + ProductQuantityMapping); 
                                                 
                                    //################## Check whether the Product or products are already in the cart ##########
                                    list<dbu_CCCartApiResponseWrapper> CartAPI_WrapperResponse = new list<dbu_CCCartApiResponseWrapper>();
                                    CartAPI_WrapperResponse = dbu_CartCtrl.fetchLstCartItemsByCartId(CurrentCartID, '');
                                    system.debug('CartAPI_WrapperResponse > ' + CartAPI_WrapperResponse);
                                    system.debug('CartAPI_WrapperResponse size > ' + CartAPI_WrapperResponse.size());
                                    list<string> ProductIdsInCart = new list<string>();
                                    list<string> elligibleProductIDs = new list<string>();
                                    
                                    
                                    if(CartAPI_WrapperResponse.size() > 0){
                                        List<dbu_CartItemWrapper> CartItemlist = new list<dbu_CartItemWrapper>();
                                        CartItemlist = CartAPI_WrapperResponse[0].lstCartItem;
                                        system.debug('CartItemlist >> ' + CartItemlist);
                                        
                                        for(dbu_CartItemWrapper eachItem : CartItemlist){
                                            system.debug('eachItem > ' + (eachItem.cartItem).get('ccrz__Product__c'));
                                            ProductIdsInCart.add((string)(eachItem.cartItem).get('ccrz__Product__c'));
                                        }
                                        system.debug('ProductIds > '+ ProductIdsInCart);
                                    }                        
                                    
            
                                    //Segregate the elligible and existing products by comparing their existence in cart        
                                    if(ProductIdsInCart.size() > 0){                        
                                        system.debug('before > ' +ProductQuantityMapping.size());
                                        for(string eachprodID : ProductQuantityMapping.keyset()){
                                            if(!ProductIdsInCart.contains(eachprodID)){
                                                //products elligible to add in cart
                                                elligibleProductIDs.add(eachprodID);
                                            }else{
                                                //products already existing in cart
                                                existingCartProductIDsMap.put(eachprodID,(integer)ProductQuantityMapping.get(eachprodID));
                                                ProductQuantityMapping.remove(eachprodID);
                                            }                
                                        }
                                        system.debug('After > ' + ProductQuantityMapping.size());
                                    }else{
                                        List<dbu_SaveForLaterWrapper> ProductsIn_SFL_or_WL = new List<dbu_SaveForLaterWrapper>();
                                        ProductsIn_SFL_or_WL = dbu_SaveForLatetGeneric.fetchLoggedInUserWishlistItems(dbu_SFL_OR_WL_Value,storeCountry,storeLanguage);
                                        for(dbu_SaveForLaterWrapper eachWrap : ProductsIn_SFL_or_WL){
                                            elligibleProductIDs.add(eachWrap.ProductID);
                                        }
                                    }
            
                                    system.debug('elligibleProductIDs >> ' + elligibleProductIDs);
                                    system.debug('existingCartProductIDsMap >> ' + existingCartProductIDsMap);
                                    
                                    //Check for coreproducts for current parent products
                                    //Added By Malhar for checking and adding CoreProducts - 6/12/2020 - Begin
                                    Map<string,integer> copyOfProductQuantityMapping = new Map<string,integer>();
                                    copyOfProductQuantityMapping = ProductQuantityMapping;
                                    list<ccrz__E_Product__c> checkCoreProducts = new list<ccrz__E_Product__c>(); 
                                    checkCoreProducts = dbu_CallCCWishListApi.getRelatedProductByProductIdSet(copyOfProductQuantityMapping.keyset(), storeCountry);
                                    system.debug('checkCoreProducts sfl >>>' + JSON.serialize(checkCoreProducts));
                                    system.debug('checkCoreProducts sfl size >>>' + checkCoreProducts.size());
                                    
                                    if(checkCoreProducts.size() > 0){
                                        for(ccrz__E_Product__c prod : checkCoreProducts){
                                            copyOfProductQuantityMapping.put(prod.id, 1);
                                        }
                                    }
                                    //Added By Malhar for checking and adding CoreProducts - 6/12/2020 - End                                    
                                    system.debug('copyOfProductQuantityMapping before >>' + copyOfProductQuantityMapping);
                                    system.debug('copyOfProductQuantityMapping before sz >>' + copyOfProductQuantityMapping.size());
                                    
                                    system.debug('ProductQuantityMapping > ' + ProductQuantityMapping);
                                    system.debug('ProductQuantityMapping sz >< ' + ProductQuantityMapping.size());
                                    
                                    boolean stockavailability = true;
                                    //CHECK FOR INVENTORY
                                    //get the country cureency iso mapping from custom settings
                                    Map<string,string> countryCurrencyMap = new Map<string,string>();
                                    for(dbu_CountryCurrencyMapping__c eachsetting : (list<dbu_CountryCurrencyMapping__c>)dbu_CountryCurrencyMapping__c.getall().values()){
                                        system.debug('dbuCountryCode__c > ' + (string)eachsetting.get('dbuCountryCode__c'));
                                        system.debug('dbuCurrencyCode__c > ' + (string)eachsetting.get('dbuCurrencyCode__c'));
                                        countryCurrencyMap.put((string)eachsetting.get('dbuCountryCode__c'), (string)eachsetting.get('dbuCurrencyCode__c'));
                                    }
                                    system.debug('countryCurrencyMap > ' + countryCurrencyMap); 
                                    
                                    string currencyISOvalue = (string)countryCurrencyMap.get(storeCountry);                                    
                                    
                                    Map<string,double> productInventorymapping = new Map<string,double>();
                                    list<AggregateResult> productInventory = new list<AggregateResult>();
                                    productInventory = [select SUM(ccrz__QtyAvailable__c) TOTALQUANTITY, ccrz__ProductItem__c PRODUCTID
                                                        from ccrz__E_ProductInventoryItem__c 
                                                        where ccrz__ProductItem__c IN : ProductQuantityMapping.keyset() 
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
                                    
                                    //boolean stockstatus = false;
                                    //double inventoryQuantity = 0;
                                    
                                    if(productInventorymapping.size() > 0){
                                        for(string eachproduct : ProductQuantityMapping.keyset()){
                                            if((double)productInventorymapping.get(eachproduct) == null){        
                                               existingCartProductIDsMap.put(eachproduct,1); 
                                               ProductQuantityMapping.remove(eachproduct);
                                                                                               
                                            }                                             
                                        }                                           
                                    }else{
                                        stockavailability = false;
                                        for(string eachproduct : ProductQuantityMapping.keyset()){                                                    
                                            existingCartProductIDsMap.put(eachproduct,1);
                                            ProductQuantityMapping.remove(eachproduct);
                                                                                                                                         
                                        }                                        
                                    }                                    
                                    
                                    
                                    system.debug('ProductQuantityMapping after inv check> ' + ProductQuantityMapping);
                                    system.debug('ProductQuantityMapping after inv check sz >< ' + ProductQuantityMapping.size());
                                    system.debug('existingCartProductIDsMap after inv check >> ' + existingCartProductIDsMap);                                    
                                    system.debug('existingCartProductIDsMap after inv check sz>> ' + existingCartProductIDsMap.size());
                                   
                                    list<string> InsertCartResp = new list<string>();
                                    
                                    	
                                    	//Removing Existing Coupon
                                        Boolean CouponRemovedStatus = dbu_CouponServiceHandler.removeAppliedCoupon(CurrentCartID);
                                        //Perform Cartitems Insert
                                        //Call method to Insert elligible products To cart                                                                        
                                        InsertCartResp = dbu_CallCCWishListApi.insertMultipleCartItems(CurrentCartID, contactID, ProductQuantityMapping, storeCountry);                                                
                                        system.debug('InsertCartResp > ' + InsertCartResp);                                        
                                        
                                        //Reapplying the Coupon
                                        //Boolean CouponReapplyStatus = dbu_CallCCCartApi.reapplyCoupon(CurrentCartID,CurrenctApliedCouponCode);  
                                                                        
                                    for(string eachitem : copyOfProductQuantityMapping.keyset()){
                                        if(!InsertCartResp.contains(eachitem)){
                                            copyOfProductQuantityMapping.remove(eachitem);
                                        }
                                    }
                                    
                                    system.debug('copyOfProductQuantityMapping > ' + copyOfProductQuantityMapping);
                                    system.debug('copyOfProductQuantityMapping size > ' + copyOfProductQuantityMapping.size());
                                    
                                    if(defaultWishlistIDForCurrentContact.isEmpty()){
                                        system.debug('No wishlist found for the current contact');                                                                                
                                    }else{                                        
                                        system.debug('wishlist found for the current contact');
                                        
                                        //########### Get get Default Wishlist for the current User #######################
                                        string currentContactWishlistID;   
                                        currentContactWishlistID = string.valueof(defaultWishlistIDForCurrentContact[0].id); 
                                        system.debug('currentContactWishlistID :: ' + currentContactWishlistID);     
                                        
                                        //Call the method to Delete the product from the Wishlist / save for later
                                        set<string> ProductsAddedSet = new set<string>(InsertCartResp);
                                        boolean DELETESUCCESSFLAG = dbu_CallCCWishListApi.DeletedefaultWishlistItems(ProductsAddedSet, currentContactWishlistID, dbu_SFL_OR_WL_Value, storeCountry);     
                                        system.debug('DELETESUCCESSFLAG > ' + DELETESUCCESSFLAG);
                                    }
                                    
                                    //Return Response
                                    list<dbu_SaveForLaterWrapper> InsertedProductDetails = new list<dbu_SaveForLaterWrapper>(); 
                                    InsertedProductDetails = dbu_CallCCWishListApi.FetchProductDetails(copyOfProductQuantityMapping, storeCountry);
                                    AddResponse.put('PAddedToC', InsertedProductDetails);
                                    system.debug('InsertedProductDetails :: ' + InsertedProductDetails.size());
                                    system.debug('InsertedProductDetails size :: ' + InsertedProductDetails);
                                    
                                    list<dbu_SaveForLaterWrapper> ExistingCartProductDetails = new list<dbu_SaveForLaterWrapper>();
                                    ExistingCartProductDetails = dbu_CallCCWishListApi.FetchProductDetails(existingCartProductIDsMap, storeCountry);
                                    system.debug('ExistingCartProductDetails :: ' + ExistingCartProductDetails);
                                    system.debug('ExistingCartProductDetail size :: ' + ExistingCartProductDetails.size());
                                    AddResponse.put('PExisting', ExistingCartProductDetails);
                                } 
                                }catch(Exception e){
                                System.debug('Exception type caught: ' + e.getTypeName());    
                                System.debug('Message: ' + e.getMessage());    
                                System.debug('Cause: ' + e.getCause());    
                                System.debug('Line number: ' + e.getLineNumber());    
                                System.debug('Stack trace: ' + e.getStackTraceString()); 
                            }
        }
     return AddResponse; 
    }
    
    @AuraEnabled
    public static Map<string,list<dbu_SaveForLaterWrapper>> AddProductToCart_From_SaveForLater_GuestUser(string dbu_SFL_OR_WL_Value, string productqty, string GuestUserCartId, string storeCountry){
        
        list<ProductQuantityWrapper> productqtyObj = (list<ProductQuantityWrapper>)JSON.deserializeStrict(productqty,list<ProductQuantityWrapper>.class);
        
        Map<string,list<dbu_SaveForLaterWrapper>> AddResponse = new Map<string,list<dbu_SaveForLaterWrapper>>();
        Map<string,integer> ProductQuantityMapping = new Map<string,integer>();
        
        if(!ProductQuantityMapping.isEmpty() || ProductQuantityMapping != null){
            for(ProductQuantityWrapper  eachwrap : productqtyObj){
                ProductQuantityMapping.put(eachwrap.id,eachwrap.Quantity);
            }            
        }
                      
        system.debug('ProductQuantityMapping > ' + ProductQuantityMapping);

        String userType = UserInfo.getUserType();
        system.debug('User Type > ' + userType);
        
        string userID = UserInfo.getUserID(); 
        system.debug('Guest userID > ' + userID);
        
        
        //################## Check whether the Product or products are already in the cart ##########
        list<dbu_CCCartApiResponseWrapper> CartAPI_WrapperResponse = dbu_CartCtrl.fetchLstCartItemsByCartId(GuestUserCartId, '');
        system.debug('CartAPI_WrapperResponse > ' + CartAPI_WrapperResponse);

        list<string> ProductIdsInCart = new list<string>();
        list<string> elligibleProductIDs = new list<string>();
        Map<string,integer> existingCartProductIDsMap = new Map<string,integer>();
        
        if(CartAPI_WrapperResponse != null && !CartAPI_WrapperResponse.isEmpty()){
            List<dbu_CartItemWrapper> CartItemlist = new list<dbu_CartItemWrapper>();
            CartItemlist = CartAPI_WrapperResponse[0].lstCartItem;
            system.debug('CartItemlist >> ' + CartItemlist);
            
            for(dbu_CartItemWrapper eachItem : CartItemlist){
                system.debug('eachItem > ' + (eachItem.cartItem).get('ccrz__Product__c'));
                ProductIdsInCart.add((string)(eachItem.cartItem).get('ccrz__Product__c'));
            }
            system.debug('ProductIds > '+ ProductIdsInCart);
        }               
                
        
        //Segregate the elligible and existing products by comparing their existence in cart        
        if(!ProductIdsInCart.isEmpty()){                        
            system.debug('before > ' +ProductQuantityMapping.size());
            for(string eachprodID : ProductQuantityMapping.keyset()){
                if(!ProductIdsInCart.contains(eachprodID)){
                    //products elligible to add in cart
                    elligibleProductIDs.add(eachprodID);
                }else{
                    //products already existing in cart
                    existingCartProductIDsMap.put(eachprodID,(integer)ProductQuantityMapping.get(eachprodID));
                    ProductQuantityMapping.remove(eachprodID);
                }                
            }
            system.debug('After > ' + ProductQuantityMapping.size());
        }else{
            List<dbu_SaveForLaterWrapper> ProductsIn_SFL_or_WL = dbu_SaveForLatetGeneric.fetchLoggedInUserWishlistItems(dbu_SFL_OR_WL_Value, '','');
            for(dbu_SaveForLaterWrapper eachWrap : ProductsIn_SFL_or_WL){
                elligibleProductIDs.add(eachWrap.ProductID);
            }
        }
        
        system.debug('elligibleProductIDs >> ' + elligibleProductIDs);
        system.debug('existingCartProductIDsMap >> ' + existingCartProductIDsMap);    
        
        
        //Call method to Insert elligible products To cart
        //list<string> InsertCartResp = dbu_CallCCWishListApi.insertMultipleCartItems(GuestUserCartId, contactID, ProductQuantityMapping); 
        
        //Added By Malhar for checking and adding CoreProducts - 6/12/2020 - Begin
        Map<string,integer> copyOfProductQuantityMapping = new Map<string,integer>();
        copyOfProductQuantityMapping = ProductQuantityMapping;
        list<ccrz__E_Product__c> checkCoreProducts = new list<ccrz__E_Product__c>(); 
        checkCoreProducts = dbu_CallCCWishListApi.getRelatedProductByProductIdSet(copyOfProductQuantityMapping.keyset(), storeCountry);
        
        if(checkCoreProducts.size() > 0){
            for(ccrz__E_Product__c prod : checkCoreProducts){
                copyOfProductQuantityMapping.put(prod.id, 1);
            }
        }
        //Added By Malhar for checking and adding CoreProducts - 6/12/2020 - End
        boolean stockavailability = true;
        //CHECK FOR INVENTORY
        //get the country cureency iso mapping from custom settings
        Map<string,string> countryCurrencyMap = new Map<string,string>();
        for(dbu_CountryCurrencyMapping__c eachsetting : (list<dbu_CountryCurrencyMapping__c>)dbu_CountryCurrencyMapping__c.getall().values()){
            system.debug('dbuCountryCode__c > ' + (string)eachsetting.get('dbuCountryCode__c'));
            system.debug('dbuCurrencyCode__c > ' + (string)eachsetting.get('dbuCurrencyCode__c'));
            countryCurrencyMap.put((string)eachsetting.get('dbuCountryCode__c'), (string)eachsetting.get('dbuCurrencyCode__c'));
        }
        system.debug('countryCurrencyMap > ' + countryCurrencyMap); 
        
        string currencyISOvalue = (string)countryCurrencyMap.get(storeCountry);                                    
        
        Map<string,double> productInventorymapping = new Map<string,double>();
        list<AggregateResult> productInventory = new list<AggregateResult>();
        productInventory = [select SUM(ccrz__QtyAvailable__c) TOTALQUANTITY, ccrz__ProductItem__c PRODUCTID
                            from ccrz__E_ProductInventoryItem__c 
                            where ccrz__ProductItem__c IN : ProductQuantityMapping.keyset() 
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
        
        //boolean stockstatus = false;
        //double inventoryQuantity = 0;
        
        if(productInventorymapping.size() > 0){
            for(string eachproduct : ProductQuantityMapping.keyset()){
                if((double)productInventorymapping.get(eachproduct) == null){        
                    ProductQuantityMapping.remove(eachproduct);
                    existingCartProductIDsMap.put(eachproduct,1);                                                
                }                                             
            }                                           
        }else{
            stockavailability = false;
            for(string eachproduct : ProductQuantityMapping.keyset()){                                                    
                existingCartProductIDsMap.put(eachproduct,1);
                ProductQuantityMapping.remove(eachproduct);
                
            }                                        
        }         
        
        
        //CHECK IF COUPON IS APPLIED TO CART 
        ccrz__E_Cart__c currenctCart;
        list<string> InsertCartResp = new list<string>();
            //Removing Existing Coupon
            if(!Test.isRunningTest()) {
			Boolean CouponRemovedStatus = dbu_CouponServiceHandler.removeAppliedCoupon(GuestUserCartId);
            }
            //Perform Cartitems Insert            
            InsertCartResp = dbu_CallCCWishListApi.insertMultipleCartItemsSaveForLater(GuestUserCartId, ProductQuantityMapping, storeCountry);
            system.debug('InsertCartResp > ' + InsertCartResp);
            system.debug('ProductQuantityMapping > ' + ProductQuantityMapping);            
            
            //Reapplying the Coupon
            //Boolean CouponReapplyStatus = dbu_CallCCCartApi.reapplyCoupon(GuestUserCartId,CurrenctApliedCouponCode);              
                      
        for(string eachitem : copyOfProductQuantityMapping.keyset()){
            system.debug('eachitem > ' + eachitem);
            system.debug('InsertCartResp > ' + InsertCartResp);
            system.debug(!(InsertCartResp.contains(eachitem)));
            system.debug(InsertCartResp.contains(eachitem));
            if(!InsertCartResp.contains(eachitem)){ 
                copyOfProductQuantityMapping.remove(eachitem);               
            }
        }  
        system.debug('copyOfProductQuantityMapping > ' + copyOfProductQuantityMapping);    
        
        //Return Response
        list<dbu_SaveForLaterWrapper> InsertedProductDetails = new list<dbu_SaveForLaterWrapper>(); 
        InsertedProductDetails = dbu_CallCCWishListApi.FetchProductDetails(copyOfProductQuantityMapping, storeCountry);
        AddResponse.put('PAddedToC', InsertedProductDetails);
        list<dbu_SaveForLaterWrapper> ExistingCartProductDetails = new list<dbu_SaveForLaterWrapper>();
        ExistingCartProductDetails = dbu_CallCCWishListApi.FetchProductDetails(existingCartProductIDsMap, storeCountry);
        AddResponse.put('PExisting', ExistingCartProductDetails);        
        
        return AddResponse;
    }
    
    @AuraEnabled
    public static Map<string,object> AddAllProductsToCartfromSaveforlater_GuestUser(string CurrentCartID, string SFL_ProductIdsList, string storeCountry){
        
        list<object> ProductIDS = (list<object>)JSON.deserializeUntyped(SFL_ProductIdsList);
        system.debug('ProductIDSet :: ' + ProductIDS);
        system.debug('ProductIDSet size :: ' + ProductIDS.size());
        
        Map<string,object> response = new Map<string,object>();
        set<string> ProductIDSet= new set<string>();
        for(object o : ProductIDS){
            ProductIDSet.add(string.valueOf(o));
        }
        system.debug('ProductIDSet > ' + ProductIDSet);        
        
        //get the country cureency iso mapping from custom settings 
        Map<string,string> countryCurrencyMap = new Map<string,string>();
        for(dbu_CountryCurrencyMapping__c eachsetting : (list<dbu_CountryCurrencyMapping__c>)dbu_CountryCurrencyMapping__c.getall().values()){
            system.debug('dbuCountryCode__c > ' + (string)eachsetting.get('dbuCountryCode__c'));
            system.debug('dbuCurrencyCode__c > ' + (string)eachsetting.get('dbuCurrencyCode__c'));
            countryCurrencyMap.put((string)eachsetting.get('dbuCountryCode__c'), (string)eachsetting.get('dbuCurrencyCode__c'));
        }
        system.debug('countryCurrencyMap > ' + countryCurrencyMap);        
        
        string currencyISOvalue = (string)countryCurrencyMap.get(storeCountry);
        Map<string,boolean> productToshipboolean_mapping = new Map<string,boolean>();
        //check if any product is a crate product
        list<ccrz__E_Product__c> crateEngineProducts = new list<ccrz__E_Product__c>();
        crateEngineProducts = [select id
                               from ccrz__E_Product__c 
                               where dbu_Crate_Engine__c = true 
                               and id in : ProductIDSet];
        
      
        system.debug('crateEngineProducts > ' + crateEngineProducts);
        system.debug('crateEngineProducts size > ' + crateEngineProducts.size());
        

        set<string> prodexisting = new set<string>();
        if(crateEngineProducts.size() > 0){
            for(ccrz__E_Product__c eachProduct : crateEngineProducts){
                if(ProductIDSet.contains(eachProduct.id)){
                    ProductIDSet.remove(eachProduct.id);
                    prodexisting.add((string)eachProduct.id);
                }
            }
        } 
        
        system.debug('prodexisting > ' + prodexisting);
        system.debug('prodexisting size> ' + prodexisting.size());        
        
        //response.put('ExistingProducts',prodexisting);
        
        system.debug('Modified ProductIDSet > ' + ProductIDSet);
        system.debug('Modified ProductIDSet size> ' + ProductIDSet.size());
        
        //get all products from Cart
        set<string> FetchedexistingCartProductIDs = dbu_CallCCWishListApi.FetchCartProducts(CurrentCartID);
        system.debug('FetchedexistingCartProductIDs > ' + FetchedexistingCartProductIDs );
        system.debug('FetchedexistingCartProductIDs size > ' + FetchedexistingCartProductIDs.size() );
        
        

        set<string> ProductstoAdd = new set<string>();
        set<string> remainingProductstoAdd = new set<string>();
        for(string eachpro : ProductIDSet){
            if(!FetchedexistingCartProductIDs.contains(eachpro)){
                ProductstoAdd.add(eachpro);
                remainingProductstoAdd.add(eachpro);
            }else{
                prodexisting.add(eachpro);
            }
        }
        
        system.debug('ProductstoAdd > ' + ProductstoAdd);
        system.debug('ProductstoAdd size > '+ ProductstoAdd.size());
        
    
        
        system.debug('prodexisting > ' + prodexisting);
        system.debug('prodexisting size > '+ prodexisting.size());        
        
        //system.debug('response line 824 > ' + response);
        

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
        
        
        if(productInventorymapping.size() > 0){
        for(string eachproductid : remainingProductstoAdd){
            if((double)productInventorymapping.get(eachproductid) == null){
                remainingProductstoAdd.remove(eachproductid);
                ProductstoAdd.remove(eachproductid);
                prodexisting.add(eachproductid);
            }
        }
        system.debug('remainingProductstoAdd > ' + remainingProductstoAdd);
        system.debug('remainingProductstoAdd size > ' + remainingProductstoAdd.size());            
        }else{           
            for(string eachproduct : remainingProductstoAdd){                                                    
                prodexisting.add(eachproduct);
                ProductstoAdd.remove(eachproduct);
                remainingProductstoAdd.remove(eachproduct);                
            }                                        
        }                 
        
         list<ccrz__E_CartItem__c> cartitemslist = new list<ccrz__E_CartItem__c>();       

        //check for coreProduct in list       
        if(remainingProductstoAdd.size() > 0){
            
            productToshipboolean_mapping = dbu_CallCCWishListApi.FetchShipToPickUpDetail(remainingProductstoAdd);
                                            
            list<ccrz__E_Product__c> relatedcoreprods = new list<ccrz__E_Product__c>();
            Map<string,list<string>> relatedproductidmappings = new Map<string,list<string>>();
            dbu_CallCCWishListApi.relatedprodwrapper currentwrapper = new dbu_CallCCWishListApi.relatedprodwrapper();
            currentwrapper = dbu_CallCCWishListApi.getRelatedProductByProductIdSet2(remainingProductstoAdd,storeCountry);
            relatedcoreprods = currentwrapper.productlist;
			relatedproductidmappings = currentwrapper.relatedproductsmap;
            system.debug('relatedcoreprods > ' + relatedcoreprods);
            system.debug('relatedcoreprods size > ' + relatedcoreprods.size());            
			
			system.debug('relatedproductidmappings > ' + relatedproductidmappings);            
            

            
        if(relatedcoreprods.size() > 0 ){
            for(ccrz__E_Product__c eachprod : relatedcoreprods){                
                    ccrz__E_CartItem__c eachcartitem = new ccrz__E_CartItem__c(
                        ccrz__Product__c = eachprod.id,                        
                        ccrz__Quantity__c = 1,
                        ccrz__PricingType__c = 'auto',                        
                        ccrz__OriginalQuantity__c = 1,
                        ccrz__UnitOfMeasure__c = 'Each',
                        ccrz__ItemStatus__c  = 'Available',
                        ccrz__StoreID__c = 'CSSNAStore',
                        ccrz__RequestDate__c = system.today(),                        
                        ccrz__ProductType__c = 'Product',                        
                        ccrz__Cart__c = (ID)CurrentCartID, 
                        CurrencyIsoCode = currencyISOvalue
                    );
                    if(test.isRunningTest() == true){
                        eachcartitem.ccrz__OriginalItemPrice__c = 55;
                        eachcartitem.ccrz__Price__c = 55;
                        eachcartitem.ccrz__SubAmount__c = 55 * 1;                            
                    }else{
                        eachcartitem.ccrz__OriginalItemPrice__c = eachprod.ccrz__E_PriceListItems__r[0].ccrz__Price__c;
                        eachcartitem.ccrz__Price__c = eachprod.ccrz__E_PriceListItems__r[0].ccrz__Price__c;
                        eachcartitem.ccrz__SubAmount__c = eachprod.ccrz__E_PriceListItems__r[0].ccrz__Price__c * 1;                            
                    }
                    if(relatedproductidmappings.get(eachprod.id) != null){
                    	list<string> relatedproductparentlist = new list<string>();
                        relatedproductparentlist = (list<string>)relatedproductidmappings.get(eachprod.id);
                        if(relatedproductparentlist.size() > 0){
                            string parentproductid;
                            if(relatedproductparentlist.size()>1){
                                parentproductid = relatedproductparentlist[0];
                                relatedproductparentlist.remove(0);
                            }else if(relatedproductparentlist.size() > 0 && relatedproductparentlist.size() < 2){
                                parentproductid = relatedproductparentlist[0];
                            }
                            
                            if(parentproductid != null){
                                if(productToshipboolean_mapping.get(parentproductid) != null){
                                    boolean shiptoboolean = (boolean)productToshipboolean_mapping.get(parentproductid);
                                    eachcartitem.dbu_isShipTo__c = shiptoboolean;
                                }
                            }
                        }
                    }
                    cartitemslist.add(eachcartitem); 
                    ProductstoAdd.add(eachprod.id);                                                   
            }
        }               
            
        }
        

     

        system.debug('ProductstoAdd > ' + ProductstoAdd);
        system.debug('ProductstoAdd size > ' + ProductstoAdd.size());
        
        
        system.debug('remainingProductstoAdd > ' + remainingProductstoAdd);
        system.debug('remainingProductstoAdd size > ' + remainingProductstoAdd.size());
        
        response.put('ProductsAdded',ProductstoAdd);                 
        response.put('prodexisting',prodexisting);            
        system.debug('response line 877 > ' + response);
        

        
        list<ccrz__E_Product__c> generalProducts = new list<ccrz__E_Product__c>();
        generalProducts = [select id, 
                           Name,
                           (select ccrz__Price__c from ccrz__E_PriceListItems__r WHERE ccrz__Pricelist__r.ccrz__CurrencyISOCode__c =: currencyISOvalue),
                           (SELECT ccrz__URI__c,ccrz__MediaType__c from ccrz__E_ProductMedias__r where ccrz__URI__c != null AND ccrz__MediaType__c =: 'Product Image' LIMIT 1)
                           from ccrz__E_Product__c 
                           where id in : remainingProductstoAdd];        
        
        system.debug('generalProducts > ' + generalProducts);
        system.debug('generalProducts size > ' + generalProducts.size());        
        
        
        if(generalProducts.size() > 0){
            for(ccrz__E_Product__c eachprod : generalProducts){
                    ccrz__E_CartItem__c eachcartitem = new ccrz__E_CartItem__c(
                        ccrz__Product__c = eachprod.id,
                        ccrz__Price__c = eachprod.ccrz__E_PriceListItems__r[0].ccrz__Price__c,
                        ccrz__Quantity__c = 1,
                        ccrz__PricingType__c = 'auto',
                        ccrz__OriginalItemPrice__c = eachprod.ccrz__E_PriceListItems__r[0].ccrz__Price__c,
                        ccrz__OriginalQuantity__c = 1,
                        ccrz__UnitOfMeasure__c = 'Each',
                        ccrz__ItemStatus__c  = 'Available',
                        ccrz__StoreID__c = 'CSSNAStore',
                        ccrz__RequestDate__c = system.today(),
                        ccrz__ProductType__c = 'Product',
                        ccrz__SubAmount__c = eachprod.ccrz__E_PriceListItems__r[0].ccrz__Price__c * 1,
                        ccrz__Cart__c = (ID)CurrentCartID,
                        CurrencyIsoCode = currencyISOvalue
                    );  
                    if(productToshipboolean_mapping.get((string)eachprod.id) != null){
                        string prodid = string.valueOf(eachprod.id);
                        eachcartitem.dbu_isShipTo__c = (boolean)productToshipboolean_mapping.get(prodid);                         
                    }
                    cartitemslist.add(eachcartitem);
            }
        }
        
        system.debug('cartitemslist > ' + cartitemslist);
        system.debug('cartitemslist size > ' + cartitemslist.size());        
        
        
        
        //CHECK IF COUPON IS APPLIED TO CART 
        //ccrz__E_Cart__c currenctCart = [SELECT ID,(SELECT ID, ccrz__Coupon__r.ccrz__CouponCode__c FROM ccrz__E_CartCoupons__r) FROM ccrz__E_Cart__c WHERE ID =: CurrentCartID];
        list<string> InsertCartResp = new list<string>(); 
        
            //Removing Existing Coupon
			Boolean CouponRemovedStatus = dbu_CouponServiceHandler.removeAppliedCoupon(CurrentCartID);
            //Perform Cartitems Insert
            insert cartitemslist;
            
            //Reapplying the Coupon
            //Boolean CouponReapplyStatus = dbu_CallCCCartApi.reapplyCoupon(CurrentCartID,CurrenctApliedCouponCode);  
                
        system.debug('final response > ' + response);
        return response;
    }
    
    @AuraEnabled
    public static list<string> GetCartProducts(String CurrentCartID){
        set<string> FetchedProductIDs = dbu_CallCCWishListApi.FetchCartProducts(CurrentCartID);
        list<string> FetchedProductIDsList = new list<string>(FetchedProductIDs);        
        return FetchedProductIDsList;
    }
    
    public class ProductQuantityWrapper {
        public String id;
        public integer Quantity;
    }
    
    @AuraEnabled
    public static boolean deleteCartItemSFLGeneric(String cartItemsLst,String cartId){
        system.debug('entering the delete method in SFL' +cartItemsLst+''+cartId);
        boolean deleteSuccess = false;
        List<String> cartItmID = new List<String>();
           list<object> cartItems = (list<object>)JSON.deserializeUntyped(cartItemsLst);
                system.debug('cartItems' +cartItems);
        for(Object eachCartItem: cartItems){
            cartItmID.add(String.valueOf(eachCartItem));
            system.debug('cartItmID' +cartItmID);
        }

        if(cartId != '' && cartItmID != null){
            list<string> InsertCartResp = new list<string>();				
           	    //Removing Existing Coupon
                Boolean CouponRemovedStatus = dbu_CouponServiceHandler.removeAppliedCoupon(cartId);
                //Perform Cartitems Delete
				deleteSuccess = dbu_CallCCWishListApi.deleteCartItemSFL(cartItmID,cartId);
                //Reapplying the Coupon
                //Boolean CouponReapplyStatus = dbu_CallCCCartApi.reapplyCoupon(cartId,CurrenctApliedCouponCode);  
        }
        return deleteSuccess;
    }
      
    @AuraEnabled
    public static string getcurrentCartItemCartID(string CartItemId){ 
    list<ccrz__E_CartItem__c> CartIdLst = new list<ccrz__E_CartItem__c>();
    CartIdLst = [select ccrz__Cart__c from ccrz__E_CartItem__c where id =: CartItemId LIMIT 1];
    system.debug('CartIdLst > ' + CartIdLst);
        if(!CartIdLst.isEmpty()){
            string CartId = string.valueof(CartIdLst[0].ccrz__Cart__c);
            return CartId;
        }else{
            return null;        
        }       
    }
    
    @AuraEnabled
    public static boolean DeleteMultipleItemsfromCart(string cartId, string ProductIDList, string storeCountry){
        boolean isDeleted = false;
        list<object> ProductIDS = (list<object>)JSON.deserializeUntyped(ProductIDList);
        system.debug('ProductIDSet :: ' + ProductIDS);
         
        set<string> ProductIDSet= new set<string>();
        for(object o : ProductIDS){
            ProductIDSet.add(string.valueOf(o));
        }
         
        list<ccrz__E_CartItem__c> cartItemsToDelete = new list<ccrz__E_CartItem__c>();
        cartItemsToDelete = [select id from ccrz__E_CartItem__c where ccrz__Cart__c =: cartId 
                             and ccrz__Cart__r.dbu_Cart_StoreCountry__c =: storeCountry and ccrz__cartItemType__c != 'Coupon' and ccrz__Product__c in : ProductIDSet];
        
        if(cartItemsToDelete.size() > 0){
            try{
                list<string> InsertCartResp = new list<string>();                
                    //Removing Existing Coupon
                    Boolean CouponRemovedStatus = dbu_CouponServiceHandler.removeAppliedCoupon(cartId);
                    //Perform Cartitems delete
                    delete cartItemsToDelete;
                    isDeleted = true;
                    //Reapplying the Coupon
                    //Boolean CouponReapplyStatus = dbu_CallCCCartApi.reapplyCoupon(cartId,CurrenctApliedCouponCode);  
                   
            }catch(exception e){                
                system.debug(e.getCause());
                system.debug(e.getLineNumber());
                system.debug(e.getMessage());
                system.debug(e.getStackTraceString());
            }                                         
        }
        
        return isDeleted;
    }
    
    @AuraEnabled
    public static list<string> AddMultipleProductsToSaveforLater(string ProductIDList, string storeCountry, string storeLanguage){
        
        list<string> CartitemsList = new list<string>();
        
        //step 1 : deserialize the product Id list
        list<object> ProductIDS = (list<object>)JSON.deserializeUntyped(ProductIDList);
        system.debug('ProductIDSet :: ' + ProductIDS);
         
        set<string> ProductIDSet= new set<string>();
        for(object o : ProductIDS){
            ProductIDSet.add(string.valueOf(o));
        }     
        
        //step 2 : get current contact        
        user currentcontact = [select contactid from user where id =: userinfo.getUserId()];
        
        //Create or get wishlist for current contact
        list<ccrz__E_Cart__c> currentWishlist = new list<ccrz__E_Cart__c>();
        currentWishlist = [select id from ccrz__E_Cart__c 
                                           where ccrz__CartType__c = 'WishList'
                                           and ccrz__CartStatus__c = 'open' 
                                           and dbu_Cart_StoreCountry__c =: storeCountry 
                                           and ccrz__ActiveCart__c = false LIMIT 1];
        
        string defaultwishlist;
        if(currentWishlist.size() > 0){
            //Wishlist exits
            defaultwishlist = currentWishlist[0].id;
            system.debug('Wishlist Found');
            
            //Filterout existing saveforlater Products in wishlist.
            list<ccrz__E_CartItem__c> ifProductsExisting = new list<ccrz__E_CartItem__c>();
            ifProductsExisting = [select ccrz__Product__c from ccrz__E_CartItem__c 
                                  where ccrz__Cart__r.id =: defaultwishlist 
                                  and DBU_SaveForLater__c = 'Save For Later' 
                                  and ccrz__Product__c in : ProductIDSet];

            system.debug('ProductIDSet before > ' + ProductIDSet.size());
            if(ifProductsExisting.size() > 0){
                for(ccrz__E_CartItem__c eachitem : ifProductsExisting){
                    if(ProductIDSet.contains(eachitem.ccrz__Product__c)){
                        ProductIDSet.remove(eachitem.ccrz__Product__c);
                    }
                }                                               
            }
            system.debug('ProductIDSet after > ' + ProductIDSet.size());
                        
        }else{
            //wishlist does not exist. Hence Create wishlist
            system.debug('Wishlist does not exist, hence creating new wishlist.');
            defaultwishlist =dbu_CallCCWishListApi.createDefaultWishlist((string)currentcontact.contactid, storeCountry, storeLanguage);
                      
        }

            //getting inventory for products
            //for wishlist product availability status
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
                                where ccrz__ProductItem__c IN : ProductIDSet
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
        
        //Perform adding products in wishlist
        list<ccrz__E_CartItem__c> wishlistitemslist = new list<ccrz__E_CartItem__c>();
        for(string eachProduct : ProductIDSet){
            ccrz__E_CartItem__c eachWLItem = new ccrz__E_CartItem__c();
            eachWLItem.ccrz__Cart__c = defaultwishlist;
            eachWLItem.ccrz__Product__c = eachProduct;
            eachWLItem.ccrz__Price__c = 0;
            eachWLItem.ccrz__Quantity__c = 1;
            eachWLItem.ccrz__SubAmount__c = 1;
            eachWLItem.CurrencyIsoCode = 'USD';
            eachWLItem.ccrz__cartItemType__c = 'Major';
            eachWLItem.ccrz__ProductType__c = 'Product';
            eachWLItem.ccrz__UnitOfMeasure__c = 'Each';
            eachWLItem.ccrz__ItemStatus__c = 'Available';
            eachWLItem.ccrz__StoreID__c = 'CSSNAStore';
            eachWLItem.ccrz__RequestDate__c = system.today();
            eachWLItem.ccrz__OriginalItemPrice__c = 0;
            eachWLItem.ccrz__OriginalQuantity__c = 1;
            eachWLItem.DBU_SaveForLater__c = 'Save For Later';   
            boolean ProductAvailabilityStatus = false;
            double inventoryQuantity = 0;
            if(productInventorymapping.size() > 0){
                if((double)productInventorymapping.get(eachProduct) != null){
                    inventoryQuantity = (double)productInventorymapping.get(eachProduct);
                    system.debug('inventoryQuantity > ' + inventoryQuantity);
                    if(inventoryQuantity > 0){
                        ProductAvailabilityStatus = true;
                    }else{
                        ProductAvailabilityStatus = false;
                    }
                }
            }
            system.debug('ProductAvailabilityStatus >> ' + ProductAvailabilityStatus);
            eachWLItem.dbu_Item_ProductStatus__c = ProductAvailabilityStatus;            
            wishlistitemslist.add(eachWLItem);
        }
        
        
        database.SaveResult[] resultList = Database.insert(wishlistitemslist, true);
        for(database.SaveResult eachresult :  resultList){
            if(eachresult.isSuccess()){
                 CartitemsList.add(eachresult.getId());
            }else{
                for(Database.Error err : eachresult.getErrors()){
                    system.debug(err.getStatusCode());
                    system.debug(err.getFields());
                    system.debug(err.getMessage());                                   
                }
            }   
        }
        return CartitemsList;
    }
    
    @AuraEnabled
    public static boolean checkProductInDefaultWishlist(string currentProductID ,string storeCountry){
        boolean isPresentInWishlist = false;
        
        //step 2 : get current contact        
        user currentcontact = [select contactid from user where id =: userinfo.getUserId()];
        system.Debug('currentcontact ' + currentcontact); 
        
        //Create or get wishlist for current contact
        list<ccrz__E_Cart__c> currentWishlist = new list<ccrz__E_Cart__c>();
        currentWishlist = [select id from ccrz__E_Cart__c 
                                           where ccrz__CartType__c = 'WishList'
                                           and ccrz__CartStatus__c = 'open' 
                                           and dbu_Cart_StoreCountry__c =: storeCountry 
                                           and ccrz__ActiveCart__c = false 
                                           and ccrz__Contact__c =: currentcontact.contactid LIMIT 1 ];
        
        system.debug('currentWishlist > '+ currentWishlist);
        string defaultwishlist;   
        
        if(currentWishlist.size() > 0){
            //Wishlist exits
            defaultwishlist = currentWishlist[0].id;
            system.debug('Wishlist Found');
            
            //Filterout existing saveforlater Products in wishlist.
            list<ccrz__E_CartItem__c> ifProductsExisting = new list<ccrz__E_CartItem__c>();
            ifProductsExisting = [select ccrz__Product__c from ccrz__E_CartItem__c 
                                  where ccrz__Cart__r.id =: defaultwishlist 
                                  and DBU_SaveForLater__c = 'WishList' 
                                  and ccrz__Product__c =: currentProductID LIMIT 1]; 
            
            system.debug('ifProductsExisting > ' + ifProductsExisting);
            
            if(ifProductsExisting.size() > 0){
                system.debug('product id in wishlist > ' + ifProductsExisting[0].ccrz__Product__c);
                isPresentInWishlist = true;
            }
        }
        
        return isPresentInWishlist;
    }
    
    @AuraEnabled
    public static list<string> returnNonCoreProducts(string ProductIDList){
        list<string> cproductidlist = new list<string>();
        //step 1 : deserialize the product Id list
        list<object> ProductIDS = (list<object>)JSON.deserializeUntyped(ProductIDList);
        system.debug('ProductIDSet :: ' + ProductIDS);
         
        set<string> ProductIDSet= new set<string>();
        for(object o : ProductIDS){
            ProductIDSet.add(string.valueOf(o));
        }  
        
        
        list<ccrz__E_Product__c> NoncoreProduct = new list<ccrz__E_Product__c>();
        
        NoncoreProduct = [select id from ccrz__E_Product__c 
                          where dbu_Has_Core_Child__c = false 
                          and id in : ProductIDSet];
        
       
        system.debug('NoncoreProduct > ' + NoncoreProduct);
        system.debug('NoncoreProduct sz > ' + NoncoreProduct.size());
        
        for(ccrz__E_Product__c echp : NoncoreProduct){
            cproductidlist.add((string)echp.id);
        }
        return cproductidlist;
    }
}