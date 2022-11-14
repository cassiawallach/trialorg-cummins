trigger OSM_Subscription_DisableDelete_Trigger on ccrz__E_Subscription__c (before delete) {
    if(Trigger.isDelete ){
        if(Trigger.isBefore){
            for(ccrz__E_Subscription__c subscription : Trigger.old){
                 if(subscription.ccrz__Storefront__c!=null && subscription.ccrz__Storefront__c=='SoftwareStore' && !FeatureManagement.checkPermission('OSM_Can_Delete_Records_Permission'))
                 subscription.addError('ERROR : You do not have delete permission for Subscription object');   
                
            }
        }
    }
}