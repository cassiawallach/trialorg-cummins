global without sharing class dbu_paypalPayment {
    public static boolean isTriggerFire = false;
    public static void dopayment(String cartId)
    {
        //String accessToken = getAccessToken();
    }
    
    @AuraEnabled(cacheable=true)
    global static String getAccessToken()
    {
        HttpRequest req = new HttpRequest(); //Create HTTP Request
        HttpResponse res = new HttpResponse();
        Http http = new Http();
        String endPoint = System.label.dbu_Paypal_EndPoint_Token;//dbu_Paypal_EndPoint_SaleId
        String username = System.label.dbu_Paypal_userName;
        String password = System.label.dbu_Paypal_password;
  
        Blob headerValue = Blob.valueOf(username + ':' + password);
        String authorizationHeader = 'Basic ' +
        EncodingUtil.base64Encode(headerValue);
        req.setHeader('Authorization', authorizationHeader);
        req.setEndpoint(endPoint);
        req.setMethod('POST');
        req.setHeader('Content-Type','application/x-www-form-urlencoded');
        req.setBody('grant_type=client_credentials');
        String resbody = '';
        if(!Test.isRunningTest())
        {
            res = http.send(req);
            resbody= res.getBody();
        }
        else
        {
            resbody= '{"scope": "https://uri.paypal.com/services/invoicing https://uri.paypal.com/services/disputes/read-buyer https://uri.paypal.com/services/payments/realtimepayment https://uri.paypal.com/services/disputes/update-seller https://uri.paypal.com/services/payments/payment/authcapture openid https://uri.paypal.com/services/disputes/read-seller https://uri.paypal.com/services/payments/refund https://api.paypal.com/v1/vault/credit-card https://api.paypal.com/v1/payments/.* https://uri.paypal.com/payments/payouts https://api.paypal.com/v1/vault/credit-card/.* https://uri.paypal.com/services/subscriptions https://uri.paypal.com/services/applications/webhooks","access_token": "A21AALlLUDutd_QpWGC84695xSEN8FZhMFtZo0CQu3S8azi9l0lVQD7p0GsKgaAKNXBlmMp3yIfUo_VZfvtWEjN3WJROPDtMA","token_type": "Bearer","app_id": "APP-80W284485P519543T","expires_in": 32400,"nonce": "2020-12-09T12:35:28ZyxxF-Wm1O0xOR1xGK8KQMeGFwfSSdFGlefNgoSvzyXQ"}';
        }
        System.debug(resbody);
        Map<String,Object> retJson = (Map<String,Object>)JSON.deserializeUntyped(resbody);
        
        String accToken = (String)retJson.get('access_token');
        return accToken;
    }
    
    
    
    @AuraEnabled
    global static String getPaypalPayment(Id cartid, String url, String cancleUrl)
    {
        System.debug('cart id  : '+cartid);
        String returnURL = '';
        string mSec;
        try{
        HttpRequest req = new HttpRequest(); //Create HTTP Request
        HttpResponse res = new HttpResponse();
        Http http = new Http();

        String accToken = getAccessToken();
        
        
        HttpRequest httpReq = new HttpRequest();
        system.debug('accToken'+accToken);
        httpReq.setHeader('Content-Type', 'application/json');
        httpReq.setHeader('Authorization', 'Bearer '+accToken);
        httpReq.setMethod('POST');
        httpReq.setEndpoint(System.label.dbu_Paypal_EndPoint_Payment);
        
        System.debug('cart id  : '+cartid);

                
                List<ccrz__E_Cart__c> lstCart = new List<ccrz__E_Cart__c>();

                lstCart = [Select Id,ccrz__TotalDiscount__c,ccrz__TotalAmount__c,ccrz__SubtotalAmount__c,ccrz__TaxAmount__c,ccrz__ShipAmount__c,ccrz__BuyerFirstName__c,ccrz__BuyerLastName__c,ccrz__BuyerPhone__c,ccrz__ShipTo__c,ccrz__ShipTo__r.ccrz__AddressFirstline__c,ccrz__ShipTo__r.ccrz__AddressSecondline__c,ccrz__ShipTo__r.ccrz__City__c,ccrz__ShipTo__r.ccrz__Country__c,ccrz__ShipTo__r.ccrz__PostalCode__c,ccrz__ShipTo__r.ccrz__State__c,ccrz__BillTo__c,ccrz__BillTo__r.ccrz__AddressFirstline__c,ccrz__BillTo__r.ccrz__AddressSecondline__c,ccrz__BillTo__r.ccrz__City__c,ccrz__BillTo__r.ccrz__Country__c,ccrz__BillTo__r.ccrz__PostalCode__c,ccrz__BillTo__r.ccrz__State__c,(select Id,ccrz__Price__c,ccrz__Product__r.Name,ccrz__Quantity__c,Actual_Tax__c,ccrz__ItemTotal__c,ccrz__Product__r.ccrz__SKU__c,ccrz__SubAmount__c  from ccrz__E_CartItems__r) from ccrz__E_Cart__c where id=: cartid];

                if(lstCart.size() > 0)
                {
                    DBU_RequestPaypalWrpr requestWrpr = new DBU_RequestPaypalWrpr();
                    requestWrpr.intent = 'Sale';
                    requestWrpr.note_to_payer = 'Contact us for any questions on your order.';
                    requestWrpr.redirect_urls = new DBU_RequestPaypalWrpr.Redirect_urls();
                    requestWrpr.redirect_urls.return_url = url;
                    requestWrpr.redirect_urls.cancel_url = cancleUrl;
                    requestWrpr.payer = new DBU_RequestPaypalWrpr.payer();
                    requestWrpr.transactions = new List<DBU_RequestPaypalWrpr.Transactions>();
                    requestWrpr.payer.payment_method = 'paypal';

                    List<DBU_RequestPaypalWrpr.Transactions> lstTransc = new List<DBU_RequestPaypalWrpr.Transactions>();

                    DBU_RequestPaypalWrpr.Transactions objTrans = new DBU_RequestPaypalWrpr.Transactions();
                    objTrans.amount = new DBU_RequestPaypalWrpr.Amount();
                    objTrans.amount.total = String.valueOf(lstCart[0].ccrz__TotalAmount__c);
                    objTrans.amount.currency1 = 'USD';
                    objTrans.amount.details = new DBU_RequestPaypalWrpr.Details();
                    objTrans.amount.details.subtotal = String.valueOf(lstCart[0].ccrz__SubtotalAmount__c);
                    objTrans.amount.details.tax = '0';
                    if(lstCart[0].ccrz__TaxAmount__c != null)
                        objTrans.amount.details.tax = String.valueOf(lstCart[0].ccrz__TaxAmount__c);
                    objTrans.amount.details.shipping = String.valueOf(lstCart[0].ccrz__ShipAmount__c);
                    objTrans.amount.details.handling_fee = '0';
                    objTrans.amount.details.shipping_discount = '0';
                    objTrans.amount.details.insurance = '0';
                    
                    objTrans.description = 'The payment transaction description.';
                    objTrans.custom = '';
                    objTrans.invoice_number = '';
                    objTrans.soft_descriptor = '';
                    objTrans.payment_options = new DBU_RequestPaypalWrpr.Payment_options();
                    objTrans.payment_options.allowed_payment_method = 'INSTANT_FUNDING_SOURCE';
                    objTrans.item_list = new DBU_RequestPaypalWrpr.Item_list();
                    
                    List<DBU_RequestPaypalWrpr.Items> lstItem = new List<DBU_RequestPaypalWrpr.Items>();
                    for(ccrz__E_CartItem__c objCartItem: lstCart[0].ccrz__E_CartItems__r)
                    {
                        DBU_RequestPaypalWrpr.Items newObjItem = new DBU_RequestPaypalWrpr.Items();
                        newObjItem.name = String.valueOf(objCartItem.ccrz__Product__r.Name);
                        newObjItem.description = '';
                        newObjItem.quantity = String.valueOf(objCartItem.ccrz__Quantity__c);
                        newObjItem.price = String.valueOf(objCartItem.ccrz__Price__c.setScale(2));//INC2512508
                        newObjItem.tax = '0';
                        if(objCartItem.Actual_Tax__c != null)
                            newObjItem.tax = String.valueOf(objCartItem.Actual_Tax__c);
                        newObjItem.sku = String.valueOf(objCartItem.ccrz__Product__r.ccrz__SKU__c);
                        newObjItem.currency1 = 'USD';
                        lstItem.add(newObjItem);
                    }
                    //=====Passing Discount as a negative line item====17-DEC-2021==============
                    if(lstCart[0].ccrz__TotalDiscount__c != null && lstCart[0].ccrz__TotalDiscount__c != 0.00){                   
                        DBU_RequestPaypalWrpr.Items newObjItem1 = new DBU_RequestPaypalWrpr.Items();
                        newObjItem1.name = 'Discount';
                        newObjItem1.description = '';
                        newObjItem1.quantity = '1';
                        newObjItem1.price = '-'+String.valueOf(lstCart[0].ccrz__TotalDiscount__c.setScale(2));
                        newObjItem1.tax = '0';
                        newObjItem1.sku = 'Discount Applied';
                        newObjItem1.currency1 = 'USD';
                        lstItem.add(newObjItem1);   
                    }
                    //=======================
                    objTrans.item_list.items = new List<DBU_RequestPaypalWrpr.Items>();
                    objTrans.item_list.items.addAll(lstItem);
                    
                    objTrans.item_list.shipping_address = new DBU_RequestPaypalWrpr.Shipping_address();
                    
                    objTrans.item_list.shipping_address.recipient_name = String.valueOf(lstCart[0].ccrz__BuyerFirstName__c+' '+lstCart[0].ccrz__BuyerLastName__c);

                    if(lstCart[0].ccrz__ShipTo__c != null)
                    {
                        objTrans.item_list.shipping_address.line1 = String.valueOf(lstCart[0].ccrz__ShipTo__r.ccrz__AddressFirstline__c);
                        objTrans.item_list.shipping_address.line2 = String.valueOf(lstCart[0].ccrz__ShipTo__r.ccrz__AddressSecondline__c);
                        objTrans.item_list.shipping_address.city = String.valueOf(lstCart[0].ccrz__ShipTo__r.ccrz__City__c);
                        if(lstCart[0].ccrz__ShipTo__r.ccrz__Country__c.equalsIgnoreCase('UNITED STATES') || lstCart[0].ccrz__ShipTo__r.ccrz__Country__c.equalsIgnoreCase('US'))
                            objTrans.item_list.shipping_address.country_code = 'US';
                        else
                            objTrans.item_list.shipping_address.country_code = String.valueOf(lstCart[0].ccrz__ShipTo__r.ccrz__Country__c);
                        
                        objTrans.item_list.shipping_address.postal_code = String.valueOf(lstCart[0].ccrz__ShipTo__r.ccrz__PostalCode__c);
                        objTrans.item_list.shipping_address.state = String.valueOf(lstCart[0].ccrz__ShipTo__r.ccrz__State__c);
                    }
                    else if(lstCart[0].ccrz__BillTo__c != null)
                    {
                        objTrans.item_list.shipping_address.line1 = String.valueOf(lstCart[0].ccrz__BillTo__r.ccrz__AddressFirstline__c);
                        objTrans.item_list.shipping_address.line2 = String.valueOf(lstCart[0].ccrz__BillTo__r.ccrz__AddressSecondline__c);
                        objTrans.item_list.shipping_address.city = String.valueOf(lstCart[0].ccrz__BillTo__r.ccrz__City__c);
                        if(lstCart[0].ccrz__BillTo__r.ccrz__Country__c.equalsIgnoreCase('UNITED STATES') || lstCart[0].ccrz__BillTo__r.ccrz__Country__c.equalsIgnoreCase('US'))
                            objTrans.item_list.shipping_address.country_code = 'US';
                        else
                            objTrans.item_list.shipping_address.country_code = String.valueOf(lstCart[0].ccrz__BillTo__r.ccrz__Country__c);
                        
                        objTrans.item_list.shipping_address.postal_code = String.valueOf(lstCart[0].ccrz__BillTo__r.ccrz__PostalCode__c);
                        objTrans.item_list.shipping_address.state = String.valueOf(lstCart[0].ccrz__BillTo__r.ccrz__State__c);
                    }
                    objTrans.item_list.shipping_address.phone = String.valueOf(lstCart[0].ccrz__BuyerPhone__c);
                    
                    
                    requestWrpr.transactions.add(objTrans);
                    
                    
                    String jsonString = JSON.serialize(requestWrpr);
                    
                    jsonString = jsonString.replaceAll('currency1','currency');
                    
                    System.debug('Json Request=='+jsonString);
                    httpReq.setBody(jsonString);
                    
                }

        String finalReturn = '';
        if(!Test.isRunningTest())
        {
            Long reqTime = DateTime.now().getTime();
            res = http.send(httpReq);
            Long respTime = DateTime.now().getTime();
            long milliSeconds = respTime-reqTime ;
            mSec='***TIME::' +string.ValueOf(milliSeconds)+ ':: TIME***';
            finalReturn = res.getBody();
            System.debug('finalReturn: '+finalReturn);
            System.debug(res.getStatusCode());
            if(res.getStatusCode() == 201)
            {
                dbu_Integration_Error_Log.createErrorLog(res.getStatusCode(),mSec,httpReq.getBody(),res.getBody(),'PayPal','Success');
                  
            }else{
                dbu_Integration_Error_Log.createErrorLog(res.getStatusCode(),mSec+res.getBody(),httpReq.getBody(),'','PayPal',res.getStatus());
            }
        }
        else
        {
            finalReturn = '{"id":"PAYID-L7IMYXQ66Y78391NV899893T","intent":"sale","state":"created","payer":{"payment_method":"paypal"},"transactions":[{"amount":{"total":"410.23","currency":"USD","details":{"subtotal":"343.28","tax":"26.95","shipping":"40.00","insurance":"0.00","handling_fee":"0.00","shipping_discount":"0.00"}},"description":"The payment transaction description.","custom":"","invoice_number":"","soft_descriptor":"","payment_options":{"allowed_payment_method":"INSTANT_FUNDING_SOURCE","recurring_flag":false,"skip_fmf":false},"item_list":{"items":[{"name":"Cummins C0147046408 PUMP,FUEL INJECTION","sku":"C0147046408","description":"","price":"303.28","currency":"USD","tax":"0.00","quantity":1},{"name":"Core: Cummins C0147046408 PUMP,FUEL INJECTION","sku":"C0147046408-1","description":"","price":"40.00","currency":"USD","tax":"0.00","quantity":1}],"shipping_address":{"recipient_name":"Dianna Strachan","line1":"1460 N NATIONAL RD","city":"SCOTTSDALE","state":"AZ","postal_code":"85259","country_code":"US","phone":"+9 (999) 999-9999"}},"related_resources":[]}],"note_to_payer":"Contact us for any questions on your order.","create_time":"2020-12-09T13:08:45Z","links":[{"href":"https://api.sandbox.paypal.com/v1/payments/payment/PAYID-L7IMYXQ66Y78391NV899893T","rel":"self","method":"GET"},{"href":"https://www.sandbox.paypal.com/cgi-bin/webscr?cmd=_express-checkout&token=EC-4DK84354U0402992H","rel":"approval_url","method":"REDIRECT"},{"href":"https://api.sandbox.paypal.com/v1/payments/payment/PAYID-L7IMYXQ66Y78391NV899893T/execute","rel":"execute","method":"POST"}]}';
        }
        
        
        finalReturn = finalReturn.replaceAll('currency','currency1');
        System.debug(finalReturn);
        
        DBU_ReturnPaypalWrpr returnPaypal = new DBU_ReturnPaypalWrpr();
        returnPaypal = DBU_ReturnPaypalWrpr.parse(finalReturn);
        System.debug(returnPaypal.links);
        
        for(DBU_ReturnPaypalWrpr.links objLink : returnPaypal.links)
        {
            System.debug(objLink );
            if(objLink.method == 'REDIRECT')
            {
                returnURL = objLink.href;
            }
        }
    }
     catch(Exception ex)
     {
        dbu_Integration_Error_Log.createErrorLog(null,mSec+ex.getMessage(),'','','PayPal','Exception');
    }
           return returnURL;
    }
    
    
    @AuraEnabled
    global static String getSalesId(String PayerId, String transactionId)
    {
        String salesId = '';
        try {
            HttpRequest req = new HttpRequest(); //Create HTTP Request
            HttpResponse res = new HttpResponse();
            Http http = new Http();

            String accToken = getAccessToken();

            
            HttpRequest httpReq = new HttpRequest();
            system.debug('accToken'+accToken);
            httpReq.setHeader('Content-Type', 'application/json');
            httpReq.setHeader('Authorization', 'Bearer '+accToken);
            httpReq.setMethod('POST');
            httpReq.setEndpoint(System.label.dbu_Paypal_EndPoint_SaleId+transactionId+'/execute');
            httpReq.setBody('{"payer_id": "'+PayerId+'"}');
            httpReq.setTimeOut(60000);
            
            String responseStr = '';
            if(!Test.isRunningTest())
            {
                Long reqTime1 = DateTime.now().getTime();
                res = http.send(httpReq);
                Long respTime1 = DateTime.now().getTime();
                responseStr = res.getBody(); 
                long milliSeconds1 = respTime1 - reqTime1;
                String mSec1 ='***TIME::' +string.ValueOf(milliSeconds1)+ ':: TIME***';
                if(res.getStatusCode() == 200 || res.getStatus() == 'Success')
                {
                    dbu_Integration_Error_Log.createErrorLog(res.getStatusCode(),mSec1,httpReq.getBody(),res.getBody(),'PayPal','Success');
                    
                }else{
                    dbu_Integration_Error_Log.createErrorLog(res.getStatusCode(),mSec1+res.getBody(),httpReq.getBody(),'','PayPal',res.getStatus());
                }
            }
            else
            {
                responseStr = '{"id":"PAYID-L7I4DVI26481637EL400862G","intent":"sale","state":"approved","cart":"45G63666KV720881V","payer":{"payment_method":"paypal","status":"VERIFIED","payer_info":{"email":"sb-t4aeu3655935@personal.example.com","first_name":"John","last_name":"Doe","payer_id":"FJPKUSZ3CSNFN","shipping_address":{"recipient_name":"test User","line1":"1460 N NATIONAL RD","city":"SCOTTSDALE","state":"AZ","postal_code":"85259","country_code":"US"},"country_code":"US"}},"transactions":[{"amount":{"total":"410.23","currency":"USD","details":{"subtotal":"343.28","tax":"26.95","shipping":"40.00","insurance":"0.00","handling_fee":"0.00","shipping_discount":"0.00","discount":"0.00"}},"payee":{"merchant_id":"L8DZ428LLHEPU","email":"sb-nzkxo3658589@business.example.com"},"description":"The payment transaction description.","item_list":{"items":[{"name":"Cummins C0147046408 PUMP,FUEL INJECTION","sku":"C0147046408","price":"303.28","currency":"USD","tax":"0.00","quantity":1},{"name":"Core: Cummins C0147046408 PUMP,FUEL INJECTION","sku":"C0147046408-1","price":"40.00","currency":"USD","tax":"0.00","quantity":1}],"shipping_address":{"recipient_name":"test User","line1":"1460 N NATIONAL RD","city":"SCOTTSDALE","state":"AZ","postal_code":"85259","country_code":"US"},"shipping_phone_number":"+9 (999) 999-9999"},"related_resources":[{"sale":{"id":"5Y248988LT753363E","state":"pending","amount":{"total":"410.23","currency":"USD","details":{"subtotal":"343.28","tax":"26.95","shipping":"40.00","insurance":"0.00","handling_fee":"0.00","shipping_discount":"0.00","discount":"0.00"}},"payment_mode":"INSTANT_TRANSFER","reason_code":"PAYMENT_REVIEW","protection_eligibility":"INELIGIBLE","transaction_fee":{"value":"12.20","currency":"USD"},"parent_payment":"PAYID-L7I4DVI26481637EL400862G","create_time":"2020-12-10T06:36:43Z","update_time":"2020-12-10T06:36:43Z","links":[{"href":"https://api.sandbox.paypal.com/v1/payments/sale/5Y248988LT753363E","rel":"self","method":"GET"},{"href":"https://api.sandbox.paypal.com/v1/payments/sale/5Y248988LT753363E/refund","rel":"refund","method":"POST"},{"href":"https://api.sandbox.paypal.com/v1/payments/payment/PAYID-L7I4DVI26481637EL400862G","rel":"parent_payment","method":"GET"}]}}]}],"failed_transactions":[],"create_time":"2020-12-10T06:36:05Z","update_time":"2020-12-10T06:36:43Z","links":[{"href":"https://api.sandbox.paypal.com/v1/payments/payment/PAYID-L7I4DVI26481637EL400862G","rel":"self","method":"GET"}]}';
            }
            
            
            System.debug(responseStr);
            responseStr = responseStr.replaceAll('currency','currency1');
            dbu_PaypalSalesResponse responseWrpr = new dbu_PaypalSalesResponse();
            responseWrpr = dbu_PaypalSalesResponse.parse(responseStr);
            System.debug(responseWrpr.transactions[0].related_resources);
            
            for(dbu_PaypalSalesResponse.Related_resources objRes : responseWrpr.transactions[0].related_resources)
            {
                if(objRes.refund == null)
                {

                            salesId = objRes.sale.id;
                }
            }
        } catch (Exception ex) {
            dbu_Integration_Error_Log.createErrorLog(null,ex.getMessage() + ' getSalesId()','','','PayPal','Exception');
            return '';
        }
        
        return salesId;
    }
    
    @future(callout=true)
    global static void getRefund(List<Id> orderItemsId)
    {
        List<ccrz__E_OrderItem__c> orderItems = new List<ccrz__E_OrderItem__c>();
        System.debug('orderItemsId : '+orderItemsId);
        orderItems = [Select Id,ccrz__Order__c,ccrz__Order__r.CC_Order__c ,dbu_CC_Order_Item__c,ccrz__OrderItemStatus__c ,dbu_Estimated_Return_Amount__c,dbu_Transaction_Payment_for_Refund__c from ccrz__E_OrderItem__c where Id IN: orderItemsId and ccrz__Order__r.dbu_Is_Cloned__c = true and  ccrz__Order__r.ccrz__PaymentMethod__c = 'PayPal'];
        System.debug('orderItems : '+orderItems);
        
        Map<Id,List<ccrz__E_OrderItem__c>> mapOrderToItems = new Map<Id,List<ccrz__E_OrderItem__c>>();
        Map<Id,ccrz__E_TransactionPayment__c> mapOrderToTP = new Map<Id,ccrz__E_TransactionPayment__c>();
        List<ccrz__E_TransactionPayment__c> lstCreateTP = new List<ccrz__E_TransactionPayment__c>();
        List<ccrz__E_OrderItem__c> lstOrderItemToUpdate = new List<ccrz__E_OrderItem__c>();
        Map<Id,Id> CloneToNewOrderItem = new Map<Id,Id>();
        for(ccrz__E_OrderItem__c orderItemObj : orderItems)
        {
            if(!mapOrderToItems.containsKey(orderItemObj.ccrz__Order__c))
                mapOrderToItems.put(orderItemObj.ccrz__Order__c, new List<ccrz__E_OrderItem__c>());
            mapOrderToItems.get(orderItemObj.ccrz__Order__c).add(orderItemObj);
            
            CloneToNewOrderItem.put(orderItemObj.ccrz__Order__c,orderItemObj.ccrz__Order__r.CC_Order__c);
        }
        
        System.debug('mapOrderToItems : '+mapOrderToItems);
        
        System.debug('mapOrderToItems.keySet() : '+mapOrderToItems.keySet());
        List<ccrz__E_TransactionPayment__c> listtpObj = new List<ccrz__E_TransactionPayment__c>();
        listtpObj = [Select Id,ccrz__CCOrder__c,ccrz__TransactionSubcode__c,ccrz__Token__c,ccrz__Storefront__c,ccrz__PaymentType__c,ccrz__TransactionType__c,ccrz__AccountNumber__c,ccrz__AccountType__c,ccrz__Amount__c,ccrz__CurrencyISOCode__c,dbu_Paypal_refund_Id__c,dbu_Paypal_refund_Transection_Status__c from ccrz__E_TransactionPayment__c where ccrz__CCOrder__c IN: CloneToNewOrderItem.values() AND  (dbu_Paypal_refund_Id__c = null OR dbu_Paypal_refund_Id__c = '')];
        System.debug('log 1: '+listtpObj);
        
        String accToken = getAccessToken();
        
        for(ccrz__E_TransactionPayment__c objTP : listtpObj)
        {
            mapOrderToTP.put(objTP.ccrz__CCOrder__c,objTP);
        }
        
        System.debug('log 2: '+mapOrderToTP);
        for(Id orderId : mapOrderToItems.keySet())
        {
        
            HttpRequest req = new HttpRequest(); //Create HTTP Request
            HttpResponse res = new HttpResponse();
            Http http = new Http();
            Decimal amountTotal = 0.00;
            
            
            
            for(ccrz__E_OrderItem__c orderItemObj : mapOrderToItems.get(orderId))
            {
                if(orderItemObj.dbu_Estimated_Return_Amount__c != null)
                {
                    amountTotal = amountTotal+orderItemObj.dbu_Estimated_Return_Amount__c;
                }
            }
            
            
            if(CloneToNewOrderItem.containsKey(orderId) &&  mapOrderToTP.containsKey(CloneToNewOrderItem.get(orderId)))
            {
                System.debug('log 2: '+mapOrderToTP.get(CloneToNewOrderItem.get(orderId)));
                ccrz__E_TransactionPayment__c cloneTP = new ccrz__E_TransactionPayment__c();
                
                String transactionSubcode = mapOrderToTP.get(CloneToNewOrderItem.get(orderId)).ccrz__TransactionSubcode__c;
                String currencyCode = mapOrderToTP.get(CloneToNewOrderItem.get(orderId)).ccrz__CurrencyISOCode__c;
                Decimal rounded = amountTotal.setScale(2, System.RoundingMode.FLOOR);
                String amount = String.valueOf(rounded);
                
                String transubCode = mapOrderToTP.get(CloneToNewOrderItem.get(orderId)).ccrz__TransactionSubcode__c;
                
                cloneTP = mapOrderToTP.get(CloneToNewOrderItem.get(orderId)).clone(false, false, false, false);
                cloneTP.ccrz__Amount__c = amountTotal;
                System.debug('transubCode: '+transubCode);
                cloneTP.ccrz__TransactionSubcode__c = transubCode;
                cloneTP.ccrz__CCOrder__c = orderId;
                cloneTP.dbu_isRefund_Transaction__c = true;
                
                
                HttpRequest httpReq = new HttpRequest();
                system.debug('accToken'+accToken);
                httpReq.setHeader('Content-Type', 'application/json');
                httpReq.setHeader('Authorization', 'Bearer '+accToken);
                httpReq.setMethod('POST');
                httpReq.setEndpoint(System.label.dbu_Paypal_EndPoint_refund+transactionSubcode+'/refund');
                httpReq.setBody('{"amount": {"total":"'+amount+'","currency":"'+currencyCode+'"}}');
                System.debug('{"amount": {"total":'+amount+',"currency":'+currencyCode+'}}');
                
                if(!Test.isRunningTest())
                {
                    res = http.send(httpReq);
                }
                else
                {
                    res.setStatus('CREATED');
                    res.setStatusCode(201);
                    res.setBody('{"id":"44X22091FE2796251","create_time":"2020-11-27T17:09:28Z","update_time":"2020-11-27T17:09:28Z","state":"completed","amount":{"total":"633.39","currency":"USD"},"refund_from_transaction_fee":{"currency":"USD","value":"18.37"},"total_refunded_amount":{"currency":"USD","value":"633.39"},"refund_from_received_amount":{"currency":"USD","value":"615.02"},"sale_id":"8EJ13000TK7774824","parent_payment":"PAYID-L7ATEJA4AK914783F302283C","links":[{"href":"https://api.sandbox.paypal.com/v1/payments/refund/44X22091FE2796251","rel":"self","method":"GET"},{"href":"https://api.sandbox.paypal.com/v1/payments/payment/PAYID-L7ATEJA4AK914783F302283C","rel":"parent_payment","method":"GET"},{"href":"https://api.sandbox.paypal.com/v1/payments/sale/8EJ13000TK7774824","rel":"sale","method":"GET"}]}');
                }
                System.debug('res.getStatus().toUpperCase(): '+res.getStatus().toUpperCase());
                System.debug('res.getStatusCode(): '+res.getStatusCode());
                if(res.getStatus().toUpperCase() == 'CREATED' &&  res.getStatusCode() == 201)
                {
                    String responseStr = res.getBody();
                    System.debug(responseStr);
                    //cloneTP.dbu_Paypal_RefundSuccessMsg__c = responseStr;
                    if(responseStr.length() > 131071)
                        cloneTP.dbu_Paypal_RefundSuccessMsg__c = responseStr.left(131071);
                    else
                        cloneTP.dbu_Paypal_RefundSuccessMsg__c = responseStr;
                    responseStr = responseStr.replaceAll('currency','currency1');
                    dbu_PaypalRefundResponse responseWrpr = new dbu_PaypalRefundResponse();
                    responseWrpr = dbu_PaypalRefundResponse.parse(responseStr);
                    cloneTP.dbu_Paypal_refund_Id__c = responseWrpr.id;
                    cloneTP.dbu_Paypal_refund_Transection_Status__c = responseWrpr.state;
                    dbu_Integration_Error_Log.createErrorLog(res.getStatusCode(),'',transactionSubcode + ',' + httpReq.getBody(),res.getBody(),'PayPal Refund Log','Success'); //Added Integration Log for INC4076715
                }
                else
                {
                    if(res.getBody().length() > 131071)
                        cloneTP.dbu_Paypal_refundError__c = res.getBody().left(131071);
                    else
                        cloneTP.dbu_Paypal_refundError__c = res.getBody();
                    dbu_Integration_Error_Log.createErrorLog(res.getStatusCode(),'',transactionSubcode + ',' + httpReq.getBody(),res.getBody(),'PayPal Refund Log','Error'); //Added Integration Log for INC4076715    
                }
                lstCreateTP.add(cloneTP);
            }
        }
        
        System.debug('lstCreateTP: ' +lstCreateTP);
        if(lstCreateTP != null && lstCreateTP.size() > 0)
        {
            insert lstCreateTP;
        }
        List<id> listRefundedItems = New List<id>();
        List<ccrz__E_OrderItem__c> refundedOrderItems = New List<ccrz__E_OrderItem__c>();
        for(ccrz__E_TransactionPayment__c objTP : lstCreateTP)
        {
            if(mapOrderToItems.containsKey(objTP.ccrz__CCOrder__c))
            {
                for(ccrz__E_OrderItem__c orderItemObj : mapOrderToItems.get(objTP.ccrz__CCOrder__c))
                {
                    orderItemObj.dbu_Transaction_Payment_for_Refund__c = objTP.Id;
                    if(objTP.dbu_Paypal_refund_Transection_Status__c == 'completed'){
                        orderItemObj.ccrz__OrderItemStatus__c = 'Refunded';
                        listRefundedItems.add(orderItemObj.dbu_CC_Order_Item__c);
                    }
                    else
                        orderItemObj.ccrz__OrderItemStatus__c = 'On Hold';
                    lstOrderItemToUpdate.add(orderItemObj);
                }
            }
        }
        refundedOrderItems =[Select id,name,ccrz__OrderItemStatus__c,dbu_CC_Order_Item__c from ccrz__E_OrderItem__c where id IN:listRefundedItems];
        for(ccrz__E_OrderItem__c originalOrderItem:refundedOrderItems){
            originalOrderItem.ccrz__OrderItemStatus__c='Refunded';
            lstOrderItemToUpdate.add(originalOrderItem);
        }
        if(lstOrderItemToUpdate != null && lstOrderItemToUpdate.size() > 0)
        {
            update lstOrderItemToUpdate;
        }
        
    }
}