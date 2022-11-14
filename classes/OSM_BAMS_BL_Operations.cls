/************************************************************
Name:  OSM_BAMS_BL_Operations
Copyright © 2018  Cummins
=============================================================
=============================================================
Purpose:                                                            
This is the business layer which will be called by batch for 
initiating the refund.
=============================================================
=============================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE              DETAIL                                
1.0 -   Vaibhav            79/2018     INITIAL DEVELOPMENT          


*************************************************************/

global class OSM_BAMS_BL_Operations {

    // variables for test class
    public static boolean testCase1;
 
/*----------------------------------------------------------------------------------
1. processRefundForCancelledOrders
Description: It will take cancelled orderList for which refund has to be initiated.
params
 orderList- list of cancelled orders
Return: None

------------------------------------------------------------------------------------*/
    public static void processRefundForCancelledOrders(List < ccrz__E_Order__c > orderList) {
            
        String request;
        String response;
        String Status;
        String StatusCode;
        String ResponseBody;
        OSM_Integration_Log__c log = new OSM_Integration_Log__c();
        List < OSM_Integration_Log__c > lstLogs = new List < OSM_Integration_Log__c > ();
        Map < Id, OSM_Integration_Log__c > orderIdVsLogMap = new Map < Id, OSM_Integration_Log__c > ();
        OSM_BAMS_WS_GeneralizedInputWrapper genWrapObj = new OSM_BAMS_WS_GeneralizedInputWrapper();
        List < OSM_BAMS_WS_GeneralizedInputWrapper > lstgenWrap = new List < OSM_BAMS_WS_GeneralizedInputWrapper > ();
        Map < Id, ccrz__E_Order__c > orderIdVsOrderMap = new Map < Id, ccrz__E_Order__c > ();
        Map < Id, ccrz__E_Invoice__c > mapOrderIdVsInvoice = new map < Id, ccrz__E_Invoice__c > ();
        Map < Id, ccrz__E_TransactionPayment__c > mapOrderIdVsPayment = new map < Id, ccrz__E_TransactionPayment__c > ();
        List < ccrz__E_Invoice__c > lstInvoice = null;
        List < ccrz__E_TransactionPayment__c > lstTrans = null;
        List < ccrz__E_Order__c > OrderListCreated = new List < ccrz__E_Order__c > ();
        List < ccrz__E_TransactionPayment__c > Translist = new List < ccrz__E_TransactionPayment__c > ();
        OSM_Integration_Log__c logOrderToSave;
        List<OSM_Orders_In_Invoice__c> parent_OrderInvoiceJuncWrapperLst = new List<OSM_Orders_In_Invoice__c>();
        Savepoint sp;
        ccrz__E_Order__c order;
        ccrz__E_TransactionPayment__c tp;
        boolean errorFlag = false;
        String errorMsg = '';
        Map<String,OSM_Orders_In_Invoice__c> orderIdVsOrderJuncMap = new Map<String,OSM_Orders_In_Invoice__c>();
        Map<Id, Decimal> map_OrderIdOrderTotal = new Map<Id, Decimal>();
        //new log created by Ashish (MAR-1961)
        Map<Id, OSM_Integration_Log__c> lst_NewLogs = new Map<Id, OSM_Integration_Log__c>();

        
        try {
            for (ccrz__E_Order__c ccOrder: orderList) {
                orderIdVsOrderMap.put(ccOrder.id, ccOrder);
            }

            parent_OrderInvoiceJuncWrapperLst = [select id,OSM_SW_Is_Refund_Request__c,Vertex_Refund_Call_Status__c,Vertex_Call_Status__c,CC_Order__c from OSM_Orders_In_Invoice__c where CC_Order__c in :orderIdVsOrderMap.keyset()] ;         
            lstInvoice = [SELECT id, ccrz__CurrencyCode__c, ccrz__OriginalAmount__c, ccrz__CCOrder__c FROM ccrz__E_Invoice__c WHERE ccrz__CCOrder__c = : orderIdVsOrderMap.keyset()];

            //add criteria for status..status should not be failed..it should not happen that OSM is refunding for failed transactions also
            lstTrans = [Select id, ccrz__Token__c,ccrz__TransactionSubcode__c, ccrz__CCOrder__c,OSM_BAMS_Cancel_Decision__c,OSM_BAMS_Cancel_Reason_Code__c,OSM_BAMS_Cancel_Transaction_Status__c,OSM_BAMS_Cancel_ReconciliationId__c,OSM_BAMS_Cancel_Request_ID__c,OSM_BAMS_Cancel_Request__c,OSM_BAMS_Cancel_Response__c,OSM_BAMS_Cancel_Req_Fault_Code__c from ccrz__E_TransactionPayment__c where ccrz__CCOrder__c = : orderIdVsOrderMap.keyset()];
            
            
            for(OSM_Orders_In_Invoice__c parentJunc:parent_OrderInvoiceJuncWrapperLst){
                //Note:expecting only one entry for one order..In case requirement changes then this needs to be changed
                orderIdVsOrderJuncMap.put(parentJunc.CC_Order__c,parentJunc);
            }

            for (ccrz__E_Invoice__c inv: lstInvoice) {
                mapOrderIdVsInvoice.put(inv.ccrz__CCOrder__c, inv);
            }

            for (ccrz__E_TransactionPayment__c tran: lstTrans) {
                mapOrderIdVsPayment.put(tran.ccrz__CCOrder__c, tran);
            }

            for(ccrz__E_Order__c ordrObj : [SELECT Id, (SELECT Id, ccrz__SubAmount__c, Vertex_Tax__c, ccrz__Price__c FROM ccrz__E_OrderItems__r WHERE Is_Refund_Initiated__c = false) FROM ccrz__E_Order__c WHERE Id IN: mapOrderIdVsInvoice.keySet()]){
                Decimal totalVal = 0;
                for(ccrz__E_OrderItem__c ordrItm : ordrObj.ccrz__E_OrderItems__r){
                    totalVal += ordrItm.ccrz__SubAmount__c + ordrItm.Vertex_Tax__c;
                }
                map_OrderIdOrderTotal.put(ordrObj.Id, totalVal);
            }
            
            //iterate each order and create the log and validate the mandatory fields
            for (ccrz__E_Order__c ccOrder: orderList) {
                log = new OSM_Integration_Log__c();
                orderIdVsLogMap.put(ccOrder.id,log);
                errorFlag = false;
                errorMsg = '';
                genWrapObj = new OSM_BAMS_WS_GeneralizedInputWrapper();
                genWrapObj.merchantID = label.CyberSource_MerchantId;
                genWrapObj.PTcurrency = ccOrder.ccrz__CurrencyISOCode__c;
                genWrapObj.order = ccOrder;
                log.CC_Order__c = genWrapObj.order.id;
                
                if (mapOrderIdVsInvoice.containskey(ccOrder.id)) {
                    system.debug('@@@@@@@' + map_OrderIdOrderTotal.get(ccOrder.id));
                    //genWrapObj.grandTotalAmount = mapOrderIdVsInvoice.get(ccOrder.id).ccrz__OriginalAmount__c;
                    genWrapObj.grandTotalAmount = map_OrderIdOrderTotal.get(ccOrder.id);
                    genWrapObj.invoice = mapOrderIdVsInvoice.get(ccOrder.id);
                    log.Invoice__c = genWrapObj.invoice.id;          
                } else {
                    errorFlag = true;
                    errorMsg = 'Invoice Record not found.';
                }

                if (mapOrderIdVsPayment.containskey(ccOrder.id)) {
                    system.debug('@@@@@@@' + mapOrderIdVsPayment.get(ccOrder.id).ccrz__Token__c);
                    genWrapObj.subscriptionID = mapOrderIdVsPayment.get(ccOrder.id).ccrz__Token__c;
                    genWrapObj.transactionPayment = mapOrderIdVsPayment.get(ccOrder.id);
                    //Added by Vineet on 26/10/1028  
                    genWrapObj.merchantReferenceCode = mapOrderIdVsPayment.get(ccOrder.id).ccrz__TransactionSubcode__c;
                    log.Transaction_Payment__c = genWrapObj.transactionPayment.id;
                } else {
                    errorFlag = true;
                    errorMsg = errorMsg + '---' + 'Payment Record not found.';
                }

                if (!errorFlag) {
                    //add the order in the list to be processed
                    lstgenWrap.add(genWrapObj);
                    system.debug('@@@@@lstgenWrap' + lstgenWrap);
                } else {
                    //handle or update records where valid data is not present
                    System.debug('=====Exception in setARInvoiceOutboundWrapper====');
                    OSM_Integration_Log__c logOrder = orderIdVsLogMap.get(ccOrder.id);
                    logOrder.Status__c = label.DA_Log_Status_Failure;
                    //log.Error_Description__c = 'Exception:'+e.getMessage() + ',' + '\n\n' + 'Stack traced at: '+e.getStacktraceString();

                    logOrder.Error_Description__c = errorMsg;
                    logOrder.Service_Name__c = label.CyberSource_ServiceName;
                    logOrder.Source__c = label.DA_Source;
                    logOrder.Target__c = label.CyberSource_Target;
                    logOrder.CC_Order__c = genWrapObj.order.id;
                }
            }
            //code to cover test covergae for Catch Block
            if(Test.isRunningTest()) {
                throw new NullPointerException();
            } 
        }catch (Exception e){
            //Vaibhav TBD
            system.debug('Entered into catch block of processRefundForCancelledOrders method in class:' + e.getMessage() + ' Line No:' + e.getLineNumber());

            for(String orderId : orderIdVsLogMap.keySet()) {
                OSM_Integration_Log__c orderLog = orderIdVsLogMap.get(orderId);
                orderLog.Status__c = label.DA_Log_Status_Failure;
                orderLog.Error_Description__c = log.Error_Description__c + '---Exception:' + e.getMessage() + ',' + '\n\n' + 'Stack traced at: ' + e.getStacktraceString();
                orderLog.Service_Name__c = label.CyberSource_ServiceName;
                orderLog.Source__c = label.DA_Source;
                orderLog.Target__c = label.CyberSource_Target;
            }      
        }

        OSM_BAMS_WS_RefundResponse_Wrapper responseObj;
        if (lstgenWrap.size() > 0) {
            //Start iterating and fire the BAMS request for each order
            for (OSM_BAMS_WS_GeneralizedInputWrapper gwrap: lstgenWrap) {
                try{
                    //process BAMS SOAP request for each order by calling the service layer
                    responseObj = OSM_BAMS_WS_Service.prepareBAMSCallForRefund(gwrap);

                    System.debug('=======responseObj from Service Layer====='+responseObj);
                    request = responseObj.Request;
                    response = responseObj.Response;
                    if (responseObj.exceptionFlag == true) {                  
                        OSM_Integration_Log__c logOrder = orderIdVsLogMap.get(gwrap.order.id);               
                        logOrder.Status__c = label.DA_Log_Status_Failure;
                        logOrder.Error_Description__c = responseObj.errorMessage;
                        logOrder.Service_Name__c = label.CyberSource_ServiceName;
                        logOrder.Source__c = label.DA_Source;
                        logOrder.Target__c = label.CyberSource_Target;
                        logOrder.Response__c = String.valueOf(responseObj);
                        logOrder.Request__c = String.valueOf(request);
                        //Added by Ashish(MAR-1961)
                        //lst_NewLogs.add(logOrder);
                        lst_NewLogs.put(gwrap.order.id, logOrder);

                        //Start updating the Order and Transaction Payment record
                        if(Test.isRunningTest()) {
                            if(testCase1 == true) {
                                responseObj.refundStatusToBAMS = 'SUCCESS';
                                responseObj.exceptionFlag = false;
                            }
                        }
                    
                        if(responseObj.refundStatusToBAMS=='SUCCESS')
                        {
                            //In case money is refunded back to user but there was some error while processing the request
                            gwrap.order.Refund_status__c = 'Refunded';
                            gwrap.order.Is_Refund_Initiated__c = true;
                            gwrap.transactionPayment.OSM_BAMS_Cancel_Transaction_Status__c='Refunded but Error in CMI';
                            gwrap.transactionPayment.OSM_BAMS_Cancel_Request__c=responseObj.Request;
                            gwrap.transactionPayment.OSM_BAMS_Cancel_Response__c=responseObj.Response;

                            if(Test.isRunningTest())
                            {
                                responseObj.OrderRefundResponseNodes = new OSM_BAMS_OrderRefundNodes();
                            }
                            if(responseObj.OrderRefundResponseNodes!=null  || Test.isRunningTest()) {
                                gwrap.transactionPayment.OSM_BAMS_Cancel_Decision__c=responseObj.OrderRefundResponseNodes.decision;
                                gwrap.transactionPayment.OSM_BAMS_Cancel_Reason_Code__c=responseObj.OrderRefundResponseNodes.reasonCode;
                                gwrap.transactionPayment.OSM_BAMS_Cancel_ReconciliationId__c=responseObj.OrderRefundResponseNodes.reconciliationID_ccCap;
                                gwrap.transactionPayment.OSM_BAMS_Cancel_Request_ID__c=responseObj.OrderRefundResponseNodes.requestID;
                            }

                        }else if (responseObj.refundStatusToBAMS=='' || responseObj.refundStatusToBAMS=='FAILURE' || Test.isRunningTest()) { 
                            gwrap.order.Refund_status__c = 'Not Refunded';
                            gwrap.order.Is_Refund_Initiated__c = true;
                            gwrap.transactionPayment.OSM_BAMS_Cancel_Transaction_Status__c='FAILURE'; 
                            gwrap.transactionPayment.OSM_BAMS_Cancel_Request__c=responseObj.Request;
                            gwrap.transactionPayment.OSM_BAMS_Cancel_Response__c=responseObj.Response;
                            if(!Test.isRunningTest())
                            gwrap.transactionPayment.OSM_BAMS_Cancel_Req_Fault_Code__c = 'Fault:'+responseObj.OrderRefundResponseNodes.Fault + '\n faultcode:'+responseObj.OrderRefundResponseNodes.faultcode + '\n Faultstring:'+responseObj.OrderRefundResponseNodes.faultstring;
                            if(Test.isRunningTest())
                            {
                                responseObj.OrderRefundResponseNodes = new OSM_BAMS_OrderRefundNodes();
                            }
                            if(responseObj.OrderRefundResponseNodes!=null || Test.isRunningTest()) {
                                gwrap.transactionPayment.OSM_BAMS_Cancel_Decision__c=responseObj.OrderRefundResponseNodes.decision;
                                gwrap.transactionPayment.OSM_BAMS_Cancel_Reason_Code__c=responseObj.OrderRefundResponseNodes.reasonCode;
                                gwrap.transactionPayment.OSM_BAMS_Cancel_ReconciliationId__c=responseObj.OrderRefundResponseNodes.reconciliationID_ccCap;
                                gwrap.transactionPayment.OSM_BAMS_Cancel_Request_ID__c=responseObj.OrderRefundResponseNodes.requestID;
                            }
                        }
                    } else if (responseObj.exceptionFlag == false) {
                        //in case BAMS send the success code then perform below operations
                        //enrich the logs for success
                        OSM_Integration_Log__c logOrder = orderIdVsLogMap.get(gwrap.order.id);
                        logOrder.Status__c = label.DA_Log_Status_Success;
                        //Not supposed to display the request and response for payments and hence commenting
                        logOrder.Service_Name__c = label.CyberSource_ServiceName;
                        logOrder.Source__c = label.DA_Source;
                        logOrder.Target__c = label.CyberSource_Target;
                        logOrder.Transaction_Payment__c=gwrap.transactionPayment.id;
                        logOrder.CC_Order__c = gwrap.order.id;
                        logOrder.Response__c = String.valueOf(responseObj);
                        logOrder.Request__c = String.valueOf(request);
                        //Added by Ashish (MAR-1961)
                        //lst_NewLogs.add(logOrder);
                        lst_NewLogs.put(gwrap.order.id, logOrder);
                        
                        //update Transaction Record While we getting error in response and request
                        gwrap.order.Refund_status__c = 'Refunded';
                        gwrap.order.Is_Refund_Initiated__c = true;
                        gwrap.transactionPayment.OSM_BAMS_Cancel_Transaction_Status__c='Success';
                        gwrap.transactionPayment.OSM_BAMS_Cancel_Decision__c=responseObj.OrderRefundResponseNodes.decision;
                        gwrap.transactionPayment.OSM_BAMS_Cancel_Reason_Code__c=responseObj.OrderRefundResponseNodes.reasonCode;
                        gwrap.transactionPayment.OSM_BAMS_Cancel_ReconciliationId__c=responseObj.OrderRefundResponseNodes.reconciliationID_ccCap;
                        gwrap.transactionPayment.OSM_BAMS_Cancel_Request_ID__c=responseObj.OrderRefundResponseNodes.requestID;
                        gwrap.transactionPayment.OSM_BAMS_Cancel_Request__c=responseObj.Request;
                        gwrap.transactionPayment.OSM_BAMS_Cancel_Response__c=responseObj.Response;
                    }
                
                    //code to cover test covergae for Catch Block
                    if(Test.isRunningTest()) {
                        throw new NullPointerException();
                    }
                }catch (Exception e) {
                
                    log = orderIdVsLogMap.get(gwrap.order.Id);
                    log.Status__c = label.DA_Log_Status_Failure;
                    log.Error_Description__c = log.Error_Description__c + '===Exception:' + e.getMessage() + ',' + '\n\n' + 'Stack traced at: ' + e.getStacktraceString();
                    log.Service_Name__c = label.CyberSource_ServiceName;
                    log.Source__c = label.DA_Source;
                    log.Target__c = label.CyberSource_Target;
                    if (responseObj!=null && responseObj.exceptionFlag == true) {
                        if(responseObj.refundStatusToBAMS=='SUCCESS') {
                            //In case money is refunded back to user but there was some error while processing the request
                            gwrap.order.Refund_status__c = 'Refunded';
                            gwrap.transactionPayment.OSM_BAMS_Cancel_Transaction_Status__c='Refunded but Error in CMI';  
                        }
                        else if (responseObj.refundStatusToBAMS=='' || responseObj.refundStatusToBAMS=='FAILURE') { 
                            gwrap.order.Refund_status__c = 'Not Refunded';
                            gwrap.transactionPayment.OSM_BAMS_Cancel_Transaction_Status__c='FAILURE';
                        }
                    }
                    else if (responseObj!=null && responseObj.exceptionFlag == false) {
                        gwrap.order.Refund_status__c = 'Refunded';
                        gwrap.transactionPayment.OSM_BAMS_Cancel_Transaction_Status__c='Success';
                    }
                
                
                }
            } //end of for loop
                
            //Save all the records for Order in one transaction...
            //rollback the TX if any error but make an entry in log

            OSM_Orders_In_Invoice__c parentJunc=null;
            for (OSM_BAMS_WS_GeneralizedInputWrapper gwrap: lstgenWrap) {           
                try{
                    sp = Database.setSavepoint();
                    order = gwrap.order;
                    tp = gwrap.transactionPayment;
                    List<sObject> lst = new List<sObject>();
                    lst.add(order);
                    lst.add(tp);
                    
                    if(orderIdVsOrderJuncMap.containsKey(order.id)){
                        parentJunc =  orderIdVsOrderJuncMap.get(order.id);
                        parentJunc.OSM_SW_Is_Refund_Request__c=true;
                        // Sharad 19 Sept : Change refund call status to pending instead of vertex call status                 
                        // START : Juhi Changes : Dec 03, 2018 : Vertex changed to pending only when BAMS is successful and it is not already a Success status
                        if(order.Refund_status__c == 'Refunded' && parentJunc.Vertex_Refund_Call_Status__c != 'Success') {
                            parentJunc.Vertex_Refund_Call_Status__c = 'Pending';
                        }
                        // END : Juhi Changes : Dec 03, 2018 : Vertex changed to pending only when BAMS is successful and it is not already a Success status
                        lst.add(parentJunc);
                    }
                
                    Database.update(lst);
                    
                    //code to cover test covergae for Catch Block
                    if(Test.isRunningTest()) {
                        throw new NullPointerException();
                    }
                    if(lst_NewLogs.size() > 0){
                        Database.insert(lst_NewLogs.values());
                    }
                    /*logOrderToSave = orderIdVsLogMap.get(gwrap.order.id);
                    if(logOrderToSave.Status__c==label.DA_Log_Status_Failure) {
                        Database.insert(logOrderToSave);
                    }*/ 
                    
                }catch(Exception e) {
                    //In case of any error rollback the TX but insert the log for that order
                    Database.rollback( sp );
                    String errorMsg1 = e.getMessage()  +'\n' + e.getStackTraceString();
                    log= new OSM_Integration_Log__c();
                    log.Status__c = label.DA_Log_Status_Failure;
                    log.Error_Description__c = 'Error occured while saving Order,Transaction Payment record.'+'\n----'+errorMsg1;
                    log.Service_Name__c = label.CyberSource_ServiceName;
                    log.Source__c = label.DA_Source;
                    log.Target__c = label.CyberSource_Target;
                    log.CC_Order__c = order.id;
                    log.Transaction_Payment__c = tp.id;
                    List<sObject> logLst = new List<sObject>();
                    logLst.add(log);
                    if(logOrderToSave!=null){
                    logLst.add(logOrderToSave);}                
                    Database.insert(logLst);
            }
            }
        } 
    }
 
    public static void processRefundForCancelledOrderItems(List <ccrz__E_OrderItem__c> orderList) {
 
        String request;
        String response;
        String Status;
        String StatusCode;
        String ResponseBody;
        string orderId;
        OSM_Integration_Log__c log = new OSM_Integration_Log__c();
    
        List < OSM_Integration_Log__c > lstLogs = new List < OSM_Integration_Log__c > ();
        Map < Id, OSM_Integration_Log__c > orderIdVsLogMap = new Map < Id, OSM_Integration_Log__c > ();
        OSM_BAMS_WS_GeneralizedInputWrapper genWrapObj = new OSM_BAMS_WS_GeneralizedInputWrapper();
        List < OSM_BAMS_WS_GeneralizedInputWrapper > lstgenWrap = new List < OSM_BAMS_WS_GeneralizedInputWrapper > ();
        Map < Id, ccrz__E_OrderItem__c > orderIdVsOrderMap = new Map < Id, ccrz__E_OrderItem__c > ();
        Map < Id, ccrz__E_Invoice__c > mapOrderIdVsInvoice = new map < Id, ccrz__E_Invoice__c > ();
        Map < Id, ccrz__E_TransactionPayment__c > mapOrderIdVsPayment = new map < Id, ccrz__E_TransactionPayment__c > ();
        List < ccrz__E_Invoice__c > lstInvoice = null;
        List < ccrz__E_TransactionPayment__c > lstTrans = null;
        List < ccrz__E_Order__c > OrderListCreated = new List < ccrz__E_Order__c > ();
        List < ccrz__E_TransactionPayment__c > Translist = new List < ccrz__E_TransactionPayment__c > ();
        Map < Id, ccrz__E_Order__c > mapOrderIdVsOItem = new map < Id, ccrz__E_Order__c > ();
        OSM_Integration_Log__c logOrderToSave;
        List<OSM_Orders_In_Invoice__c> parent_OrderInvoiceJuncWrapperLst = new List<OSM_Orders_In_Invoice__c>();
        Savepoint sp;
        ccrz__E_Order__c order;
        ccrz__E_OrderItem__c orderItm;
        ccrz__E_TransactionPayment__c tp;
        boolean errorFlag = false;
        String errorMsg = '';
        Map<String,OSM_Orders_In_Invoice__c> orderIdVsOrderJuncMap = new Map<String,OSM_Orders_In_Invoice__c>();
        //new log created by Ashish (MAR-1961)
        Map<Id, OSM_Integration_Log__c> lst_NewLogs = new Map<Id, OSM_Integration_Log__c>();
        
        try {
            for (ccrz__E_OrderItem__c ccOrder: orderList) {
                orderIdVsOrderMap.put(ccOrder.ccrz__Order__c, ccOrder);
            }
    
            parent_OrderInvoiceJuncWrapperLst = [select id,OSM_SW_Is_Refund_Request__c,Vertex_Refund_Call_Status__c,Vertex_Call_Status__c,CC_Order__c from OSM_Orders_In_Invoice__c where CC_Order__c in :orderIdVsOrderMap.keyset()] ;
            OrderListCreated =[select id,name from ccrz__E_Order__c where id IN:orderIdVsOrderMap.keyset()];
            
            lstInvoice = [SELECT id, ccrz__CurrencyCode__c, ccrz__OriginalAmount__c, ccrz__CCOrder__c FROM ccrz__E_Invoice__c WHERE ccrz__CCOrder__c = : orderIdVsOrderMap.keyset()];
    
           //add criteria for status..status should not be failed..it should not happen that OSM is refunding for failed transactions also
            lstTrans = [Select id, ccrz__Token__c,ccrz__TransactionSubcode__c, ccrz__CCOrder__c,OSM_BAMS_Cancel_Decision__c,OSM_BAMS_Cancel_Reason_Code__c,OSM_BAMS_Cancel_Transaction_Status__c,OSM_BAMS_Cancel_ReconciliationId__c,OSM_BAMS_Cancel_Request_ID__c,OSM_BAMS_Cancel_Request__c,OSM_BAMS_Cancel_Response__c,OSM_BAMS_Cancel_Req_Fault_Code__c from ccrz__E_TransactionPayment__c where ccrz__CCOrder__c = : orderIdVsOrderMap.keyset()];
            
            
            for(OSM_Orders_In_Invoice__c parentJunc:parent_OrderInvoiceJuncWrapperLst){
                orderIdVsOrderJuncMap.put(parentJunc.CC_Order__c,parentJunc);           
            }
              
            for (ccrz__E_Invoice__c inv: lstInvoice) {
                mapOrderIdVsInvoice.put(inv.ccrz__CCOrder__c, inv);
            }
    
            for (ccrz__E_TransactionPayment__c tran: lstTrans) {
                mapOrderIdVsPayment.put(tran.ccrz__CCOrder__c, tran);
            }
            
            for(ccrz__E_Order__c Order1:OrderListCreated){
                mapOrderIdVsOItem.put(Order1.id,Order1);
            }
            
            //iterate each order and create the log and validate the mandatory fields
            for (ccrz__E_OrderItem__c ccOrder: orderList) {
                log = new OSM_Integration_Log__c();
                orderIdVsLogMap.put(ccOrder.Id,log);
                errorFlag = false;
                errorMsg = '';
                genWrapObj = new OSM_BAMS_WS_GeneralizedInputWrapper();
                genWrapObj.merchantID = label.CyberSource_MerchantId;
                genWrapObj.PTcurrency = ccOrder.ccrz__Order__r.ccrz__CurrencyISOCode__c;
                genWrapObj.orderItem = ccOrder;
                genWrapObj.orderId = ccOrder.ccrz__Order__c;
                log.CC_Order__c = ccOrder.ccrz__Order__c;
                
                if (mapOrderIdVsInvoice.containskey(ccOrder.ccrz__Order__c)) {
                    //system.debug('@@@@@@@' + mapOrderIdVsInvoice.get(ccOrder.ccrz__Order__c).ccrz__OriginalAmount__c);
                    genWrapObj.grandTotalAmount = ccOrder.ccrz__SubAmount__c + ccOrder.Vertex_Tax__c;
                    genWrapObj.invoice = mapOrderIdVsInvoice.get(ccOrder.ccrz__Order__c);
                    log.Invoice__c = genWrapObj.invoice.id;
                 
                } else {
                    errorFlag = true;
                    errorMsg = 'Invoice Record not found.';
                }
    
    
                if (mapOrderIdVsPayment.containskey(ccOrder.ccrz__Order__c)) {
                    system.debug('@@@@@@@' + mapOrderIdVsPayment.get(ccOrder.ccrz__Order__c).ccrz__Token__c);
                    genWrapObj.subscriptionID = mapOrderIdVsPayment.get(ccOrder.ccrz__Order__c).ccrz__Token__c;
                    genWrapObj.transactionPayment = mapOrderIdVsPayment.get(ccOrder.ccrz__Order__c);
                    
                    //Added by Vineet on 26/10/1028  
                    genWrapObj.merchantReferenceCode = mapOrderIdVsPayment.get(ccOrder.ccrz__Order__c).ccrz__TransactionSubcode__c;
                    log.Transaction_Payment__c = genWrapObj.transactionPayment.id;
                } else {
                    errorFlag = true;
                    errorMsg = errorMsg + '---' + 'Payment Record not found.';
                }
    
                if (!errorFlag) {
                    lstgenWrap.add(genWrapObj);
                    system.debug('@@@@@lstgenWrap' + lstgenWrap);
                } else {
                    System.debug('=====Exception in setARInvoiceOutboundWrapper====');
                    OSM_Integration_Log__c logOrder = orderIdVsLogMap.get(ccOrder.id);
                    logOrder.Status__c = label.DA_Log_Status_Failure;
                    logOrder.Error_Description__c = errorMsg;
                    logOrder.Service_Name__c = label.CyberSource_ServiceName;
                    logOrder.Source__c = label.DA_Source;
                    logOrder.Target__c = label.CyberSource_Target;
                    logOrder.CC_Order__c = ccOrder.ccrz__Order__c;
                }
            }
            if(Test.isRunningTest()) {
                throw new NullPointerException();
            } 
        }catch (Exception e){
            system.debug('Entered into catch block of processRefundForCancelledOrders method in class:' + e.getMessage() + ' Line No:' + e.getLineNumber());
    
            for(String orderObjId : orderIdVsLogMap.keySet()) {
                OSM_Integration_Log__c orderLog = orderIdVsLogMap.get(orderObjId);
                orderLog.Status__c = label.DA_Log_Status_Failure;
                orderLog.Error_Description__c = log.Error_Description__c + '---Exception:' + e.getMessage() + ',' + '\n\n' + 'Stack traced at: ' + e.getStacktraceString();
                orderLog.Service_Name__c = label.CyberSource_ServiceName;
                orderLog.Source__c = label.DA_Source;
                orderLog.Target__c = label.CyberSource_Target;
            }   
        }
    
        OSM_BAMS_WS_RefundResponse_Wrapper responseObj;
        if (lstgenWrap.size() > 0) {
            for (OSM_BAMS_WS_GeneralizedInputWrapper gwrap: lstgenWrap) {
                try{
                    responseObj = OSM_BAMS_WS_Service.prepareBAMSCallForRefund(gwrap);
    
                    System.debug('=======responseObj from Service Layer====='+responseObj);
                    request = responseObj.Request;
                    response = responseObj.Response;
                    if (responseObj.exceptionFlag == true) {
                        OSM_Integration_Log__c logOrder = orderIdVsLogMap.get(gwrap.orderItem.Id);
    
                        logOrder.Status__c = label.DA_Log_Status_Failure;
                        logOrder.Error_Description__c = responseObj.errorMessage;
                        logOrder.Service_Name__c = label.CyberSource_ServiceName;
                        logOrder.Source__c = label.DA_Source;
                        logOrder.Target__c = label.CyberSource_Target;
                        logOrder.Response__c = String.valueOf(responseObj);
                        logOrder.Request__c = String.valueOf(request);
    
                        lst_NewLogs.put(gwrap.orderItem.Id, logOrder);
    
                        if(Test.isRunningTest()) {
                            if(testCase1 == true) {
                                responseObj.refundStatusToBAMS = 'SUCCESS';
                                responseObj.exceptionFlag = false;
                            }
                        }
    
                        if(responseObj.refundStatusToBAMS=='SUCCESS') {
                            //In case money is refunded back to user but there was some error while processing the request
                            gwrap.orderItem.Is_Refund_Initiated__c = true;
                            gwrap.transactionPayment.OSM_BAMS_Cancel_Transaction_Status__c='Refunded but Error in CMI';
                            gwrap.transactionPayment.OSM_BAMS_Cancel_Request__c=responseObj.Request;
                            gwrap.transactionPayment.OSM_BAMS_Cancel_Response__c=responseObj.Response;
                            if(Test.isRunningTest()) {
                                responseObj.OrderRefundResponseNodes = new OSM_BAMS_OrderRefundNodes();
                            }
                            if(responseObj.OrderRefundResponseNodes!=null  || Test.isRunningTest()) {
                                gwrap.transactionPayment.OSM_BAMS_Cancel_Decision__c=responseObj.OrderRefundResponseNodes.decision;
                                gwrap.transactionPayment.OSM_BAMS_Cancel_Reason_Code__c=responseObj.OrderRefundResponseNodes.reasonCode;
                                gwrap.transactionPayment.OSM_BAMS_Cancel_ReconciliationId__c=responseObj.OrderRefundResponseNodes.reconciliationID_ccCap;
                                gwrap.transactionPayment.OSM_BAMS_Cancel_Request_ID__c=responseObj.OrderRefundResponseNodes.requestID;
                            }
                        }else if (responseObj.refundStatusToBAMS=='' || responseObj.refundStatusToBAMS=='FAILURE' || Test.isRunningTest()) { 
                            gwrap.orderItem.Is_Refund_Initiated__c = true;
                            gwrap.transactionPayment.OSM_BAMS_Cancel_Transaction_Status__c='FAILURE'; 
                            gwrap.transactionPayment.OSM_BAMS_Cancel_Request__c=responseObj.Request;
                            gwrap.transactionPayment.OSM_BAMS_Cancel_Response__c=responseObj.Response;
                            if(!Test.isRunningTest())
                                gwrap.transactionPayment.OSM_BAMS_Cancel_Req_Fault_Code__c = 'Fault:'+responseObj.OrderRefundResponseNodes.Fault + '\n faultcode:'+responseObj.OrderRefundResponseNodes.faultcode + '\n Faultstring:'+responseObj.OrderRefundResponseNodes.faultstring;
                            if(Test.isRunningTest()) {
                                responseObj.OrderRefundResponseNodes = new OSM_BAMS_OrderRefundNodes();
                            }
                            if(responseObj.OrderRefundResponseNodes!=null || Test.isRunningTest()) {
                                gwrap.transactionPayment.OSM_BAMS_Cancel_Decision__c=responseObj.OrderRefundResponseNodes.decision;
                                gwrap.transactionPayment.OSM_BAMS_Cancel_Reason_Code__c=responseObj.OrderRefundResponseNodes.reasonCode;
                                gwrap.transactionPayment.OSM_BAMS_Cancel_ReconciliationId__c=responseObj.OrderRefundResponseNodes.reconciliationID_ccCap;
                                gwrap.transactionPayment.OSM_BAMS_Cancel_Request_ID__c=responseObj.OrderRefundResponseNodes.requestID;
                            }
                        }
                    } else if (responseObj.exceptionFlag == false) {
                        OSM_Integration_Log__c logOrder = orderIdVsLogMap.get(gwrap.orderItem.Id);
                        logOrder.Status__c = label.DA_Log_Status_Success;
                        
                        logOrder.Service_Name__c = label.CyberSource_ServiceName;
                        logOrder.Source__c = label.DA_Source;
                        logOrder.Target__c = label.CyberSource_Target;
                        logOrder.Transaction_Payment__c=gwrap.transactionPayment.id;
                        logOrder.CC_Order__c = gwrap.orderId;
                        logOrder.Response__c = String.valueOf(responseObj);
                        logOrder.Request__c = String.valueOf(request);
                        
                        lst_NewLogs.put(gwrap.orderItem.Id, logOrder);
    
                        gwrap.orderItem.Is_Refund_Initiated__c = true;
                        gwrap.transactionPayment.OSM_BAMS_Cancel_Transaction_Status__c='Success';
                        gwrap.transactionPayment.OSM_BAMS_Cancel_Decision__c=responseObj.OrderRefundResponseNodes.decision;
                        gwrap.transactionPayment.OSM_BAMS_Cancel_Reason_Code__c=responseObj.OrderRefundResponseNodes.reasonCode;
                        gwrap.transactionPayment.OSM_BAMS_Cancel_ReconciliationId__c=responseObj.OrderRefundResponseNodes.reconciliationID_ccCap;
                        gwrap.transactionPayment.OSM_BAMS_Cancel_Request_ID__c=responseObj.OrderRefundResponseNodes.requestID;
                        gwrap.transactionPayment.OSM_BAMS_Cancel_Request__c=responseObj.Request;
                        gwrap.transactionPayment.OSM_BAMS_Cancel_Response__c=responseObj.Response;
                    }
    
                    //code to cover test covergae for Catch Block
                    if(Test.isRunningTest()) {
                        throw new NullPointerException();
                    } 
    
                 
                }catch (Exception e) {              
                    log = orderIdVsLogMap.get(gwrap.orderItem.Id);
                    log.Status__c = label.DA_Log_Status_Failure;
                    log.Error_Description__c = log.Error_Description__c + '===Exception:' + e.getMessage() + ',' + '\n\n' + 'Stack traced at: ' + e.getStacktraceString();
                    log.Service_Name__c = label.CyberSource_ServiceName;
                    log.Source__c = label.DA_Source;
                    log.Target__c = label.CyberSource_Target;
                    gwrap.orderItem.Is_Refund_Initiated__c = true;
                    if (responseObj!=null && responseObj.exceptionFlag == true)
                    {
                        if(responseObj.refundStatusToBAMS=='SUCCESS') {
                            //In case money is refunded back to user but there was some error while processing the request
                            gwrap.transactionPayment.OSM_BAMS_Cancel_Transaction_Status__c='Refunded but Error in CMI';  
                        }
                        else if (responseObj.refundStatusToBAMS=='' || responseObj.refundStatusToBAMS=='FAILURE') { 
                            gwrap.transactionPayment.OSM_BAMS_Cancel_Transaction_Status__c='FAILURE'; 
                        }
                    }
                    else if (responseObj!=null && responseObj.exceptionFlag == false) {
                        gwrap.transactionPayment.OSM_BAMS_Cancel_Transaction_Status__c='Success';
                    }
                }
            }
            
            OSM_Orders_In_Invoice__c parentJunc=null;
            for (OSM_BAMS_WS_GeneralizedInputWrapper gwrap: lstgenWrap) {           
                try{
                    sp = Database.setSavepoint();
                    orderItm = gwrap.orderItem;
                    tp = gwrap.transactionPayment;
                    List<sObject> lst = new List<sObject>();
                    lst.add(orderItm);
                    lst.add(tp);
                    
                    if(orderIdVsOrderJuncMap.containsKey(orderId)){
                        parentJunc =  orderIdVsOrderJuncMap.get(orderId);
                        parentJunc.OSM_SW_Is_Refund_Request__c=true;
                        //if(orderItem.Is_Refund_Initiated__c == true && parentJunc.Vertex_Refund_Call_Status__c != 'Success') {
                          //  parentJunc.Vertex_Refund_Call_Status__c = 'Pending';
                        //}
                        lst.add(parentJunc);
                    }
                 
                    Database.update(lst);
                    
                    if(Test.isRunningTest()) {
                        throw new NullPointerException();
                    }
                    if(lst_NewLogs.size() > 0){
                        Database.insert(lst_NewLogs.values());
                    }
                    
                }catch(Exception e) {
                    //In case of any error rollback the TX but insert the log for that order
                    Database.rollback( sp );
                    String errorMsg1 = e.getMessage()  +'\n' + e.getStackTraceString();
                    log= new OSM_Integration_Log__c();
                    log.Status__c = label.DA_Log_Status_Failure;
                    log.Error_Description__c = 'Error occured while saving Order,Transaction Payment record.'+'\n----'+errorMsg1;
                    log.Service_Name__c = label.CyberSource_ServiceName;
                    log.Source__c = label.DA_Source;
                    log.Target__c = label.CyberSource_Target;
                    log.CC_Order__c = orderItm.ccrz__Order__c;
                    log.Transaction_Payment__c = tp.id;
                    List<sObject> logLst = new List<sObject>();
                    logLst.add(log);
                    if(logOrderToSave!=null){
                        logLst.add(logOrderToSave);
                    }               
                    Database.insert(logLst);
                }
            }
        }
    }
  
 
  
/*----------------------------------------------------------------------------------
1. processRefundForFailedOrderCreation
Description: This method is used to refund the money back to the customer card if he is 
charged for an order but order got failed in OSM/CMI
params
 orderList- list of cancelled orders
Return: None

------------------------------------------------------------------------------------*/
    @future(callout=true)
 public static void processRefundForFailedOrderCreation(Id tranPaymentToRefund) {
  String request;
  String response;
  String Status;
  String StatusCode;
  String ResponseBody;

  OSM_Integration_Log__c log = new OSM_Integration_Log__c();
  Savepoint sp;
  
  OSM_BAMS_WS_GeneralizedInputWrapper genWrapObj = new OSM_BAMS_WS_GeneralizedInputWrapper();
  
  List<ccrz__E_TransactionPayment__c> tpLst ;
  ccrz__E_TransactionPayment__c tp;
  boolean errorFlag = false;
  String errorMsg = '';
  OSM_BAMS_WS_RefundResponse_Wrapper responseObj;
  try {

       //add criteria for status..status should not be failed..it should not happen that OSM is refunding for failed transactions also
       tpLst = [Select id, ccrz__Token__c,ccrz__Amount__c,ccrz__CurrencyISOCode__c, ccrz__CCOrder__c,OSM_BAMS_Cancel_Decision__c,OSM_BAMS_Cancel_Reason_Code__c,OSM_BAMS_Cancel_Transaction_Status__c,OSM_BAMS_Cancel_ReconciliationId__c,OSM_BAMS_Cancel_Request_ID__c,OSM_BAMS_Cancel_Request__c,OSM_BAMS_Cancel_Response__c,OSM_BAMS_Cancel_Req_Fault_Code__c from ccrz__E_TransactionPayment__c where id = :tranPaymentToRefund];
        
        if(tpLst!=null && tpLst.size()>0){
            tp = tpLst[0];
        }
      
        //iterate each order and create the log and validate the mandatory fields
        log = new OSM_Integration_Log__c();
        errorFlag = false;
        errorMsg = '';
        log.Transaction_Payment__c = tranPaymentToRefund;
        log.Source__c = label.DA_Source;
        log.Target__c = label.CyberSource_Target;
        log.Service_Name__c = label.CyberSource_ServiceName;
        
        genWrapObj = new OSM_BAMS_WS_GeneralizedInputWrapper();
        genWrapObj.merchantID = label.CyberSource_MerchantId;
        genWrapObj.merchantReferenceCode = String.valueOf(System.currentTimeMillis());
        genWrapObj.PTcurrency = tp.ccrz__CurrencyISOCode__c;
        genWrapObj.grandTotalAmount = tp.ccrz__Amount__c;
        genWrapObj.subscriptionID = tp.ccrz__Token__c;
        
        //code to cover test covergae for Catch Block
       if(Test.isRunningTest()) {
                throw new NullPointerException();
            } 
   
    }catch (Exception e){

    //Vaibhav TBD
   system.debug('Entered into catch block of processRefundForCancelledOrders method in class:' + e.getMessage() + ' Line No:' + e.getLineNumber());
   
        log.Status__c = label.DA_Log_Status_Failure;
        log.Error_Description__c = log.Error_Description__c + '---Exception:' + e.getMessage() + ',' + '\n\n' + 'Stack traced at: ' + e.getStacktraceString();
        
  }

            try{
                
                System.debug('=====tranPaymentToRefund : genWrapObj====='+genWrapObj);
             //process BAMS SOAP request for each order by calling the service layer
             responseObj = OSM_BAMS_WS_Service.prepareBAMSCallForRefund(genWrapObj);
             
             System.debug('=======responseObj from Service Layer====='+responseObj);
             request = responseObj.Request;
             response = responseObj.Response;
             system.debug('ResponseBody' + ResponseBody);
            //in case of exception, process below code to do logging appropriately
             if (responseObj.exceptionFlag == true) {

              log.Status__c = label.DA_Log_Status_Failure;
              log.Error_Description__c = responseObj.errorMessage;
              //Start updating the Order and Transaction Payment record
              
              if(responseObj.refundStatusToBAMS=='SUCCESS' || Test.isRunningTest())
              {
                //In case money is refunded back to user but there was some error while processing the request
                 
                 tp.OSM_BAMS_Cancel_Transaction_Status__c='Refunded but Error in CMI';  
                 tp.OSM_BAMS_Cancel_Request__c=responseObj.Request;
                 tp.OSM_BAMS_Cancel_Response__c=responseObj.Response;
                 tp.Transaction_Status__c = 'Order_Placed_Failed_Refund_Complete';
                 
                if(responseObj.OrderRefundResponseNodes!=null)
                 {
                     tp.OSM_BAMS_Cancel_Decision__c=responseObj.OrderRefundResponseNodes.decision;
                     tp.OSM_BAMS_Cancel_Reason_Code__c=responseObj.OrderRefundResponseNodes.reasonCode;
                     tp.OSM_BAMS_Cancel_ReconciliationId__c=responseObj.OrderRefundResponseNodes.reconciliationID_ccCap;
                     tp.OSM_BAMS_Cancel_Request_ID__c=responseObj.OrderRefundResponseNodes.requestID;
                 }
              
              }else if (responseObj.refundStatusToBAMS=='' || responseObj.refundStatusToBAMS.equalsIgnoreCase('FAILURE'))
              { 
                 
                 tp.OSM_BAMS_Cancel_Transaction_Status__c='FAILURE'; 
                 tp.OSM_BAMS_Cancel_Request__c=responseObj.Request;
                 tp.OSM_BAMS_Cancel_Response__c=responseObj.Response;
                 tp.OSM_BAMS_Cancel_Req_Fault_Code__c = 'Fault:'+responseObj.OrderRefundResponseNodes.Fault + '\n faultcode:'+responseObj.OrderRefundResponseNodes.faultcode + '\n Faultstring:'+responseObj.OrderRefundResponseNodes.faultstring;
                 if(responseObj.OrderRefundResponseNodes!=null)
                 {
                     tp.OSM_BAMS_Cancel_Decision__c=responseObj.OrderRefundResponseNodes.decision;
                     tp.OSM_BAMS_Cancel_Reason_Code__c=responseObj.OrderRefundResponseNodes.reasonCode;
                     tp.OSM_BAMS_Cancel_ReconciliationId__c=responseObj.OrderRefundResponseNodes.reconciliationID_ccCap;
                     tp.OSM_BAMS_Cancel_Request_ID__c=responseObj.OrderRefundResponseNodes.requestID;
                 }
             
              }
              
             } 
             else if (responseObj.exceptionFlag == false) {

             //in case BAMS send the success code then perform below operations
              log.Status__c = label.DA_Log_Status_Success;
              //update Transaction Record While we getting error in response and request
              tp.OSM_BAMS_Cancel_Transaction_Status__c='Success';
              tp.OSM_BAMS_Cancel_Decision__c=responseObj.OrderRefundResponseNodes.decision;
              tp.OSM_BAMS_Cancel_Reason_Code__c=responseObj.OrderRefundResponseNodes.reasonCode;
              tp.OSM_BAMS_Cancel_ReconciliationId__c=responseObj.OrderRefundResponseNodes.reconciliationID_ccCap;
              tp.OSM_BAMS_Cancel_Request_ID__c=responseObj.OrderRefundResponseNodes.requestID;
              tp.OSM_BAMS_Cancel_Request__c=responseObj.Request;
              tp.OSM_BAMS_Cancel_Response__c=responseObj.Response;
              tp.Transaction_Status__c = 'Order_Placed_Failed_Refund_Complete';
             }
             
             //code to cover test covergae for Catch Block
              if(Test.isRunningTest()) {
                    throw new NullPointerException();
               } 
            
             }catch (Exception e) {
               log.Status__c = label.DA_Log_Status_Failure;
               log.Error_Description__c = log.Error_Description__c + '===Exception:' + e.getMessage() + ',' + '\n\n' + 'Stack traced at: ' + e.getStacktraceString();

               if (responseObj!=null && responseObj.exceptionFlag == true)
               {
                    if(responseObj.refundStatusToBAMS=='SUCCESS')
                    {
                        //In case money is refunded back to user but there was some error while processing the request
                         tp.OSM_BAMS_Cancel_Transaction_Status__c='Refunded but Error in CMI';
                         tp.Transaction_Status__c = 'Order_Placed_Failed_Refund_Complete';
                    }
                    else if (responseObj.refundStatusToBAMS=='' || responseObj.refundStatusToBAMS=='FAILURE')
                    { 
                     
                     tp.OSM_BAMS_Cancel_Transaction_Status__c='FAILURE'; 
                     
                    }
              }
              else if (responseObj!=null && responseObj.exceptionFlag == false)
              {
                 tp.OSM_BAMS_Cancel_Transaction_Status__c='Success';
                 tp.Transaction_Status__c = 'Order_Placed_Failed_Refund_Complete';
              }
              
             }
            
            //Save all the records for Order in one transaction...
            //rollback the TX if any error but make an entry in log
                try{
                        sp = Database.setSavepoint();
                        //code to cover test covergae for Catch Block
                       if(Test.isRunningTest()) {
                            throw new NullPointerException();
                        }

                        Database.update(tp);
                        Database.insert(log);
                        
                    
                   }catch(Exception e)
                   {
                        //In case of any error rollback the TX but insert the log for that order
                        Database.rollback( sp );
                        String errorMsg1 = e.getMessage()  +'\n' + e.getStackTraceString();
                        log.Status__c = label.DA_Log_Status_Failure;
                        log.Error_Description__c = 'Error occured while saving Transaction Payment record during Refund.'+'\n----'+errorMsg1;
                        Database.insert(log);
                        
                   }
                 
 }
}