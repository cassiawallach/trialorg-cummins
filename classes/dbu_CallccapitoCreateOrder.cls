public without sharing class dbu_CallccapitoCreateOrder {
    
    @AuraEnabled
    public static string CreateOrder(string cartid, String tpdata)
    {
        
        string orderid;
        
        Map<String,String> taxMap = new Map<String,String>();
        Map<String, Object> transData = (Map<String, Object>)JSON.deserializeUntyped(tpdata);
        //######### Formulate the Transaction Data Param ############
        TransactionPaymentParams TPP = new TransactionPaymentParams();
        TPP.accountNumber = (String)transData.get('accountNumber');
        TPP.accountType = 'DBUCom Reseller';// get it from cart account name
        TPP.paymentType = (String)transData.get('paymentType');
        TPP.storefront = 'CSSNAStore';
        TPP.token = (String)transData.get('token');
        //TPP.transactionCode = 'i386';
        TPP.transactionPaymentId = (String)transData.get('transactionPaymentId');
        TPP.transactionSubcode = (String)transData.get('transactionSubcode');
        TPP.transactionCode = (String)transData.get('transactionCode');//Shriram 7Dec21
        TPP.transactionType = (String)transData.get('transactionType');
        //TPP.verificationCode = 'T-84-YK';
        TPP.saveAsStoredPayment = true ;
        TPP.accountName = 'Generic Mechine';// get it from account name of cart
        
        //######### Serialize the Transaction Data Param - we need this ############
        string PARAM_TRANSACTION_DATA_INPUT_STRING = JSON.serialize(TPP);
        
        //######### Current Cart to be converted to Order ###########
        string current_cartid = cartid;
        
        //######### Retrive the CC Cart in the ccrz__E_Cart__c object form #######################################
        /*NOTE :- 
Here i am not using the CC cart fetch api as it returns values in the Map<string,object> format which
the below ccrz.cc_hk_Payment.PARAM_CART does not accept as valid.
*/
        
        ccrz__E_Cart__c cartinst = [select id,ccrz__Account__c,ccrz__TotalAmount__c,ccrz__BuyerEmail__c,ccrz__BuyerPhone__c from ccrz__E_Cart__c where id =: current_cartid];
        system.debug('cartinst > ' + cartinst);
        
        if(cartinst != null )
        {   
            if(String.isBlank(cartinst.ccrz__BuyerEmail__c) && String.isBlank(cartinst.ccrz__BuyerPhone__c)){ 
                return 'NoData'; //CHG0085464
            }
            ccrz.cc_RemoteActionContext ctx = new ccrz.cc_RemoteActionContext();
            ctx.storefront = 'CSSNAStore';
            ccrz.cc_CallContext.currAccountId = cartinst.ccrz__Account__c;
            /*
ccrz.cc_CallContext.userCurrency = 'USD';
ccrz.cc_CallContext.effAccountId = acc.id;
//ccrz.cc_CallContext.currCartId = cartID;
ccrz.cc_CallContext.userLocale = 'en_US';
ccrz.cc_CallContext.currContact= cnts;*/
            //ccrz.cc_CallContext.storeFrontSettings = storefrontsettings;
            ccrz.cc_CallContext.initRemoteContext(ctx); 
        }
        
        //######## Formulate InputData for Process Payment method ###############################
        Map<String, Object> InputData = new Map<String, Object>{
            ccrz.cc_hk_Payment.PARAM_CART =>   cartinst,  
                ccrz.cc_hk_Payment.PARAM_TRANSACTION_DATA => PARAM_TRANSACTION_DATA_INPUT_STRING
                };
                    try{
                        //Fire the Process Payment method 
                        ccrz.cc_hk_Payment ulr = new ccrz.cc_hk_Payment();
                        Map<string,object> RetResponse =  ulr.processPayment(InputData);
                        system.debug('RetResponse - we need this > ' + RetResponse);  
                        
                        //Retrive ccrz.cc_hk_Payment.PARAM_ACCOUNT_TYPE
                        string ret_PARAM_ACCOUNT_TYPE;
                        if(RetResponse.get(ccrz.cc_hk_Payment.PARAM_ACCOUNT_TYPE) != null){
                            ret_PARAM_ACCOUNT_TYPE = (string)RetResponse.get(ccrz.cc_hk_Payment.PARAM_ACCOUNT_TYPE);            
                            system.debug('ret_PARAM_ACCOUNT_TYPE > ' + ret_PARAM_ACCOUNT_TYPE);
                        }
                        
                        //Retrive ccrz.cc_hk_Payment.PARAM_PAYMENT_PROCESSOR
                        Map<string,object> ret_PARAM_PAYMENT_PROCESSOR = new Map<string,object>();
                        if(RetResponse.get(ccrz.cc_hk_Payment.PARAM_PAYMENT_PROCESSOR) != null){
                            ret_PARAM_PAYMENT_PROCESSOR = (Map<string,object>)RetResponse.get(ccrz.cc_hk_Payment.PARAM_PAYMENT_PROCESSOR);
                            system.debug('ret_PARAM_PAYMENT_PROCESSOR > ' + ret_PARAM_PAYMENT_PROCESSOR);
                        }
                        
                        //Retrive ccrz.cc_hk_Payment.PARAM_TRANSACTION_DATA
                        string ret_PARAM_TRANSACTION_DATA;
                        if(RetResponse.get(ccrz.cc_hk_Payment.PARAM_TRANSACTION_DATA) != null){
                            ret_PARAM_TRANSACTION_DATA = (string)RetResponse.get(ccrz.cc_hk_Payment.PARAM_TRANSACTION_DATA);
                            system.debug('ret_PARAM_TRANSACTION_DATA > ' + ret_PARAM_TRANSACTION_DATA);            
                        }
                        
                        //Retrive ccrz.cc_hk_Payment.PARAM_TRANSACTION_PROCESSED_DATA - we need this
                        ccrz.cc_hk_Payment.TransactionPaymentParams ret_PARAM_TRANSACTION_PROCESSED_DATA = new ccrz.cc_hk_Payment.TransactionPaymentParams();
                        if(RetResponse.get(ccrz.cc_hk_Payment.PARAM_TRANSACTION_PROCESSED_DATA) != null){
                            //Map<string,object> ret_PARAM_TRANSACTION_PROCESSED_DATA = (Map<string,object>)RetResponse.get(ccrz.cc_hk_Payment.PARAM_TRANSACTION_PROCESSED_DATA);
                            ret_PARAM_TRANSACTION_PROCESSED_DATA = (ccrz.cc_hk_Payment.TransactionPaymentParams)RetResponse.get(ccrz.cc_hk_Payment.PARAM_TRANSACTION_PROCESSED_DATA);
                            system.debug('ret_PARAM_TRANSACTION_PROCESSED_DATA > ' + ret_PARAM_TRANSACTION_PROCESSED_DATA);
                        }
                        
                        
                        
                        Map<string,object> PlaceOrderInputData = new Map<string,object>{
                            
                            ccrz.ccApi.API_VERSION => ccrz.ccApi.CURRENT_VERSION,
                                
                                ccrz.ccApiCart.CARTSTATUS => 'Closed',
                                ccrz.ccAPIProduct.PRODUCTSTOREFRONT => 'CSSNAStore',
                                
                                ccrz.ccApiOrder.PARAM_ORDER_STATUS => 'Order Submitted',
                                
                                ccrz.ccApiCart.ACTIVECART => false,
                                
                                ccrz.ccApiCart.CART_ID => cartid,
                                //Following are the Transaction Params .                
                                ccrz.ccApiCart.PAYMENTDATA => PARAM_TRANSACTION_DATA_INPUT_STRING,
                                ccrz.ccApiCart.TRANSPAYMENTDATA => ret_PARAM_TRANSACTION_PROCESSED_DATA,
                                ccrz.ccApiCart.PAYMENTRESULT => RetResponse,
                                ccrz.ccApiCart.SKIP_VALID_CHECK => True
                                };
                                    
                                    System.debug('Going to call cc api to create order');
                        Map<string, object> PlaceOrderCall = ccrz.ccApiCart.place(PlaceOrderInputData);
                        system.debug('PlaceOrderCall'+json.serialize(PlaceOrderCall));
                        
                        system.debug('SUCCESS CNF >>> ' + PlaceOrderCall.get(ccrz.ccApi.SUCCESS));
                        
                        system.debug('GENERATED ORDER ID >>> ' + PlaceOrderCall.get(ccrz.ccApiCart.ORDER_ID));
                        orderid=(string)PlaceOrderCall.get(ccrz.ccApiCart.ORDER_ID);
                        system.debug('orderid'+orderid);
                        
                        
                        //Added by Malhar Ulhas Agale - Begin - temporary modification for 3rd and 4th december 2020 Demo. 
                        //Following code will update all create orderitems status to 'Order Submitted' for current order.            
                        list<ccrz__E_OrderItem__c> CurrentorderItems = [select ccrz__OrderItemStatus__c,ccrz__Order__r.CC_Order__c,ccrz__OrderItemId__c
                                                                        from ccrz__E_OrderItem__c 
                                                                        where ccrz__Order__c =: orderid];
                        
                        system.debug('CurrentorderItems > '+ CurrentorderItems);
                        
                        for(ccrz__E_OrderItem__c eachitem : CurrentorderItems){
                            eachitem.ccrz__OrderItemStatus__c = 'Order Submitted';
                            // added by Ranadip
                            if(eachitem.ccrz__Order__r.CC_Order__c == null){
                                taxMap.put(eachitem.ccrz__OrderItemId__c,eachitem.Id);
                            }
                        }
                        if(!taxMap.isEmpty()){
                            updateTaxObject(taxMap);
                        }
                        
                        //sharad for payment method:
                        ccrz__E_Order__c newObjOrder = new ccrz__E_Order__c();
                        newObjOrder.Id = orderid;
                        newObjOrder.ccrz__PaymentMethod__c = (String)transData.get('paymentType');
                        update newObjOrder;
                        
                        
                        
                        Database.SaveResult[] srList = Database.update(CurrentorderItems, false);
                        // Iterate through each returned result
                        for (Database.SaveResult sr : srList) {
                            if (sr.isSuccess()) {                       
                                System.debug('Successfully updated orderlines ids : ' + sr.getId());
                            }
                            else {
                                // Operation failed, so get all errors                
                                for(Database.Error err : sr.getErrors()) {
                                    System.debug('The following error has occurred.');                    
                                    System.debug(err.getStatusCode() + ': ' + err.getMessage());
                                    System.debug('Orderline fields that affected this error: ' + err.getFields());
                                }
                            }
                        }
                        //Added by Malhar Ulhas Agale - End - temporary modification for 3rd and 4th december 2020 Demo.
                        
                        /*Shriram :24-09-2020*/
                        //System.debug('JSON.serialize(orderSubmitRequestData)\t'+JSON.serialize(orderSubmitRequestData));
                        //dbu_Integration_OrderSubmit.getOrderStatus(orderSubmitRequestData);
                        /*Ended Here*/
                        //returnOrderSubmitWrapperReq();
                        orderSubmitFuture(orderid);
                    }
        catch(Exception e){
            dbu_Integration_Error_Log.createErrorLog(500,PARAM_TRANSACTION_DATA_INPUT_STRING,current_cartid,'','Create Order','Error');
            system.debug('exception message==>'+e.getMessage() +''+'Exception linenumber==>'+e.getLineNumber());
            system.debug(e.getStackTraceString());
            
        }
        return orderid;
    }
    
    @future(callout=true)
    public static void orderSubmitFuture(String orderId){
        /*try{
dbu_Integration_OrderSubmit.OrderSubmitResponseWrapper response;// = dbu_ReturnCCOrderApiUtil.retunOrderOrSubmitDetails(orderId, 'submit');
System.debug('dbu_CallccapitoCreateOrder orderSubmitFuture response ===>\t'+response);
}catch(Exception ex){
system.debug('Line Number\t'+ex.getLineNumber()+ex.getMessage());
}*/ 
        List<Id> orderItemId = new List<Id>();
        Map<Id,ccrz__E_OrderItem__c> lstOrderItem = new Map<Id,ccrz__E_OrderItem__c>();
        if(String.isNotBlank(orderId)){
            lstOrderItem = new Map<Id,ccrz__E_OrderItem__c>([Select id from ccrz__E_OrderItem__c where ccrz__Order__c =: orderId]);
        }
        System.debug('lstOrderItem===>'+lstOrderItem);
        if(lstOrderItem != null && lstOrderItem.size() > 0){
            orderItemId.addAll(lstOrderItem.keySet());
        }
        System.debug('orderItemId===>'+orderItemId);
        try{
            dbu_Integration_OrderSubmit.OrderSubmitResponseWrapper response = dbu_ReturnCCOrderApiUtil.retunOrderOrSubmitDetails(orderId,orderItemId,'submit');
            //retunOrderOrSubmitDetails(String orderid,List<String> orderItemId, String orderSubmitOrReturn){
            System.debug('dbu_CallccapitoCreateOrder orderSubmitFuture response ===>\t'+response);
        }catch(Exception ex){
            system.debug('Line Number\t'+ex.getLineNumber()+ex.getMessage());
        }  
    }
    
    public static void orderSubmitNonFuture(String orderId){
        /*try{
dbu_Integration_OrderSubmit.OrderSubmitResponseWrapper response;// = dbu_ReturnCCOrderApiUtil.retunOrderOrSubmitDetails(orderId, 'submit');
System.debug('dbu_CallccapitoCreateOrder orderSubmitFuture response ===>\t'+response);
}catch(Exception ex){
system.debug('Line Number\t'+ex.getLineNumber()+ex.getMessage());
}*/ 
        List<Id> orderItemId = new List<Id>();
        Map<Id,ccrz__E_OrderItem__c> lstOrderItem = new Map<Id,ccrz__E_OrderItem__c>();
        if(String.isNotBlank(orderId)){
            lstOrderItem = new Map<Id,ccrz__E_OrderItem__c>([Select id from ccrz__E_OrderItem__c where ccrz__Order__c =: orderId]);
        }
        System.debug('lstOrderItem===>'+lstOrderItem);
        if(lstOrderItem != null && lstOrderItem.size() > 0){
            orderItemId.addAll(lstOrderItem.keySet());
        }
        System.debug('orderItemId===>'+orderItemId);
        try{
            dbu_Integration_OrderSubmit.OrderSubmitResponseWrapper response = dbu_ReturnCCOrderApiUtil.retunOrderOrSubmitDetails(orderId,orderItemId,'submit');
            //retunOrderOrSubmitDetails(String orderid,List<String> orderItemId, String orderSubmitOrReturn){
            System.debug('dbu_CallccapitoCreateOrder orderSubmitFuture response ===>\t'+response);
        }catch(Exception ex){
            system.debug('Line Number\t'+ex.getLineNumber()+ex.getMessage());
        } 
    }
    // implemented by Ranadip
    private static void updateTaxObject(Map<String,String> taxMap){
        Set<String> cartItemIds = new Set<String>();
        List<CC_Tax__c> taxList = new List<CC_Tax__c>();
        
        cartItemIds = taxMap.keySet();
        taxList = [SELECT CC_Cart_Item__c,CC_Order_Item__c from CC_Tax__c WHERE CC_Cart_Item__c =: cartItemIds];
        
        for(CC_Tax__c taxObj : taxList){
            if(taxMap.containsKey(taxObj.CC_Cart_Item__c)){
                taxObj.CC_Order_Item__c = taxMap.get(taxObj.CC_Cart_Item__c);
            }
        }
        try{
            if(!taxList.isEmpty()){
                update taxList;
            }
        }catch(DmlException e){
            System.debug('The following exception has occurred: ' + e.getMessage());
        }
        
    }
}