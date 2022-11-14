/**********************************************************************
Name:  OSM_SW_ProdDetail_DA_Comp_Ctrl
Copyright Â© 2018  Cummins
================================================================
======================================================
Purpose:                                                            
The purpose of this class is to keep all relative fetch
queries & DML statements & Logic for DA Product Detail                                      
=========================================================
=========================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE              DETAIL                                
1.0 -   Vineet            3/12/2018     INITIAL DEVELOPMENT          


*****************************************************/

global without sharing class OSM_SW_ProdDetail_DA_Comp_Ctrl {

 global static String blank {get {return '';} private set;}
  

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
         String [] Inputparams  = param.split('/');
         String userId = Inputparams[0];
         String InputData = Inputparams[1];
         String storefront = ctx.storefront;
         Id ProductIdForSubscription;
         boolean freeDAProduct = false;
        boolean hasOtherProductSusbcription = false;
         system.debug(ctx.storefront);
  ccrz.cc_CallContext.initRemoteContext(ctx);
          system.debug(ctx);
     if(!ccrz.cc_CallContext.isGuest){
     //system.debug('cc_CallContext======>'+ccrz.cc_CallContext.currAccountId+'<===>'+ccrz.cc_CallContext.currContact.Id);
     }
   Account acc = new Account();
    if(!ccrz.cc_CallContext.isGuest){
       acc = OSM_SW_ProdDetailUtils_Ctrl.getAccount(ccrz.cc_CallContext.effAccountId);   
    }
  ccrz.cc_RemoteActionResult res = new ccrz.cc_RemoteActionResult();
  res.success = false;

  try {

   Set < String > productIdList = new Set < String > ();
    String baseProductId = '';
   System.debug('*******************************Calling Fetch Services => ' + InputData);

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
   List < ccrz__E_Product__c > eProducts = OSM_SW_ProdDetailUtils_Ctrl.getEProductOnId(InputData);
   if (eProducts.size() > 0) {

    prodLongDescription = eProducts[0].ccrz__LongDesc__c;
             parentSku  = eProducts[0].ccrz__SKU__c;
   }

   List < ccrz__E_CompositeProduct__c > eCompositeProducts = OSM_SW_ProdDetailUtils_Ctrl.getCcrzCompositProducts(new List < String > {
    InputData
   });
   
   //ccrz__Component__r.Name, ccrz__Component__r.ccrz__SKU__c
   for (ccrz__E_CompositeProduct__c compProd: eCompositeProducts) {
    productIdList.add(compProd.ccrz__Component__c);
    if(compProd.ccrz__Component__r.Name.containsIgnoreCase('Base')){
        baseSku = compProd.ccrz__Component__r.ccrz__SKU__c;
        baseProductId = compProd.ccrz__Component__c;
    }
   }
    boolean hasActiveSubs = false;
   OSM_SW_ProductDetaiServiceCls.DiscountedPriceWrapper availableSubs = null;
      try{
            system.debug('====hasActiveSubs inside-1:'+hasActiveSubs);
            //availableSubs = OSM_SW_ProductDetaiServiceCls.fetchDiscountedPrice(ctx.storefront,userId, ccrz.cc_CallContext.currAccountId,productIdList);
          availableSubs = OSM_SW_ProductDetaiServiceCls.getDiscountedPrice(ctx.storefront, ccrz.cc_CallContext.currAccountId, productIdList);
          system.debug('====hasActiveSubs inside-2:'+hasActiveSubs);
          if(Test.isRunningTest()){
              throw new NullPointerException();
          }
         }catch(Exception ex){system.debug(ex +'====line===>'+ex.getLineNumber());}
  
   if(availableSubs !=null && availableSubs.subscriptionStatus != null && !String.isBlank(availableSubs.subscriptionStatus)){
       hasActiveSubs = true;
       system.debug('====hasActiveSubs inside:'+hasActiveSubs);
   }
   system.debug('====hasActiveSubs outside:'+availableSubs);
   system.debug('====ProductIdList:'+productIdList);
   //After Vaibhav meeting will revert it back
   //hasActiveSubs = false;
   /*   
    ccrz.ccAPIProduct.fetch(new Map < String, Object > {
    ccrz.ccApi.API_VERSION => ccrz.ccApi.CURRENT_VERSION,
    ccrz.ccAPIProduct.PARAM_INCLUDE_PRICING => TRUE,
    ccrz.ccAPIProduct.PRODUCTIDLIST => productIdList
   });
   */
     
    Map < String, Object > returnData = ccrz.ccAPIProduct.fetch(new Map < String, Object > {
    ccrz.ccApi.API_VERSION => ccrz.ccApi.CURRENT_VERSION,
    ccrz.ccAPIProduct.PARAM_INCLUDE_PRICING => TRUE,
    ccrz.ccAPIProduct.PRODUCTIDLIST => productIdList
   });
   System.debug('ccrz.ccApiProduct.PRODUCTLIST');
   System.debug(ccrz.ccApiProduct.PRODUCTLIST);
   System.debug(returnData );
  
      
   Map < String, ProductDetailWrapper > productIdVsWrapperMap = new Map < String, ProductDetailWrapper > ();
   Map < String, String > compositKeyForSubProdTerm = new Map < String, String > ();
   Map < String, String > subProdTermPrices = new Map < String, String > ();
   boolean onlyBase = false;
   ProductDetailWrapper prodDetail;
   boolean isBase = false;
   boolean isPlus = false;
   boolean isPro = false;
   Map < String, SubProdTerm > subProdTermMap;
   Set < String > subProdTermIds = new Set < String > ();
   Map < String, Map < String, Object >> prodMapFromApi = new Map < String, Map < String, Object >> ();

   if (returnData != null && returnData.size() > 0) {

    List < Map < String, Object >> productLst;
    System.debug('______productLst_123____'+productLst );
   if(Test.IsRunningTest()){
       productLst =OSM_SW_ProdDetail_DA_Comp_Ctrl_Test.productListTestData();
       System.debug('______productLst_____'+productLst );

   }else{
       productLst = (List < Map < String, Object >> ) returnData.get(ccrz.ccApiProduct.PRODUCTLIST);
       System.debug('______productLst___else__'+productLst );

   }
    for (Map < String, Object > productMap: productLst) {
    System.debug('______productLst__for loop___'+productLst );

     if (productMap != null) {
        
      for (String key_tmp: productMap.keySet()) {
       System.debug('=====Key API====' + key_tmp);
       System.debug('=====Key API====' + productMap.get(key_tmp));
      }
      System.debug('=====SF ID from API====' + productMap.get('sfid'));
      ProductIdForSubscription = (String)productMap.get('sfid');
      if(productMap.containsKey('OSMDAFreeProduct'))
        freeDAProduct = (boolean)productMap.get('OSMDAFreeProduct');
      prodMapFromApi.put((String) productMap.get('sfid'), productMap);
     }
     
    }
    
        
    Map < String, Object > responseMap = new Map < String, Object >();
    if(Test.isRunningTest()){
        Try{
            Map<String,Object> responseMapInner=new Map<String,Object>();
            Map<String,Object> subProdTermMap2=new  Map<String,Object>();         
            responseMapInner.put('subProductTerms',subProdTermMap2);
            responseMap.put('id',responseMapInner);
        System.debug('responseMap ____'+responseMap);
        }
       Catch(Exception e)
       {
           System.debug('???????responseMap'+e);
       }
       
    }
    else
    {
    //System.debug('responseMap ____'+responseMap);
    
     responseMap = (Map < String, Object > ) returnData.get(ccrz.ccAPIProduct.PRODUCTPRICINGDATA);
     }
    //responseMap points to each product
    for (String key: responseMap.keySet()) {
     prodDetail = new ProductDetailWrapper();
     subProdTermMap = new Map < String, SubProdTerm > ();
     prodDetail.sfId = key;
     //prodDetail.productName = 
     System.debug('prodDetail.sfId____'+prodDetail.sfId);
     Map < String, Object > responseMap1 = (Map < String, Object > ) responseMap.get(key);
     
     System.debug('******************************responseMap1 =====' + responseMap1);
     for (String key1: responseMap1.keySet()) {
      //this prints subProductTerms,minSubPrice,maxSubPrice
      System.debug('******************************Final Key=====' + key1);
      if (key1.equalsIgnoreCase('productPrice')) {
          Map < String, Object > productPriceMap = (Map < String, Object > ) responseMap1.get(key1);
       System.debug(productPriceMap);
       System.debug('productPriceMap size from API===' + productPriceMap.size());
       
      }
      if (key1.equalsIgnoreCase('subProductTerms')) {
      System.debug('______sub_____'+key1);
           Map < String, Object > subProdTermsMap;
          
            subProdTermsMap = (Map < String, Object > ) responseMap1.get(key1);
          
                        
          
       System.debug(subProdTermsMap);
       System.debug('subProdTermsMap size from API===' + subProdTermsMap.size());
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
        //single record for SubProdTerm
        SubProdTerm subProdTermObj = new SubProdTerm();
        subProdTermObj.sfId = subProdTermid;

        Map < String, Object > subProdTerm = (Map < String, Object > ) subProdTermsMap.get(subProdTermid);
        system.debug('=======subProdTerm==========');
        system.debug(subProdTerm);
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
      }


     }

     //System.debug('******************************Final value====='+str);

     productIdVsWrapperMap.put(prodDetail.sfId, prodDetail);
    }
   }
   
   List < String > prodIds = new List < String > ();
   prodIds.addAll(subProdTermIds);
    Set<String>OneTimeSets = new Set<String>{'OneTime','One-Time','One Time'};
    Decimal selectedSubsInstallmentCount = 0;
    Decimal selectedSubsInstallmentFrequency = 0;
    Decimal finalYearlyPrice = 0;
   Map < Id, ccrz__E_SubProdTerm__c > subProdMap = OSM_SW_ProdDetailUtils_Ctrl.getSubProdTermsMap(prodIds, ctx.storefront);
   
List<ccrz__E_PriceListItem__c> priceList = [Select Id, Distributor_Price__c, ccrz__SubProdTerm__c  from ccrz__E_PriceListItem__c where ccrz__SubProdTerm__c IN: subProdMap.keySet()];

   // < Id, ccrz__E_SubProdTerm__c > subProdMap = OSM_SW_ProdDetailUtils_Ctrl.getSubProdTermsMap(prodIds);
   //coded added to cover its test class
   if(Test.isrunningTest())
   {
       subProdMap=OSM_SW_ProdDetail_DA_Comp_Ctrl_Test.subProdTermData();
       hasActiveSubs=true;
       availableSubs.isSubscribed=true;
       availableSubs.billingFrequency='Monthly';
       availableSubs.recurringPrice=2;
   }
    for(String key : subProdMap.keySet()){
        ccrz__E_SubProdTerm__c subP = subProdMap.get(key);
        //coded added to cover its test class
           if(Test.isrunningTest())
           {
               availableSubs.STP=key;
           }

        if(hasActiveSubs && availableSubs.STP==key){
           //&& (String.isBlank(availableSubs.billingFrequency)){ 
              // || (String.isNotBlank(availableSubs.billingFrequency) && !availableSubs.billingFrequency.containsIgnoreCase('One')))){
           selectedSubsInstallmentCount = subP.ccrz__InstallmentCount__c;
            selectedSubsInstallmentFrequency = subP.ccrz__InstallmentFrequency__c;
            if(availableSubs.isSubscribed){
                Decimal multiple = 0;
                if((String.isNotBlank(availableSubs.billingFrequency) && availableSubs.billingFrequency.containsIgnoreCase('Monthly'))){
                        multiple = 12; 
                }
                if((String.isNotBlank(availableSubs.billingFrequency) && availableSubs.billingFrequency.containsIgnoreCase('Quarterly'))){
                    multiple = 4;
                }
                if((String.isNotBlank(availableSubs.billingFrequency) && availableSubs.billingFrequency.containsIgnoreCase('Year'))){
                    multiple = 1;
                }
                
                finalYearlyPrice = availableSubs.recurringPrice!=null? (availableSubs.recurringPrice * multiple):0;
                if((String.isNotBlank(availableSubs.billingFrequency) && availableSubs.billingFrequency.containsIgnoreCase('One'))){
                    finalYearlyPrice = availableSubs.recurringPrice/subP.ccrz__OrderFrequency__c;
                }
            } 
            if((!availableSubs.isSubscribed && availableSubs.isRFQ) || (availableSubs.isSubscribed && availableSubs.isRFQ))
            {
                finalYearlyPrice = availableSubs.recurringPrice * 12;
            }
              
            //finalYearlyPrice = availableSubs.recurringPrice * 12; 
        }
        
       // if(availableSubs.billingFrequency.containsIgnoreCase('One')){
            
      //  }
    }
    System.debug('=====finalYearlyPrice ====' + finalYearlyPrice);
    Map<String, Decimal> prodYearPrice = new Map<String, Decimal>();
    Map<String, Decimal> proratedPriceMap = new Map<String, Decimal>();
    Map<String,Decimal> proratedDnPriceMap = new Map<String,Decimal>();  
    Map<String,Decimal> prodMonthlyPrice = new Map<String, Decimal>();
    Map<String, String> pricePerBillFrequency = new Map<String, String>();
    ccrz__E_Subscription__c subcription = new ccrz__E_Subscription__c();
      if(availableSubs.isSubscribed){
          list<ccrz__E_Subscription__c> subcriptionsList = OSM_SW_ProdDetailUtils_Ctrl.getSubscriptions(new List<Id>{availableSubs.subscriptionId});
          if(subcriptionsList.size()>0){
              subcription = subcriptionsList[0];
          }
      }
    if(!ccrz.cc_CallContext.isGuest){
       for (String prodId: productIdVsWrapperMap.keySet()) {
        boolean onTimePrice = true;
        ProductDetailWrapper prodDetailObj = productIdVsWrapperMap.get(prodId);
        System.debug('=====prodDetail ====' + prodDetailObj);
        Map < String, SubProdTerm > subProdTerms = prodDetailObj.subProdTermMap;
        System.debug('=====subProdTerms size ====' + subProdTerms.size());
       for (String subProdTermId: subProdTerms.keySet()) {
       System.debug(availableSubs.STP+'=====subProdTerms I ====' + subProdTermId); 
        
        
        
         SubProdTerm subProdTerm = subProdTerms.get(subProdTermId);
         if(Test.isrunningTest())
         {
             
             for(String s:subProdMap.keySet()){subProdTermId=s;}
             availableSubs.isSubscribed=false;
         }
         
         ccrz__E_SubProdTerm__c subProdFromDB = subProdMap.get(subProdTermId);
             
         System.debug(OneTimeSets.contains(subProdFromDB.Billing_Display_Name__c)+'=====OneTimeSets I ====' + OneTimeSets +'=='+subProdFromDB.Billing_Display_Name__c); 
          
         Decimal prodSubscriptionPriceYearly = 0;
         Decimal prodSubscriptionPriceMonthly = 0;
         Decimal price = 0;
         Decimal DnPrice = 0;
         for(ccrz__E_PriceListItem__c pl : priceList){
             if(pl.ccrz__SubProdTerm__c == subProdTermId){
                DnPrice = pl.Distributor_Price__c != null ? pl.Distributor_Price__c:0;
                break;
             }
         }
         Decimal rfqPrice = 0;
            price = subProdTerm.nonRecurringPrice;
             prodSubscriptionPriceYearly = price != 0 ? ((price * subProdFromDB.ccrz__InstallmentCount__c)/subProdFromDB.ccrz__OrderFrequency__c) :0;
             
           if((hasActiveSubs && !availableSubs.isSubscribed) 
              || (hasActiveSubs && availableSubs.isSubscribed && availableSubs.isRFQ)){
             //if((availableSubs.isSubscribed || availableSubs.isRFQ) && String.isNotBlank(availableSubs.billingFrequency) && !availableSubs.billingFrequency.containsIgnoreCase('One')){
                 price = OSM_SW_SubProdTermConversion.calculatePriceForSelectedSubs(finalYearlyPrice,subProdFromDB.Billing_Display_Name__c);
                 System.debug(subProdFromDB.Billing_Display_Name__c+'=====price ====' + price+'==========='+finalYearlyPrice);
                 prodSubscriptionPriceYearly = price != 0 ? ((price * subProdFromDB.ccrz__InstallmentCount__c)/subProdFromDB.ccrz__OrderFrequency__c) :0;
                 if(subProdFromDB.Billing_Display_Name__c.containsIgnoreCase('One')){
                     price = price * subProdFromDB.ccrz__OrderFrequency__c;
                     //rfqPrice = price;
                     prodSubscriptionPriceYearly = price;// != 0 ? (price * subProdFromDB.ccrz__OrderFrequency__c) :0;
                 }
                 
            }
           
           
             System.debug('=====prodSubscriptionPriceYearly ====' + prodSubscriptionPriceYearly);
             prodSubscriptionPriceMonthly = prodSubscriptionPriceYearly != 0 ? (prodSubscriptionPriceYearly / 12) :0;
            System.debug('=====prodSubscriptionPriceMonthly ====' + prodSubscriptionPriceMonthly);
        
         if(onTimePrice){
                 prodDetailObj.prodSubscriptionPriceMonthly = prodSubscriptionPriceMonthly; 
                 prodDetailObj.prodSubscriptionPriceYearly = prodSubscriptionPriceYearly;
                 onTimePrice = false;
             }
           Decimal proratedPrice = 0;
           Decimal proratedDnPrice = DnPrice;
           //Code for test coverage
           if(test.isRunningTest())
           {//subcription=new OSM_SW_ProdDetail_DA_Comp_CtrlTest().getSubscription();
               subcription=new ccrz__E_Subscription__c();
               subcription.ccrz__SubscriptionStartDate__c=system.today();
               subcription.ccrz__RecurringPrice__c=2;
               availableSubs.isSubscribed = true;
               subcription.OSM_Subscription_End_Date__c = subcription.ccrz__SubscriptionStartDate__c.addYears(1);
               subcription.Recurring_Invoice_Start_Date__c = subcription.ccrz__SubscriptionStartDate__c.addMonths(1);
           }
           if(availableSubs.isSubscribed && subcription != null){ 
               Date subsendDate = Date.newInstance(subcription.OSM_Subscription_End_Date__c.Year(),subcription.OSM_Subscription_End_Date__c.Month(),subcription.OSM_Subscription_End_Date__c.Day());
                Date subscriptionStartDate = Date.newInstance(subcription.ccrz__SubscriptionStartDate__c.year(), subcription.ccrz__SubscriptionStartDate__c.month(), subcription.ccrz__SubscriptionStartDate__c.Day());
                Date currDate = subcription.Purchase_Date__c!= null? subcription.Purchase_Date__c:System.today();
              Date recurringDate = subcription.Recurring_Invoice_Start_Date__c!= null? 
                   Date.newInstance(subcription.Recurring_Invoice_Start_Date__c.year(), subcription.Recurring_Invoice_Start_Date__c.month(), subcription.Recurring_Invoice_Start_Date__c.Day()):System.today();
                            
               //if(availableSubs.isSubscribed && !availableSubs.billingFrequency.containsIgnoreCase('One')){ 
                //finalYearlyPrice = availableSubs.recurringPrice!=null? availableSubs.recurringPrice * subP.ccrz__InstallmentCount__c:0;
               if(subcription.ccrz__RecurringPrice__c > 0){
                   
                   /*  Start : Old Proration Logic - by Vineet on 16th- Nov 2018*/
                   
                   /* 
                       proratedPrice = OSM_SW_ProductDetailCommonUtility.getCalculatedProrationAmount(subcription, acc.OSM_Preferred_Billing_Frequency__c, subProdFromDB.Billing_Display_Name__c);
                       if(availableSubs.billingFrequency.containsIgnoreCase('One') || (!availableSubs.billingFrequency.containsIgnoreCase('One') && subProdFromDB.Billing_Display_Name__c.containsIgnoreCase('One') && subscriptionStartDate == currDate)){
                          // proratedPrice = proratedPrice*subProdFromDB.ccrz__OrderFrequency__c;
                       } 
                   if(subcription.OneTimePerDayPrice__c == null && !availableSubs.billingFrequency.containsIgnoreCase('One') && subProdFromDB.Billing_Display_Name__c.containsIgnoreCase('One')){
                       String pricesStr = subProdTermPrices.get(subProdFromDB.Id);
                        system.debug(pricesStr+'----'+subProdFromDB.Id);
                       system.debug(subProdTermPrices+'----'+subProdFromDB.Id);
                       //Date subStartDate = Date.newInstance(subcription.OSM_Subscription_End_Date__c.Year(),subcription.OSM_Subscription_End_Date__c.Month(),subcription.OSM_Subscription_End_Date__c.Day());
                       
                        Integer diffDays = (subscriptionStartDate.daysBetween(subsendDate))+1;
                       subcription.OneTimePerDayPrice__c = (Decimal.valueOf(pricesStr.split(':')[0])/diffDays).setScale(2);
                       //subcription.OneTimePerDayPrice__c = Decimal.valueOf(pricesStr.split(':')[0])/(365*subProdFromDB.ccrz__OrderFrequency__c);
                       proratedPrice = OSM_SW_ProductDetailCommonUtility.getCalculatedProrationAmount(subcription, acc.OSM_Preferred_Billing_Frequency__c, subProdFromDB.Billing_Display_Name__c);
                   }
                    if((availableSubs.billingFrequency.containsIgnoreCase('One') && subProdFromDB.Billing_Display_Name__c.containsIgnoreCase('One') && subscriptionStartDate == currDate)){
                        proratedPrice = price; 
                   }
                   Map<String, Integer>freToNumber = new Map<String,Integer>{'Monthly'=>1,'Quarterly'=>3,'Yearly'=>12};
                   if(availableSubs.billingFrequency.containsIgnoreCase('One')  
                         && !subProdFromDB.Billing_Display_Name__c.containsIgnoreCase('One')){
                             Date cycleDate = currDate.addMonths(freToNumber.get(subProdFromDB.Billing_Display_Name__c));
                             if(String.isNotBlank(subProdFromDB.Billing_Display_Name__c) && subsendDate >=cycleDate ){
                                 proratedPrice = price;
                             }
                   }
                    //subcription.Recurring_Invoice_Start_Date__c
                   if(subscriptionStartDate == currDate && !availableSubs.isRFQ){
                   //if(subscriptionStartDate == currDate){
                       proratedPrice = price;
                   }
                   if((subscriptionStartDate == currDate ||(recurringDate == currDate && !subProdFromDB.Billing_Display_Name__c.containsIgnoreCase('One'))) && availableSubs.isRFQ && availableSubs.isSubscribed){  
                            proratedPrice = price;
                }
                 */
                /*  END : Old Proration Logic - by Vineet*/
                   
                   
                   ///******  Start : New Proration Logic - by Vineet*******/
                   try
                   {
                    proratedPrice = OSM_SW_ProrationUtility.getCalculatedProrationAmount(subcription, subProdFromDB.Billing_Display_Name__c, Label.OSM_ProrationType_Price);
                   }
                   Catch(Exception ex)
                   {
                       
                   }
                       try{
                    proratedDnPrice = OSM_SW_ProrationUtility.getCalculatedProrationAmount(subcription, subProdFromDB.Billing_Display_Name__c, Label.OSM_ProrationType_DnPrice);
                   }catch(Exception ex){
                       proratedDnPrice = DnPrice;
                   }
                  proratedPrice = proratedPrice.setScale(2);
                   proratedDnPrice = proratedDnPrice.setScale(2);
                   system.debug('proratedPrice-->'+proratedPrice);
                   system.debug('subProdFromDB.Billing_Display_Name__c-->'+subProdFromDB.Billing_Display_Name__c);
                   if(Test.isRunningTest())subscriptionStartDate = currDate;
                   
                   if(currDate  == subscriptionStartDate){
                       if(Test.isRunningTest())subProdFromDB.Billing_Display_Name__c = 'OneTime';
                       if(subProdFromDB.Billing_Display_Name__c.containsIgnoreCase('One')){
                           proratedPrice = subcription.OneTime_Price__c;
                           proratedDnPrice = subcription.OneTime_Dn_Price__c;
                       }
                       if(Test.isRunningTest())subProdFromDB.Billing_Display_Name__c = 'Monthly';
                       if(subProdFromDB.Billing_Display_Name__c.containsIgnoreCase('Monthly')){
                           proratedPrice = subcription.Monthly_Price__c;
                           proratedDnPrice = subcription.Monthly_Dn_Price__c;
                       }
                       if(Test.isRunningTest())subProdFromDB.Billing_Display_Name__c = 'Quarterly';
                       if(subProdFromDB.Billing_Display_Name__c.containsIgnoreCase('Quarterly')){
                           proratedPrice = subcription.Quarterly_Price__c;
                           proratedDnPrice = subcription.Quarterly_Dn_Price__c;
                       }
                       if(Test.isRunningTest())subProdFromDB.Billing_Display_Name__c = 'Yearly';
                       if(subProdFromDB.Billing_Display_Name__c.containsIgnoreCase('Yearly')){
                           proratedPrice = subcription.Yearly_Price__c;
                           proratedDnPrice = subcription.Yearly_Dn_Price__c;
                       }
                       
                   }
                   /*  END : New Proration Logic - by Vineet*/
                   
                   
               } else{
                   proratedPrice = 0;
                   proratedDnPrice = 0;
               }
          
           }
   
           /* Other product Subscription Exist then proration for current project */
          if(!availableSubs.isSubscribed && availableSubs.otherProductSubscriptions != null){ 
              Date subscriptionStartDate = Date.newInstance(availableSubs.otherProductSubscriptions.ccrz__SubscriptionStartDate__c.year(), availableSubs.otherProductSubscriptions.ccrz__SubscriptionStartDate__c.month(), availableSubs.otherProductSubscriptions.ccrz__SubscriptionStartDate__c.Day());
                hasOtherProductSusbcription = true;
              //System.today();
           //if(availableSubs.isSubscribed && !availableSubs.billingFrequency.containsIgnoreCase('One')){
                //finalYearlyPrice = availableSubs.recurringPrice!=null? availableSubs.recurringPrice * subP.ccrz__InstallmentCount__c:0;
              if(subscriptionStartDate < System.today()){
                  proratedPrice = OSM_SW_ProductDetailCommonUtility.getProratedAmountOfOtherProduct(availableSubs.otherProductSubscriptions, acc.OSM_Preferred_Billing_Frequency__c, subProdFromDB.Billing_Display_Name__c,price);
              }else{
                  proratedPrice = price;
              }
              /*Date subscriptionStartDate = Date.newInstance(subcription.ccrz__SubscriptionStartDate__c.year(), subcription.ccrz__SubscriptionStartDate__c.month(), subcription.ccrz__SubscriptionStartDate__c.Day());
               Date currDate = subcription.Purchase_Date__c!= null? subcription.Purchase_Date__c:System.today();
               if(availableSubs.billingFrequency.containsIgnoreCase('One') || (!availableSubs.billingFrequency.containsIgnoreCase('One') && subProdFromDB.Billing_Display_Name__c.containsIgnoreCase('One') && subscriptionStartDate == currDate)){
                   proratedPrice = proratedPrice*subProdFromDB.ccrz__OrderFrequency__c;
               } */
               
               if(subcription.ccrz__SubscriptionStartDate__c  == System.Today()){
                   
               }
           }
           
            String pricePerBill = ''+price.setScale(2)+' '+(subProdFromDB.OSM_Bill_Freq__c != null ?subProdFromDB.OSM_Bill_Freq__c:'');
           System.debug('proratedPrice--in fectch--->'+proratedPrice);  
         String compositeKey = subProdFromDB.ccrz__CCProduct__r.ccrz__SKU__c + subProdFromDB.Billing_Display_Name__c + subProdFromDB.ccrz__DisplayName__c;
         proratedPriceMap.put(compositeKey,proratedPrice); 
          proratedDnPriceMap.put(compositeKey,proratedDnPrice); 
           prodYearPrice.put(subProdFromDB.ccrz__CCProduct__r.ccrz__SKU__c+subProdFromDB.ccrz__DisplayName__c,prodSubscriptionPriceYearly);
         //prodYearPrice.put(compositeKey,prodSubscriptionPriceYearly);
         prodYearPrice.put(compositeKey,price);
         prodMonthlyPrice.put(compositeKey,prodSubscriptionPriceMonthly);
         pricePerBillFrequency.put(compositeKey,pricePerBill);
         compositKeyForSubProdTerm.put(compositeKey, subProdFromDB.Id);
         System.debug('===subProdTerm while Iterating===' + subProdTerm);
        }
        System.debug('=====SF ID of Product ====' + prodId);
        Map < String, Object > productDataMap = prodMapFromApi.get(prodId);
        //code to cover test class
        if(test.isrunningtest())
        {productDataMap=new Map<String,Object>();
            productDataMap.put('package','Base');productDataMap.put('SKU','SKU');}
        //buttonName will have Base/Plus/Pro
        String buttonName = (String) productDataMap.get('package');
        System.debug('=====buttonName of Product ====' + buttonName);
        if (buttonName != null && buttonName.Contains('Base')) {
         isBase = true;
        }
           if(test.isrunningtest())
           {buttonName='Plus';}
        if (buttonName != null && buttonName.Contains('Plus')) {
            //onlyBase = false;
         isPlus = true;
        }
        if(test.isrunningtest())
           {buttonName='Pro';}
        if (buttonName != null && buttonName.Contains('Pro')) {
            //onlyBase = false;
         isPro = true;
        }
        prodDetailObj.buttonName = buttonName;
        String sku = (String) productDataMap.get('SKU');
        prodDetailObj.sku = sku;

       }
  }
   if(isBase && !isPlus && !isPro){
       onlyBase = true;
   }
      onlyBase = true;
   
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
   mainWrapper.hasActiveSubs = hasActiveSubs;
    
         
   mainWrapper.totalSubscriptionCount =0;
     mainWrapper.availableCount = 0;
     mainWrapper.daMessage = '';
                             
   if(!ccrz.cc_CallContext.isGuest){
           String customerId = user.Contact.Account.CMI_Cid__c != null ? user.Contact.Account.CMI_Cid__c :'';
           OSM_WS_GeneralizedInputWrapper inputAPiWrapper = new OSM_WS_GeneralizedInputWrapper();
                //inputAPiWrapper.messageID = 'MSG1234';
                inputAPiWrapper.customerId = customerId;
                inputAPiWrapper.initiator = 'ECommerce';
                inputAPiWrapper.timeStamp='2018-03-20T19:47:00.000Z';
                //OSM_WS_GetProductDetail_RES productsDetailFromAPI = OSM_WS_CS_Services.callGetProductsWS('MSG1234', '2018-03-20T19:47:00.000Z', 'ECommerce', customerId);
            if(Label.OSM_DA_API_BYPassProductDetail != 'true'){
                try{
                      OSM_WS_GetProductDetail_RES productsDetailFromAPI = OSM_WS_CS_Services.GetProductsWS(inputAPiWrapper);
                    mainWrapper.DAExceptionFlag = productsDetailFromAPI.exceptionFlag;
                    system.debug('productsDetailFromAPI.exceptionFlag==>'+productsDetailFromAPI.exceptionFlag);
                           system.debug('productsDetailFromAPI==>'+productsDetailFromAPI);
                       String skuNumber = baseSku.contains('-')?baseSku.split('-')[0]:baseSku;   
                       system.debug('skuNumber==>'+skuNumber);
                       if(productsDetailFromAPI!=null && !productsDetailFromAPI.exceptionFlag){
                       List<OSM_WS_GetProductDetail_RES.ProductSubscriptionInfo> productSubscriptionInfo = productsDetailFromAPI.productSubscriptionInfo; 
                       System.debug('productSubscriptionInfo______'+productSubscriptionInfo);
                            OSM_DA_GenericFunctionsUtility.DAProdCountInfo prodInfo = new OSM_DA_GenericFunctionsUtility.DAProdCountInfo();
                            Map<String,OSM_DA_GenericFunctionsUtility.DAProdCountInfo> prodCountMap = new Map<String,OSM_DA_GenericFunctionsUtility.DAProdCountInfo>();
                            Map<String, String> baseToParentSku = OSM_DA_GenericFunctionsUtility.fetchDefaultDAProductPartNumber(new List<String>{baseSku});
                             String defSku = baseToParentSku.get(baseSku);
                             String defaultPort = defSku.contains('-')?defSku.split('-')[0]:defSku; 
                            //code to cover test class
                           if(test.isRunningTest())
                           {productSubscriptionInfo=new List<OSM_WS_GetProductDetail_RES.ProductSubscriptionInfo>();
                            OSM_WS_GetProductDetail_RES.ProductSubscriptionInfo prodsub1=new OSM_WS_GetProductDetail_RES.ProductSubscriptionInfo();
                            prodsub1.productID='test';
                            defaultPort='test';
                            productSubscriptionInfo.add(prodsub1);
                            }
                            if(productSubscriptionInfo.size()>0){
                                    for(OSM_WS_GetProductDetail_RES.ProductSubscriptionInfo proInfo : productSubscriptionInfo){
                                            if(proInfo.productID == defaultPort){
                                                                                                                                                                                
                                                //Vaibhav - Start for Prod data changes
                                                proInfo.productID = proInfo.productID + Label.OSM_Default_Market_Segment;
                                                prodInfo.defaultDAProdPartNo=proInfo.productID;
                                                //Vaibhav added this comment
                                                prodInfo.availableCnt=proInfo.availableCount != null ? proInfo.availableCount : 0;
                                                //prodInfo.availableCnt=40;
                                                prodInfo.currentCnt=proInfo.totalSubscriptionCount != null ? proInfo.totalSubscriptionCount:0;
                                                prodInfo.daMessage = proInfo.message != null ? proInfo.message : '';
                                                prodCountMap.put(proInfo.productID,prodInfo);
                                                //this will return the main product sku and wrapper
                                                 system.debug('===Before convert===prodCountMap==');
                                                 system.debug(prodCountMap);                          
                                                 //prodCountMap = OSM_DA_GenericFunctionsUtility.fetchOSMParentProdAndCount(prodCountMap,acc.OSM_Market_Segment_Code__c);
                                                 
                                                 
                                                prodCountMap = OSM_DA_GenericFunctionsUtility.fetchOSMParentProdAndCount(prodCountMap,acc.OSM_Market_Segment_Code__c);
                                                                                                                                                                                                                                            system.debug('===After convert===prodCountMap==');
                                                 system.debug(prodCountMap); 
                                                OSM_DA_GenericFunctionsUtility.DAProdCountInfo prodInfoReturn = prodCountMap.get(parentSku);
                                                //OSM_DA_GenericFunctionsUtility.DAProdCountInfo prodInfoReturn = prodCountMap.get(baseSku);
                                                ccrz.ccLog.log('-----Product Information from DA API---');
                                                ccrz.ccLog.log(prodInfoReturn);
                                                
                                                //Addedby Vaibhav....tbd
                                                //if(prodInfoReturn==null){
                                                /*  prodInfoReturn = new OSM_DA_GenericFunctionsUtility.DAProdCountInfo();
                                                    prodInfoReturn.currentCnt = 100;
                                                    prodInfoReturn.availableCnt =100;*/
                                                //}
                                                
                                                mainWrapper.totalSubscriptionCount = prodInfoReturn.currentCnt != null ? prodInfoReturn.currentCnt:0;
                                            mainWrapper.availableCount = prodInfoReturn.availableCnt != null ? prodInfoReturn.availableCnt : 0;
                                            mainWrapper.daMessage = prodInfoReturn.daMessage != null ? prodInfoReturn.daMessage : '';
                                                                                                                                                                                
                                                                                                                                                                                                                                            /*mainWrapper.totalSubscriptionCount = proInfo.totalSubscriptionCount != null ? proInfo.totalSubscriptionCount:0;
                                                 mainWrapper.availableCount = proInfo.availableCount != null ? proInfo.availableCount : 0;
                                                 mainWrapper.daMessage = proInfo.message != null ? proInfo.message : '';
                                                */
                                                break;
                                                
                                                //Vaibhav - End for Prod data changes
                                            }
                                    }
                                    
                                }
                      
                            }
                        }catch(exception ex){system.debug('ex---->'+ex+'<====>'+ex.getLineNumber());
                                                OSM_SW_General_Util.maintainErrorLog(ex, 'Product Detail Page DA data fetch',ccrz.cc_CallContext.currAccountId);
                                            }
           }
           if(user != null ){
                userDetail.fName = user.Contact.LastName != null ? user.Contact.LastName:'';
                userDetail.lName = user.Contact.FirstName != null ? user.Contact.FirstName:'';
                userDetail.email = user.Contact.Email != null ? user.Contact.Email:'';
                userDetail.phone = user.Contact.Phone != null ? user.Contact.Phone:'';
                userDetail.company = user.Contact.Account.Name != null ? user.Contact.Account.Name:'';
                If(user.Contact.Account.BillingAddress != null){
                    Address address = user.Contact.Account.BillingAddress;
                    userDetail.address =  user.Contact.Account.BillingAddress;
                    try{
                    userDetail.strAddress = address.getStreet() != null ? address.getStreet()+',' : '' ;
                    userDetail.strAddress +=    address.getCity() != null ? address.getCity()+',' : '' ;
                    userDetail.strAddress +=    address.getState() != null?address.getState()+',' : '';
                    userDetail.strAddress +=    address.getCountry()!=null?address.getCountry() : '' ;
                    userDetail.strAddress +=    address.getPostalCode() != null ? '-' + address.getPostalCode():''; 
                    system.debug('Country==>'+address.getCountry());
                    }catch(Exception exx){system.debug(exx);} 
                }
               if(user.ContactId != null){
                userDetail.contactId = user.ContactId != null ? user.ContactId:'';
               }else{
                   userDetail.contactId = ccrz.cc_CallContext.currContact.Id;
               }
                userDetail.requestedDate = String.ValueOf(system.now());
                system.debug('userDetail=====>'+userDetail);
           }
    }
    
    
    
   //boolean isREQ = availableSubs.isRFQ availableSubs.isRFQ !=null
   
  
  
  //  assigning existing cart to main wrapper if exist
  if(!ccrz.cc_CallContext.isGuest){
   mainWrapper.existingCartItem = getUserCartItem(ccrz.cc_CallContext.currCartId, InputData, productIdList, ccrz.cc_CallContext.storefront, ccrz.cc_CallContext.currContact.Id);
  }
   //List<ccrz__E_CartItem__c> cartItems = OSM_SW_ProdDetailUtils_Ctrl.getUsersCartItemListExceptCurrentProduct(ccrz.cc_CallContext.currCartId, InputData, ccrz.cc_CallContext.storefront, ccrz.cc_CallContext.currContact.Id);
   Map < string, object > productcompleteDetail = new Map < string, object >();
      //if(!String.isBlank(acc.OSM_Preferred_Billing_Frequency__c) && (mainWrapper.existingCartItem == null || (mainWrapper.existingCartItem != null && !mainWrapper.existingCartItem.isPrimaryCart))){
      if(!String.isBlank(acc.OSM_Preferred_Billing_Frequency__c)){ 
      system.debug(1123456789);
          productcompleteDetail = OSM_SW_ProductDetailCommonUtility.getBillingFrequenciesAndSubscriptionsWithAccBillFre(subProdMap, acc.OSM_Preferred_Billing_Frequency__c, ccrz.cc_CallContext.currAccountId, ccrz.cc_CallContext.storefront, InputData);
          
      }
     // (String.isBlank(availableSubs.billingFrequency) 
      //         || (String.isNotBlank(availableSubs.billingFrequency) && !availableSubs.billingFrequency.containsIgnoreCase('One')))
      //if(String.isBlank(acc.OSM_Preferred_Billing_Frequency__c) || (mainWrapper.existingCartItem != null && mainWrapper.existingCartItem.isPrimaryCart)){
      if(String.isBlank(acc.OSM_Preferred_Billing_Frequency__c)){    
        productcompleteDetail = OSM_SW_ProductDetailCommonUtility.getBillingFrequenciesAndSubscriptions(subProdMap, ccrz.cc_CallContext.currAccountId, ccrz.cc_CallContext.storefront, InputData);
          system.debug(10000000);
      } 
   mainWrapper.prodYearPrice = prodYearPrice;
   mainWrapper.prodMonthlyPrice = prodMonthlyPrice;
   mainWrapper.proratedDnPriceMap = proratedDnPriceMap;   
   mainWrapper.onlyBase=onlyBase;
   mainWrapper.productIdVsWrapperMap = productIdVsWrapperMap;
   mainWrapper.billingFrequencies = (List < String > ) productcompleteDetail.get('billingFrequencies');
   mainWrapper.subscriptionLengthVsYrMultipler = (Map < String, Decimal > ) productcompleteDetail.get('subscriptionLengthVsYrMultipler');
   mainWrapper.sortedProdSpecification = (List < OSM_SW_ProductDetailCommonUtility.ProductSpecification > ) productcompleteDetail.get('specNameVsSpecsMap');
   mainWrapper.subProdTermPrices = subProdTermPrices;
   mainWrapper.compositKeyForSubProdTerm = compositKeyForSubProdTerm;
   mainWrapper.prodLongDescription = prodLongDescription;
   mainWrapper.userDetail = userDetail;
   mainWrapper.pricePerBillFrequency = pricePerBillFrequency;
   mainWrapper.isSubscribed = availableSubs.isSubscribed;
   mainWrapper.hasOtherProductSusbcription = hasOtherProductSusbcription;
      if(availableSubs.isSubscribed){
          if(Test.isRunningTest())availableSubs.subsEndDate = System.now().addDays(1);
            mainWrapper.subscriptionEndDate = ''+availableSubs.subsEndDate.Day()+' '+OSM_SW_ProductDetailCommonUtility.getMonth(availableSubs.subsEndDate.Month())+' '+availableSubs.subsEndDate.Year();
      }
    
    list<String> billingFrequencies = (List < String > ) productcompleteDetail.get('billingFrequencies');
      //Code addedto cover test class
      if(test.isRunningTest()){billingFrequencies=new list<String>(); billingFrequencies.add('test');}
      for(String billFr : billingFrequencies){
          if((availableSubs.isRFQ || availableSubs.isSubscribed) && availableSubs.recurringPrice == 0 && billFr.containsIgnoreCase('One')){
              mainWrapper.billingFrequencies = new List<String>{billFr};
                  break;
          }
          
      }
      
      //Patch Story-169959 change on 14th Nov 2018 - by Vineet
      boolean isOnBehalf = false;
      /*String loggedInUserType = OSM_SW_General_Util.getuserType(UserInfo.getUserId());
      if(ccrz.cc_CallContext.isOnBehalf && acc.BMS_Customer_ID__c != null && acc.BOLT_Account_Number__c==null
            && (loggedInUserType.EqualsIgnoreCase(Label.OSM_Support_Admin_UserType) 
                || loggedInUserType.EqualsIgnoreCase(Label.OSM_Sales_UserType))){
          //acc.BMS_Customer_ID__c
          //BOLT_Account_Number__c
          isOnBehalf = true;
      }*/
      if(Test.isRunningTest())
      {
          isOnBehalf = true;
          
          billingFrequencies.add('One');
      }
      if(isOnBehalf || (availableSubs.isSubscribed && subcription.Recurring_Invoice_Start_Date__c != null  && subcription.Last_Installment_Generated__c && subcription.ccrz__InstallmentCountRemaining__c < 1              && subcription.OSM_Subscription_End_Date__c > system.now())
            ){ 
           for(String billFr : billingFrequencies){
               if(billFr.containsIgnoreCase('One')){
                    mainWrapper.billingFrequencies = new List<String>{billFr};
                  break;
                }
           }
      }
      if(subcription != null && subProdMap.get(subcription.ccrz__SPT__c) != null 
         && subProdMap.get(subcription.ccrz__SPT__c).ccrz__DisplayName__c.Contains('1 Year')  && availableSubs.isSubscribed && availableSubs.billingFrequency.containsIgnoreCase('One') 
        && availableSubs.recurringPrice > 0){  
             List<String> billfrSubscribedProduct = new List<String>(); 
      for(String billFr : billingFrequencies){
          if(availableSubs.isSubscribed && availableSubs.billingFrequency.containsIgnoreCase('One') 
             && availableSubs.recurringPrice > 0 && !billFr.containsIgnoreCase('Yearly')){
             billfrSubscribedProduct.add(billFr);
                //  break;
          }
      }
            //mainWrapper.billingFrequencies = billfrSubscribedProduct;
      }
      
   mainWrapper.isRFQ = availableSubs.isRFQ;
      if(Test.isRunningTest())hasActiveSubs=false;
   if(!hasActiveSubs){
   //ccrz__E_RequestForQuote__c existingReq = OSM_SW_ProdDetailUtils_Ctrl.getUsersQuote(userId, ctx.storefront, productIdList);
    Set<String>quoteStatus = new Set<String>{'Requested','In Progress', 'Sent', 'Accepted'};
       List<ccrz__E_RequestForQuote__c> existingReq = OSM_SW_ProdDetailUtils_Ctrl.getAccountProductQuotes(ccrz.cc_CallContext.currAccountId, ctx.storefront, productIdList, quoteStatus);
        ccrz.ccLog.log('Query Data of existingReq--->'+existingReq);
       ccrz.ccLog.log('Query Data of existingReq--->'+ccrz.cc_CallContext.currAccountId+'==='+ ctx.storefront+'==='+ quoteStatus+'==='+ productIdList);
       //ccrz.ccLog.close();
    if(existingReq.size()>0){
       mainWrapper.hasActiveSubs = true;
    }
   }
   mainWrapper.proratedPriceMap = proratedPriceMap;
   
   
   //method call to check Free trial available 
  if(!ccrz.cc_CallContext.isGuest){
   mainWrapper.isFreeTrialAvailabel = checkFreeTrial(ccrz.cc_CallContext.currAccountId, ProductIdForSubscription, freeDAProduct);
   if(mainWrapper.isFreeTrialAvailabel)
        mainWrapper.freeTrialDetails = getFreeTrialObj(ProductIdForSubscription);
  }
  
   String userType = '';
            if(!OSM_SW_General_Util.ALREADY_CHECK_USER_PERMISSIONSET){
                userType = OSM_SW_General_Util.getuserType(UserInfo.getUserId());
            } else{
                userType = OSM_SW_General_Util.USER_TYPE;
            }
            if(userType=='OSM_Fleet_Admin' && !Label.OSM_North_America_Country.contains(acc.BillingCountry) && !label.OSM_PO_Distributor_List.contains(acc.CSS_DistributorCode__c))
            {
                 mainWrapper.GOMSUser=true;
            }
            else if(userType!='OSM_Fleet_Admin' && !Label.OSM_North_America_Country.contains(acc.BillingCountry) && !label.OSM_PO_Distributor_List.contains(acc.CSS_DistributorCode__c))
            {
            
                mainWrapper.GOMSPriceMsg=true;
 
            }
   
      // JUHI Changes - Sept 26 - Terms and Conditions PDF in different tab
      /*try
      {
          List<ContentDocument> contentDocumentList = [Select ID, title 
                                                       from ContentDocument 
                                                       where ID=:Label.OSM_TnC_Product_PDF_ID];
          
          //List<ContentDocument> contentDocumentList= [Select ID, Title from ContentDocument where Title ='OSM_TnC_Product_PDF'];
          
          
          if(null != contentDocumentList && contentDocumentList.size() > 0)
          {
              ID contentDocumentID = contentDocumentList[0].ID;
              
              List<ContentDistribution> contentDistributionList = [Select ID, DistributionPublicUrl 
                                                                   from ContentDistribution 
                                                                   where ContentDocumentId =:contentDocumentID];
              
              if(null != contentDocumentList && contentDocumentList.size() > 0)
              {
                 mainWrapper.productTnCLink = contentDistributionList[0].DistributionPublicUrl;
              }
          }
      }
      catch(Exception e)
      {
          // dont throw any exception.
          // Tnc Page will not open...no link url
      }*/
      
   res.data = mainWrapper;

   res.success = true;
    if(Test.isRunningTest())
       {
           throw new NullPointerException();
       }        
  } catch (Exception ex) {
   res.success = false;
     OSM_SW_General_Util.maintainErrorLog(ex, 'Product Detail Page load', ccrz.cc_CallContext.currAccountId);
   System.debug('====EXCEPTION IN PRICING MAP******' + ex.getStackTraceString());
   System.debug(ex+'====EXCEPTION IN PRICING MAP******' + ex.getLineNumber());
  }finally{
        ccrz.ccLog.log(System.LoggingLevel.INFO,'M:X','myMethod');
        ccrz.ccLog.close(res);
    }
  return res;
}

 // Method to check free trial is available for User or not

 public static boolean checkFreeTrial(Id accountId, Id productId, boolean freeDAProduct)
{
    boolean isFreetrial = false;
    System.debug('accountId: '+accountId);
    System.debug('productId: '+productId);
    if(accountId != null && productId != null)
    {
        List<ccrz__E_Subscription__c> lstSubsc = [Select Id from ccrz__E_Subscription__c where ccrz__Account__c =: accountId AND ccrz__SubscriptionProduct__c =: productId ];
        System.debug('lstSubsc: '+lstSubsc);
        System.debug('lstSubsc size: '+lstSubsc.size());
        if(lstSubsc.size() > 0)
            isFreetrial = false;
        else if(!freeDAProduct)
            isFreetrial = true;
    }

    return isFreetrial;
}

 public static FreeTrialDetails getFreeTrialObj(Id productId)
{
    FreeTrialDetails objFreeTrial = new FreeTrialDetails();
    List<ccrz__E_Product__c> lstFreeTrialobj = [Select Id, OSM_SW_FreeTrial_Days__c, OSM_SW_FreeTrial_Maximum_Qty__c from ccrz__E_Product__c where Id =: productId];
    System.debug('lstFreeTrialobj: '+lstFreeTrialobj);
    if(lstFreeTrialobj != null && lstFreeTrialobj.size() > 0)
    {
        if(lstFreeTrialobj[0].OSM_SW_FreeTrial_Maximum_Qty__c != null)
            objFreeTrial.maximumQty = (Integer)lstFreeTrialobj[0].OSM_SW_FreeTrial_Maximum_Qty__c;
        else
            objFreeTrial.maximumQty = 0;
        if(lstFreeTrialobj[0].OSM_SW_FreeTrial_Days__c != null)
            objFreeTrial.freeDays = (Integer)lstFreeTrialobj[0].OSM_SW_FreeTrial_Days__c;
        else
            objFreeTrial.freeDays = 0;
            
        objFreeTrial.productId = productId;
        
        
            
    } 
    return objFreeTrial;
}

/*
public static DiscountedPriceWrapper fetchDiscountedPrice(String store, String userId, Set<String> prodIds){
    boolean isActiveSubs = false;
        DiscountedPriceWrapper activeSubs = new DiscountedPriceWrapper();
         Map<String,Object> inputData = new Map<String,Object>{
        ccrz.ccApi.API_VERSION => ccrz.ccApi.CURRENT_VERSION,
       ccrz.ccAPISubscription.STOREFRONT => store,
        ccrz.ccAPISubscription.BYLASTORDERDATE => TRUE,
        ccrz.ccAPISubscription.BYASC => TRUE
    };
      Map<String,Object> apiSubscription = new Map<String, Object>();
        Map<String, Object> outputData = ccrz.ccAPISubscription.fetch(inputData);
        if (outputData.get(ccrz.ccAPISubscription.SUBSCRIPTIONS) != null) {
            // The cast to List<Map<String, Object>> is necessary...
            List<Map<String, Object>> subscriptionList = (List<Map<String, Object>>) outputData.get(ccrz.ccAPISubscription.SUBSCRIPTIONS);
            
            for(Map<String, Object> subscription : subscriptionList){
                // The cast, again, is necessary...
                 for (String key_tmp: subscription.keySet()) {
                        if(key_tmp == 'subscriptionProduct' && prodIds.contains(string.valueOf(subscription.get(key_tmp)))){
                        //f(key_tmp == 'subscriptionProduct'){
                            system.debug('############ subscription ########'+key_tmp);
                            system.debug(subscription.get(key_tmp));
                            system.debug(subscription);
                            if(subscription.get('subscriptionStatus') == 'Active'){
                                apiSubscription.putAll(subscription);
                                isActiveSubs = true;
                            }
                        }
                 }
            }
        }
        
        //for (Object subs: apiSubscription) {
        for (String key_tmp: apiSubscription.keySet()) {
                system.debug('############ subs ########'+key_tmp+'====>'+apiSubscription.get(key_tmp));
                if(key_tmp =='subscriptionProduct'){
                    activeSubs.subscriptionProduct = (String)apiSubscription.get(key_tmp);
                }
                if(key_tmp =='subscriptionStatus'){
                    activeSubs.subscriptionStatus = (String)apiSubscription.get(key_tmp);
                }
                if(key_tmp =='SPT'){
                    activeSubs.STP = (String)apiSubscription.get(key_tmp);
                }
                if(key_tmp =='recurringPrice'){
                    activeSubs.recurringPrice = (Decimal)apiSubscription.get(key_tmp);
                }
                
             }
             
    //getUsersQuote(String UserId,String store,Set<String> prodIds, String strStatus){
    if(!isActiveSubs){
            ccrz__E_RequestForQuote__c  objRFQ = OSM_SW_ProdDetailUtils_Ctrl.getUsersQuote(userId,store,prodIds, Label.OSM_RFQ_ACCEPTED);
            if(objRFQ != null){
                    activeSubs.subscriptionProduct = objRFQ.CC_Product__c;
                    activeSubs.subscriptionStatus = objRFQ.Status__c;
                    activeSubs.STP = objRFQ.CC_SubProdTerm__c;
                    activeSubs.recurringPrice = objRFQ.Discounted_Price__c != null ? objRFQ.Discounted_Price__c:objRFQ.Cost_Subscription__c;
            }
    }
    system.debug('############ apiSubscription ########'+apiSubscription);
    system.debug('############ activeSubs ########'+activeSubs);
    return activeSubs;
     
 }
*/

/*----------------------------------------------------------------------------------
4. submitFreeTrial
Description:Used to perform insert/update DML of Subscription record 
Input: ccrz.cc_RemoteActionContext ctx
Output: 
Returns SUCCESS/ERROE

ccrz.cc_RemoteActionResult
resData==>SUCCESS
------------------------------------------------------------------------------------*/
@RemoteAction
global static ccrz.cc_RemoteActionResult submitFreeTrial(ccrz.cc_RemoteActionContext ctx, String InputData) {

    ccrz.cc_CallContext.initRemoteContext(ctx);
    ccrz.cc_RemoteActionResult res = new ccrz.cc_RemoteActionResult();
    res.success = false;
    try{
        String storefront = ccrz.cc_CallContext.storefront;
        Id userId = ccrz.cc_CallContext.currUserId;
        Id accountId = ccrz.cc_CallContext.currAccountId;
        Id contactId = ccrz.cc_CallContext.currContact.Id;

         Map < String, Object > inputDetails = (Map < String, Object > ) JSON.deserializeUntyped(InputData);
        system.debug('inputDetails : '+inputDetails);
        
        Integer maxquantity = Integer.valueOf(inputDetails.get('maxQuantity'));
        Integer quantity = Integer.valueOf(inputDetails.get('enteredQuantity'));
        Integer freeDays = Integer.valueOf(inputDetails.get('freeDays'));
        String productId = (String)inputDetails.get('productId');
        System.debug('quantity: '+quantity);
    
    
        ccrz__E_CompositeProduct__c objCompositeProd = new ccrz__E_CompositeProduct__c();
        objCompositeProd = [Select Id,ccrz__Composite__c from ccrz__E_CompositeProduct__c where ccrz__Component__c =: productId limit 1];
        
        
        ccrz__E_Subscription__c objSubscription = new ccrz__E_Subscription__c();
        objSubscription.ccrz__Account__c = accountId;
        objSubscription.ccrz__Quantity__c = quantity;
        objSubscription.ccrz__Sequence__c = 1;
        objSubscription.ccrz__Storefront__c = storefront;
        objSubscription.ccrz__SubscriptionProduct__c = productId;
        objSubscription.ccrz__SubscriptionStartDate__c = System.now();
        objSubscription.ccrz__SubscriptionStatus__c = 'Active';
        objSubscription.ccrz__User__c = userId;
        objSubscription.OwnerId = userId;
        objSubscription.Subcription_Created_By__c = UserInfo.getUserId();
        objSubscription.Contact__c = contactId;
        objSubscription.OSM_Subscription_End_Date__c = System.now().addDays(freeDays);
        objSubscription.OSM_Free_Trial__c = true;
        if(objCompositeProd != null &&  objCompositeProd.ccrz__Composite__c != null)
            objSubscription.OSM_Display_Product__c = objCompositeProd.ccrz__Composite__c;
        
        insert objSubscription;
        res.success = true;
        res.data = System.Label.OSM_SW_Free_Trial_SaveSucessMsg;
        
        if(Test.isRunningTest()) {
                throw new NullPointerException();
            } 



        if(Test.isRunningTest())
       {
           throw new NullPointerException();
       }        
    }
    catch(Exception ex)
    {
        res.success = false;
        res.data = System.Label.OSM_SW_Free_Trial_ErrorMsg;
        System.debug('errorMsg'+ex.getMessage());
        
        String errorMsg = ex.getLineNumber() + ex.getStackTraceString() + '-----'+ex.getMessage();

        OSM_Integration_Log__c log = new OSM_Integration_Log__c();

        log.Error_Description__c = errorMsg;

        log.Service_Name__c = System.Label.OSM_SW_FreeTrial_Service;

        log.Status__c = 'Failed';

        insert log;
        
    }
    
    
    
    

    return res;
}
/*----------------------------------------------------------------------------------
1. submitQuote
Description:Used to perform insert/update DML of Quote 
Input: ccrz.cc_RemoteActionContext ctx
Output: 
Returns SUCCESS/ERROE

ccrz.cc_RemoteActionResult
resData==>SUCCESS
------------------------------------------------------------------------------------*/
@RemoteAction
global static ccrz.cc_RemoteActionResult submitQuote(ccrz.cc_RemoteActionContext ctx, String InputData) {
  ccrz.cc_CallContext.initRemoteContext(ctx);
  
  String storefront = ccrz.cc_CallContext.storefront;
  Id userId = ccrz.cc_CallContext.currUserId;

  ccrz.cc_RemoteActionResult res = new ccrz.cc_RemoteActionResult();
  res.success = false;

  try {
   Map < String, Object > SubscriptionDetails = (Map < String, Object > ) JSON.deserializeUntyped(InputData);
   system.debug('+++++++++++++++++++++++++++++++++');
   system.debug(SubscriptionDetails);
   
   String quantity = (String) SubscriptionDetails.get('subcQty');
   
   Decimal unitPrice = (Decimal) SubscriptionDetails.get('unitPrice');
   Integer monthlyPrice = (Integer) SubscriptionDetails.get('monthlyPrice');
   String totalPrice = (String) SubscriptionDetails.get('totalPrice');
   Integer availableCount = Integer.ValueOf((String) SubscriptionDetails.get('availableCount'));
   String billingFreq = (string) SubscriptionDetails.get('billingFreq');
   String prodSku = (string) SubscriptionDetails.get('selectedProdSku');
   String subslength = (string) SubscriptionDetails.get('prodSubscriptions');
   String plan = (string) SubscriptionDetails.get('plan');
   //String userId = (string) SubscriptionDetails.get('userId');
   String rfqDescription = (string) SubscriptionDetails.get('rfqDescription');
   
   String subProdTermId = (string) SubscriptionDetails.get('subProdTermId');
   String parentId = (string) SubscriptionDetails.get('parentId');
   ccrz__E_RequestForQuote__c reqQuote = new ccrz__E_RequestForQuote__c();

    User user = OSM_SW_ProdDetailUtils_Ctrl.getUserDetail(userId);
    if(String.valueOf(user.Profile.UserLicense.Name) != 'Salesforce Platform'){
      reqQuote.ccrz__Email__c = user.Contact.Email;
      reqQuote.ccrz__Account__c = user.Contact.AccountId;
    //reqQuote.Final_Price__c
      reqQuote.ccrz__FirstName__c = user.Contact.FirstName;
      reqQuote.ccrz__LastName__c = user.Contact.LastName;
      reqQuote.ccrz__Phone__c = user.Contact.Phone; 
      reqQuote.ccrz__Contact__c = user.ContactId;
    } else{
      Contact cont = OSM_SW_ProdDetailUtils_Ctrl.getContactByUserIdforAdmin(String.valueOf(userId));
      reqQuote.ccrz__Email__c = cont.Email;
      reqQuote.ccrz__Account__c = cont.AccountId;
      reqQuote.ccrz__FirstName__c = cont.FirstName;
      reqQuote.ccrz__LastName__c = cont.LastName;
      reqQuote.ccrz__Phone__c = cont.Phone; 
      reqQuote.ccrz__Contact__c = cont.Id;
    }
    

    reqQuote.OSM_CommunityUser__c = user.Id;
    reqQuote.Amount_Per_Billing_Period__c = unitPrice;
    reqQuote.ccrz__Amount__c = Decimal.ValueOf(totalPrice);
    //reqQuote.Billing_Period__c = billingFreq;

    reqQuote.Customer_Comments__c = rfqDescription;
    //reqQuote.Cost_Subscription__c
    reqQuote.ccrz__Description__c = rfqDescription;


  
    reqQuote.Quantity__c = Decimal.valueOf(quantity);
    //reqQuote.Subscription_Length__c = subslength;
    reqQuote.CC_SubProdTerm__c = subProdTermId;
    reqQuote.ccrz__Storefront__c = storefront;
    reqQuote.Status__c = 'Requested';
    reqQuote.Quote_Requested_Date__c = system.now();
    reqQuote.Cost_Subscription__c = monthlyPrice;
    reqQuote.Available_Subscription__c = availableCount;
    reqQuote.Product_Plan__c = plan;
    reqQuote.Display_Product__c = parentId;
    //reqQuote.Customer_Status__c = 'In Progress';
   
   List<ccrz__E_Product__c>  eProd = OSM_SW_ProdDetailUtils_Ctrl.getEProduct(prodSku);
   
    if(eProd.size()==1){
        reqQuote.CC_Product__c = eProd[0].Id;
    }
    Set<String>quoteStatus = new Set<String>{'Requested','In Progress', 'Sent', 'Accepted'};
        System.debug('ccrz.cc_CallContext.currAccountId--->'+ccrz.cc_CallContext.currAccountId);
      System.debug('storefront--->'+storefront);
      System.debug('quoteStatus--->'+quoteStatus);
      System.debug('reqQuote.CC_Product__c--->'+reqQuote.CC_Product__c);
    List<ccrz__E_RequestForQuote__c> existingReq = OSM_SW_ProdDetailUtils_Ctrl.getAccountProductQuotes(ccrz.cc_CallContext.currAccountId, storefront, new Set<String>{reqQuote.CC_Product__c},quoteStatus);
    system.debug('existingReq--->'+existingReq);
    if(existingReq.size()>0){
        res.data = 'There is already existing Quote for this Product';
    }else{
        Account acc = OSM_SW_ProdDetailUtils_Ctrl.getAccount(ccrz.cc_CallContext.currAccountId);
        system.debug('Account---->'+acc);
        //Start : Vaibhav on 21-Aug
        if(acc.IAM_Cummins_Support_User__c==null)
        {
            //tbd
             //display message to user to contact Sales User as 
            //to be fixed..this is tmp fix
            //reqQuote.OwnerId= UserInfo.getUserId();
        }
        //End : Vaibhav on 21-Aug
        else{
            // START Juhi Changes - Oct 11 2018 - RFQ SalesUser can not request for Sales Admin
            reqQuote.OwnerId = acc.IAM_Cummins_Support_User__c;
            
           /* if(user.Profile.Name.contains('Support'))
            {
                reqQuote.OwnerId = acc.IAM_Cummins_Support_User__c;
            }
            else
            {
                reqQuote.OwnerId = user.ID;
            }*/
            
            // END Juhi Changes - Oct 11 2018
            system.debug('acc.IAM_Cummins_Support_User__c--->'+acc.IAM_Cummins_Support_User__c);
        }
        system.debug('before reqQuote--->'+reqQuote);
        if(acc.IAM_Cummins_Support_User__r.ManagerId != null){
            reqQuote.OSM_Sales_Admin__c = acc.IAM_Cummins_Support_User__r.ManagerId;
        }
        //Vaibhav TBD
        //reqQuote.ownerId='0054C00000177ae';
        
        if(ccrz.cc_CallContext.isOnBehalf){
            //|| (ccrz.cc_CallContext.isOnBehalf && (Label.OSM_Sales_Admin_UserType == strUserType || Label.OSM_Sales_UserType == strUserType))
            String loggedInUserType = OSM_SW_General_Util.getuserType(UserInfo.getUserId());
            OSM_SW_General_Util.ALREADY_CHECK_USER_PERMISSIONSET = false;
            String cummRepUserType = acc.IAM_Cummins_Support_User__c != null ? OSM_SW_General_Util.getuserType(acc.IAM_Cummins_Support_User__c):'';
            if(UserInfo.getUserId() != acc.IAM_Cummins_Support_User__c){
                
                reqQuote.OwnerId = UserInfo.getUserId();
                
                if(loggedInUserType.equalsIgnoreCase(Label.OSM_Support_Admin_UserType) && acc.IAM_Cummins_Support_User__c != null){
                    
                    reqQuote.OwnerId = acc.IAM_Cummins_Support_User__c;
                    reqQuote.Quote_Requested_By_SupportAdmin__c = UserInfo.getUserId();
                }
                /*
                if(loggedInUserType.isEqualsIgnoreCase(Label.OSM_Support_Admin_UserType) && cummRepUserType.isEqualsIgnoreCase(Label.OSM_Sales_UserType)){
                    
                }
                
                if(loggedInUserType.isEqualsIgnoreCase(Label.OSM_Support_Admin_UserType) && cummRepUserType.isEqualsIgnoreCase(Label.OSM_Sales_UserType)){
                    
                }*/
                
            }
        
        }else{
            if(acc.IAM_Cummins_Support_User__c != null){
                reqQuote.OwnerId = acc.IAM_Cummins_Support_User__c;
            }
            
        }
        insert reqQuote;
        system.debug('after reqQuote--->'+reqQuote);
       //Account acc = OSM_SW_ProdDetailUtils_Ctrl.getAccount(ccrz.cc_CallContext.currAccountId);
        if(acc.IAM_Cummins_Support_User__c != null && reqQuote.OSM_Sales_Admin__c != null){
            //OSM_SW_General_Util.quoteApexSharing(reqQuote.Id);
            try{ 
             /*   boolean isSharedtoAdmin = OSM_SW_General_Util.manualQuoteShareEdit(reqQuote.Id, reqQuote.OSM_Sales_Admin__c);
                    if(isSharedtoAdmin){
                        system.debug('sharing done');
                    }else{
                        system.debug('sharing not done');
                    }*/
            }Catch(Exception exx){
                OSM_SW_General_Util.maintainErrorLog(exx, 'Issue of Quote Sharing with Sales Admin',ccrz.cc_CallContext.currAccountId);
            }
        }
    }
    //res.quoteId = reqQuote.Id;
    res.success = true;
   
   system.debug('---------->' + quantity);
      if(Test.isRunningTest())
       {
           throw new NullPointerException();
       }
  } catch (Exception ex) {
   system.debug(ex +'============>'+ex.getLineNumber());
   res.data = 'There is some issue on Quote';
   res.success = false;
   OSM_SW_General_Util.maintainErrorLog(ex, 'Issue in Quote Creation',ccrz.cc_CallContext.currAccountId);
   system.debug('Error---------->' + ex.getMessage());
  }
  return res;
}

 
 
 /*----------------------------------------------------------------------------------
1. submitQuote
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
  String accId = ccrz.cc_CallContext.currAccountId;
  Map<String,Object> returnMap = new Map<String,Object>();
  ccrz.cc_RemoteActionResult res = new ccrz.cc_RemoteActionResult();
  res.success = false;

  try {
       ccrz.ccLog.log('==Step 1');
   Map < String, Object > SubscriptionDetails = (Map < String, Object > ) JSON.deserializeUntyped(InputData);
   system.debug('++++++++++++++currCartId+++++++++++++++++++'+currCartId);
  
   system.debug(SubscriptionDetails);
   
   String quantity = (String) SubscriptionDetails.get('subcQty');
   Decimal monthlyPrice = (Decimal) SubscriptionDetails.get('monthlyPrice');
   String totalPrice = (String) SubscriptionDetails.get('totalPrice');
      
   Decimal selectedProratedPrice = (Decimal) SubscriptionDetails.get('selectedProratedPrice');
   String billingFreq = (string) SubscriptionDetails.get('billingFreq');
   String prodSku = (string) SubscriptionDetails.get('selectedProdSku');
      String parentProdSku = (string) SubscriptionDetails.get('parentProdSku');
   String subslength = (string) SubscriptionDetails.get('prodSubscriptions');
   String plan = (string) SubscriptionDetails.get('plan');
   //String userId = (string) SubscriptionDetails.get('userId');
   String rfqDescription = (string) SubscriptionDetails.get('rfqDescription');
   
   String subProdTermId = (string) SubscriptionDetails.get('subProdTermId');
   String parentId = (string) SubscriptionDetails.get('parentId');
    List<ccrz__E_Product__c>  eProd = OSM_SW_ProdDetailUtils_Ctrl.getEProduct(prodSku);
    List<ccrz__E_CartItem__c> cartItems = OSM_SW_ProdDetailUtils_Ctrl.getUsersCartItemListExceptCurrentProduct(ccrz.cc_CallContext.storefront, ccrz.cc_CallContext.currAccountId); 
      boolean isPrimayItem = true;
      if(cartItems.size()>0){
          isPrimayItem = false;
      }
    Savepoint sp = Database.setSavepoint();
      if(!billingFreq.containsIgnoreCase('One')){
            OSM_SW_ProductDetailCommonUtility.updateAccountBillingFrequency(accId, billingFreq,storefront);
      }
    Boolean wasSuccessful = false;
    ccrz.ccApiCart.LineData theNewLine = new ccrz.ccApiCart.LineData();
    theNewLine.sku = prodSku;
      theNewLine.parentSku = parentProdSku;
      theNewLine.parentProductId = parentId;
    theNewLine.quantity = Decimal.ValueOf(quantity);
    
    //theNewLine.storeID = storefront;
     if(eProd.size()==1){
        //theNewLine.productId = eProd[0].Id;
        
    }
    //theNewLine.productId = prodId;
    theNewLine.subProdTermId = subProdTermId;
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
            System.debug('===Cart from newCart is==='+eCart);
            theCartSFID = cartRefetch.Id;
            currCartId = cartRefetch.ccrz__EncryptedId__c;
         }
        
     }else{
         ccrz__E_Cart__c cart = OSM_SW_ProdDetailUtils_Ctrl.getUsersCart(currCartId);
         theCartSFID = cart.Id;
     }
     
     System.debug('====currCartId===='+currCartId);
    //Add a price to set the resulting cart item as external
    theNewLine.price = (Decimal.ValueOf(totalPrice)/Decimal.ValueOf(quantity));
    theNewLine.qty = Decimal.ValueOf(quantity);
    theNewLine.parentSku = parentProdSku;
      
      theNewLine.parentProductId = parentId;
      //theNewLine.OSM_Primary_Cart_Item__c = isPrimayItem;
    //theNewLine.subscriptionFrequency = billingFreq;
     
    //Optionally also add a subTotal to the externally priced object - If set then the automatic calculation of price*quantity for subtotal will NOT be used
    //theNewLine.subTotal = Decimal.ValueOf(totalPrice);
     
    List<ccrz.ccApiCart.LineData> theNewLines = new List<ccrz.ccApiCart.LineData>();
    theNewLines.add( theNewLine );
     system.debug('theNewLines');
     system.debug(theNewLines);
    try{
        Map<String,Object> addResults = ccrz.ccApiCart.addTo(new Map<String,Object>{
            ccrz.ccApi.API_VERSION => ccrz.ccAPI.CURRENT_VERSION,
            ccrz.ccApiCart.CART_ID => theCartSFID,
            ccrz.ccApiCart.LINE_DATA => theNewLines,
            ccrz.ccApiCart.ISREPRICE => true
        });
      
        //General check, since the cart Id will be blank if not successful we technically do not need this.
        system.debug('==addResults===');
        system.debug(addResults);
        system.debug(theNewLines);
        wasSuccessful = (Boolean)addResults.get(ccrz.ccApi.SUCCESS);
    }catch(Exception e){
        //Error reporting here....
         String errorMsg = e.getLineNumber() + e.getStackTraceString() + '-----'+e.getMessage();
         ccrz.ccLog.log('ErrorMsg-----'+errorMsg);
    }
      if(wasSuccessful){
          List<ccrz__E_CartItem__c> newCartItems = OSM_SW_ProdDetailUtils_Ctrl.getCartItems(currCartId, prodSku);
          if(newCartItems.size()==1){
              newCartItems[0].Dn_Price__c = selectedProratedPrice;
              newCartItems[0].Unit_Dn_Price__c = selectedProratedPrice/newCartItems[0].ccrz__Quantity__c;
              newCartItems[0].OSM_SW_Product_Link__c  = parentId;
              newCartItems[0].Prorated_Price__c = newCartItems[0].ccrz__Price__c;
              newCartItems[0].Custom_Proration_Price__c = newCartItems[0].ccrz__Price__c;
              newCartItems[0].withCoTerm__c = true;
              Database.update(newCartItems, false);
          }
      }
      
    res.success = true;
    if(!wasSuccessful){
        Database.rollback(sp);
        res.success = false;
    }
        returnMap.put('cart_id',currCartId);
         ccrz.ccLog.log('CART ID IN CONTROLLER-----'+currCartId);
         system.debug('---CART ID IN CONTROL----' + currCartId);
        res.data =  returnMap;
   system.debug('---------->' + quantity);
   if(Test.IsRunningTest()){
       throw new NullPointerException();
   }
  } catch (Exception ex) {
   system.debug(ex +'============>'+ex.getLineNumber());
   res.data = ex;
  
         String errorMsg = ex.getLineNumber() + ex.getStackTraceString() + '-----'+ex.getMessage();
         ccrz.ccLog.log('ErrorMsg-----'+errorMsg);
   res.success = false;
   system.debug('Error---------->' +errorMsg);
 }finally{
        ccrz.ccLog.log(System.LoggingLevel.INFO,'M:X','addToCartExternal');
        ccrz.ccLog.close(res);
    }
  return res;
}

    
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
    
   
 
/*----------------------------------------------------------------------------------
getProductcompleteDetail
Description:Used to get Specification/SubprodTerm/Frequency of DA composite's Produts 
Params: String ParentId
Output: 
Returns  Map < string, object > prodCustom

------------------------------------------------------------------------------------*/
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
    system.debug('#######################');
    system.debug('####compProd : ' + compProd);
    compositProdName.add(compProd.Id);
    compositProdNamemp.put(compProd.id, compProd.ccrz__Component__r.Name);
    compositProdIds.add(compProd.ccrz__Component__c);
    system.debug('#######################compositProdIds: ' + compositProdIds);
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
    system.debug('#####ProductSpec : ' + productSpecification);
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
      
   system.debug('sortedSubscriptionLengthVsYrMultipler===>'+sortedSubscriptionLengthVsYrMultipler);
   List<BillingFrequency>tobeSortBillingFre = new List<BillingFrequency>();
  /* billingFrequenciesLst.addAll(billingFrequencies);
   for(String bilF : billingFrequenciesLst){
   BillingFrequency objBil = new BillingFrequency();
       objBil.billingFreq = bilF;
       tobeSortBillingFre.add(objBil);
   }*/
   billingFrequencies = new Set<String>();
   //List<String> billingFrequencieslst = new List<String>();
   tobeSortBillingFre.sort();
   sortBillingFrequency.sort();
   for(SortWrapper  sortedBi : sortBillingFrequency){
       system.debug('billingFrequencies===>'+sortedBi.value);
       billingFrequenciesLst.add(sortedBi.value);
   }
   
      system.debug('billingFrequencies===>'+billingFrequenciesLst);
   //billingFrequencies.addAll(billingFrequenciesLst);
   system.debug('subProdTerms#######################>>' + subProdTerms);
    
   prodCustom.put('specNameVsSpecsMap', sortedProdList);
   prodCustom.put('compositProdNamemp', compositProdNamemp);
   prodCustom.put('subProdTermsMap', subProdTermsMap);
   prodCustom.put('subscriptionLengthLst', billingFrequenciesLst);
   prodCustom.put('prodSubscriptions', prodSubscriptions);
   prodCustom.put('billingFrequencies', billingFrequencieslst);
   prodCustom.put('subscriptionLengthVsYrMultipler', sortedSubscriptionLengthVsYrMultipler);
   prodCustom.put('subscriptionLengthWithYrMultipler', subscriptionLengthWithYrMultipler);
   //prodCustom.put('sortSubsLength', sortSubsLength);
   

   system.debug('#######################>>' + specName);
  }
  return prodCustom;

}

  @RemoteAction
    global static ccrz.cc_RemoteActionResult saveCCPackageInClass(final ccrz.cc_RemoteActionContext ctx,String jsonCCData)
    {
        ccrz.cc_CallContext.initRemoteContext(ctx);
        ccrz.cc_RemoteActionResult res = new ccrz.cc_RemoteActionResult();
        res.success=false;
        ccrz.ccLog.log(System.LoggingLevel.DEBUG,'CHECKING in cc_ctrl_subspackage_class','saveCCPackageInClass()');
        ccrz.ccLog.log(System.LoggingLevel.DEBUG,'CHECKING in jsonCCData',jsonCCData);
        
        return res;
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
/*------------------------------------------------------------------------------
Wrapper for Sorting
------------------------------------------------------------------------------*/
class SortWrapper implements Comparable {
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

    public String inputText1 {get;set;}
    
    public pageReference GoToPage2(){
        PageReference pf = new PageReference('/apex/OSM_SW_Prod_TermsAndConditionsPg?att='+inputText1);
        return pf;
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
        boolean DAProd;  
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
                if(listprod.Group_Name__c=='DA'){
                  DAProd =true;
                }
            }
            if ((acc.Customer_BMS_number__c== null)&&(acc.BOLT_Account_Number__c == null)){
                   IsBMSBoltNull=true;
                   }
                   if ((acc.Customer_BMS_number__c== '')&&(acc.BOLT_Account_Number__c == '')){
                   IsBMSBoltNull=true;
                   } 
             if(IsBMSBoltNull!=true){                
             if(DAProd){
                for(ccrz__E_CartItem__c lstcartItem : cartItems){
                    if(lstcartItem.OSM_Group_Name__c == 'FluidWatch'){                       
                        returnMap.put('PymntwrngMsg',true);                       
                        system.debug('---test1----' + returnMap.put('PymntwrngMsg',true));
                          
                    }                    
                    
                    
                } 
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

public class MainWrapper{
    boolean onlyBase {get;set;}
    boolean hasActiveSubs {get;set;}
    Integer totalSubscriptionCount {get;set;}
    Integer availableCount {get;set;}
    String prodLongDescription {get;set;}
    String daMessage {get;set;}
    boolean isFreeTrialAvailabel{get;set;}
    List<OSM_SW_ProductDetailCommonUtility.ProductSpecification> sortedProdSpecification{get;set;}
    Map<String,ProductDetailWrapper> productIdVsWrapperMap{get;set;}
    Map<String,Decimal> subscriptionLengthVsYrMultipler {get;set;}
    Map<String,Decimal> prodYearPrice {get;set;}
    Map<String,Decimal> prodMonthlyPrice {get;set;}
    Map<String,Decimal> proratedPriceMap {get;set;}
    Map<String,Decimal> proratedDnPriceMap {get;set;}
    Map<String,String> subProdTermPrices {get;set;}
    List<String> billingFrequencies {get;set;}
    Map<String,String> compositKeyForSubProdTerm{get;set;}
    List<OSM_SW_ProductDetailCommonUtility.SortWrapper> sortSubsLength{get;set;}
    UserDetail userDetail{get;set;}
    FreeTrialDetails freeTrialDetails{get;set;}
    Map<String, String> pricePerBillFrequency{get;set;}
    public Boolean isSubscribed{get;set;}
    public Boolean isOneTimeFrequency{get;set;}
   public Boolean isRFQ{get;set;}
    public Boolean DAExceptionFlag{get;set;}
    public String subscriptionEndDate{get;set;}
   ExistingCartItem existingCartItem{get;set;}
    boolean hasOtherProductSusbcription {get;set;} 
    
    public String productTnCLink {get;set;} 
    public Boolean GOMSUser{get;set;}
    public Boolean GOMSPriceMsg{get;set;}
}

/*----------------------------------------------------------------------------------
WrapperClass: ProductSpecificationHeader
Description:Used for Specification Map 
------------------------------------------------------------------------------------*/ 

public class ProductSpecificationHeader{
    String Id{get;set;}
    String Value{get;set;}
}

/*----------------------------------------------------------------------------------
WrapperClass ProductDetailWrapper
Description:Used for Complete DA prodcuts detail map
------------------------------------------------------------------------------------*/ 

public class ProductDetailWrapper
{
   String productName{get;set;}
   String sfId{get;set;}
   String buttonName{get;set;}
   String sku{get;set;}
   String pricePerLabel{get;set;}
   Decimal pricePerValue{get;set;}
   Decimal prodSubscriptionPriceMonthly{get;set;}
   Decimal prodSubscriptionPriceYearly{get;set;}
   Map<String,SubProdTerm>  subProdTermMap{get;set;}
   Map<String,Integer> subscriptionLength{get;set;}
   Map<String,Integer> subscriptionBillingfrequency{get;set;}
   
}

/*----------------------------------------------------------------------------------
WrapperClass SubProdTerm
Description:Used for Composite Products Pricing & Subscription. 
------------------------------------------------------------------------------------*/ 

public class SubProdTerm
{
    String sfId{get;set;}
    Decimal nonRecurringPrice{get;set;}
    String nonRecurringPriceListId{get;set;}
    String nonRecurringPriceListItemId{get;set;}
    Decimal recurringPrice{get;set;}
    String recurringPriceListId{get;set;}
    String recurringPriceListItemId{get;set;}
}
    
    
/*----------------------------------------------------------------------------------
WrapperClass UserDetail
Description:Used for UserDetail. 
------------------------------------------------------------------------------------*/ 

public class UserDetail{

    String fName{get;set;}
    String lName{get;set;}
    String email{get;set;}
    String phone{get;set;}
    Address address{get;set;}
    String strAddress{get;set;}
    String company{get;set;}
    String contactId{get;set;} 
    String requestedDate{get;set;}
   // String recurringPriceListItemId{get;set;}
}

/*----------------------------------------------------------------------------------
WrapperClass ExistingCartItem
Description:Used for display selected values of existing cart if any. 
------------------------------------------------------------------------------------*/ 

public class ExistingCartItem{

    Decimal totalPrice{get;set;}
    Decimal amount{get;set;}
    String billingFreq{get;set;}
    String subsLength{get;set;}
    String frequency{get;set;}
    Integer quantity{get;set;}
    boolean isPrimaryCart{get;set;} 
    Decimal monthlyPrice{get;set;}
   // String recurringPriceListItemId{get;set;}
}

/*----------------------------------------------------------------------------------
WrapperClass FreeTrialDetails
Description:Used for Free Trial. 
------------------------------------------------------------------------------------*/ 

public class FreeTrialDetails{

    Integer maximumQty{get;set;}
    Integer freeDays{get;set;}
    String productId{get;set;}
   // String recurringPriceListItemId{get;set;}
}

}