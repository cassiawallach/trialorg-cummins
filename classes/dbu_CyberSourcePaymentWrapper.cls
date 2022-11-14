global class dbu_CyberSourcePaymentWrapper {

    @AuraEnabled public String accessKey { get; set; }
    @AuraEnabled public String signedData { get; set; }
    @AuraEnabled public String signedItems { get; set; }
    @AuraEnabled public String profileId { get; set; }
    @AuraEnabled public String signedFields { get; set; }
    @AuraEnabled public String referenceNumber { get; set; }
    @AuraEnabled public String currencyCode { get; set; }
    @AuraEnabled public String amount { get; set; }
    @AuraEnabled public String utcDate { get; set; }
    @AuraEnabled public String transactionType { get; set; }
    @AuraEnabled public String transactionId { get; set; }
    @AuraEnabled public String locale { get; set; }
    @AuraEnabled public String unsignedFields { get; set; }
    @AuraEnabled public String postUrl { get; set; }
    @AuraEnabled public String cartId { get; set; }
    @AuraEnabled public String invoiceId { get; set; }
    @AuraEnabled public String cartSFId { get; set; }
    @AuraEnabled public String billingAddressFirstLine { get;set;}
    @AuraEnabled public String billingAddressCity {get;set;}
    @AuraEnabled public String billingAddressStateCode {get;set;}
    @AuraEnabled public String billingAddressPostalCode {get;set;}
    @AuraEnabled public String billingAddressCountryIsoCode {get;set;}
    @AuraEnabled public String paymentMethod {get;set;}
    @AuraEnabled public boolean ignoreAvs {get;set;}
    @AuraEnabled public String email {get;set;}
    @AuraEnabled public String firstName{get;set;}
    @AuraEnabled public String lastName{get;set;}
    @AuraEnabled public String returnURL {get;set;}
}