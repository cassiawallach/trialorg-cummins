public without sharing class dbu_ViewReturnInvoiceDetails {
    
    @AuraEnabled(cacheable=true)
    public static List<dbu_WrapperInvoiceDetails> viewReturnInvoiceData(String urlParam){
        System.debug('====Method Called===');
        String orderid;
        // List<String> listProdIds = new List<String>();
        if(String.isNotBlank(urlParam)){
            ApexPages.PageReference ref = new ApexPages.PageReference(urlParam);
            Map<String, String> params = ref.getParameters();
            if(params.size() > 0 && params.containsKey('orderid')){
                orderid =  params.get('orderid');
            }
        } 
        System.debug('orderid===='+orderid);
        List<ccrz__E_Order__c> cloneOrdersList = new List<ccrz__E_Order__c>();
        Set<String> cloneOrderIds = new Set<String>();
        //Fetching cloneOrders
        cloneOrdersList = [SELECT id,CreatedDate,CC_Order__r.dbu_Days_Since_Order_Date__c,ccrz__OrderDate__c,ccrz__ShipMethod__c,ccrz__OriginatedCart__c,CurrencyIsoCode ,ccrz__SubtotalAmount__c,ccrz__TotalDiscount__c,ccrz__TaxAmount__c,ccrz__ShipAmount__c,ccrz__TotalAmount__c, Name, ccrz__PaymentMethod__c,ccrz__ShipTo__r.ccrz__AddressFirstline__c,ccrz__ShipTo__r.ccrz__AddressSecondline__c,ccrz__ShipTo__r.ccrz__AddressThirdline__c,ccrz__ShipTo__r.ccrz__FirstName__c,ccrz__ShipTo__r.ccrz__LastName__c,ccrz__ShipTo__r.ccrz__City__c,ccrz__ShipTo__r.ccrz__State__c,ccrz__ShipTo__r.ccrz__Country__c,ccrz__ShipTo__r.ccrz__PostalCode__c,ccrz__BuyerFirstName__c,
                           ccrz__BillTo__r.ccrz__AddressFirstline__c,ccrz__BillTo__r.ccrz__AddressSecondline__c,ccrz__BillTo__r.ccrz__AddressThirdline__c,ccrz__BillTo__r.ccrz__FirstName__c,ccrz__BillTo__r.ccrz__LastName__c,
                           ccrz__BillTo__r.ccrz__City__c,ccrz__BillTo__r.ccrz__State__c,ccrz__BillTo__r.ccrz__Country__c,ccrz__BillTo__r.ccrz__PostalCode__c,
                           ccrz__BuyerLastName__c,ccrz__BuyerEmail__c,ccrz__BuyerPhone__c FROM ccrz__E_Order__c WHERE CC_Order__c =: orderid];
        
        // Map to store cloneOrders against cloneOrder Id
        Map<String,ccrz__E_Order__c> cloneOrderMap = new Map<String,ccrz__E_Order__c>(); 
        if(!cloneOrdersList.isEmpty()){
            for(ccrz__E_Order__c obj : cloneOrdersList){
                cloneOrderIds.add(obj.Id);
                cloneOrderMap.put(obj.Id,obj);
            } 
        }
        
        //Fetching invoice line items associated to cloneOrders
        Map<String,List<ccrz__E_InvoiceItem__c>> invLineItemListAgainstCloneOrder = new  Map<String,List<ccrz__E_InvoiceItem__c>>();
        String currencyCode = cloneOrdersList[0].CurrencyIsoCode ;
        String currencySign;
        if(currencyCode == 'USD'){
            currencySign = ' $';
        }else if(currencyCode == 'CAD'){
            currencySign = 'CAD $';
        }
        List<ccrz__E_InvoiceItem__c> invLineItemList = new List<ccrz__E_InvoiceItem__c>();
        List<String> listProdIds = new List<String>();
        invLineItemList = [SELECT Id,CreatedDate,ccrz__CCOrderItem__r.ccrz__OriginalQuantity__c,Name,ccrz__CCOrderItem__r.dbu_CC_Order_Item__r.ccrz__Order__r.dbu_Days_Since_Order_Date__c,ccrz__CCOrderItem__r.dbu_Estimated_Return_Amount__c,ccrz__CCOrderItem__r.ccrz__OrderItemStatus__c,ccrz__CCOrderItem__r.dbu_Reason_for_Return__c,ccrz__CCOrderItem__r.ccrz__AbsoluteDiscount__c,ccrz__CCOrderItem__r.ccrz__Price__c,ccrz__CCOrderItem__r.ccrz__Product__r.Name,ccrz__CCOrderItem__r.ccrz__Product__r.dbu_Non_Returnable__c,ccrz__CCOrderItem__r.Vertex_Tax__c,ccrz__OriginalAmount__c,ccrz__CCOrderItem__r.ccrz__Quantity__c,ccrz__CCOrderItem__r.ccrz__Product__r.dbu_Has_Core_Child__c,ccrz__CCOrderItem__r.ccrz__Product__r.dbu_Has_Core_Charge__c,ccrz__CCOrder__c,ccrz__CCOrderItem__c,ccrz__Type__c,ccrz__CCOrderItem__r.ccrz__Product__c FROM ccrz__E_InvoiceItem__c WHERE ccrz__CCOrder__c IN: cloneOrderIds];
        System.debug('invLineItemList==='+invLineItemList.size());
        //constructing invoicelineItems against cloneOrderId
        if(!invLineItemList.isEmpty()){
            for(ccrz__E_InvoiceItem__c invItemObj : invLineItemList ){
                listProdIds.add(invItemObj.ccrz__CCOrderItem__r.ccrz__Product__c);
                if(invLineItemListAgainstCloneOrder.containsKey(invItemObj.ccrz__CCOrder__c)) {
                    List<ccrz__E_InvoiceItem__c> invItem = invLineItemListAgainstCloneOrder.get(invItemObj.ccrz__CCOrder__c);
                    invItem.add(invItemObj);
                    invLineItemListAgainstCloneOrder.put(invItemObj.ccrz__CCOrder__c, invItem);
                } else {
                    invLineItemListAgainstCloneOrder.put(invItemObj.ccrz__CCOrder__c, new List<ccrz__E_InvoiceItem__c> { invItemObj });
                }
            }
        }
        System.debug('invLineItemListAgainstCloneOrder===='+invLineItemListAgainstCloneOrder);
        Map<String,String> productImg = new Map<String,String>();
        productImg = dbu_ccApiRelatedProduct.getProducts(listProdIds);
        //------------------
        List<dbu_WrapperInvoiceDetails> wrapperOrderObjList = new List<dbu_WrapperInvoiceDetails>();
        
        //Custom Labels------
        
        String reasonOrderedWronPart_FR = System.Label.dbu_OrderedTheWrongPart_Pdf_FR;
        String reasonPartNoLongerWanted_FR = System.Label.dbu_reason_partNoLongerWanted_Pdf_FR;    
        String reasonOrderedWronPart = System.Label.dbu_Return_Ordered_the_wrong_part;
        String reasonPartNoLongerWanted = System.Label.dbu_Return_Part_no_longer_wanted;
        
        //------------------
        System.debug('cloneOrdersList====='+cloneOrdersList.size());
        //---Iterating on clone order list-----
        for(ccrz__E_Order__c orderObj : cloneOrdersList){
            dbu_WrapperInvoiceDetails wrapperOrderObj = new dbu_WrapperInvoiceDetails();
            wrapperOrderObj.orderNumber = orderObj.name;
            wrapperOrderObj.dateinfoReturn = (orderObj.CreatedDate).format('MMMM dd, yyyy');
            wrapperOrderObj.orderId = orderObj.Id;
            
            Integer daysSinceOrderDays = Integer.valueOf(orderObj.CC_Order__r.dbu_Days_Since_Order_Date__c);
            Decimal prodCostAmount = 0.00;
            Decimal handlingFees = 0.00;
            Decimal totalAmount = 0.00;
            if(invLineItemListAgainstCloneOrder.containsKey(orderObj.Id)){
                List<dbu_WrapperInvoiceDetails.InvoiceLines>  invLineList = new List<dbu_WrapperInvoiceDetails.InvoiceLines>();
                
                //---Iterating on invoice line item list against to clone order-----
                for(ccrz__E_InvoiceItem__c invLineObj : invLineItemListAgainstCloneOrder.get(orderObj.Id)){
                    System.debug('Inner loop');
                    if(invLineObj.ccrz__Type__c != 'Tax'){
                        dbu_WrapperInvoiceDetails.InvoiceLines  invLine = new dbu_WrapperInvoiceDetails.InvoiceLines();
                        if(productImg != NULL){
                            if(productImg.containsKey(invLineObj.ccrz__CCOrderItem__r.ccrz__Product__c)){
                                invLine.proImage = productImg.get(invLineObj.ccrz__CCOrderItem__r.ccrz__Product__c);
                            }
                        }else{
                            invLine.proImage = Null;
                        }
                        invLine.Id = invLineObj.Id;
                        
                        invLine.invoiceLineItemDate = (invLineObj.CreatedDate).format('MMMM dd, yyyy');
                        invLine.hasCoreCharge = invLineObj.ccrz__CCOrderItem__r.ccrz__Product__r.dbu_Has_Core_Charge__c;
                        invLine.hasCoreChild = invLineObj.ccrz__CCOrderItem__r.ccrz__Product__r.dbu_Has_Core_Child__c;
                        if(invLine.hasCoreCharge == true && invLine.hasCoreChild){
                            invLine.coreCharge = true;
                        }
                        if(daysSinceOrderDays > 45 && invLine.hasCoreCharge == true && invLine.hasCoreChild){
                            invLine.coreChargeHandlingFee = true;
                        }
                        invLine.lineItemName = invLineObj.Name;
                        invLine.quantity = Integer.ValueOf(invLineObj.ccrz__CCOrderItem__r.ccrz__Quantity__c);
                        if(invLineObj.ccrz__CCOrderItem__r.Vertex_Tax__c != NULL){
                            invLine.taxAmountReturn = currencySign + (invLineObj.ccrz__CCOrderItem__r.Vertex_Tax__c / invLineObj.ccrz__CCOrderItem__r.ccrz__OriginalQuantity__c).setScale(2);
                        }else{
                            invLine.taxAmountReturn = currencySign + '0.00';
                        }
                        if(invLineObj.ccrz__OriginalAmount__c != NULL){
                            invLine.priceReturn = currencySign + invLineObj.ccrz__OriginalAmount__c.setScale(2);
                        }else{
                            invLine.priceReturn = currencySign + '0.00';
                        }
                        invLine.returnableOrNot = invLineObj.ccrz__CCOrderItem__r.ccrz__Product__r.dbu_Non_Returnable__c;
                        invLine.productName = invLineObj.ccrz__CCOrderItem__r.ccrz__Product__r.Name;
                        
                        if(invLineObj.ccrz__CCOrderItem__r.ccrz__Price__c != NULL){
                            prodCostAmount = prodCostAmount + (invLineObj.ccrz__CCOrderItem__r.ccrz__Price__c * invLineObj.ccrz__CCOrderItem__r.ccrz__Quantity__c);
                            invLine.unitPriceReturn = currencySign + invLineObj.ccrz__CCOrderItem__r.ccrz__Price__c.setScale(2);
                        }else{
                            invLine.unitPriceReturn = currencySign + '0.00';
                        }
                        if(invLineObj.ccrz__CCOrderItem__r.ccrz__AbsoluteDiscount__c != NULL){
                            invLine.unitDiscountedPriceReturn = currencySign + invLineObj.ccrz__CCOrderItem__r.ccrz__AbsoluteDiscount__c.setScale(2);
                        }else{
                            invLine.unitDiscountedPriceReturn = currencySign + '0.00';
                        }
                        
                        invLine.reasonOfReturn=invLineObj.ccrz__CCOrderItem__r.dbu_Reason_for_Return__c;
                        
                        
                        if(invLineObj.ccrz__CCOrderItem__r.dbu_Reason_for_Return__c == reasonPartNoLongerWanted || invLineObj.ccrz__CCOrderItem__r.dbu_Reason_for_Return__c == reasonOrderedWronPart || invLineObj.ccrz__CCOrderItem__r.dbu_Reason_for_Return__c == reasonPartNoLongerWanted_FR || invLineObj.ccrz__CCOrderItem__r.dbu_Reason_for_Return__c == reasonOrderedWronPart_FR){
                            handlingFees = handlingFees + (invLineObj.ccrz__CCOrderItem__r.ccrz__Price__c * invLineObj.ccrz__CCOrderItem__r.ccrz__Quantity__c)*15/100;
                            invLine.isHandlingFee = true;
                        }
                        
                        if(invLineObj.ccrz__CCOrderItem__r.dbu_Estimated_Return_Amount__c != NULL){
                            invLine.refundAmountReturn = currencySign + invLineObj.ccrz__CCOrderItem__r.dbu_Estimated_Return_Amount__c.setScale(2);
                        }else{
                            invLine.refundAmountReturn = currencySign + '0.00';
                        }
                        
                        totalAmount = totalAmount + invLineObj.ccrz__CCOrderItem__r.dbu_Estimated_Return_Amount__c;
                        
                        if(invLineObj.ccrz__CCOrderItem__r.ccrz__OrderItemStatus__c == 'Return Initiated' || invLineObj.ccrz__CCOrderItem__r.ccrz__OrderItemStatus__c == 'Return Approved'){
                            invLine.daysSinceOrderDate = Integer.ValueOf(invLineObj.ccrz__CCOrderItem__r.dbu_CC_Order_Item__r.ccrz__Order__r.dbu_Days_Since_Order_Date__c);
                            invLine.originalQty = invLineObj.ccrz__CCOrderItem__r.ccrz__OriginalQuantity__c;
                            invLine.returnedOrNot = true;
                            
                        }else{
                            invLine.returnedOrNot = false;
                        }
                        invLineList.add(invLine);
                    }
                    
                }
                wrapperOrderObj.subTotalAmountReturn = currencySign + (prodCostAmount - handlingFees).setScale(2);
                if(currencyCode == 'USD'){
                    wrapperOrderObj.totalRefund = currencyCode + currencySign + totalAmount.setScale(2);
                }else{
                    wrapperOrderObj.totalRefund = currencySign + totalAmount.setScale(2);
                }
                
                wrapperOrderObj.handlingFeesReturn = currencySign + handlingFees.setScale(2);
                wrapperOrderObj.productCost = currencySign + prodCostAmount.setScale(2);
                wrapperOrderObj.invoiceLineItems = invLineList;
            }
            
            wrapperOrderObjList.add(wrapperOrderObj);
        }
        
        System.debug('wrapperOrderObjList==='+wrapperOrderObjList);
        if(!wrapperOrderObjList.isEmpty()){
            return wrapperOrderObjList;
        }else{
            return null;
        }
        
    }
}