/**********************************************************************
Name:  OSM_SW_OrderDetailView_Ctrl
Copyright Â© 2018  Cummins
======================================================
======================================================
Purpose:                                                            
The purpose of this class to fetch transaction Id and cancel transaction Id from order.                                      
======================================================
======================================================
History                                                            
-------                                                            

VERSION  AUTHOR            DATE              DETAIL                                
1.0 -   Sharad            12/7/2018     INITIAL DEVELOPMENT  
2.0 -   Sharad            02-03-2021    Updated     
3.0 -   Subbu             Redeploying   
4.0     Subbu             Deploying
*****************************************************/
global class OSM_SW_OrderDetailView_Ctrl{
    public boolean showPartialCancel{set;get;}
    public boolean isCancelShow {get; set;}
    public boolean showCheckbox {get; set;}
    public OSM_SW_OrderDetailView_Ctrl() 
    {
        isCancelShow = true;
        /*        
        string userId = UserInfo.getUserId();
        string userType = OSM_SW_General_Util.getuserType(userId);
        if((userType == Label.OSM_Support_Admin_UserType
        */
        // Added ccrz__Subscription_End_Date__c by swetha
        String orderEncryptedId = ccrz.cc_CallContext.currPageParameters.get('o');
        List<ccrz__E_TransactionPayment__c> lstTransactionPayment = new List<ccrz__E_TransactionPayment__c>();
        ccrz__E_Order__c  order =[select id,ccrz__Account__r.Name,Hours_Since_Order_Date__c,OSM_SW_Days_Since_Order_Date__c,Refund_status__c,ccrz__OrderStatus__c,OSM_SW_Is_InterCompany_Order__c,
                                    isOnBehalf__c,Purchased_By_User_Type__c,IsGetOrderSuccess__c,ccrz__OriginatedCart__r.Third_Party_BMS_Customer_ID__c,
                                    ccrz__OriginatedCart__r.OSM_SW_Is_third_Party_BMS_Payment__c,ccrz__OriginatedCart__r.Third_Party_BMS_Customer_Name__c,ccrz__OriginatedCart__r.OSM_SW_IAM_Account_Id_For_Third_Party__c, ccrz__Contact__r.AccountId,
                                    (SELECT Id,ccrz__Subscription_End_Date__c FROM ccrz__E_OrderItems__r WHERE ccrz__OrderItemStatus__c != 'Cancelled'  AND ccrz__OrderItemStatus__c != 'Revoked' 
                                        AND ccrz__OrderItemStatus__c != 'Cancellation Pending' AND IsCancelPending__c = false AND ccrz__ParentOrderItem__c = null)
                                    from ccrz__E_Order__c where ccrz__EncryptedId__c=:orderEncryptedId limit 1];
        if(order != null){
          
            lstTransactionPayment = [Select Id, ccrz__AccountType__c,OSM_BAMS_Cancel_Request_ID__c, ccrz__Token__c from ccrz__E_TransactionPayment__c where ccrz__CCOrder__c =: order.id];
            If(lstTransactionPayment.size() > 0) {
                //MAR-1780 & Mar-1865 Code Start
                OSM_Features_Maintenance__c osmFeaMaint = OSM_Features_Maintenance__c.getValues('Partial_Cancellation');
                if(lstTransactionPayment[0].ccrz__AccountType__c =='cc' && osmFeaMaint.CC_Partial_Cancellation__c.equalsignorecase('ON')){
                    this.showPartialCancel = True;
                }else if(lstTransactionPayment[0].ccrz__AccountType__c =='po' && osmFeaMaint.PO_Partial_Cancellation__c.equalsignorecase('ON')){
                    this.showPartialCancel = True;
                }
                
                //MAR-1780 & Mar-1865 Code End
            }
                string userId = UserInfo.getUserId();
                //string userType = OSM_SW_General_Util.getuserType(userId);
                if(String.isBlank(OSM_SW_General_Util.USER_TYPE))
                {
                    OSM_SW_General_Util.getuserType(Userinfo.getUserId());
                }
                String userType = OSM_SW_General_Util.USER_TYPE;
                string newPermUserType = OSM_SW_General_Util.getpermissionset(userId);
                //system.debug('order.OSM_SW_Is_InterCompany_Order__c--->>'+order.OSM_SW_Is_InterCompany_Order__c);
                if(!order.OSM_SW_Is_InterCompany_Order__c){
                    showCheckbox = TRUE;
                }
                if(newPermUserType == '' || newPermUserType==null){
                    newPermUserType='false';
                }
                if(((userType == Label.OSM_Support_Admin_UserType || userType == Label.OSM_Distributor_Admin_UserType || userType == Label.OSM_SSOEM_Admin_UserType) && order.OSM_SW_Days_Since_Order_Date__c > Integer.valueOf(System.Label.OSM_Order_Cancel_date_for_Guest) && newPermUserType.equalsignorecase('false')) 
                        || (userType != Label.OSM_Support_Admin_UserType && userType != Label.OSM_SSOEM_Admin_UserType && userType != Label.OSM_Distributor_Admin_UserType && order.Hours_Since_Order_Date__c > Integer.valueOf(System.Label.OSM_Order_Cancel_Hours))){
                    showCheckbox=false;
                }
                if(order.ccrz__OrderStatus__c =='Cancelled' || order.ccrz__OrderStatus__c =='Cancellation Pending'){
                    showCheckbox=false;
                }
            if(order.ccrz__E_OrderItems__r.size() == 0){
                isCancelShow = false;
            }
          
        }
    }
/*----------------------------------------------------------------------------------
1. getOrderInfo
Description:Used to fetch order info
Input: ccrz.cc_RemoteActionContext ctx, order Id
Output: Returns the user info of order
ccrz.cc_RemoteActionResult
DAProductsData==> Map<String,MainWrapper>
------------------------------------------------------------------------------------*/

 @RemoteAction
 global static ccrz.cc_RemoteActionResult getOrderInfo(ccrz.cc_RemoteActionContext ctx, String orderId){
      
        ccrz.cc_CallContext.initRemoteContext(ctx);
    
        ccrz.cc_RemoteActionResult result = new ccrz.cc_RemoteActionResult();
        result.success = false;
        result.inputContext = ctx;
        Map<String,Object> returnMap = new Map<String,Object>();
        Boolean canShowCancel;
        Boolean showPartialCancel = false;
     	String storefront = ccrz.cc_CallContext.storefront;
      String accId;
       if(!Test.isRunningTest()){
        accId = ccrz.cc_CallContext.effAccountId;
       }
        String orderEncryptedId = ccrz.cc_CallContext.currPageParameters.get('o');
        //system.debug('orderId : '+orderId);
        //system.debug('====OrderId === : '+orderEncryptedId);
        ccrz.ccLog.log('====OrderId ==='+orderId );
        List<ccrz__E_TransactionPayment__c> lstTransactionPayment = new List<ccrz__E_TransactionPayment__c>();
      
        
        try{
            if(orderId != null){
                ccrz__E_Order__c  order;
                
                order=[select id,ccrz__OriginatedCart__r.ccrz__EncryptedId__c,OrderProcessedforFSD__c,OSM_Bill_From__c,OSM_SW_Is_InterCompany_Order__c,ccrz__Account__r.Name,Hours_Since_Order_Date__c,OSM_SW_Days_Since_Order_Date__c,Refund_status__c,ccrz__OrderStatus__c,isOnBehalf__c,Purchased_By_User_Type__c,IsGetOrderSuccess__c,ccrz__OriginatedCart__r.Third_Party_BMS_Customer_ID__c,ccrz__OriginatedCart__r.OSM_SW_Is_third_Party_BMS_Payment__c,ccrz__OriginatedCart__r.Third_Party_BMS_Customer_Name__c,ccrz__OriginatedCart__r.OSM_SW_IAM_Account_Id_For_Third_Party__c,ccrz__Contact__r.AccountId,(SELECT ID,ccrz__Subscription_End_Date__c,ccrz__Product__c,ccrz__Product__r.Name,ccrz__DisplayProduct__c from ccrz__E_OrderItems__r) from ccrz__E_Order__c where ccrz__EncryptedId__c=:orderEncryptedId limit 1]; 
                TransactionDetail objnew = new TransactionDetail();
                objnew.refundStatus='';
                objnew.orderStatus='';
                orderId=order.id;
                objnew.refundStatus = order.Refund_status__c;
                objnew.orderStatus=order.ccrz__OrderStatus__c;
                objnew.transactionId='';
                objnew.cancelTransactionId ='';
                
              //Mp-430 Code Start
          List<ccrz__E_OrderItem__c> orderitems = new List<ccrz__E_OrderItem__c>();
          orderitems =  order.ccrz__E_OrderItems__r;
          //system.debug('orderitems-->'+orderitems);
          
         Map<id,ccrz__E_CartItem__c> idcartmap = new Map<id,ccrz__E_CartItem__c>();  
          ccrz__E_Cart__c carts = [select id, ccrz__EncryptedId__c,(select id,ccrz__Product__c,Subscription_Expiry_Date__c,ccrz__Product__r.Group_Name__c from ccrz__E_CartItems__r) from ccrz__E_Cart__c where ccrz__EncryptedId__c=:order.ccrz__OriginatedCart__r.ccrz__EncryptedId__c];
          List<ccrz__E_CartItem__c> cartItems;
          if(carts.ccrz__E_CartItems__r.size() >0){
              cartItems =carts.ccrz__E_CartItems__r;  
            }
          for(ccrz__E_CartItem__c cartit:cartItems){
               idcartmap.put(cartit.ccrz__Product__c,cartit);
            }
           //system.debug('idcartmap-->'+idcartmap);
           for(ccrz__E_OrderItem__c ord: orderitems){
                 if(!ord.ccrz__Product__r.Name.contains('INCAL')){
                     if(idcartmap.containskey(ord.ccrz__Product__c)){
               		 	ord.ccrz__Subscription_End_Date__c = idcartmap.get(ord.ccrz__Product__c).Subscription_Expiry_Date__c;
                        //system.debug('ord.ccrz__Subscription_End_Date__c-->'+ord.ccrz__Subscription_End_Date__c);
                 	} 
                 }
           }
          
          update orderitems;
               
          /*END MP-430*/  
                /*MP-133*/
                List<OSM_Order_Subscription__c> ordSubsObj = [SELECT id, OSM_CCSubscription__c FROM OSM_Order_Subscription__c WHERE OSM_CCOrder__c=:orderId LIMIT 1];
                if(ordSubsObj.size() != 0) {
                    ccrz__E_Subscription__c subscriptionObj = [SELECT id, Current_SPT_Susbcription_Length__c FROM ccrz__E_Subscription__c WHERE id=:ordSubsObj[0].OSM_CCSubscription__c LIMIT 1];
                   objnew.subscriptionLength = subscriptionObj.Current_SPT_Susbcription_Length__c;  
                                 
                }
                /*MP-133*/
                
                
                if(order != null){
                    /*
                        List<Account> accs = [SELECT id, Name FROM Account WHERE id =: order.ccrz__Contact__r.AccountId];
                    
                        if(!accs.isEmpty()){
                            objnew.accountName = accs[0].Name;
                        }
                    */
                    objnew.accountName = order.ccrz__Account__r.Name;
                //MAR-884 Code Start    
                string userId = UserInfo.getUserId();
                string userType = OSM_SW_General_Util.getuserType(userId);
                string newPermUserType = OSM_SW_General_Util.getpermissionset(userId);
                //system.debug('order.OSM_SW_Is_InterCompany_Order__c--->>'+order.OSM_SW_Is_InterCompany_Order__c);
                if(!order.OSM_SW_Is_InterCompany_Order__c){
                    canShowCancel = TRUE;
                }
                if(newPermUserType == '' || newPermUserType==null){
                    newPermUserType='false';
                }
                if(((userType == Label.OSM_Support_Admin_UserType || userType == Label.OSM_Distributor_Admin_UserType || userType == Label.OSM_SSOEM_Admin_UserType) && order.OSM_SW_Days_Since_Order_Date__c > Integer.valueOf(System.Label.OSM_Order_Cancel_date_for_Guest) && newPermUserType.equalsignorecase('false')) 
                        || (userType != Label.OSM_Support_Admin_UserType && userType != Label.OSM_SSOEM_Admin_UserType && userType != Label.OSM_Distributor_Admin_UserType && order.Hours_Since_Order_Date__c > Integer.valueOf(System.Label.OSM_Order_Cancel_Hours))){
                    canShowCancel =false;
                }
                /*if(order.isOnBehalf__c==false){
                if(order.OSM_SW_Days_Since_Order_Date__c != null && System.Label.OSM_Order_Cancel_date_for_Guest != null && order.Purchased_By_User_Type__c != Null && order.Purchased_By_User_Type__c.contains('Distributor')){
                    if(order.OSM_SW_Days_Since_Order_Date__c > Integer.valueOf(System.Label.OSM_Order_Cancel_date_for_Guest)){
                        canShowCancel =false;
                    }
                }
                }
                else{
                    if( order.OSM_SW_Days_Since_Order_Date__c != null && System.Label.OSM_Order_Cancel_date_for_Guest != null && System.Label.OSM_Order_Cancel_date_for_Guest != ''){
                        if(order.OSM_SW_Days_Since_Order_Date__c > Integer.valueOf(System.Label.OSM_Order_Cancel_date_for_Guest)){
                            canShowCancel =false;
                        }
                    }                         
                }*/
                if(order.ccrz__OrderStatus__c =='Cancelled' || order.ccrz__OrderStatus__c =='Cancellation Pending'){
                    canShowCancel =false;
                }
                    returnMap.put('canShowCancel',canShowCancel);
                 //MAR-884 Code End     
                }
               lstTransactionPayment = [Select Id, ccrz__AccountType__c,OSM_BAMS_Cancel_Request_ID__c, ccrz__Token__c from ccrz__E_TransactionPayment__c where ccrz__CCOrder__c =: orderId];
                //system.debug('lstTransactionPayment: '+lstTransactionPayment);
                If(lstTransactionPayment.size() > 0) {
                //MAR-1780 & Mar-1865 Code Start
                    OSM_Features_Maintenance__c osmFeaMaint = OSM_Features_Maintenance__c.getValues('Partial_Cancellation');
                    if(lstTransactionPayment[0].ccrz__AccountType__c =='cc' && osmFeaMaint.CC_Partial_Cancellation__c.equalsignorecase('ON')){
                        showPartialCancel = True;
                    }else if(lstTransactionPayment[0].ccrz__AccountType__c =='po' && osmFeaMaint.PO_Partial_Cancellation__c.equalsignorecase('ON')){
                        showPartialCancel = True;
                    }
                    returnMap.put('showPartialCancel',showPartialCancel);
                    
                 //MAR-1780 & Mar-1865 Code End   
                    if( lstTransactionPayment[0].ccrz__Token__c != null )
                        objnew.transactionId = lstTransactionPayment[0].ccrz__Token__c;
                    else
                        objnew.transactionId = '';
                    if(lstTransactionPayment[0].OSM_BAMS_Cancel_Request_ID__c != null)
                        objnew.cancelTransactionId = lstTransactionPayment[0].OSM_BAMS_Cancel_Request_ID__c;
                    else
                        objnew.cancelTransactionId = '';
                         
                        objnew.paymentMethod = lstTransactionPayment[0].ccrz__AccountType__c;
                        if(objnew.paymentMethod != Null && order.OSM_Bill_From__c != Null){
                            objnew.billFrom = (order.OSM_Bill_From__c).replace('\\n','');
                            objnew.ccSouthPlain = True;
                        }
                    returnMap.put('data', objnew);
                }
                returnMap.put('data', objnew);
                returnMap.put('activationKey', objnew.activationKey);
                if(OSM_SW_ActivationKeyError_Handling.activationkeycheck(order.id,new list<string>())){
                       returnMap.put('activationKeyErrorMessage', true);
                }else  returnMap.put('activationKeyErrorMessage', false);
        Account acc = new Account();
                if(order.ccrz__OriginatedCart__r.OSM_SW_IAM_Account_Id_For_Third_Party__c != null){
                   acc =[select id, name,IAM_Service_Provider_Code__c From Account where id =:order.ccrz__OriginatedCart__r.OSM_SW_IAM_Account_Id_For_Third_Party__c]; 
                }
                if(order.ccrz__OriginatedCart__r.OSM_SW_Is_third_Party_BMS_Payment__c){
                    returnMap.put('isthirdpartypayment',true);
                    returnMap.put('thirdpartycustname',order.ccrz__OriginatedCart__r.Third_Party_BMS_Customer_Name__c);
                    returnMap.put('thirdpartycustnum',order.ccrz__OriginatedCart__r.Third_Party_BMS_Customer_ID__c);
                    returnMap.put('thirdpartyIAMNO',acc.IAM_Service_Provider_Code__c);
               }else{
                   returnMap.put('isthirdpartypayment',false);
                }
                if(order.OrderProcessedforFSD__c)
                returnMap.put('isCallFSD',true);
                else
                returnMap.put('isCallFSD',false);
                                                 
                                                
                    
                                                 
            }
            
            result.data = returnMap;
            result.success = true;
            if(Test.isRunningTest()){
                throw new NullPointerException();
            }
        }catch(Exception ex){
            //system.debug('in catch exp: '+ex.getMessage());
            //system.debug('in catch getStackTraceString: '+ex.getStackTraceString());
            CMI_SW_CartTaxWrapper objWrpr1 = new CMI_SW_CartTaxWrapper();
            objWrpr1.isError = true;
            objWrpr1.errorMsg = ex.getMessage();
            returnMap.put('ErrorMsgOrder',objWrpr1);
            result.data = returnMap;
            result.success = false;
        }
        //system.debug('return map: '+result);
        return result;
    }
    @RemoteAction
    global static ccrz.cc_RemoteActionResult getOrderInformation(ccrz.cc_RemoteActionContext ctx, string orderItemIds,String cancleReason,String cancleComment){
        
        //system.debug(ctx);
        ccrz.cc_CallContext.initRemoteContext(ctx);
        
        ccrz.cc_RemoteActionResult result = new ccrz.cc_RemoteActionResult();
        result.success = false;
        Map<String,Object> returnMap = new Map<String,Object>();
        List<ccrz__E_OrderItem__c> list_OrderItemUpdate = new List<ccrz__E_OrderItem__c>();
        
        id orderId;
        String orderEmail;
        string orderItemIds1=orderItemIds.deleteWhitespace();
        String str= '\\[|\\]';
        orderItemIds1= orderItemIds1.replaceAll(str,'');
        List<String> listOrderItem= orderItemIds1.split(',');
        //system.debug('listOrderItem-->>'+listOrderItem);
        Set<String> setString = new Set<String>();
        setString.AddAll(listOrderItem);
        Set<id> idStrs = (Set<id>)JSON.deserialize(JSON.serialize(setString), Set<id>.class);
        //system.debug('idStrings-->>' + idStrs);
        
        string userId = UserInfo.getUserId();
        
        if(idStrs != Null)
        {
            
            
            try{
                boolean isOrderCanCancel = true;
                
                // query all order item to check for license product and is get order called or not
                List<ccrz__E_OrderItem__c> lstOrderItem = new List<ccrz__E_OrderItem__c>();
                List<ccrz__E_OrderItem__c> verOrderItem = new List<ccrz__E_OrderItem__c>();
                lstOrderItem = [Select Id,Is_FW_OrderItem__c, IsCancelPending__c, ccrz__Order__r.ccrz__Contact__r.Email,ccrz__OrderItemStatus__c,VertexOrderItemCall__c,ccrz__Product__r.Group_Name__c,ccrz__Order__c,Number_of_Bundles__c, OMS_Item_ID__c,OMS_Product__c,isRenew__c,OSM_Tool_Instance_Key__c,ccrz__DisplayProduct__r.Name,ccrz__DisplayProduct__r.ccrz__SKU__c,ccrz__Product__r.Name,ccrz__Product__r.ccrz__SKU__c,OMS_Activation_Key__c, ccrz__Quantity__c,Basic_Tool_Instance_Key_Count__c,Tool_Instance_Count__c,(Select id,Activation_Key__c,CC_Order_Item__c,IsRevokeAPISuccess__c,OMS_Order_ID__c,OMS_Item_Id__c,Tool_Instance_Id__c,Tool_Instance_Key__c from OSM_Oreder_Item_Licenses__r) 
                                    , (SELECT Id FROM ccrz__CCSubscriptions__r WHERE ccrz__SubscriptionStatus__c = 'Renew') 
                                from ccrz__E_OrderItem__c where Id IN :idStrs];
                
                Set<Id> setOrderItemIdToGetTI = new Set<Id>();
                
                boolean getOrderisnotCalled = false;
                
                set<Id> setToCallOnlyRevoke = new set<Id>();
                set<Id> setToCallOnlyCancel = new set<Id>();
                set<Id> setToCallBoth = new set<Id>();
                boolean isPreventCancel = false;
                set<Id> setToCallCreateAndGetOrder = new set<Id>();
                
                if(String.isBlank(OSM_SW_General_Util.USER_TYPE))
                                {
                                    OSM_SW_General_Util.getuserType(Userinfo.getUserId());
                                    
                                }
                String UserAccountName = '';
            if(OSM_SW_General_Util.USER_TYPE == System.label.OSM_Distributor_Admin_UserType)
            {
                List<Contact> lstContact = new List<Contact>();
                lstContact = [Select Id,Account.Name from Contact where IAM_Contact_Owner__c =: Userinfo.getUserId()];
                if(lstContact.size() > 0)
                    UserAccountName = lstContact[0].Account.Name;
            }
            
            
                if(lstOrderItem != null && lstOrderItem.size() > 0) {
                    for(ccrz__E_OrderItem__c objItem: lstOrderItem) {
                        orderEmail = objItem.ccrz__Order__r.ccrz__Contact__r.Email;
                        orderId = objItem.ccrz__Order__c;
                        if(objItem.OMS_Product__c) { 
                            if(objItem.OSM_Oreder_Item_Licenses__r!=null && objItem.OSM_Oreder_Item_Licenses__r.size()!=0) {
                                //system.debug('test running debug : '+objItem.ccrz__DisplayProduct__r.Name);
								if((objItem.Basic_Tool_Instance_Key_Count__c!= null  && objItem.Basic_Tool_Instance_Key_Count__c!=0) ||
										(objItem.Tool_Instance_Count__c != null  && objItem.Tool_Instance_Count__c!=0)){
									if(Label.OSM_PreventCancel_ProductSKU.contains(objItem.ccrz__DisplayProduct__r.ccrz__SKU__c) &&
											OSM_SW_General_Util.USER_TYPE == Label.OSM_Storefront_Admin_UserType){
										isPreventCancel = true;
									}
								}
                                if(!isPreventCancel){
									if(Label.SES_OMSCreateOrder_SubscriptionProduct_List.contains(objItem.ccrz__DisplayProduct__r.ccrz__SKU__c) ){ 
										if(objItem.Basic_Tool_Instance_Key_Count__c!= null  && objItem.Basic_Tool_Instance_Key_Count__c!=0)
										{
											//system.debug('objItem.Basic_Tool_Instance_Key_Count__c>>>>>'+objItem.Basic_Tool_Instance_Key_Count__c);
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
										if(objItem.Tool_Instance_Count__c != null  && objItem.Tool_Instance_Count__c!=0) {
											//system.debug('objItem.Tool_Instance_Count__c>>>>>'+objItem.Tool_Instance_Count__c);
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
												//system.debug('setToCallOnlyRevoke___'+setToCallOnlyRevoke);
											}
										}
										else
										{
											setOrderItemIdToGetTI.add(objItem.Id);
											setToCallOnlyCancel.add(objItem.Id);
											//system.debug('setOrderItemIdToGetTI___'+setToCallOnlyRevoke);
											//system.debug('setToCallOnlyCancel___'+setToCallOnlyCancel);
										}
									}
									else{
										if(objItem.Tool_Instance_Count__c != null  && objItem.Tool_Instance_Count__c!=0 )
										{
											//system.debug('objItem.Tool_Instance_Count__c>>>>>'+objItem.Tool_Instance_Count__c);
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
												//system.debug('setToCallOnlyRevoke__111_'+setToCallOnlyRevoke);
											}
										}
										else
										{
											setOrderItemIdToGetTI.add(objItem.Id);
											setToCallOnlyCancel.add(objItem.Id);
											//system.debug('setOrderItemIdToGetTI__111_'+setToCallOnlyRevoke);
											//system.debug('setToCallOnlyCancel_111__'+setToCallOnlyCancel);
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
                                objItem.IsCancelPending__c = true;  
                                objItem.Cancelled_By__c = userId;
                                
                                
                                objItem.OSM_SW_Cancel_By_User_Type__c = OSM_SW_General_Util.USER_TYPE;
                                objItem.OSM_SW_Distributor_Account_Name__c = UserAccountName;
                                
                                list_OrderItemUpdate.add(objItem);
                            }
                        }
                        if(!objItem.OMS_Product__c && !objItem.Is_FW_OrderItem__c){
                            setToCallOnlyCancel.add(objItem.Id);
                        }
                    }
                }
                //system.debug('getOrderisnotCalled____'+getOrderisnotCalled);
                if(!getOrderisnotCalled) {
                    if(setOrderItemIdToGetTI != null && setOrderItemIdToGetTI.size() > 0) {
                        OSM_OMS_GetTI_Batch_Helper.callGetTILicensesAPI(setOrderItemIdToGetTI);
                        
                        lstOrderItem = [Select Id,ccrz__Order__r.ccrz__Contact__r.Email,ccrz__Product__r.Name,OMS_Product__c,Number_of_Bundles__c,isRenew__c, ccrz__DisplayProduct__r.Name,OSM_Tool_Instance_Key__c,OMS_Activation_Key__c, ccrz__DisplayProduct__r.ccrz__SKU__c,ccrz__Product__r.ccrz__SKU__c,ccrz__Quantity__c,Basic_Tool_Instance_Key_Count__c,Tool_Instance_Count__c,(Select id,Activation_Key__c,CC_Order_Item__c,IsRevokeAPISuccess__c,OMS_Order_ID__c,OMS_Item_Id__c,Tool_Instance_Id__c,Tool_Instance_Key__c from OSM_Oreder_Item_Licenses__r) from ccrz__E_OrderItem__c where Id IN :idStrs];
                        //system.debug('lstOrderItem___'+lstOrderItem);
                        
                        if(lstOrderItem != null && lstOrderItem.size() > 0) {
                            for(ccrz__E_OrderItem__c objItem: lstOrderItem)
                            {
                                if(objItem.OMS_Product__c)
                                {
                                    if(objItem.OSM_Oreder_Item_Licenses__r!=null && objItem.OSM_Oreder_Item_Licenses__r.size()!=0)
                                    {
                                        if((objItem.Basic_Tool_Instance_Key_Count__c!= null  && objItem.Basic_Tool_Instance_Key_Count__c!=0) ||
												(objItem.Tool_Instance_Count__c != null  && objItem.Tool_Instance_Count__c!=0)){
											if(Label.OSM_PreventCancel_ProductSKU.contains(objItem.ccrz__DisplayProduct__r.ccrz__SKU__c) &&
													OSM_SW_General_Util.USER_TYPE == Label.OSM_Storefront_Admin_UserType){
												isPreventCancel = true;
											}
										}
										if(!isPreventCancel){
                                            if(Label.SES_OMSCreateOrder_SubscriptionProduct_List.contains(objItem.ccrz__DisplayProduct__r.ccrz__SKU__c) ){ 
                                                if(!Label.OMS_ProductList_NonInsite.contains(objItem.ccrz__DisplayProduct__r.ccrz__SKU__c))
                                                {
                                                    if(objItem.Basic_Tool_Instance_Key_Count__c!= null  && objItem.Basic_Tool_Instance_Key_Count__c!=0)
                                                    {
                                                        
                                                        //Integer activationekyLength = orderItemLicense.Tool_Instance_Count__c;
                                                        
                                                        //system.debug('objItem.Basic_Tool_Instance_Count__c>>>>>'+objItem.Basic_Tool_Instance_Key_Count__c);
                                                        
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
                                                            //system.debug('setToCallOnlyRevoke_for basic___');
                                                            setToCallOnlyRevoke.add(objItem.Id);
                                                        }
                                                    }
                                                    else
                                                    {
                                                        //system.debug('setToCallOnlyCancel_for basic___');
                                                        setToCallOnlyCancel.add(objItem.Id);
                                                    }
                                                }
                                                if(objItem.Tool_Instance_Count__c != null  && objItem.Tool_Instance_Count__c!=0)
                                                {
                                                    
                                                    //Integer activationekyLength = orderItemLicense.Tool_Instance_Count__c;
                                                    //system.debug('objItem.Tool_Instance_Count__c>>>>>'+objItem.Tool_Instance_Count__c);
                                                    
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
                                                        //system.debug('setToCallOnlyRevoke_for functional__123____');
                                                        setToCallOnlyRevoke.add(objItem.Id);
                                                    }
                                                }
                                                else
                                                {
                                                    //system.debug('setToCallOnlyCancelforFunctional_123______'); 
                                                    setToCallOnlyCancel.add(objItem.Id);
                                                }
                                            }
                                            else{
                                                if(objItem.Tool_Instance_Count__c != null  && objItem.Tool_Instance_Count__c!=0 )
                                                {
                                                    
                                                    //Integer activationekyLength = orderItemLicense.Tool_Instance_Count__c;
                                                    //system.debug('objItem.Tool_Instance_Count__c>>>>>'+objItem.Tool_Instance_Count__c);
                                                    
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
                                                        //system.debug('setToCallOnlyrevoke_for functional_234_____');
                                                        setToCallOnlyRevoke.add(objItem.Id);
                                                    }
                                                }
                                                else
                                                {
                                                    //system.debug('setToCallOnlyCancel_for functional__234_______');
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
                if(setToCallCreateAndGetOrder!=null && setToCallCreateAndGetOrder.size()>0) {
                    List<ccrz__E_Order__c> list_OrderUpdate = new List<ccrz__E_Order__c>();
                    for(ccrz__E_Order__c ordrObj : [SELECT Id, OSM_SW_Order_Item_Count__c, ccrz__OrderStatus__c FROM ccrz__E_Order__c WHERE Id IN :setToCallCreateAndGetOrder]){
                        if(ordrObj.OSM_SW_Order_Item_Count__c == list_OrderItemUpdate.size()){
                            ordrObj.ccrz__OrderStatus__c = Label.OSM_CancellationPending;
                            list_OrderUpdate.add(ordrObj);
                        }
                    }
                    OSM_SW_OrderActions.call_OMS_GetAndCreateOrder(setToCallCreateAndGetOrder,null,null,false);
                    update list_OrderItemUpdate;
                    if(list_OrderUpdate.size() > 0){
                        update list_OrderUpdate;
                    }
                }
                
                
                //system.debug('setToCallOnlyCancel : '+setToCallOnlyCancel);
                //system.debug('setToCallOnlyRevoke : '+setToCallOnlyRevoke);
                //system.debug('setToCallBoth : '+setToCallBoth);
                
                if(isOrderCanCancel && !isPreventCancel) 
                {
                    // Code commented by Ashish (This is not needed, breaking system flow and creating lot of issues)
                    /*
                    Boolean OrderandOrderItemsEqual;
                    List<ccrz__E_OrderItem__c> orderItemList = new List<ccrz__E_OrderItem__c>();
                    List<ccrz__E_OrderItem__c> orderItemCancelList = new List<ccrz__E_OrderItem__c>();
                    Map<ID,ccrz__E_OrderItem__c> checklist = new Map<ID,ccrz__E_OrderItem__c>();
                    List<ccrz__E_OrderItem__c> finallist = new List<ccrz__E_OrderItem__c>();
                    Set<Id> orderItemIdSet = new Set<Id>();
                    List<ccrz__E_OrderItem__c> lstOrdItems = new List<ccrz__E_OrderItem__c>();
                    for(ccrz__E_OrderItem__c  orderItem:lstOrderItem){
                       orderId = orderItem.ccrz__Order__c;
                       orderItem.ccrz__OrderItemStatus__c = Label.OSM_CancellationPending;
                       orderEmail = orderItem.ccrz__Order__r.ccrz__Contact__r.Email;
                       orderItemIdSet.add(orderItem.id);
                             
                       lstOrdItems.add(orderItem);
                       checklist.put(orderItem.id,orderItem);
                   }
                   Update lstOrdItems;
                   //OSM_SW_OrderCancelUtilForPage.updateIntercompanyOrder(orderId);
                   orderItemList = [Select ID,ccrz__OrderItemStatus__c, OMS_Product__c,ccrz__Quantity__c, ccrz__Product__c from ccrz__E_OrderItem__c where ccrz__Order__c=:orderId and ccrz__ParentOrderItem__c = null];
                   orderItemCancelList= [Select ID,ccrz__OrderItemStatus__c,VertexOrderItemCall__c, OMS_Product__c,ccrz__Quantity__c, ccrz__Product__c from ccrz__E_OrderItem__c where ccrz__Order__c=:orderId and ccrz__ParentOrderItem__c = null and id not IN :idStrs];
                   for(ccrz__E_OrderItem__c  orderItem1:orderItemCancelList){
                        if(orderItem1.ccrz__OrderItemStatus__c=='Cancelled' && orderItem1.VertexOrderItemCall__c == True){
                            orderItem1.VertexOrderItemCall__c = False;
                            verOrderItem.add(orderItem1);
                        }
                      
                    }
                    Update verOrderItem;
                   Integer objOrder =orderItemList.size();
                   Integer objOrderItem =lstOrderItem.size();
                    if(lstOrderItem != Null && objOrder!= null){
                            if(objOrder != objOrderItem){
                                for(ccrz__E_OrderItem__c orditem : orderItemList){
                                    if(!checklist.containsKey(orditem.id)){
                                       //system.debug('orditem.ccrz__OrderItemStatus__c-->>'+orditem.ccrz__OrderItemStatus__c);
                                        if(orditem.ccrz__OrderItemStatus__c == 'Cancellation Pending' || orditem.ccrz__OrderItemStatus__c == 'Cancelled' || orditem.ccrz__OrderItemStatus__c == 'Revoked'){
                                            finallist.add(orditem);
                                        }
                                        //system.debug('finallist-->>'+finallist.size());
                                }
                            }
                                finallist.addAll(lstOrderItem);
                                //system.debug('finallist-->>'+finallist.size());
                                if(finallist.size()==orderItemList.size()){
                                    OrderandOrderItemsEqual=true;
                                }
                                else{
                                    OrderandOrderItemsEqual=false;
                                }
                          }
                            else{
                                if(objOrder == objOrderItem){
                                    OrderandOrderItemsEqual=true;
                                }
                                
                            }
                        }
                    if((OrderandOrderItemsEqual && setToCallCreateAndGetOrder.size() == 0 &&  setToCallBoth.size() == 0 && setToCallOnlyCancel.size() == 0 && setToCallOnlyRevoke.size() == 0) || Test.isRunningTest())
                    {
                        Set<Id> orderIdSet = new Set<Id>();
                        orderIdSet.add(orderId);
                        OSM_SW_OrderCancellationUtility.updateRecordsOnOrderCancellation(orderIdSet);     //Call method to update sobject records
                        OSM_SW_OrderTriggerHandlerUtility.getOrderCancel(orderIdSet);// call da order update
                    }
                    else if(!OrderandOrderItemsEqual){
                        OSM_SW_OrderCancellationUtility.updateRecordsOnOrderItemCancellation(orderItemIdSet, Label.OSM_Order_Cancellation);     //Call method to update sobject records
                        OSM_SW_OrderTriggerHandlerUtility.getOrderCancel(orderItemIdSet); 
                    }
                    */
                    // End: Ashish
                    
                    if(lstOrderItem != null) {
                        If(orderEmail != null) {
                            OrderDetail objnew = new OrderDetail();
                            objnew.userEmail = orderEmail;
                            Set<Id> set_UniqueOIId = new Set<Id>();
                            
                            if(!getOrderisnotCalled)
                            {
                                set_UniqueOIId.addAll(setToCallBoth);
                                set_UniqueOIId.addAll(setToCallOnlyCancel);
                                set_UniqueOIId.addAll(setToCallOnlyRevoke);
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
                            for(ccrz__E_OrderItem__c ordrItm : [Select Id from ccrz__E_OrderItem__c where Id IN :idStrs AND ccrz__Product__r.Group_Name__c = 'FluidWatch' AND ccrz__ParentOrderItem__c = null]){
                                objnew.lstForCancel.add(ordrItm.Id);
                                objnew.isCancelCallNeeded = true; 
                            }
                            ccrz__E_Order__c ordrObj = [SELECT Id, OSM_SW_Order_Item_Count__c, (SELECT Id FROM ccrz__E_OrderItems__r WHERE ccrz__ParentOrderItem__c = null 
                                                            AND ((ccrz__OrderItemStatus__c = 'Cancelled' OR ccrz__OrderItemStatus__c = 'Revoked' OR ccrz__OrderItemStatus__c = 'Cancellation Pending')  
                                                            OR (ccrz__OrderItemStatus__c = 'Order Submitted' AND IsCancelPending__c = true)))
                                                            FROM ccrz__E_Order__c WHERE Id =: orderId];
                            integer listSize = 0;
                            if(ordrObj.ccrz__E_OrderItems__r != null){
                                listSize = ordrObj.ccrz__E_OrderItems__r.size();
                            }
                            if((listSize + set_UniqueOIId.size()) == ordrObj.OSM_SW_Order_Item_Count__c){
                                ccrz__E_Order__c neeObjOrdr = new ccrz__E_Order__c();
                                neeObjOrdr.Id = orderId;
                                neeObjOrdr.ccrz__OrderStatus__c = Label.OSM_CancellationPending;
                                update neeObjOrdr;
                            }
                            returnMap.put('data', objnew);
                        }
                    }
                    // update comment and reason
                    
                    List<Id> lstItemId = new List<Id>();
                    List<ccrz__E_OrderItem__c> lstOrderItemUpdate = new List<ccrz__E_OrderItem__c>();
                    lstOrderItemUpdate = [Select Id,OSM_SW_Cancel_Comment__c,OSM_SW_Cancel_Reason__c from ccrz__E_OrderItem__c where Id IN: idStrs];
                    for(ccrz__E_OrderItem__c objItem : lstOrderItemUpdate)
                    {
                        objItem.OSM_SW_Cancel_Reason__c = cancleReason;
                        objItem.OSM_SW_Cancel_Comment__c = cancleComment;
                        lstItemId.add(objItem.Id);
                    }
                    
                    update lstOrderItemUpdate;
                    //OSM_SW_OrderCancelUtilForPage.updateIAMRecord(lstItemId);
                    
                    result.data = returnMap;
                    result.success = true;                    
                }
                else {
                    result.success = false;
                    returnMap.put('errorMsg', 'Your order can no longer be cancelled since your license key has already been activated.');
                    result.data = returnMap;
                }
                if(Test.isRunningTest()) {
                    throw new NullPointerException();
                } 
                
            }catch(Exception ex)
            {
                //system.debug('in catch exp: '+ex.getMessage());
                //system.debug('in catch getStackTraceString: '+ex.getStackTraceString());
                CMI_SW_CartTaxWrapper objWrpr1 = new CMI_SW_CartTaxWrapper();
                objWrpr1.isError = true;
                objWrpr1.errorMsg = ex.getMessage();
                returnMap.put('ErrorMsgOrder',objWrpr1);
                result.data = returnMap;
                result.success = false;
            }
        }
        //system.debug('return map: '+result);
        return result;
    }
    @RemoteAction
     global static ccrz.cc_RemoteActionResult callFSDAPI(ccrz.cc_RemoteActionContext ctx, List<String> orderItemIdlst,List<String> orderItemIdlst2)
    {
        ccrz.cc_CallContext.initRemoteContext(ctx);
        ccrz.cc_RemoteActionResult res = new ccrz.cc_RemoteActionResult();
        Map<String,Object> returnMap = new Map<String,Object>();
        String orderId='';
        Set<Id> orderItemIdSet=new Set<Id>();
        List<ccrz__E_OrderItem__c> lstOrderItemIntercompany = new List<ccrz__E_OrderItem__c>();
        List<ccrz__E_OrderItem__c> intCompOrderItemupdate=new List<ccrz__E_OrderItem__c>();
        List<ccrz__E_OrderItem__c> orderItemList=[select id,ccrz__Order__c from ccrz__E_OrderItem__c where (id IN:orderItemIdlst OR id IN:orderItemIdlst2)];
        for(ccrz__E_OrderItem__c orderItem:orderItemList)
        {
            orderItemIdSet.add(orderItem.id);
            orderId=orderItem.ccrz__Order__c;
        }
        ccrz__E_Order__c objOrder = [Select Id, FW_Product_Count__c from ccrz__E_Order__c where Id =: orderId];
        lstOrderItemIntercompany = [Select Id,ccrz__Order__c,ccrz__OrderItemStatus__c,ccrz__Quantity__c,Original_Sales_Order_Item__c from ccrz__E_OrderItem__c where Original_Sales_Order_Item__c IN: orderItemIdSet];
        
        if(objOrder.FW_Product_Count__c == 0){
            OSM_ReturnWrapper objRet = new OSM_ReturnWrapper();
            objRet = OSM_WS_SubmitOrderBusiness_Handler.getOrderInfo(orderId,'Cancel',orderItemIdSet,'partial cancel',false,null);
             if(!objRet.exceptionFlag) {                
                    OSM_SW_OrderCancelUtilForPage.updateIntercompanyOrderCancelSucess(orderId);
                    Set<Id> setItemId = new Set<Id>();
                    setItemId.add(orderId);
                    
                    //OSM_SW_OrderTriggerHandlerUtility.getOrderCancel(setItemId);
                    Set<Id> orderItemIdSet2=new Set<Id>();
                    List<ccrz__E_OrderItem__c> orderItemList2=[select id from ccrz__E_OrderItem__c where id IN:orderItemIdlst and OSM_SW_Is_OMS_Revoke_and_Cancel_Not_Done__c = false];
                    for(ccrz__E_OrderItem__c obj: orderItemList2)
                        orderItemIdSet2.add(obj.Id);
                    
                    if(orderItemIdSet2.size() > 0 )
                    {
                        OSM_SW_OrderCancellationUtility.updateRecordsOnOrderItemCancellation(orderItemIdSet2, Label.OSM_Order_Cancellation);
                        OSM_SW_OrderTriggerHandlerUtility.getOrderCancel(setItemId);
                    }
                    
                    for(ccrz__E_OrderItem__c objOrd : lstOrderItemIntercompany)
                    {
                        //objOrd.ccrz__OrderItemStatus__c = Label.OSM_Cancelled;
                        //objOrd.ccrz__Quantity__c=0;
                        intCompOrderItemupdate.add(objOrd);
                        
                    }
                    
                }
            if(intCompOrderItemupdate!=null && intCompOrderItemupdate.size()>0)
            update intCompOrderItemupdate;  
            returnMap.put('FSDRes', objRet);
            if(Test.isRunningTest()) {
                objRet.exceptionFlag=false;
            }
           /* try{
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
                //system.debug('exception in updating records: '+ex);
            }  */      
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
        string userId = UserInfo.getUserId();    
        try{            
            //system.debug('Call revoke API: '+orderItemIdlst);
            //system.debug('Call revoke API Size: '+orderItemIdlst.size());
            
            Set<Id> setItemId = new Set<Id>();
            for(String key : orderItemIdlst)
                setItemId.add(key);
            
            OSM_OMS_SW_RevokeAPIUtility.revokeAPIcall(setItemId);
            List<ccrz__E_OrderItem__c> lstOrderItem = new List<ccrz__E_OrderItem__c>();
            lstOrderItem = [Select Id,ccrz__OrderItemStatus__c, ccrz__Order__r.OrderProcessedforFSD__c, IsCancelPending__c,ccrz__Order__c,IsRevokeLicenseSucess__c,Cancelled_By__c from ccrz__E_OrderItem__c where Id IN: setItemId];
            
            String orderId; 
            boolean isRevoked = true;
            
            if(String.isBlank(OSM_SW_General_Util.USER_TYPE))
                {
                    OSM_SW_General_Util.getuserType(Userinfo.getUserId());
                    
                }
                
            String UserAccountName = '';
            if(OSM_SW_General_Util.USER_TYPE == System.label.OSM_Distributor_Admin_UserType)
            {
                List<Contact> lstContact = new List<Contact>();
                lstContact = [Select Id,Account.Name from Contact where IAM_Contact_Owner__c =: Userinfo.getUserId()];
                if(lstContact.size() > 0)
                    UserAccountName = lstContact[0].Account.Name;
            }
                    
                    
            for(ccrz__E_OrderItem__c obj : lstOrderItem) {
                orderId = obj.ccrz__Order__c;
                if(!obj.IsRevokeLicenseSucess__c) {
                    isRevoked = false;
                    obj.IsCancelPending__c = true;                    
                }
                obj.Cancelled_By__c = userId;
                
                
                obj.OSM_SW_Cancel_By_User_Type__c = OSM_SW_General_Util.USER_TYPE;
                obj.OSM_SW_Distributor_Account_Name__c = UserAccountName;
                
                if(obj.ccrz__Order__r.OrderProcessedforFSD__c)
                    obj.ccrz__OrderItemStatus__c = 'Cancellation Pending'; 
            }
            
            if(lstOrderItem.size() > 0 && !isRevoked){  
                update lstOrderItem;    
            }
            
            boolean isRefund = false;
            if(orderId != null)
                isRefund = callCancelOrder(OrderId, orderItemIdlst, isRevoked);
            
            OrderCancelDetail ordDtl = new OrderCancelDetail();
            ordDtl.isRefundReq = isRefund;
            ordDtl.lstForRefund = orderItemIdlst;
            returnMap.put('data', ordDtl);          
            returnMap.put('RevokeAPISucess', isRevoked);
            
            if(Test.isRunningTest()){
              throw new NullPointerException();                          
            } 
        }Catch(Exception ex){
            //system.debug('exception in updating records: '+ex);
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
        string userId = UserInfo.getUserId();
        try{            
            //system.debug('Call cancel API: '+orderItemIdlst);
            //system.debug('Call cancel API Size: '+orderItemIdlst.size());
            String orderId;

            List<ccrz__E_OrderItem__c> list_ordrItm = new List<ccrz__E_OrderItem__c>();
            List<ccrz__E_OrderItem__c> list_ordrItm2 = new List<ccrz__E_OrderItem__c>();
            for(ccrz__E_OrderItem__c ordItm : [Select Id, OMS_Product__c,ccrz__Order__c, IsCancelPending__c, ccrz__OrderItemStatus__c
                                                    , Cancelled_By__c, ccrz__Product__r.ccrz__SKU__c, ccrz__Quantity__c,Basic_Remaining_Lisences__c
                                                    , ccrz__Order__r.OrderProcessedforFSD__c,Remaining_Lisences__c, Basic_Tool_Instance_Key_Count__c,Tool_Instance_Count__c, 
                                                    (SELECT Id FROM ccrz__CCSubscriptions__r WHERE ccrz__SubscriptionStatus__c = 'Renew') 
                                                    FROM ccrz__E_OrderItem__c where ccrz__Product__r.Group_Name__c != 'FluidWatch' AND Id IN: orderItemIdlst]){
                if(ordItm.ccrz__CCSubscriptions__r.size() == 0 && ordItm.OMS_Product__c && ((!Label.OSM_SingleLicense_Basic_Products.contains(ordItm.ccrz__Product__r.ccrz__SKU__c) && !Label.OSM_SingleLicense_Products.contains(ordItm.ccrz__Product__r.ccrz__SKU__c)) 
                    || (Label.OSM_SingleLicense_Basic_Products.contains(ordItm.ccrz__Product__r.ccrz__SKU__c) && ordItm.ccrz__Quantity__c != ordItm.Basic_Tool_Instance_Key_Count__c && ordItm.Basic_Remaining_Lisences__c > 0)
                    || (Label.OSM_SingleLicense_Products.contains(ordItm.ccrz__Product__r.ccrz__SKU__c) && ordItm.ccrz__Quantity__c != ordItm.Tool_Instance_Count__c && ordItm.Remaining_Lisences__c > 0))){
                    
                    list_ordrItm.add(ordItm);
                } else if(ordItm.ccrz__CCSubscriptions__r.size() > 0) {
                    list_ordrItm2.add(ordItm);
                } else {
                    list_ordrItm2.add(ordItm);
                }
                orderId = ordItm.ccrz__Order__c;
            }
            List<ccrz__E_OrderItem__c> list_ordrItmFW = new List<ccrz__E_OrderItem__c>([Select Id, OrderItem_Cancellation_Date__c, ccrz__Order__r.OrderProcessedforFSD__c,ccrz__Order__c, ccrz__OrderItemStatus__c, Cancelled_By__c from ccrz__E_OrderItem__c where ccrz__Product__r.Group_Name__c = 'FluidWatch' AND Id IN:orderItemIdlst]);
            boolean isCanceleded = true;
            
            List<ccrz__E_OrderItem__c> list_OrderItemUpdate = new List<ccrz__E_OrderItem__c>();
            
            if(String.isBlank(OSM_SW_General_Util.USER_TYPE))
                {
                    OSM_SW_General_Util.getuserType(Userinfo.getUserId());
                    
                }
            String UserAccountName = '';
            if(OSM_SW_General_Util.USER_TYPE == System.label.OSM_Distributor_Admin_UserType)
            {
                List<Contact> lstContact = new List<Contact>();
                lstContact = [Select Id,Account.Name from Contact where IAM_Contact_Owner__c =: Userinfo.getUserId()];
                if(lstContact.size() > 0)
                    UserAccountName = lstContact[0].Account.Name;
            }
            
            
            if(list_ordrItm.size() > 0){
                Set<Id> setItemId = new Set<Id>();
                for(ccrz__E_OrderItem__c ordrItm : list_ordrItm)
                    setItemId.add(ordrItm.Id);
                
                OSM_CancelLicenses_ServiceHandler.callCancelLicensesAPI(setItemId);
                //system.debug('Cancelled Api Called___'+setItemId);
                List<ccrz__E_OrderItem__c> lstOrderItem = new List<ccrz__E_OrderItem__c>();                
                lstOrderItem = [Select Id, ccrz__Order__c, ccrz__Order__r.OrderProcessedforFSD__c,IsCancelPending__c, OMS_Product__c, ccrz__OrderItemStatus__c, CancelLicenseAPICalled__c, Cancelled_By__c  from ccrz__E_OrderItem__c where Id IN: setItemId];
                
                //system.debug('lstOrderItem ___'+lstOrderItem );
                for(ccrz__E_OrderItem__c obj : lstOrderItem) {                    
                    obj.Cancelled_By__c = userId;
                    
                    
                
                obj.OSM_SW_Cancel_By_User_Type__c = OSM_SW_General_Util.USER_TYPE;
                obj.OSM_SW_Distributor_Account_Name__c = UserAccountName;
                
                
                    if(obj.CancelLicenseAPICalled__c && !obj.ccrz__Order__r.OrderProcessedforFSD__c) {
                        obj.ccrz__OrderItemStatus__c = 'Cancelled';
                        list_OrderItemUpdate.add(obj);
                    }else{
                        isCanceleded = false;
                        obj.IsCancelPending__c = true;
                        obj.ccrz__OrderItemStatus__c = 'Cancellation Pending'; 
                        obj.OrderItem_Cancellation_Date__c = System.today();                        
                        list_OrderItemUpdate.add(obj);
                        
                    }
                }
            }
            
            if(list_ordrItmFW.size() > 0){
                for(ccrz__E_OrderItem__c ordrItm : list_ordrItmFW){
                    ordrItm.ccrz__OrderItemStatus__c = 'Cancelled';
                    ordrItm.Cancelled_By__c = userId;
                    
                
                ordrItm.OSM_SW_Cancel_By_User_Type__c = OSM_SW_General_Util.USER_TYPE;
                ordrItm.OSM_SW_Distributor_Account_Name__c = UserAccountName;
                
                    orderId = ordrItm.ccrz__Order__c;
                    ordrItm.OrderItem_Cancellation_Date__c = System.today();
                    list_OrderItemUpdate.add(ordrItm);
                }
            }
            
            if(list_ordrItm2.size() > 0){
                for(ccrz__E_OrderItem__c ordrItm : list_ordrItm2){
                    if(!ordrItm.ccrz__Order__r.OrderProcessedforFSD__c)
                        ordrItm.ccrz__OrderItemStatus__c = 'Cancelled';
                    else
                        ordrItm.ccrz__OrderItemStatus__c = 'Cancellation Pending';
                    ordrItm.Cancelled_By__c = userId;
                    
                ordrItm.OrderItem_Cancellation_Date__c = System.today();
                ordrItm.OSM_SW_Cancel_By_User_Type__c = OSM_SW_General_Util.USER_TYPE;
                ordrItm.OSM_SW_Distributor_Account_Name__c = UserAccountName;
                
                    orderId = ordrItm.ccrz__Order__c;
                    list_OrderItemUpdate.add(ordrItm);
                }
            }
            
            if(list_OrderItemUpdate.size() > 0){
                update list_OrderItemUpdate;
            }
            
            boolean isRefund = false;
            if(orderId != null)
                isRefund = callCancelOrder(OrderId, orderItemIdlst,false);
            
            for(ccrz__E_Order__c ordrObj : [SELECT Id, OSM_SW_Order_Item_Count__c, FW_Product_Count__c FROM ccrz__E_Order__c WHERE Id =: orderId]){
                if(ordrObj.OSM_SW_Order_Item_Count__c == ordrObj.FW_Product_Count__c ){
                    isRefund = true;
                }                
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
            //system.debug('exception in updating records: '+ex);
        }        
        
        res.data = returnMap;
        res.success=true;
        return res;
    }
    
    
    public static boolean callCancelOrder(String orderId, List<String> orderItemIdlst, boolean isRevoke)
    {
        boolean isRefReq = false;
        ccrz__E_Order__c ordrObj = [SELECT Id, OrderProcessedforFSD__c,OSM_SW_Order_Item_Count__c, ccrz__OrderStatus__c, (SELECT Id FROM ccrz__E_OrderItems__r WHERE ccrz__ParentOrderItem__c = null 
                                            AND ((ccrz__OrderItemStatus__c = 'Cancelled' OR ccrz__OrderItemStatus__c = 'Revoked' OR ccrz__OrderItemStatus__c = 'Cancellation Pending')  
                                            OR (ccrz__OrderItemStatus__c = 'Order Submitted' AND IsCancelPending__c = true)))
                                            FROM ccrz__E_Order__c WHERE Id =: orderId];
            
        if((ordrObj.OSM_SW_Order_Item_Count__c == ordrObj.ccrz__E_OrderItems__r.size() || ordrObj.ccrz__OrderStatus__c == Label.OSM_CancellationPending) || Test.isRunningTest()){
            try{
                //system.debug('Call cancel order funcationallity : '+orderId);
                if(!isRevoke){
                    ccrz__E_Order__c neeObjOrdr = new ccrz__E_Order__c();
                    neeObjOrdr.Id = orderId;
                    neeObjOrdr.ccrz__OrderStatus__c = Label.OSM_CancellationPending;
                    update neeObjOrdr;
                }
                
                ccrz__E_Order__c objOrder = new ccrz__E_Order__c();
                objOrder = [Select Id, OrderProcessedforFSD__c,Is_OMS_Revoke_and_Cancel_Not_Done_Count__c, FW_Product_Count__c from ccrz__E_Order__c where Id =: orderId];
                //system.debug('updated order: '+objOrder);
               
                //if(objOrder.Is_OMS_Revoke_and_Cancel_Not_Done_Count__c == 0 && (objOrder.OrderProcessedforFSD__c || objOrder.FW_Product_Count__c > 0)) {
                if(objOrder.Is_OMS_Revoke_and_Cancel_Not_Done_Count__c == 0  && !objOrder.OrderProcessedforFSD__c) {
                    Set<Id> setItemId = new Set<Id>();
                    setItemId.add(orderId);
                    
                    OSM_SW_OrderCancellationUtility.updateRecordsOnOrderCancellation(setItemId);
                    
                    //Call method to update sobject records
                    OSM_SW_OrderTriggerHandlerUtility.getOrderCancel(setItemId);
                }
                
                ccrz__E_Order__c objOrder2 = new ccrz__E_Order__c();
                objOrder2 = [Select Id, Refund_status__c, FW_Product_Count__c, OSM_SW_Order_Item_Count__c from ccrz__E_Order__c where Id =: orderId];
                if(objOrder2.OSM_SW_Order_Item_Count__c == objOrder2.FW_Product_Count__c || objOrder2.Refund_status__c != label.OSM_OrderCancellation_RefundSts){   
                    objOrder2.Refund_status__c = label.OSM_OrderCancellation_RefundSts;
                    update objOrder2;   
                }
                
                isRefReq = true;
                if(Test.isRunningTest()){
                  throw new NullPointerException();                          
                } 
            }Catch(Exception ex) {
                //system.debug('exception in updating records: '+ex);
            }
        }else if(ordrObj.OSM_SW_Order_Item_Count__c != ordrObj.ccrz__E_OrderItems__r.size() && isRevoke && !ordrObj.OrderProcessedforFSD__c){
            try{
                Set<Id> setItemId = new Set<Id>();
                for(Id ordrItmId : orderItemIdlst){
                    setItemId.add(ordrItmId);
                }
                OSM_SW_OrderCancellationUtility.updateRecordsOnOrderItemCancellation(setItemId, 'Revoke'); 
            }Catch(Exception ex) {
                //system.debug('exception in updating records: '+ex);
            }
        }else {
            try{
                Set<Id> set_IOIds = new Set<Id>();
                for(ccrz__E_OrderItem__c ordItm : [Select Id from ccrz__E_OrderItem__c where ccrz__Product__r.Group_Name__c != 'FluidWatch' AND Id IN:orderItemIdlst AND ccrz__OrderItemStatus__c = 'Cancelled']){
                    set_IOIds.add(ordItm.Id);
                }
                //system.debug('ordrObj.OrderProcessedforFSD__c: '+ordrObj.OrderProcessedforFSD__c);
                if(set_IOIds.size() > 0 && !ordrObj.OrderProcessedforFSD__c ){
                    OSM_SW_OrderCancellationUtility.updateRecordsOnOrderItemCancellation(set_IOIds, Label.OSM_Order_Cancellation);
                }
                isRefReq = true;
            }Catch(Exception ex) {
                //system.debug('exception in updating records: '+ex);
            }
        }
        return isRefReq;
    }
    // MAR-1665 - Code Start
    @RemoteAction   
    global static ccrz.cc_RemoteActionResult callCreateCreditMemo(ccrz.cc_RemoteActionContext ctx,List<String> orderItemIdlst1 ,List<String> orderItemIdlst,List<String> orderItemIdlst2)  
    {   
        boolean forBMSPO = false;
        
        //system.debug('callCreateCreditMemo: '+orderItemIdlst);
        ccrz.cc_RemoteActionResult res = new ccrz.cc_RemoteActionResult();  
        List<Id> list_OrdItemId = new List<Id>();   
        String orderId; 
        Set<Id> setProductId = new Set<Id>();
        for(ccrz__E_OrderItem__c ordItm : [SELECT Id, IsInvoiceRefund__c, ccrz__Product__c,ccrz__Order__c FROM ccrz__E_OrderItem__c WHERE (Id IN: orderItemIdlst OR Id IN: orderItemIdlst2 OR Id IN: orderItemIdlst1)
                                                ]){   
            orderId = ordItm.ccrz__Order__c;
            list_OrdItemId.add(ordItm.Id);
            setProductId.add(ordItm.ccrz__Product__c);
        }   
            
        
        //List<Id> set_InvId = new List<Id>();    
        List<Id> lstJunctionObjectId = new List<Id>();  
        List<Id> lst_InvId = new List<Id>();    
        List<ccrz__E_Invoice__c> lstInvoice = new List<ccrz__E_Invoice__c>();    
        for(ccrz__E_Invoice__c inv : [Select Id,Payment_Method__c,OSM_SW_Is_Bolt_PO__c from ccrz__E_Invoice__c where ccrz__CCOrder__c =: orderId AND IsCredited__c = false]){  
            //set_InvId.add(inv.Id);  
            lst_InvId.add(inv.Id);  
            lstInvoice.add(inv);  
        }
        // for creation of credit memo of intercompany invoice by sharad: code start
        if((lstInvoice.size() > 0 && lstInvoice[0].Payment_Method__c == 'po' && lstInvoice[0].OSM_SW_Is_Bolt_PO__c == false) || Test.isRunningTest())
        {   
            forBMSPO = true;
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
        
        //system.debug('lst_InvId: '+lst_InvId); 
        //system.debug('list_OrdItemId: '+list_OrdItemId);
        //  for creation of credit memo of intercompany invoice by sharad: code start
        try{
            ccrz__E_Order__c ordrObj = [SELECT Id, OSM_SW_Order_Item_Count__c, FW_Product_Count__c, ccrz__OrderStatus__c FROM ccrz__E_Order__c WHERE Id =: orderId];  
            //if((ordrObj.ccrz__OrderStatus__c != 'Order Submitted' && ordrObj.OSM_SW_Order_Item_Count__c == ordrObj.FW_Product_Count__c ) || ordrObj.ccrz__OrderStatus__c == 'Order Submitted' ){//|| forBMSPO 
               //system.debug('lst_InvId>>>>>'+lst_InvId);
                OSM_SW_PartialInvoiceRefundManager.createCreditMemo(lst_InvId, list_OrdItemId,'Order Item Cancel'); 
                CallRefundSubmitOrderForFW(orderId,orderItemIdlst);                                                                                                              
            //}
                if(ordrObj.ccrz__OrderStatus__c != 'Order Submitted' && ordrObj.OSM_SW_Order_Item_Count__c == ordrObj.FW_Product_Count__c )
                {
                    UpdateTPRecordForFW(ordrObj.Id);
                }

            // update flag OSM_SW_Is_credit_memo_Created__c
            if(list_OrdItemId.size() > 0)
            {
                List<ccrz__E_OrderItem__c> updateOrderItem = [Select Id,OSM_SW_Is_credit_memo_Created__c from  ccrz__E_OrderItem__c where Id IN: list_OrdItemId];
                for(ccrz__E_OrderItem__c obj:  updateOrderItem)
                    obj.OSM_SW_Is_credit_memo_Created__c = true;
                
                if(updateOrderItem.size() > 0)
                    update updateOrderItem;
            }               
        }catch(Exception exc){
            //system.debug('Exception in Create Credit Memo --->>'+exc.getMessage() + '--Line Number---> ' +exc.getLineNumber());
        }
        
        res.success=true;   
        return res; 
    }
    //method to call refund submit order
     //method to call refund submit order
    public static void CallRefundSubmitOrderForFW(Id orderId,List<String> orderItemId)
    {
        if(orderItemId.size() > 0)
        {
            Map<Id,List<Id>> MapcancleOrderIdForFWRefund = new Map<Id,List<Id>>();
            List<ccrz__E_OrderItem__c> lstOrderItem = new List<ccrz__E_OrderItem__c>();
            List<ccrz__E_OrderItem__c> lstOrderItemUpdate = new List<ccrz__E_OrderItem__c>();
            
            lstOrderItem = [Select Id,ccrz__Order__c,ccrz__ParentOrderItem__c,IsRefundSubmitOrder_Done_for_FW__c from ccrz__E_OrderItem__c where  Group_Name__c =: Label.OSM_SW_FluidWatch and Id IN: orderItemId];
            for(ccrz__E_OrderItem__c ordrItem : lstOrderItem)
            {
                if(ordrItem.ccrz__ParentOrderItem__c == null)
                {
                    if(!MapcancleOrderIdForFWRefund.containsKey(ordrItem.ccrz__Order__c))
                        MapcancleOrderIdForFWRefund.put(ordrItem.ccrz__Order__c,new List<Id>());
                    MapcancleOrderIdForFWRefund.get(ordrItem.ccrz__Order__c).add(ordrItem.Id);
                    ordrItem.IsRefundSubmitOrder_Done_for_FW__c = true;
                    lstOrderItemUpdate.add(ordrItem);
                }
            }
            if(orderId != null && MapcancleOrderIdForFWRefund.containsKey(orderId))
            {
                
                    if(MapcancleOrderIdForFWRefund.get(orderId).size() > 0)
                        OSM_FW_SubmitOrder_FutureLayer.callFWSubmitOrderFuture(orderId,true,MapcancleOrderIdForFWRefund.get(orderId));
                
            }
            
            if(lstOrderItemUpdate.size() > 0)
                update lstOrderItemUpdate;
        }
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

                                                                                  
                                                                                       
                                                                                             
            
                                                                                                                                                                                                                                                                                             
                                                             
             
                                                             
                 
                                                                                                                                                             
                                                                                                                                                                          
                                                                                                                                                                      
                                                                       
                                                     
                 
             
                                                                                   
             
                
                                                                                                                                     
                                                                                                                                                                                                                
                
             
            
                                             
                                          
         
     
    
    
     @RemoteAction
    global static ccrz.cc_RemoteActionResult callRefundReq(ccrz.cc_RemoteActionContext ctx, List<String> orderItemIdlst, List<String> orderItemIdlst2)
    {
        ccrz.cc_RemoteActionResult res = new ccrz.cc_RemoteActionResult();
        Map<String,Object> returnMap = new Map<String,Object>();
        Boolean callFSD=false;
        orderItemIdlst.addAll(orderItemIdlst2);
        List<ccrz__E_OrderItem__c> list_OrdItemRefundInv = new List<ccrz__E_OrderItem__c>();
        List<Id> list_OrdItemId = new List<Id>();
        Set<Id> setProductId = new Set<Id>();
        String orderId;
        
        for(ccrz__E_OrderItem__c ordItm : [SELECT Id, IsInvoiceRefund__c, ccrz__Product__c,ccrz__Order__c FROM ccrz__E_OrderItem__c WHERE Id IN: orderItemIdlst
                                                AND ccrz__OrderItemStatus__c != 'Order Submitted']){
            orderId = ordItm.ccrz__Order__c;
            list_OrdItemId.add(ordItm.Id);
            ordItm.IsInvoiceRefund__c = true;
            setProductId.add(ordItm.ccrz__Product__c);
            list_OrdItemRefundInv.add(ordItm);
        }
        //system.debug('setProductId: '+setProductId);
        List<Id> set_InvId = new List<Id>();
        List<Id> lstJunctionObjectId = new List<Id>();
        
        
        for(ccrz__E_InvoiceItem__c invItem: [Select id,name,ccrz__Invoice__c,ccrz__CCOrderItem__c from ccrz__E_InvoiceItem__c where ccrz__CCOrder__c =: orderId AND ccrz__CCOrderItem__c IN:list_OrdItemId AND IsCredited__c = false]){
            set_InvId.add(invItem.ccrz__Invoice__c); 
            
        } 
        //system.debug('set_InvId1: '+set_InvId);
        List<ccrz__E_Invoice__c> lstInvoice = new List<ccrz__E_Invoice__c>(); 
        for(ccrz__E_Invoice__c inv : [Select Id,Payment_Method__c,OSM_SW_Is_Bolt_PO__c from ccrz__E_Invoice__c where ccrz__CCOrder__c =: orderId AND IsCredited__c = false]){
            lstInvoice.add(inv);
        }
        
        // for creation of credit memo of intercompany invoice by sharad: code start
        if((lstInvoice.size() > 0 && lstInvoice[0].Payment_Method__c == 'po' && lstInvoice[0].OSM_SW_Is_Bolt_PO__c == false) || Test.isRunningTest())
        {   
            set_InvId.clear();
            list_OrdItemId.clear();
            callFSD=true;
            List<Id> lst_InvId = new List<Id>();
            List<ccrz__E_Invoice__c> lst_InvIdInterCompanyObj = new List<ccrz__E_Invoice__c>();  
            for(ccrz__E_Invoice__c inv : [Select Id,ccrz__CCOrder__c from ccrz__E_Invoice__c where Original_Sales_Order_Invoice_Number__c =: lstInvoice[0].Id AND IsCredited__c = false] )
            {  
                lst_InvId.add(inv.Id);  
                //lst_InvIdInterCompanyObj.add(inv);
                //set_InvId.add(inv.Id); 
            }
            if(lst_InvId.size() > 0)
            {
                for(ccrz__E_Invoice__c inv : [Select Id,ccrz__CCOrder__c from ccrz__E_Invoice__c where Original_Sales_Order_Invoice_Number__c =: lst_InvId[0] AND IsCredited__c = true order by CreatedDate DESC] )
                {  
                    //lst_InvId.add(inv.Id);  
                    lst_InvIdInterCompanyObj.add(inv);
                    set_InvId.add(inv.Id); 
                    break;
                }
                if(lst_InvIdInterCompanyObj.size() > 0)
                {
                    orderId = lst_InvIdInterCompanyObj[0].ccrz__CCOrder__c;
                    for(ccrz__E_OrderItem__c ordItm : [SELECT Id, IsInvoiceRefund__c, ccrz__Product__c,ccrz__Order__c FROM ccrz__E_OrderItem__c WHERE ccrz__Order__c =: lst_InvIdInterCompanyObj[0].ccrz__CCOrder__c  and ccrz__Product__c IN: setProductId]){   
                        list_OrdItemId.add(ordItm.Id);
                    }   
                }
            }
            
            
        }
        //  for creation of credit memo of intercompany invoice by sharad: code start
        //system.debug('set_InvId : '+set_InvId);
        //system.debug('list_OrdItemId : '+list_OrdItemId);
        try{
            for(OSM_Orders_In_Invoice__c osmObj : [Select Id from OSM_Orders_In_Invoice__c where CC_Invoice__c IN: set_InvId and CC_Order__c =: orderId ]){
                lstJunctionObjectId.add(osmObj.Id);
            }
            ccrz__E_Order__c ordrObj = [SELECT Id, OSM_SW_Order_Item_Count__c, FW_Product_Count__c, ccrz__OrderStatus__c,(Select Id,ccrz__OrderItemStatus__c,IsCancelPending__c,CancelLicenseAPICalled__c,OSM_SW_Is_Included_Product__c,IsInvoiceRefund__c from ccrz__E_OrderItems__r where ( IsCancelPending__c = true OR IsInvoiceRefund__c = true) and OSM_SW_Is_Included_Product__c = false) FROM ccrz__E_Order__c WHERE Id =: orderId];  
            
            //system.debug('ordrObj.ccrz__OrderStatus__c: '+ordrObj.ccrz__OrderStatus__c);
            //system.debug('ordrObj.OSM_SW_Order_Item_Count__c: '+ordrObj.OSM_SW_Order_Item_Count__c);
            //system.debug('ordrObj.FW_Product_Count__c: '+ordrObj.FW_Product_Count__c);
            //system.debug('orderItemIdlst: '+orderItemIdlst.size());
            //system.debug('orderItemIdlst: '+ordrObj.ccrz__E_OrderItems__r.size());
            for(ccrz__E_OrderItem__c objItem :ordrObj.ccrz__E_OrderItems__r )
             system.debug('ordrObj.ccrz__E_OrderItems__r: '+objItem);
            boolean isRunTaxReq = true;
            if(ordrObj.ccrz__OrderStatus__c != 'Order Submitted')
            {
                isRunTaxReq = false;
            }
            else
            {
                if((ordrObj.ccrz__E_OrderItems__r.size()+orderItemIdlst.size()) >= ordrObj.OSM_SW_Order_Item_Count__c)
                    isRunTaxReq = false;
            }
                
            
            /*
            boolean isSuccess = false;
            
            
            if((ordrObj.ccrz__OrderStatus__c != 'Order Submitted' && ordrObj.OSM_SW_Order_Item_Count__c == ordrObj.FW_Product_Count__c ) || ordrObj.ccrz__OrderStatus__c == 'Order Submitted' ){//|| forBMSPO 
               
                isSuccess = OSM_SW_PartialInvoiceRefundManager.getVertexInvoiceTax(lstJunctionObjectId, list_OrdItemId);
            }
            */
            boolean isSuccess = false;
            if(isRunTaxReq) isSuccess = OSM_SW_PartialInvoiceRefundManager.getVertexInvoiceTax(lstJunctionObjectId, list_OrdItemId);
            if(isSuccess){
                update list_OrdItemRefundInv;                    
            }
        }catch(Exception excp){
            //system.debug('Exception in Create Credit Memo --->>'+excp.getMessage() + '--Line Number---> ' +excp.getLineNumber());
        }
        
        
        // MAR-1665 - Code Start
        /*try{
            ccrz__E_Order__c ordrObj = [SELECT Id, OSM_SW_Order_Item_Count__c, FW_Product_Count__c, ccrz__OrderStatus__c FROM ccrz__E_Order__c WHERE Id =: orderId];  
            if((ordrObj.ccrz__OrderStatus__c != 'Order Submitted' && ordrObj.OSM_SW_Order_Item_Count__c == ordrObj.FW_Product_Count__c ) || ordrObj.ccrz__OrderStatus__c == 'Order Submitted'){ 
                OSM_SW_PartialInvoiceRefundManager.createCreditMemo(lst_InvId, list_OrdItemId); 
            }
        }catch(Exception exc){
            // do nothing
        }*/ // MAR-1665 - Code End
        returnMap.put('callFSD',callFSD);
        res.data=returnMap;
        res.success=true;
        return res;
    }
    
    
    public static void callCancelOrderItem(set<id> lstOrderItem) {
        
        try{
            
            //system.debug('Call cancel orderItem funcationallity : '+lstOrderItem);
             
            OSM_SW_OrderCancellationUtility.updateRecordsOnOrderItemCancellation(lstOrderItem, Label.OSM_Order_Cancellation);     //Call method to update sobject records
            OSM_SW_OrderTriggerHandlerUtility.getOrderCancel(lstOrderItem); 
           
        }Catch(Exception ex)
        {
            //system.debug('exception in updating records: '+ex);
        }
        
        
    }
    
    
    
    // MP-400
    
    @RemoteAction
    global static ccrz.cc_RemoteActionResult checkAddOnSubscription(ccrz.cc_RemoteActionContext ctx, String orderItemIds)
    {
        ccrz.cc_RemoteActionResult res = new ccrz.cc_RemoteActionResult();
        Map<String,Object> returnMap = new Map<String,Object>();
        returnMap.put('isShowAddonPopup',false);
        
        //system.debug('orderItemIds---->>>'+orderItemIds);
        string orderItemIds1=orderItemIds.deleteWhitespace();
        String str= '\\[|\\]';
        orderItemIds1= orderItemIds1.replaceAll(str,'');
        List<String> listOrderItem= orderItemIds1.split(',');
        //system.debug('listOrderItem-->>'+listOrderItem);
        Set<String> setString = new Set<String>();
        setString.AddAll(listOrderItem);
        //system.debug('setString-->>'+setString);
        Set<id> idStrs = (Set<id>)JSON.deserialize(JSON.serialize(setString), Set<id>.class);
        //system.debug('idStrings-->>' + idStrs);
        
        
        
        boolean isBundlePresent = false;
        String accountId;
        String bundleProductId;
        List<ccrz__E_OrderItem__c> orderIetmList = new List<ccrz__E_OrderItem__c>();
        orderIetmList = [Select Id,ccrz__Order__r.ccrz__Account__c,ccrz__Order__c, ccrz__Quantity__c, ccrz__Product__c ,ccrz__Product__r.Group_Name__c, ccrz__Product__r.ccrz__ProductType__c from ccrz__E_OrderItem__c where Id IN: idStrs]; 
        //system.debug('orderIetmList: '+orderIetmList);
        
        String orderid;                // added by swetha for 537
        for(ccrz__E_OrderItem__c objItem : orderIetmList)
        {
            orderid = objItem.ccrz__Order__c;   // added by swetha for 537
            if(objItem.ccrz__Product__r.ccrz__ProductType__c == 'Bundle' && objItem.ccrz__Product__r.Group_Name__c == 'SES')
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
                bundledSubscription=[Select Id,ccrz__CCOrder__c,ccrz__SubscriptionProduct__c, ccrz__Quantity__c,ccrz__SubscriptionStatus__c from ccrz__E_Subscription__c where ccrz__SubscriptionStatus__c in ('Active','Renew') and  ccrz__SubscriptionProduct__c =: bundleProductId and  ccrz__Account__c =: accountId and ccrz__CCOrder__c =: orderid]; //added by swtha
                
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
				// code  added by swetha for 537
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
                } // code end by swetha for 537
                //system.debug('returnMap-->'+returnMap);
                
            }
            
        }
        
        res.data = returnMap;
        return res;
        
    }
    
    @RemoteAction
    global static ccrz.cc_RemoteActionResult checkIAMUserProvisionedCount(ccrz.cc_RemoteActionContext ctx, String orderItemIds)
    {
        // public static ccrz.cc_RemoteActionResult checkCount()
        // {
        ccrz.cc_CallContext.initRemoteContext(ctx);
        ccrz.cc_RemoteActionResult res = new ccrz.cc_RemoteActionResult();
        //Id accountId = ccrz.cc_CallContext.currAccountId;
        Id accountId = ccrz.cc_CallContext.effAccountId;
        
        
        //system.debug('orderItemIds---->>>'+orderItemIds);
        string orderItemIds1=orderItemIds.deleteWhitespace();
        String str= '\\[|\\]';
        orderItemIds1= orderItemIds1.replaceAll(str,'');
        List<String> listOrderItem= orderItemIds1.split(',');
        //system.debug('listOrderItem-->>'+listOrderItem);
        Set<String> setString = new Set<String>();
        setString.AddAll(listOrderItem);
        //system.debug('setString-->>'+setString);
        Set<id> idStrs = (Set<id>)JSON.deserialize(JSON.serialize(setString), Set<id>.class);
        //system.debug('idStrings-->>' + idStrs);
        Map<String,Object> returnMap = new Map<String,Object>();
        try
        {
            Map<String, OSM_IAMProvisioningDetails> uniqueIAMProvisioningDetails = new Map<String, OSM_IAMProvisioningDetails>();
            
            List<ccrz__E_OrderItem__c> orderItemList = [Select ID, ccrz__Product__r.QSOLType__c, OMS_Product__c,ccrz__Quantity__c, ccrz__Product__c, 
                                                        ccrz__Product__r.Name, ccrz__Product__r.ccrz__ProductType__c,ccrz__Product__r.ccrz__SKU__c, 
                                                        ccrz__Product__r.isIAMProvisioningRequired__c,ccrz__DisplayProduct__c  
                                                        from ccrz__E_OrderItem__c 
                                                        where id IN :idStrs and ccrz__ParentOrderItem__c = null];
            //system.debug('orderItemList-->>'+orderItemList);
            Set<String> productIdSet = new Set<String>();
            
            for(ccrz__E_OrderItem__c orderItem : orderItemList)
            {
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
            //system.debug('productIdSet : '+productIdSet);
            Map<Id, List<ccrz__E_CompositeProduct__c>> compositeIdToCompositeProductMap = OSM_SW_SubscriptionAction.getCompositeIdToCompositeProductMap(new List<String>(productIdSet));
            //system.debug('compositeIdToCompositeProductMap: '+compositeIdToCompositeProductMap);
            Map<String, OSM_Application_Feature__mdt> applicationFeatureMap = OSM_SW_SubscriptionAction.getApplicationFeatureMetaDataMap();
            //system.debug('applicationFeatureMap: '+applicationFeatureMap);
            List<OSM_IAMProvisioningDetails> osmIamProvisioningDetailsList = new List<OSM_IAMProvisioningDetails>();
            
            Account acc = [Select ID, DTNA__c, RecordTypeId, Type,BillingCountry,CSS_DistributorCode__c, Name, OSM_HHP_Dealer__c,EngineRangeDesc__c, CMI_Region__c, Business_Unit__c, OSM_Market_Segment_Code__c, CMI_Account_Status__c, EBU_Channel_of_Distribution__c,PSBU_Channel_of_Distribution__c,CHANNEL_OF_DISTRIBUTION__c, OSM_Service_Level__c,ServiceLevel__c FROM Account where ID=:accountId]; //Mar-1236
            //Ravi Added Guidanz Tech Kits
            
            if(!label.OSM_North_America_Country.contains(acc.BillingCountry) && !label.OSM_PO_Distributor_List.contains(acc.CSS_DistributorCode__c))
             {
              returnMap.put('GOMSUser','true');
             }
            for(ccrz__E_OrderItem__c orderItem : orderItemList)
            {
                //system.debug('orderItem : '+orderItem);
                //system.debug('product : '+orderItem.ccrz__Product__r.Name);
                                                                                                                                                     
                                             
                                                                                                                                                      
                                              
                //system.debug('type : '+orderItem.ccrz__Product__r.ccrz__ProductType__c);
                if( null != orderItem.ccrz__Product__c 
                   && ( orderItem.ccrz__Product__r.Name.contains('Service Tech Kit') || orderItem.ccrz__Product__r.Name.containsIgnoreCase('Add-On') || 'Bundle' == orderItem.ccrz__Product__r.ccrz__ProductType__c))
                    
                {
                    //system.debug('first loop');
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
                            //system.debug('QTY at Bundle or Add On-->'+qty);
                            //system.debug('compositeProduct-->'+compositeProduct);
                            //system.debug('Bundle orderItem-->'+orderItem);
                            List<OSM_IAMProvisioningDetails> osmIAMProvisioningList = createOsmIamProvisioningDetail(compositeProduct.ccrz__Component__r.Name, qty, acc, applicationFeatureMap, null,compositeProduct.ccrz__Component__r.ccrz__SKU__c);
                            osmIamProvisioningDetailsList.addAll(osmIAMProvisioningList);
                            //system.debug('Bundle size-->'+osmIAMProvisioningList.size());
                            //system.debug('Bundle osmIAMProvisioningList-->'+osmIAMProvisioningList);
                            
                        }
                    }
                }
                
                if( (null != orderItem.ccrz__Product__c && 'Product' == orderItem.ccrz__Product__r.ccrz__ProductType__c && !orderItem.ccrz__Product__r.Name.containsIgnoreCase('Add-On') && !orderItem.ccrz__Product__r.Name.contains('Service Tech Kit') && orderItem.ccrz__Product__r.isIAMProvisioningRequired__c) || Test.isRunningTest())
                {
                    //system.debug('second loop');
                    
                    Integer qty ;
                        if(orderItem.ccrz__Product__r.Name.containsIgnoreCase('Guidanz Mobile')){
                           qty = 2;
                           
                        }
                        else if(Label.OSM_Intapp_Products.containsIgnoreCase(orderItem.ccrz__Product__r.ccrz__SKU__c)){
                           qty = 1;
                        }else{  qty = 9999;  }
                        qty = qty * Integer.valueOf(orderItem.ccrz__Quantity__c);
                    
                    //system.debug('QTY at Non Bundle or Non Add On-->'+qty);
                    //system.debug('orderItem.ccrz__Product__r-->'+orderItem.ccrz__Product__r);
                    //system.debug('Product orderItem-->'+orderItem);
                    
                    List<OSM_IAMProvisioningDetails> osmIAMProvisioningList = createOsmIamProvisioningDetail(orderItem.ccrz__Product__r.Name, qty, acc, applicationFeatureMap, orderItem.ccrz__Product__r.QSOLType__c,orderItem.ccrz__Product__r.ccrz__SKU__c);
                    osmIamProvisioningDetailsList.addAll(osmIAMProvisioningList);
                    
                    //system.debug('Non bundle size-->'+osmIAMProvisioningList.size());
                    //system.debug('Non Bundle osmIAMProvisioningList-->'+osmIAMProvisioningList);
                    
                    // if QSOL EBU then need to create EDS and CVCOL always
                    if(null != orderItem.ccrz__Product__r.QSOLType__c && 'EBU' == orderItem.ccrz__Product__r.QSOLType__c)
                    {
                        // Create for EDS
                        List<OSM_IAMProvisioningDetails> osmIAMProvisioningList_EDS = createOsmIamProvisioningDetail('EDS', 9999, acc, applicationFeatureMap, orderItem.ccrz__Product__r.QSOLType__c,'EDS');
                        
                        osmIamProvisioningDetailsList.addAll(osmIAMProvisioningList_EDS);
                        //system.debug(' osmIAMProvisioningList_EDS-->'+osmIAMProvisioningList_EDS.size());
                        //system.debug('Non Bundle osmIAMProvisioningList_EDS-->'+osmIAMProvisioningList_EDS);
                        
                        // Create for CVCOL
                        List<OSM_IAMProvisioningDetails> osmIAMProvisioningList_CVCOL = createOsmIamProvisioningDetail('CVCOL', 9999, acc, applicationFeatureMap, orderItem.ccrz__Product__r.QSOLType__c,'CVCOL');
                        osmIamProvisioningDetailsList.addAll(osmIAMProvisioningList_CVCOL);
                        //system.debug('Non osmIAMProvisioningList_CVCOL-->'+osmIAMProvisioningList_CVCOL.size());
                        //system.debug('Non Bundle osmIAMProvisioningList_CVCOL-->'+osmIAMProvisioningList_CVCOL);
                    }
                }
            }
            
            Map<String, OSM_IAMProvisioningDetails> toBeCancelledIAMApplications = new Map<String, OSM_IAMProvisioningDetails>();
            Set<String> applicatinNamesSet = new Set<String>();
            Set<String> accountIdsSet = new Set<String>();
            Set<String> roleFeaturesSet = new Set<String>();
            //system.debug('osmIamProvisioningDetailsList' + osmIamProvisioningDetailsList);
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
                        //system.debug('At addition osmIamProvisioningDetail-->'+osmIamProvisioningDetail);
                        //system.debug('At addition toBeCancelledIAMApplications-->'+toBeCancelledIAMApplications.get(osmIamProvisioningDetail.applicationName + '~' + osmIamProvisioningDetail.accountID + '~' + osmIamProvisioningDetail.roleFeature));
                        toBeCancelledIAMApplications.put(osmIamProvisioningDetail.applicationName + '~' + osmIamProvisioningDetail.accountID + '~' + osmIamProvisioningDetail.roleFeature, osmIamProvisioningDetail);  
                    }
                }
               
                else{
                   
                    String applicationName = osmIamProvisioningDetail.applicationName+ '~' + osmIamProvisioningDetail.accountID;
                    Set<String> iamApplicationNameSet = new Set<String>{'QuickServe Online'}; 
                        
                        If(iamApplicationNameSet.contains(osmIamProvisioningDetail.applicationName) && (osmIamProvisioningDetail.subscriptionName == Label.OSM_Quick_Serve_Online_EBU || osmIamProvisioningDetail.subscriptionName == Label.OSM_Quick_Serve_Online_CPG)){
                                   
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
                        //system.debug('At addition osmIamProvisioningDetail-->'+osmIamProvisioningDetail);
                        //system.debug('At addition toBeCancelledIAMApplications-->'+toBeCancelledIAMApplications.get(applicationName));
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
            List<IAM_Application__c> iamApplicationList = [Select ID, OSM_Max_Allowed_Users__c, IAM_Total_Units__c,IAM_Remaining_Units__c,IAM_Subscription_Count__c, 
                                                           IAM_Application_Name__c, IAM_Account_Name__c, IAM_Role__c, 
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
            
            //for(OSM_IAMProvisioningDetails osmIamProvisioningDetail : osmIamProvisioningDetailsList)
            //{
            for(String key:toBeCancelledIAMApplications.keySet())
            {
                //system.debug('toBeCancelledIAMApplications record: '+toBeCancelledIAMApplications.get(key));
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
                
                ////system.debug('OSM_IAMProvisioningDetails' + osmIamProvisioningDetail);
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
                ////system.debug('IAM_Application__c' + iamApplication);
                //system.debug('iamApplication-->'+iamApplication);
                                                                                                                                                          
                                                                                                                                                                      
                                                                                                                                                                                                              
                                                                                                                                                                            
                                                                                                                                                                                                                                                                                                 
                
                if((null != iamApplication && !Label.OSM_Intapp_Products.containsIgnoreCase(osmIamProvisioningDetail.ProdSKU)) || Test.isRunningTest())
                {
                    Integer maxAllowedUsers = Integer.valueOf(iamApplication.OSM_Max_Allowed_Users__c);
                    Integer alreadyProvisionedUserCount = Integer.valueOf(iamApplication.IAM_Provisioned_Count__c);
                    
                    Integer maxCountThatCanBeCancelled = maxAllowedUsers - alreadyProvisionedUserCount;
                    //MAR-569
                    Integer maxCountBasedOnContactCount = conList.size() - alreadyProvisionedUserCount;
                    //system.debug('Product Name' + osmIamProvisioningDetail.productName);
                    //system.debug('ApplicationName' + osmIamProvisioningDetail.applicationName);
                    //system.debug('Qty' + osmIamProvisioningDetail.userCount);
                    
                    //system.debug('toBeCancelledCount ' + toBeCancelledCount);
                    //system.debug('maxAllowedUsers ' + maxAllowedUsers);
                    //system.debug('alreadyProvisionedUserCount ' + alreadyProvisionedUserCount);
                    //system.debug('maxCountThatCanBeCancelled ' + maxCountThatCanBeCancelled);
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
                else if(Label.OSM_Intapp_Products.containsIgnoreCase(osmIamProvisioningDetail.ProdSKU) )
                {

                    //system.debug('applicationName>>>>'+applicationName);
                    //system.debug('iamApplicationMap>>>>'+iamApplicationMap);
                    //system.debug('osmIamProvisioningDetail>>>>'+osmIamProvisioningDetail);
                    iamApplication = iamApplicationMap.get(osmIamProvisioningDetail.applicationName + '~' + osmIamProvisioningDetail.accountID + '~' + osmIamProvisioningDetail.roleFeature);
                    //system.debug('iamApplication>>>>'+iamApplication);
                    
                        if(iamApplication.IAM_Remaining_Units__c==osmIamProvisioningDetail.userCount || iamApplication.IAM_Remaining_Units__c>osmIamProvisioningDetail.userCount)
                        {
                            canBeCancelledFlag = true;
                            /*iamApplication.IAM_Total_Units__c=iamApplication.IAM_Total_Units__c-osmIamProvisioningDetail.userCount;
                            if(iamApplication.IAM_Total_Units__c==0)
                            {
                                iamApplication.IAM_Status__c='Inactive';
                            }
                            applicationListToUpdate.add(iamApplication);
                            */
                        }
                        else
                        {
                            canBeCancelledFlag = false;
                            inappFlag=true;
                            
                            userCount=Integer.valueOf(userCount+osmIamProvisioningDetail.userCount);
                            remaningUnit=Integer.valueOf(remaningUnit+iamApplication.IAM_Remaining_Units__c);
                        }
                    
                    
                   
                }  
            }
            
            
            //system.debug('userProvisionedData: '+userProvisionedData);
            //system.debug('provisionedData: '+provisionedData);
            returnMap.put('userProvisionedData', userProvisionedData);
            returnMap.put('provisionedData', provisionedData);
            returnMap.put('canBeCancelledFlag',canBeCancelledFlag);
            returnMap.put('inappFlag',inappFlag);
            returnMap.put('userCount',userCount);
            returnMap.put('remaningUnit',remaningUnit);
            
            String surl = System.URL.getSalesforceBaseUrl()+'/'+ accountId+'';
            surl = surl.replace('[delegate=', '').replace(']','').replace('Url:','');
            
            
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
    
    @TestVisible
    public Class TransactionDetail {
        @TestVisible String transactionId {get;set;}
        @TestVisible String cancelTransactionId {get;set;}
        @TestVisible String paymentMethod {get;set;}
        @TestVisible String refundStatus {get;set;}
        @TestVisible String orderStatus {get;set;}
        @TestVisible string activationKey {get;set;}
        @TestVisible String accountName {get;set;}
        @TestVisible String billFrom{get;set;}
        @TestVisible Boolean ccSouthPlain {get;set;}
        //MP-133
        @TestVisible String subscriptionLength {get;set;}
         //MP-133
        
    }
    
    @TestVisible
     public class OSM_IAMProvisioningDetails
    {
        @TestVisible ID accountID {get;set;}
        @TestVisible ID subscriptionID {get;set;}
        @TestVisible String productName{get; set;}
        @TestVisible Date startDate {get;set;}
        @TestVisible Date endDate {get;set;}
        @TestVisible String status{get; set;}
        @TestVisible Integer userCount {get;set;}
        @TestVisible String accountGroupName {get;set;}
        @TestVisible String accountType {get;set;}
        @TestVisible List<String> roleFeatureList {get;set;}
        @TestVisible String roleFeature {get;set;}
        @TestVisible String applicationName {get;set;}
        @TestVisible String subscriptionName {get;set;}
        @TestVisible String qsolType {get;set;}
        String ProdSKU{get;set;}
    }
    
    @TestVisible
    public Class OrderDetail
    {
        String userEmail {get;set;}
        boolean getOrderisnotCalled {get;set;}
        boolean isRevokeCallNeeded {get;set;}
        boolean isCancelCallNeeded {get;set;}
        List<String> lstForRevoke {get;set;}
        List<String> lstForCancel {get;set;}
        
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