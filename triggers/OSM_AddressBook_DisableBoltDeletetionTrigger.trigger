trigger OSM_AddressBook_DisableBoltDeletetionTrigger on ccrz__E_AccountAddressBook__c (before delete) 
{
    Map<ID, ccrz__E_ContactAddr__c> contactAddressMap = new Map<ID, ccrz__E_ContactAddr__c>([Select ID, Bolt_Site__c, Bolt_Active__c from ccrz__E_ContactAddr__c]);
    
    if( Trigger.isDelete )
    {  
        if(Trigger.isBefore)
        {
            for(ccrz__E_AccountAddressBook__c accountAddressBook : Trigger.old)
            {
                if(null != accountAddressBook.ccrz__E_ContactAddress__c)
                {
                    if(null != contactAddressMap.get(accountAddressBook.ccrz__E_ContactAddress__c))
                    {
                        ccrz__E_ContactAddr__c contactAddress = contactAddressMap.get(accountAddressBook.ccrz__E_ContactAddress__c);
                        
                        if(contactAddress.Bolt_Site__c || contactAddress.Bolt_Active__c)
                        {
                            accountAddressBook.addError('ERROR : You are not allowed to delete Address Books with Bolt Contact Address records');   
                        } 
                    }
                }
            }
        }
    }
}