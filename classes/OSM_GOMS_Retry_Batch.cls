/************************************************************
Name:  OSM_GOMS_Retry_Batch
Copyright © 2020  Cummins
=============================================================
=============================================================
Purpose:                                                            
This batch class runs every hour and process the failure records
of GOMS API
=============================================================
=============================================================
History                                                            
-------                                                            
VERSION      AUTHOR             DATE            DETAIL                                
1.0 -   Saikomal Kattmudi    29/04/2020     INITIAL DEVELOPMENT          
*************************************************************/
global class OSM_GOMS_Retry_Batch  implements Database.Batchable<sObject>,Database.AllowsCallouts {
 
    
    global Database.QueryLocator start(Database.BatchableContext BC){
        List<String> distributorCodeList = new List<String>{'02930','02850','03520','02860','02680','02466','04959'};

        string query='select id,Is_GOMS_Integration_Processed__c,Is_GOMS_Intercompany_Invoice__c,GOMS_Invoice_ID__c from ccrz__E_Invoice__c where  (ccrz__CCOrder__r.ccrz__OrderStatus__c=\'Order Submitted\' or IsRecurringIntercompanyInvoice__c=true) and Is_GOMS_Integration_Processed__c=false and (Is_GOMS_Intercompany_Invoice__c=true or ((ccrz__CCOrder__r.ccrz__Account__r.type=\'Distributor Account\' or ccrz__CCOrder__r.ccrz__Account__r.type=\'Distributor Branch Account\') and (ccrz__CCOrder__r.ccrz__Account__r.BillingCountry!=\'United States\' and ccrz__CCOrder__r.ccrz__Account__r.CSS_DistributorCode__c NOT IN :distributorCodeList)))';                
        
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<ccrz__E_Invoice__c> scope){
        
         Set<ID> invoicesetid = new Set<ID>();
        
        for(ccrz__E_Invoice__c invoice :scope)
        {
            invoicesetid.add(invoice.ID);
        }
        GOMS_Integration_BaseClass.callIntegrationMethod(invoicesetid,false);
        
    }
     global void finish(Database.BatchableContext BC)
    {
        System.debug('OSM_GOMS_Retry_Batch completed');
        
    }
}