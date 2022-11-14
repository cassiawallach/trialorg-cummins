@RestResource(urlMapping='/BMSGetPDF/*')
global with sharing class OSM_BMSGetPDF {
    
    //==============================================================================================
    // *** REST Post *** :  Requires the id of Invoice and return results as Response Type
    //===============================================================================================
    @HttpPost
    global static OSM_FSDPDF_RES Post(){
        
        OSM_Integration_Log__c log;      
         OSM_FSDPDF_RES.OSMResponse respJSON=null;
         OSM_FSDPDF_REQ reqJSON = null;
         OSM_FSDPDF_RES resJSON=null;
         Boolean exceptionflag = false;
         Boolean RequiredFieldMissingFlag = false;
         Set<Boolean> sflag = new Set<Boolean>();
         ccrz__E_Invoice__c invoiceDetails= new ccrz__E_Invoice__c();
         List<ccrz__E_Invoice__c> invoiceList;
         RestRequest req = RestContext.request;
         RestResponse res = RestContext.response;
         res.addHeader('Content-Type', 'application/json');
         system.debug('@r22222'+res);
         String jSONRequestBody = req.requestBody.toString().trim(); //Get the request body
         system.debug('jSONRequestBody______'+jSONRequestBody);
         reqJSON = (OSM_FSDPDF_REQ)JSON.deserialize(jSONRequestBody,OSM_FSDPDF_REQ.class); //Deserialize the request body
        
        // Start : For Logging purpose
        OSM_FSDPDF_REQ withoutPDFStringReqJson = (OSM_FSDPDF_REQ)JSON.deserialize(jSONRequestBody,OSM_FSDPDF_REQ.class);
        String jSONRequestBodyWithoutPDFString = '';
            
            for(Integer i=0; i<withoutPDFStringReqJson.DataArea.CInvoice_Header.size(); i++)
        {
            if(withoutPDFStringReqJson.DataArea.CInvoice_Header[i].BMS_OE_REFERENCE!=null 
               && withoutPDFStringReqJson.DataArea.CInvoice_Header[i].BRANCH_LOCATION!=null 
               && withoutPDFStringReqJson.DataArea.CInvoice_Header[i].ORDER_SOURCE_TYPE!=null 
               && withoutPDFStringReqJson.DataArea.CInvoice_Header[i].BMS_INVOICE_NUMBER!=null 
               && (withoutPDFStringReqJson.DataArea.CInvoice_Header[i].BMSInvoicePDF!=null 
                   && withoutPDFStringReqJson.DataArea.CInvoice_Header[i].BMSInvoicePDF!=''))
            {
                        withoutPDFStringReqJson.DataArea.CInvoice_Header[i].BMSInvoicePDF = '';
            }
        }
        jSONRequestBodyWithoutPDFString = JSON.serialize(withoutPDFStringReqJson); //String.valueOf(withoutPDFStringReqJson);
        // End : For Logging purpose
        
         system.debug('reqJSON'+reqJSON);
         resJSON = new OSM_FSDPDF_RES(); 
         //Initialize Object for Data Area's
         List<OSM_FSDPDF_REQ.CInvoice_Header> invoiceHeaderList=new List<OSM_FSDPDF_REQ.CInvoice_Header>();
   //     OSM_FSDPDF_REQ.CInvoice_Header cinvoice=new OSM_FSDPDF_REQ.CInvoice_Header();
         invoiceHeaderList=reqJSON.DataArea.CInvoice_Header;
         Map<Integer,OSM_FSDPDF_REQ.CInvoice_Header> mapInvoiceHeader=new Map<Integer,OSM_FSDPDF_REQ.CInvoice_Header>();
         System.debug('invoiceHeaderList_____'+invoiceHeaderList);
         String pdfContent;
        String orderSourceType;
    String refundBMSNumber;   
         
        /*
        Set<Integer> invoiceNumberSet=new Set<Integer>();
        
         for(OSM_FSDPDF_REQ.CInvoice_Header invoiceNumber:invoiceHeaderList){
             if(invoiceNumber.BMS_INVOICE_NUMBER!=null){
                 invoiceNumberSet.add(invoiceNumber.BMS_INVOICE_NUMBER);
             }
         }
         */
        String AccountId; //Added By Dhiraj
        String prefixedZeros = '0000000000';
        String orderFormat = 'I-';
        
        Set<String> invoiceNumberSet=new Set<String>();
        Set<String> invoiceNumberSetCM=new Set<String>();
        for(OSM_FSDPDF_REQ.CInvoice_Header invoiceNumber:invoiceHeaderList){
             if(invoiceNumber.OSM_INVOICE_NUMBER!=null){
                 // need to build the order number
                 System.debug('invoiceNumber.OSM_INVOICE_NUMBER.containsIgnoreCase() : '+invoiceNumber.OSM_INVOICE_NUMBER.containsIgnoreCase('C'));
                 if(invoiceNumber.OSM_INVOICE_NUMBER.containsIgnoreCase('C'))
                 {
                     invoiceNumber.OSM_INVOICE_NUMBER = invoiceNumber.OSM_INVOICE_NUMBER.removeEndIgnoreCase('C');
                     System.debug('invoiceNumber.OSM_INVOICE_NUMBER : '+invoiceNumber.OSM_INVOICE_NUMBER);
                 }

                 String orderNumber = orderFormat + OSM_Generic_Utility.fieldSizeRestriction(prefixedZeros + String.valueOf(invoiceNumber.OSM_INVOICE_NUMBER), 10, 'back');
				 invoiceNumberSet.add(orderNumber);
                 orderSourceType = invoiceNumber.ORDER_SOURCE_TYPE;
				 /*
                 if(orderSourceType == 'OSM')
                 {
                    invoiceNumberSet.add(orderNumber);
                 }
                 else if(orderSourceType == 'OSMCM')
                 {
                    invoiceNumberSetCM.add(orderNumber);
                 }*/
             }
         }
        
        System.debug('invoiceNumberSet : '+invoiceNumberSet);
        // Changes - Juhi - Feb 14 - will not attach PDF to Intercompany invoices
        List<ccrz__E_Invoice__c> invListUpdate=new List<ccrz__E_Invoice__c>();
         List<ccrz__E_Order__c> orderListUpdate=new List<ccrz__E_Order__c>();
         Set<id> orderidSet=new Set<id>();
        List<Attachment> attachmentPDFList = new List<Attachment>();

         //invoiceList=[Select id,Name,OSM_PDF_Received__c, BMS_InvoiceNumber__c, OSM_SW_IsIntercompanyInvoice__c from ccrz__E_Invoice__c where BMS_InvoiceNumber__c IN:invoiceNumberSet and OSM_SW_IsIntercompanyInvoice__c=false];
         //if(orderSourceType == 'OSM')
         //{
             invoiceList = new List<ccrz__E_Invoice__c>();
            invoiceList=[Select id,Name,ccrz__BillTo__c, BMS_Refund_PDF_Received__c, ccrz__CCOrder__c, ccrz__CCOrder__r.Name, ccrz__CCOrder__r.Is_BMS_PDF_Received__c,OSM_PDF_Received__c, BMS_InvoiceNumber__c, OSM_SW_IsIntercompanyInvoice__c from ccrz__E_Invoice__c where Name IN:invoiceNumberSet  and OSM_SW_IsIntercompanyInvoice__c=false and Invoice_Type__c != 'Credit Memo'ORDER BY CreatedDate DESC Limit 1];
            // code for find main invoice of credit memo: Start
			/*
            if(invoiceNumberSetCM.size() > 0)
            {
                List<ccrz__E_Invoice__c> invoiceList2 = new List<ccrz__E_Invoice__c>();
                List<ccrz__E_Invoice__c> invoiceList3 = new List<ccrz__E_Invoice__c>();
                Set<Id> setInvoiceId = new Set<Id>();
                invoiceList2 = [Select id,Original_Sales_Order_Invoice_Number__c from ccrz__E_Invoice__c where Name IN:invoiceNumberSetCM ];
                for(ccrz__E_Invoice__c objInv : invoiceList2)
                {
                    if(objInv.Original_Sales_Order_Invoice_Number__c != null)
                        setInvoiceId.add(objInv.Original_Sales_Order_Invoice_Number__c);
                }
                if(setInvoiceId.size() > 0)
                {
                    invoiceList3=[Select id,Name,ccrz__BillTo__c, BMS_Refund_PDF_Received__c, ccrz__CCOrder__c, ccrz__CCOrder__r.Name, ccrz__CCOrder__r.Is_BMS_PDF_Received__c,OSM_PDF_Received__c, BMS_InvoiceNumber__c, OSM_SW_IsIntercompanyInvoice__c from ccrz__E_Invoice__c where Id  IN:setInvoiceId  and OSM_SW_IsIntercompanyInvoice__c=false and Invoice_Type__c != 'Credit Memo'ORDER BY CreatedDate DESC Limit 1];
                }
                if(invoiceList3.size() > 0 )
                {
                    for(ccrz__E_Invoice__c objInv : invoiceList3)
                    {
                        invoiceList.add(objInv);
                    }
                }
                    
            }
			*/
            // code for find main invoice of credit memo: End
            
             if(invoiceList!=null && invoiceList.size()>0){
                 for(ccrz__E_Invoice__c invoice:invoiceList){
                 orderidSet.add(invoice.ccrz__CCOrder__c);
                     AccountId = invoice.ccrz__BillTo__c; //Added By Dhiraj
                 }
             }
             Map<Id,ccrz__E_Order__c> orderMap=new Map<Id,ccrz__E_Order__c>([select id,Is_BMS_PDF_Received__c from ccrz__E_Order__c where id in:orderidSet FOR UPDATE]);
         /*}
        else
        {
            invoiceList=[Select id,Name,ccrz__CCOrder__c, ccrz__CCOrder__r.Name, OSM_PDF_Received__c, BMS_InvoiceNumber__c, OSM_SW_IsIntercompanyInvoice__c from ccrz__E_Invoice__c where ccrz__CCOrder__r.Name IN:invoiceNumberSet and OSM_SW_IsIntercompanyInvoice__c=false and Invoice_Type__c = 'Credit Memo'ORDER BY CreatedDate DESC Limit 1];
        }
        */
        if(test.isRunningTest())
        {
            invoiceList=[Select id,Name,ccrz__CCOrder__c, ccrz__CCOrder__r.Name, OSM_PDF_Received__c, BMS_InvoiceNumber__c, OSM_SW_IsIntercompanyInvoice__c from ccrz__E_Invoice__c Limit 1];
             if(invoiceList!=null && invoiceList.size()>0){
                 for(ccrz__E_Invoice__c invoice:invoiceList){
                 orderidSet.add(invoice.ccrz__CCOrder__c);
                 }
             }
            orderMap=new Map<Id,ccrz__E_Order__c>([select id,Is_BMS_PDF_Received__c from ccrz__E_Order__c where id in:orderidSet]);
        }
        try{
           
         if(invoiceList!=null && invoiceList.size()>0){
             for(ccrz__E_Invoice__c invoice:invoiceList){                            
             if(invoiceHeaderList!=null && invoiceHeaderList.size()>0 ){
              for(OSM_FSDPDF_REQ.CInvoice_Header pdfReq:invoiceHeaderList){
                     //Check all input parameters are provided
                     if(pdfReq.BMS_OE_REFERENCE!=null && pdfReq.BRANCH_LOCATION!=null && pdfReq.ORDER_SOURCE_TYPE!=null && pdfReq.BMS_INVOICE_NUMBER!=null && (pdfReq.BMSInvoicePDF!=null && pdfReq.BMSInvoicePDF!='')){
                        pdfContent=String.valueOf(pdfReq.BMSInvoicePDF);
                        System.debug('pdfContent___'+pdfContent);
                         orderSourceType = pdfReq.ORDER_SOURCE_TYPE;
                        mapInvoiceHeader.put(pdfReq.BMS_INVOICE_NUMBER,pdfReq);
                        System.debug('mapInvoiceHeader___'+mapInvoiceHeader);
                        RequiredFieldMissingFlag=false;
            refundBMSNumber = pdfReq.BRANCH_LOCATION+'-'+pdfReq.BMS_INVOICE_NUMBER;//changes regarding story MAR-2074
                        System.debug('refundBMSNumber: '+refundBMSNumber);
                        
                    }else{
                        exceptionflag=true;
                        RequiredFieldMissingFlag=true;                        
                    }
                    }
                    sflag.add(RequiredFieldMissingFlag);
                 }
               if(sflag.contains(true)){
                respJSON=new OSM_FSDPDF_RES.OSMResponse();
                respJSON.StatusCode= '500';
                respJSON.StatusDescription='Failure:RequiredFieldMissing';
                resJSON=new OSM_FSDPDF_RES();
                resJSON.OSMResponse=respJSON;
                if(exceptionflag == true){
                log = new OSM_Integration_Log__c();
                OSM_SW_LoggingContext.integrationLog = log; //Populating integration log record
             //   log.Request__c = jSONRequestBody;
              log.Account__c = AccountId; //Added by Dhiraj
                log.Request__c = jSONRequestBodyWithoutPDFString;
                log.Service_Name__c = label.PDFInvoiceTransferInBound;
                log.Source__c = label.OSM_BMS_Target_ID;
                log.Target__c = label.OSM_Target;
                log.Logged_In_User__c = userinfo.getUserId();
                log.Response__c  = 'Error';
                log.Status__c = 'Failure';
                log.Error_Description__c ='Failure:RequiredFieldMissing';
                log.invoice__c=invoice.id;
                System.debug('log_____'+log);                
                OSM_SW_LoggingContext.saveIntegrationLog(log); //Save the integration log record   
             }
              return resJSON;
             }
                 Attachment attachmentPDF = new Attachment();
                 attachmentPdf.parentId = invoice.id;
                 if(orderSourceType == 'OSM')
                 {
                     attachmentPdf.name = label.FSDInvoice+'.pdf';
                     invoice.OSM_PDF_Received__c = true;
                     orderMap.get(invoice.ccrz__CCOrder__c).Is_BMS_PDF_Received__c=true;
                     
                     orderListUpdate.add(orderMap.get(invoice.ccrz__CCOrder__c));
                 }
                 else // if the orderSourceType is OSMCM
                 {
                     //attachmentPdf.name = label.FSDInvoice+'_CM.pdf';
           attachmentPdf.name = refundBMSNumber+'_CM.pdf';//changes regarding story MAR-2074
                     invoice.BMS_Refund_PDF_Received__c = true;
                 }
                 
                 //attachmentPdf.body = blob.toPDF(pdfContent);
                 // Changes - Juhi - Feb 11 - to decode a Base64 string to pdf sent by MW
                 attachmentPdf.contentType = 'application/pdf';
                   if(Test.isRunningTest()){
                     attachmentPdf.body = blob.toPDF(pdfContent);

                 }else{
                 attachmentPdf.body = EncodingUtil.base64Decode(pdfContent);
                 }   
                 attachmentPDFList.add(attachmentPDF);              
                 //insert attachmentPDF;
                 invListUpdate.add(invoice);
               //  update invoice;
                 
                respJSON=new OSM_FSDPDF_RES.OSMResponse();
                respJSON.StatusCode= '200';
                respJSON.StatusDescription='Success';
                resJSON=new OSM_FSDPDF_RES();
                resJSON.OSMResponse=respJSON;

                if(exceptionflag == false){
                log = new OSM_Integration_Log__c();
                OSM_SW_LoggingContext.integrationLog = log; //Populating integration log record
               // log.Request__c = jSONRequestBody;
               log.Account__c = AccountId; //Added by Dhiraj
               log.Request__c = jSONRequestBodyWithoutPDFString;
                log.Service_Name__c = label.PDFInvoiceTransferInBound;
                log.Source__c = label.OSM_BMS_Target_ID;
                log.Target__c = label.OSM_Target;
                log.Logged_In_User__c = userinfo.getUserId();
                log.Response__c  = 'Success';
                log.Status__c = 'Success';
                log.Error_Description__c ='Success';
                log.invoice__c=invoice.id;
                OSM_SW_LoggingContext.saveIntegrationLog(log); //Save the integration log record   
             }

           }
           insert attachmentPDFList;
           update invListUpdate;
           update orderListUpdate;
        }else{
                exceptionflag=true;
                respJSON=new OSM_FSDPDF_RES.OSMResponse();
                respJSON.StatusCode= '500';
                respJSON.StatusDescription='Failure:No record found';
                resJSON=new OSM_FSDPDF_RES();
                resJSON.OSMResponse=respJSON;

                if(exceptionflag == true){
                log = new OSM_Integration_Log__c();
                OSM_SW_LoggingContext.integrationLog = log; //Populating integration log record
               // log.Request__c = jSONRequestBody;
               log.Account__c = AccountId; //Added by Dhiraj
               log.Request__c = jSONRequestBodyWithoutPDFString;
                log.Service_Name__c = label.PDFInvoiceTransferInBound;
                log.Source__c = label.OSM_BMS_Target_ID;
                log.Target__c = label.OSM_Target;
                log.Logged_In_User__c = userinfo.getUserId();
                log.Response__c  = 'Error';
                log.Status__c = 'Failure';
                log.Error_Description__c ='No record found';
                OSM_SW_LoggingContext.saveIntegrationLog(log); //Save the integration log record 
                }      
         }  
         }catch(Exception e){
             system.debug('Exception - '+e.getMessage()+' Line No:'+e.getLineNumber());
            exceptionflag = true;
                respJSON=new OSM_FSDPDF_RES.OSMResponse();
                respJSON.StatusCode= '500';
                respJSON.StatusDescription='';
                resJSON=new OSM_FSDPDF_RES();
                resJSON.OSMResponse=respJSON;

            if(exceptionflag == true){
                log = new OSM_Integration_Log__c();
                OSM_SW_LoggingContext.integrationLog = log; //Populating integration log record
              //  log.Request__c = jSONRequestBody;
              log.Account__c = AccountId; //Added by Dhiraj
              log.Request__c = jSONRequestBodyWithoutPDFString;
                log.Service_Name__c = label.PDFInvoiceTransferInBound;
                log.Source__c = label.OSM_BMS_Target_ID;
                log.Target__c = label.OSM_Target;
                log.Logged_In_User__c = userinfo.getUserId();
                log.Response__c  = 'Error';
                log.Status__c = 'Failure';
                String msg  = 'Message - '+e.getMessage();
                msg=msg+ 'Stacktrace - ' + e.getStackTraceString();                   
                log.Error_Description__c = msg;
                if(invoiceList!=null && invoiceList.size()>0){
                for(ccrz__E_Invoice__c invoice:invoiceList){ 
                 log.invoice__c=invoice.id;
                }
                }
                 if(!Test.isRunningTest()){
                OSM_SW_LoggingContext.saveIntegrationLog(log);  
                }        
               }
         }                 
        system.debug('log'+log);    
        system.debug('resJSON'+resJSON); 
       return resJSON; 
       }   
           
   }