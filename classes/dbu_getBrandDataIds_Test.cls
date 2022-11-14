@isTest
public class dbu_getBrandDataIds_Test {
	
    @isTest
    static void testmethod1(){
        
        Brands__c newbrand = new Brands__c();
        newbrand.CurrencyIsoCode = 'USD';
        newbrand.Name = 'Cummins';
        insert newbrand;
        Test.startTest();
        dbu_getBrandDataIds.getBrandId('Cummins');
        Test.stopTest();
    }
}