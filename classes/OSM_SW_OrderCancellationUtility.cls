//ON ORDER CANCELLATION - this method will update transaction payment record, order line items, subscription record and order susbcription record based on order
public class OSM_SW_OrderCancellationUtility {

    public static void updateRecordsOnOrderCancellation(Set < Id > OrderId) {
   
     //Initializing map based on order
     Map < String, List < ccrz__E_OrderItem__c >> mapOrderIdVsOrderItemLst = new Map < String, List < ccrz__E_OrderItem__c >> ();
     String action = label.OSM_Order_Cancellation;
     List < Id > productId = new List < Id > (); //Set of product id's
     List < Id > orderItemIdforWithOutCotermProduct = new List < Id > (); //Set of product id's
     Map<Id, boolean> productIdToRenew = new Map<Id, boolean>();
     OSM_Integration_Log__c log = null;
     Map < String, OSM_SW_OrderSubscriptionWrapper > mapProdSkuVsWrap = new Map < String, OSM_SW_OrderSubscriptionWrapper > (); //Map of product sku of that order subscription wrapper
     List < ccrz__E_Subscription__c > subsToUpdate = new List < ccrz__E_Subscription__c > ();
     Map < Id, Map < Id, List < OSM_Order_Subscription__c >>> mapAccVsSubsVsOrderSubs = new Map < Id, Map < Id, List < OSM_Order_Subscription__c >>> ();
     List < Id > subsIdList = new List < Id > ();
     Id accId;
     Boolean MissingParametersFlag = false;
     Boolean MissingOrderSubsJunc = false;
     Set < Boolean > setOfFlags = new Set < Boolean > (); //Set to check wrapper parameters
     Set < Id > SetOfIds = new Set < Id > ();
     if(test.isRunningTest())setOfFlags.add(true);
     Savepoint sp = Database.setSavepoint(); //Set savepoint
      
     try {
      //Get list of cancelled orders
      List < ccrz__E_Order__c > cancelledOrderRec = [Select id, name, ccrz__OrderStatus__c,ccrz__Account__r.Is_Coupon_Already_Used__c, ccrz__Account__c, (Select id, ccrz__Product__c,ccrz__Product__r.Group_Name__c,ccrz__OrderItemStatus__c, ccrz__Product__r.ccrz__SKU__c, ccrz__ParentOrderItem__c, ccrz__Quantity__c, OSM_SW_Is_without_Coterm__c,isRenew__c, ccrz__Order__r.ccrz__Account__c, ccrz__Order__r.name from ccrz__E_OrderItems__r) from ccrz__E_Order__c where id IN: OrderId];
      system.debug('cancelledOrderRec' + cancelledOrderRec);
   
      //Populate respective maps
      if (cancelledOrderRec != null && cancelledOrderRec.size() > 0) {
       for (ccrz__E_Order__c orderRec: cancelledOrderRec) {
        if (orderRec.ccrz__E_OrderItems__r != null) {
         accId = orderRec.ccrz__Account__c;
         mapOrderIdVsOrderItemLst.put(orderRec.id, orderRec.ccrz__E_OrderItems__r);
        } else {
         break;
        }
       }
       system.debug('mapOrderIdVsOrderItemLst' + mapOrderIdVsOrderItemLst);
   
       if (mapOrderIdVsOrderItemLst.keyset() != null && mapOrderIdVsOrderItemLst.size() > 0) {
        for (ccrz__E_Order__c cancelOrder: cancelledOrderRec) {
   
         //Get Order Line Item  
         for (ccrz__E_OrderItem__c oItem: mapOrderIdVsOrderItemLst.get(cancelOrder.id)) {
   
           if(oItem.ccrz__ParentOrderItem__c == null)
           {
               if(oItem.OSM_SW_Is_without_Coterm__c)
               {
                   orderItemIdforWithOutCotermProduct.add(oItem.id);
               }else
               {
                   productId.add(oItem.ccrz__Product__c);
               }
               
               productIdToRenew.put(oItem.ccrz__Product__c, oItem.isRenew__c);
              //Create OSM_SW_OrderSubscriptionWrapper wrapper
              OSM_SW_OrderSubscriptionWrapper osWrap = new OSM_SW_OrderSubscriptionWrapper();
              osWrap.osm_orderId = cancelOrder.name;
              osWrap.osm_productId = oItem.ccrz__Product__r.ccrz__SKU__c;
              osWrap.osm_quantity = Integer.valueOf(oItem.ccrz__Quantity__c);
              mapProdSkuVsWrap.put(osWrap.osm_productId+'~'+oItem.Id, osWrap);
           }
          
   
         }
        }
       }
       system.debug('mapProdSkuVsWrap' + mapProdSkuVsWrap);
       system.debug('productId' + productId);
       system.debug('accid'+accid);
   
       //Get Subscription record: sharad commengting this method because this method return only active subscription but we have to retrive renew subsc also if cancle call is for renew order item.
       //subsToUpdate = OSM_SW_Transaction_Util.fetchActiveSubscriptionForAccount(accid, productId);
       // add query
       //Mp-711 removed co-term check from the query
       List<ccrz__E_Subscription__c> subscTempList = new List<ccrz__E_Subscription__c>([select id,name, ccrz__Account__c, Recurring_Invoice_Start_Date__c,OSM_Free_Trial__c,ccrz__SubscriptionStatus__c,ccrz__Quantity__c,ccrz__SubscriptionProduct__c,ccrz__InstallmentNextDate__c,ccrz__SubscriptionProduct__r.Name,ccrz__SubscriptionProduct__r.ccrz__SKU__c,OSM_Subscription_End_Date__c,ccrz__SubscriptionStartDate__c,ccrz__InstallmentLastDate__c 
                                                                                    from ccrz__E_Subscription__c 
                                                                                    where (ccrz__SubscriptionStatus__c='Active'  OR ccrz__SubscriptionStatus__c='Renew')
                                                                                       and ccrz__Storefront__c='SoftwareStore' 
                                                                                       and ccrz__SubscriptionProduct__c in:productId and ccrz__Account__c=:accid]);
                                                                                       
       // Code for product without coterm
       System.debug('orderItemIdforWithOutCotermProduct: '+orderItemIdforWithOutCotermProduct);
       {
           if(orderItemIdforWithOutCotermProduct != null && orderItemIdforWithOutCotermProduct.size() > 0)
           {
               List<OSM_Order_Subscription__c> lstOrderSubsc = new List<OSM_Order_Subscription__c>();
               lstOrderSubsc = [Select Id,OSM_CCSubscription__c from OSM_Order_Subscription__c where CC_Order_Item__c IN: orderItemIdforWithOutCotermProduct];
               System.debug('lstOrderSubsc: '+lstOrderSubsc);
               if(lstOrderSubsc != null && lstOrderSubsc.size() > 0)
               {
                   Set<Id> subscIdSet = new Set<Id>();
                   for(OSM_Order_Subscription__c objOS : lstOrderSubsc)
                       subscIdSet.add(objOS.OSM_CCSubscription__c);
                   
                   List<ccrz__E_Subscription__c> subscTempList2 = new List<ccrz__E_Subscription__c>([select id,name, ccrz__Account__c, Recurring_Invoice_Start_Date__c,OSM_Free_Trial__c,ccrz__SubscriptionStatus__c,ccrz__Quantity__c,ccrz__SubscriptionProduct__c,ccrz__InstallmentNextDate__c,ccrz__SubscriptionProduct__r.Name,ccrz__SubscriptionProduct__r.ccrz__SKU__c,OSM_Subscription_End_Date__c,ccrz__SubscriptionStartDate__c,ccrz__InstallmentLastDate__c 
                                                                                    from ccrz__E_Subscription__c 
                                                                                    where (ccrz__SubscriptionStatus__c='Active' OR ccrz__SubscriptionStatus__c='Renew') //added by swetha ccrz__SubscriptionStatus__c='Renew'
                                                                                       and ccrz__Storefront__c='SoftwareStore' 
                                                                                       and Id IN: subscIdSet]);
                   if(subscTempList2 != null && subscTempList2.size() > 0)
                   {
                       for(ccrz__E_Subscription__c objSub : subscTempList2)
                           subscTempList.add(objSub);
                   }
               }
           }
           
       }
       // code end for co term
       
       for(ccrz__E_Subscription__c objSubsc : subscTempList)
       {
           if(productIdToRenew.containsKey(objSubsc.ccrz__SubscriptionProduct__c))
           {
               if(productIdToRenew.get(objSubsc.ccrz__SubscriptionProduct__c) && objSubsc.ccrz__SubscriptionStatus__c == 'Renew')
               {
                   subsToUpdate.add(objSubsc);
               }
               
               /*if(!productIdToRenew.get(objSubsc.ccrz__SubscriptionProduct__c) && objSubsc.ccrz__SubscriptionStatus__c == 'Active')
               {
                   subsToUpdate.add(objSubsc);
               }*/
               //Changes done by Karthik for MP - 711. Tis will let the subscriptions whose status is changed from renew to active to be
               //added to the list. 
               if(objSubsc.ccrz__SubscriptionStatus__c == 'Active')
               {
                   subsToUpdate.add(objSubsc);
               }
           }
       }
     
     // Commented By Ashish (No need to cancel the order here otherwise credit memo will not be generated.)
       /*
       List<ccrz__E_OrderItem__c> listFWOrderItems = new List<ccrz__E_OrderItem__c>();
       List<ccrz__E_Order__c > listFWOrders = new List<ccrz__E_Order__c >();
       if(subscTempList.size()==0 || subscTempList == Null ){
       ccrz__E_TransactionPayment__c transPayment = new ccrz__E_TransactionPayment__c();
       transPayment= [Select id, name, Transaction_Status__c, ccrz__AccountType__c, Bolt_Credit_Memo_Call_Status__c, Bolt_JE_Reversal_Call_Status__c from ccrz__E_TransactionPayment__c where ccrz__CCOrder__c=:cancelledOrderRec[0].id]; 
       for (ccrz__E_Order__c cancelOrder: cancelledOrderRec) {
           cancelOrder.ccrz__OrderStatus__c=label.OSM_OrderItem_Cancellation_Status;
           for (ccrz__E_OrderItem__c oItem: mapOrderIdVsOrderItemLst.get(cancelOrder.id)) {
               
               if(oItem.ccrz__OrderItemStatus__c ==Label.OSM_CancellationPending && oItem.ccrz__ParentOrderItem__c == Null && oItem.ccrz__Product__r.Group_Name__c=='FluidWatch'){
                   oItem.ccrz__OrderItemStatus__c = label.OSM_OrderItem_Cancellation_Status;
                   oItem.VertexOrderItemCall__c = True;
               }
               
               listFWOrderItems.add(oItem);
           }
           
           listFWOrders.add(cancelOrder); 
         }
           Update listFWOrders;
           Update listFWOrderItems;
           transPayment.Transaction_Status__c ='OrderItem Cancel Success';
           Update transPayment;
           log = new OSM_Integration_Log__c();
           OSM_SW_LoggingContext.integrationLog = log;
           log.Service_Name__c = label.OSM_Order_Cancellation;
           log.Response__c = label.OSM_Order_Cancellation_Message;
           log.Source__c = 'FluidWatch';
           log.Target__c = 'FluidWatch'; 
           log.Status__c = label.OSM_Subs_Cancellation_Success;
           log.Logged_In_User__c = userinfo.getUserId();
           system.debug('log'+log);
           OSM_SW_LoggingContext.saveIntegrationLog(log);   
       }
     */
       
       system.debug('subsToUpdate' + subsToUpdate);
   
       if (subsToUpdate != null && subsToUpdate.size() > 0) {
        for (ccrz__E_Subscription__c subsId: subsToUpdate) {
         subsIdList.add(subsId.id);
        }
       }
     
     List<OSM_Order_Subscription__c> orderSubscList = new List<OSM_Order_Subscription__c>();
     if(subsIdList != null && subsIdList.size() > 0)
     {
       orderSubscList = [Select Id,OSM_CCSubscription__r.name,CC_Order_Item__c,OSM_CCSubscription__c,OSM_CCSubscription__r.ccrz__Account__c,OSM_CCSubscription__r.ccrz__SubscriptionProduct__r.ccrz__SKU__c,OSM_CCSubscription__r.ccrz__SubscriptionProduct__r.name,OSM_CCSubscription__r.ccrz__SubscriptionProduct__r.Id from OSM_Order_Subscription__c where OSM_CCSubscription__c IN: subsIdList];
     }
     
       system.debug('subsIdList' + subsIdList);
   
       //fetchAllOrderInfoForSubscriptionsWithOneTime
       if (mapProdSkuVsWrap.keyset() != null && mapProdSkuVsWrap.size() > 0) {
        mapAccVsSubsVsOrderSubs = OSM_SW_Transaction_Util.fetchAllOrderInfoForSubscriptionsWithOneTime(subsIdList);
       }
       system.debug('mapAccVsSubsVsOrderSubs' + mapAccVsSubsVsOrderSubs);
   
       if (mapAccVsSubsVsOrderSubs.keyset() != null && mapAccVsSubsVsOrderSubs.size() > 0) {
        //Adding subscription and order susbcription to wrapper map
        for (ccrz__E_Order__c cancelOrder: cancelledOrderRec) {
         for (OSM_Order_Subscription__c ccsubs: orderSubscList) {
          if (ccsubs.OSM_CCSubscription__r.ccrz__Account__c == cancelOrder.ccrz__Account__c) {
           if ((mapProdSkuVsWrap.containsKey(ccsubs.OSM_CCSubscription__r.ccrz__SubscriptionProduct__r.ccrz__SKU__c+'~'+ccsubs.CC_Order_Item__c))) {
            system.debug('Inside get subscription loop');
            //Get subscription
            mapProdSkuVsWrap.get(ccsubs.OSM_CCSubscription__r.ccrz__SubscriptionProduct__r.ccrz__SKU__c+'~'+ccsubs.CC_Order_Item__c).osm_subscriptionID = ccsubs.OSM_CCSubscription__r.name;
   
            //Get Order Subscription
            if (mapAccVsSubsVsOrderSubs.containsKey(cancelOrder.ccrz__Account__c)) {
             if (mapAccVsSubsVsOrderSubs.get(cancelOrder.ccrz__Account__c).containsKey(ccsubs.OSM_CCSubscription__r.id) && ((mapAccVsSubsVsOrderSubs.get(cancelOrder.ccrz__Account__c)).get(ccsubs.OSM_CCSubscription__r.id) != null)) {
   
              List < OSM_Order_Subscription__c > osmSublist = (mapAccVsSubsVsOrderSubs.get(cancelOrder.ccrz__Account__c)).get(ccsubs.OSM_CCSubscription__r.id);
   
              for (OSM_Order_Subscription__c osmSub: osmSublist) {
               if ((osmSub.OSM_CCSubscription__c == ccsubs.OSM_CCSubscription__r.id) && (osmSub.OSM_CCOrder__c == cancelOrder.id)) {
                mapProdSkuVsWrap.get(ccsubs.OSM_CCSubscription__r.ccrz__SubscriptionProduct__r.ccrz__SKU__c+'~'+ccsubs.CC_Order_Item__c).osm_orderSubs = osmSub;
               }
              }
             }
            }
           }
          }
         }
        }
       }
       system.debug('mapProdSkuVsWrap' + mapProdSkuVsWrap);
       
       Set<String> setKeyToRemove = new Set<String>();
       for(String strKey : mapProdSkuVsWrap.keySet())
       {
           if(mapProdSkuVsWrap.get(strKey).osm_orderSubs == null )
           {
               setKeyToRemove.add(strKey);
           }
       }
       if(setKeyToRemove != null && setKeyToRemove.size() > 0)
       {
           for(String key : setKeyToRemove)
           {
               if(mapProdSkuVsWrap.containsKey(key))
               {
                   mapProdSkuVsWrap.remove(key);
               }
           }
       }
       
   
       if (mapProdSkuVsWrap != null && mapProdSkuVsWrap.size() > 0) {
        for (OSM_SW_OrderSubscriptionWrapper oswrap: mapProdSkuVsWrap.values()) {
         if ((oswrap.osm_orderId == null) || (oswrap.osm_subscriptionID == null) || (oswrap.osm_quantity == null) || (oswrap.osm_productId == null)) {
           MissingParametersFlag = true; //Set flag to true
           setOfFlags.add(MissingParametersFlag); //Add flag to set
         }else if(oswrap.osm_orderSubs == null){
           MissingOrderSubsJunc = true;       
           MissingParametersFlag = true; //Set flag to true
           setOfFlags.add(MissingParametersFlag); //Add flag to set      
         }
        }
        system.debug('setOfFlags' + setOfFlags);
   
       if(setOfFlags.contains(true)) {
           throw new OSM_SW_OrderProcesssingException(label.OSM_Order_Cancellation_Throw_Exception);
       }else {
           //Call the method to update
           SetOfIds = OSM_WS_CancelPartialSubscription.updateSubscriptionAndJunction(mapProdSkuVsWrap.values(), action,false);
           }
       }
      }
     }catch(OSM_SW_OrderProcesssingException e){
           system.debug('Exception-' + e.getMessage());
           Database.rollback(sp); //set rollback
           //Create Integration log
           log = new OSM_Integration_Log__c();
           OSM_SW_LoggingContext.integrationLog = log;
           log.Service_Name__c = action;
           log.Source__c = label.OSM_Partial_Subscription_Cancellation_Source;
           log.Target__c = label.OSM_Partial_Subscription_Cancellation_Target;
           log.Response__c = e.getMessage() + '. Error at line number ' + e.getLineNumber();
           if(MissingOrderSubsJunc = false){
               log.Error_Description__c = label.OSM_Order_Cancellation_Required_Error_Description;
           }else if(MissingOrderSubsJunc = true){
               log.Error_Description__c = label.OSM_OrderSubsMissing;
           }
           log.Status__c = label.OSM_Subs_Cancellation_Failure;
           log.Logged_In_User__c = userinfo.getUserId();
           OSM_SW_LoggingContext.saveIntegrationLog(log); //Save the integration log record                       
           system.debug('log' + log);
           //throw new OSM_SW_OrderProcesssingException('Message' + e.getMessage());
       } 
       catch(Exception e){
          system.debug('Exception-' + e.getMessage());
          Database.rollback(sp); //set rollback
          //Create Integration log
          log = new OSM_Integration_Log__c();
          OSM_SW_LoggingContext.integrationLog = log;
          log.Service_Name__c = action;
          log.Source__c = label.OSM_Partial_Subscription_Cancellation_Source;
          log.Target__c = label.OSM_Partial_Subscription_Cancellation_Target;
          log.Response__c = e.getMessage() + '. Error at line number ' + e.getLineNumber();
          log.Error_Description__c = e.getStacktraceString();
          log.Status__c = label.OSM_Subs_Cancellation_Failure;
          log.Logged_In_User__c = userinfo.getUserId();
          OSM_SW_LoggingContext.saveIntegrationLog(log); //Save the integration log record                       
          system.debug('log' + log);
       }
    }
   
   public static void updateRecordsOnOrderItemCancellation(Set < Id > OrderItemId, string actionType) {
   
     //Initializing map based on order
     Map < String, List < ccrz__E_OrderItem__c >> mapOrderIdVsOrderItemLst = new Map < String, List < ccrz__E_OrderItem__c >> ();
     String action = label.OSM_Order_Cancellation;
     if(actionType == 'Revoke'){
        action = 'Revoke';
     }
     List < Id > productId = new List < Id > (); //Set of product id's
     List < Id > orderItemIdforWithOutCotermProduct = new List < Id > (); //Set of product id's
     Map<Id, boolean> productIdToRenew = new Map<Id, boolean>();
     OSM_Integration_Log__c log = null;
     Map < String, OSM_SW_OrderSubscriptionWrapper > mapProdSkuVsWrap = new Map < String, OSM_SW_OrderSubscriptionWrapper > (); //Map of product sku of that order subscription wrapper
     List < ccrz__E_Subscription__c > subsToUpdate = new List < ccrz__E_Subscription__c > ();
     Map < Id, Map < Id, List < OSM_Order_Subscription__c >>> mapAccVsSubsVsOrderSubs = new Map < Id, Map < Id, List < OSM_Order_Subscription__c >>> ();
     List < Id > subsIdList = new List < Id > ();
     Id accId;
     Id orderId;
     Boolean MissingParametersFlag = false;
     Boolean MissingOrderSubsJunc = false;
     Set < Boolean > setOfFlags = new Set < Boolean > (); //Set to check wrapper parameters
     Set < Id > SetOfIds = new Set < Id > ();
     if(test.isRunningTest())setOfFlags.add(true);
     Savepoint sp = Database.setSavepoint(); //Set savepoint
      
     try {
      //Get list of cancelled orders
      List < ccrz__E_OrderItem__c > cancelledOrderRec = [Select Id,ccrz__Product__r.Group_Name__c,ccrz__Order__c,ccrz__Product__r.ccrz__SKU__c,ccrz__Quantity__c,isRenew__c,ccrz__Product__c,OSM_SW_Is_without_Coterm__c,ccrz__ParentOrderItem__c,ccrz__Order__r.name,ccrz__Order__r.ccrz__Account__c,ccrz__OrderItemStatus__c, CancelLicenseAPICalled__c  from ccrz__E_OrderItem__c where Id IN: OrderItemId];
      system.debug('cancelledOrderRec' + cancelledOrderRec);
   
      //Populate respective maps
      if (cancelledOrderRec != null && cancelledOrderRec.size() > 0) {
       
       system.debug('mapOrderIdVsOrderItemLst' + mapOrderIdVsOrderItemLst);
   
         //Get Order Line Item  
         for (ccrz__E_OrderItem__c oItem: cancelledOrderRec) {
           if(oItem.ccrz__Order__r.ccrz__Account__c !=Null){
               accId = oItem.ccrz__Order__r.ccrz__Account__c;
               orderId = oItem.ccrz__Order__c;
           }
           if(oItem.ccrz__ParentOrderItem__c == null)
           {
               if(oItem.OSM_SW_Is_without_Coterm__c)
               {
                   orderItemIdforWithOutCotermProduct.add(oItem.id);
               }else
               {
                   productId.add(oItem.ccrz__Product__c);
               }
               
               productIdToRenew.put(oItem.ccrz__Product__c, oItem.isRenew__c);
              //Create OSM_SW_OrderSubscriptionWrapper wrapper
              OSM_SW_OrderSubscriptionWrapper osWrap = new OSM_SW_OrderSubscriptionWrapper();
              osWrap.osm_orderId = oItem.ccrz__Order__r.name;
              osWrap.osm_productId = oItem.ccrz__Product__r.ccrz__SKU__c;
              osWrap.osm_quantity = Integer.valueOf(oItem.ccrz__Quantity__c);
              mapProdSkuVsWrap.put(osWrap.osm_productId, osWrap);
           }
          
   
         }
        
      
       system.debug('mapProdSkuVsWrap' + mapProdSkuVsWrap);
       system.debug('productId' + productId);
       system.debug('accid'+accid);
   
       //Get Subscription record: sharad commengting this method because this method return only active subscription but we have to retrive renew subsc also if cancle call is for renew order item.
       //subsToUpdate = OSM_SW_Transaction_Util.fetchActiveSubscriptionForAccount(accid, productId);
       // add query
       //Mp-711 removed co-term check from the query
       List<ccrz__E_Subscription__c> subscTempList = new List<ccrz__E_Subscription__c>([select id,name, ccrz__Account__c, Recurring_Invoice_Start_Date__c,OSM_Free_Trial__c,ccrz__SubscriptionStatus__c,ccrz__Quantity__c,ccrz__SubscriptionProduct__c,ccrz__InstallmentNextDate__c,ccrz__SubscriptionProduct__r.Name,ccrz__SubscriptionProduct__r.ccrz__SKU__c,OSM_Subscription_End_Date__c,ccrz__SubscriptionStartDate__c,ccrz__InstallmentLastDate__c 
                                                                                    from ccrz__E_Subscription__c 
                                                                                    where (ccrz__SubscriptionStatus__c='Active'  OR ccrz__SubscriptionStatus__c='Renew')
                                                                                       and ccrz__Storefront__c='SoftwareStore' 
                                                                                       and ccrz__SubscriptionProduct__c in:productId and ccrz__Account__c=:accid]);
                                                                                       
       // Code for product without coterm
       System.debug('orderItemIdforWithOutCotermProduct: '+orderItemIdforWithOutCotermProduct);
       {
           if(orderItemIdforWithOutCotermProduct != null && orderItemIdforWithOutCotermProduct.size() > 0)
           {
               List<OSM_Order_Subscription__c> lstOrderSubsc = new List<OSM_Order_Subscription__c>();
               lstOrderSubsc = [Select Id,OSM_CCSubscription__c from OSM_Order_Subscription__c where CC_Order_Item__c IN: orderItemIdforWithOutCotermProduct];
               System.debug('lstOrderSubsc: '+lstOrderSubsc);
               if(lstOrderSubsc != null && lstOrderSubsc.size() > 0)
               {
                   Set<Id> subscIdSet = new Set<Id>();
                   for(OSM_Order_Subscription__c objOS : lstOrderSubsc)
                       subscIdSet.add(objOS.OSM_CCSubscription__c);
                   
                   List<ccrz__E_Subscription__c> subscTempList2 = new List<ccrz__E_Subscription__c>([select id,name, ccrz__Account__c, Recurring_Invoice_Start_Date__c,OSM_Free_Trial__c,ccrz__SubscriptionStatus__c,ccrz__Quantity__c,ccrz__SubscriptionProduct__c,ccrz__InstallmentNextDate__c,ccrz__SubscriptionProduct__r.Name,ccrz__SubscriptionProduct__r.ccrz__SKU__c,OSM_Subscription_End_Date__c,ccrz__SubscriptionStartDate__c,ccrz__InstallmentLastDate__c 
                                                                                    from ccrz__E_Subscription__c 
                                                                                    where ccrz__SubscriptionStatus__c='Active'
                                                                                       and ccrz__Storefront__c='SoftwareStore' 
                                                                                       and Id IN: subscIdSet]);
                   if(subscTempList2 != null && subscTempList2.size() > 0)
                   {
                       for(ccrz__E_Subscription__c objSub : subscTempList2)
                           subscTempList.add(objSub);
                   }
               }
           }
           
       }
       // code end for co term
       
       for(ccrz__E_Subscription__c objSubsc : subscTempList)
       {
           if(productIdToRenew.containsKey(objSubsc.ccrz__SubscriptionProduct__c))
           {
               if(productIdToRenew.get(objSubsc.ccrz__SubscriptionProduct__c) && objSubsc.ccrz__SubscriptionStatus__c == 'Renew')
               {
                   subsToUpdate.add(objSubsc);
               }
               
               if(objSubsc.ccrz__SubscriptionStatus__c == 'Active')
               {
                   subsToUpdate.add(objSubsc);
               }
           }
       }
       
       /*
       List<ccrz__E_OrderItem__c> listFWOrderItems = new List<ccrz__E_OrderItem__c>();
       List<ccrz__E_OrderItem__c> vertexOrderItems = new List<ccrz__E_OrderItem__c>();
       if(subscTempList.size()==0 || subscTempList == Null ){
       ccrz__E_TransactionPayment__c transPayment = new ccrz__E_TransactionPayment__c();
       transPayment= [Select id, name, Transaction_Status__c, ccrz__AccountType__c, Bolt_Credit_Memo_Call_Status__c, Bolt_JE_Reversal_Call_Status__c from ccrz__E_TransactionPayment__c where ccrz__CCOrder__c=:orderId]; 
       
           for (ccrz__E_OrderItem__c oItem: cancelledOrderRec) {
               if(oItem.ccrz__Product__r.Group_Name__c=='FluidWatch'){
                   oItem.ccrz__OrderItemStatus__c = label.OSM_OrderItem_Cancellation_Status;
                   
               }
               if(oItem.ccrz__ParentOrderItem__c == Null){
                   oItem.ccrz__OrderItemStatus__c = label.OSM_OrderItem_Cancellation_Status;
                   oItem.VertexOrderItemCall__c = True;
                   
               }listFWOrderItems.add(oItem);
           }
           
           Update listFWOrderItems;
           transPayment.Transaction_Status__c ='OrderItem Cancel Success';
           Update transPayment;
           log = new OSM_Integration_Log__c();
           OSM_SW_LoggingContext.integrationLog = log;
           log.Service_Name__c = label.OSM_Order_Cancellation;
           log.Response__c = label.OSM_Order_Cancellation_Message;
           log.Source__c = 'FluidWatch';
           log.Target__c = 'FluidWatch'; 
           log.Status__c = label.OSM_Subs_Cancellation_Success;
           log.Logged_In_User__c = userinfo.getUserId();
           system.debug('log'+log);
           OSM_SW_LoggingContext.saveIntegrationLog(log); 
           for(ccrz__E_OrderItem__c vertexItem:listFWOrderItems){
               if(vertexItem.VertexOrderItemCall__c){
               vertexItem.VertexOrderItemCall__c = False;
               vertexOrderItems.add(vertexItem); 
               }
           } 
           //Update vertexOrderItems;
       }*/
       
       system.debug('subsToUpdate' + subsToUpdate);
   
       if (subsToUpdate != null && subsToUpdate.size() > 0) {
        for (ccrz__E_Subscription__c subsId: subsToUpdate) {
         subsIdList.add(subsId.id);
        }
       }
       system.debug('subsIdList' + subsIdList);
   
       //fetchAllOrderInfoForSubscriptionsWithOneTime
       if (mapProdSkuVsWrap.keyset() != null && mapProdSkuVsWrap.size() > 0) {
        mapAccVsSubsVsOrderSubs = OSM_SW_Transaction_Util.fetchAllOrderInfoForSubscriptionsWithOneTime(subsIdList);
       }
       system.debug('mapAccVsSubsVsOrderSubs' + mapAccVsSubsVsOrderSubs);
   
       if (mapAccVsSubsVsOrderSubs.keyset() != null && mapAccVsSubsVsOrderSubs.size() > 0) {
        //Adding subscription and order susbcription to wrapper map
        
         for (ccrz__E_Subscription__c ccsubs: subsToUpdate) {
          if (ccsubs.ccrz__Account__c == accId) {
           if ((mapProdSkuVsWrap.containsKey(ccsubs.ccrz__SubscriptionProduct__r.ccrz__SKU__c))) {
            system.debug('Inside get subscription loop');
            //Get subscription
            mapProdSkuVsWrap.get(ccsubs.ccrz__SubscriptionProduct__r.ccrz__SKU__c).osm_subscriptionID = ccsubs.name;
   
            //Get Order Subscription
            if (mapAccVsSubsVsOrderSubs.containsKey(accId)) {
             if (mapAccVsSubsVsOrderSubs.get(accId).containsKey(ccsubs.id) && ((mapAccVsSubsVsOrderSubs.get(accId)).get(ccsubs.id) != null)) {
   
              List < OSM_Order_Subscription__c > osmSublist = (mapAccVsSubsVsOrderSubs.get(accId)).get(ccsubs.id);
   
              for (OSM_Order_Subscription__c osmSub: osmSublist) {
               if ((osmSub.OSM_CCSubscription__c == ccsubs.id) && (osmSub.OSM_CCOrder__c == orderId)) {
                mapProdSkuVsWrap.get(ccsubs.ccrz__SubscriptionProduct__r.ccrz__SKU__c).osm_orderSubs = osmSub;
               }
              }
             }
            }
           }
          }
         }
        
       }
       system.debug('mapProdSkuVsWrap' + mapProdSkuVsWrap);
       
       Set<String> setKeyToRemove = new Set<String>();
       for(String strKey : mapProdSkuVsWrap.keySet())
       {
           if(mapProdSkuVsWrap.get(strKey).osm_orderSubs == null )
           {
               setKeyToRemove.add(strKey);
           }
       }
       if(setKeyToRemove != null && setKeyToRemove.size() > 0)
       {
           for(String key : setKeyToRemove)
           {
               if(mapProdSkuVsWrap.containsKey(key))
               {
                   mapProdSkuVsWrap.remove(key);
               }
           }
       }
       
   
       if (mapProdSkuVsWrap != null && mapProdSkuVsWrap.size() > 0) {
        for (OSM_SW_OrderSubscriptionWrapper oswrap: mapProdSkuVsWrap.values()) {
         if ((oswrap.osm_orderId == null) || (oswrap.osm_subscriptionID == null) || (oswrap.osm_quantity == null) || (oswrap.osm_productId == null)) {
           MissingParametersFlag = true; //Set flag to true
           setOfFlags.add(MissingParametersFlag); //Add flag to set
         }else if(oswrap.osm_orderSubs == null){
           MissingOrderSubsJunc = true;       
           MissingParametersFlag = true; //Set flag to true
           setOfFlags.add(MissingParametersFlag); //Add flag to set      
         }
        }
        system.debug('setOfFlags' + setOfFlags);
   
       if(setOfFlags.contains(true)) {
           throw new OSM_SW_OrderProcesssingException(label.OSM_Order_Cancellation_Throw_Exception);
       }else {
           //Call the method to update
           SetOfIds = OSM_WS_CancelPartialSubscription.updateSubscriptionAndJunction(mapProdSkuVsWrap.values(), action, True);
           }
       }
      }
     }catch(OSM_SW_OrderProcesssingException e){
           system.debug('Exception-' + e.getMessage());
           Database.rollback(sp); //set rollback
           //Create Integration log
           log = new OSM_Integration_Log__c();
           OSM_SW_LoggingContext.integrationLog = log;
           log.Service_Name__c = action;
           log.Source__c = label.OSM_Partial_Subscription_Cancellation_Source;
           log.Target__c = label.OSM_Partial_Subscription_Cancellation_Target;
           log.Response__c = e.getMessage() + '. Error at line number ' + e.getLineNumber();
           if(MissingOrderSubsJunc = false){
               log.Error_Description__c = label.OSM_Order_Cancellation_Required_Error_Description;
           }else if(MissingOrderSubsJunc = true){
               log.Error_Description__c = label.OSM_OrderSubsMissing;
           }
           log.Status__c = label.OSM_Subs_Cancellation_Failure;
           log.Logged_In_User__c = userinfo.getUserId();
           OSM_SW_LoggingContext.saveIntegrationLog(log); //Save the integration log record                       
           system.debug('log' + log);
           //throw new OSM_SW_OrderProcesssingException('Message' + e.getMessage());
       } 
       catch(Exception e){
          system.debug('Exception-' + e.getMessage());
          Database.rollback(sp); //set rollback
          //Create Integration log
          log = new OSM_Integration_Log__c();
          OSM_SW_LoggingContext.integrationLog = log;
          log.Service_Name__c = action;
          log.Source__c = label.OSM_Partial_Subscription_Cancellation_Source;
          log.Target__c = label.OSM_Partial_Subscription_Cancellation_Target;
          log.Response__c = e.getMessage() + '. Error at line number ' + e.getLineNumber();
          log.Error_Description__c = e.getStacktraceString();
          log.Status__c = label.OSM_Subs_Cancellation_Failure;
          log.Logged_In_User__c = userinfo.getUserId();
          OSM_SW_LoggingContext.saveIntegrationLog(log); //Save the integration log record                       
          system.debug('log' + log);
       }
    }
   
    
   //Revoke Subscription method                
    public static OSM_ReturnWrapper handleRevokeSubscriptionProcess(List<Id> invoiceIdLst) {
       
       System.debug('====invoiceIdLst===='+invoiceIdLst);
       OSM_ReturnWrapper returnWrapper = new OSM_ReturnWrapper();
        returnWrapper.invoiceIdVsStatusMap = new Map<Id,String>();
       Map<Id,OSM_SW_OrderWrapper> invoiceIdVsWrapperMap = new Map<Id,OSM_SW_OrderWrapper>();
       List<OSM_Integration_Log__c> osmLogLst = new List<OSM_Integration_Log__c>();
       Map<Id,Set<Id>>  successfulInvoiceIdVsOrderSetMap = new Map<Id,Set<Id>>();
       Set<Id> orderSet = new Set<Id>();
       Map<Id,List<ccrz__E_InvoiceItem__c>> invIdVsItemMap=null;
       Map<Id,ccrz__E_TransactionPayment__c> paymentIdVsPaymentMap=null;
       
       Map<String,String> invoiceIdVsAccountIdMap = new Map<String,String>();
       List<String> accIdLst = new List<String>();
       Map<Id,ccrz__E_Invoice__c> invoiceMap = null;
       List<Id> successInvoiceIdToUpdateLst = new List<Id>();
       String state;
       Map<String,ccrz__E_Subscription__c> subsIdVsSubsMap = new Map<String,ccrz__E_Subscription__c>();
       try{
           
           
           invoiceMap = new Map<Id,ccrz__E_Invoice__c>([select id,Payment_Method__c from ccrz__E_Invoice__c where id in:invoiceIdLst]);
           
       List<OSM_Orders_In_Invoice__c> parentJunctionList = [select id,CC_Order__c,CC_Order__r.ccrz__OrderStatus__c, CC_Invoice__c,CC_Invoice__r.ccrz__Status__c from OSM_Orders_In_Invoice__c where CC_Invoice__c in :invoiceIdLst];
       
       OSM_SW_OrderWrapper parentInvoiceWrapper = new OSM_SW_OrderWrapper();
       
       for(OSM_Orders_In_Invoice__c parentWrapper : parentJunctionList)
       {
       
           if(!invoiceIdVsWrapperMap.containsKey(parentWrapper.CC_Invoice__c))
           {
               parentInvoiceWrapper = new OSM_SW_OrderWrapper();
               invoiceIdVsWrapperMap.put(parentWrapper.CC_Invoice__c,parentInvoiceWrapper);
               parentInvoiceWrapper.orderLstForInvoiceToBeUpdated = new List<ccrz__E_Order__c>();
           }
           
           parentInvoiceWrapper = invoiceIdVsWrapperMap.get(parentWrapper.CC_Invoice__c);
           
           //ccrz__E_Invoice__c invoiceToUpdate = new ccrz__E_Invoice__c(id=parentWrapper.CC_Invoice__c,ccrz__Status__c='Cancelled');
           ccrz__E_Invoice__c invoiceToUpdate = new ccrz__E_Invoice__c(id=parentWrapper.CC_Invoice__c, Sub_Status__c = 'Revoked');
           parentInvoiceWrapper.invoiceId = parentWrapper.CC_Invoice__c;
           parentInvoiceWrapper.invoiceToUpdate= invoiceToUpdate;
           //parentInvoiceWrapper.invoiceStatus = 'Revoked';
           ccrz__E_Order__c order = new ccrz__E_Order__c(Id=parentWrapper.CC_Order__c,ccrz__OrderStatus__c='Revoked');
           //parentInvoiceWrapper.orderStatus = 'Revoked';
           //parentInvoiceWrapper.orderId = parentWrapper.CC_Order__c;
           
           parentInvoiceWrapper.orderLstForInvoiceToBeUpdated.add(order);
           //parentInvoiceWrapper.order=order;
           
           invoiceIdVsWrapperMap.put(parentWrapper.CC_Invoice__c,parentInvoiceWrapper);
       }
       
       
       
        invIdVsItemMap = new Map<Id,List<ccrz__E_InvoiceItem__c>>();
       List<ccrz__E_InvoiceItem__c> invoiceItemLst = [select id,ccrz__Invoice__c,ccrz__Invoice__r.ccrz__BillTo__c from ccrz__E_InvoiceItem__c where ccrz__Invoice__c in :invoiceIdLst and ccrz__Type__c='Item'];
       //logic to groupd the line item as per invoice
       
       
       paymentIdVsPaymentMap = new Map<Id,ccrz__E_TransactionPayment__c>([select id,Transaction_Status__c,ccrz__InvoiceAppliedTo__c,Bolt_Recurring_AR_Call_Status__c,Bolt_Recurring_JE_Call_Status__c from ccrz__E_TransactionPayment__c where ccrz__InvoiceAppliedTo__c in :invoiceIdLst]);
           
       
       
       
       Map<Id,Id> lineIdVdInvMap = new Map<Id,Id>();
       for(ccrz__E_InvoiceItem__c item : invoiceItemLst)
       {
           invoiceIdVsAccountIdMap.put(item.ccrz__Invoice__c,item.ccrz__Invoice__r.ccrz__BillTo__c);
           lineIdVdInvMap.put(item.id,item.ccrz__Invoice__c);
          //if(!invIdVsItemMap.containsKey(item.ccrz__Invoice__c))
          //{
            //  invIdVsItemMap.put(item.ccrz__Invoice__c new List<ccrz__E_InvoiceItem__c>() );
          //}
          
          OSM_SW_OrderWrapper invoiceWrapper = invoiceIdVsWrapperMap.get(item.ccrz__Invoice__c);
          
           if(invoiceWrapper != null){
               if(invoiceWrapper.lineIdVsWrapperToCancel==null)
               {
                   invoiceWrapper.lineIdVsWrapperToCancel = new Map<String,OSM_SW_OrderWrapper.OSM_SW_OrderLineWrapper>();             
               }
           }   
               OSM_SW_OrderWrapper.OSM_SW_OrderLineWrapper lineWrapper = new OSM_SW_OrderWrapper.OSM_SW_OrderLineWrapper();
               
               if(lineWrapper != null){
                   lineWrapper.invoiceLineId = item.id;
                   
                   if(invoiceWrapper != null){
                       invoiceWrapper.lineIdVsWrapperToCancel.put(item.id,lineWrapper);    
                   }
                   //invIdVsItemMap.get(item.ccrz__Invoice__c).add(item); 
               }   
             
       }
       
           
           System.debug('===lineIdVdInvMap=='+lineIdVdInvMap);
           
           
           List<OSM_InvoiceLine_And_OrderLine__c>  childJunctionLst =  [select id,CC_Invoice_Item__c,CC_Order_Item__c,CC_Order_Item__r.ccrz__OrderItemStatus__c,Quantity__c  from OSM_InvoiceLine_And_OrderLine__c where CC_Invoice_Item__c in :lineIdVdInvMap.keySet()];
       
           List<Id> orderItemIdLst = new List<Id>();
           
           for(OSM_InvoiceLine_And_OrderLine__c childJunc : childJunctionLst)
           {
             //update the order line status
               System.debug('==OSM_InvoiceLine_And_OrderLine__c==='+childJunc);
               String orderItemId = childJunc.CC_Order_Item__c;
               String invItemId = childJunc.CC_Invoice_Item__c;
               //logic to fill the orderitem id for corresponding invoiceItemid
               for(String key  : invoiceIdVsWrapperMap.keySet())
               {
               OSM_SW_OrderWrapper invoiceWrapper = invoiceIdVsWrapperMap.get(key);
                   if(invoiceWrapper.lineIdVsWrapperToCancel!=null){
                       for(String lineId : invoiceWrapper.lineIdVsWrapperToCancel.keySet())
                       {
                           OSM_SW_OrderWrapper.OSM_SW_OrderLineWrapper lineWrapper = invoiceWrapper.lineIdVsWrapperToCancel.get(lineid);
                           if(lineWrapper.invoiceLineId == invItemId)
                           {
                               lineWrapper.orderLineId  = orderItemId;
                           }
                       }
                   }
                   
               }
               
             orderItemIdLst.add(childJunc.CC_Order_Item__c);
           }
           
           System.debug('======invoiceWrapper before OrderSubs Junction===='+invoiceIdVsWrapperMap);
           System.debug('===orderItemIdLst=='+orderItemIdLst);
           List<OSM_Order_Subscription__c >  orderSubsJunctionLst =  [ select id,CCQuantity__c,OSM_CCSubscription__c,OSM_CCSubscription__r.ccrz__Quantity__c,OSM_CCSubscription__r.ccrz__SubscriptionStatus__c,CC_Order_Item__r.ccrz__OrderItemStatus__c,CC_Order_Item__c  from OSM_Order_Subscription__c where CC_Order_Item__c in :orderItemIdLst];
           
           
           for(OSM_Order_Subscription__c orderSubsJunction:orderSubsJunctionLst)
           {
               
               String orderItemId1 = orderSubsJunction.CC_Order_Item__c;
               System.debug('===orderItemId1=='+orderItemId1);
               
               if(!subsIdVsSubsMap.containsKey(orderSubsJunction.OSM_CCSubscription__c)){
                   ccrz__E_Subscription__c subscription  = new ccrz__E_Subscription__c(id=orderSubsJunction.OSM_CCSubscription__c,ccrz__Quantity__c=orderSubsJunction.OSM_CCSubscription__r.ccrz__Quantity__c);
                   subsIdVsSubsMap.put(subscription.id,subscription);
                   
               }
                   
                   
               for(String invoiceId  : invoiceIdVsWrapperMap.keySet())
               {
                   OSM_SW_OrderWrapper invoiceWrapper = invoiceIdVsWrapperMap.get(invoiceId);
                   
                       //logic to fetch the line id from wrapper and compare it with junction line id and update Subscription
                       if(invoiceWrapper.lineIdVsWrapperToCancel!=null){
                           for(String key : invoiceWrapper.lineIdVsWrapperToCancel.keySet())
                           {
                               OSM_SW_OrderWrapper.OSM_SW_OrderLineWrapper lineWrapper = invoiceWrapper.lineIdVsWrapperToCancel.get(key);
                               System.debug('===lineWrapper=='+lineWrapper);
                               
                               if(lineWrapper.orderLineId == orderItemId1)
                               {
                                   //lineWrapper.orderLineId  = orderItemId
                                   //ccrz__E_Subscription__c subscription  = new ccrz__E_Subscription__c(id=orderSubsJunction.OSM_CCSubscription__c,ccrz__Quantity__c=orderSubsJunction.OSM_CCSubscription__r.ccrz__Quantity__c);
                                   
                                   ccrz__E_Subscription__c subscription  = subsIdVsSubsMap.get(orderSubsJunction.OSM_CCSubscription__c);
                                   //Cancel the Invoiced quantity from Subscription
                                   subscription.ccrz__Quantity__c = subscription.ccrz__Quantity__c - orderSubsJunction.CCQuantity__c;
                                   if (subscription.ccrz__Quantity__c == 0) {
                                        subscription.ccrz__SubscriptionStatus__c = 'InActive';
                                        
                                   }
                                   lineWrapper.subscription = subscription;
                                   //Order Item
                                   //ccrz__E_OrderItem__c orderItem  = new ccrz__E_OrderItem__c(id=orderItemId1,ccrz__Quantity__c=0,ccrz__OrderItemStatus__c='Revoked');
                                   ccrz__E_OrderItem__c orderItem  = new ccrz__E_OrderItem__c(id=orderItemId1,ccrz__Quantity__c=0,ccrz__OrderItemStatus__c='Cancelled');
                                   lineWrapper.orderItem = orderItem;
                                   
                                   //setting this 0 as this line has been revoked
                                   orderSubsJunction.CCQuantity__c=0;
                                   lineWrapper.orderSubsJunction = orderSubsJunction;
                               }
                           }
                       }
                   
               }
               
           
           }
           
           
           System.debug('======invoiceWrapper after OrderSubs Junction===='+invoiceIdVsWrapperMap);
           //Start DML logic for each invoice
           List < ccrz__E_OrderItem__c > orderItemLst =null;
           //List<ccrz__E_InvoiceItem__c> invoiceItemLst = null;
           List<OSM_Order_Subscription__c> orderSubsJunctionLstToUpdate = null;
           List<ccrz__E_Subscription__c> subscriptionLst = null;
           System.debug('===invoiceIdVsWrapperMap==='+invoiceIdVsWrapperMap);
           
           
           for( String invId : invoiceIdVsWrapperMap.keySet())
           {
               OSM_SW_OrderWrapper invoiceWrapper = invoiceIdVsWrapperMap.get(invId); 
               System.debug('===invoiceWrapper==='+invoiceWrapper);
               Savepoint sp = Database.setSavepoint();
               try{
                       
                       invoiceWrapper.invoiceToUpdate.Invoice_Revoked_By__c = UserInfo.getuserid();
                       update invoiceWrapper.invoiceToUpdate;
                       successInvoiceIdToUpdateLst.add(invoiceWrapper.invoiceToUpdate.id);
                       update invoiceWrapper.orderLstForInvoiceToBeUpdated;
                       
                       orderItemLst =new LIst<ccrz__E_OrderItem__c>();
                       //invoiceItemLst = new List<ccrz__E_InvoiceItem__c>();
                       orderSubsJunctionLstToUpdate = new List<OSM_Order_Subscription__c>();
                       subscriptionLst = new List<ccrz__E_Subscription__c>();
                       
                       //logic to fetch the line id from wrapper and compare it with junction line id and update Subscription
                       if(invoiceWrapper.lineIdVsWrapperToCancel!=null){
                           for(String key : invoiceWrapper.lineIdVsWrapperToCancel.keySet())
                           {
                               OSM_SW_OrderWrapper.OSM_SW_OrderLineWrapper lineWrapper = invoiceWrapper.lineIdVsWrapperToCancel.get(key);
                               orderItemLst.add(lineWrapper.orderItem);
                               //invoiceItemLst.add(lineWrapper.invoiceItem);
                               orderSubsJunctionLstToUpdate.add(lineWrapper.orderSubsJunction);
                               subscriptionLst.add(lineWrapper.subscription);
                           
                           }
                       }
                       
                       update orderItemLst;
                       //update invoiceItemLst;
                       update orderSubsJunctionLstToUpdate;
                       update subscriptionLst;
                       
                       for(ccrz__E_Order__c order : invoiceWrapper.orderLstForInvoiceToBeUpdated){
                           orderSet.add(order.id);
                       
                       }
                       
                       successfulInvoiceIdVsOrderSetMap.put(invId,orderSet);
                       if(invoiceIdVsAccountIdMap.containsKey(invId) && invoiceIdVsAccountIdMap.get(invId)!=null){
                           accIdLst.add(invoiceIdVsAccountIdMap.get(invId));
                       }
                       returnWrapper.invoiceIdVsStatusMap.put(invId,'Success');
                       
                       //tbd..remove this
                       OSM_Integration_Log__c log = new OSM_Integration_Log__c();
                       log.Invoice__c =invoiceWrapper.invoiceToUpdate.id;
                       log.Service_Name__c='Revoke Invoice';
                       log.Status__c = 'Success';
                       osmLogLst.add(log);
                       
               }catch(Exception e){
                   Database.rollback(sp);
                   String errorMsg = e.getLineNumber() + e.getStackTraceString() + '-----'+e.getMessage();
                   System.debug('=====Got the exception while Revoking the Invoice====='+errorMsg);
                   OSM_Integration_Log__c log = new OSM_Integration_Log__c();
                   log.Invoice__c =invoiceWrapper.invoiceToUpdate.id;
                   log.Error_Description__c = errorMsg;
                   //tbd label
                   log.Service_Name__c='Revoke Invoice';
                   log.Status__c = 'Error';
                   osmLogLst.add(log);
                   
               }
           }       
               
               //finally update the successful Account
               OSM_SW_Transaction_Util.updateAccountFieldsForAllOperations(accIdLst,Label.OSM_Revoke_Invoice);
               System.debug('====After updating the updateAccountFieldsForAllOperations==');
               
           }catch(Exception e){
                   
                   String errorMsg = e.getLineNumber() + e.getStackTraceString() + '-----'+e.getMessage();
                   System.debug('=====Got the exception while Revoking the Invoice====='+errorMsg);
                   OSM_Integration_Log__c log = new OSM_Integration_Log__c();
                   log.Error_Description__c = errorMsg;
                   //tbd label
                   log.Service_Name__c='Revoke Invoice';
                   log.Status__c = 'Fail';
                   osmLogLst.add(log);
                   
               }
               finally{
                   
                       System.debug('====FINALLY==');
                       Map<Id,Id> paymentIdVsInvoiceIdMap = new Map<Id,Id>();
                       Map<Id,Id> invIdVsPaymentIdMap = new Map<Id,Id>();
                       List<Id> successInvoiceIdForBoltCallsLst = new List<Id>();
                       List<Id> successPaymentIdForBoltCallsLst = new List<Id>();
                       System.debug('====before paymentIdVsPaymentMap==='+paymentIdVsPaymentMap);
                       System.debug('====invoiceMap==='+invoiceMap);
                       System.debug('====successInvoiceIdToUpdateLst==='+successInvoiceIdToUpdateLst);
                       System.debug('====paymentIdVsPaymentMap==='+paymentIdVsPaymentMap);
                       
                       for(Id paymentId : paymentIdVsPaymentMap.keySet())
                       {
                             ccrz__E_TransactionPayment__c payment = paymentIdVsPaymentMap.get(paymentId);
                           if(invoiceMap.containsKey(payment.ccrz__InvoiceAppliedTo__c))
                           {
                                ccrz__E_Invoice__c inv =  invoiceMap.get(payment.ccrz__InvoiceAppliedTo__c);
                                if(inv.Payment_Method__c!='' && inv.Payment_Method__c=='po')
                                {
                                   
                                     if(successInvoiceIdToUpdateLst.contains(payment.ccrz__InvoiceAppliedTo__c))
                                     {
                                           payment.Transaction_Status__c='Revoke Invoice Success';
                                           //payment.Bolt_Revoke_AR_Call_Status__c ='Pending';
                                           //payment.Bolt_Revoke_JE_Call_Status__c='Pending';
                                          
                                           //Commented by Vaibhav on 1-Oct as Subbu mentioned that on Revocation no Bolt reversal calls required.
                                           //payment.Bolt_Credit_Memo_Call_Status__c ='Pending';
                                           //payment.Bolt_JE_Reversal_Call_Status__c ='Pending';
                                           
                                           //payment.paymentToUpdateLst.add(payment);
                                     } 
                                     else
                                     {
                                           payment.Transaction_Status__c='Revoke Invoice Failure';
                                           //paymentToUpdateLst.add(payment);
                                     } 
                                }
                           }
                            
                       }
                       
                       System.debug('====after paymentIdVsPaymentMap==='+paymentIdVsPaymentMap);
                           
                           try{
                               
                               Database.SaveResult[] srList = Database.update(paymentIdVsPaymentMap.values(),false);
                               // Iterate through each returned result
                               for (Database.SaveResult sr : srList) {
                                   if (sr.isSuccess()) {
                                       // Operation was successful, so get the ID of the record that was processed
                                       System.debug('Successfully inserted account. Account ID: ' + sr.getId());
                                       successPaymentIdForBoltCallsLst.add(sr.getId());
                                   }
                                   else {
                                       String errorMsg = '';
                                       // Operation failed, so get all errors                
                                       for(Database.Error err : sr.getErrors()) {
                                           System.debug('The following error has occurred.'); 
                                           errorMsg = errorMsg + err.getStatusCode() + ': ' + err.getMessage() +': '+ err.getFields();
                                           errorMsg = errorMsg + '|---------|';
                                           System.debug(err.getStatusCode() + ': ' + err.getMessage());
                                           
                                       }
                                       OSM_Integration_Log__c log = new OSM_Integration_Log__c();
                                       log.Error_Description__c = errorMsg;
                                       log.Transaction_Payment__c =sr.getId();
                                       log.Service_Name__c='Revoke Invoice';
                                       log.Status__c = 'Fail';
                                       osmLogLst.add(log);
                                   }
                               }
                               
                               successInvoiceIdToUpdateLst = new List<Id>();
                               for(Id paymentId : successPaymentIdForBoltCallsLst)
                               {
                                       ccrz__E_TransactionPayment__c payment = paymentIdVsPaymentMap.get(paymentId);
                                       //paymentIdVsInvoiceIdMap.put(paymentId,payment.ccrz__InvoiceAppliedTo__c);
                                       invIdVsPaymentIdMap.put(payment.ccrz__InvoiceAppliedTo__c,paymentId);
                                       successInvoiceIdToUpdateLst.add(payment.ccrz__InvoiceAppliedTo__c);
                                    
                               }
                               
                               System.debug('===successInvoiceIdToUpdateLst==='+successInvoiceIdToUpdateLst);
                               System.debug('===invIdVsPaymentIdMap==='+invIdVsPaymentIdMap);
                               
                               //invoicelist and map of tPVSINvoiceId
                               state = 'Order Cancel';
                               //OSM_BOLT_SW_BusinessLayerUtility.getARInvoiceServices(successInvoiceIdToUpdateLst,invIdVsPaymentIdMap);
                               //OSM_BOLT_SW_BusinessLayerUtility.getJournalEntryServices(successInvoiceIdToUpdateLst,invIdVsPaymentIdMap);
                              
                               //Commented by Vaibhav on 1-Oct as Subbu mentioned that on Revocation no Bolt reversal calls required.
                               //OSM_BOLT_SW_BusinessLayerUtility.getARInvoiceServices(successInvoiceIdToUpdateLst,invIdVsPaymentIdMap,state);
                               //OSM_BOLT_SW_BusinessLayerUtility.getJournalEntryServices(successInvoiceIdToUpdateLst,invIdVsPaymentIdMap,state);
                               
                           }catch(Exception e){
                                   OSM_Integration_Log__c log = new OSM_Integration_Log__c();
                                   String errorMsg = e.getLineNumber() + e.getStackTraceString() + '-----'+e.getMessage();
                                   log.Error_Description__c = errorMsg;
                                   //tbd label
                                   log.Service_Name__c='Revoke Invoice';
                                   log.Status__c = 'Fail';
                                   osmLogLst.add(log);
                           }
                       
                       
                       Set<Id> orderIdInBatches = new Set<Id>();
                       
                       if(osmLogLst!=null && osmLogLst.size()>0)
                       {
                       
                          insert osmLogLst;
                       }
                       
                       
                          //initiate the DA Cancel call
                          Set<Id> orderSetForDACancelAPI = new Set<Id>();
                          for(String invId : successfulInvoiceIdVsOrderSetMap.keySet())
                          {
                             Set<Id> orderLst = successfulInvoiceIdVsOrderSetMap.get(invId);
                             orderSetForDACancelAPI.addAll(orderLst);
                          }
                          
                          //call the DA services
                          
                          for(Id orderId : orderSetForDACancelAPI)
                          {
                               orderIdInBatches.add(orderId);
                               //tbd label
                               if(orderIdInBatches.size()==5)
                               {
                                   orderIdInBatches = new Set<Id>();
                                   OSM_SW_OrderTriggerHandlerUtility.getOrderCancel(orderIdInBatches);
                               }
                                   
                               
                               
                          }
                          
                          //for any remaining orders..call now
                          if(orderIdInBatches.size()<5)
                          {  
                               OSM_SW_OrderTriggerHandlerUtility.getOrderCancel(orderIdInBatches);
                          }
                          
                       }
               return returnWrapper;
               
               } //end of method
           
   
       
    
   }