trigger OSM_OrderItem_DisableDelete_Trigger on ccrz__E_OrderItem__c (before delete) 
{
    if( Trigger.isDelete )
    {
        if(Trigger.isBefore)
        {
            for(ccrz__E_OrderItem__c orderItem : Trigger.old){
                if(orderItem.ccrz__StoreId__c!=null && orderItem.ccrz__StoreId__c=='SoftwareStore' && !FeatureManagement.checkPermission('OSM_Can_Delete_Records_Permission'))
                 orderItem.addError('ERROR : You do not have delete permission for Order Item object');                
            }
        }
    }
}