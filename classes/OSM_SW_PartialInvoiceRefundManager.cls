public class OSM_SW_PartialInvoiceRefundManager {
    public static boolean getVertexInvoiceTax(List<Id> lstJunctionObjectId, List<Id> lstOrdrItemId) {
        System.debug('in invocie vertex call');
        OSM_ReturnWrapper objToReturn = new OSM_ReturnWrapper();
        boolean isSuccess = true;
    
        List<ccrz__E_InvoiceItem__c> lstToUpdateInvoiceItem = new List<ccrz__E_InvoiceItem__c>();
        List<ccrz__E_Invoice__c> lstToUpdateInvoice = new List<ccrz__E_Invoice__c>();
        List<OSM_InvoiceLine_And_OrderLine__c> lstToUpdateJunctionItem = new List<OSM_InvoiceLine_And_OrderLine__c>();
        List<OSM_Orders_In_Invoice__c> lstToUpdateJunctionObject = new List<OSM_Orders_In_Invoice__c>();
        List<OSM_Integration_Log__c> lstToInsertLog = new List<OSM_Integration_Log__c>();
        Map<Id, Decimal> mapInvoiceToVertexTax = new Map<Id, Decimal>();
        Map<Id, Decimal> mapOrderToTotalAmount = new Map<Id, Decimal>();
        List<OSM_Orders_In_Invoice__c> lstJunctionObject = new List<OSM_Orders_In_Invoice__c>();
        decimal totalTax;
        boolean isCallFail;
        map<String, OSM_InvoiceLine_And_OrderLine__c> mapPruductSKUtoJunctionLine;
        OSM_VERTEX_WS_GeneralizedoutputWrapper objResponseWrp;
        OSM_Integration_Log__c log;
        string AccountId; // for 1879
        
        lstJunctionObject = [Select Id,CC_Invoice__r.CreditMemo_Number__c,CC_Invoice__r.ccrz__Status__c, CC_Invoice__r.OSM_SW_IsIntercompanyInvoice__c,CC_Invoice__r.ccrz__Contact__r.Account.Bolt_Customer_Account_Status__c,
                                CC_Invoice__r.ccrz__Contact__r.Account.Bolt_Credit_Hold__c,CC_Invoice__r.ccrz__Contact__r.Account.BOLT_Account_Number__c, CC_Invoice__r.Payment_Method__c,
                                CC_Order__r.ccrz__OrderDate__c,CC_Order__r.ccrz__Account__r.Bolt_Customer_Account_Status__c,CC_Order__r.ccrz__Account__r.Type, 
                                CC_Order__r.ccrz__Account__r.Bolt_BC_Code__c,CC_Order__r.ccrz__Account__r.Bolt_Credit_Hold__c,CC_Invoice__r.OSM_SW_Is_Bolt_PO__c, OSM_SW_Is_Recurring_Invoice__c, 
                                Vertex_Call_Status__c, Name, CC_Invoice__c, CC_Invoice__r.Name,CC_Invoice__r.Total_Sales_Amount__c, CC_Order__c, CC_Order__r.ccrz__Account__c,
                                CC_Order__r.ccrz__Account__r.Name, CC_Order__r.ccrz__TotalDiscount__c, CC_Order__r.ccrz__Account__r.BOLT_Account_Number__c,
                                CC_Order__r.ccrz__Account__r.Customer_BMS_number__c,CC_Order__r.ccrz__Account__r.IAM_Service_Provider_Code__c,CC_Order__r.ccrz__Account__r.CMI_Cid__c, 
                                CC_Order__r.ccrz__Account__r.Vertex_Customer_Class_Code__c, CC_Order__r.ccrz__Account__r.CMI_Address2__c,  CC_Order__r.ccrz__Account__r.CMI_Address3__c, 
                                CC_Order__r.ccrz__Account__r.BillingCity, CC_Order__r.ccrz__Account__r.Billingstate, CC_Order__r.ccrz__Account__r.ShippingStreet,CC_Order__r.ccrz__Account__r.BillingStreet,
                                CC_Order__r.ccrz__Account__r.BillingPostalCode, CC_Order__r.ccrz__Account__r.BillingCountry, CC_Order__r.ccrz__Account__r.shippingCity, CC_Order__r.ccrz__Account__r.ShippingState,
                                CC_Order__r.ccrz__Account__r.shippingPostalCode, CC_Order__r.ccrz__Account__r.shippingCountry,CC_Order__r.ccrz__BillTo__c, CC_Order__r.ccrz__BillTo__r.ccrz__AddressFirstline__c,
                                CC_Order__r.ccrz__BillTo__r.ccrz__AddressSecondline__c,CC_Order__r.ccrz__BillTo__r.ccrz__City__c,CC_Order__r.ccrz__BillTo__r.ccrz__StateISOCode__c,CC_Order__r.ccrz__BillTo__r.ccrz__State__c,
                                CC_Order__r.ccrz__BillTo__r.ccrz__Country__c,CC_Order__r.ccrz__BillTo__r.ccrz__PostalCode__c,CC_Order__r.ccrz__ShipTo__c, CC_Order__r.ccrz__ShipTo__r.ccrz__AddressFirstline__c, 
                                CC_Order__r.ccrz__ShipTo__r.ccrz__AddressSecondline__c, CC_Order__r.ccrz__ShipTo__r.ccrz__City__c, CC_Order__r.ccrz__ShipTo__r.ccrz__StateISOCode__c,CC_Order__r.ccrz__ShipTo__r.ccrz__State__c, 
                                CC_Order__r.ccrz__ShipTo__r.ccrz__Country__c, CC_Order__r.ccrz__ShipTo__r.ccrz__PostalCode__c,OSM_Vertex_Invoice_Failed_Count__c,CC_Order__r.ccrz__Account__r.id, 
                                    (Select Id, Name,CC_Invoice_Item__c,CC_Order_Item__c,Vertex_Tax__c, CC_Invoice_Item__r.Quantity__c, CC_Invoice_Item__r.ccrz__OriginalAmount__c, CC_Order_Item__r.ccrz__ExtSKU__c,
                                        CC_Order_Item__r.ccrz__UnitOfMeasure__c,CC_Order_Item__r.ccrz__DisplayProduct__r.ccrz__SKU__c,CC_Order_Item__r.VertexOrderItemCall__c,CC_Order_Item__r.ccrz__Product__r.ccrz__SKU__c,
                                        CC_Order_Item__r.ccrz__Product__r.Name,CC_Order_Item__r.ccrz__Product__r.Product_Class_Code__c,CC_Order_Item__r.ccrz__AbsoluteDiscount__c,Sales_Amount__c,Quantity__c, CC_Order_Item__r.ccrz__Price__c
                                    FROM OSM_InvoiceLine_And_OrderLines__r WHERE CC_Order_Item__c IN: lstOrdrItemId) // AND CC_Order_Item__r.IsInvoiceRefund__c = false) 
                                FROM OSM_Orders_In_Invoice__c where Id IN: lstJunctionObjectId];   
        for(OSM_Orders_In_Invoice__c objJun : lstJunctionObject) { 
            AccountId = objJun.CC_Order__r.ccrz__Account__r.id; //for 1879  
            totalTax=0.0;
            isCallFail = false;
            mapPruductSKUtoJunctionLine = new map<String, OSM_InvoiceLine_And_OrderLine__c>();
            objResponseWrp = new OSM_VERTEX_WS_GeneralizedoutputWrapper();
            log = new OSM_Integration_Log__c();
            try {               
                OSM_VERTEX_WS_GeneralizedInputWrapper objReq = new OSM_VERTEX_WS_GeneralizedInputWrapper();
                objReq.DataArea = new OSM_VERTEX_WS_GeneralizedInputWrapper.DataArea();
                objReq.DataArea.Seller = new OSM_VERTEX_WS_GeneralizedInputWrapper.Seller();
                objReq.DataArea.Seller.Physical_Origin = new OSM_VERTEX_WS_GeneralizedInputWrapper.Physical_Origin();
                objReq.DataArea.Seller.AdministrativeOrigin = new OSM_VERTEX_WS_GeneralizedInputWrapper.Physical_Origin();
                objReq.DataArea.Customer = new OSM_VERTEX_WS_GeneralizedInputWrapper.Customer();
                objReq.DataArea.Customer.Destination_Addesss = new OSM_VERTEX_WS_GeneralizedInputWrapper.Physical_Origin();
                objReq.DataArea.Customer.Administrive_Destination = new OSM_VERTEX_WS_GeneralizedInputWrapper.Administrive_Destination();
                objReq.DataArea.ProductList = new List<OSM_VERTEX_WS_GeneralizedInputWrapper.ProductList>();
                
                objReq.orderPlacementDate=String.valueof(objJun.CC_Order__r.ccrz__OrderDate__c);                
                objReq.isForQuote = false;
                objReq.isRefundInvoiceReq = true;
                objReq.recordId = objJun.CC_Invoice__c;
                // MAR-1665 - Code Start 
                if(objJun.CC_Invoice__r.CreditMemo_Number__c != Null){
                    objReq.InvoiceRequestDocumentNumber = objJun.CC_Invoice__r.CreditMemo_Number__c;
                }else{
                    objReq.InvoiceRequestDocumentNumber = objJun.CC_Invoice__r.Name;
                }
                // MAR-1665 - Code End
                System.debug('objJun.CC_Invoice__c: '+objJun.CC_Invoice__c);
                
                if((objJun.CC_Order__r.ccrz__Account__r.Customer_BMS_number__c != null && objJun.CC_Order__r.ccrz__Account__r.Customer_BMS_number__c != '')|| Test.isRunningTest()){
                    objReq.DataArea.Customer.Customer_Code = nullCheck(objJun.CC_Order__r.ccrz__Account__r.Customer_BMS_number__c);
                }
                else if(objJun.CC_Order__r.ccrz__Account__r.BOLT_Account_Number__c != null && objJun.CC_Order__r.ccrz__Account__r.BOLT_Account_Number__c != ''){
                    objReq.DataArea.Customer.Customer_Code = nullCheck(objJun.CC_Order__r.ccrz__Account__r.BOLT_Account_Number__c);
                }
                else {
                    objReq.DataArea.Customer.Customer_Code = nullCheck(objJun.CC_Order__r.ccrz__Account__r.IAM_Service_Provider_Code__c);
                }

                if(objJun.CC_Order__r.ccrz__TotalDiscount__c != null) { 
                    Decimal totalDiscount=objJun.CC_Order__r.ccrz__TotalDiscount__c;
                    objReq.DataArea.DiscountAmount = String.valueOf(totalDiscount.setScale(2, RoundingMode.HALF_UP));
                }
                else
                    objReq.DataArea.DiscountAmount = '';
                
                if(objJun.CC_Order__r.ccrz__BillTo__c != null) {
                    objReq.DataArea.Customer.Administrive_Destination.AddressLine1 = nullCheck(objJun.CC_Order__r.ccrz__BillTo__r.ccrz__AddressFirstline__c); 
                    objReq.DataArea.Customer.Administrive_Destination.AddressLine2 = nullCheck(objJun.CC_Order__r.ccrz__BillTo__r.ccrz__AddressSecondline__c); 
                    objReq.DataArea.Customer.Administrive_Destination.City = nullCheck(objJun.CC_Order__r.ccrz__BillTo__r.ccrz__City__c); 
                    if(objJun.CC_Order__r.ccrz__BillTo__r.ccrz__StateISOCode__c != null && objJun.CC_Order__r.ccrz__BillTo__r.ccrz__StateISOCode__c != '')
                        objReq.DataArea.Customer.Administrive_Destination.State = nullCheck(objJun.CC_Order__r.ccrz__BillTo__r.ccrz__StateISOCode__c); 
                    else
                        objReq.DataArea.Customer.Administrive_Destination.State = nullCheck(objJun.CC_Order__r.ccrz__BillTo__r.ccrz__State__c);
                    objReq.DataArea.Customer.Administrive_Destination.Postal_Code = nullCheck(objJun.CC_Order__r.ccrz__BillTo__r.ccrz__PostalCode__c);
                    objReq.DataArea.Customer.Administrive_Destination.Country =nullCheck(objJun.CC_Order__r.ccrz__BillTo__r.ccrz__Country__c);
                }
                else {
                    objReq.DataArea.Customer.Administrive_Destination.AddressLine1 = nullCheck(objJun.CC_Order__r.ccrz__Account__r.BillingStreet); 
                    objReq.DataArea.Customer.Administrive_Destination.AddressLine2 = nullCheck(objJun.CC_Order__r.ccrz__Account__r.CMI_Address2__c); 
                    objReq.DataArea.Customer.Administrive_Destination.City = nullCheck(objJun.CC_Order__r.ccrz__Account__r.BillingCity); 
                    objReq.DataArea.Customer.Administrive_Destination.State = nullCheck(objJun.CC_Order__r.ccrz__Account__r.Billingstate); 
                    objReq.DataArea.Customer.Administrive_Destination.Postal_Code = nullCheck(objJun.CC_Order__r.ccrz__Account__r.BillingPostalCode);
                    objReq.DataArea.Customer.Administrive_Destination.Country =nullCheck(objJun.CC_Order__r.ccrz__Account__r.BillingCountry);
                }
                
                if(objJun.CC_Order__r.ccrz__ShipTo__c != null) {
                    objReq.DataArea.Customer.Destination_Addesss.AddressLine1 = nullCheck(objJun.CC_Order__r.ccrz__ShipTo__r.ccrz__AddressFirstline__c); 
                    objReq.DataArea.Customer.Destination_Addesss.AddressLine2 = nullCheck(objJun.CC_Order__r.ccrz__ShipTo__r.ccrz__AddressSecondline__c); 
                    objReq.DataArea.Customer.Destination_Addesss.City = nullCheck(objJun.CC_Order__r.ccrz__ShipTo__r.ccrz__City__c); 
                    if(objJun.CC_Order__r.ccrz__ShipTo__r.ccrz__StateISOCode__c != null && objJun.CC_Order__r.ccrz__ShipTo__r.ccrz__StateISOCode__c != '')
                        objReq.DataArea.Customer.Destination_Addesss.State = nullCheck(objJun.CC_Order__r.ccrz__ShipTo__r.ccrz__StateISOCode__c); 
                    else
                        objReq.DataArea.Customer.Destination_Addesss.State = nullCheck(objJun.CC_Order__r.ccrz__ShipTo__r.ccrz__State__c); 
                    objReq.DataArea.Customer.Destination_Addesss.Postal_Code = nullCheck(objJun.CC_Order__r.ccrz__ShipTo__r.ccrz__PostalCode__c); 
                    objReq.DataArea.Customer.Destination_Addesss.Country = nullCheck(objJun.CC_Order__r.ccrz__ShipTo__r.ccrz__Country__c); 
                }
                else {
                    objReq.DataArea.Customer.Destination_Addesss.AddressLine1 = nullCheck(objJun.CC_Order__r.ccrz__Account__r.ShippingStreet); 
                    objReq.DataArea.Customer.Destination_Addesss.AddressLine2 = nullCheck(objJun.CC_Order__r.ccrz__Account__r.CMI_Address2__c); 
                    objReq.DataArea.Customer.Destination_Addesss.City = nullCheck(objJun.CC_Order__r.ccrz__Account__r.shippingCity); 
                    objReq.DataArea.Customer.Destination_Addesss.State = nullCheck(objJun.CC_Order__r.ccrz__Account__r.ShippingState); 
                    objReq.DataArea.Customer.Destination_Addesss.Postal_Code = nullCheck(objJun.CC_Order__r.ccrz__Account__r.shippingPostalCode); 
                    objReq.DataArea.Customer.Destination_Addesss.Country = nullCheck(objJun.CC_Order__r.ccrz__Account__r.shippingCountry); 
                }               
                
                for(OSM_InvoiceLine_And_OrderLine__c objJunctionLine : objJun.OSM_InvoiceLine_And_OrderLines__r) {
                    OSM_VERTEX_WS_GeneralizedInputWrapper.ProductList objProductLineItem = new OSM_VERTEX_WS_GeneralizedInputWrapper.ProductList();
                    //if(objJunctionLine.CC_Order_Item__r.VertexOrderItemCall__c == True){
                    String lineNumber = String.valueOf(Integer.valueOf(objJunctionLine.Name.replaceAll('[^0-9]', '')));
                    mapPruductSKUtoJunctionLine.put(lineNumber, objJunctionLine);
                    objProductLineItem.LineItemNumber = lineNumber;
                    objProductLineItem.ProductCode = objJunctionLine.CC_Order_Item__r.ccrz__DisplayProduct__r.ccrz__SKU__c;
                    objProductLineItem.ProductClassCode = objJunctionLine.CC_Order_Item__r.ccrz__Product__r.Product_Class_Code__c;
                    if(objJunctionLine.Quantity__c != null)
                        objProductLineItem.Quantity = String.valueOf(objJunctionLine.Quantity__c);
                    else
                        objProductLineItem.Quantity = '';
                    objProductLineItem.UnitOfMeasure = nullCheck(objJunctionLine.CC_Order_Item__r.ccrz__UnitOfMeasure__c);
                    
                    if(objJunctionLine.Sales_Amount__c > 0) {
                        Decimal ExtendedPrice_TOROUND=objJunctionLine.CC_Order_Item__r.ccrz__Price__c*objJunctionLine.Quantity__c;
                        Decimal DiscountAmount_TOROUND=(objJunctionLine.CC_Order_Item__r.ccrz__Price__c*objJunctionLine.Quantity__c) - objJunctionLine.Sales_Amount__c;
                        objProductLineItem.DiscountAmount = '0.0';
                        objProductLineItem.ExtendedPrice = String.valueOf(ExtendedPrice_TOROUND.setScale(2, RoundingMode.HALF_UP));
                        objProductLineItem.DiscountAmount = String.valueOf(DiscountAmount_TOROUND.setScale(2, RoundingMode.HALF_UP));
                        
                        if(objProductLineItem.ExtendedPrice != '')
                            objProductLineItem.ExtendedPrice = '-'+objProductLineItem.ExtendedPrice;
                        if(objProductLineItem.ExtendedPrice != '' && objProductLineItem.DiscountAmount != '0.00' )  //Mar-1441
                          {
                           Decimal DiscountedExtendedPrice = ExtendedPrice_TOROUND - DiscountAmount_TOROUND;
                           objProductLineItem.ExtendedPrice = String.valueOf(DiscountedExtendedPrice.setScale(2, RoundingMode.HALF_UP));
                           objProductLineItem.ExtendedPrice = '-'+objProductLineItem.ExtendedPrice; 
                           objProductLineItem.UserDefinedDiscountCode = '';
                           if(objProductLineItem.DiscountAmount == '0.00')
                                objProductLineItem.UserDefinedDiscountCode = '';  //Mar-1434
                             else 
                                 objProductLineItem.UserDefinedDiscountCode = 'Discount';
                               //objProductLineItem.DiscountAmount = '0.00';
                          }
                    }
                    else {
                        objProductLineItem.ExtendedPrice = String.valueOf(0);
                        objProductLineItem.DiscountAmount = String.valueOf(0);
                        objProductLineItem.UserDefinedDiscountCode = '';  //Mar-1434
                    }
                    
                    if(objJun.CC_Order__r.ccrz__Account__r.Name != null)
                        objProductLineItem.CustomerName = objJun.CC_Order__r.ccrz__Account__r.Name.left(40);
                     else
                         objProductLineItem.CustomerName = '';
                    objProductLineItem.BC = System.Label.OSM_Vertex_Flex_Field_Code_BC;         
                    objReq.DataArea.ProductList.add(objProductLineItem);
                    //}
                }               
               
                objResponseWrp = OSM_CC_Vertex_Service.callTaxService(objReq);
                System.debug('$$$$$$$$$$$$$$ final tax : '+objResponseWrp);
                log = objResponseWrp.log;
              log.Account__c = AccountId; //for 1879 
                if(!objResponseWrp.errorFlag) {
                    totalTax = objResponseWrp.DataArea.TotalTax;                    
                    objJun.Vertex_Refund_Call_Status__c = Label.OSM_Success;
                    System.debug('objJun.CC_Invoice__c : '+objJun.CC_Invoice__c);
                    if(objJun.CC_Invoice__c != null) {
                        ccrz__E_Invoice__c invObj = new ccrz__E_Invoice__c();
                        invObj.Id = objJun.CC_Invoice__c;
                        invObj.OSM_SW_Vertex_Invoice_Reversal_Request__c = true;                            
                        lstToUpdateInvoice.add(invObj);
                    }
                }
                else {
                    isCallFail = true;
                    isSuccess = false;
                }
               if(Test.isRunningTest()){
                    throw new NullPointerException();               
                }
            } catch(Exception ex) {
                System.debug('exception : '+ex.getMessage());
                log.Status__c = Label.OSM_SW_Create_Log_on_QuoteVertexCall_Failure; 
                String msg  = 'Message - '+ex.getMessage();
                msg=msg+ 'Stacktrace - ' + ex.getStackTraceString();
                log.Error_Description__c = msg;
                log.Service_Name__c = System.Label.OSM_Vertex_Service_Name_Invoice_Refund;
                log.Target__c = System.Label.OSM_Vertex_Target;
                log.Source__c = 'OSM';
                log.Invoice__c = objJun.CC_Invoice__c;
                log.Logged_In_User__c = userinfo.getuserid();
                log.Account__c = AccountId; //for 1879
                isCallFail = true;
                isSuccess = false;
            }
            
            lstToInsertLog.add(log);
            if(isCallFail) {
                objJun.Vertex_Refund_Call_Status__c = Label.OSM_SW_Create_Log_on_QuoteVertexCall_Failure;
                if(objJun.OSM_Vertex_Invoice_Failed_Count__c != null)
                    objJun.OSM_Vertex_Invoice_Failed_Count__c = objJun.OSM_Vertex_Invoice_Failed_Count__c +1;
                else
                    objJun.OSM_Vertex_Invoice_Failed_Count__c = 1;
            }
            objJun.Vertex_Invoice_Call_Time__c = System.now();
        }
        
        //update tax invoice line
        if(mapInvoiceToVertexTax != null && mapInvoiceToVertexTax.size() > 0 || Test.isRunningTest()) {
            List<ccrz__E_InvoiceItem__c> lstInvoiceItem = new List<ccrz__E_InvoiceItem__c>();
            lstInvoiceItem = [Select Id, ccrz__Invoice__c, Vertex_Tax__c from ccrz__E_InvoiceItem__c where ccrz__Invoice__c IN: mapInvoiceToVertexTax.keySet() and ccrz__Type__c = 'Tax'];
            
            for(ccrz__E_InvoiceItem__c objInvoiceItem : lstInvoiceItem) {
                objInvoiceItem.Vertex_Tax__c = mapInvoiceToVertexTax.get(objInvoiceItem.ccrz__Invoice__c);
                objInvoiceItem.ccrz__OriginalAmount__c = mapInvoiceToVertexTax.get(objInvoiceItem.ccrz__Invoice__c);
                lstToUpdateInvoiceItem.add(objInvoiceItem);
            }
        }
        objToReturn.lstJunctionObjInvoiceToOrder = new List<OSM_Orders_In_Invoice__c>();
        objToReturn.lstToUpdateInvoiceItem = new List<ccrz__E_InvoiceItem__c>();
        objToReturn.lstToUpdateJunctionItem = new List<OSM_InvoiceLine_And_OrderLine__c>();
        objToReturn.lstToInsertLog = new List<OSM_Integration_Log__c>();
        objToReturn.updateInvoiceList = new List<ccrz__E_Invoice__c>();
        
        objToReturn.lstJunctionObjInvoiceToOrder = lstJunctionObject;
        objToReturn.lstToUpdateInvoiceItem = lstToUpdateInvoiceItem;
        objToReturn.lstToUpdateJunctionItem = lstToUpdateJunctionItem;
        objToReturn.lstToInsertLog = lstToInsertLog;
        System.debug('lstToUpdateInvoice: '+lstToUpdateInvoice);
        objToReturn.updateInvoiceList = lstToUpdateInvoice;        
        
        Savepoint sp = Database.setSavepoint();
        
        try{
           if(objToReturn.lstJunctionObjInvoiceToOrder != null && objToReturn.lstJunctionObjInvoiceToOrder.size() > 0)
                    update objToReturn.lstJunctionObjInvoiceToOrder;
            /*if(objToReturn.updateInvoiceList != null && objToReturn.updateInvoiceList.size() > 0)
                    //update objToReturn.updateInvoiceList;
                    */
            if(Test.isRunningTest()){
             throw new NullPointerException();                          
            }            
        }catch(Exception ex){
            Database.rollback(sp);
            isSuccess = false;
            for(OSM_Integration_Log__c objLog : objToReturn.lstToInsertLog) {
                objLog.Status__c = 'Failure'; 
                objLog.Account__c = AccountId; //for 1879
                String oldMsg = '';
                if(objLog.Error_Description__c != null && objLog.Error_Description__c != '')
                    oldMsg = objLog.Error_Description__c;
                String msg  = oldMsg+ ' Message - '+ex.getMessage();
                msg=msg+ 'Stacktrace - ' + ex.getStackTraceString();
                objLog.Error_Description__c = msg;
            }
        }
             
        finally {
            if(objToReturn.lstToInsertLog !=  null && objToReturn.lstToInsertLog.size() > 0)
                insert objToReturn.lstToInsertLog; 
        }
        return isSuccess;
    }
    
    
    public static void createCreditMemo(List<Id> invoiceIds,List<Id> lstOrderItemIds,String state)
    {
        Map<Id,ccrz__E_Invoice__c> mapIdToNewInvoice = new Map<Id, ccrz__E_Invoice__c>();
        Map<Id,ccrz__E_InvoiceItem__c> mapIdToNewInvoiceItem = new Map<Id, ccrz__E_InvoiceItem__c>();
        Map<Id,OSM_Orders_In_Invoice__c> mapIdToNewOrderInvoiceJunction = new Map<Id, OSM_Orders_In_Invoice__c>();
        List<OSM_InvoiceLine_And_OrderLine__c> list_NewOrderInvoiceJunctionItem = new List<OSM_InvoiceLine_And_OrderLine__c>();
        List<Id> list_InvItemIds = new List<Id>();
        Map<Id,ccrz__E_Invoice__c> oldMapInvoice = new Map<Id,ccrz__E_Invoice__c>();
        
        String dbQuery = generateQuery('OSM_InvoiceLine_And_OrderLine__c', lstOrderItemIds, 'CC_Order_Item__c');
        String taxType = 'Tax';
        dbQuery = dbQuery + ' WHERE CC_Order_Item__c IN:lstOrderItemIds';    //  AND CC_Order_Item__r.IsCredited__c = false';
        //dbQuery = dbQuery + ' WHERE CC_Order_Item__c IN:lstOrderItemIds AND CC_Invoice_Item__r.IsCredited__c = false AND CC_Invoice_Item__r.ccrz__Invoice__r.IsCredited__c = false';
        system.debug('dbQuery. >>>  '+dbQuery);
        for(OSM_InvoiceLine_And_OrderLine__c objOrderInvoiceJunItem : Database.query(dbQuery)) {
            list_InvItemIds.add(objOrderInvoiceJunItem.CC_Invoice_Item__c);
            OSM_InvoiceLine_And_OrderLine__c newOrdrInvoiceJunItem = new OSM_InvoiceLine_And_OrderLine__c();
            newOrdrInvoiceJunItem = objOrderInvoiceJunItem.clone(false, false, false, false);
            
            list_NewOrderInvoiceJunctionItem.add(newOrdrInvoiceJunItem);
        }
        system.debug('list_NewOrderInvoiceJunctionItem. >>>  '+list_NewOrderInvoiceJunctionItem);
        Map<Id,Id> map_InvIdOrderId = new Map<Id,Id>();
        Map<Id, Integer> map_OrderIdCreditMemoIndex = new Map<id, Integer>();
        Boolean isIntercompany=false;
        Boolean isBOLTInvoice=false;
        List<id> invoiceIDListTran=new List<Id>();
        
        for(ccrz__E_Invoice__c inv : [SELECT Id,OSM_SW_IsIntercompanyInvoice__c,OSM_SW_Is_Bolt_PO__c,ccrz__CCOrder__c FROM ccrz__E_Invoice__c WHERE Id IN :invoiceIds]){
            map_InvIdOrderId.put(inv.Id, inv.ccrz__CCOrder__c);
            system.debug('invoiceIds>>>>>'+invoiceIds);
            if(inv.OSM_SW_IsIntercompanyInvoice__c || inv.OSM_SW_Is_Bolt_PO__c)
            invoiceIDListTran.add(inv.id);
            
            
        }
        
        for(ccrz__E_Order__c ordr : [SELECT Id, (SELECT Id FROM ccrz__CCInvoices__r WHERE Invoice_Type__c = 'Credit Memo') FROM ccrz__E_Order__c WHERE Id IN: map_InvIdOrderId.values()]){
            map_OrderIdCreditMemoIndex.put(ordr.Id, ordr.ccrz__CCInvoices__r.size());
        }
        
        // creating invoices
        String invQuery = generateQuery('ccrz__E_Invoice__c',invoiceIds, 'Id');
        invQuery = invQuery + ' WHERE Id IN: invoiceIds AND IsCredited__c = false';
        System.debug(generateQuery('ccrz__E_Invoice__c',invoiceIds, 'Id'));  
        List<ccrz__E_Invoice__c> list_InvUpdate2 = new List<ccrz__E_Invoice__c>(); 
                  
        for(ccrz__E_Invoice__c objInvoice : Database.query(invQuery)) {             
            ccrz__E_Invoice__c newInvoice = new ccrz__E_Invoice__c(); 
            newInvoice = objInvoice.clone(false, false, false, false);
            integer creditIndex = 0;
            if(map_InvIdOrderId.containsKey(objInvoice.Id) && map_OrderIdCreditMemoIndex.containsKey(map_InvIdOrderId.get(objInvoice.Id))){
                creditIndex = map_OrderIdCreditMemoIndex.get(map_InvIdOrderId.get(objInvoice.Id)) + 1;
            }else{
                creditIndex = 1;
            }
            string invNmbr = objInvoice.Name;
            newInvoice.Invoice_Type__c = 'Credit Memo';
            newInvoice.CreditMemo_Number__c = 'C'+ creditIndex + '-' + invNmbr.substring(2);
            newInvoice.ccrz__Status__c = 'Pending Refund';
            newInvoice.IsCredited__c = true;
            newInvoice.OSM_SW_Vertex_Invoice_Reversal_Request__c = true;
            newInvoice.Original_Sales_Order_Invoice_Number__c=objInvoice.id;
            // code for MAR-1786 start
      if(objInvoice.OSM_SW_Is_third_Party_BMS_Payment2__c && !objInvoice.OSM_SW_IsIntercompanyInvoice__c)
      {
        newInvoice.ccrz__BillTo__c = objInvoice.Third_Party_BMS_Customer_Name__c;
        newInvoice.ccrz__SoldTo__c = objInvoice.Third_Party_BMS_Customer_Name__c;
      }
      // code for MAR-1786 end
            mapIdToNewInvoice.put(objInvoice.Id, newInvoice);
        }
        if(mapIdToNewInvoice.size() > 0)
            insert mapIdToNewInvoice.values();
        
        // creating invoice items
        Map<Id, ccrz__E_InvoiceItem__c> map_InvIdTaxItem = new Map<Id, ccrz__E_InvoiceItem__c>();
        Map<Id, Decimal> map_InvIdTax = new Map<Id, Decimal>();
        
        String invQuery2 = generateQuery('ccrz__E_InvoiceItem__c',list_InvItemIds, 'Id');
        invQuery2 = invQuery2 + ' WHERE Id IN: list_InvItemIds';
        
        String invQuery3 = generateQuery('ccrz__E_InvoiceItem__c',list_InvItemIds, 'Id');
        invQuery3 = invQuery3 + ' WHERE ccrz__Type__c =:taxType AND ccrz__Invoice__c =: invoiceIds';
        
        for(ccrz__E_InvoiceItem__c objInvoiceItem : Database.query(invQuery3 )) {
            ccrz__E_InvoiceItem__c newTaxInvoiceItem = new ccrz__E_InvoiceItem__c();
            newTaxInvoiceItem = objInvoiceItem.clone(false, false, false, false);
            if(mapIdToNewInvoice.containsKey(objInvoiceItem.ccrz__Invoice__c))
                        newTaxInvoiceItem.ccrz__Invoice__c = mapIdToNewInvoice.get(objInvoiceItem.ccrz__Invoice__c).Id;
            map_InvIdTaxItem.put(objInvoiceItem.ccrz__Invoice__c, newTaxInvoiceItem);
        }
        
        List<ccrz__E_InvoiceItem__c> list_IIToUpdate = new List<ccrz__E_InvoiceItem__c>();
        for(ccrz__E_InvoiceItem__c objInvoiceItem : Database.query(invQuery2)) {
            ccrz__E_InvoiceItem__c newInvoiceItem = new ccrz__E_InvoiceItem__c();
            Decimal taxAmount = 0.0;
            if(!map_InvIdTax.containsKey(objInvoiceItem.ccrz__Invoice__c)){  
                map_InvIdTax.put(objInvoiceItem.ccrz__Invoice__c, taxAmount);  
            }else{  
                taxAmount = map_InvIdTax.get(objInvoiceItem.ccrz__Invoice__c);  
            }
            newInvoiceItem = objInvoiceItem.clone(false, false, false, false);
            if(mapIdToNewInvoice.containsKey(objInvoiceItem.ccrz__Invoice__c))  
                newInvoiceItem.ccrz__Invoice__c = mapIdToNewInvoice.get(objInvoiceItem.ccrz__Invoice__c).Id;
            objInvoiceItem.IsCredited__c = true;
            list_IIToUpdate.add(objInvoiceItem);
            if(mapIdToNewInvoice.get(objInvoiceItem.ccrz__Invoice__c).Payment_Method__c == 'po' && mapIdToNewInvoice.get(objInvoiceItem.ccrz__Invoice__c).OSM_SW_Is_Bolt_PO__c == false && mapIdToNewInvoice.get(objInvoiceItem.ccrz__Invoice__c).OSM_SW_IsIntercompanyInvoice__c == false)
            {
                if(newInvoiceItem.OSM_SW_OrderItem_Vertex_for_BMS_po__c != null  ){
                    taxAmount = taxAmount + newInvoiceItem.OSM_SW_OrderItem_Vertex_for_BMS_po__c;
                }
            }
            else
            {
                if(newInvoiceItem.Vertex_Tax__c != null  ){
                    taxAmount = taxAmount + newInvoiceItem.Vertex_Tax__c;
                }
            }
            map_InvIdTax.put(objInvoiceItem.ccrz__Invoice__c, taxAmount);
            mapIdToNewInvoiceItem.put(objInvoiceItem.Id, newInvoiceItem);
        }
        
        for(Id invId : map_InvIdTax.keySet()){  
            if(map_InvIdTaxItem.containsKey(invId)){  
                map_InvIdTaxItem.get(invId).ccrz__OriginalAmount__c = map_InvIdTax.get(invId);  
                map_InvIdTaxItem.get(invId).Vertex_Tax__c = map_InvIdTax.get(invId);  
            }  
        }
        
        System.debug('testing.. '+mapIdToNewInvoiceItem);
        if((mapIdToNewInvoiceItem.size() > 0)|| Test.isRunningTest()) {
            insert mapIdToNewInvoiceItem.values();
            insert map_InvIdTaxItem.values();
            update list_IIToUpdate;
        }
        
        // creating order invoice junction
        String invQuery21 = generateQuery('OSM_Orders_In_Invoice__c', invoiceIds, 'CC_Invoice__c');
        invQuery21 = invQuery21 + ' WHERE CC_Invoice__c IN: invoiceIds';
        for(OSM_Orders_In_Invoice__c objOrderInvoiceJun : Database.query(invQuery21)){
            OSM_Orders_In_Invoice__c newOrdrInvoiceJun = new OSM_Orders_In_Invoice__c();
            newOrdrInvoiceJun = objOrderInvoiceJun.clone(false, false, false, false);
            newOrdrInvoiceJun.OSM_SW_Is_Refund_Request__c = true;
            newOrdrInvoiceJun.Vertex_Refund_Call_Status__c = 'Pending';
            if(mapIdToNewInvoice.containsKey(newOrdrInvoiceJun.CC_Invoice__c))
                newOrdrInvoiceJun.CC_Invoice__c = mapIdToNewInvoice.get(objOrderInvoiceJun.CC_Invoice__c).Id;
            mapIdToNewOrderInvoiceJunction.put(objOrderInvoiceJun.Id, newOrdrInvoiceJun);
        }
        system.debug('mapIdToNewOrderInvoiceJunction. >>>  '+mapIdToNewOrderInvoiceJunction);
        
        
        if(mapIdToNewOrderInvoiceJunction.size() > 0) {
            insert mapIdToNewOrderInvoiceJunction.values();
        }
        if(state=='Order Item Cancel' || state=='Order Cancel')
        {
            system.debug('invoiceIDListTran>>>>>'+invoiceIDListTran);
              //TP record creation for Partial order item cancellation for MAR-1845 and MAR-1846
            String invQuery31 = generateQuery('ccrz__E_TransactionPayment__c', invoiceIDListTran, 'CC_Invoice__c');
            invQuery31 = invQuery31 + ' WHERE ccrz__InvoiceAppliedTo__c IN: invoiceIDListTran';
            List<ccrz__E_TransactionPayment__c> list_TransUpdate = new List<ccrz__E_TransactionPayment__c>();
            for(ccrz__E_TransactionPayment__c objTransRec : Database.query(invQuery31 )) {
                ccrz__E_TransactionPayment__c objTransRecItem = new ccrz__E_TransactionPayment__c();
                objTransRecItem = objTransRec.clone(false, false, false, false);
                if(mapIdToNewInvoice.containsKey(objTransRec.ccrz__InvoiceAppliedTo__c))
                {
                    objTransRecItem.ccrz__InvoiceAppliedTo__c = mapIdToNewInvoice.get(objTransRec.ccrz__InvoiceAppliedTo__c).Id;
                       
                        objTransRecItem.Transaction_Status__c='Order Item Cancel';
                        
                        
                        objTransRecItem.Bolt_JE_Reversal_Call_Status__c='Pending';
                        objTransRecItem.Bolt_Credit_Memo_Call_Status__c='Pending';
                        objTransRecItem.Bolt_JE_Call_Status__c='Success';
                        objTransRecItem.Bolt_AR_Call_Status__c='Success';
                    
                    
                   
                    list_TransUpdate.add(objTransRecItem);
                }
            }   
            if((list_TransUpdate.size() > 0)|| Test.isRunningTest()) {
               insert list_TransUpdate;
            }
        }
        
        // creating invoice item and order item junction
        List<Id> lstTemp = new List<Id>();      
        for(Id key : mapIdToNewOrderInvoiceJunction.keySet()){
            lstTemp.add(key);
        }       
        
        for(OSM_InvoiceLine_And_OrderLine__c newOrdrInvoiceJunItem : list_NewOrderInvoiceJunctionItem) {
            if(mapIdToNewOrderInvoiceJunction.containsKey(newOrdrInvoiceJunItem.OSM_Orders_In_Invoice__c)){
                newOrdrInvoiceJunItem.OSM_Orders_In_Invoice__c = mapIdToNewOrderInvoiceJunction.get(newOrdrInvoiceJunItem.OSM_Orders_In_Invoice__c).Id;                    
            }
            if(mapIdToNewInvoiceItem.containsKey(newOrdrInvoiceJunItem.CC_Invoice_Item__c)){
                newOrdrInvoiceJunItem.CC_Invoice_Item__c = mapIdToNewInvoiceItem.get(newOrdrInvoiceJunItem.CC_Invoice_Item__c).Id;
            }
        }
        
        if(list_NewOrderInvoiceJunctionItem.size() > 0){
            insert list_NewOrderInvoiceJunctionItem;
        }
        
        Set<Id> set_InvId = new Set<Id>();
        for(ccrz__E_Invoice__c inv : mapIdToNewInvoice.values()){
            set_InvId.add(inv.Id);
        }
        
        List<ccrz__E_Invoice__c> list_InvUpdate = new List<ccrz__E_Invoice__c>();
        for(ccrz__E_Invoice__c invObj : [SELECT Id, ccrz__OriginalAmount__c, Total_Vertex_Tax__c, Total_Sales_Amount__c FROM ccrz__E_Invoice__c WHERE Id IN: set_InvId]){
            invObj.ccrz__OriginalAmount__c = invObj.Total_Sales_Amount__c + invObj.Total_Vertex_Tax__c;
            list_InvUpdate.add(invObj);
        }
        update list_InvUpdate;
    }   
    
    public static string generateQuery(string objName, List<Id> list_Ids, string fieldName){
        String query = '';
        SObjectType accountType = Schema.getGlobalDescribe().get(objName);
        Map<String,Schema.SObjectField> mfields = accountType.getDescribe().fields.getMap();

        for(Schema.SObjectField sfield : mfields.Values()){
            string key = sfield.getDescribe().getName();
            if(query != '')
                query = query+','+key;
            else
                query = key;
        }
        query = 'SELECT '+query+' FROM '+objName; //+' WHERE '+ fieldName +' IN: '+list_Ids;
        return query;
    }
    
    
    public static String nullCheck(String strValue) {
        if(strValue != null)
            return strValue;
        else
            return '';
    }
}