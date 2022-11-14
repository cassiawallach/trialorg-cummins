trigger OSM_Order_DisableDelete_Trigger on ccrz__E_Order__c (before delete) {
    if( Trigger.isDelete ){
        if(Trigger.isBefore){
            for(ccrz__E_Order__c order : Trigger.old){ 
                if(order.ccrz__Storefront__c!=null && order.ccrz__Storefront__c=='SoftwareStore' && !FeatureManagement.checkPermission('OSM_Can_Delete_Records_Permission'))
                order.addError('ERROR : You do not have delete permission for Order object');                
            }
        }
    }
}