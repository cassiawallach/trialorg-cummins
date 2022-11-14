public class dbu_productDetailsWrapper  
{
    public dbu_productDetailsWrapper(){}
    
    @AuraEnabled public integer productCount;
    @AuraEnabled public String sfId;
	@AuraEnabled public String productName;
    @AuraEnabled public String SKU;
    @AuraEnabled public String storefront;
    @AuraEnabled public double price;
	@AuraEnabled public double originalPrice;
    @AuraEnabled public decimal discountPercentage;
	@AuraEnabled public boolean hasCoreCharge;
	@AuraEnabled public boolean hasCoreChild;
    @AuraEnabled public Boolean crateEngine;
	@AuraEnabled public decimal coreCharge;
    @AuraEnabled public boolean inventoryStatus;
    @AuraEnabled public String productImageURI;
    @AuraEnabled public String promotionImageURI;
    @AuraEnabled public String priceListName;
    @AuraEnabled public decimal sequence;
    @AuraEnabled public String brandname;//Added CECI-958
    @AuraEnabled public String categoryname;//Added CECI-958

    @AuraEnabled public boolean stockstatus; 
    @AuraEnabled public double inventoryQuantity;

	@AuraEnabled public Integer shipmentWeight;
    @AuraEnabled public Double shipmentHeight;
    @AuraEnabled public Double shipmentWidth;
    @AuraEnabled public Double shipmentLength;
    @AuraEnabled public Double productOverview;

    @AuraEnabled public string saleTag;
    @AuraEnabled public String primaryAttr;
    @AuraEnabled public String secondaryAttr;
	@AuraEnabled public String TertiaryAttr;

    @AuraEnabled public Boolean featuredProduct;
    @AuraEnabled public String partNumber;
    @AuraEnabled public String fullPartNumber;
    @AuraEnabled public Boolean genuinePart;
    @AuraEnabled public Double productWeight;
    @AuraEnabled public String SEODescription;
    @AuraEnabled public String SEOKeywords;
    @AuraEnabled public String SEOTitle;
    @AuraEnabled public String shortDescriptionRT;
    @AuraEnabled public String longDescriptionRT;
    @AuraEnabled public Boolean taxable;
    @AuraEnabled public Boolean mostPopularPart;

	
    @AuraEnabled public String seoKeyword;
    @AuraEnabled public Boolean availableToShip;
    @AuraEnabled public Boolean nonReturnable;
	@AuraEnabled public Boolean pickUpOnly;
    @AuraEnabled public String productCode;
    
    @AuraEnabled public List<dbu_ProductInventoryItemWrapper> productInventoryItemsS;
    @AuraEnabled public List<dbu_EProductMediaWrapper> EProductMediasS;

    
}