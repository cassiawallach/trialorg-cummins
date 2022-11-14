/************************************************************
Name:  OSM_WS_RetryInterCompanyDistInvoiceInt
Copyright © 2018  Cummins
=============================================================
=============================================================
Purpose:                                                            
This is batch class for IntercompanyInvoice Integration for Distributor..
=============================================================
=============================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE              DETAIL                                
1.0 -   Sangeeta Rani   24/12/2019     INITIAL DEVELOPMENT          
2.0 -   Vignesh         29/09/2021     MAR-2091 Fix   

*************************************************************/

global class OSM_WS_RetryInterCompanyDistInvoiceInt implements Database.Batchable<sObject>,Database.AllowsCallouts{
    
    
    
    global Database.QueryLocator start(Database.BatchableContext BC){
        string creditMemo ='Credit Memo'; // Condition Added for MP-328 by Singaiah - 21-10-2021
        String query = 'Select id,ccrz__CCOrder__r.ccrz__Account__r.type from ccrz__E_Invoice__c where OSM_SW_IsBoltARInvoiceDone__c  = true AND OSM_SW_isBoltJournalEntryDone__c  = true AND Invoice_Type__c !=:creditMemo AND IntercompanyCalled__c = false AND OSM_SW_IsIntercompanyInvoice__c  = false AND BMS_InvoiceNumber__c = null';
        
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext BC, List<ccrz__E_Invoice__c> scope){   
        Set<Id> setInvoiceId = new Set<Id>();   
        for(ccrz__E_Invoice__c inv :scope){
            if(inv.ccrz__CCOrder__r.ccrz__Account__r.type=='Distributor Account' || inv.ccrz__CCOrder__r.ccrz__Account__r.type=='Distributor Branch Account')
            setInvoiceId.add(inv.Id);
        }
        
        if(setInvoiceId.size() > 0 )
            OSM_Intercompany_FutureLayerHandler.callIntercompanyInvoiceAPI(setInvoiceId,false,true);
        
    
    }

    global void finish(Database.BatchableContext BC){  
    }
    
}