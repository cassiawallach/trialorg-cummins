@isTest
public class dbu_contactAddress_Test {
    @testsetup static void setuptestdata(){
        ccrz__E_ContactAddr__c shipadd	=	dbu_FactoryDataTest.createContactAddress('12/plot 3', 'barrio estate', 'TX', '4535343', 'United States', 'Texas');
        insert shipadd;
    }
    
    @isTest public static void insertCCContactAddress(){
        ccrz__E_ContactAddr__c shipad = [SELECT Id, Name, ccrz__FirstName__c, ccrz__MiddleName__c,
                                         ccrz__LastName__c, ccrz__AddressFirstline__c, 
                                         ccrz__AddressSecondline__c,ccrz__AddressThirdline__c,
                                         ccrz__City__c,ccrz__Country__c, ccrz__State__c,
                                         ccrz__PostalCode__c, ccrz__HomePhone__c FROM ccrz__E_ContactAddr__c where ccrz__AddressFirstline__c = '12/plot 3'];
        dbu_contactAddress.getContactAddress();
    }
    
}