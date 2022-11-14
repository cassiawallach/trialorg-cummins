public class dbu_CCAPISearchResponseWrapper {

    @AuraEnabled public String productType;
	@AuraEnabled public String productStatus;
	@AuraEnabled public String storefront;
	@AuraEnabled public String SKU;
	@AuraEnabled public String sfdcName;
	@AuraEnabled public String sfid;
    @AuraEnabled public list<string> ProductCategory;
    @AuraEnabled public list<string> ProductBrand;
	@AuraEnabled public Double averageRating;
	@AuraEnabled public Boolean	inventoryExists;
	@AuraEnabled public double price;
    @AuraEnabled public string shortDesc;
    @AuraEnabled public string invstatus;
    @AuraEnabled public String URI;
    //@AuraEnabled public String formatedprice; 
	@AuraEnabled public String promotionTag;
    @AuraEnabled public double coreCharge;
    @AuraEnabled public Boolean hasCoreCharge;
	@AuraEnabled public double originalPrice;
	@AuraEnabled public Integer discountPercentage;
    @AuraEnabled public List<dbu_EProductMediaWrapper> EProductMediasS;
	@AuraEnabled public List<dbu_ProductInventoryItemWrapper> productInventoryItemsS;
    
}