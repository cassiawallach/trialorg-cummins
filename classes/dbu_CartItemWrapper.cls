public class dbu_CartItemWrapper {
    public dbu_CartItemWrapper(){
        
    }
    /* These will be remove after all useing cc cart Item object insted of wrapper
	@AuraEnabled public String cart;//=a1y19000001ArDOAA0, 
    @AuraEnabled public Decimal price;//=199.00, 
    @AuraEnabled public String product;//=a2w190000019UwrAAE, 
    @AuraEnabled public Decimal quantity;//=1, 
    @AuraEnabled public String sfdcCurrencyISOCode;//=USD,
    @AuraEnabled public String sfdcName;//=00000124, 
    @AuraEnabled public String sfid;//=a1x19000000VfZ0AAK*/
    /*till here the code will be commented*/
    @AuraEnabled public ccrz__E_CartItem__c cartItem;
    @AuraEnabled public String ItemAvailabilityMessage;
    @AuraEnabled public Decimal ItemTotal;
    @AuraEnabled public dbu_CCApiCartRelatedResponseWrapper cartItemProductDetailWrapper;
    @AuraEnabled public Decimal qtyAvailable;
    @AuraEnabled public Decimal qtyAvailableForPartialInStock;

    /*Below are the field of cc cartItem which we are getting from the cc cart API*/
    /**
     * ------------------------outputCartItems with the cc cartItem mapping----------------
            sfidValue ====	a1x1F000000gyfTQAQ    				Id
            sfdcNameValue ====	00000165						Name
            cartValue ====	a1y1F0000011r2yQAA					ccrz__Cart__c
            productValue ====	a2w1F000000KmrlQAC				ccrz__Product__c
            quantityValue ====	10(Integer)								ccrz__Quantity__c	
            primaryAttrValue ====	a1r1F000000ofC8QAI			ccrz__PrimaryAttr__c
            priceValue ====	145.06(Decimal)									ccrz__Price__c
            productTypeValue ====	Product         			ccrz__ProductType__c
            storeIDValue ====	CSSNAStore						ccrz__StoreID__c
            pricingTypeValue ====	external					ccrz__PricingType__c
            selectedAttrValue ====	["a1r1F000000ofC8QAI"]
            itemTotalValue ====	1450.60							ccrz__ItemTotal__c
            cartItemTypeValue ====	Minor						ccrz__cartItemType__c
            subAmountValue ====	1450.60							ccrz__SubAmount__c
            unitOfMeasureValue ====	Each						ccrz__UnitOfMeasure__c
            parentCartItemValue ====	a1x1F000000gydwQAA		ccrz__ParentCartItem__c
            itemStatusValue ====	Available					ccrz__ItemStatus__c	
            isSubscriptionSelectedValue ====	false			ccrz__Is_Subscription_Selected__c
            originalQuantityValue ====	10.00					ccrz__OriginalQuantity__c
            originalItemPriceValue ====	145.06					ccrz__OriginalQuantity__c
            requestDateValue ====	2020-08-25 00:00:00			ccrz__RequestDate__c
            primaryAttrRValue ====	{sfid=a1r1F000000ofC8QAI}
            cartRValue ====	{sfdcName=00000039, sfid=a1y1F0000011r2yQAA}
                 * 
                **/
}