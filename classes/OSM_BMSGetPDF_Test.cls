//Test Class for the class OSM_BMSGetPDF
//Reeploying this on 5/26 due to deletion from UAT by Guidanz team
/******
Name:  OSM_Intercompany_Test
Copyright © 2018  Cummins
=============================================================
=============================================================
Purpose:                                                                                             
=============================================================
=============================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE              DETAIL                                
1.0 -   Neha Sharma       25/12/2018     INITIAL DEVELOPMENT 
2.0 -   Vignesh           22/06/2021     INC2270570 - Fix
3.0 -   Sangeeta          28/6/2021      updated
4.0 -   Sharad            24/9/2021      updated
4.0 -   Sharad            18/10/2021      updated
// uPDATED BY SHARAD
// uPDATED BY SHARAD
*******/

@isTest
public class OSM_BMSGetPDF_Test{
     // Create CC Invoices
   public static testMethod void createTestData(){
        ccrz__E_Order__c  objCCOrder = new ccrz__E_Order__c();               
        //objCCOrder.ccrz__Account__c = acc.ID;
        objCCOrder.OSM_SW_Should_mail_Send__c = true;
        objCCOrder.OSM_SW_Is_InterCompany_Order__c = false;
        objCCOrder.ccrz__OrderStatus__c='Order Submitted'; 
        objCCOrder.Send_SSOEM_Customer_Email__c = true; 
         
        
        insert objCCOrder; 
                
    List<ccrz__E_Invoice__c> listInv = new List<ccrz__E_Invoice__c>();
        ccrz__E_Invoice__c inv = new ccrz__E_Invoice__c ();
        inv.BMS_InvoiceNumber__c = 987454;
        inv.ccrz__CurrencyCode__c = 'USD';
        inv.Recurring_Invoice__c=false;
        inv.OSM_SW_Is_Bolt_PO__c=false;
        inv.OSM_SW_IsIntercompanyInvoice__c=false;
        inv.OSM_PDF_Received__c=false;
        inv.ccrz__CCOrder__c= objCCOrder.id;
        listInv.add(inv);
        insert listInv;
                 
Test.StartTest();
    string JSONReq = '{'+
'  \"Header\" : {'+
'    \"Status\" : \"SUCCESS\",'+
'    \"Sender\" : {'+
'      \"ServiceName\" : \"PDFInvoiceTransferInBound\",'+
'      \"SenderID\" : \"BMS\"'+
'    },'+
'    \"Target\" : {'+
'      \"TargetID\" : \"Mrktplc\"'+
'    }'+
'  },'+
'  \"DataArea\" : {'+
'    \"DistributorCode\" : \"03520\",'+
'    \"CustomerCode\" : \"112233\",'+
'    \"CInvoice_Header\" : [ {'+
'      \"BMS_OE_REFERENCE\" : 123456,'+
'      \"BRANCH_LOCATION\" : \"E1\",'+
'      \"ORDER_SOURCE_TYPE\" : \"OSM\",'+
'      \"BMS_INVOICE_NUMBER\" : 987454,'+
'      \"OSM_INVOICE_NUMBER\" : \"'+listInv[0].BMS_InvoiceNumber__c+'",'+
'      \"BMSInvoicePDF\" : \"weblogic.jdbc.wrapper.Blob_oracle_sql_BLOB@119e\"'+
'    } ]'+
'  }'+
'}';


    system.debug(JSONReq);


    RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
       boolean sflag = true;
        //Pass apexrest parameters
        req.addHeader('Content-Type', 'application/json');
        req.httpMethod = 'POST';//HTTP Request Type
        req.requestUri ='https://cumminscss--eidmdev.cs61.my.salesforce.com/services/apexrest/BMSGetPDF/';
       req.requestBody = Blob.valueof(JSONReq);
     //   req.requestBody=EncodingUtil.base64Decode(JSONReq);
        system.debug('#####'+req.requestBody);
        //req.params.put('ACTION','SendDataReceiptAcknowledgement');
        RestContext.response= res;
        RestContext.request = req;
        system.debug('!!!!!!'+RestContext.response);
        system.debug('%%%%%%'+RestContext.request);
                //List<Attachment> attachments=[select id, name from Attachment where parent.id=:listInv[0].id];     
        Attachment att = new Attachment();
        att.name = 'Invoice.PDF';
        att.parentId = listInv[0].id;
        att.Body = req.requestBody;
        insert att;
        OSM_BMSGetPDF.Post(); //Invoke the service
        OSM_BMSGetPDFRetryInt.pdfRecievedMethod(listInv);

    Test.StopTest();
    }
    
    public static testMethod void createTestData1(){
    
     ccrz__E_Order__c  objCCOrder = new ccrz__E_Order__c();               
        //objCCOrder.ccrz__Account__c = acc.ID;
        objCCOrder.OSM_SW_Should_mail_Send__c = true;
        objCCOrder.OSM_SW_Is_InterCompany_Order__c = false;
        objCCOrder.ccrz__OrderStatus__c='Order Submitted'; 
        objCCOrder.Send_SSOEM_Customer_Email__c = true; 
        
        
        insert objCCOrder; 
        
    List<ccrz__E_Invoice__c> listInv = new List<ccrz__E_Invoice__c>();
        ccrz__E_Invoice__c inv = new ccrz__E_Invoice__c ();
        inv.BMS_InvoiceNumber__c = 987654;
        inv.ccrz__CurrencyCode__c = 'USD';
        inv.Recurring_Invoice__c=false;
        inv.OSM_SW_Is_Bolt_PO__c=false;
        inv.OSM_SW_IsIntercompanyInvoice__c=false;
        inv.OSM_PDF_Received__c=false;
        inv.ccrz__CCOrder__c= objCCOrder.id;
        listInv.add(inv);
        
        insert listInv;
            
         
Test.StartTest();
    string JSONReq = '{'+
'  \"Header\" : {'+
'    \"Status\" : \"SUCCESS\",'+
'    \"Sender\" : {'+
'      \"ServiceName\" : \"PDFInvoiceTransferInBound\",'+
'      \"SenderID\" : \"BMS\"'+
'    },'+
'    \"Target\" : {'+
'      \"TargetID\" : \"Mrktplc\"'+
'    }'+
'  },'+
'  \"DataArea\" : {'+
'    \"DistributorCode\" : \"03520\",'+
'    \"CustomerCode\" : \"112233\",'+
'    \"CInvoice_Header\" : [ {'+
'      \"BMS_OE_REFERENCE\" : 123456,'+
'      \"BRANCH_LOCATION\" : \"E1\",'+
'      \"ORDER_SOURCE_TYPE\" : \"OSMCM\",'+
'      \"BMS_INVOICE_NUMBER\" : null,'+
'      \"BMSInvoicePDF\" : \"weblogic.jdbc.wrapper.Blob_oracle_sql_BLOB@119e\"'+
'    } ]'+
'  }'+
'}';


    system.debug(JSONReq);


    RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
       boolean sflag = true;
        //Pass apexrest parameters
        req.addHeader('Content-Type', 'application/json');
        req.httpMethod = 'POST';//HTTP Request Type
        req.requestUri ='https://cumminscss--eidmdev.cs61.my.salesforce.com/services/apexrest/BMSGetPDF/';
        req.requestBody = Blob.valueof(JSONReq);
       // req.requestBody=EncodingUtil.base64Decode(JSONReq);
        system.debug('#####'+req.requestBody);
        //req.params.put('ACTION','SendDataReceiptAcknowledgement');
        RestContext.response= res;
        RestContext.request = req;
        system.debug('!!!!!!'+RestContext.response);
        system.debug('%%%%%%'+RestContext.request);
                
        //List<Attachment> attachments=[select id, name from Attachment where parent.id=:listInv[0].id];     
        Attachment att = new Attachment();
        att.name = 'Invoice.PDF';
        att.parentId = listInv[0].id;
        att.Body = req.requestBody;
        insert att;
        OSM_BMSGetPDF.Post(); //Invoke the service
        OSM_BMSGetPDFRetryInt.pdfRecievedMethod(listInv);
        OSM_FSDPDF_REQ req1=new OSM_FSDPDF_REQ();
        OSM_FSDPDF_RES res1=new OSM_FSDPDF_RES();
    Test.StopTest();
    }
    public static testMethod void createTestData2(){
        
    List<ccrz__E_Invoice__c> listInv = new List<ccrz__E_Invoice__c>();
        ccrz__E_Invoice__c inv = new ccrz__E_Invoice__c ();
        inv.BMS_InvoiceNumber__c = 987654;
        inv.ccrz__CurrencyCode__c = 'USD';
        inv.Recurring_Invoice__c=false;
        inv.OSM_SW_Is_Bolt_PO__c=false;
        inv.OSM_SW_IsIntercompanyInvoice__c=false;
        inv.OSM_PDF_Received__c=false;

        listInv.add(inv);
        insert listInv;
            
         
Test.StartTest();
    string JSONReq = '{'+
'  \"Header\" : {'+
'    \"Status\" : \"SUCCESS\",'+
'    \"Sender\" : {'+
'      \"ServiceName\" : \"PDFInvoiceTransferInBound\",'+
'      \"SenderID\" : \"BMS\"'+
'    },'+
'    \"Target\" : {'+
'      \"TargetID\" : \"Mrktplc\"'+
'    }'+
'  },'+
'  \"DataArea\" : {'+
'    \"DistributorCode\" : \"03520\",'+
'    \"CustomerCode\" : \"112233\",'+
'    \"CInvoice_Header\" : [ {'+
'      \"BMS_OE_REFERENCE\" : 123456,'+
'      \"BRANCH_LOCATION\" : \"E1\",'+
'      \"ORDER_SOURCE_TYPE\" : \"OSM\",'+
'      \"BMS_INVOICE_NUMBER\" : 987654,'+
'      \"BMSInvoicePDF\" : \"\"'+
'    } ]'+
'  }'+
'}';


    system.debug(JSONReq);


    RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
       boolean sflag = true;
        //Pass apexrest parameters
        req.addHeader('Content-Type', 'application/json');
        req.httpMethod = 'POST';//HTTP Request Type
        req.requestUri ='https://cumminscss--eidmdev.cs61.my.salesforce.com/services/apexrest/BMSGetPDF/';
        req.requestBody = Blob.valueof(JSONReq);
       
     //   req.requestBody=EncodingUtil.base64Decode(JSONReq);
        system.debug('#####'+req.requestBody);
        //req.params.put('ACTION','SendDataReceiptAcknowledgement');
        RestContext.response= res;
        RestContext.request = req;
        system.debug('!!!!!!'+RestContext.response);
        system.debug('%%%%%%'+RestContext.request);
         OSM_BMSGetPDF.Post(); //Invoke the service
        OSM_BMSGetPDFRetryInt.pdfRecievedMethod(listInv);
        OSM_FSDPDF_REQ req1=new OSM_FSDPDF_REQ();
        OSM_FSDPDF_RES res1=new OSM_FSDPDF_RES();
        String json='{"Header": {"Status": "SUCCESS","Sender": {"ServiceName": "PDFInvoiceTransferInBound","SenderID": "BMS"},"Target": {"TargetID": "Mrktplc"}},"DataArea": {"DistributorCode": "020400","CustomerCode": "C1000002045","CInvoice_Header": [{"BMS_OE_REFERENCE": 123,"BRANCH_LOCATION": "Test","ORDER_SOURCE_TYPE": "Test","BMS_INVOICE_NUMBER": 123,"BMSInvoicePDF": "test","Attribute01": "123","Attribute02": "","Attribute03": ""}],"Attribute01": "","Attribute02": "","Attribute03": ""}}';
        OSM_FSDPDF_REQ.parse(json);
        String resjson='{"OSMResponse":{"StatusCode":"200","StatusDescription":"Success"}}';
        OSM_FSDPDF_RES.parse(resjson);
        //List<Attachment> attachments=[select id, name from Attachment where parent.id=:listInv[0].id];     
       /* Attachment att = new Attachment();
        att.name = 'Invoice.PDF';
        //att.parentId = listInv[0].id;
        att.Body = req.requestBody;
        insert att; */
        
    Test.StopTest();
    }
    
}