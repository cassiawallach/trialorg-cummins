global class OSM_BOLT_AR_CreditMemo_Failure_Batch implements Database.Batchable<sObject>, Database.AllowsCallouts, Database.Stateful{
    global List<AR_JE_Failure__c> list_ARJEUdate = new List<AR_JE_Failure__c>();
    global Database.QueryLocator start(Database.BatchableContext BC){
        string query = 'SELECT Id, Is_Processed__c, Invoice__c, Order__c, Process__c FROM AR_JE_Failure__c WHERE Is_Processed__c = false';
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext BC, List<AR_JE_Failure__c> scope){  
        List<ccrz__E_Order__c> list_OrdrUpdate = new List<ccrz__E_Order__c>();
        List<ccrz__E_Invoice__c> list_InvUpdate = new List<ccrz__E_Invoice__c>();
        for(AR_JE_Failure__c arje : scope){
            ccrz__E_Order__c toupdateOrder = new ccrz__E_Order__c(Id = arje.Order__c);
            ccrz__E_Invoice__c newInvoice = new ccrz__E_Invoice__c(Id = arje.Invoice__c);
            if(arje.Process__c == 'AR Invoice'){
                toupdateOrder.OSM_SW_IsBoltARInvoiceDone__c = true;
                newInvoice.OSM_SW_IsBoltARInvoiceDone__c = true;
            }
            else {
                if(arje.Process__c == 'Credit Memo'){
                    toupdateOrder.IsBoltCreditMemoDone__c = true;
                    newInvoice.IsBoltCreditMemoDone__c = true;
                }
            }
            
            arje.Is_Processed__c = true;
            list_OrdrUpdate.add(toupdateOrder);
            list_InvUpdate.add(newInvoice);
            list_ARJEUdate.add(arje);
        }
        
        if(list_OrdrUpdate.size() > 0){
            update list_OrdrUpdate;
        }
        if(list_InvUpdate.size() > 0){
            update list_InvUpdate;
        }
    }

    global void finish(Database.BatchableContext BC){
        if(list_ARJEUdate.size() > 0){
            update list_ARJEUdate;
        }
    }
}