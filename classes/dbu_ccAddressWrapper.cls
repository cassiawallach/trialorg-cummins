public class dbu_ccAddressWrapper {
    public dbu_ccAddressWrapper(){}
   @AuraEnabled public List<dbu_ShippingCCAddressWrapper> shippingWrapper;
   @AuraEnabled public List<dbu_billingCCAddressWrapper> billingWrapper;
}