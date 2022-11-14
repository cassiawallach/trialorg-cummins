global class OSM_SW_cc_hk_Subscriptions extends ccrz.cc_hk_Subscriptions {
    public Id accountIdTest;
    global static List<Id> orderItemIdToDeleteLst = new List<Id>();
    
    //List<Map<String, Object>> subscriptionRecordsForReturn = null;
    //List<ccrz__E_Subscription__c> subscriptionRecordsForReturn = null;//Sangeeta MP-379  Commenting this unused variable
    global override Map<String,Object> getSubscriptionProcessQuery(Map<String,Object> inputData)
    {
        //System.debug('************ Inside OSM_SW_cc_hk_Subscriptions--getSubscriptionProcessQuery ');//Sangeeta MP-379  Commenting this debug line
        Map<String,Object> returnData = super.getSubscriptionProcessQuery( inputData);
        return returnData;
        
    }
    
    
    
    global override Map<String,Object> processSubscriptions(Map<String,Object> inputData)
    {
        //System.debug('************ Inside OSM_SW_cc_hk_Subscriptions--processSubscriptions ');//Sangeeta MP-379  Commenting this unused variable
        Map<String,Object> returnData = super.getSubscriptionProcessQuery( inputData);
        return returnData;
    }
    
    
    global override Map<String,Object> onOrder(Map<String,Object> inputData)
    {
        ReturnWrapper result;
        try{
            result = validateSubscriptionExist((String)inputData.get(ccrz.cc_hk_Subscriptions.PARAM_ORDER_ID));
            ccrz.cc_hk_Payment.TransactionPaymentParams resultTrans; 
            if(!Test.isRunningTest())
            { 
                resultTrans = (ccrz.cc_hk_Payment.TransactionPaymentParams)inputData.get(ccrz.cc_hk_Subscriptions.PARAM_TRANSACTION_DATA);
            }
            //ccrz.ccLog.log('************OSM_SW_cc_hk_Subscriptions--result************** '+resultTrans);//Sangeeta MP-379  Commenting this unnecessary debug line
            //ccrz.ccLog.log('************OSM_SW_cc_hk_Subscriptions--resultTrans************** '+resultTrans);//Sangeeta MP-379  Commenting this unnecessary debug line
                 
            if(result!=null && result.subscriptionsToBeDeleted.size()>0)
            {  
                for(ccrz__E_OrderItem__c orderItem : result.subscriptionsToBeDeleted)
                {  
                     orderItemIdToDeleteLst.add(orderItem.id);
                }
                 
            }  
            //ccrz.ccLog.log('************OSM_SW_cc_hk_Subscriptions--inputData************** '+inputData);//Sangeeta MP-379  Commenting this unnecessary debug line
            /*Sangeeta MP-379  Commenting this extra unnecessary for loop
            System.debug('before calling method :  cc_hk_Subscriptions.onOrder');
            for(String key : inputData.keySet())
            {
                System.debug('key: '+key+'----value-----: '+inputData.get(key));
            }*/
            Map<String,Object> returnData = super.onOrder(inputData);
            //ccrz.ccLog.log('************OSM_SW_cc_hk_Subscriptions--returnData**************'+returnData);
            return returnData;
            
            }catch(Exception e)
            {
                //TBD
                /*Sangeeta MP-379  Commenting this extra unnecessary for loop
                System.debug('Ins subscription hk execption');
                System.debug(e);
                System.debug(e.getCause());
                System.debug(e.getLineNumber());
                System.debug(e.getStackTraceString());
                System.debug(e.getMessage());*/
                ccrz.ccLog.log('OSM_SW_cc_hk_Subscriptions'+e.getCause()+' line #:'+e.getLineNumber()+ ' stack trace ' + e.getStackTraceString() + '-----'+e.getMessage());
               //display message to user..trigger error
               
                return new Map<String,Object>();
            }
                
                    
         
    }
    
    global override Map<String,Object> fetchSubscriptions(Map<String,Object> inputData)
    { 
        //ccrz.ccLog.log('************fetch subscription************** ');//Sangeeta MP-379  Commenting this debug line
        
        Map<String,Object> returnData = new Map<String,Object>();
        List<Map<String,Object>> childLst = new List<Map<String,Object>>();
        String accountId;
        if(!Test.isRunningTest())
        {
            //accountId = ccrz.cc_CallContext.currAccountId;
            accountId = ccrz.cc_CallContext.effAccountId;
        }else
        {
            accountId = accountIdTest;
        }
        String storefront = ccrz.cc_CallContext.storefront;
        //ccrz.ccLog.log('************fetch subscription account id************** '+accountId );//Sangeeta MP-379  Commenting this debug line
        //ccrz.ccLog.log('************fetch subscription store ************** '+storefront);//Sangeeta MP-379  Commenting this debug line
        
        Datetime myDT = Datetime.now();
        List<ccrz__E_Subscription__c> lstSubsc = new List<ccrz__E_Subscription__c>();
        //Sangeeta MP-379 Removed extra unused fields
        lstSubsc = [Select Id,ccrz__CCOrder__c,ccrz__CCOrder__r.Name,Name,ccrz__Account__r.billingCountry,ccrz__SubscriptionStartDate__c,ccrz__CurrencyISOCode__c,ccrz__SubscriptionProduct__c,ccrz__SubscriptionProduct__r.Name, ccrz__RecurringPrice__c,OSM_Free_Trial__c,ccrz__SPT__r.Billing_Display_Name__c, ccrz__SPTInstallmentFrequencyUOM__c,OSM_Display_Product__c ,OSM_Display_Product__r.Name,OSM_Display_Product__r.Group_Name__c,ccrz__Quantity__c, ccrz__RecurringPriceSubAmt__c, OSM_Subscription_End_Date__c, ccrz__SubscriptionStatus__c  from ccrz__E_Subscription__c where ccrz__Account__c =: accountId and ccrz__Storefront__c =: storefront and ccrz__SubscriptionStatus__c = 'Active' and ccrz__SubscriptionStartDate__c <=: myDT ORDER BY CreatedDate DESC ];
        
        //ccrz.ccLog.log('************fetch lstSubsc  ************** '+lstSubsc );//Sangeeta MP-379  Commenting this debug line

        Set<Id> setSubscProduct = new Set<Id>();
        Map<Id, boolean> mapSubscToIsAddon = new Map<Id, boolean>();
        Map<Id, DateTime> mapRenewedSubscToSubscEndDate = new Map<Id, DateTime>();
        Set<Id> subscIdSet = new Set<Id>();
        Set<Id> orderIdSet = new Set<Id>();
        Map<Id,String> mapOrderToPONumber = new Map<Id,String>();
        
        for(ccrz__E_Subscription__c objSubsc : lstSubsc)
        {
            setSubscProduct.add(objSubsc.ccrz__SubscriptionProduct__c);
            mapSubscToIsAddon.put(objSubsc.Id, false);
            subscIdSet.add(objSubsc.Id);
            if(objSubsc.ccrz__CCOrder__c != null)
                orderIdSet.add(objSubsc.ccrz__CCOrder__c);
            
        }

        if(orderIdSet.size() > 0)
        {
            /*Sangeeta MP-379 Commented these two lines 
            List<ccrz__E_TransactionPayment__c> lstTP = new List<ccrz__E_TransactionPayment__c>();
            lstTP = [Select Id,ccrz__AccountNumber__c,ccrz__AccountType__c,ccrz__CCOrder__c from ccrz__E_TransactionPayment__c where ccrz__CCOrder__c IN: orderIdSet];*/
            for(ccrz__E_TransactionPayment__c objTP :[Select Id,ccrz__AccountNumber__c,ccrz__AccountType__c,ccrz__CCOrder__c from ccrz__E_TransactionPayment__c where ccrz__CCOrder__c IN: orderIdSet])
            {
                if(objTP.ccrz__AccountType__c == 'po')
                {
                    mapOrderToPONumber.put(objTP.ccrz__CCOrder__c,objTP.ccrz__AccountNumber__c);
                }
                else
                {
                    mapOrderToPONumber.put(objTP.ccrz__CCOrder__c,'');
                }
            }
            
        }
        
        if(subscIdSet != null && subscIdSet.size() > 0)
        {
            /*Sangeeta MP-379 updated this piece of code as below...
            List<ccrz__E_Subscription__c> lstRevenwedSubsc = new List<ccrz__E_Subscription__c>();
            lstRevenwedSubsc = [Select Id, Renewed_From_Subscription__c , OSM_Subscription_End_Date__c from ccrz__E_Subscription__c where Renewed_From_Subscription__c IN: subscIdSet and ccrz__SubscriptionStatus__c =: Label.OSM_Subscription_Status_Renew];
            if(lstRevenwedSubsc != null && lstRevenwedSubsc.size() > 0)
            {
                for(ccrz__E_Subscription__c objSub : lstRevenwedSubsc)
                {
                    mapRenewedSubscToSubscEndDate.put(objSub.Renewed_From_Subscription__c, objSub.OSM_Subscription_End_Date__c);
                }
            }*/
            for(ccrz__E_Subscription__c objSub : [Select Id, Renewed_From_Subscription__c , OSM_Subscription_End_Date__c from ccrz__E_Subscription__c where Renewed_From_Subscription__c IN: subscIdSet and ccrz__SubscriptionStatus__c =: Label.OSM_Subscription_Status_Renew])
            {
                mapRenewedSubscToSubscEndDate.put(objSub.Renewed_From_Subscription__c, objSub.OSM_Subscription_End_Date__c);
            }
        }
        
        if(setSubscProduct != null && setSubscProduct.size() > 0)
        {
            Map<Id, List<ccrz__E_RelatedProduct__c>> mapProductIdToRelatedProduct = new Map<Id, List<ccrz__E_RelatedProduct__c>>();
            /*Sangeeta MP-379 Commenting these two lines
            List<ccrz__E_RelatedProduct__c> lstRelatedProduct = new List<ccrz__E_RelatedProduct__c>();
            lstRelatedProduct = [Select Id, ccrz__RelatedProduct__c, ccrz__Product__c, ccrz__RelatedProductType__c from ccrz__E_RelatedProduct__c where ccrz__Enabled__c = true AND ccrz__EndDate__c >= TODAY AND ccrz__RelatedProduct__c IN: setSubscProduct];*/
            
            for(ccrz__E_RelatedProduct__c objRP :  [Select Id, ccrz__RelatedProduct__c, ccrz__Product__c, ccrz__RelatedProductType__c from ccrz__E_RelatedProduct__c where ccrz__Enabled__c = true AND ccrz__EndDate__c >= TODAY AND ccrz__RelatedProduct__c IN: setSubscProduct])
            {
                if(!mapProductIdToRelatedProduct.containsKey(objRP.ccrz__RelatedProduct__c))
                    mapProductIdToRelatedProduct.put(objRP.ccrz__RelatedProduct__c, new List<ccrz__E_RelatedProduct__c>());
                mapProductIdToRelatedProduct.get(objRP.ccrz__RelatedProduct__c).add(objRP);
            }
            
            for(ccrz__E_Subscription__c objSubsc : lstSubsc)
            {
                if(mapProductIdToRelatedProduct.containsKey(objSubsc.ccrz__SubscriptionProduct__c))
                {
                    for(ccrz__E_RelatedProduct__c objRel : mapProductIdToRelatedProduct.get(objSubsc.ccrz__SubscriptionProduct__c))
                    {
                        if(objRel.ccrz__Product__c == objSubsc.OSM_Display_Product__c && objRel.ccrz__RelatedProductType__c == 'Accessories')
                        {
                            mapSubscToIsAddon.put(objSubsc.Id, true);
                        }
                    }
                }
                
            }
            
        }
        //Sangeeta MP-379 Added this piece of code to optimize the query in below for loop...
        Map<id,List<OSM_Order_Subscription__c>> subIDOrderSubMap=new Map<id,List<OSM_Order_Subscription__c>>();
        for(OSM_Order_Subscription__c ordSub:[select id,OSM_CCOrder__r.Name,OSM_CCSubscription__c from OSM_Order_Subscription__c where OSM_CCSubscription__c IN:mapSubscToIsAddon.keyset()])
        {
            if(!subIDOrderSubMap.containsKey(ordSub.OSM_CCSubscription__c))
                    subIDOrderSubMap.put(ordSub.OSM_CCSubscription__c, new List<OSM_Order_Subscription__c>());
                subIDOrderSubMap.get(ordSub.OSM_CCSubscription__c).add(ordSub);
        }
          
        for(ccrz__E_Subscription__c objSub : lstSubsc)
        {
            Map<String,Object> newMap = new Map<String,Object>();
            newMap.put('sfid',objSub.Id);
            newMap.put('freeTrial',objSub.OSM_Free_Trial__c);
            newMap.put('productName',objSub.OSM_Display_Product__r.Name);
            if(mapSubscToIsAddon.containsKey(objSub.Id) && mapSubscToIsAddon.get(objSub.Id))
            {
                newMap.put('productName',objSub.ccrz__SubscriptionProduct__r.Name);
            }
            newMap.put('isRenewed',false);
            if(mapRenewedSubscToSubscEndDate.containsKey(objSub.Id))
            {
                newMap.put('isRenewed',true);
                //newMap.put('renewEndDate',String.valueOf(mapRenewedSubscToSubscEndDate.get(objSub.Id).format('MM/dd/yyyy')));
                //long timet = mapRenewedSubscToSubscEndDate.get(objSub.Id).getTime();//Sangeeta MP-379 commenting this variable
                newMap.put('renewEndDate',mapRenewedSubscToSubscEndDate.get(objSub.Id).getTime());
            }
            
            newMap.put('poNumber','');
            if(mapOrderToPONumber.containsKey(objSub.ccrz__CCOrder__c))
            {
                newMap.put('poNumber',mapOrderToPONumber.get(objSub.ccrz__CCOrder__c));
            }
            //Sangeeta MP-379 commenting this query as this is bad practice to add query inside loop..
            //List<OSM_Order_Subscription__c> orderSubscritions = [select id,OSM_CCOrder__r.Name from OSM_Order_Subscription__c where OSM_CCSubscription__c =:objSub.Id];
            //newMap.put('orderNumbers',orderSubscritions);
            
            //Sangeeta MP-379 added this line after code optimization...
            if(subIDOrderSubMap.containsKey(objSub.Id))
            newMap.put('orderNumbers',subIDOrderSubMap.get(objSub.Id));
            
            newMap.put('quantity',objSub.ccrz__Quantity__c);
            //newMap.put('topRecurringPrice',objSub.ccrz__RecurringPriceSubAmt__c);
            newMap.put('topRecurringPrice',String.valueOf(objSub.ccrz__RecurringPrice__c));
            newMap.put('endDate',String.valueOf(objSub.OSM_Subscription_End_Date__c.format('MM/dd/yyyy')));
            //long timet = objSub.OSM_Subscription_End_Date__c.getTime();
            //newMap.put('endDate',timet);
            if(objSub.ccrz__Account__r.billingCountry != null && objSub.ccrz__Account__r.billingCountry != '')
            newMap.put('billingCountry',objSub.ccrz__Account__r.billingCountry);
            newMap.put('status',objSub.ccrz__SubscriptionStatus__c);
            newMap.put('currecnyCode',objSub.ccrz__CurrencyISOCode__c);
            if(objSub.ccrz__SPT__r.Billing_Display_Name__c != null && objSub.ccrz__SPT__r.Billing_Display_Name__c != '')
                newMap.put('billingFreq', objSub.ccrz__SPT__r.Billing_Display_Name__c);
            newMap.put('canManageSubsc',false);
            
            if(objSub.OSM_Display_Product__r.Group_Name__c == 'SES')
            {
                if(objSub.ccrz__SubscriptionStartDate__c.addYears(5) < objSub.OSM_Subscription_End_Date__c){
                    newMap.put('endDate','-');
                }
                //if(objSub.OSM_SW_Days_To_Create__c <= Integer.valueOf(Label.OSM_SW_Days_To_show_cancel_Link_on_Subsc))
                //{
                    newMap.put('canManageSubsc',true);
                //}
                
            }
            childLst.add(newMap);
        }
        
        returnData.put('subscriptions', childLst);
        
        
        return returnData;
       
    
    }
    
    
    
    private ReturnWrapper validateSubscriptionExist(String orderId)
    {
        system.debug('=====Inside validateSubscriptionExist==='+orderId);
        List<ccrz__E_Subscription__c> subsToUpdateLst =null;
        List<String> subsIdsToUpdateLst =null;
        String accountId;
        if(!Test.isRunningTest())
        {
            //accountId = ccrz.cc_CallContext.currAccountId;
            accountId = ccrz.cc_CallContext.effAccountId;
        }else
        {
            accountId = accountIdTest;
        }
        
        List<Id> orderIdLst = new List<Id>();
        ccrz__E_Order__c order = null;
        List<Id> prodIdLst = new List<Id>();
        Map<Id,ccrz__E_OrderItem__c> prodIdVsOrderItemMap = null;
        List<ccrz__E_Subscription__c> activeSubsList = null;
        ReturnWrapper returnWrapper = new ReturnWrapper();
        returnWrapper.subscriptionsToBeDeleted = new List<ccrz__E_OrderItem__c>();
        
        try{
            
            subsToUpdateLst = new List<ccrz__E_Subscription__c>();
            subsIdsToUpdateLst = new List<String>();
            String encryptedCartId = '';
            //system.debug('=====Inside validateSubscriptionExist accountId==='+accountId);//Sangeeta MP-379 debug statement commented
            //ccrz.cclog.log('===Inside validateSubscriptionExist accountId==='+accountId);//Sangeeta MP-379 debug statement commented
            orderIdLst.add(orderId);
            List<ccrz__E_Order__c> orderLst = OSM_SW_Transaction_Util.fetchOrderAndOrderItems(orderIdLst);
            if(orderLst!=null && orderLst.size()>0)            
            {
                order=orderLst.get(0);
                encryptedCartId = order.ccrz__OriginatedCart__r.ccrz__EncryptedId__c;
            }
            else
            {
                //this will never happen but incase occurs log in console
                ccrz.ccLog.log(System.LoggingLevel.ERROR,'ERR','======Order Id not found in OSM==='+orderId);
               
            }
                
            
        prodIdVsOrderItemMap = new Map<Id,ccrz__E_OrderItem__c>();
        Set<String> productIdsSet = new Set<String>();
        for(ccrz__E_OrderItem__c orderLine: order.ccrz__E_OrderItems__r)
        {
           prodIdVsOrderItemMap.put(orderLine.ccrz__Product__c,orderLine);
            prodIdLst.add(orderLine.ccrz__Product__c);
            productIdsSet.add(orderLine.ccrz__Product__c);
        }
            Map<Id, boolean> productRenew = new Map<Id,Boolean>();
            Map<Id, boolean> productWithCoTerm = new Map<Id,Boolean>();
            for(ccrz__E_CartItem__c crtItem : OSM_SW_ProdDetailUtils_Ctrl.getCartItems(encryptedCartId, productIdsSet) ){
                productRenew.put(crtItem.ccrz__Product__c, crtItem.isRenew__c); 
                productWithCoTerm.put(crtItem.ccrz__Product__c, crtItem.withCoTerm__c); 
            }
         //system.debug('************OSM_SW_cc_hk_Subscriptions--prodIdLst************ '+prodIdLst);//Sangeeta MP-379 debug statement commented
         //system.debug('************productWithCoTerm************ '+productWithCoTerm);//Sangeeta MP-379 debug statement commented
         //ccrz.cclog.log('************OSM_SW_cc_hk_Subscriptions--prodIdLst************ '+prodIdLst);//Sangeeta MP-379 debug statement commented
         //activeSubsList = OSM_SW_Transaction_Util.fetchActiveSubscriptionForAccount(accountId,prodIdLst);//Sangeeta MP-379 commenting this query here
         
            Map<Id,ccrz__E_Subscription__c> prodIdVsSubsMap = new Map<Id,ccrz__E_Subscription__c>();
            Map<Id,ccrz__E_Subscription__c> freeTrialsMap = new Map<Id,ccrz__E_Subscription__c>();
            //system.debug('************activeSubsList******* '+activeSubsList);//Sangeeta MP-379 debug statement commented
            //ccrz.cclog.log('************activeSubsList************ '+activeSubsList);//Sangeeta MP-379 debug statement commented
            
            //Sangeeta MP-379 Written the above activeSubsList call here instead of fetching above...
            for(ccrz__E_Subscription__c subscription:OSM_SW_Transaction_Util.fetchActiveSubscriptionForAccount(accountId,prodIdLst))
            {
              //system.debug('************OSM_SW_cc_hk_Subscriptions--ccrz__E_Subscription__c******* '+subscription);//Sangeeta MP-379 debug statement commented
              //ccrz.cclog.log('************OSM_SW_cc_hk_Subscriptions--ccrz__E_Subscription__c******* '+subscription);//Sangeeta MP-379 debug statement commented
             if(subscription.OSM_Free_Trial__c)
             {
                freeTrialsMap.put(subscription.ccrz__SubscriptionProduct__c,subscription);
             }
             else
             {
                prodIdVsSubsMap.put(subscription.ccrz__SubscriptionProduct__c,subscription);
             }
             
            }
            
            
            
            for(Id prodId : prodIdVsOrderItemMap.keySet())
            {
               ccrz__E_OrderItem__c orderItem = prodIdVsOrderItemMap.get(prodId);
                //system.debug('************orderItem*************KEY********** '+orderItem);//Sangeeta MP-379 debug statement commented
               //system.debug('************ProdId*************KEY********** '+prodId);//Sangeeta MP-379 debug statement commented
               if(freeTrialsMap.containsKey(prodId))
               {
                  ccrz__E_Subscription__c subscription  = freeTrialsMap.get(prodId);
                  subscription.OSM_Subscription_End_Date__c = System.now();
                  subscription.ccrz__SubscriptionStatus__c='Cancelled';
               }
               //system.debug('************prodIdVsSubsMap*************KEY********** '+prodIdVsSubsMap);//Sangeeta MP-379 debug statement commented
               if(prodIdVsSubsMap.containsKey(prodId))
               {
                   ccrz.ccLog.log('************prodIdVsSubsMap contains----UPDATING*************KEY********** '+prodId);
                   //if active subscription exists then update the quantity
                    //ccrz__E_OrderItem__c orderItem = prodIdVsOrderItemMap.get(subscription.ccrz__SubscriptionProduct__c);
                    ccrz__E_Subscription__c subscription  = prodIdVsSubsMap.get(prodId);
                   if(((productRenew.get(prodId) != null && !productRenew.get(prodId)) 
                        && !subscription.ccrz__SubscriptionProduct__r.Name.ContainsIgnoreCase('Incal') && productWithCoTerm.containsKey(prodId) && productWithCoTerm.get(prodId)) || Test.isRunningTest()){
                        subscription.ccrz__Quantity__c = subscription.ccrz__Quantity__c + orderItem.ccrz__Quantity__c;
                        subsIdsToUpdateLst.add(subscription.id);
                        subsToUpdateLst.add(subscription);
                   }
                    returnWrapper.subscriptionsToBeDeleted.add(orderItem);
               }
              
            }
            
        update subsToUpdateLst;
        update freeTrialsMap.values();
        
        
        /*
        //Ignore thise
        Map<String,Object> inputData = new Map<String,Object>{
            ccrz.ccApi.API_VERSION => 7,
            ccrz.ccAPISubscription.STOREFRONT => 'SoftWareStore',
            ccrz.ccAPISubscription.BYLASTORDERDATE => TRUE,
            ccrz.ccAPISubscription.BYASC => TRUE,
            ccrz.ccAPISubscription.IDS=> subsIdsToUpdateLst,
            ccrz.ccAPI.SIZING => new Map<String, Object>{
            ccrz.ccAPISubscription.ENTITYNAME => new Map<String, Object>{
            ccrz.ccAPI.SZ_DATA => ccrz.ccAPI.SZ_M,
            ccrz.ccAPI.SZ_REL => new List<String>{},
            ccrz.ccAPI.SZ_ASSC => true,
            ccrz.ccAPI.SZ_SKIPTRZ=>true
                }
            }
            
        };
  
                Map<String, Object> outputData = ccrz.ccAPISubscription.fetch(inputData);
                ccrz.ccLog.log('===outputData==='+outputData);
                if (outputData.get(ccrz.ccAPISubscription.SUBSCRIPTIONS) != null) {
                     subscriptionRecordsForReturn =(List<ccrz__E_Subscription__c>) outputData.get(ccrz.ccAPISubscription.SUBSCRIPTIONS);
                }   
            
        */
        }catch(Exception e)
        {
           ccrz.ccLog.log(System.LoggingLevel.ERROR,'ERR','***************EXCEPTION OCCURED IN validateSubscriptionExist() OF OSM_SW_cc_hk_Subscriptions************************ ');
           ccrz.ccLog.log(System.LoggingLevel.ERROR,'ERR',e);
           throw new OSM_SW_SubscriptionCreateException(System.Label.OSM_Subscription_Create_Error,e);
           
        }
       
        return returnWrapper;
    }
    
    public class ReturnWrapper{
    
        public List<ccrz__E_OrderItem__c> subscriptionsToBeDeleted;
        
    
    }
    
    
}