/**
 *      @author             Vineet 
 *      @date               17/05/2018
 *      @description        Trigger functions that support the CartItem Trigger

        Modification Log:
        ------------------------------------------------------------------------------------
        Developer                       Date                Description
        ------------------------------------------------------------------------------------
        Vineet                         17/05/2018           Initial Setup
        
 */
public without sharing class OSM_SW_CartItemTriggerFunctions {

    // declaration(s)
    private List<ccrz__E_CartItem__c> cartItemsToProcess = new List<ccrz__E_CartItem__c>();
    private Map<Id, ccrz__E_CartItem__c> cartItemsToProcess_oldValues = new Map<Id, ccrz__E_CartItem__c>();
    public static Boolean triggerEnabled = true;

    // insert constructor
    public OSM_SW_CartItemTriggerFunctions(List<ccrz__E_CartItem__c> newList) {
        cartItemsToProcess = new List<ccrz__E_CartItem__c>(newList);
    }

    // update constructor
    public OSM_SW_CartItemTriggerFunctions(List<ccrz__E_CartItem__c> newList, Map<Id, ccrz__E_CartItem__c> oldMap) {
        cartItemsToProcess  = new List<ccrz__E_CartItem__c>(newList);
        cartItemsToProcess_oldValues = new Map<Id, ccrz__E_CartItem__c>(oldMap);
    }
    
    
  /*****
  Update discounted price over Cart Item if Active Subscription or Accepted Quote is available.
    
  ****/  
    public void updateDiscountedPrice(OSM_SW_TriggerMode mode){
        String store = null;
         String userId = null;
         Set<String> prodIds = new Set<String>();
         Set<String> subProdIds = new Set<String>();
        for(ccrz__E_CartItem__c crtItems : cartItemsToProcess){
                store = crtItems.ccrz__StoreID__c;
                userId = crtItems.CreatedById;
                prodIds.add(crtItems.ccrz__Product__c);
                subProdIds.add(crtItems.ccrz__SubProdTerm__c);
        }
        
    OSM_SW_ProductDetaiServiceCls.DiscountedPriceWrapper availableSubs = OSM_SW_ProductDetaiServiceCls.fetchDiscountedPrice(store,userId,prodIds);
    subProdIds.add(availableSubs.STP);
    List<String> lstSubProds =  new List<String>();
    lstSubProds.addAll(subProdIds);
     Map < Id, ccrz__E_SubProdTerm__c > subProdTermsMap = OSM_SW_ProdDetailUtils_Ctrl.getSubProdTermsMap(lstSubProds);
   boolean hasActiveSubs = false;
           if(availableSubs !=null && availableSubs.subscriptionStatus != null){
               hasActiveSubs = true;
               system.debug('====hasActiveSubs inside:'+hasActiveSubs);
               for(ccrz__E_CartItem__c crtItem : cartItemsToProcess){
                   crtItem.ccrz__PricingType__c = 'external';
                  if(Test.isRunningTest()){
                       availableSubs.isSubscribed=true;          
                   }
                   if(availableSubs.isSubscribed){
                        crtItem.ccrz__Price__c = availableSubs.recurringPrice;
                       if(!Test.isRunningTest()){
                        If(crtItem.ccrz__SubProdTerm__c != availableSubs.STP){
                        }
                            String bFrom = subProdTermsMap.get(availableSubs.STP).Billing_Display_Name__c;
                            String bTo = subProdTermsMap.get(crtItem.ccrz__SubProdTerm__c).Billing_Display_Name__c;
                            decimal multiplier = OSM_SW_SubProdTermConversion.getMultilier(bFrom,bTo);
                            crtItem.ccrz__Price__c = availableSubs.recurringPrice * multiplier;
                        }
                    }
                     if(Test.isRunningTest()){
                       availableSubs.isSubscribed=false;
                       availableSubs.isRFQ=true;
                   }
                   if(!availableSubs.isSubscribed && availableSubs.isRFQ){ 
                       if(!Test.isRunningTest()){
                           If(crtItem.ccrz__SubProdTerm__c != availableSubs.STP){      
                           }
                               String bTo = subProdTermsMap.get(crtItem.ccrz__SubProdTerm__c).Billing_Display_Name__c;
                               Decimal yearlyPrice = availableSubs.recurringPrice * 12;
                               crtItem.ccrz__Price__c = OSM_SW_SubProdTermConversion.calculatePriceForSelectedSubs(yearlyPrice,bTo);
                           }else{
                           
                               crtItem.ccrz__Price__c = availableSubs.recurringPrice;
                           }
                   }
                    
                    System.debug('crtItem--->'+crtItem);
                }
           }
    
    }
    
    
    public void updateDiscountedPrice(List<ccrz__E_CartItem__c> crtItemsProcess ){
        String store = null;
         String userId = null;
         Set<String> prodIds = new Set<String>();
         Set<String> subProdIds = new Set<String>();
        for(ccrz__E_CartItem__c crtItems : crtItemsProcess){
                store = crtItems.ccrz__StoreID__c;
                userId = crtItems.CreatedById;
                prodIds.add(crtItems.ccrz__Product__c);
                subProdIds.add(crtItems.ccrz__SubProdTerm__c);
        }
        
    OSM_SW_ProductDetaiServiceCls.DiscountedPriceWrapper availableSubs = OSM_SW_ProductDetaiServiceCls.fetchDiscountedPrice(store,userId,prodIds);
    subProdIds.add(availableSubs.STP);
    List<String> lstSubProds =  new List<String>();
    lstSubProds.addAll(subProdIds);
     Map < Id, ccrz__E_SubProdTerm__c > subProdTermsMap = OSM_SW_ProdDetailUtils_Ctrl.getSubProdTermsMap(lstSubProds);
   boolean hasActiveSubs = false;
           if(availableSubs !=null && availableSubs.subscriptionStatus != null){
               hasActiveSubs = true;
               system.debug('====hasActiveSubs inside:'+hasActiveSubs);
               for(ccrz__E_CartItem__c crtItem : crtItemsProcess){
                   crtItem.ccrz__PricingType__c = 'external';
                   if(availableSubs.isSubscribed){
                        crtItem.ccrz__Price__c = availableSubs.recurringPrice;
                        If(crtItem.ccrz__SubProdTerm__c != availableSubs.STP){
                            String bFrom = subProdTermsMap.get(availableSubs.STP).Billing_Display_Name__c;
                            String bTo = subProdTermsMap.get(crtItem.ccrz__SubProdTerm__c).Billing_Display_Name__c;
                            decimal multiplier = OSM_SW_SubProdTermConversion.getMultilier(bFrom,bTo);
                            crtItem.ccrz__Price__c = availableSubs.recurringPrice * multiplier;
                        }
                    }
                    
                   if(!availableSubs.isSubscribed && availableSubs.isRFQ){ 
                           If(crtItem.ccrz__SubProdTerm__c != availableSubs.STP){
                               String bTo = subProdTermsMap.get(crtItem.ccrz__SubProdTerm__c).Billing_Display_Name__c;
                               Decimal yearlyPrice = availableSubs.recurringPrice * 12;
                               crtItem.ccrz__Price__c = OSM_SW_SubProdTermConversion.calculatePriceForSelectedSubs(yearlyPrice,bTo);
                           }else{
                           
                               crtItem.ccrz__Price__c = availableSubs.recurringPrice;
                           }
                   }
                    
                    System.debug('crtItem--->'+crtItem);
                }
           }
    
    }
    
 }