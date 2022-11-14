trigger OSM_Invoice_DisableDelete_Trigger on ccrz__E_Invoice__c (before delete){
    if( Trigger.isDelete ){
        if(Trigger.isBefore){
            for(ccrz__E_Invoice__c invoice : Trigger.old){
                if(invoice.ccrz__Storefront__c!=null && invoice.ccrz__Storefront__c=='SoftwareStore' && !FeatureManagement.checkPermission('OSM_Can_Delete_Records_Permission'))
                invoice.addError('ERROR : You do not have delete permission for Invoice object');                
            }
        }
    }
}