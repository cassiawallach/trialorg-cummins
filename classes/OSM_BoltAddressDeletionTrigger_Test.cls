@isTest
public class OSM_BoltAddressDeletionTrigger_Test 
{
    static testMethod void testMethod1()
    {
        try
        {
            ccrz__E_ContactAddr__c contactAddress = new ccrz__E_ContactAddr__c();
            contactAddress.ccrz__AddressFirstline__c = 'Test Address Line 1';
            contactAddress.ccrz__City__c = 'Columbus';
            contactAddress.Bolt_Site__c = true;
            
            insert contactAddress;
            
            ccrz__E_AccountAddressBook__c addressBook = new ccrz__E_AccountAddressBook__c();
            addressBook.Name = 'TestName'; 
            addressBook.ccrz__E_ContactAddress__c = contactAddress.ID;
            
            insert addressBook;
            
            // now to call the delete
            delete addressBook;
            
            // now to call the delete
            delete contactAddress;
            
        }
        catch(Exception e)
        {
            System.debug('Exception thrown properly');
        }
        
    }
    
    static testMethod void testMethod2()
    {
        try
        {
            ccrz__E_ContactAddr__c contactAddress = new ccrz__E_ContactAddr__c();
            contactAddress.ccrz__AddressFirstline__c = '1460 N National Rd';
            contactAddress.ccrz__City__c = 'Columbus';
            contactAddress.Bolt_Site__c = true;
            
            insert contactAddress;
            
            // contactAddress.Bolt_Active__c = true;
            //update contactAddress;
            delete contactAddress;
        }
        catch(Exception e)
        {
            System.debug('Exception thrown properly');
        }
        
    }
    
}