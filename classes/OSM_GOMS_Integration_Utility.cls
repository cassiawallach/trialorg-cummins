public class OSM_GOMS_Integration_Utility{
    public static GOMS_IP_Wrapper createInputRequestWrapper(ccrz__E_Invoice__c invoiceObj,ccrz__E_TransactionPayment__c transRecord, boolean isCancelReq){
        GOMS_IP_Wrapper.InvoiceHeaders invHeaders = new GOMS_IP_Wrapper.InvoiceHeaders();
        List<GOMS_IP_Wrapper.InvoiceLines> invoiceLines = new List<GOMS_IP_Wrapper.InvoiceLines>();
        Integer lineCount = 1;
        String shipToAbbr='';
        if(invoiceObj.ccrz__BillTo__r.EBU_Channel_of_Distribution__c == 'CIHR' || invoiceObj.ccrz__BillTo__r.PSBU_Channel_of_Distribution__c == 'CIHR')
        {
            shipToAbbr = invoiceObj.ccrz__BillTo__r.OSM_SW_Responsible_Region__c;
        }
        else
        {
             shipToAbbr = invoiceObj.ccrz__BillTo__r.CSS_DistributorCode__c;
        }
        if(shipToAbbr != null && shipToAbbr != '0' && shipToAbbr.startsWith('0')){
            shipToAbbr = shipToAbbr.subString(1);
        }
        
        GOMS_IP_Wrapper.InvoiceHeaderNotes invHeaderNotes = new GOMS_IP_Wrapper.InvoiceHeaderNotes();
        invHeaderNotes.transactionID = invoiceObj.Name;
        //invHeaderNotes.shipToAbbreviation = invoiceObj.ccrz__BillTo__r.CSS_DistributorCode__c;
        invHeaderNotes.shipToAbbreviation = shipToAbbr;
        invHeaderNotes.transactionLineNumber = 1;
        invHeaderNotes.noteNumber = 1;
        //invHeaderNotes.noteText = invoiceObj.Note_Text__c;
        invHeaderNotes.noteText = transRecord.ccrz__AccountNumber__c;
        invHeaderNotes.updatedBy = invoiceObj.LastModifiedBy.Name;
        invHeaderNotes.createDate = String.valueOf(invoiceObj.CreatedDate);
        invHeaderNotes.recordDate = String.valueOf(invoiceObj.LastModifiedDate);
        invHeaderNotes.createdBu = invoiceObj.CreatedBy.Name;
        
        invHeaders.transactionID = invoiceObj.Name;
        invHeaders.shipToAbbreviation = shipToAbbr;
        if(isCancelReq){
           
            invHeaders.invoiceCode = Label.GOMS_Cancelled_Invoice_Req_Code;
        }else{
             invHeaders.invoiceCode = Label.GOMS_New_Invoice_Req_Code;
        }
        invHeaders.updatedBy = invoiceObj.LastModifiedBy.Name;
        invHeaders.createDate = String.valueOf(invoiceObj.CreatedDate);
        invHeaders.recordDate = String.valueOf(invoiceObj.LastModifiedDate);
        invHeaders.createdBy = invoiceObj.CreatedBy.Name;
        invHeaders.invoiceHeaderNotes = new List<GOMS_IP_Wrapper.InvoiceHeaderNotes>{invHeaderNotes};
        
        for(ccrz__E_InvoiceItem__c invItem : invoiceObj.ccrz__InvoiceItems__r){
             //  Mar- 920 start
             GOMS_IP_Wrapper.InvoiceLineNotes invNoteLines = new GOMS_IP_Wrapper.InvoiceLineNotes();
                                                         
                                                         
             invNoteLines.noteNumber = 1;
             //condition added for MAR-1207
             if(invItem.ccrz__CCOrderItem__r.ccrz__Product__r.GOMS_Part_Number__c!=Null && invoiceObj.ccrz__BillTo__r.BillingCountry != 'Canada' && invItem.ccrz__CCOrderItem__r.ccrz__Product__r.Group_Name__c == 'SES')
             {
                  invNoteLines.noteText = invItem.ccrz__CCOrderItem__r.ccrz__Product__r.GOMS_Part_Number__c +' '+invItem.ccrz__CCOrderItem__r.ccrz__Product__r.Name; 
             }
             else
             {
                 invNoteLines.noteText = invItem.ccrz__CCOrderItem__r.ccrz__Product__r.ccrz__SKU__c +' '+invItem.ccrz__CCOrderItem__r.ccrz__Product__r.Name; 
             }
             invNoteLines.transactionID = invoiceObj.Name; //Mar-920 end
             invNoteLines.shipToAbbreviation = shipToAbbr;
             invNoteLines.transactionLineNumber = lineCount;
             /*invNoteLines.updatedBy = invItem.LastModifiedBy.Name;
             invNoteLines.createDate = String.valueOf(invItem.CreatedDate);
             invNoteLines.recordDate = String.valueOf(invItem.LastModifiedDate);
             invNoteLines.createdBy = invItem.CreatedBy.Name;
             */
            
            GOMS_IP_Wrapper.InvoiceLines invLines = new GOMS_IP_Wrapper.InvoiceLines();
            invLines.transactionID = invoiceObj.Name;
            invLines.shipToAbbreviation = shipToAbbr;
            invLines.transactionLineNumber = lineCount;
            
            invLines.invoiceQuantity = Integer.valueOf(invItem.ccrz__CCOrderItem__r.ccrz__Quantity__c);
            Integer quantity=Integer.valueOf(invItem.ccrz__CCOrderItem__r.ccrz__Quantity__c);
            // if(orderItem.ccrz__Product__r.GOMS_Defined_Part_number__c==true) //Mar-1132
             if(invItem.ccrz__CCOrderItem__r.ccrz__Product__r.GOMS_Part_Number__c!=Null && invoiceObj.ccrz__BillTo__r.BillingCountry != 'Canada' && invItem.ccrz__CCOrderItem__r.ccrz__Product__r.Group_Name__c == 'SES')
            {
                invLines.unitPrice = null;
                invLines.lineDescription = '';
                invLines.financeBusinessCode = '';
                invLines.financeResponseCode = '';
                invLines.financeSubBusinessCode = '';
                //invLines.partNumber = invItem.ccrz__CCOrderItem__r.ccrz__Product__r.ccrz__SKU__c; Mar-1132
                invLines.partNumber = invItem.ccrz__CCOrderItem__r.ccrz__Product__r.GOMS_Part_Number__c;  
            }
            else
            {
                invLines.partNumber = ''; 
                //invLines.unitPrice = invItem.ccrz__CCOrderItem__r.ccrz__Price__c;
                invLines.unitPrice = invItem.ccrz__CCOrderItem__r.Dn_Price__c/quantity;   
                invLines.lineDescription = invItem.ccrz__CCOrderItem__r.ccrz__Product__r.Name;
                invLines.financeBusinessCode = invItem.ccrz__CCOrderItem__r.ccrz__Product__r.FIN_BUSINESS_CODE__c;
                invLines.financeResponseCode = invItem.ccrz__CCOrderItem__r.ccrz__Product__r.FIN_RESP_CODE__c;
                invLines.financeSubBusinessCode = invItem.ccrz__CCOrderItem__r.ccrz__Product__r.FIN_SUB_BUSINESS_CODE__c;
            }
            
            invLines.updatedBy = invItem.LastModifiedBy.Name;
            invLines.createDate = String.valueOf(invItem.CreatedDate);
            invLines.recordDate = String.valueOf(invItem.LastModifiedDate);
            invLines.createdBy = invItem.CreatedBy.Name;
            invLines.invoiceLineNotes = new List<GOMS_IP_Wrapper.InvoiceLineNotes>{invNoteLines}; //Mar-920
            
            invoiceLines.add(invLines);
            lineCount++;
        }
        GOMS_IP_Wrapper gomsWrap = new GOMS_IP_Wrapper();
        
        GOMS_IP_Wrapper.DataArea dataAreaObj = new GOMS_IP_Wrapper.DataArea();
        dataAreaObj.invoiceHeaders = invHeaders;
        dataAreaObj.invoiceLines = invoiceLines;
        
        GOMS_IP_Wrapper.Target targetObj = new GOMS_IP_Wrapper.Target();
        targetObj.TargetID = Label.GOMS;
        GOMS_IP_Wrapper.Sender senderObj = new GOMS_IP_Wrapper.Sender();
        senderObj.ServiceName = Label.GOMS_Service_Name;
        senderObj.SenderID = Label.GOMS_Sender_id;
        GOMS_IP_Wrapper.Header headerObj = new GOMS_IP_Wrapper.Header ();
        headerObj.Target = targetObj;
        headerObj.Sender = senderObj;
        
        gomsWrap.DataArea = dataAreaObj;
        gomsWrap.Header = headerObj;
        
        return gomsWrap;
    }
    
    //Method to create request for rcurring Invoice Intercompany...
    public static GOMS_IP_Wrapper createInputRequestWrapperRecurring(ccrz__E_Invoice__c invoiceObj,List<ccrz__E_OrderItem__c> orderIttems,ccrz__E_TransactionPayment__c transRecord, boolean isCancelReq)
    {
        GOMS_IP_Wrapper.InvoiceHeaders invHeaders = new GOMS_IP_Wrapper.InvoiceHeaders();
        List<GOMS_IP_Wrapper.InvoiceLines> invoiceLines = new List<GOMS_IP_Wrapper.InvoiceLines>();
        Integer lineCount = 1;
        //String shipToAbbr = invoiceObj.ccrz__BillTo__r.CSS_DistributorCode__c;
        String shipToAbbr='';
        if(invoiceObj.ccrz__BillTo__r.EBU_Channel_of_Distribution__c == 'CIHR' || invoiceObj.ccrz__BillTo__r.PSBU_Channel_of_Distribution__c == 'CIHR')
        {
            shipToAbbr = invoiceObj.ccrz__BillTo__r.OSM_SW_Responsible_Region__c;
        }
        else
        {
             shipToAbbr = invoiceObj.ccrz__BillTo__r.CSS_DistributorCode__c;
        }
        if(shipToAbbr != null && shipToAbbr != '0' && shipToAbbr.startsWith('0')){
            shipToAbbr = shipToAbbr.subString(1);
        }
        
        GOMS_IP_Wrapper.InvoiceHeaderNotes invHeaderNotes = new GOMS_IP_Wrapper.InvoiceHeaderNotes();
        invHeaderNotes.transactionID = invoiceObj.Name;
        //invHeaderNotes.shipToAbbreviation = invoiceObj.ccrz__BillTo__r.CSS_DistributorCode__c;
        invHeaderNotes.shipToAbbreviation = shipToAbbr;
        invHeaderNotes.transactionLineNumber = 1;
        invHeaderNotes.noteNumber = 1;
        //invHeaderNotes.noteText = invoiceObj.Note_Text__c;
        //invHeaderNotes.noteText = transRecord.ccrz__AccountNumber__c;
        invHeaderNotes.noteText = transRecord.Name;
        invHeaderNotes.updatedBy = invoiceObj.LastModifiedBy.Name;
        invHeaderNotes.createDate = String.valueOf(invoiceObj.CreatedDate);
        invHeaderNotes.recordDate = String.valueOf(invoiceObj.LastModifiedDate);
        invHeaderNotes.createdBu = invoiceObj.CreatedBy.Name;
        
        invHeaders.transactionID = invoiceObj.Name;
        invHeaders.shipToAbbreviation = shipToAbbr;
        if(isCancelReq){
           
            invHeaders.invoiceCode = Label.GOMS_Cancelled_Invoice_Req_Code;
        }else{
             invHeaders.invoiceCode = Label.GOMS_New_Invoice_Req_Code;
        }
        invHeaders.updatedBy = invoiceObj.LastModifiedBy.Name;
        invHeaders.createDate = String.valueOf(invoiceObj.CreatedDate);
        invHeaders.recordDate = String.valueOf(invoiceObj.LastModifiedDate);
        invHeaders.createdBy = invoiceObj.CreatedBy.Name;
        invHeaders.invoiceHeaderNotes = new List<GOMS_IP_Wrapper.InvoiceHeaderNotes>{invHeaderNotes};
        
        for(ccrz__E_OrderItem__c orderItem : orderIttems){
            //Mar-920 start
            GOMS_IP_Wrapper.InvoiceLineNotes invNoteLines = new GOMS_IP_Wrapper.InvoiceLineNotes();
                                                         
                                                         
            invNoteLines.noteNumber = 1;
            //condition added for MAR-1207
            if(orderItem.ccrz__Product__r.GOMS_Part_Number__c!=Null && invoiceObj.ccrz__BillTo__r.BillingCountry != 'Canada' && orderItem.ccrz__Product__r.Group_Name__c == 'SES')
            {
                    invNoteLines.noteText = orderItem.ccrz__Product__r.GOMS_Part_Number__c +' '+orderItem.ccrz__Product__r.Name; 
            }
            else
            {
                   invNoteLines.noteText = orderItem.ccrz__Product__r.ccrz__SKU__c +' '+orderItem.ccrz__Product__r.Name; 
            }
            //invNoteLines.noteText = orderItem.ccrz__Product__r.ccrz__SKU__c +' '+orderItem.ccrz__Product__r.Name; //Mar-920 end
            invNoteLines.transactionID = invoiceObj.Name; //Mar-920 end
            invNoteLines.shipToAbbreviation = shipToAbbr;
            invNoteLines.transactionLineNumber = lineCount;
            /*invNoteLines.updatedBy = invItem.LastModifiedBy.Name;
            invNoteLines.createDate = String.valueOf(invItem.CreatedDate);
            invNoteLines.recordDate = String.valueOf(invItem.LastModifiedDate);
            invNoteLines.createdBy = invItem.CreatedBy.Name;
            */
            
            GOMS_IP_Wrapper.InvoiceLines invLines = new GOMS_IP_Wrapper.InvoiceLines();
            invLines.transactionID = invoiceObj.Name;
            invLines.shipToAbbreviation = shipToAbbr;
            invLines.transactionLineNumber = lineCount;
            
            invLines.invoiceQuantity = Integer.valueOf(orderItem.ccrz__Quantity__c);
            Integer quantity=Integer.valueOf(orderItem.ccrz__Quantity__c);
            // if(orderItem.ccrz__Product__r.GOMS_Defined_Part_number__c==true) //Mar-1132
             if(orderItem.ccrz__Product__r.GOMS_Part_Number__c!=Null && invoiceObj.ccrz__BillTo__r.BillingCountry != 'Canada' && orderItem.ccrz__Product__r.Group_Name__c == 'SES')
            {
                invLines.unitPrice = null;
                invLines.lineDescription = '';
                invLines.financeBusinessCode = '';
                invLines.financeResponseCode = '';
                invLines.financeSubBusinessCode = '';
                //invLines.partNumber = orderItem.ccrz__Product__r.ccrz__SKU__c; Mar-1132
                invLines.partNumber = orderItem.ccrz__Product__r.GOMS_Part_Number__c;                                                                    
            }
            else
            {
                invLines.partNumber = ''; 
                //invLines.unitPrice = invItem.ccrz__CCOrderItem__r.ccrz__Price__c;
                invLines.unitPrice = orderItem.Dn_Price__c/quantity;   
                invLines.lineDescription = orderItem.ccrz__Product__r.Name;
                invLines.financeBusinessCode = orderItem.ccrz__Product__r.FIN_BUSINESS_CODE__c;
                invLines.financeResponseCode = orderItem.ccrz__Product__r.FIN_RESP_CODE__c;
                invLines.financeSubBusinessCode = orderItem.ccrz__Product__r.FIN_SUB_BUSINESS_CODE__c;
            }
            
            invLines.updatedBy =  orderItem.LastModifiedBy.Name;
            invLines.createDate = String.valueOf(orderItem.CreatedDate);
            invLines.recordDate = String.valueOf(orderItem.LastModifiedDate);
            invLines.createdBy =  orderItem.CreatedBy.Name;
            invLines.invoiceLineNotes = new List<GOMS_IP_Wrapper.InvoiceLineNotes>{invNoteLines}; //Mar-920
             
            invoiceLines.add(invLines);
            lineCount++;
        }
        GOMS_IP_Wrapper gomsWrap = new GOMS_IP_Wrapper();
        
        GOMS_IP_Wrapper.DataArea dataAreaObj = new GOMS_IP_Wrapper.DataArea();
        dataAreaObj.invoiceHeaders = invHeaders;
        dataAreaObj.invoiceLines = invoiceLines;
        
        GOMS_IP_Wrapper.Target targetObj = new GOMS_IP_Wrapper.Target();
        targetObj.TargetID = Label.GOMS;
        GOMS_IP_Wrapper.Sender senderObj = new GOMS_IP_Wrapper.Sender();
        senderObj.ServiceName = Label.GOMS_Service_Name;
        senderObj.SenderID = Label.GOMS_Sender_id;
        GOMS_IP_Wrapper.Header headerObj = new GOMS_IP_Wrapper.Header ();
        headerObj.Target = targetObj;
        headerObj.Sender = senderObj;
        
        gomsWrap.DataArea = dataAreaObj;
        gomsWrap.Header = headerObj;
        
        return gomsWrap;
    }
}