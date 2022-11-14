public class dbu_CCApiCartRelatedResponseWrapper {  
    public dbu_CCApiCartRelatedResponseWrapper(){
        
    }
	@AuraEnabled public String SKU;
	@AuraEnabled public String sfdcName;
	@AuraEnabled public String sfid;
    @AuraEnabled public String URI;
    @AuraEnabled public boolean isProductAvailable;
    @AuraEnabled public boolean dbuCrateEngine;
    @AuraEnabled public String Brandname;//Added-CECI-958
    @AuraEnabled public String Categoryname;//Added-CECI-958
    
    //Added by Mounika.T to populate custom fields on Cart page
    @AuraEnabled public Boolean availableToShip;
    @AuraEnabled public Boolean nonReturnable;
	@AuraEnabled public Boolean pickUpOnly;
    //Added by Mounika.T to populate custom fields on Cart page
    @AuraEnabled public Decimal qtyAvailable;//Added by Shriram to populate quantity only on the cart page
    @AuraEnabled public Boolean isCoreProduct;//Added by Shriram to identify core product
    @AuraEnabled public String FullPartNumber;//Added by Shriram dbu_FullPartNumber__c
    @AuraEnabled public String partNumber;//Added by Shriram dbu_FullPartNumber__c
    @AuraEnabled public String productCode;//Added by Shriram productCode
    @AuraEnabled public String promotionTag;//Added by Devaraj promotionTag CECI-960
    @AuraEnabled public Integer discountPercentage;//Added by Devaraj promotionTag CECI-960
    @AuraEnabled public Double originalPrice;//Added by Devaraj promotionTag CECI-960
}