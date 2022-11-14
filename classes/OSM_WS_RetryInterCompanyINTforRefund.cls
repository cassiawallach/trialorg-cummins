/************************************************************
Name:  OSM_WS_RetryInterCompanyINTforRefund
Copyright © 2018  Cummins
=============================================================
=============================================================
Purpose:                                                            
This is batch class for Refund Intercompany INT call Integration 
=============================================================
=============================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE              DETAIL                                
1.0 -   Sharad         21/01/2018     INITIAL DEVELOPMENT          


*************************************************************/

global class OSM_WS_RetryInterCompanyINTforRefund implements Database.Batchable<sObject>,Database.AllowsCallouts{
    
    global Database.QueryLocator start(Database.BatchableContext BC){
        String strStatus = 'Cancelled';
        String strINTStatus = 'Success';
        String query = 'Select id,ccrz__CCOrder__c,ccrz__InvoiceAppliedTo__c from ccrz__E_TransactionPayment__c where ccrz__CCOrder__r.ccrz__OrderStatus__c  =: strStatus AND ccrz__CCOrder__r.Original_Sales_Order__r.OSM_SW_Is_FSD_refund_Call_Done__c = true AND Bolt_JE_Reversal_Call_Status__c  =: strINTStatus AND Bolt_Credit_Memo_Call_Status__c =: strINTStatus AND ccrz__InvoiceAppliedTo__r.OSM_SW_IsIntercompanyInvoice__c = True AND ccrz__InvoiceAppliedTo__r.IntercompanyCalled__c = true AND ccrz__InvoiceAppliedTo__r.OSM_SW_Is_Refund_Intercompany_Call_Done__c = false and ccrz__InvoiceAppliedTo__r.OSM_Child_Account__r.BillingCountry=\'United States\'';
        
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext BC, List<ccrz__E_TransactionPayment__c> scope){   
        Set<Id> setInvoiceId = new Set<Id>();   
        for(ccrz__E_TransactionPayment__c transecObj :scope){
            setInvoiceId.add(transecObj.ccrz__InvoiceAppliedTo__c);
        }
        
        if(setInvoiceId.size() > 0 )
            OSM_Intercompany_FutureLayerHandler.callIntercompanyInvoiceAPI(setInvoiceId,true,false);
       
    }

    global void finish(Database.BatchableContext BC){  
    }
    
}