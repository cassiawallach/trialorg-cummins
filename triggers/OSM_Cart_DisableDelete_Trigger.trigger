trigger OSM_Cart_DisableDelete_Trigger on ccrz__E_Cart__c (before delete) 
{
    if( Trigger.isDelete )
    {
        if(Trigger.isBefore)
        {
            for(ccrz__E_Cart__c cart : Trigger.old)
            {
                cart.addError('ERROR : You do not have delete permission');                
            }
        }
    }
}