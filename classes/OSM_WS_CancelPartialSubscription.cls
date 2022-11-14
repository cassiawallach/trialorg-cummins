/************************************************************
Name:  OSM_WS_CancelPartialSubscription 
Copyright © 2018  Cummins
=============================================================
=============================================================
Purpose:                                                            
This global class will be exposed for partial subscription
cancellation interface. Input JSON will be fetched based on 
entry level criteria's and subscription and order subscription
junction records will be inserted/updated accordingly. 

=============================================================
=============================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE              DETAIL                                
1.0 -   Ankit S         07/07/2018     INITIAL DEVELOPMENT          


*************************************************************/

@RestResource(UrlMapping = '/CancelPartialSubscription/*')
global with sharing class OSM_WS_CancelPartialSubscription{
    
    public static String jSONRequestBody ;  
    
/*-------------------------------------------------------------------------------------
1. FetchCancelPartialSubscriptionInfo
Description: Used to fetch input JSON for partial subscription cancellation. It will
check if it contains all required paramters or not; and will then pass it for execution. 
Input: RestContext.request (Incoming JSON)
Output: Returns OSM_WS_CancelPartialSubscription_RES and respective logs upon 
success or failure of action. 
Returntype: OSM_WS_CancelPartialSubscription_RES
----------------------------------------------------------------------------------------*/
    //This will be taken up in release 1B
    /*
    @HttpPost
    global static List<OSM_WS_CancelPartialSubscription_RES> FetchCancelPartialSubscriptionInfo(){
            
            OSM_WS_CancelPartialSubscription_REQ reqJSON = null; //Instantiating request class
            OSM_WS_CancelPartialSubscription_RES resJSON = null; //Instantiating response class
            String customerjID;
            Boolean RequiredFieldMissingFlag = false;  
            List<OSM_WS_CancelPartialSubscription_RES> resJSONList = new List<OSM_WS_CancelPartialSubscription_RES>();
            Set<Boolean> sRequiredFieldchecks = new Set<Boolean>(); 
            Map<String,OSM_SW_OrderSubscriptionWrapper> returnWrapperMap = new Map<String,OSM_SW_OrderSubscriptionWrapper>();
            Set<String> SetOfSubsNameFromWrapper = new Set<String>();
            String action = label.OSM_Partial_Subscription_Cancellation;
            OSM_Integration_Log__c log = null;
            List<OSM_Integration_Log__c> logList = new List<OSM_Integration_Log__c>();
            Set<Id> successfullSubsUpdates = new Set<Id>(); //Set of Id's of successfull subscription records update
            
            try{
            RestRequest req = RestContext.request;  //Get request from rest context
            RestResponse res = RestContext.response; //Get response from rest context
            jSONRequestBody = req.requestBody.toString().trim();
          //  system.debug('jSONRequestBody'+jSONRequestBody);

            reqJSON = (OSM_WS_CancelPartialSubscription_REQ)JSON.deserialize(jSONRequestBody,OSM_WS_CancelPartialSubscription_REQ.class);
           // system.debug('reqJSON'+reqJSON);
            
            resJSON = new OSM_WS_CancelPartialSubscription_RES();
            
            //Instantiate request objects            
            List<OSM_WS_CancelPartialSubscription_REQ.Orders> OrderObjList = new List<OSM_WS_CancelPartialSubscription_REQ.Orders>();
            OrderObjList = reqJSON.Orders;      //fetch order list from input JSON
            customerjID = reqJSON.customerID;   //fetch customer id from input JSON
            
            //Check for required fields
            if(!String.isBlank(customerjID)){
                for(OSM_WS_CancelPartialSubscription_REQ.Orders order :OrderObjList){
                if(!String.isBlank(order.orderID)){
                        for(OSM_WS_CancelPartialSubscription_REQ.OrderLineItems orderItem :order.orderLineItems){
                            if(String.isBlank(orderItem.productID) || (orderItem.subscriptionQuantity == null)){
                                RequiredFieldMissingFlag = true;
                                sRequiredFieldchecks.add(RequiredFieldMissingFlag);
                                break;
                            }else{
                                RequiredFieldMissingFlag = false;
                                sRequiredFieldchecks.add(RequiredFieldMissingFlag);
                            }                       
                        }   
                    }else{
                        RequiredFieldMissingFlag = true;
                        sRequiredFieldchecks.add(RequiredFieldMissingFlag);
                        break;
                    }                           
                }
            }else{
                RequiredFieldMissingFlag = true;
                sRequiredFieldchecks.add(RequiredFieldMissingFlag);
            }            
            system.debug('RequiredFieldMissingFlag'+RequiredFieldMissingFlag);
            
                //If any required field are missing
                if(sRequiredFieldchecks.contains(true)){  
                    //Create Integration log
                    log = new OSM_Integration_Log__c();
                    OSM_SW_LoggingContext.integrationLog = log;
                    log.Request__c = jSONRequestBody;
                    log.Service_Name__c = label.OSM_Partial_Subscription_Cancellation;
                    log.Source__c = label.OSM_Partial_Subscription_Cancellation_Source;
                    log.Target__c = label.OSM_Partial_Subscription_Cancellation_Target;
                    log.Response__c = label.OSM_Missing_Required_Fields;
                    log.Status__c = label.OSM_Subs_Cancellation_Failure;
                    log.Error_Description__c = label.OSM_Missing_Required_Fields;
                    log.Logged_In_User__c = userinfo.getUserId();
                    logList.add(log);
                    
                    //Create response object
                    resJSON = new OSM_WS_CancelPartialSubscription_RES();
                    resJSON.Status = label.OSM_Subs_Cancellation_Failure;
                    resJSON.ReturnCodeDescription = label.OSM_Missing_Required_Fields;
                    resJSONList.add(resJSON);
                
                }else{
                    system.debug('No Required Flag Missing');
                    
                    successfullSubsUpdates = CreateWrapperForPartialCancelSubscription(reqJSON); //Create wrapper for the processing
                    system.debug('successfullSubsUpdates'+successfullSubsUpdates);
                    
                    //Query subscription records from wrapper and get next invoice date and return date-1 to DA          
                        if(successfullSubsUpdates != null && successfullSubsUpdates.size()>0){
                            Map<Id,ccrz__E_Subscription__c> mapSubsIdSubsRec  = new Map<Id,ccrz__E_Subscription__c>([Select id, name, ccrz__CCOrder__c, ccrz__CCOrder__r.name, ccrz__InstallmentNextDate__c from ccrz__E_Subscription__c where id IN :successfullSubsUpdates]);     
                            system.debug('mapSubsIdSubsRec'+mapSubsIdSubsRec);  
                        
                                if(mapSubsIdSubsRec.keyset() != null && mapSubsIdSubsRec.size()>0){
                                    for(Id SubsId :mapSubsIdSubsRec.keyset()){
                                        //Create response in case of success
                                        resJSON = new OSM_WS_CancelPartialSubscription_RES();
                                        resJSON.Status = label.OSM_Subs_Cancellation_Success;
                                        resJSON.ReturnCodeDescription = label.OSM_Subs_Cancellation_Message;
                                        resJSON.nextInvoiceDate = (mapSubsIdSubsRec.get(SubsId).ccrz__InstallmentNextDate__c)-1;
                                        resJSON.subscriptionName = mapSubsIdSubsRec.get(SubsId).name;
                                        resJSON.Ordername = mapSubsIdSubsRec.get(SubsId).ccrz__CCOrder__r.name;
                                        system.debug('resJSON'+resJSON);
                                        resJSONList.add(resJSON);
                                    }   
                                } 
                            }   
                        }
                  
                    }catch(Exception e){
                        system.debug('Exception-'+e.getMessage());                   
                        resJSON = new OSM_WS_CancelPartialSubscription_RES();
                        resJSON.Status = label.OSM_Subs_Cancellation_Failure;
                        resJSON.ReturnCodeDescription = e.getMessage() + ' at line number '+e.getLineNumber();
                        resJSONList.add(resJSON);
                        
                        //Create Integration log
                        log = new OSM_Integration_Log__c();
                        OSM_SW_LoggingContext.integrationLog = log;
                        log.Request__c = jSONRequestBody;
                        log.Service_Name__c = action;
                        log.Source__c = label.OSM_Partial_Subscription_Cancellation_Source;
                        log.Target__c = label.OSM_Partial_Subscription_Cancellation_Target;
                        log.Response__c = e.getMessage() + ' at line number ' + e.getLineNumber();
                        log.Error_Description__c = e.getStacktraceString();
                        log.Status__c = label.OSM_Subs_Cancellation_Failure;
                        log.Logged_In_User__c = userinfo.getUserId();
                        logList.add(log);
                    }
                    system.debug('resJSONList'+resJSONList);
                    system.debug('logList'+logList);
                    OSM_SW_LoggingContext.saveIntegrationLogList(logList);
                    return resJSONList;     
            }
            */
/*-------------------------------------------------------------------------------------
2. CreateWrapperForPartialCancelSubscription
Description: It will create wrapper class 'PartialSubsCancellationWrapper' object
based on input from DA 
Input: OSM_WS_CancelPartialSubscription_REQ
Output: Returns OSM_Integration_Log__c and pass wrapper for execution
Returntype: OSM_Integration_Log__c
----------------------------------------------------------------------------------------*/
            //This will be taken up in release 1B
            /*
            public static Set<Id> CreateWrapperForPartialCancelSubscription(OSM_WS_CancelPartialSubscription_REQ reqJSON){
                
                Map<String,String> defaultProdPartNoVsSegmentProdPartNo = new Map<String,String>(); //Map for getting default part number wrt segment part number
                Map<String,String> mapOrderIdSubsName = new Map<String,String>(); //Map of OrderId and Subscription Name
                Map<String,OSM_Order_Subscription__c> mapOrderIdOrderSubsRec = new Map<String,OSM_Order_Subscription__c>(); //Map of OrderId and Order Subscription Record
                String action; //String variable to store type of processing
                Map<String,PartialSubsCancellationWrapper> mapOrderIdSubsCancelWrap = new Map<String,PartialSubsCancellationWrapper>(); //Map of OrderId and PartialSubsCancellation wrapper
                List<String> defaultProductSkuList = new List<String>();
                Map<String,String> mapOrderIdDefaultProdSku = new Map<String,String>(); //Map of OrderId and Default Product SKU
                String defaultProductSku;
                Map<String,OSM_SW_OrderSubscriptionWrapper> mapOrderNameVsWrap = new Map<String,OSM_SW_OrderSubscriptionWrapper>(); //Map of order name from wrapper and wrapper
                Set<String> productSKU = new Set<String>(); //Set of productSKU string
                List<ccrz__E_Subscription__c> listOfSubs = new List<ccrz__E_Subscription__c>();
                Map<String,ccrz__E_Subscription__c> mapProductSKUVsSubsRec = new Map<String,ccrz__E_Subscription__c>(); //Map of productSKU and subs record
                Set<Id> successfulSubs = new Set<Id>(); //Set of Id's to store successfull records after update
                Set<Id> returnSuccessIds = new Set<Id>();
                
                try{
                List<OSM_WS_CancelPartialSubscription_REQ.Orders> OrderObjList = new List<OSM_WS_CancelPartialSubscription_REQ.Orders>();
                OrderObjList = reqJSON.Orders;
                
                //Get the associated account
                Account acc = [Select id, OSM_Market_Segment_Code__c from account where CMI_Cid__c = :reqJSON.customerID];
                system.debug('acc'+acc);
                
                //Iterate over order, to create a wrapper
                for(OSM_WS_CancelPartialSubscription_REQ.Orders order :OrderObjList){                   
                    for(OSM_WS_CancelPartialSubscription_REQ.OrderLineItems orderItem :order.orderLineItems){
                        defaultProductSku = orderItem.productID + label.OSM_Default_Market_Segment;
                        defaultProductSkuList.add(defaultProductSku);
                    }
                    mapOrderIdDefaultProdSku.put(order.orderID,defaultProductSku);
                }
                system.debug('mapOrderIdDefaultProdSku'+mapOrderIdDefaultProdSku);
                
                //Return sample -  {5678901-DEF=5678902-OHT}
                defaultProdPartNoVsSegmentProdPartNo = OSM_DA_GenericFunctionsUtility.fetchOSMProdPartNoForDefaultSku(defaultProductSkuList,acc.OSM_Market_Segment_Code__c); 
                system.debug('defaultProdPartNoVsSegmentProdPartNo'+defaultProdPartNoVsSegmentProdPartNo);
                
                system.debug('OrderObjList'+OrderObjList);
                //Retrive values from input JSON and populate them in wrapper class variables and also create a map. 
                for(OSM_WS_CancelPartialSubscription_REQ.Orders order :OrderObjList){
                    PartialSubsCancellationWrapper subsCancelWrap = new PartialSubsCancellationWrapper();
                    subsCancelWrap.da_orderId = order.orderID;
                    
                    for(OSM_WS_CancelPartialSubscription_REQ.OrderLineItems orderItem :order.orderLineItems){
                        if(mapOrderIdDefaultProdSku.containsKey(order.orderID)){
                            subsCancelWrap.da_productId = defaultProdPartNoVsSegmentProdPartNo.get(mapOrderIdDefaultProdSku.get(order.orderID));
                            subsCancelWrap.da_quantity = orderItem.subscriptionQuantity; 
                            
                            productSKU.add(subsCancelWrap.da_productId);
                        }
                    }
                    mapOrderIdSubsCancelWrap.put(order.orderID,subsCancelWrap);
                }
                system.debug('mapOrderIdSubsCancelWrap'+mapOrderIdSubsCancelWrap);
                
                //Get list of product id's
                List<Id> productIdList = new List<Id>();
                List<ccrz__E_Product__c> productList = [select id,name,Package__c,ccrz__SKU__c from ccrz__E_Product__c where ccrz__SKU__c IN :productSKU];
                for(ccrz__E_Product__c prod :productList){
                    productIdList.add(prod.id);
                }
                
                //Get list of subsscription for that account and create a map based on product SKU
                listOfSubs = OSM_SW_Transaction_Util.fetchActiveSubscriptionForAccount(acc.id, productIdList);
                if(listOfSubs != null && listOfSubs.size()>0){
                    for(ccrz__E_Subscription__c subRec :listOfSubs){
                        mapProductSKUVsSubsRec.put(subRec.ccrz__SubscriptionProduct__r.ccrz__SKU__c, subRec);
                    }   
                }
                system.debug('mapProductSKUVsSubsRec'+mapProductSKUVsSubsRec);
                
                    //Prepare final wrapper
                    if(mapProductSKUVsSubsRec.keyset() != null && mapProductSKUVsSubsRec.size()>0){
                        for(PartialSubsCancellationWrapper pscWrap :mapOrderIdSubsCancelWrap.values()){
                                if(mapProductSKUVsSubsRec.containsKey(pscWrap.da_productId)){
                                    OSM_SW_OrderSubscriptionWrapper osWrap = new OSM_SW_OrderSubscriptionWrapper();
                                    osWrap.osm_orderId = pscWrap.da_orderId;
                                    osWrap.osm_subscriptionID = mapProductSKUVsSubsRec.get(pscWrap.da_productId).name;
                                    osWrap.osm_quantity = pscWrap.da_quantity;
                                    osWrap.osm_productId = pscWrap.da_productId;
                                    osWrap.osm_CancelDate = system.today(); //Date on which susbcription cancellation is requested
                                    //osWrap.osm_orderSubs = mapOrderIdOrderSubsRec.get(pscWrap.da_orderId);
                                    mapOrderNameVsWrap.put(osWrap.osm_orderId,osWrap);
                                }                           
                            }
                        }                               
                
                }Catch(Exception e){
                    throw new OSM_SW_OrderProcesssingException(e.getMessage()); 
                }               
                system.debug('mapOrderNameVsWrap'+mapOrderNameVsWrap); 
                
                if(mapOrderNameVsWrap.keyset() != null && mapOrderNameVsWrap.size()>0){
                    action = label.OSM_Partial_Subscription_Cancellation; 
                    successfulSubs = updateSubscriptionAndJunction(mapOrderNameVsWrap.values(),action,false); //Call method for performing DML actions
                    returnSuccessIds = successfulSubs;
                }
                system.debug('returnSuccessIds'+returnSuccessIds);
                return returnSuccessIds;    
            }
            */
        

        
/*-------------------------------------------------------------------------------------
3. updateSubscriptionAndJunction
Description: THIS IS COMMON UTILITY METHOD WHICH WILL insert/update subscription record, 
update order subscription, update transaction payment record, update order and order 
line item based on wrapper input parameters
Input: List<OSM_SW_OrderSubscriptionWrapper> osWrapList, String action
Output: Returns OSM_Integration_Log__c based on success or failure of DML operations
Returntype: void
----------------------------------------------------------------------------------------*/
            
            public static Set<Id> updateSubscriptionAndJunction(List<OSM_SW_OrderSubscriptionWrapper> osWrapList, String action, Boolean orderItemCancel){
                
                Map<String,ccrz__E_Subscription__c> mapWrapSubsRec = new Map<String,ccrz__E_Subscription__c>(); //Map of susbcription name and susbcription record
                List<ccrz__E_Subscription__c> subsToInsertList = new List<ccrz__E_Subscription__c>(); //List to insert subscription records
                Map<Id,ccrz__E_Subscription__c> mapSubsToUpdate = new Map<Id,ccrz__E_Subscription__c>(); //Map to update susbcription records
                Map<Id,ccrz__E_Order__c> mapAssociatedOrderToUpdate = new Map<Id,ccrz__E_Order__c>(); //Map to update associated order records
                Map<Id,OSM_Order_Subscription__c> mapOrderSubsUpdate = new Map<Id,OSM_Order_Subscription__c>(); //Map to update order susbcription junction records
                Map<Id,ccrz__E_OrderItem__c> maporderItemRecToUpdate = new Map<Id,ccrz__E_OrderItem__c>();  
                Map<Id,ccrz__E_TransactionPayment__c> mapToUpdateTransactionPayment = new Map<Id,ccrz__E_TransactionPayment__c>();  
                Set<Id> setUpdatedSubsRec = new Set<Id>();
                OSM_Integration_Log__c log = null;
                Map<String,ccrz__E_Order__c> orderNameVsOrderMap = new Map<String,ccrz__E_Order__c>();
                Map<String,ccrz__E_Order__c> orderIdVsOrderMap = new Map<String,ccrz__E_Order__c>();
                Boolean exceptionFlag = false;
                List<String> subsNameFromWrapper = new List<String>(); //List to get susbcription name from input wrapper        
                Id AccountId;
                
                Savepoint sp = Database.setSavepoint(); //Set savepoint
                
                    try{ 
                       // system.debug('osWrapList'+osWrapList);
                        
                        Map<String,OSM_SW_OrderSubscriptionWrapper> mapOrderNameVsOrderSubsWrapper = new Map<String,OSM_SW_OrderSubscriptionWrapper>();
                        Map<String,List<ccrz__E_OrderItem__c>> mapOrderNameVsOrderItemList = new Map<String,List<ccrz__E_OrderItem__c>>();
                        List<ccrz__E_Subscription__c> lstSubscIdForZeroQuantity = new List<ccrz__E_Subscription__c>();
                        Map<String,ccrz__E_TransactionPayment__c> mapOrderNameVsTransactionPayment = new Map<String,ccrz__E_TransactionPayment__c>();
                        
                        for(OSM_SW_OrderSubscriptionWrapper osw :osWrapList){
                            subsNameFromWrapper.add(osw.osm_subscriptionID);
                            mapOrderNameVsOrderSubsWrapper.put(osw.osm_orderId,osw);
                        }
                       // system.debug('subsNameFromWrapper'+subsNameFromWrapper);
                        
                        //Get map of order name and list of order line item. Also get map of order name with transaction payment record
                        List<Id> orderIdList = new List<Id>();
                        for(ccrz__E_Order__c orderRec :[Select id, OrderProcessedforFSD__c,OSM_SW_IsFSDFailed__c,name, (Select id, name, Transaction_Status__c, ccrz__AccountType__c, Bolt_Credit_Memo_Call_Status__c, Bolt_JE_Reversal_Call_Status__c from ccrz__TransactionPayments__r limit 1) from ccrz__E_Order__c where name IN :mapOrderNameVsOrderSubsWrapper.keyset()]){
                            orderIdList.add(orderRec.id);
                            orderNameVsOrderMap.put(orderRec.name,orderRec);
                            mapOrderNameVsTransactionPayment.put(orderRec.name,orderRec.ccrz__TransactionPayments__r);
                            orderIdVsOrderMap.put(orderRec.name,orderRec);
                        }
                        List<ccrz__E_Order__c> orderList = OSM_SW_Transaction_Util.fetchOrderAndOrderItems(orderIdList);
                        for(ccrz__E_Order__c ccorder :orderList){
                            
                            mapOrderNameVsOrderItemList.put(ccorder.name,ccorder.ccrz__E_OrderItems__r);
                        }
                       // system.debug('mapOrderNameVsOrderItemList'+mapOrderNameVsOrderItemList);
                       // system.debug('mapOrderNameVsTransactionPayment'+mapOrderNameVsTransactionPayment);
                        
                        //Get susbcription record list
                        List<ccrz__E_Subscription__c> subsList = [Select id, name, ccrz__Account__c, ccrz__CCOrder__c, ccrz__CCOrderItem__c, ccrz__CurrencyISOCode__c, ccrz__Quantity__c, OSM_Subscription_End_Date__c, Next_Invoice_Generation_Date__c, ccrz__SubscriptionStatus__c, ccrz__SubscriptionProduct__c, ccrz__SubscriptionProduct__r.ccrz__ProductType__c, OSM_Subscription_Cancellation_Date__c, ccrz__Storefront__c, ccrz__SPT__c, ccrz__Sequence__c, ccrz__User__c, ccrz__SubscriptionStartDate__c, Subscription_Cancellation_Requested_Date__c, ccrz__InstallmentNextDate__c, OSM_Parent_Subscription__c from ccrz__E_Subscription__c where name IN :subsNameFromWrapper];
                        //system.debug('subsList'+subsList);
                        
                        //Create a map
                        if(subsList != null && subsList.size()>0){
                            for(ccrz__E_Subscription__c subrec :subsList){
                                mapWrapSubsRec.put(subrec.name,subrec);
                                AccountId = subrec.ccrz__Account__c;
                            }   
                        }
                        //system.debug('mapWrapSubsRec'+mapWrapSubsRec);
                        
                        //Iterate over wrapper object and prepare list/map to insert/update sObject records
                        if(mapWrapSubsRec.keyset() != null && mapWrapSubsRec.size()>0){
                           

                           for(OSM_SW_OrderSubscriptionWrapper osw :osWrapList){  
                                ccrz__E_Subscription__c subsObj = mapWrapSubsRec.get(osw.osm_subscriptionID);
                                
                                //Update transaction payment record
                                if(action == label.OSM_Order_Cancellation){
                                    ccrz__E_TransactionPayment__c ctpayment = mapOrderNameVsTransactionPayment.get(osw.osm_orderId);
                                    ctpayment.Transaction_Status__c = label.OSM_Order_Cancel_Success; //Status to order cancel success
                                    if(ctpayment.ccrz__AccountType__c == 'po'){
                                        if(!orderIdVsOrderMap.get(osw.osm_orderId).OrderProcessedforFSD__c)
                                        {
                                            if(!orderIdVsOrderMap.get(osw.osm_orderId).OSM_SW_IsFSDFailed__c)
                                            {
                                                //commenting for partial cancellation
                                                //ctpayment.Bolt_Credit_Memo_Call_Status__c = 'Pending';
                                                //ctpayment.Bolt_JE_Reversal_Call_Status__c = 'Pending';
                                            }
                                        }
                                    }
                                    mapToUpdateTransactionPayment.put(ctpayment.id,ctpayment);
                                }                               
                                
                                //Update the existing subscription record
                                //ccrz__E_Subscription__c updateSubs = new ccrz__E_Subscription__c(id = subsObj.id);
                                    if(action == label.OSM_Order_Cancellation){
                                        subsObj.ccrz__Quantity__c =  subsObj.ccrz__Quantity__c - osw.osm_quantity;   //Updated with Net quantity
                                        if(subsObj.ccrz__Quantity__c <= 0){
                                            subsObj.ccrz__SubscriptionStatus__c = label.OSM_Subs_Status_With_Zero_Quantity;
                                            if(subsObj.ccrz__SubscriptionProduct__r.ccrz__ProductType__c == 'Bundle')
                                            {
                                                subsObj.Subscription_Cancellation_Requested_Date__c = osw.osm_CancelDate;
                                                lstSubscIdForZeroQuantity.add(subsObj);
                                            }
                                                
                                        }
                                        subsObj.Subscription_Cancellation_Requested_Date__c = osw.osm_CancelDate;    //Cancellation request date  
                                        mapSubsToUpdate.put(subsObj.id,subsObj);
                                    }
                                    /* Will be taken up in 1B release
                                    if(action == label.OSM_Partial_Subscription_Cancellation){
                                        updateSubs.Subscription_Cancellation_Requested_Date__c = osw.osm_CancelDate;
                                        //updateSubs.ccrz__SubscriptionStatus__c = label.OSM_Subs_Cancellation_Request_Status;
                                        updateSubs.OSM_Subscription_Cancellation_Date__c = Date.valueOf(subsObj.ccrz__InstallmentNextDate__c - 1);
                                        mapSubsToUpdate.put(updateSubs.id,updateSubs);
                                    }*/
                                      
                                
                                //Update associated order
                                /*Will be taken up in 1B release
                                if(action == label.OSM_Partial_Subscription_Cancellation){
                                    ccrz__E_Order__c associatedOrder = new ccrz__E_Order__c(id = subsObj.ccrz__CCOrder__c);
                                    associatedOrder.ccrz__OrderStatus__c = label.OSM_Partial_Cancellation_Order_Request_Status;                                
                                    mapAssociatedOrderToUpdate.put(associatedOrder.id,associatedOrder);                                     
                                }*/
                                ccrz.cclog.log('========OSM:Inside Order Cancellation logic======'+osw.osm_orderId);
                                if(action == label.OSM_Order_Cancellation){
                                    
                                    //START : Added by Vaibhav on 1-Oct
                                    //ccrz__E_Order__c associatedOrder = new ccrz__E_Order__c(id = subsObj.ccrz__CCOrder__c);
                                    String orderName = osw.osm_orderId;
                                    ccrz__E_Order__c associatedOrder = orderNameVsOrderMap.get(orderName);
                                    //ccrz__E_Order__c associatedOrder = new ccrz__E_Order__c(id = osw.osm_orderId);
                                    
                                    //END : Added by Vaibhav on 1-Oct
                                    associatedOrder.Refund_status__c = label.OSM_OrderCancellation_RefundSts;                                
                                    mapAssociatedOrderToUpdate.put(associatedOrder.id,associatedOrder);                                     
                                }
                                
                                //Update order lineItem for that order
                                List<ccrz__E_OrderItem__c> orderItemList = mapOrderNameVsOrderItemList.get(osw.osm_orderId);
                                    for(ccrz__E_OrderItem__c oItem :orderItemList){
                                        if(oItem.ccrz__Product__r.ccrz__SKU__c == osw.osm_productId){
                                            /*Will be taken up in 1B release
                                            if(action == label.OSM_Partial_Subscription_Cancellation){
                                                if(oItem.DA_Subscription_Cancelled_Quantity__c == null){
                                                    oItem.DA_Subscription_Cancelled_Quantity__c = osw.osm_quantity;
                                                }else if(oItem.DA_Subscription_Cancelled_Quantity__c != null){
                                                    oItem.DA_Subscription_Cancelled_Quantity__c = oItem.DA_Subscription_Cancelled_Quantity__c + osw.osm_quantity;
                                                }
                                                oItem.ccrz__OrderItemStatus__c = label.OSM_Partial_Cancellation_OrderLine_Request_Status; 
                                                oItem.DA_Subscription_Cancellation_Status__c = label.OSM_Partial_Cancellation_OrderLine_Request_Status;
                                                maporderItemRecToUpdate.put(oItem.id,oItem);
                                            }*/
                                            if(action == label.OSM_Order_Cancellation){
                                                oItem.ccrz__Quantity__c = Decimal.valueOf(label.OSM_OrderItem_Cancellation_Quantity);                    
                                                oItem.ccrz__OrderItemStatus__c = label.OSM_OrderItem_Cancellation_Status;
                                                oItem.OrderItem_Cancellation_Date__c=System.Today();
                                                oItem.VertexOrderItemCall__c =True;
                                                maporderItemRecToUpdate.put(oItem.id,oItem);
                                            }else{
                                                oItem.ccrz__OrderItemStatus__c = label.OSM_OrderItem_Cancellation_Status;
                                                oItem.OrderItem_Cancellation_Date__c=System.Today();
                                                oItem.VertexOrderItemCall__c =True;
                                                maporderItemRecToUpdate.put(oItem.id,oItem);
                                            }                         
                                        } 
                                        /*else if(action == label.OSM_Order_Cancellation && oItem.ccrz__Product__r.Group_Name__c == 'FluidWatch' && oItem.ccrz__ParentOrderItem__c == null){
                                            oItem.ccrz__Quantity__c = Decimal.valueOf(label.OSM_OrderItem_Cancellation_Quantity);                    
                                            oItem.ccrz__OrderItemStatus__c = label.OSM_OrderItem_Cancellation_Status; 
                                            oItem.VertexOrderItemCall__c =True;
                                            maporderItemRecToUpdate.put(oItem.id,oItem);
                                        } */   
                                    }
                                  
                                //Insert new subscription
                                /*Will be taken up in 1B release
                                if(action == label.OSM_Partial_Subscription_Cancellation){
                                    ccrz__E_Subscription__c newSubscription = new ccrz__E_Subscription__c();
                                    newSubscription.ccrz__Account__c = subsObj.ccrz__Account__c != null ? subsObj.ccrz__Account__c : null;
                                    newSubscription.ccrz__CCOrder__c = subsObj.ccrz__CCOrder__c != null ? subsObj.ccrz__CCOrder__c : null;
                                    newSubscription.ccrz__CCOrderItem__c = subsObj.ccrz__CCOrderItem__c != null ? subsObj.ccrz__CCOrderItem__c : null;
                                    newSubscription.ccrz__CurrencyISOCode__c = subsObj.ccrz__CurrencyISOCode__c != null ? subsObj.ccrz__CurrencyISOCode__c : '';
                                    newSubscription.ccrz__Quantity__c = -osw.osm_quantity; //insert with negative quantity
                                    newSubscription.OSM_Subscription_End_Date__c = subsObj.OSM_Subscription_End_Date__c != null ? subsObj.OSM_Subscription_End_Date__c : system.now();
                                    newSubscription.Next_Invoice_Generation_Date__c = subsObj.Next_Invoice_Generation_Date__c != null ? subsObj.Next_Invoice_Generation_Date__c : system.now();
                                    newSubscription.ccrz__SubscriptionStatus__c = label.OSM_Subs_Cancellation_Request_Status;
                                    //newSubscription.ccrz__SubscriptionProduct__c = subsObj.ccrz__SubscriptionProduct__c != null ? subsObj.ccrz__SubscriptionProduct__c : null;
                                    newSubscription.OSM_Subscription_Cancellation_Date__c = osw.osm_CancelDate;
                                    newSubscription.ccrz__Storefront__c = subsObj.ccrz__Storefront__c;
                                    //newSubscription.ccrz__SPT__c = subsObj.ccrz__SPT__c != null ? subsObj.ccrz__SPT__c : null;
                                    newSubscription.ccrz__Sequence__c = subsObj.ccrz__Sequence__c != null ? (subsObj.ccrz__Sequence__c + 1) : 1;
                                    newSubscription.ccrz__User__c = subsObj.ccrz__User__c != null ? subsObj.ccrz__User__c : userinfo.getUserId();
                                    newSubscription.ccrz__SubscriptionStartDate__c = subsObj.ccrz__SubscriptionStartDate__c;
                                    newSubscription.Subscription_Cancellation_Requested_Date__c = system.now();
                                    newSubscription.OSM_Parent_Subscription__c = subsObj.id;
                                    subsToInsertList.add(newSubscription); 
                                }*/
                                
                                //Update existing junction record
                                if(action == label.OSM_Order_Cancellation){
                                    OSM_Order_Subscription__c osJunc = osw.osm_orderSubs;
                                    Integer CurrentQuantity = Integer.valueOf(osJunc.CCQuantity__c);
                                    osJunc.CCQuantity__c = (CurrentQuantity>0) ? (CurrentQuantity - osw.osm_quantity) : 0; //update quantity
                                    mapOrderSubsUpdate.put(osJunc.id,osJunc);   
                                }            
                            
                            }//End of DML based on wrapper item
                            
                               // system.debug('mapSubsToUpdate'+mapSubsToUpdate);
                               // system.debug('mapAssociatedOrderToUpdate'+mapAssociatedOrderToUpdate);
                               // system.debug('maporderItemRecToUpdate'+maporderItemRecToUpdate);
                               // system.debug('subsToInsertList'+subsToInsertList);
                               // system.debug('mapOrderSubsUpdate'+mapOrderSubsUpdate);
                        }
                        
                        //Perform DML Actions -     
                        //Insert new subscription (only in case of partial subscription cancellation)
                        /*Will be taken up in 1B release
                        if(action == label.OSM_Partial_Subscription_Cancellation){
                            if(subsToInsertList != null && subsToInsertList.size()>0){
                                insert subsToInsertList;
                            }   
                        }*/
                                                
                        //Update transaction payment (only in case of order cancellation)
                        if(action == label.OSM_Order_Cancellation && orderItemCancel == false){
                            if(mapToUpdateTransactionPayment.keyset() != null && mapToUpdateTransactionPayment.size()>0){
                                update mapToUpdateTransactionPayment.values();
                            }
                        }
                        //Update Order Subs Junction                        
                        if(action == label.OSM_Order_Cancellation){
                            if(mapOrderSubsUpdate.keyset() != null && mapOrderSubsUpdate.size()>0){
                                update mapOrderSubsUpdate.values();
                            }   
                        }
                        
                        //Update associated order
                        if(mapAssociatedOrderToUpdate.keyset() != null && mapAssociatedOrderToUpdate.size()>0 && orderItemCancel == false){
                            update mapAssociatedOrderToUpdate.values();
                        }
                        
                        //Update order item
                        if(maporderItemRecToUpdate.keyset() != null && maporderItemRecToUpdate.size()>0){
                            update maporderItemRecToUpdate.values();
                        }
                        
                        //Update subscription record                                    
                        if(mapSubsToUpdate.keyset() != null && mapSubsToUpdate.size()>0){                          
                            Database.SaveResult[] srList = Database.Update(mapSubsToUpdate.values(),true);
                            //If update is successfull, update response class and send next due date to DA 
                                for(Database.SaveResult dsr :srList){
                                    if(dsr.isSuccess()){
                                       // System.debug('Subscription record is successfully updated, ID: ' + dsr.getId());
                                        setUpdatedSubsRec.add(dsr.getId()); //Get the id's
                                        exceptionFlag = false;
                                    }
                                }   
                            }
                        
                        //Update account details with active susbcription check
                        Account acc = [Select id, Is_Active_Subscription_Exists__c, (Select id, ccrz__SubscriptionStatus__c from ccrz__CCSubscriptions__r) from account where id = :AccountId];
                           // system.debug('%%%%%acc'+acc);
                            //Added by Vaibhav on 10-Sep
                            OSM_SW_Transaction_Util.updateAccountFieldsForAllOperations(new List<String>{acc.id},'Order_Cancelled');
                            
                            
                            
                            //Sharad for addon product subsc cancel if bundle product cancel 12 feb 2019 Start
                            /* defect 187557
                            
                            if(action == label.OSM_Order_Cancellation){
                                if(lstSubscIdForZeroQuantity != null && lstSubscIdForZeroQuantity.size()>0){
                                    updateAddonProductSubsc(lstSubscIdForZeroQuantity);
                                }   
                            }
                            */
                            //Sharad code end
                            /*Start : Added by Vaibhav on 10-Sep
                            for(ccrz__E_Subscription__c accountSubs :acc.ccrz__CCSubscriptions__r){
                                if(accountSubs.ccrz__SubscriptionStatus__c == 'Active'){
                                    acc.Is_Active_Subscription_Exists__c = true;
                                    break;
                                }else if(accountSubs.ccrz__SubscriptionStatus__c != 'Active'){
                                    acc.Is_Active_Subscription_Exists__c = false;
                                }
                            }
                            
                            if((acc != null) && (action == label.OSM_Order_Cancellation)){
                                update acc;                            
                            }
                            //END:Added by Vaibhav on 10-Sep
                            */
                            
                        }catch(Exception e){
                           // system.debug('Exception-'+e.getMessage());                   
                            Database.rollback(sp); //set rollback
                            exceptionFlag = true;
                            //Create Integration log
                            log = new OSM_Integration_Log__c();
                            OSM_SW_LoggingContext.integrationLog = log;
                            log.Account__c = AccountId;   
                            log.Request__c = jSONRequestBody;
                            log.Service_Name__c = action;
                            log.Source__c = label.OSM_Partial_Subscription_Cancellation_Source;
                            log.Target__c = label.OSM_Partial_Subscription_Cancellation_Target;
                            log.Response__c = e.getMessage() + ' at line number ' + e.getLineNumber();
                            log.Error_Description__c = e.getStacktraceString();
                            log.Status__c = label.OSM_Subs_Cancellation_Failure;
                            log.Logged_In_User__c = userinfo.getUserId();
                            OSM_SW_LoggingContext.saveIntegrationLog(log); //Save the integration log record                        
                           // system.debug('log'+log);
                        }
                        if(exceptionFlag == false){
                            if(Boolean.valueOf(label.OSM_Success_Log) == true){ //If flag to show success log is true, then create success log, else ignore
                                //Create Integration log
                                log = new OSM_Integration_Log__c();
                                OSM_SW_LoggingContext.integrationLog = log;
                                log.Account__c = AccountId;   
                                log.Request__c = jSONRequestBody;
                                /*Will be taken up in 1B release
                                if(action == label.OSM_Partial_Subscription_Cancellation){
                                    log.Service_Name__c = action;
                                    log.Response__c = label.OSM_Subs_Cancellation_Message;
                                    log.Source__c = label.OSM_Partial_Subscription_Cancellation_Source;
                                    log.Target__c = label.OSM_Partial_Subscription_Cancellation_Target;
                                }*/
                                if(action == label.OSM_Order_Cancellation){
                                    log.Account__c = AccountId;   
                                    log.Service_Name__c = action;
                                    log.Response__c = label.OSM_Order_Cancellation_Message;
                                    log.Source__c = label.OSM_Order_Cancellation_Source;
                                    log.Target__c = label.OSM_Order_Cancellation_Target;    
                                }
                                log.Account__c = AccountId;   
                                log.Status__c = label.OSM_Subs_Cancellation_Success;
                                log.Logged_In_User__c = userinfo.getUserId();
                               // system.debug('log'+log);
                                OSM_SW_LoggingContext.saveIntegrationLog(log); //Save the integration log record
                            }                   
                        }
                       // system.debug('setUpdatedSubsRec'+setUpdatedSubsRec);
                        return setUpdatedSubsRec;   
                    
                    }//End of method
                    
                    //Sharad code start 11 Feb 2019 to make sub quantity 0 for addon product if bundle is get cancelled
                    /* defect 187557
                    public static void updateAddonProductSubsc(List<ccrz__E_Subscription__c> subscId)
                    {
                        Map<Id, List<Id>> mapAccountIdVsProductId = new Map<Id, List<Id>>();
                        List<ccrz__E_Subscription__c> lstSubscToUpdate = new List<ccrz__E_Subscription__c>();
                        //Map<Id, DateTime> mapAccountIdVsCancellationDate = new Map<Id, DateTime>();
                        for(ccrz__E_Subscription__c objSubsc : subscId)
                        {
                            //mapAccountIdVsCancellationDate.put(objSubsc.ccrz__Account__c, objSubsc.Subscription_Cancellation_Requested_Date__c);
                            if(!mapAccountIdVsProductId.containsKey(objSubsc.ccrz__Account__c))
                                mapAccountIdVsProductId.put(objSubsc.ccrz__Account__c, new List<Id>());
                            mapAccountIdVsProductId.get(objSubsc.ccrz__Account__c).add(objSubsc.ccrz__SubscriptionProduct__c);
                            
                            
                        }
                        
                        List<ccrz__E_Subscription__c> subsList = [Select id, name, ccrz__Account__c, ccrz__CCOrder__c, ccrz__CCOrderItem__c, ccrz__CurrencyISOCode__c, ccrz__Quantity__c, OSM_Subscription_End_Date__c, Next_Invoice_Generation_Date__c, ccrz__SubscriptionStatus__c, ccrz__SubscriptionProduct__c, OSM_Display_Product__c, ccrz__SubscriptionProduct__r.ccrz__ProductType__c, OSM_Subscription_Cancellation_Date__c, ccrz__Storefront__c, ccrz__SPT__c, ccrz__Sequence__c, ccrz__User__c, ccrz__SubscriptionStartDate__c, Subscription_Cancellation_Requested_Date__c from ccrz__E_Subscription__c where ccrz__Account__c IN :mapAccountIdVsProductId.keySet()];
                        
                        for(ccrz__E_Subscription__c obj : subsList)
                        {
                            if(mapAccountIdVsProductId.containsKey(obj.ccrz__Account__c) && mapAccountIdVsProductId.get(obj.ccrz__Account__c) != null && mapAccountIdVsProductId.get(obj.ccrz__Account__c).size() > 0)
                            {
                                if(mapAccountIdVsProductId.get(obj.ccrz__Account__c).contains(obj.OSM_Display_Product__c) && obj.ccrz__Quantity__c > 0 )
                                {
                                    obj.ccrz__Quantity__c = 0;
                                    obj.ccrz__SubscriptionStatus__c = label.OSM_Subs_Status_With_Zero_Quantity;
                                    lstSubscToUpdate.add(obj);
                                }
                            }
                        }
                        
                        if(lstSubscToUpdate != null && lstSubscToUpdate.size() > 0)
                        {
                            update lstSubscToUpdate;
                        }
                        
                        
                    }
                    */
                    
                    //Shard Code end
                
                
                    //This is wrapper class based on incoming cancelled subscription variables from DA
                    public class PartialSubsCancellationWrapper{
                        public string da_orderId;
                        public Integer da_quantity;
                        public string da_productId;
                    }
}