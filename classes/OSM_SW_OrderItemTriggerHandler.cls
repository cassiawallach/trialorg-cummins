public with sharing class OSM_SW_OrderItemTriggerHandler{
    
    //After insert
    public static void onAfterInsert(List<ccrz__E_OrderItem__c> lstOrderItem)
    {
        Set<Id> setCartItemId = new Set<Id>();
        
        for(ccrz__E_OrderItem__c orderItem : lstOrderItem )
        {
            setCartItemId.add(orderItem.Id); 
        }
        if(setCartItemId != null && setCartItemId.size() > 0)
        {
            List<ccrz__E_OrderItem__c> lstOrdItem = new List<ccrz__E_OrderItem__c>();
            lstOrdItem = [Select Id,ccrz__Product__r.ccrz__SKU__c, OSM_SW_SubProd_term_length__c, ccrz__SubProdTerm__c, ccrz__SubProdTerm__r.Subs_Length_Sequence__c,OMS_Product__c,ccrz__DisplayProduct__c, ccrz__DisplayProduct__r.Name,Is_Addon_Product__c, ccrz__Coupon__c, OSM_SW_Coupon_Applied__c, ccrz__ParentOrderItem__c, OSM_SW_Is_Included_Product__c, OSM_SW_Non_Insite_OSM_Product__c  from ccrz__E_OrderItem__c where Id IN:setCartItemId];
            //add on
            List<String> addonsNameLst = new List<String>();
            List<String> addonsNameLstTrim = new List<String>();
            addonsNameLst = System.label.SES_OMSCreateOrder_SubscriptionProduct_List_AddOns.split(',');
            System.debug(addonsNameLst);
            for(String sku : addonsNameLst)
                addonsNameLstTrim.add(sku.trim());
            
            // osm product
            List<String> osmProductLst = new List<String>();
            List<String> osmProductLstTrim = new List<String>();
            osmProductLst = System.label.OMS_ProductList_OriginalList.split(',');
            for(String sku : osmProductLst)
                osmProductLstTrim.add(sku.trim());
            
            //OSM non insite Product
            List<String> nonInstieProductLst = new List<String>();
            List<String> nonInstieProductLstTrim = new List<String>();
            nonInstieProductLst = System.label.OMS_ProductList_NonInsite.split(',');
            for(String sku : nonInstieProductLst)
                nonInstieProductLstTrim.add(sku.trim());
            
            for(ccrz__E_OrderItem__c ordrIetm :lstOrdItem)
            {
                //populate sub prod term length
                if(ordrIetm.ccrz__SubProdTerm__c != null)
                {
                    ordrIetm.OSM_SW_SubProd_term_length__c = ordrIetm.ccrz__SubProdTerm__r.Subs_Length_Sequence__c;
                }
                //is sub prod term null 
                else
                {
                    ordrIetm.OSM_SW_SubProd_term_length__c = 3;
                }
                //Oms_Product_Set   
                if(osmProductLstTrim.contains(ordrIetm.ccrz__Product__r.ccrz__SKU__c))
                    ordrIetm.OMS_Product__c = true;
                //Coupon_Applied
                if(ordrIetm.ccrz__Coupon__c != null)
                    ordrIetm.OSM_SW_Coupon_Applied__c = true;
                //Included_Product_Check
                if(ordrIetm.ccrz__ParentOrderItem__c != null)
                    ordrIetm.OSM_SW_Is_Included_Product__c = true;
                //OSM non insite Product
                if(nonInstieProductLstTrim.contains(ordrIetm.ccrz__Product__r.ccrz__SKU__c))
                    ordrIetm.OSM_SW_Non_Insite_OSM_Product__c = true;
                
                //AddOn
                if(addonsNameLstTrim.contains(ordrIetm.ccrz__Product__r.ccrz__SKU__c))
                    ordrIetm.Is_Addon_Product__c = true;
                
            }
            
            if(lstOrdItem.size() > 0)
                update lstOrdItem;
            
            
        }
        
    }
    //After insert
    public static void OnAfterTaxUpdate(List<ccrz__E_OrderItem__c> lstOrderItem){
    
        Set<Id> setCartItemId = new Set<Id>();
        List<ccrz__E_OrderItem__c> lstOrdItem = new List<ccrz__E_OrderItem__c>();
        for(ccrz__E_OrderItem__c orderItem : lstOrderItem )
        {
            if(orderItem.ccrz__OrderItemId__c != null && orderItem.ccrz__OrderItemId__c != '')
            setCartItemId.add(orderItem.ccrz__OrderItemId__c); 
        }
        
        if(setCartItemId != null && setCartItemId.size() > 0)
        {
            List<ccrz__E_CartItem__c> lstCartItem = new List<ccrz__E_CartItem__c>();
            Map<Id,Decimal> mapCartIdToTax = new Map<Id,Decimal>();
            lstCartItem = [Select Id, Vertex_tax__c from ccrz__E_CartItem__c where Id IN: setCartItemId];
            
            for(ccrz__E_CartItem__c objcartItem : lstCartItem)
            {
                mapCartIdToTax.put(objcartItem.Id, objcartItem.Vertex_tax__c);
            }
            
            for(ccrz__E_OrderItem__c orderItem : lstOrderItem )
            {
                if(mapCartIdToTax.containsKey(orderItem.ccrz__OrderItemId__c))
                {
                    orderItem.Vertex_Tax__c = mapCartIdToTax.get(orderItem.ccrz__OrderItemId__c);
                    
                }
            }
            
        }
        
       
        
    
    }
    
    //Before Insert:
    public static void onBeforeInsert(List<ccrz__E_OrderItem__c> lstOrderItem)
    {
        Set<Id> orderIdSet = new Set<Id>();
        Map<Id,Id> orderToCartMap = new Map<Id, Id>();
        Map<Id, Map<Id,boolean>> mapCartToIteamcoterm = new Map<Id, Map<Id,boolean>>();
        
        // Changes for: MAR-958
        Set<Id> set_ProductId = new Set<Id>();
        Set<Id> set_FWProductId = new Set<Id>();
        
        for(ccrz__E_OrderItem__c item : lstOrderItem)
        {
            orderIdSet.add(item.ccrz__Order__c);
            set_ProductId.add(item.ccrz__Product__c);
        }
        
        // Changes for: MAR-958
        if(set_ProductId.size() > 0){
            for(ccrz__E_Product__c prodObj : [SELECT Id FROM ccrz__E_Product__c WHERE Id IN:set_ProductId AND Group_Name__c = 'FluidWatch']){
                set_FWProductId.add(prodObj.Id);
            }
        }
        
        if(orderIdSet.size() > 0)
        {
            Set<Id> cartIdSet = new Set<Id>();
            List<ccrz__E_Order__c> lstOrder = new List<ccrz__E_Order__c>();
            lstOrder = [Select Id, ccrz__OriginatedCart__c from ccrz__E_Order__c where Id IN: orderIdSet];
            for(ccrz__E_Order__c ordr :lstOrder)
            {
                cartIdSet.add(ordr.ccrz__OriginatedCart__c);
                orderToCartMap.put(ordr.Id,ordr.ccrz__OriginatedCart__c);
            }
            if(cartIdSet.size()>0)
            {
                List<ccrz__E_CartItem__c> lstCartItem = new List<ccrz__E_CartItem__c>();
                lstCartItem = [Select Id,ccrz__Cart__c,ccrz__Product__c,withCoTerm__c   from ccrz__E_CartItem__c where ccrz__Cart__c IN: cartIdSet];
                for(ccrz__E_CartItem__c cartItem : lstCartItem)
                {
                    if(!mapCartToIteamcoterm.containsKey(cartItem.ccrz__Cart__c))
                        mapCartToIteamcoterm.put(cartItem.ccrz__Cart__c,new Map<Id,boolean>());
                    mapCartToIteamcoterm.get(cartItem.ccrz__Cart__c).put(cartItem.ccrz__Product__c,cartItem.withCoTerm__c);
                }
            }
        }
        
        for(ccrz__E_OrderItem__c item : lstOrderItem)
        {
            if(orderToCartMap.containsKey(item.ccrz__Order__c) && orderToCartMap.get(item.ccrz__Order__c) != null && mapCartToIteamcoterm.containsKey(orderToCartMap.get(item.ccrz__Order__c)) && mapCartToIteamcoterm.get(orderToCartMap.get(item.ccrz__Order__c)) != null && mapCartToIteamcoterm.get(orderToCartMap.get(item.ccrz__Order__c)).containsKey(item.ccrz__Product__c) && !mapCartToIteamcoterm.get(orderToCartMap.get(item.ccrz__Order__c)).get(item.ccrz__Product__c))
                item.OSM_SW_Is_without_Coterm__c = true;
            
            // Changes for: MAR-958
            if(set_FWProductId.contains(item.ccrz__Product__c)){
                item.Is_FW_OrderItem__c = true;
            }
        }
    }
    
    // Mar-1266
    public static void onAfterUpdate(List<ccrz__E_OrderItem__c> lstOrderItem, Map<Id, ccrz__E_OrderItem__c> oldMap){
        List<ccrz__E_OrderItem__c> LstOitem = new List<ccrz__E_OrderItem__c>();
        Set<Id> setCouponId = new Set<Id>();
        Map<Id,Decimal> mapCouponIdQnty = new Map<Id,Decimal>();
        for(ccrz__E_OrderItem__c orderItem : lstOrderItem ) {
            if(orderItem.ccrz__OrderItemStatus__c == System.Label.OSM_OrderItem_Cancellation_Status && 
                    orderItem.ccrz__OrderItemStatus__c != oldMap.get(orderItem.Id).ccrz__OrderItemStatus__c) { 
                System.debug(orderItem.OSM_SW_Coupon_Applied__c+'==INSIDE OI Canceled block=='+orderItem.ccrz__Coupon__c+'*******'+orderItem.ccrz__Coupon__r.ccrz__TotalUsed__c);
                
                if(orderItem.OSM_SW_Coupon_Applied__c && orderItem.ccrz__Coupon__c != null) {
                    system.debug('***___'+orderItem.Coupon_Quantity__c+'######'+orderItem.ccrz__OriginalQuantity__c);
                    if(orderItem.Coupon_Quantity__c >= orderItem.ccrz__OriginalQuantity__c)
                    {   
                       mapCouponIdQnty.put(orderItem.ccrz__Coupon__c, orderItem.ccrz__OriginalQuantity__c);
                    }
                    else{
                       mapCouponIdQnty.put(orderItem.ccrz__Coupon__c, orderItem.Coupon_Quantity__c);
                    }
                }                    
            }
        }
        system.debug('****mapCouponIdQnty***'+mapCouponIdQnty);
        List<ccrz__E_Coupon__c> couponLst=[SELECT ID, Name, ccrz__CouponCode__c, ccrz__TotalUsed__c, ccrz__MaxUse__c,ccrz__TargetQty__c FROM ccrz__E_Coupon__c WHERE ID IN : mapCouponIdQnty.KeySet()];
        for(ccrz__E_Coupon__c cc : couponLst) {
            if(cc.Id != null){
                if(mapCouponIdQnty.containsKey(cc.Id)){
                    cc.ccrz__TotalUsed__c= cc.ccrz__TotalUsed__c - mapCouponIdQnty.get(cc.Id);
                }
            }
        }
        
        if(!couponLst.IsEmpty()) { 
            system.debug('*****'+couponLst);
            update couponLst;
        }
        
        
        
    }
    
    public static void onAfterUpdateAutomatedProcessImplementation(List<ccrz__E_OrderItem__c> newOrderItemList, Map<Id, ccrz__E_OrderItem__c> oldMap)
    {
        Set<Id> setOrderItemId = new Set<Id>();
        for(ccrz__E_OrderItem__c orderItemObj :  newOrderItemList)
        {
            setOrderItemId.add(orderItemObj.Id);
            
        }
        List<ccrz__E_OrderItem__c> lstOrderItem = new List<ccrz__E_OrderItem__c>();
        Map<Id,ccrz__E_OrderItem__c> orderItemMap = new Map<Id,ccrz__E_OrderItem__c>();
        lstOrderItem = [Select Id,OMS_Product__c,ccrz__DisplayProduct__c,ccrz__DisplayProduct__r.Name,OSM_SW_Revoked_Basic_Key_Count__c,Tool_Instance_Count__c,OSM_SW_Revoked_Functional_Key_Count__c,OSM_SW_Is_OMS_Revoke_and_Cancel_Not_Done__c,isRenew__c,IsRevokeLicenseSucess__c,Date_Revoke__c,Revocation_Status__c,OSM_SW_Basic_Revocation_Pending__c,OSM_SW_Functional_Revocation_Pending__c,ccrz__OriginalQuantity__c,OSM_SW_Non_Insite_OSM_Product__c from ccrz__E_OrderItem__c where Id IN: setOrderItemId];
        for(ccrz__E_OrderItem__c obj : lstOrderItem)
            orderItemMap.put(obj.Id,obj);
        
        boolean needtoupdate = false;
        for(ccrz__E_OrderItem__c orderItemObj :  lstOrderItem)
        {
            if((orderItemObj.OSM_SW_Revoked_Basic_Key_Count__c != oldMap.get(orderItemObj.Id).OSM_SW_Revoked_Basic_Key_Count__c ||   orderItemObj.Tool_Instance_Count__c != oldMap.get(orderItemObj.Id).Tool_Instance_Count__c ) && orderItemObj.Tool_Instance_Count__c == 0 && orderItemObj.OSM_SW_Revoked_Basic_Key_Count__c == 0  && orderItemObj.OSM_SW_Revoked_Basic_Key_Count__c > 0 && orderItemObj.OSM_SW_Revoked_Functional_Key_Count__c > 0)
            {
                orderItemObj.IsRevokeLicenseSucess__c = true;
                needtoupdate = true;
            }
            
            
            if(orderItemObj.OMS_Product__c  && orderItemObj.OSM_SW_Is_OMS_Revoke_and_Cancel_Not_Done__c != oldMap.get(orderItemObj.Id).OSM_SW_Is_OMS_Revoke_and_Cancel_Not_Done__c && !orderItemObj.OSM_SW_Is_OMS_Revoke_and_Cancel_Not_Done__c && !orderItemObj.isRenew__c && orderItemObj.IsRevokeLicenseSucess__c )
            {
                orderItemObj.Date_Revoke__c = System.now();
                orderItemObj.Revocation_Status__c = 'Revoked';
                needtoupdate = true;
            }
            if(orderItemObj.ccrz__DisplayProduct__c != null && orderItemMap.containsKey(orderItemObj.Id)  &&  orderItemMap.get(orderItemObj.Id).ccrz__DisplayProduct__r.Name.containsIgnoreCase('INCAL') && orderItemObj.Revocation_Status__c != oldMap.get(orderItemObj.Id).Revocation_Status__c && orderItemObj.Revocation_Status__c == 'Revoked')
            {
                orderItemObj.Date_Revoke__c = System.now();
                needtoupdate = true;
            }
              
            
            if(orderItemObj.OMS_Product__c  && !orderItemObj.isRenew__c && orderItemObj.OSM_SW_Is_OMS_Revoke_and_Cancel_Not_Done__c && (orderItemObj.OSM_SW_Basic_Revocation_Pending__c > 0 || orderItemObj.OSM_SW_Functional_Revocation_Pending__c > 0) && 
            
            ((orderItemObj.OSM_SW_Basic_Revocation_Pending__c != oldMap.get(orderItemObj.Id).OSM_SW_Basic_Revocation_Pending__c ) || (orderItemObj.OSM_SW_Functional_Revocation_Pending__c != oldMap.get(orderItemObj.Id).OSM_SW_Functional_Revocation_Pending__c ) || (orderItemObj.OSM_SW_Revoked_Basic_Key_Count__c != oldMap.get(orderItemObj.Id).OSM_SW_Revoked_Basic_Key_Count__c ) || (orderItemObj.OSM_SW_Revoked_Functional_Key_Count__c != oldMap.get(orderItemObj.Id).OSM_SW_Revoked_Functional_Key_Count__c ) )
            
            &&
            
            (
                Math.ceil(orderItemObj.ccrz__OriginalQuantity__c) == (orderItemObj.OSM_SW_Functional_Revocation_Pending__c + orderItemObj.OSM_SW_Revoked_Functional_Key_Count__c)
            )

            &&
            
            (
                Math.ceil(orderItemObj.ccrz__OriginalQuantity__c) == (orderItemObj.OSM_SW_Basic_Revocation_Pending__c + orderItemObj.OSM_SW_Revoked_Basic_Key_Count__c) || orderItemObj.OSM_SW_Non_Insite_OSM_Product__c
            )
            
            &&
            
            orderItemObj.Revocation_Status__c != 'Revoke Initiated'




            )
            {
                orderItemObj.Revocation_Status__c = 'Revoke Initiated';
                needtoupdate = true;
            }
            
            
        }
        
        if(needtoupdate && lstOrderItem.size() > 0)
                update  lstOrderItem;
    }
     
    
    public static void OnAfterUpdateTotalUsedUpdate(List<ccrz__E_OrderItem__c> newOrderItemList, Map<Id, ccrz__E_OrderItem__c> oldMap) {
        List<ccrz__E_Coupon__c> couponLstToUpdate = new List<ccrz__E_Coupon__c>();
        Map<Id,Decimal> mapCouponIdQnty = new Map<Id,Decimal>();
        
        for(ccrz__E_OrderItem__c ordrItm : newOrderItemList){
            if(ordrItm.ccrz__StoreId__c != 'CSSNAStore' && ordrItm.OSM_SW_Coupon_Applied__c && ordrItm.OSM_SW_Coupon_Applied__c != oldMap.get(ordrItm.Id).OSM_SW_Coupon_Applied__c){
                mapCouponIdQnty.put(ordrItm.ccrz__Coupon__c,ordrItm.ccrz__Quantity__c);
            }
        }
        
        if(mapCouponIdQnty.size() > 0){
            for(ccrz__E_Coupon__c cc : [SELECT ID, Name, ccrz__CouponCode__c, ccrz__TotalUsed__c, ccrz__MaxUse__c,ccrz__TargetQty__c FROM ccrz__E_Coupon__c WHERE ID IN : mapCouponIdQnty.KeySet()]) {
                system.debug('Target=='+cc.ccrz__TargetQty__c+'==OredrItem qty'+mapCouponIdQnty.get(cc.Id)+'==TotalUsed__c=='+cc.ccrz__TotalUsed__c);
                if(mapCouponIdQnty.containsKey(cc.Id) && cc.ccrz__TargetQty__c >= mapCouponIdQnty.get(cc.Id)) {
                    cc.ccrz__TotalUsed__c = cc.ccrz__TotalUsed__c + mapCouponIdQnty.get(cc.Id) - 1;
                    couponLstToUpdate.add(cc);
                }
                else {
                    cc.ccrz__TotalUsed__c = cc.ccrz__TotalUsed__c + cc.ccrz__TargetQty__c - 1;
                    couponLstToUpdate.add(cc);
                }
            }
            if(couponLstToUpdate.size() > 0) {
                update couponLstToUpdate;
            }
        }       
    }
    
    public static void beforeUpdate(List<ccrz__E_OrderItem__c> newOrderItemList, Map<Id, ccrz__E_OrderItem__c> oldMap){
        /*Set<Id> set_CouponCode = new Set<Id>();     
        
        for(ccrz__E_OrderItem__c ordrItm : newOrderItemList){
            if(ordrItm.ccrz__StoreId__c != 'CSSNAStore' && ordrItm.OSM_SW_Coupon_Applied__c && ordrItm.OSM_SW_Coupon_Applied__c != oldMap.get(ordrItm.Id).OSM_SW_Coupon_Applied__c){
                set_CouponCode.add(ordrItm.ccrz__Coupon__c);
            }
        }
        if(set_CouponCode.size() > 0){
            Map<Id, ccrz__E_Coupon__c> map_CouponObjectRec = new Map<Id, ccrz__E_Coupon__c>([SELECT Id, ccrz__TargetQty__c FROM ccrz__E_Coupon__c WHERE Id IN : set_CouponCode]);
            
            for(ccrz__E_OrderItem__c item : newOrderItemList) {
                if(item.ccrz__StoreId__c != 'CSSNAStore' && item.OSM_SW_Coupon_Applied__c && item.OSM_SW_Coupon_Applied__c != oldMap.get(item.Id).OSM_SW_Coupon_Applied__c
                        && map_CouponObjectRec.size() > 0 && map_CouponObjectRec.containsKey(item.ccrz__Coupon__c)){
                    item.OSM_Coupon_Target_Quantity__c = map_CouponObjectRec.get(item.ccrz__Coupon__c).ccrz__TargetQty__c;
                }else{
                    item.OSM_Coupon_Target_Quantity__c = 0;
                }
            }
        }*/
    }     
}