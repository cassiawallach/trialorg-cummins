/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global virtual class cc_svc_ShippingAndHandlingFedEx implements ccrz.cc_svc_IShippingAndHandling {
    global ccrz.cc_bean_ShippingOptionsRequest shippingOptionsRequest {
        get;
        set;
    }
    global String storeID {
        get;
        set;
    }
    global cc_svc_ShippingAndHandlingFedEx() {

    }
    global cc_svc_ShippingAndHandlingFedEx(Map<String,Object> storeSettings) {

    }
    global virtual void buildAddressXML(System.XmlStreamWriter xmlWriter, String postalCode, String countryCode) {

    }
    global virtual void buildAuthAndClientXML(System.XmlStreamWriter xmlWriter) {

    }
    global virtual void buildPackageXML(System.XmlStreamWriter xmlWriter) {

    }
    global virtual void buildPreferredCurrency(System.XmlStreamWriter xmlWriter, String currencyCode) {

    }
    global virtual void buildRateRequestTypes(System.XmlStreamWriter xmlWriter, String rateRequestTypes) {

    }
    global virtual String buildRatingServiceSelectionRequestXML() {
        return null;
    }
    global virtual void buildShipmentRequestXML(System.XmlStreamWriter xmlWriter) {

    }
    global virtual void buildVersionXML(System.XmlStreamWriter xmlWriter) {

    }
    global virtual ccrz.cc_excn_ShippingAndHandlingException createErrorException(dom.XmlNode node) {
        return null;
    }
    global virtual String getResponseStatus(dom.XmlNode root) {
        return null;
    }
    global virtual ccrz.cc_bean_ShippingOptions getShippingAndHandlingRates(ccrz.cc_bean_ShippingOptionsRequest shippingRequest) {
        return null;
    }
    global virtual ccrz.cc_bean_ShippingOptions getShippingServiceAndCost(dom.Document doc) {
        return null;
    }
    global virtual ccrz.cc_bean_ShippingServicesAndCostDetails handleShippingDiscounts(ccrz.cc_bean_ShippingServicesAndCostDetails shippingServicesAndCostDetail) {
        return null;
    }
    global virtual String includeHandlingCost(String cost) {
        return null;
    }
    global virtual Boolean isResponseStatusSuccess(dom.XmlNode root) {
        return null;
    }
    global virtual Boolean isResponseStatusSuccess(String status) {
        return null;
    }
    global virtual dom.Document sendRequestAndReceiveResponse(String requestXML) {
        return null;
    }
    global virtual dom.Document sendShippingRateRequestAndReceiveResponse(String requestXML, Boolean isDevMode) {
        return null;
    }
    global virtual void setDaoObject(ccrz.cc_if_dao obj) {

    }
    global virtual void setStorefrontSettings(Map<String,Object> storeSettings) {

    }
}
