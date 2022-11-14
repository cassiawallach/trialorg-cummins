trigger OSM_InvoiceItem_DisableDelete_Trigger on ccrz__E_InvoiceItem__c (before delete) {
    if( Trigger.isDelete ){
        if(Trigger.isBefore){
            Map<Id,ccrz__E_Invoice__c> invoices = new Map<Id,ccrz__E_Invoice__c>([SELECT Id FROM ccrz__E_Invoice__c  where ccrz__Storefront__c='SoftwareStore' AND Id IN (SELECT ccrz__Invoice__c FROM ccrz__E_InvoiceItem__c WHERE Id IN :trigger.old)]);
            for(ccrz__E_InvoiceItem__c invoiceItem : Trigger.old){
                if(invoices.containsKey(invoiceItem.ccrz__Invoice__c) && !FeatureManagement.checkPermission('OSM_Can_Delete_Records_Permission'))
                 invoiceItem.addError('ERROR : You do not have delete permission for Invoice Item object');                
            }
        }
    }
}