public without sharing class Dbu_Download_Invoice_wrapper_Ctrl {
    public String orderId{get;set;}
    //public List<InvoiceWrpr> lstInvoiceWrpr{get;set;}
    public InvoiceWrpr lstInvoiceWrpr{get;set;}
     public InvoiceWrpr lstInvoiceWrprPickup{get;set;}
    public String StoreLanguage{get;set;}
    public InvoiceWrpr1 lstInvoiceWrpr1{get;set;}
    public List<orderWrapper> lstOrderWrpr{get;set;}
    public Boolean isReturn{get;set;}
    public Boolean isStorePickup{get;set;}
    public String pageURL{get;set;}
    public static List<dbu_WrapperInvoiceDetails> InvoiceDetailsWrapper{get;set;}
    public static List<TaxSummery> CurrentOrderTaxList{get;set;}
    public static List<TaxSummery> taxSummarydetails{get;set;}
    public static boolean TaxReturnOrdersFlag {get; set;}
    public static boolean TaxNormalOrdersFlag {get; set;}
    
    public Dbu_Download_Invoice_wrapper_Ctrl()
    {
        orderId =  ApexPages.currentPage().getParameters().get('orderId');
        TaxNormalOrdersFlag = false;
        getTaxDetails(orderId);
        //orderId =  'a2V19000001QgNlEAK';
        ccrz__E_Order__c orderDetails = new ccrz__E_Order__c();
        List<ccrz__E_TransactionPayment__c> lstOftransantionPayment = new List<ccrz__E_TransactionPayment__c>();
        List<String> listProdIds = new List<String>();
        Map < String, List < ccrz__E_InvoiceItem__c >> mapInvoiceItemList = new Map < String, List < ccrz__E_InvoiceItem__c >> ();
        List<ccrz__E_Invoice__c> invoiceDetails = New List<ccrz__E_Invoice__c>();
        orderDetails = [SELECT id,ccrz__OrderDate__c,ccrz__SubtotalAmount__c,ccrz__TotalDiscount__c,ccrz__TaxAmount__c,ccrz__ShipAmount__c,ccrz__TotalAmount__c, Name, ccrz__PaymentMethod__c,ccrz__ShipTo__r.ccrz__AddressFirstline__c,ccrz__ShipTo__r.ccrz__AddressSecondline__c,ccrz__ShipTo__r.ccrz__AddressThirdline__c,ccrz__ShipTo__r.ccrz__FirstName__c,ccrz__ShipTo__r.ccrz__LastName__c,ccrz__ShipTo__r.ccrz__City__c,ccrz__ShipTo__r.ccrz__State__c,ccrz__ShipTo__r.ccrz__Country__c,ccrz__ShipTo__r.ccrz__PostalCode__c,ccrz__BuyerFirstName__c,
                        ccrz__BillTo__r.ccrz__AddressFirstline__c,ccrz__BillTo__r.ccrz__AddressSecondline__c,ccrz__BillTo__r.ccrz__AddressThirdline__c,ccrz__BillTo__r.ccrz__FirstName__c,ccrz__BillTo__r.ccrz__LastName__c,
                        ccrz__BillTo__r.ccrz__City__c,ccrz__BillTo__r.ccrz__State__c,ccrz__BillTo__r.ccrz__Country__c,ccrz__BillTo__r.ccrz__PostalCode__c,
                        ccrz__BuyerLastName__c,ccrz__BuyerEmail__c,ccrz__BuyerPhone__c,	dbu_Store_Language__c,ccrz__ShipMethod__c,ccrz__OriginatedCart__r.dbu_Pick_Up_From_Store__r.ccrz__AddressFirstline__c,ccrz__OriginatedCart__r.dbu_Pick_Up_From_Store__r.ccrz__AddressSecondline__c,ccrz__OriginatedCart__r.dbu_Pick_Up_From_Store__r.ccrz__AddressThirdline__c,ccrz__OriginatedCart__r.dbu_Pick_Up_From_Store__r.ccrz__FirstName__c,ccrz__OriginatedCart__r.dbu_Pick_Up_From_Store__r.ccrz__LastName__c,ccrz__OriginatedCart__r.dbu_Pick_Up_From_Store__r.ccrz__City__c,ccrz__OriginatedCart__r.dbu_Pick_Up_From_Store__r.ccrz__State__c,ccrz__OriginatedCart__r.dbu_Pick_Up_From_Store__r.ccrz__Country__c,ccrz__OriginatedCart__r.dbu_Pick_Up_From_Store__r.ccrz__PostalCode__c,
                        ccrz__OriginatedCart__r.ccrz__ShipTo__r.ccrz__AddressFirstline__c,
                        ccrz__OriginatedCart__r.ccrz__ShipTo__r.ccrz__AddressSecondline__c,
                        ccrz__OriginatedCart__r.ccrz__ShipTo__r.ccrz__City__c,
                        ccrz__OriginatedCart__r.ccrz__ShipTo__r.ccrz__State__c,
                        ccrz__OriginatedCart__r.ccrz__ShipTo__r.ccrz__Country__c,
                        ccrz__OriginatedCart__r.ccrz__ShipTo__r.ccrz__PostalCode__c
                        FROM ccrz__E_Order__c where Id =: orderid];
        if(orderDetails != null){
            /*if(String.isNotBlank(orderDetails.dbu_Store_Language__c)){
if((orderDetails.dbu_Store_Language__c).equalsIgnoreCase('US'))
CurrencyIsoCode = 'USD';
else if((orderDetails.dbu_Store_Language__c).equalsIgnoreCase('EN'))
CurrencyIsoCode = 'CAD';
else if((orderDetails.dbu_Store_Language__c).equalsIgnoreCase('FR'))
onlyFrench = 'FR';
CurrencyIsoCode = 'CAD';
}*/
            StoreLanguage = orderDetails.dbu_Store_Language__c;
            
        }
        lstOftransantionPayment = [SELECT id,ccrz__AccountNumber__c,ccrz__TransactionType__c from ccrz__E_TransactionPayment__c WHERE ccrz__CCOrder__c =: orderid];
        
        invoiceDetails = [Select id,Name,CreatedDate,(Select id,Name,ccrz__CCOrderItem__r.dbu_isShipTo__c,ccrz__CCOrderItem__r.ccrz__OriginalQuantity__c,ccrz__CCOrderItem__r.dbu_CC_Order_Item__r.ccrz__Order__r.dbu_Days_Since_Order_Date__c,ccrz__CCOrderItem__r.ccrz__Product__r.dbu_Core_Charge_Amount__c,ccrz__CCOrderItem__r.ccrz__Product__r.dbu_Has_Core_Charge__c,ccrz__Type__c,ccrz__CCOrderItem__c,ccrz__CCOrderItem__r.ccrz__OrderItemStatus__c,ccrz__CCOrderItem__r.dbu_Reason_for_Return__c,ccrz__CCOrderItem__r.dbu_Estimated_Return_Amount__c,ccrz__CCOrderItem__r.ccrz__Product__c,ccrz__CCOrderItem__r.ccrz__Quantity__c,ccrz__CCOrderItem__r.ccrz__AbsoluteDiscount__c,ccrz__CCOrderItem__r.ccrz__Price__c,ccrz__OriginalAmount__c,ccrz__CCOrderItem__r.Vertex_Tax__c,ccrz__CCOrderItem__r.ccrz__Product__r.dbu_Non_Returnable__c,ccrz__CCOrderItem__r.ccrz__Product__r.Name from ccrz__InvoiceItems__r where ccrz__CCOrderItem__c != Null) from ccrz__E_Invoice__c where ccrz__CCOrder__c=:orderid];
        
        lstOrderWrpr = new List<orderWrapper>();
        orderWrapper orderWrpr = new orderWrapper();
        //lstInvoiceWrpr = new List<InvoiceWrpr>();
        lstInvoiceWrpr = new InvoiceWrpr();
        lstInvoiceWrpr1 = new InvoiceWrpr1();
         lstInvoiceWrprPickup = new InvoiceWrpr();
        if(orderDetails != Null){
            
            if(!lstOftransantionPayment.isEmpty()){
                System.debug('========='+ lstOftransantionPayment[0].ccrz__TransactionType__c+''+lstOftransantionPayment[0].ccrz__AccountNumber__c);
                if(lstOftransantionPayment[0].ccrz__TransactionType__c == 'PayPal' && lstOftransantionPayment[0].ccrz__AccountNumber__c != null && lstOftransantionPayment[0].ccrz__AccountNumber__c != ''){
                    String accNumber = lstOftransantionPayment[0].ccrz__AccountNumber__c;
                    String lstFourCharOfAccNumber =  lstOftransantionPayment[0].ccrz__AccountNumber__c.right(4);
                    for(Integer i = 0;i<accNumber.length()-4;i++){
                        lstFourCharOfAccNumber = 'x'+lstFourCharOfAccNumber ;
                    }
                    accNumber = lstFourCharOfAccNumber;   
                    orderWrpr.paymentType = lstOftransantionPayment[0].ccrz__TransactionType__c+' '+accNumber ;
                }else{
                    orderWrpr.paymentType = lstOftransantionPayment[0].ccrz__TransactionType__c+' '+lstOftransantionPayment[0].ccrz__AccountNumber__c;
                }
            }
            
            Date date1 = orderDetails.ccrz__OrderDate__c;
            Datetime dateTim = Datetime.newInstance(date1.year(), date1.month(),date1.day());
            orderWrpr.orderDate = dateTim.format('MMMM dd, YYYY');
            orderWrpr.orderNumber = orderDetails.Name;
            orderWrpr.emailID = orderDetails.ccrz__BuyerEmail__c;
            orderWrpr.phone = orderDetails.ccrz__BuyerPhone__c;
            orderWrpr.name = orderDetails.ccrz__BuyerFirstName__c;
            orderWrpr.lastName = orderDetails.ccrz__BuyerLastName__c;
            orderWrpr.totalAmount = orderDetails.ccrz__TotalAmount__c.setScale(2);
            orderWrpr.subTotalAmount = orderDetails.ccrz__SubtotalAmount__c.setScale(2);
            if(orderDetails.ccrz__TotalDiscount__c != null && orderDetails.ccrz__TotalDiscount__c > 0){
                orderWrpr.discountAmount = orderDetails.ccrz__TotalDiscount__c.setScale(2); 
            }else{
                orderWrpr.discountAmount = 0.00;
            }
            if(orderDetails.ccrz__TaxAmount__c != null){
                orderWrpr.estimatedTax = orderDetails.ccrz__TaxAmount__c.setScale(2);
            }
            
            if(orderDetails.ccrz__ShipAmount__c != Null && orderDetails.ccrz__ShipAmount__c > 0){
                orderWrpr.shippingCost = String.ValueOf(orderDetails.ccrz__ShipAmount__c.setScale(2));
            }else{
                orderWrpr.shippingCost = 'FREE';
            }
            
          //  if(orderDetails.ccrz__ShipMethod__c=='Ship To Address' || orderDetails.ccrz__ShipMethod__c == 'Adresse d\'expédition'){
              if(orderDetails.ccrz__OriginatedCart__r.ccrz__ShipTo__r != null){ // inventory Check Changes
                // orderWrapper.ShipToAddress shipAddr = new orderWrapper.ShipToAddress();
                isStorePickup = false;
                orderWrpr.shipFirstName = orderDetails.ccrz__BuyerFirstName__c;
                orderWrpr.shipLastName = orderDetails.ccrz__BuyerLastName__c;
                orderWrpr.shipAddress1 = orderDetails.ccrz__OriginatedCart__r.ccrz__ShipTo__r.ccrz__AddressFirstline__c;
                orderWrpr.shipAddress2 = orderDetails.ccrz__OriginatedCart__r.ccrz__ShipTo__r.ccrz__AddressSecondline__c;
                orderWrpr.shipCity = orderDetails.ccrz__OriginatedCart__r.ccrz__ShipTo__r.ccrz__City__c;
                orderWrpr.shipState = orderDetails.ccrz__OriginatedCart__r.ccrz__ShipTo__r.ccrz__State__c;
                //orderWrpr.shipCountry = orderDetails.ccrz__ShipTo__r.ccrz__Country__c;
                if((orderDetails.ccrz__OriginatedCart__r.ccrz__ShipTo__r.ccrz__Country__c).equalsIgnoreCase('US') 
                   || (orderDetails.ccrz__OriginatedCart__r.ccrz__ShipTo__r.ccrz__Country__c).equalsIgnoreCase('USA') 
                   || (orderDetails.ccrz__OriginatedCart__r.ccrz__ShipTo__r.ccrz__Country__c).equalsIgnoreCase('United State') 
                   || (orderDetails.ccrz__OriginatedCart__r.ccrz__ShipTo__r.ccrz__Country__c).equalsIgnoreCase('United States')){
                    orderWrpr.shipCountry = 'U.S.A';
                }else if((orderDetails.ccrz__OriginatedCart__r.ccrz__ShipTo__r.ccrz__Country__c).equalsIgnoreCase('CA') 
                         || (orderDetails.ccrz__OriginatedCart__r.ccrz__ShipTo__r.ccrz__Country__c).equalsIgnoreCase('CANADA')){
                    orderWrpr.shipCountry = 'Canada';
                }else{
                    orderWrpr.shipCountry = orderDetails.ccrz__OriginatedCart__r.ccrz__ShipTo__r.ccrz__Country__c;
                }
                orderWrpr.shipPostalCode = orderDetails.ccrz__OriginatedCart__r.ccrz__ShipTo__r.ccrz__PostalCode__c;
            }else if(orderDetails.ccrz__OriginatedCart__r.dbu_Pick_Up_From_Store__r != null){
                // orderWrapper.ShipToAddress shipAddr = new orderWrapper.ShipToAddress();
                isStorePickup = true;
                orderWrpr.pickupStoreFirstName = orderDetails.ccrz__BuyerFirstName__c;
                orderWrpr.pickupStoreLastName = orderDetails.ccrz__BuyerLastName__c;
                orderWrpr.pickupStoreAddress1 = orderDetails.ccrz__OriginatedCart__r.dbu_Pick_Up_From_Store__r.ccrz__AddressFirstline__c;
                orderWrpr.pickupStoreAddress2 = orderDetails.ccrz__OriginatedCart__r.dbu_Pick_Up_From_Store__r.ccrz__AddressSecondline__c;
                orderWrpr.pickupStoreCity = orderDetails.ccrz__OriginatedCart__r.dbu_Pick_Up_From_Store__r.ccrz__City__c;
                orderWrpr.pickupStoreState = orderDetails.ccrz__OriginatedCart__r.dbu_Pick_Up_From_Store__r.ccrz__State__c;
                //orderWrpr.shipCountry = orderDetails.ccrz__ShipTo__r.ccrz__Country__c;
                if((orderDetails.ccrz__OriginatedCart__r.dbu_Pick_Up_From_Store__r.ccrz__Country__c).equalsIgnoreCase('US') || (orderDetails.ccrz__OriginatedCart__r.dbu_Pick_Up_From_Store__r.ccrz__Country__c).equalsIgnoreCase('USA') || (orderDetails.ccrz__OriginatedCart__r.dbu_Pick_Up_From_Store__r.ccrz__Country__c).equalsIgnoreCase('United State') || (orderDetails.ccrz__OriginatedCart__r.dbu_Pick_Up_From_Store__r.ccrz__Country__c).equalsIgnoreCase('United States')){
                    orderWrpr.pickupStoreCountry = 'U.S.A';
                }else if((orderDetails.ccrz__OriginatedCart__r.dbu_Pick_Up_From_Store__r.ccrz__Country__c).equalsIgnoreCase('CA') || (orderDetails.ccrz__OriginatedCart__r.dbu_Pick_Up_From_Store__r.ccrz__Country__c).equalsIgnoreCase('CANADA')){
                    orderWrpr.pickupStoreCountry = 'Canada';
                }else{
                    orderWrpr.pickupStoreCountry = orderDetails.ccrz__OriginatedCart__r.dbu_Pick_Up_From_Store__r.ccrz__Country__c;
                }
                orderWrpr.pickupStorePostalCode = orderDetails.ccrz__OriginatedCart__r.dbu_Pick_Up_From_Store__r.ccrz__PostalCode__c;
            }
            
            //orderWrpr.shipAddress = shipAddr;
            
            //orderWrapper.BillToAddress billAddr = new orderWrapper.BillToAddress();
            orderWrpr.billFirstName = orderDetails.ccrz__BuyerFirstName__c;
            orderWrpr.billLastName = orderDetails.ccrz__BuyerLastName__c;
            orderWrpr.billAddress1 = orderDetails.ccrz__BillTo__r.ccrz__AddressFirstline__c;
            orderWrpr.billAddress2 = orderDetails.ccrz__BillTo__r.ccrz__AddressSecondline__c;
            orderWrpr.billCity = orderDetails.ccrz__BillTo__r.ccrz__City__c;
            orderWrpr.billState = orderDetails.ccrz__BillTo__r.ccrz__State__c;
            if((orderDetails.ccrz__BillTo__r.ccrz__Country__c).equalsIgnoreCase('US') || (orderDetails.ccrz__BillTo__r.ccrz__Country__c).equalsIgnoreCase('USA') || (orderDetails.ccrz__BillTo__r.ccrz__Country__c).equalsIgnoreCase('United State') || (orderDetails.ccrz__BillTo__r.ccrz__Country__c).equalsIgnoreCase('United States')){
                orderWrpr.billCountry = 'U.S.A';
            }else if((orderDetails.ccrz__BillTo__r.ccrz__Country__c).equalsIgnoreCase('CA') || (orderDetails.ccrz__BillTo__r.ccrz__Country__c).equalsIgnoreCase('CANADA')){
                orderWrpr.billCountry = 'Canada';
            }else{
                orderWrpr.billCountry = orderDetails.ccrz__BillTo__r.ccrz__Country__c;
            }
            
            orderWrpr.billPostalCode = orderDetails.ccrz__BillTo__r.ccrz__PostalCode__c;
            //orderWrpr.billAddress = billAddr;
        }
        lstOrderWrpr.add(orderWrpr);
        
        InvoiceWrpr objWrpr = new InvoiceWrpr();
        
        //InvoiceItemWrpr invoiceItemWrp = new InvoiceItemWrpr();
        List<InvoiceItemWrpr> lstItem =  new List<InvoiceItemWrpr>();
         List<InvoiceItemWrpr> lstItemPickup =  new List<InvoiceItemWrpr>();
        List<InvoiceItemWrpr> lstItem1 =  new List<InvoiceItemWrpr>();
        for (ccrz__E_Invoice__c invoiceDeta: invoiceDetails) {
            if (invoiceDeta.ccrz__InvoiceItems__r != null) {
                mapInvoiceItemList.put(invoiceDeta.id, invoiceDeta.ccrz__InvoiceItems__r);
            }
        }
        for (ccrz__E_Invoice__c invoiceDetil: invoiceDetails) {
            system.debug('invoiceDetil--->>'+invoiceDetil);
            for(ccrz__E_InvoiceItem__c invItem: mapInvoiceItemList.get(invoiceDetil.id)){
                listProdIds.add(invItem.ccrz__CCOrderItem__r.ccrz__Product__c);
            }
            Map<String,String> productImg = new Map<String,String>();
            if(!Test.isRunningTest())
                productImg = dbu_ccApiRelatedProduct.getProducts(listProdIds);
            for(ccrz__E_InvoiceItem__c invItem: mapInvoiceItemList.get(invoiceDetil.id)){
                system.debug('invItem--->>'+invItem);
                InvoiceItemWrpr objItemWrpr = new InvoiceItemWrpr();
                if(invItem.ccrz__CCOrderItem__r.ccrz__OrderItemStatus__c != 'Return Initiated' && invItem.ccrz__CCOrderItem__r.ccrz__OrderItemStatus__c != 'Return Approved' && invItem.ccrz__CCOrderItem__r.ccrz__OrderItemStatus__c != 'Refunded'){
                    
                    if(productImg.containsKey(invItem.ccrz__CCOrderItem__r.ccrz__Product__c)){
                        objItemWrpr.proImage = productImg.get(invItem.ccrz__CCOrderItem__r.ccrz__Product__c);
                    }
                    // objItemWrpr.hasCoreCharge = invItem.ccrz__CCOrderItem__r.ccrz__Product__r.dbu_Has_Core_Charge__c;
                    // objItemWrpr.hasCoreChargeAmount = invItem.ccrz__CCOrderItem__r.ccrz__Product__r.dbu_Core_Charge_Amount__c;
                    objItemWrpr.invoiceItemNumber = invItem.Name;
                    objItemWrpr.quantity = Integer.ValueOf(invItem.ccrz__CCOrderItem__r.ccrz__Quantity__c);
                    if(invItem.ccrz__CCOrderItem__r.Vertex_Tax__c != null){
                         objItemWrpr.tax =invItem.ccrz__CCOrderItem__r.Vertex_Tax__c.setScale(2);
                    }
                   
                    objItemWrpr.isShipTo = invItem.ccrz__CCOrderItem__r.dbu_isShipTo__c; // Inventory Changes
                    
                    //objItemWrpr.returnableOrNot = invItem.ccrz__CCOrderItem__r.ccrz__Product__r.dbu_Non_Returnable__c;
                    objItemWrpr.productName = invItem.ccrz__CCOrderItem__r.ccrz__Product__r.Name;
                    objItemWrpr.unitPrice = invItem.ccrz__CCOrderItem__r.ccrz__Price__c.setScale(2);
                    if(invItem.ccrz__CCOrderItem__r.Vertex_Tax__c == null)
                        invItem.ccrz__CCOrderItem__r.Vertex_Tax__c = 0;
                    if(invItem.ccrz__CCOrderItem__r.ccrz__AbsoluteDiscount__c != Null){
                        objItemWrpr.discPrice =invItem.ccrz__CCOrderItem__r.ccrz__AbsoluteDiscount__c;
                        objItemWrpr.price = (((Integer.ValueOf(invItem.ccrz__CCOrderItem__r.ccrz__Quantity__c)*(invItem.ccrz__CCOrderItem__r.ccrz__Price__c))+(invItem.ccrz__CCOrderItem__r.Vertex_Tax__c))-invItem.ccrz__CCOrderItem__r.ccrz__AbsoluteDiscount__c).setScale(2);
                    }else{
                        if(Test.isRunningTest())
                            invItem.ccrz__CCOrderItem__r.Vertex_Tax__c = 1;
                        objItemWrpr.price = (((Integer.ValueOf(invItem.ccrz__CCOrderItem__r.ccrz__Quantity__c)*(invItem.ccrz__CCOrderItem__r.ccrz__Price__c))+(invItem.ccrz__CCOrderItem__r.Vertex_Tax__c))).setScale(2);
                        objItemWrpr.discPrice =0.00;
                    }
                    if(invItem.ccrz__CCOrderItem__r.ccrz__Product__r.dbu_Non_Returnable__c){
                        // objItemWrpr.daysSinceOrderDate = Integer.ValueOf(invItem.ccrz__CCOrderItem__r.dbu_CC_Order_Item__r.ccrz__Order__r.dbu_Days_Since_Order_Date__c);
                        //objItemWrpr.originalQty = invItem.ccrz__CCOrderItem__r.ccrz__OriginalQuantity__c;
                        objItemWrpr.isReturnable = 'No';
                    }else{
                        objItemWrpr.isReturnable = 'Yes';
                    }
                    if(objItemWrpr.isShipTo){
                        lstItem.add(objItemWrpr);
                    }else{
                        lstItemPickup.add(objItemWrpr);
                    }
                    
                }else{
                    isReturn=True;
                    pageURL =  ApexPages.currentPage().getUrl();
                    viewReturnInvoiceData(pageURL);
                    system.debug('isReturn111' +isReturn);
                    if(productImg.containsKey(invItem.ccrz__CCOrderItem__r.ccrz__Product__c)){
                        objItemWrpr.proImage = productImg.get(invItem.ccrz__CCOrderItem__r.ccrz__Product__c);
                    }
                    // objItemWrpr.hasCoreCharge = invItem.ccrz__CCOrderItem__r.ccrz__Product__r.dbu_Has_Core_Charge__c;
                    // objItemWrpr.hasCoreChargeAmount = invItem.ccrz__CCOrderItem__r.ccrz__Product__r.dbu_Core_Charge_Amount__c;
                    objItemWrpr.invoiceItemNumber = invItem.Name;
                    objItemWrpr.quantity = Integer.ValueOf(invItem.ccrz__CCOrderItem__r.ccrz__Quantity__c);
                    objItemWrpr.tax =invItem.ccrz__CCOrderItem__r.Vertex_Tax__c.setScale(2);
                    if(invItem.ccrz__OriginalAmount__c != null){
                        objItemWrpr.price = invItem.ccrz__OriginalAmount__c.setScale(2);
                    }
                    //objItemWrpr.returnableOrNot = invItem.ccrz__CCOrderItem__r.ccrz__Product__r.dbu_Non_Returnable__c;
                    objItemWrpr.productName = invItem.ccrz__CCOrderItem__r.ccrz__Product__r.Name;
                    objItemWrpr.unitPrice = invItem.ccrz__CCOrderItem__r.ccrz__Price__c.setScale(2);
                    if(invItem.ccrz__CCOrderItem__r.ccrz__AbsoluteDiscount__c != Null){
                        objItemWrpr.discPrice =invItem.ccrz__CCOrderItem__r.ccrz__AbsoluteDiscount__c.setScale(2);
                    }else{
                        objItemWrpr.discPrice =0.00;
                    }
                    
                    objItemWrpr.returnDate=Datetime.now().format('MMMM dd, YYYY');
                    objItemWrpr.refundAmount = invItem.ccrz__CCOrderItem__r.dbu_Estimated_Return_Amount__c.setScale(2);
                    if(invItem.ccrz__CCOrderItem__r.ccrz__Product__r.dbu_Non_Returnable__c){
                        // objItemWrpr.daysSinceOrderDate = Integer.ValueOf(invItem.ccrz__CCOrderItem__r.dbu_CC_Order_Item__r.ccrz__Order__r.dbu_Days_Since_Order_Date__c);
                        //objItemWrpr.originalQty = invItem.ccrz__CCOrderItem__r.ccrz__OriginalQuantity__c;
                        objItemWrpr.isReturnable = 'No';
                    }else{
                        objItemWrpr.isReturnable = 'Yes';
                    }
                    lstItem1.add(objItemWrpr);
                }
            }
            system.debug('lstItem--->>'+lstItem);
            system.debug('lstItemPickup--->>'+lstItemPickup);
            if(lstItem.size() > 0){
                lstInvoiceWrpr.lstInvoiceItemWrpr = lstItem;
            } 
            if(lstItemPickup.size() > 0){
                lstInvoiceWrprPickup.lstInvoiceItemWrpr = lstItemPickup;
            }
            
            
            lstInvoiceWrpr1.lstInvoiceItemWrpr1 = lstItem1;
            //lstInvoiceWrpr.add(objWrpr);
            system.debug('lstInvoiceWrpr--->>'+lstInvoiceWrpr);
            
        } 
        
    }
    
    public static List<dbu_WrapperInvoiceDetails> viewReturnInvoiceData(String pageURL){
        InvoiceDetailsWrapper = new List<dbu_WrapperInvoiceDetails>();
        InvoiceDetailsWrapper = dbu_ViewReturnInvoiceDetails.viewReturnInvoiceData(pageURL);
        system.debug('invoiceReturnDetails>' +InvoiceDetailsWrapper);
		set<string> ClonedOrderIds = new set<string>();
        
        TaxReturnOrdersFlag = false;
        for(dbu_WrapperInvoiceDetails eachwrap : InvoiceDetailsWrapper){
            //ClonedOrderIds.add(eachwrap.orderId);
            List<TaxSummery> CurrentOrderTaxList =  dbu_TaxSummaryCtrl.getOderTax(eachwrap.orderId);                
            if(CurrentOrderTaxList.size() > 0){
                TaxReturnOrdersFlag = true;
                eachwrap.currentOrderTaxSummary = CurrentOrderTaxList;
            }            
        }
        

        system.debug('invoiceReturnDetails MOdified >> ' +InvoiceDetailsWrapper);
        
        return InvoiceDetailsWrapper;
    }
    
    public static List<TaxSummery> getTaxDetails(String orderId){
        taxSummarydetails = new List<TaxSummery>();
        taxSummarydetails = dbu_TaxSummaryCtrl.getOderTax(orderId);
        system.debug('taxSummarydetails>>>' +taxSummarydetails);
        if(taxSummarydetails.size() > 0){
            TaxNormalOrdersFlag = true;
        }
        return taxSummarydetails;
    }
    
    public class orderWrapper
    {
        public String orderNumber{get;set;}
        public String orderDate{get;set;}
        public String emailID{get;set;}
        public String phone{get;set;}
        public String name {get;set;}
        public String lastName {get;set;}
        public Decimal totalAmount {get;set;}
        public Decimal subTotalAmount {get;set;}
        public Decimal discountAmount {get;set;}
        public Decimal estimatedTax {get;set;}
        public String shippingCost {get;set;}
        public String paymentType{get;set;}
        public String shipFirstName{get;set;}
        public String shipLastName{get;set;}
        public String shipAddress1{get;set;}
        public String shipAddress2{get;set;}
        public String shipAddress3{get;set;}
        public String shipCity{get;set;}
        public String shipState{get;set;}
        public String shipCountry{get;set;}
        public String shipPostalCode{get;set;}
        //this is for pickup only
        public String pickupStoreFirstName{get;set;}
        public String pickupStoreLastName{get;set;}
        public String pickupStoreAddress1{get;set;}
        public String pickupStoreAddress2{get;set;}
        public String pickupStoreAddress3{get;set;}
        public String pickupStoreCity{get;set;}
        public String pickupStoreState{get;set;}
        public String pickupStoreCountry{get;set;}
        public String pickupStorePostalCode{get;set;}
        //end of pickup
        public String billFirstName{get;set;}
        public String billLastName{get;set;}
        public String billAddress1{get;set;}
        public String billAddress2{get;set;}
        public String billAddress3{get;set;}
        public String billCity{get;set;}
        public String billState{get;set;}
        public String billCountry{get;set;}
        public String billPostalCode{get;set;}
    }
    
    public class InvoiceWrpr
    {
        public List<InvoiceItemWrpr> lstInvoiceItemWrpr{get;set;}
        
        public InvoiceWrpr()
        {
            lstInvoiceItemWrpr = new List<InvoiceItemWrpr>();
        }
    }
    public class InvoiceWrpr1
    {
        public List<InvoiceItemWrpr> lstInvoiceItemWrpr1{get;set;}
        
        public InvoiceWrpr1()
        {
            lstInvoiceItemWrpr1 = new List<InvoiceItemWrpr>();
        }
    }
    
     
   /* public class InvoiceItemWrpr
    {
        public String productName{get;set;}
        public String invoiceItemNumber{get;set;}
        public Integer quantity{get;set;}
        public Decimal tax{get;set;}
        public String isReturnable{get;set;}
        public Decimal unitPrice{get;set;}
        public Decimal discPrice{get;set;}
        public Decimal price{get;set;}
        public String proImage{get;set;}
        public Decimal refundAmount {get;set;}
        public String returnDate{get;set;}
        public Boolean isShipTo{get;set;} // Inventory Changes 
    }*/
}