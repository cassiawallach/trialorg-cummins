global with sharing class OSM_SW_cc_hk_TaxCalculation extends ccrz.cc_hk_TaxCalculation {
 
    /*global override boolean skipTaxCalculation(Map<String, Object> inputData)
    {
          ccrz.ccLog.log('*******************INSIDE OSM_SW_cc_hk_TaxCalculation skipTaxCalculation******************** ');
        return super.skipTaxCalculation(inputData);
    }
  */
    /**
     * The getTaxAmount method will only be executed if skipTaxCalculation method evaluates to false.
     * The skipTaxCalculation method returns the value of cc_api_User.getCurrentUser.Contact.Account.TaxExemptAccount__c.
     */
    global override Decimal getTaxAmount(Map<String, Object> inputData) {
 
         System.debug('inputData : '+inputData.get(ccrz.cc_hk_TaxCalculation.PARAM_SHIPADDR));
        ccrz.cc_bean_MockContactAddress addressbeenobj = new ccrz.cc_bean_MockContactAddress();
        addressbeenobj = (ccrz.cc_bean_MockContactAddress)inputData.get(ccrz.cc_hk_TaxCalculation.PARAM_SHIPADDR);
        
        
        OSM_SW_Addresses objAddress = new OSM_SW_Addresses();
        objAddress.shippingAddress = new OSM_SW_Addresses.Address();
        objAddress.shippingAddress.address1 = addressbeenobj.address1;
        objAddress.shippingAddress.address2 = addressbeenobj.address2;
        objAddress.shippingAddress.city = addressbeenobj.city;
        if(addressbeenobj.stateCode != null)
            objAddress.shippingAddress.state = addressbeenobj.stateCode;
        else
            objAddress.shippingAddress.state = addressbeenobj.state;
        objAddress.shippingAddress.country = addressbeenobj.country;
        objAddress.shippingAddress.postalCode = addressbeenobj.postalCode;
        
        
        objAddress.billingAddress = new OSM_SW_Addresses.Address();
        objAddress.billingAddress.address1 = addressbeenobj.address1;
        objAddress.billingAddress.address2 = addressbeenobj.address2;
        objAddress.billingAddress.city = addressbeenobj.city;
        if(addressbeenobj.stateCode != null)
            objAddress.billingAddress.state = addressbeenobj.stateCode;
        else
            objAddress.billingAddress.state = addressbeenobj.state;
        objAddress.billingAddress.country = addressbeenobj.country;
        objAddress.billingAddress.postalCode = addressbeenobj.postalCode;
        
        Id cartId = (Id) inputData.get(ccrz.cc_hk_TaxCalculation.PARAM_CARTID);
        System.debug('Cart ID: ' + cartId);
        ccrz.ccLog.log('*******************INSIDE OSM_SW_cc_hk_TaxCalculation SERVICES******************** ');
        ccrz.ccLog.log('*******************CALLING VERTEX SERVICES******************** ');
        return OSM_SW_VertexActions.getVertexQuoteTax(cartId, objAddress);
        
    }
 
}