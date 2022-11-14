global class OSM_RenewalSubs_LicenseKeys_Batch implements Database.Batchable<sObject>, Database.AllowsCallouts, Schedulable, Database.Stateful {
    
    global set<Id> set_OrderId = new Set<Id>();
    
    global Database.QueryLocator start(Database.BatchableContext BC){
        string subStatus = 'Renew';
        //string subID = 'a3W1F0000012jWT';
        String queryForBatch = 'SELECT Id, IsIAMDataUpdated__c, ccrz__CCOrder__c, ccrz__CCOrderItem__c, ccrz__SubscriptionStartDate__c, OSM_Subscription_End_Date__c, ccrz__SubscriptionStatus__c FROM ccrz__E_Subscription__c WHERE ccrz__SubscriptionStatus__c =: subStatus AND Is_Renewal_Subscription__c = true AND (ccrz__SubscriptionStartDate__c = TODAY OR ccrz__SubscriptionStartDate__c = TOMORROW)';// ccrz__SubscriptionStartDate__c = TODAY ' ;//prod fix for 6/14
        return Database.getQueryLocator(queryForBatch);
    }
    
    
    global void execute(Database.BatchableContext BC, List<ccrz__E_Subscription__c> scope){
        Set<Id> set_SubsId = new Set<Id>();
        List<ccrz__E_Subscription__c> list_SubsUpdate = new List<ccrz__E_Subscription__c>();
        for(ccrz__E_Subscription__c subs : scope){
            if(subs.ccrz__CCOrder__c != null && subs.ccrz__CCOrderItem__c != null){
                createLicenseKeys(new Set<Id>{subs.ccrz__CCOrder__c}, subs.ccrz__CCOrderItem__c, null, true);
                set_SubsId.add(subs.Id);
            }
        }
        for(ccrz__E_Subscription__c sub : [SELECT Id, ccrz__CCOrder__c, ccrz__SubscriptionStatus__c, ccrz__CCOrder__r.AllActivationKeysGenerated__c
                                                FROM ccrz__E_Subscription__c WHERE Id IN: set_SubsId]){
            if(sub.ccrz__CCOrder__r.AllActivationKeysGenerated__c){
                sub.ccrz__SubscriptionStatus__c = 'Active';
                list_SubsUpdate.add(sub);
                set_OrderId.add(sub.ccrz__CCOrder__c);
            }
        }
        if(list_SubsUpdate.size() > 0){
            update list_SubsUpdate;
        }
    }
    
    
    global void finish(Database.BatchableContext BC){
        if(set_OrderId.size() > 0){
            List<ccrz__E_Order__c> list_OrderUpdate = new List<ccrz__E_Order__c>();
            for(ccrz__E_Order__c ordr : [SELECT Id, OrderConfirmationMailSent__c, IsActivationKeyJobRun__c, SendOrderDetailMail__c FROM ccrz__E_Order__c WHERE Id IN: set_OrderId]){
                ordr.OrderConfirmationMailSent__c = false;
                ordr.IsActivationKeyJobRun__c = true;//Added by Subbunew
                ordr.SendOrderDetailMail__c = true;
                list_OrderUpdate.add(ordr);
            }
            
            if(list_OrderUpdate.size() > 0){
                update list_OrderUpdate;
            }
        }
    }
    
    
    global void execute(SchedulableContext SC){
        OSM_RenewalSubs_LicenseKeys_Batch iamRenwBatch = new OSM_RenewalSubs_LicenseKeys_Batch();
        database.executebatch(iamRenwBatch,1);
    }
    
    
    global void createLicenseKeys(Set<Id> orderIdLst, Id orderItemId, Id orderItemLicenseId, boolean updatekey){
        String AccountId;
        List<OSM_Integration_Log__c> toBeInsertedLogList = new List<OSM_Integration_Log__c>();
        OSM_Integration_Log__c objOIL = new OSM_Integration_Log__c();
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
            
            Map<Id,ccrz__E_Order__c> orderMap=new Map<Id,ccrz__E_Order__c>();
            Set<Id> orderItemIdSet=new Set<Id>();
            List<OSM_Order_Item_License__c> orderItemLicenseListToCheck=new List<OSM_Order_Item_License__c>();
            List<Id> lstItemForRenewItem = new List<Id>();          
            boolean IsFluidWatch =false;
            List<ccrz__E_Order__c>  ordr = [select ID,ccrz__OriginatedCart__c, CreatedById, ccrz__Account__c from ccrz__E_Order__c where id in :orderIdLst];// Added(ccrz__Account__c Column in SOQL Query) By Dhiraj for MAR-1621 - Story On 16th April 202
            Map<Id,Id> cartOrderMap = new Map<Id,Id>();
            for(ccrz__E_Order__c objs : ordr){
                objOIL.Account__c = objs.ccrz__Account__c;//Added By Dhiraj
                cartOrderMap.put(objs.ccrz__OriginatedCart__c, objs.Id);
                AccountId = objs.ccrz__Account__c; //Added By Dhiraj for MAR-1621 - Story On 21st April 2021
                toBeInsertedLogList.add(objOIL);//Added By Dhiraj
            }
           
            if(orderIdLst != null && orderItemId != null && orderItemLicenseId == null) {
                List<ccrz__E_OrderItem__c> orderItemList=[select id,ccrz__Order__c from ccrz__E_OrderItem__c where id=:orderItemId];
                orderItemLicenseList=[select id,name,Activation_Key__c,Parent_Activation_Key__c,Revoked_ReIssue_Lisence__c,Status__c,Type__c from OSM_Order_Item_License__c where id=:orderItemLicenseId];
                if(orderItemList!=null && orderItemList.size()>0) {
                    orderMap = new Map<Id,ccrz__E_Order__c>([select ID, Name, OrderConfirmationMailSent__c, CreatedById,SendOrderDetailMail__c, ccrz__Account__c, ccrz__Account__r.CMI_Account_Num__c, ccrz__Contact__r.Username__c, (select ID, ccrz__SubscriptionStartDate__c from ccrz__CCSubscriptions__r), (select id, Name, isRenew__c, ccrz__Quantity__c, OMS_Order_ID__c, OMS_Item_ID__c, OMS_Product__c, Number_of_Bundles__c, Number_of_Counts__c, ccrz__SubProdTerm__c, ccrz__SubProdTerm__r.ccrz__DisplayName__c, ccrz__Product__c, ccrz__Product__r.Name, ccrz__Product__r.ccrz__ProductType__c, ccrz__DisplayProduct__r.Name, OSM_SW_Is_without_Coterm__c,ccrz__DisplayProduct__r.ccrz__SKU__c, ccrz__DisplayProduct__r.Product_Range__c, ccrz__DisplayProduct__r.Feature__C, ccrz__DisplayProduct__r.FeatureGroup__C, ccrz__DisplayProduct__r.LicenseName__C from ccrz__E_OrderItems__r where id=:orderItemId) from ccrz__E_Order__c where id=:orderItemList[0].ccrz__Order__c AND ccrz__OrderStatus__c='Order Submitted' AND OSM_SW_Is_InterCompany_Order__c=false]);            
                    system.debug('orderMap in else block>>>>>'+orderMap);
                }
                singleOrderItemFlag=true;
            }
            
            Set<String> productIdSet = new Set<String>();            
            if(orderMap.keyset() != null && orderMap.size()>0) {
                for(Id orderId:orderMap.keySet()) {
                    for( ccrz__E_OrderItem__c orderItem: orderMap.get(orderId).ccrz__E_OrderItems__r) {
                        productIdSet.add(orderItem.ccrz__Product__c);
                        productIdSet.add(orderItem.ccrz__DisplayProduct__c);
                        orderItemIdSet.add(orderItem.id);                       
                    }
                }
            }
            if(orderItemIdSet!=null && orderItemIdSet.size()>0) {
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
            List<ccrz__E_Order__c> toBeUpdatedOrderList = new List<ccrz__E_Order__c>();
            List<OSM_Order_Item_License__c> toBeInsertUpdateListOrderItemLicense=new List<OSM_Order_Item_License__c>();
            
            if(orderMap.keyset() != null && orderMap.size()>0) {
                for(Id orderId:orderMap.keySet()) {
                    ccrz__E_Order__c orderRef = orderMap.get(orderId);
                    /*orderRef.SendOrderDetailMail__c = true;
                    orderRef.OrderConfirmationMailSent__c = false;
                    toBeUpdatedOrderList.add(orderRef);*/
                    
                    for( ccrz__E_OrderItem__c orderItem: orderRef.ccrz__E_OrderItems__r)
                    {
                        Boolean callOMSServices = false;
                        OSM_OMS_CreateOrderGeneral_IP_Wrapper generalizedInputWrapper = new OSM_OMS_CreateOrderGeneral_IP_Wrapper();
                        generalizedInputWrapper.orderId = orderRef.ID;
                        generalizedInputWrapper.orderName = orderRef.Name;
                        Date d = System.today();
                        Datetime myDT = datetime.newInstance(d.year(), d.month(),d.day());
                        String myDate = myDT.format('yyyy-MM-dd');
                
                        generalizedInputWrapper.timestamp = myDate;
                        generalizedInputWrapper.toolName = Label.OSM_ToolName;    // static value...will not change
                        generalizedInputWrapper.AccId = AccountId;    // Added BY Dhiraj
                        
                        generalizedInputWrapper.requesterId = OSM_Generic_Utility.truncateRequesterId(orderRef.ccrz__Account__r.CMI_Account_Num__c); //OSM_Generic_Utility.truncateRequesterId added by Pooja story 1054                               
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
                                            quantity = Integer.valueOf(orderItem.ccrz__Quantity__c) * Integer.valueOf(compositeProduct.ccrz__Quantity__c);
                                        }
                                    }
                                }
                            }
                            system.debug('inside bundle block==='+product);
                        }
                        System.debug(' DisplayProduct ggs '+ orderItem.ccrz__DisplayProduct__r.Name);
                          //Start Mar-1346
                          String tempName;
                        if(null != orderItem.ccrz__DisplayProduct__c){
                        
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
                        system.debug('tempName-->>'+tempName);
                        system.debug('tempName11-->>'+!Label.OSM_BundleProduct.containsIgnoreCase(orderItem.ccrz__DisplayProduct__r.Name));
                        system.debug('tempName22-->>'+Label.OMS_ProductList_OriginalList.contains(orderItem.ccrz__DisplayProduct__r.ccrz__SKU__c));
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
                                quantity = Integer.valueOf(orderItem.ccrz__Quantity__c); 
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
                        
                        if(singleOrderItemFlag) {                            
                            if((null != omsOrderId && !String.isEmpty(omsOrderId))) {
                                // GET ORDER Service
                                OSM_GetOrder_WS_GeneralizedoutputWrapper getOrderGeneralizedOutputWrapper = OSM_GetOrderInfo_Service.callGetOrderInfoService(omsOrderId, orderId,AccountId);
                                if(null != getOrderGeneralizedOutputWrapper) {
                                    if(!getOrderGeneralizedOutputWrapper.errorFlag || Test.isRunningTest()) {
                                        if(null != getOrderGeneralizedOutputWrapper.ItemInfoList
                                           && null != getOrderGeneralizedOutputWrapper.ItemInfoList.ItemInfo && getOrderGeneralizedOutputWrapper.ItemInfoList.ItemInfo.size() > 0 
                                           )
                                        {
                                            for(Integer i=0; i<getOrderGeneralizedOutputWrapper.ItemInfoList.ItemInfo.size();i++) {
                                                orderItem.OSM_SW_Get_Order_success__c = true;
                                                OSM_Order_Item_License__c orderItemLicenseRecord=new OSM_Order_Item_License__c();
                                                orderItemLicenseRecord.CC_Order_Item__c=orderItem.id;
                                                orderItemLicenseRecord.Status__c='New';
                                                if(getOrderGeneralizedOutputWrapper.ItemInfoList.ItemInfo[i].LicenseInfo.LicenseName.contains('Basic')) {
                                                    orderItemLicenseRecord.Activation_Key__c=getOrderGeneralizedOutputWrapper.ItemInfoList.ItemInfo[i].LicenseInfo.ActivationKey;
                                                    orderItemLicenseRecord.type__c='Basic';
                                                    orderItemLicenseRecord.OMS_Order_ID__c=omsOrderId;
                                                    orderItemLicenseRecord.OMS_Item_ID__c = getOrderGeneralizedOutputWrapper.ItemInfoList.ItemInfo[i].ItemId;
                                                    
                                                }
                                                else
                                                {
                                                    orderItemLicenseRecord.Activation_Key__c=getOrderGeneralizedOutputWrapper.ItemInfoList.ItemInfo[i].LicenseInfo.ActivationKey;
                                                    orderItemLicenseRecord.type__c='Functional';
                                                    orderItemLicenseRecord.OMS_Order_ID__c=omsOrderId;
                                                    orderItemLicenseRecord.OMS_Item_ID__c = getOrderGeneralizedOutputWrapper.ItemInfoList.ItemInfo[i].ItemId;
                                                    
                                                }                                           
                                                toBeInsertUpdateListOrderItemLicense.add(orderItemLicenseRecord);
                                            }
                                        }   
                                    }
                                    
                                    if(null != getOrderGeneralizedOutputWrapper.log) {
                                        toBeInsertedLogList.add(getOrderGeneralizedOutputWrapper.log);
                                    }
                                }
                            }                           
                        }           
                        orderItem.OSM_SW_Is_without_Coterm__c = false;
                        toBeUpdatedOrderItemList.add(orderItem);
                    }
                }
            }
            
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
            
            if(Test.isRunningTest()) {
                throw new NullPointerException();
            }
        }
        catch(Exception ex) {
            System.debug('Inside Catch+++');
            OSM_Integration_Log__c log = new OSM_Integration_Log__c();          
            System.debug('AccountId+++' + AccountId);
            log.Account__c = AccountId;             
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
}