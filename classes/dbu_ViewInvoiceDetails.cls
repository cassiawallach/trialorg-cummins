public without sharing class dbu_ViewInvoiceDetails {
    @AuraEnabled(cacheable=true)
    public static dbu_WrapperInvoiceDetails viewInvoiceData(String urlParam){
        String orderid;
        List<String> listProdIds = new List<String>();
        if(String.isNotBlank(urlParam)){
            ApexPages.PageReference ref = new ApexPages.PageReference(urlParam);
            Map<String, String> params = ref.getParameters();
            if(params.size() > 0 && params.containsKey('orderid')){
                orderid =  params.get('orderid');
            }
        } 
        
        ccrz__E_Order__c orderDetails = new ccrz__E_Order__c();
        List<ccrz__E_TransactionPayment__c> lstOftransantionPayment = new List<ccrz__E_TransactionPayment__c>();
        dbu_WrapperInvoiceDetails orderDetailsObj = new  dbu_WrapperInvoiceDetails();
        
        //Added by Ranadip for Security issues 
        if(!dbu_UserValidation.validateUser(orderid)){
            return orderDetailsObj;
        }// end here
        
        Map < String, List < ccrz__E_InvoiceItem__c >> mapInvoiceItemList = new Map < String, List < ccrz__E_InvoiceItem__c >> ();
        List<ccrz__E_Invoice__c> invoiceDetails = New List<ccrz__E_Invoice__c>();
        List<dbu_WrapperInvoiceDetails.InvoiceDetailsData> listInvoiceDetails = new List<dbu_WrapperInvoiceDetails.InvoiceDetailsData>();
        orderDetails = [SELECT id,ccrz__OriginatedCart__r.dbu_Pick_Up_From_Store__c,ccrz__OriginatedCart__r.ccrz__ShipTo__c,ccrz__User__c,ccrz__OrderDate__c,ccrz__ShipMethod__c,ccrz__OriginatedCart__c,CurrencyIsoCode ,ccrz__SubtotalAmount__c,ccrz__TotalDiscount__c,ccrz__TaxAmount__c,ccrz__ShipAmount__c,ccrz__TotalAmount__c, Name, ccrz__PaymentMethod__c,ccrz__ShipTo__r.ccrz__AddressFirstline__c,ccrz__ShipTo__r.ccrz__AddressSecondline__c,ccrz__ShipTo__r.ccrz__AddressThirdline__c,ccrz__ShipTo__r.ccrz__FirstName__c,ccrz__ShipTo__r.ccrz__LastName__c,ccrz__ShipTo__r.ccrz__City__c,ccrz__ShipTo__r.ccrz__State__c,ccrz__ShipTo__r.ccrz__Country__c,ccrz__ShipTo__r.ccrz__PostalCode__c,ccrz__BuyerFirstName__c,
                        ccrz__BillTo__r.ccrz__AddressFirstline__c,ccrz__BillTo__r.ccrz__AddressSecondline__c,ccrz__BillTo__r.ccrz__AddressThirdline__c,ccrz__BillTo__r.ccrz__FirstName__c,ccrz__BillTo__r.ccrz__LastName__c,
                        ccrz__BillTo__r.ccrz__City__c,ccrz__BillTo__r.ccrz__State__c,ccrz__BillTo__r.ccrz__Country__c,ccrz__BillTo__r.ccrz__PostalCode__c,
                        ccrz__BuyerLastName__c,ccrz__BuyerEmail__c,ccrz__BuyerPhone__c,
                        ccrz__OriginatedCart__r.ccrz__ShipTo__r.ccrz__AddressFirstline__c,
                        ccrz__OriginatedCart__r.ccrz__ShipTo__r.ccrz__AddressSecondline__c,
                        ccrz__OriginatedCart__r.ccrz__ShipTo__r.ccrz__City__c,
                        ccrz__OriginatedCart__r.ccrz__ShipTo__r.ccrz__State__c,
                        ccrz__OriginatedCart__r.ccrz__ShipTo__r.ccrz__Country__c,
                        ccrz__OriginatedCart__r.ccrz__ShipTo__r.ccrz__PostalCode__c
                        from ccrz__E_Order__c where Id =: orderid];
        
        //------------Added by Mukesh Gupta (15-04-2021) for Breaking the tax-------------
      /*  Map<String,Decimal> impositionTaxMap = new Map<String,Decimal>();
        Set<String> orderItemsIds = new Set<String>();
        
        List<ccrz__E_OrderItem__c> orderItemList = [SELECT Id,ccrz__OrderItemStatus__c FROM ccrz__E_OrderItem__c WHERE ccrz__Order__c =: orderid AND ccrz__OrderItemStatus__c = 'Shipped'];
        if(orderItemList.size() > 0){
            for(ccrz__E_OrderItem__c oItemObj : orderItemList){
            orderItemsIds.add(oItemObj.Id);
        }
        }

       List<CC_Tax__c> listCCTaxRecords =  [SELECT Id,ImpositionValue__c,CalculatedTax__c,CC_Order_Item__c FROM CC_Tax__c WHERE CC_Order_Item__c IN : orderItemsIds];
        if(listCCTaxRecords.size() > 0){
            for(CC_Tax__c ccTaxObj : listCCTaxRecords){
                if(impositionTaxMap.containsKey(ccTaxObj.ImpositionValue__c)){
                 Decimal taxValue = Decimal.valueOf(ccTaxObj.CalculatedTax__c) + impositionTaxMap.get(ccTaxObj.ImpositionValue__c);
                    impositionTaxMap.put(ccTaxObj.ImpositionValue__c,taxValue.setScale(2));
                }else{
                    impositionTaxMap.put(ccTaxObj.ImpositionValue__c,Decimal.valueOf(ccTaxObj.CalculatedTax__c).setScale(2));
                }
            }
        }
		System.debug('impositionTaxMap===='+impositionTaxMap);*/

        
        //--------------------------
        String currencyCode = orderDetails.CurrencyIsoCode ;
        system.debug('currencyCode ' + currencyCode);
        String query = 'SELECT id,Name,CreatedDate,(Select id,Name,ccrz__CCOrderItem__r.dbu_isShipTo__c,ccrz__CCOrderItem__r.ccrz__OriginalQuantity__c,ccrz__CCOrderItem__r.dbu_CC_Order_Item__r.ccrz__Order__r.dbu_Days_Since_Order_Date__c,ccrz__CCOrderItem__r.ccrz__Product__r.dbu_Has_Core_Child__c,ccrz__CCOrderItem__r.ccrz__Product__r.dbu_Has_Core_Charge__c,ccrz__Type__c,ccrz__CCOrderItem__c,ccrz__CCOrderItem__r.ccrz__OrderItemStatus__c,ccrz__CCOrderItem__r.dbu_Reason_for_Return__c,ccrz__CCOrderItem__r.dbu_Estimated_Return_Amount__c,ccrz__CCOrderItem__r.ccrz__Product__c,ccrz__CCOrderItem__r.ccrz__Quantity__c,ccrz__CCOrderItem__r.ccrz__AbsoluteDiscount__c,ccrz__CCOrderItem__r.ccrz__Price__c,ccrz__OriginalAmount__c,ccrz__CCOrderItem__r.Vertex_Tax__c,ccrz__CCOrderItem__r.ccrz__Product__r.dbu_Non_Returnable__c,ccrz__CCOrderItem__r.ccrz__Product__r.Name from ccrz__InvoiceItems__r where ccrz__CCOrderItem__c!= NULL AND ccrz__CCOrderItem__r.CurrencyIsoCode =:currencyCode) from ccrz__E_Invoice__c where ccrz__CCOrder__c=:orderid';
        lstOftransantionPayment = [SELECT id,ccrz__AccountNumber__c,ccrz__TransactionType__c from ccrz__E_TransactionPayment__c WHERE ccrz__CCOrder__c =: orderid];
        
        invoiceDetails = Database.query(query);
        //invoiceDetails = [Select id,Name,CreatedDate,(Select id,Name,ccrz__CCOrderItem__r.ccrz__OriginalQuantity__c,ccrz__CCOrderItem__r.dbu_CC_Order_Item__r.ccrz__Order__r.dbu_Days_Since_Order_Date__c,ccrz__CCOrderItem__r.ccrz__Product__r.dbu_Has_Core_Child__c,ccrz__CCOrderItem__r.ccrz__Product__r.dbu_Has_Core_Charge__c,ccrz__Type__c,ccrz__CCOrderItem__c,ccrz__CCOrderItem__r.ccrz__OrderItemStatus__c,ccrz__CCOrderItem__r.dbu_Reason_for_Return__c,ccrz__CCOrderItem__r.dbu_Estimated_Return_Amount__c,ccrz__CCOrderItem__r.ccrz__Product__c,ccrz__CCOrderItem__r.ccrz__Quantity__c,ccrz__CCOrderItem__r.ccrz__AbsoluteDiscount__c,ccrz__CCOrderItem__r.ccrz__Price__c,ccrz__OriginalAmount__c,ccrz__CCOrderItem__r.Vertex_Tax__c,ccrz__CCOrderItem__r.ccrz__Product__r.dbu_Non_Returnable__c,ccrz__CCOrderItem__r.ccrz__Product__r.Name from ccrz__InvoiceItems__r where ccrz__CCOrderItem__c!= NULL AND ccrz__CCOrderItem__r.CurrencyIsoCode = 'USD') from ccrz__E_Invoice__c where ccrz__CCOrder__c=:orderid];
        orderDetailsObj.orderDate = orderDetails.ccrz__OrderDate__c;
        orderDetailsObj.orderNumber = orderDetails.Name;
        orderDetailsObj.orderId = orderDetails.id;
        orderDetailsObj.orderCurrency = orderDetails.CurrencyIsoCode;
        /***************** CECI-207, Added by Harish, check if logged in user is accessing the details**************/
        if(orderDetails.ccrz__User__c == userinfo.getUserId()){
            orderDetailsObj.isOrderAccesible=true;
        }
        else{
            orderDetailsObj.isOrderAccesible=false;
        }
        
        if(!lstOftransantionPayment.isEmpty()){
            System.debug('========='+ lstOftransantionPayment[0].ccrz__TransactionType__c+''+lstOftransantionPayment[0].ccrz__AccountNumber__c);
            if(lstOftransantionPayment[0].ccrz__TransactionType__c == 'PayPal' && lstOftransantionPayment[0].ccrz__AccountNumber__c != null && lstOftransantionPayment[0].ccrz__AccountNumber__c != ''){
                String accNumber = lstOftransantionPayment[0].ccrz__AccountNumber__c;
                String lstFourCharOfAccNumber =  lstOftransantionPayment[0].ccrz__AccountNumber__c.right(4);
                for(Integer i = 0;i<accNumber.length()-4;i++){
                    lstFourCharOfAccNumber = 'x'+lstFourCharOfAccNumber ;
                }
                accNumber = lstFourCharOfAccNumber;   
                orderDetailsObj.paymentType = lstOftransantionPayment[0].ccrz__TransactionType__c+' '+accNumber ;
            }else{
                orderDetailsObj.paymentType = lstOftransantionPayment[0].ccrz__TransactionType__c+' '+lstOftransantionPayment[0].ccrz__AccountNumber__c;
            }
        } 
        
        // orderDetailsObj.paymentType = '';
        orderDetailsObj.emailID = orderDetails.ccrz__BuyerEmail__c;
        orderDetailsObj.phone = orderDetails.ccrz__BuyerPhone__c;
        orderDetailsObj.name = orderDetails.ccrz__BuyerFirstName__c;
        orderDetailsObj.lastName = orderDetails.ccrz__BuyerLastName__c;
        if(orderDetails.ccrz__TotalAmount__c != NULL){
            orderDetailsObj.totalAmount = orderDetails.ccrz__TotalAmount__c.setScale(2);
        }
        if(orderDetails.ccrz__SubtotalAmount__c != NULL){
            orderDetailsObj.subTotalAmount = orderDetails.ccrz__SubtotalAmount__c.setScale(2);
        }
        
        if(orderDetails.ccrz__TotalDiscount__c != NULL){
            orderDetailsObj.discountAmount = orderDetails.ccrz__TotalDiscount__c.setScale(2);
        }
        if(orderDetails.ccrz__TaxAmount__c != NULL){
            orderDetailsObj.estimatedTax = orderDetails.ccrz__TaxAmount__c.setScale(2);
          //  orderDetailsObj.taxMap = impositionTaxMap ;
        }
        if(orderDetails.ccrz__ShipAmount__c != NULL){
            orderDetailsObj.shippingCost = orderDetails.ccrz__ShipAmount__c.setScale(2);
        }
        dbu_WrapperInvoiceDetails.ShipToAddress shipAddress = new dbu_WrapperInvoiceDetails.ShipToAddress();
       // dbu_WrapperInvoiceDetails.StorePickupAddress storePickupAddress = new dbu_WrapperInvoiceDetails.StorePickupAddress();
        
        System.debug('IsShipTOAddress========='+orderDetails.ccrz__OriginatedCart__r.ccrz__ShipTo__c);
        System.debug('IsPickupAddress========='+orderDetails.ccrz__OriginatedCart__r.dbu_Pick_Up_From_Store__c);
        //if(orderDetails.ccrz__ShipMethod__c == 'Pick Up' || orderDetails.ccrz__ShipMethod__c == 'Ramassage'){ 
        if(orderDetails.ccrz__OriginatedCart__r.ccrz__ShipTo__r != null){
           
            orderDetailsObj.isPickUpAddress = false;
            shipAddress.firstName = orderDetails.ccrz__BuyerFirstName__c;
            shipAddress.lastName = orderDetails.ccrz__BuyerLastName__c;
            shipAddress.address1 = orderDetails.ccrz__OriginatedCart__r.ccrz__ShipTo__r.ccrz__AddressFirstline__c;
            shipAddress.address2 = orderDetails.ccrz__OriginatedCart__r.ccrz__ShipTo__r.ccrz__AddressSecondline__c;
            shipAddress.city = orderDetails.ccrz__OriginatedCart__r.ccrz__ShipTo__r.ccrz__City__c;
            shipAddress.state = orderDetails.ccrz__OriginatedCart__r.ccrz__ShipTo__r.ccrz__State__c;
            String countryName = orderDetails.ccrz__OriginatedCart__r.ccrz__ShipTo__r.ccrz__Country__c;
            if(countryName.equalsIgnoreCase('US') || countryName.equalsIgnoreCase('United States') || countryName.equalsIgnoreCase('U.S.A') || countryName.equalsIgnoreCase('U.S.A.') || countryName.equalsIgnoreCase('USA')){
                shipAddress.country = 'U.S.A.';
            }else if(countryName.equalsIgnoreCase('CA') || countryName.equalsIgnoreCase('Canada')){
                 shipAddress.country = 'Canada';
            }else{
                shipAddress.country = orderDetails.ccrz__OriginatedCart__r.ccrz__ShipTo__r.ccrz__Country__c;
            }
            //shipAddress.country = orderDetails.ccrz__ShipTo__r.ccrz__Country__c;
            shipAddress.postalCode = orderDetails.ccrz__OriginatedCart__r.ccrz__ShipTo__r.ccrz__PostalCode__c;
            orderDetailsObj.shipAddress = shipAddress;
            System.debug('shipAddress===='+shipAddress);
        }
        else if(orderDetails.ccrz__OriginatedCart__r.dbu_Pick_Up_From_Store__c != null){  // ================inventory Changes==========
            List<ccrz__E_Cart__c> pickUpAddress = [select id, dbu_Pick_Up_From_Store__r.ccrz__AddressFirstline__c, dbu_Pick_Up_From_Store__r.ccrz__AddressSecondline__c,dbu_Pick_Up_From_Store__r.ccrz__City__c,dbu_Pick_Up_From_Store__r.ccrz__State__c,dbu_Pick_Up_From_Store__r.ccrz__Country__c,dbu_Pick_Up_From_Store__r.ccrz__PostalCode__c from ccrz__E_Cart__c where id =: orderDetails.ccrz__OriginatedCart__c];
            
            orderDetailsObj.isPickUpAddress = true;
            shipAddress.firstName = orderDetails.ccrz__BuyerFirstName__c;
            shipAddress.lastName = orderDetails.ccrz__BuyerLastName__c;
            shipAddress.address1 = pickUpAddress[0].dbu_Pick_Up_From_Store__r.ccrz__AddressFirstline__c;
            shipAddress.address2 = pickUpAddress[0].dbu_Pick_Up_From_Store__r.ccrz__AddressSecondline__c;
            shipAddress.city = pickUpAddress[0].dbu_Pick_Up_From_Store__r.ccrz__City__c;
            shipAddress.state = pickUpAddress[0].dbu_Pick_Up_From_Store__r.ccrz__State__c;
            String countryName = pickUpAddress[0].dbu_Pick_Up_From_Store__r.ccrz__Country__c;
            if(countryName.equalsIgnoreCase('US') || countryName.equalsIgnoreCase('United States') || countryName.equalsIgnoreCase('U.S.A') || countryName.equalsIgnoreCase('U.S.A.') || countryName.equalsIgnoreCase('USA')){
                shipAddress.country = 'U.S.A.';
            }else if(countryName.equalsIgnoreCase('CA') || countryName.equalsIgnoreCase('Canada')){
                 shipAddress.country = 'Canada';
            }else{
                shipAddress.country = pickUpAddress[0].dbu_Pick_Up_From_Store__r.ccrz__Country__c;
            }
            //shipAddress.country = pickUpAddress[0].dbu_Pick_Up_From_Store__r.ccrz__Country__c;
            shipAddress.postalCode = pickUpAddress[0].dbu_Pick_Up_From_Store__r.ccrz__PostalCode__c;
            orderDetailsObj.shipAddress = shipAddress;
        }
       
        
        dbu_WrapperInvoiceDetails.BillToAddress billAddress = new dbu_WrapperInvoiceDetails.BillToAddress();
        billAddress.firstName = orderDetails.ccrz__BuyerFirstName__c;
        billAddress.lastName = orderDetails.ccrz__BuyerLastName__c;
        //billAddress.firstName = orderDetails.ccrz__BillTo__r.ccrz__FirstName__c;
        //billAddress.lastName = orderDetails.ccrz__BillTo__r.ccrz__LastName__c;
        billAddress.address1 = orderDetails.ccrz__BillTo__r.ccrz__AddressFirstline__c;
        billAddress.address2 = orderDetails.ccrz__BillTo__r.ccrz__AddressSecondline__c;
        //billAddress.address3 = orderDetails.ccrz__BillTo__r.ccrz__AddressThirdline__c;
        billAddress.city = orderDetails.ccrz__BillTo__r.ccrz__City__c;
        billAddress.state = orderDetails.ccrz__BillTo__r.ccrz__State__c;
        String billingCountryName = orderDetails.ccrz__BillTo__r.ccrz__Country__c;
		if(billingCountryName.equalsIgnoreCase('US') || billingCountryName.equalsIgnoreCase('United States') || billingCountryName.equalsIgnoreCase('U.S.A') || billingCountryName.equalsIgnoreCase('U.S.A.') || billingCountryName.equalsIgnoreCase('USA')){
            billAddress.country = 'U.S.A.';
         }else if(billingCountryName.equalsIgnoreCase('CA') || billingCountryName.equalsIgnoreCase('Canada')){
            billAddress.country = 'Canada';
         }else{
            billAddress.country = orderDetails.ccrz__BillTo__r.ccrz__Country__c;
         }        
        //billAddress.country = orderDetails.ccrz__BillTo__r.ccrz__Country__c;
        billAddress.postalCode = orderDetails.ccrz__BillTo__r.ccrz__PostalCode__c;
        orderDetailsObj.billAddress = billAddress;
        
        for (ccrz__E_Invoice__c invoiceDeta: invoiceDetails) {
            if (invoiceDeta.ccrz__InvoiceItems__r != null) {
                mapInvoiceItemList.put(invoiceDeta.id, invoiceDeta.ccrz__InvoiceItems__r);
            }
        }
        
        //----------------Added by Mukesh-------------------------
        Set<String> orgReturnOrderLineItemIds = new  Set<String>(); // added by Mukesh - to store org return order line item ids
        Map<String,String> invoiceLineItemAgainstCloneOrder = new Map<String,String>();
         for (ccrz__E_Invoice__c invoiceDetil: invoiceDetails) {
            for(ccrz__E_InvoiceItem__c invItem: mapInvoiceItemList.get(invoiceDetil.id)){
                 if(invItem.ccrz__CCOrderItem__r.ccrz__OrderItemStatus__c == 'Return Initiated' || invItem.ccrz__CCOrderItem__r.ccrz__OrderItemStatus__c == 'Return Approved'){
                orgReturnOrderLineItemIds.add(invItem.ccrz__CCOrderItem__c);
                 }
            }
         }
        System.debug('orgReturnOrderLineItemIds===='+orgReturnOrderLineItemIds.size());
        Set<String> cloneOrderIds = new Set<String>();
        if(orgReturnOrderLineItemIds.size() > 0){
            List<ccrz__E_OrderItem__c> cloneOrderLineItems =  [SELECT Id,ccrz__Order__r.Name,ccrz__Order__c,dbu_CC_Order_Item__c FROM ccrz__E_OrderItem__c WHERE dbu_CC_Order_Item__c IN : orgReturnOrderLineItemIds];
            for(ccrz__E_OrderItem__c cloneOrderItem : cloneOrderLineItems){
                invoiceLineItemAgainstCloneOrder.put(cloneOrderItem.dbu_CC_Order_Item__c,cloneOrderItem.ccrz__Order__r.Name);
                cloneOrderIds.add(cloneOrderItem.ccrz__Order__c);
            }
        }
        System.debug('invoiceLineItemAgainstCloneOrder======'+invoiceLineItemAgainstCloneOrder);
        //-------------------------------
        for (ccrz__E_Invoice__c invoiceDetil: invoiceDetails) {
            for(ccrz__E_InvoiceItem__c invItem: mapInvoiceItemList.get(invoiceDetil.id)){
                listProdIds.add(invItem.ccrz__CCOrderItem__r.ccrz__Product__c);
                
            }
            dbu_WrapperInvoiceDetails.InvoiceDetailsData  invoiceDetailsData = new dbu_WrapperInvoiceDetails.InvoiceDetailsData();
            List<dbu_WrapperInvoiceDetails.InvoiceLines> linesList = new List<dbu_WrapperInvoiceDetails.InvoiceLines>();
            
            Map<String,String> productImg = new Map<String,String>();
            if(!Test.isRunningTest())
                productImg = dbu_ccApiRelatedProduct.getProducts(listProdIds);
            for(ccrz__E_InvoiceItem__c invItem: mapInvoiceItemList.get(invoiceDetil.id)){
                if(invItem.ccrz__Type__c != 'Tax'){
                    dbu_WrapperInvoiceDetails.InvoiceLines lines = new dbu_WrapperInvoiceDetails.InvoiceLines();
                    if(productImg != NULL){
                        if(productImg.containsKey(invItem.ccrz__CCOrderItem__r.ccrz__Product__c)){
                            lines.proImage = productImg.get(invItem.ccrz__CCOrderItem__r.ccrz__Product__c);
                        }
                    }else{
                        lines.proImage = Null;
                    }
                    //Added by Mukesh --27-Sep for Inventory Change=====
                    lines.isShipTo = invItem.ccrz__CCOrderItem__r.dbu_isShipTo__c;
                    //================================================
                    lines.hasCoreCharge = invItem.ccrz__CCOrderItem__r.ccrz__Product__r.dbu_Has_Core_Charge__c;
                    lines.hasCoreChild = invItem.ccrz__CCOrderItem__r.ccrz__Product__r.dbu_Has_Core_Child__c;
                    lines.lineItemName = invItem.Name;
                    lines.quantity = Integer.ValueOf(invItem.ccrz__CCOrderItem__r.ccrz__Quantity__c);
                    
                    if(invItem.ccrz__CCOrderItem__r.Vertex_Tax__c != NULL){
                        lines.taxAmount =invItem.ccrz__CCOrderItem__r.Vertex_Tax__c.setScale(2);
                    }
                    if(invItem.ccrz__OriginalAmount__c != NULL){
                        lines.price = invItem.ccrz__OriginalAmount__c.setScale(2);
                    }
                    lines.returnableOrNot = invItem.ccrz__CCOrderItem__r.ccrz__Product__r.dbu_Non_Returnable__c;
                    lines.productName = invItem.ccrz__CCOrderItem__r.ccrz__Product__r.Name;
                    lines.Id = invItem.ccrz__CCOrderItem__r.ccrz__Product__c;
                    if(invItem.ccrz__CCOrderItem__r.ccrz__Price__c != NULL){
                        lines.unitPrice = invItem.ccrz__CCOrderItem__r.ccrz__Price__c.setScale(2);
                    }
                    if(invItem.ccrz__CCOrderItem__r.ccrz__AbsoluteDiscount__c != NULL){
                        lines.unitDiscountedPrice=invItem.ccrz__CCOrderItem__r.ccrz__AbsoluteDiscount__c.setScale(2);
                    }else
                    
                    lines.reasonOfReturn=invItem.ccrz__CCOrderItem__r.dbu_Reason_for_Return__c;
                    if(invItem.ccrz__CCOrderItem__r.dbu_Estimated_Return_Amount__c != NULL){
                        lines.refundAmount = invItem.ccrz__CCOrderItem__r.dbu_Estimated_Return_Amount__c.setScale(2);
                    }
                    
                    if(invItem.ccrz__CCOrderItem__r.ccrz__OrderItemStatus__c == 'Return Initiated' || invItem.ccrz__CCOrderItem__r.ccrz__OrderItemStatus__c == 'Return Approved'){
                        lines.daysSinceOrderDate = Integer.ValueOf(invItem.ccrz__CCOrderItem__r.dbu_CC_Order_Item__r.ccrz__Order__r.dbu_Days_Since_Order_Date__c);
                        lines.originalQty = invItem.ccrz__CCOrderItem__r.ccrz__OriginalQuantity__c;
                        lines.returnedOrNot = true;
                        System.debug('=====isContains===='+invoiceLineItemAgainstCloneOrder.containsKey(invItem.ccrz__CCOrderItem__c));
                        if(invoiceLineItemAgainstCloneOrder.containsKey(invItem.ccrz__CCOrderItem__c)){
                            lines.cloneOrderId = invoiceLineItemAgainstCloneOrder.get(invItem.ccrz__CCOrderItem__c);
                        }
                    }else{
                        lines.returnedOrNot = false;
                    }
                    linesList.add(lines);
                }
            }
            DateTime invoiceDateTime = invoiceDetil.CreatedDate;
            Date invoiceCreatedDate= date.newinstance(invoiceDateTime .year(), invoiceDateTime .month(), invoiceDateTime .day());
            invoiceDetailsData.invoiceDate = invoiceCreatedDate;
            invoiceDetailsData.invoiceNumber = invoiceDetil.Name;
            invoiceDetailsData.dateinfo = system.today();
            invoiceDetailsData.invoiceLineItem = linesList;
            
            listInvoiceDetails.add(invoiceDetailsData);
        }    
       //---------------------
       
	/*	Map<String,Map<String,Decimal>> taxAgainstCloneOrder = new Map<String,Map<String,Decimal>>();
        Map<String,Decimal> localMap = new Map<String,Decimal>();
       Set<String> cloneOrderItemsIds = new Set<String>();
        List<CC_Tax__c> cloneLineItemCCTaxRecords = new List<CC_Tax__c>();
        if(cloneOrderIds.size() > 0){
            
        
         List<ccrz__E_OrderItem__c> cloneOrderItemList = [SELECT Id,ccrz__OrderItemStatus__c FROM ccrz__E_OrderItem__c WHERE ccrz__Order__c IN: cloneOrderIds ];
        if(cloneOrderItemList.size() > 0){
            for(ccrz__E_OrderItem__c oItemObj : cloneOrderItemList){
            cloneOrderItemsIds.add(oItemObj.Id);
        }
        }

        cloneLineItemCCTaxRecords =  [SELECT Id,ImpositionValue__c,CalculatedTax__c,CC_Order_Item__c,CC_Order_Item__r.ccrz__Order__r.Name FROM CC_Tax__c WHERE CC_Order_Item__c IN : cloneOrderItemsIds];
        }
            if(cloneLineItemCCTaxRecords.size() > 0){
            for(CC_Tax__c cloneTaxObj : cloneLineItemCCTaxRecords){
                if(taxAgainstCloneOrder.containsKey(cloneTaxObj.CC_Order_Item__r.ccrz__Order__r.Name)){
                    localMap = taxAgainstCloneOrder.get(cloneTaxObj.CC_Order_Item__r.ccrz__Order__r.Name);
                    if(localMap.containsKey(cloneTaxObj.ImpositionValue__c)){
                         Decimal taxValue = Decimal.valueOf(cloneTaxObj.CalculatedTax__c) + localMap.get(cloneTaxObj.ImpositionValue__c);
                        localMap.put(cloneTaxObj.ImpositionValue__c,taxValue.setScale(2));
                    }else{
                        localMap.put(cloneTaxObj.ImpositionValue__c,Decimal.valueOf(cloneTaxObj.CalculatedTax__c).setScale(2));
                    }
                     taxAgainstCloneOrder.put(cloneTaxObj.CC_Order_Item__r.ccrz__Order__r.Name,localMap);
                }else{
                    Map<String,Decimal> innerMap = new Map<String,Decimal>();
                    innerMap.put(cloneTaxObj.ImpositionValue__c,Decimal.valueOf(cloneTaxObj.CalculatedTax__c).setScale(2));
                    taxAgainstCloneOrder.put(cloneTaxObj.CC_Order_Item__r.ccrz__Order__r.Name,innerMap);
                    
                }
            }
        }
        System.debug('taxAgainstCloneOrder======'+taxAgainstCloneOrder);*/
       //----------------------
     //  orderDetailsObj.taxAgainstCloneOrderName = taxAgainstCloneOrder;
       orderDetailsObj.invoiceDetails = listInvoiceDetails;
        return orderDetailsObj;
    }
    
}
//}