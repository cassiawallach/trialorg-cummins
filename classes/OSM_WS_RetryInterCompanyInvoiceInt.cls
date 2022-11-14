/************************************************************
Name:  OSM_WS_RetryInterCompanyInvoiceInt
Copyright © 2018  Cummins
=============================================================
=============================================================
Purpose:                                                            
This is batch class for IntercompanyInvoice Integration 
=============================================================
=============================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE              DETAIL                                
1.0 -   Sharad         26/12/2018     INITIAL DEVELOPMENT          


*************************************************************/

global class OSM_WS_RetryInterCompanyInvoiceInt implements Database.Batchable<sObject>,Database.AllowsCallouts{
    
    
    
    global Database.QueryLocator start(Database.BatchableContext BC){
        
        String query = 'Select id from ccrz__E_Invoice__c where OSM_SW_IsIntercompanyInvoice__c  = true AND  OSM_SW_IsBoltARInvoiceDone__c  = true AND OSM_SW_isBoltJournalEntryDone__c  = true AND IntercompanyCalled__c = false AND Invoice_Type__c != \'Credit Memo\' AND BMS_InvoiceNumber__c != null and OSM_Child_Account__r.BillingCountry=\'United States\'' ;
        
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext BC, List<ccrz__E_Invoice__c> scope){   
        Set<Id> setInvoiceId = new Set<Id>();   
        for(ccrz__E_Invoice__c inv :scope){
            setInvoiceId.add(inv.Id);
        }
        
        if(setInvoiceId.size() > 0 )
            OSM_Intercompany_FutureLayerHandler.callIntercompanyInvoiceAPI(setInvoiceId,false,false);
        
    
    }

    global void finish(Database.BatchableContext BC){  
    }
    
}