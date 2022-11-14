/*****************************************************************
Name:  OSM_SW_ccServiceInvoice
Copyright © 2018  Cummins
==================================================================
==================================================================
Purpose:                                                            
This is CC extension to display the invoice for account.Standard CC
API display invoices for a particular user.This is overriden to display
the invoices for particular account to Admins and any other user of account.
==================================================================
==================================================================
History                                                            
-------                                                            
VERSION  AUTHOR                 DATE              DETAIL                                
1.0 -   Sharad Sahu         ------     INITIAL DEVELOPMENT          

******************************************************************/
global with sharing  class OSM_SW_ccServiceInvoice extends ccrz.ccServiceInvoice// <1>
{
    global virtual override Map<String, Object> getFieldsMap(Map<String, Object> inputData) // <2>
    {
        system.debug('*************************** OSM_SW_ccServiceInvoice');
        system.debug(inputData); 
        system.debug('*************************** OSM_SW_ccServiceInvoice');
        inputData = super.getFieldsMap(inputData); // <3>

       String objectFields = (String)inputData.get(ccrz.ccService.OBJECTFIELDS);  // <3>

        objectFields += ',BMS_InvoiceNumber__c,BMS_InvoiceDate__c,ccrz__BillTo__r.name' ;  // <4>
         system.debug('*************************** BMS_InvoiceNumber__c');
        system.debug('*************************** OSM_SW_ccServiceInvoice 2');
        system.debug(inputData);
        system.debug('*************************** OSM_SW_ccServiceInvoice 2');
        //inputData.put(ccrz.ccService.OBJECTFIELDS, objectFields);
        return inputData;  // <5>
    }
}