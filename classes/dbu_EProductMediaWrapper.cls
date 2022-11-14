public with sharing class dbu_EProductMediaWrapper {
    public dbu_EProductMediaWrapper(){}
		@AuraEnabled public String sfdcCurrencyISOCode;
		@AuraEnabled public String URI;
		@AuraEnabled public Date startDate;
		@AuraEnabled public Decimal sequence;
		@AuraEnabled public String productMediaSource;
		@AuraEnabled public String mediaType;
		@AuraEnabled public String locale;
		@AuraEnabled public Date endDate;
		@AuraEnabled public Boolean enabled;
		@AuraEnabled public String sfdcName;
		@AuraEnabled public String sfid;
		@AuraEnabled public String product;
        @AuraEnabled public Boolean isMedia; //----Added by Mukesh---//---24-12-2020
        @AuraEnabled public String videoImage;
}