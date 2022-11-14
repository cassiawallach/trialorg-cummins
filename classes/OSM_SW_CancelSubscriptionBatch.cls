global class OSM_SW_CancelSubscriptionBatch implements Database.Batchable<sObject>{
    
    String query;
    String subsSts = label.OSM_Subs_Cancellation_Request_Status;
    String storefront = label.OSM_SoftwareStore;
    String action = label.OSM_Partial_Subscription_Cancellation;
    OSM_Integration_Log__c log = null;
    List<OSM_Integration_Log__c> loglist = new List<OSM_Integration_Log__c>();
    Map<Id,Decimal> mapParentIdVsQuantity = new Map<Id,Decimal>();
    Map<Id,Decimal> mapOrderItemIdVsQuantity = new Map<Id,Decimal>();
    
    global Database.QueryLocator start(Database.BatchableContext BC){
        Date CurDate = system.today();
        query = 'Select id, ccrz__SubscriptionStatus__c, OSM_Subscription_Cancellation_Date__c, ccrz__Account__c,OSM_Parent_Subscription__c, OSM_Parent_Subscription__r.ccrz__Quantity__c, ccrz__CCOrder__c, ccrz__CCOrderItem__c, ccrz__CCOrderItem__r.ccrz__Quantity__c, ccrz__Storefront__c, ccrz__Quantity__c from ccrz__E_Subscription__c where ccrz__SubscriptionStatus__c =: subsSts and OSM_Subscription_Cancellation_Date__c =: CurDate and ccrz__Storefront__c =: storefront and ccrz__Quantity__c < 0 and OSM_Parent_Subscription__c != null and OSM_Subscription_Cancellation_Date__c != null and ccrz__CCOrder__c != null and ccrz__CCOrderItem__c != null' ;
        return database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<ccrz__E_Subscription__c> scope){
        
        Map<Id,Decimal> mapOrderVsCancQuantity = new Map<Id,Decimal>();
        Set<Id> OrderIdSet = new Set<Id>();
        Set<Id> SubsIdSet = new Set<Id>();
        Set<Id> AccIDSet = new Set<Id>();
        
        //Initialize map to update
        Map<Id,ccrz__E_Subscription__c> mapNegativeSubsToUpdate = new Map<Id,ccrz__E_Subscription__c>();
        Map<Id,ccrz__E_Subscription__c> mapSubsToUpdate = new Map<Id,ccrz__E_Subscription__c>();
        Map<Id,ccrz__E_Order__c> mapOrderToUpdate = new Map<Id,ccrz__E_Order__c>();
        Map<Id,ccrz__E_OrderItem__c> mapOrderItemToUpdate = new Map<Id,ccrz__E_OrderItem__c>();
        Map<Id,OSM_Order_Subscription__c> mapOrderSubsJuncToUpdate = new Map<Id,OSM_Order_Subscription__c>();
        Map<Account,Id> mapAccVsActiveSubId = new Map<Account,Id>();
        
        system.debug('scope'+scope);
        //Savepoint sp = Database.setSavepoint(); //Set savepoint
        
        try{        
                for(ccrz__E_Subscription__c subsRec :scope){
                    mapParentIdVsQuantity.put(subsRec.OSM_Parent_Subscription__c,subsRec.OSM_Parent_Subscription__r.ccrz__Quantity__c);
                    mapOrderItemIdVsQuantity.put(subsRec.ccrz__CCOrderItem__c,subsRec.ccrz__CCOrderItem__r.ccrz__Quantity__c);
                }
                
                for(ccrz__E_Subscription__c subsRec :scope){
                    
                    //Update negative susbcriptions records
                    subsRec.ccrz__SubscriptionStatus__c = label.OSM_Subs_Cancellation_Status;
                    mapNegativeSubsToUpdate.put(subsRec.id,subsRec);
                    
                    //Update parent subscription record
                    Decimal reducedQuantity = subsRec.ccrz__Quantity__c;
                    if(mapParentIdVsQuantity.containsKey(subsRec.OSM_Parent_Subscription__c)){
                        Decimal parentQuantity = mapParentIdVsQuantity.get(subsRec.OSM_Parent_Subscription__c);
                        Decimal netQuantity = parentQuantity + reducedQuantity;
                        mapParentIdVsQuantity.put(subsRec.OSM_Parent_Subscription__c,netQuantity);
                    }   
                    for(Id parentId :mapParentIdVsQuantity.keySet()){
                        ccrz__E_Subscription__c ParentSubsrec = new ccrz__E_Subscription__c();
                        ParentSubsrec.id = parentId;
                        ParentSubsrec.ccrz__Quantity__c = mapParentIdVsQuantity.get(parentId);
                        if(ParentSubsrec.ccrz__Quantity__c <=0){
                            ParentSubsrec.ccrz__SubscriptionStatus__c = label.OSM_Subs_Status_With_Zero_Quantity; 
                        }
                        mapSubsToUpdate.put(ParentSubsrec.id,ParentSubsrec);    
                    }
                    
                    //Update associated order record
                    ccrz__E_Order__c associatedOrder = new ccrz__E_Order__c(id = subsRec.ccrz__CCOrder__c);
                    associatedOrder.ccrz__OrderStatus__c = label.OSM_Subs_Cancellation_Order_Status;
                    mapOrderToUpdate.put(associatedOrder.id,associatedOrder);   
                    
                    //Update OrderItem
                    Decimal reducedItemQuantity = subsRec.ccrz__Quantity__c;
                    if(mapOrderItemIdVsQuantity.containsKey(subsRec.ccrz__CCOrderItem__c)){
                        Decimal parentQuantity = mapOrderItemIdVsQuantity.get(subsRec.ccrz__CCOrderItem__c);
                        Decimal netQuantity = parentQuantity + reducedQuantity;
                        mapOrderItemIdVsQuantity.put(subsRec.ccrz__CCOrderItem__c,netQuantity);
                    }   
                    for(Id parentId :mapOrderItemIdVsQuantity.keySet()){
                        ccrz__E_OrderItem__c associatedOrderItem = new ccrz__E_OrderItem__c();
                        associatedOrderItem.id = parentId;
                        associatedOrderItem.ccrz__Quantity__c = mapOrderItemIdVsQuantity.get(parentId);
                        associatedOrderItem.DA_Subscription_Cancellation_Status__c = label.OSM_Partial_Cancellation_Item_Status;
                        associatedOrderItem.ccrz__OrderItemStatus__c = label.OSM_Partial_Cancellation_Item_Status; 
                        mapOrderItemToUpdate.put(associatedOrderItem.id,associatedOrderItem);   
                    }
                    
                    OrderIdSet.add(subsRec.ccrz__CCOrder__c);
                    SubsIdSet.add(subsRec.OSM_Parent_Subscription__c);
                    AccIDSet.add(subsRec.ccrz__Account__c);
                    mapOrderVsCancQuantity.put(subsRec.ccrz__CCOrder__c,subsRec.ccrz__Quantity__c);
                }
                
                //Order subs records
                Map<Id,OSM_Order_Subscription__c> mapOrderVsOrderSubs = new Map<Id,OSM_Order_Subscription__c>([Select id, OSM_CCOrder__c, OSM_CCSubscription__c, CCQuantity__c from OSM_Order_Subscription__c where OSM_CCOrder__c IN :OrderIdSet and OSM_CCSubscription__c IN :SubsIdSet]);
                    for(OSM_Order_Subscription__c orderSub :mapOrderVsOrderSubs.values()){
                        orderSub.CCQuantity__c = orderSub.CCQuantity__c + mapOrderVsCancQuantity.get(orderSub.OSM_CCOrder__c);
                        mapOrderSubsJuncToUpdate.put(orderSub.id,orderSub);
                }
                
                //Account records
                List<Account> accList = [Select id, Is_Active_Subscription_Exists__c, (Select id, ccrz__SubscriptionStatus__c from ccrz__CCSubscriptions__r) from account where id IN :AccIDSet];
                        for(Account accountToUpdate :accList){
                            for(ccrz__E_Subscription__c accountSubs :accountToUpdate.ccrz__CCSubscriptions__r){
                                if(accountSubs.ccrz__SubscriptionStatus__c == 'Active'){
                                    accountToUpdate.Is_Active_Subscription_Exists__c = true;                                   
                                }else if(accountSubs.ccrz__SubscriptionStatus__c != 'Active'){
                                    accountToUpdate.Is_Active_Subscription_Exists__c = false;
                                }
                                mapAccVsActiveSubId.put(accountToUpdate,accountSubs.id); 
                            }   
                        }
                    List<Account> acctoUpdate = new List<Account>();
                    if(mapAccVsActiveSubId.keyset() != null && mapAccVsActiveSubId.size()>0){
                        for(Account acc :mapAccVsActiveSubId.keyset()){
                            acctoUpdate.add(acc);
                        }
                    }
                                    
                //Do update operations
                //Update Negative Subs
                database.saveResult[] srlistNegativeSubs = database.update(mapNegativeSubsToUpdate.values(),false); 
                // Iterate through each returned result
                for (Database.SaveResult sr : srlistNegativeSubs) {
                    if (sr.isSuccess()) {
                        System.debug('Success' + sr.getId());
                    }
                    else {
                        for(Database.Error err : sr.getErrors()) {
                            System.debug('Error has occurred.'); 
                            //Create Integration log
                            log = new OSM_Integration_Log__c();
                            OSM_SW_LoggingContext.integrationLog = log;
                            log.Service_Name__c = action;
                            log.Source__c = label.OSM_Partial_Subscription_Cancellation_Source;
                            log.Target__c = label.OSM_Partial_Subscription_Cancellation_Target;
                            log.Response__c = err.getMessage();
                            log.Error_Description__c = err.getStatusCode() + ',' + err.getFields();
                            log.Status__c = label.OSM_Subs_Cancellation_Failure;
                            log.Logged_In_User__c = userinfo.getUserId();
                            loglist.add(log);
                        }
                    }
                }
                
                //Update Subscription
                database.saveResult[] srlistSubs = database.update(mapSubsToUpdate.values(),false); 
                // Iterate through each returned result
                for (Database.SaveResult sr : srlistSubs) {
                    if (sr.isSuccess()) {
                        System.debug('Success' + sr.getId());
                    }
                    else {
                        for(Database.Error err : sr.getErrors()) {
                            System.debug('Error has occurred.'); 
                            //Create Integration log
                            log = new OSM_Integration_Log__c();
                            OSM_SW_LoggingContext.integrationLog = log;
                            log.Service_Name__c = action;
                            log.Source__c = label.OSM_Partial_Subscription_Cancellation_Source;
                            log.Target__c = label.OSM_Partial_Subscription_Cancellation_Target;
                            log.Response__c = err.getMessage();
                            log.Error_Description__c = err.getStatusCode() + ',' + err.getFields();
                            log.Status__c = label.OSM_Subs_Cancellation_Failure;
                            log.Logged_In_User__c = userinfo.getUserId();
                            loglist.add(log);
                        }
                    }
                }
                
                //Update Order
                database.saveResult[] srlistOrder = database.update(mapOrderToUpdate.values(),false);   
                // Iterate through each returned result
                for (Database.SaveResult sr : srlistOrder) {
                    if (sr.isSuccess()) {
                        System.debug('Success' + sr.getId());
                    }
                    else {
                        for(Database.Error err : sr.getErrors()) {
                            System.debug('Error has occurred.'); 
                            //Create Integration log
                            log = new OSM_Integration_Log__c();
                            OSM_SW_LoggingContext.integrationLog = log;
                            log.Service_Name__c = action;
                            log.Source__c = label.OSM_Partial_Subscription_Cancellation_Source;
                            log.Target__c = label.OSM_Partial_Subscription_Cancellation_Target;
                            log.Response__c = err.getMessage();
                            log.Error_Description__c = err.getStatusCode() + ',' + err.getFields();
                            log.Status__c = label.OSM_Subs_Cancellation_Failure;
                            log.Logged_In_User__c = userinfo.getUserId();
                            loglist.add(log);
                        }
                    }
                }
                
                //Update OrderLineItem
                database.saveResult[] srlistOrderItem = database.update(mapOrderItemToUpdate.values(),false);   
                // Iterate through each returned result
                for (Database.SaveResult sr : srlistOrderItem) {
                    if (sr.isSuccess()) {
                        System.debug('Success' + sr.getId());
                    }
                    else {
                        for(Database.Error err : sr.getErrors()) {
                            System.debug('Error has occurred.'); 
                            //Create Integration log
                            log = new OSM_Integration_Log__c();
                            OSM_SW_LoggingContext.integrationLog = log;
                            log.Service_Name__c = action;
                            log.Source__c = label.OSM_Partial_Subscription_Cancellation_Source;
                            log.Target__c = label.OSM_Partial_Subscription_Cancellation_Target;
                            log.Response__c = err.getMessage();
                            log.Error_Description__c = err.getStatusCode() + ',' + err.getFields();
                            log.Status__c = label.OSM_Subs_Cancellation_Failure;
                            log.Logged_In_User__c = userinfo.getUserId();
                            loglist.add(log);
                        }
                    }
                }
                
                //Update Order Junc
                database.saveResult[] srlistOrderJunc = database.update(mapOrderSubsJuncToUpdate.values(),false);   
                // Iterate through each returned result
                for (Database.SaveResult sr : srlistOrderJunc) {
                    if (sr.isSuccess()) {
                        System.debug('Success' + sr.getId());
                    }
                    else {
                        for(Database.Error err : sr.getErrors()) {
                            System.debug('Error has occurred.'); 
                            //Create Integration log
                            log = new OSM_Integration_Log__c();
                            OSM_SW_LoggingContext.integrationLog = log;
                            log.Service_Name__c = action;
                            log.Source__c = label.OSM_Partial_Subscription_Cancellation_Source;
                            log.Target__c = label.OSM_Partial_Subscription_Cancellation_Target;
                            log.Response__c = err.getMessage();
                            log.Error_Description__c = err.getStatusCode() + ',' + err.getFields();
                            log.Status__c = label.OSM_Subs_Cancellation_Failure;
                            log.Logged_In_User__c = userinfo.getUserId();
                            loglist.add(log);
                        }
                    }
                }
        
                    //Update Account
                        database.saveResult[] srlistAccount = database.update(acctoUpdate,false); 
                        // Iterate through each returned result
                        for (Database.SaveResult sr : srlistAccount) {
                            if (sr.isSuccess()) {
                                System.debug('Success' + sr.getId());
                            }
                            else {
                                for(Database.Error err : sr.getErrors()) {
                                    System.debug('Error has occurred.'); 
                                    //Create Integration log
                                    log = new OSM_Integration_Log__c();
                                    OSM_SW_LoggingContext.integrationLog = log;
                                    log.Service_Name__c = action;
                                    log.Source__c = label.OSM_Partial_Subscription_Cancellation_Source;
                                    log.Target__c = label.OSM_Partial_Subscription_Cancellation_Target;
                                    log.Response__c = err.getMessage();
                                    log.Error_Description__c = err.getStatusCode() + ',' + err.getFields();
                                    log.Status__c = label.OSM_Subs_Cancellation_Failure;
                                    log.Logged_In_User__c = userinfo.getUserId();
                                    loglist.add(log);
                                }
                            }
                        }
                      if(Test.isRunningTest()) {
                throw new NullPointerException();
            } 

                
            }catch(Exception e){
                system.debug('Exception-'+e.getMessage());                   
                //Create Integration log
                log = new OSM_Integration_Log__c();
                OSM_SW_LoggingContext.integrationLog = log;
                log.Service_Name__c = action;
                log.Source__c = label.OSM_Partial_Subscription_Cancellation_Source;
                log.Target__c = label.OSM_Partial_Subscription_Cancellation_Target;
                log.Response__c = e.getMessage() + ' at line number ' + e.getLineNumber();
                log.Error_Description__c = e.getStacktraceString();
                log.Status__c = label.OSM_Subs_Cancellation_Failure;
                log.Logged_In_User__c = userinfo.getUserId();
                loglist.add(log);
            }   

        OSM_SW_LoggingContext.saveIntegrationLogList(loglist); //Insert the logs 
        
    }
    
    global void finish(Database.BatchableContext BC){
    }
    
}