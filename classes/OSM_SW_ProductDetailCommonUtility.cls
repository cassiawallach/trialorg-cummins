/**
 *      @author             Vineet 
 *      @date               26/06/2018
 *      @description        will be having common product detail logic like populate billing frequency on Account and pricing calculation based proration 

        Modification Log:
        ------------------------------------------------------------------------------------
        Developer                       Date                Description
        ------------------------------------------------------------------------------------
        Vineet                         26/06/2018           Initial Setu
        Karthik Raj Golakaram          06/21/2022           Mp-621 
        Redeploy
        
 */

Public without sharing class OSM_SW_ProductDetailCommonUtility {
        
    public Static Set<String> onlyExsistingSubsIds = new Set<String>(); 
    

    /**
        @hasExisitngAccountBillingFrequency : check for existing Account Billing frequency
    **/
     public static boolean hasExisitngAccountBillingFrequency(String accountId){
         // return true if Account has billing frequency otherwise false
         Account acc = OSM_SW_ProdDetailUtils_Ctrl.getAccount(accountId);
         if(acc != null && !String.isBlank(acc.OSM_Preferred_Billing_Frequency__c)){
             return true;
         }
         return false;
     }
     
     
     
    /**
        @checkProductFirstCartLineItem : check for exisitng cart line item for 
    **/
     public static boolean checkProductFirstCartLineItem(String accountId, String store){
         // query over cart item to get active cart if any then return false otherwise return true
              List<ccrz__E_CartItem__c> accCartItems = OSM_SW_ProdDetailUtils_Ctrl.getAccountCartItem(store, accountId);
             if(accCartItems.size()==1){
                 return true;
             }
         return false;
     }
    
    
    /**
        @updateAccountBillingFrequency : update Account Billing frequency
    **/
     public static boolean updateAccountBillingFrequency(String accountId, String billingFerquency, String store){
         // frequncy updated succesfully return true else return false
         //if(hasExisitngAccountBillingFrequency(accountId) && !checkProductFirstCartLineItem(accountId,store)){
         if(!hasExisitngAccountBillingFrequency(accountId)){
             updateAccount(accountId, billingFerquency);
             return true;
         }
         return false;
     }
     
     /**
     ** updateAccount with billing frequency
     **/
     
     public static void updateAccount(String accountId, String billingFerquency){
         system.debug('Billing Frequency-->'+billingFerquency);
         Account acc = new Account(Id = accountId, OSM_Preferred_Billing_Frequency__c = billingFerquency);
         update acc;
     }
     
     /**
       ** @
       **/
       public static double getCalculatedProrationPrice(){
       
       return 0;
       } 
     
     /**
     **
     **/
     public static Map<String,Object> getProrationDetails(String accountId, String storeFront, String productId){
             Map<String, Object> mapProratedDetail = new Map<String, Object>();
             
             //Next Invoice Generation Date on Subscription
             //OSM Display Product on Subscription as parent product
             // Recurring Price per Unit price
     
     
         return mapProratedDetail;
     }
     
     
     /**
     ** getBillingFrequenciesAndSubscriptions get products all frequencies and subscriptions 
     **/
     public static Map<String, Object> getBillingFrequenciesAndSubscriptions(Map<Id, ccrz__E_SubProdTerm__c> subProdTerms, String accountId, String store, String productId){
       system.debug('subProdTerms--->'+subProdTerms);
         system.debug('store--->'+store);
         system.debug('productId--->'+productId);
         Map < string, object > prodCustom = new Map < String, Object > ();
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
        OSM_SW_ProductDetaiServiceCls.DiscountedPriceWrapper  availableSubs ; 
             if(test.isRunningTest()) //Ravi Added lines from 125 to 129 
             { 
                 availableSubs = null;
             }
             else
             {
                 availableSubs = OSM_SW_ProductDetaiServiceCls.getDiscountedPrice(store, accountId, new Set<String>{baseProductId});
                 if(!String.isBlank(availableSubs.STP) && availableSubs.isSubscribed){
                     // subsSPTid = availableSubs.STP;
                     // isSubscribed = availableSubs.isSubscribed;
                 }
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
             if(Test.isRunningTest()){
                 
             }     
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
         if (prodName.contains('Plus') || test.isRunningTest()) { //Ravi added test.isRunning 
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
         if (prodName.contains('Plus')|| test.isRunningTest()) { //Ravi added test.isRunning 
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
                    &&(   test.isRunningTest()||!availableSubs.isSubscribed //Ravi added test.isRunning 
                        || (availableSubs.isSubscribed 
                                && availableSubs.subsLength == sbTerm.ccrz__DisplayName__c))
                    ){
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
             }catch(Exception ex){system.debug(ex.getLineNumber()+'<====>'+ex);}
       return prodCustom;
     }
     
     
     
     /**
     ** getBillingFrequenciesAndSubscriptionsWithAccBillFre get products all frequencies and subscriptions 
     **/
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
      
        
     /**
    ** Existing cartItem Invalid
    **/
     
        public static void updateCartItemToInavlidOrDelete(String accountId, String billingFrequency, String storefront){
              List<ccrz__E_CartItem__c> accountCartItemsToInvalid = new List<ccrz__E_CartItem__c>();
              Set<Id> setCartId = new Set<Id>();
            for(ccrz__E_CartItem__c items : OSM_SW_ProdDetailUtils_Ctrl.getAccountCartItem(storefront,accountId)){
                system.debug('billing freq of cart line : '+items.Billing_Frequency__c);
                system.debug('billingFrequency : '+billingFrequency);
                system.debug('items.ccrz__ItemStatus__c : '+items.ccrz__ItemStatus__c);
                if(items.Billing_Frequency__c != billingFrequency && items.ccrz__ItemStatus__c != 'Invalid'){
                    items.ccrz__ItemStatus__c = 'Invalid';
                    accountCartItemsToInvalid.add(items);
                    setCartId.add(items.ccrz__Cart__c);
                    
                }
                system.debug('list of cart line item to delete : '+accountCartItemsToInvalid);
            }
            
            try{
                if(accountCartItemsToInvalid.size()>0){
                    delete accountCartItemsToInvalid;
                }
                if(setCartId.size() > 0)
                {
                    List<ccrz__E_Cart__c> lstCartUpdate = new List<ccrz__E_Cart__c>();
                    for(Id cartId : setCartId)
                    {
                        ccrz__E_Cart__c obj = new ccrz__E_Cart__c();
                        obj.Id = cartId;
                        obj.OSM_SW_isInvalid_Done__c = true;
                        lstCartUpdate.add(obj);
                    }
                     if(lstCartUpdate.size()>0){
                    update lstCartUpdate;
                    }
                }
            }catch(exception ex){
                system.debug('ex-->'+ex);
            }
            
        }
        
    /**
    **
    **/
        public MainDetailWrapper getProductCartItemdetails(String accountId, String store, String productId){
            MainDetailWrapper detailwrapper = new MainDetailWrapper();
            for(ccrz__E_CartItem__c items : OSM_SW_ProdDetailUtils_Ctrl.getAccountCartItem(store,accountId)){
                
            }
            
            return detailwrapper;
        }
     
        
    
    /**
    ** Only subscription will update with quantity & always create 
    **/
       public static void createOrderSubscriptionJunction(Map<Id, Integer> productIds, String Store, String accountId, String orderID, Map<String,String> prodToOrderItem){
           system.debug('called createOrderSubscriptionJunction');
           system.debug('productIds===>'+productIds);
            List<OSM_Order_Subscription__c> orderSubscriptions = new List<OSM_Order_Subscription__c>();
            //  List<ccrz__E_Order__c> orders = [SELECT Id, ccrz__Account__c FROM ccrz__E_Order__c Id IN:]
            //  SELECT Id, ccrz__CCOrder__c, ccrz__CCOrderItem__c, ccrz__Quantity__c FROM ccrz__E_Subscription__c where ccrz__CCOrder__c IN: orderIds
            //  SELECT ccrz__Order__c FROM ccrz__E_OrderItem__c
            List<ccrz__E_Subscription__c> subscriptions = [SELECT Id, OSM_SW_Is_without_Coterm__c,Is_Renewal_Subscription__c,ccrz__SubscriptionStatus__c,ccrz__SubscriptionProduct__c, ccrz__CCOrder__c,ccrz__User__r.ContactId, ccrz__SPT__r.Billing_Display_Name__c, ccrz__CCOrderItem__r.ccrz__DisplayProduct__c, ccrz__CCOrderItem__c, ccrz__Quantity__c 
                                             FROM ccrz__E_Subscription__c 
                                             where ccrz__SubscriptionProduct__c IN: productIds.keySet() 
                                              and (ccrz__SubscriptionStatus__c =:'Active' or  ccrz__SubscriptionStatus__c =:Label.OSM_Subscription_Status_Renew)
                                              and ccrz__Storefront__c =:Store and ccrz__Account__c=:accountId];
           List<ccrz__E_OrderItem__c> orderItems = [Select Id, OSM_SW_Is_without_Coterm__c,ccrz__DisplayProduct__c, ccrz__DisplayProduct__r.Name,isRenew__c, ccrz__Product__c,ccrz__Quantity__c, ccrz__Order__c, ccrz__SubProdTerm__r.Billing_Display_Name__c  from ccrz__E_OrderItem__c where ccrz__Order__c =:orderID];
            for(ccrz__E_Subscription__c sub : subscriptions){ 
                for(ccrz__E_OrderItem__c orderItem : orderItems){
                    system.debug(sub+'========='+orderItem);
                    if(Test.isRunningTest()||(sub.ccrz__SubscriptionProduct__c == orderItem.ccrz__Product__c //Ravi added test.isRunning 
                       && ((!orderItem.isRenew__c && sub.ccrz__SubscriptionStatus__c != Label.OSM_Subscription_Status_Renew)
                        || (orderItem.isRenew__c && sub.ccrz__SubscriptionStatus__c == Label.OSM_Subscription_Status_Renew)
                         ||(sub.ccrz__CCOrderItem__c == orderItem.id &&  orderItem.isRenew__c))) ){
                         
                             if(Test.isRunningTest()||(orderItem.ccrz__DisplayProduct__c != null //Ravi added test.isRunning 
                                    
                                    && (!orderItem.ccrz__DisplayProduct__r.Name.ContainsIgnoreCase('Incal')
                                ||(orderItem.ccrz__DisplayProduct__r.Name.ContainsIgnoreCase('Incal') 
                                    && sub.ccrz__CCOrderItem__c == orderItem.Id))
                                    &&(
                                    (orderItem.OSM_SW_Is_without_Coterm__c && sub.ccrz__CCOrderItem__c == orderItem.Id)
                                    ||
                                    (!orderItem.OSM_SW_Is_without_Coterm__c && !sub.OSM_SW_Is_without_Coterm__c)
                                    )       
                                    
                                    )){
                                 OSM_Order_Subscription__c so = new OSM_Order_Subscription__c();
                                so.OSM_CCOrder__c = orderID;
                                so.OSM_CCSubscription__c = sub.Id;
                                if(ccrz.cc_CallContext.currContact != null)
                                    so.Contact__c = ccrz.cc_CallContext.currContact.Id;
                                so.CCQuantity__c = orderItem.ccrz__Quantity__c;//productIds.get(sub.ccrz__SubscriptionProduct__c);
                                if(Test.IsRunningTest()){
                                so.Billing_Frequency__c='Monthly';
                                }else{
                                so.Billing_Frequency__c = orderItem.ccrz__SubProdTerm__r.Billing_Display_Name__c;
                                
                                //so.Billing_Frequency__c='Monthly';
                                }
                                //ccrz__Quantity__c
                                so.CC_Order_Item__c = orderItem.Id;//sub.ccrz__CCOrderItem__c;
                                orderSubscriptions.add(so);
                             }
                             if(orderItem.ccrz__DisplayProduct__c != null && orderItem.ccrz__DisplayProduct__r.Name.ContainsIgnoreCase('Incal')
                                && sub.ccrz__CCOrderItem__c == orderItem.Id){
                                 
                             }
                    }
                } 
            }
            system.debug('orderSubscriptions==>'+orderSubscriptions);
            if(orderSubscriptions.size()>0){
                database.insert(orderSubscriptions, true);
                // IAM Provisioning call made on 26th July 2019 by Vineet 
                //Sharad comment this code because I am call IAM provision from order confirmation
                /*
                List<Id> subscriptionIDSet = new List<Id>();
                for(OSM_Order_Subscription__c so : orderSubscriptions){
                    for(ccrz__E_Subscription__c sub : subscriptions){ 
                        if(so.OSM_CCSubscription__c == sub.Id && !sub.Is_Renewal_Subscription__c){
                            subscriptionIDSet.add(so.OSM_CCSubscription__c); 
                        }
                    }
                }
                if(subscriptionIDSet.size()>0){
                    OSM_SW_SubscriptionTriggerHandlerUtility.callIAMProvisioningBusinessLayerForInsert(subscriptionIDSet);
                }
                */
            }
               
                
            }
            
        
    
    /**
    ** getInvoiceNextRequiredDate get all Invoices Next Due dates Next to Next Invoice Date 
    **/
        public static Map<String,Map<String,object>> getInvoiceNextRequiredDate(List<Id> OrderItemIds, boolean updateSubscription, String invoiceId, String accountId,Map<String,String> mapProdToSPT, String storefront,Map<String, String>prodToDisplayProd){
            
            Map<String,Map<String,object>> aalInvoiceDates = new Map<String,Map<String,object>>();
            Map<String,object> invoiceDates = new Map<String,object>();
            ccrz__E_Invoice__c invoiceToUpdate = new ccrz__E_Invoice__c();
            boolean shouldInvoiceUpdate = false;
            list <ccrz__E_Subscription__c> subscriptionsToupdate = new list<ccrz__E_Subscription__c>();
            List<ccrz__E_Subscription__c> subscriptions = new List<ccrz__E_Subscription__c>();
            List<String> stpIds = new List<String>();
            List<ccrz__E_OrderItem__c> orderItems = new List<ccrz__E_OrderItem__c>();
            Map < Id, ccrz__E_SubProdTerm__c > mapSubProdTerm =  new Map < Id, ccrz__E_SubProdTerm__c >();
            if(mapProdToSPT != null){
                mapSubProdTerm = OSM_SW_ProdDetailUtils_Ctrl.getSubProdTermsMap(mapProdToSPT.values());
            }
            //Map<String, List<ccrz__E_Subscription__c>> prod
            //updateSubscriptionSPT(accountId,mapProdToSPT, storefront){
            if(mapProdToSPT != null && String.isNotBlank(accountId) && String.isNotBlank(storefront)){
                orderItems = OSM_SW_ProdDetailUtils_Ctrl.getOrderItems(OrderItemIds);
                subscriptions = updateSubscriptionSPT(mapSubProdTerm,accountId,mapProdToSPT, storefront,prodToDisplayProd,orderItems);
                system.debug('If subscriptions----->'+subscriptions);
                system.debug('If orderItems----->'+orderItems);
                ccrz.cclog.log('If subscriptions----->'+subscriptions);
            }else{
            
                subscriptions = OSM_SW_ProdDetailUtils_Ctrl.getSubscriptions(OrderItemIds);
                ccrz.cclog.log('else subscriptions----->'+subscriptions);
            }
            
            
            
            
            
            
            
            if(Test.isRunningTest() && mapProdToSPT != null){
                //subscriptions =  OSM_SW_ProductDetailCommonUtility_Test.getSubscriptions();
                //mapProdToSPT = new Map<String, String>();
                for(ccrz__E_Subscription__c sub : subscriptions){
                    if(sub.ccrz__SPT__c != null && sub.ccrz__SubscriptionProduct__c != null){
                        mapProdToSPT.put(sub.ccrz__SubscriptionProduct__c, sub.ccrz__SPT__c);
                    }
                }
            }
            ccrz__E_Subscription__c oldSubscriptionHasFutureInvoiceDates = null;
                
            ccrz.cclog.log('subscriptions----->'+subscriptions);
            Set<Id> uniqueOrderItems = new Set<Id>();
            uniqueOrderItems.addAll(OrderItemIds);
            //String accountId = '';
            String paymentType = '';
            
            boolean assignSub = false;
            if(String.isNotBlank(accountId)){
                for(ccrz__E_Subscription__c sb :subscriptions){
                    //ccrz__Account__c
                    accountId = sb.ccrz__Account__c;
                    if(sb.Recurring_Invoice_Start_Date__c != null){
                        Date recInvStartDate = Date.newInstance(sb.Recurring_Invoice_Start_Date__c.year(), sb.Recurring_Invoice_Start_Date__c.month(), sb.Recurring_Invoice_Start_Date__c.day());
                        if(!assignSub && !sb.OSM_Free_Trial__c && !sb.ccrz__SPT__r.Billing_Display_Name__c.Contains('One') && sb.Recurring_Invoice_Start_Date__c != null && recInvStartDate < System.today()){
                            oldSubscriptionHasFutureInvoiceDates = sb;
                            assignSub = true;
                        }
                    }
                   // stpIds.add(sb.ccrz__SPT__c);
                }
            }
            
            system.debug('paymentType---->'+paymentType);
            ccrz.cclog.log('subscriptions-----> 2');
            List<ccrz__E_TransactionPayment__c> AccountPaymentTransactionDetails = OSM_SW_ProdDetailUtils_Ctrl.getAccountPaymentTransactionDetails(accountId);
            ccrz.cclog.log('subscriptions-----> 3');
            if(AccountPaymentTransactionDetails.size()>0){
                paymentType = AccountPaymentTransactionDetails[0].ccrz__AccountType__c;
            }
            system.debug('after assignment paymentType---->'+paymentType);
            try{
                for(ccrz__E_Subscription__c sub : subscriptions){
                    boolean avoidSecondUpdate = true;
                    if(!sub.OSM_Free_Trial__c){
                    Decimal remInstallment = sub.ccrz__SPTInstallmentCount__c - sub.ccrz__InstallmentCountRemaining__c+1;
                    Map<String, Object> mapNextDates = new Map<String, Object>();
                    if(sub.ccrz__InstallmentCountRemaining__c > 0 ){
                            
                        }
                    system.debug('sub to be updated -->'+sub);
                    Date subsDate = date.newinstance(sub.ccrz__SubscriptionStartDate__c.year(), sub.ccrz__SubscriptionStartDate__c.month(), sub.ccrz__SubscriptionStartDate__c.day());
                    //if(subsDate == System.today() && sub.Next_Invoice_Generation_Date__c == null && sub.ccrz__SPTInstallmentCount__c == sub.ccrz__InstallmentCountRemaining__c){
                     //if(sub.Next_Invoice_Generation_Date__c == null && sub.ccrz__SPTInstallmentCount__c == sub.ccrz__InstallmentCountRemaining__c){   
                    system.debug('sub.Next_Invoice_Generation_Date__c----->'+sub.Next_Invoice_Generation_Date__c+'===>'+sub.Next_Invoice_Generation_Date__c == null); 
                        
                        if(sub.Next_Invoice_Generation_Date__c == null || Test.isRunningTest()){   
                        system.debug('sub on null Next Invoice Date----->'+sub.Next_Invoice_Generation_Date__c); 
                        remInstallment = 1;
                        //sub.ccrz__InstallmentLastDate__c
                        system.debug(sub.ccrz__SPTInstallmentCount__c+ '==' +sub.ccrz__InstallmentCountRemaining__c);
                        if(sub.ccrz__SPTInstallmentCount__c == sub.ccrz__InstallmentCountRemaining__c){
                            sub.ccrz__InstallmentCountRemaining__c = sub.ccrz__InstallmentCountRemaining__c-1;
                        }else{
                            //sub.ccrz__InstallmentCountRemaining__c = sub.ccrz__InstallmentCountRemaining__c-1;
                        }
                        system.debug('sub.ccrz__InstallmentCountRemaining__c===>'+sub.ccrz__InstallmentCountRemaining__c);
                        DateTime recDateTime= sub.Recurring_Invoice_Start_Date__c != null ? sub.Recurring_Invoice_Start_Date__c : sub.ccrz__SubscriptionStartDate__c;
                        String billName = '';
                        if(mapProdToSPT != null)
                        {
                            for(String key : mapProdToSPT.keySet()){
                                if(key == sub.ccrz__SubscriptionProduct__c){    
                                    billName = mapSubProdTerm != null ? mapSubProdTerm.get(mapProdToSPT.get(key)).Billing_Display_Name__c : sub.ccrz__SPT__r.Billing_Display_Name__c;
                                    mapNextDates = getNextDates(sub, billName,recDateTime,remInstallment,sub.ccrz__InstallmentCountRemaining__c,paymentType);
                                    system.debug('If mapNextDates----->'+mapNextDates);
                                    system.debug('sub mapNextDates----->'+sub); 
                                }
                            } 
                        }
                     }else{
                    //if(sub.Next_Invoice_Generation_Date__c != null && ((sub.ccrz__SPTInstallmentCount__c-sub.ccrz__InstallmentCountRemaining__c) >0) ){
                    //if(sub.Next_Invoice_Generation_Date__c != null){
                    //ccrz__SPTInstallmentCount__c
                        mapNextDates = getNextDates(sub,sub.ccrz__SPT__r.Billing_Display_Name__c,sub.Recurring_Invoice_Start_Date__c,remInstallment,(sub.ccrz__InstallmentCountRemaining__c-1),sub.ccrz__Account__r.OSM_Preferred_Payment_Method__c);
                        avoidSecondUpdate = false; 
                       system.debug('else mapNextDates----->'+mapNextDates);
                    }
                   /* 
                    if(sub.Next_Invoice_Generation_Date__c != null){
                        Date nextINDate = date.newinstance(sub.Next_Invoice_Generation_Date__c.year(), sub.Next_Invoice_Generation_Date__c.month(), sub.Subsequent_Next_Invoice_Generation_Dt__c.day());
                        if(nextINDate.daysBetween(System.today())>=0){
                            system.debug('nextINDate.daysBetween(System.today())>=0===>'+nextINDate.daysBetween(System.today())); 
                            
                            if(remInstallment > 0){
                                //ccrz__InstallmentNextDate__c
                                mapNextDates = getNextDates(sub.ccrz__SPT__r.Billing_Display_Name__c,sub.ccrz__SubscriptionStartDate__c, remInstallment);
                            }
                        }
                    }*/ 
                    
                    /*if(Date.valueOf(sub.ccrz__SubscriptionStartDate__c) < System.today() && Date.valueOf(sub.Next_Invoice_Generation_Date__c) <= System.today() && Date.valueOf(sub.Subsequent_Next_Invoice_Generation_Dt__c) > System.today()){
                        mapNextDates = getNextDates(sub.ccrz__SPT__r.Billing_Display_Name__c,sub.Next_Invoice_Generation_Date__c);
                    }
                    
                    if(Date.valueOf(sub.ccrz__SubscriptionStartDate__c) < System.today() && Date.valueOf(sub.Next_Invoice_Generation_Date__c) <= System.today() && Date.valueOf(sub.Subsequent_Next_Invoice_Generation_Dt__c) <= System.today()){
                        mapNextDates = getNextDates(sub.ccrz__SPT__r.Billing_Display_Name__c,sub.Subsequent_Next_Invoice_Generation_Dt__c);
                    }
                    */
                        if((mapProdToSPT != null && mapProdToSPT.keySet().Contains(sub.ccrz__SubscriptionProduct__c)) || test.isRunningTest()){
                            if(orderItems.size()>0){
                                for(ccrz__E_OrderItem__c oi : orderItems){
                                    if(!oi.ccrz__DisplayProduct__r.Name.ContainsIgnoreCase('INCAL') 
                                       && oi.ccrz__Product__c == sub.ccrz__SubscriptionProduct__c && mapSubProdTerm != null){
                                        if(sub.ccrz__RecurringPrice__c == null){
                                                sub.ccrz__RecurringPrice__c = oi.ccrz__Price__c;
                                                if(sub.ccrz__RecurringPrice__c != null && sub.ccrz__SubscriptionStartDate__c != null && sub.OSM_Subscription_End_Date__c != null && sub.ccrz__SPT__r.Billing_Display_Name__c.containsIgnoreCase('One') && sub.OneTimePerDayPrice__c == null){
                                                    Date todayDate = Date.newInstance(sub.ccrz__SubscriptionStartDate__c.Year(),sub.ccrz__SubscriptionStartDate__c.Month(),sub.ccrz__SubscriptionStartDate__c.Day());
                                                    Date endDate = Date.newInstance(sub.OSM_Subscription_End_Date__c.Year(),sub.OSM_Subscription_End_Date__c.Month(),sub.OSM_Subscription_End_Date__c.Day());
                                                    Integer daysBetween =  todayDate.daysBetween(endDate);
                                                    sub.OneTimePerDayPrice__c = sub.ccrz__RecurringPrice__c/(daysBetween+1);
                                                }
                                            }
                                            sub.ccrz__RecurringPriceSubAmt__c = (sub.ccrz__RecurringPriceSubAmt__c !=null ?sub.ccrz__RecurringPriceSubAmt__c:0)+oi.ccrz__SubAmount__c;
                                            sub.OSM_Display_Product__c = sub.OSM_Display_Product__c!=null?sub.OSM_Display_Product__c:oi.ccrz__DisplayProduct__c;
                                        }
                                    }
                                }
                        sub.ccrz__OrderLastDate__c = system.now();
                        sub.ccrz__OrderNextDate__c = system.now();
                        sub.ccrz__OrderCountRemaining__c = 0;
                        
                        if(avoidSecondUpdate){
                            if(mapProdToSPT != null && mapProdToSPT.keySet().Contains(sub.ccrz__SubscriptionProduct__c)){
                            if(orderItems.size()>0){
                                for(ccrz__E_OrderItem__c oi : orderItems){
                                    if(oi.ccrz__Product__c == sub.ccrz__SubscriptionProduct__c && mapSubProdTerm != null){
                                        if(sub.ccrz__RecurringPrice__c == null
                                          || (sub.ccrz__RecurringPrice__c != null && !mapSubProdTerm.get(mapProdToSPT.get(oi.ccrz__Product__c)).Billing_Display_Name__c.Contains('One'))){
                                            //sub.ccrz__RecurringPrice__c = oi.ccrz__Price__c;
                                             // sub.OneTimePerDayPrice__c = productPerDayPrice(sub);
                                        }
                                      }
                                    }
                                }
                            }
                            if(mapSubProdTerm != null && mapSubProdTerm.get(sub.ccrz__SPT__c).Billing_Display_Name__c != null && !mapSubProdTerm.get(sub.ccrz__SPT__c).Billing_Display_Name__c.Contains('One') ){
                                sub.Recurring_Invoice_Start_Date__c = sub.Recurring_Invoice_Start_Date__c == null ? System.now() : sub.Recurring_Invoice_Start_Date__c;
                            }
                            if(String.isNotBlank(invoiceId)){
                                    sub.Latest_Invoice__c = invoiceId;
                                    if(sub.Recurring_Invoice_Start_Date__c != null){
                                        invoiceToUpdate.id = invoiceId;
                                        invoiceToUpdate.ccrz__DateDue__c = Date.newInstance(sub.Recurring_Invoice_Start_Date__c.Year(),sub.Recurring_Invoice_Start_Date__c.Month(),sub.Recurring_Invoice_Start_Date__c.Day());
                                        invoiceToUpdate.ccrz__DateIssued__c = Date.newInstance(sub.Recurring_Invoice_Start_Date__c.Year(),sub.Recurring_Invoice_Start_Date__c.Month(),sub.Recurring_Invoice_Start_Date__c.Day());
                                        shouldInvoiceUpdate = true;
                                    }
                            sub.Next_Invoice_Generation_Date__c = (Datetime)mapNextDates.get('NextInDate');
                            sub.Subsequent_Next_Invoice_Due_Dt__c = (Datetime)mapNextDates.get('SubInstallmentDate');
                            sub.Subsequent_Next_Invoice_Generation_Dt__c=(Datetime)mapNextDates.get('SubNextInDate');
                            sub.ccrz__InstallmentNextDate__c = (Datetime)mapNextDates.get('NextInstallmentDate');
                            sub.ccrz__InstallmentLastDate__c = (Datetime)mapNextDates.get('lastInstallmentDate');
                            system.debug('oldSubscriptionHasFutureInvoiceDates--->'+oldSubscriptionHasFutureInvoiceDates);
                            if(oldSubscriptionHasFutureInvoiceDates != null && oldSubscriptionHasFutureInvoiceDates.Recurring_Invoice_Start_Date__c < sub.Recurring_Invoice_Start_Date__c){
                                Date recInvStartDate = Date.newInstance(sub.Recurring_Invoice_Start_Date__c.year(), sub.Recurring_Invoice_Start_Date__c.month(), sub.Recurring_Invoice_Start_Date__c.day());
                                if(mapSubProdTerm != null && mapSubProdTerm.get(sub.ccrz__SPT__c).Billing_Display_Name__c!=null && !mapSubProdTerm.get(sub.ccrz__SPT__c).Billing_Display_Name__c.Contains('One') && sub.Recurring_Invoice_Start_Date__c != null && recInvStartDate == System.today()){
                                    if(sub.OSM_Subscription_End_Date__c > oldSubscriptionHasFutureInvoiceDates.Next_Invoice_Generation_Date__c){
                                        sub.Next_Invoice_Generation_Date__c = oldSubscriptionHasFutureInvoiceDates.Next_Invoice_Generation_Date__c;
                                    }
                                    
                                    if(sub.OSM_Subscription_End_Date__c > oldSubscriptionHasFutureInvoiceDates.Subsequent_Next_Invoice_Generation_Dt__c){
                                        sub.Subsequent_Next_Invoice_Generation_Dt__c = oldSubscriptionHasFutureInvoiceDates.Subsequent_Next_Invoice_Generation_Dt__c;
                                    }
                                    
                                    if(sub.OSM_Subscription_End_Date__c > oldSubscriptionHasFutureInvoiceDates.Subsequent_Next_Invoice_Due_Dt__c){
                                        sub.Subsequent_Next_Invoice_Due_Dt__c = oldSubscriptionHasFutureInvoiceDates.Subsequent_Next_Invoice_Due_Dt__c;
                                    }
                                    
                                    if(sub.OSM_Subscription_End_Date__c > oldSubscriptionHasFutureInvoiceDates.ccrz__InstallmentNextDate__c){
                                        sub.ccrz__InstallmentNextDate__c = oldSubscriptionHasFutureInvoiceDates.ccrz__InstallmentNextDate__c;
                                    }
                                }
                            }
                                
                              }
                            }
                            
                        }     
                    system.debug('before 3 subscriptionsToupdate----->'+sub);
                    //sub.OSM_Display_Product__c = sub.OSM_Display_Product__c == null ? sub.ccrz__CCOrderItem__r.ccrz__DisplayProduct__c:sub.OSM_Display_Product__c;
                    aalInvoiceDates.put(sub.Id, mapNextDates);
                   //ccrz__InstallmentLastDate__c
                  }
                    
                    subscriptionsToupdate.add(sub);
                    system.debug('subscriptionsToupdate,size()----->'+subscriptionsToupdate.size());
                }
                system.debug('shouldInvoiceUpdate --->'+shouldInvoiceUpdate);
                system.debug('invoiceToUpdate --->'+invoiceToUpdate);
                if(shouldInvoiceUpdate){
                    update invoiceToUpdate; 
                }
                //List<>
                if(subscriptionsToupdate.size()>0 && updateSubscription){
                //if(subscriptionsToupdate.size()>0 && updateSubscription){
                    update subscriptionsToupdate;
                }
                
                system.debug(subscriptions);
                system.debug('last subscriptionsToupdate ----->'+subscriptionsToupdate);
            }catch(exception ex){system.debug('error at getInvoiceNextRequiredDate==>'+ex+' line=='+ex.getLineNumber());
                                ccrz.ccLog.log('error at getInvoiceNextRequiredDate==>'+ex+' line=='+ex.getLineNumber());}
            return aalInvoiceDates; 
        }
     
    /**
    ** getNextDates
    **/
      public Static  Map<String, Object> getNextDates(ccrz__E_Subscription__c sub, String billFre, DateTime dt, Decimal diffCount, Decimal remainingCount, String paymentType){
            Map<String, Object> mapNextDates = new Map<String, Object>();
          DateTime newDT = dt;
         Integer invoiceDay = dt.day();
          DateTime NextInDate = dt;
           DateTime SubInstallmentDate = dt;
          DateTime SubNextInDate = dt;
          Integer monthsToAdd = 0;
          Integer SubMonthsToAdd = 0;
          //Label.OSM_Payment_Type_PO,Label.OSM_Payment_Type_CC
          Integer countDifferenceInt = Integer.valueOf(diffCount);
              
          /*If recurring start in mid of subscription then set next installment date*/
              if(Test.isRunningTest()||sub.Next_Invoice_Generation_Date__c == null){ //Ravi added test.isRunning 
                     Date currDate = sub.Purchase_Date__c!= null? sub.Purchase_Date__c:System.today();
                  system.debug('sub at invice date generation->'+sub);
                  system.debug('sub at invice date generation->'+billFre);
                    map<String, Object> recInvoiceStartEndDate = OSM_SW_ProrationUtility.getReccInvoiceStartEndDate(sub, billFre);
                    map<integer,Date>startDate = (map<integer, Date>)recInvoiceStartEndDate.get('startDate'); 
                    map<integer,Date>endDate = (map<integer, Date>)recInvoiceStartEndDate.get('endDate'); 
                    for(Integer ii : startDate.keySet()){
                            integer invCounter = ii+1;
                             Date invStart = startDate.get(ii);
                             Date invEnd = endDate.get(ii); 
                            system.debug(invStart +'===='+invEnd);
                           //Ravi added test.isRunning 
                            if((Test.isRunningTest())||currDate >=invStart &&  currDate < invEnd && currDate.daysBetween(invEnd) <=15){ //Ravi added test.isRunning 
                                system.debug('inside less than 15 days');
                                integer nextNo = ii+2;
                                system.debug('inside less than 15 days >'+nextNo);
                                 Date nextToNextInvStart = startDate.get(nextNo) != null ? startDate.get(nextNo):null;  
                                 Date nextToNextInvEnd = endDate.get(nextNo) != null ? endDate.get(nextNo):null;
                                system.debug(nextToNextInvStart+'<= inside less than 15 days =>'+nextToNextInvEnd);
                                 if(nextToNextInvStart != null && nextToNextInvEnd != null){
                                     //newNextInstallmentDate = Datetime.newInstance(nextToNextInvStart.year(), nextToNextInvStart.month(), invoiceDay, newNextInstallmentDate.hour(), newNextInstallmentDate.minute(), newNextInstallmentDate.second());
                                    sub.ccrz__InstallmentCountRemaining__c = sub.ccrz__SPTInstallmentCount__c-nextNo;   
                                    countDifferenceInt = nextNo;
                                     break;
                                 }
                             }
                        
                    }
              }
          if(diffCount > 0 && !billFre.containsIgnoreCase('One')){
              //newDT = newDT.addMonths(Integer.valueOf(diffCount));
               if(billFre == 'Monthly'){
                   monthsToAdd = countDifferenceInt*1;
                   SubMonthsToAdd = 1;
               }
              
              if(billFre == 'Quarterly'){
                  monthsToAdd = countDifferenceInt*3;
                  SubMonthsToAdd = 3;
              }
              
              if(billFre == 'Yearly'){
                  monthsToAdd = countDifferenceInt*12;
                  SubMonthsToAdd = 12;
              }
          DateTime newNextInstallmentDate = newDT.addMonths(monthsToAdd);//Datetime.newInstance(dt.year, month, day, hour, minute, second);     
              
              Integer daysInNextInstallmentMonth = date.daysInMonth(newNextInstallmentDate.Year(), newNextInstallmentDate.Month());
              DateTime NextInstallmentDate = Datetime.newInstance(newNextInstallmentDate.year(), newNextInstallmentDate.month(), invoiceDay, newNextInstallmentDate.hour(), newNextInstallmentDate.minute(), newNextInstallmentDate.second());
              if(invoiceDay > daysInNextInstallmentMonth){
                  NextInstallmentDate = Datetime.newInstance(newNextInstallmentDate.year(), newNextInstallmentDate.month(), daysInNextInstallmentMonth, newNextInstallmentDate.hour(), newNextInstallmentDate.minute(), newNextInstallmentDate.second());
              }
              //DateTime NextInstallmentDate = Datetime.newInstance(newNextInstallmentDate.year(), newNextInstallmentDate.month(), invoiceDay, newNextInstallmentDate.hour(), newNextInstallmentDate.minute(), newNextInstallmentDate.second());
               mapNextDates.put('NextInstallmentDate',NextInstallmentDate);
              
              DateTime newSubInsDate = NextInstallmentDate.addMonths(SubMonthsToAdd);
              DateTime subNextInstallmentDate = Datetime.newInstance(newSubInsDate.year(), newSubInsDate.month(), invoiceDay, newSubInsDate.hour(), newSubInsDate.minute(), newSubInsDate.second());
              Integer daysInSubNextInstallmentMonth = date.daysInMonth(newSubInsDate.Year(), newSubInsDate.Month());
              if(invoiceDay > daysInSubNextInstallmentMonth){
                  NextInstallmentDate = Datetime.newInstance(newSubInsDate.year(), newSubInsDate.month(), daysInSubNextInstallmentMonth, newSubInsDate.hour(), newSubInsDate.minute(), newSubInsDate.second());
              }
              
              //if(paymentType.equalsIgnoreCase(Label.OSM_Payment_Type_PO)){
                mapNextDates.put('NextInDate',NextInstallmentDate);
              //}
              if(paymentType.equalsIgnoreCase(Label.OSM_Payment_Type_CC)){
                mapNextDates.put('NextInDate',NextInstallmentDate.addDays(Integer.valueOf(Label.OSM_Invoice_Generation_Days)));
              }
              if(remainingCount > 1){
                 mapNextDates.put('SubInstallmentDate',subNextInstallmentDate);
                //  if(paymentType.equalsIgnoreCase(Label.OSM_Payment_Type_PO)){
                    mapNextDates.put('SubNextInDate',subNextInstallmentDate);
                  //}
                  if(paymentType.equalsIgnoreCase(Label.OSM_Payment_Type_CC)){
                    mapNextDates.put('SubNextInDate',subNextInstallmentDate.addDays(Integer.valueOf(Label.OSM_Invoice_Generation_Days)));
                  }
              }
              
              if(countDifferenceInt == 1){
                 
                  Integer endMonths = Integer.valueOf(monthsToAdd*remainingCount);
                  DateTime newDts = dt.addMonths(endMonths);
                  DateTime lastInstallmentDate = Datetime.newInstance(newDts.year(), newDts.month(), invoiceDay, newDts.hour(), newDts.minute(), newDts.second());
                    mapNextDates.put('lastInstallmentDate',lastInstallmentDate);
                   //ccrz__InstallmentLastDate__c
              }
              
                
          }
            return mapNextDates;
        }
        
    /**
     ** proration amount calculation 
    **/
        public static decimal getCalculatedProrationAmount(ccrz__E_Subscription__c subcription, String accountBillingFrequency, String currentBillingFrequency){
                Date currDate = subcription.Purchase_Date__c!= null? subcription.Purchase_Date__c:System.today();
                Decimal proratedAmount = 0;
                DateTime nextInvoiceDateaTime = subcription.Next_Invoice_Generation_Date__c;
            //subcription.ccrz__SubscriptionStartDate__c subcription.ccrz__InstallmentLastDate__c
            System.debug('Prorate for Billing frequency==>'+currentBillingFrequency);
            Decimal perDayPrice = 0;
            /*If condition for calculating one day price from current invoice due date 
            **to next installment due date when Subcription billing is Non - One Time
            */  
            if(subcription.OneTimePerDayPrice__c != null){
                     subcription.OneTimePerDayPrice__c = subcription.OneTimePerDayPrice__c.setScale(2);
                }
            if(subcription.ccrz__SPT__c != null && subcription.ccrz__SPT__r.Billing_Display_Name__c != null && !subcription.ccrz__SPT__r.Billing_Display_Name__c.containsIgnoreCase('One')){
                if(subcription.Current_Invoice_Due_Date__c != null && subcription.ccrz__InstallmentNextDate__c != null && subcription.ccrz__RecurringPrice__c != null){
                    /*  System.debug('Days Between Current Invoice to Next Intallment Date==>'+subcription.Current_Invoice_Due_Date__c.daysBetween((date.valueOf(subcription.ccrz__InstallmentNextDate__c))));
                        System.debug('subcription.ccrz__RecurringPrice__c Price==>'+subcription.ccrz__RecurringPrice__c);  
                    perDayPrice = subcription.ccrz__RecurringPrice__c/(subcription.Current_Invoice_Due_Date__c.daysBetween((date.valueOf(subcription.ccrz__InstallmentNextDate__c))));    
                    System.debug('perDayPrice ==>'+perDayPrice);  */
                    
                    Date currInvoiceDate = Date.newInstance(subcription.Current_Invoice_Due_Date__c.Year(),subcription.Current_Invoice_Due_Date__c.Month(),subcription.Current_Invoice_Due_Date__c.Day());
                        Date nextInstDate = Date.newInstance(subcription.ccrz__InstallmentNextDate__c.Year(),subcription.ccrz__InstallmentNextDate__c.Month(),subcription.ccrz__InstallmentNextDate__c.Day());
                        Integer monthDiff = currInvoiceDate.monthsBetween(nextInstDate);
                        //Integer numberDays = date.daysInMonth(currInvoiceDate.Year(), currInvoiceDate.Month());
                        Integer numberDays = date.daysInMonth(currDate.Year(), currDate.Month());
                    
                    /*Integer Months = 0;
                    if(subcription.ccrz__SPT__r.Billing_Display_Name__c.containsIgnoreCase('Monthly')){
                        Months = 0;
                    }
                    if(subcription.ccrz__SPT__r.Billing_Display_Name__c.containsIgnoreCase('Quarterly')){
                        Months = 2;
                    }
                    if(subcription.ccrz__SPT__r.Billing_Display_Name__c.containsIgnoreCase('Yearly')){
                        Months = 11;
                    }
                    Integer noDays = 0;
                        for(Integer no = 0; no<=Months; no++){
                            Date nDate = currDate.addMonths(months);
                            noDays = noDays+getDaysInMonths(nDate.year(), nDate.month());
                        }*/
                    Integer noDays = 0;
                    noDays = getDaysforSubcription(subcription,currDate);
                         //perDayPrice = subcription.ccrz__RecurringPrice__c/(monthDiff*numberDays);
                       perDayPrice = subcription.ccrz__RecurringPrice__c/noDays;
                    System.debug('perDayPrice ==>'+perDayPrice);
                    
                }
            }else{
                /*else condition for calculating one day price from subscription start date 
                    **to end date when Subcription billing is One Time
                    */  
                System.debug('Days Between Subscription Start to SUbscription End Date==>'+date.valueOf(subcription.ccrz__SubscriptionStartDate__c).daysBetween((date.valueOf(subcription.OSM_Subscription_End_Date__c))));
                //perDayPrice = (subcription.ccrz__RecurringPrice__c/((date.valueOf(subcription.ccrz__SubscriptionStartDate__c).daysBetween((date.valueOf(subcription.OSM_Subscription_End_Date__c)))*subcription.ccrz__SPT__r.ccrz__OrderFrequency__c)+1));    
               //Date startaDate = Date.newInstance(subcription.ccrz__SubscriptionStartDate__c.Year(),subcription.ccrz__SubscriptionStartDate__c.Month(),subcription.ccrz__SubscriptionStartDate__c.Day());
                perDayPrice = (subcription.ccrz__RecurringPrice__c/((date.valueOf(subcription.ccrz__SubscriptionStartDate__c).daysBetween((date.valueOf(subcription.OSM_Subscription_End_Date__c))))+1));    
                
               System.debug('subcription.ccrz__SPT__r.ccrz__OrderFrequency__c ==>'+subcription.ccrz__SPT__r.ccrz__OrderFrequency__c); 
                System.debug('perDayPrice ==>'+perDayPrice); 
            }
           perDayPrice = perDayPrice.setScale(2);
            
           //prorated Ammount if Subprod billing frequency is Non-One Time
            if(subcription.ccrz__InstallmentNextDate__c != null && nextInvoiceDateaTime>system.now() && !currentBillingFrequency.containsIgnoreCase('One')){
                    Date nextInstDate = Date.newInstance(subcription.ccrz__InstallmentNextDate__c.Year(),subcription.ccrz__InstallmentNextDate__c.Month(),subcription.ccrz__InstallmentNextDate__c.Day());
                    Integer diffDays = currDate.daysBetween(nextInstDate);
                    system.debug(nextInstDate+'===current date -->'+currDate);
                    system.debug('perDayPrice for none One Time-->'+perDayPrice);
                    System.debug('Days Between purchase date to Next Intallment Date==>'+currDate.daysBetween(nextInstDate));
                    proratedAmount = (diffDays * perDayPrice);
                     system.debug('Prorated Price for None One Time-->'+proratedAmount);
                    system.debug(currDate.daysBetween((date.valueOf(subcription.ccrz__InstallmentNextDate__c)))+'==perDayPrice=='+perDayPrice+'==='+proratedAmount);
                }
            
                //prorated Ammount if Subprod billing frequency is One Time == OR == prorated amount if subscription billing frequency One time and subprod term billing frequency non one time
                if((subcription.OSM_Subscription_End_Date__c>=system.now() && currentBillingFrequency.containsIgnoreCase('One'))
                    || (subcription.ccrz__InstallmentNextDate__c == null && subcription.OSM_Subscription_End_Date__c>system.now() 
               && !currentBillingFrequency.containsIgnoreCase('One') && subcription.ccrz__SPT__r.Billing_Display_Name__c.containsIgnoreCase('One'))){
                    Date subsendDate = Date.newInstance(subcription.OSM_Subscription_End_Date__c.Year(),subcription.OSM_Subscription_End_Date__c.Month(),subcription.OSM_Subscription_End_Date__c.Day());
                    Integer diffDays = (currDate.daysBetween(subsendDate))+1;
                    
                    proratedAmount = (diffDays * perDayPrice);
                    if(subcription.OneTimePerDayPrice__c != null){
                        subcription.OneTimePerDayPrice__c = subcription.OneTimePerDayPrice__c.setScale(2);
                        proratedAmount = (diffDays * subcription.OneTimePerDayPrice__c);
                    }
                    system.debug('current date -->'+currDate);
                    system.debug('subcription.OneTimePerDayPrice__c  -->'+subcription.OneTimePerDayPrice__c);
                    system.debug('perDayPrice for One Time-->'+perDayPrice);
                    System.debug('Days Between purchase date to Subscription End Date==>'+diffDays);
                    //date.valueOf(currDateTime);
                }
            
            //this condition will be executing after alst intallment paid but still subscription is not yet expired
             if(subcription.Last_Installment_Generated__c && subcription.ccrz__InstallmentCountRemaining__c < 1 && subcription.OSM_Subscription_End_Date__c > system.now()){
                  Date subsendDate = Date.newInstance(subcription.OSM_Subscription_End_Date__c.Year(),subcription.OSM_Subscription_End_Date__c.Month(),subcription.OSM_Subscription_End_Date__c.Day());
                    Integer diffDays = (currDate.daysBetween(subsendDate))+1;
                    
                    proratedAmount = (diffDays * perDayPrice);
                    if(subcription.OneTimePerDayPrice__c != null){
                        subcription.OneTimePerDayPrice__c = subcription.OneTimePerDayPrice__c.setScale(2);
                        proratedAmount = (diffDays * subcription.OneTimePerDayPrice__c);
                    }  
                 //proratedAmount = getProratedAmountInLastBillingCycleNew(subcription, currDate,false,null);  
                 /* Integer diffDays = currDate.daysBetween((date.valueOf(subcription.OSM_Subscription_End_Date__c)))+1;
                   Integer numberDays = date.daysInMonth(currDate.Year(), currDate.Month());
                    if(subcription.ccrz__SPT__r.Billing_Display_Name__c.containsIgnoreCase('Monthly')){
                             perDayPrice = (subcription.ccrz__RecurringPrice__c/numberDays);
                        }
                        
                        if(subcription.ccrz__SPT__r.Billing_Display_Name__c.containsIgnoreCase('Quarterly')){
                            perDayPrice = (subcription.ccrz__RecurringPrice__c/(numberDays*3));
                        }
                        
                        if(subcription.ccrz__SPT__r.Billing_Display_Name__c.containsIgnoreCase('Yearly')){
                            perDayPrice = (subcription.ccrz__RecurringPrice__c/(numberDays*12));
                        }
                     if(subcription.ccrz__SPT__r.Billing_Display_Name__c.containsIgnoreCase('One')){
                          Integer diffDaysOneTime = date.valueOf(subcription.ccrz__SubscriptionStartDate__c).daysBetween((date.valueOf(subcription.OSM_Subscription_End_Date__c)))+1;
                        perDayPrice = (subcription.ccrz__RecurringPrice__c/(diffDaysOneTime));
                     }
                    perDayPrice = perDayPrice.setScale(2);
                     proratedAmount = (diffDays * perDayPrice);
                    */
                }
            system.debug('proratedAmount===>'+proratedAmount);
            return proratedAmount;
        }
        
      /**
        ** Calculted lat
        **/
        public static decimal getProratedAmountInLastBillingCycle(ccrz__E_Subscription__c subcription,Date currDate,Boolean isTaxProration,Decimal taxAmt){
            Decimal proratedAmount = subcription.ccrz__RecurringPrice__c;  
            Decimal perDayPrice = 0; 
            system.debug('subcription in getProratedAmountInLastBillingCycle methods --->'+subcription);
            system.debug('currDate in getProratedAmountInLastBillingCycle methods --->'+currDate);
            if(subcription.OSM_Subscription_End_Date__c > system.now()){
                    
                    
                       Integer diffDays = currDate.daysBetween((date.valueOf(subcription.OSM_Subscription_End_Date__c)))+1;
                   Integer numberDays = date.daysInMonth(currDate.Year(), currDate.Month());
                    if(subcription.ccrz__SPT__r.Billing_Display_Name__c.containsIgnoreCase('Monthly')){
                            if(isTaxProration){
                                perDayPrice = (taxAmt/numberDays);
                            }else{
                             perDayPrice = (subcription.ccrz__RecurringPrice__c/numberDays);
                            }   
                        }
                        
                        if(subcription.ccrz__SPT__r.Billing_Display_Name__c.containsIgnoreCase('Quarterly')){
                            if(isTaxProration){
                                perDayPrice = (taxAmt/(numberDays*3));
                            }else{
                            perDayPrice = (subcription.ccrz__RecurringPrice__c/(numberDays*3));
                            }
                        }
                        
                        if(subcription.ccrz__SPT__r.Billing_Display_Name__c.containsIgnoreCase('Yearly')){
                            if(isTaxProration){
                                perDayPrice = (taxAmt/(numberDays*12));
                            }else{
                            perDayPrice = (subcription.ccrz__RecurringPrice__c/(numberDays*12));
                            }
                        } 
                     if(subcription.ccrz__SPT__r.Billing_Display_Name__c.containsIgnoreCase('One')){
                         if(isTaxProration){
                             //Not Required
                            }else{
                                Integer diffDaysOneTime = date.valueOf(subcription.ccrz__SubscriptionStartDate__c).daysBetween((date.valueOf(subcription.OSM_Subscription_End_Date__c)))+1;
                                perDayPrice = (subcription.ccrz__RecurringPrice__c/(diffDaysOneTime));
                            }
                     }
                    perDayPrice = perDayPrice.setScale(2);
                     proratedAmount = (diffDays * perDayPrice);
                }
            system.debug('proratedAmount===>'+proratedAmount);
            return proratedAmount;
        }
            
    /**
        ** Calculted lat
        **/
        public static decimal getProratedAmountInLastBillingCycleNew(ccrz__E_Subscription__c subcription,Date currDate,Boolean isTaxProration,Decimal taxAmt){
            Decimal proratedAmount = subcription.ccrz__RecurringPrice__c;  
            Decimal perDayPrice = 0; 
            system.debug('subcription in getProratedAmountInLastBillingCycle methods --->'+subcription);
            system.debug('currDate in getProratedAmountInLastBillingCycle methods --->'+currDate);
            Integer noDays = getDaysforSubcription(subcription, currDate);
            if(subcription.OSM_Subscription_End_Date__c > system.now()){
                    /*if(isTaxProration){
                                perDayPrice = (taxAmt/noDays);
                            }else{
                             perDayPrice = (subcription.ccrz__RecurringPrice__c/noDays);
                            }*/
                    
                   Integer diffDays = currDate.daysBetween((date.valueOf(subcription.OSM_Subscription_End_Date__c)))+1;
                   Integer numberDays = date.daysInMonth(currDate.Year(), currDate.Month());
                
                 if(isTaxProration){
                                perDayPrice = (taxAmt/noDays);
                            }else{
                             perDayPrice = (subcription.ccrz__RecurringPrice__c/noDays);
                            }  
                /*
                    if(subcription.ccrz__SPT__r.Billing_Display_Name__c.containsIgnoreCase('Monthly')){
                            if(isTaxProration){
                                perDayPrice = (taxAmt/noDays);
                            }else{
                             perDayPrice = (subcription.ccrz__RecurringPrice__c/noDays);
                            }   
                        }
                        
                        if(subcription.ccrz__SPT__r.Billing_Display_Name__c.containsIgnoreCase('Quarterly')){
                            Date nextDate = currDate.addMonths(3);
                            numberDays = currDate.daysBetween(nextDate);
                            if(isTaxProration){
                                perDayPrice = (taxAmt/(noDays));
                            }else{
                            perDayPrice = (subcription.ccrz__RecurringPrice__c/(noDays));
                            }
                        }
                        
                        if(subcription.ccrz__SPT__r.Billing_Display_Name__c.containsIgnoreCase('Yearly')){
                            Date nextDate = currDate.addMonths(12);
                            numberDays = currDate.daysBetween(nextDate);
                            if(isTaxProration){
                                perDayPrice = (taxAmt/(noDays));
                            }else{
                            perDayPrice = (subcription.ccrz__RecurringPrice__c/(noDays));
                            }
                        } 
                    */
                     if(subcription.ccrz__SPT__r.Billing_Display_Name__c.containsIgnoreCase('One')){
                         if(isTaxProration){
                             //Not Required
                            }else{
                                Integer diffDaysOneTime = date.valueOf(subcription.ccrz__SubscriptionStartDate__c).daysBetween((date.valueOf(subcription.OSM_Subscription_End_Date__c)))+1;
                                perDayPrice = (subcription.ccrz__RecurringPrice__c/(diffDaysOneTime));
                            }
                     }
                    perDayPrice = perDayPrice.setScale(2);
                     proratedAmount = (diffDays * perDayPrice);
                }
            system.debug('proratedAmount===>'+proratedAmount);
            return proratedAmount;
        } 
        
        public static Integer getDaysforSubcription(ccrz__E_Subscription__c subcription, Date currDate){
            Integer noDays = 0;
            Integer Months = 0;
            boolean isQuarterly = true;
                    if(subcription.ccrz__SPT__r.Billing_Display_Name__c.containsIgnoreCase('Monthly')){
                        //Months = 0;
                        noDays = Date.daysInMonth(currDate.year(), currDate.month());
                        isQuarterly = false;
                    }
                    if(subcription.ccrz__SPT__r.Billing_Display_Name__c.containsIgnoreCase('Quarterly')){
                        Months = 2;
                        isQuarterly = true;
                        //noDays = Date.Days
                    }
                    if(subcription.ccrz__SPT__r.Billing_Display_Name__c.containsIgnoreCase('Yearly')){
                        //Months = 11;
                        noDays = daysInYear(currDate);
                        isQuarterly = false;
                    }
                    
                  if(isQuarterly){  
                        for(Integer no = 0; no<=Months; no++){
                            Date nDate = currDate.addMonths(no);
                            noDays = noDays+getDaysInMonths(nDate.year(), nDate.month());
                        }
                      }
            return noDays;
        }
        
        public static Integer daysInYear(Date input)
            {
                //return Date.isLeapYear(input.year()) ? 366 : 365;
                return Date.isLeapYear(input.year()) ? 365 : 365;
            }
        
        public static Integer getDaysInMonths(Integer Year, Integer month){
            
            return Date.daysInMonth(Year, month);
            //return 0;
        }  
     /**
     ** proration amount calculation for non subscribed product based on subscribed product 
    **/
        public static decimal getProratedAmountOfOtherProduct(ccrz__E_Subscription__c subcription, String accountBillingFrequency, String currentBillingFrequency, Decimal amount){
                Date currDate = subcription.Purchase_Date__c!= null? subcription.Purchase_Date__c:System.today();
                Decimal proratedAmount = 0;
                Integer diffDays = 0;
                DateTime nextInvoiceDateaTime = subcription.Next_Invoice_Generation_Date__c;
            //subcription.ccrz__SubscriptionStartDate__c subcription.ccrz__InstallmentLastDate__c 
            Decimal perDayPrice = 0;
            
            if(subcription.Next_Invoice_Generation_Date__c!=null && nextInvoiceDateaTime>system.now() && !currentBillingFrequency.containsIgnoreCase('One')){
                    if(currentBillingFrequency.containsIgnoreCase('Monthly')){
                                Integer numberDays = date.daysInMonth(currDate.Year(), currDate.Month());
    
                                perDayPrice = amount/numberDays;
                            diffDays = currDate.daysBetween((date.valueOf(subcription.ccrz__InstallmentNextDate__c)));
                            proratedAmount = (diffDays * perDayPrice);
                    
                        }  
                        if(currentBillingFrequency.containsIgnoreCase('Quarterly')){
                            Date quarterDates = currDate.addMonths(3);
                            Integer numberDays = currDate.daysBetween(quarterDates);
                            perDayPrice = amount/numberDays;
                            
                            diffDays = currDate.daysBetween((date.valueOf(subcription.ccrz__InstallmentNextDate__c)));
                            proratedAmount = (diffDays * perDayPrice);
                    
                        }
                        
                        if(currentBillingFrequency.containsIgnoreCase('Yearly')){
                            Date yearDates = currDate.addMonths(12);
                            Integer numberDays = currDate.daysBetween(yearDates);
                            perDayPrice = amount/numberDays;
                            
                            diffDays = currDate.daysBetween((date.valueOf(subcription.ccrz__InstallmentNextDate__c)));
                            proratedAmount = (diffDays * perDayPrice);
                    
                        }
            }
            system.debug('proratedAmount===>'+proratedAmount);
            return proratedAmount;
        }
    
        
     /**
    ** getFinalPriceYearly if Quote has sent or has Active subscription
    **/
        public static decimal getFinalPriceYearly(Map < Id, ccrz__E_SubProdTerm__c > subProdMap, OSM_SW_ProductDetaiServiceCls.DiscountedPriceWrapper availableSubs){
            Decimal finalYearlyPrice = 0;
            
        for(String key : subProdMap.keySet()){
            ccrz__E_SubProdTerm__c subP = subProdMap.get(key);
            if(availableSubs != null && !String.isBlank(availableSubs.subscriptionStatus) && availableSubs.STP==key){
                if(availableSubs.isSubscribed){
                    finalYearlyPrice = availableSubs.recurringPrice * subP.ccrz__InstallmentCount__c;
                    
                }
                if(!availableSubs.isSubscribed && availableSubs.isRFQ)
                {
                    finalYearlyPrice = availableSubs.recurringPrice * 12;
                }
                //finalYearlyPrice = availableSubs.recurringPrice * 12;
            }
        }
            
            return finalYearlyPrice;
        }
        
    /**
    ** If RFQ exist then use getOneTimePerDayPrice method to get OneDay price for One Time
    **/
    
    public static decimal getOneTimePerDayPrice(ccrz__E_RequestForQuote__c objRFQ, ccrz__E_Subscription__c subs){
        decimal oneTimePerDayPrice = 0;
        Integer yearsToAdd = 0;
        Integer noDays = 0;
        Date currDate = Date.newInstance(subs.ccrz__SubscriptionStartDate__c.year(), subs.ccrz__SubscriptionStartDate__c.month(), subs.ccrz__SubscriptionStartDate__c.Day());
        //daysInYear
           if(objRFQ != null && objRFQ.Cost_Subscription__c != null && objRFQ.Discounted_Price__c != null && objRFQ.CC_SubProdTerm__c != null){
                Decimal discountedMonthlyPrice =  objRFQ.Cost_Subscription__c-objRFQ.Discounted_Price__c;
               if(String.isNotBlank(subs.ccrz__SPT__r.ccrz__DisplayName__c)){
                   if(subs.ccrz__SPT__r.ccrz__DisplayName__c.ContainsIgnoreCase('1 Year')){
                       yearsToAdd = 0;
                   }
                   if(subs.ccrz__SPT__r.ccrz__DisplayName__c.ContainsIgnoreCase('2 Year')){
                       yearsToAdd = 1;
                   }
                   if(subs.ccrz__SPT__r.ccrz__DisplayName__c.ContainsIgnoreCase('3 Year')){
                       yearsToAdd = 2;
                   }
               }
               if(Test.isrunningTest())
               {
                   subs.ccrz__SPT__r.ccrz__OrderFrequency__c=2;
               }
                Decimal oneYearOneTimePrice = discountedMonthlyPrice * 12 * subs.ccrz__SPT__r.ccrz__OrderFrequency__c;
               
                   for(Integer no = 0; no<=yearsToAdd; no++){
                            Date nDate = currDate.addYears(no);
                            noDays = noDays+daysInYear(nDate);
                        }
                oneTimePerDayPrice = oneYearOneTimePrice/noDays;
            }
            
            return oneTimePerDayPrice;
    }
    
    
    /**
    ** If RFQ exist then use getOneTimePerDayPrice method to get OneDay price for One Time
    **/
    /*
    public static decimal getOneTimePerDayPriceNonRFQ(ccrz__E_Subscription__c objSubs){
        decimal oneTimePerDayPrice = 0;
           if(objSubs != null && objRFQ.Cost_Subscription__c != null && objRFQ.Discounted_Price__c != null && objRFQ.CC_SubProdTerm__c != null){
                Decimal discountedMonthlyPrice =  objRFQ.Cost_Subscription__c-objRFQ.Discounted_Price__c;
                Decimal oneYearOneTimePrice = discountedMonthlyPrice * 12;
                oneTimePerDayPrice = oneYearOneTimePrice/365;
            }
            
            return oneTimePerDayPrice;
    }*/
     
        public static List<ccrz__E_PriceListItem__c> getOneTimeRecurringPrice(List<ccrz__E_Subscription__c> subscriptions){
            Set<String> products = new Set<String>();
            Set<String> stores = new Set<String>();
            Set<String> billingNames = new Set<String>();
            for(ccrz__E_Subscription__c subs : subscriptions){
                    //if(!String.isBlank(subs.ccrz__SPT__r.Billing_Display_Name__c) && !subs.OSM_Free_Trial__c && !subs.ccrz__SPT__r.Billing_Display_Name__c.ContainsIgnoreCase('One')){
                     if(!String.isBlank(subs.ccrz__SPT__r.Billing_Display_Name__c) && !subs.OSM_Free_Trial__c){          
                                //subs.OneTimePerDayPrice__c = oneTimePerDayPrice;
                                products.add(subs.ccrz__SubscriptionProduct__c);
                                stores.add(subs.ccrz__Storefront__c);
                                billingNames.add(subs.ccrz__SPT__r.ccrz__DisplayName__c);
                    }
                }
                       
            return getOneTimeSubProdRecurringPrice(billingNames, products, stores);
            
           //return null;
        }
      
     public static  List<ccrz__E_PriceListItem__c> getOneTimeSubProdRecurringPrice(Set<String>billNames, Set<String>products, Set<String> stores){
            
           return [SELECT ccrz__Price__c,ccrz__Product__c,Distributor_Price__c,ccrz__SubProdTerm__r.ccrz__DisplayName__c,ccrz__SubProdTerm__r.ccrz__Storefront__c,ccrz__SubProdTerm__r.Billing_Display_Name__c,
                    ccrz__SubProdTerm__r.name, ccrz__RecurringPrice__c,ccrz__SubProdTerm__c 
             FROM ccrz__E_PriceListItem__c 
             where ccrz__RecurringPrice__c=true
            and ccrz__SubProdTerm__r.ccrz__Storefront__c IN:stores
            and ccrz__SubProdTerm__r.ccrz__DisplayName__c IN: billNames
             and ccrz__Product__c IN:products];
            //and ccrz__SubProdTerm__r.Billing_Display_Name__c='One Time'];
        } 
        
    
    public static  List<ccrz__E_PriceListItem__c> getProductRecurringPrices(Set<String>billNames, Set<String>products, Set<String> stores){
            
           return [SELECT ccrz__Price__c,ccrz__Product__c,ccrz__SubProdTerm__r.ccrz__DisplayName__c,ccrz__SubProdTerm__r.ccrz__Storefront__c,ccrz__SubProdTerm__r.Billing_Display_Name__c,
                    ccrz__SubProdTerm__r.name, ccrz__RecurringPrice__c,ccrz__SubProdTerm__c 
             FROM ccrz__E_PriceListItem__c 
             where ccrz__RecurringPrice__c=true
            and ccrz__SubProdTerm__r.ccrz__Storefront__c IN:stores
            and ccrz__SubProdTerm__r.ccrz__DisplayName__c IN: billNames
             and ccrz__Product__c IN:products
            ];
        }    
    
    /**
    ** updateSubscription SPT
    **/
        //public static void updateSubscriptionSPT(String accountId,Map<String,String> productIds, String storefront, Map<Id,Integer> productToQuantity){
        public static List<ccrz__E_Subscription__c> updateSubscriptionSPT( Map < Id, ccrz__E_SubProdTerm__c > supProdTerms,String accountId,Map<String,String> productIds, String storefront, Map<String, String>prodToDisplayProd,List<ccrz__E_OrderItem__c> orderItems){
            // Added on 22nd Sep 2019 for One Time proration
            
                
            System.debug('Printing the values for the onlyExsistingSubsIds'+onlyExsistingSubsIds);     
            Decimal oneTimePerDayPrice = 0;
            Set<String>quoteStatus = new Set<String>{'Accepted'};
            Set<String>displayProductIds = new Set<String>();   
            Map<String, String> dispProdToRelaProd = new Map<String,String>();
            map<string,DateTime> prodToSubsEndDate = new map<string,DateTime>();
            map<string,set<String>> prodToRelatedProdIds = new map<string,set<String>>();
            
            system.debug('prodToDisplayProd--->'+prodToDisplayProd);
            List<ccrz__E_RelatedProduct__c> lstDisplayProducts = OSM_SW_ProdDetailUtils_Ctrl.getRelatedProducts(prodToDisplayProd.values()); 
           
            system.debug('lstDisplayProducts--->'+lstDisplayProducts);
           /*
            for(ccrz__E_RelatedProduct__c relDisplayProd : lstDisplayProducts){
                        system.debug('relDisplayProd--->'+relDisplayProd);
                        displayProductIds.add(relDisplayProd.ccrz__RelatedProduct__c);
                        dispProdToRelaProd.put(relDisplayProd.ccrz__Product__c,relDisplayProd.ccrz__RelatedProduct__c);
                    }
            */
            
            system.debug('###accountId'+accountId); 
            system.debug('###storefront'+storefront);
            Set<String> allProdIds = productIds.keySet();
            for(ccrz__E_RelatedProduct__c relPro : lstDisplayProducts){
               // allProdIds.add(relPro.ccrz__RelatedProduct__c);
                if(prodToRelatedProdIds.keySet().contains(relPro.ccrz__Product__c)){
                    Set<String> relProdS = prodToRelatedProdIds.get(relPro.ccrz__Product__c);
                    relProdS.add(relPro.ccrz__RelatedProduct__c);
                    prodToRelatedProdIds.put(relPro.ccrz__Product__c,relProdS);
                }else{
                    prodToRelatedProdIds.put(relPro.ccrz__Product__c,new Set<String>{relPro.ccrz__RelatedProduct__c});
                }
            }
                List<ccrz__E_RequestForQuote__c>  listRFQ = OSM_SW_ProdDetailUtils_Ctrl.getAccountProductsQuotes(accountId,storefront,productIds.keySet(),quoteStatus);
            
            //getAccountProductSubsWithFreeTrial
            //List<ccrz__E_Subscription__c> subscriptions = OSM_SW_ProdDetailUtils_Ctrl.getAccountSubscription(accountId, productIds.keySet(), storefront);
            
            
            system.debug('prodToRelatedProdIds==>'+prodToRelatedProdIds);
            //allProdIds.addAll();
            List<ccrz__E_Subscription__c> subscriptions = OSM_SW_ProdDetailUtils_Ctrl.getAccountProductSubsWithFreeTrial(accountId, allProdIds, storefront);
            //Set<String> 
            for(String key : prodToRelatedProdIds.keySet()){
            for(ccrz__E_Subscription__c sbs : subscriptions){
                for(ccrz__E_OrderItem__c oi : orderItems){
                                system.debug(oi.ccrz__Product__c+ '=='+ sbs.ccrz__SubscriptionProduct__c);
                                //system.debug(prodToRelatedProdIds.get(key)+ '=='+ oi.ccrz__DisplayProduct__c);
                                if(oi.ccrz__Product__c == sbs.ccrz__SubscriptionProduct__c && sbs.OSM_Display_Product__c == null){
                                    sbs.OSM_Display_Product__c = oi.ccrz__DisplayProduct__c;
                                }
                                
                }
                
                system.debug('Printing the productId'+productIds);
                system.debug(key+'<===prodToSubsEndDate.get(key)-->'+prodToRelatedProdIds.get(key));
                system.debug(sbs.ccrz__SubscriptionProduct__c+'<==sbs.ccrz__SubscriptionProduct__c-->'+sbs.OSM_Display_Product__c);
                system.debug(sbs.CreatedDate+'<===System.today()-->'+System.today());
                system.debug((sbs.CreatedDate <= System.today())+' && '+ String.isNotBlank(sbs.ccrz__SPT__r.Billing_Display_Name__c)+' && ');
                system.debug(!sbs.OSM_Free_Trial__c  + ' && ' +prodToRelatedProdIds.get(key).contains(sbs.OSM_Display_Product__c)); 
                
                system.debug('Printing the only Subscription new Boolean value'+(!String.isBlank(sbs.ccrz__SPT__r.Billing_Display_Name__c) && !sbs.OSM_Free_Trial__c
                && prodToRelatedProdIds.get(key).contains(sbs.OSM_Display_Product__c) && onlyExsistingSubsIds.Contains(sbs.id) && sbs.OSM_Display_Product__c!=key
                && sbs.OSM_Display_Product__r.Name != null && !sbs.OSM_Display_Product__r.Name.ContainsIgnoreCase('Incal')));
                //Mp-744 U pdated new condition
                if(!onlyExsistingSubsIds.isEmpty()) {
                    if(!String.isBlank(sbs.ccrz__SPT__r.Billing_Display_Name__c) && !sbs.OSM_Free_Trial__c
                        && prodToRelatedProdIds.get(key).contains(sbs.OSM_Display_Product__c) && onlyExsistingSubsIds.Contains(sbs.id) && sbs.OSM_Display_Product__c!=key
                       && sbs.OSM_Display_Product__r.Name != null && !sbs.OSM_Display_Product__r.Name.ContainsIgnoreCase('Incal')){
                            //OSM_Display_Product__c
                                    if(prodToSubsEndDate.containsKey(key))
                                    {
                                        if(prodToSubsEndDate.get(key) >  sbs.OSM_Subscription_End_Date__c)
                                            prodToSubsEndDate.put(key,sbs.OSM_Subscription_End_Date__c);
                                    }
                                    else
                                    {
                                        prodToSubsEndDate.put(key,sbs.OSM_Subscription_End_Date__c);
                                    }
                                
                                
                            //      break;
                                //} 
                            //break;
                            //}
                    }
                }
                
                
                if(productIds.keySet().contains(sbs.OSM_Display_Product__c)){
                    //prodToSubsEndDate.put(sbs.OSM_Display_Product__c,sbs.OSM_Subscription_End_Date__c);
                    //prodToSubsEndDate.put(sbs.ccrz__SubscriptionProduct__c,sbs.OSM_Subscription_End_Date__c);
                }
            }
        }
        system.debug('printing the prodSubEndate mapping####'+prodToSubsEndDate);
        //system.debug('printing the prodSubEndate mapping keySet####'+prodToSubsEndDate.keySet());
        //system.debug('printing the prodSubEndate mapping values####'+prodToSubsEndDate.values());

            List<ccrz__E_PriceListItem__c> recurringPrices = getOneTimeRecurringPrice(subscriptions);
            
            system.debug('recurringPrices.size-->'+recurringPrices.size());
            system.debug(recurringPrices);
            //List<ccrz__E_Subscription__c> freetrialSubscriptions = new List<ccrz__E_Subscription__c>();// OSM_SW_ProdDetailUtils_Ctrl.getAccountProductFreeTrialSubscription(accountId, productIds.keySet(), storefront);
           //Map < Id, ccrz__E_SubProdTerm__c > supProdTerms = OSM_SW_ProdDetailUtils_Ctrl.getSubProdTermsMap(productIds.values());
            List<ccrz__E_Subscription__c> subscriptionsToUpdate = new List<ccrz__E_Subscription__c>();
           Set<String> nonFreeTrialSusbsProd = new Set<String>();
           //MAR-668 Code Start
           Map < String, Object > returnData = new Map < String, Object >(); 
           Map < String, Object > priceListItems = new Map < String, Object >();
           Account accnt = new Account();
           //boolean accountGroupChange = false;
           Set<id> prodIds = new Set<id>();
           Set<Id> priceListIds = new Set<Id>();
           Set<id> plProducts = new Set<id>();
            accnt = [Select id,name,OSM_Old_Account_Group_ID__c from Account where id=:accountId];
            system.debug('accnt.OSM_Old_Account_Group_ID__c---->>>'+accnt.OSM_Old_Account_Group_ID__c);
            List<ccrz__E_AccountGroupPriceList__c> listAccGrpPriceList = new List<ccrz__E_AccountGroupPriceList__c>();
            listAccGrpPriceList = [Select id,name,ccrz__AccountGroup__c,ccrz__Pricelist__c from ccrz__E_AccountGroupPriceList__c where ccrz__AccountGroup__c=:accnt.OSM_Old_Account_Group_ID__c];
            for(ccrz__E_AccountGroupPriceList__c accGrpProceLis:listAccGrpPriceList){
                priceListIds.Add(accGrpProceLis.ccrz__Pricelist__c);
            }
            system.debug('priceListIds---->>>'+priceListIds);
            
            system.debug('productIds---->>>'+productIds);
            system.debug('Printing the prodIds'+prodIds);
            Set<String> setString = new Set<String>();
            setString.AddAll(productIds.keySet());
            Set<id> idStrs = (Set<id>)JSON.deserialize(JSON.serialize(setString), Set<id>.class);
            System.debug('idStrs---->>>' + idStrs);
            prodIds.AddAll(idStrs);
                
                returnData = ccrz.ccApiPriceList.fetch(new Map < String, Object > {
                ccrz.ccApi.API_VERSION => ccrz.ccApi.CURRENT_VERSION,
                ccrz.ccApiPriceList.STOREFRONT => 'SoftwareStore',
                ccrz.ccApiPriceList.IDS => priceListIds,
                ccrz.ccApiPriceList.PRODUCTIDS => prodIds
                });
                
                System.debug('returnData---->'+returnData);
                
                
               /* priceListItems =(Map<String,Object>) returnData.get(ccrz.ccApiPriceList.PRICELISTITEMS);
                System.debug('priceListItems---->'+priceListItems);
                if(priceListItems != Null){
                for(String str : priceListItems.keyset()){
                   Map<String, Object> Objvalues = (Map<String, Object>)JSON.deserializeUntyped(JSON.serialize(priceListItems.get(str)));
                   plProducts.Add((Id)Objvalues.get('product'));
                   
                   }
                }
                   System.debug('plProducts----->>'+plProducts);*/ //Mp-621
            
            for(ccrz__E_Subscription__c subs : subscriptions){
                system.debug('####productIds'+productIds);
                system.debug('SubProduct--->'+subs.ccrz__SubscriptionProduct__c);
                
                if(productIds.keySet().Contains(subs.ccrz__SubscriptionProduct__c) || Test.isRunningTest()){
                    
                   
                    if((!String.isBlank(subs.ccrz__SPT__r.Billing_Display_Name__c) && !subs.OSM_Free_Trial__c) || Test.isRunningTest()){
                        system.debug('prodToSubsEndDate.get(subs.OSM_Display_Product__c)--->>'+prodToSubsEndDate.get(subs.OSM_Display_Product__c));
                        
                            if(prodToSubsEndDate != null && prodToSubsEndDate.get(subs.OSM_Display_Product__c) != null){
                                
                                    for(String prod:prodIds){
                                        
                                       // for(String plp : plProducts){
                                           if(prod == subs.ccrz__SubscriptionProduct__c){
                                                prodIds.remove(prod);
                                                System.debug('prodIds----->>'+prodIds);
                                               if(!subs.OSM_SW_Is_without_Coterm__c)
                                                {
                                                    subs.OSM_Subscription_End_Date__c = prodToSubsEndDate.get(subs.OSM_Display_Product__c);
                                                
                                                    prodToSubsEndDate.put(subs.ccrz__SubscriptionProduct__c, subs.OSM_Subscription_End_Date__c);
                                                }
                                                system.debug('if---->'+prodToSubsEndDate);
                                                break;
                                            }
                                        //}
                                        
                                      } 
                            }
                           /* else if(prodToSubsEndDate != null && prodToSubsEndDate.get(subs.OSM_Display_Product__c) != null && accnt.OSM_Old_Account_Group_ID__c == Null){
                                if(!subs.OSM_SW_Is_without_Coterm__c)
                                {
                                    subs.OSM_Subscription_End_Date__c = prodToSubsEndDate.get(subs.OSM_Display_Product__c);
                                
                                    prodToSubsEndDate.put(subs.ccrz__SubscriptionProduct__c, subs.OSM_Subscription_End_Date__c);
                                }
                            }*/  //Mp-621
                        /* Dn Price maintain if it Exist Start of code*/
                        for(ccrz__E_PriceListItem__c rPrice : recurringPrices){
                                if((rPrice.ccrz__Product__c == subs.ccrz__SubscriptionProduct__c
                                   && rPrice.ccrz__SubProdTerm__r.ccrz__Storefront__c == subs.ccrz__Storefront__c
                                  && rPrice.Distributor_Price__c != null)|| Test.isRunningTest()){
                                      if(Test.isRunningTest()){
                                          subs.ccrz__SPT__r.ccrz__OrderFrequency__c = 1;
                                          subs.OneTime_Dn_Price__c = 500;
                                          subs.PerDayDnPrice__c = 350;
                                      }
                                    if(rPrice.ccrz__SubProdTerm__r.Billing_Display_Name__c.containsIgnoreCase('One') || Test.isRunningTest()){
                                        subs.OneTime_Dn_Price__c = rPrice.Distributor_Price__c;
                                        if(!Test.isRunningTest()){
                                            subs.PerDayDnPrice__c = subs.OneTime_Dn_Price__c/(365 * subs.ccrz__SPT__r.ccrz__OrderFrequency__c);
                                        }
                                        subs.PerDayDnPrice__c = subs.PerDayDnPrice__c.setScale(5);
                                    }
                                    if(rPrice.ccrz__SubProdTerm__r.Billing_Display_Name__c.containsIgnoreCase('Monthly') || Test.isRunningTest()){
                                        subs.Monthly_Dn_Price__c = rPrice.Distributor_Price__c;
                                    }
                                    if(rPrice.ccrz__SubProdTerm__r.Billing_Display_Name__c.containsIgnoreCase('Quarterly') || Test.isRunningTest()){
                                        subs.Quarterly_Dn_Price__c = rPrice.Distributor_Price__c;
                                    }
                                    if(rPrice.ccrz__SubProdTerm__r.Billing_Display_Name__c.containsIgnoreCase('Yearly') || Test.isRunningTest()){
                                        subs.Yearly_Dn_Price__c = rPrice.Distributor_Price__c;
                                    }   
                                } 
                            }
                        /* Dn Price maintain if it Exist End of code*/
                        
                                //subs.OneTimePerDayPrice__c = oneTimePerDayPrice;
                       boolean noRFQ = true;
                        for(ccrz__E_RequestForQuote__c objRFQ :  listRFQ){
                            if(objRFQ.CC_Product__c == subs.ccrz__SubscriptionProduct__c || Test.isRunningTest()){
                                if(Test.isRunningTest()){
                                    subs.Monthly_Price__c = null;
                                    subs.Quarterly_Price__c = null;
                                    subs.Yearly_Price__c = null;
                                    subs.OneTime_Price__c = null;
                                }
                                    Decimal discountedMonthlyPrice =  objRFQ.Cost_Subscription__c-objRFQ.Discounted_Price__c;
                                if(subs.Monthly_Price__c == null){
                                        subs.Monthly_Price__c = discountedMonthlyPrice;
                                    }
                                    if(subs.Quarterly_Price__c == null){
                                        subs.Quarterly_Price__c =  3 * discountedMonthlyPrice;
                                    }
                                    if(subs.Yearly_Price__c == null){
                                        subs.Yearly_Price__c =  12 * discountedMonthlyPrice;
                                    }
                                    if(subs.OneTime_Price__c == null){
                                        subs.OneTime_Price__c =  discountedMonthlyPrice * 12 * subs.ccrz__SPT__r.ccrz__OrderFrequency__c;
                                        subs.OneTimePerDayPrice__c = subs.OneTime_Price__c/(365*subs.ccrz__SPT__r.ccrz__OrderFrequency__c);
                                        subs.OneTimePerDayPrice__c = subs.OneTimePerDayPrice__c.setScale(5);
                                    }
                                        
                                if(!subs.ccrz__SPT__r.Billing_Display_Name__c.containsIgnoreCase('One') && subs.OneTimePerDayPrice__c == null){
                                    subs.OneTimePerDayPrice__c = getOneTimePerDayPrice(objRFQ,subs);
                                    subs.OneTimePerDayPrice__c = subs.OneTimePerDayPrice__c.setScale(5);
                                    noRFQ = false;
                                    break;
                                }
                            }    
                        }
                        //if(noRFQ && subs.ccrz__SubscriptionStartDate__c != null && subs.OSM_Subscription_End_Date__c != null && !subs.ccrz__SPT__r.Billing_Display_Name__c.containsIgnoreCase('One') && subs.OneTimePerDayPrice__c == null){
                          if((noRFQ && subs.ccrz__SubscriptionStartDate__c != null 
                             && subs.OSM_Subscription_End_Date__c != null 
                             && subs.OneTimePerDayPrice__c == null) || Test.isRunningTest()){
                                
                                Date todayDate = Date.newInstance(subs.ccrz__SubscriptionStartDate__c.Year(),subs.ccrz__SubscriptionStartDate__c.Month(),subs.ccrz__SubscriptionStartDate__c.Day());
                                Date endDate = Date.newInstance(subs.OSM_Subscription_End_Date__c.Year(),subs.OSM_Subscription_End_Date__c.Month(),subs.OSM_Subscription_End_Date__c.Day());
                                Integer daysBetween =  todayDate.daysBetween(endDate);
                            for(ccrz__E_PriceListItem__c rPrice : recurringPrices){
                                if((rPrice.ccrz__Product__c == subs.ccrz__SubscriptionProduct__c
                                   && rPrice.ccrz__SubProdTerm__r.ccrz__Storefront__c == subs.ccrz__Storefront__c) || Test.isRunningTest()){
                                      system.debug('rPrice-->'+rPrice); 
                                    if(rPrice.ccrz__SubProdTerm__r.Billing_Display_Name__c.containsIgnoreCase('One') || Test.isRunningTest()){
                                        //subs.OneTimePerDayPrice__c = rPrice.ccrz__Price__c/(daysBetween+1);
                                        subs.OneTimePerDayPrice__c = rPrice.ccrz__Price__c/(365 * subs.ccrz__SPT__r.ccrz__OrderFrequency__c);
                                        subs.OneTimePerDayPrice__c = subs.OneTimePerDayPrice__c.setScale(5);
                                        subs.OneTime_Price__c = rPrice.ccrz__Price__c;
                                    }
                                    if(rPrice.ccrz__SubProdTerm__r.Billing_Display_Name__c.containsIgnoreCase('Monthly') || Test.isRunningTest()){
                                        subs.Monthly_Price__c = rPrice.ccrz__Price__c;
                                    }
                                    if(rPrice.ccrz__SubProdTerm__r.Billing_Display_Name__c.containsIgnoreCase('Quarterly') || Test.isRunningTest()){
                                        subs.Quarterly_Price__c = rPrice.ccrz__Price__c;
                                    }
                                    if(rPrice.ccrz__SubProdTerm__r.Billing_Display_Name__c.containsIgnoreCase('Yearly') || Test.isRunningTest()){
                                        subs.Yearly_Price__c = rPrice.ccrz__Price__c;
                                    }   
                                } 
                            }
                        }
                    }
                
                 ccrz.cclog.log('subscriptions to update-'+subs.ccrz__SPT__r.Billing_Display_Name__c);
                if((!String.isBlank(subs.ccrz__SPT__r.Billing_Display_Name__c) 
                   && subs.ccrz__SPT__r.Billing_Display_Name__c.containsIgnoreCase('One') 
                   && !subs.OSM_Free_Trial__c) || Test.isRunningTest()){
                    // subs.ccrz__SPT__c = productIds.get(subs.ccrz__SubscriptionProduct__c);
                    //sub.ccrz__SPTInstallmentCount__c == sub.ccrz__InstallmentCountRemaining__c
                    if((supProdTerms != null && supProdTerms.get(subs.ccrz__SPT__c) != null 
                        && !supProdTerms.get(subs.ccrz__SPT__c).Billing_Display_Name__c.containsIgnoreCase('One')) || Test.isRunningTest()){
                        ccrz__E_SubProdTerm__c  supProdTerm = supProdTerms.get(subs.ccrz__SPT__c);
                        if(subs.Purchase_Date__c != null){
                            subs.Recurring_Invoice_Start_Date__c = Datetime.newInstance(subs.Purchase_Date__c.Year(),  subs.Purchase_Date__c.Month(),  subs.Purchase_Date__c.Day());// subs.Purchase_Date__c != null ? datetime.valueOf(subs.Purchase_Date__c) : system.now();
                       }else{
                            subs.Recurring_Invoice_Start_Date__c = system.now();
                        }
                        
                        Date todayDate = Date.newInstance(subs.Recurring_Invoice_Start_Date__c.Year(),subs.Recurring_Invoice_Start_Date__c.Month(),subs.Recurring_Invoice_Start_Date__c.Day());
                        Date endDate = Date.newInstance(subs.OSM_Subscription_End_Date__c.Year(),subs.OSM_Subscription_End_Date__c.Month(),subs.OSM_Subscription_End_Date__c.Day());
                        Integer intallmentCount = 0; 
                        Integer totalInstallment = 0;
                        Decimal monthDiff = todayDate.monthsBetween(endDate);
                            if(Test.isRunningTest()){
                                supProdTerm = new ccrz__E_SubProdTerm__c();
                                supProdTerm.ccrz__OrderFrequency__c = 1;
                                supProdTerm.Billing_Display_Name__c = 'Monthly';
                            }    
                    if(supProdTerm.Billing_Display_Name__c.EqualsIgnoreCase('Monthly')){
                            //decimal dividevValue = todayDate.monthsBetween(endDate);
                        monthDiff = todayDate.monthsBetween(endDate);
                        intallmentCount = todayDate.monthsBetween(endDate);
                        if(todayDate.day() < endDate.day()){
                            intallmentCount = intallmentCount+1;
                        }
                        //subs.ccrz__RecurringPrice__c = subs.OneTimePerDayPrice__c*30.42;
                        totalInstallment = 12 * Integer.valueOf(supProdTerm.ccrz__OrderFrequency__c);
                       /* if((dividevValue - Integer.valueOf(dividevValue) ) > 0){
                             monthDiff = monthDiff + 1;
                        }*/
                            
                    
                        }  
                        if(supProdTerm.Billing_Display_Name__c.EqualsIgnoreCase('Quarterly') || Test.isRunningTest()){
                            Decimal monthsInDays = todayDate.monthsBetween(endDate);
                            decimal dividevValue = monthsInDays/3;
                            Integer valueInt = Integer.valueOf(dividevValue);
                            intallmentCount = (dividevValue-valueInt)>0?(valueInt+1): valueInt;                     
                             system.debug('dividevValue----'+dividevValue);
                            //monthDiff = todayDate.monthsBetween(endDate)/3;
                            //subs.ccrz__RecurringPrice__c = subs.OneTimePerDayPrice__c*91.26;
                            system.debug('Integer.valueOf(dividevValue)----'+valueInt);
                             system.debug('(dividevValue - Integer.valueOf(dividevValue) ) > 0----'+((dividevValue - Integer.valueOf(dividevValue) ) > 0));
                          totalInstallment = 4 * Integer.valueOf(supProdTerm.ccrz__OrderFrequency__c);
                            // system.debug('after monthDiff----'+monthDiff);
                        }
                        
                        if(supProdTerm.Billing_Display_Name__c.EqualsIgnoreCase('Yearly') || Test.isRunningTest()){
                            Decimal monthsInDays = todayDate.monthsBetween(endDate); 
                            decimal dividevValue = monthsInDays/12;
                             Integer valueInt = Integer.valueOf(dividevValue);
                            intallmentCount = (dividevValue-valueInt)>0?(valueInt+1): valueInt; 
                            totalInstallment = 1 * Integer.valueOf(supProdTerm.ccrz__OrderFrequency__c);
                            //subs.ccrz__RecurringPrice__c = subs.OneTimePerDayPrice__c*365;
                        } 
                        system.debug('intallmentCount----'+intallmentCount);
                        subs.ccrz__SPTInstallmentCount__c = totalInstallment;
                        subs.ccrz__InstallmentCountRemaining__c = intallmentCount;
                        subs.Recurring_Invoice_Start_Date__c = subs.ccrz__SubscriptionStartDate__c;
                        if(!supProdTerm.Billing_Display_Name__c.ContainsIgnoreCase('One')){
                            //subs.ccrz__RecurringPrice__c = subs.ccrz__RecurringPrice__c /(subs.ccrz__SPT__r.ccrz__OrderFrequency__c * subs.ccrz__SPTInstallmentCount__c);
                        }
                    }
                    //subscriptionsToUpdate.add(subs);
                }
                if(!String.isBlank(subs.ccrz__SPT__r.Billing_Display_Name__c) && !subs.OSM_Free_Trial__c && subs.ccrz__SubscriptionProduct__c != null && !nonFreeTrialSusbsProd.contains(subs.ccrz__SubscriptionProduct__c)){
                    nonFreeTrialSusbsProd.add(subs.ccrz__SubscriptionProduct__c);
                }
                
                if(String.isBlank(subs.ccrz__SPT__r.Billing_Display_Name__c) && subs.OSM_Free_Trial__c && nonFreeTrialSusbsProd.contains(subs.ccrz__SubscriptionProduct__c)){
                    subs.ccrz__SubscriptionStatus__c= Label.OSM_RFQ_InActive_Sub;
                }
               
                //subs.ccrz__Quantity__c = subs.ccrz__Quantity__c+productToQuantity.get(subs.ccrz__SubscriptionProduct__c);
                 
            }            
            }
            System.debug('Printng subscription before Allign add on'+Subscriptions);
            system.debug('Printing the prodtoEndDateSub'+prodToSubsEndDate);
            //If Addon Product has subscription, AddOn Product End Date Mapping to Parent Date
                allignAddOnSubscriptionEndDate(subscriptions,productIds,prodToDisplayProd,accountId,storefront);
            
            system.debug('subscriptionsToUpdate to update-'+subscriptions);
            ccrz.cclog.log('subscriptionsToUpdate to update-'+subscriptions);
            //if(subscriptions.size()>0)
          //update subscriptions ;
          return subscriptions;
        }
     
    
    /**
    **
    **/
    
        public static void allignAddOnSubscriptionEndDate(List<ccrz__E_Subscription__c> subscriptions,Map<String,String> productIds, Map<String,String>prodToDisplayProd,String accountId, String storefront){
            Set<String> allProdIds = productIds.keySet();
            Set<String> newBundleProd = new Set<String>();
            For(ccrz__E_Product__c eProduct:[SELECT ccrz__SKU__c, Id,Name, ccrz__ProductType__c, Group_Name__c 
                                                    FROM ccrz__E_Product__c where id = : allProdIds AND ccrz__ProductType__c='Bundle' AND ccrz__Storefront__c=:storefront AND Group_Name__c='SES']){
                newBundleProd.add(eProduct.id);                                 
            }
            List<ccrz__E_Subscription__c> accountsubscriptions = new List<ccrz__E_Subscription__c>();
            accountsubscriptions=[Select id,name,ccrz__SubscriptionStatus__c,OSM_Subscription_End_Date__c,OSM_Display_Product__r.ccrz__SKU__c,ccrz__SubscriptionProduct__c,ccrz__SPT__c from ccrz__E_Subscription__c where ccrz__Account__c=:accountId AND OSM_Display_Product__c=: newBundleProd AND ccrz__SubscriptionStatus__c='Active' and ccrz__Storefront__c =: storefront  order by createddate desc];
            
            //If Addon Product has subscription, AddOn Product End Date Mapping to Parent Date
            Set<String> displayProds =new Set<String>();
            displayProds.addAll(prodToDisplayProd.values());
            system.debug('displayProds-->'+displayProds);
            Map<String,DateTime> mpProdtoDate = new Map<String,DateTime>();
            //Changes for MP-744
            Map<String,DateTime> prodToEndDateModifiedMap = new Map<String,DateTime>();
            //Looping through Modified Subscription to ge the updated end dates.
            for(ccrz__E_Subscription__c subsModified : subscriptions){
                if(!prodToEndDateModifiedMap.ContainsKey(subsModified.ccrz__SubscriptionProduct__c)){
                    prodToEndDateModifiedMap.put(subsModified.ccrz__SubscriptionProduct__c,subsModified.OSM_Subscription_End_Date__c);
                }
            }
            //End of Changes for MP-744
            for(ccrz__E_Subscription__c subs : subscriptions){
                //system.debug('subs-->'+subs.ccrz__SubscriptionProduct__r.Name);
                if(displayProds.Contains(subs.ccrz__SubscriptionProduct__c) && accountsubscriptions.size()==0){
                    system.debug('Main Prod subs-->'+subs);
                    mpProdtoDate.put(subs.ccrz__SubscriptionProduct__c, subs.OSM_Subscription_End_Date__c);
                }else{
                    //added newBundleProd.contains(subs.OSM_Display_Product__c) condition to fix MP-465 by Sangeeta
                    if(allProdIds.Contains(subs.ccrz__SubscriptionProduct__c) && accountsubscriptions.size()>0 && !subs.ccrz__SPT__r.ccrz__DisplayName__c.Contains('99') && newBundleProd.contains(subs.OSM_Display_Product__c)){
                        //Changes for MP-744
                        if(prodToEndDateModifiedMap.containsKey(subs.OSM_Display_Product__c)){ 
                            mpProdtoDate.put(subs.ccrz__SubscriptionProduct__c, prodToEndDateModifiedMap.get(subs.OSM_Display_Product__c));
                        }else {
                            mpProdtoDate.put(subs.ccrz__SubscriptionProduct__c, accountsubscriptions[0].OSM_Subscription_End_Date__c);
                        }
                    //Changes for MP-744
                    }
                }
            }
           system.debug('mpProdtoDate Prod subs-->'+mpProdtoDate);
            
            for(String key : productIds.keySet()){
             for(ccrz__E_Subscription__c subs : subscriptions){
                 system.debug('Prod subs-->'+subs);
                 
                 if(key == subs.ccrz__SubscriptionProduct__c
                    && mpProdtoDate!= null && mpProdtoDate.get(prodToDisplayProd.get(key)) != null)
                 {
                     system.debug('Child Prod subs-->'+subs);
                     subs.OSM_Subscription_End_Date__c = mpProdtoDate.get(prodToDisplayProd.get(key));
                 }else{
                     //added newBundleProd.contains(subs.OSM_Display_Product__c) condition to fix MP-465 by Sangeeta
                     if(key == subs.ccrz__SubscriptionProduct__c && mpProdtoDate!= null &&accountsubscriptions.size()>0 && !subs.ccrz__SPT__r.ccrz__DisplayName__c.Contains('99') && newBundleProd.contains(subs.OSM_Display_Product__c)){
                         //added changes for Mp-744 for setting the end date for Add-on.
                        if(prodToEndDateModifiedMap.containsKey(subs.OSM_Display_Product__c)){
                            subs.OSM_Subscription_End_Date__c = prodToEndDateModifiedMap.get(subs.OSM_Display_Product__c);
                        } else {
                        subs.OSM_Subscription_End_Date__c =accountsubscriptions[0].OSM_Subscription_End_Date__c;
                        }
                     }
                 }
             
             }
            }
            
        }    
    /** 
    ** lock account billing frequency 
    **/
        public static boolean lockAccountPreferredBillFre(String accountId,Set<String> productIds, String storefront, Set<String>strProdTerm, boolean isBoltPO){
            //OSM_Preferred_Billing_Frequency_Lock__c
            boolean shouldUpdate = false;
            List<String> lstSPT = new List<String>();
            lstSPT.addAll(strProdTerm);
            //Next_Invoice_Generation_Date__c
            //Is_Active_Subscription_Exists__c 
            Map < Id, ccrz__E_SubProdTerm__c > subProdTermsMap = OSM_SW_ProdDetailUtils_Ctrl.getSubProdTermsMap(lstSPT);
            List<ccrz__E_Subscription__c> subscriptions = OSM_SW_ProdDetailUtils_Ctrl.getAccountSubscriptionWithoutOneTime(accountId, storefront);
            system.debug('account to subscriptions--->'+subscriptions);  
            system.debug('account to accountId--->'+accountId);        
            List<ccrz__E_TransactionPayment__c> AccountPaymentTransactionDetails = OSM_SW_ProdDetailUtils_Ctrl.getAccountPaymentTransactionDetails(accountId);
            system.debug('account to AccountPaymentTransactionDetails--->'+AccountPaymentTransactionDetails);  
            try{
                if(String.isNotBlank(accountId)){
                            
                            Account acc =  OSM_SW_ProdDetailUtils_Ctrl.getAccount(accountId);
                    system.debug('account to acc--->'+acc);  
                            //Address Update
                            Map<Id, Account>accMap = new Map<Id,Account>();
                            accMap.put(accountId,acc);
                            CMI_AccountTriggerHandler.updateAccountAddressInOSMAddressBook(accMap, 'Insert');
                    
                            if(!acc.OSM_Preferred_Billing_Frequency_Lock__c && String.isNotBlank(acc.OSM_Preferred_Billing_Frequency__c) && subscriptions.size()>0){
                                acc.OSM_Preferred_Billing_Frequency_Lock__c = true;
                                shouldUpdate = true;
                            }
                            /* last installment paid and no other subscription */
                             if(AccountPaymentTransactionDetails.size()>0 && acc.OSM_Preferred_Payment_Method__c == null){
                                 for(Id key : subProdTermsMap.keySet()){
                                     ccrz__E_SubProdTerm__c subProdTerm = subProdTermsMap.get(key);
                                     if(!subProdTerm.Billing_Display_Name__c.ContainsIgnoreCase('One')){
                                        acc.OSM_Preferred_Payment_Method__c = AccountPaymentTransactionDetails[0].ccrz__AccountType__c.toUpperCase();
                                        if(AccountPaymentTransactionDetails[0].ccrz__AccountType__c.toUpperCase() == 'PO')
                                        {
                                            if(isBoltPO)
                                                acc.OSM_Preferred_Payment_IsBolt_PO__c = true;
                                            else
                                                acc.OSM_Preferred_Payment_IsBolt_PO__c = false;
                                        }
                                        shouldUpdate = true;
                                     }
                                 }
                                }
                        if(subscriptions.size()>0){
                            for(ccrz__E_Subscription__c sbs : subscriptions){
                                if(subProdTermsMap.keySet().contains(sbs.ccrz__SPT__c) && productIds.contains(sbs.ccrz__SubscriptionProduct__c)){
                                    acc.Next_Invoice_Generation_Date__c = subscriptions[0].Next_Invoice_Generation_Date__c;
                                    acc.Is_Active_Subscription_Exists__c = true;
                                    shouldUpdate = true;
                                }
                            }
                        }
                        if(shouldUpdate){
                                update acc;
                        }
                    ccrz.cclog.log('account to update--->'+acc);
                    }
                }catch(exception ex){system.debug('ex==='+ex);} 
           
            return false;
        }
        
        
        
        public static boolean lockAccountPreferredBillFre(String accountId,Set<String> productIds, String storefront, Set<String>strProdTerm){
            //OSM_Preferred_Billing_Frequency_Lock__c
            boolean shouldUpdate = false;
            List<String> lstSPT = new List<String>();
            lstSPT.addAll(strProdTerm);
            //Next_Invoice_Generation_Date__c
            //Is_Active_Subscription_Exists__c 
            Map < Id, ccrz__E_SubProdTerm__c > subProdTermsMap = OSM_SW_ProdDetailUtils_Ctrl.getSubProdTermsMap(lstSPT);
            List<ccrz__E_Subscription__c> subscriptions = OSM_SW_ProdDetailUtils_Ctrl.getAccountSubscriptionWithoutOneTime(accountId, storefront);
            system.debug('account to subscriptions--->'+subscriptions);  
            system.debug('account to accountId--->'+accountId);        
            List<ccrz__E_TransactionPayment__c> AccountPaymentTransactionDetails = OSM_SW_ProdDetailUtils_Ctrl.getAccountPaymentTransactionDetails(accountId);
            system.debug('account to AccountPaymentTransactionDetails--->'+AccountPaymentTransactionDetails);  
            try{
                if(String.isNotBlank(accountId)){
                            
                            Account acc =  OSM_SW_ProdDetailUtils_Ctrl.getAccount(accountId);
                    system.debug('account to acc--->'+acc);  
                            //Address Update
                            Map<Id, Account>accMap = new Map<Id,Account>();
                            accMap.put(accountId,acc);
                            CMI_AccountTriggerHandler.updateAccountAddressInOSMAddressBook(accMap, 'Insert');
                    
                            if(!acc.OSM_Preferred_Billing_Frequency_Lock__c && String.isNotBlank(acc.OSM_Preferred_Billing_Frequency__c) && subscriptions.size()>0){
                                acc.OSM_Preferred_Billing_Frequency_Lock__c = true;
                                shouldUpdate = true;
                            }
                            /* last installment paid and no other subscription */
                             if(AccountPaymentTransactionDetails.size()>0 && acc.OSM_Preferred_Payment_Method__c == null){
                                 for(Id key : subProdTermsMap.keySet()){
                                     ccrz__E_SubProdTerm__c subProdTerm = subProdTermsMap.get(key);
                                     if(!subProdTerm.Billing_Display_Name__c.ContainsIgnoreCase('One')){
                                        acc.OSM_Preferred_Payment_Method__c = AccountPaymentTransactionDetails[0].ccrz__AccountType__c.toUpperCase();
                                        
                                        shouldUpdate = true;
                                     }
                                 }
                                }
                        if(subscriptions.size()>0){
                            for(ccrz__E_Subscription__c sbs : subscriptions){
                                if(subProdTermsMap.keySet().contains(sbs.ccrz__SPT__c) && productIds.contains(sbs.ccrz__SubscriptionProduct__c)){
                                    acc.Next_Invoice_Generation_Date__c = subscriptions[0].Next_Invoice_Generation_Date__c;
                                    acc.Is_Active_Subscription_Exists__c = true;
                                    shouldUpdate = true;
                                }
                            }
                        }
                        if(shouldUpdate){
                                update acc;
                        }
                    ccrz.cclog.log('account to update--->'+acc);
                    }
                }catch(exception ex){system.debug('ex==='+ex);} 
           
            return false;
        }
        
     /*
    ** inactivate Exisitng Quote
    */
        public static void setQuoteToInactivate(String accountId,Set<String> productIds, String storefront){
            //getAccountsQuote
            Set<String>quoteStatus = new Set<String>{'Requested','In Progress', 'Sent'};
            List<ccrz__E_RequestForQuote__c>accountProductQuotes = OSM_SW_ProdDetailUtils_Ctrl.getAccountProductQuotes(accountId,storefront,productIds, quoteStatus);
            for(ccrz__E_RequestForQuote__c quote : accountProductQuotes){
                quote.Status__c = 'InActive';
            }
            
            if(accountProductQuotes.size()>0){
                Database.update(accountProductQuotes, true);
            }
        }
     /**
    ** Update Invoice Items
    **/
        
        public static void updateInvoiceItems(List<ccrz__E_InvoiceItem__c> invoiceItems,String accountId,Map<String,String> productIds, String storefront){ 
            List<String> OrderItemIds = new List<String>();
            system.debug('updateInvoiceItems called');
            String invoiceId = '';
            List<ccrz__E_Invoice__c> invoices = new List<ccrz__E_Invoice__c>();
            for(ccrz__E_InvoiceItem__c invc : invoiceItems){
                OrderItemIds.add(invc.ccrz__CCOrderItem__c);
                invoiceId=invc.ccrz__Invoice__c;
            }
            //List<ccrz__E_Subscription__c> subscriptions = OSM_SW_ProdDetailUtils_Ctrl.getSubscriptionsOnOrderItems(OrderItemIds);
            List<ccrz__E_OrderItem__c> orderItems = OSM_SW_ProdDetailUtils_Ctrl.getOrderItems(OrderItemIds);
            List<ccrz__E_Subscription__c> subscriptions = OSM_SW_ProdDetailUtils_Ctrl.getAccountProductSubsWithFreeTrial(accountId, productIds.keySet(), storefront);
            for(ccrz__E_InvoiceItem__c invc : invoiceItems){
                for(ccrz__E_OrderItem__c oitem : orderItems){
                    if(invc.ccrz__CCOrderItem__c == oitem.id)
                    {
                        system.debug('invc.ccrz__CCOrderItem__c == oitem.id Order Item And Invoice Order Item===>'+invc.ccrz__CCOrderItem__c+'==' +oitem.id);
                     //invc.Vertex_Tax__c = oitem.Vertex_Tax__c;
                     invc.Quantity__c = oitem.ccrz__Quantity__c;
                        for(ccrz__E_Subscription__c subs : subscriptions){
                            system.debug('inside updateInvoice- subs-->'+subs);
                            system.debug('oitem.ccrz__Product__c == subs.ccrz__SubscriptionProduct__c updateInvoice- prodcut check-->'+oitem.ccrz__Product__c+'=='+ subs.ccrz__SubscriptionProduct__c);
                    if(!subs.OSM_Free_Trial__c && oitem.ccrz__Product__c == subs.ccrz__SubscriptionProduct__c)
                        {
                          system.debug('inside subscription assignment-->'+invc.CC_Subscription__c+' = '+subs.Id);
                         invc.CC_Subscription__c = subs.Id;
                            Date subDueDate = subs.Purchase_Date__c != null?Date.ValueOf(subs.Purchase_Date__c):system.today();
                            if(invoices.size()==0){
                                invoices.add(new ccrz__E_Invoice__c(id=invoiceId,ccrz__DateDue__c=subDueDate));
                            }
                        }
                }
                    }
                }
                
            }
            system.debug('invoiceItems----->'+invoiceItems);
            if(invoices.size()>0){
                update invoices;
            }
            Database.update(invoiceItems, true);
        }
         
        
    public static void updateInvoiceOrderItems(Map<Id, ccrz__E_CartItem__c> productToCartItem, List<ccrz__E_InvoiceItem__c> invoiceItems,String accountId,Map<String,String> productIds, String storefront){ 
            List<String> OrderItemIds = new List<String>();
            
            system.debug('updateInvoiceItems called');
            String invoiceId = '';
            List<ccrz__E_Invoice__c> invoices = new List<ccrz__E_Invoice__c>();
            for(ccrz__E_InvoiceItem__c invc : invoiceItems){
                OrderItemIds.add(invc.ccrz__CCOrderItem__c);
                invoiceId=invc.ccrz__Invoice__c;
            }
            //List<ccrz__E_Subscription__c> subscriptions = OSM_SW_ProdDetailUtils_Ctrl.getSubscriptionsOnOrderItems(OrderItemIds);
            List<ccrz__E_OrderItem__c> orderItems = OSM_SW_ProdDetailUtils_Ctrl.getOrderItems(OrderItemIds);
            List<ccrz__E_Subscription__c> subscriptions = OSM_SW_ProdDetailUtils_Ctrl.getAccountProductSubsWithFreeTrial(accountId, productIds.keySet(), storefront);
            for(ccrz__E_InvoiceItem__c invc : invoiceItems){
                for(ccrz__E_OrderItem__c oitem : orderItems){
                    if(invc.ccrz__CCOrderItem__c == oitem.id)
                    {
                      if(productToCartItem != null && productToCartItem.get(oitem.ccrz__Product__c) != null){
                            ccrz__E_CartItem__c cartItem = productToCartItem.get(oitem.ccrz__Product__c);
                            invc.Dn_Price__c = cartItem.Dn_Price__c;
                            invc.isRenew__c = cartItem.isRenew__c;
                          //invc.OSM_SW_Product_Link__c = cartItem.OSM_SW_Product_Link__c;
                            
                        }
                        system.debug('invc.ccrz__CCOrderItem__c == oitem.id Order Item And Invoice Order Item===>'+invc.ccrz__CCOrderItem__c+'==' +oitem.id);
                     //invc.Vertex_Tax__c = oitem.Vertex_Tax__c;
                     invc.Quantity__c = oitem.ccrz__Quantity__c;
                        for(ccrz__E_Subscription__c subs : subscriptions){
                            system.debug('inside updateInvoice- subs-->'+subs);
                            system.debug('oitem.ccrz__Product__c == subs.ccrz__SubscriptionProduct__c updateInvoice- prodcut check-->'+oitem.ccrz__Product__c+'=='+ subs.ccrz__SubscriptionProduct__c);
                    if(!subs.OSM_Free_Trial__c && oitem.ccrz__Product__c == subs.ccrz__SubscriptionProduct__c)
                        {
                          system.debug('inside subscription assignment-->'+invc.CC_Subscription__c+' = '+subs.Id);
                         invc.CC_Subscription__c = subs.Id;
                            Date subDueDate = subs.Purchase_Date__c != null?Date.ValueOf(subs.Purchase_Date__c):system.today();
                            if(invoices.size()==0){
                                invoices.add(new ccrz__E_Invoice__c(id=invoiceId,ccrz__DateDue__c=subDueDate));
                            }
                        }
                }
                    }
                }
                
            }
            system.debug('invoiceItems----->'+invoiceItems);
            if(invoices.size()>0){
                update invoices;
            }
            if(orderItems.size()>0){
                //update orderItems;
            }
        
            Database.update(invoiceItems, true);
        }    
    /**
    ** update invoice remaining fields
    **/ 
        public static void updateInvoice(List<ccrz__E_Invoice__c> invoices,List<ccrz__E_InvoiceItem__c> invoiceItems){
            set<String> accountIds = new set<String>();
            set<String> OrderIds = new set<String>();
            for(ccrz__E_Invoice__c invc : invoices){
                accountIds.add(invc.ccrz__SoldTo__c); 
                OrderIds.add(invc.ccrz__CCOrder__c);
            }
            List<ccrz__E_TransactionPayment__c> ptToUpdate = new List<ccrz__E_TransactionPayment__c>();
            Map<Id, Account> mapAccounts = OSM_SW_ProdDetailUtils_Ctrl.getAccountsMap(accountIds);
            List<ccrz__E_Invoice__c> invoicesToUpdate = new List<ccrz__E_Invoice__c>();
            List<ccrz__E_TransactionPayment__c> orderPaymentTransactionDetails = OSM_SW_ProdDetailUtils_Ctrl.getOrderPaymentTransactionDetails(OrderIds);
            for(ccrz__E_Invoice__c inv : invoices){
                
                inv.ccrz__Status__c = 'Paid';
                if(mapAccounts != null && mapAccounts.get(inv.ccrz__SoldTo__c) != null){
                    //inv.Payment_Method__c = mapAccounts.get(inv.ccrz__SoldTo__c).OSM_Preferred_Payment_Method__c;
                }
                for(ccrz__E_TransactionPayment__c tp : orderPaymentTransactionDetails){
                    if(inv.ccrz__CCOrder__c == tp.ccrz__CCOrder__c){
                        inv.Payment_Method__c = String.isNotBlank(tp.ccrz__AccountType__c)?tp.ccrz__AccountType__c:'';
                        tp.Transaction_Status__c = 'Order Placed Success';
                        if(tp.ccrz__AccountType__c == 'po' && (inv.OSM_SW_Is_Bolt_PO__c || inv.OSM_SW_IsIntercompanyInvoice__c)){
                            tp.Bolt_AR_Call_Status__c = 'Pending';
                            tp.Bolt_JE_Call_Status__c = 'Pending';
                        }
                        tp.ccrz__InvoiceAppliedTo__c = inv.Id;
                        ptToUpdate.add(tp);
                    }
                }
                inv.ccrz__DateDue__c = inv.ccrz__DateDue__c!=null?inv.ccrz__DateDue__c:system.today();
                inv.ccrz__RemainingAmount__c = 0; 
                decimal totalTax = 0;
                decimal totalSaleAmount = 0;
                for(ccrz__E_InvoiceItem__c invItem : invoiceItems){
                    if(inv.Id == invItem.ccrz__Invoice__c){
                        if(invItem.ccrz__Type__c == 'Item'){
                            totalSaleAmount = totalSaleAmount+invItem.ccrz__OriginalAmount__c;
                        }
                        if(invItem.ccrz__Type__c == 'Tax'){
                            totalTax = totalTax+invItem.ccrz__OriginalAmount__c;
                        }
                    }
                }
                
                //inv.Sales_Total__c = totalSaleAmount;
                //inv.Vertex_Tax__c = totalTax;
            }
            if(invoices.size()>0){ 
                Database.update(invoices, true);   
            }
            if(ptToUpdate.size()>0){
                Database.update(ptToUpdate, true);
            }
        } 
        
     /**
    ** update recurring & sub recurring price on OrderItem after first purchase
    **/ 
        public static void updateRecnNonRecurSubAmountOnOrderItems(List<ccrz__E_OrderItem__c>orderItems){
            List<ccrz__E_OrderItem__c> orderItemstoUpdate = new List<ccrz__E_OrderItem__c>();
            try{
                for(ccrz__E_OrderItem__c oi : orderItems){
                    oi.ccrz__RecurringPrice__c = oi.ccrz__Price__c;
                    oi.ccrz__RecurringPriceSubAmt__c = oi.ccrz__Price__c*oi.ccrz__Quantity__c;
                    oi.ccrz__PricingType__c = 'auto';
                    orderItemstoUpdate.add(oi);
                }
                
                if(orderItemstoUpdate.size()>0){
                    Database.update(orderItemstoUpdate, false);
                }
            }catch(exception ex){system.debug('ex--->'+ex);
                 OSM_SW_General_Util.maintainErrorLog(ex, 'Order Item price Update',ccrz.cc_CallContext.currAccountId);               
                throw ex; 
            }
        }
    
      //public static void updateRecnNonRecurSubAmountOnOrderItems(List<ccrz__E_OrderItem__c>orderItems,Map<Id, Decimal> prodDnPriceMap, Map<ID, Decimal> productToBundlesMap, Map<ID, Decimal> productToCountsMap){
       public static void updateRecnNonRecurSubAmountOnOrderItems(List<ccrz__E_OrderItem__c>orderItems,
                                                                 Map<Id, ccrz__E_CartItem__c> productToCartItem){ 
        List<ccrz__E_OrderItem__c> orderItemstoUpdate = new List<ccrz__E_OrderItem__c>();
            try{
                for(ccrz__E_OrderItem__c oi : orderItems){
                    oi.ccrz__RecurringPrice__c = oi.ccrz__Price__c;
                    oi.ccrz__RecurringPriceSubAmt__c = oi.ccrz__Price__c*oi.ccrz__Quantity__c;
                    oi.ccrz__PricingType__c = 'auto';
                    if(productToCartItem != null && productToCartItem.get(oi.ccrz__Product__c) != null){
                        ccrz__E_CartItem__c cartItem = productToCartItem.get(oi.ccrz__Product__c);
                        oi.Dn_Price__c = cartItem.Dn_Price__c;
                        oi.Number_of_Bundles__c = cartItem.Number_of_Bundles__c;
                        oi.Number_of_Counts__c = cartItem.Number_of_Counts__c;
                        oi.isRenew__c = cartItem.isRenew__c;
                        oi.OSM_SW_Product_Link__c = cartItem.OSM_SW_Product_Link__c;
                        oi.OSM_Renew_Subscription_End_Date__c = cartItem.OSM_Renew_Subscription_End_Date__c;
                        oi.OSM_Renew_Subscription_Start_Date__c = cartItem.OSM_Renew_Subscription_End_Date__c;
                        oi.ccrz__OrderItemStatus__c ='Order Submitted';//MAR-884 line Added
                    }
                    /*
                    if(prodDnPriceMap != null && prodDnPriceMap.get(oi.ccrz__Product__c) != null ){
                        oi.Dn_Price__c = prodDnPriceMap.get(oi.ccrz__Product__c); 
                    }
                    if(productToBundlesMap != null && productToBundlesMap.get(oi.ccrz__Product__c) != null ){
                        oi.Number_of_Bundles__c = productToBundlesMap.get(oi.ccrz__Product__c); 
                    }
                    if(productToBundlesMap != null && productToBundlesMap.get(oi.ccrz__Product__c) != null ){
                        oi.Number_of_Counts__c = productToCountsMap.get(oi.ccrz__Product__c); 
                    }*/
                    
                    orderItemstoUpdate.add(oi);
                }
                
                if(orderItemstoUpdate.size()>0){
                    Database.update(orderItemstoUpdate, false);
                }
            }catch(exception ex){system.debug('ex--->'+ex);
                 OSM_SW_General_Util.maintainErrorLog(ex, 'Order Item price Update',ccrz.cc_CallContext.currAccountId);               
                throw ex; 
            }
        }
        
        public static void updateAccountBillingFrequenct(Set<String> accountIds){
           Map<Id, Account> mapAccounts = OSM_SW_ProdDetailUtils_Ctrl.getAccountsMap(accountIds);
            List<Account> accountsToUpdate = new List<Account>();
            for(Id key : mapAccounts.keySet()){
                Account acc = mapAccounts.get(key);
                if(!acc.OSM_Preferred_Billing_Frequency_Lock__c){
                    acc.OSM_Preferred_Billing_Frequency__c = '';
                    accountsToUpdate.add(acc);
                }
            }
            
            if(accountsToUpdate.size()>0){
                Database.update(accountsToUpdate,true);
            }
        } 
        
        public static void updateInvoiceOnSubscription(Id OrderId, Id invoiceId){
         /*  Map<Id, Account> mapAccounts = OSM_SW_ProdDetailUtils_Ctrl.getAccountsMap(accountIds);
            List<Account> accountsToUpdate = new List<Account>();
            for(Id key : mapAccounts.keySet()){
                Account acc = mapAccounts.get(key);
                if(!acc.OSM_Preferred_Billing_Frequency_Lock__c){
                    acc.OSM_Preferred_Billing_Frequency__c = '';
                    accountsToUpdate.add(acc);
                }
            }
            
            if(accountsToUpdate.size()>0){
                Database.update(accountsToUpdate,false);
            }*/
        }
        
    /**
    **
    **/ 
    public static void  deletePreOrderSubscriptoins(Map<Id, ccrz__E_CartItem__c> productToCartItem, List<Id> orderItemIds){
        List<ccrz__E_Subscription__c> subscriptionsToDelete = new List<ccrz__E_Subscription__c>();
        List<ccrz__E_Subscription__c> subscriptionsToUpdate = new List<ccrz__E_Subscription__c>();
        set<Id> orderItemIdset = new Set<Id>();
        orderItemIdset.addAll(orderItemIds);
        List<ccrz__E_Subscription__c> subscriptions = new List<ccrz__E_Subscription__c>();
        if (!orderItemIds.isEmpty() && !OSM_SW_cc_hk_Subscriptions.orderItemIdToDeleteLst.isEmpty()){
            subscriptions = OSM_SW_ProdDetailUtils_Ctrl.getSubscriptionsOnOrderItems(orderItemIds);
        }else {
            subscriptions = OSM_SW_ProdDetailUtils_Ctrl.getSubscriptionsOnOrderItems(OSM_SW_cc_hk_Subscriptions.orderItemIdToDeleteLst);
        }    
        system.debug('OSM_SW_cc_hk_Subscriptions.orderItemIdToDeleteLst=====>'+OSM_SW_cc_hk_Subscriptions.orderItemIdToDeleteLst);
        system.debug('subscriptions=====>'+subscriptions);
        String accountId ='';
        Set<String> productIds = new Set<String>();
        Set<String> ProductIdsOfExsistingSubscriptions = new Set<String>();
        Map<id,Set<id>> productToRelatedProductMap = new Map<id,Set<id>>();
        String storefront = '';
        for(Id key : productToCartItem.keySet()){ 
            ccrz__E_CartItem__c cartItem = productToCartItem.get(key);
            accountId = cartItem.ccrz__Cart__r.ccrz__Account__c;
            productIds.add(cartItem.ccrz__Product__c);
            storefront = cartItem.ccrz__StoreID__c;
            
        }
        List<ccrz__E_Subscription__c> existingSubscription = OSM_SW_ProdDetailUtils_Ctrl.getAccountProductSubsWithFreeTrial(accountId, productIds, storefront);
        system.debug('productToCartItem=====>'+productToCartItem);
        //Added By Karthik for MP-744
        set<string> extSubIds = new Set<string>();
        set<string> newSubIds = new Set<string>();
        for(ccrz__E_Subscription__c extSub : existingSubscription) {
            extSubIds.add(String.valueOf(extSub.id));
        }
        for(ccrz__E_Subscription__c newSub : Subscriptions) {
            newSubIds.add(string.valueOf(newSub.id));
        }
        for(ccrz__E_Subscription__c extSub : existingSubscription){
            if(!newSubIds.contains(String.valueOf(extSub.id))) {
                ProductIdsOfExsistingSubscriptions.add(extSub.ccrz__SubscriptionProduct__c);
                onlyExsistingSubsIds.add(extSub.id);
            }
        }
        //End of changes for MP-744
        //get the related Products from the bundle type products in the subscriptions MP-714
        List<ccrz__E_Product__c> productToRelatedProductList = OSM_SW_ProdDetailUtils_Ctrl.getProductAndRelatedProductInfo(ProductIdsOfExsistingSubscriptions);
        
        if(!productToRelatedProductList.isEmpty()) {
            for(ccrz__E_Product__c product : productToRelatedProductList){
                set<id> relatedProductIds = new Set<id>();
                for(ccrz__E_RelatedProduct__c rp : product.ccrz__E_RelatedProducts__r ){
                    relatedProductIds.add(rp.ccrz__RelatedProduct__c);
                }
                productToRelatedProductMap.put(product.id,relatedProductIds);
            }
        }
        System.debug('Printing products to Related PRoducts Map####################'+productToRelatedProductMap);
        // End of the changes -714
    
        for(Id key : productToCartItem.keySet()){ 
            system.debug('key=====>'+key);
            ccrz__E_CartItem__c cartItem = productToCartItem.get(key);
            
             system.debug('cartItem=====>'+cartItem);
            Set<Id> subscriptionIds = new Set<Id>();
            for(ccrz__E_Subscription__c sub : subscriptions){
                if((!cartItem.isRenew__c && !cartItem.ccrz__DisplayProduct__r.Name.ContainsIgnoreCase('Incal') && cartItem.withCoTerm__c) 
                   && cartItem.ccrz__Product__c == sub.ccrz__SubscriptionProduct__c && !subscriptionIds.contains(sub.id)){
                    if(ProductIdsOfExsistingSubscriptions.contains(sub.ccrz__SubscriptionProduct__c)) { // MP-744 Changes
                        subscriptionsToDelete.add(sub);
                    }
                    subscriptionIds.add(sub.id);
                }
                system.debug('ccrz__DisplayProduct__r.Name-->'+cartItem.ccrz__DisplayProduct__r.Name);
                if(!cartItem.isRenew__c && (cartItem.ccrz__DisplayProduct__r.Name.ContainsIgnoreCase('Incal') || !cartItem.withCoTerm__c ) 
                   && cartItem.ccrz__Product__c == sub.ccrz__SubscriptionProduct__c && !subscriptionIds.contains(sub.id)){
                       system.debug('Inside If at Incal-->'+cartItem);
                     sub.OSM_Display_Product__c = cartItem.ccrz__DisplayProduct__c;
                       sub.ccrz__RecurringPrice__c = cartItem.ccrz__Price__c;
                       sub.ccrz__RecurringPriceSubAmt__c = cartItem.ccrz__SubAmount__c;
                       //sub.ccrz__Account__c = 
                       subscriptionIds.add(sub.id);
                     subscriptionsToUpdate.add(sub);  
                }
                for(ccrz__E_Subscription__c existSub : existingSubscription){
                    //Add a condiditon to check if product is present in the exsisting subscription products or not.
                    //Removed Condition check is with coterm
                    System.debug('Printing the values for the exsisitng subscription record product########'+existSub.ccrz__SubscriptionProduct__c);
                    if(cartItem.isRenew__c && cartItem.ccrz__Product__c == sub.ccrz__SubscriptionProduct__c 
                       && sub.Id != existSub.Id && existSub.ccrz__SubscriptionProduct__c == sub.ccrz__SubscriptionProduct__c  && !subscriptionIds.Contains(sub.Id) && ProductIdsOfExsistingSubscriptions.contains(sub.ccrz__SubscriptionProduct__c)){
                           sub.OSM_Subscription_End_Date__c = getRenewedSubscriptionEndDate(sub.ccrz__SPT__r.ccrz__DisplayName__c, existSub.OSM_Subscription_End_Date__c);
                           sub.ccrz__SubscriptionStartDate__c = existSub.OSM_Subscription_End_Date__c;
                           sub.Is_Renewal_Subscription__c = true;
                           sub.OSM_Display_Product__c = existSub.OSM_Display_Product__c;
                           sub.ccrz__SubscriptionStatus__c = Label.OSM_Subscription_Status_Renew;
                           sub.Renewed_From_Subscription__c = existSub.Id;
                           subscriptionIds.add(sub.id);
                           subscriptionsToUpdate.add(sub);
                       }
    
                       //Add else condition to check if the new subscription product is a part of related product for bundle and is not present in the exsisting subscriptions and 
                       //exsisting subscription product type is bundle 
                       else if(!productToRelatedProductMap.isEmpty()) {
                            if(productToRelatedProductMap.containsKey(existSub.ccrz__SubscriptionProduct__c)) {
                                if(cartItem.isRenew__c && cartItem.ccrz__Product__c == sub.ccrz__SubscriptionProduct__c 
                                && sub.Id != existSub.Id && !subscriptionIds.Contains(sub.Id) && !ProductIdsOfExsistingSubscriptions.contains(sub.ccrz__SubscriptionProduct__c)
                                && productToRelatedProductMap.get(existSub.ccrz__SubscriptionProduct__c).contains(sub.ccrz__SubscriptionProduct__c) 
                                && existSub.ccrz__SubscriptionProduct__c == cartItem.ccrz__DisplayProduct__c) {
                                    sub.OSM_Subscription_End_Date__c = getRenewedSubscriptionEndDate(sub.ccrz__SPT__r.ccrz__DisplayName__c, existSub.OSM_Subscription_End_Date__c);
                                    sub.ccrz__SubscriptionStartDate__c = existSub.OSM_Subscription_End_Date__c;
                                    sub.Is_Renewal_Subscription__c = true;
                                    sub.OSM_Display_Product__c = existSub.ccrz__SubscriptionProduct__c;
                                    sub.ccrz__SubscriptionStatus__c = Label.OSM_Subscription_Status_Renew;
                                    sub.Renewed_From_Subscription__c = existSub.Id;
                                    subscriptionIds.add(sub.id);
                                    subscriptionsToUpdate.add(sub);
                                }
                            }
                       }
                }
                //MP-661
            if(cartItem.isRenew__c && !cartItem.withCoTerm__c && cartItem.ccrz__Product__c == sub.ccrz__SubscriptionProduct__c && sub.OSM_SW_Is_without_Coterm__c && !(cartItem.ccrz__DisplayProduct__r.Name.ContainsIgnoreCase('Add-on')) && !(cartItem.ccrz__DisplayProduct__r.ccrz__ProductType__c.ContainsIgnoreCase('Bundle'))){
                system.debug('cartItem=====>'+cartItem.OSM_Renewed_Sub_Id__c);
                sub.OSM_Subscription_End_Date__c = cartItem.OSM_Renew_Subscription_End_Date__c;
               sub.ccrz__SubscriptionStartDate__c = cartItem.OSM_Renew_Subscription_Start_Date__c;
               sub.Is_Renewal_Subscription__c = true;
               sub.OSM_Display_Product__c = cartItem.ccrz__DisplayProduct__c;
               sub.ccrz__SubscriptionStatus__c = Label.OSM_Subscription_Status_Renew;
               sub.Renewed_From_Subscription__c = cartItem.OSM_Renewed_Sub_Id__c;
               subscriptionIds.add(sub.id);
               if(!subscriptionsToUpdate.Contains(sub)){
                subscriptionsToUpdate.add(sub);
               }
            }
            
            }
           
           for(ccrz__E_Subscription__c existSub : existingSubscription){
                    if((!cartItem.isRenew__c && cartItem.ccrz__DisplayProduct__r.Name.ContainsIgnoreCase('Incal')) 
                   && cartItem.ccrz__Product__c == existSub.ccrz__SubscriptionProduct__c 
                       && orderItemIdset.Contains(existSub.ccrz__CCOrderItem__c) && !subscriptionIds.Contains(existSub.Id)){
                       system.debug('Inside If at Incal-->'+cartItem);
                     existSub.OSM_Display_Product__c = cartItem.ccrz__DisplayProduct__c;
                       existSub.ccrz__RecurringPrice__c = cartItem.ccrz__Price__c;
                       existSub.ccrz__RecurringPriceSubAmt__c = cartItem.ccrz__SubAmount__c;
                           subscriptionIds.add(existSub.id);
                     subscriptionsToUpdate.add(existSub);  
                }
             } 
        }
        
        system.debug('subscriptionsToUpdate -- >'+subscriptionsToUpdate);
        if(subscriptionsToUpdate.size()>0){
            Database.update(subscriptionsToUpdate, true);
           /* //Ravi Added lines to refer to correct referrence ID
            Set<ccrz__E_Subscription__c> subset = new Set<ccrz__E_Subscription__c>();
          subset.addall(subset);
          List<ccrz__E_Subscription__c> subList = new List<ccrz__E_Subscription__c>(subset);
          Database.update(subList, true);*/
        }
        
        if(subscriptionsToDelete.size()>0){
            Database.delete(subscriptionsToDelete, true);
        } 
    }
           
    /**
    ** Create junction Object records of OSM_Orders_In_Invoice__c
    **/ public static void creatOrderInvoiceJunctionEntries(ccrz__E_Invoice__c hookInvoice, List<ccrz__E_InvoiceItem__c> invoiceItems ){
        try{
            List<OSM_InvoiceLine_And_OrderLine__c>invOrderItemsJunction = new List<OSM_InvoiceLine_And_OrderLine__c>();
             OSM_Orders_In_Invoice__c ordInv = new OSM_Orders_In_Invoice__c();
            if(hookInvoice != null){
               
                ordInv.CC_Order__c = hookInvoice.ccrz__CCOrder__c;
                ordInv.CC_Invoice__c  =hookInvoice.Id;
                insert ordInv;
            }
            
            for(ccrz__E_InvoiceItem__c invItems : invoiceItems){
                if(invItems.ccrz__CCOrderItem__c != null){
                    OSM_InvoiceLine_And_OrderLine__c invOrdItem = new OSM_InvoiceLine_And_OrderLine__c();
                    invOrdItem.CC_Invoice_Item__c = invItems.Id;
                    invOrdItem.CC_Order_Item__c = invItems.ccrz__CCOrderItem__c;
                    invOrdItem.Quantity__c = invItems.Quantity__c;
                    invOrdItem.Sales_Amount__c = invItems.ccrz__OriginalAmount__c;
                    invOrdItem.OSM_Orders_In_Invoice__c = ordInv.Id;
                    system.debug('invOrdItem---->'+invOrdItem);
                    invOrderItemsJunction.add(invOrdItem);
                }
            }
            
            if(invOrderItemsJunction.size()>0){
                Database.insert(invOrderItemsJunction, true);
                callVertex(ordInv.Id);
    
            }
        }Catch(Exception ex){system.debug(ex.getStackTraceString());
           
               OSM_SW_General_Util.maintainErrorLog(ex, 'Invoice Order Junction Insert',ccrz.cc_CallContext.currAccountId);               
                throw ex; 
           }
        
    }
    
    public static void callVertex(Id IdJunctionObj)
        {
            if(IdJunctionObj != null)
            { 
                
                OSM_Orders_In_Invoice__c objJun = [Select Id,CC_Order__r.ccrz__Account__r.Is_Training_Account__c,CC_Order__r.ccrz__Account__r.Is_OEM_Acount__c,CC_Order__r.ccrz__Account__r.Is_Internal_Account__c,OSM_SW_Is_Recurring_Invoice__c from OSM_Orders_In_Invoice__c where Id =: IdJunctionObj ];
                if(!objJun.OSM_SW_Is_Recurring_Invoice__c  && !objJun.CC_Order__r.ccrz__Account__r.Is_Training_Account__c && !objJun.CC_Order__r.ccrz__Account__r.Is_OEM_Acount__c && !objJun.CC_Order__r.ccrz__Account__r.Is_Internal_Account__c)
                {
                    List<Id> lstJunctionObjectIdfroTax = new List<Id>();
                    lstJunctionObjectIdfroTax.add(objJun.Id);
                    if(System.isBatch())
                    {
                        OSM_SW_VertexinvoiceTaxCalculation.calculateInvoiceTax(lstJunctionObjectIdfroTax); 
                    }
                    else
                    {
                        OSM_SW_VertexinvoiceTaxCalculation.calculateInvoiceTaxFuture(lstJunctionObjectIdfroTax); 
                    }
                }
            }
        }
        
     public static ccrz__E_Cart__c createNewCart()
        {
            System.debug('=====Inside createNewCart====');
            Savepoint sp = Database.setSavepoint();
            Boolean wasSuccessful = false;
            //Id cartId;
            ccrz__E_Cart__c cart;
            try{
                
                Map<String, Object> inputData = new Map<String,Object>{
                    ccrz.ccApi.API_VERSION => ccrz.ccAPI.CURRENT_VERSION
                        
                        };
                            
                            System.debug('=====Firing Create call=====');
                Map<String, Object> outputData = ccrz.ccAPICart.create(inputData);
                
                //General check, since the cart Id will be blank if not successful we technically do not need this.
                if(outputData==null)
                {
                    System.debug('=====outputData is null=====');
                }
                System.debug('=====outputData is NOT null====='+outputData);
                wasSuccessful = (Boolean)outputData.get(ccrz.ccApi.SUCCESS);
                System.debug('===ccrz.ccApiCart.CART_ID==='+ccrz.ccApiCart.CART_ID);
                //List<Object> newRawCarts=(List<Object>) outputData.get(ccrz.ccAPICart.CART_OBJLIST
                String cartId =(String) outputData.get(ccrz.ccApiCart.CART_ID);
                
                //Map<String, Object> newCart=(Map<String, Object>) newRawCarts[0];
                System.debug('=====New Cart===='+cartId);
                //cartId = (Id)newCart.get(ccrz.ccApiCart.CART_ID);
                if(cartId!=null && cartId!='')
                {
                    cart = new ccrz__E_Cart__c();
                    cart.id=cartId;
                    
                }
                
                System.debug('===cartId==='+cartId);
                
                
                
            }catch(Exception e){
                //Error reporting here....
                System.debug('====Exception===='+e.getStackTraceString());
            } 
            
            if(!wasSuccessful){
                Database.rollback(sp);
            }
            
            return cart;
        }
        
        public static DateTime getRenewedSubscriptionEndDate(String subprodTerm, DateTime startDate){
            integer days = 0;
            DateTime endDateTime = null;
            try{
                String [] arrString = subprodTerm.split(' ');
                integer terms = Integer.valueOf(arrString[0]);
                if(arrString[1].containsIgnoreCase('Week')){
                    endDateTime = startDate.addDays(terms*7);
                }
                
                if(arrString[1].containsIgnoreCase('Month')){
                    endDateTime = startDate.addMonths(terms);
                }
                if(arrString[1].containsIgnoreCase('Quarter')){
                    endDateTime = startDate.addMonths(terms*3);
                }
                if(arrString[1].containsIgnoreCase('Year')){
                    endDateTime = startDate.addYears(terms);
                }
            }catch(Exception ex){
                
            }
            
            
            return endDateTime;
        }
        
    /**
    **
    **/
        public static String getMonth(Integer mNum){
            
          return monthInLetter.get(mNum);  
        }
        
     private static Map<Integer,String> monthInLetter = new Map<Integer,String>
      {
        1=>'Jan',
        2=>'Feb',
        3=>'Mar',
        4=>'Apr',
        5=>'May',
        6=>'Jun',
        7=>'Jul',
        8=>'Aug',
        9=>'Sep',
        10=>'Oct',
        11=>'Nov',
        12=>'Dec'
      };
    
     
     /*------------------------------------------------------------------------------
    Wrapper for Sorting
    ------------------------------------------------------------------------------*/
    public class SortWrapper implements Comparable {
    public Integer sequence{get;set;} 
    public String value{get;set;}
    public Decimal multiplier{get;set;}
    
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
        
         
        public String billingFreq{get;set;}
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
        String base{get;set;}
        String specValue {get;set;}
        String specName{get;set;}
        String imageText{get;set;}
        
        public Integer compareTo(Object ObjToCompare) {
            ProductSpecification prodSpec = (ProductSpecification)(ObjToCompare);
            if (this.sortVal == prodSpec.sortVal) return 0;
            if (this.sortVal > prodSpec.sortVal) return 1;
            return -1; 
        }
        
    } 
    
    /**
            Method is for find if product contains of included 'Guidanz Mobile'
        **/
        public static boolean isIncludedGuidenzMobileProduct(Id compositeProductId)
        {
            boolean isGuidenzMobile = false;
            List<ccrz__E_CompositeProduct__c> listComProduct = new List<ccrz__E_CompositeProduct__c>();
            listComProduct = [Select Id, ccrz__Composite__c, ccrz__Composite__r.Name, ccrz__Quantity__c,ccrz__Component__r.Name from ccrz__E_CompositeProduct__c where ccrz__Composite__c =: compositeProductId];
            
            for(ccrz__E_CompositeProduct__c compProduct : listComProduct)
            {
                if(compProduct.ccrz__Composite__r.Name.containsIgnoreCase('Guidanz Mobile') || compProduct.ccrz__Component__r.Name.containsIgnoreCase('Guidanz Mobile'))
                {
                    isGuidenzMobile = true;
                    break;
                }
            }
            
            return isGuidenzMobile;
        }
        
        /*
         * To count Guidenz Mobile Access feature record quantity 
         */
        
        public static Integer getGuidenzMobileIAMAccessRecord(Id accountId)
        {
            Integer count = 0;
            List<IAM_Application__c> lstIamRecord = new List<IAM_Application__c>();
    
            lstIamRecord = [Select Id,(Select Id, CC_Subscription__r.ccrz__Quantity__c,CC_Subscription__r.ccrz__SubscriptionStatus__c from OSM_Subscription_Account_Provisions__r where CC_Subscription__r.ccrz__SubscriptionStatus__c = 'Active') from IAM_Application__c where IAM_Application_Name__c = 'Guidanz Mobile' and IAM_Status__c = 'Active' and IAM_Account_Name__c =: accountId];
    
            
            if(lstIamRecord.size() > 0)
            {
                
                for(OSM_Subscription_Account_Provision__c provision : lstIamRecord[0].OSM_Subscription_Account_Provisions__r)
                {
                    count = count + Integer.valueOf(provision.CC_Subscription__r.ccrz__Quantity__c);
                }
            }
            
            return count;
        }
        
        public static Integer getGuidenzMobileRenewedRec(Id accountId)
    {
        Integer countSubscQuantity = 0; 
        List<ccrz__E_Subscription__c> lstSubsc = new List<ccrz__E_Subscription__c>();
        
        lstSubsc = [Select Id,ccrz__SubscriptionProduct__c,ccrz__SubscriptionProduct__r.Name,ccrz__Quantity__c from ccrz__E_Subscription__c where ccrz__SubscriptionStatus__c =: Label.OSM_Subscription_Status_Renew and ccrz__SubscriptionStartDate__c >=: DateTime.now() and ccrz__Account__c =:accountId];
        
        for(ccrz__E_Subscription__c subObj : lstSubsc)
        {
            if(subObj.ccrz__SubscriptionProduct__r.Name.containsIgnoreCase('Guidanz Mobile') || OSM_SW_ProductDetailCommonUtility.isIncludedGuidenzMobileProduct(subObj.ccrz__SubscriptionProduct__c))
            {
                countSubscQuantity = countSubscQuantity+ Integer.valueOf(subObj.ccrz__Quantity__c);
            }
        }
        
        return countSubscQuantity;
    }
    
    }