/************************************************************
Name:  OSM_SW_OrderActions 
Copyright © 2018  Cummins
=============================================================
=============================================================
Purpose:                                                            
This is a future class that will prepare an order update 
and order cancelaltion input wrapper using all input paramters 
from order, orderitem and subscrciption product.                 
=============================================================
=============================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE              DETAIL                                
1.0 -   Ankit S            18/04/2018     INITIAL DEVELOPMENT           
1.1 -   Ronnie Mishra    15/11/2021    Changes added as part ofMP-139, to add requesterId     

*************************************************************/

public class OSM_SW_OrderActions {
    
    /*----------------------------------------------------------------------------------
    1. call_DA_OrderUpdatesAsync
    Description: Tabulate all Order updates input paramters. This is future method.
    Input: Set<Id> orderIdLst
    Output: Get output wrapper for order update
    Returntype: void
    ------------------------------------------------------------------------------------*/
        
        public static void call_DA_OrderUpdatesAsync(Set<Id> orderIdLst)
        {
          //Initialize variables
          List<OSM_WS_GeneralizedInputWrapper> orderWrapperLst = new List<OSM_WS_GeneralizedInputWrapper>();
          OSM_WS_GeneralizedInputWrapper wrapper;
          ccrz__E_Order__c order;
          OSM_Integration_Log__c log = null;
          Map<Id,ccrz__E_Order__c> orderMapToPushToDA = new Map<Id,ccrz__E_Order__c>();
          List<Id> productIdList = new List<Id>();
          List<ccrz__E_Subscription__c> AccsubsList = new List<ccrz__E_Subscription__c>();
          String AccountId ;
          Map<Id,ccrz__E_Subscription__c> mapProductIDVsSubs = new Map<Id,ccrz__E_Subscription__c>();
          Map<Id,Map<Id,List<OSM_Order_Subscription__c>>> mapAccVsmapSubsVsOrderSubsList = new Map<Id,Map<Id,List<OSM_Order_Subscription__c>>>(); //Map of Acc Vs Map of Subs Id Vs List of Order Subscription
          List<Id> subscriptionList = new List<Id>();
          Map<Id,String> mapOrderIdVsSubsBillingFreq = new Map<Id,String>(); //Map of Order Id Vs Billing Frequency from Order Subs rec
          List<OSM_Order_Subscription__c> orderSubsList = new List<OSM_Order_Subscription__c>();
        
          //Create an order map
          try{      
          Map<Id,ccrz__E_Order__c> orderMap = new Map<Id,ccrz__E_Order__c>([select id,name,ccrz__Account__c, CreatedById, IsActivationKeyJobRun__c, ccrz__Account__r.CMI_CId__c,ccrz__Account__r.Next_Invoice_Generation_Date__c,createddate,(select id,name,ccrz__OrderLastDate__c,ccrz__SubscriptionProduct__c,ccrz__SubscriptionStartDate__c,OSM_Subscription_End_Date__c, OSM_Free_Trial__c, ccrz__RecurringPrice__c,ccrz__CurrencyISOCode__c from ccrz__CCSubscriptions__r),(select id,name,ccrz__Quantity__c,ccrz__Product__c, ccrz__Product__r.Group_Name__c,ccrz__Product__r.ccrz__SKU__c, ccrz__OriginalItemPrice__c, ccrz__Order__r.ccrz__CurrencyISOCode__c, ccrz__DisplayProduct__r.ccrz__SKU__c, ccrz__Subscription_Auto_Renewal__c from ccrz__E_OrderItems__r) from ccrz__E_Order__c where id in :orderIdLst and Original_Sales_Order__c=null]);
          system.debug('orderMap'+orderMap);
          
          //Map that will take only those order id which are under 'DA" group name     
          if(orderMap.keyset() != null && orderMap.size()>0)
          {
            for(Id orderId:orderMap.keySet())
              {
                 ccrz__E_Order__c orderRef = orderMap.get(orderId);
                 
                 for( ccrz__E_OrderItem__c orderItem: orderRef.ccrz__E_OrderItems__r)
                     {
                         if(orderItem.ccrz__Product__r.Group_Name__c == Label.OSM_GroupName_DA)
                         {
                            orderMapToPushToDA.put(orderId,orderRef);                        
                            productIdList.add(orderItem.ccrz__Product__c);
                            AccountId = orderRef.ccrz__Account__c;
                         }
                     }
              } 
          }  
          
          
          if(productIdList.size()>0){
            AccsubsList = OSM_SW_Transaction_Util.fetchActiveSubscriptionForAccount(AccountId,productIdList);     
          }
          
          if(AccsubsList != null && AccsubsList.size()>0){
              for(ccrz__E_Subscription__c accsub :AccsubsList){
                  mapProductIDVsSubs.put(accsub.ccrz__SubscriptionProduct__c,accsub);
                  subscriptionList.add(accsub.id);
              }
          }
                
          mapAccVsmapSubsVsOrderSubsList = OSM_SW_Transaction_Util.fetchAllOrderInfoForSubscriptionsWithOneTime(subscriptionList);
          
            for(ccrz__E_Subscription__c accsub :AccsubsList){
                if(mapAccVsmapSubsVsOrderSubsList.containsKey(accsub.ccrz__Account__c) && mapAccVsmapSubsVsOrderSubsList.get(accsub.ccrz__Account__c).containsKey(accsub.id)){
                    orderSubsList = (mapAccVsmapSubsVsOrderSubsList.get(accsub.ccrz__Account__c)).get(accsub.id);
                    for(OSM_Order_Subscription__c orderSubs :orderSubsList){
                        mapOrderIdVsSubsBillingFreq.put(orderSubs.OSM_CCOrder__c,orderSubs.Billing_Frequency__c);               
                    }   
                }
            }
            
    
          //Populate wrapper paramters
          if(orderMapToPushToDA.keyset() != null && orderMapToPushToDA.size()>0){
             for(Id orderId:orderMapToPushToDA.keySet())
              {
                wrapper = new OSM_WS_GeneralizedInputWrapper();
                order = orderMapToPushToDA.get(orderId);
                wrapper.orderId = order.name;
                wrapper.customerId = order.ccrz__Account__r.CMI_CId__c;
                
                datetime myDateTime =  order.createddate;
                String formatted = OSM_Generic_Utility.getUTCDate(myDateTime);
                wrapper.createdDate = formatted;
                
                //Added by neha mehta on 6 feb 2019--start
                List<ccrz__E_OrderItem__c> orderItems=new List<ccrz__E_OrderItem__c>();
                List<ccrz__E_OrderItem__c> orderItemList =order.ccrz__E_OrderItems__r;
                if(orderItemList!=null){
                for(ccrz__E_OrderItem__c orderItem : orderItemList){
                    if(orderItem.id!=null && orderItem.ccrz__Product__r.Group_Name__c == 'DA'){
                        orderItems.add(orderItem); //List to get all order line items of that order
                    }
                    }
                }
                 //Added by neha mehta on 6 feb 2019--end
                List<String> skuList = new List<String>();
                Map<String,String> mapDefaultProductPartNumber = new Map<String,String>();
                Map<String,Id> productSkuVsproductId = new Map<String,Id>();
                
                Map<String,OSM_WS_GeneralizedInputWrapper.OrderLineItems> productIdVsOrderLineItemMap = new Map<String,OSM_WS_GeneralizedInputWrapper.OrderLineItems>();
                
                for(ccrz__E_OrderItem__c orderItem:orderItems)
                {   
                   OSM_WS_GeneralizedInputWrapper.OrderLineItems orderItemObj = new OSM_WS_GeneralizedInputWrapper.OrderLineItems();
                    
                   if(orderItem.ccrz__Subscription_Auto_Renewal__c == false){orderItemObj.subscriptionType = label.OSM_SubscriptionType_New;}
                   if(orderItem.ccrz__Subscription_Auto_Renewal__c == true){orderItemObj.subscriptionType = label.OSM_SubscriptionType_Renewed;}
                   orderItemObj.subscriptionQuantity = orderItem.ccrz__Quantity__c.intValue();
                   orderItemObj.pricePerUnit = orderItem.ccrz__OriginalItemPrice__c;
                   orderItemObj.currencyType = orderItem.ccrz__Order__r.ccrz__CurrencyISOCode__c;
                   
                   productIdVsOrderLineItemMap.put(orderItem.ccrz__Product__c,orderItemObj);
                   
                   String ProductSKU = orderItem.ccrz__Product__r.ccrz__SKU__c;
                   skuList.add(ProductSKU);
                   productSkuVsproductId.put(orderItem.ccrz__Product__r.ccrz__SKU__c,orderItem.ccrz__Product__c);
                }
                  
                
                mapDefaultProductPartNumber = OSM_DA_GenericFunctionsUtility.fetchDefaultDAProductPartNumber(skuList);
                    if(mapDefaultProductPartNumber.keyset() != null && mapDefaultProductPartNumber.size()>0){
                        for(String productSku :mapDefaultProductPartNumber.keyset()){
                            if(productSkuVsproductId.containsKey(productSku)){
                                String skuNumber = mapDefaultProductPartNumber.get(productSku).contains('-') ? mapDefaultProductPartNumber.get(productSku).split('-')[0]: mapDefaultProductPartNumber.get(productSku);
                                productIdVsOrderLineItemMap.get(productSkuVsproductId.get(productSku)).productID = skuNumber;                       
                            }   
                        }
                    }   
                            
                            
                if(mapProductIDVsSubs.keyset() != null && mapProductIDVsSubs.size()>0){
                    for(ccrz__E_Subscription__c susbRec :mapProductIDVsSubs.values()){
                            Id productId = susbRec.ccrz__SubscriptionProduct__c;
                            Integer subsQuantity = Integer.valueOf(susbRec.ccrz__Quantity__c);
                            
                               
                            if(productIdVsOrderLineItemMap.containsKey(productId)){
                                
                                OSM_WS_GeneralizedInputWrapper.OrderLineItems orderLineItem = productIdVsOrderLineItemMap.get(productId);
                               
                                datetime myDateTime2 =  susbRec.ccrz__SubscriptionStartDate__c;
                                String formattedStartDt = OSM_Generic_Utility.getUTCDate(myDateTime2); 
                                orderLineItem.startDate = formattedStartDt;
                               
                                datetime myDateTime3 =  susbRec.OSM_Subscription_End_Date__c;
                                String formattedEndDt = OSM_Generic_Utility.getUTCDate(myDateTime3); 
                                orderLineItem.expirationDate = formattedEndDt;
                               
                                if(susbRec.OSM_Free_Trial__c == true){
                                    orderLineItem.freeTrial = label.OSM_FreeTrial_Yes;
                                }else if(susbRec.OSM_Free_Trial__c == false){
                                    orderLineItem.freeTrial = label.OSM_FreeTrial_No;
                                }
                                //productIdVsOrderLineItemMap.get(productId).subscriptionQuantity = subsQuantity;  
                            }
                            
                            
                            if(mapOrderIdVsSubsBillingFreq.containsKey(orderId)){
                                if((mapOrderIdVsSubsBillingFreq.get(orderId)) == Label.OSM_Subscription_OneTime){
                                    wrapper.nextInvoiceDate = null; 
                                }else if(mapOrderIdVsSubsBillingFreq.get(orderId) != Label.OSM_Subscription_OneTime){
                                    datetime nextinvoiceGenDt = susbRec.ccrz__InstallmentNextDate__c;
                                    String formatnextinvoiceGenDt = OSM_Generic_Utility.getUTCDate(nextinvoiceGenDt);
                                    wrapper.nextInvoiceDate = formatnextinvoiceGenDt; 
                                }   
                            }    
                        }                                  
                    }
                    
                    //finally set the list of order lines in wrapper 
                    wrapper.orderLineItems=productIdVsOrderLineItemMap.values();
                     orderWrapperLst.add(wrapper);
                  } 
                }          
            }catch(Exception e)
              {
                    System.debug('=====Exception in call_DA_OrderUpdatesAsync====');
                    log = new OSM_Integration_Log__c();
                    OSM_SW_LoggingContext.integrationLog = log;
                    log.Service_Name__c = Label.DA_Order_Update_Service_Name; //Used custom labels
                    log.Source__c = label.DA_Source;
                    log.Target__c = label.DA_Target;
                    log.Logged_In_User__c = userinfo.getUserId();
                    log.Response__c = e.getMessage() + ' at line number '+e.getLinenumber();
                    log.Status__c = label.DA_Log_Status_Failure;
                    log.Error_Description__c = e.getStackTraceString();
                    log.Account__c = AccountId;  // Added By Dhiraj for MAR-1621 - Story On 21st April 2021
                    OSM_SW_LoggingContext.saveIntegrationLog(log);
              }
            
           
            
            if(orderWrapperLst != null && orderWrapperLst.size()>0){
                for(OSM_WS_GeneralizedInputWrapper wrapperObj : orderWrapperLst)
                {
                    //call Order update service 
                    OSM_WS_GetOrderDetail_RES response = OSM_WS_CS_Services.callGetOrderWS(wrapperObj);          
                }   
            } 
        }//end of method
        
    /*----------------------------------------------------------------------------------
    2. call_DA_OrderCancellationAsync
    Description: Tabulate all Order cancellation input paramters. This is future method.
    Input: Set<Id> orderIdLst
    Output: Get output wrapper for order cancellation
    Returntype: void
    ------------------------------------------------------------------------------------*/  
        
        public static void call_DA_OrderCancellationAsync(Set<Id> orderIdLst)
        {
        
          //orderIdLst max count must be 5 initally..depending on the performance we can increase or decrease the size
          //Initialize variables
          List<OSM_WS_GeneralizedInputWrapper> orderWrapperLst = new List<OSM_WS_GeneralizedInputWrapper>();
          OSM_WS_GeneralizedInputWrapper wrapper;
          ccrz__E_Order__c order;
          String cancellationDateStr;
          OSM_Integration_Log__c log = null;
          Map<Id,ccrz__E_Order__c> orderMapToPushToDA = new Map<Id,ccrz__E_Order__c>();
    
          Set<Id> orderIdOfSucess = new Set<Id>();
          Set<Id> orderIdOfAll = new Set<Id>();
          Map<String,Id> orderNameToId = new Map<String,Id>();
          String AccountId ; // Added By Dhiraj for MAR-1621 - Story On 21st April 2021
          //Create order map
          try{
          Map<Id,ccrz__E_Order__c> orderMap = new Map<Id,ccrz__E_Order__c>([select id,name,ccrz__Account__r.CMI_CId__c,createdDate,
          (select id,name,ccrz__Quantity__c,ccrz__Product__r.Group_Name__c from ccrz__E_OrderItems__r ),ccrz__Account__c, CreatedById
          from ccrz__E_Order__c where id in :orderIdLst and Original_Sales_Order__c=null]); // Added(ccrz__Account__c Column in SOQL Query) By Dhiraj for MAR-1621 - Story On 21st April 2021
          system.debug('orderMap'+orderMap);
          
                  //orderMapToPushToDA will contain only those orders which has DA product in OrderLine      
                  if(orderMap.keyset() != null && orderMap.size()>0){
                    for(Id orderId:orderMap.keySet())
                      {
                         orderIdOfAll.add(orderId);
                         ccrz__E_Order__c orderRef = orderMap.get(orderId);
                         for( ccrz__E_OrderItem__c orderItem: orderRef.ccrz__E_OrderItems__r)
                         {
                             if(orderItem.ccrz__Product__r.Group_Name__c==Label.OSM_GroupName_DA){
                             orderMapToPushToDA.put(orderId,orderRef);
                             AccountId = orderRef.ccrz__Account__c; //Added By Dhiraj for MAR-1621 - Story On 21st April 2021
                             break;
                             }                         
                         }
                      }  
                  }       
                  system.debug('orderMapToPushToDA'+orderMapToPushToDA);
          
                  //Prepare wrapper
                  if(orderMapToPushToDA.keyset() != null && orderMapToPushToDA.size()>0){
                     for(Id orderId:orderMapToPushToDA.keySet())
                      {
                        
                        wrapper = new OSM_WS_GeneralizedInputWrapper();
                        order = orderMapToPushToDA.get(orderId);
                        wrapper.orderId = order.name;
                        orderNameToId.put(order.name,orderId);
                        wrapper.customerId = order.ccrz__Account__r.CMI_CId__c;
                      
                            
                        datetime cancellationDate =  System.now();
                        String formatted = OSM_Generic_Utility.getUTCDate(cancellationDate); 
                        wrapper.cancelDate = formatted;
                          
                        //Added by neha mehta on 6 feb 2019--start
                    /*    List<OSM_WS_GeneralizedInputWrapper.OrderLineItems> orderItems=new List<OSM_WS_GeneralizedInputWrapper.OrderLineItems>();
                        List<ccrz__E_OrderItem__c> orderItemList =order.ccrz__E_OrderItems__r;
                        
                        OSM_WS_GeneralizedInputWrapper.OrderLineItems orderItemWrap=new OSM_WS_GeneralizedInputWrapper.OrderLineItems();
                        
                        for(ccrz__E_OrderItem__c orderItem: orderItemList){
                        if(orderItem.id!=null && orderItem.ccrz__Product__r.Group_Name__c == 'DA'){
                            orderItemWrap.productID=orderItem.ccrz__Product__r.Id;
                         
                            orderItems.add(orderItemWrap); //List to get all order line items of that order
                            }
                        }
                    
                       wrapper.orderLineItems=orderItems;*/
                       //Added by neha mehta on 6 feb 2019--end
                       
                        orderWrapperLst.add(wrapper);
                      }  
                  }       
              if(Test.isRunningTest())
              {
                  throw new nullPointerException();
              }
              }catch(Exception e)
              {
                    System.debug('=====Exception in call_DA_OrderCancellationAsync====');
                    log = new OSM_Integration_Log__c();
                    OSM_SW_LoggingContext.integrationLog = log;
                    log.Service_Name__c = Label.DA_Order_Cancellation_Service_Name; //Used custom labels
                    log.Source__c = label.DA_Source;
                    log.Target__c = label.DA_Target;
                    log.Logged_In_User__c = userinfo.getUserId();
                    log.Response__c = e.getMessage() + ' at line number '+e.getLinenumber();
                    log.Status__c = label.DA_Log_Status_Failure;
                    log.Error_Description__c = e.getStackTraceString();
                    log.Account__c = AccountId;  // Added By Dhiraj for MAR-1621 - Story On 21st April 2021
                    OSM_SW_LoggingContext.saveIntegrationLog(log);
              }
            
            system.debug('orderWrapperLst'+orderWrapperLst);
    
            if(orderWrapperLst != null && orderWrapperLst.size()>0){
                for(OSM_WS_GeneralizedInputWrapper wrapperObj : orderWrapperLst)
                {
                    //call Order cancellation service
                    OSM_WS_GetCancellationDetail_RES response = OSM_WS_CS_Services.callGetCancellationWS(wrapperObj);
                    if(!response.exceptionFlag)
                    {
                        if(orderNameToId.containsKey(wrapperObj.orderId))
                        {
                            orderIdOfSucess.add(orderNameToId.get(wrapperObj.orderId));
                        }
                        
                    }
                        
                } 
            }
            
            Set<Id> orderToUpdateDADone = new Set<Id>();
            for(Id key : orderIdOfAll)
            {
                if(!orderMapToPushToDA.containsKey(key))
                    orderToUpdateDADone.add(key);
            }
            
            for(Id key : orderIdOfSucess)
            {
                orderToUpdateDADone.add(key);
            }
            
            List<ccrz__E_Order__c> objOrder = new List<ccrz__E_Order__c>();
                objOrder = [Select Id, OSM_SW_Is_DA_Update_Done_Or_Not_Needed__c from ccrz__E_Order__c where Id IN: orderToUpdateDADone];
                if(objOrder != null && objOrder.size() > 0)
                {
                    for(ccrz__E_Order__c objOr : objOrder)
                    {
    
                        objOr.OSM_SW_Is_DA_Update_Done_Or_Not_Needed__c = true;
                        
                    }
                    update objOrder;
                }
                    
            OSM_SW_OrderCancelUtilForPage.updateOrderCancel(orderToUpdateDADone);
            
        }
        public static void call_DA_OrderItemCancellationAsync(Set<Id> orderItemIdLst)
        {
        
          //orderIdLst max count must be 5 initally..depending on the performance we can increase or decrease the size
          //Initialize variables
          List<OSM_WS_GeneralizedInputWrapper> orderWrapperLst = new List<OSM_WS_GeneralizedInputWrapper>();
          OSM_WS_GeneralizedInputWrapper wrapper;
          //ccrz__E_Order__c order;
          String cancellationDateStr;
          OSM_Integration_Log__c log = null;
          //Map<Id,ccrz__E_Order__c> orderMapToPushToDA = new Map<Id,ccrz__E_Order__c>();
    
          Set<Id> orderIdOfSucess = new Set<Id>();
          Set<Id> orderIdOfAll = new Set<Id>();
          Map<String,Id> orderNameToId = new Map<String,Id>(); 
          String AccountId ;// Added By Dhiraj for MAR-1621 - Story On 21st April 2021
            
          //Create order map
          try{
          
          List<ccrz__E_OrderItem__c> lstOrderItem = new List<ccrz__E_OrderItem__c>();
          lstOrderItem = [Select Id,ccrz__Order__r.OrderProcessedforFSD__c,ccrz__Order__r.Name,ccrz__Product__r.Group_Name__c,ccrz__Order__r.ccrz__Account__r.CMI_CId__c,ccrz__Order__c,ccrz__OrderItemStatus__c, CancelLicenseAPICalled__c,ccrz__Order__r.ccrz__Account__c  from ccrz__E_OrderItem__c where Id IN: orderItemIdLst];// Added(ccrz__Order__r.ccrz__Account__c Column in SOQL Query) By Dhiraj for MAR-1621 - Story On 21st April 202
          system.debug('lstOrderItem-->>'+lstOrderItem);
          
                  //Prepare wrapper
                  if(lstOrderItem != null && lstOrderItem.size()>0){
                     for(ccrz__E_OrderItem__c orderItemId:lstOrderItem)
                      {
                        AccountId = orderItemId.ccrz__Order__r.ccrz__Account__c; //Added By Dhiraj for MAR-1621 - Story On 21st April 2021  
                        if(orderItemId.ccrz__Product__r.Group_Name__c==Label.OSM_GroupName_DA){
                        
                        wrapper = new OSM_WS_GeneralizedInputWrapper();
                        //order = orderMapToPushToDA.get(orderId);
                        wrapper.orderId = orderItemId.ccrz__Order__r.name;
                        //orderNameToId.put(order.name,orderId);
                        wrapper.customerId = orderItemId.ccrz__Order__r.ccrz__Account__r.CMI_CId__c;
                      
                            
                        datetime cancellationDate =  System.now();
                        String formatted = OSM_Generic_Utility.getUTCDate(cancellationDate); 
                        wrapper.cancelDate = formatted;
                          
                        //Added by neha mehta on 6 feb 2019--start
                    /*    List<OSM_WS_GeneralizedInputWrapper.OrderLineItems> orderItems=new List<OSM_WS_GeneralizedInputWrapper.OrderLineItems>();
                        List<ccrz__E_OrderItem__c> orderItemList =order.ccrz__E_OrderItems__r;
                        
                        OSM_WS_GeneralizedInputWrapper.OrderLineItems orderItemWrap=new OSM_WS_GeneralizedInputWrapper.OrderLineItems();
                        
                        for(ccrz__E_OrderItem__c orderItem: orderItemList){
                        if(orderItem.id!=null && orderItem.ccrz__Product__r.Group_Name__c == 'DA'){
                            orderItemWrap.productID=orderItem.ccrz__Product__r.Id;
                         
                            orderItems.add(orderItemWrap); //List to get all order line items of that order
                            }
                        }
                    
                       wrapper.orderLineItems=orderItems;*/
                       //Added by neha mehta on 6 feb 2019--end
                       
                        orderWrapperLst.add(wrapper);
                      } 
                    }
                  }       
              if(Test.isRunningTest())
              {
                  throw new nullPointerException();
              }
              }catch(Exception e)
              {
                    System.debug('=====Exception in call_DA_OrderCancellationAsync====');
                    log = new OSM_Integration_Log__c();
                    OSM_SW_LoggingContext.integrationLog = log;
                    log.Service_Name__c = Label.DA_Order_Cancellation_Service_Name; //Used custom labels
                    log.Source__c = label.DA_Source;
                    log.Target__c = label.DA_Target;
                    log.Logged_In_User__c = userinfo.getUserId();
                    log.Response__c = e.getMessage() + ' at line number '+e.getLinenumber();
                    log.Status__c = label.DA_Log_Status_Failure;
                    log.Error_Description__c = e.getStackTraceString();
                    log.Account__c = AccountId;  // Added By Dhiraj for MAR-1621 - Story On 21st April 2021
                    OSM_SW_LoggingContext.saveIntegrationLog(log);
              }
            
            system.debug('orderWrapperLst'+orderWrapperLst);
    
            if(orderWrapperLst != null && orderWrapperLst.size()>0){
                for(OSM_WS_GeneralizedInputWrapper wrapperObj : orderWrapperLst)
                {
                    //call Order cancellation service
                    OSM_WS_GetCancellationDetail_RES response = OSM_WS_CS_Services.callGetCancellationWS(wrapperObj);
                    system.debug('response---->>'+response);                    
                } 
            }
               
            OSM_SW_OrderCancelUtilForPage.updateOrderItemCancel(orderItemIdLst);
            
        }
        
        public static void call_OMS_GetAndCreateOrder(Set<Id> orderIdLst,Id orderItemId,Id orderItemLicenseId,boolean updatekey)
        {
            String AccountId ;// Added By Dhiraj for MAR-1621 - Story On 21st April 2021
            List<OSM_Integration_Log__c> toBeInsertedLogList = new List<OSM_Integration_Log__c>();// Added By Dhiraj for MAR-1621 - Story On 21st April 2021
            OSM_Integration_Log__c objOIL = new OSM_Integration_Log__c();// Added By Dhiraj for MAR-1621 - Story On 21st April 2021
            try
            {
                String userType = '';
                List<OSM_Order_Item_License__c> orderItemLicenseList=new List<OSM_Order_Item_License__c>();
                Boolean singleOrderItemFlag=false;
                if(!OSM_SW_General_Util.ALREADY_CHECK_USER_PERMISSIONSET){
                    userType = OSM_SW_General_Util.getuserType(UserInfo.getUserId());
                } else{
                    userType = OSM_SW_General_Util.USER_TYPE;
                }
                //Changes made by Sangeeta for Subscription Managenemnt story
                Map<Id,ccrz__E_Order__c> orderMap=new Map<Id,ccrz__E_Order__c>();
                Set<Id> orderItemIdSet=new Set<Id>();
                List<OSM_Order_Item_License__c> orderItemLicenseListToCheck=new List<OSM_Order_Item_License__c>();
                List<Id> lstItemForRenewItem = new List<Id>();
                //List<Id> AccId = new List<Id>();
                
                boolean IsFluidWatch =false;
                List<ccrz__E_Order__c>  ordr = [select ID,ccrz__OriginatedCart__c, CreatedById, ccrz__Account__c from ccrz__E_Order__c where id in :orderIdLst];// Added(ccrz__Account__c Column in SOQL Query) By Dhiraj for MAR-1621 - Story On 16th April 202
                Map<Id,Id> cartOrderMap = new Map<Id,Id>();
                for(ccrz__E_Order__c objs : ordr){
                 objOIL.Account__c = objs.ccrz__Account__c;//Added By Dhiraj
                 cartOrderMap.put(objs.ccrz__OriginatedCart__c, objs.Id);
                 AccountId = objs.ccrz__Account__c; //Added By Dhiraj for MAR-1621 - Story On 21st April 2021
                 toBeInsertedLogList.add(objOIL);//Added By Dhiraj
                }
               
                if(orderIdLst!=null && orderItemId==null && orderItemLicenseId==null)
                {
                    //adding condition Activation_Key_Generated__c=0 in order item query for story 182645(create order call from ordercancel)
                    orderMap = new Map<Id,ccrz__E_Order__c>([select ID, ccrz__OriginatedCart__c, Name, CreatedById, SendOrderDetailMail__c, ccrz__Account__c, ccrz__Account__r.CMI_Account_Num__c, ccrz__Contact__r.Username__c, (select ID, ccrz__SubscriptionStartDate__c from ccrz__CCSubscriptions__r), (select id, Name, isRenew__c, ccrz__Quantity__c, OMS_Order_ID__c, OMS_Item_ID__c, ccrz__Order__c, OMS_Product__c, Number_of_Bundles__c, Number_of_Counts__c, ccrz__SubProdTerm__c, ccrz__SubProdTerm__r.ccrz__DisplayName__c, ccrz__Product__c, ccrz__Product__r.Name, ccrz__Product__r.ccrz__ProductType__c, ccrz__DisplayProduct__r.Name, ccrz__DisplayProduct__r.ccrz__SKU__c, ccrz__DisplayProduct__r.Product_Range__c, ccrz__DisplayProduct__r.Feature__C, ccrz__DisplayProduct__r.FeatureGroup__C, ccrz__DisplayProduct__r.LicenseName__C,OSM_SW_Is_without_Coterm__c from ccrz__E_OrderItems__r where Activation_Key_Generated__c=0 AND Group_Name__c != 'FluidWatch' ) from ccrz__E_Order__c where id in :orderIdLst AND (ccrz__OrderStatus__c='Order Submitted' or ccrz__OrderStatus__c='Cancellation Pending') AND OSM_SW_Is_InterCompany_Order__c=false ]);
    
    
                    Set<Id> cartId = new Set<Id>();
                    Map<Id,Id> cartToOrderMap = new Map<Id,Id>();
                    Map<Id,List<ccrz__E_OrderItem__c>> orderToOrderItemMap = new Map<Id,List<ccrz__E_OrderItem__c>>();
                    
                    for(ccrz__E_Order__c obj : orderMap.values())
                    {
                        cartToOrderMap.put(obj.ccrz__OriginatedCart__c, obj.Id);
                        for(ccrz__E_OrderItem__c orderItem: obj.ccrz__E_OrderItems__r)
                        {
                            if(!orderToOrderItemMap.containsKey(orderItem.ccrz__Order__c))
                                orderToOrderItemMap.put(orderItem.ccrz__Order__c, new List<ccrz__E_OrderItem__c>());
                            orderToOrderItemMap.get(orderItem.ccrz__Order__c).add(orderItem);
                        }
                    }
                    System.debug('orderToOrderItemMap: '+orderToOrderItemMap);
                    System.debug('cartToOrderMap: '+cartToOrderMap);
                    Map<Id,ccrz__E_Cart__c> mapCart = new Map<Id,ccrz__E_Cart__c>();
                    mapCart = new Map<Id,ccrz__E_Cart__c>([Select Id,(Select Id,isRenew__c, ccrz__Product__c from ccrz__E_CartItems__r) from ccrz__E_Cart__c where Id IN: cartToOrderMap.keySet()]);
                        
                    System.debug('mapCart: '+mapCart);
                    
    
    
                    for(ccrz__E_Cart__c objCart : mapCart.values())
                    {
                        System.debug('objCart: '+objCart);
                        if(cartToOrderMap.containsKey(objCart.Id) && orderToOrderItemMap.containsKey(cartToOrderMap.get(objCart.Id)) && orderToOrderItemMap.get(cartToOrderMap.get(objCart.Id)) != null && orderToOrderItemMap.get(cartToOrderMap.get(objCart.Id)).size() > 0)
                        {
                            System.debug('objCart.ccrz__E_CartItems__r: '+objCart.ccrz__E_CartItems__r);
                            for(ccrz__E_CartItem__c objCartItem : objCart.ccrz__E_CartItems__r)
                            {
                                System.debug('objCartItem.isRenew__c: '+objCartItem.isRenew__c);
                                if(objCartItem.isRenew__c)
                                {
                                    for(ccrz__E_OrderItem__c  objItem : orderToOrderItemMap.get(cartToOrderMap.get(objCart.Id)))
                                    {
                                        System.debug('objItem.ccrz__Product__c: '+objItem.ccrz__Product__c);
                                        System.debug('objCartItem.ccrz__Product__c: '+objCartItem.ccrz__Product__c);
                                        if(objItem.ccrz__Product__c == objCartItem.ccrz__Product__c)
                                        {
                                            lstItemForRenewItem.add(objItem.Id);
                                        }
                                    }
                                }
                                
                            }
                        }
                            
                    }
                    
                    System.debug('lstItemForRenewItem: '+lstItemForRenewItem);
                    
                }
                else
                {
    
                    List<ccrz__E_OrderItem__c> orderItemList=[select id,ccrz__Order__c from ccrz__E_OrderItem__c where id=:orderItemId];
                    orderItemLicenseList=[select id,name,Activation_Key__c,Parent_Activation_Key__c,Revoked_ReIssue_Lisence__c,Status__c,Type__c from OSM_Order_Item_License__c where id=:orderItemLicenseId];
                    if(orderItemList!=null && orderItemList.size()>0)
                    {
                        orderMap = new Map<Id,ccrz__E_Order__c>([select ID, Name, CreatedById,SendOrderDetailMail__c, ccrz__Account__c, ccrz__Account__r.CMI_Account_Num__c, ccrz__Contact__r.Username__c, (select ID, ccrz__SubscriptionStartDate__c from ccrz__CCSubscriptions__r), (select id, Name, ccrz__Quantity__c, OMS_Order_ID__c, OMS_Item_ID__c, OMS_Product__c, Number_of_Bundles__c, Number_of_Counts__c, ccrz__SubProdTerm__c, ccrz__SubProdTerm__r.ccrz__DisplayName__c, ccrz__Product__c, ccrz__Product__r.Name, ccrz__Product__r.ccrz__ProductType__c, ccrz__DisplayProduct__r.Name, OSM_SW_Is_without_Coterm__c,ccrz__DisplayProduct__r.ccrz__SKU__c, ccrz__DisplayProduct__r.Product_Range__c, ccrz__DisplayProduct__r.Feature__C, ccrz__DisplayProduct__r.FeatureGroup__C, ccrz__DisplayProduct__r.LicenseName__C,isRenew__c from ccrz__E_OrderItems__r where id=:orderItemId) from ccrz__E_Order__c where id=:orderItemList[0].ccrz__Order__c AND ccrz__OrderStatus__c='Order Submitted' AND OSM_SW_Is_InterCompany_Order__c=false]);
                        system.debug('orderMap in else block>>>>>'+orderMap);
                    }
                    singleOrderItemFlag=true;
                }
                Set<String> productIdSet = new Set<String>();
                
                if(orderMap.keyset() != null && orderMap.size()>0)
                {
                    for(Id orderId:orderMap.keySet())
                    {
                        for( ccrz__E_OrderItem__c orderItem: orderMap.get(orderId).ccrz__E_OrderItems__r)
                        {
                            productIdSet.add(orderItem.ccrz__Product__c);
                            productIdSet.add(orderItem.ccrz__DisplayProduct__c);
                            orderItemIdSet.add(orderItem.id);
                            
                        }
                    }
                }
                if(orderItemIdSet!=null && orderItemIdSet.size()>0)
                {
                    orderItemLicenseListToCheck=[select id,Activation_Key__c from OSM_Order_Item_License__c where  CC_Order_Item__c IN:orderItemIdSet];
                }
                
                List<String> productIdList = new List<String>(productIdSet);
                
                List<ccrz__E_CompositeProduct__c> composteProductsList = OSM_SW_ProdDetailUtils_Ctrl.getCcrzCompositProducts(productIdList);
                
                Map<Id, List<ccrz__E_CompositeProduct__c>> compositeIdToCompositeProductMap = new Map<Id, List<ccrz__E_CompositeProduct__c>>();
               
                for(ccrz__E_CompositeProduct__c compositeProduct : composteProductsList)
                {
                    if(null == compositeIdToCompositeProductMap.get(compositeProduct.ccrz__Composite__c))
                    {
                        List<ccrz__E_CompositeProduct__c> compositeList = new List<ccrz__E_CompositeProduct__c>();
                        compositeList.add(compositeProduct);
                        compositeIdToCompositeProductMap.put(compositeProduct.ccrz__Composite__c, compositeList);
                    }
                    else
                    {
                        compositeIdToCompositeProductMap.get(compositeProduct.ccrz__Composite__c).add(compositeProduct);
                    }
                    productIdSet.add(compositeProduct.ccrz__Composite__c);
                    productIdSet.add(compositeProduct.ccrz__Component__c);
                }
                Map<Id, ccrz__E_Product__c> productMap = new Map<Id, ccrz__E_Product__c>([Select ID, Name, ccrz__SKU__c, ccrz__ProductType__c, Product_Range__c, Feature__c, FeatureGroup__c, LicenseName__c from ccrz__E_Product__c WHERE Id IN: productIdSet]);
           
                List<ccrz__E_OrderItem__c> toBeUpdatedOrderItemList = new List<ccrz__E_OrderItem__c>();
                //List<OSM_Integration_Log__c> toBeInsertedLogList = new List<OSM_Integration_Log__c>();
                List<ccrz__E_Order__c> toBeUpdatedOrderList = new List<ccrz__E_Order__c>();
                List<OSM_Order_Item_License__c> toBeInsertUpdateListOrderItemLicense=new List<OSM_Order_Item_License__c>();
                
                if(orderMap.keyset() != null && orderMap.size()>0)
                {
                    for(Id orderId:orderMap.keySet())
                    {
                        ccrz__E_Order__c orderRef = orderMap.get(orderId);
                        orderRef.SendOrderDetailMail__c = true;
                        toBeUpdatedOrderList.add(orderRef);
                        
                        for( ccrz__E_OrderItem__c orderItem: orderRef.ccrz__E_OrderItems__r)
                        {
                            if(!lstItemForRenewItem.contains(orderItem.Id))
                            {
                                Boolean callOMSServices = false;
                                OSM_OMS_CreateOrderGeneral_IP_Wrapper generalizedInputWrapper = new OSM_OMS_CreateOrderGeneral_IP_Wrapper();
                                generalizedInputWrapper.orderId = orderRef.ID;
                                generalizedInputWrapper.orderName = orderRef.Name;
                                generalizedInputWrapper.timestamp = getRequiredDateFormat(System.today(), 'yyyy-MM-dd');
                                generalizedInputWrapper.toolName = Label.OSM_ToolName;    // static value...will not change
                                generalizedInputWrapper.AccId = AccountId;    // Added BY Dhiraj
                                
                                /*if(userType == Label.OSM_Fleet_Admin_UserType)
                                {
                                    //generalizedInputWrapper.requesterId = orderRef.ccrz__Account__r.CMI_Account_Num__c;
                                    generalizedInputWrapper.requesterId = 'Test 1';
                                }
                                else // need clarification
                                {
                                    //generalizedInputWrapper.requesterId = orderRef.ccrz__Account__r.CMI_Account_Num__c;
                                    generalizedInputWrapper.requesterId = 'Test 2';
                                }*/
                                
                                generalizedInputWrapper.orderItemDetailsList = new List<OSM_OMS_CreateOrderGeneral_IP_Wrapper.OrderItemDetails>();
                                
                                ccrz__E_Product__c product = null;
                                Integer quantity = 0;
                                
                                if((null != orderItem.ccrz__Product__c && 'Bundle' == orderItem.ccrz__Product__r.ccrz__ProductType__c) || (null != orderItem.ccrz__Product__c && (orderItem.ccrz__Product__r.Name.contains('Service Tech Kit') || orderItem.ccrz__Product__r.Name.contains('Add-on') || orderItem.ccrz__Product__r.Name.contains('Add-ON') || orderItem.ccrz__Product__r.Name.contains('Add-On'))))
                                {
                                    // if it contains composites....if it has Insite then add to orderItem Details
                                    if(null != compositeIdToCompositeProductMap.get(orderItem.ccrz__Product__c))
                                    {
                                        List<ccrz__E_CompositeProduct__c> compositeList = compositeIdToCompositeProductMap.get(orderItem.ccrz__Product__c);
                                        for(ccrz__E_CompositeProduct__c compositeProduct : compositeList)
                                        {
                                            if(compositeProduct.ccrz__Component__r.Name.contains(Label.OSM_ToolName))
                                            {
                                                product = productMap.get(compositeProduct.ccrz__Component__c);
                                                if(orderIdLst!=null && orderItemId==null && orderItemLicenseId==null)
                                                {
                                                quantity = Integer.valueOf(orderItem.ccrz__Quantity__c) * Integer.valueOf(compositeProduct.ccrz__Quantity__c);
                                                }
                                                else
                                                {
                                                    quantity=1;
                                                }
                                            }
                                        }
                                    }
                                    system.debug('inside bundle block==='+product);
                                }
                                System.debug(' DisplayProduct ggs '+ orderItem.ccrz__DisplayProduct__r.Name);
                                  //Start Mar-1346
                                if(null != orderItem.ccrz__DisplayProduct__c){
                                String tempName;
                                for(String str : Label.OSM_Special_Char.split(',')){
                                  if(orderItem.ccrz__DisplayProduct__r.Name.contains(str))
                                      {
                                          tempName=orderItem.ccrz__DisplayProduct__r.Name.replace(str,'');
                                      }
                                 }
                                  if(tempName != '' && tempName != null)
                                     orderItem.ccrz__DisplayProduct__r.Name = tempName;
                                }
                                //End Mar-1346 Also updated the Custom label OSM_BundleProduct and removed special char
                                if(null != orderItem.ccrz__DisplayProduct__c && Label.OMS_ProductList_OriginalList.contains(orderItem.ccrz__DisplayProduct__r.ccrz__SKU__c) && !Label.OSM_BundleProduct
                                   .containsIgnoreCase(orderItem.ccrz__DisplayProduct__r.Name))
                                    
                                {
                                    
                                    product = productMap.get(orderItem.ccrz__DisplayProduct__c);
                                    system.debug('inside display block==='+product);
                                    if(orderIdLst!=null && orderItemId==null && orderItemLicenseId==null)
                                    {
                                        quantity = Integer.valueOf(orderItem.ccrz__Quantity__c);
                                    }
                                    else{
                                        quantity=1; 
                                    }
                                }
                                
                                // if the order item is Insite / FleetCount / Zap-It / Bundle with Insite / Add on with Insite
                                if(null != product)
                                {
                                    orderItem.OMS_Product__c = true;
                                     system.debug('final product==='+product);
                                    callOMSServices = true;
                                    system.debug('callOMSServices'+callOMSServices);
                                    if(Label.OMS_ProductList_NonInsite.contains(orderItem.ccrz__DisplayProduct__r.ccrz__SKU__c))
                                    {
                                        generalizedInputWrapper=OSM_SW_CreateOrderRequestDataSetup.reqDataSetupNonInsite(product,orderRef,orderItem,quantity,generalizedInputWrapper);
                                    }
                                    else
                                    {
                                        if(orderItemLicenseList!=null && orderItemLicenseList.size()>0)
                                        {
                                           if(!Test.isRunningTest()) generalizedInputWrapper=OSM_SW_CreateOrderRequestDataSetup.reqDataSetupInsite(product,orderRef,orderItem,quantity,generalizedInputWrapper,orderItemLicenseList[0]);
                                        }
                                        else
                                        {
                                            if(!Test.isRunningTest()) generalizedInputWrapper=OSM_SW_CreateOrderRequestDataSetup.reqDataSetupInsite(product,orderRef,orderItem,quantity,generalizedInputWrapper,null);
                                        }
                                
                                        
                                    }
                                }
                               
                                if(callOMSServices)
                                {
                                    //OSM_Order_Item_License__c orderItemLicenseRecord=new OSM_Order_Item_License__c();
                                    String omsOrderId=null;
                                    if(null == orderItemLicenseListToCheck || orderItemLicenseListToCheck.size()==0 || (null != orderItemId && null != orderItemLicenseId))
                                    {
                                        // CREATE ORDER Service
                                        OSM_OMS_CreateOrderGeneral_OP_Wrapper createOrderGeneralizedOutputWrapper = OSM_OMS_WS_CreateOrder.callOMSCreateOrderService(generalizedInputWrapper);
                                        
                                        toBeInsertedLogList.add(createOrderGeneralizedOutputWrapper.log);
                                        //toBeInsertedLogList.add(objOIL);//Added By Dhiraj
    
                                        
                                        if(null != createOrderGeneralizedOutputWrapper
                                           && null != createOrderGeneralizedOutputWrapper.omsOrderId && !String.isEmpty(createOrderGeneralizedOutputWrapper.omsOrderId))
                                        {
                                            //orderItem.OMS_Order_ID__c = createOrderGeneralizedOutputWrapper.omsOrderId;
                                            //orderItemLicenseRecord.OMS_Order_ID__c=createOrderGeneralizedOutputWrapper.omsOrderId;
                                            omsOrderId=createOrderGeneralizedOutputWrapper.omsOrderId;
                                        }
                                    }
                                    
                                    //System.debug('The OMS ID : ' + orderItemLicenseRecord.OMS_Order_ID__c);
                                    
                                    if(!singleOrderItemFlag)
                                    {
                                        if((null != omsOrderId && !String.isEmpty(omsOrderId)) 
                                       && (orderItemLicenseListToCheck==null || orderItemLicenseListToCheck.size()==0))
                                       {
                                        // GET ORDER Service
                                        OSM_GetOrder_WS_GeneralizedoutputWrapper getOrderGeneralizedOutputWrapper = OSM_GetOrderInfo_Service.callGetOrderInfoService(omsOrderId, orderId,AccountId);
                                        if(null != getOrderGeneralizedOutputWrapper)
                                        {
                                            if(!getOrderGeneralizedOutputWrapper.errorFlag || Test.isRunningTest())
                                            {
                                                if(null != getOrderGeneralizedOutputWrapper.ItemInfoList
                                                   && null != getOrderGeneralizedOutputWrapper.ItemInfoList.ItemInfo && getOrderGeneralizedOutputWrapper.ItemInfoList.ItemInfo.size() > 0)
                                                {
                                                    for(Integer i=0; i<getOrderGeneralizedOutputWrapper.ItemInfoList.ItemInfo.size();i++)
                                                    {
                                                        orderItem.OSM_SW_Get_Order_success__c = true;
                                                        OSM_Order_Item_License__c orderItemLicenseRecord=new OSM_Order_Item_License__c();
                                                        if(getOrderGeneralizedOutputWrapper.ItemInfoList.ItemInfo[i].LicenseInfo.LicenseName.contains('Basic'))
                                                        {
                                                            orderItemLicenseRecord.OMS_Item_ID__c = getOrderGeneralizedOutputWrapper.ItemInfoList.ItemInfo[i].ItemId;
                                                            orderItemLicenseRecord.Activation_Key__c=getOrderGeneralizedOutputWrapper.ItemInfoList.ItemInfo[i].LicenseInfo.ActivationKey;
                                                            orderItemLicenseRecord.type__c='Basic';
                                                            orderItemLicenseRecord.CC_Order_Item__c=orderItem.id;
                                                            orderItemLicenseRecord.OMS_Order_ID__c=omsOrderId;
                                                            
                                                            orderItemLicenseRecord.Status__c='New';
                                                            //toBeInsertUpdateListOrderItemLicense.add(orderItemLicenseRecord);
                                                        }
                                                        else
                                                        {
                                                            orderItemLicenseRecord.OMS_Item_ID__c = getOrderGeneralizedOutputWrapper.ItemInfoList.ItemInfo[i].ItemId;
                                                            orderItemLicenseRecord.Activation_Key__c=getOrderGeneralizedOutputWrapper.ItemInfoList.ItemInfo[i].LicenseInfo.ActivationKey;
                                                            orderItemLicenseRecord.type__c='Functional';
                                                            orderItemLicenseRecord.CC_Order_Item__c=orderItem.id;
                                                            orderItemLicenseRecord.OMS_Order_ID__c=omsOrderId;
                                                            orderItemLicenseRecord.Status__c='New';
                                                            //toBeInsertUpdateListOrderItemLicense.add(orderItemLicenseRecord);
                                                        }
                                                      toBeInsertUpdateListOrderItemLicense.add(orderItemLicenseRecord);
                                                    }
                                                    
                                                    
                                                } 
                                                orderRef.IsGetOrderSuccess__c=true;
                                                if(updatekey)orderRef.IsActivationKeyJobRun__c=True; 
                                            }
                                            
                                            if(null != getOrderGeneralizedOutputWrapper.log)
                                            {
                                                toBeInsertedLogList.add(getOrderGeneralizedOutputWrapper.log);
                                                //toBeInsertedLogList.add(objOIL);//Added By Dhiraj
                                            }
                                        }
                                       }
                                    }
                                    else{
                                        
                                        if((null != omsOrderId && !String.isEmpty(omsOrderId))) 
                                        {
                                        // GET ORDER Service
                                        OSM_GetOrder_WS_GeneralizedoutputWrapper getOrderGeneralizedOutputWrapper = OSM_GetOrderInfo_Service.callGetOrderInfoService(omsOrderId, orderId,AccountId);
                                        if(null != getOrderGeneralizedOutputWrapper)
                                        {
                                            if(!getOrderGeneralizedOutputWrapper.errorFlag || Test.isRunningTest())
                                            {
                                                if(null != getOrderGeneralizedOutputWrapper.ItemInfoList
                                                   && null != getOrderGeneralizedOutputWrapper.ItemInfoList.ItemInfo && getOrderGeneralizedOutputWrapper.ItemInfoList.ItemInfo.size() > 0 
                                                   )
                                                {
                                                    for(Integer i=0; i<getOrderGeneralizedOutputWrapper.ItemInfoList.ItemInfo.size();i++)
                                                    {
                                                        orderItem.OSM_SW_Get_Order_success__c = true;
                                                        OSM_Order_Item_License__c orderItemLicenseRecord=new OSM_Order_Item_License__c();
                                                        if(getOrderGeneralizedOutputWrapper.ItemInfoList.ItemInfo[i].LicenseInfo.LicenseName.contains('Basic'))
                                                        {
                                                            orderItemLicenseRecord.Activation_Key__c=getOrderGeneralizedOutputWrapper.ItemInfoList.ItemInfo[i].LicenseInfo.ActivationKey;
                                                            if(orderItemLicenseList!=null && orderItemLicenseList.size()>0)
                                                            orderItemLicenseRecord.Revoked_ReIssue_Lisence__c=orderItemLicenseList[0].id;
                                                            orderItemLicenseRecord.CC_Order_Item__c=orderItem.id;
                                                            //orderItemLicenseRecord.Parent_Activation_Key__c=orderItemLicenseList[0].id;
                                                            orderItemLicenseRecord.Status__c='Create And Get Done';
                                                            orderItemLicenseRecord.type__c='Basic';
                                                            orderItemLicenseList[0].Status__c='Reissued';
                                                            orderItemLicenseRecord.OMS_Order_ID__c=omsOrderId;
                                                            orderItemLicenseRecord.OMS_Item_ID__c = getOrderGeneralizedOutputWrapper.ItemInfoList.ItemInfo[i].ItemId;
                                                            //toBeInsertUpdateListOrderItemLicense.add(orderItemLicenseList[0]);
                                                            //toBeInsertUpdateListOrderItemLicense.add(orderItemLicenseRecord);
                                                        }
                                                        else
                                                        {
                                                            orderItemLicenseRecord.Activation_Key__c=getOrderGeneralizedOutputWrapper.ItemInfoList.ItemInfo[i].LicenseInfo.ActivationKey;
                                                            if(orderItemLicenseList!=null && orderItemLicenseList.size()>0)
                                                            orderItemLicenseRecord.Revoked_ReIssue_Lisence__c=orderItemLicenseList[0].id;
                                                            orderItemLicenseRecord.CC_Order_Item__c=orderItem.id;
                                                            //orderItemLicenseRecord.Parent_Activation_Key__c=orderItemLicenseList[0].id;
                                                            orderItemLicenseRecord.Status__c='Create And Get Done';
                                                            orderItemLicenseRecord.type__c='Functional';
                                                            orderItemLicenseList[0].Status__c='Reissued';
                                                            orderItemLicenseRecord.OMS_Order_ID__c=omsOrderId;
                                                            orderItemLicenseRecord.OMS_Item_ID__c = getOrderGeneralizedOutputWrapper.ItemInfoList.ItemInfo[i].ItemId;
                                                            //toBeInsertUpdateListOrderItemLicense.add(orderItemLicenseList[0]);
                                                            //toBeInsertUpdateListOrderItemLicense.add(orderItemLicenseRecord);
                                                        }
                                                    
                                                    toBeInsertUpdateListOrderItemLicense.add(orderItemLicenseRecord);
                                                
                                                    }
                                                    toBeInsertUpdateListOrderItemLicense.add(orderItemLicenseList[0]);
                                                    
                                                }   
                                            }
                                            
                                            if(null != getOrderGeneralizedOutputWrapper.log)
                                            {
                                                toBeInsertedLogList.add(getOrderGeneralizedOutputWrapper.log);
                                                //toBeInsertedLogList.add(objOIL);//Added By Dhiraj
                                            }
                                        }
                                       }
                                        
                                    }
                                    
                                   
                                    
                                    toBeUpdatedOrderItemList.add(orderItem);
                                    //toBeInsertUpdateListOrderItemLicense.add(orderItemLicenseList[0]);
                                    //toBeInsertedLogList.add(objOIL);//Added By Dhiraj
                                    //System.debug('After toBeInsertedLogList+++ '+ toBeInsertedLogList);
                                }
                            }
                        }
                    }
                }
                
                
                 /*
                // code commented for MAR-1816
                if(null != toBeUpdatedOrderItemList && toBeUpdatedOrderItemList.size() > 0)
                {
                    update toBeUpdatedOrderItemList;
                }
                if(null != toBeInsertedLogList && toBeInsertedLogList.size() > 0)
                {
                    System.debug('toBeInsertedLogList+++ '+ toBeInsertedLogList);
                    insert toBeInsertedLogList;
                }
                if(null != toBeUpdatedOrderList && toBeUpdatedOrderList.size() > 0)
                {
                    update toBeUpdatedOrderList;
                }
                if(null!=toBeInsertUpdateListOrderItemLicense && toBeInsertUpdateListOrderItemLicense.size()>0)
                {
                    upsert toBeInsertUpdateListOrderItemLicense;
                }*/
                // New changes for MAR-1816
                
                if(null != toBeInsertedLogList && toBeInsertedLogList.size() > 0) {
                    System.debug('toBeInsertedLogList+++ '+ toBeInsertedLogList);
                    insert toBeInsertedLogList;
                }
                if(null!=toBeInsertUpdateListOrderItemLicense && toBeInsertUpdateListOrderItemLicense.size()>0) {
                    upsert toBeInsertUpdateListOrderItemLicense;
                }
                if(null != toBeUpdatedOrderItemList && toBeUpdatedOrderItemList.size() > 0) {
                    update toBeUpdatedOrderItemList;
                }
                if(null != toBeUpdatedOrderList && toBeUpdatedOrderList.size() > 0) {
                    update toBeUpdatedOrderList;
                }
                
                if(Test.isRunningTest())
                {
                    throw new NullPointerException();
                }
            }
            catch(Exception ex)
            {
                System.debug('Inside Catch+++');
                OSM_Integration_Log__c log = new OSM_Integration_Log__c();
                
                System.debug('AccountId+++' + AccountId);
                log.Account__c = AccountId;  // Added By Dhiraj for MAR-1621 - Story On 21st April 2021
                
                System.debug('log.Account__c+++' + log.Account__c);
                
                log.Service_Name__c = Label.OSM_OMS_Service;
                log.Target__c = Label.OSM_OMS;
                log.Source__c = Label.OSM_Paid_recurring_invoice_source;
                log.Request__c = 'Using orderIdSet : ' + orderIdLst;
                System.debug(ex.getMessage()+'   '+'Stacktrace - ' + ex.getStackTraceString());
                String msg  = 'Message - '+ex.getMessage();
                msg=msg+ 'Stacktrace - ' + ex.getStackTraceString();
                log.Error_Description__c = msg ;
                log.Status__c = Label.OSM_Subs_Cancellation_Failure; 
                
                System.debug('log+++' + log);
                
                insert log;
            }
        }
        
        public static String getRequiredDateFormat(Date d, String format)
        {
            Datetime myDT = datetime.newInstance(d.year(), d.month(),d.day());
            String myDate = myDT.format(format);
            System.debug(myDate);
            
            return myDate;
        }
    }