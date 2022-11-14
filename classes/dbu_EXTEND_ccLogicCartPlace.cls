global virtual without sharing class dbu_EXTEND_ccLogicCartPlace extends ccrz.ccLogicCartPlace {
 
    global virtual override Map<string,object> processInput(Map<string,object> inputData){
        system.debug('ENTERING IN processInput cartplace');
        for(string str : inputData.keyset()){
            system.debug('inputData processInput keys > ' + str + ' inputData values > ' + inputData.get(str));    
        }
        
        Map<string,object> RetMap = super.processInput(inputData);
        
        for(string str : RetMap.keyset()){
            system.debug('RetMap processInput keys > ' + str + ' RetMap values > ' + RetMap.get(str));    
        } 

		return RetMap;       
    }
    
    /*
    global virtual override Map<string,object> createOrderItem(Map<string,object> inputData){
        system.debug('ENTERING IN createOrderItem cartplace');
        for(string str : inputData.keyset()){
            system.debug('inputData createOrderItem keys > ' + str + ' inputData values > ' + inputData.get(str));    
        }
        
        Map<string,object> RetMap = super.createOrderItem(inputData);
        
        for(string str : RetMap.keyset()){
            system.debug('RetMap createOrderItem keys > ' + str + ' RetMap values > ' + RetMap.get(str));    
        } 

		return RetMap;        
    }*/
    
    global virtual override Map<String,Object> placeOrder(Map<String,Object> inputData){
        
        system.debug('ENTERING IN OVERRIDERN cartplace');
        for(string str : inputData.keyset()){
            system.debug('inputData keys > ' + str + ' inputData values > ' + inputData.get(str));    
        }
	
        string paymentmethodc;
        if(inputData.get('ctTransPayData') != null){
            string method;
            system.debug('LBRUR' + (ccrz.cc_hk_Payment.TransactionPaymentParams)inputData.get('ctTransPayData'));
            if(((ccrz.cc_hk_Payment.TransactionPaymentParams)inputData.get('ctTransPayData')).transactionType != null){
				method = ((ccrz.cc_hk_Payment.TransactionPaymentParams)inputData.get('ctTransPayData')).transactionType;
            }
            
            string paymentnumber;
            if(((ccrz.cc_hk_Payment.TransactionPaymentParams)inputData.get('ctTransPayData')).accountNumber != null){
                paymentnumber = ((ccrz.cc_hk_Payment.TransactionPaymentParams)inputData.get('ctTransPayData')).accountNumber;
            }
            
            if(method != null && paymentnumber != null){
                if(method == 'PayPal' || method == 'paypal' || method == 'PAYPAL' || method == 'Paypal'){
                    system.debug('old pay num > ' + paymentnumber);
                    paymentnumber = paymentnumber.replaceAll('.(?=.{4})', 'X');
                    system.debug('new pay num > ' + paymentnumber);
                }
                paymentmethodc = method+paymentnumber;
            }
        }	
        
        
        Map<string,object> RetMap = super.placeOrder(inputData);
        
        for(string str : RetMap.keyset()){
            system.debug('RetMap keys > ' + str + ' RetMap values > ' + RetMap.get(str));    
        }   
        
        //Current OrderID
        String CurrentOrderId = (string)RetMap.get('orderId');
        
        //get Cart of Current Order
        list<ccrz__E_Order__c> CurrentOrder = [select id, ccrz__User__r.contact.account.FSL_ERP_Customer_Code__c, ccrz__User__r.contact.account.Customer_BMS_number__c, ccrz__User__r.contact.account.FSL_BMS_Instance__c, ccrz__OriginatedCart__r.id,ccrz__OriginatedCart__c,ccrz__OriginatedCart__r.dbu_optEmailNotification__c from ccrz__E_Order__c where id = : CurrentOrderId];
        system.debug('CurrentOrder > ' + CurrentOrder);
        list<Ecom_Cart_Coupon__c> cartCoupon = [select id,CC_Cart__c,Ecom_Coupon__c,Ecom_Coupon__r.id from Ecom_Cart_Coupon__c where CC_Cart__r.id = : CurrentOrder[0].ccrz__OriginatedCart__r.id limit 1];
        if(CurrentOrder.size() > 0){
           
            if(paymentmethodc != null){
                system.debug('paymentmethodc > ' + paymentmethodc);
                for(ccrz__E_Order__c instance : CurrentOrder){
                    instance.dbu_OrderPaymentMethod__c = paymentmethodc;
                    instance.dbu_optEmailNotification__c = CurrentOrder[0].ccrz__OriginatedCart__r.dbu_optEmailNotification__c;

                    if(instance.ccrz__User__r.contact.account.FSL_ERP_Customer_Code__c !=null && instance.ccrz__User__r.contact.account.FSL_ERP_Customer_Code__c.split('-').contains('USA') == true)
                    {
                        instance.DBU_Customer_BMS_Number__c = instance.ccrz__User__r.contact.account.FSL_ERP_Customer_Code__c.split('-')[0];
                    }

                    else if(instance.ccrz__User__r.contact.account.FSL_ERP_Customer_Code__c ==null && instance.ccrz__User__r.contact.account.FSL_BMS_Instance__c == 'USA')
                    {
                        instance.DBU_Customer_BMS_Number__c = instance.ccrz__User__r.contact.account.Customer_BMS_number__c;
                    }

                    if(cartCoupon.size() > 0){
                        instance.dbu_Coupon_Code__c = cartCoupon[0].Ecom_Coupon__r.id;
                    }
                }
				update CurrentOrder;               
            }            

            
            //get all orderitems 
            list<ccrz__E_OrderItem__c> allOrderItemsforCurrentOrder = new list<ccrz__E_OrderItem__c>();
            allOrderItemsforCurrentOrder =  [select id,ccrz__Product__c,Vertex_Tax__c from ccrz__E_OrderItem__c where ccrz__Order__c = : CurrentOrder[0].Id];
            system.debug('allOrderItemsforCurrentOrder > ' + allOrderItemsforCurrentOrder);
                                    
            //Get all cart and CartItems for current OrderId
            list<ccrz__E_CartItem__c> CurentOrderCartItems = new list<ccrz__E_CartItem__c>();
            CurentOrderCartItems = [select id,ccrz__Product__c, Vertex_tax__c from ccrz__E_CartItem__c where ccrz__Cart__c = : CurrentOrder[0].ccrz__OriginatedCart__c and Vertex_tax__c != null];
            system.debug('CurentOrderCartItems > ' + CurentOrderCartItems);            
			
            Map<ID, double> productIDTaxMap = new Map<ID,double>();   
            if(CurentOrderCartItems.size() > 0){                             
                for(ccrz__E_CartItem__c eachCartLine : CurentOrderCartItems){                	 
                    productIDTaxMap.put(eachCartLine.ccrz__Product__c, eachCartLine.Vertex_tax__c);                    
                }                                
            }

            if(allOrderItemsforCurrentOrder.size() > 0){
                if(productIDTaxMap.size() > 0){
                    
                    for(ccrz__E_OrderItem__c eachOrderLine : allOrderItemsforCurrentOrder){
                        if((double)productIDTaxMap.get(eachOrderLine.ccrz__Product__c) != null){
                            eachOrderLine.Vertex_Tax__c = (double)productIDTaxMap.get(eachOrderLine.ccrz__Product__c);
                        }
                    }
                    
                }
				
                Database.SaveResult[] UpdatedOrderItemIDList = Database.update(allOrderItemsforCurrentOrder, true);
				                
                // Iterate through each returned result
                for (Database.SaveResult sr : UpdatedOrderItemIDList) {
                    if (sr.isSuccess()) {
                        // Operation was successful, so get the ID of the record that was processed
                        System.debug('Successfully Updated OrderItem. OrderItem ID: ' + sr.getId());
                    }
                    else {
                        // Operation failed, so get all errors                
                        for(Database.Error err : sr.getErrors()) {
                            System.debug('The following error has occurred.');                    
                            System.debug(err.getStatusCode() + ': ' + err.getMessage());
                            System.debug('OrderItem fields that affected this error: ' + err.getFields());
                        }
                    }
                }                
                
            }            
            
        }

        
        //Code To delete Invoice and Invoice Items for the related order 
        List<ccrz__E_Invoice__c> CurrentInvoice = new List<ccrz__E_Invoice__c>();
        CurrentInvoice = [select id from ccrz__E_Invoice__c where ccrz__CCOrder__c =: CurrentOrderId];
        system.debug('CurrentInvoice > ' + CurrentInvoice);
        if(Test.isRunningTest()){
            system.debug('not deleting');
        }else{
            if(CurrentInvoice.size()>0){
                delete CurrentInvoice;
            }
        }
         
        
        //Code To Update currency in transaction record   
        string TransactionID;
        string CurrencyCodecustom;
        
        try{       
        //get transaction ID
        if((Map<string,object>)RetMap.get('transactionResult') != null){
            if(!((Map<string,object>)RetMap.get('transactionResult')).isEmpty()){
                           
                ccrz__E_TransactionPayment__c CurrentTP = (ccrz__E_TransactionPayment__c)((Map<string,object>)RetMap.get('transactionResult')).get('transactionCreated');
                system.debug( (ccrz__E_TransactionPayment__c)((Map<string,object>)RetMap.get('transactionResult')).get('transactionCreated') );   
                
                CurrencyCodecustom = (string)CurrentTP.ccrz__CurrencyISOCode__c;
                system.debug('CurrencyCodecustom  > ' + CurrencyCodecustom );
                
                TransactionID = (string)CurrentTP.Id;
                system.debug('TransactionID > ' + TransactionID );
                ccrz__E_TransactionPayment__c GetCurrentTP = new ccrz__E_TransactionPayment__c();
                GetCurrentTP = [select CurrencyIsoCode from ccrz__E_TransactionPayment__c where id =: TransactionID ];
                system.debug('GetCurrentTP  > ' + GetCurrentTP );
                GetCurrentTP.CurrencyIsoCode = CurrencyCodecustom;
                update GetCurrentTP;
                
            }
        }
        }catch(exception e){
            system.debug(e);
        } 
        
        return RetMap;
    }

}