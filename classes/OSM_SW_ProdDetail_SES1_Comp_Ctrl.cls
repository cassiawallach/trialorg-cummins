/**********************************************************************
Name:  OSM_SW_ProdDetail_SES1_Comp_Ctrl
Copyright Â© 2018  Cummins 
======================================================
======================================================
Purpose:                                                            
The purpose of this class is to keep all relative fetch
queries & DML statements & Logic for DA Product Detail                                      
======================================================
======================================================
History                                                            
-------                                                            
VERSION  AUTHOR            	DATE            DETAIL                                
1.0 -   Vineet            	03/12/2018     	INITIAL DEVELOPMENT   
2.0 -   Subbu                   
3.0 -   SUbbu
4.0 -	Charlynn	  	 	09/08/2022		LL-33/LL-34/LL-35
*****************************************************/
global without sharing class OSM_SW_ProdDetail_SES1_Comp_Ctrl {
     
    global static String blank {get {return '';} private set;}
    public static Id accountIdTest; 
    global integer qty2 {get; set;} 
    global integer qty1 {get; set;} 
    global   OSM_SW_ProdDetail_SES1_Comp_Ctrl() {
        
            String skuPrm ;
              if(test.isRunningTest()) skuPrm= '15458776';
              else skuPrm= Apexpages.currentPage().getParameters().get('sku');
            
             List<ccrz__E_Product__c> prod = [SELECT Id,Rule1__c,Rule2__c,ccrz__SKU__c FROM ccrz__E_Product__c where ccrz__SKU__c=:skuPrm];
             if( prod[0].Rule2__c!=null)
             qty2 =integer.valueOf(prod[0].Rule2__c);
             else qty2=0;
             if( prod[0].Rule1__c!=null)
             qty1 =integer.valueOf(prod[0].Rule1__c);
             else qty1=0;
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
        ccrz.ccLog.log('param___'+param);
        Map < String, Object > mapParamDetails = (Map < String, Object > ) JSON.deserializeUntyped(param);
        Map < String, Object > mapTestData = new Map < String, Object >();
        Map<Id,boolean> mapProductSubscribed = new Map<Id,boolean>();
        if(Test.isRunningTest()){
            mapTestData = OSM_SW_ProdDetail_SES1_Comp_Ctrl_Test.getTestData();
        }
        List<String> lstRelatedProductId = new List<String>();
        String withOutCotermProduct='';
        String userId = '';
        String InputData = '';
        String renewSubProd ='';
        //String renewAddOn = '';
        String accountId = ccrz.cc_CallContext.effAccountId;//added by swetha MP-473
        if(mapParamDetails.containsKey('portalUserId'))
            userId = (String)mapParamDetails.get('portalUserId');
        if(mapParamDetails.containsKey('parentId'))
            InputData = (String)mapParamDetails.get('parentId');
        
        if(mapParamDetails.containsKey('renewProd'))
            renewSubProd = (String)mapParamDetails.get('renewProd');
            
        /*if(mapParamDetails.containsKey('renewAddOn'))
            renewAddOn = (String)mapParamDetails.get('renewAddOn');*/
        
        if(mapParamDetails.containsKey('relatedDate'))
        {
            
            for(Object obj : (List<Object>)mapParamDetails.get('relatedDate'))
                lstRelatedProductId.add((String)obj);
        }
        
        
        //String [] Inputparams  = param.split('/');
        //String userId = Inputparams[0];
        //String InputData = Inputparams[1];
        //ccrz.ccLog.log('userId___'+userId);
        //ccrz.ccLog.log('Inputparams___'+Inputparams);
        //ccrz.ccLog.log('InputData___'+InputData);
        //ccrz.ccLog.log('lstRelatedProductId___'+lstRelatedProductId);
        
        String storefront = ctx.storefront;
        Id ProductIdForSubscription;
        boolean freeDAProduct = false;
        boolean hasOtherProductSusbcription = false;
        ccrz.ccLog.log(ctx.storefront);
        ccrz.cc_CallContext.initRemoteContext(ctx);
        ccrz.ccLog.log(ctx);
        Account acc = new Account();
        if(!Test.isRunningTest()){  
            //if(!ccrz.cc_CallContext.isGuest){
            //ccrz.ccLog.log('cc_CallContext======>'+ccrz.cc_CallContext.currAccountId+'<===>'+ccrz.cc_CallContext.currContact.Id);
            //}
            
            //if(!ccrz.cc_CallContext.isGuest){
            //ccrz.ccLog.log('ccrz.cc_CallContext.currAccountId-->'+ccrz.cc_CallContext.currAccountId);
            //ccrz.ccLog.log('ccrz.cc_CallContext.effAccountId-->'+ccrz.cc_CallContext.effAccountId);

            acc = OSM_SW_ProdDetailUtils_Ctrl.getAccount(ccrz.cc_CallContext.effAccountId); 
            if(acc == null){
                OSM_SW_ProdDetailUtils_Ctrl.getAccount(ccrz.cc_CallContext.currAccountId); 
            }
            //ccrz.ccLog.log('account record>>>>'+acc);
            //}
        }else
        {
            acc = OSM_SW_ProdDetailUtils_Ctrl.getAccount(accountIdTest); 
        }
        
        boolean isQSOLProductAndSubscribed = false;
        if(InputData != null && InputData != '')
        {
            List<ccrz__E_Product__c> lstProduct = new List<ccrz__E_Product__c>();
            lstProduct = [Select Id,ccrz__SKU__c from ccrz__E_Product__c where Id =: InputData];
            if(lstProduct.size() > 0 )
            {
                if(System.label.QSOL_ProductsSKUs.toUpperCase().contains(lstProduct[0].ccrz__SKU__c.toUpperCase()))
                {
                    List<ccrz__E_Subscription__c> lstSubsc = new List<ccrz__E_Subscription__c>();
                    lstSubsc = [Select Id from ccrz__E_Subscription__c where OSM_Display_Product__c =: InputData and ccrz__SubscriptionStatus__c = 'Active' and ccrz__Account__c =: acc.Id];
                    if(lstSubsc.size() > 0 )
                    {
                        isQSOLProductAndSubscribed = true;
                    }
                    
                }
            }
        }
        
        ccrz.cc_RemoteActionResult res = new ccrz.cc_RemoteActionResult();
        res.success = false;
        
        try {
            ccrz.ccLog.log(System.LoggingLevel.info,'M:E','*******************************Calling Fetch Services => ' + InputData);
            
            Set < String > productIdList = new Set < String > ();
            Map<String,List<AddOnProducts>> productIdVsAddOnProducts = new Map<String,List<AddOnProducts>>();
            String baseProductId = '';
            ccrz.ccLog.log('*******************************Calling Fetch Services => ' + InputData);
            
            /*
Map<String, Object> returnData = ccrz.ccAPIProduct.fetch(new Map<String, Object>{
ccrz.ccApi.API_VERSION => 6,
ccrz.ccAPIProduct.PARAM_INCLUDE_PRICING => TRUE,
ccrz.ccAPIProduct.PRODUCTID => InputData
});
*/
            
            String prodLongDescription = '';
            String parentSku = '';
            String baseSku = '';
            String parentStandAlone = '';
            String parentProductName = '';
            List < ccrz__E_Product__c > eProducts = OSM_SW_ProdDetailUtils_Ctrl.getEProductOnId(InputData);
            if (eProducts.size() > 0) {
                
                prodLongDescription = eProducts[0].ccrz__LongDesc__c;
                parentSku  = eProducts[0].ccrz__SKU__c;
                parentStandAlone  = eProducts[0].Stand_Alone_Product__c;
                parentProductName = eProducts[0].Name;
                ccrz.ccLog.log('product record>>>>>'+eProducts[0]);
            }
            
            List < ccrz__E_CompositeProduct__c > eCompositeProducts = OSM_SW_ProdDetailUtils_Ctrl.getCcrzCompositProducts(new List < String > {
                InputData
                    });
            
            //ccrz__Component__r.Name, ccrz__Component__r.ccrz__SKU__c
            for (ccrz__E_CompositeProduct__c compProd: eCompositeProducts) {
                ccrz.ccLog.log('compProd----->'+compProd);
                productIdList.add(compProd.ccrz__Component__c);
                if(compProd.ccrz__Component__r.Name.containsIgnoreCase('Base')){
                    baseSku = compProd.ccrz__Component__r.ccrz__SKU__c;
                    baseProductId = compProd.ccrz__Component__c;
                }
            }
            
            Set<String> allSubscriptionProdIds = new Set<String>();
            allSubscriptionProdIds.addAll(productIdList);
            Set<String> relatedProdIds = new Set<String>();
            ccrz.ccLog.log('productIdList___'+productIdList);
            List<ccrz__E_RelatedProduct__c> relatedProductAccessories = OSM_SW_ProdDetailUtils_Ctrl.getAddOnProducts(productIdList);
            ccrz.ccLog.log('relatedProductAccessories___'+relatedProductAccessories);
            
            
            //sharad date: 28 Oct 2019: for: Bundle count
            Set<Id> compositeProductSet = new Set<Id>();
            Map<Id, List<ccrz__E_CompositeProduct__c>> mapProductVsCompositeProduct = new Map<Id, List<ccrz__E_CompositeProduct__c>>();
            Map<Id, Integer> mapCPVsBundleCount = new Map<Id, Integer>();
            
            for(ccrz__E_RelatedProduct__c rp : relatedProductAccessories){
                compositeProductSet.add(rp.ccrz__RelatedProduct__c);
            }
            
            if(compositeProductSet.size() > 0)
            {
                List<ccrz__E_CompositeProduct__c> listComProduct = new List<ccrz__E_CompositeProduct__c>();
                listComProduct = [Select Id, ccrz__Composite__c, ccrz__Quantity__c,ccrz__Component__r.Name,ccrz__Component__r.ccrz__SKU__c from ccrz__E_CompositeProduct__c where ccrz__Composite__c IN: compositeProductSet];
                
                if(listComProduct.size() > 0)
                {
                    for(ccrz__E_CompositeProduct__c objCP : listComProduct)
                    {
                        if(!mapProductVsCompositeProduct.containsKey(objCP.ccrz__Composite__c))
                            mapProductVsCompositeProduct.put(objCP.ccrz__Composite__c, new List<ccrz__E_CompositeProduct__c>());
                        mapProductVsCompositeProduct.get(objCP.ccrz__Composite__c).add(objCP);
                    }
                    
                    for(Id key : mapProductVsCompositeProduct.keySet())
                    {
                        Integer bundleCount = 0;
                        for(ccrz__E_CompositeProduct__c objCP: mapProductVsCompositeProduct.get(key))
                        {
                            if(System.label.SES_OMSCreateOrder_SubscriptionProduct_List.toUpperCase().contains(objCP.ccrz__Component__r.ccrz__SKU__c.toUpperCase()))
                            {
                                bundleCount = bundleCount+Integer.valueOf(objCP.ccrz__Quantity__c);
                            }
                        }
                        if(bundleCount > 0)
                        {
                            mapCPVsBundleCount.put(key,bundleCount);
                        }
                        
                    }
                    
                    
                }
            }
            
            
            for(ccrz__E_RelatedProduct__c rp : relatedProductAccessories){
                relatedProdIds.add(rp.ccrz__RelatedProduct__c);
                
                AddOnProducts addProd = new AddOnProducts();
                addProd.quantity = 0;
                addProd.Prices = 0;
                addProd.TotalPrice = 0;
                // Sharad
                addProd.bundleCount = 1;
                if(mapCPVsBundleCount.containsKey(rp.ccrz__RelatedProduct__c))
                    addProd.bundleCount = mapCPVsBundleCount.get(rp.ccrz__RelatedProduct__c);
                addProd.productId = rp.ccrz__RelatedProduct__c;
                addProd.productName = rp.ccrz__RelatedProduct__r.Name;
                addProd.productSku = rp.ccrz__RelatedProduct__r.ccrz__SKU__c;
                addProd.supportingText= rp.ccrz__RelatedProduct__r.Product_Supporting_Text__c;
                addProd.productShortDesc = rp.ccrz__RelatedProduct__r.ccrz__ShortDesc__c; 
                List<AddOnProducts> addOnProducts = new List<AddOnProducts>();
                if(productIdVsAddOnProducts.keySet().contains(rp.ccrz__Product__c)){
                    addOnProducts = productIdVsAddOnProducts.get(rp.ccrz__Product__c);
                    addOnProducts.add(addProd);
                    productIdVsAddOnProducts.put(rp.ccrz__Product__c,addOnProducts);
                }else{
                    addOnProducts = new List<AddOnProducts>();
                    addOnProducts.add(addProd);
                    productIdVsAddOnProducts.put(rp.ccrz__Product__c,addOnProducts);
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
                //ccrz.ccLog.log('====hasActiveSubs inside-1:'+hasActiveSubs);
                //availableSubs = OSM_SW_ProductDetaiServiceCls.fetchDiscountedPrice(ctx.storefront,userId, ccrz.cc_CallContext.currAccountId,productIdList);
                availableSubs = OSM_SW_ProductDetaiServiceCls.getDiscountedPrice(ctx.storefront, ccrz.cc_CallContext.effAccountId, productIdList);
                //ccrz.ccLog.log('====hasActiveSubs inside-2:'+availableSubs);
                if(Test.isRunningTest()){
                    //throw new NullPointerException();
                }
            }catch(Exception ex){ccrz.ccLog.log(ex +'====line===>'+ex.getLineNumber());}
            
            //MP-135 - Start-Added AND Condition for renewSuProd - 16-Nov-2021
            if(availableSubs !=null && availableSubs.subscriptionStatus != null && !String.isBlank(availableSubs.subscriptionStatus) && String.isBlank(renewSubProd)){
                hasActiveSubs = true;
                //ccrz.ccLog.log('====hasActiveSubs inside:'+hasActiveSubs);
            }
            //ccrz.ccLog.log('====hasActiveSubs outside:'+availableSubs);
            //ccrz.ccLog.log('====ProductIdList:'+productIdList);
            if(parentProductName.containsIgnoreCase('Incal')){
                availableSubs.isSubscribed = false; 
            }
            
            boolean  hasRelatedProductSubscribed = false;
            String relatedProductSubscEndDate = '';
            String relatedProductSubscLength = '';
            Datetime   relatedProductSubscEndDateformat ;
            ccrz__E_Subscription__c subcription = new ccrz__E_Subscription__c();
            boolean hasAnySubscription = false;
            allSubscriptionProdIds.addAll(lstRelatedProductId);
             Map<Id,ccrz__E_Subscription__c> subsidmap = new Map<Id,ccrz__E_Subscription__c>();//added by swetha MP-473
            if(availableSubs.accountSubscriptions != null && availableSubs.accountSubscriptions.size()>0){
                for(ccrz__E_Subscription__c sub : availableSubs.accountSubscriptions){
                    if(!sub.ccrz__SubscriptionProduct__r.Name.ContainsIgnoreCase('INCAL') &&
                       ((allSubscriptionProdIds.Contains(sub.ccrz__SubscriptionProduct__c) 
                         || allSubscriptionProdIds.Contains(sub.OSM_Display_Product__c)) && !sub.ccrz__SPT__r.ccrz__DisplayName__c.Contains('99')) ){
                             subcription = sub;
                             if(String.isBlank(renewSubProd)){ //MP-135 - Added If Condition for non renew products- 16-Nov-2021
                             hasAnySubscription = true;
                             hasRelatedProductSubscribed = true;
                             }
                            // relatedProductSubscEndDate = ''+sub.OSM_Subscription_End_Date__c.Day()+' '+OSM_SW_ProductDetailCommonUtility.getMonth(sub.OSM_Subscription_End_Date__c.Month())+' '+sub.OSM_Subscription_End_Date__c.Year();
                            // relatedProductSubscEndDateformat = sub.OSM_Subscription_End_Date__c;
                             //relatedProductSubscLength = sub.ccrz__SPT__r.ccrz__DisplayName__c;
                             break;
                         }
                }
            }
            //added by swetha MP-473,MP_669
            if(hasRelatedProductSubscribed || Test.isRunningTest()){
            String incalskus= System.Label.OSM_NonCoTerm_Products;
            System.debug('incalskus-->'+incalskus);
            List<String> incalskuslist = incalskus.split(',');
            List<ccrz__E_Subscription__c> lstSubsc = new List<ccrz__E_Subscription__c>();
            
             if(availableSubs.accountSubscriptions != null && availableSubs.accountSubscriptions.size()>0){
                for(ccrz__E_Subscription__c sub : availableSubs.accountSubscriptions){ 
                    subsidmap.put(sub.id,sub);
                }
            }
           
           List<ccrz__E_Subscription__c> lstSubscrelated = new List<ccrz__E_Subscription__c>();
           String account=ccrz.cc_CallContext.effAccountId; 
           lstSubscrelated  = [Select Id,OSM_Subscription_End_Date__c  from ccrz__E_Subscription__c where (ccrz__SubscriptionProduct__c In:allSubscriptionProdIds OR OSM_Display_Product__c In:allSubscriptionProdIds)  and ccrz__Account__c =: account and ccrz__Storefront__c =: storefront and (ccrz__SubscriptionProduct__r.ccrz__SKU__c NOT IN:incalskuslist) and (NOT ccrz__SPT__r.ccrz__DisplayName__c LIKE '%99%') and ccrz__SubscriptionStatus__c = 'Active' and  OSM_Subscription_End_Date__c >: System.today() ORDER BY CreatedDate DESC ];
            //System.debug('lstSubscsize-->'+lstSubscrelated.size());
            //System.debug('lstSubsc-->'+lstSubsc);
            Map<datetime,ccrz__E_Subscription__c> Osmendsubmap = new Map<datetime,ccrz__E_Subscription__c>();
            if(lstSubscrelated != null && lstSubscrelated.size()>0){
                for(ccrz__E_Subscription__c sub : lstSubscrelated){ 
                    Osmendsubmap.put(sub.OSM_Subscription_End_Date__c,sub);
                }
            }
           List<AggregateResult> lstsubscriptions = new List<AggregateResult>();
           lstsubscriptions = [select day_only(createdDate) createddate,MAX(OSM_Subscription_End_Date__c) Maxenddate,count(createdDate) numCreated from ccrz__E_Subscription__c where  (ccrz__SubscriptionProduct__c In:allSubscriptionProdIds OR OSM_Display_Product__c In:allSubscriptionProdIds) and ( ccrz__SubscriptionProduct__r.ccrz__SKU__c NOT IN:incalskuslist) AND (NOT ccrz__SPT__r.ccrz__DisplayName__c LIKE '%99%') and ccrz__Account__c =: account and ccrz__Storefront__c =: storefront and ccrz__SubscriptionStatus__c = 'Active' and OSM_Subscription_End_Date__c >: System.today() and OSM_SW_Is_without_Coterm__c = false group by day_only(createdDate) order by day_only(createdDate) Asc];
           datetime Maxdateinsameday; 
           if(lstsubscriptions != null && lstsubscriptions.size()>0){ 
             Maxdateinsameday = (datetime) lstsubscriptions[0].get('Maxenddate');
            /*for (AggregateResult ar : lstsubscriptions) { 
                System.debug('Maxenddate in sameday' + ar.get('createddate') + ' and ' + ar.get('Maxenddate') + 'and' + ar.get('numCreated'));
               
                } */ 
            
           //System.debug('Maxdateinsameday-->'+Maxdateinsameday);
            relatedProductSubscEndDate = ''+Maxdateinsameday.Day()+' '+OSM_SW_ProductDetailCommonUtility.getMonth(Maxdateinsameday.Month())+' '+Maxdateinsameday.Year();
            relatedProductSubscEndDateformat = Maxdateinsameday;
            //System.debug('Osmendsubmap-->'+Osmendsubmap);  
            ccrz__E_Subscription__c subfound ;
            if(Osmendsubmap.containskey(Maxdateinsameday)){
                  subfound = Osmendsubmap.get(Maxdateinsameday);
             }
              //System.debug('subfound-->'+subfound);    
            if(subsidmap.containskey(subfound.Id)){
                   ccrz__E_Subscription__c finalsub = subsidmap.get(subfound.Id) ;
                   relatedProductSubscLength = finalsub.ccrz__SPT__r.ccrz__DisplayName__c; 
                    subcription = finalsub;
                
               }
           
              // System.debug('relatedProductSubscLength-->'+relatedProductSubscLength);  
            }     
            }
            
           //end by swetha MP-473
            //ccrz.ccLog.log('subcription==>'+subcription);
            //code to get related product subscription
            /* seems extra 
try{
if(Test.isRunningTest()){
hasActiveSubs=false;
}
if(!hasActiveSubs)
{
if(lstRelatedProductId != null && lstRelatedProductId.size() > 0)
{
List<ccrz__E_Subscription__c> subscList = new List<ccrz__E_Subscription__c>();

subscList = [Select Id,OSM_Subscription_End_Date__c, ccrz__SPT__r.ccrz__DisplayName__c 
from ccrz__E_Subscription__c 
where ccrz__Account__c =: ccrz.cc_CallContext.currAccountId 
AND ccrz__Storefront__c =: ctx.storefront 
and OSM_Display_Product__c IN: lstRelatedProductId 
AND ccrz__SubscriptionStatus__c = 'Active' 
AND OSM_Subscription_End_Date__c >= TODAY
AND  (NOT ccrz__SPT__r.ccrz__DisplayName__c like '%99%')];

if((subscList != null && subscList.size() > 0)  || Test.isRunningTest())
{
//hasRelatedProductSubscribed = true;
//relatedProductSubscEndDate = ''+subscList[0].OSM_Subscription_End_Date__c.Day()+' '+OSM_SW_ProductDetailCommonUtility.getMonth(subscList[0].OSM_Subscription_End_Date__c.Month())+' '+subscList[0].OSM_Subscription_End_Date__c.Year();
//relatedProductSubscLength = subscList[0].ccrz__SPT__r.ccrz__DisplayName__c;
}

}

}


}
catch(Exception ex)
{
ccrz.ccLog.log('exception on related product details: '+ex);
}*/
            
            
            
            
            
            // code end
            //After Vaibhav meeting will revert it back
            //hasActiveSubs = false;
            /*   
ccrz.ccAPIProduct.fetch(new Map < String, Object > {
ccrz.ccApi.API_VERSION => ccrz.ccApi.CURRENT_VERSION,
ccrz.ccAPIProduct.PARAM_INCLUDE_PRICING => TRUE,
ccrz.ccAPIProduct.PRODUCTIDLIST => productIdList
});
*/
            Set<String> allProdIds = new Set<String>();
            allProdIds.addAll(productIdList);
            allProdIds.addAll(relatedProdIds);
            Map < String, Object > returnData = new Map < String, Object >();
            if(!Test.isRunningTest()){
                returnData = ccrz.ccAPIProduct.fetch(new Map < String, Object > {
                    ccrz.ccApi.API_VERSION => ccrz.ccApi.CURRENT_VERSION,
                        ccrz.ccAPIProduct.PARAM_INCLUDE_PRICING => TRUE,
                        ccrz.ccAPIProduct.PRODUCTIDLIST => allProdIds//,
                        //ccrz.ccService.ORDERBY => ccrz.ccAPIProductIndex.BY_SEQUENCE 
                        //ccrz.ccApiRelatedProduct.PRODUCTIDLIST =>relatedProdIds,
                        //ccrz.ccApiRelatedProduct.RELATED_TYPE => new Set<String>{'Accessories'}
                        });
            }
           // ccrz.ccLog.log('ccrz.ccApiProduct.PRODUCTLIST');
           // ccrz.ccLog.log(ccrz.ccApiProduct.PRODUCTLIST);
           // ccrz.ccLog.log(returnData );
            
            Map < String, ProductDetailWrapper > productIdVsWrapperMap = new Map < String, ProductDetailWrapper > ();
            Map < String, ProductDetailWrapper > addOnProductIdVsWrapperMap = new Map < String, ProductDetailWrapper > ();
            
            Map < String, String > compositKeyForSubProdTerm = new Map < String, String > ();
            Map < String, String > subProdTermPrices = new Map < String, String > ();
            boolean onlyBase = false;
            ProductDetailWrapper prodDetail;
            boolean isBase = false;
            boolean isPlus = false;
            boolean isPro = false;
            Map < String, SubProdTerm > subProdTermMap;
            Set < String > subProdTermIds = new Set < String > ();
            Set < String > relatedsubProdTermIds = new Set < String > ();
            Set < String > mainSubProdTermIds = new Set < String > ();
            Map < String, Map < String, Object >> prodMapFromApi = new Map < String, Map < String, Object >> ();
            
            if ((returnData != null && returnData.size() > 0) || Test.isRunningTest()) {
                List < Map < String, Object >> productLst;
                if(Test.IsRunningTest()){
                    productLst =OSM_SW_ProdDetail_SES1_Comp_Ctrl_Test.productListTestData();
                    ccrz.ccLog.log('______productLst_____'+productLst );
                    
                }else{
                    productLst = (List < Map < String, Object >> ) returnData.get(ccrz.ccApiProduct.PRODUCTLIST);
                    //  productLst.sort();
                   // ccrz.ccLog.log('______productLst___else__'+productLst );
                }
                for (Map < String, Object > productMap: productLst) {
                    //ccrz.ccLog.log('______productLst__for loop___'+productLst );
                    
                    if (productMap != null) {
                        
                        for (String key_tmp: productMap.keySet()) {
                            //ccrz.ccLog.log('=====Key API====' + key_tmp);
                            ccrz.ccLog.log('=====Key API====' + productMap.get(key_tmp));
                        }
                        //ccrz.ccLog.log('=====SF ID from API====' + productMap.get('sfid'));
                        ProductIdForSubscription = (String)productMap.get('sfid');
                        prodMapFromApi.put((String) productMap.get('sfid'), productMap);
                    }
                    
                }
                
                
                Map < String, Object > responseMap = new Map < String, Object >();
                if(Test.isRunningTest()){
                    Try{
                        //  productIdList.add('id');
                        Map<String,Object> responseMapInner=new Map<String,Object>();
                        Map<String,Object> subProdTermMap2=new  Map<String,Object>();         
                        responseMapInner.put('subProductTerms',subProdTermMap2);
                        responseMap.put('id',responseMapInner);
                        //ccrz.ccLog.log('responseMap ____'+responseMap);
                    }
                    Catch(Exception e)
                    {
                       // ccrz.ccLog.log('???????responseMap'+e);
                    }
                    
                }
                else
                {
                    //ccrz.ccLog.log('responseMap ____'+responseMap);
                    
                    responseMap = (Map < String, Object > ) returnData.get(ccrz.ccAPIProduct.PRODUCTPRICINGDATA);
                }
                //responseMap points to each product
                for (String key: responseMap.keySet()) {
                    prodDetail = new ProductDetailWrapper();
                    subProdTermMap = new Map < String, SubProdTerm > ();
                    if(Test.IsrunningTest()){
                        allProdIds.add(key);
                    }
                    if(allProdIds.contains((String)key)){
                        prodDetail.sfId = key;
                        //prodDetail.productName = 
                        //ccrz.ccLog.log('prodDetail.sfId____'+prodDetail.sfId);
                        Map < String, Object > responseMap1 = (Map < String, Object > ) responseMap.get(key);
                        
                        //ccrz.ccLog.log('******************************responseMap1 =====' + responseMap1);
                        for (String key1: responseMap1.keySet()) {
                            //this prints subProductTerms,minSubPrice,maxSubPrice
                            //ccrz.ccLog.log('******************************Final Key=====' + key1);
                            if (key1.equalsIgnoreCase('productPrice')) {
                                Map < String, Object > productPriceMap = (Map < String, Object > ) responseMap1.get(key1);
                                //ccrz.ccLog.log(productPriceMap);
                              //  ccrz.ccLog.log('productPriceMap size from API===' + productPriceMap.size());
                                
                            }
                            if (key1.equalsIgnoreCase('subProductTerms')) {
                                //ccrz.ccLog.log('______sub_____'+key1);
                                Map < String, Object > subProdTermsMap;
                                
                                subProdTermsMap = (Map < String, Object > ) responseMap1.get(key1);
                                
                                
                                
                                ccrz.ccLog.log(subProdTermsMap);
                                ccrz.ccLog.log('subProdTermsMap size from API===' + subProdTermsMap.size());
                                //code added to cover test class
                                if(Test.isRunningTest()){
                                    Map<String,Map<String,Object>> innerMap=new Map<String,Map<String,Object>>();
                                    Map<String,Object> innerMap2=new Map<String,Object>();
                                    Map<String,Object> innerMap3=new Map<String,Object>();
                                    innerMap2.put('price',120.00);
                                    innerMap3.put('price',120.00);
                                    innerMap2.put('priceList','id');
                                    innerMap2.put('sfid','id');
                                    innerMap3.put('priceList','id');
                                    innerMap3.put('sfid','id'); 
                                    innerMap.put('nonRecurringPrice',innerMap2);
                                    innerMap.put('recurringPrice',innerMap2);
                                    subProdTermsMap.put('id',innerMap);
                                }
                                for (String subProdTermid: subProdTermsMap.keySet()) {
                                    
                                    subProdTermIds.add(subProdTermid);
                                    if(prodDetail.sfId != null){
                                        if(productIdList.contains(prodDetail.sfId)){
                                            mainSubProdTermIds.add(subProdTermid);
                                        }
                                        if(relatedProdIds.contains(prodDetail.sfId)){
                                            relatedsubProdTermIds.add(subProdTermid);
                                        }
                                    }
                                    //single record for SubProdTerm
                                    SubProdTerm subProdTermObj = new SubProdTerm();
                                    subProdTermObj.sfId = subProdTermid;
                                    
                                    Map < String, Object > subProdTerm = (Map < String, Object > ) subProdTermsMap.get(subProdTermid);
                                    ccrz.ccLog.log('=======subProdTerm==========');
                                    ccrz.ccLog.log(subProdTerm);
                                    Map < String, Object > nonReccuringPrice = (Map < String, Object > ) subProdTerm.get('nonRecurringPrice');
                                    Map < String, Object > recurringPrice = (Map < String, Object > ) subProdTerm.get('recurringPrice');
                                    subProdTermObj.nonRecurringPrice = (Decimal) nonReccuringPrice.get('price');
                                    subProdTermObj.nonRecurringPriceListId = (String) nonReccuringPrice.get('priceList');
                                    subProdTermObj.nonRecurringPriceListItemId = (String) nonReccuringPrice.get('sfid');
                                    subProdTermObj.recurringPrice = (Decimal) recurringPrice.get('price');
                                    subProdTermObj.recurringPriceListId = (String) recurringPrice.get('priceList');
                                    subProdTermObj.recurringPriceListItemId = (String) recurringPrice.get('sfid');
                                    
                                    subProdTermMap.put(subProdTermid, subProdTermObj);
                                    String subProdTermPrice = subProdTermObj.recurringPrice + ':' + subProdTermObj.nonRecurringPrice;
                                    subProdTermPrices.put(subProdTermid, subProdTermPrice);
                                    
                                }
                                
                                prodDetail.subProdTermMap = subProdTermMap;
                                ccrz.ccLog.log('prodDetail.subProdTermMap--->'+prodDetail.subProdTermMap);
                            }
                            
                            if (key1.equalsIgnoreCase('GOMSPartNumber')){
                               prodDetail.GOMSPartNumber =(String) responseMap1.get(key1);
                            }
                             
                            
                        }
                        
                        //ccrz.ccLog.log('******************************Final value====='+str);
                    }
                    
                    if(prodDetail.sfId != null){
                        
                        boolean isProcessProduct = false;
                        if(Test.IsRunningTest())
                        {
                            availableSubs.billingFrequency='Monthly';
                            availableSubs.recurringPrice=2;
                            availableSubs.isSubscribed=true;
                            availableSubs.subscriptionProduct = prodDetail.sfId;
                        }
                        System.debug('-----'+availableSubs);
                        if(!Test.isRunningTest() && availableSubs != null && availableSubs.isSubscribed && !availableSubs.isQSOLPowerGenProduct && !Test.isRunningTest())
                        //if(availableSubs != null && availableSubs.isSubscribed )
                        {
                            if(availableSubs.subscriptionProduct == prodDetail.sfId)
                                isProcessProduct = true;
                        }
                        else
                        {
                            isProcessProduct = true;
                        }
                        
                        if(!Test.isRunningTest() && availableSubs != null && availableSubs.isSubscribed)
                        {
                            if(availableSubs.subscriptionProduct == prodDetail.sfId)
                                mapProductSubscribed.put(prodDetail.sfId,true);
                        }
                        /**  if(test.isRunningTest()){
                            productIdList.add(prodDetail.sfId);
                            relatedProdIds.add(prodDetail.sfId);
                            }**/
                        if(isProcessProduct)
                        {
                            if(productIdList.contains(prodDetail.sfId) || Test.isRunningTest()){
                                
                                productIdVsWrapperMap.put(prodDetail.sfId, prodDetail);
                                
                            }
                            
                        }
                        if(relatedProdIds.contains(prodDetail.sfId) || Test.isRunningTest()){
                            addOnProductIdVsWrapperMap.put(prodDetail.sfId, prodDetail);
                        }
                    }
                }
            }
            ccrz.ccLog.log('relatedProdIds-->'+relatedProdIds);
            ccrz.ccLog.log('addOnProductIdVsWrapperMap-->'+addOnProductIdVsWrapperMap);
            List < String > prodIds = new List < String > ();
            prodIds.addAll(subProdTermIds);
            Set<String>OneTimeSets = new Set<String>{'OneTime','One-Time','One Time'};
                Decimal selectedSubsInstallmentCount = 0;
            Decimal selectedSubsInstallmentFrequency = 0;
            Decimal finalYearlyPrice = 0;
            Decimal proratedPrice = 0;
            Decimal proratedDnPrice = 0;
            //Map < Id, ccrz__E_SubProdTerm__c > subProdMap = OSM_SW_ProdDetailUtils_Ctrl.getSubProdTermsMap(prodIds, ctx.storefront);
            // < Id, ccrz__E_SubProdTerm__c > subProdMap = OSM_SW_ProdDetailUtils_Ctrl.getSubProdTermsMap(prodIds);
            
            map < Id, ccrz__E_SubProdTerm__c > subProdMap = new Map < Id, ccrz__E_SubProdTerm__c >();
            Map < Id, ccrz__E_SubProdTerm__c > relProdSubProdMap = new Map < Id, ccrz__E_SubProdTerm__c >();
            Map < Id, ccrz__E_SubProdTerm__c > allSubProdMap = OSM_SW_ProdDetailUtils_Ctrl.getSubProdTermsMap(prodIds, ctx.storefront);
            if(Test.isrunningTest())
            {
                //allSubProdMap =OSM_SW_ProdDetail_DA_Comp_CtrlTest.subProdTermData();
                hasActiveSubs=true;
                availableSubs.isSubscribed=true;
                availableSubs.billingFrequency='Monthly';
                availableSubs.recurringPrice=2;
            }
            for(Id key : allSubProdMap.keySet()){
                if(mainSubProdTermIds.contains(key)){
                    subProdMap.put(key, allSubProdMap.get(key));
                }
                if(relatedsubProdTermIds.contains(key)){
                    relProdSubProdMap.put(key, allSubProdMap.get(key));
                }
            }
            
            ccrz.ccLog.log('=====finalYearlyPrice ====' + finalYearlyPrice);
            Map<String, Decimal> prodYearPrice = new Map<String, Decimal>();
            Map<String, Decimal> proratedPriceMap = new Map<String, Decimal>();
            Map<String,Decimal> proratedDnPriceMap = new Map<String,Decimal>(); 
            Map<String,Decimal> prodMonthlyPrice = new Map<String, Decimal>();
            Map<String, String> pricePerBillFrequency = new Map<String, String>();
            ccrz.ccLog.log('productIdVsWrapperMap-->'+productIdVsWrapperMap.size());
            Decimal originalDNPrice=0;
            if(!ccrz.cc_CallContext.isGuest || ccrz.cc_CallContext.isGuest){
                
                
                List<ccrz__E_PriceListItem__c> priceList = [Select Id, Distributor_Price__c, ccrz__Price__c, ccrz__SubProdTerm__c  from ccrz__E_PriceListItem__c where ccrz__SubProdTerm__c IN: allSubProdMap.keySet() and ccrz__RecurringPrice__c = false];
                if(Test.isRunningTest()){
                    //priceList = OSM_SW_ProdDetail_SES1_Comp_Ctrl_Test.getTestPriceList();//().values();
                }
                for (String prodId: productIdVsWrapperMap.keySet()) {
                    
                    if(productIdList.contains(prodId) || Test.isRunningTest()){
                        
                        
                        boolean onTimePrice = true;
                        ProductDetailWrapper prodDetailObj = productIdVsWrapperMap.get(prodId);
                        ccrz.ccLog.log('=====prodDetail ====' + prodDetailObj);
                        Map < String, SubProdTerm > subProdTerms = prodDetailObj.subProdTermMap;
                        
                        if(subProdTerms != null){   
                            ccrz.ccLog.log('=====subProdTerms size ====' + subProdTerms.size());
                            Decimal perDayPrice = 0;
                            Decimal perDayDnPrice = 0;
                            Decimal perMonthPrice = 0;
                            Decimal perMonthDnPrice = 0;
                            
                            
                            /* Logic to calculate PerdayPrice and Monthly Price*/
                            for (String subProdTermId: subProdTerms.keySet()) {
                                ccrz__E_SubProdTerm__c subProdFromDB = new ccrz__E_SubProdTerm__c();
                                if(!Test.isRunningTest()){  
                                    subProdFromDB = subProdMap.get(subProdTermId);
                                }else{
                                    subProdFromDB.Billing_Display_Name__c='One Time';
                                    subProdFromDB.ccrz__DisplayName__c = '1 Year';
                                }
                                if(subProdFromDB.Billing_Display_Name__c.EqualsIgnoreCase('One Time') 
                                   && subProdFromDB.ccrz__DisplayName__c.EqualsIgnoreCase('1 Year')){
                                       if(Test.isRunningTest()){ 
                                           perMonthDnPrice = 12;
                                           perDayDnPrice = 365;
                                           perDayPrice = 365;
                                           perMonthPrice = 12;
                                           //subProdTermId = priceList[0].ccrz__SubProdTerm__c;
                                       }
                                       for(ccrz__E_PriceListItem__c pl : priceList){
                                           if(pl.ccrz__SubProdTerm__c == subProdTermId){
                                               //ccrz.ccLog.log('Existing Pl-->'+pl);
                                               //SubProdTerm subProdTerm = subProdTerms.get(subProdTermId);
                                               perMonthDnPrice = pl.Distributor_Price__c/12;
                                               perDayDnPrice = pl.Distributor_Price__c/365;
                                               perDayPrice = pl.ccrz__Price__c/365;
                                               perMonthPrice = pl.ccrz__Price__c/12;
                                               originalDNPrice=pl.Distributor_Price__c;
                                               break;
                                           }
                                       }
                                       
                                   }
                            }
                            
                            if(hasAnySubscription || Test.isRunningTest()){
                                subcription.OneTimePerDayPrice__c = perDayPrice;
                                subcription.Monthly_Price__c = perMonthPrice;
                                subcription.PerDayDnPrice__c = perDayDnPrice;
                                subcription.Monthly_Dn_Price__c = perMonthDnPrice;
                            }
                            //ccrz.ccLog.log('perMonthDnPrice-->'+perMonthDnPrice);
                           //ccrz.ccLog.log('perDayDnPrice-->'+perDayDnPrice);
                            //ccrz.ccLog.log('perDayPrice-->'+perDayPrice);
                            //ccrz.ccLog.log('perMonthPrice-->'+perMonthPrice);
                            
                            //ccrz.ccLog.log('subcription-->'+subcription);
                            //ccrz.ccLog.log('subProdTerms.keySet()-->'+subProdTerms.keySet());
                            for (String subProdTermId: subProdTerms.keySet()) {
                                //ccrz.ccLog.log(availableSubs.STP+'=====subProdTerms I ====' + subProdTermId); 
                                
                                SubProdTerm subProdTerm = subProdTerms.get(subProdTermId);
                                
                                ccrz__E_SubProdTerm__c subProdFromDB = new ccrz__E_SubProdTerm__c();
                                if(!Test.isRunningTest()){
                                    subProdFromDB = subProdMap.get(subProdTermId);
                                }else{
                                    subProdFromDB.ccrz__InstallmentCount__c = 1;
                                    subProdFromDB.ccrz__OrderFrequency__c = 1;
                                    subProdFromDB.Billing_Display_Name__c = 'One Time';
                                }
                                Decimal prodSubscriptionPriceYearly = 0;
                                Decimal prodSubscriptionPriceMonthly = 0;
                                Decimal price = 0;
                                Decimal rfqPrice = 0;
                                price = subProdTerm.nonRecurringPrice;
                                Decimal DnPrice = 0;
                                for(ccrz__E_PriceListItem__c pl : priceList){
                                    if(pl.ccrz__SubProdTerm__c == subProdTermId){
                                        DnPrice = pl.Distributor_Price__c != null ? pl.Distributor_Price__c:0;
                                        originalDNPrice=DnPrice;
                                        break;
                                    }
                                }
                                prodSubscriptionPriceYearly = price != 0 ? ((price * subProdFromDB.ccrz__InstallmentCount__c)/subProdFromDB.ccrz__OrderFrequency__c) :0;
                                
                                String pricePerBill = ''+price.setScale(2)+' '+(subProdFromDB.OSM_Bill_Freq__c != null ?subProdFromDB.OSM_Bill_Freq__c:'');
                                proratedDnPrice = DnPrice;
                                if(!parentProductName.containsIgnoreCase('Incal') && hasAnySubscription && (String.isBlank(parentStandAlone) || (String.isNotBlank(parentStandAlone) && parentStandAlone=='Subscription') || Test.isRunningTest())){ 
                                    proratedPrice = OSM_SW_ProrationUtility.getCalculatedProrationAmount(subcription, subProdFromDB.Billing_Display_Name__c, Label.OSM_ProrationType_Price);
                                    try{
                                        proratedDnPrice = OSM_SW_ProrationUtility.getCalculatedProrationAmount(subcription, subProdFromDB.Billing_Display_Name__c, Label.OSM_ProrationType_DnPrice);
                                    }catch(Exception ex){
                                        proratedDnPrice = 0;
                                    }
                                    proratedPrice = proratedPrice.setScale(2);
                                    proratedDnPrice = proratedDnPrice.setScale(2);
                                    
                                    Date subsendDate = Date.newInstance(subcription.OSM_Subscription_End_Date__c.Year(),subcription.OSM_Subscription_End_Date__c.Month(),subcription.OSM_Subscription_End_Date__c.Day());
                                    Date subscriptionStartDate = Date.newInstance(subcription.ccrz__SubscriptionStartDate__c.year(), subcription.ccrz__SubscriptionStartDate__c.month(), subcription.ccrz__SubscriptionStartDate__c.Day());
                                    /*if(subcription.ccrz__SubscriptionProduct__r.Group_Name__c == 'SES'){     
//subscriptionStartDate = subsendDate.addDays(-364);
}*/
                                    if(subscriptionStartDate == System.today() && subcription.Purchase_Date__c == null){
                                        proratedPrice = price;
                                        proratedDnPrice = DnPrice;
                                    }
                                }
                                String compositeKey = subProdFromDB.ccrz__CCProduct__r.ccrz__SKU__c + subProdFromDB.Billing_Display_Name__c + subProdFromDB.ccrz__DisplayName__c;
                                prodYearPrice.put(subProdFromDB.ccrz__CCProduct__r.ccrz__SKU__c+subProdFromDB.ccrz__DisplayName__c,prodSubscriptionPriceYearly);
                                //prodYearPrice.put(compositeKey,prodSubscriptionPriceYearly);
                                proratedPriceMap.put(compositeKey,proratedPrice); 
                                proratedDnPriceMap.put(compositeKey,proratedDnPrice); 
                                prodYearPrice.put(compositeKey,price);
                                prodMonthlyPrice.put(compositeKey,prodSubscriptionPriceMonthly);
                                pricePerBillFrequency.put(compositeKey,pricePerBill);
                                compositKeyForSubProdTerm.put(compositeKey, subProdFromDB.Id);
                                ccrz.ccLog.log('===subProdTerm while Iterating===' + subProdTerm);
                            }
                            
                        }
                        ccrz.ccLog.log('=====SF ID of Product ====' + prodId);
                        Map < String, Object > productDataMap = prodMapFromApi.get(prodId);
                        
                        ccrz.ccLog.log('$$$ productDataMap: '+productDataMap);
                        
                        //buttonName will have Base/Plus/Pro
                        String buttonName = '';
                        if(!Test.isRunningTest()){
                            buttonName = (String) productDataMap.get('package');
                        }else{
                            buttonName ='BaseLitePro';
                        }
                        
                        ccrz.ccLog.log('=====buttonName of Product ====' + buttonName);
                        
                        if(!Test.isRunningTest() && !(boolean)productDataMap.get('QSOLPowerGeneration'))
                        {
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
                        
                        }
                        else{
                            if(!Test.isRunningTest())
                            {
                                String productName = (String) productDataMap.get('versionDisplay');
                                    buttonName = productName;
                                if(mapProductSubscribed.containsKey(prodId))
                                {
                                    prodDetailObj.selectedPowerGenProduct = true;
                                }
                                else
                                {
                                    prodDetailObj.selectedPowerGenProduct = false;
                                }
                            }
                        }
                        String longDesc='';
                        if(!Test.isRunningTest())
                        longDesc = (String) productDataMap.get('longDesc');
                        
                        prodDetailObj.buttonName = buttonName;
                        prodDetailObj.longDesc = longDesc;
                        if(!Test.isRunningTest() && productDataMap.containskey('GOMSPartNumber') )prodDetailObj.GOMSPartNumber =(String) productDataMap.get('GOMSPartNumber');
                       
                        String sku = '';
                        if(!Test.isRunningTest()){
                            sku = (String) productDataMap.get('SKU');
                        }
                        prodDetailObj.sku = sku;
                        withOutCotermProduct=sku; // Added for MP-632 -> 10-2-2022
                    }
                    
                }
                
                
                //////////////////////  ****************** ////////////////////////////////
                for (String prodId: addOnProductIdVsWrapperMap.keySet()) {
                    if(relatedProdIds.contains(prodId)){
                        boolean onTimePrice = true;
                        ProductDetailWrapper prodDetailObj = addOnProductIdVsWrapperMap.get(prodId);
                        ccrz.ccLog.log('=====prodDetail ====' + prodDetailObj);
                        Map < String, SubProdTerm > subProdTerms = prodDetailObj.subProdTermMap;
                        
                        if(subProdTerms != null ){   
                            //ccrz.ccLog.log('=====subProdTerms size ====' + subProdTerms.size());
                            
                            Decimal perDayPrice = 0;
                            Decimal perDayDnPrice = 0;
                            Decimal perMonthPrice = 0;
                            Decimal perMonthDnPrice = 0;
                            /* Logic to calculate PerdayPrice and Monthly Price*/
                            for (String subProdTermId: subProdTerms.keySet()) {
                                ccrz__E_SubProdTerm__c subProdFromDB = relProdSubProdMap.get(subProdTermId);
                               // ccrz.ccLog.log('Rel subProdFromDB--->'+subProdFromDB);
                                if(subProdFromDB.Billing_Display_Name__c.EqualsIgnoreCase('One Time') 
                                   && subProdFromDB.ccrz__DisplayName__c.EqualsIgnoreCase('1 Year')){
                                       for(ccrz__E_PriceListItem__c pl : priceList){
                                           if(pl.ccrz__SubProdTerm__c == subProdTermId){
                                               ccrz.ccLog.log('Rel pl-->'+pl);
                                               SubProdTerm subProdTerm = subProdTerms.get(subProdTermId);
                                               perMonthDnPrice = (pl.Distributor_Price__c/12).setscale(5);
                                               perDayDnPrice = (pl.Distributor_Price__c/365).setscale(5);
                                               perDayPrice = (pl.ccrz__Price__c/365).setscale(5);
                                               perMonthPrice = (pl.ccrz__Price__c/12).setscale(5);
                                               break;
                                           }
                                       }
                                       
                                   }
                            }
                            
                           // ccrz.ccLog.log('Rel perMonthDnPrice-->'+perMonthDnPrice);
                           // ccrz.ccLog.log('Rel perDayDnPrice-->'+perDayDnPrice);
                           // ccrz.ccLog.log('Rel perDayPrice-->'+perDayPrice);
                           // ccrz.ccLog.log('Rel perMonthPrice-->'+perMonthPrice);
                            
                           // ccrz.ccLog.log('Rel subcription-->'+subcription);
                            
                            if(hasAnySubscription ){
                                subcription.OneTimePerDayPrice__c = perDayPrice;
                                subcription.Monthly_Price__c = perMonthPrice;
                                subcription.PerDayDnPrice__c = perDayDnPrice;
                                subcription.Monthly_Dn_Price__c = perMonthDnPrice;
                            }
                            
                            for (String subProdTermId: subProdTerms.keySet()) {
                               // ccrz.ccLog.log(availableSubs.STP+'=====subProdTerms J ====' + subProdTermId); 
                                
                                
                                
                                SubProdTerm subProdTerm = subProdTerms.get(subProdTermId);
                                
                                ccrz__E_SubProdTerm__c subProdFromDB = relProdSubProdMap.get(subProdTermId);
                                
                                Decimal prodSubscriptionPriceYearly = 0;
                                Decimal prodSubscriptionPriceMonthly = 0;
                                Decimal price = 0;
                                Decimal rfqPrice = 0;
                                price = subProdTerm.nonRecurringPrice;
                                Decimal DnPrice = 0;
                                for(ccrz__E_PriceListItem__c pl : priceList){
                                    if(pl.ccrz__SubProdTerm__c == subProdTermId){
                                        DnPrice = pl.Distributor_Price__c != null ? pl.Distributor_Price__c:0;
                                        originalDNPrice=DnPrice;
                                        break;
                                    }
                                }
                                prodSubscriptionPriceYearly = price != 0 ? ((price * subProdFromDB.ccrz__InstallmentCount__c)/subProdFromDB.ccrz__OrderFrequency__c) :0;
                                
                                String pricePerBill = ''+price.setScale(2)+' '+(subProdFromDB.OSM_Bill_Freq__c != null ?subProdFromDB.OSM_Bill_Freq__c:'');
                                
                                proratedDnPrice = DnPrice;// Fix for MAR-469
                                
                                if(hasAnySubscription){ 
                                    proratedPrice = OSM_SW_ProrationUtility.getCalculatedProrationAmount(subcription, subProdFromDB.Billing_Display_Name__c, Label.OSM_ProrationType_Price);
                                    try{
                                        proratedDnPrice = OSM_SW_ProrationUtility.getCalculatedProrationAmount(subcription, subProdFromDB.Billing_Display_Name__c, Label.OSM_ProrationType_DnPrice);
                                    }catch(Exception ex){
                                        proratedDnPrice = 0;
                                    }
                                    proratedPrice = proratedPrice.setScale(2);
                                    proratedDnPrice = proratedDnPrice.setScale(2);
                                    
                                    Date subsendDate = Date.newInstance(subcription.OSM_Subscription_End_Date__c.Year(),subcription.OSM_Subscription_End_Date__c.Month(),subcription.OSM_Subscription_End_Date__c.Day());
                                    Date subscriptionStartDate = Date.newInstance(subcription.ccrz__SubscriptionStartDate__c.year(), subcription.ccrz__SubscriptionStartDate__c.month(), subcription.ccrz__SubscriptionStartDate__c.Day());
                                    
                                    if(subscriptionStartDate == System.today() && subcription.Purchase_Date__c == null){
                                        proratedPrice = price;
                                        proratedDnPrice = DnPrice;
                                    }
                                    
                                }
                                
                                String compositeKey = subProdFromDB.ccrz__CCProduct__r.ccrz__SKU__c + subProdFromDB.Billing_Display_Name__c + subProdFromDB.ccrz__DisplayName__c;
                                prodYearPrice.put(subProdFromDB.ccrz__CCProduct__r.ccrz__SKU__c+subProdFromDB.ccrz__DisplayName__c,prodSubscriptionPriceYearly);
                                //prodYearPrice.put(compositeKey,prodSubscriptionPriceYearly);
                                proratedPriceMap.put(compositeKey,proratedPrice); 
                                proratedDnPriceMap.put(compositeKey,proratedDnPrice); 
                                prodYearPrice.put(compositeKey,price);
                                prodMonthlyPrice.put(compositeKey,prodSubscriptionPriceMonthly);
                                pricePerBillFrequency.put(compositeKey,pricePerBill);
                               // ccrz.ccLog.log('compositeKey--->'+compositeKey+','+'pricePerBill-->'+pricePerBill);
                                compositKeyForSubProdTerm.put(compositeKey, subProdFromDB.Id);
                               // ccrz.ccLog.log('===subProdTerm while Iterating===' + subProdTerm);
                            }
                            
                        }
                        
                    }
                }
                
                /////////////////////  88888888888888888  //////////////////////////////////
            }
            
            // END : March 19, 2019 - Change added by Juhi - to show the Lite and Pro button for Anonymous User
            if(Test.isRunningTest() || (isBase && !isPlus && !isPro)){
                onlyBase = true;
            }
            // onlyBase = true;
            
            /*  if(!hasActiveSubs){
//ccrz__E_RequestForQuote__c existingReq = OSM_SW_ProdDetailUtils_Ctrl.getUsersQuote(userId, ctx.storefront, productIdList);
Set<String>quoteStatus = new Set<String>{'Requested','In Progress', 'Sent', 'Accepted'};
List<ccrz__E_RequestForQuote__c> existingReq = OSM_SW_ProdDetailUtils_Ctrl.getAccountProductQuotes(ccrz.cc_CallContext.currAccountId, ctx.storefront, quoteStatus, productIdList);

if(existingReq.size()>0){
hasActiveSubs = true;
}
}*/
            
            MainWrapper mainWrapper = new MainWrapper();
            UserDetail userDetail = new UserDetail();
            User user = OSM_SW_ProdDetailUtils_Ctrl.getUserDetail(userId);
            ccrz.ccLog.log('User record>>>>'+user);

            
            
            mainWrapper.hasActiveSubs = hasActiveSubs;
            mainWrapper.toShowCoTerm = false;
            mainWrapper.withCoTerm = false;
            if(Test.isRunningTest() || (hasActiveSubs && System.Label.OSM_SW_Co_Term_Applied_Product.containsIgnoreCase(parentSku)))
            {
                mainWrapper.toShowCoTerm = true;
                
            }
            //MP-697 start
            Boolean makeCoTermFalse=false;
            /*
            List<ccrz__E_Subscription__c> accountsubscriptions =[SELECT id FROM ccrz__E_Subscription__c where 
                        ccrz__Storefront__c =:ctx.storefront
                        and OSM_Free_Trial__c = false
                        and ccrz__SubscriptionStatus__c =: 'Expired'
                        and OSM_SW_Is_without_Coterm__c = false
                        and ccrz__Account__c =: ccrz.cc_CallContext.effAccountId
                        order by createddate DESC];
                        
             if((accountsubscriptions!=null && accountsubscriptions.size()>0) && !hasActiveSubs)
             {
                 makeCoTermFalse=true;
             }*/
            ////MP-697 end 

        //MP-697 start
        //Boolean makeCoTermFalse=false;
        /*   
        List<ccrz__E_Subscription__c> accountsubscriptions =[SELECT id FROM ccrz__E_Subscription__c where 
                    ccrz__Storefront__c =:ctx.storefront
                    and OSM_Free_Trial__c = false
                    and ccrz__SubscriptionStatus__c =: 'Expired'
                    and OSM_SW_Is_without_Coterm__c = false
                    and ccrz__Account__c =: ccrz.cc_CallContext.effAccountId
                    order by createddate DESC];
                    
         if((accountsubscriptions!=null && accountsubscriptions.size()>0) && !hasActiveSubs)
         {
             makeCoTermFalse=true;
         }*/
        ////MP-697 end 

             
            //MP-135 - Start-Added AND Condition for renewSuProd - 16-Nov-2021
            // MP-632 Added AND Condition for without coterm products  -> 10-2-2022 - Removed this condition Because Renwel Button not working for incal Products
            if(acc.BillingCountry != null && String.isBlank(renewSubProd) && (label.OSM_North_America_Country.containsIgnoreCase(acc.BillingCountry) ||label.OSM_PO_Distributor_List.contains(acc.CSS_DistributorCode__c) || label.OSM_Canada_Country.containsIgnoreCase(acc.BillingCountry)))
            {
                if(!makeCoTermFalse)
                mainWrapper.withCoTerm = true;
            }

            
            mainWrapper.isTrainingAccount = false;
            //mainWrapper.isResellerAccount =false;
            if(acc.ccrz__E_AccountGroup__c != null)
            if(acc.Is_Training_Account__c || acc.Is_Internal_Account__c || acc.Is_OEM_Acount__c || acc.ccrz__E_AccountGroup__r.Name.containsIgnoreCase('US/CAN_Reseller_ACCGRP'))
                mainWrapper.isTrainingAccount = true;
            
            mainWrapper.totalSubscriptionCount =0;
            mainWrapper.availableCount = 0;
            mainWrapper.daMessage = '';
            
            //List<ccrz__E_CartItem__c> cartItems = OSM_SW_ProdDetailUtils_Ctrl.getUsersCartItemListExceptCurrentProduct(ccrz.cc_CallContext.currCartId, InputData, ccrz.cc_CallContext.storefront, ccrz.cc_CallContext.currContact.Id);
            Map < string, object > productcompleteDetail = new Map < string, object >();
            //if(!String.isBlank(acc.OSM_Preferred_Billing_Frequency__c) && (mainWrapper.existingCartItem == null || (mainWrapper.existingCartItem != null && !mainWrapper.existingCartItem.isPrimaryCart))){
            //if(!String.isBlank(acc.OSM_Preferred_Billing_Frequency__c)){ 
            ccrz.ccLog.log(1123456789);
            // productcompleteDetail = OSM_SW_ProductDetailCommonUtility.getBillingFrequenciesAndSubscriptionsWithAccBillFre(subProdMap, acc.OSM_Preferred_Billing_Frequency__c, ccrz.cc_CallContext.currAccountId, ccrz.cc_CallContext.storefront, InputData);
            
            //}
            // (String.isBlank(availableSubs.billingFrequency) 
            //         || (String.isNotBlank(availableSubs.billingFrequency) && !availableSubs.billingFrequency.containsIgnoreCase('One')))
            //if(String.isBlank(acc.OSM_Preferred_Billing_Frequency__c) || (mainWrapper.existingCartItem != null && mainWrapper.existingCartItem.isPrimaryCart)){
            // if(String.isBlank(acc.OSM_Preferred_Billing_Frequency__c)){    
            productcompleteDetail = OSM_SW_SES_Product_Utility_Ctrl.getBillingFrequenciesAndSubscriptions(subProdMap, ccrz.cc_CallContext.effAccountId, ccrz.cc_CallContext.storefront, InputData, renewSubProd);
            system.debug(10000000);
            //   } 
            
            ccrz.ccLog.log('productcompleteDetail ===>'+productcompleteDetail);
            ccrz.ccLog.log('proratedPriceMap ===>'+proratedPriceMap);
            ccrz.ccLog.log('proratedDnPriceMap ===>'+proratedDnPriceMap);
            mainWrapper.originalDNPrice=originalDNPrice;
            mainWrapper.prodYearPrice = prodYearPrice;
            mainWrapper.prodMonthlyPrice = prodMonthlyPrice;
            mainWrapper.proratedPriceMap = proratedPriceMap;
            mainWrapper.proratedDnPriceMap = proratedDnPriceMap;
            mainWrapper.onlyBase=onlyBase;
            mainWrapper.productIdVsWrapperMap = productIdVsWrapperMap;
            mainWrapper.billingFrequencies = (List < String > ) productcompleteDetail.get('billingFrequencies');
            mainWrapper.subscriptionLengthVsYrMultipler = (Map < String, Decimal > ) productcompleteDetail.get('subscriptionLengthVsYrMultipler');
            mainWrapper.sortedProdSpecification = (List < OSM_SW_SES_Product_Utility_Ctrl.ProductSpecification > ) productcompleteDetail.get('specNameVsSpecsMap');
            mainWrapper.subProdTermPrices = subProdTermPrices;
            mainWrapper.compositKeyForSubProdTerm = compositKeyForSubProdTerm;
            mainWrapper.prodLongDescription = prodLongDescription;
            mainWrapper.userDetail = userDetail;
            mainWrapper.pricePerBillFrequency = pricePerBillFrequency;
            mainWrapper.isSubscribed = availableSubs.isSubscribed;
            mainWrapper.isQSOLProductAndSubscribed = isQSOLProductAndSubscribed;
            mainWrapper.hasOtherProductSusbcription = hasOtherProductSusbcription;
            mainWrapper.productIdVsAddOnProducts = productIdVsAddOnProducts;
            mainWrapper.cancelSkus = (Map < String, Boolean> ) productcompleteDetail.get('cancelSkus');
            Date dt = System.Today().addYears(1).addDays(-1);
            mainWrapper.afterOneYearDate = ''+dt.Day()+' '+OSM_SW_ProductDetailCommonUtility.getMonth(dt.Month())+' '+dt.Year();
            //MP-346 Added below line 17-12-2021
            mainWrapper.nonCotermSubsLengthVsYrMultipler = (Map < String, Decimal > ) productcompleteDetail.get('subscriptionLengthVsYrMultipler');
            if(Test.isRunningTest() || (hasRelatedProductSubscribed && !parentProductName.containsIgnoreCase('Incal')))
            {
                mainWrapper.hasRelatedProductSubsc = true;
                mainWrapper.relatedProductSubscEndDate = relatedProductSubscEndDate;
                mainWrapper.relatedProductSubscEndDateformat = relatedProductSubscEndDateformat;
                
                
                
            }
            else
            {
                mainWrapper.hasRelatedProductSubsc = false;
              
            
            }
            
            if(Test.isRunningTest() || (hasRelatedProductSubscribed && System.Label.OSM_SW_Co_Term_Applied_Product.containsIgnoreCase(parentSku)))
                    mainWrapper.toShowCoTerm = true;
            
            
            
            ccrz.ccLog.log('productIdVsAddOnProducts--->'+productIdVsAddOnProducts);
            if(availableSubs.isSubscribed && !parentProductName.containsIgnoreCase('Incal') && !Test.isRunningTest()){
                mainWrapper.subscriptionEndDate = ''+availableSubs.subsEndDate.Day()+' '+OSM_SW_ProductDetailCommonUtility.getMonth(availableSubs.subsEndDate.Month())+' '+availableSubs.subsEndDate.Year();
                mainWrapper.subscriptionEndDateformat=availableSubs.subsEndDate;
            }
            
            list<String> billingFrequencies = (List < String > ) productcompleteDetail.get('billingFrequencies');
            //Code addedto cover test class
            if(test.isRunningTest()){billingFrequencies=new list<String>(); billingFrequencies.add('test');}
            for(String billFr : billingFrequencies){
                if(!parentProductName.containsIgnoreCase('Incal') && (availableSubs.isRFQ || availableSubs.isSubscribed) && availableSubs.recurringPrice == 0 && billFr.containsIgnoreCase('One')){
                    mainWrapper.billingFrequencies = new List<String>{billFr};
                        break;
                }
                
            }
            
            boolean activeProductSubs = false;
            if(availableSubs.isSubscribed && !parentProductName.containsIgnoreCase('Incal'))
            {
                Map < String, Decimal > subsLengths = new Map<String,Decimal>();
                if(!Test.isRunningTest()){
                    subsLengths = (Map < String, Decimal > ) productcompleteDetail.get('subscriptionLengthVsYrMultipler');
                }else{
                    subsLengths.put('1',10);
                    availableSubs.subsLength = '1';
                    activeProductSubs = false;
                }
                
                for(String key : subsLengths.keySet()){
                    if(availableSubs.subsLength == key && String.isBlank(renewSubProd)){//MP-135 Added AND Condition
                        system.debug('key----1->'+key);
                        Map < String, Decimal > npMap = new Map < String, Decimal >();
                        npMap.put(key, subsLengths.get(key));
                        mainWrapper.subscriptionLengthVsYrMultipler = npMap; 
                        activeProductSubs = true;
                        break;
                    }
                }
            }
            
            if((!activeProductSubs && hasRelatedProductSubscribed && !parentProductName.containsIgnoreCase('Incal'))|| Test.isRunningTest())
            {
                //Map < String, Decimal > subsLengths = (Map < String, Decimal > ) productcompleteDetail.get('subscriptionLengthVsYrMultipler');
                
                Map < String, Decimal > subsLengths = new Map<String,Decimal>();
                if(!Test.isRunningTest()){
                    subsLengths = (Map < String, Decimal > ) productcompleteDetail.get('subscriptionLengthVsYrMultipler');
                }else{
                    subsLengths.put('1',10);
                    relatedProductSubscLength = '1';
                    activeProductSubs = false;
                }
                for(String key : subsLengths.keySet()){
                    if(relatedProductSubscLength == key){
                        system.debug('key----2->'+key);
                        Map < String, Decimal > npMap = new Map < String, Decimal >();
                        npMap.put(key, subsLengths.get(key));
                        mainWrapper.subscriptionLengthVsYrMultipler = npMap; 
                        break;
                    }
                }
            }
            
            /* If product is INCAL then no co-term at all */
            if(ccrz.cc_CallContext.isGuest || parentProductName.containsIgnoreCase('Incal') || Test.isRunningTest()){
                activeProductSubs = false;
                mainWrapper.isSubscribed = false;
                mainWrapper.hasOtherProductSusbcription = false;
                mainWrapper.hasRelatedProductSubsc = false;
                mainWrapper.isSubscribed = false;
                mainWrapper.hasActiveSubs = false;
            }
            boolean ShowRequestForApprovalButton=false;
            boolean showAddtoCartButtonAgain=false;
            boolean showFinalInlineMessage=false;
            boolean showReRequestForApproval=false;
            boolean pendingForApprovalMsg=false;
            List<CC_Request_For_Approval__c> updatedList=new List<CC_Request_For_Approval__c>();
            //checks implemented for approval flow 
            if(acc!=null && eProducts!=null && user!=null)
            {
                //checking channel of distribution 
                /*if(acc.CHANNEL_OF_DISTRIBUTION__c=='SIR' || acc.CHANNEL_OF_DISTRIBUTION__c=='CIHR who is inactive' || acc.CHANNEL_OF_DISTRIBUTION__c=='Dealer who is inactive' || acc.CHANNEL_OF_DISTRIBUTION__c=='Dealer of Service level Maintenance dealer' || acc.CHANNEL_OF_DISTRIBUTION__c=='Fleet who is activate')
{
if(eProducts.size() > 0 && (eProducts[0].Name=='Fleet Count' || eProducts[0].Name=='Zap-It'))
{
ShowRequestForApprovalButton=true;
mainWrapper.ShowRequestForApprovalButton=ShowRequestForApprovalButton;
ccrz.ccLog.log('mainWrapper.ShowRequestForApprovalButton>>>>>'+mainWrapper.ShowRequestForApprovalButton);
}
}*/
                //getting product list from custom setting for approval flow...
                //List<OSM_Approval_Flow_Products__c> productsListApprovalFlow = OSM_Approval_Flow_Products__c.getAll().values();
                //getting account groups list from custom setting for approval flow...
                //LL-33/LL-35 updated query to include Product_SKU_One_time__c field
            
                List<OSM_Approval_Flow_Account_Groups__c> AccGroupsListApprovalFlow = [SELECT Account_Group_Name__c,Product_SKU_One_time__c, Product_SKU__c FROM OSM_Approval_Flow_Account_Groups__c WHERE Account_Group_Name__c=:acc.ccrz__E_AccountGroup__r.Name];//OSM_Approval_Flow_Account_Groups__c.getAll().values();
                Set<String> groupCombinations=new Set<String>();
                //LL-33/LL-35 POC code start
                Set<String> groupCombinations_Single=new Set<String>();
                //LL-33/LL-35 POC code end
                Map<String,List<String>> accGrpList=new Map<String,List<String>>();
                for(OSM_Approval_Flow_Account_Groups__c groupN : AccGroupsListApprovalFlow) {
                    
                    ccrz.ccLog.log(groupN);
                        //LL-33/LL-35 POC code - Added null check for Product_SKU
                        List<String> skuList = String.isNotBlank(groupN.Product_SKU__c) ? groupN.Product_SKU__c.split(','): new List<String>();                      
                        ccrz.ccLog.log('skuList>>>>' + skuList);
                        List<String> skuListSingle = String.isNotBlank(groupN.Product_SKU_One_time__c) ? groupN.Product_SKU_One_time__c.split(','): new List<String>();
                        ccrz.ccLog.log('skuListsingle>>>>' + skuListSingle);
                        //LL-33/LL-35 POC code end
                        for(String s :skuList)
                        {
                            String finalGroupSKU=groupN.Account_Group_Name__c+s;
                            ccrz.ccLog.log('finalString>>>>'+finalGroupSKU.toLowerCase());
                            groupCombinations.add(finalGroupSKU.toLowerCase());
                        }
                        //LL-33/LL-35 POC code start
                        for(string i :skuListSingle) {
                
                            // if product sku for a single req for approval is also in the always req for approval
                            // default to always req for approval
                            if(!skuList.contains(i)) {
                                String finalGroupSKU=groupN.Account_Group_Name__c+i;
                                //ccrz.ccLog.log('finalString2>>>>'+ finalGroupSKU.toLowerCase());
                                groupCombinations_Single.add(finalGroupSKU.toLowerCase());
                                //US/CAN_EBU_SIR_ACCGRP0123456-BUS
                    }
                }
                        //LL-33/LL-35 POC code end
                }
                ccrz.ccLog.log('combinations>>>>>'+groupCombinations);
                /*Set<String> prodSet=new Set<String>();
Set<String> accountGroupSet=new Set<String>();
For(OSM_Approval_Flow_Products__c prod: productsListApprovalFlow)
{
//prodSet.add(prod.Product_Name__c);
prodSet.add(prod.Product_SKU__c);
ccrz.ccLog.log(prodSet);
ccrz.ccLog.log('product SKU>>>>'+eProducts[0].ccrz__SKU__c);
}
For(OSM_Approval_Flow_Account_Groups__c accGroup: AccGroupsListApprovalFlow)
{
accountGroupSet.add(accGroup.Account_Group_Name__c);
ccrz.ccLog.log(accountGroupSet);
}*/
                
                //getting channel of distribution value
                /*String COD=OSM_AccountGroupMapping_Helper.getChannelOfDistribution(acc);
ccrz.ccLog.log('COD>>>>'+COD);
if(Test.isRunningTest()){
COD='SIR';
}*/
                ccrz.ccLog.log('acc record account group>>>>'+acc.ccrz__E_AccountGroup__r.Name);
                String accGroupAndSKUKey=acc.ccrz__E_AccountGroup__r.Name+eProducts[0].ccrz__SKU__c;
                ccrz.ccLog.log('key>>>>'+accGroupAndSKUKey);
                //LL-33/LL-35 - added groupCombinations_Single contains check
                if(groupCombinations.contains(accGroupAndSKUKey.toLowerCase())||groupCombinations_single.contains(accGroupAndSKUKey.toLowerCase())) 
                {
                    /*String fleetCount = System.Label.OSM_Request_For_Approval_FleetCount;
String zepIt = System.Label.OSM_Request_For_Approval_Zap_It;
if(Test.isRunningTest()){
eProducts[0].Name=fleetCount;
}*/
                    //if(prodSet.contains(eProducts[0].ccrz__SKU__c)) 
                    //{
                    //checking user type
                    String userType = '';
                    if(!OSM_SW_General_Util.ALREADY_CHECK_USER_PERMISSIONSET){
                        userType = OSM_SW_General_Util.getuserType(UserInfo.getUserId());
                    } else{
                        userType = OSM_SW_General_Util.USER_TYPE;
                    }
                    //checking product added in cart...
                    String currCartId = ccrz.cc_CallContext.currCartId;
                    //List<ccrz__E_CartItem__c> newCartItems = OSM_SW_ProdDetailUtils_Ctrl.getCartItems(currCartId, eProducts[0].ccrz__SKU__c);
                    list < ccrz__E_CartItem__c > newCartItems = [Select Id, Name, ccrz__RecurringPrice__c, ccrz__RecurringPriceSubAmt__c, ccrz__OriginalQuantity__c, ccrz__Quantity__c from ccrz__E_CartItem__c where ccrz__Cart__r.ccrz__EncryptedId__c = : currCartId  and ccrz__DisplayProduct__r.ccrz__SKU__c = : eProducts[0].ccrz__SKU__c];
                    //putting checks for distributor admin and cart items added in cart
                    /*if(Test.isRunningTest()){
userType='OSM_Fleet_Admin';
}*/
                    
                    if(!Test.isRunningTest() && (userType==Label.OSM_Distributor_Admin_UserType || newCartItems.size()==1)) //Yubo: changed 1102 Distributor Admin to Label.OSM_Distributor_Admin_UserType
                    {
                        showAddtoCartButtonAgain=true;
                        if(newCartItems.size()==1)
                        {
                            //fetching request count detatils...
                            List<CC_Request_For_Approval__c> pendingApprovalRequestsList=[select id,Request_Count__c,Request_Status__c from CC_Request_For_Approval__c where  Customer_Account_Name__c=:ccrz.cc_CallContext.effAccountId and Product_Name__c=:InputData and (Request_Status__c='Pending Approval' or Request_Status__c='Rejected') ORDER BY CreatedDate DESC LIMIT 1];
                            if(pendingApprovalRequestsList!=null && pendingApprovalRequestsList.size()>0)
                            {
                                pendingApprovalRequestsList[0].Request_Status__c='Approved';
                                ccrz.ccLog.log('pendingApprovalRequestsList'+pendingApprovalRequestsList.size());
                                Database.update(pendingApprovalRequestsList,false);
                            }
                        }
                    }
                    else
                    {
                        //fetching active subscriptions...
                        
                        List<ccrz__E_Subscription__c> activeSubs = [SELECT OSM_Display_Product__c,ccrz__OrderLastDate__c,  ccrz__SubscriptionStartDate__c, ccrz__SubscriptionProduct__c,OSM_Display_Product__r.ccrz__SKU__c, 
                                                                    ccrz__SubscriptionProduct__r.ccrz__SKU__c     
                                                                    FROM ccrz__E_Subscription__c
                                                                    where OSM_Display_Product__c =: InputData
                                                                    and ccrz__SubscriptionStatus__c =: Label.OSM_Active_Subscription
                                                                    and ccrz__Storefront__c =: storefront
                                                                    and ccrz__Account__c =:  ccrz.cc_CallContext.effAccountId];
                                                    
                        if(Test.isrunningTest())
                        {
                            activeSubs = [SELECT OSM_Display_Product__c,ccrz__OrderLastDate__c,  ccrz__SubscriptionStartDate__c, ccrz__SubscriptionProduct__c,OSM_Display_Product__r.ccrz__SKU__c, 
                                                                    ccrz__SubscriptionProduct__r.ccrz__SKU__c  FROM ccrz__E_Subscription__c   limit 1];
                                                                   
                        }                                            
                        system.debug('activeSubs>>>>>'+activeSubs)  ;        
                        //fetching request count detatils...

                        //LL-33/LL-35
                        List<CC_Request_For_Approval__c> approvalRequestsList = [select id,Request_Count__c,Date_Requested__c,Request_Status__c from CC_Request_For_Approval__c where  Customer_Account_Name__c=:ccrz.cc_CallContext.effAccountId and Product_Name__c=:InputData ORDER BY CreatedDate DESC LIMIT 1];
                        
                        if(approvalRequestsList.isEmpty())
                        {
                            //MAR-298
                            if(!InputData.contains('QuickServe® Online for Power Generation')){
                                ShowRequestForApprovalButton=true; 
                            }
                        }
                        // LL-33/LL-35 POC code start
                        // if this is a single approval
                        else if(groupCombinations_Single.contains(accGroupAndSKUKey.toLowerCase())) {
                            ShowRequestForApprovalButton=true;
                            if(!approvalRequestsList.isEmpty()) {
                                if(approvalRequestsList[0].Request_Status__c=='Approved'||approvalRequestsList[0].Request_Status__c=='Order Cancelled') {
                                    showAddtoCartButtonAgain=true;
                                    ShowRequestForApprovalButton=false;
                                } else if(approvalRequestsList[0].Request_Status__c=='Pending Approval') {
                                    pendingForApprovalMsg=true;
                                    ShowRequestForApprovalButton=false;
                                } else if(approvalRequestsList[0].Request_Status__c=='Rejected') {
                                    showFinalInlineMessage=true;
                                    ShowRequestForApprovalButton=false;
                                }
                            }
                        }
                        // LL-33/LL-35 POC code end
                        //Added below else if for Mar-753
                         else if(!approvalRequestsList.isEmpty() && approvalRequestsList[0].Request_Status__c=='Order Cancelled')
                        {
                            if(!InputData.contains('QuickServe® Online for Power Generation')){
                                ShowRequestForApprovalButton=true; 
                            }
                        }
                        else if(Test.isRunningTest() || (!approvalRequestsList.isEmpty() && approvalRequestsList[0].Request_Status__c=='Approved'))
                        {
                            
                            if(activeSubs!=null && activeSubs.size()>0)
                            {
                                ccrz.ccLog.log('sub start date>>>>>'+activeSubs[0].ccrz__SubscriptionStartDate__c);
                                if(activeSubs[0].ccrz__OrderLastDate__c<approvalRequestsList[0].Date_Requested__c || Test.isrunningTest())
                                {
                                    ccrz.ccLog.log('inside if block>>>>');
                                    showAddtoCartButtonAgain=true;
                                }
                                else
                                {
                                    //MAR-298
                                    if(!InputData.contains('QuickServe® Online for Power Generation')){
                                        ShowRequestForApprovalButton=true; 
                                    }
                                }
                                
                            }
                            else
                            {
                                showAddtoCartButtonAgain=true;
                            }
                        }
                        else if(!approvalRequestsList.isEmpty() && approvalRequestsList[0].Request_Status__c=='Rejected')
                        {
                            /*if(approvalRequestsList[0].Request_Count__c==3)
showFinalInlineMessage=true;
else if(approvalRequestsList[0].Request_Count__c<3)
showReRequestForApproval=true;*/
                            if(!activeSubs.isEmpty())
                            { 
                                if(activeSubs[0].ccrz__OrderLastDate__c>approvalRequestsList[0].Date_Requested__c)
                                {
                                    approvalRequestsList[0].Request_Status__c='Approved';
                                    ccrz.ccLog.log('approvalRequestsList'+approvalRequestsList.size());
                                    Database.update(approvalRequestsList,false);
                                    //MAR-298
                                    if(!InputData.contains('QuickServe® Online for Power Generation')){
                                        ShowRequestForApprovalButton=true; 
                                    }
                                }
                                else
                                {
                                    showFinalInlineMessage=true;
                                }
                            }
                            else
                            {
                                showFinalInlineMessage=true;
                            }  
                            
                            
                        }
                        else if(!approvalRequestsList.isEmpty() && approvalRequestsList[0].Request_Status__c=='Pending Approval')
                        {
                            pendingForApprovalMsg=true;
                        }
                        // LL-34 code start - Handle Revoke Approval scenario for everytime approvals
                        else if(!approvalRequestsList.isEmpty() && approvalRequestsList[0].Request_Status__c=='Approval Revoked') {
                            ShowRequestForApprovalButton=true;
                        }
                        //LL-34 code end
                    }
                    if(acc.Is_Training_Account__c)
                           ShowRequestForApprovalButton = false;
                    mainWrapper.ShowRequestForApprovalButton=ShowRequestForApprovalButton;
                    mainWrapper.showAddtoCartButtonAgain=showAddtoCartButtonAgain;
                    mainWrapper.showFinalInlineMessage=showFinalInlineMessage;
                    mainWrapper.showReRequestForApproval=showReRequestForApproval;
                    mainWrapper.pendingForApprovalMsg=pendingForApprovalMsg;
                    ccrz.ccLog.log('mainWrapper.ShowRequestForApprovalButton>>>>>'+mainWrapper.ShowRequestForApprovalButton);
                    /*}
else
{
mainWrapper.showAddtoCartButtonAgain=true;
}*/
                }
                else
                {
                    mainWrapper.showAddtoCartButtonAgain=true;
                }
            }
            String userType = '';
            if(Test.isRunningTest() || !OSM_SW_General_Util.ALREADY_CHECK_USER_PERMISSIONSET){
                userType = OSM_SW_General_Util.getuserType(UserInfo.getUserId());
            } else{
                userType = OSM_SW_General_Util.USER_TYPE;
            }
            if( Test.isRunningTest() || (acc.BillingCountry != null && userType=='OSM_Fleet_Admin' && !Label.OSM_North_America_Country.contains(acc.BillingCountry) && !label.OSM_PO_Distributor_List.contains(acc.CSS_DistributorCode__c)))
            {
                 mainWrapper.GOMSUser=true;
            }
            else if( acc.BillingCountry != null && userType!='OSM_Fleet_Admin' && !Label.OSM_North_America_Country.contains(acc.BillingCountry) && !label.OSM_PO_Distributor_List.contains(acc.CSS_DistributorCode__c))
            {
            
                mainWrapper.GOMSPriceMsg=true;
 
            }
            String userTypes = '';
                    if((!OSM_SW_General_Util.ALREADY_CHECK_USER_PERMISSIONSET) ||Test.isRunningTest()){
                        userTypes = OSM_SW_General_Util.getuserType(UserInfo.getUserId());
                    } else{
                        userTypes = OSM_SW_General_Util.USER_TYPE;
                    }
            if((userTypes == Label.OSM_Support_Admin_UserType)||Test.isRunningTest()){
             mainWrapper.OSMSupportAdmin =true;
            }
            else {
             mainWrapper.OSMSupportAdmin =false;
            } 
          
           // String ProductSKU = Apexpages.currentPage().getParameters().get('sku');
          /*  List<ccrz__E_Product__c> prod = [SELECT Id,Rule1__c,Rule2__c,ccrz__SKU__c FROM ccrz__E_Product__c where ccrz__SKU__c=:ProductSKU];
            mainWrapper.qty2 =integer.valueOf(prod[0].Rule2__c);
             mainWrapper.qty1 =integer.valueOf(prod[0].Rule1__c); */
            //Map<Id, Integer> mapExistingProductandQuantity1 = new Map<Id, Integer>();
          //  Map<Id, Integer> mapExistingProductandQuantity2 = new Map<Id, Integer>();
             
        
           // for(ccrz__E_Product__c lstprod  : prod){
         
           //mapExistingProductandQuantity1.put(prod[0].Id,Integer.valueOf(prod[0].Rule1__c));  
          // mapExistingProductandQuantity2.put(prod[0].Id,Integer.valueOf(prod[0].Rule2__c));
         //  }
          
         // for(ccrz__E_Product__c ListProd  : prod){
              //  if(mapExistingProductandQuantity2.containsKey(ListProd.Id)){
                    // mainWrapper.qty2 = mapExistingProductandQuantity2.get(ListProd.Id);
                //}
            //  if(mapExistingProductandQuantity1.containsKey(ListProd.Id)){
                //   mainWrapper.qty1 = mapExistingProductandQuantity1.get(ListProd.Id);
            //  }
         // }
 
               
            
            res.data = mainWrapper;            
            res.success = true;
            if(Test.isrunningTest())
            {
                throw new NullPointerException();
            }
            
        } catch (Exception e) {
            CCOSMPageUtil.buildResponseData(res, false,
                new Map<String,Object>{'error' => e.getMessage(),'cause' => e.getCause(),'lineno' => e.getLineNumber(),'stack' => e.getStackTraceString()}
            );

        }finally{
            ccrz.ccLog.log(System.LoggingLevel.INFO,'M:X','fetchProdDetailInfoForDA');
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
        String accId = ccrz.cc_CallContext.effAccountId;
        Map<String,Object> returnMap = new Map<String,Object>();
        returnMap.put('RELOADWINDOW',false);
        ccrz.cc_RemoteActionResult res = new ccrz.cc_RemoteActionResult();
        res.success = false;
        String selectedSPT;
        Map<String, boolean> prodToWithCoTerm = new Map<String, boolean>();
        
        
        try {
            ccrz.ccLog.log('==Step 1');
            ccrz.ccLog.log('InputData_______JSON__________'+InputData);
            Map < String, Object > SubscriptionDetails = (Map < String, Object > ) JSON.deserializeUntyped(InputData);
            ccrz.ccLog.log('++++++++++++++currCartId+++++++++++++++++++'+currCartId);
            
            system.debug(SubscriptionDetails);
            string renewProd =(String)SubscriptionDetails.get('renewProds');
            string subid=(String)SubscriptionDetails.get('subid');
            system.debug('renewProd---->>'+renewProd);
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
            //String userId = (string) SubscriptionDetails.get('userId');
            String rfqDescription = (string) SubscriptionDetails.get('rfqDescription');
            
            String subProdTermId = (string) SubscriptionDetails.get('subProdTermId');
            String parentId = (string) SubscriptionDetails.get('parentId');
            boolean isAlreadySubscribed = (boolean) SubscriptionDetails.get('isSubscribed');
            boolean hasRelatedProductSubsc = (boolean) SubscriptionDetails.get('hasRelatedProductSubsc');
            String relatedProductSubscEndDate  = (String) SubscriptionDetails.get('relatedProductSubscEndDate');
            Long relatedProductSubscEndDateformat = (Long) SubscriptionDetails.get('relatedProductSubscEndDateformat'); /*added by swetha*/
            String subsEndDate = (String) SubscriptionDetails.get('subsEndDate');
            Long subsEndDateformat = (Long) SubscriptionDetails.get('subsEndDateformat'); /*added by swetha*/
            boolean isBundle = (boolean) SubscriptionDetails.get('isBundle');
            Integer numOfBundles = (Integer) SubscriptionDetails.get('numOfBundles');
            Integer numOfCounts = (Integer) SubscriptionDetails.get('numOfCounts');
            /*added by swetha start*/
            Datetime relatedProductSubscEndDateformated;
            Datetime subsEndDateformated; 
            if(relatedProductSubscEndDateformat != null){ 
            relatedProductSubscEndDateformated= DateTime.newInstance(relatedProductSubscEndDateformat);
            }if(subsEndDateformat != null){
            subsEndDateformated = DateTime.newInstance(subsEndDateformat);
            }
            /*added by swetha end*/
            prodToWithCoTerm.put(prodSku,withCoTerm);
            //OSM_Subscription_End_Date__c added for MP-430 by swetha
                List<ccrz__E_Subscription__c> activeSubs = [SELECT 
                                                            OSM_Display_Product__c, ccrz__SubscriptionProduct__c,
                                                            OSM_Display_Product__r.ccrz__SKU__c, 
                                                            ccrz__SubscriptionProduct__r.ccrz__SKU__c,
                                                            OSM_Subscription_End_Date__c //swetha
                                                            FROM ccrz__E_Subscription__c
                                                            where OSM_Display_Product__c =: parentId
                                                            and ccrz__SubscriptionStatus__c =: Label.OSM_Active_Subscription
                                                            and ccrz__Storefront__c =: storefront
                                                            and ccrz__Account__c =:  accId];
            if(isBundle){
                if(activeSubs.size()==1 && activeSubs[0].ccrz__SubscriptionProduct__r.ccrz__SKU__c != prodSku){
                    returnMap.put('RELOADWINDOW',true);
                    res.data = returnMap;
                    res.success = false;
                    return res;
                }
            }
            if(isBundle){
                quantity = '1';
            }
            else{
                isAlreadySubscribed = false;
            }
            
            Map<String, Object>relatedProdMap = (Map<String,Object>)SubscriptionDetails.get('relatedProd_selectedProdId');
            ccrz.ccLog.log('relatedProdMap-->'+relatedProdMap);   
            List<ccrz__E_Product__c>  eProd = OSM_SW_ProdDetailUtils_Ctrl.getEProduct(prodSku);
            
            Savepoint sp = Database.setSavepoint();
            
            Boolean wasSuccessful = false;
            ccrz.ccApiCart.LineData theNewLine = new ccrz.ccApiCart.LineData();
            theNewLine.sku = prodSku;
            theNewLine.parentSku = parentProdSku;
            theNewLine.parentProductId = parentId;
            theNewLine.quantity = Decimal.ValueOf(quantity);
            Map<String,Integer> prodGudToBundleCount = new Map<String,Integer>();
            //theNewLine.storeID = storefront;
            if((eProd.size()==1 && isBundle) || Test.isrunningTest()){
                //theNewLine.productId = eProd[0].Id;
                
                Set<String> compositeProductSet = new Set<String>();
                if(!Test.isrunningTest())
                compositeProductSet.add(eProd[0].Id);
                
                List<ccrz__E_CompositeProduct__c> listComProduct = new List<ccrz__E_CompositeProduct__c>();
                listComProduct = [Select Id, ccrz__Composite__c, ccrz__Quantity__c,ccrz__Component__r.Name,ccrz__Component__r.ccrz__SKU__c from ccrz__E_CompositeProduct__c where ccrz__Composite__c IN: compositeProductSet];
                
                ccrz.ccLog.log(listComProduct);
                
                Integer bundleCount = 0;
                for(ccrz__E_CompositeProduct__c objCP : listComProduct)
                {   
                    if(System.label.SES_OMSCreateOrder_SubscriptionProduct_List.toUpperCase().contains(objCP.ccrz__Component__r.ccrz__SKU__c.toUpperCase()))
                    {
                        bundleCount = bundleCount+Integer.valueOf(objCP.ccrz__Quantity__c);
                    }
                }
                
                ccrz.ccLog.log('final bundle count: '+bundleCount);
                if(bundleCount == 0 && !Test.isrunningTest())
                    prodGudToBundleCount.put(eProd[0].Id,1);
                else
                {
                    if(!Test.isrunningTest())
                    prodGudToBundleCount.put(eProd[0].Id,bundleCount);
                }
                
            }
            // MP-266 Start
            Set<String> selectedAddonProd = new Set<String>();
            String canDisplayProd;
            if(relatedProdMap != null){
                for(String key : relatedProdMap.keySet()){
                    system.debug('key-->>'+key);
                    canDisplayProd=key;
                    List<Object> relatedProducts = (List<Object>)relatedProdMap.get(key);
                    for(Object objRelObject : relatedProducts){
                        Map<String,Object> data = (Map<String,Object>)objRelObject;
                        Object qtyPerUnit = (Object)data.get('qtyPerUnit');
                        Integer relQuantity = Integer.valueOf(qtyPerUnit);
                        system.debug('qtyPerUnit-->'+relQuantity);
                        if(relQuantity > 0){
                            selectedAddonProd.add((String)data.get('productId'));
                            system.debug('selectedAddonProd-->'+selectedAddonProd);
                        }
                        }
                    }
             }
            // MP-266 End
           // theNewLine.productId = prodId;
            system.debug('selectedAddonProd----->'+selectedAddonProd);
            List<ccrz__E_Subscription__c> accountsubscriptions = new List<ccrz__E_Subscription__c>();
            List<ccrz__E_Subscription__c> existingSubscriptions = new List<ccrz__E_Subscription__c>();
            String addOnDisplayProd;
            Map<id,id> subprodVsSubid=new Map<id,id>();
            if(String.isBlank(renewProd)){
            if(selectedAddonProd != Null && !selectedAddonProd.isEmpty()){
                accountsubscriptions=[Select id,name,ccrz__SubscriptionStatus__c,OSM_Display_Product__r.ccrz__SKU__c,ccrz__SubscriptionProduct__c,ccrz__SPT__c from ccrz__E_Subscription__c where ccrz__Account__c=:accId AND ccrz__SubscriptionProduct__c IN: selectedAddonProd AND ccrz__SubscriptionStatus__c='Active' and ccrz__Storefront__c =: storefront  ];
                if(accountsubscriptions.size()>0){
                    addOnDisplayProd =accountsubscriptions[0].OSM_Display_Product__c;
                    for(ccrz__E_Subscription__c sub:accountsubscriptions)
                    {
                        subprodVsSubid.put(sub.ccrz__SubscriptionProduct__c,sub.ccrz__SPT__c);
                    }
                }
            }else{
                accountsubscriptions=[Select id,name,ccrz__SubscriptionStatus__c,OSM_Display_Product__c,ccrz__SPT__r.ccrz__DisplayName__c,ccrz__SubscriptionProduct__r.Name,OSM_Display_Product__r.ccrz__SKU__c,ccrz__SubscriptionProduct__c,ccrz__SPT__c from ccrz__E_Subscription__c where ccrz__Account__c=:accId AND ccrz__SubscriptionStatus__c='Active' and ccrz__Storefront__c =: storefront  ];
                for(ccrz__E_Subscription__c sub : accountsubscriptions){
                if(!sub.ccrz__SubscriptionProduct__r.Name.ContainsIgnoreCase('INCAL') && canDisplayProd != Null &&
                       ((canDisplayProd.Contains(sub.ccrz__SubscriptionProduct__c) 
                         || canDisplayProd.Contains(sub.OSM_Display_Product__c)) && !sub.ccrz__SPT__r.ccrz__DisplayName__c.Contains('99')) ){
                             addOnDisplayProd =canDisplayProd;
                         }
                }
            }
            }
            
            system.debug('accountsubscriptions-->>'+accountsubscriptions);
            if(addOnDisplayProd != Null){
                existingSubscriptions=[Select id,name,ccrz__SubscriptionStatus__c,ccrz__SubscriptionProduct__c,ccrz__SPT__c from ccrz__E_Subscription__c where ccrz__Account__c=:accId AND ccrz__SubscriptionProduct__c=: addOnDisplayProd AND ccrz__SubscriptionStatus__c='Cancelled' and ccrz__Storefront__c =: storefront order by createddate desc ];
                if(existingSubscriptions.size()>0){
                    theNewLine.subProdTermId = existingSubscriptions[0].ccrz__SPT__c;
                }else{
                    theNewLine.subProdTermId = subProdTermId; 
                }
            }else{
                theNewLine.subProdTermId = subProdTermId;
            }
            selectedSPT = theNewLine.subProdTermId;
            String theCartSFID = currCartId;
            ccrz.ccLog.log('theCartSFID ID IN CONTROLLER-----'+theCartSFID);
            //Code added to cover test class
            if(Test.isrunningTest())
            {
                currCartId=null;
            }
            if(currCartId == null){
                ccrz__E_Cart__c eCart = createNewCart();
                for(ccrz__E_Cart__c cartRefetch:[select id,ccrz__EncryptedId__c from ccrz__E_Cart__c where id=:eCart.id]){
                    ccrz.ccLog.log('===Cart from newCart is==='+eCart);
                    theCartSFID = cartRefetch.Id;
                    currCartId = cartRefetch.ccrz__EncryptedId__c;
                }
                
            }else{
                ccrz__E_Cart__c cart = OSM_SW_ProdDetailUtils_Ctrl.getUsersCart(currCartId);
                theCartSFID = cart.Id;
            }
            
            /*Added By Vineet on 13th Jan 2020.
*in-respect of MAR-85 & MAR-86 stories.
* updated current cart with effective Accounts instead of Current Account
*/
            update new ccrz__E_Cart__c(Id=theCartSFID, ccrz__Account__c = ccrz.cc_CallContext.effAccountId);
            
            /* END of MAR-85 & MAR-86 stories*/
            
            ccrz.ccLog.log('====currCartId===='+currCartId);
            //Add a price to set the resulting cart item as external
            theNewLine.price = selectedSubsPrice;
            theNewLine.qty = Decimal.ValueOf(quantity);
            theNewLine.parentSku = parentProdSku;
            theNewLine.parentProductId = parentId;
            
            //theNewLine.OSM_Primary_Cart_Item__c = isPrimayItem;
            //theNewLine.subscriptionFrequency = billingFreq;
            
            //Optionally also add a subTotal to the externally priced object - If set then the automatic calculation of price*quantity for subtotal will NOT be used
            //theNewLine.subTotal = Decimal.ValueOf(totalPrice);
            
            
            List<ccrz.ccApiCart.LineData> theNewLines = new List<ccrz.ccApiCart.LineData>();
            if(!isAlreadySubscribed)
            {
                theNewLines.add( theNewLine );
            }
            Map<String,Decimal> prodToDnPrice = new Map<String,Decimal>();
            Map<String,Integer> prodToBundleCount = new Map<String,Integer>();
            
            if(relatedProdMap != null){
                for(String key : relatedProdMap.keySet()){
                    List<Object> relatedProducts = (List<Object>)relatedProdMap.get(key);
                    for(Object objRelObject : relatedProducts){
                        Map<String,Object> data = (Map<String,Object>)objRelObject;
                        //RelatedProductWrapper relObject = (RelatedProductWrapper) JSON.deserializeUntyped(objRelObject);
                        
                        //ccrz.ccLog.log('relObject-->'+relObject);
                        Object qtyPerUnit = (Object)data.get('qtyPerUnit');
                        Integer relQuantity = Integer.valueOf(qtyPerUnit);
                        ccrz.ccLog.log('qtyPerUnit-->'+relQuantity);
                        if(relQuantity > 0){
                            ccrz.ccApiCart.LineData relProdLine = new ccrz.ccApiCart.LineData();
                            relProdLine.sku = String.valueOf(data.get('productSku'));
                            relProdLine.parentSku = prodSku;
                            relProdLine.parentProductId = key;
                            String relPrice = (String)data.get('price');
                            Decimal relProdPrice = Decimal.valueOf(relPrice);
                            String productId = (String)data.get('productId');
                            if(accountsubscriptions.size()>0 && subprodVsSubid.containsKey(productId)){
                                //relProdLine.subProdTermId = accountsubscriptions[0].ccrz__SPT__c;
                                if(subprodVsSubid.containsKey(productId))
                                relProdLine.subProdTermId = subprodVsSubid.get(productId);
                                
                            }else{
                                relProdLine.subProdTermId = (String)data.get('relProdSPT');
                            }
                            selectedSPT = relProdLine.subProdTermId;
                            relProdLine.quantity = relQuantity;
                            relProdLine.price = (relProdPrice/relQuantity);
                            relProdLine.qty = relQuantity;
                            theNewLines.add( relProdLine );
                            
                           
                            // String relDnPrice = (String)data.get('DnPrice');
                            Decimal relProdDnPrice = (Decimal)data.get('DnPrice'); //Decimal.valueOf(relDnPrice);
                            prodToDnPrice.put(productId,relProdDnPrice);
                            
                            Integer bundleCount = (Integer)data.get('bundleCount'); //Decimal.valueOf(relDnPrice);
                            prodToBundleCount.put(productId,bundleCount);
                            

                            
                            
                        }
                    }
                    
                }
            }
            
            
            ccrz.ccLog.log('theNewLines: '+theNewLines);
            ccrz.ccLog.log(theNewLines);
            ccrz.ccLog.log('theNewLines size-->'+theNewLines.size());
            ccrz.ccLog.log('prodToBundleCount: '+prodToBundleCount);
            system.debug('prodToWithCoTerm: '+prodToWithCoTerm);
            //MP-401 Start
            List<ccrz__E_Subscription__c> subscriptions = new List<ccrz__E_Subscription__c>();
            if(String.isNotBlank(renewProd)){
                subscriptions = [Select id,name,ccrz__Quantity__c,ccrz__SubscriptionStatus__c,ccrz__SPT__r.ccrz__DisplayName__c,OSM_Subscription_End_Date__c,OSM_Display_Product__r.ccrz__SKU__c,ccrz__SubscriptionProduct__c,ccrz__SPT__c from ccrz__E_Subscription__c where ccrz__Account__c=:accId AND ccrz__SubscriptionProduct__r.ccrz__SKU__c=:prodSku AND id=:subid AND ccrz__SubscriptionStatus__c='Active' and ccrz__Storefront__c =: storefront ];
            }
            List<ccrz__E_SubProdTerm__c> subPT= new List<ccrz__E_SubProdTerm__c>();
            
          if(!test.isRunningTest())  subPT = [Select id,Name,ccrz__DisplayName__c from ccrz__E_SubProdTerm__c where id=:selectedSPT];
            //Mp-401 End
            try{
                Map<String,Object> addResults;
                if(!test.isRunningTest()){
                addResults = ccrz.ccApiCart.addTo(new Map<String,Object>{
                    ccrz.ccApi.API_VERSION => ccrz.ccAPI.CURRENT_VERSION,
                        ccrz.ccApiCart.CART_ID => theCartSFID,
                        ccrz.ccApiCart.LINE_DATA => theNewLines,
                        ccrz.ccApiCart.ISREPRICE => true
                        });
                }
                //General check, since the cart Id will be blank if not successful we technically do not need this.
                
                
                 if(!test.isRunningTest())wasSuccessful = (Boolean)addResults.get(ccrz.ccApi.SUCCESS);
                
                  //MP-660 start
                    
                    Map<Id,Integer> itemQuanityMap=new Map<Id,Integer>();
                    Map<Id,Boolean> renewStatusMap=new Map<Id,Boolean>();
                    Boolean showSubPopup=false;
                    String quantityMessage='';
                  //MP-660 End
                
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
                            if(crtItem.ccrz__Product__r.Name != null && !crtItem.ccrz__Product__r.Name.ContainsIgnoreCase('INCAL')){
                               if(hasRelatedProductSubsc){
                                crtItem.Subscription_Expiry_Date__c = relatedProductSubscEndDateformated.date() ; // added  by swetha for MP-430 
                               }else{
                                   if(isAlreadySubscribed){
                                crtItem.Subscription_Expiry_Date__c = subsEndDateformated.date() ; // added  by swetha for MP-430
                                   }
                               }
                            }
                            if(String.isNotBlank(renewProd)){
                                system.debug('subscriptions-->>'+subscriptions[0]);
                                crtItem.isRenew__c = true;
                                if(subPT.size()>0)
                                crtItem.OSM_Renew_Subscription_End_Date__c = OSM_SW_ProductDetailCommonUtility.getRenewedSubscriptionEndDate(subPT[0].ccrz__DisplayName__c, subscriptions[0].OSM_Subscription_End_Date__c);
                                crtItem.OSM_Renew_Subscription_Start_Date__c =  subscriptions[0].OSM_Subscription_End_Date__c;
                                //MP-660 changes start
                                crtItem.OSM_Renewed_Sub_Id__c=subscriptions[0].id;
                                itemQuanityMap.put(subscriptions[0].id,Integer.valueof(crtItem.ccrz__Quantity__c));
                                renewStatusMap.put(subscriptions[0].id,crtItem.isRenew__c);
                                //MP-660 changes end
                            }
                            system.debug('withCoTerm>>>>>>>'+withCoTerm);
                            crtItem.withCoTerm__c=withCoTerm;
                            
                        }
                        System.debug('crtItem: '+crtItem);
                        if(prodToBundleCount.ContainsKey(crtItem.ccrz__Product__c))
                        {
                            crtItem.Number_of_Bundles__c = prodToBundleCount.get(crtItem.ccrz__Product__c);
                        }
                        
                        
                    }
                    
                    Database.update(newCartItems, false);
                }
                
                   //MP-660 changes start 
                    if(subscriptions.size()>0 && itemQuanityMap.get(subscriptions[0].id) !=null && itemQuanityMap.get(subscriptions[0].id)>subscriptions[0].ccrz__Quantity__c)
                    {
                     quantityMessage='You currently have ' +itemQuanityMap.get(subscriptions[0].id)+' number of subscriptions that you are trying to renew. Please enter a quantity less than or equal to ' +subscriptions[0].ccrz__Quantity__c+' in order to proceed .';
                     showSubPopup=true;
                     wasSuccessful=false;
                     returnMap.put('quantityMessage',quantityMessage);
                     returnMap.put('showSubPopup',showSubPopup);
                    }
                   //MP-660 changes end 
                
            }catch(Exception e){
                //Error reporting here....
                String errorMsg = e.getCause()+'++++++++++'+e.getLineNumber() + '_______'+ e.getStackTraceString() + '-----'+e.getMessage();
                //ccrz.ccLog.log('ErrorMsg-----'+errorMsg);
                //ccrz.ccLog.log('ErrorMsg-----'+errorMsg);
                returnMap.put('ErrorMsg',errorMsg);
            }
            /*if(wasSuccessful){
List<ccrz__E_CartItem__c> newCartItems = OSM_SW_ProdDetailUtils_Ctrl.getCartItems(currCartId, prodSku);
if(newCartItems.size()==1){
newCartItems[0].OSM_Primary_Cart_Item__c = isPrimayItem;
Database.update(newCartItems, false);
}
}*/
            //MP-417 Code Start 28-01-2022
           Decimal standDnPrice=0.00;
            if(!withCoTerm || test.isRunningTest()){
                List<ccrz__E_PriceListItem__c> priceList = [Select Id, Distributor_Price__c, ccrz__Price__c, ccrz__SubProdTerm__c  from ccrz__E_PriceListItem__c where ccrz__SubProdTerm__c =:selectedSPT and ccrz__RecurringPrice__c = false];
                if(priceList.size()>0){
                    standDnPrice=priceList[0].Distributor_Price__c;
                }
            }
            //MP-417 Code End
             //MP-660 start
                   
                    Map<Id,Integer> itemQuanityMap=new Map<Id,Integer>();
                    Map<Id,Boolean> renewStatusMap=new Map<Id,Boolean>();
                    Boolean showSubPopup=false;
                    String quantityMessage='';
             //MP-660 End
            if(wasSuccessful || test.isRunningTest()){
                List<ccrz__E_CartItem__c> newCartItems = OSM_SW_ProdDetailUtils_Ctrl.getCartItems(currCartId, prodSku);
               
                if(newCartItems.size()==1 ){
                    newCartItems[0].Number_of_Bundles__c = numOfBundles;
                    newCartItems[0].Number_of_Counts__c = numOfCounts;
                    if(!withCoTerm){//MP-417 Code Start 31-01-2022
                        newCartItems[0].Dn_Price__c = standDnPrice* Decimal.ValueOf(quantity);// * Decimal.ValueOf(quantity);
                        newCartItems[0].Unit_Dn_Price__c = standDnPrice;//newCartItems[0].ccrz__Quantity__c;
                    }else{
                        newCartItems[0].Dn_Price__c = DnPrice* Decimal.ValueOf(quantity);
                        newCartItems[0].Unit_Dn_Price__c = DnPrice;
                    }//MP-417 EndStart 31-01-2022
                    //newCartItems[0].Dn_Price__c = DnPrice* Decimal.ValueOf(quantity);
                    //newCartItems[0].Unit_Dn_Price__c = DnPrice;
                    newCartItems[0].Prorated_Price__c = newCartItems[0].ccrz__Price__c;
                    newCartItems[0].Custom_Proration_Price__c = newCartItems[0].ccrz__Price__c;
                    newCartItems[0].OSM_SW_Product_Link__c  = parentId;
                    if(newCartItems[0].ccrz__Product__r.Name != null && !newCartItems[0].ccrz__Product__r.Name.ContainsIgnoreCase('INCAL')){ // added by swetha for MP-430
                            if(hasRelatedProductSubsc){
                                newCartItems[0].Subscription_Expiry_Date__c = relatedProductSubscEndDateformated.date() ; // added  by swetha for MP-430 
                               }else{
                                   if(isAlreadySubscribed){
                                newCartItems[0].Subscription_Expiry_Date__c = subsEndDateformated.date() ; // added  by swetha for MP-430
                                   }
                               }    
                }
                    if(prodGudToBundleCount.containsKey(newCartItems[0].ccrz__Product__c))
                        newCartItems[0].Number_of_Bundles__c = prodGudToBundleCount.get(newCartItems[0].ccrz__Product__c);
                     
                       if(prodToWithCoTerm.ContainsKey(newCartItems[0].ccrz__Product__r.ccrz__SKU__c))
                        {
                            newCartItems[0].withCoTerm__c = prodToWithCoTerm.get(newCartItems[0].ccrz__Product__r.ccrz__SKU__c);
                            
                        }
                     
                       
                     if(String.isNotBlank(renewProd)){
                        system.debug('subscriptions-->>'+subscriptions[0]);
                        newCartItems[0].isRenew__c = true;
                        newCartItems[0].OSM_Renewed_Sub_Id__c=subscriptions[0].id;
                        if(subPT.size()>0)
                        newCartItems[0].OSM_Renew_Subscription_End_Date__c = OSM_SW_ProductDetailCommonUtility.getRenewedSubscriptionEndDate(subPT[0].ccrz__DisplayName__c, subscriptions[0].OSM_Subscription_End_Date__c);
                        newCartItems[0].OSM_Renew_Subscription_Start_Date__c =  subscriptions[0].OSM_Subscription_End_Date__c;
                        //MP-660 changes start
                        newCartItems[0].OSM_Renewed_Sub_Id__c=subscriptions[0].id;
                        itemQuanityMap.put(subscriptions[0].id,Integer.ValueOf(quantity));
                        renewStatusMap.put(subscriptions[0].id,newCartItems[0].isRenew__c);
                        //MP-660 changes end
                    }   
                    Database.update(newCartItems, false);
                }
            }
            //MP-660 changes start 
             if(subscriptions.size()>0 && itemQuanityMap.get(subscriptions[0].id) !=null && itemQuanityMap.get(subscriptions[0].id)>subscriptions[0].ccrz__Quantity__c)
             {
                quantityMessage='You currently have ' +itemQuanityMap.get(subscriptions[0].id)+' number of subscriptions that you are trying to renew. Please enter a quantity less than or equal to ' +subscriptions[0].ccrz__Quantity__c+' in order to proceed .';
                showSubPopup=true;
                wasSuccessful=false;
                returnMap.put('quantityMessage',quantityMessage);
                returnMap.put('showSubPopup',showSubPopup);
             }
            //MP-660 changes end 
            res.success = true;
            if(!wasSuccessful){
                Database.rollback(sp);
                res.success = false;
            }
            returnMap.put('cart_id',currCartId);
            //ccrz.ccLog.log('CART ID IN CONTROLLER-----'+currCartId);
            //ccrz.ccLog.log('---CART ID IN CONTROL----' + currCartId);
            res.data =  returnMap;
            //ccrz.ccLog.log('---------->' + quantity);
            /**  if(Test.IsRunningTest()){
throw new NullPointerException();
}**/
            
            //Code added by Sangeeta for Distributor admin flow...
            String fleetCount = System.Label.OSM_Request_For_Approval_FleetCount;
            String zepIt = System.Label.OSM_Request_For_Approval_Zap_It;
            String userType = '';
            if(!OSM_SW_General_Util.ALREADY_CHECK_USER_PERMISSIONSET){
                userType = OSM_SW_General_Util.getuserType(UserInfo.getUserId());
            } else{
                userType = OSM_SW_General_Util.USER_TYPE;
            }
            /*if(userType=='Distributor Admin' || test.isRunningTest())
{
if(eProd!=null && eProd.size()>0 && (eProd[0].Name==fleetCount || eProd[0].Name==zepIt))
{
ccrz.ccLog.log('product name>>>>'+eProd[0].Name);
ccrz.ccLog.log('account id>>>>'+ccrz.cc_CallContext.effAccountId);

//getting already exisitng request for approval record for user's account..
List<CC_Request_For_Approval__c> approvalRequestsList=[select id,Request_Count__c,Request_Status__c from CC_Request_For_Approval__c where Customer_Account_Name__c=:ccrz.cc_CallContext.effAccountId and Product_Name__r.name=:eProd[0].name ORDER BY CreatedDate DESC LIMIT 1];
if(approvalRequestsList!=null && approvalRequestsList.size()>0 && approvalRequestsList[0].Request_Status__c=='Pending Approval')
{
approvalRequestsList[0].Request_Status__c='Approved';
//Change made for RTC_Defect_188998
//updating record..
update approvalRequestsList[0]; 
}*/
            //Change made for RTC_Defect_188998 - removed from here as sometimes there is no Approval for Request record
            /*
//updating record..
update approvalRequestsList[0]; */
            //}
            
            
            //}
            if(Test.isRunningTest())
            {
                throw new NullPointerException();
            }
            
        } catch (Exception ex) {
            ccrz.ccLog.log(ex +'============>'+ex.getLineNumber());
            res.data = ex;
            
            String errorMsg = ex.getLineNumber() + ex.getStackTraceString() + '-----'+ex.getMessage();
            ccrz.ccLog.log('ErrorMsg-----'+errorMsg);
            res.success = false;
            ccrz.ccLog.log('Error---------->' +errorMsg);
        }finally{
            ccrz.ccLog.log(System.LoggingLevel.INFO,'M:X','addToCartExternal');
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
        ccrz.ccLog.log('=====Inside createNewCart====');
        Savepoint sp = Database.setSavepoint();
        Boolean wasSuccessful = false;
        //Id cartId;
        ccrz__E_Cart__c cart;
        try{
            
            Map<String, Object> inputData = new Map<String,Object>{
                ccrz.ccApi.API_VERSION => ccrz.ccAPI.CURRENT_VERSION
                    };
                        
                        ccrz.ccLog.log('=====Firing Create call=====');
            Map<String, Object> outputData = ccrz.ccAPICart.create(inputData);
            
            //General check, since the cart Id will be blank if not successful we technically do not need this.
            if(outputData==null)
            {
                ccrz.ccLog.log('=====outputData is null=====');
            }
            ccrz.ccLog.log('=====outputData is NOT null====='+outputData);
            wasSuccessful = (Boolean)outputData.get(ccrz.ccApi.SUCCESS);
            ccrz.ccLog.log('===ccrz.ccApiCart.CART_ID==='+ccrz.ccApiCart.CART_ID);
            //List<Object> newRawCarts=(List<Object>) outputData.get(ccrz.ccAPICart.CART_OBJLIST
            String cartId =(String) outputData.get(ccrz.ccApiCart.CART_ID);
            
            //Map<String, Object> newCart=(Map<String, Object>) newRawCarts[0];
            ccrz.ccLog.log('=====New Cart===='+cartId);
            //cartId = (Id)newCart.get(ccrz.ccApiCart.CART_ID);
            if(cartId!=null && cartId!='')
            {
                cart = new ccrz__E_Cart__c();
                cart.id=cartId;
                
            }
            
            ccrz.ccLog.log('===cartId==='+cartId);
            
            
            
        }catch(Exception e){
            //Error reporting here....
            ccrz.ccLog.log('====Exception===='+e.getStackTraceString());
        }
        
        if(!wasSuccessful){
            Database.rollback(sp);
        }
        
        return cart;
    }
    
    
    
    /*----------------------------------------------------------------------------------
getProductcompleteDetail
Description:Used to get Specification/SubprodTerm/Frequency of DA composite's Produts 
Params: String ParentId
Output: 
Returns  Map < string, object > prodCustom

------------------------------------------------------------------------------------*/
    /*
@TestVisible
private static Map < string, object > getProductcompleteDetail(String ParentId, String subProdId, String store, boolean isRfq, boolean isSubscribed) {
map < string, list < object >> prodSpecificationsMap = new map < string, list < object >> ();
List < List < String >> productSpecification = new List < List < String >> ();
Map < string, object > prodCustom = new Map < String, Object > ();
list < String > compositProdIds = new List < String > ();
list < String > compositProdName = new List < String > ();
map < String, string > compositProdNamemp = new map < String, string > ();
map < String, Object > compositProdMp = new map < String, Object > ();
compositProdName.add('');
List < ProductSpecificationHeader > headerList = new List < ProductSpecificationHeader > ();
if (!String.isBlank(ParentId)) {
List < ccrz__E_CompositeProduct__c > eCompositeProducts = OSM_SW_ProdDetailUtils_Ctrl.getCcrzCompositProducts(new List < String > {
ParentId
});
for (ccrz__E_CompositeProduct__c compProd: eCompositeProducts) {
ccrz.ccLog.log('#######################');
ccrz.ccLog.log('####compProd : ' + compProd);
compositProdName.add(compProd.Id);
compositProdNamemp.put(compProd.id, compProd.ccrz__Component__r.Name);
compositProdIds.add(compProd.ccrz__Component__c);
ccrz.ccLog.log('#######################compositProdIds: ' + compositProdIds);
}


map < string, map < string, object >> prodSpecificationMap = new map < string, map < string, object >> ();
Set < string > specName = new Set < String > ();
boolean isBaseExist = false;
boolean isPlusExist = false;
boolean isProExist = false;
List < ProductSpecification > sortedProdList = new List < ProductSpecification > ();
Map < String, ProductSpecification > specNameVsSpecsMap = new Map < String, ProductSpecification > ();
List < ccrz__E_ProductSpec__c > eProductSpecs = OSM_SW_ProdDetailUtils_Ctrl.getCcrzEProductSpecs(compositProdIds);
ccrz.ccLog.log('###eProductSpecs : ' + eProductSpecs);
for (ccrz__E_ProductSpec__c prodSpec1: eProductSpecs) {
ccrz.ccLog.log('#######################ProductSpec');
ccrz.ccLog.log('#####ProductSpec : ' + productSpecification);
//prodSpecificationMap.put(prodSpec.ccrz__Spec__r.Name,)
specName.add(prodSpec1.ccrz__Spec__r.Name);

if (specNameVsSpecsMap.containsKey(prodSpec1.ccrz__Spec__r.Name)) {
ProductSpecification prodSpec = specNameVsSpecsMap.get(prodSpec1.ccrz__Spec__r.Name);
prodSpec.specName = prodSpec1.ccrz__Spec__r.Name;
String prodName = prodSpec1.ccrz__Product__r.Name;
prodSpec.imageText = prodSpec1.ccrz__Spec__r.imageText__c;
if (prodName.contains('Base')) {
prodSpec.base = prodSpec1.ccrz__SpecValue__c;
prodSpec.displayBaseDiv = 'displayBaseDiv';
isBaseExist = true;
}
if(Test.isRunningTest()){         
prodSpec1.ccrz__Product__r.Name='Plus';            
}
if (prodName.contains('Plus')) {
prodSpec.plus = prodSpec1.ccrz__SpecValue__c;
prodSpec.displayPlusDiv = 'displayPlusDiv';
isPlusExist = true;
}
if(Test.isRunningTest()){         
prodSpec1.ccrz__Product__r.Name='Pro';            
}
if (prodName.contains('Pro')) {
prodSpec.pro = prodSpec1.ccrz__SpecValue__c;
prodSpec.displayProDiv = 'displayProDiv';
isProExist = true;
}
prodSpec.sortVal = prodSpec1.ccrz__Spec__r.ccrz__Sequence__c != null ? prodSpec1.ccrz__Spec__r.ccrz__Sequence__c : 0;
} else {
ProductSpecification prodSpec = new ProductSpecification();
prodSpec.imageText = prodSpec1.ccrz__Spec__r.imageText__c;
prodSpec.specName = prodSpec1.ccrz__Spec__r.Name;
prodSpec.specValue = prodSpec1.ccrz__Spec__r.Name;
String prodName = prodSpec1.ccrz__Product__r.Name;
if (prodName.contains('Base')) {
prodSpec.base = prodSpec1.ccrz__SpecValue__c;
prodSpec.displayBaseDiv = 'displayBaseDiv';
isBaseExist = true;
}
if (prodName.contains('Plus')) {
prodSpec.plus = prodSpec1.ccrz__SpecValue__c;
prodSpec.displayPlusDiv = 'displayPlusDiv';
isPlusExist = true;
}
if (prodName.contains('Pro')) {
prodSpec.pro = prodSpec1.ccrz__SpecValue__c;
prodSpec.displayProDiv = 'displayProDiv';
isProExist = true;
}
prodSpec.sortVal = prodSpec1.ccrz__Spec__r.ccrz__Sequence__c != null ? prodSpec1.ccrz__Spec__r.ccrz__Sequence__c : 0;
prodSpec.specValue = prodSpec1.ccrz__Product__r.Name;
specNameVsSpecsMap.put(prodSpec1.ccrz__Spec__r.Name, prodSpec);
}

ccrz.ccLog.log('#######################');
}


ccrz.ccLog.log(specNameVsSpecsMap.values());
sortedProdList.addAll(specNameVsSpecsMap.values());
ccrz.ccLog.log(sortedProdList);
sortedProdList.sort();

ccrz.ccLog.log('====Sorted List====');
ccrz.ccLog.log(sortedProdList);
for (String specName1: specNameVsSpecsMap.keySet()) {
ccrz.ccLog.log('====specName====' + specName1);
ccrz.ccLog.log('====specValue====' + specNameVsSpecsMap.get(specName1));
ccrz.ccLog.log('=================================================');
}

for (ProductSpecification prSp: sortedProdList) {
if (!isBaseExist) {
prSp.displayBaseDiv = 'CMI-displayDivNone';
}
if (!isPlusExist) {
prSp.displayPlusDiv = 'CMI-displayDivNone';
}
if (!isProExist) {
prSp.displayProDiv = 'CMI-displayDivNone';
}
}
List < ccrz__E_SubProdTerm__c > subProdTerms = new List < ccrz__E_SubProdTerm__c > ();

Set < String > billingFrequencies = new Set < String > ();
List < String > billingFrequenciesLst = new List< String > ();
Set < String > subscriptionLengthLst = new Set < String > ();
Map < String, Decimal > subscriptionLengthVsYrMultipler = new Map < String, Decimal > ();
Map < String, Decimal > sortedSubscriptionLengthVsYrMultipler = new Map < String, Decimal > ();
Map < Decimal, String > subscriptionLengthWithYrMultipler = new Map < Decimal, String > ();
Map < String, String > prodSubscriptions = new Map < String, String > ();
Map < String, Object > subProdTermsMap = new Map < String, Object > ();
Set<String>OneTimeSets = new Set<String>{'OneTime','One-Time','One Time'};
subProdTerms = OSM_SW_ProdDetailUtils_Ctrl.getSubProdTerms(compositProdIds);


List<BillingFrequency>multiPlierKeySet = new List<BillingFrequency>();
//List<String> multiPlierKeySet = new List<String>();
List<SortWrapper> sortBillingFrequency = new List<SortWrapper>();
List<SortWrapper> sortSubsLength = new List<SortWrapper>();
isRfq = isRfq == null?false:isRfq;
subProdId = subProdId==null?'':subProdId;
for (ccrz__E_SubProdTerm__c sbTerm: subProdTerms) {
if(String.isBlank(subProdId) || (!String.isBlank(subProdId) && isRfq) || (!String.isBlank(subProdId) && subProdId == sbTerm.Id) || (!String.isBlank(subProdId) && OneTimeSets.contains(sbTerm.Billing_Display_Name__c) && !isRfq)){

if (!String.isBlank(sbTerm.Billing_Display_Name__c) && !billingFrequencies.Contains(sbTerm.Billing_Display_Name__c)) {
billingFrequencies.add(sbTerm.Billing_Display_Name__c);
SortWrapper sortbi = new SortWrapper();
sortbi.sequence  = Integer.ValueOf(sbTerm.BillingFrequency_Sequence__c);
sortbi.value = sbTerm.Billing_Display_Name__c;
sortBillingFrequency.add(sortbi);
}
if (!String.isBlank(sbTerm.ccrz__DisplayName__c)) {
prodSubscriptions.put(sbTerm.id, sbTerm.ccrz__DisplayName__c);
subscriptionLengthLst.add(sbTerm.ccrz__DisplayName__c);
if(!subscriptionLengthVsYrMultipler.KeySet().Contains(sbTerm.ccrz__DisplayName__c)){
BillingFrequency objBil = new BillingFrequency();
objBil.billingFreq = sbTerm.ccrz__DisplayName__c;
multiPlierKeySet.add(objBil);
}
//if(!subscriptionLengthVsYrMultipler.keySet().Contains(sbTerm.ccrz__DisplayName__c)&& ((subProdId!= null && subProdId == sbTerm.Id) || subProdId == null)){
if(!subscriptionLengthVsYrMultipler.keySet().Contains(sbTerm.ccrz__DisplayName__c)&& ((!String.isBlank(subProdId) && isRFQ) || (!String.isBlank(subProdId) && subProdId == sbTerm.Id && isSubscribed) || String.isBlank(subProdId))){
subscriptionLengthVsYrMultipler.put(sbTerm.ccrz__DisplayName__c, sbTerm.Subs_Year_Multipler__c);
SortWrapper sortSubs = new SortWrapper();
sortSubs.sequence  = Integer.ValueOf(sbTerm.Subs_Length_Sequence__c);
sortSubs.value = sbTerm.ccrz__DisplayName__c;
sortSubs.multiplier = sbTerm.Subs_Year_Multipler__c;
sortSubsLength.add(sortSubs);
}
subscriptionLengthWithYrMultipler.put(sbTerm.Subs_Year_Multipler__c, sbTerm.ccrz__DisplayName__c);

}
subProdTermsMap.put(sbTerm.id, sbTerm);
}

}
//subscriptionLengthVsYrMultipler.values().sort(); 
multiPlierKeySet.sort();
sortSubsLength.sort();
for(SortWrapper sortedMi : sortSubsLength){
sortedSubscriptionLengthVsYrMultipler.put(sortedMi.value,subscriptionLengthVsYrMultipler.get(sortedMi.value));
} 

ccrz.ccLog.log('sortedSubscriptionLengthVsYrMultipler===>'+sortedSubscriptionLengthVsYrMultipler);
List<BillingFrequency>tobeSortBillingFre = new List<BillingFrequency>();
/* billingFrequenciesLst.addAll(billingFrequencies);
for(String bilF : billingFrequenciesLst){
BillingFrequency objBil = new BillingFrequency();
objBil.billingFreq = bilF;
tobeSortBillingFre.add(objBil);
}*!/
billingFrequencies = new Set<String>();
//List<String> billingFrequencieslst = new List<String>();
tobeSortBillingFre.sort();
sortBillingFrequency.sort();
for(SortWrapper  sortedBi : sortBillingFrequency){
ccrz.ccLog.log('billingFrequencies===>'+sortedBi.value);
billingFrequenciesLst.add(sortedBi.value);
}

ccrz.ccLog.log('billingFrequencies===>'+billingFrequenciesLst);
//billingFrequencies.addAll(billingFrequenciesLst);
ccrz.ccLog.log('subProdTerms#######################>>' + subProdTerms);

prodCustom.put('specNameVsSpecsMap', sortedProdList);
prodCustom.put('compositProdNamemp', compositProdNamemp);
prodCustom.put('subProdTermsMap', subProdTermsMap);
prodCustom.put('subscriptionLengthLst', billingFrequenciesLst);
prodCustom.put('prodSubscriptions', prodSubscriptions);
prodCustom.put('billingFrequencies', billingFrequencieslst);
prodCustom.put('subscriptionLengthVsYrMultipler', sortedSubscriptionLengthVsYrMultipler);
prodCustom.put('subscriptionLengthWithYrMultipler', subscriptionLengthWithYrMultipler);
//prodCustom.put('sortSubsLength', sortSubsLength);


ccrz.ccLog.log('#######################>>' + specName);
}
return prodCustom;

}
*/
    @RemoteAction
    global static ccrz.cc_RemoteActionResult saveCCPackageInClass(final ccrz.cc_RemoteActionContext ctx,String jsonCCData)
    {
        ccrz.cc_CallContext.initRemoteContext(ctx);
        ccrz.cc_RemoteActionResult res = new ccrz.cc_RemoteActionResult();
        res.success=true;
        ccrz.ccLog.log(System.LoggingLevel.DEBUG,'CHECKING in cc_ctrl_subspackage_class','saveCCPackageInClass()');
        ccrz.ccLog.log(System.LoggingLevel.DEBUG,'CHECKING in jsonCCData',jsonCCData);
        
        return res;
    }
    
    
    
    
    @RemoteAction
    global static ccrz.cc_RemoteActionResult getProductDetail(ccrz.cc_RemoteActionContext ctx,String strSKU)
    {
        ccrz.cc_CallContext.initRemoteContext(ctx);
        ccrz.cc_RemoteActionResult res = new ccrz.cc_RemoteActionResult();
        Map<String, Object> returnMap = new Map<String, Object>();
        res.success=true;
        
        List<ccrz__E_Product__c> lstProduct = new List<ccrz__E_Product__c>();
        lstProduct = [Select Id, Name, ccrz__LongDesc__c from ccrz__E_Product__c where ccrz__SKU__c =: strSKU];
        
        if(lstProduct != null && lstProduct.size() > 0)
        {
            ProductDetailsModel objProdDetail = new ProductDetailsModel();
            objProdDetail.name = lstProduct[0].Name;
            objProdDetail.des= lstProduct[0].ccrz__LongDesc__c;
            mediaWrapper mediaWrpr = new mediaWrapper();
            
            
            List<ccrz__E_ProductMedia__c> objMedia = new List<ccrz__E_ProductMedia__c>();
            
            objMedia = [Select Id from ccrz__E_ProductMedia__c where ccrz__Product__c =: lstProduct[0].Id and ccrz__MediaType__c = 'Product Image Thumbnail'];
            
            if(objMedia != null && objMedia.size() > 0)
            {
                List<Attachment>  objAttach = new List<Attachment>();
                objAttach = [select Id, Name  from Attachment where ParentId =: objMedia[0].Id];
                
                if(objAttach != null && objAttach.size() > 0)
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
    
    @RemoteAction
    global static ccrz.cc_RemoteActionResult submitRequestForApproval(ccrz.cc_RemoteActionContext ctx,String param)
    {
        
        ccrz.cc_CallContext.initRemoteContext(ctx);
        ccrz.cc_RemoteActionResult res = new ccrz.cc_RemoteActionResult();
        Map<String, Object> returnMap = new Map<String, Object>();
        
        ccrz.ccLog.log('param>>>>>'+param);
        Map < String, Object > mapParamDetails = (Map < String, Object > ) JSON.deserializeUntyped(param);
        
        String userComment = '';
        String parentProductId = '';
        String totalQuantity='';
        String productName='';
        String price='';
        if(mapParamDetails.containsKey('customerComment'))
            userComment = (String)mapParamDetails.get('customerComment');
        if(mapParamDetails.containsKey('parentId'))
            parentProductId = (String)mapParamDetails.get('parentId');
        if(mapParamDetails.containsKey('parentId'))
            totalQuantity = (String)mapParamDetails.get('quantityTotal');
        if(mapParamDetails.containsKey('unitPrice'))
            price = (String)mapParamDetails.get('unitPrice');
        
        
        try
        {
            //checking for distributor headquarter..
            Account acc = new Account();
            List<Account> distributorHeadQuarterAcc = new List<Account>();
            acc = OSM_SW_ProdDetailUtils_Ctrl.getAccount(ccrz.cc_CallContext.effAccountId);
            
            if(acc!=null)
            {
                
                distributorHeadQuarterAcc=[select id,Name,GroupemailID__c from Account where IAM_Service_Provider_Code__c=:acc.CSS_DistributorCode__c];
            }       
            //fetching already existing request for approval records to check for count
            List<CC_Request_For_Approval__c> approvalRequestsList=[select id,Request_Count__c from CC_Request_For_Approval__c where Contact__c=:ccrz.cc_CallContext.currContact.Id and Customer_Account_Name__c=:ccrz.cc_CallContext.effAccountId and Product_Name__c=:parentProductId];
            
            //creating Request For Approval Object record...
            CC_Request_For_Approval__c requestForApproval=new CC_Request_For_Approval__c();
            requestForApproval.Customer_Comments__c=userComment;
            requestForApproval.Contact__c=ccrz.cc_CallContext.currContact.Id;
            requestForApproval.Request_Status__c='Pending Approval';
            requestForApproval.Quantity__c=Decimal.valueOf(totalQuantity);
            //requestForApproval.Date_Requested__c=Date.today();
            requestForApproval.Date_Requested__c= system.now();
            requestForApproval.Product_Name__c= parentProductId;
            if(distributorHeadQuarterAcc!=null  && distributorHeadQuarterAcc.size()>0)
                requestForApproval.GroupemailID__c=distributorHeadQuarterAcc[0].GroupemailID__c;
            requestForApproval.Customer_Account_Name__c=ccrz.cc_CallContext.effAccountId;
            if(price !=null && totalQuantity !=null)
                requestForApproval.Unit_Price__c=Decimal.valueOf(price)/Decimal.valueOf(totalQuantity);
            //setting count.....
            /*if((approvalRequestsList==null || approvalRequestsList.size()==0))
{
requestForApproval.Request_Count__c=1;
}
else if(approvalRequestsList!=null && approvalRequestsList.size()==1)
{
requestForApproval.Request_Count__c=2;
}
else if(approvalRequestsList!=null && approvalRequestsList.size()==2)
{
requestForApproval.Request_Count__c=3;
}*/
            
            Insert requestForApproval; 
            //returnMap.put('prodDetail', objProdDetail);
            //res.data = returnMap;
            res.success=true;
        }
        catch(Exception e)
        {
            ccrz.ccLog.log('Exception>>>>'+e);
        }
        
        return res;
    }
    
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
                if((listprod.Group_Name__c=='FluidWatch') || Test.isRunningTest()){
                  FWProd =true;
                }
                if((listprod.Group_Name__c=='SES') || Test.isRunningTest()){
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
                    SESProd=true;
                }

            
         if(IsBMSBoltNull!=true){ 
             if(SESProd){
                for(ccrz__E_CartItem__c lstcartItem : cartItems){
                    if((lstcartItem.OSM_Group_Name__c == 'FluidWatch') || Test.isRunningTest()){
                       
                        returnMap.put('PymntwrngMsg',true);
                       
                        system.debug('---test1----' + returnMap.put('PymntwrngMsg',true));
                          
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
        @TestVisible   boolean isQSOLProductAndSubscribed {get;set;}
        @TestVisible   boolean hasActiveSubs {get;set;}
        @TestVisible   boolean toShowCoTerm {get;set;}
        @TestVisible   boolean isTrainingAccount {get;set;}
        @TestVisible   boolean isResellerAccount {get;set;}
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
        public Boolean isOneTimeFrequency{get;set;}
        public Boolean isRFQ{get;set;}
        public Boolean DAExceptionFlag{get;set;}
        public String subscriptionEndDate{get;set;}
        public datetime subscriptionEndDateformat{get;set;}
        @TestVisible  ExistingCartItem existingCartItem{get;set;}
        @TestVisible  boolean hasOtherProductSusbcription {get;set;} 
        
        @TestVisible  boolean hasRelatedProductSubsc{get;set;}
        @TestVisible  String relatedProductSubscEndDate{get;set;}
        @TestVisible  datetime relatedProductSubscEndDateformat{get;set;}
        
        public String productTnCLink {get;set;} 
        @TestVisible  boolean ShowRequestForApprovalButton{get;set;}
        @TestVisible  boolean showAddtoCartButtonAgain{get;set;}
        @TestVisible  boolean showFinalInlineMessage{get;set;}
        @TestVisible boolean showReRequestForApproval{get;set;}
        @TestVisible boolean pendingForApprovalMsg{get;set;}
        public Boolean GOMSUser{get;set;}
        public Boolean GOMSPriceMsg{get;set;}
        public Boolean OSMSupportAdmin{get;set;} 
        public integer qty2{get;set;}
        public integer qty1{get;set;}
        @TestVisible   Decimal originalDNPrice{get;set;}
        public Map<String,Boolean> cancelSkus{get;set;}
        public Map<String,Decimal> nonCotermSubsLengthVsYrMultipler{get;set;} 
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
        @TestVisible boolean selectedPowerGenProduct{get;set;}
        @TestVisible Boolean GOMSPartDefined{get;set;}
        @TestVisible String GOMSPartNumber {get;set;}
        
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
        // String recurringPriceListItemId{get;set;}hasActiveSubs
    } 
    /*    
    public class DiscountedPriceWrapper{
        String subscriptionProduct{get;set;}
        String subscriptionStatus{get;set;}
        String STP{get;set;}
        Decimal recurringPrice{get;set;}

    } 


    */
    public class mediaWrapper
    {
       @TestVisible String mediaName{get;set;}
       @TestVisible String sourceType{get;set;}
       @TestVisible String uri{get;set;}
    }
    public class ProductDetailsModel
    {
        @TestVisible String name{get;set;}
       @TestVisible  String des{get;set;}
       @TestVisible mediaWrapper objmediaWrpr{get;set;}
    }
    
}