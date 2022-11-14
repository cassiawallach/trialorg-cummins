public with sharing class dbu_ProductInventoryItemWrapper {
    public dbu_ProductInventoryItemWrapper(){}
		@AuraEnabled public String sfdcCurrencyISOCode;
		@AuraEnabled public String status;
		@AuraEnabled public Decimal qtyAvailable;
		@AuraEnabled public String sfdcName;
		@AuraEnabled public String sfid;
		@AuraEnabled public String productItem;
    	@AuraEnabled public String availabilityMessage;
    	@AuraEnabled public Boolean notifyStock;
    	@AuraEnabled public Boolean lowStock;
    
	}