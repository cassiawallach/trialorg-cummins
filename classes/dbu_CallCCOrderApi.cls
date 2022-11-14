public without sharing class dbu_CallCCOrderApi {
    
    /**
* Author : Mounika V
* Created on 9th September 2020
* Description : This class will fetch all the order related data
*/
    
    // To Fetch the order details based on the ID
    // 
    @AuraEnabled(cacheable=true)
    public static list<dbu_CCOrderAPIResponseWrapper> fetchOrderDetails(string orderId){
        
        list<dbu_CCOrderAPIResponseWrapper> wrapperlist = new list<dbu_CCOrderAPIResponseWrapper>();
        
        dbu_CCOrderAPIResponseWrapper wrapper = new dbu_CCOrderAPIResponseWrapper();
        Map<Id,ccrz__E_Product__c> productListByIDMap = new Map<Id,ccrz__E_Product__c>();
        Set<String> orderIdList = new Set<String>{orderid};
            Map<String, Object> inputData = new Map<String, Object>{
                ccrz.ccAPIOrder.PARAM_ORDER_ID_LIST => orderIdList,
                    ccrz.ccAPI.API_VERSION => ccrz.ccApi.CURRENT_VERSION,
                    ccrz.ccApi.SIZING => new Map<String, Object> {
                        ccrz.ccAPIOrder.ENTITYNAME => new Map<String, Object> {
                            ccrz.ccApi.SZ_DATA => ccrz.ccApi.SZ_XL,
                                ccrz.ccApi.SZ_REL => New List<String>{'E_OrderItems__r'}
                            
                        },
                            ccrz.ccApiAddress.ENTITYNAME => new Map<String, Object> {
                                ccrz.ccApi.SZ_DATA => ccrz.ccApi.SZ_XL
                                    }
                    }  
            };
            
            String paymentMethodStr ='';
            List<ccrz__E_TransactionPayment__c> lstTP = new List<ccrz__E_TransactionPayment__c>();
                       lstTP = [Select Id,ccrz__AccountNumber__c, ccrz__TransactionType__c from ccrz__E_TransactionPayment__c where ccrz__CCOrder__c =: orderId];
                       if(lstTP.size() > 0)
                       {
                           String accountNumber = lstTP[0].ccrz__AccountNumber__c;
                           if(lstTP[0].ccrz__TransactionType__c.toUpperCase() == 'PAYPAL' && lstTP[0].ccrz__AccountNumber__c != null && lstTP[0].ccrz__AccountNumber__c != '')
                           {
                                String cardNumber= lstTP[0].ccrz__AccountNumber__c;
                                String lastDigit = cardNumber.right(4);
                                for(Integer i = 0;i<cardNumber.length()-4;i++)
                                lastDigit = 'x'+lastDigit;
                                accountNumber = lastDigit;
                           }
                           paymentMethodStr = lstTP[0].ccrz__TransactionType__c+' '+accountNumber;
                       }
                try{
                    Map<String, Object> outputData = ccrz.ccApiOrder.fetch(inputData);
                    if (outputData.get(ccrz.ccApiOrder.ORDERLIST) != null) {
                        system.debug('outputData-->'+outputData);
                        system.debug('outputDatakeyset-->'+outputData.keyset());
                        
                        for(String outputkey : outputData.keyset())
                        {
                            System.debug('key: '+outputkey);
                            System.debug('value: '+outputData.get(outputkey));
                        }
                        
                        List<Map<String, Object>> outputOrderList = (List<Map<String, Object>>) outputData.get(ccrz.ccApiOrder.ORDERLIST);
                        system.debug('outputOrderList'+JSON.serialize(outputOrderList));
                        system.debug('outputOrderList>>>' +outputOrderList);
                        
                        
                        if(outputOrderList!=null && outputOrderList.size()>0 ){
                            
                            Map<String, Object> myOrder = new Map<String, Object>();
                            
                            for(Map<String, Object> ob:outputOrderList)
                            {
                                System.debug('obsfid=>'+ (String)ob.get('sfid'));
                                String sfid = (String)ob.get('sfid');
                                System.debug('my order is matching now');
                                myOrder = ob;
                                
                            }
                            //--Added by Mukesh Gupta for CurrencyISOCode-- 18-01-2021
                            wrapper.currencyISOCode = (String)myOrder.get('currencyISOCode');
                            //wrapper.orderNumber = (String)myOrder.get('orderNumber');
                            Date dt = (date)myOrder.get('orderDate');
                            //wrapper.orderDate = myOrder.get('orderDate');
                            wrapper.orderDate = DateTime.newInstance(dt.year(),dt.month(),dt.day()).format('MMMM dd, yyyy');
                            system.debug('^&^%'+wrapper.orderDate);
                            //wrapper.orderedDate = wrapper.orderDate.format();
                            //wrapper.orderDate = (Date)myOrder.get('dateOutput');
                            //DateTime yourDate = Datetime.now();
                            //String dateOutput = orderDate.format('dd-MM-yyyy');
                            //System.debug('Debug: '+dateOutput);
                            wrapper.sfdcName = (String)myOrder.get('sfdcName');
                            
                            wrapper.sfid = (String)myOrder.get('sfid');
                            //wrapper.orderStatus = (String)myOrder.get('orderStatus');
                            //wrapper.billTo = (String)myOrder.get('billTo');
                            
                            //Added by Malhar & Dhiraj - for getting order Pickup address
                            if(myOrder.get('dbuPickUpFrom') != null){                                
                                string order_pickupaddress_Id = (string)myOrder.get('dbuPickUpFrom');
                                system.debug('order_pickupaddress_Id > ' + order_pickupaddress_Id);
                                
                                list<ccrz__E_ContactAddr__c> currentOrderPickupAddress = new list<ccrz__E_ContactAddr__c>();
                                currentOrderPickupAddress = [select id,
                                                    dbu_PickUp_Store_Name__c,
                                                    ccrz__AddressFirstline__c, 
                                                    ccrz__City__c,
                                                    ccrz__State__c,
                                                    ccrz__Country__c,
                                                    ccrz__PostalCode__c,
                                                    dbu_StartEndTimeOfStore__c,
                                                    dbu_zone__c,
                                                    dbu_TimeZone__c 
                                                    from ccrz__E_ContactAddr__c 
                                                    where id =: order_pickupaddress_Id LIMIT 1];
                                
                                if(currentOrderPickupAddress.size() > 0 ){
                                   	wrapper.OrderPickUpAddress = currentOrderPickupAddress;
                                }                                    
                            }
                            
                            wrapper.buyerFirstName = (String)myOrder.get('buyerFirstName');
                            wrapper.buyerLastName = (String)myOrder.get('buyerLastName');
                            wrapper.buyerPhone = (String)myOrder.get('buyerPhone');
                            wrapper.buyerEmail = (String)myOrder.get('buyerEmail');
                            wrapper.items = (decimal)myOrder.get('dbuNewOriginalOrderTotal');
                            System.debug('items>>>>'+wrapper);
                            wrapper.shipAmount = (decimal)myOrder.get('shipAmount');
                            System.debug('shipAmount>>>>'+wrapper);
                            wrapper.subtotalAmount = (decimal)myOrder.get('subtotalAmount');
                            System.debug('subtotalAmount>>>>'+wrapper);                           
                            wrapper.totalDiscount = (decimal)myOrder.get('totalDiscount');
                            System.debug('totalDiscount>>>>'+wrapper);
                            wrapper.taxAmount = (decimal)myOrder.get('taxAmount');
                            System.debug('taxAmount>>>>'+wrapper);
                            wrapper.taxSubTotalAmount = (decimal)myOrder.get('taxSubTotalAmount');
                            System.debug('taxSubTotalAmount>>>>'+wrapper);
                            wrapper.totalAmount = (decimal)myOrder.get('totalAmount');
                            System.debug('totalAmount>>>>'+wrapper);   
                            wrapper.dbupickupAddress = (string)myOrder.get('dbupickupAddress');
                             wrapper.dbuPickUpStoreOpenHrs = (string)myOrder.get('dbuPickUpStoreOpenHrs');
                            wrapper.paymentMethod = paymentMethodStr;
                            //System.debug('dbupickupAddress>'+ dbupickupAddress);
       
                            
                            // wrapper.subtotalAmount = (decimal)myOrder.get('subtotalAmount');
                            // wrapper.quantityperUnit = (decimal)myOrder.get('quantityperUnit');
                            
                            List<Map<string,object>> orderItemsRelatedList = (List<Map<string,object>>) myOrder.get('EOrderItemsS');
                            System.debug('ORDER ITEM DETAILS::::: ' + json.serialize(orderItemsRelatedList));
                            ////////////////////////////////
                            List<String> lstProductIds = new List<String>();
                            for(Map<string,object> obj : orderItemsRelatedList){
                                for(String str : obj.keySet()){
                                    System.debug('Key==>\t'+str+'\tValue==>\t'+obj.get(str));
                                    //shriram 24-11-2020
                                     /*Here getting the product lst by Iterationg*/
                                     if(str == 'productR'){
                                     System.debug('productR===>'+obj.get('productR'));
                                     Map<string,object> objProductlst = (Map<string,object>)obj.get('productR');
                                     lstProductIds.add((String)objProductlst.get('sfid'));
                                     System.debug('productId????????????????????????????????'+(String)objProductlst.get('sfid'));
                                     }
                                }
                            }
                            System.debug('lstProductIds====>'+lstProductIds);
                            productListByIDMap = new Map<Id,ccrz__E_Product__c>([Select id,dbu_Has_Core_Charge__c,dbu_Has_Core_Child__c from ccrz__E_Product__c 
                            where id = :lstProductIds]);
                            ////////////////////////////////
                            List<dbu_OrderItemsRelatedListWrapper> orderItemsList = new List<dbu_OrderItemsRelatedListWrapper>();
                            if(orderItemsRelatedList!=null && orderItemsRelatedList.size()>0){
                                for(Map<String,Object> ob : orderItemsRelatedList)
                                {
                                    dbu_OrderItemsRelatedListWrapper items = new dbu_OrderItemsRelatedListWrapper();
                                    
                                   
                                    items.quantity = (decimal)ob.get('quantity');
                                    items.price = (decimal)ob.get('price');
                                    items.subAmount = (decimal)ob.get('subAmount');
                                    items.orderItemStatus = (String)ob.get('orderItemStatus');
                                    items.sfid = (String)ob.get('sfid');
                                    items.prodId = (string)ob.get('product');
                                    items.dbuisShipTo = (Boolean)ob.get('dbuisShipTo');
                                    
                                    if(ob.get('dbuEstimatedDelivery') != null){
                                        items.estimatedDelivery = (String)ob.get('dbuEstimatedDelivery');
                                    }else{
                                        items.estimatedDelivery = '';
                                    }
                                    
                                    if(ob.get('dbuEstimatedPickUp') != null){
                                        items.estimatedPickUp = (String)ob.get('dbuEstimatedPickUp');
                                    }else{
                                        items.estimatedPickUp = '';
                                    }        
                                    
                                    System.debug('111items.sfid*****************************************************\t'+items.sfid);
                                    orderItemsList.add(items);
                                    
                                }
                                
                            }
                            wrapper.EOrderItemsS =orderItemsList;
                            
                        }
                        
                        // wrapperlist.add(wrapper);
                        //orderItemsRelatedList(orderItemsList);
                        
                        
                        list<dbu_CCApiOrderRelatedResponseWrapper> wrapperlist1 = new list<dbu_CCApiOrderRelatedResponseWrapper>(); 
                        list<dbu_orderBillingAddress> billingAddressList = new list<dbu_orderBillingAddress>();
                        //################## Fetch CC Contact Address Details BillTo & ShipTo #########################
                        
                        List<Map<String, Object>> outputAddressList = (List<Map<String, Object>>)outputData.get(ccrz.ccAPIAddress.ADDRESSLIST);
                        String storeCountry;
                        if(outputAddressList!=null && outputAddressList.size()>0){
                            for(Map<String, Object> myAddress:outputAddressList)
                            {
                                if((string)myAddress.get('shippingComments') == 'Shipping Comments'){
                                    dbu_CCApiOrderRelatedResponseWrapper addresswrapper = new dbu_CCApiOrderRelatedResponseWrapper();
                                    String sfid = (String)myAddress.get('sfid');
                                    //wrapper.SKU =(String)myAddress.get('SKU');
                                    addresswrapper.sfdcName = (String)myAddress.get('sfdcName');
                                    addresswrapper.sfid = (String)myAddress.get('sfid');          
                                    addresswrapper.firstName = (String)myAddress.get('firstName');
                                    addresswrapper.lastName = (String)myAddress.get('lastName');
                                    addresswrapper.email = (String)myAddress.get('email');
                                    addresswrapper.homePhone = (String)myAddress.get('homePhone');
                                    addresswrapper.addressFirstline = (String)myAddress.get('addressFirstline');
                                    addresswrapper.addressSecondline = (String)myAddress.get('addressSecondline'); 
                                    addresswrapper.city = (String)myAddress.get('city');
                                    addresswrapper.state = (String)myAddress.get('state');
                                    //addresswrapper.country = (String)myAddress.get('country');
                                    if((string)myAddress.get('country') == 'US'){
                                    addresswrapper.country = 'U.S.A.';
                                    }else if((string)myAddress.get('country') == 'CA'){
                                    addresswrapper.country = 'Canada';
                                }
                                    addresswrapper.postalCode = (String)myAddress.get('postalCode');
                                    wrapperlist1.add(addresswrapper);
                                }
                                
                                
                                if((string)myAddress.get('shippingComments') == 'Billing Comments'){
                                    dbu_orderBillingAddress billingwrap = new dbu_orderBillingAddress();
                                    String sfid = (String)myAddress.get('sfid');
                                    //wrapper.SKU =(String)myAddress.get('SKU');
                                    billingwrap.sfdcName = (String)myAddress.get('sfdcName');
                                    billingwrap.sfid = (String)myAddress.get('sfid');          
                                    billingwrap.firstName = (String)myAddress.get('firstName');
                                    billingwrap.lastName = (String)myAddress.get('lastName');
                                    billingwrap.email = (String)myAddress.get('email');
                                    billingwrap.homePhone = (String)myAddress.get('homePhone');
                                    billingwrap.addressFirstline = (String)myAddress.get('addressFirstline');
                                    billingwrap.addressSecondline = (String)myAddress.get('addressSecondline'); 
                                    billingwrap.city = (String)myAddress.get('city');
                                    billingwrap.state = (String)myAddress.get('state');
                                    //billingwrap.country = (String)myAddress.get('country');
                                    if((string)myAddress.get('country') == 'US'){
                                        billingwrap.country = 'U.S.A.';
                                        storeCountry =(string)myAddress.get('country'); 
                                    }else if((string)myAddress.get('country') == 'CA'){
                                        billingwrap.country = 'Canada';
                                        storeCountry =(string)myAddress.get('country'); 
                                }
                                    billingwrap.postalCode = (String)myAddress.get('postalCode');
                                    billingAddressList.add(billingwrap);
                                }
                                
                            } 
                            wrapper.addresslist=wrapperlist1;
                            wrapper.billingAddress=billingAddressList;
                        }
                        //##################################
                        list<dbu_CCApiOrderItemsResponseWrapper> productlist = new list<dbu_CCApiOrderItemsResponseWrapper>();    
                        List<Map<String, Object>> outputProductList = (List<Map<String, Object>>)outputData.get(ccrz.ccApiProduct.PRODUCTLIST);
                        System.debug('outputProductList=11111====>'+outputProductList);
                        if(outputProductList!=null && outputProductList.size()>0){
                            // Added for CECI-957
                            Set<String> productSFID = new Set<String>();
                            for(Map<String, Object> myProducts:outputProductList)
                            {
                                productSFID.add((String)myProducts.get('sfid'));
                            }
                           Map<String,String>  productvsPromotionTag = dbu_CallCCWishListApi.getProductPromotiontag(productSFID,storeCountry);
                            for(Map<String, Object> myProducts:outputProductList)
                            {
                                dbu_CCApiOrderItemsResponseWrapper productwrapper = new dbu_CCApiOrderItemsResponseWrapper();
                                productwrapper.sfdcName = (String)myProducts.get('sfdcName');
                                /**Core charge Logic here */
                                productwrapper.sfid = (String)myProducts.get('sfid'); 
                                productwrapper.SKU=(String)myProducts.get('SKU');//Added CECI-958
                                wrapper.quantityperUnit = (decimal)myProducts.get('quantityperUnit');
                                // Added for CECI-957
                                productwrapper.promotionTag = productvsPromotionTag.get((String)myProducts.get('sfid'));
                                //productwrapper.OrderItems = (String)myProducts.get('OrderItems'); 
                                //productwrapper.parentId = (String)myProducts.get('parentId');
                                productwrapper.URI = (String)myProducts.get('URI');
                                //productwrapper.numberOfReviews = (Decimal)myProducts.get('numberOfReviews');
                                /**Shriram 24Nov2020 Core Charge only */
                                system.debug('productwrapper.sfid===PPID==>>'+productwrapper.sfid+'productListByIDMap.get(productwrapper.sfid)==>'+productListByIDMap.get(productwrapper.sfid));
                                if(productListByIDMap.get(productwrapper.sfid) != null ){
                                    ccrz__E_Product__c prod = productListByIDMap.get(productwrapper.sfid);
                                    if(prod != null && prod.dbu_Has_Core_Charge__c && prod.dbu_Has_Core_Child__c == True){
                                        productwrapper.isCoreProduct = true; 
                                    }
                                }    
                                /**end here */
                                
                                List<Map<String,Object >> productMedia = (List<Map<String,Object >>)myProducts.get('EProductMediasS');
                                
                                List<dbu_ProductMediaWrapper> productMediaList = new List<dbu_ProductMediaWrapper>();
                                
                                if(productMedia!=null && productMedia.size()>0){
                                    for(Map<String,Object> ob : productMedia)
                                    {
                                        dbu_ProductMediaWrapper media = new dbu_ProductMediaWrapper();
                                        media.sfdcCurrencyISOCode = (String)ob.get('sfdcCurrencyISOCode');
                                        media.URI = (String)ob.get('URI');
                                        media.startDate = (Date)ob.get('startDate');
                                        media.sequence = (Decimal)ob.get('sequence');
                                        media.productMediaSource = (String)ob.get('productMediaSource');
                                        media.mediaType = (String)ob.get('mediaType');
                                        media.locale = (String)ob.get('locale');
                                        media.endDate = (Date)ob.get('endDate');
                                        media.enabled = (Boolean)ob.get('enabled');
                                        media.sfdcName = (String)ob.get('sfdcName');
                                        media.sfid = (String)ob.get('sfid');
                                        media.product = (String)ob.get('product');
                                        if(media.mediaType == 'Product Image'){
                                            system.debug('entering the if loop>>' +media.mediaType);
                                            productMediaList.add(media);
                                        }
                                    }
                                }
                                
                                productwrapper.EProductMediasS =productMediaList;
                                System.debug('3333wrapper@@@@@@@@@@@@\t'+wrapper);
                                productlist.add(productwrapper);
                                //  productMedia(productMediaList);
                                //productlist.add(productwrapper);
                            } 
                            wrapper.productlist=productlist;
                        }
                    }
                    wrapperlist.add(wrapper);
                    system.debug('finalwrapper'+json.serialize(wrapperlist));
                    
                    
                } catch (Exception e) {
                    system.debug(e);
                    system.debug('exception message '+e.getmessage()+''+'exception line number '+e.getlinenumber());// Error handling...
                }
        return wrapperlist;
    }
    
    // To Fetch the order details based on the Name and Email's
    
    @AuraEnabled(cacheable=true)
    public static list<dbu_CCOrderAPIResponseWrapper> fetchOrderDetailsbyNameandEmail(List<String> orderidset){
        list<dbu_CCOrderAPIResponseWrapper> wrapperlist = new list<dbu_CCOrderAPIResponseWrapper>();
        dbu_CCOrderAPIResponseWrapper wrapper = new dbu_CCOrderAPIResponseWrapper();
        Set<String> orderIdList = new Set<String>();
        //Set<String> orderIdList = new Set<String>{'a2V19000001ANhqEAG'};
        if(orderidset!= NULL && orderidset.size()>0)
            for(String str:orderidset){
                orderIdList.add(str);
            }
        Map<String, Object> inputData = new Map<String, Object>{
            ccrz.ccAPIOrder.PARAM_ORDER_ID_LIST => orderIdList,
                ccrz.ccAPI.API_VERSION => ccrz.ccApi.CURRENT_VERSION,
                ccrz.ccApi.SIZING => new Map<String, Object> {
                    ccrz.ccAPIOrder.ENTITYNAME => new Map<String, Object> {
                        ccrz.ccApi.SZ_DATA => ccrz.ccApi.SZ_XL,
                            ccrz.ccApi.SZ_REL => New List<String>{'E_OrderItems__r'}
                        
                    },
                        ccrz.ccApiAddress.ENTITYNAME => new Map<String, Object> {
                            ccrz.ccApi.SZ_DATA => ccrz.ccApi.SZ_XL
                                }
                }  
        };
        Map<String, String> mapOrderToPaymentMethod = new Map<String, String>();
        List<ccrz__E_TransactionPayment__c> lstTP = new List<ccrz__E_TransactionPayment__c>();
                       lstTP = [Select Id,ccrz__AccountNumber__c, ccrz__CCOrder__c,ccrz__TransactionType__c from ccrz__E_TransactionPayment__c where ccrz__CCOrder__c IN: orderIdList];
                       for(ccrz__E_TransactionPayment__c tpObj : lstTP)
                       {
                           String accountNumber = tpObj.ccrz__AccountNumber__c;
                           if(tpObj.ccrz__TransactionType__c.toUpperCase() == 'PAYPAL' && tpObj.ccrz__AccountNumber__c != null && tpObj.ccrz__AccountNumber__c != '')
                           {
                                String cardNumber= tpObj.ccrz__AccountNumber__c;
                                String lastDigit = cardNumber.right(4);
                                for(Integer i = 0;i<cardNumber.length()-4;i++)
                                lastDigit = 'x'+lastDigit;
                                accountNumber = lastDigit;
                           }
                           mapOrderToPaymentMethod.put(tpObj.ccrz__CCOrder__c,tpObj.ccrz__TransactionType__c+' '+accountNumber);
                           
                       }
        
        
        
            try{
                Map<String, Object> outputData = ccrz.ccApiOrder.fetch(inputData);
                if (outputData.get(ccrz.ccApiOrder.ORDERLIST) != null) {
                    system.debug('outputData-->'+outputData);
                    system.debug('outputDatakeyset-->'+outputData.keyset());
                    
                    List<Map<String, Object>> outputOrderList = (List<Map<String, Object>>) outputData.get(ccrz.ccApiOrder.ORDERLIST);
                    system.debug('outputOrderList'+JSON.serialize(outputOrderList));
                    system.debug('outputOrderList>>>' +outputOrderList);
                    
                    
                    if(outputOrderList!=null && outputOrderList.size()>0 ){
                        
                        Map<String, Object> myOrder = new Map<String, Object>();
                        
                        for(Map<String, Object> ob:outputOrderList)
                        {
                            System.debug('obsfid=>'+ (String)ob.get('sfid'));
                            String sfid = (String)ob.get('sfid');
                            System.debug('my order is matching now');
                            myOrder = ob;
                            
                        }
                        //wrapper.orderNumber = (String)myOrder.get('orderNumber');
                        //wrapper.orderDate = (Date)myOrder.get('orderDate');
                        //wrapper.orderedDate = wrapper.orderDate.format();
                        Date dt = (date)myOrder.get('orderDate');
                        //wrapper.orderDate = myOrder.get('orderDate');
                        wrapper.orderDate = DateTime.newInstance(dt.year(),dt.month(),dt.day()).format('MMMM dd, yyyy');
                        wrapper.sfdcName = (String)myOrder.get('sfdcName');
                        wrapper.sfid = (String)myOrder.get('sfid');
                        //wrapper.orderStatus = (String)myOrder.get('orderStatus');
                        //wrapper.billTo = (String)myOrder.get('billTo');
                        wrapper.buyerFirstName = (String)myOrder.get('buyerFirstName');
                        wrapper.buyerLastName = (String)myOrder.get('buyerLastName');
                        wrapper.buyerPhone = (String)myOrder.get('buyerPhone');
                        wrapper.buyerEmail = (String)myOrder.get('buyerEmail');
                        wrapper.items = (decimal)myOrder.get('dbuNewOriginalOrderTotal');
                        System.debug('items>>>>'+wrapper);
                        wrapper.shipAmount = (decimal)myOrder.get('shipAmount');
                        System.debug('shipAmount>>>>'+wrapper);
                        wrapper.subtotalAmount = (decimal)myOrder.get('subtotalAmount');
                        System.debug('subtotalAmount>>>>'+wrapper);                           
                        wrapper.totalDiscount = (decimal)myOrder.get('totalDiscount');
                        System.debug('totalDiscount>>>>'+wrapper);
                        wrapper.taxAmount = (decimal)myOrder.get('taxAmount');
                        System.debug('taxAmount>>>>'+wrapper);
                        wrapper.taxSubTotalAmount = (decimal)myOrder.get('taxSubTotalAmount');
                        System.debug('taxSubTotalAmount>>>>'+wrapper);
                        wrapper.totalAmount = (decimal)myOrder.get('totalAmount');
                        System.debug('totalAmount>>>>'+wrapper); 
                        wrapper.dbupickupAddress = (string)myOrder.get('dbupickupAddress');
                        
                        wrapper.paymentMethod = mapOrderToPaymentMethod.get(wrapper.sfid);
                        //System.debug('dbupickupAddress>'+ dbupickupAddress);
                        
                        // wrapper.subtotalAmount = (decimal)myOrder.get('subtotalAmount');
                        // wrapper.quantityperUnit = (decimal)myOrder.get('quantityperUnit');
                        
                        List<Map<string,object>> orderItemsRelatedList = (List<Map<string,object>>) myOrder.get('EOrderItemsS');
                        System.debug('ORDER ITEM DETAILS::::: ' + json.serialize(orderItemsRelatedList));
                        
                        List<dbu_OrderItemsRelatedListWrapper> orderItemsList = new List<dbu_OrderItemsRelatedListWrapper>();
                        if(orderItemsRelatedList!=null && orderItemsRelatedList.size()>0){
                            for(Map<String,Object> ob : orderItemsRelatedList)
                            {
                                dbu_OrderItemsRelatedListWrapper items = new dbu_OrderItemsRelatedListWrapper();
                                items.quantity = (decimal)ob.get('quantity');
                                items.price = (decimal)ob.get('price');
                                items.subAmount = (decimal)ob.get('subAmount');
                                items.orderItemStatus = (String)ob.get('orderItemStatus');
                                items.sfid = (String)ob.get('sfid');
                                System.debug('2222items.sfid*****************************************************\t'+items.sfid);
                                orderItemsList.add(items);
                                
                            }
                            
                        }
                        wrapper.EOrderItemsS =orderItemsList;
                        
                    }
                    
                    // wrapperlist.add(wrapper);
                    //orderItemsRelatedList(orderItemsList);
                    
                    
                    list<dbu_CCApiOrderRelatedResponseWrapper> wrapperlist1 = new list<dbu_CCApiOrderRelatedResponseWrapper>(); 
                    list<dbu_orderBillingAddress> billingAddressList = new list<dbu_orderBillingAddress>();
                    //################## Fetch CC Contact Address Details BillTo & ShipTo #########################
                    
                    List<Map<String, Object>> outputAddressList = (List<Map<String, Object>>)outputData.get(ccrz.ccAPIAddress.ADDRESSLIST);
                    
                    if(outputAddressList!=null && outputAddressList.size()>0){
                        for(Map<String, Object> myAddress:outputAddressList)
                        {
                            if((string)myAddress.get('shippingComments') == 'Shipping Comments'){
                                dbu_CCApiOrderRelatedResponseWrapper addresswrapper = new dbu_CCApiOrderRelatedResponseWrapper();
                                String sfid = (String)myAddress.get('sfid');
                                //wrapper.SKU =(String)myAddress.get('SKU');
                                addresswrapper.sfdcName = (String)myAddress.get('sfdcName');
                                addresswrapper.sfid = (String)myAddress.get('sfid');          
                                addresswrapper.firstName = (String)myAddress.get('firstName');
                                addresswrapper.lastName = (String)myAddress.get('lastName');
                                addresswrapper.email = (String)myAddress.get('email');
                                addresswrapper.homePhone = (String)myAddress.get('homePhone');
                                addresswrapper.addressFirstline = (String)myAddress.get('addressFirstline');
                                addresswrapper.addressSecondline = (String)myAddress.get('addressSecondline'); 
                                addresswrapper.city = (String)myAddress.get('city');
                                addresswrapper.state = (String)myAddress.get('state');
                                //addresswrapper.country = (String)myAddress.get('country');
                                if((string)myAddress.get('country') == 'US'){
                                    addresswrapper.country = 'U.S.A.';
                                    }else if((string)myAddress.get('country') == 'CA'){
                                    addresswrapper.country = 'Canada';
                                }
                                addresswrapper.postalCode = (String)myAddress.get('postalCode');
                                wrapperlist1.add(addresswrapper);
                            }
                            
                            
                            if((string)myAddress.get('shippingComments') == 'Billing Comments'){
                                dbu_orderBillingAddress billingwrap = new dbu_orderBillingAddress();
                                String sfid = (String)myAddress.get('sfid');
                                //wrapper.SKU =(String)myAddress.get('SKU');
                                billingwrap.sfdcName = (String)myAddress.get('sfdcName');
                                billingwrap.sfid = (String)myAddress.get('sfid');          
                                billingwrap.firstName = (String)myAddress.get('firstName');
                                billingwrap.lastName = (String)myAddress.get('lastName');
                                billingwrap.email = (String)myAddress.get('email');
                                billingwrap.homePhone = (String)myAddress.get('homePhone');
                                billingwrap.addressFirstline = (String)myAddress.get('addressFirstline');
                                billingwrap.addressSecondline = (String)myAddress.get('addressSecondline'); 
                                billingwrap.city = (String)myAddress.get('city');
                                billingwrap.state = (String)myAddress.get('state');
                                //billingwrap.country = (String)myAddress.get('country');
                                if((string)myAddress.get('country') == 'US'){
                                    billingwrap.country = 'U.S.A.';
                                    }else if((string)myAddress.get('country') == 'CA'){
                                    billingwrap.country = 'Canada';
                                }
                                billingwrap.postalCode = (String)myAddress.get('postalCode');
                                billingAddressList.add(billingwrap);
                            }
                            
                        } 
                        wrapper.addresslist=wrapperlist1;
                        wrapper.billingAddress=billingAddressList;
                    }
                    //##################################
                    list<dbu_CCApiOrderItemsResponseWrapper> productlist = new list<dbu_CCApiOrderItemsResponseWrapper>();    
                    List<Map<String, Object>> outputProductList = (List<Map<String, Object>>)outputData.get(ccrz.ccApiProduct.PRODUCTLIST);
                    if(outputProductList!=null && outputProductList.size()>0){
                        
                        for(Map<String, Object> myProducts:outputProductList)
                        {
                            dbu_CCApiOrderItemsResponseWrapper productwrapper = new dbu_CCApiOrderItemsResponseWrapper();
                            productwrapper.sfdcName = (String)myProducts.get('sfdcName');
                            productwrapper.sfid = (String)myProducts.get('sfid'); 
                            wrapper.quantityperUnit = (decimal)myProducts.get('quantityperUnit');
                            
                            //productwrapper.OrderItems = (String)myProducts.get('OrderItems'); 
                            //productwrapper.parentId = (String)myProducts.get('parentId');
                            productwrapper.URI = (String)myProducts.get('URI');
                            //productwrapper.numberOfReviews = (Decimal)myProducts.get('numberOfReviews');
                            
                            
                            List<Map<String,Object >> productMedia = (List<Map<String,Object >>)myProducts.get('EProductMediasS');
                            
                            List<dbu_ProductMediaWrapper> productMediaList = new List<dbu_ProductMediaWrapper>();
                            
                            if(productMedia!=null && productMedia.size()>0){
                                for(Map<String,Object> ob : productMedia)
                                {
                                    dbu_ProductMediaWrapper media = new dbu_ProductMediaWrapper();
                                    media.sfdcCurrencyISOCode = (String)ob.get('sfdcCurrencyISOCode');
                                    media.URI = (String)ob.get('URI');
                                    media.startDate = (Date)ob.get('startDate');
                                    media.sequence = (Decimal)ob.get('sequence');
                                    media.productMediaSource = (String)ob.get('productMediaSource');
                                    media.mediaType = (String)ob.get('mediaType');
                                    media.locale = (String)ob.get('locale');
                                    media.endDate = (Date)ob.get('endDate');
                                    media.enabled = (Boolean)ob.get('enabled');
                                    media.sfdcName = (String)ob.get('sfdcName');
                                    media.sfid = (String)ob.get('sfid');
                                    media.product = (String)ob.get('product');
                                    if(media.mediaType == 'Product Image'){
                                        system.debug('entering the if loop>>' +media.mediaType);
                                        productMediaList.add(media);
                                    }
                                }
                            }
                            
                            productwrapper.EProductMediasS =productMediaList;
                            System.debug('3333wrapper@@@@@@@@@@@@\t'+wrapper);
                            productlist.add(productwrapper);
                            //  productMedia(productMediaList);
                            //productlist.add(productwrapper);
                        } 
                        wrapper.productlist=productlist;
                    }
                }
                wrapperlist.add(wrapper);
                system.debug('finalwrapper'+json.serialize(wrapperlist));
                
                
            } catch (Exception e) {
                system.debug(e);
                system.debug('exception message '+e.getmessage()+''+'exception line number '+e.getlinenumber());// Error handling...
            }
        
        return wrapperlist;
    }
    
    // To Fetch Each order detail on clicking 
    
    @AuraEnabled
    public static list<dbu_CCOrderAPIResponseWrapper> fetchOrderDetailsOnClick(string orderId){
        
        list<dbu_CCOrderAPIResponseWrapper> wrapperlist = new list<dbu_CCOrderAPIResponseWrapper>();
        
        dbu_CCOrderAPIResponseWrapper wrapper = new dbu_CCOrderAPIResponseWrapper();
        
        //Set<String> orderIdList = new Set<String>{'a2V19000001ANhqEAG'};
        Set<String> orderIdList = new Set<String>();
        orderIdList.add(orderId);
        system.debug('orderIdList security testing ' + orderIdList);
        Map<String, Object> inputData = new Map<String, Object>{
            ccrz.ccAPIOrder.PARAM_ORDER_ID_LIST => orderIdList,
                ccrz.ccAPI.API_VERSION => ccrz.ccApi.CURRENT_VERSION,
                ccrz.ccApi.SIZING => new Map<String, Object> {
                    ccrz.ccAPIOrder.ENTITYNAME => new Map<String, Object> {
                        ccrz.ccApi.SZ_DATA => ccrz.ccApi.SZ_XL,
                            ccrz.ccApi.SZ_REL => New List<String>{'E_OrderItems__r'}
                        
                    },
                        ccrz.ccApiAddress.ENTITYNAME => new Map<String, Object> {
                            ccrz.ccApi.SZ_DATA => ccrz.ccApi.SZ_XL
                                }
                }  
        };
        String paymentMethodStr ='';
            List<ccrz__E_TransactionPayment__c> lstTP = new List<ccrz__E_TransactionPayment__c>();
                       lstTP = [Select Id,ccrz__AccountNumber__c, ccrz__TransactionType__c from ccrz__E_TransactionPayment__c where ccrz__CCOrder__c =: orderId];
                       if(lstTP.size() > 0)
                       {
                           String accountNumber = lstTP[0].ccrz__AccountNumber__c;
                           if(lstTP[0].ccrz__TransactionType__c.toUpperCase() == 'PAYPAL' && lstTP[0].ccrz__AccountNumber__c != null && lstTP[0].ccrz__AccountNumber__c != '')
                           {
                                String cardNumber= lstTP[0].ccrz__AccountNumber__c;
                                String lastDigit = cardNumber.right(4);
                                for(Integer i = 0;i<cardNumber.length()-4;i++)
                                lastDigit = 'x'+lastDigit;
                               accountNumber = lastDigit;
                           }
                           paymentMethodStr = lstTP[0].ccrz__TransactionType__c+' '+accountNumber;
                       }
        //added by Ranadip on 30/11/2020
        boolean isInvoiceCrd = true;
        List<ccrz__E_Invoice__c> lstOfInvoice = new List<ccrz__E_Invoice__c>();
        lstOfInvoice = [SELECT Id , Name FROM ccrz__E_Invoice__c WHERE ccrz__CCOrder__c =: orderId];
        if(lstOfInvoice.size() > 0){
            isInvoiceCrd = false;
        }
        // end here
       
            try{
                Map<String, Object> outputData = ccrz.ccApiOrder.fetch(inputData);
                if (outputData.get(ccrz.ccApiOrder.ORDERLIST) != null) {
                    system.debug('outputData-->'+outputData);
                    system.debug('outputDatakeyset-->'+outputData.keyset());
                    
                    List<Map<String, Object>> outputOrderList = (List<Map<String, Object>>) outputData.get(ccrz.ccApiOrder.ORDERLIST);
                    system.debug('outputOrderList'+JSON.serialize(outputOrderList));
                    system.debug('outputOrderList>>>' +outputOrderList);
                    
                    
                    if(outputOrderList!=null && outputOrderList.size()>0 ){
                        
                        Map<String, Object> myOrder = new Map<String, Object>();
                        
                        for(Map<String, Object> ob:outputOrderList)
                        {
                            
                            //wrapper.orderStatus = (String)ob.get('orderStatus');
                            System.debug('obsfid=>'+ (String)ob.get('sfid'));
                            String sfid = (String)ob.get('sfid');
                            System.debug('my order is matching now');
                            myOrder = ob;
                            
                        }
                         //--Added by Mukesh Gupta for CurrencyISOCode-- 18-01-2021
                        System.debug('AllMapKeys========='+myOrder.keySet());
                        System.debug('CurrencyISOCOde ===='+(String)myOrder.get('currencyISOCode'));
                        wrapper.currencyISOCode = (String)myOrder.get('currencyISOCode');
                        //wrapper.orderNumber = (String)myOrder.get('orderNumber');
                        //wrapper.orderDate = (Date)myOrder.get('orderDate');
                        //wrapper.orderedDate = wrapper.orderDate.format();
                        Date dt = (date)myOrder.get('orderDate'); 
                        //wrapper.orderDate = myOrder.get('orderDate');
                        wrapper.orderDate = DateTime.newInstance(dt.year(),dt.month(),dt.day()).format('MMMM dd, yyyy');
                        wrapper.sfdcName = (String)myOrder.get('sfdcName');
                        wrapper.sfid = (String)myOrder.get('sfid');                       
                        wrapper.orderStatus = (String)myOrder.get('orderStatus');
                        //wrapper.billTo = (String)myOrder.get('billTo');
                        wrapper.buyerFirstName = (String)myOrder.get('buyerFirstName');
                        wrapper.buyerLastName = (String)myOrder.get('buyerLastName');
                        wrapper.buyerPhone = (String)myOrder.get('buyerPhone');
                        wrapper.buyerEmail = (String)myOrder.get('buyerEmail');
                        wrapper.items = (decimal)myOrder.get('dbuNewOriginalOrderTotal');
                        System.debug('items>>>>'+wrapper);
                        wrapper.shipAmount = (decimal)myOrder.get('shipAmount');
                        System.debug('shipAmount>>>>'+wrapper);
                        wrapper.subtotalAmount = (decimal)myOrder.get('subtotalAmount');
                        System.debug('subtotalAmount>>>>'+wrapper);                           
                        wrapper.totalDiscount = (decimal)myOrder.get('totalDiscount');
                        System.debug('totalDiscount>>>>'+wrapper);
                        wrapper.taxAmount = (decimal)myOrder.get('taxAmount');
                        System.debug('taxAmount>>>>'+wrapper);
                        wrapper.taxSubTotalAmount = (decimal)myOrder.get('taxSubTotalAmount');
                        System.debug('taxSubTotalAmount>>>>'+wrapper);
                        wrapper.totalAmount = (decimal)myOrder.get('totalAmount');
                        System.debug('totalAmount>>>>'+wrapper);
                        wrapper.dbupickupAddress = (string)myOrder.get('dbupickupAddress');
                            //System.debug('dbupickupAddress>'+ dbupickupAddress);
                        wrapper.daysSinceOrderDate = (decimal)myOrder.get('dbuDaysSinceOrderDate');                                
                        // wrapper.subtotalAmount = (decimal)myOrder.get('subtotalAmount');
                        // wrapper.quantityperUnit = (decimal)myOrder.get('quantityperUnit');
                        wrapper.paymentMethod = paymentMethodStr;
                        wrapper.isInvoiceCreated = isInvoiceCrd;
                        
                        List<Map<string,object>> orderItemsRelatedList = (List<Map<string,object>>) myOrder.get('EOrderItemsS');
                        System.debug('ORDER ITEM DETAILS::::: ' + json.serialize(orderItemsRelatedList));
                        List<String> orderItemIds = new List<String>();
                        List<String> itemProdIds = new List<String>();
                        if(orderItemsRelatedList!=null && orderItemsRelatedList.size()>0){
                            
                            for(Map<String,Object> ob : orderItemsRelatedList)
                            {
                                orderItemIds.add((String)ob.get('sfid'));
                                itemProdIds.add((String)ob.get('product'));
                            }
                        }
                        
                        //  List<ccrz__E_OrderItem__c> listOItems = [Select id,name,ccrz__Product__c,ccrz__Quantity__c from ccrz__E_OrderItem__c where ccrz__OrderItemStatus__c = 'Return Initiated'];
                        //------------------------------------------
                        List<ccrz__E_OrderItem__c> listOItems = [Select id,name,dbu_Is_Returned__c,ccrz__Product__c,ccrz__Quantity__c from ccrz__E_OrderItem__c where (ccrz__OrderItemStatus__c = 'Return Initiated' OR ccrz__OrderItemStatus__c = 'Return Approved' OR ccrz__OrderItemStatus__c = 'Return Requested' OR ccrz__OrderItemStatus__c = 'Refunded' OR ccrz__OrderItemStatus__c = 'Open' OR ccrz__OrderItemStatus__c = 'OPEN') AND dbu_Is_Returned__c  = True AND id IN:orderItemIds];
                        Map<String,List<ccrz__E_OrderItem__c>> mapObj = new Map<String,List<ccrz__E_OrderItem__c>>();
                        List<ccrz__E_RelatedProduct__c> coreRelatedProdList = New List<ccrz__E_RelatedProduct__c>();
                        coreRelatedProdList =[Select Id,Name,ccrz__RelatedProduct__c,ccrz__Product__c,ccrz__RelatedProductType__c from ccrz__E_RelatedProduct__c where ccrz__RelatedProductType__c = 'Core Charge' and ccrz__Product__c IN:itemProdIds];  
                        wrapper.relatedProducts = coreRelatedProdList;
                         Set<Id> oItemIds = new Set<Id>();
                        
                        for(ccrz__E_OrderItem__c obj :listOItems  ){
                             oItemIds.add(obj.id);
                            if(mapObj.containsKey(obj.ccrz__Product__c)){
                                List<ccrz__E_OrderItem__c> orderItemObjList= mapObj.get(obj.ccrz__Product__c);
                                orderItemObjList.add(obj);
                                mapObj.put(obj.ccrz__Product__c, orderItemObjList);
                            }else {
                                mapObj.put(obj.ccrz__Product__c, new List<ccrz__E_OrderItem__c> { obj});
                            }
                        }
                        //----------
            
                        Map<String,String> cloneOrderAgainstOrgOrderItem = new Map<String,String>();
                        List<ccrz__E_OrderItem__c> cloneOitemsList = [Select id,name,ccrz__Order__c,ccrz__Order__r.Name,dbu_CC_Order_Item__c  from ccrz__E_OrderItem__c WHERE dbu_CC_Order_Item__c IN : oItemIds];
                        for(ccrz__E_OrderItem__c orderItemObj : cloneOitemsList){
                            cloneOrderAgainstOrgOrderItem.put(orderItemObj.dbu_CC_Order_Item__c, orderItemObj.ccrz__Order__r.Name );
                        }
                        wrapper.cloneOrderAgainstOrgOrderItemMap = cloneOrderAgainstOrgOrderItem;
                        
                        /***************************** RETRUN ORDER MODIFICATION MALHAR 21/2/2021 *************************************/
                        /*    
                        String reasonForReturn = System.Label.dbu_Return_Reason_for_Return;
                        String reasonDamageInShipping = System.Label.dbu_Return_Damaged_in_shipping;
                        String reasonOrderedWronPart = System.Label.dbu_Return_Ordered_the_wrong_part; 
                        String reasonPartNoLongerWanted = System.Label.dbu_Return_Part_no_longer_wanted; 
                        String reasonInCorrectPart = System.Label.dbu_Return_Incorrect_part_was_received;
                        
                        
                        String reasonDamageInShipping_FR = System.Label.dbu_DamagedInShipping_Pdf_FR;
                        String reasonOrderedWronPart_FR = System.Label.dbu_OrderedTheWrongPart_Pdf_FR; 
                        String reasonPartNoLongerWanted_FR = System.Label.dbu_reason_partNoLongerWanted_Pdf_FR; 
                        String reasonInCorrectPart_FR = System.Label.dbu_IncorrectPartWasReceived_Pdf_FR;                        
                        
                        if((cloneOrderAgainstOrgOrderItem.values()).size() > 0){
                            list<ccrz__E_Order__c> ClonedOrderList = new list<ccrz__E_Order__c>();
                            ClonedOrderList = [select id,
                                               Name,
                                               ccrz__OrderDate__c,
                                               (select id, ccrz__Order__c, ccrz__Price__c, ccrz__Quantity__c, dbu_Reason_for_Return__c, dbu_Estimated_Return_Amount__c 
                                                from ccrz__E_OrderItems__r 
                                                where ccrz__Price__c != null and ccrz__Quantity__c != null)
                                               from ccrz__E_Order__c 
                                               where Name in : cloneOrderAgainstOrgOrderItem.values()];
                            list<dbu_CloneOrderOrderItemsRespWrapper> cloneOrderAgainstOrgOrderItemDetails = new list<dbu_CloneOrderOrderItemsRespWrapper>();
                                                                                                            
                            if(ClonedOrderList.size() > 0){
                                for(ccrz__E_Order__c currentOrder : ClonedOrderList){
                                    Decimal ProductCost = 0.00;
                                    Decimal handlingFees = 0.00;
                                    Decimal Total = 0.00;
                                    if((currentOrder.ccrz__E_OrderItems__r).size() > 0){                                        
                                        for(ccrz__E_OrderItem__c each : currentOrder.ccrz__E_OrderItems__r){
                                            ProductCost = ProductCost + ((each.ccrz__Price__c)*(each.ccrz__Quantity__c));
                                            if(each.dbu_Reason_for_Return__c == reasonPartNoLongerWanted || each.dbu_Reason_for_Return__c == reasonOrderedWronPart || each.dbu_Reason_for_Return__c == reasonPartNoLongerWanted_FR || each.dbu_Reason_for_Return__c == reasonOrderedWronPart_FR){
                                                handlingFees = handlingFees + (each.ccrz__Price__c * each.ccrz__Quantity__c)*15/100;
                                            }
											Total = Total + each.dbu_Estimated_Return_Amount__c;
                                        }
                                    }
                                   
                                    Decimal SubTotal = ProductCost - handlingFees;
                                    
                                    
                                    dbu_CloneOrderOrderItemsRespWrapper eachCloneWrap = new dbu_CloneOrderOrderItemsRespWrapper();
                                    eachCloneWrap.Clonedorderid = currentOrder.id;
                                    eachCloneWrap.ClonedorderName = currentOrder.Name;
                                    if((currentOrder.ccrz__E_OrderItems__r).size() > 0){
                                        eachCloneWrap.ClonedOrderitems = currentOrder.ccrz__E_OrderItems__r;
                                    }else{
                                        eachCloneWrap.ClonedOrderitems = new list<ccrz__E_OrderItem__c>{};
                                    }     
                                    eachCloneWrap.handlingFees = handlingFees;
                                    eachCloneWrap.ProductCost = ProductCost;                                    
                                    eachCloneWrap.SubTotal = SubTotal;
                                    eachCloneWrap.Total = Total;
                                    
                                    cloneOrderAgainstOrgOrderItemDetails.add(eachCloneWrap);
                                }
                                
                                wrapper.cloneOrderAgainstOrgOrderItemMapDetails = cloneOrderAgainstOrgOrderItemDetails;
                                system.debug('cloneOrderAgainstOrgOrderItemDetails > ' + JSON.serializePretty(cloneOrderAgainstOrgOrderItemDetails));
                            }
                            
                        } 
                        */
                        /***************************** RETRUN ORDER MODIFICATION MALHAR 21/2/2021 *************************************/
                        
                        //---------
                        //------------------------------------------
                        List<dbu_OrderItemsRelatedListWrapper> orderItemsList = new List<dbu_OrderItemsRelatedListWrapper>();
                        if(orderItemsRelatedList!=null && orderItemsRelatedList.size()>0){
                            for(Map<String,Object> ob : orderItemsRelatedList)
                            {
                                dbu_OrderItemsRelatedListWrapper items = new dbu_OrderItemsRelatedListWrapper();
                                
                                items.quantity = (decimal)ob.get('quantity');
                                items.price = (decimal)ob.get('price');
                                items.subAmount = (decimal)ob.get('subAmount');
                                items.orderItemStatus = (String)ob.get('orderItemStatus');
                                items.sfid = (String)ob.get('sfid');
                                items.additionalInfo = (String)ob.get('dbuReturnAdditionalInformation');
                                items.reasonForReturn = (String)ob.get('dbuReasonforReturn');
                                items.selectedReturnItems = (Boolean)ob.get('dbuSelectedReturnItems');
                                items.vertexTax = (decimal)ob.get('vertexTax');
                                items.prodId = (String)ob.get('product');
                                items.dropOffLocation = (string)ob.get('dbuDropoffLocation');
                                items.estReturnAmount=(decimal)ob.get('dbuEstimatedReturnAmount');
                                items.originalQuantity=(decimal)ob.get('originalQuantity');
                                items.dbuIsReturned=(boolean)ob.get('dbuIsReturned');
                                system.debug('items.dropOffLocation--->>'+items.dropOffLocation);
                                if(mapObj.containsKey(items.prodId)){
                                    Decimal alreadyReturnedQty =0.00;
                                    for(ccrz__E_OrderItem__c orderItemObj : mapObj.get(items.prodId)){
                                        alreadyReturnedQty = alreadyReturnedQty + orderItemObj.ccrz__Quantity__c;
                                    }
                                    items.newQuantity = items.quantity-alreadyReturnedQty;
                                }else{
                                     items.newQuantity = items.quantity;
                                }
                              
                                orderItemsList.add(items);
                                
                                /*items.quantity = (decimal)ob.get('quantity');
                                    items.price = (decimal)ob.get('price');
                                    items.subAmount = (decimal)ob.get('subAmount');
                                    items.orderItemStatus = (String)ob.get('orderItemStatus');
                                    items.sfid = (String)ob.get('sfid');
                                   // System.debug('333items.sfid*****************************************************\t'+items.sfid);
                                    
                                    orderItemsList.add(items);*/
                                
                            }
                            
                        }
                        wrapper.EOrderItemsS =orderItemsList;
                        
                    }
                    
                    // wrapperlist.add(wrapper);
                    //orderItemsRelatedList(orderItemsList);
                    
                    
                    list<dbu_CCApiOrderRelatedResponseWrapper> wrapperlist1 = new list<dbu_CCApiOrderRelatedResponseWrapper>(); 
                    list<dbu_orderBillingAddress> billingAddressList = new list<dbu_orderBillingAddress>();
                    //################## Fetch CC Contact Address Details BillTo & ShipTo #########################
                    
                    List<Map<String, Object>> outputAddressList = (List<Map<String, Object>>)outputData.get(ccrz.ccAPIAddress.ADDRESSLIST);
                    String storeCountry;
                    if(outputAddressList!=null && outputAddressList.size()>0){
                        for(Map<String, Object> myAddress:outputAddressList)
                        {
                            if((string)myAddress.get('shippingComments') == 'Shipping Comments'){
                                dbu_CCApiOrderRelatedResponseWrapper addresswrapper = new dbu_CCApiOrderRelatedResponseWrapper();
                                String sfid = (String)myAddress.get('sfid');
                                //wrapper.SKU =(String)myAddress.get('SKU');
                                addresswrapper.sfdcName = (String)myAddress.get('sfdcName');
                                addresswrapper.sfid = (String)myAddress.get('sfid');          
                                addresswrapper.firstName = (String)myAddress.get('firstName');
                                addresswrapper.lastName = (String)myAddress.get('lastName');
                                addresswrapper.email = (String)myAddress.get('email');
                                addresswrapper.homePhone = (String)myAddress.get('homePhone');
                                addresswrapper.addressFirstline = (String)myAddress.get('addressFirstline');
                                addresswrapper.addressSecondline = (String)myAddress.get('addressSecondline'); 
                                addresswrapper.city = (String)myAddress.get('city');
                                addresswrapper.state = (String)myAddress.get('state');
                               // addresswrapper.country = (String)myAddress.get('country');
                               if((string)myAddress.get('country') == 'US'){
                                    addresswrapper.country = 'U.S.A.';
                                    }else if((string)myAddress.get('country') == 'CA'){
                                    addresswrapper.country = 'Canada';
                                }
                                addresswrapper.postalCode = (String)myAddress.get('postalCode');
                                wrapperlist1.add(addresswrapper);
                            }
                            
                            
                            if((string)myAddress.get('shippingComments') == 'Billing Comments'){
                                dbu_orderBillingAddress billingwrap = new dbu_orderBillingAddress();
                                String sfid = (String)myAddress.get('sfid');
                                //wrapper.SKU =(String)myAddress.get('SKU');
                                billingwrap.sfdcName = (String)myAddress.get('sfdcName');
                                billingwrap.sfid = (String)myAddress.get('sfid');          
                                billingwrap.firstName = (String)myAddress.get('firstName');
                                billingwrap.lastName = (String)myAddress.get('lastName');
                                billingwrap.email = (String)myAddress.get('email');
                                billingwrap.homePhone = (String)myAddress.get('homePhone');
                                billingwrap.addressFirstline = (String)myAddress.get('addressFirstline');
                                billingwrap.addressSecondline = (String)myAddress.get('addressSecondline'); 
                                billingwrap.city = (String)myAddress.get('city');
                                billingwrap.state = (String)myAddress.get('state');
                               // billingwrap.country = (String)myAddress.get('country');
                               if((string)myAddress.get('country') == 'US'){
                                    billingwrap.country = 'U.S.A.';
                                    storeCountry =(string)myAddress.get('country'); 
                                }else if((string)myAddress.get('country') == 'CA'){
                                    storeCountry =(string)myAddress.get('country');      
                                    billingwrap.country = 'Canada';
                                }
                                billingwrap.postalCode = (String)myAddress.get('postalCode');
                                billingAddressList.add(billingwrap);
                            }
                            
                        } 
                        wrapper.addresslist=wrapperlist1;
                        wrapper.billingAddress=billingAddressList;
                    }
                    //##################################
                    list<dbu_CCApiOrderItemsResponseWrapper> productlist = new list<dbu_CCApiOrderItemsResponseWrapper>();    
                    List<Map<String, Object>> outputProductList = (List<Map<String, Object>>)outputData.get(ccrz.ccApiProduct.PRODUCTLIST);
                    if(outputProductList!=null && outputProductList.size()>0){
                        // Added for CECI-957
                        Set<String> productSFID = new Set<String>();
                        for(Map<String, Object> myProducts:outputProductList)
                        {
                            productSFID.add((String)myProducts.get('sfid'));
                        }
                        Map<String,String>  productvsPromotionTag = dbu_CallCCWishListApi.getProductPromotiontag(productSFID,storeCountry);

                        for(Map<String, Object> myProducts:outputProductList)
                        {
                            dbu_CCApiOrderItemsResponseWrapper productwrapper = new dbu_CCApiOrderItemsResponseWrapper();
                            productwrapper.sfdcName = (String)myProducts.get('sfdcName');
                            productwrapper.sfid = (String)myProducts.get('sfid'); 
                            productwrapper.SKU=(String)myProducts.get('SKU');//Added CECI-958
                            wrapper.quantityperUnit = (decimal)myProducts.get('quantityperUnit');
                            productwrapper.genuinePart = (Boolean)myProducts.get('dbuGenuinePart');
                            productwrapper.nonReturnable = (Boolean)myProducts.get('dbuNonReturnable');
                            productwrapper.dbuPickUpOnly = (Boolean)myProducts.get('dbuPickUpOnly');
                            productwrapper.dbuCrateEngine = (Boolean)myProducts.get('dbuCrateEngine');
                            productwrapper.hasCoreCharge = (Boolean)myProducts.get('dbuHasCoreCharge'); 
                            productwrapper.dbuHasCoreChild = (Boolean)myProducts.get('dbuHasCoreChild');
                            productwrapper.URI = (String)myProducts.get('URI');
                            productwrapper.promotionTag = productvsPromotionTag.get((String)myProducts.get('sfid'));

                            //productwrapper.numberOfReviews = (Decimal)myProducts.get('numberOfReviews');
                            
                            
                            List<Map<String,Object >> productMedia = (List<Map<String,Object >>)myProducts.get('EProductMediasS');
                            
                            List<dbu_ProductMediaWrapper> productMediaList = new List<dbu_ProductMediaWrapper>();
                            
                            if(productMedia!=null && productMedia.size()>0){
                                for(Map<String,Object> ob : productMedia)
                                {
                                    dbu_ProductMediaWrapper media = new dbu_ProductMediaWrapper();
                                    media.sfdcCurrencyISOCode = (String)ob.get('sfdcCurrencyISOCode');
                                    media.URI = (String)ob.get('URI');
                                    media.startDate = (Date)ob.get('startDate');
                                    media.sequence = (Decimal)ob.get('sequence');
                                    media.productMediaSource = (String)ob.get('productMediaSource');
                                    media.mediaType = (String)ob.get('mediaType');
                                    media.locale = (String)ob.get('locale');
                                    media.endDate = (Date)ob.get('endDate');
                                    media.enabled = (Boolean)ob.get('enabled');
                                    media.sfdcName = (String)ob.get('sfdcName');
                                    media.sfid = (String)ob.get('sfid');
                                    media.product = (String)ob.get('product');
                                    if(media.mediaType == 'Product Image'){
                                        system.debug('entering the if loop>>' +media.mediaType);
                                        productMediaList.add(media);
                                    }
                                }
                            }
                            
                            productwrapper.EProductMediasS =productMediaList;
                            System.debug('3333wrapper@@@@@@@@@@@@\t'+wrapper);
                            productlist.add(productwrapper);
                            //  productMedia(productMediaList);
                            //productlist.add(productwrapper);
                        } 
                        wrapper.productlist=productlist;
                    }
                    
                }
                wrapperlist.add(wrapper);
                system.debug('finalwrapper'+json.serialize(wrapperlist));
              
            } catch (Exception e) {
                system.debug('getStackTraceString ' + e.getStackTraceString());
                system.debug('exception message '+e.getmessage()+''+'exception line number '+e.getlinenumber());// Error handling...
            }
        return wrapperlist;
    }    
    
    
    /* public static list<dbu_ProductMediaWrapper> productMedia(List<dbu_ProductMediaWrapper> prdMedia){
List<dbu_ProductMediaWrapper> prdMediaList = new List<dbu_ProductMediaWrapper>();
try{
if(!prdMedia.isEmpty()){
prdMediaList.addall(prdMedia);
system.Debug('prdMediaList>>' +prdMediaList);

}
}
catch(Exception exc){
system.debug('exception message '+exc.getmessage()+''+'exception line number '+exc.getlinenumber());// Error handling...

}
return prdMediaList;

}*/
    
    //Block returns when return item doesn't have a weight (CECI-657)
    @AuraEnabled
    public static Map<String,Boolean> getProductWeight(List<String> itemProdRtnIds){
        Map<String,Boolean> prodsWeight =  new Map<String,Boolean>();
        List<ccrz__E_ProductSpec__c> listOfProductSpec = new List<ccrz__E_ProductSpec__c>();
        listOfProductSpec = [select ccrz__Product__c,ccrz__SpecValue__c,ccrz__Spec__r.Name from ccrz__E_ProductSpec__c where ccrz__Product__c IN: itemProdRtnIds AND ccrz__Spec__r.Name = 'Shipment Weight'];
        for(ccrz__E_ProductSpec__c prodSepecWeightCheck : listOfProductSpec){  
            Boolean weightValid = false;                          
            String weightValue = prodSepecWeightCheck.ccrz__SpecValue__c;
            if(String.isBlank(weightValue)) weightValue = '0.00';
            if(weightValue.contains(' ')){
                weightValid = Decimal.valueOf(weightValue.substringBefore(' ')) > 0.00 ? true : false;
            }else{
                weightValid = Decimal.valueOf(weightValue) > 0.00 ? true : false;
            } 
            prodsWeight.put((String)prodSepecWeightCheck.ccrz__Product__c,weightValid);                           
        }
        if(listOfProductSpec.size() == 0 && itemProdRtnIds.size() >= 1) {
            prodsWeight.put(itemProdRtnIds[0],false); 
        }
        return prodsWeight;
    }
}