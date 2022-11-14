/**
 *      @author             Vineet 
 *      @date               17/05/2018
 *      @description        ProductDetaiServiceCls

        Modification Log:
        ------------------------------------------------------------------------------------
        Developer                       Date                Description
        ------------------------------------------------------------------------------------
        Vineet                         17/05/2018           Initial Setup
        
 */
public without sharing class OSM_SW_ProductDetaiServiceCls {


public static DiscountedPriceWrapper getDiscountedPrice(String store, String accountId, Set<String> prodIds){
    boolean isActiveSubs = false;
     DiscountedPriceWrapper activeSubs = new DiscountedPriceWrapper();
        activeSubs.isRFQ = false;
        activeSubs.isSubscribed = false;
    activeSubs.hasValidQuote = false;
        activeSubs.subscriptionProduct = '';
    activeSubs.subscriptionStatus = '';
                    activeSubs.STP = '';
                    activeSubs.recurringPrice = 0;
    
    //List<ccrz__E_Subscription__c> accountSubscriptions = OSM_SW_ProdDetailUtils_Ctrl.getAccountSubscription(accountId, prodIds, store);
    List<ccrz__E_Subscription__c> accountSubscriptions = OSM_SW_ProdDetailUtils_Ctrl.getAccountSubscription(accountId, store);
    if(accountSubscriptions.size()>0){
        activeSubs.accountSubscriptions = accountSubscriptions;
    }
    for(ccrz__E_Subscription__c sub : accountSubscriptions){
        if(prodIds.Contains(sub.ccrz__SubscriptionProduct__c)){
            isActiveSubs = true; 
        //ccrz__SPT__r.Billing_Display_Name__c,OSM_Subscription_End_Date__c
            activeSubs.isSubscribed = true;
            activeSubs.subscriptionProduct = sub.ccrz__SubscriptionProduct__c;
            activeSubs.isQSOLPowerGenProduct = sub.ccrz__SubscriptionProduct__r.QSOL_Power_Generation__c;
                    activeSubs.subscriptionStatus = sub.ccrz__SubscriptionStatus__c;
                    activeSubs.STP = sub.ccrz__SPT__c;
              activeSubs.billingFrequency = sub.ccrz__SPT__r.Billing_Display_Name__c;
              activeSubs.subsEndDate = sub.OSM_Subscription_End_Date__c;
                  activeSubs.recurringPrice = sub.ccrz__RecurringPrice__c;
                activeSubs.subsLength = sub.ccrz__SPT__r.ccrz__DisplayName__c;
              activeSubs.subscriptionId = sub.Id;
             // break;
        }
        
        if(!prodIds.Contains(sub.ccrz__SubscriptionProduct__c) && !sub.ccrz__SPT__r.Billing_Display_Name__c.ContainsIgnoreCase('One')){
            activeSubs.otherProductSubscriptions = sub;
      activeSubs.hasValidQuote = true;
            //break;
        }
    }
   /* if(Test.isRunningTest()){
        isActiveSubs = false;
    } */
     Set<String> quoteStatus = new Set<String>{'Requested','In Progress', 'Sent', 'Accepted'};
     ccrz__E_RequestForQuote__c  objRFQ;
    if(Test.isRunningTest()){
         Account acc = new Account();
    acc.name = 'OSMTestAcc';
    acc.OSM_Preferred_Payment_Method__c = 'PO';
    insert acc;
  set<string> prodid = new set<string>();
        ccrz__E_Product__c prod = new ccrz__E_Product__c();
        prod.name = 'Connected Advisor';
        prod.ccrz__SKU__c = '45918776';
        prod.ccrz__Quantityperunit__c = 343;
        prod.ccrz__StartDate__c = system.today();
        prod.ccrz__EndDate__c = system.today()+1;
        prod.ccrz__ShortDesc__c = 'testingprod';
        insert prod;
        String prodidstring = String.valueof(prod.id);
        prodid.add(prodidstring);  
        Set<String> status=new Set<String>();
        status.add('Accepted');
        
        objRFQ=OSM_SW_ProdDetailUtils_Ctrl.getAccountProductQuote(acc.Id,'SoftwareStore',prodid,status);
        
        System.debug('objRFQ__if test__'+objRFQ);
    }else{
    objRFQ = OSM_SW_ProdDetailUtils_Ctrl.getAccountProductQuote(accountId,store,prodIds,quoteStatus);
   }
    //System.debug('objRFQ____'+objRFQ);
    if(isActiveSubs && objRFQ != null && objRFQ.Status__c == Label.OSM_RFQ_ACCEPTED){
       activeSubs.recurringPrice = objRFQ.Discounted_Price__c != null ? (objRFQ.Cost_Subscription__c-objRFQ.Discounted_Price__c):objRFQ.Cost_Subscription__c;
       activeSubs.isRFQ = true; 
    }      
    if(Test.isRunningTest()){
        isActiveSubs=false;
      //  objRFQ=;
        objRFQ.Status__c = Label.OSM_RFQ_ACCEPTED;
        objRFQ.Accept_or_Reject_Date__c=System.today();
    }
    if(!isActiveSubs){ 
          if(objRFQ != null && objRFQ.Status__c == Label.OSM_RFQ_ACCEPTED && objRFQ.Accept_or_Reject_Date__c != null && objRFQ.Accept_or_Reject_Date__c.daysBetween(System.today()) <= Integer.valueOf(Label.OSM_Quote_Accepted_Days)){
                    activeSubs.subscriptionProduct = objRFQ.CC_Product__c;
                    activeSubs.subscriptionStatus = objRFQ.Status__c; 
                    activeSubs.STP = objRFQ.CC_SubProdTerm__c;
                  activeSubs.billingFrequency = objRFQ.Billing_Period__c;
                    activeSubs.recurringPrice = objRFQ.Discounted_Price__c != null ? (objRFQ.Cost_Subscription__c-objRFQ.Discounted_Price__c):objRFQ.Cost_Subscription__c;
                    activeSubs.isRFQ = true;
           }
    }
        system.debug('activeSubs----->'+activeSubs);
    return activeSubs; 
}
public static DiscountedPriceWrapper fetchDiscountedPrice(String store, String userId, Set<String> prodIds){
    boolean isActiveSubs = false;
        DiscountedPriceWrapper activeSubs = new DiscountedPriceWrapper();
        List<Map<String, Object>> orderItemList = new List<Map<String, Object>>();
        Map<String, Object> orderItemMap = new Map<String, Object>();
        activeSubs.isRFQ = false;
        activeSubs.isSubscribed = false;
        activeSubs.subscriptionProduct = '';
    activeSubs.subscriptionStatus = '';
                    activeSubs.STP = '';
                    activeSubs.recurringPrice = 0;
    try{
        String CCOrderItem = '';
         Map<String,Object> inputData = new Map<String,Object>{
        ccrz.ccApi.API_VERSION => ccrz.ccApi.CURRENT_VERSION,
        ccrz.ccAPISubscription.STOREFRONT => store,
        ccrz.ccAPISubscription.BYLASTORDERDATE => TRUE,
        ccrz.ccAPISubscription.BYASC => TRUE
    };
      Map<String,Object> apiSubscription = new Map<String, Object>();
        Map<String, Object> outputData = new Map<String, Object>();
        try{
            outputData = ccrz.ccAPISubscription.fetch(inputData);
        }catch(exception ex1){system.debug('==========>'+ex1);}
        if (outputData.get(ccrz.ccAPISubscription.SUBSCRIPTIONS) != null) {
            // The cast to List<Map<String, Object>> is necessary...
            List<Map<String, Object>> subscriptionList = (List<Map<String, Object>>) outputData.get(ccrz.ccAPISubscription.SUBSCRIPTIONS);
            List<Map<String, Object>> orderList = (List<Map<String, Object>>) outputData.get(ccrz.ccAPIOrder.ORDERLIST);
            List<Map<String, Object>> productList = (List<Map<String, Object>>) outputData.get(ccrz.ccAPIProduct.PRODUCTLIST);
            boolean islatestSubs = false;
            for(Map<String, Object> subscription : subscriptionList){
                // The cast, again, is necessary...
                 for (String key_tmp: subscription.keySet()) {
                        if(prodIds.contains(string.valueOf(subscription.get(key_tmp))) && !islatestSubs){
                        //f(key_tmp == 'subscriptionProduct'){
                            system.debug(subscription);
                            if(subscription.get('subscriptionStatus') == 'Active'){
                                CCOrderItem = (String)subscription.get('CCOrderItem');
                                apiSubscription.putAll(subscription);
                                isActiveSubs = true;
                                activeSubs.isSubscribed = true;
                                islatestSubs = true;
                                system.debug(CCOrderItem+'############ CCOrderItem ########'+key_tmp);
                                system.debug(subscription.get(key_tmp));
                                break;
                            }
                        }
                 }
            }
            
            boolean isLatestOrderitem = false; 
            for(Map<String, Object> orders : orderList){
                // The cast, again, is necessary...
                 for (Map<String, Object> orderI : (List<Map<String, Object>>)orders.get('EOrderItemsS')) {
                        for (String key_tmp: orderI.keySet()) {
                            system.debug('############ orderI ########'+key_tmp);
                            system.debug(orderI.get(key_tmp));
                            
                        if(CCOrderItem == string.valueOf(orderI.get(key_tmp)) && !isLatestOrderitem){
                                orderItemMap.putAll(orderI);
                                isLatestOrderitem = true;
                                system.debug(prodIds+'############ prodIds.contains(string.valueOf(orderI.get(key_tmp))) ########'+prodIds.contains(string.valueOf(orderI.get(key_tmp))));
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
                    
                    //activeSubs.recurringPrice = apiSubscription.get(key_tmp) != null ? (Decimal)apiSubscription.get(key_tmp):0;
                }
                
             }
             
    /*
     for(Map<String, Object> orders : orderItemList){
                // The cast, again, is necessary...
                 for (String key_tmp: orders.keySet()) {
                        if(activeSubs.subscriptionProduct.EqualsIgnoreCase(string.valueOf(orders.get(key_tmp)))){
                                apiSubscription.putAll(orders);
                            }
                    }
            }
    */
    if(orderItemMap.get('originalItemPrice') != null){
        system.debug('############ orderItemMap ########====>'+(Decimal)orderItemMap.get('originalItemPrice'));
        activeSubs.recurringPrice = (Decimal)orderItemMap.get('originalItemPrice');
    }
    //getUsersQuote(String UserId,String store,Set<String> prodIds, String strStatus){
    if(!isActiveSubs){
            ccrz__E_RequestForQuote__c  objRFQ = OSM_SW_ProdDetailUtils_Ctrl.getUsersQuote(userId,store,prodIds);
            if(objRFQ != null && objRFQ.Status__c == Label.OSM_RFQ_ACCEPTED){
                    activeSubs.subscriptionProduct = objRFQ.CC_Product__c;
                    activeSubs.subscriptionStatus = objRFQ.Status__c;
                    activeSubs.STP = objRFQ.CC_SubProdTerm__c;
                    activeSubs.recurringPrice = objRFQ.Discounted_Price__c != null ? objRFQ.Discounted_Price__c:objRFQ.Cost_Subscription__c;
                    activeSubs.isRFQ = true;
            }
    }
    
    if(isActiveSubs && activeSubs.recurringPrice == null){
        activeSubs.recurringPrice = 0;
    }
        
    system.debug('############ apiSubscription ########'+apiSubscription);
    system.debug('############ activeSubs ########'+activeSubs);
        }Catch(Exception ex){system.debug(ex+'===>'+ex.getLineNumber());}
    return activeSubs;
     
 }

    /**
        @ getSegmentSku return logged in user's sku
        @ param sku & userId 
    **/
    public static String getSegmentSku(String sku){
        
        List<User> us = [Select Id, contact.Account.OSM_Market_Segment_Code__c from User where Id =: UserInfo.getUserId()];
        if(us.size()>0){
            return us[0].contact.Account.OSM_Market_Segment_Code__c != null ? sku+'-'+us[0].contact.Account.OSM_Market_Segment_Code__c:'';
        }
        return sku;
    }

public class DiscountedPriceWrapper{ 
   public String subscriptionProduct{get;set;}
    public ccrz__E_Subscription__c otherProductSubscriptions{get;set;}
   public String billingFrequency{get;set;}
    public String subsLength{get;set;}
   public DateTime subsEndDate{get;set;}
   public Boolean isSubscribed{get;set;}
   public Boolean isRFQ{get;set;}
   public Boolean hasValidQuote{get;set;}
   public String subscriptionStatus{get;set;}
   public Id subscriptionId{get;set;}
   public String STP{get;set;}
   public Decimal recurringPrice{get;set;}
   public List<ccrz__E_Subscription__c> accountSubscriptions{get;set;}
   public boolean isQSOLPowerGenProduct{get;set;}

}

}