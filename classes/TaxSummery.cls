public class TaxSummery{
        @AuraEnabled
        public String TaxType{get;set;}
        @AuraEnabled
        public Decimal calculatedTax{get;set;}
        @AuraEnabled
        public String taxPercentage{get;set;}
        @AuraEnabled
        public String countryCurrency{get;set;}
    }