public class dbu_CCAPIResponseWrapper 
{
    public dbu_CCAPIResponseWrapper(){}
	@AuraEnabled public String shortDesc;
    @AuraEnabled public String longDesc;
	@AuraEnabled public String sfdcCurrencyISOCode;
	@AuraEnabled public String inventoryType;
	@AuraEnabled public Boolean taxable;
	@AuraEnabled public Integer productCount;
	@AuraEnabled public Double quantityperunit;
	@AuraEnabled public Double averageRating;
	@AuraEnabled public Date endDate;
	@AuraEnabled public String secondaryAttr;
	@AuraEnabled public String primaryAttr;
	@AuraEnabled public String unitOfMeasure;
	@AuraEnabled public Date startDate;
	@AuraEnabled public String productType;
	@AuraEnabled public String productStatus;
	@AuraEnabled public String storefront;
	@AuraEnabled public String SKU;
	@AuraEnabled public String ownerId;
	@AuraEnabled public String sfdcName;
	@AuraEnabled public String sfid;
    @AuraEnabled public Integer totalRating;
    @AuraEnabled public String seoKeyword;
    @AuraEnabled public Decimal numberOfReviews	;
    @AuraEnabled public Boolean productTypeKit	;
    @AuraEnabled public Boolean showDesc	;
    @AuraEnabled public Boolean inventoryExists	;
    @AuraEnabled public Boolean availableToShip;
    @AuraEnabled public Boolean nonReturnable;
	@AuraEnabled public Boolean pickUpOnly;
    @AuraEnabled public Boolean crateEngine;
    @AuraEnabled public String productCode;

    @AuraEnabled public String promotionCategory;
    @AuraEnabled public Integer discountPercentage;

   // @Auraenabled public Boolean addedToWishlistCheckbox;
   // Add For Price 
   @AuraEnabled public double price;
   @AuraEnabled public Boolean hasCoreCharge;//11 Nov 2020
   @AuraEnabled public Boolean hasCoreChild;// 8 Aug 2022  ADDED CECI-839
   @AuraEnabled public Decimal coreCharge;//11 Nov 2020
   @AuraEnabled public double originalPrice;//11 Nov 2020
   @AuraEnabled public double totalPrice;//11 Nov 2020


   @AuraEnabled public List<dbu_ProductInventoryItemWrapper> productInventoryItemsS;
   @AuraEnabled public List<dbu_EProductMediaWrapper> EProductMediasS;
    
   @AuraEnabled public boolean stockstatus;// Added by DKS 29th Jan 2021 for In Stock and Out Stock on UI 
   @AuraEnabled public double inventoryQuantity;// Added by DKS 29th Jan 2021 for In Stock and Out Stock on UI
}