public class dbu_CCCartApiResponseWrapper {
    public dbu_CCCartApiResponseWrapper(){}
    @AuraEnabled public ccrz__E_Cart__c cartDetails;
    @AuraEnabled public List<dbu_CartItemWrapper> lstCartItem;
    @AuraEnabled public Decimal subtotalAmount;
    @AuraEnabled public Decimal totalAmount;
    @AuraEnabled public Decimal taxSubTotalAmount;
    @AuraEnabled public Decimal totalQuantity;
    @AuraEnabled public Decimal taxAmount;
    @Auraenabled public decimal totalCartDiscount;
    @Auraenabled public decimal originalCartAmt;
    @AuraEnabled public Decimal totalGiftCardAmount; // Promotion Changes
    @AuraEnabled public Boolean isPartialAvailability;
    
    // Shipping Amount
    @Auraenabled public decimal shippingAmount;
    @Auraenabled public decimal totalShippingAmount;
    @AuraEnabled public decimal costShippedProduct; //Saneep - 9th Nov
	//@Auraenabled public List<dbu_PicklistOptions> options;
    
    /*Here are some Non Writable field on the cc cart object So to hold that value I am creating other field instead*/
    //cartDetails.ccrz__SubtotalAmount__c = (String)outputCartList[0].get('subtotalAmount');
    //cartDetails.ccrz__TotalAmount__c = (String)outputCartList[0].get('totalAmount');
    //cartDetails.ccrz__TaxSubTotalAmount__c = (String)outputCartList[0].get('taxSubTotalAmount');
    //cartDetails.ccrz__TotalQuantity__c = (String)outputCartList[0].get('totalQuantity');
}