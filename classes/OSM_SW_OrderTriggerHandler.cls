/************************************************************
    Name:  OSM_SW_OrderTriggerHandler
    Copyright © 2018  Cummins
    =============================================================
    =============================================================
    Purpose:                                                            
    Trigger handler for Order trigger OSM_SW_OrderTrigger.              
    =============================================================
    =============================================================
    History                                                            
    -------                                                            
    VERSION  AUTHOR            DATE              DETAIL                                
    1.0 -   Ankit S            18/04/2018     INITIAL DEVELOPMENT          

    *************************************************************/

    public class OSM_SW_OrderTriggerHandler
    {
        
        //Before Insert call
        public static void OnBeforeInsert(List<ccrz__E_Order__c> orderLst){
            
            
            
            /* list<ccrz__E_OrderItem__c> OrderItemList = new list<ccrz__E_OrderItem__c>();
             OrderItemList = [select id,ccrz__Order__r.OSM_ActivationKey_Available__c,Vertex_Tax__c,ccrz__DisplayProduct__c,ccrz__OriginalQuantity__c,ccrz__DisplayProduct__r.ccrz__ShortDesc__c,ccrz__DisplayProduct__r.name,ccrz__Product__r.name,ccrz__Quantity__c,ccrz__Price__c,ccrz__ItemTotal__c,ccrz__ExtSKU__c,ccrz__Order__c from ccrz__E_OrderItem__c where ccrz__Order__c =:orderLst[0].id];
             
            Set<String> prodName = new set<String>(); 
            prodName.add('INSITE™ Pro');
            prodName.add('INSITE™ Lite');
            prodName.add('Fleet count');
            prodName.add('Zap-IT');
            prodName.add('ZAP-IT OEM');
                  system.debug('@@@@@@'+prodName);
             for(ccrz__E_OrderItem__c orditem:OrderItemList){
                 
            // if(orditem.ccrz__DisplayProduct__r.name.contains(prodName) ){
            system.debug('%%%%%%Name'+orditem.ccrz__DisplayProduct__r.name);
                if(prodName.Contains(orditem.ccrz__DisplayProduct__r.name)){
                 orditem.ccrz__Order__r.OSM_ActivationKey_Available__c = true;
                 
                }
             }*/
            /* for(ccrz__E_TransactionPayment__c trans : [Select id,ccrz__Account__c,ccrz__Account__r.OSM_Preferred_Payment_IsBolt_PO__c ,ccrz__AccountType__c from ccrz__E_TransactionPayment__c where ccrz__CCOrder__c =:orderLst[0].id])
             {
                 system.debug('$$$$$'+trans);
                if(trans.ccrz__AccountType__c == 'po' && trans.ccrz__Account__r.OSM_Preferred_Payment_IsBolt_PO__c == false){
                    orderLst[0].ccrz__OrderStatus__c = 'In Process';
                    system.debug('@@@@@'+ trans.ccrz__AccountType__c);
                    system.debug('######'+ trans.ccrz__Account__r.OSM_Preferred_Payment_IsBolt_PO__c);
                }
                 
             }*/
             
             // Added by Ashish Goyal (MAR-1235)
            Set<Id> set_AccountId = new Set<Id>();
            for(ccrz__E_Order__c ordr : orderLst){
                if(ordr.ccrz__Account__c != null){
                    set_AccountId.add(ordr.ccrz__Account__c);
                }
            }
            if(set_AccountId.size() > 0){
                Map<Id, String> map_AccIdGroupEmail = new Map<Id, String>();
                List<IAMDistributorCodeGroupEmail__c> iamDistGrpEmail = IAMDistributorCodeGroupEmail__c.getAll().values();
                for(Account acc : [SELECT Id, CSS_DistributorCode__c FROM Account WHERE Id IN: set_AccountId]){
                    /*if(acc.CSS_DistributorCode__c != null && IAMDistributorCodeGroupEmail__c.getValues(acc.CSS_DistributorCode__c) != null){
                        IAMDistributorCodeGroupEmail__c customSetting = IAMDistributorCodeGroupEmail__c.getValues(acc.CSS_DistributorCode__c);
                        map_AccIdGroupEmail.put(acc.Id, customSetting.Group_Email__c);
                    }*/
                    for(IAMDistributorCodeGroupEmail__c setting:iamDistGrpEmail)
                    {
                      if(acc.CSS_DistributorCode__c!=null && setting.Distributor_Code__c !=null && 
                       setting.Distributor_Code__c==acc.CSS_DistributorCode__c)
                       {
                            map_AccIdGroupEmail.put(acc.Id, setting.Group_Email__c);
                       }
                    
                    }
                }
                for(ccrz__E_Order__c ordr : orderLst){
                    if(ordr.ccrz__Account__c != null && map_AccIdGroupEmail.containsKey(ordr.ccrz__Account__c)){
                        ordr.IAM_teams_group_email__c = map_AccIdGroupEmail.get(ordr.ccrz__Account__c);
                    }
                }
            }
               
        }
        
        //After Insert call
        public static void OnAfterInsert(Map<Id,ccrz__E_Order__c> newOrderMap){
            if(!System.isBatch()){
                //OSM_SW_OrderTriggerHandlerUtility.getOrderUpdate(newOrderMap.keySet()); 
            }
        }
        
        //After update call
        public static void OnAfterUpdate(Map<Id,ccrz__E_Order__c> oldOrderMap,Map<Id,ccrz__E_Order__c> newOrderMap){
            if(!System.isBatch()){
                //Logic to call DA service only if Order is cancelled
                Set<Id> orderIdSet = new Set<Id>();
                Set<Id> orderIdSet2 = new Set<Id>(); //MAR-753
                Set<Id> orderIdSetForIntercompany=new Set<Id>();
                List<ccrz__E_Order__c> orderList=new List<ccrz__E_Order__c>();
                for(Id orderId : newOrderMap.keySet())
                {
                    /* Condition !newOrderMap.get(orderId).OrderProcessedforFSD__c Added to 
                        just remove those Orders have fsd call those will be trigger from Order Cancell UI */
                        // add condition do not process cancel if license product cancel or revoke is not done.
                    if(newOrderMap.get(orderId).ccrz__OrderStatus__c!=oldOrderMap.get(orderId).ccrz__OrderStatus__c 
                       && newOrderMap.get(orderId).ccrz__OrderStatus__c=='Cancelled'
                       && !newOrderMap.get(orderId).OrderProcessedforFSD__c && newOrderMap.get(orderId).Is_OMS_Revoke_and_Cancel_Not_Done_Count__c == 0)
                    {
                        orderIdSet.add(orderId);
                    }
                    system.debug('fsd status>>>'+ newOrderMap.get(orderId).OrderProcessedforFSD__c);
                    //Code added for Intercompany order and invoice creation functionality by Sangeeta...
                    if(newOrderMap.get(orderId).OrderProcessedforFSD__c != oldOrderMap.get(orderId).OrderProcessedforFSD__c && newOrderMap.get(orderId).OrderProcessedforFSD__c ==true && newOrderMap.get(orderId).ccrz__OrderStatus__c=='Order Submitted')
                    {
                        system.debug('Inside intercompany transaction>>>>>');
                        orderIdSetForIntercompany.add(orderId);
                    }
                    
                    ccrz__E_Order__c order  = new ccrz__E_Order__c(Id = orderId); 
                    if(newOrderMap.get(orderId).OSM_SW_Order_Item_Count__c != newOrderMap.get(orderId).FW_Product_Count__c){
                        if(newOrderMap.get(orderId).AllActivationKeysGenerated__c ==oldOrderMap.get(orderId).AllActivationKeysGenerated__c && newOrderMap.get(orderId).IsGetOrderSuccess__c ==false){
                            order.Activation_Key_Failure_Mail_Sent__c=true;
                            orderList.add(order);
                        }
                        else {                            
                            order.Activation_Key_Failure_Mail_Sent__c=false;
                            orderList.add(order);
                        }
                    }
                   
            // Mar-753 -- 1171  
            if(newOrderMap.get(orderId).ccrz__OrderStatus__c!=oldOrderMap.get(orderId).ccrz__OrderStatus__c 
                       && newOrderMap.get(orderId).ccrz__OrderStatus__c=='Cancelled')
                    {
                        orderIdSet2.add(orderId);
                    }
                   
                }
                System.debug('==Calling DA Order Cancellation for OrderIds==='+orderIdSet2);
                if(orderIdSet2!=null && orderIdSet2.size()>0)
                {
                   OSM_RequestForApprovalController.UpdateRFA_OnOrderCancellation(orderIdSet2);  //Added for Mar-753
                }
                if(orderList!=null && orderList.size()>0)
                {
                  if(OSM_CheckRecursive.runOnce())
                    {
                        update orderList;
                    } 
                    
                  //OSM_SW_OrderCancellationUtility.updateRecordsOnOrderCancellation(orderIdSet);     //Call method to update sobject records
                  //OSM_SW_OrderTriggerHandlerUtility.getOrderCancel(orderIdSet);  //call order cancellation method if order is cancelled
                }
                /*//Code added for Intercompany order and invoice creation functionality by Sangeeta...
                if(OSM_CheckRecursive.runOnce())
                {
                     if(orderIdSetForIntercompany!=null && orderIdSetForIntercompany.size()>0)
                     {
                         OSM_SW_IntercompanyOrderInvoice.createIntercompnayOrderAndInvoice(orderIdSetForIntercompany);
                         //OSM_SW_OrderTriggerHandlerUtility.intercompanyProcess(orderIdSetForIntercompany);
                     }
                } */
                
            }   
        }
        
        //Before Update Call
        public static void OnBeforeUpdate(Map<Id,ccrz__E_Order__c> oldOrderMap,Map<Id,ccrz__E_Order__c> newOrderMap){
        
            if(!System.isBatch()){
                //Logic to call DA service only if Order is cancelled
                Set<Id> orderIdSet = new Set<Id>();
                for(Id orderId : newOrderMap.keySet())
                {
                    if(newOrderMap.get(orderId).ccrz__OrderStatus__c!=oldOrderMap.get(orderId).ccrz__OrderStatus__c && newOrderMap.get(orderId).ccrz__OrderStatus__c== Label.OSM_CancellationPending)
                    {
                        newOrderMap.get(orderId).Order_Cancelled_By_CSR__c = System.UserInfo.getUserId();
                        newOrderMap.get(orderId).Order_Cancellation_Date__c= System.Today();
                    }
                    
                }
              
            }
        
        }
        
/** 
 **Cancel subscription if Order is getting cancelled
 **
**/
/* sharad because this method is not used anywhere
        public static void cancellSubscription(List<ccrz__E_Order__c> newOrders, Map<Id, ccrz__E_Order__c> oldOrdersMap){
            Set<String> OrderIds = new Set<String>();
            for(ccrz__E_Order__c newOrder : newOrders){
                ccrz__E_Order__c oldOrder = oldOrdersMap.get(newOrder.Id);
                if(newOrder.ccrz__OrderStatus__c != oldOrder.ccrz__OrderStatus__c && newOrder.ccrz__OrderStatus__c == 'Cancelled'){
                    OrderIds.add(newOrder.Id);
                }
            }
            
            Set<String> accountIds = new Set<String>();
            Set<String> products = new Set<String>();
            Set<String> stores = new Set<String>();
            for(ccrz__E_OrderItem__c cancelledOrderItem : [Select ccrz__Order__c, ccrz__Product__c, ccrz__Order__r.ccrz__Account__c, ccrz__Order__r.ccrz__Storefront__c 
                                                           from ccrz__E_OrderItem__c where ccrz__Order__c IN: OrderIds]){
                                                                
                 accountIds.add(cancelledOrderItem.ccrz__Order__r.ccrz__Account__c);
                products.add(cancelledOrderItem.ccrz__Product__c);
                stores.add(cancelledOrderItem.ccrz__Order__r.ccrz__Storefront__c);
                                                               
               }
            
            for(ccrz__E_OrderItem__c OrderItem : [Select ccrz__Order__c, ccrz__Product__c, ccrz__Order__r.ccrz__Account__c, ccrz__Order__r.ccrz__Storefront__c 
                                                           from ccrz__E_OrderItem__c where ccrz__Order__r.ccrz__OrderStatus__c !=: 'Cancelled'
                                                          and ccrz__Order__r.ccrz__Account__c IN: accountIds 
                                                          and ccrz__Product__c IN: products and ccrz__Order__r.ccrz__Storefront__c IN: stores])
            {
                
                
            }
        } */
    }