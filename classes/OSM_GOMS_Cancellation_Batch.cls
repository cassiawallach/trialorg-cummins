/************************************************************
Name:  OSM_GOMS_Cancel_Retry_Batch
Copyright © 2020  Cummins
=============================================================
=============================================================
Purpose:                                                            
This batch class runs every hour and process the failure records
of GOMS  cancellation API
=============================================================
=============================================================
History                                                            
-------                                                            
VERSION     AUTHOR              DATE            DETAIL                                
1.0 -   Sangeeta Rani   30/05/2020     INITIAL DEVELOPMENT          
*************************************************************/
global class OSM_GOMS_Cancellation_Batch  implements Database.Batchable<sObject>,Database.AllowsCallouts {
 
    
    global Database.QueryLocator start(Database.BatchableContext BC){
        List<String> distributorCodeList = new List<String>{'02930','02850','03520','02860','02680','02466','04959'};
        string query='select id,Is_GOMS_Integration_Processed__c,Is_GOMS_Intercompany_Invoice__c,GOMS_Invoice_ID__c from ccrz__E_Invoice__c where  ccrz__CCOrder__r.ccrz__OrderStatus__c =\'Cancelled\' and Invoice_Type__c=\'Credit Memo\' and GOMS_Invoice_ID__c=Null and (Is_GOMS_Intercompany_Invoice__c=true or ((ccrz__CCOrder__r.ccrz__Account__r.type=\'Distributor Account\' or ccrz__CCOrder__r.ccrz__Account__r.type=\'Distributor Branch Account\') and ccrz__CCOrder__r.ccrz__Account__r.BillingCountry!=\'United States\'))and ccrz__CCOrder__r.ccrz__Account__r.CSS_DistributorCode__c NOT IN :distributorCodeList and Is_GOMS_Integration_Processed__c=false';
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<ccrz__E_Invoice__c> scope){
        
         Set<ID> invoicesetid = new Set<ID>();
        
        for(ccrz__E_Invoice__c invoice :scope)
        {
            invoicesetid.add(invoice.ID);
        }
        GOMS_Integration_BaseClass.callIntegrationMethod(invoicesetid,true);
        
    }
     global void finish(Database.BatchableContext BC)
    {
        
        
    }
}