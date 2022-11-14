global class OSM_SW_ProductCatalogue_Ctrl
 {

    global String Categorylist{set;get;}
    global string sCategoryId{get;set;}
     global boolean Isguest{set;get;}
    global string dummy{get;set;}
    
    global OSM_SW_ProductCatalogue_Ctrl(){
    
        Isguest = ccrz.cc_CallContext.isGuest;
    
    
    ccrz.ccLog.log(System.LoggingLevel.DEBUG,'Guest User', +Isguest);
    
    
    sCategoryID =  Apexpages.currentPage().getParameters().get('categoryId');
    ccrz.ccLog.log('sCategoryID => ' + sCategoryID); 
    Categorylist = [select Name from ccrz__E_Category__c where id = :sCategoryID  LIMIT 1].Name;
        
}
    
    global class FeaturedProductsForCategory
    {
        global Boolean Featured;
        global Boolean isGuest;
        global String shortDesc;
        global String prodName;
        global String id;
        global String sku;
        global String skuNumber;
        global List<MediaWrapper> mediaWrapper;
        global ProductImage prodImage;
        global Integer availableCount;
        global Integer totalSubscriptionCount;
        global Boolean isDAmsg;
        global String daMsg;
        //global OSM_WS_GetProductDetail_RES productsDetailFromAPI;
        
    }
    
    global class DAProductApiDataWrapper{
        
        
    }
    
    global class MediaWrapper
    {
        global List<ProductImage> productImageLst;
    }
    
    global class ProductImage
    {
        global string uri { get; set; }
        global object productDescription { get; set; }
        global string mediaName { get; set; }
        global object altMessage { get; set; }
        global string sourceType { get; set; }
    }
    
 
     @RemoteAction
    global static ccrz.cc_RemoteActionResult getFeaturedProductsForCategory(ccrz.cc_RemoteActionContext ctx, String Input){
         ccrz.ccLog.log(System.LoggingLevel.ERROR,'M:S','INside getFeaturedProductsForCategory with Json => ');
          ccrz.ccLog.log(System.LoggingLevel.DEBUG,'TEST FOR LOG');
         String [] inputArray =  Input.split('/');
         String userId = '';
        if(inputArray.size()>=1){
            userId = inputArray[0];
        }
        String categoryId = '';
        if(inputArray.size()>=2){
            categoryId = inputArray[1];
        }
       
        System.debug('====INside getFeaturedProductsForCategory===='+categoryId);
        ccrz.cc_CallContext.initRemoteContext(ctx);
        ccrz.cc_RemoteActionResult result = new ccrz.cc_RemoteActionResult();
        result.success = false;
        
          //Account acc = OSM_SW_ProdDetailUtils_Ctrl.getAccount(ccrz.cc_CallContext.currAccountId);
          Account acc = OSM_SW_ProdDetailUtils_Ctrl.getAccount(ccrz.cc_CallContext.effAccountId);
          
        User user = OSM_SW_ProdDetailUtils_Ctrl.getUserDetail(userId);
        List<FeaturedProductsForCategory> lst = new List<FeaturedProductsForCategory>();
        FeaturedProductsForCategory fProducts = null;
        List<ProductImage> productImageList = null;
        ProductImage pImage = null;
        MediaWrapper mediaWrapper = null;
        map<String,Object> returnDatasetMap = new map<String,Object>();
        
        string producttype = [select Name from ccrz__E_Category__c where id = :categoryId  LIMIT 1].Name;
        
        map<Id,FeaturedProductsForCategory> prodIdVsWrapperMap = new map<Id,FeaturedProductsForCategory>();
        Map<String,OSM_DA_GenericFunctionsUtility.DAProdCountInfo> prodCountMap = new Map<String,OSM_DA_GenericFunctionsUtility.DAProdCountInfo>();
        
        //map<String,Object> prodIdVsWrapperMap = new map<String,Object>();
        //OSM_WS_GetProductDetail_RES productsDetailFromAPI = OSM_WS_CS_Services.callGetProductsWS(String messageID, String timeStamp, String initiator, String customerID);
        String customerId = user.Contact.Account.CMI_Cid__c != null ? user.Contact.Account.CMI_Cid__c:'';
        List<OSM_WS_GetProductDetail_RES.ProductSubscriptionInfo> productSubscriptionInfo = null;
        OSM_WS_GetProductDetail_RES productsDetailFromAPI=null;
        try{
            //if(!ccrz.cc_CallContext.isGuest && producttype!='Electronic Service Tools' && producttype !='FluidWatch™'){
            //if(!ccrz.cc_CallContext.isGuest && producttype!='Electronic Service Tools' && producttype !='FluidWatch'){    
                if(!ccrz.cc_CallContext.isGuest && producttype!='Electronic Service Tools' &&  !producttype.containsIgnoreCase('FLuidWatch')){ 
                OSM_WS_GeneralizedInputWrapper inputAPiWrapper = new OSM_WS_GeneralizedInputWrapper();
                inputAPiWrapper.messageID = 'MSG1234';
                inputAPiWrapper.customerId = customerId;
                inputAPiWrapper.initiator = 'ECommerce';
                inputAPiWrapper.timeStamp='2018-03-20T19:47:00.000Z';
                //OSM_WS_GetProductDetail_RES productsDetailFromAPI = OSM_WS_CS_Services.callGetProductsWS('MSG1234', '2018-03-20T19:47:00.000Z', 'ECommerce', customerId);
                 
                        productsDetailFromAPI = OSM_WS_CS_Services.GetProductsWS(inputAPiWrapper);
                   
                    system.debug('productsDetailFromAPI==>'+productsDetailFromAPI);
                
                
                if(productsDetailFromAPI!=null){ 
                productSubscriptionInfo = productsDetailFromAPI.productSubscriptionInfo; 
                system.debug('productSubscriptionInfo==>'+productSubscriptionInfo);
                    
                if(productSubscriptionInfo.size()>0){
                    for(OSM_WS_GetProductDetail_RES.ProductSubscriptionInfo proInfo : productSubscriptionInfo){
                            OSM_DA_GenericFunctionsUtility.DAProdCountInfo prodInfo = new OSM_DA_GenericFunctionsUtility.DAProdCountInfo();
                                proInfo.productID = proInfo.productID + Label.OSM_Default_Market_Segment;
                                prodInfo.defaultDAProdPartNo=proInfo.productID;
                                prodInfo.availableCnt=proInfo.availableCount != null ? proInfo.availableCount : 0;
                                prodInfo.currentCnt=proInfo.totalSubscriptionCount != null ? proInfo.totalSubscriptionCount:0;
                                prodInfo.daMessage = proInfo.message != null ? proInfo.message : '';
                                prodCountMap.put(proInfo.productID,prodInfo);
                                //this will return the main product sku and wrapper
                            }                                                                                                                                                                               
                        }   
                prodCountMap = OSM_DA_GenericFunctionsUtility.fetchOSMParentProdAndCount(prodCountMap,acc.OSM_Market_Segment_Code__c);
                }
             }
         }catch(Exception e)      
        {
            system.debug('******ERROR | EXCEPTION while calling DA ');
        }
        //prodIdVsWrapperMap.put('DAAPI',productsDetailFromAPI);
        
        //Start logic to fetch the fetaured products
        system.debug('prodCountMap===>'+prodCountMap);
        boolean onlyOne = false;
       list<ccrz__E_FeaturedProduct__c>featureprodLst =  [select id,ccrz__Product__c, ccrz__Product__r.ccrz__ShortDesc__c,ccrz__Product__r.name,ccrz__Product__r.ccrz__SKU__c from ccrz__E_FeaturedProduct__c where CC_Category__c=:categoryId and ccrz__Enabled__c=true and ccrz__Product__r.ccrz__EndDate__c > Today and   ccrz__Product__r.ccrz__StartDate__c < today 
                                                     and ccrz__Product__r.ccrz__ProductStatus__c='Released' order by ccrz__Sequence__c];
        
        Set<String> categoryIdList = new Set<String>{categoryId};
        
        List<String>parentProductIds = new List<String>();
        for(ccrz__E_FeaturedProduct__c fProd : featureprodLst){
            parentProductIds.add(fProd.ccrz__Product__c);
        }
        List < ccrz__E_CompositeProduct__c > eCompositeProducts = OSM_SW_ProdDetailUtils_Ctrl.getCcrzCompositProducts(parentProductIds);
           Set<String> BaseSkuSet = new Set<String>();
           Map<String,String> ParentToBaseProdSku = new Map<String,String>();
           //ccrz__Component__r.Name, ccrz__Component__r.ccrz__SKU__c
           for (ccrz__E_CompositeProduct__c compProd: eCompositeProducts) {
            if(compProd.ccrz__Component__r.Name.containsIgnoreCase('Base')){
                BaseSkuSet.add(compProd.ccrz__Component__r.ccrz__SKU__c);
                ParentToBaseProdSku.put(compProd.ccrz__Composite__r.ccrz__SKU__c,compProd.ccrz__Component__r.ccrz__SKU__c);
            }
           }
 
        Map<String, Object> inputData = new Map<String, Object>{
            ccrz.ccAPICategory.CATEGORYIDLIST => categoryIdList,
            ccrz.ccAPI.API_VERSION => 3,
            ccrz.ccApiCategory.FEATURED=>True
        };
         
        try {
            System.debug('====Calling ccAPICategory==');
            Map<String, Object> outputData = ccrz.ccAPICategory.fetch(inputData);
            System.debug('outputData----'+outputData);
            if (outputData.get(ccrz.ccAPICategory.CATEGORYLIST) != null) {
                // The cast to List<Map<String, Object>> is necessary...
                List<Map<String, Object>> outputCategoryList = (List<Map<String, Object>>) outputData.get(ccrz.ccAPICategory.CATEGORYLIST);
          System.debug('outputCategoryList----'+outputCategoryList);
                 // The cast, again, is necessary...
                String categoryName = (String) outputCategoryList[0].get('sfdcName');
                System.debug('categoryName----'+categoryName);
                ccrz.ccLog.log(System.LoggingLevel.DEBUG,'M:S','categoryName----'+categoryName);
                for( Map<String, Object> mp:outputCategoryList)
                {
                     for(String key:mp.keySet())
                     {
                        
                        System.debug('Key----'+key);
                        System.debug('Value----'+mp.get(key));
                         ccrz.ccLog.log(System.LoggingLevel.DEBUG,'M:S','Key----'+key);
                         ccrz.ccLog.log(System.LoggingLevel.DEBUG,'M:S','Value----'+mp.get(key));
                     }
                }
            }
        } catch (Exception e) {
            // Error handling...
            System.debug('****Exception in fetching the featured products*****-');
             ccrz.ccLog.log(System.LoggingLevel.ERROR,'M:X','****Exception in fetching the featured products*****');
        }
        
        
        
        if(featureprodLst!=null && featureprodLst.size()>0){
        for(ccrz__E_FeaturedProduct__c featureProd : featureprodLst)
        {
            fProducts = new FeaturedProductsForCategory();
            fProducts.shortDesc = featureProd.ccrz__Product__r.ccrz__ShortDesc__c;
            fProducts.id = featureProd.id;
            fProducts.isGuest = ccrz.cc_CallContext.isGuest;
            //fProducts.prodName='Connected Advisor Temp';
            fProducts.prodName=featureProd.ccrz__Product__r.name;
            fProducts.Featured = true;
            fProducts.sku=featureProd.ccrz__Product__r.ccrz__SKU__c;
            fProducts.skuNumber=featureProd.ccrz__Product__r.ccrz__SKU__c.contains('-')?featureProd.ccrz__Product__r.ccrz__SKU__c.split('-')[0]:featureProd.ccrz__Product__r.ccrz__SKU__c;
            String baseSku = ParentToBaseProdSku.get(featureProd.ccrz__Product__r.ccrz__SKU__c)!=null?ParentToBaseProdSku.get(featureProd.ccrz__Product__r.ccrz__SKU__c):'';
            system.debug('baseSku==>'+baseSku);
            String baseSkuNumber = baseSku.contains('-')?baseSku.split('-')[0]:baseSku;
            Map<String, String> baseToParentSku = OSM_DA_GenericFunctionsUtility.fetchDefaultDAProductPartNumber(new List<String>{baseSku});
            system.debug('baseToParentSku==>'+baseToParentSku);
             String defSku = baseToParentSku.get(baseSku) != null?baseToParentSku.get(baseSku):'';
             String defaultPort = defSku.contains('-')?defSku.split('-')[0]:defSku; 
            //fProducts.productsDetailFromAPI = productsDetailFromAPI;
            //boolean prodMatched = false;
            if(productSubscriptionInfo != null && productSubscriptionInfo.size()>0 && !onlyOne){
                for(OSM_WS_GetProductDetail_RES.ProductSubscriptionInfo proInfo : productSubscriptionInfo){
                        fProducts.totalSubscriptionCount = 0;
                            fProducts.availableCount = 0;
                            system.debug(proInfo.productID == defaultPort+'<===>'+proInfo.productID+' == '+defaultPort);
                        if(proInfo.productID == defaultPort){
                            OSM_DA_GenericFunctionsUtility.DAProdCountInfo prodInfoReturn = prodCountMap.get(featureProd.ccrz__Product__r.ccrz__SKU__c);
                            fProducts.totalSubscriptionCount =  prodInfoReturn.currentCnt != null ? prodInfoReturn.currentCnt:0;
                            fProducts.availableCount = prodInfoReturn.availableCnt != null ? prodInfoReturn.availableCnt : 0;
                            fProducts.daMsg =  prodInfoReturn.daMessage != null ? prodInfoReturn.daMessage : '';
                            fProducts.isDAmsg = false;
                            if(fProducts.totalSubscriptionCount ==0 && fProducts.availableCount==0 && !String.isBlank(fProducts.daMsg)){
                                fProducts.isDAmsg = true;
                            }
                            break;
                        }
                
                }
                
            }
            system.debug('fProducts==>'+fProducts);
            prodIdVsWrapperMap.put(featureProd.ccrz__Product__c,fProducts);
            
            /*
            pImage = new ProductImage();
            pImage.uri='https://cumminscss--eidmdev--c.cs61.visual.force.com/resource/1519142506000/Truckproductlist';
            pImage.productDescription='Sample productDescription';
            pImage.sourceType='URI';
            fProducts.prodImage=pImage;
            */
            
            
            
            //productImageList = new List<ProductImage>();
            //productImageList.add(pImage);
            //mediaWrapper.productImageLst = productImageList;
            
            //fProducts.mediaWrapper=mediaWrapper;
            //fProducts.mediaWrappers="Product Image":[{"uri":"00P4C000000bcxfUAA","productDescription":null,"mediaName":"IA.JPG","altMessage":null,"sourceType":"Attachment"}];
            
            //lst.add(fProducts);
            
            
        }
        }
        
        List<ccrz__E_ProductMedia__c> mediaLst = [select id,ccrz__Product__c,(select id,name from attachments) from ccrz__E_ProductMedia__c where ccrz__MediaType__c='Product Search Image' and ccrz__Product__c in :prodIdVsWrapperMap.keySet()];
        FeaturedProductsForCategory productWrapper;
        for(ccrz__E_ProductMedia__c media : mediaLst)
        {
            
            for(attachment a:media.attachments) {
                 pImage = new ProductImage();
                 pImage.productDescription='Sample productDescription 3';
                 pImage.sourceType='Attachment';
                 pImage.uri=a.id;
                 pImage.mediaName=a.name;
                 productWrapper = prodIdVsWrapperMap.get(media.ccrz__Product__c);
                 if(productWrapper!=null)
                 {
                    productWrapper.prodImage=pImage;
                 }    
             }
        
        }
        
        
            lst.addAll(prodIdVsWrapperMap.values());
            returnDatasetMap.put('0',lst);
            returnDatasetMap.put('1',productsDetailFromAPI);
            returnDatasetMap.put('2',ccrz.cc_CallContext.isGuest);
            returnDatasetMap.put('3',prodCountMap);
            /*
            fProducts = new FeaturedProductsForCategory();
            fProducts.shortDesc = 'Tmp Discussion';
            fProducts.id = '';
            fProducts.prodName='Connected Advisor Temp 2';
            fProducts.Featured = true;
            pImage = new ProductImage();
            pImage.uri='https://cumminscss--eidmdev--c.cs61.visual.force.com/resource/1519142506000/Truckproductlist';
            pImage.productDescription='Sample productDescription 2';
          
            pImage.sourceType='URI';
            fProducts.prodImage=pImage;
            lst.add(fProducts);
            fProducts = new FeaturedProductsForCategory();
            fProducts.shortDesc = 'Tmp Discussion 3';
            fProducts.id = '';
            fProducts.prodName='Connected Advisor Temp 3';
            fProducts.Featured = true;
            pImage = new ProductImage();
            pImage.uri='https://cumminscss--eidmdev--c.cs61.visual.force.com/resource/1519142506000/Truckproductlist';
            pImage.productDescription='Sample productDescription 3';
            pImage.sourceType='URI';
            fProducts.prodImage=pImage;
            lst.add(fProducts);
            */
            
            
         result.data = returnDatasetMap;
         ccrz.ccLog.log(System.LoggingLevel.ERROR,'M:X',lst );
         System.debug('====INside getFeaturedProductsForCategory===='+lst);
         result.success = true;
        return result;
    }
    
     
       @RemoteAction
    global static ccrz.cc_RemoteActionResult getImageForCategory(ccrz.cc_RemoteActionContext ctx, String categoryId){
        
       
         ccrz.ccLog.log(System.LoggingLevel.ERROR,'M:S','INside getImageForCategory => ' +categoryId);
        System.debug('====INside getImageForCategory===='+categoryId);
        
        ccrz.cc_CallContext.initRemoteContext(ctx);
        ccrz.cc_RemoteActionResult result = new ccrz.cc_RemoteActionResult();
        result.success = false;
        
        FeaturedProductsForCategory fProducts = new FeaturedProductsForCategory();
        ProductImage pImage;
   
        List<ccrz__E_CategoryMedia__c> mediaLst = [select id,(select id,name from attachments) from ccrz__E_CategoryMedia__c where ccrz__Category__c=:categoryId];
        pImage = new ProductImage();
        
        pImage.productDescription='Sample productDescription 3';
        //pImage.mediaName='Banner_Productivity.JPG';
        pImage.sourceType='Attachment';
        if(mediaLst!=null && mediaLst.size()>0)
        {
            ccrz__E_CategoryMedia__c media = mediaLst[0];
            for(attachment a:media.attachments) {
                 //pImage.uri='00P4C000000bdQr';
                 pImage.uri=a.id;
                 pImage.mediaName=a.name;
             }
        }
        
            
    
       /*if(categoryId == 'a1S4C000000L6TpUAK')   //productivity category Id
        {
            pImage = new ProductImage();
            pImage.uri='00P4C000000bdQr';
            pImage.productDescription='Sample productDescription 3';
            pImage.mediaName='Banner_Productivity.JPG';
            pImage.sourceType='Attachment';
            
        }
        else 
        {
            pImage = new ProductImage();
            pImage.uri='00P4C000000bdTl';
            pImage.productDescription='Sample productDescription 4';
            pImage.mediaName='Banner_Compliance.jpg';
            pImage.sourceType='Attachment';
        } 
        */
            

           
            fProducts.prodImage = pImage;
             System.debug('----fProducts---'+fProducts);
            result.data = fProducts;
            result.success = true;
            
            
            return result;
            
      }
    
    
}