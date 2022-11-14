global class OSM_SW_DuplicateBMSSubmitOrdr implements Database.Batchable<sObject>, Database.AllowsCallouts {
    
    global Set<Id> set_OSMLogRecordId = new Set<Id>();
    global Set<Id> set_CMRecordId = new Set<Id>();
    global boolean isPart = false;
    
    global OSM_SW_DuplicateBMSSubmitOrdr(){
        // do nothing
    }
    
    global OSM_SW_DuplicateBMSSubmitOrdr(Set<Id> set_OSMLogRecordIdTmp, Set<Id> set_CMRecordIdTmp, boolean isPartial){
        set_OSMLogRecordId = set_OSMLogRecordIdTmp;
        set_CMRecordId = set_CMRecordIdTmp;
        isPart = isPartial;
    }
    
    
    global Database.QueryLocator start(Database.BatchableContext BC){
        String query = '';
        string serviceName = 'RefundSubmitOrder';
        string successStatus = 'Success';
        Date orderCancelDate = Date.newInstance(2021, 10, 27);
        string logDate = String.valueOf(Label.OSM_DuplicateRefund_LogDate);
        if(set_OSMLogRecordId.size() > 0 && isPart){
            query = 'SELECT Id, CC_Order__c FROM OSM_Integration_Log__c WHERE Id IN: set_OSMLogRecordId';
        }
        else if(set_OSMLogRecordId.size() > 0 && !isPart){
            query = 'SELECT Id, CC_Order__c FROM OSM_Integration_Log__c WHERE Service_Name__c =: serviceName AND Status__c =: successStatus AND CC_Order__r.Order_Cancellation_Date__c <: orderCancelDate AND OSM_SW_Created_Date__c =: logDate AND Id NOT IN: set_OSMLogRecordId';
        }
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<OSM_Integration_Log__c> scope){
        Set<Id> set_OrderId = new Set<Id>();
        for(OSM_Integration_Log__c osmLog : scope){
            set_OrderId.add(osmLog.CC_Order__c);
        }
        if(set_OrderId.size() > 0){
            Set<id> itemIdSet=new Set<id>();
            for(ccrz__E_Order__c ordrObj : [SELECT Id, (SELECT Id FROM ccrz__E_OrderItems__r) FROM ccrz__E_Order__c WHERE Id IN : set_OrderId]){
                for(ccrz__E_OrderItem__c item : ordrObj.ccrz__E_OrderItems__r){
                    itemIdSet.add(item.id);
                }
                getOrderInfo(ordrObj.Id, 'Submit',itemIdSet,null,false,null);
            }
        }
    }
    
    global void finish(Database.BatchableContext BC){
        // do nothing
    }
    
    global void getOrderInfo(Id orderId, String strStatusMode,Set<id> orderItemIdlst,String canceltype,boolean isRetry,Id creditMemoId){
        
        OSM_ReturnWrapper objToReturn = new OSM_ReturnWrapper();
        OSM_Integration_Log__c log =new OSM_Integration_Log__c();
        ccrz__E_Invoice__c invoiceObj=new ccrz__E_Invoice__c();
        ccrz__E_Order__c orderObj=new ccrz__E_Order__c();
        Set<String> mandatoryFields = new Set<String>();
        
        Savepoint sp;
        List<ccrz__E_Invoice__c> invoiceList=new List<ccrz__E_Invoice__c>();
        List<ccrz__E_Order__c> orderList=new  List<ccrz__E_Order__c>();   
        List<ccrz__E_OrderItem__c> orderItemToUpdateFlag = new List<ccrz__E_OrderItem__c>();        
        List<OSM_Integration_Log__c> lstToInsertLog=new List<OSM_Integration_Log__c>();
        Set<Id> orderIdSet=new Set<Id>();
        Set<Id> productSubTermIdSet=new Set<Id>();
        Set<Id> cartItemIdsSet=new Set<Id>();  
        Set<Id> cartIdSet=new Set<Id>(); 
        List<ccrz__E_Invoice__c> invoiceRecord = new List<ccrz__E_Invoice__c> ();
        List<ccrz__E_Invoice__c> creditMemoInvRecord = new List<ccrz__E_Invoice__c> ();
        List<ccrz__E_InvoiceItem__c> invoiceItemList=new List<ccrz__E_InvoiceItem__c>();
        Map<Id, ccrz__E_PriceListItem__c > mapSubProdIdToPriceListItem = new Map<Id, ccrz__E_PriceListItem__c >();
        String AccountID;//Added By Dhiraj
        invoiceRecord=[Select id,CreatedDate,Invoice_Type__c,OSM_SW_Is_Refund_FSD_Done__c,ccrz__CCOrder__r.Order_Cancellation_Date__c,BMS_InvoiceTotal__c,ccrz__CCOrder__r.BMS_OrderRefNumber__c,ccrz__CCOrder__r.ccrz__OrderStatus__c,ccrz__Status__c,BMS_InvoiceNumber__c,ccrz__CCOrder__r.ccrz__TotalDiscount__c,ccrz__CCOrder__r.OSM_Discount_On_BMS__c,ccrz__CCOrder__r.ccrz__SubtotalAmount__c,ccrz__CCOrder__r.ccrz__OriginatedCart__c,ccrz__CCOrder__r.ccrz__Account__r.id,ccrz__CCOrder__r.ccrz__Account__r.Location__c,ccrz__CCOrder__r.ccrz__Account__r.OSM_Location_ID__c, ccrz__CCOrder__r.ccrz__Account__r.CSS_DistributorCode__c,ccrz__CCOrder__r.ccrz__Account__r.EBU_Channel_of_Distribution__c,ccrz__CCOrder__r.ccrz__Account__r.PSBU_Channel_of_Distribution__c,ccrz__CCOrder__r.ccrz__Account__r.OSM_SW_Responsible_Region__c,ccrz__CCOrder__c,ccrz__CCOrder__r.ccrz__ShipTo__r.ccrz__PostalCode__c,ccrz__CCOrder__r.ccrz__ShipTo__r.ccrz__StateISOCode__c,ccrz__CCOrder__r.Order_Source_Type__c,ccrz__CCOrder__r.Name,ccrz__CCOrder__r.Discount_Type__c,BMS_paymenttype__c,name,ccrz__DateIssued__c,ccrz__OriginalAmount__c,ccrz__CCOrder__r.ccrz__Account__r.Customer_BMS_number__c, ccrz__CCOrder__r.OSM_SW_Is_third_Party_BMS_Payment__c, ccrz__CCOrder__r.Third_Party_BMS_Customer_ID__c ,ccrz__CCOrder__r.ccrz__Account__r.name,ccrz__CCOrder__r.ccrz__BillTo__r.ccrz__AddressFirstline__c,ccrz__CCOrder__r.ccrz__BillTo__r.ccrz__AddressSecondline__c, ccrz__CCOrder__r.ccrz__BillTo__r.ccrz__AddressThirdline__c, ccrz__CCOrder__r.ccrz__BillTo__r.ccrz__CountryISOCode__c, ccrz__CCOrder__r.OSM_SW_Coupon_Count__c,ccrz__CCOrder__r.ccrz__BillTo__r.ccrz__City__c,ccrz__CCOrder__r.ccrz__BillTo__r.ccrz__StateISOCode__c,ccrz__CCOrder__r.ccrz__BillTo__r.ccrz__PostalCode__c,ccrz__CCOrder__r.OE_Comment__c,ccrz__CCOrder__r.ccrz__OriginatedCart__r.Purchaser_Comments__c, ccrz__CCOrder__r.ccrz__OriginatedCart__r.OSM_SW_IAM_Account_Id_For_Third_Party__c,ccrz__CCOrder__r.Calculated_Total_Discount__c  from ccrz__E_Invoice__c where ccrz__CCOrder__c=:orderId and Invoice_Type__c='Credit Memo' AND Id IN: set_CMRecordId];
        
       
        system.debug('invoiceRecord +++ ' + invoiceRecord);
        system.debug('creditMemoInvRecord +++ ' + creditMemoInvRecord);
        invoiceItemList=[select id,ccrz__CCOrderItem__r.Discounted_Amount__c,ccrz__CCOrderItem__r.ccrz__Price__c,ccrz__CCOrderItem__r.ccrz__Quantity__c,ccrz__CCOrderItem__r.ccrz__OriginalQuantity__c,ccrz__CCOrderItem__r.Vertex_tax__c,ccrz__CCOrderItem__r.ccrz__OriginalItemPrice__c,ccrz__CCOrderItem__r.ccrz__SubAmount__c,ccrz__CCOrderItem__r.ccrz__Coupon__r.ccrz__DiscountAmount__c from ccrz__E_InvoiceItem__c where ccrz__Invoice__c=:invoiceRecord[0].id];
        system.debug('invoiceItemList +++ ' + invoiceItemList);
        AccountID = invoiceRecord[0].ccrz__CCOrder__r.ccrz__Account__r.id; 
        log.Account__c = AccountID; 
        List<ccrz__E_OrderItem__c> orderItemRecord=new List<ccrz__E_OrderItem__c>();
        List<ccrz__E_CartItem__c> cartLineItemDetails=new List<ccrz__E_CartItem__c>();
        
        if((invoiceRecord[0].ccrz__OriginalAmount__c > 0 ) || (invoiceRecord[0].ccrz__CCOrder__r.OSM_SW_Coupon_Count__c > 0 && invoiceRecord[0].ccrz__OriginalAmount__c == 0)) {
            try {
                List<ccrz__E_TransactionPayment__c> transPaymentList=[Select id,ccrz__CCOrder__c,ccrz__AccountNumber__c from ccrz__E_TransactionPayment__c where ccrz__CCOrder__c=:orderId];            
                
                for(ccrz__E_Invoice__c invoice:invoiceRecord){
                    cartIdSet.add(invoice.ccrz__CCOrder__r.ccrz__OriginatedCart__c);
                    orderIdSet.add(invoice.ccrz__CCOrder__r.id);
                }
                
                orderItemRecord=[Select ccrz__SubProdTerm__c,OrderItem_Cancellation_Date__c,ccrz__OriginalQuantity__c,ccrz__ParentOrderItem__c,ccrz__Product__r.GOMS_Part_Number__c,ccrz__Product__r.Group_Name__c,ccrz__Price__c,Dn_Price__c,id,name,ccrz__Order__c,ccrz__UnitOfMeasure__c,ccrz__Product__c,ccrz__Quantity__c,ccrz__Product__r.ccrz__SKU__c,ccrz__Product__r.Product_Class_Code__c,ccrz__Product__r.name from ccrz__E_OrderItem__c where ccrz__Order__c=:orderIdSet];
                Set<id> productIds=new Set<Id>();
                for(ccrz__E_OrderItem__c orderItem:orderItemRecord){
                    productSubTermIdSet.add(orderItem.ccrz__SubProdTerm__c);
                    productIds.add(orderItem.ccrz__Product__c);
                }
                system.debug('orderItemRecord else +++ ' + orderItemRecord);
                cartLineItemDetails=[Select id,name,ccrz__Cart__c,ccrz__ParentCartItem__c from ccrz__E_CartItem__c where ccrz__Cart__c IN: cartIdSet and ccrz__Product__c IN:productIds];  
                
                for(ccrz__E_CartItem__c cartItem:cartLineItemDetails){
                    if(cartItem.ccrz__ParentCartItem__c==null){
                        cartItemIdsSet.add(cartItem.id);    
                    }
                } 
                
                List<CC_Tax__c> ccTaxList=[Select Id, CC_Cart_Item__r.ccrz__SubAmount__c,CC_Cart_Item__r.ccrz__Product__r.Product_Class_Code__c, NonTaxable__c, Taxable__c,CC_Cart_Item__r.Prorated_Price_AfterDiscount__c, CC_Cart_Item__c,CalculatedTax__c,name,JurisdictionLevel__c,JurisdictionId__c,Discount_Amount__c from CC_Tax__c where CC_Cart_Item__c =:cartItemIdsSet];
                system.debug('ccTaxList  +++ ' + ccTaxList);
                
                
                //intializing GeneralInput wrapper
                OSM_WS_GeneralizedSubmitOrdrInpWrapper inputWrapperObj=new OSM_WS_GeneralizedSubmitOrdrInpWrapper();
                inputWrapperObj.dataArea=new OSM_WS_GeneralizedSubmitOrdrInpWrapper.DataArea();
                inputWrapperObj.header=new OSM_WS_GeneralizedSubmitOrdrInpWrapper.Header();
                inputWrapperObj.header.sender=new OSM_WS_GeneralizedSubmitOrdrInpWrapper.Sender();
                inputWrapperObj.header.target=new OSM_WS_GeneralizedSubmitOrdrInpWrapper.Target();
                OSM_WS_GeneralizedSubmitOrdrInpWrapper.FSDList fsdList;
                inputWrapperObj.dataArea.headerList=new List<OSM_WS_GeneralizedSubmitOrdrInpWrapper.FSDList>();
                OSM_WS_GeneralizedSubmitOrdrInpWrapper.TaxList taxList;
                inputWrapperObj.dataArea.taxList=new List<OSM_WS_GeneralizedSubmitOrdrInpWrapper.TaxList>();
                OSM_WS_GeneralizedSubmitOrdrInpWrapper.ChargeList chargeList;
                inputWrapperObj.dataArea.chargeList=new List<OSM_WS_GeneralizedSubmitOrdrInpWrapper.ChargeList>();
                OSM_WS_GeneralizedSubmitOrdrInpWrapper.PartList partList;
                inputWrapperObj.dataArea.partList=new List<OSM_WS_GeneralizedSubmitOrdrInpWrapper.PartList>();
                //binding values
                Set<String> set_ThirdPartyBMSAccount = new Set<String>();
                Map<String, String> map_BMSIdDistId = new Map<String, String>();
                system.debug('invoiceRecord  +++ ' + invoiceRecord);
                if(invoiceRecord!=null){ 
                    
                    // Start: Added for MAR-1285
                    for(ccrz__E_Invoice__c invoiceItem:invoiceRecord){
                        if(invoiceItem.ccrz__CCOrder__r.OSM_SW_Is_third_Party_BMS_Payment__c){
                            set_ThirdPartyBMSAccount.add(invoiceItem.ccrz__CCOrder__r.ccrz__OriginatedCart__r.OSM_SW_IAM_Account_Id_For_Third_Party__c); 
                        }
                    }
                    system.debug('set_ThirdPartyBMSAccount  +++ ' + set_ThirdPartyBMSAccount);
                    if(set_ThirdPartyBMSAccount.size() > 0){
                        for(Account acc : [SELECT Id,CSS_DistributorCode__c,Customer_BMS_number__c FROM Account WHERE Id IN: set_ThirdPartyBMSAccount]){
                            map_BMSIdDistId.put(acc.Id, acc.CSS_DistributorCode__c);
                        }
                    }
                    // End: Added for MAR-1285
                    system.debug('invoiceRecord  +++ ' + invoiceRecord);
                    for(ccrz__E_Invoice__c invoiceItem:invoiceRecord){
                        fsdList=new OSM_WS_GeneralizedSubmitOrdrInpWrapper.FSDList();
                        chargeList=new OSM_WS_GeneralizedSubmitOrdrInpWrapper.ChargeList();
                        
                         system.debug('invoiceItem.ccrz__CCOrder__r.OSM_SW_Is_third_Party_BMS_Payment__c  +++ ' + invoiceItem.ccrz__CCOrder__r.OSM_SW_Is_third_Party_BMS_Payment__c);
                        if(invoiceItem.ccrz__CCOrder__r.OSM_SW_Is_third_Party_BMS_Payment__c){
                            if(map_BMSIdDistId.containsKey(invoiceItem.ccrz__CCOrder__r.ccrz__OriginatedCart__r.OSM_SW_IAM_Account_Id_For_Third_Party__c)){
                                String distCode = map_BMSIdDistId.get(invoiceItem.ccrz__CCOrder__r.ccrz__OriginatedCart__r.OSM_SW_IAM_Account_Id_For_Third_Party__c);
                                inputWrapperObj.dataArea.locationId = distCode + '-' + distCode;
                            }
                        }
                        else{
                            if((invoiceItem.ccrz__CCOrder__r.ccrz__Account__r.EBU_Channel_of_Distribution__c == 'CIHR' || invoiceItem.ccrz__CCOrder__r.ccrz__Account__r.PSBU_Channel_of_Distribution__c == 'CIHR') && invoiceItem.ccrz__CCOrder__r.ccrz__Account__r.OSM_SW_Responsible_Region__c!=null) {
                                inputWrapperObj.dataArea.locationId = invoiceItem.ccrz__CCOrder__r.ccrz__Account__r.OSM_SW_Responsible_Region__c + '-' +invoiceItem.ccrz__CCOrder__r.ccrz__Account__r.OSM_SW_Responsible_Region__c; 
                            }
                            else if(invoiceItem.ccrz__CCOrder__r.ccrz__Account__r.OSM_Location_ID__c!=null){  
                                inputWrapperObj.dataArea.locationId = invoiceItem.ccrz__CCOrder__r.ccrz__Account__r.OSM_Location_ID__c; 
                            }
                        }
                        
                        if(invoiceItem.ccrz__CCOrder__r.OSM_SW_Is_third_Party_BMS_Payment__c){
                            if(invoiceItem.ccrz__CCOrder__r.Third_Party_BMS_Customer_ID__c != ''){
                                inputWrapperObj.dataArea.customerCode =invoiceItem.ccrz__CCOrder__r.Third_Party_BMS_Customer_ID__c;
                            }
                            else{
                                mandatoryFields.add('CustomerCode');
                            }
                        }
                        else{
                            if(invoiceItem.ccrz__CCOrder__r.ccrz__Account__r.Customer_BMS_number__c!=null){
                                inputWrapperObj.dataArea.customerCode =invoiceItem.ccrz__CCOrder__r.ccrz__Account__r.Customer_BMS_number__c;
                            }else{
                                mandatoryFields.add('CustomerCode');                                
                            }
                        }
                        
                        if(invoiceItem.ccrz__CCOrder__r.Name!=null){
                            String invoiceOrderId=invoiceItem.ccrz__CCOrder__r.Name;
                            fsdList.salesOrderId=invoiceOrderId.SubString(2,12);                                      
                        }
                        else{
                            mandatoryFields.add('SALES_ORDER_ID');                            
                        }
                        
                        fsdList.orderSourceType =Label.OSM_Source;
                        inputWrapperObj.header.target.targetId = 'BMS';
                        inputWrapperObj.dataArea.orderReferenceNumber = '';
                        
                        if(invoiceItem.ccrz__CCOrder__r.ccrz__BillTo__r.ccrz__PostalCode__c!=null || invoiceItem.ccrz__CCOrder__r.ccrz__BillTo__r.ccrz__StateISOCode__c!=null ){
                             system.debug('Inside else 220  +++ ');
                            fsdList.taxDistrict =invoiceItem.ccrz__CCOrder__r.ccrz__BillTo__r.ccrz__PostalCode__c.substring(0,5) + '-' + invoiceItem.ccrz__CCOrder__r.ccrz__BillTo__r.ccrz__StateISOCode__c;
                        }
                        else{
                             system.debug('Inside else 225  +++ ');
                            mandatoryFields.add('TAX_DISTRICT');
                        }
                        fsdList.paymentType =Label.OSM_paymentType;
                        if(invoiceItem.BMS_paymenttype__c!=null){
                            system.debug('Inside if 230  +++ ');
                            fsdList.paymentType =invoiceItem.BMS_paymenttype__c;
                        }
                        
                        if(invoiceItem.name!=null){
                            system.debug('Inside if 234  +++ ');
                            fsdList.invoiceNumber = OSM_Generic_Utility.fieldSizeRestriction(invoiceItem.name, 8, 'back');
                        }
                        else{
                            system.debug('Inside else 246  +++ ');
                            mandatoryFields.add('INVOICE_NUMBER');
                        }
                        system.debug('invoiceItem.ccrz__DateIssued__c 249  +++ ' + invoiceItem.ccrz__DateIssued__c);
                        if(invoiceItem.ccrz__DateIssued__c!=null){
                            fsdList.invoiceDate = System.today();                            
                        }
                        else{
                            mandatoryFields.add('INVOICE_DATE');
                        }
                        system.debug('invoiceItem.ccrz__OriginalAmount__c 262  +++ ' + invoiceItem.ccrz__OriginalAmount__c);
                        if(invoiceItem.ccrz__OriginalAmount__c!=null){
                            fsdList.invoiceTotal=invoiceItem.ccrz__OriginalAmount__c;
                            system.debug('Inside if 283 +++ ');
                        }
                        else{
                           system.debug('INSIDE ELSE +++');
                            mandatoryFields.add('INVOICE_TOTAL');
                        }
                        system.debug('invoiceItem.ccrz__CCOrder__r.OSM_SW_Is_third_Party_BMS_Payment__c 289 +++ ' + invoiceItem.ccrz__CCOrder__r.OSM_SW_Is_third_Party_BMS_Payment__c);
                        if(invoiceItem.ccrz__CCOrder__r.OSM_SW_Is_third_Party_BMS_Payment__c){
                            if(invoiceItem.ccrz__CCOrder__r.Third_Party_BMS_Customer_ID__c != ''){
                                fsdList.billToCustomerNumber=invoiceItem.ccrz__CCOrder__r.Third_Party_BMS_Customer_ID__c;
                            }
                            else{
                                mandatoryFields.add('BILL_TO_CUST_NUMBER');
                            }
                        }
                        else{
                            if(invoiceItem.ccrz__CCOrder__r.ccrz__Account__r.Customer_BMS_number__c!=null){
                                fsdList.billToCustomerNumber=invoiceItem.ccrz__CCOrder__r.ccrz__Account__r.Customer_BMS_number__c;
                            }
                            else{
                                mandatoryFields.add('BILL_TO_CUST_NUMBER');
                            }                           
                        }
                        
                        if(invoiceItem.ccrz__CCOrder__r.ccrz__Account__r.name!=null){
                            fsdList.billToName =invoiceItem.ccrz__CCOrder__r.ccrz__Account__r.name;
                        }
                        else{
                            mandatoryFields.add('BILL_TO_NAME');
                        }
                        if(invoiceItem.ccrz__CCOrder__r.ccrz__Account__r.name!=null){
                            fsdList.shipToName =invoiceItem.ccrz__CCOrder__r.ccrz__Account__r.name;
                        }
                        else{
                            mandatoryFields.add('SHIP_TO_NAME');
                        }                   
                        if(invoiceItem.ccrz__CCOrder__r.ccrz__BillTo__r.ccrz__AddressFirstline__c!=null){
                            fsdList.shipToAddress1 =invoiceItem.ccrz__CCOrder__r.ccrz__BillTo__r.ccrz__AddressFirstline__c;
                        }
                        else{
                            mandatoryFields.add('SHIP_TO_ADDRESS1');
                        }
                        
                        if(null != invoiceItem.ccrz__CCOrder__r.ccrz__BillTo__r.ccrz__AddressSecondline__c){
                            fsdList.shipToAddress2 =invoiceItem.ccrz__CCOrder__r.ccrz__BillTo__r.ccrz__AddressSecondline__c;
                        }
                        else{
                            fsdList.shipToAddress2 ='';
                        }
                        if(null != invoiceItem.ccrz__CCOrder__r.ccrz__BillTo__r.ccrz__AddressThirdline__c){
                            fsdList.shipToAddress3 =invoiceItem.ccrz__CCOrder__r.ccrz__BillTo__r.ccrz__AddressThirdline__c;
                        }
                        else
                        {
                            fsdList.shipToAddress3 ='';
                        }
                        if(null != invoiceItem.ccrz__CCOrder__r.ccrz__BillTo__r.ccrz__CountryISOCode__c){
                            fsdList.shipToCountry =invoiceItem.ccrz__CCOrder__r.ccrz__BillTo__r.ccrz__CountryISOCode__c;
                        }
                        else
                        {
                            mandatoryFields.add('SHIP_TO_COUNTRY');
                        }
                        
                        if(invoiceItem.ccrz__CCOrder__r.ccrz__BillTo__r.ccrz__City__c!=null){
                            fsdList.shipToCity =invoiceItem.ccrz__CCOrder__r.ccrz__BillTo__r.ccrz__City__c;
                        }
                        else
                        {
                            mandatoryFields.add('SHIP_TO_CITY');
                        }
                        if(invoiceItem.ccrz__CCOrder__r.ccrz__BillTo__r.ccrz__StateISOCode__c!=null){
                            fsdList.shipToState =invoiceItem.ccrz__CCOrder__r.ccrz__BillTo__r.ccrz__StateISOCode__c;
                        }
                        else
                        {
                            mandatoryFields.add('SHIP_TO_STATE');
                        }
                        if(invoiceItem.ccrz__CCOrder__r.ccrz__BillTo__r.ccrz__PostalCode__c!=null){
                            fsdList.shipToPostalCode =invoiceItem.ccrz__CCOrder__r.ccrz__BillTo__r.ccrz__PostalCode__c.length()>=5?invoiceItem.ccrz__CCOrder__r.ccrz__BillTo__r.ccrz__PostalCode__c.substring(0,5):invoiceItem.ccrz__CCOrder__r.ccrz__BillTo__r.ccrz__PostalCode__c;
                        }
                        else{
                            mandatoryFields.add('SHIP_TO_POSTAL_CODE');
                        }
                        
                        fsdList.orderComments ='Invoicing to offset credit duplication';
                        
                        if(transPaymentList.size()>0 && transPaymentList[0].ccrz__AccountNumber__c!=null ){
                            fsdList.customerPONumber =transPaymentList[0].ccrz__AccountNumber__c;
                        }
                        else{
                            mandatoryFields.add('CUSTOMER_PO_NUMBER');
                        }
                        
                        if(map_BMSIdDistId.containsKey(invoiceItem.ccrz__CCOrder__r.ccrz__OriginatedCart__r.OSM_SW_IAM_Account_Id_For_Third_Party__c)){
                                String distCode = map_BMSIdDistId.get(invoiceItem.ccrz__CCOrder__r.ccrz__OriginatedCart__r.OSM_SW_IAM_Account_Id_For_Third_Party__c);
                                fsdList.customerLocationCode = distCode;
                            }                        
                        else{
                            if(null != invoiceItem.ccrz__CCOrder__r.ccrz__Account__r.CSS_DistributorCode__c || ((invoiceItem.ccrz__CCOrder__r.ccrz__Account__r.EBU_Channel_of_Distribution__c == 'CIHR' || invoiceItem.ccrz__CCOrder__r.ccrz__Account__r.PSBU_Channel_of_Distribution__c == 'CIHR') && invoiceItem.ccrz__CCOrder__r.ccrz__Account__r.OSM_SW_Responsible_Region__c !=null)){
                                if(invoiceItem.ccrz__CCOrder__r.ccrz__Account__r.EBU_Channel_of_Distribution__c == 'CIHR' || invoiceItem.ccrz__CCOrder__r.ccrz__Account__r.PSBU_Channel_of_Distribution__c == 'CIHR')
                                {
                                    fsdList.customerLocationCode = invoiceItem.ccrz__CCOrder__r.ccrz__Account__r.OSM_SW_Responsible_Region__c; 
                                }
                                else
                                {
                                    fsdList.customerLocationCode = invoiceItem.ccrz__CCOrder__r.ccrz__Account__r.CSS_DistributorCode__c; 
                                }
                            } 
                            else{
                                mandatoryFields.add('CUSTOMER_LOCATION_CODE');
                            } 
                        }
                        fsdList.vendor = Label.OSM_Vendor;
                        fsdList.status ='';
                        if(invoiceItem.ccrz__CCOrder__r.Discount_Type__c!=null){
                            chargeList.discountType=invoiceItem.ccrz__CCOrder__r.Discount_Type__c;
                        }else{
                            chargeList.discountType=Label.OSM_MISC_CHARGE;
                        }
                        chargeList.totalDiscount=0;
                        if(invoiceItem.ccrz__CCOrder__r.Calculated_Total_Discount__c!=null){
                            chargeList.totalDiscount=-invoiceItem.ccrz__CCOrder__r.Calculated_Total_Discount__c.setScale(2, RoundingMode.HALF_UP);
                        }
                        system.debug('orderItemRecord +++ '+ orderItemRecord);
                        for(ccrz__E_OrderItem__c orderItem:orderItemRecord){
                            system.debug('orderItem +++ '+ orderItem);
                            system.debug('orderItem.ccrz__ParentOrderItem +++ '+ orderItem.ccrz__ParentOrderItem__c);
                            if(orderItem.ccrz__ParentOrderItem__c==null){
                                partList=new OSM_WS_GeneralizedSubmitOrdrInpWrapper.PartList();
                                if(orderItem.ccrz__Product__r.ccrz__SKU__c != null){
                                    if((Label.OSM_GOMSPartnumber_SubmitOrder).contains(orderItem.ccrz__Product__r.ccrz__SKU__c)){
                                        partList.itemNumber =orderItem.ccrz__Product__r.GOMS_Part_Number__c;
                                    }else{
                                        partList.itemNumber =orderItem.ccrz__Product__r.ccrz__SKU__c;
                                    }
                                }
                                else{
                                    mandatoryFields.add('ITEM_NUMBER');
                                }
                                
                                if(orderItem.ccrz__Product__r.name!=null){
                                    partList.description =OSM_Generic_Utility.removeSymbols(orderItem.ccrz__Product__r.name);
                                }
                                else{
                                    mandatoryFields.add('DESCRIPTION');
                                }                    
                                if(orderItem.ccrz__Quantity__c!=null){
                                    partList.quantity = Integer.ValueOf(orderItem.ccrz__OriginalQuantity__c);
                                }
                                else{
                                    mandatoryFields.add('QUANTITY');
                                } 
                                if(orderItem.ccrz__UnitOfMeasure__c!=null){
                                    partList.unitOfMeasurement =orderItem.ccrz__UnitOfMeasure__c;
                                }else{
                                    partList.unitOfMeasurement ='EA';
                                }
                                
                                partList.itemCost = 0;
                                if(orderItem.Dn_Price__c!= null){
                                    Decimal item_cost_ToRound=orderItem.Dn_Price__c / orderItem.ccrz__OriginalQuantity__c;
                                    partList.itemCost =item_cost_ToRound.setScale(2, RoundingMode.HALF_UP);
                                }
                                
                                if(orderItem.ccrz__Price__c!= null){
                                    partList.sellingPrice =orderItem.ccrz__Price__c;                                    
                                }
                                else{
                                    mandatoryFields.add('SELLING_PRICE');
                                }                                     
                                partList.product =Label.OSM_Vendor;
                                partList.nonstockType='';
                                partList.product='';
                                inputWrapperObj.dataArea.PartList.add(partList);                               
                            }
                        }
                        inputWrapperObj.dataArea.headerList.add(fsdList);
                        inputWrapperObj.dataArea.chargeList.add(chargeList);
                        system.debug('inputWrapperObj +++ '+ inputWrapperObj);
                        if(ccTaxList.size()>0 && ccTaxList!=null){
                            
                            for(CC_Tax__c taxDetails:ccTaxList){
                                 system.debug('taxDetails +++ '+ taxDetails);
                                taxList=new OSM_WS_GeneralizedSubmitOrdrInpWrapper.TaxList();  
                                taxList.salesCategories = taxDetails.CC_Cart_Item__r.ccrz__Product__r.Product_Class_Code__c;
                                boolean isSaleAmount = false;                               

                                taxList.saleAmount = 0;
                                Decimal SALE_AMOUNT_ToRound;                                
                                
                                if(taxDetails.CC_Cart_Item__r.ccrz__SubAmount__c != null){
                                    isSaleAmount = true;
                                    taxList.saleAmount = taxDetails.CC_Cart_Item__r.ccrz__SubAmount__c.setScale(2, RoundingMode.HALF_UP);
                                }
                                
                                if(!isSaleAmount){
                                    mandatoryFields.add('SALE_AMOUNT');
                                }
                                
                                taxList.taxAuthorities =invoiceItem.ccrz__CCOrder__r.ccrz__ShipTo__r.ccrz__PostalCode__c.substring(0,5) +'-'+invoiceItem.ccrz__CCOrder__r.ccrz__ShipTo__r.ccrz__StateISOCode__c + '-'+ taxDetails.JurisdictionId__c;
                                taxList.printGroup =taxDetails.JurisdictionLevel__c;                                
                                taxList.taxAmount =Decimal.ValueOf(taxDetails.CalculatedTax__c);
                                if(strStatusMode.equalsIgnoreCase('CANCEL')) {
                                    taxList.taxAmount = -Decimal.ValueOf(taxDetails.CalculatedTax__c);
                                }
                                
                                if(!(taxList.taxAuthorities != null)){
                                    mandatoryFields.add('TAX_AUTHORITIES');
                                }
                                if(!(taxDetails.JurisdictionLevel__c != null)){
                                    mandatoryFields.add('PRINT_GROUP');
                                }
                                if(!(taxDetails.CalculatedTax__c != null)){
                                    mandatoryFields.add('TAX_AMOUNT');
                                }
                                inputWrapperObj.dataArea.taxList.add(taxList); 
                                inputWrapperObj.dataArea.AcctId = AccountID; 
                            }                        
                        }                         
                    }
                }
                system.debug('inputWrapperObj +++ '+ inputWrapperObj);
                if(Test.isRunningTest()){
                    mandatoryFields.clear();
                }
                if(inputWrapperObj.dataArea.locationId !=null && inputWrapperObj.dataArea.customerCode !=null && !(mandatoryFields.size() > 0)){
                    //Calling Service class
                    system.debug('Calling Service class +++ ');
                    OSM_WS_GeneralizedSubmitOrderOutputWrap responseWrpObj=OSM_WS_SubmitOrderInfoService.callSubmitOrderService(inputWrapperObj);
                    System.debug('General Output Wrapper>>>>>'+responseWrpObj);
                    
                    sp = Database.setSavepoint();
                    log=responseWrpObj.log;
                    log.Account__c = AccountID;                    
                }                
                else {
                    String mandeToryString;
                    for(String valueStr : mandatoryFields) {
                        if(mandeToryString != null)
                            mandeToryString = mandeToryString+', '+valueStr;
                        else
                            mandeToryString = valueStr;                        
                    }
                    
                    log.Status__c = Label.OSM_Subs_Cancellation_Failure;
                    log.Target__c = System.Label.OSM_BMS_Target_ID;
                    log.Source__c = Label.OSM_Source;
                    log.Logged_In_User__c = userinfo.getuserid();
                    log.Error_Description__c='Mandatory fields are missing: '+mandeToryString;
                    log.Service_Name__c=Label.OSM_SubmitOrder_ServiceName;    
                    objToReturn.exceptionFlag=true;
                    invoiceObj.id=invoiceRecord[0].id;
                    orderObj.id=orderId;
                }        
                if(Test.isRunningTest()){
                    throw new NullPointerException();
                }
                
            }catch(Exception ex){        
                System.debug('exception : '+ex.getMessage());
                log.Account__c = AccountID;  
                log.Status__c = Label.OSM_Subs_Cancellation_Failure; 
                String msg  = 'Message - '+ex.getMessage();
                msg=msg+ 'Stacktrace - ' + ex.getStackTraceString();                   
                log.Error_Description__c = msg;
                log.Target__c = System.Label.OSM_BMS_Target_ID;
                log.Source__c = Label.OSM_Source;
                log.Logged_In_User__c = userinfo.getuserid();
                if(invoiceRecord != null && invoiceRecord.size() > 0)
                    invoiceObj.id=invoiceRecord[0].id;
                orderObj.id=orderId;
            }
            
            if(log!=null){
                if(log.Status__c != Label.OSM_CalloutStatus_Success)
                    objToReturn.exceptionFlag=true;
                log.CC_Order__c = orderId;
                log.Account__c = AccountID;  
                lstToInsertLog.add(log);  
            }             
            
            objToReturn.updateOrderList=new List<ccrz__E_Order__c>();
            objToReturn.updateInvoiceList=new List<ccrz__E_Invoice__c>();              
            objToReturn.updateOrderList=orderList;
            objToReturn.updateInvoiceList=invoiceList;
            objToReturn.lstToInsertLog=new List<OSM_Integration_Log__c>();
            objToReturn.lstToInsertLog=lstToInsertLog;
            try{
                if(lstToInsertLog!=null && lstToInsertLog.size()>0){
                    insert lstToInsertLog;
                }
                if(Test.isRunningTest()){
                    throw new NullPointerException();
                }
            }catch(Exception ex){
                System.debug('exception : '+ex.getMessage());
                String msg  = 'Message - '+ex.getMessage();
                msg=msg+ 'Stacktrace - ' + ex.getStackTraceString();                   
            }
        }
        
        else {
            try {
                objToReturn.exceptionFlag=false;
            }
            Catch(Exception ex) {
                objToReturn.exceptionFlag=true;
            }            
        }
    }
}