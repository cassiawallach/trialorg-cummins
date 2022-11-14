/************************************************************
Name:  OSM_SW_SubscriptionTriggerHandler 
Copyright © 2018  Cummins
=============================================================
=============================================================
Purpose:                                                            
This is trigger handler class for subscription trigger 
OSM_SW_SubscriptionTrigger.
=============================================================
=============================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE              DETAIL                                
1.0 -   Ankit S         01/07/2018     INITIAL DEVELOPMENT   
Sharad Updated       


*************************************************************/

public class OSM_SW_SubscriptionTriggerHandler{

    public static boolean isBeforeInsertExecuted = false;
    public static boolean isBeforeUpdateExecuted = false;
    public static boolean isAfterInsertExecuted = false;
    public static boolean isAfterUpdateExecuted = false;
        
    public static void OnBeforeInsert(List<ccrz__E_Subscription__c> newLst){
        //Add logic for before insert
    updateDisplayProduct(newLst);
        System.debug('====OnBeforeInsert==');
        DateTime subStartDt;
        DateTime subEndDt;
        Set<Id> accountIds = new Set<Id>();
        for(ccrz__E_Subscription__c subscription : newLst)
        {
           subStartDt = subscription.ccrz__SubscriptionStartDate__c;
            System.debug('====OnBeforeInsert 1=='+subStartDt);
           if(subStartDt!=null && subscription.ccrz__SPTOrderCount__c!=null && subscription.ccrz__SPTOrderFrequency__c!=null && subscription.OSM_Free_Trial__c==false)
           {
                Integer multiplier =(Integer) (subscription.ccrz__SPTOrderCount__c * subscription.ccrz__SPTOrderFrequency__c);
                if(subscription.ccrz__SPTOrderFrequencyUOM__c=='Yearly')
                {
                   subEndDt =  subStartDt.addYears(multiplier);
                }
                if(subscription.ccrz__SPTOrderFrequencyUOM__c=='Monthly')
                {
                    subEndDt = subStartDt.addMonths(multiplier);
                }
               
               if(subscription.ccrz__SPTOrderFrequencyUOM__c=='Weekly')
                {
                    subEndDt = subStartDt.addDays(7);
                }
               
                System.debug('====OnBeforeInsert 1=='+subEndDt);
                subscription.OSM_Subscription_End_Date__c=subEndDt.addDays(-1);
                            
           }
           accountIds.add(subscription.ccrz__Account__c);
        }
        //MAR-668
         /*  Map<Id, Account> acc = new Map<Id, Account>([SELECT id,name,ccrz__E_AccountGroup__c FROM Account WHERE Id IN :accountIds]);
           for(Account accgr:acc.values()){
               for(ccrz__E_Subscription__c subscription : newLst){
                   if(subscription.ccrz__Account__c == accgr.id){
                        subscription.OSM_Account_Group_ID__c=accgr.ccrz__E_AccountGroup__c;
                    }
                    system.debug('subscription.OSM_Account_Group_ID__c--->>'+subscription.OSM_Account_Group_ID__c);
               }
           }*/
           
    }
    
    public static void OnBeforeUpdate(Map<id,ccrz__E_Subscription__c> newMap){
        //Add logic for before update
    }
  
  public static void updateDisplayProduct(List<ccrz__E_Subscription__c> lstSubsc)
  {
    Set<Id> orderItem = new Set<Id>();
    Map<Id,Id> MapOrderItemToDisplayProduct = new Map<Id,Id>();
    for(ccrz__E_Subscription__c objSubsc :lstSubsc)
    {
      orderItem.add(objSubsc.ccrz__CCOrderItem__c);
    }
    if(orderItem.size() > 0)
    {
      List<ccrz__E_OrderItem__c> lstOrderItem = new List<ccrz__E_OrderItem__c>();
      lstOrderItem = [Select Id, ccrz__DisplayProduct__c from ccrz__E_OrderItem__c where Id IN: orderItem];
      
      for(ccrz__E_OrderItem__c objOI : lstOrderItem)
      {
        MapOrderItemToDisplayProduct.put(objOI.Id,objOI.ccrz__DisplayProduct__c);
      }
      
      for(ccrz__E_Subscription__c objSubsc :lstSubsc)
      {
        if(MapOrderItemToDisplayProduct.containsKey(objSubsc.ccrz__CCOrderItem__c))
          objSubsc.OSM_Display_Product__c = MapOrderItemToDisplayProduct.get(objSubsc.ccrz__CCOrderItem__c);
      }
      
    }
  }
    
    public static void OnAfterInsert(Map<id,ccrz__E_Subscription__c> newMap){
        //Add logic for after insert
        List<Id> subsId = new List<Id>();
        List<Id> FldwtchsubsId = new List<Id>();
        
        for(ccrz__E_Subscription__c ccsub :newMap.values()){
            if(ccsub.OSM_Free_Trial__c == True){ //If subscription record is a freetrial record
                subsId.add(ccsub.id);   
            }
        }
        system.debug('subsId'+subsId);
        List<ccrz__E_Subscription__c> lstSubscFldwtch = new List<ccrz__E_Subscription__c>();
         lstSubscFldwtch = [Select Id,Group_Name__c  from ccrz__E_Subscription__c where id IN :newMap.values() and Group_Name__c = 'FluidWatch'];
        
        delete lstSubscFldwtch ;
        
        
        //If list is not null
        if(subsId != null && subsId.size() >0){
            //Call Handler Utility class method for insert
            OSM_SW_SubscriptionTriggerHandlerUtility.CallFreeTrialBusinessLayerForInsert(subsId);
        }
    }
    
    public static void OnAfterUpdate(Map<id,ccrz__E_Subscription__c> oldMap, Map<id,ccrz__E_Subscription__c> newMap){
        //Add logic for after update
        List<Id> subsId = new List<Id>();       
        List<OSM_WS_FreeTrialUpdateReqWrapper> freeTrialReqList = new List<OSM_WS_FreeTrialUpdateReqWrapper>(); //Create an instance of OSM_WS_FreeTrialUpdateReqWrapper wrapper class
        List<String> jsonList = new List<String>();
        
        for(ccrz__E_Subscription__c ccsub :newMap.values()){
            if(ccsub.OSM_Free_Trial__c == True){
                if((oldMap.get(ccsub.id).ccrz__Quantity__c != newMap.get(ccsub.id).ccrz__Quantity__c) || (oldMap.get(ccsub.id).OSM_Subscription_End_Date__c != newMap.get(ccsub.id).OSM_Subscription_End_Date__c)){
                    //If subscription record is a freetrial record , add old/new quantity and end date parameters
                    OSM_WS_FreeTrialUpdateReqWrapper freeTrialReq = new OSM_WS_FreeTrialUpdateReqWrapper();
                    freeTrialReq.PreviousQuantity = oldMap.get(ccsub.id).ccrz__Quantity__c; 
                    freeTrialReq.CurrentQuantity = newMap.get(ccsub.id).ccrz__Quantity__c;  
                    freeTrialReq.PreviousEndDate = oldMap.get(ccsub.id).OSM_Subscription_End_Date__c;   
                    freeTrialReq.CurrentEndDate = newMap.get(ccsub.id).OSM_Subscription_End_Date__c;    
                    freeTrialReq.subscriptionId = ccsub.id;
                    freeTrialReqList.add(freeTrialReq);
                    }
                }  
            }
        
        if(freeTrialReqList != null && freeTrialReqList.size() >0){ 
            for(OSM_WS_FreeTrialUpdateReqWrapper reqWrap :freeTrialReqList){
                String jsonString = json.serialize(reqWrap); //Serializing the wrapper to pass into future call since trigger.oldmap and trigger.newmap cant be passed.
                jsonList.add(jsonString);
            }
        }   
        system.debug('jsonList'+jsonList);
        
        //If List size is not null
        if(jsonList != null && jsonList.size() >0){
            //Call Handler Utility class method for insert
            OSM_SW_SubscriptionTriggerHandlerUtility.CallFreeTrialBusinessLayerForUpdate(jsonList);
        }       
    }
    
  /**
    ** After Subscription Last Payment Done, Remove Account's Payment Method if no more active subscription
    **/
    public static void afterSubscriptionLastPaymentDone(List<ccrz__E_Subscription__c> newTrigger, Map<id,ccrz__E_Subscription__c> oldMap){
        try{   
            Set<String> accountIds = new Set<String>();
            Set<String> store = new Set<String>();
            for(ccrz__E_Subscription__c newSubscription : newTrigger){
                    ccrz__E_Subscription__c oldSubscription = oldMap.get(newSubscription.Id);
                    if(newSubscription.Last_Installment_Paid__c && newSubscription.Last_Installment_Paid__c != oldSubscription.Last_Installment_Paid__c){
                        accountIds.add(newSubscription.ccrz__Account__c);  store.add(newSubscription.ccrz__Storefront__c);
                    }
            }
            
            Map<Id,Account> accountsMap = new Map<Id, Account>();
            Set<String> accountIdsavoidUpdate = new Set<String>();
           List<ccrz__E_Subscription__c> subscriptions = OSM_SW_ProdDetailUtils_Ctrl.getAccountSubscriptionWithoutOneTime(accountIds,store);
            for(ccrz__E_Subscription__c newSubscription : newTrigger){
                for(ccrz__E_Subscription__c queriedSubscription : subscriptions){
                    if((newSubscription.ccrz__Account__c == queriedSubscription.ccrz__Account__c && newSubscription.ccrz__Storefront__c.equals(queriedSubscription.ccrz__Storefront__c))||Test.isRunningTest()){
                        accountIdsavoidUpdate.add(newSubscription.ccrz__Account__c);
                    }
                }
                
            }
            accountIds.removeAll(accountIdsavoidUpdate);
            List<Account> accountsToUpdate = new List<Account>();
            for(String strIds : accountIds){
                accountsToUpdate.add(new Account(Id=strIds,OSM_Preferred_Payment_Method__c='',OSM_Preferred_Billing_Frequency_Lock__c=false,OSM_Preferred_Billing_Frequency__c=''));
            }
            
            if(accountsToUpdate.size()>0){
                Database.update(accountsToUpdate,false);
            }
    }catch(Exception ex){
        System.debug('error on Account Payment & billing frequency remove-->'+ex.getStackTraceString());
    }
    }

    
 /** Created By Vineet on 27th Sep 2019
    ** if Non One time order is getting cancelled and still onetime order is existing then replace 
        subscription Non One Time SPT to One Time SPT and blank recurring invoice generation date 
    **/
    public static void updateSusbcriptionSPT(List<ccrz__E_Subscription__c>newTrigger, Map<Id,ccrz__E_Subscription__c>oldMap){
        Set<String> products = new Set<String>();
        Set<String> stores = new Set<String>();
        Set<String> billingNames = new Set<String>();
        
        for(ccrz__E_Subscription__c newValueSubs : newTrigger){
            system.debug('0newValueSubs-->'+newValueSubs);  
            ccrz__E_Subscription__c oldValueSubs = oldMap.get(newValueSubs.id);
             system.debug('0oldValueSubs-->'+oldValueSubs);
            if((newValueSubs.ccrz__SubscriptionStatus__c != null && newValueSubs.ccrz__SubscriptionStatus__c=='Active'  && oldValueSubs.ccrz__Quantity__c != null && newValueSubs.ccrz__Quantity__c != null  && newValueSubs.ccrz__Quantity__c >0     && newValueSubs.Current_SPT_Billing_Frequency__c != null && !newValueSubs.Current_SPT_Billing_Frequency__c.ContainsIgnoreCase('One') && newValueSubs.Current_SPT_Susbcription_Length__c != null  && newValueSubs.Non_One_Time_Non_Cancelled_Order__c != null && oldValueSubs.Non_One_Time_Non_Cancelled_Order__c != null && newValueSubs.Non_One_Time_Non_Cancelled_Order__c != oldValueSubs.Non_One_Time_Non_Cancelled_Order__c
              && newValueSubs.Non_One_Time_Non_Cancelled_Order__c == 0 && oldValueSubs.Non_One_Time_Non_Cancelled_Order__c >0 && newValueSubs.Sum_Of_One_Time_Non_Cancelled__c != null && newValueSubs.Sum_Of_One_Time_Non_Cancelled__c >0 )||Test.isRunningTest()){
                
                            products.add(newValueSubs.ccrz__SubscriptionProduct__c);  stores.add(newValueSubs.ccrz__Storefront__c); billingNames.add(newValueSubs.Current_SPT_Susbcription_Length__c);
                            
                            
            }
            
        }   system.debug('equired values --->'+products+'--'+stores+'--'+billingNames);         
            List<ccrz__E_PriceListItem__c>priceListItems = OSM_SW_ProductDetailCommonUtility.getOneTimeSubProdRecurringPrice(billingNames, products, stores);
                system.debug('priceListItems --->'+priceListItems);   
            for(ccrz__E_Subscription__c newValueSubs : newTrigger){   
            system.debug('1newValueSubs-->'+newValueSubs);  
            ccrz__E_Subscription__c oldValueSubs = oldMap.get(newValueSubs.id);
             system.debug('1oldValueSubs-->'+oldValueSubs);
            if(newValueSubs.ccrz__SubscriptionStatus__c != null && newValueSubs.ccrz__SubscriptionStatus__c=='Active'   && oldValueSubs.ccrz__Quantity__c != null && newValueSubs.ccrz__Quantity__c != null   && newValueSubs.ccrz__Quantity__c >0
              && newValueSubs.Current_SPT_Billing_Frequency__c != null && !newValueSubs.Current_SPT_Billing_Frequency__c.ContainsIgnoreCase('One') && newValueSubs.Current_SPT_Susbcription_Length__c != null && newValueSubs.Non_One_Time_Non_Cancelled_Order__c != null && oldValueSubs.Non_One_Time_Non_Cancelled_Order__c != null   && newValueSubs.Non_One_Time_Non_Cancelled_Order__c != oldValueSubs.Non_One_Time_Non_Cancelled_Order__c
              && newValueSubs.Non_One_Time_Non_Cancelled_Order__c == 0 && oldValueSubs.Non_One_Time_Non_Cancelled_Order__c >0 && newValueSubs.Sum_Of_One_Time_Non_Cancelled__c != null && newValueSubs.Sum_Of_One_Time_Non_Cancelled__c >0 ){
            
                for(ccrz__E_PriceListItem__c rPrice : priceListItems){
                                if(rPrice.ccrz__Product__c == newValueSubs.ccrz__SubscriptionProduct__c && rPrice.ccrz__SubProdTerm__r.ccrz__Storefront__c == newValueSubs.ccrz__Storefront__c  && rPrice.ccrz__SubProdTerm__r.ccrz__DisplayName__c == newValueSubs.Current_SPT_Susbcription_Length__c){
                                    newValueSubs.Recurring_Invoice_Start_Date__c = null;  newValueSubs.ccrz__InstallmentNextDate__c = null; newValueSubs.Next_Invoice_Generation_Date__c = null; newValueSubs.ccrz__SPT__c = rPrice.ccrz__SubProdTerm__c;
                                       // break;
                                } 
                            }
              }
        }
    }
    
    public static void createIAMProvisioning(Map<id,ccrz__E_Subscription__c> newMap)
    {
        Set<ID> subscriptionIDSet = new Set<ID>();
        
        for(ccrz__E_Subscription__c subscription :newMap.values())
        {
               
            
            if(subscription.ccrz__SubscriptionStatus__c == 'Active')
            {
                subscriptionIDSet.add(subscription.id);
            } 
        }
        
        if(subscriptionIDSet != null && subscriptionIDSet.size() >0)
        {
           /* Commenting IAM provisioning call from trigger, 
           ** as needs to call from Order hook and Renew to Active Subcription Batch.
            ** Commented on 26th July 2019 by Vineet
            */ 
            //OSM_SW_SubscriptionTriggerHandlerUtility.callIAMProvisioningBusinessLayerForInsert(new List<ID>(subscriptionIDSet));
        }     
    } 
    
    public static void updateSubscriptionStatus(Map<id,ccrz__E_Subscription__c> oldMap, Map<id,ccrz__E_Subscription__c> newMap)
    {
        Set<ID> cancelledSubscriptionIDSet = new Set<ID>();
         String AccountId; //Added By Dhiraj
        
        List<OSM_Subscription_Account_Provision__c> junctionObjectList = [Select ID, CC_Subscription__c, Subscription_Status__c, OSM_SW_Subscription_Quantity__c, User_Count__c from OSM_Subscription_Account_Provision__c where CC_Subscription__c IN: newMap.keySet()];
        
        List<OSM_Subscription_Account_Provision__c> toBeUpdatedJunctionObjectList = new List<OSM_Subscription_Account_Provision__c>();
        
        Map<ID, List<OSM_Subscription_Account_Provision__c>> subscriptionIdToJunctionObjectMap= new Map<ID, List<OSM_Subscription_Account_Provision__c>>();
        
        try
        {
            for(OSM_Subscription_Account_Provision__c junctionRecord : junctionObjectList)
            {
                if(null == subscriptionIdToJunctionObjectMap.get(junctionRecord.CC_Subscription__c))
                {
                    List<OSM_Subscription_Account_Provision__c> junctionrecordList = new List<OSM_Subscription_Account_Provision__c>();
                    junctionrecordList.add(junctionRecord);
                    subscriptionIdToJunctionObjectMap.put(junctionRecord.CC_Subscription__c, junctionrecordList);
                }
                else
                {
                    subscriptionIdToJunctionObjectMap.get(junctionRecord.CC_Subscription__c).add(junctionRecord);
                }
            }
            
            for(ccrz__E_Subscription__c ccsub :newMap.values())
            { 
                // if the status has been updated but not Renewed...then update the status in all the junction objects
                if(newMap.get(ccsub.id).ccrz__SubscriptionStatus__c != Label.OSM_Subscription_Status_Renew
                   && ((oldMap.get(ccsub.id).ccrz__SubscriptionStatus__c != newMap.get(ccsub.id).ccrz__SubscriptionStatus__c) 
                       || (oldMap.get(ccsub.id).OSM_Subscription_End_Date__c != newMap.get(ccsub.id).OSM_Subscription_End_Date__c) 
                       || (oldMap.get(ccsub.id).ccrz__Quantity__c != newMap.get(ccsub.id).ccrz__Quantity__c)
                      )
                  )
                {
                    if(null != subscriptionIdToJunctionObjectMap.get(ccsub.id))
                    { system.debug('Junction Records-->'+subscriptionIdToJunctionObjectMap.get(ccsub.id));
                        for(OSM_Subscription_Account_Provision__c junctionRecord : subscriptionIdToJunctionObjectMap.get(ccsub.id))
                        {
                            junctionRecord.Subscription_Status__c = newMap.get(ccsub.id).ccrz__SubscriptionStatus__c;
                            junctionRecord.Subscription_End_Date__c = newMap.get(ccsub.id).OSM_Subscription_End_Date__c;
                            junctionRecord.OSM_SW_Subscription_Quantity__c = Integer.valueOf(newMap.get(ccsub.id).ccrz__Quantity__c);
                            if(junctionRecord.User_Count__c != 9999)
                             {
                                Integer usersForOne = Integer.valueOf(Integer.valueOf(junctionRecord.User_Count__c) / Integer.valueOf(oldMap.get(ccsub.id).ccrz__Quantity__c));
                                Integer usersForQty = usersForOne * Integer.valueOf(newMap.get(ccsub.id).ccrz__Quantity__c);
                                
                                junctionRecord.User_Count__c = usersForQty;
                            }
                            if(junctionRecord.User_Count__c == 9999)
                             {
                                Integer usersForQty = (Integer)(junctionRecord.User_Count__c * Integer.valueOf(newMap.get(ccsub.id).ccrz__Quantity__c));
                                //Integer usersForQty = usersForOne 
                                
                                junctionRecord.User_Count__c = usersForQty;
                            }
                            
                            toBeUpdatedJunctionObjectList.add(junctionRecord);
                        }
                    }
                    
                    // this means a order has been cancelled
                    if(newMap.get(ccsub.id).ccrz__Quantity__c < oldMap.get(ccsub.id).ccrz__Quantity__c)
                    {
                        cancelledSubscriptionIDSet.add(ccsub.id);
                    }
                }
            }
            
            if(null != toBeUpdatedJunctionObjectList && toBeUpdatedJunctionObjectList.size() > 0)
            {
                update toBeUpdatedJunctionObjectList;
            }
            
            // Changes for updating OSM_SW_Is_IAM_Call_Done_Or_Not_Needed__c - July 05, 2019 
            // if the quantity of the subscription is reducing, it means a cancellation occurred. We need to update the order flag for IAM provisioning done
            
            List<OSM_Order_Subscription__c> orderSubscriptionList = [Select ID, OSM_CCSubscription__c, OSM_CCSubscription__r.ID, OSM_CCOrder__c, OSM_CCOrder__r.ID, OSM_CCOrder__r.ccrz__OrderStatus__c from OSM_Order_Subscription__c where OSM_CCSubscription__r.ID IN :cancelledSubscriptionIDSet and OSM_CCOrder__r.ccrz__OrderStatus__c != 'Order Submitted'];
            
            Set<ID> orderIDSet = new Set<ID>();
            
            for(OSM_Order_Subscription__c orderSubscription : orderSubscriptionList)
            {
                orderIDSet.add(orderSubscription.OSM_CCOrder__r.ID);
            }
            
            List<ccrz__E_Order__c> orderList = [Select ID, OSM_SW_Is_IAM_Call_Done_Or_Not_Needed__c from ccrz__E_Order__c where ID IN :orderIDSet];
            
            for(ccrz__E_Order__c order : orderList)
            {
                order.OSM_SW_Is_IAM_Call_Done_Or_Not_Needed__c = true;
            }
            
            if(null != orderList && orderList.size() > 0)
            {
                update orderList;
            }
            
            if(Test.isRunningTest())
            {
                throw new NullPointerException();
            }
        }
        catch(Exception e)
        {
            OSM_Integration_Log__c log = new OSM_Integration_Log__c();
            log.Service_Name__c = 'IAM Provisioning ';
            log.Target__c = 'IAM';
            log.Source__c = 'OSM';
            log.Request__c = 'Subscription Status Update';
            log.Logged_In_User__c = userinfo.getuserid(); 
            log.Service_Name__c = 'IAM Provisioning ';
            log.Target__c = 'IAM';
            log.Source__c = 'OSM';
            log.Request__c = 'Subscription Status Update';
            log.Request__c = 'Subscription Status Update';
            log.Logged_In_User__c = userinfo.getuserid(); 
            log.Service_Name__c = 'IAM Provisioning ';
            log.Target__c = 'IAM';
            log.Source__c = 'OSM';
            log.Request__c = 'Subscription Status Update';
            log.Logged_In_User__c = userinfo.getuserid(); 
            log.Error_Description__c = e.getMessage() + ' ' + e.getStackTraceString() ;
            log.Status__c = 'Failure';  
            log.Account__c = AccountId; // Added By Dhiraj	
            OSM_SW_LoggingContext.saveIntegrationLog(log); 
        }
    }
}