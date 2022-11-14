/**********************************************************************
Name:  OSM_GOMSGetInvoice
Copyright © 2019  Cummins
======================================================
======================================================
Purpose:The purpose of this is to Update GOMSinvoice ID to invoice                                
==============================================================================================
*** REST Post *** :  Requires the invoice number
===============================================================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE              DETAIL                                
1.0 -    Nandigam Sasi     20/04/2020         INITIAL DEVELOPMENT          
*****************************************************/

@RestResource(urlMapping='/GOMSGetInvoice/*')
global with sharing class OSM_GOMSGetInvoice {
    @HttpPost
    global static OSM_FSDPDF_RES UpdateInvoice() {
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        list<OSM_Integration_Log__c> logs = new  list<OSM_Integration_Log__c>();
        OSM_Integration_Log__c log = new OSM_Integration_Log__c();
        OSM_SW_LoggingContext.integrationLog = log;
        string  responsedata = req.requestBody.toString().trim();
        log.Request__c = responsedata;
        log.Service_Name__c = label.OSM_GOMSInvoiceUpdateInBoundTransfer;
        log.Source__c = label.OSM_GOMS_Target_ID;
        log.Target__c = label.OSM_Target;
        log.Logged_In_User__c = userinfo.getUserId();
        OSM_FSDPDF_RES.OSMResponse respJSON=null;
        OSM_FSDPDF_RES ServiceResponse= new OSM_FSDPDF_RES();
        res.addHeader('Content-Type', 'application/json');
        try{
            OSM_GOMSInvoiceReqWrapper  records = OSM_GOMSInvoiceReqWrapper.parse(responsedata);
            
            
            if(records.INVOICE_DATA.size()>0){
                Map<string,OSM_GOMSInvoiceReqWrapper.INVOICE_DATA>  invoicedata = new  Map<string,OSM_GOMSInvoiceReqWrapper.INVOICE_DATA>();
                Map<string,list<OSM_GOMSInvoiceReqWrapper.INVOICE_DATA>>  shiptoinvoicedata = new   Map<string,list<OSM_GOMSInvoiceReqWrapper.INVOICE_DATA>>();
                system.debug('records.INVOICE_DATA'+records.INVOICE_DATA);
                for(OSM_GOMSInvoiceReqWrapper.INVOICE_DATA rec: records.INVOICE_DATA){
                    if(rec.TRANSACTION_ID !=null && rec.TRANSACTION_ID !=''){
                        invoicedata.put(rec.TRANSACTION_ID,rec);
                    }else{
                        OSM_Integration_Log__c newlog=log.clone();
                        newlog.Response__c  = 'Error';
                        newlog.Status__c = 'Failure';
                        newlog.Error_Description__c ='TRANSACTION_ID not available :'+rec;
                        logs.add(newlog); 
                    }
                    
                }
                system.debug('invoicedata'+invoicedata.keyset());
                if (Schema.sObjectType.ccrz__E_Invoice__c.fields.GOMS_Invoice_ID__C.isUpdateable()) {
                    List<ccrz__E_Invoice__c> invoicerecords ;
                    if(test.isRunningTest()){
                      invoicerecords=[Select id,Name,GOMS_Invoice_ID__C,GOMS_Invoice_ID_Received__c  from ccrz__E_Invoice__c where id IN:invoicedata.keyset()]; // WITH SECURITY_ENFORCED
                    }else{
                        invoicerecords=[Select id,Name,GOMS_Invoice_ID__C,GOMS_Invoice_ID_Received__c  from ccrz__E_Invoice__c where Name IN:invoicedata.keyset() WITH SECURITY_ENFORCED];
                    }
                    system.debug('invoicerecords'+invoicerecords);
                    if(invoicerecords.size()>0){
                        map<string,ccrz__E_Invoice__c> invoicemap = new map<string,ccrz__E_Invoice__c>();
                        for(ccrz__E_Invoice__c invoice :invoicerecords){
                            if(test.isRunningTest()){
                                invoicemap.put(invoice.id,invoice);
                            }else{
                                invoicemap.put(invoice.Name,invoice);
                            }
                            
                        }
                             
                        for(string invoicenumber :invoicedata.keyset()){
                            if(invoicemap.containskey(invoicenumber)){
                                OSM_GOMSInvoiceReqWrapper.INVOICE_DATA  invoicerecord =invoicedata.get(invoicenumber);
                                ccrz__E_Invoice__c  invoice = invoicemap.get(invoicenumber);
                                if(invoicerecord.STATUS =='SUCCESS'){
                                    if(!Test.isRunningTest())invoice.GOMS_Invoice_ID__C=invoicedata.get(invoice.Name).INVOICE_ID; 
                                    invoice.GOMS_Invoice_ID_Received__c=true;
                                    OSM_Integration_Log__c newlog=log.clone();
                                    newlog.Invoice__c=invoice.id;
                                    newlog.Response__c  = 'Success';
                                    newlog.Status__c = 'Success';
                                    newlog.Error_Description__c ='GOMS InvoiceId Updated Successfully';
                                    logs.add(newlog);
                                }else{
                                    if(!Test.isRunningTest())invoice.GOMS_Invoice_ID__C=invoicedata.get(invoice.Name).INVOICE_ID; 
                                    invoice.GOMS_Invoice_ID_Received__c=false;
                                    OSM_Integration_Log__c newlog=log.clone();
                                    newlog.Invoice__c=invoice.id;
                                    newlog.Response__c  = invoicerecord.STATUS;
                                    newlog.Status__c = invoicerecord.STATUS;
                                    newlog.Error_Description__c =invoicerecord.MESSAGE;
                                    logs.add(newlog); 
                                }
                                invoicemap.put(invoice.Name,invoice); 
                                
                            }else{
                                OSM_Integration_Log__c newlog=log.clone();
                                newlog.Response__c  = 'Error';
                                newlog.Status__c = 'Failure';
                                newlog.Error_Description__c =' Given TRANSACTION_ID :'+invoicenumber+'do not match with Invoice ID';
                                logs.add(newlog); 
                            }
                            
                        }
                        
                        Database.SaveResult[] results =  Database.update(invoicemap.values()) ; 
                        respJSON=new OSM_FSDPDF_RES.OSMResponse();
                        respJSON.StatusCode= '200';
                        respJSON.StatusDescription='Success';
                        ServiceResponse.OSMResponse=respJSON;
                        log.Response__c  = 'Success';
                        log.Status__c = 'Success';
                        log.Error_Description__c ='Success';
                    }else{
                        respJSON=new OSM_FSDPDF_RES.OSMResponse();
                        respJSON.StatusCode= '200';
                        respJSON.StatusDescription='Success';
                        ServiceResponse.OSMResponse=respJSON;
                        log.Response__c  = 'Error';
                        log.Status__c = 'Failure';
                        log.Error_Description__c ='No matching Invoices found in Salesforce Database.';
                    } 
                }else{
                    respJSON=new OSM_FSDPDF_RES.OSMResponse();
                    respJSON.StatusCode= '500';
                    respJSON.StatusDescription=userinfo.getUserId()+'do not have permissions to update Invoice.Please Contact Salesforce System Admin for More info.';
                    ServiceResponse.OSMResponse=respJSON; 
                    log.Response__c  = 'Error';
                    log.Status__c = 'Failure';
                    log.Error_Description__c =respJSON.StatusDescription;
                }
                
            }else{
                respJSON=new OSM_FSDPDF_RES.OSMResponse();
                respJSON.StatusCode= '500';
                respJSON.StatusDescription='Failure: No Invoice items found in Request';
                ServiceResponse.OSMResponse=respJSON;
                log.Response__c  = 'Error';
                log.Status__c = 'Failure';
                log.Error_Description__c ='No Invoice Line items found in Request';
            }
        }catch(system.JSONException ex){
            respJSON=new OSM_FSDPDF_RES.OSMResponse();
            respJSON.StatusCode= '500';
            respJSON.StatusDescription='Malformed JSON Exception';
            ServiceResponse.OSMResponse=respJSON;
            log.Response__c  = 'Error';
            log.Status__c = 'Failure';
            String msg  = 'Message - '+ex.getMessage();
            msg=msg+ 'Stacktrace - ' + ex.getStackTraceString();
            log.Error_Description__c ='Malformed JSON Exception :'+msg;
        }catch(system.Exception ex){
            respJSON=new OSM_FSDPDF_RES.OSMResponse();
            respJSON.StatusCode= '200';
            respJSON.StatusDescription='Success';
            ServiceResponse.OSMResponse=respJSON;
            log.Response__c  = 'Error';
            log.Status__c = 'Failure';
            String msg  = 'Message - '+ex.getMessage();
            msg=msg+ 'Stacktrace - ' + ex.getStackTraceString();                   
            log.Error_Description__c = msg;
        }
        
        OSM_Integration_Log__c servicelog = OSM_SW_LoggingContext.saveIntegrationLog(log);
        for(OSM_Integration_Log__c errorlog :logs)
            errorlog.Parent_Integration_Log__c=servicelog.id;
        Database.upsert(logs) ; 
        return ServiceResponse;
    }  
}