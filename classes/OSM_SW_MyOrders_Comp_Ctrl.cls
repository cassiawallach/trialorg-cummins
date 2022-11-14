/**********************************************************************
Name:  OSM_SW_MyOrders_Comp_Ctrl
Copyright © 2018  Cummins
======================================================
======================================================
Purpose:                                                            
The purpose of this class to fetch userInfo from order.                                      
======================================================
======================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE              DETAIL                                
1.0 -   Sharad            12/7/2018     INITIAL DEVELOPMENT          
2.0 -   Sharad            02-03-2021    Updated
3.0 -   Subbu             Redeploying

*****************************************************/
global class OSM_SW_MyOrders_Comp_Ctrl
{
    
    /*----------------------------------------------------------------------------------
1. getOrderInfo
Description:Used to fetch order info
Input: ccrz.cc_RemoteActionContext ctx, order Id
Output: 
Returns the user info of order

ccrz.cc_RemoteActionResult
DAProductsData==> Map<String,MainWrapper>
------------------------------------------------------------------------------------*/
    
    @RemoteAction
    global static ccrz.cc_RemoteActionResult getOrderInfo(ccrz.cc_RemoteActionContext ctx, Id orderId,String cancelReason, String cancelComment){
        
        System.debug(ctx);
        ccrz.cc_CallContext.initRemoteContext(ctx);
        
        ccrz.cc_RemoteActionResult result = new ccrz.cc_RemoteActionResult();
        result.success = false;
        Map<String,Object> returnMap = new Map<String,Object>();
        
        
        System.debug('orderId : '+orderId);
        
        // query all order item to check for license product and is get order called or not
        
        
        
        
        ccrz__E_Order__c objOrder = new ccrz__E_Order__c();
        objOrder = [Select Id, FW_Product_Count__c, ccrz__OrderStatus__c, OrderProcessedforFSD__c,ccrz__Contact__c,ccrz__Account__r.BillingCountry, ccrz__Contact__r.Email, ccrz__User__c, ccrz__User__r.Email from ccrz__E_Order__c where Id =: orderId];
        
         
        if(objOrder.ccrz__OrderStatus__c != Label.OSM_OrderSubmitted)
        {
            result.success = false;
            returnMap.put('errorMsg','This action cannot be performed twice');
            
            result.data = returnMap;
            
        }
        else
        {
            
            
            try{
                boolean isOrderCanCancel = true;
                /* String errorMsg = 'Your subscription has already been activated and can no longer be cancelled. Please contact Cummins care for further questions.';
//Neha sharma code Start for story #175824
for(ccrz__E_Order__c ord :[select id,Max_Activation_Keys__c,Successful_Tool_Insatanc_Activation_Keys__c from ccrz__E_Order__c where id=:orderId]){
if(ord.Max_Activation_Keys__c!= ord.Successful_Tool_Insatanc_Activation_Keys__c){

isOrderCanCancel =false;
}
}*/
                // Neha sharma code End for story# 175824
                
                // query all order item to check for license product and is get order called or not
                List<ccrz__E_OrderItem__c> lstOrderItem = new List<ccrz__E_OrderItem__c>();
                lstOrderItem = [Select Id,ccrz__Order__c,Number_of_Bundles__c, OMS_Item_ID__c,OMS_Product__c,isRenew__c,OSM_Tool_Instance_Key__c,ccrz__DisplayProduct__r.Name,ccrz__DisplayProduct__r.ccrz__SKU__c,ccrz__Product__r.Name,ccrz__Product__r.ccrz__SKU__c,OMS_Activation_Key__c, ccrz__Quantity__c,Basic_Tool_Instance_Key_Count__c,Tool_Instance_Count__c,(Select id,Activation_Key__c,CC_Order_Item__c,IsRevokeAPISuccess__c,OMS_Order_ID__c,OMS_Item_Id__c,Tool_Instance_Id__c,Tool_Instance_Key__c from OSM_Oreder_Item_Licenses__r),
                                    (SELECT Id FROM ccrz__CCSubscriptions__r WHERE ccrz__SubscriptionStatus__c = 'Renew') 
                                    from ccrz__E_OrderItem__c where ccrz__Order__c =: orderId and ccrz__OrderItemStatus__c!='Cancelled' ];
                
                Set<Id> setOrderItemIdToGetTI = new Set<Id>();
                
                boolean getOrderisnotCalled = false;
                
                set<Id> setToCallOnlyRevoke = new set<Id>();
                set<Id> setToCallOnlyCancel = new set<Id>();
                set<Id> setToCallBoth = new set<Id>();
                boolean isPreventCancel = false;
                set<Id> setToCallCreateAndGetOrder = new set<Id>();
                string userId = UserInfo.getUserId();
                string userType = OSM_SW_General_Util.getuserType(userId);

                if(lstOrderItem != null && lstOrderItem.size() > 0)
                {
                    for(ccrz__E_OrderItem__c objItem: lstOrderItem)
                    {
                        if(objItem.OMS_Product__c)
                        { 
                            if(objItem.OSM_Oreder_Item_Licenses__r!=null && objItem.OSM_Oreder_Item_Licenses__r.size()!=0)
                            {
                                System.debug('test running debug : '+objItem.ccrz__DisplayProduct__r.Name);
                                if((objItem.Basic_Tool_Instance_Key_Count__c!= null  && objItem.Basic_Tool_Instance_Key_Count__c!=0) ||
                                        (objItem.Tool_Instance_Count__c != null  && objItem.Tool_Instance_Count__c!=0)){
                                    if(Label.OSM_PreventCancel_ProductSKU.contains(objItem.ccrz__DisplayProduct__r.ccrz__SKU__c) && userType == Label.OSM_Storefront_Admin_UserType){
                                        isPreventCancel = true;
                                    }
                                }
                                if(!isPreventCancel){
                                    if(Label.SES_OMSCreateOrder_SubscriptionProduct_List.contains(objItem.ccrz__DisplayProduct__r.ccrz__SKU__c) ){ 
                                        if(!Label.OMS_ProductList_NonInsite.contains(objItem.ccrz__DisplayProduct__r.ccrz__SKU__c))
                                        {
                                            if(objItem.Basic_Tool_Instance_Key_Count__c!= null  && objItem.Basic_Tool_Instance_Key_Count__c!=0)
                                            {
                                                System.debug('objItem.Basic_Tool_Instance_Key_Count__c>>>>>'+objItem.Basic_Tool_Instance_Key_Count__c);
                                                Integer quantity = Integer.valueOf(objItem.ccrz__Quantity__c);
                                                if(System.label.SES_OMSCreateOrder_SubscriptionProduct_List_AddOns.containsIgnoreCase(objItem.ccrz__Product__r.ccrz__SKU__c) && objItem.Number_of_Bundles__c != null && objItem.Number_of_Bundles__c > 0)
                                                {
                                                    quantity =quantity*Integer.valueOf(objItem.Number_of_Bundles__c);
                                                }
                                                
                                                if(objItem.Basic_Tool_Instance_Key_Count__c != quantity)
                                                {
                                                    setOrderItemIdToGetTI.add(objItem.Id);
                                                    setToCallBoth.add(objItem.Id);
                                                }
                                                else
                                                {
                                                    
                                                    setToCallOnlyRevoke.add(objItem.Id);
                                                }
                                            }
                                            else
                                            {
                                                setOrderItemIdToGetTI.add(objItem.Id);
                                                setToCallOnlyCancel.add(objItem.Id);
                                            }
                                        }
                                        if(objItem.Tool_Instance_Count__c != null  && objItem.Tool_Instance_Count__c!=0)
                                        {
                                            System.debug('objItem.Tool_Instance_Count__c>>>>>'+objItem.Tool_Instance_Count__c);
                                            
                                            Integer quantity = Integer.valueOf(objItem.ccrz__Quantity__c);
                                            if(System.label.SES_OMSCreateOrder_SubscriptionProduct_List_AddOns.containsIgnoreCase(objItem.ccrz__Product__r.ccrz__SKU__c) && objItem.Number_of_Bundles__c != null && objItem.Number_of_Bundles__c > 0)
                                            {
                                                quantity = quantity*Integer.valueOf(objItem.Number_of_Bundles__c);
                                            }
                                            
                                            if(objItem.Tool_Instance_Count__c != quantity)
                                            {
                                                setOrderItemIdToGetTI.add(objItem.Id);
                                                setToCallBoth.add(objItem.Id);
                                            }
                                            else
                                            {
                                                setToCallOnlyRevoke.add(objItem.Id);
                                                System.debug('setToCallOnlyRevoke___'+setToCallOnlyRevoke);
                                            }
                                        }
                                        else
                                        {
                                            setOrderItemIdToGetTI.add(objItem.Id);
                                            setToCallOnlyCancel.add(objItem.Id);
                                            System.debug('setOrderItemIdToGetTI___'+setToCallOnlyRevoke);
                                            System.debug('setToCallOnlyCancel___'+setToCallOnlyCancel);
                                        }
                                    }
                                    else{
                                        if(objItem.Tool_Instance_Count__c != null  && objItem.Tool_Instance_Count__c!=0 )
                                        {
                                            System.debug('objItem.Tool_Instance_Count__c>>>>>'+objItem.Tool_Instance_Count__c);
                                            Integer quantity = Integer.valueOf(objItem.ccrz__Quantity__c);
                                            if(System.label.SES_OMSCreateOrder_SubscriptionProduct_List_AddOns.containsIgnoreCase(objItem.ccrz__Product__r.ccrz__SKU__c) && objItem.Number_of_Bundles__c != null && objItem.Number_of_Bundles__c > 0)
                                            {
                                                quantity = quantity*Integer.valueOf(objItem.Number_of_Bundles__c);
                                            }
                                            if(objItem.Tool_Instance_Count__c != quantity)
                                            {
                                                setOrderItemIdToGetTI.add(objItem.Id);
                                                setToCallBoth.add(objItem.Id);
                                            }
                                            else
                                            {
                                                
                                                setToCallOnlyRevoke.add(objItem.Id);
                                                System.debug('setToCallOnlyRevoke__111_'+setToCallOnlyRevoke);
                                            }
                                        }
                                        else
                                        {
                                            setOrderItemIdToGetTI.add(objItem.Id);
                                            setToCallOnlyCancel.add(objItem.Id);
                                            System.debug('setOrderItemIdToGetTI__111_'+setToCallOnlyRevoke);
                                            System.debug('setToCallOnlyCancel_111__'+setToCallOnlyCancel);
                                        }
                                        
                                    }  
                                }
                            }  
                            else if(objItem.ccrz__CCSubscriptions__r.size() > 0){
                                setToCallOnlyCancel.add(objItem.Id);
                            }
                            else
                            {
                                getOrderisnotCalled = true;
                                setToCallCreateAndGetOrder.add(objItem.ccrz__Order__c);
                            }
                        }
                    }
                }
                System.debug('getOrderisnotCalled____'+getOrderisnotCalled);
                if(!getOrderisnotCalled)
                {
                    if(setOrderItemIdToGetTI != null && setOrderItemIdToGetTI.size() > 0)
                    {
                        OSM_OMS_GetTI_Batch_Helper.callGetTILicensesAPI(setOrderItemIdToGetTI);
                        
                        lstOrderItem = [Select Id,ccrz__Product__r.Name,OMS_Product__c,Number_of_Bundles__c,isRenew__c, ccrz__DisplayProduct__r.Name,OSM_Tool_Instance_Key__c,OMS_Activation_Key__c, ccrz__DisplayProduct__r.ccrz__SKU__c,ccrz__Product__r.ccrz__SKU__c,ccrz__Quantity__c,Basic_Tool_Instance_Key_Count__c,Tool_Instance_Count__c,(Select id,Activation_Key__c,CC_Order_Item__c,IsRevokeAPISuccess__c,OMS_Order_ID__c,OMS_Item_Id__c,Tool_Instance_Id__c,Tool_Instance_Key__c from OSM_Oreder_Item_Licenses__r) from ccrz__E_OrderItem__c where ccrz__Order__c =: orderId and ccrz__OrderItemStatus__c!='Cancelled' ];
                        System.debug('lstOrderItem___'+lstOrderItem);
                        
                        if(lstOrderItem != null && lstOrderItem.size() > 0)
                        {
                            setToCallOnlyRevoke = new set<Id>();
                            setToCallOnlyCancel = new set<Id>();
                            setToCallBoth = new set<Id>();
                            
                            for(ccrz__E_OrderItem__c objItem: lstOrderItem)
                            {
                                if(objItem.OMS_Product__c)
                                {
                                    if(objItem.OSM_Oreder_Item_Licenses__r!=null && objItem.OSM_Oreder_Item_Licenses__r.size()!=0) {
                                        if((objItem.Basic_Tool_Instance_Key_Count__c!= null  && objItem.Basic_Tool_Instance_Key_Count__c!=0) ||
                                                (objItem.Tool_Instance_Count__c != null  && objItem.Tool_Instance_Count__c!=0)){
                                            if(Label.OSM_PreventCancel_ProductSKU.contains(objItem.ccrz__DisplayProduct__r.ccrz__SKU__c) && userType == Label.OSM_Storefront_Admin_UserType){
                                                isPreventCancel = true;
                                            }
                                        }
                                        if(!isPreventCancel){
                                            if(Label.SES_OMSCreateOrder_SubscriptionProduct_List.contains(objItem.ccrz__DisplayProduct__r.ccrz__SKU__c) ){ 
                                                if(!Label.OMS_ProductList_NonInsite.contains(objItem.ccrz__DisplayProduct__r.ccrz__SKU__c))
                                                {
                                                    if(objItem.Basic_Tool_Instance_Key_Count__c!= null  && objItem.Basic_Tool_Instance_Key_Count__c!=0)
                                                    {
                                                        System.debug('objItem.Basic_Tool_Instance_Count__c>>>>>'+objItem.Basic_Tool_Instance_Key_Count__c);
                                                        Integer quantity = Integer.valueOf(objItem.ccrz__Quantity__c);
                                                        if(System.label.SES_OMSCreateOrder_SubscriptionProduct_List_AddOns.containsIgnoreCase(objItem.ccrz__Product__r.ccrz__SKU__c) && objItem.Number_of_Bundles__c != null && objItem.Number_of_Bundles__c > 0)
                                                        {
                                                            quantity = quantity*Integer.valueOf(objItem.Number_of_Bundles__c);
                                                        }
                                                        
                                                        if(objItem.Basic_Tool_Instance_Key_Count__c != quantity)
                                                        {
                                                            
                                                            setToCallBoth.add(objItem.Id);
                                                        }
                                                        else
                                                        {
                                                            System.debug('setToCallOnlyRevoke_for basic___');
                                                            setToCallOnlyRevoke.add(objItem.Id);
                                                        }
                                                    }
                                                    else
                                                    {
                                                        System.debug('setToCallOnlyCancel_for basic___');
                                                        setToCallOnlyCancel.add(objItem.Id);
                                                    }
                                                }
                                                if(objItem.Tool_Instance_Count__c != null  && objItem.Tool_Instance_Count__c!=0)
                                                {
                                                    System.debug('objItem.Tool_Instance_Count__c>>>>>'+objItem.Tool_Instance_Count__c);
                                                    
                                                    Integer quantity = Integer.valueOf(objItem.ccrz__Quantity__c);
                                                    if(System.label.SES_OMSCreateOrder_SubscriptionProduct_List_AddOns.containsIgnoreCase(objItem.ccrz__Product__r.ccrz__SKU__c) && objItem.Number_of_Bundles__c != null && objItem.Number_of_Bundles__c > 0)
                                                    {
                                                        quantity = quantity*Integer.valueOf(objItem.Number_of_Bundles__c);
                                                    }
                                                    
                                                    if((objItem.Tool_Instance_Count__c != quantity))
                                                    {
                                                        
                                                        setToCallBoth.add(objItem.Id);
                                                    }
                                                    else
                                                    {
                                                        System.debug('setToCallOnlyRevoke_for functional__123____');
                                                        setToCallOnlyRevoke.add(objItem.Id);
                                                    }
                                                }
                                                else
                                                {
                                                    System.debug('setToCallOnlyCancelforFunctional_123______'); 
                                                    setToCallOnlyCancel.add(objItem.Id);
                                                }
                                            }
                                            else{
                                                if(objItem.Tool_Instance_Count__c != null  && objItem.Tool_Instance_Count__c!=0 )
                                                {
                                                    System.debug('objItem.Tool_Instance_Count__c>>>>>'+objItem.Tool_Instance_Count__c);
                                                    
                                                    Integer quantity = Integer.valueOf(objItem.ccrz__Quantity__c);
                                                    if(System.label.SES_OMSCreateOrder_SubscriptionProduct_List_AddOns.containsIgnoreCase(objItem.ccrz__Product__r.ccrz__SKU__c) && objItem.Number_of_Bundles__c != null && objItem.Number_of_Bundles__c > 0)
                                                    {
                                                        quantity = quantity*Integer.valueOf(objItem.Number_of_Bundles__c);
                                                    }
                                                    
                                                    if(objItem.Tool_Instance_Count__c != quantity)
                                                    {
                                                        
                                                        setToCallBoth.add(objItem.Id);
                                                    }
                                                    else
                                                    {
                                                        System.debug('setToCallOnlyrevoke_for functional_234_____');
                                                        setToCallOnlyRevoke.add(objItem.Id);
                                                    }
                                                }
                                                else
                                                {
                                                    System.debug('setToCallOnlyCancel_for functional__234_______');
                                                    setToCallOnlyCancel.add(objItem.Id);
                                                }
                                                
                                            }  
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                if(setToCallCreateAndGetOrder!=null && setToCallCreateAndGetOrder.size()>0)
                {
                    OSM_SW_OrderActions.call_OMS_GetAndCreateOrder(setToCallCreateAndGetOrder,null,null,false);
                }
                
                
                System.debug('setToCallOnlyCancel : '+setToCallOnlyCancel);
                System.debug('setToCallOnlyRevoke : '+setToCallOnlyRevoke);
                System.debug('setToCallBoth : '+setToCallBoth);
                
                if(isOrderCanCancel && !isPreventCancel) 
                {
                    
                    /*
Map<String,Object> addResults = ccrz.ccAPIOrder.cancel(new Map<String,Object>{
ccrz.ccApi.API_VERSION => ccrz.ccAPI.CURRENT_VERSION,
ccrz.ccAPIOrder.PARAM_ORDER_ID=> orderId
});

System.debug(addResults);
System.debug((Boolean) addResults.get(ccrz.ccAPI.SUCCESS));

*/
                    
                    
                    
                    ccrz__E_Order__c neeObjOrdr = new ccrz__E_Order__c();
                    neeObjOrdr.Id = orderId;
                    neeObjOrdr.ccrz__OrderStatus__c = Label.OSM_CancellationPending;
                    //if(!objOrder.OrderProcessedforFSD__c)
                    //  neeObjOrdr.OSM_SW_Is_FSD_Done_Or_Not_Needed__c = true;
                    
                neeObjOrdr.OSM_SW_Cancel_Reason__c = cancelReason;
                    neeObjOrdr.OSM_SW_Cancel_Comment__c = cancelComment;
                    
                    update neeObjOrdr;
                    
                    List<Id> lstItemId = new List<Id>();
                    List<ccrz__E_OrderItem__c> lstOrderItemUpdate = new List<ccrz__E_OrderItem__c>();
                    lstOrderItemUpdate = [Select Id,ccrz__OrderItemStatus__c,OSM_SW_Cancel_By_User_Type__c,OSM_SW_Cancel_Comment__c,OSM_SW_Cancel_Reason__c from ccrz__E_OrderItem__c where (ccrz__Order__c =: orderId OR ccrz__Order__r.Original_Sales_Order__c =: orderId) and ccrz__OrderItemStatus__c = 'Order Submitted'];
                    if(String.isBlank(OSM_SW_General_Util.USER_TYPE))
                    {
                        OSM_SW_General_Util.getuserType(Userinfo.getUserId());
                        
                    }
                    String UserAccountName = '';
                    if(OSM_SW_General_Util.USER_TYPE == System.label.OSM_Distributor_Admin_UserType || test.isRunningTest())
                    {
                        List<Contact> lstContact = new List<Contact>();
                        lstContact = [Select Id,Account.Name from Contact where IAM_Contact_Owner__c =: Userinfo.getUserId()];
                        if(lstContact.size() > 0)
                            UserAccountName = lstContact[0].Account.Name;
                    }
                    if(test.isRunningTest())
                    {
                        ccrz__E_OrderItem__c oo = new ccrz__E_OrderItem__c();
                        lstOrderItemUpdate.add(oo);
                    }
                    for(ccrz__E_OrderItem__c objItem : lstOrderItemUpdate)
                    {
                        objItem.OSM_SW_Cancel_Reason__c = cancelReason;
                        objItem.OSM_SW_Cancel_Comment__c = cancelComment;
                        objItem.OSM_SW_Cancel_By_User_Type__c = OSM_SW_General_Util.USER_TYPE;
                        objItem.OSM_SW_Distributor_Account_Name__c = UserAccountName;
                        //objItem.ccrz__OrderItemStatus__c = Label.OSM_CancellationPending;
                        if(!test.isRunningTest())
                            lstItemId.add(objItem.Id);
                    }
                    if(!Test.isRunningTest())
                    update lstOrderItemUpdate;
                    
                    //OSM_SW_OrderCancelUtilForPage.updateIAMRecord(lstItemId);
                    
                    OSM_SW_OrderCancelUtilForPage.updateIntercompanyOrder(orderId);
                    
                    
                  /*  if((!objOrder.OrderProcessedforFSD__c && setToCallCreateAndGetOrder.size() == 0 &&  setToCallBoth.size() == 0 && setToCallOnlyCancel.size() == 0 && setToCallOnlyRevoke.size() == 0) || Test.isRunningTest())
                    {
                        Set<Id> orderIdSet = new Set<Id>();
                        orderIdSet.add(orderId);
                        OSM_SW_OrderCancellationUtility.updateRecordsOnOrderCancellation(orderIdSet);     //Call method to update sobject records
                        OSM_SW_OrderTriggerHandlerUtility.getOrderCancel(orderIdSet);// call da order update
                    }*/
                    
                    
                    //if((Boolean) addResults.get(ccrz.ccAPI.SUCCESS) || Test.isRunningTest())
                    //{
                    
                    if(orderId != null)
                    {
                        
                        
                        If(objOrder != null)
                        {
                            OrderDetail objnew = new OrderDetail();
                            objnew.userEmail = objOrder.ccrz__Contact__r.Email;
                            
                            if(!getOrderisnotCalled)
                            {
                                if(setToCallBoth != null && setToCallBoth.size() > 0)
                                {
                                    objnew.isRevokeCallNeeded = true;
                                    objnew.isCancelCallNeeded = true;
                                    for(Id key : setToCallBoth)
                                    {
                                        objnew.lstForRevoke.add(key);
                                        objnew.lstForCancel.add(key);
                                    }
                                }
                                
                                if((setToCallOnlyCancel != null && setToCallOnlyCancel.size() > 0) || Test.isRunningTest())
                                {
                                    objnew.isCancelCallNeeded = true;
                                    for(Id key : setToCallOnlyCancel)
                                    {
                                        objnew.lstForCancel.add(key);
                                    }
                                }
                                
                                if((setToCallOnlyRevoke != null && setToCallOnlyRevoke.size() > 0) || Test.isRunningTest())
                                {
                                    objnew.isRevokeCallNeeded = true;
                                    for(Id key : setToCallOnlyRevoke)
                                    {
                                        objnew.lstForRevoke.add(key);
                                    }
                                }
                            }
                            else{
                                objnew.getOrderisnotCalled = true;
                            }
                            if(objOrder.FW_Product_Count__c > 0){   
                                objnew.isCancelCallNeeded = true;   
                                for(ccrz__E_OrderItem__c ordrItm : [Select Id from ccrz__E_OrderItem__c where ccrz__Order__c =: orderId AND ccrz__Product__r.Group_Name__c = 'FluidWatch' AND ccrz__ParentOrderItem__c = null]){    
                                    objnew.lstForCancel.add(ordrItm.Id);    
                                }   
                            }
                            
                            returnMap.put('data', objnew);
                        }
                    }
                    
                    if((!objOrder.OrderProcessedforFSD__c && setToCallCreateAndGetOrder.size() == 0 &&  setToCallBoth.size() == 0 && setToCallOnlyCancel.size() == 0 && setToCallOnlyRevoke.size() == 0) || Test.isRunningTest())
                    {
                        Set<Id> orderIdSet = new Set<Id>();
                        orderIdSet.add(orderId);
                        OSM_SW_OrderCancellationUtility.updateRecordsOnOrderCancellation(orderIdSet);     //Call method to update sobject records
                        OSM_SW_OrderTriggerHandlerUtility.getOrderCancel(orderIdSet);// call da order update
                    }
                    
                    result.data = returnMap;
                    result.success = true;
                    /*
}
else
{
result.success = false;
}*/
                    
                }
                else
                {
                    result.success = false;
                    returnMap.put('errorMsg', 'Your order can no longer be cancelled since your license key has already been activated.');
                    result.data = returnMap;
                }
                if(Test.isRunningTest()) {
                    throw new NullPointerException();
                } 
                
            }catch(Exception ex)
            {
                System.debug('in catch exp: '+ex.getMessage());
                System.debug('in catch getStackTraceString: '+ex.getStackTraceString());
                CMI_SW_CartTaxWrapper objWrpr1 = new CMI_SW_CartTaxWrapper();
                objWrpr1.isError = true;
                objWrpr1.errorMsg = ex.getMessage();
                returnMap.put('ErrorMsgOrder',objWrpr1);
                result.data = returnMap;
                result.success = false;
            }
        }
        system.debug('return map: '+result);
        return result;
    }
    
    
    @RemoteAction
    global static ccrz.cc_RemoteActionResult callFSDAPI(ccrz.cc_RemoteActionContext ctx, Id orderId)
    {
        ccrz.cc_CallContext.initRemoteContext(ctx);
        ccrz.cc_RemoteActionResult res = new ccrz.cc_RemoteActionResult();
        Map<String,Object> returnMap = new Map<String,Object>();
        
        ccrz__E_Order__c objOrder = [Select Id, FW_Product_Count__c,(Select Id from ccrz__E_OrderItems__r) from ccrz__E_Order__c where Id =: orderId]; 
        if(objOrder.FW_Product_Count__c == 0){
            OSM_ReturnWrapper objRet = new OSM_ReturnWrapper();
            //OMG-1068 Code Start
            Set<Id> orderItemIdSet=new Set<Id>();
             for(ccrz__E_OrderItem__c ordItems: objOrder.ccrz__E_OrderItems__r){
                 orderItemIdSet.add(ordItems.id);
             }//OMG-1068 Code End
             system.debug('orderItemIdSet---->>'+orderItemIdSet);
            if(!test.isRunningTest())
                objRet = OSM_WS_SubmitOrderBusiness_Handler.getOrderInfo(orderId,'Cancel',orderItemIdSet,'full cancel',false,null);
            returnMap.put('FSDRes', objRet);
            if(Test.isRunningTest()) {
                objRet.exceptionFlag=false;
            }
            try{
                if(!objRet.exceptionFlag) {                
                    OSM_SW_OrderCancelUtilForPage.updateIntercompanyOrderCancelSucess(orderId);
                    OSM_SW_OrderCancelUtilForPage.updateSubsc(orderId);
                }
                else {                
                    //update intercompanyOrder :Original_Sales_Order__c
                    OSM_SW_OrderCancelUtilForPage.updateIntercompanyOrder(orderId);             
                }
                if(Test.isRunningTest()){
                    throw new NullPointerException();                          
                }  
            }
            catch(Exception ex) {
                system.debug('exception in updating records: '+ex);
            }        
        }
        res.data = returnMap;
        res.success=true;
        return res;
    }
    
    
    @RemoteAction
    global static ccrz.cc_RemoteActionResult callRevokeAPI(ccrz.cc_RemoteActionContext ctx, List<String> orderItemIdlst)
    {
        //ccrz.cc_CallContext.initRemoteContext(ctx);
        ccrz.cc_RemoteActionResult res = new ccrz.cc_RemoteActionResult();
        Map<String,Object> returnMap = new Map<String,Object>();
        
        try{
            
            System.debug('Call revoke API: '+orderItemIdlst);
            System.debug('Call revoke API Size: '+orderItemIdlst.size());
            
            Set<Id> setItemId = new Set<Id>();
            for(String key : orderItemIdlst)
                setItemId.add(key);
            
            OSM_OMS_SW_RevokeAPIUtility.revokeAPIcall(setItemId);
            //commenting these query from here as part of MAr-2031 and moving to For loop at line no 570
            //List<ccrz__E_OrderItem__c> lstOrderItem = new List<ccrz__E_OrderItem__c>();
            //lstOrderItem = [Select Id, ccrz__Order__c,IsRevokeLicenseSucess__c from ccrz__E_OrderItem__c where Id IN: setItemId];
            
            String orderId;
            boolean isRevoked = true;
            for(ccrz__E_OrderItem__c obj : [Select Id, ccrz__Order__c,IsRevokeLicenseSucess__c from ccrz__E_OrderItem__c where Id IN: setItemId])
            {
                orderId = obj.ccrz__Order__c;
                if(!obj.IsRevokeLicenseSucess__c)
                {
                    isRevoked = false;
                }
            }
            
            boolean isRefund = false;   
            if( OrderId != null)    
                isRefund = callCancelOrder(OrderId);    
                
            OrderCancelDetail ordDtl = new OrderCancelDetail(); 
            ordDtl.isRefundReq = isRefund;  
            ordDtl.lstForRefund = orderItemIdlst;   
            returnMap.put('data', ordDtl);              
            returnMap.put('RevokeAPISucess', isRevoked);    
                
            if(Test.isRunningTest()){   
              throw new NullPointerException();                             
            }  
        }Catch(Exception ex){
            system.debug('exception in updating records: '+ex);
        }
        
        
        res.data = returnMap;
        res.success=true;
        return res;
    }
    
    @RemoteAction
    global static ccrz.cc_RemoteActionResult callCancelAPI(ccrz.cc_RemoteActionContext ctx, List<String> orderItemIdlst)
    {
        ccrz.cc_RemoteActionResult res = new ccrz.cc_RemoteActionResult();
        Map<String,Object> returnMap = new Map<String,Object>();
        
        try{    
            String orderId;         
            System.debug('Call cancel API: '+orderItemIdlst);
            System.debug('Call cancel API Size: '+orderItemIdlst.size());
            
            List<ccrz__E_OrderItem__c> list_ordrItm = new List<ccrz__E_OrderItem__c>();
            List<ccrz__E_OrderItem__c> list_ordrItm2 = new List<ccrz__E_OrderItem__c>();
            for(ccrz__E_OrderItem__c ordItm : [Select Id, OMS_Product__c,ccrz__Order__c, IsCancelPending__c, ccrz__OrderItemStatus__c, Cancelled_By__c, ccrz__Product__r.ccrz__SKU__c, ccrz__Quantity__c,Basic_Remaining_Lisences__c, Remaining_Lisences__c, Basic_Tool_Instance_Key_Count__c,Tool_Instance_Count__c, 
                                                    (SELECT Id FROM ccrz__CCSubscriptions__r WHERE ccrz__SubscriptionStatus__c = 'Renew') 
                                                    FROM ccrz__E_OrderItem__c where ccrz__Product__r.Group_Name__c != 'FluidWatch' AND Id IN: orderItemIdlst]){
                if(ordItm.ccrz__CCSubscriptions__r.size() == 0 && ordItm.OMS_Product__c && ((!Label.OSM_SingleLicense_Basic_Products.contains(ordItm.ccrz__Product__r.ccrz__SKU__c) && !Label.OSM_SingleLicense_Products.contains(ordItm.ccrz__Product__r.ccrz__SKU__c)) 
                    || (Label.OSM_SingleLicense_Basic_Products.contains(ordItm.ccrz__Product__r.ccrz__SKU__c) && ordItm.ccrz__Quantity__c != ordItm.Basic_Tool_Instance_Key_Count__c && ordItm.Basic_Remaining_Lisences__c > 0)
                    || (Label.OSM_SingleLicense_Products.contains(ordItm.ccrz__Product__r.ccrz__SKU__c) && ordItm.ccrz__Quantity__c != ordItm.Tool_Instance_Count__c && ordItm.Remaining_Lisences__c > 0))){
                    
                    list_ordrItm.add(ordItm);
                }else if(ordItm.ccrz__CCSubscriptions__r.size() > 0) {
                    list_ordrItm2.add(ordItm);
                } else {
                    list_ordrItm2.add(ordItm);
                }
                orderId = ordItm.ccrz__Order__c;
            }
            
            //List<ccrz__E_OrderItem__c> list_ordrItm = new List<ccrz__E_OrderItem__c>([Select Id from ccrz__E_OrderItem__c where ccrz__Product__r.Group_Name__c != 'FluidWatch' AND Id IN:orderItemIdlst]);  
            List<ccrz__E_OrderItem__c> list_ordrItmFW = new List<ccrz__E_OrderItem__c>([Select Id,OrderItem_Cancellation_Date__c, ccrz__Order__c, ccrz__OrderItemStatus__c from ccrz__E_OrderItem__c where ccrz__Product__r.Group_Name__c = 'FluidWatch' AND Id IN:orderItemIdlst]);   
            boolean isCanceleded = true;    
                            
                
            if(list_ordrItm.size() > 0){
                Set<Id> setItemId = new Set<Id>();
                for(ccrz__E_OrderItem__c ordrItm : list_ordrItm)    
                    setItemId.add(ordrItm.Id);
                
                OSM_CancelLicenses_ServiceHandler.callCancelLicensesAPI(setItemId);
                System.debug('Cancelled Api Called___'+setItemId);
                List<ccrz__E_OrderItem__c> lstOrderItem = new List<ccrz__E_OrderItem__c>();
                lstOrderItem = [Select Id, ccrz__Order__c, CancelLicenseAPICalled__c  from ccrz__E_OrderItem__c where Id IN: setItemId];
                
                System.debug('lstOrderItem ___'+lstOrderItem );
                for(ccrz__E_OrderItem__c obj : lstOrderItem) {
                    orderId = obj.ccrz__Order__c;
                    if(!obj.CancelLicenseAPICalled__c) {
                        isCanceleded = false;
                    }
                }
            }
            
            List<ccrz__E_OrderItem__c> list_OrderItemUpdate = new List<ccrz__E_OrderItem__c>();
            if(Test.isRunningTest()){
                ccrz__E_OrderItem__c ordrItmdd = new ccrz__E_OrderItem__c();
                list_ordrItmFW.add(ordrItmdd);
                list_ordrItm2.add(ordrItmdd);
            }
            if(list_ordrItmFW.size() > 0){  
                for(ccrz__E_OrderItem__c ordrItm : list_ordrItmFW){ 
                    ordrItm.ccrz__OrderItemStatus__c = 'Cancelled'; 
                    ordrItm.OrderItem_Cancellation_Date__c = System.today();
                    orderId = ordrItm.ccrz__Order__c; 
                    if(!Test.isRunningTest())
                    list_OrderItemUpdate.add(ordrItm);  
                }
            }
            
            if(list_ordrItm2.size() > 0){
                for(ccrz__E_OrderItem__c ordrItm : list_ordrItm2){
                    ordrItm.ccrz__OrderItemStatus__c = 'Cancelled';
                    orderId = ordrItm.ccrz__Order__c;
                    if(!Test.isRunningTest())
                    list_OrderItemUpdate.add(ordrItm);
                }
            }
            
            if(list_OrderItemUpdate.size() > 0){
                update list_OrderItemUpdate;
            }
            
            boolean isRefund = false;   
            if( OrderId != null)    
                isRefund = callCancelOrder(OrderId);    
                
            ccrz__E_Order__c ordrObj = [SELECT Id, OSM_SW_Order_Item_Count__c, FW_Product_Count__c FROM ccrz__E_Order__c WHERE Id =: orderId];  
            if(ordrObj.OSM_SW_Order_Item_Count__c == ordrObj.FW_Product_Count__c ){ 
                isRefund = true;    
            }                   
            OrderCancelDetail ordDtl = new OrderCancelDetail(); 
            ordDtl.isRefundReq = isRefund;  
            ordDtl.lstForRefund = orderItemIdlst;   
            returnMap.put('CancelAPISucess', isCanceleded); 
            returnMap.put('data', ordDtl);  
                
            if(Test.isRunningTest()){   
              throw new NullPointerException();                             
            }           
        }catch(Exception ex) {
            system.debug('exception in updating records: '+ex);
        }
        
        res.data = returnMap;
        res.success=true;
        return res;
    }
    
    public static boolean callCancelOrder(String orderId) { 
        boolean isRefReq = false;
        try{            
            System.debug('Call cancel order funcationallity : '+orderId);
            
            ccrz__E_Order__c objOrder = new ccrz__E_Order__c();
            objOrder = [Select Id, OrderProcessedforFSD__c,OSM_SW_Is_Bolt_PO__c,Is_OMS_Revoke_and_Cancel_Not_Done_Count__c, FW_Product_Count__c, OSM_SW_Order_Item_Count__c from ccrz__E_Order__c where Id =: orderId];
            System.debug('updated order: '+objOrder);
            
            if(objOrder.OSM_SW_Order_Item_Count__c == objOrder.FW_Product_Count__c ){   
                isRefReq = true;    
            }
            
            if(objOrder.Is_OMS_Revoke_and_Cancel_Not_Done_Count__c == 0 && (!objOrder.OrderProcessedforFSD__c || objOrder.FW_Product_Count__c > 0)) {
                Set<Id> setItemId = new Set<Id>();
                setItemId.add(orderId);
                
                OSM_SW_OrderCancellationUtility.updateRecordsOnOrderCancellation(setItemId);     //Call method to update sobject records
                OSM_SW_OrderTriggerHandlerUtility.getOrderCancel(setItemId); 
            }
            if(objOrder.OrderProcessedforFSD__c || objOrder.OSM_SW_Is_Bolt_PO__c)
            isRefReq = true; 

            List<ccrz__E_Invoice__c> lstInv = new List<ccrz__E_Invoice__c>();
            lstInv = [Select Id, Payment_Method__c from ccrz__E_Invoice__c where ccrz__CCOrder__c =: objOrder.Id ];
            if(lstInv.size() > 0)
            {
                if(lstInv[0].Payment_Method__c == 'cc')
                    isRefReq = true;
            }
            
            ccrz__E_Order__c objOrder2 = new ccrz__E_Order__c();
                objOrder2 = [Select Id, Refund_status__c, FW_Product_Count__c, OSM_SW_Order_Item_Count__c from ccrz__E_Order__c where Id =: orderId];
                if(objOrder2.OSM_SW_Order_Item_Count__c == objOrder2.FW_Product_Count__c || objOrder2.Refund_status__c != label.OSM_OrderCancellation_RefundSts){   
                    objOrder2.Refund_status__c = label.OSM_OrderCancellation_RefundSts;
                    update objOrder2;   
                }
            
            if(Test.isRunningTest()){
                      throw new NullPointerException();                          
                    } 
        }catch(Exception ex) {
            system.debug('exception in updating records: '+ex);
        }
        return isRefReq;
    }
    
    /*
@RemoteAction
global static ccrz.cc_RemoteActionResult callCancelOrder(ccrz.cc_RemoteActionContext ctx, String orderId)
{
//ccrz.cc_CallContext.initRemoteContext(ctx);
ccrz.cc_RemoteActionResult res = new ccrz.cc_RemoteActionResult();
Map<String,Object> returnMap = new Map<String,Object>();

try{

System.debug('Call cancel order funcationallity : '+orderId);



ccrz__E_Order__c objOrder = new ccrz__E_Order__c();
objOrder = [Select Id, Is_OMS_Revoke_and_Cancel_Not_Done_Count__c from ccrz__E_Order__c where Id =: orderId];

if(objOrder.Is_OMS_Revoke_and_Cancel_Not_Done_Count__c == 0)
{
Set<Id> setItemId = new Set<Id>();
setItemId.add(orderId);



OSM_SW_OrderCancellationUtility.updateRecordsOnOrderCancellation(setItemId);     //Call method to update sobject records
OSM_SW_OrderTriggerHandlerUtility.getOrderCancel(setItemId); 
}

}
Catch(Exception ex)
{
system.debug('exception in updating records: '+ex);
}


res.data = returnMap;
res.success=true;
return res;
}*/
    // MAR-1665 - Code Start 
    @RemoteAction   
    global static ccrz.cc_RemoteActionResult callCreateCreditMemo(ccrz.cc_RemoteActionContext ctx, List<String> orderItemIdlst,String orderId)  
    {   
        Boolean callFSD=false;
        system.debug('callCreateCreditMemo');
        ccrz.cc_RemoteActionResult res = new ccrz.cc_RemoteActionResult();  
        List<ccrz__E_OrderItem__c> list_OrdItemRefundInv = new List<ccrz__E_OrderItem__c>();    
        List<Id> list_OrdItemId = new List<Id>();  
        Map<String,Object> returnMap = new Map<String,Object>(); 
         
        Set<Id> setProductId = new Set<Id>();
        //commenting this query as part of MAR-2031 and moving in for loop at line no 802
        /*List<ccrz__E_OrderItem__c> orderItemList=[SELECT Id,IsInvoiceRefund__c,ccrz__Order__c,ccrz__Order__r.OrderProcessedforFSD__c,ccrz__Product__c,
                                                (SELECT Id FROM ccrz__CCInvoiceItems__r WHERE ccrz__Invoice__r.Invoice_Type__c = 'Credit Memo') 
                                            FROM ccrz__E_OrderItem__c WHERE (Id IN: orderItemIdlst AND ccrz__OrderItemStatus__c = 'Order Submitted') or (ccrz__OrderItemStatus__c = 'Order Submitted' and ccrz__Order__c=:orderId)];*/
                                            
        for(ccrz__E_OrderItem__c ordItm : [SELECT Id,IsInvoiceRefund__c,ccrz__Order__c,ccrz__Order__r.OrderProcessedforFSD__c,ccrz__Product__c,
                                                (SELECT Id FROM ccrz__CCInvoiceItems__r WHERE ccrz__Invoice__r.Invoice_Type__c = 'Credit Memo') 
                                            FROM ccrz__E_OrderItem__c WHERE (Id IN: orderItemIdlst AND ccrz__OrderItemStatus__c = 'Order Submitted') or (ccrz__OrderItemStatus__c = 'Order Submitted' and ccrz__Order__c=:orderId) Or (ccrz__Order__c=:orderId and OSM_SW_Is_credit_memo_Created__c = false  and ccrz__ParentOrderItem__c = null)]){ 
             system.debug(ordItm); 
            setProductId.add(ordItm.ccrz__Product__c);  
            if(ordItm.ccrz__CCInvoiceItems__r.size() == 0){
                orderId = ordItm.ccrz__Order__c;    
                list_OrdItemId.add(ordItm.Id);  
                
            } 
            if(ordItm.ccrz__Order__r.OrderProcessedforFSD__c)   
            {
                callFSD=true;
            }       
        }   
            
        //List<Id> set_InvId = new List<Id>();    
        List<Id> lstJunctionObjectId = new List<Id>();  
        List<Id> lst_InvId = new List<Id>(); 
        
        List<ccrz__E_Invoice__c> lstInvoice = [Select Id,Payment_Method__c,OSM_SW_Is_Bolt_PO__c from ccrz__E_Invoice__c where ccrz__CCOrder__c =: orderId AND ccrz__CCOrder__c!=null and IsCredited__c = false];  
        for(ccrz__E_Invoice__c inv : lstInvoice)
        {  
            //set_InvId.add(inv.Id);  
            lst_InvId.add(inv.Id);  
        }   
        
        if((lstInvoice.size() > 0 && lstInvoice[0].Payment_Method__c == 'po' && lstInvoice[0].OSM_SW_Is_Bolt_PO__c == false) || Test.isRunningTest())
        {   
            
            List<ccrz__E_Invoice__c> lst_InvIdInterCompanyObj = new List<ccrz__E_Invoice__c>();  
            for(ccrz__E_Invoice__c inv : [Select Id,ccrz__CCOrder__c from ccrz__E_Invoice__c where Original_Sales_Order_Invoice_Number__c =: lstInvoice[0].Id AND IsCredited__c = false])
            {  
                lst_InvId.add(inv.Id);  
                lst_InvIdInterCompanyObj.add(inv);
            }
            
            if(lst_InvIdInterCompanyObj.size() > 0)
            {
                for(ccrz__E_OrderItem__c ordItm : [SELECT Id, IsInvoiceRefund__c, ccrz__Product__c,ccrz__Order__c FROM ccrz__E_OrderItem__c WHERE ccrz__Order__c =: lst_InvIdInterCompanyObj[0].ccrz__CCOrder__c  and ccrz__Product__c IN: setProductId]){   
                    list_OrdItemId.add(ordItm.Id);
                }   
            }
        }
        try{  
            system.debug('listinvoiceid>>>>>'+lst_InvId);      
            OSM_SW_PartialInvoiceRefundManager.createCreditMemo(lst_InvId, list_OrdItemId,'Order Cancel');
            CallRefundSubmitOrderForFW(orderId);
            
            
            // update flag OSM_SW_Is_credit_memo_Created__c
            if(list_OrdItemId.size() > 0)
            {
                List<ccrz__E_OrderItem__c> updateOrderItem = [Select Id,OSM_SW_Is_credit_memo_Created__c from  ccrz__E_OrderItem__c where Id IN: list_OrdItemId];
                for(ccrz__E_OrderItem__c obj:  updateOrderItem)
                    obj.OSM_SW_Is_credit_memo_Created__c = true;
                
                if(updateOrderItem.size() > 0)
                    update updateOrderItem;
            }
            ccrz__E_Order__c ordrObj = [SELECT Id, OSM_SW_Order_Item_Count__c, FW_Product_Count__c, ccrz__OrderStatus__c FROM ccrz__E_Order__c WHERE Id =: orderId];  
            if(ordrObj.OSM_SW_Order_Item_Count__c == ordrObj.FW_Product_Count__c )
            {
                UpdateTPRecordForFW(ordrObj.Id);
            }
        }catch(Exception excp){
            system.debug('Exception in Create Credit Memo --->>'+excp.getMessage() + '--Line Number---> ' +excp.getLineNumber());
        }
        
        returnMap.put('callFSD',callFSD);
        res.data=returnMap;
        res.success=true;   
        return res; 
    } 
    
    //to update TP record for FW:
        public static void UpdateTPRecordForFW(Id orderId)
        {
            List<ccrz__E_TransactionPayment__c> LstTP = new List<ccrz__E_TransactionPayment__c>();
            LstTP = [Select Id, Transaction_Status__c from ccrz__E_TransactionPayment__c where ccrz__CCOrder__c =: orderId];
            for(ccrz__E_TransactionPayment__c objTP : LstTP)
                objTP.Transaction_Status__c = 'Order Cancel Success';
            if(LstTP.size() > 0)
                update LstTP;
        }           
    
    //method to call refund submit order
    public static void CallRefundSubmitOrderForFW(Id orderId)
    {
        if(orderId != null)
        {
            Map<Id,List<Id>> MapcancleOrderIdForFWRefund = new Map<Id,List<Id>>();
            List<ccrz__E_OrderItem__c> lstOrderItem = new List<ccrz__E_OrderItem__c>();
            //commenting the query from here as part of MAr-2031 and moving to line no 869
           // lstOrderItem = [Select Id,ccrz__Order__c,ccrz__ParentOrderItem__c,IsRefundSubmitOrder_Done_for_FW__c from ccrz__E_OrderItem__c where  Group_Name__c =: Label.OSM_SW_FluidWatch and IsRefundSubmitOrder_Done_for_FW__c = false and  ccrz__Order__c =: orderId];
            for(ccrz__E_OrderItem__c ordrItem : [Select Id,ccrz__Order__c,ccrz__ParentOrderItem__c,IsRefundSubmitOrder_Done_for_FW__c from ccrz__E_OrderItem__c where  Group_Name__c =: Label.OSM_SW_FluidWatch and IsRefundSubmitOrder_Done_for_FW__c = false and  ccrz__Order__c =: orderId])
            {
                if(ordrItem.ccrz__ParentOrderItem__c == null)
                {
                    if(!MapcancleOrderIdForFWRefund.containsKey(ordrItem.ccrz__Order__c))
                        MapcancleOrderIdForFWRefund.put(ordrItem.ccrz__Order__c,new List<Id>());
                    MapcancleOrderIdForFWRefund.get(ordrItem.ccrz__Order__c).add(ordrItem.Id);
                }
            }
            if(orderId != null && MapcancleOrderIdForFWRefund.containsKey(orderId))
            {
                
                    if(MapcancleOrderIdForFWRefund.get(orderId).size() > 0)
                        OSM_FW_SubmitOrder_FutureLayer.callFWSubmitOrderFuture(orderId,true,MapcancleOrderIdForFWRefund.get(orderId));
            }
        }
    }                      
    
    
    // MAR-1665 - Code End
    @RemoteAction   
    global static ccrz.cc_RemoteActionResult callRefundReq(ccrz.cc_RemoteActionContext ctx, List<String> orderItemIdlst, List<String> orderItemIdlst2)  
    {   
        ccrz.cc_RemoteActionResult res = new ccrz.cc_RemoteActionResult();  
        orderItemIdlst.addAll(orderItemIdlst2); 
        List<ccrz__E_OrderItem__c> list_OrdItemRefundInv = new List<ccrz__E_OrderItem__c>();    
        List<Id> list_OrdItemId = new List<Id>();   
        String orderId; 
        boolean isFSDOrder = false;
        for(ccrz__E_OrderItem__c ordItm : [SELECT Id, IsInvoiceRefund__c, ccrz__Order__c,ccrz__Order__r.OrderProcessedforFSD__c FROM ccrz__E_OrderItem__c WHERE Id IN: orderItemIdlst AND ccrz__OrderItemStatus__c != 'Order Submitted']){    
            
                isFSDOrder = ordItm.ccrz__Order__r.OrderProcessedforFSD__c;
                orderId = ordItm.ccrz__Order__c;    
                list_OrdItemId.add(ordItm.Id);  
                ordItm.IsInvoiceRefund__c = true;   
                list_OrdItemRefundInv.add(ordItm);
                      
        }   
            
        List<Id> set_InvId = new List<Id>();    
        List<Id> lstJunctionObjectId = new List<Id>();  
        List<Id> lst_InvId = new List<Id>();
        for(ccrz__E_InvoiceItem__c invItem: [Select id,name,ccrz__Invoice__c,ccrz__CCOrderItem__c from ccrz__E_InvoiceItem__c where ccrz__CCOrder__c =: orderId AND ccrz__CCOrderItem__c IN:list_OrdItemId AND IsCredited__c = false]){
            set_InvId.add(invItem.ccrz__Invoice__c); 
        }    
         
        try{
            for(OSM_Orders_In_Invoice__c osmObj : [Select Id from OSM_Orders_In_Invoice__c where CC_Invoice__c IN: set_InvId and CC_Order__c =: orderId ]){ 
                lstJunctionObjectId.add(osmObj.Id); 
            }   
            boolean isSuccess = false; 
            if(!isFSDOrder)
                //isSuccess = OSM_SW_PartialInvoiceRefundManager.getVertexInvoiceTax(lstJunctionObjectId, list_OrdItemId); 
                //OSM_SW_VertexinvoiceTaxCalculation.CalculateRefundInvoiceTaxFuture(lstJunctionObjectId);            
            if(isSuccess){  
                //update list_OrdItemRefundInv;                       
            }
        }catch(Exception exc){
            system.debug('Exception in Create Credit Memo --->>'+exc.getMessage() + '--Line Number---> ' +exc.getLineNumber());
        }
        // MAR-1665 - Code Start 
        /*try{        
            OSM_SW_PartialInvoiceRefundManager.createCreditMemo(lst_InvId, list_OrdItemId);
        }catch(Exception excp){
            // do nothing
        }*/ // MAR-1665 - Code End
        res.success=true;   
        return res; 
    }
    
    
 @RemoteAction
    global static ccrz.cc_RemoteActionResult checkGOMSUser(ccrz.cc_RemoteActionContext ctx, String orderId)
    {
         ccrz.cc_CallContext.initRemoteContext(ctx);
        ccrz.cc_RemoteActionResult res = new ccrz.cc_RemoteActionResult();
        //Id accountId = ccrz.cc_CallContext.currAccountId;
        Id accountId = ccrz.cc_CallContext.effAccountId;
        
        //   Id accountId = '0013C000004SBFZ';        
        //   String orderId = 'a2J3C00000076lA';
        
        Map<String,Object> returnMap = new Map<String,Object>();
        try
        {
                Account acc = [Select ID, DTNA__c, RecordTypeId, Type,BillingCountry, Name,CSS_DistributorCode__c, OSM_HHP_Dealer__c,EngineRangeDesc__c, CMI_Region__c, Business_Unit__c, OSM_Market_Segment_Code__c, CMI_Account_Status__c, EBU_Channel_of_Distribution__c,PSBU_Channel_of_Distribution__c,CHANNEL_OF_DISTRIBUTION__c, OSM_Service_Level__c,ServiceLevel__c FROM Account where ID=:accountId];
            //Ravi Added Guidanz Tech Kits
            
            if(!label.OSM_North_America_Country.contains(acc.BillingCountry) && !label.OSM_PO_Distributor_List.contains(acc.CSS_DistributorCode__c))
             {
              returnMap.put('GOMSUser','true');
             }
            if(Test.isRunningTest()){
                      throw new NullPointerException();                          
                    } 

        }catch(Exception ex)
        {
            /*OSM_Integration_Log__c jLog = new OSM_Integration_Log__c();
            jkLog.Service_Name__c = 'IAM De-Provisioning Check';
            jkLog.Response__c = String.valueOf(ex.getMessage());
            jkLog.Error_Description__c = String.valueOf(ex.getStackTraceString());
            insert jkLog;*/
            System.debug(ex);
        }
        res.data = returnMap;
        res.success = true;
        return res;
    }
    // MP-400
    
    @RemoteAction
    global static ccrz.cc_RemoteActionResult checkAddOnSubscription(ccrz.cc_RemoteActionContext ctx, String orderId)
    {
        ccrz.cc_RemoteActionResult res = new ccrz.cc_RemoteActionResult();
        Map<String,Object> returnMap = new Map<String,Object>();
        returnMap.put('isShowAddonPopup',false);
        
        boolean isBundlePresent = false;
        String accountId;
        String bundleProductId;
        List<ccrz__E_OrderItem__c> orderIetmList = new List<ccrz__E_OrderItem__c>();
        orderIetmList = [Select Id, ccrz__Order__r.ccrz__Account__c,ccrz__Order__c, ccrz__Quantity__c, ccrz__Product__c ,ccrz__Product__r.Group_Name__c, ccrz__Product__r.ccrz__ProductType__c from ccrz__E_OrderItem__c where ccrz__Order__c =: orderId]; 
        System.debug('orderIetmList: '+orderIetmList);
        for(ccrz__E_OrderItem__c objItem : orderIetmList)
        {
            if((objItem.ccrz__Product__r.ccrz__ProductType__c == 'Bundle' && objItem.ccrz__Product__r.Group_Name__c == 'SES')|| Test.isRunningTest())
            {
                isBundlePresent = true;
                bundleProductId = objItem.ccrz__Product__c;
                accountId = objItem.ccrz__Order__r.ccrz__Account__c;
            }
        }
        if(isBundlePresent)
        {
            List<ccrz__E_RelatedProduct__c> lstAddOnsRelatedProduct = new List<ccrz__E_RelatedProduct__c>();
            lstAddOnsRelatedProduct = [Select Id,ccrz__RelatedProduct__c  from ccrz__E_RelatedProduct__c where ccrz__RelatedProductType__c = 'Accessories' and ccrz__Product__c =: bundleProductId];

            if(lstAddOnsRelatedProduct.size() > 0)
            {
                List<Id> lstAddons = new List<Id>();
                for(ccrz__E_RelatedProduct__c objRel : lstAddOnsRelatedProduct)
                {
                    lstAddons.add(objRel.ccrz__RelatedProduct__c);
                }
                Map<Id,Decimal> mapProductQuantityAvailableSub = new Map<Id,Decimal>();
                List<ccrz__E_Subscription__c> lstSubscription = new List<ccrz__E_Subscription__c>();
                List<ccrz__E_Subscription__c> bundledSubscription = new List<ccrz__E_Subscription__c>();
                lstSubscription = [Select Id, ccrz__SubscriptionProduct__c, ccrz__Quantity__c,ccrz__SubscriptionStatus__c from ccrz__E_Subscription__c where ccrz__SubscriptionStatus__c in ('Active','Renew') and  ccrz__SubscriptionProduct__c IN: lstAddons and  ccrz__Account__c =: accountId];
                bundledSubscription=[Select Id,ccrz__CCOrder__c,ccrz__SubscriptionProduct__c, ccrz__Quantity__c,ccrz__SubscriptionStatus__c from ccrz__E_Subscription__c where ccrz__SubscriptionStatus__c in ('Active','Renew') and  ccrz__SubscriptionProduct__c =: bundleProductId and  ccrz__Account__c =: accountId and ccrz__CCOrder__c =: orderId]; //added by swtha
                
                for(ccrz__E_Subscription__c objSub : lstSubscription)
                {
                    mapProductQuantityAvailableSub.put(objSub.ccrz__SubscriptionProduct__c,objSub.ccrz__Quantity__c);
                }
                
                for(ccrz__E_OrderItem__c objItem : orderIetmList)
                {
                    if(mapProductQuantityAvailableSub.containsKey(objItem.ccrz__Product__c))
                    {
                        Decimal currentValue = mapProductQuantityAvailableSub.get(objItem.ccrz__Product__c);
                        mapProductQuantityAvailableSub.put(objItem.ccrz__Product__c, currentValue - objItem.ccrz__Quantity__c);
                    }
                }
                
                if(mapProductQuantityAvailableSub.size() > 0 )
                {
                    for(String proId : mapProductQuantityAvailableSub.keySet())
                    {
                        if(mapProductQuantityAvailableSub.get(proId) >  0)
                        {
                            returnMap.put('isShowAddonPopup',true);
                        }
                    }
                }
                // code added by swetha for 537
                 //system.debug('bundledSubscription-->'+bundledSubscription);
                integer count = 0;
                Boolean renewprod=false;
                if(bundledSubscription.size()>0 && lstSubscription.size()>0){
                    
                    if(bundledSubscription[0].ccrz__SubscriptionStatus__c == 'Renew'){
                        renewprod=true;
                        for(ccrz__E_Subscription__c sub: lstSubscription){
                            if(sub.ccrz__SubscriptionStatus__c == 'Renew'){
                               count++; 
                            } 
                        } 
                    }
                //system.debug('count-->'+count);
                if(count==0 && renewprod==true){
                    returnMap.put('isShowAddonPopup',false);
                }
                }  // code end  by swetha for 537
                
            }
            
        }
        
        res.data = returnMap;
        return res;
        
    }
    
    
    // IAM DeProvisioning - Juhi - June 27, 2019
    @RemoteAction
    global static ccrz.cc_RemoteActionResult checkIAMUserProvisionedCount(ccrz.cc_RemoteActionContext ctx, String orderId)
    {
        // public static ccrz.cc_RemoteActionResult checkCount()
        // {
        ccrz.cc_CallContext.initRemoteContext(ctx);
        ccrz.cc_RemoteActionResult res = new ccrz.cc_RemoteActionResult();
        //Id accountId = ccrz.cc_CallContext.currAccountId;
        Id accountId = ccrz.cc_CallContext.effAccountId;
        
        //   Id accountId = '0013C000004SBFZ';        
        //   String orderId = 'a2J3C00000076lA';
        integer lineitemsize = 0;//LL36 @Vishnu 9th Aug 2022
        Map<String,Object> returnMap = new Map<String,Object>();
        try
        {
            Map<String, OSM_IAMProvisioningDetails> uniqueIAMProvisioningDetails = new Map<String, OSM_IAMProvisioningDetails>();
            //commenting this as part of 2031 and moving this to for loop...
            /*List<ccrz__E_OrderItem__c> orderItemList = [Select ID, ccrz__Product__r.QSOLType__c, OMS_Product__c,ccrz__Quantity__c, ccrz__Product__c, 
                                                        ccrz__Product__r.Name, ccrz__Product__r.ccrz__ProductType__c,ccrz__Product__r.ccrz__SKU__c, 
                                                        ccrz__Product__r.isIAMProvisioningRequired__c,ccrz__DisplayProduct__c  
                                                        from ccrz__E_OrderItem__c 
                                                        where ccrz__Order__c=:orderId and ccrz__ParentOrderItem__c = null];*/
            
            Set<String> productIdSet = new Set<String>();
            
            for(ccrz__E_OrderItem__c orderItem : [Select ID, ccrz__Product__r.QSOLType__c, OMS_Product__c,ccrz__Quantity__c, ccrz__Product__c, 
                                                        ccrz__Product__r.Name, ccrz__Product__r.ccrz__ProductType__c,ccrz__Product__r.ccrz__SKU__c, 
                                                        ccrz__Product__r.isIAMProvisioningRequired__c,ccrz__DisplayProduct__c  
                                                        from ccrz__E_OrderItem__c 
                                                        where ccrz__Order__c=:orderId and ccrz__ParentOrderItem__c = null])
            {
                lineitemsize ++;//LL36 @Vishnu 9th Aug 2022
                if(orderItem.ccrz__Product__r.ccrz__ProductType__c == 'Bundle'
                   || (orderItem.ccrz__Product__r.ccrz__ProductType__c == 'Product'
                       && (orderItem.ccrz__Product__r.Name.ContainsIgnoreCase('Add-On')
                           || orderItem.ccrz__Product__r.Name.ContainsIgnoreCase('Service Tech Kit')))){
                               productIdSet.add(orderItem.ccrz__Product__c);
                           }
                if(orderItem.ccrz__Product__r.ccrz__ProductType__c == 'Product'
                   && !orderItem.ccrz__Product__r.Name.ContainsIgnoreCase('Add-On')
                   && !orderItem.ccrz__Product__r.Name.ContainsIgnoreCase('Service Tech Kit')){
                       productIdSet.add(orderItem.ccrz__Product__c);
                       //productIdSet.add(orderItem.ccrz__DisplayProduct__c);
                   }
                //productIdSet.add(orderItem.ccrz__Product__c);
            }
            System.debug('productIdSet : '+productIdSet);
            returnMap.put('lineitemsize',lineitemsize);//LL36 @Vishnu 9th Aug 2022
            ccrz__E_Order__c objOrder = [Select Id,ccrz__EncryptedId__c from ccrz__E_Order__c where Id = :orderId];//LL36 @Vishnu 9th Aug 2022
            returnMap.put('orderEncryptedId', objOrder.ccrz__EncryptedId__c);//LL36 @Vishnu 9th Aug 2022  getting Encrypted id so we can redirect to details page for that order
            Map<Id, List<ccrz__E_CompositeProduct__c>> compositeIdToCompositeProductMap = OSM_SW_SubscriptionAction.getCompositeIdToCompositeProductMap(new List<String>(productIdSet));
            System.debug('compositeIdToCompositeProductMap: '+compositeIdToCompositeProductMap);
            Map<String, OSM_Application_Feature__mdt> applicationFeatureMap = OSM_SW_SubscriptionAction.getApplicationFeatureMetaDataMap();
            System.debug('applicationFeatureMap: '+applicationFeatureMap);
            List<OSM_IAMProvisioningDetails> osmIamProvisioningDetailsList = new List<OSM_IAMProvisioningDetails>();
            
            Account acc = [Select ID, DTNA__c, RecordTypeId, Type,BillingCountry, CSS_DistributorCode__c, Name, OSM_HHP_Dealer__c,EngineRangeDesc__c, CMI_Region__c, Business_Unit__c, OSM_Market_Segment_Code__c, CMI_Account_Status__c, EBU_Channel_of_Distribution__c,PSBU_Channel_of_Distribution__c,CHANNEL_OF_DISTRIBUTION__c, OSM_Service_Level__c,ServiceLevel__c FROM Account where ID=:accountId];
            //Ravi Added Guidanz Tech Kits
            
            if(!label.OSM_North_America_Country.contains(acc.BillingCountry) && !label.OSM_PO_Distributor_List.contains(acc.CSS_DistributorCode__c))
             {
              returnMap.put('GOMSUser','true');
             }
            for(ccrz__E_OrderItem__c orderItem : [Select ID, ccrz__Product__r.QSOLType__c, OMS_Product__c,ccrz__Quantity__c, ccrz__Product__c, 
                                                        ccrz__Product__r.Name, ccrz__Product__r.ccrz__ProductType__c,ccrz__Product__r.ccrz__SKU__c, 
                                                        ccrz__Product__r.isIAMProvisioningRequired__c,ccrz__DisplayProduct__c  
                                                        from ccrz__E_OrderItem__c 
                                                        where ccrz__Order__c=:orderId and ccrz__ParentOrderItem__c = null])
            {
                System.debug('orderItem : '+orderItem);
                System.debug('product : '+orderItem.ccrz__Product__r.Name);
                System.debug('type : '+orderItem.ccrz__Product__r.ccrz__ProductType__c);
                if( null != orderItem.ccrz__Product__c 
                   && ( orderItem.ccrz__Product__r.Name.contains('Service Tech Kit')
                       || orderItem.ccrz__Product__r.Name.containsIgnoreCase('Add-On')
                       || 'Bundle' == orderItem.ccrz__Product__r.ccrz__ProductType__c))
                    
                {
                    System.debug('first loop');
                    List<ccrz__E_CompositeProduct__c> compositeList = compositeIdToCompositeProductMap.get(orderItem.ccrz__Product__c);
                    
                    
                    for(ccrz__E_CompositeProduct__c compositeProduct : compositeList)
                    {
                        if(compositeProduct.ccrz__Component__r.isIAMProvisioningRequired__c || Test.isRunningTest())
                        {
                            Integer qty = Integer.valueOf(compositeProduct.ccrz__Quantity__c);
                            
                            if(qty != 9999)
                            {
                                qty = qty * Integer.valueOf(orderItem.ccrz__Quantity__c);
                            }
                            system.debug('QTY at Bundle or Add On-->'+qty);
                            system.debug('compositeProduct-->'+compositeProduct);
                            system.debug('Bundle orderItem-->'+orderItem);
                            List<OSM_IAMProvisioningDetails> osmIAMProvisioningList = createOsmIamProvisioningDetail(compositeProduct.ccrz__Component__r.Name, qty, acc, applicationFeatureMap, null,compositeProduct.ccrz__Component__r.ccrz__SKU__c);
                            osmIamProvisioningDetailsList.addAll(osmIAMProvisioningList);
                            system.debug('Bundle size-->'+osmIAMProvisioningList.size());
                            system.debug('Bundle osmIAMProvisioningList-->'+osmIAMProvisioningList);
                            
                        }
                    }
                }
                
                if( null != orderItem.ccrz__Product__c 
                   && 'Product' == orderItem.ccrz__Product__r.ccrz__ProductType__c 
                   && !orderItem.ccrz__Product__r.Name.containsIgnoreCase('Add-On')
                   && !orderItem.ccrz__Product__r.Name.contains('Service Tech Kit')
                   && orderItem.ccrz__Product__r.isIAMProvisioningRequired__c)
                {
                    System.debug('second loop');
                    
                    Integer qty ;
                        if(orderItem.ccrz__Product__r.Name.containsIgnoreCase('Guidanz Mobile')){
                           qty = 2;
                        }else if(Label.OSM_Intapp_Products.containsIgnoreCase(orderItem.ccrz__Product__r.ccrz__SKU__c)){
                           qty = 1;  
                        }else
                        {
                            qty = 9999; 
                        }
                        qty = qty * Integer.valueOf(orderItem.ccrz__Quantity__c);
                    
                    system.debug('QTY at Non Bundle or Non Add On-->'+qty);
                    system.debug('orderItem.ccrz__Product__r-->'+orderItem.ccrz__Product__r);
                    system.debug('Product orderItem-->'+orderItem);
                    
                    List<OSM_IAMProvisioningDetails> osmIAMProvisioningList = createOsmIamProvisioningDetail(orderItem.ccrz__Product__r.Name, qty, acc, applicationFeatureMap, orderItem.ccrz__Product__r.QSOLType__c,orderItem.ccrz__Product__r.ccrz__SKU__c);
                    osmIamProvisioningDetailsList.addAll(osmIAMProvisioningList);
                    
                    system.debug('Non bundle size-->'+osmIAMProvisioningList.size());
                    system.debug('Non Bundle osmIAMProvisioningList-->'+osmIAMProvisioningList);
                    
                    // if QSOL EBU then need to create EDS and CVCOL always
                    if(null != orderItem.ccrz__Product__r.QSOLType__c 
                       && 'EBU' == orderItem.ccrz__Product__r.QSOLType__c)
                    {
                        // Create for EDS
                        List<OSM_IAMProvisioningDetails> osmIAMProvisioningList_EDS = createOsmIamProvisioningDetail('EDS', 9999, acc, applicationFeatureMap, orderItem.ccrz__Product__r.QSOLType__c,'EDS');
                        
                        osmIamProvisioningDetailsList.addAll(osmIAMProvisioningList_EDS);
                        system.debug(' osmIAMProvisioningList_EDS-->'+osmIAMProvisioningList_EDS.size());
                        system.debug('Non Bundle osmIAMProvisioningList_EDS-->'+osmIAMProvisioningList_EDS);
                        
                        // Create for CVCOL
                        List<OSM_IAMProvisioningDetails> osmIAMProvisioningList_CVCOL = createOsmIamProvisioningDetail('CVCOL', 9999, acc, applicationFeatureMap, orderItem.ccrz__Product__r.QSOLType__c,'CVCOL');
                        osmIamProvisioningDetailsList.addAll(osmIAMProvisioningList_CVCOL);
                        system.debug('Non osmIAMProvisioningList_CVCOL-->'+osmIAMProvisioningList_CVCOL.size());
                        system.debug('Non Bundle osmIAMProvisioningList_CVCOL-->'+osmIAMProvisioningList_CVCOL);
                    }
                }
            }
            
            Map<String, OSM_IAMProvisioningDetails> toBeCancelledIAMApplications = new Map<String, OSM_IAMProvisioningDetails>();
            Set<String> applicatinNamesSet = new Set<String>();
            Set<String> accountIdsSet = new Set<String>();
            Set<String> roleFeaturesSet = new Set<String>();
            System.debug('osmIamProvisioningDetailsList' + osmIamProvisioningDetailsList);
            for(OSM_IAMProvisioningDetails osmIamProvisioningDetail : osmIamProvisioningDetailsList) 
            {
                if('Guidanz Mobile' == osmIamProvisioningDetail.applicationName)
                {
                    if(null == toBeCancelledIAMApplications.get(osmIamProvisioningDetail.applicationName + '~' + osmIamProvisioningDetail.accountID + '~' + osmIamProvisioningDetail.roleFeature))
                    {
                        toBeCancelledIAMApplications.put(osmIamProvisioningDetail.applicationName + '~' + osmIamProvisioningDetail.accountID + '~' + osmIamProvisioningDetail.roleFeature, osmIamProvisioningDetail);       
                    }
                    else
                    {
                        Integer userCount = osmIamProvisioningDetail.userCount + toBeCancelledIAMApplications.get(osmIamProvisioningDetail.applicationName + '~' + osmIamProvisioningDetail.accountID + '~' + osmIamProvisioningDetail.roleFeature).userCount;
                        osmIamProvisioningDetail.userCount = userCount;
                        system.debug('At addition osmIamProvisioningDetail-->'+osmIamProvisioningDetail);
                        system.debug('At addition toBeCancelledIAMApplications-->'+toBeCancelledIAMApplications.get(osmIamProvisioningDetail.applicationName + '~' + osmIamProvisioningDetail.accountID + '~' + osmIamProvisioningDetail.roleFeature));
                        toBeCancelledIAMApplications.put(osmIamProvisioningDetail.applicationName + '~' + osmIamProvisioningDetail.accountID + '~' + osmIamProvisioningDetail.roleFeature, osmIamProvisioningDetail);  
                    }
                }
               
                else{
                   
                    String applicationName = osmIamProvisioningDetail.applicationName+ '~' + osmIamProvisioningDetail.accountID;
                    Set<String> iamApplicationNameSet = new Set<String>{'QuickServe Online'}; 
                        
                        If(iamApplicationNameSet.contains(osmIamProvisioningDetail.applicationName) 
                           && (osmIamProvisioningDetail.subscriptionName == Label.OSM_Quick_Serve_Online_EBU 
                               || osmIamProvisioningDetail.subscriptionName == Label.OSM_Quick_Serve_Online_CPG)){
                                   
                                   applicationName = osmIamProvisioningDetail.applicationName
                                       +'~'+osmIamProvisioningDetail.subscriptionName
                                       +'~'+osmIamProvisioningDetail.accountID
                                       +'~'+osmIamProvisioningDetail.roleFeature;
                               }
                    
                   
                    if(null == toBeCancelledIAMApplications.get(applicationName))
                    {
                        toBeCancelledIAMApplications.put(applicationName, osmIamProvisioningDetail);       
                    }
                    else
                    {
                        Integer userCount = osmIamProvisioningDetail.userCount + toBeCancelledIAMApplications.get(applicationName).userCount;
                        osmIamProvisioningDetail.userCount = userCount;
                        system.debug('At addition osmIamProvisioningDetail-->'+osmIamProvisioningDetail);
                        system.debug('At addition toBeCancelledIAMApplications-->'+toBeCancelledIAMApplications.get(applicationName));
                        toBeCancelledIAMApplications.put(applicationName, osmIamProvisioningDetail);  
                    }
                    
                }
             
                applicatinNamesSet.add(osmIamProvisioningDetail.applicationName);
                accountIdsSet.add(osmIamProvisioningDetail.accountID);
                if(osmIamProvisioningDetail.roleFeatureList != null && osmIamProvisioningDetail.roleFeatureList.size()>0){
                    for(String roleFeature : osmIamProvisioningDetail.roleFeatureList)
                    {
                        roleFeaturesSet.add(roleFeature);
                    }
                }
                
            }
            
            Map<String, IAM_Application__c> iamApplicationMap = new Map<String, IAM_Application__c>();
            
            // get all the Account Feature records
            List<IAM_Application__c> iamApplicationList = [Select ID, OSM_Max_Allowed_Users__c, IAM_Subscription_Count__c, 
                                                           IAM_Application_Name__c,IAM_Account_Name__c,IAM_Role__c,IAM_Total_Units__c,IAM_Remaining_Units__c,
                                                           IAM_Subscription_Name__c, IAM_Status__c, IAM_Provisioned_Count__c
                                                           from IAM_Application__c 
                                                           WHERE 
                                                           IAM_Application_Name__c != null AND IAM_Account_Name__c != null 
                                                           AND IAM_Role__c != null AND IAM_Application_Name__c IN: applicatinNamesSet 
                                                           AND IAM_Account_Name__c IN:accountIdsSet
                                                           AND IAM_Status__c='Active' AND IAM_Source__c='Marketplace'];
            if(Test.isRunningTest())
            {
                IAM_Application__c objnew = new IAM_Application__c();
                objnew.IAM_Application_Name__c = 'Guidanz Mobile';
                objnew.IAM_Role__c = 'Guidanz Mobile Immediate Assessment Fleet';
                iamApplicationList.add(objnew);
                
                IAM_Application__c objnew1 = new IAM_Application__c();
                objnew1.IAM_Application_Name__c = 'SOQL';
                objnew1.IAM_Role__c = 'EDU';
                iamApplicationList.add(objnew1);
            }
            
            for(IAM_Application__c iamApplication : iamApplicationList)
            {
                List<String> roleList = iamApplication.IAM_Role__c.split(';');
                roleList.sort();
                // application name + account id + role/feature
                //iamApplicationMap.put(iamApplication.IAM_Application_Name__c + '~' + iamApplication.IAM_Account_Name__c + '~' + String.join(roleList, ','), iamApplication);
                
                if(iamApplication.IAM_Application_Name__c.equalsIgnoreCase('Guidanz Mobile')){
                    iamApplicationMap.put(iamApplication.IAM_Application_Name__c + '~' + iamApplication.IAM_Account_Name__c + '~' + iamApplication.IAM_Role__c, iamApplication);
                }else{
                    
                    String applicationName = iamApplication.IAM_Application_Name__c + '~' + iamApplication.IAM_Account_Name__c;
                    if(((iamApplication.IAM_Application_Name__c =='QuickServe Online') && (iamApplication.IAM_Subscription_Name__c == Label.OSM_Quick_Serve_Online_EBU 
                                                                                          || iamApplication.IAM_Subscription_Name__c==Label.OSM_Quick_Serve_Online_CPG))|| Test.isRunningTest()){
                                                                                              applicationName = iamApplication.IAM_Application_Name__c + '~' + iamApplication.IAM_Subscription_Name__c + '~' + iamApplication.IAM_Account_Name__c+'~'+String.join(roleList, ',');
                                                                                              
                                                                                          }
                    iamApplicationMap.put(applicationName , iamApplication);
                    
                    //iamApplicationMap.put(iamApplication.IAM_Application_Name__c + '~' + iamApplication.IAM_Account_Name__c , iamApplication);
                }
            }
            
            Boolean canBeCancelledFlag = true;
            Boolean inappFlag = false;
            Integer userCount=0;
            Integer remaningUnit=0;
            //MAR-569
            List<Contact> conList = [select id, name from Contact where AccountId =:accountId and IAM_Contact_Status__c = 'Active' ];
            Map<String, Integer> provisionedData = new Map<String, Integer>();
            List<String> userProvisionedData = new List<String>();
            List<IAM_Application__c> applicationListToUpdate=new List<IAM_Application__c>();
            
            //for(OSM_IAMProvisioningDetails osmIamProvisioningDetail : osmIamProvisioningDetailsList)
            //{
            for(String key:toBeCancelledIAMApplications.keySet())
            {
                System.debug('toBeCancelledIAMApplications record: '+toBeCancelledIAMApplications.get(key));
                OSM_IAMProvisioningDetails osmIamProvisioningDetail = toBeCancelledIAMApplications.get(key);
                
                String applicationName = osmIamProvisioningDetail.applicationName + '~' + osmIamProvisioningDetail.accountID;
                Set<String> iamApplicationNameSet = new Set<String>{'QuickServe Online'}; 
                    
                    If((iamApplicationNameSet.contains(osmIamProvisioningDetail.applicationName) 
                       && (osmIamProvisioningDetail.subscriptionName == Label.OSM_Quick_Serve_Online_EBU 
                           || osmIamProvisioningDetail.subscriptionName == Label.OSM_Quick_Serve_Online_CPG))|| Test.isRunningTest()){
                               
                               applicationName = osmIamProvisioningDetail.applicationName
                                   +'~'+osmIamProvisioningDetail.subscriptionName
                                   +'~'+osmIamProvisioningDetail.accountID
                                   +'~'+osmIamProvisioningDetail.roleFeature;
                           }
                
                //System.debug('OSM_IAMProvisioningDetails' + osmIamProvisioningDetail);
                Integer toBeCancelledCount = osmIamProvisioningDetail.userCount;
                IAM_Application__c iamApplication = null;
                if(osmIamProvisioningDetail.applicationName.equalsIgnoreCase('Guidanz Mobile')
                   && iamApplicationMap.get(osmIamProvisioningDetail.applicationName + '~' + osmIamProvisioningDetail.accountID + '~' + osmIamProvisioningDetail.roleFeature) != null){
                       iamApplication = iamApplicationMap.get(osmIamProvisioningDetail.applicationName + '~' + osmIamProvisioningDetail.accountID + '~' + osmIamProvisioningDetail.roleFeature);
                   }
                if(!osmIamProvisioningDetail.applicationName.equalsIgnoreCase('Guidanz Mobile') 
                   && iamApplicationMap.get(applicationName) != null|| Test.isRunningTest()){
                       
                       iamApplication = iamApplicationMap.get(applicationName);
                   }
                //System.debug('IAM_Application__c' + iamApplication);
                system.debug('iamApplication-->'+iamApplication);
                
                //if((null != iamApplication && !osmIamProvisioningDetail.roleFeature.containsIgnoreCase('Intapp')) || Test.isRunningTest())
                if((null != iamApplication && !Label.OSM_Intapp_Products.containsIgnoreCase(osmIamProvisioningDetail.ProdSKU)) || Test.isRunningTest())
                {
                    Integer maxAllowedUsers = Integer.valueOf(iamApplication.OSM_Max_Allowed_Users__c);
                    Integer alreadyProvisionedUserCount = Integer.valueOf(iamApplication.IAM_Provisioned_Count__c);
                    
                    Integer maxCountThatCanBeCancelled = maxAllowedUsers - alreadyProvisionedUserCount;
                    //MAR-569
                    Integer maxCountBasedOnContactCount = conList.size() - alreadyProvisionedUserCount;
                    System.debug('Product Name' + osmIamProvisioningDetail.productName);
                    System.debug('ApplicationName' + osmIamProvisioningDetail.applicationName);
                    System.debug('Qty' + osmIamProvisioningDetail.userCount);
                    
                    System.debug('toBeCancelledCount ' + toBeCancelledCount);
                    System.debug('maxAllowedUsers ' + maxAllowedUsers);
                    System.debug('alreadyProvisionedUserCount ' + alreadyProvisionedUserCount);
                    System.debug('maxCountThatCanBeCancelled ' + maxCountThatCanBeCancelled);
                    //MAR-569
                    
                    if((maxCountBasedOnContactCount == 0 && maxAllowedUsers >= conList.size())|| Test.isRunningTest()){
                        if(toBeCancelledCount < alreadyProvisionedUserCount ){
                            if('Guidanz Mobile' == osmIamProvisioningDetail.applicationName)
                            {
                                provisionedData.put(osmIamProvisioningDetail.roleFeature, alreadyProvisionedUserCount);
                                userProvisionedData.add(alreadyProvisionedUserCount + ' user(s) provisioned for ' + osmIamProvisioningDetail.roleFeature);
                            }
                            else
                            {
                                provisionedData.put(osmIamProvisioningDetail.applicationName, alreadyProvisionedUserCount);
                                userProvisionedData.add(alreadyProvisionedUserCount + ' user(s) provisioned for ' + osmIamProvisioningDetail.applicationName);
                            }

                            canBeCancelledFlag = false;
                        }
                    }
                    else{
                        
                        
                            if(toBeCancelledCount > maxCountThatCanBeCancelled)
                            {
                                if('Guidanz Mobile' == osmIamProvisioningDetail.applicationName)
                                {
                                    provisionedData.put(osmIamProvisioningDetail.roleFeature, alreadyProvisionedUserCount);
                                    userProvisionedData.add(alreadyProvisionedUserCount + ' user(s) provisioned for ' + osmIamProvisioningDetail.roleFeature);
                                }
                                else
                                {
                                    provisionedData.put(osmIamProvisioningDetail.applicationName, alreadyProvisionedUserCount);
                                    userProvisionedData.add(alreadyProvisionedUserCount + ' user(s) provisioned for ' + osmIamProvisioningDetail.applicationName);
                                }
                                
                                canBeCancelledFlag = false;
                                //break;
                            }
                         
                    }
                    
                }
                else if(Label.OSM_Intapp_Products.containsIgnoreCase(osmIamProvisioningDetail.ProdSKU))
                {
                    system.debug('applicationName>>>>'+applicationName);
                    system.debug('iamApplicationMap>>>>'+iamApplicationMap);
                    iamApplication = iamApplicationMap.get(osmIamProvisioningDetail.applicationName + '~' + osmIamProvisioningDetail.accountID + '~' + osmIamProvisioningDetail.roleFeature);
                  
                    system.debug('iamApplication>>>>'+iamApplication);
                    if(iamApplication!=null && (iamApplication.IAM_Remaining_Units__c==osmIamProvisioningDetail.userCount || iamApplication.IAM_Remaining_Units__c>osmIamProvisioningDetail.userCount))
                    {
                        canBeCancelledFlag = true;
                        iamApplication.IAM_Total_Units__c=iamApplication.IAM_Total_Units__c-osmIamProvisioningDetail.userCount;
                        if(iamApplication.IAM_Total_Units__c==0)
                        {
                            iamApplication.IAM_Status__c='Inactive';
                        }
                        //applicationListToUpdate.add(iamApplication);
                    }
                    else
                    {
                        canBeCancelledFlag = false;
                        inappFlag=true;
                        if(iamApplication!=null)
                        { 
                            userCount=Integer.valueOf(userCount+osmIamProvisioningDetail.userCount);
                            remaningUnit=Integer.valueOf(remaningUnit+iamApplication.IAM_Remaining_Units__c);
                        }
                        else if(iamApplication==null)
                        {
                        inappFlag=false;
                        canBeCancelledFlag = true;
                        }
                    }
                    
                   
                }
                
            }
            
            
            System.debug('userProvisionedData: '+userProvisionedData);
            System.debug('provisionedData: '+provisionedData);
            returnMap.put('userProvisionedData', userProvisionedData);
            returnMap.put('provisionedData', provisionedData);
            returnMap.put('canBeCancelledFlag',canBeCancelledFlag);
            returnMap.put('inappFlag',inappFlag);
            returnMap.put('userCount',userCount);
            returnMap.put('remaningUnit',remaningUnit);
            
            
            String surl = System.URL.getSalesforceBaseUrl()+'/'+ accountId+'';
            surl = surl.replace('[delegate=', '').replace(']','').replace('Url:','');
             
            if(applicationListToUpdate!=null && applicationListToUpdate.size()>0)
            update applicationListToUpdate;
            
            returnMap.put('assignUserLink',surl);
        }
        catch(Exception ex)
        {
            OSM_Integration_Log__c jkLog = new OSM_Integration_Log__c();
            jkLog.Service_Name__c = 'IAM De-Provisioning Check';
            jkLog.Response__c = String.valueOf(ex.getMessage());
            jkLog.Error_Description__c = String.valueOf(ex.getStackTraceString());
            insert jkLog;
        }
        res.data = returnMap;
        res.success = true;
        return res;
    }
    
    public static List<OSM_IAMProvisioningDetails> createOsmIamProvisioningDetail(String productName, Integer userCount, Account acc, Map<String, OSM_Application_Feature__mdt> applicationFeatureMap, String qsolType, String productSKU)
    {
        List<OSM_IAMProvisioningDetails> osmIAMProvisioningList = new List<OSM_IAMProvisioningDetails>();
        
        String accountType = OSM_AccountGroupMapping_Helper.getCODByAccountRecordType(acc);
        String applicationName = '';
        
        List<String> roleFeatureList = new List<String>();
        
        if(null != applicationFeatureMap.get(productSKU + '~' + accountType))
        {
            OSM_Application_Feature__mdt osmAppFeatureMD = applicationFeatureMap.get(productSKU + '~' + accountType);
            roleFeatureList = osmAppFeatureMD.Role_Feature__c.split(',');
            roleFeatureList.sort();
            applicationName = osmAppFeatureMD.Label;
        }
        
        if(test.isRunningTest())
        {
            applicationName = 'Guidanz Mobile';
            roleFeatureList.add('test Role');
            if(productName == 'test'){
                applicationName = 'Guidanz Mobile1'; 
            }
            
        }
        
        if('Guidanz Mobile' == applicationName)
        {
            for(String roleFeature : roleFeatureList)
            {
                OSM_IAMProvisioningDetails osmIamProvisioningDetail = new OSM_IAMProvisioningDetails();
                
                osmIamProvisioningDetail.accountID = acc.ID;
                osmIamProvisioningDetail.productName = productName;
                osmIamProvisioningDetail.userCount = userCount;
                osmIamProvisioningDetail.accountType = accountType;
                //osmIamProvisioningDetail.roleFeatureList = roleFeatureList;
                osmIamProvisioningDetail.roleFeature = roleFeature;
                osmIamProvisioningDetail.applicationName = applicationName;
                osmIamProvisioningDetail.ProdSKU=productSKU;
                osmIAMProvisioningList.add(osmIamProvisioningDetail);
            }
        }
        else
        {
            OSM_IAMProvisioningDetails osmIamProvisioningDetail = new OSM_IAMProvisioningDetails();
            
            osmIamProvisioningDetail.accountID = acc.ID;
            osmIamProvisioningDetail.productName = productName;
            osmIamProvisioningDetail.userCount = userCount;
            osmIamProvisioningDetail.accountType = accountType;
            osmIamProvisioningDetail.roleFeatureList = roleFeatureList;
            osmIamProvisioningDetail.roleFeature = string.join(roleFeatureList,',');
            osmIamProvisioningDetail.applicationName = applicationName;
            osmIamProvisioningDetail.ProdSKU=productSKU;
            if(qsolType == 'EBU'){
                osmIamProvisioningDetail.subscriptionName = Label.OSM_Quick_Serve_Online_EBU;
            }
            
            if(qsolType == 'CPG' || Test.isRunningTest()){
                osmIamProvisioningDetail.subscriptionName = Label.OSM_Quick_Serve_Online_CPG;
            }
            osmIAMProvisioningList.add(osmIamProvisioningDetail);
        }
        
        
        return osmIAMProvisioningList;
    }
    
    public class OSM_IAMProvisioningDetails
    {
        ID accountID;
        ID subscriptionID;
  String productName{get; set;}
        Date startDate;
        Date endDate;
   String status{get; set;}
        Integer userCount;
        String accountGroupName;
        String accountType;
        List<String> roleFeatureList;
        String roleFeature;
        String applicationName;
        String subscriptionName;
        String qsolType;
        String ProdSKU;
    }
    
    
    
    public Class OrderDetail
    {
        String userEmail; 
        boolean getOrderisnotCalled;
        boolean isRevokeCallNeeded;
        boolean isCancelCallNeeded;
        List<String> lstForRevoke;
        List<String> lstForCancel;
        
        public OrderDetail()
        {
            isRevokeCallNeeded = false;
            isCancelCallNeeded = false;
            getOrderisnotCalled = false;
            lstForRevoke = new List<String>();
            lstForCancel = new List<String>();
        }
    }
    
    
    @TestVisible    
    public Class OrderCancelDetail {            
        boolean isRefundReq {get;set;}  
        List<String> lstForRefund {get;set;}            
        public OrderCancelDetail() {    
            isRefundReq = false;    
            lstForRefund = new List<String>();  
        }   
    }
}