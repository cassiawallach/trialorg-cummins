/************************************************************
Name:  OSM_IntercompanyOfRecurringBatch
Copyright © 2018  Cummins
=============================================================
=============================================================
Purpose:                                                            
This batch is written to run intercompany invoice logic run for recurring
=============================================================
=============================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE              DETAIL                                
1.0 -   Sangeeta           16/07/2020    INITIAL DEVELOPMENT          


*************************************************************/

global class OSM_IntercompanyOfRecurringBatch implements Database.Batchable<sObject>,Database.AllowsCallouts{
    
    String query;
   
   
    global Database.QueryLocator start(Database.BatchableContext BC){
        
        query='select id,Name from ccrz__E_Invoice__c where Recurring_Intercompany_Generated__c=false and Recurring_Invoice__c=true and ccrz__BillTo__r.BillingCountry!=\'United States\'' ;
        return Database.getQueryLocator(query);
    }
 
    global void execute(Database.BatchableContext BC, List<ccrz__E_Invoice__c> scope){               
       Set<Id> InvoiceIdSet=new Set<Id>();
      
       for(ccrz__E_Invoice__c invoice :scope)
       {
           InvoiceIdSet.add(invoice.id);
          
       }                                                                          
       OSM_SW_IntercompanyInvoiceOfRecurring.createIntercompnayOrderAndInvoice(InvoiceIdSet);
                                                                                             
              
    }

    global void finish(Database.BatchableContext BC){
    
    }
}