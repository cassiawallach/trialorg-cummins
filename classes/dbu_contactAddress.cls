public with sharing class dbu_contactAddress {
    @AuraEnabled(cacheable=true)
    public static List<ccrz__E_ContactAddr__c> getContactAddress(){
        return [SELECT Id, Name, ccrz__FirstName__c, ccrz__MiddleName__c,
                ccrz__LastName__c, ccrz__AddressFirstline__c, 
                ccrz__AddressSecondline__c,ccrz__AddressThirdline__c,
                ccrz__City__c,ccrz__Country__c, ccrz__State__c,
                ccrz__PostalCode__c, ccrz__HomePhone__c FROM ccrz__E_ContactAddr__c];
                
    }

}