trigger OSM_ContactAddress_DisableDelete_Trigger on ccrz__E_ContactAddr__c (before delete) 
{
    if( Trigger.isDelete )
    {
        if(Trigger.isBefore)
        {
            for(ccrz__E_ContactAddr__c contactAddr : Trigger.old)
            {
                contactAddr.addError('ERROR : You do not have delete permission');                
            }
        }
    }
}