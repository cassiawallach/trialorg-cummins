global without sharing class OSM_SW_OrderConfirmationPg_Ctrl {
    @RemoteAction
    global static ccrz.cc_RemoteActionResult doOneBMSFSDCall(ccrz.cc_RemoteActionContext ctx, String orderEncId) {
        boolean shoudDAUpdateCall = true;
        ccrz.cc_CallContext.initRemoteContext(ctx);
        ccrz.cc_RemoteActionResult res = new ccrz.cc_RemoteActionResult();
        Map < String, Object > returnMap = new Map < String, Object > ();

       // String accountId = ccrz.cc_CallContext.currAccountId;
        String accountId = ccrz.cc_CallContext.effAccountId;
        String cartId = ccrz.cc_CallContext.currCartId;
        List < Account > accountList = [select id, type, Business_Unit__c,BillingCountry,CSS_DistributorCode__c, OSM_Service_Level__c, Is_Coupon_Already_Used__c from Account where id =: accountId];
        /*if(accountList!=null && accountList.size()>0)
        {
            String DealerType='';
             if('PSBU' != accountList[0].Business_Unit__c)
             {
                 if('Full Service' == accountList[0].OSM_Service_Level__c)
                 {
                    DealerType = 'Deal' + '_FS';
                 }
                 else if('Lite Repair' == accountList[0].OSM_Service_Level__c)
                 {
                                DealerType = 'Deal'+'_Maint';
                 }
            }
            if(accountList[0].type=='Dealer Account' && DealerType!='Deal_Maint' && accountList[0].Is_Coupon_Already_Used__c==false)
            {
                DNPriceDiscountOnDealerLogin(orderEncId,accountId,cartId);
            }
            else if(accountList[0].type=='Distributor Account' && accountList[0].Is_Coupon_Already_Used__c==false){
                DNPriceDiscountUpdate(orderEncId,accountId);
            }
            else
            {
                couponDiscountLogicForAllAccounts(orderEncId,accountId);
            }
                            
                
        }*/

        List < ccrz__E_Order__c > orderObj = new List < ccrz__E_Order__c > ();

        orderObj = [Select Id, OrderProcessedforFSD__c,ccrz__OrderStatus__c,IsGetOrderSuccess__c,OSMRequestCounter__c,FW_Product_Count__c,OSM_SW_Is_DA_Update_Done_Or_Not_Needed__c   from ccrz__E_Order__c where ccrz__EncryptedId__c =: orderEncId];
        if (orderObj.size() > 0) {
            List < ccrz__E_Invoice__c > objInvoice = new List < ccrz__E_Invoice__c > ();
            objInvoice = [Select Id, Payment_Method__c, OSM_SW_Is_Bolt_PO__c from ccrz__E_Invoice__c where ccrz__CCOrder__c =: orderObj[0].Id];
            if (objInvoice.size() > 0) {
                
                if (objInvoice[0].Payment_Method__c == 'po' && !objInvoice[0].OSM_SW_Is_Bolt_PO__c && !orderObj[0].OrderProcessedforFSD__c && (Label.OSM_North_America_Country.contains(accountList[0].BillingCountry) || label.OSM_PO_Distributor_List.contains(accountList[0].CSS_DistributorCode__c))) {
                    OSM_ReturnWrapper objRet = new OSM_ReturnWrapper();
                    String callSubmitOrder = System.Label.callSubmitOrder;
                    if (callSubmitOrder == 'true' ) {
            List<ccrz__E_OrderItem__c> orderItemRecord=[Select ccrz__Order__c,id from ccrz__E_OrderItem__c where ccrz__Order__c=:orderObj[0].Id and (ccrz__OrderItemStatus__c!='Cancelled' and ccrz__OrderItemStatus__c!='Cancellation Pending')];
                        Set<id> itemIdSet=new Set<id>();
                        for(ccrz__E_OrderItem__c item:orderItemRecord)
                        {
                            itemIdSet.add(item.id);
                        }
                        //objRet = OSM_WS_SubmitOrderBusiness_Handler.getOrderInfo(orderObj[0].Id, 'Submit');
            if(orderObj[0].OSMRequestCounter__c==1) 
                    {   
                        objRet = OSM_WS_SubmitOrderBusiness_Handler.getOrderInfo(orderObj[0].Id, 'Submit',itemIdSet,null,false,null);   
                    }
            //Need to remove line number 53 to 58 and 60 and uncomment 59 for PROD deployment. Added for minor_ProdFix_for1861
                                                                                                                                                              

                    }
                    if (objRet.exceptionFlag) {
                        shoudDAUpdateCall = false;
                        Set < Id > setOrderId = new Set < Id > ();
                        setOrderId.add(orderObj[0].Id);
                        OSM_SW_OrderCancellationUtility.updateRecordsOnOrderCancellation(setOrderId);
                        deleteSubscOfOrder(orderObj[0].Id);
                    } else {
                       if(!orderObj[0].IsGetOrderSuccess__c && orderObj[0].OSMRequestCounter__c==1) 
                       {    
                           callIAM_CreateOrder(orderObj[0].Id); 
                       }
                    }

                    returnMap.put('FSDRes', objRet);
                    returnMap.put('FSDNotNeeded', false);
                    system.debug('returnMap>>>>'+returnMap);
                    system.debug('FSD>>>>>'+orderObj[0].OrderProcessedforFSD__c);
                    /*if(orderObj[0].OSMRequestCounter__c>1 && orderObj[0].OrderProcessedforFSD__c)  
                    {
                          returnMap.put('FSDRes', true);
                    }*/  
                } else {
                    if(orderObj[0].FW_Product_Count__c > 0 && orderObj[0].OSMRequestCounter__c==1){
                        OSM_ReturnWrapper objRet = OSM_FW_SubmitOrder_Handler.getOrderInfo(orderObj[0].Id,false,null);
                    }
                    if(!orderObj[0].IsGetOrderSuccess__c && orderObj[0].OSMRequestCounter__c==1)    
                    {   
                        callIAM_CreateOrder(orderObj[0].Id);    
                    }
                    returnMap.put('FSDNotNeeded', true);
                    if(!label.OSM_North_America_Country.contains(accountList[0].BillingCountry) && !label.OSM_PO_Distributor_List.contains(accountList[0].CSS_DistributorCode__c) && accountList[0].type!='Distributor Account' && accountList[0].type!='Distributor Branch Account')
                    {
                        returnMap.put('IsGOMSAccount', true);
                    }
                }

                if (shoudDAUpdateCall && !orderObj[0].OSM_SW_Is_DA_Update_Done_Or_Not_Needed__c  && orderObj[0].OSMRequestCounter__c==1 ){
                    Set < Id > setOrderId = new Set < Id > ();
                    setOrderId.add(orderObj[0].Id);
                    OSM_SW_OrderTriggerHandlerUtility.getOrderUpdate(setOrderId);
                }
               
            }

        }

        List < ccrz__E_Order__c > orderObjUpdated = new List < ccrz__E_Order__c > ();

        List < ccrz__E_Order__c > orderIntercompany = new List < ccrz__E_Order__c > (); 
        orderObjUpdated = [Select Id, OrderProcessedforFSD__c,OSMRequestCounter__c, ccrz__OrderStatus__c, ccrz__EncryptedId__c,ccrz__TotalAmount__c,OSM_SW_Coupon_Count__c from ccrz__E_Order__c where ccrz__EncryptedId__c =: orderEncId]; 
        orderIntercompany= [Select Id from ccrz__E_Order__c where Original_Sales_Order__c =:orderObjUpdated[0].id];
        if (orderObjUpdated != null && orderObjUpdated.size() > 0 && orderObjUpdated[0].ccrz__OrderStatus__c == 'Order Submitted') {
            if (accountList[0].type == 'Distributor Account' || accountList[0].type == 'Dealer Account' || accountList[0].type == 'Distributor Branch Account') {
                flagUpdateForDistributorAndDealer(orderEncId, accountId);
            }

        }
         System.debug('intercompany>>>>>>'+orderIntercompany);  
         if(orderObjUpdated[0].OSMRequestCounter__c>1 && orderObjUpdated[0].OrderProcessedforFSD__c && orderIntercompany.size()==0)     
         {  
              if ((orderObjUpdated[0].ccrz__TotalAmount__c > 0) || (orderObjUpdated[0].OSM_SW_Coupon_Count__c > 0 && orderObjUpdated[0].ccrz__TotalAmount__c == 0)) {   
                OSM_SW_IntercompanyOrderInvoice.createIntercompnayOrderAndInvoice(new set<id>{orderObjUpdated[0].id});  
            }   
         }
        res.data = returnMap;
        res.success = true;
        return res;
    }

    public static void callIAM_CreateOrder(String orderId) {
        // calling create order
        Set < Id > setId = new Set < Id > ();
        setId.add(orderId);
        OSM_SW_OrderTriggerHandlerUtility.getOMSOrderIdAndActivKey_OrderUpdate(setId);

        // call IAMProvision

        List < OSM_Order_Subscription__c > lstSubscOrder = [Select Id, CC_Order_Item__c, CC_Order_Item__r.isRenew__c, OSM_CCSubscription__c from OSM_Order_Subscription__c where OSM_CCOrder__c =: orderId];

        List < Id > subscriptionIDSet = new List < Id > ();
        for (OSM_Order_Subscription__c ordrSubsc: lstSubscOrder) {
            // Uncommented if condition for MP-508
            if (!ordrSubsc.CC_Order_Item__r.isRenew__c) {
                subscriptionIDSet.add(ordrSubsc.OSM_CCSubscription__c);
            }
        }
        ccrz.ccLog.log('==call IAM========' + subscriptionIDSet);

        if (subscriptionIDSet.size() > 0) {
           callIAM(subscriptionIDSet);
           //OSM_SW_SubscriptionTriggerHandlerUtility.callIAMProvisioningBusinessLayerForInsert(subscriptionIDSet,true,false);
        }
    }
    
    @future
    public static void callIAM(List < Id > subscriptionIDSet)
    {
        OSM_SW_SubscriptionTriggerHandlerUtility.callIAMProvisioningBusinessLayerForInsert(subscriptionIDSet,true,false);
    }

    @RemoteAction
    global static ccrz.cc_RemoteActionResult callInterCompany(ccrz.cc_RemoteActionContext ctx, String orderEncId) {
        ccrz.cc_CallContext.initRemoteContext(ctx);
        ccrz.cc_RemoteActionResult res = new ccrz.cc_RemoteActionResult();
        ccrz__E_Order__c orderObj = new ccrz__E_Order__c();
        String cartId = ccrz.cc_CallContext.currCartId;
        //String accountId = ccrz.cc_CallContext.currAccountId;
        //String accountId=apexpages.currentpage().getparameters().get('effAccountId');
        
        String  accountId = ccrz.cc_CallContext.effAccountId;
        system.debug('accountid1>>>>'+accountId);
       
        List < Account > accountList = [select id, type from Account where id =: accountId];


        orderObj = [Select Id, ccrz__TotalAmount__c, OSM_SW_Coupon_Count__c, OrderProcessedforFSD__c from ccrz__E_Order__c where ccrz__EncryptedId__c =: orderEncId];
        Set < Id > setId = new Set < Id > ();

        setId.add(orderObj.Id);
        ccrz.ccLog.log('==call inter company========' + orderObj);
        try {
            System.debug('===== calling intercompany after submit order');
            //OSM_SW_OrderTriggerHandlerUtility.getOMSOrderIdAndActivKey_OrderUpdate(setId); 

            if ((orderObj.ccrz__TotalAmount__c > 0) || (orderObj.OSM_SW_Coupon_Count__c > 0 && orderObj.ccrz__TotalAmount__c == 0)) {
                OSM_SW_IntercompanyOrderInvoice.createIntercompnayOrderAndInvoice(setId);
            }
        }
        Catch(Exception ex) {
            System.debug(ex);
        }
        res.success = true;
        return res;
    }
    @RemoteAction
    global static ccrz.cc_RemoteActionResult callDiscountingLogic(ccrz.cc_RemoteActionContext ctx, String orderEncId) {
        ccrz.cc_CallContext.initRemoteContext(ctx);
        ccrz.cc_RemoteActionResult res = new ccrz.cc_RemoteActionResult();
        Map < String, Object > returnMap = new Map < String, Object > ();

        //String accountId = ccrz.cc_CallContext.currAccountId;
        String accountId = ccrz.cc_CallContext.effAccountId;
        String cartId = ccrz.cc_CallContext.currCartId;
        List < ccrz__E_Order__c > orderRecordList = new List < ccrz__E_Order__c >();
         orderRecordList = [Select Id,OSM_SW_Is_Bolt_PO__c,OSMRequestCounter__c,ccrz__OriginatedCart__r.ccrz__EncryptedId__c,(SELECT Id,ccrz__Subscription_End_Date__c,ccrz__Product__c,ccrz__Product__r.Name,ccrz__DisplayProduct__c from ccrz__E_OrderItems__r) from ccrz__E_Order__c where ccrz__EncryptedId__c =: orderEncId];   
        if(orderRecordList!=null && orderRecordList.size()>0)
        {
            List<ccrz__E_Invoice__c> invoiceList=[select id,name from ccrz__E_Invoice__c where ccrz__CCOrder__c=:orderRecordList[0].id];
            if(invoiceList!=null)
            {
                 List<ccrz__E_TransactionPayment__c> tra=[select id,ccrz__AccountType__c,ccrz__Account__r.BOLT_Account_Number__c from ccrz__E_TransactionPayment__c where ccrz__InvoiceAppliedTo__c=:invoiceList[0].id];
                 if(tra!=null && tra.size()>0 && (tra[0].ccrz__AccountType__c=='cc' || tra[0].ccrz__Account__r.BOLT_Account_Number__c !=null))
                 {
                     savePdf(invoiceList[0].id);
                 }
                
            }
            orderRecordList[0].OSMRequestCounter__c=orderRecordList[0].OSMRequestCounter__c+1;
            /* added by swetha MP-430*/
          List<ccrz__E_OrderItem__c> orderitems = new List<ccrz__E_OrderItem__c>();
          orderitems =  orderRecordList[0].ccrz__E_OrderItems__r;
          System.debug('orderitems-->'+orderitems);
           Map<id,ccrz__E_CartItem__c> idcartmap = new Map<id,ccrz__E_CartItem__c>();  
          ccrz__E_Cart__c carts = [select id, ccrz__EncryptedId__c,(select id,ccrz__Product__c,Subscription_Expiry_Date__c,ccrz__Product__r.Group_Name__c from ccrz__E_CartItems__r) from ccrz__E_Cart__c where ccrz__EncryptedId__c=:orderRecordList[0].ccrz__OriginatedCart__r.ccrz__EncryptedId__c];
          List<ccrz__E_CartItem__c> cartItems ;
            if(carts.ccrz__E_CartItems__r.size() >0){
              cartItems =carts.ccrz__E_CartItems__r;  
            }
          for(ccrz__E_CartItem__c cartit:cartItems){
               idcartmap.put(cartit.ccrz__Product__c,cartit);
            }
           system.debug('idcartmap-->'+idcartmap);
           for(ccrz__E_OrderItem__c ord: orderitems){
                 if(!ord.ccrz__Product__r.Name.contains('INCAL')){
                     if(idcartmap.containskey(ord.ccrz__Product__c)){
               		 	ord.ccrz__Subscription_End_Date__c = idcartmap.get(ord.ccrz__Product__c).Subscription_Expiry_Date__c;
                        system.debug('ord.ccrz__Subscription_End_Date__c-->'+ord.ccrz__Subscription_End_Date__c);
                 	} 
                 }
           }
          system.debug('finalupdate-->'+orderitems);
          update orderitems;
            
        }
     
        List < Account > accountList = [select id, type, Business_Unit__c,ServiceLevel__c, OSM_Service_Level__c, Is_Coupon_Already_Used__c, BOLT_Account_Number__c, Customer_BMS_number__c from Account where id =: accountId]; //Mar-1571 added field ServiceLevel__c
        try {
            if (accountList != null && accountList.size() > 0) {
                String DealerType = '';
                if ('PSBU' != accountList[0].Business_Unit__c) {
                /*  if ('Full Service' == accountList[0].OSM_Service_Level__c) { Mar-1236
                        DealerType = 'Deal' + '_FS';
                    } else if ('Lite Repair' == accountList[0].OSM_Service_Level__c) {
                        DealerType = 'Deal' + '_Maint';
                    } */
                         if('Full Service' == accountList[0].ServiceLevel__c)
                            {
                                DealerType = 'Deal' + '_FS';
                            }
                            else
                            {
                                DealerType = 'Deal'+'_Maint';
                            }              
                }
                system.debug('### DealerType ###'+DealerType);
                if (accountList[0].type == 'Dealer Account' && DealerType != 'Deal_Maint' && accountList[0].Is_Coupon_Already_Used__c == false) {
                    DNPriceDiscountOnDealerLogin(orderEncId, accountId);
                } else if (orderRecordList!=null && !orderRecordList[0].OSM_SW_Is_Bolt_PO__c) {
                    couponDiscountLogicForAllAccounts(orderEncId, accountId);
                }
                else if (accountList[0].type == 'Distributor Account' || accountList[0].type=='Distributor Branch Account') {
                    //DNPriceDiscountUpdate(orderEncId, accountId);
                }


            }
            update orderRecordList;
        }
        Catch(Exception ex) {
            System.debug(ex);
        }
        res.data = returnMap;
        res.success = true;
        return res;
    }

    public static void deleteSubscOfOrder(Id orderId) {
        List < OSM_Order_Subscription__c > ordeSubsc1 = new List < OSM_Order_Subscription__c > ();
        List < OSM_Order_Subscription__c > ordeSubsc = new List < OSM_Order_Subscription__c > ();
        Map < Id, List < OSM_Order_Subscription__c >> mapProductToSubsc = new Map < Id, List < OSM_Order_Subscription__c >> ();
        List < ccrz__E_Subscription__c > lstToDelete = new List < ccrz__E_Subscription__c > ();
        ordeSubsc1 = [Select Id, OSM_CCSubscription__c,OSM_CCOrder__c from OSM_Order_Subscription__c where OSM_CCOrder__c =: orderId];


        Set < Id > subIdSet = new Set < Id > ();

        try {
            
            for (OSM_Order_Subscription__c objSubscJun: ordeSubsc1) {
                subIdSet.add(objSubscJun.OSM_CCSubscription__c);
            }

            ordeSubsc = [Select Id, OSM_CCSubscription__c, OSM_CCOrder__c from OSM_Order_Subscription__c where OSM_CCSubscription__c =: subIdSet];
            

            for (OSM_Order_Subscription__c objSubscJun: ordeSubsc) {
                if (!mapProductToSubsc.containsKey(objSubscJun.OSM_CCSubscription__c))
                    mapProductToSubsc.put(objSubscJun.OSM_CCSubscription__c, new List < OSM_Order_Subscription__c > ());
                mapProductToSubsc.get(objSubscJun.OSM_CCSubscription__c).add(objSubscJun);
            }


            for (String key: mapProductToSubsc.keySet()) {
                if (mapProductToSubsc.get(key).size() == 1) {
                    for (OSM_Order_Subscription__c objSubOrd: mapProductToSubsc.get(key)) {
                        if (objSubOrd.OSM_CCOrder__c == orderId) {
                            ccrz__E_Subscription__c objNew = new ccrz__E_Subscription__c();
                            objNew.Id = objSubOrd.OSM_CCSubscription__c;
                            lstToDelete.add(objNew);
                        }
                    }
                }
            }

            if (lstToDelete != null && lstToDelete.size() > 0)
                delete lstToDelete;


        }
        Catch(Exception ex) {
            System.debug('Git exception in subsc delete method: ' + ex);
        }
    }

    //method written by Sangeeta to calculate DN price discount for sub migration functionality..
    public static void DNPriceDiscountOnDealerLogin(String orderEncId, Id accountId) {
        ccrz__E_Order__c orderObj = new ccrz__E_Order__c();
        List < OSM_Existing_Subscription__c > subList;
        List < ccrz__E_Order__c > orderRecordList = [Select Id,OSM_SW_Is_Bolt_PO__c,ccrz__Account__c, ccrz__TotalDiscount__c, OSM_Discount_On_BOLT__c, OSM_Discount_On_BMS__c, OSM_Discount_On_DN__c from ccrz__E_Order__c where ccrz__EncryptedId__c =: orderEncId];
        List < Account > accountList = [Select Id, Is_Coupon_Already_Used__c, name, type, Customer_BMS_number__c, BOLT_Account_Number__c from Account where Id =: accountId];

        System.debug('accountList____' + accountList);
        List < ccrz__E_OrderItem__c > orderItemList;

        List < ccrz__E_Order__c > listToUpdateOrder = new List < ccrz__E_Order__c > ();
        List < ccrz__E_OrderItem__c > listToUpdateOrderItem = new List < ccrz__E_OrderItem__c > ();
        List < OSM_Existing_Subscription__c > listToUpdateExistSub = new List < OSM_Existing_Subscription__c > ();

        //List<ccrz__E_Cart__c> cartList = [select id, ccrz__Account__r.name,ccrz__Account__c,OSM_Payment_Method__c from ccrz__E_Cart__c where ccrz__EncryptedId__c=:orderEncId limit 1];
        //System.debug('cartList____'+cartList);
        try {
            if (accountList != null && accountList.size() > 0) {
                if (orderRecordList != null && orderRecordList.size() > 0) {
                    orderItemList = [select id, ccrz__ProductType__c, ccrz__Coupon__c, ccrz__Coupon__r.ccrz__DiscountAmount__c, ccrz__Coupon__r.ccrz__CouponCode__c, Dn_Price__c, ccrz__AbsoluteDiscount__c, ccrz__Quantity__c, Original_Dn_Price__c from ccrz__E_OrderItem__c where ccrz__ProductType__c = 'Bundle'
                        and ccrz__Coupon__c != null and ccrz__Coupon__r.Subscription_Migration_Coupon__c=true and ccrz__Order__c =: orderRecordList[0].id limit 1
                    ];

                    if (orderItemList != null && orderItemList.size() > 0) {
                        subList = [select id, Discount_for_Distributors_for_Backend__c, account__c, Is_Coupon_Already_Used__c from OSM_Existing_Subscription__c where account__c =: accountList[0].id and Dealer_Coupon_Code__c =: orderItemList[0].ccrz__Coupon__r.ccrz__CouponCode__c limit 1];

                        if (accountList[0].type == 'Dealer Account' && !orderRecordList[0].OSM_SW_Is_Bolt_PO__c) {

                            List < ccrz__E_TransactionPayment__c > tranList = [select id, ccrz__AccountType__c from ccrz__E_TransactionPayment__c where ccrz__CCOrder__c =: orderRecordList[0].id limit 1];
                            if (tranList != null && tranList.size() > 0 && tranList[0].ccrz__AccountType__c == 'po') {

                                System.debug('subList____' + subList);
                                System.debug('orderItemList___' + orderItemList);
                                if (subList != null && subList.size() > 0 && accountList[0].Is_Coupon_Already_Used__c == false && subList[0].Discount_for_Distributors_for_Backend__c != null) {
                                    if (orderItemList != null && orderItemList.size() > 0) {
                                        Decimal dnPrice = orderItemList[0].Dn_Price__c;
                                        Decimal updatedDnPrice = dnPrice - subList[0].Discount_for_Distributors_for_Backend__c;
                                        orderItemList[0].Original_Dn_Price__c = dnPrice;
                                        orderItemList[0].Dn_Price__c = updatedDnPrice;
                                        orderRecordList[0].OSM_Discount_On_DN__c = subList[0].Discount_for_Distributors_for_Backend__c;
                                        //orderRecordList[0].OSM_Discount_On_BMS__c=orderItemList[0].ccrz__AbsoluteDiscount__c;
                                        orderRecordList[0].OSM_Discount_On_BMS__c = orderItemList[0].ccrz__Coupon__r.ccrz__DiscountAmount__c;
                                    }


                                }
                            }

                        } else if (orderRecordList[0].OSM_SW_Is_Bolt_PO__c) {
                            //orderRecordList[0].OSM_Discount_On_BOLT__c=orderItemList[0].ccrz__AbsoluteDiscount__c;
                            orderRecordList[0].OSM_Discount_On_BOLT__c = orderItemList[0].ccrz__Coupon__r.ccrz__DiscountAmount__c;
                        }
                        listToUpdateOrder.add(orderRecordList[0]);
                        listToUpdateOrderItem.add(orderItemList[0]);
                        listToUpdateExistSub.add(subList[0]);
                    }
                    //if(orderRecordList!=null && orderRecordList.size()>0)
                    //orderRecordList[0].ccrz__TotalDiscount__c=orderItemList[0].ccrz__Coupon__r.ccrz__DiscountAmount__c;
                    /*if(accountList!=null && accountList.size()>0)
                    {
                     accountList[0].Is_Coupon_Already_Used__c=true;
                    }
                    listToUpdateOrder.add(orderRecordList[0]);
                    listToUpdateOrderItem.add(orderItemList[0]);
                    listToUpdateExistSub.add(subList[0]);
                    */
                }
            }

            if (listToUpdateOrder != null && listToUpdateOrder.size() > 0)
                update listToUpdateOrder;
            if (listToUpdateOrderItem != null && listToUpdateOrderItem.size() > 0)
                update listToUpdateOrderItem;
            if (listToUpdateExistSub != null && listToUpdateExistSub.size() > 0)
                update listToUpdateExistSub;

            //calling multiple coupon discount logic as well for dealer account...
            couponDiscountLogicForAllAccounts(orderEncId, accountId);

        } catch (Exception e) {
            system.debug('Exception>>>>' + e);
        }
    }
    //method written by Sangeeta to calculate DN price discount  for leet users for sub migration functionality..
    /*public static void DNPriceDiscountOnFleetLogin(String orderEncId,Id accountId)
    {
        
        List<ccrz__E_Order__c> orderRecordList = [Select Id,ccrz__Account__c,ccrz__TotalDiscount__c,ccrz__EncryptedId__c from ccrz__E_Order__c where ccrz__EncryptedId__c=:orderEncId];
        List<Account> accountList=[Select Id, name,type,Customer_BMS_number__c,BOLT_Account_Number__c from Account where Id =: accountId];
       
        List<ccrz__E_OrderItem__c> orderItemList;
        
        List<ccrz__E_Order__c> listToUpdateOrder=new List<ccrz__E_Order__c>();
        List<ccrz__E_OrderItem__c> listToUpdateOrderItem=new List<ccrz__E_OrderItem__c>();
        try{
            if(accountList!=null && accountList.size()>0)
            {
                //List<ccrz__E_Subscription__c> subscriptionList=[select id,ccrz__Account__c,ccrz__SubscriptionProduct__c from ccrz__E_Subscription__c where ccrz__Account__c=:accountId and ccrz__SubscriptionProduct__r.ccrz__ProductType__c='Bundle'];
                
                if(orderRecordList!=null && orderRecordList.size()>0)
                {
                     orderItemList=[select id,ccrz__ProductType__c,ccrz__Coupon__c,ccrz__Coupon__r.ccrz__DiscountAmount__c,ccrz__AbsoluteDiscount__c,ccrz__Coupon__r.ccrz__CouponCode__c,Dn_Price__c from ccrz__E_OrderItem__c where ccrz__ProductType__c='Bundle' and ccrz__Coupon__c!=null and ccrz__Order__c=:orderRecordList[0].id limit 1];
                     if(orderItemList!=null && orderItemList.size()>0)
                     {
                             Decimal dnPrice=orderItemList[0].Dn_Price__c;
                             Decimal updatedDnPrice=dnPrice-orderItemList[0].ccrz__AbsoluteDiscount__c;
                             orderItemList[0].Dn_Price__c=updatedDnPrice;
                         
                         //orderRecordList[0].ccrz__TotalDiscount__c=orderItemList[0].ccrz__AbsoluteDiscount__c;
                         
                     }
                }
                 listToUpdateOrder.add(orderRecordList[0]);
                 listToUpdateOrderItem.add(orderItemList[0]);
                 
            }
            
            if(listToUpdateOrder!=null && listToUpdateOrder.size()>0)
                update listToUpdateOrder;
            if(listToUpdateOrderItem!=null && listToUpdateOrderItem.size()>0)
                update listToUpdateOrderItem;
            
            
        }
        catch(Exception e)
        {
             system.debug('Exception>>>>'+e);
        }
        
    }*/
    public static void flagUpdateForDistributorAndDealer(String orderEncId, Id accountId) {
        List < ccrz__E_Order__c > orderRecordList = [Select Id, ccrz__Account__c, ccrz__TotalDiscount__c, ccrz__EncryptedId__c from ccrz__E_Order__c where ccrz__EncryptedId__c =: orderEncId];
        system.debug('orderList>>>' + orderRecordList);
        List < OSM_Existing_Subscription__c > subList;
        List < ccrz__E_OrderItem__c > orderItemList;
        List < Account > accountList = [Select Id, Is_Coupon_Already_Used__c, name, type, Customer_BMS_number__c, BOLT_Account_Number__c from Account where Id =: accountId];
        List<OSM_Accounts_Coupon_Details__c> couponCustomerDetailsList=[select id,Customer_Name__c,Coupon_Code__c,Date_Generated__c,Is_Coupon_Used__c from OSM_Accounts_Coupon_Details__c where Customer_Name__c=:accountId];

        if (orderRecordList != null && orderRecordList.size() > 0) {
            orderItemList = [select id, ccrz__ProductType__c, ccrz__Coupon__c, ccrz__Coupon__r.ccrz__DiscountAmount__c, ccrz__Coupon__r.ccrz__CouponCode__c, Dn_Price__c from ccrz__E_OrderItem__c where ccrz__ProductType__c = 'Bundle'
                and ccrz__Coupon__c != null and ccrz__Order__c =: orderRecordList[0].id limit 1
            ];
            if (orderItemList != null && orderItemList.size() > 0){
                subList = [select id, Discount_for_Distributors_for_Backend__c, account__c, Is_Coupon_Already_Used__c from OSM_Existing_Subscription__c where account__c =: accountList[0].id and Distributor_Coupon_Code__c =: orderItemList[0].ccrz__Coupon__r.ccrz__CouponCode__c limit 1];
            if (accountList != null && accountList.size() > 0) {
                accountList[0].Is_Coupon_Already_Used__c = true;
                update accountList[0];
                if(couponCustomerDetailsList!=null && couponCustomerDetailsList.size()>0)
                { 
                    for(OSM_Accounts_Coupon_Details__c cd:couponCustomerDetailsList)
                    {
                        if(orderItemList!=null && orderItemList[0].ccrz__Coupon__r.ccrz__CouponCode__c.contains(cd.Coupon_Code__c))
                         cd.Is_Coupon_Used__c=true;
                    }
                   
                }
                update  couponCustomerDetailsList;
            }
        }
        }

    }
    public static void DNPriceDiscountUpdate(String orderEncId, Id accountId) {
        List < ccrz__E_Order__c > orderRecordList = [Select Id, ccrz__Account__c, OSM_Discount_On_DN__c, ccrz__TotalDiscount__c, ccrz__EncryptedId__c,Calculated_Total_Discount__c from ccrz__E_Order__c where ccrz__EncryptedId__c =: orderEncId];
        system.debug('orderList>>>' + orderRecordList);
        List < OSM_Existing_Subscription__c > subList;
        List < ccrz__E_OrderItem__c > orderItemList;
        List < ccrz__E_OrderItem__c > updatedOrderItemList=new List < ccrz__E_OrderItem__c >();
        List < Account > accountList = [Select Id, Is_Coupon_Already_Used__c, name, type, Customer_BMS_number__c, BOLT_Account_Number__c from Account where Id =: accountId];


        if (orderRecordList != null && orderRecordList.size() > 0) {
            orderItemList = [select id, ccrz__ProductType__c, ccrz__AbsoluteDiscount__c, ccrz__Coupon__c,ccrz__Coupon__r.ccrz__CouponType__c,ccrz__Coupon__r.ccrz__TargetQty__c,ccrz__Coupon__r.Subscription_Migration_Coupon__c,ccrz__Coupon__r.OSM_Coupon_Discount_Target_Type__c, ccrz__Coupon__r.ccrz__DiscountAmount__c, ccrz__Coupon__r.ccrz__CouponCode__c,ccrz__Coupon__r.DN_Discount__c, Dn_Price__c, ccrz__Quantity__c from ccrz__E_OrderItem__c where 
                 ccrz__Coupon__c != null and ccrz__Order__c =: orderRecordList[0].id limit 1
            ];
           
             
                                              
                
                                                                                                                                                        
                 
                                                                                                                                             
                                                                                                                                                                
                     
                                                                               
                                                                                                                                      
                        
                                                                                                                                                         
                        
                        
                     
                                                                                                                                                          
                     
                                                                                                                                                                
                     
                    
                    
                 
                                                                                                                                                                 
                 
                                                                                                                                                                
                     
                                                                    
                                                         
                            
                                                                                                                                                                                                      
                             
                                                                                                                                                                                                           
                                                                                                                                                                                                                         
                             
                                
                             
                                                                                                                                                                          
                                                                                                                                                                                                                                                                                                                                                                                 
                             
                                                                               
                                                                                                                                      
                        
                                                                                           
                        
                        
                     
                 
                
                                                

               
        }
        orderRecordList[0].OSM_Discount_On_DN__c=orderRecordList[0].Calculated_Total_Discount__c;
       if(updatedOrderItemList!=null && updatedOrderItemList.size()>0)
       {
           update updatedOrderItemList;
       }
       
        update orderRecordList[0];
        

        //calling multiple coupon discount logic as well for dealer account...
        //couponDiscountLogicForAllAccounts(orderEncId, accountId);

    }

    public static void couponDiscountLogicForAllAccounts(String orderEncId, Id accountId) {
        ccrz__E_Order__c orderObj = new ccrz__E_Order__c();
        List < ccrz__E_Order__c > listToUpdateOrder = new List < ccrz__E_Order__c > ();
        List < ccrz__E_OrderItem__c > listToUpdateOrderItem = new List < ccrz__E_OrderItem__c > ();
        List < ccrz__E_OrderItem__c > orderItemList;
        List < ccrz__E_Order__c > orderRecordList = [Select Id,OSM_SW_Is_Bolt_PO__c,ccrz__Account__c,Calculated_Total_Discount__c, ccrz__TotalDiscount__c, OSM_Discount_On_BOLT__c, OSM_Discount_On_BMS__c, OSM_Discount_On_DN__c from ccrz__E_Order__c where ccrz__EncryptedId__c =: orderEncId];
        List < Account > accountList = [Select Id, Is_Coupon_Already_Used__c, name, type, Customer_BMS_number__c, BOLT_Account_Number__c from Account where Id =: accountId];
        List<Subscription_Length_Estimation__mdt> subscriptionLengthMdt = new List<Subscription_Length_Estimation__mdt>();
        subscriptionLengthMdt = [SELECT Label, Coupon_Cost_Estimation__c FROM Subscription_Length_Estimation__mdt];
        System.debug('subscriptionLengthMdt: '+subscriptionLengthMdt);
        Map<String, Integer> mapSubscriptionLengthVsMultiplyer = new Map<String, Integer>();
        for(Subscription_Length_Estimation__mdt mtdRecord: subscriptionLengthMdt)
        {
            mapSubscriptionLengthVsMultiplyer.put(mtdRecord.Label,Integer.valueOf(mtdRecord.Coupon_Cost_Estimation__c));
        }
        try {
            if (accountList != null && accountList.size() > 0) {
                if (orderRecordList != null && orderRecordList.size() > 0) {
                    //orderRecordList[0].OSM_Discount_On_BMS__c=orderItemList[0].ccrz__AbsoluteDiscount__c;
                    //Decimal TotalDiscountAmountOnDN=0.0;
                    //Decimal TotalDiscountAmountOnBMS=0.0;
                    Decimal DiscountAmountOfAbsolutueDN = 0.0;
                    Decimal DiscountAmountOfPercentageDN = 0.0;
                    Decimal TotalDiscountAmountBoltAbsolutue = 0.0;
                    Decimal TotalDiscountAmountBoltPercentage = 0.0;
                    Decimal DiscountAmountOfAbsolutueONPrice = 0.0;
                    Decimal DiscountAmountOfPercentageONPrice = 0.0;
                    orderItemList = [select id, ccrz__SubProdTerm__r.ccrz__DisplayName__c, ccrz__ProductType__c, ccrz__Coupon__c, ccrz__Coupon__r.ccrz__DiscountAmount__c,ccrz__Coupon__r.ccrz__TargetQty__c,ccrz__Coupon__r.OSM_Coupon_Discount_Target_Type__c,ccrz__Coupon__r.DN_Discount__c, ccrz__Coupon__r.ccrz__CouponCode__c, ccrz__Coupon__r.ccrz__CouponType__c, Dn_Price__c, ccrz__AbsoluteDiscount__c, ccrz__Price__c, ccrz__Quantity__c, Original_Dn_Price__c from ccrz__E_OrderItem__c where
                    ccrz__Coupon__c != null and ccrz__Order__c =: orderRecordList[0].id and ccrz__Coupon__r.Subscription_Migration_Coupon__c=false
                    ];
                    System.debug('orderitem list>>>>>' + orderItemList);
                    if (!orderRecordList[0].OSM_SW_Is_Bolt_PO__c) {
                        if (orderItemList != null && orderItemList.size() > 0) {
                            for (ccrz__E_OrderItem__c orderItem: orderItemList) {
                                //calculating BMS discount applied on frontend...
                                //if(orderItem.ccrz__AbsoluteDiscount__c!=null)
                                //TotalDiscountAmountOnBMS=TotalDiscountAmountOnBMS+orderItem.ccrz__AbsoluteDiscount__c;
                                Decimal MSRPDiscount=0.0;
                                Decimal DNDiscount =0.0;
                                if(orderItem.ccrz__Coupon__c != null && (orderItem.ccrz__Coupon__r.OSM_Coupon_Discount_Target_Type__c=='MSRP' || orderItem.ccrz__Coupon__r.OSM_Coupon_Discount_Target_Type__c=='DN' || orderItem.ccrz__Coupon__r.OSM_Coupon_Discount_Target_Type__c=='MSRP/DN'))
                                {
                                    MSRPDiscount=orderItem.ccrz__Coupon__r.ccrz__DiscountAmount__c;
                                    DNDiscount=orderItem.ccrz__Coupon__r.DN_Discount__c;
                                }
                                else
                                {
                                    MSRPDiscount=orderItem.ccrz__Coupon__r.ccrz__DiscountAmount__c;
                                    DNDiscount=orderItem.ccrz__Coupon__r.ccrz__DiscountAmount__c;
                                }
                                //Calculating discount on DN Price and updating DN Price on backend...
                                if (orderItem.ccrz__Coupon__c != null && orderItem.ccrz__Coupon__r.ccrz__CouponType__c == 'Absolute') {
                                    // code to update absolute price on the basis of subscription length MP-307
                                    if(!Test.isRunningTest())
                                    {
                                        if(orderItem.ccrz__SubProdTerm__r.ccrz__DisplayName__c.containsIgnoreCase('YEAR'))
                                        {
                                            MSRPDiscount = MSRPDiscount*mapSubscriptionLengthVsMultiplyer.get(orderItem.ccrz__SubProdTerm__r.ccrz__DisplayName__c);
                                            DNDiscount = DNDiscount*mapSubscriptionLengthVsMultiplyer.get(orderItem.ccrz__SubProdTerm__r.ccrz__DisplayName__c);
                                        }
                                        else
                                        {
                                            MSRPDiscount = MSRPDiscount/mapSubscriptionLengthVsMultiplyer.get(orderItem.ccrz__SubProdTerm__r.ccrz__DisplayName__c);
                                            DNDiscount = DNDiscount/mapSubscriptionLengthVsMultiplyer.get(orderItem.ccrz__SubProdTerm__r.ccrz__DisplayName__c);
                                        }
                                    }
                                    
                                    
                                    Decimal dnPrice = orderItem.Dn_Price__c;
                                    Decimal price = orderItem.ccrz__Price__c;
                                    //DiscountAmountOfAbsolutueDN = DiscountAmountOfAbsolutueDN + orderItem.ccrz__Coupon__r.ccrz__DiscountAmount__c;
                                    DiscountAmountOfAbsolutueDN = DiscountAmountOfAbsolutueDN + DNDiscount;
                                    //Decimal updatedDnPrice=dnPrice-orderItem.ccrz__AbsoluteDiscount__c;
                                    //Decimal updatedDnPrice = dnPrice - orderItem.ccrz__Coupon__r.ccrz__DiscountAmount__c;
                                    Decimal updatedDnPrice = dnPrice - DNDiscount;
                                    orderItem.Original_Dn_Price__c = dnPrice;
                                    orderItem.Dn_Price__c = updatedDnPrice;
                                    //DiscountAmountOfAbsolutueONPrice = DiscountAmountOfAbsolutueONPrice + orderItem.ccrz__Coupon__r.ccrz__DiscountAmount__c * orderItem.ccrz__Quantity__c;
                                    DiscountAmountOfAbsolutueONPrice = DiscountAmountOfAbsolutueONPrice + MSRPDiscount * orderItem.ccrz__Quantity__c;
                                    listToUpdateOrderItem.add(orderItem);

                                } else if (orderItem.ccrz__Coupon__c != null && orderItem.ccrz__Coupon__r.ccrz__CouponType__c == 'Percentage') {
                                    //Decimal DiscountPercentage = orderItem.ccrz__Coupon__r.ccrz__DiscountAmount__c;
                                    Decimal dnPrice = orderItem.Dn_Price__c;
                                    Decimal price = orderItem.ccrz__Price__c;
                                    //Decimal amountToSubtract = (dnPrice * DiscountPercentage) / 100;
                                    //commented on 29th Feb 2020....
                                    //Decimal amountToSubtract = (dnPrice * DNDiscount) / 100;
                                    Decimal amountToSubtract=0.0;
                                    if(orderItem.ccrz__Coupon__r.ccrz__TargetQty__c >= orderItem.ccrz__Quantity__c)
                                    {
                                        //amountToSubtract=price*orderItem.ccrz__Quantity__c)*DNDiscount/100;
                                        amountToSubtract=(dnPrice * DNDiscount) / 100;
                                    }
                                    else
                                    {
                                        Decimal unitDNprice=dnPrice/orderItem.ccrz__Quantity__c;
                                        amountToSubtract=(unitDNprice*orderItem.ccrz__Coupon__r.ccrz__TargetQty__c)*DNDiscount/100;
                                    }
                                    //Decimal amountSubtractedFromPrice = (price * DiscountPercentage) / 100;
                                    Decimal amountSubtractedFromPrice = (price * MSRPDiscount) / 100;
                                    Decimal updatedDnPrice = dnPrice - amountToSubtract;
                                    orderItem.Original_Dn_Price__c = dnPrice;
                                    orderItem.Dn_Price__c = updatedDnPrice;
                                    DiscountAmountOfPercentageDN = DiscountAmountOfPercentageDN + amountToSubtract;
                                    DiscountAmountOfPercentageONPrice = DiscountAmountOfPercentageONPrice + amountSubtractedFromPrice * orderItem.ccrz__Quantity__c;
                                    listToUpdateOrderItem.add(orderItem);
                                    system.debug('updated order item list>>>>' + listToUpdateOrderItem);
                                }
                            }

                        }
                        if (orderRecordList[0].OSM_Discount_On_DN__c != null && orderRecordList[0].OSM_Discount_On_BMS__c != null) {
                            Decimal OldDNDiscount = orderRecordList[0].OSM_Discount_On_DN__c;
                            Decimal oldBMSdiscount = orderRecordList[0].OSM_Discount_On_BMS__c;
                            Decimal finalDNDiscount=OldDNDiscount + DiscountAmountOfAbsolutueDN + DiscountAmountOfPercentageDN;
                            //Decimal finalBMSDiscount=oldBMSdiscount + DiscountAmountOfAbsolutueONPrice + DiscountAmountOfPercentageONPrice;
                            Decimal finalBMSDiscount=orderRecordList[0].Calculated_Total_Discount__c;
                            if(finalDNDiscount!=null)
                            {
                                orderRecordList[0].OSM_Discount_On_DN__c=finalDNDiscount.setscale(2);
                            }
                            if(finalBMSDiscount!=null)
                            {
                                orderRecordList[0].OSM_Discount_On_BMS__c=finalBMSDiscount.setscale(2);
                            }
                            
                            //orderRecordList[0].OSM_Discount_On_DN__c = OldDNDiscount + DiscountAmountOfAbsolutueDN + DiscountAmountOfPercentageDN;
                            //orderRecordList[0].OSM_Discount_On_BMS__c = oldBMSdiscount + DiscountAmountOfAbsolutueONPrice + DiscountAmountOfPercentageONPrice;
                        } else {
                            Decimal finalDNDiscount=DiscountAmountOfAbsolutueDN + DiscountAmountOfPercentageDN;
                            //Decimal finalBMsDiscount=DiscountAmountOfAbsolutueONPrice + DiscountAmountOfPercentageONPrice;
                            Decimal finalBMsDiscount=orderRecordList[0].Calculated_Total_Discount__c;
                            orderRecordList[0].OSM_Discount_On_DN__c=finalDNDiscount.setscale(2);
                            orderRecordList[0].OSM_Discount_On_BMS__c =finalBMsDiscount.setscale(2);
                            //orderRecordList[0].OSM_Discount_On_DN__c = DiscountAmountOfAbsolutueDN + DiscountAmountOfPercentageDN;
                            //orderRecordList[0].OSM_Discount_On_BMS__c = DiscountAmountOfAbsolutueONPrice + DiscountAmountOfPercentageONPrice;
                        }


                    } else if (orderRecordList[0].OSM_SW_Is_Bolt_PO__c) {
                        if (orderItemList != null && orderItemList.size() > 0) {
                            for (ccrz__E_OrderItem__c orderItem: orderItemList) {
                                Decimal MSRPDiscount=0.0;
                                Decimal DNDiscount =0.0;
                                if(orderItem.ccrz__Coupon__c != null && (orderItem.ccrz__Coupon__r.OSM_Coupon_Discount_Target_Type__c=='MSRP' || orderItem.ccrz__Coupon__r.OSM_Coupon_Discount_Target_Type__c=='DN' || orderItem.ccrz__Coupon__r.OSM_Coupon_Discount_Target_Type__c=='MSRP/DN'))
                                {
                                    MSRPDiscount=orderItem.ccrz__Coupon__r.ccrz__DiscountAmount__c;
                                    DNDiscount=orderItem.ccrz__Coupon__r.DN_Discount__c;
                                }
                                else
                                {
                                    MSRPDiscount=orderItem.ccrz__Coupon__r.ccrz__DiscountAmount__c;
                                    DNDiscount=orderItem.ccrz__Coupon__r.ccrz__DiscountAmount__c;
                                }
                                if (orderItem.ccrz__AbsoluteDiscount__c != null && orderItem.ccrz__Coupon__c != null && orderItem.ccrz__Coupon__r.ccrz__CouponType__c == 'Absolute') {
                                    // code to update absolute price on the basis of subscription length MP-307
                                    
                                    if(orderItem.ccrz__SubProdTerm__r.ccrz__DisplayName__c.containsIgnoreCase('YEAR'))
                                    {
                                        MSRPDiscount = MSRPDiscount*mapSubscriptionLengthVsMultiplyer.get(orderItem.ccrz__SubProdTerm__r.ccrz__DisplayName__c);
                                        DNDiscount = DNDiscount*mapSubscriptionLengthVsMultiplyer.get(orderItem.ccrz__SubProdTerm__r.ccrz__DisplayName__c);
                                    }
                                    else
                                    {
                                        MSRPDiscount = MSRPDiscount/mapSubscriptionLengthVsMultiplyer.get(orderItem.ccrz__SubProdTerm__r.ccrz__DisplayName__c);
                                        DNDiscount = DNDiscount/mapSubscriptionLengthVsMultiplyer.get(orderItem.ccrz__SubProdTerm__r.ccrz__DisplayName__c);
                                    }
                                    
                                    
                                    Decimal dnPrice = orderItem.Dn_Price__c;
                                    //TotalDiscountAmountBoltAbsolutue = TotalDiscountAmountBoltAbsolutue + orderItem.ccrz__Coupon__r.ccrz__DiscountAmount__c * orderItem.ccrz__Quantity__c;
                                    TotalDiscountAmountBoltAbsolutue = TotalDiscountAmountBoltAbsolutue + MSRPDiscount * orderItem.ccrz__Quantity__c;
                                } else if (orderItem.ccrz__Coupon__c != null && orderItem.ccrz__Coupon__r.ccrz__CouponType__c == 'Percentage') {
                                    //Decimal DiscountPercentage = orderItem.ccrz__Coupon__r.ccrz__DiscountAmount__c;
                                    Decimal DiscountPercentage = MSRPDiscount;
                                    Decimal price = orderItem.ccrz__Price__c;
                                    Decimal amountSubtractedFromPrice = (price * DiscountPercentage) / 100;
                                    TotalDiscountAmountBoltPercentage = TotalDiscountAmountBoltPercentage + amountSubtractedFromPrice * orderItem.ccrz__Quantity__c;
                                }
                            }

                        }
                        if (orderRecordList[0].OSM_Discount_On_BOLT__c != null) {
                            Decimal oldBOLTDiscount = orderRecordList[0].OSM_Discount_On_BOLT__c;
                            //Decimal finalTotalDiscount=oldBOLTDiscount + TotalDiscountAmountBoltAbsolutue + TotalDiscountAmountBoltPercentage;
                            Decimal finalTotalDiscount=orderRecordList[0].Calculated_Total_Discount__c;
                            if(finalTotalDiscount!=null)
                            {
                                orderRecordList[0].OSM_Discount_On_BOLT__c=finalTotalDiscount.setscale(2);
                                //orderRecordList[0].OSM_Discount_On_BOLT__c = oldBOLTDiscount + TotalDiscountAmountBoltAbsolutue + TotalDiscountAmountBoltPercentage;
                            }
                        } else {
                            //Decimal finalTotalDiscount=TotalDiscountAmountBoltAbsolutue + TotalDiscountAmountBoltPercentage;
                            Decimal finalTotalDiscount=orderRecordList[0].Calculated_Total_Discount__c;
                            if(finalTotalDiscount!=null)
                            {
                                orderRecordList[0].OSM_Discount_On_BOLT__c=finalTotalDiscount.setscale(2);
                                //orderRecordList[0].OSM_Discount_On_BOLT__c = TotalDiscountAmountBoltAbsolutue + TotalDiscountAmountBoltPercentage;
                            }
                        }
                    }

                    listToUpdateOrder.add(orderRecordList[0]);
                }
            }

            //updating the order and  order items ...
            if (listToUpdateOrder != null && listToUpdateOrder.size() > 0)
                update listToUpdateOrder;
            if (listToUpdateOrderItem != null && listToUpdateOrderItem.size() > 0)
                update listToUpdateOrderItem;
        } catch (Exception e) {
            system.debug('couponDiscountLogicForAllAccounts Exception>>>>'+e);
        }


    }

     public static PageReference savePdf(ID parentId) {
        PageReference pdf = Page.PdfGeneratorTemplate;
         pdf.getParameters().put('id',parentId);
        Attachment attach = new Attachment();
        Blob body;
        try {
            body = pdf.getContent();
        } catch (VisualforceException e) {
            body = Blob.valueOf('Some Text');
        }
        attach.Body = body;
        attach.Name = 'CCInvoice.pdf';
        attach.IsPrivate = false;
        attach.ParentId = parentId;
        insert attach;
        return new PageReference('/'+parentId);
      }
}