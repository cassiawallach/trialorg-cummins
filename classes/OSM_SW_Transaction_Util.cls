//This class will be used to make SOQL for important transaction object
//Update
public without sharing class  OSM_SW_Transaction_Util {

    public static List<ccrz__E_Order__c> fetchOrderAndOrderItems(List<Id> orderIdLst)
    {
        List<ccrz__E_Order__c> orderLst=[select id,name,ccrz__OrderStatus__c,ccrz__OriginatedCart__c,ccrz__OriginatedCart__r.ccrz__EncryptedId__c,
                                         (select id,name,ccrz__DisplayProduct__c,ccrz__Product__r.Group_Name__c,
                                         ccrz__Product__c, ccrz__Product__r.ccrz__SKU__c ,ccrz__Quantity__c,ccrz__OrderItemStatus__c,DA_Subscription_Cancelled_Quantity__c,isRenew__c, DA_Subscription_Cancellation_Status__c,ccrz__ParentOrderItem__c from ccrz__E_OrderItems__r),
                                         (Select id, name, Transaction_Status__c from ccrz__TransactionPayments__r)
                                         from ccrz__E_Order__c where id in :orderIdLst];
        
        return orderLst;
        
    }
     
                       
    public static List<ccrz__E_Subscription__c>  fetchActiveSubscriptionForAccount(String accountId,List<Id> prodIdList)
    
    {
        System.debug('fetchActiveSubscriptionForAccount: '+accountId+'  '+prodIdList);
        //this will return free trial also
        List<ccrz__E_Subscription__c> subsList = new List<ccrz__E_Subscription__c>([select id,name, ccrz__Account__c, Recurring_Invoice_Start_Date__c,OSM_Free_Trial__c,ccrz__Quantity__c,ccrz__SubscriptionProduct__c,ccrz__InstallmentNextDate__c,ccrz__SubscriptionProduct__r.Name,ccrz__SubscriptionProduct__r.ccrz__SKU__c,OSM_Subscription_End_Date__c,ccrz__SubscriptionStartDate__c,ccrz__InstallmentLastDate__c 
                                                                                    from ccrz__E_Subscription__c 
                                                                                    where ccrz__SubscriptionStatus__c='Active' 
                                                                                       and ccrz__Storefront__c='SoftwareStore' 
                                                                                       /*and OSM_SW_Is_without_Coterm__c = false
                                                                                       and OSM_Subscription_End_Date__c>= :System.Now() 
                                                                                       and ccrz__SubscriptionStartDate__c<= :System.now()*/ 
                                                                                       and ccrz__SubscriptionProduct__c in:prodIdList and ccrz__Account__c=:accountId]);
        System.debug('subsList : '+subsList );
        return subsList;
    }
       
     public static List<ccrz__E_Subscription__c>  fetchActiveSubscriptionForInvoiceForAccount(List<String> accountIdLst)
    {
     //this will return free trial also
        List<ccrz__E_Subscription__c> subsList = new List<ccrz__E_Subscription__c>([select id,ccrz__InstallmentAddress__c,Monthly_Price__c,Quarterly_Price__c,Yearly_Price__c,OneTime_Price__c,
                                                                                    ccrz__SPT__r.Billing_Display_Name__c,Recurring_Invoice_Start_Date__c,ccrz__Storefront__c,ccrz__RecurringPriceSubAmt__c,ccrz__OrderAddress__c,ccrz__InstallmentCountRemaining__c,Last_Installment_Paid__c,ccrz__Quantity__c,OSM_Subscription_End_Date__c,
                                                                                    ccrz__SubscriptionProduct__c,ccrz__SubscriptionProduct__r.Group_Name__c,ccrz__SubscriptionStartDate__c,ccrz__SubscriptionProduct__r.ccrz__SKU__c,ccrz__Account__c,Contact__c,ccrz__CurrencyISOCode__c,
                                                                                    OSM_Free_Trial__c,Subsequent_Next_Invoice_Due_Dt__c,Subsequent_Next_Invoice_Generation_Dt__c,
                                                                                    ccrz__User__c,ccrz__InstallmentLastDate__c,ccrz__InstallmentNextDate__c,Latest_Invoice__c,
                                                                                    Next_Invoice_Generation_Date__c,OSM_Display_Product__c,ccrz__RecurringPrice__c,
                                                                                    ccrz__SPT__c,ccrz__SubscriptionStatus__c from ccrz__E_Subscription__c 
       where  ccrz__InstallmentCountRemaining__c>0 and ccrz__SubscriptionStatus__c='Active' and ccrz__Storefront__c='SoftwareStore' 
       and OSM_Subscription_End_Date__c> :System.Now() and ccrz__SubscriptionStartDate__c< :System.now()   
       and ccrz__Account__c in :accountIdLst]);
        return subsList;
   
        
   }
       
    public static  Map<String,List<ccrz__E_Subscription__c>>  fetchActiveSubscriptionForAccountWithoutFreeTrial(List<String> accountIdLst)
    {
     //this will not return free trial also
        List<ccrz__E_Subscription__c> subsList = new List<ccrz__E_Subscription__c>
        ([select id,ccrz__InstallmentAddress__c,Monthly_Price__c,Quarterly_Price__c,Yearly_Price__c,OneTime_Price__c,
          ccrz__Storefront__c,Recurring_Invoice_Start_Date__c,ccrz__RecurringPriceSubAmt__c,ccrz__OrderAddress__c,ccrz__InstallmentCountRemaining__c,Last_Installment_Paid__c,ccrz__Quantity__c,
        ccrz__SubscriptionProduct__c,ccrz__SubscriptionProduct__r.ccrz__SKU__c,ccrz__Account__c,Contact__c,ccrz__CurrencyISOCode__c,
        OSM_Free_Trial__c,Subsequent_Next_Invoice_Due_Dt__c,Subsequent_Next_Invoice_Generation_Dt__c,
        ccrz__User__c,ccrz__InstallmentLastDate__c,ccrz__InstallmentNextDate__c,Latest_Invoice__c,
        Next_Invoice_Generation_Date__c,OSM_Display_Product__c,ccrz__RecurringPrice__c,
        ccrz__SPT__c,ccrz__SubscriptionStatus__c,OSM_Subscription_End_Date__c,ccrz__SubscriptionStartDate__c,
        (select id,Billing_Frequency__c,CCProduct__c,CC_Order_Item__r.ccrz__OrderItemStatus__c from OSM_Order_Subscriptions__r)
        from ccrz__E_Subscription__c 
       where  OSM_Free_Trial__c=false and OSM_SW_Is_without_Coterm__c = false and ccrz__SubscriptionStatus__c='Active' and ccrz__Storefront__c='SoftwareStore' 
       and OSM_Subscription_End_Date__c> :System.Now() and ccrz__SubscriptionStartDate__c< :System.now()   
       and ccrz__Account__c in :accountIdLst]);
        
        Map<String,List<ccrz__E_Subscription__c>> accIdVsSubsListMap = new Map<String,List<ccrz__E_Subscription__c>>();
        for(ccrz__E_Subscription__c subs: subsList){
            
            if(!accIdVsSubsListMap.containsKey(subs.ccrz__Account__c))
            {
                  accIdVsSubsListMap.put(subs.ccrz__Account__c,new List<ccrz__E_Subscription__c>());
            }
               accIdVsSubsListMap.get(subs.ccrz__Account__c).add(subs);
        }
        
        return accIdVsSubsListMap;
   
        
   }
       
       
         public static Map<Id,Map<Id,List<OSM_Order_Subscription__c>>> fetchAllOrderInfoForSubscriptions(List<Id> subsIdLst)
           {
           
           Map<Id,Map<Id,List<OSM_Order_Subscription__c>>> accIdVsSubsInfoMap = new Map<Id,Map<Id,List<OSM_Order_Subscription__c>>>();
           List<OSM_Order_Subscription__c> orderSubLst  =  [select id,CCProduct__c,Tax_Per_Unit__c,OSM_CCSubscription__c,Billing_Frequency__c,OSM_CCOrder__c,OSM_CCOrder__r.ccrz__Account__c,OSM_CCOrder__r.ownerid,Vertex_Tax__c,CC_Order_Item__c,CCQuantity__c from OSM_Order_Subscription__c where OSM_CCSubscription__c in :subsIdLst];
           
           for(OSM_Order_Subscription__c orderSubs:orderSubLst)
           {
               //excluding One time orderlines
               if(orderSubs.Billing_Frequency__c==Label.OSM_Subscription_OneTime)
               {
                 continue;
               }
               if(!accIdVsSubsInfoMap.containsKey(orderSubs.OSM_CCOrder__r.ccrz__Account__c))
               {
                  accIdVsSubsInfoMap.put(orderSubs.OSM_CCOrder__r.ccrz__Account__c,new Map<Id,List<OSM_Order_Subscription__c>>() );
                  
               }
               Map<Id,List<OSM_Order_Subscription__c>> junctionMap = accIdVsSubsInfoMap.get(orderSubs.OSM_CCOrder__r.ccrz__Account__c);
               if(!junctionMap.containsKey(orderSubs.OSM_CCSubscription__c))
               {
                  junctionMap.put(orderSubs.OSM_CCSubscription__c,new List<OSM_Order_Subscription__c>());
               }
               junctionMap.get(orderSubs.OSM_CCSubscription__c).add(orderSubs);
               
             
           }
           
               return accIdVsSubsInfoMap;
      
           }
           
           
           //Get Order subs with onetime
           public static Map<Id,Map<Id,List<OSM_Order_Subscription__c>>> fetchAllOrderInfoForSubscriptionsWithOneTime(List<Id> subsIdLst)
           {
           
           Map<Id,Map<Id,List<OSM_Order_Subscription__c>>> accIdVsSubsInfoMap = new Map<Id,Map<Id,List<OSM_Order_Subscription__c>>>();
           List<OSM_Order_Subscription__c> orderSubLst  =  [select id,CCProduct__c,Tax_Per_Unit__c,OSM_CCSubscription__c,OSM_CCSubscription__r.id,Billing_Frequency__c,OSM_CCOrder__c,OSM_CCOrder__r.ccrz__Account__c,OSM_CCOrder__r.ownerid,Vertex_Tax__c,CC_Order_Item__c,CCQuantity__c from OSM_Order_Subscription__c where OSM_CCSubscription__c in :subsIdLst];
           
           for(OSM_Order_Subscription__c orderSubs:orderSubLst)
           {
               if(!accIdVsSubsInfoMap.containsKey(orderSubs.OSM_CCOrder__r.ccrz__Account__c))
               {
                  accIdVsSubsInfoMap.put(orderSubs.OSM_CCOrder__r.ccrz__Account__c,new Map<Id,List<OSM_Order_Subscription__c>>() );
                  
               }
               Map<Id,List<OSM_Order_Subscription__c>> junctionMap = accIdVsSubsInfoMap.get(orderSubs.OSM_CCOrder__r.ccrz__Account__c);
               if(!junctionMap.containsKey(orderSubs.OSM_CCSubscription__c))
               {
                  junctionMap.put(orderSubs.OSM_CCSubscription__c,new List<OSM_Order_Subscription__c>());
               }
               junctionMap.get(orderSubs.OSM_CCSubscription__c).add(orderSubs);
               
             
           }       
               return accIdVsSubsInfoMap;
      
           }
           
   
       /**
   ** Only subscription will update with quantity & always create 
   **/
       public static void createOrderSubscriptionJunction(List<Id> orderItemsIds){
           List<OSM_Order_Subscription__c> orderSubscriptions = new List<OSM_Order_Subscription__c>();
                   List<ccrz__E_Subscription__c> subscriptions = [SELECT Id, ccrz__CCOrder__c,ccrz__User__c,ccrz__User__r.ContactId,ccrz__User__r.Profile.UserLicense.Name,Recurring_Invoice_Start_Date__c, ccrz__SPT__r.Billing_Display_Name__c, ccrz__CCOrderItem__r.ccrz__DisplayProduct__c, ccrz__CCOrderItem__c, ccrz__Quantity__c 
                                            FROM ccrz__E_Subscription__c 
                                            where ccrz__CCOrderItem__c IN: orderItemsIds];
           // change made for removal of SOQL in loop
           List<Contact> cons = [Select ID, IAM_Contact_Owner__c from Contact where IAM_Contact_Owner__c != null];
           Map<ID, ID> userToContactMap = new Map<ID, ID>();            
           for(Contact con : cons)
           {
               userToContactMap.put(con.IAM_Contact_Owner__c, con.ID);
           }
           for(ccrz__E_Subscription__c sub : subscriptions){
               OSM_Order_Subscription__c so = new OSM_Order_Subscription__c();
   
   
                       so.OSM_CCOrder__c = sub.ccrz__CCOrder__c;
                       so.CC_Order_Item__c = sub.ccrz__CCOrderItem__c;
                       so.OSM_CCSubscription__c = sub.Id;
                       so.CCQuantity__c = sub.ccrz__Quantity__c;
                       if(sub.ccrz__User__r.Profile.UserLicense.Name != 'Salesforce Platform'){
                           so.Contact__c = sub.ccrz__User__r.ContactId;
                       } else{
                           // change made for removal of SOQL in loop
                           //List<Contact> cons = [Select ID, IAM_Contact_Owner__c from Contact where IAM_Contact_Owner__c =:sub.ccrz__User__c];
                           Id conId = userToContactMap.get(sub.ccrz__User__c);
                           if(null != conId){
                               //so.Contact__c = cons[0].Id;
                               so.Contact__c = conId;
                           }
   
                       }
                       so.Billing_Frequency__c = sub.ccrz__SPT__r.Billing_Display_Name__c;
                       orderSubscriptions.add(so);
           }
           
           if(orderSubscriptions.size()>0){
               database.insert(orderSubscriptions);
           }
           
       }
       
       
       
       public static void updateAccountFieldsForAllOperations(List<String> accIdLst,String operation)
       {
           
           System.debug('Start updateAccountFieldsForAllOperations Accounts==='+accIdLst);
           System.debug('Start updateAccountFieldsForAllOperations Operation==='+operation);
           List<OSM_Integration_Log__c>  osmLogLst = new LIst<OSM_Integration_Log__c>();
           //IsActiveSubExist?
           //Next INvoice Generation Date
           //Preferred payment/billingfreq method...lock is important
           //Lock on payment/billing freq method
           
           Database.SaveResult[] srList;
           
           try{
                if(operation==Label.OSM_OrderPlaced){
                    //List<String> orderIdLst = sObjIdLst;
                    //if first order(Account fields are blank) then only update the Account fields else not required
                    //if order is one time then not required
                    
                    
                }else if(operation==Label.OSM_OrderCancelled){
                    //if there is not active subscription exists for any other product
                    //if current order is one-time then also do not update
                    Map<String,Account> accIdVsAccMap = updateAccountFields(accIdLst,operation,osmLogLst);
                    if(accIdVsAccMap!=null && accIdVsAccMap.size()>0){
                       srList = Database.update(accIdVsAccMap.values(), false);
                    }
                    
                }else if (operation == Label.OSM_Revoke_Invoice){
                    
                    
                    //if there is not active subscription exists for any other product
                    //if current order is one-time then also do not update
                    Map<String,Account> accIdVsAccMap = updateAccountFields(accIdLst,operation,osmLogLst);
                    if(accIdVsAccMap!=null && accIdVsAccMap.size()>0){
                       srList = Database.update(accIdVsAccMap.values(), false);
                    }
                    
                    
                }else if (operation == Label.OSM_Subs_Expiration){
                    //if there is not active subscription exists for any other product
                     Map<String,Account> accIdVsAccMap = updateAccountFields(accIdLst,operation,osmLogLst);
                     if(accIdVsAccMap!=null && accIdVsAccMap.size()>0){
                       srList = Database.update(accIdVsAccMap.values(), false);
                    }
                    
                }else if (operation == Label.OSM_Invoice_Payment){
                    //if there is not active subscription exists for any product which has pending invoices
                     //if there is not active subscription exists for any other product
                   Map<String,Account> accIdVsAccMap = updateAccountFields(accIdLst,operation,osmLogLst);
                   
                    if(accIdVsAccMap!=null && accIdVsAccMap.size()>0){
                       srList = Database.update(accIdVsAccMap.values(), false);
                    }
                    
                }else if (operation == Label.OSM_RecurringInvoiceCreation){
                    //if there is not active subscription exists for any product which has pending invoices
                    // no action required
                }
                
            
           
           if(srList!=null && srList.size()>0){
                   // Iterate through each returned result
                   for (Database.SaveResult sr : srList) {
                       if (sr.isSuccess()) {
                           // Operation was successful, so get the ID of the record that was processed
                           System.debug('Successfully update account. Account ID: ' + sr.getId());
                       }
                       else {
                           
                           OSM_Integration_Log__c log = new OSM_Integration_Log__c();
                           
                           log.Service_Name__c=operation;
                           log.account__c = sr.getId();
                           log.Status__c = 'Error';
                           
                                   
                                   
                           // Operation failed, so get all errors                
                           for(Database.Error err : sr.getErrors()) {
                               System.debug('The following error has occurred.');                    
                               System.debug(err.getStatusCode() + ': ' + err.getMessage());
                               log.Error_Description__c = log.Error_Description__c + '--' + err.getStatusCode() + ': ' + err.getMessage();
                               
                           }
                           
                           osmLogLst.add(log);
                       }
                   }
           }
           }catch(Exception e){
               String errorMsg = e.getLineNumber() + e.getStackTraceString() + '-----'+e.getMessage();
               OSM_Integration_Log__c log = new OSM_Integration_Log__c();
               log.Service_Name__c=operation;
               log.Status__c = 'Error';
               osmLogLst.add(log);
               throw e;
               
           }finally{
               
               if(osmLogLst!=null && osmLogLst.size()>0){
               insert osmLogLst;
            }
               
           }
            
       }
       
       
       public static Map<String,Account> updateAccountFields(List<String> accIdLst,String operation,List<OSM_Integration_Log__c>  osmLogLst)
       {   
       
           System.debug('Start updateAccountFields Accounts==='+accIdLst);
           System.debug('Start updateAccountFields operation==='+operation);
            // Perform some operations
           Map<String,List<ccrz__E_Subscription__c>> accIdVsSubsListMap = OSM_SW_Transaction_Util.fetchActiveSubscriptionForAccountWithoutFreeTrial(accIdLst);
           
           Map<String,Account> accIdVsAccMap = new Map<String,Account>([select id,OSM_Preferred_Billing_Frequency__c,OSM_Preferred_Payment_Method__c,OSM_Preferred_Billing_Frequency_Lock__c,Is_Active_Subscription_Exists__c,Next_Invoice_Generation_Date__c from account where id in :accIdLst]);
           
           
           
           for(String accId : accIdLst)
           {
                   System.debug('Start updateAccountFields For Account -> '+accId);
                  Account acc = accIdVsAccMap.get(accId);
                  
                  if(accIdVsSubsListMap!=null && accIdVsSubsListMap.containsKey(accId))
                  {
                       List<ccrz__E_Subscription__c> subsList = accIdVsSubsListMap.get(accId);
                                           
                       if(operation==Label.OSM_Revoke_Invoice){
                          
                           populateAccountFields(subsList,acc,operation,osmLogLst);
                          
                       }
                       else if(operation==Label.OSM_Subs_Expiration)
                       {
                             populateAccountFields(subsList,acc,operation,osmLogLst);
                                  
                       }
                       else if(operation==Label.OSM_Invoice_Payment)
                       {
                             populateAccountFields(subsList,acc,operation,osmLogLst);
                                                      
                       }
                            else if(operation==Label.OSM_OrderCancelled){
                            populateAccountFields(subsList,acc,operation,osmLogLst);
                       }
                       
                  }
                  else
                  {        
                         //if no active subscription exists for account meaning we need to reset the Account flags
                         acc.OSM_Preferred_Billing_Frequency_Lock__c=false;
                         acc.OSM_Preferred_Payment_Method__c='';
                         acc.OSM_Preferred_Billing_Frequency__c='';
                         acc.Is_Active_Subscription_Exists__c=false;
                         acc.Next_Invoice_Generation_Date__c=null;
                  }
           }
           
           
           return accIdVsAccMap;
            
       }
       
       
       
       public static void populateAccountFields(List<ccrz__E_Subscription__c> subsLst,Account acc,String operation,List<OSM_Integration_Log__c>  osmLogLst){
           
           System.debug('Start populateAccountFields Account==='+acc);
           System.debug('Start populateAccountFields subsLst==='+subsLst);
           
           boolean lineWithNonOneTimeFlag=false;
           for(ccrz__E_Subscription__c subs : subsLst){
                   
                   if(subs.OSM_Order_Subscriptions__r!=null && subs.OSM_Order_Subscriptions__r.size()>0)
                   {
                       
                       for(OSM_Order_Subscription__c junc : subs.OSM_Order_Subscriptions__r){
                           
                           if( String.isBlank(junc.CC_Order_Item__r.ccrz__OrderItemStatus__c) || junc.CC_Order_Item__r.ccrz__OrderItemStatus__c=='Open'){
                               
                               
                               
                               //if billing Freq is Onetime as monthly/quarterly/yearly would have been revoked
                               if(junc.Billing_Frequency__c!='' && junc.Billing_Frequency__c.contains('One')){
                                   
                                       
                                       //if order is partialcancelled/order cancelled/revoked/
                                       //check as order cancelled logic is written by Ankit
                                       //update Subs SPT and Installment fields
                                       
                                   
                               }
                               else if(junc.Billing_Frequency__c!=''){
                                   //if billingfrequency is not null and not one time meaning monthly/quarterly/yearly
                                   lineWithNonOneTimeFlag=true;
                               }
                           }
                           else{
                               //no need to consider those subscriptions..this will not happen though
                               //update Account ActiveSubscription Status
                                       //update lock
                                       //update payment method
                                       //update billing - not required
                               
                           }
                       }
                   }
                   else
                   {
                         //if junction not exists then insert in logs
                         
                           OSM_Integration_Log__c log = new OSM_Integration_Log__c();
                           log.Error_Description__c = 'ALERT : No Entry found in Order Subscription Junction';
                           log.Service_Name__c=operation;
                           log.Subscription__c=subs.id;
                           log.account__c = acc.id;
                           log.Status__c = 'Error';
                           osmLogLst.add(log);
                         
                   }
               }
               
               
               if(!lineWithNonOneTimeFlag)
               {
                         acc.OSM_Preferred_Billing_Frequency_Lock__c=false;
                         acc.OSM_Preferred_Payment_Method__c='';
                         acc.OSM_Preferred_Billing_Frequency__c='';
                         acc.Is_Active_Subscription_Exists__c=false;
                         acc.Next_Invoice_Generation_Date__c=null; 
               }
               
               
           System.debug('END populateAccountFields Account==='+acc);
           
       }
       
       public static String logProdSubsApi;
       /*
        * Commenting for now..this method can be used to stop the unlimited logging of Prod Subs API
       public static String validateLogOrNotDAProdSubsAPI()
       {
           if(logProdSubsApi==null){
               
               String OSM_DA_PROD_SUBS_DISABLE_FAILURELOG_TIMER =Label.OSM_DA_PROD_SUBS_DISABLE_FAILURELOG_TIMER;
               Integer OSM_DA_PROD_SUBS_DISABLE_FAILURELOG_TIMERINT = Integer.valueOf(OSM_DA_PROD_SUBS_DISABLE_FAILURELOG_TIMER);
           Datetime fifteenMinBack = Datetime.now().addMinutes(OSM_DA_PROD_SUBS_DISABLE_FAILURELOG_TIMERINT);
           
           Integer count  = [select count() from OSM_Integration_Log__c where createdbyId=:Userinfo.getUserId() and Target__c='DA' and Service_Name__c='Prod_SubAPI' and Status__c='Failure' and createddate>:fifteenMinBack];
               if(count>10){
                    logProdSubsApi='Enable_Log';
               }else{
                   logProdSubsApi='Disable_Log';
               }
               return logProdSubsApi;
              
           }else{
               return logProdSubsApi;
           }
       }
       */
   
       
   }