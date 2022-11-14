public class dbu_CCApiOrderItemsResponseWrapper {
    
    @AuraEnabled public String sfdcName;
    @AuraEnabled public String sfid;
    @AuraEnabled public String SKU;//Added CECI-958
    @AuraEnabled public String OrderItems;
    @AuraEnabled public String parentId;
    @AuraEnabled public String numberOfReviews;
    @AuraEnabled public String URI;
    @AuraEnabled public decimal quantityperUnit;
    @AuraEnabled public Boolean nonReturnable;
    @AuraEnabled public Boolean genuinePart;
    @AuraEnabled public Boolean dbuPickUpOnly;
    @AuraEnabled public Boolean dbuCrateEngine;
    @AuraEnabled public Boolean hasCoreCharge;
    @AuraEnabled public Boolean dbuHasCoreChild;
    @AuraEnabled public List<dbu_ProductMediaWrapper> EProductMediasS;
    @AuraEnabled public Boolean isCoreProduct = false;
    @AuraEnabled public String promotionTag;//Added by Devaraj promotionTag CECI-957
    
}