/**
 *      @author             Vineet 
 *      @date               03/12/2018
 *      @description        will be having common product detail logic like populate billing frequency on Account and pricing calculation based proration 

        Modification Log:
        ------------------------------------------------------------------------------------
        Developer                       Date                Description
        ------------------------------------------------------------------------------------
        Vineet                         03/12/2018           Initial Setup
        Recompilation
        Recompilation
 */

Public with sharing class OSM_SW_SES_Product_Utility_Ctrl {
        
 
    /**
    ** getBillingFrequenciesAndSubscriptions get products all frequencies and subscriptions 
    **/
    public static Map<String, Object> getBillingFrequenciesAndSubscriptions(Map<Id, ccrz__E_SubProdTerm__c> subProdTerms, String accountId, String store, String productId, String renewSubProd){
      system.debug('subProdTerms--->'+subProdTerms);
        system.debug('store--->'+store);
        system.debug('productId--->'+productId);
        Map < string, object > prodCustom = new Map < String, Object > ();
        List<String> listProdSKU= new List<String>();
        String prodSKU;
        String prodType;
        try{
        //OSM_SW_ProductDetaiServiceCls.DiscountedPriceWrapper  availableSubs = OSM_SW_ProductDetaiServiceCls.getDiscountedPrice(store, accountId, new Set<String>{productId});
        
        list < String > compositProdIds = new List < String > ();
     list < String > compositProdName = new List < String > ();
     map < String, string > compositProdNamemp = new map < String, string > ();
     map < String, Object > compositProdMp = new map < String, Object > ();
     compositProdName.add('');
     //if (!String.isBlank(productId)) {
      List < ccrz__E_CompositeProduct__c > eCompositeProducts = OSM_SW_ProdDetailUtils_Ctrl.getCcrzCompositProducts(new List < String > {
       productId
      }); 
      system.debug('####################eCompositeProducts###'+eCompositeProducts);
      system.debug('productId--->'+productId);
      String baseProductId = '';
      for (ccrz__E_CompositeProduct__c compProd: eCompositeProducts) {
       system.debug('compProd.ccrz__Component__r.ccrz__SKU__c---->>'+compProd.ccrz__Component__r.ccrz__SKU__c);
       system.debug('####compProd : ' + compProd);
       compositProdName.add(compProd.Id);
       compositProdNamemp.put(compProd.id, compProd.ccrz__Component__r.Name);
       compositProdIds.add(compProd.ccrz__Component__c);
       listProdSKU.add(compProd.ccrz__Component__r.ccrz__SKU__c);
       prodSKU = compProd.ccrz__Component__r.ccrz__SKU__c;
       prodType = compProd.ccrz__Component__r.ccrz__ProductType__c;
        if(compProd.ccrz__Component__r.Name.containsIgnoreCase('Base')){
        //   baseSku = compProd.ccrz__Component__r.ccrz__SKU__c;
           baseProductId = compProd.ccrz__Component__c;
       }
       system.debug('#######################compositProdIds: ' + compositProdIds);
      }
            
       OSM_SW_ProductDetaiServiceCls.DiscountedPriceWrapper  availableSubs = OSM_SW_ProductDetaiServiceCls.getDiscountedPrice(store, accountId, new Set<String>{baseProductId});
            if(!String.isBlank(availableSubs.STP) && availableSubs.isSubscribed){
               // subsSPTid = availableSubs.STP;
               // isSubscribed = availableSubs.isSubscribed;
            }
   
      map < string, map < string, object >> prodSpecificationMap = new map < string, map < string, object >> ();
      Set < string > specName = new Set < String > ();
      boolean isBaseExist = false;
      boolean isPlusExist = false;
      boolean isProExist = false;
      List < ProductSpecification > sortedProdList = new List < ProductSpecification > ();
      Map < String, ProductSpecification > specNameVsSpecsMap = new Map < String, ProductSpecification > ();
     
     List < ccrz__E_CompositeProduct__c > eProductSpecs = OSM_SW_ProdDetailUtils_Ctrl.getCcrzCompositProducts(compositProdIds);
      System.debug('###eProductSpecs : ' + eProductSpecs);
      for (ccrz__E_CompositeProduct__c prodSpec1: eProductSpecs) {
          //Product_Supporting_Text
       system.debug('#######################ProductSpec--->'+prodSpec1);
       specName.add(prodSpec1.ccrz__Component__r.Name);
       
       if (specNameVsSpecsMap.containsKey(prodSpec1.ccrz__Component__r.Name)) {
           ProductSpecification prodSpec = specNameVsSpecsMap.get(prodSpec1.ccrz__Component__r.Name);
           prodSpec.supportingText = prodSpec1.ccrz__Component__r.Product_Supporting_Text__c;
           prodSpec.specName = prodSpec1.ccrz__Component__r.Name;
           String prodName = prodSpec1.ccrz__Composite__r.Package__c;
           //prodSpec.imageText = prodSpec1.ccrz__Spec__r.imageText__c;
           prodSpec.sku = prodSpec1.ccrz__Component__r.ccrz__SKU__c;
           prodSpec.unitOfMes = prodSpec1.Unit_of_Measure__c;
           prodSpec.fluidVolReq = prodSpec1.Fluid_Volume_required__c;
        
        String unit = prodSpec1.Unit__c;
        if(null != prodSpec1.ccrz__Quantity__c)
        {
            if(1 == prodSpec1.ccrz__Quantity__c)
            {
                unit = unit.substring(0, unit.length()-1);
            }
        }
         
        if (prodName.contains('Base')) {
         prodSpec.base = ''+prodSpec1.ccrz__Quantity__c + ' ' + unit;
            if(prodSpec1.ccrz__Quantity__c == null){
                prodSpec.base = ' - ';
            } 
            if(prodSpec1.ccrz__Quantity__c == 9999){
                prodSpec.base = 'Unlimited Users';
            }
         prodSpec.displayBaseDiv = 'displayBaseDiv';
         isBaseExist = true;
        }
        if (prodName.contains('Lite')) {
         prodSpec.plus = ''+prodSpec1.ccrz__Quantity__c + ' ' + unit;
            if(prodSpec1.ccrz__Quantity__c == null){
                prodSpec.plus = ' - ';
            } 
            if(prodSpec1.ccrz__Quantity__c == 9999){
                prodSpec.plus = 'Unlimited Users';
            }
         prodSpec.displayPlusDiv = 'displayPlusDiv';
         isPlusExist = true;
        }
        if (prodName.contains('Pro')) {
         prodSpec.pro = ''+prodSpec1.ccrz__Quantity__c + ' ' + unit;
         if(prodSpec1.ccrz__Quantity__c == null){
                prodSpec.pro = ' - ';
            } 
            if(prodSpec1.ccrz__Quantity__c == 9999){
                prodSpec.pro = 'Unlimited Users';
            }   
         prodSpec.displayProDiv = 'displayProDiv';
         isProExist = true;
        }
        prodSpec.sortVal = prodSpec1.ccrz__Sequence__c != null ? prodSpec1.ccrz__Sequence__c : 0;
       } else {
           ProductSpecification prodSpec = new ProductSpecification();
           prodSpec.supportingText = prodSpec1.ccrz__Component__r.Product_Supporting_Text__c;
           //prodSpec.imageText = prodSpec1.ccrz__Spec__r.imageText__c;
           prodSpec.sku = prodSpec1.ccrz__Component__r.ccrz__SKU__c;
           prodSpec.specName = prodSpec1.ccrz__Component__r.Name;
           prodSpec.specValue = ''+prodSpec1.ccrz__Quantity__c;
           String prodName = prodSpec1.ccrz__Composite__r.Package__c != null ? prodSpec1.ccrz__Composite__r.Package__c:'';
           prodSpec.unitOfMes = prodSpec1.Unit_of_Measure__c;
           prodSpec.fluidVolReq = prodSpec1.Fluid_Volume_required__c;
        String unit = prodSpec1.Unit__c;
        if(!Test.isRunningTest()){
        if(null != prodSpec1.ccrz__Quantity__c)
        {
            if(1 == prodSpec1.ccrz__Quantity__c)
            {
                unit = unit.substring(0, unit.length()-1);
            }
        }
        }
           
        if (prodName.contains('Base')) {
         prodSpec.base = ''+prodSpec1.ccrz__Quantity__c + ' ' + unit;
            if(prodSpec1.ccrz__Quantity__c == null){
                prodSpec.base = ' - ';
            } 
            if(prodSpec1.ccrz__Quantity__c == 9999){
                prodSpec.base = 'Unlimited Users';
            } 
         prodSpec.displayBaseDiv = 'displayBaseDiv';
         isBaseExist = true;
        }
        if (prodName.contains('Lite')) {
         prodSpec.plus = ''+prodSpec1.ccrz__Quantity__c + ' ' + unit;
          if(prodSpec1.ccrz__Quantity__c == null){
                prodSpec.plus = ' - ';
            } 
            if(prodSpec1.ccrz__Quantity__c == 9999){
                prodSpec.plus = 'Unlimited Users';
            } 
         prodSpec.displayPlusDiv = 'displayPlusDiv';
         isPlusExist = true;
        }
        if (prodName.contains('Pro')) {
         prodSpec.pro = ''+prodSpec1.ccrz__Quantity__c + ' ' + unit;
             if(prodSpec1.ccrz__Quantity__c == null){
                prodSpec.pro = ' - ';
            } 
            if(prodSpec1.ccrz__Quantity__c == 9999){
                prodSpec.pro = 'Unlimited Users';
            } 
         prodSpec.displayProDiv = 'displayProDiv';
         isProExist = true;
        }
        prodSpec.sortVal = prodSpec1.ccrz__Sequence__c != null ? prodSpec1.ccrz__Sequence__c : 0;
        prodSpec.specValue = '' + prodSpec1.ccrz__Quantity__c;
        specNameVsSpecsMap.put(prodSpec1.ccrz__Component__r.Name, prodSpec);
       }
   
       system.debug('#######################');
      }
   
   
      System.debug(specNameVsSpecsMap.values());
      for(String key : specNameVsSpecsMap.keySet()){
       ProductSpecification prodSpec = specNameVsSpecsMap.get(key);
       prodSpec.base = string.isBlank(prodSpec.base)?' - ':prodSpec.base;
       prodSpec.plus = string.isBlank(prodSpec.plus)?' - ':prodSpec.plus;
       prodSpec.pro = string.isBlank(prodSpec.pro)?' - ':prodSpec.pro;
       specNameVsSpecsMap.put(key,prodSpec);   
   }      
      sortedProdList.addAll(specNameVsSpecsMap.values());
      System.debug(sortedProdList);
      sortedProdList.sort();
   
      System.debug('====Sorted List====');
      System.debug(sortedProdList);
      for (String specName1: specNameVsSpecsMap.keySet()) {
       System.debug('====specName====' + specName1);
       System.debug('====specValue====' + specNameVsSpecsMap.get(specName1));
       System.debug('=================================================');
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
        
        
        
        //List<String> billingFrequencies = new List<String>();
        Set < String > billingFrequencies = new Set < String > ();
        List<BillingFrequency>multiPlierKeySet = new List<BillingFrequency>();
      List < String > billingFrequenciesLst = new List< String > ();
      Set < String > subscriptionLengthLst = new Set < String > ();
      Map < String, Decimal > subscriptionLengthVsYrMultipler = new Map < String, Decimal > ();
      Map < String, Decimal > sortedSubscriptionLengthVsYrMultipler = new Map < String, Decimal > ();
      Map < Decimal, String > subscriptionLengthWithYrMultipler = new Map < Decimal, String > ();
      Map < String, String > prodSubscriptions = new Map < String, String > ();
      Map < String, Object > subProdTermsMap = new Map < String, Object > ();
      Set<String>OneTimeSets = new Set<String>{'OneTime','One-Time','One Time'};
      List<SortWrapper> sortBillingFrequency = new List<SortWrapper>();
       List<SortWrapper> sortSubsLength = new List<SortWrapper>();
       //MP-136 Code Start - 28-10-2021
       system.debug('prodSKU--->'+prodSKU);
       List<ccrz__E_Subscription__c> accountsubscriptions = new List<ccrz__E_Subscription__c>();
       List<ccrz__E_Subscription__c> cancelledAccSubscriptions = new List<ccrz__E_Subscription__c>();
       List<ccrz__E_Subscription__c> activeAccSubscriptions = new List<ccrz__E_Subscription__c>();
       Map<String,Boolean> cancelSkus= new Map<String,Boolean>();
       accountsubscriptions=[Select id,name,ccrz__SubscriptionStatus__c,ccrz__SubscriptionProduct__r.ccrz__SKU__c,ccrz__SubscriptionProduct__c  from ccrz__E_Subscription__c where ccrz__Account__c=:accountId AND ccrz__SubscriptionProduct__r.ccrz__SKU__c=:listProdSKU AND ccrz__SubscriptionStatus__c='Expired' order by createddate desc limit 1];
       cancelledAccSubscriptions =[Select id,name,ccrz__SubscriptionStatus__c,ccrz__SubscriptionProduct__r.ccrz__SKU__c,ccrz__SubscriptionProduct__c from ccrz__E_Subscription__c where ccrz__Account__c=:accountId AND ccrz__SubscriptionProduct__r.ccrz__SKU__c=:listProdSKU AND ccrz__SubscriptionStatus__c='Cancelled' order by createddate desc];
       Set<id> cancelledProd = new Set<id>();
       for(ccrz__E_Subscription__c canAccSub:cancelledAccSubscriptions){
           cancelledProd.add(canAccSub.ccrz__SubscriptionProduct__c);
       }
       if(cancelledAccSubscriptions.size()>0){
           activeAccSubscriptions=[ Select id,name,ccrz__SubscriptionStatus__c,OSM_Display_Product__c,ccrz__SubscriptionProduct__r.ccrz__SKU__c,ccrz__SubscriptionProduct__c  from ccrz__E_Subscription__c where ccrz__Account__c=:accountId AND OSM_Display_Product__c=:cancelledProd AND ccrz__SubscriptionStatus__c='Active' order by createddate desc];
       }
       if(activeAccSubscriptions.size()>0){
           for(ccrz__E_Subscription__c canSub:cancelledAccSubscriptions){
               cancelSkus.put(canSub.ccrz__SubscriptionProduct__r.ccrz__SKU__c,True);
           }system.debug('cancelSkus-->>'+cancelSkus);
       }
       system.debug('accountsubscriptions-->>'+accountsubscriptions);
       Map<String, OSM_SubscriptionLength__mdt> subscriptionLengthMapData=OSM_FetchCustomMetaData_Ctrl.getSubscriptionMetaDataMap();
       OSM_SubscriptionLength__mdt subsLengthData = new OSM_SubscriptionLength__mdt();
       if(accountsubscriptions.size()>0){
           subsLengthData = subscriptionLengthMapData.get(accountsubscriptions[0].ccrz__SubscriptionProduct__r.ccrz__SKU__c);
       }else{
           subsLengthData = subscriptionLengthMapData.get(prodSKU);
       }
       //MP-136 Code End - 28-10-2021
       
        for (Id key : subProdTerms.keySet()) {
        system.debug('key-->'+key);
               ccrz__E_SubProdTerm__c sbTerm = subProdTerms.get(key);
             system.debug('sbTerm-->'+sbTerm);
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
            if(!subscriptionLengthVsYrMultipler.keySet().Contains(sbTerm.ccrz__DisplayName__c) 
                   &&( !availableSubs.isSubscribed 
                       || (availableSubs.isSubscribed 
                               && availableSubs.subsLength == sbTerm.ccrz__DisplayName__c))
                   ){
                subscriptionLengthVsYrMultipler.put(sbTerm.ccrz__DisplayName__c, sbTerm.Subs_Year_Multipler__c);
                 SortWrapper sortSubs = new SortWrapper();
                sortSubs.sequence  = Integer.ValueOf(sbTerm.Subs_Length_Sequence__c);
                
                //MP-136 Code Start - 28-10-2021
                OSM_Features_Maintenance__c osmFeaMaint = OSM_Features_Maintenance__c.getValues('SubscriptionLength');
                if(subsLengthData != Null && subsLengthData.Subscription_Length__c.contains(sbTerm.ccrz__DisplayName__c) && osmFeaMaint != Null && osmFeaMaint.Subscription_Length__c.equalsignorecase('ON') && prodType != 'Bundle'){ 
                    system.debug('sbTerm.ccrz__DisplayName__c----->>'+sbTerm.ccrz__DisplayName__c);
                    sortSubs.value = sbTerm.ccrz__DisplayName__c;
                   }else if(subsLengthData != Null && subsLengthData.Subscription_Length__c.contains(sbTerm.ccrz__DisplayName__c) && osmFeaMaint != Null && osmFeaMaint.Subscription_Length__c.equalsignorecase('ON') && prodType == 'Bundle' && accountsubscriptions.size()>0 && (accountsubscriptions[0].ccrz__SubscriptionStatus__c=='Expired' || !String.isBlank(renewSubProd))){
                       sortSubs.value = sbTerm.ccrz__DisplayName__c;
                   }else if(subsLengthData != Null && subsLengthData.Subscription_Length__c.contains(sbTerm.ccrz__DisplayName__c) && osmFeaMaint != Null && osmFeaMaint.Subscription_Length__c.equalsignorecase('ON') && prodType == 'Bundle' && (accountsubscriptions.size()==0 || accountsubscriptions == Null) && !String.isBlank(renewSubProd)){
                       sortSubs.value =sbTerm.ccrz__DisplayName__c;
                   }else if(subsLengthData != Null && subsLengthData.Subscription_Length__c.contains(sbTerm.ccrz__DisplayName__c) && osmFeaMaint != Null && osmFeaMaint.Subscription_Length__c.equalsignorecase('ON') && prodType == 'Bundle' && (accountsubscriptions.size()==0 || accountsubscriptions == Null)){
                       sortSubs.value =Label.OSM_Default_Subscription_Length;//'1 Year';
                   }//MP-757 code start
                   else if(osmFeaMaint != Null && osmFeaMaint.Subscription_Length__c.equalsignorecase('OFF') && label.OSM_99Years_SubLength.containsIgnoreCase(sbTerm.ccrz__DisplayName__c)){
                    sortSubs.value =sbTerm.ccrz__DisplayName__c;
                }//MP-757 Code end
                   else{
                       sortSubs.value = osmFeaMaint.Default_Subscription_Length__c;
                   }
                //MP-136 Code End - 28-10-2021
                sortSubs.multiplier = sbTerm.Subs_Year_Multipler__c;
                sortSubsLength.add(sortSubs);
                subscriptionLengthWithYrMultipler.put(sbTerm.Subs_Year_Multipler__c, sbTerm.ccrz__DisplayName__c);
            }
            
            
           }
           subProdTermsMap.put(sbTerm.id, sbTerm);
          }
   
      
        
        multiPlierKeySet.sort();
       sortSubsLength.sort();
           for(SortWrapper sortedMi : sortSubsLength){
          sortedSubscriptionLengthVsYrMultipler.put(sortedMi.value,subscriptionLengthVsYrMultipler.get(sortedMi.value));
      } 
         
      system.debug('sortedSubscriptionLengthVsYrMultipler===>'+sortedSubscriptionLengthVsYrMultipler);
      List<BillingFrequency>tobeSortBillingFre = new List<BillingFrequency>();
    
      billingFrequencies = new Set<String>();
      //List<String> billingFrequencieslst = new List<String>();
      tobeSortBillingFre.sort();
      sortBillingFrequency.sort();
      for(SortWrapper  sortedBi : sortBillingFrequency){
          system.debug('billingFrequencies===>'+sortedBi.value);
          billingFrequenciesLst.add(sortedBi.value);
      }
       prodCustom.put('specNameVsSpecsMap', sortedProdList);
      prodCustom.put('subProdTermsMap', subProdTermsMap);
      prodCustom.put('subscriptionLengthLst', billingFrequenciesLst);
      prodCustom.put('prodSubscriptions', prodSubscriptions);
      prodCustom.put('billingFrequencies', billingFrequencieslst);
      prodCustom.put('subscriptionLengthVsYrMultipler', sortedSubscriptionLengthVsYrMultipler);
      prodCustom.put('subscriptionLengthWithYrMultipler', subscriptionLengthWithYrMultipler);
      prodCustom.put('cancelSkus',cancelSkus);
            }catch(Exception ex){system.debug(ex.getLineNumber()+'<====>'+ex);}
      return prodCustom;
    }
    
    
    
    /**
    ** getBillingFrequenciesAndSubscriptionsWithAccBillFre get products all frequencies and subscriptions 
    **/
       /*
    public static Map<String, Object> getBillingFrequenciesAndSubscriptionsWithAccBillFre(Map<Id, ccrz__E_SubProdTerm__c> subProdTerms, String accountBillingFrequency, String accountId, String store, String productId){
       
        Map < string, object > prodCustom = new Map < String, Object > ();
        String subsSPTid = '';
        boolean isSubscribed = false;
        try{
       
         system.debug('subsSPTid--->'+subsSPTid);
        list < String > compositProdIds = new List < String > ();
     list < String > compositProdName = new List < String > ();
     map < String, string > compositProdNamemp = new map < String, string > ();
     map < String, Object > compositProdMp = new map < String, Object > ();
     compositProdName.add('');
     //if (!String.isBlank(productId)) {
      List < ccrz__E_CompositeProduct__c > eCompositeProducts = OSM_SW_ProdDetailUtils_Ctrl.getCcrzCompositProducts(new List < String > {
       productId
      });
            
       String baseProductId = '';
      for (ccrz__E_CompositeProduct__c compProd: eCompositeProducts) {
       system.debug('#######################');
       system.debug('####compProd : ' + compProd);
       compositProdName.add(compProd.Id);
       compositProdNamemp.put(compProd.id, compProd.ccrz__Component__r.Name);
       compositProdIds.add(compProd.ccrz__Component__c);
        if(compProd.ccrz__Component__r.Name.containsIgnoreCase('Base')){
        //   baseSku = compProd.ccrz__Component__r.ccrz__SKU__c;
           baseProductId = compProd.ccrz__Component__c;
       }
       system.debug('#######################compositProdIds: ' + compositProdIds);
      }
            
       OSM_SW_ProductDetaiServiceCls.DiscountedPriceWrapper  availableSubs = OSM_SW_ProductDetaiServiceCls.getDiscountedPrice(store, accountId, new Set<String>{baseProductId});
            if(!String.isBlank(availableSubs.STP) && availableSubs.isSubscribed){
                subsSPTid = availableSubs.STP;
                isSubscribed = availableSubs.isSubscribed;
            }
   
   
      map < string, map < string, object >> prodSpecificationMap = new map < string, map < string, object >> ();
      Set < string > specName = new Set < String > ();
      boolean isBaseExist = false;
      boolean isPlusExist = false;
      boolean isProExist = false;
      List < ProductSpecification > sortedProdList = new List < ProductSpecification > ();
      Map < String, ProductSpecification > specNameVsSpecsMap = new Map < String, ProductSpecification > ();
      List < ccrz__E_ProductSpec__c > eProductSpecs = OSM_SW_ProdDetailUtils_Ctrl.getCcrzEProductSpecs(compositProdIds);
      System.debug('###eProductSpecs : ' + eProductSpecs);
      for (ccrz__E_ProductSpec__c prodSpec1: eProductSpecs) {
       system.debug('#######################ProductSpec');
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
   
       system.debug('#######################');
      }
   
   
      System.debug(specNameVsSpecsMap.values());
      sortedProdList.addAll(specNameVsSpecsMap.values());
      System.debug(sortedProdList);
      sortedProdList.sort();
   
      System.debug('====Sorted List====');
      System.debug(sortedProdList);
      for (String specName1: specNameVsSpecsMap.keySet()) {
       System.debug('====specName====' + specName1);
       System.debug('====specValue====' + specNameVsSpecsMap.get(specName1));
       System.debug('=================================================');
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
        
          
        //Map < string, object > prodCustom = new Map < String, Object > ();
        //List<String> billingFrequencies = new List<String>();
        Set < String > billingFrequencies = new Set < String > ();
        List<BillingFrequency>multiPlierKeySet = new List<BillingFrequency>();
      List < String > billingFrequenciesLst = new List< String > ();
      Set < String > subscriptionLengthLst = new Set < String > ();
      Map < String, Decimal > subscriptionLengthVsYrMultipler = new Map < String, Decimal > ();
      Map < String, Decimal > sortedSubscriptionLengthVsYrMultipler = new Map < String, Decimal > ();
      Map < Decimal, String > subscriptionLengthWithYrMultipler = new Map < Decimal, String > ();
      Map < String, String > prodSubscriptions = new Map < String, String > ();
      Map < String, Object > subProdTermsMap = new Map < String, Object > ();
      Set<String>OneTimeSets = new Set<String>{'OneTime','One-Time','One Time'};
      List<SortWrapper> sortBillingFrequency = new List<SortWrapper>();
       List<SortWrapper> sortSubsLength = new List<SortWrapper>();
       
        
        for (Id key : subProdTerms.keySet()) {
               ccrz__E_SubProdTerm__c sbTerm = subProdTerms.get(key);
             
           if (!String.isBlank(sbTerm.Billing_Display_Name__c) && !billingFrequencies.Contains(sbTerm.Billing_Display_Name__c) 
               && (OneTimeSets.Contains(sbTerm.Billing_Display_Name__c)||sbTerm.Billing_Display_Name__c==accountBillingFrequency)) {
                billingFrequencies.add(sbTerm.Billing_Display_Name__c);
                SortWrapper sortbi = new SortWrapper();
                sortbi.sequence  = Integer.ValueOf(sbTerm.BillingFrequency_Sequence__c);
                sortbi.value = sbTerm.Billing_Display_Name__c;
                sortBillingFrequency.add(sortbi);
               }
           if (!String.isBlank(sbTerm.ccrz__DisplayName__c)) {
            prodSubscriptions.put(sbTerm.id, sbTerm.ccrz__DisplayName__c);
            subscriptionLengthLst.add(sbTerm.ccrz__DisplayName__c);
            if(!subscriptionLengthVsYrMultipler.KeySet().Contains(sbTerm.ccrz__DisplayName__c)
              && (String.isBlank(subsSPTid) || (!String.isBlank(subsSPTid)&& isSubscribed && subsSPTid == sbTerm.Id) || !isSubscribed)){
                BillingFrequency objBil = new BillingFrequency();
              objBil.billingFreq = sbTerm.ccrz__DisplayName__c;
              multiPlierKeySet.add(objBil);
            }
            //if(!subscriptionLengthVsYrMultipler.keySet().Contains(sbTerm.ccrz__DisplayName__c)&& ((subProdId!= null && subProdId == sbTerm.Id) || subProdId == null)){
            if(!subscriptionLengthVsYrMultipler.keySet().Contains(sbTerm.ccrz__DisplayName__c) 
               && (String.isBlank(subsSPTid) || (!String.isBlank(subsSPTid) && subsSPTid == sbTerm.Id))){
                subscriptionLengthVsYrMultipler.put(sbTerm.ccrz__DisplayName__c, sbTerm.Subs_Year_Multipler__c);
                 SortWrapper sortSubs = new SortWrapper();
                sortSubs.sequence  = Integer.ValueOf(sbTerm.Subs_Length_Sequence__c);
                sortSubs.value = sbTerm.ccrz__DisplayName__c;
                sortSubs.multiplier = sbTerm.Subs_Year_Multipler__c;
                sortSubsLength.add(sortSubs);
                subscriptionLengthWithYrMultipler.put(sbTerm.Subs_Year_Multipler__c, sbTerm.ccrz__DisplayName__c);
            }
            
            
           }
           subProdTermsMap.put(sbTerm.id, sbTerm);
          }
   
      
        
        multiPlierKeySet.sort();
       sortSubsLength.sort();
           for(SortWrapper sortedMi : sortSubsLength){
          sortedSubscriptionLengthVsYrMultipler.put(sortedMi.value,subscriptionLengthVsYrMultipler.get(sortedMi.value));
      } 
         
      system.debug('sortedSubscriptionLengthVsYrMultipler===>'+sortedSubscriptionLengthVsYrMultipler);
      List<BillingFrequency>tobeSortBillingFre = new List<BillingFrequency>();
    
      billingFrequencies = new Set<String>();
      //List<String> billingFrequencieslst = new List<String>();
      tobeSortBillingFre.sort();
      sortBillingFrequency.sort();
      for(SortWrapper  sortedBi : sortBillingFrequency){
          system.debug('billingFrequencies===>'+sortedBi.value);
          billingFrequenciesLst.add(sortedBi.value);
      }
         prodCustom.put('specNameVsSpecsMap', sortedProdList);
      prodCustom.put('subProdTermsMap', subProdTermsMap);
      prodCustom.put('subscriptionLengthLst', billingFrequenciesLst);
      prodCustom.put('prodSubscriptions', prodSubscriptions);
      prodCustom.put('billingFrequencies', billingFrequencieslst);
      prodCustom.put('subscriptionLengthVsYrMultipler', sortedSubscriptionLengthVsYrMultipler);
      prodCustom.put('subscriptionLengthWithYrMultipler', subscriptionLengthWithYrMultipler);
        }catch(Exception ex){system.debug('error==>'+ex);}
      return prodCustom;
    }
     
   */
    
    /*------------------------------------------------------------------------------
   Wrapper for Sorting
   ------------------------------------------------------------------------------*/
   public class SortWrapper implements Comparable {
   Integer sequence{get;set;} 
   String value{get;set;}
   Decimal multiplier{get;set;}
   
       public Integer compareTo(Object ObjToCompare) {
           SortWrapper srt = (SortWrapper)(ObjToCompare);
           if (this.sequence == srt.sequence) return 0;
           if (this.sequence > srt.sequence) return 1;
           return -1; 
       }  
   
   } 
   /*----------------------------------------------------------------------------------
   WrapperClass BillingFrequency 
   Description:Used for BillingFrequency  sorting
   Sorting of Products based on sorting Value 
   ------------------------------------------------------------------------------------*/ 
   public class BillingFrequency implements Comparable{
       
        
       String billingFreq{get;set;}
       public Integer compareTo(Object ObjToCompare) {
           BillingFrequency prodSpec = (BillingFrequency)(ObjToCompare);
           If(this.billingFreq.ContainsIgnoreCase('Time')){return 1;}
           if (this.billingFreq== prodSpec.billingFreq) return 0;
           if (this.billingFreq > prodSpec.billingFreq) return 1;
           return -1; 
       }
       
   }
   /*----------------------------------------------------------------------------------
   WrapperClass 
   Description:get Billing frequncy and isCurrent User's Cart and 
   Sorting of Products based on sorting Value 
   ------------------------------------------------------------------------------------*/   
     public class MainDetailWrapper {
         String cartitemsBillingFrequency{get;set;}
         String aaccountBillingFrequency{get;set;}
         boolean isCartItemExistForProduct{get;set;}
         boolean hasSameUser{get;set;}
         boolean shouldShowAllsubscription{get;set;}
       }
       
       /*----------------------------------------------------------------------------------
   WrapperClass ProductSpecification
   Description:Used for Composite products specification wrapper. 
   Sorting of Products based on sorting Value i.e. sequence at composite products
   ------------------------------------------------------------------------------------*/ 
   public class ProductSpecification implements Comparable{
       
       String displayBaseDiv{get;set;}
       String displayPlusDiv{get;set;}
       String displayProDiv{get;set;}
       Decimal sortVal{get;set;}
       String pro{get;set;}
       String plus{get;set;}
       String sku{get;set;}
       String base{get;set;}
       String specValue {get;set;}
       String specName{get;set;}
       String imageText{get;set;}
       String supportingText{get;set;}
       String unitOfMes{get;set;}
       String fluidVolReq{get;set;}
       public Integer compareTo(Object ObjToCompare) {
           ProductSpecification prodSpec = (ProductSpecification)(ObjToCompare);
           if (this.sortVal == prodSpec.sortVal) return 0;
           if (this.sortVal > prodSpec.sortVal) return 1;
           return -1; 
       }
       
   }
   
   }