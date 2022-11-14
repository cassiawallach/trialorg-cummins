trigger OSM_ContactAddress_DisableBoltAddressDeletionTrigger on ccrz__E_ContactAddr__c (before delete) 
{
    if( Trigger.isDelete )
    {  
        if(Trigger.isBefore)
        {
            for(ccrz__E_ContactAddr__c contactAddress : Trigger.old)
            {
                if(contactAddress.Bolt_Site__c || contactAddress.Bolt_Active__c)
                {
                    contactAddress.addError('ERROR : You are not allowed to delete Bolt Address records');   
                }       
            }
        }
    }
}