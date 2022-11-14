/************************************************************
Name:  OSM_GOSM_InvoiveIdIntegration 
Copyright © 2020  Cummins
=============================================================
=============================================================
Purpose:                                                            
Used as GOMS integration service class

=============================================================
=============================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE              DETAIL                                
1.0 -   Ashish            4/23/2020     INITIAL DEVELOPMENT          


*************************************************************/
public class OSM_GOMS_InvoiveIdIntegration {
    public static void callGOMSService(string invoiceId, boolean isCancelReq){        
        ccrz__E_Invoice__c invoiceObjRec;
        Integer retryAPICallForErr=0;
        Integer retryAPICallForExp=0;
        Set<String> set_MissingField = new Set<String>();
        
        for(ccrz__E_Invoice__c invoiceObj : [SELECT Id, Name,ccrz__BillTo__r.EBU_Channel_of_Distribution__c,ccrz__BillTo__r.PSBU_Channel_of_Distribution__c,ccrz__BillTo__r.OSM_SW_Responsible_Region__c, ccrz__BillTo__r.CSS_DistributorCode__c,ccrz__BillTo__r.BillingCountry, Note_Text__c,Original_Sales_Order_Invoice_Number__c,
                                                Is_GOMS_Integration_Processed__c, CreatedBy.Name, CreatedDate, LastModifiedBy.Name, LastModifiedDate,IsRecurringIntercompanyInvoice__c,
                                                (SELECT ccrz__CCOrderItem__r.ccrz__Quantity__c, ccrz__CCOrderItem__r.ccrz__Price__c,ccrz__CCOrderItem__r.Dn_Price__c,
                                                    ccrz__CCOrderItem__r.ccrz__Product__r.GOMS_Part_Number__c,ccrz__CCOrderItem__r.ccrz__Product__r.Group_Name__c,ccrz__CCOrderItem__r.ccrz__Product__r.ccrz__SKU__c, ccrz__CCOrderItem__r.ccrz__Product__r.FIN_BUSINESS_CODE__c,
                                                    ccrz__CCOrderItem__r.ccrz__Product__r.FIN_RESP_CODE__c, ccrz__CCOrderItem__r.ccrz__Product__r.FIN_SUB_BUSINESS_CODE__c, 
                                                    ccrz__CCOrderItem__r.ccrz__Product__r.Name, ccrz__CCOrderItem__r.ccrz__Product__r.GOMS_Defined_Part_number__c, CreatedBy.Name, CreatedDate, LastModifiedBy.Name, LastModifiedDate
                                                        FROM ccrz__InvoiceItems__r where ccrz__CCOrderItem__r.ccrz__OrderLineType__c!='Minor' and ccrz__CCOrderItem__c!=Null) 
                                                FROM ccrz__E_Invoice__c WHERE Id =:invoiceId]){
            invoiceObjRec = invoiceObj;
        }
        Set<id> orderIds=new Set<Id>();
        List<ccrz__E_OrderItem__c> orderItemsList=new List<ccrz__E_OrderItem__c>();
        
        //Quering OSM Order Invoice and order invoice line Junction object Data...
        List<OSM_Orders_In_Invoice__c> OrderInvoiceJunList=[SELECT CC_Invoice__c,CC_Order__c FROM OSM_Orders_In_Invoice__c where  CC_Invoice__c =:invoiceId];
    
        For(OSM_Orders_In_Invoice__c osmOrderIn:OrderInvoiceJunList)
        {
            orderIds.add(osmOrderIn.CC_Order__c);
        }
        //Quering Order and Order Items....
        List<ccrz__E_Order__c> OrderList=[SELECT id,(SELECT ccrz__Quantity__c, ccrz__Price__c,Dn_Price__c,
                                                    ccrz__Product__r.ccrz__SKU__c,ccrz__Product__r.FIN_BUSINESS_CODE__c,
                                                    ccrz__Product__r.FIN_RESP_CODE__c,ccrz__Product__r.FIN_SUB_BUSINESS_CODE__c, 
                                                    ccrz__Product__r.Name,ccrz__Product__r.GOMS_Part_Number__c,ccrz__Product__r.GOMS_Defined_Part_number__c, CreatedBy.Name, CreatedDate, LastModifiedBy.Name, LastModifiedDate FROM ccrz__E_OrderItems__r) FROM ccrz__E_Order__c WHERE id IN: orderIds];
        for(ccrz__E_Order__c order:OrderList)
         {
             if(order.ccrz__E_OrderItems__r!=null)
                {
                    for(ccrz__E_OrderItem__c orderItemListRecord:order.ccrz__E_OrderItems__r)
                    {
                        orderItemsList.add(orderItemListRecord);
                    }
                }
         }
    
        List<ccrz__E_TransactionPayment__c> tranRecordList=new List<ccrz__E_TransactionPayment__c>();
        if(isCancelReq==false && !invoiceObjRec.IsRecurringIntercompanyInvoice__c)
        {
            tranRecordList=[select id,ccrz__AccountNumber__c,Name from ccrz__E_TransactionPayment__c where ccrz__InvoiceAppliedTo__c=:invoiceId];
        }
        else
        {
            tranRecordList=[select id,ccrz__AccountNumber__c,Name from ccrz__E_TransactionPayment__c where ccrz__InvoiceAppliedTo__c=:invoiceObjRec.Original_Sales_Order_Invoice_Number__c];
       
        }
        if(invoiceObjRec != null){
            OSM_Integration_Log__c log = new OSM_Integration_Log__c();
            log.Target__c = Label.GOMS;
            log.Source__c = Label.GOMS_Sender_id;
            log.Service_Name__c = Label.GOMS + ' ' + Label.GOMS_Service_Name;
            log.Logged_In_User__c = userinfo.getuserid();
            log.Retrial_Count__c = retryAPICallForErr;
            log.Invoice__c=invoiceObjRec.id;
            
            if(tranRecordList ==null)
                set_MissingField.add(Label.GOMS_Invoice_Note_Text);
            if(invoiceObjRec.ccrz__BillTo__r.CSS_DistributorCode__c == null || ((invoiceObjRec.ccrz__BillTo__r.EBU_Channel_of_Distribution__c == 'CIHR' || invoiceObjRec.ccrz__BillTo__r.PSBU_Channel_of_Distribution__c == 'CIHR') && invoiceObjRec.ccrz__BillTo__r.OSM_SW_Responsible_Region__c == null))
                set_MissingField.add(Label.GOMS_Account_Ship_To_Abbr);
                
            if(set_MissingField.size() == 0){
                GOMS_IP_Wrapper gomsWrapper = new GOMS_IP_Wrapper();
                if(invoiceObjRec.IsRecurringIntercompanyInvoice__c)
                {
                    gomsWrapper=OSM_GOMS_Integration_Utility.createInputRequestWrapperRecurring(invoiceObjRec,orderItemsList,tranRecordList[0],isCancelReq);
                }
                else
                {
                    gomsWrapper=OSM_GOMS_Integration_Utility.createInputRequestWrapper(invoiceObjRec,tranRecordList[0],isCancelReq);
                }
                String jsonStr = JSON.serialize(gomsWrapper);
                System.debug('JSON String>>>>>'+jsonStr);
                
                log.Request__c = jsonStr;
                
                GOMS_IP_IntegrationRequestWrapper gomsIPReqWrap = new GOMS_IP_IntegrationRequestWrapper();
                gomsIPReqWrap.jsonReqBody = jsonStr;
                gomsIPReqWrap.methodType = 'POST';
                gomsIPReqWrap.timeOut = 120000;
                gomsIPReqWrap.serviceName = Label.GOSM_Invoice_Integration;
                
                //GOMS_OP_Wrapper gomsOPWrapper = GOMS_Mule_Integration.calloutGeneric(gomsIPReqWrap);  
                
                //this is used for testing
                GOMS_OP_Wrapper gomsOPWrapper = GOMS_Mule_Integration.calloutGeneric(gomsIPReqWrap);
                
                if(gomsOPWrapper.exceptionFlag == true && gomsOPWrapper.response == null){
                    log.Status__c = 'Failure'; 
                    system.debug('error>>>>'+ gomsOPWrapper.exceptionMessage);
                    log.Error_Description__c = gomsOPWrapper.exceptionMessage;
                }
                else if(gomsOPWrapper.exceptionFlag == true && gomsOPWrapper.response != null){
                    log.Status__c = 'Failure'; 
                    string responsBody = gomsOPWrapper.response.getBody();
                    GOMS_OP_Wrapper wrapObj = (GOMS_OP_Wrapper)System.JSON.deserialize(responsBody, GOMS_OP_Wrapper.class); 
                    log.Error_Description__c = gomsOPWrapper.exceptionMessage + ' ' + wrapObj.ReturnCodeDescription;
                    log.Response__c = gomsOPWrapper.response.getBody();
                }
                
                else if(gomsOPWrapper.exceptionFlag != true && gomsOPWrapper.response != null){
                    log.Status__c = 'Success'; 
                    string responsBody = gomsOPWrapper.response.getBody();
                    log.Response__c = responsBody;
                    GOMS_OP_Wrapper wrapObj = (GOMS_OP_Wrapper)System.JSON.deserialize(responsBody, GOMS_OP_Wrapper.class);   
                    invoiceObjRec.Is_GOMS_Integration_Processed__c = true;
                    
                    update invoiceObjRec;     
                }
            }
            else{
                String mandeToryString;
                for(String valueStr : set_MissingField) {
                    if(mandeToryString != null)
                        mandeToryString = mandeToryString+', '+valueStr;
                    else
                        mandeToryString = valueStr;                    
                }
                log.Error_Description__c='Mandatory fields are missing: '+mandeToryString;
                log.Status__c = 'Failure';
            }
            insert log;
        }
    }
}