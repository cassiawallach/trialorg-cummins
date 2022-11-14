global class dbu_GoogleMerchantController implements Database.Batchable<sObject>, Database.Stateful {
    
    global String log = ''; 
    global Integer counter = 0;
    global Database.QueryLocator start(Database.BatchableContext BC){

     //@Vishnu Core Price  28th Feb 2022  
	 //String query = 'SELECT Id, Name,ccrz__SKU__c,dbu_Part_Number__c,ccrz__LongDescRT__c,ccrz__ProductStatus__c FROM ccrz__E_Product__c WHERE Group_Name__c = \'Ecom\' ';        
     String query = 'SELECT Id, Name,ccrz__SKU__c,dbu_Part_Number__c,ccrz__LongDescRT__c,ccrz__ProductStatus__c,dbu_Has_Core_Child__c,dbu_Has_Core_Charge__c, (select id,ccrz__RelatedProduct__c from ccrz__E_RelatedProducts__r where ccrz__RelatedProductType__c = \'Core Charge\' AND ccrz__Enabled__c=True) FROM ccrz__E_Product__c WHERE Group_Name__c = \'Ecom\'';        
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<sObject> scope){
        try {
            String csvColumnHeader;
            List<String> csvRowValuesUsa = new List<String>();
            List<String> csvRowValuesCanada = new List<String>();
            Map<Id,String> prodMediaMap = new Map<Id,String>();
            Map<Id,ccrz__E_PriceListItem__c> usaProductPriceMap = new Map<Id,ccrz__E_PriceListItem__c>();
            Map<Id,ccrz__E_PriceListItem__c> canadaProductPriceMap = new Map<Id,ccrz__E_PriceListItem__c>();
            Map<Id,Integer> usaInventoryMap = new Map<Id,Integer>();
            Map<Id,Integer> canadaInventoryMap = new Map<Id,Integer>();
            Map<Id,Decimal> productSpecMap = new Map<Id,Decimal>();
            Map<Id, List<String>> prodAdditionalImgMap = new Map<Id, List<String>>();
            List<String> mediaUriList = new List<String>();
            Set<Id> prodListIds = new Set<Id>();
            //@Vishnu Core Price  28th Feb 2022
            Map<Id,Set<Id>> relatedProdIds = new Map<Id,Set<Id>>(); 
            Map<Id,ccrz__E_PriceListItem__c> usaCoreProductPriceMap = new Map<Id,ccrz__E_PriceListItem__c>();
            Map<Id,ccrz__E_PriceListItem__c> canadaCoreProductPriceMap = new Map<Id,ccrz__E_PriceListItem__c>();
            Set<Id> prodIds = new Set<Id>();

            for(ccrz__E_Product__c prodObj : (List<ccrz__E_Product__c>) scope){  
                prodListIds.add(prodObj.Id);
                //@Vishnu Core Price  28th Feb 2022                
                if(prodObj.dbu_Has_Core_Charge__c && prodObj.dbu_Has_Core_Child__c == false){
                    if(prodObj.ccrz__E_RelatedProducts__r != null && prodObj.ccrz__E_RelatedProducts__r.size() > 0){
                       if( prodObj.ccrz__E_RelatedProducts__r[0].ccrz__RelatedProduct__c != null){
                           if(!relatedProdIds.containsKey(prodObj.ccrz__E_RelatedProducts__r[0].ccrz__RelatedProduct__c)) {
                               relatedProdIds.put(prodObj.ccrz__E_RelatedProducts__r[0].ccrz__RelatedProduct__c,new Set<Id> {prodObj.Id});
                           } else {
                               prodIds = relatedProdIds.get(prodObj.ccrz__E_RelatedProducts__r[0].ccrz__RelatedProduct__c);
                               prodIds.add(prodObj.Id);
                               relatedProdIds.put(prodObj.ccrz__E_RelatedProducts__r[0].ccrz__RelatedProduct__c,prodIds);
                           }
                       }
                    }
                }
            }
            System.debug('prodListIds.size()====='+prodListIds.size());
            
            //=============Product Media===============
            List<ccrz__E_ProductMedia__c> prodMediaList =  [SELECT Id,ccrz__MediaType__c, ccrz__URI__c,ccrz__Product__c FROM ccrz__E_ProductMedia__c WHERE ccrz__Product__c IN :prodListIds AND ccrz__MediaType__c = 'Product Image' AND ccrz__URI__c != null ];
            System.debug('===prodMediaList=='+prodMediaList);
            System.debug('===prodMediaList size=='+prodMediaList.size());
            
            if(prodMediaList.size() > 0){
                for(ccrz__E_ProductMedia__c mediaObj : prodMediaList){
                  /*  if(!prodMediaMap.containsKey(mediaObj.ccrz__Product__c)){
                        prodMediaMap.put(mediaObj.ccrz__Product__c,mediaObj.ccrz__URI__c);
                    }*/
                    mediaUriList.add(mediaObj.ccrz__URI__c);
                    //=====Additional Image Map======
                    if(prodAdditionalImgMap.containsKey(mediaObj.ccrz__Product__c)) {
                        List<String> thumbnailImages = prodAdditionalImgMap.get(mediaObj.ccrz__Product__c);
                        thumbnailImages.add(mediaObj.ccrz__URI__c);
                        prodAdditionalImgMap.put(mediaObj.ccrz__Product__c, thumbnailImages);
                    } else {
                        prodAdditionalImgMap.put(mediaObj.ccrz__Product__c, new List<String> { mediaObj.ccrz__URI__c });
                    }
                }
            }
            
            System.debug('prodAdditionalImgMap========='+prodAdditionalImgMap);
            //======= To get the product image URL =========
            
            String orgId = UserInfo.getOrganizationId();
            String domainName = System.Label.dbu_domainName;
            Map<String,String> imageUrlMap = new Map<String,String>();
            List<Document> docList = [SELECT Id,Name FROM Document WHERE Name IN: mediaUriList];
            System.debug('docList.size===='+docList.size());
            
            if(docList.size() > 0){
                for(Document documentObj : docList){
                    String returnImageUrl = domainName+'--c.documentforce.com/servlet/servlet.ImageServer?id='+documentObj.Id+'&oid='+orgId;
                    System.debug('returnImageUrl==='+returnImageUrl);
                    imageUrlMap.put(documentObj.Name,returnImageUrl);
                }
            }
            
            for(ccrz__E_ProductMedia__c mediaObj : prodMediaList){
                if(!prodMediaMap.containsKey(mediaObj.ccrz__Product__c) && imageUrlMap.containsKey(mediaObj.ccrz__URI__c) && mediaObj.ccrz__URI__c != System.Label.dbu_DefaultProductImage){
                    prodMediaMap.put(mediaObj.ccrz__Product__c,mediaObj.ccrz__URI__c);
                }
                
            }
            
            /*>>>>>>> To get the product brand >>>>>>>>>>*/
            
            Map<String,String> productBrandMap = new Map<String,String>();
            List<ccrz__E_ProductCategory__c > prodCategoryList = [SELECT Id,ccrz__Product__c,ccrz__Category__r.Name , ccrz__Category__r.ccrz__ParentCategory__r.ccrz__ParentCategory__r.Name FROM ccrz__E_ProductCategory__c WHERE ccrz__Product__c IN : prodListIds  AND ccrz__Category__c != null AND ccrz__Category__r.ccrz__ParentCategory__c != null AND  ccrz__Category__r.ccrz__ParentCategory__r.ccrz__ParentCategory__c != null];
            if(prodCategoryList.size() > 0){
                for(ccrz__E_ProductCategory__c prodCategoryObj : prodCategoryList){
                    productBrandMap.put(prodCategoryObj.ccrz__Product__c, prodCategoryObj.ccrz__Category__r.ccrz__ParentCategory__r.ccrz__ParentCategory__r.Name);
                }
            }
            
            //============Price List ===================
            List<ccrz__E_PriceListItem__c> priceListRecords =  [SELECT Id,ccrz__Pricelist__r.ccrz__CurrencyISOCode__c,CurrencyIsoCode,ccrz__Price__c,dbu_Original_Price__c,ccrz__Product__c FROM ccrz__E_PriceListItem__c WHERE ccrz__Product__c IN :prodListIds AND ccrz__Price__c != null];
            if(priceListRecords.size() > 0){
                for(ccrz__E_PriceListItem__c priceListObj : priceListRecords){
                    if(priceListObj.ccrz__Pricelist__r.ccrz__CurrencyISOCode__c == 'USD' && !usaProductPriceMap.containsKey(priceListObj.ccrz__Product__c)){
                        usaProductPriceMap.put(priceListObj.ccrz__Product__c,priceListObj);
                    }
                    if(priceListObj.ccrz__Pricelist__r.ccrz__CurrencyISOCode__c == 'CAD' && !canadaProductPriceMap.containsKey(priceListObj.ccrz__Product__c)){
                        canadaProductPriceMap.put(priceListObj.ccrz__Product__c,priceListObj);
                    }
                    
                }  
            }
            System.debug('usaProductPriceMap===='+usaProductPriceMap);
            System.debug('canadaProductPriceMap===='+canadaProductPriceMap);  

            //@Vishnu Core Price  28th Feb 2022            
            List<ccrz__E_PriceListItem__c> priceListCoreRecords =  [SELECT Id,ccrz__Pricelist__r.ccrz__CurrencyISOCode__c,CurrencyIsoCode,ccrz__Price__c,dbu_Original_Price__c,ccrz__Product__c FROM ccrz__E_PriceListItem__c WHERE ccrz__Product__c IN :relatedProdIds.keyset() AND ccrz__Price__c != null];
            if(priceListCoreRecords.size() > 0){
                for(ccrz__E_PriceListItem__c priceListCoreObj : priceListCoreRecords){
                    if(priceListCoreObj.ccrz__Pricelist__r.ccrz__CurrencyISOCode__c == 'USD' && !usaCoreProductPriceMap.containsKey(priceListCoreObj.ccrz__Product__c)){
                        if(relatedProdIds.containsKey(priceListCoreObj.ccrz__Product__c)) {
                            for(Id mainPartId : relatedProdIds.get(priceListCoreObj.ccrz__Product__c)){
                                usaCoreProductPriceMap.put(mainPartId,priceListCoreObj);
                            }                            
                        }
                    }
                    if(priceListCoreObj.ccrz__Pricelist__r.ccrz__CurrencyISOCode__c == 'CAD' && !canadaCoreProductPriceMap.containsKey(priceListCoreObj.ccrz__Product__c)){
                        if(relatedProdIds.containsKey(priceListCoreObj.ccrz__Product__c)) {
                            for(Id mainCAPartId : relatedProdIds.get(priceListCoreObj.ccrz__Product__c)){
                                canadaCoreProductPriceMap.put(mainCAPartId,priceListCoreObj);
                            } 
                        }
                    }
                    
                }  
            }
            
            //==========Inventory Check==============
            
            List<ccrz__E_ProductInventoryItem__c> inventoryList =  [SELECT Id,ccrz__QtyAvailable__c, CurrencyIsoCode,ccrz__ProductItem__c FROM ccrz__E_ProductInventoryItem__c WHERE ccrz__ProductItem__c IN :prodListIds];
            if(inventoryList.size() > 0){
                for(ccrz__E_ProductInventoryItem__c invObj : inventoryList){
                    if(invObj.CurrencyIsoCode == 'USD' && !usaInventoryMap.containsKey(invObj.ccrz__ProductItem__c)){
                        usaInventoryMap.put(invObj.ccrz__ProductItem__c,Integer.valueOf(invObj.ccrz__QtyAvailable__c));
                    } else if(invObj.CurrencyIsoCode == 'USD' && usaInventoryMap.containsKey(invObj.ccrz__ProductItem__c)){
                        Integer updatedQty = Integer.valueOf(invObj.ccrz__QtyAvailable__c) + usaInventoryMap.get(invObj.ccrz__ProductItem__c);
                        usaInventoryMap.put(invObj.ccrz__ProductItem__c,updatedQty);
                    }
                    
                    if(invObj.CurrencyIsoCode == 'CAD' && !canadaInventoryMap.containsKey(invObj.ccrz__ProductItem__c)){
                        canadaInventoryMap.put(invObj.ccrz__ProductItem__c,Integer.valueOf(invObj.ccrz__QtyAvailable__c));
                    } else if(invObj.CurrencyIsoCode == 'CAD' && canadaInventoryMap.containsKey(invObj.ccrz__ProductItem__c)){
                        Integer updatedQty = Integer.valueOf(invObj.ccrz__QtyAvailable__c) + canadaInventoryMap.get(invObj.ccrz__ProductItem__c);
                        canadaInventoryMap.put(invObj.ccrz__ProductItem__c,updatedQty);
                    }
                }
            }
            
            //============Product Specs =============
            List<ccrz__E_ProductSpec__c> prodSpecList = [SELECT  id,ccrz__Spec__r.Name,ccrz__SpecValue__c,ccrz__Product__c FROM ccrz__E_ProductSpec__c WHERE ccrz__Product__c IN : prodListIds  AND ccrz__Spec__r.Name =: 'Shipment Weight'];
            if(prodSpecList.size() > 0){
                for(ccrz__E_ProductSpec__c specsObj : prodSpecList){
                    Decimal weightValue = 0.00;
                    if(specsObj.ccrz__SpecValue__c.contains('')){
                        weightValue = Decimal.valueOf(specsObj.ccrz__SpecValue__c.substringBefore(' '));
                    }else{
                        weightValue = Decimal.valueOf(specsObj.ccrz__SpecValue__c);
                    }
                    productSpecMap.put(specsObj.ccrz__Product__c,weightValue);
                }
            }
            
            List<Google_Feed__c> feedList = new List<Google_Feed__c>();
            List<Google_Canada_Feed__c> canadaFeedList = new List<Google_Canada_Feed__c>();
            //==========Mapping google merchange attribute=======
            for(ccrz__E_Product__c productObj : (List<ccrz__E_Product__c>) scope){
                String title;
                String id;
                String description;
                String link;
                String image_link;
                String condition = 'New';
                String brand;
                String shippingweight;
                String priceUsa;
                String priceCanada;
                String salePriceUsa;
                String salePriceCanada;
                Integer totalQtyUsa = 0;
                integer totalQtyCanada = 0;
                String availabilityUsa;
                String availabilityCanada;
                String additionalImages;
                String mpn;
                
                title = productObj.Name;
                mpn = productObj.dbu_Part_Number__c;
                id = productObj.dbu_Part_Number__c;
                if(String.isNotBlank(productObj.ccrz__LongDescRT__c)){
                    description = productObj.ccrz__LongDescRT__c;
                }else{
                    description = productObj.Name;
                }
                /*>>>>>>> Mapping product weight >>>>>>>*/
                
                if(productSpecMap.containsKey(productObj.Id)){
                    shippingweight = String.valueOf(productSpecMap.get(productObj.Id))+ ' lbs';
                }else{
                    shippingweight = '0.00 lbs';
                }
                
                /*>>>>>>>>>> Mapping product url >>>>>>>>*/
                
                String prodName = productObj.Name.toLowercase();
                prodName = prodName.replaceAll('[^a-zA-Z0-9\\s+]', '');
              /*  if(prodName.contains('/')){
                    prodName = prodName.replace('/', '-');
                }
                if(prodName.contains('-')){
                    prodName = prodName.replace('-', '');
                }*/
                if(prodName.containsWhitespace()){
                   // prodName = prodName.deleteWhitespace();
                   prodName = prodName.replace(' ', '-');
                }
                if(prodName.contains('--')){
                    prodName = prodName.replace('--', '-');
                }
                link = System.Label.CommunityDomain + System.Label.dbu_communityName + 'product/' + productObj.Id + '/' + prodName;
                
                /*>>>>>>>> Mapping Image url >>>>>>>>>>>>>>>>>>>>>>>>*/
                
                if(prodMediaMap.containsKey(productObj.Id)){
                    if(imageUrlMap.containsKey(prodMediaMap.get(productObj.Id))){
                        image_link = imageUrlMap.get(prodMediaMap.get(productObj.Id));
                    }
                }
                if(String.isBlank(image_link)){
                    image_link = System.Label.dbu_DefaultProductImage;
                }
                
                /*>>>>>>>> Mapping additional Image url >>>>>>>>>>>>>>>>>>>>>>>>*/
                if(prodAdditionalImgMap.containsKey(productObj.Id)){
                    List<String> thumbnailURI = prodAdditionalImgMap.get(productObj.Id);
                    String imgUrl;
                    for(Integer i=0; i<thumbnailURI.size(); i++ ){
                        if(imageUrlMap.containsKey(thumbnailURI[i])){
                            if(String.isNotBlank(imgUrl)){
                                imgUrl =  imgUrl + imageUrlMap.get(thumbnailURI[i])+ ',' ;
                            }else{
                                imgUrl =  imageUrlMap.get(thumbnailURI[i])+ ',';
                            }
                        }else{
                            if(String.isNotBlank(imgUrl)){
                                imgUrl =  imgUrl + System.Label.dbu_DefaultProductImage + ',' ;    
                            }else{
                                imgUrl =  System.Label.dbu_DefaultProductImage + ',' ;
                            }
                            
                        }
                    }
                    
                    additionalImages = imgUrl;
                }else{
                    additionalImages = System.Label.dbu_DefaultProductImage;
                }
                
                /*>>>>>>>> To get price of every product >>>>>>>>>>>>*/  

                //@Vishnu Core Price  28th Feb 2022 
                Decimal coreOrgPrice = 0.00, corePrice = 0.00;
                if(usaCoreProductPriceMap.containsKey(productObj.Id)){
                    if(usaCoreProductPriceMap.get(productObj.Id) != null){
                        coreOrgPrice = usaCoreProductPriceMap.get(productObj.Id).dbu_Original_Price__c != null ? usaCoreProductPriceMap.get(productObj.Id).dbu_Original_Price__c : 0.00;
                        corePrice = usaCoreProductPriceMap.get(productObj.Id).ccrz__Price__c != null ? usaCoreProductPriceMap.get(productObj.Id).ccrz__Price__c : 0.00;
                    }
                }

                if(usaProductPriceMap.containsKey(productObj.Id)){
                    if(usaProductPriceMap.get(productObj.Id).dbu_Original_Price__c == null){
                        priceUsa =  usaProductPriceMap.get(productObj.Id).ccrz__Price__c + corePrice + ' USD';
                        salePriceUsa = ' ';
                    }else{
                        priceUsa =  usaProductPriceMap.get(productObj.Id).dbu_Original_Price__c + coreOrgPrice + ' USD';
                        salePriceUsa  = usaProductPriceMap.get(productObj.Id).ccrz__Price__c + corePrice + ' USD';
                    }
                    
                }else{
                    priceUsa = 'Price Not Available';
                }
                
                //@Vishnu Core Price  28th Feb 2022 
                Decimal coreCAOrgPrice = 0.00, coreCAPrice = 0.00;
                if(canadaCoreProductPriceMap.containsKey(productObj.Id)){
                    if(canadaCoreProductPriceMap.get(productObj.Id) != null){
                        coreCAOrgPrice = canadaCoreProductPriceMap.get(productObj.Id).dbu_Original_Price__c != null ? canadaCoreProductPriceMap.get(productObj.Id).dbu_Original_Price__c : 0.00;
                        coreCAPrice = canadaCoreProductPriceMap.get(productObj.Id).ccrz__Price__c != null ? canadaCoreProductPriceMap.get(productObj.Id).ccrz__Price__c : 0.00;
                    }
                } 

                if(canadaProductPriceMap.containsKey(productObj.Id)){
                    if(canadaProductPriceMap.get(productObj.Id).dbu_Original_Price__c == null){
                        priceCanada =  canadaProductPriceMap.get(productObj.Id).ccrz__Price__c + coreCAPrice + ' CAD';
                        salePriceCanada = ' ';
                    }else{
                        priceCanada =  canadaProductPriceMap.get(productObj.Id).dbu_Original_Price__c + coreCAOrgPrice + ' CAD';
                        salePriceCanada  = canadaProductPriceMap.get(productObj.Id).ccrz__Price__c + coreCAPrice + ' CAD';
                    }
                    
                }else{
                    priceCanada = 'Price Not Available';
                }
                
                /*>>>>>>>> Mapping the brand >>>>>>>>>>>>>>>>>>>>>>>>*/
                
                if(productBrandMap.containsKey(productObj.Id)){
                    brand = productBrandMap.get(productObj.Id);
                }else{
                    brand = 'Cummins';
                }
                
                /*>>>>>>>> Mapping product quantiy >>>>>>>>>>>>*/ 
                if(usaInventoryMap.containsKey(productObj.Id)){
                    totalQtyUsa = usaInventoryMap.get(productObj.Id);
                }else{
                    totalQtyUsa = 0;
                }
                
                if(canadaInventoryMap.containsKey(productObj.Id)){
                    totalQtyCanada = canadaInventoryMap.get(productObj.Id);
                }else{
                    totalQtycanada = 0;
                }
                
                if(totalQtyUsa > 0){
                    availabilityUsa = 'in_stock';
                }else{
                    availabilityUsa = 'out_of_stock';
                }
                
                if(totalQtyCanada > 0){
                    availabilityCanada = 'in_stock';
                }else{
                    availabilityCanada = 'out_of_stock';
                }
                
                /*>>>>>>>>> Not adding the product which does not have price >>>>>>>>>>>>>>>*/
                
                if(priceUsa != 'Price Not Available' && brand != 'Yamaha'){
                    
                    Google_Feed__c feed = new Google_Feed__c();
                    feed.id__c = id;
                    feed.mpn__c = mpn;
                    feed.title__c = title;
                    feed.description__c = description;
                    feed.link__c = link;
                    feed.image_link__c = image_link;
                    feed.price__c = priceUsa;
                    feed.condition__c = condition;
                    feed.availability__c = availabilityUsa;
                    feed.brand__c = brand;
                    feed.shipping_weight__c = shippingweight;
                    feed.sale_price__c = salePriceUsa;
                    feed.additional_image_link__c = additionalImages;
                    feed.Status__c = productObj.ccrz__ProductStatus__c;
                    feed.CurrencyIsoCode = 'USD';
                    feedList.add(feed);
                }
                if(priceCanada != 'Price Not Available'){
                    Google_Canada_Feed__c feed = new Google_Canada_Feed__c();
                    feed.id__c = id;
                    feed.mpn__c = mpn;
                    feed.title__c = title;
                    feed.description__c = description;
                    feed.link__c = link + '/?store=EN';
                    feed.image_link__c = image_link;
                    feed.price__c = priceCanada;
                    feed.condition__c = condition;
                    feed.availability__c = availabilityCanada;
                    feed.brand__c = brand;
                    feed.shipping_weight__c = shippingweight;
                    feed.sale_price__c = salePriceCanada;
                    feed.additional_image_link__c = additionalImages;
                    feed.Status__c = productObj.ccrz__ProductStatus__c;
                    feed.CurrencyIsoCode = 'CAD';
                    canadaFeedList.add(feed);
                } 
            }
            if(feedList.size() > 0){
                
                //upsert feedList id__c;
                Database.UpsertResult[] srList  = Database.upsert(feedList, Google_Feed__c.id__c,false);
                for (Integer i = 0; i < srList.size(); i++){
                    if (!srList[i].isSuccess()){
                        this.counter++;
                        this.log += '\n Error in USA Product: ' + feedList[i].title__c + '. Error msg=' + srList[i].getErrors()[0].getMessage();
                    }
                }
            }
            
            if(canadaFeedList.size() > 0){
               // upsert canadaFeedList id__c;
                Database.UpsertResult[] srList  = Database.upsert(canadaFeedList, Google_Canada_Feed__c.id__c,false);
               for (Integer i = 0; i < srList.size(); i++){
                    if (!srList[i].isSuccess()){
                        this.counter++;
                       this.log += '\n Error in Canada Product : ' + canadaFeedList[i].title__c + '. Error msg=' + srList[i].getErrors()[0].getMessage();
                    }
                }
            }
            
            if(this.counter > 0){
                createErrorLog(500,this.log,'','','Google Merchant','Exception');
            }
        } catch(Exception e) {
            System.debug('The following exception has occurred: ' + e.getMessage());
            createErrorLog(500,e.getMessage(),'','','Google Merchant','Exception');
        }
    }
    
    global void finish(Database.BatchableContext BC){
        
    }
    
     public static void createErrorLog(Integer ErrorCode,String ErrorDescription,String Request, String Response,String ServiceName,String Status){
        
        dbu_Integration_Error_Log.createErrorLog(ErrorCode,ErrorDescription,Request,Response,ServiceName,Status);
    } 
    
}