global class OSM_SW_SubscriptionRenewToActiveBatch implements Database.Batchable<sObject>, Database.Stateful{
    global List<Id> subscriptionIDSet = new List<Id>();
    global Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator([Select 
                                         id,OSM_CCSubscription__c,OSM_CCSubscription__r.Renewed_From_Subscription__r.ccrz__SubscriptionStatus__c, OSM_CCSubscription__r.ccrz__SubscriptionProduct__c,OSM_CCOrder__c,OSM_CCOrder__r.ccrz__OriginatedCart__c,CC_Order_Item__c,CC_Order_Item__r.isRenew__c,
                                         OSM_CCSubscription__r.ccrz__Quantity__c,OSM_CCSubscription__r.ccrz__Account__c,
                                         OSM_CCSubscription__r.OSM_Subscription_End_Date__c, 
                                         OSM_CCSubscription__r.ccrz__SubscriptionStatus__c 
                                         from OSM_Order_Subscription__c 
                                         where  
                                         OSM_CCSubscription__r.ccrz__SubscriptionStatus__c =: Label.OSM_Subscription_Status_Renew 
                                         and OSM_CCSubscription__r.ccrz__Quantity__c>0 
                                         and OSM_CCSubscription__r.OSM_Subscription_End_Date__c >: DateTime.now()
                                         and OSM_CCSubscription__r.ccrz__SubscriptionStartDate__c <=: DateTime.now()
                                         and OSM_CCSubscription__r.Renewed_From_Subscription__r.ccrz__SubscriptionStatus__c = 'Expired'
                                        ]);
    }
    
    global void execute(Database.BatchableContext BC, List<OSM_Order_Subscription__c> scope){ 
        
        Set<String> accIdSet = new Set<String>();
        list<ccrz__E_Subscription__c> subscriptionToActive = new List<ccrz__E_Subscription__c>();
        list<ccrz__E_OrderItem__c> orderItemToUpdate = new List<ccrz__E_OrderItem__c>();
        Map<Id,List<Id>> cartToProductMap = new Map<Id,List<Id>>();
        List<Id> subscriptionIDSet = new List<Id>();
        for(OSM_Order_Subscription__c OrderSub :scope){
            subscriptionToActive.add(new ccrz__E_Subscription__c(Id = OrderSub.OSM_CCSubscription__c,ccrz__SubscriptionStatus__c = 'Active'));
            subscriptionIDSet.add(OrderSub.OSM_CCSubscription__c);
            orderItemToUpdate.add(new ccrz__E_OrderItem__c(id = OrderSub.CC_Order_Item__c, isRenew__c = false));
            //sub.ccrz__SubscriptionStatus__c = 'Active';
            //accIdSet.add(sub.ccrz__Account__c);
            if(!cartToProductMap.containsKey(OrderSub.OSM_CCOrder__r.ccrz__OriginatedCart__c))
                cartToProductMap.put(OrderSub.OSM_CCOrder__r.ccrz__OriginatedCart__c, new List<Id>());
            cartToProductMap.get(OrderSub.OSM_CCOrder__r.ccrz__OriginatedCart__c).add(OrderSub.OSM_CCSubscription__r.ccrz__SubscriptionProduct__c);
            
        }
        
        
        List<ccrz__E_CartItem__c> lstToUpdateCartItem = new List<ccrz__E_CartItem__c>();
        if(cartToProductMap != null && cartToProductMap.keySet().size() > 0)
        {
            List<ccrz__E_CartItem__c> mapCartItem = [Select Id,isRenew__c,ccrz__Cart__c, ccrz__Product__c 
                                                     from ccrz__E_CartItem__c 
                                                     where ccrz__Cart__c IN: cartToProductMap.keySet()];
            
            for(ccrz__E_CartItem__c cartObj : mapCartItem)
            {
                if(cartToProductMap.containsKey(cartObj.ccrz__Cart__c) && cartToProductMap.get(cartObj.ccrz__Cart__c) != null && cartToProductMap.get(cartObj.ccrz__Cart__c).size() > 0 && cartToProductMap.get(cartObj.ccrz__Cart__c).contains(cartObj.ccrz__Product__c))
                {
                    
                    cartObj.isRenew__c = false;
                    lstToUpdateCartItem.add(cartObj);
                }
            }
            
        }
        
        
        
        Savepoint sp = Database.setSavepoint();
        try
        {
            if(subscriptionToActive.size()>0){
                update subscriptionToActive;
                
                List<Id> subsIdForIAM = new List<Id>();
                for(ccrz__E_Subscription__c sub : subscriptionToActive){ 
                    subsIdForIAM.add(sub.Id); 
                }
                if(subsIdForIAM.size()>0){
                    //OSM_SW_SubscriptionTriggerHandlerUtility.callIAMProvisioningBusinessLayerForInsert(subsIdForIAM,false,true);
                }
            } 
            
            
            if(orderItemToUpdate.size()>0){
                update orderItemToUpdate;
            }   
            if(lstToUpdateCartItem.size()>0){
                update lstToUpdateCartItem;
            }    
            
            //
            
        }
        Catch(Exception ex)
        {
            Database.RollBack(sp);
        }
        
        
        
    }
    
    global void finish(Database.BatchableContext BC){
        OSM_Integration_Log__c log = new OSM_Integration_Log__c();
        log.Service_Name__c='Scheduled: Subscription Renew to Activation';//+Label.OSM_Subs_Expiration;
        log.Internal_Batch_Log__c=true;
        AsyncApexJob jobstatus = [SELECT Id, Status, NumberOfErrors, JobItemsProcessed,TotalJobItems, CreatedBy.Email FROM AsyncApexJob WHERE Id =:BC.getJobId()];
        log.Status__c = jobstatus.Status;
        if(jobstatus.Status=='Completed'){
            log.Status__c = 'Processed'; 
        }else if(jobstatus.Status=='Failed'){
            log.Internal_Batch_Failure__c=true;
            log.No_of_Jobs_Failed__c=jobstatus.NumberOfErrors;
        }
        insert log;
        //OSM_SW_SubscriptionTriggerHandlerUtility.callIAMProvisioningBusinessLayerForInsert(subscriptionIDSet);
        OSM_OMS_CreateOrder_Retry_Batch retryBatch = new OSM_OMS_CreateOrder_Retry_Batch();
        Database.executeBatch(retryBatch,1);
    }   
}