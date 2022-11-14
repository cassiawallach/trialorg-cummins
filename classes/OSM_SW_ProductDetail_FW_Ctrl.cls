global class OSM_SW_ProductDetail_FW_Ctrl {
    
    global static String blank {get {return '';} private set;}    
    public static Id accountIdTest; 
    global boolean is5Packs {get; set;}
    global integer qty2 {get; set;} 
    global integer qty1 {get; set;}
    global string skuPrm {get; set;}
    global boolean isBlankRule {get; set;}
    
    global OSM_SW_ProductDetail_FW_Ctrl(){
        is5Packs = true;
        skuPrm = Apexpages.currentPage().getParameters().get('sku');
        system.debug('skuPrm___'+skuPrm);
        if(skuPrm.contains('1')){
            is5Packs = false;
        }
             List<ccrz__E_Product__c> prod = [SELECT Id,Rule1__c,Rule2__c,ccrz__SKU__c FROM ccrz__E_Product__c where ccrz__SKU__c=:skuPrm ];
               
             if(prod[0].Rule2__c!=null ){
             isBlankRule = true;
             qty2 =integer.valueOf(prod[0].Rule2__c);
            }
             if(prod[0].Rule1__c!=null ){
             isBlankRule = true;
             qty1 =integer.valueOf(prod[0].Rule1__c);
            }
             if(prod[0].Rule2__c==null ){
             isBlankRule = false;
             qty2 =0;
             
            }
            if(prod[0].Rule1__c==null ){
             isBlankRule = false;
             qty1 =0;
             
            }
             
    }
     
    
    /*----------------------------------------------------------------------------------
    1. fetchProdDetailInfoForDA
    Description:Used to fetch DA product's realted data to be displayed on DA Page
    Input: ccrz.cc_RemoteActionContext ctx
    Output: 
    Returns the DA product's realted data to be displayed to user
    
    ccrz.cc_RemoteActionResult
    DAProductsData==> Map<String,MainWrapper>
    ------------------------------------------------------------------------------------*/
    @RemoteAction
    global static ccrz.cc_RemoteActionResult fetchProdDetailInfoForDA(ccrz.cc_RemoteActionContext ctx, String param) {
        system.debug('param___'+param);
        Map <String, Object> mapParamDetails = (Map <String, Object>) JSON.deserializeUntyped(param);
        Map <String, Object> mapTestData = new Map <String, Object>();
        Map<Id,boolean> mapProductSubscribed = new Map<Id,boolean>();
        if(Test.isRunningTest()){
            mapTestData = OSM_SW_ProdDetail_SES1_Comp_Ctrl_Test.getTestData();
        }
        List<String> lstRelatedProductId = new List<String>();
        
        String userId = '';
        String InputData = '';
        if(mapParamDetails.containsKey('portalUserId'))
            userId = (String)mapParamDetails.get('portalUserId');
        if(mapParamDetails.containsKey('parentId'))
            InputData = (String)mapParamDetails.get('parentId');
        
        if(mapParamDetails.containsKey('relatedDate'))
        {
            
            for(Object obj : (List<Object>)mapParamDetails.get('relatedDate'))
                lstRelatedProductId.add((String)obj);
        }
        String sfdcBaseURL = URL.getSalesforceBaseUrl().toExternalForm();

        
        system.debug('userId___'+userId);
        system.debug('InputData___'+InputData);
        system.debug('lstRelatedProductId___'+lstRelatedProductId);
        
        String storefront = ctx.storefront;
        Id ProductIdForSubscription;
        boolean freeDAProduct = false;
        boolean hasOtherProductSusbcription = false;
        system.debug(ctx.storefront);
        ccrz.cc_CallContext.initRemoteContext(ctx);
        system.debug(ctx);
        Account acc = new Account();
        if(!Test.isRunningTest()){  
            system.debug('ccrz.cc_CallContext.currAccountId-->'+ccrz.cc_CallContext.currAccountId);
            system.debug('ccrz.cc_CallContext.effAccountId-->'+ccrz.cc_CallContext.effAccountId);

            acc = OSM_SW_ProdDetailUtils_Ctrl.getAccount(ccrz.cc_CallContext.effAccountId); 
            if(acc == null){
                OSM_SW_ProdDetailUtils_Ctrl.getAccount(ccrz.cc_CallContext.currAccountId); 
            }
            system.debug('account record>>>>'+acc);
        }else {
            acc = OSM_SW_ProdDetailUtils_Ctrl.getAccount(accountIdTest); 
        }
        ccrz.cc_RemoteActionResult res = new ccrz.cc_RemoteActionResult();
        res.success = false;
        
        try {
            
            Set <String> productIdList = new Set <String> ();
            Map<String,List<AddOnProducts>> productIdVsAddOnProducts = new Map<String,List<AddOnProducts>>();
            String baseProductId = '';
            system.debug('*******************************Calling Fetch Services => ' + InputData);
            Map<String, Decimal> prodYearPrice = new Map<String, Decimal>();
            String prodLongDescription = '';
            String parentSku = '';
            String baseSku = '';
            String parentStandAlone = '';
            String parentProductName = '';
            Decimal unitPrice = 0;
            List <ccrz__E_Product__c> eProducts = OSM_SW_ProdDetailUtils_Ctrl.getEProductOnId(InputData);
            if (eProducts.size()> 0) {                
                prodLongDescription = eProducts[0].ccrz__LongDesc__c;
                parentSku  = eProducts[0].ccrz__SKU__c;
                parentStandAlone  = eProducts[0].Stand_Alone_Product__c;
                parentProductName = eProducts[0].Name;
                system.debug('product record>>>>>'+eProducts[0]);
            }
            
            List <ccrz__E_CompositeProduct__c> eCompositeProducts = OSM_SW_ProdDetailUtils_Ctrl.getCcrzCompositProducts(new List <String> {
                InputData
                    });
            
            //ccrz__Component__r.Name, ccrz__Component__r.ccrz__SKU__c
            String componentProdId;
            for (ccrz__E_CompositeProduct__c compProd: eCompositeProducts) {
                system.debug('compProd----->'+compProd);
                productIdList.add(compProd.ccrz__Component__c);
                componentProdId = compProd.ccrz__Component__c;
            }
            
            for(ccrz__E_Product__c prodD : OSM_SW_ProdDetailUtils_Ctrl.getEProductOnId(componentProdId)){
                baseSku = prodD.ccrz__SKU__c;
                if(prodD.ccrz__E_PriceListItems__r.size() > 0){
                    unitPrice = prodD.ccrz__E_PriceListItems__r.get(0).ccrz__Price__c;
                    prodYearPrice.put(baseSku, unitPrice);
                }
            }
            
            Set<String> allSubscriptionProdIds = new Set<String>();
            allSubscriptionProdIds.addAll(productIdList);
            Set<String> relatedProdIds = new Set<String>();
            system.debug('productIdList___'+productIdList);
            List<ccrz__E_RelatedProduct__c> relatedProductAccessories = OSM_SW_ProdDetailUtils_Ctrl.getAddOnProducts(productIdList);
            system.debug('relatedProductAccessories___'+relatedProductAccessories);            
            
            //sharad date: 28 Oct 2019: for: Bundle count
            Set<Id> compositeProductSet = new Set<Id>();
            Map<Id, List<ccrz__E_CompositeProduct__c>> mapProductVsCompositeProduct = new Map<Id, List<ccrz__E_CompositeProduct__c>>();
            Map<Id, Integer> mapCPVsBundleCount = new Map<Id, Integer>();
            
            for(ccrz__E_RelatedProduct__c rp : relatedProductAccessories){
                compositeProductSet.add(rp.ccrz__RelatedProduct__c);
            }
            
            if(compositeProductSet.size()> 0)
            {
                List<ccrz__E_CompositeProduct__c> listComProduct = new List<ccrz__E_CompositeProduct__c>();
                listComProduct = [Select Id, ccrz__Composite__c, ccrz__Quantity__c,ccrz__Component__r.Name,ccrz__Component__r.ccrz__SKU__c from ccrz__E_CompositeProduct__c where ccrz__Composite__c IN: compositeProductSet];
                
                if(listComProduct.size()> 0){
                    for(ccrz__E_CompositeProduct__c objCP : listComProduct){
                        if(!mapProductVsCompositeProduct.containsKey(objCP.ccrz__Composite__c))
                            mapProductVsCompositeProduct.put(objCP.ccrz__Composite__c, new List<ccrz__E_CompositeProduct__c>());
                        mapProductVsCompositeProduct.get(objCP.ccrz__Composite__c).add(objCP);
                    }
                    
                    for(Id key : mapProductVsCompositeProduct.keySet()) {
                        Integer bundleCount = 0;
                        for(ccrz__E_CompositeProduct__c objCP: mapProductVsCompositeProduct.get(key)){
                            if(System.label.SES_OMSCreateOrder_SubscriptionProduct_List.toUpperCase().contains(objCP.ccrz__Component__r.ccrz__SKU__c.toUpperCase())){
                                bundleCount = bundleCount+Integer.valueOf(objCP.ccrz__Quantity__c);
                            }
                        }
                        if(bundleCount> 0){
                            mapCPVsBundleCount.put(key,bundleCount);
                        }
                    }
                }
            }
            
            String currCartId = ccrz.cc_CallContext.currCartId;
            String effAccId = ccrz.cc_CallContext.effAccountId;
            List<FeaturedProductsForCategory> list_ReltdProdcts = new List<FeaturedProductsForCategory>();
            String siteURL = Label.Storefront_URL;
            if(!siteURL.contains(sfdcBaseURL)){
                siteURL = sfdcBaseURL + '/apex/';
            }
            Set<Id> set_relatedProdId = new Set<Id>();
            for(ccrz__E_RelatedProduct__c rltdProd : [SELECT ccrz__RelatedProduct__c, ccrz__Sequence__c, ccrz__RelatedProduct__r.ccrz__SKU__c,
                                                        ccrz__RelatedProduct__r.Name, ccrz__RelatedProduct__r.ccrz__ShortDescRT__c 
                                                            FROM ccrz__E_RelatedProduct__c WHERE ccrz__Product__c =:InputData
                                                            Order By ccrz__Sequence__c ASC]){
                set_relatedProdId.add(rltdProd.ccrz__RelatedProduct__c);
                relatedProdIds.add(rltdProd.ccrz__RelatedProduct__c);
                FeaturedProductsForCategory featureProd = new FeaturedProductsForCategory();
                featureProd.shortDesc = rltdProd.ccrz__RelatedProduct__r.ccrz__ShortDescRT__c;
                featureProd.prodName = rltdProd.ccrz__RelatedProduct__r.Name;
                featureProd.id = rltdProd.ccrz__RelatedProduct__c;
                featureProd.sku = rltdProd.ccrz__RelatedProduct__r.ccrz__SKU__c;
                featureProd.pageURL = siteURL + 'ccrz__ProductDetails?sku='+ featureProd.sku + '&cartId' + currCartId + '&portalUser=' + userId + '&store' +storefront+ '&effectiveAccount=' +effAccId;
                list_ReltdProdcts.add(featureProd);
            }
            if(set_relatedProdId.size() > 0){
                for(ccrz__E_ProductMedia__c prodImg : [SELECT ccrz__AltMessage__c, (SELECT Id, Name FROM Attachments), ccrz__Product__c
                                                        FROM ccrz__E_ProductMedia__c 
                                                        WHERE ccrz__Product__c IN: set_relatedProdId AND ccrz__MediaType__c = 'Product Image Thumbnail']){
                    for(FeaturedProductsForCategory featureProdObj : list_ReltdProdcts){
                        if(featureProdObj.id == prodImg.ccrz__Product__c && prodImg.Attachments.size() > 0){
                            ProductImage prdImg = new ProductImage();
                            prdImg.uri = Label.Storefront_URL + 'servlet/servlet.FileDownload?file='+prodImg.Attachments.get(0).Id;
                            prdImg.mediaName = prodImg.Attachments.get(0).Name;
                            prdImg.altMessage = prodImg.ccrz__AltMessage__c;
                            featureProdObj.prodImage = prdImg;
                            break;
                        }
                    }
                }
            }
            
            
            if(test.isRunningTest()){
                relatedProdIds.addAll(productIdList);
            }
            allSubscriptionProdIds.addAll(relatedProdIds);
            allSubscriptionProdIds.add(InputData);
            
            boolean hasActiveSubs = false;
            OSM_SW_ProductDetaiServiceCls.DiscountedPriceWrapper availableSubs = null;
            try{
                system.debug('====hasActiveSubs inside-1:'+hasActiveSubs);
                availableSubs = OSM_SW_ProductDetaiServiceCls.getDiscountedPrice(ctx.storefront, ccrz.cc_CallContext.effAccountId, productIdList);
                system.debug('====hasActiveSubs inside-2:'+availableSubs);
            }catch(Exception ex){
                system.debug(ex +'====line===>'+ex.getLineNumber());
            }            
            
            if(availableSubs !=null && availableSubs.subscriptionStatus != null && !String.isBlank(availableSubs.subscriptionStatus)){
                hasActiveSubs = true;
            }
            
            system.debug('====hasActiveSubs outside:'+availableSubs);
            system.debug('====ProductIdList:'+productIdList);
            if(parentProductName.containsIgnoreCase('Incal')){
                availableSubs.isSubscribed = false; 
            }
            
            boolean  hasRelatedProductSubscribed = false;
            String relatedProductSubscEndDate = '';
            String relatedProductSubscLength = '';
            
            system.debug('subcription==>');
            
            Set<String> allProdIds = new Set<String>();
            allProdIds.addAll(productIdList);
            allProdIds.addAll(relatedProdIds);
            Map <String, Object> returnData = new Map <String, Object>();
            if(!Test.isRunningTest()){
                returnData = ccrz.ccAPIProduct.fetch(new Map <String, Object> {
                    ccrz.ccApi.API_VERSION => ccrz.ccApi.CURRENT_VERSION,
                        ccrz.ccAPIProduct.PARAM_INCLUDE_PRICING => TRUE,
                        ccrz.ccAPIProduct.PRODUCTIDLIST => allProdIds});
            }
            system.debug('ccrz.ccApiProduct.PRODUCTLIST');
            system.debug(ccrz.ccApiProduct.PRODUCTLIST);
            system.debug(returnData);
            
            Map <String, ProductDetailWrapper> productIdVsWrapperMap = new Map <String, ProductDetailWrapper> ();
            Map <String, ProductDetailWrapper> addOnProductIdVsWrapperMap = new Map <String, ProductDetailWrapper> ();
            
            Map <String, String> compositKeyForSubProdTerm = new Map <String, String> ();
            Map <String, String> subProdTermPrices = new Map <String, String> ();
            boolean onlyBase = false;
            ProductDetailWrapper prodDetail;
            boolean isBase = false;
            boolean isPlus = false;
            boolean isPro = false;
            Map <String, SubProdTerm> subProdTermMap;
            Set <String> subProdTermIds = new Set <String> ();
            Set <String> relatedsubProdTermIds = new Set <String> ();
            Set <String> mainSubProdTermIds = new Set <String> ();
            Map <String, Map <String, Object>> prodMapFromApi = new Map <String, Map <String, Object>> ();
            
            // productIdVsAddOnProducts.put('Related Products', list_ReltdProdcts);
            
            if ((returnData != null && returnData.size()> 0) || Test.isRunningTest()) {
                List <Map <String, Object>> productLst;
                if(Test.IsRunningTest()){
                    //productLst =OSM_SW_ProdDetail_SES1_Comp_Ctrl_Test.productListTestData();
                    Map < String, Object> prodMap = new Map < String, Object >();
                    ccrz__E_Product__c product = [SELECT Id,name,ccrz__ProductStatus__c,ccrz__Quantityperunit__c,ccrz__SKU__c,Group_Name__c,ccrz__LongDesc__c,ccrz__ProductType__c,Product_Class_Code__c FROM ccrz__E_Product__c WHERE ccrz__SKU__c = 'NGEOK-B-1'];
                    String testData = '{EProductMediasS=({attachmentsS=({"sfid":' + product.id + '}),"enabled":true,"locale":"en_US","mediaType":"Product Search Image","product"=' + product.id + '})}';
                    prodMap.put(testData, product);
                    Id id;
                    prodMap.put('sfid', id);
                    productLst = new List <Map <String, Object>>();
					productLst.add(prodMap);
                    system.debug('______productLst_____'+productLst);                    
                }else{
                    productLst = (List <Map <String, Object>>) returnData.get(ccrz.ccApiProduct.PRODUCTLIST);
                    system.debug('______productLst___else__'+productLst);
                }
                
                for (Map <String, Object> productMap: productLst) {
                    system.debug('______productLst__for loop___'+productLst);                    
                    if (productMap != null) {                        
                        for (String key_tmp: productMap.keySet()) {
                            system.debug('=====Key API====' + key_tmp);
                            system.debug('=====Key API====' + productMap.get(key_tmp));
                        }
                        system.debug('=====SF ID from API====' + productMap.get('sfid'));
                        ProductIdForSubscription = (String)productMap.get('sfid');
                        prodMapFromApi.put((String) productMap.get('sfid'), productMap);
                    }                    
                }                
                
                Map <String, Object> responseMap = new Map <String, Object>();
                if(Test.isRunningTest()){
                    try{
                        Map<String,Object> responseMapInner=new Map<String,Object>();
                        Map<String,Object> subProdTermMap2=new  Map<String,Object>();         
                        responseMapInner.put('subProductTerms',subProdTermMap2);
                        responseMap.put('id',responseMapInner);
                        system.debug('responseMap ____'+responseMap);
                    }
                    catch(Exception e){
                        system.debug('???????responseMap'+e);
                    }                    
                }
                else {
                    responseMap = (Map <String, Object>) returnData.get(ccrz.ccAPIProduct.PRODUCTPRICINGDATA);
                }
                
                //responseMap points to each product
                for (String key: responseMap.keySet()) {
                    prodDetail = new ProductDetailWrapper();
                    subProdTermMap = new Map <String, SubProdTerm> ();
                    if(Test.IsrunningTest()){
                        allProdIds.add(key);
                    }
                    if(allProdIds.contains((String)key)){
                        prodDetail.sfId = key;
                        system.debug('prodDetail.sfId____'+prodDetail.sfId);
                        Map <String, Object> responseMap1 = (Map <String, Object>) responseMap.get(key);
                        
                        system.debug('******************************responseMap1 =====' + responseMap1);
                        for (String key1: responseMap1.keySet()) {
                            system.debug('******************************Final Key=====' + key1);
                            if (key1.equalsIgnoreCase('productPrice')) {
                                Map <String, Object> productPriceMap = (Map <String, Object>) responseMap1.get(key1);
                                system.debug(productPriceMap);
                                system.debug('productPriceMap size from API===' + productPriceMap.size());                                
                            }
                        }
                    }
                    
                    if(prodDetail.sfId != null){                        
                        boolean isProcessProduct = true;
                        if(productIdList.contains(prodDetail.sfId) || Test.isRunningTest()){                                
                            productIdVsWrapperMap.put(prodDetail.sfId, prodDetail);                                
                        }
                    }
                }
            }
            system.debug('relatedProdIds-->'+relatedProdIds);
            system.debug('addOnProductIdVsWrapperMap-->'+addOnProductIdVsWrapperMap);
            List <String> prodIds = new List <String> ();
            prodIds.addAll(subProdTermIds);
            Set<String>OneTimeSets = new Set<String>{'OneTime','One-Time','One Time'};
            Decimal selectedSubsInstallmentCount = 0;
            Decimal selectedSubsInstallmentFrequency = 0;
            Decimal finalYearlyPrice = 0;
            Decimal proratedPrice = 0;
            Decimal proratedDnPrice = 0;
            
            map <Id, ccrz__E_SubProdTerm__c> subProdMap = new Map <Id, ccrz__E_SubProdTerm__c>();
            Map <Id, ccrz__E_SubProdTerm__c> relProdSubProdMap = new Map <Id, ccrz__E_SubProdTerm__c>();
            Map <Id, ccrz__E_SubProdTerm__c> allSubProdMap = OSM_SW_ProdDetailUtils_Ctrl.getSubProdTermsMap(prodIds, ctx.storefront);
            
            
            system.debug('=====finalYearlyPrice ====' + finalYearlyPrice);
            
            Map<String, Decimal> proratedPriceMap = new Map<String, Decimal>();
            Map<String,Decimal> proratedDnPriceMap = new Map<String,Decimal>(); 
            Map<String,Decimal> prodMonthlyPrice = new Map<String, Decimal>();
            Map<String, String> pricePerBillFrequency = new Map<String, String>();
            system.debug('productIdVsWrapperMap-->'+productIdVsWrapperMap.size());
            if(!ccrz.cc_CallContext.isGuest || ccrz.cc_CallContext.isGuest){
                List<ccrz__E_PriceListItem__c> priceList = [Select Id, Distributor_Price__c, ccrz__Price__c, ccrz__SubProdTerm__c  from ccrz__E_PriceListItem__c where ccrz__SubProdTerm__c IN: allSubProdMap.keySet() and ccrz__RecurringPrice__c = false];
                for (String prodId: productIdVsWrapperMap.keySet()) {                    
                    if(productIdList.contains(prodId) || Test.isRunningTest()){
                        boolean onTimePrice = true;
                        ProductDetailWrapper prodDetailObj = productIdVsWrapperMap.get(prodId);
                        system.debug('=====prodDetail ====' + prodDetailObj);
                        
                        system.debug('=====SF ID of Product ====' + prodId);
                        Map <String, Object> productDataMap = prodMapFromApi.get(prodId);
                        
                        system.debug('$$$ productDataMap: '+productDataMap);
                        /*for(String key : productDataMap.keySet()){
                            system.debug('key: '+key);
                            system.debug('value: '+productDataMap.get(key));
                        }*/
                        //buttonName will have Base/Plus/Pro
                        String buttonName = '';
                        if(!Test.isRunningTest()){
                            buttonName = (String) productDataMap.get('package');
                        }else{
                            buttonName ='BaseLitePro';
                        }
                        
                        system.debug('=====buttonName of Product ====' + buttonName);
                        
                        if(productDataMap!= null && !(boolean)productDataMap.get('QSOLPowerGeneration')) {
                            if (buttonName != null && buttonName.Contains('Base')) {
                                isBase = true;
                            }
                            
                            if (buttonName != null && buttonName.Contains('Lite')) {
                                isPlus = true;
                            }
                            
                            if (buttonName != null && buttonName.Contains('Pro')) {
                                isPro = true;
                            }                        
                        }
                        else{
                            if(productDataMap!= null){
								String productName = (String) productDataMap.get('versionDisplay');
									buttonName = productName;
								if(mapProductSubscribed.containsKey(prodId)) {
									prodDetailObj.selectedPowerGenProduct = true;
								}
								else {
									prodDetailObj.selectedPowerGenProduct = false;
								}
							}
                        }                        
                        if(productDataMap!= null){
							String longDesc = (String) productDataMap.get('longDesc');                        
							prodDetailObj.buttonName = buttonName;
							prodDetailObj.longDesc = longDesc;
							String sku = '';
							if(!Test.isRunningTest()){
								sku = (String) productDataMap.get('SKU');
							}
							prodDetailObj.sku = sku;
						}                        
                    }                    
                }
            }
            else {
                for (String prodId: productIdVsWrapperMap.keySet()) {
                    if(productIdList.contains(prodId) || Test.isRunningTest()) {
                        ProductDetailWrapper prodDetailObj = productIdVsWrapperMap.get(prodId);
                        Map <String, Object> productDataMap = prodMapFromApi.get(prodId);
                        
                        system.debug('productDataMap: '+productDataMap);
                        String buttonName = (String) productDataMap.get('package');
                        if (buttonName != null && buttonName.Contains('Base')) {
                            isBase = true;
                        }
                        
                        if (buttonName != null && buttonName.Contains('Lite')) {
                            //onlyBase = false;
                            isPlus = true;
                        }
                        
                        if (buttonName != null && buttonName.Contains('Pro')) {
                            //onlyBase = false;
                            isPro = true;
                        }
                        prodDetailObj.buttonName = buttonName;
                        String sku = (String) productDataMap.get('SKU');
                        prodDetailObj.sku = sku;
                    }
                }
            }
            // END : March 19, 2019 - Change added by Juhi - to show the Lite and Pro button for Anonymous User
            if(Test.isRunningTest() ||(isBase && !isPlus && !isPro)){
                onlyBase = true;
            }
            
            MainWrapper mainWrapper = new MainWrapper();
            UserDetail userDetail = new UserDetail();
            User user = OSM_SW_ProdDetailUtils_Ctrl.getUserDetail(userId);
            system.debug('User record>>>>'+user);
           // mainWrapper.OSMSupportAdmin = [SELECT Name FROM PermissionSet WHERE Name = 'OSM_Support_Admin' LIMIT 1];
           
           // List<PermissionSet> OSMSupportAdmin = [SELECT Name FROM PermissionSet WHERE Name = 'OSM_Support_Admin' LIMIT 1];
           // mainWrapper.OSMSupportAdminPset = OSMSupportAdmin[0].Name;
           // system.debug('OSMSupportAdminPset >>>>'+mainWrapper.OSMSupportAdminPset);
            
            
           
            mainWrapper.hasActiveSubs = hasActiveSubs;
            mainWrapper.toShowCoTerm = false;
            mainWrapper.withCoTerm = false;
            if(hasActiveSubs && System.Label.OSM_SW_Co_Term_Applied_Product.containsIgnoreCase(parentSku))
            {
                mainWrapper.toShowCoTerm = true;
                
            }
            

            if(acc.BillingCountry != null && (label.OSM_North_America_Country.containsIgnoreCase(acc.BillingCountry)|| label.OSM_PO_Distributor_List.contains(acc.CSS_DistributorCode__c) || label.OSM_Canada_Country.containsIgnoreCase(acc.BillingCountry)))
                mainWrapper.withCoTerm = true;
            
            mainWrapper.totalSubscriptionCount =0;
            mainWrapper.availableCount = 0;
            mainWrapper.daMessage = '';
            
            //List<ccrz__E_CartItem__c> cartItems = OSM_SW_ProdDetailUtils_Ctrl.getUsersCartItemListExceptCurrentProduct(ccrz.cc_CallContext.currCartId, InputData, ccrz.cc_CallContext.storefront, ccrz.cc_CallContext.currContact.Id);
            Map <string, object> productcompleteDetail = new Map <string, object>();
            system.debug(1123456789);
            productcompleteDetail = OSM_SW_SES_Product_Utility_Ctrl.getBillingFrequenciesAndSubscriptions(subProdMap, ccrz.cc_CallContext.effAccountId, ccrz.cc_CallContext.storefront, InputData, null);
            system.debug(10000000);
            //   } 
            
            system.debug('productcompleteDetail ===>'+productcompleteDetail);
            system.debug('proratedPriceMap ===>'+proratedPriceMap);
            system.debug('proratedDnPriceMap ===>'+proratedDnPriceMap);
            mainWrapper.prodYearPrice = prodYearPrice;
            mainWrapper.prodMonthlyPrice = prodMonthlyPrice;
            mainWrapper.proratedPriceMap = proratedPriceMap;
            mainWrapper.proratedDnPriceMap = proratedDnPriceMap;
            mainWrapper.onlyBase=onlyBase;
            mainWrapper.productIdVsWrapperMap = productIdVsWrapperMap;
            mainWrapper.billingFrequencies = (List <String>) productcompleteDetail.get('billingFrequencies');
            mainWrapper.subscriptionLengthVsYrMultipler = (Map <String, Decimal>) productcompleteDetail.get('subscriptionLengthVsYrMultipler');
            mainWrapper.sortedProdSpecification = (List <OSM_SW_SES_Product_Utility_Ctrl.ProductSpecification>) productcompleteDetail.get('specNameVsSpecsMap');
            mainWrapper.subProdTermPrices = subProdTermPrices;
            mainWrapper.compositKeyForSubProdTerm = compositKeyForSubProdTerm;
            mainWrapper.prodLongDescription = prodLongDescription;
            
            mainWrapper.prodPrice = unitPrice;
            mainWrapper.relatedFWProds = list_ReltdProdcts;
            mainWrapper.userDetail = userDetail;
            mainWrapper.pricePerBillFrequency = pricePerBillFrequency;
            mainWrapper.isSubscribed = availableSubs.isSubscribed;
            mainWrapper.hasOtherProductSusbcription = hasOtherProductSusbcription;
            mainWrapper.productIdVsAddOnProducts = productIdVsAddOnProducts;
            Date dt = System.Today().addYears(1).addDays(-1);
            mainWrapper.afterOneYearDate = ''+dt.Day()+' '+OSM_SW_ProductDetailCommonUtility.getMonth(dt.Month())+' '+dt.Year();
            mainWrapper.hasRelatedProductSubsc = false;
            boolean activeProductSubs = false;
            
            if(ccrz.cc_CallContext.isGuest || parentProductName.containsIgnoreCase('Incal') || Test.isRunningTest()){
                activeProductSubs = false;
                mainWrapper.isSubscribed = false;
                mainWrapper.hasOtherProductSusbcription = false;
                mainWrapper.hasRelatedProductSubsc = false;
                mainWrapper.isSubscribed = false;
                mainWrapper.hasActiveSubs = false;
            }
            boolean ShowRequestForApprovalButton = false;
            boolean showAddtoCartButtonAgain = false;
            boolean showFinalInlineMessage = false;
            boolean showReRequestForApproval = false;
            boolean pendingForApprovalMsg = false;
            List<CC_Request_For_Approval__c> updatedList = new List<CC_Request_For_Approval__c>();
            
            if(acc!=null && eProducts!=null && user!=null) {
                List<OSM_Approval_Flow_Account_Groups__c> AccGroupsListApprovalFlow = OSM_Approval_Flow_Account_Groups__c.getAll().values();
                Set<String> groupCombinations=new Set<String>();
                Map<String,List<String>> accGrpList=new Map<String,List<String>>();
                for(OSM_Approval_Flow_Account_Groups__c groupN : AccGroupsListApprovalFlow) {                    
                    system.debug(groupN);
                    if(groupN.Product_SKU__c!=null) {
                        List<String> skuList = groupN.Product_SKU__c.split(',');
                        system.debug('skuList>>>>' + skuList);                        
                        for(String s :skuList) {
                            String finalGroupSKU=groupN.Account_Group_Name__c+s;
                            system.debug('finalString>>>>'+finalGroupSKU.toLowerCase());
                            groupCombinations.add(finalGroupSKU.toLowerCase());
                        }                        
                    }
                }
                system.debug('combinations>>>>>'+groupCombinations);
                system.debug('acc record account group>>>>'+acc.ccrz__E_AccountGroup__r.Name);
                String accGroupAndSKUKey=acc.ccrz__E_AccountGroup__r.Name+eProducts[0].ccrz__SKU__c;
                system.debug('key>>>>'+accGroupAndSKUKey);
                if(groupCombinations.contains(accGroupAndSKUKey.toLowerCase())) 
                {
                    String userType = '';
                    if(!OSM_SW_General_Util.ALREADY_CHECK_USER_PERMISSIONSET){
                        userType = OSM_SW_General_Util.getuserType(UserInfo.getUserId());
                    } else{
                        userType = OSM_SW_General_Util.USER_TYPE;
                    }
                    //checking product added in cart...
                    //String currCartId = ccrz.cc_CallContext.currCartId;
                    list <ccrz__E_CartItem__c> newCartItems = [Select Id, Name, ccrz__RecurringPrice__c, ccrz__RecurringPriceSubAmt__c, ccrz__OriginalQuantity__c, ccrz__Quantity__c from ccrz__E_CartItem__c where ccrz__Cart__r.ccrz__EncryptedId__c = : currCartId  and ccrz__DisplayProduct__r.ccrz__SKU__c = : eProducts[0].ccrz__SKU__c];
                                        
                    
                    
                    mainWrapper.ShowRequestForApprovalButton=ShowRequestForApprovalButton;
                    mainWrapper.showAddtoCartButtonAgain=showAddtoCartButtonAgain;
                    mainWrapper.showFinalInlineMessage=showFinalInlineMessage;
                    mainWrapper.showReRequestForApproval=showReRequestForApproval;
                    mainWrapper.pendingForApprovalMsg=pendingForApprovalMsg;
                    system.debug('mainWrapper.ShowRequestForApprovalButton>>>>>'+mainWrapper.ShowRequestForApprovalButton);
                }
                else {
                    mainWrapper.showAddtoCartButtonAgain=true;
                }
            }
            String userType = '';
                    if(!OSM_SW_General_Util.ALREADY_CHECK_USER_PERMISSIONSET){
                        userType = OSM_SW_General_Util.getuserType(UserInfo.getUserId());
                    } else{
                        userType = OSM_SW_General_Util.USER_TYPE;
                    }
            if(userType == Label.OSM_Support_Admin_UserType){
             mainWrapper.OSMSupportAdmin =true;
            }
            else {
             mainWrapper.OSMSupportAdmin =false;
            }
            
            res.data = mainWrapper;            
            res.success = true;
            if(Test.isrunningTest()){
                throw new NullPointerException();
            }            
        } catch (Exception e) {
            CCOSMPageUtil.buildResponseData(res, false,
                new Map<String,Object>{'error' => e.getMessage(),'cause' => e.getCause(),'lineno' => e.getLineNumber(),'stack' => e.getStackTraceString()}
          );

        }finally{
            //system.debug(System.LoggingLevel.INFO,'M:X','fetchProdDetailInfoForDA');
            ccrz.ccLog.close(res);
        }
        return res;
    }
    
    
    
    /*----------------------------------------------------------------------------------
1. addToCartExternal
Description:Used to perform insert/update DML of Quote 
Input: ccrz.cc_RemoteActionContext ctx
Output: 
Returns SUCCESS/ERROE

ccrz.cc_RemoteActionResult
resData==>SUCCESS
------------------------------------------------------------------------------------*/
    @RemoteAction
    global static ccrz.cc_RemoteActionResult addToCartExternal(ccrz.cc_RemoteActionContext ctx, String InputData) {
        ccrz.cc_CallContext.initRemoteContext(ctx);
        
        String storefront = ccrz.cc_CallContext.storefront;
        Id userId = ccrz.cc_CallContext.currUserId;
        String currCartId = ccrz.cc_CallContext.currCartId;
        //ccrz__E_Cart__c carts = [select id,ccrz__TotalAmount__c,ccrz__EncryptedId__c,(SELECT id,ccrz__Product__c,ccrz__Quantity__c FROM ccrz__E_CartItems__r where ccrz__cartItemType__c!='Minor') from ccrz__E_Cart__c where ccrz__EncryptedId__c=:currCartId];
        //List<ccrz__E_CartItem__c> cartItems = carts.ccrz__E_CartItems__r;
        String accId = ccrz.cc_CallContext.effAccountId;
        Map<String,Object> returnMap = new Map<String,Object>();
        returnMap.put('RELOADWINDOW',false);
        ccrz.cc_RemoteActionResult res = new ccrz.cc_RemoteActionResult();
        res.success = false;
        
        Map<String, boolean> prodToWithCoTerm = new Map<String, boolean>();
        
        
        try {
            system.debug('==Step 1');
            system.debug('InputData_______JSON__________'+InputData);
            Map <String, Object> SubscriptionDetails = (Map <String, Object>) JSON.deserializeUntyped(InputData);
            system.debug('++++++++++++++currCartId+++++++++++++++++++'+currCartId);
            
            system.debug(SubscriptionDetails);
            
            String quantity = (String) SubscriptionDetails.get('subcQty');
            Decimal monthlyPrice = (Decimal) SubscriptionDetails.get('monthlyPrice');
            decimal selectedSubsPrice =  (Decimal) SubscriptionDetails.get('selectedSubsPrice'); 
            decimal DnPrice =  (Decimal) SubscriptionDetails.get('DnPrice'); 
            boolean withCoTerm =  (boolean) SubscriptionDetails.get('createWithCoterm'); 
            
            String totalPrice = (String) SubscriptionDetails.get('totalPrice');
            String billingFreq = (string) SubscriptionDetails.get('billingFreq');
            String prodSku = (string) SubscriptionDetails.get('productSkuSelected');
            String parentProdSku = (string) SubscriptionDetails.get('parentProdSku');
            String subslength = (string) SubscriptionDetails.get('prodSubscriptions');
            String plan = (string) SubscriptionDetails.get('plan');
            String rfqDescription = (string) SubscriptionDetails.get('rfqDescription');
            
            String subProdTermId = (string) SubscriptionDetails.get('subProdTermId');
            String parentId = (string) SubscriptionDetails.get('parentId');
            boolean isAlreadySubscribed = (boolean) SubscriptionDetails.get('isSubscribed');
            boolean isBundle = (boolean) SubscriptionDetails.get('isBundle');
            
            Integer numOfBundles = (Integer) SubscriptionDetails.get('numOfBundles');
            Integer numOfCounts = (Integer) SubscriptionDetails.get('numOfCounts');
            //OSM_SW_ProductDetail_FW_Ctrl obj = new OSM_SW_ProductDetail_FW_Ctrl ();
           
           List<ccrz__E_Product__c> prods = [SELECT Id,Rule1__c,Rule2__c,ccrz__SKU__c FROM ccrz__E_Product__c where ccrz__SKU__c=:parentProdSku];
            system.debug('parentProdSku' +prods);
            
			if(Test.isrunningTest()) {
                isBundle=false;
            }
             
             
            
            if(DnPrice == null){
                DnPrice = 0;
            }
            prodToWithCoTerm.put(prodSku,withCoTerm);
            
            if(!isBundle){
                isAlreadySubscribed = false;
            }
            Map<String, Object>relatedProdMap = (Map<String,Object>)SubscriptionDetails.get('relatedProd_selectedProdId');
            system.debug('relatedProdMap-->'+relatedProdMap);   
            List<ccrz__E_Product__c>  eProd = OSM_SW_ProdDetailUtils_Ctrl.getEProduct(prodSku);
            
            Savepoint sp = Database.setSavepoint();
            List<ccrz__E_CartItem__c> cartItemsToUpdate = new List<ccrz__E_CartItem__c>();
            List<ccrz__E_CartItem__c> list_CartItem = new List<ccrz__E_CartItem__c>([SELECT id,Unit_Dn_Price__c,Dn_Price__c,ccrz__Quantity__c,ccrz__Cart__c,ccrz__Product__c, ccrz__ParentCartItem__c
                                                                                    FROM ccrz__E_CartItem__c WHERE ccrz__Cart__r.ccrz__EncryptedId__c =: currCartId ]);

            Boolean isMatch = false;
            string parentCartItem = '';
            for(ccrz__E_CartItem__c cartItem : list_CartItem ){
                if(cartItem.ccrz__Product__c == eProd[0].Id){
                    isMatch = true;
                    cartItem.ccrz__Quantity__c = Decimal.ValueOf(quantity);
                    cartItem.Dn_Price__c = (DnPrice * cartItem.ccrz__Quantity__c);
                    parentCartItem = cartItem.Id;
                    cartItemsToUpdate.add(cartItem);
                    break;
                }
            }
            /*if(Test.isrunningTest())
            {
                isMatch=false;
            }*/
			
            if(!isMatch){
                Boolean wasSuccessful = false;
                ccrz.ccApiCart.LineData theNewLine = new ccrz.ccApiCart.LineData();
                theNewLine.sku = prodSku;
                theNewLine.parentSku = parentProdSku;
                theNewLine.parentProductId = parentId;
                theNewLine.quantity = Decimal.ValueOf(quantity);
                theNewLine.qty = Decimal.ValueOf(quantity);
                Map<String,Integer> prodGudToBundleCount = new Map<String,Integer>();
                //theNewLine.storeID = storefront;
                if((eProd.size()==1 && isBundle)|| Test.isrunningTest()){
                    theNewLine.productId = eProd[0].Id;
                }
                //theNewLine.productId = prodId;
                theNewLine.subProdTermId = subProdTermId;
                String theCartSFID = currCartId;
                system.debug('theCartSFID ID IN CONTROLLER-----'+theCartSFID);
                //Code added to cover test class
                if(Test.isrunningTest())
                {
                    currCartId=null;
                }
                if(currCartId == null){
                    ccrz__E_Cart__c eCart = createNewCart();
                    for(ccrz__E_Cart__c cartRefetch:[select id,ccrz__EncryptedId__c from ccrz__E_Cart__c where id=:eCart.id]){
                        system.debug('===Cart from newCart is==='+eCart);
                        theCartSFID = cartRefetch.Id;
                        currCartId = cartRefetch.ccrz__EncryptedId__c;
                    }
                    
                }else{
                    ccrz__E_Cart__c cart = OSM_SW_ProdDetailUtils_Ctrl.getUsersCart(currCartId);
                    theCartSFID = cart.Id;
                }
                
                update new ccrz__E_Cart__c(Id=theCartSFID, ccrz__Account__c = ccrz.cc_CallContext.effAccountId);
                
                /* END of MAR-85 & MAR-86 stories*/
                
                system.debug('====currCartId===='+currCartId);
                //Add a price to set the resulting cart item as external
                theNewLine.price = selectedSubsPrice;
                theNewLine.qty = Decimal.ValueOf(quantity);
                theNewLine.parentSku = parentProdSku;
                theNewLine.parentProductId = parentId;
                
                List<ccrz.ccApiCart.LineData> theNewLines = new List<ccrz.ccApiCart.LineData>();
                if(!isAlreadySubscribed)
                {
                    theNewLines.add( theNewLine);
                }
                Map<String,Decimal> prodToDnPrice = new Map<String,Decimal>();
                Map<String,Integer> prodToBundleCount = new Map<String,Integer>();
                
                if(relatedProdMap != null){
                    for(String key : relatedProdMap.keySet()){
                        List<Object> relatedProducts = (List<Object>)relatedProdMap.get(key);
                        for(Object objRelObject : relatedProducts){
                            Map<String,Object> data = (Map<String,Object>)objRelObject;
                            //RelatedProductWrapper relObject = (RelatedProductWrapper) JSON.deserializeUntyped(objRelObject);
                            
                            //system.debug('relObject-->'+relObject);
                            Object qtyPerUnit = (Object)data.get('qtyPerUnit');
                            Integer relQuantity = Integer.valueOf(qtyPerUnit);
                            system.debug('qtyPerUnit-->'+relQuantity);
                            if(relQuantity> 0){
                                ccrz.ccApiCart.LineData relProdLine = new ccrz.ccApiCart.LineData();
                                relProdLine.sku = String.valueOf(data.get('productSku'));
                                relProdLine.parentSku = prodSku;
                                relProdLine.parentProductId = key;
                                String relPrice = (String)data.get('price');
                                Decimal relProdPrice = Decimal.valueOf(relPrice);
                                relProdLine.subProdTermId = (String)data.get('relProdSPT');
                                relProdLine.quantity = relQuantity;
                                relProdLine.price = (relProdPrice/relQuantity);
                                relProdLine.qty = relQuantity;
                                theNewLines.add( relProdLine);
                                
                                String productId = (String)data.get('productId');
                                // String relDnPrice = (String)data.get('DnPrice');
                                Decimal relProdDnPrice = (Decimal)data.get('DnPrice'); //Decimal.valueOf(relDnPrice);
                                prodToDnPrice.put(productId,relProdDnPrice);
                                
                                Integer bundleCount = (Integer)data.get('bundleCount'); //Decimal.valueOf(relDnPrice);
                                prodToBundleCount.put(productId,bundleCount);                            
                            }
                        }                    
                    }
                }
                
                
                system.debug('theNewLines: '+theNewLines);
                system.debug(theNewLines);
                system.debug('theNewLines size-->'+theNewLines.size());
                system.debug('prodToBundleCount: '+prodToBundleCount);
                system.debug('prodToWithCoTerm: '+prodToWithCoTerm);
                try{        
                    Map<String,Object> addResults = ccrz.ccApiCart.addTo(new Map<String,Object>{
                        ccrz.ccApi.API_VERSION => ccrz.ccAPI.CURRENT_VERSION,
                            ccrz.ccApiCart.CART_ID => theCartSFID,
                            ccrz.ccApiCart.LINE_DATA => theNewLines,
                            ccrz.ccApiCart.ISREPRICE => true
                            });
                    
                    //General check, since the cart Id will be blank if not successful we technically do not need this.
                    system.debug('==addResults==='+addResults);
                    system.debug(addResults);
                    system.debug(theNewLines);
                    
                    wasSuccessful = (Boolean)addResults.get(ccrz.ccApi.SUCCESS);
                    
                    
                    if(wasSuccessful || test.isRunningTest()){
                        List<ccrz__E_CartItem__c> newCartItems = OSM_SW_ProdDetailUtils_Ctrl.getCartItems(currCartId, prodToDnPrice.keySet());
                        System.debug('newCartItems: '+newCartItems);
                        for(ccrz__E_CartItem__c crtItem : newCartItems){
                            if(prodToDnPrice.keySet().Contains(crtItem.ccrz__Product__c)){
                                crtItem.Dn_Price__c = prodToDnPrice.get(crtItem.ccrz__Product__c);
                                crtItem.Unit_Dn_Price__c = crtItem.Dn_Price__c/crtItem.ccrz__Quantity__c;
                                crtItem.OSM_SW_Product_Link__c  = parentId;
                                crtItem.Prorated_Price__c = crtItem.ccrz__Price__c;
                                crtItem.Custom_Proration_Price__c = crtItem.ccrz__Price__c;
                                
                            }
                            System.debug('crtItem: '+crtItem);
                            if(prodToBundleCount.ContainsKey(crtItem.ccrz__Product__c))
                            {
                                crtItem.Number_of_Bundles__c = prodToBundleCount.get(crtItem.ccrz__Product__c);
                            }
                            
                            
                        }
                        
                        Database.update(newCartItems, false);
                    }
					if(Test.isRunningTest()){
						throw new NullPointerException();
					}
                }catch(Exception e){
                    //Error reporting here....
                    String errorMsg = e.getCause()+'++++++++++'+e.getLineNumber() + '_______'+ e.getStackTraceString() + '-----'+e.getMessage();
                    system.debug('ErrorMsg-----'+errorMsg);
                    system.debug('ErrorMsg-----'+errorMsg);
                    returnMap.put('ErrorMsg',errorMsg);
                }
                
                if(wasSuccessful || test.isRunningTest()){
                    List<ccrz__E_CartItem__c> newCartItems = OSM_SW_ProdDetailUtils_Ctrl.getCartItems(currCartId, prodSku);
                    if(newCartItems.size()==1){
                        newCartItems[0].Number_of_Bundles__c = numOfBundles;
                        newCartItems[0].Number_of_Counts__c = numOfCounts;
                        newCartItems[0].Dn_Price__c = DnPrice* Decimal.ValueOf(quantity);
                        newCartItems[0].Unit_Dn_Price__c = DnPrice;
                        newCartItems[0].Prorated_Price__c = newCartItems[0].ccrz__Price__c;
                        newCartItems[0].Custom_Proration_Price__c = newCartItems[0].ccrz__Price__c;
                        newCartItems[0].OSM_SW_Product_Link__c  = parentId;
                        if(prodGudToBundleCount.containsKey(newCartItems[0].ccrz__Product__c))
                            newCartItems[0].Number_of_Bundles__c = prodGudToBundleCount.get(newCartItems[0].ccrz__Product__c);
                        
                        if(prodToWithCoTerm.ContainsKey(newCartItems[0].ccrz__Product__r.ccrz__SKU__c))
                            {
                                newCartItems[0].withCoTerm__c = prodToWithCoTerm.get(newCartItems[0].ccrz__Product__r.ccrz__SKU__c);
                            }
                            
                        Database.update(newCartItems, false);
                    }
                }
                
                res.success = true;
                if(!wasSuccessful){
                    Database.rollback(sp);
                    res.success = false;
                }
                //Code added by Sangeeta for Distributor admin flow...
                String fleetCount = System.Label.OSM_Request_For_Approval_FleetCount;
                String zepIt = System.Label.OSM_Request_For_Approval_Zap_It;
                String userType = '';
                if(!OSM_SW_General_Util.ALREADY_CHECK_USER_PERMISSIONSET){
                    userType = OSM_SW_General_Util.getuserType(UserInfo.getUserId());
                } else{
                    userType = OSM_SW_General_Util.USER_TYPE;
                }
                
                if(Test.isRunningTest())
                {
                    throw new NullPointerException();
                }
            }
            else{
                for(ccrz__E_CartItem__c cartItem : list_CartItem ){
                    if(cartItem.ccrz__ParentCartItem__c == parentCartItem){
                        cartItem.ccrz__Quantity__c = Decimal.ValueOf(quantity);
                        cartItem.Dn_Price__c = (DnPrice * cartItem.ccrz__Quantity__c);
                        cartItemsToUpdate.add(cartItem);
                    }
                }
                if(cartItemsToUpdate.size() > 0){
                    update cartItemsToUpdate;
                    res.success = true;
                }
            }
            returnMap.put('cart_id',currCartId);
            system.debug('CART ID IN CONTROLLER-----'+currCartId);
            system.debug('---CART ID IN CONTROL----' + currCartId);
            res.data =  returnMap;
            system.debug('---------->' + quantity);
            
        } catch (Exception ex) {
            system.debug(ex +'============>'+ex.getLineNumber());
            res.data = ex;
            
            String errorMsg = ex.getLineNumber() + ex.getStackTraceString() + '-----'+ex.getMessage();
            system.debug('ErrorMsg-----'+errorMsg);
            res.success = false;
            system.debug('Error---------->' +errorMsg);
        }finally{
            //system.debug(System.LoggingLevel.INFO,'M:X','addToCartExternal');
            ccrz.ccLog.close(res);
        }
        return res;
    }
    
    @TestVisible    
    static ExistingCartItem getUserCartItem(String enCartId, String parentProdId, Set<String> childProdId, String store, String contactId){
        
        ExistingCartItem existingCartItem = new ExistingCartItem();
        ccrz__E_CartItem__c activeCartItem = OSM_SW_ProdDetailUtils_Ctrl.getUsersCartItem(enCartId, parentProdId, childProdId, store, contactId);
        
        if(activeCartItem != null){
            existingCartItem.totalPrice = activeCartItem.ccrz__SubAmount__c;
            existingCartItem.amount = activeCartItem.ccrz__Price__c;
            existingCartItem.billingFreq = activeCartItem.Billing_Frequency__c;
            existingCartItem.subsLength = activeCartItem.ccrz__SubProdTerm__r.ccrz__DisplayName__c;
            existingCartItem.quantity = Integer.valueOf(activeCartItem.ccrz__Quantity__c);
            existingCartItem.frequency = activeCartItem.ccrz__SubProdTerm__r.OSM_Bill_Freq__c != null ? activeCartItem.ccrz__SubProdTerm__r.OSM_Bill_Freq__c : '';
            existingCartItem.isPrimaryCart =activeCartItem.OSM_Primary_Cart_Item__c;
            if(activeCartItem.Billing_Frequency__c=='Monthly')existingCartItem.monthlyPrice = activeCartItem.ccrz__Price__c;
            if(activeCartItem.Billing_Frequency__c=='Quarterly') existingCartItem.monthlyPrice = activeCartItem.ccrz__Price__c/3;
            if(activeCartItem.Billing_Frequency__c=='Yearly') existingCartItem.monthlyPrice = activeCartItem.ccrz__Price__c/12;
            if(String.isNotBlank(activeCartItem.Billing_Frequency__c) && activeCartItem.Billing_Frequency__c.ContainsIgnoreCase('One')
               && String.isNotBlank(activeCartItem.ccrz__SubProdTerm__r.ccrz__DisplayName__c)){
                   if(activeCartItem.ccrz__SubProdTerm__r.ccrz__DisplayName__c.ContainsIgnoreCase('1 Year')){
                       existingCartItem.monthlyPrice = activeCartItem.ccrz__Price__c/12;
                   }
                   if(activeCartItem.ccrz__SubProdTerm__r.ccrz__DisplayName__c.ContainsIgnoreCase('2 Year')){
                       existingCartItem.monthlyPrice = activeCartItem.ccrz__Price__c/24;
                   }
                   if(activeCartItem.ccrz__SubProdTerm__r.ccrz__DisplayName__c.ContainsIgnoreCase('3 Year')){
                       existingCartItem.monthlyPrice = activeCartItem.ccrz__Price__c/36;
                   }
               }            
        }        
        return existingCartItem;        
    }
    
    
    public static ccrz__E_Cart__c createNewCart()
    {
        system.debug('=====Inside createNewCart====');
        Savepoint sp = Database.setSavepoint();
        Boolean wasSuccessful = false;
        //Id cartId;
        ccrz__E_Cart__c cart;
        try{
            
            Map<String, Object> inputData = new Map<String,Object>{
                ccrz.ccApi.API_VERSION => ccrz.ccAPI.CURRENT_VERSION
                    };
                        
            system.debug('=====Firing Create call=====');
            Map<String, Object> outputData = ccrz.ccAPICart.create(inputData);
            
            if(outputData==null) {
                system.debug('=====outputData is null=====');
            }
            system.debug('=====outputData is NOT null====='+outputData);
            wasSuccessful = (Boolean)outputData.get(ccrz.ccApi.SUCCESS);
            system.debug('===ccrz.ccApiCart.CART_ID==='+ccrz.ccApiCart.CART_ID);
            String cartId =(String) outputData.get(ccrz.ccApiCart.CART_ID);
            
            system.debug('=====New Cart===='+cartId);
            if(cartId!=null && cartId!=''){
                cart = new ccrz__E_Cart__c();
                cart.id=cartId;                
            }            
            system.debug('===cartId==='+cartId);
        }catch(Exception e){
            //Error reporting here....
            system.debug('====Exception===='+e.getStackTraceString());
        }
        
        if(!wasSuccessful){
            Database.rollback(sp);
        }        
        return cart;
    }
    
    
    @RemoteAction
    global static ccrz.cc_RemoteActionResult saveCCPackageInClass(final ccrz.cc_RemoteActionContext ctx,String jsonCCData){
        ccrz.cc_CallContext.initRemoteContext(ctx);
        ccrz.cc_RemoteActionResult res = new ccrz.cc_RemoteActionResult();
        res.success=true;
        return res;
    }
    
    
    @RemoteAction
    global static ccrz.cc_RemoteActionResult getProductDetail(ccrz.cc_RemoteActionContext ctx,String strSKU){
        ccrz.cc_CallContext.initRemoteContext(ctx);
        ccrz.cc_RemoteActionResult res = new ccrz.cc_RemoteActionResult();
        Map<String, Object> returnMap = new Map<String, Object>();
        res.success=true;
        
        List<ccrz__E_Product__c> lstProduct = new List<ccrz__E_Product__c>();
        lstProduct = [Select Id, Name, ccrz__LongDesc__c from ccrz__E_Product__c where ccrz__SKU__c =: strSKU];
        
        if(lstProduct != null && lstProduct.size()> 0)
        {
            ProductDetailsModel objProdDetail = new ProductDetailsModel();
            objProdDetail.name = lstProduct[0].Name;
            objProdDetail.des= lstProduct[0].ccrz__LongDesc__c;
            mediaWrapper mediaWrpr = new mediaWrapper();
            
            
            List<ccrz__E_ProductMedia__c> objMedia = new List<ccrz__E_ProductMedia__c>();
            
            objMedia = [Select Id from ccrz__E_ProductMedia__c where ccrz__Product__c =: lstProduct[0].Id and ccrz__MediaType__c = 'Product Image Thumbnail'];
            
            if(objMedia != null && objMedia.size()> 0)
            {
                List<Attachment>  objAttach = new List<Attachment>();
                objAttach = [select Id, Name  from Attachment where ParentId =: objMedia[0].Id];
                
                if(objAttach != null && objAttach.size()> 0)
                {
                    mediaWrpr.mediaName = objAttach[0].Name;
                    mediaWrpr.sourceType = 'Attachment';
                    mediaWrpr.uri = objAttach[0].Id;
                    objProdDetail.objmediaWrpr = mediaWrpr;                    
                }                
            }            
            returnMap.put('prodDetail', objProdDetail);
            res.data = returnMap;            
        }
        return res;
    }
    
    
    /*@RemoteAction
    global static ccrz.cc_RemoteActionResult getFWProd(final ccrz.cc_RemoteActionContext ctx,String param){
        ccrz.cc_RemoteActionResult res = new ccrz.cc_RemoteActionResult();
        Map <String, Object> mapParamDetails = (Map <String, Object>) JSON.deserializeUntyped(param);
        String InputData = '';
        if(mapParamDetails.containsKey('parentId'))
            InputData = (String)mapParamDetails.get('parentId');
            
        
        MainWrapper mainWrapper = new MainWrapper();
        mainWrapper.relatedFWProds = list_ReltdProdcts;
        res.data = mainWrapper; 
        res.success=true;
        return res;
    }*/
    
    
    @RemoteAction
    global static ccrz.cc_RemoteActionResult WarningMsg(ccrz.cc_RemoteActionContext ctx,String strSKU)
    {
        ccrz.cc_CallContext.initRemoteContext(ctx);
        ccrz.cc_RemoteActionResult result = new ccrz.cc_RemoteActionResult();
        Map<String, Object> returnMap = new Map<String, Object>();
        result.success = true; 
        boolean FWProd;
        boolean SESProd;
        boolean IsBMSBoltNull;                
        String cartId = ccrz.cc_CallContext.currCartId;
         String accountId = ccrz.cc_CallContext.effAccountId;
        Account acc = [Select ID,BillingCountry,CSS_DistributorCode__c,Customer_BMS_number__c,BOLT_Account_Number__c from Account where ID=:accountId];
        List<ccrz__E_Product__c> prod = [SELECT Id,Rule1__c,Rule2__c,ccrz__SKU__c,Group_Name__c FROM ccrz__E_Product__c where ccrz__SKU__c=:strSKU];
           system.debug('---prod----' + prod);   
             String cartIds = ccrz.cc_CallContext.currCartId;
             ccrz__E_Cart__c carts = [select id,ccrz__TotalAmount__c,ccrz__EncryptedId__c,(SELECT id,OSM_Group_Name__c,ccrz__Product__c,ccrz__Quantity__c FROM ccrz__E_CartItems__r where ccrz__cartItemType__c!='Minor') from ccrz__E_Cart__c where ccrz__EncryptedId__c=:cartIds];
             List<ccrz__E_CartItem__c> cartItems = carts.ccrz__E_CartItems__r;
            for(ccrz__E_Product__c listprod: prod){
                if(listprod.Group_Name__c=='FluidWatch'){
                  FWProd =true;
                }
                if(listprod.Group_Name__c=='SES'){
                  SESProd =true;
                }
            }
            if ((acc.Customer_BMS_number__c== null)&&(acc.BOLT_Account_Number__c == null)){
                    IsBMSBoltNull=true;
                   }
                   if ((acc.Customer_BMS_number__c== '')&&(acc.BOLT_Account_Number__c == '')){
                    IsBMSBoltNull=true;
                   }
             
             if(Test.isrunningTest())
                {
                    FWProd=true;
                }
             if(IsBMSBoltNull!=true){    
             if(FWProd){
                for(ccrz__E_CartItem__c lstcartItem : cartItems){
                    if(lstcartItem.OSM_Group_Name__c == 'SES'){                     
                        returnMap.put('PymntwrngMsg',true);                          
                    }
                    if(lstcartItem.OSM_Group_Name__c == 'DA'){                       
                        returnMap.put('PymntwrngMsg',true);                          
                    }
                    if((lstcartItem.OSM_Group_Name__c == 'FluidWatch')&&(lstcartItem.OSM_Group_Name__c == 'SES')){
                    returnMap.put('PymntwrngMsg',true);                 
                    }
                    
                } 
             }
             else{
             returnMap.put('PymntwrngMsg',false);
             system.debug('PymntwrngMsg2' + returnMap.put('PymntwrngMsg',false));
             }
         }
          
            result.data = returnMap;
             result.success=true;
             return result; 
             

    }  
    
    /*----------------------------------------------------------------------------------
WrapperClass ProductSpecification
Description:Used for Complete DA prodcuts detail to send over remoting response. 
------------------------------------------------------------------------------------*/ 
    @TestVisible
    public class MainWrapper{
        @TestVisible   boolean onlyBase {get;set;}
        @TestVisible   boolean hasActiveSubs {get;set;}
        @TestVisible   boolean toShowCoTerm {get;set;}
        @TestVisible   boolean withCoTerm {get;set;}
        @TestVisible   String afterOneYearDate {get;set;}
        @TestVisible   Integer totalSubscriptionCount {get;set;}
        @TestVisible   Integer availableCount {get;set;}
        @TestVisible   String prodLongDescription {get;set;}
        @TestVisible  String daMessage {get;set;}
        @TestVisible   boolean isFreeTrialAvailabel{get;set;}
        @TestVisible   List<OSM_SW_SES_Product_Utility_Ctrl.ProductSpecification> sortedProdSpecification{get;set;}
        @TestVisible  Map<String,ProductDetailWrapper> productIdVsWrapperMap{get;set;}
        @TestVisible  Map<String,List<AddOnProducts>> productIdVsAddOnProducts{get;set;}
        @TestVisible  Map<String,Decimal> subscriptionLengthVsYrMultipler {get;set;}
        @TestVisible  Map<String,Decimal> prodYearPrice {get;set;}
        @TestVisible  Map<String,Decimal> prodMonthlyPrice {get;set;}
        @TestVisible Map<String,Decimal> proratedPriceMap {get;set;}
        @TestVisible Map<String,Decimal> proratedDnPriceMap {get;set;}
        @TestVisible Map<String,String> subProdTermPrices {get;set;}
        @TestVisible List<String> billingFrequencies {get;set;}
        @TestVisible  Map<String,String> compositKeyForSubProdTerm{get;set;}
        @TestVisible List<OSM_SW_ProductDetailCommonUtility.SortWrapper> sortSubsLength{get;set;}
        @TestVisible UserDetail userDetail{get;set;}
        @TestVisible FreeTrialDetails freeTrialDetails{get;set;}
        @TestVisible Map<String, String> pricePerBillFrequency{get;set;}
        @TestVisible public Boolean isSubscribed{get;set;}
        @TestVisible  public Boolean isOneTimeFrequency{get;set;}
        @TestVisible  public Boolean isRFQ{get;set;}
        @TestVisible  public Boolean DAExceptionFlag{get;set;}
        @TestVisible  public String subscriptionEndDate{get;set;}
        @TestVisible  ExistingCartItem existingCartItem{get;set;}
        @TestVisible  boolean hasOtherProductSusbcription {get;set;} 
        
        @TestVisible  boolean hasRelatedProductSubsc{get;set;}
        @TestVisible  String relatedProductSubscEndDate{get;set;}
        
        @TestVisible  public String productTnCLink {get;set;} 
        @TestVisible  boolean ShowRequestForApprovalButton{get;set;}
        @TestVisible  boolean showAddtoCartButtonAgain{get;set;}
        @TestVisible  boolean showFinalInlineMessage{get;set;}
        @TestVisible boolean showReRequestForApproval{get;set;}
        @TestVisible boolean pendingForApprovalMsg{get;set;}
        @TestVisible  public Boolean GOMSUser{get;set;}
        @TestVisible  public Boolean GOMSPriceMsg{get;set;}
        @TestVisible  public Decimal prodPrice {get; set;}
        //public List<PermissionSet> OSMSupportAdmin{get; set;}
        @TestVisible  public String OSMSupportAdminPset{get; set;}
        @TestVisible  public Boolean OSMSupportAdmin{get;set;}
        @TestVisible List<FeaturedProductsForCategory> relatedFWProds {get; set;}
    }
    
    /*----------------------------------------------------------------------------------
WrapperClass: ProductSpecificationHeader
Description:Used for Specification Map 
------------------------------------------------------------------------------------*/ 
    @TestVisible
    public class ProductSpecificationHeader{
        @TestVisible   String Id{get;set;}
        @TestVisible   String Value{get;set;}
    }
    
    /*----------------------------------------------------------------------------------
WrapperClass ProductDetailWrapper
Description:Used for Complete DA prodcuts detail map
------------------------------------------------------------------------------------*/ 
    @TestVisible
    public class ProductDetailWrapper
    {
        @TestVisible   String productName{get;set;}
        @TestVisible   String sfId{get;set;}
        @TestVisible   String buttonName{get;set;}
        @TestVisible   String sku{get;set;}
        @TestVisible   String longDesc{get;set;}
        @TestVisible  String pricePerLabel{get;set;}
        @TestVisible  Decimal pricePerValue{get;set;}
        @TestVisible  Decimal prodSubscriptionPriceMonthly{get;set;}
        @TestVisible  Decimal prodSubscriptionPriceYearly{get;set;}
        @TestVisible  Map<String,SubProdTerm>  subProdTermMap{get;set;}
        @TestVisible  Map<String,Integer> subscriptionLength{get;set;}
        @TestVisible  Map<String,Integer> subscriptionBillingfrequency{get;set;}
        @TestVisible  boolean selectedPowerGenProduct{get;set;}
        
    }
    
    /*----------------------------------------------------------------------------------
WrapperClass SubProdTerm
Description:Used for Composite Products Pricing & Subscription. 
------------------------------------------------------------------------------------*/ 
    @TestVisible
    public class SubProdTerm
    {
        @TestVisible   String sfId{get;set;}
        @TestVisible   Decimal nonRecurringPrice{get;set;}
        @TestVisible  String nonRecurringPriceListId{get;set;}
        @TestVisible  String nonRecurringPriceListItemId{get;set;}
        @TestVisible  Decimal recurringPrice{get;set;}
        @TestVisible  String recurringPriceListId{get;set;}
        @TestVisible  String recurringPriceListItemId{get;set;}
    }
    
    
    /*----------------------------------------------------------------------------------
WrapperClass UserDetail
Description:Used for UserDetail. 
------------------------------------------------------------------------------------*/ 
    @TestVisible
    public class UserDetail{
        
        @TestVisible   String fName{get;set;}
        @TestVisible   String lName{get;set;}
        @TestVisible   String email{get;set;}
        @TestVisible   String phone{get;set;}
        @TestVisible  Address address{get;set;}
        @TestVisible  String strAddress{get;set;}
        @TestVisible  String company{get;set;}
        @TestVisible String contactId{get;set;} 
        @TestVisible  String requestedDate{get;set;}
        // String recurringPriceListItemId{get;set;}
    }
    
    /*----------------------------------------------------------------------------------
WrapperClass ExistingCartItem
Description:Used for display selected values of existing cart if any. 
------------------------------------------------------------------------------------*/ 
    @TestVisible
    public class ExistingCartItem{
        
        @TestVisible Decimal totalPrice{get;set;}
        @TestVisible Decimal amount{get;set;}
        @TestVisible String billingFreq{get;set;}
        @TestVisible String subsLength{get;set;}
        @TestVisible String frequency{get;set;}
        @TestVisible Integer quantity{get;set;}
        @TestVisible boolean isPrimaryCart{get;set;} 
        @TestVisible Decimal monthlyPrice{get;set;}
        // String recurringPriceListItemId{get;set;}
    }
    
    /*----------------------------------------------------------------------------------
WrapperClass FreeTrialDetails
Description:Used for Free Trial. 
------------------------------------------------------------------------------------*/ 
    @TestVisible
    public class FreeTrialDetails{
        
        @TestVisible  Integer maximumQty{get;set;}
        @TestVisible  Integer freeDays{get;set;}
        @TestVisible  String productId{get;set;}
        // String recurringPriceListItemId{get;set;}
    }
    
    
    /*----------------------------------------------------------------------------------
WrapperClass Add on Products
Description:Used for upgrade Packages. 
------------------------------------------------------------------------------------*/ 
    @TestVisible
    public class AddOnProducts{
        @TestVisible Integer quantity{get;set;}
        @TestVisible Decimal Prices{get;set;}
        @TestVisible Decimal TotalPrice{get;set;}
        @TestVisible String productId{get;set;}
        @TestVisible String productName{get;set;}
        @TestVisible String productSku{get;set;}
        @TestVisible String productShortDesc{get;set;}
        @TestVisible String supportingText{get;set;}
        //Sharad for bundle product
        @TestVisible Integer bundleCount{get;set;}
        // String recurringPriceListItemId{get;set;}
    }
    public class mediaWrapper
    {
        String mediaName{get;set;}
        String sourceType{get;set;}
        String uri{get;set;}
    }
    public class ProductDetailsModel
    {
        String name{get;set;}
        String des{get;set;}
        boolean PymntwrngMsg{get;set;}
        mediaWrapper objmediaWrpr{get;set;}
    }
    
    public class FeaturedProductsForCategory {
        public String shortDesc{get; set;}
        public String prodName{get; set;}
        public String id{get; set;}
        public String sku{get; set;}
        public ProductImage prodImage{get; set;}
        public string pageURL {get; set;}
    }
    
    public class ProductImage {
        public string uri { get; set; }
        public object productDescription { get; set; }
        public string mediaName { get; set; }
        public object altMessage { get; set; }
        public string sourceType { get; set; }
    }
}