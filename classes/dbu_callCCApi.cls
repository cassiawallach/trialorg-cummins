public class dbu_callCCApi {
    
    @AuraEnabled(cacheable=true)
    public static list<dbu_CCAPIResponseWrapper> fetchProductDetails(string productID,String urlParam){
        Set<string> productIdList = new Set<string>{productID};
            //Set<String> productIdList = new Set<String>{'a2w190000019Uwu'};
            system.debug('productIdList'+productIdList);
        system.debug('productID>>>' +productID);
        
        ApexPages.PageReference ref = new ApexPages.PageReference(urlParam);
        Map<String, String> params = ref.getParameters();
        string storelanguage = params.get('store');
        string storeCountry;
        //check which country it is
        if(storelanguage == system.label.dbu_home_store_U_S_A){
            storeCountry = system.label.dbu_home_store_U_S_A;
        }else if(storelanguage == system.label.dbu_home_store_Canada){
            storeCountry = 'CA';
        }else if(storelanguage == system.label.dbu_home_store_Canada_French){
            storeCountry = 'CA';
        }
        //get the country cureency iso mapping from custom settings
        Map<string,string> countryCurrencyMap = new Map<string,string>();
        for(dbu_CountryCurrencyMapping__c eachsetting : (list<dbu_CountryCurrencyMapping__c>)dbu_CountryCurrencyMapping__c.getall().values()){
            countryCurrencyMap.put((string)eachsetting.get('dbuCountryCode__c'), (string)eachsetting.get('dbuCurrencyCode__c'));
        }
        string currencyISOvalue = (string)countryCurrencyMap.get(storeCountry); 
        system.debug('currencyISOvalue--->' + currencyISOvalue);
                                        
        Map<String, Object> inputData = new Map<String, Object>{
            ccrz.ccAPIProduct.PRODUCTIDLIST => productIdList,
                ccrz.ccAPI.API_VERSION => ccrz.ccApi.CURRENT_VERSION,
                ccrz.ccAPI.SIZING => new Map<String, Object>{
                   
                   ccrz.ccAPIProduct.ENTITYNAME => new Map<String, Object>{
                       ccrz.ccAPI.SZ_DATA => ccrz.ccAPI.SZ_XL
                        //ccrz.ccAPI.SZ_REL => new List<String>{'E_ProductInventoryItem__r'} 
                   }       
               }
                };
                    system.debug('inputData'+inputData);
        
        dbu_CCAPIResponseWrapper wrapper = new dbu_CCAPIResponseWrapper();
        List<ccrz__E_Product__c>productListByID = new List<ccrz__E_Product__c>();
        Boolean shipAvailable = false;
        Boolean returnable = false;
        Boolean pickUpOnlyProduct = false;
        Set<String> relatedProd = new Set<String>();
        list<dbu_CCAPIResponseWrapper> wrapperlist = new list<dbu_CCAPIResponseWrapper>();
        try {
                productListByID = [Select id,dbu_Product_Code__c,dbu_Available_to_ship__c,ccrz__SEOKeywords__c,dbu_Non_Returnable__c,dbu_Pick_Up_Only__c, dbu_Has_Core_Charge__c, (select id,ccrz__RelatedProduct__c from ccrz__E_RelatedProducts__r where ccrz__RelatedProductType__c = 'Core Charge' AND ccrz__Enabled__c=True) from ccrz__E_Product__c  
                                   where id = :productID];
                
            for(ccrz__E_Product__c productBooleanData : productListByID){
                if(productBooleanData.ccrz__SEOKeywords__c != null){
                    wrapper.seoKeyword = productBooleanData.ccrz__SEOKeywords__c;
                    system.debug('wrapper.seoKeyword' +wrapper.seoKeyword);
                }else if(productBooleanData.ccrz__SEOKeywords__c == null){
                    wrapper.seoKeyword = null;
                }
                if(productBooleanData.dbu_Available_to_ship__c){
                    shipAvailable = true;
                }else{
                    shipAvailable = false; 
                    //returnable = false;
                    
                }
                if(productBooleanData.dbu_Non_Returnable__c){
                    returnable = true;
                }else{
                    returnable = false;
                }
                if(productBooleanData.dbu_Pick_Up_Only__c){
                    pickUpOnlyProduct = true;
                }else{
                    pickUpOnlyProduct = false;
                }
                /**11Nov2020 Core Charge*/
                if(productBooleanData.dbu_Has_Core_Charge__c){
                    wrapper.hasCoreCharge = true;
                    if(productBooleanData.ccrz__E_RelatedProducts__r != null && productBooleanData.ccrz__E_RelatedProducts__r.size() > 0){
                       if( productBooleanData.ccrz__E_RelatedProducts__r[0].ccrz__RelatedProduct__c != null){
                           relatedProd.add(productBooleanData.ccrz__E_RelatedProducts__r[0].ccrz__RelatedProduct__c);
                         //  wrapper.coreCharge = productBooleanData.ccrz__E_RelatedProducts__r[0].ccrz__RelatedProduct__r.dbu_Core_Charge_Amount__c;
                       }
                    }
                }
                /** End: Core Charge*/
               /* if(productBooleanData.dbu_Added_to_Wishlist__c == true){
                    addedToWishlist = true;
                }else{
                    addedToWishlist = false;
                }*/
            }
            List<ccrz__E_PriceListItem__c> corePriceListItems= new List<ccrz__E_PriceListItem__c>();
            corePriceListItems=[Select id,ccrz__Price__c,ccrz__Pricelist__c,ccrz__Product__c,ccrz__Product__r.DBU_Product_Location__c from ccrz__E_PriceListItem__c Where ccrz__Product__c IN:relatedProd AND ccrz__Pricelist__r.ccrz__CurrencyISOCode__c = :currencyISOvalue];
            if(corePriceListItems.size()>0){
                wrapper.coreCharge=corePriceListItems[0].ccrz__Price__c;
            }else{
                   wrapper.coreCharge=0.00;
               }
            
            Map<String, Object> outputData = ccrz.ccAPIProduct.fetch(inputData);
            if (outputData.get(ccrz.ccAPIProduct.PRODUCTLIST) != null) {
                // The cast to List<Map<String, Object>> is necessary...
                system.debug('outputData-->'+outputData);
                system.debug('outputDatakeyset-->'+outputData.keyset());
                
                List<Map<String, Object>> outputProductList = (List<Map<String, Object>>) outputData.get(ccrz.ccAPIProduct.PRODUCTLIST);
                system.debug('outputProductList'+JSON.serialize(outputProductList));
                system.debug('outputProductList>>>' +outputProductList);
                
                if(outputProductList!=null && outputProductList.size()>0 ){
                    
                    Map<String, Object> myProduct = new Map<String, Object>();
                    System.debug('productID=>'+ productID);
                    for(Map<String, Object> ob:outputProductList)
                    {
                        System.debug('obsfid=>'+ (String)ob.get('sfid'));
                        String sfid = (String)ob.get('sfid');
                        
                        //if( sfid.SubString(0,15) == productID)
                            //{
                                System.debug('my product is matching now');
                                myProduct = ob;
                            //}
                    }
                    
                    wrapper.shortDesc = (String)myProduct.get('shortDesc');
                    
                    wrapper.longDesc = (String)myProduct.get('longDesc');
                    system.debug('wrapper.longDesc' +wrapper.longDesc);
                    system.debug('wrapper.shortDesc' +wrapper.shortDesc);

                    if((wrapper.shortDesc != null && wrapper.longDesc == null) || (wrapper.shortDesc == null && wrapper.longDesc != null) ||
                      (wrapper.shortDesc != null && wrapper.longDesc != null)){
                        wrapper.showDesc = true;
                          system.debug('showDesc>>>' +wrapper.showDesc);
                    }
                    wrapper.sfdcCurrencyISOCode = (String)myProduct.get('sfdcCurrencyISOCode');
                    wrapper.inventoryType = (String)myProduct.get('inventoryType');
                    wrapper.taxable = (Boolean)myProduct.get('taxable');
                    Decimal toroundquantity = (Double)myProduct.get('quantityperunit');
                    if(toroundquantity != null)
                        toroundquantity = toroundquantity.setScale(0);
                    wrapper.quantityperunit = toroundquantity;
                    Decimal toround = (Double)myProduct.get('averageRating');
                    if(toround != null)
                     toround = toround.setScale(1);
                    wrapper.averageRating = toround;
                    System.debug('wrapper@@@@@@@@@@@@\t'+wrapper);
                    //
                   // integer toroundtotalRating = (integer)myProduct.get('totalRating');
                    // toroundtotalRating = toroundtotalRating.(0);
                   // wrapper.totalRating = (integer)myProduct.get('totalRating');
                    //
                    
                    wrapper.endDate = (Date)myProduct.get('endDate');
                    wrapper.secondaryAttr = (String)myProduct.get('secondaryAttr');
                    wrapper.primaryAttr = (String)myProduct.get('primaryAttr');
                    wrapper.unitOfMeasure = (String)myProduct.get('unitOfMeasure');
                    wrapper.startDate = (Date)myProduct.get('startDate');
                    wrapper.productType =(String)myProduct.get('productType');
                    if(wrapper.productType != '' && wrapper.productType == 'Bundle'){
                        wrapper.productTypeKit = true;
                        system.debug('wrapper.productTypeKit' +wrapper.productTypeKit);
                    }
                    System.debug('2222wrapper@@@@@@@@@@@@\t'+wrapper);
                    wrapper.productStatus =(String)myProduct.get('productStatus');
                    wrapper.storefront =(String)myProduct.get('storefront');
                    wrapper.SKU =(String)myProduct.get('SKU');
                    wrapper.ownerId = (String)myProduct.get('ownerId');
                    wrapper.sfdcName = (String)myProduct.get('sfdcName');
                    wrapper.sfid = (String)myProduct.get('sfid');
                    wrapper.numberOfReviews = (Decimal)myProduct.get('numberOfReviews');
                    wrapper.availableToShip = shipAvailable;
                    wrapper.nonReturnable = returnable;
                    wrapper.pickUpOnly = pickUpOnlyProduct;
                    wrapper.productCode = (String)myProduct.get('dbuProductCode');
                    system.debug('wrapper.availableToShip' +wrapper.availableToShip);
                    
                    List<Map<String,Object >> inventories = (List<Map<String,Object >>)myProduct.get('productInventoryItemsS');
                    List<Map<String,Object >> productMedia = (List<Map<String,Object >>)myProduct.get('EProductMediasS');
                    List<Map<String,Object >> compositeProducts = (List<Map<String,Object >>)myProduct.get('compositeProductsS');

                    system.debug('compositeProducts'+compositeProducts);
                    system.debug('inventories>>>'+inventories);

                    List<dbu_ProductInventoryItemWrapper> inventoryList = new List<dbu_ProductInventoryItemWrapper>();
                    List<dbu_EProductMediaWrapper> productMediaList = new List<dbu_EProductMediaWrapper>();
                    if(inventories == null ){
                        wrapper.inventoryExists = true;
                        system.debug('inventoryExists>>' +wrapper.inventoryExists);
                    }
                    if(inventories!=null && inventories.size()>0){
                        for(Map<String,Object> ob : inventories)
                        {
                            dbu_ProductInventoryItemWrapper inven = new dbu_ProductInventoryItemWrapper();
                            inven.sfdcCurrencyISOCode = (String)ob.get('sfdcCurrencyISOCode');
                            inven.status = (String)ob.get('status');
                             inven.qtyAvailable = (Decimal)ob.get('qtyAvailable');
                            if(inven.qtyAvailable != null && inven.qtyAvailable <= 5.00 &&  inven.qtyAvailable !=0){
                                inven.lowStock =  true;
                            }
                            if(inven.status=='Out of Stock' ||inven.qtyAvailable==0){
                               inven.notifyStock = true; 
                            }
                                
                           
                            inven.sfdcName = (String)ob.get('sfdcName');
                            inven.sfid = (String)ob.get('sfid');
                            inven.productItem = (String)ob.get('productItem');
                            inven.availabilityMessage = (String)ob.get('availabilityMessage');
                            inventoryList.add(inven);
                        }
                    }
                    
                    if(productMedia!=null && productMedia.size()>0){
                        for(Map<String,Object> ob : productMedia)
                        {
                            dbu_EProductMediaWrapper media = new dbu_EProductMediaWrapper();
                            media.sfdcCurrencyISOCode = (String)ob.get('sfdcCurrencyISOCode');
                            
                            media.startDate = (Date)ob.get('startDate');
                            media.sequence = (Decimal)ob.get('sequence');
                            media.productMediaSource = (String)ob.get('productMediaSource');
                            media.mediaType = (String)ob.get('mediaType');
                            media.locale = (String)ob.get('locale');
                            media.endDate = (Date)ob.get('endDate');
                            media.enabled = (Boolean)ob.get('enabled');
                            media.sfdcName = (String)ob.get('sfdcName');
                            media.sfid = (String)ob.get('sfid');
                            media.product = (String)ob.get('product');
                             if(media.mediaType == 'Product Image')
                            media.URI = (String)ob.get('URI');
                            //----Added by Mukesh---//---24-12-2020
                            if(media.mediaType == 'Media'){
                                 String mediaUri = (String)ob.get('URI');
                                String videoId =  mediaUri.remove('https://www.youtube.com/embed/');
                                media.videoImage = 'https://img.youtube.com/vi/'+videoId+'/1.jpg';
                                media.isMedia = true;
                            }else{
                                 media.isMedia = false;
                            }
                            //------------------------------------
                            if(media.mediaType == 'Product Image' || media.mediaType == 'Media'){
                                system.debug('entering the if loop>>' +media.mediaType);
                            productMediaList.add(media);
                            }
                        }
                    }
                    
                    
                    wrapper.productInventoryItemsS =inventoryList;
                   
                    wrapper.EProductMediasS =productMediaList;
                    System.debug('3333wrapper@@@@@@@@@@@@\t'+wrapper);
                    wrapperlist.add(wrapper);
                    productMedia(productMediaList);
                    System.debug('wrapper=>'+ wrapper);
                    System.debug('inventories=>'+inventories);
                }
            }
        } 
        
        catch (Exception e) {
            system.debug('exception message '+e.getmessage()+''+'exception line number '+e.getlinenumber());// Error handling...
        } 
        return wrapperlist;
    }
    
    public static list<dbu_EProductMediaWrapper> productMedia(List<dbu_EProductMediaWrapper> prdMedia){
        List<dbu_EProductMediaWrapper> prdMediaList = new List<dbu_EProductMediaWrapper>();
        try{
            if(!prdMedia.isEmpty()){
                prdMediaList.addall(prdMedia);
                system.Debug('prdMediaList>>' +prdMediaList);
            
        }
        }
        catch(Exception exc){
                        system.debug('exception message '+exc.getmessage()+''+'exception line number '+exc.getlinenumber());// Error handling...

        }
        return prdMediaList;
        
    }
    
        @AuraEnabled(cacheable=true)
    public static List<dbu_ProductInvWrapper> productInventoryDetails(string productID, string storeCountry){
        Map<string,double> productInventorymapping = new Map<string,double>();
        //get the country curency iso mapping from custom settings
        Map<string,string> countryCurrencyMap = new Map<string,string>();
        for(dbu_CountryCurrencyMapping__c eachsetting : (list<dbu_CountryCurrencyMapping__c>)dbu_CountryCurrencyMapping__c.getall().values()){
            system.debug('dbuCountryCode__c > ' + (string)eachsetting.get('dbuCountryCode__c'));
            system.debug('dbuCurrencyCode__c > ' + (string)eachsetting.get('dbuCurrencyCode__c'));
            countryCurrencyMap.put((string)eachsetting.get('dbuCountryCode__c'), (string)eachsetting.get('dbuCurrencyCode__c'));
        }
        system.debug('countryCurrencyMap > ' + countryCurrencyMap);   
        string CurrencyISOcodeValue = (string)countryCurrencyMap.get(storeCountry);
        
        
        
        list<AggregateResult> productInventory = new list<AggregateResult>();
        productInventory = [select SUM(ccrz__QtyAvailable__c) TOTALQUANTITY
                            from ccrz__E_ProductInventoryItem__c 
                            where ccrz__ProductItem__c =: ProductID 
                            and CurrencyIsoCode =: CurrencyISOcodeValue 
                           ];
        List<dbu_ProductInvWrapper> invDataList = new List<dbu_ProductInvWrapper>();
        dbu_ProductInvWrapper invData = new dbu_ProductInvWrapper();
        system.debug('xyzzz>>>' +productInventory);
        for (AggregateResult ar : productInventory)  {
            invData.quantityInInv = (Decimal) ar.get('TOTALQUANTITY');
        }
        if(invData.quantityInInv > 0 && invData.quantityInInv != null){
            invData.invStockData = 'In Stock';
        }else if(invData.quantityInInv == null || invData.quantityInInv == 0 || invData.quantityInInv <= 0){
            invData.invStockData = 'Out of Stock';
        }
        system.debug('invData>>' +invData);
        invDataList.add(invData);
        return invDataList;
        
    }
}