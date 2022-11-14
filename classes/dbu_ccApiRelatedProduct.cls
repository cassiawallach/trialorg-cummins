public without sharing class dbu_ccApiRelatedProduct {
    
    public static String selectedStore;
    public static Map<String,DataTemp> getRealatedProduct(String Product1Id){
        set<string> RelatedProductsIDList;
        Map<String,DataTemp > relatedMap = new Map<String,DataTemp>();
        Set<String> productName = new Set<String>();
        //string Product1Id = 'a2w190000019UwpAAE';a2w190000018XfSAAU
        //string Product1Id = 'a2w190000018XfSAAU';
        Map<String, Object> InputData = new Map<String, Object> {
            ccrz.ccApi.API_VERSION => ccrz.ccApi.CURRENT_VERSION,
                ccrz.ccApi.SIZING => new Map<String, Object>{
                    ccrz.ccApiRelatedProduct.ENTITYNAME => new Map<String, Object>{
                        ccrz.ccApi.SZ_DATA => ccrz.ccAPI.SZ_XL
                            }        
                },
                    ccrz.ccApiRelatedProduct.PRODUCTIDLIST => new Set<String>{Product1Id},
                        ccrz.ccApiRelatedProduct.RELATED_TYPE  => new Set<String>{'Accessories', 'CrossSell', 'Related','Complementary','UpSell'} 
        };
            try{
                Map<string,object> RelatedProductFetchResponse = ccrz.ccApiRelatedProduct.fetch(InputData);
                system.debug('RelatedProductFetchResponse :: ' + RelatedProductFetchResponse);
                RelatedProductsIDList = new set<string>();
                
                if(RelatedProductFetchResponse.get(ccrz.ccApiRelatedProduct.RELATEDPRODUCTLIST) != null){
                    List<Map<String, Object>> RelProductList = (List<Map<String, Object>>)RelatedProductFetchResponse.get(ccrz.ccApiRelatedProduct.RELATEDPRODUCTLIST);
                    system.debug('RelProductList :: ' + RelProductList);
                    system.debug('RelProductList :: ' + RelProductList.size());
                    
                    for(Map<string,object> eachRelProduct : RelProductList){
                        string relatedProductrecordID = (string)eachRelProduct.get('sfid');
                        system.debug('relatedProductrecordID :: ' + relatedProductrecordID);
                        string relatedProductType = (string)eachRelProduct.get('relatedProductType');
                        //if((string)eachRelProduct.get('relatedProductType') == 'Complementary'){
                        string relatedProductName = (string)((Map<string,object>)eachRelProduct.get('relatedProductR')).get('sfdcName');
                        DataTemp obj = new DataTemp();
                        //system.debug('relatedProductType ' + ((string)eachRelProduct.get('relatedProductType')));
                        //system.debug('relatedProductTypeID ' + (string)((Map<string,object>)eachRelProduct.get('relatedProductR')).get('sfid'));
                        obj.productType = ((string)eachRelProduct.get('relatedProductType'));
                        obj.Name = relatedProductName;
                        //productName.add(relatedProductName);
                        //productName.add((string)eachRelProduct.get('relatedProductType'));
                        relatedMap.put((string)((Map<string,object>)eachRelProduct.get('relatedProductR')).get('sfid'),obj);
                        // }
                        
                        system.debug('relatedProductType :: ' + relatedProductType);
                        //string relatedProductName = (string)((Map<string,object>)eachRelProduct.get('relatedProductR')).get('sfdcName');
                        //system.debug('relatedProductName :: ' + relatedProductName);
                        
                        string relatedProductID = (string)((Map<string,object>)eachRelProduct.get('relatedProductR')).get('sfid');
                        //system.debug('relatedProductID :: ' + relatedProductID);
                        RelatedProductsIDList.add(relatedProductID);
                    }
                    system.debug('relatedMap ' + relatedMap);
                    system.debug('RelatedProductsIDList :: ' +  RelatedProductsIDList);
                }
            }catch(Exception e){
                system.debug('Exception Fire :: ' + e);
            }
        return relatedMap ; 
    }
    @AuraEnabled
    public static Map<String,String> getProducts(List<String> RelatedProductsIDList){
        // set<string> RelatedProductsIDList = new set<string>{'a2w190000019UwmAAE', 'a2w190000019UwnAAE', 'a2w190000019UwoAAE', 'a2w190000019UwqAAE', 'a2w190000019UwuAAE'};
        Map<String,String> relatedMediaMap = new Map<String,String>();
        Map<string,object> pinputData = new Map<string,object>{
            ccrz.ccApi.API_VERSION => ccrz.ccApi.CURRENT_VERSION,   
                
                ccrz.ccApi.SIZING => new Map<String, Object> {
                    ccrz.ccApiProduct.ENTITYNAME => new Map<String, Object> {
                        ccrz.ccApi.SZ_DATA => ccrz.ccApi.SZ_L,
                            ccrz.ccApi.SZ_REL => New List<String>{'E_ProductMedias__r'}    
                    }
                },
                    ccrz.ccApiProduct.PRODUCTIDLIST => RelatedProductsIDList,
                    
                    ccrz.ccApiProduct.PRODUCTSTOREFRONT => 'CSSNAStore',
                    ccrz.ccApiProduct.TYPES => new Set<String>{'Product'}  
        };
            system.debug('pinputData'+pinputData);
        Map<String, Object> outputData = ccrz.ccAPIProduct.fetch(pinputData);
        if (outputData.get(ccrz.ccAPIProduct.PRODUCTLIST) != null) {
            system.debug('outputData-->'+outputData);
            system.debug('outputDatakeyset-->'+outputData.keyset());
            
            List<Map<String, Object>> outputProductList = (List<Map<String, Object>>) outputData.get(ccrz.ccAPIProduct.PRODUCTLIST);
            system.debug('outputProductList'+JSON.serialize(outputProductList));
            system.debug('outputProductList>>>' +outputProductList);
            if(outputProductList!=null && outputProductList.size()>0 ){
                
                Map<String, Object> myProduct = new Map<String, Object>();
                for(Map<String, Object> ob:outputProductList)
                {
                    List<Map<String,Object >> productMedia = (List<Map<String,Object >>)ob.get('EProductMediasS');
                    if(productMedia != NULL){
                        for(Map<String, Object> media : productMedia){
                            //system.debug('media ' + media.get('URI'));
                            //system.debug('sfdcName ' + media.get('sfdcName'));
                            //system.debug('sfid ' + media.get('sfid'));
                            //if(relatedMap.containsKey((String)media.get('product'))){
                            //system.debug('matched product id ' + media.get('product'));
                            if((String)media.get('mediaType') == 'Product Image') //Changed for CSSN-2628,CSSN-2627
                                relatedMediaMap.put((String)media.get('product'),(String)media.get('URI'));
                            //}
                            //system.debug('product ' + media.get('product'));
                            //ob.get('sfdcName');
                            //ob.get('sfid');
                        }
                    }
                    
                    //System.debug('obsfid=>' + ob);
                }
                system.debug('relatedMediaMap ' + relatedMediaMap);
            }
        }
        return relatedMediaMap;
    }
    
    @AuraEnabled
    public static Map<String,Decimal> getProductPrice(List<String> RelatedProductsIDList){
        //Vishnu
        String currencyISOvalue = 'USD';
        for(dbu_CountryCurrencyMapping__c eachsetting : (list<dbu_CountryCurrencyMapping__c>)dbu_CountryCurrencyMapping__c.getall().values()){
            if(selectedStore == (string)eachsetting.get('dbuCountryCode__c')){
                currencyISOvalue = (string)eachsetting.get('dbuCurrencyCode__c');
            }             
        }
        //set<string> RelatedProductsIDList = new set<string>{'a2w190000019UwmAAE', 'a2w190000019UwnAAE', 'a2w190000019UwoAAE', 'a2w190000019UwqAAE', 'a2w190000019UwuAAE'};
        Map<string,object> PricelistItemInputData = new Map<string,object>{
            ccrz.ccApi.API_VERSION => ccrz.ccApi.CURRENT_VERSION,
                ccrz.ccApiPriceList.PRODUCTIDS => RelatedProductsIDList,
                ccrz.ccApiPriceList.CURRCODE => currencyISOvalue,
                ccrz.ccApi.SIZING => new Map<String, Object> {
                    ccrz.ccApiPriceList.ENTITYNAME_PLI => new Map<String, Object> {
                        ccrz.ccApi.SZ_DATA => ccrz.ccApi.SZ_L
                            }
                }    
        };     
            Map<string,decimal> ProductPriceMap = new Map<string,decimal>();
        try{
            Map<string,object> PricelistItemResponse = ccrz.ccApiPriceList.fetchPriceListItems(PricelistItemInputData);
            if(PricelistItemResponse.get(ccrz.ccApiPriceList.PRICELISTITEMS) != null){
                Map<String, Map<String, Object>> priceListItems = (Map<String, Map<String, Object>>)PricelistItemResponse.get(ccrz.ccApiPriceList.PRICELISTITEMS);
                
                List<Map<string,object>> pricelistitemsList = (List<Map<string,object>>)priceListItems.values();
                
                
                for(Map<string,object> eachPriceListItem : pricelistitemsList){
                    system.debug(JSON.serializePretty((string)eachPriceListItem.get('product')));
                    system.debug(JSON.serializePretty((decimal)eachPriceListItem.get('price')));
                    ProductPriceMap.put((string)eachPriceListItem.get('product') , (decimal)eachPriceListItem.get('price'));
                }
                system.debug('ProductPriceMap :: ' + ProductPriceMap);
            }
        }catch(Exception e){
            system.debug('exception : ' + e);
        }               
        return ProductPriceMap;
    }
    @AuraEnabled(cacheable=true)
    public static List<RelatedProductResponseWrapper> getRelatedProductList(String urlParam){
        System.debug('urlParam ' + urlParam);
        string Product1Id;
        if(String.isNotBlank(urlParam)){
            
            ApexPages.PageReference ref = new ApexPages.PageReference(urlParam);
            Map<String, String> params = ref.getParameters();
            // System.debug('SimilarProducts?????????\t'+params.size());
            if(params.size() > 0 && params.containsKey('pId')){
                Product1Id = params.get('pId');
            }
            //@Vishnu             
            if(params.size() > 0 && params.containsKey('store')){
                if(params.get('store') == System.label.dbu_home_store_Canada || params.get('store') == System.label.dbu_home_store_Canada_French) {
                    selectedStore = System.label.dbu_home_store_Canada_CA;
                }
            } else {
                selectedStore = System.label.dbu_home_store_U_S_A;
            }
        }
        //string Product1Id = 'a2w190000018XfSAAU';
        Map<String,DataTemp> relatedProductMap = new Map<String,DataTemp>();
        Map<String,String> productMap = new Map<String,String>();
        Map<String,decimal> productpriceMap = new Map<String,decimal>();
        Set<String> relatedProductIds = new Set<String>();
        
        if(Product1Id != null){
            relatedProductMap = getRealatedProduct(Product1Id);
        }
        
        relatedProductIds = relatedProductMap.keySet();
        List<String> relatedProductIdList = new List<String>(relatedProductIds);
        system.debug('relatedProductIdList ' + relatedProductIdList);
        
        if(relatedProductIdList != null){
            productMap = getProducts(relatedProductIdList);
            productpriceMap = getProductPrice(relatedProductIdList);
        }
        
        system.debug('productMap ' + productpriceMap);
        system.debug('relatedProductMap ' + relatedProductMap);
        
        List<ccrz__E_Product__c> lstOfProduct = new List<ccrz__E_Product__c>();
        Map<String, Decimal> mapOfOriginalPrice = new Map<String,Decimal>();
        List<String> releasedFBTP = new List<String>();//INC2544526
        lstOfProduct =  [select id,(select id,dbu_Original_Price__c from ccrz__E_PriceListItems__r) from ccrz__E_Product__c where id IN : relatedProductIdList and ccrz__ProductStatus__c = 'Released' and dbu_Product_Status__c = 'In Stock'];
        for(ccrz__E_Product__c pObject : lstOfProduct){
            releasedFBTP.add(pObject.id);
            for(ccrz__E_PriceListItem__c priceObj : pObject.ccrz__E_PriceListItems__r){
                mapOfOriginalPrice.put(pObject.id,priceObj.dbu_Original_Price__c);
            }
        }
        
        List<RelatedProductResponseWrapper> responseObjectList = new List<RelatedProductResponseWrapper>();
        for(String data : relatedProductIdList){
            RelatedProductResponseWrapper responseObject = new RelatedProductResponseWrapper();
            if(relatedProductMap.containsKey(data)){
                responseObject.id = data;
                DataTemp dataTempObj= relatedProductMap.get(data);
                responseObject.Name = dataTempObj.Name;
                responseObject.productType = dataTempObj.productType;
                //responseObject.productType = relatedProductMap.get(data);
                
            }
            if(productMap.containsKey(data)){
                responseObject.URI = productMap.get(data);
            }
            if(productpriceMap.containsKey(data)){
                responseObject.price = productpriceMap.get(data);
            }
            if(mapOfOriginalPrice.containsKey(data)){
                responseObject.originalPrice = mapOfOriginalPrice.get(data);
            }
            if(releasedFBTP.contains(data)) {
                responseObjectList.add(responseObject);
            }
            System.debug('data ' + data);
        }
        System.debug('responseObjectList ' + responseObjectList);
        return responseObjectList;
    }
    public class RelatedProductResponseWrapper{
        @AuraEnabled
        public String id;
        @AuraEnabled
        public String Name;
        @AuraEnabled
        public String productType;
        @AuraEnabled
        public String URI;
        @AuraEnabled
        public decimal price;
        @AuraEnabled
        public decimal originalPrice;
    }
    public class DataTemp{
        public String Name;
        public String productType;
    }
    @AuraEnabled
    public static Decimal getShippingAmount(String cartId){
        List<ccrz__E_Cart__c> cartData = new List<ccrz__E_Cart__c>();
        Decimal shippingCost = 0.00;
        cartData = [select id,ccrz__ShipAmount__c,dbu_Free_Shipping__c from ccrz__E_Cart__c where id =: cartId];
        system.debug('cartData ' + cartData[0].ccrz__ShipAmount__c);
        if(cartData[0].ccrz__ShipAmount__c != null && cartData[0].dbu_Free_Shipping__c != true){ //  Free Shipping case== Mukesh 
            shippingCost = cartData[0].ccrz__ShipAmount__c;
        }
        system.debug('shippingCost ' + shippingCost);
        return shippingCost;
    }
    
    @AuraEnabled
    public static void insertFrequentlyBoughtItemsInCart(string ProductsIdsList, string storeCountry, string CartId){
        
        //Deserialize the productID list and convert it to a set
        list<object> ProductIDS = new list<object>();
        ProductIDS = (list<object>)JSON.deserializeUntyped(ProductsIdsList);
        system.debug('ProductIDList :: ' + ProductIDS);
        
        set<string> ProductIDSet= new set<string>();        
        if(ProductIDS.size() > 0){
            for(object o : ProductIDS){
                ProductIDSet.add(string.valueOf(o));
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
        string CurrencyISOcodeValue = (string)countryCurrencyMap.get(storeCountry); 
        
        system.debug('CurrencyISOcodeValue > ' + CurrencyISOcodeValue);
        
        
        
        
    }
}