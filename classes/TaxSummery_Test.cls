@isTest
public class TaxSummery_Test {
	
    @isTest static void testmethod1(){
        TaxSummery each = new TaxSummery();
        each.calculatedTax = 4;
        each.countryCurrency = 'USD';
        each.taxPercentage = '45';
        each.TaxType = 'GST';
    }
}